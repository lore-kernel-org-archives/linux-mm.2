Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E09D1A61D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABDF6B0088; Fri,  9 Jan 2026 08:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962FD6B0089; Fri,  9 Jan 2026 08:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C356B008A; Fri,  9 Jan 2026 08:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73C366B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:32:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A0D3140700
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:32:14 +0000 (UTC)
X-FDA: 84312514230.17.554656F
Received: from out28-99.mail.aliyun.com (out28-99.mail.aliyun.com [115.124.28.99])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1951180006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:32:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=Usj2yAlP;
	spf=pass (imf24.hostedemail.com: domain of houwenlong.hwl@antgroup.com designates 115.124.28.99 as permitted sender) smtp.mailfrom=houwenlong.hwl@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767965533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vjbCs+Tbn7fqSeAHdJK8sFAOmv8QqKu3U51GXVFpxco=;
	b=mQc7Hfw/9w0jwIGvG+XSDcKJJ2NsT9wzTf2CbgzFr/KQMmpag9h3OvW3b3P9AK5rcAfDVB
	fm5lSVb5A4Zbaotzj09Aayf5CSnuSFKzWSQA3j+hB8eTH4jliK/ZPkoyw1zPXRRuls5hET
	vYavEJAzM4Ay/e6omZ3n5YpOeF1PQd8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=Usj2yAlP;
	spf=pass (imf24.hostedemail.com: domain of houwenlong.hwl@antgroup.com designates 115.124.28.99 as permitted sender) smtp.mailfrom=houwenlong.hwl@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767965533; a=rsa-sha256;
	cv=none;
	b=cKAPYfUiiKteh4IoVt0Uz8rCsYRepqjSmlw4OWBM87OQR8DHHFW/ztEIi8xDqvD5/wTAna
	ApVhBC+fwqYLq1uiipotEU7p9n4nLAL/n7rqJf1FR3qElc1sLM7txuP95GwvVWqjDpGg/u
	SE2TlaSKwHCuX8Zl9I3i/vteAPDLhS8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1767965527; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vjbCs+Tbn7fqSeAHdJK8sFAOmv8QqKu3U51GXVFpxco=;
	b=Usj2yAlPlNq/u2V/G71XePJEYvEXO38WchQT5VFPng+sJbjaYlGh19/0W++E81P3yDwTjokEKVy1HRO7G3m21O68CbI2Y4jpH8dpeoY+HcHJxmbLdb/9Wkdq2k/oVb5/obEDm7MWEcTwWVaT42o/oDJrqFU/+MS2Qb3h5E8PGgQ=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g2TRMK0_1767965526 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 09 Jan 2026 21:32:06 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH] mm/early_ioremap: Print the starting physical address in __early_ioremap()
Date: Fri,  9 Jan 2026 21:31:51 +0800
Message-Id: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f5r3xu4xs4wa84yk4tz1cds184mhyq4a
X-Rspamd-Queue-Id: B1951180006
X-Rspamd-Server: rspam04
X-HE-Tag: 1767965530-157297
X-HE-Meta: U2FsdGVkX1+O8pcmvIoyZxrWM0+Tk+tCveJuT/ZLL4rAhu5IoAfoeHclibGhHZe1Rk+J577+Hq+ovAZKE9uUNa3ZInxwXyJqW+7Ai3SrK+KGLPLd5/ezOR9iEu2zNb5GmqCbNnL8Fgjraix6Q2+DwJoTLXwu9lTk64afWw6vQmJ6Tvhvp8U0fcqCQbd926/my5rfrRjktq60umK+eaNfEaVfT814Zy7FZLv6/CiHDB/6Da6Rx9PO9tCvgS3gDxqwyHWhxwCVI+mG4Nf3UrqrxNx4kmn/FTMpbH9gCaVAbLHoW1RemcwTIytx6DbaCCXoNeTmEog5lFnHnsxsT1f2o43ouhuVmvfvaHz5I2dESkqd6Hfd4Wp064flElXMgUkTidjqQJ7Y0Mg53jhZ10WpD0YRw//BCjbdM06zJ2nk0l/CXKgVLEhuCotYYsDtAqcFjpGZKgeE8Aq41GpAm52Ei9yxCF/Ngk+yWpcHXDygqBVCxSLrdQFTs3BARewbCnjTh5Rhj21dErsOTOog6CQRx85UbzJFErcms7WgGB/AJtMvvUOwhwxJ8Gsd5BmjjPpj4cL7SwM7oW/F515AArKlO99eR1tF653+eS/T8ap/LEqNBpta4BnNDjYbmJ+5yXVqqsdlrN2J27I706Dc3oAeNZbAM6j54jDzDbXoDv6JZqeQNf1vHBDJhT5i2CLcloihbyYhV6s8j6ij5nKKzFOVWhwpqR6g5tqosdofA6xfv7LyghMct+DgH0HBb+wpIPWrLab1c4ODKW7agAFJpEkBbYejFiiym2XIWA61sIDgL6y110UQpeTN+iuOzjI2AoTj6z/dhS4ot8QtnIAxVu1ec8hI2Zdu6PdLx4Zh6bPk/7ijxcIgHyGp1G3XJUMPVjW04wTV1nzVFYFrdzA3J+XLzZIa/UWrJdXIMQ+QBY9xdcVUdbWD2mImEzXd/+6dkXO1rBlgSZGnfqA4tHuSDSO
 2pSKpOu0
 Fi4ZlQAJbnskRXzhr3e9eo/8iaApm/pM/9VSP1V6F6tKHZkDyE/cOm7dgrlNNiBcMnpkoHcxeVIg67Ti/e8TiIb3nCTtPSO1bun1KfJdSgKFSxGafVYwiHYIx2VGY/T3sPDoqd3VTeTinOV2EOxZerSPO+WS9u3EjcpaeX53HFHdoIy28Qj7cL9FHbQTHj98s/HTZwRCEXkJ/YD846Uh/rmC1+vj2Rdy0BP+I4k1KuwZibFKTPRn03324rdvNkr67a7haf2FTKC776eiJV3ski9I35DXfmdJDrBNQ4yxJ8MiPDJiOOBSdCYZBYX45/0ENFHsr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The debug WARN() printing occurs after the while loop, so the
'phys_addr' reflects the last physical address rather than the actual
starting physical address, which is not useful for debugging. To
simplify, the WARN() statement could be moved up before the loop instead
of introducing a new variable to record the original 'phys_addr' value.
Additionally, swap the print order of 'slot_virt[slot]' and 'offset', as
this will enhance output readability.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 mm/early_ioremap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
index ff35b84a7b50..3fdde074c9da 100644
--- a/mm/early_ioremap.c
+++ b/mm/early_ioremap.c
@@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
 		return NULL;
 
+	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
+	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
+
 	/*
 	 * Ok, go for it..
 	 */
@@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 		--idx;
 		--nrpages;
 	}
-	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
-	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
 
 	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
 	return prev_map[slot];
-- 
2.31.1


