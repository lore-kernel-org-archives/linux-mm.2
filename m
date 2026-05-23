Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 739C7CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF7F6B00B6; Sat, 23 May 2026 13:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D973C6B00B8; Sat, 23 May 2026 13:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4256B00B9; Sat, 23 May 2026 13:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBB856B00B6
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EB84161B42
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:49 +0000 (UTC)
X-FDA: 84799440138.20.211458D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E482640003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7xL6A+P;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779559008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZPGEhDpFGQ4u9PuMAl3Sd2ga9kaV9qTLPAdSB24HI8=;
	b=t9zEZFKTbCmZfWO0NxbfJcS8ubVYFXlqF/57rwSjJ1Oh8H2l4v/wG2LZu1UUs2X5TEwUWW
	MRPsUJTfXcrVMmUXrIwVWZ8hD9wbR3hO9v4NBidVEOlewkkGTVgEVGVLip+KTo5N7Y5r6L
	56dEqgh8nizstEVVMpI/5FSb/dosw2w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7xL6A+P;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779559008; a=rsa-sha256;
	cv=none;
	b=YUPKUYi2t1W0NAff6v9WiU7SWMYkNwPOtlu95+US++daAE1sN86lrQfVO80WYDi2DoFsJs
	K6q4Ltjp0QoUxhP8m0YUM4xWndI4XzmlBfDcDKCK5RfTsm1x1xhDmQ4LboUUoMf1OFC6nk
	lyj702i3EJjbANFqLCErcg/q62kT2EM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C67340B36;
	Sat, 23 May 2026 17:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251481F00A3A;
	Sat, 23 May 2026 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779559007;
	bh=4ZPGEhDpFGQ4u9PuMAl3Sd2ga9kaV9qTLPAdSB24HI8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m7xL6A+PruyXrPWvmsAoypMnFQsfwqCPeKuQPez0FgnKXSO06Un5FB8QHqDpQb4H3
	 8QknBb1CUFzuPKF4giiNNpeUdLdIIIsPnz1Ln2weva2frsm2ejuVEJ0bFmsRwjAxNu
	 i/DzE4LeSWzHIfmW+ns99umidgSpMcOIIIYllFd6PYxpQLLXwQ4XMKHOu1/fIaLcCt
	 zhdM2i/e3b8Ke1xmeXKtbBVQbZpbUhT64iUOlh5+FfVjeiu90PmDJCNxVosZZxEitS
	 O561RMw4EqfbRr+CldkljoL1KHUYKOwku2ScXQEPToGxFFI4OwACtEaaJ5nvb9VOZi
	 6JI2zyrKgrbMg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:29 +0300
Subject: [PATCH 17/17] bfs: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-17-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: oj93suoef5d4io9xknfic93amphtmmtj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E482640003
X-HE-Tag: 1779559007-915430
X-HE-Meta: U2FsdGVkX19DJI4takdrQ9ukeX12GEWNhslnhGPMaRPgk7aIJ9wGrqOkABPeflTRMG5ZZNZftCfSr5kuh5JYZ+2KR0baOq0Wy+8GLUte2vfZitbEzqfVSv6Q2crJzng4ZmNyNKk9yJvjLgGhde70Cyi3HdEXLKC74fCordmXvVimmvfw/j/8csfILg65SsGXdnCXZP0NV/QU5mTAXkyUuaD16k6TElsJFnmPULNvVfev1rYy4sHnpEpDtsrpQ5UrbaZcOTxk6Usqp0Qd9WdYKzKATF4NA98vhT7TTYsZ8nV4rkP5gKYufJbNxUSDAi3CV+90vKyC78pdX9FHEwuny8W75uGcbg6z4/3EY6HNi47T3vms8RBx0X+P7V6saw4MRacnH+nVyJXpJTjkMCDCHfVYWcCtsfHZOCuKaVZtQMDLN2wIoLmCaGiY1P9diRlEMFc4F5sw2O6Bc4UaEQudiUl8DnlHTVTr3U9noBueC0wzSdNQX+PLvPXh09hbyM5Hkj37/DNhjgGAdCgr0+hv/56zMWxRD368pqE1QGew16M1bKynh3VhD17KMbSMjiArCDfERUgBn/Obdzg7VK1FJG7dUSZZemJAByw9ENbNbSpWPwSLEkgKJisza/eBS9X0qT66JFRuGCNhxYk5JWmkAqB6v+sPgouwDL1JQ2quVKoBtbJwj/DViAwS1aENRvLv80GHVZsx5NGaqkpw5I4L9zSiETFaImebSWHLq8ajIhad6yieYbJKXQDzz84p1toWieacIGbNeXnuRMVtu0ZbJ51OytcRepqxVDDh7jixBj9X/7iW0+7dorlRDxNTux4ZNAiIayzIu66t7KycbBNQgeUrl1DJR1kWAl5K3zYTNZd9L+NUsCfYFJel+8wZZ53JqkNtz22dbUIqt+MJcJQPK1OsRksJNKGT8E/sOsFcD9Ud6X/5H/d9+4EROz3zrt+PMsiyJMU0QZHZyp48Sao
 +Xihq3TQ
 wSqW2bi4JLcmjo8pDV73HJz8swH+cqEAHQwYU3rYfY+GWFi1VDsIoyo5GRMDVUv36w6NgHkOYnn4i9t6BUpRHVkdngkjT3BlciwAWw22Hp9fI/5w95917IYH06u2ZXPmqAjC84ZR6LRpe22Sat0vO1Zsu6KkaEzw/H4pBpcC6tOeLiXvT0yUYp94pmgGmKQSt7x4HnohjdARCHJZBa1SUcXzk4eC7msdwkUml6PJL2PPPAjy0U2CxO9iAb2daNVAuiI44PXf5IF6uPrf95QPvsAEvXMlVKzNDOI7rKGcQ0DaKCSsmXyglh9rFBE5J69FpikNkgpj8Ozm6LKpjkHmrQFSfWuVidCNtgmeM0LUOFDTVW0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bfs_dump_imap() allocates temporary buffer with get_zeroed_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of get_zeroed_page() with kzalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/bfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 19e49c8cf750..0d7b95371271 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -311,7 +311,7 @@ void bfs_dump_imap(const char *prefix, struct super_block *s)
 {
 #ifdef DEBUG
 	int i;
-	char *tmpbuf = (char *)get_zeroed_page(GFP_KERNEL);
+	char *tmpbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!tmpbuf)
 		return;
@@ -323,7 +323,7 @@ void bfs_dump_imap(const char *prefix, struct super_block *s)
 			strcat(tmpbuf, "0");
 	}
 	printf("%s: lasti=%08lx <%s>\n", prefix, BFS_SB(s)->si_lasti, tmpbuf);
-	free_page((unsigned long)tmpbuf);
+	kfree(tmpbuf);
 #endif
 }
 

-- 
2.53.0


