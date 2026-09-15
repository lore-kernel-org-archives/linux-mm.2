Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C9FC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C3F6B009B; Tue, 15 Sep 2026 08:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2EC6B009F; Tue, 15 Sep 2026 08:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20BE6B00A0; Tue, 15 Sep 2026 08:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAFED6B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:04:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 549BB1A03A8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:04:52 +0000 (UTC)
X-FDA: 85215865224.14.FE0D04A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A60D3180016
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:04:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mh0aJRjv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473890;
	b=NRV/CzWO1nJy6h8DoZag2whM1liucuVVwo+NCrbAX42ialJJfgbOWhcTUxCV7EVES1wb4g
	V0I9849crppm6jNgod7jC+YV5IWQUeYtWFtR5XSCtKP3pqyBK2p6JGzA/qHz5oWo5Sj0IL
	iMSDV8T7SPxHYftqUohBKiWsHRz4fig=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mh0aJRjv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473890;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAT+dPINnJ0baLSnWeyqna2pT2L+zf+r0Hb38LXbJr4=;
	b=h8w9jgV66savp3pQjSD4ScwKGkdn27T1uEJHaRxwLWD6GMmh9WC2IBway3M3DsKJkhxIam
	4syugcEZ/L7EF5kuw6PCKJVrehIN5LGAKXX7AWJvLJeBJfhBCoUAa2IO54aArdowx+/7zu
	sSaXkjh+WWssD42xBiapGXwEEqqYLT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D371E42D5E;
	Tue, 15 Sep 2026 12:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92CF1F00893;
	Tue, 15 Sep 2026 12:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473889;
	bh=JAT+dPINnJ0baLSnWeyqna2pT2L+zf+r0Hb38LXbJr4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mh0aJRjvpgxlZiLKhSATPqRfUaES+f2XTT49Q88vDM46+M2joHhrL5IXTe47rLwKc
	 lQ8SWuZa+L36m8Iss1J2WPRz0FGDuI7oSB9RhNnd6Q/OBlecSo2ec3ESUds1YiK9AY
	 yE5zSTou8yCIYMwaO7fw3TkKtVt9q88AVkigmJ0j7/I1yD7epQKS1vU3wqqB1ahaXX
	 LNYP3gTZ6O2PbkoUguLy6zmGopGbgX6RXuAS1J3tZlp1M2JrhXEo7fKehrQrDDD3RI
	 cFHwW76z9ATTIL4qO2fc49BAVBC61Nonh5r1ZU9cD24BOO9dRalQfLo+8prJsERH0V
	 r769lDt95U/fA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 27/50] drm/amdkfd: stop collecting CRIU dma-buf
 descriptors for a final install
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-parisc@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-arm-kernel@lists.infradead.org, linux-alpha@vger.kernel.org, bpf@vger.kernel.org, linux-csky@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-sh@vger.kernel.org, linux-hexagon@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, linux-snps-arc@lists.infradead.org, io-uring@vger.kernel.org, linux-gpio@vger.kernel.org, sparclinux@vger.kernel.org, linux-mips@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, "Peter
 Zijlstra" <peterz@infradead.org>, "Jan Kara" <jack@suse.cz>, kexec@lists.infradead.org, linux-arm-msm@vger.kernel.org, linux-openrisc@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-27-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-27-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:04:47 +0000
Message-Id: <20260915120447.D92CF1F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A60D3180016
X-Stat-Signature: pprw11jb7ffon4q8pqht4ui941uu9hrm
X-HE-Tag: 1789473890-988633
X-HE-Meta: U2FsdGVkX1/GjlcgvdWU/OApvoULs3Cglvdht3wxMmhEcHj9k0b13QewILqi/g3I4/1o4LQviUfSlWUT5n0Wa8WyXY/7wwIZMTPf+C0ZwBjZ2aafo6E2qO+tO+hY1o3VKLV7NqNX8/iud/e3uxb6cw+yaEQYWeywXIvGrBehfQOyugXVR/HqtHMWBTrupFkM+qrwjYIuh+CUZGVbVpSXOR09O3tpKiQW21Wo8Iv3nWidAvq7zQ6yqSHvFEegeVunwUZYYD9Nck30yNk0tKi4GmGN+Qw4Q9ob149lSM5RtE4J++2gbLDJTy/T8ILEkMiIUoPH8RK9+6IScOMKjudWObr9rjPsQRRX6f7j3s12ptgSHslMFTdyrd2UikFj2bOuTVlOwbgSdKGC5y5O4wbsMl/9P6d2fwqI/CMOlRc0IodmMaSnCId2ALUWMR5bKkA7XQPTaga942eW3t+eJf4v6boo2SggufKjr0CmTdGsybT+bkbSTE5l6c30NCSfQ2gznGqj40LxZCyGAFSD7ki4zznYsVIV38hwanjwmK/hx+QS+6xM0uzG2qqe8SLXQNdPbgsWoF69ej6NF54LBlGQbmCBZhF17ASp0VwmZUpquD/RAtdE8xzpiDBMtppvL6Vv7cMsseAjJ2Q04kz2ILj00744pd1dxva+yDSAkX7Ak7effNr1cioX5hhsXDI+aTAXVnVXXFc111Xgxh4OK1wsTYKGyeUrAD0tI+L92JngQiixjzUrZIvnTxIIhLPxWLrNcNazne85BxhiMyhykfE4beKtjaG6f1GGmJh7GPN3ERXmfJ1oDytQdCz+0KLUYyrVkVuZ0EnN6ji5NYBxk3cfu9hlvyyGs9KP0kuNs0Cr5GRZccsyC3h9unYagJug1CNNKqHU9GZGs75W2qnfI8jt+SSMurZ0lq3T9SdO8jKJhTSfBQrsmGvliGArwToxHREEu+ZmZqLGkTqwebvsYEK
 nD/pR1tp
 M6B3meAYmxwuIFlUGonUHV03MWV/MQwwKqBI/xyBWyXtu4YfcG6OaDla6HrwbkFN4uA+QrdinwlHOLMlMVsJ9iS3ekqUIH398trpAHbDwXT5sfzsLb1NEtVBKlHwmfwO6BCebfN93aIYLH0MEFInhMZLgXs1PWr8SVFXx6fX4qX8HInleMZRCuXbJssKC0jM5K4/6Bx3G7tbVHxCninDVGUCq6FFwYAQAdrnQdYS18QX4/wzZx/tfRPOzO6SJPZGi7o7xKrD2Kl1C+hNeLhOPumFxOAlg9DrhblJNimaBRBzpk2J53e/XU2TBGfxedGotJX0ovKwkqCCrMyMz7kzTKVgMt88tJ1Qq3rZ/ZMVDqW6dcxl3T4+LYcoTw6cBvlVLWriDSS4ldfVNGv+bGojUO6nQEd6HJn0WxsHWMHmIZcYjYEK+7ZYZHzz3Bz561s2GUOcAk9Xshx14JaOifRydxWtsKMK3XP6vsuh51m71ZvXzRilGoXU/Vfh4UOG0WCqpoTh8BHTsm76Rurt7GVR6/hZCpFR6DH5/nBuf+RM50ZFoOuSTz6zpioy647QmFK+3ckfjpLZrnLMfA79Q+1iztQqBc+ufR6TatMbeTZI6VYRlpQAZIt28QMmxWvAFzxmus1rkFNI7mQjMAuAkwTxijuCrpKH0y77noZvlNDm5sVNirAV8E7xLU53g/iDfVKSvIEZ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D27


