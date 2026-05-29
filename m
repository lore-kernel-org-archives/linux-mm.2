Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8E2CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019616B00C8; Fri, 29 May 2026 13:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33126B00CD; Fri, 29 May 2026 13:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48FD6B00CE; Fri, 29 May 2026 13:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2A2D6B00C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64388C01C7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:17 +0000 (UTC)
X-FDA: 84821130954.20.85B625F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70F0516000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTtJGEh7;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbbpli+hXkiBIhpDsuI5TYzprk7eDfizGvmgjVMK96o=;
	b=SfeUz8naqZMU4Rc4f85QnKs+gaku0UjWMF7meTyOcCb3haoSKkf91OjxGgAEWpzDGyPfWA
	7Efv4WwvhhYEZQ0QcCntL9eYIvrhu4DeyQQRdohpvgfT5Op0y3Y/wjrB44TbesgLrGJ5pB
	9sOGtfDtOKQreBF29falMXlA7XyxdMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075455; a=rsa-sha256;
	cv=none;
	b=Lu4oceRKYt6VYPxttZoPzuUCSQO51qkyGtoqCP14S9YQqU67ep8kv6b+Axhex3OsjzL+dE
	paLbFwVt2aHcd/qZYih9EoyTkS3wsjugd6QOlRzGEVeLXE1LjXFCW/dqNr64OuYqfdBclE
	8uMSZVrWLGBjPpXR7IIz8SYCaOVRnqs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTtJGEh7;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04F53605DB;
	Fri, 29 May 2026 17:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308971F00899;
	Fri, 29 May 2026 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075454;
	bh=fbbpli+hXkiBIhpDsuI5TYzprk7eDfizGvmgjVMK96o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTtJGEh7Mm/KsO0ad+cS2miLHGEUbr39u5u2xM9Y2h6nuK4ndN/FjmfSHlvrQqKqy
	 DYekQYcuQZpKYD9Ml3nEoHVWaVJxiCL3/7FC2HsSvdCL0+h5jKZs3U4VixQUlD0xC+
	 Nn8UIwuIFl2ymSweMZP8GYYRuS2/K4OchuOOIlUxY58xBxjlZbc88XLYpQBvRxX6ni
	 bv5ZEb0lsX7Dv8yfnRxp2PdKyLROn5vzsCTTU0oVnrlzg/jQroWFamkOu7gRq8GV+c
	 c9PsRwf4abnjdO0fmtbKBelE6GrrKZf7u4Yodc+682Zyca5zJ/aX9K0rYDDBg8zRgJ
	 2nlzus/Po9QSg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 83AC1F4006E;
	Fri, 29 May 2026 13:24:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 13:24:13 -0400
X-ME-Sender: <xms:vcsZaqgNi-dPsjvESoXOibqniTCH1aaiII-D7KGP0oxGGd6HDGu7WQ>
    <xme:vcsZai93UM9cV5OQKIy0I7pi3TZqp9NDqwiUmMRsDEHXHHaJmZ9w3DJPzJhIsIrup
    vqMpxg98bgDWhNOra06n-5512Amd_91yn1XBBhHGH-zNpcpdH9YY5A>
X-ME-Received: <xmr:vcsZapQCUUf-dC0JuicBhoUlEeTMsSZQuIXx1p-yf6xdyVBGm5eLnGy4RiG4-Q>
X-ME-Proxy-Cause: dmFkZTEZfpMr5/eRRE28w8SXJrP2dhbWJDto6huRdd/cnfVbAAhK4j6L5mXvQtvbZW1Tgn
    qdHjS1xVDGkdt7hr1SYRochmR7yuP2KsuqbhH6HkebbwRdIZkVYqIRv2TfGI9SaQtUiic8
    G8SBlRV6/L2Xtb05bm6QmOQTKoj3b/RGprk0F6woL4YfqntUvh+0D5sL6ruauatQhdAfx4
    sxg873kOfAaKAVmot+PkxhAMe2YWyy/aSlFAam2C/bHdTY9DLsPBVhceLLRJtCvIR2Q+zM
    kaoJA5O2aRPotfcyz8zPVtzBiOjMLe5Pw3NzV/bo4OKaUt+lobJ5eojHQXZMuqCslD6ADP
    cnvxXMLJ+GGO+YsdKG/VtAzip3oPKBED00TGmZboavLxb51m+v659bwaubg2JY1xQjHuTg
    UmCM8Q2oSZdxrvMk3bWtd5KMX1M2Pd6UArm6jSDfw81nsFHKAMQ4fbbfRC+vk9N/Vgfi7V
    oqaul2hByG2eXK5j2n6x3xF395psx+G0RTb5h9LdHo131yNJ4WEPG72PtkjD4woebIeM/+
    o5O0e2DGUKzrXWs7x4haLKZGLWCkhawOH+sDfIB69Q8admleEF9xdNHiVEu2gjwY2cS4MD
    0S3PRQnsWFPiUiwqDqufDTz1neUdguM5GjjW9YxmtF3DDBpmERQbvTJuH76A
X-ME-Proxy: <xmx:vcsZaptuIvMWKVIoDfSSxAt5uSo66EGK16NJygpha6IAG0F3Yet0CQ>
    <xmx:vcsZaj6s24cmbOwqFZUU1reTXtOLJe0YCCi0MiJJrj1ybaEbrm2_6w>
    <xmx:vcsZaoJCJucrLRtgQHE8U_Whi1DSZLTKevFkg4XWEjcOnn5s9I0s2A>
    <xmx:vcsZatQRQvFd3-rD4Ak0Pj9NPRui0PDQ4siQ5W1BH_DXH07U4TRxSw>
    <xmx:vcsZarrmZ9lZy446Zyhoy--4ni-DCz-f0txBjarbHVUvrXTETQHXN6tL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:24:11 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 4/6] mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade
Date: Fri, 29 May 2026 18:23:28 +0100
Message-ID: <20260529172331.356655-5-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: rsubrfdjk9odzgpb4a395ruad1qeickx
X-Rspamd-Queue-Id: 70F0516000A
X-Rspam-User: 
X-HE-Tag: 1780075455-767782
X-HE-Meta: U2FsdGVkX18aMbVpzAqqHvU8P/H0LRFVm0VHI0shUd9e/HdyR66TdmZUNqep/NQRsC1Atl6HhSGGAmYzKcF0BulgknmkjWzuPmU6xrl8RuoEzG0oMHWpowPWOiTX8BjKr9EZ11sfI0L7MtxbEXCD16JrHMslknV5yw6jFWx0ZTVkOx9nUNdpAe+U9tHI95O5ftMQEf7zfy5tLDtuQrEO9os5Ggd87OavZX7AbvdxWZDcHVULED+xJkdkOqB1iCb71tfCOOJpDUczvW8Mjwd0SluAae1lz9voe6ecok8O90oZm7JNj6Cga7ICqW42VJwQ3NGOMnYlbYEOyF+N43RedmFGwriD195vJdfGS5DUBcWP2q5E474kYqevxt7+7f/4m9lofMzuFnOkKQYwgNgGbwjW5IUQ4VTGXTIXCx7vDTDKCMr4AmMsCinZN2qi8zInG//gWHdKI69q5hg6aFzOCKdLW7xVR5q20xaJ4tuRd9tu8C43rAvpIiHyU2hAA9icohHvFoMcZ889ayhgkmqyGFI9M0fK6NRXNRNn21u0X6xUgygL6hFxS2nPXHmB6hQBCWChAm4zpBmRI6l+q1PyTUKSei4ZzEv5a6cUeBkumDznvF4Lnhe3Rhcn6mw5NfPOOIFrm/+W5CgHj2XhH0Ovq7YRJ5sIxYI0rjCyknt0W5dQOThv7kl6gw6P0MwP7zwbjklABtrUc26vP4vLy2yvF50EjevUGksXiKX7vy3YZwW5CRhR8Nzs4BDqz5547A7xCzfHjBZ0uUgYQPyNaz13q+4ndc6ATMmVxnrHrC80i0CS5sB5CRC9KQLtsPUUg7LqWg0oUU37q6YPnGL//Ue6S2tfScc+CIVuo42vcZap4Xi9SKACgPk5fZx3qd6h5PzD49CbuZnCnszlXXqVPEB+Mr3Jr1OxfumSU/tkolcCMGyOq71UxgcL3xSeyL5fnIQ6sxcHVAjmEBO0Q196xXp
 4TqRatqF
 LrJhj6z1xEmmdOEqw/jUt/F69MTuLPMzkIS0KuuA+3j87r6CI7UDdGr69gXouuZAx+Crtk1e1Jk/OBiJPrptF3D5SjYdQku+UCL5G1XCZTIx0UyFarUP8vQQo9xbTlh835bdErCdOImZMeKEb5oWXChjSIHt8HwMuJ9T+uvQSNaQ18W1yPySd3LeX+pVmVeSbEcY9nWsgEAbYPk6H8GX/fZ2hrYxZ7edBszPCrMLbNcOtcVpWgMwx8k+j8Jjvm483Nb62N3VJiMj3kzZRchZ2bPa4ZP3N3rrHOiDBz7ClflJXB/h0OrfGHXICi0C8Tpm+4WP3yrFtygjx3KnRU/KeIJ41Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

change_non_present_huge_pmd() rewrites a writable device-private PMD
swap entry into a readable one without carrying pmd_swp_uffd_wp()
across. The PTE-level change_softleaf_pte() does this correctly;
mirror that here, matching what copy_huge_pmd() does for the fork
path. Without the carry, a plain mprotect() over a UFFD_WP-marked
device-private THP strips the bit and the trap is bypassed on
swap-in.

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 42b86e8ab7c0..b7c895b1d366 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2663,6 +2663,8 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpmd = swp_entry_to_pmd(entry);
+		if (pmd_swp_uffd_wp(*pmd))
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
 	} else {
 		newpmd = *pmd;
 	}
-- 
2.54.0


