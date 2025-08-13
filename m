Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32518CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1929000A2; Wed, 13 Aug 2025 10:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8938900088; Wed, 13 Aug 2025 10:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9EED9000A2; Wed, 13 Aug 2025 10:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A79E5900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:58:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31EF05892D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:58:43 +0000 (UTC)
X-FDA: 83772040926.21.ACA58D8
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 50E0220005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:58:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S3N2OL50;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755097121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdj+KiCbn1oJwqYp1Ud6yUCBUGI3vXG9Hhhy6pT+YGI=;
	b=M/sXKhzl9a6RYx6mYNLcZCeZdfyk2N29+2BKV6VUDcr+8FsK8BvkIvfbmEJSDlinazgUOr
	C4VrLFH4fw0DagBt++D69NEwBkvrGWK334VrqXb2+9hCSepnFCt1mGm3pdSSTS69KCHlFl
	0KP+VGd2mq8MvcbBw4ZMpqyUNpI5P8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755097121; a=rsa-sha256;
	cv=none;
	b=3WUOEPrK/QS3XkG2+oi/pieWFquKg9mDTRV9QgR5RCtkLo1aL447G4cY/cGcg6QcpJCrn9
	eeWJEbz3SYkp4kJ93c+oH9feQ81Vs/CJ6iMA5JyDALIhTC+OrUOFzyDtilkHGu6wOW4xez
	08QI+IDzBtv2n0rrZaK/Y/1gdgXcs7c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S3N2OL50;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-87653e3adc6so155470139f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755097120; x=1755701920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdj+KiCbn1oJwqYp1Ud6yUCBUGI3vXG9Hhhy6pT+YGI=;
        b=S3N2OL50nWhSTJyJcaEeI6vco/5O1nIDyDlhOZuEW4MoTx2FzpY+uyjj3wL2dA8iYc
         xzAMTdnFSVLwZkbYYqLsgVhWpzwi0ShdomQYCsLVx6l8ckzWJUNpkaanh2wm40HIMsQx
         XIiPhlcc3dVwISFTt4UhAXa6c8fwxY/hQ+eOvhpLqjNdfA0VTwCmrQHdNKeyUhaTbY9d
         CGRfdH7sLCWa3rbuaXnX6vzv3hNGv0DE8rIrfBHxh7heDf/ey7ZH6OLrtrtcPXyEJpOM
         JBzrBVSmXmcq7ANgv+o6cwJB9nlwz8IaNFyp2GCrZz0vxO4Inu4FqKmWtiLYJg/IvSIQ
         WAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755097120; x=1755701920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdj+KiCbn1oJwqYp1Ud6yUCBUGI3vXG9Hhhy6pT+YGI=;
        b=lXZDnyOML09LDRAugtYC73hvlgp0DLZaLgnPfWNKO8B1WyUo5+VU2inVPWzDndnh2H
         JJibVTt58Ok59mJJHcQsxwluo3uPV3/BV1sb7mtn2o63b3Y5ADbWETvq09xSN4HRk3HP
         h5aE4gCpUoOlHZ0yThhmbgm6t4ld2KNGYSe6Ia32zAGufXgKBhuB9gGYvRw9WTjo62HX
         of0ZPowe21NnY4VQ3Xpcyb6Pjg1Tu/jL4+ShuO9ttdVvMDv0iErkRySracoS+D1UIfco
         UMqmrKaSUHbH8YB3GlhuIHxdWXSYXUw9Zyzs5HSoXLRg+JGtpr0iJOlMnCuadVvAJq9n
         IPkQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0nx3z4vpzzHnvJfAIcg424HBA+i0xt1ESvOm+2J+2UFM7SlzX99FiDZeZmrNTi62urb6pamqbzQ==@kvack.org
X-Gm-Message-State: AOJu0Yyoy2RIoTBz6yiSFe/2n7uUvyyfWBST/LDOnh5zvst4SlDWleC3
	lKcwk0lw+XXI1+GMIvzUE7v4+bO2qgQEmJ3N7kIVoYxbhW5Ix0atkaen3qOyKCTAjybunYpOMXc
	lP3W5rhnpafN9JpgB+I7eQlPaaGz7esc=
X-Gm-Gg: ASbGncutxfETBsAfwW0ocNqbx0gzfoGRcnCBSELHptZ0axvpIIVblgIFNqE+gfqv50q
	F20sHxOY9uhmm4GUxmAfsWJFhPJ/WbtaTz7p8baqwwFmmlAIdK+Qj/WhZCN/Hw0+v/f2o1MkirC
	qT/8QihCQwMed63DTJtPPBVZHNVCuvWf2RclSmUz3K/Q6DAP6ov1dmaVKWlOZrfnYfxZpwQog8V
	pSS
X-Google-Smtp-Source: AGHT+IHLKYWoLQgeaa8lpUZkBDSOBm6JTFQBeQSvjC9Q22Wk4nofbygD4o5PAkEKh0CzR9uDm1gnj7nWtx8MBs/ueCQ=
X-Received: by 2002:a05:6602:160d:b0:881:99eb:e212 with SMTP id
 ca18e2360f4ac-884296893a8mr594614639f.9.1755097120122; Wed, 13 Aug 2025
 07:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org> <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 13 Aug 2025 07:58:29 -0700
X-Gm-Features: Ac12FXwhCZMD2zvgw16nmysoWddi5UuKHvB6gp_uCoNluS02s0CWA3dtY7J3FTM
Message-ID: <CAKEwX=MkZ0MeedMdjczsuwWLEyj2asZsvt+2Vk5evEbRTZrh9g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: swap.h: Remove deleted field from comments
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50E0220005
X-Stat-Signature: iniydx84i9jufp9xnqrd4qwdkokx5k55
X-HE-Tag: 1755097121-318156
X-HE-Meta: U2FsdGVkX18QY78O3KitEqHuhYFwyy8vogdTfUirjlSD62sM0y2Bhje9g0POcJgZqaj7ZhxSA9ZOfqtaQyItSwymzOQ3Ez62Py/iYiu5sDNP7XA30/MorqGLGd9tU7NZdejS6+OyuBmQ51P+B5p+6YqF2OO2z88o1Ynyy6289CxNGFvsl0qNzdvB2bhNQRcDWbz65A9yTXEpWN1QBtnmotW6V6ToZgmoUPR5tEm2X4tNPvV372Ie4UeYn3ZWYKi5dVRHZfXEDiQHVo99eIo4eVgjO2ktZgSgXqeMVV0SLAQvv/sDi1eCESrgXCrNZRZywT26sS0ft2jGOO3Z3+jVLGLPdlBaAQdhMIVJEyNsKM/DdYCS/D2+SqZ+tX8ARv+X+3TnxAlRGOiZh3/njxP51RkxOsudsdx6loc+AKxmbWLV8urtkh2yOjtoZZmM70UEOKifirTdKCwEErNvoU0k1PevHfU3wCrVBIHhkdFDy1as61Qm4QZhDVUwxf1tdO/XeREXnVCGgWaEJGniHB2viwHT9vjgJHgZwyxbi2vlP+p+eWW+ezg1batwICt0KNeC9CRwiC806izLspvAyLkXHeD8SwIIcqmzkl+RDffV26DeVKOVDdrmbMo5qkPibh2uh0v8aiywJo1wPqp3ozlMzvp4yM0+F2l1VlCgVbEfQYGVsFndmM2VBd3ApiVkZpN7wFEHGT3bZhBxdPJ08VJ9Sua5ETLl/y3GEPzwLxqZVqqeomUAEeoAqvwfjJdyJLmlT7ODl/w+0UaIt4SnKBsqmYBwcAtPp7/Ed4LnQkbFy3BDg1MJq0XucUxks/nKImO+dKXxKypWxZxmy50IGat00IeqB2HeB6493fCBEtrzhIk9wS4q2v1OF3w0BzyXua/6ElwEq+eCF9xMtHIFKPTkWtaXByzJ0Hq66eYXYadgEFM+gmStr1RH3SYS8f0TIlCxyuCnlnPLM5hJdJa0RAR
 ES/qHUbi
 ulPhXV2KmHGFjykwKOtNu9H20bL/fGuKa29a7JdkirYHRZgbDXd+OVNr0DkZrBWUdRLruVMUbbdpIBWfyjDNCKFXBqvvfKA9PQw+MyRpCBuUqCpEDO18SR4ZGKQPEsg/+ca4zDwn91YFh8dRn5sDBPo68Nkrcwm7za+7NwqEZr9D5vw4gT2ph93ENcGLXAtI+J1bqp4QWUJpymBsP2KU6b/CjHWCNF+lla6c37LfXONucv9VGQ0LDNHWhBEN7EzPhvhc15qt+NNHlbEA+mdWg1FG275T799tWdH+vLQYUzr13PxswT4ZZh0uLMzttRxq7DHDUv7Xvlsb5XBhG0+1HLuJBoHkrcwPmmZpc+0AfSPGls5kStsXo2JeKCdGLGdLD/tpGaiBPiYTMU6ZuXr4ACaDGkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 12:11=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> The comment for struct swap_info_struct.lock incorrectly mentions fields
> that have already been deleted from the structure.
>
> Updates the comments to accurately reflect the current struct
> swap_info_struct.
>
> There is no functional change.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

