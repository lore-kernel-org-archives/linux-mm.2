Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A26CCA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63706B000C; Fri,  5 Sep 2025 05:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39E96B000D; Fri,  5 Sep 2025 05:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F8C6B000E; Fri,  5 Sep 2025 05:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3B2E6B000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:20:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A6B8140607
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:20:37 +0000 (UTC)
X-FDA: 83854651314.26.B114E59
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82351180003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:20:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Z76vPVV8;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757064035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn5dEdZ+lZHL1bSbN7KhfCFXfCyJi17J1T7WYwt+oY4=;
	b=Al28AbRVOcTl6x1yV9IQLS1hXagfkC6MQqanm+CRwMOktvaEvHzHNtnCBb7Ua4nwO0YWLI
	FicXh7l8liEQD03mXRmRDPWEsyucyq1CAilQtXxy1aro+Birr3uRpIglFLw9NfV8S6H4/4
	W4Awmlay5s9Yw9EnJXA8nz/RKAo3nH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757064035; a=rsa-sha256;
	cv=none;
	b=iY/U0XIs3lIe3bXUP6P2I8t2tJBMTu/p6wFQr0oRmiS8FRcHw0Z92JSCmz4LF+r56aB4Ba
	FELYD3GkuDrJ5NuKQ5xLA5aA16gqvj9QGtqxNnKW/DMQku2tqgRQG6MHdsk2UZRWiLT6tY
	/Q2quSYB8xjtA8OlDToHiIDMNXoeE70=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Z76vPVV8;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3d1bf79d758so1708190f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757064034; x=1757668834; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cn5dEdZ+lZHL1bSbN7KhfCFXfCyJi17J1T7WYwt+oY4=;
        b=Z76vPVV8BjshUi5iM4MJr1VnOSq6B5bq0lRaTxfHpfoV9bjSnXoLBb+orcNMTpNe39
         BznJKRqSlA20gSYwJLkhiz+VY2DzD9zMfO4H+cYr3bxAfSfhiCPxtRrdwy96SuEGZqBG
         JZTv9WwAT5JRfHE4oIkthUNVKZDtYFATX8TjwNqm3pudvfEgdyF2aGeMiduq1oQML6Ze
         TLEHmsGByDg2vE4OXOIqwqUX1f55lIEBJbwtsXhUJKF7AqU/U5SRcHuOrLh0x7Lg/Ck/
         iMtW6PekXOUjed2Q7pWq9tFzl5TEf0Tpnqpf/I8fV5usz+NfQXjHCkFqycFKRMu8kgv+
         S8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757064034; x=1757668834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cn5dEdZ+lZHL1bSbN7KhfCFXfCyJi17J1T7WYwt+oY4=;
        b=qklbqrl1VIMx3o+P1RzuGSIPPhJyEyLU/rMI4xKxY3+jOpg898EW+EQ9lKQ5PDixkw
         SuRGqACgL63esY6Lt/TyTk5mJKgyjdJhWM9jHhwAlmpkElNYGkJF5GJTZRIwDQsvG9Rx
         o/YYmwb9fnL7Unw1lZVTOIkRrDcHkHn0A7V2MUBXdd+5/DgHC19k6JKmtk/bv1UquOlx
         AcmKOmv80oQKpeLWxjN9bsimmWIB0QZejk2G09i6AKrHPiJDNC/AsOuMZux0B/+M6vh1
         8wn0WNLvvbpEkz+3mFXntLWWWwiQ82pbQfyLrD99ktCN7xohW1dMZx1lG7Aljh5FaJKe
         oiFQ==
X-Forwarded-Encrypted: i=1; AJvYcCViUHEnUG9cOrnGZiwWGtd+Tyr5adFrdqhUCW9+y1LGQaONkRJmO89bX11WoKRUlRY3xANZZj11QA==@kvack.org
X-Gm-Message-State: AOJu0Ywf/VPJW3GugOW9qHQixi4HF8VDNJNUySIG2p2m7WM3b0U1fCh8
	G15gUGJLDFS853Wp1qC2nY2KyPN8HgnNZ18F3mrH7jx1m+Gj6BU9eWosMTGt3jFEwoo=
X-Gm-Gg: ASbGncsnNpz96Rht/7KHJyZi5lbfuv46IKD2ty1eW9vDZMhWZVj4Fkti9333N5ym9xH
	p/DRRd+mlQembh4mRK5ughu/6iZ3N4E/455uFroxaXZqkny4cmWrmyR3e2Hhr8draVtfT0fTHUI
	CNN32FY8nIeG1uofcrWDcMph7R+W1StZt6IO1tOwCDqBImFeYez8FiBP5/gXWk0XFDguCbr4vjU
	wkoAZMtPDyD9CmVicpR2vKv/fzPiEAwsOusx8L4zPgiuBaJ2NkrYbNHwTiRIOykapAET+rmm7jp
	Ql3YzdiZA2SeQ+BymxssVhCbnEB5xvETLaC1eShC+BGbhP8rXSdwhcBbvjHfJl6M2qFX7ep219n
	pviWrnLOOgahFgk3SNIjy8TjnYL+O+o/B
X-Google-Smtp-Source: AGHT+IH/8fhX/fgj2tMYfhp5tk0xz7+PqaSeuV56lrf1jk5bI4HL3PlQBpwu2LI3QZpIRCEAOgjxYQ==
X-Received: by 2002:a05:6000:2f8a:b0:3e3:921b:659f with SMTP id ffacd0b85a97d-3e3922aad5cmr1139388f8f.2.1757064034085;
        Fri, 05 Sep 2025 02:20:34 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf276d5816sm30579447f8f.25.2025.09.05.02.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:20:33 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:20:33 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com,
	shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, lorenzo.stoakes@oracle.com, surenb@google.com,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aLqrYbsLzdr8tXe7@tiehlicka>
References: <20250903092729.10611-1-zhongjinji@honor.com>
 <20250903092729.10611-3-zhongjinji@honor.com>
 <aLg7ajpko2j1qV4h@tiehlicka>
 <7rvwvuifkav5oz4ftfuziq23wek2bn6ygvrfotpaweypuy7obv@hjuf3eknscii>
 <aLmENFH-g9MUQAsE@tiehlicka>
 <a3hgvhvix2ulzfof6d23f7kzk5clsnea3grmd2wowjyhjwuiyn@ymzvkqf7gcsc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3hgvhvix2ulzfof6d23f7kzk5clsnea3grmd2wowjyhjwuiyn@ymzvkqf7gcsc>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 82351180003
X-Stat-Signature: 1pnynj88xqoe71odwounxosneb8gotju
X-Rspam-User: 
X-HE-Tag: 1757064035-465559
X-HE-Meta: U2FsdGVkX19gpRN8srwYygyhlNIEkJTovtBVcOupAANs35KpGlIRRiggpHJAbaBS1zk2n2iN7xgpEY8UqkVbSqv7mF0vTbt6ymymPpc66PCcS9KxWb6YUrtDs8aLwUbdTO4VjvBo6waLHSMR7L2qxxi8RM5f6xbndNT/V3VnX/LJDx7s3Y+RgGfcWyDACkUt94dV3hrgx3OW6YcwGoXWtyxVloMeyU+ocUgIei2vyqBblfTUe83rXq6qwL6iWy08B7V2IIW2q5kb3wZqVRrxRnFmpV7o0EBlDSKwJy6Q67VcYp3N6k0EcYfLcG3dstRb/M1c9NQ21T2ikAVOqBcMHfGID8hLQwQMlPyntHN42PmCY9H1OIg5y1t0N/MBxp2r6sZRbUmkQLlKBc4Wq8nkAtMUL9DzhbEWAjCG458Q3wiA8DD0qTgt9gqm/5fb2v1221d9CkNXnBmbEGTlmVFDz1N4Ujite9nQRmXDNj+GHIHWcgNrjVoa9PqIRi+HA5gPCnI+le6HEdzatzxOFFG4znqx5bvc5tbwLwIMZ/evmHyWZrLykZUnyRipOD5PgUMyYH8E8t7FAauafdQ0MV60DkUwXtBVyeGxk/h0gxxQ8ZT7mxtfJjArld4eEh74iGMOx3oTG3KaBo9uc1y8OIDlhXHvovhci3U5ZLa0S7LQUuf6Tcer12fT4Vh/p6tsEU9b1Hl0Y0PlfaKC18BlLOQbKtgQ8ctD83x1pjcurFl3vvy3qYMygAfVM05I6XcCA3wrtxZUskjwhcrJn6AvPrpsAXPBEcNl7pppT8yIJvmdHi0RclOCeUfKQqiymPuv4J+dWH2hc/r5u5O0B0Zv/5fNgRAODqmf8p5xRtXtyprTcQemjgRLCCv5FwvHQfneBa/fg7UywIhYwgs1+tfLZMH3toWJqxU12qkdlQincLvvvURgc6Aqn8tl4aIB+3xMsKCRC6vg+VmR2o1nbCDcIMH
 PyPIP4qg
 KOYQkatNcGlNKyomcsZ+A31oBrBGocnWJ9ZLaP/1aCY9+vWq/dDxznIuhyMoV9bjwKiMv3swvZ/JHh97SDYRuClmaxMfy+TBz5taoulNqbwKJE1O4FIRu0rDhbWwc6gyx8ubzhU2j2+OyAltB4yELHgEOqs6XUZgw5ZrZFUhfIUhXzjx0JmUB8s9SZRzId0eUoB8NgDgwWZptmDUm/5GwOtjFjOO9Fy+CQwZykuQkR3ET5fDR6DgoulmMoM82AHPZI4L1gaWm5IPts1H2zh/v+Gb0/1jpOESf1U7C50EcyvGzY0EmGbl2FcjoQ2fwFmC3TnoseJgopDsK5Yt0XE4Z/T8tRsGxr61dWmeIbkVbmqzyvLFGlA/6yJZe9cZrOXPl1dwWKl9h+qEz3O/eY+OuVYmk9nMPxQ+qm7MhJNskx+jHtgs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-09-25 22:12:48, Liam R. Howlett wrote:
> * Michal Hocko <mhocko@suse.com> [250904 08:21]:
> > On Wed 03-09-25 15:02:34, Liam R. Howlett wrote:
> > > * Michal Hocko <mhocko@suse.com> [250903 08:58]:
> > > > On Wed 03-09-25 17:27:29, zhongjinji wrote:
> > [...]
> > > mmu_notifier_release(mm) is called early in the exit_mmap() path should
> > > cause the mmu notifiers to be non-blocking (according to the comment in
> > > v6.0 source of exit_mmap [1].
> > 
> > I am not sure I follow you here. How does this relate to the actual
> > direction of the address space freeing?
> 
> It doesn't relate to the direction of the address freeing, I think it
> explains the perf data a bit.
> 
> The exit_mmap() would have a decrease in mmu related work while this
> thread will have an increase, I think.
> 
> If they race, this thread gets virtually nothing while exit does all of
> the work.  If they don't race then the work is split.
> 
> Does that make sense?

OK, I can see what you mean now. Thanks! I believe we need more data to
understand what is actually going on here. Having the overall duration
should help to get that.

-- 
Michal Hocko
SUSE Labs

