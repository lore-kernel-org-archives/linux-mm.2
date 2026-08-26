Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2683DC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6526B0092; Wed, 26 Aug 2026 12:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6636B0095; Wed, 26 Aug 2026 12:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76EBF6B0096; Wed, 26 Aug 2026 12:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE5B6B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:06:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87C398019C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:06:56 +0000 (UTC)
X-FDA: 85143899232.02.74EA093
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC16710000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:06:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgnOTYOn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787760414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmJCLhannwpQfe0H8AhecB4RfP76TbhEicx9QpJ/hJc=;
	b=M3JN7ahn+GsG40ehIbQnmXFrC7Zm74B7RlVZOPAZCEzcocfZPux221anr++zG9WikE55JB
	njSJcCToNhKb+cXf28fvzK87PX2Ps/2SaoE/cpHmO+57BloVyE12nDAYBw4r5Ob60KYhWw
	inkUvmIZE9+sg+I+M7U6+YzNHvfGv8E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgnOTYOn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787760414;
	b=Q3BQYEZDtTcxUda5kg+NS+tZwf+oxRGb/5G3/CjsFj/VLcLdd8AV82c4hvXVfhdOxx7NSI
	HtjsBcB/oIAkQvwwfBIj/sslqJROJ3aZ4A97IiDGXxyqJljauM83G1KeJKSY60dKXX3r/7
	iJkbkKcEh90zGRh+c/KIh6UBSaHKyUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9F2A438CE;
	Wed, 26 Aug 2026 16:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C192B1F000E9;
	Wed, 26 Aug 2026 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787760413;
	bh=cmJCLhannwpQfe0H8AhecB4RfP76TbhEicx9QpJ/hJc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XgnOTYOnVRzH0wZzLVRnQR05xwQjWrrl7AVdNnViIQ4Bcyw/EPxZmS4FinZ70OsWY
	 NI+H1W/ghgVhv+9tjU/qcry166sRrHtZkaCW+UlpLBnVQ9SHnm06izP3gjYaDqI94Z
	 EWnE5w1MOosmHr5SwiFYZNNuJWlbDdHMIjbvnM49ihiBoyuxgr7I0yd4RPDerv3xi8
	 WwFtIZw5piEN/tTVQJpaSXNx6u6g0do/u4YPtzlQ/TpNVAlq17aUNDbfKlLQyDVKx1
	 QMU6IIYc96dtY/44sPJtZpWLeY1J176+tOKx+Uhglz3h5Tc/OSbh08iP+PJAPMTp00
	 8Yps6dr390Osg==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 26 Aug 2026 18:06:41 +0200
Subject: [PATCH 2/2] coredump: stop unsharing the file descriptor table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-work-spufs-coredump-v1-2-579e72a7ab66@kernel.org>
References: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
In-Reply-To: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Kees Cook <kees@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1819; i=brauner@kernel.org;
 h=from:subject:message-id; bh=K84TbfxfceCW8PndmuLZov84ig4iyficrU4Ck6RdOao=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT18wvf21CYzVAq/4Ndf77FU/EJZkmX07z5U1Rnd//95
 xASP/1VRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETuBjP8j7/41PjNiR/Frurs
 CzhO/9/V9aSg15/f/2bdrLU317tf+c7wz4x3AXuNAZvI2n6HIMaZ/zJKDCqnq/EwxRxdfvVP0mZ
 PJgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: butsf6w9sya1tx515fqdnkkko3ck4xdo
X-Rspamd-Queue-Id: AC16710000A
X-HE-Tag: 1787760414-542459
X-HE-Meta: U2FsdGVkX1939SnLalxSF2/+DgJlb09H/FSD/E6unO38rwuMe9U9ydR4cPjvxAnmWTIjLV2n9EGKaMcnTmTkn9/U4oa30KlYhwZJa8uBsn7meTRaYKOQt2Vckymtr4S1UKL53zGmJPRsL3iC8vccLAfwu+st5qUchTR8qpZYBsfkEIDSpg5CunwHbz+YX0E6FO01NriicYm22VjCBT2O7fskhvXN8XvCIwXK9/m8CPD+445vxqZGto7sQ+us8KHXnr11yLy3zlAumna3qm9Oto5FOfBpNLzZrLo09PIr7c9iEHGFP7/jy8Gll1joVRBLAm//S2/GbWSNKPvHFbpYnycbHTTU8Q45WufoCwMWBldXhJTfdUGzGQmv02Z07Oc6VEsMVv4y6UXHdv95beKEuSZBvMIV+wQ53FTmdFBoh1X2yPIzCDtmIn4SPIsVwhuBYsh9D4eHG6apeJHskrFaM9V0zdBQMIkiZ7WigBFNtR+pR2feGZ5xOWnClyzsg0axqJRTnW1ueuSxqebKdUwXDE+pFr2isGzYb3bo1MJEHW2BD+dzr/KQmek78kuysR12JKuZsTmKW43+fsFTlMecWbwL3V1/3ekmv4i9eUcwlNIeyyIIoPMl8EwEaLV084tPNnWb/FJ2U/QNT7AmdPYvmMYqDTCGIez3gCZPlOi3qs2Q7Ogwg4btv0nbPiJMTZSZwBbefLtwX/GK5Nl/GkzJzHkw1E5RlBdzP0g8nAQm6lLKGeRaQHTXJu7jimajiSOdfOdJwZY39IOyhkPo/7gK0RVFAcjB/fr1GGHBpR2bsGc2osyJbQDwjwGLtyjHDDqbqXZaufXzB9GilAab+4x3v6I1wJfnO2h5vWXWxNrdbspXHpF3Blr+mcEWXHnBtmXjd1XrY8CCCQyvU7GImZjqv9EymwDjMuHVic5w7tzOG5q7T+OWoTWNnllKNP1N9HcKmauwCo5tMyaeg/PuwQa
 wtrvPQCy
 HBW28IDE8ePmvgPhZb4grgDsGTsoRYkrtqVEiQ8OEGwkUPMnU/q+DlQXpDl7q1E0f94zF5p2BbBZBISa06C4L6LsggflEMOBNVXiSvK+biYNSmi+Kif3B0+RAqJk6XeJHbhRJyQ3N+pZzV+jc1IQuDBCkMSA882GLsLQo2WMSj1ROW8aOs/w52VT336RsUkhnQ4/InnDtzP6s0PzXZ1I8c+43Vs+WHX4fo+dDeJoCsaXllMi/wwnH1ZE7pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently unshare the file descriptor table before we write the
coredump. The only code that ever looked at the file descriptor table
was the cell spufs coredump support. It walked all file descriptors to
find the spufs contexts it would have to dump as extra elf notes.

Now that we killed spufs coredumping stop doing that and update the
comments referencing spufs as they ave become stale.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf.c | 4 ++--
 fs/coredump.c   | 5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 06d0df105382..db32bb40a867 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2029,7 +2029,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	{
 		size_t sz = info.size;
 
-		/* For cell spufs and x86 xstate */
+		/* For x86 xstate */
 		sz += elf_coredump_extra_notes_size();
 
 		phdr4note = kmalloc_obj(*phdr4note);
@@ -2093,7 +2093,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!write_note_info(&info, cprm))
 		goto end_coredump;
 
-	/* For cell spufs and x86 xstate */
+	/* For x86 xstate */
 	if (elf_coredump_extra_notes_write(cprm))
 		goto end_coredump;
 
diff --git a/fs/coredump.c b/fs/coredump.c
index ac3cd74808c6..a49f2fd6be28 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1118,11 +1118,6 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	if (cn->mask & COREDUMP_REJECT)
 		return;
 
-	/* get us an unshared descriptor table; almost always a no-op */
-	/* The cell spufs coredump code reads the file descriptor tables */
-	if (unshare_files())
-		return;
-
 	if ((cn->mask & COREDUMP_KERNEL) && !coredump_write(cn, cprm, binfmt))
 		return;
 

-- 
2.53.0


