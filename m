Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF69FF8877
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 11:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10CD6B0088; Wed, 29 Apr 2026 07:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1CB6B008A; Wed, 29 Apr 2026 07:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD75B6B008C; Wed, 29 Apr 2026 07:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD57A6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:22:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 765781C00E2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:22:30 +0000 (UTC)
X-FDA: 84711355260.10.6833CC0
Received: from mail-m82105.xmail.ntesmail.com (mail-m82105.xmail.ntesmail.com [156.224.82.105])
	by imf18.hostedemail.com (Postfix) with ESMTP id 613101C0009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:22:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.105 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777461748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MmiES75UD5YneXyb0ZYHupreDQ6OdVYzNQOCQeUcRtw=;
	b=uXvS9xzLfJuwWxsORGBhBE4fC19rhWjHX0AisCvEdXfVb4USbf0DJk0J6FSPBSClBtR24m
	mhGUpVSgcMUQf+ewYNaLgiO3wdhGfR3QQrsqv3xpUiSyI3kntAkKUgbG3rtR8d8BBBl0sF
	O2LF3iHhJpiLyQ5XYx5Fcv2trXmG8BU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.105 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777461748; a=rsa-sha256;
	cv=none;
	b=DpRtljfbCdy1kpoZZbMOG2V39N5tpEygvLse8O3BFtfiXBH+oquvCn/SY9q3LKsKgbsTQN
	E8kyK3geoEA3OrJkenxrqCGKHCFndbvLbxTg7Z/c3S6p51XE4Mcj7A/R95pdZ3dInANwQr
	yb779bQiJRFsJNHHPc0xP9SkX7bUb/g=
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 198b96013;
	Wed, 29 Apr 2026 19:22:21 +0800 (GMT+08:00)
Message-ID: <25ba8fe9-30c0-4f75-a6d2-e14560613950@easystack.cn>
Date: Wed, 29 Apr 2026 19:22:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-2-zhen.ni@easystack.cn>
 <12259EA6-2095-4F79-A7C4-E89DAFE9E8D6@nvidia.com>
 <7944d24f-f29a-43b3-918b-ce25e7bae520@easystack.cn>
 <F8F8A2DA-CC65-491B-B69A-2716186D0495@nvidia.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <F8F8A2DA-CC65-491B-B69A-2716186D0495@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd8f9c7b00229kunm8f1b36071bb2f3
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSUlLVhlISkkeGEJDS08YTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Stat-Signature: xoxgf5ezqjccsyesha96w3qiki4jsyxd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 613101C0009
X-Rspam-User: 
X-HE-Tag: 1777461746-737352
X-HE-Meta: U2FsdGVkX19veKuIOJKsBxEIugB2J+/hhz4X4ltTU/62wocXlJ8hQlb5w/7g/9idn7Pc5c5yipsNwRmDHhstZGSQJinlEn2xZ7VPlXQttlc7ZmA0F28YoQ9fVrRj0z9poH/kvkyZNpdz3idesWCwB9Fxn05DyFa9uOYUA5O2alAcxBkc7zB0iNCt7q7G7Jqkrs0v/BAdnEqhMy/4PFfaJt2eRkTLl7A1SH6XtyIm5jS0w9MuHLrrgNPjtOmrasjCoOlCUIkHeWVAcb9teQBom3zEt4uswxbYz+rbk9sGK3H90qFnMG2jLxqchN2THVp19MgUyNbP56J/2aKHfb1ebbk+b86u1qKb1pvfOW/75SYx4IRTn178wHWEobPvQ/iWwy2LdCE634m0i7AYBKzmf1DRZyWYIaIhqLMEJJmhgpxGjSNQLLKvV5f/Crg00GD+DSbwLamRAa/W2VmCL01riBDv//NP7Z8v272P5uAzSuMOqiHDJ/OKBqobMYZWYpeVJeNwxrhBEHFUmPPncU07sPYNRoFCYTEUuRmRg6775XTnepYOFjK4mc7gcb+YibeSPMLnFDo3LVBYeVRXAVA2XdCI3h+iuYi6vlUKwNYQKPX2SPtHemOm4RMCvkapTKxt596LhgyZCPKc3H6hq55MnfzkzSdas60d7zvOFr+3TS3DEfrOLN3LhEscuzvN5SxsyBirgatYM4mW2knSEcOodkgpYGW/wu9bmXMc8rwyEFZzRKQfpgLcHziXn8SG3Dcd6Fz1jsfwh47Wl4pEoFnpvNUcR+hfQecew4NTBW0MxcT2+JPi9NcmK4ib4AkyW/4XokitKW6j2hX6EgFC52PPhtOkxHau2UqoicIw/B318ZBzmWI3907z0X70nPWNwfM3SBPYxJGBsZcDxyXm+ZTt5Jeqr+oxF/CtVpKT011JUeCb9O40yTPY8ABS71uKpRWMElxf4GhzCyUGsFO7PEF
 FmtQJ5eO
 sM/ozfnlL3fq/+MFnblYd3FNlAxA5EpWb/WRLjAQDy2SZqgUAf2rElhFEkQQec8z8BHgHyRF1RHrxjVXp6FHuxnIdRSupnzqQfljJv1zq2905Q9LPKeG4WMhYn3UBp/I2lkiDpRYtpF4bapS0BF6OKcpyj/UVyQg31m++fWnulJl5cVszluvNGmkYbU0mXxbCij7wGiFH07u5URkXefLhLrdwv3nXa5e3zN5ZvUGyNFWZzHT6Rdgqqio3GuVSdvBm9G7TPdnMTSKqzmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/28 21:13, Zi Yan 写道:
> On 27 Apr 2026, at 23:33, zhen.ni wrote:
> 
>> 在 2026/4/27 23:35, Zi Yan 写道:
>>> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
>>>
>>>> Add data structure for page_owner filtering functionality and create
>>>> debugfs directory for filter controls.
>>>>
>>>> This adds:
>>>> - enum page_owner_print_mode with values for full_stack and stack_handle
>>>> - struct page_owner_filter with print_mode and nid_mask fields
>>>> - Static owner_filter instance initialized with default values
>>>> - page_owner_filter debugfs directory
>>>>
>>>> The filter infrastructure will be used to add print_mode and NUMA node
>>>> filtering capabilities in subsequent commits.
>>>>
>>>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>>> ---
>>>>
>>>> Changes in v2:
>>>> - Use enum page_owner_print_mode instead of bool 'compact' for better clarity
>>>> - Use nodemask_t instead of int 'nid' to support multi-node filtering
>>>> ---
>>>>    mm/page_owner.c | 20 +++++++++++++++++++-
>>>>    1 file changed, 19 insertions(+), 1 deletion(-)
>>>
>>> The patch can be folded into Patch 2. Otherwise, these new types are not
>>> used and page_owner_filter folder is just empty.
>>>
>>
>>
>> Thanks for your review and suggestion.
>>
>> I kept the 3-patch structure mainly for clear functional separation,
>> which also makes review easier. Patch 1 adds the infrastructure,
> 
> What is the point of adding unused code in a separate patch?
> Patch 1 has no functional addition and should be part of Patch 2.
> 
>> patch 2 adds print_mode filter, and patch 3 adds NUMA filter.
>>
>> I discussed this with Andrew and he has already accepted the
>> current 3-patch structure into mm-new for testing. Since he's okay
>> with it and mentioned that bisection holes are acceptable in this
> 
> The patches are still in mm-new, not mm-stable. It is totally acceptable
> to reorganize them.
> 
>> case, I'll keep the current structure in v3.
> 
> Please refrain from posting a new version when the discussion is still
> going on.
> 
>>
>>>>
>>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>>> index 8178e0be557f..5884d883837e 100644
>>>> --- a/mm/page_owner.c
>>>> +++ b/mm/page_owner.c
>>>> @@ -54,6 +54,21 @@ struct stack_print_ctx {
>>>>    	u8 flags;
>>>>    };
>>>>
>>>> +enum page_owner_print_mode {
>>>> +	PAGE_OWNER_PRINT_FULL_STACK,
>>>> +	PAGE_OWNER_PRINT_STACK_HANDLE,
>>>> +};
>>>> +
>>>> +struct page_owner_filter {
>>>> +	enum page_owner_print_mode print_mode;
>>>> +	nodemask_t nid_mask;
>>>> +};
>>>> +
>>>> +static struct page_owner_filter owner_filter = {
>>>> +	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
>>>> +	.nid_mask = NODE_MASK_NONE,
>>>> +};
>>>> +
>>>>    static bool page_owner_enabled __initdata;
>>>>    DEFINE_STATIC_KEY_FALSE(page_owner_inited);
>>>>
>>>> @@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>>>>
>>>>    static int __init pageowner_init(void)
>>>>    {
>>>> -	struct dentry *dir;
>>>> +	struct dentry *dir, *filter_dir;
>>>>
>>>>    	if (!static_branch_unlikely(&page_owner_inited)) {
>>>>    		pr_info("page_owner is disabled\n");
>>>> @@ -981,6 +996,9 @@ static int __init pageowner_init(void)
>>>>    	}
>>>>
>>>>    	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>>>> +
>>>> +	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
>>>> +
>>>>    	dir = debugfs_create_dir("page_owner_stacks", NULL);
>>>>    	debugfs_create_file("show_stacks", 0400, dir,
>>>>    			    (void *)(STACK_PRINT_FLAG_STACK |
>>>> -- 
>>>> 2.20.1
>>>
>>>
>>> Best Regards,
>>> Yan, Zi
>>>
>>>
>> Best regards,
>> Zhen
> 
> 
> Best Regards,
> Yan, Zi
> 
> 
Regarding your suggestion to fold patch 1 into patch 2:

I understand your point that patch 1 adds unused code and creates
an empty page_owner_filter folder. While a single patch should not have 
unused variables, in a patch series it's sometimes acceptable to have 
preparatory patches that add infrastructure for subsequent patches to use.

I found many examples in the kernel where "prepare" or "preparatory" 
patches add code that is only fully utilized in later patches

If you and other reviewers strongly prefer merging patches 1 and 2 to 
follow the guidance more strictly, I can do that in v4. I'm open to this 
change if the community feels it's the better approach.


Best regards,
Zhen



