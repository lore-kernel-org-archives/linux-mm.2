Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6611FCA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 04:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2016B0088; Tue, 13 Oct 2026 00:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782F36B008A; Tue, 13 Oct 2026 00:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670B26B008C; Tue, 13 Oct 2026 00:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4551A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:03:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA44E160AA2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:03:01 +0000 (UTC)
X-FDA: 85316257362.16.D6CEAE5
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 08A8540007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:02:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dViaKtlj;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791864180;
	b=jbwlUffeAlIwxs/wc7f4WjhfwhUEoiTxSanJoDVl0XbabJ+PIfRDe8qQSf/vCirtexDP7L
	7ze74WKFdx+DKF4vXaS+LhibotIq2ePX8M4vMKP4DYzuq7MS9OFevQvWnz7yc7JHNDPs53
	8PY6w15CWdCN46r5l6wmN68RLcd9IgQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dViaKtlj;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791864180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wJ4fczHpBB7QAqi3kAlwydilUU5q2AAkVxgHET/ArQ=;
	b=QPL6ULg0Qf605QPpe8ApFLCbDyf+iUy2A43N6kKsfSzueZ5wQyzJBaxHiWbcUC0I6E6wUJ
	rwGh2xj0z6xC4mNld6fT0JVBNjZckSdCeW83Ukmjqvwia5IEYudfxGkydFQoOzZd2DM8qB
	wH8iSXzOmzw/dzpV3B2WkI4jBlcmszs=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc4e9e56e9aso743650a12.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791864179; x=1792468979; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9wJ4fczHpBB7QAqi3kAlwydilUU5q2AAkVxgHET/ArQ=;
        b=dViaKtljEQhgytzx1ZSnj/OSqjV0NY6siQB1WIF+HGFcAF8I+zWhrnWAI9Lb4bYkck
         0Z8xUNkcHdxB/v+akxBkg4bdjxQ3pIJfixuzKzK7NCEIf+GqiAD5S8+ZPdcMD0bzRiRr
         JtuEFCBWzk7Z7NUsrSeOuiiQnpwmKYkaQSJto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791864179; x=1792468979;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9wJ4fczHpBB7QAqi3kAlwydilUU5q2AAkVxgHET/ArQ=;
        b=Z6C6aEH8QCJkkf/L7qBkr5bI/wHmzYs7jIuSHlSb+tU7BrN1MarSjn6MI5AEIKLlvl
         d/ywsYv4spLKcujQWm3P3MEQ3/siOschugcswHdhU4JGj4ovk0zcy3eVvzA6G9Wg4yzw
         10ShT3TMIKd72IOjcFMK81w4Z17ND4VyyeszSs8n1qmKcI5fknFSLoRk2TAh+uDplHL3
         CBpYayPGGN9j1lTc3oDwhwI3F2yarhhNZi8UCXJdygdwWCdWS/ouknYFOaByDNql1EmA
         wD/b1mRMAKiy5a3p8cE++GlPSG+czPPXbmpbHYiMFMaEYGLsq1NvJBI5bCNQheRC+Ie2
         ie1g==
X-Forwarded-Encrypted: i=1; AKwUvBxMSc2kHFMpZHfg2WQPJ1cco0Fk08NIsC4lNyXp4kUxYXAHBS2Qh57XgTnHVXhXgzLb3z7qf5ZNBA==@kvack.org
X-Gm-Message-State: AFq9FYLFRtE13niXPaQvS9Z0OJeJh8RFvsFASP1YRr1DRHzuTjLsZKsV
	vctvVFX6Nm56JlvvK1c0z0kYuQWYSHFTC3Hck+DLeRJwMso/1Dbh8xu4OKMfACj49A==
X-Gm-Gg: AYBFou31ELJdSaouaJViEvN8jnEwyfHDd8Gp2WIkIL54TRrp9SiMM9ZMs74+bG/5lyn
	38eMeMdrlbu10JPz44HNoVL8ZMVFKMeHMCxY36CFRQbhRgNqjObFe68EdbS2sH5tlLW/v8uKQgS
	hXbxPYO01da649hqH0XErf4oRD+Bkyfy/VQ9wAIVXnqvAC2YbnXsmM7ticAjb1fF6KCcyJaktVl
	BRqpyUlRDuQdVDA2sPpLe4GlSSHGEODsO875ydNMGNjSt77OvP+u5Cvs5/n/NfhCo6VdZAOA5H0
	oQp6nVl8oY0dzicD5Y09nv/2YPhQJIQ5EM/q94YDSPZJhoQXdDValhy0qZPUkNaMzneyFOY6EfG
	u34w1UR7urwJNUgDEWX8teNJFbTKaQap46F4VnLVkw4uPob/pAnbWS4HTl9KpyicjlR2v7jBceO
	ucyMVH+2AIiltQdvW2T3wOXxTTs08nKxZeKTDj3lqE8OaN4FQ0+FPMMrYrj8tjelMEN3sXG/aqa
	PJFCYrp7dA/IYwXVwPVdbQoGnWnWJZ0WrWBrA==
X-Received: by 2002:a17:90b:384c:b0:3a4:e234:111c with SMTP id 98e67ed59e1d1-3ab3a9183bemr9589953a91.66.1791864178821;
        Mon, 12 Oct 2026 21:02:58 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3371f748sm11618699a91.1.2026.10.12.21.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 21:02:56 -0700 (PDT)
Date: Tue, 13 Oct 2026 13:02:52 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: senozhatsky@chromium.org, baohua@kernel.org, akpm@linux-foundation.org, 
	bigeasy@linutronix.de, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, yosry.ahmed@linux.dev, 
	surenb@google.com, suleiman@google.com, zhangdongdong5@xiaomi.com
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <as2s0JflTS1wUUOl@google.com>
References: <anMPLgbrf7XMC7Qw@google.com>
 <20261012123328.1138059-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012123328.1138059-1-zhangbo56@xiaomi.com>
X-Stat-Signature: eyzupgf13de8zuus7xjzj6b6ihhbuz3j
X-Rspamd-Queue-Id: 08A8540007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791864179-925177
X-HE-Meta: U2FsdGVkX1+Wyel0uAaKz9kBxyaar63ZIJTlPP83bCmkVuIH/zW6k+zCrG7ClIHEZT4yOO2vfw0eOJOcS2P63oBKiaryzt74kkG+/KxjIEpUMfkKyy8DNhzeY8XCkKEg1Jud36VdY5VERONOum8GXJgpNkSfnuI83nqDGCjwNIKe05g5ATu4/1Kpjn60GUfYdT9POo4bwdZDEcloFwr/p/rF2AWnCVepOSu4ld2c7BcHdmNehe3sBcafoY0g6H1nBpYAPFqaz4kcYRoT216Mn1QFch1s/pzH2UTPKIVU4KxalNQ7F+nOjSyZoKYVJhdAstNhmZysOWSR1VN+vQ3BVTUSvHt+Qi2+9WnbrdG7Hyzz/Fzk0GkGcNU+80rlfM1dA3nQxG2vjl1PZOdQFnCx9x1s31YSAwCO+TaEgun9LaFidD1Xg6YlPXk2qWIug6yQkJ76tNYEtRAZVkUDgHrQv11GgRiGNfO9ISvGhTKl1p/D5U/PH8pzklnrDckUUgj0aOzxcT8rgsU2Apx3ShPS5qQQ+CwdxDQYaFDg5buafsBZ59Cm9LUq9pRmEw3tosAYX7BIfwrzsfar92mfN/9oOZ+3aqGxPx+Aq0bNK/H79NNv6hMF8vNPW/VNn2lF4/RZTKgr+0QBmCSwUqZ5qjkFhADQuItgRLC+MnKkz1e4EsH8P56KrKge8sde0ym9wVvsXeqRygKCBlwYrxZvcF8Txoq27lYUHT7oBvRcXU+DQ1UwUkDdkGJ0z/EtRQ7Zz4AUZi1IXQMkbaHBpxhZlV667gL4xXtnIKbCbWRhvEdkWNPCeVnVtOY8dv5CgLSorQFFmHragx5y+V+N2KCXVqIuqeNR+pkrTCqYtlnioQfulw3/MXvas7gbN5b2tihVvwR8K9jkH85g1LLNoKq/8vKvUrw+8nId1aPHwFU8J+GrzgSi9K3OuiaITtq3PvDS8WAVYc+/3h4WCQnhjGQ+k3Q
 ODBG3wUq
 4xuYYkvmbGJP2ldFYy+uUO3CUXZhps9QHWk5Q6mM61q+GczHJALBAFmTqhID4pO2S93WoonJbxZ+p7IsJr0+sUN2AYxUVz2M/JE68YIz2aT0Y3FUCMOI+izmamRH/eB81y959dcCDFQvCWilVWt/crzXTszZxs7ueWBfBdHcaBeTW1yDN++TfWAOnpl0K9eKMmMo/Jk9XE4pvmKm9+uNnvOYlFpUt1sxLan06Oby9M/AjsoIRwdFzEt8ZztGwrR+9GUJswawLVVd1cg5Ppymg0GGfmav81GsGm0ryJwoemlzpI1Ph4iumgFKMSpcmzsBG+COGmU9Es79obUnGHb0YDjXWYVubd181/iveIFQ53GLw/aPI4QExJilD0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On (26/10/12 20:33), Bo Zhang wrote:
> On (26/08/05 19:25), Sergey Senozhatsky wrote:
> > quick and dirty patch.  Just curious if this improves anything on your
> > side.
> 
> Hi Sergey, Barry,
> 
> I ran an A/B of the three approaches on a real Android device
> (MemTotal ~7.7GB, zram ~8GB). Same workload for all three: cycle 20
> memory-heavy apps through fg/bg to force swap-out/in, 8 rounds (~550s).
> The stream mutex is instrumented with a trylock-based counter; the
> measurement code is identical across all three builds, so the only
> difference is the patch.

Yeah, that patch was too quick and too dirty.  We have significantly
reworked it in [1], specifically patches 9 and 10.

[1] https://lore.kernel.org/linux-kernel/20261013035201.2809924-1-senozhatsky@chromium.org

