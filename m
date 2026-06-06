Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27453CD8C8C
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98376B0093; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60956B0098; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2256B0095; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7F7A6B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BDB2120375
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:43 +0000 (UTC)
X-FDA: 84848111166.20.E73EFA7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57D1A4000E
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zd7e6bMo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OOINykmD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zd7e6bMo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OOINykmD;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiUHkYsEHrYPIfd24rvBp/nbuzBhF0loEn0qGJjej88=;
	b=jDelAZHD2pqF2zuJ82JjnncXWcfYo57KT7Kk0Wl2bKeNfwZ6vhpi4EPe6e7Zn/+srd1pau
	4hEUeg2hi1r/pswi4tTGmjahuqD4xyZMEa0lrumfaeWY4sLhNfnD2R3SP3HaWhCfE5a8HF
	RbS86//Nk4xRp22jk3bMFp90i5q6pvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717841;
	b=N87VQcjvjFEzWbznJgwanbyXLo9Shv3cxwHcuL55fgZCXqQV2ApR8+WqxESx0vZ9aJaCOs
	bOREchcKuDBZuRSyoke9gsciApYzzboO6mV/zurWqIQ4oKqVNw7X9pCjiXQq932ezDoFLo
	DxsPovNaMJFHRz9hWkWtaMReEoiYuWU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zd7e6bMo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OOINykmD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zd7e6bMo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OOINykmD;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F59175BDC;
	Sat,  6 Jun 2026 03:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiUHkYsEHrYPIfd24rvBp/nbuzBhF0loEn0qGJjej88=;
	b=zd7e6bMot+n41fRdWRjK+zqJkovr2Fc5exf5AwbHTzAk7ezdCj+OUE4G+a64eR3oXs/5to
	lJ83IPchuUSXCKv0T8q6vDSbUB/btp0FQ/BZ5PBxYcH27KpusnZCDMoFYVKxwo3kxm1oiP
	Yu8ZlsymBKld+DOmM06btsuy52XsZmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiUHkYsEHrYPIfd24rvBp/nbuzBhF0loEn0qGJjej88=;
	b=OOINykmDQN3+6wcQTjl5ayRcYRwb5rqkgcZ/JxKKGAGTxyz8hpzM/6yUQ+yj8QVpvvdJnG
	Nvnb0h4cWdS7xUAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiUHkYsEHrYPIfd24rvBp/nbuzBhF0loEn0qGJjej88=;
	b=zd7e6bMot+n41fRdWRjK+zqJkovr2Fc5exf5AwbHTzAk7ezdCj+OUE4G+a64eR3oXs/5to
	lJ83IPchuUSXCKv0T8q6vDSbUB/btp0FQ/BZ5PBxYcH27KpusnZCDMoFYVKxwo3kxm1oiP
	Yu8ZlsymBKld+DOmM06btsuy52XsZmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiUHkYsEHrYPIfd24rvBp/nbuzBhF0loEn0qGJjej88=;
	b=OOINykmDQN3+6wcQTjl5ayRcYRwb5rqkgcZ/JxKKGAGTxyz8hpzM/6yUQ+yj8QVpvvdJnG
	Nvnb0h4cWdS7xUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5022F779A7;
	Sat,  6 Jun 2026 03:50:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gOm8EAqZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:34 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Karsten Desler <kdesler@soohrt.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 2/8] mm/mmap: Stop special-casing hugetlb in generic_get_unmapped_area path
Date: Sat,  6 Jun 2026 05:49:57 +0200
Message-ID: <20260606035003.529685-3-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57D1A4000E
X-Stat-Signature: gy6aqpqdp8ibxbnao3muysfkqs9rtq71
X-HE-Tag: 1780717841-730576
X-HE-Meta: U2FsdGVkX1/ws+JznASE8toDQMNeAyoZQf2/+1TKZtW/TPKtvBUmi2ot7HfCdEfg7WU45Xp0XTCv7soGm7YLZM1LVcFnyevwEdaBuLvNDTpcZyuN8myfIAm1xmTL3B3g3Q7CdYv+CgpaH+wGb9ckUnBP+SgdrZJ8jeVmOrJHuQMUAkINOI35daxNSC0WBhE2J/H2ZRZ5UEl92LMbmAz1/5tbf2dFNXWOtj2P7L2WgbYlUd38QXbigXnX+AdKd4e+nN4nJ6GIjqRCxAHq+6u1UAX6lPgyJJmdUS5IdGzi37tgLqAffRj1rc8K9Cy9v7hpneSVTALF8GDUWzPIT9czh5hG8wzGSIQBu5gX6I++bYgq5P5Rxh1p5HIryWvXbSelIzD4/XJexgHm4jVuZ6kFoKPmXwgE5IvWg1gX/UfAhgE6+sZbSzvZsOi9NmknCloSWvy5opRQZAZ+vrP7xfF9YINYFTUWF+ETvdGCJsuX27LsLCV1Xw6GopN1z66a3li/I8/MfowihiOdcE10qPOpBnRCKnVRtVFGLSFGeX84v/CSMAhpTw0Aw09zeKlSc3mfSgVBMVtooJIwIh7erT/ohR15feVranaDL3L2U6G+et7Agt75XyWfrY6HeMaST5yqf0AKtwUEWKkfwNVYPfeLQd07sGPJ2TJI7LKEoXaftCwrYethyi/VUZ5VVayVO/6LYXItsfNcSFasj8IPxjZMsoO+mYVHYkPSutnTmTe6nVJaKJMVW6w2lVQiqX+DfsWe6yn+nTn8CNn5JsEagPn8N/pIpR00cRAyA0tXVHuqShXuWx0+a95VCueo+GnDGiXQutnq0YI0MwrPz2TzBcdkz7R6ddsunpqXUnH4suz/DLp6xxIDBbm8VmEvB2lwh0SjjdpEDOyRWToiJ+oiD7zW67juJZU7gvVkshAOnV6iC2y3q/u6BGSrB6LBP+NH17tKFJ1Dabi2Arl71BX8yZX
 qxAwQd4w
 4Jexrx+wp/d3nLHV+QI9uU98ykdLrmm8ZAoTRcyZ50FJ6Is19200UXF0gv3JGL4QN7j7Gad5m2enPNEkUAkzJaIDKze+JWJD3IdHA/HcQoUDgCqoL7sHD+730gSXsjY01N3vE1QEEfjUGeCcxtpjLNg4/lCIdBT/5HmPlnU2rP28Y1RTMZl5338FM2cQo6/x32KHmZ5mWOPkOH5wZ7tbYgeFDrToeBrLY+z7QBHVEN5DfUldPs1khbu+hfjeT45z31qYF/MUte2PoNuz1bRwtBvNsO4qRABVOEv1HjHSQDj2j0prrLw4guP3chw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generic_get_unmapped_area* sets info.align_mask to make room for extra alignment,
so that is added on top of the length we requested in unmapped_area{_topdown}.
hugetlb_get_unmapped_area() already adds this extra padding in the 'len'
parameter, and it also masks off the address it gets to properly align it to
the huge_page_size we are using.

Stop special-casing hugetlb in generic_get_unmapped_area* functions.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 mm/mmap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..e4defe9fb1b7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -715,8 +715,6 @@ generic_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
 	info.start_gap = stack_guard_placement(vm_flags);
-	if (filp && is_file_hugepages(filp))
-		info.align_mask = huge_page_mask_align(filp);
 	return vm_unmapped_area(&info);
 }
 
@@ -767,8 +765,6 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.start_gap = stack_guard_placement(vm_flags);
-	if (filp && is_file_hugepages(filp))
-		info.align_mask = huge_page_mask_align(filp);
 	addr = vm_unmapped_area(&info);
 
 	/*
-- 
2.35.3


