Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815BBD1BDE7
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 22:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD366B0029; Wed,  3 Dec 2025 17:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD5E6B002B; Wed,  3 Dec 2025 17:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C876B002C; Wed,  3 Dec 2025 17:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97F536B0029
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:09:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F09F81407E2
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:09:46 +0000 (UTC)
X-FDA: 84179552772.20.339B61C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 413FE180012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:09:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnSUynhi;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764799785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0FMOQMPWOaFaX3J0R5kGgnPh7DvIQSjQYIcXRky+Nc=;
	b=XY/TK6irEVEEpDpPZcTkm82sFdVql1Ehj+MFRnzETJSvh/zfzH5EkrMe2XWhSY6f91DFAd
	bW1HAOve7MKOPQZ/RjR4S1FhYLZEgTltwu7oKuyz123rlGySnfg/8RSaRsWC+0wNTIdF42
	JiKMz8fipBrpv+a9e2GuJzxrNA8+a1M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnSUynhi;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764799785; a=rsa-sha256;
	cv=none;
	b=Dv36uqt4REPh+xEWfbdpmx+IScODAUVgpu008NGfzZ3VUacQkwmFXCuWhSumkDlqAFwBIt
	+XzAhqCibGjWhJpIZDjvDIcp+/3l6Y6ZHvzFSu6FCXD2MiNC8jsdZTpVHAHLPj2pVqzE/v
	HlEYIi9InrFI1cSxpIDhIdgTQYMfjsw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9117B60126;
	Wed,  3 Dec 2025 22:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC6BC4CEF5;
	Wed,  3 Dec 2025 22:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764799783;
	bh=qplw2NsSDVoMG0RmGsxE0liWEOV24X9E6jdz5lTHSqs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=hnSUynhiHzos6CFDDzU9qowPSxtRN4BNvQCLmdClkN111LnqBpQ8Ncx8GqhU64KaT
	 9ZPiP9/5YWT7e++u1Ombip0PtYIi/o/HbS7mEwroMYSzqDK1FrqL0ZcdxdSOXPqjkv
	 8RALgMOgTeJgdQCf2HhJwqfSxc9yfNzHSliaIklOe+OiqdjyjC5oxwsFWW4WDxOBaN
	 U0zpAOiUKc659WwskAF9NOei1WmQLUcs+6epkKQIyjwCTLtXVr3PwodL+ORu9in/qN
	 Qfuj7GhPR10jphED71eJtLlesfbPDl7W++yIshUE3MYE9218c4eehVEF03G2gCUE6U
	 KtSRxI1wC2IWQ==
Message-ID: <ab64a25a-0fd8-4e2f-81fb-7f948e0cddbc@kernel.org>
Date: Wed, 3 Dec 2025 23:09:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 06/10] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <237bcb7f3d832457322210cc7f8d1272c4ac88ef.1762464515.git.luizcap@redhat.com>
 <c80c776d-182f-4f0e-a974-b9bcbcd394be@kernel.org>
Content-Language: en-US
In-Reply-To: <c80c776d-182f-4f0e-a974-b9bcbcd394be@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 413FE180012
X-Rspamd-Server: rspam02
X-Stat-Signature: 48ym7fg8drh3ea11fxfes48rqxx9h5i3
X-Rspam-User: 
X-HE-Tag: 1764799785-161172
X-HE-Meta: U2FsdGVkX19P6lFIzCbCi14dz9+XI5Ww+SjS16exrMpHlzNHxnGr+NA3T5+63E/mkuWInJMOBWAlZmvYsPG2Uo2KZhhQBUaa94XBOv9n9sK0Mad+FiaF8jP8fHH4FcbFpSRypU3h1SR3nHtG0irR4pJvUvxobpGK8LQ+AQkHFLgQE8zU0iewTP5xYbD5K1i81XQw5fD42BbL7/RehIJGHvIa/eSnPD/NFZb488OFIv83SmvJedQMIkYaeBLMQdmtAWMoGlNxTiBs5AHFlKXx5klv0dkFiFhsxYFPPq30L2iqOzmF7HjBn1lwhMWIQHzXt/ENv/jBbMaDdYwJUuZ4Rw+aqbOOYnYJ08c7eX1g5G3SxX7s881DqXcNkkwYL92Beh1rr/HqyX9ARpwbwq1RO39Q23JcfRWSu6fH3BKgEwFHLUjjBmGUZRcKzSJLo3GqYhJHa4qSAMm283LgZd6kH+HcCMWdDTasEerfjIV8AiSqtfh1tuRuwb6MxSO0Bq+5CMc/DgGCyPVGb2St4j8oSNbH++hqv9Y3nY4/VdG6HXV50LRFi39EjmedIzDzSaR6GOCLI2yN6HK+tJyJp0F3hrGoNfAwLV75I9QeVwmdmq7FiPuuE7ZtknhuRIZabEA5u0NdKqnSF/To4asAqmEadwa/IwuWXwzpOcplxWw+Mc9XELF07uocB+jDbDgrJxts2UNePWvdDzG0tQtZyMtBvtL74oLZ90sVYY+FDIybf2HPneEHdxFnidZhwGTgu/FX86wnkSDIdXG6gpNAT1UdWA5r0cvL5MHE7DeaeztSxPzW6nfunzX/f2eIAFaLEzdQR0sAzXL1jfDLq/nFQm3JbIkGZjIOoKgQOdXlk6a8yVEt87IcAk23g5xpOs3i6qRqoLcIgtLjnvLsMf48XrdX7X9bW6QyDEkAcL+Vqi3GQTqfIyck5e+poVzY+A3OvVZikaYAeQA0pAPTaUAOD3i
 ar+PmLSL
 xLIbj8FK2mpRbhzG/SM9uflQc3g1AsUbeYZfvLyP7a3vMIj+pzzAksty3KwLPtjjYQpDLi5f9Qcipa0HnyFXSZrB7OIMSenLDmICRnoKgHR+SBz6BPj5AgqidnTQrr4qadSUlZxkOCksWLXaPbQCsbrKYW87MdmR0VV5lN/pNG6mOCj+bZer/gwzxCVrfePcb16Yrn/0O8rn388K9MTd1bJiALX0MZpArM7c1CAsedpjhZNNoa+UkAXN3QCoxwoiSuo5jYxWOamjVIZgFVU6onwnr3tRS8ut2RiRM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/17/25 18:40, David Hildenbrand (Red Hat) wrote:
> On 06.11.25 22:28, Luiz Capitulino wrote:
>> debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
>> check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
> 
> Is that code even dealing with pages? Likely we really only want to
> check whether PMD leaves are supported, independent of any pages.

I recall that some arch protect certain pmd_* helpers under 
CONFIG_TRANSPARENT_HUGEPAGE.

But it's certainly something to explore, to see if we can just get rid 
of that without causing compile-time or runtime issues.

> 
>> instead.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>    mm/debug_vm_pgtable.c | 20 ++++++++++----------
>>    1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>> index 830107b6dd08..241b36c78ac9 100644
>> --- a/mm/debug_vm_pgtable.c
>> +++ b/mm/debug_vm_pgtable.c
>> @@ -170,7 +170,7 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>>    	unsigned long val = idx, *ptr = &val;
>>    	pmd_t pmd;
>>    
>> -	if (!has_transparent_hugepage())
>> +	if (!pgtable_has_pmd_leaves())
>>    		return;
> 
> 
> All of these are currently protected by CONFIG_TRANSPARENT_HUGEPAGE, right?

IIUC, yes.


-- 
Cheers

David

