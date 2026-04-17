Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A009F8E49F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 17:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324CA6B0130; Fri, 17 Apr 2026 13:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5956B0131; Fri, 17 Apr 2026 13:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAEF6B0132; Fri, 17 Apr 2026 13:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8AA6B0130
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:34:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FD8F8B1FF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:34:44 +0000 (UTC)
X-FDA: 84668747688.15.2E8B18F
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 521AB80002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:34:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="d2Pj/QgY";
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776447282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5XIMYxIzUh7BVvwy85lkjIccJ9W4yTqzAd3JI6lXw4=;
	b=RAPFYX6dF2GqthF679l1dLfRHqNgDN7XByJ2mFmpOuoAezoqkTZUnryE3d/3u9Ghrv/tE0
	dldO2DOYMDud/3GrjHrsf1va5sT0pVGqngF/z4eCxucdIEyUvoNsyXaHTsZTCIk3RIujBB
	t0/qA5rchRx9kjSBzhAY2H8a9gQIKaE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776447282; a=rsa-sha256;
	cv=pass;
	b=vKETe74tgcH/3k8VdhcJ0b0FmzUBP5636EToedQFQEIdrcqea99fJRDYyWSYGVsX4MFBrN
	ngqiJNlcUkaY/tfL631ZDsPXZFrB7zf5gxf3WGySh+AC0g9TV2Ctf0QC0MvRjCaVuxqS14
	8CqTxT3DwV6cI+nU5yFnEripooT+PTc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="d2Pj/QgY";
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1776447265; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=ZUsgQ2/6XZeJ+MRLHucC20MZ1ntcH8CVJ0QOC70zBIp30doybc76ZyB1A3PcH+XyDqAtOtFt7OSd6nOvtwjrfmtGrqu24+6blVNOw+rQ8Ugn41aJypRwszJECO9X+eximziNI6BOEUcREsloPU82itgJs3AhKVOIb/l0ZAJYCFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776447265; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=q5XIMYxIzUh7BVvwy85lkjIccJ9W4yTqzAd3JI6lXw4=; 
	b=QaF3Ont/0oAxoOhiKL41UZTojbuqvChxX3SdXjAneP57dgvSfx69PiOCsWSx6STNtpMB9ukif/QWjkI7OwU1lj9iHjd/ERsGxj55aCLdGEIjt/9ZyYiUr3MyhmvHDb7HKzAF/E1ruIu5WpvZeSMpQBqOPmZB2FLpc8n/C/2/x64=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776447265;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=q5XIMYxIzUh7BVvwy85lkjIccJ9W4yTqzAd3JI6lXw4=;
	b=d2Pj/QgYCube9fX8AO/3nShrXBy4u3ySp/U7we+OfoUkhWuk/Pl8FbIMplVE8qeK
	LXtVBNYlsf23wnPeNHsOq1AOtVZmbRw9C7dN1rFUtKqxXZ+A53iEQb/c69Yh50RK2ZB
	DqD/It1iEQeP/sOIjMBJj38an80lnletf1Vf9lzA=
Received: by mx.zoho.in with SMTPS id 1776447262025809.8838442059232;
	Fri, 17 Apr 2026 23:04:22 +0530 (IST)
Message-ID: <20d2e9f5-9b4a-477d-b3a0-5a268364d70f@zohomail.in>
Date: Fri, 17 Apr 2026 23:04:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
 <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
 <ad5yE0sgV1HJsyaC@google.com> <ad_cpqx38LtQPlX8@milan>
 <85a9f419-7f1e-41a0-9e8e-67aae7a1b0fe@zohomail.in> <aeJs4jmco7BGCNHq@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <aeJs4jmco7BGCNHq@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: f1g8567sfqygmrx4i1e5k5cctg1sj7pb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 521AB80002
X-Rspam-User: 
X-HE-Tag: 1776447281-614592
X-HE-Meta: U2FsdGVkX1/TOzoXdtifh9T6jwR0bj8uSYD4Jyw125BWC0fY+xuDTRTbSTTVHWoFv4SzV42uiMCmAEQAwhS4HLqdj6ies1+oNU4Qv2bFiuCTCI2iGZSsHFN4NASbdwbFsQpUIvEABaLWTs4XKyMv8C59x3XgBiZS+KPcoDzpJE2oeScuEoxRoWE5Xok0FmOEr0qKZQQcpwPxtG/VhfEPbttihlsZkN41W47i5E4hnGVS28DEe8UlUVOv6DB7BUhUzqcbJENxPUjed7RktMTMgVFadYR6UPkBz1B8od2caPlbESncBxLepE9fzCvl8QoKwDbn6EIlRRflrKPBl0XQlwR0L+mMjmCy3YktiW2nIzWEpSC03/NKa0ZnEZpLtAemfAX2P1XfLCuTMrGZhPy2PvB1ARKn65as0eHPxz3W1eepVveGdhEIcUH1Y937/vNaLxpPt50lDhD4LYj1grGzOjYQOFbN2OPrSyumUoKWeagjTfY6mk389nOspA8/+I4m0cwUIm1iGPrFpx1b+xuahabDNaOTa5DUJwmgcRZf+PHjyp8qX2b5ZZOQPlPiHxq7Pljd4892+5Xs8PYqy0i69azLCsDd7vTbQDh7dMTrrAc2rlhEItpUeyt+hcZqISrshgcsJqp4Uc4OG1bBqLd/usR/Mtzzv5XSmvtJk7ASJPCEz9FngwsGGWoXuiIT2DQpqajBBJcmfcH90syF6/ZexkcKod4ra3vqseIN8JxIrJeaOR5RHklikktILsKeLEZm7zG1gaRo3dM2f9KMqazDys+utffzJn4+f41sjPetlpQ2m5SWue9NFBYUPVvp/A/D2CT8+CSDXDZ/rVMpsLLnjehgWrM4jQVvAZSTQgp9CDQxQ8wnVk/RVnbaZ0CtwZ9hkjQOgz2lQHPaAWUqN3Cv3wDP8jHre/NUbBzz+iiL1Yxz1oggxjOAUcvGTFU3eJ0Mjl0QXygOAFOeGqFYhnW
 MbEvfjwD
 WUeEFxgfJuT80zTxOyK6K/gLwazaH7lx0qjmEhdEJl5MbdCncyQeiDYet5+msPYDGKoDIAI+/25euNYb+GSDUwOi+1Z/p6Llrh+D5NIl9E2xO+Ilf9DVw5WWqb7R49/CeRXfpw3XAnuAkEPDJpLw/re0OU1s8ynMCvpjSrMxFHa2OlMkeEtNt2uDN5aYfs4OOf8c2k9EEhAR+agJByCzhxF0dGhQ00HdYlZ8g2YjsxRWbJgn+WnIAVQFJCDbFygTaRalkvQtUfbZ7mUNO6hGpnxhTMwMD91xtapwR+2sbQZrSTEoDXGcVnoG4+1ldPorRwaFvokVsDk4SO5yAC6t+KuRlpfdvF95aZcsC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/04/26 22:54, Uladzislau Rezki wrote:
> I have some questions to clarify.
> 
> Why should we use min()?
> Checking vm->nr_pages, can it be 0?
> 
> Can we just do:
> 
> if (vm)
>    /* Can not use get_vm_area_size() because of realloc(). */
>    size = vm->nr_pages << PAGE_SHIFT;
> else
>    size = va_size(va);
> 
> or i am missing something?
> 
> Thanks!
> 
> --
> Uladzislau Rezki
I honestly don't know much about the usage
of this function, so wanted to be cautious.

1. We can skip the usage of min though.
2. Do need (size_t) for overflow issue

I can include this simple version with size_t,
let me know your thoughts.

