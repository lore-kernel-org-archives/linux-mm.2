Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB1E60A355A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XqeV2NQm
Received: by kanga.kvack.org (Postfix)
	id DD4BA6B05E3; Mon,  2 Nov 2026 09:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D853E6B05E4; Mon,  2 Nov 2026 09:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BB36B05E5; Mon,  2 Nov 2026 09:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD27D6B05E3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:28:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 397CAA0109
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:31 +0000 (UTC)
X-FDA: 85390409622.01.523635C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DE90180005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqeV2NQm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsGmMsU5ViaEXrFm2/HEk+OSOttZ2XCHXLgyJx8eD0g=;
	b=fn1Js7++HhBPh2Z6zBt+QoalRYbA75d+Da9zDLqw7XYG/AwMu+Oz89sEdi3TBOBdv+Xj5A
	yPpSQvW/8V73eUeo6K23jOaiXqozkbVDKKcNbZVOqRNtXOsnsLz4icpLTlcyToP7JXoUlg
	tNJTM858C8Ce8d044kAGgNF71vaYkyg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqeV2NQm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629709;
	b=Zn7YoZm+dCQ84APEvq8pl9+HLOJXpy6ufxPnFUJGXzxFHAaXFCjYuN6pDCeMbmMMHvRcWq
	tnX09Js8aFel0dsNc9tcbR1G2H/lCPQ5jNCsgUPyUBzUdDYoRb29uVlUPiqxIWIGussL8q
	84Im2ZGkMpR5XuEM2V7Cdf1cOr9/bkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BDA5437D6;
	Mon,  2 Nov 2026 14:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A371F00A17;
	Mon,  2 Nov 2026 14:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629708;
	bh=VsGmMsU5ViaEXrFm2/HEk+OSOttZ2XCHXLgyJx8eD0g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XqeV2NQmybmcQpQCfl29ZjQwKCUGyTxg3Lk86HZD3i6fKefYdRhi6Czqkj/uY0gbw
	 WIMDP6xlkx2+VEkRPOdds7rQS/Uyu9UXSkxhmRXEhC5evtJOy9tI/yOL5szCJhbeLc
	 0E5d3uMaycB0bt6F9SqARsY6HZ9K2Zfxz47uxakdila20hiMIqVwKfumClrZvot30Z
	 0TzxA0nOHiKy1ykKqAGRyBaWolaL8pxg29oFyVMB6WnCop+8tSXpiWoJYlA9GSs8di
	 n96TiYbYdDvUjg9bfLf9swi1GEQWlrFWmIElw3Xf/XFNUaLj2StS2zAyQW67MjajXk
	 tc+uqwcEoZ88g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:44 +0100
Subject: [PATCH RFC 29/38] powerpc/pseries: bound the lengths in the ofdt
 property parser
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-29-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4036; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8Hd2AVI62ImOZ5MsmuM9jPXUwAC7qJ+A0OqSTVpNjVY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOjt7/StVJ92/OGaG62tVk7lptsnry1XOeEU0MEt
 6WRwtT+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImICTH89xVRKXt8brGes8gD
 hbehWc6VDwOeTlTd5HNl61HeI6E7HzD8D7LS778lssD/iJNbEMt1XRWVzwwGj4q5Nv1edEZE+NV
 ibgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DE90180005
X-Stat-Signature: 1o33wac4bz6dehftzriaf81nnqsndg46
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629709-668629
X-HE-Meta: U2FsdGVkX1/UQcWpdZxs2H/KfDSwa7ntsjMDsVSYMR90xGPl+5sj1lvtaYWYMfj3IxBAUan8eUqNogox019IS+QDWDLX1EyyXvTpDigOLlbnVAIDxMzwyGsdfakGZOPbFEtsus2AYnxWVAZb3OniXlqSr2ZXLo93xVowf7TocB5iITtKphD3u0K85ll+NnYo0Q4Ert+8J0cGQWhTHk4gepSSC8nLECekFE0vhfSlfjsW8L4PyhNfgQn28WIAsz9q9H5KLDAyY88Jp0B+lN8fhbQjEjqOi5LQNPfLTwDm+8Qx572eA0xHKHPqOGeUkXFGxccgC3NTgNY8ZQVmhYQbUc+J7VVHIrQiIdw8rYOVm5s8owcoZFSxETnt6OFQSgowNqVT5u+OkNmpzVndZm/jCYHfvdCWZFj32S6cFLv6VvAeoWyqbVsqslutMSMj5mOgReRPrZrqV0Q/B+D70ICWRO1WygpYeEbibY60Hpi+b0EojUtEmdFkhsXdCHbkZY2txH1mUGdNvS5pO1vecLtItszR7war4Y2z+MN6qjAazAF7L7uZTynPTjlCrY4EomQEoUWsOuNGKTq9yt41fEohdQ6If5Ej8zTeeuGcq2sIOgPIb7OuSHzG39i3NpqHgRnj4HMHEs9mNjDPJ26/sEabufOAz4e4sr82dUOJzRPMv+sYPNjjKwJiTj32DA1kzdSQHICjDw+AF27ynRagP1tPvKnGDMbnVl7COFwUj7gzEsDx4Qf364uXjqQmLYxDPYa0uqhmqHbE2vq5ijMixHk24Sr+5B7uMhmD/DIE/nd9tlc+wZuZDsrfIksQleZFIb3FdTx8BaaykLcXhjneYz9Q+0xVzdOSBz34vD0xGVdQzfBgLHYJGn9BphumC/A/d2C8zsPxtslJDYKX3Ret0rOiKVa+lxygQCICAQcL/HGbO5Pz2y4ZYDOmpsOkFbdALhRrSszULD8jLRdGo7xvDiK
 jf0eWVjr
 3PyYomLYRNElPNoPLg0Q9Ok16MvlMdAj3MrCcMwdyiOulhP3SCUFAmFdAuGQUcfg77bfplVyFvW1jQrttpE/0DSQ/jsMaKaKduLBN6Wr6octlW93SENZ0fY8ymVzE8maQXTItISVJ1PtrhbSWaSTy7SgigOUlSW1ebDALdUy8IcrQicOM4uZBJ7LRcNyZ9h/23m6xmn3TrRjbezF3lObhtEQmxJEuz0fpMFi0m7V9634Y5S4gufWIO5dHWO7mSclm/dPpUDPWGaZT+BktAFs3xO6dCUdyESO03cRz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The commands for /proc/powerpc/ofdt that carry properties, "add_node",
"add_property" and "update_property", can make the parser read past the
buffer they were copied into:

(1) do_update_property() computes the end of the buffer after
    parse_node() moved buf past the phandle. So the end is off by the
    length of the phandle string, which can be padded with zeroes, and
    parse_next_property() accepts a value that reaches that far past
    the command. new_property() then copies those bytes into the
    property, which everyone can read in /proc/device-tree.

(2) parse_next_property() parses the length with simple_strtoul() into
    an int and only rejects -1. A length above INT_MAX turns negative,
    tmp += *length moves backwards and passes the check against the
    end, so *tmp is read up to 2G in front of the buffer.

(3) Updating "slb-size" or "ibm,slb-size" reads an int from the value
    whatever its length.

Compute the end before parsing the phandle, reject lengths that don't
fit into an int or into what is left of the buffer, and only take the
slb size from a value that holds one. The file is root-only and
refused under lockdown but the parser still shouldn't read past its
input.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 610d91511f99 ("[PATCH] powerpc: Add support for changing properties from userspace")
Fixes: 46db2f86a3b2 ("powerpc/pseries: Fix to handle slb resize across migration")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/reconfig.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 18e3f1a036e3..b41c5db726c9 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -114,6 +114,7 @@ static void release_prop_list(const struct property *prop)
 static char * parse_next_property(char *buf, char *end, char **name, int *length,
 				  unsigned char **value)
 {
+	unsigned long len;
 	char *tmp;
 
 	*name = buf;
@@ -133,13 +134,13 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 	}
 
 	/* now we're on the length */
-	*length = -1;
-	*length = simple_strtoul(tmp, &tmp, 10);
-	if (*length == -1) {
+	len = simple_strtoul(tmp, &tmp, 10);
+	if (len > INT_MAX) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
 		return NULL;
 	}
+	*length = len;
 	if (*tmp != ' ' || ++tmp >= end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
@@ -148,13 +149,13 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 
 	/* now we're on the value */
 	*value = tmp;
-	tmp += *length;
-	if (tmp > end) {
+	if (len > end - tmp) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
 		return NULL;
 	}
-	else if (tmp < end && *tmp != ' ' && *tmp != '\0') {
+	tmp += len;
+	if (tmp < end && *tmp != ' ' && *tmp != '\0') {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
 		return NULL;
@@ -320,8 +321,8 @@ static int do_update_property(char *buf, size_t bufsize)
 	char *name, *end, *next_prop;
 	int length;
 	struct property *newprop;
-	buf = parse_node(buf, bufsize, &np);
 	end = buf + bufsize;
+	buf = parse_node(buf, bufsize, &np);
 
 	if (!np)
 		return -ENODEV;
@@ -337,7 +338,8 @@ static int do_update_property(char *buf, size_t bufsize)
 	if (!newprop)
 		return -ENOMEM;
 
-	if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
+	if ((!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size")) &&
+	    length >= (int)sizeof(int))
 		slb_set_size(*(int *)value);
 
 	return of_update_property(np, newprop);

-- 
2.53.0


