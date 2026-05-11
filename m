Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BCDCD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858A16B00BD; Mon, 11 May 2026 06:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830696B00BF; Mon, 11 May 2026 06:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E446B00C1; Mon, 11 May 2026 06:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 691956B00BD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:38:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1074540668
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:38:20 +0000 (UTC)
X-FDA: 84754789560.18.32FF0F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 622CF1A0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:38:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQ6e9yFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778495898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAFuh1H5RPPmu8UUWalvHLGgDhvGmMyx0sup2Av9VXA=;
	b=77Um9voeNeU/ttEh78NWBPjZwfnv7Kk30aIMLkvWczNxZNnrYNdsUKiuq3QqBDoJGVzkiE
	TCABT9FAY6ltRILjiU5gfxfuFCGyHqnLwlJLbG+QJdOEPU6FjqRozPsmfxKeOdbeZxjy6d
	zLg8ngFe3C66TbctFosmWrHcLdNNyX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778495898; a=rsa-sha256;
	cv=none;
	b=J+KHExHYkIswqPT6rSEy2WCGX6monX5OII615TRHyU1ANXtQk9KVJ5pAHPLxj0MnpsqNOZ
	gFlCJLh+3DRmrZ67iGVVbL69uIyFqaNcZ7XNWqO4ESdISdJCnW1sVvPUOFp5FXweNULaEZ
	DvXk+lHpWQWwdubwIBBk86tHIw+D2rk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQ6e9yFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09D0840909;
	Mon, 11 May 2026 10:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56287C2BCC9;
	Mon, 11 May 2026 10:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778495896;
	bh=/5HeHYtYR3X7G2/ltDcaDNYVkBv+5CDR/1dSY68hK6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQ6e9yFFbLBK9EIUuso90JtjHXZFN079j+U6DWcxrFgJWQ2PTwpzOgbyWXs4VFH16
	 wjjWxT61MuoHtWqV5F0O/ciED3sZNKoDUhwrP6oQ1oHkSyouJaeyBScU1D9lna8fIL
	 znfciRTpn9Ym+eEckaq67/uz0npM533hUDJe1y07jYx50kE01WnbaYAx2beT93Eco8
	 P4EKPz5MTMBB5Eg6DjsqZxaSTD+4EaQFfICdKWtEh8S2/ZKnEaXKfP2XpITvg/xY0t
	 mCmlO713v1JNcsETpFGkkeUooZ3jb+Endpu1Yd/zYugTuxsxYc+Hs5DjMQRyKY9hiS
	 ADScn2yX/660A==
Date: Mon, 11 May 2026 13:38:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: sourabhjain@linux.ibm.com, jbouron@amazon.com,
	akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com,
	linux-kernel@vger.kernel.org, dan.carpenter@linaro.org,
	rafael.j.wysocki@intel.com, piliu@redhat.com,
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com,
	changyuanl@google.com, mario.limonciello@amd.com
Subject: Re: [PATCH v2 1/3] kho: skip KHO data for context-preserving kexec
Message-ID: <agGxkHPx7W7P5AUS@kernel.org>
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
 <20260506182039.2623553-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506182039.2623553-6-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 622CF1A0004
X-Rspamd-Server: rspam04
X-Stat-Signature: iay1hbjbt5b9tcs3ehn556kuxbumm567
X-HE-Tag: 1778495898-727727
X-HE-Meta: U2FsdGVkX1985EsG4ibIO0g+9ZLVVcZtCqEGrkpm53z+rUQhrJnqTFII6H4qjT4bYYeHgYFej6mJJS6qRG4Zi650mispZ+oJMRuAlwnWCBxsehl6oZ7/0VeXPE2iI0fa0idQdNDSo82RwvYhFd4Y483Y2RjUiVU/poM5ECZsMykh2wcg5CoOKgNlmnIj9a8HEtT973Bm++q9jeKdOqBEFqHEcFvFxoI6mVO4h4lDPOXQcUuQlYEka8tBeVLAU/M+db7XUM87V1B7079W3M9kQP0kt/zhDvwEwEMfUQPHXAVM/NmDEEjbU3q4vI9f4ahEkClZu3HryFYaYNJz3WHwW2FVsKTReYelObkbNncBy1GiGDWgrdG1o0LLverA0Bl2DnbiAQ2cyFyztdAatBP65M5Hc39hzRO4vEEAbi3i9MRkd10r7C0/y+on8RiaAzi89/s1QctXYXvaQghNl9z/IM8/8bMZBOrlutaWEL5VIHGddsH4N/EAdqxERSceYK0EjsweLZoZ1dGRsjW8JlNs0r8d1agZHK2uLy5HbqV09ljTImIc8R/+qX5DwAswkTPkuQtGxCLAjvT2o4e1/sSudMstJ8IChk1oFHLynVPHkSneYvwexuKtKNOGAzvSpLXB2EGsSiRHRYATqHeq2CDuvKrOxeLLqciLNcDieO3SLpll9Lz/D5qcQssOMIQVHW/9aKRjNbU042IfujaandvTBxLUSRbT4tTSc3p6mPaAbNAuK9gMbPsCADyMVhL3J/qgKkbVvh1ow7R6abY2ntRr58FeMUPXZ8rfyieJPhLnO1bMKaooDIczm/SdC/eQ4IMo4WKs8fsVICbwE/aqJ7sRcnBL0cQufE5BABtNt7DT3/Z1Zh70Q9gyhzgz5pobkimhH7ZWTUIb//cRRBPTxUYyFmFUIWna2TheNlAoQOoQHweKuoHtR4hQWGaH1G4lnZgmEStD5fkThPf6nw36mkw
 FhtX0EvQ
 lZ15J95p/xCIGPlqjdB/9uf7YSQyI6d3aYCgWgHSjeCDPSJs0lzO0EqeRPqFZCrpSgqmE8pfXc8tHDHLEQJsXiLL9g1cYlZyFPxThNCtYik9ttB2ruXB7jtdlTFeZk0cH0hbIeAzb878Rve4PDolzzyIYoB5oiU1yTMNgAu83S8jjl9uxHGUMLV1OYjkXIIz4CFfXhCUrQyEYF69AZ+/ta8Amwy0lT8kxI0E/7DyMw6gcuDlqE4/Svmui6R4+8h0Ig55zRlJ45fAXDK/BxePH6BbStBHemzNGIzpUxLtGpIfWN8jjYQql86VYF6f2xKQyMzoUD15SCnunCicnwsxrUOlCFFk9JaIoFZhCmlw0N00Cnyjjyumqp0laFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 02:20:41PM -0400, Pasha Tatashin wrote:
> A preserve_context kexec returns to the current kernel, which means the
> 2nd kernel does not use KHO data (and their memory spaces don't
> overlap). Passing KHO data to the 2nd kernel via setup_data or
> devicetree is unnecessary.
> 
> Add a check in kho_fill_kimage() and return early if preserve_context is
> set, to avoid passing KHO state during context-preserving kexecs.
> 
> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 4fde8325c49f..2eec2a169c83 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1702,7 +1702,8 @@ int kho_fill_kimage(struct kimage *image)
>  	int err = 0;
>  	struct kexec_buf scratch;
>  
> -	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
> +	if (!kho_enable || image->type == KEXEC_TYPE_CRASH ||
> +	    image->preserve_context)
>  		return 0;

Sashiko says it's unnecessary:

https://sashiko.dev/#/patchset/20260506182039.2623553-5-pasha.tatashin@soleen.com

I tend to agree :)
  
>  	image->kho.fdt = virt_to_phys(kho_out.fdt);
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

-- 
Sincerely yours,
Mike.

