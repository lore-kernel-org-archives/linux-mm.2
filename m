Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D776C5ACD3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33EC46B0005; Fri, 20 Feb 2026 11:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED086B0089; Fri, 20 Feb 2026 11:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAE36B008A; Fri, 20 Feb 2026 11:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02BE66B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:22:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5790016022F
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:22:32 +0000 (UTC)
X-FDA: 84465352944.13.EF9029A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id C73A620010
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:22:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CGCEvJdm;
	spf=none (imf03.hostedemail.com: domain of BATV+48c09b353778ff9f8542+8216+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48c09b353778ff9f8542+8216+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771604550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRnb4BkrQlqKhx6q+mEan9QZi8Q7dlXMpG6gOi5/rDU=;
	b=IBeaXOAcmpN9BNn68N2WKYJiAm2/WzfZhbvlCJzJM5KcktiAzySDB0UlUwi2XGlIJFBi/3
	tu4c4b4xqoaIGw/q3qB69dDuACmZXSh3FtSYwSdMw3N0WgqAk571/Qg/LmIu3/VeuhmqbM
	07JTxrSc8oGh4U05Ex/mJgpPG56WAro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771604550; a=rsa-sha256;
	cv=none;
	b=DUaPFGLnH6z1lemfZwyecvemQpArz4UEGqEosCQ9Fodb0s5yBF9a8FpPxY/NysNB5A7Dlb
	roP3WV35pctGOsJ39roFx6D52bWCUWOm3OZz+soqJFrkedSkITTlX4KyH1FmH2FweEpf/6
	/03Qd4LHnGbC2N+Ol87rXTRUdd+dctE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CGCEvJdm;
	spf=none (imf03.hostedemail.com: domain of BATV+48c09b353778ff9f8542+8216+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48c09b353778ff9f8542+8216+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JRnb4BkrQlqKhx6q+mEan9QZi8Q7dlXMpG6gOi5/rDU=; b=CGCEvJdm3G8Zx0dH30TeN5aaSa
	HHac/iNGrEN4/ftoNZXONISPs+51ihEOHZXi/a3o/nUiXDjvSTYoGKioArcVaPPkXlVg+Qyl8NHP/
	UfowdDJ16SFuzMMmJBA/Y02hinZT3QegUfeioqc/yiAiGsunNanX+S4vJc1mn7Lee7xZSnSZaVvc3
	4gNxr1idPs82bfPS3qFWhPcPJvS6AHpOo2FFkVOuQO91AzBVlQYIDD+D+qhnm99aLMkiCseYxHz0G
	pEBmXUqsObD8vfdg1w0ICgaFzgTJctbPyVvDV2+kQi4aYfbkTu1BbIgMqPqtT48V1x9t0l8qEMQYy
	/8osRV8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtTGt-0000000FFkF-1hCw;
	Fri, 20 Feb 2026 16:22:27 +0000
Date: Fri, 20 Feb 2026 08:22:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	chrisl@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZiKQwT7KjWDLspH@infradead.org>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: C73A620010
X-Stat-Signature: ahr1usuqrygwz48comdj69qoos4ionpq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771604549-421255
X-HE-Meta: U2FsdGVkX19vEEVSrqWewVpfdS/ZDjOiGVFs+pEGLQnCuBzGC0jXhjkze0IQDFa1Msps0xu/gHw86ra6dJOocHLEqkjaBHSTvIxkmEyPeXeqhnGJ5XeruDa6a28/iUDum8zU1tAt8mEam4TFLcgg+GnSuh7zV9p7V0TE6V+x5zLdWzZIqK3UHBj1/fuUMdtWtmXOUC6+hiLgwOKxROIfqUP3Tuy1OkddSChKBHUMy2JXYOZmViqc4ehLkKrEeNHs5UgBGIQcaY5h5pRAThc33wsa8+EsqsLyzqoRADlUbEqHLmUfBNwmuI1DRw8PTyiRx4dm65AFygoeOBboBuF1zfzV+pmv7+wU6zkdOrqW7/RdocgfUHOa1dRkwME9ZUTj6som87ML+YLP9x2f9q9vSYQyNXx4ar+9214poJFYa/uCi+Gxip/Tixqwirb9F6LwKgbysZYiy7oRD0ep0rm+xwA57pXspErKJy42FmeWDNUTLnJ2+pftYl2Gk97DgVd0O0qKJJJzecZjBYVVRIEVIXrErVsQGfEoQd+wf5596Iajkez1ukqnCo0PSqtQFCz985MtP28dFWmzVaBm9phQD4s/J0yB/XZFoCzvj1bTk2tmXIyDBTfXkH41eFMNXPuTivACYRyPfWAcvkiNDxQi7pTBR1+/PnT0rrTcpcEaUNrtLQLd/D+9FGwiboRkMDyNGFSNrUFQLGn1TPRrOH2Zn3vqYq0fF2ptii44zNdMGxHmuYNyB9VeGDs6YHqh8VJfsmfpyypFmYOwZ0UTuZyfwv06GlV30Ws12sMU1gvlaOX0Ev9UrydWh59pIBeDVg9fqf85ZH0WAyDM0KJ7DMQlCQqVRi37oZ81yLQLXCz3LoRdgvnICq8gJ+DH7GrEqVpweTS14rTWyomMmVjo2ptL7DiEf6IqfcIttO890LlkfOCDOq67lQvehTluJvHuIamoLQz6eLUaQBTuS4uCZAo
 Pw6wZJae
 GYRSiS2OASsB9Xjv6q/Ah5JGqNe1n2w0fAWAp/8aS9oHeTilS9A1x2H7G5sQ1K5G5T9WDubXnPfSl+T+v/I9bXuoFjSg6+3HQ9DZSSGAbVG3bPIAyS6d3UeMqfhHhNyvNEiFO+y0ToUcznxJOXUOyAbxWTupSGzcbSi7S5mAOy7c6y7uHdBktiIC7OBwoVxyvl9clSZzZedVtzlyqebh9PqPCyjNSBwNBjhtuiBVHScmDLh5cG1k7zzasxIT/KPAwXBgmRolhj6mE/JMZ7ZoMJurZcu05lgO/vBP/vFDkVahKO7A8afKObcf79H5p4OulMcETkmIV46blKG1RXkKyZfhh1rHjMvCBwsbx7RH/QRGbr6JnsM9RMBhRCmOLTaDJQT88BsAl4sK1F1BLEA51C2ey5/Ok+UEPJlT4x0mE8t7A6zAr6v58yJS8zUp3i5RHm88OMQ9AtRrBjCuJ5uNHBk4S96RLGruw8w4agAc1K6U+lla+QJ5g/CF5gQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Honestly, I think always writing sequentially when swapping and
reclaiming in lumps (I'd call them "zones" :)) is probably the best
idea.  Even for the these days unlikely case of swapping to HDD it
would do the right thing.  So please no conditional version that need
opt-in or stacked block drivers, let's just fix swapping to not be
stupid.

