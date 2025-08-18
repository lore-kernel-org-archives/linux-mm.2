Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A60BCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3723F8E0008; Mon, 18 Aug 2025 01:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322988E0001; Mon, 18 Aug 2025 01:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAC88E0008; Mon, 18 Aug 2025 01:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043128E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:55:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B49D1407AE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:54 +0000 (UTC)
X-FDA: 83788817028.10.A9E5106
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9732F140004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YDeis1hq;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFHLpr6FcX/Wx3J31OLqW186GX8K2s1j2kcuC3aNVeM=;
	b=ef9KH8xYL93exvcxsS2HnHoBBj1GWN1hJrISk9W+hhuRY9NerTKEW/VaSM7iDVZ5I8zcRw
	FcLiY3avUBfxfJp9T8S2W138HktHA9PvIwsrRry6fbdPj7X+2ljMoETJuPUmPW70dE7n1u
	22rbAVemB0aI5rqu7ekcbmC1Ezsih7g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YDeis1hq;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496552; a=rsa-sha256;
	cv=none;
	b=GFxCnhWS/gs5HcEHYlq97mJew9xgJK0dfDGa8A4bSGGSGrxG06rFAuOW/uSMzT8Tbu9ld9
	312TjqGV7waBPqPJY988D6Bo7C063FdeiEL73YKMtS/gWWPOxpvE/18rP+/UaQPZJzQ06g
	TN+jU07nQDVc3ZLxaDXQ7Pcc2EFpr5k=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32326e202e0so2886250a91.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755496551; x=1756101351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFHLpr6FcX/Wx3J31OLqW186GX8K2s1j2kcuC3aNVeM=;
        b=YDeis1hqe794K5OPYNu0T6tlMsc9gL/EcjY4bV0ujb7l6/Yh1nyWpb0v9OEGwztuXn
         NeZkvg75IT5ZpyX6VKl9x31iL7evi3s0pvW0hoBNaZu/xDFyl4L8ViKb2tEe1onkokpm
         km5wqINVWIseORvYKK9sEILEIj0vPRgOhbCEvAIe4vRGNdY5pKYJa0Zf1O4yEw5+MUqb
         Fr4atSEp+dwv4153rqzCGeeqNytNOv3/4YB0Ye4rkN1mwfXzwhVcA7JwoJWRIS7Dzaak
         0G0yFlSlKBZIIg304OPx2VY9zQG30iX6+3Wx80rPRMoXRg9SKQiUuYmS4XisZRAkOAVv
         qocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755496551; x=1756101351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hFHLpr6FcX/Wx3J31OLqW186GX8K2s1j2kcuC3aNVeM=;
        b=EhC2kG6lcBmy+YSxLrPfFtMxtMOJmi2OETwIfbJcb8wS8eTudSE6Vg9ZzNkInk5qjt
         rNFP4tCI3AvWVZg6gdEVnlI/1W69/ff1l5KwmXt8duPSgJLrf94e9aTh8zaeSc2ArW/g
         PYIr3Rngx2sYBcmJg6k1z8wWM8wl09GNvDDz8t3jbrogmphzPfIup189xJis7lpc3mnU
         ZFBm3nNWFoPMHfhj/Pxs4q6gG73//DJzdxPgPnCmm+kZvIIQf6MaiVhP38sVAeCjhRK6
         OIO2Rf1VpisR+44fxF7kWLLvKFDvyVwRqckovwAiPsnhEaqYdAI6sm/1SbKd+mVB0ZJZ
         p/KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUICBytcdW7DsDbTtuIMnqV5i7zDdKM2lC86cokJQ+BlIwICKhPJH2/OiPD5DlApMeXwOiVETvs0Q==@kvack.org
X-Gm-Message-State: AOJu0Ywr1CEBzsce4ovWjVwTSxXo5QrM+SV4A4qIHyve+VRH7EYsX9SC
	p8IV/ja8hBi29I2EyCGFhQ+r1EJQmacVeswEgql5wQiqXoeoOSgq7uK5
X-Gm-Gg: ASbGnctA0+gsj8uWWRLmFJNBhwn5MgyatEGEC+AjaI/qLYxfub2eN5Dgy2SCuwzLR/1
	X/f05dsMLWIIx05P5PpkMNQ125VOO/TOfxZ8XHCOINB11wBXKTcNi/k661o1lCYRJYT9+BBnXnp
	nedhm2W/2K0hAwfYt7QkOoENN/mO7uRNd+kLfoU0pEpMpc7WKt/EZZmBr+PIeZ3zYy9w8AZBnNw
	XJoWY90zzyJzD6W2hzoEXgG7Gg8Pl/rTbYl4p/9KVxVY8c/eWMcPG7hLqlUd+C1o1KT/6WpRn3S
	2OeE38Ny12Vrfl1UNnlqG+gMXbr6ftIgllrbqEkidm+Y9dHTlUX/H1Ihka+dbJPgzAjID/ou8aL
	dxccs1wMItPPys6IbI8WityLVhEKPYxmfS1KyzQXy4+teaQ==
X-Google-Smtp-Source: AGHT+IEJCPBS5iRXP4XM57Mk2ebvHxoxGY6WLtHS3LPJQ+Lh6u7Flwa0rSsbi14YcW+iQnoFzlmjLQ==
X-Received: by 2002:a17:90b:4d0b:b0:321:b7ed:75f2 with SMTP id 98e67ed59e1d1-3234dc62038mr8862243a91.32.1755496551296;
        Sun, 17 Aug 2025 22:55:51 -0700 (PDT)
Received: from localhost.localdomain ([39.144.105.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323439961c9sm7003413a91.13.2025.08.17.22.55.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 Aug 2025 22:55:50 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v5 mm-new 4/5] bpf: mark vma->vm_mm as trusted
Date: Mon, 18 Aug 2025 13:55:09 +0800
Message-Id: <20250818055510.968-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250818055510.968-1-laoar.shao@gmail.com>
References: <20250818055510.968-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9732F140004
X-Stat-Signature: q6ca5dpuor15kqthfjine8wo9zeq3x5b
X-Rspam-User: 
X-HE-Tag: 1755496552-48854
X-HE-Meta: U2FsdGVkX1+zX4a80/7zmEUCJNEDL3ImVwPJa4GylFqYt4OCjyrlFY03MYHLkvzNanGbJ8I0CvJJc8wTe1Y5AG/MRDMx9E7zF4C4MXzoeg1AHFOJZnZOARUh65mWk6KffflvbyNkGrlirL+1P729Dv0+C2R6roNeivVD8ZiRGV91ZOshSe2ZS8eDZFoj81sFUrShq4XmrUDn6sjnEgyKKa3U7XMg+RIgfJOAtsdVG0ttkcg8siqQV3j2kurqUxdgBbdOXaWwL2r0mOuWALyXc57vxBot2xPcQ30m7/OY8H6DJHBekCZjtX2IKN1JThCPsXRIdBq1ee2cfW+Oxov5XCLOC5jKJsjhoe9q4UJusrJpxBpEj/qlIKMP0/EsNaDGueuyd2IQv9V8MDDvwSEbd2Xtb0tPQAjOHAtgo/180c7H9gDxFiRbG0NFxm8rCsokkT0UDd7HDPlnHRgVZw+0JWf5YoDC55zHMhK8NSe1b+ascuNzCz2ednCAM76lyxCbNVxblBoEzsB+3DB4fxaRjXOEqAcs7FmFU67hZ3DygTawX+ZuREGxD4hZ9wrDOOy/cJVsnTctJPIYkWQpoMpDSIrKd+kQ12SFBjWqQBTSm7txRBDehWTXjyaT5lejdWnbhsjA7QYHt79kcngBDLwueV1vsicKy4fZeRmoGBqS29wnnM8xNZi68uQfInACMs2Z/3/acAwkfbGXBTQqhfxfg9zKA2nKt3SYRzQrXpRhf+KpvLKA/iWUPbYwp9UrikPvfeqNJvpdBubjciJ1/Z9e6Vh9iR+lHOTegHhW8XlmL/cgwbtZFnxpXf2VI2Pof5fukeOFE5++kWn2gn2nxdQdVHw4ePbfAM4vJsLapYTMmWtpaf5/8k7lDj7Q/SknhmmKGgPMWDRqRQyhP69gv4loQvv/dLJiapEz9XrTQ01RpqLbYiFzOwDMWDbU102Qu9h6uBjymFAqCrdfELrYygG
 Kq7OB1Wk
 hEDMdn/ZIPCsygw9WCYT6SbqDm2O/Q0dX5DdttmlOMDsQ7U9ddPvEcW4HHwmFJCgi3HMBpSrHzk9RwZEIcXrm+t2POYmpTwfJejRBYWoI95AETJAlYJbPW31efY/PDnlo5GmnJ7Rg3lOAk8lM3WUhKyXD1bQqHmQ4M9cKOBQnBw/fcp2w1wHYuJApTKc5o/bpU0+0usbBoZSChAprG3QQHdDg5nrIY/ml4LlqFge70grhx7H3wJuB4AFvUimx8vtNmfsF/WmIVvAqNvK24xDb0gYwJgoUZvNsGSFCnthAujkTJcPAzbhzNzlVXO29T48rsfETe7rUDqQAPsYchgGxcQlR2zwiMIPm0SpKvZxJJKXHP20eO+hDl1Jf+Lk/erGjsh6jYAYS17xbeUsP9Wz5HIgDeupTcttAuAyUgEn1DfYeTEQNN0COSB/Gov30CsLFAdEqeBjwbAf5yqA+EM6rv5rmTDGKP0kKiZqXJGauvLfIZA5QL8/G8tdNY2CcmH9phogClxxDoGaiEST/1eBO2Yfxq/DaN9urrb8kINU+8fAsEUwU65uVp5vf4IqDP67Lfr0veVqMPib9Xvzqa8v29Ruiig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every VMA must have an associated mm_struct, and it is safe to access
outside of RCU. Thus, we can mark it as trusted. With this change, BPF
helpers can safely access vma->vm_mm to retrieve the associated task
from the VMA.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4f69a9e9af6..984ffbca5cbe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7154,6 +7154,10 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
 	struct inode *f_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED(struct vm_area_struct) {
+	struct mm_struct *vm_mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
@@ -7193,6 +7197,7 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct file));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_trusted");
 }
-- 
2.47.3


