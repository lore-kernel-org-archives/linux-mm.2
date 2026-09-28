Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC3BC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3156B0096; Mon, 28 Sep 2026 04:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893CA6B0098; Mon, 28 Sep 2026 04:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0FD6B0099; Mon, 28 Sep 2026 04:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 619886B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:05:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE2481A012B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:05:22 +0000 (UTC)
X-FDA: 85262436084.14.66B4C5E
Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3FC4CC0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:05:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=UqOERltV;
	spf=pass (imf28.hostedemail.com: domain of clkernel@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=clkernel@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790582721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3M8BPv/p9dM+qPIYdIkmizLgsmL/s/qhobeuo3NeTSM=;
	b=7I6d+IFhSx2PfJRm9sKoFh+T7OnjlxnyaL1NvbYHrLP6n0eYFqgxwVpcghVmQg6C6/+OiQ
	Hh8wy6PvW89e6h13YU3w2Or5WgERVFHzqND7CvxuJsLkYTlgJF5E8OVv8ql4A807/oayWB
	4RDDJkgN4DxHx6wnBAMllKA/oVfFPW4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=UqOERltV;
	spf=pass (imf28.hostedemail.com: domain of clkernel@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=clkernel@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790582721;
	b=fneEqX28N+8rk+GhxoWU763QQ3BbeGthxuutzyVyS3ConEmMTs0xH/DAUr+s5VQLyu1JfB
	O3ycLRK5GKp5pbWwTA1Tf7hskeY+pyle8o/mdYP4pC2Yl0FFzj3UlrqjOE2v6gvgJXpoks
	M0WHljIayXgImeWIAOFHbMpgRrevyfk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1790582718; x=1790841918;
	bh=3M8BPv/p9dM+qPIYdIkmizLgsmL/s/qhobeuo3NeTSM=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=UqOERltVcMd2g1ZVy25hZwT9exWp+EqFJOwoVf8fXUDabC6AVVUezsZmAIgXd0Ar+
	 Pw9gThUIp7pFh3SOo653tHotzP63hXOKSjjsPztIM4s+qPbdIfm9S8eD0axEfeA1fa
	 0JvmxjMX5LFyH6W/nYvtqNgNN7LiIBOjO0Ft12U5prsknszc2gQsjRsQt3RsDwkPwq
	 M0uYeRPbuydEls4MhAlU/bUgzgpfyRLTLP0/Cvi4+a+Oz1rS3BsvFqIuKDS6PUzq8g
	 M4G/PCk60zDyEU3iRxx3kHCcYMqhUBn3MLnrwcZ94dIE+7DajPMR8uVQGOZ1b+S9LD
	 45dka1h3ekHqg==
Date: Mon, 28 Sep 2026 08:05:13 +0000
To: linux-mm@kvack.org
From: clkernel@pm.me
Cc: axboe@kernel.dk
Subject: [PATCH] mm/filemap: queue non-exclusive folio waiters ahead of exclusive
Message-ID: <67a11eea-e0a3-49c3-a823-b5a488625293@pm.me>
Feedback-ID: 224698563:user:proton
X-Pm-Message-ID: b9d07f5cbf723acdc678724508bfefae6e0ef896
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FC4CC0007
X-Rspam-User: 
X-Stat-Signature: 43dh1s9bgdys7wi8cdhozetq43nz4wam
X-HE-Tag: 1790582721-710634
X-HE-Meta: U2FsdGVkX18rT/to3tBpiKl1cQkcza8DWGurLGAbBhsDmRX5AWW+cDha9BFlFz3ayd9XHuyoP/j5BjvcbcenEF46eYB4hm5k/KqDWnl8GP+4jC5+p9tgwJIRH5NMX2Ft7kDtiiAvH2SjpcJZ58wZyKzRNeZA82KqTdQuPwJ9HuiK+4e8EOFjkOZv3noNwW0wDcLvW74B3RaDaPPiEUxru9X2eRVX3rXnqp0Ps9Wa4Xpm8SP16rtCyzeoTcPsnD75eaYev/ts69LcVif/96txoqFgIVaBN3JN6tE/z08Dhn12wLUyztkMK93LG7R0T66vgSvfrB6Q1bYhNkkLlBTz18GyCktRvew/LGFbWvdz+19mT/ca64TtkeOIEq+xGLCFLSuTAyYBaAJGO0ExH8Co5mdM0hm1cvCUhVIVfaqmYU68H/oBcNTCsHvQ3xsl9bbXcUDWbNUFa9WA8Qm41G9Hc6NPfa24hbq8B4fQVbLYRYoySRS92m5OQXcrt2Z+KbcN5Jp+kanw/uT4ENKMu/tcPRZFaV2PpXZhJuO6XtQrQF01y/FLuRGHeElv1BBWHkRQgtaxC4/zJ2SzXU3/zURqfAoiS1yIeIDRW/BGOBFXWXo2QzeDjlLxYq/TdyRkFekIbP3XMqP55ziHHC8meVCa3zr0OpCfXbGWmk2exYe7mjJxo3eaqy5Z8BLBIfERRiX1GM4NLF1ZTyvuvNq/X1rJsWsucHr8/oyLxyJaNEVvprN/gA+IQ1HgYWOc7kcbChy78u70F3KMFSCmEoDeAOY2p5Y8YzdW5r9kx7yNxXk8P5BujAvoTVk3WTEoFU4osClO/jpXdi8PPCimmNxLPL2ilHzZG237l0eO5WwbLXutm1tjEKSJqo9nN/pfUM2fgCUDKZWKf6R4w3ss+o3bfyEZ+BBtoAFFVipVck3vyg7M8L9GhCc35c+7RDEFvKATWlh5lse64H8GPXeyJPZMUBc
 0fiWTix7
 p4t87gg3zliEq7WLd0VcSlrXqS+pxdYJgwlkuyM20OQ5Qu6eT0vL+GtqgLpFI607ljxUJNjcszRMGhv32KQ2Ckg+khR1i1eccgjvfwvtNpN8alS4X913Kxe0JzJVRCQMqBus5g+0mTEkzhWrSUd9IHsgrBqKTNc/01bvXL7dsn2h0vawfmgdCxtqWZFal10qdolp6GI+HGJtAEs6EPDaVmS6yKP9k1v8xeaJddq64QhVHMOprlrsXfh7I/IIHp3PIqEBz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A folio waiter queued behind an exclusive folio_lock() waiter on the=20
same folio is skipped by folio_wake_bit()'s nr_exclusive=3D1 walk, so a=20
shared/DROP sleeper (folio_put_wait_locked from do_read_cache_folio)=20
never receives WQ_FLAG_WOKEN even though its wake ran: readers hang=20
D-state in folio_wait_bit_common, fresh reads of the same page answer=20
instantly, and the sleeper wakes only with each later lock/unlock of=20
that address, one page at a time. Numbers from a queue-walk instrument:=20
363 skipped waiters per 10-minute run before the change, 0 after.

https://lore.kernel.org/all/6a4763e3.9dc7bc9d.3d5df4.0007.GAE@google.com/T/

The same change cherry-picks clean onto v7.2.6 (mm/filemap.o builds). It=20
only reorders the enqueue side: non-exclusive waiters use wait.h's=20
default head-side insert, exclusive folio_lock waiters keep the tail, so=20
wake-one fairness for lockers is unchanged.

---
  mm/filemap.c | 16 +++++++++++++---
  1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d721986d5f46..48994aa81320 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1294,8 +1294,18 @@ static inline int folio_wait_bit_common(struct=20
folio *folio, int bit_nr,
  =09 */
  =09spin_lock_irq(&q->lock);
  =09folio_set_waiters(folio);
-=09if (!folio_trylock_flag(folio, bit_nr, wait))
-=09=09__add_wait_queue_entry_tail(q, wait);
+=09if (!folio_trylock_flag(folio, bit_nr, wait)) {
+=09=09/*
+=09=09 * A non-exclusive (shared/DROP) waiter must queue ahead of
+=09=09 * exclusive folio_lock waiters: the nr_exclusive=3D1 wake walk
+=09=09 * stops at the first exclusive match, so a non-exclusive
+=09=09 * waiter behind one is never visited and never woken.
+=09=09 */
+=09=09if (behavior =3D=3D EXCLUSIVE)
+=09=09=09__add_wait_queue_entry_tail(q, wait);
+=09=09else
+=09=09=09__add_wait_queue(q, wait);
+=09}
  =09spin_unlock_irq(&q->lock);
   =09/*
@@ -1429,7 +1439,7 @@ void softleaf_entry_wait_on_locked(softleaf_t=20
entry, spinlock_t *ptl)
  =09spin_lock_irq(&q->lock);
  =09folio_set_waiters(folio);
  =09if (!folio_trylock_flag(folio, PG_locked, wait))
-=09=09__add_wait_queue_entry_tail(q, wait);
+=09=09__add_wait_queue(q, wait);
  =09spin_unlock_irq(&q->lock);
   =09/*


