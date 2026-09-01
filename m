Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39367C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8C96B00B0; Tue,  1 Sep 2026 01:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90556B00B1; Tue,  1 Sep 2026 01:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7FA16B00B2; Tue,  1 Sep 2026 01:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8056F6B00B0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:21:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2E37120311
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:21:14 +0000 (UTC)
X-FDA: 85164044868.09.48DEA12
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id E90631A0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:21:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TGyncSPq;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9z10EeSNeIlyZFnhXWLzQdFpOPihH3ow6K97VqCgdXo=;
	b=Q5gZsKGnZpkjldlA6oVY8C5eakH9n/5obpl53B/jJKLGEkNRJ01jsdfyvYyGe7YYDXWBN7
	SFrqVDwt9NJMk8vuFVU5MMAwzgCY5EWvT4IQYTT6QZgNa6HFKP+fid+VIBTd9rCU+3twgQ
	MsiIKR6bH4GseI6iTZU0jgBxyetkfJo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788240072;
	b=oxDLkxl0DNBmmVYlfCIie/evo4IxA8ceq36/C7iqNSttqJvhO53r/wF7hOvLdogrxCIGID
	1xA8QOyQ6B6LZzTFpV026uOnU+5rmd8vH0+BYOZ63FBcwDItUgVf15AKY5Q1OjV09GIwgU
	9V70N04LnX8QBzbgZ9XtsJZ2/Y30Ol8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TGyncSPq;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1600d040e4so119132566b.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:21:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788240071; cv=none;
        d=google.com; s=arc-20260327;
        b=UYUvQv04LfIWUE3v38KcVoWTSgaNGnyzNMDgufD1f07lSkulCmxLdjzlubnaRWWR8Z
         urtR24A9jEIXmJy1IpICF7zVdgle2vIZ2Kbfx1Wi1VcJp5Suh58pHDzPp3v311LUcMNE
         VaAH3cqgr9LVbNa4xqYB19+kFHyAALDoELljDwz2JYub6ZG4DgS/tEXqBvhABTR/5BcE
         4b5XS9+gJZAq5C6xcH5H8jhbwkYVdL6kW6IDF0juRvk/eqv7ZhZZ69dtw8wlVx+g0Ei7
         q/oCZk2jjYQ0kkUqKBBnhclkv/U7W5Bi8QQEzcl/Q1XTMADbWIqvyKtLEdQYw+39RFet
         8iFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9z10EeSNeIlyZFnhXWLzQdFpOPihH3ow6K97VqCgdXo=;
        fh=9OtubVzT62RuDK+UzaUPHULs4CVlPa6sMix+QhbQvNk=;
        b=lFc4sf/9L9P7CVQVdasyylk7rgpGY0Ai/AtvCJ2Icom+3eDfeqgxYAea7RHA+4znB/
         GUhl4E4gp1fHKlWuBMWmyf91WH/fQoYEZ6bTE5vrX618wp+HbV+rN+EbgWBd1myH0r4S
         DPqmmpAN9lIWcj2xTWOIpF3EWA4DzxKydFwNBFf+0GMbiVJTTdmNeT6aU0+kEH4Fzgan
         Z1j0GlROwUkcBrTiDUY2bMdhGBOxUtS2EIe9YVXT5lTHaZ8e0n7iHUKMRKS1X5KX3Azm
         DVJWVtHuKO+qNPLMynyUIuufwnarIrdmB7JbFIYb1oPMqHcCVA8rGMet/fvy5ttYqQO9
         RRqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788240071; x=1788844871; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9z10EeSNeIlyZFnhXWLzQdFpOPihH3ow6K97VqCgdXo=;
        b=TGyncSPqiYCTks9kyI54PTt7MfqqnI3gy2U6gMOozZ0EuIc50Z9E7Vdi/OktZDk4pf
         eDTw41VVQPDBCi0BtpCYmJ938ea4zZVVknubFRR5jDTzL8aHI81g9gp45Q2coQG367am
         BlU086EOQJPIJAy2V9HzjrLDvAVWsyW5n75xRLg1nrrE0YXLW97/9p+ja479wIH/gLwm
         YT00pwDYXQy45A8gB99LWXIWqSV28hp8SUKSP7uNNqc3oJp+dsvSABfKFxUjwqkc800R
         0kKfYnBYmWs8QOz3t2eJ+LKBrwtkGP0WyfdFbAwdzwVr6NnB65dd7yQxdOrKVYDZyNcx
         cDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240071; x=1788844871;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9z10EeSNeIlyZFnhXWLzQdFpOPihH3ow6K97VqCgdXo=;
        b=HmKN6SejupXeSrUnnmgMYSP+VzjQyo4YhultwGOGWnmRK05r2RS0dTW6xqk26bEuQF
         FsfceeE7fPW6+3Yo1FZwBeJ87ZUwsRsnSH2H2FQeRiYssKnoO3vzHLrCKY0IFydkbic5
         YPVBI0HLMWdHdixpq/eyzYFCXG+nlC6VugdAXtlIuR/NAs0bpUOqv+AKozQGJ0ybW2fi
         /2/h128OK4gozJai8XhmfPyIUhUf5QqIsUpm73JCW353IM6bcJssa6obHmKUxysZKtUb
         t7fVciQPBVBwbFnMJBiiKioquUvDxMDHSehh/sE1A77RLNokAnbhAWNGmMP67ScFeh1d
         EuAA==
X-Gm-Message-State: AFuF++nbsxm79qrt5EQmRSRvA/lrsKpg8mQFfNo7I2+z3kQMZyDyuvkI
	Yq3J0/67H1XjZbt8ZHZtJN4jhtUZk1Vyu5P1j/3M88XYvfvRNltWEG/kPDeahBo0bp/R4Jr5gaK
	Ji7ET9NT4MY+CpBMwNwLOAByythnpb0M=
X-Gm-Gg: AR+sD107ymoINTyUHgMJPAob8lOXkCuE9BnFJyoVSalrHVLkfQ0FFvm6qHJdnIXadms
	9U7oX9rs/NxIj01uMB+eHrEqkMibreBEERbPJQ9FlxeSU+Kb+RBnMGoVX05Kc7A1lWPeyjhUVMg
	b3KnP+uaXjFT2tyLbGWxhF5fVvVshWnNma4SGa/O088HL7p6AFhSgxpLdw2+/Z4xryez/nXb31A
	LB+3vJeNK0CCyqo7IKotXoUO3qlRrg2/v8eLO0TQGt4wHW9teSNbWIdw+3Mb/IOBWE6RTixH1k1
	axpb0U951JWVKDCqptlTTVaGal2SijiMNniFcGAUt1I93rJeuludzi8gPxLBVCbxCup7VYeP3nH
	r
X-Received: by 2002:a17:907:7253:b0:c25:8bf0:36e2 with SMTP id
 a640c23a62f3a-c25b91a2114mr161539966b.10.1788240071158; Mon, 31 Aug 2026
 22:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com> <apZVe8UHZ1CNo4r1@linux.dev>
In-Reply-To: <apZVe8UHZ1CNo4r1@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 1 Sep 2026 13:20:33 +0800
X-Gm-Features: AcwNN1XYYZEVuDsFVysPBXGQM2_96ZhDLvR26kiyIMr2QMBACwffo8RrchKnu5k
Message-ID: <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E90631A0003
X-Stat-Signature: kix1sdhynd85bstw8iw48ww1npkyssug
X-HE-Tag: 1788240072-925668
X-HE-Meta: U2FsdGVkX18k5mLsZ+nWxlxqYvncPp+UNAlBADQvyRQLR7zkJGl+G5Efoc+uIED3KwRf2ka9NECcRwjlaRXqv2O7k6fSQmk1FJFYehhjsgi/VodaJ/ux6LieM/sMkFsxp79JZ0MQYV1fu1OpK3E7CVhfj5MR8rJR6bdTTqoesRq0i35B53PEZ5RACoU+sYoAcU+s+BrCFGYzWCd67OMrQ+Wp+Xfm5W3mtRx7tAx8Y6VmvQXP0aGbI/53GnRxa5z/k1JaJPH5F+OFaKlqNhGezmpIG+38k+bk+5jIbANBOYFU9D+kTPyTPyy6vNrkdIZjNeHjKeq3TVJtXp+HRkD5P6OavW99Wcgqn3wn3CHFkonXYIFGgTAseTJnkuQgSIk+RNAMhJ5dr/GzuV7fKJdj4zk0Uc27dtTJ5KZ7nGBw5ObjKV1qkkVaY81zQzPrzOSKnnj3Qbtp6LxyZTC1B6o38n7GGBfqSOz/DDtQ69bqtDq5ToVPkHZ4ogFQeh6Lmmd6yL8G0NghqG3TCdvL1z9WgiYiZMJ8ZWkCSeziN5rO4e6dMns0JM7EZ/EIwkOwf7VnkiHvrIgoEpfxdZkZUXS1lO72oHYadpPkOAQaHxbXhsexAujIsTlMjAzMDoecZ+fmD1+ZCVb0vazsgA9GOPywhxR+GlS6gBx9rQuIH4vyxcph85meRn+WDlet/1Vk17e2mZPK7PrXtuxnCiSfkVcQWiu6CNhuy3DE1OuE1qUXMTLZjJSA978qWDXWtEhdAng5ISfVgdyaMH2wc0O/tbHmm0/wEAHk1DkTWjIyDh51vm10LKrtWGAqCeDKn8OaxPMUMpX/dd1x+DM5pREQdpD+Ju5bB17Rhe2c3e6n3xICEoED5n0jat3ZgmqUWw+6O+kFo2BxrsH0HX2SeHT2x+ajYKi/JC/y68I0VHtoerMIWSFkU5rbobNaNlGZt3pLtIK2NMwO5IZPyPY7yJOjjo/
 cBDAk2Bi
 3XpaPzxvo4ZQ176xie1XL7Bezn2bg9fNk8fsXM1FVep6G5wASCaYmHQUKFUUA5yHGmMazRkwfbWmWctBdBfXAkDq1bjifUf75f69Wv6B4ZBPB922LGPvYnpTWqwD99uoE0nyW6WOrhPOXmskmMo86hOTKsNMQoKl8HNfIFEw/eQrMkJxWQLQ4FlrGn5CstaznMbqFNZPVbOlkkaebVqTvalktHHFiMJ1KBaon93sEM6ttWt399TVDPXuwh5aB/NKZoMw5ai7EN3E6c1G4u88sHa0l6iNl8+zhYGofuzVx4V3NPimdToLO9qaUCMUcsizG7IDb9nhOIJZaRXkcREXHORqVu2HcclD7joQ6ekcA7AsGaUm5Pr8955R3qxZPdBmfK6Guf5TLyPqbmEjqVg1B0y9oTujwsNaxO7+A0vVKq9Zqp2eeOMm5XHN/GRLSCs0JtuRKSpojTbWcyxD9JgQFe74ya5hnJ4lcJRPRdM52DLsYNsloswg0GI2v2NceqcQAjPkdPlLVqHAeo9F2+wXRwHaT/hVHD0DZNjaEV0r8yN9kqHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 12:38=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Aug 31, 2026 at 02:43:31AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> > introduced a sanity check to catch memcg counter underflow, which was
> > more of a workaround for another bug: lru_zone_size is unsigned, so
> > underflow wraps it around and returns an enormously large number, then
> > the memcg shrinker loops almost forever as the calculated number of
> > folios to shrink is huge. That commit also checked if a zero value
> > matches the empty LRU list, so we have to hold the LRU lock, and
> > handle the positive and negative deltas separately.
> >
> > But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> > for lowmem requests when memcg is enabled") already removed the LRU
> > emptiness check, so handling the deltas separately is no longer
> > needed. And if we just turn it into an atomic long, underflow isn't a
> > big issue either,
>
> Why atomic long and not just long?

Long is fine too; I was just trying to be defensive. The original
check was a defensive design for leaks or races, and atomic long is
more immune to race conditions. See below for the other conditions.

> > So let's turn the counter into an atomic long and check at the reader
> > side instead, which has a smaller overhead. The underflow correction
> > is removed: a massive leak of the LRU size counter would indicate
> > that something else has gone very wrong, and one should fix that
> > leaking site instead. Besides, the updater-side sanity check is
> > unlikely to catch the leaking site anyway: if a folio was removed
> > without updating the counter while other folios remain on the LRU,
> > the WARN only triggers much later, from a likely innocent callsite.
>
> Do you have any data to support your claim that updater-side sanity check=
 is not
> that useful? Also can you explain the motivation to move the check from t=
he
> update side to reader side?

I think I described that in the commit message. Commit ca707239e8a7
introduced the original emptiness check. The goal was to fix an
over-busy reclaim scenario: upon underflow, an unsigned long returns
an extremely large value. The reclaimer calculates the page number to
scan based on that value, and thus enters a busy loop trying to
reclaim much more than the actual usage. It's really a defensive
design or workaround.

And later commit b4536f0c829c just removed that emptiness check,
leaving only the underflow check. So at this point we are just
defending against underflow. Currently, I don't believe there are any
known leaks or underflow issues in mainline, still purely a defensive
design.

Reading these counters (mem_cgroup_get_zone_lru_size()) is much rare
than updating them: the only readers are reclaimer - per loop, each
loop will scan a large chunk of folios. Or during reparenting - per
child.

Writers, however, operate on every LRU folio.

So checking it in the reader side is much lighter and cleaner code-wise.

Checking in the reader side also tolerates deferred accounting false
positives: if a folio is added to / removed from LRU but have the
accounting happens later, that's fine, but might cause a temporary
underflow (there shouldn't be such usage right now, but cleanly the
oldest commit I mentioned is trying to catch something). It should
just proceed without performing extra operations on the counter or
raising a warning on the updater side.

The underflow won't affect anything besides the two readers mentioned
above (reclaimer and reparenting).

Besides, I don't think warning on the writer side will help catch the
real leak either, it just adds overhead to a busy path. The folio
triggering the underflow is very unlikely to be the one leaking the
count. And if that leak is actually caused by a race, the atomic long
change should cure it.

