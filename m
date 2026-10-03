Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2E6CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60E46B00AE; Sat,  3 Oct 2026 17:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11B76B00B9; Sat,  3 Oct 2026 17:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27916B00BA; Sat,  3 Oct 2026 17:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D07F6B00AE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:35:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33A7EA0A14
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:35:12 +0000 (UTC)
X-FDA: 85282620864.02.DC4711D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id C4DD01C0007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:35:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Y6GWTiYz;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791063310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1K4Bb8TbAcWVToXI4RbrgbOR5huL24YK/BbhnHns2K0=;
	b=3+GEv3qJw2INnUjfh9r8wq2kh9+dD8HcFTvAw4jb/pAEZ+L9iihoaZ+u7EBRHfzZx+Ne7T
	pEu1VgYQvNLXY0dEYFmwyIVqUODA5iaktKklyOrqeO47sOGeb3Fwy9WKVoRVPCWxSs5oSb
	ehorpNr+JKQm5WCuSMM/phW7y9SP/v0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791063310;
	b=fnP8NquL/yPViYS47WnNdHOjd7XzDxHPdiiMkLFvqZ4DzMdEGv7FBJsOYgx0XVBTuKDVhD
	qHjL5K/fMq5DUijcPEPIxmnXEV3sA5SAJVWI19/uLoDFdfrYAawkIrNjiuGJC5gNTsaAO4
	wU2Mqdl9EvXDt4blJQiMD/XFlubphJ8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Y6GWTiYz;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1K4Bb8TbAcWVToXI4RbrgbOR5huL24YK/BbhnHns2K0=; b=Y6GWTiYz9EQjCmy4o5haJ1IoWz
	jOVdoaSwoI4H7lzRdHizquuOJHkEfo1kR6U/FoJK6/x+js+T3I0yU4Al26PQkvVg0jmygsY8QfyXz
	IDsHLk6i+2hxInSqjtc7Hg6Y67Yc3RBPm4f1D8tF6mBICdRuI0CQE/iDQYmwMtHXYzesV+AguB0Z2
	T2m4ILHdLabgT4nq21FqiMsUbun0LlTQgtinZGsYf2NJRwCVKd4nIcWD9OWgAzCGxkOjVP9r89HRc
	Np56s/QcmSm51YPhG6rSxlv1KFhk847t0IUnFFkwq3KImqf2PEi3HJAhG9UKmWToMmSbIJpLrmESB
	Y5J4pRrQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xD7Ns-0000000E5FZ-3sMR;
	Sat, 03 Oct 2026 21:35:08 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH] docs: kernel-parameters: don't mix cmdline options & build options
Date: Sat,  3 Oct 2026 14:35:08 -0700
Message-ID: <20261003213508.96424-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qfg7mtaqpehtf8j9npsf47cx3rh6zxft
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4DD01C0007
X-HE-Tag: 1791063309-318020
X-HE-Meta: U2FsdGVkX1+nkFJgfyaYuA6k6dTZaCTHArpFKYNYsR2vIGhFhOA4/gmpv2zpw0W2g9k9Q69D/OeBzojApppjyej+1lOt1dAJg7PIFQIU2Wt0YAhg/+2p0GRZ3JuEgs2ZgWMTQNBlYMoRwZ08+N/HmsOgqUqLxyRd1N0eMTludxiKN3X59xmqPG2M90zgSPnHC+vC3KqXVmFRWsyLDz2zOCgNwGzdgxOzWuuhbZYEY6qikr2YmgNJEipDzT/NgOuGWY2lCClg4dZ3o2e6YCEZB+YlJXes0wEKIL8PszZTfaEv2ba4mMdMRYUe4lDseQUSbE/h3OnbSsU8j4hr6RWetN8GpvYhp+jHQob3aIyhLXqUI/U7t0svFZn9kXl5j1a7dLQnKxixtKPfKGX85mRZKGzn5miOZZgoC2+dvOB9+het6CGvUvs5WPxk+zL2DD0hDwxmLNB4nDhoL+T0yj4wqE2NdoBMYyaSey3Mu6PAaBEXhkr0eQMBgEtzn9JGtsuxGDYDvHGyQq4yomdaM6VGMAweii+OTjE0+fiztrg+NQRvRt0F6BpijIJVUiEhJZMUeT8cXB89u8LaCTLAacoOCWXwXvkwZprsjyhbD7dTIufAFkHU85eQ8BcH3GIgyxWDqK9DufGRb4ldkBgYNiERFRDpyCvIDu993IsxrYlgLrSk3KoY+nYhJK6aXCFE+PvTLBdkOfLZcUsh5nsMmrmJy4P1YjA+XsbbIqydptgYkEoGehiEkCz7515z3y8kLBx40NA3gpSPLLCWGnWjZ2YmKxWrk/1H37yKdb4ZypfV9UDjS3vc6sOyy+YSS+LMYfIB/KNHi/aL+6R8jlYfzEPERCgPIFwc6mip/jYLxz44YtdJr+hNjCn7LcMQIwzz4nu4hgke0r/9JMLFtP5d5RiSeM0duhyAXtEjBSPWPOxhtyysnfe5SoAkiyld7vAcYy+QRzT92VQzzYh/Jf32U3w
 YyyhdB7B
 gp25QqT56w+/qQ7WpLYv6ymp4Hu4hF6iz27os7VNjzZi1rF+7XjF4NvoZgKqS54VvkUWNoYqsX4Z5gECABUntMsaAjY8D/HyYt5a3vKiXpkvfqFfBR4ID1od1Yf5+GytrtRO6pmu033qy6iNRJBDA0ry/0DgdJ4vD53hamT8HrOzE474+PtDs4F+vJNZr5M5cxw3+A1J9ukHJwXWq4pNPdtan5wRnpsFW2rkj1v/G86XPDwr5GnMkQzpxsLSi+sBMWlXXuDITLuOfhmHKXAA7fBM6QPHcbnK865mkHv80brQ+iz1FQHRQ/8r7QjUi3bvlz3+M5s14/uCKnEZYmXcoNTE5vdlYgK0xdL3fLrw61tJzMI1g6itkOjCMSzfZo14OooGmJx/+FQH7TQG7o7Dd6Lz2h3cSAsTOQIJ7wKmfIdE82TQUhYh2csrhuMHVW/K0EOoXVH/+O+gYuWGAowVD+j4Z2vxwy59vmEFOHN2FzQ5M+ObIM1K7Ud9zYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some kernel command line descriptions mix, mingle, or conflate an
optional part of the command line with the build options that are
applicable to those command line options.

Specifically, a few command line options that use "KMG" to specify
a memory size mix that string with build options like "X86,EARLY".
These should be separate fields although they are both enclosed in
square brackets, so separate the conflated fields.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org

 Documentation/admin-guide/kernel-parameters.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20260930.orig/Documentation/admin-guide/kernel-parameters.txt
+++ linux-next-20260930/Documentation/admin-guide/kernel-parameters.txt
@@ -4080,8 +4080,8 @@ Kernel parameters
 			like Grub2, otherwise '$' and the following number
 			will be eaten.
 
-	memmap=nn[KMG]!ss[KMG,EARLY]
-			[KNL,X86] Mark specific memory as protected.
+	memmap=nn[KMG]!ss[KMG]
+			[KNL,X86,EARLY] Mark specific memory as protected.
 			Region of memory to be used, from ss to ss+nn.
 			The memory region may be marked as e820 type 12 (0xc)
 			and is NVDIMM or ADR memory.
@@ -4371,11 +4371,11 @@ Kernel parameters
 			Enable printing debug information related to MTRR
 			registers at boot time.
 
-	mtrr_chunk_size=nn[KMG,X86,EARLY]
+	mtrr_chunk_size=nn[KMG]		[X86,EARLY]
 			used for mtrr cleanup. It is largest continuous chunk
 			that could hold holes aka. UC entries.
 
-	mtrr_gran_size=nn[KMG,X86,EARLY]
+	mtrr_gran_size=nn[KMG]		[X86,EARLY]
 			Used for mtrr cleanup. It is granularity of mtrr block.
 			Default is 1.
 			Large value could prevent small alignment from

