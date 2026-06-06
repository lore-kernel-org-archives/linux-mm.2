Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A15CD6E7E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C583A6B0088; Fri,  5 Jun 2026 20:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C092F6B008A; Fri,  5 Jun 2026 20:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EF66B008C; Fri,  5 Jun 2026 20:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A04A86B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:01:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B814120330
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:01:49 +0000 (UTC)
X-FDA: 84847534338.14.8DB3831
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 86DE014000B
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:01:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsUaZ3qP;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780704107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqWYuw9fMZ0HJi94khPWYsnX8/BSDjE/fdElKDO8oUI=;
	b=QMyNfN+UMcVvVXthJ3WAhwLn6a3j9S7eFUTxev19HjFOn0xOsAwlYX++aaA32h45fdjZKI
	bBvHcjrU/Xa1SHUYTqEQCQ9Tr+QHsZV3+SkAg1vrrQp5YK0aP+5U/KGLClYZ0FI08sY0g/
	FOfW+bUQobamUuMr12BKoc8SbcEA7vw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsUaZ3qP;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780704107;
	b=WhLAXOgxx79rhSrZwUSkyS9aUW+oHmIam9J3dC911CmjgASZIPclBTSWZcwk5prK7rS/Eo
	gTw4AFvox24V6ybX6SMp8GJafo1ecdP6Qx0p2saB1Uj5QG1G0orLQDkAMQAoDAJtnhCAvP
	29gz9tQtUjUkCLVmc33m8fb/SeZ67tc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B2B34024E;
	Sat,  6 Jun 2026 00:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF021F00893;
	Sat,  6 Jun 2026 00:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780704106;
	bh=pqWYuw9fMZ0HJi94khPWYsnX8/BSDjE/fdElKDO8oUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsUaZ3qPlL1jbAyzayrQRb+dyjgqQoq+2mYizaMceSAnuP7GoL81jreSO0O8hQqqs
	 oUGG8RZ1flCtXeCi1+u3mY/K9j/e07C/JUQbqed6cWiStrOSR7if7Gu2v1Q3tkQDtY
	 BM8YfUCXu/AZlOAsG2YvvQ3nTpBw9Bomh7tBFaoLsBAFZY/QngBoZ+uSjhPN9VytDF
	 NzPxhvTzH7vHs7ZTE3ngtfhM6Msp/IkSdUQXHPCyJgUhKnFEc6j0vfmgOHvxujCulB
	 idtoLFfAh9iLJZG2k5xbmeA0pKooJ5ULDQFySMkGdQ6VjMAC/y7LqX3fo1rSKC7xI/
	 M0PZ1i+83pkcA==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <npache@redhat.com>,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	vbabka@suse.cz,
	willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP) collapse support
Date: Fri,  5 Jun 2026 17:01:42 -0700
Message-ID: <20260606000142.88128-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2ca2c36d-318a-4668-bce9-3a0387135904@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86DE014000B
X-Stat-Signature: 4oj6izijsefzx9cydbnx9rhbni6m3qte
X-Rspam-User: 
X-HE-Tag: 1780704107-895088
X-HE-Meta: U2FsdGVkX1/MtuNfA/7Xqgg9lJGc9Tq8xK1ZeNoAZemKFNmMhxO9GX5nzP8XDFr5v+ladpRG9BIgrsmIuulfcVO88w0mP1DsM/voFhpslgIIfKsbtGyvjsvwgRlKH7D7vfGWrrqztyC4/J5sze3qhJwEKoViy1x16tDEMWXNpRLFKDcQ9jwo6KzvsZV4++HyjbI4v9IDNINESP1wyP8VCdzaxE3Q5otTlNHiTVwzbCxF/UmPugw1xC50sAPsD5A9wNhM3QsEdYxNEGc45oWtwxPu/QEMZjL7P63eI9WCQXAFsTkIAr61HoebUiBYmyDaQDnY2BXc/OHnDjvcEGHjYArNSYyx1y/hSx/qzv9SuxaYouswQB3hUnGD7ynOOlf9H6ZZ6axRIsvgMquxzEvUkRm3UGI31vH/gHwX0aP6G2Hm4RkQxDBCa/fq2+/nVoSembAF3Vu1IAQuEGo2cO33ziTZf3vsaVDGFcPg+6OirvLKEpo1wbRiDW404fLi78tVSJdfQSL5gRuFZI8/CcviBI/gjfPwJXX5kL3rMjkPO4UsZ3pES3m2Z8qtbmg8WJBqj3ABwvJldS5fjs6SPytqJava1JaiZWgFcTrK0x2bwVR232ZyNO+RK1MpEkddIVDj/WwoAampOWE1dXxbTJf742TKZbaVPH1tm2AdwH1JdLTwFk4CJ7iDbXMS+EM32eItjyUmkVTarehtsMojpKQk5KTWEbLrzg0ShOVUoGIb3PunrF5Jpi3/bsIQKppIAceYsun+jsyi7mSVPcnVNehdWIDBVDv4mHWXk7UM3xXf/W/fYjr+xPh2A8rEE4xJFUW4S2lqusM11GqrmH6I7utHF4aHPGiXhWAuMmVaH0TwkzvySqFBF+Z4JmmPLNNs7s+JvghhilOiYhUcYP4Qjna2LzsvNdwnxQiu0Qgkp75+8t/cLYljBG48MP5MV0UnGbBlIdzCEu6uc1IA0fK6zwN
 0bu0ml2U
 L9xptMCLI9tlUmTUF3NydpzM3r4PYKzdxfP3/ymOIz+yQu2Vp1fdxNdAI/BFmJ6ESl78roPboYV+JMqR2iBKLfFjtnsLEvuA1eAtrwSza+NZH78CD8YjV17BMoBkG2UsH5IDARkOBiGMgc9lWZmrvDf41dsIiVfjetVgUYP5sHdfD868rl06d5/CawWlKM9rYZ7pqLeZY5Z0HZXe3Y+34vtBe8e/ilGRZK9QRn8QU9cSydT7pJStYp+rjxDUXvUqXmugM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 17:24:25 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 6/3/26 03:48, SeongJae Park wrote:
> > On Tue, 2 Jun 2026 15:16:27 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> >> On 6/2/26 15:08, Vlastimil Babka (SUSE) wrote:
[...]
> I guess, as a first step, we'll document something similar to what TIP documents
> in that regard.

Sounds like a good plan :)

[...]
> I'm sure we'll figure out how bad one approach or the other is as we move
> forward, we can always adjust that. Conflicts will haunt us :)
> 
> But I assume, independent of what we document, we will always have people that
> submit to arbitrary trees, and it will be out job to make sense of it (or ask to
> resend).
> 
> Documentation is good, as long as people read it ...

Agreed.  Nonetheless, even when people don't read it, it helps us typing less,
since we can give them a link to the doc instead of repeatedly explaining the
details.  And thankfully some people do read it when we gie the link.  At least
a few contribution guides in DAMON maintainer entry document [1] helped me in
the way.

> 
> > 
> > mm-next maintainer's perspective might see many different things, though.  I
> > will be more than glad to be learn what I'm missing and get enlightened.
> > 
> > Anyway I think both approaches may work, and we can learn from others and
> > trying on our own.  I will be happy to help when there is something that I can
> > help. :)
> 
> That's the right spirit! :)
> 
> We'll discuss this topic in more detail as we move forward!

Fully agreed, and appreciate your effort on this!

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html


Thanks,
SJ

[...]

