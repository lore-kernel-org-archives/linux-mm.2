Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD0FC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8D06B0088; Thu, 27 Aug 2026 13:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99416B008A; Thu, 27 Aug 2026 13:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88096B008C; Thu, 27 Aug 2026 13:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 895A86B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:35:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06EE5C0116
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:35:46 +0000 (UTC)
X-FDA: 85147751934.21.E62B259
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6682F40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:35:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bk4w13ik;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2o8MOsuV4Jtw0bdDdi6XdQxXMsv0/NeHM6TvE/6nwQ=;
	b=XJ50ex5fdQjyUt1RmB4ZvLPYT+bMlsFI/5ubG4ipS+vtVpZDAaKssTeP/L7zOZnbSAuvKP
	k8VEajfp0vfIdBVLUc8aUluD7Af+OQTz9cOal4zckQErmsp8QfaO7kmEnw3Lnjoluo6Lt9
	Adagg4B1zox/qOZc/7buaQwkA82hmsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787852145;
	b=NZYQLMobpmpzJZdJylIUNsDK/ypia0IX2Vla5yB+kR7cmay8TVWp/y7hQu9r72qOWcPGeA
	XF3uulHCr1cDZ0km18YQebCpDOCBRa3YY1jJQTpBcPUy20Apz7MW/10OAi2Ry8saE/BBS4
	NJSzwnUpeq2TQz0m4+X/fp6kWa7PPRg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bk4w13ik;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD240600D2;
	Thu, 27 Aug 2026 17:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661641F000E9;
	Thu, 27 Aug 2026 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787852144;
	bh=z2o8MOsuV4Jtw0bdDdi6XdQxXMsv0/NeHM6TvE/6nwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bk4w13ik+oNJLlCaJU9UGdlr8LAknop2T13tjJCfGFeSmTmtry78KGtazH+HM7Hvn
	 ehSik91/x7Wz8aAfU1U25dGLgVoWUZANGcvIPueQ/Lg+0yxJ5iGM+XvBo2y6Ik0QKi
	 UnIE970PZwh+KufLaJg2PQKyLB2exuSkuxVKu2PxsGCvOCYzVT3vE8pI3P8lVqHHCZ
	 qomINzVPwcqJ2BbNmSP4VURAYLyV5H3yiHvikO/PFD0ueO9hsvB+S+5DokZp515fXb
	 dRX0vmhxPlM7Bildubr0iDMLZyL6HvhTQOlp7rcNrak1ECxViWt/vUMgdfC/gh9suD
	 3UjjQGD8NYj1w==
Date: Thu, 27 Aug 2026 18:35:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: artem.kuzin@huawei.com
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@kernel.org, 
	vbabka@kernel.org, cl@gentwo.org, linux@armlinux.org.uk, will@kernel.org, 
	mark.rutland@arm.com, liam@infradead.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, wangkefeng.wang@huawei.com, panov.nikita@huawei.com
Subject: Re: [RFC PATCH 02/18] arm64: align kernel text and rodata
Message-ID: <apB1JCaNkGQMJQqq@gremlin>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
 <20260827161158.3618409-3-panov.nikita@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827161158.3618409-3-panov.nikita@huawei.com>
X-Stat-Signature: d5j6caaguryughwtwwojdtktjtaz55h3
X-Rspamd-Queue-Id: 6682F40003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787852145-319627
X-HE-Meta: U2FsdGVkX1+crwoFp3YuHy8Zypb8NTxoBp8kICxwWP5Olottwi32+D7iqE7FRxCnTV275V0z5TykXIDShptXCndjWqtpRtXKZmDI2PJ6PtPHZuBR2Z0Sgle3v8xThq2ThdpXNQ/ZXlfDsbOQ7UQd40quQ6yI877zIim2K/0GKZ9vMFdZHCMD7tPtDuujX3qkon6ZfQWU8gOQBlmwN1w+8X+JwJPIzziFZgYDx/S7IhbAjYB9zcZ71DJn7sblG1Eoxhhi4FvMr+gsQprz4KrAZfdGvq92CURU3i0tAn2MN0wjhPIIqkTCQJxP4PNW5OR9i4BDjUAye9WMQBH54tCFkWBFfa7ZYs0Zt5BqCdGb7Vea/5JCp1HhFmP+97VaoL+bjXRJoyzQQutS3hX5dg+CXaE3b9QPcN0bpxRjUsDBtlvjTF/wgODDe05SdbFaVNsTR9UQLRlps9b15sDfMxFXLESveJIsD1nEjH7HSHPIbi9Ye+TYdjZwAX3Wab1flZVg4XcrRBhgayO7xcvQKfYAEDJ0MaFkK2q8bQwf+KNV2+UVTwfldUMNx2nhXjgajChWHU7fbvYPgmOHVATrpxj5hxZHl0zJZ+Jf+ZXT2JVo53ot9EURj60Mc2dQASqmJX83WTsjGBCq2K6aNiVIl5kY7aTySyyBDp01V0Cpn0e64q2J1kJzugUouZubQRePG5MvB4T0jfQvjmDNEpTbfesOuKe7ja8bEWZ769QzTHyWhGE8jYb2puS4vgqDAzL5NTxMayF1d4n+DXmFTYtIPracmzOQ2ENxhdMJ7w3q6+feyrdKxMI9Nxg4Eoy+t4Heyl2TS64FI4/73FRz1BG0XbEEgysYhr4huoJDj+OC6ujfRxeFn5fF+vZV7RWnVKq704g61E9KbFFQBlXa3xRDRAzeW6f3C0hNfqH5sIZ5+po7xvuYkpHN8fg1INkFg74xTJllZZcgawhu9P0HAUvonWV
 w1QmAlP/
 iW7g5TFvtC/wWksUO5xc2c0Kw/VdSrMfh2IGSTqPBb6V5ew4wV10g4OdzPnHLg9xVJbOBluLHS2s1BvY2NDeDuEpHhn2fyVnHOU5bHcZ7aloacYaQXcBTcjFMWes0ZNjiHog+LIHQIuUpGsDrfcgkVapL9JavSBiX0VKGk3kojn02qp67tFcyTJc96I+idhJP9arkcIHkyIPVW5qtDn0sogeL/+/fBy5E/NOTQNRsrWU0MmO55QKu4WFBHl2HhfHPc05Whb5hfhea5yplLGs7eumzYUHJON58XlaPIV1OEYKhBIjXXzFQp98TbiUzTycMCxPodxSMFq5sNhFXb+QymkTO6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:11:42AM +0800, Nikita Panov wrote:
> Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
> Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
> Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
> Acked-by: Denis Darvish <darvish.denis@huawei.com>

One small note on procedure: it's not really the done thing to pre-Ack
patches in series sent upstream like this :)

--
Cheers, Lorenzo

