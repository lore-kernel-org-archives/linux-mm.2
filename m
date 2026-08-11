Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BB9C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8F66B00AA; Tue, 11 Aug 2026 13:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80246B00AB; Tue, 11 Aug 2026 13:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6FE56B00AC; Tue, 11 Aug 2026 13:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88C3D6B00AA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:54:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26D3FA1376
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:01 +0000 (UTC)
X-FDA: 85089737082.23.4EAB041
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C2ED140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=CZJ+DP1c;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Y to8vG2";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JSH/iI45wy3MD9zA4sQib4hD7ZbkdXLzpNiNtsaJcE=;
	b=gefY2qBn8eWWZfDG172IT15mCFTEfvaQNNdzMmVVZ+5JyifMVR0sTENBFYiba3cNDtTwTu
	GRx8/pPg9irLcBJXn8v5Y2z4Iq1lJAdg0UkMwcHX1n/GkqwWPZ4q8LXfOGnuPD1++nSQ+C
	wsF1Uq7X0ZURWh2A30Ci6Tfq5hUGEW0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=CZJ+DP1c;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Y to8vG2";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470839;
	b=kWOb56jltautAnI3vRLhL9fJJWzuOtq59DssT2XRTAoZvSuYTgvNF6BIsZ3GhZrItttN/W
	+GGkWjFkL6qM11HipvVzdhpmKLYPpgiYWCJq7bNky5132stBrLbSDpwAEaUlGOkLMaqIRh
	npSCJRO0AYTjhgtJ18pMXIIlgVSVtpg=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 0645A1300397;
	Tue, 11 Aug 2026 13:53:57 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 11 Aug 2026 13:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470836;
	 x=1786478036; bh=3JSH/iI45wy3MD9zA4sQib4hD7ZbkdXLzpNiNtsaJcE=; b=
	CZJ+DP1ctATAeRR/KJYvTUIM3t8q9GDjhKCZJvatoQooWR6rVWNSly772PQ/TfUy
	ENUwOmU25bKc8x8iO+5/ZiNSoxDpy65ZsBKcuwerOM0xJtAMRQlKbIA2r4+K7cpo
	4bjjS9E5oRvoOp38MPHnL+07j7CKJyZfjvfarLFn9unjoYWs69bl7jCUKKr8Ndsa
	JTNOUd8st5x+6dnD+tzTK+EJVuqdzDYdM5RKFtGLtt2fo6MdxoDxsQEmWWm+1h5h
	9r0ieubu+uMTq53Onf1eIiRRGrIEDqzqRf1iGgAN3ZRTwO/3zZolwRXxQuwQVsSO
	JLp/WAXW/e6HViLutxDuDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470836; x=
	1786478036; bh=3JSH/iI45wy3MD9zA4sQib4hD7ZbkdXLzpNiNtsaJcE=; b=Y
	to8vG2bwv0UUn+XNWPlW4HltiAZMSeXAls7xJHf405to9maLImvQ9bJiV7xuBJPt
	xUIZWEgivpvjAZ/1QdoIo+b9/FKpN+LOU/6eXGlSokf48mJSnxOdoAhuJl9haavG
	p1QQ0O5H31ulz2f1KK09UhIo4WQbcFU/ccZ7Ax2MFwad5tcauqP8cfc3flFLwxGe
	Y75oecP+XNv5iwLqvldxhGrdvSZiAdo1RNEgog64rZDGoXYdeDr3/Tn4wnsVZDlr
	v5P57anNA1u+0/KQAx/G2WWflCk6nIRdXxiG9tYHoiaBV0XQv8Cuv39dxLYqb4Hf
	eNT7F4OO6XotcScVosu+Q==
X-ME-Sender: <xms:tGF7aiJKno3z67rxtm3MwFWmSr1qq3YuYzcqq6y63Z8oTuM-n8nhVw>
    <xme:tGF7ak8Hu_jhjkU4e82Xz7I9J6AizYJgLpYww1XpLix4ozUrHA2hHKre4tCCegENF
    JKguZ2uOe7Yz-h17ITstcjZNXyrafTMgUbUcfzPTjfN-QuWyVja_w>
X-ME-Received: <xmr:tGF7aoXciMDUTi6hA0_x7ZQsNOwlQ4EtBC8NLT6gl4HIwkC-AsF3-PTrFq6F3Ak_1-9hb2fTU-q8NQzKzWR_o4Q>
X-ME-Proxy-Cause: dmFkZTFP5tmiXRyqpvhao8uWnDWsuVG58E3QcpY8nNF+TN3d4+2z3XaWQJ1+2uEKcUq9Jg
    +xH/KDfBOi31TfxVE5vy2aZ5W5Eono+bvv7mBiiNvVW/C9tjIvrxCLzv7Tz6GJOSvAG1cd
    t11+FzpQNbill+yp1ZC7JKPVzEaxQ4CH2HewKTU1gYEn0mNFldMXWgoBvZ/c5OhwLZogLW
    sZeOMCUfQY9vOvCjGHA0ivpYn+5HBy3sK6RswFREIaUm9jlhbU7pV5ZXGDLpJAMlUAJ/Lo
    y1vjaaTNNEiBF07QqH8YbZg0fsVTsE2lSAku2XiqZRlB3GAWdGnDFC/NxQNHJZjZwh0bM3
    cLQaepUv4mccOXTYHSJClVmCRVjSn+gHGZSrZSr9AIOtFX696ePpwSJ3GivOeqzsZkLmTk
    yyYQq6X2LYjRyPVZRsKI2XFbuaBY59zZqLm0Ubjaf2Up6v/CUhpiejbTg9OndalmiNo1NB
    TgyZExpcvXKCRncIx0T/h5V17Yq+BBkt1Lp9C6cm0M6/7WFjIX6uj79fa7WzCqocBHAItx
    lYJGO4yn0BYCEOUjuH4msbchVi4ZaVb/zXzuqFPnUz6EFLEG1rjqsToNrsNvdQ0zdS7Ksc
    iAXcKrD3AR2kiGeCuPM2c70LXnp+ct6Uu0ATWnPyvkCwQAMtKo2ec5wQGj0w
X-ME-Proxy: <xmx:tGF7asL5qDC481n5yJUehDCZHwRaJL4UwVQrDFm98jQ0hiVJMLyalw>
    <xmx:tGF7ai30rrImeq9T90IIpB94BB1urAX1qiXxvs9BhUZjke5_4nNXEA>
    <xmx:tGF7am4zJuXzY0djzripvWMbDrNrupcdCQQZTxKukPDBk7oCLv2Crg>
    <xmx:tGF7aqDX5cdfqklMb2Ex7760XSkgmpeDBXmZI4o_6ZxqlfsL1Bb5ug>
    <xmx:tGF7aroe6voaYG2F9rSNjt3fN3R27pPqoKVo5MIMqwC34HAnQgRdkqhC>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:50 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:55 +0200
Subject: [PATCH v2 06/13] security/keys: implement wipe op for user-type
 keys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-6-9561d13c2340@jaseg.de>
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
X-Rspam-User: 
X-Stat-Signature: xfpnpikbb6sgfnptn46bjrfjepahdrim
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0C2ED140004
X-HE-Tag: 1786470838-298446
X-HE-Meta: U2FsdGVkX1+y3h2jkStCFnCbRZbu9ngBHmWPcmHB44RXKkO0KevJHTzhREYJS9F6PE25bAGqpLu3NEYni2DiMMyBJ+8UaN4V87xVnhF6HPW2Ox1DTRY0IqQyxmUDgroB043L6ukDWTZ6h5DLqZz+l9bZMUacffiN5lGn0WR0zRzySeId5AFJxi4N/Roo8+jR3bSZggiUmBxhssECBGbUzIGSbZzwF0b5ZagsD7AQoLnenesG2GwmKo9be0UjmcbzLqEMy6bLteeMrjrKqXChb7tYcaVCUVvYaTFp0U3/JP6r4783ctW4fkGPZkTqnA5OjHFAkUsLcaLBJAFfdCUnu6K+1XR715iOoBr/5KLhjZAekTAzGgYGMnTqvY96Whfe05XLnucOX2CPArHZqPw8jJQm2R0DATw8OYNljSehMR4x6BV5I2jWsadK2ZgNX8WzAC2CK1rmumGnDo5+r7iO8htM/YxOBJ33osqyBN8nBzh5GFAEKhwTdu7NjY0tBScgtMw/qZ/BdpygtFuEHbjVNwk980k2G9m2NTTGoS+B6C11x3eNj7A2vsRekLk+32s0D/+UfhKc2S1gZRnJgtuSl5Zr2vggJOn2D/h7jixhxSBEsQWqD37t4bsAxBv6WmLyKXUtNRXlIeay/GVJFCjtU48SCvYo23+n1QkSqquW0zY6cIPWBgYcPaH9hmzHQ31xQIgZV53IJjMK1SyUNmuzsJdeGNHjaTPHHokCumVK/Z7X23aL8EC1XBv9vA7vLN1X74SdUTNioXvV/YlgKGeTN7lAlrFSEub9GCYYvNmmCJn8/fMTGn8BqRn/ozMs27lqBXlovY2Sl+7xW5a/Q2O0tcvgLcLm/YFDT82qYuSrUico6Q1kCyk/VXLnHqdUDZUIYWPX0GWcjU4LhSB7/KN1AvWWtqlnf5uqMjWWYCV4ArdSiHi1PEVNRvh0zztUiVHgIvtxB5KZvMMIV5j+JIP
 0SfASndL
 vfvlgEiYwjYINPmizM+luN0RQE6RgZm1FilU5HuH3Td9d+OXEAHoh0MxgwKWF5lNFvA9Dqb2csqA3jcPzB0oPjAFSGmYYqVp/PgtzvlEGzbMoLv0/9tAvwQ2IjUszq3SZznjLR05T89KIWyantbXRXzzDDFTi7AvgUBuc1Y8hOmAThnEpm410VBkiAWqKHO6y7gUMFRMiSaqNuXCNDASxarJfRR13zf2CjW075V/2ucJn6m390UHfjqHg9whhk9uIXbubBi1OCNCxTE+px9EzrIcJLUBD3OMR4Xxb0SbwyPCiCrNYhcmou+ghviR4F83T5GLBKWwSGsezc5Q8Q/kivA2Y87Tq2Zm1IENUyezeKSTj6nQyuLvohluJvn83WNUFvC7LXyv2ferqrdk++0J/HOXIv/ykjJdpydu5mPrm5PhnVk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wipe the payload of "user" and "logon" keys, and of the key types reusing
the user-type ops: s390 cert_store, NVMe TLS PSK, NFS idmap and PKCS#7.

Used by CONFIG_CRASH_WIPE_SECRETS.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 crypto/asymmetric_keys/pkcs7_key_type.c |  1 +
 drivers/nvme/common/keyring.c           |  1 +
 fs/nfs/nfs4idmap.c                      |  2 ++
 include/keys/user-type.h                |  1 +
 security/keys/user_defined.c            | 15 +++++++++++++++
 5 files changed, 20 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index b930d3bbf1af..663a246742f7 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -74,6 +74,7 @@ static struct key_type key_type_pkcs7 = {
 	.instantiate		= generic_key_instantiate,
 	.revoke			= user_revoke,
 	.destroy		= user_destroy,
+	.wipe			= user_wipe,
 	.describe		= user_describe,
 	.read			= user_read,
 };
diff --git a/drivers/nvme/common/keyring.c b/drivers/nvme/common/keyring.c
index 32d16c53133b..33303f035fb1 100644
--- a/drivers/nvme/common/keyring.c
+++ b/drivers/nvme/common/keyring.c
@@ -84,6 +84,7 @@ static struct key_type nvme_tls_psk_key_type = {
 	.instantiate    = generic_key_instantiate,
 	.revoke         = user_revoke,
 	.destroy        = user_destroy,
+	.wipe		= user_wipe,
 	.describe       = nvme_tls_psk_describe,
 	.read           = user_read,
 };
diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index bc397110d977..26f579ae2c73 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -190,6 +190,7 @@ static struct key_type key_type_id_resolver = {
 	.instantiate	= generic_key_instantiate,
 	.revoke		= user_revoke,
 	.destroy	= user_destroy,
+	.wipe		= user_wipe,
 	.describe	= user_describe,
 	.read		= user_read,
 };
@@ -412,6 +413,7 @@ static struct key_type key_type_id_resolver_legacy = {
 	.instantiate	= generic_key_instantiate,
 	.revoke		= user_revoke,
 	.destroy	= user_destroy,
+	.wipe		= user_wipe,
 	.describe	= user_describe,
 	.read		= user_read,
 	.request_key	= nfs_idmap_legacy_upcall,
diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index 386c31432789..685fa054b0ac 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -40,6 +40,7 @@ extern void user_free_preparse(struct key_preparsed_payload *prep);
 extern int user_update(struct key *key, struct key_preparsed_payload *prep);
 extern void user_revoke(struct key *key);
 extern void user_destroy(struct key *key);
+extern void user_wipe(struct key *key);
 extern void user_describe(const struct key *user, struct seq_file *m);
 extern long user_read(const struct key *key, char *buffer, size_t buflen);
 
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 6f88b507f927..f4897c19c2dd 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/crash_core.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -28,6 +29,7 @@ struct key_type key_type_user = {
 	.update			= user_update,
 	.revoke			= user_revoke,
 	.destroy		= user_destroy,
+	.wipe			= user_wipe,
 	.describe		= user_describe,
 	.read			= user_read,
 };
@@ -48,6 +50,7 @@ struct key_type key_type_logon = {
 	.update			= user_update,
 	.revoke			= user_revoke,
 	.destroy		= user_destroy,
+	.wipe			= user_wipe,
 	.describe		= user_describe,
 	.vet_description	= logon_vet_description,
 };
@@ -152,6 +155,18 @@ void user_destroy(struct key *key)
 
 EXPORT_SYMBOL_GPL(user_destroy);
 
+void user_wipe(struct key *key)
+{
+	struct user_key_payload *upayload = key->payload.data[0];
+
+	if (upayload)
+		crash_wipe_memzero(upayload->data, upayload->datalen);
+	key->payload.data[1] = NULL;
+	key->payload.data[2] = NULL;
+	key->payload.data[3] = NULL;
+}
+EXPORT_SYMBOL_GPL(user_wipe);
+
 /*
  * describe the user key
  */

-- 
2.53.0


