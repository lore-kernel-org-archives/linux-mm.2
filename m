Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C10CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5318E0018; Fri,  7 Nov 2025 16:05:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F4F8E000D; Fri,  7 Nov 2025 16:05:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D498E0018; Fri,  7 Nov 2025 16:05:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 590B98E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CB4DC060C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:58 +0000 (UTC)
X-FDA: 84085043196.04.D8A65D6
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 58AA840008
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F6jv+icD;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFdqd9exB0x0hPzLUkgD+8tlEyMvj6WmHDEVMBDy3B0=;
	b=W8rcEVbAj3Z7YSL2N+Ncnqd90miTq2Trigjeou4G551oEhBNyGjCUSHP4qC5FE0EqGfOS0
	4QqgJqD+OEU7/zkVJ+QXdhlhrgYFx5qTsXu43h/zKq9Do4opCL5UyBck4C0PxorhEqJlwd
	ZeKZMrpx5Pr0v6PiAgpsHcD5n7MTiMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549556; a=rsa-sha256;
	cv=none;
	b=s9JR6bcQw4ElySGF5Ug2k/8nABbCa3OTXR85sSi98x+WxLms60m2qu3EM0mCcqG7Nll1w/
	DGjs+0lCOuXpS/IHo+5f6CawI+r+08Pw76usQaGs/vgL8xH5CjRhIaRjrG6dkUE+aYS2xF
	ocwfwODNTsfpgWIAscutVEcSLrn47GU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F6jv+icD;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-786943affbaso9584447b3.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549555; x=1763154355; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sFdqd9exB0x0hPzLUkgD+8tlEyMvj6WmHDEVMBDy3B0=;
        b=F6jv+icDHGj6Lrhbh2m8ocJl2ZGRGzHDuYcye0ivuU/ZGbhYBwiNhyEeIVLeQ1iM3D
         pIcBPaIiY5Vwc15xfZFm2Elgki3v3Kcmiu/LANJLsJm6KrHRGT+asaZbVxXV5G40IsIX
         Q0PgS/+FV9Y9ZdQAseE+RYwcqjtjElux0n1znqpmZL1vcRg/Rdh7SK0Uo//pLFW8/LyA
         W/lhbNtnQHGNC21qZ6WRV1DjHeGPHxGT7mlACibnna972MkuBBzvrGwD1whyphRrTdRh
         pz/f9Tq908ZXse2a5BUvR7Vu3Ri/OqdDqyTx7h58Ui2ni8bP0z00wCl5bHUfJI1lWYJB
         R6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549555; x=1763154355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sFdqd9exB0x0hPzLUkgD+8tlEyMvj6WmHDEVMBDy3B0=;
        b=wOq0V7m2haTznitWqLSL4jKSgqFYOlaN7P4sKLLVuYJS4rbjF2t5VMGCWRMnojwEm6
         jl5bIqNCk8AiL1WjijXxGcrMnKSNRZgE6VILNk3JH98olNGuPo/acMLqpNBUBTKgN+Wv
         TGKjKM8ivfs8eii8X4qHqq2BYbT+rRm4WgV8WZCLbKOgpQdRA+9EeQElt0q7dpck6l9J
         62RH1syC1aHEUzfjT6sILb65sp8rKgPVPU47HNmBvDgKcJt/ied70p6X0WiQM9c34yu8
         lZg/YxZE1jamBjDbJpmMMLLuKkR2MKH0at3KXjhjz+c2kOCQIOzJqAcHI60lU7H0nCOO
         CpDw==
X-Forwarded-Encrypted: i=1; AJvYcCVaNOs/z9zFrNrfgyT9Bes8zV+ZlV98SqPPl9JbJH9iGp/6KBLw+6kZkzpbaRcEaeZ9u7xMaOPvAw==@kvack.org
X-Gm-Message-State: AOJu0YwDYdvtaV+CwShiUo+aruy4UHmFFxWQfDaTRNTXPh68yJSlPD/F
	BMbvnkqaRl+41tRId6AUHlBULLR89nmO0t9YP9D7d/Vm6G8LtZrZMedirXaKZ5DaY4o=
X-Gm-Gg: ASbGnctj7+WWOOusACCTlJeoHumizCZVY3EwZ0vTjJQkxEgR2TnaEXUXsW9dWYArW/3
	AD3zXkQHAj+dC2QQLr0951A9UVrcX23ivTAW/36AyRD6k8B3Jeafwa5lQv5eknsDBREKbR/dNBK
	PJisci2kN+g3y8pvdU4j/dL6jxniYcIOrNeJw695wr9RJLmxj23zSLLwuwiKIX94cj/tO2KeZA5
	tkMlq4CX2GJcNft+AdX03uPjot7bfYmc+zQs4vq5ymNAgYAL65c6XyCt1QItIoeZOCeU+l1fdLr
	BP2lObfV2TzB1jNruhlRvlfFwmJtLK8QLeFXBSYl4HXFHn8e2xl93HL2TBDWVWtiR+j7bM8dw+T
	Wyq2hncXvwXBXeZR6oaBPHrlKazXdTG1YS88awPYzf6X28W56l/3Qe+4AfLRAP0szNgaORzyNx4
	/a1a2mmkA1p6tRn6U6UoGvNuuvIlBZHApMU3uzAkrZ+0cIuHnx6LmGiSsEiAJn++pOg9BpwbJBr
	A==
X-Google-Smtp-Source: AGHT+IF010PbDrS6Jp4mBjzKbhPzLzB8jkjc+eSVHmds1J2sDdVJ/oNxdwOHlro9GSCJe4RgFsfJuA==
X-Received: by 2002:a05:690c:c004:b0:786:4860:2226 with SMTP id 00721157ae682-787d5400978mr6003887b3.32.1762549555336;
        Fri, 07 Nov 2025 13:05:55 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:54 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 12/22] MAINTAINERS: add liveupdate entry
Date: Fri,  7 Nov 2025 16:03:10 -0500
Message-ID: <20251107210526.257742-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gn5eq65ibo57xhoaiwfd5ucm8zbmsmjb
X-Rspam-User: 
X-Rspamd-Queue-Id: 58AA840008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762549556-885392
X-HE-Meta: U2FsdGVkX1/5uRSOJUngDj0NMgUS9JZaE0TdjXEntTQGezNSf4jF5MxIycL+sb/SDhXIlLmFVwrbDTZomTNsM0LnW8XqNx61wdP29E6TFwTzBb9WIBODYOwBRgXEZryTYUIYYhYWD3qEBzWcT+HwTIYSXFnAFhn8Hfe8m9URke1TaN0hoHSbaX/mLXzQnDw1F29drTKALyKUTBZrcl1j91j0Kn/23yyxpSsdtyUTL7wT9NJ0HDXn6BsK49o19Nx8k4Bwrfllz8rZPGxf/WfBOml1D6BEhUIdXLhGc96hIbEmF++t0YGyscrnfxxGGRf2z9EkctiNbZYc3RvHsOhb6YjNzAqrWKN1j/xDZ7RCD5fdt8FI+ajDQ0cIvzvEd791ZERzuY2WfMhOEgK0cVkqmLZJ1Db8FmCKI80/4p4teErNJLvA7X27c6uTY4s2G5qjDWjaZ8E6cShB3jH2eimNCb8aShKfC47QhdhctgCNPTST/zHI1cNPn/deB7d0cRvytYlyx6PyWgpxKMEaiHx5TVrgJ3tJYANwT6vwGQiZiRN+3tLVj1hmsi+z/iWPmn7a83UPdS3RJOnI66WcJ50K7U/b2h1BkO/H6tnXeVvVC/nDAl/UiHUiMufD1mrEVMeAM7YdFRi3mGd3T+GsDSydcMkneDMGGqsTgMgp6TugMxu+/0L+nxJCPQwW0dvkPbvJjQEx2D31hCs5UcXG9P2wQPcuvli0OqP53AhGypG4P/gulU64JyPICA8ybAm1t+AXIp4+nMZKqXC9aIAkJwxnVscLLs9xpuk2TfXBc9bfJuSs2CmL1rFIumChj5iheZrpz/88G+eldgjwnXGvAuH7xU7NyZskDNt+BjH0PGXsyt3enhcvKnSVz84iCS2zBXD6N6KginX5UK/SAPKwhlebffLw2EDHmA0rg6DXc67qgx8SzZVYxQewsfZh0s6s4jgTQrO1Pms3t+BOlCxX5D7
 mXFllnqP
 zG3Y8xKFiFeY330rI4p5aU56noF2DgCoiczZuQTo7TCOZ2PIzQByoozZENrdb/NOvwnwjPK4pWFrVdwFkIUCb7ohbJ5sNraErC5I9JbRmR6PgLGbf2RAA5vQ9HuGWF4a+CVS74K0U/3lpQtaZg7EqGIoJwBMlJ1joVGaYV4QQdhcTrNPjt3pWWedmL7XzvzZAft56P6wWPHfX4P5VZCVFkEDR6A/3awKxM1TZvykhjorJOj/EKaIG1B4R92qIhCJtBiNIlGEtURcmZHNFG6KF4j2PmckW33BS+X0UY4Su5Tp3huQJMLDUATa6I/HyF3H3QxvQyArneIpZ5zVVdt4KHu3Jf/AFUTx+CC4VWHuwfzYxZBsdCrIfdAeGTxfd4356cETlrBtNrkMS8JfJEtv0B7a23cNPedn5B8gn4zHwBOjrJyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a MAINTAINERS file entry for the new Live Update Orchestrator
introduced in previous patches.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 58c7e3f678d8..11b546168fb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14512,6 +14512,17 @@ F:	samples/livepatch/
 F:	scripts/livepatch/
 F:	tools/testing/selftests/livepatch/
 
+LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/liveupdate.h
+F:	include/linux/liveupdate/
+F:	include/uapi/linux/liveupdate.h
+F:	kernel/liveupdate/
+
 LLC (802.2)
 L:	netdev@vger.kernel.org
 S:	Odd fixes
-- 
2.51.2.1041.gc1ab5b90ca-goog


