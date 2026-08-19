Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D28CC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550956B0095; Wed, 19 Aug 2026 10:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501C66B0098; Wed, 19 Aug 2026 10:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1166B009B; Wed, 19 Aug 2026 10:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2040F6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:42:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6449A2EEE
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:42:38 +0000 (UTC)
X-FDA: 85118285196.18.02F1297
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9A5910000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:42:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nghxtBIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787150556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euzWB7dCetLNLqR5WV4eVczx5GRlvOmYADjVRxqRnpE=;
	b=jZj9iTfgX5jNlnEmPjStH89cTydomJvBOEXh14pn2Iv2qzYrwpXVdRwzOpp2nYlfF+bHgL
	IHzFYWwdHdrb4QlJIytd8pFuh1D2U9h0WMi3eHwPq6l+XgYk6dvcZ4I1tZamqDWj6pFvIj
	nN3Vz/8vIsaWfBggAKUCIy5Koo4p5rg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nghxtBIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787150556;
	b=Ev+p51D1cRQy38ZMsg7xsPcE04sQLuocUHx6lRu7OW0+6yMBu5CBn/xaTQb54fDP1ti5Yj
	eUM8e4iXvl5mFgU/1jl8DHbLj8LJLHU04csz1VXO2vEJ56QY/ytamqXfvhzXkkKVkW2vkq
	5D0DqxaeEH/7FY1+8sQpauCvgZT9QLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A53460AAA;
	Wed, 19 Aug 2026 14:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5FA1F000E9;
	Wed, 19 Aug 2026 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787150556;
	bh=euzWB7dCetLNLqR5WV4eVczx5GRlvOmYADjVRxqRnpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nghxtBIolQ1n39QlzjrS/sENoKXNU3NwQWvvafLMJdYOHWUUzP0lhmO+/RMiVH2fJ
	 ifI8H+a+tcasYMblqC1tF/eUBGDfRSok/mS+lsoOZs5dpTbkDbFjg2/otEkL6yGocU
	 2SfJz0z8QDaYun1UTXCdvH32R33Semyn4gHpcAHnMOiSSWjulH4Vzem/i/FGnh0ytS
	 zrTYjLbNa1U7DKjENaavJyFAYJ+iSrYsIw9HlGyq3CNrde839BYt9nVp11az2l79PT
	 adhPIi322tgRs9zAXbNS/oVKurlR4Y/endjzPHoTjxGh69JuCVW9rE7Tq3ypJKc9Zb
	 ggO3rNGkNGwVA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id A4B42198004A;
	Wed, 19 Aug 2026 10:42:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Wed, 19 Aug 2026 10:42:32 -0400
X-ME-Sender: <xms:08CFalKXZZyaqdS5V04lmEmbcUR3JRVxvY3KkXiRlYH8unOghIP-1w>
    <xme:08CFan4ELTY9CD3t4qhNda4fstuGmjDWfPvIgX9cgVnKHi--r8fgKmBjwJg-6w6z0
    22ZB6WH4adrB5DftIp4DCj-C5ZF17FefOBM-QSNxX-e5gxO4FFgPQ>
X-ME-Received: <xmr:08CFal0SDtEx7wyy1gbT7NUgapBYS5yPjsHXzdeZ8Io-GSTvUrbq2Sf7TKE>
X-ME-Proxy-Cause: dmFkZTF9GNlml/7ZH2ZirDFfAOYp1RQ+JoZ8Eq9eulPUMv7MLi+5VjXzX63DjrUPLgl7l6
    R8oNHwpwUnnq+UPZOJDOiQxuzqfSdcl74A7kR7QdUbRCUR0nO/+gOgiQ6FAb1o7IV3J4e4
    D1VsYRo2tQ8yUtl+PjrteG9om7KQhBRfqSOPEJsjtFiT7MAZCVSIwwkkPqU1qimhsu4eSF
    X0YUjFCffKeXgMcyK9jFvg8KSz7kZubdHS5AwVBBOaXjWLIVZPtExpgDo2wuI5bwxVZj8F
    IbyGayU/L5KggC25BvMYv3V48mZiKZKJKF64xqDBJKtnCBRL5xBVObCBpQxQg64oXr2Ijy
    oI6byfYtP6lJPBT5RKENrP+T2O1D3cSm2dU50GjEuMjC8rS+fCL4RF6Kktbbc98fXqvKvM
    m+py/25Hgs+XT/RX6NZk5Dpwhcm1q2pT/P9b24C08OepU9Ckd11jezkuNzm8S1a+K9mivt
    Z8lj2F8HrxRihUQQ/iyvUBKFgO16WV6IdlXibA8HoxeQ9FphVA5M95HGpwzOeBqM56A9cQ
    RcDLriM4TAz1MonNfkwQgXd8+Tou9ByptXDorhNtLxgGKiiEu7r+Y4zt1lch7i+nlVkTg7
    NTpOBa+OgAViHWsd2w2pvHkMwe30kXqnfcpqGud49mXmsNcgAtL9ePOZXqHA
X-ME-Proxy: <xmx:08CFanOFtaHOcV5FYh5lFqCL1voPFhT_guxWwvy-y6sjFjJwyYqk2g>
    <xmx:08CFarQ-vdptxouFQFVwee1ZoUIHhQVDOGE-m1aXQU_uDlr5Q_n_Ug>
    <xmx:08CFaioqHw-3tu0sBmBGTkGJc2IOBxpMWV3POYYnloIT4QvHb2St2Q>
    <xmx:08CFajTQplbaWMBUDnHoMxLOL4BY3-nfsmH5e9_Jvnsd0EALmSJeEA>
    <xmx:08CFasIjWgV4-YByO3kHh-S1OJh9ccUDwkXCcMND13tkup3VQ5zW73fc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 10:42:26 -0400 (EDT)
Date: Wed, 19 Aug 2026 15:42:25 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, 
	ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
Message-ID: <aoXAQkLdp07zdJIt@thinkstation>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-3-usama.arif@linux.dev>
 <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
 <5baead5e-b9e9-4850-9ce3-e48a2e5db2ca@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5baead5e-b9e9-4850-9ce3-e48a2e5db2ca@linux.dev>
X-Rspamd-Queue-Id: C9A5910000D
X-Stat-Signature: apjhpob5c8c1q45zphnhh3ezy4wyzamk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787150556-574897
X-HE-Meta: U2FsdGVkX1+vuZBvNTYiMwwtTxlXE+QZVR6LYpDc7ZOpYzQuQi1KnnyQgq6ai9SqB+TL4AC2R6oItFvkfB6i9NaA9i8CymuDVVpcR43CxBvmdgFGMMLCZyRdeuhNKGaRqC1Lplqdtaqaeiydcqj6b9IcRRt0nhfOw3WAupfxm39MmFxhtuOpOVF90Jmc8Kh+LtejyWF+6sYU65b0Ld62YB+pmRJHCU2pPyuZtJjRfaW5RNNN7K5e8IvwzlsmZRaDU0RHasQOEMeQSETuAJxr/kPVkbgohkyFRI3U01qmMfACoMyRpHyQ041jk9jCpIvhzRnzNXZFUl1hx6ZADloaZOUZRZ7usP+NqTD1eBvibTxwgFsXlqLwazY87lI4eKId0WErOcWoHZc9drgTR/nEE7UG9b0mhNUgpcbBy3Zrz9J8lK7BUYPLduoZwIAt13lRCtzlCOO8/A9l4yIvf4EpMolSH6xDAG+kN1eMBYU5PIsDlxdpwHYrc0F8LOKPuMknOFM8+1VcYqRY41c0Dd1b7zPkMJreidsp7s4STycwKKYvttTJtP195+xflVV+t6M8rU5pb+/it411GzaAfesIvl8nfqCQfOEI2U7Kubq02b0zo63oKcIG9XObPakqE8QmkZmKFGsZkiIeJC5JABv4/7K+7nd6AXqUIB5eglsBeYXM0/5oV6lxP3D4bWC3IB+bu/V5bwF0cEsmedz4A2Mxx0BMIEHxq1sAa2ZOZbTvd77fV3mpl3oElbSl/IV4ZdHdYuyFlidz+/ySI+cpgsOMX70JMpZEzPjD1pgIdbuMQHksK/BQ4ihG3g2+DIBCjT4inTqtmGi7YWmRFobJwhD+mfvlZlBuA264hr4Scw/BBpfFYGQJmf/+CVw0miMaYGNZlW+JiE0UmaKrB43WmwaHUmS0EUb8HjcWDh9gKwwmI5gwK2CQgTvqls3B36j2hpiqJ1Rn5wsmmplUZKavC/3
 5SNF4HmM
 jsjErsz1FzKbPvuHYviZV35022EqzoRWgPQeWrDobPFQQW63+FTT88/dtpY58J2sj/XqeMsGRTWmDJuXntdFSRT1l+kxosgI27bZfkCOTszZBjL1ebhi2hqDIhO5Qtv24Q0J5hwbSEmxFOp8T5MvyqXbhnuERtpN4Zw7N1cR30tH88iidMk7nT01+NuKu0bX5OT8kf1QeekKIZA7hRgaEDMHB6VOv2hJtorPBaE5OzttSto2y/C052kyVsObSbUrWOc052RgSxCxENlm5kwHWoKnf6+xyxzJfsHf0k7ydR5NZw2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 01:31:08PM +0100, Usama Arif wrote:
> I have now split the architecture helpers into separate patches, followed by generic
> support for the next revision.

Shouldn't generic come first?

> I think I will need split patch 7 and patch 12 into
> several independent patches as well? This will significantly grow the patch count
> which is what I was trying to avoid as I feel that makes it more daunting to review
> (atleast for me), but I will try and keep it under 57 patches to not beat Kiryl :)

Resistance is futile. Relax in creep into triple digit patch number. :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

