Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB99DCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2E98E0094; Fri, 22 Aug 2025 05:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E188E008C; Fri, 22 Aug 2025 05:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B0C6B0023; Fri, 22 Aug 2025 05:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13DA06B0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81C63138F3F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:19 +0000 (UTC)
X-FDA: 83803943118.20.5BDC812
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59B96C0008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zeGGKSxmF7i3vYkKfI2pzpK4m5vG9ZbzD3DnVV/u23c=;
	b=NeQmx4c9iVVRlvgX7/mYputw1OvfSQBJ2od3kPqISFjMmlPwDsLtPkMn+p7zD3KeeR8RzQ
	l20DDeJNh5RR8dj3S1F5LA3CIkXHvR11SWpgr3X01BgxsyoF2pq8hX4adUy5MLZiUr9zNF
	zI0sb3bKJ85sSuwYSgIBqIsGmgopU7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856697; a=rsa-sha256;
	cv=none;
	b=tS7T//rNH6vTAMh0DIZ542V6JVfJI4Mt8Vs93Dv2q/yBo4TZotSO5C4HxerZduTNdo8LwB
	M/lCIP1FltPSDQ8LlZLGyDqXuofSUoRbfzu8Rpj+1LUHXt0raVerOQL8CD5Uf5K0Xk7Wcm
	gq+2JPA/85cR2avoRns4UmWDvMTlYhI=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGm4MbWz9sSN;
	Fri, 22 Aug 2025 11:58:08 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1R7C9v1g2tlo; Fri, 22 Aug 2025 11:58:08 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGm3cnpz9sSL;
	Fri, 22 Aug 2025 11:58:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 687F58B775;
	Fri, 22 Aug 2025 11:58:08 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 260MbcVDPASD; Fri, 22 Aug 2025 11:58:08 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 754DD8B781;
	Fri, 22 Aug 2025 11:58:07 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 02/10] uaccess: Add speculation barrier to copy_from_user_iter()
Date: Fri, 22 Aug 2025 11:57:58 +0200
Message-ID: <82b9c88e63a6f1f5926e39471364168b345d84cc.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856678; l=1419; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=XwlsUHUFJUpz+VqDmhFyhZF843JW5vLl0ICFNZPjHwg=; b=OMJi7NtS5t9H8b/LM9QX7LNwGLYVRhm3b1ohh2Ifek1Ac+dVg5W2gO7XbDwDHd3D5fgUdFcH6 CiFpzXB8IzvDR8zy+bYW8ctsDTYL16XT29wlRQ8tKvZye/dJFBYy7QM
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 59B96C0008
X-Stat-Signature: iomgtxgueh9admg3whcib36bci89ht56
X-Rspam-User: 
X-HE-Tag: 1755856697-134703
X-HE-Meta: U2FsdGVkX19yW9OE8ouOw2Z1VUnpgsmhQzIOaWVNqoFJojtOfFz7z6aIjpzOldb2A3hIRf91v4ZxCoO4XmZe32uLO4D3Vcveou/DU6XUWV/XPXuJFWLYnbqbZVV8LBC6zlDexLEkaYVSqpAexmquST8Q7vnr2ASDVbNbXFJZHnfnyv+dZPVBcZY+EOgZ/cS/m6y8a35+k4w1KX8f333jL85nmr5jXdw+8XYk5s9fHwzONCWKS8jjbjQlndWGsuYqaDznmqJwIagvRia28GWokJMLT4R3e5KP8//WrjuXX9kvojAF0c3VW0cE7k4qUaAwNYr9VYQO7tqHENag7mL2clgPa/eSjbHzUxmKPjuRB8LWVpwRBtHEnSbMid5dLlr0+m9qq9r+R1SiX7iTkUQAuMZCQGL4nrPC09t0oV5Ae5tUnxciHiJQvQK7ltNa3JydDvWkiNbcqEVwJsZwXc95hICvE/nmnhDItenGxVwWkcKl7e5GRHO+vZAUt9T17ezU+9VDFa/Iupw9kJrw/qj3TjAH0jonHb52LUHFECk1getRZXp++b14S5gz5YPCAQUhUwQlZ5Gy0Wdk9N1AI+5djg8QbEFbEUEAM6T2wJSLfNy93TEXTR1gyOQUmWeUAJAa/fAFjlNzZ5L98a/uGfC/dR5H9i2WPIbqmIHGN1kHDx9+qOPwjwCZMVO/VD8quDbRHspmQHwRWResIZG+/gaewKB6sqWzrKT1MmWBrcirjgesVji+jYqs4alVX8CXrmunkyroXWZs6tW/SLN3iMVvba7AcW2cHzfV34YcaP4LTxmekoP9Gl7Jx+lB5RSGqy4KjYrkjz4FfPSMcjbGRqXVriQZTBJE3yYa+VW2ZPX3B19C+h9K3HXieU2YtO1YfQbx9Jr6U6KadYAkhhJFAN+oZH1wpEYu96BkIfqxIG8ls9byI1V/VFXi2Nc6oV0xd284u8QHw2SBAPUJ1lPMJ5k
 DkWZkjdu
 z0WG0Yf1FaD2xTB28o/wukKCDU35Woufl5ecIG9gl735Y2EWwR5M1PN3X1bmuisVHyjfTVZ9pNvmALKaEtVikNsK/1zMxLNZrii+CvVsVwauXgvPhf3/aki8Fklq/7XGEj6Pw1Or+9AlLJno0E4rwmul1+B0VzbSOdhnAlFOuho5GOeF1V5LtMq/czcJSQBIbBYF/L5QXpup0kXtAd2uCYPX+9s6lQ/Pd5a6cXNbdbkGS6zMSe33wamEK0E9Chvw4ZqnaoEInlbhRMJixScxHfqDbdcXTGAmnEc/rHZt21dqoiew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The results of "access_ok()" can be mis-speculated.  The result is that
you can end speculatively:

	if (access_ok(from, size))
		// Right here

For the same reason as done in copy_from_user() by
commit 74e19ef0ff80 ("uaccess: Add speculation barrier to
copy_from_user()"), add a speculation barrier to copy_from_user_iter().

See commit 74e19ef0ff80 ("uaccess: Add speculation barrier to
copy_from_user()") for more details.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 lib/iov_iter.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 48bd0cbce8c2..8d08b3435174 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -49,11 +49,19 @@ size_t copy_from_user_iter(void __user *iter_from, size_t progress,
 
 	if (should_fail_usercopy())
 		return len;
-	if (can_do_masked_user_access())
+	if (can_do_masked_user_access()) {
 		iter_from = mask_user_address(iter_from);
-	else if (!access_ok(iter_from, len))
-		return res;
+	} else {
+		if (!access_ok(iter_from, len))
+			return res;
 
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
+	}
 	to += progress;
 	instrument_copy_from_user_before(to, iter_from, len);
 	res = raw_copy_from_user(to, iter_from, len);
-- 
2.49.0


