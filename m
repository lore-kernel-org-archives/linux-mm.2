Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B93C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E2B6B008A; Fri, 25 Jul 2025 11:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F126B008C; Fri, 25 Jul 2025 11:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964D46B0092; Fri, 25 Jul 2025 11:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87C196B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:27:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3184140818
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:27:50 +0000 (UTC)
X-FDA: 83703167100.13.1E3A3AA
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0AB74000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:27:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gJbZ8eco;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753457268; a=rsa-sha256;
	cv=none;
	b=S5SWuGubjSgJwvsRqBgzjDXYk6yfwohbVfHgP1H+0um2LqVM1N3zrL/CKtCAMbCxAW2PMS
	hvMJm7LhCvK8BOwcSSBmM77CNzMziRZmexiPNKWQKfQfYstmyJvrbKYZdjp8ijERYGCaQ9
	dGuemzbI6jfaTVdwomjDTEGUzf9QKp8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gJbZ8eco;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753457268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heucYa9tkBbiVjSZTaVAyzcUPy+E2SStTDCL3AW7JpY=;
	b=GsirwKGC2L9UP89iNSy3DBG7HNCanLSMtr/IvaaWatx/oqBqCdZbx/kRZi2PpPA05bAT1H
	x714URJPcEfN5eo3h45c8/ebOnXi7O4pt6cghWbNCEmmNaJCQSH7PAsZnz/0H/m3XBOg7l
	iAMbrQorDfhY2f8yV5oShaR7+pzmqh8=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so9449a12.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753457267; x=1754062067; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=heucYa9tkBbiVjSZTaVAyzcUPy+E2SStTDCL3AW7JpY=;
        b=gJbZ8ecoabVbVgbszuloLDYcMf3pdHbtYnPRm7PBznz0liGkKM/HzgM6V3M6BmhfpS
         ypH7j2EB9BraSk50X0JKlUdCb6UjdwBLX4hI4lSVK5OkFjH8Je4urAllFSRuxhU5g1dx
         nAyUvOEtDnbHJ5AQ2yYyUP4x09Z05+km/Yc7lH5DwWTIEjzd7bvHnYb1hsqrY3DUmEZX
         HoefLD1sxdsaoxeUjqzTs6PE21po6aoKyk564l4ezY19qZjfi/qoE9HRKdrWoR2rl8fk
         +1+3laikeOT2erT8uuuhsXKoekw2TyqetxHj349YjHEECJuE14CUEWMKm33gBQIbaFsh
         NsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753457267; x=1754062067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=heucYa9tkBbiVjSZTaVAyzcUPy+E2SStTDCL3AW7JpY=;
        b=n7dxhi8fveTC3HcQ5BcQqS91Vs4sckG7DX2vd/e6xGFHPXLIdovwxoaWmZuNRuN6zm
         0fZOTnopv5/wFreIkbpwtykpmwsMyjOo3lChBRGyuiWtLMWqOBkfJEcPK19RB/qwrZ2R
         /J0X77MWlXHKRfHQo2gl/9Xm33e1PNCntbXogd8RmBzMh8LEMw6Q6uC2UwUyRHrlqjG2
         t1MiUsaYgClz8c4ei9xWauyEX0kGBKrkhq/MRuUjUPhd+fjzTx3lmYWWArT1eB3MrXKL
         cq6st6/Mt98XoqzlY21Z22Ntpp7nZGzp6+Gf8B5IJOV8jzHjOyfjsWBR9mdovrcV1XPs
         U+Wg==
X-Forwarded-Encrypted: i=1; AJvYcCVYVCs1c4iF9qBPEFs0sneLlwhQdj+EO5ZMwu+zmi2Yu1Lbh0je4GbgISt2ga1aUPZVCTdM0FtyoA==@kvack.org
X-Gm-Message-State: AOJu0YzDdYDfYhDtSUTpB3E+TwCEx8y/RH3s/X1kgOTSKAOuHsA0LlFn
	omMuGVz+2uHyv1SFHFahf9UTCQa2DHhCXu935ML3F4DUc7fobXu7Tbl137oj4U5NwL2x7Odx0m6
	NmcaZFZdx7MVcYtDa4abe7cNZb2s44rNHx7JDclMt
X-Gm-Gg: ASbGncuwZlKMoLoYU1tx7ONtTqEzrVU5a4IZ5MPpExMSHR6TxH/5ayR82ha2CIOiiSy
	y/x2qp4BQBxU0SUEaerl9Ss6PyrnKTaELvtD6FdcTgtXdi8WT2l4MS1s+W8AIUODLYNHddTRTH9
	ygJwSSj4wSZ2e3zOBxzTuGB0GoTOkZM+oQ3226GgDD8fauWCmv1OpWFITPXK6nVBpT9ObZAWMXj
	/kdHuH4HQaGEDG8j1+gFi2vUfrEQjKky7l6eLaa/sO2AA==
X-Google-Smtp-Source: AGHT+IHmROIehhbYRxV/sAIn+yOhhSoj9REcttU7TNQcIOB5gzW1Kdwc/lbrdBYUHkCFLf9V422ymNC0rUd8uXdmbiw=
X-Received: by 2002:aa7:cd50:0:b0:612:e537:f075 with SMTP id
 4fb4d7f45d1cf-614ea7376b0mr81054a12.7.1753457266917; Fri, 25 Jul 2025
 08:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local> <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
 <50502c3b-903f-4018-b796-4a158f939593@lucifer.local> <CAG48ez1TOULrpJGsUYvRSsrdWBepCJf9jh-xPpurRUXbMmAkuA@mail.gmail.com>
 <3cfc1146-1b62-4b04-a2e5-997d10ba4124@lucifer.local> <CAG48ez3aiXUmCqu2i7g6qrnVmZ6PRUsA-rQzHX1r8SXeYh2sow@mail.gmail.com>
 <f3e77eed-10b9-4197-b381-91c4ea3fc576@lucifer.local>
In-Reply-To: <f3e77eed-10b9-4197-b381-91c4ea3fc576@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 17:27:09 +0200
X-Gm-Features: Ac12FXxX-E0pa4qnmFlZi3v7jA9BWeiJRqZSsm3ywM6zYCVg5zIWDC8jcXl38BI
Message-ID: <CAG48ez2U5SSpRANKmUHmZkj62tDa3tYA06jem-i0G3pDGMJToA@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0AB74000C
X-Stat-Signature: d61y1fznfyy6y3aeo4maokfxa555otro
X-HE-Tag: 1753457268-198584
X-HE-Meta: U2FsdGVkX19BcELuImVzxiA75kqQRblv3FqWWpzwOiXoHh6w8pdDzQ4pCiD8eXs4hBaztkYAVp3I4slx6yfLhxtR6FudK1Kt6FEG80M1SNcTrPAOO3oRye1SnxOS7y2mLPfFBReTPdA6fwvMBt5fo9R4vj6iOv9co0NS/Q7fU/xsQNwbQfzmH6FwxQ+oANrPlCAHju+BOXOqc4c950frmubXQPADWR8UzlwcHSGqQC/SGEO1FInVa/fRiT3ADE4MC1adPtXSzmu6xXF/UQYb1/j+GHem843/oLgesr2vmz2teHyAOU/ja8ZIszzGxnYFEvvtpQ6I/4OdJ/1SD11wzEjaBPFi+NUyXLESWkHWDWq0OM5jMN60B7yma3UXZQTXNwscTxJEL+92kFCVfSQlRle1YpUtf6SZgZrgqAeJOWa4w/7XLZkJUrgIRHIAAVUGyxTJCYgaT87w8M0RvFRfjgUFnqd6cLVzm820bqA8mZ6I05I//hG+5Pn2TQabNUiXDmrRxtGQjk+4bFlgfCEGg+6PtPmSHzxCvsuvS76x9jHgO6KZ8FfG9fC/g8jNIcuDQmlc5yeoCb7THIPj+zdOwIKBdIXFDDzifxQaufgwoMCnvvGpV8YZRP/vEx4Cp/fGLGoS0/cTYWhzYVfT7ikA0Gy88LcCLiuSSCpJihQBOvALXK8slY6b3gLAHdlzfoZDxqyTWntmoVba5quaPlzshgb/XiIOP9N5GreeC86knYpU9JsWZEcCGVrOgR4Ach+f6CYxerq9HaJyJpWB6cFYbKWJS+YrFu0K3FU6L7dheo1QRMdgZYLyeo9QkZ0WBmt10xXOawZWj7meYEXoyfj+Hfk3DVMsBIoounJj0kUl6QpHTKcP6t6r7PocKK1OYx7rbXcX7nOhfuCvI3Rhaah4KJ7lj6+kzEin6grIOROqLrA25fsJw49WrYmR/c6SLc+DS7F6cM/zKQZeSOBuwHz
 5Ly9FWDm
 V7JUbPCjYQY/ur+bIfP7VtjmQ8g12jAx/6YuYt0Y7nTIrGxFLej0CrmAOkehW00MTuUxU767UQy9NtHkFZzOc0Ycv5+C4dTUMK+bOcv++nLe7vsdKUWnHde245E8mMHXqJx9xYeFnqSdd+t+GKgXC2qWmfgMfTzU1+GjjJYA7kzj19VZn2LclbDaRqbwGK5VsxCdrmOAOy8jaDRX29TXq8iJM0Hr/BF18Q5BZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 5:22=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Fri, Jul 25, 2025 at 05:15:45PM +0200, Jann Horn wrote:
> > On Fri, Jul 25, 2025 at 5:07=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > Basically CONFIG_SLUB_RCU_DEBUG turns kmem_cache_free() on
> > SLAB_TYPESAFE_BY_RCU slabs into something like kfree_rcu(), and this
> > allows KASAN to catch UAF access.
> >
> > > It's surely only UAF?
> >
> > I mean, "UAF" is kind of vague when talking about SLAB_TYPESAFE_BY_RCU
> > slabs. I am only using the term "UAF" when talking about a situation
> > where accessing the anon_vma object is entirely forbidden because an
> > RCU grace period has passed after it was "freed" with
> > kmem_cache_free().
>
> Could it not be either case? Or are we sure it's been accessed within tha=
t grace
> period?

If there is a bug here, it could be either case. The check covers both
cases in CONFIG_SLUB_RCU_DEBUG builds (as long as the object hasn't
already moved all the way through the KASAN quarantine, the usual
KASAN caveat). Note that atomic_read() implicitly causes KASAN to
check that the object is still accessible.

