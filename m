Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E39CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23C18E0020; Wed, 22 Oct 2025 21:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB6D8E001D; Wed, 22 Oct 2025 21:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B116D8E0020; Wed, 22 Oct 2025 21:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A09D98E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:29:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65A5F1609E8
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:29:39 +0000 (UTC)
X-FDA: 84027646878.19.BF7A057
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 874AB20004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:29:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LmQfe4Vf;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4RIiEQbuKSxiwjeneYaNeE7brucAMNW0pT9fdMXWYs=;
	b=Yj1NXfBgbIR7gup9Oe6I7/bo4aKjyPZBKWReczthFyBbdmDA9/lcGcussny12rVs6HmHKR
	n+Gb7yZ4aai9ivXFuGbj4jpySiuDZoyKZ0jlCAELllePsaXn0P+w2sY2PnzkxBH3P1iTh6
	iLYGO4iR1ekLDATa027J98iGHnzfkbc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LmQfe4Vf;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182977; a=rsa-sha256;
	cv=none;
	b=eCfS4Xeb6kZsJqk0TKILvfC8A1foc7piJkOznA6hEBIn0AhL31brOov4f4Tc/QD3V6wEEB
	5MQel61u3nL6ZDIVbbUHDaLx1FgiuWJsvpNAb8A7DevZx/WCgdNenEsqzDGOGcQkYDce7M
	tBb1J+08Qie9xIYN1hJkcsJMa2fItHk=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7833765433cso364106b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761182976; x=1761787776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4RIiEQbuKSxiwjeneYaNeE7brucAMNW0pT9fdMXWYs=;
        b=LmQfe4VfmDLIzj486pidiIXnjiMSZppe8iwnOTuzVA/Ud+H0ZzMqee3QftzzBnMYXZ
         r0z01sP5Lk7SgSvPiX7ia4CXb3Mr1p3FHqKkFTe0pPwfN/7tzeWB701ntGtjTd7nyVUI
         +V3KfgCQZYhcIIOiV4sBCxzmK26WyVPeLUwgVjjsCYs5Z66rvIM8vHkoDGHtmj1BhI4q
         dda17rD/npaCQ9poltCJvzHX40HlQjGSiHfOWxIpsaGeavbl7xSd9HL0iEbiDP8NwTTg
         9Fu0Fo77Me12xNU8QQVVRsoQW8/Lc/lBv5QreOTrLuI5+OZnjQQzT/ieaFT/sFxV1L8J
         aquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761182976; x=1761787776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4RIiEQbuKSxiwjeneYaNeE7brucAMNW0pT9fdMXWYs=;
        b=t/RcPVMEMDxAwqftWPGxAB79LDPXZ7r4P+lAyN5XdMkGS9shum8Ej/H3nbvuvYAw0/
         I/oOEiAZw+nEEQFNVKqpJoEumigM6iAPQ0czdrhxWpDsPkA+6QK/eOY9wy5SivsRnm5v
         EjSxZpBHE3krgx2ASjEjUToaqIxtHCSyndMReTVspDaCBOs/hEuc2WDHWr8lwQlu7Hxf
         h/We97opyqRHkr0SGYpwuV1EnzcYK2l1Ni4UDaX9UCoZlAlhkewVsw4ugX96+Iqw5v5E
         TTWvwnWtSiuKUjykdEXtr1lXukseObtFwvtjd9qAoqW012q6GUHD/HuD46rl816IG+Jd
         /CHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVAxnnF0YE/UHgTTZVrq2nU1juFZkUZ2++ueij0QzBCiykSJlx8+GU2DJ8vyCwidEK+zcrStCx3A==@kvack.org
X-Gm-Message-State: AOJu0YwMhxO8qM/vItZmtVHFozw5UsCkXrTaGO2cdB+n+Xs4BsMuFF57
	vca+6y6G9hYpG8tycmBUoFLyDPlAJnC/MmQJtlXOxIBbP1UVEH9mzZiX
X-Gm-Gg: ASbGncvSlLXEfaNmGDdz9vjvD5HliRfFt8vatlKd25qvzmMWsuvvab4VNxlgC+YY3Mg
	VFCRmZFfGmTinKFPmCou4DlYr2bxFdbMP0gOQNSvB/cswBpO+vYyWDCv1uIn9+JxAiA4Aec9Mep
	f6gf6yjYAZAfgL+WcZtvIKaiADbd62ONCf5xxP/uZx3ALMKzvx7y3gCNyeaLrV2IbWG6W6I5URi
	kmwSYiNX33lD+HeLl3YfHZwCSVi3UK7kzzqxfTA8kv+gS640B0x/S0oEYiYFGmpkO+SgpxlPQS1
	kG1kghAv3GQSlJVkb0W/VCXHbtGomaO2GQHV3imdQP4zlkGkmTqaLm+ZpG81YYJegRfZO7sqF03
	hwFE2kw3S/P+WHXCagN6dlxJjysZeupHLh3i9uZcU3wC9JrIMpfxUA3jppRGegIwpspUxp7lQvS
	0nVCUTv5o1aIWqT1gLmUyCEpa2Vfqbtywmb9RBJvh+EX/Gm+3qfA==
X-Google-Smtp-Source: AGHT+IHVMR51lOF6X4jmIHDgdKsD6hguBJeZJYSWPOrAlhszymF6v64FcenSCMnCR/bRDw8+ZFYqNQ==
X-Received: by 2002:a05:6a00:84a:b0:78c:985b:8d3b with SMTP id d2e1a72fcca58-7a220b29d75mr23211144b3a.23.1761182976363;
        Wed, 22 Oct 2025 18:29:36 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1af1:e76d:71f3:4e0f:3054:cd47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274bb22f6sm613128b3a.56.2025.10.22.18.29.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 18:29:35 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [Patch v3 3/4] mm/huge_memory: optimize and simplify folio stat update after split
Date: Thu, 23 Oct 2025 09:29:21 +0800
Message-ID: <20251023012922.15460-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021212142.25766-4-richard.weiyang@gmail.com>
References: <20251021212142.25766-4-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 874AB20004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sycsfaot5njyngx3must1xznkz6tyqni
X-HE-Tag: 1761182977-144357
X-HE-Meta: U2FsdGVkX1+BuPdCQutCvFntWnjToPxEiNVKpm2bBGfqwv1hkkWo6JTpJpSC1KbTOdTQDS2QESTF+ZrurqReKk+jvlgkXJL/b5vFWEdGwtx0eFvf2rk8Tms3AnbrM2UQWKF9FoAwjPW8C/pNwBL+J7TULOMGysbtSbvqYxPB/Rded48t8nkmrj0voHgGLheGaP9+1C4SUfO+wVyUJfQk3Z99uMTXpL/xHRVX5CLFZeXQKswZ+wEM0uIDfRagqGiL9Loj7D7Itcb+NcqSEzTo4BCCftb7e+LE/6W0eULKX5jRJshbSYcTCQLImititvGc1fM6eXb6IyMqv6EBZ3VT7HhotgrsO96Nw7N09ZXYXj6FAMk+iKj3P3lotzgblSZLUW+83cgSTn1EYspgx6b2Cc5z7hGUM/zrRiT4zwakBplmerm+dzz0avSzqHpkj5vy64kn9E1l+RmSGhtH14uXnv3IcAsJyKVVuNBOyErfRDaO2B771N1J4/8ZQ41ImrKEGgitgwLhTd1Uw7oAkjmC7VNyRv2N1LsPxOHRSPwvvqA2JgZW29ZHZ0IzJ13nAPCxK6SyiQ5JX1UjlruwZ3+U3HFGos7yrgV902L3WZrXIihLTyhv1iNU57VvtTBDOlgFOEwX1zWYjf86JgjAwanPn+EtJMoV/EAHi2oOVuUJMSdcPPpEqTSoPDtKIweVXGWZ/TT1RPpHWfEJ5sVe686tEBW8AjfzoWYILKjkRFOigFm8qAaw89PEBULFw4aDbBVFtyoLRUhgNu/jvL0vC1DNApDIplhOWK1hCtq2vOFzK9W3UtFPeQfUN6dyvFr//0EVEncxi6JstMRAtmXEE+f+I5k5jI/wrxD2LJz1Ju3q/QBG/H9mW963C94m3+7CJI73r5mPEufdpZMHc2RFiQPJxHH7rtd+IGDpDjj1rwXv763c7TgM8DE1nLm69eXi59H38NmdHQuSHKkYN8fdgLr
 44Msa3Ln
 /Hpc7OCZhu3sfu6cFlk0Olp+LDsqWLZ5Qu6PZTHYvLjE/AWooz0fOA2HnXiXmomJmfENDJ7KLOJne5V2VWhXQmucIbPV3OQb9yEwOq7VLgptIlz6quyDOGWTkL5GrE0ZLVa5yTB+NEDo6YwbNSJYhLH4cUkrz17SZP26kQur13uICoicCNPE1r1dVfRS7F0X7JIgQTqPkSLX/HXeCpp1LUegTkZKPF2CqNUtNSPnFzaeoTGPIpdk+SqDk4DpNw/pE4fOAxQaESBy5tpX5GlBnpP4lCZotuDkptWYAr15V3agDJNBhIG+hjOc3ePYARVBtmHOPKOPER2mmMq3kCWxZPteradwgltCTH02dKtcgP1kRqEnbMmNjcJeMM/39774vr7aoFmmk0AJnMi2A70GZr/vk5zL2t765LvoKJES5xP5JxWlyKB/sAPOJjfQ83gze9oKYxmuh8EznrFqbCc9gj9ZfZ0ZwuRdzxuk7zLbmEmAlyMKIhUO1oPyWS9eyLwe/qdfdpy0IHkJD7YATNidIFL/BVDhHKGt3y8asC+cW5Ci3zioFrH7rpLeYaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The loop executed after a successful folio split currently has two
> combined responsibilities:

>  * updating statistics for the new folios
>  * determining the folio for the next split iteration.

> This commit refactors the logic to directly calculate and update folio
> statistics, eliminating the need for the iteration step.

> We can do this because all necessary information is already available:

> * All resulting new folios have the same order, which is @split_order.
>  * The exact number of new folios can be calculated directly using
>    @old_order and @split_order.
>  * The folio for the subsequent split is simply the one containing
>    @split_at.

> By leveraging this knowledge, we can achieve the stat update more
> cleanly and efficiently without the looping logic.

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
---

LGTM.

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

