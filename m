Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2ACFC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804A86B0092; Mon,  3 Aug 2026 03:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4F06B0093; Mon,  3 Aug 2026 03:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A43E6B0095; Mon,  3 Aug 2026 03:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 474666B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:33:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB303140644
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:33:01 +0000 (UTC)
X-FDA: 85059141762.04.328F458
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 355AB1C0009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:33:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cztgAZfE;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785742380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sc3ti9VahDQD+o7JET/jvG499uuDfICvW9Jpo401Cww=;
	b=1gt5TlLEua6vJ3YB+d50v4H7Fc8K396BCOZHawb2i0fd1mObeeCwT7jLkxAc0jSm27Qsvp
	sVOKD/Jx+dK5CCwl8epHmsOK2V5R2GneE19k/gq0mRdxjvJ3LMZteWlLTe7PoywtGZO7f+
	Ida2u+6ZdKORgYJTlSXnOOg3ncK1b+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785742380;
	b=FYGPyGG9UTKeVqKzgzohZXlj9rcvT8NRbCT53W1uVn/yRjHRLd6kjunLfDmdNdjv8tw6t4
	dmin0VkL9N/uDGnpCDF9F0NSGsWSrhBswZoL7umzfDBI5jH76hZxFbAV1XttgKyC7xsc2W
	W52qhmDqKT43jLSIYtr5ZDt77yxwLXM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cztgAZfE;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A56A9600FF;
	Mon,  3 Aug 2026 07:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A807F1F000E9;
	Mon,  3 Aug 2026 07:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785742379;
	bh=Sc3ti9VahDQD+o7JET/jvG499uuDfICvW9Jpo401Cww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cztgAZfEmYTOrL8/HN5y0Tqx9RlVBCjGy0NB4QPs1EtIp+pbpOPpxQAKmPNEf5XjL
	 iLZ3k2g+Q4pMQuCogHdLGTNpPrBFknM5Cl9BR7ULlPxjLw5cem27D4LiF755dyETIS
	 O5QlV5MHCtIbh3K4Jffxtlxu/tht28sF3TburoHUY3f5jvngPfC6BwyeZw7OXUYek2
	 6Jwa387Vj9LUpvRu35yR5buDduvlFdwJ82cGRXs3YXfHg88KUrVuLTMmiEtfpRSVby
	 9hfm3mOnMBaSbBrQak6FARwj26RmHR80wBDOTOYusGIubEyvxeA/GR7Ma/1gQ+O6Ko
	 qBrW0LQFkAcjQ==
Date: Mon, 3 Aug 2026 08:32:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
Message-ID: <anBD-_khxIX-FzW-@lucifer>
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-2-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731083526.3953421-2-tujinjiang@huawei.com>
X-Stat-Signature: 6hjgr7yw8th9xufzu163uqp36mxw64cr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 355AB1C0009
X-HE-Tag: 1785742380-222645
X-HE-Meta: U2FsdGVkX1/CYd6pV3ZMDLQv3D4nW/6jgIvOKyVOsLcIW4hfNgIAEG91hUdUtFDsYj+gouwkqu9OAWFTCbey1nPSGr2VoWTz2sbTiDFt7zM1JQ90oRoexz4ZAznQKZv3TlKsopSqGEgmSsVd8Jnl+lJ0tA2woYoPAXIKbF/+2WaLylcFsn3nfylUEczLo3T5lOCpweXryB/MHbcnqoLWxelbUMIFzQ5940gd//ic3sYbRHRlDo/e78voo4iVAnk7XiQy1W1izJHYYe3Ohe+L8Wp0qzXy+neBHAAlRq+gVV5RKpK697aUEiggg8k8ffjH36zksHyzpMn2eExuH1vMWWXEH0Pdn7Me6+HvyaqHauIDyeKAhsgWJpXBCu6GOp3VSmuOx3YjqVrsOKAsuJyKyi6Cqe7w0eIJXWusX3QHM3Hv7iloychv3kcPmgcnOr7TcisEAgw7Ol8WUl5IcMMlDYUE0aNaqJ2IrVGjNUjoom2AK2i6IRJf5cGIB7FxaLPSmvdtVRpUiItAiTrsLMvLb7fPFWD47Ri9H68QBYPh1SS0fy7U+T7dCCSnfOjfVfY0OmOjAnwubMKnKguvMWfEG3lY6411iJVHnKgpR1LfZqCdTDIj91iHBvgXSXJIBONqX2lS4qkBx99QMgHY5a+BlOCMXw5eBXGu45LcZ6AQ+DW4bpvS9m/0/wxX/RgM8DIggbKruLiwOFGyC05e9wHBU2mii9aSaY0WR4nx9ep4SHWCJcfR7q4+e+3I5V7qNk7RI4UrcWFZHKUdG4TtFJkrFl82IwmEekShrts8WZ4sGKmkS3cZxn4KRAZ4paCd8CBTu9+L/EF/s1Srb5nwgcexEusjsGKdkeP+u8daazL+VVA3cz+28hRs+PGjf+ukTFgOI/G6xJ11WA0vBMHSfiq/VK2X5a7vt9HoAfc89k+xiygrNV40frSSi3KZucEgbOsP02zhWMfgeeqkerGClw2
 D/feqL2M
 9utom9/cKu4sOIl9fxiYGTQhbcwH9S1ocG7Wfu7dRUXlrkxPTd6Vr1nbId5jo6FyJ1HxsFPJnoMXrkapsVxQ8iLdSdiVTrePAXmVOP850e9e14dy+Ug7LLuZUEpqOh+LI5bCujykgDiZKzxQwCu8vZk/Ia9HEg8nKd7Hzt/ECsPFC73aB7KwFowfEZSqAT1IE/pqCNCBMyk4h1W3YbGEtrgpatBBCaZOXUkK1Jgfl7da4p/Kmu6/+cVhyQRhBwRLmVIbq5lsIpVrPXVZKoYZazb7+cmpmZ/J/Bud+UFnSlFxnRsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 04:35:25PM +0800, Jinjiang Tu wrote:
> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
> both as "adivsor_*", fix the two typos.
>
> Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")

Same comment as David :)

> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Anyway LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  Documentation/admin-guide/mm/ksm.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index ad8e7a41f3b5..c9f533b10f6f 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -174,7 +174,7 @@ advisor_mode
>          The section about ``advisor`` explains in detail how the scan time
>          advisor works.
>
> -adivsor_max_cpu
> +advisor_max_cpu
>          specifies the upper limit of the cpu percent usage of the ksmd
>          background thread. The default is 70.
>
> @@ -186,7 +186,7 @@ advisor_min_pages_to_scan
>          specifies the lower limit of the ``pages_to_scan`` parameter of the
>          scan time advisor. The default is 500.
>
> -adivsor_max_pages_to_scan
> +advisor_max_pages_to_scan
>          specifies the upper limit of the ``pages_to_scan`` parameter of the
>          scan time advisor. The default is 30000.
>
> --
> 2.54.0
>

--
Cheers, Lorenzo

