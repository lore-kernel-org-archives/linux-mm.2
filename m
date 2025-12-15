Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F9DD5B868
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB946B0088; Mon, 15 Dec 2025 15:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88BC6B0089; Mon, 15 Dec 2025 15:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86E16B008A; Mon, 15 Dec 2025 15:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B37586B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:22:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 630C0C0369
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:22:20 +0000 (UTC)
X-FDA: 84222827640.20.1618827
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 239CA1C0023
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:22:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DocYPQr5;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765830138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+y/OExnZJdz2I4sdpnCKdx4pnmEb3dzMAfFUovxakG8=;
	b=A8iAXFOZRJXrr1BWeWpJGmGJllHqUllzc5PtpgJSuiWT0k9ewU3L8v76CwZbPIE2sxyOXE
	GTd4HU7Dy2bh08V3OuAFjrddJaRSDHndWrxfrFNPQIEsCxo4P+Vpg2t99tBtPZJFkWyZ/q
	Yg0n6Juo+p3Q2Y14YNYZQJdBGJHEDWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765830138; a=rsa-sha256;
	cv=none;
	b=j51R8IZoQW7V4SG02kYlKZwtBhL+PdGZ4I/uXhJIOoKUlG9HLOrvL/1L9RQR6nCGI21rO+
	QF4tI2zB15n9sMORaWFDff3Ox3PPsP+wpecapXEIs4JEBejfL8xPUOlyJpf1Dc2FDXZ2wY
	U+vMFlAlp6TnmhwcsYcSCUYtGnUO0zI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DocYPQr5;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8b5ccceb382so432883485a.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765830137; x=1766434937; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+y/OExnZJdz2I4sdpnCKdx4pnmEb3dzMAfFUovxakG8=;
        b=DocYPQr5IQouKWFXaEG4XdbKfIoBbu/y7DlSkplmaFJdqNeEvsVws9QdcS62JU4Itg
         XgiaM+hAykztG+HLPsyNa24+/p+x+26/Kmz+Z+zT1LePM/n10Y719uSHjOONe1sFwP0E
         4/zpbvF72ewThIBJMnTR7wsn9h0QfTWjKoWTsQV5pbT5v0cocwfuLFo0saTrzOE8ovD/
         pICTVOmxzJUeZpUudw197F/tr5e9PLrlxB6pEANiP/1lVxmpRDD1rD+UaoWJvG3uSNBY
         gCVTqHMyxiH1Vtng6wiOt9ha2pkKyufMseyKL/gGwOpeelIUyZO54VvurvEH2Q9KKPm8
         3Bbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765830137; x=1766434937;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+y/OExnZJdz2I4sdpnCKdx4pnmEb3dzMAfFUovxakG8=;
        b=j75ZuzJZVxoUQn/fSGlKNISVxxgdcGDfKUjrN+l7Agl6eK0vbu98/nH0pLvnhBAkUf
         xMmVOMvRCtR6mMC5+xZKpzLpXLI+2pOPrEmiN56wdnkeNyzMFK9jPvPmm04S/chsaqzn
         pTqNa3KqaWDZCRIHp29rKNtQto50TAFdNvuzFklrbGKJFadps0t/vjLCBzxXyDRqKZoI
         PXVuz/9wOZ7wJW6TuLywaFdnsJvie1pXY50p5Zd+uFwNQqAiV7XRNtZyz19BKI6vNIc7
         kZ6JhIRo1L41sZDhRF2n3WfC+bakpis1dSorZsAMehE9Fsv8Mqg/rtDwphRcu2DGmdsp
         DZug==
X-Forwarded-Encrypted: i=1; AJvYcCUlU51HvmFSdnCEpeMGEEs1lkNQUZ+SM736ZoPsNSxL2fPI86n/YuX3kadB2Ml0fbFgwVrHOJSCeg==@kvack.org
X-Gm-Message-State: AOJu0Yz3zcfqpD+k3bsjDXzjx6LrPgOaaH43r22XZ4gLvlHL7MzPJSZv
	R+1aEc8PrfM9PO3ZaCuKOC6nM0TNu9wPa5O3ynrGm69jWevYHah8f/i/TvFFeuBcMIM=
X-Gm-Gg: AY/fxX55w2sBGKhPoCK6UrKvFqTIvkcZ97xPSbPNoe2Gy/d858yVAGdv7nIIjICZAP7
	q5V8eImRXCOPfLwBlU9jG/XFapYsgD2c+j4tqOOsyZ1JChN7MmXHljpSEoS9Nv49WXSyYup9QHa
	lVpvBE/VZPEVYpd6LEC6LqYoDKsQfNkHhTSPs4viPgUCj8776odYvOHTSx4IS+D+RAi5oq13OcN
	r0G1udL7hvXAgLNi1qLapKhHasgquFCvoGgvUY6q7guTcvzwFLdpVPTNwODnCFE3T7aBSL1OUa6
	MvRjhee5r0lNW+7Zgx2POA1Bmh+IqxKweh1lkCLaa0SgRzwf3h3Hv+jmwtS21NcxCen9/42gDZU
	bOV/4izP2aqUGw1BjefDvC/eYc1AkHUBF6ymEVgeEBZkvvKLjwW90deM0F8yCH5j53gsihmztUP
	9eeZ8YkPmbbg==
X-Google-Smtp-Source: AGHT+IFB0yWAs/WQa22s4hXXN/WjgCrjXwhkmj33fa4e6o9GlD3XRiZMrt6K5AEN5A7fpG0KHFBCbA==
X-Received: by 2002:a05:620a:19a3:b0:892:501a:290 with SMTP id af79cd13be357-8bb3a39bdadmr1752551085a.86.1765830137060;
        Mon, 15 Dec 2025 12:22:17 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be303e7bf3sm27079585a.6.2025.12.15.12.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:22:16 -0800 (PST)
Date: Mon, 15 Dec 2025 15:22:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yuanchu Xie <yuanchu@google.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, weixugc@google.com, david@kernel.org,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	yuzhao@google.com, heftig@archlinux.org, oleksandr@natalenko.name,
	bgeffon@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
Message-ID: <20251215202212.GD905277@cmpxchg.org>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <CADhLXY6tueNOZKqjWEKU697_pTGuLyiTdm48CHRH=W6udmQVZg@mail.gmail.com>
 <CAJj2-QHV09Rh+s2AgDtC815YUJUnYgTs0EE9YbDvXdPM9DsKug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJj2-QHV09Rh+s2AgDtC815YUJUnYgTs0EE9YbDvXdPM9DsKug@mail.gmail.com>
X-Stat-Signature: 7qxaurw7huzutzn39ijjnihqifc7kz6t
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 239CA1C0023
X-Rspam-User: 
X-HE-Tag: 1765830137-364913
X-HE-Meta: U2FsdGVkX189dvz4bg2MRcB86lms7d47SSw9WuUROHH+d7pzmp42Zex91d5GPG0SKLSp2ZQudZ77PKcCnjitS6uCzt5YJSTiJdZA4XGtO0CEybNOqugx805PniLXEGXRTOYds9i33rSHomn8NHWLWrZ88Rv+QmtLhZcuy5VMYdQoyxfnaTAiEAyrUF+WAoaf6eWq+flZ1QWB2iX9QiJHFaTvFw1tnj6c6XLON/q9mQB+C0lmWB8aWBi5U+UPf6qDkz7opqhsfnay8CTdZrJ7foMcsQTac4PTqJjuqUuONa80J5Bn4vUNl9cwLlGOuicTQAvjp7V+bayjN8iZqvwBXCMARU0oagYrckwpn4f4HtdvA4v4HlXib0Ep0AE7C2NUFXW+46yjQBwhMDb2a3c145R3iaZ0/4EGnWphNXArVumZibER9XZvoWjloGL+CT8/JeZyYKFL8j2+NB42E6gFzGR0GDcm0mEcssCiSRznWPIy5RTmf93MKCc6NYomSoEM88jUcBuieuFDn8Csc1zUtAIb6B2nVG+I5hMAoVPQejkzSlkvK14l2+ezqSMKmzvYvlHiwkb7c+dWcCJoRvf3mqEqFqDxUJFjj7cWSMuK58h/WoMe5wPsgQsTxG893rBDwpI1mGFvLyWACfJEocVQkqnKdjC366NC1Bzk8cYDBuql5PDN/vJ+jSg1VHOStKkgZ41j5wuiN4wIeKHTUAIk2QxKx8/xDj0hDlA16AqLOkqiCRy00tVaTrV0SVplfF9Fb60grIp6cVh5kDRIdguqqdEMtiqj2z/zdxfeyjC1b64X7ZKHYtPusEhK8h0/Kb15QLQUB+JQWRVYEOgN0fdwUxgurBrPNTYHa8aiSuf9ehjMfzvRa8kn9KNSmY8TreRg9BD4ivdbGDg/wXei1IE0AlIT4DH20n+wmv73WE/vu+opmtFvqa3FO+gqcOz5EuqA422rXiPNpVi4f6qzkT1
 nTN/ev87
 0uwWNWtfatQAOoeXdZY2X+WDpJ7GES5OHQp9akMybSKvtM2we0iKZitmme3cCLudcm4La4Q+i2UiCn05GBYF8zgYbSOus/Y6BR3YrDSZQ4VY2/BmCId6de9CNC3xXbOL5V53vCFA84FsfyOEZ6hq+moB00X0u1Q41bKPoFGOS/F5BQr4elCVimBFxTSM+6Wtac9nxFvLKXLuvI0R47gbmea7vR+wWtLnXYGq8pORwLG7SCBhXiMhr9wlPCOyiGwyswxuBM/bzPRXJnEvizRlhQmCLV1LwxYwMoamVBl+VoadFKcATH76Y4v3ukQqn7hWlRdU+xRCl2M2JnIeFuamuE9P5u4Sq6QjZkuPu0cpPqgN2dHiNbJCLEdUX7mUP/3EM10Iav/xaN5IOwAdV4woO9+gsXOVUvF/4NrL6lgYzE+qCrquUzL8OCD+DdzytLeUaUBO79vZlk0Mxi0sb2nVd8e5lFRzsN59Q4QQsWv01AbqJwbLuVHnGJ3msb5Ofd7oy7hyirgjwsN7DRRrozrfyZUh+AXuRPGxtNGYKnZHiKdDhiCae8ecfYEEEYKizNpjvav9u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 01:42:27PM -0600, Yuanchu Xie wrote:
> On Sun, Dec 14, 2025 at 10:52 PM Deepanshu Kartikey
> <kartikey406@gmail.com> wrote:
> >
> > On Mon, Dec 15, 2025 at 9:42 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > >
> > > That seems unrelated?
> >
> > Sorry for the wrong fixes. Correct  Fixes: ee814fe23daf ("mm: vmscan:
> > clean up struct scan_control")
> >
> > I'll wait for input from someone with MGLRU context on the broader discussion.
> >
> This warning came from commit e9d4e1ee7880 ("mm: multi-gen LRU:
> clarify scan_control flags") [1].
> 
> The original rationale:
> > 4. sc->may_writepage and sc->may_unmap, which indicates opportunistic
> >   reclaim, are rejected, since unmapped clean folios are already
> >   prioritized. Scanning for more of them is likely futile and can
> >   cause high reclaim latency when there is a large number of memcgs.
> 
> As far as I can tell this was a sanity check to ensure
> `lru_gen_shrink_lruvec` avoids extra work for minimal gain. Perhaps
> this shouldn't be a warning? Always setting may_writepage in this case
> would free more folios. I'm not against removing the warning either.

The premise doesn't seem correct. Aside from laptop_mode, they're used
in those scenarios:

- zone_reclaim_mode: local node is full and user would prefer clean
  and/or unmapped pages over spilling to remote nodes

- watermark_boost: the page allocator finds itself in a situation
  where it needs to fragment pageblocks, and it calls for additional
  reclaim to get out of that situation

Neither of them are opportunistic. It's user-requested behavior.

