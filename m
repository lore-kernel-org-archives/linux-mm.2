Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61389606BDFE
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGhyitu5
Received: by kanga.kvack.org (Postfix)
	id 78C476B05BF; Wed,  4 Nov 2026 12:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D326B05C0; Wed,  4 Nov 2026 12:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6047A6B05C1; Wed,  4 Nov 2026 12:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFCB6B05BF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:50:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5044A8547
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:18 +0000 (UTC)
X-FDA: 85398175716.02.13A1D10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C13E4000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGhyitu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ayyh3GSY9IX8l/NxmtUwOJrSt8ohKQ1xsnTJeKuAZFg=;
	b=i2nVwTgmdva3MH2TIFvERaTPMEONbg4IN2aJKHpSmYtJTXl+2gqJ98tUJIU2xP/xzLg2To
	FUcHsAd3bl0X/CUI2scS8vkCJjtr5kRlIPdNePW3I6XhGTiZXUKGq26f5svbJjEtVVKib+
	XIsLBmlcu1H/PWf+8C4Ro4PB2yywMgI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGhyitu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814617;
	b=b1ahv/rtKoWjF5s5KrJ/fqeQQMg3ORw1abXhJvuDYvB98JYV5n8xdMGR21johkg5AQ+Jiw
	J9sYCeUIY/RbxcYzpcTXowAdaLA1zgXbvAl++LyW977rPFo4KpfGdBBpl9rUwgSr17v9Z5
	UKfDdyp1Vsn2jUdalN+q6usZaaN/8RM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CC9E609EC;
	Wed,  4 Nov 2026 17:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC531F00919;
	Wed,  4 Nov 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814616;
	bh=Ayyh3GSY9IX8l/NxmtUwOJrSt8ohKQ1xsnTJeKuAZFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGhyitu5c+TLBGkN2ZGwDU5Rsh1w/dzPMJRviHA5R0mqU+LsoYuTVg18Jscu2+6e9
	 Bde/aMBOPoYzdl/OGhbYhq2RMksr0qSkO6OBBKfsIB2QpTbcfD5O1d7DOOn6y0WboD
	 luv6dPR8E2zuVmQwRu6+4E313LCJ0DI7VA+RNwygcTxJ2P+0Zxk4UQl+ViD8uLTSyj
	 0Bj56pQlnnoENGhH5tM4j+e/k88FvtR06w4zxZ0OD2mDGN5+rEvzwyzh17+R2wIXby
	 my99TU5Vz2jDt+TrjxUCacOsyHguhDC7NltTczyRHXx91ZO5qtVY+n6qU6a+sO5L4R
	 ZOW5mHfdcdKFg==
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
Subject: [PATCH v2 20/51] powerpc/rtas_flash: don't read past the validate message
Date: Wed,  4 Nov 2026 18:47:06 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-20-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=brauner@kernel.org; h=from:subject:message-id; bh=7JHU1Fe1PUKfNakrIeb+3f7MU5rT/9SRwlQjBFg57NM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zru+45fmhHOmCTv0/xXyljhu8Ir9cn6xZ2brsiN/Z jmlm2+821HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRKEaG//GPri/6rCTy5+J8 1kMXe3b3xt9+LRAy/bux8ZXk+aLWoroM//OvT312ZfeyeUVOzxsmOu8P7DVL+ub/7E+HuUjwFae yubwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1C13E4000A
X-Stat-Signature: uy13z5yauxwp53gjp61q4eecpc3bh1bn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814616-476510
X-HE-Meta: U2FsdGVkX1+HMXOMy/4vCGH4AjTwj5kr8tW+BVWNO+LhSRBgCzcDf9MGqUUM+dmfFXzG6lKGIui1pynQVfke8KwD3JIIEOpaTCn1n46OqrP7B5JD6q0l8XuFO4GqyBhn3+dXaJzZR8zOV9ZDLmEGFdYJ4+VglvBR2PePFaQPPS9p3Rp0ChiRvPHnug2DOe9bNpI7wM+WnImYpK05UhZqOYLx6fZrASMmgz3Ehd33BOTHYiRCkIfgvIHcMSA/cpVWJS3mrFxkOKUm6UO8thYSD4LxzUb9YzNOSQIHMhNo/4L303v6Bo9Jd9KE22GEJd9Nu06xGlV1API/aa8Q12CIJVOv7oK2ip8pZopmHD6RJosXeiPNgU61pdumGGKaujiUG/jNxGZY5StqAxOb3JF+Q11BntUj4NgvjeDBefMnFNuoiiMIQL0beikldMeHDobKwzc5tB3XuskLVbMSbZZjQ5meHF/MOtGyFonX5nHfvLiVi4K+R1rJu+LfASRSTWmbD8mTLbOk7DyVNBjC4yQDUtPQSGRPogWhQEE4uHfgjSRqCp3p1vqBHM0FJHicJ/7AcN0rOHjbCxpo+6R82WDRa7QzwFqe0jKyAuGU2+moCbv8lyv3hq1E16Q8rC5rSZ/AXFkhijxWqKqOTrP1I4s/dZZ+rUxPEbguhlSMncpeROF1dLJoE0Iv7r++8pfb2wq5AUrSsz2qk68kMJYXlUO4wjwbB3wpBHmd/RV1mUMNqP1ejLuBYFEqoXNeOn/gLcYNiJejna0zNw8r8Jun8zBsp9Qz/GfhoUpEsS7Tcp+DSuWj5WbJrWplbjLjT0snE1QA9ZQzP9YVyiCcPdmHFtCNtqqeSD4oGaWzbhpUoFPo66OpDHOpxL/pRVr6VbTlcVZSnbGI7fiGlzJaHQcjEqhWbdadgM1qnhBlWYaZnNuel2ucIEgQ9p7H0eajB87xYpMJRwj3WaNJJyClzTEw6Qc
 qP/qSW0O
 M9s6sAKYSTPrMmHH1Hf/7JjW2Bu8PkQioXCvvi48HMFyb3s/ESG9SQyDujXidCCLpWZYKAeojgrz6sn63mRphbOO7qOmn9LWEZMKfXMLnXkneHxrYo6O4/JlswlP/d5V7vf/thAeYyNEP0t6oENZUUZJmw7PgLrjMeYzA4tARaZSDQNSfA6YkcwCaJvi3Un9jDN4Lvaza+yhTdkVlGKozfBzpkFpDAfXDvypctpBPuHycwMo4rlIGa5IOat+ojf8VKzD3VRTVaEuBGRI3fXVd9TLh8mdmhMj5ZENENkk3RnPCus+kSzEZn+vOg7GlAOWN5Wf7jQ4Wp3rN1aA6V2b3DN+w8+uIFJg32lAwP6a1k+7mxeGRjMGyx33hEVKoYCpjZ1FSPhr2kM/G1JfMhp9dYWrnqGiKRAvHfoAAel5da2ePx5rJyoI7E1F7JioAOaH4KB9L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_validate_flash_msg() adds up what snprintf() returns, which is the
length of the whole string and not what fit into msg. If the update
results the firmware hands back don't fit into what is left of the 256
bytes, the length ends up larger than msg and validate_flash_read()
copies whatever follows it on the stack to userspace. Use scnprintf().

Fixes: a94a14720eaf ("powerpc/rtas_flash: Fix validate_flash buffer overflow issue")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtas_flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 722dbfb6fbf8..f1cd105f7426 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -448,7 +448,7 @@ static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf,
 		n = sprintf(msg, "%d\n", args_buf->update_results);
 		if ((args_buf->update_results >= VALIDATE_CUR_UNKNOWN) ||
 		    (args_buf->update_results == VALIDATE_TMP_UPDATE))
-			n += snprintf(msg + n, msglen - n, "%s\n",
+			n += scnprintf(msg + n, msglen - n, "%s\n",
 					args_buf->buf);
 	} else {
 		n = sprintf(msg, "%d\n", args_buf->status);

-- 
2.53.0


