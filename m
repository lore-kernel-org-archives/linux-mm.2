Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40196D3F08E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 16:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F6F6B0089; Wed, 28 Jan 2026 11:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9645F6B008A; Wed, 28 Jan 2026 11:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891376B008C; Wed, 28 Jan 2026 11:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 763E36B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:32:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 156491A0709
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:32:06 +0000 (UTC)
X-FDA: 84381914652.10.ED15609
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 23B11A001B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:32:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGlZKZEB;
	spf=pass (imf15.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769617924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZBOhl5QfO3A28TRtYUsNu8pCd3M0zspq69YD8AtaJ1U=;
	b=W9w7P2SkaH09ZOKNhZGofu2wEGXZr4Ypg6JLtEPiDvbfviY3OLQf5+dMg1Tk9Nrwkd0J2Y
	ideeFayvIyyToUCBARScDQlcnUh7DAWVFkYX7cu4sgLcpHNH9yGlpn2pipMgmmFwXr5RFL
	jICLb7YsHskZs9C9Q5Mop0Brj35OyG0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGlZKZEB;
	spf=pass (imf15.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769617924; a=rsa-sha256;
	cv=none;
	b=7UG0pTi5ED54U0ppVwxm058/Ki49ClPvJ+W+fXrPZbpQxLmH/1oR11d8CpVHRXUnoiwCwN
	ysauGZ2gdHgrDisAoHzvcfYTKH9KvXviqSl5RxvyDTViJ+4odZ+6Or4jFd+sgx32Q485Je
	E+t+/2qf9rBYNk2LdZm4ZvvADRJspzE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0236343F81;
	Wed, 28 Jan 2026 16:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA51C116C6;
	Wed, 28 Jan 2026 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769617922;
	bh=QbKda8xrUxEigtyC7rW0AxjR7Uf/A+PpdEzSH6Fe22g=;
	h=From:Date:Subject:To:Cc:From;
	b=WGlZKZEBAWrp6M3gAhqc9Xng8HryUVtKz57fHjJfGTHD1SJcfgL6NxkG2UsUJKY0N
	 kMrxrHAMg2xijvw9NFY7gyM9RaWvBUGzZ2sWzIxn6RB2SjVCul7zW54WdX1mAMrejy
	 hdHo/FwuHixXiHbDQi+hdECCjj0pfAJ7RPjKywriaavSyjDVw+jw2XzPo0P62VrhBV
	 bWV4IBbvxIjqeft7yTC9kMKPSRjmh9USEPK7Bwx34/DIElATfZVJ1fzV2ff+E9Wl8J
	 vWdlGo/Y/MKSSiItR9LdslW368+f+o4VkLAoUK9kjD5rGFbh+i9ge+u5wrseQHVxoo
	 IqIByZgdw1Xeg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 28 Jan 2026 16:28:35 +0000
Subject: [PATCH] mm: cma: Fix stub for cma_skip_dt_default_reserved_mem()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
X-B4-Tracking: v=1; b=H4sIADI5emkC/yXMQQqEMAyF4atI1gZMFZW5yuDC1qgRRofGiiDe3
 arLj8f7D1D2wgqf5ADPm6gscwSlCbixnQdG6aLBZKbMyNTofi32sqOuwSqa0lLumIqKOoifv+c
 4Pr1v81qDnditdwTO8wLhlRlpcQAAAA==
X-Change-ID: 20260128-cma-fix-stubs-26b13ce1471d
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 "Rob Herring (Arm)" <robh@kernel.org>, 
 Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1283; i=broonie@kernel.org;
 h=from:subject:message-id; bh=QbKda8xrUxEigtyC7rW0AxjR7Uf/A+PpdEzSH6Fe22g=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpejn/kFnEv0sTZo3ggeXRnV6p0sd1Q1aVspYj3
 IOKRPoNG7qJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaXo5/wAKCRAk1otyXVSH
 0JeGB/41twQ91FH3FSXXsKADIC7eENmTj4J51sGJB3NrXYPL7ENLa9gXdpwhLPoI1U94yx8Brm6
 K2Y/SyFw/1c9fMnsj7kSDGEcaNvu1VUUDf/rW0E0Pr81/KuX0GupHD3NbEkumCZFbXkA7qlPt6s
 Y5VYm1B6oAgAwijt0XOcCvTv1zaEbbi8dskeRBLAMkh7Pis0Nx3Li2LTHMrw/kXQFVjOOcwziQW
 JSaxX0/cmNy83GD40qsw+w/REvbuMEadToyf/xlRtTrDf8W1O67lo8RVWtbnIxrJcrN/rIe2h8f
 yZYHaR04sU4tdsbiyUTBPA6nBMw/GqK0CBfYqI72zKJnSd2b
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Server: rspam12
X-Stat-Signature: 673f5s76w3dg7hb99grkeebzsab3qmao
X-Rspamd-Queue-Id: 23B11A001B
X-Rspam-User: 
X-HE-Tag: 1769617923-77380
X-HE-Meta: U2FsdGVkX1+02FmCu/t1bheY4DTCWms8fkJsvBN3fF65bixbQxi+nUoGX8HZP+gdG2UYvF2Nv5tcHZqLwyHuUj+t5qIC/8yVvpaS7IMBZT4+euT1UBvSOlSKYK4hLRn2GxH/YXf5+oX1m3ei3gHpL3oTnhTNgw144DTaEX0731hFRwcXZas/0oqjv7aP2YSM0WlRW9PEhQH1Vu/iw5XRmcHiRmfigo5D5kebNM0fJ5LYbzbfwP/OtF+xcMxlubuTmnSRUxHuw7jO+a8ApzS/Fywp0VgxTskUu5/WRFQVjfio+/OW6COgdU0cEWT6+2Ro0taGhWz9uds9Y/WZYZJYmsqPqz4R/VQh/VFttNg9gAfaZEUmUHZFEMlU6qcjwGaxPTrwJb2sask1tgzaO8dmqZ6oBzkmqsvh6XcHkK7eT1OmmJnw/r+VFwIlhYgTjiF3KK11oUYsNAustbmGUmy0PbKcP61WcrCk8sTlZ2t2jA/37wPomr/qhwTqq69alChpYHLDaWSteBNH9tJ8zL7ZJfsuDePFp7J3Sf7ZsZZzc9oos02SYHvXTn8IpyJsaVwgIeHwnkd1VZaUyOr8mfibsOWVQCSkMO19yqrZ069SNQakqnY3kKpAQ7hdscWHeBDlk5AAhh/Lklhmhve2TXwCb7JS8bbK7C7JLjOopeTdjq1TKkOKKaZrdsuiAj52dL3bCBAbQy6SF46jX3lFaKquHs8/sraCoNJ/Vcya3CNuWZ8x3VdaDVsU39BbW7XTT+VOb2NMC5E2JqZ7SO8vSSjfdNWvXgJ10PBoI+RRU68g+xHwAFuhl5+pMGZoeup1ekMtfaYDmU37VI/ig50FmUQ3Iry7qgjBzr/iy3iFfZizLr+U/t4+6dchixRSnDXI7JDsfOO8usVykxA508gOqZduXsPmmR0vJRlwVM324LWMT5+PiwjZR+je/s1rEL0EpGN0IlZt50V8op3dCHLkosA
 XrbmIFgT
 UEEn8VJN1v0+I47HWH6Rx2Nv2RcNCFJorZY4g0FAjznPX4t79GONkNu+9Ma1V4M0ZJxSyb/y5BxcRefi3zCzokEwcw8v2DH+SPQsxvRGokqX2KsJvFNqN8ndUcBIh7Q2OnLFfslsZgjOf6bpNNcyJYK2Wu6mvQT6x287CyaLmbFK9XfGs175osFcKDkFSPT41vXxyVCvmHDHrC9WnG6j1LZbtoL0ERd5woz3dCieBSW2lpRlFEYp1aK8XzFY+uykCciAxIcA30zrWKq40lulOrD8+CL3AU6HVoVnyFs2R7uFo25EmDKc990M3IDVrSsWGkW9bir+/jIRN76w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stub for cma_skip_dt_default_reserved_mem() is not inlined so
triggers build warnings:

In file included from /tmp/next/build/fs/proc/meminfo.c:18:
/tmp/next/build/include/linux/cma.h:68:13: warning: 'cma_skip_dt_default_reserved_mem' defined but not used [-Wunused-function]
   68 | static bool cma_skip_dt_default_reserved_mem(void)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

which are fatal with -Werror.

Fixes: 26332ae848f08 ("of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 include/linux/cma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 0bf408360641..d0793eaaadaa 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -65,7 +65,7 @@ extern void cma_reserve_pages_on_error(struct cma *cma);
 #ifdef CONFIG_DMA_CMA
 extern bool cma_skip_dt_default_reserved_mem(void);
 #else
-static bool cma_skip_dt_default_reserved_mem(void)
+static inline bool cma_skip_dt_default_reserved_mem(void)
 {
 	return false;
 }

---
base-commit: d0d97f0b2b2b4633022dfaef4ac08af0b7917efe
change-id: 20260128-cma-fix-stubs-26b13ce1471d

Best regards,
--  
Mark Brown <broonie@kernel.org>


