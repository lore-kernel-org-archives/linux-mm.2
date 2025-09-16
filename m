Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC30CCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197B98E000B; Tue, 16 Sep 2025 01:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147DE8E0001; Tue, 16 Sep 2025 01:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084F78E000B; Tue, 16 Sep 2025 01:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBA778E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:32:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9944511AF81
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:32:27 +0000 (UTC)
X-FDA: 83893993134.18.E265977
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id C5FD81C000B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:32:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nh7fI5kB;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758000745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6voqErnEQOmB44o/am2FrWyW/OWGShTujrCbNNtL5TQ=;
	b=6PuSB+6LDu45/7C25r2Ak6uXkAwjUAvG+FWCDzjvkIBirfvzdL5sL4nm61gf+fqkNy0n3U
	vnOzPftZXx8X5U7lM/3m3LqmzrVs0O/u4phmGm56bUpmoyTUa+EUCB90dGKLqlogddIzUn
	/u7LhdEO/DS3VLxxdrlfgvsENMgAFjo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nh7fI5kB;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758000745; a=rsa-sha256;
	cv=none;
	b=L4Kvolvda5X2SXZjCD4zThUGpCUu5C2eE4ZF+wxqVlWxqRPaHx8P46FDMC63ryNP2K5OG/
	bNTKNpECMfjv+J5JssYXe6Yz03VEOnn3nuN4GCAk+OHq9XwJJHZAULWA12Yfct6+pAqcil
	oR17S+oTIw4pgq3WoqLXSrkbfsZ8/AE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-26060bcc5c8so29299575ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758000744; x=1758605544; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6voqErnEQOmB44o/am2FrWyW/OWGShTujrCbNNtL5TQ=;
        b=Nh7fI5kBBG3HUKK5W+ho2EuNLzhfnttNUGzg0PdZ5HGqAakhHRJ8GkhlvutWj2kHI8
         H5/GkvelLYvd79DO6MNAvVJnezbokw0l5z4OZ4b79L2lXOEBezDaFLQiuY5Vzhn00ULa
         SzYRFw9VYw8qaMc+Rgbvf73PCJcQc5ZP77DdvHU6Ar2izV5jYak1DINqxDXi6XOQCM2A
         nVr8XD7ROCnGLA1KETQTFnjshu/Er8NwkesKZXKWhzr/laM8ovCv7j/ngQrIUX93yytp
         V2v2iAXGr2tCX5xXMmkMLT7EVQ9HLY8iYsLWnJDS8doIXgDXgR9Hf5AK2VnssLRtH5Ay
         tPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758000744; x=1758605544;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6voqErnEQOmB44o/am2FrWyW/OWGShTujrCbNNtL5TQ=;
        b=s66jA0wsoZAXyD98rMjduF5S66DhniWilcrrTOf7QBgBZAnWJ6KTuCwKT7Z5NRqybF
         VyBL7iyG2QRct4IN35DF7llcpuND2Fa1w8C1oh1teUJJc1F1k+ZmLMGnam0TmapBniaR
         6zvuf2724IE1NWnvldVG2sd0g/X7/+Lr9Whw5WvugikXuUhVKouwzaE71bFFAT4lVoEK
         kzbUuGEgdB3W0GN9BDaVnELHFhBIzYje5JtspzVp0I6EF2MwXxcLkxHKEx49Q3bMtgIA
         o16epllnnIbCErAXMECjvfhDk2tqXt9wFltr4QJbUqw4RuZFbpOhFJIVcZBcX5ECpbKQ
         c6sw==
X-Forwarded-Encrypted: i=1; AJvYcCVSro4YwKuBgJBreDmOFbr3ZXcKi8dejkUnrnSaU5rpsQEw2HSOZfekFzBcIhdm9ucsg5nVceX6AA==@kvack.org
X-Gm-Message-State: AOJu0YwRtKeMUGzB4NAgKXw+6wEFGp7xydHmgmKu38CHMPGSy+xbq2K8
	fMcHg2UmHl+Lqzu/CmdHGLfqM+DQ7lYnw9ePibqFTfFzr924f6OSzFDPLoliOeGCnw==
X-Gm-Gg: ASbGncvES91dcSA8dcqWFH+CxnbqwzdJnErA9/c0cFPrqPNMPL29nV05Fv0BvNHrB5l
	BVw4Z7aiaU3HTVvbXjC3MDdvzbOQDwYm+BcWFWAIe5RlUoHzxgCdV6zbSx0OqOVUFkmzENPodGI
	f5MtnsUJomlVx2mq6YzTNLAAtq9xUVKYX1S394z1cTm3jvvWRfSS8MUAeYtCxd3dHWY30sAi+7O
	2dy1+6Chpkv+1RdEft1ierf1Zsxt1uNbjzQApK30DBMdC5TZszzxgeq1er9PiZcVERV01g5Derk
	Im+AQAKLYH3x++NjRMARdOWrGnWizrsa/6zMhbtkcQG2GXpeD1Kxw1sCLTHQOqTe8GycoXe8Jhl
	D/s+KE9PbOhVy3jwdPFJYGxekyYYF9VL+uc67kWS8An+v62/jTf6EX1XMQskM5y6I9U+roKFkEo
	lVzhcj1iZGb0Lpmg==
X-Google-Smtp-Source: AGHT+IEnkvhTw3nUkfiJeNmFc7oYbGNJ4HyrSkWvFKyAiuoLkwC1fVikGMm/aWV1OtdK1zVaOsSiEQ==
X-Received: by 2002:a17:903:950:b0:267:b0d0:eb39 with SMTP id d9443c01a7336-267b0d0ecbdmr33737535ad.51.1758000743957;
        Mon, 15 Sep 2025 22:32:23 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2647bf5bf7asm63906485ad.1.2025.09.15.22.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 22:32:23 -0700 (PDT)
Date: Mon, 15 Sep 2025 22:32:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Lance Yang <lance.yang@linux.dev>
cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
    ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
    npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
    baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier
 in khugepaged_scan_mm_slot()
In-Reply-To: <20250914143547.27687-2-lance.yang@linux.dev>
Message-ID: <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
References: <20250914143547.27687-1-lance.yang@linux.dev> <20250914143547.27687-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: C5FD81C000B
X-Stat-Signature: uxcg1q6o3ednu6aps5y3c16cbzc7udj6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758000745-709580
X-HE-Meta: U2FsdGVkX1/02qXjqcHVu/7tBzfm3w7t1Cbm7+Hg7Za2K8qL39PEiCk7Wix8v6n0cQ3frVJiz62VaGURIu3GXzxuBM26oPCIvpr2RHHwlzHwyZI+GLNzlla5YTgVHmVgoJQ4vZcMB+2zkNqw4ms8+CMvosTnd4uyE0GENGUdm5cqWnGRccQGDuSIAuaGKZKe4VJOKiPeEb2PwYqiBCTPy5tllzHRboVvkLkTitHFuxu5l+MNui1rTMNKIcVldncBxSJmxAZNAPAptDih8nR0wgyXJENh8KWjanr6sOBi4DD10KhHkM+nIl8CeMx98gT7wu//CoRe+w7K8yJ04iUIQljiCH0gOTLx/V79cxh0AyxVmL1miMIMWiiG354ZLnROSMisJUIxbD551llSXxBktN6cngUJjvrlXc80J2QeJxNuxOEcPbT085de/fLD+XS1T5e8wWlio/Z1iAE+Ht31rAnSgN7RST7myhNy6A+E462QiRh9+bOmQdvZYY0VnET5TvzMrL1f1fTPdOGN1hvUlOlTxd9foeYcTlTb8ow/XnfAV6SiPyGlrHnJG/LfL2soT2gFHDaCV53t/pqMMb/R51lnY818iGLjxLMf7P5H5vA3imDFDfTgEYtH2hE4Mf+8lnGIJkS1auxY3ub4LkP0/7sRx0bwudl4htGhrgj0qiXG0lOe0QmfGRwRSy0tU0R6PKeI0rgccJAACePy3ssKplEb8FLav8AF1KH55G0mjzQYhCCM6ttM2bNQJdGTCzmXkdCtsB+djG2IgIyUmuW7ZcFGQ3+z3tZgrOFzMLnYkXcIxoFGq8WsDC//ezuiR41o9WRS7tThyxew9mLXb6C2jiQ+rpg2mX6ADTsfX4SI9kNGChmL/WQRSfqoK0/tws8pIAv7FWS3SKJ4qc0gWeOVtpSlPscv0AVb7Vm/56/2PckZtKMbbyoq7YnBn6qfbLnoyXYsWz0wTyj8T/6Eh2f
 eSSvHJZJ
 1syw14GTwNTDJqqrrAnoS9YBHeDCyVVmSpKwSPayugg43H1hiB9H2kej6XJS44CrFSR83jqXvbAEIQIFRzJHszqKkOUoa2sBt6sJXstwrIDdQRVLPLTdBXEDbDUvdsXyGsi2UIeUexvceAQODNDVaVMbmMEMh5+dsWmY6fTla/xVL8ucmly7CQ6dzIgS0wyxcuiaiQ0X2aZ/OEkUiP17KpolD7S7G2x9ChuSQgXIuie88ZuSlfUz0dpAifWy14CElZyp/75V30Uy/dRGMIs2hPXugYwU6O2C+/sUBxez3nRBtdQeKMNe3zzNKLJ+6jiSa5n1n+1F924g/cek75BydePQ9Nz3o0fnRNqtQeqQZp1jYgX7dXG5K2zPH4sgH4OAuNlspt6dWcDDt7gQPbNydYMKWGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
> mlocked VMAs should not be touched.

Why?  That's a change in behaviour, isn't it?

I'm aware that hugepage collapse on an mlocked VMA can insert a fault
latency, not universally welcome; but I've not seen discussion, let
alone agreement, that current behaviour should be changed.
Somewhere in yet-to-be-read mail?  Please give us a link.

Hugh

