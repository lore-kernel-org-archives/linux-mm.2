Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E07CCD19A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 00:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8098E0027; Sun, 16 Nov 2025 19:53:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2788B8E0002; Sun, 16 Nov 2025 19:53:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141128E0027; Sun, 16 Nov 2025 19:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFE258E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 19:53:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8511513B4B8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 00:53:52 +0000 (UTC)
X-FDA: 84118276704.19.AF01C6C
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id B02B0C000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 00:53:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ui8jDn+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763340830; a=rsa-sha256;
	cv=none;
	b=R/BL4bArMoBL5xjJA+Z2p8vzY0KrBDGkpv2inHvtiRc6uakBasS6ZaMENaI8OUi9a3AKFl
	AHGfEgYBv5Vh+lS+k3JYXtPnvo7x2EjWPvYNosiX5rt2U4p9ne+ZJpBkETEErT8cCgwlKu
	/X0TeXXR+U3rZ+YpG1sE74mhfUMnvEI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ui8jDn+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763340830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUUKmIT+3Y7jaIwhjA5RkVMHzmBdbQPoW2dXEuh0Auc=;
	b=XbNpnI3EtKH+YOoKW+EljSUTy4PDzBcPU9RBMYBOGay2J/Zt5K1sfswkKzSnWaVWubwWey
	iJ4M3OlEN+rx1ZQmsOPyMpeEEiOK6UTtIb3clg95BnRxbK5XS7o7468n7VWMDV1NfSKbAy
	eYq0LjI3ljHAR48VXxvjTOrKVgyqVCI=
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3eae4e590a4so348057fac.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 16:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763340830; x=1763945630; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUUKmIT+3Y7jaIwhjA5RkVMHzmBdbQPoW2dXEuh0Auc=;
        b=Ui8jDn+fXI8w4I075PGVdm0EeAxYL4Qg6KEA7eSOVuEJhr3D9Vs10/HKcBhYofMBIV
         kJDDIR0BoB+ijixmt2zL2sdLXk0qL3YCChWVh1iohnNvebBit/bq63DMmXO/RBJ7sCf5
         xHRCyMFAVVXRhmcZ2wgQ//7fyjVga/un7TrBc89ua6c/oQ0tQGUhCjgGaIOPtUhc8agr
         lADGGp0ktYeuCt0BdycclcVmMURw5XbaMRcX6DcJRecfa/KBiScBYWQB2q02OswmE3XS
         Cwmj/7zB0x9wNXRISccVOwgQ3jHRiSunaZNDRm4Csls/WQ+U4M1L63DQtH2Poz8PaLgG
         CxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763340830; x=1763945630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JUUKmIT+3Y7jaIwhjA5RkVMHzmBdbQPoW2dXEuh0Auc=;
        b=jhVxt3zE0y2vc9L2gJ4TSHEUjVZ/Am8WYn4Ft3jSlNuJSMP8B0iSYQDhtg568QQfJP
         0yKDqbG7PuI4Aio99EZp0nYa+GSOBjH/4fpgTkF1CkQAsAxqT2xgiW3Fkshsiw/erkKl
         n1QzqbqN84BQ/Pbnu9NLEBli9qDtudFQPqOoPC583VMMSt8a8JnX+Z901eZ1RX3Xz67K
         ZOn2cBn7/vBYuWVr5mw0XmyKEkEA3nfMWliTXqwlT7L2HvwJUjJ4e9CehtH7LGJeih0x
         GIzHNoUF8I7z4DJjdhf36Agv6X9qqhfWdJFegv5IuJVGPQ8KYHyy3/9C+huhqywq+7fO
         pzJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYN8SlA/3K2GoW5gwaOl65KlF0Vo5MnKqVP1EsMbQaFZAuFJorYdou2BLHrnYXq7iutxVPMsVaag==@kvack.org
X-Gm-Message-State: AOJu0Yzg9AqX+JhMLacjmGpBPWJHrGU6g+j+GIr1brEwATjK9B73tcim
	eZCVWB666ZhvFCV9DEYw1E2DqsbgGBt7hciT/atbF37ELtISVYsTYeyYAYuE2F9ahHIjfMRpzmz
	YsFkQNE5J2x3b5QVPYyKrQxtn/pM16wE=
X-Gm-Gg: ASbGnctv3ymKxcIJqgXqK+lDcsaqa4u3LOH85B+vFNnV5QK5wZDJ9UB5ZYLVn0L/PBr
	Vbkj2NX6vLfyJkty4/Oijy/h+GsVP8jQh3J/poNILoXFUrRUPQJMQL/JEo3qQIji0asqU2V0KMx
	MYZlj3kJP0v3PasLKXwisPcKmd3yO4U+XNJSPBgAxiwzyiux0rkh6IT2TzkuvkLsQ691E13NHC8
	yR7qNSUrogD2GhOILZgTIib+nfpeMz3pRKlcwdl6bVwWi4j/VF2cu/6qIEbSA==
X-Google-Smtp-Source: AGHT+IHrkXT4ga0eamGpS2zWdQBgHzrdl6WIQctjh7LLswDTPHCsXKchKRw7dIqhqCwD/h62hyHtDeq7HcxQ60l93AY=
X-Received: by 2002:a05:6871:5d18:b0:3e8:983c:c8a with SMTP id
 586e51a60fabf-3e8983c1b8fmr2584368fac.37.1763340829660; Sun, 16 Nov 2025
 16:53:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Sun, 16 Nov 2025 16:53:36 -0800
X-Gm-Features: AWmQ_bmvX0uDONwlpbm6Nmh_pn01wpbgH5cINsWTUdb8ce5wvGjqGcwxvg12ZoE
Message-ID: <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, criu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B02B0C000B
X-Stat-Signature: bqk1414u5ey5e7bcz5d5honsiz7fqk1n
X-HE-Tag: 1763340830-548524
X-HE-Meta: U2FsdGVkX18lt+5bk0l2QtPOMtlti9eJ5xnVU/eN+a3x6xKqIin9OKeY0T13GO8yVoZPRL7BROjLsM3kIis2bjeRAhq3FS/7U+bY71CwJS1x/DjQTcbIPc3S0buGHBcvaF8FSywa4ZH7xWYJzIxVLS+hbHSxpBTwIlnQ0wlQ2dDp0xtQKqs48xkbNCWktSfOkM2h15N35Jq4RCVULmN3gf9XRYZffgmqJiMufc5nkvRzi9eMfPsqcVf2iZTGpdKatJZhseRyMPuwx8/7rFvnp/h7ho1bem87fymhlqf+Hw0olQWTp/o1yUMWPu03yt8Lid/3SzORJWlnnmxANTQhWhMZaYkNrGAeDDnnskTEAG4970UHCV2Te6bm62VPcHHyks7fv2/9EymgdS8bLSgy55PzsaVkyAUz78csQHaFQIJS+TpCE74CIE3dqyXujKgsFiZWyfUVFUeSBX8iNODNUphCFXqjdSqinFaGv6gfnjUtM8JQrGCEHj8XIuvD2xBgLnSnAFQdd2XiUvVyKYVyxB0AmPgxwuoKGRIJuUP1DZPo872B+kz7IJ6L7u9iZRQmF0ur89c0p5FOYwxqdwEhAjjaVWDEEngmwfsUjvaX2iXpflrve+2KcmQSgqGLJOMODJlnqiyWauTK9wzfrngSVvw0cZbxY/ABI/9oy1D9ykH6TX3O264hSTJsqQ1QG1TFyhx/qvckhdcSc+VT24wolnbBXyk5hc53D2PsT4NfANdZCSTvD478F3/hNTEl9c/4stcf+emdHgMkK0S80VkIh50bN9qrD7tj8gAFQBIqbg1U3JrP/tnwvUcnvz+MxxmYJL7tUvheRWJCqgs43b1pixKofkloeXUjGMJAA981FjDLlAyHieD+5LEVQcuwGOL46QB57/q4fE8oALE54bS9Fry2no7hrljGu61l0ksk0eATD6sk1TcfUDNDHWD2mOSVGJiUoG8ZWaIZFV+LZgV
 /f/SajPe
 gsxzTzMAicpTATSOXJVgO2w2bzmw90tYwXhlEjp5qJuJ7k0HHWx3YWo+nHDoll9vkV9VInqf2+vdMZiNHPs9/MBvqBn9HASjk/xCJfxTp1K+cD14ghQChS9ljnrWN9NJA9ncZjfGzQ+n2qDseatpaaMCDfe3HX6STf20gdLgSl+jxK6XDjEjTZJZKQzL9Iwnd+WUloUOMZp7eqhkcnr41LRTKLTTrm05YstwgJFE5/ZpzJixifEGWLJom00nG/fbVuRuo8VVK3glifkWfJAD0OItsVdK79zkqSUKm8oxiOKOW+HjHkL2vkj/XKWGojQqfLA4X8M4ICj3GwVlCbkFDjZFR1SUSz7Dx4Vszx+yqql+JWEXAY5PWxL1DKQ/2zQWBZBvi4fViY/AC/knu/ER/bcLzAfmPJ07ZunssGCON9PmtlqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 9:59=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
>
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.

Losing VM_SOFTDIRTY is definitely a bug, thank you for fixing it.

A separate concern is whether merging two VMAs should be permitted when
one has the VM_SOFTDIRTY flag set and another does not. I think the
merging operation should be disallowed.The  issue is that
PAGE_IS_SOFT_DIRTY will be reported for every page in the resulting VMA.
Consider a scenario where a large VMA has only a small number of pages
marked SOFT_DIRTY. If we merge it with a smaller VMA that does have
VM_SOFTDIRTY, all pages in the originally large VMA will subsequently be
reported as SOFT_DIRTY. As a result, CRIU will needlessly dump all of
these pages again, even though the vast majority of them were unchanged
since the prior checkpoint iteration.

Thanks,
Andrei

>
>
> Lorenzo Stoakes (2):
>   mm: propagate VM_SOFTDIRTY on merge
>   testing/selftests/mm: add soft-dirty merge self-test
>
>  include/linux/mm.h                      | 23 ++++++-----
>  tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
>  tools/testing/vma/vma_internal.h        | 23 ++++++-----
>  3 files changed, 72 insertions(+), 25 deletions(-)
>
> --
> 2.51.0
>

