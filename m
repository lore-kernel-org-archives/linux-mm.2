Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25853FD45FD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C4B6B0096; Wed, 25 Feb 2026 17:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF526B0099; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66756B009B; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C07FD6B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 888DEC287D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:43 +0000 (UTC)
X-FDA: 84484452486.01.866C5BC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3095A40008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=dk9Jybov;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+x8HlKrObJCF5zGXiosgMuiJzbAlNo3I+yj4hi3OCU=;
	b=IxuV9ejaclsqC20YeGH4CIHJk5gCw6jHu77kCIJHSRrjI4iO4Y55c9EBA9huER6Dosh/ci
	/C9VY98r1lRjLk711ZbDgWnfm6RDwN1FNy0ks2A/lmjYUq1tAXlQo1QkuLA4lRQWL/Rqw5
	Ffv/5/uaeTEPyjHA+zmN3dCMlg1fu8Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=dk9Jybov;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059301; a=rsa-sha256;
	cv=none;
	b=U7sT0Q2ZHQfoNVnpoS+DDMmwFMF38KGriOYFBW17p4kzpLeuvM9ea/aJj4NEpu6bcCgnhL
	Tfiex5vSu0Z2A+KpK8OjVz99Jcla+FRSKbxTXGU/CT5pHRqUFcCscKnTGQxVduHpyzwsSQ
	GVj+8N8Vz1dxnuQ+RioIOm1yuoSVEuw=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PMC1jT1601368
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=B+x8
	HlKrObJCF5zGXiosgMuiJzbAlNo3I+yj4hi3OCU=; b=dk9Jybovs8IHdEvEGP9P
	/Q+tTmC5El4AZB2gHDz4eA8v6PeKwiNC27gSP64f3zuophROaYaLhYmmHZXiKwMJ
	NSRp7hKX/59LhbwItsKVPFd7Crde5MZ4zs3tGudNHcoxx4fALdYT98VxFmtL21u7
	fGfx2Y40whZsXWbmDY0qeSprynaAbzY7D4ttYLp1lNjUZRCarCpKgXdwbIuqQBKo
	dAh2ixL7cwqcSMAUrxeiWUHwrgu0D6JUMLqoY/Z34kR3anogYSc0Opb+0Pn0KWVM
	aWbq5vkVIyD/o2s7Co6n14E/UIIBlvbWXdW76yZm6WRRtPqcpoGOJFPXc2AOxDga
	cA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4chxa0p1sg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:39 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5061d1ef1f3so32446481cf.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:41:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059299; x=1772664099;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B+x8HlKrObJCF5zGXiosgMuiJzbAlNo3I+yj4hi3OCU=;
        b=qLKqCOiSsHc+arDgchiDTS22zdXn+v6dXebm+4leOrqkK1UP1++1z/ZZmzrFh+hQ40
         KvFTE/x1P/zt0HIpG2JjRwxrmoPeq5qa1gFw5oAoxL4t7O4KggPjfLMEr2NSaV+U1LmV
         Pc5OSZSqH/HRHq0sYNongM53XGH+0MNBJjb/gJMghICRU27kHqkIxuhcT2BzgzCJUrFt
         wN+pP7Wr8P0TPdpsIaVCpp6HZWYsmO86xIzXwXwbqhMIKkDdrUB/MY/CtSlgk+y+KWuP
         xGYQk8iwQqh43516/LevyW/bpFR3QLIDsDJQazagt3pyDphhqcTXI9cOK9T4BwCU+c5J
         AMLw==
X-Forwarded-Encrypted: i=1; AJvYcCXIKlOtQRjUsqviKNBfqo1CdRQZR2ifhVQrslv6IccSeQTbfSgiJF8ypS5+PTnTKIggWcuWqh5KwQ==@kvack.org
X-Gm-Message-State: AOJu0Yymk1FqhpLyr+8LM3eZwcdd1CsFAPbek1sK660MCpHVWyKEpEyT
	X53jVA7UcsuNMElgj2gJgKcZU61qfETOmiVHV/utfpwA6KdiM1WX/PaQ6ErS9/vnS7EEGUtN4JK
	goN8tgPbthEHn3Dj7nltKp/WtVaBdOhNFs11RvRAwSRhmvgMz
X-Gm-Gg: ATEYQzwQgC8jjwXFC86Tokbv6o0K78uekE53cXUQr7n4bV1uGCr/fRMz8dZlERtjU+N
	VkW9fwGDe5Jwn0fju32Yeg/t98xqmo60IBiGP2xZHARDA6walW/zcs72GGfWSACjYvyNcLdKc1X
	kjfiTzY6Cg/0Rj/89a91i7G6hFNa67khU6yhhbjfFRrrObmXc1xAly/KwJw77SsmhVJaWPGQbRA
	FrLVTZ+liikZE5AzcrVlpFG/L+KjUt1GetBRiXzU1txz/P/VP7oGxYH8awczDSl0J60NuJROC73
	VsFXnYxIMfBtKEdA4kJAVasyGMKF9mJ99MeDrSTgymLJbqbT9f+sjDNT8LL53VodIOKEgVikdr0
	SaBGPyPlrw+5vS1fZ4qYZ1hwvsvzx0LOM
X-Received: by 2002:a05:622a:44:b0:4f3:59c1:768c with SMTP id d75a77b69052e-507460dc42emr758601cf.60.1772059298710;
        Wed, 25 Feb 2026 14:41:38 -0800 (PST)
X-Received: by 2002:a05:622a:44:b0:4f3:59c1:768c with SMTP id d75a77b69052e-507460dc42emr758291cf.60.1772059298273;
        Wed, 25 Feb 2026 14:41:38 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-507449be47dsm4196231cf.15.2026.02.25.14.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:41:37 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 17:40:56 -0500
Subject: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from IRQ
 context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
In-Reply-To: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
        ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
        linux-mm@kvack.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772059296; l=4861;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=wvO7UclkDfOFQdfC1evvQhRGdmzqdeL+WI5Bp8USXg0=;
 b=h4bisF4GoCaCSoqd37/ZfJNSaUymW/3u+9LXcqmZG0KnRoDbGHtk/4qRW+EsLRX8yAk3THDOa
 S2MblO1dCLPBna+BzWEdZKkpfva3GYEHQU94DPCiujOK2l2fhb+tpu1
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Csiys34D c=1 sm=1 tr=0 ts=699f7aa3 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=wj6egcThClJy_xBgiekA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: NbuSrbQ8E6FK-t7cCenw7G29_MMKv72a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIxNiBTYWx0ZWRfX46pA/6gCqBto
 iOvZfgzHlpXBHyMVOTgiK7H/vXEI4TrzL+O32qy6WJ1U+35+SxAa3aub2O8MH79g6ehTzYHhmp6
 ky7YJLMzvKNXPK2w0bHCLodHUTPJCfwbOHflfMc0plkbtZl4KVHtnKpurmJsNfkRqDiCmpZK1rn
 tybyJUd36BO1CNkxLjWGLaxk02ejCc+3+GCi9nmC0XH3XugF4Mb70LWcYkLblhQ+TPw7RsnE/PW
 0a3oXA6JgxQxIdq9Vg9b4Nh+7hNrJ0wtEQ9yz3ycJjXcJu1I6k5E3ye8bwZZOTiJYzJfRwtRnPK
 gTrb3ZGinPsaD30oAzIQ/MkLxCkSN1fRfbeLlzhPn2z/oViWKAmou5FpTBSN0lSwOYkVB8yAQVL
 D4UHOxGi0ktyth8mJTrocg4OYOU2LSkx/8Z0DDk2tbL0+LPGy0OYbOi3EGFLVEptLAtMCJmklbX
 sVv5D60LhaCLLqIK0zA==
X-Proofpoint-ORIG-GUID: NbuSrbQ8E6FK-t7cCenw7G29_MMKv72a
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1011 lowpriorityscore=10
 impostorscore=10 phishscore=0 suspectscore=0 bulkscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250216
X-Stat-Signature: 37g5p71jsxart7yhx481f7i9f5t6ydmf
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3095A40008
X-HE-Tag: 1772059300-195633
X-HE-Meta: U2FsdGVkX1/FBhSs+CqhGBtu3I3vRTQlnReZVqdZNH9e3A6LLx9cgPhioYNfuMY/QntVSL4qCMI4uFErePUk/e+Ri60A+b6puU6FUz/0o9Lry7q0alM0e0ZzYy+yJ4YJoPiuqScJdidaWiOkJNR26X7gGJ/axypBa10Ga+bkI9jjCzd5p0/YAQOyEK839ChAEIIxMgKzaRxym51E7DsVp9Xf2rHlME6rTe8rOKXsX57IZSV13BbCSjPNAyHnIoLtMxpaPGG3RZINnC3TklIy3YV36GOa4OUJJslN8Vt9uCULR5zicBF7feSvUvtnm8d/UBL8ilXWAMcmImu3v9wqSsf7Aqqnlcm/gPzCvOGovqS9oAhoCnPqILrxLc6OYLGDfLGfITBQjgOElVwCfm0a5H0L6XcqPVpc6PfCBMhmRE9FyABGcr4NoNlcqWS6fduw0DvRWKMkpvWMmajf10YnlGgEJUcDEv19s+Md5ez4pVF99yg4ln0pi+kHj5d4W4HPQt5T3/U7rn6eHHYIhVNcfyxCEuBFLh2lo70s0s0qSVtCaBHJ2qUPAaTZUD3UI7MRe3roAg5Ob5xoEU0UGWCIZzhBeXjD0GiqO3KEQdim4oWuTusXHbKeNsd1EYjKqujjTZOl07qSf+rQAqR/fljcEOWHny+83O0VGiRE83pavMzi26axc1XTWDk/3L97QlVWX7ay+zl+CGl5OkaYsRI7Qya29Es2DA7VcgJT1W7rJ3LdTBk1cGG41g20T6jRJf5nuYqfcRYAQkjqNSInMj8g9b+jgiLXGTraCy8UmvqQcKxl1wxMsF/NwxdpJdztQAVi2Y7oM6dAHKkVwCMXBTGqDPQZhq9XMd4TWfAn1TiGvRUY7GydExKbYRbNSuWv0vmYNoKPES0B+jNIUErYj1PL+coh5g7d+xkWIiLU4PMtVFRTUWVFO86twPu3TVKHWjIaYw9BYT0ksoJ+APczsy1
 u6aLkfsQ
 NUNrpXnTjRGSh7u8k+rFbZ5TxIghVD2d8cQJbUIPRdrpzhCZwmRja3akWNJB8sadU6SCDRbq4cFsPnzR5AnS18Ke+AACLNwsOFHez1f4kJ1Zn9/ipH9GicpAjmtroTpB17TPeByxVzDCWVJ6Xe+IVu0QzkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_end_dropbehind() is called from folio_end_writeback(), which can
run in IRQ context through buffer_head completion.

Previously, when folio_end_dropbehind() detected !in_task(), it skipped
the invalidation entirely. This meant that folios marked for dropbehind
via RWF_DONTCACHE would remain in the page cache after writeback when
completed from IRQ context, defeating the purpose of using it.

Fix this by deferring the dropbehind invalidation to a work item.  When
folio_end_dropbehind() is called from IRQ context, the folio is added to
a global folio_batch and the work item is scheduled. The worker drains
the batch, locking each folio and calling filemap_end_dropbehind(), and
re-drains if new folios arrived while processing.

This unblocks enabling RWF_UNCACHED for block devices and other
buffer_head-based I/O.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/filemap.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..6263f35c5d13 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1085,6 +1085,8 @@ static const struct ctl_table filemap_sysctl_table[] = {
 	}
 };
 
+static void __init dropbehind_init(void);
+
 void __init pagecache_init(void)
 {
 	int i;
@@ -1092,6 +1094,7 @@ void __init pagecache_init(void)
 	for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
 		init_waitqueue_head(&folio_wait_table[i]);
 
+	dropbehind_init();
 	page_writeback_init();
 	register_sysctl_init("vm", filemap_sysctl_table);
 }
@@ -1613,23 +1616,94 @@ static void filemap_end_dropbehind(struct folio *folio)
  * If folio was marked as dropbehind, then pages should be dropped when writeback
  * completes. Do that now. If we fail, it's likely because of a big folio -
  * just reset dropbehind for that case and latter completions should invalidate.
+ *
+ * When called from IRQ context (e.g. buffer_head completion), we cannot lock
+ * the folio and invalidate. Defer to a workqueue so that callers like
+ * end_buffer_async_write() that complete in IRQ context still get their folios
+ * pruned.
  */
+static DEFINE_SPINLOCK(dropbehind_lock);
+static struct folio_batch dropbehind_fbatch;
+static struct work_struct dropbehind_work;
+
+static void dropbehind_work_fn(struct work_struct *w)
+{
+	struct folio_batch fbatch;
+
+again:
+	spin_lock_irq(&dropbehind_lock);
+	fbatch = dropbehind_fbatch;
+	folio_batch_reinit(&dropbehind_fbatch);
+	spin_unlock_irq(&dropbehind_lock);
+
+	for (int i = 0; i < folio_batch_count(&fbatch); i++) {
+		struct folio *folio = fbatch.folios[i];
+
+		if (folio_trylock(folio)) {
+			filemap_end_dropbehind(folio);
+			folio_unlock(folio);
+		}
+		folio_put(folio);
+	}
+
+	/* Drain folios that were added while we were processing. */
+	spin_lock_irq(&dropbehind_lock);
+	if (folio_batch_count(&dropbehind_fbatch)) {
+		spin_unlock_irq(&dropbehind_lock);
+		goto again;
+	}
+	spin_unlock_irq(&dropbehind_lock);
+}
+
+static void __init dropbehind_init(void)
+{
+	folio_batch_init(&dropbehind_fbatch);
+	INIT_WORK(&dropbehind_work, dropbehind_work_fn);
+}
+
+static void folio_end_dropbehind_irq(struct folio *folio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dropbehind_lock, flags);
+
+	/* If there is no space in the folio_batch, skip the invalidation. */
+	if (!folio_batch_space(&dropbehind_fbatch)) {
+		spin_unlock_irqrestore(&dropbehind_lock, flags);
+		return;
+	}
+
+	folio_get(folio);
+	folio_batch_add(&dropbehind_fbatch, folio);
+	spin_unlock_irqrestore(&dropbehind_lock, flags);
+
+	schedule_work(&dropbehind_work);
+}
+
 void folio_end_dropbehind(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
 		return;
 
 	/*
-	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
-	 * but can happen if normal writeback just happens to find dirty folios
-	 * that were created as part of uncached writeback, and that writeback
-	 * would otherwise not need non-IRQ handling. Just skip the
-	 * invalidation in that case.
+	 * Hitting !in_task() can happen for IO completed from IRQ contexts or
+	 * if normal writeback just happens to find dirty folios that were
+	 * created as part of uncached writeback, and that writeback would
+	 * otherwise not need non-IRQ handling.
 	 */
 	if (in_task() && folio_trylock(folio)) {
 		filemap_end_dropbehind(folio);
 		folio_unlock(folio);
+		return;
 	}
+
+	/*
+	 * In IRQ context we cannot lock the folio or call into the
+	 * invalidation path. Defer to a workqueue. This happens for
+	 * buffer_head-based writeback which runs from bio IRQ context.
+	 */
+	if (!in_task())
+		folio_end_dropbehind_irq(folio);
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 

-- 
2.39.5


