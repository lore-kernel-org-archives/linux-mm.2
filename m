Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6285CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 12:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E901D6B0088; Mon, 22 Jun 2026 08:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41986B008A; Mon, 22 Jun 2026 08:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09BF6B008C; Mon, 22 Jun 2026 08:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97FCE6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:17:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC21C12012D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:17:00 +0000 (UTC)
X-FDA: 84907447800.04.9979689
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 167F21A0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:16:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VO3IdVzy;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782130619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1euf1uJU62E8XFUXqV3rFKeTmuDeiqg608jtJ97nyzE=;
	b=kb9wnUhpidx7P7km6JFhnhfecO3BDFI43wGekhvgRwtZ9aHYVYrTwbsM6xVe5TBjTZHptn
	5rg3GyJMWC03Aw70e02mmtpgRUotlg495+njFKGcVFrpYPUVmbtaYCCkuuMcCxNiZl5a9q
	WLGtWMt4nQ2KsDUx59eGMHzrvJ3vhQ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782130619;
	b=HjYKtjJr6nYJ+hNdEuTFKaK7PDW6wWxyPc3B6DRfAPWMaZZTTgcWPNt9XHNUMZn+c4KHYi
	2ldPgnunW1H6ImcNXyTdajbiYHVSDjPj/PLpPpMDsyIWTRRzLGZD8R6S4Fs/PrzFSfYh1/
	VO53q1T5bf5QOuKlwNcu89ar6rKlDEU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VO3IdVzy;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0342600AF;
	Mon, 22 Jun 2026 12:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731B51F000E9;
	Mon, 22 Jun 2026 12:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782130618;
	bh=1euf1uJU62E8XFUXqV3rFKeTmuDeiqg608jtJ97nyzE=;
	h=Date:From:Subject:To:Cc;
	b=VO3IdVzyIZheMuDilwOUirhN+mzaKygayeJuduNxngpWvNx7KQx0LO5PbLgzo+G81
	 MLtS9dI49BXq7qDuW2pXrNV/bgKBGH+S+E9HFIaovc+YBRTlMd3QTnfAZGirq+qZJj
	 sk0I3yoGxhm9bbTq8ztkSwfD4AMltUKuTiepDJIQKSFiErJ5tybxpCc3BzUNQLmVqo
	 N5z/y1cyLkpTJp1LTu7NooNnR6mSt61ZW62NFDJV3SzOJBr2fkkSs7I4lYYfHSetx/
	 hrjlV781mlqHwT27ba7W/6EnnuMIKOhd1NrFqvpcW5kMOtiRVpcRzPEpcdTTWkH1mc
	 ZwPgSjB9O1FRA==
Message-ID: <ceea5c00-cb30-4ca6-9824-a993d9712497@kernel.org>
Date: Mon, 22 Jun 2026 14:16:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab updates for 7.2 - part 2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k4ykhgn145qe7j3umnwyuswja46f3yqd
X-Rspamd-Queue-Id: 167F21A0005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782130618-673414
X-HE-Meta: U2FsdGVkX18cb2LX9nKnPERn8iyMcf4D6dbg+aRXc7K+j6nwlQyT4HF4xh/jEeERD+eV02NMSyVlxkJkXL1yFHqdmYrCTblw0hcpsggbwhn7fjywuZqvQ2Dq4yN+WDr9tkfBLm7UEQ8kQ34yKqahlQ1l1rI463l1SUcyJlE9gqY0HWA1v/4qsbMSEZYCuODcOKP1s+zmd891RjBPxHOCAMKZ/1P+ovkhj5J/tznktJI9/ZlOcpHz463REC+u+GZhcvWnfbO4vvMtORL9xSre15AFDWnYTJgj6EQMHpEE4dr4xw1EEQzQ7teL6Cwl/z4YCOtta2YSI6mC1nBxleVUTAf1cKZ5msye28ZYEmOwGeEN80n2PJJaTTEyuYefZNmOVFNPz2P9Pp/aAyp1nvUp55DeDk5I0dMWo27cdsHWMZVMfA0sdUQDRzgyeQYH3fOrfZC4zWw5npyH1zVjUL5kfmnRCXDqGgTdzCNwce3RhzTPpEd6CxqjE6xutrx5F1LbTQikYtpljbSHfRNgjJ1QnT8yw2oEr+8NaL+BEeN84TjjDxYtOu6yI1ofcO91HX1exHPp7Y44O256JGoAHvMwgoqIbM6qSlyZxG14DfbYv0PY/jogAnkTfJmyrcURXc9zJMMov/qVF+aPRRpGormIdcCgG6ue94UNjhBe/NmpWuYX0crTynAF5GRs55YYgXN8ZXCYdCMXneWvX90u/sLatWbachxYX6x9jUm4ewPI6CzW2L+QSkpnQKpCtDfVGGy/+iz6FDZsuIWDcnJSao/Muz0M8e33q3Y2Xl+09p9Nb546PY68FpPO7Hq+HNNp4UAzlgnndBb4lBxuSHo2fgvbO98LH4fQcopBKOPp/Od+vjkNW5ox2xSt152nyHu523B1zeYbhIEjJM00S2h7RmDAtO5brKFsHSO7ijWyb4Nq3PkrXgkukY2udol00U1kiH8XLU3e29i+fwtGArnSLnc
 9AZ5GjuY
 8Zm2gTFpwxBwh+nN1Ws0e9YC+k11Grir2BRVkuDEVjxoEto+jryAIpkkOJqETtpMIs4AbwdS7j+ltIZJDBb9kbYAsNPDpCYBT5WtYMGEQxtxtGhxE7QVBEi+j5G6SHoQvDGKkHNy8T7eZHuAtyN0TW+Cb1gdsQc9JTJm6FonGnM8+GVzrZRxplGXlGyI2JcfS8lkB88ywdyNMAmv3YKQIdxhjAAw4qYmhlcakvus0qtiKMAMvD2qGDEZlql/bl642zIfYpzwKUHhizqwdFEcAjXaPsqY9u3cl1TmFvY6NLj4c1ZGwyjmV77UEYYBtO0As7v2G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2-part2

The bigger changes have been in -next before merge window, but due to promised
reviews I've waited the extra week (and got them) for this. Most of it is rather
mechanistic, but touches a lot of code, so it will help to have it in 7.2-rc1
to base upcoming for-7.3 stuff (e.g. bpf_arena_alloc() or kfree_rcu_nolock())
on that.

Thanks,
Vlastimil

======================================

- Introduce and wire up a new alloc_flags parameter for modifying slab-specific
  behavior without adding or reusing gfp flags. Also introduce slab_alloc_context
  to keep function parameter bloat in check. Both are similar to what the page
  allocator does. kmalloc_flags() exposes alloc_flags for mm-internal users.

  SLAB_ALLOC_NOLOCK flag is used to implement kmalloc_nolock() behavior without
  relying on lack of __GFP_RECLAIM, which caused false positives with workarounds
  like fd3634312a04 ("debugobject: Make it work with deferred page initialization
  - again"). SLAB_ALLOC_NO_RECURSE replaces __GFP_NO_OBJ_EXT, which could have
  been removed, but pending memory allocation profiling changes in mm tree have
  grown a new user - there is however a work ongoing to replace that too, so
  __GFP_NO_OBJ_EXT should eventually be removed. (Vlastimil Babka)

- Add kmem_buckets_alloc_track_caller() with a user to be added in the net tree.
  (Pedro Falcato)

- Fixes for kernel-doc and slabinfo (Randy Dunlap, Yichong Chen).

----------------------------------------------------------------
The following changes since commit 5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2

for you to fetch changes up to dfdfd58cce1c3f5df8733b64595448996c08e424:

  Merge branch 'slab/for-7.2/alloc_token' into slab/for-next (2026-06-12 11:25:12 +0200)

The following changes since commit dfdfd58cce1c3f5df8733b64595448996c08e424:

  Merge branch 'slab/for-7.2/alloc_token' into slab/for-next (2026-06-12 11:25:12 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2-part2

for you to fetch changes up to 892a7864730775c3dbee2a39e9ead4fa8d4256e7:

  tools/mm/slabinfo: fix total_objects attribute name (2026-06-18 11:19:43 +0200)

----------------------------------------------------------------
slab changes for 7.2 - part 2

----------------------------------------------------------------
Pedro Falcato (1):
      mm/slab: add a node-track-caller variant for kmem buckets allocation

Randy Dunlap (1):
      slab: recognize @GFP parameter as optional in kernel-doc

Vlastimil Babka (SUSE) (15):
      mm/slab: do not init any kfence objects on allocation
      mm/slab: stop inlining __slab_alloc_node()
      mm/slab: introduce slab_alloc_context
      mm/slab: introduce alloc_flags and SLAB_ALLOC_NOLOCK
      mm/slab: replace struct partial_context with slab_alloc_context
      mm/slab: add alloc_flags to slab_alloc_context
      mm/slab: pass alloc_flags to new slab allocation
      mm/slab: pass alloc_flags through slab_post_alloc_hook() chain
      mm/slab: replace slab_alloc_node() parameters with slab_alloc_context
      mm/slab: allow kmem_cache_alloc_bulk() with any gfp flags
      mm/slab: pass slab_alloc_context to __do_kmalloc_node()
      mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN for kmalloc_nolock()
      mm/slab: introduce kmalloc_flags()
      mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
      mm/slab: replace __GFP_NO_OBJ_EXT with SLAB_ALLOC_NO_RECURSE for sheaves

Yichong Chen (1):
      tools/mm/slabinfo: fix total_objects attribute name

 include/linux/slab.h |  18 +-
 mm/kfence/core.c     |   2 +-
 mm/memcontrol.c      |   5 +-
 mm/slab.h            |  29 ++-
 mm/slub.c            | 488 +++++++++++++++++++++++++++++++--------------------
 tools/mm/slabinfo.c  |   4 +-
 6 files changed, 340 insertions(+), 206 deletions(-)


