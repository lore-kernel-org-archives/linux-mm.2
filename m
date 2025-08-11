Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E705C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B778E0012; Mon, 11 Aug 2025 04:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A238C8E000A; Mon, 11 Aug 2025 04:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960138E0012; Mon, 11 Aug 2025 04:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83B398E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:25:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E4481A074E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:32 +0000 (UTC)
X-FDA: 83763792504.12.30FFE76
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8D89140006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mVk5V2vX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900730; a=rsa-sha256;
	cv=none;
	b=M/jtnBGyZGmZBXxbF3POZLWMvukh4dbREWKcvPyTQRJgkv/9sNYG8N1chm9YKxo9ti2Yk7
	YD55IzUBPw6QsbQGw9I+KJY1vEnpRqOxG5LdLaBw97NbD5fol7Fu1ZEabapex1vFvBra7e
	BXYaZsF3zYB0680fDC58Y5QPUhtJZug=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mVk5V2vX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSz15bnga4zoRgDp622ci0X5CLrX1Thjc1ekKQAUr6g=;
	b=s7rLycj479NqgHH/2B59oHTZd+33Fw6t3ku5VAxzbT2G2OpKeZ72cR6wesfkGBRh4jDdrx
	8i7GmE3THjCb647FLIFe2tqpJodIfO6QbxHQcyEnbBCjrAjcSTafzxhMTLEJ3BvF3JFprG
	3gV4m16GWdhJq/El/nsgtEWX4rTRpHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A17DF5C5BF9;
	Mon, 11 Aug 2025 08:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC748C4CEF7;
	Mon, 11 Aug 2025 08:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754900729;
	bh=GD0CZJPipj/scvOiwO86D4QvWu2bhvyPoPfEPeM7R1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVk5V2vX3KTa6TTrst2P85RRH05lSqF0XHkEtbdHC7XoprqtDZ1clLzEoeeQ8KLuR
	 U6PvynDjMIG3Eo9QnHWbTT+EKN9IVGPnwNaBEfjSi/uckjWPQn7KJFqgA4CacMTKw6
	 9wUZQVsVqwXh5eewwvehW8hxHCT52OMZG72LMZ8T9+490eIS1WoY9Rp1p+4OcK6hqn
	 Mzc/g6UG3olKoudsttAg9N2gc/ZMiXq445iE0fnbZLPRIy/im7Pd+LUShSAu+DHdfu
	 ep2YrMSWxgbIEqnKPB/RMVav5E7YKyX8IPyz7mVX+c1mKshftSmB3rxoI1wNbJ3ddY
	 PWpdlLQJ294vw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=DFschuh?= <linux@weissschuh.net>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] kho: allow scratch areas with zero size
Date: Mon, 11 Aug 2025 11:25:08 +0300
Message-ID: <20250811082510.4154080-2-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250811082510.4154080-1-rppt@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D89140006
X-Stat-Signature: w1scdxd31pybb4jx39cexzggg1aenpj8
X-Rspam-User: 
X-HE-Tag: 1754900730-130983
X-HE-Meta: U2FsdGVkX1/W15LdQx7O0K2hMEJQNxdfSVlMzH7eN9rGkuPXQ/R+RrV/ynOnemuvk0SeEeNCSeJVYuIV6Q/pK21RvGjq/M1BSUiMhuxIhokz3Ji6YsdGNLV2DV1P2SRI4uSRJz/laznH9M20e2aU8XCU4If8QLoNgnomG5BgN8W+qIIQnOoDOf20dOFjpKwop6ljCTNFDcOIuhcYVFb9VH2qiOozxzStI3tw1JqJEk1FVgmUHRIdT869VGYKlTUaXHHRR8Gywr4coiMhTD2yeLp9FLHFTepBnyX4QA2kUUn+5qCP/s8XCK715BJ1SAelVZ4b1D3QfpkjtYI+Tn0VvfGINi/M3nAsb9bL3bIJzKRDCCASDiLG4m1O3DYYPQg4gX5sEwWScZa1Vz/as7s4iUWuGagO1zs7qm4XUaQHfDQWFRh22U0jkEXtxjirfDK18q2QymnSuTApFdQPPJ9s2Rrpnew5hk46TV8LmYCK+dDr80EwXV7m/ViI8TYWhkM68Ampi/8yBVyUdlNC16VTldmtSHWpJTktLKV2UCwIsHTVnUJsolJPa2+ptnmnfMYGcV9Hc12mgaSMSTSD0F1xb8F6f5NciLRH18WesenDEa524OfVqLdehbb4wC7FjeVroxRjM5W3Iwno5JC6X+JO1VSvGQ8WZ/grEjEpTEoi+yFVRUw1uVd/UiQ4TVdOill8D60xtSYjsTJ8sD+YVhdrBFfSiVR5YNzL+GWmCfxlZQIzQSgFpMsGornsR22kW0AFUSlvCrgvZXgKMh9bp8Wt2CWqa70mFkjqsG6H5I3oavK+Yo/epmkR6jufWiUaNfn1xLb97gLhRb3qQIrISvjLhL3+OZAukz3cYzDfvfhLiZKgzu3wq/4ifnOEQIMMs1qPQUjEWD1j1bYUj0+5zOStWOum0e08mWGUGvMFIxcBjf2Vnx1Dls1bH16e9klXsj6g3myYQMG9ZcpfdPa93tH
 4WGoyoBz
 YZVAl8QYzCm5O4J0TgVlCmzeLiiAUBYGISUILL7I+wCPLz0xt3JIK5zVS5SjgXY+Ry5KkWOoYwiZiyscgNHvGQY9iJ79Pew3NuMsDhSBroOer97VjrCqz1457bLUCR51YyrZyRDEOZcOyHC16IbXlKY28dno8HjS8aKfCiesDIn5foHoBFoPkybpIQ1z5o5z8bKQafqJjDMtKGhsbqamR5oib9XmM0OREurC0rF5042Ouv1585EQj3mkOwwADHGtzyu+FdSOwiqBCVN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Parsing of kho_scratch parameter treats zero size as an invalid value,
although it should be fine for user to request zero sized scratch area
for some types if scratch memory, when for example there is no need to
create scratch area in the low memory.

Treat zero as a valid value for a scratch area size but reject
kho_scratch parameter that defines no scratch memory at all.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/kexec_handover.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e49743ae52c5..c6ac5a5e51cb 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -385,6 +385,7 @@ static int __init kho_parse_scratch_size(char *p)
 {
 	size_t len;
 	unsigned long sizes[3];
+	size_t total_size = 0;
 	int i;
 
 	if (!p)
@@ -421,11 +422,15 @@ static int __init kho_parse_scratch_size(char *p)
 		}
 
 		sizes[i] = memparse(p, &endp);
-		if (!sizes[i] || endp == p)
+		if (endp == p)
 			return -EINVAL;
 		p = endp;
+		total_size += sizes[i];
 	}
 
+	if (!total_size)
+		return -EINVAL;
+
 	scratch_size_lowmem = sizes[0];
 	scratch_size_global = sizes[1];
 	scratch_size_pernode = sizes[2];
-- 
2.47.2


