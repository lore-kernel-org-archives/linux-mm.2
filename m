Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB8FEB106D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAAB6B00AD; Tue, 10 Mar 2026 11:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2976B00AF; Tue, 10 Mar 2026 11:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEFC6B00B1; Tue, 10 Mar 2026 11:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF986B00AD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:19:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DA1F1C1B9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:19:00 +0000 (UTC)
X-FDA: 84530511240.21.4B3FE23
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 56B2E4000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:18:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RpCAhSo9;
	spf=pass (imf27.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773155938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dF0egp0NMjHto7AOlBLmoDYpDU8LRY2oTuHXLlJABsE=;
	b=xzeIVUNP6yA6dWEmPuovAg/fG3pCthlZmpzix1Yl90/uHbnI4Hiobijnr8+9f6ktYAL99Q
	TwOS97OyxPj1UprE2Bj1Z/hsz+T0g3zqXqd3foPEa2QCmLA1zfbgG3HMrdUkXmy4mbd1r/
	PCwSVgCLHtXYNbmazdsxmpdl4IC7pA4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RpCAhSo9;
	spf=pass (imf27.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773155938; a=rsa-sha256;
	cv=none;
	b=MBiP12kzASGPFQSWhBfqgs1NYj0b48o+Q0pQzBQ6P9Uo9MGXZcRWt3pO6YPuMMqNxgoFyN
	4M0cy3cty948cLzHfBcBJp+yGJTyu4f5Jp6b6ppYouoMu1LNf2J8nZsLtlJ5u2UKecNkNo
	3Ll+VaMoJFHjRhMhiD+T9FAWBg5O83k=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-829781b2b01so4120940b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773155937; x=1773760737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dF0egp0NMjHto7AOlBLmoDYpDU8LRY2oTuHXLlJABsE=;
        b=RpCAhSo9fU/gWJlkj8Rqb6KxS00PVeN2hYFpee25++853DHFV3Nr7OXIRwGltsvAgM
         lXvr/5uzBQWD+LlZipdfei4JLxY+CsvKffwC1+VTi6uU+1sVRPG/W25lG6Rsdr/Yt8rN
         CHSql1YL4iD1g3EB6Ftog7wApqU7PeRfg/I4pH94OAw6uaMiDXMu8DfVT0DTRtglY8sN
         tjD2yo+iUAMEMrWjyUl1ggf1yAUZK6mqlFY/U9mEB745GwaId7vdJiLAirTsVsXZGJoS
         ilWJqn0JaK9xN0W3hmute1608Pm75VoRKFAvUDEmVMsJnLTEt5W43avioK9tlZ73qI9O
         +sew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773155937; x=1773760737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dF0egp0NMjHto7AOlBLmoDYpDU8LRY2oTuHXLlJABsE=;
        b=sX6MhBYR/Kw9sjCBY2FM0pYf/sh/ea5HFD6XBERTrjt1YBBy0glBgzsfWrdedQfLza
         RBzCjOU2JxZj2V1owODRAlb+OAwSNuf+yjPB1zlVQJFe1toh1dGYrIE4ZsNyayxMFzzE
         9t8raDkx1TwA/GiwBGAMI9JOyvKAc9beI2F0G3BRyeqIEgRMe/q/VpJUp+CRJ64BxytV
         NHIfkqEhBEIH/heyYxCHeXMDdffiRv7k/Ig66bCp/DqBFZ2nscJ1AP2ykW0IjnRTAj17
         SGbprj2Ez+xwg3QSBF31dnP2U5DXBM78yujpXcNV+IqUo9U4+aaouVtV/9+BsoRr0rim
         UEoA==
X-Gm-Message-State: AOJu0YwAIe7c8TW06A5kQoa/4Iqr5zU0hpgVGLbc6SnnghHgGcnKM1pU
	BIokVPgCH6dCJCla6VktCpT8YlIsWIyH7TGjhG28NF2mvxb6n0GQfgGslyAASA==
X-Gm-Gg: ATEYQzxrH2W0L2g8/h6UHzlcPfj6d1D+GUpFQnd4R2uMcPWddURpMz2eOEjtQ746XVs
	18aLNbBOfuaDbI256yK7AZMB//PWWKsOZlNRbE0L5e8Ut3/u6vf+7bgCmhy35QE8H73Lryl9Qhw
	/fuULFVNzKB+wXF5xRxvGl/yJOKp4SkVvgi+SXqZLTbwbE4162VkpG3YA5fFGN1d1LJb9r5hRbZ
	f1CGH5i1AJthx7ke9G5HSZ88MTmdGEPEDS7HfGRqhvSbzersD2d69EYFAVtwzDSypeXw2qPb73g
	WZGkxyQJFhr7f/cDhsvcFOWLZTe5+/Au8yJpXi8Rbaf4fCJypTt3Q0CKLsZQTigZg25KWVGRTnc
	6wE/EAuvUMVMe+4vjyEN1FsCf9n1dpz5PPyxbDqw0LoliB2xvonHRBb1335v5OQLYNr5JSd+M63
	cFf7cHdrttTXzp7l9fTKdNXox2cQj6o241Qq5exg==
X-Received: by 2002:a05:6a00:2d89:b0:827:28ba:ff00 with SMTP id d2e1a72fcca58-829a2dbc7e3mr13800245b3a.18.1773155936776;
        Tue, 10 Mar 2026 08:18:56 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:42d1:111d:2b5b:9957])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48a20c0sm17011548b3a.43.2026.03.10.08.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:18:56 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] docs: mm: fix typo in numa_memory_policy.rst
Date: Wed, 11 Mar 2026 00:18:37 +0900
Message-ID: <20260310151837.5888-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56B2E4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: st1nf8jhp7ga6ai3y6zbaz6nxim4dczy
X-Rspam-User: 
X-HE-Tag: 1773155938-394612
X-HE-Meta: U2FsdGVkX1/7D7kZayzu2j6XFtGEwHGEDkR3Mr4yYFUmfri4aOZVvecw6STRoKiMLUv8wRraAz8X3EGANiu+CeZ5FBw61Lj7tNNes6vU5JPVu99lSsaAFP5FziOLSah76wI7u/Fe10jZB4j7nc2ZkU09um1WmmV3OQSQKGk4UtF8ko4ML34nIBM1apYcN9/6uyOdXit8bp9QxTLIb8RFbmbVqgxDn7mPtEt1gm8Mma2bmMcqO17d85ygKkHbf+LmiFa5QtrOl+UoF0su7u0+F6QVVPa+jvFoO9cMAu2pk0osnOxNmDiRdJqk/pZgvJQgYW2O0xQe+yZQQX1pyWiHwfyZQKWakwOwZw09o7Z7CS4Unt2YUsA6sJaX40dG8ZhdIOtjPrq67wFuWzRNTRnajCtuRGkyQ8fWkemirLFTDzE01XWbOiQLK6AdNGwuTogmXzBZO5q35epr5c2uu2piMhJFVoz0j8KChnIPr74WkmFyiePNsWQ6DSF5QWV5zwHPpxxNc7/+U5ga0WB7Y9xrHBu/lD1iDTk3VHX/i2Kwdp4TP1ltYfnk/cG7RiiBpjKuIXAlzTtXnxGUeAn2l+LzhIcuT+zPS+2IKQwpjFfhAg0ICNaMGwjCXa8eEBOkHmPlonWiHS+kJLzytCdGmXGoqxTofs1AZxfLy1P0/GWSVIl//2EO2elQQILe10WdTcoMnzK4Lo4xxWd/NhMs0yQNCN0AH8JOa7ygCjSeHf9RxL012hTU+29dT4RWHphCtY94+tnQg62MOMSLQjuXu2bUccOBqp1d2ciHlxsaBFN28dktbqsEz5NPGTi00ZAPt/f5eI4xxMhbtLhNywm6/L4H9nlBq0cAnGCyMg0BPaxElsUuS080519o/1AskQFnxbGSePbj9Whvla4Uo8A9CelvMsrYEKxZyG/NzBQhvA1mCzv5zQK+6obABGyA9Vz4gOrXHoDRIPukhxl4n47HdCt
 9OIZ9xeO
 CsZn5ZaIX5aWul937cD9BUJU0unNOXGaPcDpzeeK/EVIXjaLjHuyrNMUWSWLEYw+mXGepMOzkYrYQzqotpc2HF4YDHlQ94AYbxvHBF347N9xoeS6rPhMTtZp5B1htPxPPlVZsO2RFBoYFgjXPMmbXjS2jUaDpW71e8lTdDw1OXoOj/SvMsg1koOiW2rS4XV81muQcFJax9l3nJ+TMQLRnjzF4msfhNdFfJOgF16h0EXegpYTF2fmQ5Q556iuRdvZt/WfZYioIpISAcauHysZgBBNSa6Ixwl3V+6rbgudo+uoyenzfTwwOUXc8NEWGFLfDrcbUgI+YUvYNK7Q+eQaz8edtFO1e9zsxCzzqEOfvbkbColWNShrn9bZhWD/yKBkzxYcwG9AZQ/uKQC+W98HXN7/6y0iQ9M6L4zsyaI37QYGWpkK8vW4Ikn3fX6tKxr5FKG+B2kxb7J633ctQ9sZIfLsDtyniTJwqJabZvVYNGEQXrrlZ0Dd7FeMJzl/RmFQnrP7mYc4oaFuJSsD4nVGkZEwXNMO+7Y4nnKNb02DfggisthXH+tGPES1WZd/EdK+/jW1z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a typo: MPOL_INTERLEAVED -> MPOL_INTERLEAVE.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 Documentation/admin-guide/mm/numa_memory_policy.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
index a70f20ce1ffb..90ab26e805a9 100644
--- a/Documentation/admin-guide/mm/numa_memory_policy.rst
+++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -217,7 +217,7 @@ MPOL_PREFERRED
 	the MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags
 	described below.
 
-MPOL_INTERLEAVED
+MPOL_INTERLEAVE
 	This mode specifies that page allocations be interleaved, on a
 	page granularity, across the nodes specified in the policy.
 	This mode also behaves slightly differently, based on the
-- 
2.43.0


