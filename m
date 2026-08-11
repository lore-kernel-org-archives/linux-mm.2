Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664FDC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751C66B00A9; Tue, 11 Aug 2026 13:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728C06B00AA; Tue, 11 Aug 2026 13:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6402A6B00AB; Tue, 11 Aug 2026 13:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB576B00A9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:53:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2C7EA018A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:52 +0000 (UTC)
X-FDA: 85089736704.06.9BF7C5E
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf17.hostedemail.com (Postfix) with ESMTP id D2EF540011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=Z8bwl0Xj;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="a YONY/p";
	spf=pass (imf17.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSx5jstEMxGImoS/91W19MHOeSaIonN8JmHYqcRdoo0=;
	b=uE2Fcci8uMnMnuCgSkfA4Prxhsh7vaw8+JpHvv67yWzKZpxyVBZeNWk0Z/TK5Y3gw9trSR
	eM0cNEJGFT9xpDXdbEEVDGgJV0Fepkf5uVO+gnvoiQwAazxSP5TDEOBskGkCz37cNnYBul
	oz2cSGezw6zlpqNQUxOeK8rOXuqkKsI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=Z8bwl0Xj;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="a YONY/p";
	spf=pass (imf17.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470830;
	b=1PTtjXf+N9EouN9KTbHciMxnNysrHe30VcdkFKudU9BoVpmSGnksC64BqVHv2jeSiuf3xH
	E1/c2FcBlZt6TCmmIdqcm1BNI4j47w0FB6RXtNGBQrhXqksXWUKlRssOnVOYWssLFfApmE
	66TmuZFOyUErMFAilYoQnWOjxXh+Xlw=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id BF9781300395;
	Tue, 11 Aug 2026 13:53:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 11 Aug 2026 13:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470828;
	 x=1786478028; bh=qSx5jstEMxGImoS/91W19MHOeSaIonN8JmHYqcRdoo0=; b=
	Z8bwl0XjcJPZQLjW9pXCAUF5EWldkGiE9BEEdn2IuAMsXkmfOq3/dvpxmwnP2ZlY
	8URUSWG/4y0tCxepJplqISoEiYwfVYK/s8vhmV3uUUrGk7zFTdPqMNIWZs+LJLOA
	DyCqajFHL7DmdzdzkamxO9z9Wob/c73E7WLPk597ZlIvHS6jmRJcdG7aHu8F2dTW
	imnXcLgJEGG44MAZQwOinFHlEgCrj6F0218t2fYyyxdt+sm7vHVsMLaS2sM+KzUd
	IucUdBz7PmGhmm4mCSpIW5y7I3249h8Bo0TbSyj3VAlroAAslctclu3lTZEFlZsZ
	2cMCxiZZ3x+umDldQ8whqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470828; x=
	1786478028; bh=qSx5jstEMxGImoS/91W19MHOeSaIonN8JmHYqcRdoo0=; b=a
	YONY/pbby/jHIFWGCQYz+RGUa9FvXes2QTVlDwZtO0+s6y3GL7Z5zvn5OrsxGQO2
	2CjUf18XoqUu7baCU6uNkr1s/KP55lhhgN6I1S5KKzcgSKi4I4ccbwwOkbop0hph
	KrXZtXVQHK9BAjpJipdmlDKNbWmElQYO0/vPrhkYdaQ8FlfJg+CjWrk3WneBjwRg
	pc+DdLurAGOzcoGOyySJWcadJMh5G3tKOlt3JRBZP/Nm7V58QJLsdxkMviUfgKSz
	faob06Ye2Y6SZRYVO2pKJpjllwmXmNruMWGdOQU6jJuwND0RWOAx2Wp0dtqCg2ma
	mGm/TdYa22Upi948CkHlA==
X-ME-Sender: <xms:q2F7ag6rcMW7PiXU5aVJpGDMjV4y94oKSR98ceGllN2DVEqdO41whA>
    <xme:q2F7aodWtq_UGq3M8P8T9aqgN8mqQTBDNAGndFFqhUm_HvSXiChe26yhBuoJs-LWV
    FKzg3Q3CUg4vLxtFs9M4rLni7eZdMo12wZBq520sgFNd2w0dQP_KQ>
X-ME-Received: <xmr:q2F7asO212iSnFyguVFX2i8LKazuh-gy3sRI-dv5M7tTiMrce552n4EusAmZ-Cefm6zvuGdbae04IA7lsGMs-mk>
X-ME-Proxy-Cause: dmFkZTFP5tmiXRyqpvhao8uWnDWsuVG58E3QcpY8nNF+TN3d4+2z3XaWQJ1+2uEKcUq9Jg
    +xH/KDfBOi31TfxVE5vy2aZ5W5Eono+bvv7mBiiNvVW/C9tjIvrxCLzv7Tz6GJOSvAG1cd
    t11+FzpQNbill+yp1ZC7JKPVzEaxQ4CH2HewKTU1gYEn0mNFldMXWgoBvZ/c5OhwLZogLW
    sZeOMCUfQY9vOvCjGHA0ivpYn+5HBy3sK6RswFREIaUm9jlhbU7pV5ZXGDLpJAMlUAJ/Lo
    y1vjaaTNNEiBF07QqH8YbZg0fsVTsE2lSAku2XiqZRlB3GAWdGnDFC/NxQNHJZjZwh0bh8
    kqbkKWELcjtAChbH2Wzn4QOL41OlbQEqlswqKr3P1+VpFR+XsiNX3rUaf5vdKXSnolPw5Q
    /Ll/uLB1cldMhqyZbAiZQTCYwXiJkO7FdRZ/9Gqe2gvfTrCfAfdNHgTLVZMsAD+fn76T3x
    gFGfQHvbVS8RM9muaXsf/hhgBhDP9KsibwWWSg2C80hHXEUnxirzCVePR8OTs9vajPnbRl
    X6LpwU+UjkzYg6auPW6XF1a5W10elYx6W0MaLbP3aPYktTrXr0mX/LqhjI0xOv8F8rUXJl
    m+CCx3AZq3TzeBvltaEQBfoUWTY6LYm9OAxOqDrHYgNL3v9VOvbb9AA+vdHQ
X-ME-Proxy: <xmx:q2F7atztMqppu2lCJw-ae59-79OYTIhf_9RyZUK_28A5frxI4jADzw>
    <xmx:q2F7ao60tNlXmCbxPM9_Vtf4u2b_FNL1_oEvj80sP9fbOVH7gyrr4A>
    <xmx:q2F7apcLuELBIZJX3JNKD7FIGWcg6-VMv9HSb2EfWQYrubi0zhIlPw>
    <xmx:q2F7at7pehO2MMvoObvrQcmAnnV-vM28a5gSPy_0kgEBunY_22OfOw>
    <xmx:rGF7ajAHefbo5jnothnc_kPjagUMcTa_3pOxoBH00iCr7EwKCl7HBwFz>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:41 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:54 +0200
Subject: [PATCH v2 05/13] security/keys: wipe key payloads before kdump
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-5-9561d13c2340@jaseg.de>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
In-Reply-To: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
  Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
  "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
  Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Keith Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,  Sagi Grimberg <sagi@grimberg.me>,
 Trond Myklebust <trondmy@kernel.org>,  Anna Schumaker <anna@kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,  "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
  Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org, 
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Stat-Signature: o17nws7bxp5m7sx6zjiduwgz68b5oain
X-Rspamd-Queue-Id: D2EF540011
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786470830-848947
X-HE-Meta: U2FsdGVkX1+5UCAI7vTJrCopXkdnGejfYj/8W8tQeyWOJOEycMLSSAfRx9H9dk9ck6lQo1Kl+KxNmG23YrpxORc/2TpNDQdPbWZh1D8DvPKVhVSU33dyT4h7lnkzxjRPONYbEsKjjE80EZ5720H26ga/8dsXT+VwDuClEWdabdUWJddHiMoY5DxDDq8yCN6vU9+ASM9kIhJji7yrekQe/U1R2Qx0WBdj1AT8arxmvaCZQRlTSfWzSkLKyCshTts7Vkv8MSen+PJnOHHoz2f12qoPwWX1KB9BlzIhbo2QEUjh2j/WE0TxHrBh3sjb3nXqNVq6loO88KwJt4WXSXvU8JIdgAUXa/8QnBZCjse6oXKVGieQaFTGwgyBf4eITlLcKHF0aSyYrp0I34uSkeNt/mVz2K8mTESpyDyaG8IbtSR73zJB+gjEB+MLt4bCUV3pT3fe9Sm7pU5LunmuahW2k5b3FJEy6bm6h1g6Mpx66kX/gK03LVQBcnsicTMcMV2i6KiWsY+M55ObMp+qPCJYWB3LyBiEbKk6MBp4mK7xcMg2eL/wQrklqnZ9fcBRJQrb2AVzAcly5wm7m2EO2rnXQJy6przg1vQmhn4CVaem4iSE8ofSMZITVEWQAWI784AOBr+OsNMm9KYrJpwti6tYitdEacgdQ7LNr2jHXDNfBhw2ij3yTPm+5Kipq3TlZQK8nyNU7OsWga6dfy2BCbQf4PWrCF0Dn9jafNq87IFJ9enLhCGPa3vtqXGWWBTGlrtbm+AOCrr3MgQEMlZzBHBZTYDNJKSg35Gm2XT12cJnv3c2cSAtfDaKADgiUPEkv/sfoBVi8gIZYMQYqaSl0sBbFeqegdi1JK2rp3h/qvqVoqpSPqz0oii5lpsjtqI41ItSEQyqhkTQudm0Lp6A48KJOdF/ZCLoRbV4eQoDDS2gAmnkK1DdPRYwo8NZ+4vbHX9YdGLscmMtTZld1MuDVyX
 k8VoG7Kq
 JDAhJ/Y1hA89UKPDa5iS+7sa0IYR33HOVjS/g2CjNtyEXiYCAgXPtC//gq7I8opVJxArUNQfKS2UGOJhGXGw3aqWrq9SwtHeG1y/lSbw70OByZnKra9I7SEZ/lNqSD+NUP8tcyRgrfV77IrWVrv1JKK0XMAXmch/5l1teyA/oMa9qju95G7qN7wW+VJ5j9FXfYwDaItkfaRoRJN3kl3PJVgMNhVNeXKkSLlbdtoD37E20htCpnRBOGl412e9Lph3s0QptCOvw5VG+qxJgjEEirrr7cE+3ABdkMIGZpKchkCD06futGyMPYHXUG3CbPl6V0FxoIn+b3kHRE0SOn8FJuDyXD1LfaWv7qFFnfkWx6M55LsmRFXooKQltjM7SX9HBOcyGkv3LB9pj7dl7FWylu7gTDtezPVIdVrSAwlxfRO7r2I+Y5/ki8C9DirD/a7RhMiYz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_CRASH_WIPE_SECRETS is set, try to erase key payloads on
panic before jumping to the kdump kernel.

CRASH_WIPE_SECRETS notifiers run during panic() with other CPUs stopped
and preemption disabled. In this state, we can't rely on free()'ing
being safe, so we define a new `wipe` key op.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 Documentation/security/keys/core.rst | 13 +++++++++++
 include/linux/key-type.h             |  9 ++++++++
 security/keys/key.c                  | 43 ++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/Documentation/security/keys/core.rst b/Documentation/security/keys/core.rst
index 326b8a973828..35cb00a87c46 100644
--- a/Documentation/security/keys/core.rst
+++ b/Documentation/security/keys/core.rst
@@ -1596,6 +1596,19 @@ The structure has a number of fields, some of which are mandatory:
      It is not safe to sleep in this method; the caller may hold spinlocks.
 
 
+  *  ``void (*wipe)(struct key *key);``
+
+     This method is optional. It is called from the panic path when
+     CONFIG_CRASH_WIPE_SECRETS is enabled, to erase the key material from
+     memory before the kdump kernel is started, so that it does not end up in
+     the crash dump. Unlike destroy(), it must only clear the payload, not
+     free it.
+
+     This method is called with all other CPUs stopped and preemption
+     disabled, and only for positively instantiated keys. It must not sleep,
+     allocate, free or take locks, as they will never be released.
+
+
   *  ``void (*describe)(const struct key *key, struct seq_file *p);``
 
      This method is optional. It is called during /proc/keys reading to
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index bb97bd3e5af4..21e07db0c5f2 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -122,6 +122,15 @@ struct key_type {
 	/* clear the data from a key (optional) */
 	void (*destroy)(struct key *key);
 
+	/* wipe the key material without free'ing (optional)
+	 * - used from CONFIG_CRASH_WIPE_SECRETS during panic to keep keys out
+	 *   of crash dumps
+	 * - called from the panic path with other CPUs stopped and preemption
+	 *   disabled
+	 * - must not sleep, allocate, free or take locks
+	 */
+	void (*wipe)(struct key *key);
+
 	/* describe a key */
 	void (*describe)(const struct key *key, struct seq_file *p);
 
diff --git a/security/keys/key.c b/security/keys/key.c
index b34a64d81d47..213e6f1d5d83 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/workqueue.h>
+#include <linux/crash_core.h>
 #include <linux/random.h>
 #include <linux/err.h>
 #include "internal.h"
@@ -1268,6 +1269,47 @@ void unregister_key_type(struct key_type *ktype)
 }
 EXPORT_SYMBOL(unregister_key_type);
 
+/* Called far into vpanic from crash_core.c with other CPUs stopped and
+ * preemption disabled
+ */
+static int key_crash_wipe(struct notifier_block *nb, unsigned long action,
+		void *data)
+{
+	struct rb_node *node;
+
+	/* If we can't acquire the lock, the rbtree might be in an inconsistent
+	 * state. That's all we can do then, as there's no point to waiting
+	 * at this stage.
+	 */
+	if (!spin_trylock(&key_serial_lock)) {
+		pr_crit("crash_wipe_secrets: can't acquire key_serial_lock. skipping keyrings.\n");
+		return NOTIFY_DONE;
+	}
+
+	for (node = rb_first(&key_serial_tree); node; node = rb_next(node)) {
+		struct key *key = rb_entry(node, struct key, serial_node);
+
+		/* Negatively instantiated keys have key->state < 0 and never
+		 * had a payload attached, so only wipe positive ones.
+		 */
+		if (key->type == &key_type_keyring || !key_is_positive(key))
+			continue;
+
+		/* We have a dedicated wipe callback for this since free'ing
+		 * isn't safe at this point
+		 */
+		if (key->type->wipe)
+			key->type->wipe(key);
+	}
+	spin_unlock(&key_serial_lock);
+	/* off to kexec()! */
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block key_crash_wipe_nb = {
+	.notifier_call = key_crash_wipe
+};
+
 /*
  * Initialise the key management state.
  */
@@ -1290,4 +1332,5 @@ void __init key_init(void)
 
 	rb_insert_color(&root_key_user.node,
 			&key_user_tree);
+	crash_wipe_secrets_register(&key_crash_wipe_nb);
 }

-- 
2.53.0


