Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9603FCEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03628E001C; Mon, 17 Nov 2025 20:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3988E0002; Mon, 17 Nov 2025 20:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA26A8E001C; Mon, 17 Nov 2025 20:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C27D88E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:18:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69B08C0307
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:18:42 +0000 (UTC)
X-FDA: 84121968084.05.25B1A8A
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 06CE240003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:18:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763428720; a=rsa-sha256;
	cv=none;
	b=aY77jrlw09d7FW0tD+uppb2EDZ0I/D2b0BsigRcUCFlXNKmkqUK1uZyKHYioc1I7CKCDjy
	mIf1kjQnVB6nCui3YV8DNYZGHQNjUaIkWCkG8Jt2dWgQXWeyzcaJxnSSCNaprhqhoKIxvm
	yFv5zYsrqvWpXcN/MtVxXhpuSpVyOP8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763428720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OGEiG/4WShvoCcw2YamNdhuBhp4+OGqOdt7XB8UGhGo=;
	b=qUhDJEs1DzvypwlLqLU58JU3I+qnXoJJc2XQus4rMF/v8AP9HQLsAQNZdklqLrsjZ1kSzC
	acsfa8WBWEtwrXbg9AQ2jg5GrqC7n6Sgj1FRn0GjRVDVt9Pi6ackNvA0zTwIuuPR4nSzIB
	ZBdbNo/C3sG5lJW9azEixSEqqzOU/58=
X-AuditID: a67dfc5b-c45ff70000001609-12-691bc96c1cc2
Date: Tue, 18 Nov 2025 10:18:31 +0900
From: Byungchul Park <byungchul@sk.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: Re: [RFC mm v6] mm: introduce a new page type for page pool in page
 type
Message-ID: <20251118011831.GA7184@system.software.com>
References: <20251117052041.52143-1-byungchul@sk.com>
 <f25a95a4-5371-40bd-8cc8-d5f7ede9a6ac@kernel.org>
 <e470c73a-9867-4387-9a9a-a63cd3b2654f@kernel.org>
 <20251118010735.GA73807@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118010735.GA73807@system.software.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUzMcRzH9/09d3Pzc4kv95czM20Ks/nYjNiar81Dmz80jG76TTc92KUn
	G6tkKkoeos5Rka7rQXPp4VJG5cjZJNV+RClRKmnJrYT8rtb032vvz/vz2uePj0BrmtilgiH8
	hGQM14fqOBWj+jbv9uqwJq1hjT2ZAnNZCQfF47Fg+VjNwkRJnxIVVSIYm+jgYarOgeBH4zMO
	BhtGEdzJc9FgfpXEQF/FLwT2mj4EA1mlHHx29PBQbNsFXQVfGKg9V0VDz8XnHKQlTdJQNzHM
	Q2J1oSIuj+ehuTKdhau/7tJQFf+Rhzc1Zg46S6ZY+FKfxkCTycrASGYjDV3pfuDIXQQu5xCC
	xrIqClwXbnLQll1DQUVdGw9XWnI5+JTUhaCloYeBzN/JHNxISEcwOa4ohzPGWLjxtJP38yEJ
	ssyRhqHvNHlgfUuR9qxLDJEfvaCI3fSBJ7m2KFJe6E1S5Raa2IpSOGIbvcyT9+21HHmeNckQ
	e/dGYq/+QZG0M8NcgNd+1aZgKdQQLRl9NwepQlprc+jjVm3sdWtEPBrwTEUeAhbX43fOh+ws
	l1/rptzMiCtwmaV1mjlxJZblCdrNC5VOf6k83afFZAGnmrGbPcW9OOnnmelcLW7ACW1nkZs1
	4kuEa/P3zOQLcFN2LzOz643lv18Vv6CwFlv+Cu7YQ9yInfmvpyte4nL8uPKZUlEpp/ULOLG0
	mZq5cwl+UigzGUg0zdGa5mhN/7W5iC5CGkN4dJjeELreJyQu3BDrcyQizIaUBys49ftANRpt
	3luPRAHp5qmJl9agYfXRkXFh9QgLtG6h+txObNCog/VxJyVjxGFjVKgUWY+0AqNbrF7nignW
	iEf1J6RjknRcMs5OKcFjaTzK2bAmgLVkDo50jNNWlJnvFzjl3MJ+KD/isO9eMZLHw/2B0+0v
	G73tZcYubQa31jf50JXtAartIdYYyXl+ic58wWeqtK4NBd07usc3JiXnvOnteGdr77arjh3N
	W29Z6FZxYHUaZO+bH7isV9sDfG9MR7+/5/c/B/1bTketwi4dExmiX+tNGyP1/wDdYy8PXAMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzHfZ/nued5Om4eJ/nqxuzMbG2EMZ/8aP7i6zdjmH+4uWc6rit3
	STF2KaOmFKLOmdDPq8Sln7uMK+X8THXtaSjlR4S0pHVlcZcZ/732/rxf778+PK0slAXyOkOU
	aDRo9GpWzsg3Loufq3epdPOvu2eCtaSIhcKhGMh7UykDT1E3BVZbOYIBz0sOftXUI/he18DC
	59p+BDeuDdJgfZ7AQHfZMIKq6m4EPRnFLLyv7+Kg0L4BOnI/MOA4VUFD19mHLCQnjNBQ4+nl
	4ERlvne41MxB7RWXDBrLU2RwYTiHhgrzGw6aq60stBf9ksEHZzIDLksBA33pdTR0pKyE+qwA
	GHz8BUFdSQUFg2eusODOrKagrMbNwfmmLBbeJnQgaKrtYiD952kWLselIBgZ8k72pg7I4PKD
	dm5lMImTJJbUfvlGkzsFbRRpzUhjiHT3EUWqLK85kmU/RErzg0iS1EQTuy2RJfb+cxx51epg
	ycOMEYZUdYaQqsrvFEmO72U3B+ySL9eKel20aAwO3SMPa3FcpSMLVDGXCiLMqGdyEvLjsbAI
	l17spHzMCLNxSV7LGLPCHCxJHtrH/t7Ox2JJ5mNaOM3jJCv28WRhK074ET+WK4QlOM59EvlY
	KTxB2JG96U8+Cbsy3zF/3CAsjX7y7vNeVuG8Ud4X+wkh+HH2i7HKFGEWvlfeQKUiheU/2/Kf
	bflnZyHahvx1huhwjU6/eJ7pQFisQRczb29EuB15Xyj32M+0SjTQvNqJBB6pJyjIFJVOKdNE
	m2LDnQjztNpfcWo91ikVWk3sEdEYsdt4SC+anEjFM+qpirU7xD1KYZ8mSjwgipGi8e+V4v0C
	zWi3NqWmLGCoISa0PmTvzVeFt6alHyUn1q1afXtcZ4+HUabNyAm3RVp3fN35VtF2b18mXloc
	cDxErlW1yvtbVwR1B9uq+w8PJY70bTVJB0O3qalZ9xsXTn9Wx5U3aqPHr/kab13R5qQfOQxP
	R8197k+pmdv3j2uf2Jk3/UJxs2vYvUXNmMI0C4Joo0nzG4TMdJA+AwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06CE240003
X-Stat-Signature: zum66r67zpfqn638ksgm1xjqoee7b1o9
X-HE-Tag: 1763428719-438107
X-HE-Meta: U2FsdGVkX1+hemUYh/wI7ULcPmpSF+jv63sPeOQntMGRz/4nEjMJeRhs99QOx2+Gy4L1TJDwSgKnGN01gSzky4EzfFbTA2b+5J9zB3O3qJGaR/SRd7M1Rp1BBZOa5UdbjC2MkDmR3z6hauc5zbaZpS4Cwtj3uVEUmrOgN3dCjMqpCYNqsq46MThdgsSZSCoYvAoyWqWuVrMoDOPQLWeQQ46muYb4q/BntNOmrWcxLyjzhnJOYmtW4jG+b49hqTE3vfDd53EmNUHfP/z2Klh0lVcVW9+O2CpVwQKZvZqOvdJl4fgiWns8iUnwIuZ2mxTqBCleWinWFoiQc5Gy5sYl6bG0Pw7pMNuNERjHL3UlknuCAl3ZU3+lFfhLd/71WPB1Zsy3RjPTXews5lIoVqa70MNWzA/cvZAcJJ3Vm9W/hA871d+1VGqqv8w5lwwjCXlZ7PAbK8QD9VYzQ+TXfpdIDRdsXf94OIhqy/IYSXmKV1zc/TgDCYnZsexgUjRkyDaN89kcQC39O5IvO28HgCLMzHHICCRGpdk0Xf/5A8KTkRrLydcN7mn3zqP2/BjNlG3FSuFkfEiy3MvztWTsqkGAuk0D7ew6bZ5ovyvGjKJqigks7s8g5nGVdFboCs9B85fraWuXoomFBTD2XxXA4twpdmrx0xbs/GCf7ZE/bxPea7YUOXS4rX19c0vL1SGRkj4NpO1PPoWCc+sXldjB/T8dfRsEEYBcAi051whK7X8EQNN7Ij1o+6fPn2bqeUvd4JwoszRvhSfbMY1vYtl1uC3ysgSdrqUcbXp7FDqW6bEOS2CfdANIzse9WrxqmcIJVAStcO+GVmVkUjLUUWoriShk1DASnIpvESE4Eoy9c1RSoeugyHVNgR4PdEIVxUgy0G0Vvjo8h+bu6jKDubNuiiCfY0+n7WFQXkGEplT+wuuo/6S/mpSylBAJ5CDUeuityZI4Z3mjdRqsVuWZyiicXNq
 gqa9LRwg
 hi9mh0Z82lGOtpwFeeWjVzANXuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:07:35AM +0900, Byungchul Park wrote:
> On Mon, Nov 17, 2025 at 05:47:05PM +0100, David Hildenbrand (Red Hat) wrote:
> > On 17.11.25 17:02, Jesper Dangaard Brouer wrote:
> > > 
> > > On 17/11/2025 06.20, Byungchul Park wrote:
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 600d9e981c23..01dd14123065 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -1041,7 +1041,6 @@ static inline bool page_expected_state(struct page *page,
> > > >    #ifdef CONFIG_MEMCG
> > > >                      page->memcg_data |
> > > >    #endif
> > > > -                    page_pool_page_is_pp(page) |
> > > >                      (page->flags.f & check_flags)))
> > > >              return false;
> > > > 
> > > > @@ -1068,8 +1067,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
> > > >      if (unlikely(page->memcg_data))
> > > >              bad_reason = "page still charged to cgroup";
> > > >    #endif
> > > > -    if (unlikely(page_pool_page_is_pp(page)))
> > > > -            bad_reason = "page_pool leak";
> > > >      return bad_reason;
> > > >    }
> > > 
> > > This code have helped us catch leaks in the past.
> > > When this happens the result is that the page is marked as a bad page.
> > > 
> > > > 
> > > > @@ -1378,9 +1375,12 @@ __always_inline bool free_pages_prepare(struct page *page,
> > > >              mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> > > >              folio->mapping = NULL;
> > > >      }
> > > > -    if (unlikely(page_has_type(page)))
> > > > +    if (unlikely(page_has_type(page))) {
> > > > +            /* networking expects to clear its page type before releasing */
> > > > +            WARN_ON_ONCE(PageNetpp(page));
> > > >              /* Reset the page_type (which overlays _mapcount) */
> > > >              page->page_type = UINT_MAX;
> > > > +    }
> > > > 
> > > >      if (is_check_pages_enabled()) {
> > > >              if (free_page_is_bad(page))
> > > 
> > > What happens to the page? ... when it gets marked with:
> > >     page->page_type = UINT_MAX
> > > 
> > > Will it get freed and allowed to be used by others?
> > > - if so it can result in other hard-to-catch bugs
> > 
> > Yes, just like most other use-after-free from any other subsystem in the
> > kernel :)
> > 
> > The expectation is that such BUGs are found early during testing
> > (triggering a WARN) such that they can be fixed early.
> > 
> > But we could also report a bad page here and just stop (return false).
> 
> I think the WARN_ON_ONCE() makes the problematic situation detectable.
> However, if we should prevent the page from being used on the detection,
> sure, I can update the patch.

I will respin with the following diff folded on the top.

	Byungchul
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 01dd14123065..5ae55a5d7b5d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1377,7 +1377,10 @@ __always_inline bool free_pages_prepare(struct page *page,
 	}
 	if (unlikely(page_has_type(page))) {
 		/* networking expects to clear its page type before releasing */
-		WARN_ON_ONCE(PageNetpp(page));
+		if (unlikely(PageNetpp(page))) {
+			bad_page(page, "page_pool leak");
+			return false;
+		}
 		/* Reset the page_type (which overlays _mapcount) */
 		page->page_type = UINT_MAX;
 	}

> 
> Thanks,
> 	Byungchul
> 
> > 
> > --
> > Cheers
> > 
> > David

