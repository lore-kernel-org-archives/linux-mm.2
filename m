Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE7CC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC6E6B008A; Mon, 28 Sep 2026 05:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E026B0092; Mon, 28 Sep 2026 05:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3686B009B; Mon, 28 Sep 2026 05:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5F416B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:07:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 292F4C0130
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:07:27 +0000 (UTC)
X-FDA: 85262592534.23.FB4229F
Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43876140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:07:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j6ZGtaRu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz4A9u2HwDkmyVBaHthqdE81Vhdpzal2brNiQu6Y4JM=;
	b=1OHmBkiPGJPsDhxWBxUg1eXOajR8x6Ue3KMS0P6Iz3x1pxm9RO5/0ybdOr9e82mzFc/SnJ
	y5AoQ3bveGZYL2ONG0t1aPyHTI+Nstxhb054bOYHR4HiGEVnvsskRkxnNL/axHfu7mfFLF
	d9WOxViJF32+BMe5XHITMgVcthyDg5Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j6ZGtaRu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586445;
	b=dB0gfM6PponPYu8DrJUl2LqKsrv7bmmPkQpGqcc0IIhAubmTDXa1JzJNbCIGnrdgy7YYvQ
	8pXSmn+ISW8XzzxKY+PHeZJ5uU3QLogh9P0zoQXmv3lFhTvhyaSsdscM2TnmeV5AkNk0eN
	dDuYI0VKYmOnH32TO6Vjvrn7tXST0UI=
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2dca989afcso146892466b.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790586444; x=1791191244; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rz4A9u2HwDkmyVBaHthqdE81Vhdpzal2brNiQu6Y4JM=;
        b=j6ZGtaRuJMQEePjecYgDTBs55kkAZvHCBrrBXhPQRmigKyseh3sW5ttd8AWV+Qi9Xr
         yrIa2aj8IItLAogoCu7LZs2qAER61iEAGxTOJJjtRMbd13jjZZgEII1eqQsGFfgOdnqQ
         NkcwNXL/Da3O+gQGaUDPjxRiHLUlyJBU0uc4hTQWkMEoyaqzGfK14wXr8dQjlhSTBclG
         /AMmo/mbnI7TUPT9GS29aEE7lpEqms1J7PKAiES0JpC8s9zNvtmoF2FA0Lqg23/fxGtF
         ZNQo0oyzYOSd3N+Nm5UrRW6dGFP/yi0PJ6dalPm0tQLmqcVcmsbOmDWC/FFM5xGyuFnm
         fB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790586444; x=1791191244;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rz4A9u2HwDkmyVBaHthqdE81Vhdpzal2brNiQu6Y4JM=;
        b=etpBKVZi0gfkJWH8rjaAhvBGN8szwqNs8UtQg/b21p9PWkdwSkN/62kjGbNIWzv/Uh
         44DhYr3SJzTvozZzn4n/zJuxzIP53l3oNjKbE5xWzDhLl+Lv21i/AzQbnmNU2ix04dDI
         wobaMbKqukobDEGohB4P+BTLRfNPn5x/9c9K4KSoSNFNYChsiQG01gG35gXsBgR6Ci3f
         upOayoMv4weVDTdT8MWSB5CWaF1bzq1Qeu5BJnBy+Iw5jw4FnlIcPF7hXBMRMZ789HQO
         Dj759VI+63Q0ta0HXf8R6iMKkiwcqkdn1zj0Ir8ZBVlrLFzLAyL0Tc2THhdkfuTAS4e5
         Xv0g==
X-Forwarded-Encrypted: i=1; AKwUvBzzWPbEoaz71tZulS58ceR3wWuNg+PGQu2jzqG1XR5nAuPAEqeBJ6GGdcsga+j9FxcBh8oZXZgusA==@kvack.org
X-Gm-Message-State: AFuF++mZDVI+Pps/m4wElU1friWy7IPuBR0cEdrawLpvpcbckoTAU6gg
	/Ds29cpAPZnozEoQVaFTFiYp6bpIOrxQQKqvfbhnuYPQrbeXWEnwMvuA
X-Gm-Gg: AYBFou3F1mUYFndEkqakuL0J7zRg2ME3lAcU97W29W30UHPRFQ4BMUjSHeJ4ZQcaVxv
	J27QUl0zDMKnRImCtmvwrnzIDhykazuLH6BmBl0TKVeXjOygLBEFvEPu4238sxp3YWUG8tC5DOW
	hWdY45Lg0LBMTdpwGGCsbLIg1zA4hgX1YdSr/WDkLr07PSKqMS+oPtBvp4ZkdHKtjoJbiwnH9yu
	9/5OFb7Mtvy+iJgRRO9F6ogrTJygTytHVqDFbu/aQl1WhLRPswDXynMqGMqtxzmE5A9h3u9H2rT
	u7ljmepDJ0XfHf8TQBCrZ+RkPufAWIdwUpVz1tfo5eMlGzVbYk4r7gQ9VVhqKae77S3nWv6P6Eq
	+IEipkht8sVJn8qebiwfzKDoEEzzileVgVatr2Jr3Q0jYAuQrpLBBnuyOWjufwretbJkMetUISd
	BQLqlYlpaaYKsQJd8/cRt/L1eu0UrITMRO9SU=
X-Received: by 2002:a17:907:6091:b0:c16:4df6:176b with SMTP id a640c23a62f3a-c2ac23d6040mr1043044966b.20.1790586443621;
        Mon, 28 Sep 2026 02:07:23 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae757ac8dsm438371866b.25.2026.09.28.02.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 02:07:23 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 28 Sep 2026 11:07:21 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v4 0/2] mm/vmalloc: fix vmalloc_dump_obj VA lookup
Message-ID: <arouSec6y9oVau10@milan>
References: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
X-Stat-Signature: 4ruwcypbnkwe1zo88pbnrwp14wprpkru
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43876140003
X-HE-Tag: 1790586445-467709
X-HE-Meta: U2FsdGVkX19e+T5xeq8qK7RPfODcnNtqTyV6Umf3if4i3Qc8NXmvF280IyH8vBav2W09JOZkw7hb/z+16yDvxoMPq+TMETpqLFrjdC1Hcj33hd8MUMbHkA7r9txHGexWjmm7TLKSeFVR8CYGroKvP1DVvtQade1mL1psZmGUybdGzj7u/FYF9uDYSKCSrNiQ8bxo7w00F0gqxriJnbF5pR66JdrGBPSW5dyfuL+Icm8MNp7r541VRmzZC7qwokrmqAB+BytUt2jLeC22JeUVCSLPOo9hG9+m7sS9K8CptF1+gDtpu5cs9NlebDfjCy0T/HRfZsKENqkf7i/R2MkmCJhqdG93AVVt40KOSTIfnT3C4+iFM8lKqBlAamEIXEJnIdS469jdD7tdsgPbiLoDm5mjKu0TKgmIM3td0qjs6uKc3UxnCA77Mo6nd7tKCePN064JcUVFShAFVIPK1D6nbhR8zpI4O7f9SMMO/+Gpe44P+6wUT8ovVP9MMyQQ9UzJmUGSOu9h08j2kSIG6WwtjEWnfTFxBWn+2i4zZC/MmWCKp6V2BtVslNXuc0OVHNQlaFNNK80GwoYQkuk++2GUj0RNEcFlrQ82DBpKP8UbQKehkLbHSt6SwEfs3/zjzj+m3hSHoAikQrdMaTQVoh36ut934VSW34SrWRUXrf6XvNvkFuCwtX293iArYP452+IaW6LRPa9WpBGSYu4ZTKrqLfr9bOlfJSu+Om8SVOarI99lAnmLN2VEIIcyRazG6Zwklvq2QOdqobDUaSqAIdnOoDUoSh4iSbPAPadnliUBn+uwYBnmEHhLTi+YJZaDJMX6QVioqtlgL4FCglGCd5+lvHUuMj4foDThczklw6QQkV5+Bh+Y+HP24It4xobwWsb9VRWwg7EjP5+TWTGRjN7VqITl0Ix9dxJCxiEg6b3RnHWB/foXxQ+ftVdy1b7QvMzkEPp4NvSfMQgZEifwM1V
 i5n7wGvj
 QdQO5wkqPeRXFpnHEtgtVRyxZ4DRhFG4gpQAM2b4qBiiFXEmp3J7OFIkYuYy00ob306bq8KNny+6YsfU1dXRVV03hkkhuy2PM4z1gwkanN37dw13hbFfxGyJv2kK1dnjpzOFaEjUnlQUg2woCSzyof3XnCLLwWRnri+lwF4e1PXo/S8GCW3Bg33R06erhTA6ZvyDmkh+Eg4EwVe9VfQlGBXdP8SXKWMaQmctcoVsB0g5rjPnHFtEyXYu6c4j2cTvdO0QspnA7JUhq8sH2Cl+Hn+ckkRiy8Yur//9eDsId/5NC4yuKj/a1mLJed8eQwx2dqejyq1u4Hme+1aNyFvAkaa+Yck7iaK81Ra6+FaCouAbCdIK+ETD+/iPTS+xnmOEh5BYSU5/MULAyD8BW00YqnVHjON4abKSCavsQDB4svNBI264K2GenZLecQ4WMr/aRcF13aAHn98KDCoiOJz+Z1QqnJsF0VQzfa2fGgI4tNq88b0UMvuHMe2ISC3fuEM88Ssk4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 04:15:53PM +0800, Ye Liu wrote:
> vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
> allocations.
> 
>   1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
>      and outside the VA lookup range.
> 
>   2. The function searches only one vmap node, but allocations
>      larger than 64 KiB may span multiple vmap zones whose VA
>      is stored in a different node's rb-tree.
> 
> Patch 1 fixes the alignment, patch 2 fixes the cross-zone search.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
> Changes in v4:
> - Patch2: Simplify find_vmap_area() to return va directly.
> - Patch2: Simplify locked_vn initialization in find_vmap_area_lock().
> - Link to v3: https://lore.kernel.org/r/20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev
> 
> Changes in v3:
> - Patch3 drop.
> - Patch2 Extract find_vmap_area_lock as a helper to simplify the code.
> - Link to v2: https://lore.kernel.org/r/20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev
> 
> Changes in v2:
> - Use is_vmalloc_or_module_addr() instead of is_vmalloc_addr() to
>   avoid filtering module/BPF/execmem addresses. (sashiko-bot)
> - Link to v1: https://lore.kernel.org/r/20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev
> 
> ---
> Ye Liu (2):
>       mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
>       mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
> 
Both look good to me.

Thank you.

--
Uladzislau Rezki

