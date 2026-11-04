Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C752606D835
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxIENLz0
Received: by kanga.kvack.org (Postfix)
	id 882746B05BF; Wed,  4 Nov 2026 14:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8323D6B05C1; Wed,  4 Nov 2026 14:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727CA6B05BF; Wed,  4 Nov 2026 14:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B60A6B05BF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:19:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 952561207DE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:26 +0000 (UTC)
X-FDA: 85398400332.27.3CA2E0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCAA614000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxIENLz0;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819964;
	b=m1jGee8E/9Vku6F9Q10/xuaHdiiiX3kt3B1dhJ0Yere3bUSs2DN80Aj9WZJ60G05JZCInQ
	U5/oL9IWM8sUWsUFXYcsHlgEu6ynd+wZzDmMGNu8x/Ti+eLXys4tPirx+r8IQfvtnkzFlI
	Ar9Xj+n4Gd+TxoG8EzbBnFkqAVW+wUE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxIENLz0;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QMuJvtMuQ+CXnn6xLeWoxU7H9VJY0mzKEyTXi76/+M=;
	b=minbmjescUtJd4Rz8bA2CQVLrSosavivsgsKSjHh48hExYOwlq8ePnsIR5d//KDvhn0cQz
	jkDUpHluuvLWiXmNek5nzba4hq14n5fDxCUQdM28Vi6TajZDcIZ0KarCqoyoT7gmpLr+mH
	tHyjNfevnRiNCSq37Y7K6H2pcwzOGq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D28B43EF3;
	Wed,  4 Nov 2026 19:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C301F00919;
	Wed,  4 Nov 2026 19:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819964;
	bh=+QMuJvtMuQ+CXnn6xLeWoxU7H9VJY0mzKEyTXi76/+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxIENLz0UJSM86XrOE1Sp3JOvLA1u1MA6tN2TKsN8z69sY8YtYsnY9pKSo3aFOcfQ
	 It+yrAGN09WT7v77bOcS26Rrfp6yDzWLpkBPnc74ur6LeQ3oTzrvuG6Ky0kmVgi5Bb
	 Z3j0QjnFD8aYVcI8yWVigWpiQHEHJJZHAuuleBaspMz1mpQ5rRYAMWLJX0zRU4vJo6
	 RVoQiNLCqpiXG3Q/pt4TC6GrXdJ/RtFA4o6YSTd9QUZ7eQ0PuRnoorZ/GGmdi0VNty
	 8+ElarT6h6fA4UlBB9caj85En7ce0T5GP9cwgZFrj2EBL5oKo+5dRL8rx9quzBAg6O
	 vLwWBgOdvm1Pw==
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
Subject: [PATCH RESEND v2 13/51] sched/psi: don't drop the last byte of a trigger write
Date: Wed,  4 Nov 2026 20:19:09 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-13-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=brauner@kernel.org; h=from:subject:message-id; bh=/5ST8groFWC3ZYrB9+5K2L5OtN8hrslkTr6MpvXzbng=; b=kA0DAAoWkcYbwGV43KIByyZiAGrrgdqjlnhsS+Xn2bQzAZGlod8csUEIbzAtYr5Z7PKO7g1AP Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrrgdoACgkQkcYbwGV43KLVfgEA1c1M +KyfIhJG/BAv6BFn00vAnDN1zj94NkCXNtd8aaQBAIjacXos/OXrlYuIrWKCfCTQiGjILl4kpqo N1Eyu2lMK
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 76tfiu538ns7xec5iffzjnpetkkg15xs
X-Rspamd-Queue-Id: CCAA614000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819964-893469
X-HE-Meta: U2FsdGVkX198yK6KGoB1kSv9oMgM48U4PnvFHefKNcOuc7oJmd63ROZWKfQy+ujYZ1VURzOim7YIFP7SdBIbtreImpuShI0JXTRTa7rB1MHv+c/R1GqNDFeHBTmL9kCsnJKKerpl+QLDJqjVd27tWgUKO/D/48jSOXdRRcJJWF4Dyya8nzCOExSL1yO1dKRqdOLK4BE8un0c/KnlbV0cd4AosQnUdMGN/uGk0U7FsNyULqni/UCMzAi96j4l6NaNnoDSWzpydKvE/c6JO2VF0Y7Mcv+46gHbnfg7ulEqI/GwZmzU2cN5VffRI1UNNU/sTfdzoKUWZQegfE/q4WtcXXNHV98n/zyNGQpwroaQAwImM1w9zt9CsvxIfaEtN34Jl5VmIFZQNxrSwulAPoGTFbMcGTH1CUAL6X3hH1xXTieF/IZQdAJygjqCjqhZzrVIabqHXycxOLzuKArt7eud1pisBoZqt2/ApoHEmGCsbbGEBbea/n8t1sLGjSWWK9GlUT/odzz9JE5PtOI/hLQavmzbQkYQD7ZQooNYtLSvJxNjBmIxtlmEsAlxMLZL0gtJeCOSJNVJHolWmHW1acAZaiPAAHUGf+bLlBnCdvybNNFFQ9u51rzjS52PTueagkBM+laj2DieLWZ48ldEqPiIbem/v+fl7vqXZ1h4oPBxEOR5+L2czOMDx0TGqKmOB9luuUj5OVN4TDLIJoQ4CiBfkGNmzpyENXomUrAxV91S9y/6+MW24dnvlWyLZgEl1vcYpw56w75ybiBKXCY3MNImhSHqfwtdq34R/BJ7uGXTECiUMxEDNWrg0OwRVi7kGq2jHVwnEkk+xxlxKctyoWctzdEuknWUpY5Xw28OwGUdwNzRyw3N1bSZs5FiDnC6JeI4WA43vt4tYOUGXqlHwA+cb9Ojl9k35+yQBqP3wBOwNeO1YqxhU0dA+FXtciCr9Aqqy+mwzhpc2IA9O46XiHZ
 kt5Qfcht
 GaynDN+I4pIJqp2XL4sDjqfX2XBxFVVOJaLTrVNK3DxuzbtoUSmCAF9bK1ZxHvrm3idmvhWe0BwTqyF/Q6wJIdADHpEpsylESBYXYEUXCsFBIOkY91Q8hH0HHyxN93MbPIA7wuv40KBx+AXw3j6Sb7HGNke1uGM1q65ByOFI98P4K406khbMqPldBCfnN1uzFdGetOcYDwzg5Gj+9U8OoRPocpmCszdHvTbNTnL7BFYEEIifkqJZi9e901eLAzCw1V/RerveM4qvVn5UOqyF766L7n+a6KZI8YqZmpQOo4K2g+rvy5hak3jtvzSNjqE6AGa5VbcebY3pkhIxftwZiR1cUqKPO+Xkce44i7QULU4opZQ+TtGRHtXsPEnxJlPDewDjHHTsIg2oAnaENMJYCwNuWXUPe+ai9u6+F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

psi_write() copies at most 32 bytes of the write into its buffer and
terminates the buffer by overwriting its last byte. For a write shorter
than 32 bytes that is the last byte the writer sent. A trigger written
without a trailing newline loses its last digit then, "some 150000
1000000" turns into "some 150000 100000", and a shorter one like
"some 150 10000" fails with -EINVAL because the window doesn't fit
anymore. Only writes that end in a newline parse as intended.

Copy at most 31 bytes and terminate behind them.

Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/sched/psi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7c5381423334..8b59635e95d4 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1566,11 +1566,11 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	if (!nbytes)
 		return -EINVAL;
 
-	buf_size = min(nbytes, sizeof(buf));
+	buf_size = min(nbytes, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
-	buf[buf_size - 1] = '\0';
+	buf[buf_size] = '\0';
 
 	seq = file->private_data;
 

-- 
2.53.0


