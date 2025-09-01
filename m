Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85733CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37348E000F; Mon,  1 Sep 2025 06:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0ED88E000B; Mon,  1 Sep 2025 06:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFDA48E000F; Mon,  1 Sep 2025 06:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB87F8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:23:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55AFE1607A7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:23:40 +0000 (UTC)
X-FDA: 83840295000.27.A931B82
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 65294C0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:23:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DvmGXLJt;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756722218; a=rsa-sha256;
	cv=none;
	b=gZi78UtxkhUFxs1u+V4MEet9pu4sXPOGRv/2EOzwG5gGXX5WQUjo7Ql7Inp+u0KZLqUeXQ
	hMsgDt1KIyTGR1+QUlKNm3D6ZxEW7dBpTejuNw57lYBdm4Ub5vpiw9OLCDFerz3iIoGwO0
	3hWMMmZKwlq0LmkP7yie1tC9mmZiu8M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DvmGXLJt;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756722218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKqd7PpE3yly34arj4SP6XhH3xgSPkbGcUhsqf+SkXE=;
	b=YtfukjmQ/Bu594mo778TyA3BzY66NIWKTfEopmUWQDQSXFVF8SSEikiHmf1ui8SkhXfUsQ
	mjjGBBoMlZLGdNKmaijUS4EUBuKLiH3WmuC7LMIwByWgreRuVf1N2PcuWG2kdqa9cwRIp1
	E/zKs53HIy0mfTk/Q6f3xgzb5z/QHcY=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-336c86796c0so13701461fa.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756722217; x=1757327017; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IKqd7PpE3yly34arj4SP6XhH3xgSPkbGcUhsqf+SkXE=;
        b=DvmGXLJtss5HKEx33sT0YHmFL7OykOXEIMeMTR0CCLTA8rYQ7QdrjhChlPBCsK5k4d
         l0TLOFtwB0o8tbt7xeMUSHsYLb23vgc+kHDayp8LJuFkLgrMq3uGY08dTnzqjAOu3VNl
         VDu9jKJfkNOT+6TyBzjkg8YLNhMPLoCqyLpadKR6Qu3rnyQuJSu4TJGin/Jt6KnPoaPU
         QHrUcarcxgsrL6jvTHP06w3P9BNddAvKyjo9As56W9wERTILJaFigiIXQ9LSX8NQiOfn
         Ea1aDW5G1UputroztfC3gy2lqAHcTrOYhpIFK6vS7Cy0mLii+PgHQzvq13JAmoobjbwt
         /fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756722217; x=1757327017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IKqd7PpE3yly34arj4SP6XhH3xgSPkbGcUhsqf+SkXE=;
        b=S77dMr55Nz1KlinsC/ZkUXeF9p3c89Rz6IFeiD9wl1CevYCKbrAMnwyaF0xFMlv0Mq
         rSjRbESUBILgtSIaGEk2R7ddGvDbcHl2Bq3gAFgdCmH9fCWcwd+7AhUCxHnp7++wGDrE
         m51zzne1YgczHcf2RfjjzcTS54y9+7fRlD3x5+QlGNfIvEoFvtc4qf9R2m1Ia0603aV+
         +wt2Z5V23vWV06/w+i0SaIOgcmpvhPr6QZd/+s6S3KXIHPgsTOONfP2x64e8tvXvgRaq
         Trj6lCw7jQxNuElHZX6X+IyMiIs/rRwAWIPHVCFRCTgLCcGQiLqvbZdjJd4bxsuqVTQf
         jixw==
X-Forwarded-Encrypted: i=1; AJvYcCXkWXOSn2X9bDBj/QZnGr90NwBxZeWxlwiq80mdm9+hB6XizO3oBJiPoSiIm8HkUSoYOj+UuRDW8Q==@kvack.org
X-Gm-Message-State: AOJu0YxBPdp8tRHbi+Nmb1jF0xQePk3S7VKnH40QvxGkT5MS96v5J+st
	ZJ4C/8jasVTNmEm8PDDnXrPEzOu79JoPRVc/MpfI88X7G4oK5QRC367N
X-Gm-Gg: ASbGncu1u5HLuXxNpdQzYZxiBQ9zmNVyOLKuTrq4/nqGKuN1N3at2amsZJbY5G+aBJl
	+dAjnm/uCtTGP+LU8JeuahSEjerVZPCjhyRQQrMRiqOKWeaPuPBOpatOnl5NusgaLA3b+F8T1bI
	sOosos70JBp+bnTNdGp9rO1yLpi1Py9Pwns3t/LdqiExlxL+CT7PNyUSyhSdDVAyBwlhw8c1qN8
	Fv2N+c4K7m3J3yag5cEFc4XqU2Ff3RQfYE5sW/ynBW20kS94C5SBFlH1gv2oW0EXwgP0V4OFI3z
	5bAUsSHDpDMH/xLXLQ6nNO8j2YtxBhUdtO6O0XuJKSRxIFKfXA7xQYHTkF/bESfgdF9dZaWwzDB
	cnkM6RV4VIwVNVg9tHVu9uYv5udXJ
X-Google-Smtp-Source: AGHT+IEofX/eNnkXm26e6KDt8g+jikWgXxGGcfHBANCoOLg4hL3QjuemdJNTszKyuEhhug5qw4amEw==
X-Received: by 2002:a2e:b88f:0:b0:332:5fc0:24ae with SMTP id 38308e7fff4ca-336ca98d99amr15516571fa.15.1756722216273;
        Mon, 01 Sep 2025 03:23:36 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-336d0c583absm13691161fa.2.2025.09.01.03.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 03:23:35 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date: Mon, 1 Sep 2025 12:23:34 +0200
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
Message-ID: <aLV0JrSPfitu1jFV@pc638.lan>
References: <20250831121058.92971-1-urezki@gmail.com>
 <aLVyia16eyoYftAw@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLVyia16eyoYftAw@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 65294C0007
X-Stat-Signature: qws9d9mrpf9f654u739ox4k5js4jxmpb
X-Rspam-User: 
X-HE-Tag: 1756722218-104166
X-HE-Meta: U2FsdGVkX1/6NjiWuo3RpEvRCGOFp+ExSlk4e+uQoDL05kDElSno59l+JOjY2S0n3MJEnj/giftMI+DuMmx2uy49RC7gSqWx8SN7nJZB7voM/gSwKDuu1WTmLmvcGoH3AQEuhBx1Ais1uwgKsns5GHttmc7UhVafpt5Xc+HESHMF5X/w5acKkBChEGcLCXEU1QHwPfoQlYxQseaAyun/lTdxn7Zyv12kQq9CVBjvskrTgO7N9meOj1ob5Sa2K1jh4I2hxSMedwGtDYWjDHB1V0+GF5tgx6V8dxKUUpuFAmE1gHSeN7XrYesyhTyDrIkybYzFenqSKTTNQsDOOgWhQjYt1iG8US2PBxpsA/Cecgn0W/OKfAKK4TIX/05KT5nMt/3KZpW+2+n8uLxHIOeUJ9qVdIIp+JIT/vlrIUadoBylmqAVEzAk7SWr3W2t4UTFFYKnX2plXEFyl3lW9eXZDCkt919n26BgoBlFybsWHMHxB+vUH1LBdILdak2V1erSKJreAg3NcuN03hU4nMdlRKZ8RQgp6Ao31pBy89sgdAKCHCycmEqSFDiuV+kHDB+GXCEL9Mb3YHksogZynealMWsVUn1U+MzGp0xVfUSKsm8ACR0Vgo5RAdzE5xppoQKUBnhUFkJVwKGPbH4BLI8HYDas7dqkRCai6TsER3uV64909FsHp9Jrw7niiB85sNTmNsMOrotlpAx2knTtIx35bATi8743q09+vJ5DJ9Zp7LCcdgfJ/TPMQkpBBaj6TSs7AI5gN51r6FjRp0ZR5MVJJAKkCY3a+l3HZNcAcbMEtnzsl33nDVvN0pb8lpmAv3Tw1G166FyYTiMpHeYpkKdqtZYuQVByzahqMIbGwkAzwROI7rIUgP7VW5rT7ei4Q006gU5bxyoVv58nb+E9D5uT/+2DJc0WzUQN99sdZQ9PKYu98jVTDJqUnNUmSUrcXuZ8xEbpCPQyRkGolrlqAc9
 RYxFDUOd
 2y8K1xPt9Q8od1kLzmsPRfGzqNKc0yKmjA35c2o5zhZ9iHFp1SCzC4oXg3/m6YaYtwZDwDoU6mR6kJZnytXP7x+m+zuMp+RGL3jJzBbADmOMi4j+E/Rph1YP18TPjc/qMMVIEFyQbhiria/kTnmXwuRjsWI5YMvF6pYQinlmnBSTShkZJrVyeivY5ijgQrtmjbX/159ZAQbzDIt6JNyUV0AZ7QKk1T3wJyz2LhKzy1pE3VZh24jU80rhqtjAGizudbdtVvp5uH28EDsR2zAzx6x6XgRAHbxTP1TgyS9kaNk2aXM/IK7nDTy01sT931vFQLrG2Mm/6jpJuNExGJaCVpSsLjXboe9jzgax4qrbFdKRPtA4dX9Aariig6rSpCW2XBuz4We6zL6hpbmypSPRrifJHHzmZG2oAjZs1xsJ9SvvdPQ/2UpIe9q9qfbkHmytdITa09Tb6VpF3z6MXGaYOQ0AtY/3ONRCxzevOJTiFpnx3nnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 06:16:41PM +0800, Baoquan He wrote:
> Hi Uladzislau,
> 
> On 08/31/25 at 02:10pm, Uladzislau Rezki (Sony) wrote:
> > kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> > and always allocate memory using the hardcoded GFP_KERNEL flag. This
> > makes them inconsistent with vmalloc(), which was recently extended to
> > support GFP_NOFS and GFP_NOIO allocations.
> 
> Is this patch on top of your patchset "[PATCH 0/8] __vmalloc() and no-block
> support"? Or it is a replacement of "[PATCH 5/8] mm/kasan, mm/vmalloc: Respect
> GFP flags in kasan_populate_vmalloc()" in the patchset?
> 
> I may not get their relationship clearly.
> 
It is out of series which i posted to support no-block for vmalloc. 
I will base a new version based on this patch because it is rather
a fix.

It is to address and complete GFP_NOFS/GFP_NOIO flags for vmalloc.

--
Uladzislau Rezki

