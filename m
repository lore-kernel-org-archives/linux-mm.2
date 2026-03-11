Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDE91125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A036B00A4; Wed, 11 Mar 2026 15:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5076F6B00A5; Wed, 11 Mar 2026 15:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433DA6B00A6; Wed, 11 Mar 2026 15:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF4F6B00A4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:56:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E055D13AB29
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:56:46 +0000 (UTC)
X-FDA: 84534840012.19.DD1B08D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1673B10000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:56:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0thDb5L;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzGmQtWSP8GeCjmmELZFrh744oNZpIw4KDagI1bfGXE=;
	b=gGIRXdWz23mB5CkcIsxwtVSgi/l+7ClegVB5nymnHdxKfriG0+WXTcz4xiWCyyOdDc5FHG
	XrAbsmzNCb0Q7Vsn+0KKvqFkwrS/48hVn8NY51X7nz6NFwIw/RrgM2RtkzE10URXKUJl0u
	mZiL+1MHQdhlf66QP496oafdOls2c8M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0thDb5L;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773259005; a=rsa-sha256;
	cv=none;
	b=o8Qrwvm+kn9OmfmiKJP4LNF1B00JnqXXrlWN84+dP0DLA8ZncMkis0y9x8LySjeaBDaJnY
	5xYJw4mqWCB+YnddQ2cw99b2PDroI4BUkZhC5yR6QaiW5BcZ+F0gB4FOZHRm/LzY5o38Kx
	+1tfrfPixkYrmZl4Y8WCzQpzD6emO/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F6B26057A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20160C19425
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773259004;
	bh=OzGmQtWSP8GeCjmmELZFrh744oNZpIw4KDagI1bfGXE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=S0thDb5LzDQ3z65UsKxGoGvIK56PYoaMDyznUeMm1l3/XfM1c9qZ5CZWmdOWcvzYs
	 FH+AZYBKSC+Q1fRebCxxXWO8sKhk/OTKVz+G8PmKVvZf3OwUv+9yCjj0lLB7aSVV4Q
	 5Nq9nMmVLb/fPoGGrzkpG+GtRAbCCMU23E7fcJBVKeDgU5RMHNuX7LfGpZfV+EDb1W
	 RSEdTiyXsD3YrqQOq5v1SREuqG1MVjp4IctMbdF770Ce8OfszFz79LzrUEr4Nb6HSH
	 6vQdDsjGB+QHCU9mID+IdmkzM06kdoJbJQiIPqo9ZCIQvKvScjwT3peoB5voUzrkJj
	 hJZGWCBImoM8Q==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b96d784828bso28860366b.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:56:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWWDt5jJMd8OspI8Jtsfze5tFCiXn7k3lVnSD0LRHKW33z+XKVo7wD3MNrvV5dvfUvUOR/iUetf+w==@kvack.org
X-Gm-Message-State: AOJu0YxEECs0UeNt0SwlWTvLhETykDrij/Y1jhNvNFgUBqrZYt3Sznz2
	Lk6EESqe3jOYHkZhwZojn3FD2IpRKCsV6gEeVfzqxQfuoaXXCJrFvBUpi4iAwEez2Fy24ACvE4q
	coTU01+tlj7rqFOeZDUDS/3CgJBl2KyA=
X-Received: by 2002:a17:907:1b19:b0:b87:1fe6:f223 with SMTP id
 a640c23a62f3a-b972e1ab900mr207703466b.6.1773259002841; Wed, 11 Mar 2026
 12:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-2-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-2-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Mar 2026 12:56:31 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPzf-u5L0XZwmS-zdDX8od2JA5yCQJ0+poiT-2z4DaatQ@mail.gmail.com>
X-Gm-Features: AaiRm51YaN1-HxybwvONP6LHP3O_El-JbbSMV02_d8YijMGa92UgDZMyDISFQ38
Message-ID: <CAO9r8zPzf-u5L0XZwmS-zdDX8od2JA5yCQJ0+poiT-2z4DaatQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1673B10000F
X-Rspamd-Server: rspam07
X-Stat-Signature: jg3ue3rprjrt53wykoeyo8bj83ug88xx
X-Rspam-User: 
X-HE-Tag: 1773259004-803845
X-HE-Meta: U2FsdGVkX1+kZrgb84WRVzErW1/92aOO94iiQZKUWTderdltM8aZVkanu3ObQIkM9JEPWu3fLoElG8hm91vnkBEijcmvmSaC4/MS68KY+ZE5LKHOvnRtKHSwPDcfJWjP+puzPJwB/ecNMF3rSDHtAOQuKlN1cRrSxG/0/1ajgv4kA/1Fn4ApIAkY1I0SooPG7D2vyAScOWxmUYtgw1W/YDQIbCOWgPlnmS6J4/tCtHDQX6/nfOpivFDZAaWf5S+tXhVAjjWCpG8d6dDVAwPbw08r/Se+SBG2pA13/80Ja8wwG0LMaBDta9Xd0l5BzgxjC1CqA0DQr8E8wUCg9i0DZVzH8mjMlC7TnC8WioSKLI+QElJ0udyzccGWh2EIUe55uMetgZ/eZTsx8gI8pfvGU4qhLgeUXyuPTilOnf6W10F70icH+zPWir4tlAWihevdVxmxq37Qgn6MD4oPN7NUXRWlTUN7XBskr3hXiibwDV1OOr01COiWUjsmvrM5fXK8KOB/YLiHqNM46inX4j0MK4TYKqn4d8IP1swojtMO5CtWaETmN7bVv7qnrn7E9DLGR74h5IubZ9qApjxS0dpRBAEfhzkuWpliOVSydtrZAuSSWapdJfSSY/H+S7A7v5F7qTw1ZAZSksOMaG/QeJsusjAS1VH+6Tmwd8W9k1drP8uGo/fyHZ+qE2xU/l0Kh3pwAUYzX00bmnEfINjAsWoJoLWCSDvz0X33KoDem+ddUUZkOEt+YUGgScMFdATXDN60K/yHI9iO8NrqQVaH+nKHxHiUSCtxZRYSxcv7THtgwjlP+LuXHpgz4bC1pAmwxjQ7kV2f76oh9wB7n2alXecmPShOnveV2isSpke3BUo84Dk+2iHB0IBuCVB3F9HjV0oJmT0Vqz0uYX67mtmuRHGzcGWDirFdpvthLitLzlvfLwchFbaaOItWjSHFC/kQHhm0sTOHt9bvyKkFOqn0UC7
 O/t7DSgg
 8TiavcztXzPcXP7uN77LXAaXdPKEYMvIOSjHstV/J0FhS5w77t1e8hvZI/451Wnginzzl/BsClB5gJkdirQgIeFX/yCtLByibTCjjlmZtKKDc3ycUzE+tz+btgYavF8Z+GW+AvmJGJmdq29Y7kE+qldPxHqI6VoZsvuMDy6JKFytFBHPs1WZm2RNfAKAm5qd9oIqadWPNIMp3jDYGlfELY9eU9Q7/lW1Z7uqUmfCG4fu2bsBUavlWFx6HbnOndxE/h70IcEBGTMeBl9QDlIU0ruWoyZqy/Mtc3FM9wc2AJvhNICnmoqMEPDdc+QgF3qMrhdX9WGSGaMq7Z11GBe5in0xhnTvyhq7PO1y3zW8llbOneZphGQuEu2svVo52WNPmdWdPCSz04/NTd4+bYjDAX6BE5HaDB4ni2R5HzUwzWwb1vHPaLCm5BfilWivL3WFlVCxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:52=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> All the zsmalloc functions that operate on a zsmalloc object (encoded
> location values) are named "zs_obj_xxx", except for zs_object_copy.
>
> Rename zs_object_copy to zs_obj_copy to conform to the pattern.
> No functional changes intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

