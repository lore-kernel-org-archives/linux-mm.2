Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22287C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B3A6B00F1; Mon, 29 Jun 2026 09:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBF86B00F3; Mon, 29 Jun 2026 09:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC686B00F5; Mon, 29 Jun 2026 09:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93FE26B00F1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:23:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CD4F846F8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:23:26 +0000 (UTC)
X-FDA: 84933016812.17.09E37D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 838BDA000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:23:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0HZQCoy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782739404;
	b=DvVmSR1QDDIDp4c5LqUEgx0zglOPLiWuXBPIZN5aPbsah6iqHaHVS+U4zAPYWLjAMGfpMN
	ppKFcD25U2fRD9SUrHADERSmyCh8O9tZon2QxtQxPxHkCRPhQ5ZsMn3+ZSBb4fPS4aP01a
	YSGGcCY7IqkqN8zC6vgULdp+LvIQD+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782739404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlAxXYXVGgouR1BHxhqF05/N6yt8unJyYd+g+wHldrM=;
	b=yDJ9DcUxCIsu4M7wD9yUqbtolzfkrJ9vkMWKhINhdVdQpV2Cf+rX9CHI6ho+KQClNNtOIO
	kzDQ9YywrmX8xDur5XH3YMf68Br4YcL7FVrSDxu/rf5jMZKYsOA39I7xZTjM4YhlYxL8J2
	1Cx/F3dnvRQTsC+C/EzxNCg+9EpKMaw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0HZQCoy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A6E36001D;
	Mon, 29 Jun 2026 13:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457541F000E9;
	Mon, 29 Jun 2026 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782739403;
	bh=mlAxXYXVGgouR1BHxhqF05/N6yt8unJyYd+g+wHldrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0HZQCoycgaXPOttVMA87L/FwV0kiFBu9cH71xwSnUuV0mobalX62irez65uiFcKe
	 3k+zjWlQ6vgHLluq0Xl768naZIhvjIHmQU4RTJEtU/gtMpEU73d3PmEKZ4Ggocwoc4
	 18ELB7nnmHRqis5KbXLhAYeDxa+6CA9iZx/HpZI6vrjVqP8PHZiec/iWYUecgczzYN
	 SohbGcl3EvsI0ohHgx/0rCG4NnjCtqGAPkMTflCXorRjViYWx3PnoKOC0vRC+X6qDv
	 xXTX3+ntiRUL66dNz0BTBZwaRKYrYDqw7fiyZ303C5bmRr0rtU355T3Xzx+7IyYzac
	 rjpG9n1XOHzmw==
From: SJ Park <sj@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
Date: Mon, 29 Jun 2026 06:23:14 -0700
Message-ID: <20260629132314.159577-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <akJB9EYPerO90rEh@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 838BDA000B
X-Stat-Signature: anqjjb5gafkdroirronaqqqi5qxeptqp
X-HE-Tag: 1782739404-113515
X-HE-Meta: U2FsdGVkX1/creW7X/YEl92M2XiU9w8KcISWE2he+Vecm9/rW0dZ54Pa3djd7qs0fopcNFyRq/wz2fLJs6+yAQgdYy852iZ28iPXkzZqQLyeH2MRJPEKbFB8+hkbjUMZAuFXGtUssUkL0Etf1jR2kJOcRLgudoqhC3/EKynA1yr2lRuXLDgUlICYkT4VIaOIsZRl9tj2GcWqTL361WCc0tRRbIFE55BNN6BM8+HKMZZFKzv8SoqjIv6T3J5abxsvD6tT2HimZLIqgMjUoN48TypENK4UaoP/SJHtJACgzrZTD4oDOdxoXvel2aoPm5N8gPum2mhDEJM7hejHiQ29/GQWKo39D5RtMq33Wj97++1zMcfIoD8vtRwrq1aipFrO3iDdvMpaUVz4kBxHAN3LuqLY5ug1BkiAVTcYnfLM1Ada34WbuGOolsfh52M3m0uTW/HG/7CZ22uJR0ObjfYzTDIV4MNRSIT3FOasZVTn6SHdL3hB19+jpuoQcR/Z/gNxA4MZyJ3fnfwabAQcShF1BrMxiroxpCgpsD7uc3Z//t6G4Ngv/Q8BD3O/Fdf5FW/IC7h4rHB0mKaewh5DVYAvk3rXrYVii33oizQUmMzyE+O21RPH2doi8N9QvBv9zZfA+99ZAO7E0/soI18dfoDWzB5syeeJXuAdotDntYVnnOfRre0fPbQAFP/jZcBaSaoWtSFcsjGikBR2C/aT1wwUXu5OIzMk8IC+YYIdwH+KxlXZa60lW3vcynYmJ/m0c3e7VxYtgl7bqFFDDaDfjvTIlBfJzD1yxklkkRRXuArHhVmaQPuDEVrvmR3WfwzEV72hdqkRy1Nt05NfpqrJCnsf5pW5YY2B1+rQmbBEMyOrN98hcu9ZrXZh355YmSr2hQLYxwMoLmpNWqBsYqF4G7y8xJRbl5cxTYPgZvtuTLcLh5wabVpl75Gndned5dSJhncIhP1AHYMC13YcgobkZmp
 Oqc4LSSy
 vJorBuaASlsT1nwBDzYEJfdszvMJ6abylRFTkCv40LT+0yjgPJAhSH5B/AYFvbu0EuhkyJgnvOP0w9ktH/o0SHVVV8oGDoDYp3UFWs0Vln0EqRUF0UcnSvyGDqyhk+vlZ94Cv7OnW1gCHGt3NkLHuxsK0nk3sZsdV4/Oswas6DxNWLwHqkzilSxlHlLlj1Fk3ByiQ3xHtlgP8n5X+ldiyIwiPPP8tzfNK8/83yaT0aEvnXTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 10:59:25 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> On Mon, Jun 29, 2026 at 11:45:03AM +0200, David Hildenbrand (Arm) wrote:
> > On 6/29/26 11:37, Lorenzo Stoakes wrote:
> > > On Mon, Jun 29, 2026 at 11:25:52AM +0200, Pratyush Yadav wrote:
> > >> On Mon, Jun 29 2026, David Hildenbrand (Arm) wrote:
> > >>
> > >>>
> > >>> [...]
> > >>>
> > >>>
> > >>> Just curious, why do you drop the author and copyright information? (can you
> > >>> even drop the Amazon copyright note?)
> > >>
> > >> Off topic, but I am curious how these copyright notices are supposed to
> > >> work in the first place. From what I have seen, the person who creates
> > >> the file normally adds one for themselves/their employer. But then other
> > >> contributors who make small/medium changes don't add theirs, even though
> > >> they should hold the copyright for the code they added. Bigger refactors>> sometimes add a notice but that isn't done consistently either.
> >
> > Yes, I saw it on bigger stuff as well, but not on small stuff, really.
> >
> > >>
> > >> So do these notices even hold any value? They certainly don't list all
> > >> the entities who hold the copyright to the code in the file. Only git
> > >> log can tell you that. Is there even any point in adding them?
> > >
> > > It strikes me as a rather loose convention.
> > >
> > > I am not a lawyer, but I would say that individual and corporate ownership of
> > > code are implied by S-o-b, not by comments in files.
> >
> > Guess it gets interesting once the SOB does not carry that information. Also,
> > some people might work at company X (and send code from company mail address)
> > but may hold all copyright by themselves.
> >
> > So even the git log cannot tell that story.
> >
> > But in any case, I would expect a comment about that in the patch description :)
> 
> Right yeah that'd be nice agreed :)

Thank you for all the comments.  I intentionally removed those notes, becuase a
better information could be found from the git history (I was using amazon
corporate email when I initially sent the patch) and seems the notes will only
be outdated and may confuse people.  I'm not familiar with the law, though.
But again, thanks to git, I think I could revert necessary parts if anyone
claims.

And I agree this intentions is better to be clearly explained.  I will send v2
with the explanation.


Thanks,
SJ

[...]

