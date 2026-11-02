Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD9A606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kX8+D9NV
Received: by kanga.kvack.org (Postfix)
	id 2AF236B05D5; Mon,  2 Nov 2026 09:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285C46B05D6; Mon,  2 Nov 2026 09:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2AF6B05D7; Mon,  2 Nov 2026 09:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC1A86B05D5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:26:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77CBC1A0137
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:56 +0000 (UTC)
X-FDA: 85390405632.01.8FA5C51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA9C712000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kX8+D9NV;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629614;
	b=Z5jH5xPW67Le8ircJE9o/bPET9EJqeaJB6jQ+HDfBm+KpySLWaJU3LmH3V6dwt6I527KY7
	peCDhqBABHCyDbB1ChzlZXwWubRN46xNagdO4gEbtLhayJ+iANNfCYEGuCtAbuSpwh6/nS
	gJV4aiiUCSOdg6dMcRMbJ9wyOTtssPI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kX8+D9NV;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aVyOXB46BuISsBUhN38Gy53ksJP5B0VIb3fhsBGGRA=;
	b=1EVGr5uM9Aat+8YEM17mtyvw3FpPipsqTCZOZ4T/b9S+3YtIbrYxpKWpSbtdFrvEL3b9tz
	vBTcMc1VSBlsxeddsskqDr9V0zcfqNKQa8IDYdbH0zt+tLHvv0AvFhXW5WXE/XL82yXKdf
	LBVSsrcelsIJf+k4XnU1pe7udZYJPR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6384160252;
	Mon,  2 Nov 2026 14:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C131F00A16;
	Mon,  2 Nov 2026 14:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629614;
	bh=9aVyOXB46BuISsBUhN38Gy53ksJP5B0VIb3fhsBGGRA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kX8+D9NVfqUSc8gdnE5o7Q3Oq/uGaLH3xjedKLYih9wdsnnjGcjcRNyhrZaxgnxxx
	 6mJPp78Dyw5jmgqKUNdlhpYQ/2Qf2LxAvvtdrBxj50iBxD11Dxk7n+iHGOSy2yxUdF
	 FBfa3aXoeS07kk/77nHtewMxpER9ltz8Mj/fE7xHULINbv3mdMS1KJ84n3AWWtBdk/
	 bya8kywSYeK0JZbU+HmtQD21/aGPUSusYBz+eyTQ4qL+4aq772xEp6pJWjXfU6i3HK
	 oQcjHkwy6Nkk9N/kAx/z/L8sk7X6Lk8bFh4mVxNn8C/PKjrqbaPSzJA45GkFv8YnRt
	 zK+G0svabDX1Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:37 +0100
Subject: [PATCH RFC 22/38] proc: warn about entries left in /proc/net of a
 dying namespace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-22-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1461; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VO4WYvqdbdInF0wrRh04dkmiJiaJmigcn5WsH5ed6c4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJO9wixVJYzvlj178KfJTowVe+L0g7o9JBeHSb4ui
 OJO1MvqKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMiaf4wMS+2vzm0vtpws3xjx
 Ms/u6ofZgus/vnESzThVVPxXfJGuFSPDjsrTjR0fyxMDjG7OlZnMcnPhiY11+Y35btcVvI932r1
 jBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: BA9C712000A
X-Stat-Signature: 865wpd3jhcstzoe5yz7151cdcnoxqqoi
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629614-515244
X-HE-Meta: U2FsdGVkX1/F+tYpXvLI1JvG7bFI5/w6OpnaaXJY4XUqPBsxMXcQcJDkQLY/aHBIEDFfMIkKD3a6CWmmBDfRsDk6EjZrefHH52ShqITgZ9vZNjGlN5+OeOcOmBiBW82I5fhqdHkP4W99Aqe/UrlvKTE4l9/wTkUu6h2gIq/eLna+COgxPE4v2YXOCpDYcHZ/JufPl+WPh9J/vC8rOy8nUIJVBh82p0vXJN/E8bN+JXic+/SdSTBcqSAwrtDcKFSpwJV9q0viIN4LO++/ijZQDuit5JxuPmBo+NH36p0qxv0uReopUEOqobQJwpFYr06DeeI29yjuXGZAuGpm+fEZAxhxv4tb/0vCLYBQsK6xN0iuNqFf9mSHxcIMYARpSlx+KnUUh4hwOPwDmJ0RpgM+05h0cU1z7rXryaf7rZ8p5zABolMpAn38RQfYhiU5DqV8WSKH/n0Op904ju6uHWca8GfDbynfLW/4osZX9GPN7orZiVpfY28btucFcacXOQtoxH/0R5b9H9WW6XxW6WSigj5KoRBxYxkZRt4JcloABr0n+8XQ+z1MfOM0OBvR1YE4pBoDK+dzp03vgu1J/WrMzIsVRxed5iv2M6RN1LU9wy32fL+PasAr5ksyLENX1AhLyZ2t3CCPJUYv9HUfR5FWo9JTq2Fir4aFO4Mk8FWCf8+6Pnjl36/godM0evU0ixWHoG2fflEcPWEkqLkfXp36zsZFhe8FG/0Bra0ZfzE4vaVZ6ES/xTHUqVzb2f90Ky4rJwg8g0ToUIvBH7j/LWEpMxR80YRevbWvWrnFrHyhDLtxSEJR3de5GkgmG3x6Kyhpg2QUuB8gvRXOMa/1CeIOT5lTnRK1w4e+k3Z+UIJi++P9Y/oqM46gogizi1NgMAMJUWOmbwW414s4XF+zhpycg0gb9G3rsTTFW2Y/rlOhRI0yaqX/Rhw1QbmJaihPDBsm2jcxqbxssNK7QCxt5j2
 Mc0PSL/q
 lUgZy6bENuvQo8B0VbW4Hx+9Y9VC2MQWQFfmJuK9/XKRRQlTnOj0xuUkILcpQCq8wqOjFFABtWTZ0t5nUef1w7xsB9A0sEhhxttwDVj7nu4DIcu2ljiRuvNbSEuckoSr9eceLtvizFWeVyNgrXjM86YtFZeGCIxtUYk5xQRoUBfsJDyfreVo2tJQPOh0nJQIUcVYur/yetxI2CxxPo2/7raaWzxN9ubXH6RNCdDnmgIYaZT8JxELlEHPwfk+3N8FG8y0SRgjTm9YOUr9Y1q8U3KgOdaYkNfJ4lcqnl+Z6ruU+XrLbhzwaB6PCtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_net_ns_exit() runs after all the other pernet exits and frees
net->proc_net right after removing "stat" from it. An entry that some
pernet exit forgot to remove is left with a freed ->parent, and so
PDE_NET() hands seq_open_net() and single_open_net() a freed struct net
when the entry is opened through a file descriptor that someone kept.

There is no such entry in the tree that we know of, but nothing would
tell us about one either. So warn about it like remove_proc_entry()
does for a directory that isn't empty.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: e9720acd728a ("[NET]: Make /proc/net a symlink on /proc/self/net (v3)")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index dbcf87a257e1..df5484813d5d 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -410,7 +410,13 @@ static __net_init int proc_net_ns_init(struct net *net)
 
 static __net_exit void proc_net_ns_exit(struct net *net)
 {
+	struct proc_dir_entry *left;
+
 	remove_proc_entry("stat", net->proc_net);
+	/* Whatever is left still points at net->proc_net and so at net. */
+	left = rb_entry_safe(rb_first(&net->proc_net->subdir),
+			     struct proc_dir_entry, subdir_node);
+	WARN(left, "/proc/net: leaking at least '%s'\n", left->name);
 	pde_free(net->proc_net);
 }
 

-- 
2.53.0


