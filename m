Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BC06082BE1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HTQPXr4s
Received: by kanga.kvack.org (Postfix)
	id 551266B05C3; Wed,  4 Nov 2026 08:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528F86B05C4; Wed,  4 Nov 2026 08:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417096B05C5; Wed,  4 Nov 2026 08:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20EE46B05C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDB6E40726
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:40 +0000 (UTC)
X-FDA: 85397450880.27.72E6ABE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BEBA112000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HTQPXr4s;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vv/svtPtjalr0x/FT//NZi3aKSPK9q9fUmUPJz1NOWY=;
	b=FGZGWIy+hAqqI3qT+b8A/57Q2057ON8O8XD5Jy3DxmeSD0PjjMerov/hfd8UbOz9bhcsvK
	Pl2YWNF0bOQB1ZzuW/0zDOQC8v8AQCHeBain6fVH7q6BiYS8tRnpIFf1AQ/WtPXYdxJB5+
	R1Gnd4/TH9yW7UvK10LkWMow9JSSM48=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HTQPXr4s;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797358;
	b=Ut4xiHt+2W6mPrgk0sQXs4Xw6KU3Qz+5zHK26giShxAYdJ0zXwhYT8U9Le+tBUnjTrObCd
	/4KsS8qbIfaicpW3+P7HtWHITkOCPywMSWap2yBeL7DWRjwTvKcsaaWXcOQZvc4MVttRRM
	/Mx/aPFhOqaNkM65ZWhyY2NNg0T1NLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22FB04051B;
	Wed,  4 Nov 2026 13:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69BE1F00A1D;
	Wed,  4 Nov 2026 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797358;
	bh=vv/svtPtjalr0x/FT//NZi3aKSPK9q9fUmUPJz1NOWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTQPXr4sD2/5Ui1D+Fhep6YcWFwNRN/V3imz+2TUGGT77MMVeHICrkoLK+tRSJraB
	 7+99medGbnPsVsOLmkNwO6U4CbO1FrlCpDiz35at2/hn/Jv6/sQZ6rScrFLNnEY9Tt
	 g6lIjgl9ZNCWVcIZm9X+riin/zRbc9GfPmjJ0mAFcpxXmPnCymTM+dqCpSdG1YKXvq
	 4Yo2JayYCGGWyvZwFquS9yxRgo9bYbIGOJcpxQcZNfzhqMEGi35GFiMBOgJKH1/6qk
	 paF8ABo5GuRAAeSjUDt7zykP9LZNd58FGgiYwAsX6OIBl2IMI6Rp4rNGIj1I0v790c
	 Z/teP7dpVi76g==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id AD0181980054;
	Wed,  4 Nov 2026 08:02:29 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 04 Nov 2026 08:02:33 -0500
X-ME-Sender: <xms:5SzranlD4yipwHC67kSzCjVzioSdAt_fcuUh4HelGAp02GkQoL3Y2w>
    <xme:5SzragGEy28L1f8IFaQJlveL3NzbUnlO38CjP_62tN-ZFd4nTs821CzHdsHhbhC5n
    fPKngmn38l7BPTugr6HDYcKwPO5vc-qrnUHR0clv3cUeELR46zt9Y25>
X-ME-Received: <xmr:5SzragRqeCVmQ5RWjKdrZaaqIIKLKEp75DJxBBjoVGJjQmoocJBUUa8G-Ok>
X-ME-Proxy-Cause: dmFkZTGcnWxWNdwzviArTqwO8SleswujEAoF3G5cAnzgWuj9VIXYzVn8L/YtSSoCVpDQCx
    AFAjkaMBKJDECegKseyQPi3BoJ2ULdzgEWHQh0kOOdV3qcZ96T5qYw8zvnYBduU6y+7gOl
    ju1hRqdfaUd029Zpq0M1QKVfvNYpVJXA03mIXM/FVYF2n1TVZdGxcwDBil6kVRafbiJtv0
    QuPNDwYksKVrYzT4QGS7HIxmz8ayVgiPQk5G9zoQji1nSBMTr/zV+0QH6w0a9BT4L54N+d
    cRhB7KhKgiZgmWNJc1G8l9d+gvjQ75B75nEIsy2loqzEXGvtqjUcmfJ5UhZu2fDzNX4RE/
    4NterOEAV5G9AyH78TaNMwJDSrsHkVXYhC14lVODhlcfqOzYRFLhIHdmP+oBMTDVen5okq
    50ie1MfxvtcSQRGWnFHUt30oIHJXEv7ihBJT2RCFrpaRsO/nJ4cCDjPWp1YpK0EKxfeJZH
    cOrAddTXddbA6c219PzWE0glXtryq6S2/RVaR71IhWHgWaBrePtyit2XicrSua4+3zBbXW
    sA1UEghV0FqAHEvS/sJG1aiF76j/nCke6PldcAVbImCwu4MJmIVHAWs1XEbXcHSLHIAjd+
    orvKs1f1ymhsm2t3vTqwGjhIg3jZ7XiV/v30FQITVWOyrc0vDYOTkhV5Hdfw
X-ME-Proxy: <xmx:5SzravTX-xgqZi4zw8j46ra0sDAduHU_n6CXfzpDX_8lBRYVw64Oqg>
    <xmx:5Szrame5SEn6fHCafDskZJyXz3Tyz-YZ3ryF8Js7XXZmaxMhLT_JkQ>
    <xmx:5SzramCN1gxO9rz9jOzf4USeLED84Bfip6exWLGzjMaLwm9_J9EUdg>
    <xmx:5Szras2rXhYvmOXzPA3hUAMRjZJSpy9P7a3HCffv-R8G9Z374SJ-DQ>
    <xmx:5SzrauSZgH4kYB3T-ggHWveiZMUuVIojGPWTzg-HT_jrxHz3F-V1CLMz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:28 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 11/18] mm/filemap: mark a folio accessed in one place in filemap_read()
Date: Wed,  4 Nov 2026 13:01:07 +0000
Message-ID: <20261104130118.2507513-12-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8k4nkcdnynae8r88zoe91gnoq1oh581g
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BEBA112000E
X-HE-Tag: 1793797358-830739
X-HE-Meta: U2FsdGVkX1+FY8NK7RtKDJThEjUVOH2ehG+j3nEPi0ZbNbfBPI0017tWcBuAHEqusC0EWH5gLd/RItTbDM9Z4lEeuiuuWmEGdOaMLfebpwwRu8Uz+X86EGNkQXAFC9OXB5lsgh/6Ip9aH0Wl+hsO/UxAYjASy+d0wOjeNdMCyPQAr98ooVSVI2EsJ8VRgN12rO25ADjPPqSgaFiMXwVz0qC5tuGUvafbcsYRwIW19+SgV/pXs00HxYFzKBJJWrTyoh8atF3fcvzeRq9twR0cPYTHFUlRhqMpKz8aXzAYZwcE8YXxBNe7kMza3ROVi60q2rDrRmt9SY0yudy0UOvyjpDawdkbFMbpjKXt1FBPuDktvGQPu2PAht92xGi6fTz2Jo7yEjen5X7DwL0hcCKWOkpTx9tpzYyw+6uj6QevC8a8/8r7q/90l/hHkAWFYtxt+KSipfRzSTsXAYJonz/fVIZXLWi9a2/k/FNfnbHxbODEPaGDuNOOKuxObme1KdjBXXWxTh/6bpb24Qq4Xz1GF4XAZyPEFPX/huNDTlTg0h2P8nKCW/xnJ/Q/cTb98D4LPnfN8FxKLc2d63u1m8ZqqGJwuwgaqNTPkWFMMHWDt67RuwxREiysfmI0H1D40JMv3JWLidZlheY5eMNZag92Dv3PhVcRfQwbezuGjn+R1cKLepmNAMcUpDegMQtKj1k+ikKdHYqTkmrx0XRQpZ41nSJuNrjMDwq/l2sxCiyMag5K985rZvzrb0ddgZ5XpshjWSY/mz01XP93zcoZ/L6pvdoMMbf3eJ8NVZtO3vAVauKB0ZoSD8XlX0sgwdjJzpXJbmypEJkpfhP4d7XArpqt0npG2n1Jd7gvB8fLQbcqjZGe0P/vBhcjw/ZDQvJi3Tkjq2z0NmT+2mj1AnCdkYUdUR05xDZrbRs0Dvj1sqb1ZfR7GPr2RIzA5FOLQ1LHnEcuE8qxaKKqS+CPjl63SaB
 trPiotHg
 SugcEKBrenj/EZPPDGE19YFtGPEb8xVqKNY0OKFwDJsvv/O0GQKdI9B4pjAq+MK1BzJUOPs7CJ4lnEiSUd1+b8ssNxZ8l/XrhDz0LcY4ho3+vsIIZPOcFLbTJKz1aixpZxMnrMrpPL0lQsedIWKTRg5wKsJpXOMsK+mvpKcQ8xyXAANP/SYt0m5HmJc/D8B+k/IocDQZZxKc0lWnK3aKbphiUybW9iqpNDVjXsuRig0/JYbF2Rb+nyVizP1/5Z1Ntd7oJrfcTsejBQdFSGf5kFzHPwEL1xdqG9ZOmX0BZWTpWSjhtviyV5gKGnKKqkAga0ZGFIisR9KlIfkGa14zSVWKk+Iuu75LoNEtZ2xN47EHUZoIWAF71rdopeTy5twGFGJ3wWIMxjxD2lX0iTL0Mnw5FyNQ4F5dGPzoxy+pDoO5neReKe0TG1rGERsqprRicGUpS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

filemap_read() calls folio_mark_accessed() in two places.  Before the
copy loop it marks the first folio of the batch, unless the previous
read through the file ended in that folio.  In the loop it marks every
later folio.

The test made for the first folio also says "mark" for every later
one.  The loop gets to a later folio only after the folio before it was
copied to its end, so last_pos is at the later folio's first byte and
pos_same_folio() is false.

Do both in one helper, filemap_read_accessed(), called for each folio
in the loop.  For the first folio the call moves below the test of
end_offset against the folio's start, which is false for it: the folio
holds ki_pos, and end_offset is beyond ki_pos.

No change in behaviour intended.  Preparation for deciding in the
helper which folios are worth reading without a reference.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: shorter changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..3508eea44ad9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2759,6 +2759,20 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+/*
+ * filemap_read() is about to copy from @folio at @pos.  @last_pos is where
+ * the previous read of this open file ended, or how far this one has got.
+ *
+ * Reading on in the folio that the last read ended in is not another access
+ * to it: a folio read in small pieces is marked accessed once.
+ */
+static void filemap_read_accessed(struct folio *folio, loff_t pos,
+				  loff_t last_pos)
+{
+	if (!pos_same_folio(pos, last_pos - 1, folio))
+		folio_mark_accessed(folio);
+}
+
 static void filemap_end_dropbehind_read(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
@@ -2844,14 +2858,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		 */
 		writably_mapped = mapping_writably_mapped(mapping);
 
-		/*
-		 * When a read accesses the same folio several times, only
-		 * mark it as accessed the first time.
-		 */
-		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
-				    fbatch.folios[0]))
-			folio_mark_accessed(fbatch.folios[0]);
-
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 			size_t fsize = folio_size(folio);
@@ -2862,8 +2868,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 
 			if (end_offset < folio_pos(folio))
 				break;
-			if (i > 0)
-				folio_mark_accessed(folio);
+			filemap_read_accessed(folio, iocb->ki_pos, last_pos);
 			/*
 			 * If users can be writing to this folio using arbitrary
 			 * virtual addresses, take care of potential aliasing
-- 
2.54.0


