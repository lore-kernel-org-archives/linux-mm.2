Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63984C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512146B00A5; Mon,  6 Jul 2026 09:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3386B00C6; Mon,  6 Jul 2026 09:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400396B00C8; Mon,  6 Jul 2026 09:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC9C6B00A5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:09:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36945A03B9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:09:44 +0000 (UTC)
X-FDA: 84958383888.06.BB620D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BE1F1C0005;
	Mon,  6 Jul 2026 13:09:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOSRt7ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaUS4o+OCdA++JRZVpENFHMgrpsIBgCmDimelppknkc=;
	b=ODW06bQted5H2Fa0vEgO3+2rnya3LWgsP1LpNlsjSedj20lY7FvYPi+/+uuLL46DFYWan2
	Ipn2IfujD4+iQ2jR6nHbN4oq1Fce+2Cb2CunsqjN9O+9ELdTBTdZ6WWHBEU+rdOvmTiEsy
	tvaoY/E1K97KVBMfYTD4BOHzY2LY4k4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOSRt7ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343382;
	b=WSZeJq/XCPBSwZPvVn++1AujulszGdd0eD8fq3WxW7AqS2PKjMy0xKQpKcRNm2ei6w/PfN
	aDUrcJCFSbKhQbeppRoVm7IebPwBOqHpDEq7GNp0bfpbpBW3VWpcVU9lg3F1coL8kIJKW5
	3076xByQkxZTW0hQ/JU59OuvjIJDFb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BE1940797;
	Mon,  6 Jul 2026 13:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119D1F000E9;
	Mon,  6 Jul 2026 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783343381;
	bh=oaUS4o+OCdA++JRZVpENFHMgrpsIBgCmDimelppknkc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=IOSRt7ts6ZiFuuYHDDuuAdfzX5zZC4jjq4v4cJeJ/0xCdvajACZnYcro1UaRufaQu
	 k6KaWVYtuCn+SA8PfScCE9DCYsNyQPZ5KZzAmoh5UtyHwi1R85C+4Bfk+EALohOowK
	 6V3WCMdX6qI1AcLeuIwMKW4YzZSzeTH5Gg/fgJiQ/0v3pcnPz38piZ7rHjs3CjbaNp
	 +wBqfPTYjnG9oe39BqKlfljNCvH92uur5h1l89Y/Z3Wys+QiPPzCUniozj9rm4hn2o
	 nu9owkT5nTrx3ziv12Ey0022YYQGEEU7eUZ7DNBTZg8mueWWcbyc99txirtYEbezMu
	 hYflRKsrle9Pg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, 
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260706041125.642097-1-hch@lst.de>
References: <20260706041125.642097-1-hch@lst.de>
Date: Mon, 06 Jul 2026 15:09:36 +0200
Message-Id: <20260706-hochmoderne-vorher-chipsatz-8882212e1328@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=597; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OcnMw8egfvLFzXD/0CCTqlghbuhYW8htOYqsc71uG2Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR5rxTeuk3s5/GXM8/utNgdk3dV9JTCxQlpT72besXUe
 i5ztStwdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkSyTD/0jhBa4/V3W1c7Gp
 VDLWzq15FvX2yTXPnAmZivmzX90+84jhD9+E9uS6vsm/Oqc+WTg3/X+2x86Q1AMX9mvJab/IK5s
 2hwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: w8xas6k8nggqodgemzjjpxzi4ghnupkj
X-Rspamd-Queue-Id: 3BE1F1C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783343382-292959
X-HE-Meta: U2FsdGVkX1+5ZCZmwrlsU5k8I/g6HwXBImU7L0X0GY5C8gkfI8xxi5idzeu9QFjcjrDIDvsfrwLKI5WzYESQtQo3zNkQyoqNqELXiUi3a+R45nRgWB4rFpIHZCw9j4SmKoK0mEWjEkLV6Zc/xaN064mE+ENYzBTibyPIx7u+tXHti1oZnJWPE8VPz/XpRAcsUpvVjEbia6TjiybiwleLyLomkgcsGtbCLb1056lrWDOPacY354YFVxCiRvc88lc+lWIzyBogwdcbRHyrq7cR0rHdJH+VkHnMIyiaf+0xgb5A0p2ipMvm9XnKQHqyRf0KYZGBwUMETlvSovJU4Xa49OLbDBe8L5ZLR5SiFOMfHLtSvFQAdx4gygisounN8GVLPi+BYAKHR+4Cvu3hYVhOng3nf3nTquzPm/7jF4iWJI31TT1aH2R4+C9ezWpsPppARzong9XHyN5TktkxT4/7fqDApmS1SAP7KX+UxcYxsyQsNCZGi37n8rIU/8Hzfv7dAUIg0JUULmM+Xc7vqq8Y2NTdP0lP59ww7MNrr0oqpkfEaBDa60JzT3Px4UxgZ5l8MN+dv6fIzUOpSTRn+fGimLnLNN/VC/tiiPGugLR+WVx8i0PZw/EwydFbC6Qw9aw+ejggYh+S45zUSQDUoAyog8dJc2CMiE2q50nUJzLVp/tnLOKiw3ILPGYg5vQTZqpf0Y1DiniaM6N6NLlbRPxq2dP0BhdGdjN7Y1IaADooxLxHzQQkTnuuyyk7vFL1SyG+/oLJBTeAdx4xW6VfxlJHBFyKJrr3YtWhWE6LQ76lGJWmq+9RmCeleTUxPBwDKNr/in/g3kv4dP2pinZuC3fSqqUi7HYhwPnqAr3UzXxs2UijMYbVnmnAkfp0d2yFjhqJRHm/+7Zel8m4uHANRKGPLxhe8QgFpiR+1fksuFh4DO9oPG053tgBaX0GRdC5n0Fxg4H7AgZ9YrnKkDLK979
 /pkcOuZQ
 D628wOAcgryeiG2i4d2+tJCREWxusnBUbsquZdRSkB5F02aRA3ObKNRE1G5Ok1m0WDaOfxJH4XMIO1dbrrUMSi/20/dxdsFLIP0qoce8aflOQARnDE5yUPfdmhXE0x+1Y45x8zTekn5l5XE4G6euJthw7VEsYL4fKCTE+wRRgWGjz+tfSEj+UN/E1oLJ28DOPmVuO6+FObwse1vHjtw+N7+LiNQFXPTULiYPz2JIqNw76WE5BaiHoTYO4HxGeNHOizCu4QdoeUv5Yh7DYHi9WIktwOK8iCxaEKl/xBG7nKAPjq3XnMHwiDA/DEhI0fiwdNgj3g10J+SBTLQJ1n0YxLrfFQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> blkdev.h gets included in various places outside the block layer just
> for struct blk_plug and related plugging functions.
> 
> Split blk_plug into a separate helper to reduce the amount of code
> that needs to get rebuilt when blkdev.h changes and to slightly
> reduce compile times.
> 
> In io_uring this requires pulling in a few other headers explicitly that
> previously were implicitly included through blkdev.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

-- 
Christian Brauner <brauner@kernel.org>

