Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F5C2C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5065F6B0098; Wed, 19 Aug 2026 19:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD7C6B009B; Wed, 19 Aug 2026 19:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3B46B009D; Wed, 19 Aug 2026 19:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF136B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05857120688
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:00 +0000 (UTC)
X-FDA: 85119563760.12.2B0C0C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B5DD40003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:09:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNnanCph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787180998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=92sAIl034UVvrjZzhGbIXHo8EB/Zw9a0LG/wt2JppBc=;
	b=E9Gcca45vBj23YWwQLFbiZBenwPRY1tpT8uIDFtIUMLmE/J/9t4aN7/4ksxjbpah5Khi/s
	1BgJm8zDiprTBN7DKljMXpYYOxbHaGrui43yI3EuvmG6ZX/gEazOXHnkyNjMKj3N0Yd/gA
	yHXAIY43iD6fsZTD8RrR40x6eOp10II=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNnanCph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787180998;
	b=SP6e9XSPpavki/7tce5k1XSSthdczdXPziop0VNmjiz0oJEumJI8TLmPEsDE23hXo1+Q9o
	3ehsfXBOTPYM+jhwJBcm05W7fu2xs5/JV4AbEPzxAoM3neuJWf2dk+v32jNJD66+AEiXvw
	XNtjdGlvATNin5ppJFbCKgBZFHJhac8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32D3841901;
	Wed, 19 Aug 2026 23:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356491F000E9;
	Wed, 19 Aug 2026 23:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787180997;
	bh=92sAIl034UVvrjZzhGbIXHo8EB/Zw9a0LG/wt2JppBc=;
	h=From:Subject:Date:To:Cc;
	b=UNnanCphHmtaW87zNtZsjZwFU8YPz6DPmMXoMfNkJmqefcPkklsscYXWBbaJwmTdA
	 1Z4ybYz2uCQK/1fyICi/suG8Wu65HbcrlqqNqx+IRb4GkzHqC8bmO2cmtBAC+sZjLH
	 L3KZfLuSPN3Lldt4rEQC8QN0DEehi6VsZv/+lanVMVAoLVKGJjn52gNvAoNJhkD45o
	 +KmNbPF58TAuL85ZNqFt1v0ba47yRCIngIa7vV3DlxxT8pttVau2KOfFTLas2i9CYf
	 xqoeAPWx3itc9oVCEKZRP7DqPkmw1LAUffUeh4MbOwB4Eun/dFh4xKmBHUBwtpchSJ
	 Y3yFNRcPXyhEQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 00/22] coredump: allow to create sparse coredumps on the
 coredump socket
Date: Thu, 20 Aug 2026 01:09:17 +0200
Message-Id: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WOTQ6CMBCFr2K6toQWpcSV9zAs+jNCRVoyhaoh3
 N0WD+Dym3nvy1tJALQQyOWwEoRog/UuAT8eiO6l64Bak5jwktdlwxh9eRyo9ghmGScaJokBKGu
 YEEYIVbITSdUJ4W7fu/bW/jgs6gF6zq6cUDLVFEqn+3waZZgBiygKnr+9DbPHz74qsmz5MyAyW
 lJtKmgUg+pcm+sA6OBZeOxIu23bF3rg5DzpAAAA
X-Change-ID: 20260811-work-coredump-sparse-18177d77b014
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4846; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/FEG26D+sa/7sriN55UB6u03YL4u4CWR85ubKYD7zIk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me9jEyk5ridXtlf7sdyUsk0Vh8zOBQpZf5je1Smha
 lFjqPazo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIaCgx/Je7qLMi4uN9p6pnC
 21/2lK9fY7bMhIlhz12ZCa+P/r7/Ipzhf9n3Tn7B1qd3XGJj+lcn7n30o2ZRdHTxgoeChrvWP7v
 vwQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: he3k71eqo88ctm6p4mbk8f75o4ag88ns
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B5DD40003
X-HE-Tag: 1787180998-448137
X-HE-Meta: U2FsdGVkX18pEvC3TpJVx7ItxHTvy5ILpKIiRXtMjAhFmXMIxkoxZwc8Xf71KxtQFQHYSneCVfr4b5F2uS8ZRPWhQhAPMAku0w403QLkXe93j//IaoH6fiLGzN2ZZ+iPlKuizdvFWRvPzbnMqeoV1PNLhoBzaHtzvkmS7V1Wt1XPouBZOiP6AuYdSIn140vOIJjGiuo72PaIBMTOXo4RmKQTDZOph5fDhQNS1SpYiC21yxeEuLqYlUDjSNclMSrVVHwgPtiHgMJzdPHgYmD5jZY0Lg0wlvM9k1Di46+/Aq0od4nBqLrVBVCiCGmJAjvco0Ufa56GREeCw73YprjOTNoJNCnRhBNgs5F93u7SotafhGLtrb/8P0sK1A9Ld0M6oyazW09aQIeotFZf3y1k14OyGG0ZmZScmfALVqaxQ7GqvdJdJzS+FZCPnE1u3GvAnYcXw/iUJDBzVB1F07SRaIm++1SdvXtUgDb4NgsDaDHEOk6K1ZOTgYsR8QpNiwls2Wwz5gIGouXA/lhYv6/qHQnsuKbgG61Ww8I7Z8EF9Z22jRgynNH+r8BSK4ChtnyUDi855DMl4Q7YHPQ8cOxhzAiF2Z24AvY8fPT3nMPGWf47QyZS8GEht+YW7asiOngRrrSVAIA6g/ZX6OMb2nG/euSOcMqqnPhhbmDwrFCid9OcRR3e70uzISOU44xNiMuKB5qWMBqfeKqv2yJbyLOlJ+Fc4Zh4/elD1eN2Cpd9/J+aPqEVs3SbbFsJKlGINpyjOr5sYt3KcNVPuDcPZyD5RQqboyyLc/NYXSG9Bl20ab1nOlSLutX27hE7ByB1IfkuMEKyxDvj4XUn0lYbzuJ7inkUPdTnyQTTEK0fD7qVuZJjxNX/T8sjyJo406I2Yu9CTy12OpTmt8aIV2Sq2klbac0A438hO7gUjilAM5HXoVEcME9YbDDqJ+D45X54ZgZKZW+hAGaRvS/Bm3G0uMq
 cEH8cTAu
 Pkrn8O+0hxzPQGgIspcI0peWKT8uQa8WyEq6Y+fJtcsZrhSkcZeRefray7B062OilyMEBZ18jsQ6KZY9Qd8OdkPwcz1/ffwneruV+/+szTsVCeePXcYbvKPwBEEizRLt0AcywSeTU1u1w6JHnpOHq6zT509v+PB4J6m+hjv4/8u14nA9/uF5VTS6aJm7suDmr++iKaGxbyj9TAN9ntc9tm9R2Ui8LpXbyhWBbqawOVct1bj5fgSZgmp2g1mYCXLeLyZh6XRI2V5ZuLWNEWxMrtU+DX4FgxlkzdLXAX72FvyVNNkt1Wg4D4d3HcUUc/UEgMUu4C7u0ifWGSm5+MXUCDcHYLjZE4afaLmGSvS1mTzu3jpWmoGTud9oHvEz36PjURqJwm9aUCAw5emw=
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

A server that raises COREDUMP_RECORDS in coredump_ack->mask doesn't get
the coredump as a plain byte stream but as a sequence of records. Each
one a struct coredump_record_header followed by what it describes. A
data record carries its bytes. If a server also raises COREDUMP_SPARSE,
zero records are sent for unpopulated mappings. They only indicate how
many zero bytes need to be written and do not include data. Reassembling
the records gives back the same coredump. A debugger and everything else
still see an ordinary core file and nothing outside the coredump server
has to learn anything.

Numbers from the selftests, on a kernel built from this series:

- a process with 128 threads: 1424153 bytes on the socket for a
  coredump of 1075150848 bytes
- a 256MB mapping with the first and last page touched: 188793 bytes on
  the socket for a coredump of 268890112 bytes
- the same 256MB mapping with COREDUMP_RECORDS alone: 271009312 bytes on
  the socket, so the record overhead itself is under one percent

The first one is the interesting case. Almost all of it is thread stacks.
All stacks are 8MB reservations that are nearly all holes. And they are
holes in the middle of the dump rather than at the end.

Link: https://lore.kernel.org/all/20260731171336.2255844-1-jalalonde@meta.com [1]

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Use standard naming aligning with other subsystems.
- Add a termination record to make this really clean.
- Link to v1: https://patch.msgid.link/20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org

---
Christian Brauner (22):
      powerpc/spufs: don't dump more than the note supports
      coredump: refuse negative skips
      coredump: set the minimum send buffer size
      selftests/coredump: discard the right amount after the coredump request
      selftests/coredump: collapse the expected request check into the helper
      selftests/coredump: add a separate helper header
      coredump: pin the protocol struct sizes
      coredump: move the negotiated mask into struct coredump_params
      coredump: deduplicate the to_skip flush
      coredump: make the dump helper return bool
      coredump: always chunk writes
      coredump: clean up coredump state handling
      coredump: add COREDUMP_RECORDS to the coredump socket protocol
      coredump: add COREDUMP_SPARSE to the coredump socket protocol
      tools: sync coredump.h header
      coredump: send the coredump in records if requested
      coredump: describe the holes when COREDUMP_SPARSE is negotiated
      selftests/coredump: test COREDUMP_RECORDS and COREDUMP_SPARSE
      selftests/coredump: hand the record stream to a sink
      selftests/coredump: put a hole in the middle of a sparse mapping
      selftests/coredump: simulate a blob store
      selftests/coredump: show how to inspect the task to decide how the coredump should be sent

 arch/powerpc/platforms/cell/spufs/file.c           |   18 +-
 fs/binfmt_elf.c                                    |   12 +-
 fs/binfmt_elf_fdpic.c                              |   12 +-
 fs/coredump.c                                      |  325 ++++--
 include/linux/binfmts.h                            |    3 +-
 include/linux/coredump.h                           |   33 +-
 include/uapi/linux/coredump.h                      |   79 +-
 tools/include/uapi/linux/coredump.h                |   79 +-
 .../coredump/coredump_socket_protocol_test.c       |  783 ++++++++++++-
 tools/testing/selftests/coredump/coredump_test.h   |   31 +-
 .../selftests/coredump/coredump_test_helpers.c     | 1171 +++++++++++++++++++-
 .../selftests/coredump/coredump_test_helpers.h     |   53 +
 12 files changed, 2399 insertions(+), 200 deletions(-)
---
base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
change-id: 20260811-work-coredump-sparse-18177d77b014


