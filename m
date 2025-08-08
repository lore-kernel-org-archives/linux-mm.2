Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B741FC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F7A6B0095; Fri,  8 Aug 2025 05:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427606B0096; Fri,  8 Aug 2025 05:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364646B0098; Fri,  8 Aug 2025 05:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 262126B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:59:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FA9B83796
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:59:19 +0000 (UTC)
X-FDA: 83753142438.08.AD97FDF
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 96BCA180008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:59:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vjypu3Qs;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754647157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GD+1uoxSRmqY3LoCmFQ1CrmMk/JQcPEzGxpw35N/9I=;
	b=7kGH7OAxJe81h5gFGP1C3JAFrm8vW056vlsEgN/rrHvVXMoC/Qaxi+y26DV+auFtKssFJ+
	rULF6B+Yeb5C3hbeMmyZ/hkCJqPhfxUArlBsz9aY2/16CxKP4GHLOB1KDG24vRC0MSCCcr
	rGW1R8gNjEF3Mu0GnhqLrK6GwmFqRKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754647157; a=rsa-sha256;
	cv=none;
	b=WxK53eYf80FRVtD9iPVTZuac+TBPd5kDnpaOjFNBZiPMgbfj4CiB+sW/3W0oa0fphE4e1E
	MfDquj20Bm4C62C3v+5xkg+pJuLiCK+DSZ6mlFh+kf/lNtFkhZFo+/ZiD1qlL2FYoHb4Cc
	bzxqQdnq9u27W+m7YwkTAGNZt37gC4s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vjypu3Qs;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55b82db8fd4so2212473e87.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 02:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754647156; x=1755251956; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/GD+1uoxSRmqY3LoCmFQ1CrmMk/JQcPEzGxpw35N/9I=;
        b=Vjypu3QsKMTiOzImewY6UoymtK/DcK3fqLHvoRFuW743SLFQdqMCLzLBdeiHk1+PU/
         LXNlEsu70oa4QoHZzauJQdi0WPuBkt8Y8X9jQ1TSA/hrUtJZ0qNnIBlYYokgVub6vT9S
         89z40MwkwbzTe3d1gu/p/Gbsao6QPnrJcwkIePAnGZ956NIbn5Yo/KLv6ydR+5Ap942c
         6jYGuNbfeoPy6aHrihERbz+2EBnJx4dUZ9m1cJKS7Ujw7dFI2ynZH/NfUFV4xSJ4VoUY
         VttOx/AS9NR/7xfzXCAV7Wrm8m7865vd6LaExsZlxxjWPfJEm3L7rKDUuB1rF9zXN1XT
         q85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754647156; x=1755251956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/GD+1uoxSRmqY3LoCmFQ1CrmMk/JQcPEzGxpw35N/9I=;
        b=De4poyGYAhzF/4oGSPeQMKYjZc8sDqO/DPvQNPPU8YctnrRvxEzqpNf9ji4rjmluQS
         fPt/lVMhiXd6zGdo28dPDnlalEROW6RzQorY+sjw8Ha9th5eChMsRV2/3QL5IFdsZgRJ
         66oDtd/p6r8N5027ypUq0SpDUZwB8635Lkub28+vJk6rfDkCGSU772O4rnMZN014pvzK
         qYG1c/0ZFrKNYlnBikqHnaXDAoiOazvolUTpg0TLIrsft5Z8oZcPRViwxTQJoBzwjXG8
         dRBuUH12rL6+dhQM0tpPabaQJZXgObaz2OeSS8BVSg+Oe2C5cfLRr/hvOOsTrKLbtoc4
         SHwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTE/Nke0nAj0FQnj6nidUsvlM0YyLU3tY3jaUBlnBou1iHyL+FDHPmTwynVotzdmkxHXnnYbIY0w==@kvack.org
X-Gm-Message-State: AOJu0YyO6PkvkqSJEsfmfJE8vEsYvGuFa7pIDywI39vqkHoT27OmqiAj
	9DR79qn+TC9EyxnuS9Vwyi6PMMEKYtClSccxRxEJr6Uoo01Zr5v7VL/R
X-Gm-Gg: ASbGncsSGdd82iiFQrv6DoypbHB4J03jTEhCb0lMqq8aXCiBj6eFdfj2B46a2u3s4R6
	zG+J0ULyDS2VzeyLSfXn2XWIlDnIljbpwG+fNeO62DdMIy8eLfyKvWK0DhAvsL2SkTxiU4EvLEL
	KNAsyHAsVj6YsdA9bU4uioAnt/HFpQOlIB+9CWz89R2trdsQ4cxScXITqDzqnCjVx1WTmKGB0Er
	YopmTVkP2yO/tXOTg+079Qs3GCEEKZd98sQfnANbFOvNMj9ydPTcbRAOGHeCJSwe6bCrUgaUFdD
	Ol63ppFwY6HzlXDFNLZMvJRY6EO4vp4Uf1MyLxawAc0TgxWpT5jMY4BdXFO+swYbkxqcbxP/FtF
	/zoBsR6ia8291waMDiarBP4+zcOmvGXzpjlcQ6z81c7C1ztLrmg==
X-Google-Smtp-Source: AGHT+IHRHsDsTXzZgAshxJsbKmsUggOsFkvCkS3GFd3Ifj9I0+C477rZaqlzarHB17wtGKvoXU8TwA==
X-Received: by 2002:a05:6512:2386:b0:55b:8f02:c9ec with SMTP id 2adb3069b0e04-55cc011893dmr523062e87.42.1754647155348;
        Fri, 08 Aug 2025 02:59:15 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b8898c0e9sm2917640e87.13.2025.08.08.02.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 02:59:14 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 11:59:12 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] mm/vmalloc: Support non-blocking GFP flags in
 alloc_vmap_area()
Message-ID: <aJXKcEJq4EbIlON-@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-4-urezki@gmail.com>
 <aJSMFgvrLEN-nwdT@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSMFgvrLEN-nwdT@tiehlicka>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96BCA180008
X-Stat-Signature: zjaemx4sewy4ee6bwgdyr4os3j8q1jrf
X-Rspam-User: 
X-HE-Tag: 1754647157-625992
X-HE-Meta: U2FsdGVkX1/QQQS/txJTS8B0dwiVLT3976IMpBw8skqiG2Y9AuZWgolQ8qF/zgCjWWSN+0kzTCONh7smEwymMGbGt0uS2gq05bpOM1Hup+A+WqlS5Tomh81PzZacB6zwTQxofIFQIm6gyk2k8ziFvF4t+P+X1wGcfftZfTv1q1HuJlE6ZKgS/vGCbnNBrNHsteCf4Ky+7n7eNtlRjs4TWaJpE0lgH5WhRG+RKLoczQedW6Cg1EEXVximsXPzKmlNlVDf1gAjU7Hxu3zPUbIzo6AJx+Aj6vfmS42BVWPG4hEkmen8GHAWFgZBIYQDXPGevyPLOZ8iTdS6unwX/RPbfQYk85Dv4jz6kxJt+QQBAyd9jzoUVje+m68INGzlapDM5PjGL1mvEjWAH1IYHXHae0pl7SJnQfqp4Vy1pmyfznlwQjGktsresYwm+HxnJEZ7NOkgdVzw1EZYDcbdqV99COaYnXrJSN4rZiGx2Dv+YKYCOQCLmeJ+CpDWivVmUCvs2m09oRPLPfeqv+eVu01lCgjfNyfog5CJy87Gzywol5UyPn7Xmd4FRivIhoM0cpFZa1FFnnJYjCvV44dQ25B1H/WxNqEnvJIiOV9fyCc0mOQ+DeasCXJLRKoLMfAZhRc2xjA/IjylGVPXXYnAmUcBPfjWPNAXMkMS6ZRRhLz6DZHBYUlNISShqLGU6eUA6zen9fVgW0FPefhOfWvAn19oYdnAp6li4j01NqOHqRiDLW17lr5ujU/mjlMRu8MBddukBeSm8yF855KHIsLh3qLsX4bMSalIKgtElMbQ4tLkBfAnfiGtOFT1P5Zp66fAv9RzvjEHRXlUSvg1Io6x1FujCReXPvXvzJmXYv7uYwcmBEiQKGlKoyHnLqy5/+BCmdDvV2RiArW/n7MU99NczaJTXdN2df7rUexh7QEsm3m5W2mSC3wd2T4r+uT9LxWFA+aj6n69ktIb5Rj3Y/vr7Ls
 oCk53RKC
 QudSZhA6oY6EVNhBltskBeebKsLjcmjXH9TijIL8afQpV2cWxTLwaq1s6b0gdspi4wonjtp/EllvPwNy//ghCXDIKtKgfgZ57k4sy6eF0vi6bKA5ZeudDHfv6lhUgSN53bjiI5wR85rtd+q7z2G1rf4fmfadEm5NsnUSQANJPeckgWszw8oiSWydlhchH0xT56cCaIXMngP7iEShcP56X8Qp3vSmLtshWvIAOGUkW3cTZ1fYj4v/rzyMwG8LzVh8OlyBeBdCBCLasHkTppJg2XfX47vldYN87T7XzbX5hNXuLoLK38TWaRRGRgfJi9x6OLYSqHNOrY9yvDOIwHgn9Zrd3FgiACBU+u4Oq7QIDkwtxD7pfdTdr8ATS/4AGm2ZILiyLPbjXpJ4oNLzKWLl5BpCkx41V8IfOSE36jE7Mc3AYhOlkSAm6sq1K6wDkf5xFf/5+hGN3Nk9l47v9rpRbpn5sd7ST3UImyYTcXtPeUESouZz27PGGUFoh6Ky0nCYSm/DchzBBFt/4+PM/+7FBJ8X7XZqBLMFmBNRYMx96l0xuCM4yTSXmQfXUPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:20:54PM +0200, Michal Hocko wrote:
> On Thu 07-08-25 09:58:05, Uladzislau Rezki wrote:
> > alloc_vmap_area() currently assumes that sleeping is allowed during
> > allocation. This is not true for callers which pass non-blocking
> > GFP flags, such as GFP_ATOMIC or GFP_NOWAIT.
> 
> Those are currently not allowed so it would be better to mention this is
> a preparation for those to _be_ supported later in the series.
>  
> > This patch adds logic to detect whether the given gfp_mask permits
> > blocking. It avoids invoking might_sleep() or falling back to reclaim
> > path if blocking is not allowed.
> > 
> > This makes alloc_vmap_area() safer for use in non-sleeping contexts,
> > where previously it could hit unexpected sleeps, trigger warnings.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> With the changelog clarified
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks!
> 
Thank you! Added in the end:

It is a preparation and adjustment step to later allow both GFP_ATOMIC
and GFP_NOWAIT allocations in this series.

--
Uladzislau Rezki

