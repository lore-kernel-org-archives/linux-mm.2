Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134A1606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gnQCqrY1
Received: by kanga.kvack.org (Postfix)
	id A0E956B054D; Tue, 20 Oct 2026 15:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C06C6B054E; Tue, 20 Oct 2026 15:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AEE46B054F; Tue, 20 Oct 2026 15:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF416B054D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:35:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3CD51603AF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:35:36 +0000 (UTC)
X-FDA: 85344009072.24.8879EC8
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id F309B1C0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:35:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnQCqrY1;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792524935;
	b=vPKqemFcXDCSQETxrsO8R9xEIS8t7O4zdbvFLsY59Jj7KXROsVk8hPgPAYHmW+8ofupIt7
	we+U0VkQv0viX5eyrWjlkqf/YYk0761Z8eOUCbPQ4rk1RtK0o91JiTPt0Kxl3C7x3e4tK/
	ylHqbOXYe5I2rrgEeEL4XCFCyUSPyyk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnQCqrY1;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792524935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckZOjrI/a8l3XvmSOhJFFANe7UEtEpi/7X1L9+I2s3U=;
	b=ImEs7KOVOu3U3aUur2rBECj+qYOgXMgQZhtu59jbQ9gSG8gYom57syWyJ4hJHJRtTdLCvI
	ipjdq2pTo195b++CsJLhPpY0xvU7Fo2ptH56vb4KPDYm+Zd6B1ugYcL07Hl2IITrQU4K5v
	zPrVXDnXcYP+bTRGLbuKynPj4aKDWV4=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67999045530so3278042d50.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792524934; x=1793129734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ckZOjrI/a8l3XvmSOhJFFANe7UEtEpi/7X1L9+I2s3U=;
        b=gnQCqrY1Zx7Wlef/lgTQNVUOY13s1zdosaKbJiHtaS+Ad6nzf20kNpnBYDE2hAjJCE
         ooBChS6bc18NFAXE6JljMD/oFxQ5T540po0jNoOv/iVMVUZihMFDaY57ZJmXtqeon8Z+
         ZPWfVgLJU4jT0CCyH9ngVYTkt8fVumfPduKm9HAnul9hMC3TqOwymhEz+AU388hPscD5
         hNENnEh91di11+RikSyGY1hWkXtSQVMOKh+FVOTeqKRfwsDrgI8vTG7zCmG5qCMl3l4+
         QSo0Rhy+w+R6s0eIW6inXhWZi+lz1AZLCJPF8B//DMFwcZ3Zt2x24gSPKhdL9omQfA0i
         kwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792524934; x=1793129734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ckZOjrI/a8l3XvmSOhJFFANe7UEtEpi/7X1L9+I2s3U=;
        b=qcP3KNIUtc+yilYItg/1kr4P8OXlQV4yijWRF/g92rLVzVUssGdsmPreZpaSXHGKvW
         bjKl605N7MDzY5EA49GWZmq5iSiZm4W7YY1Lw3LXNWgoBUZnQOecJ2syTr012W58ieG9
         ffgutMk1AC5/q/0rZ+Eg/7K3mAOn2PQBQF1jxujG3cpZksA1kMwaa/SHoeZieGo+EHIl
         VexfqaD2wntv/yK+Pu6JM58vzLNXj/H7ctT3xXoVy4rwB2bXim6K7E6hMXtGgZR3h1Eq
         Qj+QIRoXJlpgO6uaSaxb+6/CyNg1pna7jq4a0COnTWhVJBTSDXCuUDuAzRCuduNcaL2g
         +Z3g==
X-Forwarded-Encrypted: i=1; AKwUvBwYecRQEqs4wyalefCvelwaWnz9uOfihPazi1AAJh4qOJguuPG0QhhMlhUMKyZFmOLnA+AZqwHqqw==@kvack.org
X-Gm-Message-State: AFq9FYKHzM7Uzvs/TZbTPABJtEwhZiMsPmfRSHt6m5Cj2rJr+aj3kxNA
	a9A6PPtPx9M364yhd40G16oLtmtIfMPgxVjB87NNeL92rT25QTIvzWoq
X-Gm-Gg: AYBFou3N6lKLeWCecyFDl5WoAYg26KPWunCTDUKHU4wxjlDIt55XuiJO1a4Xh/1V2E5
	2su0FAGwkeYO7Kb/0ugFB87/gI01n7T4HT4YjOjuXsv7zbKdYqkrfF3LqxyXJTizLu3OJ3f6ogH
	lZp5AaXj/qkJS77zvLPyWAyf5Q4XlAR22FAm5RcQ88EyCqw97MUggsCzpthCiJjcnEXFLQAH0oo
	U77LRtdPM/IrCvvDrBQS/GrpHGJvbjBy3JFxdVvJ7ap0Anp5TuS1mwQQAc0wNAl3iholqgSuaPy
	TClq4tMwAnBrfTd/y+QP26wiSA6SQpUPLJi/Lzr0ZdmG6wKLVDQ7s6Z/l1G8vjSsfbYVyZGH0tP
	MwPkGNnQhPwEm5eji8OH1eFBQAs4NaCVG/laixd7eqkStzHEyP5pweWWsz91W8gIs0HwGWvdIvJ
	kWXBmJxT7kQ5hJ/Id41UHJeVKUIoo+nK6iRWO6f6CjITVApQT8lmhEXWx5rSEMH0Jxiyj6D9Zdq
	sS0WUn8dJzil2eF5Lykz+4t2ndXvg==
X-Received: by 2002:a05:690e:1201:b0:674:1968:4194 with SMTP id 956f58d0204a3-67a0e02e652mr126937d50.2.1792524933795;
        Tue, 20 Oct 2026 12:35:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e5779ddsm89200d50.20.2026.10.20.12.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:35:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 12:35:31 -0700
Message-ID: <20261020193531.181318-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020190336.3754557-1-joshua.hahnjy@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F309B1C0004
X-Stat-Signature: h1uzi4w7549jth6e6pythgmgi8n4q4jn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792524934-113620
X-HE-Meta: U2FsdGVkX1/M7lFA90z9p6FPJLS5NZAPPY7CGjRb9THqhfrnVb7JbgrARLEITYp024ipDwJRNRo9VJH4mnxY26vrdtt3jz+dUIEnt4Y/lfmGe/2XfZc3RLcZg5E/foQiVgHIiDDRP2GJwBXjqLiASXLSSFd+qA7BOOYgeWRKq46CPT9yHnrUS53ZrI3NoczglkV9WstM/hog3kj1YMBNfSQzXV4jG7RmUpOm9PkqOl/4HPEiLwOfQQ73Bunek8CxHEaNmeb39OTgynmaKrY1wXe4AxxgR6ZUEOAdPJKKW3dJmNCI031talBZ56Q17H3e0os/E5FBqX4XBZRHT9thUl4rfTe088Tolzsdn1SPFTF2P9+iNOKOhXcYyoPPqlHRlDuGu1uEWIDWzWpGPmVcrYN5iMP810rn1gV8eSpKKR0lECWjw3g2I+JJGvd9iGEPVGm5RzWBYb90Jzy0Ipjg6VSRupampKLltQrvEJAEHxX7uONzdhO/qhzZUllJEq29GfBrhat6kw6mZFd8U4un4P2oQ5ZS7Liud20VZBiWfT7RKXpW2oE9pfy0gdYSMuXKt7FhXNra92o6qcfRqwPiWRM9HFenlKawPJeEXtm3myV1H/H1Gc36wVl11pFc7x9INV0EvUzXa+7cxZtwZMkhkuh+dJhYDcPZVznUt0JkQ3VaOGCgM/tojHI/ca4WpM01U0fsBgz2R6rnurw9oPLasy3wZ3bWs9vDAtOf2jEkPRAW8D2dMj8V9ghzgl3A3RrrL4S48rKKBR6MsPawL5eNSiJCdyQF9k1PqWmOOlf+OFAPceQ/KSbBqIeFUvyE1+OHvL93emkGHC9oqG91CqLEFuVhD5rPcqycddwbwS9jfb/FNx/Nci7/mUnC+nO48ukHoPBkGTh8aeqzPslMJSf/ymIV+zYsMpZAHdgWJWDJ/yBzSZb/wOjcO9/01dH+qQQyQJY3bptwvJs4rLde+RI
 hCuVrNZY
 xAewu++ek8C1c20UamXA4wcUt3rf2yG53pWS1haqfFnwxF/tJwKH4yUoDDZwPtgHnKoVKP9e3n9c+T2ug/kFb68wiidNnFJHq7qDbEmQYCemurR7lpuKtvuPz0PAjpqa2WLHV8HSjNtRQPf309OBQW1gZdC45H0YAS3mCQW5Q4qPBTbcD+R6GURJPYcuQSm0xeg4H+Y8Luj9DvWHKM6FB/by8JgDwjl1xiAwE6ph7jbBKMoWv1E5njrjWUgxcP+1ANgqQT6fYP9HRcgUQKVg/w4rp40i2ZSwYvGWwb4MzLtCMvPyZqdowSUPqqRYMMdkeEsLVeR8lW5K3d1vJcal74w9BeRsFkIjwN9OqH42u0BLyT+YJG7NSkjhBvyviEeIuPKMXoaELSlEhDXbbkF1Tx1UGZkZJ2L3a4zesl0j5E4ZuYt4fOw7ueQEYI72ri2ELGtztjEswu0h32vzKNKW8etx52sY4aH8j/IyojWFHDyWZxYa8e8LN+pTDdLCJCwDtVEjr5hwWox9k3H59UGeqZhs2RkxrBncTinARjcBMJZwWsqDCPNv8DGCkyQFE5Rpvb8Yf4OKan4+5lFYAmb3l2gV2nS8IY6fUf671
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 12:03:38 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Tue, 20 Oct 2026 11:13:27 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Tue, Oct 20, 2026 at 09:56:26AM -0700, Joshua Hahn wrote:
> > > struct memcg_stock_pcp hold references to cgroups that it tracks to make
> > > sure that the memcg never gets freed with unaccounted charges still
> > > living in the stock. The cached stock can be cleared either via
> > > drain_stock() or consume_stock(), which drop the reference if the
> > > stock goes to 0, and then clears the pointer from the stock.
> > > 
> > > If that was the last reference, the memcg is freed after an RCU grace
> > > period, but this can happen while the pointer still points to the
> > > to-be-freed memcg. Then a reader that enters its read-side critical
> > > section after the grace period has started is not waited for, and then
> > > can dereference it after the memcg gets freed.
> 
> Hi Shakeel,
> 
> Thank you for the very quick review! : -D
> 
> > These are per-cpu fields and are accessed within local_lock. How can there be a
> > reader where a cpu is still between css_put and WRITE_ONCE and within
> > local_lock?
> 
> I think there is a case where a different CPU can actually access the
> percpu stock. drain_all_stock walks every online CPU's memcg_stock
> and calls is_memcg_drain_needed, which reads the value with READ_ONCE
> with no local_lock. So I think there can be a concurrent reader that
> doesn't need the local lock. 
>  
> > > In practice, this is very rare and I have not been able to reproduce
> > > the issue in my own testing.
> > > 
> > > Switch the order of the reference drop and the publishing so that
> > > we first publish the NULL pointer, then drop the reference.
> > > 
> > > This is based on a report from Sashiko, who found this pre-existing
> > > issue in my page_counter_stock series [1].
> > > 
> > > [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> > > 
> > > Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > ---
> > >  mm/memcontrol.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index e7d7db5718f9a..a05d9a8baa1b6 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > >  			stock_pages -= nr_pages;
> > >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > >  			if (!stock_pages) {
> > > -				css_put(&memcg->css);
> > >  				WRITE_ONCE(stock->cached[i], NULL);
> > > +				css_put(&memcg->css);
> > 
> > This css_put can not be the last reference for the memcg from this path as the
> > caller of consume_stock() (above the stack) should be holding a reference to the
> > memcg.
> 
> Ah right, that's true!
> 
> > >  			}
> > >  			ret = true;
> > >  		}
> > > @@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
> > >  		WRITE_ONCE(stock->nr_pages[i], 0);
> > >  	}
> > >  
> > > -	css_put(&old->css);
> > >  	WRITE_ONCE(stock->cached[i], NULL);
> > > +	css_put(&old->css);
> > 
> > Here this can be last reference but I don't see any concurrent readers of stock.
> 
> So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
> is set, so you can't have it concurrent with drain_all_stock since it
> will skip that stock. But refill_stock also calls drain_stock when
> it evicts the slot but the flag isn't set, so is_memcg_drain_needed
> can read it at the same time.
> 
> What do you think I should do? I think reordering makes the intent more
> obvious and maybe it's just me but I did find it a bit misleading at
> first that we were dropping the reference and then publishing. 

Oh and just for clarification, my page_counter_stock series actually
gets rid of this codepath and switches the order when moving it anyways.
I just thought I would pull this out early and send it as a fix to see
if it would be worth the effort!

> Thanks again Shakeel. Have a great day!!
> Joshua

