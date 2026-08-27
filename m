Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEF4C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667976B0092; Thu, 27 Aug 2026 05:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617DE6B0095; Thu, 27 Aug 2026 05:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D576B0096; Thu, 27 Aug 2026 05:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6E26B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:31:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A43271203AB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:31:53 +0000 (UTC)
X-FDA: 85146532506.22.B646062
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id BB5E6C0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:31:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BOyhMa/R";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pR6mczGLZ4oTQtEIp92SfLVnhaH6TJA1RsH9sfmiLc=;
	b=0vWyS1BqoOi1NRpojYli1OfolYiAxVFAPyhMgsi9jLU0Hi9P+gyLkiajwigyvAvq5YEIu2
	x2EwUtk8SD94X9pIb1QOt7l52HwliCMYirC/xesUPNLgDx+ixIHEs6TOzX5oBKZfTW1PhM
	Mz4zhe9snCxqDVjMHMg5gf8I2YQ+2OI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BOyhMa/R";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787823111;
	b=d1Xxyrsc8bKLZYvB8+ujVCt+MOP7AoJseRGRAjFIhdbuufK1boiurJk5CHgvSfLBNkssT+
	WLG610AfvpDcDS+kCyFuPBgOnF62u3Ws2lxXRbYC0BdEEHPbCHlDpta0d9v9INt43BtEGn
	qLCNYItkjguMLgOWwJtz0Ba+pzORvwU=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so2868068a12.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:31:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787823110; cv=none;
        d=google.com; s=arc-20260327;
        b=ojTjCexTHjnNiYber3u3JfdMvXKsPKuuu2XT79CmrXF85uNzUblMNWWwU5OC1KH3fR
         ZhvG6/U+jGSHoyop6IsVrvZvbOCBOIm13Qcult0F2ntqNH3lTSWYrsyw5he2486YKIJ4
         1XETB9FAChsaVuTGDH3APjiL3So6gozsfWeZygQVtHCyA4SDHitof4yFGtqnl0qb1ruA
         juocBmZCaAqYMEmA+IC/QI+OrTgThUSTSGw6lr9VM+zJoB9MDFLz+6ztLHBr71r1BkiI
         YMIJkTwrT8TQsJEfAYiSGYxtl301K+LSTPIlOD8nQAOdBZqnrIYV+z4dk7/LzeFGRUwD
         nTvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5pR6mczGLZ4oTQtEIp92SfLVnhaH6TJA1RsH9sfmiLc=;
        fh=XYXz6GJPLgExViypcA+JiAzEY8Qh54qRnNNv3aHR88s=;
        b=rWCRVwKjVdcbX0vhoUzIuPQv69hoYsFeIWwnLwmxn7XHyboHtEk2IvpKquHkaINiui
         rJ2TT1ATFQYGYYkScWX71teK6fu135GJv2Ag5lxQXkg3lQ4cQzxeWCjlhIEBEeXjhQyf
         KJf/u+4wFbqkQ8wrEuVDBL00vZtACndDgmWd5bvVx+5zLxcTCrXEZVhYdA5ft0LO0Vpn
         hD4uUahD0LcWC4Q/MwI4XO+wJZ4FnTw8JCpPe6sj+J7c3fOEhrY5C/y/9riBg76/c52Q
         0+Dd3e6N85/8p1fjn/NMobYWQpAFxSmm+60nrJKWacCBDlp5H2qNMaR+B9Xg5vy4/6Sn
         u7/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787823110; x=1788427910; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5pR6mczGLZ4oTQtEIp92SfLVnhaH6TJA1RsH9sfmiLc=;
        b=BOyhMa/ROoCtYoI1XU0oD7CbXgSM4UCeS5T677FoPnCeQUeitigehXgpaao/Ua83UO
         lwyknGDbSUX5djt7C8YJsMiDtW5d/zoAeRFpuZCsvrrwWSRohZnYS6ZNoPJ9qDHKBC39
         3W8yVA1u2Vy7v2MbWOdNUiTqUMBI0It+qZpRlIDsisXP14nN/CkOv234NIPL+/CQgoEM
         OJzQUeWTYolc6ipWl8MalQLF/OH9I5Wyhp/XHFYxFtGDNh/E+zCEefY0frUgK0eQ5HUW
         ZHKcmXsOO5FCufPmIHPXiWMHBSThuyqzcbaFvoxk48sSpSB726iuua5/svBpVydx/mPM
         pNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787823110; x=1788427910;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5pR6mczGLZ4oTQtEIp92SfLVnhaH6TJA1RsH9sfmiLc=;
        b=IIyJtE5PvX7e0vRsYYa+HRfxqJsPNL150KohhDMe+LUILm2ZycO3UgmEy7uy08nPOm
         KZ5BNA/f81QXz7tKuaFs37I2YKSNENhzw1Hr2pKkFw21xy/UQAs73ms2uFFwJLDzzsNN
         J3Ds5g/agALlr3+NFbpDZ+GuQLdJ8ngVdk/JXpvfu9fnjfWJ2S/28RinYt1OfDZLlMVu
         m1HArywnLqEgiPx8ti1zxGTVjx+U9zYEp83mb+6yY3SW+mvjWlEXm5ILJOE1Mw88XJNv
         8JKf+uwzbM3jd676/zRAX/7SfsyreKO32d7hKId1pHCcwwH3J8OdrIFLSEv/NwPLD6dj
         61Ag==
X-Gm-Message-State: AFuF++mqVAqRGpiahlOPs8fUj+rejae1XNjNMky3szbx0LwtJcmbMhZE
	gcGX7iRm3hsnAxURVw5bbXIQcgv1VBpJoaROsht6fzwo6ZGrPOoSw1zjUQoYmngEVpmWglIVgZX
	JVVPV+aBP4FK7oNo3Pt+dtA8VOnedpSY=
X-Gm-Gg: AR+sD12QC2B9fuExQeQD6rpj0POdEZMLLIXw94x25XzT9qleqCfJuO5FjACz78QKDqU
	XzFcnnzMKfIzFQbOGZsYmHCfeJNqxStV212D2SyJzdLc5sk0ImDh+j1osca3XMwoPZnPfKn6Pty
	a3Ihq3ci6Cw7Pbxy3gS+TRd8smUcB00sWwS5h9nl2x9YxPLA1PoaIp0dX0Tp9eEBz4slBL7Vf8N
	wRLxmpjCcYjogx0lnpNUI4LtrOcuVfeoM7gNtrSL1GupMZVm8ZWYquLkmNG3ZyP7PfVv4WpskDX
	iXk53Fx9brFqeJy2kPH+nDRUj+Qo0mKpJLCVEAjpzHhognuokFEjtLjHvyX69mkPNlSvW1PQhqr
	GssU=
X-Received: by 2002:a17:907:3c90:b0:c25:58e:83ff with SMTP id
 a640c23a62f3a-c250bb126d0mr1498631566b.10.1787823109975; Thu, 27 Aug 2026
 02:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com> <CAGsJ_4x7ukyX1nUikuZd6fWtCdAJyfH8zJt+yRPByU7pZ8PPag@mail.gmail.com>
In-Reply-To: <CAGsJ_4x7ukyX1nUikuZd6fWtCdAJyfH8zJt+yRPByU7pZ8PPag@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 17:31:13 +0800
X-Gm-Features: AcwNN1UpyH7xDqcTAweobdT93tBwprOXaRt-X3XUo75tnaXlcJA4RQT7BJzDyEA
Message-ID: <CAMgjq7Ab93eu0JzbGmyZaLC7SKMpNa9oLXwL6hn8CBoP0McW_w@mail.gmail.com>
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xo8xt7ff9nhoecky7csbaqayjyyzdr7j
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB5E6C0004
X-Rspam-User: 
X-HE-Tag: 1787823111-20899
X-HE-Meta: U2FsdGVkX19iRg0HhJmuC728XTuLQ4k6kungJkb8KU/xcOuLCGSLFZ6CCm27dPdBMHuImoKll3XttqVUXqXuHUnUI+LmaA2rnvgcng3xuTGyVnUCxdHDyKdSxDM8wBm2+2E/kMubNoGtwnJLuMZOZwEAhD4kQbrg/amGWAgzE2NHMVp0vNTGjbN76u9qt0ppKTLNxiRiPKemYtEA9hQF9gT3/0ZpTkzhJEkB59uzfMH7AgZLESb/eHrIFXCB6rOku+R4ZoICEaUtUjcYY9EcuUTetDpsgSC5f4TtgKP/VHb300t85oLT2jKycRRJwmSJb982cMk/GnkxKAX3mwF5YWW9TuTBQi0OwC4XSEJjCR69CqAqp1ylRAFNq/uZRKvFf7C04ZbhcXSxIAUOO24Sy0+/IwWEeYu2TTKcLXEAfAo9FGGJPmEw6ecXxfo2lJgi2tvf/EcQQqgbkyWt2uop3ZD84aicEj783L+tijxKGQ7kmZuyR6vxw944tUki3USAVSR0ZrqYfxulISJW6Wwbhbop9lrqh8qziT0HwQZ1vJZrqhrT6ZFp61AVWbInUFi/S4eE5mcFcAo1Dh4h5TRusZyg/LhNOKgy3ZZrpL4oDgFXzGB+ssjkYmVKYQudd7QnTzoW51uY4NaP8y7hF7kubPD54ckaX8OSJ4V+DGHuv2eLs2y2lZ/qmJslzdkLtt2xrZCTKwx/v3L7nMnnT+Rcs6sBYFNcaK1kMjTmqxy9rv0CxItOho+OqAD/SdN39NZZ5N3YZYl5m2ZNbYkFpSq8AnNdF5AvgQmgDi0WDNdwP3Ee7/HTk5IIl4OqQETBjnb4Pxo0/4UcOvizmOWzUxDeMDxzzQujvD1Bi47IrZIb5oMGkovafgqummrxlK29jY88IOTGDohsTlrtPwnAwvmkl/hKu8YS8o9+IgEKOHqKEnYa4Cpn7cRl1kbNRBdWanXFuyMLmTMuunxWtRjfAef
 it0Oou1h
 o9WckGyUYT4dpl5fpqZ6fK2hoMixurmEJSWd0g62d9jSdln+lZDngVGY+QmoFlBQ6xdZl4VkzdU1t5L0b9cU/QjpSGhvGccJ7p97ho/u/CB0gp60YOuq7R82FyPoMndRtbNrBdusUprSPTlWOeo51d0/vS00x1osyzJOm2TRJ67j8FRDQsq1lTLYqVs4126iZuttV/ApumpbDvCD+pfS75DVi6Lgb8aNRw+oY6R+VADGyGz7gR/RTzCXJNz1dzYkR15Zs0VcpqdAFAd23OZpfMUi8pB7+AtLcH5Avgq/SgU4dhb79+EyYgPq3NCX72kE9NgZ4axrjHfTooG2sjzL/bPsfC0RC77ZpkaiUD7yjN8PIJFrPNJEx/ZFfKxKbVB0Wp1hr+uj6z6CHBicLyNHeCF/TusP2aDJOYQeUlWitH80t48/5k2A8adrLASrxQKnYfwOJYQGxOmr0q8zwDsuJZdtim2+trKBJ+3dGaUJHMGnzkb64MapCv8eSsEnE70PFGVC7C1/WcKgOluo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 4:46=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > A folio in the swap cache cannot be split if it has a mapping (shmem).
> > The split code does a defensive check for this in
> > __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> > and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> > rejects the split and returns -EINVAL without unfreezing the folio or
> > restoring the counters. That error path is buggy: if it is ever taken,
> > it leaves the folio frozen and stuck, skews the counters, and fires
> > the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
> >
> > Check for this case up front in folio_check_splittable and return
> > -EBUSY before any state is modified, so the split routine always backs
> > out cleanly.
> >
> > Also fix a bracket style issue that checkpatch.pl keeps complaining
> > about.
> >
> > Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functi=
ons for folio_split()")
> > Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __=
folio_split")
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> LGTM,
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks for the review!

> [...]
> >
> > -               if (folio_test_swapcache(folio)) {
> > -                       if (mapping) {
> > -                               VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> > -                               return -EINVAL;
>
> BTW, I=E2=80=99m really curious whether you=E2=80=99ve ever encountered t=
his warning?
>

Nope, found by reading the code. It's possible in theory, the race
window is super short so maybe no one observed it, or observed it but
hard to debug it (a random frozen folio). Anyway we should just fix
it.

