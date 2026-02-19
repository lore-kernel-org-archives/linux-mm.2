Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49220E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 16:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6C16B0005; Thu, 19 Feb 2026 11:57:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784C76B0089; Thu, 19 Feb 2026 11:57:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666506B008A; Thu, 19 Feb 2026 11:57:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53B9B6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:57:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA9621C703
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:57:54 +0000 (UTC)
X-FDA: 84461813268.05.D5D4981
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id E39DC40004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:57:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8P7lS5A;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hv0CvmODka/syAwxAeBmxnw8MUjvxFT8d+ZWcy2ak0=;
	b=t3Grl32RP9Y9OC3chtO9ARCb5+UfHtr0dA1EjaQiXYerS1f19J0PGrKwsJYU2tpPihQE8V
	1JokZHl3WORFt896KkplIF+rxpzMnB4m+on5RMq6im0b7i2nNRJCHEv8kKI5UrfCAtXnIR
	UiUOOCQ8YMFQXs4SCx3qL+q6xs7qzvE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8P7lS5A;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771520273; a=rsa-sha256;
	cv=none;
	b=mXo/u7GA+H2JCaEq0X+MKGHwsU1xoBgjdnQ65aknxgEJDkVk/T4eHS+QYMj91Zs/bS4knq
	NuKMdR9W2jUPiqO2mCxg2BZVtFRKYR3pv/Qi2cwNWG9l0sto26JMTZrLnfhwU2/desAXSB
	x84AQtkuVb6LwpSFLPnDDW5W7umE/tY=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59dcdf60427so1268452e87.3
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771520271; x=1772125071; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3hv0CvmODka/syAwxAeBmxnw8MUjvxFT8d+ZWcy2ak0=;
        b=E8P7lS5AUFrXOcb9AVCOh/0nrOlvZHuS7kaFEZF5r9bIIpQ8Dvc1knpHQEQ3AZK9cT
         O4ecYX7x1b3IZoPP+GmcIAvcSV00gsrWDrCKfPEeXQlexExMrXHQReb42jfJi0ndTvE1
         N0/8M7KEHDa/bwPR1/oEVeq5Ak4hVXh7IpA0yueYC48yX42ov5mEieKu7UmDjISGRu1s
         yJ9TR89OccPaxwu4SMab1df0P3dZDDObt7zkONM8GZKl8RV1Q+1D3HMD8+vRQvp/4X+V
         WffEES325Nvez8+dsf/WZasVuhHC3qPEep1MxNfEYVTjKDR1MuAcmLVEudr9IEIxWS3j
         3JlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771520271; x=1772125071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3hv0CvmODka/syAwxAeBmxnw8MUjvxFT8d+ZWcy2ak0=;
        b=EwwBDtFC2PtMDCh10TDxfqAArh0aaL0fHfuJQH+H26go0tfmCBzMCKUvyDdWvZKBia
         R6pIK6let+TiieLhDkluAN9ISollwjx8U+ngny1CCCvEfpE1FMetum0iV5lvWI48rslK
         nJ+7hX+b2e9ldqZWmShN4tT8YlAqvIKw1G2R3vNf0MyQt3AxQepRKu4gLcxVxWov8eXD
         3KRAFjUlO5egNdz97MYP4EQt9M7N7FKe+LcCTrtp6Aind1+2nEFZHFFho2Fj+fWgODqF
         bmYMObyeT5zP6Lk+kz9yXfBTbvPv2d5mC311wgcAmcd3Dfl5SEA+O1P27HMus2KVnoqD
         Rjcw==
X-Gm-Message-State: AOJu0YwNaeajqfhXlPAEwGe6Vy/iD/HWbf7bIxeviaNyUnPtCf7Ekonb
	9sPNOfIJgZDMt/R7TgoR/d5tQsynYOwcc43Sp+Bd4hlFSqg46p8VUoDj
X-Gm-Gg: AZuq6aLzrqD2BxL7ldEKubHn/g9fWtx49GFP76s53WnNc5UYnu3n9/zH+zDUVvqR2Yv
	CWuJ5rztgWzx4TmwaUTKpXtB75ATLWxlDx705+EH1lkmSGrJxBaHl5dVzTytDxQ1Iif65sy1wxY
	TO2O91rMlWAy72ZCLK8+Kxkc4cd/9dsIXbMM6M4qYXZv66Kz8zMYrysLhDNV+Xs/OFH5nJDSwvp
	ebPR07yYftGSFYhcGwxDks9dcAwn54h6uuMNhFvyoHd7sR0eC7DR8xVkZHRwqkWqUEVdZswT1az
	4LEFNnYQtMWZXnP3HsX6JdIALXvREeiDuBpVtnsIGgR9PSOIuvmvLmUygAzKyPZ3b2Q2HYX2BiA
	GuOozGdNgoF1qRPDDNwFKiFtH2wWMZEYRT8Yj3qJ/0Rmr+Jgv2SvVczrg/QbGm4E66z8QmaTWGB
	jraI93b9lpwWl+x7Yvo64Rg4lXV/S5fB28TkFsn3d9RDlN
X-Received: by 2002:a05:6512:3e0b:b0:59f:7318:c5e8 with SMTP id 2adb3069b0e04-59f83bbdd17mr2001000e87.39.1771520270842;
        Thu, 19 Feb 2026 08:57:50 -0800 (PST)
Received: from pc636 (host-95-193-11-6.mobileonline.telia.com. [95.193.11.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f5ac180sm5391859e87.63.2026.02.19.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 08:57:50 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 19 Feb 2026 17:57:48 +0100
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: linux-mm@kvack.org, Danilo Krummrich <dakr@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org
Subject: Re: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction
 before implementing
Message-ID: <aZdBDOPUccXa85O2@pc636>
References: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E39DC40004
X-Stat-Signature: m9otb6aopboh5b3sd8qhgn9oz1kmuraw
X-HE-Tag: 1771520272-608238
X-HE-Meta: U2FsdGVkX1+BgiGbjwEWvLR+f0a4iseHa5GhUzSOKr3VlIEJGYkdTZF5/Pnt4lSEesnTHC40ZOV49KacqgB3whNKj0o85tnJLeKmOK0ps02Stzak9gypxBjkNdp35IQBoMQQ/1xVvVyG6MVn6QUVGiKotJHB5Q+JROU+W1jJFZe3mkwa3j6DKz6wRwddJ0BWGG2wNBCzq2mEbcYvPS5sWkS01U2bJX7da+QW42AshIAzYX4sbPbu8McN4d3fNQCZBwJBKzzO3B/jxoK3P4RMlFfaGBqCtVX6dswmz5XAoiZuzm3TnRyWOlaCPocVmNf2eZDuBOoWeHteo7bWIdNzryWrkBJ2uqnI0ARLk/dpguEhXxK+8CDLjQGz8TE+9Z5QET+2Bhkz5OZL9eKRHjUtwc2i0gWfuZcZ4CDw4OOCIA7936IMm9jelT3G+OSdAds5pV01QIosbbQWvVuCKtcPbgBgBaBVVuLlyKe+6t9ZBIXrmAPyzpUJgBfKvcPgUCQBsaGHZvBcXZI15dVPgyOsQGQSq3YefIbVfpwM2DmNUfLm4o1CabLuD4Un8GzjyYEEctMW/+F0KX1GL0NU0mA7kIXPGeREIaMIVKF1m9O8BNmIiqgLis81SIt933wFGXeuIG17s7xAYY4HUvnNWl4bO1VDpBgIo83vnX22JEFv0H11YmFupRsgn8iRZl8vTilAMhtYF8D+AADUpiZfYeYTUNVYIuFljS6fFUgkmJx2/U2GzUKCJ9q4Ml0KjA4u3mVciEitf13hmAqPAniKiMji50hV+c7+k8A/fy1NYdjg0wSY687JI9tgqoyFlGVrOV0Uk48u4oimCmne7uiACqjEwshCYpOHWE/czoUxfaEdCaBCEG+i1kTheDZAdNnckYK1LH7a7IynQ2KLpoTJ0wIFpBbBnHa+WWdk9AQEhq7a2ovSY4OkZCWlcykK3gEDOHTtc4LOBidiZN51L+whY4i
 5DY0OY8G
 oIeA5Bj9QdTWeE558docco67tJzW4ZKK++jodNRe62tnyIoNxgfJlfHgww4OXrl+EHqgtGoekVVdVSwRU6pUIqgEj7jIx7pfqazdjwr0isLIZPNGLXEYkG2Rbd2t935aNA8JJ5GeRyfW4mkc5LoY9Sa/xOz7tQ49s9aO2M9DQyr+x5iR8A/4ToJgfdTWEcHTv16hYeHSn26uxPNz/nO1DolrtYPeo27iErDtSVvgn9TKIP7umDC3zQ5ujNFu3gA5BnKMMiHiLSqYAcb30ytAU93476lVmj1GocVLOIE+JHeZmPSP2Yy+CWw3h/z50moO1JDruCubeUy3+lyx79dSVhAFtHZYpBXMp4y4gCR58jC8qdYGlSef6Z3/Vibn1hJ1vVVb1sWteqf914IeCrL6tP4lBVGH92CTy1lEvGPB/vLzlLk6ZQQwqdzgTIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:36:54AM +0530, Shivam Kalra wrote:
> Hi all,
> 
> I've been looking at the TODO comment introduced in commit 3ddc2fefe6f3
> ("mm: vmalloc: implement vrealloc()"):
> 
> ```c
> /*
>  * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>  * would be a good heuristic for when to shrink the vm_area?
>  */
> ```
> 
> Before spending time on an implementation I'd like to check with
> maintainers that the approach is sound.
> 
> Current state
> 
> When vrealloc() shrinks an allocation, it only updates `vm->requested_size`
> and KASAN shadow - no physical pages are freed. This leaves wasted
> pages mapped for the lifetime of the allocation.
> 
> Proposed approach
> 
> When the new size crosses a page boundary, free the tail pages in-place.
> 
> I'm proposing to always shrink when pages can be freed (no threshold
> heuristic), matching the simplicity of krealloc()'s in-place shrink
> approach. For huge-page vmalloc allocations (page_order > 0) I'd skip
> the shrink, since partial freeing would require splitting.
> 
> 
> Questions
> 
>   1. Does the in-place approach (keep `vm->size`, free tail pages) look
>      acceptable, or is there a preferred alternative?
> 
>   2. Is "always shrink when crossing a page boundary" a reasonable
>      heuristic, or would you prefer a threshold (e.g., free only if
>      > N pages are reclaimed)?
> 
>   3. Is skipping huge-page allocations the right call for a first
>      patch, or should it be handled upfront?
> 
I think we have 0 users of vrealloc(). It was added because of Rust folk
wanted this.

From the other hand, if we free some tail pages without saving much in
memory consumption, IMO it does not make sense to introduce more complexity
then. Also, as an example, if you want grow you need to alloc/map back.

I mean it all depends on number of use cases and sensitive to it workloads.

--
Uladzislau Rezki

