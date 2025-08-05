Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3EAC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1156B009E; Tue,  5 Aug 2025 08:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8D26B009F; Tue,  5 Aug 2025 08:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20FC6B00A0; Tue,  5 Aug 2025 08:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF57D6B009E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:31:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB51B5892B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:31:27 +0000 (UTC)
X-FDA: 83742639414.10.856603B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id A16482000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:31:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sz6r4q6z;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754397085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7ilX0mFGR4/JkHsqHcNZKxMRUw+NahHCrzFehFr1BY=;
	b=JzRhjc6jPKpbB2htzbUAA4QvcSahqSWW0oyZVPiouUn59l0HDi4/BNdWVPoGKOcFQWIwxp
	sYJEptfil3qS0ZSho+pjkkuJcUcc9bvOPieihJK3XBe/+YUB8k9TNezWK5ybiF1QMcbzfG
	PPspS3rlxkdBsoFMVA9QNBrVln8zGug=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sz6r4q6z;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754397085; a=rsa-sha256;
	cv=none;
	b=E7rkBh2ZWtXcQxnGAmf2Qr3mTuAmNdRwtkr13RpfQlgTZ0NkPVPMvXVWrQNTPyZaaAacv8
	CRcZ9yLXD/WY+vTCErJQ/DsuYwF+qSPsqxix34+R3gSmMtVPSAZucya6r6sfX3la+7EZGc
	DiAsN3peXu/W1ORzpFsjAQ2Arv7l/yI=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-459e20ec1d9so5823055e9.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754397084; x=1755001884; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U7ilX0mFGR4/JkHsqHcNZKxMRUw+NahHCrzFehFr1BY=;
        b=Sz6r4q6zxyBc3ctG8tfWmiENyznkrPCGP0whFPtsiqDQ3/HauFYtFkVDVqNLwQpE49
         GgbAgsvQB3Tnid4ylCkEb7/qfAUf+v83vaK5b2w9PCCfGYrKjb6xrmxaLnS2bMzPAPWd
         EQDvj071v9MC4smt1lVdqb/5l/tzy0oHCIR9nL7nWK073rYZqo4xl7DWrJa9S7bHyC57
         mwFBHGJnXYqx1yhg67rC6l+KYrCy/BWh8Hp03PQ01sl9wKmZcnSLdoFOoU6H3Jy80B5k
         NaL+KGQcL1VywN2nVUuOUEiDqIiKHEkJVrVB+dOicil/xJGpAeCFbH16VuL5uNe/ORAV
         mzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397084; x=1755001884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U7ilX0mFGR4/JkHsqHcNZKxMRUw+NahHCrzFehFr1BY=;
        b=mD+qYVhSs+YB048VQve7YJE0g+Ydxt74QnpiTpVmBf3Zg2hy2jcO7ctBzDRgi76zqa
         jGpzJtMFbuuXhWLOhOrMtqQSn6NqE5mWugWscbJHpCZ4nM4YdZLhTccvtBxhGbs1cHWV
         sGAD9hqwEdyxwUReb1UB5Xt5M7merLa/iXqmxIFDbw6Ws4ruoCd+V7Vqf6c7kKXB3mKx
         aqbcI1ZZGxCYB3Ka1H8MySSco29bFlRJBDDcgLGsY+Ja+sNcfq1jTMhf4hkenJ6xZPAc
         iFt/cc41pBAT5KuEkC9wIQz1X6oGTmDX2Eoj+uq7GoaSbtgHK9o+lQ6NzCTquF9lC1T7
         7GQA==
X-Forwarded-Encrypted: i=1; AJvYcCUvbMeHOx/W51XXOY0JnxXsjj3XdZxX/Hox3S8BkXFEPmiABzs95GWx4Ssj4qDtbmrKNqOFwVpfqA==@kvack.org
X-Gm-Message-State: AOJu0YwnM2zmoi/NOal3NZj1AwBcyy4iEJCf1yu6dxQFbmeUg1U4HW1e
	2/leOOHcB+mBEW1yW5JYATPI+4q9VRDeI/t7QyxBt+023YAhewTLUVzy
X-Gm-Gg: ASbGncsMUmuhY8nsHsA6m+VNA/b0D82nTv7HuppfEnVTBljDEkyTx4iviZm3umtgISJ
	LH9aIUmgtnQbh2dFJwrWZSwFtkpbimVaiIav5embOMmMT2Oxv/Nj51ELbw4a3C0wT+9yvSz4BdV
	n89l+qMGnCdrzDIuurQEwbA9GFy21R4azmTwu9igaFSfFyIKUjdv8faxu5ys8vfHJ4ccPaBhrc9
	sWEtyc1BC/jJc62dWiScTDq5WpbvBx7y4OkCwWof0T63lRDpHn4r0pWKLnz61eA3E1c1d5UjyuP
	BGM8N67hUlMZdlatnbNzZJ6tEDCfehQKcbgTaSq6TthtfxD3/UeF8kOrc9CgiVPQszop6hfGOiQ
	xlwKBVByB5P87FPJqUSHFuN64oVTzdzWEZgHX+DUfEEH8tAuaUxMg79lr3gDrONNZPZaljYM=
X-Google-Smtp-Source: AGHT+IEnzppskDltSmW5ttFeZtALCEJKNR1VGLhcZm5DmqLbGcICelSCPZQ6ElJz30cvbsgwmnqllg==
X-Received: by 2002:a05:600c:4ecd:b0:459:e048:af42 with SMTP id 5b1f17b1804b1-459e048af80mr32090645e9.24.1754397083749;
        Tue, 05 Aug 2025 05:31:23 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5844eebsm1892575e9.1.2025.08.05.05.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:31:22 -0700 (PDT)
Message-ID: <dd981fbe-bbb3-478e-8432-f30e0adb6a88@gmail.com>
Date: Tue, 5 Aug 2025 13:31:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-7-usamaarif642@gmail.com>
 <9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com>
 <5dc09930-e137-47ba-a98f-416d3319c8be@gmail.com>
 <ff285199-5f29-44b8-81df-891196eeca3d@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <ff285199-5f29-44b8-81df-891196eeca3d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A16482000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 7rm5nmtjrwcg68hrk8pk8duzmq83uj9j
X-HE-Tag: 1754397085-141086
X-HE-Meta: U2FsdGVkX1+Zt7NsyDqfijCPPd52LKTLTYr0wgT5ewL1h7vLlk91MfrNNidUQ2BP9nluIARHStsHKR4uX5SzncFesNmyLSTjrORkzoh1YeqKt9GIVbCIE/7bLoh4RRhRTwdhFUpMlYjk9i1teueWhHRvfVM0J4tdxsbxHb3jLd/xvHNgbL3hcAMWLzukZ/EVyBn9/qB2194WBzDjt6xJAA8J8KfiYWy6+nx74apgb/TUgrVKYOpSsBS8Z12zNl8PY84nh4eBd3n1e5FNNcHEOEnj+o12x7CSKioS6YV/yE8HXVDQ7Ctgq2GQvuiABNbIhyRKJ6oSm7OfGAtABcQW2yDYciUl5Cip/bKBvQ0hSCC7JjlXzY48qapHNyMJpPwKUUQNVI0XCK77ZEiQWhhdybHh+iTaY9MYDpPR9yf3ZP9PDDP9HjbbUpNRYeyV+qAY9BveFnqztM2vZMH5Elt3M8onnhSjrGPKY7eOGHb6OXMwtSLrBdronm6iupDjKILCSG8j2A13eT2aCtm90Tv4csPuEf8aF8SXnzsMSmVk6B0gxs6X+dgNy3mIzU1qmjm8Hm0hkRcghgNZRj7MMzOU3Vtyj7B4fnp7HY0T51vnl/FR9dAA+4OftzrCq3r7YF/O8XjzD+fv5MYncA/PeEhTlKCn9Lv8sSJukhkJ93P2bPcAImgyg4T6yBGpffErmTeS2WHLTHHsz6h6Dh9IQFrXx4/+lLw2D8coY3V0EVCP4OA56pHYDi6GFY6VXV6r8D20Rn5HP3Tykx9Gzsgf9Ok3TGuj7sY4xlVJr9ZI9vvNqygDmkcj+135KKL+0clCLRv2EAKH7omFYUGuI8/G6qSbkbGLgC84BVdM8n4SADQSZgNOk4mAqKqOXiUMBTuev3n/BhkDqDa6PXkOcxZbbyLjInStAWWg0NDTClXRCWyPWAA+zl4yaRP9I1wVfwo4Aa0m1OEzu7fotAbLhHIKZvc
 JqL2sSxP
 RWLtM6Xuhtms4ifpNwTbHwxP05cVCeRK79qLcg6Vu1qvSuYriQDicoSlQyzuL7Ze5Z3PfEYpNmduDJJW95EmrZU4UvacnFFS5qhmqy9dcSEdgxbWLa/zRL+ODbq8KezJYeFFm25YFQ3xEzhiD1aLDnQ9HmW7VI5wugnJR4En6XE3rW+oKsn3o6P5/yRjUC2doETcs6GWSnPsyULWpINVEcazK8zByMXeMLAwXvSwqKTQFCGKYIWqIcmjVvWNiYvRhAg5huPMn6zfKyRx5AyoQU/u8RwBWW4CL/p4lSsvgp8PznG3wV0DkX0yR2fRL+lCYvbxWUr+88dLijwZeO6oz+08vjLwU0pGY3AbyZikE22XSDm9JyRftwt8cGVstoixTSm8UYLDP5lm8dIwivOVRnkhhWwO/goiPlVRv51VzWQOA0fbhVPqkkfB3w3IvehFyd3KJF2VfGgXrZYv2gHk0FBsbOX6U3+PiAquKmS6QW1LL7aFYprrRvbJoxA1CwGncuT/Ah6g/Rf5/HzxfMjHXMLGfMgGk5K74Pp881aImT3dkGsBU+jeHFGxPW4Fdt+FeLSpRhuMx835s5Dls2yPATuQIDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/08/2025 13:29, David Hildenbrand wrote:
> On 05.08.25 14:19, Usama Arif wrote:
>>
>>
>> On 05/08/2025 11:36, David Hildenbrand wrote:
>>> On 04.08.25 17:40, Usama Arif wrote:
>>>> The test will set the global system THP setting to never, madvise
>>>> or always depending on the fixture variant and the 2M setting to
>>>> inherit before it starts (and reset to original at teardown)
>>>>
>>>> This tests if the process can:
>>>> - successfully set and get the policy to disable THPs expect for madvise.
>>>> - get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
>>>>     is madvise/always and only with MADV_COLLAPSE if the global policy is
>>>>     never.
>>>> - successfully reset the policy of the process.
>>>> - after reset, only get hugepages with:
>>>>     - MADV_COLLAPSE when policy is set to never.
>>>>     - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>>>>     - always when policy is set to "always".
>>>> - repeat the above tests in a forked process to make sure  the policy is
>>>>     carried across forks.
>>>>
>>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>>> ---
>>>
>>> [...]
>>>
>>>> +FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
>>>> +{
>>>> +    enum thp_enabled thp_policy;
>>>> +};
>>>> +
>>>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
>>>> +{
>>>> +    .thp_policy = THP_NEVER,
>>>> +};
>>>> +
>>>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
>>>> +{
>>>> +    .thp_policy = THP_MADVISE,
>>>> +};
>>>> +
>>>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
>>>> +{
>>>> +    .thp_policy = THP_ALWAYS,
>>>> +};
>>>> +
>>>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>>>> +{
>>>> +    if (!thp_available())
>>>> +        SKIP(return, "Transparent Hugepages not available\n");
>>>> +
>>>> +    self->pmdsize = read_pmd_pagesize();
>>>> +    if (!self->pmdsize)
>>>> +        SKIP(return, "Unable to read PMD size\n");
>>>
>>> Should we test here if the kernel knows PR_THP_DISABLE_EXCEPT_ADVISED, and if not, skip?
>>>
>>> Might be as simple as trying issuing two prctl, and making sure the first disabling attempt doesn't fail. If so, SKIP.
>>>
>>> Nothing else jumped at me. Can you include a test run result in the patch description?
>>>
>>
>> Instead of 2 prctls, I think doing just the below should be enough:
>>
>> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
>> index 93cedaa59854..da28bc4441ed 100644
>> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
>> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
>> @@ -236,6 +236,9 @@ FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>>          if (!self->pmdsize)
>>                  SKIP(return, "Unable to read PMD size\n");
>>   +       if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
>> +               SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
>> +
>>          thp_save_settings();
>>          thp_read_settings(&self->settings);
>>          self->settings.thp_enabled = variant->thp_policy;
> 
> Then probably best to remove the
> 
> ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL), 0);
> 
> From both test functions?
> 
> You can consider doing the same in patch #5.
> 

Yes makes sense, Thanks!

