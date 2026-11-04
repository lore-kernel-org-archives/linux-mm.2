Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7698E606A864
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtF7Ltpa
Received: by kanga.kvack.org (Postfix)
	id 8D5E36B05BA; Wed,  4 Nov 2026 14:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E766B05BB; Wed,  4 Nov 2026 14:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E836B05BC; Wed,  4 Nov 2026 14:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 569836B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:18:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E545D160847
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:28 +0000 (UTC)
X-FDA: 85398397896.19.6159377
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 393541C000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtF7Ltpa;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axjAzDMxe/T5Kt/VR9558Sdu9PB/HLdF+q053OKTtnM=;
	b=Viqa216uFnm09ffnXd+bzokUebGGMrGiBeGB3IfIyq3CieUEuL8j/aoarQdyi8AibW+CuR
	lroM57DjFzZMjVFVolYrVBaa8W3SqLYkVMWKPQQ5+ubEEny+oVj4lVX5oje3BG2iDtUzgS
	ylS5SQS+WUpxiZqu4J7s6Hf2J/yCoM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819907;
	b=XOdL7QPlX1wUYdchmQjaNsVfWnYhkOoTBf2BrVsDwCQEgebzI/waGPM9TH3iJ0wQz+pi8X
	tXWW6uzdLBp5rq80imVS6w64ziGcu+65LkgHIpTvrmqqh55hAABuDo0I4zHxGCSapySjA2
	1MY+hEi4ynMsUKSRgkG+HiNc+neqVsI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtF7Ltpa;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A84D260A7C;
	Wed,  4 Nov 2026 19:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DB61F00919;
	Wed,  4 Nov 2026 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819906;
	bh=axjAzDMxe/T5Kt/VR9558Sdu9PB/HLdF+q053OKTtnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtF7LtpaCnKrvS5VracHtmez/lTDVmZLEAJMPsf5RyRtHK8331ZbVhu/+wfqQSNNp
	 k5kqnIbPjR6sVpgI8dl+aRQlbCOs2pnczhaDMKEZx/ZWxJhKcA7brLV8fiEaMbiuh9
	 MFwalEMmSkSmMudfVxnNahrVfbIp17CK1joRPuayEeMp2faKCSbZvgOaORRjZAcf99
	 D+S/7ltnAyBBNuf+VXhjPvzz/9hi+4KRi6bMiJuG/7hKYOJ5c3GtlY1t4+Db/rkvuL
	 jH/DdCnBKpMBBqg0/ET26Tl25sQsMCrXwsOIkyA5elhHUZdHUYVdfAatvui3m3bHkd
	 QSod2kP355CYg==
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
Subject: [PATCH RESEND v2 09/51] profiling: report it when /proc/profile can't be created
Date: Wed,  4 Nov 2026 20:18:12 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-9-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1225; i=brauner@kernel.org; h=from:subject:message-id; bh=tYIXM5EjsYRFpz3d9CdZ23LhMvzI2JA5U8qSrxldqzY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brwqovU2YO3sJayOU6SjJt6WZHyobvyDXUfg5ueIY sXw4vmmHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPh/8rIcHlz85mzfw/yeois tZ+X+nK/Y0nbTtuVF6duv2wgyFZ5PYmR4ROf8bk1y/9m+Rgw5Xqu+ydQsSxzObvU5rn/LzCHben y4gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xqesziy8esruzchowhr9k4g8y84mj4ts
X-Rspamd-Queue-Id: 393541C000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819907-268581
X-HE-Meta: U2FsdGVkX1+fP2qfOBA/Dt0zxTneW/IyH8Hadzmkq2SW+wsdBo7QTDx4BH+SJLVvOc2wWI6KlGbBdZtaqo1csU+wNWnRw/O0yf5mGqc1SfSoaqZnIRxntdhohDr3p5pOnsn9ons6HziRLpqHsgOtMPGzRbNkKSnwM6UmuhHBBQkTCgaef2nepiiR8cuINuqC5R4JLZuPJe0jLvsVwC6ql6xAfBTG91epzsKK+XXqSbT9UvXmZT6luoGpOClg69WyngDKmt3FY9LoMG/MD5qVZQ9dyP12Tqxfr+4Q5/ql2XUB+vXTCBelLf3bPsKrJ0xN4bBoGISElaq+4qw+xK6Viz1YGNOz6MjeiLaqlJ6t/TVNP4m9F+eEAoBItGwxvG/tCKZQDeTG1Wi2qNnunIVeJEjwiNeLEn0xsueWv8m7+k+l/KsmfRvujy7xkExn3S5NNjWl+gRBzFx+3QhfEe2NjcKtB/oZVZXf6MwXJPbsbUZ8gUVadPVuJGRpgnepEU1p2JN8ToYkb2dljyrj6hngvRf3EGCb2RjEGeqvUxa0tJ1oPXc0VhxB+UDy5aCk6VFmpDSn/uKgalqC5JMDBeFdh203k6cIvx+UpgPBJGl0JT7em/Odj3xdabQkGk9R3Y5Elonyg45fIXpOapGigUX2yUjFS1pl+1WriJBejWWPQMKfkuZ93Jd+5WLxfay1smyOsE2D0Y6mwT6NggYLqXXJc9Qu62BzfbqnF4dNfA1inskVOpBgUchYvp94hdgksf+SWNkSbFSHUKGkfBSavAho+uWKbUBuv4abAjnjrF5J6YgiG7lq4QahsBdMwKV1RWtsJYdziHORSQ0twuuseCwnNp8V8I/gILYN+VAWFrSD5ubV77Hk4DyEL6+iS3Lp2/fDhb9OQdy5fRl/suTQwC+fQ3zyfE8d3c4QLVqWm61So8RY0eGMP57iUudyd5LWJVWxu3vR/X2UVlPA0sXzLmz
 d6umAOj1
 KZ4M6nwLeHI11lg8hr2CNMyZWm0zUx4yDFweYrEkkKqG4uQsjoh+MvYlcTdYREziqzQzLmFxmhH9z0gDNOJ/DNivLlcVUQyjgQqcan8PfiqVFtC5k9QuYbGapVRqQoXB8CgnLPp4VQAWi/7F53lIV9hYDgDB1dgUZT4k9W3Ozzc08k4uraS3o50RxtjRLFHGPcQII1KED/Os0zzPlrJB79zasuXgRSF3Kgt2WHltlztDMejdVLyvabJxd0MO5JSHjjTx7oFvAacRHIRgQgvQ3Ir7zF274CVLAMV9ooKGAH3JCVJY+qlhXMbxtBhLLdw5+HeZRYG+aF8t1vnzOUzVGb5D3L76/EUEBIxEN4gXBo0Fnaioz4551m0P+rhkBk5ogGFlODrPMHbCqdGFsINc71QL0Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

create_proc_profile() returns 0 whether proc_create() worked or not, so
a write to /sys/kernel/profiling that turned profiling on but didn't
get the file reports success and there is no file to read the profile
from. Return -ENOMEM like the other failures of that write do.

Fixes: 22b8ce94708f ("profiling: dynamically enable readprofile at runtime")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index e7defa90a34c..820d5ec909d4 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -216,15 +216,15 @@ static const struct proc_ops profile_proc_ops = {
 int __ref create_proc_profile(void)
 {
 	struct proc_dir_entry *entry;
-	int err = 0;
 
 	if (!prof_on)
 		return 0;
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
 			    NULL, &profile_proc_ops);
-	if (entry)
-		proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
-	return err;
+	if (!entry)
+		return -ENOMEM;
+	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
+	return 0;
 }
 subsys_initcall(create_proc_profile);
 #endif /* CONFIG_PROC_FS */

-- 
2.53.0


