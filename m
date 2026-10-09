Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664DACA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1EE6B0093; Fri,  9 Oct 2026 03:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B026B0095; Fri,  9 Oct 2026 03:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551DC6B0096; Fri,  9 Oct 2026 03:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C356B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:46:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA4CF140289
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:46:17 +0000 (UTC)
X-FDA: 85302304794.15.D6A9AD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40BC8C0007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:46:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxOKpDs4;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791531976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6z02uFgszMrykfA+H9Lp9iL6Wt8zF9IJww9x8UauC4=;
	b=in+cN1J/OR3tCESktRe75A1PQIGfBygFHMZwqMrKDNB+p6FYGxUt1AattKrtgOMmllk4Yz
	TGcNLDWmrfkRRh/zPhDX/svq3ScaJE2DJmCkE5DWWaGThSTBcOLuQEHbONev/mM9XVXrbv
	NHOUM8NUhYDAsKXZ2z11g48q4VSWcL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791531976;
	b=hXecjQjjGVhpee4aJTZq1IckiYHs6/25O3gfJ1GyZenG4RzkHB76FuzcvooUMjY7wSapLr
	Eca1ovsmepO9QL4cpzJKRWihFr+8mC4tAp1m0cJS9/vW1xoOVCpJ8HbvO4gWodrFJrpLTi
	Nm3DjJhiaoIMNqrDfEdsfpMEW6jNcXw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxOKpDs4;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC8EF602CA;
	Fri,  9 Oct 2026 07:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCDB1F000FF;
	Fri,  9 Oct 2026 07:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791531975;
	bh=v6z02uFgszMrykfA+H9Lp9iL6Wt8zF9IJww9x8UauC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxOKpDs4KsGTOWH08PpkeJrjcTh98rZoJrZqvjkYBmeSULddDTjFYd+6/ktBJfDlw
	 KhAAdp+9TWemJ7qVAj2WLf2JCrCVLJ3MzJFSgscZGL33vTFBmYafaq5AOKpKLE6jMk
	 U0xcHPbo8ho9M+eRkw1LVBPSx+Z6CDsxYYDz4Bs4DTo0tmp+IFUZ8lABKU7lVjEwFN
	 AciVb8xjvVPJlW7efCXAr12cG7HfN9pZM9Q8t+JQdiWMqtt0tHp0Erj8iUj3RI8zTr
	 NZIE6NUMTmy3MsiB20dS8LDPw+JotggZp6Pqh0/wUlpBqaNS+nfMm4K/7Ueig8At1w
	 C433LXcVW8yIQ==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Fri,  9 Oct 2026 00:46:10 -0700
Message-ID: <20261009074611.40973-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ase2u791QTcV1LZt@fedora>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40BC8C0007
X-Stat-Signature: skxtjh9uxrf8kdqii1rwxfcm9ex56ek3
X-HE-Tag: 1791531976-946723
X-HE-Meta: U2FsdGVkX19WO8TXGlMOMbH8AO8ab9QMWcZD+u7s1no7XubYgnxEUSadaJ0+FskMXJql87WHIgXGnyOm5ZODiHq/hBYcZ9DZmoe49bOLZZKGO8yjpgfZQUQyckN59evaG72SPcSNhfUgWDdYFT20datES0Znl0saA2Wa0vwqbyShf4WLWK9cEMVtnkj6HbmMEMgjk7UVTclHZD9EHOrSFIM2fdic0B3OftlaHvBgpd58lTOZPDMqmAwd4uM4MtLtSKKRkd4SRc1/I1s60otkOYAqt3RqD9i9fxFmoBzPsrc3StDv7ZpOShhcnITfQnQrYpjVMKkNRLK2+vsrcMWyWIjTPknjyIUcWM7UgzZnZeGgyqbVHvvREfmEozFjTdpOFiCLVeft/PGKhzETUxynKNQfzLPDrY/wi7WMR5os+RCiXlfPrLNoTB7zXky/I2t3Xrz82YCPJ2zh9R6SdTwgM42Jos+Pmnwwc1Mfj6/gpto0TkmG7NjSNJH3YPK3+vsaKutkg01Gfr4r30gJiKU/xHz8Kn0XDrtQ0PLnu5zO+/W+EJbvZDOnvW31itIihjYObwBHDGQ4T2Xbbht2Eef4jfAbebJXe0eD7grM/nYbq39tVPsg8+hH74ZBy9HkciVmk4FpA4+z7MNW4TTRSZzGyEghGgXK2KPsYvJwGMVK3FETg28TJgCHYWUwIoBVpBoYBCbMdg78twrlw1xeVifvtrBiCS5meZYzYVZAZFoqZN7a8s6UirtvboFP5Jmmk03keeGzWuYO1wg7uysAv22aWWE6BULw/wGh+vHSjyW+VH0Qg3rD5npD3OnAElNvmmTq2jNE6INrNeZMBjEgCrzDlL5yDOQflCTjAFaIuGP8F/HbiWIbpjSXmWbv/Lald2gMcgGv9HAMPpDnokDhhQCcvu8V7eXlrOTLXVDbPxq28++gwrGjHWZiFigYfL7nS2h964WVdCxbFvnpeLq32kZ
 o8yjSOO5
 KtB+G+i3NOTZDnW227XrpNWX94/Z7xnPHsWBtkw0TE+EbsRQzeBxy+A8cNk/VhT76Ugxm5Q78bNfBDaiAiuPTz2ReYC2mqUPgx4BxlU633UVlsm1RATrgknor/F8ZcTipJNR+LEwrA7hFET/9gWSwmK2S+8YTD4BKd1X2a8L3tjh3f09D3MEmk0dX26mqjFXYQhogo2sXyY52V9OmCo57dTmPav+iBIFWhxH6dilWp35gKIcAhdClQzSbRFjnkqke+Zi0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 8 Oct 2026 21:03:15 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> For some inexplicable reason, the cover-letter hasn't been sent again.
> 
> I am just adding the changelog here, in case the cover letter never arrives.
> 
> Changelog v1->v2:
> 
> 1. Simplified patch 1's commit message to make it clearer 
>    (Liew's suggestion)
> 2. Added comment docs for extra arguments I am adding to functions
>    (SJ's suggestion)
> 3. Destroyed the context in case r2 allocation fails in damon_test_merge_two()
>    (Sashiko/Liew/SJ suggestion)
> 4. Wrapped lines at 80 characters 
>    (SJ's suggestion)
> 
> As for why the cover-letter isn't being sent, I have no idea. Everything seems
> fine during `git send-email --dry-run`. Also seemed fine when I sent the series
> to myself as a test.
> Apologies for the inconvenience. I will make sure I fix this issue before sending
> v3 or any more series in the future.

No worries.  Thank you for clarifying this!  Maybe a possible workaround is
sending only cover letter first, confirming it is sent and appear on the
mailing list, and then sending patches using 'git send-email --in-reply-to'?


Thanks,
SJ

[...]

