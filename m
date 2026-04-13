Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBE7E93808
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 00:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8788C6B0089; Sun, 12 Apr 2026 20:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8014F6B008A; Sun, 12 Apr 2026 20:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9DD6B0092; Sun, 12 Apr 2026 20:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 582856B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 20:15:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1E84140C48
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:15:34 +0000 (UTC)
X-FDA: 84651613788.07.1492E56
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id E41AC180004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:15:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p5OM6cIR;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776039333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZjAoNv/0bH6d96ZJoX3aNNUEH/X9X2mePXXADQJKVw=;
	b=Kf9j7SdZxQWGwwK03/8pFLFFZ6oQij3GCT/irrChvTBI/XcEaUunQVvNHohdUqWyE5s6xL
	UqBQ3eRzOtbQAkDgOe93Pq7OrD4kMas+6UyTz/c3WG82rvKqAPwaFcSyZj/N8KmAYrdLpX
	RmgvtnF2b3tOMA+9Jlf8M9sGy5ma7YY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p5OM6cIR;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776039333; a=rsa-sha256;
	cv=pass;
	b=X9mBt9sZqg33SXiLKwmV1OHYesQ2/vpRCslcDfi9w+py3GhXn/Kcx4qd8wQJQmUiAvhPb4
	0tDWdsdvaOaSgMi6Y4lEFrM2nVRZ1x/SO4b4s/pmiwuMl2mR01H47u5n9SRuKiEn8Df/2X
	jO5cJAuaTl0+2c8FJAr3S8Nl75jvScU=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d17bb1c65so2480059f8f.0
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:15:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776039331; cv=none;
        d=google.com; s=arc-20240605;
        b=DhyCDKc4iBYnHtf/SMMEqUocDYrrX+86+/d6mbrrRfD6UY6kSFRfe9orP4hAeVZcWA
         jh8//LOOclqGW8rrg3p8xllV7RHSdQ0/vIq3ssxnynyIW+ae8EU5dgDvUVnMlHr2QbOD
         VIPE3hvZ056c5FnZ7HadZDRkIRF6A9OBIWFNUDNTq9l1V4tL2H72UcdgISSd12zTHaH+
         sDdzCtp0vJCOwkfpj1IGVTSREx21CXwbB5geqO1PgMj+NpdrHGeJ/nbzPe+3BIyni34z
         WNN1x2EsIzaUHE45uz0KIehcQI3EKH38luCV6H0nrQv99Od8XGP6BahuWTuk9XkUz2vN
         HEdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/ZjAoNv/0bH6d96ZJoX3aNNUEH/X9X2mePXXADQJKVw=;
        fh=m19usqeNreHnnb4qc/nYsR3m461IlxNxEl5q/20sMzU=;
        b=cgcKva1A2Wt7nq1IBcrP3pFVssX1urcoKCvju0g4axxD4IRWp5mNXK1r6e6xyW0r94
         L5Li/NJs/vUKSK4vQD1+bI4jCCeTyDvXh/B+l/UEyGWK/z4cOALYnehrje8TEp18Y+zi
         Fv3OSWEmtTQLxKn65m+PC/yT2l0gYSwEyzCqTJuYu2xM4brXpSFwkvybWGw898/dhXyW
         Rrc/vquc15fywSp6Nhi5CYKJ0HtNX/rUPfszuLxR+XzZk+QP5PzfNKAD14VhJ4VLBHdI
         Nr8t1NO9FKfJGqAtpH3z4w873d3ubB1LjwPkTm+girNgT1FFxXyvBYLXGuNLQs/bu00Z
         AQrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776039331; x=1776644131; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZjAoNv/0bH6d96ZJoX3aNNUEH/X9X2mePXXADQJKVw=;
        b=p5OM6cIRtmK3Z0jwBB/R9HHVC/B8aE1fOdzlT9YxZjWMWPg5RhMA6Yj7FOyZ8vulHm
         /hXE8eRnZXKBlR7EXe4Fig/4wwAS16icrWXhKkHix/D66wE1dRVcEGTLK1n0zlHKYCr6
         9S4y2Htjwqhm5nPUf0ozeQ8Cqk/f97+5z/D9To4ViwrW8cvKJ5vJsUI04vQM/uvGURpW
         mPT3uVXcOASM1nGvTUppO/4ezUPv9K2zn5Q6kmmWlg3Zo4shK7aa4r36EvYXj/pnckZX
         EJhfA60jeyUaV4DphZG2QRnsqBGwSvuRuxsqZzSzOTo8cjURc/VKbPBCsNhN4qbLxKjO
         yfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776039331; x=1776644131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ZjAoNv/0bH6d96ZJoX3aNNUEH/X9X2mePXXADQJKVw=;
        b=r/UrXgIefyRY8bn+eeYQkSORzacqz07usle6AgCxIvDDzE3OjiIF05hDNBXN6hyLJM
         K67RPhJdw7uHg7zp2xQffb1Fz1wJ5qMkWgvhE6Lpg+T9mlL/dBkl6cEKFfJOLi91BuzS
         e0iaToXjc4rfE0sB4miNt/D5ADhZf3f3NipRyojkSqiV3zVGkJ0icpVb5+dmA9NiRVqS
         otnkbtflrkCXnNnu8wZBTEPHMSWBl0YrnJMsdEDkhLRjCOSZKhF48Xp0fgufiTsSMY+L
         Kml4Brfhrb7uHCfEFAtJwZEzXDNH4zpiHfT3x4eTM0AZmPbjuVzGQsK+nY0zjVk/dH/f
         iuDg==
X-Forwarded-Encrypted: i=1; AFNElJ+vTJ3ggt0edmfrs4vX67yIQLK01CcxFgB4NVmKA1wrb/657whTWNgJ9FUAkErGGpcFtYlueUXTzA==@kvack.org
X-Gm-Message-State: AOJu0Yz90EMoUOQN0PZd9mG9kuUFxD6fpLmsB2WiYmWmVJ5Q2hkXs/9Q
	PLZWbCw9PQX+QTiImolK+jL7tAC7EjLqa6qT4x56w2e0vA5CrHqRmo2p4Z4tX4UHL96OqB93g3Z
	MAY5fVAB/n09LQbXTPeNqdml2xac5bxw=
X-Gm-Gg: AeBDiesAws//GQQPxp3Pqne/Lov5rmSJAD2oajJ1/FgX0LjDDpKvCqIGmLnimU8ugWk
	pwBIch5tAk136WxeY+3ecl901QxZV0qJ5NNxvDtxadO06WH8oB/iF7PFPxQK23qP4eghQzd8Zm4
	y4WrogJzTImUIvzwv6Vlde53dwaaCrt+ToRjS1Wj3LDbbmUEmkEykQAKzUNE86NipgcXtw3v+5u
	nYu8XOCJ8Z8QoMtCoxuNDJodsF2LwTK15BQrqXZv+n8kVRb+IKThFVhCTVNlcJgSCF4A9J+z1zi
	W6BCENSKTRP3rg23bhPmm1xx+1V1X2asXd+8DnCo73ykEWiw
X-Received: by 2002:a05:6000:4387:b0:43d:7508:c9c1 with SMTP id
 ffacd0b85a97d-43d7508cd32mr5342542f8f.50.1776039331323; Sun, 12 Apr 2026
 17:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260402063714.55124-1-liwang@redhat.com> <20260402063714.55124-8-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-8-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 12 Apr 2026 17:15:20 -0700
X-Gm-Features: AQROBzCifv09xX9_r3AlbMnr7448_s_gW4fyAOGpR6oYAtKp0TkiGlmLrGMOEK8
Message-ID: <CAKEwX=P5vet_tfsLtOcF5x4vMu3NFkq=2oP1npiY1uemR-GZvg@mail.gmail.com>
Subject: Re: [PATCH v6 7/8] selftest/cgroup: fix zswap attempt_writeback() on
 64K pagesize system
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, yosry@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	mhocko@suse.com, shuah@kernel.org, chengming.zhou@linux.dev, 
	longman@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6p76pr717e1e6e57jhss8dae93skz94z
X-Rspamd-Queue-Id: E41AC180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1776039332-977040
X-HE-Meta: U2FsdGVkX19dHLk6KbwQm2KjocyceIqgVcqfo37gcSrdj4oX22m8PNW8h/w+cP0HPc56XmLptZmm3sJjrtJn7sKMYc4SF4NibwHHTvxW7m4NF7FZf2MoMzB+x1ehNTa1ECSvyvTRcU/WfTYR8XGON5KLxNIIe79mAsGUw2ySHK/3CRcJTeWJf1PzuTh2jb/NIB5HcH0Qfdkiv0zAHSAPXPjdSElh8xIE4PDvsOTeNYQUX5ZczoH047udalKb6bZS0TrmCsELRh4jEVyG0dV2KFNflVjEYIw/mxjb84v+0b2phPQwiyTZUf6fX2wTT3u9kVbpyWrlknUS3LZHCtBgVjnK7dHn3gi5pWs6y2HxI/KwNbpCOfmQJyGLg4w2nepvEHx7FP0uLEzyPWHwaSzEUpxgIZKz4zaaL3598937kUwB5L3K3ezBwVcQgaYfuTGlqmzzuJEgjXI1om55izTIptVJZtZ5ZD5hVq2kK8e8gJ5EWL3FfNED+tyIvRgjv16LDBP0DZPHGPpbL3SSGPYQ3LQ4AGmh4LGAW7yukXhCjreCOTqDYvu5IezON1EXxuSqLiJx5y6UYxFwyv58zdW/NDKFGak87+yCAbVPfPNTKoZPI+6Bd9fn7fp/ATTknQsCyhXj5ZYHkaWNkhiWqSbMHb7IW1QQmPvb7nQ60QKOZ4wqiIOmwSrj42XZHgzFZQ1sWWkyZe0puiZ+BeoxSwqHSu6Z8kn7OVXzlyJZWuLiwRMSiC8HdvCj/9JQzTadrSWW2F4k+QawLOqnovl5Bhh8nelsc/maNW2xpC2qDchHsSjRn1RCD7Y3ar59bwShxGkW668YOnjUTa+8StJtLBVghwW08gmIwI9xAy6hM6fPyoHtZJh5lA/s8UGMimocedCKmsXvoBoY/b8t+SjqIGY1AYZaHKezMRIOTnIcn7KCtqMkVtfGE6MNUovUbGrrswUx8PABUC4AX+GvQbpC1KB
 0cIJI72j
 INjsFoMlB6SCwSUCsQtfzTq1oReDG0cQ718CAeMzpvG6NscZ6MEbGMzQgjvrk0tLvv7Q5UOUpWT0Dc68COyWP4YEsc4E+O+yx97pQQdGFkP97zosrzK9fkDCqMHWBV12oIJKNDYOkYhHHn0ShnfpUVQjB7NCbqUSnFq4+8girUJCm8SVr3d5xXVcuFr02CgI4d5qe6Yz6aETsqJVezWlbls1NIT9dGJACLvL/Ss+6PhZSOXvakeGbXKkzTtnR8v4mrtOMG2Dgp/X1fzg2rxcel3buY8YESqiI1sGoZARbSNtIah4Sc/Kw5FiQR2dAv1lv9F3w+F+/am+x/QG8OwuMCYTDXV/ZH72PbnFlWK6h0vgqwPodZYPDvCCw30wcn2NqqYpFGMc8FTHcOsV+aaC2HPbHaEHmNVpIN8Bm9/wnZW83aWXz4+ekk+OPf+uX9v1Bm8JSfz4X3h9buse7ZwYocwrBEfb0qu0pZ5iZKE4ZnWas0sRyi6N+vKb7sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 11:38=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
> page size systems. When memory.reclaim is called, the kernel prefers
> reclaiming clean file pages (binary, libc, linker, etc.) over swapping
> anonymous pages. With only 64 pages of anonymous memory, the reclaim
> target can be largely or entirely satisfied by dropping file pages,
> resulting in very few or zero anonymous pages being pushed into zswap.
>
> This causes zswap_usage to be extremely small or zero, making
> zswap_usage/4 insufficient to create meaningful writeback pressure.
> The test then fails because no writeback is triggered.
>
> On 4K page size systems this is not an issue because 4M covers 1024
> pages, and file pages are a small fraction of the reclaim target.
>
> Fix this by:
> - Always allocating 1024 pages regardless of page size. This ensures
>   enough anonymous pages to reliably populate zswap and trigger
>   writeback, while keeping the original 4M allocation on 4K systems.
> - Setting zswap.max to zswap_usage/4 instead of zswap_usage/2 to
>   create stronger writeback pressure, ensuring reclaim reliably
>   triggers writeback even on large page size systems.

Makes sense to me. We should scale the test by PAGE_SIZE.

Acked-by: Nhat Pham <nphamcs@gmail.com>

