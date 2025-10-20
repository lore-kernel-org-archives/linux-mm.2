Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7964BCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EC28E000C; Mon, 20 Oct 2025 16:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF978E0003; Mon, 20 Oct 2025 16:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDF58E000C; Mon, 20 Oct 2025 16:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA7DA8E0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:27:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9677786D03
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:27:45 +0000 (UTC)
X-FDA: 84019628490.12.45A924C
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC09640005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:27:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Aatf2q3A;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760992063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZAR9SssPQwBAqxjhFTq7HnrtWlYyCmPDIdAbTnHEWQ=;
	b=u6GfJBzOllOhVm0ATW0/J5Id9lqVFVIKHua0n4A8msD38dUv+VLakJrDSPZmrA4WxubEG5
	CNK6bWq/8pp2coScqB2Tthogsx3+JVDsilBuVejvsDrNaoZs11hbPrt9JqMgqZGLTJwEav
	G3Kf4eLp39tKvxIQzEzOnlcVNoLqbG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760992063; a=rsa-sha256;
	cv=none;
	b=SPOliNWA5BKkLImgse/85K1jADNKKXpF76hwKCmAB6PbY9KIcVHqU7tBWxeHvDoRgvFjHn
	WeScLL9qDjgxpVcqO6i3IY3TRWBJrwSIaXbH5y9Xic30Jvm0Bld7NLkojmGGOQzaRwd11K
	fYEBOJwMN9Q0fkEJVDwo4HSG9yGuQ0c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Aatf2q3A;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-891208f6185so476596585a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760992063; x=1761596863; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aZAR9SssPQwBAqxjhFTq7HnrtWlYyCmPDIdAbTnHEWQ=;
        b=Aatf2q3AgKdMQulgtR99Yx7G3+Z9lInr2ljBq3ZrEzClqjUthuehkEg1XNVMbOrWRI
         aWOSxaFsBj2o76G4fzgmw3w257HZmzV9hUI1wm+g5wj8v/uE5ah6RtYN9e5LBqzR00CP
         TcqNyKjrgVnDFInuq5K6lz3nrC3omlJGJJ3dxWtxsMJBQLb1SMUqyKDVM/ldh5LY/OKc
         yACI6NRL0tRayYR7ELoAxdaXgatjgsYgAUQF/MYTkTS8qEQJtC4oOeSBqFpzkiCPTw++
         vZaaFCKuTCdF61QZR8kfN91T/m9tF4FQBSZZyOusDayAJIsy48MQtkrUTRc4y8ks97rm
         T+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760992063; x=1761596863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZAR9SssPQwBAqxjhFTq7HnrtWlYyCmPDIdAbTnHEWQ=;
        b=ASLzB5CDTbO4T5h1E1lUfYW7GqG8HzBZpsJSy7ioyLsb+VgxUCT7hfZ+9/xx4NivKV
         /z54wDAqvpUVkROXXTHmgCjqXUZii6pP3q64V4aQToulUIKdpQsUgp8M4eYsS+vWYRqS
         U/Wmql2pGfll63k9n9KmT13dkZoYotXcxSLk4GdIB4HIONAzMjIJ0U2t8viad8kDLwhv
         Mip4p6jvOhk690tQI3pjsUVVN0ZixM+TewiwKSEqvhEkiEpxkUKl+qrKsRi4J0ywjBeD
         QZAiOfGJ+AKE8f+ub4utocnsb2MWQRy4T6QoF8TgLQNtQLMwbEasQfrePRLY1JKqaQB+
         6wMw==
X-Forwarded-Encrypted: i=1; AJvYcCWoY0ESh3cM2N2HQ6IHtyZTEqUchd3qpRXyc5YeB5lEt/R4SJNdVmnrOqIrFZaIbQpqOD5A5YRpMQ==@kvack.org
X-Gm-Message-State: AOJu0YyzgcCJDmfnujprT9Ey4NSExgCRn7sE+S+Yi/FbCbYgsOZE5B1s
	rmDUKVkesxVry7zHMlpz+R/S9MuPMjZN/squ3Qp0Ry7i2XT9pa8+F7jI7KMkLfykXso=
X-Gm-Gg: ASbGnct+a3/zOOepa4cRb3vQ/eBQ5h1mx2tf+hv92QVe4gzGHvV2Hxtfrt1bR5CUpxX
	nXOit2rpoGQpcrCnJZQAt7XYrDMESc1c77YzyLrjBbKBv28/R9dxkpHphtFnD0ezHZXHES5bnx8
	GeeESMpkaAxuWiHd4cK6Af5JVdk5PxBhgCrymUHz3KGswMxn7d9v/U0uQhwb7kRCJui7owh5nH9
	lYiVc+QvUsmq0lPEyfFpGUCFq+ZH7m+5kfWKzn8sT1vL7tbA0NwwDgXgp4dnGM636qhOkyCDhha
	ccHgTFI0uATMvJcZ4AHuArypmVz4UfQdZsjzSZbnNJe4PRkPCMSM+0tvyCPWC1yi8Wf+ap0ZNe5
	F20khD77EwYvjIQQhOQOHAnSGm+OUYeOMb+f1DmV0Tv2RpZLX5zW+IrYChg5nQX4OBBfVXV8F5X
	p8McdON326Hy0RoKzja6bj6unfT9oHF356B+REAZEFUc4K3rGyF1Dcg1UASxU=
X-Google-Smtp-Source: AGHT+IFNSyuzqB2My2z4Xm3I40YNadj+tQNgS0RKzLB/47h6w1YVPgpdgKfsMPIyviG3eSdWQLOPfA==
X-Received: by 2002:a05:622a:d03:b0:4e8:9fac:d6fc with SMTP id d75a77b69052e-4e89face203mr174400271cf.47.1760992062744;
        Mon, 20 Oct 2025 13:27:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cefba8f0sm621073285a.40.2025.10.20.13.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:27:42 -0700 (PDT)
Date: Mon, 20 Oct 2025 16:27:40 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aPabPH_6FxPgPKM5@gourry-fedora-PF4VCD3F>
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
 <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
 <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
 <0d92a675-ab24-4b1c-be71-956f09a9e973@redhat.com>
 <aPaUZm0ZfIEW3gUr@gourry-fedora-PF4VCD3F>
 <451b72a3-8052-4dfb-84e7-1e97c3388db0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <451b72a3-8052-4dfb-84e7-1e97c3388db0@redhat.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: rujjrxz8u4sjsb483jq77yqeka7iu7j5
X-Rspam-User: 
X-Rspamd-Queue-Id: AC09640005
X-HE-Tag: 1760992063-61345
X-HE-Meta: U2FsdGVkX1+Qrs/OwLlMckpUoEOICwzIgRh5QDQT8/b3cd4H0O/CAYKdoNrlRTD20S+dLr5CzqjzO5LOxEzIFQz96yzsCdqSuQpv5ba7nmnOWr8vOejtj5NmSdreu8nXXUSs3Cy800kfdPsx0Iat7kciKbKWrgubVLkJNJgF3uyJeU0a62SkK124fc5grVjAuKF4sT1p4LoN+VOiZV+O863i7c0U/b9vPdsLHsY4QhKFXgkMmIdu8rRok0jCOCfP1mKjaQ4SsoOg9Ez2t98vII4+NcFyRqaeX/FhghICBPguDccofLmEEB53ffv1HkHBcrmseV4FBJydj8NV0DrmjjBrb4BxOc4/MiAQXJFW/QUb7pPT1GO/bHJXntIM5bmxsyUhKznNT6Gw2OzyLzHxTVpZxkj8yY6pLXhyQkCMaiixz2vEQDCTYMQUMuVRW7NVDwULZKvf+kOHUSJ36ejvsCnulKB4hC3k4/Od0R4SrpmCUDhLPTmpoehSNVfECpRwVhdyzaB31QOgzEpC1t94sqRBW7OL1ltPZ+cFiVM3cq4jv6cbP5CQoxp36CVal/8Wr0artFkRk6ADlL+r0jTwIZELTkRmAzgdhTu5BhmI949N8ml/VYr65/+pxTvoTDAXj/gWQTy+K6s8HiXQ+D84Twb2z+xC7b4WHIJSDFsdxYawB6/vYg3JiYMWXgU5BFiY5r4SBXDvcxBdKnjeQqy5jJ80S1Yy/PDxtwaHZiWz4/HDxDoYaSK6SBBTA+CEQ62Vw1loouFGUqRwiadbKQ4ttNs732PNf4CikjI7a8hYSOtTwXNyw6N8Th8w8KNL02ZlUA/V5noSUpaqdZ1r9xYesIvTK8GE1qP/JZqHSzkOXnhTIrOFodUxJxNm/muqHhQWhKwxQ3obVzMrvGh/i8plpST/WYnDEzH9HJ4fcKXTOzn14ql2y6Q39PrMo5rq2YHkK+gs+xyZ8TjummXMmJG
 Gwfl6VQn
 +eroHKgNNX1LZA62uD+btpjB7JnD15TOtI4M5YIoTYzI6b0NZER8rL8Ow3wcEQeYLBdxz61/wKeJhNeO2pU4Kv4Khr22jyPpOLyuVT825JlaevyzjZjK/5btAaJVGBWHsE+3alZo5iLsVgEzQWT4C4G/4iY1ZR9Nx5icvLDU8O5HhRFJM9Ls1lIIuN+XFfTpfgFHnwZ7JBira0huwi9b9lrygN9JhiEpUaODeDKSCcgn4yITi1vDQrO1uWhhwRmhbz3CgSgwlRzplaSUWuQ4+XEfO/ShcYg2x0bWXflspDK7RMEIEsKPCFCsCRORQDTkmM/7kyyC10lw4i8kmDkZtxxxYRF4IQU8Tmq2soTVHaewB/nI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 10:17:42PM +0200, David Hildenbrand wrote:
> Yes, it's completely racy.
> 
> I was primarily concerned about us calling functions that will VM_WARN_ON()
> etc due to the races; not that they would make us accept/jump over a range
> although we shouldn't.
> 
> Of course, regarding the latter, we want to try as good as possible to avoid
> jumping over ranges that we can actually handle.
>

I'll go ahead and add a snapshot_page.

~Gregory

