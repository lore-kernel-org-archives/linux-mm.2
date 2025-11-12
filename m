Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78ADCD13DD
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 16:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52AE8E0011; Wed, 12 Nov 2025 11:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2978E0002; Wed, 12 Nov 2025 11:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C0F8E0011; Wed, 12 Nov 2025 11:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 711538E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:20:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F47D12DE2E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:58 +0000 (UTC)
X-FDA: 84102468996.06.F1BCFA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51931140012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UsmGD2BD;
	spf=pass (imf09.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762964456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MraQBP8Fz8GDLEPLH0WoG09oMfWbX6B77SbiOfhXQE8=;
	b=Os7bFB/pRBkfwuztBvMSbAZvLu+l+cBqxH0kjwGprIObSgmDEYE0QbEuAPy9uRzIDERvt+
	oPKcI3cOdpUmo4uXF2F7K+k5GyNuVb5Fe45fF/w6tI0mHk0BFezEM4EQP9vH9VQ8THrr5X
	ewN/ktSsiHDliaMFEIZ+7EGH13Kavfc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UsmGD2BD;
	spf=pass (imf09.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762964456; a=rsa-sha256;
	cv=none;
	b=ceQkLhWRtEuls//KxkUapx3VdyyfYvvczGMm0jpi1ojNfgjWU16e2Ai2j9UP+IdVjfGbZe
	mHQ30qotmr39XIp5DKwG+mEPIzkUB8i/2xQBtM5zkeip0ogpQHZjydTiMNY3gAUTgUbiKd
	Io48dT13kt5OB5EJfqu53RtQD6lzriU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762964455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MraQBP8Fz8GDLEPLH0WoG09oMfWbX6B77SbiOfhXQE8=;
	b=UsmGD2BDsv5m4dCSMeF/ZQ8ak8qlUINwmkw8K9qLQT45rNzDcWm2p2oSUAXTFAMWm9GDcd
	9q4kiiMneahPyzEFdlqmHK9VJzjVIxv0TFwuCv+lIlKjG7/3cE+Gjc1vibh8TTvQ5oqaiH
	+ml+wgud+cN4Fy2gP/LIIJwgsD+Rba8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-JeiFEAvtMiyRzhoWazdvlQ-1; Wed,
 12 Nov 2025 11:20:51 -0500
X-MC-Unique: JeiFEAvtMiyRzhoWazdvlQ-1
X-Mimecast-MFC-AGG-ID: JeiFEAvtMiyRzhoWazdvlQ_1762964450
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31AD61954B08;
	Wed, 12 Nov 2025 16:20:50 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3CA6D1955F1A;
	Wed, 12 Nov 2025 16:20:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 0/3] tmpfs: zero post-eof ranges on file extension
Date: Wed, 12 Nov 2025 11:25:19 -0500
Message-ID: <20251112162522.412295-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UE2cSRrctFXotwg2adrN076RwoVeWAgi8LwJzNND6b4_1762964450
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 51931140012
X-Stat-Signature: c7jdoqxdeuzc98yddubxkifwmido7kwr
X-Rspam-User: 
X-HE-Tag: 1762964456-473944
X-HE-Meta: U2FsdGVkX1+s1fVGQhyhngAiV1RU8uGxqRwOXDdF7OAfh5Ct0GfeuvuOXPPj2neviZE6VjDROB52ZBG3ivbpFIXIJxCRXsKzF2G3Qx1q/fulLb5WK3ibdjzaYh83A+7CAcTNbUTVM9afQfRtqFqQc804HmDCd1tcztZq1Mv1zc6IRc8q0PrUv2xqKXAzNqHeb/td17Hoa6yki9Dw6v1GBMtmjAkadgX604vrsqTa33ICAq0sFQy5VlEFr3GV86Z++8xP2otNe/s70puxccRm/AbMwtUm2EieXJtRRD6kGozCPXFvKt36xpeKDaTImX+l1001zL0IuxuX1MyCXzgJdz22+LDHsW4C3KlQPln+IuCw7rJ5W/3kfnLsgz2cMPHBSWfEOSJT92HLvIiprDbHIt2/0psnbruCxGyYHKwVBecL4iPGGAzE5AvXdVU7AWBecS2cQUsirD0EiLw+09IxCwFzMnNcp8xtKYrqu1eSNOsCSAWoWY9SCNgrhmCFFCm8OaKbr4/N8rl/5IRh3n9u8+wGPiojT8a9qjyO0ogVC86EbGyzqMNts/eQAOQCcuyHM0KZ9+Aj/mu+i6Um55DKDSQUaDYDMLq6u3Uo4F51ZC2FiRcz6wX0ikUVCxjpFKQRlOgZBuKyuwKoZFQ+1/NXshOtcgQVie0Q9vc7OYi5kUqurjLkDeY24cunNGdYdpK2gI/qdWsm3blXaTT9QKqe2lWT/CAFKBePiqxKg+8U1K14BynWdUynDxzBLOXZEuNequVQhCHr4HCyQmkf/D8T/qjHZztykNjpfX7TMnfSb6AWemr1hRhNEeIBge9j0s9NCPws29151+kUpjZoqMFRmk1ZG2d+XLE+un97WPGRXKUkGyaCzn6I3rZUNLe+2Zs0NT9tbPd+I3+9pLqUt84TvWrcEBYYY9BQTp7PgZ7jD8j/EG2thnXCr3Qp3WECV/htYk63pbOMydbvkls/XgL
 fsSyw4z+
 +FAOA+QkVZ7jVIfZqd3VjXaWboI6S/W82rt6xojx4SrCae8H7NUXdqOVwZ11rYBmQ5cQqbG6QE7aY8lPbNt7RQjbU19DZBNEhQugwkH89GXQ/yZ4RZNIiSFaXahxaY8xZUdY9jUnebB6ZDeWpOOWNw9gv79cOoKALDJKYCXhwzxqxQzIvyIqKvV27cDDwj0NGLkPoYOhiEul3bATVvkUYQQTxCSF5AIXJTt4+0/pU3ByM7ZZ2FwpnXZh4bQRLYYwaip0Rho9QgcqsNzicCxivjLx4Xyf6MazXwUpCp/eof2YYkqf3ezl9/l3xJhI10Qpm2lxOnchghqX5gGbSZwrCPYaUL3USYl2enN/LeaOtmuXs4jaCGC9SV+GMtlcabU1y8ILm5Lg5nKImGY0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

First and foremost, I'm posting this v2 with a bit of a caveat. This had
survived most of my testing until I rebased onto -next and came up with
a bit more involved of an fsx test that concurrently stresses swap
activity. I root caused a couple or so issues that fell out of that
which appeared to be preexisting problems, then ultimately ran into the
folio_next_pos() type issue that exists in for-next (this causes wrong
same_folio values and subsequently wonky behavior).

So with that I need to reset my thinking and revisit that particular
test, but given that I hadn't thus far changed anything in these
patches, I wanted to get a v2 of the core work out on the list. Note
that this is based on -next and I'm testing locally with the
folio_next_pos() changes reverted (including the call added in patch 3).

With that out of the way, I think this addresses the open issues from
the discussion on v1. The main difference in v2 is that rather than just
zero the post-eof portion of the EOF folio, we now zero the full range
between the current and new i_size to accommodate situations where large
folios may split across writeout and swap in.

Patch 1 introduces post-eof zeroing at writeout time so the zeroing call
can skip swap entries. Patch 2 is an incremental cleanup (I found it
easier to split the change this way, but these two patches could be
squashed). Patch 3 introduces the zeroing behavior.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Rework to zero uptodate post-eof folios on writeout and full range
  from EOF on size extension.
- Misc. cleanups: variable renames (pos -> end), code relocation,
  comment cleanups/removal.
- Update commit log to call out POSIX requirement.
v1: https://lore.kernel.org/linux-mm/20250625184930.269727-1-bfoster@redhat.com/

Brian Foster (3):
  tmpfs: zero post-eof uptodate folios on swapout
  tmpfs: combine !uptodate and post-eof zeroing logic at swapout
  tmpfs: zero post-eof ranges on file extension

 mm/shmem.c | 135 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 113 insertions(+), 22 deletions(-)

-- 
2.51.1


