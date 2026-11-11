Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05665606A89B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tootLfOq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hIqtQddj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tootLfOq;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hIqtQddj
Received: by kanga.kvack.org (Postfix)
	id 217C16B05B5; Wed, 11 Nov 2026 12:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF9B6B05B6; Wed, 11 Nov 2026 12:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA766B05B8; Wed, 11 Nov 2026 12:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDF4D6B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68D7D1A03BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:28 +0000 (UTC)
X-FDA: 85423580256.02.A47C7B4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 608E01C0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tootLfOq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hIqtQddj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tootLfOq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hIqtQddj;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kNvahHNr+ZnzS6BVqxpaB44fT0M1MamccoIc3pC6eE4=;
	b=6CPuJEjyKmgoWgcWrePFJqELWr3aelUswWH+XF00TUEW9xj0pMmDPOxEBz2uk4Al1mb5G2
	Y5iVdfamqy+eGQqxwYyJ2VUKmtlPbzLiaNn0O5dVcxokV85px4NXfro1aRyEQl9nU0dBD6
	mj5ymQ4HL/Zvj6CwYIdRn/jeJtIPvWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419486;
	b=DckEewWkT52kSSIH+giGy5XdKvIMYxaYpSjOOiV1Zz5LLkmifS9qBbQvvVZoNiYavHJvuF
	rotBYL0wUw34h7Ercmob5vWqINvd8pUQLS30EM7uyVqINKrzvilZIBxscHek6WFiCJ4vvp
	17ojBetwTxfyeUzJqJ/sSRTRBSLTHbE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tootLfOq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hIqtQddj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tootLfOq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hIqtQddj;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D3581F45A;
	Wed, 11 Nov 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kNvahHNr+ZnzS6BVqxpaB44fT0M1MamccoIc3pC6eE4=;
	b=tootLfOq6n+huT/L0wPFtVc9Cr37kH/3CByuKhioM9XtkQVUn2upi819BxHqSKE+/LluF1
	qU0osjk6nzn+JsznB6gTAg8bFQqMfPf+Yzmn/F0JUX1SmvBUgJGG3x06/L4+WbYSmqTe2E
	xrVTRbRxEpvMd/UhAJIADVa5QZTFJN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kNvahHNr+ZnzS6BVqxpaB44fT0M1MamccoIc3pC6eE4=;
	b=hIqtQddjhDYyd/etrvpeoXmab+twE6gMqWJKKg9qhdzq9i45GpZfcUAUbH0CY7trU5VAia
	FtxH4wE8vKmocAAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kNvahHNr+ZnzS6BVqxpaB44fT0M1MamccoIc3pC6eE4=;
	b=tootLfOq6n+huT/L0wPFtVc9Cr37kH/3CByuKhioM9XtkQVUn2upi819BxHqSKE+/LluF1
	qU0osjk6nzn+JsznB6gTAg8bFQqMfPf+Yzmn/F0JUX1SmvBUgJGG3x06/L4+WbYSmqTe2E
	xrVTRbRxEpvMd/UhAJIADVa5QZTFJN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kNvahHNr+ZnzS6BVqxpaB44fT0M1MamccoIc3pC6eE4=;
	b=hIqtQddjhDYyd/etrvpeoXmab+twE6gMqWJKKg9qhdzq9i45GpZfcUAUbH0CY7trU5VAia
	FtxH4wE8vKmocAAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B8261339F;
	Wed, 11 Nov 2026 17:51:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:23 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] mm/khugepaged: collapse_file() cleanups
Date: Wed, 11 Nov 2026 17:51:13 +0000
Message-ID: <20261111175121.1328383-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 608E01C0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jbpb5smuhd3un6czz4yqt6moji86egis
X-Rspam-User: 
X-HE-Tag: 1794419486-877909
X-HE-Meta: U2FsdGVkX1+6sRMWLiMadxJ4vwYNmY5HREv22ZcXq0QEVZgajNQbj5dT0HZPBGEqzW463I47YvunLJNTDAhvTv7wdJTpcWkeARtx91EbWNPl9Eaj27332InFtqgFxkq8UcyHc1r3HZHFWOznkqqUFuERVOMOh9KcbPmNP0wNl/5BGOmwxKpdGK2vOPXp2Ir2/KyWNuGLDkhlPku/mLzM13r8ei/2SHG36CSw4wyox0Fk4zqjwuGCuiMNWUg5/swSgujjCJ6TL5Rd/0CUDoGPUtFuQ1eGdqUU0xl1nUoBTAPBE9w6MAbo2d0rMIJgnUJzh7Uc9NAfhQtu97Ci79jduc5PyB1qy2P1hkndbL9P8VM7Ix1i/WyG/MpCe96799WlqNslZPRl/8QsFuwZx7erAb2NPaDOtJwTpFf3l436vW2u7d2ZVoRj7jGKGzSrfBKSLObMU6W47ucByMjFsNNx/A2+xWyQDRDCXNB+h5iX9zJqNJAhXbYlddg4TpCvn/VPHrWdvAcgrBzN62YMae+bWz4TE9cB5aBKbrgmOVy/8ma4/9Vb5bYam5Lzv+vu6ncFj5FPNRxQ1RU9Dpj/dg78CZcKnSHL/fHjjwNDd/B9sZKqCL8Hmvvq4kiJi+MOlK/PeFyQxfLZGIAKx1kiWHF809khtRvt1PnqNVyUhcbCfCpuJXpZnxzZgYaH6cHTnVol+6ADmaapv1eydS/FKcoEDLPbOVbz5yYJyO/DhF69BFV1GXvZdfVh12KX1xzHwaskAUCafP/VwG2ohj5bCOXA77efNcS6vxarsrcnznnEhcypGnQHFRx84k1r70bXHJJ0z7OC8/uf2oPCx0IltkVyNnd2fRfd2Hc70WkyssIaIzbeDmSipJMOYsXkKnjR08QU9PSV8u1s4g3uk0qqUyfm/tGcPSxXHn2jn5lM/wl145VSzkmOFg2nF2mF59MN+iNySW7ykDMzoD5PLOqXwo8
 3eC29qP0
 0UuSVtEdHt41vJG8Hsg3a1WRRMaDkm8aTASg5T6xVBZz7II9q7nac+bvknWPA0i0RLLw3UCsukkGxEo1+Qo0270O7TgnLrITz7aE069dHClbqlhxkrfER2vK6uRhl5s4k8is9EwH1XFr1KvpoM+8zjf2Nno4rSl+7tRWC3G1LwjjqqRJSyY3Ehfz8V9qeK79v41FcSbLVYJ8NV8kz9+t1ba6kswU4yuiGErORu4M09xrQeqm0ZDNSjGR3MBkxM9x7/V01UYVtQ1E3+3GLI1ccT3L2jPgMsfg/m8nWOxQKtMVfZKeTvQdWbkrM7hpbuDGfSpl/XuEU0pBCCL/u1shQrFtKJYlRx88427yWDkVZ9z9HcileQRvI4YBMU2fohU9Qsg7cGSGMNxqxwyQwAWBSnmuXGxcy/WDw/hsZO6TfNsv68G0gDcJzQgl1/A3qRAW92iPALOHujW8aQ58NLcnheY4erkeF63x3W09QNKCRMhnlrKZvrdCLPJHGXwvYdAyifZfXHTEL5LoDNHtqNjXB0Dd6OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Here are a bunch of cleanups for collapse_file() that attempt to aid
code readability and understanding. This is part 1 out of N, and only
attempts to address the main collapse loop. The exit path is still a
mess but I figure it's much easier to review if I send this batch as-is,
versus sending the whole thing.

Tested using the khugepaged shmem and file selftests.

Based on top of latest mm-core/for-next.

Note that some review comments from v1 went unaddressed
(Nico's larger restructuring, some small Lorenzo suggestions) for a couple
of small reasons. The main one being that I want to get this v2 out before
going insane :)) I agreed to work with Nico, and I'll either send out some
of his patches as a followup, or he will.

In any case, I'm tired of this function and I hope this kicks off some
discussion :)

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Changes in v2:
- Rebased on current mm-core/for-next, which contains a number of fixes to
  the amazingly simple and awesome collapse_file() function.
- Fix the "bad unlock balance" reported by syzbot ci (syzbot ci, Lorenzo)
- 1/8:
  - Fold in v1 5/8 (kerneldoc); new helpers get their kerneldoc in
    the patch that introduces them. (Lorenzo)
  - Group the input fields of collapse_file_state and make end and
    is_shmem const; is_shmem is now a bool. (Lorenzo)
  - Wrap the prepare_collapse_file_folio() declaration to fit in 80
    columns. (Lorenzo)
  - Keep the original LRU drain behaviour (drain only after a
    successful shmem_get_folio()) (Lorenzo)
- 2/8: New patch. Turn value entries into NULL before calling
  prepare_collapse_file_folio().
- 3/8 (v1 2/8):
  - Rename collapse_read_folio() to maybe_read_folio(). (Lorenzo)
  - Replace the compound condition with an early-return guard.
    (Lorenzo)
  - Comment on why the xa_lock is dropped. (Lorenzo)
  - Expand the commit message. (Lorenzo)
- 5/8 (v1 4/8): Drop a duplicate blank line.
- 6/8: Add a commit message, noting that errors before try_to_unmap()
  no longer call try_to_unmap_flush() themselves.
- 7/8: Explain in the commit message why the refcount and dirty checks
  don't need the i_pages lock. The flush added by 854e5ff8b3ce now
  happens at out_putback.
- 8/8: Retitle (drop "fix"), since 854e5ff8b3ce already reworded the
  comment; drop a stray blank line.

  Link to v1: https://lore.kernel.org/all/20260720142913.846902-1-pfalcato@suse.de/

Pedro Falcato (8):
  mm/khugepaged: separate out windy folio logic from collapse_file
  mm/khugepaged: sanitize the folio passed to file folio collapse logic
  mm/khugepaged: factor out page cache folio reading
  mm/khugepaged: factor out and simplify dirty/writeback handling
  mm/khugepaged: simplify prepare folio locking and exit paths
  mm/khugepaged: hoist isolation into collapse_isolate_folio()
  mm/khugepaged: hoist more code into collapse_isolate_folio()
  mm/khugepaged: flesh out try_to_unmap_flush() comment

 mm/khugepaged.c | 461 ++++++++++++++++++++++++++++++------------------
 1 file changed, 286 insertions(+), 175 deletions(-)


base-commit: 8d21e3d3faf19f461f6d0380fe8a1f5bdba97f25
-- 
2.56.0


