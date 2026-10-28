Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8984606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B8F6B05B5; Wed, 28 Oct 2026 10:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32986B05B7; Wed, 28 Oct 2026 10:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72F46B05B8; Wed, 28 Oct 2026 10:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B83406B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:41:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 532E740C5C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:41:56 +0000 (UTC)
X-FDA: 85372299432.08.A42CCFA
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C98240007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:41:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793198514;
	b=sICtR+dHpXcKVItVbn98jOaaEDI7Xs3hIpJbjahLc+z+w/8EHvvyP5OqFxkqyJq7UItsp9
	cHhfphcJG1ShXhFb0V3TT5tsHnqpeONEMn1gYM6My7HvYB307M7fvld71x9bvgHa5S92jN
	QISqlkfPOm0eGf2eS6G05UaZzgcKCL8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8RJ2Yn7WpwUCye9rkv6tfQ0zZ5Kyo7robmi/5qT0aAk=;
	b=lYzXjA+yHSWKnaiT390cHuoMq8GMY1ziGzJzd9H4zm6UvL9iNHdwfe6CkEw44+t+H68lgu
	2qZMczSPsYFlo5bGck/TGLGeKu6dbuI4d09bkCPt/otG+KHnuiSVX2zUr1UNUJlVgCGQ0n
	EUo8pwIM8MPfIb8bpUATRMIxZftn64Q=
Received: by verein.lst.de (Postfix, from userid 2407)
	id C578F68AFE; Wed, 28 Oct 2026 15:41:48 +0100 (CET)
Date: Wed, 28 Oct 2026 15:41:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: hannes@cmpxchg.org, abuehaze@amazon.com, akpm@linux-foundation.org,
	alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
	brendan.jackman@linux.dev, david@redhat.com, dgc@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matt@readmodwrite.com, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <20261028144148.GA14023@lst.de>
References: <arFBr22V60BMmVpl@cmpxchg.org> <20261027150002.318916-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027150002.318916-1-dipiets@amazon.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C98240007
X-Stat-Signature: aof9kkd7u5gupgcekwyfztghoia15rop
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793198514-145015
X-HE-Meta: U2FsdGVkX18O4YLhIPicUuGTQbRiSNIXCYbqeSbnZiqLdaiTLukVoGsPOCJaJPRRYBJn5y6kLtJFSUaWVXW0p3zl9GxgrH1UwVxrpT3M7Jti7JpErH3zoTXdxqdyUaBa2uyBNTThoifs6t/mmxW5qsCWuZtXiA4MXgkzGr5w7Vg/qVw1jXsIO4pSZsr9G6zZXuwNRLgMu8tgiNxV6ab5+BcEaF3TcPfuzr15NFFYhL2BihN89GYiDryAMm01OIde3AsOIfWs4ufRBoR08r6XUi3NJSQeIFM+VXxQ1UG0PEIYbqPKwO0DYOcnuQN3MaGSmKoFxbJPL3x2EiiZR4bePAnZWYcUuKCmDhQWEjQfvcY3Hdh4+HvWRMmX0frXqDaiz1bI8DtjOXA8uiI9HHITtcGGd1LQXacuqfKrnUK7Xxr3LfISEgGXgqT+/CidDzdhJjyNRv0S/pZINub5aVkJtrgVMyg24AFNhYXpBM4PKgsFWtUM8eiYSKndDTieLyF9XiMRCIsnU9aLNjH3j8Np9XZmcMKdyO8p/i+1xfFKjH1PzxDpiEhSAxyizFNIyq/VOkyWJ6F43tnjEasvNrWeGwcIVenp2bIhjZHjvqzbPX83HcqUpJrySRkaknVkwhRmJRmn7zEM8+SzPvjNp23bgwGlcrRBAk5DPlgCqDoHZFMozxlEsy8ANtpxjW1MgD5r1h4P1wOVUgJnvqOHcq6PJJAj1mLRGiXktMIrVa2hwDjaX476A/RkZVf/VBoSDlGD0TcvMcIuqH91G5s10WJOg2FED+CCnPwNPymm9NP5mRq0eWXylAlrem9GmN/f+R9sL6u0+W8vt17GHkxHpZwedXElMS96VhUdwqE8yKWp7lT6hdZraFZs/loI1b2oDZwAxB/2/+3qkd0fac6pMcY5lcY8p3I2xP2jkP8OQSnQJDhqCCRmzp0RqgnfAYdz7E7istHnyFMQqMK1n5dTeT8
 9fps6UnN
 uw6L7j/8jMiX9yrQsp1VtwaQBjL5ZVW3JQJYS5cZIwmjHGWw7CdcyGPh6Ot3u7s1HYxfiuGm/g6vGgsEoLiTQ4/iiayRCEvmdxkjlwDTsKyom1e/D0Ak0Qq3UNcdpPfTQL2P4yRz/rnYMot1WAJOvKLB5Pwucqd5yxCSUSZZe8md4+4AozaP/OgcsXawt/pKvetuHCQfLOyaif5GYiZmWnZdtKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> 
> Hi Johannes,
> 
> Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> before these two patches land, so Andrew parked v6 at the tail of
> mm-unstable and dropped its Cc: stable until then.
> 
> Are you still planning to work on 1/2 and 2/2, and if so, do you have
> a rough ETA? Or would you rather post them as a separate series as
> they are? If anything is needed on my side to move them forward, I'm
> happy to help.
> 
> For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> no performance difference on my benchmark with or without them.

It would be really important to get some fix for this into 7.3.
We can still perfect it later.


