Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779E0C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B96A6B0679; Fri, 14 Aug 2026 06:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890526B067B; Fri, 14 Aug 2026 06:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F886B067C; Fri, 14 Aug 2026 06:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56BB36B0679
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:21:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D48C9120374
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:21:03 +0000 (UTC)
X-FDA: 85099482006.30.EEBEF45
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 03F5C40004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:21:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HHQVfcuM;
	spf=pass (imf07.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786702862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyoHuKQTwId/VXA8STa2sMMaQb4tz0VI6sVRW1TKmeE=;
	b=m4oPHZ7OMMrc3bM3VHSuBIUESM7rDkBDcaFg5+mjLOjKVbtMe8SO68hokrEQDfMwiVauEK
	tDdIt2vGTjaMAi58un6OMYBR1uP80j7Tx11+qxmU2Lc3EKmvKYh4JT63acfKPo8nMuPuIP
	IY9v1Bn1T6tiz9djnQu3Wjbp+xscXtw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HHQVfcuM;
	spf=pass (imf07.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786702862;
	b=WjF1g7U7IPFmBtYe3W1azGhp6nc8ZRKHoiJ9QZDBDnAbeTuEpYDp/sMmIQhmIZU0HPzv+v
	fxmoiJA0WoOTUB5EdbMNAeyTb0GN06CBJRlU9jlyBEgqhbZaojXH1YfI/Wa9+uigeoD+OU
	jGKDqHAMgI0AJgXokqjWUJr8EmPpAHE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caf228a910so7678445ad.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786702861; x=1787307661; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TyoHuKQTwId/VXA8STa2sMMaQb4tz0VI6sVRW1TKmeE=;
        b=HHQVfcuM2kKML8E1SMrmDaVY5CkQZs3jwa2HCPX+KHdzB7Xz786+j1fCOk4HihOlI9
         AoHzqL92sao7juN7BKQJuDAclj8i8mz2S8WgRyiXd6GglW3PO6JkN96u1s/mDNF3Cfj+
         Ro1pFj4ocSAb5Ww07+HATGiwdSnO3l8LxYNRD3vI8EgcAXfuXqLZjL65CoBnLJ46Bj05
         ndEQ6uzFZ9qVPX8j5bUu1v9uBppr0Py3+f0fTEakz5fUofd+j48BVPqWtdm7bATnxTi+
         nWKFUiMJMb+dGmIcq2cWmYD2VD/Q33D4oS+BA35JF23wB1cGaEP1jbpVP52RxCyAgDnC
         1Qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786702861; x=1787307661;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TyoHuKQTwId/VXA8STa2sMMaQb4tz0VI6sVRW1TKmeE=;
        b=IzIDrFvmbvORAmDcEJpwrWa+vqKc3m1guQ9wZ3Se3ly32afToXZwsBA94yTntNqtic
         GQuarV8w5WmLo7MRRz9DYghWAD01UiAxed2MqgDLO6iyOpU3knHKKz5UwhbOlFOxQiho
         OConG/8dVxmGdoG/HGI7Y9+7WVESt+olnCjl+e5/ATDEhr8ooFmha8VECJgsV2PMb24q
         N5PU8MGH94NhANr/htZbzVtMqaMEGlauaUfyY/Yn9+Oh8gDMu3pWahXTl7gRMuWWiFSA
         whK20cKSYf/jVNKus2LviWqsfHZIk5mElV6ptOINKWNg2imoPOftEJUfCKAV9u4PHr4S
         3Z4g==
X-Forwarded-Encrypted: i=1; AHgh+Rq8gidR4yUFahHQObtr36BGQJgW/fK7BrCkogDSUu/7AsMZcMjUgIt0n9VMth/DoNM9A7SIdeC9wQ==@kvack.org
X-Gm-Message-State: AOJu0YyaaorI4Fco2Z3aAyLVfRo3HZlbbZ3nuwurw5T5vp8CyDH66EP2
	UrCTnTPNMcyBG/EkPKz3czjlOWPMP7M7jreJjuxVHQNmL7gGsCFkUuauKYKlwF8A
X-Gm-Gg: AR+sD10hBFTMjg29A4eO/lzK/d0GvlFLKeWZLTRX5SICgxAQqg3lucBZhJnZaM6269f
	rNiNWWp9QZ99hcNyF+/DFU18b7tt88IugN5Xt6l9LJbIt0Z7ayeutYDNQmF67k4PxXjfEQu+iX3
	q4hMolMAu6+K6tOG5BEKRkdPfWsBRLNbgcBWaPPCi2TasVEYM+eb0F2znNx6HetoT5/U2pzuYUn
	CXPNII8EROvsY/s2b+32XnbyOzV31h5wqd5D1Kwl+1lkVNuEIz1Kn0ihTvMbx4pMczoIvdiJrlL
	zaNEorus1RfBYnomY0g8rwIPAupM0RnSFZr0OsQzdSIk1BqcK3zWyuJ5x1R23D3iad4vwUmPite
	qLw0BUqqFPWP56Na/68VOGzOuRMGB5ZeXEEuiwHltSHLKgn0Vx+SakyLaI0UxGs6r4aNWVEndkw
	KfrjQCrF6d0LRkgZqwZHNDHqPsy2Y9VWv8y6hGswJ/CAOfsLja3xAMe2cmqLvkdbZGQIJlgw==
X-Received: by 2002:a17:902:c402:b0:2cc:e620:e307 with SMTP id d9443c01a7336-2d3b0ce9623mr46757575ad.20.1786702860611;
        Fri, 14 Aug 2026 03:21:00 -0700 (PDT)
Received: from localhost ([2400:adc1:447:6d00:6351:4475:eeb9:18f1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320d5ff42b7sm3348400eec.7.2026.08.14.03.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 03:21:00 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 15:20:47 +0500
Message-Id: <DKOLAT327XRI.X9Q4O449VPL6@gmail.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Mike Rapoport" <rppt@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
From: "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>
To: "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>, "Kees Cook"
 <kees@kernel.org>
X-Mailer: aerc 0.22.0
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
In-Reply-To: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
X-Stat-Signature: 9zxtcte8o4dg48z3ec8q7zrksuk16eth
X-Rspamd-Queue-Id: 03F5C40004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786702861-168858
X-HE-Meta: U2FsdGVkX19wMJ9pwOhNE3QgkJBxCaWoOZSGjhYz6So952JykKps8QAgOYXNf4dnNLnR+t4407Jz05XHemdKwhKUw9nX0jC/sKZ9TjA83LMNh4o2ra2owxi4Wr9mI4zRZ5aGkzECFo4bjZtgKfT+Rp72r7Vx0lccDlvOaUUHM9Mz8kmPZraAMATqe0mhsyfWYAbxgdGiRgJwbVoR6GfwJUTUxf3IiJFIvnSxlsbo9nUTPg40lSLTrpMr6JoDkHVgJ6xpMMWO5F+ItZKIDtDEsQsvt0I5d9u4Ts3HjzjJZgt+eOvrZ+dCKeL8PP0XDIO5Ia+n32mcRA7N0Xrs6rHNEfDDM9pbHwds/RWu5D18nbREH4ffuMGJCOBnOb53/8zm6lA9ZUgWKdJClBMdd3jjrL+pQtQq2ee+HzRXiTwS8sqq925ek+s7QwgCk0Ze0EtGvqVq/6mwjt2U9Gbug53JzgAD3WSvJiagCV320O0pNFHv2rNi14dmLyG8wykhHhcuykWinOLnCXCudziJobgqGldfaaij94CJWgppRDR2hRpGSoGqyuCQIWnQdjp34TbMcbdCsjg0ldwR8euLvGunxUHkRCAEoXWRcjnNtDHSnZCPhectPUXbPPEQk47ctCej/qkRl3/D6iph36VORCqOKvi/kIqKjryJcQjrqrdl5S0E2V59FgRk2XeWNIUQQYi/UKp3rsXt2x8pSlu33/KGOqLjxzQXPhfMSJMTqfqHSLhr0TsNzcMfY0fR6XEFeJcZ2Vh+3zMKQBs5sI53on2GsfJhzktB3oENVD5bTvyfNZQNLZGPSGnLNYnROI2YnV/8DsHI/y6ugihKF4tEFKR6gIpfjMsfEayV/X1X5ziJWjEoucz4kETekM2zqOhHWKJRxXpcqcEMigg7FcJurQk8IT1Fe2PI7InI5IJVfA7ploDqZlp1GuswRi7d0S/9D1hF6ufkoqoV+iPJqA4v49A
 qtz9s166
 YstAAw2KkXqkzpF2V0nhIQL/h+MbeY5viT+tvNy8Ogx3PhIAnMoxmEAF5Bt3FsqEUko0FbpS4HRM1n07MxP2LwvFuh8fPOTYm6I3yDHsv32hN15ymOQVmKFJgzvwp61AZ77MzRpM6ChLeHz6TmYfTmea+8EOjYzEvFZ9nicyIQiMur7w6/qPlwyL8MLLQUg2GsmVWkH9oqO8/p1vzdksZedDeMFocSE7O1blOclfGtisnAdBGubXH0hait3CQwoc+61c74dVLlR4c/osFzJhgu6NykdpLw6zXE8sdWlrSe7O+bbTujrM6eEJT3snWl22FaeccS17rhuadmV6qvSRjNSYfcTh8XeG1qF7NSVAtf6yI1uIDuvTYpasSX0L6JXxvT4mWm+XWthPDITtYvoip3ac7NRfByLHvRFRes8TIOqQaUmWCUPE6CWpDQIPwZk1yEwCAP5tBH2GwW7Kotafm7kM3i7XYb+G1Kp6nJCGLBfLON8nb4rjn1ftmW8OjCoxLdfoF2Nm0bMrRKgnUQGwna5WIMpa5LKEEXaLrdKFfJK9fSBGZrmbIjB4BlqB2vV8cKhm6QvxRB7u0l0hheho0NSKLpon7nA+1gz49Hk+wMEwR9z2VcmC1vXFFjQvCXsGAVafe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping.

Mike Rapoport acked this on-list and said he'd prefer that it goes via
your tree. No outstanding review comments.

Boot-tested on 7.2.0-rc4+. Read and write paths tested, clean dmesg.

Thank you,
Mahad Ibrahim

