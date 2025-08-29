Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF733C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 04:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758EF6B000E; Fri, 29 Aug 2025 00:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730956B0010; Fri, 29 Aug 2025 00:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D286B0011; Fri, 29 Aug 2025 00:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5545F6B000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:36:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28D0A14053E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:36:16 +0000 (UTC)
X-FDA: 83828533152.25.9D128CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 96848A0004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xY1Jjw8Z;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756442174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D03u/UhYlbgS7OohI1AfsBOYVG5Wsqsc7uhnXMt0gdU=;
	b=XLbSc7OBUJzR19LjTbd+nmCtaXuY9s0uM8K+DSJcC4t5OzTt5XAN1hNjXWfZz5vazEXC4n
	QGYWYXpnktb4wwGnTTQdSKB3UzrxYgZ+7bd0THXZjN6X3E8m0J7z3N91CrJzAxomVAVJRf
	XFw0ucQ8GqfVNNDXZmRm75cZwVb/HFg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xY1Jjw8Z;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756442174; a=rsa-sha256;
	cv=none;
	b=dqpAdWCowsKVg+9kUgH3EmLy7ijEjh9p6Os4TrxaBcviiOpKpx4wfQ38Ogsvk6GCro5PXb
	/qwuyAe1IM+l93ijkFAJ3OmJCvJMFXbgKHv3pEltfPHa4QXGWwUT/sz6a3SpClIa2IJUbO
	3FxoMrO5MjVTRoPTemeGsP4iQBN170A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC55D6013D;
	Fri, 29 Aug 2025 04:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE04C4CEF0;
	Fri, 29 Aug 2025 04:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756442173;
	bh=Xt0feyUezz/5l4+6xUi2n7/85qxMuRWR4CZoEWdHKEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xY1Jjw8ZJBjA1gereFJwF2Toip1RNMc4A+dPEATNGOjGOWnbBOdZRcUYPKc3V7qn0
	 GWpberpA5gzOQUr6rZ2g81TEVJp6F5fxemjpng6mPH9tMwua0E6udfMs4Q9mfIQL5e
	 QrOAV51Bd+lS3QmtuIBpcrPqdL6lb/E4BIM44zL0=
Date: Fri, 29 Aug 2025 06:36:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>,
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
	Jacky Bai <ping.bai@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	NXP S32 Linux Team <s32@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v6 01/15] devres: provide devm_kmemdup_const()
Message-ID: <2025082957-cruncher-shingle-980a@gregkh>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
 <20250828-pinctrl-gpio-pinfuncs-v6-1-c9abb6bdb689@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-1-c9abb6bdb689@linaro.org>
X-Rspamd-Queue-Id: 96848A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8w9xgixcxr6ptmnmfs48qpf5a4rfgchk
X-HE-Tag: 1756442174-655680
X-HE-Meta: U2FsdGVkX189zM+Vn2+eT4wCn+9rSbqHx0WrTP75+ky3fXKKC845c7b2m8VXUBicxYpdfwXRXaR5mJ15x1QAxuM4IBswqRCUOzGezbQS8FI/3KJfVvxDzllZm4iyyf8v55aN7DH8kSchgAX2RL5+1Zd3GqJlzLTQaykmUkeRw0w3zCRIMlOfB4b1QqKccYaIYYFTOVwlN1ZvtXOc6gEPi+oXTFEOEOBb1i9KtNlseqMuXTiEyrRpJ4z97XtsQFg9CouBfMpf7XFy2IMA++kfCOArGRz3w2KrRI5acqZSogxEOnSy2/CPKFKzdP4SU12m0Ctz8Y2N08ISrKT3JPn578D5b/gCk5IDRFS+MlWitRTv57iHe8uxZknWRK7cKUdmppcby9eTkpRYbfmmjZnZDl7jq2j5AeJJoWeo5BWyykc5sbyMYGC6byWv3wnrS13D2MYNhgnLmlAcVY1JvWrkD00h21M7nl2bRYhabjgQpKkejTGYVs7Mi2IfM0Y5tTb5tM2fRBUEar9rQa2miHIIEIy2pRamBflgRYP5BabTKo9zRaA5PW7nsKM1NXj12cYvR2Ao57s9Ec9kTfXRQ6G5ttqG29rq3wOVyZ0QZnpUIBbHzp6qMDdmCQtKARhjrxqjFY08J5QHaFaEiP0d5OGESoriLHNdcg8Fz5O2PUvuDGcogThl5mJoqiiw7PAcail/aPSjY2TnxC2XlQkPtwoKVArJa8NGI7gbjx+UaTBhMsGmw+JxayP2k1GEpOOLR65udPX8wIghTSrqsYONnabksqIJ/+/+9nd3HEHCAoQyj2IARsYULyzHfJXEVtdsq0TiBETqqfWneBwanE2qs9DAJwkHP7OTFO9jZA8s0Vq55/pOdUqxqfsn36HfDADqs7UVJbvVSjdyiolDQzH+t6JbIsEa/m4QuBmJcPgOzEpr935ZZfkMC8l8ALaE3A69JfrCGeAB7ctBEbCqNwOV6Xk
 bmCn1uxa
 zYpNbbnmLrfs9aCOzBF9uYy4dw5CEubBK7ESPanTKr95r+9ra/hrJeiquLrBiUkHIqqsQBK/SNh+0q16MAzbiQRiwrEh2XFuAgTZXC/tm5KsxSQtD2BN7YZmC7MrDdRvL57GasVUbJjzVFjpwdIbhhnFGI1gdxXd8SS1AkTmABEo0Uz7FgDuHk4+PZolBlTtGCtcv203Zg2cCAaqRREKA/c539nyw3DAO/cu5EA+lAb5NDO89t1/Yb0K8Amjzpjn830VI8AEaLamBCA0iAUEvdhlFPh/bQkq8Y00wd0DNILjssCu6rlC8V13I56e/TbUJgIn8NCCuWpDE9d/hELOyoEEzTIwwXkmwvpESzNkYndPZcpHnkbIbGxlsf/Y3md0WTHSmo0wtCCIfRRyS9fQkHY9/9h8xEFKUBJh/IbpMAJYt70+BNv0iiFDOrcx1wkp7C/0rHlI6/QUcYqIg6VtDrX3P76nXCkbaG+xU+0qEbeRiv+dqlHVPiWWsCdaOSg7djgGIoNzztjij3+ey/qVC/M0/4mTLklisDxhDLOLL90NbBwoipI/DfH+zMKoyYyb4zW870eyOEY+OanLA7seGzHNo7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 06:00:09PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Provide a function similar to devm_strdup_const() but for copying blocks
> of memory that are likely to be placed in .rodata.
> 
> Reviewed-by: Andy Shevchenko <andy@kernel.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/base/devres.c         | 21 +++++++++++++++++++++
>  include/linux/device/devres.h |  2 ++
>  2 files changed, 23 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

