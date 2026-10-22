Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092F5606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQeZti5A
Received: by kanga.kvack.org (Postfix)
	id 26BC86B08FE; Thu, 22 Oct 2026 06:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C2F6B0900; Thu, 22 Oct 2026 06:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132326B0901; Thu, 22 Oct 2026 06:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAE906B08FE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:25:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73334A81AE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:25:39 +0000 (UTC)
X-FDA: 85349880798.23.ECACBF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E10038000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:25:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQeZti5A;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792664737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDsI0V/DrB0oah071lr270oK5k2KUhctBjE7DETfs40=;
	b=3t+RULsXCaXw8XXf5NCfyoN3PL2kjoHP9BRDNLK3lR+4xp2kCq+m6sBUfkaTE2IMHZ4ET8
	23WEM6xM03PSR1PuF/hyZ5jYz/GIgPhtMWNlvLzEDC/dIOt2PgrtUgcG4I0l3ddLoHMGtI
	LjMuMiVRtbhRQgCLhVj9yE6l9m0CczU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQeZti5A;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792664737;
	b=QbUDhmOZBq76nzbYjA6WhLVvMdqzeBXtNsXCWi4fTDRRp83EAQEGQ7gyg9MTi4bpStH/ct
	Zfkqpk+W50YQppdxD5vSYnSgG5BttXCxgj80axWBiMw4cIc//4gWE/q4ZZKIZ3ghxlDklU
	EBPW8l5hulRxTwYTowtE1YZUMV7YNyc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F3DA60200;
	Thu, 22 Oct 2026 10:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BF01F000C1;
	Thu, 22 Oct 2026 10:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792664736;
	bh=NDsI0V/DrB0oah071lr270oK5k2KUhctBjE7DETfs40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iQeZti5A3LdIdAWPvUzMpxpmbMHI195SAFMfniFpmwTfM2Tdf2f2a5+3uRRnsMJco
	 21chjCodtp6w6WFflNdaWUHSjRqg96YHecPIoDkSM+OnpdRdPn4Ea89ucr+YeihBTQ
	 ZgXq0WLhbXPux6BGXVbIIWncwK702hzgm5s6kr2Qz3BTKhzx09DuWBkcb3lLKLtfBE
	 COoHsjMoWDcUV8Gs4XXuGiBSXTRbXOhdrLW4ONiWs4DMdqE2sULTv67HyUaPY8+Rhg
	 U90V0/SmTUz2sZdXd2QQ2e3PwIGLe/F3GIE/0SaWwa5uQojXaMZnode5rwkyC5EnOJ
	 thTp8OZXHHKWA==
Date: Thu, 22 Oct 2026 11:25:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 3/9] mm: Expose locked mprotect operation
Message-ID: <atnjEc2-6CuKjFzH@gremlin>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <20261021195759.119421-4-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021195759.119421-4-jolsa@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E10038000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dio4m7imrbpw5c3bydhis6p9ct9ex6qs
X-HE-Tag: 1792664737-942067
X-HE-Meta: U2FsdGVkX1+O8TXhnlGqncqIHUImw6/9QHPQXbCEN7u6BQEcWj3GEHJzqAidzH0qD3p6pxNLBbkRXyCizUof45mxMCLzneYO+raOZeDpIO/oe5/ejen4BrVMlyYRGWrwG0Q7BOHN10r3KCqzLW7Y/gOLuvT1RgG2ZwA11vjreTug679X0WU9o/8Qs5h36LNPaK2hRgBdvUoz0POE29ikCVx03rodDi6LqcJxUHqTJBc1DkJuq+Nvx9ODO4dzBP1ZfsUNdBgR9jQiWgFPpauQf8FlIl/Eb0TXcchIj3s13dkFNan4d13QERd6mM5Efb1rhGwalnh6JsRC+zYLEQLK67RLCqNW+dGdWkpJYHG6j1dUK6qvWPQl9IBMAwzulDV2QibTNoCv5Wgj3GSIqEw1J9CjVNq8Ws6D3XjJoSbqlnlqE6TyegVhlFmPH034vCEFcgAdNCRNRgoxE7vd2NpY/420Qx00YHdiPdOV2nvXsIl4ye3bWItf6GDmfjtzCnay9LDwZ0jpy6bX/RBtMS4XVf05uXuzmKu+WrjiVW3t5n2TBWIp1iKU4p7FIr6JJ8dzHKf9Fj2YZgcDFgSVjz6h88pm2JL6torgrPHUxTMN83bIitZTyihN724bZ2HNSMtI/KUO0Dzhj5EtqO+ttjcsz/YlcGFmGHfDSdCB6w+fjXlWlwuviGJ/2enLwyJa8DkpJnkm5MVPi/Yg/+NNiFzeoRLpWG2fyZF5AZ6F+LkAPOT2h1C2+lNIWUI/8uNCU1zj0PORiW0zVGnJFOELSkHvFWw29CxiPT+y34hiVeM/evFBXdzDZ4q3AVtg8QdaxxFJbPaXmlH1O3R0WPqriw5xnQ/QsCU4Bdc3liM9rLX3jRFe1wmkL70lJBCXBwUXY7fTxT7kwQRJmnhOXtF4Us8T/exwkMdPq08cCpDQRKoBxdyMfYtXh4OY5CRmSPWE1NkPER49vXjGSEVgV6yVPAq
 JVqITKFu
 L456tm7cl2hrtSWQpxesRDLmne4+O6PY1C5ZmccTM2qEX2PLNcU0A11hl+BvpZo5UCCniGTlm9bsYDv+BFmt2QBh+EcMnQOYT8QhB7JSqyJi+N1dnsSU0gsPjWebF1NW0u/RnJImgT6jfwu04VSAHFtK8zQE1NvZT1CgbTzP75E+DaF8l35JH3l9uCh99Bpm7MGhPbFwz/PmsVMvJ95mNLrF7MZcgYTquPuXNP3ple+3bRk6T/Q5CNWUTOnYFZKfMbTKrnLe7e1syzqsIm1JG734dnizuFNkeiEeTEC+ciXMp0O/ya0/ZDJQBe/1jApLl7pXD2oZBawq4DmIdPwN/PJDuzeu7RH/xY7MaeNvSPl26UD2fQVAPkjH4PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 09:57:52PM +0200, Jiri Olsa wrote:
> The bpf_user_page_exec() in following patch needs to change page
> protections while holding current->mm's mmap write lock.
>
> Exposing the do_mprotect_pkey_locked helper for that.

Err, we'll need some more justification than this for exposing internal mm
logic to the rest of the kernel please.

Note that you're already allowing any caller to bypass
CONFIG_ARCH_HAS_PKEYS here which is immediately a broken thing.

>
> Assisted-by: Codex:GPT-6
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

It's a no to this in its current form.

> ---
>  include/linux/mm.h |  3 +++
>  mm/mprotect.c      | 20 +++++++++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 63f40e615754..47e853093601 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3435,6 +3435,9 @@ extern long change_protection(struct mmu_gather *tlb,
>  extern int mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	  struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  	  unsigned long start, unsigned long end, vm_flags_t newflags);
> +/* Caller must hold current->mm's mmap write lock. */
> +int do_mprotect_pkey_locked(unsigned long start, size_t len,
> +			    unsigned long prot, int pkey);
>
>  /*
>   * doesn't attempt to fault and will return short.
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2888ee638d87..8d800830d3e1 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -868,8 +868,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  /*
>   * pkey==-1 when doing a legacy mprotect()
>   */
> -static int do_mprotect_pkey(unsigned long start, size_t len,
> -		unsigned long prot, int pkey)
> +int do_mprotect_pkey_locked(unsigned long start, size_t len,
> +			    unsigned long prot, int pkey)
>  {
>  	unsigned long nstart, end, tmp, reqprot;
>  	struct vm_area_struct *vma, *prev;
> @@ -899,8 +899,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>
>  	reqprot = prot;
>
> -	if (mmap_write_lock_killable(current->mm))
> -		return -EINTR;
> +	mmap_assert_write_locked(current->mm);
>
>  	/*
>  	 * If userspace did not allocate the pkey, do not let
> @@ -1013,10 +1012,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  		error = -ENOMEM;
>
>  out:
> -	mmap_write_unlock(current->mm);
>  	return error;
>  }
>
> +static int do_mprotect_pkey(unsigned long start, size_t len,
> +			    unsigned long prot, int pkey)
> +{
> +	int ret;
> +
> +	if (mmap_write_lock_killable(current->mm))
> +		return -EINTR;
> +	ret = do_mprotect_pkey_locked(start, len, prot, pkey);
> +	mmap_write_unlock(current->mm);
> +	return ret;
> +}
> +
>  SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
>  		unsigned long, prot)
>  {
> --
> 2.54.0
>

--
Cheers, Lorenzo

