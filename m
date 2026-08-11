Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE08C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4256B6B0088; Tue, 11 Aug 2026 11:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD106B0092; Tue, 11 Aug 2026 11:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316926B0093; Tue, 11 Aug 2026 11:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9F616B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:27:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5758CA284A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:36 +0000 (UTC)
X-FDA: 85089368112.16.F6CE73A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 96DF21A0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqvJN4ji;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HXGN+7DyTtsXASE0Xx28luC/PppdvwQ35E4XsIfnroc=;
	b=QcNdx1YpolmZ4qF2qbMACsICeTwKSMhtVtRnMVaMFO97iXf7se18/oXi+rv9KLAhxI5Xle
	6Ycr4mZKsK5kFFGbzZ5yl/LB6b2voXYq++s+zXU6WmIw/1/ww+QJBq2hOIpFyio+zr5zwf
	cznCYBUuKWSOU4v3P9uLrgN76Lg1fkU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqvJN4ji;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462054;
	b=mf0je111mURtkFqSkugjE/h8WIEAx89fArMF0oslOQ9xlNTaTiOVxtNSs28NvAv9ulzALK
	VlYffGT44WGuJPj0kfqArUbKUbncPMXQXo9bID89FIJ1oqPvUSuR+I53Yv28whFujCr0Cw
	g4ztQ8dPaVUMqJLh5y0eWxCRfSEgQFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEA37600AD;
	Tue, 11 Aug 2026 15:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A0A1F00A3A;
	Tue, 11 Aug 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462053;
	bh=HXGN+7DyTtsXASE0Xx28luC/PppdvwQ35E4XsIfnroc=;
	h=From:Subject:Date:To:Cc;
	b=BqvJN4ji64/oOUX2EnFxNXoqg04JhEpnBQGw7xNGN/zaJ6XI7PzMBraz1NrQt4yei
	 Wqs4cFR6qerGTXMd5Sl3NjxJP6DVtKt3L2drI5dNGT6sKmockwGav3TsqzD5zfG0i1
	 pOuJTrklYtOlicbTYnaTrPnILV97BUuQQ81UsCGfHY6hf5VIAauNQxUWaH9NhlbVdy
	 O1whZE0cOKO5nqaUPYTim1r2guugrjHj8iXkC+zJoJ+gZ6pfI0ucHsdZgppDz22tTp
	 eymEsMKyBTlRFLlEKN9QhrZjxxIjhHyKzfcr8SqbRRkHTXbn9yhlqmExwQaHMGe4G5
	 9MYqnDaRuXoSg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/11] coredump: allow to create sparse coredumps on the
 coredump socket
Date: Tue, 11 Aug 2026 17:27:21 +0200
Message-Id: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMywrCMBBFf6XM2kCmSFP8FXGRx2ijNAkzrQql/
 95El+dyz9lAiCMJXLoNmN5RYk4V8NSBn2x6kIqhMvS6H/SIqD6ZX8pnprDORUmxLKRwRGOCMU7
 jGapamO7x+8teb3+W1T3JL63VHs5WzbFNfmrTbGUhhn0/AKCEPsaRAAAA
X-Change-ID: 20260811-work-coredump-sparse-18177d77b014
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3673; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1qHewHSXRcdYAaTnKKH0DpOw8nUTqXZkj+4XBvqR5C4=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGp7P2CiEcw1DU7Ai+OgN8p+lfwbbW0AppufWk6kpoYW9p9mB
 4h1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmp7P2AACgkQkcYbwGV43KIvmAEA2Wze
 c/m0aNRh0crwsw6YxvxsZTHxQzCmK/dONsndyYwBALLT9S+a/xY66rac/QOOGQOPaYYQImDpZ45
 gTngmFv4P
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: d9xjmtwhm3eiidhxex4rkbfwcqh49qdx
X-Rspamd-Queue-Id: 96DF21A0006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786462054-741662
X-HE-Meta: U2FsdGVkX198A0cfcWNlfldsI2WoUZFSaWzAULPAt/OKvRb4sqb/NWr5JESLLZkIniedKDJv/XzAntvmzfP0+4iTv/R+8MyiXlSYmwQCFWoLfw0HTuHA+PTa0v9hS0gFopGIxBvs4TH1EC+6mZF8JDEWELXzHQKBKVKeJKDZymMBm/65LNJ3wDaPRv+ALox4aeTmPbXkY++vtStP1T0wBCVapwI/t8dUlv79eT2TwPlmmC4+Xt2UT1qgrt2mcLIGdSbQyui3uKjrw0N1I4zQiCDz0tUdimhFzIHsewMSfNImXB1dVPTWcXmfhG9GCDjGMMnOnpmOMiCennUgK/dLdaY2aYmEtmD9Ytl3RPjxeytrB5beoTNMDrO2xnuSH4uSbBuXYBaXDHpObiozs10hX4RL6lb9RbYv1J6KfIGqVmFcswjU3tWGchhAhnEGek+MTXDgy7cavwBOLV/nzFfpbcjH13/7oBFs6Q0BeFtKpy5d7hf1QxEQ76bxGRR5G56achyhzjPC5Y4k1dvM6D4FoEi3T9Cu/nMib/fC4XrBGUXETL1EqdcRLfhCmKPZCXv11zh0RIITulW3xHQFtXsR9fdgds1B4Xa5owZIzQJ+NoKKspYvo9YlbJj0WHpjvde3+t9+6MQ9gKQ4VETguMOJIkrOVm61D16HFEB2JLIoSyaXrGlN752yfv2QGYTklsb5fzYudGe5LL6izAXN1Riw/+e9erkHzZf7Ri7GZjYD92DFe1HuMn4iH1Om4KjBlPjlUU0ngZDNqwswVI5c9Sexdx5iIGUo+UUw5J2+0tbEH//j0cuISDaTxtvO4ZlZPGz8yGOiffeEo1T1VcAvb1+S1mcpHK2dxCFWg+YxVcKbAVhiLWMBaXDUZjTE4Ed0kQI/EmNhetvl6/ovZi08EWvufiDXQecC2FiuxlFUWschGMzkryrnhGIKT9+KnXu1SmlAldlLgaU3CW2oipoNizw
 u6ju00FL
 OJN3mMFomsYCjdUnkz3Oim2LrX0FiZQ5moaL/3FW5+7SgHLFDV016tNcqJGWjhsTGGFNkXryDlpISGvFt8/XbSgJ8V7iQ3rCBJca0EuxEwONHwL32SCVxA+XTh2W050IFJ18lLzBUdxsuo+8XgU7YlYC0pSCJniYnEs9xN2doSFbot4WgS81bZ/TC0h+I87O3hZz68dVS3KAb7+YAt5Dv0GfurhSgr7NFylLvZLsc+4Gb20nutgDVTZiCEQrIj4A2nuSLVUO37rD2O4OdaRHQCkdD9j3PkIfcdEOPl/HFslbqa5L+/LH1nwe3UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coredump generated via the coredump socket ends up transferring
zeroed data when a mapping contains holes. For a large process that
maps a bunch of data that's wasting a ton of work.

Jacob ran into this and Josef has bitched^wcomplained about this to me
before. I dislike the coredump_filter bit solution in [1] which stops
each PT_LOAD at the last populated page.

The problem is real though. I don't think coredump_filter is where we
need to solve this. That mask says which kinds of memory to include and
it propagates across fork and exec, whereas what is being selected here
is an encoding mechanism.

I also think that the usermodehelper - may it swiftly die - isn't really
salvagable for this and it's not the future anyway. The coredump socket
already has a handshake for stuff like this.

I always had an idea how this would look like but punted on it back
then. So here it is.

A server that raises COREDUMP_HEADER in coredump_ack->mask doesn't get
the coredump as a plain byte stream but as a sequence of frames. Each
one a struct coredump_frame_header followed by what it describes. A data
frame carries its bytes. If a server also raises COREDUMP_SPARSE, zero
frames are sent for unpopulated mappings. They only indicate how many
zero bytes need to be written and to not include data. Reassembling the
frames gives back the same coredump. A debugger and everything else
still see an ordinary core file and nothing outside the coredump server
has to learn anything.

Numbers from the selftest in patch 11, on a kernel built from this
series:

- a process with 128 threads: 1740014 bytes on the socket for a
  coredump of 1075150848 bytes
- a 256MB mapping with one page touched: 170542 bytes on the socket for
  a coredump of 268890112 bytes
- the same 256MB mapping with COREDUMP_HEADER alone: 270993024 bytes on
  the socket, so the framing overhead itself is under one percent

The first one is the interesting case. Almost all of it is thread stacks.
All stacks are 8MB reservations that are nearly all holes. And they are
holes in the middle of the dump rather than at the end.

Link: https://lore.kernel.org/all/20260731171336.2255844-1-jalalonde@meta.com [1]

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (11):
      selftests/coredump: discard the right amount after the coredump request
      selftests/coredump: collapse the expected request check into the helper
      coredump: pin the protocol struct sizes
      coredump: move the negotiated mask into struct coredump_params
      coredump: deduplicate the to_skip flush
      coredump: add COREDUMP_HEADER to the coredump socket protocol
      coredump: add COREDUMP_SPARSE to the coredump socket protocol
      tools: sync coredump.h header
      coredump: frame the coredump when COREDUMP_HEADER is negotiated
      coredump: describe the holes when COREDUMP_SPARSE is negotiated
      selftests/coredump: test COREDUMP_HEADER and COREDUMP_SPARSE

 fs/coredump.c                                      | 178 +++++++--
 include/linux/coredump.h                           |   7 +
 include/uapi/linux/coredump.h                      |  65 +++-
 tools/include/uapi/linux/coredump.h                |  65 +++-
 .../coredump/coredump_socket_protocol_test.c       | 415 +++++++++++++++++++--
 tools/testing/selftests/coredump/coredump_test.h   |   9 +-
 .../selftests/coredump/coredump_test_helpers.c     | 200 +++++++++-
 7 files changed, 849 insertions(+), 90 deletions(-)
---
base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
change-id: 20260811-work-coredump-sparse-18177d77b014


