Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61420FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970AB6B0088; Wed, 25 Feb 2026 19:57:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952736B0089; Wed, 25 Feb 2026 19:57:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888266B008A; Wed, 25 Feb 2026 19:57:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7580A6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:57:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07640C19F8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:57:37 +0000 (UTC)
X-FDA: 84484794954.14.9CF002E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58995100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:57:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHjcPwVM;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aY9V24uTr1/JJ6EREQlykAthH4Gf6hPUxAJj20GQXgY=;
	b=XyGhAayXymSuNzhRTvZSyiNLX6eZW2/Qfer6FeuIahS6AIRxsJfpDkzjMtM7BUa5Ji0RNu
	S6UaocYSwIZiHH9hmIl50ljl/gcywROapGv+D4X+jhIW5Iqq280BEGkwaMarNPdqUj9hzR
	WfkA/rVzYx13McfQlSgMy0d2PbWODoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772067455; a=rsa-sha256;
	cv=none;
	b=aLKFR46Uj8Nk+h2aHMqW1ZnSoZsw5E/1h/sVk+An4y3s07cMC3er9vtSuS/If3gi2K3h9i
	0z2HE/SHZaqK+kEhUYyRouhEfG0IYXaXpjkOQswP3isU28Sd4qzz8Bd9nix3QBUDaQDNKE
	yXj5q8JMGqAneNmrx8YfAM1c0sAK4qw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHjcPwVM;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46A3042DA9;
	Thu, 26 Feb 2026 00:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B9CC116D0;
	Thu, 26 Feb 2026 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067454;
	bh=q+CQwYcdbwUOFLj1CvBSURNbNPO+bp03YTfwhYPOTHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHjcPwVMIAiYYEGBpfx3lHSd2/P5d+v7r7FMnMdbXBEreVOIPGcqXj/x8x37W0m+P
	 ZoVCh7/EYXI7+v2iQWInc4bblq/Xo8qwfvYfa0MXMm2X98mvfcxxswIVe/XB08gGmU
	 dL+I4Dg36/4j2fxy05Tw2x4jV92SNhMQ0D4hH45lRJ2oroF+b5TzxyCO8XmhdTmgTG
	 Z4BlqIugl8mG7tgBgxAkAjF18S3fMuP7xD6i2rYKslaMD3qyHa3CrnASC8Yy7gU2ZD
	 W93qa8MSTPadb6O3hrKYNoHZgiqXuhNtD2GcOiTJXVo4pAuiDD4ab09sYrZcuJamKI
	 mDdnezseFomPg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 3/4] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Wed, 25 Feb 2026 16:57:31 -0800
Message-ID: <20260226005732.7839-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y16T-yNPq75s_PWwEJAEZ=r1YVdd7AyRMA2DtS=BdkZ3-w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58995100002
X-Stat-Signature: oh913uj61sgninb7tu4butrra5pb5msa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772067455-338904
X-HE-Meta: U2FsdGVkX1+X+f0mE8x5JTCluMSyznzkWutQv1fHukIfmXoBGRvqCMargLLNgtR5NSAl1U11NSp5XfIEug29hgqS//L3L5tuAqjG2aIjLbQ2S8LpWjktsJoRjIKIyRwL8egenony9LrZGb5dytrusHaAsf6LTk+em3znwLxXG6sKC2AF1dhD6QuhU2fTULzK1jsOi7bO4nBN/MxxIhc9to7yubSeldXhf17p7QFNFUdyY66Yx4XQRYqNJY2j1FLXEPvk34fmQt2V0bqduefukf34O02GW4afOL8XDQQ20fdmDutWjvR+4aey3EGyJQuPxTyIjkLFFy+oexmwW5LTsD03aT56/qa2cZNkz0KsBtRDlLl++5mMDxfY29hGLuohLX7g7GZKk1j6ddG9cmzGSPpQCOcFUn9++fHiWRLumFG4RL6bPnoMebIYlEe2+asm58THFqB1B5Ojxgo9coIDiJyhX2/c29Hawp/+nn1dSvH2Hyf4Jk8P/LShRkHooKnsnpzDnJ2OH7XTpaVaM3RjwxGccfUr0bARA7xSXdBXYRRRyCvwveiOhsoB7xuA+73WLXCTYK+VOwR69WvMOiXtBojUzRkhZzsPKbmJtsH+lCksjobug3ES+vuZusizuQq50ykduwa8UzfGwwJ8EXzzylq+cr0AKVBc8kjDq5UTC+k5CcB1Iw5NqJR65YV5HNVsFoK+vSeAlRRrbWDkMPj43hjMXXbC4r55KR66T5+RDFShQcMAoPOx8ZYM7nLncabCYwIgiMR8UuMBV/9LMyXEx279avVEPx88xmz2sHeDrXocxzgPJcJGOt90ujjh9JuE66+I4ZaTWkct00NDXrdztLeXRKnbCshxG0rHL6lSrbOi7RP75jQ90wPj+lOLIpTgl2ye9xh9jsuUCNjFx9BbaWYAX12W5a2MpAf0/eCLdqVJUHGNI6Ud6hc8+FSqjk+1gi8ZZK0jiivMKzJUO2o
 EV/A0LRZ
 4pVFNWuzkBKXxR8/RlbjDQwIW2XgOv76qIMnDRwKI/SONqAYG0BNjxGApBCYjIidWRl9PQrKxF7suo+Ucwk1+i3KgyUxKoSwA97KMQNKAvNpuM2uf5FcmRMVf7Ot/js5UM5pKewYzARYPYGQIgxi/97223ucrA1W4toNEe1uLU0AUKwiQGnBXgOgS9nayGDQpWmwWy5raEZgESIHG7yAD5uQ2d8bnZ+pmpWqEUxSob78TaYZ1OOUH+G1xz7QEm9gqEq9iZFSGh3G06oA49z4l18SZtKY7brz0GyT3eJ0hxWeV3DFQG9r22P30BYmt3QqHOXAteRkjC2PVJlHxIk5UplleR3NCZkamL1CgfIS5/D3YydDS24wpsZ4/IrRio6f03SC5p9KTxILnsi03f2JVyFxCs64RBar9/1wX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 10:46:56 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Mon, Feb 23, 2026 at 8:27 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Mon, 23 Feb 2026 12:32:31 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
[...]
> >
> > So, the overall concept and definition of the new goal metrics sound good to
> > me.  But I'd prefer having less optimized but simpler code, and nodes boundary
> > crossing regions handling.
> >
> 
> I'll prepare a v4 addressing all these points:
>   1. Fix 80-column wrapping
>   2. Remove eligible_bytes_per_node[] array, iterate regions per goal
> instead
>   3. Handle regions crossing node boundaries
>   4. Pass scheme pointer from caller

Thank you for flexibly accepting my suggestions and listing those again here.
All looks good and catching all the points!

> 
> I'm currently on a break and will send the updated patch after March
> 10th.

I hope you a great break!


Thanks,
SJ

[...]

