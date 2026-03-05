Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B362F3092C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3D86B00A7; Thu,  5 Mar 2026 07:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDC96B00AC; Thu,  5 Mar 2026 07:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEAF26B00AE; Thu,  5 Mar 2026 07:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC8956B00A7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:46:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 347A514011C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:46:39 +0000 (UTC)
X-FDA: 84511983318.17.9CBD207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 88A671C0006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:46:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kN0xWwK+;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772714797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AS28BV2LArq5Gd7gZIjeCX8n005pfRWTBqnRSFxBes=;
	b=8FGYxMMu5ZutzvwGUyJIeGqCvO5FsnLhzSKnJFG5qWAcK+YWtPm3fK97FcMZRt6TENBjDg
	PtZg3INtNcsOAVu21XqCe7KsMUfRM6fYKBAQ5hiMr5JwQm7n4x5Tf1Y7ABuVbn26SP5Gdb
	lRopCO0otjgsL8feUeffzEca+gSRTuM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772714797; a=rsa-sha256;
	cv=none;
	b=opm0pmJZrPGHn/VGSETC/LcKbKNKUhkTEIoQPz+Q/VbBR7MvSjYS76wsrtXAcsRPq0Xa3D
	fvZcGe1WKcZAeFadwltJsI7ZAeetY8yc7MM9q6iXNbXhQoIciPSO7GaVq5c0n8IOg0vj75
	gGSq9HtN5R/NA8GYbEYR1mZMtzbmlVw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kN0xWwK+;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9254D41A41;
	Thu,  5 Mar 2026 12:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC8FC19423;
	Thu,  5 Mar 2026 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772714796;
	bh=Qdwfpvgsgpr6yfgAg3OTdpdcikiTy4SkbiVRhMT24LA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kN0xWwK+CXTs++d6bbglMvxLbDAwcfPrJQHp1YKBJbeBPJjM7DFNDWMpEsmC0pmVh
	 SD5PwI0Jdv0dpedYAo5lRPXR+2JJ+WPV28cuRNAlW4wzu7+nmbpTEKCvPRAqH2qXBe
	 mi0JbWbsWCu1ItDHcljgtKUPoc9nXsrWdbx2XAqUjMZSJEEQOp4/YAJ4322pa8pnxm
	 Z8fZqclTkKV9z6STUU1HC0zIKyTaKtcZ2mO6pyhDLQf0u1ctse/YzA4/A8ehPaEORj
	 hPIA7DihX5R+bATvQhaSOG8jMH352nFj+d9oq7qgbL/xKvuAb9rWAaRaPtIobxQ63Z
	 X9ot2UYRfYxfA==
Date: Thu, 5 Mar 2026 12:46:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Message-ID: <8042a515-e88a-4b4c-a5ab-d4eb6deaf4b3@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <aagSrIwiFM7GaL1m@thinkstation>
 <e46c8bd6-9f6b-4985-bec5-fef6c8f33dfe@lucifer.local>
 <ae48168f-c88c-4f74-8cf6-ab90f6c97c68@kernel.org>
 <cac26373-2323-4897-992b-5cc56e2b9481@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac26373-2323-4897-992b-5cc56e2b9481@lucifer.local>
X-Stat-Signature: d1zgtcmk7drnkbr49nyt3ugyb8bzx6ss
X-Rspam-User: 
X-Rspamd-Queue-Id: 88A671C0006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772714797-376775
X-HE-Meta: U2FsdGVkX1+uukMzIi4sDxPKjvfFFy7rC5YtrDQi9RuWwlT0Ob2hlBfoNIqt2YC1utQRJQOMMrIBhToVxk3TTGlro4wphFhFKQbPraHsWzL0j9TgNJWB2F/NBfz/0PX2QzHLrZ7F15hg1vvZ3RLW053fPl7PanMMwl42wIm3q+IMjaOB2/qJNNrrLpJ1Uy9nXbqtFeDCU/TxcY6+fCRSSDjvZ4RLTaqpuqo3huCZBEgAWU3hn0n1pTFWJXrWW7B3jgNE35OCA7Z1ZCw71BRkMZFr8Sn8+iU7OrtMadG9gbO+JlTmJpNEKYKVzkXGrjTkXoMQYnVPItXfeZ8UN5mDYZNocs6xA2rqw5LaUf8YRfTf09b8FplNKZQRCFb4GWGggVndzexjcWATcrVhh86KqBD0fkbue3MtxE38PvklrHqMNBPQukBl0cyNh+m7NzFOydNm0p38UmrnczyLAIHZV0z+y4bIrNzjfcevnnAkhfs4hi6mJODYxdF79NbQVLLYy7EctV020Hu8NGyXjr1LBZpfPPxJu2Y+qkYAgT00YqCkCjWSNr29NcTagAFCUMRyZYfh8BHvnFb3Lq89sts+SHL0mHcq0M4k2vsgikM9L1ouWmEtpGHtLlHTXETM3jj/kaTyiCpQoXqvmzUughV7p+iXx255ldIE/e5J9A/hFHGv7DcWg8Ve50ymP9fF9+ylNWdUUv3U2tt46gIrFBrXYHUiDB53V8MfjUJNdQPn4hQuSrt6ur5crfUK8w32p820sCHuOPfoAu16/eEe+QMU6mvw4j7grGc5tVJXNTPAqTMwJVhWLGdOENMXFOOCttMDbNKXMAF4gJ+LoHNRu/QxP9g4NkeouSfyGjKJrCm5281gdHKZb2ygRHSN4OY+gUKYYgM+MsPGejZ+fNV+muRvRCs0LrtH/6ixQXPvNONdA+QNIO6w8klxjOOEgaXNjOSZ9QwznHh/NH4dfwv9FUx
 TzobUC2R
 0hH4FWlTwUToQ4p6oJjkg3jq5UdmrQ0ZAj6bqfTrbSVamIccdj+1Fti5YL2RP8rBhJBkvMSiCQTruF44aBRFbrBaLGn1QprWVxyby7Cycp/4Mhi3pvx2yK3TFf/T/zSoHpzRFmI4bSVguuFH/5mvnk80gpOt9ZOeJi8rsnGJlVPBjheQL0VZSkEUbJkv+S7wQS2T5vPlBwiExt/qArsz7fic1rTexJcrSYm2gQ1gvSkH6EJ3Na+jEPfWL55p86EpTlUzHuWzeMY1VSvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 12:45:56PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 05, 2026 at 01:41:33PM +0100, David Hildenbrand (Arm) wrote:
> >
> > >> +
> > >> +	/* Check if anything has to be done */
> > >> +	if (hugepage_pmd_enabled() == !!khugepaged_thread)
> > >
> > > This is horrible, better to break out the latter expression as a small static
> > > function like:
> > >
> > > static bool is_khugepaged_thread_running(void)
> > > {
> > > 	if (khugepaged_thread)
> > > 		return true;
> > > 	return false;
> >
> > return khugepaged_thread;
> >
> > should do the trick, given taht the return type of the function is a bool :)
>
> Yeah I know :)
>
> I mean it's subjective, but this form makes it clear that what you're returning
> is _not_ a boolean.

Sorry obviously meant to say what you're TESTING not what you're RETURNING.

>
> I was a bit 'meh' when I first saw this pattern, but it's grown on me, sort of a
> 'make it so simple you can't get confused' kinda thing.
>
> >
> > > }
> >
> > --
> > Cheers,
> >
> > David
>
> Cheers, Lorenzo

