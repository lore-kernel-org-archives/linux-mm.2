Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E52360A261C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBDNdFbN
Received: by kanga.kvack.org (Postfix)
	id 2B0A36B05D7; Fri, 20 Nov 2026 19:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A546B05D8; Fri, 20 Nov 2026 19:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129206B05D9; Fri, 20 Nov 2026 19:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E15186B05D7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EF30C0289
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:46 +0000 (UTC)
X-FDA: 85457195292.18.4A9B04F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D25251C000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fBDNdFbN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219844;
	b=UHc3638W9GbJbyJEUWY3PuyAfaGzk8tPP4eAcRgcxCZGI+1edhgcGsAc72MCYrcuAEQ8F6
	bw5h9aHFLpPNE77wXPsGT7yVWAbX49QLEaiKPwUlmqLZo/CE0XI18F6DoiGNbBVPL2O7v+
	UVswAse7GoKRRQXJi6ggWduMWKEb450=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=wI8FEBwQdjmpujwo939OW/rCjV4rS3vXfIeJGRuwevVVhpiYCA3GCQ8mXtITR7CWOYeqNa
	9MchevUBv4wInX2bpoTXPdCP/L4UnLZHoGfhZUw1UY/o/VkFO+GfqJNvDiohKEdzxEqU2f
	cOYVv8i0isZqIn2cBh4hGuZ6ybdgN28=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fBDNdFbN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 2EA2744D22;
	Sat, 21 Nov 2026 00:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 84AC81F000C0;
	Sat, 21 Nov 2026 00:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219844;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBDNdFbNVJ4c2R5l21BN3Q6Yj7sCXFhuqkBWMB7MGY9VGnU18lQLctOh/0TXBJw1A
	 AFhfJIKGI21WemZTyiQ43YZrKXxrNaUKh8fARfXnWGA+2KLCuwhpbxnNc8pfVOLFgB
	 aItHE1rE5obmsDbiFvA2QueDhqAkL6BlPnyhtBQXEqha+3WKl2dokM63Jy+j3tDPZx
	 BsHyfqL7xTYDzsw3Q0MEQDZ8ntZxKX9PqU50i9o16YGBTbxsAvnmWsi/sE5nQXACPp
	 c2JK74RbPnfBjJBDYCzCTBkRxFM1JCvQeDnjjgEevuQIBei9Qe5zhzaxO4Cmyd3aNQ
	 CcsrBIJqvhWeg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 25/25] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Sat, 21 Nov 2026 02:08:44 +0200
Message-ID: <20261121000844.1863324-26-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4uybwtxu9gew7aqmeuznud1s4prnb87t
X-Rspamd-Queue-Id: D25251C000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795219844-948272
X-HE-Meta: U2FsdGVkX18YdinFSi58r+BuHoG9865Ya7Qqi3nq6nPz88uUVgr9vZ2iJXW68bEBb9aiBn/JHTtfxQJms0Yajx+FqUQzIrSPeWZ/Euc1Oxv/P1QUrhCoB2TDzjSzFFa5cXIMVmnMv/79l6TBfnoWe7wa8qCocLTbmcDmVkwvJ8ZXnXEgr2jLbhKkv0SvsP1OInK2HgnrthN9CTOenyxecsvRWFvFYtdJuxpHNFvqGUuaA1Xc8we23PLDXQJmszsXqajhAGYt5TYP1UNqIa0ybTOsz4FlshU4AbQItau2yYd+ACqRfVM9UMPfwIw47wc4p9SSkiyZ/tapDIJjny2tRkz2Llc9DB4Fx/iAhI56WLsCYZthCVexaI1kRWr7nvUdt0FsBRaZaIPqgGALDbqU2y4/R3l08zYgvjTKqnr2aMzcnZbMTg9Vbipv9YT4Y3nzcmwZkcivtjz1wiWC4qY8kqprlA/N0je6NmwVwPkb2/fnNiUTszAW7ZqNRl83ese15nPTivAjd1Q4FB4LjwYmIVO0bKMSQNY+d1v7KM3ocbdKYDPwRI/jC9ySAEmpnVm/Z6ipzdNsWl/rTmL6x64kMx2kvwH5aC1JWsjgygX+38Qa/oFI3qXg72d4YCpjkC1LZbPRQfgqjxd9YStsrPcTpyFqfYVXkxEssZmbmNCBRIBW4TBnoO0qk6eoJoIayVaJuYh4L7/ln3llqlRjGKP/HfJBkGlwtGL0r31jTVTYXpfUeVnLkzUwD5JLaYeuSr/ZICZd6pGlNHrEpsVwWZ9OhJ0l6F9ZgcVX85T5V7hOVBZb8rmJV8I4RXlxODPRkjuLUcuUds/sJyqF4oUxgymtI718hM7hCcGY5/7kZDSr8InVp9XKSxiHIK0Eg1W50BTiQPVB1RH34Rnf37CmAt19R2V66TGrU+cYp2WHzE2KzZj2W9OkwFMsx0yRuMn3n9Qq44bZhCpxeyqhhQum78R
 7gNRTxTZ
 BdaarxrpTerINtXrH6BPPVjNplcikl5SYuovxpw0OUdDsr/5NzdVYSSy4RCjHfki4HIRWdV+APS3f5G+0sj0SWT6L6v0EuHaBEJ4KD16B84y0MuLeq4IypEfA8bUbmGqx6J7RlKmaTtdFNw/NIPQra6aKWfHex2kOgDIWeiECeu9p6EuviFequI/Aj29/G2EpbMm4jO0cg7DyzSWXrhMQJjxUnSkinMrndbg3JWl7MVWrO7xpWVizbi6UnjOAckoqgTt2o7A9BdvUtT0SpLgCHQdUHgVHQjngkJ6jY2RzMjusrEXDHvQ0fOl0MWySpExr/rfq4ZBtwzeF/8ONvU4zi0rkOMpuCSRfy4XDQkIZl9xGfobq0H5/kX5xE6FXr6ojtlcRDR9LBnnLolP75d7fkbBxslrNNnUNBLc4ycpRx5CCkSmYDdzoQ6OqdQwkXZxCsQgw1YL8IQEo9eaR1XGSIA4z5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Record maintainership and mailing list routing for the root namespace
subsystem across its uAPI headers, core implementation, documentation,
and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..072be5ec7fd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
 F:	include/linux/mfd/rohm-generic.h
 F:	include/linux/mfd/rohm-shared.h
 
+ROOT NAMESPACE
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/rootns.rst
+F:	include/linux/rootns.h
+F:	include/uapi/linux/rootns.h
+F:	kernel/rootns.c
+F:	tools/testing/selftests/rootns/
+
 ROTATION DRIVER FOR ALLWINNER A83T
 M:	Jernej Skrabec <jernej.skrabec@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.47.3


