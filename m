Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6018960A260D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZbNYpoOa;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rWB7D58p;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZbNYpoOa;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rWB7D58p
Received: by kanga.kvack.org (Postfix)
	id 0EAD96B0604; Thu, 19 Nov 2026 15:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B1F6B06F0; Thu, 19 Nov 2026 15:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA51B6B06F1; Thu, 19 Nov 2026 15:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B06EB6B06EE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:11:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E5F71A0BA5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:30 +0000 (UTC)
X-FDA: 85452963540.27.578B043
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 315D714000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZbNYpoOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rWB7D58p;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZbNYpoOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rWB7D58p;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119088;
	b=H21KGku2vPcU9lwdzKSfO0zBJHNsnOPEeyoiUyW1Asn4VxLlOy41n7j9zWkRsK4Hk8kllK
	5RsU0vZXCAFXVkKuJNSqfeM2D1rbjk5upyepSY3QJXBZGp11AmTD6is7iwTuyYbyyIu1yU
	cDlSGPDOFgOCaQMxo8xXllyM2Zs7ooY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krDZt2lyQMLpvzP9eRLAozoK+Qau2jyjNPNf8Y6N1eY=;
	b=UmT4fj52q6gR/5ukwxv07oipbHuVR3SD9zD6JzgTyCRlHAAgbsL1SBYi3RILdQAMcWlT8/
	zYQjAK0RUChdnNhFhmkTchBYuN8aFbyvzG6vku2IaAaPxVPND48e/QMtGIO2+gF9t+nbK4
	kLWHbpawwgskQ1w7JrIzm6KZI1jzJDA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZbNYpoOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rWB7D58p;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZbNYpoOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rWB7D58p;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0CA2F1FCEB;
	Thu, 19 Nov 2026 20:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krDZt2lyQMLpvzP9eRLAozoK+Qau2jyjNPNf8Y6N1eY=;
	b=ZbNYpoOaGHeZLHdhDXsl/zYnjZ/AdQMk7i/SPEMY0Q10yolOExVKqmC4xS+vyK8DszjFQD
	+wfqfFk0zFqQIPP4rrtwR68RSIviHw868FyVT+LRaikKFObVB0EPO0gkgI5wS5BkL9SSee
	V2Ykgs4Q5J5Ir7RU6b2thZ7aLwdmJqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119087;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krDZt2lyQMLpvzP9eRLAozoK+Qau2jyjNPNf8Y6N1eY=;
	b=rWB7D58pv4B4x4q/+Pniaue/ehUunRQRZIy9bTKP+RjVGS0SZswC5zGUcX2yfKsXJqQKXu
	HOQf9AyUfnS6R/CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krDZt2lyQMLpvzP9eRLAozoK+Qau2jyjNPNf8Y6N1eY=;
	b=ZbNYpoOaGHeZLHdhDXsl/zYnjZ/AdQMk7i/SPEMY0Q10yolOExVKqmC4xS+vyK8DszjFQD
	+wfqfFk0zFqQIPP4rrtwR68RSIviHw868FyVT+LRaikKFObVB0EPO0gkgI5wS5BkL9SSee
	V2Ykgs4Q5J5Ir7RU6b2thZ7aLwdmJqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119087;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krDZt2lyQMLpvzP9eRLAozoK+Qau2jyjNPNf8Y6N1eY=;
	b=rWB7D58pv4B4x4q/+Pniaue/ehUunRQRZIy9bTKP+RjVGS0SZswC5zGUcX2yfKsXJqQKXu
	HOQf9AyUfnS6R/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F09A81334C;
	Thu, 19 Nov 2026 20:11:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OqV1JuRX/2pPYQAAD6G6ig:T5
	(envelope-from <pfalcato@suse.de>); Thu, 19 Nov 2026 20:11:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
Date: Thu, 19 Nov 2026 20:10:47 +0000
Subject: [PATCH RFC 4/5] mm/vmscan: be more careful when releasing FS
 metadata if buffer_heads_over_limit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-gup-dirty-what-v1-4-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Lorenzo Stoakes <ljs@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Spam-Level: 
X-Spam-Score: -17.30
X-Rspamd-Queue-Id: 315D714000C
X-Stat-Signature: kgqej1rmatudq9j7zkqxkypjnx7ued9e
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-HE-Tag: 1795119087-304288
X-HE-Meta: U2FsdGVkX18gx7c1OZJosf2MNGj5rhSB8YS61kZlanUFXiWSipG6sM/uKhHldSTMtI2AgVOLv7g5IKW9pRgtnhErTjVVV64rbMIHYhPbQ4WCctJZlbVGESbD5YnmkV+jukIAoosmZrOj5+l52fKoQF0zVErnKOrjOw8FijIHnyqE146QwrVHgTgIav5Kfvo8ZP8m5o3FU7bibNboEYPeeu1rpVdNlnhda6JOdpNk5TJs/J9zzjiaIQHjMeFPaSJfBJQQ/BH07ELGcyp9d9T1hcCU7nuAfKjJ8K78i7ynktgogV+JGAmiVdQNOqmo96F85Xxyaf9EArtt0719I2nMcz+evO+iQCJkHv2EGfiWP55k0Ks19hcbSAWC7thLO2oRy/FIHdUvYIluDne9A9SmNjCO0E8e+4OoIn6XtO9vnaPyagXdQ63BirOGISJf5ohQadPlGChKteZZ9orwmTiqZNnr6zPry19NKcvi0Y5Dmz1tqlOlmrp1o6ZASEQhEkOTvC1YoDcNGTyXxaqG1vHKKYFIvk5r2ITyfmo0sBwpNcu+Ep/XHQDQQlNQ31iifUKSb2Bw4Ej6EPuj5ZmxSqWZ72gQiIHlTGOdybTbrH58bN0raYhKtvt3AdUtY/psDrIoZLZtJvA/hPuc6ZFdplCIiso+8LVm4HVeU4bv3ekt9RFOTMDPZ5I6j00G7s/Hh0QOsivUGpuBBfOZrg0+AZnczcfj5K759XXw8ZPaZ0qrUGdb6V2Ic0ZOtpgWOVVRjhlehX8LzaBZU1OQIcn2Lswh30LvlI5/yGWypIn1k367gOujyAuH7bqyNlEDzlM1mklUzqRC8G03uScBgPJZFWIpEXT9Y9c1IEWksTf0UXj7uemZqboIIrbbjEpSDCYSsTING3UN90VhR3102xwWrlvqYfIcPV7+o/+WMA2doYsIR8KkTh0FcOkAG2u029QDS+9WqbUeFTN6Y/7Uvn+rrDJ
 4fG4HDzu
 tOjad40Ux3YHoV9Qeu6VqtuHZ1+PCRXkcFTorOSBuSGWJHJalj6H+E7caHQfLXT6GnCnTC8KEouzfRPUO27UVuXv70Fr3XoAtIXle5QHHX22XREFFYQWadxFxcAZVHZk486A6x+WTxVdiIa9L8u8su+CF0HSfHeXiu/WvPS90jNOL7gi0CY2sW3JF94m755ewMjSpqKqtBVYGLhKPQhhIsMG2rPXaub04FqqKFAxPmuhk+88kRLStN/SQJBxdbeq4hXuqzGfBkn1jcymrU8ZSk7tqNopnn+NhlT2yBUK1lm7a51NWd2J3qSkhmd/PRp3kY2Y9dskIjTfOoE1cCkMZpwrhHFMpU9ENSWk/fDNExxobQmOePD1REu3rgsDqDBMydAa+4kruqj3yr+m73D2Yta7RYBdHvZ0bvu0ZmBCDQFUauzNh9f5Y2V1dWj4T/rJLLh+LEXFAPdNDMM/wAbYS8z2arogzeBn1PGce/odjRuGkXOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Namely, don't call ->release_folio() for mapped or referenced folios.
Since this is the active list, there's no actual point in doing
unmapping. In fact, that would be counterproductive for active folios.

So, gate on !mapped && may_release_folio.

Reported-by: David Hildenbrand <david@kernel.org>
Cc: stable@vger.kernel.org
Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/vmscan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d80bbb607a15..986742d7fb6a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2217,7 +2217,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		if (unlikely(buffer_heads_over_limit)) {
 			if (folio_needs_release(folio) &&
 			    folio_trylock(folio)) {
-				filemap_release_folio(folio, 0);
+				if (!folio_mapped(folio) &&
+				    filemap_may_release_folio(folio, 1)) {
+					filemap_release_folio(folio, 0);
+				}
 				folio_unlock(folio);
 			}
 		}

-- 
2.56.1


