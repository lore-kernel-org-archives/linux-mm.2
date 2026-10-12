Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10CECA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70B96B008C; Mon, 12 Oct 2026 14:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21706B0095; Mon, 12 Oct 2026 14:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FDA6B009B; Mon, 12 Oct 2026 14:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE3A6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:02:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E21E0A121F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:02:37 +0000 (UTC)
X-FDA: 85314744354.15.F6CA42D
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0DB6B4000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:02:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zm9Vc6zB;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9aoCkFfSDX2/6XxSiLf6H4ohGMtImVLYKMUBsJfeiU=;
	b=S4UWZGPOwx2DmOW2KNVVz2NGce9g5IUL9u2ZbTu/eD6Yx4/a4qoj9VUHsIS6ggMx3WwPVc
	3bmsl6MT/sqJT2aHjKctSmf9xqF8kYT/lm3mh5HxieaEptvQ33Y/IhjxsIuEpMroIn7GJ+
	jNPBLN2gdpb6b97xSIggMTQHLH7tm7Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791828156;
	b=H/O1KYKVBAfatZ+RV1V3DIaSe8Q5SnCy+c7EJhLWf/btZaepEFjqXB8SFOmRh4ypuuUtPk
	5s+jLRXfMkjURUL99n5VYNn7qnJOc1UO6YpuACzVijib5d5AMO3IvqHXW2jT9lX7MKh/ix
	jYE++oykPBZ+0mUECgyeQAbRNzp7C/o=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zm9Vc6zB;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3a1f628b1d1so15410721fa.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791828154; cv=none;
        d=google.com; s=arc-20260327;
        b=ms+ncsMCUXsdLj9OdRYwVKLPLvZ3QOkyRFKPduKY/GFyK2qdOkzRGHk0QdE6RlFANC
         xOU7SEZxHqBVKcH5fhYqnjEx2hs+tw4K/JF/4LFvdI+MkUEYzQkJtnZB4aYhRfYruUYe
         sZrJSJ17ldAk9eKgKsMkwxFkvIq94U1a9kxBys70DCTymwQGdq7qQH+Jcm+4TKwAIBs6
         AZqiKiBJoANEXTsMMWH4tdNjcD51UuIRO0fJODor4dtV7g56EeyNpOj8HUZ2FouSzX9u
         /rvEllpHTy3DBIlzuDMQ5FrZWCM6vzFZLrltVc5I0TQsUFUHdGCwl+jnCSpkHaxacA7l
         40uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f9aoCkFfSDX2/6XxSiLf6H4ohGMtImVLYKMUBsJfeiU=;
        fh=7/qrlmZ9HXDez/fx5gvl0EuJ09Kl9im1NxdaCwm/wGQ=;
        b=CsW2sWGIPW0HpC+YTRdrAktxDE+IOBEBdfjR1my0I4ywIlxUCF396YfJzX7a1l7Hqe
         3MU+hMJqd2c9+KfoaFu5kmM6ovTuCElBfQUp0F/57PH7fcW2MmsWAWv4x481fhHmtx5t
         jQPrRNnFkh61YrEv76T+18T6JDipdhPUokGeevpmZGz6dFPiNQDOe1tQcVDBc6BOLoTZ
         uvTU1mmT46hCaQHE6COTvejb3bCW5MMs02Q+QuGFmq8OSm9AxYjPrwPBeNgEShsMX8SD
         FgGbTLF6dJ8KK4YEY28kxwflj5K8CNXv09ZnHBn9IruyXd46m28xMtIj6pGdWS04KeKd
         uucA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791828154; x=1792432954; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f9aoCkFfSDX2/6XxSiLf6H4ohGMtImVLYKMUBsJfeiU=;
        b=Zm9Vc6zBTm65n/9aM4jX97QtTajVzh31B7j4dWmizUU+mqebIIJ4bR8p02MW1sGYEv
         Sky2omP7rFBGckEosYyPbf0gXfs+tm2UJPA/4YquK5F0BoTpN5OBGkdWf5MCS/KamtTi
         f2R0XqIKOrJ0z8yN8z1JD/DY7lIMSlUHBe6MMQ0txbUWsuJ/UsjEiPLwq6iWpMv5jbsI
         gz4OogShVf5u/yYR7kcitp4FpXwf8lzngTkfrHZOZ6JHmzHrNX+00Il3o1R2oqn2qO3M
         joqjy9INVE5WyBG9A/bPgvm0kBTslS51Aq4b6g4ikpQQmF9yUIBAEcY1ty8Zc1Ax/4U4
         VbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791828154; x=1792432954;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f9aoCkFfSDX2/6XxSiLf6H4ohGMtImVLYKMUBsJfeiU=;
        b=WJQ/vYhBy7tjcWAvz5bQQO8U9IGGEaapNPxBP8oiD8ZjXYRcANEhaEg5NBNvjbl3J4
         11cK6ySHDiDQc8hRrBn0jn2oLHVJzhJ26ugx1mcSQwwL3rn3rDeXbFgaWMxYMX+rLs+s
         P4Y9qrO6kofD6qd0q+UyiCXHBGpSeLI8W6WnfuTVmW+SIuoiIGSv7EmvEh4vHU8nXdgt
         2RO2ToLz8uih3KQhFJZ1shlO+e5syYfgcVUS1f1iCeIJa8XYz7gZ3mOqKh1wsczzDqi3
         7TNhG3U4tjvZmd9/q/d+qUzL2S6fanqAhVA1RvXrEu5Z+aBDhJpqx8hb6tlc0V0ChB/j
         2mPw==
X-Forwarded-Encrypted: i=1; AKwUvBzLadzqw4Z5Khh6TU+R/EVysWDc97pSbynoX+1KrXAbKwRX1hsDdZE96sNIzfVTZy6OIx4fs5foKw==@kvack.org
X-Gm-Message-State: AFq9FYJazlrK2FToP6X6OGWWK/8ZpbtZXbfLCx8LldG0wSkqZdJPpq4h
	sPy0vSgm4/orTxtwIxOJ7o/SGUtOaYQa+hgszfiiYlB2PEYrCt1Aek4RS4+ifmyYgGkan4POyde
	4kGmFFDHwp7uRoYBuJ+ZhMS5dVi9sKps=
X-Gm-Gg: AYBFou3WXQoj1MKGZESGoJvzgyoFON3GZh23ZZaO02zrkkz22l2gCWeaJ8PvLk2e1cJ
	5AnwyAWSFPhwCxPf2DAwDj7GJOpUHJzVQh+ztULijl4Ke+AY2zq0NbWBn/4ciCxmjoQWuL7s8v3
	oE8C2cq/pPpLHcI6MGwM0DyNMO96T8ziU0LmxRoP2Ha5YqIgpJlAE5Xz0iK7aspe7ib+eoVLOdU
	hwFS6lUyccbDapM+LhyoahqUkn1sAWUb/Y44fLrflo151NeltaUG6/C1n//8gi9P/yN/KSRLnJb
	Z3RsnvSnpccoF1iE4w6Ex+EcqPZCaZCOyVInxNL39RmISxAFxW8QWHQ=
X-Received: by 2002:a05:651c:144c:b0:3a9:d377:f5e4 with SMTP id
 38308e7fff4ca-3a9d377fd51mr18447101fa.20.1791828154266; Mon, 12 Oct 2026
 11:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20261002090947.869220-1-jiangwen6@xiaomi.com> <20261002090947.869220-6-jiangwen6@xiaomi.com>
 <astarANeoldvqBxc@milan> <4f812ef0-ab14-48c5-908b-b7d82ce418b3@arm.com>
In-Reply-To: <4f812ef0-ab14-48c5-908b-b7d82ce418b3@arm.com>
From: Uladzislau Rezki <urezki@gmail.com>
Date: Mon, 12 Oct 2026 20:02:20 +0200
X-Gm-Features: AclHuK_uSuO89Qhd1bXs6ll2oIbh2EHyO8-k6OSdE2Rwub_69M_koNK3b1_sl9g
Message-ID: <CA+KHdyVjjk3B0gsfsx+NPeuNH+ZyN7HbiP=S0F9kspRO9ZAXAg@mail.gmail.com>
Subject: Re: [PATCH v10 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size()
 to batch multiple CONT_PTE
To: Dev Jain <dev.jain@arm.com>
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	linux-mm@kvack.org, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, 
	chleroy@kernel.org, david@kernel.org, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DB6B4000C
X-Stat-Signature: zo5ha6p4mbzdrrumgaeqzprzb8xqu9y7
X-HE-Tag: 1791828155-974046
X-HE-Meta: U2FsdGVkX1/Fi45OiySHNDY15NJiHlaZEtgbq/DuKc+3iWrytiSYFO/fN7NWNKuDtiuSh2DA1ByheuG59Z7e1mBsvfU3Oe2eTLiPU0Oc0bLfRcFTH72ZDQjs5aLa8GXdiL9T7TtM48btHb+5Jpg/ELlVr5Z6rJyQHoT2J73Dr171bEHd1cHXHcUlfVBcIzKpYqGJwVVjHXNp50pFmEhdTFgDWE9sdKng/aVXA3S9sVB8QftD/y/mnTKTRggGVFhQfImzLJOgY+T103QQRfTddKoVn3Ayh518WU7Ot8F1twDdumcV4rc31Yi5P8GW+dleIVjrZvPLDbeA4QnjEjCJuirmb06iRqJo5x4QaCLsAiIReWO1MUFUOM+zFQjrd45fKw7Zu/Q6f6urM41i9KFqrkjH0Jg9UXeN+tDRkvp7XL/VALBGmRFAx4Ikyy0AyHQn6TtmIVsxShU/CF47Y58Xs0Q8s5+UTRUsf4XPFrOTCa9RmnVuUhyxeCIKhbsyK0GF1HjmmXwRWiYkvinuJV3y7TdrUZ17dF3VrTLaBpBS2he8iWpt65i0Wz8jOkxDdjL3s1KGsyRCqfAiSTU0DUBn/0fnVeb42KLB5DBcCwVJYtky3Rgb6M5Rwr4R3UGhlVBf8KFKH4T4GI3BZ1z3O6Fl1G/3GTAMOdDZ2q5+LIuTblbmg2cjxbdeNoPeA3jPTqFoFBaR79z8Sh4tqCssmS7E9eT31kihOPfXhqGhxon6vVhOunZbyAYXOLcZBssIQhuE4S7ybLzI2hvdQAsJJtyP2QRYzdjuOvCNoj9M8llPxRouaDJXJ10OqKj89LzMmM6ZuvXud6S2UgPHv88qVIlu1OPjie/jeeDKa4hqXMNRiE53o9OqQ4fZjvljI8L6p8RxWlGM1fEIh0plVGMLMgyr6N7yz4cE41CYapCRYRDY2YeIEyBkFDfyK0CIsB/R6VluTU518sVC1xmtsHe4ih9
 IiG2+ghX
 LiWJjPbHIP0zEGtOv4r+Sp9inIkH6OlTnRjGqlvO8ImYXap7bgEX5E2aV+N7E9cdbdTWj3knJEnreYEH6TzdGz6+F7T6L9ZmR7UmEuwG+JohYlkmN8foZjxuYwymitgbYi5t5l8E4rWe4r1k55XIzyatWTLbXFkHmMdn5O4euJcQXHK1v8tTeC4bVTnk5mvtJ/nlvGrcBD1j1lUouQxOtxJZZExtpiBqhxdzcVBprPJc33CaN3Pz4EMc3J53ItQz9pVhGnqmjRl4bjzROPY7Xj0/4QjFT7igmW3/8B9kx9tq7o3HgN2AWLMDxajx8Zy6W+fgAD0cRlH8jZyKSktAD638X2VqUpN0Nv3OQMeG+TgZcqXr2WDbCUArVxQ/jR29bwU7iZvygX8+vaYYEVZzBzicnRTnlBFdWO8fMgzeexF7vaQwQWitbqlS2WWcpjlMjadIdpucSn8gN/iHY9hbk+hqgnSgoMLv+fcd0AiYKwVTQ2T/HiUq64zzO0zIsKzGksu4OKqAzZDbQhKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >>
> > This is arch/arm64 code. Can you, Jain or Ryan from ARM folk review this change?
> >
> > Thank you!
> >
>
> I will come to this soon.
>
Thank you!

-- 
Uladzislau Rezki

