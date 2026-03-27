Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C55810BA455
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9723D6B00A5; Fri, 27 Mar 2026 05:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922AD6B00A6; Fri, 27 Mar 2026 05:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838696B00A7; Fri, 27 Mar 2026 05:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB1D6B00A5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:06:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 108B413BFF6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:06:54 +0000 (UTC)
X-FDA: 84591263148.14.F774C5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 966F2C000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:06:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UaQ7wuq2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kh+jfeZakTdDR7kLQWAKSzB2/oy+VfaI2uyYIv+5Eak=;
	b=Uim2SK6dYGtn1r5rycpKd7XHD406MAHUbATxuvrTctoYhoQ4DTG+c3Chiiys5/vvUFcfi9
	my764iDRsk56SQD9HX5msbOT2FG2WX4yezXXsmRcvOl3cM49z4P6KyADl0xlU7GcB4pUlP
	vY1hnHI/daZLh3EQtVMAHqgtZxi/7Bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602412; a=rsa-sha256;
	cv=none;
	b=xjt4HOsIJrQYGThcilvo+6ST6hXNsXu/pZYFSpxxsPcVnm3TK7ZcHqEd7f9oa8gD1kREhR
	/fHGuLvRiDSbtWtxDou0JS7ug7+NbNUZLRoroD9lAMMbn6L/LOOed6E5ie02eY3jvGrMw7
	V86qrXbzuNHOczqvi/dPa4R2aw8vANI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UaQ7wuq2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03A966132B;
	Fri, 27 Mar 2026 09:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25144C19423;
	Fri, 27 Mar 2026 09:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774602411;
	bh=zCUe+10pc9NzniBg+3H/fjkn66/IAuhTCiP2Sjn9XC8=;
	h=From:To:Cc:Subject:Date:From;
	b=UaQ7wuq2LAVDVorSRlR0v5oN+8l1EEzicAlpp5W4EDxXAK5kRe8atolhh4sMDtikF
	 3mTTtK3OCvoA4Rm1nxfitvZTBUQt2rjQjG6P337FZlyKL5jLrNemJ9S7nuVORSJKvj
	 BH3ROLdHgu12qlZvVYwXiGOeQnKO+F09fYDRGKr0vdTuhcSZpKm16qbuMvfyuPpdhh
	 TQs1+wMN1T1InPplQ3whdLM/FxnK8uF5Vxkx8G66Pb/oHem1/jMVYGY0YxvNijyhhy
	 3uzDNAnjDM3hZ1b/hZVkB5dPgh4rKuLJ77L0AspVA4So2lkk3aW2xUJvFQH6oNB371
	 oS64tR6eMLAQg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jeff Xu <jeffxu@chromium.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	antonius <bluedragonsec2023@gmail.com>
Subject: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Date: Fri, 27 Mar 2026 09:06:40 +0000
Message-ID: <20260327090640.146308-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 966F2C000C
X-Stat-Signature: gzf7uq4tkmhddofakih5o4we58fgygjq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774602412-988186
X-HE-Meta: U2FsdGVkX1+EDqILsxz3PTIe5wEoWUXhucyJUlYivYBblPegVF6X00UGc5T4P6Y9Cw/O1wTwPvNRMjVR70sygVvQm/+FIcBTsCZ94h1EZ/aH/R8mQm5quZIkwH1hnTTKkZXSvIj0bTnPw8KbGPMu1gts19GKhT8xYZZqXRHDeF4PJlo/DqFET+gEr5Mqn0PvmBcuTgg5u3Ey8gjtUdrJQRj4lIdNmlxTVFp4cLT2cwLWmY59PzDHts+7o/V1K62khpIgdkl0zOVyltHWJibiO8y1eH7tdXeZYu7L82CwVrXdcchbXSJ8PWkdPHzZFUTkb/8qdAOp58GkLFfdzb5cENnckXUdjUNoMu9oImOLw454nUGeI4yELoXL3OuApEkKn4Jmzln/ernMRKwOVF9402Gn8S6Cup/qt7NKGrpm1zztRdKdyUNRCXECBeEApIzabK/nZ7bJGNP+0sxEfJtWd+DIhvYvJaU5j7/hUiJj4Igg7HvKEkHg1Gb7zwQBAvOLQHusS23RAHFRPUhRP9iPOrlvH88rNnbCPbsz2yKpc0fT4tJRnroTOA8n/164uWbH2ZMhU1TJqnKEoGSxHw8NI7w+8Fsz/Sx2L5XeIe3TJnjj8Ycjrn7aCSf4RQhbsgSwQFWWqlnFE6hxZ+XoAUdUvYDvwCAo0lSk69u4YV5W6hCBhtlH8vluEO9jvzFX4UqIs27l11vBHQ4DsNiyXh3jydelTzuKB7ZZW6RVEFaYY0org2nYPyh8bYi+krNkHEyDs2HJ8w/cWHgaM6wvVsfEXBbebDraCF2W2dEORWBV8JqyO7QzyaCbeXb3Ii3RNzMSt2YkdpfA+73pYCrk+a3P6Dyys3JaFXOruX/tg2ftfkCLZa3UInjQDP0axyCch1tYHmQjGrbvEqM1F6UJXV7ztjCYaaTUlHFMBcbNTLsDgpth/TKZOT/ASQYtx21x+mrziar2QifeTxcpNn4Id7Y
 WglwOHDJ
 v//kWEdhPpdUT8cU8rtaQiKdfevLCyVYGfuN+/scEee0EuIS+zqy96hZIpso9VQE8QGF52jOpwPNf6t0UhIyvU84wm4FofZkkNe4sQh3hyN8crBIToOF4126N2+1BTvDoyzZ4YicSB2ea4teeiepSNk2FkJepF5pIwABSmGqDF/TkaMm0BwHVh8OlbZrB6JZiEEnmP5Tqdtb3/rWE6QBQ6jE/MOvwgRff1rrzQPDQ5ln2r96cV5fH2c45Heiyagh5mzOz6MKhnZHdxZYGFkuo9EYiF21gQMJN4cf09Hn3jo91vr8vr11qtNtKdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously we stored the end of the current VMA in curr_end, and then upon
iterating to the next VMA updated curr_start to curr_end to advance to the
next VMA.

However, this doesn't take into account the fact that a VMA might be
updated due to a merge by vma_modify_flags(), which can result in curr_end
being stale and thus, upon setting curr_start to curr_end, ending up with
an incorrect curr_start on the next iteration.

Resolve the issue by setting curr_end to vma->vm_end unconditionally to
ensure this value remains updated should this occur.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
Cc: <stable@vger.kernel.org>
Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/linux-mm/CAK8a0jyHXqBpt8Xe8v9SNDbnRiwz7OthA8SKY=NLRY7smPEP3Q@mail.gmail.com/
---
 mm/mseal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 316b5e1dec78..2d72a15d8ea1 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
 		prev = vma;

 	for_each_vma_range(vmi, vma, end) {
-		const unsigned long curr_end = MIN(vma->vm_end, end);
+		unsigned long curr_end = MIN(vma->vm_end, end);

 		if (!(vma->vm_flags & VM_SEALED)) {
 			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
@@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
 			vm_flags_set(vma, VM_SEALED);
+			curr_end = vma->vm_end; /* Merge may have updated. */
 		}

 		prev = vma;
--
2.53.0

