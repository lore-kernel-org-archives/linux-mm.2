Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE06D606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bZ8cCMhP
Received: by kanga.kvack.org (Postfix)
	id BBAC26B05B4; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92B56B05D5; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AD36B05D6; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 827B26B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F40F2A0A01
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:03 +0000 (UTC)
X-FDA: 85467301206.27.67516B7
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37FF820015
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bZ8cCMhP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3bI0EawgKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3bI0EawgKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460462;
	b=qKSlgfI3OJJW2KTATtF7q3gOKAu/6D8dHb83oOCl0hdSqtwqHt/kjkgjixQ7uk3/UWuqNt
	kwncGQ/aG4WyTw43bziEFztJ8bZ3cEB2bYCCzd++GHyFRsu5BuZHXEv0s4I0y+EmPVRVsm
	7BYovie01kiCfufuFn8Sy03FCsWE7hA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pH/xf3kQm7acLfNhYZrfRJLXvU+0NBXvSnbGGfIqejo=;
	b=PS+cgUcCUfQftGUmwja99tYL+buh68KiB5dakOETzd4IA+EbFHfTs7Jj+t+1QWqV8zvwM1
	NeeqbvrMYkYPuj6GK7XDkhuvHpoqzZ3Lie0QKYL4S8nSYykYK8e6dS0CNQPVOMxNQbPvLI
	Ro+AasQWpgPn4oJzVmpnVH9p8T/TwoQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bZ8cCMhP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3bI0EawgKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3bI0EawgKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-574ae6cc614so3836958b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795460461; x=1796065261; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pH/xf3kQm7acLfNhYZrfRJLXvU+0NBXvSnbGGfIqejo=;
        b=bZ8cCMhPaAwU8UUu+ZCnyKRiAEEZsdtYZTGsOF/SckfbugD+vqpY25Xx+MgWYko9Rb
         Mevy9trcFfVddpduZ9xispeJUZkSUoI6hr/TVYuREqByw4mabGI4JQi0Br8Sbf8qDE2e
         HaxjTiSCo3bch93hwvz9iBX45ApIOVvyrnJ3wN0XjwBi2P569STxdF7RDHeLZdF2VXJ1
         ovkQMOUfJM1vuXtB6uKRYnjIEGO3motg3n/9pnssLsmzFYX2CLbAc7ZrYiI/38XkRY0t
         hR4mib7xsD674U3tXzor3n4Poxu1eZuyyx6fQ6YTC0h6h4bvb+Ka5g8bNHusSj6z6Hon
         JdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460461; x=1796065261;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pH/xf3kQm7acLfNhYZrfRJLXvU+0NBXvSnbGGfIqejo=;
        b=YBEP/sCJCVINTba0EEkBmUj0E/YOMQSQzjLQwdFdTm1NMBZyFWAlcvejXiFGU4xGbT
         H9UhYdNfN1ju71pxGJtUQUJe4gKxCeMDp7gcpd+WFRtMOFZ7R/QX4orPtqlAYZ2ccbsX
         4SO689bnGzwD4ijL7YrPndOn/+k4YxGs/Htm1xy/XI5gFGjgWspP22Il6iWoEjNvhtk/
         R4prdl0BALj2/Nsux8xV6ixZiqIWAQ5PIGkAbvgI+oON72FjgIY9ePqRQG3+SJLjyKXE
         Z5GT/OgDraYgNsVO928bmkvVD8MfzQUYzC7lqVE9uGd7fq8IRZvpaVi9hdi+ZOQhLeYZ
         kmJA==
X-Forwarded-Encrypted: i=1; AL+hErG9HWSwpQvhOKRfEqC+9eDwvncAcQ98QAsO72xdJse+c3zN9DaOb5mfWkYi/QsG9cWZorikGXv+Vg==@kvack.org
X-Gm-Message-State: APuU4Z8RHNeAq5Z60bQy6NdUCZ/592ekmpHrSGoPYE821uxtV72flRz5
	STZWiGkFn9uJCyYkbWvFonqFY+iCryOL09WVQxuamd/ydvkhKROwprA7q/fOdaUNkIKNf6d5AZb
	z8PtopJk0uNrkLA==
X-Received: from jajj12-n1.prod.google.com ([2002:a05:6639:18c:10b0:5fe:be7:9ab2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6d93:b0:4f1:5068:b93b with SMTP id 5614622812f47-5797bb9fad7mr10333977b6e.14.1795460460873;
 Mon, 23 Nov 2026 11:01:00 -0800 (PST)
Date: Mon, 23 Nov 2026 19:00:44 +0000
In-Reply-To: <20261118223704.3286085-11-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-11-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123190045.2166865-3-dmatlack@google.com>
Subject: [PATCH] fixup! PCI: liveupdate: Adopt ARI Forwarding Enable on
 preserved bridges
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Williamson <alex.williamson@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 37FF820015
X-Stat-Signature: z8angxhe4gcireigey74iba9jbaakd6j
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795460462-207070
X-HE-Meta: U2FsdGVkX1+3niC8WCRgTx4yRXWTj9LeHpLR182b1CcaWm8lUW5ye+vDx95IcX3HqPhTPmC0SR4GLpjmgke0KgCOZUYUB7Kw38GSFfa+MbB6aaxhmfTx/70gwVVPRJrEVfrm/AqRMe2cuhuO1UsZXY1cbUDaw3ZfsGVRgClGwoPj552AllZm06k6Ik3EkedYnaqEmSlkkFvmqS11XUlCj6bauvUQ02WSlO40TjH35yeCfmn8ak8FAXi7X/IAsbX9NCN8AqYnHXqjxVp3SOsE3RYLChm+pdX1pjGOuOQqjFfJHNEWtRkTBG7C4p/wX22akF4mLs7TaJeHwAW/Dkwa2DuzdR3OPn1chzA1yVrlD/Qveq1BYLJgHkfQxixSoRRXe7JmNKMVhr3PYArt1/i+6p6FsYb4Zrw715BXWWt8b48CLiTKsHgwxZYN1/vi8HqrHw27m3bj7ioE3+j0fywP0TnByp/TU3m2bOT8lxGz54p+qjLJyf5F12Yq8r3ZqOJ2n2wPMxwI/Zi1Zu2+k2vghG426AiIRsU0Ddns3aVSIY3vqFLC25zlitSqr7RqA9E0Fiz9GOGhEDpic3IcWRxLr/RBV2OFb/+9L5mSxKx2/KBmVpaRdourF+72uMSMGZVwwhL3hL7MQGW5dTFnDD1Vzac039biywMcDPdmOJvsh4flIjKVqC6bhei1fW7yLIVS2jDkr8QgOk0dVIE7h1Mfsqe8zPwxyyqX3ONY3ZmgI5GxJm0zHT5FYJjWVqJNdzZ+SxS4wiDOPkWazRKCw9pq5EIWVVG4/cEQZ+h+ZBErrdLPtyirc2wNtL/dAVoiIqsAS9hIy8qbr8qBKQDB/Zqa2j/wXzy11U4xT/jfBakMJ79CL/FJfNhQUHRQak++Wl86K41ADqNSCnLNw9sTcIOQA3AYDbO7tVSUKeIA/sFLudyvPIAhdbTpBRtlHs7cBRMTciqIAhFpXbASShCPqss
 EpHFAqnm
 doRB+UIBWRWHPo900g9lKwYcj2Wz5tFlPbKyTm4L0jDFppi9x/GAuCkOPoD1JMrcr/zXTtKNkVs5keKoXUyi41XJb/ysaroSbSEbzZk24CfGRyH/5mtGzmva2bnz5g+VZoKQK3siqoo9lJIdZTZzvTaUuVkqBdm9pMJn7w4h+WqDDmOXC7xar5x+dx0paFELKpnzsPC4uSiEx9oe8sEOO3E45DhS79k0Plgy5pSVktzUQyRyFW8igfqQWHV8v0oU/inOs3wXDuv/x/rCuHK4x8I+oxaTydpA4gq08eVrkKIVQkhoaa23SULpksA43bBh8GAddoY1J6haD2FnhHcAAROj4ZpgvzNreAo1lzJMv7xCsBPkx9byUI11RJ8VMNXRmACC5JZ6ikz8jA7MVaoEfFwk4qxkbpGc0nOH+kaKcarwBNJ2yuMfUi1AMdI4CIf6omkykYeVnmvcgwIFUaWVcE1BpMOs+huty7n7tHm12pyjyLa4+sygJ3+Sah+m7h59aF8J9d57VRnxmAEsQNP5u50jmpwhkqZFQM/sdrVAQ6+v9QSb0ufVpu8SXFpe3tqz9WncLr0VZh9TheQiQNwPYiGPbUCZpafuwuQN3Udt2gGW6SaLaglkPeTKFVge6L39qE6bvEWuIV4IfI04tI5UZ+MxJI0CIl15Dwz8/Ei4sOEy7sQoTawI81xP/tZvSm/mvFhxzET+96Eq7k131P7YjeQRNkeb18HyzBGkKvKEZUjrp2sUti9Hg8tk/mftXE1pZbXIJMBlxXsU9jSJVenxhn0yljwtONMdPoFnAclahGROROa+7sgYWlQ70+H3OIOQlmf8Dgjd0UuOYuF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix the comment in pci_liveupdate_adopt_ari(), which claimed that ARI
Forwarding Enable is always recomputed after the preserved devices below
the bridge finish. That is not true with pci=noari, where
pci_configure_ari() leaves the bridge alone, so document that the adopted
setting persists in that case.

Reported by Sashiko.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 520c7530475c..08451452fa54 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -938,9 +938,14 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
 
 	/*
 	 * Unlike ACS, only adopt ARI while the bridge is incoming-preserved.
-	 * Once all devices below the bridge have finished, recomputing ARI
-	 * Forwarding Enable yields the same result for the same device, and
-	 * must be allowed to change if a different device is hot-plugged.
+	 * Once all devices below the bridge have finished, pci_configure_ari()
+	 * configures ARI Forwarding Enable as usual the next time a device is
+	 * added below the bridge, e.g. if a different device is hot-plugged.
+	 *
+	 * The exception is pci=noari, where pci_configure_ari() does not touch
+	 * the bridge, so the adopted ARI Forwarding Enable persists after the
+	 * preserved devices finish, even if a device without ARI is later
+	 * hot-plugged below the bridge.
 	 */
 	if (!dev->liveupdate.incoming)
 		return -EINVAL;

base-commit: fd54e32f7903199e8acb2762dd2debfffe4501c4
prerequisite-patch-id: ac616bdf67b652da754c7b00a368613d345ae384
prerequisite-patch-id: 9c324eb4a47b659efcf7c0c8bb14acfcbf5d615c
-- 
2.56.1.809.ga0b61035b5-goog


