Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EAF606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=Fl/RHck/
Received: by kanga.kvack.org (Postfix)
	id 8DF386B05B7; Mon, 23 Nov 2026 15:08:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6B56B05B8; Mon, 23 Nov 2026 15:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5F56B05B9; Mon, 23 Nov 2026 15:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDEA6B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:08:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4FA4408C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:15 +0000 (UTC)
X-FDA: 85467470550.30.FB22E5A
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf14.hostedemail.com (Postfix) with ESMTP id C0C8F10000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795464493;
	b=3Zv5/TfpmhrP4oCCbVLrgPhUF3ywA0m/CuX510iVYjOItELahgBnCHqRPsrFVIdySHDwRV
	g2VU7zo4Yl09LDZHb/QK5DbLGXAKp6s3e2yFaV0956hljgtP0Ctdn4FziYRMjc+a9IlVuh
	7lVuk6bxhfN1KE2NoEmrGziCDpmgauw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795464493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Vi8Uo03fcHCO6cbzt4Mec26MkR6iEWVyQcc5YT5w1Q=;
	b=N3FBYSDNFwNbaDhJ8D5DRAQ9Ti5VNJoClZVljQuMOxe8fRtGW7knPsb+W6/4l3ZV2Sf/w3
	1RDU1J2VJRiVRXuAI++f2ToHtiekryn8ZqfgEKdIkwsbP400/tRAKniJUOcDPGN0CRK+Oy
	MCxNMDkx/q+6vdX5vA61ZF5sl3B0Pkw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 522321A09BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:13 +0000 (UTC)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B517809B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:13 +0000 (UTC)
X-FDA: 85467470466.23.2DD44F2
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5851380010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795464491;
	b=rSEvZlF8obwcdISNofrCnVQ+x7+a3wmOacTV9WNjaCez7qbLQglQiavZp1SfenBv1g8CJX
	1gn0o2iJxuZ2oGrbUzaJ5wxOqQnhdb2boDfsfXgFBrbYiEE+dLJwEkFkDm6VL4kotkCeVP
	RQk+gzNhYQjqI+5FRcT7zBuBjbcReG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795464491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Vi8Uo03fcHCO6cbzt4Mec26MkR6iEWVyQcc5YT5w1Q=;
	b=XFlhenQxDR/mwwQZ7x4omU3iFHjtFNagt9rTuwk24MNgrmMhMONCW/GUH/2Ay/cgYjWHq3
	VprO5WobXaTNiDb2fcjcFYYMTLR6aN+fb8DXStuXTk2c7xcXKh1YNtR6GqWYc9LN2HsYhD
	kG7SoT44YKjp84YyqiftGM6yRhyE92g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b="Fl/RHck/";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf30.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+Vi8Uo03fcHCO6cbzt4Mec26MkR6iEWVyQcc5YT5w1Q=; t=1795464491; x=1796328491; 
	b=Fl/RHck/MJceSlYscCM0H4VLL/vy/FrLi+mNXuImekY14iKgXyXD5VklFi2+MlG5j1vYtrCNXN/
	Tdu0/z6ORPTncOZxSGorHmCq+JTfRZwC20xFS7ioTXIu1uORGUCug+MafgSnG7Ja8NRYVgFbc3HK5
	bDDHwtlGWI5twbUfPX2GWAgHWbStqVBkOgMddJms/M9eshgU5Y4oxucXkFJH7iZFzhJXzoZwhrmex
	kK+lGe7SWfox1STPUjrXhNjXF/O61IBrVw8oi6C2f9mCawf8UgzjBG7ZbDKqRwmTGSF6pf7Vn10BE
	AbGEt3DMer1d/SDg/U0Xdha8unBfBJpfrPvQ==;
Received: from [49.207.211.146] (helo=[127.0.1.1])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xVaKf-006jgv-EY;
	Mon, 23 Nov 2026 15:08:09 -0500
From: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Date: Tue, 24 Nov 2026 01:37:53 +0530
Subject: [PATCH 1/2] MAINTAINERS: Add missing files to KEXEC and KHO
 subsystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-fix-kexec-kdump-maintainers-v1-1-79c6a6144de4@csail.mit.edu>
References: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
In-Reply-To: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
X-Mailer: b4 0.13.0
X-HE-Meta: U2FsdGVkX1/UxVP3afiEpPrkyPdE1TOFuZnV3F3/MHBsZBeySV9I8yHk37oIbaBJw0YsJvFwFizFcaf2StnAVvG8AHDOFybjWfOvl/H9vOkkSPfzvOCImm/b8qhqTfZPBp8iKXQX6vZvfoJ5f4eHBT/47P6qGA8ag+of/FJNNg7WCncRTiJ5hM86TLxN23Ymi5RJkxFwhWBWEox9GIvPXSOhMVu8FTaor54XU6Z1BOpfuXB91HnxjkGlwbJnO2QkxgCssDcI9ZtVrBJTigVY4h0Gf2brly5ctawna2fAaQM+DHqxAywoALgMU3ZyITrh06FZ9CXOb0wC4pNE3z5jCqm7QEM+Xz3ygrA5gh56OyhdddqlYi162yPpG+CoSQ0SYmWTBxDPi1m9Fv7vsHhFoDwWWjbfjdePSOTZhq/R7mucKED/kMJ6KnMTNjXD3FsAYdrFzzUQxDXMbGeLA4G0TRjLVSbWqTl4IhuiL9xk2XHqxpwtNbm6jGnXl8t92SGccYr/z2RhAv5XdXugz5CjVj1fJDABFmio+3MPQkWDxhjFW1Ents7IgMHTW8VOiFrpuLwzmlSYZXnuC4cejd1y5J+6Cjk18CruZXkCWcPMP6hcEcKtXR5eO4OCJyKrrKzPqOongdZf7kopYn9iBxXh6vfI1XqUq7tn5zGwaVjDljxw70Wbj509Lvj96zrIjrEjSdFp7iUtrXBK4BGgqcWWo7dbWQUV9Lqk7L2hPYsWj1d0XWDmH1igU3lCvKiqd7GRwh4K/F/wFyWAMOBcWYnPhmHJVDNadeiQqbxhhX2Wbgj4rDvh2Vpvytvpu24ymbLYLoWwgC2wlL+E+0dYcJ/S4jekOswYHbWgUGkixt0Cqc0burUETdsg5EPM0z39frgSHRfLHSTNyPA3W5laxTOe1H4dGBBGgy5lS2pdL0zuLF8xBZo92sh8EP9SU2C4X0H32BFMREsyNod2UN3ckY7
 KBuPWe7n
 MdVa/dSEQp0Nh8KiPQtu7fEoo8IYfGz07BHHDQN6mY8RTXDktgVE0qiPXEq/7LHExdwRl2bVCQHM8ezZcocJxHVjgIUl1JuFNEwczVj/0cySFqcQfLRQNBG9ssycVZyyyb+uT2ywEK9ssHlenB7tkgd17RYB2seRvj/C2KLWKt5FciILGnZ772Xwsd4ICuWSiq3G0fPo3B6tiJB4d4OfmLRXrwLl2Z05zLSRCmg56Fg7kvJDNyEjfSFiR+UT2csxD2f5vQ6dr6Y8edm0kuROwYae66eJQFAyuZqYqK3ZQaTSM3rIFuqR6QRp3NEZbPJD+b8e+ppjoDqaQvosTdLe9bBhZ/sQxjpsXbL19Px6lgRchC9QK8e6cWOPpzRf5HWcYkJdsFvvO0aJRP6Y0o1PSgaznrpU9HmpbgPFfKp5ceXsqiQ9F50dY27HkD7rzvfTbVzZ+LX9feWKeN0iveWPkzMut19oKSs/xB1eqNqYO2WS+fzVWn6JstWfwkQAtf6JyIJPg
X-HE-Tag-Orig: 1795464491-864783
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: C0C8F10000D
X-Spam-Status: No, score=-21.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oys3ughd4pat1dfdrzffq464k4h7sdtb
X-HE-Tag: 1795464493-368589
X-HE-Meta: U2FsdGVkX1/PyaoOJi70R/8rTJ1WpdSIFDFbue+jP3CXvEa0ATs0sqaoWfnhpxFZnelEWJWGlPGq9bZt8ZPHt7BoWcSTGjJgDUEcvOT+h+gUJ5pwSWoaC7GGKOU0qPrPgcVVKd4nIBTcIZLgusDOciYPzKWRh4TK4LlEPGN4EInb9CUo3l3xguqXvIlHFkv5KhGyti0g04UXXbK3GhHd+Y85CQogQoV8MGKsugE1zvIPRPOanUcLCPNZW1tdmYda4/PXJ28NcSQlvp+qKUXWNGDFUXJJeR60KTdba+AfTPqNEctpeFcKnvk62m1uHNVekqmIADYhHJGj5IVZUnGHG9wm66+7mHqAP+XeUszjn+PMrmtP26xlkZCzD0APphyg6MsiqG4YqbDznNPML7eQgpJNaY3Bw1yaBJ5SiZ2Kon4DZK5YVFLCygC3Ze3eEkjcEE2lL8dbG446+2IuaOqQWJJezOe+B/SlwPM82dMmdzChH9facNSoXMo6fd2fd2aw833N4DwEjTfIIZ1zFIoJ8tijTfz92RfH+fGxAVanhcoPmKqA3xg8lr2eNLCx4oW4AlpTeiwz/ZwEpxrYbO3n0ctu++XLnnDtUbR/rIAQuRZOEiqc6bFcIVTmPBZ4bU4SZQ2N//GBMyboBiBpVX+VZofDvQuUdonCDZVcurIIpoaZPcEiMlr9sgWfFkwTkQ5C2TgQQVUwTduILwty1hcCr+3rKBRtnHa2QCJSRE1PgP/5XWOzwOlJR9lKma3zCNu8tavOBUT5V50LwU/Ad873A6oMUIy8J0fOAwIJXtUl0/dJOBphvAwA6rpNYDW43r0SgiabByYyLZL+liqc5iJGeVILNiveOclIJelrLWeQYqGc+kK7L4ZYOd2PvInyAxEOAE4DBMDNgwCxgIc/p/tZtHV+hH/jVD0b6IFpzgwLgRHGUMW6RI3KqBkfCM0eZlIOsDJwey8ZihfkbNbrIe0
 bmP4pT5T
 soCJEqg/eg2+ZkiQkBmtp3glDWtVDEXYwFIg7Dd34XFhLbdu3zWnskWWl2+6/55CsioMUxrn/tkNVBklM32cjes95KyWZLmFJhboge+3gAy+AfWnqTtxYFWDSmgBDv+DR5tNVdocgvixk1J7v/+SOBjbERe0WzjsGu8mjkzKcO2AyJbeHQ4PskhufMb9WfInkowvG1F6WxvBgULGTtarOWz+HLCVgbbpSToo8Uyq9HrHDAOyWnGXuulZ9igIVONmqyCBTFMMrxNRQ2EF32djM8N/tedyNdwIWO3ThUcsszM6Clwgx/ZyzS4xShLMW0pQGRwSnvuIO5Q+8YY4tGXt/O9wIvHhvn8LttD2Kbar8v4xBvhiaQNELL2KXqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several files related to kexec and Kexec HandOver are missing from their
subsystem entries in MAINTAINERS. Hence, scripts/get_maintainers.pl does
not currently recommend the kexec maintainers or the mailing list for
changes to OF helpers, IRQ shutdown helper, purgatory header and kexec
selftests.

Fix it by adding these files under the appropriate KEXEC or KHO entries
while preserving the existing Device Tree, IRQ, selftest and live-update
coverage for these files.

Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 012a21e4afcc..bb4d9c20db06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14775,10 +14775,14 @@ M:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	drivers/of/kexec.c
 F:	include/linux/kexec.h
+F:	include/linux/purgatory.h
 F:	include/uapi/linux/kexec.h
 F:	kernel/Kconfig.kexec
+F:	kernel/irq/kexec.c
 F:	kernel/kexec*
+F:	tools/testing/selftests/kexec/
 
 KEXEC HANDOVER (KHO)
 M:	Mike Rapoport <rppt@kernel.org>
@@ -14791,11 +14795,14 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
+F:	drivers/of/kexec.c
 F:	include/asm-generic/kexec_handover.h
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
 F:	include/linux/kho_block.h
+F:	include/linux/kho_radix_tree.h
 F:	kernel/liveupdate/kexec_handover*
+F:	kernel/liveupdate/kho_block.c
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
 

-- 
2.43.0



