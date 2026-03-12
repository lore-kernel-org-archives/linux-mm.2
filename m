Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455E2105A59B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 13:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8025E6B0098; Thu, 12 Mar 2026 09:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA026B0099; Thu, 12 Mar 2026 09:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D85F6B009B; Thu, 12 Mar 2026 09:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 54E7A6B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:15:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 056101B6E6B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:15:02 +0000 (UTC)
X-FDA: 84537456444.17.9BDE865
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3EC5740005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:14:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T+f6+AIK;
	spf=pass (imf12.hostedemail.com: domain of 3UryyaQYKCOkSXLkfcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--hmazur.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UryyaQYKCOkSXLkfcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773321300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dWSTF95QRNDxT+WTc7E7E1G9atdgc+PIwxyOxtBYOHY=;
	b=cL5Dh+k7SqVwnCPH3SBUZWNP5UUeoKHjUaFvhmA71HDUX0dk0zdg2gbRleRsugnkXhx0zW
	wvsnpuWeH3dC7m0Dcqg+BTGKK03DVPiiOJjka1rBq7uKhzvXWKqv0FukpmLUhXyMmoBJar
	tGaWez596o0mWA2UQJhigf6eX/fT2QM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773321300; a=rsa-sha256;
	cv=none;
	b=fuiizlI13zs+9QIYmaNzSGMvVPc90hEfK7lDBo8/MEcs/3d+hf1cxoiTgNqYZAvlq4FPLD
	60BuA9EEfNpuwwp00yMNF30eLefjOwcNNOHrSya/oBQ8ZnOhOUnQjxTlyKwoaBb3Wxzn78
	mH7109N//zJu9Q2vgpAgsYey2YtwZT4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T+f6+AIK;
	spf=pass (imf12.hostedemail.com: domain of 3UryyaQYKCOkSXLkfcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--hmazur.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UryyaQYKCOkSXLkfcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853ab1cae0so10363245e9.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773321298; x=1773926098; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dWSTF95QRNDxT+WTc7E7E1G9atdgc+PIwxyOxtBYOHY=;
        b=T+f6+AIKOO9lS2nZhejSKR2W4B7zrj87IgRI5PX3AyxxKZBsocEy00TTu+TqyB8w1e
         Nl5/s8vzLn7RYgRiWfp2xBZpRBB4dXi5FkMrkvZ668B1DT7CI7XLq5v4e8qpXVn0Qe4X
         4xoAGc5WmJV1FrGZN8DFC/hCZsK8qAzUUdg8wnXGpg7PtDDszJ/UslQi64xd/eg1dEvw
         9xkKmyQi/bUJuoY52DgAwBraolrZ2ZbD4TBspaNiIdTL9Jc9hCH9gpP16FEvxPLJWtXU
         ab1cjVgxPf3Koq+s2pK6RtJsaPJ5u9NuwZROa7WDwNRt/yzMfjG5RqYWt0rkbuuZe+L9
         KSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773321298; x=1773926098;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dWSTF95QRNDxT+WTc7E7E1G9atdgc+PIwxyOxtBYOHY=;
        b=bWNDxLhTYvXcmcrecKZKD3jVboNeN9kuFLoHegLGkIsZew3HLPZz6rkZ7AVjLWJWYE
         79j849xS26m5mSVqVZPeIPQR33arfxhtDoY/E1DmhCx1XWe4M0q6n2cenbOsRMUEMgac
         ITrKRm+BCN6L4Bj/fVKpNFRhaN1JxMW9Qt5ql5WGAhpV0lp+RF+qfqGqe1GZjSYa5LUK
         Wd5IKRonMgka3IF7dg15v8Q3YonKHqisYu4DJNCmoQjJMLYxPxg1aSLSb150BWiwcy81
         RADwIj1LjPGOAofhJAprRIYPm8KStookcPLti3+cupE4MZkhhuuImm3fthHTY9rvW5mA
         093w==
X-Forwarded-Encrypted: i=1; AJvYcCVf91HVoC3WmKhPZ/oHhKM0COYUotH0UhyvaVUxJef10ZteaYbYJvcdaMoXa1iTCMe5ovOReHOoiQ==@kvack.org
X-Gm-Message-State: AOJu0Yx14/iHZ4bK62V2Ia1K5pG33oZPCU7xyhbnCdmQWV+j7E7Bf3of
	mHsQJNowoutTXRBlxDfNwZu020WRmvIFMXB+XpcCilvnDMDWCgeCfD95suB3otJiloq5Y5anI+C
	D38444g==
X-Received: from wmqu11.prod.google.com ([2002:a05:600c:19cb:b0:483:71ce:bfb])
 (user=hmazur job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3511:b0:485:3473:d48b
 with SMTP id 5b1f17b1804b1-4854b139161mr108804515e9.35.1773321298259; Thu, 12
 Mar 2026 06:14:58 -0700 (PDT)
Date: Thu, 12 Mar 2026 13:14:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260312131438.361746-1-hmazur@google.com>
Subject: [PATCH v1 0/1] Fix race condition in the memory management system
From: Hubert Mazur <hmazur@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
	Ryan Neph <ryanneph@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hubert Mazur <hmazur@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3EC5740005
X-Stat-Signature: 4pq7r5847hhb9xjdr4e88andxt678sib
X-Rspam-User: 
X-HE-Tag: 1773321299-614147
X-HE-Meta: U2FsdGVkX1/SjZl2gacqop246GfUSUGYuDrHDbMiBLK3Mnpx60i+n2OJ5K4QVQHfkWk+mk1HJcviIdbEwSImlHlII6r6GSyTYAKWrfprbRe4ooycDtbYA6oPeSCBUYZMI3PfayEk1wZnXAExrkkGvFlu/vfQaU1k3iMPs0f9izHDfFyIszgTxaPnpjyVIQTOC4UYWI76EdND1sb5IEHk5e8ml1yVAVkT2iyuzVTjTPQ0/jcQUfcwNkfplmY/ISpojx3FylbEcx1zmykMCrse1PchwuZn4KH1O1/DQIxg8cStjvOO0BM7jzxk5Idfyodhf6cpmBEyrueDSzpzANP9a1nNsfmzdmVDwRelAsIyvss29HZA3UWned0jsFyrLDNjlqg7tNMPkTrvGHhLIQgbqfxD7BxEifMDSwSDgVVI6+bwMoeNC5nhvuGgEgNwq37U/sFBiRhMqwzCgQqXOfnmpLKX1qgdpQ/2IPSxWHc2FFr6WwRCtRTXKn36ykPSfmkbPg0+PXgXj5s8+3rz3ESOK3hNSIasIy1DBYxZgR2YVaJick1Wbux8nauemvIuZz+ykCsrXiv2JQjnVVwS74UDOTmwM6q5JI+BTEQocW4ZkLdv+RC81jMb4gjSOIZ5QdGKb7GAEkNJ3jfD04v27aGnQzrmIHTpXCYBoLDiK/3ClcRzjwkmhfKDhlK+NtaSqwZSmupmOCbqa6MF0dunjm9+piQTxDCw2rVOv9ZGqf1YopZQ/wN9MwVlIicfi+LkE0i+QXOzYLpJ7q9HxdLW/2ac52m4V2ItJ3e8G/mVW6WOYpoJzosAOhWjaMCB2r0MmH0vNEe9tYqEZuZ3zUDVl3cNxucelXYvyl39TSfKGa6UMvbciSKXrmab01QlolIIM2Gda67GfG98GYnb+MRQ3VnO6BHVptwQh8vbsYnANrvs0s+6rSAowDT43oB4XZRBpNXrMfVjQnB3U3mWhNpLwzq
 ad4RNu5z
 MWnTai/4zBPIRl37UJjQpRIDKVG4TWKTIUPWivVu/m+trD/tDyyOw7JW9hS7OPXCLOk9iMdJyivwWcfS114W3B77gyPgZms6FsooQ2uqlyB/zE7h8pkOf34WWeAHVN13AICqOiWzrU6W6szEC5kmeikcqSILGga0NhE8TX2pMu398GbIw9FsyCgJPXlCEzW60rZX9WacFZU8ClUN6CJCx9arpCLXIacn/blBmurMj6GW6FaMF9XXg65jjdCqS5VPX+z/sVDedphayxGzzEPLR9KcwTzue6p/q+VJJAzcPKEG64Lxb2tXHisdIhiXA1QudXiKzQ2cZEqfxSSvgYup8vobk7mtFZ7OjWDZhfrGdidqcvMPZmmUvUGKEPNASR0zfAMiDrqAG5lhwfZrSKSip8agIbTlb4RE8PZil/hhjft088PnMn+Ula2CnCtPg+/seHb5KSIFcQQpJrejXHsnDdRYjZZQ04aaUsHt1Mv55dL70cx6/reYN7FlShRnAQ9s86iNzW9YgHG02bDEfE2yQ14yHbD72rcnLDAYMqtkkVEvn+sA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When 'ARCH_HAS_EXECMEM_ROX' is being enabled the memory management
system will use caching techniques to optimize the allocations. The
logic tries to find the appropriate memory block based on requested
size. This can fail if current allocations is not sufficient hence
kernel allocates a new block large enough in regards to the request.
After the allocation is done, the new block is being added to the
free_areas tree and then - traverses the tree with hope to find the
matching piecie of memory. The operations of allocating new memory and
traversing the tree are not protected by mutex and thus there is a
chance that some other process will "steal" this shiny new block. It's a
classic race condition for resources. Fix this accordingly by moving a
new block of memory to busy fragments instead of free and return the
pointer to memory. This simplifies the allocation logic since we don't
firstly extend the free areas just to take it a bit later. In case the
new memory allocation is required - do it and return to the caller.

Hubert Mazur (1):
  mm: fix race condition in the memory management

 mm/execmem.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

-- 
2.53.0.851.ga537e3e6e9-goog


