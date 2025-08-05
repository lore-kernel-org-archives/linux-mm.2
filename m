Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFE7C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E906B00A2; Tue,  5 Aug 2025 13:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F096B00A5; Tue,  5 Aug 2025 13:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44E96B00A7; Tue,  5 Aug 2025 13:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 969256B00A2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:32:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C7D41D9F22
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:32:10 +0000 (UTC)
X-FDA: 83743397220.01.19CECBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCA7340010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:32:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9Zw80FB;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754415128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kKT3xIHrPaSBRUSzlfErq4bYssBTtJhswv6fr5Dbqo=;
	b=uCUgmJNPTDO9G1iJtDdXuPUd6z8ZLWPbg9sV0gBxoNGDh05mBclZ1VqhssXc0Vn+f6GBAE
	+TJSh+lMjiEee2JL2L8VnJ578ZqzWSDH/+d2RR4twNSXZ13b8M8gJ4MOEieGYOHjgjvHFx
	6F+e1oNVZedoxqj5Smvn52a3x3B6Ss8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754415128; a=rsa-sha256;
	cv=none;
	b=ZBnoVhqIwZ3hdLoEhTiT5uhlzKNOsdQVlqD1lVg6HVCKvkqwowuKFL+CBA/p0X2opPyPo7
	n2GL8sY3AQY7/RESN+2vviEbRulOKOI+sDpHL8ANs07Zn97i/D2pgApmSTkddJrtfo43QN
	b/l/h7zjQhe1NM4KR5rVHUv+C5Wk4Cw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9Zw80FB;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C1A1601D1;
	Tue,  5 Aug 2025 17:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44D7C4CEF0;
	Tue,  5 Aug 2025 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754415127;
	bh=9M6H/aifoCUKwuC0rptHtdBZsDlS72B3swWOIoljHlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9Zw80FBGLYJezDB/tqLgH/kZAcne22SkYTVFvvJb0f2xJCMjkebA0KPlQbMFXdiO
	 OyknCgPN1gdOnmb9sChaTg5YbhlXk3RESZfsiFqXRtjr4bJO5Q2ASML8uZFptkBuQg
	 HFdX9Ifh3HuI/UHh84mheGK+KQw/gEcYZLT6IZZtK4s0FcvFZmjLt7YKLNj/o75m+s
	 UFGckUHDEX9q5lpXUbMAUw7BM2fch7p60E71GJFATJ6xaTDkwiZa1FSXt3/hDeaeNu
	 HQYx0zsssHJpx0hIi89yAdAR+hCKFHoXe1K4ZQxeCAZt17IpbTKjGTQ/flb1G1Cglf
	 Y9GCTryhbD/gA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/damon: update expired description of damos_action
Date: Tue,  5 Aug 2025 10:32:05 -0700
Message-Id: <20250805173205.7385-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805123940.13691-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BCA7340010
X-Stat-Signature: n81kruezg1tiyctd3toeg18edasy5oyq
X-Rspam-User: 
X-HE-Tag: 1754415128-136961
X-HE-Meta: U2FsdGVkX1/taALYuRgUndHU7TCpVBuj6sRs3CWeBv5empwt7T6pLEAECYe/1dhrm7pnsXnqrpR9eTOd149rN7wYiUbMh9iUjd41e14XvoNTIxSdvB3uOMCAuzO089DYpdmhnjqulNu+hzj+PrlFv71x/TjCTGIoDQaSS8h1JAefF3/8oIbTFQefiUqgATmVSicAKpaLkd41URxlH0uY5WSnYqN9r0AgeGx+D5JR15yLj0gYqCv65MODHt7L22ytHcWymJJ9fiuWM5yQxHrfDOJRVFVi2dLhH8JtEkYrRE1lB1DpBqyTogTjYNAUdxA6cd5f9BRl4tIjwoh011xk6bgYVM4B+EAojBzFG/rUUsNYgQzUFL0fbFwVD83KPBvIbdxGaB73vcaxAnt8lescdZzqc4w+a5iZEhocazBrWOj474sTvGOVAOOH78WfuJXEBPfjHNoxrAGCzlYHmPkRQj2Cn/zynmvq+jW1jv6fNrqpz/RrTk1zOytbWeBaklfAXEkPQLT08E8upK5G0QaiOMNEWKQW1mR6GGyfVlcoMcaALxbhCJHZCUcrvtRKy0/IEM+im2/EJoaQr7PFN0qS8rSkMO2NiASbHHtKoRRfbhUfeYBecu6K7jrsbr6743h4BhT9Mtfl386go5wEnng4EsxfXrwa1GL947Y5ts+ZgQXgSVgdCi+rsMEzu/av7EecyMBkJuyRmibsbJIhWTEItyNh50UW7ry0dpXMHwD1l4ADDU2W3wHjMysdCtAYuyu44s2bpOjE72JXn2seMSKyp5MXQ5AZMxK6rgfHwyjhfDd4IonY93SSP+wXDWqtdM059FHhWmmyq2UsqGweNVwkTEIV7RCcvW1nFiSDmCm20lONzglahOSnZBNxYx9ahCgTlne9Dl2Lm5LgaqewlthrElx+HSC1oIIu+MvEynKCldrbf5nXuF+Mky3i2UhNduddXnTl8pOgqjWF4/ab+9u
 kwiNf8wk
 OjJ2r3HkVZIvW8Vh9L0DAM8ehDgs7wxKGUM5sRiubwzdAil6+EQea2bvKleVrZB+ECADDwZ7b5WZJasfiTWZqZAdgxM56PrNGkSD826k3nJuDwtis6PAudxp5M6c0JCQQOcO0j4GbpuGVeCKeGENbVKJCu3gok19nf6NyUjDWVj+CyrjkeM1brCYwzpaeUfg6g/+tdW52MKQJKh/S83eNDCQU2w2fUc6f60ZV4L80REv1pRNGC+yiiC6xtWqxIjyUBvRF708+ugGJxcwEWA+xSBLkmqy/0y9cbMAYDePhiIkVPlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  5 Aug 2025 21:39:40 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Nowadays, damos operation actions support more various operation set.
> But comments(also, generated documentation) doesn't updated.
> So, fix the comments with current support status.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

