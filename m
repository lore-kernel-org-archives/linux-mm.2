Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB3E606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H0IIX6t+
Received: by kanga.kvack.org (Postfix)
	id 730FA6B05B9; Fri, 27 Nov 2026 07:26:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708F96B05BA; Fri, 27 Nov 2026 07:26:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F0C6B05BB; Fri, 27 Nov 2026 07:26:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6696B05B9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:26:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C29E11C3568
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:07 +0000 (UTC)
X-FDA: 85480821174.16.DDDB415
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C6AE18000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0IIX6t+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782366;
	b=Y0+oh5fQPUTeB4ZvZyxrmP5BSEr8htueCLAQqcqwp6hrpSy6Xe04Rb7amwxjpnHJjzwkEV
	y4rG+9Cy72FHwdUCGpMJAXFKGV5gbmT9bEf0/dnP3XOLLfO2jEf0Yj59U+wihbMxtqoZd+
	HBghXvAKCeZ5VMOxGzYPIDe78oWe/5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bg93s8E2qpiOXI1yg+RWP0SFq8cNRtNnpPDwdNib6R8=;
	b=feNtsPWMoSBtp+EijEiTjWqzKca8JTzjdWyGMfczmB7gDYnlz63dmSDcvt3Xqm57rwdSkf
	RjdufFemhUAsVz+v/ZH0Ttb39K+t2BKs2DD1fWLZR7fX6JZenye7ZK3x6Bg4EURRGtt4ig
	HtxLUrnnZMjQQxQ54wfHsM9I6Cu6tBI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0IIX6t+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAC81629CE;
	Fri, 27 Nov 2026 12:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1371F00893;
	Fri, 27 Nov 2026 12:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782365;
	bh=bg93s8E2qpiOXI1yg+RWP0SFq8cNRtNnpPDwdNib6R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0IIX6t+zutMiF55Susal3PFvq6aiLSRkmxkwqPipXuMFrZ93zliUC5V2CKvPwfdQ
	 krRhxyZjzHgjMJXE6FWBLzxTw73NHDgXMGmglqeselfTCPTNx30Xv6xv59vp2KWumb
	 eM9M6RX5iSa+q1vc1gt8I7WY71fPqlxMbqOTJ/J8WRgvaoRzE/tlkNOEj9+3vZFA36
	 KhmaJZedzie2/kNbRDe7B+NTJheXmcpOqX6JOTPLBUoafGU8IErF1ucWcpBjtArpiz
	 Roq3DD1iyJaiquku45grPzzBTugp3kwhQ6cgusx6rE/XoMzx54PyZBvaOvBRuNXMvi
	 ePpFfD2N+Q1BA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 5/6] kho: fix kernel-doc return for kho_alloc_preserve()
Date: Fri, 27 Nov 2026 12:25:31 +0000
Message-ID: <20261127122536.3708770-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <20261127122536.3708770-1-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C6AE18000A
X-Stat-Signature: np8763gdr5taarz8ghjm5km8u55t51sb
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795782366-800081
X-HE-Meta: U2FsdGVkX1/Foo7Tb5j2PLHWWngGMCa7tXSzdbHEPhIPwUXvySkpFtP6zw0tA96Y4/KIlWhff5OGn3UvV+wwLk8g0flHwB4sLIkoES3GZJLVuxrFjUoNSwjsKUvanDGDCe9s5hwmygHUubxgo8wBGGDCz1Jlb5AabsK06jYEt3efFLhIgZmuc8NPxQIPNxJ9aGnVBhz+m9AJ5g8l/el2N0Aoy1VgFWgw7AZvSLDeXU5EOUjvpLw1q1vSuOaitfzeJkEZEbAz20A6FZtWPZz8ZZXCRFiARIlDJ5r1W8UsBfOx2/GqVaILV1e3TZJjiqI7/lmEHrSSjieBiANhz0Zl/2r+AnO0FhwX4OlpeVI6ZVlpg/7ESkMFrCEI+Hub1+sN8+p7AC3gXw8Dkg4g/cXR7AD5PTZeYgYW7gxVYq7Oag85CFkY0strxA21gtxUKZXDokfq0bNlcDtA/5MlSVGoCu+3K5PqNWZDQyZMSHHNhdNKBsD7mL0gKHdI8SpPRMI/4XnPZAWpsiju5KbbWO4Y9leXrsonpuS437/ULmQhZvQA2cUtfSDFlFW7IzxKBDDqfe0jlBCfacVLAC3Hu2nxbBmj9THN1FmOxbIhqMSZd5ctXyZqlUBoNOOnaNjxGRcmP3gBVNCY6v5zr+DY4acW1gLxid+a9WDcc984Edlx+dW04wdddVgQzDMGPrUfLBAgwxO4ch1dHdxatUQGlVvDOlFY4YR4Djucfsvmk7BEDtmRyyPN+QSR0ZIo9hnlnx04J6RKT00u53/EmJEDKbCwb12phYmBie8/sfKsnyqK+tGcqMo9SZOXyBuxu2bHYuX5aG/Hwf557fmuG+ccpqdSS0dmnPq30IUvszlgC3BpTBe4z6vucqKk98f++ptcJro1h3ifR/pZKqWUZocdyQOMbnvTVoZos9m/EYjFBdhfwhsbBnTEF/VAIszG84JU9nmCgbyT52AAJxkvabSYX/G
 p6z9HfjR
 vTPlXdW0trGYAHd0HRSlufCrwC0aRZSHxJFMOJtup48dLgW4WRhGwbAT7h9HudFCk8nqkUgx3YdVEkmUKkQUILByOfoevSy0kSnoB1A6GWkLMATpy9kkei4AJb2I4r2gklebfDjGQ8vd3SA8Pc8kCC8ttsUYtk+y1AZqn393cYDYIzQYbZ7uXxsj/wr7ALGJFJQO2PcvwCIfCvtfMz7FBJAwAQZo3RIqYqkAOjrvV1amjLeTe3//kSt9wgxzgBTYLs2reHyYPUzYAWV3qGusuRm7FOaZ4ElW4ZWfCNVSu25YqDNh8JA0NqMpjHkLuPSfYuCQ55o65fX4XdtTMUFbilyG1DYUyqotwK6m72/EHNaIxj3l1sUKsOWdXxBwU57pu58g1ysl0cx220Cxezvn5k90qYmQllva84Xg/ivGfeSoktyeAmM/3rmNF2DiS7VRUNqbOSALgGCY/RPV+8/nKHy8Rdr4m29+zBB2mzWeJuD4h+DDFPdwPMVmCqWQAHbrW5RJr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

kernel-doc complains:

  No description found for return value of 'kho_alloc_preserve'

It does not recognize '@return'. Use 'Return' instead.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kho_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kho_core.c b/kernel/liveupdate/kho_core.c
index 3f9d408b9d29..580cdb3ea070 100644
--- a/kernel/liveupdate/kho_core.c
+++ b/kernel/liveupdate/kho_core.c
@@ -1584,7 +1584,7 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
  * Note: The actual allocated size will be rounded up to the nearest
  * power-of-two page boundary.
  *
- * @return A virtual pointer to the allocated and preserved memory on success,
+ * Return: A virtual pointer to the allocated and preserved memory on success,
  * or an ERR_PTR() encoded error on failure.
  */
 void *kho_alloc_preserve(size_t size)
-- 
2.56.1.839.g22a8290db9-goog


