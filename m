Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88CFCCFA07
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECA98E0010; Sun,  2 Nov 2025 20:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C8E8E0002; Sun,  2 Nov 2025 20:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DE08E0010; Sun,  2 Nov 2025 20:48:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 581CB8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:48:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18A6A12BFCD
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:56 +0000 (UTC)
X-FDA: 84067612272.10.4DC04C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A282140009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yReFW9gB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:references:dkim-signature;
	bh=818PaUGUBLk3ZcROrqVnDDvy+icOHZOEUYmGeQN9ScA=;
	b=kN/gHlCxsA5BVssERxUP3DiwygYfKxo7Yg0Ov8H90bOAfvfvY4Qoqh5d7m6mPX1L+MJHSw
	jipT3YmOrSdrcQRRMWFKYAP5gGBuVzuaLYMbeEFrOn7bplUHywZ7IPaOT4PKs4Yw2cZ1e3
	hhj6juEOqMJtK64kRiDttMvdpwyHvuM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134534; a=rsa-sha256;
	cv=none;
	b=G8abagxJX/3uLgMusEjozGT2PlvjWHke9CDZeJM0/OBiGTcghney3MSibdkEC5S110rR8U
	NETfYEx3+0FtObdK0CjjD7l72RhQouxA35zmqCfpErPSQWnsozM8+7qXe6X31a5D7Xdkx5
	B2jlNjMsvIcLKi5kwyYe7+2MClLQtro=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yReFW9gB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DAFED60284;
	Mon,  3 Nov 2025 01:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455F5C4CEFB;
	Mon,  3 Nov 2025 01:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134533;
	bh=VzvbnXysMs+hPXBAqPduVuWyElJXSDfW/ZKbFExsF/g=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yReFW9gBO54JeNjTBde3SV80321WrjASHp+In1jbqSzNCIejQv34o5HtFBhHUHLKw
	 txjxZxFL2pxKLl9yhR/1uOoAkxhuMTtCxJXkhfdTVXezqntOpDmEX9IvSLZx2n0LJi
	 DDdTSNQXbpb2OU8u2dJH79GPULbkFncty5NDovow=
Subject: Patch "direct_write_fallback(): on error revert the ->ki_pos update from buffered write" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,brauner@kernel.org,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,mngyadam@amazon.de,nagy@khwaternagy.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:56 +0900
In-Reply-To: <20251021070353.96705-7-mngyadam@amazon.de
Message-Id: <20251103014853.455F5C4CEFB@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A282140009
X-Rspamd-Server: rspam02
X-Stat-Signature: 8st5sgjkhwosgqktitpny1qhhbfoze63
X-HE-Tag: 1762134534-562108
X-HE-Meta: U2FsdGVkX19WDRj1/BMl2BW29apNQNpxwvUa4TbZd33eWoL0doWiu9LA5tiJV6suNwhPAfUpBhIt4D8c1vOvYse+QL4qSrOt5p8QlJ4OX5IGeLPguVGQtcgKyUTUJcQ98roTGOJM0JSGDHjkSok3J00smWDl+qitYbddES4iVwiyjy6w6gC2cirZf2cuycqr+U+mOGutxX7PtYps6uu7PgumuGt8xzkmrrG36sDz6/aVq6HTwHEEY9X17O6F+0oFn/RkWQs+HTqAZii2ZsWu+GlEBnMhoDmcK47r8dni/m48PTl8ArHeA5C1SxMzns+EvhKTXx0X37j6/YnY2knoyVMvaZkNEm7A1/UBqc11Cv11VETbW8FOGpfEum6bh3epc3ALcl5BrIE61z+Hrhl8R/KOsr0lSdG86htlf0zPNB90fpyRNxLNq89OxxFyF8hUrEMbf0525Ozh0BjBzpjL7E6agfDz7tju2s1YFysMmR/Kx23qWbVENuPCNnKnDyRnI6v9tCkHIVYDKB8yuJ50iQofGjfOe8C/R3JNJGHAIRLqhYRajNF9rlvaK3JK95wglJq562Y9MjmlLNvdYZRzb6G4SSpI8CvBayNlN/QouUgDcNi5hIpKr1hIMu0ATOVrlmKezUPekuWaNzBeQy3awqPhhZY7/zOPO4Yej9VspVBRSrti/rGxr8banNZzgbeku25w2xT22WP0Ag7gsRtEAfJQ75jsI8WcSqBe7x9iVsYjnn02FfpFQWzjCjEB3HpvE+tJb9/DkIM3NXYsJI27QmJS7PyMJYrN9W8YUIGbKyGefsWuhM8XN5Tzcjc8K6Ax82lyiRs0hx5IKdB1iVfYyi0ZrUIxjuBx+nAC2tMS3bFXbjWY58hHRvCiIAlnI8xojZJ2mjpPJp4qrNpEtNYU0S4xXJaGPzKfWvL1SL64Fzhyn4APlbRVybvFs/VU9uDpzZgl/bMej3jH9CYWwQ2
 vq9/9xli
 zLLw2B0FGVx1N11ibdwGmZpO2YZhGbBcaJh2gpjpl5wXwsJgYSC637Z9j4RRuk8rd9WEnj8NB2OvF/GWD1fYyfuqGPQmsO8S7ND1/qIG5/PzX12rPikYvYJUMR2xO/vmp3kJyUdFf5HTvHgZp8XtxW5YxSSLGMPAtS/iipmJEL1QpTA4tkXF5C1LxlIBmDozily9sRwTOMUIexSaJTVmxRaSGwdsbVuY0fonSQ0iH3WA83CNPsUExQsyz9S3+OeR3ftQb7hLoGsDyab+6ZQ2Ch29vzbmZ/LTZXFAB+CRQ9tff0/LG8Mj61FGW5sTNz44pwdvVCu5E6rN1cLpE3AyNoUDfYjeYQSXAxhP2rq5miwz/OtPD2toeyc3IOQzGpa/qS81F+e01i7HVvWRV0plR11/90U+kka61jtuZgbvp9VLuIfOR5qtfBhEP7yIK1RfZ/RCIqYis3+ysmTWdaS7BXo6yPJrwkTwk/2MA/H1djlJaVGvL8OngooXgpFW66Un0oPj6ogvv3zPQiXaYkX45iyrced0plY6sxYRjoi2j64+lRvsCExppF4Jh5C8gKgjzKtYyY7ksWfjyWXkERuLFHMETn3r4rXhjwWh0Nbxfj6KkijRTsvSLI10+KwrSBW/W+JrpBISgOfqyOfnyuEOeU86SK5EJ+Uk0fhtWjSeQszGX05b/Xt+tqW1A7+tNuoYWay4O8hvF2PlbXCbE0LjO9VulH3RSQoV9UcG9h3P7Y0ftfXMZvmu1AuPVBFnl5DZMSwyX4Liacli8PFxfhuk0/9UTxBiElsWKRHizDdcPpNkI06c4wxi9GcBmC0Lmya/AF2ZGVYc6H/IMaoPj8Mlpy+4WzBTKDXw8TGs96g4390T+biL4wE8oYiAZby7D/r9jT9pMmjnnR6ktE/iQmZNVCdclPP3kzpKfjOA4GW/ZcjMiKqsdcOTGqxe6Up925NsGUm9g7Aqbu+Us6kw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

20230827214518.GU3390869@ZenIV>
Message-ID: <2025110356-extending-goal-0e9a@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    direct_write_fallback(): on error revert the ->ki_pos update from buffered write

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188300-greg=kroah.com@vger.kernel.org Tue Oct 21 16:13:26 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:40 +0200
Subject: direct_write_fallback(): on error revert the ->ki_pos update from buffered write
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Ryusuke Konishi" <konishi.ryusuke@gmail.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Hannes Reinecke" <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>, "Luis Chamberlain" <mcgrof@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.
 sourcefo
 rge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-7-mngyadam@amazon.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1615,6 +1615,7 @@ ssize_t direct_write_fallback(struct kio
 		 * We don't know how much we wrote, so just return the number of
 		 * bytes which were direct-written
 		 */
+		iocb->ki_pos -= buffered_written;
 		if (direct_written)
 			return direct_written;
 		return err;


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch

