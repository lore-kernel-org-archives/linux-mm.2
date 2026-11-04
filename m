Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EFA606B21C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LcsHmz5f
Received: by kanga.kvack.org (Postfix)
	id 6CEC96B05CE; Wed,  4 Nov 2026 12:53:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E836B05CF; Wed,  4 Nov 2026 12:53:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5496C6B05D0; Wed,  4 Nov 2026 12:53:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30AB56B05CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:53:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4F711A0601
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:53:15 +0000 (UTC)
X-FDA: 85398183150.14.E8630BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E341E40004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:53:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LcsHmz5f;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dtN9D2ek/PODLB9eXKISWT+1DyRVltUAnsYO5R4w7M=;
	b=sjeQ51aHDx9DsrOFX3qeXx9rZxwtIuhy6Odp0lef/P2/EVYLgUAj0dNNTogShTMyzIrIzm
	sdP7mXv4xfPmpbl/4BOFt7RYgDcHh7qNhzJwS60dSvCgTiFYlCI362Ntt/N/IxnNeZ7L+p
	SdiwnHCcNnM0ZB/t7lSQ+tTfUH+iKLc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LcsHmz5f;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814794;
	b=OQYRmOGuKDUJokQHc899Fm01zKHWqg3FDTR8weua2S2kQ8mdoYgJhaOeT8tsz5h/3IjSub
	DQl7+yI1d4X6XrwExC3d7QZqN5JCqlsMYMXeWL3g0HENQ3ZhoJG5mGyoB/GLJmOW5Rk3ql
	fulDXjTml2gwuhzJdRR4UFf5mM3TJL8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 322A643C0F;
	Wed,  4 Nov 2026 17:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924261F00919;
	Wed,  4 Nov 2026 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814793;
	bh=9dtN9D2ek/PODLB9eXKISWT+1DyRVltUAnsYO5R4w7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcsHmz5fK/rq4Bthqez6bEjgj3XEj/c4XKC7cTJTsyy7D8CM7px4kYtiPIzpCal3e
	 YBnBaglaHwrkG0flLB3F5W7+c/cuVEsjWKHrViqroXNJjS/gLfGejJZpTfdZwQ3hxC
	 MmTHns7R80U7RN5yvO/p+jAHpSlpp28zonoPL5JONcxOoGjLH7eL2t5N/YO/Ar8kN9
	 Uv53YRcqkSaZvuCyD2wDiglbNsEmatVgs/O4H1aOlq+Q2Fx7/kPdW3ED163deYMdjW
	 mzDyj/1PR2eJIDW/uTXVOsrPDnM7bk3qNxgMT69wH0jr1TOdByT+AbZB6eZHAK8Tua
	 TqbNm9ftkTIoQ==
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
Subject: [PATCH v2 29/51] proc: don't walk through a non-directory when resolving a name
Date: Wed,  4 Nov 2026 18:47:15 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-29-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2403; i=brauner@kernel.org; h=from:subject:message-id; bh=syoXv99Xi8HZbn/gUZHMWCnjRlLtpR5bAeJLx/CLQI8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znvEfdPiys++q6WXg17bqvjo1yRcanm93G/LTAvP+ yo6V5wqOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSps7I8Lk1e9tBje0T0qw2 XN3x9V66cYxZdMKvVWWifA53/z6tv8nwT2XZnUOOz2p0hO4vzbeojJFe8k4sMSUqVEPr/fE7CSI PWQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bc6ueog89hu1aqh4zth4nnb9p455861z
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E341E40004
X-HE-Tag: 1793814793-553654
X-HE-Meta: U2FsdGVkX1+jUPhpIZPmmGDsmv6dfddwgfWdiMCvOWiC/L13r1LmhDxDlX22pQWiBe3WP5fwqddzmqtuILGRGEwrGHt35o6aNIGvCFqDnZ52aRC1LjMtXTFLcUP4gUrnBpWPFecvErALt0HYa0Unu+umkkJiVc1nrtv395KxFSR3sGKQUd3ODYNtX47X57+vEhkN4OoIpj7B702PJmV5clt9LkWDOyyGBkjxckNNwy+YVhJvc5+LCYKpn0AqqV/5obxWsoEVjP5v6nsfO7pgxlCP4/+/leyfDHSHwFYE8Eg7te2EQF5bMueeZ8PcmLXKA82Kn8WvFPPlafJjR/iBe4F4c9rUQsdIi7U0kudcTuuoo5N0GQVgxnPkgvAP38v9F4tWw2b+HFyjVMwdCCbi+9uEyxI7LuogNJGvh8THa8dztq9fiCS6yTQp58HZMKu0D5owk24fP5UKX3XnfEzNm4emV2hQHiaaG5WTAPiwAi1DtNkWoyBc9X8/kV6+GjpD7OBI+/vcoeJ3Ko6wlx6+YTssAwb7jGaLevg2zRblvCckue0uo5NtQWmPIjj46YSju0qjNkJ7hTIDvQ5RUtFStoHSFC50idK8CuzFTh/UH65xQXmSIXceKDqtiyJeQDcbDQ6H9jzH9Cnoz6k/uD+WBjuazgTyuuDh6/kx/a8gF3LzE9N756jlkdFPE94nGflSjdTllwa4L59yYCzreBglKl74nyEjm8voePKAceEpZ3XkX6ctH8kiAT45AnNfwfTWAApl0aTAiVpy9qsC1pan4li5l9VRelrGpeovVR0SADdKagvVcR48ReeR8ULl6dMvyGLF9rYdIm7MnGAFOwKB9z+pAwuukPDbFgp2bnYLCcjLyu5kMNzEMk6DRRCgqZ7XsoPhQXUnWoJrowMAk3XOLMMn2z/wq7XAu0Btijw3l0AxtQWCyQoEDRql/XkGJwHuMnvw2OWtEMTJOVXeFZ1
 mulf9yfv
 sZAmeocO47qh5TAyltNaxEcV1rKOCCgnZ380a2vMhQBawXIet/s1EcDqw+siiXqazm1WPx7vZDvm6DsnSZnIAmtHmJnKWBM5VxH7j1HeYYdLSuTDIU5XwKe/EJ2I1/zhdKIejttB6BTlZTONQQRMgeN1d5vVhJ2AGzOQPqIEuHoatpuVKoBaqumi9byNng0RAao5Rec1MPV5EjuuGdVzHGbTDfY6Wu0hGVOYOWx7cM43LPXQEaZDbM9NPmXP4vUxksYHhD1lz+9vvHV7NB7CY9uYmp3j2bI/lbeQ8QKTgfOV3l9gjBlyHGLy09Uoaz+2YyQtWGZUTYcuxa5rRxrJCwFdZdRyVu0aOdM+Ld5Uwvrvk4QsS+CEDbKgAAAMO14r2zyh95ns+saAXyaBuR5lseuJe3OZANyIzPwbR8JbKDAfH130dBiqUxiV00w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__xlate_proc_name() walks the components of a name like "a/b/c" and
takes whatever it finds for "a" and "b" as the directory to go on in.
It never checks that they actually are directories. So
proc_create("file/x") hangs x into the subdir tree of the regular file
"file". Nobody can look x up there, but remove_proc_subtree() on the
file removes and frees x along with it, behind the back of whoever
registered x.

pktgen passes the name the writer of "add_device" picks to
proc_create_data(), and only the part in front of the '@' has to name
a network device:

  echo "add_device lo@"   > /proc/net/pktgen/kpktgend_0
  echo "add_device lo@/x" > /proc/net/pktgen/kpktgend_1
  echo "rem_device_all"   > /proc/net/pktgen/kpktgend_0
  echo "rem_device_all"   > /proc/net/pktgen/kpktgend_1

The third write frees both entries and the fourth one makes kpktgend_1
call proc_remove() on the freed second one:

  BUG: KASAN: slab-use-after-free in proc_remove+0x8f/0xa0
  Read of size 8 at addr ff110001134c8e70 by task kpktgend_1/243
  Call Trace:
   proc_remove+0x8f/0xa0
   pktgen_remove_device.isra.0+0x118/0x500
   pktgen_rem_all_ifs+0xeb/0x1a0
   pktgen_thread_worker+0x1b42/0x7280

The files of a network namespace belong to the root of its user
namespace and these writes don't require a capability. So once pktgen
is loaded an unprivileged user can do this in namespaces of its own.

Treat a component that isn't a directory like one that doesn't exist.
All names with a '/' that the tree passes in as literals only walk
through directories. pktgen is fixed separately to not pass such names
in the first place.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4c3fcaf68ef4..6ac9c4c13897 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -170,7 +170,7 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
 	de = *ret ?: &proc_root;
 	while ((next = strchr(cp, '/')) != NULL) {
 		de = pde_subdir_find(de, cp, next - cp);
-		if (!de) {
+		if (!de || !S_ISDIR(de->mode)) {
 			WARN(1, "name '%s'\n", name);
 			return -ENOENT;
 		}

-- 
2.53.0


