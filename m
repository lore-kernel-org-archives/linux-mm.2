Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A10CA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAF88E002B; Tue,  2 Sep 2025 11:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502D48E0002; Tue,  2 Sep 2025 11:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC3F8E002B; Tue,  2 Sep 2025 11:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15C1D8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:47:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA41C13A1AE
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:04 +0000 (UTC)
X-FDA: 83844738768.25.D0D730F
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id E0A37120006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mqU/+lJJ";
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqVDx7JqAPgJ8o1edyCmRNgqjh3YbvmCUsqqhz4V0Ns=;
	b=Ke3fEnFf4FfiigxMKjdkuy8LvXZ5Nnu0fnQfkP0fnszmuf90y6eq7Kzph30GRKRWTxQCxn
	DCInc3JM/ZrK2EWnGUCd7k+uABnk4OYW/QKU6NIWF0BDc0+iz5b0pP87dwPBUsBiQm90Ed
	MbiPLg59um587RYjMpWPyE7tsSoHJsE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mqU/+lJJ";
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828023; a=rsa-sha256;
	cv=none;
	b=uYsFckvxHvZ2xZnquPNJ61Jrr/9CP7cbUIR+nvdKdrrlYs/sa4CLJWbFgvz6x2FKnHL94e
	3uVJi4eG8U8nPUP0ZU/C2k4XtONSzdV5YykQ4pqUw0fhrCdM5ci/CjpVKGqveiIiZbUHJt
	rnSC/rsccrkTPLgOZ47UOM5ettfe9RM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b9853e630so8480535e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828021; x=1757432821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqVDx7JqAPgJ8o1edyCmRNgqjh3YbvmCUsqqhz4V0Ns=;
        b=mqU/+lJJXKpwza9WH6BIf7Tc2ShIuLU4IsUGgQw2fCFzyoJloycdUZlC8cTiPp8oBV
         6IaGXP0xfK0pOMJeESePSsx2TkgkqZXTJa857ggeW6ewNpY8GKIYYqoOxv43WfcaIXvS
         BpQHeuKEJoACeyQ2Ks9zvwos3UCRuOPstjS4qXQpeM7V6U0hFKmDbjz1snMm5+Ktx5Nw
         eOBWlNb3aORwoMSVkI1z1eU8T2yP+bqvVmKPYoavdy/wFuRrogmX2zA3NWb4oW0fbfli
         GRb5LLcFJurBoRVFZgUkjolQsOv+EoZfT+mRcG7tgfJUrbSvK2uhRik/h/G6EbyGqYvI
         RWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828021; x=1757432821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqVDx7JqAPgJ8o1edyCmRNgqjh3YbvmCUsqqhz4V0Ns=;
        b=h6Lzw17KxtBzXy2I9Dm3KjXi5YyzxHKkBA/KrixM/gK26L94BpRco8qRLpqYTbpPxw
         bPzxTUewDAiGFDdgOxFsdCTplePXjyO9m6WLqm2voKkTXLdZoQAB8W7eMYNx1DGfkcsL
         aY/Ac5bRWrnDrZN/HU6lcIfJuYpC2mpXPIt0RSBSdJesaCAq4q9BNHSvQqzusPWzfkM0
         Xaa9IxJ7MaEzV5kJ5ExDVYZXIWXJkJpWlli5flTqoG1RVJtGybzfqnY9bqh328Usl9RZ
         M9RJMZQs+yZHhsubIzlSj02eMv/1edccibDVtl2GpgVQjwVJLtgzhQyZTO0bLro7xJPJ
         EIxA==
X-Forwarded-Encrypted: i=1; AJvYcCUU6TEtSYGAbqUBH4xyWs1y7/9d9f1ygeDwLDRU0bbBCH8XmugkdjtOGGBamhIGmgtmtqhCOXt/9Q==@kvack.org
X-Gm-Message-State: AOJu0YyAbQ4pXZPditsQvoaCND2drPfKPC7uA2HmFWMpm/+PYx1ZmEsT
	rpNn9ur+wSZjihriRB5ejQIQDHyd/uTyGKBTl6PaVdAT9QPyi6S+rvjP3DQYZg==
X-Gm-Gg: ASbGncsfItqbNOQhd4hW43ADsuSkge65ZQq5TkpKCQQJ5srUGp5FwqbpKzqoaGPSf4A
	Y2eALXelM8FBDOXl8jip4THhC4IkuYzlhvp69wE7XJJkcAemD2XoMnCgLzCRfRFULKBOcjrt0Jr
	Ekd8VgYC8GE7+Q7xwuzY2yoQdZtAw5YtS2K+MTDnh/M8bcc+A/4/4xppuJGCEVomLLRSBSFxb3W
	W2SIEHYRNExEmq12k7DyiWW4ENspdvZc6FVsCjlxp0zRPCjNXcWevLXppnTAtDY7c6j5I18Q8Wx
	Z4KdqZ82XBLL6rnQbTFyHx/g3U1C/0cbXqhjYR+mVco1uTDFmuJ5GnXSSpHtY5+1XRigQ1YuMDc
	w4d/No1gruptKL/UChcyiryWSo1A8SQO/O1SPDviQ6sFLqxlBwbHCzgx1wdOAb2Gv44pOHs5Iyn
	9iB+CiIBOBLVsRhN31SSQpc6b/
X-Google-Smtp-Source: AGHT+IGhjQ61sFdI6+vTwemnHBbvz8ZNQ9haJ2DTjk2jvyEjnERfMyfPcIWCXNf5u0RiWSHPgdHosg==
X-Received: by 2002:a05:600c:524b:b0:45b:84f2:76ff with SMTP id 5b1f17b1804b1-45b8549c809mr99393805e9.0.1756828021297;
        Tue, 02 Sep 2025 08:47:01 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e7d2393sm202232315e9.3.2025.09.02.08.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:47:00 -0700 (PDT)
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
Subject: [PATCH 6/9] arm64: tegra: Add VPR placeholder node on Tegra234
Date: Tue,  2 Sep 2025 17:46:26 +0200
Message-ID: <20250902154630.4032984-7-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0A37120006
X-Stat-Signature: f8rgf5pgok8jap19etjhm393d3pgk7hq
X-Rspam-User: 
X-HE-Tag: 1756828022-976097
X-HE-Meta: U2FsdGVkX18wirxV0zh/OnKD4PUMY2l9NdCBFQQJcP16Wvr4vo9CRod7/obXHVPEXc0ewG43ba3TAMWrkwHim08qslQJ33Kwe2jhFGmTQX5QkviM1fLhBHHJO1xUOtZXYPOChbkRtKisS7lh/QbNFkV4DcR4ZBF3Gql+GkCqYbDM26heZAyqvng5BWJ2UDdMs/6LoynWBu/Z/0uVG2ARuOKHnNfziDmtDg06hfpG81yx6t2/FyWkaZ0TQWlQur5pICNV0KKTzSZy/mShXRs3vMSznbGkcRbIVeXgfwobNVSG8qgZ98QkW8+2H7f5b29peUGhRSYRQAgcJd4MRFAZp6TwsjefSCUpo9R4IvXbczQYACxikGwgLu9GJATsGT7f1JR02+0KVhJpW8WyvanaPU54j5Avexbh2GOcQ1p43owPSt2SQW0bwBbXmanARH83cvIopDMEBE/Q+GLl9quSEEiW/ZbJhBdmVZt3Jh9zDrBlFKKimKtLNobNQwuigdweKurMxZkKy7CrNh/AGAZ1uPxxBiIHlDbuUOvynDTV62o17gBqYm70MXsayV4Ii6qyRykKA5xub1B1j8oui+mo+BZx0NcdoQxHArdnvtU2WNXtP6VULvqn7BAD1IIwMlRhDsRl0hgU7tRWzxcXxuEhblnLtnzzcIbaGQx/a+gN/ulEAc7P+bnxqe7+/e1Jr4OYZAU3mmGu69boz8pkAgf9hfwlu3qlZY241g2WFswGRqnjzZX6i66KaElt1ehoQj8eFta0eh8djQRR254qXBNLeuFwQ5DcHGbN92Vqw64LBhfNur5CWW4gQLnIPjWQ1gjGTrzdsc+P77eEg+vLHNM8lEnidUsyH+EPOXI3QLVooJJXMw4sv0+FOIFxDMesZFHzKikd1/2p0BiNJG0+yNA/kDFbGYxxJhTZntEAPrSmYQBLgBhKALwgTNpwovdOPNtwxiQv6cSM55nk4hoDf3w
 f4adFDKv
 2XTnTpNhFNRWXT61nzJO5ilnt8pfUnxaPibFtk3jteqPtEqzHAVxJtLQDqznr76pIPIubaRdF4XCP/Wfrk53+F5dsP/fLO5ftv56xl3ZHpU8ok3wKSeUZKhMcOLogXPBimjy1p83o/q2NeHVQR+s5KJghWiiK5jmy0liQWJDZOEDI581QYhxdkkgk65mhSLYHWMhobjCDYvmrDHDoFRLbhzpcL5LA2L3HG8zWLlp5bx4MCI7fyhc8Rmp7/SUi3QXdrTP6dsn0jfAMc8XrvArjyq3OhgYYT/Ph+zk6GKPkYzDrZ93X+4zQAvthW25wu3+n0n5xW2OXVdjFrmePI0kICldx+1ZQ4PkoMWFs9CyDP1hq50AI2XoB91cJ1Jqo9H6jysOGP9K4ARaYmGKZcQB/s69s2Azxbev8DCs3IkaMgDWPxmvUGJ0Ri0AMdY0mkl0SBv+vdYX3HNZbS5NZ+shYjMTHAOpz3eXqXxqbINsdrQYpg4X0lJKPjLuLVWvdWTHvWsnOu+5HRmYHbCkR6jH90RdoaGBuCOp8BkvRI/Mrt746Bx0O92Ja51iAeB5L7UpqkVgscFQR3ixRWHBEvalH2CdljG6Gud86PRUh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

This node contains two sets of properties, one for the case where the
VPR is resizable (in which case the VPR region will be dynamically
allocated at boot time) and another case where the VPR is fixed in size
and initialized by early firmware.

The firmware running on the device is responsible for updating the node
with the real physical address for the fixed VPR case and remove the
properties needed only for resizable VPR. Similarly, if the VPR is
resizable, the firmware should remove the "reg" property since it is no
longer needed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 34 ++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index df034dbb8285..4d572f5fa0b1 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -28,6 +28,40 @@ aliases {
 		i2c8 = &dp_aux_ch3_i2c;
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		vpr: video-protection-region@0 {
+			compatible = "nvidia,tegra-video-protection-region";
+			status = "disabled";
+			no-map;
+
+			/*
+			 * Two variants exist for this. For fixed VPR, the
+			 * firmware is supposed to update the "reg" property
+			 * with the fixed memory region configured as VPR.
+			 *
+			 * For resizable VPR we don't care about the exact
+			 * address and instead want a reserved region to be
+			 * allocated with a certain size and alignment at
+			 * boot time.
+			 *
+			 * The firmware is responsible for removing the
+			 * unused set of properties.
+			 */
+
+			/* fixed VPR */
+			reg = <0x0 0x0 0x0 0x0>;
+
+			/* resizable VPR */
+			size = <0x0 0x70000000>;
+			alignment = <0x0 0x100000>;
+			reusable;
+		};
+	};
+
 	bus@0 {
 		compatible = "simple-bus";
 
-- 
2.50.0


