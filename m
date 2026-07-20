Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A6A3C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D356B00BD; Mon, 20 Jul 2026 10:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55606B00BE; Mon, 20 Jul 2026 10:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AA06B00BF; Mon, 20 Jul 2026 10:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85A686B00BD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB84A1201E8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:39 +0000 (UTC)
X-FDA: 85009388478.30.FF03C3F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id ECEE7120007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CXeOidXW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=In7xaeto;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CXeOidXW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=In7xaeto;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMzkkAq1z2Y80PcJnVoa9xD0YS9/V3IeR5uFiuqgrfM=;
	b=BUnild/+BO3uh/XUecn4w1XYCpLNghtERheQ1soBUWmVDfvVzsxa+TUiqoPzBH+w0gxsl0
	NNCsQ3iceo/Uv7rb/RUkP1K80HQ+yaItqiC7moaXbzP/bRPNEd6mSWzPdvF2kpfybyfuLF
	aZqcWKN5fnka0eRZ0Zev9mVAmO0KnwQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CXeOidXW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=In7xaeto;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CXeOidXW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=In7xaeto;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557778;
	b=0nqDgcIb/9ivQq/rcIGv4dSVyA7pe+/hmFg3i4dlTjWtsT7s9h5IP3Ny68n6oWfXc8TGvh
	9ykyYrwWemZb8mnW0tdRvVTkmCOxudgDMdF7JxpapQyziV2UmYzWDi1AZHp1nUisT4JQ31
	RuNoGA1mnVbiQWIDnUz1Rdbbf563IMs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1F7E79FD1;
	Mon, 20 Jul 2026 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMzkkAq1z2Y80PcJnVoa9xD0YS9/V3IeR5uFiuqgrfM=;
	b=CXeOidXWIbvLnTUq+SygjrSElZGh74hLlnQs02aGIQzCcp+CtKjgvYqU7fAA2oZG7D8RIH
	74CJOB1GIKVgKf2bMgMwZwvDHdjckJe4kA6mFNrbHpkSh43uYTgPP/3Igmwon/bW/u89eI
	acIwvWc38EfYNBZUO9fEfn2ZIUj+bpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMzkkAq1z2Y80PcJnVoa9xD0YS9/V3IeR5uFiuqgrfM=;
	b=In7xaetoG+Iy1MF6i3VsDFgW8+ruD5cI7ODn8GIJ6Xk37B2EWcPFWmvTR7+1zx2rzWbx8M
	fXGMc1nfoULf8YCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMzkkAq1z2Y80PcJnVoa9xD0YS9/V3IeR5uFiuqgrfM=;
	b=CXeOidXWIbvLnTUq+SygjrSElZGh74hLlnQs02aGIQzCcp+CtKjgvYqU7fAA2oZG7D8RIH
	74CJOB1GIKVgKf2bMgMwZwvDHdjckJe4kA6mFNrbHpkSh43uYTgPP/3Igmwon/bW/u89eI
	acIwvWc38EfYNBZUO9fEfn2ZIUj+bpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMzkkAq1z2Y80PcJnVoa9xD0YS9/V3IeR5uFiuqgrfM=;
	b=In7xaetoG+Iy1MF6i3VsDFgW8+ruD5cI7ODn8GIJ6Xk37B2EWcPFWmvTR7+1zx2rzWbx8M
	fXGMc1nfoULf8YCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D51E779AA;
	Mon, 20 Jul 2026 14:29:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QIsWI8EwXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:21 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] mm/khugepaged: add kerneldoc to prepare_collapse_file_folio()
Date: Mon, 20 Jul 2026 15:29:10 +0100
Message-ID: <20260720142913.846902-6-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ECEE7120007
X-Stat-Signature: pz61hab4sxrf3kmy5dfebkgdniq5anio
X-HE-Tag: 1784557777-476703
X-HE-Meta: U2FsdGVkX18ZBuZMT9ajglCMx7KICnFBenG48X6oWtTlg4udQlZFFYt3cT73UeyDkq6IWLW3n9JgEAFBBXR7C/6b23YnCesl33ANu/ROPwSEUPm3eXmRAUEMZaADYjxa/SkNCQYhAP4/+5ASIYmaSox5SIyRRg4BXMXOcpgyn2KpX4140l9b3B1j47w3DiQejxVq6GX5/7s+6SvXEvRI839vwQ1ujfHUS1je/WoiEU5mV0lT59l0SEuAv5T8p2dvIDfTOaZ870dUHT4kiCSwY1Yx2X9luChLWU0/7O59jSyO00NJ4onBRaM/sWrKpHQYkPBQtHzsbNq5Olphpt6KFj43ExVUDaDsjveKNm7ModDooGb4VxsUq4kE1YUz97u5UAIzlqJOhTV+h0gYjYyilVuMVktSSi8ElxceRMoZ18XoELZuyH+QnXkVozaumIjUf4y2xF/SNS9H/T7Clx+l/O9m1yDv3on2yaVnqSahh9+mKWV7XwEXjFAnmOUn5JkCQuTCGielabAMl8cAPur08WWDt+AsX5E37ewrkjxobXWVvcu/u3xqbHusIQ/g0DUFiHuRYVmaWIYRLTiuigbJB0Gmc0kTT26FaidHcp9ApLK/F4El3qv6xvBvQV7DfNtjWmgiP2pP3jJVMAe/GGXOHu7OnWfVN1RQp94biu4qUlPR6RQWesr825YkQjUdCUVgHuHArv401GDpaPXTjSrx7ZBV1vHRllmc014GSGFmmfZBid2GDSmTgIhnuX5vajWBgYEu8zfOrvMSM9yORPHPae45TC9miL9kKp5PbzlqYTnd1nlH0e6tSD80QwfywpjbllZeSDUfGKAeE1OHUp34J/94qt7kHG/YKOXbD38zg4MiqEfQO1ByJ44AYmaDRQorw4G5PGEy4qEuDeGUxcuoBqlw2n0BiBA4MdaTx108i9q+3YfOyiHYT9oS6aXeaHNpI3JTsbKEaSdX72JM6x+
 1aPRAa7I
 BatSBjWMF3DNXf4nH/xqpCGqbTHoMukN61B/8T0z10Bd3j0RKEu9GqHPC3UjEhRo8ZyWrUaefZ5GJLpsvf3eeGnHkMZDgsLe6kYRA/jbLGrVQ5GnH2gUdcOibA49g8uYDiC2/zbQubxfcCXhVKfp8l5Ew8UJ6ZBm/wnnzBxB8LE/M5EKgbouzavP6JUFNlXF0qadswvFpAkMRmWUupEKO1Q9s+jB97AxPEGnfZvD5P59iTcQVeVVRdlefirPlGMI4kzMqF9TL+pOXKFDnl5NRhFiZpZf/9Z77n/ZRv+yG2nd6pdqNJyXgE9Q14Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The input-output expectations are not entirely clear, thus document it.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d170b64378e6..db1f765b6ead 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2256,6 +2256,21 @@ static struct folio *collapse_read_folio(pgoff_t index, struct collapse_file_sta
 	return folio;
 }
 
+
+/**
+ * prepare_collapse_file_folio() - Prepare the collapsing of a single file folio
+ * @index: folio index in the page cache
+ * @state: helper struct of state being passed back and forth.
+ *
+ * prepare_collapse_file_folio() helps prepare the THP collapsing of file folios
+ * (both shmem and !shmem), including the reading of folios, initial tests for
+ * dirty/writeback, locking, etc.
+ *
+ * Context: Expects @state->mapping->i_pages->xa_lock to be held. Releases the same xa_lock.
+ *          On success, returns a refcounted and locked folio in @state->folio (that may
+ *          not be the same that was passed in).
+ * Return: Appropriate scan_result value (on success, SCAN_SUCCEED).
+ */
 static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 {
 	struct address_space *mapping = state->mapping;
-- 
2.55.0


