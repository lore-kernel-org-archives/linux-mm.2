Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 574C4EA8542
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765FB6B0088; Sun,  8 Mar 2026 22:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E92F6B0089; Sun,  8 Mar 2026 22:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBA06B008A; Sun,  8 Mar 2026 22:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490016B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:28:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C69D98D0E6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:28:34 +0000 (UTC)
X-FDA: 84524940948.23.BEF6E21
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 029F414000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:28:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GAlD3m7O;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773023313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ps1Hfv9yWFYK/K2noVGj+dmwqc5tyuYyDUSGFJyxTPQ=;
	b=WUMLfhLnQpFBL7CrdajybpzulVTU0D7iNqXQSQXgRfZpR8iXx7N2ul5BHnZ2MDS7sjpQ8L
	JkUjP7nUH/rBsQr52dTgjB5vDieHw4NK+Px+1vRgAzmHyT/H5s36b8tBoX4ItVFZjgbHqV
	cYbUxAyh0lh29vql8WooZMTSDpM0Sl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773023313; a=rsa-sha256;
	cv=none;
	b=NNYcnBDw96pHsS5z7tzmMraqDcUe45xZ5sPMk3RqpKKfksL3uPGjA7M/wWev3w9dTIDDOF
	V+Leuhm+SZmvbEkwngSp2kaD1hnPqShH8yG6gT8lnDCPeVGOJM7MXqT33era+sLgLUjivj
	JgAP6BaNzAFV2naXb4wS2IQzQ7XSDik=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GAlD3m7O;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1279eced0b9so10086923c88.0
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 19:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773023312; x=1773628112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ps1Hfv9yWFYK/K2noVGj+dmwqc5tyuYyDUSGFJyxTPQ=;
        b=GAlD3m7ODtPnnFaioLXeoCEh4Lpy+loRWCNd63ETZyotFxopfuSqj2Mm6mQtxkK6zw
         n+bLtRWNThEima89afwo7JHh/lJeyRJe1i8rdpH9GZhr2WUMEjADaRNqxsKjD9sQRSpF
         5YGpcVYsq5pqnfnZ3s+6n+JuO/8Ivvrna7AOlj+BZcp6HH76zGVuuv1K1X2qce2B97kO
         jfsf4Il6xMe6m+28GP19nwLkWunVuDeATDqw0OBxqHaz7Gh9WrBuG4rph1q9Ohh+RmX4
         Y3ir7LnLvAV2v09GCl7gAMnqMCS/uXMPj4uPlbnM7237HR+6X4sv4jtykJrieDtMv8Pq
         jiYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773023312; x=1773628112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ps1Hfv9yWFYK/K2noVGj+dmwqc5tyuYyDUSGFJyxTPQ=;
        b=iKo0TD7kO7jN9lqEKv48LLvoJ/3IdeBEDwXKw+3Tm+wFq4TkyAPfwDWUQ9MirRZv26
         gfJDYvHmNnx2zGsF52mKsJNLddI0DHzf6NXrAXHa0LoCsTtc5TMo21I+L9ymlTGp7ftK
         LbY34TSkgiE2vRdRylbHE1gjuc89eJLyEGk2KhK93ghLUhIWg4DXQwqzGJzVqLusserS
         AX5zO2JatQsKCn+m3lbZ3fHoL2d9K8TZxEObos3kdeJRTItuWV0mhNL8+RcyQpYl4jmo
         fin6MBgf1JIHCEE9OKQUUiDz0HuToyThQhcbtIJL3M+GnWZo1sdNbaMDrtP3n4imK2Gq
         otNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwDeJQY8Nua28mjG/mP5TZqZ34C/dUfw0Ai4Tc/oDZV7zb9ThUcVls0cinv7yF8Px3YxpDUlR6AA==@kvack.org
X-Gm-Message-State: AOJu0YwijWkFofkljCzGQpQd8n7pVFhQ183nC8OQj0bk/az908QXN1e3
	VnwA+PSnA2tONInJ3juHkAqXKJFnkL0AV/iEVCWTxsvzvfGsXftNbJaD
X-Gm-Gg: ATEYQzwkJd7Y1dLkBH+Z2FY16Xjw8R74CgJCyIuy1vDSfiagCS1fSc89qhbEodfPYJU
	RR5QNAiABKSOGrrf8PrhunZKyuXTqmLNqUiQ+DykXCqo9Gy2Bhuu30sAYpXNYr0QX155ILIZ3Hn
	jJqqpwl8/z8y3KBWZ686ud/ZFEmtHo4j1t5qCuMJCPkd4ZMO1ndbLLO/EiSb3idpZS4nyskaycv
	AO3HODAWMfAJdSh2t6xTDAZfupVst0ctEY0iw01AxF9J2CSBmNbdBQautqVgYybrwCW/aNspD1S
	K7CHuwN67DKvTPTdLB/cC1TKdHRxDm+hOfmfwlNoTaDjP/sYO7OVhO+ApkLzVQbr24KFKUghBlF
	35Opor7LpgNtftvzawlQiJk5O/sVajMOnom4xcc1jJbGhFYDwxQWTcxkQr136VEZOopnWnk0Ik1
	KPP9KOhQTTxh2aidbO/llNdvSedit/J0k/LR4=
X-Received: by 2002:a05:7022:4186:b0:128:d5bd:3572 with SMTP id a92af1059eb24-128d5bd39b3mr713023c88.31.1773023311637;
        Sun, 08 Mar 2026 19:28:31 -0700 (PDT)
Received: from localhost.localdomain ([104.28.165.128])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128c3d5a85dsm6728418c88.3.2026.03.08.19.28.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 08 Mar 2026 19:28:31 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	brendan.higgins@linux.dev,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	davidgow@google.com,
	kunit-dev@googlegroups.com,
	lianux.mm@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH 0/7] mm/damon: improve/fixup/update ratio calculation, test and documentation
Date: Mon,  9 Mar 2026 10:27:59 +0800
Message-ID: <20260309022759.9010-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 029F414000A
X-Stat-Signature: 3o91iwaftodie1mgadpk5ph8atjfiq35
X-HE-Tag: 1773023312-473473
X-HE-Meta: U2FsdGVkX1/q/e7SJVN7pv7I/s4SNQVgdquoE02pP5hkBW4OFrpxv0nNtPUrLyHZ7+vfioG2PXU2Ky29MmX1CtVmfrcxTx4/79FWmz8ZMh7AnrU8CPKgaWRIl2nIFuwlIkAyTn1erOPvuJ7keyf7yIfpWVwcMLDzE8yogJHWAYVAkqYR2tJAPCEXXKzWzY5RGtiaCu7flaWUpkniHqxcCus4x+6XzoMpq3dXqJELlnwXMbEX/U0pZs3COtS1RHPX0gxA8r8iFb2ivRxRw1rpIMXPOhk+BNhjTO7PPdous1hDriV0a7YZ3mG8LxBBM5dBD+B96BIIv03F1vE6Ox5tPsQeVeJY0pFG+Ed//gZYqGp0m0ycubpKOVPt1kQUXJ/VQ7b56Z16nigM5BhoNkGsEN9C2yQGzZNNR+evEReDn8j4pBTJM3Zmu7ph4GkNvqVx77qJUMpYOrwWAmNZnBAvDaMRJh55F6niO+IpeLncV5xed9esYk6atJOOonjkIn1b33KDqlMiJb8WzEBei2zFvyNc6V/5bhgKYoRGacv7jbxrYLqV5ZL9DoAvOO/juLdjrIZOD/yzDMfdbSD3DbEVOkYmJv8K2XBBUtHTYGuej00RCF84xiZii43UPAEJNeYxlLhV54FtKrBg8L8jiF9Udz6VxRaIlfbRkFB5F4GlGz4EIjlsfi6CXgbHx0By89SNKjEO2KIJbewrd2PMTFVj7BufeJZz6XzDJosGfckbvjwWYq36BmPcfBMxzp0vxIzydpyw8cJ2R/o9GL56CgO8YZa61MhHoGbc470a/RB3lJ6kuQ/9rq4Y+pE4Ecl7kwfABg88+eYNGGzkfQLKdBeRDhCyBjbuztSNsKuLnhOqAKxo8OHChBJWNuXE8ckglJkCqW8Uw5TFjNJ7HmHmhE4NUOFij3tcnpFjbJba3vsunwKJ1l0ENCfrVmse8x+9Kxzqp2qdBJqqbF5B2fzZMRf
 RghFgUdS
 eYPLozp6iQ8+yVBl4mHsoghBD8IFItWQa4YzIVJSrm8+USAw31B0hdgSa26m+jtji9BGFudE4V2nr+aZD97QlaJiclK/Bx2YDe08AFggp7T6GONZiAg2IWGx+/FdPY4cOPO1gC8jMQWF199Wjn3Zm5AZ+5gbPrSCjSRH9C6bI5g/MHn4/5Bu4wHHk7PD7N4JPXqw6r7aYGKLZoxa/nemIWjm/shh5M0VSLO2l0TVsk4SUlM+XvVzWN7QMWTC16a+yxfdvB5fDzDk7odFcoK8Bdj+GKitGAlvtuMxLYz/cSkDVo3N/WzP7UkyW8bdayZudg1LJFOU7qiZg4n9Xbe5hwE3FSfZZP5oUejwJO9LvQUNZkjmy+yhs7S80FpwLXbhQnv5bgvDlEc17s6LOXiYv0560jo+bZwpOIRHIPfx51pC6zhEBfLIUXRyuLEO2AxXfXsGb/+L08KDTMt7ArT1Uzaw20wzfGW/DF5OuFo06pxOO4AvAHrIP4HFMQCgPCI63LMErQTzSuNFSCJTDPpFw/7vLhIO1vTrbXw/uGsvFqn2qkuAQSliuaJ8IPq57/b3OXz2qXVteUb/o+vxHkMQb/WBU+GDz9yV2p1+c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Yet another batch of misc/minor improvements and fixups.  Use
> mult_frac() instead of the worse open-coding for rate calculations
> (patch 1).  Add a test for a previously found and fixed bug (patch 2).
> Improve and update comments and documentations for easier code review
> and up-to-date information (patches 3-6).  Finally, fix an obvious typo
> (patch 7).

Hi SeongJae,

Thanks for the patches and the CC!

I've reviewed the entire series and conducted functional testing on my arm64 environment (native VM). 
All 28 KUnit tests passed successfully, including
the newly added damon_test_is_last_region.

Acked-by: wang lian <lianux.mm@gmail.com>
--
Best Regards,
wang lian

