Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22396CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCB06B00F6; Mon, 18 Aug 2025 20:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4D16B00F8; Mon, 18 Aug 2025 20:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA256B00F9; Mon, 18 Aug 2025 20:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73D9D6B00F6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:36:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04002827F3
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:24 +0000 (UTC)
X-FDA: 83791640730.03.7C6762E
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf22.hostedemail.com (Postfix) with ESMTP id 18AC4C0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=TbAf2y1n;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="D/1JpP9M";
	spf=pass (imf22.hostedemail.com: domain of boris@bur.io designates 103.168.172.145 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755563783; a=rsa-sha256;
	cv=none;
	b=wVnvEekLGHXQpfPtTyB4LmJs3JlauBWXpfcoJAU5+E/5lAYmIdEMnoDCJLMzHEqbE5ALxn
	n3QNfvukwaOcLe9A8QJ7TrcOIaHkEuG2sE8WRUenVEHvepKe8jQijlI4cAuTqx9ubT88aA
	8fcyPOusysUqdVFjB8ekSxF/lcMXThE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=TbAf2y1n;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="D/1JpP9M";
	spf=pass (imf22.hostedemail.com: domain of boris@bur.io designates 103.168.172.145 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755563783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/Ev8ptTbSa6crLCiddX4DLFg5va4F4iq3QV7Ft+6OUA=;
	b=s+24uFN+Q0PbA0S4j/B50s3lx4pVSGXNX9+KlnRWEHwOOwEIn7pOtTzaduCHYOlZCQGjvz
	ff+4QFa+MuGT4P0wKm4LRrky9GhqGnhljcmf7gXyltgNK6PTClJu0oB0ECpUifKhqdn6as
	qp2YPZuDiw1YbtgDRpjPNATnbwerxHU=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 4A454EC0853;
	Mon, 18 Aug 2025 20:36:22 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 18 Aug 2025 20:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1755563782; x=1755650182; bh=/Ev8ptTbSa6crLCiddX4D
	LFg5va4F4iq3QV7Ft+6OUA=; b=TbAf2y1nLSA68emvru9qoX7jsxaINk0SkVW14
	XXYRW4XwAMQouF15hi4u/qjR6vVKT1AhafGlaXQP3sfDy3snqu1nhPEA76jL9P47
	R8WftMuBu1zAucsRKtY7KnKei9GfzZeb5UsSun9VVy/5boaa5BaN+NhF3I+T6IJs
	UJz3Li+rynIrGeCvOKtSbOZE1g1D2lgd2bEevwCOJC1R+aDBxwI7MJpegldqXXfu
	aUMVTwf+u1OjEZCyhvYrm9Nvnxf9FVzIktweveFtS6L9G9xw3kIjfIe+YNts6jkX
	jTC/t9jeVMz78SFxCXOHWoUWUyjM8WJ7o0yny+F6yPfODaozQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755563782; x=1755650182; bh=/Ev8ptTbSa6crLCiddX4DLFg5va4F4iq3QV
	7Ft+6OUA=; b=D/1JpP9MzZG7xqnLX2v9ZbVJF5232P4YWr8EOImRMJcwC2A6kOr
	R/3gOEZ4mjWCOKsi3OjWQ1a1vlS6mN82LOgtd7vFMJPZPm8H5aqTUUg6rgXpTTBm
	fnFur8SKy++2L/9aV+G1kG/h5nctG3Ykzuufkonv3TuATAE0bOjJ9ptQQagY1P+t
	4h42PTLUXj/ElcJcE+Fz+0vgd3Oq6naM1jaDhumU9CL6MDPSW+AF2q8C0a6FbdUB
	vBCl0wyop0CFngxSAXUJ7dKATqUmjvh1eFo2GIcRD8RBKvx3igCrUCqNO5AV9+Ij
	ndliFfpWnp7T3FjAhDEa+YGqEnImmYGjn+A==
X-ME-Sender: <xms:BcejaBuT5PXL98drRyuxgBN8cyp7L9pZrhNvro7cOv_SevJ4kNyzXA>
    <xme:BcejaP9661sfFKC_CAMRYSePTxGvJQ85kNIzxHhXFm5Cr9JWQFugecQCVXfS-0cd-
    oICFsg_a_G8xdloqs4>
X-ME-Received: <xmr:BcejaD1K12Mn2jjFfiBFJsMsKxxifyU1kNrF1YenT945aRLfsJkgA6GXE0kqcAOQbbCAieLli47xDracgaf6k6SlDwU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheegtdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieegleehjeelfeeifeeiuefhfefgvefgkedtjefhiedvve
    etgfduleejheeifffgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hiohdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvg
    hvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdht
    vggrmhesfhgsrdgtohhmpdhrtghpthhtohepshhhrghkvggvlhdrsghuthhtsehlihhnuh
    igrdguvghvpdhrtghpthhtohepfihquhesshhushgvrdgtohhmpdhrtghpthhtohepfihi
    lhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehmhhhotghkoheskhgvrh
    hnvghlrdhorhhg
X-ME-Proxy: <xmx:BcejaMh3Mg_wY7sWh3tf1hEPkxEXcMOpFrjgN2Dso3v6Y5vphBa1dA>
    <xmx:BcejaLYu5f75W6lkvFuu0wUl4WCYmZzVMrm2r2jwinIfGvsLAEB3gA>
    <xmx:BcejaAWJRNDmat8g6qKhGvBAE4D0TgU71bWzZk9oxvrg77mWO3boYg>
    <xmx:BcejaLF0Ukwqvbo5Dr9Zqk6JqGy3dzyouHACe1PAs0NXYD1nKIQ10g>
    <xmx:BsejaIqyJCeHtecmHl9fjstQOZ9-dVguM5qPDdJ8f7h7kxFVDwRdKk2t>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 20:36:21 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: akpm@linux-foundation.org
Cc: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com,
	shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v3 0/4] introduce uncharged file mapped folios
Date: Mon, 18 Aug 2025 17:36:52 -0700
Message-ID: <cover.1755562487.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18AC4C0002
X-Stat-Signature: 9ipcbh739yxrcn56pr5wqwz1b5ahu6d6
X-Rspam-User: 
X-HE-Tag: 1755563782-534822
X-HE-Meta: U2FsdGVkX18IoQqk4OzhMYRhJJDQqAThM18Vo4C7dtJ20jnPWvL/5QEMb6/aKlp/Gid7xw6M3xHFEF1vE4IcSdDfeZiIHYmJaqt5Biht95LnuYpnXU4cyLhH7OG5VB4B+18p0FwBlytXKak7TM0tRXP4CuCsK9jmPcygObywYbAvPimhOaRNDPNaMIDsMxlmMTW08yS5E0bo+x7TSdnguQMdetAj6eqxs2pdo1qz+JRKx+OR5MVXGvCHIWRSJP64KOEAgUoVHOtf4h6YUHbTyQKrZzLa6HcOWks2PAxNf2GcB145tSwjlJddcPd8XQSjmMQsFAnnkbc9+OTpxqM9ObpdAlsSDx6xp0b5rMMtTCP3qbYEab2PYi+cV2elAvaH953Z4QU1gJbQfEor64Zp41d4WhlQK0h86Ws+BehDww0YIeotWVb3f0ypfQ2cinny9Otr2X9uAjW6zwMGVI2cgLInK3MZ6WJbqVeDUV1BBW/DBJwQSBiBL+Qv+9OtYo5sbZ9UZdqMD9EvopjgVofASBOgDIDxcLKp/Z+d4nUt/G2dSUAjyLDNtasCx9Qi18kaR57YH8YYwOkhewQsJv0HQVLug+Ld18pETNpJvcYDUhQILulJHe5rK54iK5em08MNDYsfL8CmZRGSFDBmbkNxHoEtJgUSLerJuWN6we4GvN5QKpz1+QRi7tq+r8Stvf6kAFlrwGrjJUxnypMZVZoQDdrvGKNZYiPhsE5EYhPTMKKAlB5rp250k0OjDZJNBiLMowB/iaKgr7L1yPYSp7h8U1A5yUKb6QX3WNcgkTsjDRo2PyZqZOTI015u42au8kQqs6OpDNTlHo3ik3H8aHQscKnMZ8ZDa7kHr/ipgRdIpmBbAlcZ5JauYgun+IoHv+nz3+WxrRDpy+BBPD9CR2suObR0TWzZIdr1u0DQBN1xKWz1OY+GrPdKbOdOGpvcG7jIFaDDxxIrryguqsj5qGm
 WZRCtFtL
 BlwrJg+9Ks56+da4A55GyTpOs4m3bA9uWx6Wx/OkwDyZN4k9dbBxHRYj8qBR4rAwAGklHtG1hP//fBRa9Tm7x0z12e5BC+qVxAG2sfVIqRKpb7KP7JN+hkMVw0eC1Pmc05abJj66+fe2JJ66rPM0D5TClHnrtgW+xhZM8C5RjFFGco++4YlA8B+ZCXiRT0tVuZ0JQYPbEL07vMjue9XPS8NCR58pzrxBbiBLq8sJ0+0vvvB9OmJvB4WEiFP9Yxhput8O6WXSMyuhPtflkHI3mtryxrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I would like to revisit Qu's proposal to not charge btrfs extent_buffer
allocations to the user's cgroup.

https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/

I believe it is detrimental to randomly account these global pages to
the cgroup using them, basically at random. A bit more justification
and explanation in the patches themselves.

---
Changelog:
v3:
- use mod_node_page_state since we will never count cgroup stats
- include Shakeel's patch that removes a WARNING triggered by this series
v2:
- switch from filemap_add_folio_nocharge() to AS_UNCHARGED on the
  address_space.
- fix an interrupt safety bug in the vmstat patch.
- fix some foolish build errors for CONFIG_MEMCG=n


Boris Burkov (3):
  mm/filemap: add AS_UNCHARGED
  mm: add vmstat for cgroup uncharged pages
  btrfs: set AS_UNCHARGED on the btree_inode

Shakeel Butt (1):
  memcg: remove warning from folio_lruvec

 fs/btrfs/disk-io.c         |  1 +
 include/linux/memcontrol.h |  5 +----
 include/linux/mmzone.h     |  3 +++
 include/linux/pagemap.h    |  1 +
 mm/filemap.c               | 29 +++++++++++++++++++++++++----
 mm/vmstat.c                |  3 +++
 6 files changed, 34 insertions(+), 8 deletions(-)

-- 
2.50.1


