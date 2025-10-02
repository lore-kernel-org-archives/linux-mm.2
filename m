Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE1DCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD318E000E; Thu,  2 Oct 2025 03:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADD48E0002; Thu,  2 Oct 2025 03:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801AC8E000E; Thu,  2 Oct 2025 03:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69EB38E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:35:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 266A058B75
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:11 +0000 (UTC)
X-FDA: 83952363222.20.05FCA22
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58901140006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759390509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Zy0m6lGq7yazke2nafMsvPVV6PQXFaV2+DO3R5bhnME=;
	b=q8wPxVuatQRbFqSVBlFSmrFnqdpMS/E+5uagINI5zB1lOHfcW/BadVqowUFod3JQpqJk0s
	DYDvnobQTFDwlIE254K37eYh9ZhFzv4PRDmdVjvLCQ3ckWXzLcFdSQg7JNWcGCdbBhsal9
	B/o6BLqosjTqMJ+Ugqqt+nYcvnfeFLE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759390509; a=rsa-sha256;
	cv=none;
	b=FC63mh8XDBPTtnAatXAN4asyS3uK8zMUXRaC/a/OYAbkhe3EwpWhCTFVbtRRTfEYE2LMzV
	5vNKTiwdg9pHNrjbha0h8PCVSUAy88b3tmMOIVGx/K7YovR91LyorCr8wIwr1IdbhKgR+U
	rUQBXAPUS8HjnyQCp9bVKi/hDhFnpRU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e48d6b95fso5575925e9.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759390508; x=1759995308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zy0m6lGq7yazke2nafMsvPVV6PQXFaV2+DO3R5bhnME=;
        b=P/UTy4zF6UuUpYyfPpYK7xe+y9H4yD7XVfXtg2TRCgRRLlrxeZ6mnOzX4EDy6+/t81
         iK3aireQc+psMzJ7htroUpixrlO+IoMAxsb94i2jKgGagHd2D8pQ0S5/a7mm6jHkPGiF
         a1afv4y7KrhsfaD3l6yGftjFREYvvOBk5nuDZ8an+Y4bMhjFgmhuXq491fxCVTbFaFla
         sUvQzvUJXWV3TTbd1S5uw4lafsjQThda0KVvj7JIXQTbPKN4zJVtTKvDLvO3aaP4Vg6j
         lrqzsuauWRYodB0Ve6RYWWR/9AUJLaTZD0sdq0s42arEuKsgV1gYV1RzbgI1Cy76z/Uw
         vDaA==
X-Forwarded-Encrypted: i=1; AJvYcCUSfjsGB04KB5hDAnhAm2vi356+8aEVs5mEEFKWX9YzmOtD7k7J7aw9HPSNx6gBS1nXmZA8Zvjf2Q==@kvack.org
X-Gm-Message-State: AOJu0YyAIJvjnFp7R40HkCG0vIxUcaFjgBH96d6LxScGLN/zN4EOPEeC
	tkHs+GFwDDKotUWc8nBYncRF9O2yjonmt88rkzDeIfkst+5Wa7CRscW1
X-Gm-Gg: ASbGncuhV4amklSIDeZKHJfsrB5iDES5QtmBZDai0IrstkMDvgNb9aw5dYIBI5c2DY4
	BI8CTiGUfZ2SGDdHfuGoP+VPvqjLFMvpTAPbRZPLSVb84fj+4esd9CMl3TF9YBWR+j2jWlRL4cA
	rizBYIlVpCk+wwiXnAEg8UKjr8bRIZSDgjTd7dxBnJ1EYrhA43vwOBsGkgehS5GBxaBf6eZXr42
	hsqForJYedFZRS129KiqQGVPdF151719nWI1/mhVkej1Cz1/wXkPwKBzy5J95BBslu4LOsI1i3o
	dqE5w4o7gygydWfMgHO528B4kN5VH9P0EwethajC2y2YaPnkcywL6XZi9l6KBAxSJUjU21WxdxQ
	4T+9HDf/WHju1Lwre6hOhW5AutBZQn/BBaJYlhko=
X-Google-Smtp-Source: AGHT+IFdXedeq8zfqN8YTO4c4rG0+WopGT+gds1vJKougcSHuF83RceLKvrR4pss1nVq5M3RimSQvA==
X-Received: by 2002:a05:600c:3544:b0:46e:5aac:54f9 with SMTP id 5b1f17b1804b1-46e61293e93mr47824755e9.37.1759390507589;
        Thu, 02 Oct 2025 00:35:07 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6a692af6sm17856135e9.21.2025.10.02.00.35.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 00:35:07 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new 0/2] mm/khugepaged: refactor and merge PTE scanning logic
Date: Thu,  2 Oct 2025 15:32:53 +0800
Message-ID: <20251002073255.14867-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58901140006
X-Rspamd-Server: rspam05
X-Stat-Signature: ce3mbigo4w3cnciataexfg1weejm6baa
X-Rspam-User: 
X-HE-Tag: 1759390509-398177
X-HE-Meta: U2FsdGVkX18M9aFZrL7BWOhMSKARVqrcrp3gwOe99cPp+qf87SDZC/ToxdOONRWkIfhzEnqqElDWA9r+YPrxebrNCZBe3wLSghOuaKnX8988PWU65HW29x+jvwnkx8+HyUQVryatsYj+hghlk5L9Lo4I3DtBCnQSpODn6DN3Og1EgDGlLIdydYXS1tUXWlgJPGwtoOrhpkBuJpzo9qZUrmIVMaOJ4JbkZzZ8X+2xuSZ3/qdlAwqV5oQR6I46EwvyWpIMjlA31B4Pl3yrhwXv+7GSbHWSS/im0RpNkHCpg/3QeCaZHhrwJVdgHSNZTubNy/GHGcHWXyOh1hWbiPGVG5rMjAmUKKScgiN/N8gMF9RlPOhncdX4Rm0AlBioi7/Y0k1GihUzX/m6wavMGnGQF/bWpLrV4n4wfokeSDn5IDE8CESz0PS5RyEI0gPX+Ul6MZnQmIQHkwM7gUYHYBk9P2xXB3o7oAqE9ynFfg+ZXhOf9OTWsQGAyIv37HwwAms2BH63bSioJFnzeg5io1/9E2iCSq9jCTIFI51hwdtFoVteIsFtstyrerQnogYiAcfZdH9otQadq0DoIrEpBtY7NfIZDjHs3KMbXntXg6X2Y3eXwKGzRfXkZUBgw1qKSPgl2a/8mvz5EARVM5qxIx3gAZLxN5orQNL1/8VOYyyHjWRB0hR+LkBh4DpEDHfpm2sjJ55gV5LnzPars2aMp9lhe7V7qixNqaGAph967K6qs/1H+DlVn6k0HQk6kMzHuXGvKdfo6uIfGEgiExbkYGBc2Q4BSLtDXOOFdZN4aZQZtroDI2LoyjJgNJFureR/1GdGyJKkqoSo4Dj48ygJfeL+jRMufhxEU0uN7886bnmmbvopbNzQlgIRpu5wN4hOrcrhSv50ULzrHkJZsGQFHzDnOhkgW1jy3L3dhvQcMrvIlaXdFgIc4f7od5WxJpoKJFRe9EEv/zOdZutbXvrsZjJ
 qRuIKp0q
 qdYgvIcvdYSZHgKVXTh2ZiqII0JLGRy/s2fvxnUYiATLCEjEuENzpj7pEh3Xj92LB2l2JPEvKcArh/8fKDuG/hZC5lmFbgEATMYkULxHE/FY4TUCfAgRqBLROtj+msRhoag4kek6ZPuoHy+W9QQIcqs2T8aUOrve0GgFm7qtGaQT1djPi7i7f57bbUaXT1XTVFc8O/E5scgL1+iRv/8Wr69vvDPRwaTM/gZxPPE5tPSB1E9IxT5OtqCiVkV3FbD6vYVJhlsZmLDt5J4YA0br9zwHJT1ee+2yxTKtbkAPAsEgXbxVp1LibD5iRDrUOePbWzPz0KCbFVGkprCFhZV+npzchTMtK8IKqEK70pceTbTZAj/wEf/7qxfB/LbKhesVG5ej5VmgKz/nf0ZAFTm5P1yLD/or7I9JpG9jPtlOGa99yE7t8j4Rgta/UQ1PUByhfXuJVJJGkrfHd50FY9M5BOeZepQ9QIsHfuYMlGt5/QgQUWa9Ka0Swxkfs81F43nMDTjcxXSktvD9Tq0NT56Whdzuclg5Iv1UJRZW8iWyu+HkiGS4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series cleans up the almost-duplicated PTE scanning logic in the
collapse path.

The first one is a preparatory step that refactors both loops to use
a single if-else-if-else-if chain for checking disjoint PTEs.

The second one then extracts the common logic into a shared helper.

Thanks,
Lance

Lance Yang (2):
  mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
  mm/khugepaged: merge PTE scanning logic into a new helper

 mm/khugepaged.c | 171 +++++++++++++++++++++++++++++-------------------
 1 file changed, 104 insertions(+), 67 deletions(-)

-- 
2.49.0


