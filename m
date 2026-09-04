Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA58C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E186B00A4; Fri,  4 Sep 2026 06:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05B96B00A5; Fri,  4 Sep 2026 06:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4FE6B00A6; Fri,  4 Sep 2026 06:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9221D6B00A4
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25B4E120820
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:49 +0000 (UTC)
X-FDA: 85175749218.03.7A94C8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D842C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdrJ1ddH;
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518747;
	b=rzanltXTaWSH8RMXr8c06UWOWZpTPY0aSL4XiTMWhZ4OzIDr8K29feW9DV2Rm980UwBAy+
	/2jXtLfx3oPaKN6hRWrgGFgoTj2zUIuBd81V5y7ZUj0DhS0I/Uc5f1+yT8TbKPZylCzVax
	tW2azBWFrPVXv1IL525Wyz256YJKJdg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdrJ1ddH;
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Jc01ta292IyzRQJ7S0gkfePZTtvrNXCh0bWGk/zJv0=;
	b=mxS+iQP3WLFZhzmqTbZRUItzTC4BrI4DnkA63JhoB8CgbrF7BzxGOIaGhAVq6KJGGOr+8o
	QRB7EqAgYSy/4mM8g+o4mxwmQ4OctE4G46Vsnb0Fr1zfWYal7yoMoJAC5CcH0K0AiT6sr5
	t4l4yRMPjSGIFxbHYtGwVyQl6mYBHT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A74D741AB0;
	Fri,  4 Sep 2026 10:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04A31F00A3D;
	Fri,  4 Sep 2026 10:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518746;
	bh=3Jc01ta292IyzRQJ7S0gkfePZTtvrNXCh0bWGk/zJv0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mdrJ1ddHAZh0RBFuHKXNfw3fkqkJfmCIOGiJfKTBKm8OhvRyljaX/bBYspXvWQfAb
	 LZBgyRMCh4PrSUIsSvJcJr+0kn+kgqiozuNwWW62jfsITEaPYWqkTxPZttIYwp20qy
	 mDmGrTg3ZtGgFBwGXvX65BhBnuX2jKZ/CPBu1c7J45zFWyEyMf/oqA2RCDQnIfXuh8
	 N9RlPLyDqzPhOjtsWnOGZX4FQgQRZ2ncNLVHaRMP0tcqDuSU8v9WOSVKr2CP/ONTxl
	 kNhPuylaE7OHka7lwRhqI27ZX1m4J+yYlCfnMk9dsl7PBD3Zk3rnuQAaEUZvpLSCjj
	 /+cOz8R91wZug==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:45:01 +0200
Subject: [PATCH v6 10/12] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-10-79042cfa8de5@nvidia.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
In-Reply-To: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2272; i=treding@nvidia.com;
 h=from:subject:message-id; bh=tluD4wsCTEuKp0Tp27V1iO02LeJ7xPXs3NTBGtUc+lo=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE7Lt5Anz8aJt2DvjvvqhhLimK66QEmLFp5x
 boZgxc2ZwiJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOwAKCRDdI6zXfz6z
 oZ5hD/43CrJtfKpYLCkCb21+kPu526QvefmWAv6kxTjJ9/mrrSYYAYf25vuyeaAPXr9nyDWryjU
 zq/NsLx+qpynIFU4tV7MxGzjJMYkE6IopYEG7NT6qlIvAq0gPENEhJgSMejC6r0m7s011hz4zqd
 urzSwLnSUQ6B2wPveIp6PR8IdzXeNtQsxfcq6SfDCx3QDuJZlvL5EAxNDTKs7sBo0T2pLi9fXLZ
 gwoTvwaZUkqNZdbWET3UY8VzOIEAYg/H+4FxEy6moXbB+lgXHjUP08KaIwGq3axDOVDtnR32Vmr
 stBa9pFdA8F6T8gs22ScTlAYBVUnJcsjn0KWFfj2v5Jm/PbS6taE2EmstYVgknXM9ilQFm4lHal
 9ItIzTg+7NcvCIZsaYk0y/CgWSM4MtjblPjPTIAZFJnL/aqnNmW5Fy7l3wdUpeaAnjDsqPShQ9p
 SpDCMU0shuMtgu6a9lwAETKx0kJYj2kGnMQbDD7ncJJm/p/XE4OoEeGrS26DcbVWuuFyaeEXwM1
 UNOD8mHOzMbZRw88rmbxfGlFs7YR/XPDF7Mqg6JmDb80LQNFb/+jD2A9YjO13QZJ+xIWw/5qSbf
 Bao6LbbQfVCtnpfkyVNioEs26TBqiyVbXh0QDdpQKUCcC8yJjlw0YI1DpmOfIZTH+eV/RBXAA7n
 cR6eJAxszH9IjsQ==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5D842C0003
X-Stat-Signature: w7mu476iixgio4sj3tq5h815iu7nqqde
X-Rspam-User: 
X-HE-Tag: 1788518747-541297
X-HE-Meta: U2FsdGVkX18MtIyfMdeio0DaYp+DiLiXKLswe8CQpP2KAwjDpCk3mc1NeH5lr7jwaYxZ4dqtiz5MFJQAmw+6mRN6itdo2XFZkEj88X5K3HqmLgsTxWrv0nvccEc0xYsDXNoaWXj8a7xq4AvGCCPt73isX8T+QNhCdie3pnHUWtzyN9CUxeY6xxdOWUuKi5ZGed6DtZUttBK2Sj6S4z1v2g5mrdSGBBNcvLnkhsKMRVHJR3GhA7/T/f82QAKJdqx7YdanftF2ogNwG15wKKxEwkkvkJUR039tsZHAUXnp9/mwRhMfIgA7mXpHMs7zym/xjgNWW6MiGcVx9gUkarnT/xjhwlWa94O6PJUg1cSG+kr/3t43KxbDN6xkcGwPFcKX89kD9mMXDANiWMXe09dw+1zSQQr0Z+4mFU2B2X1d1oZiRKdkpaOkjtC8O+nkuqm8BjnOG+VGMO+DBrIr9doVoX6vV2kwfM7oOUuu/CYBgoz2FaP92OGZYLfQEI+mTegwZdllieo1bd0TfO1QKNHWJuAalXrOtP/qMS4uNZDn5GHrUhHA6Sg92v9M7NG3oXw/W29jtXp9UjbxuzINcQeT2TILAdYneIv8VSG8SOuhbBPVG8bRXcQm4fM1SD0QiC0DbbOMMBdoc9WYzCowp+6dwDociFSQVVkXpG82h4wc5VTL7hyAIJsl1lqkSeZBMU9cKzk+W2BYb7eQt8MYkdnG+jrrG//Sao7Hm6haGSMs0FWtUi8h8+2waVA9kSe9VW6i8y/ZytncaDG6iF6D41G9KVJQd7QYq7lvOvut93RxmXmTMhm623uLDp0pulHuTEFc6NURISdSmu6ZX6+/dudj4e2Dakizqls+9rzrjarDVWDVSmMyT31e++j2J/mDNocDq3fbLoXmxJg7+alh3iCxwP/XbojKVt4E8pxmucGYYHI+yOFJIIO3r7EPV2rJRbjW4NYLklTo92Xoq6TJIzy
 D098AAZe
 COyN7TEaawVuNP/tNp27Sed80lwIoJS54HyF6/gszyjBpX0IitbBhUpjPZONWNVZqDCJtrBqfqsbHwlUa75rtRXrB9IkpCDEpPQjgZ83bVTSTehJv0+sykAoGXb6TJ8FUYdtitXteXhB4dwfPsocnmtg9tgbRMjAg8BN8ohx8WB/TUPmhOZh8VioKeh841429iLtHjssbaEGn5fQZpEa3v3cxZO/genZe2VKgABjNvOWTobCKAoObH7JC+PvMBbiq50V8KvOqzuunNsLM9mwd5ghX0hVMDChU+pLkSf8lTtt5ePCvzHdiDvviPIobEaZz8peocNOgoFH3kNh2NQTDS+PWE0lhi6UNXoLU
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
Changes in v3:
- comment out fixed VPR properties, assume resizable by default
- rename node to "protected"
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 5e29316a4d75..6c4739efc8a5 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -29,6 +29,45 @@ aliases {
 		i2c8 = &dp_aux_ch3_i2c;
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		vpr: protected {
+			compatible = "nvidia,tegra-video-protection-region";
+			status = "disabled";
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
+			 * The below assumes resizable VPR by default. If the
+			 * firmwares sets up fixed VPR, it is responsible for
+			 * adding the missing "reg" property, removing any of
+			 * the unused properties, as well as adding a unit-
+			 * address matching the "reg" property.
+			 */
+
+			/* fixed VPR */
+			/*
+			reg = <0x0 0x0 0x0 0x0>;
+			no-map;
+			*/
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
2.55.0


