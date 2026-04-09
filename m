Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83EF2EA3C23
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E135F6B0005; Thu,  9 Apr 2026 07:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB536B0088; Thu,  9 Apr 2026 07:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D284C6B008A; Thu,  9 Apr 2026 07:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5D9C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:04:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 770411B845C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:04:39 +0000 (UTC)
X-FDA: 84638734278.08.3C99AFB
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B1EE20003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:04:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eTF2u6EX;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eTF2u6EX;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775732677; a=rsa-sha256;
	cv=none;
	b=kfOCEhVri1vyUFxxuEa5fH3EtSAsbIEtxrbqE7R+0xIqg7FPbNJqtl+zEgnC90V1/YGdWH
	QaWchS0jZjFrfKbJflGd9TzfEC3kuC7YApyhs+6K9XlarChGJtl+ruFxS1wQu4BqnQyRw5
	+fmHOZ9HXy9oYHJ1JHjg0jH/IO2WDJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775732677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZrtVyQUSl1Vkkss/YEluHGFstFbA0FqBERkViJ95LkM=;
	b=Kmw4+pdz7tiswvPVMZDilDJIeekKg14QMWW+jEYkV3Tv7TUuP4P2UWaFqsq3q2bq/ow7Fn
	PAvQ52jembNv/+NInugkDgfcgJcpj+3gM1SUdmRiyjEA8rIUTzt1j6HKez/Rxtt7HwK3E1
	W0rgBkoS+eZFRwL/MAkuS6uS+dpcgxg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775732675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZrtVyQUSl1Vkkss/YEluHGFstFbA0FqBERkViJ95LkM=;
	b=eTF2u6EX+3el+2pBg+jrigA4m47nOHc+sErjD/Lp4eWVN1BQFVb58zyw/90hVUnGUDTlto
	Skw/OYZy0h1LR77kVhv2XJjNXYeoWh3LGI2Xy/0C9VQOzyH6cXLmP+z+A+XZVYsdBkqzw9
	Eji71oWiTUGeskUtlKX1gmRrGTPPmG4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/hugetlb: fix early boot crash on parameters without
 '=' separator
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260409105437.108686-4-thorsten.blum@linux.dev>
Date: Thu, 9 Apr 2026 19:03:41 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frank van der Linden <fvdl@google.com>,
 stable@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <518E33D5-81E7-4119-8168-6E31ED743930@linux.dev>
References: <20260409105437.108686-4-thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B1EE20003
X-Stat-Signature: yukti7mg897939h13fs1req48sfty9hu
X-Rspam-User: 
X-HE-Tag: 1775732677-284401
X-HE-Meta: U2FsdGVkX1/HDTn1cEfH695eS6UQn9fXqFaivExkznMUStyiFclS6Kj5Ybb/xdLXYmiCHOVw/egkGNJ536iRjktdtvR9i/rYKGnLmMPVqBVwH3nd4pMT1C75an6GdTFBLJNnhAqywZJO0X0QunpGnE1NbyOk0XFTCsKxre5E/9wbSvAIXH/83c6+wVYUELorGENKOX6HDMWW6OARLLOHa4EpOXgoVNNb5jdZbPXXmRo3Q6AYj+nLfD8IlnIXYFOAQUI9/Vi3g8FuEBoJqFyJaU1bRCyPavxfxIN8Jiiu7PWzuSk/Q6Zu5+RsRJU18+CHfD7j+kc6864f4QA081sCnXvlMpK0t5llpHF5eI0rNxrCRA/GkaPCiqNrKpfKIF6zDeer0N0421WdSiKv9vdk/3TPtJ6epP2DMMdazM37jk7FLJtz1u5cbcNSCtiblLTFNEMhCLZLJxEU1LwOryU/wWzJ9nNHBWnVKjwApgqNz6fORqDT9jaOzbP2Rai5h8/YUh1ZUCzJuLLE8wUVIZHUZrRPx+rs43UprRC/IpPyrmwUQjLTsGldBzKvIV1dfMZAJFUYHtfaJXxucUDrgbGk/LFUCFdW3cqMIil77d1fYolDkqJ4ELuxuL4Ej3sN6l8utZ2nR02WIE9mJvLwfbcPW437rAIHX9/ZqCQy8h/JVyoftJ6ZUEHu7SlkG3zWOoSmdQXsrSDdkjVf8LnsGKRlyWh6pLumj8nprLaiFrZmlFitcZnOHzUcPz63fkFvRUvQHWWbU0NFIVpGQwiv9Y6yxrJz8G9J3NC19Je8+mVBqLn+YJUfiyv6L7WK3i4CteN+tK4GrwsYiTvUrb9mKo+6fYLY2jBffeXeznzQq+FBd9+/o+6vEmUPGtU9WeMcGaU2LjzhOMW2VgerGJB8TbKl2WfzBfreTQbUfjD5tuvsnGHi09K+JLC8fBrq2DuXgB+t2RGfgTFVADCJT/BNfin
 2nalQrYT
 OAt+5gAg/aNQA6SBhLe4yGAxpLfw1BBKiYVO2/gpiQ/A/j4hAqf4ro+0cvjcybQed2mObuEf7d+uZ0ORhiOAcwpXMmANgqoN5JgYKWQcoM/zN9g/uCj2GiFxIHFRZM5BkKdtAXI0flHVzIZv8qOjsCCrJily2ieSGz+89qt38Ds+VDddQL+DZEf2ewmykMLPYzUelY77LVTrAX//wWVO4eDNxf6GS7JV54kfkmede235FuVT9jzH1FzyDe15M4Prz4EGX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 9, 2026, at 18:54, Thorsten Blum <thorsten.blum@linux.dev> =
wrote:
>=20
> If hugepages, hugepagesz, or default_hugepagesz are specified on the
> kernel command line without the '=3D' separator, early parameter =
parsing
> passes NULL to hugetlb_add_param(), which dereferences it in strlen()
> and can crash the system during early boot.
>=20
> Reject NULL values in hugetlb_add_param() and return -EINVAL instead.
>=20
> Fixes: 5b47c02967ab ("mm/hugetlb: convert cmdline parameters from =
setup to early")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


