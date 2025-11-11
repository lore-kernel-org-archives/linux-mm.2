Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222CDCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571DD8E0008; Tue, 11 Nov 2025 01:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547798E0002; Tue, 11 Nov 2025 01:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463198E0008; Tue, 11 Nov 2025 01:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 364518E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:27:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7CDB1A02C5
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:27:43 +0000 (UTC)
X-FDA: 84097345206.16.BEACD0E
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DA2640002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:27:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=XZqf7vyG;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf27.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762842461; a=rsa-sha256;
	cv=none;
	b=0cGOWG+FQ61H8mTeVVZ6odpmTlDS1sFp/JfeND1Ejy234UjrRqWTfts4CtKcYEsbcslnGZ
	iYYldT9lTxYKDTzZhZBVaR7lDOrDV2gFpmzk2GfcETiJFFi2H7HQyvteFKQtPuCJPbiixb
	9LHaGYRQcaMpeedxLVWBkEx4PBoi7i4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=XZqf7vyG;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf27.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762842461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89750Oqu/BHAULCo/u4k/dwdc+TJgBdi3kwqH7WW9JE=;
	b=krMwEPyki8Iz0aFTwCxqQV/vd1HoSWmNSLV6F5zgz0lOdzMemyTuUhOAbfqHqa7GPuvp/5
	iAJ8tUJjGvlruFPCe7t/xLn1qzFOCGHbQ8zivebHNUmUOTL3am8vx2mAT8e5wG/zLPvcFX
	sRliALn5lAbM7dXXj4Q9kHZ+/Q4wPEs=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7af6a6f20easo3098071b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762842460; x=1763447260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89750Oqu/BHAULCo/u4k/dwdc+TJgBdi3kwqH7WW9JE=;
        b=XZqf7vyGoo8NP/IjJB0zoTpn4BLZU5mG/tGe2QNIBuuzwePYA9JKbb6cl4Ri/l+AhB
         kuVEK5SvDiIc1BkUYMaeBfCotXBWvoIl0J70/pV+CQ9CpuY05da6n17mPEvkjjjKDhYA
         C4TBpORzgQtoA7vjOTidYa9POdATP67fhlO4t9WpD5oEvutfOj8fCUoGSVTYJy2zxW4N
         mqdZ3UHAorBtoK1m1ieN0bmQxvA3QdztpsjvTFVxEU9eZFgsSA7gD++MH/2qQge4asuI
         ULppwTHEeO+6SBfMxURUGWIbU9rPm2fSvDUF1OfIfIEKXQuX8exZ4TmXJhONM+FN6NHV
         sdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762842460; x=1763447260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=89750Oqu/BHAULCo/u4k/dwdc+TJgBdi3kwqH7WW9JE=;
        b=EIgE+pEuTl/l6CXaZKGW8dvA6j+1R/eRLBKPBMbAgidOMx06WOw0CasAs00uWy0toV
         e4ItUTYVN9+2rAivDuCUulUXBFk+0/dG+bA01L5vS6VYfcW/Az28BRHPrRIzrBUf6UM+
         6kkz4kfIJrZlPiAd4Bx32fFlo8Ypy9XLPi6L98sj+qeK4uFExRFU0lojkCEPVTQ7Yp64
         dMlgBnI/Dr3QRn8yNUHCTgcPWHvwOLyWyRCfHiWFphEaBDxNzGNb5ROI8uQu/AMjjjpX
         7TdWT16dswW5FL7fT+ZinuABPol8Jk94QPKjDzawXgbG01VnAI7CFwQjMz/7Ea0naVb4
         HI7A==
X-Forwarded-Encrypted: i=1; AJvYcCWC5mpgEb5OpalPl0leRgzaJ9rYokgUJ236qVzl8mYOfNTh/iU2kYc6UWdQU72Fq9UGnImcyzfXDQ==@kvack.org
X-Gm-Message-State: AOJu0YydcdRF5ceJJjnLr87O1DvgOxM0pGRnjLRrZKvs76iyGeEPidgS
	6vmfcjW2EbjszZHJYIWItZJfI+bqo7prLYDR1MHaaWH06gWT2kEQzAhd3zNhzSUMJMQ=
X-Gm-Gg: ASbGncsLdHB5wmMCeASsoxUO3V2DegOX8v/Eud/q2u5rqzqi8FwaBdTbQUfBFvWmNrI
	qWGy6LCsSJxYzPmUEqHtwpCWb87mCTGX5U7cV85YJ18WgrHdn0JJ1YrTdY976ocdVdpC+TOGOc3
	AjtzamLym/FWsCUQ4xSPDHDKMtIj/Fx6JsEaz+SpmwiuUL8eP0l203k8XXGXZofY6jddVBLGNdp
	U3v3F2ikPNvQfIHSWDrWt4ce9IB9CaI7M5CErqNmDBmscgO9lf407KjcIDY7qSV3f+dsujIQEE3
	a7enj1AKJGvB0bYcaROYdkNr4WLDFhKSOhZlyb4ALXoZ2slwRQeCg0HifobZ6bZaD3necGnK2qb
	w9eFB45Hxt0KM6vPCIyz0WvFvTQIX7M9T37TYvdhPunHpoXIBH9297y1zlQMdfqGNJRSKTKrxil
	/Cal8qKgnDSEwI/LYErZ/TDbgb
X-Google-Smtp-Source: AGHT+IHvv3nGqmj6KV33XK0cWeJgSfI0JoC5d0X073m/gYYS8JMWAEkjk7xwepmEOfVYPNtHkdK8iw==
X-Received: by 2002:a17:90b:3c09:b0:32d:e780:e9d5 with SMTP id 98e67ed59e1d1-3436cbf60c3mr13213813a91.22.1762842460272;
        Mon, 10 Nov 2025 22:27:40 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c6951633sm14267754b3a.0.2025.11.10.22.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 22:27:39 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: tj@kernel.org
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for on-demand stats flushing
Date: Tue, 11 Nov 2025 14:27:30 +0800
Message-ID: <20251111062732.72880-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <aRINDrnnI1HVvU1p@slm.duckdns.org>
References: <aRINDrnnI1HVvU1p@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8DA2640002
X-Stat-Signature: 8h7p35j3ojbbdosg47x9rqbm7accmr9e
X-HE-Tag: 1762842461-970473
X-HE-Meta: U2FsdGVkX1/Bmdr8+5uuURd4nyKxFMDntlGyww/Ucr5tKiceskehEwanAtRhxEl/bUcNUjOjnshVyzU7oEG6h/9xpvWAVQUPjDJZc2Ercn0IK13UjZh1qM/GoD365iXalP5Qs0zUpKeV6lacVVghEE9oO7MLzQ3ViGHCMhzlkaP475ENdWGgHJ7VvsJ1ybeXtn4E2tudsGEafBgwIP2cwUC6VYrFL3Yh6Oi8iqy9KxR++dKJgT/1sT8YBAaT/laqh6VCdmdwyV+rAdmKMLMwrVpD70Eqri5CfZctsy+JzM+UnW50VWsW+/WcCDW1VT52OFmReeKA4PqTkAL5ApUtArAgm3NUw5IhLLCKd+KYJligiCCn3N2uolyJFRnecZLtaP94Pdq0bTDWD7ijKxXXXN0IMzQeCgvuAdNMJxSxnIsZddE1VIxY9KnVdlnP/mw8UNitSD5y6xn5RWEhr51LexWfQdvJqhDalWFiHjgNj96F25GmxUXYQw7uChQ8XKlzM3VfEnT58g4/kDc097s8jts9bMAT38iUVuXZIZsN7gZxL5EvX3B8JS0LLt7K9D0vEwHMPtQV8FNrzyJVJw3oAr64GAWHTx19r5191fiChq/UJWZdG6OU1H9J6ncv+syl1uaVbdwkciXUSqEG4KeeGVtIyHB25XJK4g9iL7zzgWLcVMWfGG/M+ShcIAjU0ip8TqijMW2BfmOeOOBF+tO6diCjpjuv/sOIE76r57rBkAVCEVHenkiFmjVzqiM5cKs/Oe0P9Eg0cWIXfGyiL20YUMaZeC7FIY+5ssEb9+kp+Uzs9KCTfiDdwbrnn13AJ0Vo8TlcBowqNS0MimNRn9Hrs2pfmcxW3SoZyazT+m+6sYpBfi2AXkavaTGvQTmvj8Kv9uruJLPoi40yNcf851+n4EgUMxaVdGG9EB7uRkf/UqghNBZatVe4xeJSV04fP3uS/QZP+jYkA6TExd5rMJs
 ry0qGyfw
 wCMCwxcUQslhMUcid3F6Ue8nMBBt5SF+q/nwT65uQB/Fbe+d7tdsGfqEVXAt1vqY/KqwYmC0MlY9LKnFRD2eBvX8Tgbr6Nf2JaaTPxT9Dn9ukaWDK+m0qLFFHFrFySVS6SB6haADtljDK4cVLoYWdwpUd25Dl4/+kYxfetdA+cweJ0XHgEp2BRoQUQzLuI40ylKFxUWU3jbk0Rc28S3/O6926Ve92GElZSxRbOePhizjUL2qe6qLbBQaAwExP+18lljX9wxTGGpHWVXFiqcp7xGVkwmgEONEjMdPNhQvSFNx4KcmbLojIYFimY1UW8zpT+dE/46/52avw7D7ghG8IdFHFi+Ulri/3Ty/Hnhs8ucZm4L7k0GpluZalnhdGAq1LMOXIGzw2Q5xALAq+7Ko2sFmiibMC9jwHXXdvnqvcwN0aLFZ6hSxaDCpzhCQmnNN/f9NM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 12:04 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,

Hi Tejun,

>
> On Mon, Nov 10, 2025 at 02:50:11PM +0100, Michal Koutnı wrote:
> > All in all, I'd like to have more backing data on insufficiency of (all
> > the) rstat optimizations before opening explicit flushes like this
> > (especially when it's meant to be exposed by BPF already).
>
> +1. If the current behavior introduces errors too significant to ignore, I'd
> much rather see it fixed from the implementation side rather than exposing
> internal operation details like this.
>

I haven't observed any significant errors with the current behavior.

That said, I agree that we should focus on improving the flushing
implementation to enhance stats accuracy on high-core-count systems.
I'll review both the synchronous and asynchronous flushing paths to see
where we can tighten things up.

Thanks,
Leon

