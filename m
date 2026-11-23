Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515E1606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Gy5v7eMu
Received: by kanga.kvack.org (Postfix)
	id 1C5DA6B05B2; Mon, 23 Nov 2026 00:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174266B05B3; Mon, 23 Nov 2026 00:16:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CBF6B05B4; Mon, 23 Nov 2026 00:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3A706B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:16:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68B29407E9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:16:56 +0000 (UTC)
X-FDA: 85465224432.04.7689C35
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6483E1C0002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:16:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gy5v7eMu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795411014;
	b=BYU5HbL4NmzuUpldv+iHv5JLoLFG8SmEkP4g1/1QF7DUMeaOVdY0Xvv0Ddl969oeauIP9s
	zNuycKr466E8JP66fhXVPjtCfowRW0oDobZzsg2pDRJ+RPlSq4umQg33rSIrLYbK5G/fi9
	gznttbrhiijyun0Xg19QjlFX+AH+3/c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795411014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUa5uKi0VrDw4UA0BAsczrZyFuWjUpTgTE7iF1Q00ck=;
	b=vim33coPuMTwDjuGI9awTxouz6KzDZ8jNqac+gDnnUQEr4KAIWCSZ1C2b7G0iYDA4aov48
	qJdQYOHkCN9bhhJNo8lm34h1qzdHc/ciO8p1u2I/HawSUxE68AIo8loU97nqDZVaejJYwq
	NzBSV+GT8wb5avIQTpDRNMTZqaR3+5w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gy5v7eMu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AmAm6mxlSWJGoWywt8mEuBAs99e9NGK1yr/YzgW36PM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795411012; v=1; x=1796015812;
 b=Gy5v7eMuVNiwKNAU0qe4b0M+ZZLrCetQzCratijnkzmImjJoHi0R+kZLN3fMQ/s1bNaA90eR
 Ze0MDNHFs0+rdS9WIgYSidMwuSqsPF5CMxe0mXrMwcJCIKOUW7sHgnNdeOn8UY29RxUEWn+4GK3
 xBmr3992nPZ9kVVioNUkasx4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d908d048c329c710;
	Mon, 23 Nov 2026 05:16:52 +0000
X-Mizu-Trace-ID: d908d048c329c710
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hughd@google.com,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	andrealmeid@igalia.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 1/2] shmem: do not inherit FS_CASEFOLD_FL onto non-directories
Date: Mon, 23 Nov 2026 13:16:28 +0800
Message-ID: <20261123051629.2547645-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123051629.2547645-1-cui.tao@linux.dev>
References: <20261123051629.2547645-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w1dp5ggp1mpk86k55w8xfaqm41tnn5ha
X-Rspamd-Queue-Id: 6483E1C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795411014-476510
X-HE-Meta: U2FsdGVkX1+Fy9Kgw8mTuoliPL66MR+tearr2DjL1a5tV87NaEsYVmP9jLbP8vVqfHDSCXs8xByghowwxJOxclhFdifClyXsRZdKV1mt4q4iCSQ4PtIy1fhEHEC8/eFTovlJbtE1mcj5SEXhJ8lGexgGnRkT7hOzsscAxqmVqef4BMBweELLG+cFKUTwRF8tMQn7EukjUKLmA7tgmg1Y91IIV3HbKuU9XO2VV8zyb3EF/cGIQ4yi6vChrbNbX0OkeN8av9fTqCPj/SYFv7i7KOoyBaGkNPSDo5pIfpmNErUYezjNKOwse3wiQm1qauKQ7X0XuPZLjes8/8u+L4FNX2A4Lc2aXLEycsP8F0/RuYHIh9ON3DcJaafHG/FQYUi1OXnd3dhPr72orP8i4Aqr5gDe7znpXjh9NVqwuW3VXnYSIRdrNXrazzUPDHvaj/adnhKRlsrGJyqakNchDIXAdupDk2O1FIgaNHoVlKB2qaovHfJW5HDZ/8i9eIZEaQfIaXboF1i+hRkP7rBxMcBZru7NjW1lVYgRAc4vQ9jHYUcK0FUWcm4IZdgCTjVNCD4/NIz4nR1AXH0/gBPJRruvpFTC6tHd0uRpARkPyUk4eLsgxIN686cSMZ9B3nCN4VQ1JKb1xOQe2rqDZVmmoZu3vG1AumDYnI69TtMFZITBNkGp2hs+S1FOtqmweMv5v3McDNYyCT/rnRjryF4z0UwQagIAKRaZtGM1l6gavnpZbc6lXywp+lbl1cp9eVI3NS5uH+7s0IfqJXiIP2dtMoI+Jo7U9qHX7SnqiAs/rXjqYX86p86e0mkZ0i9FxeYDp5LV1/AO9mKdwRGUZ644+Myzr3yG9x0PvqBOy1h7f5zYOgSIShG+T0XyLe51KhyrNaYBs6lSyvRqsmiMLQp4sNWftY9gJyegWxt/NlzKPN66cABKAuqDzDyHcQmpwJD+vSlS+slGFc7csWb7G3cFyWn
 XuuPwoNz
 w2ASZuXpNbGj2VQoNa0MTE1xFS+Yd9Ak9YPW44G4zm9DGGskhFhOJkgUaPy8ZeKlN1hb8ki2pVs4CKbN7vqtt4oRaPqC6AMZ4RDkQZEmQjprkStXy9uYqvea9kxHIx+qcXb9NH0EY3W1+6LqjVvveNq7PlHDudkBfbJApeG9OdN3CAWZKtS4UvJTDdNZHQLAWUyiswC4Px9C8o2bAIAQJkhXGj/6zxMCB/HdyVYjzmtgPS8b2Pqh5hIwom0ieG+AGYtS1RifkrMVchYoKGvyLnZ3n6gRwctXBY+beAnY9KETq93/XOHa3u+iP+eYQ2gDEE+8K9DtNM8ybWcoajACh7uo97rm74TMznCnrIzjboY12ZUTD9ePyWZ1HqltWq8Bn1MMZ9BxhlS1bGufXKzpBS02xCb1JMGTrwjCYZB3k7eSWUYsgQZ4h8gr+s1B636VRj8A9GusvN9YLmOa/FPCy9k5yRNAO/zcUNgf4GJ357LlM3PM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

__shmem_get_inode() copies the parent's SHMEM_FL_INHERITED flags,
which include FS_CASEFOLD_FL, onto every new inode and ignores the
-ENOTDIR that shmem_set_inode_flags() returns for non-directories.
A regular file created in a casefold directory therefore reports a
phantom F flag via FS_IOC_GETFLAGS, and chattr, which writes the
full reported set back, then fails with ENOTDIR on every flag
change while dropping NOATIME/NODUMP from the same request.

ext4 and f2fs mask inherited flags by file type; mask
FS_CASEFOLD_FL for non-directory inodes here too.

Fixes: 5cd9aecbc72c ("tmpfs: Add flag FS_CASEFOLD_FL support for tmpfs dirs")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 mm/shmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1ecda28178e3..46e30b1f5ab8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3321,6 +3321,13 @@ static struct inode *__shmem_get_inode(const struct mnt_idmap *idmap,
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
 		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
+	/*
+	 * FS_CASEFOLD_FL is directory-only; mask it for non-directories
+	 * like ext4_mask_flags()/f2fs_mask_flags() do, or the
+	 * shmem_set_inode_flags() call below fails with -ENOTDIR.
+	 */
+	if (!S_ISDIR(mode))
+		info->fsflags &= ~FS_CASEFOLD_FL;
 	if (info->fsflags)
 		shmem_set_inode_flags(inode, info->fsflags, NULL);
 	INIT_LIST_HEAD(&info->shrinklist);
-- 
2.53.0


