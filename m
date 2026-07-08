Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B8FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34876B0092; Wed,  8 Jul 2026 09:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5AD6B0093; Wed,  8 Jul 2026 09:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD73F6B0095; Wed,  8 Jul 2026 09:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACAA6B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:18:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 113091C05D0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:18:59 +0000 (UTC)
X-FDA: 84965664798.15.DE48A42
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 35E69180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:18:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m0iuxMKH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783516737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lU05FE26Pl3IlT3o57vnxyXktDraHqQtoMyoL/hzPVA=;
	b=TBQMz3pRsNOogm4bNgqe0RjQAUejdVPIBCdIPXwMXIOBmHTj4J2WCrirLgdDukh1Wyygsx
	kCeC3mYrmQTsKsnVCmqzRUngK42yhP7tqLfrKzeJGghf+WhWnJ12L3stn8JsJALengwKgf
	91fWEXGqwiig87pT1mPijK4RVNdKQpw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m0iuxMKH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783516737;
	b=sqMaS5RbQzcabb/Z6dPSSc1j74NTjLtg7OIj5eCy/PlcxnuLN3KxbQg/WVznpPBBmQF9KZ
	DodhOlyjVvu1EueiHv9Amp5DqP7T99pyaBY0VIW00Qh7i+vSK3ErM1rUxvyRL3+EyC39kx
	NkXDDP0s+MQu6SAyb4g2kRttjC3Gp20=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so485808a12.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 06:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783516736; x=1784121536; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lU05FE26Pl3IlT3o57vnxyXktDraHqQtoMyoL/hzPVA=;
        b=m0iuxMKHXATFzl39y/AWG0GpP4leS1XRf/r3sIKB2lkaKuLHRqw9pfoYgKEinZ9Y0u
         EXxmnk+kWJJfX74uMHc02E0w95PDuuXBbpFIJuEn5l7cUVgG/0Hdyp7aF/FFw0LrsfUS
         T1t8Mo9w577OwyW94adTH45qt6Bq/0ZqryFdEKYOccsHezs4fra2LOK2wRmRXo7eT9og
         27ApYpYDPPn7ULAl+mCJKdaoZWEfTmAxzWI2DWRKvx7XlWvvkfv4APGDd4nLQOY428LL
         q5BlpCE9AtItYM4Rj5whUbmW5qwBCaGOfIRcM1PIiSi7LRZIdExN5idz2U2nJizW2XJy
         QZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783516736; x=1784121536;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lU05FE26Pl3IlT3o57vnxyXktDraHqQtoMyoL/hzPVA=;
        b=UnLkLL6iwTqAcUzJjclqBk3fBwfL6HrvKxrtAXvHSGab5x0pcga1jESeUsgIXqowEH
         8hfoaj1lkZQ7mucxI2nx8dD/B56Gs5zGlepGi0C9Waid7UavZXY6xDsbLW3F8cEOxu7N
         +h+mc7nCmCLpYgAh1kN7wNLFP9V1GAuzMRDWJgVyMcGhErVz15HRdAkJ4x2xiDn4OSea
         TI3RHWYTklu5BcQT1nbrgIsmo/GY76cghCoAxt9A2MmkmDqh4F/SKHE4DFSB+iW88BAg
         kagYfZgcmgeVQ2CAsPLvSUVp20Mc3NBbctg2ysZKZO3eWEli+2RScwoZ1g65Y+xSodV6
         p+Ew==
X-Forwarded-Encrypted: i=1; AHgh+RqOTK2E50EOdiQnHuB6ihHMr7mCcXT7aHkpXiC4z2q2eHtAsd5vk5CnjULKZI9oOjfkGITvu9HBNQ==@kvack.org
X-Gm-Message-State: AOJu0YyKTdnMPUdDgJ6YT/KXp6z+hOB94tGo4NATubsl6uPk4z1lLIo8
	MsvZx4rKJgDBWqUW/s3dXoa/8QCMfc8W3Vleks/YUYUB//E1ugKsRUP+
X-Gm-Gg: AfdE7clSdpKwVbVl4QD/sqn4ZJSYPqCGGNcVYPi2Qyd196OLCGX/k1XtZMHLcNOH/8D
	EPGIyehdfA4rX2ckQSuSmZqTJoUqGQFCkqKrphVE32YGMIs7SgYJ+2oLry/JyURJEnU+l6rn0yY
	AKgvu2URoAbMN0MMuTcjOVyGndhqCIJ+Le7nBsi9y5qkRlawIgieQKj/l/LKcUtOFtqb52URslD
	9PiI3DmjMOx2U/omSsGFDWw0sOLoBiCHzjxTWKfRKW8dFhluKCp4IijX0f5R+ef/TYwowqYTRKv
	S0zljXrNZZNTYcPm8KA5kP8xb1C3PeOEDvtN7gmJ6kjhyDhJkbyHkybdSAaWl7Aprk2pVJHP1EG
	wuwzgF9Zk4HICSW1tndlgUP5rPlqi192pvYFdOQQA9Fa90xEooQu+qA0DCCo8ZFZnRXzajjc1sP
	bNJ+BrLDbiGJP69A5CWuzLOnL+eeHu+RrQB6x0k7R2PHC/Hum+Nf51sjJH0rl/x+gtCBJok9yqI
	mdTddvKHswnuzwGvMNVTEHQKEC4Jzgc0w==
X-Received: by 2002:a05:6a20:6f8b:b0:3b4:b275:c5b1 with SMTP id adf61e73a8af0-3c0bc9bb036mr3196913637.26.1783516736110;
        Wed, 08 Jul 2026 06:18:56 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3643399sm2462823a12.22.2026.07.08.06.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 06:18:55 -0700 (PDT)
Date: Wed, 08 Jul 2026 22:18:53 +0900
Message-ID: <m2ik6pty9u.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: nommu: fix the error path when vma_iter_prealloc() fails
In-Reply-To: <m1a4s29tbt.wl-thehajime@gmail.com>
References: <20260707235137.498738-1-thehajime@gmail.com>
	<20260707173910.928c74a7e4dc8a1fdfddae3d@linux-foundation.org>
	<m1a4s29tbt.wl-thehajime@gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 35E69180002
X-Stat-Signature: 3ywwhrbt5gwu4b5wug6ixarjadsjt99y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783516737-408146
X-HE-Meta: U2FsdGVkX18KzlwEhVmj3LEgFsTkwCLNzukkTKeWSXIdqzXTdyurohtVD7nOIjx+4ebcA+OndxKRXTx4FGp4W6SV30Ji2woSP9ReoTKExa9c/1ylpA8cAul5Y8E8Mbu+3z+lQhCeEhx0rYQ8WNVGIPvYB61XDJ7rb+sLu76YdOO3iWQCVNRQYgg502ybxZ0im8kESYQZnnPtakz6Bnaa70IA5Xq+ZhCg00I+ymbLJ1KhyuqbxS9OnLXamq/H8pkOQl2hpD2xq9CQ2Z50MDERAbKxHcuf6HhGJjXglwlXRbAdycG80n8ebAQq4BrNqMuu92fImJQIVc34vWKlJWGmUhf8kpi7HycZR55RfJzwPrVg0rmbXcahMB76Oiz27qdkJM3yBx7i7yjEeR6H5IsJpC3+5aavHcuaJHXZup8MY6ALgh2EROg+5rREvF77mYQAgy/Wu6gfCC4rA8HAWWzMi3t154zXN1t+E7nqq6yXRkf1p1atth7hjHEPdEkaEt+5rzGEfp443/FNUymM8ca/No1S84OnnY/ooO6S1DfWjSwDL1bcF4xLO5jae7GoX4+8J9Vkedid29tmfkkhCospOPmfZWVhHjShH58xzQzi2NF2bpvhAWTLhWwNz0pFsacelQhR8M1B9zzEF3zDReo+uHNKN20og0xf9d6ZSv1rzwbR6ocesyGjGMI/OiQr1vu89JyV86VrOzPL0vM8DV3KhkMNYNm/QN1mcdGdxzlzkHdQgT9GANCFFN9E0W8WOGOZQOCQOJg8rM+wNBtlwiYJfQUYwpo7ecwDw9Iom+Xns/59qoaxQPe82QUaNQs/SgFvhFKhHbaWTrT1cfW7pRbZPjkpUWe1Uckhq6LeDKzNJp/699zwmmnSL2HStHnvpElZB4YFMKUx3+eW4P2iu6n8z+bkbZyslB0ObFhJScSZ++Ely5FTgexhL2bhJYWT+mfG85tu/bG5CTqtqg6quxF
 s6qWh29P
 7li87aMdNv0j8r5uw4Etmi5OJP4eW7nQexloLE48vIjAt5u01btUgZxJOLkXYQUvis0wCgxTABUFUtg1tnWSuGfqAZ/R4IzNyoS7597CxSGFIoeCufd2Tc3nCuK6sqovdLj8vZBkaBv3fkkKrZ2jJYDtrZpeLYXNdvYDj7Zz5lFWr7wPg8+yQ4C+H+grEMf1BDGxb+C6R2bniIEpwanLrlCJWRfLACLYyCt8Aq1vpXocNXNoRJOhoCSpNWzr/UyGFNsa37fErv69IEG25lcZdq1Kr4AY4Qh8waKSna3R9XnyN6F16eI/NqgpFEGMFs8M+xvVCmpRmlWxLVDQVup7X+vZKw+s5ANUDWhXR7mFcyCUVHC9wg45hh07T4xeyLCrLJDtlU5tbzh+jRI+cxej1O5sE94DkCMohmsPOaC5wVs7eiPOGICq9ibLMv8TdViU3EIV5vA+sVYSM5i0czHaTNzzWWPdshnKa+iTA4Ss+zdlpziK0UQz3Uwvrskl/E3FgP3Ql
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 08 Jul 2026 10:13:42 +0900,
Hajime Tazaki wrote:

> > afaict, all these issues pertain to failures from vma_iter_prealloc().
> 
> yes, will look into detail and get you back with another spin.

now with two more spins, Sashiko reports no issues with v3 patch.

https://sashiko.dev/#/patchset/20260708083829.576036-1-thehajime%40gmail.com

-- Hajime


