Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C5B3CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3316B008A; Tue,  9 Jun 2026 13:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7838B6B008C; Tue,  9 Jun 2026 13:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672546B0092; Tue,  9 Jun 2026 13:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5222C6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:58:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AE141A0703
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:58:43 +0000 (UTC)
X-FDA: 84861134526.17.343C304
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17E81180007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:58:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lrfa0Kkl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781027921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOO7uvOn0arlDojJxvw+4H1znmBcEQoW0aSiqI14dLw=;
	b=CYTH3cCTvlp5qLVNlK90vHoVNLeNQkH6ocupXILWwzgNRrr2JtanPKPqFpm7t3aKL6l1UD
	dyGLOzAUH0AwQOufWnCDOtgXw7aPCA1v5s8yzVedIAEKoia4RYGzD0uZM533ctFlaltVhv
	/LnMmxOaPd50SBsGGtf6kel2jdpZqjk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lrfa0Kkl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781027921;
	b=BZzS7KBWC4jYz2VogMxd3b/KYjgRCHa7+N+3jq+hKLJC6bDRP+65ToDBy4oo8HOIG6ooNt
	pbYxzab1L/NiQxj1ylW7rlvqpwO4y8dQhPEAwi+ZCf8i9EZyLkWzkOd78c8uzz17c+KPSA
	MoInmhG0vntHPBMKxeWD/g1yuMBjeOU=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45eedcdaeaaso4029095f8f.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:58:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781027920; cv=none;
        d=google.com; s=arc-20240605;
        b=TGzWadScmhukoQfJ1ezGABJv/v0HlCkdSVaxs/PSDBiGFXIeOGYqwomaMdwrDUH6jf
         2PLTPnV1XJh50jWW1pBo83i78uXCm2bX8Az5duGEaSzTs784OLdezjRVJVfR9mMuOnR0
         uUmopM8Dl9z6Z/7rJ/uMCZgjmtHs19IxCW8PJ38CLGoo+R2ctIDs44YaiUqH5HHMrhtP
         mw5VsEvgl+e3Nqpqegt639i//S/Rr3KyViUseKBCysXOX7qSHKagjPnLzpzTH2QhXgEJ
         c1mThulnTJb7AD5QOxMcCKWH3qsE3mYokBB3pGC74dlj3+UGsLEYHQ6O/Tl33Amsu7ZN
         LoKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WOO7uvOn0arlDojJxvw+4H1znmBcEQoW0aSiqI14dLw=;
        fh=T+RnvNed4xseW39oq7NKldywZ7ptPy0XNS2Xza2zypU=;
        b=VDCtX2dJcnVWmKbl9hqmzEiEYcR0LQ+GaFvpjT9rkg4vXStCCX7kT/rmrX38gLmxWZ
         mLCRix1wA/dVcr7rCBprJHiYaErV19wajjtwJraSWF4sXRjsS1sZz8C9JUOcno5E2Wui
         qhWi7XWvyR4bryr9nr3mxeqTmzjDxk5JUTM6gC/1eyZDmX8UADxyIrkr8MFWQYGw9KiM
         zKZroIwGdigDyjAyUmlYJoDOzc6ycMOdeNmY1Svz+eeytPfwSZU3nTo9MQklsTGPFMvJ
         bMafiiOHRuBDdROnr1ETXllT4iRpi6gk5xdNZgmvjofEBWBAwHFuceSSKeffBge+zCwi
         zeUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781027920; x=1781632720; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOO7uvOn0arlDojJxvw+4H1znmBcEQoW0aSiqI14dLw=;
        b=lrfa0KkldtltcmGuzsfKznQscv8AKCFxVSMp7Krh8bqlgoyeON7VK9NENOmmFtXY7A
         AXCrk46sgotwcu3hoFS5Yw0Zyl5+G4g3H6IkHa4s7/IpH5G/ZRY+yLJH7mADtvDzFV/k
         MrfixWUNW4/w5Qg8vnTOlzA7OB1tpd+vTS21x4ybtrk9qMJJo19W4/CesWRg9nJg/LbH
         h4eWjumhUCMeIrg4oiLO84fNnedWXW1fgAftE+7JSn3/mrRQO7FhhTUPRH0ahW+uwY6Z
         Y+peyP5yMApwXgZmQBVVpp9Z30kzBwivJuuO22sQaaMYLfF8YYISbMi36SVejXYYMhbZ
         vqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781027920; x=1781632720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOO7uvOn0arlDojJxvw+4H1znmBcEQoW0aSiqI14dLw=;
        b=M6mPhpHZw4A+PRUV1Usr+n3iIOZT91YHHoIcRQ4kS5Q6pcbne7l7fWgAIvNiMosbzC
         8XcFk+pE7RKilb+zFqNWkDwKX0U6+ZnP0bgJgnNRf0wjS0eD1m9bHlih0bDBkQWH33TO
         lE1GyzGgC+D3j2UW1zyfPdXKDg8bqFvzYcaWs40R0pSHEJWoAlgExXuvi1XrzjHgAq0C
         dn9SMp/nB6Wm9zJPf1rwersDR9Q87Wv8arr3Ua6Lqei4FtzSvcR8J5ify86G+UOr/2QL
         UArgmsd6uM34/LGXpjnLKUihQdgf0LJnEL+BkgBX7RaOp73EYQeZMpk645UUYLl169pM
         GXsw==
X-Forwarded-Encrypted: i=1; AFNElJ/I+4AKg8akrCfme61FzSiVktdnKvZtvZGz07Ymb9HfGRnSoJqHJuVEc3AQ5a9/QAmeYk1+n0FHrQ==@kvack.org
X-Gm-Message-State: AOJu0YzewwR8jcDQc2bRAxBoFHIUT1wB77fAi0NKpi2j2nHo/YPZeoLc
	UiXoMD7Mcm+iMdlGbOVdlQEDVSfK1hoKbeu75SM28HV3uonEFpd6ripOn6zP+XAJM2bYwzthJ+p
	mEhAmos7nz1kkIppd3sLu+8GJAABYgsI=
X-Gm-Gg: Acq92OFFetlmWM3E16y/MBzi2ylO3/qkevpf4inT0VRcf2paAhH7AdSwmDdEMtV6HGL
	BdR3TmTWTYDki3PIQkycntPG5MqlwgnhE+fGsuNGWXWdj47/nXTGXSwaD7rvZ6gdN3aM9Unggf2
	7L9Y0VpH35UUoERZMAafngeidQ2AIPjXg8Q5gBf9o2RELJWk5YqpgeS5hf5kDSKDPMYPCsFPX7a
	R6s8WW3+zOVSxuOfLWdbRUhDXC7rDPDGovcXQjKE1KOeOhG0Sm6st2XyMctV08xQRbyLvXLEvh3
	gUgkIaRFtY7b9R+HGEfK8WsHCPTVxAqKvQlVAA0ONqxKTKcblA==
X-Received: by 2002:adf:f88c:0:b0:45a:e3dd:586b with SMTP id
 ffacd0b85a97d-4603063a9e2mr25146309f8f.18.1781027919659; Tue, 09 Jun 2026
 10:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com> <20260609113520.3507783-3-haowenchao22@gmail.com>
In-Reply-To: <20260609113520.3507783-3-haowenchao22@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 9 Jun 2026 10:58:28 -0700
X-Gm-Features: AVVi8Cfs-5dvdPAkueMrChO2nVP3oBPz5uW3NVI9ESM4cPEFe3I4YU7vPCwtpS8
Message-ID: <CAKEwX=PsAb+Fja3_Nj9Qq55z1szKLo89BhzS9jHivA1e4uwiCA@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 17E81180007
X-Stat-Signature: iiru5hygtp395fetjnu5gshr355fp31s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781027920-195062
X-HE-Meta: U2FsdGVkX18x38iAFfGWIv9SuiW52xQvloZHRUuK4beONDSF2ezNMN0H+ZxNAvUXjNS1GyJP9hvgwia5/nBIZQTzE8MhWGVxysZ0RDFfWzOpNSwBx640u4J5hERO2ErIAfvmcb2ZgKTAQQaeYdKWHl/+e2BpJTxhJ9/b4U1alglve3xg/Ut0/GAe/vdAzp0vZXIYX4UawJLgSL4VsWIX8NTr2iZKHhWor3VdesqCyLWnNb7AWxcENlPSovtRvaAtEZxQ2IBqmgMmO8zi6T0U+fFJCLntLOvhy6JzjCa4PjxNOocGU0xhMi2OWByN0fkzjIJwrQICqsZsPCaLxC+yvXxTAJKP5bWs7R5HNW4Ybavi7OjCc00txMcmR6NUXnmNLf207wWJ7R5qfR1aUNKVKkdZIIC3TeHOm28vkIZ7R3TmDRz0l4BPjWlZURdsrMVWsP/LzW7syWJmibbGCh2FgXnWkqYtpzU7z36rY5HjKWfIRECw4kIIuhP/aFvwnW7RaLbC4F80ZBtUdj6WzvrNi69JBXZLwoz/i+josE3XNHuBFJwyjZSO/UU3bcuqCa0nqiT6nruAHp1W5lwf5vViWdMBrbItxM0VvBHnoPrwV8AXt6/0Nx160oKsFC5eqJg+h8h9jFYd7qzoleR8OMytQYKnwL5Jf5Q0/AdVwYeNDAiUWaVsg6nxIfTeWXPLdZuynng8TNaahZPNgX0b9RTWOr9vCTz4VzZ2/XxykHQeBX3agowQeqKGwipM/fCC2RDDawysQJnoyISVg5XwPl+4Pfj6Xsg1b9cqOO9qS4hGevEGjqnMV2idIFDMYUnjHUQRNTnbGrg4DjT6Rvo+qrCpsbSPeHkjbCnRVbxD+KbIuMeH1Qn+KTQMmSzXE5GrewWYta+XL5RIeDhBCUxDrrXKL5xgw3VQlYWfzt8VENI9dmaALAlYEHbh24pAZvIRNLbyDfgkS8dtk/WmKNLmZZ4
 ZFKPt9EC
 qdDGV5jPBykICfLp8UQJ5YBW9NAkrKdx5wKyHWmBTlN9Rnw7giRBoN2blU5XKIoW0pD0+vACmK15CYJX59pCFKC4NR919ea6Y3hwFnsJKxdJPiTZU28WZ1afssTJ/xMe+DY1fueimuQAlNbvxKLIPzhyFnl9TBtF5Z44WxedaczMZc6CfUmga/utdZ7rAoQV1TakcpxLNo7VkZkPt83YUp63zP7i+h55KQQkI2QvDqrmAnL2d7yWpC/OQJtgVyIzMmAPQQnFGRE6L+0/aHuv0rTvjLRd4rHkHdjZboW6hVooWe7MQk4vTWdDyCbN1yTuIoLwtSrxq6BoOsDwvf8x0qekLAzUgNuhxq3q9FdQLXmB9ymIfMycJrQmY2Vikm8lup+QX991QglYcIqjRccsw/3Bl/QvAQrDIjTCqLxfjbMNkhJFmTBp6WesapXH8IxVX8r6Q0fKvO65WWSEbH0rv5IAXqotPCvPgbvyD4VTQJ4FSJsAKHqKTlcOrRwGgVYTPWXnBMGINOoTGtot7o7apNY7zF9yJTXBnPug5D6b45mJmAuuJYDKDHnQMVxU5WWU4U/09shOBNawxtRydoTwKWJZD/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 4:36=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> From: Wenchao Hao <haowenchao@xiaomi.com>
>
> With class_idx encoded in obj, zs_free() can locate the size_class
> without holding pool->lock on 64-bit systems.  Page migration also
> takes class->lock and only rewrites the PFN field of obj, so:
>
>   1. read obj locklessly,
>   2. lock the size_class derived from obj's class_idx,
>   3. re-read obj under class->lock to get a stable PFN.
>
> This eliminates the rwlock read-side cacheline bouncing between
> zs_free() and migration/compaction on multi-core systems.
>
> Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() to
> prevent load/store tearing on the lockless read path and silence KCSAN
> data race reports.
>
> When ZS_OBJ_CLASS_BITS =3D=3D 0 (32-bit, or 64-bit with obj too narrow to
> hold class_idx), zs_free() keeps pool->lock.
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>

LGTM.
Reviewed-by: Nhat Pham <nphamcs@gmail.com>

