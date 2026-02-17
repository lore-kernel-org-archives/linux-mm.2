Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13462E68144
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 08:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B296B0005; Tue, 17 Feb 2026 03:28:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD826B0089; Tue, 17 Feb 2026 03:28:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E93E6B008A; Tue, 17 Feb 2026 03:28:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D65C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 03:28:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7DADC4865
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:28:27 +0000 (UTC)
X-FDA: 84453271854.13.BDE487D
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf21.hostedemail.com (Postfix) with ESMTP id E02711C000F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:28:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771316906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/awg13Cq2cMwEq4JvU7bDTsdttanDdzWNRndJsAPxS0=;
	b=wT9yXBkrYIhUawR9xGHnf91CZ3D5ZXS0ILyrbCtCDVjILdLL5/1PvoCiunSLSAyMTV0zHK
	nmQLMVG9PS5GTJIpmVBUjjiW9p8FLrf8z6YSIi8vqslUvqI3pbJjRavHPBQut3Xghoj1+M
	0wOmFBgfnamuXpLR9AX1yqUh4mTO6RI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771316906; a=rsa-sha256;
	cv=none;
	b=3eOJ8+pIoPnATtPZvh5gObgSyJZDLq3/pUp56WtjFdAgyjBFglXjex0BfzvWmzXxj6rFqB
	pacYyxXLR8gS8+T2xAVEpSEyP6HVDGkaMb/6m2SJEl2MgL39CYHmwWBjj/BfZ6A9F03w1r
	R+hmKkAGukhBJliMspXZo8ttK2F28Hk=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61H8SCAm412409;
	Tue, 17 Feb 2026 02:28:13 -0600
Message-ID: <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
Subject: [PATCH v2] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>
Date: Tue, 17 Feb 2026 19:28:12 +1100
In-Reply-To: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E02711C000F
X-Stat-Signature: o59rczxtzkjf158t4p1tz6hris3x834q
X-Rspam-User: 
X-HE-Tag: 1771316905-614192
X-HE-Meta: U2FsdGVkX1/dEM7UOSwWPhEZG8gFpFaEIXugpLW3/m5S8ZWk1qTONvYmycn7ZoNi/JmxkYQn0ueaqtJL6S+kTjsTAN9vIti0RtxNYjA95GrtAikgIJQo9gbBlDj4v9uV5yFlgUNnvQAgTg3h2WyN2V8f18im+LZWkHkAspvlB8ucXH5jgfdRwYJmAATNiapFOSJDvdicqjrd2NqyidglagMu9iEvrHgUHXIAGH1BGk3wuFo5Dm6lbbIoRqRqQ1uhrSksMkwE45oFiITG/lwp6TDJUTWX7G0Zm3EM3GBuicPXEsiSEWGolxzxvZNmQoDD+zWacDiPHvIwPp6Hg5CpaJOZj+Dv0Bo0Wewv638w6g1rZCqthCXsIK2Llys21qFCPzL8Rpjs5Wqmsh+SXMfe8kWUX0iqCAEO/cy0luuHfu+mthFbu61m0G6YU7bNdp4YaPIfBvy1P7wjHghAbsQtdJvWXv/w6rXcfrKJDhKdVgS39+uvTIBKqBBYBzbtOZeQsPYTc4BButqhddf+nqT+nwOhkFb3JIGXvIDIJ1E3WSAFPl8tZ1m5aXeHxPPgtrj3km9LFv26jxMnPcly1djz7Fz8T6BgIHmbQXJu24E/g06Lmb1jqGxuGX9Q/+nxP6BTE4/c8n1yYSOYgNy4l+TtLfgtIt/bk6Af0ShNldYsBDVxfXYuLQ0nybJNxmtbtPRZOEZNgYdylCt5nl9v8UG/1EMswNswR9CPilBtjeGlcA+lsjpPtPWvs51ic8PWYF9keOjsYOiTccDjPs34GtDnwz0VsHIJZyuXJyGbGvJ/oXbAtfdu13qcUCqKq+3Qjj7NblOSCPmKg6o42n0UbXWqdKduCcqFRfE9fXk5AfLg4G6nhKoAl0enXjq1+P+DxcqtByybkgiNparCM/oQydUR2XrFGmC69uQZeKiZ29x7U+8n8l1FRdZC7HiBRGsZO6Ba5R8HX8qPys3/tjpY9Gu
 YYre/EL2
 6PmRuXE54TOqk0ESMffri5xrvCfNaEqkdpVk/RThNi/L78owbLnHEw6TOuzQcuZgqpMxt5+bc3tGm8WZd6CE4cFDJPMGfVpuaN+jV8K7rj6MQUdtUwQN9BZ8G7l9dcmsZ77blEaATRemHxGr2ci2y6gsEc4lEHjyufaO6VaSIRKTwSxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have two issues:

- One is we don't check for pfn_valid(). If this is called for
a page corresponding to a big enough memory hole that we don't have
allocated a corresponding sparsemem section for it, it will crash.

- Then, when using deferred struct page init, we can end up not
freeing the pages at all. This happens routinely with some of the
UEFI Boot Services memory, as soon as they fall above the threshold
of pages whose initialization is deferred.

We can very easily hit the !early_page_initialised() test in
memblock_free_pages() since the deferred initializer hasn't even
started yet. As a result we drop the pages on the floor.

Now, memblock_free_late() should only ever be called for pages that
are reserved, and thus for which the struct page has already been
initialized by memmap_init_reserved_pages().... as long as we check
for pfn_valid() as a big enough hole might cause entire sections of
the mem_map to not be allocated at all.

So it should be safe to just free them normally and ignore the deferred
initializer, which will skip over them as it skips over anything still
in the memblock reserved list.

This helps recover something like 140MB of RAM on EC2 t3a.nano instances
who only have 512MB to begin with (as to why UEFI uses that much, that's
a question for another day).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

v2. Reworked a bit to add the pfn_valid() check, remove the bogus memblock
access in debug mode, and add a test of PageReserved() for sanity.

We could separately do a patch forcing UEFI Boot Services into
memblock.memory but so far I haven't hit a case where that is necessary.

 mm/memblock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 905d06b16348a..71eb25b68851e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1770,9 +1770,14 @@ void __init memblock_free_late(phys_addr_t base, phy=
s_addr_t size)
 	cursor =3D PFN_UP(base);
 	end =3D PFN_DOWN(base + size);
=20
+	/* Only free pages that were reserved */
 	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
+		struct page *p;
+		if (!pfn_valid(cursor))
+			continue;
+		p =3D pfn_to_page(cursor);
+		if (!WARN_ON(!PageReserved(p)))
+			free_reserved_page(pfn_to_page(cursor));
 	}
 }
=20
--=20
2.43.0



