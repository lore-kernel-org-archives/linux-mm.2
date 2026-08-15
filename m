Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22EDC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CDA6B074B; Fri, 14 Aug 2026 21:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECA66B074D; Fri, 14 Aug 2026 21:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503816B074E; Fri, 14 Aug 2026 21:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF456B074B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6E74A2821
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:15 +0000 (UTC)
X-FDA: 85101846270.21.800EF6D
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf27.hostedemail.com (Postfix) with ESMTP id CFB1A40003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="y cL0gDq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GGCr6WBx;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7okFjne0ixAjtjgoZ2s//LBwIwAIBw11vdB2BGCtpCE=;
	b=A4wMNWbPczDjPyu7rGyvdnfCBu/9UEN0ZxPBoysoWdQOYHsV5qHL4aKiUzGtwiY+BSwW1L
	ZHIJNfQDSNaiCOpjWgHqZA7Aht9u6C0p488bCsiNr3+I4MsLYfeqPASlgN4LgTRYh708el
	44qCueQDOObg3XtdG/1EV+tMw9T8L1k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="y cL0gDq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GGCr6WBx;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759153;
	b=ZWxhbkte4x0RTol2wHolauxEDVinWhJigBl3GTZYJGLH+BSovQgRVHoam4znuvWmNRw0Wc
	mYRX9DXi8YhRrO9H1i9p+ipD/bG1iESlhL118MIZKKci0xbnxu73NylusowdPsyCeRfkdi
	ElwBbDoNaaUNCpwqG1HAC4dnv02Q+6c=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5EA4F140011B;
	Fri, 14 Aug 2026 21:59:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 21:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759153; x=
	1786845553; bh=7okFjne0ixAjtjgoZ2s//LBwIwAIBw11vdB2BGCtpCE=; b=y
	cL0gDqtgPktLYY5aC2FRRb+f7yuCgU8MdWuA0SE7klljNCwNCLsPFn/la/FNvbZF
	rZGR3cojZqugyPWWRAIuMwKMc2OBYqdPdg/0S8VflgFXzewbEtaQOtDvyZedDI8v
	SqKRM01cojAM85GkYGtyAmqokDw/8MotmKDo+07Sjp32zyPE/HfCiBVjQaDreRpA
	YX2wTYK4uvhBwd6D8Gmn/czLgVC/Rc6bTTK2BuNJml818+4L4vA4lLlVcUwFHtuV
	dC8CKDBXtMfsWA3vCwcb0t0Q1iVWXh0642XG/EhgURvpkQ0bbMy/JU+GO6DV4Abm
	otKTwGnQ0CmAnhHRpJa5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759153; x=1786845553; bh=7
	okFjne0ixAjtjgoZ2s//LBwIwAIBw11vdB2BGCtpCE=; b=GGCr6WBxBJoc7zMXf
	eLylOaM5YjDd508p2ct27iG2BHTO9mGezIvqpKAZExGHnPwx7Z7ADNCr/y9Lwg++
	DNCXcOM5oTF2w62Y10x7HWwXskLsLwrdCXriR5lp2jajbSj/aynyfm4yLXaDA5oj
	dYLG9UwRmHhyelgR91H7IzBR0AXLkSGDQwIGtIEPstUWMcYbDZMTht/jMgo4jsxl
	wDBA9hO3Tg9EL6mOU6fZTV+YuGKYymN25mxAim2gJENirnf2EgSGxxJVXoiDDbTT
	9/GHkAzgzR/j7V5Ij0ZjUc/BKufY5hV6cyIA8DfLw92AvpjEXXeaX10qfriMm36X
	1En5g==
X-ME-Sender: <xms:8Md_aoO7Y_9exU8iIQPInLfcHm6LNOGlUGZdv5_RmiluDGrZvwa4UA>
    <xme:8Md_ai7Q3Jwh3GKgxwqKWHQEYXrcwVZvwaC2Q6Hlz7JpUyw9j9E_WiVaYK8eQfyIS
    CZdX8PQCttXes5l10KQj0TGLZj_LY8qKjkBS41xoUjAjj3gH29zhW8>
X-ME-Received: <xmr:8Md_anw3M0Qey5tuzY74F-I9yQoQDmV2fc03X90T5z55CFpF3WLkz_xEZmA>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1Umx
    2uYvkBKxn8OCitH4tiS7XbwgtTqmllHcukvryTHSfl6vlnOrj8XmN2F/Pp+RhmKDmPC4+L
    3yFq30/qobTXJk46PT6w9GUjK37luykqi8lbz8fN5OsJvmGQ8lwD3kxlTDZ9j3RpCuP3WL
    3/N2LainzeMLlxA33wTciNriKMZA5r/iKGejBBnu11DrzDFNEivHfhPNRNe0J6yc7L+3IJ
    zdLsn9uVZbARUSz2715eFtGk52TKGnDW9r5S9t4RtI6DejdZMEaXeqjQsRojU+ix4bgIuv
    1P3KMEL0fom/+GhJUW4Obyvc4whTmI7i/V7wwRCeSIj7Z+wk1QfaxKD9FXCw
X-ME-Proxy: <xmx:8Md_aqQY1C3qkgnLtayLE8Hhr4q1Pb4EHbflTsLtWgUy8R3bbwU2Qw>
    <xmx:8Md_an8oas-2wxQDpC4oMkXiZEIkBMqex6pYZi7f5w0Av2ejIw46pQ>
    <xmx:8Md_avJp8iZQYfLJKuERsiFDGuEjO2NBNqtElYoDGhrlkgzqDVnjmA>
    <xmx:8Md_ajuubzf5O2-mHmYaGIoyOvLR7B9yxSciUtofGafC6M41G6yVdQ>
    <xmx:8cd_agsK5NdTvGgoSHbJVP_NTF9PFoEP_U32lZUkpnA6MmlwPK0p2QDs>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:12 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 03/19] selftests/mm: scale khugepaged's collapse wait with the PMD size
Date: Sat, 15 Aug 2026 02:58:45 +0100
Message-ID: <20260815015901.1236937-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u6rydnd1wfey6yyus1grjisc77nyyjnx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CFB1A40003
X-HE-Tag: 1786759153-892628
X-HE-Meta: U2FsdGVkX18uamp1G2Dd3QzsrCZ57X0rvav25t2n2S0mJE9KhYm/h2lSJ844vQK1/KYyMZxyAYdwoWOClSwq8IoQAAX6sCKzZehTpycKLtrppPvCy9F0bQiJxWddO7aMVAX4evx4Yjnm/M5nZZAx0EAVziWfcjoT1K7nhACiXYKsxyysQzVoeqSHjFzEIZ0fTSDqP0P5GjngY+5Z4QkUkGcwXHMOwsXHQ+1NGBPelcmLrlV447PcAhCksskv9o/tJm8bb8v3l+9t9tU3cRhBg/MuSKhNf3RQblMSBvP2bd4X0oq9act/QdVXk/JasRM/x1C6sRAOx7ChjwTHJUYBxg9046S0H8R0KW8SPLyw4GpD+BM5EWvjJlV9qPDgEYe3ImSXk6cTG40wmP10EwBM+XyvJgskVqtzGsLiocinAvWk1bTot+Xvm/20ciNKd9XcLaOk6KpjL3SFOu2J/9g2v4nXWUYUlxwXLkWuV8Kk/CmwRHtUSkd4YWQZ0jCIM+4gdCjH9zV/tpaCv16zLlZ8cbg0bEmRDum3yGmn9xpnLi2ZMam88IHahdmacQ0ECAVxvZhzdrLpCGPhYIU2VhtJHWypGJBWBYwcLot4vFS13F6DyHnhO8JeHqjA9JfBFsGEtb0Jz+ONN9k/gcX+zg5hEbHogDzWLGmFJNTWOVZYfZ/4ftEbjaJNsOWqQvEyT6ktyOoJ/NxaIfFrp7AVEAXHBMFCCeDQw6DJR9och/y9jqtpTqEQIevm9a4EmL7QKAAuzL1msZjBlg72Eho3GZW4fqLg7MeQhDB+GErfRl4WxCTkR63Xg7jpuXWNj2LwqCpOESv/CgSz0y5eRM1Ir+BXPBeyoGEsAzPyhslaqZCqJyab9seKe+9MD88C1jed8lOFHLlHQppFRBbQk8D33boWvWRApSRr/EOBx9J9OgdVkW2eVGW+M4f4C+TcvxptYJl4pGE/mFnWMkFeYZuIMxI
 E25FGLWk
 Jq23oY6qbxoS/yXgKSmxPjqhZNStPJG18GZv4+fxSeVeYu3Vf5CsMYvnJUdOv29tec7qngVKUozAKUJggoOxFVTCsCiXDW/jzk4y7F8USYkCM5nbHGLNM3Y/Pl1rmZS0CyA+m7yq9NQMUVfjZJBREZVHZnHRpi6KnMtYUS69DnPk/9/LdTaU1p796wIWGpoKS4xrBFpaN6G3rzOmZ/ISrWjMCGP1oDzlrJt3XhME1+45sQUwxihrULwFuCPDqtS3lg0G1wVFTWcNI5n8kGtV8E6hpODVmTniVSkeWFgju9eeqyfzY6hC6h/r65Rra8Joa/H55kgMN+5/7m60tElwPA1/2bfQPZ/whA249WP5giQFbDH3ytGcRNHL5GDmMNFLkprgzZCPvocKs97FMLyH1HqNiP7a9bTSstQZfeLQ6Q6Nn2Q2OBVA0hM/5p4sxXiWLdBQkzw2aiOoWCcdDdAILSzQ2aTjVLciY5QBZZlPbNjLAX6HZBcXiOjNCyJq0wYIIm59s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

wait_for_scan() gives every case the same three seconds, whatever the huge
page costs to build.  collapse_full() asks for four of them: 8M at a 2M
PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.

Three seconds is thin at that size rather than generous.  Across 80 runs of
collapse_full() on arm64 with 64K pages the wait was half a second in 73 of
them, with a tail to two seconds.  The case has also timed out in a full
matrix run, reporting a failure for a collapse that was still going.

Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
PMD is unchanged.  A 512M PMD gets 19 seconds.

arm64/64K: khugepaged all:anon 21 pass/1 fail -> 22 pass/0 fail.  x86-64 is
unchanged.

Assisted-by: Claude-Code:claude-opus-5
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index dd924edd8557..c499804a0ec4 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -561,8 +561,10 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
 	unsigned long hpage_size = page_size << collap_order;
+	/* Three seconds as a floor, plus a second per 128M to collapse */
+	const unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
+	int timeout = 6 + 2 * (bytes / (128UL << 20));
 	int full_scans;
-	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
 	if (!ops->check_huge(p, len, 0, hpage_size))
-- 
2.54.0


