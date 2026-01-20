Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F49ED2629C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 19:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865206B04A1; Tue, 20 Jan 2026 14:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812FB6B04A2; Tue, 20 Jan 2026 14:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F686B04A3; Tue, 20 Jan 2026 14:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62CBE6B04A1
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:56:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 041B8D275C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:56:56 +0000 (UTC)
X-FDA: 84353400474.11.8FDA427
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id F059280006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:56:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YjpIfUyQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768939015; a=rsa-sha256;
	cv=pass;
	b=ltO/0zYHWWXLb0h5QSMXwruVJh03bIBN12je5W5z2jY0xbPW8rHwSs2Zvyepg1HLBFO12+
	zCMTsJa7ba5VXVSLX+x0hUQIeZlZ72WbXuGeU0+lGeG2dMKodiSJW1K6coUUoHmNnRTukC
	pdgIsrBNOoC3vMi6tX2J0AqTRGRg9jM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YjpIfUyQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768939015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6V0MzzonTsj3SY2V0AuVyvuQ6Xxvu4Y/qBnCAG3I38=;
	b=GDvB+ZwIIm1ZurkuzDjf/yXxFVznp6IQyhCSwx/x0TgjWuUtxk9g+2JkjFv8F4eG4ZxPJK
	zlMw8Ul0CMkTbdXo2UMFgowbj8eebqnFCK47kioR54UQw2/sZOsuVhLBcja2LQAv6VUW2s
	gJQzdAZyjw4fk7xnyRkxj9e0vUByg8A=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so38354215e9.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:56:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768939013; cv=none;
        d=google.com; s=arc-20240605;
        b=Q+ZybN9PSt5sy88fZTJnu8BmtQIizXkQX8LUMZTsCiVIpARUB+SAJiB6hO0ZVSjRJP
         vBmPibkSGrkAKaN0fG+VBpFoFuAX7UWg8bSO3gIvwbpQJvyAzjFabsii/Y0VUiBMWXTw
         7Jy2KyLkYfnVCsbl6VPZeIdb2OQVx4rZVRiEp8NzOWu7BXPon7QU9x3EiAavMZ6AGX/L
         Q3//Y/IuhDzhm5YGVc6XzskBHW1qJpiDVhULGbQ8iqdJ2Qlj7M9tQGotS+O/NVuCcZnC
         PFNB9Uw94cnyZikB/J3/g9oBHw5XVipTFNM89HAukXxZE1YRVNllRLBL/xTJZLJfYhdG
         lNxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W6V0MzzonTsj3SY2V0AuVyvuQ6Xxvu4Y/qBnCAG3I38=;
        fh=4tAhOyg+QgcfsYZtuarfoKlePn0M4IW5B0cI0S/jj9Q=;
        b=LRv5toFHzhqDNywKW9ZmvqCKaa0TKxOn09lu5BuFqg/sB3Rf++KGs614LfUdu+iZHS
         gOg8E5jLUbPg7R+tcEYVoALQICVIFivWvRMIVgSTT20UzGaUY2d5jONyxYmL8VhW0OBz
         T2pYAImsBo/qclYK+UjWXYgu9XGJQsVQ65R77Wtymhf3vUdwcpG9jDeRPDGKGcPUcrS3
         t7wuCmGu2nHjsSO+LPJdq2lXB/AYwuxsxWO8qhJfKSDQCcBtePWOiQRri/UXD0IEVlpS
         sJ5z2eUYYHbzVC/neGMnmbM7SUBscY1SlMLe/TtGdb+Mny29sOwvaLfYh8qnhLDFOW/C
         uRcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768939013; x=1769543813; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6V0MzzonTsj3SY2V0AuVyvuQ6Xxvu4Y/qBnCAG3I38=;
        b=YjpIfUyQt7GQ0UAWMvorjurzoyhCxrfBt9NU2P4bm/tY2lV+XHQL1SUIHvIaeVXHkp
         Bif8/5Ut6b1V2oXqa4hV0g8xGAHcP/g3pMqUK7/Y9HGqnxx+rm+7lnxSfau6FCjdunvT
         61I61a1RNXnO0x7M3nHL01SpiZDnepO6gaWctqNozrrzcIgaCIYyzjvvgo7jEF1EWi6f
         HzxloUAMlbU9oKq2qw01A/sGRpXkLg8ysYpzuDUl/961YF8JXqzQTCUoRK21QGbYl5Ly
         OLAnPPg/So0YBjTxVix0NaUxFEZCG5pgITtKdjW2+4EK3nm9FZ+FZyBgQ6nqd5F1JvXb
         BMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768939013; x=1769543813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W6V0MzzonTsj3SY2V0AuVyvuQ6Xxvu4Y/qBnCAG3I38=;
        b=S5t9GlIcbpXyM2c7c6AXjgrsQFOvunFepT/Hv26ulsB+T84InoripCdkQllEF/ZkaG
         3tyrfvgww+fIFuTLddhUWPLpRqgZzvKfAG+v/dZ9QJK/LJbpToq4icUUlXwoVUcwREK9
         8+OFdUMNVDTWuAwWXlp52Qi6Vx0jwpWgHHk/bU0yuYy4Y1Q9ZZb3hVnwPUHOi7sWtl01
         RAn7Akwul4T97EIrGi32oK4jlKcO1BBHGlkhYkCIOUwV/QrmQTTrn+WGWdRr918XMYU0
         BoTTfCW221M9YyNXK7vP26WaS33TRMtcQ3QZwsMd8wpB0c768aEFQbQ4/qS/4A929rDo
         1lKg==
X-Forwarded-Encrypted: i=1; AJvYcCU7ew6KFldY3y9FX3UbEcysAAVvZStnJP6j1SLzYWDAzzcc9TL4s2Lb9VJs10jIxe0E5riuV3KHww==@kvack.org
X-Gm-Message-State: AOJu0YyMO7/NV21Y4apkCkU/LJb+Ar2GNrYH27BRNdmQS1PZ4hR7ahMX
	F/O+KV4DykHhazG6o9BwSPUxx+ANS80UtMjZtRhhi+ighW0BG1cVxXpSHWjqrtyeR8IjmcWKaYO
	gVoc6PyDCUaW8CwkPyb2KTsmLQO7Ef6g=
X-Gm-Gg: AZuq6aKNo83/XqGokvpo34DdztibTl7YrqUkQPTskGrSawylOxkXKg0f5eO0a2jqWEx
	7PMiKYLIyr+ltbTutG5xJwxuVBs+Pe1DpPPFLslx6XKSlEA56umINoscImeagsPSN3grKAloEq7
	qHi6DkO5L4vDu8vlzjWxvrcn9mMvz+M+sYDqHH0EeMQu2tTBH8mKOnqpjhwUuNiMRGM0DpsTuTv
	cri6ryrRHEdjYYst6dV8npEQkwVKVHdgYsm8p1XXM0Vd5HNMIjNth2rsFUgJZAlXvAF4jQ=
X-Received: by 2002:a05:6000:2912:b0:430:f454:84ae with SMTP id
 ffacd0b85a97d-4358ff6facfmr4656211f8f.63.1768939012951; Tue, 20 Jan 2026
 11:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20260117025406.799428-1-senozhatsky@chromium.org>
In-Reply-To: <20260117025406.799428-1-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 20 Jan 2026 11:56:41 -0800
X-Gm-Features: AZwV_QijmhvOjpYw2seYqtQZ2Lsp1lrYo6pizQH5md_5eMLBevC-IDWt5651bz0
Message-ID: <CAKEwX=PrYbegbCF6Y4OhQHZBsru_rPLf-YtUO1jHpYh_hL8qkA@mail.gmail.com>
Subject: Re: [PATCHv2] zsmalloc: make common caches global
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ny5a11bk8gcikn4xd59ifka88nqugkro
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F059280006
X-Rspam-User: 
X-HE-Tag: 1768939014-596132
X-HE-Meta: U2FsdGVkX18JZv1rxiHlmeir7rg96idOmVpdTBzhKpP+Hv56jU/aKqAo9bV9fJVFM/UWSKuEl6m1fqvFlU296j5t9NGO8B6Um5db8HmJXS0bwG3YoeZwsIfJtKg6+iyvHVaKh50orIuh9PvyqP0ky6ydQPURPlBv6A9PaIs2epvaFswVGg21F0VcNPbSQQYtNljL0o2v9vvu6trOSbT4iKblu2CXi0WrxPT32lQj49phafQX/QRknlvAR8l5m7e4d3tMgjGlyARA8ZpMSqKYxOJm+Mowir6We3wLHlpq/+t6QOvc+GuCaksqitjJnjJSmQ+Ze2KORXueXI+XR1eKtajWX36mW+RZPtCU4xQFLd7dhg0bZ+zTNysMvFz1aci3jNWaJNfjTOY8BMmQz755CtTbxPr3ASJkaurNL+QaCdULo9ohK0WRVtDjtJNM/Ndw/KuBfu4UjnKb8dT4eowmS5W4sVypPLCHhg06fhXwgLeCNeqoxzIrr//8slYwte+l9ESuPwwtVnTLm5iSoapViw0BoxANli1z8NihxehnFD/sKfYf0pGkFrpACEqjsuZrdKVZUAg5kYSg1wOcr03fwM3jPqSMTkLYKjxldh1bHmLpoAw4OVF51Oqy5glhp3tVlJzQ1QRZhSwkXgqhGGLjGVhx9Jykx7mkF9gqFgk4Cy13yEzc1e5CzPb/g/E67FDJlYMCSDsIlvBi2HVjIEePc7auZV46rdmiX/0YaKzBMnP1IGRXe9FJrAB3W07YLQ0eNyKyjusVONCDfgpL+hjjHYiDcXsIjRD3SUEfjxcAPU2f2MgERX6/4RqPgOe8vPH3d9N6y/HFnFONWU6i8g9UdWeymA6PbUQvR4CgTCRtStMh5JdY8+2ffKiNO5giccHY5a6hC3BGsOO5agjyZicm5hdMERPXsjSfWlu1We/aBOhjz1sTqoWRCw1iRp1AYiR6YYPO5rA7UqpJLJQ0tAD
 JN90u0qA
 He3FA/q8r7BDgTLf+VAD5mT2dYPhanng0fxz85Ofz0vkc04UHmlEoHnXV6E980PZpDGT0btYHVKNfgEi5byiG9kd/wsvTQj8xgycnon03Wlb6UvJsS7j2Qb0LIanoeP/9808XBWcUm+u5tfUBDZ3KHXy2wN/edH7zI5kUlCeLUtmK3BdsGdruZBUgh/E8aXI0JlN2owU45VvFFYpg82q9FNl4RpMcZoYttiKQbxuMbn2X0Xqyzf3F75liMhQFBfsuakVVZyo8Cjiwp/EPCnrdIErp6nKJdgmXZk25c6RBZP9e60djd8uEsjvtZHQfahxjyEvaGADg+pQEr9p9E4oizdQwqFReg4YNfB/OK+FEwa1g50My4+nP3yQuQre+bC/Y0bUtbKrtNNdqQZO5GP2AhRSSBkpYkQdPnhMDUsjHXtd5xyeo6h7IhtEfnLmEqop37izhk0/FMu3bSrwdTEDb6iUS6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 6:54=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Currently, zsmalloc creates kmem_cache of handles and zspages
> for each pool, which may be suboptimal from the memory usage
> point of view (extra internal fragmentation per pool).  Systems
> that create multiple zsmalloc pools may benefit from shared
> common zsmalloc caches.
>
> Make handles and zspages kmem caches global.  The memory
> savings depend on particular setup and data patterns and
> can be found via slabinfo.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

LGTM!

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

