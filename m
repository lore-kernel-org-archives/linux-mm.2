Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E9D1094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32146B00BA; Sat, 21 Mar 2026 10:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2746B00BB; Sat, 21 Mar 2026 10:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0CE6B00BC; Sat, 21 Mar 2026 10:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBD796B00BA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:21:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A36F1B8219
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:21:35 +0000 (UTC)
X-FDA: 84570283350.14.ABE70E3
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9518C180006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:21:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=IYXk0gNB;
	spf=pass (imf24.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774102893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFdEgLKBQwl/qBMdiHVw8eCe65OPPezRSACDbsiut88=;
	b=vqMHQSwHsitl0wrF3WY2zMjCdkX7n13eya6k4OAXaNJ/1cplER2460E0eL6ue93bGKa79c
	TDb7/YgNb2k8vr0tnWeNEDIZyRJpH5TYjmY4sCZbxy5v4zAnt6PxIHOB5EgDHwjIvaGa+d
	r9+AtCaM1SAxCUTg/Bc+TCsuGlLC1UY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=IYXk0gNB;
	spf=pass (imf24.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774102893; a=rsa-sha256;
	cv=none;
	b=5Ap1SFVHBAW0M27qUQPPxmLhvx3pOtSbeKGaMhZgr99+4cIBXI8iyE9zL9tDfbQSKEzRN9
	SVIszUREYbO8WXl09Lw5oqYJShUnolD4gVkCIOgLAeMolRJfR9Rl9IXmJDcnbNiYQpNZlU
	nExn4xXLA9VF2+rmjIVOj8NTsfxPYy8=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b0484a6de4so12181905ad.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 07:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774102892; x=1774707692; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFdEgLKBQwl/qBMdiHVw8eCe65OPPezRSACDbsiut88=;
        b=IYXk0gNB99bSadophVm+Q3BrCUyzJYC/enCR1CnTDXIlXXyGBV4IADcb7/yb5VhVdi
         Kr/uNLxoZf2nuFLMny33a2lHBhm3qQ9S044urGCiMdnGwRJXiCrS/83E5721iRR/0Tra
         Zy7WMZ3nFEUi10MEeWIOBvQz2g/Xw9pSc7H9xMjtpWXklvDuDchPvPLxaokM+YKTQV/7
         sCavxjuVzX5CH3IkbSlGPf7QiMIQk0l7S6oZ9t1IXmNRlOuirgGyE4bOiXNnRej8/D+U
         TaR6s9x0zWPOPHzfmK8A2nI4VcY5eCTamO1jIwdE6FCDgUj6aPwYxrHd+d4Vz7ZjdGlM
         8CqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774102892; x=1774707692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FFdEgLKBQwl/qBMdiHVw8eCe65OPPezRSACDbsiut88=;
        b=meiLSKiu4duEGdYtpgahtdp/b1f6ps88fDsPF2hViAN1oHBfjgEQSPZkcXkap5Cbb2
         ccJDy8/DyCZaZNzvkKSxq7Xv1dEhYyeKYkYlHAh5+N6se3Am9H8ZJ4svFcagP53M+xEA
         WqIaLlPBC1+WQAfluq3WIPmZYJb3zNgEZfiGgI10xhcyI9ONpNBVpsUxoU5GpymwHpnd
         lcadlQz4PuyY4CC+dNzEk9aEfpOvy+M0yaBCoGRDUhN2mDdm41Q532Mk44P2RHwQZncK
         sIm9pYE/PQobRgg3g1NEEQnF5SeYbAuahj7wXCJmCFBwTBvq+tJEMq+4bFkerucOvTrR
         glcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO7lA6S4lZAmoSV9jKNTVPf44qppoH/xCWdG1nJNJqZw+d904d3cyQeb+TicV77w1Lrva27DiLbA==@kvack.org
X-Gm-Message-State: AOJu0YyWhKLAKUjk2icQ2ugVtxHP4x3+CnsxK+ZrDV7Vtws9sHYyh9Kq
	32XcyV2tniW89yfM/gFeu4qQNc3OJiomW09hVaNii58atgDbSMA32/cp2ZQ+lFBABVI=
X-Gm-Gg: ATEYQzw14Wn14nseieDLH2wgv6ubA5pgvMQVp/EzIaBb4NHQ3dqHtuIltdotbpLrElV
	/8cOGVNEkFJ6epvFmWpOh1mTpf6BU+Ql/LyxuB++R/oEUljLce3dq8xPJjVLvnpx6cqFolS1Vd3
	tljZq8JHhGj8Tmbyk28U7qU22rkmhk2r3aCDI/dVYLM+gWpv5s+uF+/NlFefIYBxSkQeYlMDZ6V
	ofN39sAibmDqGy5fim8+khDjSSjIg0DbvDO34MM2/g8a04uKDwym/6t6dJ4LQpTFTRVJNKP65l6
	spelVVqFymHEtt+s59cNSXWwJGVXMke2k8xKWfQwwDfG8FJHJFPtEbUggYtFpLeXJ38JGy6nTl0
	QctjV3b6n+aDeUFCyW3kqByHB1cgvjUYj5bnoKqSeiHU/Fp6iuL1bUUxCn27TmzyOEb8iMqTTig
	iY
X-Received: by 2002:a17:902:eccb:b0:2b0:8106:f3ad with SMTP id d9443c01a7336-2b0827c7f52mr60674775ad.29.1774102892319;
        Sat, 21 Mar 2026 07:21:32 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083656df5sm70621765ad.44.2026.03.21.07.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:21:31 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: david@kernel.org,
	usama.arif@linux.dev,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com
Cc: r@hev.cc,
	Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	baohua@kernel.org,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Sat, 21 Mar 2026 22:21:19 +0800
Message-ID: <20260321142119.102525-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320171115.93235-1-r@hev.cc>
References: <20260320171115.93235-1-r@hev.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9518C180006
X-Stat-Signature: sr89mm7hoygg99w9u56qtd4xocu9rgus
X-Rspam-User: 
X-HE-Tag: 1774102893-298221
X-HE-Meta: U2FsdGVkX1+NkJ3hzhS/yNxuNzXuJDF6FYKoN/a/zD33DUg200tWc9njRqIxgjPHbhc5Z4Fq3wGYtTniXG4jnFTiE16yT2vfdWJnb0++++e86iWTYSTa75Z7MCgURB/a38D25+050IdF4EMe3tADyAJOW3sxgdqrpQiqApblQ0VXyIaNo05YqYqc36IGyc9seuQ/OgtmvLAMzkqSHJLxl6tRTaPONcaf8klr3sidEX1MmZlsSoctDtSi6/+sfmfghSfvFAAtS6Kaen1FoOLmUHEpCPnneCLWJpWUHiwfrVQQuymTj9BF0dYm2SVYxXfLhd6Y8oGXDVP80VWZT9R2bRfZf2HtUUJwQqllUeAtybpVo5yoc8a4qXRcdxa1f3ky2hUxdfFNnwUcRPDd60Ixc51psH0794V9MALHoEbvmVXueJ+29bceUhFV7zja/F0/HMALJEqQJxiL5lPQkiYg3c0aUHJCctTZ9wAkx39XtRrWS1b6F3+HOhc504bQXYL2wgnXCxRkh3JP1maHsNzcMhtq9NFI+ZU3Awgzv68nmXeDV3uJ2x0zgDB78sM8Isb2Wwj2Ds8kQyXpd3/I3gjbRIfT1sXT4zLCa9LdcIOYeJgtOy7p3HFpRio+afMdSlMXgW0FiWtWS6fKcpbO+ruN/RahhcqKN4V7AvRvSB2kaeIqe9VAsbez7o2AdDve9j+/skVDhE23wsJurPVpoQa+bFGb7bA+WLcktpEVSaEI+h0FFBh7zA6QoQRXKZB8kdmHMPu+zar9hVF2049IZhvBj0BQfrgfD+d/OtPNPk0L7NiIapB7WX0J9vv79ZQPt/37BUeN99k+4iBKy2S5jmro42w/McOAOVS0olzBQmxVT48mcQhzDv46T2yflkHqcKz8g1sQRupl6+0wNixqcnd9ZIGxRZMwbJK4ibB2twKR80EL35mcXc80Y3dp66BV3FxrOxKx0NodXT2YzSwRO2u
 Vuc5IqFn
 5d9eXMePSoMEWoOMfVuEtuxjjcdruMRARL8g9FEiHJr8Y5bNLAIBlk7tA6Ac1fEJ9dvqeiO4kfAw0XYztyDdBRY2gAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One clarification regarding my earlier comment about compatibility with
cont-pte.

What I meant there is that the alignment logic in my patch does work for
systems with 4K and 16K base pages, where the PMD size remains within a
practical range. In those configurations, providing PMD-level alignment
already creates the conditions needed for both THP collapse and cont-pte
coalescing.

This does not fully extend to 64K base page systems. There the PMD size
can be quite large (e.g. 512M), which exceeds the 32M cap used in my
patch, so PMD-sized alignment may not be achievable in practice.

One way to structure this could be to treat alignment in a layered manner.
My patch focuses on establishing a reliable PMD-level alignment baseline
so that THP has the opportunity to form large mappings where it is practical.
On top of that, Usama's work can further improve behavior at smaller
granularities, for example by enabling cont-pte mappings when PMD alignment
is not feasible.

 			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;

			if (p_align < PMD_SIZE && should_align_to_pmd(&cmds[i]))
				p_align = PMD_SIZE;
+			else if (p_align < CONT_PTE_SIZE && should_align_to_cont_pte(&cmds[i]))
+				p_align = CONT_PTE_SIZE;
 
 			alignment = max(alignment, p_align);
 		}
 	}

With that separation of roles, the two approaches complement each other,
and we can get the benefit of both without changing the core alignment
policy in binfmt_elf.

Thanks,
Rui

