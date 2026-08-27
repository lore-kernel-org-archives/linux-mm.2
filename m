Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300E2C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40806B008A; Thu, 27 Aug 2026 02:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA6F6B008C; Thu, 27 Aug 2026 02:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAE76B0092; Thu, 27 Aug 2026 02:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3FEA6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:26:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36EBE40330
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:26:16 +0000 (UTC)
X-FDA: 85146064752.19.B421B83
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf27.hostedemail.com (Postfix) with ESMTP id 094084000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:26:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="W5/ygaN2";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787811974;
	b=TQlaPIeRrveSnAYOcKiBnESVSJmHJiBFNCUP8WDgCydwnzreavHxgjrBpQGl/njus0OMFn
	spXDgBk0/qvDf5Uj/YSO2f6KgyBQHtTlZTesTACJbt+Naj9sukqwynnmTCx8Pvx6jES99n
	rrhMaizam5iSvOXRHwIlqGgXjU5tBHM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="W5/ygaN2";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787811974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paUlhZn9t+ILv8kEAUHY2bGSoJtzMH3jxankaf15DKA=;
	b=4sCI+Ahxn6WSGGA4BKVcRC/knVcM6GKeMXyK7WpGEdOqNVlLtxUl+E8SW2b+Wm97yGLPEM
	dzIPTRvSAuDuZvavi6Xk2KMO9hPq/j+ZASSUd/mnL9PIRodSg816/0KqkVkj/3K+ip+wl6
	tX9iYyk5HD2i35oB6f/QwuLrn2fdHoI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787811969; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=paUlhZn9t+ILv8kEAUHY2bGSoJtzMH3jxankaf15DKA=;
	b=W5/ygaN2Cs00I1D95eeNXSZsnn+GIVttC8jQmNNcv3ovFsxZpYw6SvgUVZj0TNenIjyHnf+rPLPbHpCjYGXuXApow70zbUWel7sDSJr6HYOSCRYBY5jEX8woVPRRBIG3GC2FT+xJ+Whl5k1Y0H4o6D0xDuom/8enpvhb4IvKXR0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X9ijePx_1787811967;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9ijePx_1787811967 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 14:26:08 +0800
Message-ID: <1cb2ee22-5d41-4992-a44b-6fd27e524b6a@linux.alibaba.com>
Date: Thu, 27 Aug 2026 14:26:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 094084000A
X-Stat-Signature: 97nxo7anmp4mbtpw5799b6ic3yi39i31
X-HE-Tag: 1787811971-98527
X-HE-Meta: U2FsdGVkX19CoAERRCixiYE7BmsecLZxDau937Pjra2Ld926+spko3JPh8pQHlnMZT8f4ZqEY6oPj+VvlRhz8zX6h3Y7Rczi+BPNKBR2YXRKbsPmtVSnkHE53CNJjMsOx9fCGyXVltjLzbdQvLQPdxWDN4CH4wdFXoK7G5ZhTizxLeNFuXA5k5pDUfZNZ2RR//qLSBol53pgakNUiouKqNzlfXdz+pTWIeKwFytaRxM5q3sY1y4njs/xJiL3w+9/L4hWzE2sBvpY2/fPxnWAbIMZQRQ2aOq14gZ+uivpUUhuwpLjBy2yq+H8eVG2MP2JOnHDq8gcMyUK05xK2o9pxyJbYYQL/SjcsM1qXVuX3/3u3PavbWWOK+02rvZqG8uLjcrCHeNB0uTq4D3MDNSylN60FSow3z+CTWHMFlQdeO5duEcEVIYAQbfkvz4xXPBBN1TKAiFdEuloHSS91FPDixGKEiamefHFh/+gWcLYhtRfnttqff6fPPhJHCGQ9QUYfOAEizGQyR9kjcNIz10xZWRSJnZWyeLDoK/HC1yrsdAzIASGsdxcpqdVROlL4n78sDEUhYjwzGY/8D26mySR2stkcPiSSLxAWGPNVcvy2/a1cdxqbEJ4ITwhnmPCr/zH+WDhWY3qEFo5VrsinVDh6erkmtoxqtn6Zd5dr2PvD6ArzPcvC0Gql5kAVVq6/3zMve8H2qhsryy12NniqljqSn+LztbU1Sb7fdSVV+4tpDUaOD9YVZ0158Vcc+lYxjVQOpwGs45F5BxXu1jvTVPDV76h2+k9QmqArGkrVqqGirRrl1LeyKnSj7UKpxVRziuAzu3r4D7d85sdG3k469JoPWvh6SZpWDN5ds2ov+YZgATqegCaCQwwkuRaSRx+/oUyptmT2b9H6vq1btMmenDx6SsLbJ+f/WM48O/lhwU2NLKrw30VWrX2w5d0hu99yaOds1HWfKIMP4EzLaYNzU9
 lBOGLY0S
 cX/rCrB588+TnvxQVLZJ08+3OTdRXIjUQLvfgCnSIu9r9wzaGRQ+Tu0FoEEggGOLafnQtX9YcO0EkBc14JRWlJDrfUYzH0o2AXthiOioAGdbrl1rLz8rW8nq3dNj+Ac/PXPrsGguSOcG4EnuzOwTpdGGIQGNHfO2X8zj2JyJBv0WEmHZM9zxHUKs7Y5z40Ap2b/Ihrao5F8iEKpB/+fQN5I1YwPSTaHT/A0ZJWZ5juxMvA5Eifvtup1itX2jx0fQXiRTHydRcAS8bzNpGfa5JRtaq/l4uKLMpwdeSbfTGz7/isWclQ5PIKL97oJFL0I7Iu0paV0aZneWL0sARuw94zqhM9P+J7xXqr5IxvalO9RP1TrL0shNM/T4BJIHrSoWIkTuf2lgOFKjVTDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 7:20 PM, David Hildenbrand (Arm) wrote:
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
> 
> Nobody after us needs these parts of the argv[0] string anyway.
> 
> This patch is inspired by previous work from Anshuman Tewari [1].
> 
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

