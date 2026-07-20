Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAA5C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9557D6B009B; Mon, 20 Jul 2026 11:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9068E6B009F; Mon, 20 Jul 2026 11:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846276B00A1; Mon, 20 Jul 2026 11:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE4C6B009B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:38:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE079A020B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:38:42 +0000 (UTC)
X-FDA: 85009562484.03.47E9AD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44FCA120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:38:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+CF2QBM;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=320lZWOP7Be76LRxzscSD7R+x+bdzGRYS+OkSMWeIUI=;
	b=3PNE+cc/JbZhwRhIfrwutGjW/WRLc6LSlrBUbNav8qq8Y8S90C3qQqHe+JI6c1O9rUUmg4
	cmGCmlglxDW/zqxKSW+yhS+LvPjoxLaYrN+ExhF8nzr5q3XRMCu4fRXeEJsQVf3t6Bd5I4
	racErewirXWnPg/PzrM2ZXLzB1YKXPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784561921;
	b=A8tUk7k1u8FycnbTrxXZkQBI+1TapmcLs0D0JYEAs9GI3uZgdpDE4gyGRko4oAww/SWFPY
	6VRj/F1jqULzd3+bmrgKMmQBOiHYGC7IckbMU3H5lleiK9c+RzaGy7gdvjOjw3eIEGEwEK
	hdJPABilftidZMtDwP8K0xy8O3uQfkc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+CF2QBM;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 773B943D0B;
	Mon, 20 Jul 2026 15:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3CE1F000E9;
	Mon, 20 Jul 2026 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784561920;
	bh=320lZWOP7Be76LRxzscSD7R+x+bdzGRYS+OkSMWeIUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+CF2QBM9I1dJaRlQr96O9J8QoU0CrUC/H27CPaCXNxeJc2q0qmnRE/0raoyPxOjK
	 +6fKQvMZbkmEBEvOTfXIhoPdTXM5YnaM/+hILaWctC4PUJG2ijAMXLwt6Ja8M7wnRn
	 QT2R4FUlk9ySUn7z4F1T+7UxvZ2/SzxhX+QInRsHcQD32KzE6EnMg+JTTvslb+ACbn
	 bZ4yNE3XuZVsSNEkERUYK6NUyHrAPeS8C6mdKscMfStpZVmoRnu67cGTkmBWtotKrO
	 +Y2JQaHhui1c0GXEnYTLJ/RqpaHhyoZxyHfxd3ieOzlytoe6G7ZkCkDEhDVYLekwm+
	 FstokRc8NABIw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Yikai Zhao <yikai@z1k.dev>
Subject: Re: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Date: Mon, 20 Jul 2026 08:38:31 -0700
Message-ID: <20260720153832.90939-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720094708.243937-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44FCA120002
X-Stat-Signature: 1rgmkbhk1tn1ehhh9n3ktkpzqgp683ed
X-Rspam-User: 
X-HE-Tag: 1784561921-750680
X-HE-Meta: U2FsdGVkX1/PQwGoQ3vCl4HaqZImya87bAa1ftKNnTR86L23Df9mqnXHxiGR2g2hCuHhQcpDBssEUehKdjECB3YbDS+9Vg3n3UN10YraZP57xAzlBJkcRJc8ykrGHeOIjQw2KQKPY1Cki4zWuv4Ybyo897jhSQ6aPoSCQZhbTOujhjxjyD7v8sBsqu2x79G4GXLwIXE5EWLoGcDksgm3TAsTVLGPg1LPTC9vm4JcWjSuA+k0MkHKobflqHZ//cMGIJ/hsWnR9Lgsgg0fov06nJ/t4D1sh5PD+xAWPukxf/glbWZroa72n/XvV+wpcCd4hBtyXVVgCvU98uNkAQs5tAOWR2qbXGly+u7jt6iqY2de/dQQ7BX1ZLp+eHKEOCb2Q5KR5wmY1ccgVAMMZ+VQPBTJLbNbfueromkWDUCjsqjbJMfz/PZfqLxwgVy2CbE0nrGzDiXN7Fr4AKoPpnayEcv3DqaQNBj2HNjDBExpBxrdqLu/5cZAzQPYjeFOoeqD+qk8wZwyh7wRJVbZod1xoi1WR3FsjmPgwDHwKFcjFrUy3MmCRc1VAPra0qQhSnOsR6xVD/r4wA0lrTGQK0CnMQtsmi69XCOrdWHR7tVlVBuhTG2KJ6ACWJ5XLfJV3ZQXTpqMxu7plQQ9gQ1VzX5EjzxEKlG02ceBEIH+qdcKyvcZRFKtW6ITnvQc3p8q5AxDxZfmbJVXm70Fs7X/6nyq8ED4sZkTYxx9pdXNFEI+Ik+XKgSYrUkKXcJADCMYe+TmW/G4BJy/yOQ11wo+mPCv1tFF2ROZSMWFZFpTAmB6rakPxKc3ZEWyQafd/XiWjxZ0lOpkq0AtU4CBJXr/3h1b4MjL2Zg3/VTUS3pENn9saMAGudZ6Fuhauf3hJqyHHjlbb5a8E1Gw1IszAQe0nN9oR02Lbm5xSo7oaE7R+EOmQpavDGM76Vzv838SphUeVvdDCahBX6cOLVkGLX2/sV8
 U7NgUzwF
 tWY3sJPrDuVs2Tz7PIjDAtQANoHayn6tYjstzn8DEOLWqjYKDczArzVGkw1Jy0FMK1cwbORTI4MjvT7gafGu3IBcQoMrv1FSJlju9N+0QL0RcQenYKX3juymWuoIJ0CmMixQZhS6wB4IUyBs1tf7cO/F/f5MXbPGd+OhaXPSQwkKRKSGKGVlkyoAvRvSMf0xhiQ8VCNOwvVjlah3jLVQrnGALayctCa7VMQnIg1oTUuHf6ycujdfkoTNwkhpBhptNDHNJP5XSkgZ1NrD7sWtnzXdj9NEL0qByEPFcWtNmZUGEYIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 17:47:08 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Commit 2f54908fae211 ("mm/damon/reclaim: detect and use fresh enabled
> and kdamond_pid values") introduced a typo in damon_reclaim_timer_fn()
> where '!=' was used instead of '==' (unlike damon_lru_sort_timer_fn()).
> This caused damon_reclaim to return early during the delayed work,
> breaking early boot parameter configuration like
> 'damon_reclaim.enabled=Y'.
> 
> Fix this by changing '!=' to '=='.

Thank you for quickly fixing this!
> 
> Fixes: 2f54908fae21 ("mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values")
> Cc: <stable@vger.kernel.org> # 6.1.x
> Reported-by: Yikai Zhao <yikai@z1k.dev>

Closes: https://lore.kernel.org/CANMyjpgq5n0Ekt4dgyLRHGb89_Ew0aOMZ3j32V_w0GjHkqH1FQ@mail.gmail.com

> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

