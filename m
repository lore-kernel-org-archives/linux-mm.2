Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963C2606A87D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtj+GH2h
Received: by kanga.kvack.org (Postfix)
	id A16096B05E0; Wed,  4 Nov 2026 14:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED976B05E1; Wed,  4 Nov 2026 14:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904566B05E2; Wed,  4 Nov 2026 14:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2E96B05E0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:47:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CFA4C0865
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:41 +0000 (UTC)
X-FDA: 85398471522.01.8B35C2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 449A218000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtj+GH2h;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vfgsd3PUinlq5Gnmk93ZNsjvWtIfYjQstKDgqXFFHmI=;
	b=oTBy9gmGhue/kLfWITrGeobJvJ1+OC52WSKH4ewtvmO9L2pis1CEEAnNjXH15GJkiiilp6
	ZaTmpdvWxQy9qDyboEgXG4MOTyO9YlEiid7CUZq1dbVgZGZFt7dDrA37eIw1M1k8G+osXF
	TdF5rDncmNfoKRoCxY/NjQbAPEUqxUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821659;
	b=YvT5ROOVksW3L82kWuM6BhwN+Vv5VkhqwzE37clviF2BGN3Eu6WPgOlY5c3yXuJBT8/ciE
	yHB/cpPuq+4jYLx+yjxq2zfbQninXQXQhJfQuvsgEZmMJwh56upHgVsVKrVskQTO43CEtX
	LEWczCaXX+Bs5dJ7LW/HPqps5Xsskk8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtj+GH2h;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66EDC417AD;
	Wed,  4 Nov 2026 19:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D2E1F0093A;
	Wed,  4 Nov 2026 19:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821658;
	bh=Vfgsd3PUinlq5Gnmk93ZNsjvWtIfYjQstKDgqXFFHmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtj+GH2hqTPplDjhVzhRAWhU8OkVhPJPP0JLMRwTbfdc+nl4HFqaLUtkQ0sGqY9p1
	 cio3rKWjRbaW0hfoe+iR5yUiUxGlvl6F9N71fZhbqKX3d7khRaPNZmLb3yNj8B0VZt
	 vYfLltTat3exR0SQB7Uf68Jxi/SRcYyBvdcK5hbQj2/GV68lWs4IX74yTfnWqymq82
	 M8yspGv/K4UmZRSLladjige3wPn9EOhryHH1PaBstskLXXtn/pAaCO1Kia1pLxX1NY
	 C6gBdMcfP0MHCUtCGkHA2XBsPT4EAkNI1eiSvXtWEQIDsoCAj2OLDYM0olGMiVe6SX
	 LvO7OJ7dWJD9w==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 21/26] Input: let procfs own the wait queue of /proc/bus/input/devices
Date: Wed,  4 Nov 2026 20:47:23 +0100
Message-ID: <20261104-work-procfs-drivers-v2-21-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2424; i=brauner@kernel.org; h=from:subject:message-id; bh=cAurGI8IRWHsk8N+x2SlkH9/s4vXIqR5KE32d74H9dY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97uoVPNHOMiVW7/vlsMd9s7daas+73xSQc6TwtsuLx am89pNudZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk6xbDPwufULMS+bvROaer RY/ePlP4dAePp5GonG38y6XNHTtmb2H4n3LmTr9vRD1nY+L127WsJ/1+dr1MjVS/KzLXyCg/wcW ECQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: in4ea3eyaey73mrjph45tyo1ijmtpc6d
X-Rspamd-Queue-Id: 449A218000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821659-416336
X-HE-Meta: U2FsdGVkX18PNUWgWCs+kK5xqPf/eLaY5hL8g1oCbIkPJp/czyBfLnbhU/VVfjse5kOTH5FwcuK2ZJUI0B+lkw1QWb2EUve8Wq2MIs6USY8ziFmoYIBszIEVS4IWHdoiBOhSxcAu7bKYzyeV1tVN+mkC/LhKQEbdC8wjS4tQ7XwjdCGoMRWb9bwFRFhc0+qdPMZee1UQBt0Md00RMd74v6knFlLvD5jvNGz0xoMCMS6eHuFHkKyNupRBkrUJHdVZ50/97SD1YOHomwRAD6UgtCKfjnpi5hndfLLBEco9qGgdEPhOnKhaL5pcjevYgsOLjTMkipO6QlzV+/pPWdcmQg3l/6W3YLLOBJJDOACgoz7Kvu5Zm2bI9mYdGSf22YDs0Lo46kQr8MbR6zG9k0kGtVSizakvRnyuTpuY8jckMa+iPL/ak04L1SGaFXlFTHOHiK2M5nGbcWWncpsHOxGcMhmrfxTAB/fabCoM7ntZZqnJVVFz7xsXFjNoHx+CtO2IqZnrGnmfiFuVF6EgfdltkExpc0UJMyOKN7vx+u66Yb5RaS2ByhtcvxdOK5ZKLg06Q/XaKzOkIqOChEN5XlubkpuvgwVy2WMnH9zKHGZySyHGqiCudQrzF/FtaE6bBlpcx6lYBTDcq/eNXE0zYtmbg/xyDLB8UAeKcol2YygW/vqi7oilAV1M+1BkalJVAr+eoMape4E7Hj1QX33xZnA7RliM2Ur86rTeqhJjiVeMZkZo3yTeN5nIXT6mFQiI+K7/MXCLkcxHheR9Oa3TvRXOR/pUX2dSJpr6aTMIsbj3QMaZrvebEbgduSOyos+V2zMA7yU4qmR5xd12jo8D/lzIEVVULLAz7+hUXTjBZnazIeuhyoVJ94s+uov+xEu7P2bCo7eGEQK+9kgs5coBgMCLCm4Xq5/C3WswDGzFhE3VaioYzaIHm0Yfn79e0wPzbDJA/sfrUHa0qKiTzt0kr2d
 VqaP18YU
 fxk8loVU3YE4axM6gjp20XHEQQcqMlbARfkAXLrOA80Nlbpu/tjZ9Zf4TDA6Ytg5bCCcC4UfOFR56FnNsnqn85TDo0DZ2yDtKWrnGY5l6X0loFiyj+bUuSRl0jVi/3PI9reeGgLxLrDQ0rjW0KaOFnq07WzlI4YVwb3JGBl4Ayig53p0OAR2wnu5i6enDpJ9toaEPYQ1b9cd2IsoZMmo7BrOYwEENyqhmIOHZJJuFtz++413Oy0E4s2+fZk1yPSE3awiJ2aOOuV+eXN598TaLxS+H9Jwd9lFjhRGa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

input_proc_devices_poll() sleeps the poller on a queue of its own.
procfs owns the queue poll() uses now, so leave the poll_wait() to it
and wake its pollers instead.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/input/input.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index d27eecbf4a03..a984810eb80d 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1082,13 +1082,13 @@ static int input_attach_handler(struct input_dev *dev, struct input_handler *han
 #ifdef CONFIG_PROC_FS
 
 static struct proc_dir_entry *proc_bus_input_dir;
-static DECLARE_WAIT_QUEUE_HEAD(input_devices_poll_wait);
+static struct proc_dir_entry *proc_bus_input_devices;
 static int input_devices_state;
 
 static inline void input_wakeup_procfs_readers(void)
 {
 	input_devices_state++;
-	wake_up(&input_devices_poll_wait);
+	proc_poll_notify(proc_bus_input_devices);
 }
 
 struct input_seq_state {
@@ -1102,7 +1102,6 @@ static __poll_t input_proc_devices_poll(struct file *file, poll_table *wait)
 	struct seq_file *seq = file->private_data;
 	struct input_seq_state *state = seq->private;
 
-	poll_wait(file, &input_devices_poll_wait, wait);
 	if (state->input_devices_state != input_devices_state) {
 		state->input_devices_state = input_devices_state;
 		return EPOLLIN | EPOLLRDNORM;
@@ -1284,9 +1283,9 @@ static int __init input_proc_init(void)
 	if (!proc_bus_input_dir)
 		return -ENOMEM;
 
-	entry = proc_create("devices", 0, proc_bus_input_dir,
-			    &input_devices_proc_ops);
-	if (!entry)
+	proc_bus_input_devices = proc_create("devices", 0, proc_bus_input_dir,
+					     &input_devices_proc_ops);
+	if (!proc_bus_input_devices)
 		goto fail1;
 
 	entry = proc_create("handlers", 0, proc_bus_input_dir,
@@ -1297,6 +1296,7 @@ static int __init input_proc_init(void)
 	return 0;
 
  fail2:	remove_proc_entry("devices", proc_bus_input_dir);
+	proc_bus_input_devices = NULL;
  fail1: remove_proc_entry("bus/input", NULL);
 	return -ENOMEM;
 }
@@ -1304,6 +1304,7 @@ static int __init input_proc_init(void)
 static void input_proc_exit(void)
 {
 	remove_proc_entry("devices", proc_bus_input_dir);
+	proc_bus_input_devices = NULL;
 	remove_proc_entry("handlers", proc_bus_input_dir);
 	remove_proc_entry("bus/input", NULL);
 }

-- 
2.53.0


