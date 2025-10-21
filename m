Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8119ECCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0ED8E000D; Tue, 21 Oct 2025 03:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8DA8E0002; Tue, 21 Oct 2025 03:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE4C8E000D; Tue, 21 Oct 2025 03:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE0E38E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:11:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EA871A0365
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:11:43 +0000 (UTC)
X-FDA: 84021251286.20.16B7AFF
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id 306F314000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:11:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=UhfhSkmm;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf23.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ER5cLgoC/4MdsBzdzUsBYBpn6poQFnbZbMEZNMZv5Vc=;
	b=y42Na6eCT/Ottjccrpmfh/5YK+phfklHsmH7BZV8ICNNlfYq5Y5nXq/d395Ar0C38L0X1V
	nc0WRpasWtVjejR/AO3LfVfS+M91SsuOkKl3ZEwrqje2Uf5K1XswU/FbvX8NECbMQm1LCx
	a2fn7GFgI47moHGk8wUS5r9S4Uv+E5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030701; a=rsa-sha256;
	cv=none;
	b=vFZOIPP7CMUWa26BUXFUvZPANuhqgp0t56KiC7QhrnyzohbXcFvW1Jak+PSL7Z25QoUKXH
	QHYlpdt7jFFFma/uz8KcCD68JLyYxxMSmMO8WbPpFGSEAiYl8Bok2Oggi3TWJ4min2nzx7
	CsmzFR4c0T2W+fPnj6YzkX9bhHQhgxU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=UhfhSkmm;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf23.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030701; x=1792566701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ER5cLgoC/4MdsBzdzUsBYBpn6poQFnbZbMEZNMZv5Vc=;
  b=UhfhSkmmwGkeVcSPwO39yvuC66h7w/8cEwZKUORaGY+86aWuAtzXsTD2
   zoVwTi+Bb4DmcSWSrB/yuIAI7FJtxEi6NkrKVBGq861EE1zwxjdVClmEB
   1WrUZrOH5xEGllo68PzFxqtQIcF44c2IhSUgOIqD8yCtE8Mc/qhMYnALG
   qQ00SF9+Wjlcx/vbTm+pdjvu34vykf+yq1fcCkN2g9DLh7dbz8Re+Eqmk
   WRwU7ZkxquhbhUqb7pNCkQZohG1f3up53yXqM+pMd1WGI1cxJmhkDLBlu
   COexZ+c6RB2bsbGKVFqQj2VkCsIx4JfcU/7oVKtuikP5A2kQ87N7Mc2Zv
   A==;
X-CSE-ConnectionGUID: kUEZ2KC2Rfa44N6E7Rqgsw==
X-CSE-MsgGUID: epsBYkLXTYGjTRt8EkVXCA==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3824996"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:11:29 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:28509]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.241:2525] with esmtp (Farcaster)
 id c31f0d4e-9a33-4d49-91df-70df47201fd2; Tue, 21 Oct 2025 07:11:28 +0000 (UTC)
X-Farcaster-Flow-ID: c31f0d4e-9a33-4d49-91df-70df47201fd2
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:11:28 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:11:19 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Al Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
	<idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Theodore Ts'o
	<tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, Trond Myklebust
	<trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Hannes
 Reinecke" <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>, "Luis
 Chamberlain" <mcgrof@kernel.org>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.1 5/8] direct_write_fallback(): on error revert the ->ki_pos update from buffered write
Date: Tue, 21 Oct 2025 09:03:40 +0200
Message-ID: <20251021070353.96705-7-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D046UWB003.ant.amazon.com (10.13.139.174) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 306F314000C
X-Rspamd-Server: rspam02
X-Stat-Signature: a7ra68wa6dp8hnpdytkdzfiafotwaaug
X-HE-Tag: 1761030700-506914
X-HE-Meta: U2FsdGVkX1+RNwZdSg7As+CZrbEFnK2AIZVBGTkeGYuO1vr4KYTaMdF7qcO3WOz958309bx11bh8Vrb1nEEUZKd7aukj5qltJ6gfSMN+LkNjlj2Ny/zfwZqv+T6ceHH8WYiTeEQP+/GwYx5O9MJrcWTa54DOWt/blN7+muw/V3V+n8MMaZQotdOqPD/cDixlaVRGeheYLu9oWU+4PokgMue4hfw6ojnjp9QkCMkQqYW4+Xkxj1mVtYWItVQWURFbkIhNILDOq7as9h9zneVH0aXzUCVUlPAa+r2DXr4rblMK4t4LDsmRNht1yt34ox/aF1by0cVR2DO9iMlKgRKb/eLn/J6pfMF7L7zjI/fF+PZ0JBWOs2Om6jXaaM6Hl/PcQW8l6O4QrmDojeqZef6B6SUY2UucUbG1B1CRFt7Mxh65mBX3tUp74+0uFTs8CLPCSHhcl3rXhhU6WEmMhTpKLs9rXsKMknvAGpLqqTbATBupght1R+oILqN1Go+8Q0/lekryYud9fPhQ7vL7PUO+cLYwTPrgISYgp/YwXgG8KiDuPdHm6RBxUTGxZgoyxFtQXgnFovQLJ4NMnJVJCAWliojGMZA3zjSH9TBDBDqAhC9ENlQdJtgj/ZGt3cCH9DRFTqQvkNbUsX9atA3tlo9Lu1jEPmmxExjifDfADoCk51ASCf5yI8dm0A/VmQVnRyh3+gd6kTrqfcOT3N+RP1PaGrBMq3TMQvcuX7Qds1zrpbeiFYiI4qcCoggAMW7tOd38SSOREr7TQ7mbxhcKswN+qzCc/ivkho1/cPAKGLF44s5d7wgM7DEDFCY3DjUwl3iYBLBfIS4lVG/XaCQqtn3X53tmblpgw3m09dYJR41kTkhJ1SVOG5MB79UOR6cJa8luv5wUm0fvL9JHinD9y995qErjxpwG4S53B/dmreCbJIAMpH5idcpC8ddoz3pMRCY/HkOYtu7REKK8cp9xsLa
 NHK29vZP
 wcArYZBsY6t/Pu9JKgzcwBDTmI5WFU7AH8BGMYXzz5G9XBmlABmkTilAsDys8v2wpCSspbEUCGYd6jx6DQJvOpkWNdDPnUCVKAzAikPV0lTe9znCr7V+wRBpc2GqJl6sNl/RgUPh0S0AYAmB8Ucw0Q7HjVq/EH4zhb5u+ydnE64Ycjn8hF/IbnDZinjz+9O4TQJx1vB363mm/EYnGqSv90eXJam/s2lmWqVrY+RxYv9irWX0qLl87SET8ctUfTt7NFavtnzFFz6b0XeHWYSrUbCIz8V/9yu5WbfGBxlat0t7VpX+Wc1qhU9bbbG4qExon/eMcg0XBoOpHNRA+epHEGCD52toHhXtSbhgZSzLdOUBZnr9m3kfzb6/ITOn0ErnAWbgsgKieOZ1dtDlCMLQj+Qk3I7SocFd9JGpbDuKJpol/TzMvlwFehNfKDBF0xznjz42gSNJIljduW1xcypmgIJfq81A2sypYlKUBJrd3qtYwAKEAPhA+6wev4nbW1C54hcBN9Q4Pj/4FCWKy6OkTSfHgUWp0pPWGyXr47SUX2fLfZ4cyrlNC8dJiawssbLD2c6Ow8HlhCqW7ptRLMzGj8kVjGgRKChmVpuqkgMCPuh67DaxliRNWZVfCk+Es7ElA/NiOhr5qFKhjSrj/seBHF4jXLb+YZppKL7PjIsMpp9HYe6Lk3K+UjX2/+W00sXmoCKOoMXLCW/8NH3mF/64cZxCb94u9FLA6FuxkwtYT+NgH6Yx/2F5sDnF7IeWrPX/knGrXBZVCKz+GgOoVSirizu/Pow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8287474aa5ffb41df52552c4ae4748e791d2faf2 upstream.

If we fail filemap_write_and_wait_range() on the range the buffered write went
into, we only report the "number of bytes which we direct-written", to quote
the comment in there.  Which is fine, but buffered write has already advanced
iocb->ki_pos, so we need to roll that back.  Otherwise we end up with e.g.
write(2) advancing position by more than the amount it reports having written.

Fixes: 182c25e9c157 "filemap: update ki_pos in generic_perform_write"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Message-Id: <20230827214518.GU3390869@ZenIV>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 fs/libfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index a5bbe8e31d6616..63bc52c20f7e03 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1615,6 +1615,7 @@ ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
 		 * We don't know how much we wrote, so just return the number of
 		 * bytes which were direct-written
 		 */
+		iocb->ki_pos -= buffered_written;
 		if (direct_written)
 			return direct_written;
 		return err;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


