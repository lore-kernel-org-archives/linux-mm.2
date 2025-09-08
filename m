Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D60CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 21:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB368E0002; Mon,  8 Sep 2025 17:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054988E0001; Mon,  8 Sep 2025 17:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E098E0002; Mon,  8 Sep 2025 17:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDD1A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:47:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DBBC13A82D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:47:35 +0000 (UTC)
X-FDA: 83867420070.13.20C367F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71C9FC000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:47:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ydu8buzd;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757368053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BLaFovz61dlh7ow4ijqIn2/yM4F9mqJ6CyX42AuzX4=;
	b=UsSLwg8myUEF59oQ5YfgflokOHlti0/UvZ7pmHByFCqqnl3rU9K2OWxDvb9+5aj3L1e0Bn
	CbACjoB9WuH97+2GLyzPG/ecFYtHP6RHLzLfV7XeVjsPhXvZp2K0TL9P8zhA2yxBaVfICt
	iCErokKDXjtvp3tOaKrJqDnCy7zdpSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757368053; a=rsa-sha256;
	cv=none;
	b=iyJM3p2V9TbBpwEaO2wfy2cBZGvH158V6wYxekdm+LGE7ssByFdY04GS1P/gaYE3h9G0Ah
	nJOgxLrxJOF/lB0zj0qEM+yY934z03lp+oYFc9B/XfPLtZBeaz0Ie8CtbTVvONh1ar+qyD
	abQzKjRMrG3MQ4p+Uadxz2ebwLR4+VM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ydu8buzd;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b340966720so33052331cf.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 14:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757368052; x=1757972852; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BLaFovz61dlh7ow4ijqIn2/yM4F9mqJ6CyX42AuzX4=;
        b=Ydu8buzdpkKrzP8+nUxp7DoNawZafN20HALalUO3xHNLwA3ZrkgZRrYq0pRZMonnFk
         SUxQ80W9mkAx+PgbvfHEtpaF4OXOG3Naz1CHKJ0W8CY/rw1tfhfmF0EUJoPqJOXJs8jl
         N+7EeeTYjd89zLeXAnJTshE0NPL+NvKWkoGuSsi2Byf8ub0duDGKN9V9OOMLu5L7AHIn
         W/HFoz2mJN6ZqSYSEQeQ5UXfItc2ErUUDWUQpP/TWKphiqK0TBNxL77kTMYvCRnxfDNC
         lD5ep4dT+nqzdRtc9AaxPsVPbaCTvMTR0mv0yWB0Ji8kPR1GiyPJpe4wT5Y+IAz/rn6q
         KKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757368052; x=1757972852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BLaFovz61dlh7ow4ijqIn2/yM4F9mqJ6CyX42AuzX4=;
        b=spbx3nRnoVgfXhbW+uKUv4PKYen15cyYtVZ1GmEFero/70oE+prahSR5yJ9TLKzx+/
         h4Cy4WKkrHOa7KpSGF8lval02R4DwzgbkQkymldtS7Es6fa739ORYsjElnK5YtzgcOym
         QCC30dj839NpHiDLwdL+fEJsSwx7xyIS1CmIYbCMQeE1WwFBXuu4d4a7bM6pCI1/17Ip
         aVNA3pod8E+huoGTfE5VhrWGbw6I7HNhAxpnGeK/5FuJz2m681Yp6khnrTpnm4mJwT2I
         uQHI9YVn++qTTNygkYMZeqd95ROuO9CDP2g6iNp9FDtrzcpE62RVVTcl3E+x90b/9mnS
         m39w==
X-Forwarded-Encrypted: i=1; AJvYcCWjWnK1L7n7VWpj/+iG8AbXvg8N3ToJqAl/4kCNQtLOARNdcJx7boO/luKncVRfUN5rm2MzWtEkPQ==@kvack.org
X-Gm-Message-State: AOJu0YwU44m+Lss1vTQ+5rn8q5k0gdoEhVHnuH+IoXG/EJh391pC6Pc5
	v6ucH+TxzgdEzxIwMgkSyHu10v0em/b8CrkC2s/+wtxL+5wQ3mbjexkF0TO5OSF+XIPIZBy37+i
	cA6+KuPvbAATP/lKOFfmTuEJfLR0ai8y0ce5Nl+g=
X-Gm-Gg: ASbGncssWVA/n1+fUMz2BGYRvqlnzodzqqdoIwF0PR/IFDwdvmTWZDfLaLGMOcTME4I
	LFYdvzLSZMSZ7rHHlT3vV9k35URwZHY7Gw4aUdoXMQS7hRlRjXbwcRPfGxWoe1dcSQtzXSgT72r
	4apVlRN/w1jmuMR2lvCKn76Dx/qmocA2NqyENiNv9kuD5D86Q9llYmy6c/2BsTHF3ZorDHReZS5
	sXONkcGGA7TL93+gw==
X-Google-Smtp-Source: AGHT+IGMgxXpEJKdA0/VaYBjW7wne3u+Z/bvfTs93jSMLlnrdYdvJ8H/cjOy+DRjQYS0XvGXWWTS8+MVP4tCJ8K80BQ=
X-Received: by 2002:ac8:5fd1:0:b0:4b5:e8df:f21c with SMTP id
 d75a77b69052e-4b5f8382945mr91893031cf.30.1757368052321; Mon, 08 Sep 2025
 14:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
In-Reply-To: <20250908044950.311548-1-lokeshgidra@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 9 Sep 2025 05:47:21 +0800
X-Gm-Features: Ac12FXyqytdm6LTd_S9oLQ5lEaWENBoTtlX28nASjMqbh1MB1XvaVuuBvojMNAw
Message-ID: <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 71C9FC000A
X-Stat-Signature: oreqyqqadkrmt4azpougwcnmdccxmpcp
X-Rspam-User: 
X-HE-Tag: 1757368053-476572
X-HE-Meta: U2FsdGVkX19UtZvdl4es0pNXEWEuQX4kG0BGaoDLsfwyU2mfK7LkEpRZAl0OpF9jp1cTgTnWtFEnGfZD8JEOaW+scHy8ONAYodrsHRrcUAfHpLBTIKfkme32qqZ65W2G7WIcgQx79UaLLsYcg8ifpYWdryICIQnvHLO83ecqObGgNi73FgB1G3l+4QJIEudsW0BVPcM8yjMnuoByQEzqXgHvETQWkFp9v8ub8wghY8ozcCQUb46VqsxbL7IJ39b3pUwDhZ38GhZsWwh8eMLfmlz/aNJWZlMW0cJDRzgst3/riTFM8+VZ2vDusU4hApUD1BU3Nl8E2ocgqrb5u2uEze92cV8GYFte6lwdCGem68F8aCVVbO2D/3eId2W2lx2J6mie+NyCngD5EvdSLzMlmwqL8Ie0JUwq+NS7ihz62nJFwdLwinDlfQxJh86zUOM3wxoog6We2uLaGciQOtT2d8Skt2Jwa3HHEETJ4FvAOTHBi3tSoOTDpIWU1idawpwdKMMjrdmnTCF+KYgSmG9vuMEJ0GS/IMeikyaJKLxiNutDINr/vDvkfo7gBFrgWvhwfo9mhtb7SjREVubW9of3Tz/RqK8kCHeLX//ZjeYf4wyFluSDNsZ3esAR/+QdKNrdFqFYbzUt3L8SFscD4aDCuOOdi9Gf9t2pnt3UFmsm0IpchDljo16I63PiYayTLF8wcCyvPTy/f3DN80f4WSP/Wr5y5N0cFH/BQjkIVllzd+1gL0amHdoMtkrz1oRaM3+X4XiY5+2E2F9mRd+sg/gZZK3ApNuQ/lHhwfDbjz3oyOgO/bg/7cHHwSTwL8RKznkn1C4c/aKgaIdgqpczHx/ZV1aQZCbnRMU91aWcMhS9PiczMJ8T+xJWf/jqg0B70YFoU+M0Q2+bZDeBBndulyQQAvzoy1cFZu4LeYF3ZF07/fTlidWFx617ocsqCY9E1CtwC05tBvngc0oqQB/ysCh
 rsIpBwMJ
 lyx3J0wauSJ3AwP54iETQHrfbnBsP4m7NSPKJVu1lOs7A2K38h3gDhjQvlXPDHU+W8VKlWci33Zmx55nyubPzvj5IIp/PNNX0BEKYqyL98VnbXLHdZ9NyzsxNzuxgCYVh4Bq/tp74LslWmtwyOuNhYLAn52enVDDDJS2ziQaG+QyY9W0rSFgvrSxA1ajlfiD/eL8h1W/Va4YE23UUYK0eklNAACDNw1FZVEfxSIyAlyIETf8cX8GO7hIBY0JOk683GJ8kJOOnNJzs/6BCrnUtMOqBm/JelX8uFcZTTvkHkbCzqNBuho0L+moG0rW4mxMxDbbhhmDafsqkPdbQ0PpILYtYtGwk2ifPzN4B5MO5xcSXEbtQv/mwvR175ll+3dw6FUd1m4qZ4/M+jlU82/yLhMFVlDt11mehcFwGNf3flAGjDIrkpJPNLoX/f8kJcPKDUcR+YwDeXFSb1GLa16JvlvS6jZuDfRx/c4nB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.co=
m> wrote:
>
> Prior discussion about this can be found at [1].
>
> rmap_walk() requires all folios, except non-KSM anon, to be locked. This
> implies that when threads update folio->mapping to an anon_vma with
> different root (currently only done by UFFDIO MOVE), they have to
> serialize against rmap_walk() with write-lock on the anon_vma, hurting
> scalability. Furthermore, this necessitates rechecking anon_vma when
> pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
>
> This can be simplified quite a bit by ensuring that rmap_walk() is
> always called on locked folios. Among the few callers of rmap_walk() on
> unlocked anon folios, shrink_active_list()->folio_referenced() is the
> only performance critical one.

As I understand it, shrink_inactive_list() also invokes folio_referenced().
Shouldn=E2=80=99t it be called just as often as shrink_active_list()?

>
> shrink_active_list() doesn't act differently depending on what
> folio_referenced() returns for an anon folio. So returning 1 when it
> is contended, like in case of other folio types, wouldn't have any
> negative impact.

A complaint was raised that the LRU could become slightly disordered:
https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifeng@oppo.com/

We can re-test to confirm if this is the case.

Thanks
Barry

