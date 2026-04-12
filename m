Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0856DE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406A36B00A1; Sun, 12 Apr 2026 13:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE916B00A3; Sun, 12 Apr 2026 13:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3526B00A4; Sun, 12 Apr 2026 13:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4AB6B00A1
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:43:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E254D160A12
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:16 +0000 (UTC)
X-FDA: 84650625192.20.602626A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA7C240002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AuJPD9CS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u45SU55D;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AuJPD9CS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u45SU55D;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776015795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdCTR0tCpwfzVsn5q0RVh1DnLiRFbAD92h9WzaCJKOs=;
	b=kbh0t2SgiEKAHomfprt0daZktJjiDnLR78Ir9079D7Ipkg5xlOudPdZuWrVTwA9jpK+C3K
	OLDGgAwD8mOFkGQFLso8XVmKA/ULcg8gq+oOR3lgXLSIyNVaKJMAHFXzP2mjLhHBDjCzAq
	gXBUHewrd9ntJ1OyFRJoZAp40AzjlO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776015795; a=rsa-sha256;
	cv=none;
	b=3fV6txLcsNW488OGzmoAJM7rjKmoog4Bh+oAjjxb8XXS3XjPCjNKm6/N9RmBpxLhpY2V6f
	welwaxQqtx9rCBco6JjiZJq2VoVF/Y34fcSRaAjGFSe6JuMWAjhfxrWRbeMyIt594DIPcu
	4bGaNAT7/pJ0g7jAOFFpzNK5g2kY3eA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AuJPD9CS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u45SU55D;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AuJPD9CS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u45SU55D;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2801C5BD83;
	Sun, 12 Apr 2026 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdCTR0tCpwfzVsn5q0RVh1DnLiRFbAD92h9WzaCJKOs=;
	b=AuJPD9CSFTtu9WM+XaKpk2j0S0KF74+Ghh+JguxmJ8jMocklMU5tZH41YDzhA4/WpzMIsJ
	lHhPKbMwXSVr9JZ9ALm8Dv5My10g+p4HR3uYdlkOOFRiOPbsfO4RgpdW/6XDnJ3CRYftFd
	OcIcQ8pw4uWfaY53Huukxd4eEL51kqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdCTR0tCpwfzVsn5q0RVh1DnLiRFbAD92h9WzaCJKOs=;
	b=u45SU55D/mS/OVH6cBFwsQVgMBlY/UZZVshfmjx/jDoSoWpVcOsRw/EhFbbjcq5ns/iXER
	4UJxH74uH0OqgvBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdCTR0tCpwfzVsn5q0RVh1DnLiRFbAD92h9WzaCJKOs=;
	b=AuJPD9CSFTtu9WM+XaKpk2j0S0KF74+Ghh+JguxmJ8jMocklMU5tZH41YDzhA4/WpzMIsJ
	lHhPKbMwXSVr9JZ9ALm8Dv5My10g+p4HR3uYdlkOOFRiOPbsfO4RgpdW/6XDnJ3CRYftFd
	OcIcQ8pw4uWfaY53Huukxd4eEL51kqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdCTR0tCpwfzVsn5q0RVh1DnLiRFbAD92h9WzaCJKOs=;
	b=u45SU55D/mS/OVH6cBFwsQVgMBlY/UZZVshfmjx/jDoSoWpVcOsRw/EhFbbjcq5ns/iXER
	4UJxH74uH0OqgvBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3E984AA48;
	Sun, 12 Apr 2026 17:43:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4PBPJaXZ22miRQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 12 Apr 2026 17:43:01 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH 2/7] mm: Add {pmd,pud}_huge_lock helper
Date: Sun, 12 Apr 2026 19:42:39 +0200
Message-ID: <20260412174244.133715-3-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
References: <20260412174244.133715-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA7C240002
X-Stat-Signature: dk7zms6wkqh5pzohtnea5jtrhpz6bwx9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776015794-65543
X-HE-Meta: U2FsdGVkX1+v5YMoYoWZ0yjv13Qp1E21GbDCJVBxC3UVaHmAKqAj4Ood37NV5zj/dsEu9Sininktcp4+wWAxtr3vXbMjHTqcoDJhNw23bZMt6N0PeLnMkzL07RJsYX6XIpJJKXjPqhJhNn/qCd+XVFhkHG/jA3brCOzV3IH2oMTCJaX4XCnegC6ElSV1EThgWhA69sPJYu8FGV5QanqJAzTi7YyuVgPfYFLwU63cZt0So4H4l8UVCUC3F0jHanL9A77c//ZzfN0S64WNX23jtmaj0bXFB//zsjiGtCMDYgQi3oG4kphB7VwZP7/SJ6gY+52sKhDdZMAImv4CyJPnjXFxSB6xCky8J98D6SM3aTzXOzT0kY5SXoEBe5o7viIQWHGSBdE9ka3dxMXkPMflcjvH/OVnls5JdkkjjYT5fj6X4pOBCDDDyCQQiWvoRZpd01tdtjUVufSivDlk+qLwd/lB3TlWkspX5E1Op0rTc6XjgQNRnkvJAT6wI6DJHThDmKTNnVxGr1kbuH94JpWWAjBsQcl7+8QZuo2XVgktHNsMC+zIASwBI8TINl2UceuO5WpcwiW5WUstsnAZfkgguOuGX0BcJ+KZGxiZsL72MAUDMvKLtFuKb3nrWyV6PgUxpV1ZBoMCKM+sUHbxPCcjWx773pdAFSKfb3f1Bsf3CY5Jz9c2W1O3A4Ylbh6Vtx6TE45SzHmOwcpyIAFn7vUkeIu8FYFK3Ke07csUcjdrQ7Kq9nXp+9bOVvIADzNXB1VtHTkK7aFdXtgVqx1QncpzFiNWKDbE3rdaf+nhsbD/v9tLFa1wDdhzpaWzQe8UClrN47t1cI8szNLOjmJyQAVpU8gYZI0qIz/UTz5Uu9jO44853/WAhhqSCcL5UXpG2h95luC/ESukGsDRbkjhvO4wcGih+bRq6vQvqfHImMauHA4fNJMIkWuc0e5xJj74+1+RRFl+N2qZaCuH4rHi3LJ
 uRDH5Rmt
 qpG+yGHp0mveIxh5oWRmvLGqSvxdTG7eShijG/wiWmIeX5QU8I7O0UClhRc/LRp9eP7XZ2SFhiYSDrV6pm5TlFkNIKOmicnAaHy/zF8WNiV8cCslBDgKaORJEURnu2ELWL9Somxzmk3gWk8Qi4ZWkPKpOAAY/2ZxRPI7PXDcMgB35izDNvsk64JxxQ522lNjXxn1QbKGNh9htEWYDQy2UebgpD1Tzb4uIms3AAm3Ma5gOOA+pqHda5S1PTsiu+13GrfCcAAdrDBh1LaH1JJW+1nYu1AIQcsJXnvOk+QP0V5nlKOMW4UZf1ZVi+aPWLI7RSSCaT227SxdXBAlgePwXr/DqmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and THP use the same lock for pud and pmd,
so create two helpers that can be directly used by both of them,
as they will be used in the generic pagewalkers.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 include/linux/mm_inline.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b5..3ac77b50e91f 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -655,4 +655,36 @@ static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
 	return i;
 }
 
+static inline spinlock_t *pmd_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
+{
+	spinlock_t *ptl;
+
+	if (pmd_present(*pmd) || !pmd_none(*pmd)) {
+		ptl = pmd_lock(vma->vm_mm, pmd);
+		if (pmd_present(*pmd) && pmd_leaf(*pmd))
+			return ptl;
+		else if (!pmd_present(*pmd) && !pmd_none(*pmd))
+			return ptl;
+		spin_unlock(ptl);
+	}
+
+	return NULL;
+}
+
+static inline spinlock_t *pud_huge_lock(pud_t *pud, struct vm_area_struct *vma)
+{
+	spinlock_t *ptl;
+
+	if (pud_present(*pud) || !pud_none(*pud)) {
+		ptl = pud_lock(vma->vm_mm, pud);
+		if (pud_present(*pud) && pud_leaf(*pud))
+			return ptl;
+		else if (!pud_present(*pud) && !pud_none(*pud))
+			return ptl;
+		spin_unlock(ptl);
+	}
+
+	return NULL;
+}
+
 #endif
-- 
2.35.3


