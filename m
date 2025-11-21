Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E3EBCFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870D26B0027; Fri, 21 Nov 2025 02:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8219D6B002B; Fri, 21 Nov 2025 02:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7370A6B002C; Fri, 21 Nov 2025 02:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6313A6B0027
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:05:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C1C85908A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:05:20 +0000 (UTC)
X-FDA: 84133728000.09.90A0AA5
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf14.hostedemail.com (Postfix) with ESMTP id 653A710000C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:05:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=iuZ5EChK;
	spf=pass (imf14.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763708718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TysMVlAgZHEtXel8Jzt/aImsWIJRorMNwBr5l76BKF4=;
	b=cRQa1S59nt4K/eQGJiWxLzEBXR/gDyPw4ADe5zItbkOv9e0LjAF4/c/zc1P6iucmSwlwqe
	4c0FO3ihAFFboE2OJYVJRR+xvCtE8L3UpA114WJMQxe7Edk6itrhZ3SRrQc1EM1XYuAJ4b
	ix+5sUf6UyFEiExUNsROdHlOo5Lm1MQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=iuZ5EChK;
	spf=pass (imf14.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763708718; a=rsa-sha256;
	cv=none;
	b=E5DtLafKxg38EVwH8ZUbY39WSvrFqD8Tpio5jZVQysua/GwTcfzwxc8DmX4DKHGt/KYvo/
	yI6Upu+keIKQX2z0uGNcBJ6UnB5GPWTpHwu1uJ3dMvIq8zAyTerbR+IXJH+hc5IaGlVgWF
	cWG+yaVWnFoi3X1KuSLb/w3yOLhrO10=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763708710;
	bh=TysMVlAgZHEtXel8Jzt/aImsWIJRorMNwBr5l76BKF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuZ5EChKC6jkK2ZgKAj/po40+MehtuavJznVvf+hIzCg/x6d2ZCcsvOta1FfvmAsI
	 Vfa2DV6XyCotuOlzqyf8ywSN1YqzmN0792NUl2LyeNVJHIyYlhuv0joETvU5/df3VB
	 YaPlIo5f5MXZrKRD7Um5A+Y3jUD2WqPTejVX+ndg=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 147BFE15; Fri, 21 Nov 2025 15:05:07 +0800
X-QQ-mid: xmsmtpt1763708707t7bqn4l5y
Message-ID: <tencent_F47110578F73D23CE92FD0AE86A27F6ED507@qq.com>
X-QQ-XMAILINFO: No7DFzN00JnRsm/HvCRPm7mM+Z5Zf+A3jcMf6GQa7PngQWsjn1DVc4Zf3OmB75
	 7OyvzJR06jIr8MHHLn3oq/6M3Jl3C8d01YWHfGz7hCToWzPBNb+N34wwXUT199KOqgn5gajPlgXz
	 R3WEO7ARSCcJKjjqIDr7dASUlBJXheJs502RWtOMEka+Cl/f57mM7WosbBDrMUa/AawcHg/b62YD
	 +o6wWFPauYlknIME+pbUwY60tLMeWOnPaB8+S1DzPZQFJze1a5PM2fHBT3f8f9pBjS0m3oCVDidp
	 lT3crhpxpzwliIVuAWD9s2X4uHo4o5aOxQCQDKarwf7cysiDsb1it/yCK+oV6qcNUfpu/jx7W9Sv
	 1IcGqI++sM/adhUcCOS0HayqkhDmb7wC2QRTvNnZnCdyphw+6tUFjMM4A3IOzI9UnXDqwxJf5jGM
	 mvVi/5bI3UTQX7ovlhrAGH9P0DMracp8oJHhJ3HkW4cl7PMSWTH0lrrBlS+iIDonbF6iWVmPjnZi
	 Tj8/jyC61mdPRtBz9ghWbSpt44R7uHdiHMAkiyTKXQhBzc0GSJaH2jaGIaR0T7gFubEhKg9Y2y5G
	 hL67ayKpwrWCudbR+v8u2iNV7JjiXYo8OF+Orj06MGWl4cwhIZod+k2cIlU1RGp8f7heGs3Vx0Ne
	 A65aUJiquElqEoxFKnYPFLn7vfq4fyl0vcMgXegD7DT466F3vpau2oUxxqwubDSe83pIBdsJBxgM
	 jET7VJArqe3THlxV+0iksnNTNd7uzpbHMfpA4ufeShVQGfoyV5ZJETn5qknlYqBdGUTWJhWNXhxr
	 14o5jxV1pCcBRaBLU7U2roObPWkZxkHA7jljWIc9cq9GAolzMsCn++STrT/enbtncnFdPeKVllWJ
	 iTGHb9pBmoIRkcBS0HrTYMR9OwZtTH8ATuuAOYXSs115S008KyrDOf3XQI2HIcuVQTVHVPAsvneW
	 vnz++Uc6hyf267I1w6lYZ0kQ+VJSo3gslpQj3ruuwFsERHHUvH8y8s+YEy9ZxTtc5Upc6HMSP09z
	 zMQzx/1qDpbygL6sHp89lnZqlfZgNB22lvlatxLA==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: [RFC PATCHv5 1/6] zram: introduce writeback bio batching
Date: Fri, 21 Nov 2025 15:05:07 +0800
X-OQ-MSGID: <20251121070507.2999428-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120152126.3126298-2-senozhatsky@chromium.org>
References: <20251120152126.3126298-2-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 653A710000C
X-Stat-Signature: cs44uxrhikf3b9ku5trzs8h8h5nqofgz
X-Rspam-User: 
X-HE-Tag: 1763708714-443111
X-HE-Meta: U2FsdGVkX1+FjMjgu3HQUA5k4ddXPTjQuuWmp5mX/EMhXbVqvQAu6CFj7JqLXuWs4uuT2L12xYhKEl+uD4HbBQrlhILxCpIDiy/QiS40j1NV+lyhq/wEIBtBKgrSBuS6OrvpmOeGHctZqP0mQYlZtv3TMVwlQ3Y1iQYGgS2q0Izbi4Kox++UbtcusDW82bL6SO04bVTg6ACTdhOFzVQAnNuPY4ST+oXwwcT7f1ku0Uv5at78QhrZG4TnPAkQglOz+HaAxhlu1weEcXqhe4L57wndyyVF1ju/clEs3a0A/mugjacnZ7PZ/kP+xpkUugnrElWvsZ4l1Lhds9AvwhpXoTWf84nt6G0zaZAwgY4bDSTesDUjkhLj41aKi+xyUTA7MqS0rJjCx1MNnNCmoQ2wgmw0ZQBELzpBIGjWXAp3LdtTTZRGIG7StGzdz9ZtyJUiLCqnwMT1KkTyXabkQCNAHNNlnOXqI72OCDgSp2RB+I+Ksx8x29LJAobFVZ0psxUOOR+fZ8RgKKkI7WHOp/YQaLbFfaExEaDXzXp7ZOdOBJ8sHWXXqnf/s/fx/d5umZQzy0KI+qQOgwX2C6jlPvY/bwVgAp2BhqJbWaZAMJ3OxdMHc/dTKCuhAtWlmCUuJZcDDDMhf/UHnN/f4EZXPV/ooG01MBuSRoi0+L9af9Gc6m+iJBIn5hwTKNT7NHziqQT0/PDUWSbchg5ZIsopCqCBXRcQ++fmRCGAF6vEUCW6oyW7TXUmKD8/vof7gt0JgdzGxV1k6sV6GdO8kSEp7N+a8GEfmqxZE/2Fh4jN/EoWemThcFUPCiYHTg2PzZYhKl1RMI0r0kXLEwOoW52IAWtmZFfBJLcooV8wLk25RXdx6ikf8e3B3Isbaf4FIvp1hAc+jzw+D7MTqrJvgMTYwdz94c1cSscKjhqdkYS2yU5p27N0Lj8SR1DqVAN8n3SEfmQuOScbx9Y6im4j8Wzu7Q9
 y+iBfKLO
 +VLeMFyZn+8HLWtT6uXxuamV8Kf8nFj1JEPOiDHcNFnxtUxwANU9gDUPLaPss3o1lv1/nWhTqfvQKo9vhybo6pSiy80Ygox+1/J5D0JuH8tIW4Gp6OetXlY2v7EH4rziaDsbByZe1Dgpd2j/BN/S9ucfa6bAkR2iRH0N9A99hwGXEvn1Yi2W4RD8+JcAt3P6IX8UDeavyRcU4S/c8XeRryHbG2tzlJhV3+4T7g3zf77NyyEYz1T/tkAxt9mTgGaVDyGHJ0gNAmEi81a5k+I7RCwfHKxLHw+w2B02QYhQQwsSUoM3WIPZ5XvL34rji3g77snE8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 00:21:21 +0900, Sergey Senozhatsky wrote:
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Co-developed-by: Yuwen Chen <ywen.chen@foxmail.com>
> Co-developed-by: Richard Chang <richardycc@google.com>
> Suggested-by: Minchan Kim <minchan@google.com>

I rarely participate in community discussions and I'm not familiar
with the processes here! I hope the community can be more friendly
to new members. Indeed, you wrote that patch all by yourself.


