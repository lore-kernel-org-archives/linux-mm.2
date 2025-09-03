Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB089CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50DD78E0019; Wed,  3 Sep 2025 09:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F818E0015; Wed,  3 Sep 2025 09:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2B58E0019; Wed,  3 Sep 2025 09:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 117C58E0015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:00:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7E251DEB37
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:42 +0000 (UTC)
X-FDA: 83847948324.04.7FB8FBC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 75988180018
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xmlnP3KJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N4++Wte7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xmlnP3KJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N4++Wte7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904440; a=rsa-sha256;
	cv=none;
	b=DpRFLLzdhx8HfxQC+NVWQCsnbCLKqAIAG6Pnz53LzUe+PKVnKq9XTos3jRkodLicnZXNqj
	YMb1Df/wkiHTdKklzEjiBw0bP67SZHNUAJQm5k6h6a0SeJlVmWvwBCr5N9vgbBe/73tigS
	WyacTH9+JxPXfYKpRtU+TFWtpDQrjzk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xmlnP3KJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N4++Wte7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xmlnP3KJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N4++Wte7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8VowGBFfDXG/GD85vj37Bupo+CslYBKF/PIHnrFTIo=;
	b=WOHCQALDVxy4oKIc4fSaWDG9qGDWfs0Jj792toLH7TldnTBYstD3ct2NebBia/s55rLY7Y
	h6u2SGMQwD5tnCVXwOk7uoF+B1fgPgXLW63J+YKtou0c999yOPNC9nXQDxvs8BtcrlVRT1
	JEfkYIixzRm990+7f12FmtQ7FQM4zuQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AEC901F745;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8VowGBFfDXG/GD85vj37Bupo+CslYBKF/PIHnrFTIo=;
	b=xmlnP3KJzd9cpQ2KM9zzpkXW/WInltLBBIOx1WWqZstmEQ8zlGEsKFADxRv2DWWqhVy+g7
	bH6hbWOVsz1cZLixljP1tJxgbpWYrX16+YFgN6UjjsXNaHGrhSrVHTYdM+v2zVQvWkGRf1
	2WBXlMwwIxcQZds6glBZ4JTZmCtNwBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8VowGBFfDXG/GD85vj37Bupo+CslYBKF/PIHnrFTIo=;
	b=N4++Wte7jeEZOXvrC75+VMaUkacqmOM3kfAzUKtfPmsg95/u4HsVUJSInm3u2ssLDRl2z/
	ZvUNnf7oZJOVtVBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8VowGBFfDXG/GD85vj37Bupo+CslYBKF/PIHnrFTIo=;
	b=xmlnP3KJzd9cpQ2KM9zzpkXW/WInltLBBIOx1WWqZstmEQ8zlGEsKFADxRv2DWWqhVy+g7
	bH6hbWOVsz1cZLixljP1tJxgbpWYrX16+YFgN6UjjsXNaHGrhSrVHTYdM+v2zVQvWkGRf1
	2WBXlMwwIxcQZds6glBZ4JTZmCtNwBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8VowGBFfDXG/GD85vj37Bupo+CslYBKF/PIHnrFTIo=;
	b=N4++Wte7jeEZOXvrC75+VMaUkacqmOM3kfAzUKtfPmsg95/u4HsVUJSInm3u2ssLDRl2z/
	ZvUNnf7oZJOVtVBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB42D13B03;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +FNHNdk7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:52 +0200
Subject: [PATCH v7 10/21] tools/testing/vma: Implement vm_refcnt reset
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-10-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75988180018
X-Stat-Signature: ewy7dqa5e6iogupkdbh46bme851jxq94
X-Rspam-User: 
X-HE-Tag: 1756904440-77274
X-HE-Meta: U2FsdGVkX18RU2STn7Q//G9CGb0+jyD7Y8G7LjcWXd0JFhggDHWZnq9ukGQ/Y9PM1GVGiJWHZH9YVnhzg5Bfksno5B47XhJ5pLA88A8QF+9PZz5lYjxeG564BlYCD8yPkXpAHIX9BmvYoQrhvVzuIfx7JgqMYeTAobTEQzUkA2bfqgDKe7QE+RtttHPHUS8JfDEC2FD+9NJX2O7jZl54UF0TkKcxSGuF6R7GPodhdMfi0WqDIPZFFAEnePGmxYn5VKNGnTinI8ndpFLFMKQRQLD+egK7yQlJtPKAjIr/w2qcvJrGvusNxDZoVRvBzIJj/Wnp0uKDWrGKP6EwDw1jjxlt8OnsqC6IaFNQr4vm5x58/gLPn0RXKBEse7KjMBGMQ+8HG5y0gtY/dJHwR7mcXCmZhcRSYjZ0X3+4nwN6qytf3JDmKFD1fQXiovAF7FSg7UBOwUmuZwV8U3P+BZE5tLskTE4qqOeoSjVYWSIADTldJb9T7HtSiNTvqNxbsmmZWiIfo5ThTi9giC2m768Bf7RkeqAKzrxV5HZ2zr4zgvDd18X+MiAK/vrbw3LfOfI7KVcOXp7VeddxEMiFobeLDnxRBkG/2CO8k3DMghOO5V3/ET7bmxEo/s5lPVs89LQZcpjmQPj4CBofLOHOHnvkzpNz3sxdV8FippQn/EHS/5GWLnwAfpJXnbNjkWecfCM3KFx29t6tMLDvsTaRcC+kqlBZICzn0jsRPX8EYTW+U8O3uAjNzVGAiJxVy9HDCdPLpGppHVDqm2WgKqN7VWf6/G5iOaBsd9aRFkf4E4K8JEm0q4ddTLLB/dmsHSxoQ4B1Uftco6+yl4bMk3/G9wG8mH5VnmbUm2B/oSJW2asIP3W9xOq3Xpl0gr84RbO+7YQz/uXCqCQcuR7Aoy/XU+c6XtZVVgXw5slCy+fdUgrql8HbTH49XQ+kS5Qp/ly1dPAYk/a1btPWr0N6iJcc2LB
 5WjdmMIT
 COjJ0H3RSkpzMDZZlIUq9OG/taFOEjGmQ7oRms3bKt028hbBkUgnIAYnm8Ooj+v2Mi3zCEiVSHqrq2Lp447TxtUfgSL+fn6FKHubdrxle7dLB2UjXvTPCivC2t5Aafrd3TAzK3Mbxz7t2BLIrEggIn0dcRaiJEUlKJwpnegwtgxR3ccKTY/7wJXjSNrgrvIxH7NRjBvvuI2Nifdby9cCzfUszleS6y2Bndm80R+yk7Q+3dBHRLA1eqRFbqaT7mNtwg9+uuiG949W/mnaYIEC+AjzLSIKlLwSht2E/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Add the reset of the ref count in vma_lock_init().  This is needed if
the vma memory is not zeroed on allocation.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/vma/vma_internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 3639aa8dd2b06ebe5b9cfcfe6669994fd38c482d..2f1c586400cfd65413d2ff82199590b43796b18c 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1418,8 +1418,8 @@ static inline void ksm_exit(struct mm_struct *mm)
 
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 {
-	(void)vma;
-	(void)reset_refcnt;
+	if (reset_refcnt)
+		refcount_set(&vma->vm_refcnt, 0);
 }
 
 static inline void vma_numab_state_init(struct vm_area_struct *vma)

-- 
2.51.0


