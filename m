Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0275210FC465
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4786D6B0005; Wed,  8 Apr 2026 22:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FFF6B0088; Wed,  8 Apr 2026 22:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CBB6B008A; Wed,  8 Apr 2026 22:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2608B6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:27:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E3CC13A085
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:27:54 +0000 (UTC)
X-FDA: 84637432068.28.7F57CCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81F251C0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:27:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTHhH5PI;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775701672; a=rsa-sha256;
	cv=none;
	b=dDW/LVS7pMR9KHYmHv8k5CPD8oA5uDwjvTU5fMREJpgIwTXsx47DBkExz4xb0AQWKPwu6u
	w1kGy+AyDQOzwZMujm4K3OCx2DarMyMnP/WyG3yoIzL+tOuFenqBNV4GGk6Vu1T4DD9bsY
	2RmTVCo8EHjNnxMC3e08FXe5NFljlKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775701672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPi3lm04sHbgQE41/IAGLyaSBuw90y/u3eFpV2u5Aos=;
	b=ru8J49xGec1My5gPpfH18c97roo31lq5VD+ww4PYQEmpq3zAccQn+C3/eEH26PyCK5MirF
	VzD+BVRxKY/oZTIjGLW8Z3qkIJeYXRjLSUsNzv0qMPVSafu05sms1kdzBHP1/IQLRUkN8q
	yHRSfcU+4kV5bjZ/nfSFoKGTscmpnKA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTHhH5PI;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D289F60126
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634B3C4AF09
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775701671;
	bh=pPi3lm04sHbgQE41/IAGLyaSBuw90y/u3eFpV2u5Aos=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WTHhH5PIIplErlR8SQJNbwhpyfg5qGUOK8dsw+zXQpNbgkdap1dcY6LO2x2/NthEm
	 QrT/2YUhq3zKtdXNJIF0ePf2oT2fMir8OCMRZIB40zThJWYrGxYwrRrDOlVYNSTPCR
	 lLqH6SnY1TiDR0GaC9PwiWqmrQNzTbks3FAk5wQnzdwaXEb2QFly5a0mhr3WtrMfeo
	 yFKC0SUaOfHV4Fzy/jN3c66UIOtl6v/p8/fvT9ZB9y3ZvWxj5D7+OX9f7iBUNn437R
	 CrSYTYl3CCXhi+zPktdVX5s8wpP0DCzj7IxFpX4bqegQvHubr2VOQ5FRT6e8Nqoc3R
	 oJ3il4Vob8KSw==
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5ff05af29b4so124339137.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 19:27:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWirziEAL0o7QGTuO4xoq7aYzvdgvZOwwTkotWCZ56Zuu/OgZamSVidqBLo2sPZlvka5TeBAUkN6w==@kvack.org
X-Gm-Message-State: AOJu0YynzEd6SW01xmgfet8lJoGpt1fufa21lTGPz6OlKKd3PbPTTW5j
	0XL/jgPpiy/P8RAgREoVpFYEtWq2n4hjbCRLxFfQR/1XTcNzHz/HVK3tC2UVqhvVeDqAIYveT7n
	H/mPd2ABIMHbrhnIsasxsXyX1SHw8xSk=
X-Received: by 2002:a05:6102:1614:b0:605:b96a:a0d4 with SMTP id
 ada2fe7eead31-6085eab3ff1mr1058862137.27.1775701670512; Wed, 08 Apr 2026
 19:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260409014323.2385982-1-ye.liu@linux.dev>
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 9 Apr 2026 10:27:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zb0BH0ipUtft_FUTyBYgxV69V-Za1xHLN8fXi3jBaXeg@mail.gmail.com>
X-Gm-Features: AQROBzAEKv6EK9eJUTZzxh3iWjJmEpc5kXlPFLLkfO7O3qt8udOD-r7XHKCtYQY
Message-ID: <CAGsJ_4zb0BH0ipUtft_FUTyBYgxV69V-Za1xHLN8fXi3jBaXeg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81F251C0005
X-Stat-Signature: gjssy4bqk3xnfqhxc8f4fsetme4j1ekh
X-HE-Tag: 1775701672-91254
X-HE-Meta: U2FsdGVkX18jnhTwLpngxKdkg13j9T7yW+HM2oYM+VyX9jpVQWdZgxtxbAstjitfxT5DqcmISVhG66zuQpW3eOhf6zgJrobW4cimNtI+K4/e9RS48ddlSC77ETwplKQwQ5CFee2b8gkzw3kjVRAE2Qtx9Kn7h+dQ/F2ZHIEDxjt9RwXPo0LnLojhX8Sv8yrgRut3jHfayX6ZndpWqh34AFnJ/P7I/ACS+7ugocVJhN7MmzpC379yJ0ROKb5+tsqVhF8ivxriCrtAUYdxeHU0J4VSQ2CaCDn7J1tVz2N4CZ/OaWA++TACAtFaVs6ziv0q6WkAiDexN1DsOIbxdG/u86vkbYCYrhtgS72OlCxNyPaxcpShO9dfyr0kvaTUhJG+Gkr04wxcJHj1lcW1OolEKYNLZriG6y1biOPVZ1XRnugdykMOMPmRDARUYUaovnDE8HCP5vOxhFgD7D6sLrd1hUyCDf+Jj43IfMjldx7VY5Jsw/f2XpdGGjjBA9E08/y8MqxNuBO5/ZzVWHe+R0Ht6LTnYZWENiQFuJs/Kh3s8RjokIUBOfKWZVo2IUewJZ3DEAMXb1+6DeixI+2hncihLZ1weq0ps+59g+MF8DHWIMpihvbG00QljC1Y4f3ZpycUsEtdrZvV+7tJp7gFBTI9vHMVuBPHZD2DgQJa6O64FhEYLyI/s+LPfjVTDk6dJgmMgOKN8lD7zo3SoVn/GFg4g4PWzlMmHWscb6x7+A3CIqwn2vCQPYoQl5ZDwcYS+Yg53F14gMcxk0ER5kT4R1SsYOh+eXuqu2g7nKM+GCW1a5DMyPoances2h8UM7o1/eHc3aEnsxxpofHWVmXu/TDm4QIg1m/ZwqU0siyMpHakU9oacc36Gol6FCuAu+LBWBqOCNDYsox5AKW+xT4P6zdI1LGuWV+e/mbv+LOLqgPcDydbPR71vg2o04pU3XfqOCHNoPA0gP5MfSkElABrM2H
 b2+p38H6
 /PdNCwMahvgBRrNawilP0rvhfsG1Zq7LbHB2dP3eHYZjhv1o2nMEilNJUg7K3FpCAv1/P7pHlt4sd3c/Q/t/qy5G9+THWjtjSkeWoJgbJ8rlvucCW1+up3fP7TSmGM+8lnA7V4v425TBfB3brSLdSb3NTGKMqCUWD8W/LyANGuZQB7sbpGbUI2MQIgpLRqNEcANGExDfB2VNaf3RMmt+swowcuEa3H+9vaxOutIqJE26qDsKT58V3/LtulRH4VXJaPEZ8+fH388VHW9cdBHb9N8eXG+/hIa9vGUjH28WSM/uAncHAPCjpaYz+cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 9:43=E2=80=AFAM Ye Liu <ye.liu@linux.dev> wrote:
>
> From: Ye Liu <liuye@kylinos.cn>
>
> PMD alignment in khugepaged is currently implemented using a mix of
> rounding helpers and open-coded bitmask operations.
>
> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> alignment, matching the preferred style for address and size handling.
>
> No functional change intended.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: Barry Song <baohua@kernel.org>

Best Regards
Barry

