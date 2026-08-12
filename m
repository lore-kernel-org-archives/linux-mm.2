Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475D3C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204376B00E9; Wed, 12 Aug 2026 09:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4576B0285; Wed, 12 Aug 2026 09:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE096B0287; Wed, 12 Aug 2026 09:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB3B36B00E9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:38:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67F6DC029F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:38:12 +0000 (UTC)
X-FDA: 85092721224.07.89BA3A6
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74D83140005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:38:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I/6ep9ia";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786541890;
	b=77DlhD5zwopgZWUVVRRs8366IZ+pJ9kKL0otFDxCotGDDeMg12w6UnSV/UKqnDPruSpCkl
	sdhCVVJIt7K2yt+dZEdDfzVXr4dB/gvaYj7mEJMOzTPgn8zkEwTUUv8pX1QxhjOjDHRTIc
	6XiKKnfdM49W7M7lvm2hyujBeQVKobY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I/6ep9ia";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Af/S8eLr9zVnK4LInUNnEDFqmidhuoOMIoXFwHiIEnw=;
	b=xawteH56w8H8Q9fPOe+z2BOrbkWobGd94ai6UuNofARsC4hHMMicPkUSOYoa60418KWmN1
	XUekJf9b6WBcofdeLPaZf97wyrgK846gIDbRscXRICeGgkwgJka/fUYGB/6KZ3oy18XWYo
	Z1akORA8BP+1PXkmzHwwNWiNW1EWiSo=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c01c79467so217611cf.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786541889; cv=none;
        d=google.com; s=arc-20260327;
        b=L5SYlwkcbXQTc5L1uRGLI7yO7Gq4nThxqF/qdRhwPTTeHuMN7c2+1NvcrGbiAl8NIU
         vNQwZKHAXYz5UJjJMyiGE1RPUCp4N/cXhGtfK9WXW6Ir80zoKkE/1IPgwuRyMrLD8T/i
         ERIfi6BIAu7aeqUvOZkDDTE4klHwpzYeKafjW+UXgQCfl7G3w6lxc1iX60UGSlPLkkVZ
         WHhiX62PeBGqSO7+6kb2BY57l03v/Zzuib9e9SQHQTcVGfTtGS3depvqSyGpPFlMA7g5
         rRKdVb6P3ulOCJ6746ZniYqVYVEw+MwoWAsGajRQAW0uf4BsOb6M3iU8VwLcVBk1UDzf
         hRVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Af/S8eLr9zVnK4LInUNnEDFqmidhuoOMIoXFwHiIEnw=;
        fh=0gSCzR+HH/8tYeTRBLQuuHUHSPy+PXtF0xyz6diCCRQ=;
        b=kzR4gJ+xv1HFTjvkHuKYO8Z/eelOiWwSKjjFkig13+bUFiLjkEID0ZhD4V62OY1EgN
         xTWQUIdDb67qSiUcPN8dDDRjm67SKDKEZ3QTQVA9Pzo5zL+0aXNCCw0dj908ZleirVSY
         9CsAG4xv79FTP63JXo86u7NKbKCbEwdbaeabvhBsV60+KgMaBHlkWmXrTS3E6k547JhQ
         0q8u2jtRwDKTqL3aphxAsyEpZD1Oea5K83sJOm04NsWtfkoJoO5JGGtIiWENisZuRnce
         pYLrQ9Ywfv/CZwIbjZgpnXzuuYwCVhxOsO1BVFdxpI4j/DLpGI9ZRL/0UIKGs+MiFJaJ
         5Pjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786541889; x=1787146689; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Af/S8eLr9zVnK4LInUNnEDFqmidhuoOMIoXFwHiIEnw=;
        b=I/6ep9iayX8qasQwA6gm9kf39Fuj/499nXMK6PzHDuKiWpeFIel/4T2SdKByfVc8a9
         2K8fimVHTmpBlokQLiUVhOpIjju7dkj8bXfK49ctn7ugpz1gy1MO0X3NC/+0JqhhAIas
         Y+M8fhjq3EtbRORnFlUAWISc8N/g9kC6tKrkhGSmXvVxyhmIJSuG9kYDNF+u8ibZdEMl
         g54opt4wHulfoJobSz0aEtRgoANREvdF2fIr9jF0rPmcmRGPqA1VgyG6CKnqahfxQLZE
         JnQHhG4Ys33MfXHAmgT35SLqTiMwNFqKDWT1kHVfBl1QIo0ti5PMamGyNYaFwx25LldD
         vysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541889; x=1787146689;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Af/S8eLr9zVnK4LInUNnEDFqmidhuoOMIoXFwHiIEnw=;
        b=N+iJlmPLGoiveyvqmAD0VVlMSGElyqnBbzisbB0SrvC99fbDn//+hX/W+WiElIyyXf
         DShKZ+vAbrxjHqKk0j33vPr5D4bedG8gdTrmI0GF22uv0kT6Y0E1T4AIu4oHPGQyMna9
         w+s6HPan9NOlfK+8BlPAZJRJfzAcdkbLKSR99l8i/4uNjWOU6ihysc4ETDUbk2r4wqMX
         shmygjAYnz/ehYh6qlhf9YKzAivPUCXBqLdp6FHVQ8iqgppZwn4dapy0zxVIHD5n0W8H
         FyB9r+dwR8rvxIQALQtJPZuS0A3wpMNKBq1XAsI7ZL3DMoEp9nrwsUZLPabHrcKM1A5I
         reeQ==
X-Forwarded-Encrypted: i=1; AHgh+RpauyG4CpRAhP/GdN3dc9oMLxvWxddvQ2Yft+GGGDCOlN0Us/YlQLoV+dNfsXBxfIWoe0l5rvkyNg==@kvack.org
X-Gm-Message-State: AOJu0YwpL/s7FJJkwi13CilYORsKfxoMoVKfn6qOAfW8aVZRkD/VfYHj
	SpnWDU+7GysUwOpvXCVrO541Dpyh78PeBL5O+ObHaoqqbG1450Py9F8If03aiZ4QA5Rb0dYQ7e9
	9NiPCmczyq7YhP5eW0V8KPwsCY12J8/eXYD0JeRc1
X-Gm-Gg: AR+sD13aKHQ8dk31efITD8oKOKnxaaYeR/653wRGLNVf3HbpuLzSHCuRNsBbvMJHmYb
	Yu0mKKb+yKQpOfBWeQRiB2eZnxKBqKTrmxOVsvaBmHhK92l3bw9lQ7OD2VzNalDml/TzY5hOAvB
	3I5ntpY43XH5Mh5d2XpD43Y2eVVQb6PPgHhZfrWkvWk+hgKbjBBT8DTe6mJp20lzqmBBc88fRdT
	6siRabPYBxRoZVOARm/EqjB/St3SEqowOCq2SeAm1CRRPIHw0C1Y3ky5eQi+xe+IdKJI7ICEk30
	o1q7vsIGSH948x0aZDquisqlRHrb4qZBOh+muunnt41uOD4Eiz8NGQ==
X-Received: by 2002:a05:622a:1e17:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52d61fa3c57mr18476801cf.12.1786541888875; Wed, 12 Aug 2026
 06:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260812011056.902771-1-surenb@google.com> <20260812011056.902771-3-surenb@google.com>
 <anxO3VT1JPAuSNf-@google.com>
In-Reply-To: <anxO3VT1JPAuSNf-@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 12 Aug 2026 06:37:56 -0700
X-Gm-Features: AUfX_mzbFA-KN8buPIyWzFvmXLKnb07ifBNN55GX1GEWXEY0xprOs_eMrg67EEM
Message-ID: <CAJuCfpF_3W8BwJ5rqWHABO_2N7Ow8qCbTMacGj8gLTV4mCUy1g@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Alice Ryhl <aliceryhl@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74D83140005
X-Rspam-User: 
X-Stat-Signature: nemomji35m7fisb4awr7ujydosf85k13
X-Rspamd-Server: rspam06
X-HE-Tag: 1786541890-433971
X-HE-Meta: U2FsdGVkX19vwnS3sI5jgfxrYP0eHeAOuukzFPP/7Dbge30/E8yjkCOyglI0fnsxMuTWLziSTEu0/Bd/uFoX/qDmsdy60dOgfyI9Qv7jrqbScT6TO2K5d8aGPdAkGCNDBpfYymDj3F8/86IG1xRavC9FNa1IlR9Mhd+uH154LZzUtT4GNXmHs0MS6lLlxt9zFBFjvKLJfVgBZukHvR4NQDgItfT+JXbYGzxnufsK3yn4Mt3h+m7hk0/dfzuEdVbsQ8EwHfLw5RLsRcPALb1xtxNyqK3MiMD1CIYYIuiPiYWFZWiWQCkTbD74KbUj+Px/1rt5kpoDEmll/xp9EOu/bcWO3pzBrZJrRQqhBtNhBaXk5ENnejKXZPyuv+5D98PGVP3cr9vmAK4rsBa8zHU9DtSAz7O+k7r7y9vRIMrNdsqIiR1/r5cGkRhJfV8iw8OaATtd1KMnq2Uf6AT057sSrpy3WafXSLSymKJIoWzUsa3zlrR+S6uv5G93Uhgq1Z8I7CfOOoyW8uA+dbS1FwvQ5KA6fMvIbj0OGGgbIIb4+8vqBT7pDKr5HVvpYwoqc1XzYNaVUK4BjAWgCdBZaqJVZrzo/rx+N15dxcu2ib+9FYeLEgSymkxY73LjysAq07WnqSw8mzDKFQVwoApNZpg3Gg8gydqQQ2MZpurcKZz38L7V8vrNs8AAg+CSTGIrJHuV3b718VvFBo5GDetOD6CK3HUiA2gg9AzoI43z2QPYGVbKz1krBa8Wne/sGCOEqrqH+Twe2r22Day7EMHjZEo/Isy3d9vshsdwkHQnS/nHfRMHkTSRhc6u5eRkvHdwiUuidDMdTiiHheYR9Nwvrhf+OzU5M/ssbvCi7FBGo+oEe2RuAWxcchrsV+pFo/Mni3+lDah73vV7SwOs/WYVVrvf8zpykYGG+JY20eeX/v+oMSIIpecxsgTZ/gA7tcaYYJk6/pe9nZvYF45S+/f8Jwe
 8pncMa8D
 ckU00uFz+PCc/GLPLFWxmyEmJa4x8B54VG1XNytEDx1nHSqNC9xRJHP7P8+nuGE0fQhrXVZAnUMSExZGJUrbd15OO/K7WpCRY+1mkPyfx/Jy6HYYv6hcbVlfcKUPzbGOqVUsNcG1gVPNMfaC2+QVDKBk7lBe58M2sqLC1ZKxrRljXX6thAhWm8X8ocClKEd89MDeeIkASA1yzSDwl4bSKizt0zj8tAPRUcyF8iaCvu/XomFFoDmk6+OMEeaOHopXqckZanDkwiiraJfFKFNbv1GX7igRI0c3TAlWtXNSCFuzVYssFO7oiv15x1pHxlTZtt9dChCd/aQ+T0fAlN8tmJQla/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 3:46=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> On Tue, Aug 11, 2026 at 06:10:52PM -0700, Suren Baghdasaryan wrote:
> >       return LRU_REMOVED_RETRY;
> >
> > -err_invalid_vma:
> >       mutex_unlock(&alloc->mutex);
>
> With the err_invalid_vma label removed, this call to mutex_unlock() is
> no longer reachable as it comes right after a 'return' statement.

Oh, darn! Carlos pointed it out in the previous version and I missed
it again. Sorry about that. I'll remove it, double-check I didn't miss
anything else and repost.
Thanks Alice!

>
> Alice

