Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEFFC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBACB6B0092; Fri, 11 Sep 2026 10:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B856B0093; Fri, 11 Sep 2026 10:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81776B0096; Fri, 11 Sep 2026 10:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B8F6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:29:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18104401F3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:29:03 +0000 (UTC)
X-FDA: 85201713366.05.32EBD2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 81C504000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:29:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bD1M6nDs;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136941;
	b=mj+8HsAJCQrPvYK7qvhWKimipYNSebcUpvoihiwoGSsdCo+GASLc4eekn5+QfPgerwPu5c
	YcMqf6safwnxDB+0r+WgoBmincuEamgA1WrxeBNeVex759x8LuTq2Qrqz2QH7pB6VCxYGT
	E1dIY76osfT8Z4TPcd8aX51G5L2+w+k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bD1M6nDs;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+imRWCTv6smcDNW//4365ucDiUEC8sAvOg5IdNe59U=;
	b=Z692qzr3PSbuvKTjRScLclbNCrNfl/zi2ZESN64NecFpeHm0HlW2nb67Rx79QjipU1vfXj
	7CLL/PNlpHvHxXVSuXj7Dbzc88Kc/kLVXeJOE89rtO2vuN7kmFt4dJocZB0quZoELTWcV5
	5y2RDfV66kSh7RU+zYkG+kFrstOR9dY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA2066020C;
	Fri, 11 Sep 2026 14:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBE21F00893;
	Fri, 11 Sep 2026 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789136940;
	bh=0+imRWCTv6smcDNW//4365ucDiUEC8sAvOg5IdNe59U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bD1M6nDshZEVXr+zFg8cAzmUh5bAdEXi7GQkHl2Re16P6383OWnqmoO8NEtKOgEIX
	 Dah2KCz4CUVivNTolTFCCZWU8NraTm8iVHKOxA5RSuMDdyY/iDCXVxvQ5PkwSrAtqi
	 yj79boC2n3vYk/5nt3oxrGq1K1cE2Z/JVdI8ORZGVv5UsPQyj/K22FJN9J3axvOT94
	 97nUl6QUb5M5c9UMQ13YUV1HRht1VXgndRk/6lpGzr94wZmidlgLWOSqiXLnae6ss0
	 gNH33cr5ey0+btv9y0d6DOXmi69b3i0cmpDjzz5F+Wa1yMifs/STNghRfHPzzchcXC
	 uk8VQsIPls4Zw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Fri, 11 Sep 2026 07:28:52 -0700
Message-ID: <20260911142852.98297-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81C504000D
X-Stat-Signature: bbrpa4hmefkn9r5dfnhwouuxof6ndxqu
X-Rspam-User: 
X-HE-Tag: 1789136941-654434
X-HE-Meta: U2FsdGVkX18L305fqjo2oGGagA6O44SWfrKD4z2ur5QVoHk903XBLdsWnMQYlno6HRfxowB5QnYMXI5Z+Vyv9+Ns6yFkkseHaR2oI4dd/XZOIzyWRDaA/abcCU1o8Yz91ZIc8h89xecnp9ktdZX2Am6pXfXuqSNznsqWW6Yd5znD7DrJcAbnGtaVihoEADM0DL9GPCHy6yfVEDR7UU8RBcQvI4jlhB6yhZTTRYRtQJZG+r4MGVcMhnG1t4ScM8v0mSPreVBXopFQ7xd3OJr08PJIEsrWJvrKLDiGpTb7T+cw3GV8vSH6Ee2/dbAOzG6QZ0pQ+wsRL5vszszM8Nw59/dSNmSgbZWYBrebAhSMWO7xJrhFegCqj6v+QeafFHvvfX2DXABX1MwvYNFjfKmRFx/KddnRcLmIOLVMKlZ2nZG5oB1m7qfilGOmZ0994DKq1JzVIQ1w1ild94pJPLjVP+pFGs/KNJL2Yw81AAehS7kuxulK0AnUftMCl5lpuB+7S7JA87w92WWtdeXbesL3KHhmUqQ9WI9sTfiW7a4k7WSkAbnpBKMp6N1i24MNcWb8L+Ub5IyinsvQAARIy5VtX6Lj5Uf3Hg+ZMWKmqMBqVKdWXcrQWAzltcGGZC6h3qRlrEfx5/AzcpQN4A3VNouNsVSVqOoQCSAwxluhoOukaHVvASIXcDuQvolNBAAbSiBHc+varEx2paU9ZdBclZyEoV8vudYKCe+Ywr4rr+WtOWv1ri40XFBCjlplRJ9ix8QPY9VCheUcsZ0qh6mJHK4/njeqNC9sPoMIehLHkbPBT4usa/d1iPmbYSEEPXP9f7yM/FuRs4qnb887oa9N4Cx2gzAiCZTivfKjZl8o/p5Eq1yWDJOUh4rZnXT9IkhKyOCdbKXe+yNArQmfdEn6k6gCLr5QPy5KB8ZzIDQeBw/k5F7U8UZxK2y9hptqYd348ykWaXWwE2ft8ZUkY+SxSIS
 IqQLFCrf
 OCaWhq+M+A70OEpkTDWyUPM0qO4fFqE2sA0eH9IXxIWTpnyouMpTyiQDGYWd5zMcEon/idgv/G016OflhtEm0XEVF0TbIcztnTevz65S/+E6nJRBZwWxLX9HqD0r4NnZbnqegDgkZy4ek+hrZeOgk2odkyHvdh3woA6OIFz/gwfZUQHrhEH5EPqCQ20iBWWDBHE8pUQNzz61YolbauJyYzGvwtMGx+aMtpBW1xjCi6ssFQgIWeXDga57MGETQrc9UsAYfpcWACtPmuvSGPelumUhZxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 06:55:02 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON can do flexible data attributes monitoring.  The classical data
> access monitoring can also be done using the attributes monitoring.  The
> access event is just one of the data attributes that DAMON supports.
> Users do monitoring to make some actions based on it.  DAMOS is a
> feature for automating that.  However, DAMOS cannot utilize the data
> attributes monitoring results.  It is still Data "Access"
> Monitoring-based Operation Schemes.  It requires users to set the target
> "access" pattern.
> 
> DAMOS core filter is effectively the same as the target access pattern.
> It is just a more generalized and flexible way of describing the
> operation action target region.  Introduce a new DAMOS core filter type,
> probe_hits_wsum.  It specifies the filter target based on a range of the
> probe hits weighted sum.  Using this, users can apply DAMOS actions to
> regions of specific data attributes pattern.

Sashiko found no blocker for this series but a minor documentation issue that
better to be clearified.  Because it is too trivial for reposting entire series
in my opinion, I asked Andrew to pick a fixup [1] for that together.

Sashiko send its findings to damon@ mailing list [2], and I reply those if
anything needs to be clarified.  Please refer to those for details.

[1] https://lore.kernel.org/20260911142522.98013-1-sj@kernel.org
[2] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

