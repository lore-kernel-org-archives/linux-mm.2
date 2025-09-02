Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0F9CA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E328E002D; Tue,  2 Sep 2025 11:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245BB8E0002; Tue,  2 Sep 2025 11:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C098E002D; Tue,  2 Sep 2025 11:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 041DB8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:47:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCA30B7761
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:16 +0000 (UTC)
X-FDA: 83844739272.17.2EACF60
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id D24E2C0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/eeCrAL";
	spf=pass (imf22.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4ni6DYQQHBDySZ7UbEZ/7lnZ6pICpjz1prMHmfQhmA=;
	b=jL71R4cs1dO2VrugRucUEdlTcV+h07F2aiAc3wWIDldYAChh6cQ0NAO/wZ7+AGFaKJ73WS
	nRGT3tfzfe08WSIxHX1PPSw6EemZ2Lyh1rdemldNxwUPiiH0jsLwSLTIKM3Ub7PuqzAYwL
	CppRd0k5xWdSQZo2sAg65/kNuLcCBcU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/eeCrAL";
	spf=pass (imf22.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828034; a=rsa-sha256;
	cv=none;
	b=VrFyqKB75+04dqH/oUReS4IvRS70Cvzef9WwbI/iJkdhiHkp4nU3iyUL+aFQ9ePSivGnZ4
	2q659RwotbwzKzmdpN/4ZB/h/lf1OZb9o6+s5DuWil1lrWT2e5nIdh+C0Oeqk91zQUw23g
	qfQ3kfsR/UpAlEgvScr3rgDAfOCIS4o=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso37673655e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828033; x=1757432833; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4ni6DYQQHBDySZ7UbEZ/7lnZ6pICpjz1prMHmfQhmA=;
        b=g/eeCrALT6A3d8svoD5m34BVaEhvCwoF1CeqVxy/X+HDBfzPS3uVRT2m6JxhP6/1Rb
         oZKq173zEQzM/KanMYYuKloBVlPUUEs2P7l14opCPtVlwpEvlcHwSD3QZQ9V+PC5crvg
         +NiDYu925YevG6ikIf3lI9izB+8HDV8/TMtMR/n051ObRTAiiQr/BI6jLidnVvgWkGXS
         AAsJEN79dEgQgZSo1U50NdVMK3yFHBhR/zqlZD+BNEaWVNJwLmaFQrUhazQZXuyn0G/t
         pUXTEzvkVe/6HhFE+1wJPMKiPIgq/ncefaAnnTXTWNl28bNb3fkpbSPJ97RKUNFGjXPR
         N2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828033; x=1757432833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4ni6DYQQHBDySZ7UbEZ/7lnZ6pICpjz1prMHmfQhmA=;
        b=aP7T/dubyb8zmYFSowt5+k9xECGLGCUuhRt4c8hF8Ry2QMbsCsmeHI6MepQNdLlMNv
         SlRhXBKJUS8v/Hui77p6/Ylwrunb6U6kcS/Ta9fR5h5RRSj+5XAgnSnRJAPyAUzA0E67
         oK4NlPLgcn/8QOa4ZD30fWm7xL4arv0UPIkAjT/S4fRM23/Fb/tzEqW0aT9F5OXGLayH
         bSECZCjPOEBts8OjaEYz4yuHnDKt6WbIqFFKWnDH7WjzXkTWBWKJLjPYMV7MOlun9ImQ
         5UEFY2LafeC92SqVIcJxVa8xnoa2yC36CQBuNL27TahJ2G0HKt3bSrikpwh5iJExgFVL
         kH2g==
X-Forwarded-Encrypted: i=1; AJvYcCVOunnvtqkFDbQ+sLNOGjDBppBvv94BJeho0m1cSmYBUi1P/OTyHk3/fyrNeVVrfQR4dSW0bH72NQ==@kvack.org
X-Gm-Message-State: AOJu0Yxl8D/N/FQaYVYnFVVWWmY1Zpd8CkYcQUvzktXuugrB/OfbUkVM
	6NizUXSM6HyaXr7U37ikQbFEcC3tzjFcoTJt51K4MGiVAtyiZBv7lCh7
X-Gm-Gg: ASbGncs3OQeqU5QVdm95yg7yiL6SyO8ucPsfJwRaIjGDW2MOBQtKlj0DIsu9XgVJZpj
	/KXq14eZToxIP/US7ABfxvV021cbON1ieX7Z862YgFmEPaOEnUHwZwah8HCoe8xwMEaoO2UI4xW
	7EuRmMGOZxZAL6TDbzXxw3uH+HDXEKWQkhcQXvxCUbWP8hxsrfE49GMdHdZbaRB8wBeyV0zdcjL
	o9DavJ16q0WtGYT5GLUjE80KfNBjB9RldMxJl8MyVFvKts9C6Wt3uMMhpov7zUs6MghWppK7786
	HYGvyrNm4IgMccPOyXNY1LEwLcyya70rTOFmICoAzCJq++IJddgOPMxCbhM7S6ekoXchnv4PeuE
	U4Y1/yoHrLI507faA6ARzJQiDL5IkbZxE8/Vqyld5QpT4i4G09st2dwcNbdLZAljrwvZROL3id5
	ZDZIWw+LBD9pNFcQ==
X-Google-Smtp-Source: AGHT+IF6uqhh0MoB6VhNHwPxlLM19ybnZxxGRDzHhQIuurCjTrk9XBgo1dEpxbne5cu5+x+vhkeceQ==
X-Received: by 2002:a05:600c:3b01:b0:45b:88c6:709d with SMTP id 5b1f17b1804b1-45b88c67339mr80656105e9.25.1756828033201;
        Tue, 02 Sep 2025 08:47:13 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e8879cesm201587945e9.12.2025.09.02.08.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:47:07 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 8/9] arm64: tegra: Hook up VPR to host1x
Date: Tue,  2 Sep 2025 17:46:28 +0200
Message-ID: <20250902154630.4032984-9-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdcthf9qogejy4sjg6rpqngjc1kpe3ry
X-Rspam-User: 
X-Rspamd-Queue-Id: D24E2C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756828034-734360
X-HE-Meta: U2FsdGVkX1/gJT3+2TXyPzMKN3DnzdK1lQ/j6snn4leg0vDKRGWR4CiYag73PejXhQmgwmPrAM+8bAPigeX0kYlni+eUTf8xTrFNBFekdvNV+0Yi8o0T/i1JNF04LB9qFP4SRKmtbQuGmCDNDtKOxorm1zKJ5PcdMq6aXWb4zjfnueP51kjn13o2ppG2fLe1PwXuRTyreTWzQXYQNucTUpWgHZyCTWZFnIR4btzBaXwL4WaQVbX+oI8d1HIZg/6Ug7QCnTs78JiyAzpiQ6zBMH2ESQsL4m0rkLwro7H45n0PxKD2Hp2bPCsd1fAKc+RTmhp8cKUpKYxcVvqPcx6oUb0Cz/VpSYdnuuoT1jjquC8zKAbBRc7eW8nWLCekbGYaW3ykrHBBPWHNyfvbo9GCK2R5GU6legLRHc9kWjHlz0DWm1h1v8fv5eWC0VZvenboH3Bgc8l+sQ1ekxXT5jY3W4hm41bvvDG14r63b/0ryuRirIXLJl2i0syR1U0o4WLYYLqNJZPdkG1GJjlISai3AstroTScVTvNymE9+7FNGwiSqxkN8mujpbAWO7CA0jXpuNlBGeI4xVH8F7HtcHycr9212MqySawIUOj1NZcPHDZtYsxiZFw32r4B2hBp6SOeKPOv4VibkB3sPwamd3ttJe1WYRnZLZh1lEps4jQHjFuW/u0rshlnJFvLV5d/ljqMVVjNq9D8hxlUkGyJKTjzJmYalTuSlwlSJ3wTF4rYl1dOUiNqojYlkqYrOBlnv43Cdg18hiDfOUvJ7bG8ECGX6aANNokE1auNf8FYd8SmxpGoHfv/Dks/ADipsaaPFr9xvXAN/Ob2YejDtqTyOlWsxsUSdhuzDaxeEOk+AgmH+qaykdJou1qKFXeqBnZZ2dAyYrRhey4nNhlukWA3hy60t5UnRjyqnQsCeWNqslmjOA32QxM6dVwVvgRbcFRPny+yDf39ID8bUdXOUyUNIRI
 9BOuKpCB
 aP/UeR54EuKEqFIBeaKtvsou8YQShGd2q2TSw6cCeQn9sN93Yyp7ca/nOQvGmLVwa9sA9bR5rANESRXcB3ZiyxqVDDDgJ9Hd4SC4xKL0ITc4BzJKi+LFfRT36XL/k5at9p4adn5/eVkSOMXccOFqh1g4OjaiM7tFQZIG+MedEz87UaTi4szST7c9drLckyL/xU5YC0CmEALgVjKQySmVCASZfAW/6si7RkHgcdgFAqBcn08s7Ljunj4ga3yW2VJyhlJ/7COEbEhmK6u9pMZ0C3v/7sCxazSHcAuJoNUQVPu1cry3lhCsGe+6fqw9S0VlwuwoGSszFKKtMO4JYphuI273B2gwUcPCzyya9jC7wWoWGlQeWYPJN7Rnk6jDaNT7wJvgGOW4Wq3KuRMnSRF1RHRPufyJLdtPQtXiJpx8tIT0P7Fu5cY7OhH2oUNTdS51vh5J6Jlfsg8JyM01GK2xU7fmqUAuC35kYPrDAscCRtmyeoN+3KDUXKeQawKPCLM3Yz1BDBt1udX2AU2NNldsXz7rJEZQZIXPm/97E0u92bYYRJ+MlXW651A5YC6CSTvSLMIsS0lhffwrW1sL6/OAKoxwgzTkfKRshJnAy2VmKLm/thtpggWaDdFljGtDGT3JQflRU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The host1x needs access to the VPR region, so make sure to reference it
via the memory-region property.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 4f8031055ad0..0b9c2e1b47d2 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -4414,6 +4414,9 @@ host1x@13e00000 {
 				    <14 &smmu_niso1 TEGRA234_SID_HOST1X_CTX6 1>,
 				    <15 &smmu_niso1 TEGRA234_SID_HOST1X_CTX7 1>;
 
+			memory-region = <&vpr>;
+			memory-region-names = "protected";
+
 			vic@15340000 {
 				compatible = "nvidia,tegra234-vic";
 				reg = <0x0 0x15340000 0x0 0x00040000>;
-- 
2.50.0


