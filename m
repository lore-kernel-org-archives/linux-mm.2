Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD92D3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEDA6B0088; Thu,  2 Apr 2026 08:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB00A6B0089; Thu,  2 Apr 2026 08:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC61B6B008A; Thu,  2 Apr 2026 08:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9BB6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:07:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3790B1401CF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:07:04 +0000 (UTC)
X-FDA: 84613489968.05.964B11C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A700712000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:07:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1ar6JDJ;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775131622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onBNEhqnvSStr+uFYhTmrvACp4SVmdtW6ghEj/BuMP0=;
	b=mMMPhUGJ95f5GPou9dwYlUBSjHoMwVo6x2wRp3qnD3iGpcRHLe5aj8kQhjGGj8g7Agj+rs
	EdpbH8V9N4SplNWN1mDFxMHVeq7I9usuJ9SQrUFp0okkwLYXwiDg4jqZAKE0o+rv6aE3UB
	7flhE2OhaFlR52V/2rMuwHu0L3fbgFc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1ar6JDJ;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775131622; a=rsa-sha256;
	cv=none;
	b=e5QAWkNk15FHSgIcPS9gD+Xmv6j6nRATyE/FDbNkDJ9R7LupJLZ+SAXzxl0ev+3tmdKswU
	s/xQ1z7sNXkt782JST/s5JGQiWASwDISIL5Xz3a314WfcfEHhUSuyG6k+5k0qZM5D4Mdf/
	ul9YGZ0geviaJioSXsjrM4jNGm+sVkI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05E3F61880;
	Thu,  2 Apr 2026 12:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0F8C19423;
	Thu,  2 Apr 2026 12:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775131621;
	bh=0YRJDY0hlF0nvCzgbpge69pz9CdJ/F2OpbMew3Md154=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=G1ar6JDJ7+Y4ix6kgBRCWPVO4hlNkcPXbqmeYWcUT9OzK/1pCvYkCljSGnZEROccZ
	 9g2xWjUqFx+RbMEObRj2J0ZbiPLDHZoJa6OtSoa3DfwU8jfrlDVNuKPU7R/zX8Ikgq
	 eT77oYOTWoc2yq3SEkwoPnoL+Vv7W+zCaZCZQZsPx9HTGhgpR249xpXF4g+1iDHO+Z
	 Pz0lidg+qDO5POkRgbElAFdYVXxwBYh7xhsa4zHAOtOVXpRc+5oJLpEmNJ8m/euGVM
	 zd69mHrF8Suk5gaMPNFtkILC1kzeV9xaL1PGrIMHdr4QJxcIY5s8jVLEFL0Bq4Kd6j
	 3mLm4PRWUVQdw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 7/7] mm/memfd_luo: fix integer overflow in
 memfd_luo_preserve_folios
In-Reply-To: <20260326084727.118437-8-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Thu, 26 Mar 2026 16:47:27 +0800")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-8-duanchenghao@kylinos.cn>
Date: Thu, 02 Apr 2026 12:06:58 +0000
Message-ID: <2vxzv7e9ftwd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A700712000A
X-Stat-Signature: twtxsgraf1qfqns4hpocmmp4zr11h1yn
X-Rspam-User: 
X-HE-Tag: 1775131622-596180
X-HE-Meta: U2FsdGVkX187T+mlSRbHMdGZYjrOl74BdS13YSRbS4bC9ckk1TKO+RCf7tRnY/svfeKsqxviV4b8QBeWEpILtXCYvenoyhJ1ZFZ7kS11g3nhj5rZGg0iyw3B0xzbN5GVdvG4MwPyT4nDxS9Xw5avx0eL3j9BwSg21vqmEA/0VRwYXrVrYkQcI0ajIW5UAoh2BO8MlbWEvNrOU4aTdjVhWvQTfMXAHi20bcSIzbT0oPVKYGZm7IDFTioP/i3IlyS5SVWsI7orS6Z9//v01v6ZAS9X8vmgbPmAG7NpsMKGIaCAFIK9Ufcmjo5I+jCKy2JJwemsOPaBK8mvjOgc16+jduL/og3cbUrAatynrsK5OiNw6Ie8sX8DenJLTBwmob1I8sVXA+NM9ShhB65z+Ddz0Ke2OzG7te3XnOUR4I4hRWlc1vQJeve4a/qxxxi5L92JU/gauOuZ8Tp11QqilAHuR3VNNHZeYX+bTMB+bpqsd+YM0Y0Wi/rRsROASqIWCUiOTtQGIqGBp7htRX3F36T5+k6WC/n83gRv0sNgwYZchfTZbAd0L/YOHlHagJ3oxVznrEyQNY8GNZxwgdtqDrxOJNy0uc8qxCP+Ranx3ibZ+sVbzFNrnoNkx6nV0UQ+ZHmqv5mwGvPdGeVzfD9nHI7LaG9OEPfUnj8etVyw9L00OwhRJnWTpvjq/QdVsTMIOoZa0YpwWxeBfMZS/UNqAnvMJdRy/jIBpGKSzDhGz2ueP6VOHjR94K5A93afzfXpuGVZHEK8GuM6a9OQSNRRJ9+/icXBTMR0GZOxxOEO7x1H8Zk4x8Gxc9li0DoMtuLjnNw8U3mPJAhoYvzmpTtZmqbVbRw0Bt2Slrc8NBz5RrIjP3sSrXxS50N3DemyrQTH2j6YubHHqGDwisqyDCPjMObUl3gT3jfpIpeYnlAHVoREI3b8RX4sJv2gxeD0e8kXdPkI4U5QsAa6xjXo42PWKki
 GmBaPnjo
 vxMptCM5KoEjKe/izc9AiRmv0CpuWwxlRRCToS2GilogG1Rof+5d+cpdxkY1TfFCMzzsEftvtVK4Tnas6a3lJhZ0kle4qSI9RQkpWuKaoyZDzyhI4XzKAw+WGqB3Qrz55lr/1siJ6CBTRI8qEr8EGcZbUCx7A8/hD49N3/9giCv7CHMk0irKDLAc7M9RHXQjlDtEMeeCnHbqWm0JMkS1/YQ+N6giGzZKCEW5c6AWqNlL5I+bFKqoR3eEqhq4G0qDoppozOGh+C/9ADZOmBZZEyButfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26 2026, Chenghao Duan wrote:

> In memfd_luo_preserve_folios(), two variables had types that could cause
> silent data loss with large files:
>
> 1. 'size' was declared as 'long', truncating the 64-bit result of
>    i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,
>    causing the function to return early and discard all data.

As Pasha said, KHO and LUO are not expected to run on 32-bit systems.
Plus, since i_size_read() returns loff_t, why use u64 when you can just
match the type and just use loff_t (which on 64-bit is long anyway)? I
don't get why u64 is any better than long or loff_t.

>
> 2. 'max_folios' was declared as 'unsigned int', causing overflow for
>    sparse files larger than 4TB. For example, a 16TB+4KB file would
>    calculate 0x100000001 folios but truncate to 1 when assigned to
>    max_folios, causing memfd_pin_folios() to pin only the first folio.

Using unsigned int was intentional. We pass max_folios to
memfd_pin_folios(), which expects an unsigned int. So this change is
pointless unless you go and update memfd_pin_folios() too.

I think making memfd_pin_folios() use unsigned long for max_folios makes
a lot of sense, so can you please go update that first before making
this change? And when you do, please match the type of the argument to
the type you use here instead of using u64. This can be a separate,
independent patch series.

>
> Fix by changing both variables to 'u64' to match the types returned
> by i_size_read() and the folio count calculations.
>
> This issue was identified by the AI review.
> https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
[...]

-- 
Regards,
Pratyush Yadav

