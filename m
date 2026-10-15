Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F68ECC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5B76B008C; Thu, 15 Oct 2026 10:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6266B0092; Thu, 15 Oct 2026 10:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC646B00A3; Thu, 15 Oct 2026 10:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1CC6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:51:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C61D81605D9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:51:16 +0000 (UTC)
X-FDA: 85325148552.22.2962881
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 30643180003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:51:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HlatsEK8;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYCZTLgMdKAMbjDwe6rj3TCyhuIW3P4WAa+YVRWkZiM=;
	b=nz/HIkguP6e6T+9oI3N8TnGmP4Alp1/99n+vfwQ0MKTaenHewhBP1w2VYH8z87zYGFIH4K
	218H4BWMUoKYfqai6HWpaZ/LVIvLPxQ9qbtXbOceEA/AUa+mjKMUPyC7tZnKNLu6mOYo10
	VcTGe97fLvLWFfwFwkgr0jJf8Dl7vJI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HlatsEK8;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075875;
	b=VYS0mqqzsax3K+RYdDiLTP3a6/XYqMSMOIES2e5aUgNPLpn+8fjrAUvuBqvDvOD+6LYUHx
	5d5WWhjK4Q5Kq1qg+T+Lh9Uotw7pUFlhtZMypzsZ3rXor2hn4Ae6bx2n1f0JFPM9XNB4Fz
	DPgjGc1uLrZrnP84PLAJ2ll/MmmlZm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B443560120;
	Thu, 15 Oct 2026 14:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBCB1F000C4;
	Thu, 15 Oct 2026 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075874;
	bh=EYCZTLgMdKAMbjDwe6rj3TCyhuIW3P4WAa+YVRWkZiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlatsEK8fF2bnPYLhS8lSkjCXRwknERaPZN05duwpYlL5kJudW7XJ6Ac1MCKkJdCh
	 iuO0MWDTbEjNj7kHUqSH/QLnFurbKmExR3ipjqeDp7ujxfNToXdDZ2v6+Aba1thd3f
	 YYLqDfZN8nXBXxaVvzHBTNvM5zKFBgqAi4TM15E0/ICvsvohnjFnRt30oRsLym2U6v
	 YBQq3NhZzbUUJSFH7va0j8T57LOtkbtTuXWw0eQWKj0TCl66BVAurukQ4wESMHIkKg
	 CHeVpVsPssT/1Ut/aoP6CmzmMj7b2B/WjxzEx+EPxObETjXvDXD1nO1gzfYsw2hDXp
	 MaKCMk+Jlf4ng==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	ackerleytng@google.com,
	akpm@linux-foundation.org,
	chriscli@google.com,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jack@suse.cz,
	liam@infradead.org,
	muchun.song@linux.dev,
	shakeelb@meta.com,
	ziy@nvidia.com,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Date: Thu, 15 Oct 2026 07:51:06 -0700
Message-ID: <20261015145107.106608-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 30643180003
X-Rspam-User: 
X-Stat-Signature: 3mbwxuj1dec9dk9te9qb6bgcsqa8qfci
X-HE-Tag: 1792075875-160707
X-HE-Meta: U2FsdGVkX1+f/IDpFGJVrumJ1rbX6pvozrId0BoinlusPVlhjiQhmv018qAsnU0FUi1j2ZE1kmVJV7ZMraxj/A5xuLAP1aoXjiGS+aBpu4wzHWfoVM2k6szz9pKkjR6nDUmAZrFUeeJAl2e3hBvv1RnjS8jXfdf7LVqk4TonXPJwYmWBMw3hSM9Cyc2qATeoITCZ2yeW62NCiDwfIdYL/PshzgwI5Bxz6yIGgtQ2+ZKWRoyHxmZRTjZN5Ouz77JIZU+GFTpCxQl34lBaMd1Ldj1fU3Td1rkyAtmBUIo/bxhfdhVFJe9kQRDQiwwC6CY56lvt39fseubD7AxWBV83HPdaBo2kbnfZpByLybie3zODKVf8EoGf/OTgAwYiFJbsnlmnNrJ1bbB8BWF82CFTl/QVZvE0Y8/1fZNtX5MXuSbUIr8Moac/hzvgW090J4c0cuokSzNqZdC5iDHNI8TUwybZ6SvsgyP5ivFS2BEcvcQtp0Er7f29JzoK5mpwbIDDwQCiVQFFAz43xqyAr5AYE5Vl1GG3leUpVQehzh6wVF+8PzaV5qk/UKRlIMGFXIZtSLdZ++pgTnoxT82sLU9yvFy6pu7jX0Fn8kjMceLNUMHM0yGJIid2zfURPt8FStd5kKw/j1A+gJPKS8gFqMlafKYPDRS1IP/do/9xhhZDN4+qtnL7sl5/Kfw/Enil6h8CesRQ0ioUuIMrWr3Kij8dGIkWRmjrJw8xERTyVCejSjmTIZWtCXi8hp3H9RDVzfvz37Yf6nfQnkG7JHAVoP5ZePDmO9NU+iNv6vhb1zkSP15Id+cyUt/62Yw5wCixOLbURutxPW6nPSTvKw/Qpdd9Zdyu0rjpYyRrW1/eaVgQUWSOSgro+nkqboubw/abeg4WCNMTgBqgaSnVkkxK+DBzBCUdtCf20Ln+ZlYNMelEPniBekJZxDirn4SDr2Jf91PygCMAnzG+4xizSPY77VV
 me61kLsA
 hE3PcAbs9PMxCyKGmAMHEnJXM24qdqhFpPTF3zJcnZtEhLhIPcb+ZN0SB4p9gasLrXdfCVHCbVE7+vzeEVz916dbaqR1Uj6I7Nf8s/Afc+iAP5s6FQvHVuVEaTPN2tYq7iynbBnKiY3zlCVLTwG4Y6uLw6mFdSGK4qtK/GQQiH3kCQwYyMvaeitiOeDedl7WzcEpslQ1kSdDom9MXqni107jzIoDscswxon/JY6VMV/K4QbqLP3CMP78EgzAJcvRqfr19t2EMwSK7UjIS3vc7wGwHew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 10:38:14 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> (CCing all people attending the mm-next call)
> 
> Hi,
> 
> After talking to Roman at MS, he just informed me that sashiko now has a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately

Kudos to Roman and Sashiko team for developing the features.

> 
> That solves the key issue I had with sashiko: people/agents re-spinning stuff
> too fast before a human at least had the chance to jump in first.
> 
> I suggest the following sashiko change for linux-mm:
[...]
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
> 
> I'd say we start with 24h and see how it goes.
> 
> Thoughts?

Sounds good to me.  Thank you for suggesting this, David.

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

