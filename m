Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AB4F3ED6D
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 04:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4CF6B0089; Sun, 12 Apr 2026 00:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5D86B008A; Sun, 12 Apr 2026 00:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EA86B0092; Sun, 12 Apr 2026 00:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 930356B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 00:39:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E98EB1A09BB
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 04:39:51 +0000 (UTC)
X-FDA: 84648650982.19.00FDC67
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20D8580008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 04:39:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OK1lYJpb;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775968790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRdR1dc5/UfNuJsTk7iiKeGwmqYxW3GpWumyMvQ9lak=;
	b=eMATxeCegxu9lV/gg8raS/jiSM/a/PzMqaxRLTZzi5Or6jKGGbc8lHQupu/xsSmV+/0oUt
	9XLW6rXcRPggNYgng6LC6yCwTyOT5Y5MRfyJ8/e7KteGekuFY7zkmo0Iga+B26pEVJztdb
	SX1IqxrCjYSBsn1L/l0Zu8hY67I7Ass=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OK1lYJpb;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775968790; a=rsa-sha256;
	cv=none;
	b=LgXoIrboyG+w/jwXCYPw6TzKx8Bgo0UzTxSizY5Q8cvO/t1N2cB7N++93DnJHnqZHy+O+8
	vlLdEp5UtTOk5H3AxrnUGeSOP5wg5S0qMW9/d2nqPmzWdddHg2tVBwE9woz9uCS2XFcfha
	lXErHxFW4QTtrLKF3YchXM3qvYce2vE=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2c156c4a9efso4673784eec.1
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775968789; x=1776573589; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kRdR1dc5/UfNuJsTk7iiKeGwmqYxW3GpWumyMvQ9lak=;
        b=OK1lYJpbSKz5h0rsx4A08G+LfW+XQldcCMLa3kpQFo6uQPvsG7swPgNuYh0NhvHBT/
         y9oWk3HRpxiJyVgh4ZuGp+Z7/aCNmmeSLriJNTRezs5LphE3JmnJhnDbhoZClGvQ1Zwb
         dbfFia6/VSAq7XSp9ccxe55E4iXwvsXS9L0JHJZrn4LWANTdDiB0ohTPYqbSwKK4amza
         YFU/8OcbyLhTFP/Z6i6n4euHl/Y2BcARWwo0MkIn6piwdLjrQpMEdfCDhS99R8q413rk
         1LOnEOr35leImufnQbYFeG9FPz8P/7891tQrfv2h7o3VJ691GGkzeOH/eMnHk/H/ZtNt
         pmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775968789; x=1776573589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRdR1dc5/UfNuJsTk7iiKeGwmqYxW3GpWumyMvQ9lak=;
        b=jh8+zJ8bK0JZNX0Onw6277S9dW0YErE9zExcA1Z3442bJg8jn+8V23e/x4xGikJVyY
         Tgru2F0pFXQ2A3r7R4Kv9b/DeIZg2eIDjZ7IAC2Bo4ZPi327rCImfsK26ahfDCeL/OyC
         opjTFh9gsWpYkyez1Fp/yEIH/NYUx7W+UAL0nh8+94VsKRbvn2RbTTo11L27xIo6fdZo
         2ntz1CP50aYN9tiV3OK1Cbn/aJNFS7K0+PndA0nKNh17JoNehY6LcesHSlC3k7tlHwaJ
         tJboGVvZl+MpR73s6GSsSnlyAznhEL02xe9d9to96cgnQ+oKqpwYMhtKNjeE7Ib/gu/6
         EIHA==
X-Forwarded-Encrypted: i=1; AJvYcCX7x4afxz2LB6zXhWCnEXIwDEEb6XjE7uEwrHQQZjNWu64NOgcZ2ww6jIqG8bxMz0bzL1Fuf09MXg==@kvack.org
X-Gm-Message-State: AOJu0YxzcoFsDfrbB4Nt+gBHJEAKztvF4DVfYcEqWTFYbXP6pKS0Usc/
	NjZULgoyyBNJWAo5weTjGCABS736H39N5quMjaGw9DoVmhGsfC8f4me+
X-Gm-Gg: AeBDiesV/phKP65okRQ5HibjRRAL7jO3OF1aPS1+CeXwo7x/zFjisdOKvBNYBt6ch/d
	49zWISsxjMnWneiI/thNsrFzrT3g1WA2c2imBSMZSdIlwR+b2/SL1g4TSeL/uI7CII2CrAT/KHK
	87C/YngHuku3r9XElwqdQ2Rog+acmQ/st0AnMDRYFv6pxiuWo+OrEirdY7OJIZNU/wlyNhdqLVr
	/JsDauajJxa45cnkr3ZbaxzguNMCY7LEKFzbXD/Et63S6cQOfB4wA6fJy69ixgQtI2p0JDnuW4r
	WqcejjQyIatl9dcGRdzPcfEzYJPoVhltlKrqRmfxF6xAzwww2sxugLQnnJ80DqlmIkljoDTQsx7
	w2hyZHCgxig3Z0XxxbMIuy85QYgrmdOVO6u3l0tybYc6L/i4/tuSgU9X2p66cH6v7G6RpkGEGBP
	YZwKDmqFctFTCaWZvVyIUEGrfXmsP9Rfs2p9de
X-Received: by 2002:a05:7022:517:b0:128:dab3:f528 with SMTP id a92af1059eb24-12c34e892c2mr5118834c88.8.1775968788704;
        Sat, 11 Apr 2026 21:39:48 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90::f8b0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm13449412eec.15.2026.04.11.21.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 21:39:48 -0700 (PDT)
Date: Sat, 11 Apr 2026 21:39:45 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zone_device: Do not touch device folio after calling
 ->folio_free()
Message-ID: <adsiEY671D8mFZao@fedora>
References: <20260410230346.4009855-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410230346.4009855-1-matthew.brost@intel.com>
X-Rspamd-Queue-Id: 20D8580008
X-Stat-Signature: wzah565otg8ia9ixwtr5zisop7hs96h9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775968789-518007
X-HE-Meta: U2FsdGVkX1/zy9O6ZAVMc8+7uDoNCMyJLwnQBLLTxWfjqDaTfh1byPYs8d6NopnyHE+dOeIdJaBpgzOhqIhg3rZVUKMcmauD9PDwPWADFNDk4pXwS4SgHeqlJ5+33FchC2DLHpgHOC0WUcXJNBp4dTAgpkGQBPcKIU6G/OQgHZ3VBz1OH63mhe5aU8zvL+1i2Nwdl9QNMMM/DthYHCCjNXOqVVjnDynn6FAnefHmhrri5fFBhbpK+u/Yy49CBOPZdCEyE8olJ/VPf6Vt63LWMWyuzwpgtTUW5070ILiipMJ35HDwh9+sMzT1h8WXvnKruPjw49SZxNbBneDcabllZ0p346ZQoH0glOC/vpmX0izn2HjmF2+bYNyHghhNbN7IAjuYZNSMflAwsAMOOsiZS38FtXVoogfcDe3kcYnzng72T53XbM1dqByuKSI/q5QUs/z9KcEtTRWdWCvh3dSPyoVSzs5S2nxH77Waqf6UdS1l1ptnQpHKmUSLgjckR1AcOhbypSuz2xUmDysPwts8nHSXxgjYCGgDRf5GlmXN+XsCdd/wxLHd/wIRoPdN5FooU/YXPLlGA4TDd2EvRBSP0T1Q55OGnlD2RcnkMybgKBVazO9c8I9ObOcRbPkmilRG0yjjB0+q1SA1s3P2f0Jy4nIhd/7BJDrwFucVSu+ERwLc9VAl1lKpXydHW5qZAGGb19DOTwuGu4m81+EiEefbEjQTs4Crw5wjn8oZ1tcw8k1qlKpkm34JCCZeexsznugaWdlGl6WIBDb3j6v3UGspgNuvLeVpBZzim/zCCpUWQ2vjP220QH60FnKtasfw9/k6M1/W3Q/R+fL3WRnDKRdfOZcuu9dKkRoIPWogE3Durch0zejQAugEeeV1UOCW74FRDoAdCvwCTC/nuWqt4bpQ8dknXW59i6vTrmIX1Nzp//WMzd+dEX7fVNEwlksNgQma0QAV5admqiW7J9HYBcp
 W44ychAk
 ANdRzrAZiXAxaejELvs80aOQpebCP1lDahpZGudzdF8XJsuOhb0SoNClqHtVle+x1o2VN/Rl5O1Cam6Rw/fATEGrkJSCzGFfukIqaSXaNi3j229EPFEBAwU7FLET6rmMCaZwEVDFOMEcILbA1AKJkJxxwOMkMxCFvzfK4B0UF9RqTvIWeYFBOh5glkz+cAKoJ6VoFjPF6JfnCNthd+axY2PGI7mmDfcaxuOl6Etb9pqQtYn7jWd0Fn9pBT2M+E6WyMKLcMx+0QRH6Q8mS/jb34PnWTIiSpx0IVPdp1mv89LvyW+XrWXGczHyv623VOyhrKPwvCb5c/KXCMYmOrUkPlJjWHyRtvLyP41TE8pHectjYHuvmxVC2SHVgPj4J9aViv9+MY/8/hbhIejah2tcbc5WV2OsaxMa5wCY+/elD9hFbC2cRoQJ2yTxRG2dBEMiN84xD5sYpuUsgmaKn2JE2ALWSPnvoCz7MvjFxnLo88hM/F9fzszFNr7fcyIi386Shhyj00/Mak2WSJg784ouqaplzXcIvpwGJXLORzHO7yFtyqRw+e8W49sHHzZfN6ncbsTaHuF4QtNdSOGhN2BYebK+pkGD1YONEQDzdcoVwMhFCT3Zno/dhu5XL4+hYqivj1g42UBPE810VExcKYgt5zEQAZYnikN6IWaxPB4IMaEbld2SSrHea11EQtrptDT/KorUkOzQ0wUzCOF5/7kKzWTRKw5ArsAop9bCN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 04:03:46PM -0700, Matthew Brost wrote:
> The contents of a device folio can immediately change after calling
> ->folio_free(), as the folio may be reallocated by a driver with a
> different order. Instead of touching the folio again to extract the
> pgmap, use the local stack variable when calling percpu_ref_put_many().
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>

With the cc-stable:

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

> ---
> Stack trace:
> 
> [  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
> [  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
> [  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
> [  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
> [  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
> [  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
> [  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
> [  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
> [  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
> [  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
> [  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
> [  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
> [  632.400919] PKRU: 55555554
> [  632.403605] Call Trace:
> [  632.406039]  <TASK>
> [  632.408131]  do_swap_page+0x146d/0x18c0
> [  632.411938]  ? __pte_offset_map+0x3e/0x190
> [  632.415994]  __handle_mm_fault+0x6e8/0x8d0
> [  632.420053]  handle_mm_fault+0xbf/0x250
> [  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
> [  632.428256]  do_user_addr_fault+0x168/0x690
> [  632.432399]  exc_page_fault+0x74/0x200
> [  632.436117]  asm_exc_page_fault+0x26/0x30
> [  632.440092] RIP: 0033:0x5587554ff70d
> [  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
> [  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
> [  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
> [  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
> [  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
> [  632.502547]  </TASK>
> ---
>  mm/memremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index ac7be07e3361..053842d45cb1 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>  			break;
>  		pgmap->ops->folio_free(folio);
> -		percpu_ref_put_many(&folio->pgmap->ref, nr);
> +		percpu_ref_put_many(&pgmap->ref, nr);
>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:
> -- 
> 2.34.1
> 

