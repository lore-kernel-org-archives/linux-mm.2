Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7032D6406B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76C66B0005; Tue, 16 Dec 2025 21:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A249D6B0089; Tue, 16 Dec 2025 21:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926996B008A; Tue, 16 Dec 2025 21:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81FBC6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:03:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DA108B42D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:03:48 +0000 (UTC)
X-FDA: 84227316936.01.453BADB
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2813720013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:03:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tw1gsfsu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765937026; a=rsa-sha256;
	cv=none;
	b=uPNomGqLLkiZ0xw21rUc7zTZDp5mvuYw11dUa0ivaFonL2b/k4h87AMgNj+LUb90jjjWpH
	w4h9Wo22kj7Ma11+JIcloYIH2izRYSuTfBJDI4xi0XpP042pYy9FPhEkDMR7Sa8lb/d4Wv
	uCpeE210e0lKbQqYasOnd6bcxhcpFzA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tw1gsfsu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765937026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttWHsTmtm8XVtyIlQxLU2HxvXx4XuoxblDFFcZ20C1I=;
	b=4pBoRrSHoSe6DRbG7mU7rvVvbv8ZjdprN2GKoQ7ukDXhSn/i1eAhsEzvFmRGGfiC0JJvki
	mNVG+SRCV3uW2eqxMCQ6ljhLAGpqR5A91Wv2ezqb8C88XLEkFrUqhsdeRxwuD+nebC/dof
	OOeHfvIE5Z6NYFbWjmli23uonoPQhsc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765937021; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ttWHsTmtm8XVtyIlQxLU2HxvXx4XuoxblDFFcZ20C1I=;
	b=tw1gsfsu7DT2g+RAs2shgcWcv4HEFjJa/vGTQPvt5jYIqFh++NGfw44AbWdjZblfpd42yNP3xpgY2wRO85To0pd+ejy146F7qB58GsmktS5nyv9+9vMsCVxH/PEzHNdyGzeLgeoZAoqYiOpMhvsnxk5mWfUgoHuDgMyda0liZZo=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv1Jy1Q_1765937020 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 10:03:40 +0800
Message-ID: <324b64d3-2d12-462c-9afc-070dd100c582@linux.alibaba.com>
Date: Wed, 17 Dec 2025 10:03:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] mm: shmem: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1765833318.git.luizcap@redhat.com>
 <e2eab9e249d10ea559e1e3c9e9b224bf2822d13e.1765833318.git.luizcap@redhat.com>
 <e7514940-1330-4c4c-84f8-fb9d66fff80d@linux.alibaba.com>
 <64b1e5fd-113d-4874-9b6c-6e344bd24ed5@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <64b1e5fd-113d-4874-9b6c-6e344bd24ed5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2813720013
X-Stat-Signature: qufpjtrpkcmk4hfh4jkcg4ck4fczc6sn
X-Rspam-User: 
X-HE-Tag: 1765937024-826876
X-HE-Meta: U2FsdGVkX18kblqbCUppWnAPQ2/ez2uNhpd0+8Gl0clpA0lxUF+hl8nFowg1Ej7PyIRwAxlc74vCWeNK91qnRTX6CqMYazhZZyyKLOS7rKIduZrPyP3dB6c0rvOuLYM42bQfuET1E0JCVwvf8avTIhB3CQoH2qNIFKNK6HF5Mpe5MH65HwcqIoeVJAuiOxlEQMWn1w1Cp5REF/kZIRKznLveJR+yzpUd4NQbVXMfpi4bHMwfmXuUpy33j/W3rZcB1027L7vOg0QntOKWrL5TbrO7tCRwX1a5Kv1Y8e72Q3pTwwDCVmXU9Z33416rxgiYBd20bzn+WdhMCUaOC+AjJ7Px5cpmiVzvI0D38VnKN5r9ozR2M2lId/iIWAdBrFpwXinkeeeksSEhWTyKZ8PMS0DjN6icDwnv1x2t/VBxwsYWrBQM23V9HzUAIcA9zhVd5XrF/h3zvzLZ/KDRoNqq8Iwu1GgieR1U20ojVNWXlODkCPQqwLXYc6/JGdoM9mRaZPQeiS93FCViyF/8PttPGrbj5UVmq7ApGsHVOrAWM8VACEHLTT/UkH4gmXNUBIA7MNRu7YFZGPrwZfJO0tlM9x1E368iom21moqVWSIeEYTuIEa7ZF/dt4DFBY7irbIXCxxemHlc1ZLY36FgMy+BIItZJRqMS33hOu41sJJgXLyuDw9Z5aNL8gwh48KhJCaFSqdsTJZgTw+e50F/j2ZRKwmUudpd4SDSWdOui9txhBYQM/hU/XzseUphYfJLtKhFJu6DOInYAAtw1aalfDJSPho3hVLVUy4Y+BKgAMjSTk/bM51WQYd4RZHQ3k50aVgjjcqnedIMZjXuHSMlqwjktqf86hUz8+0U3K90yG4TZqa6GVMNjIvF9A87V2Yidi5DsXR9zAnDxISmCngTt7l/jyPQOoLKKQQfYzaWZadYxArlyCdUoroITGZgQA5IsoomGRCPlfqjCVBr33WCmIb
 ToXvR6SR
 VCPFdSF3tKgMqB/eKG00R7m5FYjV7gbZ/6eel5Gi0YTKwf0TDPQmPlRDZVEVNxo159DG0KggslxnXj+3gFFD9Afr8a8qLg20fJa67SA9xpszQeV2hfkABunL4TFzbpLOFpy7LwumKLo+YyT0h22/4Y0R0wlionOOwFPlxEemreIuPi9wjknsvz6SKvIu+Sd9EcXZK+MoC45qmuUX0Rje7B1FXz/cS+iCpGNHYcB6OZm+fulb08DO0RB14Plk4jpW8FOsknK33cl3CgBpmnyi8aqeLg2dGH2ocqXx1sIWzjZflYmuPctCqMWDg1lXXtaI7fYnpY/3RI0PBwllSW7oLOiEjtmprXylp3apdmAiquR0G4q3jZs6EgUjBOgTQFnGDqJe0xl+xf1M1Wq3xdzdIAGF19A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 21:47, Luiz Capitulino wrote:
> On 2025-12-16 02:52, Baolin Wang wrote:
>>
>>
>> On 2025/12/16 05:16, Luiz Capitulino wrote:
>>> Shmem uses has_transparent_hugepage() to check if PMD-sized pages are
>>> supported, use pgtable_has_pmd_leaves() instead.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   mm/shmem.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index b329b5302c48..ad5825667b49 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -689,7 +689,8 @@ static int shmem_parse_huge(const char *str)
>>>       else
>>>           return -EINVAL;
>>> -    if (!has_transparent_hugepage() &&
>>> +    if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>> +          pgtable_has_pmd_leaves()) &&
>>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>           return -EINVAL;
>>> @@ -4655,7 +4656,7 @@ static int shmem_parse_one(struct fs_context 
>>> *fc, struct fs_parameter *param)
>>>           ctx->huge = result.uint_32;
>>>           if (ctx->huge != SHMEM_HUGE_NEVER &&
>>>               !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>> -              has_transparent_hugepage()))
>>> +              pgtable_has_pmd_leaves()))
>>>               goto unsupported_parameter;
>>>           ctx->seen |= SHMEM_SEEN_HUGE;
>>>           break;
>>> @@ -5439,7 +5440,7 @@ void __init shmem_init(void)
>>>   #endif
>>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> -    if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>> +    if (pgtable_has_pmd_leaves() && shmem_huge > SHMEM_HUGE_DENY)
>>
>> Using pgtable_has_pmd_leaves() here is a bit confusing because the 
>> definition of pgtable_has_pmd_leaves() is: it returns true if the CPU 
>> supports PMD-sized pages and false otherwise.
>>
>> However, tmpfs and shmem already support other sizes of large folios, 
>> not just PMD-sized large folios.
>>
>> So, for me, using has_transparent_hugepage() to check would be at 
>> least clearer (even though it doesn't change the functionality).
> 
> This is more of a naming issue, correct?

Yes.

> Would adding something like thp_has_pmd_support() which expands to:
> 
>      return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && 
> pgtable_has_pmd_leaves();
> 
> solve it for you? I suggested it in my RFC, but David advised not to do it.

I agree with David. The thp_has_pmd_support() is not helpful too. What I 
mean is that the term 'pmd' shouldn't be used here. PMD-sized large 
folios aren't any more special than others.

shmem also supports mTHP, and a better approach might be what you did in 
patch 10: even if PMD-sized pages are not supported on an architecture, 
shmem can still use other sizes of mTHP.

> Also, I'm not sure if the comparison with other folio sizes apply, as
> PUD and PMD sizes are special.


