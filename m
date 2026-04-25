Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417ACFF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 01:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA5B6B0005; Fri, 24 Apr 2026 21:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B0A6B008A; Fri, 24 Apr 2026 21:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A396B008C; Fri, 24 Apr 2026 21:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 409746B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:12:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0C1FC09E5
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:12:36 +0000 (UTC)
X-FDA: 84695303112.06.A507F35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 225A9C000E
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:12:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrRUtSPb;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777079555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Iym8A6bnuhwROPZaXbuhVpB4CGx45TjbkRvW+Wx0yQ=;
	b=F9BoVIHjSqC45J8cnq3A2IOOMqKd7LR7mjDbymtyB1MTTJe7HzVPW1HvRKfOZ5bP1hCyNE
	Ar7BCfGw62baGqvHVv40yRkBcp6O9vQBkIS1lOV/B7FHgajt/fpHo6yUzDRDu2vxSOw5mM
	tQcNwLe1/OdLqCSB8aW/97txc6wQyrQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrRUtSPb;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777079555; a=rsa-sha256;
	cv=none;
	b=N9tWxUdF/EGhRXlWYjKhhCumRYWz0u12cfdmgrSlXoCeav21ut0QfdglHmYP5JqgnfneCn
	u2YUBqER1iCCkHMrPuSn6TPOq6Nb9fw/mpl/kG4SbkoY6kJq8zr38F956sv4Xyg9Yo6v+7
	62F1tsxZwBtDIIvZYHyhZIJMwP5b67A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8548F60052;
	Sat, 25 Apr 2026 01:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D479C2BCB2;
	Sat, 25 Apr 2026 01:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777079554;
	bh=kLGofZVDjG/mCzrm1LRRVMOEwwqZ3rDNeHAHTirfbaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrRUtSPbpCYF9NFEliEIjHHeYQcZ66l1VWvOXUU8wfQAq5VLZuRqmfsSGZbBfEVhr
	 ElLh2ilGqlOTwJ2VXwXW4hqCPW3axHoWKImRIWkIApx0GIqQUbK3iuAoOvXKr4hurG
	 LkxowpnzN/tZFyA0UmYmFy6Gym+yJC0tOuZHMJls2H+E95YRt3OS5O6b/wXgjkM+OV
	 jY6rXzHRtx8T4iTgkd7MgWE3AmzuAqW034nBcXgAGsXq53YbpqtwXofjq0oM7/4FiO
	 563qADLY2NVkI1knPbVwA1zM45NLL50cqB7IZeuZWN/uo1JdJaR3Pny7SZW9J2LXlo
	 QKU/bwYk0cYag==
From: SeongJae Park <sj@kernel.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>,
	peterz@infradead.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Fri, 24 Apr 2026 18:12:22 -0700
Message-ID: <20260425011223.85854-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAO9r8zO4eSiAK9U-ijzWJMK80XsK+LmFxGAG+nTo+tmK6aLfYA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: con1qfadc81my9gp68x8jdooqwsa9z96
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 225A9C000E
X-Rspam-User: 
X-HE-Tag: 1777079554-661150
X-HE-Meta: U2FsdGVkX1/uZRlNOKRNMQK8uyDDZ0lNhZidF8itTq/yiegMuDU2jEY25DKFQs0X1rqJ74IuGXVfEB0ay+6eB4bMR3hh6GEcl+HsLlGFSth5qvkOWR4wdAzNzsPpaVYd8VRXez6BV0JTFmdB2RhRALuQgz2BFF8j3n/9r8hIOIjFywy3o40XD28Pjt1NaBHT/NSpvJakQ68Q2FT0UzZIW1bGGbZJEChWHPRT5FOKJ+wV7SSgi5h3mUUL/RXM44skfivVliDRunHunjwyNVF/2AGx5Q1cAaY4V53wXMmd42f72Mq9mDG6Mn/jjkIGsWew9nDq02zpFi3r7BTaxUJrpQNwC2qPibKKvE9+Ok0iFTqBL9bO0H1crPjU0hQvRtFrJy+lAMA6AeVuv7Vp95XWszU9rwK7rv8tl8VMNhaxdKCflkeFtvE4WPvgG0FPUM90xLIA2d74dEQ05AIXopa7ksGl4FC1oYOHTBSy2ZoarIIP1684wdB12pHIgNOIW03XrdxClT/24rg1zkXHDoMPm0Ze3vPwxsc1SZtKDh85/CSlsnXag+xUDzo0rj9P8qorLzpsytF4/DfPZ6zRpKOUpvwaoa2MyPi7JBH6hm+47ha5/OgMnmDcmJeZSA5x674bDHKYalrY0xEbnSxB/XaHT3pjtML6YVcI5f9DkjfJXxrUh91y6d4EN7shXhbPfHR2ooE3Ml9xVjZ6JAUhuOGPN8+btHSCNXPOGvkX/hTzWEhZYulc9s1+++Be/01ELvlwRF0UScZf6N8CqvPlJzPJjDBBU3bW5c8pPDZp9BBMV8fvXMjEBPihTGt0X2whFmssCEIgWMP8FhFILcl030/QZMWkaRSGdF3NJxKQxQse7GYiN01fxn9idtQzdltSqMhD9Bk8SKS+Dh3Kp72xxoVm99+RZpk/ceQcqN2/ye6r5VYQsqAmiNXHgUrliAJXdcnjvQVb04tpaaOT8LOxGvL
 +BNbt0LG
 UddcPbT/FMxVu/eseJKH3YFwXePlJuua5NywkLZw721oC+D7hRYmtKSKyRiIdQvvA9RvgK/WIL3w7QLz/BDycK4zMTkVXUXNB805cp7a773WsSbF8lAX5GuxpizcYWUof2J8BSzStw3TbXr4y6f6HQHsqbAJ1QENRvN/wzMwzQkGA2zcJeLEfYiFgXFNMu/qFtqJZzNeFN78G9OWL+M5XJvjFq09p8QXpgLdh6/1Gh1AsU7JdA8zDtKzid2dtxzyAxA0A0yhxPbRaT/4zZwDDHZQfMag+l4KEVfX4pMLgomNmG0FDRu49cidZ0TtKEeFF4W33XEUOLnPTTZvOpzbMLTHvwCJnZr+Hyvbz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 12:18:49 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Fri, Apr 24, 2026 at 12:09 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 4/24/26 20:50, Yosry Ahmed wrote:
> > > On Fri, Apr 24, 2026 at 11:36 AM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 4/24/26 16:31, Andrew Morton wrote:
> > >>>
> > >>>
> > >>> Why do you think so?
> > >>
> > >> The most important part for me is that authors are aware of the reports.
> > >>
> > >> Sending them as a mail forces people to publicly reply to the feedback, and at
> > >> this point in time, I am not convinced that that is the right approach.
> > >
> > > But I imagine it's useful for reviewers to see Sashiko's feedback as
> > > well (without having to go look on the website).
> >
> > I read a lot of them, yes. Maintainers know how to find it.
> >
> > I even think maintainers should  briefly go over it before applying to spot if
> > anything in there is still left unanswered. But that doesn't need a mailing list
> > posting.
> >
> > I enjoy if contributors are aware of the reports and use that input in a
> > reasonable, like Zi just did [1]. And if they are unsure, they usually ask to
> > double-check.
> >
> > [1] https://lore.kernel.org/r/15191F7F-0D10-4907-B963-DA4EA0E36EB6@nvidia.com
> >
> > > It's possible that
> > > Sashiko is right but the author isn't convinced, so getting more eyes
> > > on the feedback would help.
> >
> > Forcing contributors to reply to everything. I don't like that, in particular
> > not as long as there is no way for contributors to run it early in private.
> >
> > In most cases, contributors just do the reasonable thing: incorporate the
> > feedback in a new version.
> 
> The usefulness of the mailing list posting is that it makes it easier
> to respond and discuss the review. Yes, what Zi did is great, but it
> would be nice if contributors/reviewers didn't need to manually quote
> Sashiko.

I agree.  I had to implement hkml-Sashiko integration [1] to avoid the manual
works.  People could use such existign tools or develop their own.  But I can
say Sashiko's direct mailing service has improved my dasy much more than the
hkml feature.

> 
> That being said, I understand the concerns and the pressure to respond
> to everything as you mention below. Maybe at some point this will
> become an easier decision to make as reviews become more refined.

I agree here, too.  Apparently [2] my tooling-motivated Sashiko reply
forwarding didn't convince all.  My honest feeling was that it is not only
unconvincing but might making someone slightly annoyed.

I personally feel no problem at Sashiko review is publicly replied to my
patches, but I understand my personality is not necessarily same to others.  If
some change can make someone happy while also making someone sad, I'm up to
reducing sadness.

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list
[2] https://lore.kernel.org/20260331045245.67438-1-sj@kernel.org/


Thanks,
SJ

