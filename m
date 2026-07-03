Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6B7C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB78B6B013A; Fri,  3 Jul 2026 00:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DC86B013B; Fri,  3 Jul 2026 00:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F546B013D; Fri,  3 Jul 2026 00:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89E316B013A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5C201202D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:01 +0000 (UTC)
X-FDA: 84946147482.09.152F53A
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2048F20002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:13:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mgOB0DZh;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052040;
	b=3bsqCKRaZz2wCfigEinfmckxX3gtO/8A7kYtfWOucqqX9nX0XaD+gW5LLXZp2YQzYMhBLO
	BzMHzwMQQu0rKKpWjqfkAOw7nJ6nwq445Bnr1QFSpGPVckDI1aJLDBwj16gMGLLFXSfcHh
	FdGD0YdKQMrpcMcIMrYf/MawalW74ts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIaBpk+cC3a2unYJH6KOjVsgZL7HXEgoxVhGp5CcYCQ=;
	b=JLf1jUEjWmZsI3ufkVCCWTSFmg4mtYr6UYsAzn4klHTCVF5DosN1/dNMm2VqdoXJeZwEJy
	+VX3yCFgEl0H+//x/aVMRuGJ8fTiS9XSPAe/12hHkAhXQroFS1oD6i2CCQRhajoMccRRn+
	dw+dleyi7MmBLl0zaY89PiZ+5cCyf9A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mgOB0DZh;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84794e800f4so68602b3a.0
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052039; x=1783656839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIaBpk+cC3a2unYJH6KOjVsgZL7HXEgoxVhGp5CcYCQ=;
        b=mgOB0DZheLURFaNDITKgF74AaHvPMSJ5+ikxPi8A9BCxwweDUIdt81XEQTHS1r9qb3
         sKJHNfiCvi7VvMX/dMDykAy37M/bmqPQkzRfD0vvIfzLkrrhQqC3zpC2nRs3EG2lwFSE
         lVD0SmfKTxwXAGUaMqSnQuBg/x53iPmGwNHtJJ3MyBiKf5TV3IgOA/Rn+/Ogo2nkDzQS
         RKtMuAiRjQOlQJOCDICiluo2YcAnWV2V0o8Yejr3pxK1D+j6AEPt69MVDs5gQbvkmsX/
         fIZWr5ufEZ/cX7gzpZrjFZJQyvhjJc69Uj4KH9yZ4o950qv6RbrwIHT3I0XW/NEXUurN
         cnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052039; x=1783656839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sIaBpk+cC3a2unYJH6KOjVsgZL7HXEgoxVhGp5CcYCQ=;
        b=esfSK7tluVosmsB8yC+r8znQms3ZxFGmbaNqbbe7ZDlHL5LjtGuSQPycYTrFfYZ7/f
         2iONBHCTls98ykvGTfpU6an39jpQPFvQuqKWDeRsiEjAk7MzO7t+SggveUYXl8YAvGMq
         gIsm2+xYtuahebVgx7rMCyrZrneBMm21XRnY1UVEhTYuV1ffl4KUMaN+0qTo8ENsym+J
         bb+uKGb1v/WMsuyFeS9/F6BWpixMOqTwqHG2/uXdFWhCJMF/P6KoNL+xWnPNK7eRqFtR
         hdHSGgTWsRqI1Gawe7aA+Y9xrOSkgq9O9BaB5wsuxsIBDqBMaV8b1wRTPrE+wsbDNClU
         HQkQ==
X-Gm-Message-State: AOJu0YzAUPTODTlz3OzeuLIEhIveExGaEpX5eG6aRxHnKA5asWNlrfez
	+UIqRZggb7U1DR5+31FbLW3aYQ/lX7mVj6Rt8jirFCzrmRKZUIT/REN6
X-Gm-Gg: AfdE7cmLZmn1Dsbf3Hu5WqzSxSQMKoQ+vnzMpWxqFXJXodKNhigx9lak2TRev9m+eAU
	gArb01c4j/60AqyjqTSLbzsN6An1IMnMw/Lx7zPh9kc6lZgImd8ejzTPyKKWLcjJZgtdRyPP9rr
	cV67bD25De76T5p1l6/IWILzBO5GPlk/L9ks/i05f+tOFbgm2eA60DJiw++pPvgUmJBoDWGsL0r
	XPkhDmyifsMFeuCafChuexxmYlBjn5+ICIlYzW56ie0pdXW6YUQMs2m24rn6K5nBUSTgKFDK9I3
	yVrc2FHfebhb43eR7YJNQRrcwiL5ujE9WlU8yarfMRWePCqEOY31Rx7IOpLgB/kaEBX638BS7l+
	Tcpc+/LLWhj2YNho5riUi2OSwtgbPZ4pQbEG73+0B39D0wDDLDcbovInWxcM/PwSjik3WT0esSU
	GJupXzbz0=
X-Received: by 2002:a05:6a00:1745:b0:842:5711:9a2f with SMTP id d2e1a72fcca58-847c514001fmr7765902b3a.36.1783052038847;
        Thu, 02 Jul 2026 21:13:58 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:13:58 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 1/9] mm: numa_memblks: set numa_nodes_parsed in numa_add_memblk()
Date: Fri,  3 Jul 2026 13:13:21 +0900
Message-ID: <20260703041329.2797584-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2048F20002
X-Stat-Signature: guh86oii9e9q74mxdpd7m1iqnk5fhpqi
X-HE-Tag: 1783052039-912648
X-HE-Meta: U2FsdGVkX19PpjoQceMLGa5GWE0andAaWQfYILg/HMUUxgh1tWZiJfb2Ll2rjVkjpahth/qD/evqDbYR8Vv63M/QTjEPHbxeVPObQL/fgyI6T0OdUebD4NaFFFTfbtLXbsrHachDQi/rjamfmramoUye3X6bj6WUDQaiWkOHkOjX01wqsAE2K7YE8xuFYIXT9IHWUt/Gn5cVJzdZU2HXzidjPuTALRC5eW7vkG6FwAqvpia4pvlLzPx3wJZSOsSbzdNRR88qs5CZz3pil8a0s1Asg5YQZvXpLbiBm/niBjFvbH/VwVYMOWeBnqCpBNsoI+xL3IHWE9Mf9r6LqY1gAgXmn6ld7KjMULCe8+IP9aQHgtJsNZ2kXTJNwGdbKeUUmIpCL2vrcjp769cUjowBRBtb73dOULdWVn25f/qZKkkJ9QV7uXyZiDs11gmXqoz9UMZFQRiYM09ZH5461qpS9MGR/KC/dfZmxzBuBd23sjx8TRHlls/mbS8Q/zBNPMOSUf2h+N196sx7csMIucPQsae75mKD4ew6SdTT32OO1k5agNRksTZ7JFpTSAbIy4SYO/g1oYH5QcKRU70W+ozfJU3P/EtLn/O1SY8p7rlIoDi3YBsjQ29Yln/kJWAq0f8rjY+0L5poIAyhx6Jf8GJ8pzal9U1lHcHaSFGKqjmMEqeAjYu7foIJvkY+GXHvFUX9N0rS1E6GuP3p1+MSiEvPJv5FILaMBmcbaMv49rP9fh3IJxzmviwATX8XpF4MgDn3USurrS70W0p7CrEVtFlAlCcxweI3aXomG7xMJ38jmujCKaEF1WHiXy2sebe8P7BQ9A8fiFhJttAUoRO2us8Lara3s5FPxnDoAduiHOl6F+xOfg9QvC3NQ4XQ6Uaayub5DVijZxuSehF7xFL31thI4CX7l2k5qJSu1RNuxQeabTlDrGLErhR7Ms+3ZNC9vPOpT7KmD3bJ4TPS/p89qAn
 2CmpmR9p
 nnpEfsiTPMiBAtxBC/P8yTQEcv2Z8JMPy0AH+NA++BRFnVU0WmAsMKgDjClPlZL9xxZD0Dka8CbErcx6NZqdo4R53/bnTV5ANohXP78/g2mkmrsgSFP5sSCemjKVjmnoYzqQ2asYsiOBqsGTXic9Dz8+xg8pChFjUnhk6TXzV7IEzOFrCLljeU6x+j+HDao4wgHd87ZvYjgSmr7lwQVdB2P0yiqqYRVUcPyH5J1KOD4Wm/N67ZJZ9IqE4MINxRFJzwVC2z4z3vXR/5n0L1pT28wwIWet40yb8ZvE+B/C5OxwL0sIN5d9mKRXvjMrliHMXwi/tsx/YwZmQutmnleRSUhtEQeiHe8XUEcbpKEJSvSVPNjxP1i7R1jCtwb5nJNC6CNsWlcdzc8PuIHTZE42TydzcH5OaGBJsG6QtW5vgwMpXwP2FAAc4Ku630aO439HlGhgvEBK9c8bXzqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every existing numa_add_memblk() caller separately marks the new node in
numa_nodes_parsed with node_set().  Set the node in numa_add_memblk() itself
on a successful add, so this no longer depends on each caller.

numa_add_memblk_to() now returns -EINVAL for an out-of-range node id, so a
zero return implies @nid was valid.  No caller passes an invalid one, so
existing callers are unaffected.

The per-caller node_set() calls are removed in later patches.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 3c3c4eac3514..9815192549c3 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -135,13 +135,20 @@ EXPORT_SYMBOL(__node_distance);
 static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
 				     struct numa_meminfo *mi)
 {
+	/* whine about and ignore invalid nid */
+	if (nid < 0 || nid >= MAX_NUMNODES) {
+		pr_warn("Warning: invalid memblk node id %d [mem %#010Lx-%#010Lx]\n",
+			nid, start, end - 1);
+		return -EINVAL;
+	}
+
 	/* ignore zero length blks */
 	if (start == end)
 		return 0;
 
 	/* whine about and ignore invalid blks */
-	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
-		pr_warn("Warning: invalid memblk node %d [mem %#010Lx-%#010Lx]\n",
+	if (start > end) {
+		pr_warn("Warning: invalid memblk node size %d [mem %#010Lx-%#010Lx]\n",
 			nid, start, end - 1);
 		return 0;
 	}
@@ -193,13 +200,20 @@ static void __init numa_move_tail_memblk(struct numa_meminfo *dst, int idx,
  * @end: End address of the new memblk
  *
  * Add a new memblk to the default numa_meminfo.
+ * On success @nid is also set in numa_nodes_parsed.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
 int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
-	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	int ret;
+
+	ret = numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	if (!ret)
+		node_set(nid, numa_nodes_parsed);
+
+	return ret;
 }
 
 /**
-- 
2.43.0


