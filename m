Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FC8606A336
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=jOWsaRw/
Received: by kanga.kvack.org (Postfix)
	id 9EE336B00EF; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F2E6B05B0; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3D06B05B2; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634DB6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4F82140408
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:10 +0000 (UTC)
X-FDA: 85434304620.29.D8C1104
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf08.hostedemail.com (Postfix) with ESMTP id 28C8D160003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b="jOWsaRw/";
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf08.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674828;
	b=wFJ4tbi6RoqHb3S+fi4mmQgZA4Nb1gFiisMFsDvb0C9hokBOkQCLvz5avLO9gXhPrnqt8R
	Eej2N1/oJ3prbH4nAyn5LDuLExueeu33siVpF3YtX8JXFxiEswMj8T9O3st338lbEzMmNS
	KKUhdjqsHVVhf3EaIAsHj0NtQVb7n28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XRgYV+Ks94EfuBXAohtceBa45x+x3HR336pqrCVLcA0=;
	b=LmJJMnfEbcmretMxY/CPuoGamhwLG/Qr10ZfJIneoQrv98ChYZdtq72UQ6x+PlCjNmF1kl
	eyzLUNImdsMKkbp3L+gb91WqwDKCvUtxiQihTwY7tBxsMFlz+fz/P6lMXKWLqyUZQehA7a
	ZDZxy08GfEbzhhscC/FSIeiEzMr9Ips=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b="jOWsaRw/";
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf08.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRg5P5TFgz8Xrrf;
	Sun, 15 Nov 2026 00:47:05 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674825;
	bh=gydiiSAYZ04Px2gvqNM114JBE2j0C3oik9IAucsOCfc=;
	h=Date:From:To:Cc:Subject;
	b=jOWsaRw/iXRCCp7hoEAuBB6fxkc+WS+s3FVqyRylTo3uFSoJMivmogwPUQF9ar8s9
	 WzxNdSwg+w+Aqcr10L8E09zqHLqzH+kvNGBMJUJDkYKya4b3fI7ev91URvq1tB9HI1
	 e6GcyIOvCMQ9a8STZi5K9DqMXOWQbPk2C2FZ93gqzbj49Ln//t7bf9WCpVgac6I/F6
	 eCiTsqHKztuFPD4pCwmWikuoY52ZyV0KC/tJAbzI+OPwZGfN/OaBISPDDQd11ajqMq
	 FXCWCBRFiQJpQekSLTupAd2Znl2IiZUEYuH03U+avxotces8jh1EHxDvZW/zLBOG4f
	 MI+hD2sNL4+bQ==
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6AEGkuKx094406;
	Sun, 15 Nov 2026 00:46:56 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:47:00 +0800 (CST)
X-Zmail-TransId: 2afc6af890848a8-30878
X-Mailer: Zmail v1.0
Message-ID: <20261115004700194_SpQtdnE3JL6bzx51l-a5@zte.com.cn>
Date: Sun, 15 Nov 2026 00:47:00 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <liam@infradead.org>, <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <vbabka@kernel.org>, <jannh@google.com>,
        <pfalcato@suse.de>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9tcmVtYXA6IGVuZm9yY2UgdGhlIGRyaXZlcidzIHBhZ2Ugc2l6ZSBvbiByZXNpemUgYW5kIG1vdmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6AEGkuKx094406
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sun, 15 Nov 2026 00:47:05 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF89089.001/4jRg5P5TFgz8Xrrf
X-Rspamd-Queue-Id: 28C8D160003
X-Rspamd-Server: rspam12
X-Stat-Signature: qe1othczxzmq8cnux8hp85qwdzm64rsm
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794674828-701380
X-HE-Meta: U2FsdGVkX1+q2wcX7PP5lV014B2Nu1gfQLDBMI3u4Y37HzAIm0zB+n6RfG4j2wLPAwoLmWthL+WR7/sk5i37UabfuKCSLcIZ2z9TI1GLKM2I3joATD++w0zzuAs5U5wsfsULgPdr143lAjt18fgepESyOVw6WGNkDG1NYeF1LDHPRU+K27oXzyGtEIeZApsFX0P7yX+RidduoQ9a1FAqGX9buNAwa4wCq6VJsbFnGGXYM9MeRDAN6fGnJeiPAvpIfVhqqvUvPq3d6fxIJ/EUl8rDWnWC5EwrZmcP6jmGULMUbL4FSbnt/8rpvhbujXchvlS/fC9icBLrANgSv+IPMlJgSkqXdP8vmWh2bF7vA9UiKlPAeyCr0ZVns0rNjQZOIH8e5fKj4D6MnW/3H3uklsAlhZ4vAWPxZJz5SXKIz6vx0zRxKTOQ15DeGKbudTjR+LnHrkibUd8imto9LVE9DMs6t8ghmAW/6pPc4lAcn4tHfT0joQ44kkcxtYaOS3Q1AfSFCpB9kJMk5wUxSTVjbMz47N4qvBuzJXy1ajXTWOIJcZPvGhU8P/flpSR0enJg00uTzDaCy7YKWEX6VFUZigOXci2BrZpS9h+mD1/PV0HtP6tH3ZGP3ANPSPtuuUZHKd822UGxGTmVlgnnUMMkmPKqmym2s/8LJbc0rqDL7303EqsC5p3MuisgUIYgGQmGbZdu2oW2GCubZMabZ7cAflA4YzOEEDbHBP9MYfmDmWK9pts/h7Nk9hK/LHLdOwYxCBWnCc6lJNbS06X5YtO76XeBO59igwSkeHHrpi4GT7abm7Qn98ET1OXf+567HCxlee93eN9wTwaCEulJD6tmX2rwEWlM6S4deh6ldN6HC3nRjD41UNw5ZVG/Slp6yzn7mkX0aULcOMnsvONaY9L5NJURjdA5WOVlSBBEGLLzgEkqz8+0AN3M4SOy5gTZmWPwThZsq7yxpYG1eBuWt9J
 bNZWxTI6
 M2FKAX/IDgZRootqjyg9gh748+7YZZe3PR+KmjYh9/pQ9WaGIp8WsRnuGBqttz1tuvxy8q4PfT8NHzjBeuUo0puhxqzTrRlkJAD0ljLvuaruxGYGpPtq/8uJr0ADZAJUw4unQizArgP+Ps5IevdRiSLmoMBQIIxnsTLbF22fJ4aC8XPAUo48HloiLSWKqEowefcyq0B+cw5TFRtg4EuvG4pstyIH7gr5bZyRPGNhA21ba1q//dXJ2JZ7AyliK0J5bGYhTQWWS9Ar9x5+4fLNqCYOfFotz5+5vt1VPfERvKBeg/1X5DUKHIQLiOPt3SKtHoHElZjKLt7VYbmTrbR7Lb5e3RfWQT+6pHVNFxjeLEy/7P4Ps50M3AW+/nAQVDMl1GhpBJi1/inRYxBlKrFnSZ5qqGmGNRHGxuzEJYuCy6UVsIMDbqcYbtImZAkd/UZ1MmbxJ4QPLPWRfxfUkJnY8smu7xKyx+FMX850y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/mremap: enforce the driver's page size on resize and move

device-dax exposes its mapping granularity through vm_ops->pagesize()
and requires both VMA boundaries to be aligned to it. mremap() checks
may_split() when moving a subrange, but does not validate the new end of
an in-place expansion or both boundaries of the destination VMA.

An unaligned expansion or move can therefore succeed and leave a VMA
that device-dax rejects at fault time with SIGBUS. Check the final
new_addr and new_len before moving, and check vm_end + delta before
expanding in place.

Checking the actual boundaries preserves an expansion starting inside a
VMA when its resulting end remains aligned. The move check also covers
equal-length MREMAP_FIXED moves. Existing PAGE_SIZE mappings pass both
checks, and the existing hugetlb restrictions remain in effect.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/mremap.o with W=1 on x86_64. Earlier QEMU testing used
a synthetic VMA with 2 MiB pagesize and may_split callbacks to compare
unaligned moves/expansions and valid aligned/interior expansions.
No device-dax hardware was used. The synthetic tests do not establish
a real device-dax workload report. No stable tag is included until the
historical introduction and applicable backport baseline are established.


 mm/mremap.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index fff0465f5e061ff44ae4fd42bc037ce178517bda..8a0a406bd78d41df96f7ef41aeb6eae36c77c1a6 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1406,6 +1406,17 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 	unsigned long hiwater_vm;
 	int err;
 
+	/*
+	 * A driver can impose a page size larger than PAGE_SIZE through
+	 * vm_ops->pagesize(); device-dax exposes dev_dax->align this way and
+	 * rejects any VMA whose start or end is not a multiple of it.  The
+	 * destination VMA spans [new_addr, new_addr + new_len), so do not
+	 * create it with a boundary the driver would reject.
+	 */
+	if ((vrm->new_addr | vrm->new_len) &
+	    (vma_kernel_pagesize(vrm->vma) - 1))
+		return -EINVAL;
+
 	err = prep_move_vma(vrm);
 	if (err)
 		return err;
@@ -1577,6 +1588,16 @@ static bool vrm_can_expand_in_place(struct vma_remap_struct *vrm)
 	if (!vma_expandable(vrm->vma, vrm->delta))
 		return false;
 
+	/*
+	 * Growing in place only moves the end of the VMA.  A driver page
+	 * size larger than PAGE_SIZE requires the new end to stay aligned;
+	 * otherwise let the caller try a move, where move_vma() validates
+	 * the destination instead.
+	 */
+	if ((vrm->vma->vm_end + vrm->delta) &
+	    (vma_kernel_pagesize(vrm->vma) - 1))
+		return false;
+
 	return true;
 }
 

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

