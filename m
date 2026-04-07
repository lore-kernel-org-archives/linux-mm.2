Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8332FEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063F56B00A1; Tue,  7 Apr 2026 08:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014BE6B00A3; Tue,  7 Apr 2026 08:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46286B00A4; Tue,  7 Apr 2026 08:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D427B6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:47:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 739391B8560
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:47:00 +0000 (UTC)
X-FDA: 84631734600.27.98265C5
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56FAD100002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:46:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CCH1PwO4;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbTQpF3+hPLIOL+yboKhhdmIl8i/2JZY5hAAOzxmhBI=;
	b=4fBWI99+dTACJN9eJFFOLWbSAVMtYqZQyu6fszVGlw+aYYrX7UBzVeYNqzKwwYObyEonor
	r5nijm02B450JgnpS3Jnho3i/jVDhC/DEI2DZOuJwobLuZzDN0fj6mcAfXq04bh4ap6sbC
	g3ihyZfgADXmzMDq+vIA3mvygppoM5A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CCH1PwO4;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566018; a=rsa-sha256;
	cv=none;
	b=fj2aplMCE0h1WBW5HzDvEYqXlOBT1qVyh9DREPrrtE7P7jQItydMxTIRUGPGq6HQAqvgYR
	87jDQEH6GAl4RCpkK7jgxbhBJ0G1TzuLuunO9kAMY3dPfHUZwyo5d4AFM0HDf9FANUUiM9
	tEQoNSKbR7PSioTnTsErps5VwLEqfdY=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so11680305e9.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 05:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775566017; x=1776170817; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vbTQpF3+hPLIOL+yboKhhdmIl8i/2JZY5hAAOzxmhBI=;
        b=CCH1PwO4p00UjIYSS4u27EqjyH4gOk5G1xfw9NZDV+R/sbYSk2LrdcbtDE0bZuC5uf
         TUNmq908yHB+AOwetGqX5SwGjJ5K40FG/MeewQ8UgLWfelVbDgu7mllbqX54oEQNNvD8
         zj9pHErHY8GXHeaVKcGTm2dakQj6sbGYgonOedg0kDU+/hMZcBNnVh4mpWYY5IQC86cG
         LQDZbWl8IIi9kF4EyNkH3jNr9rITOkrz+LyS2q3P7ndTpZy3dEebUe3gB3alBQpvTyV3
         bx3TBNtr3ZrZrPVuYrM48o+k40ftIeLercEAcAhxf9FXL++6MlEheboyCUc4W9AeXpxY
         kC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775566017; x=1776170817;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vbTQpF3+hPLIOL+yboKhhdmIl8i/2JZY5hAAOzxmhBI=;
        b=Z7IeiHCqdTpTdwkTEUfGVYmUTUzl2Jcbk61Lv0mvirhq5OZiqXybKgVnaQOgocJwTH
         6Q34TiRKhFrHZVsBDXoqsOy1gU4bXsUXrqxYYkMomzJS5ADLtL6gBvxTKfq+3Ma4hTKF
         6rCVrXTcHT30fC3o5kOk6gVicOfnQZMVfesfrlcOt5fCp0wzqG/6I7MO3Uk/EUd41/k/
         kalACfqk0rP6A0trOg/5KaHi4quRHdNT+3kTmLEDwGfEwXrAnzCb9f26dHHxURyw5j1j
         RAg00MDQ5P+howEArroR8NLM/d+e1n+mByes53jwFdyvR8a/Z0XFCpTfdb/TFcqzuR42
         xYbw==
X-Gm-Message-State: AOJu0YyYoOqP84CXFJjadSzyVeSfQr5YUUcNGAx5VOKVQ1xsj3ETHJgV
	A+JijLZm3O19nFbc2NM2Ydwh71Abh6/01/SRxQcDNFBC3VJPXITFbNyzMiFtmXCx1NI=
X-Gm-Gg: AeBDietGJfJh3ypAZ6G9SZ2+4e2Hl6sQJ7AYVvZtg+DWqJNHncci6WxvqgCokP0oHYW
	0ykrBcbBiQTeDtmRZpKXYXYxFylXM8QorXuHWDhadZDJ4Qv3KPEixZby4lQorK8pHwrKAPEVA6V
	5EfJYKSrdIzZaAvnvhb6v9UU3PM7U8yLPFunJV8WJgHxvIlajXjKPUuEpUgbDQWMHR3SPSHKn1k
	KZpqn4NHe9GcyxVkTBY5fZ71BSjE1Nj2H1GyrrRUqxjlvs55Q1Tp1bFMyid+e5+X+GeYzKau2R7
	jXQAb6rTYxLF2vIlBitF5RQxPGkihC4OW1nbWs2qGBIGtvdw17thSQ0f200LffPX+GbwfM8/TfP
	FjrYSPyfGeFbbtdgC7z0w0Kayl/xdoCJYExx4k8bwwDPla7NF5j5mvbrVqYKTTys7X+pPtTXYdV
	gfCJgDJwWftcV9ZDW6sRO2WkSKHsqObl/qttAQ
X-Received: by 2002:a05:600c:64cd:b0:487:1fbf:e0bb with SMTP id 5b1f17b1804b1-488996a1c9dmr247002615e9.6.1775566016576;
        Tue, 07 Apr 2026 05:46:56 -0700 (PDT)
Received: from localhost (109-81-88-253.rct.o2.cz. [109.81.88.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48897fd7e2bsm178382765e9.2.2026.04.07.05.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 05:46:56 -0700 (PDT)
Date: Tue, 7 Apr 2026 14:46:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, baohua@kernel.org, bhe@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
Message-ID: <adT8vnS27qKSTvOC@tiehlicka>
References: <20260407110002.204755-1-wujianyue000@gmail.com>
 <adTomi7uPYJebAMD@tiehlicka>
 <CAJxJ_jjFonN8m1YsGh8FjMBbiociLiXzE=tS2+=Or4+PnTPr-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJxJ_jjFonN8m1YsGh8FjMBbiociLiXzE=tS2+=Or4+PnTPr-g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 56FAD100002
X-Stat-Signature: kr6qks35x854pwffc6qnc8jpje3krrf8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775566018-870258
X-HE-Meta: U2FsdGVkX18tnqSgNLIHAnikX4QxpAcaXyNHibNl77xBi/P5Ko4qldnK7DgBAqmWVot4sK6al9nR7Lj+EWERNzBOKnwotC/kEEQ6n6GzCj70cAqb5zWP/zNmrJTiWQ7lbxIo5sgczodO8ZOMXZ/T4zi3jOjspKqnVcZ5ZHbLroaok5fUpIDF/5xrPEIuY7neokVERyL8hj2CjdsLDB4sSyYU31d/hol268zSpJNXTEg464B4GxH5ATFiq0GfyTfyYzSI87hbkCNBMSOWycwZPBkI5o1THAWXddTYrJtJNpq85J5/pOSHXzTu+fX4xHBmoMPbwLzz2gdrAvtxyiTZK1xI0wzH0mGThI2dzH/1MTIV9dZwuxRXpR5d7rQL5gxOISm4nREz5BIVLLWSuK2Gm6I5xEJ14oYf4ziXJSq3gmqDG8otMWQPWKD3mzR9aqoBQUwDl8o0qMAlE5M2DS9EuqXf+lWc7sOpPOz0/jJX9gs9yfPAz1bOFdekZoLReTHp61a/pgUAAVZv+vyptj2B4NhK/18aLEgMyZNtUCHsa23W6u0reyPkXHNpgk18GOBZZ3st4jDJ+CtH4OpFsRDrpJBMXprQZnApxcbWpvur3Ci2rz1OXBDFd9ZFzr3TltiAjFUUH0F5tXyBg38KnX++kakRxI5K7hQKuQN1bQjMi5ZowxaMcjZF4qo5SuUB9YYPPIvlxUBAiq56z2qApTFCrWz/5ZAyaM5XEz8isGSKJ87tKl8mFFPFiesdwgp/7wwleqypuDm5whbBBvLx2x8h5HEiUazaj0tLP8M26EkSXdml4+SDd4YXWdgMwvwe/80Ze1tdim0tRqQesdM2rCuU8LkHS0/y2X/22vQt6ijpGwWMLmDP39LAF/yXiZyYBZ3sBAe/DdefPCPpSsa1/p0wqC7e1i4FLJdLlXpk0OiqYQV4CUfWAHm+Y+8aNqV1dQGy5vsQz9yCXTRmAufr8mK
 PAm1o9py
 RuRPDHIo/oQag270pgwU0/MZav2LHAM1u1ixHveVAPv3cWK2Blm/tVEMIMK1/bodXcsMwloFsK80DSwGJyTajjU10CLGimcGgh6Fxn3rgUhMn0eh5sj+ZcZpYl/f3sS/woHHSo5ARVqxWCdI7OCYjQFW/j3/IfIwiw2vOVVlwYYzLOO5um+W3KZE5ms4vgZRiCGinZknIogb0kewOSZLpsBGmcPygvgZMPhPEpCC6uM6Tq0KrI3ydgb6YyRfBgVdPj4WT4mrHnUn7Q1k7xd4waflWm3wkNsJcGYWlH1ydozcyCh62td4iWY+I4wHc+7El/JSvj1OkvTOVTIVuIEkDU0Nf55jOOcQZ0NFdV7DInppF1PVLoR/IlM+74fLN0Trb11s81ewHPKFXd/y2nlK7FNwxwNfBrgE2zgYXrgP4QwrK7+p0NCrN4a/xveIa4O/BoFGfNymw8odsZfK1YfBezgd0xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 07-04-26 20:31:40, Jianyue Wu wrote:
> On 4/7/2026 7:20 PM, Michal Hocko wrote:
> >
> > All that big churn is really worth it? Are there any other reasons than
> > "not so appropriate"?
> >
> > Really if this is not a part of a much bigger plan then NAK.
> 
> Hi Michal,
> 
> The intent here is to keep generic LRU/reclaim helpers separate from
> swap-specific code paths.

OK, but why do we want this and cause a lot of code churn to achiev
that?

> The LRU helpers are shared by both file and anonymous memory, whereas
> swap.c is meant to host logic tied to swap devices and swap entries.
> Placing LRU code there would blur the boundary between general reclaim
> and swap, and make the code harder to follow.

The code is harder to follow than it could be, no questions about that.
But that alone is a rather weak argument to justify a lot of code move
that cause a lot of conflicts.

> Separately, I’ve been looking at routing zram’s swap-slot handling
> through swap-owned hooks (e.g., swap_ops / swapon probing), which would
> involve swapfile.c and swap.h. That’s likely orthogonal to this LRU
> move, but it’s driven by the same goal of clarifying the swap boundary.

Does that work benefits huge by this work?
-- 
Michal Hocko
SUSE Labs

