Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB5ED68BD8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C20A6B0088; Wed, 17 Dec 2025 22:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4704A6B008A; Wed, 17 Dec 2025 22:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351E96B0092; Wed, 17 Dec 2025 22:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 262866B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:41:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF4AC140CAF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:41:29 +0000 (UTC)
X-FDA: 84231191898.12.F9F3EBB
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id E44071C0012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:41:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hz0k00js;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766029288; a=rsa-sha256;
	cv=none;
	b=fR1ph4DM/+IVA8HTz1erBuGHpvDR0l3ciJv7vnhESr9ijjK6TirqMxoXCsvStojsX1tp4A
	N+09r40RAaS08dRXy1eO923qDjRcb6E7HM3D2I1YCHc4CwVgDqc0Syg5a0eh7KYMPlF5Wj
	PXj/tgdAZdZKjTasPK3wQOcgB3RpCMc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hz0k00js;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766029288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvcKXPYXyvoHgrXRz9J7bkI2dFcPOhF4/4vzRDeSzVY=;
	b=agMhUbRHOqYgErDiA8PXMIxmmYb2X2NCawv/N2fra4FZYrC4IrPVLkbTv0OqqoQzPd+SXt
	ufnnWGGgUppM9HdRnLN4MkamIv+1DCDwWxnyNX+ggvdCmbEA5IKg8fdoWein85acQFsRiH
	sg5oE8Y5ijO25JkRR6XZMcHqUf67exU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-649784c8967so159946a12.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766029286; x=1766634086; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvcKXPYXyvoHgrXRz9J7bkI2dFcPOhF4/4vzRDeSzVY=;
        b=Hz0k00jsqujOoYKVlvmg10atJdVDXoGKXgk/KCdIHM2RiXUnuXqKbDw1R6+Vy0IFc8
         G2i1zwg4NZxrKrSkEc/ONwYaQK+OJUJy/ZCfY1whPR7xEOecBbIEQ6VuuwvO77HSLUbr
         2NcW1HdSpBEC2ydQIXzbUnGf2gQAlMYs43SszND1SVCwikt5E65zo/I1929PSbXMMA/E
         VLNCnDeumWC7NyEeCHiSDg39eM+SA8MHFUhBZbj784qXIYL3+mn0Y4PTmLGR4DZYw4yy
         Zbr0bKHDGAfIoP5+VzC1h6/jQ7nQEbUBYosoGke8IFnHkB01T7N7WnDJCVHSKFmL0jpf
         3sLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766029286; x=1766634086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SvcKXPYXyvoHgrXRz9J7bkI2dFcPOhF4/4vzRDeSzVY=;
        b=Jjg4c6MUfyUhGCQ/WZWDJOSPwZy+j7A5XIANfwG88FFEIctgiybdM8T4K0iid8RVM7
         Uh4G2bMUOlvbbPDz2cc7UDyUruWZRWzC5H8bTDImHF2S6yiae26T+LBCKcSOaW/tkqe0
         V8JAmpVu0wv+DJr/KnQaAjDoF26aRf4v8fcqEPdEGHl8oTi3/7BWKIueKkqUJLtqlr5s
         6ZClA09aWc0Rfrqm1uin65EUSMksR2w7YXMlNpLQhHPmTq82jVoguD+wOjO5Y7fuyJpZ
         sP24a4NJrb6RmU0LT2MTaUvWrBIkAhUFnCLJAucq2ALT0Uz6ZVDGggYE+rNmkpsW992q
         l30g==
X-Gm-Message-State: AOJu0YyiXfXnO4OfDbhNmMGAH76z1+H0GDGSbkFOz6FYdPONBLn5aJ0e
	DJ4tkRfUXq2zGtdj0Gtsf23nIBv7hdbgxOLCVv+bzqPF628+ggDwqC5qDi0MBlGlI/uNKsbJRtp
	ZaxpLWN7H5WXf7LcR2ACIjfRhYdqnYGc=
X-Gm-Gg: AY/fxX7Ce2EvGidcXLkhroTx9swoeNuCRgpD3qxZJ6I6sCvdAKZILADZv8m0Njv3HcM
	1ERDCA5CuPmmApwFkPMDPMbM5+wguhyOkQAX2hQHqfjWTzelg4gR8yg/4uQ2u9En0DerRPArlnS
	CocUX49ID10GUnXb654vJ9pEgXr3W4zQZXqUWDfyJ7/S4ZPOWiyygT85zN4RhVv7B80Cy6RM3qO
	k3AvPw70NhamxB4GaEiSmNIOiHWzsSPeoQgRD/iGqgTaqmhDOZxRfRVq8IH8nRNHYPiyFPRQow2
	hTVZDl/SrrCT0QRT/0EMmI0EFPE=
X-Google-Smtp-Source: AGHT+IGSdkZg81W3TpEHIBPO/y+Matoj/knKeAvayBQN1jUo2FSd5GzAUUfi9gX4864ik2eakwACxB0NB6hpUcaRtW8=
X-Received: by 2002:a17:906:4fc8:b0:b73:54d8:7bc8 with SMTP id
 a640c23a62f3a-b7d23c45d1fmr2119316566b.59.1766029286000; Wed, 17 Dec 2025
 19:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-12-cb7e28a26a40@tencent.com> <aUN1ou9otdqjSRls@MiWiFi-R3L-srv>
In-Reply-To: <aUN1ou9otdqjSRls@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 18 Dec 2025 11:40:49 +0800
X-Gm-Features: AQt7F2pTdf4bMWfl7ViW9A4okDOqg6cPFLcg7XBCD4ytF0YutMXopXD6jT2hk9s
Message-ID: <CAMgjq7Ci7uEMp_UwzaucoHL_xDi2bSPOUk0vcEBLN7S78Lo9Mw@mail.gmail.com>
Subject: Re: [PATCH v4 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E44071C0012
X-Rspamd-Server: rspam10
X-Stat-Signature: e6bhmyxpumd9c9uetfahghxhfc4dsa7m
X-HE-Tag: 1766029287-291825
X-HE-Meta: U2FsdGVkX1+om8cuv7RWE1YzG5nMMdpLHC990LEvbTGyanO5L7YPyF2ApulfjPivJaJY3Qrt/61J6MQpZ3daSFjNtSLKx+mB+rR0uG/ZIs+kfsu1BbCNwkGbbXJanZEedtt4yhfBiZqHgCU/5WfzXrCebcdQArL8vzScs9Yj7uABKjo2SZetyfc857XHLUIlPmpMNFXB6Dx17LzBcHl4ejJ04BqDPfU9J/WUzu8AQzSKM7JUdWdTS8ClkDbE5kSy2gsBxca1s7KjdxBCeDwc4u/NeMHwRMmqpottBH203hQjnZSRxvkeIDUDaj23Pk1QBonLITT9dxWkfCe+2IpL48ieiOtRz0OomsEHbj2sEqqrztz5x2MNFGHGXpRqsjNHW7fVQ/9atg+84zDlAQvLPLW44fahGbeUvTEVKyi0C1AiFmvahaBJqLixm3tqHNvZBAxPFO22F+ZNgZb7FvUGuNVCxBKgUngOAg2QQGpUS5X19q80s2I/e+xaurFr3X4o/VmH6i4QKG39B9AozWGCdR8rfSFXOKTSPdqtCojeudu7Viyx5w/FW/TRoC/USvNEzGJJFFqq12EUbF0FikEasUZrOODMi+1MR1e0KHqKOFClTFgtvZ5shdHTVg3d7kxRB7kV1n/lKtIWoDo/3sQRpbVqO5PB0JszxhsvKy5XPIYQslfq2N8kznvQLBtv+BV/IxXufuUWPussW2FF1EW/TnslzIMzJQx/t0HBwxlBA+dCtJU5m94/zJG6gURwqWLToB5xmIl4gpsOicWUnEl3EtkiGRfS8eAqru9DjH1c+2R8o5to7539pP9KXR8lihwVOr3k0eP1/GGheHTVBMvjNwq0ns299E8i/1ZvLy1TU+hGq6UzpaGg/cfK40kq02H+wGXYVEDJxqmV+fkAJ5kP9OX02txe2AY+Osi6aiCoupf0yR3LKAbTmc0Du3o/gwDsIXrRhtT580TLT+vMo4W
 siiBe+A0
 h8tvHu77Q/ek+0zPu0swvnsBsu6lStp948BPFl89zq52n2ZFhSlM5aDbFp3CoW3+yTXE8eWMpUS0k5H75kjljtknIA+2GfzDFapGunP68nHPfI05R65ArBDLoi/ObfP7jBH+bp/CWvc6MQpjxTMje7oDSSZb+rrNM07j3YzEy3bUj/KVmXA0lVwbCDqO85rjRDi7wF9ZVyDw4DCWgIMVX1Cy+sOvDwsqCsbAeDaR/dlzoCDaRJbLADICFI2FGH+5jFpVKN2Uax8uxpWzuGuCyLkaB9gi8Lg7WTmrLzvdIzEoH7rdsuJM2ZbJ4wuS56hvqARVuoScZJQIa687Vzbl+qD/47IvnPT3inklxOjpR9QhJDUiQAKIZuXHcd5Ek11JsYgnGYG2ggoSk4GkZRZADOCu4/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 11:32=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/05/25 at 03:29am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Current swap in synchronization mostly uses the swap_map's
> > SWAP_HAS_CACHE bit. Whoever sets the bit first does the actual
> > work to swap in a folio.
> >
> > This has been causing many issues as it's just a poor implementation
> > of a bit lock. Raced users have no idea what is pinning a slot, so
> > it has to loop with a schedule_timeout_uninterruptible(1), which is
> > ugly and causes long-tailing or other performance issues. Besides,
> > the abuse of SWAP_HAS_CACHE has been causing many other troubles for
> > synchronization or maintenance.
> >
> > This is the first step to remove this bit completely.
> >
> > We have just removed all swap in paths that bypass the swap cache, and
>
> I think we didn't remove swap in paths that bypss the swap cache, we
> just add folio to swap cache in those swap in paths where swap cache is
> bypassed.
>

Hmm, that sounds exactly like we removed the "swap cache bypass" thing :)

Anyway I can change the word here to make it read better.

