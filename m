Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2ABC982F0
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F3C6B0088; Mon, 21 Sep 2026 16:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7304E6B008A; Mon, 21 Sep 2026 16:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F656B008C; Mon, 21 Sep 2026 16:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37AA86B0088
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:34:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF7D9A02A3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:34:00 +0000 (UTC)
X-FDA: 85238921040.24.CA092E3
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFC7340007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:33:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mE0AflkS;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790022838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8pKhaAmdHE4EQl/ul08KWVls1Kd2eQeZ+aeVuZNGSQ=;
	b=sD9Hbmb/zRHq+xZDn3vliLQ3El1+wazc4Lhc2QE5HbrVK5NKFVxyoUhHmqONLYm/UTSiqI
	OvFhJz/+KOgubv+v1meDY2aXcko6iJl6OZnMqza/NJif1Q5wNAHIAhBvim4CH2Eu7s2MUK
	qynaOwgJQYGg1AdgMevkI7tZcJZHDKM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mE0AflkS;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790022838;
	b=ENRErZzAQlzQNOSizaGsIQ6Kv/qQgU8svq4sbbeBOvnlEXe6u/4uA4Z17ld7askImw0a5f
	uvbKOWJgY3/Ieml/feIc4Dv7vAUiBhCD7LcmPynC+upvkyW498uQr20MQZcCRon2jrCDgC
	pjQ+ZkCkJxXfQcjClEazjk3i0HJYyOg=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6351832so1763907f8f.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790022837; cv=none;
        d=google.com; s=arc-20260327;
        b=eGkIfwy34DDgrIyrjYNjcarr2k/ULG3x5gIKgNuR8Yr028LFmsWCvfoZqolDDopOSj
         6tdMkjCjy9pU4kTVNrGw8jsj3Mt0iVpnBsZSg73GCCgMNvcl0N6jpTeJSHv7uG1bg9fA
         kDZRd92StBLNJNHXVhIGQ5L4gNbp5fz4/Iujk/0UUMIwmCNxt/4hOBVplyYOnMkgXEw2
         54OjU6uv9kgLnpCKCoi5Ji1vTEu0LYV3afmnlyAzTNOFKIB7J2+2cEDGzLQM+HdIz8ER
         QqNIDx7GLXWDbG8yqFhIiVaN2aw6rEIRzOqKaH86GMjh2rN8hTZugTa+2K4tAk/y9Oz1
         T+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R8pKhaAmdHE4EQl/ul08KWVls1Kd2eQeZ+aeVuZNGSQ=;
        fh=7BdYsprLnfehajo3y2x+Y0o3nh7Gdmt2VKaPuJbNOr0=;
        b=VhBaYFrJntQF7qHFCmbavtaDpvP4KXn0XzAjZ4+bFlwWl6LMetCXoeJG23ViGYTLLe
         kqxVBpJ2rZj8IteGJZVs9o4i6RghJiVRqmTtaEcyCJDYjiVOgpqp/uWe9q23eKSqopWb
         rd397V49ctf7RTdlxgHweY/E+ubMcFgYq1S0R/uqj1Qk0RP0N9WdHyPNyKDHsCKxwXLA
         oXZJScSUwvtZeQWD/OWh8OqyEiRjnbcm9WXHTuwBcjFOnIDjUO33E1y6vFTnPk8Ynhi9
         6f3mdCh2Ynz62OwpVQHY1An46g4AhoMW85ZTD8mlV3YTsXXijfPb+FyCmoTF60h8Nhew
         zmZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790022837; x=1790627637; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R8pKhaAmdHE4EQl/ul08KWVls1Kd2eQeZ+aeVuZNGSQ=;
        b=mE0AflkSqUYpeqXZKyIjWDRJmHvLUINCtZFnCEbmLzQ3clbstb+VaVszPfQDGmj4oU
         CZAElDOepNSkx7AHr6ZzhSKe4uyfrqj9LfbRa/hhjafhIEIGHZcKeQXz/8jekKCLIGAF
         kppbi+2UDe3opsKN/AAGuvqajaF0VeWkrgXxJMwGvR0q9WKO5mIUBwWnt3l5iF1YPnrq
         mmJBMDigYoOzP5yAGXybXxXtGxsKK/vafDHEHXU6Q69xIEMPtOTMiiLbmLRh6iXBrk7h
         Vk3a1KU0L3TXnVNA9VChg0YULMuvmujpdDrfNwlVqeX9+39WQlr3bBnrjZWlXPDx5Jdh
         4/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790022837; x=1790627637;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R8pKhaAmdHE4EQl/ul08KWVls1Kd2eQeZ+aeVuZNGSQ=;
        b=EjcPR6QMokZp3Dpt4IMooh606bV8fSFOP7gR86jPsCLB/0vaDP4eRyWnSZe9QVkR32
         mvVZDUun+nl8AqFQsQaMfVQYapwbDYrQGIZad2JSsq5YykRp+dKxizJHBUknEBNIUrdY
         dvK6IhVnK05VUdmFVKGDOuuHA7hDRX5F1Fsagnl6Md9reENLTqeWSu9Z1Xt51bc+Vv83
         qF0q/AlLDhFWb+e+uGiZ6qmr4Epq/WjTZmOWGVSBtdvSV66Je6fnxr/UDRNYfV2+cAye
         eb2umIYRK448YreKydY5vwAD/qMsQO92e06jmF/AsdiifmHt2Zw/nsKwn+zY+LcWkIqQ
         HIoA==
X-Forwarded-Encrypted: i=1; AKwUvBztySZ8IlU97e3P1+Ha+W31fakNmGgjt+dC5lWOgfYD4gpICSN+5FPjkGq8JuBZBwfyyJ2y9w3ymw==@kvack.org
X-Gm-Message-State: AFuF++lU+8JeA2bGr+28MQu7JoZ9bK4itdl8i1v4ql03oQU80qh4TiHX
	wkEtESFYSQtyNPen0fmUZ4bEx727oBG1ohBrPvWpXTgYtwxXIgjmSSoTqArrZ1bYHj580Ak/Ehq
	QmdqmVNvPutvGqugd0KtO70CxdalPzGg=
X-Gm-Gg: AYBFou1ZWdHFYqasmxYzPpSaEjcMWCTMqK5OERUcunSS3MDZqu9D+iDGgJ2ewiyekj3
	oTigVn94JTCIwih1G4REMkr0jIObZdhXAAPu7v0tX5HmP4QrpIPX0h4G2ZF0GqzuTX+uEs7VLox
	kqZfnBevU0ykDIGndRZP3zTZNKXDL9w+mtDCmKOT9gdYt/3K8+exDx9ZiJnYhZWSbO/i/mHSKjY
	c6GOolI819cEWXlD/enntlaY6QGaP7pgaT8cMLe2BJx+xoFIQuBlD/fhavtLknoxSh1oU6eP9fY
	hHFO44ApTNjL5mURC+LvFyY3LjJH91dpxS7WbnkXNOVdueovTGS8Z4pOsZGvOo39p2Ezyq0Q/FF
	dd7Nuu68UbF3eLQcXz1pojLcdGbrj1euEhN7fvfwDqkv3RCI21Uga
X-Received: by 2002:a05:6000:186b:b0:487:faa:b1e0 with SMTP id
 ffacd0b85a97d-4871e212ab2mr18043400f8f.12.1790022837143; Mon, 21 Sep 2026
 13:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com> <46914256-508a-4737-86b9-a43be7e628a7@kernel.org>
In-Reply-To: <46914256-508a-4737-86b9-a43be7e628a7@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 21 Sep 2026 13:33:45 -0700
X-Gm-Features: AcwNN1U0WGniUnRa1OP3Xbqff0XMbrxPtpax-fajL_uQ1U5O2wDkoFOiUP-LrqY
Message-ID: <CAJnrk1aMitdNO8kDgMF2tAE_1N_sc1JsuhOTqqiWrHxue61bPw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev, 
	hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFC7340007
X-Stat-Signature: 6jnaui4rtgrudenodjauaempmq74dfq1
X-Rspam-User: 
X-HE-Tag: 1790022838-63843
X-HE-Meta: U2FsdGVkX1+QifJh3Zla/zEx/m6R68gA75CEJdDLav9N+FwCoWd5ZkBEzthkEuVkv399qOqBOoY0FmX8go07+iImN/YXcVHgIGABYQmdC9yZh9fTJD83TOi53tBFem+6GAc+PKcuyQuZ/PtAYW/BPH3O1oU9ieN2tJ7bEYf3D7iANk63p4TVWka/pa++rUW8kvZZ18rIMFBe5SP+KlxhWxomyJg38V3ROrgpjJSv1Ew6Afv45U32nALErA9YwiHFkVHkDmfYXqTI2bqqIFh1VQXqzBcKcMStC4McLtESNM0zNHmghBo8/Jdr3rH3t3kqchCGK/ivo+UIb8ctLTTSx/ap6TnR6K4kzAz4hModHNZ+ZiHDIIStPI+5kkw8nXtWR4uxRsavyIQwU4iFXol1i28d6QiaR/pAb3V3aHQ0l1OxyQMYUpr8KLStWzefAF2YtE/y7Fb07JPLJSRdo6rz0FgA43PxLQ/KeJeSMLvtIxjHvVUCIQmlT9S7bY+50/sMcE7ZqIVGJm0QxRaPX4YuQe0CIpl8OO9Bsf7sz59jOFwAQgFgC8HDKsfAvU2TlJGlOMfiBtPp/kW1zKedkDksXnBICmx6lPi0nBzGljjZ3SGZSE6Oz5OhpjXwKrYCA7T+6jsWOxatrGvMrNTvyrTRuA1veJYkTDJnVkKYJFBRySzuiairZMfcPrUC6vlPu02T5xtDovHbFETTs3xs7bkPaN6EF3OQcEbHOi2BCmFdHnLQk1agITWD6t/mA7fxN9e0ODy0vZZji49QT929GnCKTguiQ9tnfkQOX+AFX8+IJ4pmnqgB3r4cvoOq3e2h1M+LgVOZi2/LDCQY/y9yvP2IqzZ7PRgsVlB921RDK1q6QyH5eRRvbOGhZ6weN7D/gT9uqll/DcYyk1523vV45b42UnKhG8XxtaczK7HvhWm8VIqw8vv6/jyHN4e0oq8Ab1uFoM9Y7IaaarrGiDiD/m2
 xwQBYutb
 BzjzmcR/Fj6U22b4tlktxQaA0tjUFkU0yuv3cLBctvAadFdKnjCzh5Do8UJR997V68Bcf4YI8f6Janf/g3TsqS2v10rFTVBKeK2JnzhwyMm3j27tbU3DeLa76d/XVdyw8IBt8uTUaSk/BdcmYtwUN0sJ11EMwMTsCfI/TdAtM7VNZ7qSYwCc5u08Rl86x84ti2Vea7Lvu0W+1ZnuNKeznqmbmK1NcVjhYplHDNuqyU85OaUbfXXlHSm4CQSiwGJiZ5s+UDlV+uJkuBoHFLjccpULONKRSUlqObyxOTjxnqbhTnGoquBMJNfOPQ4o2qotkUx49oKtwfd1bby+YTPpznH49iYeILOs54HcCDE0bc//+jwz9Dfw2kwEg9tO4UpAq8wODxIKmNcDKjD2z2nf/mQjf/N0ryllfdsdVgEnxoZ7EPVW8iTw0LPV984jv/fTrctXEpoZpgeacfJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 3:23=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/17/26 00:44, Joanne Koong wrote:
> > PMD-sized THPs that are mostly zero-filled are reclaimed under memory
> > pressure by the deferred split shrinker, but this is not done for mTHP
> > folios. At Meta we would like to deploy 2M THP=3Dalways on arm64 with 6=
4k
> > base pages, as 2M provides the contpte benefits while the PMD size ther=
e
> > (512M) is too big to use. However, 2M THP=3Dalways causes memory regres=
sions
> > unless the unused portions of those folios can be broken down and
> > reclaimed.
> >
> > v1 did two things. It scaled khugepaged_max_ptes_none down per folio or=
der and
> > it queued every anonymous mTHP folio. David objected to the scaling sin=
ce
> > collapse had already rejected proportional scaling as either letting th=
e memory
> > footprint creep or being confusing to reason about. David and Barry sep=
arately
> > objected to the queuing, which adds list_lru lock contention on every a=
nonymous
> > fault, and hurts lower-order use cases such as Android's order-2-only
> > configuration. Johannes suggested keeping khugepaged_max_ptes_none abso=
lute and
> > simply not queuing folios that could never exceed it, which addresses b=
oth.
> >
> > Read as an absolute count, khugepaged_max_ptes_none also implies the
> > smallest folio that takes part in underused splitting. A 2M folio on 64=
k
> > base pages is 32 pages, so the knob has to be set below 32 for those to
> > be queued at all, and any folio with no more pages than the value stays=
 off
> > the queue entirely.
> >
> > Patch 1 makes thp_underused() folio-size aware. Today it only ever sees
> > PMD-sized folios, so it assumes HPAGE_PMD_NR pages throughout. Patch 3
> > breaks that assumption, so patch 1 generalizes it first. No functional
> > changes are introduced.
> >
> > Patch 2 keeps folios that can never be found underused off the deferred
> > split queue, as suggested by Johannes. This changes/optimizes existing
> > behavior. With the default khugepaged/max_ptes_none, PMD folios are que=
ued
> > today and then dropped again by the first scan without ever having been
> > splittable. After this patch they are not queued at all.
>
> I think we discussed queuing folios once the value changes and you would
> actually be able to split some. Was there a good reason why that idea was=
 dropped?
>

Hi David,

I have a paragraph about this in the commit message of patch 2:

"Please note that the queue has always been best-effort. A folio that was
queued before khugepaged/max_ptes_none is lowered gets dropped from the
queue by the first scan that finds it's not underused, so changing the
sysctl has never retroactively applied to folios that were already
scanned. Requeueing eligible folios when the sysctl changes will be
addressed in a separate patch."

I will be sending out the change for this as its own separate patch.

Thanks,
Joanne

