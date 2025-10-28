Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9698CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24812800E5; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBB4800E7; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489E4800E1; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10ACB800E7
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C327A8795B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.02.3DA659B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 310DC40004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Jn1rr4xm;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=FkteBXchPnEux4EknaRb6Y/G1oOrOXCxNnLHvmtnLSpML4SvcCo4O5w+OkQldhA7DuMMTt
	OcXRKuClEnYtwi50mCKz2Yy0BNds7kRS+uKHay4Emn6b2cE/BOTSccl7iBrivpg414zjum
	TIkW92EExeZWtJM9oTlvh9Z95qM2LAI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Jn1rr4xm;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3maaNWdAFQG6lKGkg4q4mAf3fnGzZVX1VVI0dDX3CYE=;
	b=Y8+YwxfqzI9TEM/PA04Y/OiexmFirwFUzeFIEe5tqR394eZzqUDchi7cH6iAbuQWp42C7a
	J7gAXZvEtK72DBLf5HKHjxVESRT6bYwfxi5yvRWRV+2tJErD7PEcYqyJzeq3zFXuPZJE0g
	7HceQ4QuXG5Y7mABnD+XTIcPGU2qOoo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3maaNWdAFQG6lKGkg4q4mAf3fnGzZVX1VVI0dDX3CYE=; b=Jn1rr4xmQG1IqcjqhJaKaR7xTA
	sM6hBlk8e8SQ4yUYAgOOqdZzo9bACAs/WPkow7e/rkXGarCOoTZxiFS3RHwQmGcvfOb2ulg6xnopz
	J/HO3jjnRphVBt4huDUgOf6rKgJ7T3bDhhzp3KQ6SnXvTvyD2TBSummdrS03OeLzgyAIgx6eoS5oK
	ioyXd8Bn1o1DXjds5OwnqHDrYOp+gAfDymaJ3G9i9LyY7FcIBF+My20d/iVxASx4ZdQIFWVHd8d0o
	Kp5sdzDstFGPwEJGaOcoeGtRbGYXl2FsQEyFZ4orXIkM2gsJ5K1E7wt4L/XRP+2hXcpMlwRzj5NCD
	URiHYTdw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eVn-086m;
	Tue, 28 Oct 2025 00:46:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v2 04/50] new helper: simple_done_creating()
Date: Tue, 28 Oct 2025 00:45:23 +0000
Message-ID: <20251028004614.393374-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: itw4a4sp9izsjiymnwqjkidh8uyjwxes
X-Rspamd-Queue-Id: 310DC40004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761612383-148565
X-HE-Meta: U2FsdGVkX18TG6U/gVLPcRJ82PhJBwXUVRSEY3WAmSjmK2SrPZJ1x9lhR62xW/mEiNqVr7ksPhU+VNZD+kXvv0xVy9zab1GNW9cnA1vZnPEsmG7JVKGptqTqENLyvoeuR36aDlerIRHV4Nhp8RhOqkQZHTisTs97vyB56DfoU8KeSYwHHCRRNmbNgaFWG5avpXNzFGm1ApCZ6SJgOBtrUhiXOePYVvPMhKFzj8F+tDlwDpxzJMfn0UDsTzKLbQFznL8Zrk2gLjDm16ZThxjHWTHJFg1jWGL4Pc+4afI+S6TJKyYRXU+mxw5EIytX92nvhC86tFlJMlnSHD4B7356eOguwhitaTa1N8AudrJzpPETnDEQcXzvpz935J771gxqSPzLhZw+ipF9rgK7i7tIjgwqNDOX+0RXlj8ijnETHnNH9Qppzs/4Vdsi0BAw9btgTkJz9sg30s/Z7D+KLPcpr1ZIsRZZoxYMQQ7vfYGPAb0JP/+/ceokq9kFYbIOeK9JpAx+Z98aFDKNT3dlkJAiAHcFudFC+PgMSAMDM2jEJFnC/d3/65fnV7MIVx6JN4Vq8qw/aSwH+UW1xqCqQfB557QzV7zGsXQD0wmMUy0clUkmWD8tJKbVinBGBpeuXptqp1LBUwfaI/wIiki7I0rinj10m/SunHPvXByvVgeIIW7d7xHkXq0LjkpPvE/Olsffrxa6bLls3wrP+9F6QOLWDWiFfQdNq5qNL7huywaTo4FxtWy5nerpqd2TSj2ywJKpTCZL60M/NzuNNLhZfL04DAI9Jr61fHANYlHWZ51BtBA18jrtklVN2fgSgb2vlp0UPTbn+xG4nuBnbzHfkpcUoLaEHpyIxXzYVMyOb+wOMaXOLagGqK+9T+23fjUrU3JtYe2BF79/znNdFihPICPcKk93GvMGcROTJ0HWecY2G1KwxqK/Md/lAe+Jjg9zukAC/Gjg5xu5bYh3AO8A58s
 bZ2JzH8n
 0U5HFLuCkOZwGMVbTWl2fphqk9bKz0YgcDIJd6Vegr4DsxivCW8qyVChKrWDX3iaLwlKJsqzg/PhYryNof57yZrKkgqnijL3JlbkWRRH7hyngfFtaMTEEdxqTDM+bBZGV4gKgT7VekI9HItBVNmA3KbqC0m3lNamPcfZ27lnVDyYDLqWdMS6QHkfFptyMJyqbVC9QOIRxFGMFnIAiEvkeVsBOWIiUAUc7tBeon+E59JijriZJ1w9FECkcPm/26PTdIl1OvjNXbQveEUm/yBBmgeoZK/UT/euueQjonqO86BWEasuCYlk60TvWS2q38lG2lVOLOg2FRTTjH7suEACU67IC0OiE+uWj/n2wIxl5qOdAjeKiFSI73/kt2ntbkjxyXDu7z3Sz/kCsNNZfn3T7ZGKOhVbDA/X38FYnEQ3BOqTSEeaOV3gw4SDRORN1C09778XEJ2RjKB4l/8vv4rt6QjASFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

should be paired with simple_start_creating() - unlocks parent and
drops dentry reference.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c         | 8 ++++++++
 include/linux/fs.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index d029aff41f66..a033f35493d0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2326,3 +2326,11 @@ struct dentry *simple_start_creating(struct dentry *parent, const char *name)
 	return dentry;
 }
 EXPORT_SYMBOL(simple_start_creating);
+
+/* parent must have been held exclusive since simple_start_creating() */
+void simple_done_creating(struct dentry *child)
+{
+	inode_unlock(child->d_parent->d_inode);
+	dput(child);
+}
+EXPORT_SYMBOL(simple_done_creating);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 28bd4e8d3892..f5037c556f61 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3662,6 +3662,7 @@ extern int simple_fill_super(struct super_block *, unsigned long,
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 struct dentry *simple_start_creating(struct dentry *, const char *);
+void simple_done_creating(struct dentry *);
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-- 
2.47.3


