Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF92606A93D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gfbswzaD
Received: by kanga.kvack.org (Postfix)
	id 3485B6B05C2; Wed,  4 Nov 2026 12:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8676B05C3; Wed,  4 Nov 2026 12:30:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7A76B05C4; Wed,  4 Nov 2026 12:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E16176B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:30:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65ED41607D1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:05 +0000 (UTC)
X-FDA: 85398124770.03.F49BD3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A984D40006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfbswzaD;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dKsu59FtDy8aNyG4WRUkN7aPYhsNBybpSNJpPGyZ1Y=;
	b=Pk4jDYlTM4RY8sxDLKeiDlA6IaFKzH5qcRf0jddT78adYmHsCfDaODuFVbOv1/fbUvPIB8
	kSv/BOnG+F1Gnda/i5vKsyNAZ7PyIylIKd2+Uf3oMHD+xjLm5bOvxNRzgJgq1j0BqMdYXs
	8bgNTPBc9mVcfMDOmDls+z7JsnmaJ1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813403;
	b=fMoa4aDwmZm43W2wClbOxBnhMP56GqjrZQiIwVLmz1iDGgLSpJJHfMS+cwfhc2eIkn6RND
	xl/NAXTvv7yuFM0GhxquTvfJXufQuhoT1l8N/DqbTv2DQbhzkB05d3W9RD7CWvFIJmoXUr
	+OVT3VGUyaOhmpD2WKiNaqDg9qaINMo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfbswzaD;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BE0D60A95;
	Wed,  4 Nov 2026 17:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E771F00919;
	Wed,  4 Nov 2026 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813402;
	bh=7dKsu59FtDy8aNyG4WRUkN7aPYhsNBybpSNJpPGyZ1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gfbswzaDVBU7GKHdo96TauMKv1ceaJJyNilcKhGi1iENsVgvyZyYNALew+6JI6AWe
	 pnCrSRXKJFZI76CSsVO2k0ZfaudiGPDz4H6nanxp+IyJlIS7zpWq7WbGYIpqXvffaY
	 YPXkZIViE9ginAIsagyAOsm2dADTElAlSFhpb7mW7+aUif42uY6NuovJjFCkr22t+o
	 8YZgU+wGhNeEvlg8uYowdA2V5/tkllZe4obLrFZwBz6wKkhavF4aJ1MAwudrDBYgmg
	 iqyQouJN+3c3V4Q9h3e+svUJCBV88Hc0/UG53sSExSaEIpQZoLXQ7yhOlSnC5s6p6e
	 /vqOf39HCSJtQ==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:23 +0100
Subject: [PATCH v2 06/51] powerpc/pseries: put the node that the ofdt
 property commands look up
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-6-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1735; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9GgvRCMv4/Dc1Z942cy3A7/ul6cTW5I084eAKnASIT8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zmZ4quyyZkXDnPt7l06dpyFV4qG0w25zxJ4t0hO4d
 EKlP1YEd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykTo6R4ULmC811i1exrd39
 SCDIqSZw/sIzLju3fTqjXqriV5H7NIjhf6qrTt6RLRKL95YYMKbV3Ltr0FNg0RZ8ear5gYvqs+r
 mMQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: us3iya3tn1nqunwch544tnaqkd5etubr
X-Rspamd-Queue-Id: A984D40006
X-Rspam-User: 
X-HE-Tag: 1793813403-69026
X-HE-Meta: U2FsdGVkX1/SK8SSKaLmQddSbJBhbT6z5V/hWZ6V77m6WQOnNhQV7JYUb04mIvJDc7O6OvSIwZ1PLhQDit1pP9Udowjc0v5aAnc6C6pQjhce1X/R9fVO0y6jl9cjVwgAPTkxMqIZD48k5Q4r8pgPcFHFCT/QKC7BHFhks2bKCmpN7bmvbYzA9KRZzdc0mJUd+aKbAD8IJQgZ+FBY96c341GC2E7NCBp853d/JknC2DwJSijn5klbTdB7Dj0O8SgrpG/I8MzTbHkymiPdrVe/jxm89tEuCPKpOtLZmBf7ROoH22LRov9T/CYw5KlbmxJ1SCeUKKx72DTlvRMZNPznRtuJPL9hAJFVj8hIsCK9l/OqJM+yUovQ5qqqzQNY8CyYFuZkxpXxbJCW3fvuc+2rrI73ruIrjbD8xYEiORS+cozXHhCMiskE1Jc2KaTuk8uZS37FYJrvJAX0KcKTKNRR/3Cgh4wF8Oq0KFyKdqcxNZ38VoCdQ8m6PZGwoqB4wdtNvOdDctJxtIJgRp9isfYqubFMWpN08ftc2mmFzVUXShJ6jcyYFB/ERMkWMxYAaXMgOV1nWDbdApCpYF9BptE8yGlJqK+msw3TN6ELtBZyIEPixvqJWrM817ej8P+enxdugIkx1kgLXReEbQ4b3AsQV7xhaNrDDLYCY36UNk8NthC8GTIrSXQiistW2yI71GY4iZcR2+gP/oyJms2z8Mosv+/NXlwsBPRb4iaGmicRd4o0QdyDqEWwSZS7xzC7L+NvHoxRHi/WTOjubuHR1M7R9G+LECMrgix6ED1NA0msxXNPmD85SYgZOwWhnJHDQ0OnS7pG9ixqlQxTBe+FjEsuipQEEt17p+QVd+v0Hfv2bdWLT6QKXI8kCY3YPMpH1IFliPku6UVqIb75jqhmf60sYL8jEdgvqaYIY/21Y+XpFXZp8+jaYujhXaxTTZQAoeCqKaiBo8kz1z981xdWUhp
 SGOK+noo
 JWVEfHW/9e5lp1oLQGyNKYKdy5cg/BIt8WwJ3ex14lF8yMWy9/xGWSDdCcGpo3yxYf05X28DWzCyJHL5XLrvPrFZr1WWocTDSN2uNiGVNGx76AxyRMIh6IIBQGpbnPvKFEiSfBurJlXLZcs7ohGZjFFb1xH+lExJa1l4/vOUZY/ej+LhX3M1oWzaZPD6fdQPt4o7YOHEK9q8N7JDJng3MvKW1OZlFJWI0CPNqQn1z+XT0gZXdKy2VOn9P7LufyHIR4iCTfajukuYFQtNVcmsMji3icSkpr9DE/wKsVLmRYloz1s26sweu/ceHbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

parse_node() looks the node up with of_find_node_by_phandle(), which
returns it with a reference, and do_add_property(),
do_remove_property() and do_update_property() never put that
reference. Every property command written to /proc/powerpc/ofdt leaks
one. Put it when the command is done.

Fixes: 610d91511f99 ("[PATCH] powerpc: Add support for changing properties from userspace")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/reconfig.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 18e3f1a036e3..5a0c9c0b6253 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -271,8 +271,8 @@ static char *parse_node(char *buf, size_t bufsize, struct device_node **npp)
 
 static int do_add_property(char *buf, size_t bufsize)
 {
+	struct device_node *np __free(device_node) = NULL;
 	struct property *prop = NULL;
-	struct device_node *np;
 	unsigned char *value;
 	char *name, *end;
 	int length;
@@ -296,7 +296,7 @@ static int do_add_property(char *buf, size_t bufsize)
 
 static int do_remove_property(char *buf, size_t bufsize)
 {
-	struct device_node *np;
+	struct device_node *np __free(device_node) = NULL;
 	char *tmp;
 	buf = parse_node(buf, bufsize, &np);
 
@@ -315,7 +315,7 @@ static int do_remove_property(char *buf, size_t bufsize)
 
 static int do_update_property(char *buf, size_t bufsize)
 {
-	struct device_node *np;
+	struct device_node *np __free(device_node) = NULL;
 	unsigned char *value;
 	char *name, *end, *next_prop;
 	int length;

-- 
2.53.0


