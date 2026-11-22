Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4C8606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c41yvlTm
Received: by kanga.kvack.org (Postfix)
	id 0D21A6B05D8; Sat, 21 Nov 2026 20:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA866B05DA; Sat, 21 Nov 2026 20:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC086B05DB; Sat, 21 Nov 2026 20:20:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAA436B05D8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:20:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F193160611
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:20:03 +0000 (UTC)
X-FDA: 85460998686.26.496A0AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C888A0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:20:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c41yvlTm;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310401;
	b=pK223J4PYOI9fbRgpYn3aRWR3p2NCcmCk2mXh6GeAL42LiqxNgoN/MlXwcm27pbmUzV2+j
	Hxsfw18qJoKU5wrqkuf50kHaXcTOOUCUW6rFeud23I2k+NmTbvDtFliDFWChZgdvCyHiDW
	x9ouDbfTmFtLf8KaHhU7eNq/ND9o0Yg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	b=vnjjGveG8adgyjpxBdrz0iX1lnG7wXDt+vU1VhVC3YrD0xf3rjBn2neHn8FSCNG9+ldSsu
	y+Oqa16wV2neeR/F5hWaXGURtpfs0fx7693Sv0RViYR3I68T6PMyhY9BZWKpbJ7T8nNG/7
	t+s5e7apbMNmPxLSAUHYM1pj3GHWbiE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c41yvlTm;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id EE61B459C6;
	Sun, 22 Nov 2026 01:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 00A451F000C0;
	Sun, 22 Nov 2026 01:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310400;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c41yvlTmsmUggUlC3/vjinTm6vFtUxEB9z2rCyU4sjtlo4Nhf2qmcPGP+/NpenLob
	 viRQ+5vSpy+tqkKMNA5Oet6+CAkVFtRS0CJsFclAKgeel6Gcsi0XY0SD6uyqJ1U8z7
	 utsX/+EqeQkhmu19i55+Q+TtmVYAGUuXCjOvVDpyws08iMTtw55Ectr/3BW2yMv+uJ
	 EUImr8k8+n0HTGtMzfumIDfRvrzzErJiXsgowtanlgTOgRbvFf8OkSo3MpIB1F9SLa
	 3irPUYzQqOhIKnQeTnC4RPUqldnRrQNkrVz/WkTLXU9vtRScHrl6gdnDzY9+d62owQ
	 nfh+WULW4lmjw==
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
Subject: [RFC PATCH v6 26/26] MAINTAINERS: Add entry for USERLAND
Date: Sun, 22 Nov 2026 03:18:09 +0200
Message-ID: <20261122011809.2667684-27-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 9C888A0007
X-Stat-Signature: cswrtq8xe9ab47gjed74ohfn9nbz17tj
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795310401-424282
X-HE-Meta: U2FsdGVkX1+5gmfCm+Y12P7AnfJa3KXCETjWgWKppUxJFUw+wJusETZYtBabeLP+wWghFyqP1+SIE5DUK0ji4YZsq4w9PPXznHftoTD0W0dt7by3+vEdaIbVqgTsFvDNIlKzyYDUCSJoM8I8LIAP3CUez96fwDDE57CQMq0M7C3vXqUNr4MHemc3PBDvuHQx/oljwtzcNDq9ZWoXMmCKxRjMSORToxeVPzrmpnCoZO1CEuuruCIno4BWzG3YUfaJp2j8ec22XY9Gi1G+PLTIPHGp+OmOlZiLv87fRWY+U0x7K1lDVrPLU+UStaNu9QjhkR2D0cckZN3KGYjrTFQfSL+8ys1spohwSUEnkUNtALIht1bYnM/ZToF6gzzMmcV1JgwVBfZWb0932ziFW1VNJlyVNjI00pc9HrpaLUA6apcWthq7z2xLU8h/mmT3PG9Pc3JxvHGedqffTqj1c0ax1TFemuE2kY24dIDX8Bqq6SCH6+TzJZIJO7YKpGTI1tIM1roe0r0yx6A4MVJmoCtFwgTmyCPwp952Zve/wvQBgBfDfoSFr8prPXHqCkrcWIbPXSUlodKTahaeIo0TYek+eTxS5PSe4z0ixBs4Mq+dmsborAuj1QmKxZiFqPqtHGEVqWZjFuWOp9hqBvxHvPj8omtBbCXesas6zw9oIKcWeqv5hVBlYZ4NF2xk9KpXgT80RRuxfYe2z8VcfiuuejQdiLY9W4+Onl0YUJgbRHveiABbefY3opE2dJCvAHEEIhCR4qiM7lnI9+H+X50X+zLSCVFXZ7ioJqIwTFZiGVD6i5CcpL8RlaH/2FI2lfnzexF4rdxQEnRAPLLUqqEzX+2KKxyFntEnFu/I2pgiix83sDW5312+mYXETBWe+23ZaM/aiOqC/e3CRocnYbH+ThUvfcvZihoOoMrHS4432ehKF5OAfCZ7QfpZY21oZMovRGtgJ0J4IlCpdFynRbKodQx
 aDlf5VtK
 f5cxDXgGiPMEZxJ9yLwcUy4cRVPze4kd9QOfRLxgOauZi43H7ROpRyqCppLIxDL1/jY/JsXon0UoMbG75m0Qj2jM7p6brdtmEwGi1OBAEb+jjlOZM4cKXYGCWY7JNoXB5JyiLpaXb9n0YcU9c4dBUqBoVKOBX2kc72l645Tiw1EOKLlixjUEWNC7gYFyoSYA7n0S9YlL+2PtjXaWpHsvvwmovlw1RJdlHBxjiHXW5Q2w40kZxTGBuI4FcTbja9HIE4yNZincQVXkTGthqTm4FejMfHwSQV/j7xOIWHTnJUNpBv6X5RPHtmVs94oyMw876enjFmh3OawzI9dOHN7YfU1/NPjMN5hoheXBNPcLVBPYZyvcWY5ha0VeRFfSHaQyqYHXboWbIdNM+eoUGCKAffP4DZsFydi8M3yBBhRT8I2nafGj2/a17TTzIE+uXUumpp+EHXjg7cviro+e5n9r/CvU91T8h3oRDUgwVv/NovTnUH3F4m2osRr0YDnY/ZBbFxWkH
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


