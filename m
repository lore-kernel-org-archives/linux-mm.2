Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAF5C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6121D6B0093; Fri, 31 Jul 2026 11:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9E56B0095; Fri, 31 Jul 2026 11:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7F46B0096; Fri, 31 Jul 2026 11:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 131636B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:46:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 944171404AC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:36 +0000 (UTC)
X-FDA: 85049499192.22.7E9021C
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf01.hostedemail.com (Postfix) with ESMTP id A908540005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b="C5f/C1yB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="D ZEerSN";
	spf=pass (imf01.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785512794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RJPYbBdKyVevokLLvrFaLY6IOxzeT8FvabNtZpBPjM=;
	b=Ad5+J6L7wzjwFA5y3ACcqQby/y39/NJfKPk4ZttL386SgaYJ75sfKREvk2huuSf0uTi2Cl
	zgfBA2A40dAX2Bv8AwxmB7UpG2aLz6L+x2nucJGB8YcR8oImWab7eNRsVoFowgKlnMkCGO
	JsZ/u6PvTm4NS3c8CCfN3g+j+7bzzBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785512794;
	b=PpuHDRJTwwcKtpGg/HgM/+K3CxjdTV2M0KE3x3FtWyK6xP/HETGOm6HwrekmLf/WPh0kW0
	ZTu3YO2VpZscbjOqdwh6aGpzXf2YrPJ5dU+iISeidoG0F+cEFM37OTj9jv/mWH+nYrCj+M
	fyZajSFV0lhUTrylzF4XZfrGxsKDyZ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b="C5f/C1yB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="D ZEerSN";
	spf=pass (imf01.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 7AD961300126;
	Fri, 31 Jul 2026 11:46:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 31 Jul 2026 11:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785512793;
	 x=1785519993; bh=6RJPYbBdKyVevokLLvrFaLY6IOxzeT8FvabNtZpBPjM=; b=
	C5f/C1yBEM7vqvF64K9CEdgvycISMSYEFZqHnRg/NchCU1OeMbXHX4SemBxucdYb
	QQFNa8W5A3IV0sIf4gelplYdSmPJBooDOVbx3jN/hI8MeiOiAbFL+r//CMt1uvrr
	nTEOUVnA9xFkJ99sbHmuag4GmrOIPgNZZ8aM9SBCq5LIsWxWh6D4P5MeMTA9T0d/
	0ep2UeaNOU3F4s2jrnGzEAnD9eBs5u+PFvYRUADzl/7BPz0MqwutqMylxQSHaeOz
	zhATvtK6DPlTyqnoOobwwy1qVs3K2LGfB+Bl23yi37Ja6ZpbCnTZLXiPQaW/OEv9
	E/ZMmlg2uq/K6jSNzgU7/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785512793; x=
	1785519993; bh=6RJPYbBdKyVevokLLvrFaLY6IOxzeT8FvabNtZpBPjM=; b=D
	ZEerSNTSuAhU17BHLUw/FatEm72vJIktkenaFzljNXeYlnpfXNudpapwxLG9K2v6
	D7PFbav0Q5TxhNiqCZ5coEbfDjIoQ7xNft7ohvgd0wdJ1RECDeqM/t3za7sZNk0y
	KIkHLp8Mfdi2GAGTWPa0NNmBGzmvFN7wkygyGlQDJRK7dJ1bXDG1DleH5fXzDFKG
	VwqlYWraBwY4ogA53zpmFpmr6ME1MUHCtMiMc2Yqf6RJXQYswL2zNDjvnIPOAqYz
	55iRjxrI2KjNy36nw+/03Q7RVXah8FEpmAefld5rSkuNr/AJfkn//1Stc6p3+5WZ
	5wqqQJFHw2jhJpsIKUlSQ==
X-ME-Sender: <xms:WMNsahK68PcRhDYbo_CwcrJna2vsKpCm3uHiecWu0_g94U0pstoDtA>
    <xme:WMNsau0AoJCzh5fLBU-W1erkrKFrYFdeidb5nquSrs5qftiBHerRvl597vDjikV39
    tP10lTtKldWlYedEq50hesyQYfVKd1HK-2BpZVz2Spc-ha2J_rimw>
X-ME-Received: <xmr:WMNsatIDcLIHEaNrUeWdmS-2ajotvHDhDcBR7TmbHrORfAPwCMqeRIPFtB3cReLikaKRYdRwM9mFCL5FJw>
X-ME-Proxy-Cause: dmFkZTFJfofAu11mowXawT83+JQu53L9bnc/QTnL9gqST2VtMt8iG6+kbXjN+5vhhcwMKP
    fY4wA6UFwdX4zMp8/Qgrkj4H4zmVFbRfdsy/N5dPuJwExieSr4d0DlzUvz60M7JGSR+Cas
    IIT0Q1Wvzymfk4UjWkFNDc+yKtF4IuXKh5cKmIh3bt+XHREf/LNKs7bitBNrGH8CDX9znW
    2Wl0vpilYna00Bcop4B4Q0eR2lAe6qJei4JSSzGQmf8MllLPQkBEX1f4QlGlpITHhMgUaS
    ChLmpQl5BWmuB8wQidJ14Rq4SSXn6lcvGT8g0z3kZ8RoVHOoSzo31dnElgvt5nloKKToi2
    Meb/1RkHPWfnLw/TR9m3N1hk7B0f4d4TP7BdT68iBqR0e3ZqQJM9vZn9qPtezcn60J2890
    g9mLE7B4cVabqGEYMxfPiWK9ul86fnjHpM1BqYe8k4+NqZu+7DppJUinWUMrJLoy9m+NYz
    2chY89W/LkmcbR2gh/Pqz7tN9nvlr+DWXHW1PteBEg3NSk7epULDx8ewc6ELJic5Qm9p48
    ahKcLqq6cDNLJYjVrHgUbEILULEAf9CKXnlqeQWJf3VahmY+HDdo+u5rC1NH4j00bG7ghI
    iHci+EYJ2nGCHLvrDQ49CpQs85Z3eeMewDO2oWXVAxq/z1b9Yv0pbUKBrO2Q
X-ME-Proxy: <xmx:WMNsaiNCJ5hgNNgsX1soVX2aDnFApRAX8gwdB2epHyO5n3GCEPoPVA>
    <xmx:WcNsauz30mR0zGTTz7O1z-SAi5qcFE2AGfmNBZUiR1FSzNr70HR_cQ>
    <xmx:WcNsaqIWBM-ZiIQojrKtJw5OjCjLpscLOEJR6WCrFkrAVKKdeLPS4Q>
    <xmx:WcNsato1Q4GUoE1n87-wHh5t8bDmqzyOOPs44LtUIaCzMheKrqh3Kg>
    <xmx:WcNsalKp8XMjyCpNBgspYRtrwAFMH0JcZHRbKiaBxH-2dDwe5h5Yo_Rm>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 11:46:29 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	"devicetree@vger.kernel.org"@kvack.org,
	"linux-kernel@vger.kernel.org"@kvack.org,
	"kexec@lists.infradead.org"@kvack.org,
	"keyrings@vger.kernel.org"@kvack.org, "linux-mm@kvack.org"@kvack.org,
	"linux-security-module@vger.kernel.org"@kvack.org,
	"linux-integrity@vger.kernel.org"@kvack.org
Subject: [PATCH 4/4] security/keys: zeroize key payloads before kdump
Date: Fri, 31 Jul 2026 17:46:08 +0200
Message-ID: <20260731154608.153258-5-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154608.153258-1-linux@jaseg.de>
References: <20260731154608.153258-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jdnhssh7ffiwmc8sg6umk4tu6s1er7s5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A908540005
X-HE-Tag: 1785512794-267153
X-HE-Meta: U2FsdGVkX191VKOMNFNh6KWdvDftahguIZ/ACRo6aAp4uYaT6F8WcblGSsjA5ftq/mP7yjwS8cMguhtdQAOzO2v4ome1ZbzeTU4tzTx5lfOdhqaTA3s+aYq85/Yxn7rBeTsiwlIE1iO5hwZ38ZK3rZckkqMJeVFT5O+Wpg/i7lXhfxy0XHJMDr6ltrdgFDJyVbJUQ5o9ljMCix5zcp1+1kGxIFgNZI0AK1zVHtuJTqK68D331bdV0W6ntKG01bNI0jWNEhOFFQbVA43fBgbYZ3Vuy48fz7aozFI6au031yyhpBKkjqecvkEpQ1r6XEfJW6i3RKe4YM95RUDb8WLcCgk4RyMoIQenf/XzHVYtr1I2KwBObnUhQJdbmNGjZ1JJjkiAw+vzJRyPHx8cLLWp3v/FWb0qMRlnwYfL8DB4gGSA3DS1TIuLzLsCdU44VCZbaqdT7+XPPWBrLGFKJZOkZS17MIgqsRW20LTtJ6qWDGc4gqcP+pK+5a8HrnzwwgRZlGNHrmegyi3Cv9N7bbMQP6jpJQyUwiqOha1xYYwHTZvZGZJzwyoH4K2yCB9+pT0IcOq/KJnOxAz4CM+LAoHiMtJwlkkhZGFB4XRh31jP6zJME7IH3ttAPVLBg0wxYfxoN9EkNsgCwLjuq6mCFNdFnqF7a3aYLLgx0IEBH9juiGYoqfjPwCl/5qUVVsqlUm8MvsshXNRbicWdopQN0a7MrZKtiV0j678a3FeKXlsxmn8VaTvJpU/rlhUUxua8OL3SIbLNLdmSUCSFyMhFNP0B+O8Z7qc4ZxnV3eTfgYoTGShpmRe2B5czB9WXddD73h+Lymr3YWm8zVS/T/xsAWr00R/HJDpn+NSd37PRUdkeQPWVfsS/h+8+LuLHzOQwg4aDOjubbXuJVG8SZYfGfYMIWoXtl0PPcGDwdKUKxpGu+28UFUPnHXRfaLVWf0R6AfvY4nKAkgz6PspsxeiB5z1
 MM5r1Ctp
 GSg82Q08wBbM69eVtJxzHIiAe0eSXqAVV+NAO9Pfp/2LLnQTLfvuV/yzQmnEw2CuAofir8lxaPWdNY5vjDWA+OplAPhid8zIj6mEYvQSGLyPILK1wdGWi65zEJbBxk39jxgzCXp06MycD0xmpRFOGSpFSjnDrg14ExNkMvVJ2FbVKEKoJ95r9m8p1vAh0PXhJqpavEwY9xR1OEAzSmjfSnOw4CDFEbdEt2FHUj2AI72W250bZNTwFkLzyjojUTeSZwkLoBJ1mguNloDxOCWpz/xB3TOjMDD+0IC7pnPd/bVSvxZzg3LoeJMcNktNb0YSD4XTXIOIysNklNMpTCeUg9yLuLPOpzP5+Qke5YrH9qkpAynl615F8+fDWB0e+KhlLec4l96JIr7dpzPNBWuvIZZHeGuG19xfIMeRsfGV8ocBnvw29wwrgba5GKParPoMlIhQqrpOpk3ojE6uJb/0lkHdaBxfAS7bYbycbzWzmncFnYzDdLhe1WFr4WeEeahYei37AHu95ofNwl/dZIQ7/uSpMM7YVqz2DgYxkbdqshVlmCpYF0FBJmUHYS/s8gLz2YRvLEt0dYjwul+8FicuyvkxVikKar8t/Z/a/7mH5zTLqsVT+7YqzzBXNiqsxPT+R9VX+dVnmK9CjU3qTaebEBv00XD3Cw0HMO80ex1vBqEOBEaHjY+eptKv/SczjQ0L/PeUooRQHHxnBy0ULD5k7POsQExTqK+2CeBTrUhbCs0V8K4o2I0TdEWXc18vy7YcOlP5Ev4P4sjSVsFDLa4yRAeSpCzQBT/kXWE3pEFuCsqjW1NiGD0zGb5naRc9jhs5baBx4QB/jMkMIqEvHkuobp8JdLNotmRi2yeOReckLZ6gkeDOjs+Bbl5PJ9VnjVB294sadKBQVBy08dDgNJqALRqygb7Nb5dQs8Pw5FX2Ld/p1roBcMlk77JeFDtkI0brEU3BOcQQ61jqWDlD+owk3zmCDU4T7
 HPbptsRb
 MQQxIislBoTshYk87GBnknORC+99uZSBdGbPRyqxiUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_CRASH_ZEROIZE is set, try to erase key payloads on panic
before jumping to the kdump kernel.

CRASH_ZEROIZE notifiers run during panic() with other CPUs stopped and
preemption disabled. In this state, we can't rely on free()'ing being
safe, so we define a new zeroize key op.

Implement the zeroize op for the user/logon, encrypted, trusted, and
big_key types.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 include/linux/key-type.h                  |  9 +++++
 security/keys/big_key.c                   | 15 ++++++++
 security/keys/encrypted-keys/encrypted.c  | 12 +++++++
 security/keys/key.c                       | 44 +++++++++++++++++++++++
 security/keys/trusted-keys/trusted_core.c | 14 ++++++++
 security/keys/user_defined.c              | 11 ++++++
 6 files changed, 105 insertions(+)

diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index bb97bd3e5af4..ff0944ce368f 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -122,6 +122,15 @@ struct key_type {
 	/* clear the data from a key (optional) */
 	void (*destroy)(struct key *key);
 
+	/* scrub the key material without free'ing (optional)
+	 * - used from CONFIG_CRASH_ZEROIZE during panic to keep keys out of
+	 *   crash dumps
+	 * - called from the panic path with other CPUs stopped and preemption
+	 *   disabled
+	 * - must not sleep, allocate, free or take locks
+	 */
+	void (*zeroize)(struct key *key);
+
 	/* describe a key */
 	void (*describe)(const struct key *key, struct seq_file *p);
 
diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 268f702df380..ad8537dda70f 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -35,6 +35,8 @@ struct big_key_payload {
  */
 #define BIG_KEY_FILE_THRESHOLD (sizeof(struct inode) + sizeof(struct dentry))
 
+static void big_key_zeroize(struct key *key);
+
 /*
  * big_key defined keys take an arbitrary string as the description and an
  * arbitrary blob of data as the payload
@@ -46,6 +48,7 @@ struct key_type key_type_big_key = {
 	.instantiate		= generic_key_instantiate,
 	.revoke			= big_key_revoke,
 	.destroy		= big_key_destroy,
+	.zeroize		= big_key_zeroize,
 	.describe		= big_key_describe,
 	.read			= big_key_read,
 	.update			= big_key_update,
@@ -279,6 +282,18 @@ long big_key_read(const struct key *key, char *buffer, size_t buflen)
 	return ret;
 }
 
+static void big_key_zeroize(struct key *key)
+{
+	struct big_key_payload *payload = to_big_key_payload(key->payload);
+
+	if (payload->data) {
+		if (payload->length > BIG_KEY_FILE_THRESHOLD)
+			memzero_explicit(payload->data, CHACHA20POLY1305_KEY_SIZE);
+		else
+			memzero_explicit(payload->data, payload->length);
+	}
+}
+
 /*
  * Register key type
  */
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 59cb77b237b3..9f56fa9b4aaf 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -970,11 +970,23 @@ static void encrypted_destroy(struct key *key)
 	kfree_sensitive(key->payload.data[0]);
 }
 
+static void encrypted_zeroize(struct key *key)
+{
+	struct encrypted_key_payload *epayload = key->payload.data[0];
+
+	if (!epayload)
+		return;
+
+	memzero_explicit(epayload->payload_data,
+			 epayload->payload_datalen + epayload->datablob_len);
+}
+
 struct key_type key_type_encrypted = {
 	.name = "encrypted",
 	.instantiate = encrypted_instantiate,
 	.update = encrypted_update,
 	.destroy = encrypted_destroy,
+	.zeroize = encrypted_zeroize,
 	.describe = user_describe,
 	.read = encrypted_read,
 };
diff --git a/security/keys/key.c b/security/keys/key.c
index b34a64d81d47..5673dcc8c5d2 100644
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
@@ -1268,6 +1269,44 @@ void unregister_key_type(struct key_type *ktype)
 }
 EXPORT_SYMBOL(unregister_key_type);
 
+#ifdef CONFIG_CRASH_ZEROIZE
+/* Called far into vpanic from crash_core.c with other CPUs stopped and
+ * preemption disabled
+ */
+static int key_crash_zeroize(struct notifier_block *nb, unsigned long action,
+		void *data)
+{
+	struct rb_node *node;
+
+	/* If we can't acquire the lock, the rbtree might be in an inconsistent
+	 * state. That's all we can do then, as there's no point to waiting
+	 * at this stage.
+	 */
+	if (!spin_trylock(&key_serial_lock)) {
+		pr_crit("crash_zeroize: can't acquire key_serial_lock. skipping keyrings.\n");
+		return NOTIFY_DONE;
+	}
+
+	for (node = rb_first(&key_serial_tree); node; node = rb_next(node)) {
+		struct key *key = rb_entry(node, struct key, serial_node);
+
+		if (key->type == &key_type_keyring ||
+		    key->state == KEY_IS_UNINSTANTIATED)
+			continue;
+
+		/* custom zeroize since free'ing isn't safe at this point */
+		if (key->type->zeroize)
+			key->type->zeroize(key);
+	}
+	/* off to kexec()! */
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block key_crash_zeroize_nb = {
+	.notifier_call = key_crash_zeroize
+};
+#endif /* CONFIG_CRASH_ZEROIZE */
+
 /*
  * Initialise the key management state.
  */
@@ -1290,4 +1329,9 @@ void __init key_init(void)
 
 	rb_insert_color(&root_key_user.node,
 			&key_user_tree);
+
+#ifdef CONFIG_CRASH_ZEROIZE
+	atomic_notifier_chain_register(&crash_zeroize_notifier_list,
+			&key_crash_zeroize_nb);
+#endif
 }
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 0509d9955f2a..f159faeafe23 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -325,11 +325,25 @@ static void trusted_destroy(struct key *key)
 	kfree_sensitive(key->payload.data[0]);
 }
 
+static void trusted_zeroize(struct key *key)
+{
+	struct trusted_key_payload *p = key->payload.data[0];
+
+	if (!p)
+		return;
+
+	memzero_explicit(p->key, sizeof(p->key));
+	memzero_explicit(p->blob, sizeof(p->blob));
+	p->key_len = 0;
+	p->blob_len = 0;
+}
+
 struct key_type key_type_trusted = {
 	.name = "trusted",
 	.instantiate = trusted_instantiate,
 	.update = trusted_update,
 	.destroy = trusted_destroy,
+	.zeroize = trusted_zeroize,
 	.describe = user_describe,
 	.read = trusted_read,
 };
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 6f88b507f927..ade95dc2481d 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -15,6 +15,7 @@
 #include "internal.h"
 
 static int logon_vet_description(const char *desc);
+static void user_zeroize(struct key *key);
 
 /*
  * user defined keys take an arbitrary string as the description and an
@@ -28,6 +29,7 @@ struct key_type key_type_user = {
 	.update			= user_update,
 	.revoke			= user_revoke,
 	.destroy		= user_destroy,
+	.zeroize		= user_zeroize,
 	.describe		= user_describe,
 	.read			= user_read,
 };
@@ -48,6 +50,7 @@ struct key_type key_type_logon = {
 	.update			= user_update,
 	.revoke			= user_revoke,
 	.destroy		= user_destroy,
+	.zeroize		= user_zeroize,
 	.describe		= user_describe,
 	.vet_description	= logon_vet_description,
 };
@@ -152,6 +155,14 @@ void user_destroy(struct key *key)
 
 EXPORT_SYMBOL_GPL(user_destroy);
 
+static void user_zeroize(struct key *key)
+{
+	struct user_key_payload *upayload = key->payload.data[0];
+
+	if (upayload)
+		memzero_explicit(upayload->data, upayload->datalen);
+}
+
 /*
  * describe the user key
  */
-- 
2.53.0


