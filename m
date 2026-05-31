Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F067DCD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC176B0101; Sun, 31 May 2026 03:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C6A6B0102; Sun, 31 May 2026 03:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72686B0103; Sun, 31 May 2026 03:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2A526B0101
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:02:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF0721C17B2
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:02:56 +0000 (UTC)
X-FDA: 84826822752.23.6B8E65C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F533100011
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:02:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hm0xTCxv;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780210975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TNo/DBsbd7T6Wd5boSxyQ/8mBLAohX5xkpcukm+9f/c=;
	b=rLw4rxDwaTRKxKdyRNjOnR0fooX2C0DjoN98C/m/czYwh0KFF8rqJd9T6H/xyict0DMxAf
	CTeJ1lLWcZ48YYwsW2LF+qS7/kOlrlz9pB0z2/5zywh0AnfosUltHvq9nXkCK2hwb2spao
	BzfJMH2t2/UVPjdik9jFqu+cQY6ANQo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hm0xTCxv;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780210975; a=rsa-sha256;
	cv=none;
	b=UzjoG020+bl7s6AZIh1NV5dR3UThedd4DuMboQptuAftV3G7XeM1LhcU8d3oQu+ardH80X
	jBOK9hzT7RTVNLvOi3fILXq6DxdCvkXYHidgp4h0KgTsjoi8JaiO5uylO53XuaHjxtcVYC
	mfWZZgkU4T9boYkm1DkPB3uO8YqJjTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC77F60220;
	Sun, 31 May 2026 07:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EBD1F00893;
	Sun, 31 May 2026 07:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780210974;
	bh=TNo/DBsbd7T6Wd5boSxyQ/8mBLAohX5xkpcukm+9f/c=;
	h=From:Subject:Date:To:Cc;
	b=hm0xTCxvJyetF9xTE6wmCMBb7QoTP5L4S3MNH/MGJVf+DtAYubOsFNBXIjHmR1xzM
	 6iuxJiw6xM/PwdVP/pVxgBNeBoED0n8vwjQop1bfxMBk6LO0703JCCQ2CPvmDgpzOo
	 n9OyQA/l1Hc4xLVSCLRfJyyfCwREH6DnIokqsj0cSO6Pfxu8IayyAIkpWRVIPRzIge
	 tyKGjpkax60BmlVguhXWzzhogPI/KerEm3SGmbasVbeUijJB/hYHAMiGdOV8bdFbav
	 ivVA4kFg/NfpeqdqwYAq6y2xBpEPQEVWNaIsokf+Ly0STz5YTWHkD2V5SvUzNR1FC/
	 ZbIWMU2X1hLOg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/4] tty: replace __get_free_pages() with kmalloc()
Date: Sun, 31 May 2026 10:02:46 +0300
Message-Id: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABbdG2oC/2WOyw6CMBBFf8V07RhaeYgr/8Ow6GMKVVPMtDQSw
 r9LcenyTM7cexcWkBwGdj0sjDC54Ea/gTgemB6k7xGc2ZiJQtRFJS6gSohxhkbX2Ba25Iaf2Sa
 /Ca377EH37sdhUg/UMX9nQ8mAoEh6PeSTIZeQAqjJWqQsDC7EkeZ9SuI56K81cSigNbK1jURdW
 XF7Inl8nUbqWbeu6xeHcVnp0AAAAA==
X-Change-ID: 20260528-b4-tty-7c6e90f41d13
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: bhbpz1c58fo33emzwo1ah7enago35run
X-Rspamd-Queue-Id: 4F533100011
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780210975-897633
X-HE-Meta: U2FsdGVkX1+r0BzxLvYUtDLnbPe1kpdv6XRqHJ0Dem1XYqZJrXrHQyVTsnRo4eqpLhyKLHA5xBRTeIXxi8EyqhigJaFw8FHXk9TCYRp+CShleqrRZBSeZ2C0AXJs55CZ/byBy5sae/u7kPrFxAjqjjGx9Ducpnd8TkkvDoZmur9BHAaDQ9XLY3f90ekVdWy62jY1U8kc+JqjuvDoOzYK7tJzpQkhrO+kvZdkASN1ctvNYnee4F9OYmsiBF9yerSf5u04zqpFtFE/8sZAQ8BFhf1dNDKi8CcgL6QIyy+XBsQov4Qf8vdrGvPGrJj9fHOaDpe3mUthsma118VO7alTwLwTjxY4FbS/20+QiaBJoSBXkT40h9iOeluJBldWPlQHvwY6XJJdLZ5rifaiQEUYYgyjW4/Ci1zCjEkJSAYpIikgQlzAR5OvB1fwgthANF53DYY3ZKSROfoQEGmYS/QCY6A37/OmSgDswP7y8BjOeGCkaBb2H+ZiFvj2RDKGvChmed/kG0ZDzw0wcO/xah59QxeB4gpY2+61XH+JMogp/Stigb0GtviPANNn9iYhBihXHVxYzzHcWvQQikz97IGvUtAGoqU98ZNsUV173+87Nw4s0a4nu+4i14/596ZXKN+RHTY7+CeHKbszOvw6Tza8a83mDHsiUPJCjtee535G9xESI+ZUktQsVwYD5a1IIUN+0RHBk2q1hrGfbF/V9cietp+FUqFYU0BoeakFf6qJQ/82fOKvPAAJVBJa/2IJFScpn6e4DAalm2xH958XdTRAjKRHdJmpBy66FqzKClT8AOsOj7Nh0dYGJF4CBDIbUz2EJ8Hj9RFpuj+N3KedEfdFUVLGh9uHVKhhXMJwEIQ7dmkT0UmjF4CADSQCMeQ1nVhj7FvL5Ky9BHwTHpcL8v+jEnGmpYtEuk8NtuikhHHW5S8KNl7/PJPxr8mKZPdX1NdM1MNSrDIcjirWsux3OPm
 iEUueYPi
 ueMTfWzYs+Zt7CtDye3DK0vLCKlP89z2nwbGmyEIw4QXKK5we+1DN0nVQNFRNWJXriUjR7VQjsekNLtVJDoSfguDLFQ5VaAVEi3wIOMwHGURnGdw0MTuc46VUtM6pzfVRB4TZB1Op4edC4BOTYgrtXBy60wMJjHfiEEtWW3B5iZGL2NjnyrJVWXHd+nV8CIt3cKEw0bCvY18bwuAKdRrGhLMcxew/AWCSJuorA8ww11obhNaO5n9Fb4lTCK1OkqLTBIRiHvqLXDjXqOZOSm/lIjq1Ojkr1auKM2lFspfaeND87n5Hn0ilChbWqsT5sgE2P0Z1CzTqBo1b9YxPpdvos3caOLkVBkpN0xYm0sZOMl0NY26kkvZmY/2k/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
v2 changes:
* fix placement of include <linux/slab.h> in men_z135_uart

v1: https://patch.msgid.link/20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org

---
Mike Rapoport (Microsoft) (4):
      serial: pch: replace __get_free_page() with kmalloc()
      tty: amiserial: replace get_zeroed_page() with kzalloc()
      tty: serial: men_z135_uart: replace __get_free_page() with kmalloc()
      vc_screen: replace __get_free_pages() with kmalloc()

 drivers/tty/amiserial.c            | 14 +++++++-------
 drivers/tty/serial/men_z135_uart.c |  7 ++++---
 drivers/tty/serial/pch_uart.c      |  6 +++---
 drivers/tty/vt/vc_screen.c         |  6 ++----
 4 files changed, 16 insertions(+), 17 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260528-b4-tty-7c6e90f41d13

Best regards,
--  
Sincerely yours,
Mike.


