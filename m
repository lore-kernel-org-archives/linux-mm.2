Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590F5E63F0B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 19:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A746B0098; Sun, 15 Feb 2026 14:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038436B009B; Sun, 15 Feb 2026 14:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A666B009D; Sun, 15 Feb 2026 14:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB36B6B0098
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:32:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6242B1B46B8
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:02:41 +0000 (UTC)
X-FDA: 84447310122.04.214E995
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 923EF18000C
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:02:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="AHApYU/e";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771174959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vra/CfQE8iAuhhBGkxVjBmXdn5qs8b+8qH/FS8WdgG0=;
	b=qjmfNlFKfApg1qotHgAO83w+sUFJw6READhPE4DKxRbr6LzkYx1NqaohTZjOk+7DA476u9
	JuqvdY6e6N/Szew3jUvUnhlxQSHBrnsgXZ5ir5h6Io7yq68t+omeCR537An0CRt0KCLEXj
	st/doxFWiH2FO2Im3mYWtye/8hB/rbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771174959; a=rsa-sha256;
	cv=none;
	b=2bfKvpl/EFK6Q8PLrOFN4BeevajjtJlpYhbjevzIs6iaIbcrSvwWY5q5tmX+QbqR/Ydoyc
	rMGKTotd3y8Ywm7SeONynUvGAo2OEOoqjuOQ89uDrRX+imR1A/HNmGxBuH0aUiA/qA7TLB
	Z05s0IJnuwuj1P9pM1U1u8rt9a/A3S4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="AHApYU/e";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C358843A31;
	Sun, 15 Feb 2026 17:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44765C4CEF7;
	Sun, 15 Feb 2026 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771174957;
	bh=OvAnKTaL14/r9aEBIEjJXyVSCbVNytTacNr8GtNUKxw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AHApYU/er0rxf4sTDinVRbaaVZC62BCDB9x/6yklj7sMiJwBFDl6F8Q2PeP0dIb6x
	 wLAVfn+w6rAt7Xv9AtPkyavBWgoV6M1npK9nV/28uKwxaNOHZO1gg/wo82aR39kwVw
	 NYYkxd+TwicNKrxAUuBH53+hyFP4xLhklJo6ugIQ=
Date: Sun, 15 Feb 2026 09:02:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>,
 linux-kernel@vger.kernel.org, "open list:SUSPEND TO RAM"
 <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] mm, swap: speed up hibernation allocation and
 writeout
Message-Id: <20260215090236.b546ef526b9bb6315f7884b8@linux-foundation.org>
In-Reply-To: <20260215-hibernate-perf-v2-1-cf28c75b04b7@tencent.com>
References: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
	<20260215-hibernate-perf-v2-1-cf28c75b04b7@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 923EF18000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hrhiomqz9m5e8zwp5wiu49es3ztbbwzk
X-HE-Tag: 1771174959-869610
X-HE-Meta: U2FsdGVkX18x0nlBuznJJ7VoHeyDNQr8ZyoopQoiKqcjs8vO9UvvjeGLmUvXKLm1IngW2b7RbH/beoJfm7arPB4bPEFRptz6+lZpBAo6FSGqD+Vja0v9BkVuNbl9f4Qhu66g76Hv4OPe7WPoKdPY67+ooaYZiZmMwBwuX/AXYCH7aNuv2inpGrtO2BVl9GkNrn5DUNVXa5QtN0ZTAwVrGwDSZ4/0PVB9HEsJzsqlaGQkzeeSQivRdDWcz4UzmyLyyTGPX8GYAhNolIvZAgunUWnjeM+ukL1UOFAwOp5JI/7ZkEIv1beYYSrQboXmbwOeoGkcz90TwB9cGt+wNckOEoUpVC+i1cKZzFaiOsE8e2wOVYGfKmhXYq5gVlvjGM5R8FRTTaGzLy8RP50Z2h2ISGKPd2Y8wSY9dagZiaUXODD1dbQ2KBjzQbMLHZ3ketJ2SsuUkQtbO0XdrhRZnej55bdOcpxHO5A9VuakN2q75YtTyrsrAiDsRE7qYdUcUjV96Q33m6mOXAEKlSVHwy27K2cKDuZ8P4zUp7itABJ6IJv40PObXhHZKlTcmNueRJsUZjREC9GaVaUpzAMnJNB0cRPPLdym2GiWMvG4m1KlN0h/nY2P/BCbcSVVk24Ff6nH/ktCHXU0pOz0wpxp08ZZX+uDsERgRHjBKJH/egxcpuw8iJxUr5XusNo5LazFfWfQqhRMRYI1Smf2L6WAjArFdjp+5up1TOfI8O8PRZxjUbDfmNU508vwdXi3wdXb9dUaijFD8DcZAhcxaTnO+RTnZTSAUC1LE+cr3bLO+0QQ+gB/GJU5qbuv9MUnqojYz4OdlkBotFS1DJ7HLLDTBFJdeOqvNQCLEg5QjO+SDNDV497SYAvyJUgkKnVeBaB8oxkqoO2d1ZsiTVCsCT4I7WHRml7sNYGHaDZMGS3e1KwO51uxjQ7DsEfg2pIvHz9oeX6dzj6uGKZ6hxsaOMFFtdF
 PYABLWGZ
 KiCTEBTq1GwjImitTp3ur3zS/CZHtLBfX6kQzd+j4iKcnkKgbT3LBGT9vNjJK/yjwtQ8igVZSCjjYKgeKVhakzwY4LmUheV4bWgUTvpnnZlTc9xeoTJ+dxe/dzYlHgppYR2CgNwfLFrsJMEZ7GW3cXxcfuHlQFMUYNt8NiBdXenvQo6DweFkDMWb9VvWtm2CiGBMzp2/JfC3hpQDoXI5iFwpvit0at3vSFeKQp0jskUgIWScg+BlsHsk+VTo7Jsy9ur3gLlsPKvRpHPepQcM5WO6pPxCsdugaAekojxnjruVxWAwSlUftP3SWMXh+d2ok06KrBuoOZTLl9Uuve9df7JvaK8PqzsQb0ygfra4zLzxDr+eJ5ijmpmVzEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Feb 2026 19:15:05 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> hibernation has been using the swap slot slow allocation path for
> simplification, which turns out might cause regression for some
> devices because the allocator now rotates clusters too often, leading to
> slower allocation and more random distribution of data.
> 
> Fast allocation is not complex, so implement hibernation support as
> well.
> 
> And reduce the indent of the code too, while at it. It doesn't have to
> check the device flag, as the allocator will also check the device flag
> and refuse to allocate if the device is not writable.
> 
> Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
> performance is several times better [1]:
> 6.19:               324 seconds
> After this series:  35 seconds

10x is a lot, so I think we should offer this to -stable kernels.

If you agree, could you please prepare a more backportable fix? 
Something minimal, separated from the [2/2] cleanup and without the
incidental whitespace alteration?

We can look at the indenting alteration and [2/2] after 7.0-rc1.

