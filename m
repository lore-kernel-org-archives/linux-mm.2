Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C56CD8CA8
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5222B8E0006; Thu, 13 Nov 2025 11:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9AA8E0002; Thu, 13 Nov 2025 11:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FBA8E0006; Thu, 13 Nov 2025 11:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF558E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:54:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEEE6C0ABE
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:54:22 +0000 (UTC)
X-FDA: 84106181964.04.FEA3BD5
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9636180017
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:54:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vt7S+UOk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763052860; a=rsa-sha256;
	cv=none;
	b=Ho2tMhZVGdpHSHr8vOEj27JW29p0upf2ii02zgg8663UuNrE2vwAwb840OCNqP8m3lolx9
	d1v0XqiG+9799XXwF+IFjauHtYwU6yG3jBw+PpNnnvgEX6TPUPQDrp20pdfkh7Vx+O682S
	tm6mlO4Vd8r8YzOkiyXbzWsJEQ4fEvA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vt7S+UOk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763052860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etMtDfwD+3QZuYUqVZKqjI6mrl2ackYWEvqoK5GuUAQ=;
	b=z4S/FPXUiFMKInpgLacW+kuXV9lElDRhjZectNpqd+Tq/FKHRB/V7hfq3msLsBzyRpY5/M
	YniMppsnB+TRWgqBu872IOiaT6WiPcvK1y870D60mzTG3SSVemKenctVjuM1ykWeudTM8k
	5qmQrGxN+vlHm1QXkTwBo19Dlz2jJXA=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-37b996f6b28so10034951fa.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763052859; x=1763657659; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=etMtDfwD+3QZuYUqVZKqjI6mrl2ackYWEvqoK5GuUAQ=;
        b=Vt7S+UOkEGBSi1SCJXmeAwS2RPFcUMbfc4WLfUSGsfM6YKUWXEOomkMR5Oj2lmhhL8
         O/W24nQHAQTEMBMT8WOaniLWLoegP8Fuygz655eGbRZsLpFwsAHcX4XbOrwhRFdCruQB
         3MumzypSaGnlzDotglaOClsQ6KFKdjpsop959rIBos3O96BbSIG6LNVGJ25R7KYh3iZl
         YR4Oqg+IF/GQpZunfhHvk3Tvlh8JF/F6+kHoJx4RJGhGJ5rYk0dUuNeY5lIQbKYcFcwK
         reW54nYyGAIyxtMi5SrowUIojhHFc7YnSrwJD1bt8zRAE0ng/dyzWTi4XXm8qMy3kDTT
         4mTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763052859; x=1763657659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etMtDfwD+3QZuYUqVZKqjI6mrl2ackYWEvqoK5GuUAQ=;
        b=mBUw65hgqWBuiIvfQ+O2+Sej6Wm/DTuIKPl7VsjnEU/lqjLhJuduqMEe3s+fxInOEn
         80Ta5vbYT/pWN5iljD31D5mDkxNfrjNCcjG2gr0nu5x97rD3TpnFVl3cHcSFH2lWzXlY
         MmK/Gy4sFcAamjP/TBQ+2bl5YYkOSqQPbu/eZK+Mv4IprwkyjjDN4gdUSvE9dM6igQ3b
         40lMvbwsn17PB459UckfX+BzYQSesmek/O/LaUN+FLnlNah5lmi36RFGr/aMHRSk6Ifn
         G1WnMmJg0FAqhv0pe1qyqqQkzeyGbn61LOje02WF1tJty3UnOa9JmX1081I6c/Ab4HiA
         1hOg==
X-Forwarded-Encrypted: i=1; AJvYcCW10taB8cirskh1FB/0nknTa+UBYpkCdljeAZNli0IQv6MaaU7KakQ7/kn29RPtaHCJOq5YWpPnbA==@kvack.org
X-Gm-Message-State: AOJu0Yy0DiiJfi7RsNaWxHKMYyK0BOudlQmn5SuKjXYqcr6LvzXQxlTa
	pvZ3qBQGzAoy6KNJqBhLXJ7uwWRAbSS5jQeBzLzo7EICw2JwWqBlNf0H
X-Gm-Gg: ASbGncuw16mBc817YM9pCFZrFjqNabrWPDPWUrEhsVufbzIpgJ5ryfPxm5ZZMsoe0kv
	FoAnGQ1NGP7HyP0cMzOYqGKtz+oforE5aVO6iLRal+BY3UTHRGV7LjEIE9rQ/QbcyxTNzpvYqdg
	wVNrVyBzx/EWYJTLdI6G6+Lvafb/HEmOg9M2SFNGyCiWx/FSZW3/w0nJmU6NTiTcq/51wzFpp9/
	5DQFIEnB1iM2mV2DJ8M46lh8VabtVcXJLg0/t8zpMSII+dvBkVtHSqSB3PBHwsH/qJWATWCMBG7
	eVLIaKRRM+xK2LNg6+rTs1o2kZ4/t0larQEYRT9B0jWU7fIF2Hw2E/RYipAvGl9yzmi99nhrL+s
	3LdQ2X0pwl9khdxJY4ismgl7fqC6qWa54Exf5CMoMm54=
X-Google-Smtp-Source: AGHT+IEPT42mAJ6MUQqgjo5ZM8rlqgnxDoAaqQlhU3CiG0tihICqar5Ppn5XfbeoxErgayfhRkMTWw==
X-Received: by 2002:a05:6512:b20:b0:594:35d5:9a1f with SMTP id 2adb3069b0e04-59584265411mr32340e87.50.1763052858346;
        Thu, 13 Nov 2025 08:54:18 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5958040576csm507458e87.88.2025.11.13.08.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:54:17 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 13 Nov 2025 17:54:16 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	bpf@vger.kernel.org, hch@infradead.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRYNOIQ0A4g6BClW@milan>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
 <aRXeK_C44xGb3ovg@milan>
 <aRYL6XVX5pfhLqBX@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYL6XVX5pfhLqBX@fedora>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C9636180017
X-Stat-Signature: kjxqu8scthznxwyw68tpkwchdh5h3wsd
X-Rspam-User: 
X-HE-Tag: 1763052860-216762
X-HE-Meta: U2FsdGVkX19B1iBK0Xp0eWa9IEsZklfidKCa2w6zP0sd8rs2g3Pq34neU7R4JQhhLYbYXDDF2J1z+SbfTbl07xch3GjKkaJA3jUY2/hSVHTSbfk+SYA/OSMoItvl/l19rolomFn+qaeYKWzDiCbJpsDv0kK++I3yheJejY5OkUoiOY09F7pOBlDFvLDFUMxPiqCE1/zh7OmwYdi3MWOVJ185YxrEYr68R3hMPNKU2qxmP2D1rgkaEdw8ENXmyF4uHp5ZtMsAmp7UFKt/aY+CJ+mt5xXAFnlI8liAA10IT1LCsjg3OK6e5QirXOb60f4ii+VnYeVLKnCxfMRzZSnHe9bPhiLAfF6r+DNmDpVo825iofHqw8u99c2H/fCs2mvle5syXdbOMf5lnGfrv6hrFIOQ/0ADGhugJbnjOQZmZknZVsRfpltHfWuxnkJ/hNjGhBba3xkHAS57WGejynLzJAFgQK+mrkqjBBxFSXJ1RJ/3EHLSt1nRueUqwYfpUH8a2sgZltM2oYTBKPF7IB7jNYPLiayj5O4X8vQjf/pwszvbb+uIDG7KPuS5C1pj2QA3Y3T6XARwUzSf4tJRvf22S+53he2SF25K3bZX2jfU15JpneLVXmHFsFSeZbsV7xlft84KOS54D5e0FjLgYo1wbA/GYZBEE4quok9padSkWsQSxcYz5F/QcqX9+seQF4zr8C5R0TZB1KH6u7Oq7yH4fEgAmxyCMlFm7C36oFGApjZMjqrLoQ71l6294EWg4JKl7ZuzM9ZjEFw3mvqVd5afVZYJZ79CCkhsf+7SoTQX5W9hIgIgixSGTDxX0L8LRfTpLL/y+O/DY4VeKS6wlhBMf0vEdowxsyPXdkUV3kXCN+6HgN7Oiel1LugGe3IvVorv7nRRHHcrodUyO2Qp9zj+2/tXipLzJF0ux7chkyMruSsjILzQhGTe8mfMJ5WYeRBletaI1Nh+cQk0k0QAZab
 Fth9Akfn
 Lh8pdkzR2UPYRjJWfhgOFxEnG65GxK5PH5B71BxfsG+jHgjTL7NJoTbDFsDLbgxDihg8XUFfBL39gcIwX7lpI9nj55ldQbGvjQsHvxl/saebhtVAfghsyKNQR6AVGZfn6VE92vASSwoPlWirSgtRxLkDzo6q0sblHysKrLGw0RBc+2298fMkyBBPIGID5Tugbj8ggix5zzxPLSK5cG87SW1AXZoqR+zbeZ7zqFHeP2IYdaKVCJLIvwc1EofbUD6y6ylLLe4Ut9M1IJhGOUzjzFMWLUNnNTalA0w4N81wdAmQV/lgk6GEEEPAPuwyX6TExsDWi3CZRdefG+3qJMi+l8NoNXFEdav8lmo/RHjS+4QndT6tLU0L3yKCOsxYJnc6eq/PUEH6wIbfFSm9uhZ3DX25w+hDCXdSHX4WFgXPjty6OoABxpCgXYymRBTSJK+0bLjmbRn106WR+mOKeaaAG5pZ90vH7bQOrD/7Dn5itTRy4UjTXeoB38IvHOvp0OX3VXWa9xUXdY9DrRJLyrxzekoDqpj8nO6Ovac1F3xdcwEV6pVh1Zj7WYmoVhRSlSzIdpIVRkKqWrbiRRJxADyNPsjRFbKccfvOY1M0HWTA8fxQMS0pmjGmZ8Xg2cBYb3t1n+5S3dYDkFoDToPddCef3A6hCn9ib1X14y1GFF38yJH1XLCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 08:48:41AM -0800, Vishal Moola (Oracle) wrote:
> On Thu, Nov 13, 2025 at 02:33:31PM +0100, Uladzislau Rezki wrote:
> > On Wed, Nov 12, 2025 at 11:41:37PM -0800, syzbot ci wrote:
> > > syzbot ci has tested the following series
> > > 
> > > [v2] make vmalloc gfp flags usage more apparent
> > > https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> > > * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> > > * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> > > * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> > > * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> > > 
> > > and found the following issue:
> > > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > > 
> > > Full report is available here:
> > > https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
> > > 
> > > ***
> > > 
> > > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > > 
> > > tree:      linux-next
> > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> > > base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> > > arch:      amd64
> > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config
> > > 
> > > ------------[ cut here ]------------
> > > Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > > WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
> > > Modules linked in:
> > >
> > Again bpf :)
> > 
> > GFP_KERNEL_ACCOUNT? I saw there have been __GFP_HARDWALL added already,
> > IMO it is worth to replace it by "high level flag", which is GFP_USER.
> 
> Yeah I'll replace __GFP_HARDWALL with GFP_USER, and add
> GFP_KERNEL_ACCOUNT. At this point I'll just add GFP_NOFS and GFP_NOIO
> as well so its easier to understand the mask.
>
Sounds good!

--
Uladzislau Rezki

