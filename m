Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938C2C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927506B00AB; Tue, 11 Aug 2026 13:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEBE6B00AC; Tue, 11 Aug 2026 13:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8153A6B00AD; Tue, 11 Aug 2026 13:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D78B6B00AB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:54:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D47E16018D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:09 +0000 (UTC)
X-FDA: 85089737418.08.F71E671
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F58C4000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=CO0Kje71;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="k oLw6IQ";
	spf=pass (imf27.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470847;
	b=ckxct8gMaFHeNZIKWPXcQEe/ycMmtb3kSMJ99O9YmW28zavhRQoX+Mpr1eMWR033rzZQKR
	SSsDQCJx5aFzhL+mWmOmtzWn5QW6X7n/EUZefN3mPxXaZuxOWBh6h2y6Vag6G+jIVSpcQi
	6ktdxjWmi3hP+jczuCbaqKjASGaSIrs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=CO0Kje71;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="k oLw6IQ";
	spf=pass (imf27.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpsnlNCccEzAx1VvGs1BtMr3ZszQOnPZ7Dvx24ZVOoQ=;
	b=LFk+6LCPzQN4x66dKl8yFCtH8T0EagDKodcvAdVp8v5Ps2xZLwdKwMVth/M3+j/URNtULl
	kR2OrL+NipJVp7+LELSHD2jHLIlsBFcQ1mlvWGpQGVbkcPATT1TS++9roOoARAu0DAruKO
	vbbPcWIlMv1pyCKYmmfltUCStjMPdqE=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 768401300399;
	Tue, 11 Aug 2026 13:54:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 11 Aug 2026 13:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470845;
	 x=1786478045; bh=ZpsnlNCccEzAx1VvGs1BtMr3ZszQOnPZ7Dvx24ZVOoQ=; b=
	CO0Kje71ADHAkCmXbnQAZokL+eSWvgwPZWPHmSNOEOVHrTnQpYRqXb1hqK2Uh/r/
	Yd3x7VDfQYmeW35C1EDJN1ovLe9G9sdhLEjE0SMuPLGt7/sOh1Wd8prN4/uu6Lqm
	qha8bFKTOzaB8Xl1n8NkI2GfBXs1RX2UJHbEueS78UVr7xN+39obSLaQs6q0l5Dq
	EANeKWNx1Q4PWyA8udr9f3AfbbuhlciRtcPB1Z8t3mMBdrnykbUwsqViH6leJRVs
	PF3UGXQF48IPvFdkDna56xKJyD6BHZwD6coo+eOmMthRuKaA7WeKH/2uHqZpzrYY
	6UMvpA7pj39GegQSfpmpMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470845; x=
	1786478045; bh=ZpsnlNCccEzAx1VvGs1BtMr3ZszQOnPZ7Dvx24ZVOoQ=; b=k
	oLw6IQ54IYbzIorzGo/Fm0B2EF48jdeMVhpkER6hAlAzec9z9ubOQ6rRjdPVTFcc
	MubOaAcsdMKqhJkjfR/utkUOiNg+8gEExZHQMDjQa59TqonNX06lcrgg8XkjpTb4
	pnacKb6GoWq2VHJU70pbHR2oEK19mZk2PvSoj5X8jk4vD10oej5X/bb6bWaz3eU3
	YYzcZU9/r753lY6x867A1rWK4WybMP5WuuH9Zoi+DwdxDogx1dBFXyxxTT1hy8/t
	1ZAeV9pkJoYJ/b5bVN0hfT4BQqAFEklAkju521/YsTD7qA1u50yFPH++xKyGKKCp
	PH4kIQZwcW7p8gtl1lzEg==
X-ME-Sender: <xms:vGF7ap-78Cw810gkzWisJUAzuiMpXwBK7ozuqxBLIcNUgARH8MADFg>
    <xme:vGF7amjL_5OwyUN72qGopD0KVc-DCcP7fvdq_mjaprq89Y6hJuefK8C4h8ZDyG0ja
    1ssePlZZb0rQDz871exzHBdmC6Dq_lIEhgJDAojuPSFy14xVWIT>
X-ME-Received: <xmr:vGF7atn4rxipHGchHUmh1LwuQ3ShBMoBsR87w1J2fN-MpT0rYMoCqIa1ap8CFEOM90WFY0lbHShBlJV71bW8rSs>
X-ME-Proxy-Cause: dmFkZTFz4vgNe8oY8QyUL0mlPqEECv57Qi7HCBIaM0H0fEpf1xbY2+8hZG6UpCbiC57xgk
    VavagF0YgIkokz9w1ZYP1FsIKkSgwmPUkWwZZopzEj1hsTumYxogfZ8LsE2lIsmrvQrzxe
    DNsAmjkffjDdnK7Hikwb1PBijPzdc+/pLDsJWa/G9io4Zr2WihJBScLGTtc/AAEph99TK7
    KMYjrfPBzTMOGahPoGoXnc0LQ7Z6pMXIRNlA+PEZw+HSeBor1z9UME1MTUTi3zab2cdg5l
    S2ygLFXboS6erW/oqrZ0wC4vZEyPuJEZAHdMIjRfMGBWirnE5Gt0LHQJATpVfpt20aHeVC
    WVD3qwZKQUbal0U+m98B4JhWUSNaJDclWMKiggs1inMalAO0xRnRH3Oouto/luMbNsCB2k
    eSSMm2vjcQBKUvPCfA9hEqFDdbvDb3quCu37KQrVNZypjOu6fL7cprPZRqICDDKVtkztFU
    yrFIasOIyWnuenf8eW7I1Zps/ju1bW9xOHNoW4ln3/bmbFFIXA1cNSJEjke0FYBk7fwY26
    UXB3NzWKPPR2sQ+sCGiPGl0CFHNyi7yjk0GLrJPi2Yr6boERxx1j+qh0F9fuatJNPph+i3
    qUZDH/7D50/AxoO6XxEpOgSyBH2Tr99IP5LbQWtXdp+AhwI4U5A+5y275YDg
X-ME-Proxy: <xmx:vGF7aq1_jyJ3orlciFCUouprVANRIpGlkWCFcyvQc_aJBo0eKcNFOg>
    <xmx:vGF7an61rf_JljW_69O71GwKPMZx349kMnGhgDw_-ouNaIEVpYCCNQ>
    <xmx:vGF7aohArxPwGkmaLkAm1gbdwtxkaVYdmXSi-SXyVYuUkiwN-ay-HQ>
    <xmx:vGF7aglBoOLkcA3og2op4zVMarAqmM_uURQoA1x32QUsN8vPKT9uIw>
    <xmx:vWF7as3ir_QgDzIGYjVblmX7CRlZmtJIgtJFpPtTacPxRUOwiYwKxR3e>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:58 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:56 +0200
Subject: [PATCH v2 07/13] security/keys: implement wipe op for big_key
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-7-9561d13c2340@jaseg.de>
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
X-Rspamd-Queue-Id: 7F58C4000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: i1hs3si1u46huw1rf7s6ggy1gkad1i3m
X-HE-Tag: 1786470847-483100
X-HE-Meta: U2FsdGVkX19ELNUhawRnKJs63Q9Vn0VewWLfGlt+Hsvk8XbY02x1OqXbo10wXD0IQh4mFsJPKQ/vpFBbkwKBVGQJBxeN1Ck12/fC0rDwjoxpfp29yhZqyxMLYoZJOSnaPVzzhiMHK5y0qGm0c2p5hbPl1m2pA5tONUep/LObNkOcQ1RxTsOX4Q1WWWnygTMu9rbPO7d5Xl8MNU8wZdn06r7302udSc6odEAVyl1zU60NXnsgsGb3LMFuVyCtiGROjq/q4mjBXBKhwgtp5UKLm27lyiqKXII+NP3YjwDQUpJmM0w6nXVn7JuWw+um1d5bajuZfSs9Ak/0XuVRaCmXRD8EBWDkw/uzOe6HTust3tfxwGU+TeAfO1Mc8a3T8LERKH+T2kD1604Nmc7oOOxD3vAqif1K0ARVCcGmUW4wjtpzNYsHMMedPyo92+fyvjpqXsFqzw6ZVFstf6gUaPhB8cx6/E9wbovS1Ex6FCJ/i5/lH1pgY32+w6a4mcA0DPjDn1HqbRdbSV3VD8vFYO787UZGobMGXgxZN1n9PWDmGwTXXff1poVkJE/KBv8l4D1khG2iBGPvHhwFky5tTikqggTFcqnGl3jw/9Z93C7m4EVKHfIRaATdFGJMNzio+YdYXk/MacFCUeBaecTfoUqUV6l5dmn7QURRSTzbu/BaNAbrpmt1rPvCSdCZ2HXCXaJKRiqMtlbZBhI/was6F4lYdKgtMDZ6ciipIfWjmzc2aVdZvSLsmg4OO0sktwa6W/+hAP1jXB8Q0m/9Nft+kx5Ob4W3Zsa15zzSgOQM4J2aANGN1YXPuiK/9JZhLinRzYEPM1F1JgLcMg9JEmic34ZOB68mEg0E8c1C0pQ7G4IqsDsp0QMyVmz5QTFHwZbQAJs87BuxTHA+c8nStNOAp238hQ5IRHSZjYvusY75VfhxeXMFygnzX0X57NVokIvXFaeWnQripduJnKwe12hsKTj
 J0PcJdLk
 sAaEEYkWd27ktxWk2RNBRzzf5kHQSJ0JkQXeE8aRuiMA0CIpmLWiGTK77D/QKES8vX98pEIu7HUzBaDsIY44o4P6So3YxSC4+E6lflnGDa2gw3faqG6vaW9YED2P0Qw7j7Sfba9sDPch6akZnlXKQwEzcz/qvhAlC3pgcWDTYlAbYF7o17aAVkSP6pol+b3L7krtnr35AzF+K5ZcGBn0QzErpmu4oV6rza9oC3LCCQNx0aUJJ9k32pMhSjdUXosqYRolWAW2+N7n8Q7DD1SZLAlpO9Q4IFLjB36QnDU4tj8gGT9fkFmhQfU2Fg1evonzcA+svNTrExNjBG9YdG9mMS4Uja36cK1EBIwH+z4ol0JDLJ1XA2JfS8wQ6KecSgnOeFTXgS6GWdC5XyWhxCHQImS9FSLCez10KuYAdsdRhSNcH84oGuJo5+rikd9SDB5LmTzZNeYKKlpulXS42D3tQvPAyaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For keys stored in shmem only the ChaCha20-Poly1305 key is reachable here,
so wiping it is enough to render the payload unreadable.

Used by CONFIG_CRASH_WIPE_SECRETS.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 security/keys/big_key.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 268f702df380..c01a212bec90 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) "big_key: "fmt
 #include <linux/init.h>
+#include <linux/crash_core.h>
 #include <linux/seq_file.h>
 #include <linux/file.h>
 #include <linux/shmem_fs.h>
@@ -35,6 +36,8 @@ struct big_key_payload {
  */
 #define BIG_KEY_FILE_THRESHOLD (sizeof(struct inode) + sizeof(struct dentry))
 
+static void big_key_wipe(struct key *key);
+
 /*
  * big_key defined keys take an arbitrary string as the description and an
  * arbitrary blob of data as the payload
@@ -46,6 +49,7 @@ struct key_type key_type_big_key = {
 	.instantiate		= generic_key_instantiate,
 	.revoke			= big_key_revoke,
 	.destroy		= big_key_destroy,
+	.wipe			= big_key_wipe,
 	.describe		= big_key_describe,
 	.read			= big_key_read,
 	.update			= big_key_update,
@@ -279,6 +283,19 @@ long big_key_read(const struct key *key, char *buffer, size_t buflen)
 	return ret;
 }
 
+static void big_key_wipe(struct key *key)
+{
+	struct big_key_payload *payload = to_big_key_payload(key->payload);
+
+	if (payload->data) {
+		if (payload->length > BIG_KEY_FILE_THRESHOLD)
+			crash_wipe_memzero(payload->data,
+					   CHACHA20POLY1305_KEY_SIZE);
+		else
+			crash_wipe_memzero(payload->data, payload->length);
+	}
+}
+
 /*
  * Register key type
  */

-- 
2.53.0


