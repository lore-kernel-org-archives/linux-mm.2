Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29711CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4AE66B0088; Tue, 13 Oct 2026 12:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5716B008C; Tue, 13 Oct 2026 12:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B966B0095; Tue, 13 Oct 2026 12:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72E796B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:39:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 034F0160D77
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:39:07 +0000 (UTC)
X-FDA: 85318162776.14.40C50E0
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05C974000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:39:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KuWfkj8p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791909546;
	b=boXM24KAlWqsJIi0EJzCegbrNHvNg/FUlPsov6w4FX6d5AFV8s1EtbUw+wZH9J6fol7Hw4
	pfqdguwYAe0vUS7t+ea8p6wvi+0IyEXcwwLogxScYaAgzet5myIpKN0kmAIGc30evFfOm9
	KF4V5HmC3GgXE/HUmE2tLcU33Cy3JyI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KuWfkj8p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791909546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMGgj7z4LL/41SC/RzPSs++jA5iS5B4RotyfALMsZXw=;
	b=zTtCGCwA1ZDOAsfWjfrJojMkLeWkFNh0xqAUliYwkd24Wy33olfVIpAHZNq7yUn5+Amrpf
	0pEt13BSyph7HsG0DYBYBxke7f6hKA3ZZSWoU3YdVle/A28xqlxKxLis1wlgKjCebyv0mY
	egd3TzrKrL4gK/khtlnhncrH7OjUawo=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bccc73eea4so137879e87.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791909544; x=1792514344; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hMGgj7z4LL/41SC/RzPSs++jA5iS5B4RotyfALMsZXw=;
        b=KuWfkj8p9Zms2XtvRVupiVDsHAynjpsZxmgjg4E6LXp8sJfZeAwxOu0tflYkugxacc
         dH0QpUccRqJPx/dBp4NmskPsLel02WBiiDRVIxOlV/cJrwQ/R3KPB8tJnHFVJK6VSwXf
         DGrAuFUrU2P4DrjV/DPoj7/K/IRWWzH8uWFXFZw2Rxr12metZvbFP0ouVQcHvqWrrgT4
         Nh64KGUXq7R27lvN37IKgQ4K5076QLl8KCVLRqz3jsruC3Jj8PX5kfbgS24nhf7xjRa2
         FZiqclmO9tu+A6+ZYfthqzqIqsVGlN8F4NYtW/5rjhJAAIcGR1EmZR60rVP639jh99Ei
         Nx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791909544; x=1792514344;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hMGgj7z4LL/41SC/RzPSs++jA5iS5B4RotyfALMsZXw=;
        b=lv/tGemB6gf+UnXYicvbACFapbCh+Xn+/AnaBBs7bw0Mw3Qk5sHF9X9tsF4jH/YPnP
         7V3tud9tjHx0ddNfCpxWL426l5QWnGTX0ItP1++6WPNsJ5w1JMHFYOWCYWoWRKqOEeiX
         dDSRDP/5VRQiZIw4GV2Elf0ZW8GW7GSJxUsLRrsMVF7odV/mhmsNCjUSkqJMrNT+PzSW
         ELaaq3RAIORA1VyqLiGaEMLTcjd/mfmPQnUcKdXQRHfyNa7dtPwu70RU4h2UIeFp2Cul
         ZQAJb/uaV4EcdvtrCVOwVWRBpY1H4qC4pxIZo1y23PXQCtxkGy7KsV0pxcn1ZmS5aep2
         NJzg==
X-Forwarded-Encrypted: i=1; AKwUvByE14N9A03xhWZGjSLgKjd6HagTnAs53GtHvDsmWLMYfMmXp+3KqQdzNHRFNlQMEjV6Cr1TXKZ7cQ==@kvack.org
X-Gm-Message-State: AFq9FYJdqtkma6ebQhU36EpEHGz998lJ1DglNNgTWRXWQ+Pne0P+qLn3
	iky89I+/8os9sQMKec77XH/w/jXIhp5lJekn/73M3wF/y+R4ezgLIrTS
X-Gm-Gg: AYBFou11FxYbWVFu/S2uqyXFeciaGAgx3AvkusKJI+VQOteHNZE7ZLhFj1ij78mKlhz
	8lsHt1XRW3c8ugsm/6O+6FDzj4VaQl1vXiDD54GXgQrTeEBRIOEc9WrvBwTSIkHhP0wD7uNOOPu
	mgojnVpKaKwf/Ph10JXTKtpbYISARYf04Qq24fJBVaxqkJtFdqqwUWC7mvAqF0ODVsMbGZmJPl4
	SXZnFxwLESa2F6WXoUReRb0IpUM8J5FPO8ghQl7LzduBHNaXEaZluoG0KCMZEEz8ClZfL1TocZL
	O9Vdi+Pz5f7alg0Hq/SpV+HuTb3RnBKuCxs7iVXZ+nixMZm46DlN45PCCYiKbJm+T/KiI/pfjh6
	6P8A119DfRKoi8WhAC0GUNNv56+2zl9TKW6r+xtR7yjnsqGd7ECqfjDXnDMDSVMiLfzoAqdQX0i
	Vwy4/Fbq9tQWFHvMqHGM+jRHM9ZV9UEhdQRuXnHlRUiluHZLaoezp0J3hlA3WI8/gafmXCHH8ps
	Nr4BTqxZvgb5FuTq3Sq5JymILyBI4PDgYA=
X-Received: by 2002:a05:6512:3d94:b0:5b4:af24:3612 with SMTP id 2adb3069b0e04-5bcdd509e2bmr4530333e87.20.1791909543917;
        Tue, 13 Oct 2026 09:39:03 -0700 (PDT)
Received: from pc636 (host-95-203-22-87.mobileonline.telia.com. [95.203.22.87])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5be33d8a485sm45759e87.54.2026.10.13.09.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:39:03 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 13 Oct 2026 18:39:00 +0200
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [RFC PATCH 2/4] mm/vmalloc: undo partial mappings inside the
 mapping functions
Message-ID: <as5epHFQF4iE_VQK@pc636>
References: <20261009063619.112313-1-hao.ge@linux.dev>
 <20261009063619.112313-3-hao.ge@linux.dev>
 <CAJuCfpE9VfgTw2ZNMJTEVh41H_R+1RY_MtzeMuZNCD3BFm-Piw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpE9VfgTw2ZNMJTEVh41H_R+1RY_MtzeMuZNCD3BFm-Piw@mail.gmail.com>
X-Stat-Signature: j436meay7ub9c3rm1crifd3hgq76neo6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05C974000D
X-HE-Tag: 1791909545-317478
X-HE-Meta: U2FsdGVkX1/6L4uTIjtg07c7qCdy5CNnzS5xxVYq721v96aTIfeS3ahMkKi3bPGmWVLmUeda45EyeuYtgVMWB6vwfxgLxX44bWvW9IeUaQCDZBHDcoSKJC/kL5jtff+N7l1wjoyWZSjG3M5l9ryYVEPRNKUrTKOVPO3v4XeKKfG8KNXgnl2CE8/CJLcPe7I/dytebL4JRmhdTIAEdjFVuyKXWWNtbr/JFO+VJb4VfeUbbgwM1tp9hUEAYZH+d0uU74AEGoYJ2TlqMTPn8YEgQuXED1/GmGRkkWsU+FX9KbDLEwNAWseWd+bPc4yvkyQf8KqreFfcKLc3M+ptHVMDrMA6nvUy1RLw3q0dCbX0zbZCZCxrQTm5Gq2vhBmoTAw84thAXIN4bs6wSnSXsfmvSpP64ZJxIdFI/5S3gJhyHuvWbpTKOoPn2Pu7aJBHie+Rz7YzdTWvOTxNjesFH51TGILLaZOBJME4NOTff0CQs27dc0OhMzYtmk+1WUyCU6oZGlV537J3Vashr2XfzcX9QNj5fTDieZy9Da5mpiqfCYSGl6lf6Y7XpwsEKx7SeGjFVjEacJmx/9H0EbK4AofJ1TM2nx9xM5c4asVHfMGaOl7GBfubTDiPdtA4qvhSShwHXyC3B9KKZDxCjHS8d61B0e5EdOiCMKUtO5lh4A9b2gmIDaeco1vhYftFLeS2uRQ5AkHy7irYHg/uRPSKsyghFz7TXi85JYOsJMx4b4kV7/DdXLWITW7hl5pZF5zvEylg32Fe2spKd4xI5UymL1Q68lQXX3ERQSboglxcdXb/dOLyYq96MrdxJ1hJihTd9w4M20mHAQO0WaxYmhwr3LAy8NnHKH6gTP8Qetr++APZXIdFXdCxY8sct89mjnvO9hJZIWC0QbKSm7gq+477WuStFKH5Lun1TQbCvCnHbe7WAhBAXsbL6K0FlX/7jZXKEOdNW90cw9rXkOeXwbL2jTu
 O/dWQ3nP
 iNKpbMFiLCRCRtcVzTBhIkZ4NMSsqpEjRVx8labgwrnZFqxFdoqEpvSWW/Uz0gzv1IHsvDmT4iy72bOO7zoyk1Xt2kzgrskRGWDo1iUhP9yczjgDxnElxtSznpR9g2iLpGZSN1QIAZkfGha++hp9A1ltlt2iOr/eS+jRMbAIU+90ZMGRyWv8eKs5nij2fAUQaEZiefZeFDrEbocMNN8TEiasZopgf/WJ1WWTWwosmwabQudCjkX1ydpSuJZncDdyTii7LUKtAnMrSbxiOKc5ZJUSbzjEDOWIg8tlTr7y6Bu52c55VA/7uR8D7blBRY/h6/xzYm9ypQkG3nJaMKKeP2WApMM4tRMVF7r2jwMuf2+bv0TjKhFBJAztRFxINgnDflzxZz0LhFkSL4OVf3jzWFEPHqfi+8M1pLJi0mc69m8mGpOhUQ0FeUqy/PPhk1m3GfJLyiUgiPWmPT3UoraSf0A9vqGRn7zp1mKmDVFV7/Sw6Wxl/eYORHCJI8Sjk75PFbCsDQT8my+gF44v3IYfS174svs2NlNWZzutLp9bBvMmOWLm+WOHwTHw5SQl8csN6GVXHuPH6B9XXTiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 03:23:14PM +0400, Suren Baghdasaryan wrote:
> On Fri, Oct 9, 2026 at 10:36 AM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > __vmap_pages_range_noflush() and friends can install some PTEs before
> > failing and leave them mapped, and the kernel callers do not agree on
> > who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
> > roll back what they mapped before the failure, while
> > vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> > __vmalloc_area_node() rely on the mapping functions cleaning up and
> > do not call anything like vunmap_range() themselves. When the same
> > range is mapped again, the attempt hits the leftovers and fails, with
> > a BUG() in vmap_pte_range() for huge mappings and a warning on the
> > small-page path.
> >
> > After discussing with Suren and Ulad, we decided to put the rollback
> > into the entry points of the vmap API rather than into every low-level
> > helper. __vmap_pages_range_noflush() undoes the whole range it was
> > asked to map when it fails, and vmap_page_range() undoes its range
> > for the ioremap-style mappings.
> >
> > The rollback is __vunmap_range_noflush(), it only clears the PTEs,
> > no TLB flush, nothing has touched these mappings.
> > vmap_pages_range_noflush() drops the KMSAN metadata when the data
> > mapping fails, and an empty range bails out with -EINVAL now, which
> > used to BUG_ON() on the small-page path and map nothing at all on
> > the huge-page one.
> >
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Suggested-by: Uladyslau Rezki <urezki@gmail.com>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
> >  1 file changed, 32 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index db669103dc66..e1b376f57dd2 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
> >         if (!err)
> >                 err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> >                                                ioremap_max_page_shift);
> > +       if (err)
> > +               __vunmap_range_noflush(addr, end);
> > +
> >         return err;
> >  }
> >
> > @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >                 pgprot_t prot, struct page **pages, unsigned int page_shift)
> >  {
> >         unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> > +       unsigned long start = addr;
> > +       int err = 0;
> > +
> > +       if (WARN_ON_ONCE(addr >= end))
> > +               return -EINVAL;
> >
> >         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
> >                 return -EINVAL;
> >
> >         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > -                       page_shift == PAGE_SHIFT)
> > -               return vmap_small_pages_range_noflush(addr, end, prot, pages);
> > -
> > -       for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > -               int err;
> > -
> > -               err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> > +                       page_shift == PAGE_SHIFT) {
> > +               err = vmap_small_pages_range_noflush(addr, end, prot, pages);
> > +       } else {
> > +               for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > +                       err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> >                                         page_to_phys(pages[i]), prot,
> >                                         page_shift);
> > -               if (err)
> > -                       return err;
> > +                       if (err)
> > +                               break;
> >
> > -               addr += 1UL << page_shift;
> > +                       addr += 1UL << page_shift;
> > +               }
> >         }
> >
> > -       return 0;
> > +       /* Undo the PTEs installed before the failure. */
> > +       if (err)
> > +               __vunmap_range_noflush(start, end);
> 
> Would it be too complicated to track how much was actually mapped and
> unmap only that portion?
> 
I think it is possible to vunmap the range which is already unmapped.
i.e. in this case it is better to no to track anything as soon as a
mapping failure is a corner case. Also it is more reliable without
extra track logic.

--
Uladzislau Rezki

