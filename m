Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CE9C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9818C6B007B; Thu, 31 Jul 2025 11:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932DA6B0088; Thu, 31 Jul 2025 11:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8487E6B008A; Thu, 31 Jul 2025 11:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7526A6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:44:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 243841A0778
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:44:48 +0000 (UTC)
X-FDA: 83724982656.19.861E75E
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29827C0010
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:44:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lYxZlNCF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3bI-LaAYKCAUxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3bI-LaAYKCAUxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753976686; a=rsa-sha256;
	cv=none;
	b=VfI+pi9ulycoWTpE9hg22wU+WJN0TPCBFgzSsQYvW4Uea5PQijrovUc3RWBSR+LUrjIwTP
	BqRh8ADGJZOi9khFst2X7eYXvMSsarnYhvM1mxOHof5cjWRyrHDJsPJbeWtitmLkVxdnXH
	1k3hnlpiIrwKtXIp265k9dNEpk/sr38=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lYxZlNCF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3bI-LaAYKCAUxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3bI-LaAYKCAUxzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753976686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8D6H3TovcRUpDHrrv443Wy2kKrliHPbwf72lIkroPTg=;
	b=eUfmPBxOFVugl5UR/Pne2KKVyVGoJH7tQw/2fnnT6/fCVd0kCtLLCicGDyPbVvNoOQK8L5
	TtVfPm5SrN895hnpsXDWmTzD36FdqMiW/DWE/sv9KqE7Mf36v8OgDptW+BtkTdzJQvyq3v
	5DMFyIFESosTJAIavEXsHctL1t9BJqU=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f74a64da9so751763a91.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753976685; x=1754581485; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8D6H3TovcRUpDHrrv443Wy2kKrliHPbwf72lIkroPTg=;
        b=lYxZlNCFLp1Ea278nziSFPtYQfnC+IRxrS/mTbJ9ZeQKOwZ1NAKrBImBn90uYx/Q2x
         gWkM3ojmddc9i7O38+YNbivrIOxIv8quvBClpAKYkpODVl0V5BJB9w9QKRyD4f4MJ/SB
         KcOLjTa1hj5TJL3akKVG9OdFZsDqE71xJNv+jH5EUPZaTr890hZ8R5Sh9zZi+5XNvQSO
         xmRv3zsaI2CP28nWD2yFr/6pLqULRCrMS/V4QWJBnmk5vau3tvBZD+dZ/FEkHXa80sqJ
         fA8TXYqSixaVk3Sb6+J8Io54N/aP7hkI15dvBgeYgg+pH9ak0LCVHnOX17k1yhpToU7u
         gYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753976685; x=1754581485;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8D6H3TovcRUpDHrrv443Wy2kKrliHPbwf72lIkroPTg=;
        b=j4v0wUqd5iNjlHqHp4ASzoZT502dTXLG4nbdetmjODGNx7vF/IGJh9Z+BIrmxOvQJW
         FXjXef5VUG5Jtf9sbUpOH3qKrxqPdR7eG1pE8Vz6xIqv/QsQ3M3LeRbUqTjO1UNFqgLY
         kJ2K/VIAJGNibYntPlQVy4ZEa7L/XPVc0qIM93sqYhGWjYpybjXSAg0HsDV6t9kiat5Y
         bJhV1coPiSDa3wLXEStTw24ABaPitSbmXJyWq+x7XVZvG3ctngFBIR2vl7lpPZlvcbGB
         PpEKVrAzuH6biKKp9DUmjWa/yALjqyX8urYl32d8OXSBaKJG1ITJT/PqUTvRNM1k1WTM
         AskA==
X-Forwarded-Encrypted: i=1; AJvYcCUa6QX5jUb5EKxLptoaryhocIZsVaSGYR7qWfp90GL8atHFXe9v0GXRoH9n9ZWBOluKNqqbIC4/gw==@kvack.org
X-Gm-Message-State: AOJu0Yx5sM8PtLkw83G/yAGyDE+YbivQcQk4+urC/Bg8mFGikXGNkV93
	gaZK+gEL2rWOq84xLNP7iAJjjVrzwDBCOtge0IHmHvz6/sGyjM05b8NHeP4i1nNlQQ9dI6Amvsb
	4Fw6ObA==
X-Google-Smtp-Source: AGHT+IG5srnDugZwbzwxdO5CMVzSLz47ALstUwtxD0ry/hJIfF+IqAvaHkQ39SziNPkrw/OnSv1Kvb0DGBw=
X-Received: from pjbqd15.prod.google.com ([2002:a17:90b:3ccf:b0:314:d44:4108])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:562b:b0:312:959:dc4f
 with SMTP id 98e67ed59e1d1-31f5dd6b53amr9841464a91.5.1753976684978; Thu, 31
 Jul 2025 08:44:44 -0700 (PDT)
Date: Thu, 31 Jul 2025 08:44:41 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250731154442.319568-1-surenb@google.com>
Subject: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles a
 THP hole
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: peterx@redhat.com, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, surenb@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4rpz88gcqym7o9k7xjsyy117cfj33n1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 29827C0010
X-Rspamd-Server: rspam02
X-HE-Tag: 1753976685-443425
X-HE-Meta: U2FsdGVkX18oSg2GcHaCtiDqyQKCIfgDZvotNLJtLtKfr7PCCyfytpi2rjt35kI+6nVSd5F33T5qD++jNqnOehIIetpS/5yUanpH/oo+wE7/VxGMnqzefhkg4/3LteoKogODl0pe2oeW8aGbISqlzNWgNTeNdAEYfdV1SOKfDVOStnM2lmMOiSYzX5ZWbjUu1+54fpZRVQZtUBdzqVIE5+rVYL7PIoiecQMGa+b76rY0ga+z57avEOK+oVehnZaqdBNh3VZ7ULJhOfvH+monRfK0Fd6F/CdRnwtHrfXC0/MHRxzGStdJFxvCuxGAL0IBzef4PrbOd0ThhEiGuPWO2x7Sx0PGv35da/tgmJ9XOuBWurR5hn+4+qMhfTpKjfL++GyxhTrl+ukDeOSjbXfaBeVH0eQ4EjG8JVrm69FGkOB8OIjewMFBcUjOih0A6q8LLwSLkk+Zx4sI407L538YxMQN+NbKgCVABsuYT0S978JidSzmqEyKCW+fbxwDQ6Bf4DDCplTfN+40l3xFsMZ0ktKKWzWekQhEvpZm4GsJhQxRoswRWX9pj7SwZNegIBFpwjlZzJRc9pxO0MTk5JKeFVVC3NjV+NYEBNhdWDUcjwUrGfib4s/KagD3IexTB4b4shp9KfetzHOxeJ2pL0XEoBjiwhK0J3bR8IZEW07YP/XEcyPQ1bHntK94zYg4OtkCL4hA6N7QTdlPlWDq6eLGExGa+i6aQ1zk/2E2pHW18QczYgDPXBSBO/+AZQb0bvYsDPHpal6jGjFk4+N2cZQ8Zm8Krbur77rZtiZOR+bizzlx9SzorGMxIPWS9JunB5olBR+3xs2yKJQQwei27gTJsdSMGIrlna5M+8SHUgMpx7aw10tLzMe3/cuInpcPRE3zoa2hgyEJESMyDBqtZJO3/LtKuKW+Vbqrka4RGCClXIhpMSw6sHkZjvorpN5tvU3eTCfiG13L41PSCHwKuvl
 50U6vR60
 o1MZmIEX/ixF70IMAlp31vSAK5ics/qCAs0bsvf+sfQ0h7qqLudG+yWTnUJeHQI4XMKM5X3a192TksSAESstc95GrwRcdCcwOQUjtHl2moe4JwS6BXHcLWYi4VQEfYedLF4v904uP1VpY7XgSn6fcUbbeTWBNzjNolDppe8SMVY8TBaEf+kduxbEVLqcXTP8pCfilT0geu1qJXaaxFQGPGCKZxtJTBZs92aSomCAmllWvT6ZLdbE2TpbVysbY3F3ARuwloeLpns8BzMWSuH9MagsgDErLGGVnWwXWAMfg69hlJKdjEZYT4Nv9OBwi0cjIXfyzrATrdCKDySegi8wG2kNZXxxGmyEu4VicmOp/vMBeOSDvvprUvj9BbxprbpA0icpKm73cfhJXZlrCfxQTaAMFzaRgIqa7rmc0J1Grcqy71yVskAGxjrEqoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
encounters a non-present THP, it fails to properly recognize an unmapped
hole and tries to access a non-existent folio, resulting in
a crash. Add a check to skip non-present THPs.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
---
Changes since v1 [1]
- Fixed step size calculation, per Lokesh Gidra
- Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra

[1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/

 mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cbed91b09640..b5af31c22731 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 
 		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
 		if (ptl) {
-			/* Check if we can move the pmd without splitting it. */
-			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
-			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+			if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
+				/* Check if we can move the pmd without splitting it. */
+				if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
+				    !pmd_none(dst_pmdval)) {
+					if (pmd_present(*src_pmd)) {
+						struct folio *folio = pmd_folio(*src_pmd);
+
+						if (!folio || (!is_huge_zero_folio(folio) &&
+							       !PageAnonExclusive(&folio->page))) {
+							spin_unlock(ptl);
+							err = -EBUSY;
+							break;
+						}
+					}
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
 					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					split_huge_pmd(src_vma, src_pmd, src_addr);
+					/* The folio will be split by move_pages_pte() */
+					continue;
 				}
 
+				err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
+							  dst_pmdval, dst_vma, src_vma,
+							  dst_addr, src_addr);
+				step_size = HPAGE_PMD_SIZE;
+			} else {
 				spin_unlock(ptl);
-				split_huge_pmd(src_vma, src_pmd, src_addr);
-				/* The folio will be split by move_pages_pte() */
-				continue;
+				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
+					err = -ENOENT;
+					break;
+				}
+				/* nothing to do to move a hole */
+				err = 0;
+				step_size = min(HPAGE_PMD_SIZE, src_start + len - src_addr);
 			}
-
-			err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
-						  dst_pmdval, dst_vma, src_vma,
-						  dst_addr, src_addr);
-			step_size = HPAGE_PMD_SIZE;
 		} else {
 			if (pmd_none(*src_pmd)) {
 				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {

base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
-- 
2.50.1.552.g942d659e1b-goog


