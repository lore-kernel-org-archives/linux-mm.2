Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CE7CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B5B6B0088; Mon,  4 May 2026 03:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472A86B008A; Mon,  4 May 2026 03:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6A06B008C; Mon,  4 May 2026 03:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30B9F6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:02:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA98BA027B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:02:16 +0000 (UTC)
X-FDA: 84728843472.17.89FBEFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A2F8180006
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:02:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaLhgUAo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777878135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLpJ5f+a4wMEBWCfEL3kr5VDnmwptVmJoRoK6QRwUjY=;
	b=ZkAn+8aR3kVR0epavVAkjxb/B5QPnTId1gGVKuBBYk0NWFEO8LnPxOH2gZE6xYTqr11+8S
	8K+dbVBSA7GZx0pCHok77F8zLM1SZjU4mMJn4aRZlb4ICixXGtBFogLsH4osm8r9yY/grG
	3Yotx7eFLlrVnP9P35zU9qQ8jQGz3xg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777878135; a=rsa-sha256;
	cv=none;
	b=GHryQyx5cu+GsO3NS6rOyT0veU2Cc1O0R3aezJCet6BdEHZaptFOz+yeYCq9BTFtbHKCSr
	rUVJIGHWmK/PZIfSCS1jFHQaoA4qBj51KK76odYMsc/YpqfNLS/66V+uJCjq/qq3qmZgW3
	pcvFaq3hpAXI64gAbx/EywinYSGcbo8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaLhgUAo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66D7860008;
	Mon,  4 May 2026 07:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C02C2BCB8;
	Mon,  4 May 2026 07:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777878134;
	bh=WLpJ5f+a4wMEBWCfEL3kr5VDnmwptVmJoRoK6QRwUjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaLhgUAosc+V0WZ+RiOOhWGBvH3Kecwiv5jZRsGPJSx4pchQ+zVABik8uUMZk3PEp
	 kALenCyCSPdCqzBB2ucIOeCQSw8x+xS+6l97ZQW/bmvQli4D5HxrzRZGzHJpDvzPG5
	 gFF2wbVgyJ3MqUGGPfWFCIpYawZyV9IdduL2tP9l5ePC4kBA6A2nTo0QrlQTGgBZAF
	 xzJ2/MACyGPPvX3XPPDP691N5L0+MKIpgh6Rr6vV1WDCcz3v6SQPjk2JlyMD0iR79H
	 ETCI/MRg6j4bibdJiyJBvVPmNoxQ45bJq1e4H7ZG7tGssTQFICOD2v3RaPxtfI9ZgP
	 3sfNcBk1NqfFg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] DAMON Updates: Tiering, Pagel Level Monitoring and DAMON-X
Date: Mon,  4 May 2026 00:02:07 -0700
Message-ID: <20260504070208.7106-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426213545.94918-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A2F8180006
X-Stat-Signature: dk44xs7tirzzxr6fyi4payeq7q6bwksp
X-Rspam-User: 
X-HE-Tag: 1777878134-298677
X-HE-Meta: U2FsdGVkX19WCMcFUUzWFRvZoAzlcjx/nHkeon48b/+sQUpDmgNDrNmxwiuVZH4Wl+BUzM78artUqBDqO3SKHnkayDV96eB3sOdZn3Nhkefa9uZv0ha2HbIHsa79U49LCVZOzlkWHEnulIOC5Y1dEVqCz2JyTGl8oXy2b0WgAT2XcLUekc5RdPllJmfUxx3D8hurmfR3wtdArJKO46NCEB8/QKE8FeFAzzQMLbM1NuHT8CqGgnkOknlXvATF/qnWHkG/70EIgkgZqeKqAZcQPr0cXNmnMRwlvGFTC3Z9ElSK0MdI+HjJpWqKrPGWSc9hXEE8g6KOPevSqofaE6qEXFvxihtXLnvrL25dUsxCuMO1nNZ6BKffpLN303ZalFcRRVMJgI4BBBQ2TWkZh4Gzx74nHglIOAxIpisR7Ua7LgzYwsh0+TielpXZZvwkC2u7Ha6TreFF6ZyQsvpoysIvEnz4D/Wh2Naosxt1OyWtNExLzA2mRvRCO3pgrBUIaoZ56pbbdwhQRLoZDLJTglmZJdwOlLrz7xGZiSan/Ipu1YmSdnCzoJFzBrE5L3OLI2uAWSDp6vxFyBWjUlcWbIj78VcsdL+IutA3aG9b/OIGfijEuxgr6nc5oxplp5c66S9T2uNcgxZDX/GqFQ6k4XnmPdcyYatQpUuTD6UU2wHa1dHLkhdA6Woi9nnI/ZDKCgqnAKcNNP3LzWO25L/6av2yl0m9cWqjsTI2hfJadQLxhk42MEsebKAJcWCSxoKkSkxpJ2pFZbI/AHwIAyzNBvQuMHXbreTZvh+oA+vTIpmkT1Z35CEb0hqN99wPIDukGluivp7p77EsfA75uKdQ0Il/c/Q/alInL1N+Fye+ApWp8Vr9CLjTFJ2EarIR6Uh4RWEg/yRnswxDp0IzrqbRgNmYUepd4KetcuZtxhwRYpBoBUYQZjvVgK9bSPckwil2sISGIpqj+8xPjVwhOOoG6mq
 z8h1+InG
 ZHSGDi+EBAufoAYkRYjqRPZgtwDBCCPBhFrCo9fZbzT/s3m0je1EuUGoGSt7g+OAqvLKKluWi3KgFEyVHHwNT/9p7Y1OwZYwj3XbSULX+FE52uiQm2I1x5w3IyFbw0dI7mhummrBCQ/9pkyVWL0O8uIpqTNhh3EdUhU4QrywZkcwhBNMgz6YJwJ+uhX6sMQBBjx1RnMyd03SRu9FvJL33+wuTUs/9hcxD4gCNBIZv7EltCFJ8iDiFHPkMzYXmiRSEKlni
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I uploaded slides for all DAMON LSFMMBPF'26 topics:
https://github.com/damonitor/talks/tree/master/2026/lsfmmbpf


Thanks,
SJ

[...]

