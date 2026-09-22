Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C33CC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 07:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9166B00A4; Tue, 22 Sep 2026 03:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089D46B00A5; Tue, 22 Sep 2026 03:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD576B00A6; Tue, 22 Sep 2026 03:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C07366B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:19:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 483EE1C271E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:19:46 +0000 (UTC)
X-FDA: 85240548372.17.5C221ED
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2BDA5100005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:19:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b="Cx5/Q/di";
	spf=pass (imf14.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.228.41 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790061584;
	b=LbGUuyvsfoQItlU3NewWi4o8YkZNP5c+PQoDS0NyzlZuygiGPxQ69C1VsPomxkjpNqLHXs
	08Oxjdos7tUCAjVlbTxc008NSJsBP4Hxt3mz7EIVdG9qmm0fitAzut4auXX/PYP5aIpxCb
	Sk4o7F5TIP0Wb9bbYHUTGAXljJlH0N4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b="Cx5/Q/di";
	spf=pass (imf14.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.228.41 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790061584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBX4z2VJhRPZnv9f6eQyJQ/gucy6LJHIvxxPIGWeDPw=;
	b=ZhT5fpxLgZfC8xrWGV84PWqLMJpqu7ix3ssL/3AJD5OSzVAQ+/Iarby4a0sS2Qlw3zHeLo
	M/rxoNaH3sixRG0QdNeqaRgmWMJ7UpTUNlh9RRprfqOT6AJv9rR0hfSRj1Ad+KtSylAcRv
	golFChc1T2a7L67Fsb5+J7YGdqCD2vw=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8625b35df89so319564b3a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dgu-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790061583; x=1790666383; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mBX4z2VJhRPZnv9f6eQyJQ/gucy6LJHIvxxPIGWeDPw=;
        b=Cx5/Q/di6PhHXchs+zoTIdroeyveo8nHfhrQBld5oaMP9f4+Wr8uQIt7LzDHei21Ja
         yoo0aAKKX6Hv64qp3Gb1r0aaSwR0MP5xN1xdK/Sz4NuPz/pHnUMyQuCjBc7LrX/4gyvm
         wV0HlAgt3+b6t3b2O3Tpi4W1dGWfpeCfwhRsiC1twW1Rs51s6z2zSoHfrxOjIF3qdKVK
         SaDtdo2u2InFNPQ2vqlAvXtBjk6lFFKLr8tApv5P80BOl2Qc6bwxgvJtZqGTfF0ZoGHN
         jOoKQJP8qtCE0VYi/HFHP04UGLLQfEe4XfUIw8kXhX8lWKM8WzDVOBzxUYhbU215cujo
         CH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790061583; x=1790666383;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mBX4z2VJhRPZnv9f6eQyJQ/gucy6LJHIvxxPIGWeDPw=;
        b=vms8lMxmpfOiCBZZue+ROoRQzbGovqEt5+JBXjSKT+ulbHofQw6JqiW2rlksUIsM1Q
         i2oRBDbyXeYEOeuqpuO4bD2PDLyVh362/43TGsrI4clylWSmHrpGH6EqHDBnsOGr9esL
         P/0DDHM3OJ7fLNVyLnBpdyT5In1+KEo7GJsIQMUHkp0n8GlcyXIiWFGfwxJKzqE0cB9n
         zdZ+URuV+4ps6gR/+BeSr1IEY+wzXW+mAQGF+YGwOp2cJakgpL3fDgyG0WrWZ/KzwnLt
         is6cd4ew4enjC+Aj+Jg8L090i0BJNFawT1uwcBf7l2u86rVA2CP3+zste2RYGB0TOcCh
         VBmQ==
X-Forwarded-Encrypted: i=1; AKwUvBxe9lvdi089iC8s1LcRXFl4vZ4o8WozmNmfRO20yeZbJyhi72/hpIdwlbuNnKfMc1fee/nwgSCVzg==@kvack.org
X-Gm-Message-State: AFuF++mam/AtunuXcPT39Ja8b65/iB7Rsp3ssdc0oH/GzU6eynITTT2w
	91dsX2az2kY0p1bXEdDFJ87NOQSEwTywPdt1w2iyANjrZEOMaHE46a0U/rb2pnEbxuc=
X-Gm-Gg: AYBFou1ipg33YS2BDD/S7ry2dOuWumJdmJw7urIDGqeKFRnPWCdsHelL2x57xV0zHHr
	XFhdN4XSppkK62gbp+YJUqblihN/c90YcAUwpLLC9+qVw1qph7fQfnwk/ToA9WE5PxeJm5N9Ap3
	urU2lxpveyBf9eW+K3JRpAsszSGdbQZk0f1u+IaQ3tR8S/rwpgejapyf1W8cU8JlH7ucLUZQpPM
	4mrsN+XLjUVseNmVy19SwWYuGO+SKdhLZiX0CXsZ+0fUoAxsnohlkYkZyH2LTEbxc+buqWj0NBF
	Ygjsk0tyYbPBtLNgxejEXj0WBmX4UmNJybuHpsYK3NxKUijSxQsyCjnoUC5fm68E7y9d3lgnG6f
	/KpXlqsqODx5e6q6RajD+PqlpCIFcEn2rcnoPfNvVB18WfuERiNAkqn8SITuLG9INm/sAj9GxFm
	7CFbDWNl3Gj48BqJ/TAug8PNohliAsIqoArMfvdsxemu8RgpKLj0fk935aRF1Ez0V3SA==
X-Received: by 2002:aa7:914b:0:b0:878:3704:e0f6 with SMTP id d2e1a72fcca58-87c8cbd2624mr162498b3a.28.1790061582980;
        Tue, 22 Sep 2026 00:19:42 -0700 (PDT)
Received: from PC2. ([175.193.106.181])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87c324cf14fsm397422b3a.22.2026.09.22.00.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 00:19:42 -0700 (PDT)
Subject: Re: [PATCH] selftests/mm: mremap_test: handle ENOSYS for userfaultfd
 and add missing newlines
From: Park Tae-sun <ts930@dgu.ac.kr>
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Park Tae-sun <ts930@dgu.ac.kr>
Date: Tue, 22 Sep 2026 16:19:40 +0900
Message-ID: <179006158019.123863.10328178989374348836@dgu.ac.kr>
In-Reply-To: <2e0a8157-a529-4355-bd7e-11ef0234b825@arm.com>
References: <20260922065143.118702-1-ts930@dgu.ac.kr>
 <2e0a8157-a529-4355-bd7e-11ef0234b825@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BDA5100005
X-Stat-Signature: i3i5nnjhhqr16p5ghcm1nt9f87ca6ffu
X-Rspam-User: 
X-HE-Tag: 1790061584-62225
X-HE-Meta: U2FsdGVkX1/0/MFgTkgV5l+t4UZ6h8SeGx7tkKsc5xnLeN27ujdHmWV5uCryz21zaTVqOGjb1TriCdEVUY0MULuXWSP59X+n80gfeIh7rBjMr9yEk35kMXB+/mjxvpy1AYFg1QY8dq6prj695VmbGYNjAglzU2s/yrwiI+CVy/3MhRI+eVfWsHGf0sdkXuUsjc6WKIMf1e3lBB2rnx7TaFv+lFay6cIO2gVqm3orxuXqDIhqnt9d2b79f4HNncM/pv5ldg6UfIJV3B0Zgko6dvFXpBy/nnow2jYDL/ILHaTbZRM9fjyBYb1fZX16zLN41rqL/IyNTfH6OX5+1OVE9/JpdprI19zlMmdiSaTXHksYkYroDaqa3KLcGgLglQxuG7OnWqGZ1HhtPLh7QySpECHa17pSodYeUK1DLGBAJGdCm5BAR7UG+l++UX3zNCXEaiDu0Th+tg2IapVlGZ64KCCivpD04ELjz3aa/DEHQQd0oem2VllAdsV4PqHUTh4o9zCG7uwYU+zSwcx/BXEtqNDp/6U4L7nmAEWLT8SN55EHjTdZJHnK6gztY9clzBzW8tR2RWse5h5H/fNBD21L+Leaqme4wzpkZR5XSfnXYsxdHNGclG7DrvelitC6ohOYuNCANM/t3BxwrSaxQJJhwXZ01C8yb1wPudhqxbzWWlCSLaC3gEcSBpi+U5IoYjuACTFQZTpTDMxrpwSxPkqzKeZeYzdYpFdkkf0B5GAh/zHdTC3NjjHRPF9Q7juAt8eehSGR+owYj0guoYqbOrimU9xliDwgZ6CtWdazhx5VVq18uQlcp7MNRC+989CHZQCkKRN+OLktzyzKtDI8u95wuF5gJ44KzXYudZ3GZ4L9nQWdCNt1+EwSWkK7TknYn2QRnZcsvS5jo8hjd9yiFsjzqgouKxPAVCZkY16q4l7kVjHE91y7OAfS2I3YkLwpM7wQXkWuAIvjku27DD6DoIu
 Vdxg6mKO
 oaXjHYywn+BVScBRrF92BMzjcbC5fjvgnijczstDhdSR/3MU/ILfoeW1KQybmE28JCLyLPbBoBKeguVwENtcABjXg10grd90kmd+ydkV1cmJFrr+foqltOYNfbVeNoNPqp3naPg+RRYEIwyLBQkao+2SnjTtqMI7/RF0sOuho7lhmKXMjZ0VsbxzobNLvzn8LKYKpc+LQ7r+BFp3oNbnYf72AZLwWYURNWsWRIDC7xBzCxMSZ6TegX6DXk3CEka+nG4+W0Pqtwud9I6j6hON7Ot2b+Fqd7jM5ttIbmDD044sRMhAG/0qYAT/EkY+gawhCRFmfMzGujgA9fv/h6fzQ6O0RTAjfRjYO6H3/hdyBmACda4FSgnp4KNR8Yj58Y+xaVzwnmwJsKRddf014egBRyYpGfMRAHGDzZ5wrl2FaSmNpF2i9L/MlVBepys2inBxf8On7PF6dQDkal7w+cdATwqQGE99AUHRXA/62oX0vy5cpVhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

Thanks for letting me know!

That sounds completely fine with me. I independently ran into the same
issue while testing mremap_test in QEMU on a minimal kernel without
CONFIG_USERFAULTFD, so I'm glad to see it addressed as part of your
larger series.

Feel free to add my:
Tested-by: Park Tae-sun <ts930@dgu.ac.kr>

Thanks,
Park Tae-sun

