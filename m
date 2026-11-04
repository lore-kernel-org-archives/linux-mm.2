Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A932D606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NOIHB49x
Received: by kanga.kvack.org (Postfix)
	id A1AC86B00EF; Wed,  4 Nov 2026 13:46:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB656B05B1; Wed,  4 Nov 2026 13:46:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3266B05B2; Wed,  4 Nov 2026 13:46:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E48D6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:46:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3D991C4218
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:46:45 +0000 (UTC)
X-FDA: 85398317970.22.46E7BE7
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3A3DF100003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:46:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NOIHB49x;
	spf=pass (imf14.hostedemail.com: domain of 3kn3ragwKCJk5AKBLPBL7F3G9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--chriswiseman.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3kn3ragwKCJk5AKBLPBL7F3G9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YhDr+3iNQXZpzi3ONHbQbAMo5PLwYKn4EglqMWvWgc=;
	b=WWJ1mB/R1br6QhhO6STqQhjFB2a+r90HDRqEGyIloZmVod0IMx2mHWBeqDEHchD1mIpCWn
	6BPVAtsU+tY//cdIMuEqPQOaBrWlkFiEIHcWXASu6TM8sek/FtZqdrfc9WRtWxu7XTbj4q
	VQLleXKJFknngm7BdsUJSYruI+9yMJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793818004;
	b=cYaNPdn8pgjPUK7ES/TrMJken5ZTPyhOP4usiU/z8/gdXJyLaMjjKFb8NnIUIDIQzRLSTY
	3hvCK0ekyXTIuW8MI8sTLcBstctlqD/RqimnKPvXxzkcHTFHEAL5hsS36gF/ZJx3ZhO3Ey
	NzBgaHD+C0aMxWCtFYfo53KhlkA62m0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NOIHB49x;
	spf=pass (imf14.hostedemail.com: domain of 3kn3ragwKCJk5AKBLPBL7F3G9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--chriswiseman.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3kn3ragwKCJk5AKBLPBL7F3G9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bcb065bfdso1809304eec.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793818003; x=1794422803; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0YhDr+3iNQXZpzi3ONHbQbAMo5PLwYKn4EglqMWvWgc=;
        b=NOIHB49xCBtdQCNwDyA511ImqqghnTqkqUARQarvabJOADXWM/LPtNUsJSTA6zIm5Y
         CY+Yeu93JA867fpObkHVEtzw2F1YFU7qMytC+lpoetkR4C0PQ0ReXcqzIYzH5y1rLrv0
         I1tigMthGUhKbAuIEH4VVtUCgydfIOzKFvWO2t46FUaF240WMCJtKO9FKDKtIbgvOc8/
         bZrxls36HvTtF7iZlgWGlVJpU6oLXvKGa3ASqNfib1dj9LPNDu8nKLFkUhTNn45/psD/
         FzvMQNwkTKIsNwHyDOjkarMsChAH1hlSFVsA3s2GKp6iJEBwlAkO5jMXXktvLp6LuM7a
         rTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818003; x=1794422803;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0YhDr+3iNQXZpzi3ONHbQbAMo5PLwYKn4EglqMWvWgc=;
        b=de4Iagocf5UImFIb5Jr8hsV4uuLcb6BtGeXmDPoV5lqT3w88A8xESz40eq8WzTKnRr
         m5etLQrW4q0X0szAczJOrIyFf7kVEcUnONXo59IdGfvhSaBXYslC++k10tigfFUwDalC
         njbbWZZgN8B5aFjwA4nUc6lDmPDoFPnKqFtmddjQCd3iUkxBV3OwVMdMK3p3ss7JLmJ0
         tVg1AsCaFudRFCu6GfGGcGmFv8LqIVRPfGKNVhUTLColPYJtLf/1lpEvsYVIWNKSmIrA
         CZhZ9c/090/BKrCspu6qg95Rj/L6VEIaCCFu/GfmYt17me58azi0mzFZwaOn/ibOhG98
         2/og==
X-Forwarded-Encrypted: i=1; AKwUvByOz8iGjNnR6iravCBrOV3RQYxLqzHt69hJGAxt9HTguRAmw4uOsjtIjSHWN1xeRdfyXKw1l8V9hA==@kvack.org
X-Gm-Message-State: APuU4Z+fVyRncORzFZ8e1ywzsZ9wdrxI1yMgV76jXg2nWId5KVY3kdQW
	6SUBv+u5RZgb/OqzNvgw2LTfh4FocwzaWda8lIHHF0TpqPW4yoeFQhOCLc+0cl3M4AWHFPnR4OL
	doD1zEjwv7ucvM4LvXVVv1/NTvTmWnw==
X-Received: from dycnr25-n1.prod.google.com ([2002:a05:7300:e9d9:10b0:369:f343:e68d])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:42c1:b0:36c:9bc6:3ec with SMTP id 5a478bee46e88-36c9bc60702mr6170036eec.3.1793818002106;
 Wed, 04 Nov 2026 10:46:42 -0800 (PST)
Date: Wed, 04 Nov 2026 18:46:41 GMT
In-Reply-To: <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com> <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
Message-ID: <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com, 
	Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kdcua1d9zpqmwq18ho38u9jgcdskkqpd
X-Rspamd-Queue-Id: 3A3DF100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793818004-799447
X-HE-Meta: U2FsdGVkX18buIyqIPdhwLcTdDig6bLqA+BCwsMyqcOb3hMZK1BwsWSZRBfRVP5LHHVi1KoIxjdJvqs4DZG2UgaR/Lcku7JFsMeQrsZx9dpXhriW3ZGyu2Q/QSO3Eob4cBm22UnOGj1s597G6CnaJAvU+5HSQmmxwb1JtTACsTFYOiB/SCGvNRVYhDv684oRH9+adSLo8qm7r4Fv4+bm6qKtmiBN/OtFUFTZpffYjsCzeyNaLwaZDoPlHz0U2BmFrqLEKuZ7rNFHa43Bo3F2h7Iyi3KL0dxxhd3ERfkj4Tyj2wn+3oRF9efvDg9izvufu/7UHwntM+rqdzBkdGZgkrRdQi5d+FhXdPa4alM8ZqqLVaMlvugo0Pt8oY2e/1OoP82UKVSsgugei9VLTj4vI7jIbynvbSTlwcTD2tQ0WZ85PsHyxJjT0a5P/xjX+Bd0K9lk8BhxTNEI+rubUs7ygIRkF/NJpNEbtW6RLCnVMgRLhT0l2Nfh+101V1mRsXdCfHoxJVj5dX/FcumqhDT7AX/8h4g8+V/ODKIGIwxdv1OoH1A62xxEQGcuIIk7l4jPiLq1fxliBBJ0pRvekqiY+gAeJ0OqfMEUEglSEKzOmek2A7xXHKEqoaY5SFvnz53y2215v/Yqdk//xWYoLLwoxCd5dGEWWiYJayl/KfzoBsUWoG9+yBG8rNsp4bVjmYm6IDSZQLTOEUByAlDs6aSnL7ewAZ/wxodQQYqQEdnD7ckC3FgwlkoNzFVVLHrSADqRmfZxfd3NH4OsAViURu3RCgHnajQRP6s36BzEUSA98T2TARWP2bi3TuGMLBZQde3RQ1H+uLutJ0prEy5cEkdIigP7eAmnCwxMVBgepmVVytzSeHiOW/e1K7bvyY4X+fJ8ApDBvgsR5ZvMS/jyLo+v3L63ZRHmuUOWutJUjLc9EXyQPYJYenJgvSrneS2d5EQ+qfYZIFhOyexujIbOMB0
 lacp9YN7
 7Qo5TQz7tPaqazXPgRiYZ513Atc+aTWaBgkhFGFQHT/l+8OMGooeCAmTGO4HsvgN3GTBUlNFlqQC6lWT3NVwXq+crSf5S9EE5Jf/EfRTdZ3m8XGMVb+wEPiUsJNgUI8BRmwzCHHw30vZyRN5TgL344JPHa0/3Y44RbFUQ6qbxG2icngddvbyxBcghn5frs5kNa2hjEZvQgLV4vBoav4QakOL31UpHAENx1LufoIwCnwfa08z4VRuqWQhcm403m9uBlV4rGCHXDa4xhPpi48U4DJn/DsWdeA1OVOltlKjl0lgPc6a9XPqetUcGkGHWcRsXOtiqIdrfylkE/lWa1mjn5sjQnjE/Gx+shcrI5tp8oCY6vq9A0caUAlQbQ6u6hmUdsYHOqz2D3n8cwYCsF1KOp6SInTohflJlhqMohvxMZy/zqlYaIWrbN16R/fzOPKaWWeY269stCUyUjQSDpsrvfDmQH03NEQ5s30Kr3bIl3OgnUusXCZ+slTxYTBCFAQ28JHIYoULpOHGhWmH6/+Ht+P/NpwOjQFiUSEx/p6kstsksqnJn1YugaFjvlCB5KMkuW1/q6AOaAHII+TzG7PbxEGTkdr8Jj1yMQBEhZLfTBM95mgEY1RYh7kNt0cfj1f+qfDrXcKQ4inyidr+IyJjhL1gXaP82MWYp/8xl1awuy/vY/IZa1LCPqsMZVFULaLsFCIOILzVcEHa66IKwNgjyMcs+DqAQcsspRxTZFdlPz6ouA2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 9:57 AM Nhat Pham <nphamcs@gmail.com> wrote:
>
> Is this precheck basically checking if we can free at least one zspage
> of the size class before proceeding? Yeah the number looks good -
> let's add that, in parallel!

Yeah, it just checks if a bucket has enough wasted slots to free at
least one full page before taking the locks.  Sergey pointed out those
two counters aren't atomic together so an unlocked check is just a
best-effort hint - if you and Sergey are good with that, happy to send a
patch.

> Ah ok hmm. Sounds like internal compaction isn't that helpful, i.e
> zsmalloc already does a pretty decent job at packing objects that
> there aren't a terrible amount of internal fragmentation in the first
> place...?
> Should we do CONFIG_ZSMALLOC_SHRINKER (default to N or to
> CONFIG_ZSWAP) for now, and remove it in a couple of releases if users
> in the wild do not complain?

Compaction still helps when we trigger it between bursts (freed ~21 MB
before the swap storm and ~10 MB after).  It just wastes time running
mid-swap when new writes are filling those open slots right back up.
Defaulting CONFIG_ZSMALLOC_SHRINKER to N (or CONFIG_ZSWAP) for a couple
releases makes sense to me.

