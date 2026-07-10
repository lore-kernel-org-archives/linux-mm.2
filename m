Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C17A2C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98146B0088; Fri, 10 Jul 2026 01:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B223C6B008A; Fri, 10 Jul 2026 01:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB346B008C; Fri, 10 Jul 2026 01:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74DD66B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:47:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8AFAC1E23
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:47:11 +0000 (UTC)
X-FDA: 84971783862.06.A060121
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B27340003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:47:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RKJz9Axb;
	spf=pass (imf11.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783662430;
	b=zPXYqTAYu7IzBlv6ZaTz60CP0l8uDB3w2ssTS7DTOgbgiCPVDbOkhz79k0q2BhzjAriblj
	F4RSIVzES2SwsmirSca46OUwyFqZHPLl+INRmTWy+X4nxlQIHA49cd8brARhIJioWpsC+j
	m7RGHl5kj3Qt4wS9jzUN7EV0cK81Wu0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RKJz9Axb;
	spf=pass (imf11.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783662430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tdRhJB/OghWJG/3wbKJ2IGD+9QSPJ/wrl2a3I1KSz+c=;
	b=bg+Xouqu0LX4g0YVnj3QfaFN2UW9cjTGSsiEteUhrDLFq2M9RAVJlF3THEcmIgmPfRU84X
	bNRCafUCiJnxqYO4ntE7bIFudJMj3kI/tgcXr8Ywicn+gaG/qoTG5Rys77zXJMRbl+09z4
	NTu/4iQQOcSXS/CqEdPfuTZgSr37iEM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c7c61b5292so8651355ad.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 22:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783662429; x=1784267229; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tdRhJB/OghWJG/3wbKJ2IGD+9QSPJ/wrl2a3I1KSz+c=;
        b=RKJz9AxbyDUMC/cLmKJurYyqvasSv4oTIJbNLFshXuA2YIcSWZr915Gx1Wmw3S8GLx
         3BidaxEDfKzHlOGkbMrN2VmohEQs1dJp5IsTOXQPvkZ5xj8C8EkDXYJjZyk5JyzyOSsP
         By+FUCaLknM43crtaJDYAoc287Y+ZBm2flg2iWMckZAlgD7Ggf6KJ1zeawrSxTHaQ2xg
         m43KjoUjwLghdzPtr8njJqMU0Ab+HFeti6UE6PUmL6P549JmqDzTS1rvpfNMUwGSpmSl
         t+vwnX/6kXvVCVq1TtKbxHE1ZMEcdpn5y1/8DXcAzptTEqXciL4Yp1E4bPg8BYUyUFvl
         oTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783662429; x=1784267229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tdRhJB/OghWJG/3wbKJ2IGD+9QSPJ/wrl2a3I1KSz+c=;
        b=hCaWK3EyAZd1K7fKLnIsFt6SW3Je1HU7u+nqHOYPeh+1zNS7vL09wYn3NPmULbEL/2
         FFFJ1CyVVzR9Dkp81I3/nyS51Z7JFEyglrc6Rjx1jigYYRzsuszcEDAAu1wp8j+vlclx
         B+7joPMTe13k6pB99Eg8WKJKZJaWFkxkewkcCthk3B4zDiATJK6rCuqWMxG0M7b941YZ
         XCfZ2w64Sr7ecXOf0bzKi/6/JXi/mmDi7qTa8nsd3PbWPFDjkKC3fglva5WFGVwffr6w
         fLFcdbR1zCDDAzK7Da8Pm8PLasWvIcF8OPVMx9jdO3AykVzoJPiztyush8p1gdlvuqoD
         Y0fg==
X-Forwarded-Encrypted: i=1; AHgh+RqcCVCg2/eRcgYTHWGYXFp0R1JXzdZsFEbe7TuHdj8rDuc9OvXlgFa3KEx/vvdms5BIwVQA2I9ccA==@kvack.org
X-Gm-Message-State: AOJu0Yx85YL4j0bNmYLC9MuiqZNQNQh352Co/dfZm6A01xz7dZK4GGKB
	/JAWfPeoe69diDvynS39vQW1YtwKxHBeJhkx98AsZJSMPunfC0dZXtyb
X-Gm-Gg: AfdE7cnoG3Ue7NFzY6T30JVz15JjGOGb8frOTls9HCh/VBR4U8HsdgAhNciNY8DIROB
	TvuS7W4qi0FcPkPVQvmU/V3k3lPT6dwkB1WXkssp23q89OmKBv6ABQuqsJpMb6RdxMdInEQNOA9
	69oq98nBK8EyQF+Kqz1E7MjGXH8ixkNS/ABEDRw/sYzPwQE/C2OnWh9Hix7v0wAFOu4QEqIvNMJ
	H/cWfr4cmYKxFeKaipEPM2KMSDv9kItn1j70pVwPOM8Q3APAIfmytU5ZVKTVUsWm7J9j/ThmlMz
	b67HGYydv46NtKBy9IgH4wQ3TuWJ5RxAOVy2ErL6E8hhEKFtm4eoBZcD1iT6qyqbWNnroHRV2YX
	Xz7wu1U4r6gIer/5Kt1H19bde1Crp00wTqSzQI+2YOGPhpq19ErJopbJFdoluGe1zlrHUxac3Fl
	8EHsYO4m6lFF8XYbWkgBKhZLqOW7tF3Ktn9pnmWk18kGjwjJqZ/MlOC4ZayOUNZqrn0g9/5fbwq
	xZJLAR6AshLf5roCYQUHXuWeFj5
X-Received: by 2002:a17:902:ce03:b0:2cc:ee78:3236 with SMTP id d9443c01a7336-2ccee7832d2mr100808235ad.33.1783662429102;
        Thu, 09 Jul 2026 22:47:09 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb76asm56102255ad.12.2026.07.09.22.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 22:47:08 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id A435814961CF; Fri, 10 Jul 2026 14:47:06 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v2] mm: nommu: free unused resources when mremap shrinks the vma
Date: Fri, 10 Jul 2026 14:46:48 +0900
Message-ID: <20260710054648.924005-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B27340003
X-Stat-Signature: emwduzjhzwukips8bgtoajsx6p4f7eyo
X-HE-Tag: 1783662430-189353
X-HE-Meta: U2FsdGVkX19yaTSztdaOrTa7xqtGBqo5BQVicsLQfRzC5R6PL/xayOffPGq8sCCPOp1QxTr/Ug035hG3ucKYQY+AdkRsLQvjCMVP4bIS27YuwK/JHknKF0Qxl6Yjj/UYXA3TrpiC2RcN3bWxUIN9KqCmCDbxqx47gaZrachdH2riFFRDeIW6CJ9uz2Xh3bqlvZywaFTN0YIjfyaMAxDhT981VgCRq/ruh8KzBVwhg/XVyqSn9pvQXrnXfZ/J5u8NbyGaRrrQHx+m9FmkI+/VzH74q9GntP+uyJboq43ovXUHncQyWfZd3ZscUBO1lCfwVGsYd/ob8vRDI/l+jnKt6ZHjBIN7MZTCqlQZ+68Y+E3frRbUtiSBiqutWeopR0krkJHEBixHzsdLIWahDxRdBCpXJmiTBdvkauUM3377T64SsbA7i3SbMvqU0IjjwAzd7bhuU5h/stpGDGy0caW7G/E5zC5E44cfMo4VJ+nrmymCwBmxurwn36DMR0DacNTo8VZfUM96FcwWYZJ2BorK1KyHieAAG090njf7meQ9KLaAo2bhzQpu907HkvlZgpvylq6rYyqvFiRIr/u6Ec6UVSEqwBmsZP6PjL7BDG87ZMa+RV1E4DGPxLi8jy6h0I6fxYojt/zV9wxv6AJNe80mF1LBwXR0Un2TRbZm2y5K1xYSDkj4gITYn+fpX1yDIuwdEix97ET61YMAg/PbLH2iM9oaU3Fn/JlKzIR4O4PmKi/jUvgEEiTThznUZbdg6UkCQ14yFc83pD9JKfm1FXNkvX6g4Mu/dKxHxM183gYECGwprD3Ufoxd5y0x8ff62lD6fwMEc+1eg/dp+fOetHnBfA0+FjUX1NdcPT5KjNRNX7FEKbL4O9tFoWjpubnBjdhNbtBgXwt+DcFwtSXU33BjuGT13QE9q4XdU4ZTNUqhyN58MQ4EDsHeomDCLLMzAFOvS0UyWtb05JpJbsh99Fk
 0zyWB6ED
 WVfaKu4/AxXdO02Pvqt2eYEc4iRIC+tT4fQ/CalmUBNHHfEVKy1CSus2vPYcuks5Xvd/QevqUHE0ZkrXtqu19z/pDn6T7HadN+5xx77q1wuxziQstwHdJXrnePoKLQs4d9lXJmf+hR+u++UgbJAbyvygwkh19sN7N9uDikbywUxZ1s1ed3eaXqz5ifQl0NLN798KzGC8o1+mVrByVx0jEz+rlTePe8Rwb8uXfas8JHNQ3uT/h0hr/8tWQWqoNTQWGGtagcCugqHgdUrXNfdeFwHTk6hWVD4ednsX1dIDvqZQ3JUX8g8qQEODnxEhcsTfH3OsFCwv2a/J0QIzjR43l2Ag4VQkeacmoZJHGLcbKchf4+SkNWQ7gjXZr/EFZY7CQmK+t+uIik3mt+6zm5MkYQpH49ohZnT46amcYAmksbhpHj/OJi2ZO2ILdYIw7U+171DLGqTTj9IBNhkI7VocObNUARw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When shrinking a VMA via mremap, the bounds are modified directly:
mm/nommu.c:do_mremap() {
    ...
    vma->vm_end = vma->vm_start + new_len;
    ...
}
This shrink the VMA without updating its bounds in the maple tree.
If the maple tree (mm->mm_mt) still contains the old bounds, a user
process could access the freed portion. The stale maple tree would
incorrectly return the shrunk VMA for an address past its new vm_end.

This commit fixes this issue by calling vmi_shrink_vma() when shrink
happens.  Additionally, if a file-backed map is to be shrunk, it reports
-EINVAL like do_munmap() does.

The issue is reported by Sashiko review, linked below.

Link: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
Link: https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v1 -> v2:
- handle error when vmi_shrink_vma() failed (reported by Sashiko)
- prevents mremap() with being shrunk for file-backed one like munmap()

v1: https://lore.kernel.org/linux-mm/20260710021028.892645-1-thehajime@gmail.com/
---
 mm/nommu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 852ec9bd0505..c8effbffa0f0 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1597,8 +1597,26 @@ static unsigned long do_mremap(unsigned long addr,
 	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
 		return (unsigned long) -ENOMEM;
 
+	/* like do_munmap(), we're allowed to shrink an anonymous VMA but not a file-backed one */
+	if (vma->vm_file)
+		return (unsigned long) -EINVAL;
+
 	/* all checks complete - do it */
-	vma->vm_end = vma->vm_start + new_len;
+	if (new_len < old_len) {
+		/* shrink only happens addr + new_len and old_len are in different pages */
+		VMA_ITERATOR(vmi, current->mm, addr);
+		int ret;
+
+		/* vmi_shrink_vma() needs from/to pointers to be removed,
+		 * (mainly used in munmap) so, specify them.
+		 */
+		ret = vmi_shrink_vma(&vmi, vma, addr + new_len, addr + old_len);
+		if (ret < 0)
+			return (unsigned long) ret;
+	} else {
+		/* when there are no shrink, update vma.  */
+		vma->vm_end = vma->vm_start + new_len;
+	}
 	return vma->vm_start;
 }
 
-- 
2.43.0


