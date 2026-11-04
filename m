Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32ACC606D4D9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUjVvSgY
Received: by kanga.kvack.org (Postfix)
	id 4E0366B00EF; Wed,  4 Nov 2026 14:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6C16B05B2; Wed,  4 Nov 2026 14:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6C36B05C9; Wed,  4 Nov 2026 14:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1982E6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:23:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B369E140837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:21 +0000 (UTC)
X-FDA: 85398410202.27.B6EFC97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01BDF40008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUjVvSgY;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dtN9D2ek/PODLB9eXKISWT+1DyRVltUAnsYO5R4w7M=;
	b=JAnplDZem5F9LNrha3vlDlv+V3I4frhbEHyPC06Ej9oLnAedQganO5RmcLv4IkwDNgQOgQ
	R+NmNLhaocHk+vTiIg+aQ5EQJcdNhnRMV7QPzgoNkxY0+V/7ZMex1aRK2HfdWunvXbRi/f
	Vuq74IKyEBqieg9senm8IPeLBv8GM7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820200;
	b=nRlkK9WjrOP9vj12UfIfQcu5X1IPZwHILGsQt17xlNmy0BCEPla5fmarW0HHCJX+ldbsIj
	0Nf/a4b6MFGtpW7ej3MB/VEBejVgj9J/8X7ILMtDUBr0X98uHBv/lIvW4xP4rBTGYw6g0H
	7px6M3ne64xGLeTGjwwu4c772g6HL/c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUjVvSgY;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 775D060A82;
	Wed,  4 Nov 2026 19:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055C01F000C1;
	Wed,  4 Nov 2026 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820199;
	bh=9dtN9D2ek/PODLB9eXKISWT+1DyRVltUAnsYO5R4w7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUjVvSgYe5Hj7+VHJxqGCdVuPZtH9TtLIRIu84V4WAA6vFP1AvkW+oSj/edLc2ck/
	 AAJWe21jGN66rAVWXOLHwrW3BkgJ7C5MMC9kqPjYIm9KMsBUn46oa0vCJA/TU5q6rX
	 iH5MZ7/d6lbSeiP9AbR9i30r2ap/96zzZx+nemJvi6mhYtlWM8sEF2UUpZwV40I+z3
	 +txyiwalAfhoSb0jj4BJxzYGfVLI7LPAybYz/+TrWrBDGQ0NUDbS+hRxwxJlmPbijJ
	 EE86e3tlHpNNL7Pmd5DKa/IXf1VMJPtPlvfcVaYXoetHk9VmlRKFC3n8SLFdRpRElE
	 JRmL7ZtyfUvGw==
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
Subject: [PATCH RESEND v2 29/51] proc: don't walk through a non-directory when resolving a name
Date: Wed,  4 Nov 2026 20:23:04 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-29-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2403; i=brauner@kernel.org; h=from:subject:message-id; bh=syoXv99Xi8HZbn/gUZHMWCnjRlLtpR5bAeJLx/CLQI8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnzfyJTJaHMu41dep952AaYXinG37t+WyDPu5f08x dN5TvXxjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImwHGP4n7qS/1/T39mfA+ez nur5I3X/0v1ZE26+TomYpu8oNvN10zOG/0VzMx60c//Q3nGn5Li21/MFnmxuVnN23S5+YyFT+l7 1HzMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01BDF40008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: mxw9ine1s5qqrseugz8i1gaegpz91zcq
X-Rspam-User: 
X-HE-Tag: 1793820199-754978
X-HE-Meta: U2FsdGVkX18LVk4vxOs3UQdjpG9TG/yHfTPEE7UiytcwxgUNIMdyQaFlIR+XO+bByeOc9q8gRSD9K7/y2zHbTrO4oUB7uP2cBGuYPyecMwd4F6WfOqEBgvhSLWcNGxYv5OtDpqfrKjPYARfXlz/DIlzBH46hFf71e1RT99df9rv1C0W5ZTwoh+fQPJSIcWBSNPMrsI/YDt7Dzl3gkFCUyxccNGbwURTXi1DNeOoHxzDhX3JoUUla2W6RTvweK3HO/elBy40u4MCXywUperCLObEDS3rctPiNUVZc1fkgFvmTn2y+kiefAMJs5+h+XT+9WRo474tMpKEI89ki8ckCvWpnywCdKTk7YXh0UOTsEDXU27e4pVEbIoDZ2XkDU6VEQT/WTNii/NJPu+AdxesFyQ8wdPXh+cd1un1gIUNKkq8nb2Y4w4cY7oAc11tBHrEgyUSjGCqQC0w7VZ6yltPtFdViAwbcd3A/SbmH7AaX3UO5jq8o0GaaxZg/uV3KSEMT5Y/BJfFS59jRi6LMPaMB+cmTICPL/LZnvE1r/vuyhH362XG4qW7HqD4jWd76wyQzjG65CYtDD5uSotswxLMN5czDovMFMecY8OT1QVVvgduOJ/uTYCPzh1Z39M+Nmum0pgQw58XUweyWGcB8iqCBWta0qrlLvb7MGryXyoMTsZGi3LaBj84zy/4taNJ4PG61+Pr3z6P6aQu7PaZc+QyvQf7Hb1+UTgTDxLVm3kwPEFxCKFrXo1F5EJwIuFNG+9QVDswyP9BEwtnL+YMwClFRDpfNcDqw7sbiwzQvr0AbKNViy2LrXoVM7+j1Klk4bi4Mr98zepE4bOyINLVApNoBTKhTrVHrs5Tzg2Wy7zILOYvuHH/pZgxak2XEgXnXQ0B7xYMx29PvYKDibqYSoNkQ/T/jerUbszwy9IEGIfo/8rH6z2vfsaCy7Sm3qc4mvT5PMtAsr+y1Y05WJLobuQu
 8H7PTcRJ
 EEct0DyuwTsZDGvxX6W+h70NAroucz9+69iL/TiFy86djpU5uph2ymonqiGg1KUgtSL2C+g7J4g8+MbDcFLgGg79RsC/C8c3FLU5BWYrJVep4elTnz7ensZn7sJ+YR26repLWTEaK7D0tbUXQoLOBIyWQLOUA2izo8nZOzhEKXYCWATQyX3VxoRDa9SyWU5L0Z2B+0guLz3tUlAiMzM7qm+dYYNrkNV8LXNcR5K4KJPfOpvaC+5sGg0NnpdWmGhGB2LNrNyS8h++p+x6l4CIaXB5OM1VDYaJam1CTMYHhZgSBCKmtw7ltie2G9dFlbmSkH5im+0laYteuarKvVCuAs3EPyFnahFcVFH3+tyyNwUqS0cD0Mlura6GJFHpGh4pCr3tzuBw9XGGBIQxGfZEXObYdMSIivfIvfdkOozgPTDbBk2UUe8Kn97VGuQ==
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


