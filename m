Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AADFCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499436B0005; Thu, 11 Jun 2026 23:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449C36B0088; Thu, 11 Jun 2026 23:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FBB6B008C; Thu, 11 Jun 2026 23:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24EE16B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:40:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FEEDA016A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:40:43 +0000 (UTC)
X-FDA: 84869858766.12.ED10315
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A2A340009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:40:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DXBXuwaW;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781235642;
	b=G+blIcnWJCTzcoRmKQsWer7bnx82V5RFjHdBUv7VR9kY28HJuOyNiPkJhp3EE6fRtwNPQH
	rlx5L1xkmO/+jEygK5pLHb5G2wGTDFtlibggo4yyMUzhCwt2ddjqzA26NUvdoflJECmeD3
	M0t6TdqLOIf06oth5IkaiM9D3wjblM4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DXBXuwaW;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781235641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfLPaJC56I4XkY2NPI72JW3HnSJltKglVGN+5coME0Q=;
	b=2lUSSG1nGJuE6LMqNMyeEdzFxVYhaT3/35M8fh5JMxX/6kUtuJ9Uw1tt6yPuDJFYRJFGED
	uQwOil4e9b+ILK3Gpt88Ddi4QOPwM2DbGw8euFxz/mE5HC7sAuhylGE4HTb2YxveDQrBHL
	JoB2czVpYB55o20yeJNE/CmqMekIn1U=
Date: Fri, 12 Jun 2026 11:40:29 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781235636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qfLPaJC56I4XkY2NPI72JW3HnSJltKglVGN+5coME0Q=;
	b=DXBXuwaWtBhtEquMwhJK55BZyLnNIpUQg4d3bUQvQBgl94aho1yeJLRUUNCFJyipK6sVLa
	VdXPqxUySWjiadhlO6YiiHwQTsTfKpUlN2zcRUb2PUcbYvZVlRD5iWH5Etl6I2i/8naFoc
	NYP6gt11SEIBIiHUsHtVvgGo4EEvQ1s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, youngjun.park@lge.com, jp.kobryn@linux.dev,
	usama.arif@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <ait_rZUchteKu9-p@MiWiFi-R3L-srv>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev>
 <air7FCRQneIPiJ5l@linux.dev>
 <aitb-XwJ0gRiOqPW@MiWiFi-R3L-srv>
 <CAGsJ_4yFgcvpTAZ_YV73+U=BEnOiSxaFtGNFpbf0DWBkVcOQ3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yFgcvpTAZ_YV73+U=BEnOiSxaFtGNFpbf0DWBkVcOQ3Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1A2A340009
X-Stat-Signature: pby6m7a46shf8yirytfatbxysqm7i5ht
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781235639-211619
X-HE-Meta: U2FsdGVkX193BztdwFYp3t3CGe21ImrnEC3gMxg3MrYpBO9G7O8NH40EvDJ+PLwZV+5uqDI2y+IQS/aLrbyR9wVTDKaws9bUORysELUqpR1c4y0r7O6mayoc4qaq6voX7eXPBo9U1G42YTxU5TZOCxMdDYTV5J8zaT5U6z4XnTu+QiU/nOFR4GKUqLED8v1wVHCUrMfefo+LvhDvy3+0vBd6lTmZOCZug0wP/E/166i0BGmmyexLvCW1NTOf2di9xi0pIM2QKnvBiEAeRwp3jDq7+NsBpEXyUfr5aiulV4k9zVowJsZC1LcLQpNf3iY2spafnKL7qP5vfTCUZI7ZKH42Sj6DcY87KwkbeMRjSO04ptX9pO8RqfYNTJA6lt/IggZmS3t+Mwmni/oovKcKzC+IFufJ5dA8NgxvSXCGwNPZFNRNrLn2fGGrXRBJsERoQzXReWEdNPn+BGJQijF1d7ZQi/WwCkdDGjc+aR8WM2Ika07InEJIuEjthGD/VpyAHPhzTBheeztTsPmiB0nliM284++T/xwVBYD4Or+vtCPzIYHBxBlDw/vQy+9isUm7Z5HXMQihyomXrzEQs9YKKRmyxEeGWUD0IoFeiwAJPf4l+h4FKFmgiJ09UkTBLzc0vGhne4Inq9NSooBCc6WLSV8qS1/gAEmsgjivJzoZH2bImToGxj/2eCQmQXMghCmrUzGHjXpl5B6PJD6wqRTUVE84VTyNXQp4nXDL1YLkRL5cjR8JvIsJyPJjrm1a//pEtqipjh6k8rs43X5bo5huit6qrFb73I0EWdQ0jfuyfH74LFagTbRgGn+S+lzmmqdwRasbLjc9VNPLvy42JgdvGAWjullpXyz/j+FRvbIPBagINJ19hcg6c2uu/bwMFhqG/kIbNtyg9I4vs3Jm3s5bbXrBaWVyblDyhTmSThHJ2mCrJpK2f6BUIOGqFgXMGblEJU6GOggTpXMX+AeTrvS
 G6CgOkiW
 71sgj9pEX/0m8PaUwRCGo5DV622ii1540+KXPwF/N+LFi5W/7DtSCxvsmyFVlm5xq/fplKoimPioK34i+8RdHS490sVJB1IZ04prgFon1XzDVwho9DZYOf/CKMy66+pzbJXomOPEwV/Uwlm+jQVChk/9bt5Gg4hSZX90g9pk2++ffTsEvCyutOXaHP2djaxdfdqUGJI7DkB2Gr1zdxGlotlnCZyaVoI3WfbRJkF5IPFd9gEB8qQ/abjTQMWPUAuNSbCipPdaSJNau9XdLLNCPR0zgBzjOwyC4gp7LOIz1J5z3NjWB1e1x812NrpP6XnzFrZIEUSFXChLd/vIE7OfzzXz4AaAERz17fUDd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/12/26 at 09:57am, Barry Song wrote:
> On Fri, Jun 12, 2026 at 9:08 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 06/11/26 at 11:17am, Shakeel Butt wrote:
> > > On Thu, Jun 11, 2026 at 11:09:43AM -0700, Shakeel Butt wrote:
> > > > On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > > > > We always unconditionally drain the LRU before retrying anon folio
> > > > > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > > > > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > > > > drains.
> > > > >
> > > > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > > > ---
> > > > >  mm/memory.c | 8 +++++++-
> > > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > index 56be920c56d7..487a34377a7b 100644
> > > > > --- a/mm/memory.c
> > > > > +++ b/mm/memory.c
> > > > > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
> > > > >    */
> > > > >   if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > > > >           return false;
> > > > > - if (!folio_test_lru(folio))
> > > > > + if (!folio_test_lru(folio)) {
> > > > > +         /*
> > > > > +          * Assume folio is on lru_cache and holds a cache reference.
> > > > > +          */
> > > > > +         if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> > > > > +                 return false;
> > > >
> > > > In your experiments, how much amount of drains were reduced due to this specific
> > > > check?
> > > >
> > > > I wonder if that data can motivate to introduce lru_add_drain_folio(folio) which
> > > > only drains if the given folio is in the local lru_add cache.
> > >
> > > Actually if we can peek into lru_add cache and folio_ref_count(folio) is exactly
> > > equal to (2 + folio_test_swapcache(folio)) and folio is not on LRU then we can
> > > just reuse folio if it is in lru_add cache without draining, right?
> >
> > Sounds more reasonable if we can only touch the wanted folio if it
> > exists in pvec. Believe it can improve efficiency more than the
> > current patch.
> >
> 
> Technically yes, but in practice it seems quite hard. As I explained
> to Shakeel, we don't have an easy way to determine whether a folio is
> sitting in the lru_cache. !folio_test_lru(folio) only tells us that
> the folio may either have been removed from the LRU or still be
> sitting in the lru_cache; it does not distinguish between the two.
> Unless we want to scan the lru_cache to look up the folio, we may need
> a dedicated folio flag, similar to PG_lru, to indicate lru_cache
> membership -
> I guess people would be quite unhappy about adding a new flag?
> 
> On the other hand, the folio may be sitting in the lru_cache of
> another CPU, which the current drain cannot flush. As things stand
> today, the drain only succeeds if the folio happens to be queued on
> the current CPU's lru_cache, giving it roughly a 1/nr_cpus chance of
> working. drain_all would clearly be too expensive to avoid.

BAM, sitting in other CPU's pvec is a real barrier. If it's in local
cpu, it definitely deserves a try as Shakeel said, when refcount = (2 +
folio_test_swapcache(folio)). 

Then the current solution is optimal at present.

> 
> So another possibility is to drop this drain as well. The folio can
> be released later, at the cost of missing some opportunities for
> reuse.
> 
> Best Regards
> Barry

