Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04F7606A6AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=If6Azv7y
Received: by kanga.kvack.org (Postfix)
	id 010D76B05D9; Sun, 22 Nov 2026 14:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A486B05DA; Sun, 22 Nov 2026 14:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40746B05DB; Sun, 22 Nov 2026 14:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFE956B05D9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40973A83A2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:51 +0000 (UTC)
X-FDA: 85463765142.04.BA30847
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id ABF16140003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If6Azv7y;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376269;
	b=OIjB8AGR4M2SJNYgTVA3b/wQ7qEeYeg4gnxFLEzoKwAVUmrWUMhQcn88QIy4xqjt8yK52+
	gs2hY41bXVRRduaH8ZwbERCZKqJwByif3lSt0Q/NjVz58XivZ7/73l9KcC9E8x3bgZIqED
	rgFRsHHkglzqj40lWCJePnivbGvDPNE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	b=v0KpG/3t/mzzEt3KnZlPB/MypUJhnJKm0p7X6B9af0k8UbGho/VRgwLLgut6rSiRQXOFyO
	zhSWu7crmK5JZ0ltmiU6Ppejqw5hzm3L9jmm9ubPXDJAFCMJTtSa0vZQM+zqRsf96DgXSs
	fp4c0rGx1D/UCq2h+6q0PpJLSeZ1gi4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If6Azv7y;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E8F7D408C8;
	Sun, 22 Nov 2026 19:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E59221F000D1;
	Sun, 22 Nov 2026 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376268;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=If6Azv7y7srTCn6OR0qdqZQAwa1W7Gt05tNg4TPPtNZ0kqbU7S/HJIrOaVSbu5He2
	 UcQYGZyFJswbruL02XotkP5Qo0sAiLgKUKGIQ8Gi8yiHFaR9w9q4Wx7olOPpVQs/Ky
	 A9rTDmfwXa5kKjKsqhuSfUcv8eeNDe3A2PZuK0tdgw2gon96AVqaD6syspi5fkJ3Wo
	 ScgOoGL5gTQFoAfLmxdcLAxxx/Ypx7zjqXVJyKlTiTYDeVpD48x/RK33TjzOrp5rLO
	 ANINvuVSa4Z5EmpoCFu4ML34znZVg9/tvfMwXoQWObjGP9ozyW5Vp36n4R0Za6rYTG
	 k9ENPgWMMUgug==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 26/26] MAINTAINERS: Add entry for USERLAND
Date: Sun, 22 Nov 2026 21:35:39 +0200
Message-ID: <20261122193539.3334213-27-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ABF16140003
X-Stat-Signature: ijszpstgrkxcz7s5rt477hp8sbdxsc7a
X-Rspam-User:
X-HE-Tag: 1795376269-92417
X-HE-Meta: U2FsdGVkX19vH7a1EB44qqFvzEaiDWD0TMI87QA4JiG53yu+s8TfzRUffI/4DfB08OuMT6HH3V+i4PHygV+ApWRq87L5ABPxljN6cnv9n6rAJTS4tS+1Qef74a5Tjq9d/vHvOvTn5xEwEtEUMXoJDP64o6IEufLPcIvv8ne9ruEXeTMbwG5yQB+zTtTwI5f1f9lnTajsUD3dcufPPBj5ciFmU4s+8tUDP8mE5S66JR9N0E3FafYZh0lGuz99S898WKecM81+99T0SfOsSYSQ3/GnSMKpTWZQnosmxl4ZqhP42V6gnf9t9FiFX2gqNieHKkMwwnuvAp6YAposyAPD9UywgXw+Fik0c3x4JBgokmv0FRQUlKNQfikCoTZ+jc7LhirlTzpCL97vwOXEQEmcB7w4/lTSAuUeU5Cv4Qij+b3Nhz+uOe5Fl7m0nR5UDeODA4AIZHiHmCippOnCtgYbz2lBleLcKtj6XLC6FgDFRZrpB5KE7/vnNuv04cIlHZJM1N4dg+P4hReoXiEF/s05g6k4O9TASL1X0HifLAGZld7w02lA32wRjVU0iohuvX1SVE9QaPL0I8sZPktB2fQ/66s/L9L4WtJzaAhhXVTqBBq9I58Cd1F/Ri48NOz6XAHVaCS+uDQwJEDCHRY1ub4/B1/g98jyY7WW0H5K0qgJf6Rzifq1d01gUvI+aWnRSjvOiEq1hk3AvN5NA7N9do7/rcZEtwR7Cr73D1IGtdWxkiXOFMtPJc4TOK69Nu0dPlTeOGG4wM09Mg79nfO2YMA5NN5XS18yC2MSk0gtkSIMj0DihDmVOx+UMj7Ho62QjfAx8eckV29q2QGDku06gCOSn+8sp23Jx8UV6b2Ln+v5qxtAKUe70FLxgevUl6tbNDXCfitO7KIgQ+ktzjjZer86MyJTASYjauIuxHQ2xpJNk6tgbM4Wfq5u0k7npACg10U+0HAAraKxzqMdmPqfcLq
 sc1arVV/
 zITJ3IzOE5J1P8pMMcLR39zR46RZ2wJqwKto+MxKFN0FP08NEx1MVLKv6UUdiNXxzq60SUECreolNjdRxn2yOqFKSXvgRcvGRpzVS3DrYvd8UZ/svbxXMrSYiOCuJO7U8N3nXG+K6l7glPYzsYcsDdr1FScxvd6JPEii1KUf53HBFBDYY+Lv6631pAR8Fd6KMQT0RD7B9SSoAeknRiJgn1dGKa9fu6rTLngFrqJIszCB17ZtZDjUOXxWSFW8WzAd9FULl+Ji27BtBoIoa3DFU2cSStYzaK2Go4R102O7I36bAAeyXnAM8KnT1lMoT//XkrGVXIH8JtPBoEKO1A2uSohmWFz2vXSQtWRYx5iUv/mklM2okkXc5UueLAFezdp4BZF/cDtkTOEnZ6qljgFQr0XRTfHIXcC8nGIV9HTDehpMrerSdylO5n827bV8t0RmkRneh+jB+1kPzPCIw21DujMwSxukguLFhOS7MhgF3/sAnwXOMwwCTe64qVrVnF9P0i/ZcBBeulk+WvY5U4kCajdRHNN5Sa5LaYqoYVkAnn+vr7+w/L0WA3tlEvO9plji4Z5CJtsImygT0MtNZkOF86hDadEG+FcEBZExCyqj3xAsq0Av3EJwNTGITzNoPcdAuU1ed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Record maintainership and mailing list routing for userlands across
their uAPI headers, core implementation, documentation, and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..54d8f628cb87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29285,6 +29285,17 @@ F:	arch/um/
 F:	arch/x86/um/
 F:	fs/hostfs/
 
+USERLAND
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/userland.rst
+F:	include/linux/userland.h
+F:	include/uapi/linux/userland.h
+F:	kernel/userland.c
+F:	tools/testing/selftests/userland/
+
 USERSPACE COPYIN/COPYOUT (UIOVEC)
 M:	Alexander Viro <viro@zeniv.linux.org.uk>
 L:	linux-block@vger.kernel.org
-- 
2.47.3


