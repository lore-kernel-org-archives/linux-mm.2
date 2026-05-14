Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC226CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1516B008C; Thu, 14 May 2026 05:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1614F6B0092; Thu, 14 May 2026 05:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0296E6B0093; Thu, 14 May 2026 05:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E12CF6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:35:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7081A1C0F41
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:35:07 +0000 (UTC)
X-FDA: 84765516654.04.73D7672
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D66C180006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:35:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZorsDTyX;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5BmJ+T62BckrwlUIw6kdxJ9jDEEX8iVD8QUYqwbCAA=;
	b=Wh2VEpuzqEe2hudCMGzRionuF8EyF1q/3vrFqp1MNsMEiLgYiXsca/06ByKajAUlrGFnE1
	ksJ/J1SXMeRWY6YIf7VnyV4lNATCdcRpbvCjAMUp/8eE3YVy8+DGrhKl8iEpHZZptJBQvX
	uHQhG8v2gfEFulOV9Jsy2NJInWYKy9A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778751305; a=rsa-sha256;
	cv=pass;
	b=l5eATQZ/ED8VM/lzzjbUFuFCkHZWBHpLhMjFviGN/Jtr4ewPm7T98P4QABXLbEoEUZWpKu
	RB8z8tU057c6t8mSoD1/daX5MrXcWg8Mz43AHhpvtC+W/W/P2vs4RN5yG8saMrO5rqCLRs
	qDnhNX+HWTnn8OJ4/nqhfXP+lXLM934=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZorsDTyX;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6815add87f0so2906306a12.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778751304; cv=none;
        d=google.com; s=arc-20240605;
        b=HMZ42SujAs/vLCGHnd9xNIUPuDj5pi1HK5Mdl8ZW+Yw+b38aUnlDB8WLRlpwB17vzY
         WAZfADKzZLN2g6QlfE8JDKGyhnqUxvMiD6m23ZEsfCKrh4H/mWNIO0PlJv/BFTLTJ4Sm
         /KH/GDBfUZx/mKsf4MaV6bxloaDMfCrLk4UoU1rlDmJa1S3q9QnqBz+9gspeScw3uz7h
         iQ3p509Cc33Z1lwhaEpNb1dd4ARb7NBFNnLXQUdhi6V6NaVlxywPb7BsDapjaSjkv/bE
         0min62314l1uiE483C8WXOpl35sOTsO7NOBwOXk76Jy0Y7TNt9xwDGyLtHneq2ljP/Gs
         5h4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i5BmJ+T62BckrwlUIw6kdxJ9jDEEX8iVD8QUYqwbCAA=;
        fh=GSI4Hxk9X45wY8tM7WKXO/M9KHetpu+Lq4IE7FEOTzc=;
        b=abbxQx0IpVAYScvzumSyscd66zx9TuYGsSm9slK+ML8rOHINfxrPoC4IdGOk9E1ekb
         916pi3caEMSUr6b2h1YE0VaODp2nr2VYZaJuwWE+C8e1KnW0xMdHT8u0ZTXb4r5A2DN0
         RTxphjqzOIk9G8XH5SFQnElLhB5KnI8R5EJ9+gysdLHGQndEm/FZS6p6cdMgrGb9Von9
         lC+e1xOzsYdt6Kw6VRoyerZcMA0HC/HHpuu9Rm/vSz/5hmrrx19VCkJpnnXDrWItPZzj
         eY+SqTwfiJ9SfFPrP8+eGnJ+hETsRlCpgok+qDWHNnByDoaZotUPrL8C8UbMTFDoO6sf
         bfvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751304; x=1779356104; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5BmJ+T62BckrwlUIw6kdxJ9jDEEX8iVD8QUYqwbCAA=;
        b=ZorsDTyXTiSNedo/MSyNAr5QyZCfjTJyUUKEFzJcePb5/6oE1sLybOJ3LEQX6g8iwP
         Riw0cIvK8aGnVZMK8zD720eyQtdlelMzPsARdKrvYpQRaCPa/MjGQVum4459eW6wDjnv
         wVUczWzQhWDgIqORueg9Zh+vCMrEknxWNlAqlVGY7hxtBOXZlBjRasvDjCo7y19iSTur
         F7qVHCI4q6k6+PhKp6I8V9TsFz7IbdzRf2cYw0A6V98yLYh85411VAj4Awl5bGh2T8ag
         jXmfPtkGs+6CpFuUfjRfC8CQOi6jz+ym+UGnTNnvbS7kBfBZ+7vVWLpEVlg7QP8lPyDJ
         CPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751304; x=1779356104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i5BmJ+T62BckrwlUIw6kdxJ9jDEEX8iVD8QUYqwbCAA=;
        b=KHxZEZEv/4MRr1eS1UI8cZ/7xYjMRroG8QwRFoJ3Yo+Gh0gzfPYLb0DV6AP7dZW4oE
         yTrh1oPCnOGZrkgNlaPwoasKRf8FkA1gXwhmke9wVBX1ip+6/EjDB5YE1i43naqeCjBm
         K26hOLwna1YJrH2o85N3+8ax3VzEZJNhZ8AmPKBO7dJdSCP7pcdIQUPvBbbImJY1xkEY
         cRAbH4BKlS3STGpdEubb8IzTC0/pelXis5CH7RSMPhDZAtfr522+X61F48PlOJrabdPb
         mGNkOsgPm2FcxP22IwK/zaCQbIbf+IihIwO+L+DNHMt5MPdo9URk3pUp5Kr5NnByCwFN
         Yg6A==
X-Gm-Message-State: AOJu0YybhF3Y+Rad9C3DI5h2eRW4Gh4qwHF7zKnEirplpo8aI14AnQuo
	E2fyAIPuTLlAMk5rlmhlKfWk3nQESFmzBDwRfcCblbQDaKPoBuy99t8OoxPC+A06ucMj+5vp22g
	1mk1xuFyfkG/y+34ALAZNfgKkl2Qifdw=
X-Gm-Gg: Acq92OFvL5MfQ5kCTm3mCAIH/WUbsCcePnrn4OxOgRm1zcZYf6h1KcaJNlPTrQzH2M7
	avhL1N5o8ssomBg7IyT7AhZrTc2I6DxjvJqU6j64oUABq1qi654RAQqVpMunABT3dvkPo1K8n55
	yxnUd7TQsFTWVPmP97mk5Hlk+OlXv3er+XTRNkOwJ9f7kMULJVDslRQwnyJCKHi+Z/G1Q0A/sCy
	Gcc+8GFvxzvAuBfpACXIJeXlgS7DEMdArOk9xc0oIYaMCMjzCOj1+5oZxJ2hr8ATbTIQITaPVCz
	hkb7vwDsYtyRBVXpj0GgeaLxELm/qas26/Xo98e2Brtxmw5320c=
X-Received: by 2002:aa7:c90b:0:b0:670:8b48:182a with SMTP id
 4fb4d7f45d1cf-682557f3d7emr3014379a12.4.1778751303585; Thu, 14 May 2026
 02:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-12-2f23759a76bc@tencent.com> <agTCeEuMWJtYN9EF@yjaykim-PowerEdge-T330>
In-Reply-To: <agTCeEuMWJtYN9EF@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 14 May 2026 17:34:25 +0800
X-Gm-Features: AVHnY4LfpJtn3nb4Q3bvJ0QT35TkmRaTVD9SQDjzyukUZncbdo_xdbm0-W9qMTU
Message-ID: <CAMgjq7DjQug9JNsu2dkUoGNMn4gAurhHGTxnHfYXNjprWYxdCw@mail.gmail.com>
Subject: Re: [PATCH v3 12/12] mm, swap: merge zeromap into swap table
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D66C180006
X-Stat-Signature: rzm7tsct9tf86s5jycfz6urz7fceacwb
X-Rspam-User: 
X-HE-Tag: 1778751305-838183
X-HE-Meta: U2FsdGVkX1/apSwxDNdJT5ZBJKn1WvCUGyhvYeWFRPb/aVPXGY7/bQUnBLV0wpa7Pn0xWCglDeO+3J+7w3/S/ypkhRCdps3Yti+5fBNgEr+91V3nma4/d2rFMsySmut2883fOOyyWZ4+qQf0sTDjx5+ekFWrNKTQn30DFZvnJ7FoSR77vJFDlVapAoM/hfjPki/tlZMXKUWMkxrhm0URppyaDDijsomcaKQUauKn1349V8MXUzJvV/75GkvsnIXH77+dxSBkoOBD/IEmzNBw7NQoKgj34v8aX5ZuzNH5pjZe4IxvZDC1OhpWL+4DPtFrdMERKOMezlXS4ZqGkNUlJEBPQPAJHv6qXGGCJr2E4Zi2lpE1k6yhGAFab3VeMX/RIumRAkofSHkA+EG/CJJI3+0rpkjYZSZOlaqF8kKStCthUnJnm4DGFtaFvh7llOKQOQehoSVtc/atx+OhnLWbVshQBJ9Ejz6iyJpL6LRgw+0T6gojtA3suGB1Mo+g1TSvaZwHFSb7lAFGnhmOgJgAu1cjIx0D3sGM6/Qh66FVvJ/UEeuD/3EC45lxEBEY1VQjtHQEGkB3sjPog1UaLBdzV/NUngt8nAiOY0YC7VJIXN+ETtsrrET/++7yZNx8YPj7fds5tZM4519h/jEnoTzHngx/CQDjQYJq/klp7o2a3Lg7wYenpoQQ+A+92quFCPy6/s3JD6WepTXJGQLoqmb8vnz081puP/oYiGF27O/6qnpl9nV27wGOj98zWGNGexb0rm1D1wQwZTojW6u7SgxQqlkqaWph074yPcHHq6EbzjlXt3i5lmZTLIJNuuHvRMJ01cooG65AsCGzgnvEo/Z4mLD6gB3jsQ1pBZniNjrgbQYyQaehIEleY7CIPfs0kZWlyVxZL3Vda6/35dc9KMbtoQC40gS9A8iuTiwYrhEoaPUOZBnYOFnI1grLCZPPEJ71Qm4HPUxo4a2Ak2WoVTa
 lglajnpE
 zwptp44wOroJ5asLgDvG9n1tdupaC/j9ALMqVETNDINcfLYvTLHQQWJ3hJ+wx06bkkJB/6SIe7LYCQw5wY2iTCoUeNFL83drb5kEE0t5rIZ7wp3DD7EHsWIODpnHPlcyMwMo+sNvdEbzcpAw6rSPXm7YvsXjDZvnasR4fjtu5URn4BFHkmrq48aB+ekgXCEr0JghDY+CuU2jQLiUCWUbhuawV+lFzGmCEcmW9/zhKK+I3Dn0XKYFAgu5Bo2jkMyk07jLSAlbodINJ2rp1N1mx80NEKBUFz4Q7qUK/TXZCizve2UFIprsJlPjOvbJtM7cBY+NYVSoe5v3Mnx76jWvANd1pF74boesqWZ2jYU5ZsXspsPkHhFSgFtXpSEn8NkfEq9oxbG+SM/B71cmwJ7AgWt5R6rlpZe+47VOMrNEpyLYW7+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 2:33=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Tue, Apr 21, 2026 at 02:16:56PM +0800, Kairui Song via B4 Relay wrote:
>
> Nice! LGTM
>
> Reviewed-by: Youngjun Park <youngjun.park@lge.com>
>
> A few nitpicks follow. take them if you find them useful. :)

Thanks!

>
> > +static inline void __swap_table_clear_zero(struct swap_cluster_info *c=
i,
> > +                                        unsigned int ci_off)
> > +{
> > +
>
> trailing blank line.
>
> > +#if SWAP_TABLE_HAS_ZEROFLAG
> > +     unsigned long swp_tb =3D __swap_table_get(ci, ci_off);
> > +
> > +     VM_WARN_ON(!swp_tb_is_countable(swp_tb));
> > +     swp_tb &=3D ~SWP_TB_ZERO_FLAG;
> > +     __swap_table_set(ci, ci_off, swp_tb);
> > +#else
> > +     lockdep_assert_held(&ci->lock);
> > +     __clear_bit(ci_off, ci->zero_bitmap);
> > +#endif
> > +}
> ...
> > +
> >       table =3D (struct swap_table *)rcu_access_pointer(ci->table);
> >       if (!table)
> >               return;
> > @@ -470,6 +475,13 @@ static int swap_cluster_alloc_table(struct swap_cl=
uster_info *ci, gfp_t gfp)
> >       if (!ci->memcg_table)
> >               ret =3D -ENOMEM;
> >  #endif
> > +
> > +#if !SWAP_TABLE_HAS_ZEROFLAG
> > +     ci->zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> > +     if (!ci->zero_bitmap)
> > +             ret =3D -ENOMEM;
> > +#endif
> > +
>
> memcg_table above uses `if (!ci->memcg_table)` before
> kzalloc, but ci->zero_bitmap is assigned unconditionally.  Both
> are NULL on entry today (swap_cluster_free_table nullifies them),
> so either form works but the asymmetry reads oddly.  Either
> drop the memcg guard (with an entry VM_WARN_ON asserting both
> NULL by design), or mirror the guard here.

Good idea. Let me turn them into VM_WARN_ON. They should never be
non-NULL right now, and proceeding after a WARN shouldn't be
catastrophic.

I also notice I better let them do something like goto err_free on the
failure case, where err_free aborts early and frees everything. If any
allocation fails, the entire cluster should be freed for cleanliness
instead of proceeding. I will update this part.

