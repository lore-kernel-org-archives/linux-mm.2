Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692D3C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4287E6B0088; Fri, 10 Jul 2026 02:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF996B008A; Fri, 10 Jul 2026 02:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8E96B008C; Fri, 10 Jul 2026 02:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EEE16B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:27:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A28D41C7F29
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:27:44 +0000 (UTC)
X-FDA: 84971886048.12.61F6F6A
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8FF49160005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:27:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e5eEmSnL;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783664862;
	b=8QGCncUcTx/uAir5AVbHdZb0q9S0OGtlYQnGt+OA3pBc5LeGvvbbeJR4P6pqEkTRXwXchk
	FeYx2NdvkKEQZYFcc+ADkRtevGOQg0+hkp97OSKeKMfkdc4wCn3CFYPt8QrhRqYWdoGAjL
	ULCGF12EEUzA4M2FpLnOgQTIXxNyOoA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e5eEmSnL;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783664862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tofb55HHSG+cFY/phPEZpv9GCTsETD3jbHewnOI3aFY=;
	b=rihZKqmkQ7dG/5Re4AuXip4txmaiS4mV/Q5n03XdlS8nUJfHgJk6QTf8Z5UtGnn5mKYp+4
	IWHgLZzXlN2tVWwhI35HVWjdtm9YiyHLB5bIRfwKqpa+XtjdqqyA04hJzHMAQDrHiHqhKy
	jF0d2fZLMYip8whGncf3eZUvgCczhV4=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4703bc0a99aso290484f8f.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 23:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783664861; x=1784269661; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tofb55HHSG+cFY/phPEZpv9GCTsETD3jbHewnOI3aFY=;
        b=e5eEmSnLZpHhxX6bAtd4U/DjX9qhjpbOnn207uCeKIkchWHS7cs0Nfwu+1IrWx7L/u
         Tz+HcWaD7PvMCuH/inFHRFeLH1YVoekFUGHjvPTCLMn5bn8QE93RRjP+M3mhJkql4SYA
         PYSU8ZzaRuQ+pOxtUL6tbfNoXdqfkqAHWggvm942cg5KNqBUFYnF2hMjWtQBklgcmab2
         ugVCMPjurV7R8+umC4jBKaoaewwmPiR6IdD9yAdERcWGuBtru8jauZ01NVppy/q+fbfq
         2OlqukHBMbcZMXwsbsXTvt+hh6klLKV1hvMR3osgOuimDdZzHhQpDHSAG/0L0SckbMtD
         VgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783664861; x=1784269661;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tofb55HHSG+cFY/phPEZpv9GCTsETD3jbHewnOI3aFY=;
        b=Z9JB04SK9KLAIWcE7YxzjveQo589UjbNojmu6+29khnUHQHuPMWDudTCzEl0uV0mvF
         tw4u8yPK2/i3GRpmOALrJ0OfjwOinQVeaWqsuRkvyeHp2PNGoIyFqE2/tbemguZrLNn8
         EDf5lWaQxCc0O0hcoChhgSgo9AVKTDO11KEM6Ts9EGjV2GO8p0wS0jcR71ji7uCVjJnI
         atUQ9cLqANNcjL/3/57wG4Lhbx7q/GUPEkQYxRD75BvVxLAWJgRmuZQZXgf5sAKG15bh
         ZHmlSRo47ubRrrwej8TNiaHAJXzP3tOfMyyOgr3QmSAHwFTcY5ystrco5+0mft1bL1Ep
         MHnw==
X-Forwarded-Encrypted: i=1; AHgh+RrjyyP5YLXBCKGx0AtiDqJPsBiJZNumbmeZ/a0xstAiaI1h3kKpYILjuY+VAxOPpRVKy2ex2nXFRA==@kvack.org
X-Gm-Message-State: AOJu0YySBJBNDWS7K5syoHWc14mWsB7VcrWW5IDHKIBEpVHcp6gA8ouQ
	3zGONsPK0UOQCKgzleA0cKdzQHl6xNuOcQrll3CIHw9DkJrjxZLn/zzImLqM5uAoGsM=
X-Gm-Gg: AfdE7cnWpoUd4MPXA9RZg3lftJWYyz5CkJj25vGYWR3zzC7KbXkymsuP78zBmDBjd8A
	T4U9iiH+K5PsNqsQw2DGEZIjCwn3kryM9hWjMkE7JB7YtfAn33MH+ocvApmJg0v99CTFInq3u7Z
	EzyV7i+sQPBO0dsSFaORaBMHMNOypbs94g4ON6P+o/xvnq69vj5NkGDmQFMcWZaqxC5kkfgfoNV
	2Z3QewHTyEkYVoWQczvv/K8jjv4s9EPbwJvdAtbzdvIkuj+CMLGEK+jmU088EL7YGS8Jusay0yn
	YKhkROswzalFwifVkuD4eY/VnKrqpFzoUtlxe9CNskEBNZreOGhkA4q0vWx2B29S4jufxOvQGEL
	Q+LvvTLGsKPSzJN7PmZJBgcMFEXVXz4V6rkoEJ6oRhZBBYhfVc0YHefkgjMOztWhRJ9Zk4gl2yc
	7RUyE77cdHTf7x47P+ANZxf6A=
X-Received: by 2002:a05:6000:298d:20b0:47e:96f4:4a5b with SMTP id ffacd0b85a97d-47e96f44b24mr2183314f8f.51.1783664861062;
        Thu, 09 Jul 2026 23:27:41 -0700 (PDT)
Received: from localhost (109-81-22-50.rct.o2.cz. [109.81.22.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039ad21sm56217525f8f.20.2026.07.09.23.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 23:27:40 -0700 (PDT)
Date: Fri, 10 Jul 2026 08:27:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <alCQ28gBclWOFF4_@tiehlicka>
References: <ak5-qwmpXrYi5md6@linux.dev>
 <20260709072231.3163082-1-richardycc@google.com>
 <ak-OyACkE8lLaRRS@tiehlicka>
 <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8FF49160005
X-Stat-Signature: hsx6ujhx4mmnyyyztokiiw33sy16k34i
X-HE-Tag: 1783664862-576903
X-HE-Meta: U2FsdGVkX1/sXz++bqCZv2d5yEnAyYBiWdCCaCjOSe1Yt+G5gaCeh0QqDHRTrRSA/9IZRnL4nsvYyf9+oKJ6aFppZ7i7n+G/kGwxmhmRUMADTbQubYU1d64CG0GsenxPXkrON1Qb9jCuObLOCh9qtlyM0AqjeIRNhlCnYYPz9cYhJ3f1fk8ZKp6lC7f9qkUyNtxnbtjNHs+HL3yuhi37wvGFxvvbssvVMp8zv4dXUTyurSRM9tJuwRAdKGkMBt6MM+jsrKNryLHauFrKRiMoBARwtO9plEb5Y7Howcz84srAaKu24vmzODkTo8itJ5bt6e/lLnFf5I+28n7Bw4J0+OS+qliNZzRjghxkeKdf5InId0vSV/2q2pMK9whCGdnm8HyTAaO3mUxjJ8k/FxXEZ+61BvYq/1J92TQjYApctfM0qmnRv5ZYWJhL2mP8rXJrPGv1S+DAvakIaTpixAZCjwfKctoJ8bogB1qUxf6THaB9qVx5mtFRvzXZl25mG3vn81MF4VokUc6oxxwAwTdNomYYozxHIHJBnywjk12g3EAR2p0nYMqOhiXWgvAfph5zR5KMRsRSpqG/I06RItWjlyjfzqPWUQuPlR93fpU/dSTQk5z+vbyDXijFUz9+2LMmPsGds7lSu78CZNshrov4ImvCmeRsXoDqwFOGuZNZViHF/VDhHjeMjvhbCahktvir4J4BKg6JNLaiJbrbCl5y8ca9J1LgXb5MMVow4nNxUVJvxFfKWS2lzgKxXlfiZwrY7LXxyYSFzc0nMtlb369/5BWMmnBSaFP60XrlT6L3cxCvqwbo6VPUZdVITQuOf45PHpyd/QMmV43X+ipCPbSksm4akkMRQ+etIRh3+EeuHEFpHET7l+ZB++tUCXuJGDtnmw3tQ+VfQYwhuE4vriUyiLCv4E/2HPTMBUuxkB1C++NHxlycIiAA8QThOy8RBxtHf+xjW971UJw61U8Mllw
 LD2B7Rp1
 tAjH1lS6psyfj4umX/5O1ffCuqXzW0aHwFz8EbiXjQQ4LOt3kl80vZozzyNJnMp1WEAk/yOcmO8J9duAQEB7/ZwWycPiqA6tFD3lAUXAeipsf+g+UqUedbhEl0CKX8U4KH68wxFDo5597eruDPP2Oooazr1/xPULxxCm4cT5NaD+nHvvuToEjEQbFrFeu1NruyMSecagYkWE0akNzRLEvq99CyVvPXD2b3IbTXxmlDZp5zV3zyh/g29zLyNZpePtyHOeWLYmBD2U/i4L8Pmc4LBNNXlxmLWV5TWXiOGH8T1RNakfXJ+f3z9tKIPlOQ71akgDp2a1t9E9yFGqlNTAxok+pLWVd6ZgoYdsPRSFxVJfo1gM+NpDbSq5cdOdBqDD0tSK4EPmbxWNVVvOCrDTjN484HsdOhbtgyOAyKc/y2/p+fS74DAFbuTRwMDtfVHIz4z03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-07-26 11:29:25, Richard Chang wrote:
> Hi Michal,
> 
> On Thu, Jul 9, 2026 at 8:06 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > The changelog doesn't explain whether this is MGRLU specific problem as
> > the fix is MGRLU specific AFAICS.
> >
> I will prepare the v3 changelog update. Thanks.
> 
> > Also do I get it right that freezing a task while doing the pro-active
> > reclaim will force EINTR early return even if no real signal was
> > delivered to the task?
> >
> Yes, that is correct.
> The PM freezer ( freeze_task() ) calls fake_signal_wake_up(), which
> sets TIF_SIGPENDING on the target task.
> Returning -EINTR when checking by signal_pending(current) is already
> the existing behavior of user_proactive_reclaim().
> This patch does not change the behavior, it just allows the task to
> exit the inner loop quickly.

I believe this is a wrong behavior. Freezer should be invisible from the
userspace POV. Your patch makes the pre-existing problem much more
visible. I believe we need a slightly different approach. Should we
try_to_freeze in well defined places in the reclaim and turn 
user_proactive_reclaim to fatal_signal_pending?

-- 
Michal Hocko
SUSE Labs

