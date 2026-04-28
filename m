Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF167FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38ABE6B008A; Tue, 28 Apr 2026 09:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3615B6B008C; Tue, 28 Apr 2026 09:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2779E6B0092; Tue, 28 Apr 2026 09:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16F736B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:49:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9F551B6D0F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:49:51 +0000 (UTC)
X-FDA: 84708097782.27.67B425C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE7C24000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:49:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kz0llVJQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777384189; a=rsa-sha256;
	cv=none;
	b=H7k3FG6ivFtb38bqSAhOqD6j7kyYF7PpjiPj3rVZNboIbEh5g4Xb5TV6f2oxkJSdYTmTOe
	derTbG6OnwQOJEqMgoxW1bA+J03woabovh0ScPfxXHvcqT4++IWXqyRbqGs6Qawu1aPWh3
	WTq+zOHUNs9iPX7Vt05fODveorLQ/l8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kz0llVJQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777384189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f03d73z3nlVWqYoQgDrOjHn8TKUZm990cCChGiHCynk=;
	b=zLqclIQvbLkgaotXCrq3pc6k7OBHdPpaZ1rysXJm/4Ckgbr8mMIMn5Z1NU014ChtqGHl0Z
	xRcIK2faxpVhI/nalR9HFJbrD02YmAcuT21LwkBeKFPljOx9KLOebI5FASew7FCF9nMYtp
	1XfZg1rtYrzjjtDbQ9wK4YpJ6+auumM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EA6F43B2E;
	Tue, 28 Apr 2026 13:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CDDC2BCAF;
	Tue, 28 Apr 2026 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777384188;
	bh=t30QIMEMwddaP+f8CyRmCqUIYCZU4C7eqdDikOzltg0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Kz0llVJQJ8iMvWNY+15gZD3TzXDP3x7+IxK4Hbht2eEZyBAzbR50uA+2lB7amIMkh
	 BCzKE2Q6AHuCF0xILmCYuUlNRdSyytnm+VGGWr4sP3BPqbqU/5EoP4PCFfc595/0AO
	 EUC6DN+y90P9Al682BHV4g39BZa4y88uxflaoNxUgIqiTdxhoWF7WiDHfNBDS4Ga0W
	 BInPAISl7GuovWyUVVA9L8jgybg7mXPhqArjwDJVTOex1L2qRx8+Xi8pVsyFNAtx18
	 wXUvTx2TJljJNkyVImnOV6z6CknVKqvQQd8zEIOkfx3Tg6gVpVj4YtpkwhMsnfnurK
	 5TQlxK0N4PoUQ==
Message-ID: <f5f5ac12-efe5-4f5c-b45c-f1332ecfff13@kernel.org>
Date: Tue, 28 Apr 2026 15:49:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 86baedhfc3cmgw15saz6nh76m71dwhet
X-Rspam-User: 
X-Rspamd-Queue-Id: AE7C24000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777384189-997957
X-HE-Meta: U2FsdGVkX1/3MnlsD+lKK5kiEJK4oAWotOjK7wsOO5B/XApa2lHKNJ+6B4e353c1G0Frz+CJXZrA7Bj9kY78rUha6ZVecdvzCBJwn0juY5CtRsTihNcpXv1WV8ImIY7kuogzfz1bWb2m6Vag3jB06SbzR7NOF4/WRCjv9OzCxjO8QKWrjZpUOGrmKPlm024wPMOKpnEgKaoGsL7kMTvgAEWHXraGEmPUDngS/EKltfjJPngKiEbluXzePhcyACC59kUxITMbWm/dhnTXI/Sty6QuX5lAKkH/UWI0ITAx6oL0Lx/mR8xTCa/y7J6aCnmvIRSIMqnXaM+BlBowgYc92w+EsiTR0CkATm8UUwHYoDi7Guid3+fYbaIuWxwsoV4/eT1OJ0hC3tiZwl6VPCUh6b3h1H36FSsSqIuwIXTMtMYm+YhNvRjXyPWyRA6fH34K5csNhgO6G8PwFijcFleOvGmIknODTexWXe0aOVsBY1aXN5kxtK3c3gNc5ZPRzT1ZYXuAanRkkOmseKv5ezuIUBC4zi5qvYTLJFY0t0mThpd9Ufba0neY4QsG4R6khG4DTPZIzWeVLnkFnHSOCITHGXIJygyU/AciBcC1nm8aD27TXuIjSvxYJHT51yYmuxWubRBr3SaHPOLhvPjsekkNgWqxVRNdAefyiN3MdVQthmAocJ7bffO/mpsZ1V32RZlr5cGK7cUM3WUacnddMhtJ4SmXtcVo3Og7c/OuPQsU+ZTgcE2jOPOHx9b4YA8EW41YrmVEjRSyqoS6yJvYg3ON7NZyZ5ukjRpY/wsAA0x5wrHIGB9is+/LWJ6emEt4ujZl+lVDhj+2Ygi/+w2CuerA6ujKg0PFDKLGXxyxkCA97RoYfcVqCFifptrrd1yp6HveNZdvqeLrHkBwBW4p2BfAzv44CStfIPCFPhLTWuH39+e8xEvUs2M6TTW+LiUnkU2NqSZGDutpkKb9ll8nGoD
 mfgRApBn
 Bvb8uqTVgj5vbgBaz470ffDB9Sq5gW+9DzJA0av6lDuv62BCILFGRkeLLRcPklp3rn83juVKmr9s9ROHebjJt7nGih/kR7sjCL2xqYbGh4nTife390Aw8L0V/2136tIhI1x1rSpR936GBFySSUENVjDPLYL8z2c9+2WD3m/GXHt3xtQhRG37n070Pt2x61OMLjlcycBdfnWfxPfmDWHERwHdebJTMcZz+yIs1K1KGO9sF+CneTHqmslfPgbbL+BX1fYicJ+8cgGn8efvTy9Cy6XR/oDJ6dZhYW77jXc4ntFltjWP7jRq9GJ5U+vXQ+0czuglYNh48iTBqz3OCKRq0g2VUDgyUV4dn/pu3E0iVDTKk2IacahJRvsAX7rVSziRpKEnq5rcsVuoUaxWz6uH+cUVvHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 15:31, Vineet Agarwal wrote:
> file_setup_area() currently allocates anonymous memory, fills it,
> and writes it into the backing file used for collapse testing.
> 
> Instead of copying data through write(), resize the file with
> ftruncate(), map it directly with MAP_SHARED, and initialize the
> mapped area in place.
> 
> This simplifies the setup path and avoids the need for explicit
> partial write handling.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> 
> v3 -> v4:
>   - Restore unrelated blank line removal
>   - Restore original close()/munmap() ordering
> ---
>  tools/testing/selftests/mm/khugepaged.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..6e929a484a1b 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -381,9 +381,19 @@ static void *file_setup_area(int nr_hpages)
>  	}
>  
>  	size = nr_hpages * hpage_pmd_size;
> -	p = alloc_mapping(nr_hpages);
> +	if (ftruncate(fd, size)) {
> +		perror("ftruncate()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
> +	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
> +		MAP_SHARED, fd, 0);
> +	if (p == MAP_FAILED || p != BASE_ADDR) {

p != BASE_ADDR

is sufficient as it includes p == MAP_FAILED.

> +		perror("mmap()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
>  	fill_memory(p, 0, size);
> -	write(fd, p, size);
>  	close(fd);
>  	munmap(p, size);
>  	success("OK");


Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

