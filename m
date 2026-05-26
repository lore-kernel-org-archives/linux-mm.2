Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB26CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B5F6B00C0; Tue, 26 May 2026 09:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5A26B00C5; Tue, 26 May 2026 09:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA3B6B00C8; Tue, 26 May 2026 09:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 847236B00C0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4761C1A03C8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:31 +0000 (UTC)
X-FDA: 84809592462.25.4CEA63F
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf11.hostedemail.com (Postfix) with ESMTP id 60B7640014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="0 Ff9KK5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="tq/IS1vr";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2ZWqfxA3Xfz/rbOUTC3r3TWiQNsEFUYd9kcAPigHDw=;
	b=73LSKO8VO96uODs4c3i1dpzI9WQt5HCiUDD1F0REDFxdmg3eaGeimExDkcoTdKT4TdK+wt
	cxpwQOgmb3unfLO0g270W0vIxtZBcDZZ7nurmNL2fyixJ0FTqz0zDWD8mIRcoXhkKoHaKq
	UEU5Kkrlsg+ubOe5xSaa6h0KvMIdUsM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="0 Ff9KK5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="tq/IS1vr";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800729; a=rsa-sha256;
	cv=none;
	b=CrceBB1FSMAn9ghdgouC5TJDa0MQyxvB+bYUb+bJNVKhCPQ8FS3Mx6uAXf1R3q79k3IME3
	bG484lTL66v+OkVLZmEAvHRV1mX+q72+HH1c/UIzuGmckkMgqwztaS5j6AyqJB7S3459cn
	wAJlFkMWWABuUuPZrJFsoPiXwMiyVKc=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 2F3B21D00136;
	Tue, 26 May 2026 09:05:28 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 26 May 2026 09:05:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800728; x=
	1779887128; bh=d2ZWqfxA3Xfz/rbOUTC3r3TWiQNsEFUYd9kcAPigHDw=; b=0
	Ff9KK5jJKOUb5d5liGmK5GatF06r44Cqioot76R60wyzD6cRAD9/2HeBNut4ujaS
	W2GEl7DHhCjn8SBl/Dn6IbsDf4fSsHiupW3zsAt5y9KaIeeHUnfOqmmLs0dzHQb8
	yL9NJAglP41B0KecJ+SN+MfhSvYG4i9QPP3veMLaNRJfz37Sh+iS8tKHxlIPt/hL
	A+cyp3Kk1xHYrHaRf2aXafzfSUwaXt8hRTLnPcg7WbTUgF2duU5kcAv1cLaj/9eV
	CjFtsjAN7yiEmkjsXhREstaGOz0oslu8fN7kdgdBdH476fKfBBPzOJlonrF4pXtc
	JXN+Tlf+125HctylqWzKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800728; x=1779887128; bh=d
	2ZWqfxA3Xfz/rbOUTC3r3TWiQNsEFUYd9kcAPigHDw=; b=tq/IS1vr8K9Xqtgj6
	hGGWy8M5burQAAJFH0YCT/nT8ovMNG44HRzh7iF94TumMePIZjhnQ9atwHGP95+9
	nqghS1a/qL1/ZjK3nYEkBHTjgoiTbvZIZso0UG6072OAlxVDRruJju1BcoG8YpyZ
	dB4UBVsdSDUTXxvWYSMCooVaa7PZNa7N/BJ0Rs4NecmDKCGkyVOeaBvZtEFWVk1Q
	zmCdFDFh80V9ORlxHE9nXmEvposv+o2wjQ47XNKuGb0zhKToto8OgiF2ztuI+gJx
	kq34Bb2JpQ3H/T06Lm3G4uXduOFgb7/ocjDXERCSVuM0d6VPGGezmHEFf6nphESi
	RGPEw==
X-ME-Sender: <xms:l5oVapEQREyqAyXgzoj3JyV5dF2GevI2K5JILv8N-4gc2CsvJq1pQw>
    <xme:l5oVagDv5TZKe5_ReejPF2kKd3CE_TkVhpvPFhIhldDhk5TPRsTUdGQoD6pICqGt4
    wXiJ7yf-0m0fb2Q5ow3BtxD_cmhFSQuOJZHX7fxMpTeF0X_oCI8yyM>
X-ME-Received: <xmr:l5oVaulzn0VZWjMJbqWO8LAHaWnW7N0hrBVADFWDiOFhSqJRNbyptKvI5DLUjA>
X-ME-Proxy-Cause: dmFkZTGorQpjKAi1i8ZG7iYIJOmPXyYX16Wn66HfpfZJJwBiL8IODTEb3YekzvnSBlbsM/
    X6SQ7ppixGZbLDOnnWP3soza/h36vxVDnsrC4ARxk4Fv4Yxwdlz6XfYgV6aVIhmCAkL7S2
    rg8LxWrTzJxnWF5mIcscGivOVXfPKYpE0f6/jiO1NUStm2Yrejvp+NeLpIjMig9ai5xjSZ
    OfcKIZ2RBZ3qxjzIlRdeUOJIM3gZ80hy7RrJ61riH0RZeVqDEJKO9QmnDrbe2YL9kG6jXf
    jJ57EekWZW19wOy8aabwVWOCaUr0TBZVdRGF4CNgIjxmzTTbsnitPoPbwOXnU30/TzlgQz
    7FtKYR4dZi54wHrYQVhUER00pFq5LStKwSFXwPOG3Vf4ECuBo0m+ZCs6GaATfLv3YR0/oD
    R/sn8lj3ySJEA70rOZ/5ulxtvgnYy6+kbWK2YY//GIXDgADn4aMyrp88Y8k+uMKX0saJGq
    qt3NscLpQPqSHFguy4RerDH2D82jpyQb6UPZ8hb6IW+AmShC0tv1FRp0N1uBKIYOn1nuCV
    s/Yekbapt/tmMvawu6RTGFOLqbNk2Q/wwDfdoXQaxq+L4uhAvleHvWgGWyEoMxhGto9LOt
    oqn1gmDacXcYL+l5QGABeMXIy2A5N/lw6eH5WqqBzP5ZbOBIU61XrbkURIUQ
X-ME-Proxy: <xmx:l5oVau6lQilRttxZLL3uPbR3nLw57vq_HW7684_SfTJiErlDA5RR2Q>
    <xmx:l5oValvXSNLcUdpaUel8hQtUQxL-wNBBiyW9N5f338N-fa1aIUd2xg>
    <xmx:l5oVauXyRY2JceNxqFJ-Lezmgdp3BUB0tvC1RImipaPZxMZ_fBi6Cw>
    <xmx:l5oVamEw9tYFanWfa7Ydl0EulvM7hoEpA7IQuQ480dBJBlBYznfFwg>
    <xmx:mJoVaptHxgo0EELYExcTw1ohvypCC79cMadcpJiGv83nk-jqMvlhgVhu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:27 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Date: Tue, 26 May 2026 14:04:52 +0100
Message-ID: <20260526130509.2748441-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60B7640014
X-Stat-Signature: nhso7wo8sy9yaquee154ez4frsocmcyp
X-HE-Tag: 1779800729-182319
X-HE-Meta: U2FsdGVkX1/+jKmBYgtS62P7xrVekFy+4IlrJzfeQ++/6C86Fai76jSkFNbuhGfL0MyEnVqE+zhiBvxAmKBmvcjuSLvfZhoj/YGSegZ9xkUKezBefKcZI9Ts4vu8k+/fMX9WuW4Acyeg1u2CKDi1P9EHF7ji20rONlEAPcMuomufPMLVuQ2rpM/504lKGZxj7Zgw+mDb9fH2HpVOkBBL56vAL+gIMy3lVXofH016dG4MZIuaU42ow02GnMsPKF3HMwSzZ7lHaFmoRsO5sOby15e5i7QW7swqZpbrR5PUQFSJODJKGPSIcsLl/vzUpxm6FFeCLFzGhOvoEd2/Rss/kD3Hstig0NqMOs/lIr/XsJ7Bb68SjA6A/yW+XcKoRlzYbhm8eo15McW8jF/Xmq03kmfBzLRSADINjYvkePmaGv0Ib89+LrQYT4omnl8eQ2SUUS4w6Cj7BIt+ICIEqSpiVccd7q7joAnjmB3gt48MljlOH93fIaF1XGAA129mUHVv+pnhTym2cubTcyY1J54sqROxj1QyAmpgXMbHSrla5GexiUAkZmCYstpUO0lTuDrsvDsGo6oBu5TonrUy3SiEqn0aytJLggoZJOfzZNx+8KZ/FWwRIQ4RjCmabo+uQGlEoUjIn5pPDLbj9emnJNLJSiftV03X/kwp2NUW0Cfy+Gj76D1o2vQASP3IeefzBqC1AqfYiN5pV6gE1qnT0Ra5kYFfxamHvDZgidrIeyWR3D5mRPAzIUhyxYh5CjmJnCY4ggTvecV6R25oe/d+IaeriadHvBYOBf5PXyEf+d29UYU5uonGkf2Yxp1LZXjSpKLLMYx4MFcCg0qkVxmlnEnPXVA8MZ9KB3e2sGFk+McYXyDY2Bx3z0Zk5D5HoqPpnIqXVZCqX7blOtkoXGCOXyuPMJ9JfMq2rlFNLetG2mVV6V1fGElRiVrFHGtr3VAaaWOXD74zFPtxTEx92pdXqE2
 MPJbbKn0
 Tx0CdYZMBdFsdPzN3SBNGRGq6UKNAjdrSHTWatXZg1AomgA97AeVspEN6RWc0Ku2fvD4BXXEqbnHyVO/oGXzTH5eAPm9rj8vhSajUvgaDBrqjZ27TEx3QHJL6DB8FX+RaVMaHML7dUuhbIyNMr3o09AGLSn1VBXyG4clZshBklBL4NOfm2vxLPZoViqLM2Wbyo2TnN/NJfUTDz29zo+GMNx5Hh9djzXGpjRboNN+ZBsct6rlpDkl3OxMv+sxRPKFERxPN6cLNCmDL1Rx2Igm85CXZ0XdWda2oCZvDGBDtgGQHoZD7FJoz/of4Vryls3UeoXMgQPnw4uAM/SHAU2cvCSKYOqtw5ViN6KqG5HQplX+e79Ya0QaTBvGwC8x9N82uTUdvB7oKy5gwbJUde+MUKp7705VtUu0E41KXwgHL6G8Vi+5jfFP6NbtSqsOsQH8LQ2Dm/8QMXvcs+JijAUTeBkMMhenPEjmwY7Je3p2hlR5vX1RYSrHicAhCQ0JK6mhV3O7CvK+k1XeWpOueh/G+OsI/oUlXIp+b1mw1YPPYKRZEfS+viPlkTRi5qHzqseCYH1+FZr61EFRVan2GAmSSMqYey4YYm4Xn2sGcV2htAIzyuAZfpnRl6XeiH1zbSkZ301zw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

vma_flags_t is one unsigned long on 32-bit -- NUM_VMA_FLAG_BITS ==
BITS_PER_LONG by design, so VM_xxx-declared bits sit in the first
word and hit the single-long fast path. But the bit enum declares
some bits unconditionally above BITS_PER_LONG (VMA_UFFD_MINOR_BIT
== 41 today, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
actually carries the bit).

Passing such a bit to mk_vma_flags() goes through __set_bit(41,
&one_long) and writes one word past the end. The compiler folds
the OOB store with wraparound (1UL << (41 % 32) == bit 9) into
the first word. Bit 9 is already in __VMA_UFFD_FLAGS so the mask
happens to come out right today, but any high-numbered bit whose
mod-BITS_PER_LONG position is otherwise unused would silently OR
an extra bit into the mask.

Add VMA_NO_BIT and have DECLARE_VMA_BIT() resolve any bitnum out
of range to it. vma_flags_set_flag() drops negative bit values.
The ternary collapses at compile time, the runtime check folds
away when the bit is in range, and the common path is unchanged.

Bits declared in the enum are now safe to pass to mk_vma_flags()
regardless of arch.

Fixes: 9ea35a25d51b ("mm: introduce VMA flags bitmap type")
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mm.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0f2612a70fb1..71b11945e4fc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -286,8 +286,17 @@ extern unsigned int kobjsize(const void *objp);
  */
 typedef int __bitwise vma_flag_t;
 
-#define DECLARE_VMA_BIT(name, bitnum) \
-	VMA_ ## name ## _BIT = ((__force vma_flag_t)bitnum)
+/*
+ * VMA_NO_BIT means "no bit"; mk_vma_flags() skips it. DECLARE_VMA_BIT()
+ * below uses it for any bit number that doesn't fit in the bitmap, so
+ * callers don't need to track which bits are valid on the current build.
+ */
+#define VMA_NO_BIT	((__force vma_flag_t)-1)
+
+#define DECLARE_VMA_BIT(name, bitnum)					\
+	VMA_ ## name ## _BIT = (((bitnum) < NUM_VMA_FLAG_BITS) ?	\
+				((__force vma_flag_t)(bitnum)) :	\
+				VMA_NO_BIT)
 #define DECLARE_VMA_BIT_ALIAS(name, aliased) \
 	VMA_ ## name ## _BIT = (VMA_ ## aliased ## _BIT)
 enum {
@@ -1081,6 +1090,8 @@ static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
+	if ((__force int)bit < 0)
+		return;
 	__set_bit((__force int)bit, bitmap);
 }
 
-- 
2.54.0


