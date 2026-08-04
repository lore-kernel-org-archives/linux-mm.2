Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5850C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B157B6B00CD; Tue,  4 Aug 2026 16:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5DC6B00D5; Tue,  4 Aug 2026 16:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CAC6B00D6; Tue,  4 Aug 2026 16:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6989F6B00CD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:35:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A3FA1602A6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:35:48 +0000 (UTC)
X-FDA: 85064743176.28.4959101
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 945AC14000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:35:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=HmEN5pZQ;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfPSIGNtSNCrYmnAjCAJSktSQDthCNJqrL3J4J7+FmE=;
	b=l87RzoAQMG9HqyC53a4O1RcHBzGCJAMQup/R/uwVRLGlM9/I/izNsyPgCWX0P0FciznvyY
	DdlMNtzxhoRhsxBVf0v7FxPOdawCwvJipBn9d2Y/P5E0ylBFaThDmAJFH1Z5VTDV07dcKX
	aLQpIMhzPdrDw4jqBIRhj7OK1hI/Efc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=HmEN5pZQ;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875746;
	b=CfMcbAKeq7pYtDO+C7JzaqjyNw1vCVt1GoCO44BMN/RuPfvGR4Q/GVq3g9Sb52S4/OhTj5
	AiyuiXz8dhtQnqeWGnKdOKgZ3mmgsH7YFbgcCcIdYh4mnhxloi6gzsikHh3blxjjUownzt
	2PIcQeFL4nlluMKZcZV1qnDg4+RfPh0=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2942640E016E;
	Tue,  4 Aug 2026 20:35:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id G9xu28hJndJV; Tue,  4 Aug 2026 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785875729; bh=DfPSIGNtSNCrYmnAjCAJSktSQDthCNJqrL3J4J7+FmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HmEN5pZQO1cKYlPgMAo65EnTIgwNhdAim8xqmSG4ttbRFwy8V4QH31OiveIXudeHz
	 lLQ2DBk62mVo4s5DRFi0K4KwxKTtllyenYtsO2ePAG59cJ0XTmWRt/fxJYqlCyzDRn
	 Bqq93WIV6BLQlmZUoH+OwNIAjGrIkDtRtdKoEjgNbDr/6wpVRpvTxiN4RaN2Gd7s34
	 ACmBPodoaYPhLKgx86l1TEty8mDHTSe496UMG02V3It8ayzdoJ1mur2Q6Jxw2g5bXF
	 wqel4Euvgie89cJw5ANYmuCqBJLyVUkKKabFB0jMeFyhJhGcvxVw+JG7gO9g5zYy3e
	 DlLU6aLhbbZ/VjQT7p2H/TuatxG4W6XMxFB3Jc0T8Xi+vODVNzn5hM8ejf8mWi/9ZL
	 3/mnZxTldZZxcJKdUfgHeRRefjevS+7plphaeJCViSoUrHUj4uaJTAJvhdKNHuRRl3
	 X3KnAHNz39CiACbbFAkhdPnNqIWnalVxKRrkYrHJwNNrcTciE9IHNXIaRmZSpDtH5w
	 /yHtiw4nnoKLk1SZY9WCjAoXZ4UtHCk2g3Ujm+EjpNMXtnkLa2bhWWGVl47QUga4Pe
	 03vn0uLw7tjwQNm/AHyG7AWe105MjvuAqYWIVTrut9R5oq/MT6+ytYyTnybnjAuFbj
	 VCdtX2dFjL1b+Q2otoXv4sFc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3B33640E014A;
	Tue,  4 Aug 2026 20:35:12 +0000 (UTC)
Date: Tue, 4 Aug 2026 13:35:08 -0700
From: Borislav Petkov <bp@alien8.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	balbirs@nvidia.com, dave.hansen@linux.intel.com, david@kernel.org,
	kees@kernel.org, mingo@redhat.com, muchun.song@linux.dev,
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v9 8/8] x86/string: extend memcpy_flushcache() fixed-size
 fastpaths
Message-ID: <20260804203508.GEanJM_LGXmItYhFKZ@fat_crate.local>
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
 <20260803070929.86075-9-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260803070929.86075-9-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 945AC14000B
X-Stat-Signature: sdtcnm5szzxpp3fy9y6ymn7hksjnkoge
X-HE-Tag: 1785875745-238753
X-HE-Meta: U2FsdGVkX1/rId0IT4/clFEZCW875XA98AlisE2UVsZr53t4SxlSVr5FEApLckPz7/DM1URSe2jT+tme1T4dvUSvHB4BFHBP3/KM2eIpfW03O79ChhRlQg4onn7l/a4kMAdG1y12ATu1DD3JAOiGwSgdoE8Rv62tO6jTch6dPZ6Uu3+jjMZ2ABdRCYEbEfppNDfqYOA51FES9y5tvuf27gdWJsdutkhvulyBq1OCMPiT/f8zxyL5EvrcrEXRYdpICyCUVloedCcgJnv/6L2q1zn24gKAlrHFyX5kR+t1TVZTlZcbuI4gYOh1SO8KIMbkH13uVcdQglrIAoomwIOvhz4f/85EeSdCXS4fDXErjvs0/YScVbR1RyA5Aq4XkSvXkDtRepKarzLXSU0jNvXYXWxQYqsHVSEkmjbW6D91OjLA+bH6S0hJ9/l1Zhru1iAoyamcRXKkyTVu5nuByp44scFYN5WKJJ1dVJCwY6eHKXCRl+Zt5rJ4CiVIfefkK3KrFOrYfUM+l8KMthAUvhBDsBmT3sRP+q4wtmvB3qFrbbYPvPS+o5R6RPkO1Od0Ej8vdhHxWyH5hV6gPj+OSfMRnGPMFyGTbgvUMBBaGbhkfc/Gsupq+ewjcQK1BC8WXMEmTEv+VhTAZMF20u96wY2TqxzoJWf6hjtLcsB9FWZ7tD0ryVQ3Enr5JA1u7vK192bJtJ0Gh70hJZ0q+Til4+b8b/d/5fViS9gacT51rdMnDwlP3IOazwS+dNgFcek5Mth6OoYhTva73ZYseemGnly1xjDKdUUDZ/lbiMDB2+LX+W7i86A0mOI1ZlEcTPl1lJWpWCmexXIszMDQgxo9cypHeTGkYlJtoCBkh+bej3vtpCkHroCptoxkYn6PgcoS9C8/viEqvcKu22jHtRJvQjpYinC4TY6aftF/t30WsLrJYlllf0R0paEoMEGPfe20q2ekkaIUozt/0bgDI8c+/+t
 wSBg5Bpv
 MDNj5doMeeQO5idin4pyeTrzwodgOygXsIx3Mw8dK5TsHPZpnEtHbuS1mMTKEEYi4Mecwzwqzr3lmu198ksOkNbfh1Fnb6h6TifBPnTdTpdFpwGbML85WQXnrTHBJbBd6f9yP2HKI0YSt7G54+g2ty4FsPp6g1VcOstG3BsVpSt3AoIdJ4bfi3fFcGNpf5Zz+9l9VT1Dtr+0LQFLTM/aKVs3qxotUk9c1ZMrM1xP5F709sDc3ORK9G0JWbyXEkPzV5dsZIVOUjYon6DWpAhOLEjcjSrZBzYbFg4DshaPbOYuWOaXp10Y5iYy/0b+HDa3/V5WD+IpQBQPi47SiELnabvVP4wnbF6NfT1PtIwnUXFvWNeDXLSyBBxlxpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 03:09:29PM +0800, Li Zhe wrote:
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> server.
> 
> Test procedure:
> Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
> initialization time from the pr_debug() output of
> memmap_init_zone_device().
> 
> With memcpy_nontemporal() used by the ZONE_DEVICE template-copy path:
>   Average of rebinds for nd_pmem driver: 150.83 ms
>   Average of rebinds for dax_pmem driver: 153.55 ms
> 
> With this x86 fixed-size fastpath patch applied:
>   Average of rebinds for nd_pmem driver: 96.79 ms
>   Average of rebinds for dax_pmem driver: 119.04 ms
> 
> This further reduces the average memmap initialization time measured
> during rebind by about 35.8% for nd_pmem and 22.5% for dax_pmem.

Testing methodology doesn't usually belong in the commit message but under the
"---" lines below but this is important enough to keep it here.

> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  arch/x86/include/asm/string_64.h | 56 +++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)

A quick and untested cleanup ontop with the potential for a bunch more
unification. But later.

Note that you're inconsistent about the "memory" clobber. The current code
doesn't have it, you're adding it to movnti_8(). I've added it now everywhere
to be on the safe side - it would be interesting to know whether you see any
perf difference with and without it in your use case.

Thx.

---
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index bc6a9f34b346..3a1e1f17431b 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -83,6 +83,14 @@ int strcmp(const char *cs, const char *ct);
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
 
+static __always_inline void movnti_4(void *dst, const void *src)
+{
+	asm volatile("movntil %1, %0"
+		     : "=m"(*(u32 *)dst)
+		     : "r"(*(u32 *)src)
+		     : "memory");
+}
+
 static __always_inline void movnti_8(void *dst, const void *src)
 {
 	asm volatile("movntiq %1, %0"
@@ -112,47 +120,26 @@ static __always_inline void movnti_64(void *dst, const void *src)
 static __always_inline void memcpy_flushcache(void *dst, const void *src,
 					      size_t cnt)
 {
-	if (__builtin_constant_p(cnt)) {
-		switch (cnt) {
-			case 4:
-				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
-				return;
-			case 8:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				return;
-			case 16:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
-				return;
-			/*
-			 * The relevant fixed-size copies here are the
-			 * x86_64 struct page sizes: 64, 80, and 96 bytes.
-			 * Keep 32-byte and 48-byte copies inline as well
-			 * instead of sending those nearby fixed-size
-			 * cases back to __memcpy_flushcache().
-			 */
-			case 32:
-				movnti_32(dst, src);
-				return;
-			case 48:
-				movnti_32(dst, src);
-				movnti_16(dst + 32, src + 32);
-				return;
-			case 64:
-				movnti_64(dst, src);
-				return;
-			case 80:
-				movnti_64(dst, src);
-				movnti_16(dst + 64, src + 64);
-				return;
-			case 96:
-				movnti_64(dst, src);
-				movnti_32(dst + 64, src + 64);
-				return;
-		}
+	if (!__builtin_constant_p(cnt))
+		return __memcpy_flushcache(dst, src, cnt);
+
+	/*
+	 * The relevant fixed-size copies here are the x86_64 struct page sizes:
+	 * 64, 80, and 96 bytes. Keep 32-byte and 48-byte copies inline as well
+	 * instead of sending those nearby fixed-size cases back to
+	 * __memcpy_flushcache().
+	 */
+	switch (cnt) {
+	case 4:  movnti_4(dst, src); break;
+	case 8:	 movnti_8(dst, src); break;
+	case 16: movnti_16(dst, src); break;
+	case 32: movnti_32(dst, src); break;
+	case 48: movnti_32(dst, src); movnti_16(dst + 32, src + 32); break;
+	case 64: movnti_64(dst, src); break;
+	case 80: movnti_64(dst, src); movnti_16(dst + 64, src + 64); break;
+	case 96: movnti_64(dst, src); movnti_32(dst + 64, src + 64); break;
+	default: __memcpy_flushcache(dst, src, cnt); break;
 	}
-
-	__memcpy_flushcache(dst, src, cnt);
 }
 
 #define memcpy_nontemporal memcpy_nontemporal

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

