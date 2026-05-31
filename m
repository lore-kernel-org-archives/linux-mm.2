Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD6DCD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 18:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82D26B0168; Sun, 31 May 2026 14:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A6D6B0169; Sun, 31 May 2026 14:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6FE46B016A; Sun, 31 May 2026 14:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B52986B0168
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:48:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 538748F06A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:48:57 +0000 (UTC)
X-FDA: 84828601914.26.668CCC0
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60B80180007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:48:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AQFQ6xul;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780253335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cg/AjrXDwe2lskvjan1cekt4xlGxpsrXMJuFn7kTY44=;
	b=rNJ6y/hY5/6npbr1Nk6IYHgrAUHN1jeVclWyYq1pYa1Mi4f+MowDCfMmBNl9XOSUNFhLzv
	NdBzOv6w6nujyAk7k7iOnbyyiUmzKt/pdnyCwpP5ivU2/lql/DUYSKjSJlz/KHNlEuPjRL
	Q2cppJ+XTj2K8jeQUL3L7mdHP6hq/PY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AQFQ6xul;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780253335; a=rsa-sha256;
	cv=none;
	b=Hi5pOmS7xk0/q8GWG5d/7wbdsp5asbTNEglGIJoIshfiuU9EH7y2X9FDm6B00xvx+nBpxd
	1Bm8pTvjIQMIq1POAt8AK7oJScLAF1i2YuipE7dmi+67pJ1EZXCMK0DljEge6J+Sz8f7Ua
	akvDEV4AS5eN8mrDV0X9d6fy+TPwapU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bf1cda2b17so18336695ad.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 11:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780253334; x=1780858134; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cg/AjrXDwe2lskvjan1cekt4xlGxpsrXMJuFn7kTY44=;
        b=AQFQ6xuloGu8p9GuEEvR3bBN4N4N3pIcOOVDFGhM+CMGnfCe87itdXgT9/z67It+jZ
         tg28pAIqHrKctSVR0tA5CEawsKfsDU5ospanYLCGhfrK8GhDVbfspQZcgz4CP/7AQY2X
         KFUYl8MLJ3hfVot2g02/bigkDfNz1UQPZCj/u+rWB/vmvc5IQSiCywPVwd6WQPtPNGSV
         SfEXE3byJIxRjO1jR3sGzG2+7angMdG0iBhV5T5slKmSEWFYwdcbXyhpK36ff9yVvafE
         B0rNOEvItgp01/Z+i1AfM4yQS5zvadjhbMSY5eMCJKb37Jwm6sS7kx23WuxNK3qLBnXf
         7x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780253334; x=1780858134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cg/AjrXDwe2lskvjan1cekt4xlGxpsrXMJuFn7kTY44=;
        b=ovYzTWyl8QaIkNlPlYgq8n3aj7UW0/2syeHx/FdOc6J5eBZwVPrG7mJoS9/6qtK+QX
         YKjNKYesVS2mI1CADWgCyYJggMrfjELAAwrhgKJMxTDpdihf1NOQq0n5zDgUGyMGEL4S
         jA7iCr43hi/atOFB88hG45PPpu5JNzl2cqhQ2mZtLV0O4odezM8BWi/Sv94ea7iuOUWm
         vuvT6TaUQMQVyGSkXOccUueYYxmScj1NjL+fVAJlwhQbYiG5a9csrKCG0A/m5wXGtSD4
         fIC3d8xG047RDQ5qx7Y5rfzwa6VXMwvuwpBD9IMpeqcXo6m+ackVAySAayFidmEoBuZr
         Bgig==
X-Gm-Message-State: AOJu0YxmzNowpf88AaqdpJau2ADB+lMSpsRDdKapihbDe6aJEAi3grvw
	SvW13JdaIQYm5S2yYcbLoqUurlyrsTx4cqvb11S1Dfv/5XrnTRPZHjae
X-Gm-Gg: Acq92OH8uwkD4THzusriQfZvtUUDO1KCRNBvbn7ZA5eW+wRceO13PbIEL2ovJbvSRTx
	DpEQSCRdEiG/VR9v4l8ygLr4HwxQQMj8WFGbat1LcIwyl6w3H2zTC5FOfThUSbWfM9zW7TWcc1T
	FIAtvJtm0r84S+lcPQizYB7vbc6PKCETdMAbTaHQn4M4P2jILsfoYPmPmc5fj0UMOLHoXYjjC2L
	abs5p/ffJvGaWuakTUxPlTcQbTs+zpFrOdPrBdd2+OuDTpmh60uyXCtRE1pBdipndI0tiSplOoN
	Yj7T89LbG1qNOYKQzSuE9wIiGyOozufFbYLMF1ECGHZoozcAkW0OPKIDexl+px/UZ6v4PTe2Nvw
	2jgsiq9u54WG7v9AcZD1Wnu/1bzGptcoRQ4Fa/PLL97UGWgIS5QCGqYfC7WM/jOCaZA+bJTtbXk
	Fve8E1F3S3y4eFWCq372BxSPdeCJty7wkIdpE+NnSxX1j/JntVdyQu1e89CM4sPuKEiDNS9w==
X-Received: by 2002:a17:903:9ce:b0:2c0:d1ad:d13f with SMTP id d9443c01a7336-2c0d1add9d5mr18109025ad.4.1780253334045;
        Sun, 31 May 2026 11:48:54 -0700 (PDT)
Received: from KASONG-MC4 ([115.171.41.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e7019sm82869655ad.11.2026.05.31.11.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 11:48:53 -0700 (PDT)
Date: Mon, 1 Jun 2026 02:48:44 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org
Subject: Re: [RFC PATCH 0/2] mm: swap: allow per-device skipping of
 zero-filled page check
Message-ID: <ahxeXOlodtwjpVcH@KASONG-MC4>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518073455.2495934-1-youngjun.park@lge.com>
X-Stat-Signature: roafip7h1jtwbjwisx3aghsjddp1h9fk
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60B80180007
X-Rspam-User: 
X-HE-Tag: 1780253335-741357
X-HE-Meta: U2FsdGVkX1+N/iTp9UTrxuzRKPAyeIYLwF9h+FHTkCxLj+3Py8WhzH/L/0c1A1SfpUEZuoBt5IGREBdcjgnb3gUJ8fsK6YPDvCENj0BTXVSU5GarcQr9CLg6SeSb8rTZ1c8U91P66PWhxejLyrS9eitvpzhdsGcPynZ1GV3oekRWp2pMQeGVBAgKB1GzKU/U7qe5PDMcjvJlFzlFmUMa3clBXV13oOr2m5M6QHPtftQqMWXad7KvMt4zIq1LWBW+Pb/WLcFOB9ZWn3/FsDGOg/UzgjcuhmMytn6H0+1KvEFuG2HEO030B0QK/gRbK12YDdvbjta4+IbrS3rkngFAoQ2yU+7WqlHfDVfwiwhVEWcdzr7ySrXqegznuCfYHelDagLQvaMJvxUNC1SSaCk3wpbGxr/1oz2MzCEL45j7jonlWl/vG3QoNIXWqMgDDGcdgb3TEGl29asaOxFsoU3ap4N0cjYWNs0PEBHDIDze5LduzZkrTvzXngsxI89m1KM1I+ou1B0LJaw+VSyn6ldgTuK2yOWBJo+OTWFEKPoWzOUEx5tQTuFy07oSdA/TNUzB5KfWP/Jg9H3Ep7RcYH/P6PvzDc2VnNFDOpO1Sz4DBcSymDHgxoekxH/BAv7JGRMMhR4Os8vmqpkja3zVMdJoSCxEYDfj+1N1Hb4jrUHNsP15cM3yfovai7QOVNzQAm0Y6bTbPNyn54lSpiz1ziUipd2dgpOyqqn4HxZbZLkpj1JkapkIkd5xw6zWyZ1ag0KzxXQRT+hqidzJMM/HtiqCmr/pgVBj2lY3P+L+DMe1lol7a21UVa7/q7LFnIW+0GQoDCNvB1ax4twDc0dmrAuR0aGirsZETJXYpjCsTyJOja1bu06wh/GqloWSyr8bp3mVbxURneNW9UK8rfxelmiu2d9aBtCfuzEHR1vu0+tKr8mwUSmLbTdujcrRtVF2eSJRUjk94SW72zxQcjX2X1F
 sKO8Uhda
 yUSfvRpxGJqgcViCK0dEZUzm+/P5JZSHIHYzWcdbIPKiNk22GanuXXvVxi9rq1J3IYAsZs9ht6ffuna//AwrXlXggcmAWQjTQ79ZdB+8m8iT/FEO4MsJIzhjD17XHGkqro+K/NlPHWda6byaIw+dZi1ZcB+lOugDaKHp3Z7PV5wf3nwnuV/r6G073YUKXF4j+ct3uoPqeJ2WP0GKwJCdJNaucfovOCLWVZhQ1l1LCyxdyZD8fl8CMzrHrDaO4axuu1D7T45L4ZTxKVcxCNPrq1KL98Jga0w5/mtz66lorqcn+YYc5K2soi6KTi+omXJoBmyvD6saTPLFf7iCjVzQiTxrzvmwOtgbVLAn8c+ntT86lQ9UXYSgXvv/0qyfBnBM7DfVqC/uwI09H5DMjtBBDZfY29zUOJQycRzi3i7WuE/6MKRjIB1Q5Bpj9dmJkPWwCzyQCIX//O+ZNz9Ggfig3V2cCG4s8hkej9F9t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 04:34:53PM +0800, Youngjun Park wrote:
> Currently, the swap layer checks whether a page is entirely zero-filled
> before writing it out to the swap device. However, some swap backends,
> such as zram and our custom swap device, already perform their own
> same-filled page checking internally. This results in redundant CPU operations 
> checking same page pattern.
> 
> This patchset introduces a new swapon flag, SWAP_FLAG_SKIP_ZERO_CHECK,
> to eliminate this redundancy. I introduce this as a per-device flag
> rather than a global setting because traditional swap devices still
> benefit from the swap layer's zero page check to avoid unnecessary I/O.
> By using this flag, userspace can selectively disable the zero check
> only for specific backends.
> 
> Furthermore, on certain architectures where the zero map is managed via
> a separate bitmap, skipping this check allows bypassing
> the bitmap allocation entirely (saving memory).
> 
> This modification is based on the previous discussion with Nhat Pham [1].
> Additionally, this patchset is built on top of Kairui Song's recent
> patchset regarding swap table and zeromap modifications [2].
> 
> Tested simply with zram on QEMU to verify zero-filled page handling.
> 
> References:
> [1] https://lore.kernel.org/linux-mm/acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330/
> [2] https://lore.kernel.org/linux-mm/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/T/#t
> 
> Youngjun Park (2):
>   mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip zero-filled page check
>   mm: swap: do not allocate zero_bitmap if zero check is skipped
> 
>  include/linux/swap.h |  4 +++-
>  mm/page_io.c         |  7 ++++++-
>  mm/swap.h            | 12 ++++++++++++
>  mm/swapfile.c        | 14 ++++++++++----
>  4 files changed, 31 insertions(+), 6 deletions(-)
> 
> -- 
> 2.34.1
> 

Hi YoungJun,

I think this idea might be useful, some workloads with very few zero
folios doesn't benefit from this zero folio detection and it's more of a
burden than gain:

For example, one test result with MySQL:

pswpin      129323368
pswpout     131460192
swpin_zero       4641
swpout_zero    248210

Less than 0.3% percent of the pages are zero, and almost none of the
zero pages are swapped back.

I think the zero page detection is actually better combined with
compression, e.g. ZRAM & ZSWAP which will always have to touch the
content of the page. But some devices may be able to just accept
the folio as it is and CPU may not want or need to read the content
again before pass the folio to the device, that may save some CPU
time I think?

How we can make this zero check as an interface is arguable though.

So I think the user might not be limited to ZRAM.

