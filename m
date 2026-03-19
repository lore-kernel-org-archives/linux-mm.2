Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172CE1088E5C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 00:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C606B038F; Wed, 18 Mar 2026 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D866B0390; Wed, 18 Mar 2026 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053DE6B0391; Wed, 18 Mar 2026 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA4736B038F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:46:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D153160274
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:46:26 +0000 (UTC)
X-FDA: 84560971572.15.DDD1A20
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 60E6E4000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:46:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MESElTa2;
	spf=pass (imf27.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773881184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iO4zzri0RhD3F5jPjfxxyouMdHUdH65AzOyDe2G30U=;
	b=A95L19Sq5gHYgRazfgZdLomnDXBUzo+DeNIIw3un+TEkpq8GU105B9eVqRBqKbqQf4B7gv
	FdOn63RqLZXDUjFruSVLk+Fq00GmrP23kBm958tEYZUzMSCMlGTtCXyBHjE9EsBiG8y7Yo
	1UofM3ZaQdWuYgSMhIcj6QCqN0lWLDs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773881184; a=rsa-sha256;
	cv=pass;
	b=2YSgzQOaAKJDDEK9l3AUidWy19SS9O6jBcnSWYqb/6DqVBVYyipAbrgTm1tythaC8lmpVu
	RXMy6noTqXmYkqevGXXXbqI13zrsKZ6WHg2IAIokiFCdChcTUGSkzH1yjPfjQaudFoqisa
	L6n713KBwt7kClETgOfihUq6FfmW+s8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MESElTa2;
	spf=pass (imf27.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a1e29979bbso65187e87.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773881183; cv=none;
        d=google.com; s=arc-20240605;
        b=N4bilXAlRqBo8b5syZeDGtDNsW3KnZkoHRTpGLYGcrlNbZqLi0zX00DtjaJmMZo4Ka
         vO0xYTxfiAmRJ9axWK1lfTFTAYsxI0WCLmQpQdjRZxQ6tdFAvlmvM3VBuJwVA1SIwa6Y
         GND7UdJTUvzEakjt58y9JjwLaOrbiGVW0HjOklFgvucdG5HEVWsOzWhrCG0A671dHP4I
         Vg5b8NT0cxP4qhNYMP6hd9WMdm3LzykCstSXaiqdgTUqvViUCrpKbiXE6sFl22ZnanEo
         InW1tuPOzSeF4iTmA6je2lyjzGTHDrqjIKxSrC+mVExxPwzgo6w9iVMf+jUpG8gPaJbA
         oZqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5iO4zzri0RhD3F5jPjfxxyouMdHUdH65AzOyDe2G30U=;
        fh=SBuQ5C7MGUnnnYEY5oy6NGfcJI1eDn81RlKsxMyojbs=;
        b=DyeTe0U2Y1EQ9lbxpEusAFLOra+cN2TxMoPKnM3kYY/TFbf2GEtHq9JvEToNvDwPfq
         08bj1by2b6YHvCdYUe85/CdXrLHsZipjlA34CQmz/+7qGsooiIIuV74UHNGbGrtnaYVv
         yx/rezKFhQ0q5kEycJiFv1qeHACsamZOQ5/GgJ0lPK/p491QCJWk9EB5uqeXQjODeO4f
         KbbLomgdslXOCsmuJCQuobr9C3YvpdWS0lnYrqai/7FTO0AA2ZN8rTA0nsB/gEuO3vNM
         4PjQ3+j5Tm7Dw4Z5RdUNtGDC4X2wWOsfsCX2O2AZQefv2Jgd7PVgv+KHFdsygzPzan7S
         p49A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773881183; x=1774485983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iO4zzri0RhD3F5jPjfxxyouMdHUdH65AzOyDe2G30U=;
        b=MESElTa2DwVtyBXFFpU7gsTjbvASqKe+rB0/7SiAscHQ740sv45mNBDtMtAmrgmCsh
         0F4z22KWB/6JFoxKBciIA81EdIIvlhcRaLFrq1Gv1GnFrqDW8gkEBrGzIPlJci6J489A
         KgGMUWNmpqCIbnDbH5xu4eq2aZELfJznidQoKUZsCP2z5j3hAoarqEOePSALNs5NZxvp
         PPT4/6sP9fOWCp2Pu85ouwY8S9XrfYfOL8QjUUGTI/a8Q3cqgqxF59RRHgiyEbU2mgJN
         5cAD6XqhQsOPhlzms+b8/sgTEA9UCTtslcjFEeB/OxB+lGXjo3AVM7tVWjXs0pmXtPwI
         PrQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773881183; x=1774485983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5iO4zzri0RhD3F5jPjfxxyouMdHUdH65AzOyDe2G30U=;
        b=h0udz6bD5KrdPW7WdZXiOl63/uOj+Kx9ozMJAA07q/If4ugXyQ9PqAxb0QEjVOHS6J
         nt9hU5Tg1n8lyeN25/vcfj3PIe/VthT8vKWcTr6sS0Au1CgZO1LtgFenFpOpOjHEZ6pK
         V50zw785kyvUOZJHxkE/WsDnfgcxOZEYe2R6sw7D+oyCiIFtfBg75riJNr9tX/7cz5LD
         Mz4e/CDeFPzhlSpIUJS9sHJTUGmduSOGE+LUcMOb9izmNG99UlfDowzP81OeVNl+8rG9
         1hmCzwf0F00pXpSXb+LpBDTRJOm5kVDgPDJpX+AZ9U0G/sl830neN8D6TNfNjHqLbyOT
         afNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMm1/S+PsqPebRekLthBi1Qj1Hgcsr7NkwU+pmk6srUO2jffqcleaqWWXiHC/Qzu2XyMGd1HIatA==@kvack.org
X-Gm-Message-State: AOJu0YzWq80toH0S4mAbNhiZaYhLuFEeIVgfHNnKBHiyGE2Xtx6aDGn1
	1s0IYhLHh0zv+EzXIvT1qmsdtWefvTm2wrF4ryP/xMB0Oq7p63B8+8ncKy8F1d+q+v0bKmYPp22
	5v1NLex0tXP20EDXbJ81WqNhNlUh0JYg=
X-Gm-Gg: ATEYQzyFgF+JNZM2VX4/7lkvwFw9sRpB770VMT7C1i7WevfRDTh0hxjwM6k8CJbIhkm
	Tg49CPcpSi5juMZtVq8OBmaVWxwgkgL2ib6Ty8PkiKBjo7CsitjKUHIyrCIfRFnqtqO2ri11kdJ
	F/XQ6ppJxQqFqlBvTvYaIqkRjijtJYvPP4r74B+A1moVkhMI+t5DxcCvrZzTebw8AVSKJMbz3Xk
	Pxg110dmosSAaFqjdKlGf+sot0av8S/NQ76f5BiaVjZenArnMo7YZl0eu7yejP8SM+r4spdYbHt
	4ffp2jX4
X-Received: by 2002:a05:651c:3244:b0:37e:566d:7fb9 with SMTP id
 38308e7fff4ca-38bd578b396mr10044061fa.1.1773881182351; Wed, 18 Mar 2026
 17:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260318090656.1748509-1-zhaoyang.huang@unisoc.com> <abqtp8kpNpRhV2Eh@cmpxchg.org>
In-Reply-To: <abqtp8kpNpRhV2Eh@cmpxchg.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 19 Mar 2026 08:46:10 +0800
X-Gm-Features: AaiRm53B2tEjH2sJqe9TlFHnspL8xnYoapjFKtUxoYxR3fldCOdnamPhmPZT4XY
Message-ID: <CAGWkznH_+MVhAsEc5LYJrei0ZkUD+MYHUPdORKtQztC1hDhsvw@mail.gmail.com>
Subject: Re: [PATCH] mm: skip dirty file folios during isolation
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 60E6E4000C
X-Stat-Signature: j5a6prfxkob8qafmyf6gsfj63dab5yt1
X-HE-Tag: 1773881184-929468
X-HE-Meta: U2FsdGVkX1+mfSApBIq2Lz1T86uPgQMPXeVdVURb/5OUXoVAe7pEyrePPIAekHSr5CnqP+A/bbzvHHA7OJQ4T3VyWU+5uRWCyyiGIvIuZl4l9s399Y2WhbgIX3f9b3nPRV0HTcWmn8YYfAoay6BC4DFXepFrP8ViCagOxYaQClt/0/SmVNejJTBDm9BbCTDXBDk+Fv/T6AJTD7C0WHX39X+K1rsA+zwM5Z6sy+Te9QH5xrNOvgvtmmAbfnxvNCHqvBgxCssLT4U/EoicRmkvwn+6qJUnuO/LWT8CahphClm+oErSP4x+cLOS2Y05gumHIzZTiOaDDe0jr3DTXqHgbowTySdmydcWIg1hXE5RBRPj42aTiCj4pfzBB0C64EZhyyl2hVVwWujBA7qxUQayaDGorUjGHJgvrxBOEUDBkx0EsVv9tSVE6Jcf7fLCOixt0xdKSfyg2xCjI5OUPjYWpNV09lx2M1d0z6fuUZPg7XU+07dq7+uBzNjvtXsyAG2C1FJb5T6Er22IDAAeZdEtrn5dwi8nF9fEiAU27neQMoFFUeLDq+fXO8tzU09SCrsI6NsTMnGzqHWaoWsciUKlisXhAY+JmJwTxwMHIQopr9mBKvUzmMfg7PFyBXtxw8aNywSv8YWUmlnwQ6xWQ4JA3N+6iGFu5+lll44jFzB3KtV2TMtDcaO6OHNmokAokPYlFeAJsptI7GtSHBgAYnJavLZmIbeI4Bi8Ti9mWuQRD8ZIsUonHg71Z6zHr81PCAfNbcD+NsGLtACct4woZzlp9apk0xJ2G/OwLJ/tuB7dIsyyaYiqBa11vMcIXwoOmvwlKeyq9pBo6QbtQn1uRJTvyCrKpfzwe9TDB2oP179KV1AYlusneksWtIWHx8C0V0NPzcLo/qjHi5ag10gnhFqzdPbd36Yxx3eXCztL3bwvxSPKkxoRO2H5Ds39TcaTiWDyPGwHubrjLliROZidrI+
 d+UbmNVt
 a/yDGi33DGfUJhPt/UnCCnNj0cZRh3ddR8koc2fqeOeJ0U2QbHfQAejJU5PqRlArT0a9KYeShNuhHMSWLr5dCIjeZqCtA+eA6RrjSIMyBOSahRPmW7QeX0zE3NmGvIH8WwPcK/2bn40MODK1pzzFST5J1aQtxBBpd1hxDpTO+oO2+V9aKqhsIe7jcnYjXeGHPtvLR3XMDfarYcUrmU1UNZBilOKTJmXChIZV54KDIu0J1lXNeqfABOZgD3H9wM3nMhp0x1V3rmG3ipLFHQK5uwLF2RXxkQfLe7NnOPpjC1xtQy+26+gsWhvoOJKBJH/wsQWlmcyUb+nXhIhHwUBnTgwubnrAyzcYEek1QjsQubvd+KX11JoIUjP2bWLPRTvV7OyZFX9awU8Q/p+XuezqeGihmEOi7Eo9LCseUbiwipVsj3LE8kHrLHvRjzVz4L8zFKwCSZ5YTvZzfpAy/wsm3o72ovvMQd/Ve7tT4zWWNS6R1Ck73w0d3nevKDM6G+XKOzpAgepuuSiZ40S0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 9:50=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Wed, Mar 18, 2026 at 05:06:56PM +0800, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > Since dirty file folios are no longer writeout in reclaiming after
> > 'commit 84798514db50 ("mm: Remove swap_writepage() and
> > shmem_writepage()")', there is no need to isolate them from LRU which
> > could help to improve the scan efficiency.
>
> The reclaim scanner needs to sample dirty state to coordinate if early
> writeback is necessary:
>
> try_to_shrink_lruvec():
>         /*
>          * If too many file cache in the coldest generation can't be evic=
ted
>          * due to being dirty, wake up the flusher.
>          */
>         if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D sc->nr.=
file_taken)
>                 wakeup_flusher_threads(WB_REASON_VMSCAN);
Thanks for heads up. Just find out that dirty file pages have been
promoted to younger gen under MGLRU, will update the code in patchv2

