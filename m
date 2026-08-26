Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693EBC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708A36B008A; Wed, 26 Aug 2026 03:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9306B0098; Wed, 26 Aug 2026 03:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8036B0099; Wed, 26 Aug 2026 03:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EAD96B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:53:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5AB11202C5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:53:28 +0000 (UTC)
X-FDA: 85142655696.21.69F0B74
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5D39C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:53:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Czto7XXA;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GS6w62IL/zxzq4/zoss8k2p0TRrsAsNyMrcb0qeyi48=;
	b=XS+fEXRKszGHWwRGp9Ua2wCBHfM67g4ypqzZuyzwftL1doA6InKkrWmlWz5/6PO3P0jEGL
	Fr2b+S+GkFEDKHI0DVHKPqocYEttq8GJWFjsJeMTVvKz3KrEXgln2IEcTa7aS9nH9EO/Nk
	GcPpsiEgDI9Si88S5DBGvNJ6vQbKOdM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787730806;
	b=jVhaGxT+nI0uysdGm93AGYZdjaFKwaXQ5+rEjPW17qJLQY9nkUDUO9trNfHFsvRYTHAEK6
	Cmjgwyy2D5Mb8aL2hGilKKRB9czLy35N8yCPwGR3cos2KstZDXKmSoDU4i5aviMb1cqKLY
	YBn1RWyEGgg7ETgZp4OWE0BEEgflK/E=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Czto7XXA;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-482e7093e75so2319f8f.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:53:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787730805; cv=none;
        d=google.com; s=arc-20260327;
        b=gkPaMkZ+u+qAvIFVPAFK+m8YutjcVc8BnHGUdzR6SOJyUsp5WB3+DmSItIKst+icMz
         +pn9GSwA0lqMGr0t8mHkdD2ECmvIp/oFko6+gYDpyLAiBSgwhJwWEluOCujhFDX0VBtJ
         hpcwohTkNdOWE0JGj5TiPGDB5P5rGueuCMAloaacodjuIREQp8v9nCuXOLsfZM1wT/5J
         OLRHZ54jScABD3mLYkscQOR8uCutjYe5B2Sz5zWwz76KBjbV7CClBdl4nZtVm6pp6VJI
         B3CN9xl5F6lQ+/p01M+Xl8LS10RkjTQSUGPES8XgOXgwqESyYfdhQ8S7CH5MrMwGJXns
         8/pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GS6w62IL/zxzq4/zoss8k2p0TRrsAsNyMrcb0qeyi48=;
        fh=90a1f2NlLKIfCabW1mddagHmuRpXwAKcjMH/VUpfaw0=;
        b=Ymc2rRyTtgeTCLpxNMhf+qJp8316y+0TJuwJtqxj8Ac5BtovxJxZNqO/MPGdAfQk2U
         uGhmAcSOD+Se7Vj6trYhLqFvxPFLqzTW31sgiuDQJOwWYXi5AAbifpbwkCXrxdMpiH1F
         SI60ZXwnZqGrp+6ZFMkM8wGRyj7qePchf/ZyxfvBruVK08uStBsTxDOZ0COixIoMZHqC
         968TWE5t62CUUZ9n2WyqgHQst3hAVg/leDqi0WIBcnefl4R+FXPzfh/UR6qtOLR/r/yh
         +YHMwA5Wzl+nu2gSwRIN31xvEzM1dRuVusR6Ri+DsWIvyjpQ1MFdoYM+s0AVeNACUoP3
         ev3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787730805; x=1788335605; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GS6w62IL/zxzq4/zoss8k2p0TRrsAsNyMrcb0qeyi48=;
        b=Czto7XXAmA6fwQHSk1lzPnluVUUetqiHQ/MgXDSJUGDJk3irH3liWPmNkp3+o2iSw1
         iSy1sAXsMDDqOCzZvLB3MudZEBh8UB78GjarxxogIm/A8GpNsLxrv03lQnwMsgB7+0ei
         m+c7fOAxbXHaNCF7DYgRrlPn7gp+oJNRJBhCkkXi/8jtuof4CYQJ9gkn3siaLadya1C7
         sklaDYDuUU0jdQNkKjIsnsrIeiRHuxwXAB6ZzBgC3VzK1sUZFEAZtQ2SQn/+QeYErW4h
         /cCzwIyiYiTMtG1Aj9XQkZAxwTAGNgIZfqDURRhRho2OMtFg8gbMXPSaFRYIISfyRSoz
         IvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787730805; x=1788335605;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GS6w62IL/zxzq4/zoss8k2p0TRrsAsNyMrcb0qeyi48=;
        b=OFX0tVfzQf6oHbWUnmlEJ/kZQ1bVikCC87XsxlktxaJUAdLyrn/VT8xSDScskQYUul
         nrqsXWJGuZ1vmjmstA4uS4fhy6ayYOjk+tMmLMsEIJ8j207bnqwLJBT3zXq9VnAhwtJ+
         Od7FlS5Rgz/6H+aqBO30ZA+2j58ss1VzOxDQMHxyp7Ts0PjkNa6oh9slPF1xW9yvJQr8
         YZyiFgCmkWcFxWh7PRLiLwjTNyxojvfXUrLXnKQZ89QXODRCryNeywiQV6gBoFl2QMGm
         kQaKmEPhb9A2ossSjRmRnPCfe0uYnyK3ge6LaUCyVmbLHR9XUoW1rEI7GL4yz99b2F/Z
         NuXw==
X-Forwarded-Encrypted: i=1; AHgh+RrzQtwi6upFTSJ8Fk+LEmaJJgUfPnNInQMv2/wmYTWOOT7rmMDeHqB+9KXS8BRJwDOOe4xNeEM3BA==@kvack.org
X-Gm-Message-State: AFuF++mY0gTSdBcCYrsdj6XoMgaJFMUaWH+QkpXZXaMd1rL4c20dmenS
	vfKMKgGnaD7NfGExqCROEId5KNazA0qJZOlrVO40a5BOI+ddUwrsAvPiYZpjBLXqBM0QbZ559ua
	Uu0E3wBxLesS+cFCmfdMITxTluiASxGM=
X-Gm-Gg: AR+sD10EZrXeiQG9qaow1xb/wr291/IZ3Ws6dh79GB+O2HupIFgraL0KL5F6mKotYlm
	PiMNHENZMgMx4Kw+fYiYAgJ1b8FdOt3EGBEWUoBN67F1OI86PNGzNRGsfBB2SujUz4iw54LDL4z
	Ibwrd/yf1WDvItpASPn4CnpTsTGPZy2M5jx7IrEzZAVSjgz4d2Te62XRMDwpONipbMcDunWnTz2
	Dv/TuFlC08nQP6AxyYm2IOD6R/vlSwHH8aDv/GLTpP8SU4zbnNYcPN0OASVBuHlu/D8AgRgbHNh
	eZg+7j+ZIZRs7wIkhNraeaITxGBVqw69L7UamddL9yGwKdRqq10GeQA2JHsSRJgeGlyT5TNiYmM
	VsLwpaGtp8Gy557ayrxIe8KF2xfLLyA==
X-Received: by 2002:a05:6000:2f89:b0:482:db2d:4530 with SMTP id
 ffacd0b85a97d-482e2679df3mr2200734f8f.1.1787730804949; Wed, 26 Aug 2026
 00:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-3-xueyuan.chen21@gmail.com> <c81ff923-800c-4ef4-b6e4-ec9f5eb1671f@kernel.org>
 <ao3GXvT2ltf89_rG@willie-the-truck> <86823e2b-f739-4ebe-b92f-a35b9dcfa0c7@kernel.org>
In-Reply-To: <86823e2b-f739-4ebe-b92f-a35b9dcfa0c7@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Wed, 26 Aug 2026 15:53:12 +0800
X-Gm-Features: AcwNN1VjJ2lKh5_YdVKV0IGoF8qN-k3btcVN2OMCYjKb6W9mIPF2WiO3SwjTsXc
Message-ID: <CA+qSx6yPD7bz1s8B3QHxFhaVzsgSV9H_iKfskSQXjbu6kuG3tQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] arm64/mm: add set_direct_map_ro_noflush()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Will Deacon <will@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com, baohua@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5D39C0007
X-Stat-Signature: so9hmgj7p8kzd83sfbcau54coorjzof6
X-HE-Tag: 1787730806-657489
X-HE-Meta: U2FsdGVkX1+1KHFwFXgMTz6K+hafyDPz5fUKhPQQaa56+tE3jvhchGogzufdndz9lgP8vJh3VKti8dYsYUiNefh4jkk4Cs5A/w7G5Ci7v/1z/XKL7N/0fcbXf7DK/bHQ4mg7kJhV70K2tStdl5xG2aD3409NaogyD/hiry9J6fr05YzU55kqkKssQ5rUihLcQLEpnYFd+p7E1Z1UyJKg3udTcqc+c7THqYTx7dnJCWpNepDmbHmXlylRjnSZqgdUoss268rxlZeEpxAUGpq4gdowThH3f7Q+EcixTyVzye4KpuadJlohW7teV+hAQL/URDhKz+PHv5re++TmMWHDyYi09Bi4GF5fRLQLE53KrPBpIe/lYc0dqlfgjDDNYiNe02VHxvYh+SD5e0t8xn10avfgrzdNWsBSJGSmnVjmRmIDuiAE8N7Hpx7KTcVZ2NEZXbLMKvXgENwIWl9G9rUTN3QoZAdhy+FVidplj4V0pbkdr1xA80OPLZvEe4jSbBhSQhDRZGjLUsZjwqHjpicrUIixQJmqvmjLECMo4DAEOWN3O+18Len2+uAvF3aJmwGTNrJ0X1AqW+7oCLhMDkFEqzorMTBzNeCTchTXOMhb3CZ2G5rjzseseeibdlZe+f+tmQADJA1FkM8VMcw10v2FqyeyKw0F0Vb3fBNc8v/F4zB4b1wHbsYDPwnxADEL5MxcfBs1YmdAWykOwiK/qAgePTjAicn0ndVxeHVKqptH190nLKLosbvtVq3QmZzXdp3FYGDHnFEYyz4g6DI3RvxJ/frwSVyLYIEOvzgcL7RKXwMAxSJyeG0F2jKqL9NwipB7e9tswkkex/HkGJs+MMV86bGrKDUgg58JUpQ8h9DaSKKPVSua2NWJOFmfbTSd9wdsVFvE6D1SIA4vn8z/OCoTje2IBkUrF0AHQeqZqnpAutihTOhvC0uMl+Kjqnoyu0N6+H2OdwezG9Hcx/UOBIk
 6/SxJ5h9
 mjC5wR/dbfsMGneUQ3KcJiTxGORWPdSX/oSq9vs4UjOV7hdxtWNtRsU0JFUg6G5fjK367yNILyNoX7VuHyjRVs78LFqF3ZUIXcDF4zP7yWPKGE2Bt5i9AzjRITRrk4zDIwKgKl03wkf8FpFNhbz9sbiKSdFwcjDNZj82ceBRu4i4sTQJ0vTzDAj4QhB7chfQ6TySHX0aSTRBTHyZU7CpSnN8B29vV//mNCgHL5li9mEejFeJhFJ8kDxH5Jbj2DHjCTc1QhHBE5tdF5jBWQiWBnr2vGswpgsxTk1M6q/otEIvcP+uf5KCrQG3BHaVA4PCXo6Yb1dM92XTJyAedNECHXnFC5JQ+ZKIZJezdmoQ7GM6yuQG0B/trkeAyL6pvmkw5deNaJVK4XifHZDX9y8zvfYHrKUDP3K6T9Kz1bWxeDQIfoORO7SQh9OEaaXeGNiwEKFO74G5lYyje9DM/XHzU1KJPv81EpMH0tIWIWy/DcqY4bkojckFX5+yIwkxsfce/3VUiCpff2BfPt+k0B5npkByrUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:46=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/25/26 18:44, Will Deacon wrote:
> > On Tue, Aug 25, 2026 at 05:52:20PM +0200, David Hildenbrand (Arm) wrote=
:
> >> On 7/30/26 11:06, Xueyuan Chen wrote:
> >>> Implement set_direct_map_ro_noflush() for arm64 with update_range_pro=
t() on
> >>> the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
> >>> existing can_set_direct_map() guard and leave TLB invalidation to the
> >>> caller.
> >>>
> >>> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> >>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >>> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> >>> ---
> >>>  arch/arm64/include/asm/set_memory.h |  2 ++
> >>>  arch/arm64/mm/pageattr.c            | 10 ++++++++++
> >>>  2 files changed, 12 insertions(+)
> >>>
> >>> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include=
/asm/set_memory.h
> >>> index 90f61b17275e..7083260303c3 100644
> >>> --- a/arch/arm64/include/asm/set_memory.h
> >>> +++ b/arch/arm64/include/asm/set_memory.h
> >>> @@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpag=
es, int enable);
> >>>  int set_direct_map_invalid_noflush(struct page *page);
> >>>  int set_direct_map_default_noflush(struct page *page);
> >>>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, boo=
l valid);
> >>> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pag=
es);
> >>> +#define set_direct_map_ro_noflush set_direct_map_ro_noflush
> >>>  bool kernel_page_present(struct page *page);
> >>>
> >>>  int set_memory_encrypted(unsigned long addr, int numpages);
> >>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> >>> index ce035e1b4eaf..c51236b61651 100644
> >>> --- a/arch/arm64/mm/pageattr.c
> >>> +++ b/arch/arm64/mm/pageattr.c
> >>> @@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *pa=
ge, unsigned nr, bool valid)
> >>>     return set_memory_valid(addr, nr, valid);
> >>>  }
> >>>
> >>> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pag=
es)
> >>> +{
> >>> +   if (!can_set_direct_map())
> >>> +           return 0;
> >>> +
> >>> +   return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_page=
s,
> >>> +                            __pgprot(PTE_RDONLY),
> >>> +                            __pgprot(PTE_WRITE));
> >>> +}
> >>> +
> >>>  #ifdef CONFIG_DEBUG_PAGEALLOC
> >>>  /*
> >>>   * This is - apart from the return value - doing the same
> >>
> >> We'll need an ACK from arm64 maintaines. To me this looks good.
> >
> > I generally dislike deferring critical things like TLB invalidation to
> > the caller, so it would be good to see an example of a caller that real=
ly
> > needs that. The caller in patch 1 unconditionally  calls
> > flush_tlb_kernel_range() immediately after calling
> > set_direct_map_ro_noflush().
> >
> > In fact, that means we have a pointless invalidation if
> > !can_set_direct_map(). See exhibit A :)
>
> Ack. I recall that the patch set originally didn't do any flushes, but we=
 really
> have to flush even though we are early during boot.

Hi David,

Right, the original assumption was that the TLB might not hold a
writable mapping for these pages at all. But the folio is allocated
with __GFP_ZERO, so the allocation itself zeroes the 2 MiB through
the writable direct map and leaves writable TLB entries behind.
That's why skipping the flush is not safe even this early during
boot. (Usama Arif pointed this out.)

Thanks,
Xueyuan
>
> So agreed, the interface should just flush internally.
>
> --
> Cheers,
>
> David

