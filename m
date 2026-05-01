Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9ADCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726656B0093; Fri,  1 May 2026 14:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6CE6B0095; Fri,  1 May 2026 14:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6138D6B0096; Fri,  1 May 2026 14:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBE56B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:06:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D93341201AC
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:06:15 +0000 (UTC)
X-FDA: 84719630310.25.4ECE744
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C541E40014
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:06:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="coVPx/A6";
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777658773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=630MhdUWZ50lV42R/9KL67pHjAmDynf77R6eqGRWh3E=;
	b=mUNKlkdHZ7al/yX3Jq/kkwBk9vnZWkjBGn+EY8vSXw+4SXvFbouWNZyNgdEp//gPkyrL/n
	VN4iEFlJ0N+Vjq58OfiWgV+7UpND78Kcqghgi1nWjqU9O3nb4wbUxo7chSQdffOQeWVnVB
	6zm7ikbuk9Vep/rvqEqU1N4x7QhjRRs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="coVPx/A6";
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777658773; a=rsa-sha256;
	cv=none;
	b=30PAZ6y+WtO32eyEo3EURnVKxp7HoyINAvsbNPhdCRLe7TeW3IDaa4vB+e0Bb4fDIGOxMu
	enXycQKKbK3uv9Um24SJ8YLULpGQcX67zsGkVDFKGyW8H6Kl4/7h917C4xdUCnT8RofjOv
	wCGkuwYAwvmSdVulCTRVm6uKhjfH64A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF25F43ED3
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A322AC2BCC6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777658772;
	bh=8L+AJLWAAO5U+MofkQtpBKjEAlAiu+8zhqpanDmWb9Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=coVPx/A6AjHBTRX88JlLDcSdCfYnbFCYIgoi953xlS+ZOa6VSrh8rAFD+aWv4W6Ej
	 jrCJsX5v7PGCtNMnpv0x0XX2vku4MiermYneqcQbdy/LzVVp0Bdo5uoFIyKrILHgVC
	 Xw3qqbScFHlnNA01YLKDHVhMOlEt+nApGf6zbDy3T6G8USsNIMp2K8gI1hhRI96MOp
	 GwXgMzm901Kk4L/FpJPGVClSSt/4R/pzMo7WRG92N+6/WO4cfoAaukTmGpGCPuNAsJ
	 Zugo2T5OzakgRmdPFRJyGmsX+2VRPrWQHop7xaUZIamD3JD9Mtdd4m4S71NdqY9ekU
	 xnycF9lm0dTzw==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-656d749109cso1277629d50.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 11:06:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ89pyHcZ2SMAWBJAPdEPk0UyB0l3VngPIAZ/zQxNNaW33Dhxzj/ZQ6TMqlTzCReiWOBWnoMAwfbJw==@kvack.org
X-Gm-Message-State: AOJu0YxbG0wlFXMTnd3ZIfFT0Y0xDwiLLScblSrb2BpIxMHDQ3vOuXUq
	s8FR8M0vFR1Vt2LDvwzoOgOE5FNmJm7xe69GtIPOUR+sZAIVtm2TJyuTFRfDxLHu+8SL9ZHm1a8
	8eDBADm5Kx/aKuj8Ffq5+SqnG6EVruhYwVWGh0j0gxw==
X-Received: by 2002:a05:690e:c41:b0:64c:9ec3:d71a with SMTP id
 956f58d0204a3-65c3db8e48dmr133308d50.48.1777658771980; Fri, 01 May 2026
 11:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260430195651.287659-1-devnexen@gmail.com> <20260501061816.5d59d1eefb0a41a3480a3a11@linux-foundation.org>
In-Reply-To: <20260501061816.5d59d1eefb0a41a3480a3a11@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 1 May 2026 11:06:01 -0700
X-Gmail-Original-Message-ID: <CACePvbWNh_Xb63NkKtQX4t=kvmZdv_--LnTbum6hKHipAKGq6w@mail.gmail.com>
X-Gm-Features: AVHnY4KmNdTKU7Wh0RhCDGtXkLakhnbgtvyibCflHyo0CKnj_VeIUitePRIOtds
Message-ID: <CACePvbWNh_Xb63NkKtQX4t=kvmZdv_--LnTbum6hKHipAKGq6w@mail.gmail.com>
Subject: Re: [PATCH] mm/swap, PM: hibernate: atomically replace hibernation pin
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C541E40014
X-Rspamd-Server: rspam06
X-Stat-Signature: mxskmirb9mpcq85k3j7aohmhnebwbgoy
X-HE-Tag: 1777658773-932406
X-HE-Meta: U2FsdGVkX1/FxHCqvixSo7lgAnn4V7QvBZLw/vIYPBWTRt86EsSQwxakY2mp2nQ/+PnVIS38ysgtMJlPvduAyfRSTKvOBUIcz34MfNAHCBE6wf2t1Pi8zOaFAURNWjfEuLaVrEomg6zKAz9a00Sir+9aZNSf9oXYI4HGtV47wS8M+yIz7RkHHDlQ0HgmJqOdn8svJyPBksWTf370WQQ5QlZQookd8kRxgx5N7ECdzdFNNBt9iislHz9zVNrUYwJ8niGTeuEsfT5fly6yCLWo6Z6JavfFBzOmNMFRYNduNDaIHiBF9aGFZUgUrVmp0ecZXRR5zRE/SWE57JrhgCNQpbMc+oLSO7wueaGztwmU6v0rmPl/PYCzJRErW9gg7b6/7lPB+5vrmMnsOEY90WlcOL26p7pVRLNLH/15BGHXJXGp1IdhDdWE97VLgbB4px9n1nS/cnvoB7IhxQwBTWB6yRQmgeA2NwgCnhCk5+z/erXp98JYnx0W3/w7XBvzj093Efsb2d5Avb6IN5KWWxhsBMr8ZWCwUBY+Cwj99QepR4wPd4afyRerPMx50yJkJpg4Yv+X9TFKaGGtHh/YXTMoWf3Q/Vuqk/8zCN9y/erm0ebOKudmemzwu4Rz/Zhi/YxtL+O6XeG/yhl6FoFUPH2WK19B7r3MtiS1OX7gMQxTJ8sOzooIYqjMqfE6d2UNkhMRUlgiR3QN/qynk+idvCPg8oEnYENjF5qA4L6YyJEUDnsEKzzNCpFxFy/lWYmfbu7IQzmt7t4kKeMSOfsOnfZMPJpanTCABGczd8TvKD9CyMizEeha3Pel2lssFfYjXwenMuO3bqJKPwApTcsjjjpu2b4bxfo9wOcZ+4CzbhJfXdVcVCMYvr4IoX5euGbjTPGzuYjPqAyTJ26oHPIysRggZlUHx9xr3HUZH7vhmFttFwygyxvYMm5ZGeONPxHNtFMfAlIogWs+9XgDNWQJ3qk
 ijA35+rO
 pxg70T9FldngJ6ahg061DPEjDxyXh0JFVYECEnXFB/X+s0c3Jntfjc26YuYEPBwHk6cqwmRrE8E+i92HvK0Y9LMLJSlh6nvPbBiHCyp3iOs40R/UK9JFiy2iI7frPdu+p6KaTPHxTAtuI9jG6PaT9nNDpw4MAj7Mo6wGVUC461F4+xM/dM0rAj+FdJ5QzIPbcNjfDRywx/ABoP5CdbwR5u31nqVN6YIvG9C1vfyC6Y+Vjq18YLmsLk6QrqQf2OUC3CYqHupApOSkQjf4xGGtfUd+rYaz6U2r3x33V85YOrqe8/CfTLGQ59IH2C7fkKumoHdKRRHRrq4m7FnDzfUiYlMaP/XL4SJ9n+Gcc5U2DysvwVlDQGxblfFTVMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 3:18=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 30 Apr 2026 20:56:51 +0100 David Carlier <devnexen@gmail.com> wro=
te:
>
> > The race was identified during AI-assisted review of the
> > SWP_HIBERNATION pinning series.
>
> Thanks, I'll queue this for testing.  Can the swap maintainers please
> do a detailed review at some point?

I'm looking at it right now. I might response slow due to the traveling.

Chris

