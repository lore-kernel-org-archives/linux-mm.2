Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B3CCF45DB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 02:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0CF6B0005; Mon, 12 Jan 2026 21:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E686B0088; Mon, 12 Jan 2026 21:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACB86B008A; Mon, 12 Jan 2026 21:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBAF96B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:00:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 934121A14B4
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:00:18 +0000 (UTC)
X-FDA: 84325285716.15.1F04346
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.6])
	by imf23.hostedemail.com (Postfix) with ESMTP id E916014000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:00:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b="f bQYBnU";
	spf=pass (imf23.hostedemail.com: domain of cp3alai@126.com designates 117.135.210.6 as permitted sender) smtp.mailfrom=cp3alai@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768269616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cpMMSXmxxAK/oz2nR0lbi8N/BFlxzjt8GL5z0xcp/9A=;
	b=Ylm6JVajLGQ9rInELhb7e9BlzS026bB95bzZ7+l3G7476HZ/es8CbvhkY6ujKP6LgRcsig
	hrGi6Z5325NQlyuU26BSGIvHdads0Hb3aY6borsNa7XwrZRolFeLMALdqml8RYyXfoXuWw
	q17oFWlYVq+wtKeneJcVoVYJS3RyC38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768269616; a=rsa-sha256;
	cv=none;
	b=vD7kIJJ3BaPeutthpZi+hMk6vtA/Ojm6j5W4AETp1L7UVqHIf/6UKA+0RQH5q7i9b0tbo4
	njNt3FEXeJrW9ehm55E/a8k6GFUpZ6iywqR8CXZ2NEbZvgOCTNxPDI73QJqE0Zl3NDJbYM
	DpnecpImQ4Y4qX8deEUCOgm7EIGdaJo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b="f bQYBnU";
	spf=pass (imf23.hostedemail.com: domain of cp3alai@126.com designates 117.135.210.6 as permitted sender) smtp.mailfrom=cp3alai@126.com;
	dmarc=pass (policy=none) header.from=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=cpMMSXmxxAK/oz2nR0lbi8N/BFlxzjt8GL5z0xcp/9A=; b=f
	bQYBnUj2Twy3AHfRba6wPyvWh1IVSEZVHlnZGVIaPV1SjkfJyK6C/P2/2e7cDf+y
	pTj4N3HuNrYyNbsBsj3dZ0m38dARQqxWsJxf2PjksjujZzLUpm5esStCIis6oFEb
	rIy0ppNTZcGLRkhBbcOr/hKwWgak9/kd1P0VzCojOs=
Received: from cp3alai$126.com ( [49.7.65.243] ) by
 ajax-webmail-wmsvr-41-107 (Coremail) ; Tue, 13 Jan 2026 10:00:11 +0800
 (CST)
X-Originating-IP: [49.7.65.243]
Date: Tue, 13 Jan 2026 10:00:11 +0800 (CST)
From: alai <cp3alai@126.com>
To: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-mm@kvack.org
Subject: =?GBK?B?wLTX1GFsYWm1xNPKvP4=?=
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 126com
X-NTES-SC: AL_Qu2dCv6dtk4q5yCdZOkfmUkUjus3WMKyuv4u34RQPpF8jDrjwg4aTHFNLVTZ2dCFLSqMiTaGVSZo9+Z/T4RIYKUOLK5IUAtaKRTxyH8BokwUqg==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <697cd2e2.171a.19bb5150035.Coremail.cp3alai@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:aykvCgDXnxArp2VpysNDAA--.50487W
X-CM-SenderInfo: lfsttzldl6ij2wof0z/xtbBrQunZGllpyuk1wAA3W
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E916014000B
X-Rspam-User: 
X-Stat-Signature: f5whk7aog1xnu5wb5wpyguzsimhbqud1
X-HE-Tag: 1768269615-791594
X-HE-Meta: U2FsdGVkX185irw6SuKJzEbSNMoadxkuumRHVXB4HDeQONostl2ytey+9jkrsHqp7oty6uXnvs+BJN60u40H3W9cY5sTfw7fJTxAG0KQl9Id/v+ddCV3+pSrLbnKtoVR1zZ7OqvL66dY9L/0AZT2Wc8M2OPg9KbPSbolNAz3z07bwjE+FNu7K+D3y8pwTrxLueDNZqvXShUVt9YCr3stCFpV1JRD0bmVQ1SUfxl6hr0YGajYZbK/KJ4TfrqB+OhYl2ONFj0L0W1wER2W7VriTiy2ANJEOPNmYp2WwOBR0GW5R9uh7d1jvR0XfkHrXKNaGmt331mHcumaRwZS/LQ4ZLh1LG/IekpIf8+qcRfiFUkxEzpkqG5weVfOpPaElNaxGxfQpoRjJYR5PVBQ04+w25+jMmZxRndWUzZkEvjQZsog5V8DrMMnw5r4umxnmWVRTb4VHe9sc5EDsCBw7IqHentdxS2veK0lP9Tvd3DyEqQd3w9FVVYS+LkAZLawWIMWL6wasc9Mea5orguEcB9iM56RFva+F+AUSL7TejfRG0mG8PMmFjMMsw+6qyPvSjeLK61y0OrbKp9k5mcgefm84feTb5fqavYHqHIO/ym3jpXFKU6YoTnkPzqNhg9bYFI9UBqrsAcGBl3snnSVXtM7fK0sDe3yJw1Ne9a+opuUkwYDtM9mie1jmnxQ6z/96563EwVje/2Qtg215eWuOzg9z9E8df8Z8OQ0NYXnx/850hTFH68uMQX1v+z7vVxdIJ2Ajtnu3XABkBIR8ZcyqJFfsz3cfWoIldTDURee6il9PiJg5WRaQ1+X1J1m6xzkNnZScaMHLqJUdwAV/R8gk7obLpGigV4D2QbE2fvm8XgfeyGi2ojR/wAZrIh+G9g1BTmxaqLb6a4gteQzns7bHN7xxUoyAXM3zzYw6xogUzGUh3CagZg+ldJ3/V7pDQhChC1xk/lF5oqSwBxgnf0IE1Y
 dQu7ufxN
 DNVS+CTWbUz22bF0ZFSZ8A1mUfTFVTIQ4OXhtpqVGoc/6kmxL7+HZKzNEupkbXAZCnKs7KAcn8f6JvwEHrZIjVNaaqgMtr7uvtJhURO/P0BHK5R0kYL9GxdfEwJ578La2JVFDotsSTwfzsBXwKfkhM9+CORzV4zewgBivmm+m7pQcxdvJ02S21zLjuJlMSPqW+yREZ0gC3F9ucdUtYli5VAF7E02xZ2wXNVu7PGiieh/RwjSEOrkUHGWqVfAs5xh1i8wNidzYJHtqhV2ppp88PVVVTNFUIZZuRkSy7nmN3sVzzKowtpxMoSXrO48E9+J+/fxB5qJwRCxjsGBGnoXKzjFQtW++EigYfYFeTwXuSw+omAwxHHdRDjZLTJd0PUU9uWkIjR6hfEYMtFa3yJWpRYDR7H4jVXU88UjpEftbbpfyaHrcjzHH1JDCbebzqZglDyie4SQN8GCK/yGuoY9cNI1W0V3+RcKEPd8pGv6vaaF5WDRgF5JbzA26sKqeYC3vMCP4bo/MRWP0cGOx+wW6XUqOQB4SzgmItFwjhwM/ZIY2dZ6r60z5TLH4lrpSoFZieoeP9RBdh+P49QahCm/kh/uVEC8nbddX+JEL6bSuhczt8V8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.074075, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgpzdWJzY3JpYmU=

