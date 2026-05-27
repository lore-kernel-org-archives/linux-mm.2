Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B15CCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BFC46B0005; Wed, 27 May 2026 03:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670BC6B008A; Wed, 27 May 2026 03:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586B36B008C; Wed, 27 May 2026 03:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 488606B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:32:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF2921A0515
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:32:23 +0000 (UTC)
X-FDA: 84812381766.18.418443C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1DEA7180003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:32:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dOZxfO6U;
	spf=none (imf16.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779867142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bnqm1PUlXcpQOpp83CzY3yA/a3r130J/7y9wVWWZawI=;
	b=3pGrg8deID9fvC4GssnSrRYg4VRW/xs9NeNDp042fLM111HMPjgdmJfk6xj0XPPpfZ2Dbq
	JCw5RAdZgJefDnTdRMqv/NMyVoESzEac7jiyGqRm2NGvfjHOxf3cL73e5XF4AnsAsCoDHi
	E6gNT+GknNht6bsxfJT6r9zfaf54R2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779867142; a=rsa-sha256;
	cv=none;
	b=ER/iHOO9A0IahgX5i54aekqaPbkZVvTplrlSJ84OUvYGlpkQDlU/WY+Ft2PoACn4NTMJ2G
	2zvXufAn9GJxipuqGELbkDvA/MpvWzwsF4AtWx1nOS1IIlElS+RnCLOFa+pJtCAQFBtJ3R
	aT1G+XQZovmICrtGntPBfAE0WXDs2E8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dOZxfO6U;
	spf=none (imf16.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bnqm1PUlXcpQOpp83CzY3yA/a3r130J/7y9wVWWZawI=; b=dOZxfO6UtgiIeNFOXrwCMM3pqn
	070nwCYciZpWBVLEeX64F6HFhhvVuXTu1lsrU6UASi5mmCK1CjcvdzJe0NS0xkyhUg2E1CGhuIvEH
	S2CkR+x4mU7iiDVJaEI6Ju1TclaMS9kqP1uR9YKbab+If7znbwLkTdWZjWmGYpo7LEs0BCcZfw6JG
	TVgypKRGxTMlUeJhLxcRzhdEGrv7hlTjPqc4MY4NP6HlfZZZV4mVLFkPDggkhLQQtYO27spuyZwE0
	I/Iy6D3hqPHFLIWEFkj4ltLV6L2tlyaGYs4oZT9hs85UM00jpV4M5Qr5mZTHJzD+i7qH3hF/0a2Yl
	C6wIip8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8kU-00000003TAQ-3QMz;
	Wed, 27 May 2026 07:32:18 +0000
Date: Wed, 27 May 2026 00:32:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lib/raid: use kvmalloc() in calibrate_xor_blocks()
Message-ID: <ahaeAngWN7sMboRE@infradead.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
 <20260526-lib-v2-1-ca3f0fc24b14@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526-lib-v2-1-ca3f0fc24b14@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DEA7180003
X-Stat-Signature: bc96sks5393jrn8ibz4ap1kydnjiyn5y
X-Rspamd-Server: rspam06
X-HE-Tag: 1779867141-772235
X-HE-Meta: U2FsdGVkX19+vQSw7aQJJ7yAgvSxvcOi/TSboFRX+4hFkueJEMX+E26WKc1yvILubbanvHUPHBphW0FOOj3FMq0L1dN0Ndg9vIqEMeOGnCvEeQBurV95+5kckc6vv2nmREcPMcXfYTLNUdfdW6DruHFH5QepkcxpdPV63SCpxzk0VBl9KM+3jG4LCkTA8wVeapSuU42gPW9+so7pfWIqlAT/jf58x6r0qe0mmbAsZYrALAIhJ4oWPp3sa258z2wL0jaXxG9JpwrE9BgE4UYxCuCtr4/H2793OTPduNGrCwClL/wbmwQMxeZWKRx8ffdAl0/cL+gTKOiI6eSc2q/hsORUG5m5nNUn7BD9ZOVfNiT1yaLwXd6rXoE1kYnE8bWgjnOrwxl7dMxE1g4Mc2SStyoxyNUt59KCnXcCS4AVEQbgySAIEI/HaL6UdARwKq7iGtGmKMB/wjokiLQ4Sp7eMTE2xinABzBeK7FmPLM+ZyQZ2NC45D/lv4RnhDALdLBQt3YabLciCa0C23FLWYCTvrWxiACLQb8ppdLE3oq0lw39Z11LGdRIW/fqSQF1ZleIIvnE0jURgQoBHsynB9iEdPMEYO14rO/EzTM2p5v462ipEEsgAILUStRCFGR1C/eRebYC8ZylVnTutK2NgCuThWHC+vmc8D1pKPtGsx6UwDMsE011BSxqO7V5Q33B+8oNp4SvkT66Df8MumE/6S9edPPQJbfwS/jfGZyp8AzfUYkYrWDBetqE+tmf2TU2b9qYIs1907FPmO+bvQBILIwmI7z5Pi/BdwNW6ptjzYBrvDqrR43nwvuHRmOZKfm5DhaXTNs08IGHauA/ytxMC6r8RRnRaVL0KvQytOmoMMGC+6zw+vF5obfvvAB+baLCjFnEbOTq9F3vYSZzDn1ocGVAlUTHs6nQJ+x1sBrFk4kHhCU9d3cnmFwTB6FpCJx5oar479DssSy509dlGEPSrhW
 JZJDJ+GW
 gxDMZ5LxOkY3ibtGoqP862eWJAZtihKOMyQBKVIDAAr0+A0rIBVvDNQUAf6nYzCtLd5ki7/f4bLG/wtNOXK/sTmzEWDt31Sll5lcfQAUMEZaC0D2yUYEWeaWYLEjoLkFsQ0ByefvMjSMiZhtAYMc9wHCIpmfM16NVSb6OtD4aI+AG7bsrSM3KmQr+gho69uY6p8i7dND0R4yigdy8tYEz1U6MM4PScalM4CSHa5FzybthInkjPq3ymvtLfsrZDAiRBA+EkVY6698qWISpCMiazuU92Cgusa0YBLaJwVj9+Gz6tI8wrdUy33ZQbiC0vO9qHJFbPlUagz4hNx94rmhq/jzni5oki5mVCilGCbZhd8Q+ktPJvF/K9iN94tmaxL48726KD4Sz5d63bhsWQ727brXC2xC+y/EKmqFp4r7Kf270XJAvPFJYF2ChHcfx5OJF83nns3ZYoDL3hiJq1D87REanWEdyr2UYbvRvoaKQpNDnrzAErEX9+Q0PeFaZQTUiP1SA2dcSBheDtFylprVBN6NWObZO5LPMUdhx0Hqz8FtKHu1NJD/jphpeeLG1wgCuUoXxp4d6Vyz9DoDRnAMNFwCe/BNaIsFHYjj7h5twEUK/qK6fNXQORYWZIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Can you stick to the xor: prefix used for all commits since moving it
to lib?


