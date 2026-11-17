Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75EE1606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hP4ZqYnA
Received: by kanga.kvack.org (Postfix)
	id 61F4E6B05B1; Tue, 17 Nov 2026 05:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0726B05B4; Tue, 17 Nov 2026 05:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C05C6B05B5; Tue, 17 Nov 2026 05:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 197C06B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:28:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 869241C2254
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:28:38 +0000 (UTC)
X-FDA: 85444237116.27.14A6443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 817C940007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:28:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hP4ZqYnA;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794911316;
	b=Z520wk9vOa9bKwFij5gDUln89FszbAhVUquy8RwMcNqHqFoLxHmhTLZJF6WjV4h4M8uT/W
	OdXYbymAnGJu2H6Q0+/iILsTy/2H8jR5cHjvdcrkndlP9cXclQIwhCbalWqyW3znkYH8yT
	5Axfm8RGMtGAYnGSoTwEH1IM7CMQUPs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hP4ZqYnA;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794911316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUuc456jVRsmRWx54q8uCKHa7yeIdCKeWb6UY4IYup8=;
	b=qJFB4cpHZn8K7M97+F/sqdEI1/u8VtEq0QOwWgEXqLE4k8SPSEhHDOCjI6+n9sDM3zGsn9
	Hs2sJLqrIi+QJUvj5Y3O/9UhtLF+tBfyNEcW30xlJGtNR8Ou/0QUYt5nyNRQgVT5DH0IQl
	a2YRlrfsxkdYs2fS1gnz+uKbFwYefxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDEEC4163A;
	Tue, 17 Nov 2026 10:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA191F000C4;
	Tue, 17 Nov 2026 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911314;
	bh=aUuc456jVRsmRWx54q8uCKHa7yeIdCKeWb6UY4IYup8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hP4ZqYnAcliINUm3HE1RI/55CUjTkg3u4O507VK4VDlkAnyGDgK5yjYEYOq3NW3cP
	 +FB+r5tElC8n+LOYI6HAozO5JLFi7wOzM/IsUa5skpD10ZL9LNKYQCqjc9r/eUhqA0
	 BYhD3lavJuyMKCGqLJqvDNzwBdpbNo271tDeFfC+nmMWG1iluD9K95v3jD1+6+Olce
	 o2AyFd6Ew4t31F/37ybedCzflXhOlb10591Y9httqiaggxcAmcoEyxPbkkBLTw+sjo
	 1QyphzjZCDnjgRS847XGqLB0FDBRFuuyeL1KoeSuaQW2KZqUghvj4eYrIQiHMYhxp9
	 7HUxG5jiBX50Q==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 466DA198003A;
	Tue, 17 Nov 2026 05:28:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 17 Nov 2026 05:28:32 -0500
X-ME-Sender: <xms:TSz8akoIJ8VUdPzL2SAiWezRgl-xK2V1RTwV_qy8_po38gJ4Z-kejQ>
    <xme:TSz8ajv5tywZhKakde_bPAmx3iEyufG7ZFZ8S33VIQLqLr5Jksk3g-fQGtraUnigc
    pzqEIUaP2eojkS-JWGjbs3iPBQmqgT7sirtzjnlSEQmTSeuqV8XBn3p>
X-ME-Received: <xmr:TSz8aiR9EEX3NPPPgJeP7O8Kc4pvyuP2AgHF7-LAs4rWoYPBn7JNAf1LXr4>
X-ME-Proxy-Cause: dmFkZTEyk12DcAQuIlTI2xJtbrOBSs+QrfdgWAvOUBdNOkqljsjgvALIdBr7Jffnf/Vh9w
    FK7xcfJVC+STgtN1Cz2GRI2Kh104UxI95eHtE//tBhmqi2hu6pIyaAgxIzhFuC7GMEXmVo
    Tpq1KL61++h1aClhBiPt5I2Yn3jUWMVxis1ka23Rhc7KaS3ObGJFW9Th80E4+x5RcGGPbe
    pnS+zPR15R+jxQWkbj/jQwUNfYD8cZtLC4S4+TDMS1BwSEY5tBktOjQjVazb6rpLDly24h
    9gC+Vqt8lr1zsFqyi6SwbGj5AtzFivZws+QSr5kkFEAH3QIzrdy2/D+0X7rQ4Xq1GklHiq
    wr1w3kJJH3vFW6cRjI3TiaxeaipF5h7UYumzTynQh88nyDwB2dB4ttLfqfae9hhwVIqMlP
    Xv2Se5iFpRzxNm5zEDAvHXtq19X/u/2icBThVFdLeh8OMxfDQADC6dXkMXkHOqvfiowEM8
    yilSsrPCZoUftz8loKWlB7Sv+NAIwystEO7qIRBOtTwJ5Ln7PtPn1KKUJfVXRArqYOGzCO
    QkApXqsq47Nx7BaCdwxvS0y0erKA0U/GHlU2g1PnXlx3/6vb8u7BQNcHqOEg/nFSdcYMiO
    RZ39dUYlu4I6e2iTb5goZox7sX/U0lukWx8YhPpjGBMlrfRSc4xIsQucLWWA
X-ME-Proxy: <xmx:TSz8anofhu7nNmVpvzT2pcY6RSTlJIgjs34zEeA4En6hvuVgwZnPXA>
    <xmx:TSz8atIJszYvWLsH6P2BumTmmcn7RuntqIDDfHQy15asFAthMe_tlQ>
    <xmx:TSz8aqORVjb07TSUxsL9ffSizIxS_a13Aqjri1kOT8m3ziR5nSlKcw>
    <xmx:TSz8aopJgLyZZ_LS8fMSIt_-3-0fX2aE1MS5DP_qttsTERHtv60NgA>
    <xmx:TSz8asGRw07OZlo26V4Qm4Tz0MATWMtrfGOnYElGyj61HDuwfmNxwEQf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 05:28:29 -0500 (EST)
Date: Tue, 17 Nov 2026 10:28:28 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/compaction: do not skip the free scanner's periodic
 lock drop
Message-ID: <avwrmTszH4tNSIjA@shutemov.name>
References: <20261116125746.2897395-1-kas@kernel.org>
 <ad8a7751-c9c1-4b0c-969b-27efd0945dc1@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad8a7751-c9c1-4b0c-969b-27efd0945dc1@arm.com>
X-Stat-Signature: h1n6yxu1kpze6mmmuane5effsfdnob3n
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 817C940007
X-HE-Tag: 1794911316-16055
X-HE-Meta: U2FsdGVkX1/NjdHPjH6Yq1wscLfkOcAA6h9Ou1hpYUhtOoUUZuF8RVIYCvjM4JrkJYojwF2o+XLvUn4OPiefaj2tOfGZZ2/1buF2QCqx0saL2g4mHePgN5HGWRzt9px9eRUVWTLDxlgs9fPTg/ZTIL6YPClJU0aeJC4V+1nn5iPmafo6h7WlegeZUL1xJLtiGNAkMem1lcU6ereDaRzmnq8jv0qxqIQd2emDjE6wlJz5tnhzW+bH8n0ntgTEIN1MkKw7ZFYbxPO5cPLB78qXCTLWSnNsFDylF2OOCrhhBcFK9QPa2utMbxwVGho+yv/KSLOP2CdjZyKq/FA+j9QK4FUIorW31kxUBSsXg2p65Z1+Gl6lxuvmyYQGzeVNLACBJpVb40sxUyM/fXDHZraoFB2kZX0a39+9sy7rgoVmIZrHnFCOam3KseEadPca2Z7AF/7qZFgtxgbpClqF+PD+KyVM8CFjim2xph/BtJmOOl8RWY7RjPSiTwTbINcX8D5s4FiwRzDqdetS6DrVaiZX5YC1OUpriwVO51vFcLrh1/RbYZjbgRJT04W/m3x+RWfKUHFl5VlYRb7fT/sjQGB8uswHKCSdt7tvzVxEjnox632tzB5yI1hKu9PbQGXygyQ0XXGWVdep8mJ8OSRBpCBA/n9nlVyCid7acEwfRE1qpQChLRn4y2rmCaPvGeHfcVrcU4fH4PpNMNPCL4qyA/vODo9qCIVuSk3REj1LfVA8BZRLdMbDOqU9MyLVqir0oBE0MGsLEixlXw9XWyvuRB75J2F8GyF6zak0qgY31A2Z2v0QfVSO8fC5BhII+/jFIYlnG+0rNnNvB/7TiEm1og8cTu3sKY/2unblIl0cvgcx2nWhCsL4pWiGAVIX3ggEIQOaG50AXWTCQSgO8giWlfswNrbfHuc0lH6T/sALQL9si0W24Zs0iKZ4exDLvJ9vX7Kr7R5dp5kakY0A75HdSB4
 Gg985FdB
 vRKrgKw2zck/Ixx75kqJm6AcS2wQMLDcsktgyV0bbkwSWyK+0yDTIKB5p3m5COxTbuJYH7nlI+ybCWD2mN4+fFg8mia/3PMU7Tg/1qo0ZvXo8WaMDH0Ja1T7keUrKU5mHVldAsbdAjkY34DSbuiYLacuytZn22QzmFtTUYFgGh9nu+bvOXjJOyzDrRym5jncaIQbdYMBm5/lX2hzdxYb2rka0vqW4lRMGl5JP6Ew3S8MkJ7ToY2aOa6WtqSL4RutxdC5ldJjnqKNW1RKw+r3O74r3dDAvvZ9NeQ6ADhdsdVhtyNhTDQ8Egv8KstE5FEI8QtZLDCdpNXVEV30jjuMkrPJCYX42mq9MbiH0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:04:25AM +0530, Dev Jain wrote:
> 
> 
> On 16/11/26 6:27 pm, Kiryl Shutsemau (Meta) wrote:
> > isolate_freepages_block() drops zone->lock, checks for a fatal signal
> > and calls cond_resched() at every pfn that is a multiple of
> > COMPACT_CLUSTER_MAX.
> > 
> > With a stride above one, the scan steps over a compound page, or over a
> > high-order free page it has just isolated, to a pfn that is not a
> > multiple of the stride.  From there it never reaches a multiple of
> > COMPACT_CLUSTER_MAX, so the rest of the pageblock is scanned without the
> > check, possibly with zone->lock held and interrupts off.
> > 
> > Count probes instead, and check every COMPACT_CLUSTER_MAX of them.
> > 
> > Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> 
> Cc stable?

I have not seen real world problem triggered by the bug. I don't think
it is needed.

> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Thanks!

> >  mm/compaction.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index f1b2060eb201..4465c1551406 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -579,7 +579,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  				unsigned int stride,
> >  				bool strict)
> >  {
> > -	int nr_scanned = 0, total_isolated = 0;
> > +	int nr_scanned = 0, nr_probes = 0, total_isolated = 0;
> >  	struct page *page;
> >  	unsigned long flags = 0;
> >  	bool locked = false;
> > @@ -599,13 +599,15 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  		/*
> >  		 * Periodically drop the lock (if held) regardless of its
> >  		 * contention, to give chance to IRQs. Abort if fatal signal
> > -		 * pending.
> > +		 * pending. Count probes rather than pfns, as the scan does not
> > +		 * always land on a multiple of COMPACT_CLUSTER_MAX.
> >  		 */
> > -		if (!(blockpfn % COMPACT_CLUSTER_MAX)
> > -		    && compact_unlock_should_abort(&cc->zone->lock, flags,
> > -								&locked, cc))
> > +		if (!(nr_probes % COMPACT_CLUSTER_MAX) &&
> > +		    compact_unlock_should_abort(&cc->zone->lock, flags,
> > +						&locked, cc))
> 
> I see this is an unrelated change but I don't mind.

&& on the new line looks odd to me, it belongs to the first line.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

