Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF80CFC283
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994926B0092; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945A56B0095; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834476B0093; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A21D6B008A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31F4989A02
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:55 +0000 (UTC)
X-FDA: 84134981910.13.28B13B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6937680002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJpQhaCl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763738573; a=rsa-sha256;
	cv=none;
	b=Aje/KCe42XYfKSQqNfEtyEUjcAYBOmP558XLdLTZvq3RVOXEkQzM95OrPjW9qE9t+usjA7
	hdYDTAsSYzLiWX/IMKMk2rH3Rw4DE9s/9nh69I4Kj3pGq1Vx4XpRY7l5gUEcCTttymJ03b
	hV2GhYN0i1P7is8+4KoG4QxEodLJIrA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJpQhaCl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763738573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NySiid1ttSH3vVSHl9J41RWUqUN5VcGrJvuHMEWTQV8=;
	b=7wGvNUMPmtUsc+oJlyH4nL/swnqqO5lhQT8B5U+3nQmUiSuJRR4qEZZ3HuQBCtLRqL0vv9
	ij1SdmXjIBZv5l/27qkxF5QuSrS9ar8AXdru6D903tMHnGafPpD0/CetZ1KgCQa1NrlE2Y
	f+DfcSWafxUX4/78d5NHOAQuMYkw01M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763738572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NySiid1ttSH3vVSHl9J41RWUqUN5VcGrJvuHMEWTQV8=;
	b=eJpQhaClyfrhRFdVztNihBZ7U9Gk7Sdl83tC4S0NGBkmealeqe8Cg8DpXb4RHmt6q85nCH
	qRaOH64wg6U7J3ZuEUylyxTheP06LBWBN8e2N3hcFXUk+KKJBGoT5/Tm/XawdwSGRhZzUY
	t+vgTD0Khytrv9l6DHmHUKtUIC3BH7o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-6yUN2uP4M5i1MbXRy5jFdw-1; Fri,
 21 Nov 2025 10:22:49 -0500
X-MC-Unique: 6yUN2uP4M5i1MbXRy5jFdw-1
X-Mimecast-MFC-AGG-ID: 6yUN2uP4M5i1MbXRy5jFdw_1763738568
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C6AF19560AD;
	Fri, 21 Nov 2025 15:22:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00866180049F;
	Fri, 21 Nov 2025 15:22:46 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
Date: Fri, 21 Nov 2025 10:22:43 -0500
Message-ID: <20251121152246.1023918-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pWBhoZMx2x2nI3suCSubBO7PlTrmWvJvTieiIy7ppag_1763738568
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6937680002
X-Stat-Signature: rgs3axmo6bwpz81cfm7eh9os57s1f6rm
X-HE-Tag: 1763738573-237821
X-HE-Meta: U2FsdGVkX1/9f5ZtTsYhVNrAtJqhxWNC6jFdr6oWi4jfrYfO36eneYEASInHXMGHljFqH1UsZJ7MWz9w3qEJrxTeE/UoJJ3OpNNcEQvfAyrizGUJ3tpOkAh4fMW7VVD+kkrdTm+Um38hJyp8Szv2wxLHMv0Ve0mCZTICL3ku1hIj8zEQLkWroM50+DOgeMBEy/X6ZL+Tc3Ux8jZwcW1Eh1oK9bJL9iwxahdn60zaIjo/Ak/xiqR1h6OGrW2LkTCxxZkRD/55048B7B/8ySVm4sQeZnf4MVq9uxmopXda89lIm33aoXZQoJ4DFiiBvJsaQmnEO8tndDA29qzu7BjDvnonx+GYvjztMVwtUFQZ39VzzuqI5HhecBWHh3Z+OgUTkWxy9b9P2/j6o5HoowTzKPdWAgBrK5pqoop5qr6fNpSS9gL6RGdYAWftpvV+QU+9iMMz2n9pR/CBwALdSYtgr5+5Pz2Emlfj00OZK5tLgHUhgt4fz4HbdYTcJj/Z5dOvuj5i7ivp2GEXcCCCwxqpjyVbaFE2hopGKet512OxXmm2oFoyvK11jji6rQj7g6yPmGtxgxIPJQyx9mpqvNueQUvgNswIk31rp8o4LrB/d1t3mit6BBzv9o97BMEUMrcecBDhg4xVmJtFxQoLTs7n2rIGsUQG8qDp4p0V1Qf1V7g162UhHL9qeV9/03vwkb/A5KTQA2GupxQBasYk9Dt11Ixk9n3lOY7HL3p03UH8Gk3oDWRyJ8cMrU5LlIlthdhy6ETN17K+qFB3iLZ5cqSxai4IQ9XKpaJJ8mnuYpAaxFqt0aKDW07uiWh1UsvPTJA+xb7JxTJho2vAmq7WzWeS+GSvUZ8R6J/uSZI3lY5WEjC157XCbdTirpCQM9qYcGOOsewZW9dqU8xxSb/SCglB9tQ/ya4c2QYpiVgkVoLeX8dh0F6xbnXvKN7jG9+qVqGd64/qzaTohSRLj1Iv9jF
 iHviQ9k5
 O3jok2gOBkJGiE2VlG2xAPfxhh72kQmDMhktpD+CuShcNfvgH2QS/XIg0HbdPGpCtKdbKoLaVubi7DndIZbuS/wQ2TBCQLS92SfVdEZ2F1NDZXRiYiHd2nDA06Sl+CUFmPuzp4Gm/Lvp8eeWJC7DBMXOWu3m1cEdQThNgpi6N76nUDD/is/BOwVZJv5N5oM8b2PFMqbi4iXlypiv9Ep81WxWFDsm23Dza5URCIc+vrmIRm5Ixe9MyP6m/or2MJAvepw2hXkefvs0nRNI8/oiOoKb7ngjcm5UIPeJUWI77/+q4ayvv8e5xA6jN5VsdRKG4k+nwVyAnVcFcgXe1ddi1sVL/hZGk6ANAGbloROTbTrxHX+YEZyy0kUtDNQo9TcIruOM1LzYmi/cFi14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Apologies for the quicker than expected respin here, but during
discussion with Baolin on v2 it became apparent that I factored the
first two patches in an unnecessarily confusing way, and I wanted to get
that resolved more quickly. Otherwise there are a few smaller changes
here that I think are incremental improvements.

Baolin, I left off the R-b tag from v2 just out of caution and how I
reworked the first two patches. The end result is mostly similar, but
I'd appreciate a quick look before adding that back. Otherwise most of
the functionality here should be the same as v2.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Reorder changes in patches 1-2 to factor out existing logic first.
- Use local scope variable in shmem_writeout() fallocend block.
- Tweak combined zeroing logic in shmem_writeout().
- Clean up commit logs.
v2: https://lore.kernel.org/linux-mm/20251112162522.412295-1-bfoster@redhat.com/
- Rework to zero uptodate post-eof folios on writeout and full range
  from EOF on size extension.
- Misc. cleanups: variable renames (pos -> end), code relocation,
  comment cleanups/removal.
- Update commit log to call out POSIX requirement.
v1: https://lore.kernel.org/linux-mm/20250625184930.269727-1-bfoster@redhat.com/

Brian Foster (3):
  tmpfs: factor out folio zeroing logic at writeout time
  tmpfs: zero post-eof folio ranges on swapout
  tmpfs: zero post-eof ranges on file extension

 mm/shmem.c | 135 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 114 insertions(+), 21 deletions(-)

-- 
2.51.1


