Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9C2D66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826A66B00A0; Wed, 17 Dec 2025 13:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D45D6B00A1; Wed, 17 Dec 2025 13:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC7D6B00A2; Wed, 17 Dec 2025 13:50:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 568046B00A0
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0248B60BC5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:50:25 +0000 (UTC)
X-FDA: 84229853652.16.5652DFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 896EE180002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:50:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XjGIUGT3;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765997423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EidE7jdXt0UYKwzPU9UpTjHI4QPMS/jha9Tv6skpLTs=;
	b=7pv4DKXFLTX2ajOejkIjhVeLLdFtCSNBEHEOYTueI7YcpBkABOvxOi5C9fzMo/Ana2AF+C
	fimB1MjLcVqOPVF5e4CGwKN45XK8GZiwe/wCIEhbA1jy4g9X7NcgTwlR+SS1tk28L418A3
	dkKQtAtINsJdzcjYibX/mNUxKkRvgwk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XjGIUGT3;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765997423; a=rsa-sha256;
	cv=none;
	b=Jh8rkF8CHbdoDcS7OmEVOJ94TeEpRaDMLWNDp6LWi85LT7m467G1+sTpWsT2J/Ky6Hc6ET
	pzpZcIywcMA61Ee8Ezn/RQBehnbdWxcd2Ru9NiRp+2Yld+vR7IFRIE7aRwSzbc86Niojr+
	J1eeT8OkRhZFKgq448XaR55S+foSwHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765997422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EidE7jdXt0UYKwzPU9UpTjHI4QPMS/jha9Tv6skpLTs=;
	b=XjGIUGT3b3tii75uR/6r2/OxnBUZYoljCr9jGDGz8WT9Fbi+fHYLJXRV9JDBuP+ZfFQ0UE
	2scT0hzpWbwllefMDkR4FnOb7IvExd4tzNTvXpXQtFNrITyERAMvuze/cMtUNYAq+HqLMg
	a8gleMW7c4nLHiv4Xhw4/2vgir/uThQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-oNu5GX9LNGKfV7mpg-mgOA-1; Wed, 17 Dec 2025 13:50:21 -0500
X-MC-Unique: oNu5GX9LNGKfV7mpg-mgOA-1
X-Mimecast-MFC-AGG-ID: oNu5GX9LNGKfV7mpg-mgOA_1765997421
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88a32bf024cso38599526d6.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765997421; x=1766602221;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EidE7jdXt0UYKwzPU9UpTjHI4QPMS/jha9Tv6skpLTs=;
        b=loaVrnsk8V2Y0a76gYaSJDFNka/u+jif8Z+daApYUbUpF+JfYU1G5pMCyAEDl208jD
         GinQyQW49Hp5JfTx5UZhUVrtjN6lYRNUf7s8wu5lo6HYg1w7NccZltGWbLqmlAcBZzT1
         VA01zIXUFA5ehF0+QY5gei5XJBhxC7OCfKyZHBmaAAlYhPN+J9abar36tHkk2+BxBhQX
         BKrvGvcOMGI891Vsdj4AFvZPlkJ9nbukOwXnDlTCgSGPYhbVD5Au6112FsDXqhS9mvxh
         EQ+/pGMc9sB776ZRnjhCrI1p6fKv4wYIGzDOggsxeR+0wFandAvRvQPw2qBSilnRSbs2
         pVlA==
X-Forwarded-Encrypted: i=1; AJvYcCX2iakZJIlNq6t9c6z7CN8nwLpNUJm5yuoTLsKHIo89GjqDLmZ2nfsvcGaVy6LddnxanHYWVByIKw==@kvack.org
X-Gm-Message-State: AOJu0YzCwqf/OWomZYbYsVRp64dwbyNuL5+lC58crH2A2qaiBK1VW61e
	+e5Ud26rN6YVFbi4DmwMlrgHddjP/dAWtq1GnbLwIOUkXOjz/OUmtrkJrPBt+iKKHOGlo+vMiv6
	isMuIxJe4FuLrU7bv9iVy3l1W2VGcpqmqUYyrHYOG3xgAs++w6xlN
X-Gm-Gg: AY/fxX4g1nRRSvIPu1kksgfMLjrptWgEeDR8hK8Tjwn6Zg8XvyCoawzDbQbO3LWtdo+
	9yR/mzL2dpUFq9fSBkuNaOCVv+7Rhmgt6Div+lO7otC0b71pJ1wvXUbIhdLDfzGLqCN3n0rFw4X
	XtcAwoRMFf/Dn78zDlijrDT23tgXZhjVizuTGkfGFb1bl6pG6yaKearuDT03qHTBoB0vjPIZGqJ
	zu1I0uKqGjYGdxNuAJl55V4r0I8cisDYRSFx+Ifh7YxwWUXRL4zq7jkw3WOO25dIHsuPiyRpuYt
	RxqWZ3HmYOrdiU3Y9wxh9H4j/gN9Iv8ReU8dHvpMPrbiAZ8GKLHD9DyxmCBOKDRYQWJTAyaT68H
	mGbNvl7f4yF0=
X-Received: by 2002:ad4:5ba8:0:b0:87c:b91:788f with SMTP id 6a1803df08f44-8887e42ed67mr328077866d6.16.1765997421013;
        Wed, 17 Dec 2025 10:50:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETx0DwnisTQ5EVVeGIDPDdI0MYWLK5ibI8oPBGvf27VhTZegS1FyULmKsUp5rce/dArvnPnA==
X-Received: by 2002:ad4:5ba8:0:b0:87c:b91:788f with SMTP id 6a1803df08f44-8887e42ed67mr328077486d6.16.1765997420556;
        Wed, 17 Dec 2025 10:50:20 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c5e169c8csm1563416d6.24.2025.12.17.10.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 10:50:20 -0800 (PST)
Message-ID: <4c43344e-8ecd-43ba-b8d2-e62e9e0fecb6@redhat.com>
Date: Wed, 17 Dec 2025 13:50:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] mm: shmem: use pgtable_has_pmd_leaves()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1765833318.git.luizcap@redhat.com>
 <e2eab9e249d10ea559e1e3c9e9b224bf2822d13e.1765833318.git.luizcap@redhat.com>
 <e7514940-1330-4c4c-84f8-fb9d66fff80d@linux.alibaba.com>
 <64b1e5fd-113d-4874-9b6c-6e344bd24ed5@redhat.com>
 <324b64d3-2d12-462c-9afc-070dd100c582@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <324b64d3-2d12-462c-9afc-070dd100c582@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dz9UFFo51bVxjJM4xE-2bDfYAM0GqULnXNon8nlqlAQ_1765997421
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 896EE180002
X-Stat-Signature: h3ycqasnjnnq519xrn4kttkywhqqb6s7
X-HE-Tag: 1765997423-781116
X-HE-Meta: U2FsdGVkX18Egyd8rCk6BVFP9Rqmps+IRTHFQrpwls5aiYBRvzaykj0CvVTicMsWCD+pvY3iKpqKSSGut3eA4nmapbytCh1YxCvDoX1KjcDg2NjUc+ii0aFdCHlnI/JOVi8TaXP5dhZha2so638N7LWJ40DTZlBIvWI+ml+JsTjlu/tum3xijHtHdPgv+HWpzI+GRvcR5DYfjJ2Q5ioNE0w6g6l6xFmiL50W0yZNeRzl10T2JUbRRc1xg9BxFq2FP5vAh5c/0XMrT7VFkOdV9VFYyOHQE5g8xAFspUh7MoiLV9mPFQOqINLOBr2WybRN6yoULpQvaU8NR9R3Oj7GLTgjAcStcPFjxGfXFUv77QaPVVpVc7uSTeex3zXMMazxq3sND9ISiTgdP6tNbL4fxoyC2ZybHxvW5dIs422b5v3+OLG1cKIGPpzGPFily/hyCg74TEZLO2nftHehEdFS6kI9iNCLgUH4ZW5OYYRG/6QPlZd3NZkjEVlzPl7dVOLhE4PC7cxJTTWpcPQehmKMqxD8X3yKZzPQlZtfcU2Sk9ixmeVt8f+RNHKH1cDXblQ0fF4QL7T3DemnMLYeuBInfj3F83pTATd9p107ORT+fGZX70fBqK6eCguDRhoM90AdBK+V+O6RsjbHUpTme3Sr5PHq607pMHI5nv77SPRT35Y0E39BmrnuhtW+bPRmrKeG2dhmW8MZ0TXyFwElzj1SXEJjjCt/L2DqA5RUS8Bc/5fr090jsXlLdf3BdrDCb/o4tzzkp+oAASlJTve9javBvzbl8b6bgnUqb+Vr2NBX3mAg0owAnFOOawUSbTBrXoa3eWwWzRgUNnAl0v5CMHvWgQ6RuaEoTA4VCWS5ZJ9kP6rtMHXrMjMYaaHd5ncKOKya9pXtub9mXys1dpyg68kcgaqCAQiVbD/9cyu0RRCuSUTs7k2I4yU7ZJPATz9UVf48xz2sLkN8VWQzAfYl4EZ
 5kj1aDih
 3qwHWu2kqeli3VxL4fRsSFwqldeM1c8Ccf+owgb4qrXO3HUyu9wIPWwIm28bmt3LzGn10QU8A2wqkoUoOjae2UJEmV2TA0R9GrhWdGfm6Nt3NWWJzOMVaymjtdt/S0cOuEKZ5sERfjJ7xlkgvQbY8ZqytVAAw1LGyISDCp4sRZO6qdQxamk6GsMyFN3dX0VNlgMdlU54tBXDAlYnlGtIInUp40dmAn14+fvwLhUQlA0KQjM/V73NgmFPKhXU8JHUfqz+XhepU3MHAPJ+2cs51nnrqhSsXXok0e2hGAf1Kc7Df0gXsZ/U4j/5BUossPFnrouNaruIRfyNyM0R90XhKQVPaifuk/tGecTQNe+NQEyCqLm2tlaGcjrwUgaaj/51x9w++RNq8VGqZeYXnpJ/kp1tcF9pnXoWViGY9MOcbO/a5Lqn4RXwnso8m7NdGbfD5uPi14h7inynsn6ueUm/mrvo3B1Jv2vZZkMnkTmwSOrjr4Z0Sl6cLvOFU0YTrp8wOa7dPsxL+VMyRwUlJs7ypUHOy5sBgBBzjwHCic2CuHQpaYxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-16 21:03, Baolin Wang wrote:
> 
> 
> On 2025/12/16 21:47, Luiz Capitulino wrote:
>> On 2025-12-16 02:52, Baolin Wang wrote:
>>>
>>>
>>> On 2025/12/16 05:16, Luiz Capitulino wrote:
>>>> Shmem uses has_transparent_hugepage() to check if PMD-sized pages are
>>>> supported, use pgtable_has_pmd_leaves() instead.
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>   mm/shmem.c | 7 ++++---
>>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index b329b5302c48..ad5825667b49 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -689,7 +689,8 @@ static int shmem_parse_huge(const char *str)
>>>>       else
>>>>           return -EINVAL;
>>>> -    if (!has_transparent_hugepage() &&
>>>> +    if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>> +          pgtable_has_pmd_leaves()) &&
>>>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>>           return -EINVAL;
>>>> @@ -4655,7 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>>>>           ctx->huge = result.uint_32;
>>>>           if (ctx->huge != SHMEM_HUGE_NEVER &&
>>>>               !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>> -              has_transparent_hugepage()))
>>>> +              pgtable_has_pmd_leaves()))
>>>>               goto unsupported_parameter;
>>>>           ctx->seen |= SHMEM_SEEN_HUGE;
>>>>           break;
>>>> @@ -5439,7 +5440,7 @@ void __init shmem_init(void)
>>>>   #endif
>>>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> -    if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>> +    if (pgtable_has_pmd_leaves() && shmem_huge > SHMEM_HUGE_DENY)
>>>
>>> Using pgtable_has_pmd_leaves() here is a bit confusing because the definition of pgtable_has_pmd_leaves() is: it returns true if the CPU supports PMD-sized pages and false otherwise.
>>>
>>> However, tmpfs and shmem already support other sizes of large folios, not just PMD-sized large folios.
>>>
>>> So, for me, using has_transparent_hugepage() to check would be at least clearer (even though it doesn't change the functionality).
>>
>> This is more of a naming issue, correct?
> 
> Yes.
> 
>> Would adding something like thp_has_pmd_support() which expands to:
>>
>>      return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves();
>>
>> solve it for you? I suggested it in my RFC, but David advised not to do it.
> 
> I agree with David. The thp_has_pmd_support() is not helpful too. What I mean is that the term 'pmd' shouldn't be used here. PMD-sized large folios aren't any more special than others.
> 
> shmem also supports mTHP, and a better approach might be what you did in patch 10: even if PMD-sized pages are not supported on an architecture, shmem can still use other sizes of mTHP.

Oh, I get watch you mean now. I'll have to dig a little deeper into the
shmem code but I'll give your suggestion a try. Thanks for your
feedback.

> 
>> Also, I'm not sure if the comparison with other folio sizes apply, as
>> PUD and PMD sizes are special.
> 


