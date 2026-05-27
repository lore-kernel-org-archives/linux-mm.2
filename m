Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C27CD6E43
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40FC6B008C; Wed, 27 May 2026 14:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3E56B0092; Wed, 27 May 2026 14:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892996B0093; Wed, 27 May 2026 14:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7727B6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:48:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47B7F140616
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:07 +0000 (UTC)
X-FDA: 84814084614.06.C686D4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F6BC10000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRoX7yVU;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779907685; a=rsa-sha256;
	cv=none;
	b=4UFxafuWs3wxYXu4KPSrgO9e/PwaGqlkLIkUhRI1IZX4osCv9qe5UfueyjLXqG+B5JLym2
	W65zHg0nYnzjPWlUJNOOx6c9OAfpf/rF/JXkM7ZZIIznGKhNVVqqYhx1iEEH+7XTtY8Z66
	Z1OHxicPZn848VS+Ct/2uH6oY/0IwrY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRoX7yVU;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779907685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRSYO9/9bR0VX2Or4HoVo4m/cqxBZNmu+Ypk7OqiXPg=;
	b=Ro7Ef5hHDUneCCJFNbPEetqECh0QwSfjzo9f3R65m2bp53hfbiisZ5rDr/6SF5Zg4c4RIj
	Pd/uaGH8WDJmtYLVeadHfyy7XqucrThWKjSJFl1mJ6OiGzJOK88dsZ2d/E7DLEDMri+ANr
	4cKdAQGxKY3uHoRiQjQkw3V8EaxmdIU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3A3F43ED7;
	Wed, 27 May 2026 18:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E818E1F000E9;
	Wed, 27 May 2026 18:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779907684;
	bh=dRSYO9/9bR0VX2Or4HoVo4m/cqxBZNmu+Ypk7OqiXPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRoX7yVUnMQec8ELSRsqOSyrWPmRFWm7oaNBr1RunHRiYkJHwdhXT5uoI65FaoN5Y
	 gzZbvEahTLDAyoPjZtjtRSTQ8zLOi4QfP43lSm2BZNvvIqc3CSmKRyNtuxI4J2cIz5
	 uMBXfXKV9xWlkR3LnSITJJrCH7OtzVvJe4aWMmP4EhxeIDBf61g/f7OZ/zrcguyrOp
	 XLPylXlGh106yhi8JWllMWWVYSjjprsp6UszlhijGbptAYcQOgBK2M8XMln9r51nKh
	 KVM5zemZT8bUdHY+M9EoKmx/gKtXrgHIrYZAR6PRCqDENbi8lv23dFDSbZ+nYcR6TP
	 KZvgchARk1NYA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
Date: Wed, 27 May 2026 21:47:50 +0300
Message-ID: <20260527184751.4147364-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527184751.4147364-1-rppt@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F6BC10000B
X-Stat-Signature: p8af7sqd4btmsxbthy64dhwh5xshgpda
X-HE-Tag: 1779907685-490551
X-HE-Meta: U2FsdGVkX18QZ4es82zD6Azbu0IW3BzPADGop7gFucPtLR+36iPdqkR1/fvUh7SolQ3dRK7OVugkbmXdIgPYvhfE3zMpXbwyZSJeamwmPSTi+UEQB7a/fbl+wM0dmCztznDcS+RoRas3/4DYMMtZN/AfHwzL0e/YxNiYz1f1ffC/HAidiuSwHQ3X7GlIliTSaZPbihUZngedbnRiHsPHCa+xjQcRmiY/R+Rei5exVMeSEIvYyghuAFDUVe47plEajO2T34mhJWH6yE1WAaWDwUe+TT78uL/G+aLqnLv3nmgEZumIylx3yYj7zhFcqvFUs7rH18i0hGM3AlWKIcJE1Q+EO0/hQR/Pi0TA42mf0VPNufOhWOa+zQbxIMtA6S4N15g8OwukE1ZEho5ZGHf0QqHmOEnBrUh4KefLbLqCiki/eM0Mgl2M9cl/5NJCauZWCxOilxMjk0C+ryt+v4zQ5GvQ8DVj/AWhjkxTLkoPGUQRQ6hml+FujpTJDlYL364ih+MsXwVORWvI4xUd8zaw1MYomVhs7bwIfsW55BboddrRRxI86G7VOQ8NFheC41z+ta8NriZibY4w8hOLi7P9/jmEy4KWbW4O5OOu4pmypzZWDbFM3tWwFgYo12IySIf6Ey1tu/H3qJn/Yd+REbp9tWciMdf54h5Z6H7yXu7T71lHbGi8SL1z0KWV9S3onBkgWsmE4ABI3BMiveMWmiyXDWvxviGDHq2byQsBddH/r3c/NtRhX5B+fkfweuZXZ18rzUrvslg3zpduJvGoNdMm/bVTW9uERCfF4hIgpNVyAJBDpSD8A1A6iGKDiu1zDX2WD+vvFPf3sDtuwwKUKqkznBj0BOMLld+Ptlx2UuVLzAOnO4nVfeMRMTTxhRRPwGxhnW3UECxRf/TXnZ2LtrigkfZBRv79mwrT7/ZaeVH8bwvTMkbQEEe1FNeLBQLGCddTCiTQiDyP0O0fCoLyn+K
 xKFdjcbp
 0s62kHF5jdEG1kZtaeL7rv/5YJWqHlp6gt6hGIxg38KzonCwHsmwi+G4QhxD5FRK+gciLb40ENZv4mrl/Gpo34v8VtvJMpjGrTdBaYlNXwCApYy3QY9YYMOa0Fu2j34UV7C6NboudnHOOoCgmKOh+Uu2jFJ+fnlK9fr0LZ63qbsa3iYh56hU9+0fC6O9wUpp7/fIGmFXQCfzF3YErhUeC2E13xIW+xFsBRRXhO+y7mVxNR1nhUoAzAWDpyinn1kTZqjHxdswm2dXvktqSup/IjpbTOTK64S9sEgtD0xYJOZhMhiJTqtmsj8tw/8sRKHAZAH26WuhbCGdctZYGJHcVjOVJEqRNCg/j2ya9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

__mfill_atomic_pte() unconditionally dereferences ops because there is an
assumption that VMAs that can undergo mfill_* operations are vetted on
registration and must have valid vm_uffd_ops.

Add a guard against potential bugs and make sure __mfill_atomic_pte() bails
out if ops is NULL.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Fixes: ad9ac3081332 ("userfaultfd: introduce vm_uffd_ops->alloc_folio()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e5d2fb3ce2c1..2872c71bbf36 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -552,6 +552,11 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 	struct folio *folio;
 	int ret;
 
+	if (!ops) {
+		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
+		return -EOPNOTSUPP;
+	}
+
 	folio = ops->alloc_folio(state->vma, state->dst_addr);
 	if (!folio)
 		return -ENOMEM;
-- 
2.53.0


