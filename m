Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42F2C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C11F6B009F; Fri,  4 Sep 2026 06:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8983A6B00A0; Fri,  4 Sep 2026 06:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787256B00A1; Fri,  4 Sep 2026 06:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 565A66B009F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E320E80649
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:37 +0000 (UTC)
X-FDA: 85175748714.12.41B3733
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18B97100005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SP5bfIG8;
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC3CPrr3PAY7P/aChmlLF9PhF6B4gfio4q7V2fdfYsc=;
	b=vPso/GP8BxGyXdTzQW41NHgLKuECdUnsxeI/a+4YntLMoDqzkOEZ6yp4scgP1HSFYokGrV
	O7PjHM1U5NhIrPHF3DeyIqWlbclmBqArJzNDVkBHBrEWfPJaok5TJ/IHc9y+aoTum/pUGJ
	CarrSTiKGpl1prE9sIYNhk1eFEgogAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518736;
	b=lcEec64Zy8I5bua5bQFIY5EzJDKYI5hiWs6+7G0L0WWnpM/Iep5CeLC4dc9Iri808mUQXU
	ieOTQAVsKVzhjEVEe4ZJQ2cnrlO6f/XLbfd+OMVemShYWgqdXrFMlF8uCmSvU4Aka9uwil
	iWZtfG6YLYGB0MDkF3k88zdN0F0YUkE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SP5bfIG8;
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AAA441AB0;
	Fri,  4 Sep 2026 10:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836DA1F00A3E;
	Fri,  4 Sep 2026 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518735;
	bh=kC3CPrr3PAY7P/aChmlLF9PhF6B4gfio4q7V2fdfYsc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SP5bfIG8u6MRQNywxnJUOh6EF6Ed7XpEvhzfAE1agnxOQUrgZenSUyYiBRrnUlZbM
	 jeabei0jiWAmeF7c3Gn9saxPOUP7pZ5iqkH7ZmyYIEpQJjpbHja2MhP5Dpj/oGo/TQ
	 Rb6q1b6xAq4lsrzhFgI/p3pwuefX/K175ft/Eztv+5FOn1sLQD23M1mmOYKhL1J0jj
	 wMDfTyZ1rBdn4BFr6lAPrAzM5Blm6BxHxXkx4Hy0m+wanRE30eEj+UBbsUUL/taWGT
	 gZBJEclpTDXns6tyVt2TiBet4agLrRtaQneYUTIzCZmGqmQL7OE/IXk0IixV1Pb34i
	 Tyhus9nqR5Cww==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:57 +0200
Subject: [PATCH v6 06/12] of: Export of_node_to_nid()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-6-79042cfa8de5@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=531; i=treding@nvidia.com;
 h=from:subject:message-id; bh=XVM1jxgviVEtDinHenIJ2Kw8sOhFectSaf+1DVtDVAo=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE6BHc3U4JQE7eU7NgsnGt5czLULWf+jkgKq
 OsJ4G0rIHSJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOgAKCRDdI6zXfz6z
 oZMoD/9xguhdwCrD8iOdtsVTh6dfItXp4r9Hbp1ZfBZm4OHIQI81YR3MZrSb2bzObPQJoXC4dRy
 ZIYhPvqOvoILsZRMwWhqyyJXQRnmIDPlqWdvNybGETu1FibVSDZxMnudxPMRKtEBRG2es5Vt///
 s7wdiWgHfZzbpnobQGL0B1q6ZLLcxoK2kkAKKKzEbMnrPameUnFH66Yi8tyqRG1XlNz6JEwt8z0
 NXNjwPRMwYMiqVSATbrGIa51QKepW1D0NeQtsAXGk/WDjMaXbdly0QpUt7RANZcBjUtNvA0Ko2N
 pe5d7gaALs7yKIUTgy/AC0WmqCkC6s2jaYTcZ+/cHl7P3+tsvIox+SfFKW5/bGSZOwAZ9hLDu4w
 d68AplnyPNl8NsOCcwDct6dphMpBzWFuOO2z44y6Ee7CJrcOMqaT8eRU3SUhQttDVB/pCVAcU3y
 rHmnZZgQwAnjDHNl+Sk8APIDNYxsv/m+KNLs2gPv2ezugy6xYbkHwnLf2j+fnaP6gTlKewgZA2Z
 4d8idRFEPqFLEYXsKG3rVDE+bywdW/uY33dz1euxG81qYT9tZKrGxRvCtWG/oQ9mWoogNlUTqvt
 OY8mocLptFLj7WMCtzyy7tPXOeq7oT4GS2flTTf+lc2cgg3pX7Rpg1QesoC5/nD7fEZFe3GyOGL
 6CeFVyhYcyTff3g==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: 6jaasay4nc8hukte4jw3813uqw9k574q
X-Rspamd-Queue-Id: 18B97100005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788518735-648762
X-HE-Meta: U2FsdGVkX1/MVdq2AnNKv3kpmN7PgvGtNSGzsEhYcFdPGVlPG/RwnGDWACy+yQF5ok7V+ZtaZAf/dB3E2yxTsVRjViwrgxW1KCVYkhi4bPaiwkRgEyvii+cmtKwAoUQsrowESRXKuiFsgD7DhFAKGjyVAlNz85HI7MB+L9GSsInB6YfkToBFa9C3mimo3P4hRiIo1nCXS4bA9pIhgpIkIAGlubEOpQqgppbsRqVMeFmDxkVddlhAjt0wLdjTX12uE65uiXQrL2RaSPa6CFh2BFqOsVgUGtT2cEa9bddBLx74Eaie57w38ySBd+9YOxdUszZEDRmKv//n0dElLgVYdAM0cU90IJ6ya5i+1HRbG8O3as+1hDNWi01Z19pvODkT6LeZjddEU9huJg5HUleDeH7/DQRV6ZoYUG2n2zgUsEwpciBYTZiAaAF/t74blEcQ5Ox4y+svES2AkMBsq4usRFta9Pj1U+IPWRvi7OpWRjzaX+gZZMOGn/8Ae2Sr6/NNxsRFXQNrnmcxUYgwTd/odpZqb/3nApIhGx106RUP5LErcXM+u/Nb7ZdBfjS1OlDDwdXPtBXyn5lcN/Q6pBQvQCh+S7KWY1qguzEzv7dvTBde1oSOZlYQ2BQ+b8GKa9RN0v3A2TjWPrcd/LV+iO5ZHtiDwR08kGHtra3DpiWyOGXcq5n2X/WFRDiyVgCEVlJE8rXOjoSNx9SIoGqC47q50WIEJsIDcQckhb8LVguUlEqDueN5e4lXwR8pkOeR9BxhbsPn9aK0GLFJGj722W2COtpP6IfAEuW8k5JOZjgmJ6N5UHp9gjPO5etlqBfw5CJB/vjjqEV6jr1yRnjMBi9c8xjE7V/43/izh9y6B2+uP7X3A1vyXgD8gO2hOkX1VAqXHepGXfdtg4BYZew5j98c3SznN2I6ZlHsnErelpFCjMQPL59euUAbBl97tIcQiMDToZHiRZ+ZOiOl0XKHIxL
 30NCyNwk
 Q68uwiy69thlVc86nFhb7AE/JpWfqlRjmcJAIrz5oDSoP/5mmrr55rYP+kuKvKPxMHkWEyKvrigzsukR3eq3ZIew4QnFt/oTh+sjpzyucl8BpHvLXz7KUnR/Oa7vH/IFNwREdYQrvskgkEts1nmqxu6hIx4N/e+mI8dXRK02kKQarvDLCpB9mluq6WQR7TvxUoXYpf8KVCIBl8kgS5rLBVuMJDSIJTb5fGmCxta7RSoxEFNtLpIOAboG/ZK/5qNB6EklBADmNeX9xaaK85Ow/We+5SUshcycil6glc+ud2uZnnR6ynD8ISSElweWLmPKz7ahr9zEL6hichbnFSQ5mJCB4dYNjj5dZzNHVWAglMbIAiaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Drivers buildable as a module may want to use this, so export it.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/of/of_numa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
index 230d5f628c1b..da2e9bd1717c 100644
--- a/drivers/of/of_numa.c
+++ b/drivers/of/of_numa.c
@@ -171,6 +171,7 @@ int of_node_to_nid(struct device_node *device)
 
 	return NUMA_NO_NODE;
 }
+EXPORT_SYMBOL(of_node_to_nid);
 
 int __init of_numa_init(void)
 {

-- 
2.55.0


