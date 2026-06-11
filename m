Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F24CD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588196B0005; Thu, 11 Jun 2026 03:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539186B0088; Thu, 11 Jun 2026 03:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400196B008C; Thu, 11 Jun 2026 03:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9236B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:45:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B15F4404D0
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:45:37 +0000 (UTC)
X-FDA: 84866847114.27.3527ECA
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F35E40008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:45:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jDON+qpV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781163935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCoAU+TVGs9cnjbnsvNCWbB8dij/67uZElYc2XTKOZU=;
	b=sNx6daxb3Pk4Xb/+B/CKGK616JC9V4i9hZemk1JJGU0uNWazJW2yarh+B9CITJBYEjpMlO
	XnnzdkgU4h95Ysq02oRfiiJFRKVquJ4Ja2sOaDW85UOnMV0kGRhqiwUf9enEaupkqubE8+
	LFxvm1t0QdKyXQ0Vxma3+A1X9IGMJ6E=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jDON+qpV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781163935;
	b=12x+wSM8HWS2prjyErTIbYoVutMJD7t8LjYp0bGr5X4VFk8NMigXdPbOWGgHWIkdDfsSs+
	o2Dm77qYG8vvM5WFT7msxYjK5rUQNO7u04xdap7lmWtBVaLOSw4SU3wAJEXOMW+xPucGN9
	X/k9ByhvAH7t4VmRoLb30pAhKnGuxc0=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39677114c7bso6607371fa.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:45:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781163933; cv=none;
        d=google.com; s=arc-20240605;
        b=cGw5/+UXnuaTaC2282gAVnXopWMoufrQJ+pLmnfCXkkSmdpMkYgAw5inOiJh3A1HzX
         2eC7lpZ2ljpi6+/o6xSIe+yr0uXxZ7v8tjlvdQKqob/hkMcsN9HaYb2/Osgu2ASbLtlz
         bfzrrR5wm8PKqUdXOKSoYNL7s7vK42DCqjRdnkHCixm0IE5zYSH92dI1yflW92L0IzFx
         UrcUU80UQqTlIE5pJbEiA8cqwO6hVNa3aEstlzKh0sYoshwoMuASBHnN1p9DAGjfnUH2
         tZucszxKEtQxmOeXLswTUqxSklacSXTcmgqpy45PImr1Bng98QONYnMyb87g7IMR/Qj8
         99xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GCoAU+TVGs9cnjbnsvNCWbB8dij/67uZElYc2XTKOZU=;
        fh=S60SeD4GGyk+3EGoiVInacYQFPB4GU9LTydjrkYVvV0=;
        b=GZtEYHgY/O2Yyaqw9h0lQHD1HMhTjYarTslP/vXZfm6JSHaQPdT+4yFCtJouWwE1sl
         0RoCp9qjzSXSVKyotHJyMgCKnYdMYjQeHBw++yal2IEwRTM8FPziT/Qr49tIC0PjIqeE
         vE2MiIjZAFht/E9faeleauEKotyG3uanaI8wyIpeQ5kMO0uD5LgFMkWfdaYRihWBrMox
         e3Oa9YPjXugor3K2+maK3f/21Tr/OWsbjgiIwfZByYjwfbmvHwWSodzpKiWsCx26W/wZ
         RT/9XzAjeyKE7PZPVyM87xwuzIs1DCjDvpYpYEFSrfgdlcZNBxMod+dY6lt2+FQ2ghTL
         drZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781163933; x=1781768733; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GCoAU+TVGs9cnjbnsvNCWbB8dij/67uZElYc2XTKOZU=;
        b=jDON+qpVVsdc3Xbqu/ohDbuzD12s8P7kgiPbc9j/7QjX0Lwjotv4iwy4uCBRsciB7Y
         mtwhx2MgXw+zHX0zeYnx+YHZQncGE3Tqqa6Lxz8tt19fbZohB3edSCbKkdWZx0gC/yZy
         jAM3Mus4PyOU1cJtbsK0He6LlXjdlYeDIdRgvyxIl5+tSYsEzcTPRZ3Hp8NnlYaOY4jx
         /8BhJDBtO1OqohwdbLWKUeJbR4l4hy/aWfUF/unzpvwvIQWup5OGPhpVpfWQnV82jJBo
         R3ZN00UPLXW4USxIfFET79rxxFA5ne9SMvQL6c6NBVOIYJFcEXyxJC9uylg+c2QpHoBu
         SF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781163933; x=1781768733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GCoAU+TVGs9cnjbnsvNCWbB8dij/67uZElYc2XTKOZU=;
        b=AVeAsfoerw1RGf6oDHrBVYfhbtLVxbJEZoVokyQEgP3wTG0qziKNDviI66nb5kOLpU
         29F7uR4Wmz6VRrtdEPjwomouEOK5jhXSSi2Zaoq0vnSb+3uDq5cP11DwbzHI657CG/P2
         QF6RA97CjR+DEAMZJfPmo512ayrFhRhGqkW8p3Vz5BNZoI7UTkCfptAa6XJRJ7sv8Fd3
         PS4eNtZe15wHsWQH4FUbzjbZdY+u3cZd1xkXHL62X2w5UZrUP6bMEHIbyBb7+m8BbI3c
         uHbOg4zTyO5Pg39RmQE9pD9+hGilcHbrrcRY4BbsyMuzHxAfu0ttHW/FBichlFh4iAOD
         QvuQ==
X-Forwarded-Encrypted: i=1; AFNElJ+6PW3NfP+oaA/he0yzsAtDW5HI/MZ6GXDdcSNzQ1DwmZGXJNgRdOsnZ7TKOR6DLtw9UJYEcdA90A==@kvack.org
X-Gm-Message-State: AOJu0YzH0v6CEwZ/YmUWdlD9J9IWDGDaa4NF4ESzw19WObdZDvFcuiaQ
	Qe3pnBGNrfJZZSS8SLwPUvWgc2zx95/FlbnFapIRLokT0rMr3sbQTJ7sTmIhajPQJN/KwGEaQHk
	5c33MT5XZY1QWW89r6BSTWIGw7+GwePw=
X-Gm-Gg: Acq92OFdlDWTNS/4c5A0huqM99wTpUJzUO7YdboVjVp2kt5ERM0wRtF080bjeaQWv6q
	MPjhY2bTlK/1/vQCzfUOGkd+b7aBv/3lYrgNbZ8dxlf4RcUDdqs4lSelqaj0Vlz8G45jmCPmRJ1
	ahHgnKWzMfa0F430zfB/SYd6wxRacSBbIYuK8F4Q9xV6BMcBDgPWgl9JYwRIICA/PdS02CJ1igZ
	QQ5tqyfLZWXojzxN5sob2Us5Th1ECDbI7HQYrNLqrzkMRZORtgCmlBxqN3dKg8y3bIkcjQKzcZQ
	tLRL7YkL2tVDIq5eVtOBP5zXbH3E+A==
X-Received: by 2002:a05:651c:1504:b0:396:7222:d730 with SMTP id
 38308e7fff4ca-3991a0d4176mr1577961fa.6.1781163933032; Thu, 11 Jun 2026
 00:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org> <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
 <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com> <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
 <A7D51FCA-7D88-449B-9113-7741BA2D659B@nvidia.com>
In-Reply-To: <A7D51FCA-7D88-449B-9113-7741BA2D659B@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 11 Jun 2026 15:45:19 +0800
X-Gm-Features: AVVi8CexYaDwTfsug8qTAMpp20IvKxFnS7lJ8zbGR4banVqjk_DDrKBQN4YTi2s
Message-ID: <CAGWkznHyxMNX3=A8ApCuY20As4NJpF_dCTaY_5+STVSv3RjsBw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
To: Zi Yan <ziy@nvidia.com>, jaegeuk@kernel.org, Chao Yu <chao@kernel.org>, 
	"jyescas@google.com" <jyescas@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7F35E40008
X-Stat-Signature: 63ze77uz7scp1aijk1p5cqc73k69aky9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781163935-672899
X-HE-Meta: U2FsdGVkX19EW2ytATc63TTbOPGgVJ216AJEtS2W5c2/3SnG0C+D2KxLzFJwj98+gly/c1wonE6+wEPl8C/iOGNgrx/vFwSLnWS/uxYwGUVf7J/oLx4rFjzRivE3eNFVe97wwjP08lmTLSj6iHlmuvDFuSLpX2mTSjb4U6Ro/hlm57pXvSxE3CPoyd5wVsBh4e3H+TKOyT076G0ueKBsFuv6Z+w6OXwdNWXZ0yIMcDwEWblt9y/uRii10UNOg/6jAZQx01qxEP4Qj11Fwo7U/AV7GYXg4pALUrEyvZoe/M470QqMkW2eaCP5vopEOhdzW9/U9O0SljTCHxlrgFA3PXlHvUHLKt64x7xUzZy+3T36QsbnTAwx/m+Vvji833O4nBweZY14scRro6ynmyFXRtqry44AyrGktIsCBBRfjEgMsiQYNbXBoBXRDcrIdbcuP4nRP508XnbpRJ1JwChVYEHUZJCxdxJrDc4XuBCFwtYjz28a1H1mg+HeOd9s70kOTxUQpphGF1zbA6EteDgouH/7Ltxk9HYNjQCntXTR6ceJZ7jtMwren7ZxV7LiqxO5+Hxrnar3mEBjgXA0U2vkabU3sngxlvFMCIZ77v2oMvXzEtw17nOnY0d6nQWzQ6NHr6WpYYhx8XxM5JwCKmWeCigGqVteZ8VmDgDaNItOsLbhYnmWuk7M5JnMJjr9BWiicG1Pahk0r+01q7xBfEuSbCcwnJTsmXL6HAu+RGPQtNLTV+QElZ4KvgSWn7wgP9x0sn/LN+kmWtwoA4ovr3B8pwu8GyWMKYuh1k72wx1wZRF1EdSwRVbg5rw5iHsOMgW7Hsonj6IX2VjvwKwBpGgVuWbquMoMvgopZbd84sMVob7RAOXtTcXAflhUIp+p+mBFpPhVL7zy7XegptcllPFYES+DPNwDEUhE0/KBTt2P9pe22EugadvfyLm8YnlkuRLBL4ElynEzjCkQDHOWWy2
 drAb6xgw
 WRU3rYYfqX2viBKVdureB3Gn47QGOW5aXb/2Jurtgy49YmyXw2+jenVAis8+338FLaBPqWXZai44IVxpAEfn296FWXnjXFgXcu/+u32sOBJ/u689ghZ1sK2EEeSJEDepAKqKRiCRVBQnT+3KE49SQDdWJNKM/oVzaD6klDi36NhcCwf5TPLHqzsztHXOki6Tdmj+iVK4sk/3o/d04SlRPUqUzStFFdwBjE/N/0oq25DqyMxZY+Zb/Hw/2ZCVcHqcS2EiIfrTC5H87n7XqPUokkW9euZ90pQLyRnxKBqO4NCEq8U/wXRaLxbZymhlNzaIxmVPftEI+lMRLbXhkVQhKF/x9ECBk/HqYwDaQWVXeH7UJqshGaB1J/ALdvUOpN6U20cG8frTw2AxyYMIKY5dfDrG0z02gQ/3VbY5OvzWFu5WeC657ZG7S39I6YURd8SqtRp5qVk/C4vqtd7vPaxMsXARWDRW/E08rwulO+67653RdgoQ+mj8Z8MGVNJILHk8Duv5U9OsoEghD5BwoS+bOtzKCSXpzbLIqlxcJkMAXNfShEI1uVxhiH42IDX4VCiAwwGsg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+f2fs and android folks
@jaegeuk ,chao and jyescas, this mailing thread is talking about an
issue which related to f2fs, that is, with the commit 9609dd704725
("f2fs: remove non-uptodate folio from the page cache in
move_data_block") on and off the android's v6.18, we can reproduce or
not the kernel panic reported by this RFC. Could you please have
insight into this or just revert the suspicious commit?

On Thu, Jun 11, 2026 at 11:06=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Jun 2026, at 22:39, Zhaoyang Huang wrote:
>
> > On Thu, Jun 11, 2026 at 9:56=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 10 Jun 2026, at 21:39, Zhaoyang Huang wrote:
> >>
> >>> On Wed, Jun 10, 2026 at 10:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrot=
e:
> >>>>
> >>>> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
> >>>>
> >>>>> On 6/10/26 14:05, zhaoyang.huang wrote:
> >>>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>>>>
> >>>>>> The kernel panics are keeping to be reported especially when the f=
2fs
> >>>>>> partition get almost full. By investigation, we find that the reas=
on is
> >>>>>> one f2fs page got freed to buddy without being deleted from LRU an=
d the
> >>>>>> root cause is the race happened in [2] which is enrolled by this c=
ommit.
> >>>>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs=
: remove
> >>>>>> non-uptodate folio from the page cache in move_data_block").
> >>>>>
> >>>>> But I assume, that other FSes can trigger this as well? Any insight=
s?
> >>>
> >>> Yes, I think all FSes support big folio could suffer from this defect=
.
> >>>
> >>>>>
> >>>>>>
> >>>>>> There are 3 race processes in this scenario, please find below for=
 their
> >>>>>> main activities. However, by further investigation over the code, =
I
> >>>>>> think there is a common race window for the truncated folios betwe=
en
> >>>>>> split_folio_to_order and folio_isolate_lru, where the folios lost =
the
> >>>>>> refcount on page cache and remains the transient one of the split
> >>>>>> caller, under which the folio could enter free path and compete wi=
th the
> >>>>>> isolation process. This commit would like to suggest to have the f=
olios
> >>>>>> beyond EOF stay out of LRU.
> >>>>>>
> >>>>>> Truncate:
> >>>>>> The changed code in move_data_block() lets the GC path evict the t=
ail-end
> >>>>>> folio from the page cache through folio_end_dropbehind().  Once
> >>>>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, =
the
> >>>>>> page-cache references for all pages in the folio are dropped.  The=
 folio
> >>>>>> is then kept alive only by temporary external references, which al=
lows a
> >>>>>> later split to operate on a folio whose subpages are no longer pro=
tected
> >>>>>> by page-cache references.
> >>>>>>
> >>>>>> Split:
> >>>>>> After the page-cache references are gone, split_folio_to_order() c=
an
> >>>>>> split the big folio into individual pages and put the resulting su=
bpages
> >>>>>> back on the LRU.  For tail pages beyond EOF, split removes them fr=
om the
> >>>>>> page cache and drops their page-cache references.  A tail page can=
 then
> >>>>>> remain on the LRU with PG_lru set while holding only the split cal=
ler's
> >>>>>> temporary reference.  When free_folio_and_swap_cache() drops that =
final
> >>>>>> reference, the page enters the final folio_put() release path.
> >>>>>>
> >>>>>> Isolate:
> >>>>>> In parallel, folio_isolate_lru() can observe the same tail page wi=
th a
> >>>>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking =
its own
> >>>>>> reference.  If this races with the final folio_put() from the spli=
t path,
> >>>>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_fol=
io().
> >>>>>> The page is then freed back to the allocator while its lru links a=
re
> >>>>>> still present in the LRU list.  A later LRU operation on a neighbo=
ring
> >>>>>> page detects the stale link and reports list corruption.
> >>>>>
> >>>>> Complicated mess :(
> >>>>>
> >>>>> So, folio_isolate_lru() really only requires the caller to hold a f=
olio
> >>>>> reference, which can happen given that we did the folio_ref_unfreez=
e(). It can,
> >>>>> for example, be triggered by memory offlining or page migration.
> >>>>>
> >>>>> So we really want to not allow folio_isolate_lru() while we are sti=
ll processing
> >>>>> the folio.
> >>>>
> >>>> Or we should defer adding split folios to LRU after unfreeze.
> >>>>
> >>>>>
> >>>>> What your patch does is, simply not add folios that we will drop fr=
om the page
> >>>>> cache to the LRU?
> >>>>>
> >>>>>
> >>>>> You should describe here how you are fixing it: "Let's fix it by...=
"
> >>> Yes. This commit would like to suggest to fix it by having the folio
> >>> skip the lru_add_split_folio
> >>
> >> Skipping it causes more issues like LRU counter mismatch, firing up ba=
d_page()
> >> since PG_active, PG_unevictable, or MGLRU fields in ->flags.f could st=
ay
> >> uncleared at page free time.
> >
> > OK, we should solve this issue.
> >>
> >>>>>
> >>>>>>
> >>>>>> [1]
> >>>>>> [   22.486082] list_del corruption. next->prev should be fffffffec=
10e0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> >>>>>> [   22.486130] ------------[ cut here ]------------
> >>>>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
> >>>>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  =
SMP
> >>>>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> >>>>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> >>>>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SS=
BS BTYPE=3D--)
> >>>>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> >>>>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> >>>>>> [   22.488539] sp : ffffffc08006b830
> >>>>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 00=
00000000000000
> >>>>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ff=
fffffec10e0ac0
> >>>>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: de=
ad000000000122
> >>>>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ff=
ffffc080061060
> >>>>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 00=
00000000000058
> >>>>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 00=
00000000000003
> >>>>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ff=
e85721f0e25f00
> >>>>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c=
65645f7473696c
> >>>>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 00=
00000000000010
> >>>>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 00=
0000000000006d
> >>>>>> [   22.488647] Call trace:
> >>>>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> >>>>>> [   22.488661]  __folio_put+0x2bc/0x434
> >>>>>> [   22.488670]  folio_put+0x28/0x58
> >>>>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> >>>>>> [   22.488689]  f2fs_gc+0x230/0x9b4
> >>>>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> >>>>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> >>>>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> >>>>>> [   22.488725]  invoke_syscall+0x58/0xe4
> >>>>>> [   22.488732]  do_el0_svc+0x48/0xdc
> >>>>>> [   22.488739]  el0_svc+0x3c/0x98
> >>>>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> >>>>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >>>>>>
> >>>>>> [2]
> >>>>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          C=
PU2 (folio_isolate_lru)
> >>>>>>
> >>>>>> F: pagecache refs =3D n
> >>>>>> F: extra refs =3D GC + split
> >>>>>> F: PG_lru set
> >>>>>> move_data_block()
> >>>>>> folio =3D f2fs_grab_cache_folio(F)
> >>>>>> ...
> >>>>>> __folio_set_dropbehind(F)
> >>>>>> folio_unlock(F)
> >>>>>> folio_end_dropbehind(F)
> >>>>>>   folio_unmap_invalidate(F)
> >>>>>>     __filemap_remove_folio(F)
> >>>>>>     folio_put_refs(F, n)
> >>>>>> folio_put(F)
> >>>>>>                             split_folio_to_order(F)
> >>>>>>                               folio_ref_freeze(F, 1)
> >>>>>>                               ...
> >>>>>>                               lru_add_split_folio(T)
> >>>>>>                                 list_add_tail(&T->lru, &F->lru)
> >>>>>>                                 folio_set_lru(T)
> >>>>>>                               __filemap_remove_folio(T)
> >>>>>>                               folio_put_refs(T, 1)
> >>>>>>                               /* T refcount =3D=3D 1, PageLRU set =
*/
> >>>>>>                             free_folio_and_swap_cache(T)
> >>>>>>                               folio_put(T)
> >>>>>>                                 /* refcount: 1 -> 0 */
> >>>>>>                                                                   =
folio_isolate_lru(T)
> >>>>
> >>>> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(fol=
io), folio) in
> >>>> folio_isolate_lru() would be triggered. Maybe we could just return f=
alse in that case.
> >>> No, isolate caller will grab one refcount.
> >>
> >> As I said in another email, isolate caller cannot grab a refcount when=
 folio refcount
> >> is 0.
> >
> > pin_user_pages*(..., FOLL_LONGTERM)
> > =E2=94=94=E2=94=80 __gup_longterm_locked() [gup.c:2465]
> > =E2=94=82 =E2=94=9C=E2=94=80 follow_page_pte() [gup.c:802]
> > =E2=94=82 =E2=94=82 =E2=94=94=E2=94=80 try_grab_folio() [gup.c:858]
> >              if (WARN_ON_ONCE(folio_ref_count(folio) <=3D 0))
> >                  return -ENOMEM;
> >
> >                                // Could __folio_split->folio_put could
> > race here ?
> >              if (flags & FOLL_GET)
> >                  folio_ref_add(folio, refs);
> > =E2=94=94=E2=94=80 check_and_migrate_movable_pages() [gup.c:2490]
> > =E2=94=94=E2=94=80 collect_longterm_unpinnable_folios() [gup.c:2391]
> > =E2=94=94=E2=94=80 =E2=94=94=E2=94=80if (!folio_isolate_lru(folio))
> >
> > Could the __folio_split race in the above scenario? It looks like
> > try_grab_folio set the refcount without using atomic operation.
>
> folio_ref_add() used by try_grab_folio() is an atomic op.
> Which refcount change is not atomic here?
The atomic I mean is folio_try_get is implemented by
atomic_add_unless, while try_grab_folio does this by the below
sequence which leaves a window to have __folio_split race with it.
right?

if (WARN_ON_ONCE(folio_ref_count(folio) <=3D 0))
....

if (flags & FOLL_GET)
    folio_ref_add(folio, refs);


>
> In addition, who is GUPing f2fs folio?
Don't know yet.
>
> I think you need to find the actual f2fs code path instead of
> chasing theoretical code combinations.
The test case get passed by reverting the commit of
folio_end_dropbehind which encourage us to believe this is the clue.
>
> >
> >> (from previous mail)
> >> Wait, if folio->mapping is NULL and folio is not anonymous,
> >> folio_check_splittable() returns false at the beginning of
> >> __folio_split(). So the split cannot happen.
> >
> > According to my understanding, the folio checked here is still big
> > folio which is locked and with folio->mapping set, right?
>
> But the provided trace says the folio is split after folio_end_dropbehind=
(F)
> and folio->mapping is NULL.
Please find  below for more information of the coredump. We can know
the BUG_ON information that the folio just under list_del is
fffffffec096e440 while its lru.next folio fffffffec096e480 is the one
which get freed to PCP without lruvec_del_folio wrongly[1]. We can
also find that that 'folio(0xfffffffec096e440)->lru.prev =3D
fffffffec0f639c0' in which fffffffec0f639c0 is an alone index folio
within the page cache that looks like the result of the fallocate[3].
So if it is possible that the split happens prior to fallocate and
then the folio got truncate and free_folio_and_swap_cache race with
folio_isolate_lru?

[1]
[   22.339229] list_del corruption. next->prev should be
fffffffec096e448, but was ffffff80f9791830. (next=3Dfffffffec096e488)

struct page 0xfffffffec096e440 {
         lru =3D {
          next =3D 0xfffffffec096e488,
          prev =3D 0xfffffffec096e408

[2]
fffffffec096e440 a5b91000                0       18  0 24 referenced,lru
fffffffec096e480 a5b92000 ffffff801e930481  73009e9  1 41028
uptodate,lru,owner_2,swapbacked
fffffffec096e4c0 a5b93000 ffffff801e930481  730033a  1 41028
uptodate,lru,owner_2,swapbacked

[3]
fffffffec33f9440
  index: 76446  position: root/0/18/42/30
fffffffec00da9c0
  index: 76448  position: root/0/18/42/32
fffffffec3ded040
  index: 76449  position: root/0/18/42/33
fffffffec0f639c0
  index: 6188581  position: root/23/38/56/37
fffffffec0f63a00
  index: 6188853  position: root/23/38/60/53
fffffffec0f63a40
  index: 6188854  position: root/23/38/60/54

[4]
    CPU0 (f2fs GC)              CPU1 (split_folio_to_order)
CPU2 (folio_isolate_lru)

                                split_folio_to_order(F)
                                  folio_ref_freeze(F, 1)
                                  ...
                                  lru_add_split_folio(T)
                                    list_add_tail(&T->lru, &F->lru)
                                    folio_set_lru(T)
                                  __filemap_remove_folio(T)
                                  folio_put_refs(T, 1)
                                  folio_unlock(new_folio);
   move_data_block()
    folio =3D f2fs_grab_cache_folio(F)
    ...
    __folio_set_dropbehind(F)
    folio_unlock(F)
    folio_end_dropbehind(F)
      folio_unmap_invalidate(F)
        __filemap_remove_folio(F)
        folio_put_refs(F, n)
    folio_put(F)
                                  /* T refcount =3D=3D 1, PageLRU set */
                                free_folio_and_swap_cache(T)
                                  folio_put(T)
                                    /* refcount: 1 -> 0 */

folio_isolate_lru(T)

 folio_test_clear_lru(T)
                                    __folio_put(T)
                                      __page_cache_release(T)
                                        folio_test_lru(T) =3D=3D false
                                        /* skip lruvec_del_folio(T) */
                                      free_frozen_pages(T)

folio_get(T)

lruvec_del_folio(T)

>
> >>
> >>>>
> >>>>>>                                                                   =
  folio_test_clear_lru(T)
> >>>>>>                                 __folio_put(T)
> >>>>>>                                   __page_cache_release(T)
> >>>>>>                                     folio_test_lru(T) =3D=3D false
> >>>>>>                                     /* skip lruvec_del_folio(T) */
> >>>>>>                                   free_frozen_pages(T)
> >>>>>>                                                                   =
folio_get(T)
> >>>>>>                                                                   =
lruvec_del_folio(T)
> >>>>
> >>>> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T=
 from LRU list.
> >>>>
> >>>>>> later:
> >>>>>>   list_del(adjacent->lru)
> >>>>>>     next =3D=3D &T->lru
> >>>>>>     next->prev =3D=3D LIST_POISON / PCP freelist
> >>>>>>     BUG
> >>>>>>
> >>>>
> >>>> Why does CPU0 still see the stale link from adjacent?
> >>> The staled link should be from LRU since the folio never be deleted f=
rom lru.
> >>>>
> >>>>>> Assisted-by: Cursor:claude-opus-4-8
> >>>>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>>>
> >>>>> I'm wondering if this has been broken the whole time, or if some re=
work allowed
> >>>>> this to trigger.
> >>> This issue is from AOSP with v6.18 which just supports big folio in
> >>> f2fs. Besides, it is triggered by the timing of f2fs's partition get
> >>> almost full during the test case of filling f2fs's partition(should b=
e
> >>> the trigger factor of f2fs's gc which enroll truncate thing)
> >>
> >> Are you able to reproduce it with other FSes supporting large folio?
> >
> > Sorry, I can't so far since only f2fs has gc in the Android system.
>
> Have you checked f2fs gc code to make sure it is working correctly?
> BTW, what makes you think the issue is related to folio_split()?
> Can you elaborate more on your investigation?
>
> Thanks.
>
>
> --
> Best Regards,
> Yan, Zi

