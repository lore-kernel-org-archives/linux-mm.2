Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D88F46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF256B0005; Mon, 23 Mar 2026 10:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0536B0088; Mon, 23 Mar 2026 10:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6076B0089; Mon, 23 Mar 2026 10:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD0B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:20:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17F8B13C11D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:20:04 +0000 (UTC)
X-FDA: 84577537128.29.D110BE4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39E30C0014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:20:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R+lTLEr6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774275602; a=rsa-sha256;
	cv=none;
	b=DufvfA44ob6tWXaJ0yxDbELcf/0c6PF0i4B1O7I+yIO/7u3Y3Ea2rubBUoYtwAf2yxAh6c
	iqY7+c9LtTw9c2RK7LM1LJ82iS21i7E1KHmRGVPrKFkm1WlIZhkYN+bp+YYv0EHz7xOx6m
	Bmvc2F2vdWRb3qsWTvqJWvuXaeovj8E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R+lTLEr6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7v0kKo5kx/NTKypqvvw5WZo/TwKAYeoO2unauSZDIU=;
	b=pQk/XxIeiTdMlWIs7L4njH+qEmuRGixw5GOMGlNge5RB72A4xb+BucA2SDuEgTq+8jP1p1
	xLNe++fuAuc0dqqghO77Sdf/eHqVIL5ATZtdbowHzheMQq872PZlglP9mghG/5hWBzH48h
	YjiRT3YGB1pcKpqPx9OhNz/0WoAEFYs=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b042533de1so22072485ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774275601; x=1774880401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7v0kKo5kx/NTKypqvvw5WZo/TwKAYeoO2unauSZDIU=;
        b=R+lTLEr6yWfjBk9NawVuMeiYT1Xb/4/sEdLy7Bs23+F+nwob8Czu0XXHOr3zmgTocs
         N/+pvN8kHL0dNO95NPqg9kqyuB0uom3aa2l63gNB9esol39B/oUo18CJdknuywce2SNq
         uNu8GnZBufMtrVTYttVd3226w1UuYeJXmDQj3nyeMfRLr57u2DKata9hg5j2zwmuG13s
         ml9HMSxjd2eabLBTpWSQ0l0MSTBXD7K8Mzo3kAx3ZC87HFdluKHQDacKbL+XtLjyhYJk
         w7nXeygq5WPeja+0ZE9TL/I7HHhdAPoe4A1X6CkOemr9Da+WuewAvFraFdOjFxAx9kdd
         64Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774275601; x=1774880401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K7v0kKo5kx/NTKypqvvw5WZo/TwKAYeoO2unauSZDIU=;
        b=rN2/3AzFzqP/iRy83M6UiXhFlIHVcd9P98baCIySXyEWKguf7IK6bCbGrjP9GmdNzA
         Q6quUOZfVLMnUrOyp4uKQk4p79uTNGUcAU/O9aICUUIbzygNzJt9Cfs0oY5m9S+r0cYB
         UlbhurauNs33Veu1DUZBmHczcP3kF7G9K2DDoeIPCJ4jo7qzr8Sz79mOpcrJxoCZr+kU
         Di2ykWY9oQQ7TjedoOamfUTshPPzfk5oL7d9UcGpX9yHQqP3M7c2DYs4DiQ5to8HxeOd
         lBXWrrsmwK6hXcK9i1W9fNmRqwKXDkEYRewrZoLab43y7ll3TCtHNJjR7RKf4Owy5qPX
         t1iw==
X-Forwarded-Encrypted: i=1; AJvYcCWdWYCHZGSuKucdHpziaZ+pvcDZT0VAidWtKjhqbaF3qw+6crw8BepIFkzX00Y5u5XMNu+tRpTg1g==@kvack.org
X-Gm-Message-State: AOJu0YwQdYOLpRq47AonJg5Fvf/ZC8a00IaTbUvZaofEeZfP1zR1NMCn
	x32BNQmqRwnrrRNNoSNqQv4kxA4MAjoPv4FGflHbI/d0BD0Cnx1rq4+h
X-Gm-Gg: ATEYQzxnXjKgx0G6/T88YgPChI2YzDZI6TWlDC9cDB3ZDZuYhuaQ43F7fNqyeBiojga
	jqfheLgC2jQs0Bau99NZwHa3aOQrPkiocNoakkQN/fPy//M92ssQy4r/+tkDZsquk7cra1RxWdu
	oxO0xoVXXU37yqkpLLqk3Z0JupHWeqBcxFOrqFZuR5d1uwxtWwtWyJovaE+xkLWmEXw2P2dhHNI
	AVLor0oLIqfbGl0CTGjXQJVi9yPE6aYySlrlsWyPUFaeluPZRb+2GJ/H14ZWwzcg+tn6QWLmgYI
	6i9hu/d4IZ3n3nDZWKjkBJq+Wu2rSXrBFeaN7QiAfhn1QseMmL2BNJAAMjR8GYAoFQfN65ObmZ1
	hkOo+Bj5eV7rVFEozbbj+p0P5OX65cvwaUF4SCS/a7N0sAZwipvQjju+tajbQUGHWSOC4QCgfxK
	533m351QonvS7OAQaJzmgHlB3Syng=
X-Received: by 2002:a17:903:240e:b0:2b0:60b2:4dc with SMTP id d9443c01a7336-2b082750c20mr127256235ad.15.1774275600873;
        Mon, 23 Mar 2026 07:20:00 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836747dcsm107209275ad.64.2026.03.23.07.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 07:20:00 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	aethernet65535@gmail.com
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 22:19:55 +0800
Message-ID: <20260323141955.20535-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323072724.15942-1-aethernet65535@gmail.com>
References: <20260323072724.15942-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bgjdr3gx4h631tdri53dyzd6r8xpitsq
X-Rspamd-Queue-Id: 39E30C0014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774275602-840386
X-HE-Meta: U2FsdGVkX1+YGJV4WLd1DeyjUxBf/LDsBlPQ05kw//i9qKr1xk5FH5YNzkcREIC+eHZqZ7ugXhzIzhnaIlT8TKwjQKAsMfmiY1sHiZebdIa45O+vTSPmTNbwtYjJln2fa45S+LniiS1b9w654wzMoTWs90D5AnVMPgllSE0KqCwGq2Kdukbovp+T4I35DO6yTlkcl/ksq//KnBjpVWuSsRE8nBYbLO27LNFgNDsm7lrHZN/i8E6woeeexYrg4fMhYJrL1Wj2Dn3aRqEPNBRON9Jpl8wtpCGcys9s6tcM/2U/JyK5LrO9G0tikjrxH4QHUQBsxjBta+JbKSKbfwK3iQ8+/5LAPbnGs0oO88InlG4BqXQwLBhyQGA+DAKl8Qkj/NXV+TgfPTBu54pJZjv3kYQl5CrDDyrTEEnqNf5MulBATQJS82AO9k9lGYyoWtQA4nrc+wE457AdDHr9XU3ARbse+K4fhO2WjaOtXvmzlp7iM36Z6DNN2H/78/AYPaNudtRdVey9f+xD35BGAFR6N1mODL5o0WmP5nnUeLLu8nKMDSc8Zppvalm1Kbld4EBoRviZvywVpB/B0/XdAMHQeF7wkdPTFmzAH8GsiMksiJirGpvktpSk5nHOHQefkiOE7M8aey1dO591A7O7xtWgWwWtzKOsGxP26F/lsoSMhMQUDQPjPTy/IouMLQ1y6FDalsFgmzN38JDkEhc7OeTTpsrXpcJ3/RJ93k+6XbtJOyTtUoLYHV5mUAHFaljuJGTxXRdWmXxK1jvS6VjhX76P4fupGl4IDPZyx5Z8zqftZAISVMNzO3j2MlPlO2dldf+F+MqJSyqFHOe1co2d5Zz8hSvZ5ykqIprUXO/ARAIorPFuVNjNk4o9iCdQv403BrnMymQAEMJ69ccNHGOuq/19Nf9g0fVExmON8drEwU/eQUCZ9ovxgdXRW0uPZn5whuraW/m+Rkr/tUekj+I1soS
 5lUP/QhC
 7IYl87Ut9wqu7sDWd2VyH3ne685MDcAeseRlpN+7ipmGEH0hkRsMRll2ntFUS9LnRwrYPl2eV/PbSZHvMJpvDRMNxZSQrAeMMEUOyM2jEIJQNQHrbzAuRabnCqQOSXEHCwkNIqi3qxnxsOXZZB+oJhEF4EKP7fPrS3reizr8Herh/CqP4VL9CViGNxyOhGHuFfUIzMyHY9UwIhZ0uVkWu0gAJDlznGz/Y+npU2r09DJwg1CtI8hFgECMukBzuO4qnIvwdafHNT9YhdcAjCQJeTE/hisaM2CBut0Gf4pnNA+AY9mpPZf1lwrbsRcT7Uo4gs9kJp4ezjHYSAbY97+395d75q8zRQqWK+Gy1yPiuQdpF1+UO0jjfO5PEjoEZi4vpioZF8LYrB3Mebl0nCEYdMDlmZNpyaL8ARzgqqjCjr5/dPgHhtj/1qxTaGAxXGrNBl8gU9IeKKKukgRA6zl70duAHrXPBMvQc2rhW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Follow-up on my previous email regarding the locking concerns.

> I admit I don't have an elegant solution yet. Here are my current
> thought:
> 
> Add a timeout to wait_for_completion() (e.g.,
> wait_for_completion_timeout()), using 'damos_watermarks.interval' as the
> upper bound. This prevents indefinite blocking of 'param_lock', though
> it still holds the global lock for up to several seconds.

After further analysis, I realized that since both 'commit_inputs' and
'enabled' module parameters are protected by the global 'param_lock',
stopping kdamond gracefully (via enabled=N) is serialized with
'commit_inputs' writes. Therefore, a classic deadlock scenario should
not occur in normal operation.

However, I'm considering edge cases where kdamond might terminate
unexpectedly. In such cases, commit_inputs_store() could hold
'param_lock' indefinitely, blocking other module parameter updates
system-wide.

To mitigate this risk defensively, would you accept adding a timeout to
wait_for_completion()? This ensures 'param_lock' is eventually released
even if kdamond fails unexpectedly.

Please let me know your preference. :>

Best regards,
Rui Yan

