Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E39CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E82C8E0019; Tue,  9 Sep 2025 22:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971908E000F; Tue,  9 Sep 2025 22:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887108E0019; Tue,  9 Sep 2025 22:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 723AD8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:56:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14CD01DEFD4
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:56:59 +0000 (UTC)
X-FDA: 83871828558.18.C9003D4
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DA7640004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:56:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AT1NNayl;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757473017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrGyG66Zz7xTWILpFo3YOH6zYqrmFzQUSQypRWnmJ2Y=;
	b=UDXshxeNRELbiiZKJVbwDJSfgdzOlfomXCoebkPWrESjOquilrxkzJ6GpGzukU5oXoDk9T
	B9RGS9xJI1/gH3yucp/+nW0aKtw/8lrBPx4wqjjaEkIf059p+/vvLofW9DwlwKxgJujIEl
	sfKZwax3dGZ4aNsVnqBhuRu8CHhlW8c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AT1NNayl;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757473017; a=rsa-sha256;
	cv=none;
	b=Hj/cCbCMZ49txSx475rslGuB5aSNGk7kVKXf6Chlbwo0vo3nANovDyd0QjbuUQgPVSFwiV
	CuArGyoRD5/eE5lHfQCp/npJJTKPGRTvekKuLopARJ8P75wQWM5mSFrpOPMSqAvsg6tArR
	ytg74DJym9BAibRBLQYyULHG+driIos=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-625e1ef08eeso7285775a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757473015; x=1758077815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrGyG66Zz7xTWILpFo3YOH6zYqrmFzQUSQypRWnmJ2Y=;
        b=AT1NNaylHH+UnGsZ+h2LC2pC8DwEWoTvxjzdrtc4fvTqoxQg7ESXb2OFCt6O8sTUyG
         iOFfychK+eS6q2dBhZ3Fb0kcghG1mvMiqLtg40tlSCXNVbtIjMX29XCmqp4SQSTBdqt6
         YaWzQDvEA5fZuGzYroW48fqZ4ev2RtNYD2PgKhcbkiS2xlGhsJtnLw/GyVawbEd22Jg/
         o3w/HMhrKubStUt+ED4faWasK42mmwLrp4m7fm4a1uF9vPHWTsZ0CvakGKxOVBcG41ZS
         r19sSHbDgC7tNvP4XN++oQ9s47ubE0z5M0rCgI0qGX6oIKB/ov2bOtPXGrsQCw0jRBGk
         51bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757473015; x=1758077815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrGyG66Zz7xTWILpFo3YOH6zYqrmFzQUSQypRWnmJ2Y=;
        b=fp4QgFEUrd0IZxGMJtFn+xWpEtobONYr38pLiZzGoUzMD/83b/JTJSLIBdVscnmPxS
         dK8Nb1m2pjmz+9VyvrybWiM7S59qOjyAKoWccJLbXCGhOPWflvq7kVCHcQhgS1T5y2zw
         3OAKNXMHKc3O4+AD/J8HTyvSowkj7Mm/bmO8I42HXxq1oAcIFz3xTD8io3DLgVFsVsZS
         PfIZwPxw+qtNDD1D5togwD0H3KXFf+IFoyX+E+XeO/VkFonIpLkY6fRYDPOAc2nwWsR+
         60l3BFE17bUrCmx+/JJd9+mzQBIujvHUSwaYDHcE8MS5hK6ufw38TwsB/ha8SHlGTySD
         iazg==
X-Gm-Message-State: AOJu0YwDSHzWD2Gnvv2MSJ+dgZKndPKoWbZ2Dfpw2rex4mNb0u9MgjMx
	90cYoeJ1EfM9fqtU4NHDQXcPx/ciXen6rRbIBVV61at7+/xZy6Xa5rYwGqVq1no9Fr9Eq1110tB
	f3912x3FYGOCMnZXeVhScEcw66iWFBfA=
X-Gm-Gg: ASbGncs1QsqwvK9XIouetUQwaemsESYyaGL+0ekPnYVVgZ5hq7un/JbpARAbLyNwYo8
	S+UR1RbI0wE9AeX4L8ejcDhbd+6+S1rDkvRDmcXhhTsw54sqRHDwuzgmQ+VbBLut9g1BjC361Tk
	CvRSt7ESTcv4ZrTbu4pf8vHmwhU04pHBg+ffHUxS/dkM08wPe8OJc+t5idlJok5wKUrkXjRxBLy
	+gPitg9SSSAhDJsHe0YvQ==
X-Google-Smtp-Source: AGHT+IHjkD97AbYwgHxhY6BZHaDg/uLduF7f3nRFFMpbDeYSOHPOV6nGvSYKzsNcrHoOkWugUDXE2os2N/uaM92+m78=
X-Received: by 2002:a05:6402:3589:b0:62c:62e1:8ff4 with SMTP id
 4fb4d7f45d1cf-62c62e1986amr3286599a12.23.1757473015266; Tue, 09 Sep 2025
 19:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-12-ryncsn@gmail.com> <20250910025315.109884-1-sj@kernel.org>
In-Reply-To: <20250910025315.109884-1-sj@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 10 Sep 2025 10:56:18 +0800
X-Gm-Features: AS18NWC--jKgTPO8qykBZ10aNTJ4ysuxn4mpZh-qs_f-Wo4HnvYwrqhg0W-D4vU
Message-ID: <CAMgjq7A4j6xCjSw3o=9UDYMUgvqhKscCuPMqcAD_3zKAcQP6ZQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2DA7640004
X-Stat-Signature: c5d6b7ouz6ktxn8q76xangyzkqytdrw5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757473016-18645
X-HE-Meta: U2FsdGVkX1+UsOMSnH5XxMGv0IsJxLwZR/hkkgWL3cX6Hjso7bc9ZjthSMlKr1ONS/xoDbs2ho8G0VzKtZIjtT+cMsD6do50LbPdEHDIB1Ceh0eXwSXnfkMXhG4GivQc2tkphNYTwsAR3cCdgfqRezuSYJ2kbUA8F1GSS4kbaOxln3cQsgFeDwYIxBw8iiR5BpV68X0HkTXK3Bmz3DojKAbb9lAvk8cfyWq/cu5leSM+tqmNTbeOvAsX5G3lviDOcUnxmfIASb3vkugVVdFWFpkqfKLByVPbJqwa3MRh8/FO7MuPp6vrBavZQFUC/PXC+eNFqVd+QJ6qKueV57bMCeMUVVXatyxxZCTyz+AIDMWahAkp9Z65WVLe9n11Uq87KKlQY6fkRwOHTNoNCyDb0ZR7bHawpNm3j8CoW+RC1rtL3SmFLVBpgtneYrsGmA4m17cNpyONzDsHLVkdWNq52A1BkH4H3yhghRYEO3AdvyOPa1WSdLxlK1roE5jEq7aERxBQEobhVRtPg4mRWhB0KslD0mzl4C1MSf+FQ0I0HxkptaQ9Ck79prEqC5XBrv0Al96YUhYKAjBabhVUahSBFNwoXU7xU+ZQ5GbylA5JlRC+KCRrCLIt9DNzbcqkUzmIyiXkEHfqxdBdqApYRxQWC2wczIYxJvJVQxCkyo65JPBakfqPID4Z7jXqbUX++to2PdHn+Cvl/bpatyXbnfPlOhrKgO8Y92ULyQuIqA7jypK5fcnPOJsV6NIo1b2IJx4eJieVzOT0GwaJimQJ5GavG2vQN8u52iWmtr32NRvYuQBstsAAsY1Xz80pDMgOk59P4rKvmcSGkr1x/MsGUUkMh5bq9dIR8d+IESOAz4GNeP0vTYGz/33kuhtF2ibAt0QzcZGTPZ9ixzjZfqynQNddfSY9DWzHQMdxeRGRvmfRHXmeGbdxrPEYtNbTOQ0f6AtP+QkcUTsmJRfQa4imz3L
 pQ3OSFQO
 K2bF4vgd2eXDzoPhwo++h19aUDBXO100iBTuSFgKTpdhAZGW20OVMXa6aHZx6g4JgdOG+IbnfSFSgvzL5EIbrb064fSFbE2RR8kMfIhxuOpWTMIjltlCDDDJzyYPCeunEO1oBLuEX3yLRP+bt2TMGvOQMBh9urZmzUI7exlS3/nw2goVhEFDBgQ9pTGXDiYkZBru8DOqXMKvpCjRvtTYGHbXNMeuNZxdphs8VGVfaE4tVihDodsgQA8pqbfP2T2VsCw6MTVcasmR/CzQU5V/d3iSedR/AAmuSxPjWvZUDJnjoAQKksOXsUuubcOteEgr/Y2WqrNriVdkC3QD85xnJRaVUFVxR3jVDKnUgQ433dYn2JqmkznIXCzF6eymkhyalQP3LwwYRd0KEsO8PJf9qR0F9UCpFsxFgAITiNdG/xsmD8YZhIfoqToNZsiZdtJUQzA7JzpzcG7AVXVlHkpfjGhQhjv7Wh4R+OMyc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> Hi Kairui,

Hi SeongJea,

>
> On Sat,  6 Sep 2025 03:13:53 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce basic swap table infrastructures, which are now just a
> > fixed-sized flat array inside each swap cluster, with access wrappers.
> >
> > Each cluster contains a swap table of 512 entries. Each table entry is
> > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE)=
,
> > a folio type (pointer), or NULL.
> >
> > In this first step, it only supports storing a folio or shadow, and it
> > is a drop-in replacement for the current swap cache. Convert all swap
> > cache users to use the new sets of APIs. Chris Li has been suggesting
> > using a new infrastructure for swap cache for better performance, and
> > that idea combined well with the swap table as the new backing
> > structure. Now the lock contention range is reduced to 2M clusters,
> > which is much smaller than the 64M address_space. And we can also drop
> > the multiple address_space design.
> >
> > All the internal works are done with swap_cache_get_* helpers. Swap
> > cache lookup is still lock-less like before, and the helper's contexts
> > are same with original swap cache helpers. They still require a pin
> > on the swap device to prevent the backing data from being freed.
> >
> > Swap cache updates are now protected by the swap cluster lock
> > instead of the Xarray lock. This is mostly handled internally, but new
> > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > few new cluster access and locking helpers are also introduced.
> >
> > A fully cluster-based unified swap table can be implemented on top
> > of this to take care of all count tracking and synchronization work,
> > with dynamic allocation. It should reduce the memory usage while
> > making the performance even better.
>
> Thank you for continuing this nice work.  I was unfortunately unable to g=
et
> time to review this thoroughly, but found below.
>
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> [...]
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> [...]
> > @@ -367,7 +452,7 @@ static inline int non_swapcache_batch(swp_entry_t e=
ntry, int max_nr)
> >  static inline pgoff_t folio_index(struct folio *folio)
> >  {
> >       if (unlikely(folio_test_swapcache(folio)))
> > -             return swap_cache_index(folio->swap);
> > +             return swp_offset(folio->swap);
> >       return folio->index;
> >  }
>
> This makes i386 build on my setup fails, like below:
>
>     In file included from /mm/shmem.c:44:
>     /mm/swap.h: In function =E2=80=98folio_index=E2=80=99:
>     /mm/swap.h:462:24: error: implicit declaration of function =E2=80=98s=
wp_offset=E2=80=99; did you mean =E2=80=98pmd_offset=E2=80=99? [-Werror=3Di=
mplicit-function-declaration]
>       462 |                 return swp_offset(folio->swap);
>           |                        ^~~~~~~~~~
>           |                        pmd_offset
>     In file included from /mm/shmem.c:69:
>     /include/linux/swapops.h: At top level:
>     /include/linux/swapops.h:107:23: error: conflicting types for =E2=80=
=98swp_offset=E2=80=99; have =E2=80=98long unsigned int(swp_entry_t)=E2=80=
=99
>       107 | static inline pgoff_t swp_offset(swp_entry_t entry)
>           |                       ^~~~~~~~~~
>     /mm/swap.h:462:24: note: previous implicit declaration of =E2=80=98sw=
p_offset=E2=80=99 with type =E2=80=98int()=E2=80=99
>       462 |                 return swp_offset(folio->swap);
>           |                        ^~~~~~~~~~
>     cc1: some warnings being treated as errors
>
> You may be able to reproduce this using my script [1].
>
> I also found including swapops.h as below fix this on my setup.  I didn't=
 read
> this code thoroughly, so not really sure if it is the right approach, tho=
ugh.
>
>     --- a/mm/swap.h
>     +++ b/mm/swap.h
>     @@ -3,6 +3,7 @@
>      #define _MM_SWAP_H
>
>      #include <linux/atomic.h> /* for atomic_long_t */
>     +#include <linux/swapops.h>
>      struct mempolicy;
>      struct swap_iocb;
>
> [1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build=
_i386.sh

Yes, I also saw a report from the build bot. I tested !SWAP build but
didn't test !SWAP !SHMEM build.

Adjust the include header then the problem is gone, I'll send a V3 soon to
include this fix.

Thanks!

