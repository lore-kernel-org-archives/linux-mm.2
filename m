Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D1CD1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503396B009E; Thu,  8 Jan 2026 13:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0A86B009F; Thu,  8 Jan 2026 13:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6C66B00A1; Thu,  8 Jan 2026 13:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8346B009E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:29:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC1C757688
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:29:27 +0000 (UTC)
X-FDA: 84309634374.09.AFBFA18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22F7918000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:29:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qA1Aq20x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767896966; a=rsa-sha256;
	cv=none;
	b=ZNB1Dgy5UOJL6L10EtSRMzxOZuBU01MbokavhMvOyCjR7TvCeaYHKGrFA6fYQbtwE3luJ8
	BKBVicqimiXi2aBVUXFZw/4IU4Mj8dauohn53OLHcyXYuMnO3eWQ3amqOjCprmpp6zTXd1
	+P2ATGVLui5xW4YvXjaftPiynKJH17A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qA1Aq20x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767896966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1qPdoO+X2jwPeMvVPGM0GzX5uNn2DdddZW3ayiLdg8=;
	b=rkpTDrxxzbHeLBwkILIKZ1HT3W9Magc0b70cxKOdSVe8yNcVQCHRUV7Zyosv1rFIGGdrhN
	mHL9KFQKmjG1EFeAxfd0UBb5FgWxjnCUdmhCsrxFcFNY079UIHAXZgg8Pew60FPbL6D5lD
	ZCzbcC8Veh2YxTLxad0NldpMAYQUSP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D89124405D;
	Thu,  8 Jan 2026 18:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3BCC116C6;
	Thu,  8 Jan 2026 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767896964;
	bh=C1ZZbneNUmbULmhmIIcvZNddGcCUci7DDbpWChqEyKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qA1Aq20xJgjpSoMfhVPELlB3kaMSb4V949hdTJTF7ntA/YDRLPvppPlo71J3iNVEz
	 rWPCZzTejHHH+XB9IiMGiMIVOdrHLg92f88tFmfG7Ee4vaZkHKHJOAzq+fw14Nu3o3
	 3XyFg2T6izd3Edg2iO6j9aynx/8E5EKvZC7I5BKofd1bGmvairPCUhH9p0rE64TXbh
	 AZHNfuCTQICVlmaoj472l/aJicPGDjbXohpy9QXQzRldQth+W5Xr/j92I3bfizc0/9
	 jMOW/hMOBwidFSFHMxnmxaY04o9i2lgVgZ7aCLmsvinqdRjXMYgP1qT2fZwJzh2seo
	 M6yCbvZJ5I0bw==
Date: Thu, 8 Jan 2026 18:29:19 +0000
From: Will Deacon <will@kernel.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Weilin Tong <tongweilin@linux.alibaba.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all
 pagesizes
Message-ID: <aV_3fxlzwOSz8B0t@willie-the-truck>
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22F7918000A
X-Stat-Signature: ckhjr8j7bbbwsu44omccq64adeo597gp
X-Rspam-User: 
X-HE-Tag: 1767896965-359368
X-HE-Meta: U2FsdGVkX1+xUIseHgBjT3CiG+FdSZuVN71DMOm1fmFy9imjWnAhAYOtm0rd5Bt87NnQfx/FykZ5eIhjKXCWoezmJc/Qvk5LkJRJDgWWa/hvWRcKSZWnhUo7uYngToebLhxbcjEenVA0ZAWl6RiSHvTIkNMhxHoTqiLhuat4a6QK7lieBiR0iwaIG0Viso1ORkCblXUHe2Gp08JNFDHl2EOykxXGNJLLjwXG7xaY4HiE19j0s0qV7CRgYAcn6NVfNazqpx1SDq9ezI0YF+N4hWQ519mWS6YASGIFDVehqn0HeXtXClq/jWMrCSiZpAv24Vj9Wk0Mx1dpH08CLkbJKCYQa2+z9F7gybNVhxx+vb8bjz3h5AJQ+S2UfXjDn/M97a6dE84U9EE9y2gGHlX8qkKV9WA/GZ70UES4UEqHHHb7Rz5KkLgKthZ+ARN88MjQ428wRhqKGy1Z6Law4FhyZ8zSnOA+0sTDFKoiTr76C3yqaWfTDw+5BwLcoNwTWZ758YpvVo2aYkEEdqR5rE8o6EWvimSkJb+9tC9n+kgij73GN7Ocsdo+qiaLmc35pKKUxjuuOdE7I9qbozHNelC6bz/bmEZxn0p3G9irKE8rN1ohWJYX/ONL8kNgZotzlwsmtO64yE893ZfYd5fNaZr6pZcRWsNHLSJRdTKMUUEksAIIHyegeoHBKFCsqWvTLMKw64tS4QwnOiEAFk26oyuefATYI9t2StM7oYId73sd8zubr6LJCidMWjBB+686C0clkoL1qOjCRP3CGtU2uZ4dbMe1iYES3e2AidNJpGsU9CkvGSlWi/W8x5/Wp63/WBOc7hRv+XQF+C6D0vwAOVSN7ccv/weguUGxm3odglQ5DMupBxYLyYINncJsmxP8t1VS7wqUMjoRUjUdVGINPqp4a8hbAJUpL6vPQF+0jD5s9FRyEKhjSh8dXMnDTT61xmSIYrqa1i9VhjJUqd2VBAa
 Jg7ymlKO
 1gPSiyf1h98EJq67m6LjWdihnTo+Ty2o/ofisU1WLFWjc0k8jmUszaiOODV2xpBby2Xg3kh1oIy7ZHjPfIsVX9O1WH5YN5VdnjozjRx4yBCx+jCW0SghPWPUK1kja+2V68WH1jl+VW2ZOF7ZrAxD/SiLF1a+SkZV1AWAlCvcv/K9El4KhC+e4AfVBB5inaPakSXFEvg4lHrM3jOT3jVZOvBUyUz+buSPcoksmlNSlJsllnU3lnF6VTebKBBG74uj9FhofPt/dXd8hohIBXCANJRI+m5C0lO8jKbuuCAUuAyftxrllUl+2ysyYt2tNqUrCGXoGad4TVEDEgQDsNQ49zaHqqOMCiQtPcH59hOw67Was4LYWc6CLVDNbaijSJJHuu8TlD/r29e5so9E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 07:52:44PM +1300, Barry Song wrote:
> On Fri, Dec 26, 2025 at 7:39 PM Weilin Tong
> <tongweilin@linux.alibaba.com> wrote:
> >
> > Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels, but
> > large folios requiring swapping also exist in other page size configurations
> > (e.g. 64K). Without this config, large folios in these kernels cannot be swapped
> > out.
> >
> > Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
> 
> I no longer recall why this was not enabled for sizes other than
> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
> it appears to be fine, and the swap cluster size should also be
> more friendly to PMD alignment.

You seemed to be worried about I/O latency in your original post:

https://lore.kernel.org/all/20220524071403.128644-1-21cnbao@gmail.com/

Will

