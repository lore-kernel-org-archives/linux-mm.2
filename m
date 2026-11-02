Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952406074AED
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RuiXMui8
Received: by kanga.kvack.org (Postfix)
	id BD3B56B05CB; Mon,  2 Nov 2026 09:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84466B05CC; Mon,  2 Nov 2026 09:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A2F6B05CD; Mon,  2 Nov 2026 09:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D95D6B05CB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:25:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3154440121
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:35 +0000 (UTC)
X-FDA: 85390402230.10.4BD86D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C5A31C000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RuiXMui8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKU98amy9hy90zr0rIuEDpX5DG9FkJnMRpzgeAMYKDA=;
	b=bHdQa3Kw5FY99LBXR3Iq8VvWLTR7Aj/oR2C0/K5JrZpkxGcxUm2L8DWwqd2LCB63BrV5j5
	5gIEYUGbvsq3HunM8MgLsKTBMn+WWNQE8AcT3j9kuuw7WNUngphojKOI5vCTGsth06Ai3Z
	J3kbBVIJClpkrL/CN02fyOVhFc4O8AA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RuiXMui8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629533;
	b=PPeOhko7uHDX9zZ4imIx+5zulVD14b0ZB3KQ9HoJCf0pXG/kri2VJGI8WYUkkNPxE4/UUD
	yXtlHN89d/F3jGex7Lhm62/l19BA3++e0oGt8yCCooSLW/J9ORERzqV/oOQ1DxBZhtWS4P
	OywMkj/FZm7hwSZM01Lg4f0RPgzJugU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8B54435BA;
	Mon,  2 Nov 2026 14:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C7B1F00A1A;
	Mon,  2 Nov 2026 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629532;
	bh=mKU98amy9hy90zr0rIuEDpX5DG9FkJnMRpzgeAMYKDA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RuiXMui8BjXqcKpOkZSSb2fzdRJqOkdTcBMExOILHIUKi584gE62EX9Rp9REsxAIh
	 tjfzstrESrt5D/m0KQUF1dxAhGVFfymG0E8Js/U44Ve00018P7C9iKFESKyfNdRPH7
	 jxqcAf+UyNqrfhgRtXxl4xxVCit/7IAdifFgBcmNi28pEmExfPZqlZQ4Q0GbNWzpIU
	 msgRoEl0hgaDf8LmrTDw9dYe6Yf6s53ZTxmKCSoEgxdjVUtQjEYNmUbpSyhFg70PwG
	 1lAYyQW6WwhB8zxcVpIbbkLDhHR6Rqo3KCYBrHb/1mUtI2SL/iwP/I6AQGkAgYxSJ7
	 LV6XKXIW55awQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:31 +0100
Subject: [PATCH RFC 16/38] proc: don't walk through a non-directory when
 resolving a name
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-16-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2403; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/ELhSiescDaKRjbpWYPGx1ceLHTHmhSA6KoiiBWZ7Vg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOt9OXTNdZ5WT/1Ui5nzeZtP2wlv61nddee+08Ux
 Eyii1I+d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykaAvD/7pF4SLFW7W7Qx48
 CBf6zy7QHPZPaforsYxZ6W92nFswPYbhf+p3tsbuWgVbTQW7NyaGa9/nmy3g0Lj3LuPQBLv7vNr
 OzAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 5C5A31C000F
X-Stat-Signature: uqjg4xgm4o9tzrp5nhwjfqdtd6ms8dc9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629533-422987
X-HE-Meta: U2FsdGVkX19ND3Nqmi1nzhiuxYQDNMmgODdEjJuXWsNy382Q5guytAWy5mdkiRDp2f+ezt2Ok53tBNg+57YzyvoUOweVgGi629IyTHw9IPSmAZ4NHE5i8ZjTqBjVFmNfDQaypKYqgOFhow7mlTWI7fQimHYRGA9kbRSBgNFPoO5TtTtIqylPJEdX2VMr+Bp9nxdTfgvfWJYX2k0rM0Cw1wQXBeD5w5my5S3cBHR6VpF5en6m82Z9VnULOS4ORPw2lGNYkM/KoeqJRUESvrUMVvgIMqQ1Cgnlddy/Qe2uiSburlVT6GXjRTKqw/mQaraALU2UXvYIwCVcyr/TO8W4X4jGU94wX160jNC+ft/ludtXIROhGfozo/CqnQYNObCp+6mAeQrHjoUvfQc8lObhXS04G76uwowfo+ID56IerZO/8SElpclgHO4di3vUVAKNHETbpX10yludCwtvzPNPyi0RLm41IdAwywy4pwPSthol32zUcrGNDw45xOeZ+beM6pd8u6vQY7bxfEfO8glOkwfHhBSBsBLclsBn5jmG3MHwd7ag+3jJYMnizvAW/t0xk7L28wLmkGf7RSYTBNKrPqY2E2ThHCG5GCnhe55H6eeqI552uUmFN/Zf18QO9B82ElSMi6jwpu5dehb7Z/qa3NUYqHVv+AMgJfpqwPd/Eft0uxMMlwfhZn6MqJ3u3zKvgvNDfxd66J+rws1bBAofWtS+0eiwkCj7wi4DIX8e7IbdELXZHphWS7/arTS8WUElq01985jjgAiA7FM+7JLS5srdiiIRSAfT/ohKeD0Ya4E8NHlU1OV2KudxYjyGv1RojMCDzl/2GachQaS6mqO69PeC20v/XYH78PH0zie5W7hDwDD5yhqK9qY9ZyEqqCgcuamkLMtJFjVelvm/Pyl3jiAQPPkdJHGnrt5pAWtf+FeL+TYV+qhqZ14MKVWn2JbzYWit7OADOv3LdeLakF5
 iHIj8XkK
 Ns1jbFSI+TOknwzhoBm31OTo2RDB3rxD1So0NgmVZ4RE7Zcc1L8bzbTLSHBnPVCMILduhPBNEDGbHKWXZhLpt246k3igaqViOz495PQQGebmDvnnaJ9jQ4XtRqj2Nj6Ll9qTfewrOmags8FyhFx4KCIQU0o1Jr6qiJVjq317lmCmDjMVGSm0wP7r8+qcMlNcl7AH8+MHnseGvwGAQ0ZhH+ieKchdji9ZDFNa/oROhKS7/2DDLeLMuxg1tFrryNH+D8Brnf990m415SNNL30KKwknpJpkLkYQ8ir47xKvU2D0Q99Sp855I3JDe/99lMLlyxXki
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
index 2b1971da4a85..c560c96a64eb 100644
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


