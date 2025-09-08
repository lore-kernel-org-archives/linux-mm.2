Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3830CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6858E0005; Mon,  8 Sep 2025 15:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDEF8E0001; Mon,  8 Sep 2025 15:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3F98E0005; Mon,  8 Sep 2025 15:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3EA8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:48:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31E9D57E90
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:48:15 +0000 (UTC)
X-FDA: 83867119350.14.9C9D96D
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DC5C4000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:48:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lw7F8inX;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757360893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkWutJuoMHFChanlNo58aMCO1DUKKA6gzqFMsdXKD24=;
	b=gaY5B3rf6GNXosZdmg/HN9mZXjEQNaqdLTBGtXBmMr8VZgKoB3aMKxHqiqX4uKKbBVQV3z
	NKNAPiQ9ua5jdJL44vM1Z8mb0/vIbsyWuyAcVKNKO5EIEqL5T5J8TxbuydV2Vsxn4e9qKe
	OIOnRWptVEqFELqDqECvtUr8B041WMs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lw7F8inX;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757360893; a=rsa-sha256;
	cv=none;
	b=YvFiYIFgD/4DJFJlrZQJkMgrAoIqNYbUAnwrk6w1eiqZdess9dOo4rYNvthO7J+ppHac8I
	jz4xwEKDIQf3uj8ycJFdcUWgNFCNGMt/Ii1OvO+L1wB/Q51MO6OZ0HAL+9pw24B3OKJ4a2
	LIy/WmFSLa+a7HRV1E172xsgUskzlTc=
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e9e137d69aaso2070562276.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 12:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757360892; x=1757965692; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkWutJuoMHFChanlNo58aMCO1DUKKA6gzqFMsdXKD24=;
        b=lw7F8inXRvEsAXJ0o9ObxIVBRffKHDAj8r3fkvVLdV9C28l4U8Tj3FAd9P8q70M6qv
         dhVK5MGwRSoDywFEZ7Dtx6g13zZX0d+5+sR+f3ejSjBUkIe86IAD+uSelLOJcGJtFVcc
         4Vo3n/RJnEejRg66ImLMIxCjCFruSHv6j247AH5I8CQjN1Q5X3y2nUDlRfPNTeu+Sbas
         YJh0O0++Cc2wBzzH0iY46cUeFyW1GWsSIhzzNRB5PH56xRPkixlZhy52bdGZcroeKWwm
         Up1rkvD5CruZFRoVj27JSVzL7urPEdiibRZXoi4MpfdhXnWg4vGwkl0TC9XVVEWHaKn4
         Mt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757360892; x=1757965692;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkWutJuoMHFChanlNo58aMCO1DUKKA6gzqFMsdXKD24=;
        b=IWS6mUlu9q+SQFemmDID7O7RXu+91ljQrCi+jnIRr380IL1WeGGYOO2+vOgkP28DCV
         o7mC0xPUsWMZn63ksNUpzpw+8LLiwgOd+B0T5Gt6jUWD66KsP6/AVG7ota3EBQ3rVdbW
         1m9O1Z4tPwK5LKFAS02+4IRqTr63irfwPot9xaazUfONAhgqq5H8P3zTG5CYak9txGjt
         g24UpfGEj+AgsR6Gz6UQgSQ/TT+9kGwMyBlM7AgKCKXUS7QZsa0KXU1j1wbtrUX/lgOi
         nQsoR8hzumWWDMNka9Dds9cCGFFt/hJxbnsRppxj5zPdTOGjZvBym8QSxvT2ejEtJgXK
         /tkw==
X-Forwarded-Encrypted: i=1; AJvYcCXS3Mgctb6J7KnH4zAABFgDO+uDljptyx8lD5HE0aBIoFTY60AKkab7g+3orXscwMXyR0UxCrSaMw==@kvack.org
X-Gm-Message-State: AOJu0YyZNP3vws3xpVx6hDdrdNK+f3LNODIg868/A2zHOLV+f2vv8dO0
	YqZfFRc8FKy0bnG+KAuStoiFelaiWwaguHM49xEY2FTxXoofuMn31R9QQlSFVL62vA==
X-Gm-Gg: ASbGncvuTpNTXE5keIrE6W9pAVbyZkbJHUfcgYMA0TGYA3+2KD/hemYtBYU0Qi3xQ7r
	0hZ7Whc6mR+Tg+a/EQtfUJ2Sg/ebClZD32PVpHXcAHIH5wwlLRntYzq2gj1jwhPdk1LVBDW0kUm
	sxhBMIiZMrdQ5YeLiU4HKseJ6zaZfKkyGLbpekx7PvbdbDOjZKGI25VvZQZLZ32MyBThy6Ab+1m
	/cNW9p7WvNwRI3o7o2PAany5ywledHQhc5ZXCeEVJQEJuhFcxqKXcrOzV7EStg/6RhHXRz0d+Sr
	VGBcMGzWgD7Rbf8K8uaJ3R/WqvhOXYOMQxD2lIiZhOsF2vUCQURxXydYfCJikHnSqw862EgW21p
	AwlWJVENM2LRoRliuxLtlZyqONmsR+Fqr06PnF9EEkppWwh/in2e4+G/TBGZKKz/H/4+Gv/8zKt
	ajHnSDzCU=
X-Google-Smtp-Source: AGHT+IG4PW91kFyjbmPgXJLgM5A2EFr+Ploj908V1ZohpTeRJB9+gDbvi/48Raxp7i+jqIStykUZkQ==
X-Received: by 2002:a05:690c:3681:b0:721:29fe:1d49 with SMTP id 00721157ae682-727f5a347b5mr89278617b3.52.1757360892016;
        Mon, 08 Sep 2025 12:48:12 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a82d58b8sm55941157b3.9.2025.09.08.12.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 12:48:11 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:47:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Matthew Wilcox <willy@infradead.org>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>, 
    Shivank Garg <shivankg@amd.com>, Christoph Hellwig <hch@infradead.org>, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, 
    David Howells <dhowells@redhat.com>, ceph-devel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when
 PG_private_2
In-Reply-To: <aL7w4qrJtvKE1cu5@casper.infradead.org>
Message-ID: <685fa6c1-e343-ae92-b673-48524918548d@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com> <aLTcsPd4SUAAy5Xb@casper.infradead.org> <52da6c6a-e568-38bd-775b-eff74f87215b@google.com> <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
 <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com> <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com> <aL7w4qrJtvKE1cu5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: fn9zh7hqz58hiw7r4gg76nf7prpth1zf
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DC5C4000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1757360893-969775
X-HE-Meta: U2FsdGVkX1/O+Dav0s4Xzds8jbFpUBaSfWQyQfzr2qQk61plLEEAc2dvBBDwtWC0O7EDHzJCxY/6mNXocQvb8e8kCxGue0sC5ojuCm1z9gN+PJhGp7X4O0RumvbWZ0C8yP9WYGELfw64tRF3YjL07r1UuoZHlVtCXhw/784aAYjV4L/LN7FGGcoIl5LFtu3Jv6dS5EzfVPCJBp82Cqhtuu8fSShaN1HkY4cgCd9kiB6MaACDOaRH/WKuR5vvheGPNwnTXHYBne/TMAx2733ZCvGaAEo/x8J6ECElXCTREHo2fLTyANsGanG6ZaAb5vL/g3T2kG3CkZb97VbWgS73x5TKV6BOyYuE8HoJ6Zz6p7bLfsDvpekb0DP6j39UEnOqqhX2YQ2qSl2h3BrS2Xqm+dq0c4sj/pjVgREJLZc8RjRFr0ttIunGexHpMWbaWxbGxFZ7qZspFXfnxZtrqiBgOqUgS+NjYd+ncV1omt6gN6RntdrHLf+2MQLYcEmgVVpEu8dlZFJ/aXAUf77JPdou3OvWXXp7Uk+D7jFcRxlIw3Yi7F3E2Dao1W57XD3eku579uxuK68dyMmJEtEQ+6aflp0zufKfASOYxRHZP29cf/bJCWtEUhwpQHiKZMgIt40Fhn6UZnBEL3pTPyKty9Ck6a3eggopE01k4te25RwW6EPxyYROebdUKBF0Iqd2pflgWkNHPjOQpkIkBk6jQqIl8XnwjTUiKcN7CxRmZRHZM23EgpVgky/ex53ef1920VZ1sFt40CWWwwvY5qTBYBB78BRy3EgVPmu89vS02tOac5Kt8djT5lFBRd8tVU1UID23u4347XhHR+xr3SikjDi9CWJuofifgu655IMbEMPljhn+NOZ13GMuWdsnDC+48ZGkVlLkowY9feQ/c4Ri5RSOgF5nfJroKakyEjs43XWAldPR9htTQolwVnOhRZblGd7cb4cp+N8F2PWrM81fG8f
 g6P7wwm0
 v359pkig9GszaLsIDvVh8SSRf1ZTFIQP/c2KZ9pU18nlWvfGe9EkpmEuWUXqzqlaxDlKndZXV1itqGITC3VaBaI3YJnoIDbLamSU6L4l/PMU8WnOAFkchwuL0po4EmvgFcI27p3l5OIcaYndrs1x+gPl32i74IWupUkVwMSHfnWcakLgM7bkOebLnLoLm3ecZGBlSsiImZkOqPKJ32yVECVCDvrRzKXgb9gIyhQU6m/AoDQrlRQbaaajt55Z/78Ia5lv2IHZGbGow5oXvwjXPU00Wif41SdpP4XjlHucZcJyK65TeCoDK/UU5oO5PaOPdzrLPCBURxwa+R5MsKi7wmN983lRzaTAqCBRv5/7mdnSfdn7uuUv3B5eBy9HFbP6ht44E2GjM1QkfqpHFsR8Ul/K7Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025, Matthew Wilcox wrote:
> On Mon, Sep 08, 2025 at 03:27:47AM -0700, Hugh Dickins wrote:
> > On Mon, 1 Sep 2025, David Hildenbrand wrote:
> > > On 01.09.25 09:52, David Hildenbrand wrote:
> > > > On 01.09.25 03:17, Hugh Dickins wrote:
> > > >> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> > > >>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> > > >>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> > > >>>> which (like PG_private, but not in addition to PG_private) counts for
> > > >>>> 1 more reference: it needs to be using folio_has_private() in place of
> > > >>>> folio_test_private().
> > > >>>
> > > >>> No, it doesn't.  I know it used to, but no filesystem was actually doing
> > > >>> that.  So I changed mm to match how filesystems actually worked.
> > 
> > I think Matthew may be remembering how he wanted it to behave (? but he
> > wanted it to go away completely) rather than how it ended up behaving:
> > we've both found that PG_private_2 always goes with refcount increment.
> 
> Let me explain that better.  No filesystem followed the documented rule
> that the refcount must be incremented by one if either PG_private or
> PG_private_2 was set.  And no surprise; that's a very complicated rule
> for filesystems to follow.  Many of them weren't even following the rule
> to increment the refcount by one when PG_private was set.

Thanks, yes, I hadn't realized that you were referring to the +1 (versus
+2) part of it: yes, a quite unnecessarily difficult rule to follow.

...

> So the current behaviour where we set private_2 and bump the refcount,
> but don't take the private_2 status into account is the safe one,
> because the elevated refcount means we'll skip the PG_fscache folio.
> Maybe it'd be better to wait for it to clear.  But since Dave Howells
> is busy killing it off, I'm just inclined to wait for that to happen.

Yes, that's where my internalized-Matthew brought me in the end;
though killing off PG_private_2 seems to have been just around
the corner for a very long time.

It's a pity that there isn't much incentive on ceph folks to
get it fixed: the one who suffers is the compactor or pinner.

Hugh

