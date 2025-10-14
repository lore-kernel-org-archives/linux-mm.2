Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C7ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF46B8E00B3; Tue, 14 Oct 2025 00:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4988E0007; Tue, 14 Oct 2025 00:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93038E00B3; Tue, 14 Oct 2025 00:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A45178E0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:04:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 498545A897
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:04:18 +0000 (UTC)
X-FDA: 83995377396.09.2388D65
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8B12B140002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:04:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6a1l4E7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760414656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlLsbu+bTFy8wydBgazQtZsA/9vcLNVB+6k0RNzBels=;
	b=m0z3f58Nxf1N4apipPvFxnkEjPsjpyCgLN1yTAA6Q877lGGzp7cmhxpjK2i5TUEwA1qWXq
	hUK6YKysthYWGv6dEoaCQ6Q1DXp8Hf3oYv/uLBjt/6p9T7fNt3enxoLJwGO/IIzx6uO+cf
	NLBNFJ7LZMREHDwLZm6jzsjk7VWimXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760414656; a=rsa-sha256;
	cv=none;
	b=VAis3AZne5dXPsdb1sV11aZu0iOUjusUK/rkXbBjvSo66AfmjfljacP092e7oueNnMpJLE
	7HQ3uUKLVoE8cZjQZSxBwsc80BPGGOakcKNnxif1TEhQp2EmRFap6PWMfo2yPB3ZcPdfR9
	++Oq4jFYkJ9zA0LDRLaZDCKYpRvjzUE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6a1l4E7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-636d5cefab2so5219609d50.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760414655; x=1761019455; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlLsbu+bTFy8wydBgazQtZsA/9vcLNVB+6k0RNzBels=;
        b=L6a1l4E71Y+1qCabiG61hMhyjuut/euiJYpm2NRyM2XVQ+QG8ZQcNz7p5w9qHeVzYV
         EXH7KTbWM2oLS3qiyQvWQIPMOimg3bcfb17J+2dWfAeGbb0IBg5jrDACO+oRuHxO27Ax
         tG+HJkkWwouo6ROwaewXSD240C+2e5YUcSXtTbMbTGYX3UYrBI7cWMgxSWYaBVvsjnxZ
         D1MyWUTFCYF3nbZn0aAj2X/w0PITrIl8XsWAodF5wf+07ewW4bfCUDKJoOQiABM80CWO
         z0rDxQJFFpQCAE2knUtQ62YyVWcYjjLiAndgeheKKSVD0tIhtLfeDzSkIBgNvWNtpOG4
         6bMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760414655; x=1761019455;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZlLsbu+bTFy8wydBgazQtZsA/9vcLNVB+6k0RNzBels=;
        b=U7nfK1uqiwCKPboSD4Y4VY6FjyNUDxojT98NrFaN2k7p16DK5qvdyXIj8TVacC/ULY
         4RRJD0+/pfNBYW897vfHE6aKnbngYRJ93DZZcX3QtGcRvygnfBpscJM3/tiZf6QRgz0L
         WTK3ZKsDkIPVfoluTbwGG5UGKxQr1v1qf6VRvNB5lmDaKF+9kxiW8njjhtNPQzIUiFvD
         XMS2pFZEnwOGGi9jYmiwjVLmwl2WXUK7lv9N762tzP+m63UkxP/G8Lg3RU2YovKkA5eZ
         6qLuWLFZPUKOyz0HcfxJmECKUsmI6Y3DxEw+bcObVYqE8U3Z0kJ4s4SLabNFU24bcpLl
         5qpQ==
X-Gm-Message-State: AOJu0YzNE/XGxjNCpL8Yk/uOT5wBtHfEk0i3DdCOkml9AGxT8NQlyk6p
	z0PmCkb3fz2aG2LaPWO+jYBJCyVo9NKwFKZvt4iRWCJncwoj5HQe4D2sM10X194adoSh7JFvnzP
	ev2PeSuCLu4bt3LopaQGjXQvPPSW5xh4=
X-Gm-Gg: ASbGnctdDhLhZZoXcrdVlSkz2/hkPJ+fMBi9qAAE8RQCcApQ9CPyF2RJ2YRpxnsiQ7E
	s4b7mVJjwKsLeNsRvYq8t0OnL0dU6qWw5im3644iLFLaDZbZem5ePQvDkxhGMDlvAbisuFq6r+M
	VDa1cNrJd7G9mT8zN5zdjM5yET474eS0zU9M9fJjcobSl+V0iKrm67XFOFg0vi5vULyFkJ2cHtT
	XPaP5hl3jAoxRQ2sXRpUObJZloMn2okBE7ZVmonAR0YprLT9HJey/Tq4Fx9yGX9t6WzMAhij8ZZ
	xU8iGOrvhhXIwDCQe8J3PFvTMg==
X-Google-Smtp-Source: AGHT+IEKl8GhYUzZqq5KI3es/Unb8qf1fU24yfR3Th634G+85UZwEzV3RRxo6zuR0ELnukwcBrsk0rTTyYY3GXjywm4=
X-Received: by 2002:a05:690e:18e:b0:635:4ed0:572b with SMTP id
 956f58d0204a3-63ccb92c021mr16769294d50.47.1760414655375; Mon, 13 Oct 2025
 21:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20251014035720.346268-1-kartikey406@gmail.com>
In-Reply-To: <20251014035720.346268-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 14 Oct 2025 09:34:03 +0530
X-Gm-Features: AS18NWDzAynPG_VfiI4lVlnyK2Etdss_z91oHt88SHY4XTwNK7WJJ6GKSFws07U
Message-ID: <CADhLXY72yEVDjXWfxBUXfXhNfb8MWqwJmcb1daEHmDeFW+DRGw@mail.gmail.com>
Subject: Re: [PATCH v5] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
To: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: 7dj77pt6yssbw3fhwipenucpmeecxyec
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B12B140002
X-HE-Tag: 1760414656-60405
X-HE-Meta: U2FsdGVkX182Ms7geuVEiITxZlGyv/zMOAM+cX54vTZ93EVafe6H/WXqBTQRIawdoJylj6tvBTls1p3INIK8txsSiaT4t/6q6AhDHR/rCkjpw94egNpVnJyJMSDoJeiii1C1cigjHM6v7xC306jaw5gRpJiZ8u4UqQaaiVm8uJ3X1JygE8yqpsK/Db1bmcpR2bCGlEwmtmoAtl5alHgQmkfSAJVEvO1Jmix1AZEwAaSlWk252wf+jptfTCl6eyY5pFh5voS+XCbgvcgqq9zldn/Ej0AuItyyuuJDjUZQH+wW/ht128agEZj8vKPKvT9WnhgBk+7t7aj7epAI01Rl1UYhqKtHkH7yHSHR/p2lLmMTe8T4JZw06uCHpcnZAWrZYun4MXLQkgVNCh7rOcSyk+oVwvgAR0V5XT9syHSPs7wGXcECKsi+4AKZYuKIzK5S/Q4lRa780c49oTv0jbbgNefbh+shCJZa+bmgjfHoqWQ8yoO+i6ZQ2SMYkHdG7JvDYWH4mMxLpprpmRez7h6Ry+ydZh8+0kZ+aoR0J2PbkRhPOSSqgpSzH7dN5RKpOh1psNNW3ZrcegNA+fTTzM3mHHTyJnAv8YfILIOCCvKn26IZPHdKGQnCQj2RS+Yavi1pT8hH7Wznv0l2mkwFL9n9BBRToHCSb6G/wlQcKgEESs1rJ4Z0mwPrCjOSQ4J6psb9DdTYAN5Kyqdiri/b5TJtwXqWkkFjj0DF1Z2m7QKbSHlKGTF8L1J6GkeB3frAwa8iNoyir9fIJGl1snVvgP50grtCM9Y4PFmjcuRpPO3pWw14nq0OCcAJ2FxrjgWoTMnuzCsQqlylCd8rGbds8igw5gV2Li4qGyyXVeAXXJXJZoqi7qrE0PEuRdDljHXw8htXmUJ6bAeuVAjNudzxhujxUUtq+UuWUT2osq2VGK8LNBdjZFLNGAeS0Dn9XoUNgZxxNc1WT+vL3xjAAKkECO6
 P1iGQKky
 CGXxWqnKnOGZHCmhsEptnJ8ac2s2X7parlKAsfqBrtHQBOXOqmbFByZyou2xBsJJ5Z7nN8VKLIuOCglfvW5GmrxdmRnOOUPs8/9XjTHk20FHsTUDsTkBbtkwkcZwhIhfWO1wr4DJ205V8hVrqGVTQp+VwyQDwkHKUfZrleuWEb3NInvuHUdwhen3r6mnZdwML7pS1L7CgTNbW6sTnN2saXgA7Y5wEIojENL/ooZ/9nCS+KM3/BcqzLVs3c8MNrU1rkh3/URLfL14oXkv0jAvMLwLJ/Jgc9CxKeJyIWMrYyFW8Mz3SlqipkHt8cNC0XBEflMDzRLVkwZw73+bTRgh/B3L7OfL8c5ruHXWXeaK/YmneN9uiBeh5QohgTcBiyYWF3MJAnVlhdhGHrJzl/a52NnmweffBBTVtqmLlvNPVVdI8Nu/blcoOFgIxi0c5tJX36ZW4gVOMo5McdI6Jj79+1vyTTqhrtWRZbXhLLoGhb0WgsMUCQ7d4zS8E5MQ4QTCDgULQnCxTB3ng/QE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please disregard v5 - it's incomplete. I'll send v6 shortly with both
required changes: removing the v4 check and moving assertions per
David's suggestion

