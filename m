Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1F560756D0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hR983dtE
Received: by kanga.kvack.org (Postfix)
	id 214A86B05D2; Wed,  4 Nov 2026 12:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4D96B05D3; Wed,  4 Nov 2026 12:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5106B05D4; Wed,  4 Nov 2026 12:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D24356B05D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:54:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C186407FB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:54:01 +0000 (UTC)
X-FDA: 85398185082.16.071FCE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9845040002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:53:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hR983dtE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxrLiMapbfHc1EZ+4ADuNXD+VcOTR1takrrVPNDTeA0=;
	b=U+zb7WDofM7MFljo3rHK6jDY/8ns+ZRGIFSmInaWmi5vOcq0+oRVTDDHG0u1ub9VUOeNhv
	JsMyJ4u28EU0vcdaJSy1fWA4D//k8SPwoSb6EeKPnr/CR2MZrXUNxd2gcKITdHi2YEzXtT
	PQQIsmGcAA59gvZpzFF/iIzXnviplvk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hR983dtE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814839;
	b=LnfBzqQZFmL5y8+wZEoIm52W9doO2IhS+bjFfKPczkuom/Zw+gqbIf5Zmg7PgTS4Gcu34v
	RPuFuyRf9OBRyDB0ThwNnrB79NxTLop3saMBOcB9rL1Ob0Vuajx1yTOayMZGksOY0hcYTQ
	DrtUYjJa1Htcyik57My4JVduBdCjCwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15A9A60A00;
	Wed,  4 Nov 2026 17:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F761F0093A;
	Wed,  4 Nov 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814838;
	bh=bxrLiMapbfHc1EZ+4ADuNXD+VcOTR1takrrVPNDTeA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hR983dtEUOSoR1nExeO0GeUwrjO/mgN+D93Hhi/YSJLgc+1HDjfD6+S1cMOHcfPiT
	 EwYGbEXBA/2fP9wa9RUJc04pMLMUFs6iNYt5+uuoKFrGCAZ+txysVQRWfJZwCiA+36
	 Kv6xb59h1lmkmNz2gcyZtJxNxT1pTMrmjXv0sxgWirSDR2g3Za04iKGP39Hj6YdQTl
	 y5FF0uUYM1eHAIlFWaGpq2EWgbuk/UufrvUpVcYmkznTkZZpAQ78QK90TyF+5BousJ
	 jriw2793lOU9jehM5A4wHIN7wbucrDzox4jCw/nDBd3RuuoodmWGmRhfe06iR5wnpq
	 9u9MNzXAk8L5w==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 31/51] proc: don't WARN about a name that is already registered
Date: Wed,  4 Nov 2026 18:47:17 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-31-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2415; i=brauner@kernel.org; h=from:subject:message-id; bh=zKPnydEa7A3MJSKUBbljFnXGgiSfil9PV1OK0LsDT40=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znv6v+fTdPXzZly6K78zubTOUDi3Ruzh+oLLi/f2t ta+4ivc31HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRMA+Gv0Lp97/U9/7qeXCd 84skr8y50Atv1zx7Ez9nf/97g/QpR3cw/LN/tfm1hsfnn7JPfh8xM7OMOVTLOG/+thWN9s07szU vWjECAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9845040002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 99k6udfbmjngp73fot7qu8dqqmc6btwx
X-HE-Tag: 1793814839-154105
X-HE-Meta: U2FsdGVkX188CodjP+IxHDn289yqpkhhxdhuad223VBlE9XVdUuna6zuX0AjB72zDJfaNArcAqBL3rhCWBweQNeOwQzdOlZyrRnpMJ2I+kFwjd9fa5rBWJQCPBDIg1Vk7ZTZiaiZPZPWmIBoXwAAghStPtecn7VIYC/5+rQ3DaWYkfhLfjnSGXhcxuBnSYPz7Sme+XFMk3HWTZCX8R1f7tGwJW9LY82LK90CKpZNxNSxnU8202fauZHYdsy3VJ7ycDF3yn4lXbCeFDqwSmATepmtNx1XAc4ZV37nEtOtCgCKJpkjWinbtZoRtB8ioay1LixtuPRm7gxQKKiYilDoFDa2EY41hiFALd0Mf424gqW/7dAGt9qUZW8z53wNA81nnn+BkyOuoq9LOfoTam9V0VisLiXr/rWSS+dqfUIWYqXgOVXd3at92v23aVKNOhDCmGs2pzFkJHhc3Nbi1EFcAfrwsCxpqlZzaa5O49BCYdqSiWCr4HLVWlPwuwtGYHb/EvsbUljVkTvKuKjiZz/nnjshkZ8GZo9UT2H6pxcNHtIX2lBACw62sNCeUbTRAIeTMY60iAdwMm2PsjtEc6CQw8cti11JjAXwx5J9jy9pNRVOvnPhqSfVJy1KkfePeI2ZnJFPcsHvFYEfah/Z+GxWaS9rZMX2051HWgPyFFjzCtfM9VTLevkUKVVYPgbYwEXqcoGEguTDAJwpj3m7C7V7CxHU7IctBP6ge1BQUzOSj2jU7H5ERJEw7leN6WjUAQPRkxtArLzUSIUPNSGBN7jt1giVM8x2sYzAN4c8ESfxoCFplQwNWsvdESbhpgirLAArzrNH2Rx47qD2dp5P9Pd0a8HjGfat+MgKW//Z6GMHjDgsmzUDUE/kwdgYGLnoi1cjyuFCVY6BXGUIczYhvY5+e8Ejhy1BU42fBjDVnX3hxkIZRLF+1PuDrP+rcMPMX/G3DT7OgrH3dEqlPED/rWW
 FDB5XSxN
 7AdA1r6+pGlVGaHNl795laa2REP6Kmiked6fOuYHd2Z5E4I4OtXJCfPzw8qBHYN3gSvmLo26//+vKrvZ9JemQZ+l6Ay6dxJrhyJVHajU+X4HrMctlkwKzLZxL3h8jTQdKyZ3TehxNvhRWowVpKTiY8pvFF2wuCGysYuVRkkcxk5xl5NhDHlfam6JURtWrcxImi+W1A/ExylamltO6851Rd5HMRF+q9FNNVelNGa+4m7NoPXjNXQU0qzLRfl1+N33GEXnSF80RLiL7AVW9f2Eo8Un1sUz6OFSnZu6WPgf8QDqBdNui7rla9Nh/4Sj75EbgixF7gokoYbJofrm1ho5tYmimYxsrNPa/p90pXSJkeglQqifp0QFhZhvT22LVaajhDCDzigUaMufDtl9iJKfPx1kqpr3XaAcb2n2ASsQ68h/T0tU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_register() WARNs when the directory already has an entry of the
same name and fails the registration. Callers that pick their names
themselves should never get there but some take names from userspace.
pktgen creates a file for each device a writer of "add_device" adds,
named after the device. A device can have any name, including "pgctrl"
or "kpktgend_0", the names of pktgen's own files:

  ip link set lo name pgctrl
  ip link set pgctrl up
  echo "add_device pgctrl" > /proc/net/pktgen/kpktgend_0

  proc_dir_entry 'pktgen/pgctrl' already registered
  WARNING: fs/proc/generic.c:404 at proc_register+0x555/0x8b0, CPU#0: bash/241
  Call Trace:
   proc_create_data+0x9f/0xf0
   pktgen_thread_write+0xd9b/0x1780
   proc_reg_write+0x1c2/0x3c0
   vfs_write+0x1cd/0xfa0

The files of a network namespace belong to the root of its user
namespace and none of this requires a capability. So once pktgen is
loaded an unprivileged user can taint the kernel, or crash it with
panic_on_warn, from namespaces of its own. pktgen itself copes with
the failed registration just fine.

So go back to what proc_register() did before commit 6c2f91e077f1
("proc: use WARN() rather than printk+backtrace") and what
sysfs_warn_dup() does for sysfs: report the name with pr_warn() and
dump the stack. While at it, do that after dropping proc_subdir_lock
instead of printing a backtrace while holding the lock that every
lookup and readdir in procfs needs.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 6c2f91e077f1 ("proc: use WARN() rather than printk+backtrace")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 6ac9c4c13897..9e59796349e1 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -402,9 +402,10 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
 	if (pde_subdir_insert(dir, dp) == false) {
-		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
-		     dir->name, dp->name);
 		write_unlock(&proc_subdir_lock);
+		pr_warn("proc_dir_entry '%s/%s' already registered\n",
+			dir->name, dp->name);
+		dump_stack();
 		goto out_free_inum;
 	}
 	write_unlock(&proc_subdir_lock);

-- 
2.53.0


