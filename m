Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D59CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 12:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C39900246; Fri, 15 Aug 2025 08:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF128E01EC; Fri, 15 Aug 2025 08:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0DA900246; Fri, 15 Aug 2025 08:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52FC18E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:13:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B35FA1D826C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:13:02 +0000 (UTC)
X-FDA: 83778881004.25.FF99AA8
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id D58C840007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:13:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="apKxMqQ/";
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755259980;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Cr2T/PlowsNaBGSDWx2tOzD0LdjEtAvHJO/VwvUy1TQ=;
	b=UIb3LfIapPf5c+14tS33iCeWaUTPkZArb5XDnW65n1h89810rbzpzrFFQ/VFosWxIH/cE3
	gF1GCIHFYTftCRuFldVvm0NFu9SoMfoUBBQYnWRHuJMAcaqEkbmzfhL/gEU++9nQGEMEh0
	kXUdtJ9AKqv+sA3mSqvfyq/5DDAGDso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755259980; a=rsa-sha256;
	cv=none;
	b=EfckDNaAugWfuOwHUkWBEfTofaK+mh/I3tLf4gvWX8I8QE6d9v41TUO+8RI3vaqEIOTHZ9
	o9mR4b2hp0MKi1Vcqx4f7bjgRHOmbDsiiK0nS01j4qf3qb6jaVMdLK20CrdrJmLKEhfrR7
	rXQ+VqJvGEHFRiC11wLTOMqKHE9PcKs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="apKxMqQ/";
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2445806e03cso20493105ad.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755259979; x=1755864779; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cr2T/PlowsNaBGSDWx2tOzD0LdjEtAvHJO/VwvUy1TQ=;
        b=apKxMqQ/FlTSJ8uTwKFnZ1QUJIfZ1x+lRFxf49716o3SdRUmC/FO/O3K5fHxXxhJjI
         hzCFjRMAIui/wyJoqxBypUhTTH+nvr+0t5yaslrhdEuRvFGg8NMCXQzsq688cu6T9GGm
         goIa6yqeI8xj+wdoN88EvBEztBWX3J8oFUSx0WCTzg7euFzgoCmowe7bwoFiw5Mb62e+
         W3DDCfJm4et8bnahl2aIoUp4U2GH0sE02qmY9Uk0sMUkmTE7zswFv955gjAP1Hy8yaZZ
         2urjI+kcrtQJ/uvt4SeFU+0N6FPhKHOygGmu82RLZH0l5P9OraafWQrEnb9jHJ43yGd8
         Bwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755259979; x=1755864779;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cr2T/PlowsNaBGSDWx2tOzD0LdjEtAvHJO/VwvUy1TQ=;
        b=SqbRAQmtm8gd0hQHi1BxCXzZvayx7vPSsv7jHmmFaMn6J9KzYkkEfdyvEVoArTk6X8
         eyarxH0HTzSuezgYnKp151wq051qM2Fsdil+sH811KvUS5yUyjyvFSACMRJRuxV/3D8g
         tRQ7WPMisHvl/RQx5jwER8JWko0vMVOxQVeG/BO7c8qBZedxKWeTBtHoKLQJoM7H/6KD
         KAXIowI/T8NxnNynmYfJ07ci1sQPSVPDQPnpKBQr5G/LsBr5f3KH62U9DBTtYgCS3MwB
         fUc5HJmtn9TNjWPWLoDNbeqWVvq/Vp9mUODgVvbUQJMoyFSSNjZ49fhdyHDRyBlwUphT
         /Myw==
X-Gm-Message-State: AOJu0YzaATi1fZ/ZeaaW9fA2MzpnRxU6tuySTzdCFPHa9v8b+vUHc+y8
	QgrNx2gP1FWgxmPtpvg0C+732Jy9H3UlbbJ29oYhJrepzpOQkAbhBbWRnhpd7TTQ4iw=
X-Gm-Gg: ASbGncvdkJKC3eNOoOzNo3CFTyuHnXoedD0Hq0Z+MPY/3NZ5Qnl4kZc4vag6eJKray5
	pQEnfturOmHXOB5n3Hz/h/9DV6zGfLXBM3uFNwMm8p/2GyolWa78xQZGt1kmr+aU+rnECNC7eWf
	/rftrEq7nEI2Rqzsy+6kbtlAPYleApilS7cHc1QnD/D4CdTowcg7xefnkDlqJ/28XeaTxAuYeAG
	kD05SWofaQEgFhWlnOJA7ZYLneSqRKpT/AE+MLnnXOIufBhrvCvTfG6vfwErWeSvkYwK9iE2WoF
	D+PZEit5V6KpAu1UELuWduA8o7urepNrRztuHcT3vrNDS2FKBvo95Woa3dmV9zbnfwIgmAmvocA
	qly5MtGIN9y+1F3O3ww9AQB2fbPIp/jivP2Yw1f0e5DA=
X-Google-Smtp-Source: AGHT+IFjTqLHBoX4djgJecMaacmADP/j4ypwrNwz8xnCbsplMONYA7NKn4JfOt92v+1JWrG/JCU98A==
X-Received: by 2002:a17:902:ced2:b0:242:cf0b:66cd with SMTP id d9443c01a7336-2446d8f0a20mr30878675ad.34.1755259979059;
        Fri, 15 Aug 2025 05:12:59 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d5769a9sm12765655ad.151.2025.08.15.05.12.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Aug 2025 05:12:58 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH] mm/page-writeback: drop usage of folio_index
Date: Fri, 15 Aug 2025 20:12:52 +0800
Message-ID: <20250815121252.41315-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D58C840007
X-Stat-Signature: fg4gxaopmpz5yzom5ji4dg8wps7fpra9
X-HE-Tag: 1755259980-449900
X-HE-Meta: U2FsdGVkX18JP8hXr24QxBJx3SjDlZbRru4IXcTp35OaVJzmgc9sYJaIw99yOPSmgICw5UGuu7L7VeUknURzKlYGFYmBoqP10aP+cH+G3k04tNooxGAvpeUOIppkML+fI6GI0Fo6XbKawvjOQm8rjleu7ESLp4zY88cSgITG8MGmjFTwL+JzeMLzWS8xqamsjtgUxCzrQg1Ypdn33Ifh2Wd/7q+OVhgR2LuoYQl1h7PKD8HJbVStiqdlkGh5mblUPsXDvtP94N4ctiBo9NKO8u6MkrjfYwy36dvbuRccOb2MARyEQItpuHhDjHIihdygUduTgXIFkBlx9uCuVZxogyICXvi5+DHa4kheJ1t416z6ZBv9eas4xZ1Cwf5SZVHTW+UXSce2WZzwdZ7k8Jw5IAy8E77zTS8aRnLvecGBUpQKNmfFQeju0lm9aQtiB88fJbQL5ynDoLFvbQP/jONwP/oOLttrtG/v6CdxHermCfHFKqlWPgcBHL5nB6XpHOyAEZAc61+VAL5CRNIR2+cxkmON1k5w04H9kKpt8Kfg7oQIxoVPqEibZAJhNVdUcrnsxBfFWacinaxJp8WW775noNkwftlKrZ4G1YYPPVJcqF1OgKwql2H6UPNozMlc+RJlh3fcdCXb/S4TXC+db86QAG3eEkmKm2PNhw020vqm6x+HUXqq5C5VlKZKOaTdE3qRKAj33qObgiR+/ll+Ms3RAuZH0S3ShbxEI/SDNcScCPOaOtvQQHPjt/pfCcKhABclTJfSmCBx3SLTViOi7aw/7CBnmwn4ObGNGP0Js9S+10rvLpopmjK7i0IEjAjOAPxxzNBOffmhwITjdgigaL3mZeGdIO5mm4omXF1yFDneWL2yG+zCNwRzAKFd7g8esau7oqi+H89n3bNQrjSriDWBqctV/B412R3GE3dvh31fn4bde9J7ofUc7bYo4m9ktDdxggYofiwqXVG+Rhd1sHi
 QqPb8Se3
 dDgdb7JcZtIQpETJJ4U01F+reAPE7ZjpRB53eWI4jynLZa2RypFYWmHnnvvEclLKeSFfS33yz+S8bO18kejGuoAR294TunrW0DRBSQcz5jSdk5QC+gt8mNV3xeSSkpGdVrOLOWw03p9IIrEeDxG1P7fDr/2SYZNe4kggSp6WDiV4IdMQAp6pc2jlnln/b7X5xTcpiQzwor1tG2wWx6/C/CdDjccFIYGsi+A6Xy2e7IULHDLMwNXyR9IhUxJFUJHTA7g+1+IsODoUDMEcoBfqcoY0fHSmY56SxZR+OTADjCPUskyfL8oVjNVhj1m73NsCIU6MczbRx7Su5y8eXxYkRKfhR5I5Yl2uQKNth+IoCF6Jwof+xH1iGY6bJpl4HVR+4ul4/BbiaNp3Jdfhf93nE3mfJeE6q8W9q3wWVHV0LdfyJUYO/DPqYv1i2AsZ76aZWza2Qe+2ZAkqF1cJtCIh52zjSEKylS/AqaPK6QomM1eRs6PvpGKxLcQO+XXHvnzVGLRxsz3XOj0/KZb7zlHrj3f4fQIzoVXoz+fW+4O/PXPMcsjvIjRAEFh54P4Lh7OX9CvcsPwIDFdZNbiW9aUifI+UkrP6e5AKJ3kcy0RUTSSYIupXo39661DExPf1r7mtVqg83WCtf35l/9Ac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_index is only needed for mixed usage of page cache and swap cache.
The remaining three caller in page-writeback are for page cache tag
marking. Swap cache space doesn't use tag (explicitly sets
mapping_set_no_writeback_tags), so use folio->index here directly.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/page-writeback.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3e248d1c3969..30c06889425f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2739,8 +2739,8 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
 		folio_account_dirtied(folio, mapping);
-		__xa_set_mark(&mapping->i_pages, folio_index(folio),
-				PAGECACHE_TAG_DIRTY);
+		__xa_set_mark(&mapping->i_pages, folio->index,
+			      PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
@@ -3019,7 +3019,7 @@ bool __folio_end_writeback(struct folio *folio)
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
 		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
-		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
+		__xa_clear_mark(&mapping->i_pages, folio->index,
 					PAGECACHE_TAG_WRITEBACK);
 		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
 			struct bdi_writeback *wb = inode_to_wb(inode);
@@ -3056,7 +3056,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
-		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+		XA_STATE(xas, &mapping->i_pages, folio->index);
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
-- 
2.50.1


