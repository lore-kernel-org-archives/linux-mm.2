Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFA5C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51E76B00AD; Wed, 21 Jan 2026 21:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29906B00AF; Wed, 21 Jan 2026 21:18:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56736B00B0; Wed, 21 Jan 2026 21:18:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C56F46B00AD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:18:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C7C35F861
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:18:04 +0000 (UTC)
X-FDA: 84357989688.12.5048287
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8959680002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:18:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jw0iCzdz;
	spf=pass (imf02.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769048282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dw/DgZzvLJTE04Xi6WXYLsL13zpRb3IL+pq9d6F+PXg=;
	b=O9znwVPneDUjHLF63B3s0jyZPqAlRl0HPL4jgwb5i297jB8FvCK24xIkAdaR1ZZVITAmv7
	OA/xRNWlH9qp9RoQkR+5dowgF3kKyyonH3zbkowPKo0YuNaIVNJiKXGTMAFbEvgWiK65pY
	o/lu9W20hoK6erapNRLvxR/LZxF8EZs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jw0iCzdz;
	spf=pass (imf02.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769048282; a=rsa-sha256;
	cv=none;
	b=azGQ3C/coD4X6btmOpK40f+9zuyRf6LisY+/jFMSAtWDOmOBLNCz8bihpR7LhjIE+ekT8Z
	HreZR2jlZIt9WBz4bl7HmmJ0x4rFVMOwVyS/NwyUSwPdumoJpc3XVvw1XeuBH4ljdtG5hZ
	HYrdfXeuttC9BtTXFK4ZfhJ8PJd/Bwk=
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-2b71557299dso671927eec.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769048281; x=1769653081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw/DgZzvLJTE04Xi6WXYLsL13zpRb3IL+pq9d6F+PXg=;
        b=jw0iCzdzcwran2pNVoTZOcwqZISTUdOt/xq4enNyE4tvWS/1o53kQcwnvsuQXF3HBI
         FXlMVepDE/ZiNhZwDG9hm+Vz5SPxfb84NCKje4D9OOsWrOn8Q/Z31D2HfxzTUNHwDKQM
         1HHeAWxKjimCrx89t0PTd6/0s3sAYqsBjYE7Mo84q1pFOm4YlwApsG47IbOV6ErfyNbt
         bskH3BPSWvQQAs7DkOVmYH/SuVu6FgHBI+osnj3ZBoFDBuZnNZ1siGt7Ht4UN3Hjzl0u
         gjEMzz3FArQhalqaO0cEtbo4PfJAH5LKaQt0NtiwCcuEQt99w+cD9VU6bbJOpGj+OLJP
         3Sgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769048281; x=1769653081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dw/DgZzvLJTE04Xi6WXYLsL13zpRb3IL+pq9d6F+PXg=;
        b=LUku+5KnbJ31gZWMqYyGKfNxqFhrK6xvsOEXNFiL5xwIkljpci/d6zHtpXyrpLOE/W
         C47kqjCTpPYqVNXoIrk1QzsFXLy8bvUQZawxFO5Oq3sbZ1GUKnMC4c4XYRU30pBK5dgU
         lccM7U5PjEHW2+sK9DEDKRCtbfsKzRw/8sXjoiYfUFr2roSxyStPcITix4Mx3RKKD9fj
         +CL35lg18pvGVB7Al1Jh3ItjlLCcsXFUxBFUq5BrOOkIWPpUzzEFel/NQP+FU40gKscH
         +rq9xUN0ZjHMQo2ngt7b0j0QPaCdYIP2+PGEpt1izwJEyMYwFzq8cJma/UemYYKXMXDW
         ho9w==
X-Forwarded-Encrypted: i=1; AJvYcCWRaGzPP/szcptp5GU4bGyNs7hOUGJXkBXLFE8kUog+2lJL6KzM7MvcvEI9mM5O5fv5UnM9DQGkLA==@kvack.org
X-Gm-Message-State: AOJu0YwHlf7IDVg/b2p8AA4ROdhGHe+dUHbi6KG84JKV9uZV2AIU/dqJ
	h4nce+Ig2Lq3+ppgWo2SdntE+Olit6GzAP/V4e6a5ifyTLwdNp7BoH/N
X-Gm-Gg: AZuq6aJUufmup8+UzyhQhaMIsbNbd68NBAJdY/anE/IRcOd5cUdGt9T20/WT89E7jlU
	5NryQ0AzIcWOD1X50fG2DTNn9vksFnV6Xr7NmjRVvIiijZaoJgYDvcAlvjO0adP4BhBvy1XadyE
	aWOfgJ0Ynpxbn47EeQK10MLBnWBr4P8wEubRgxMEegVGlXGGz2is/88TPOFma+a5TKKZldPW5Vy
	73twbGcLaA3qPckDrGBOVCenQfhLCeCJkHOK3tuSDDXjlCgWKCovrF2QhdtNN7RCAgNh6V+w/Hu
	P6oDXzgDE/NCGDDOjXovjlhYKHxbs966OT3HsnW72Pr2tDQyp1FqTrFeUFCS6iecehJvjrjfNpc
	r+WQ0KjIM4/sE6dneH9QEVP/s8bFGo0WEQEuEy0U3uRcDkMCnNl3VvWNRWOr/cwdUdqxLuHURsb
	6Ocpk=
X-Received: by 2002:a05:7300:549:b0:2af:7f2:50b3 with SMTP id 5a478bee46e88-2b6b46c6835mr14542939eec.5.1769048281251;
        Wed, 21 Jan 2026 18:18:01 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b34c11c4sm23694514eec.1.2026.01.21.18.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 18:18:00 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: realwujing@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	edumazet@google.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jis1@chinatelecom.cn,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liyi1@chinatelecom.cn,
	mhocko@suse.com,
	netdev@vger.kernel.org,
	rppt@kernel.org,
	sunshx@chinatelecom.cn,
	surenb@google.com,
	vbabka@suse.cz,
	wangh13@chinatelecom.cn,
	weixugc@google.com,
	willy@infradead.org,
	yuanql9@chinatelecom.cn,
	zhangjn11@chinatelecom.cn,
	zhangzq20@chinatelecom.cn,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Wed, 21 Jan 2026 21:17:53 -0500
Message-ID: <20260122021753.234007-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260122020035.227449-1-realwujing@gmail.com>
References: <20260122020035.227449-1-realwujing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8959680002
X-Stat-Signature: 4t5kh5gpwe9bpmhy3hpcbof8a8owmria
X-Rspam-User: 
X-HE-Tag: 1769048282-81584
X-HE-Meta: U2FsdGVkX1/+vhZzX3X7eq9DVuT0BRt7gxEimikdvLG9/xggVk6RRRZV4CKprLwzpdv3Io2OpXAoRDzJpRg11P44rheM8H0z2lWTrXsKTRWY0oSYu5VkyQtIvTJSERo8TfdMWkcIZsUxjAiRplLtXdQq6uhuTmFzrFLS3mzW784IMoR4dxLqBT9i+lLTeXcT//HE5X7mZGcaCkh7o63tzaI2xHEnIsxNNwPiFEDeWqSEgkqn9RkfJ8QcxIJk+L+VOR+JO/C3bT6U6yrhZlYK3ehRBVrjRnzBe6eXiwTd/1RgwttJ1XYXOUtWHLrSMvzEskaGNbK31WBWzbQMZ4bGYzMGCtf6CpBE6ue6kODRrT47m+ltia8CLEhCIdLp/OXDvOy0wq3GDbPDJnhzaJznVmLr4uw6n5K1/YkZjz1L/VXkI0fEJZ19mRm07n3dGkBrx3jnEIVien6P0SEnabMt7UQm3O26a9AknOiQYj0dPj391W4K0VMNAhDJ+xQHBOhMn8N51YTsRV95sS9f6SbmK7g3KG9krJFIID0JIcRaq3pSqfqI+S0UYlawEUFI21xG8F6vGimILjGgQzltCkymivXn/PBlM3HrH5/wkkmG9OFxGEmGJCJxfZPdvdRjUCeOoKQJVV2T1Djm4f6bWyTmdm5Gx8ej/wQFHjQxU0+1B5Z4pLU2JbzsZJq/M3XfRZKVVcYllktPkclz9fpWUua6ePRnuErm4/5Hu2VErHwhxvbFTMMez2IAL/O8qqLZNPp+7/YDp/p1ZSX86udehC1IcPqmX59NcRooK/6z2EqvlVbDMdACz6gKms7BN6s/AybdftZiR+w6EBXMHjlqq46KXlZfP3/pd7pczElU/a0aseSnLs6VZZsFLVXvYtXoGafRQa6lsDU7CVtbETXd0eLrM2cDib7NuYAy1JtwlMY5x3+ZrGuDBRrGZFwBsvcMvCRTVOh1zdO3JCIwMBvvOjR
 cwNLbv6V
 G2+0RHDEJ2UWqQLaGE73IUBxnovZUrCGDp2x0JthkQX7fNA5cZ5sWKivyEhz3Q7/RtRtxgk/F+vgxnPgs7QPosz+MumM5NUu5hwxXsG9IZT4e7oMwuuYCCEyl0DlLuO1wWaNbF/hiyvrZHHb1bGbY1xA6pRuEVJRPhmDWJFKwf1c8VQjHahComZ6Sp+1OdWiZmtldryyrD+fiylDg/KM7AoAr14JzFQBznSvo6CNNo9/SOzFyRloC1yJWzFA85ykiYnpnEJchBixKCOVAL8HD8YvjtMZXVe0c1Za8ikAKO3UAk8fHGyO+SYNb1Lo5gOzPG45Oy6an2IE4iO6ze8XY65rwauUwTNOIRYsfZvXiuB6HlEXXsUBERvq3UY6Q9X2QgUISbDKmXvLRHQGvOhXacCMdOvqZBLR7AcffYVW9X1BsRZLvMHjKCW5UwzTkyOvoIO7AKKzqybz2oCt72/z/lmEnN5d600r4TxG/T6ZemJEEP9/ZrvKqs6IBkxVI8PdqJ/xW+lx4mvmqHW5sNeEZI1y/oE7MIEBZLgecBA4yPlg47AA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000021, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please ignore this patch. I realized that I forgot to label the
subject as v6, and I also forgot to rebase properly, so the changes
from v5 were not correctly merged into this version. 

I will rebase and send a proper v6 shortly. Sorry for the noise.

Best regards,
Qiliang Yuan

