Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84000FEFB6C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29076B0005; Fri, 27 Feb 2026 10:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B65A6B0088; Fri, 27 Feb 2026 10:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF446B0089; Fri, 27 Feb 2026 10:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E95E6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:54:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B03A5A7CF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:54:58 +0000 (UTC)
X-FDA: 84490685076.15.E805B53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9602740010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:54:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ENrQJObo;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772207696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eA36SXxm4opYLqUn9vzWvNyB7TxLqBsV2xqV6ejeLfw=;
	b=OOGRJSo+T7h9FdgFQScxEUyatiaRWSxEAm1GvtY4V0+gqZ4eqjxOsBoaW2ys5DRpIC2WQr
	4H1JqK4m9hZSy6ZjHJFAR7+tLxDiDInviXY/Qi3XOT3MHi7f/Vilw14vgyusPr11OM6DZB
	3gq0rEaNetkyDbtJv9d9vBtT/buYPXo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ENrQJObo;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772207696; a=rsa-sha256;
	cv=none;
	b=opFjs60t9Emiv0w4o5qJzk8+n0Sh8nNbxI7K/JnWbtlmbH4m+tvv62/sZya2ZWC0StNJQb
	lnd65mRR9qblvLOlZhZhpARsKFOnkK/peQuqqRnAhC6Y7QbMccvOngkGCAylMsQwKGW4ey
	I3plvZVomx8XNJxD0Sr0sDul87cXQhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5D1960008;
	Fri, 27 Feb 2026 15:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74DAC2BC86;
	Fri, 27 Feb 2026 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772207695;
	bh=4Zzb6q5slBlEtb0w5Mzsgczf8qRMEZD8SPQwYZ9pCDk=;
	h=Date:From:Subject:To:Cc:From;
	b=ENrQJObooEAFRLew5F6BNGix6CnzQ9MSnRmbu4CHT3zoQeThkNacIc0P3q9vkF7HY
	 xtvEVhkNcDxKnToAtFQut6jR4752ASMf8H0jx1YO42DA4tIyqYHXb6gtFUPIfZRauf
	 aC+LGzoZ+yudtcU+PONr1EXGJQQ6JvuqVvFgSXyqUj0fqM1RP5ncMu3ITVriC0cI19
	 W2xMcK5DkaNfTl1AMrMcaExlxzDSJYzPq4VkSM4Ts0WWThwAs0gOTaAXBCmtqnukG7
	 f0zXa/SvjVOpfTl54vdCj6j1WpBdg2KT5ztGn0fw9Q8ihfq6JWBy0QBYIHSCF4JqIv
	 ZWiEgETuED3TA==
Message-ID: <682fcb79-bf65-4af7-87fe-bb28274e96a6@kernel.org>
Date: Fri, 27 Feb 2026 16:54:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.0-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9602740010
X-Stat-Signature: ghnhn4j4beojxq8qhtqzpo7grii5xh7h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772207696-931446
X-HE-Meta: U2FsdGVkX1/Tw9slusYobAd++yGqLp0a87h/QWZDTsNOwhJhDckJWIKczPltam/bFomTEs2ULMdtJnkpbN/I9UdRe5HZbufO1LCqLy05f8T7Pftib9lz8T1AzMaJ35cCA0IfikUyWYFXFKJK1RTeHIb3MNRZEIBDOplqxDEbpaGAUEEBogUgUpgOKLYGn1bGKpxEl4k7+8GjfSM5everG/NHdfDJz9eb44xlTT2N8fjHeaIVyV0jEif/tTof+9YaRgI41GISeYCiHWJ3fEZdvPfBiWl6mhloBOdnAhNauXsDVe8yqneWSCFDdF7Uo5QMycGGcDr0P2mJJ8FGgMHi8TMe4bQNIJ3uAjjtpvdRLcjmFckJs1HlStyx/SKZfUE5RyjnuHsOCHZhTFhJ5wJHe05kTlnjCM6Q3arPTmm1KQgT9223XgPyG0FFp0iFQUT2sBthA6KeZm7V9mGowuRobdiqgUzXpe6foLGgX4lfptU/CSQeWqT34Sd+L1BG8bwZF8CaIWccy7zrXeSiaxa1Rz2YwSG48nNbUbIojZIxram9Ui9ICXH7/X7RCujeAEMFf6PDeADZL1dCxl40yF8dFNEVxIR/birnEQevfFuln9EUD0scFvpHrlYsnGFkoqrWxfmfHvhXGz5km4zNkXIDRO7AaC099aq11SK4OYS5gtQELJkco7IoARcWvPjlQG70qKdKC3Tn+8/j+Boqz2sWcuC75ZreN1/jYph1sdBHTxrI8IYwApOQjc47/UC00nrseqmNzy2jgjjdUl4H4I0K5dHLFFbjDt+mti9g01a2NhJI+1kb6O5gd3mGeBzUmvw//L+dHWDfOc2hU7FqqPXnX3WFXeelIFCyGjWZujMb/285tNbdJxBWA0f50UYBapMG/njn9u0RQjgB+s3qtEXVIUbyQhN+liJYBmWhY4agpFBXil4AAMv5VAmL4cfPRNnm4+J8WtJwn4uoaf6hfwS
 QZ8qf1ri
 fjnxIiEzgfZQOqiP/A4z1YDrK6JK1NraTofrqYMCxTG0E76HKVBL3w0r4BR03hyohm8rM9t3XporagSprVz5kpzIZH9hIeRb6v2r1vS5xM7LAGa4CLZdfKsnlpNlicot/9XYW7qpAeO3cRBzTyew1QfXAhHpBMh7QGWwnv7YC8e0bITUV8cBwcL7xZKxJPTRa9tZibjzTL1GA4781Qm0ti4C0oYR2Q+RxF6yZMGEMQuCIrXgJ5hGJbl9xrAb+dwWHuBjQGcgYKkm9kPCoyfbdONsZh7mY4wrXGRt+hog6xnAV1Npdk+QrHYEVPoh4XXYORUM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc1

Note my externally facing mail address changed, which should be in
MAINTAINERS and .mailmap by now.

Thanks,
Vlastimil

======================================

- Fix for spurious page allocation warnings on sheaf refill (Harry Yoo)

- Fix for CONFIG_MEM_ALLOC_PROFILING_DEBUG warnings (Suren Baghdasaryan)

- Fix for kernel-doc warning on ksize() (Sanjay Chitroda)

- Fix to avoid setting slab->stride later than on slab allocation. Doesn't
  yet fix the reports from powerpc; debugging is making progress.
  (Harry Yoo)

----------------------------------------------------------------
The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc1

for you to fetch changes up to e9217ca77dc35b4978db0fe901685ddb3f1e223a:

  mm/slab: initialize slab->stride early to avoid memory ordering issues (2026-02-27 16:22:57 +0100)

----------------------------------------------------------------
slab fixes for 7.0-rc1

----------------------------------------------------------------
Harry Yoo (2):
      mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback is available
      mm/slab: initialize slab->stride early to avoid memory ordering issues

Sanjay Chitroda (1):
      mm/slub: drop duplicate kernel-doc for ksize()

Suren Baghdasaryan (1):
      mm/slab: mark alloc tags empty for sheaves allocated with __GFP_NO_OBJ_EXT

 include/linux/gfp_types.h |  2 ++
 include/linux/slab.h      | 12 -----------
 mm/slab.h                 |  4 ++--
 mm/slub.c                 | 51 ++++++++++++++++++++++++++++++++---------------
 4 files changed, 39 insertions(+), 30 deletions(-)

