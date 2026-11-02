Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E7260703A9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WOtNUR7A
Received: by kanga.kvack.org (Postfix)
	id 4B1D26B05BF; Mon,  2 Nov 2026 10:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4626B6B0634; Mon,  2 Nov 2026 10:32:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353F76B0635; Mon,  2 Nov 2026 10:32:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 014766B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:32:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C92B160156
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:32:34 +0000 (UTC)
X-FDA: 85390571028.06.196E60F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A690518000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:32:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOtNUR7A;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0XEj0YD19hajZrTiSL4Hx5oTZ822IFleoT2hqE8QNQ=;
	b=G8P2eoDQFRnSzCQ8uVO1QO3leNSzvy3fP6TijLS4lQDvuwHWTpB4oc2df/iCsoaHNxtYiu
	LrIaGlp7YefM+uBHFTE/UQ7niTYJG09vNc4KKE9lSGcEAscL5fbZ8Y2obJb88EaB6A+DU4
	bJfTpAuaICwjKNIALXHIcxFxhvEBMKA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOtNUR7A;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633552;
	b=rmgi8F6J3oVlRmfQ7Q+3/YPF6vpEcGOAimGiNl40qQB8wqmg2N8UfMs3CCKl7o0XyS8piJ
	Ajlw7yHR7j/7ZEzDhxwnoeQCLEhf/nOvv8Pm0gP/6jd0c5hh/x+fJkjHXf0L5Wp2PC0oin
	c06VQ+nFz6zV19RPpMDT1ruk5ujJj1A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4D2142E35;
	Mon,  2 Nov 2026 15:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714811F00A1A;
	Mon,  2 Nov 2026 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633551;
	bh=j0XEj0YD19hajZrTiSL4Hx5oTZ822IFleoT2hqE8QNQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WOtNUR7ANTbV8Aq+NS5tB7HOgtUYtUFBrHUduOMXGSrvyvVh49FKtJAtPA79xEdKK
	 bWLuxrK34vw5XvQe2Ses1fW882zwHJNi0DTpIw4mOgryVfyh06j3VgDnExsFIakuQ5
	 myUaZwuXJOiUD0AVpk0r2EDdW+XFBxyBcKxkzbyxcSh7mpU9vIC53YIaLvGKA95Tv5
	 l0wnd9SE3I99/RpnQwpcxyDZJh+XRZ7Gez9UyXhApoK8ws1dteMc6OckWGLtrOFM+7
	 gV/vEgFiiBUWN/JNUdIJHozxukOMKP9vkwq6miFhFVRTjftdm1zZuN9/BGNHxbp7GI
	 sMgsvoriwacXQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:19 +0100
Subject: [PATCH RFC 05/11] netfilter: xt_recent: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-5-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1724; i=brauner@kernel.org;
 h=from:subject:message-id; bh=m6dNErjBjmz9XKGa3rT6vumTNxSZMRjmxs3KBefnnQ8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7ccSQ+KU5P1WO9/aOk9EeM4vLnjsV0vNLouKtsy
 VSiVh/SUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBGms4wMX9eu8Tt9WbzpS8+D
 b9e3s2i/FAvXOGvYKGJYVuMb/Oy2IcM/vbLA/s/ikvwyn4PDDs4pne0p8eNi9MxKj7iwnmCdYhF
 uAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A690518000F
X-Stat-Signature: ufiuqyzxeppys1zsp7egfo8gq6xs9fmz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633552-28692
X-HE-Meta: U2FsdGVkX19WMCnNatwodEr36qgGUtHgoiwriXcraBShkBJn6Pvy9xwzmq+XtExkXHNA03VftyooUttEPv+NJdqV4OF8cJlNbGH+9JoUJoPt1yz/AIj+zvpG9NjmrH8NTO6/Jn4rQJxRczhxR8DsMzcquX1cpYGLf8oHuOyiPKgiVKjp7YZPCowIo5exRU7N5CIRls57qZZqq3Fcrz614rsFzxjlC/DPWAdFzn3kRPvm4Qw7DvOMCnIG/5iblTq7ZEAqTQ7rnK0KJkFKxF/Uare83FVUGyttN3ZuklA4T25ekqIXY4T+l024rMga12wHyEAxyLtUDLRBHpdW7yz+lj7wvT3HpfsA8c5gsozmP3yjz4xkVvCxztzy9GK1U0uwxkj4MIDvB7iUis1gMhAuG4ybYlezH2xfTqL7E/kyeEYYxSx87K6jrc8OydlvCF1mVMGZq7+WSK3tuzz+y9KeMYU0/9sIYGts4I8Y61R4tBY3rF2vJAte5o+zg9WuUKJH/vY45l8iZNML3usPBaSj/60P98FNc8PTEGYTbWzeV3q14TZxAhf8U3u3wWVvSjpPDz2JjJ1Dv/805Wgl23zz+OrD0m+OMF0ELqKUMPXqgsX4b3IXLeA0tsMdWIyGj9UCxt4+uaW6ScrDNYE/k+8hiZUso9kOaWCPyAi+MwDA1hkMYcKwpW76emREeSk56LO66rc2zakhJW/l42uoHyYY6OuGZwtf1BI0dbCgrjc/+A/qaZzDcZp8FMuGTQnt4xEA/3sZ/TsUOE9FyLZT+zQYazK2ZAXCxlYznQlsbaa6YBhrR/CJxZx2WkKkZEKZWz1TRwu67uO8cPAp7kWVB4xyAcgfvbdDMsCKVCsPkMJYSeh5DIeRXgcMCYejfCNQm3ouFpwmmuEtl92zyl8ZrPLXMLghWWbpaLf8Q+UKNpRc5ZoBAKP7P0hN5L+RftnUkxphOEI1Gu+K0H/prLAwS0C
 mupNLO2W
 Pn8Q1dQe+t4ZVWT4Bb2Q5mWWRu8Rmiu1Jcks719Un/UfOX71AD8MLkSa5dc3s8Je8dVkU6ympJLp+0Ek7X/OKvS+Gx6kzghxqh8ukBpuCUT8zkiKUKdmsuTAiRU7Sg8eFBMGRYiqIQnlwzq4+FbR5fcfMG8mTQN7luZQIvtP18YAjuJgzDzkp5jQma7XbOPM/QiZXUXW3yssqZlah5qWIldPu8lyka8yIOJCxckURCRUgjbqn85ooOsMr5kRzFEkBuqDaFh0B+gO5EfOoGIcUdEyZaCB/GHnV3aANR0jt7D8/sxKWuiJvtk0MOlxZiR7UcIC4j2r6R355xWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/net/xt_recent/<table> before it pins the entry, and take the
address from that copy. The removal of a table runs under recent_mutex
and doesn't wait for a writer that faults on its buffer anymore. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/netfilter/xt_recent.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index b771cc463aab..306557f25daf 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -553,8 +553,7 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 }
 
 static ssize_t
-recent_mt_proc_write(struct file *file, const char __user *input,
-		     size_t size, loff_t *loff)
+recent_mt_proc_write(struct file *file, char *input, size_t size, loff_t *loff)
 {
 	struct recent_table *t = pde_data(file_inode(file));
 	struct recent_entry *e;
@@ -568,8 +567,7 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 		return 0;
 	if (size > sizeof(buf))
 		size = sizeof(buf);
-	if (copy_from_user(buf, input, size) != 0)
-		return -EFAULT;
+	memcpy(buf, input, size);
 
 	/* Strict protocol! */
 	if (*loff != 0)
@@ -625,7 +623,7 @@ static const struct proc_ops recent_mt_proc_ops = {
 	.proc_seq_ops	= &recent_seq_ops,
 	.proc_state_size = sizeof(struct recent_iter_state),
 	.proc_open	= recent_seq_open,
-	.proc_write	= recent_mt_proc_write,
+	.proc_write_buf	= recent_mt_proc_write,
 };
 
 static int __net_init recent_proc_net_init(struct net *net)

-- 
2.53.0


