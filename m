Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB95DCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3D56B0088; Mon, 12 Oct 2026 10:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB736B008A; Mon, 12 Oct 2026 10:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1C86B0095; Mon, 12 Oct 2026 10:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CDF66B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:08:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C442E160EE6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:08:22 +0000 (UTC)
X-FDA: 85314154044.01.25323DB
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id D32D24000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:08:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TNB8qsH+;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
	b=0EXR5Kw3qyMXagLNaWCzOvlG7hhGH2HU6BJuINPe3ZlsG83tFfuYlK/GFKeBsZGgkpPdXq
	MW6PSD7nDSppid4XSh53JdgIlIfSOpUC4xqQTKgWdPATuiRrSpz+HBw5ZeWuerOVI1ylhx
	mRLDCDB62N1XiUz2b1GJuL+dM+EiQbY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791814100;
	b=oKiIJoOvSWD07+dTTM3erq9CHHl6Ya/v+5nmBFLLmXIePkitWbK5ciPpc9BgvVr388z56C
	RX1Z0RW5827gw7UoxQ29T/Ul+05pmxNfckjqKs0LTdRa8jzeGIoprhVFidstfxmu2RXa32
	KWsCXfmM8mLbo5cIvOKyC5sfZzMYRsU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TNB8qsH+;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-533202fe429so382261cf.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814100; cv=none;
        d=google.com; s=arc-20260327;
        b=gwys6v1mk3MtPBNYBp2GH6ruKjNMMYkAeT9F2T/a8iBSiFWx0zTHQdp6ZtgUT9U+EY
         SMNhJY3AoPa99BskADuefKE5PNSTWidTWk1/zo3OSIYpUsWCIl/XDqqSPpY3ylQE35og
         EpSOcJWAW1FCZtN1CBVFHO5AmDZU2BC6Z1J5SRlyjee4vmJZfJPvzaDChsaBNYFWH27E
         OVbc7NkUvheU81Haul90ooAX1mhx3BDHqp7RnIyxXUw6O4pWscfyjdWQPyfUOMY1UtIf
         xhITA/uQEyrcDwwfAe7xxdsX93z+ld/uBE47AEH4utzG3M/OLtwnZm0r6eW8HN+1gXRf
         f6rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
        fh=EmnAIRdyXRU2cmhP/zjYptxJVpOiOrEYCjlf3MMS7tY=;
        b=Qv72By9Yxm9QgWIBS6F8YXxq5n4HKSwvGpr2sBgi0Ylgm8BXX2CpGi/PjSEA6obPja
         bufdoOH9UvTlFSOX8NWtOizC4XcbC3kcEOYWTlbrCoYXAXuWGY+Ll7Rmv8JJiHwKzbRv
         zJDv4iMK5o4sFUe1TsABDfZbeg3L0Q27AfdHKu8CLSABc0DAIDhs7qhDyI5biKvI3GCe
         mUXLoYDL09vI6V0+rb3Q53Ur7YypwkF/E39fINiGF7+Q/XOaHlAMEHmYrGN78FU9W8nn
         YPLXPFTfLbLX3XVkdXshELmKdQ4z97saqwccj5LDgdsnsmqoh8d60IPf7nQ8Cwp0Ukop
         jB4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791814100; x=1792418900; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
        b=TNB8qsH+243o8lR4nkuylPv1+BUAW9REzGYJ2O4Jq/rO3lSO4lWMNLQE/mFYTMtTHt
         Zd9haqN7S+8SDppxBEsEJHKnJMtALoMcRSzpd6NogViaOUrtdQKPLF+3Rst4cNQv/R3f
         zpZjwR14+bpeN54BUJZKl7zQptCVQcm3willhP8rJoXzsmeRwA6szEsjbwmDCLWNLcLH
         qlkU7m+RceTipaA/N2YglYBq1fzJsBO4f/YDBcBYvorfZyJ9Kl8ZTbma3BjDAUfZgCfh
         tihlP46uEekkLBGfVkqFsOtFZ+BwTTXDl2dbyf9CcsMEXgdVOHFguN3/7fWtiI8LA3qh
         qjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814100; x=1792418900;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
        b=fMqbi7aMwtB8lMKVFQN7A44MgCnfXdAOYzmVib4cp9OIWRCZ3DcWZJ9+Uq7HMoMBIE
         GlQ++hJ4j91KpOMYCzGLOwJxOlYXnU6SfpEcGYIrPe5eNZ2qv9FdilaNtCsvl18/mtAN
         pZeJqaoM9Q3elZ3wQTQ/WAAHPTGmUKsm0foaYXQs/eNKzA7EIrOmkk4gteapqoo53hVM
         q6+wUtHL+yOVe2/ydnbA9nG3Ck6lxOIrSg9nwvzqARwFyYha5I9OH4hM8Ep97DNS7Udx
         nNJkW7xxb7Qe8yM3KayafmGd1oaPdr6Dp1xIEpyoztXG7i4Yx5oRf9Nb1OSFlQI6ndYs
         K/Zg==
X-Forwarded-Encrypted: i=1; AKwUvByfac1m6qvCQjoBwMIO8rXCeRUUHk7aDS1u2BWQQinF7cVLUviFIEWV/kPDD+8488Z/rtJZSs9FMg==@kvack.org
X-Gm-Message-State: AFq9FYLkQN2eCNy3Ip1FGTrQoQ/iIr/3alQfDrZJcX7fdSInIERQaChh
	tXGg0uSemVgfudbjhfAA4ekpCin0HwfGLOJWgxsKU/+dpdPBLxujikNAIz43tEC4CsWPLea9onV
	QN2QbSvXvDHKJ+DSWDfcr9zGsvqox9tc0M15aqYP9
X-Gm-Gg: AYBFou3HYCQO1Ay9YDBB6L2dohp42VS6ySq84guz5mb7cUNw2vk14Q0RkVVzW7Z4Wcv
	WKq5usILpoEIBfceleNbOtOGAOAJPO9+ugbI5s0O/8GBULMFj+fKTvNqCZnGjKbFbl5Nhpv2Nkn
	tBanfRzGIWDWHyuyp898vtOcMvLUSLujs4daLiGWMeVrgTGG01gQg3Q9KloCeLofxukUXbXBL6N
	WozSKLX1392lcHUFkmCiEwRBG3gk8Mbdixku8b9mutPVUAlHcRU2C/05J9Q9/k4e1p27JbIso+E
	PNPlQKEw4PdgPzGOatFV5el13QH4VQjgS6tIKq0YYuyCSzDBMJXq/QHF/xlaqAosPm7UXO2qR5k
	3WLpId7vM40E=
X-Received: by 2002:a05:622a:413:b0:533:9746:9a86 with SMTP id
 d75a77b69052e-535b325f8d9mr32241681cf.5.1791814096393; Mon, 12 Oct 2026
 07:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20261011223358.2327625-10-sashal@kernel.org>
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 12 Oct 2026 07:08:02 -0700
X-Gm-Features: AclHuK84WqMsyxy-I57pRe8rAHj6B83pUNBHs476hJrJgTGppN2WMc_WLWeA8KM
Message-ID: <CABdmKX2D1obDASTm+exAtrZSfkLikUxmzKxjsj8avyfUbEcsFg@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
To: Sasha Levin <sashal@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D32D24000D
X-Stat-Signature: kxf5qht1kpwokf1xj697nthdymemcewm
X-HE-Tag: 1791814100-81461
X-HE-Meta: U2FsdGVkX18defVIkmHXLFi711rrV4nsjP6e3hs4XYFqONocsutG7hgPhiwPqJ9MBaZGg52xApApgX0so/D7Hh8Gb6TMbWpTnBUXBYdXzdPxQviAGuMYpuHoJheUJJTwOeravnIZmRVRO4/eysah9Zjd9MaAO4++CeJeXgA7qcjAP9pb7CRT3QFpKEelQADqLwSPS9uyCWkWzfQanMjCaeaUGS4no0POqApKERSlbe+AOZIoUsNypbyjh/AEg0JH1CsA55KKu8T6pXlIt0HZ5tBS2Y3OWXotREdCptDh6KYlQOoLcjFXqCPRzNIvuy6wJpzTH4sA+DahxFMPX98pTXc9wpQJW4LBK/xbOpaCULeiQb8hVhBITjUwt18QoWo19gAnGQ7QKaRxzQIuX6urBewBqJhfgeNV2YdQMNeLYgkABcrEGDEhJZ4GxVZTohFr2VriHEm72Mo+9AhNNSt25TCoZ/cR5xTbc6YDu2hG6LXLV9UvKZfdSQxLsq8/7i1ar4Iiy9CCDuG+Bm2MHMDYQpEAfzJKd1X8GqJO1bRFdLKH2IW7lNKB0qOPNnGFGmHmJnwe7+YJPmNkobdrNizRgN9/t4C1NjTo21WKHnu8TbYmTtwnlmbOfM38MI5jHY3Vf/A4EW8gra/RUhCLyCcdBMiW5cGynPBdVQTubeDOsNUWOlMZmYSCaKNhcz+ZPKxyDbwQ6mvSH/9xGHWFxtBjRSVaN5EE42MSdXOJVvGVp6eTncS9FHASiGNvtbGhd+DB3scadXVsGJP2mXgCUExsAhiEviC4rqmgh2gPGa1aCFlake1X5kAYwzu1EGCySww2m+f+7od/znsxZMenxUYnakgd6flHQYz4Wpkagx2qbAMBFksOpfJ1PTY7HPj/wHoEldZs1SXbFre383+ns75O6DNtZkTd6Wzkg56ymDYY31NuYMh8PjsY/uiMGuQi/CI74KrypcACHN/Qy1KoO5q
 DmHn459j
 /WzNWN1D8P3ahlW48Vd47I9Am39G+0dH2AVjJYrBWaz53SaA9j4ussLyzVLhMswuvZNU7Nkj9Ilc34YUb8vnx/z0+4P4mwOMU9fY85d78dQ+r6Nx+K/WcKMWz2pz4HJlr+NrvsY2ygHhZMQyUgCuSc9Xo5BytpjVnbj5xBvqj9/daednW4JT6bBWUId8PF3FwdPYX4MkST5doUwL3L9H7Mf/Rf2n0vTuTEbvbpiUjzLD5A1YswIE/OpvAuOVg5ibEzYELHJRd5gS/538fRPMbIsxnMuxXmrbFyZ1pCfkV/JjZT2Y3iEYwcT+T5SOWXYMs7byQqe6IGd7iBeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 11, 2026 at 3:34=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> cg_control() returns a path allocated with malloc(). The two callers
> that pass it straight to inotify_add_watch() never free it, and pass
> NULL to it if the allocation fails.
>
> Keep the path in a local variable, check it, and free it when done.
>
> Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-te=
sts")
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

