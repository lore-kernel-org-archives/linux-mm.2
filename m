Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4A7C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6216B00AC; Tue, 11 Aug 2026 13:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE6D6B00AD; Tue, 11 Aug 2026 13:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4196B00AE; Tue, 11 Aug 2026 13:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACA26B00AC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:54:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB40814015E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:17 +0000 (UTC)
X-FDA: 85089737754.25.B21B24E
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0673512000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=U3I428v4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N FVSFrF";
	spf=pass (imf29.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470856;
	b=Gf8UFdnvBofHeUoBuBvOM7N41BrXNDwJf4XJ9xvrR4I7CvOzr2OCaTpvyWoTqEqytnm4sJ
	T2TcVrlyuOMuJa6KJITIVBdxABP40jnPOr8R353nafH4Tn76YjFzERInEobENObL5Gdo+0
	oOgiBZj6D3ghlJCX3zbh3eXTRc3CY9I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=U3I428v4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N FVSFrF";
	spf=pass (imf29.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZBYWhL5n7JQ+WX8bMFfUS0qJovxuh7QkbRbWkvh2HQ=;
	b=0/isQbjbiO/3HxSYjQk9VcYLDd8rqcuZridzkYYkMZ+5gxu3qZB7nbX/7KJdIaMfF7OBU0
	cwdKXxw49lEit7/pw4+tHbNnvvB1D7xUycN+2OwQhVWSOdx+oQV8f4pb2ZyfkI7tIiXF66
	H1PfSCuuwVgysAicKRcCSaHatF1UKDo=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id E7CC4130039C;
	Tue, 11 Aug 2026 13:54:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 11 Aug 2026 13:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470853;
	 x=1786478053; bh=FZBYWhL5n7JQ+WX8bMFfUS0qJovxuh7QkbRbWkvh2HQ=; b=
	U3I428v4Xek0tSEHP9VEkmh84J7xFx2TdU9S8LG8Hnyrt9FFLS3afQgWc4pLxMUh
	oDOB6G5O6t7bhE7LBdDe7Xd9k/LUDmytiRYGMYxaetH4N17pKTtDPgG3q1z6H0a3
	n4bfRz3VifmOrPkTBoHURT9d88Xjb8ZNs4IcVbOStH++mstZ1HzzikSXnbDdM5AR
	cmqQjmAR7Ht+lxSsR9pE6KZ0pEOwmVYwt5c9IWgrVHohtRzyTh+Q9pgb+T6Y8ggs
	vZ56sq37RhJOa3ubp9HuVWHnMzWAeOzxc4Y5zb5Je1U7IWLAxVfnOXNOfayNvO5/
	gbYudKk97aPgWYyIByBOOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470853; x=
	1786478053; bh=FZBYWhL5n7JQ+WX8bMFfUS0qJovxuh7QkbRbWkvh2HQ=; b=N
	FVSFrFrsdHDuwX5bmwEFi+vfM4jbvPi1714oBu1Pe04LTQ4ur68y0wRIxq8PvQ/d
	CK5ZGpzx+b0HGehJPn6zOIyrzHk/fGVB5FsDztbzGbCNFUuW3H0GhsS6WsR3vv6Z
	BcB+8GzdZv2ZYrvwtzxpKcc6jVQrIpKkmaNznEjvmBPKa6D2QAMF1RqYLeKx/JPO
	6FXrwSg7EIiA7UuparnXo61bTYDNTFy4zcXHHvvcPINcmkoilfMZj4hVTChqLkl7
	mtUmU/6kAdq5UxKLWXnh2n2Q/VTAv/mlYQ4g00356aF5Px9u2TMDaBPeEvhaI8Pf
	/0Wg9vZV7YHTADO1cCo0A==
X-ME-Sender: <xms:xWF7agcUcHV810dBcwVWO-0wByEQ2xBhPXEwl2NknpB0F6K3NW67Mw>
    <xme:xWF7arDfhYtv79rmwh-5DfRRdValYWTUL59GVlWFS3q7lnbndGfy1VmkjJRIP-hSF
    RRPVTRDvknzlGjOPXU8GULe3UyNitYlp7cm-7yjQquxBeX46Yf6>
X-ME-Received: <xmr:xWF7aoFLXxX4gYoHmQsdhuqDAgVmSvThwlCFyR3Y49qbILa9WSLPXbi_DlaluXse02X_vcyXa9c6ghT327XDOBA>
X-ME-Proxy-Cause: dmFkZTFqRXkqeRY8YxPaiPG6bKtumQZ44ueOyE0ycsRtkYHYtMPeLw9KqkFTfoymoPXANQ
    f8xIE59to9muOon1MQaYxt7DdSPzezKDm/5lwbw25fHysrcDraGpHHDQDBxbs7DNakPMfM
    e6H9gUHyYw6Jnjx4Hrnr8P0aqcdlkP/OQCvkpK5i8nwVpDOUjiFIrGc2aHzhOHJwaTCmvE
    SohzxPZY/BMExH4tATsvbW62+v/yi0C/jL+BZWLe9AwElVYGEpH8rm9jM3a5qxQfAZo+/L
    Re7VHgx53z5HSeOGiZCoxmlFJwvoInomet06PrQYp2gmHd77fq1CpUHnH937B47mzUIvku
    yUh4mUkbwyIu2ja7cJVK9b5XTWYB3dNvbtYJydefJ79hiiQApVeOYD7m1nli1tUKbs9WrY
    rf6TqxumbHWQJhS9dRF7SycnMHQ6BSeUFwSC0Jc9Hnz+CpcUylmf2b4TB1iS15234kpK4m
    awbwTHUT4h4bvy2Idl4MLcnpcyjQdT8Ab8gCmErQCN0e7s7wL39Q0j7anatprW32BrU2u5
    COL6aNgtIPHavUk6F00gHusdEiFqlhHp0D1PYqraDFPTljJ+i0kxTOlnCQbqK1AkW0Osfk
    J/vfxzuBWvaQmujMPvnwYblwydfhIlNC7DKYrx/NLuL6fNaINYhWN84Nk/Lg
X-ME-Proxy: <xmx:xWF7ajWhWCACvP5bO-pmqXmBAmRXeF-U0U3przamkrmnRLj8AOCsvw>
    <xmx:xWF7amYs0Zv_2aczeJOHicvIVvmoAn3YVBhfzpngMyYgZFoGtUyl7g>
    <xmx:xWF7alBRfTlpL7kuASpGVnPd6eHEPUmnsKJ6PY5hfTOJ2mj8Lqkvgw>
    <xmx:xWF7ajEW0QbI9MLp3s-6tY5Kr01DqRBB2uSkRGUl_9OjEvosCg4t9A>
    <xmx:xWF7ag0IsNk0BBs9Q4B2iViJjlp5tI2fmcCO7rByHXbNsuc466shgXK0>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:54:07 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:57 +0200
Subject: [PATCH v2 08/13] security/keys: implement wipe op for trusted and
 encrypted keys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-8-9561d13c2340@jaseg.de>
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
X-Rspamd-Queue-Id: 0673512000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kyccynf3skbcdcwfmny6dsju8e5q5c89
X-HE-Tag: 1786470855-692624
X-HE-Meta: U2FsdGVkX186gSKxrgv4Uiu4mhRDI7aRYm1FtgSKqJnzSrc1dD1NuEqiIRIIDuWrhsOihC5pl8SCrrEAf8pSO+7m9nAuZdNYl/U0BztMCTjZ834RJ948VPN+bQnEftmc5tuAf90+bNDK9VdpWQhFlKuglRMfVRQ7WNs0JeW/JaX+/mRHcPmDdceY60hT0ynGZ3h8sTKeAiL6Bpmh5WQ6mDIiKXJZkBkHmiGbXERSQobeLMP8Jqf5J8eicYAm4L7he6uP0/hgGHKEoCLRMZ2LjaeCCs7Em1TUgpkzuszjUslsuz72/gd1OtM6kprYxGF4m3vZHnQgh7UspEWQkAlBf2edttOskpcfd3Yo0j30YhSkMhyoW6U7qCkCBTFmTCF63oShZfVL78weXG9/LcnU0j3FUQv9rdHGA0ZU4UcY4y34BLAS76RtlpsieBxd+pQpqIqwibivEUVYaL2ZFRH13BLegKDUHHIpdlDLGJRtSOxCuY5MJN4qvedXsv5NEtCyVI7GK1Ooc5bwh84Ewt+0ThW+YdE8iXgAwUNTrnKq+Ogyd0h7PLCemrDgNML0oYqlGoctCET2izOP/48/KYkJbcAjnn1XcpLWUfY+Sxzn9Fr7pa8wE4E8W2995A1Lsg2rmYMKLHJvc8nTBAuX8JpUTYqGtSwZiRtcTIT0zcklMRWqaoaOheeakNf1gULT0y4RKvErDJD5lcLG9wpadV3znBjwXBJ0DsHv1f5HRPUCMf9TZGE3vDP3l8AScW2etiuWa2ULjtEH6r6cwPR7ma+xe0SyM8RaOP1fPt5Vb9dOjB4ZXuIzihLew1cIrRU0+2vlZhRGswFm7r1ZUs45t/QwxZ1nWjdbM5VdzJhvs0kMAme/6TvJcZYkQB2//p2++8cwy+nPpYqnA4wesSu6ot6Znw8y8iitxmMH6Cx/OdrmR7YF4ufAypfaNkMoLmL0t0mNNxlGhGX/oAi4COgM3Tf
 XZAtuqqv
 QFx8w9mnMUQBwgUtuZP052gyPEyo5fqKMLTcEMR2UqHhpGv+K29IjabYqvyxonmtvmCMXRHpZoHEjJ12xj534HdmlVebwWkWgOt2j6wbhot8GDg1xGO/2IufP0TFKAYe3kk8UXlUuhV/gbekPb2n14RFucddktG+aCT5aq9uPuQX6zv6AomHVsUOOJhxSqaXHd11pVmTZnT9rNaxlLYSZqMwIIAWZxo3OE2wuPRImfZ1dTPPKj1OmOQ4atbDoeyX5ckHNyYVNpFDZROneA1f/2UwTET45hobK/sMDG37EdCIBzu3EcGStA0hB7dn7fdx6KluGHOQqFv6LgYKm+JQsJcy3d4Q/XEwBISNXd4H6jJq4YCDXM8LBqAnq7Wglu4F8ZVQB6Uf0qJUJHNCPktev/3FGC+P2WINNZF67YY/gV1n3IBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wipe the decrypted key material and the sealed blob held in the payload.

Used by CONFIG_CRASH_WIPE_SECRETS.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 security/keys/encrypted-keys/encrypted.c  | 13 +++++++++++++
 security/keys/trusted-keys/trusted_core.c | 15 +++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 59cb77b237b3..9d6fe08ecb7a 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/uaccess.h>
+#include <linux/crash_core.h>
 #include <linux/module.h>
 #include <linux/hex.h>
 #include <linux/init.h>
@@ -970,11 +971,23 @@ static void encrypted_destroy(struct key *key)
 	kfree_sensitive(key->payload.data[0]);
 }
 
+static void encrypted_wipe(struct key *key)
+{
+	struct encrypted_key_payload *epayload = key->payload.data[0];
+
+	if (!epayload)
+		return;
+
+	crash_wipe_memzero(epayload->payload_data,
+			   epayload->payload_datalen + epayload->datablob_len);
+}
+
 struct key_type key_type_encrypted = {
 	.name = "encrypted",
 	.instantiate = encrypted_instantiate,
 	.update = encrypted_update,
 	.destroy = encrypted_destroy,
+	.wipe = encrypted_wipe,
 	.describe = user_describe,
 	.read = encrypted_read,
 };
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 0509d9955f2a..7b220c6381b5 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -14,6 +14,7 @@
 #include <keys/trusted_tpm.h>
 #include <keys/trusted_pkwm.h>
 #include <linux/capability.h>
+#include <linux/crash_core.h>
 #include <linux/err.h>
 #include <linux/hex.h>
 #include <linux/init.h>
@@ -325,11 +326,25 @@ static void trusted_destroy(struct key *key)
 	kfree_sensitive(key->payload.data[0]);
 }
 
+static void trusted_wipe(struct key *key)
+{
+	struct trusted_key_payload *p = key->payload.data[0];
+
+	if (!p)
+		return;
+
+	crash_wipe_memzero(p->key, sizeof(p->key));
+	crash_wipe_memzero(p->blob, sizeof(p->blob));
+	p->key_len = 0;
+	p->blob_len = 0;
+}
+
 struct key_type key_type_trusted = {
 	.name = "trusted",
 	.instantiate = trusted_instantiate,
 	.update = trusted_update,
 	.destroy = trusted_destroy,
+	.wipe = trusted_wipe,
 	.describe = user_describe,
 	.read = trusted_read,
 };

-- 
2.53.0


