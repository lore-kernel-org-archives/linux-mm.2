Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBB2CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313788011E; Tue, 28 Oct 2025 02:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA61800E4; Tue, 28 Oct 2025 02:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2F48011E; Tue, 28 Oct 2025 02:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0626A800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:11:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92D4149109
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:11:32 +0000 (UTC)
X-FDA: 84046501224.13.61ED7E6
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id EF5C2180008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:11:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=en38n3Ho;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761631891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeGicC5Z67ZOycdylyHVP58sPv/wzz9kpKbtM8vrBao=;
	b=SEkDdA0YFTrFJZkDa/8NSoN/1Xfy3RqGwfoOnm4AK8Mnw0cyDsHmmRZ7FFB7xg0gwM9rSl
	5c+trHQew0KI8bL4Af6HSTLHKH0005fRl6Mxkn7k3uQzhpKfl7cle2qcPMlH++VWZw39Hg
	aROfF98Cz1li8gNBkWyp8djuzag9CYw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=en38n3Ho;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761631891; a=rsa-sha256;
	cv=none;
	b=ACY+lOr1KGcCfilZ0lGfBMhaeiVoC3X0LO/d5H+x8js3g0kwi1PAdk2FQrT9tmHISLaBT8
	SvyEoa4p6QPmy7wCKOfXi1WVMa2aIEaOh4k2s4XzTj1LZRbDXbqObG0OwbPQzSK8IU1MwV
	o3qxBlCZyBCs/EydT3/5grpSn+4XU/M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NeGicC5Z67ZOycdylyHVP58sPv/wzz9kpKbtM8vrBao=; b=en38n3Ho4OllXdazOO42BlB+wf
	jLWpRZUqHeOL4fVy14AZUu0if+Zl0TYbzTm0FT4IkBHK0nL7PpgGPpqFJxsd5BctsjcfxD+WGf/Nd
	RNcAo/2+zVnE4mYgH3rt20keuFI59nUR5ddlqTumaQImzzOGi2MO1tpBgntbek9BD3SKkh3K8BmPO
	KZ57zXUChompwqBOodJ1GzIWTOBp0GBTEJDKcGiHG9IdciXVUVRem1vBUUpwsTRZlv6ulgq4cuPCN
	MDhMeyq4GU7mKoeZnEVt2ksHnCwVu+lSAuQwBykTxlt5GMnS9YMK/1sm2pmWsx1Ilp2nwhFUTVScz
	Ww6yXlUQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eXS-0sEj;
	Tue, 28 Oct 2025 00:46:16 +0000
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
Subject: [PATCH v2 15/50] convert bpf
Date: Tue, 28 Oct 2025 00:45:34 +0000
Message-ID: <20251028004614.393374-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF5C2180008
X-Stat-Signature: 9nzpidrgooyxaockdrefq1i8wuoessrk
X-Rspam-User: 
X-HE-Tag: 1761631890-837891
X-HE-Meta: U2FsdGVkX1/q5vG7oad0M/EOxb7O/XCmIxM5D/3je/xscB5pjKi9IEa/OqZnlTt1oPTPF+Ovr6N7LkinJr2edOuka6DUTBfR2DXra6X56UIdE2pxvVQzYLj1qglaido8p1aKwUUuLMmUpnLtMFrx97ivqx6107dk2y8T0D0ICma6foKdJZiBmPfrxodZwDfjNTEih3MM3qijCOL62yWGqYtJOE6i2v93iRnMlex363sxU6nZCaM3HGhsjr2vpkJ+K4FLNBgcyySVkIhZ588VDXxrsryeJ1e5h+MERzD+R7dZYsl5JVIms7qalU5ASUoVjDplzm1ihhK7lne3aeQ5qtgMkMXkUiFhCiy4qn5oNhmPjbGqUFjiwZPj0Hw60Wzg8jhYSjk5jkWZ9tX1Ssv3vQp3Y9zxVyd9ArbUCCmAh6yrRaSqA0f9dEgWozLutb/P9fNLbHbPl5BcS7uSbGULZK+08MNp7FqGBt5fBLpzaYX1khZKyy9ql+hCNvIo2OekY/d9Pa0DArQsDny/EtYNFqqFmRIp+sS7bLzCH3pzJgAbThg/hL9EuLvpSrjlEJ8NioQvcaMgB+zTs2P3nYOFj/szyABl9R6hgwHEUsqcKFN/h2vkDWmfEARgol/GF2FhuQ7AzWkW8ahcJ9stlkJ4X5oAqtNHOtuo2UcCcvBdPqss4wyRe0+jRKBzWfTipphCWwJ6v6U7jvBbvHS3urzpaJG6gPk6l63DyUtMMdS7kEwhUMbjfFHadp+k/3csNs8ss88RjZeUFJWLZV17wk2/eORpOHuSI3wMfUkfATbwt6d1iSZQ3KQdCZx1iEg/rLWHcGKZnSH9ypgk2JsT/4J1nyVaMzcq/e4YxkrTFvR9TivR7OKdGr49J0Z8k1xUOt5uBMtk0VgOco1uURp0Uh73VLW4LjKof6/HmqahTr6FVzdCOFkyVjFCACpDl7guZFsfVKtJWjNf3OrJ2k1FYhZ
 z0+Ia0M1
 wJ+zgl84QbKNDuAr2B0/G1ZPwQR/iC/MAo57gie6JyCoeVCk+TZ37lybrVbGH1iRVXikumn4I+dQNRCrsUyBYqhcLMTh929/n7FwvAk0oRJBXTDvpnd/VQs0QMMA671aw4YeUrrpM9zHNdCeTs35ivdHBTOhcMdVO0uLqrqCNzst/f3NjUPz80lnrEMagpSI5t0ilck8UA2YW6Ab5F0Q30xhyOoV3QuFVyso2xy0WyL5XX750Vgl9uv27FzOzZiEHeHV5exslG8qKVVVsTHYBx7AXdgFJiiCxsA9nvL4tnmaHpbc+CJupVvB/JQnsfYcBm8jqus0ez4RrS+Bf9u/GQDHfAlRO06dQ0yDAzGbDrnZr2jp+hUJOr5XKxastXuT9tzIPrXZDFH9mwCo2Yh+oDuIHFRjx3ItT3BwU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation goes through the normal VFS paths or approximation
thereof (user_path_create()/done_path_create() in case of bpf_obj_do_pin(),
open-coded simple_{start,done}_creating() in bpf_iter_link_pin_kernel()
at mount time), removals go entirely through the normal VFS paths (and
->unlink() is simple_unlink() there).

Enough to have bpf_dentry_finalize() use d_make_persistent() instead
of dget() and we are done.

Convert bpf_iter_link_pin_kernel() to simple_{start,done}_creating(),
while we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/bpf/inode.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 81780bcf8d25..9f866a010dad 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -144,8 +144,7 @@ static int bpf_inode_type(const struct inode *inode, enum bpf_type *type)
 static void bpf_dentry_finalize(struct dentry *dentry, struct inode *inode,
 				struct inode *dir)
 {
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
@@ -420,16 +419,12 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 	struct dentry *dentry;
 	int ret;
 
-	inode_lock(parent->d_inode);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry)) {
-		inode_unlock(parent->d_inode);
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-	}
 	ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
 			    &bpf_iter_fops);
-	dput(dentry);
-	inode_unlock(parent->d_inode);
+	simple_done_creating(dentry);
 	return ret;
 }
 
@@ -1080,7 +1075,7 @@ static void bpf_kill_super(struct super_block *sb)
 {
 	struct bpf_mount_opts *opts = sb->s_fs_info;
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	kfree(opts);
 }
 
-- 
2.47.3


