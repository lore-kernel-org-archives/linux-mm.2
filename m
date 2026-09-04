Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A37C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976DA6B00AB; Fri,  4 Sep 2026 11:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900AC6B00AC; Fri,  4 Sep 2026 11:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C81E6B00AD; Fri,  4 Sep 2026 11:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56B146B00AB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:13:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDD1140173
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:13:09 +0000 (UTC)
X-FDA: 85176422898.27.39DA132
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 39AAC20009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:13:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gS8SMNln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YTDhqWyU63qquth7ntQA9BiabBhfNeU/n3wjNRNaWCc=;
	b=2uKyYxFrSLfqgoC1lWERCAZyUmLsIlQ4X/VllA85v5i8lxuwVygZeWWWOBWIpK1lDeOUS0
	CbU1mITArDWSU9hV8KtaRYNnc05XqMPsy8A18DHR+iy1fN/yMgZTRCcfBtGzk3aZFCEePb
	DefrvK9ya+Rg+mignHnh0Ma+hF3Jexo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gS8SMNln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534788;
	b=ueQz5rL+UKHhGR6OtLRTXNElcdsf4Db+NIlmwbhUyncEAV/PNFtEzNUbUjDJ3Q1OUydMbm
	hroBFuz4amzNhnAfvEIV7wUcHKSaK9iSsTjBvr4axcZXGtXtou+pn+zmVNFogPPFP72uBS
	NClNLirdr45MyWyekWuOgxNV8YlJp6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DC1F600CB;
	Fri,  4 Sep 2026 15:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D08D1F00A3D;
	Fri,  4 Sep 2026 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788534787;
	bh=YTDhqWyU63qquth7ntQA9BiabBhfNeU/n3wjNRNaWCc=;
	h=From:Date:Subject:To:Cc;
	b=gS8SMNlnyBJwyDzDX8NtqkSCNTK4xkoeKOCPQuDtlyVCFYf6rYD8kz0s4kFo2o5zq
	 I2xZLrCjbJ7ZadErkGTUjIg5VsYNd2M6a0O39W2bSyNi3JxB5emRqrRFuAuXRgH21l
	 19Vownn4M/4cBuAP2Tr6DTPDkSuzWY8dZu6SvQ0PWgCl5/ywYVpjpAhWqZtI2Hxhdq
	 qU85lOSH5pcrobw2QGe8H5pQbWvHl98R8m/ir/O3Dr8I41ZmVHzqA73GkDgj+OiaEx
	 fOLsK7UNkVp7nS6hsFPDjP4qhTQcNvzpBqWERrepvcCadG1LYlVv+DOcGk5ujpNzQ0
	 CScblm/h/YzUQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 04 Sep 2026 16:12:53 +0100
Subject: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQqEIBQF0F+Jt54HplQ0vxKzkLzVg3JEw4Lo3
 5OWZ3MuSoiCRN/qoogsSf6+oP5UNC7Wz2BxxaSVblWvDG/WZT5kXdkDrjBwiJLtDq51AwM9dWr
 sqAQhYpLzzYfffT9GuzzMbAAAAA==
X-Change-ID: 20260903-madv-will-need-map-private-125e3e2f70c7
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Mike Kaplinskiy <mike@recall.ai>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1694; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1c+ecH8uuNYp3IKgpKgpW07tV0l3TB+x9EGP2nGu9ZI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJm3f+3guFgy/vda766BCzVTUw7GKH9uXvt8upur6Cyi
 5dCsln6O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARn02MDE+sf7/kKp7qcblV
 b4Xbju8bDJuZpTdbvmC5VdXh927RWyZGhgWzjs6/7Dd1qll3pdA3Ab7mlb/VBI5/lZzJ/XzL8i/
 yO/gA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xis93974dgrndww4ypk4jbea6utbip51
X-Rspamd-Queue-Id: 39AAC20009
X-HE-Tag: 1788534788-214389
X-HE-Meta: U2FsdGVkX18Jb7+yPYKGkOicz5Z11jcgBzsBRgdMr7gEfxGbrInp6Q6fm8LATXFBwvIu54I9RhQv6LC4WMG5aOKFf8K6m5BpZRv2bTZEN0w/ENjppym86DlxevZfe8BMKe3BFDdIPJndSnzTLk0Tyz/UShbkOyfyUiQPbaYrR1v84XiVHWp4Xrqp+i61nbujjl8HPq99ZjvCwyHM/8ZhtPtRcthH19a8955jWc74nJPGeTl/wytHhBzL+xSIPx7sw7UqNAAaLUg21NY/SCKWaYKj7W6vWMfDM888u3mfj28GTlaFiDv6uaynnxmx1fXc8xc3LqlRXOoTpourr6j6cJ9pGKl17ZnIOug6SxPf0G/yrs/KqSl/GM78fQLV38yjqUUaTtsudLjZsX/OBgEv/DqlKLWatY0sezG508sq8VRJLyHVL4/2cW5buMUjhyZUjtXfSQ/WTQplloJfMlVrBuUgOMo8JoTjp9GWkXLeFYO7qI/Jb6cV+Nm/kyBji9vDtQtjBvJBRmRVWzIouoAyIvITUgfdL1V7IN190KfN1im/FyjYM4EL/+STV3ENQASd5jE7ow0tm+9uNvtbGyRVvyyZ0rFZuFHRHYcppwqkYdJC1zWGoK79DdIS4brBTNAQGAIg4WvCfv0+9KcOb7SVD/lKG71C0pqJMyRfZYW5u3ynqGpqjnIh4oT7AuhFVWoCQ6YH5egbaVfPb3DsFvfMj8fM5ACRMZUORbswHAazaK9YYBW6uNOiJSl6lg3mYqlHvpTJ7ZUjKRrCun0f61p2NHqVDkfNJYUpei4wfiOS/c+pdS4k/8fMwQbbhVncMxNYAyWt8oxPQ529h6NkTi+hNYlA6z8WF2lBLZcz+Oiy9WocZsUM1fCr1ry8dVyiEAsqqlLWeZBWxIeW1vcTJLd/aU9wj6QCbdAvIWDl9bfPe3TLHgiMJJD8TrgpoBCkJn5GHJDTTzaX0LOrPMpCicN
 PIY/XVEK
 CiFd0lN/Ev/Zmjhj0nCxUutOtG53/+ePmTn7V6FFq2WpB6pOxtgJ0txIyu2roJNwWHNc2qxo6oDEdeRFcIs1g5NuxBbcL9CHrWmyD7HUH+eb47exa5tuxBPyak3u1389N/Gqm7J9l029749RUb7g1F6IKFqxbnVzNVAIL18eyCbDYRju8kTuNurgmKICK02da8y5ZTdiTmJju+6V4t5aMsHPzHR0K+2d06CM/5kr4BGjToeHp4WI0SC5yaD1m6Du0oD8DRVAK19U/4S1YFbU06h5UQ7ZxZzRNJiRfUprPcSqBmjbC9nFZNNmaBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
for the former and a tree walk and swap in to swap cache for the latter.

MAP_PRIVATE-file backed mappings straddle the two and currently get treated
as if they were purely file-backed, meaning any swapped out private pages
remain swapped out.

Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
mappings and performing both walks in this case.

Since the logic checks for vma->anon_vma this means un-CoW'd
MAP_PRIVATE-file backed mappings retain only the single file walk.

Reported-by: Mike Kaplinskiy <mike@recall.ai>
Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adb..d0510dd49dde 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -297,10 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
 	loff_t offset;
 
 #ifdef CONFIG_SWAP
-	if (!file) {
+	if (!file || (vma_is_cow_mapping(vma) && vma->anon_vma)) {
 		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
 		lru_add_drain(); /* Push any new pages onto the LRU now */
-		return 0;
+
+		if (!file)
+			return 0;
 	}
 
 	if (shmem_mapping(file->f_mapping)) {

---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260903-madv-will-need-map-private-125e3e2f70c7

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


