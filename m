Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D0EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87436B009E; Thu,  3 Sep 2026 09:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E926B009F; Thu,  3 Sep 2026 09:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CAD6B00A1; Thu,  3 Sep 2026 09:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEE36B009E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:03:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21A5A140525
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:03:14 +0000 (UTC)
X-FDA: 85172466708.15.D0D7EC9
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2E2C14000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:03:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OlwaiFVQ;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ob5eiYeuCZYsXL+A7MdawzkLmkoUvOE4FfKBJ4ZMYwk=;
	b=EbQQrTCcb30oANReBTCV7GWB2ibQWEuq9fmorY098dYhgGE8QM5c2B0kofgFghyZOHlslj
	SGKvqVOg5C2iuKJmyWRoIDylDtSa0UbFkz8LqIAnU7poJLdpO9jWU3N4plfEFMjpuynGN6
	aWDupmnnvJ9OPBTBxyL1HSzIS/PPklw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788440592;
	b=ONBaKoKt9g7BOyHXWgjmWoDSjYgBwVD6lhxLdUHyL4Vg5mANKt22zEFDsx9Bp6W2dh5eTq
	Y7lU9k9/nBZdQvKQ/WNDhDoQuS++f1EsKEuHpZGIRa1s1UGU+UbV6ySmO2S+dDxc0NFS+Q
	6pg+nJzYJd9pbZZWJgJvQLo1/y3nipE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OlwaiFVQ;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-855c26cf490so20714227b3.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788440591; x=1789045391; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ob5eiYeuCZYsXL+A7MdawzkLmkoUvOE4FfKBJ4ZMYwk=;
        b=OlwaiFVQay0wMiGcPAzN3tMH5qeeTvIcdJ3s3SLVG4qbhc/hXmzi6YYFP9/F6a9kPo
         NIJw1VypfHHb/JTX+o3umxlDd3KG/C2diZqV0/cV/PktahcKU6lIe+Mose3Zft95Zrve
         izBulnZV8zz0un9c38GX+pEIbCUL+JP847ZNQGTku1nEAF9ZWBILMr8DF86sVQ7vf+kD
         lltU5vakKkrcsU+VGn7q29CfDf4XGM2fXHGBffFnIF5jMQDvrWwD01tmB0NvX2bJJYYa
         COhmMSfnbwsgS02Q4SyBGbLGYHB7qnIwjuOwqEVfca8N2X3QdJGWa0+IT0DJYA6FXRVQ
         iErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788440591; x=1789045391;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ob5eiYeuCZYsXL+A7MdawzkLmkoUvOE4FfKBJ4ZMYwk=;
        b=ST7N/HutILztRa0s1SNaLtAiAItFfB2JhzRB7pThQPGluLvhjlZ3aqduWeYhsnoJs+
         HTcRcowpY+Udm59unJARKEMAXRmhctDoDtYfcZ291LZisFQx+bOstjHq/AYJjY53WnLP
         xqaH6EkjHXyROqKq+sboSeuV7Z7WWi7HxJJVw4eFiQlSkIxxP85PXA8/DjbMXkaQPxwp
         PovOh/XoBXcxYwnR9hd52NmuapNGQe5xlQZk1GxZoLkz/37QT91rv+kXCFX+cvomegXs
         W9vTe0fjBY4LyNGtGze2Tbl+QjIwH0HzY561ywnUS7Xx5oWDRHZNo8QPq6GiWoCY/71f
         H2MA==
X-Forwarded-Encrypted: i=1; AKwUvBybc4Mq9ffrPt5C7gpu/X17dr13+Bv7MHs1w/seesoLAabQKXvZsiwro5PIWibaxKTPCzlDlIowdg==@kvack.org
X-Gm-Message-State: AFuF++mlsyeifYTYRU0z3QFmXtlzdGbiSeZ0Rw+rV/LhNEMCW/EiU1yY
	V1W0zzblFF9d7hRx0UDYjXfUo1KfQIURNovrTbgCuZv9aY1gXFaNarOzSEOgdHLrVQo=
X-Gm-Gg: AYBFou1UTJGISnI/R0tywb2+vqms+4G8l0TlH23KqqKbdD6jrPUk1XjlkOMJ7NVnmUd
	fZfPMyWdwWkb37dBcxYbqEupezXSY3KVY5NB4Qxeo0NRn7/SQH3J8tagZOwEfdisc0lgykORyKW
	8i4DRybLnMlvSfxyuULzigAmWvquKF7HHfNEjmOrVnGAtnc6j6ok2mUyR/apEdhfeNvvcjKPw6s
	75d83l4I0Dmw4Offhi9jjb/o3bRxTV3Zo7iw6e4n1W0k013eCE5wTp3AXBazy5+MueRQslpfjf/
	GrDSxo3ul3ZDIx+SVHQ1CAlN/WkH6gcHeE9XW0vA0x9pvwPYcPze6JsUf56wyprLTwR5b9WoUXP
	6IuxE1ns9SnehrNYIiHaexLlSUrL1wlRy+MtX89rq/P5SObvrMS7ZeH0QWpMDrYrVFtOdpL+JQJ
	nnMkSWB8hIckWqw70xoP+F7Bw+hxW2EJZOY/O5ZB8rXzuhK+gE0UTjkwUTcdRI
X-Received: by 2002:a05:690c:6d83:b0:870:f53:4edd with SMTP id 00721157ae682-8700f5350fbmr10493197b3.7.1788440590683;
        Thu, 03 Sep 2026 06:03:10 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c129b2eecsm39802527b3.15.2026.09.03.06.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 06:03:09 -0700 (PDT)
Date: Thu, 3 Sep 2026 09:03:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache
Message-ID: <20260903130304.GQ3004@cmpxchg.org>
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2E2C14000B
X-Stat-Signature: 7yzzfygoe49sk796esjcp4guqicsoic4
X-HE-Tag: 1788440591-244793
X-HE-Meta: U2FsdGVkX18SVZXVWVoT4F4TPemqtouEDkjJIvbha+8akMKobLcAyUJ2mCKaJD7/mEm13pOZgrmmh4SaeKkb7eaog8WBWrQKZ+77bqt9gNHxf1N1BMiRlTYXstPv5io3GHxVgab5oXcd0gWQV4y953VscRpTaD91SShrR76hsZZON0jp3nliWYG6eIJ0UzRvaOITte5/EbNHnA5uZfDDpSu30Yx+C6iSyTh6z0wYEnloitoLMW/dJaShXTSXIVwvZT/LBlzduzqnBTnCKAd+UAAIkCLrL1cXdF056rduFlKn4GMfuIVD/h4gl12Ms0yluoXUEV4LJQHIi7ot29fSXhs43SxG2qJ2HO/R5cEU97EEDG9dt1/2pCouIbEWZ2OCK+MbVbmefXK1a3OsCNXisZY+d/IZAwg9KDZhhrhIcCdS2tzVkpeB8iNxUp78MsrPFdeGZ7M6Vgz/KdqvqCnaqO3VMkYVhYrid2uMRUm8RGybJT01sXr048WZg9F84IXXVnr/BEgpyzT7tHDPFTUGGesDg44OdPzLO+JcSgEpxpGS8P3IAOLhOe79vSmDt8Tm27ZkCoNsLWuqjqeesquTfv3B+aScrMsoyzg+GduhJwVgYiukcy8m6rfK7P5f7Z7vgfBDixwD1K/9WsVP+F8/ZVUV6XPzA3eb7z7yd5si5Nr26s9unWmlJVtz2AcWLE7C/LVFn8d658dOt/7n7kEgvik+XtDJQoCd+Dqot/PxubEky4TWUxGnLw8lZe9LDjMwONXB0imy3/ucs8yHC9G5+Ae0oG7JgE2l/03n2pqtv0+aOG24DmHS5p9jj2YtOxjl975M+JwmQ2CbowjIv5dbO075gucbsPZ6r+gf4M348f5a5S+HrhWS5E8OHNZ3tuAiDUE0gOJkL9Tk+9qOV1bvTpJpetBQIGBkzBhPeweXXkhfbU566NDpsFGO8AKjoOWwI7oz6gWDOXfCthwMqqI
 BlMomAUf
 KG10SAu8zQuvoae7Ly09fIzyYTD8uyu/tYMHjpZP2+xKOaLoJvR7L/ZeCjbPl81sSgOaeCK9sN/KoxvfYdJ2oSoaD7fLQ4SqDm7KILYrDbU+zs9KtwImOalmY8qj2L0PVEFGejxoHNGh7N+mH6n9T6Ub8WnXD6Hv4fiHIO+ZEshJfa2arPUYSlndpawYXNZgkMvIobdw5nMdxKfAGimVONRYOO+H803JqP8pVnmxVcuk8tQStUq5W6YuflZ5zna9oUNklLG+V/+pUjCVjc/mKzwxFs51Omy0vtNP8M0Nkx/epauVKM3uG+ygaxqI+cWRc/4+F/MrkAlGWffi7oI6ZBZ8Zco6WD+wCMF3MNajhbp1WSkj+LAj1Ihr9YwHef+KmXKlT4u2hGlJKVprsKbpxS6MGuvgiLyW16Mz0YCJ/FlB3lg0oHhQ3GHg381UCJhhQmtd3WAFC/XmNBxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 12:01:31PM +0800, Bo Zhang wrote:
> We have observed some cases where memory is allocated with GFP_NOIO, so
> we cannot reclaim any anon folios unless they are in swapcache. We can
> end up spending more than 150 ms looping in `shrink_folio_list()` scanning
> non-swapcache folios without reclaiming a single folio. This is pure
> overhead.

Not entirely. There is some value in aging anon alongside file, so
that the next __GFP_IO reclaimer doesn't look at a stale list.

Can you describe a bit more about what you observed? What workload is
running, maybe you have a stack trace of which NOIO requests are
routinely getting stuck in reclaim?

150ms sounds awful indeed. Is this cumulative for a whole reclaim
cycle or single shrink_folio_list() runs?

