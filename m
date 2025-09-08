Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D280CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B0E8E0019; Mon,  8 Sep 2025 11:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722AD8E0007; Mon,  8 Sep 2025 11:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638A38E0019; Mon,  8 Sep 2025 11:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 506208E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:01:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F08CF1601D3
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:01:05 +0000 (UTC)
X-FDA: 83866395690.28.503E905
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2A35C0020
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:01:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dpHYEoFU;
	spf=pass (imf28.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0G2erlBBBsAwmVhizzYkBp5Pme+1M8YCrN1OqJRjg5U=;
	b=qMtI2+uET0JA1DpLPwSkfubdQLpyDXe7XG5njytdz7w/M2RnlP+AiUFjjKZpJWq56Kss/t
	Fd4u65gwY/FSLk16fquCuchNUvJLXRkqPRKGuhuPVo96RbusjgNMuc4JgquCrfQS7u87UT
	LDUtp+OKqj28wb2vt9q0nxg9Gpk4ILE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343664; a=rsa-sha256;
	cv=none;
	b=lj9WfUxmljOrT8fI7oRsosc+EegYOwnMYBP9x64oU0TxrUAtAIiN6+aGU80d5CURtVrBkI
	SREJot2zfcIuB4HEZC1uF1I0oo5oG1RGbR+PFb2wrw4MsbQpQbG2ZqaIvRnp5/4QGtqtlH
	zNLbNt2fzSUWNHThytmXGnxcdpwxikM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dpHYEoFU;
	spf=pass (imf28.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55f720ffe34so5938431e87.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757343662; x=1757948462; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0G2erlBBBsAwmVhizzYkBp5Pme+1M8YCrN1OqJRjg5U=;
        b=dpHYEoFUnx0/KxDXwvIizXVD04TAQ+2QDYvGpgdCbjS9iOnEUev/JNWBkdufmwwRSh
         12H6lXRQithZM3Fncz1W5QGdZHTj/vLHXgFqyNGAfvLtLVn/4AnTPDa0oj58Q6kKwVgd
         ifsw5Mj8WQK0ATGvQCPOr/+L7cVsUAdh4mVZAoy8+zDY95zp1XlVudOo2ofdwx1xqDD/
         alV/WiooUT66BGzRNvQFN9cdTZYOiSnrazWYN/tagW8aq0oKT+IYt+eAc5BbqcmzCrBW
         e3mNz62s+1qs05DAXD0fwEyk38yTbBAtWPY8bePjkRmZkkq6o8ZHKBNDy6hBhwEuyXKi
         tMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343662; x=1757948462;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0G2erlBBBsAwmVhizzYkBp5Pme+1M8YCrN1OqJRjg5U=;
        b=UwbnLZ1dIQNuWZagcbLq4F7WQ2v8C6e8OwMzcfWU/u1wDzy3WcClv7KMGKvfHhGSgQ
         SgwFF6F23clV4t9OTPcith2f/ymG5n5Y30E/8I2Q7Neggs3V43NVSGtu90NWOnuI4nls
         Yo+8HQeyNFBFJNE9TwaEd+vcAmU3Rk1Wk2NwkWqWzosNkzw8R+k1kYm4k2eW1ldPwDFm
         19wH7frV6BG3ATJsHn1Qbs8SLBxNUfV2nnIvOJc7jEduCxwqq5f1E3kyZPQJfUk+XhwH
         ymHKWfuv1QlYwunAODzr60wvSWzPsVuNhvzc7kvkCqn64uia3YMk81PZvqYkhgkgCt/e
         IkeA==
X-Gm-Message-State: AOJu0YwNlffEEUZiuxSnZm4pG16wCJ3PuIzhbvRKq8xW1CxmlqIRJbDw
	PgLAaJ+fB+YNaUoRpdE3jPyROBgBqSQK4TRO9ppYXMk+BrVK/YojTRaH
X-Gm-Gg: ASbGnctRXfWxFjJtyNNDAoE4nvzYHyDyFolbBmeDcJ2VGnXkQ+RbkBL/VGAugG8kaqa
	3ssMlECku1IdERYliFLJw9IxoG8vwxKFUGLWkdMPZ1/dNUZYFnYsp2Au6vO82JLeRAPuccF9t66
	jOb+gI7Efne0NZ96NCqtEXtpJrU2iqo5qS8XzXXVQjrrhJAcF9C9IViEbJYh137mGyLyd4ZLe6k
	o2TTIES/Z/Dkj54OfH4el1Fpb4hiNOoovFkzA8KAFiV2BkEMOX3KWmiKD4LwuHvL/GoCdzdKsK5
	30BOJzptijEysTVleVLfQfMEYM/yRGI6MdLZtxJU0k7LP0lGfJjtwGzhQ/RCQLYD5BZkwvSkMKB
	ztWIQtp66gq0VwCf3stKcd8OSX7Ep0NO8GdqBX63bbuuXEueJXRLfUmiqug==
X-Google-Smtp-Source: AGHT+IFTQ26xNIJNHkUoNSxGQXYmSiWt+zlA45nFh35zZguoZcxu0ISSR5ewCOBgamveazUKyZmXsw==
X-Received: by 2002:a05:6512:1289:b0:55f:5c1d:6cd8 with SMTP id 2adb3069b0e04-56273118a3emr2247856e87.2.1757343661124;
        Mon, 08 Sep 2025 08:01:01 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5608ab5e4cbsm3665567e87.15.2025.09.08.08.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 08:01:00 -0700 (PDT)
Date: Mon, 8 Sep 2025 17:00:58 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
Message-ID: <eu3s6hqfcbkymjqk2rrngzx7qxjzpivfty2dr4lrduxohxuuuv@g63qihvder5d>
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-12-ryncsn@gmail.com>
 <vj7utcgrseaot6ktpbwgshthmjza7w7vk2glede273tza7yfi6@cyxppxoney5u>
 <CAMgjq7CLSuSfRwMYqNL9ZU3ehpZfR6oewHsYtLD4CTXcvEKOTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qjdjihavuqnpisjz"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CLSuSfRwMYqNL9ZU3ehpZfR6oewHsYtLD4CTXcvEKOTg@mail.gmail.com>
X-Stat-Signature: atb1u71e4q49cmue8arb3j87pqpenwx5
X-Rspam-User: 
X-Rspamd-Queue-Id: D2A35C0020
X-Rspamd-Server: rspam10
X-HE-Tag: 1757343663-41004
X-HE-Meta: U2FsdGVkX1/uaKDDD7AUABhslvanFQbHoyOg08U/sBfJmqKslnZne5/xM8qd7XiwvunnLwK42Z+UIqecQSRazVfPlasELfm8pOgvUs+tLsnc0sFwX/u4wQ+XBld5AuUzitO0howWwr53M64DM3JnYM2CsTGo/7PD0hXtMIXQnHz21FvhE9FGlzh7fcVKEnXFVNw3+RnFW8W6Z4dZkAydwuIAgdEMcYRD4zK9lejMgp9fz8h8S1Ay5MgprdjxWCxFtCmGc8N39/Tu87IrYVX425XQzpvmBSLk/Vb7Rj6xabRwWcpUSq7P4TI0Ae+g7n8MF/kmH2/yMPy7wbaopi+clkGx4ncB+t3cfnMvR9efHBoGQJri1ocI2aNE0G2DuQOlkKjUKNp81mFvefSZCwsZ5dCheVm812UfCAp68VcVYWcJUIg/T0YVtk4Up9StFOEI8vLYZJ96//KK5x4xZoa5ZkidZNjzvA9YwChejLjCozzGma2WCK+5lyUnHNqPCdvgIyJ4uNS+VVbggZWYRW0ZlVIND3lhNDxA8j0vIrq5Zbahii4YOMk/+nf+eKo+Gwkgk6LPY4IEKCcT4ZCjFb16dXRUPSo5/aoV0OjW9LI7kYsh5ziBvAyZRHEvxec7lJ67z9cs1wPKmWM1LD1twvhAwetAzNK0GIFGAVxS40KqgC964h15lF4tsUQkzzEp+IEjENxrm5HGuXgJk0cNl1lwDPU5D2pk5P4546gSuI5nMkhdxQCKEEKPbicv9WegIcY1swzRjJgbBZgQZkydGR1V7iBR8XWJIqYo4+5yPec8I9IgRA2k0AV+lCQ8q7cbGs7DhL4VSl9BlB70haTaVEFhB02r7kpOMmvxZWHYBTY/UUsVJYvdppoC6BHTl83BwYJMLLszQ8ayRMoNDi2Hj491d7jZrbEvNu8VKWFOM9pxvo4+u7EHIcPXd0+SMDAnvRLWon5goJRjnvpMUP8Dn51
 qfrfEAu8
 Sl5Wd5Avw+26vTmbpHIQJMpvtBBZ1iApEj8VvOFD4n0xcAt0c2Y0+edzzGLVMmC8OEA1m14tJgm0ZgVsQOiMr2roSIqUJFWRs770L1nMLqnFIEIXngCY28IDvYuFS3lxy9w9Z+81W5uXjmWLtm4RxCPk9vTd86lOEejOno0/2Q9Em32UJA7Q30UYCqp9uHWXPkoI0WGGm5pWHHd7LHAqKHm1vYWlBLm6OnKbJp4ijujEaj15JvWwS7MD5Ekwl6hs9lcZijD0YV2Hwdbi9nXibqkpSuCYRfOFUKhf3NtlNkwjfjbgON+Roa+OsOVyNh55IkyzIH4CLjnl8PlBzji8ipbQZsDjjSo9K64YIh27bU44VGmDOW7FG6DQq+5Qn0PR8Qk1ztOt/zlQjF8QD0nZFPjH438kuBZo6DylLvhnUjM4RBI/EzHZ6cLNSfuISgq0GuFXsnlptp++nYqm8jl7VTAGUJ2HClptclBK/UoNTQ3dx0y/O5PuWQpDhkyHDaFHkR8Hbztkrs9hJFN38+V65q3qp/FN3k+18uEmp+sKoDwSFoclb9sKNQcE4H4xnGFWPRbJqU+7/Oopjr6lmnOffW51suYTJZK2Oxx7guvsZwsV5txTTgQSxa5WgSULj0Zuv8ACwDgWbDCBioVqVlF6J0MWNDPMtd+gR69O/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qjdjihavuqnpisjz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2025-09-08 22:34:04 +0800, Kairui Song wrote:
> On Sun, Sep 7, 2025 at 8:59 PM Klara Modin <klarasmodin@gmail.com> wrote:
> >
> > On 2025-09-06 03:13:53 +0800, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Introduce basic swap table infrastructures, which are now just a
> > > fixed-sized flat array inside each swap cluster, with access wrappers.
> > >
> > > Each cluster contains a swap table of 512 entries. Each table entry is
> > > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE),
> > > a folio type (pointer), or NULL.
> > >
> > > In this first step, it only supports storing a folio or shadow, and it
> > > is a drop-in replacement for the current swap cache. Convert all swap
> > > cache users to use the new sets of APIs. Chris Li has been suggesting
> > > using a new infrastructure for swap cache for better performance, and
> > > that idea combined well with the swap table as the new backing
> > > structure. Now the lock contention range is reduced to 2M clusters,
> > > which is much smaller than the 64M address_space. And we can also drop
> > > the multiple address_space design.
> > >
> > > All the internal works are done with swap_cache_get_* helpers. Swap
> > > cache lookup is still lock-less like before, and the helper's contexts
> > > are same with original swap cache helpers. They still require a pin
> > > on the swap device to prevent the backing data from being freed.
> > >
> > > Swap cache updates are now protected by the swap cluster lock
> > > instead of the Xarray lock. This is mostly handled internally, but new
> > > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > > few new cluster access and locking helpers are also introduced.
> > >
> > > A fully cluster-based unified swap table can be implemented on top
> > > of this to take care of all count tracking and synchronization work,
> > > with dynamic allocation. It should reduce the memory usage while
> > > making the performance even better.
> > >
> > > Co-developed-by: Chris Li <chrisl@kernel.org>
> > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  MAINTAINERS          |   1 +
> > >  include/linux/swap.h |   2 -
> > >  mm/huge_memory.c     |  13 +-
> > >  mm/migrate.c         |  19 ++-
> > >  mm/shmem.c           |   8 +-
> > >  mm/swap.h            | 157 +++++++++++++++++------
> > >  mm/swap_state.c      | 289 +++++++++++++++++++------------------------
> > >  mm/swap_table.h      |  97 +++++++++++++++
> > >  mm/swapfile.c        | 100 +++++++++++----
> > >  mm/vmscan.c          |  20 ++-
> > >  10 files changed, 458 insertions(+), 248 deletions(-)
> > >  create mode 100644 mm/swap_table.h
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 1c8292c0318d..de402ca91a80 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -16226,6 +16226,7 @@ F:    include/linux/swapops.h
> > >  F:   mm/page_io.c
> > >  F:   mm/swap.c
> > >  F:   mm/swap.h
> > > +F:   mm/swap_table.h
> > >  F:   mm/swap_state.c
> > >  F:   mm/swapfile.c
> > >
> >
> > ...
> >
> > >  #include <linux/swapops.h> /* for swp_offset */
> >
> > Now that swp_offset() is used in folio_index(), should this perhaps also be
> > included for !CONFIG_SWAP?
> 
> Hi, Thanks for looking at this series.
> 
> >
> > >  #include <linux/blk_types.h> /* for bio_end_io_t */
> > >
> ...
> 
> > >       if (unlikely(folio_test_swapcache(folio)))
> >
> > > -             return swap_cache_index(folio->swap);
> > > +             return swp_offset(folio->swap);
> >
> > This is outside CONFIG_SWAP.
> 
> Right, but there are users of folio_index that are outside of
> CONFIG_SWAP (mm/migrate.c), and swp_offset is also outside of SWAP so
> that's OK.
> 
> If we wrap it, the CONFIG_SWAP build will fail. I've test !CONFIG_SWAP
> build on this patch and after the whole series, it works fine.
> 
> We should drop the usage of folio_index in migrate.c, that's not
> really related to this series though.

Interesting that it works for you. I have a config with !CONFIG_SWAP which
fails with:

 In file included from mm/shmem.c:44:
 mm/swap.h: In function ‘folio_index’:
 mm/swap.h:461:24: error: implicit declaration of function ‘swp_offset’; did you mean ‘pmd_offset’? [-Wimplicit-function-declaration]
   461 |                 return swp_offset(folio->swap);
       |                        ^~~~~~~~~~
       |                        pmd_offset
 
(though it's possible I have misapplied the series somehow).
If I just move the linux/swapops.h include outside the CONFIG_SWAP ifdef:

diff --git a/mm/swap.h b/mm/swap.h
index caff4fe30fc5..12dd7d6478ff 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -3,6 +3,7 @@
 #define _MM_SWAP_H
 
 #include <linux/atomic.h> /* for atomic_long_t */
+#include <linux/swapops.h> /* for swp_offset */
 struct mempolicy;
 struct swap_iocb;
 
@@ -54,7 +55,6 @@ enum swap_cluster_flags {
 };
 
 #ifdef CONFIG_SWAP
-#include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 static inline unsigned int swp_cluster_offset(swp_entry_t entry)

it fixes that issue for me, and my other CONFIG_SWAP builds do not seem
to be impacted. I attached the config in case it's useful.

> 
> >
> > >       return folio->index;
> > >  }
> >
> > ...
> >
> > Regards,
> > Klara Modin
> >

--qjdjihavuqnpisjz
Content-Type: application/gzip
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

H4sICKbrvmgAA2NvbmZpZwCcPElz4zaz9/wK1uSS7zATeY1Tr3yASFBCRBIcANTiC0uRNTOq
z7bmSXKS+fevG+ACkKCUejlMbHSjiaX3bvjnn34OyPtp/7o+7Tbrl5cfwdft2/awPm2fgy+7
l+3/BBEPMq4CGjH1CZCT3dv7P7/+83Af3H+6+u3T6ONhcxvMtoe37UsQ7t++7L6+w+zd/u2n
n38KeRazSRmG5ZwKyXhWKrpUjx++bjbBL5Pt22m/D67uPl1/GgXf7/5T/fjBmsZkOQnDxx/1
0KQl9Xh1N7oejRrkhGSTBtYME6lpZEVLA4ZqtOvbu5ZCEiHqOI5aVBjyo1qAZlAUUlmrGz38
PnJgSJ3MCUvIOKHtN8y0JJmn7bdGI5huHUNIsjJh2aydBYNT2AiRaTnhipe8UHmhhuGK0aiH
pDhPZCmLPOdClYImwkuAZfBt2gNlvMwFj1lCyzgriVL92SEvMgUfHq96oLRIFItYSjPcMkmA
XCaVYNnEOX7ceSFpOaM0h4WUHM4oIavu8ZmPURHSMucMvtk7YMSQOVDDBfuARZbRkEpJxKpU
gmQyLRSVPky95QVT0zIrkhYhJ1MOgIYBbprbZ+JzueDCur5xwZJIwe5LhdxQSrgA616mghLg
xizmuGdFJE4Fefo5mGjhfAmO29P791bCxoLPKJxOVso0bwmxjKmSZvOSCDhNljL1eHMNVOqr
4GmOe4F9qmB3DN72JyTcIiyoEFzYoPpmeEiSeqcfPn4HUd69v3583T1/8KGUpFC8s/tSkgRU
QYM/JXO8ZpHRpJw8MWsXNmQMkGs/KHlKiR+yfBqawYcAt37Ak1SoHpoDstbrPUB71ecQcO2e
Y7bX35/Cz1O8PQfGjXg+GNGYgGBqxrHuph6ecqkyktLHD/WNn7bH04eWulzJOctDPzMRFU7L
zwUtqBceCi5BL9CUgwSCOiHh1LNCfRtEACVSgEWCDwKbJbV4gKQFx/c/jz+Op+1rKx4TmlHB
Qi2IoLPGlgKwQXLKF/a9iwhGQW0sQDdKmkX+WQgTc6KQz1MeWbQRGnNQSlEl0o52A20kQLMB
kr7d7dtzsP/S2UFr3Xg4k7xABafPMeIWJX0cNoq+vt5itb6ZtyfWAWsCdE4zJc8CyxR0Eon+
AH3owUs5qNI8Iop2JCjnki3LMC/0OoTUaq1Wi/ry1O51ezj67m/6VOZAnkcstCUBLBBAWJT4
GUqDvZApm0zx3qqleNjMd+BlSpalnNEFWCSw76P20nord3ZOx3lc/qFvRO8TfnU22SwL8arr
cZddfcad2NgdQWmaKzSg1KjWDmegzaqREvJkGU97qn2w9ficJ2DAwSJ6T7HCOgfT3zuLIM7P
j1agb5ijUMyJ5cWvan38b3CCow/WcD7H0/p0DNabzf4dVNPb15Z7FAtnmvFIqB0SI4XNp1BK
tWi0YP+SJPPeyr9Yil6yCItA9nkbvrcqAWYvCX4t6RJYXnlYU0+Q9YxqES5xa3Mz84PXhqMl
Bo6bslg9Xt07PFuAM2Y8k3AK6kuLQ82/cvNt+/z+sj0EX7br0/the7SZ2EwALbtcwR5o6D0z
DwmHZRckU+UY5Q5oFVlK8lIl4zJOCjl1XEmW5gkLwcuJQWhAyfJiMgWHZLF7/f6y2+xOH79A
THP6dti/f/32eNcYNIgjrkaoIIgQZFWO4d4j6RAehE0M0PiqPNceaZzYhmMYobV1E1hpLr18
Zg4QPSaN5MUBX5345WqczMBcz7UJEJEfhXNV9tmi5RmcStJYaw20bbRMUUD8VjsseQ5Q9kTR
1qGehv+lJAupT612sCX84Pj7XORTcNIXRGRD42UCdih5/PD3+vDmeo8Fi67uLQMLqlQlwIQh
zbV1hl2Fjp4DDNilR+U6hiuU+Qw2lhCFO2vpGwm16emgBsIV4b/YCVUpGj2vjq+QYtjmkEEz
JnTQZuXAcMoJMhw919mHh8CYgD8iU+MdtCuCOGjpXQ/N+cAuJJtATBf7+U9vYACmXYwBmJyC
c+iFEOb3hRkvCzGkz0k0Z7hfcxl+WYQPjkENsIEbnYXpgHxK+tkvLuDVQrRF1FkmmOGCVqnv
khuL3i4NSGXgeXHRc7ngmMvGo9NKukrU5NvDl/3hdf222Qb0L/DljwEBzRyiwQJPprVOLolm
gREF5jJAjM7nyDPcr+r/5Rdt049Jhc6tVYv/Z7vRFnZzWB+/ec3PbNDmDM+uMdzguqV5fztm
Pku8fLgvb6xoFH63Y2+wAEWoFU9EQwgMrPyIycSUWlNCoLV9+XJz/XF383Bvh8+ziOZ1dsbS
ahAYzbQm68PStOj4fimaTpFFJexAe+6PD+fgZGk5Ai4CJguAbS/RcdAcck3MJEkZ2aF6DTD6
yqEK9rfSwWUchf0pIEFsLCDYgCN20kKNmKDfh9Zy2YWxMUTCJmoDvSqZk5TTKLKQOUR9w2B9
+hjuYEhpuQgxaGlKRLIKMSSklsnIJ8ar0iZMPl4bvs4P+832eNwfgtOP78aF9HpWA8oG2ZAu
FSwVHS+Pencwb67B42U+1WIcD56iNwX2v06lCVvwpysQetCbYLsnxVDaKL19uJd+k4EgP+DO
BVjDSjpRHw6l6QD5+yHycJNgmlPGLoDPw/3HWkP9GZd0NrCk2W/+8VAUkvs9gJTGMQspz/zQ
BcvCKcvDgQ9W4Bu/eU1BSgboTiior8ny6gy0TAZuJFwJthw81zkj4U3pz41p4MAZEcV9Hkyd
XNYCitI9d/w95P9KdQyoc83wGe5HW+oqOLqzUZKrYVg8GsWuHsNRUFKTLAUeKW33FCGGta2B
cPngDoCqZWmRaj0WQyicrNovgt7BjDX60TShoeOKIj5oKL0hv5NRY+gLArVwFomkfqap4dPV
ZIApm8/A/knh96NqHJN3p4pcWk6RhpdQnqaEL9n5Nc1Bf9PBvU9zqoyz6gVHKfMwkQ6u5hRs
XM86ZwI/LEvY5ISWYzoBK3rlB2KysQeqsrA9AAw4HI7XlTN/ElazlBuaGRNkuWev+7fdaX8w
OZTGORrAcEkndELCFfiDA2pYixjPE/yHDhgpxUGwxmRwvqB4xmBjhwJovUfpvzQtYzkEioN5
QbDXt/6AYZ7KPAHjeHMJjDGuhzVqhGsnLGtHu9N6KFe+NE5OgF94HEuqHkf/PIzMf46nEoNP
ANsCriIeN0anoYfBWrPUaXnMb1upY5bghSe1o1DOSVLQx1HnuKc0nIFDyLFEJ0ShY3G/Vldi
+NbAOOfDGp+NVWfh+YyutBv6eGulka9GI8edeSqv70Z+Xngqb0aDIKAz8qxm+qQTw143UUcm
Qz6kBpZ5ISZg2UTXke2gQXR9EcEUHs6jjZ9YitwzB4MYry6T/aOwi4sao64MhYJI+K2P0JAw
GFOu8sS2j/l0JRm48RjXCOTgK8O/dqqLh0S7zT7ur6drGwvTr53JVTQyj6Q/QRCmEda2UWv7
jSQwPB5NEp0P2DHZB1ICJ0gSpSM0ndryxqHnvP1uiR288KgkbmbSBmCoQbGUmjEF3xMWJsbl
KDeSTvqmqCIjkz5pQVUhslJNC0+/Adhw0AI5idxSVlxkJtCtIGUYs8erq0HweIWldQgNHYsM
gQecHyLKvn3a/709BGB91l+3r9u3kz42EuYs2H/HZhM3UDKBmz+H5nMbXU5FsraS0J/xFCCC
+LD93/ft2+ZHcNysX2p7ae0oFt00UFsz8MxuCLPnl22XVr/MZdEyExoOu3hYpg71fqwHgl/y
kAXb0+bTf9rcDwbq48LikCpyR+/CGXRSqiGKoPfoeTJQGQbZ9QcPGVV3d6Mr77YHVm92tntb
H34E9PX9ZV1zh6sRdNqmpdXDd8vNEGxg4oKnJHdMNxOqgMU/ka5Jc9yVzwUTIKQxJSBZQC1Z
kJV0vfweUi8O6GEU+QWEOC9cjAiuCrSoRSJl+QUUONjoEsrs0ne4BGN8iYpiFzBAMeXc7UQ6
j1cmMc3Cf4Huqjr/UWWAdwEHrQMYxFxNLyAmJL2AQbPPYJouIMnJ8gLGkmb5/AKOipYmlXPp
BCRmmqdSXToqxxXzYoBavLg3Oi9ldok7WTZP8snYcjmwxW55d3XtDE3ijDkDc2Kn63AgD5O0
SD5Hn53hhSikjaj7LPTPBXYPdIzWY6dHa33YfNudths07R+ft99B2aAybg1WRdZuJtEGtp/n
HGzaqPHb/LdJRnrVKfpvwHzjgYQAliVMTjVBtz/utoXZKlHnoRimNIpMu17ojoSYjegcF7oh
2JSgWFaO5YJ0+7oYFxRzx7Bs1QHNunlVM4ry7QNA9OSfYEaxOS6uK4DuhQqBIY6VWAfU5jMd
ao0vo1vjgAP/oPr3DlqWWhxniML1QiA2kX1vrAOHuX2ctu9JY085n3WAaJnhd2DHgheeFh4J
l49ORNWL5MmVQ8igdCCg+148CBBjVpHgADBi+ihT0g0D6lR8zJBdnrotStbuTO+jqZ2UiylT
NGGyG9xhf4Csm0NMJ5GZ4cXLuKnGdIA31xAeYuhc9lYiU/T8q+7FLkMJCpdEsshwTMX2rlNk
8CT9PMQ92JA5OHG6KMdwCjMdVndgqXb4W7DUy+kgaV1dOfIZhztldvGpWxt0mdWsgIgIK1BF
DgZNwZVWlX0fEc/368KgqI7IjQvby24V0nmoruBUydw6MEuLEvTuFL5hSipgVPxgbKa5gJJS
MdFVzK720n0ougkQ2YTA3c2x2JSmLhnsctINKoLGuoeox/1GJUCgFoOfkObLcNqNtY1aXYJ0
l6B78dpodzU68qupqCkzIsXz7vHXCrkSIswQdTCqJZgm3QFYxIt+OsgcSB6WpnmxbgH23J6k
IfraZ0DYSN0pL1WQs32fM8NTVBDZ3ZaGoCXRHOsQdiAXQ8BEcfOiYCib0SDgPditKjBeddP5
Y8tC8TjqEW93h33lYCrNHnUZrnu7nn61ro7gKINF5B1Ou8O1UckwE4gWfVpMqIdnQCHWGUMa
gkqxclkAKhIwsWjskXlFT6AljxUuHFQfX1Tba1HOQxve16RB8fLUaRtqd+FUszsIdAnK3mv6
3FkPziydXcVUTnk7s/zMi8MJanaFLUv3FzGu7+77KKYp77oTi7vGIkx0yycc1gL0tbVhju31
bFLlQW56AFK7LN1EmTGJ3WYvLyf7nZPmemoxrTLTdnOjH+Vcr0uVXqt618XCinvOgLrTDZe6
OO3Kc2Dam+s63eiafbvpBlzuUKzy7u4t57lrDN1W1vPQDoFW5w71xrmXUvXlAAfphpwumq4i
gOtxf+vZG0g/yTiLyuQq6nZa1qsD3tE6yTMdnJYcTOMKVFLftMn6gmJTeat8WxMuhXz+8c/1
cfsc/Nf0Cn0/7L/sXpwe3oYOYjfvjupOtbp/5wwl59CxhxPT0CxzupqsYQ83tr5bU869tcTW
A766Pwu3emPqujVofg9eL21LMurH67UyXYhBnUQ3qvCBnlJwBT0nYh6GAVvBsosMkarXDC5c
O/QGfg7mnbsQEAAMTbaB7uyO0TX5O5EuOhhor/SDlEhvQvf8D6OIhQ/BPIWrX6blOea3SRQJ
VO9gUf1xVN2wV45pzKvkivt2xMLVoT9sFohrb0lLDf1nu3k/rf982epnmoGuzZ6cNPiYZXGq
0Gr6b9WAZSjYQN2xwkiZ9OdtcQfo2nvzs0ML1CtMt6/7w48gbVPUbVbE9Ji/rP8M1i8v+836
tD/0cyYyKSzZwt90X7w9RMaVX1/XzS3xGCBv+YvTIo6Tyv5rXUo6fmPXdI6FT0TOlk/rumxK
soI4PbdtUdbAfOrITLZ23MwxtqhjaCYQy8XEjqTpMgQtz+a6B1bBPGHnJY1rNM1x7eggmVY2
3EVTJ3aPIBys6+pDFBSFsdPWWSOEuen2L5HXqW4ctKp4M+kr2tSlR7068yYpEo9u8VWbTp0A
IYn2ayFIsxfuc3uHauzwmU5sl1FsuKO6C6OcpQMAmo4xZcmEVGXoppodPP0RL5pxMCCczxtk
WLJTdgm97wc1Sa299dslLrAJtdeQqVsV60ScL2+ju52Mqncc7xajEPoIjT/Xtg128Z7QX8U8
VcclrMcHuh9MnqJ6TSz8NgoORnf1AOv3q4fI+zqb+bbdPh+D0z74tv5rGxhvKZagFVBPPdvK
E1aTc5703sb2vCZFTUBkx9EzZMk6trabyeOoDOHmlL+7D6JfQdVQkzvaCM3xA+3xiSjwSj2L
NQyQ6pxVzOCfuW6/1duN1qd1QDZYkQ5St/GnPgmSduW60qJDc2v4sJZ3Sny964q2f+02cD2H
3V9OM7qJ4zoFR/x9KF+Qh1a0VLM7DPZLeVhA9LJVGJKBZzR5eDW67bMaOl67TbX4gPer04Xh
5ilN8qHOMjpXaR57e3QVXCJJnAwDhBCaIuiOFIKD9hGg/mq8O7z+vT5sg5f9+nl7sFcSL4A1
SNRdRXV73Yl2vTbhC/3KyO8BNNtA8YoEWJihfWoEOhcDjqdBQBGsyIAVwSyG52CajnBQAkCR
hdSTAteas1B84A0wgudFgtZizCBUYjYNrbamBCusY/AN3LwVAnWx0WTnvZuJ9ZHhn3Ew/h+q
KqpjbV4o7w0M8FJTvH/WcuIwVzplmCfw97IYWEn9DptN0ZBcb77ZUth2HDgAl8tadD1ORBpI
/SgR/zjI6bB/0c0Ilkpg+P7jyxrkPT/sT/vN/sX+1P9rvqUcIr/sNqJinBufoK1k7LgKegAM
YJonNB57qU44nyS0Id7TDZ/f1y+b/esrOMTVaT33D3cYyTyS3n49rLswe/4AQk+q2+trGTRU
/srgJJMDLKX858vjIZuZsslUNY86wPWqUgGWs6iH/Co3y3uHms1TGsj379/3h5N9Ds64CTp2
x41PZkCBpSuMH73fBKlOuDQ1aaH1it92g/Ps713Et0zLUkZx911SbQEVqgN/aHHdPQoT+1FQ
YGlwtDZdL1ZDyt9vwuW9V8g7U42MvoAErYM4nxCLb/Z/v6HiD173+FA3+AW7lXaH7TFg1+F/
7G/m85xkzP/myjlyE9iFklUjzgbqwMwDttiNhOBacuw01Oag7+mxt+/vpz79Jm9g/v5NQ1AP
lHGMegATst5bMEgmvJp1tEUHKSVKsGUXyUGZszlJIhYbB0QvujhuDy+o1na1LnP4syLNwQEE
A3Lm63/w1XkEOu/ArTMbcrrMzBldjTl4QpaPW42URM3GnT+KUkGSGUC8y2lQMrpQA1Fjg8Nz
kEE+5CM0aFLxBVkMPItusSCyurSopeqg9C/Crn1giiiX154h8JTs4lw7Pl5FvuGETxj8P899
QNASJIe43kswXOFbbS8IPZKmlGzl+2o4PvtR1P1jKx40SfElSVfO+1/jRTideZ9Ltkgxhkb4
zf6KQMkyMtSLiwhwCUPmwSDgIY4HHmqZFYRXV6OcDLyC0ihzuVwuiT8ebWRN4h+WOIOii87+
lVYIeFYSYj7ql4CK34bSbyJlt9oD70n0dH141lqc/coDVIF25gz/kEo3zeMY5Q6G/rVkD6Pb
6+4g/Ns13wYQqofr8LcrX4u8QUjY2IhMZ6Igi4HQGKHINIIgC51BAii+wz9HRoSDNAqN4veC
SEr7vFcZLt+RN3/Tx2eUjIb/tj6sN6D0Lb+kTk0pK5s5d9928UzinxrT2auk3zHdTKox7ckw
Ol00JMYsi4YeyBcZW/7+UOZq5de81WOfS3BY3v9VdmXNbeNI+H1+hWoetmarnNnYjjPehzxA
FCRxzMs8dOSFpbFlRxvbUunYTfbXLxoHCRDdlPfBscNugiSuPtD9dSCWCs4yEpNbmmRgiHrz
uBDmz+rF0pKtYWRRk2PrTktBuL26+didW/oyBGjmPGAAS5dmXteht1x+vrn5yOoZE5eS8jz/
GPxfuDe4ZWqHBiEmeV2xvCzaXC+bmsOpf8wbFvQlTEbw2bcd0SuueWB5dXuLh2g7b+2HySfb
tw9AE1fkUMLUxxRX3Qx8kTC8MQNfc7gwB9ZFbK5rMgi4ENfuNUcRBMkCV+w0h+jwIc9HjIDm
0Fx6g/qzZBP4lHewnmXL8c1fk8eF+LzsXCOSK0zGEV/4rEbzdtea14bEZwTnE+EOS6oogk2r
7z3AZUR5J8StGsEE9wKHeQmCRQ0yLi6zOKwVfArubxL7ngo+wJ1NZYQ/WhjzMwKQJbj94/rz
j3qSESIjEbsbSRS9Qfl6kxllToqbSP1HfPtEZdvRWatlIH4yIvOSR0H3qLd1+niiShkPVwG2
nuEy1orNbnFfE5M8w8VGkcU4YdrF6DIDlSEpRWU2eHjZPnz37URBqi9vbm8V7pWWE6xBGeTy
uGCQTZdCjZH+qISXgGQH6Wiy78VKieEkGI4aDuv14PhtPVg9Pm7AgScWmXzs4XcnvdZ7G+UK
z6Kox1zGyNZXh0lQ5oRLR8xKeHvEk6ooWnzb2+kcBwDI0rn0zBaEsqvoBb+vhB1HoqsppirL
InwLmc69Ywgzbac8jwmbwWD3YQKlGNrQHu3kKrBeGQYxQ9mHnaM35Wo6vRw3T6e3BxhwM0C2
s89sLXAgNBkSRpUgxuCex+0QIN/xOIsIQwbuLj9f/5NAUBDkIvaSq2zqsgioRF1BLu/jRTfL
23h9+r7esl/4pIrIY/U8wG2bgKMbTsxHIasDSH5VYR/4Jsax7Ufdi9ynTnT2q923zcPB3yYY
4H+BZ1Cd5VjWtzLqJIKvpcSHI57aU4dVC6H/ZhSU28hNkFd+9v3qdT346/T0JDbiUddmcD3W
42FXe2gJswmzsSjgCnfP1cSl5NMlPj0EbTrBZ6Ug9ftrwIl+Obq8FgY2RRfmez1ZlIC4TbHo
1DuKHPMyT5OUwKxr/Ph437gqJvQDhNAvnUvqiMm5FIifcRhFObfTEDQhSLMlU2f2LkFmYA+j
sOz0PYQFhZMEkCBChh3qwr0pRHuMnQDw5nI7J52OAWgTTaL6pgwj+UY+EqY5Q8AmoTqVWj18
f9k8fzsO/jaIghEmuYzlFwCqJCsK3ZXoy0BoayR9EzSrOb3qf3KzBidMnrtZHWaOgsQm0Bya
Btu3w1aI+MfNYfey+qk3L38HEM1hdkc8Ypimata1PG/w7D/nsvgdVXFSfLn9iNPzdF58ubqx
Bg7iMtXJJK4lmy2w/9OsEUonuN6q0pUmkPzWVV/NwWV3y7SkK8BpIp0yDUdI0lPoOJaBZ8hK
YTctIaaXJ5MS91oKRsqRVE1D6vH6GNjMgWK3fgCLCG5ARDfcwT6RjlNJDvIK3+QkVUgOYgeT
H8qjOwK+BshCz88JXF5JTqsJI6ygENQKiCnsuV2KRJqsvM0kXfT+JE3ysMCXNbDwuKjHeGCi
JEc8IOw0SZ6FBRVtJulf7zj9dRMeD0PCjJX0MQFNI4lRmocpYcRKBnUKLLYZ0Cp6vlGfBJF0
8QnSQ0wzLOn+nbOoTHGPhno2nxepd2xnc+QBAYskiIuQpZQJBl2wzL2UeIchDIReS1OJ+Cig
/cmGhD4M1HIeJlMCxUx1aVIIqUYdOQFLFEhTpGfpTMJAnhL0sESgfvTQl2Mhz+iBzblaQXQL
IaDlp2PCDwAcKcTK9SwCiVXbP78SwmsLNEDOwt0lQM1YAlaZWCr0Kst4yaJlQm+QWSiEYNDT
APj1cpjE9GLMFoT/THYz+9oz0FkudDP67QoW9vVAweN+esY5YM/0cJSc8AEpWZlkUc8ulPct
TzBOWNGzwRcxy8s/02XvI8pwhisIkii0Uk54nzU9p1dQBfK7zorrnh0oiemni3FNe9/963Ik
pHPPCivETpHm9bTCQ32kAI+6AGTGlYpoDupcLhx9UCD+nienSzKKSVUIg2oahDUo5BHX9oCt
FQEHavMaZTQm3AtCBJMnmAmf1xEf4R2oEpdDGSPnbDCazkXfmqQLYQnbkfqS5Ol5OVRACofu
hTi4/PT59vJWU1rHQBkocwA3msFjMuuG6ShfWsyEfozkEkA0ni4LZLcD4PgyZ1LZf9TjgE0G
KvYxGDwF8qWBacoZAWlnWlF45d0Y59Yd6H6hNUcIF/RsTBGEfY0F2TgMYSomUVLhdKgV45F1
HNbDfnvYPh0H05+79f7DbPB8Wh+O2Ko4x9o+T2iLnNClRH9NKLfjJI1G45AQxcE0TwEGV0Pq
UhDhkZBD6aIfebeo8jFYTf1tAciJ4aiRaWx/rRDwYhkQ4mNu0pl895n0MRfb097xSJp2o7si
D+rw9urGyhoVV/msRK4OoWaavtoamNgTrP5iYTRMcbkappBNTzni8vXr9rje7bcPmD0GkcEl
RLfhBw/IzarR3evhGW0viwszzfEWnTuVySge/psOV03fBsG3ze7vgwNIg6cmjLcNjX192T6L
y8U2wOJAMbLysey3q8eH7St1I0pXh7GL7B/j/XoNeGPrwf12H95TjZxjlbxPp39tjocT1QZG
lvTN7/GCusmj2Scu0ea4VtThafPyCG4L07lIU++/qR31eRbEn24+1kXq15xpInOJV0fp1haQ
Qgkmr9UF5Kf+oNrEqI2a8a7Zps664sFo+7ravHmzz6F4k8+iunMPvw0jtyOO39MluV2N34OS
m5M0uy3T+ZncT308PqOWLMqAOuuQSW/4dkUIz2zuO+4hvPhBjBAm5Tya9YgMMqqoM3N55iZB
f/I06px6q3GfLp2aQ63cM8kwU6I803Qpay/KEKOAd1M4msb1pITsznb0dy+rI6R7utmoQVzf
pQkDffXKf64ZvPNtui+ZLVh9dZvEcPSL67kOFzyc5JJY2XU0iWvuKc3W+2F1lqTPICBig+Ng
6HeeD6eMTY0+NmseMF/bZW+P++3GyWljySiHBH8I+uJ57RXqM4tf32mpn4QdnHQDGJSVMx8c
96uHzdszGulT4hqS6vyuQ9dYR36T7Z0ycB1VukJCzyiiMKbWlMxdFH8nPMDtKZ2GiM8iTuSR
TbsuLaOxu1HXOpdGSC01wyzVbKTSMOdpbiGtteo2i0IoulePCwXNg78fX4BmJXiGOrCBOAQC
cAXgoNTmcWFgMCgv31hW2Q2JeKBRj0kVKlpN1lEas56776u0xGeDhN4p6jHxyRD2S9B00dkO
uc2R8pOjjNg9rE+PW5n/3o5nO1mErko9Ulp6iGntAhvojOaxMxWai8TshV9IP5gNx39layOD
aE2YHCphHH9CQtRSqpIQquCgT3WmvA79fDjtN8efGL7vHSciTgseVDDnhL3MCykeJfIL0o+y
7+GYVKGxNmjZ7uCo41VZVZjO62s4k1Qx974aNd4KPsbgQPjJoWbh6KT39kuZlegfFfGXXyGT
BEywC/gH0ngufq5eVxeQzLPbvF0cVk9r0eDm8QKyTZ6hjy/+2j396tSH+rbaP67fYLvt4DLo
lN6NkESb1cvmv36lb1k1Wiw1CJdVBYgzeWRnRemiXOCyq4fMPnon+dwUntAkngPwFrGlNDwA
paFfCOneDiP6LAm5IjbHZiyIHdAwA+ocwet+p+wBifUBmT4GV69pDyGjawkfIqW+b09vjweh
a64fvneyvF3sR1yGsXzEAVcOZikENKCP7z6jSUjQ8+nJYPM8Qvb44bg/PXiVjgDxsXkc+i6Q
FwyFtVjJyKoCVmT+uWc3fkehImnUvKYmqlvHDFkZbQRtZ8uydl0QlaknPaLNX3sAnt5vT8fN
m9sHoPjjaBkNoGeZJ0EmxBKk/MGY+BnNwBLxxFAtKZCPKHU5h9DypIJwZ0wCNWi1qY8WATLU
gha8y/m4wyFhRhl4BuH4KYtCDydCJgEtAaxASPkGiMvqyaaEJAEVH+x/7o7bwYvft85ggFtZ
qEHsjl8V1tG/z5Ol0fLy+uNNnUv0i0tL1BNPshVzCDe+vkLxdFu331eoEIf0taxskTooL+pS
FxvWXHORV+G6U2lN4o0UKl09kuET3SR2loW+M7vdIoQkNEVnOhV0u6Ugm1cA6Bk9ZaAMgz9H
hbYik+DHI4YgH8M9TpE9hyDTIBIk019STeXVWgM/EmxyEylKJ+rLAa1VmneYNEq2GBGx/TrA
l0oxKyUWX3Rn9040v/dQRJop5O0ArhQ227S8utsLif1dxhs/vq4Pz5hqpCLoPQS/Lh3ECFWl
tIVBljgSNRovE+gwpAhiHWY8akCW/iA57quQl20xFqGhFQBP47XwydrloZiSfuVRt+RtoynH
wzQCGJs8TxQ0XTujJX6E+BETYZh2T+z1EJDd+ovTigKw81vvpufp+LHXnVBpP8iS0FIUHlTl
SXUdAbRSjbkBo4Cqp9HFoDfLuor48PLq1n8JuM9Tf3yO0Zzl47pM0yiYsjBxkLEIbrymXZfr
5hwXwIQEhCy32ABICiKLxDZFKnM4+1c8mJ1gLsoR8dESIxEzGNgUZrNEZJMwisPSkm0WVYLC
SmgtG85tMhpqpDU7VlNWWZR4jpcfrz7Za1BwShTqbhVYy/XHRhLUmBVEkACH0PFCIl9TZWvU
dxcKwRxmcgzh8tgi67CoQsxpEjn5AbM4CpNqUVM58hpvSYqROWd3Bs0KXZbvXkK/2LA7eucc
rf86PT+Dlha+gZoHSCFu4D1E8YCVTaA+NNBQhEhTSMRiVJ3Ed/F/ymaHqVENi87RPVygHnEX
CKKctcLgzm1V9F0fq0581sf/bPcgRFou55gHo9uGnntXM9snXOUXkkF4HSBSXBbJymXzhPKl
ATlLQwhTI9xQ6il5KiX4OaQuxeyBv+rdXQJAsDt/VzCUnhdIh1AEoA/CSJmUVdGBl2sXvCy9
qoGtk5GqmXb+Y2axqSjrv/eM8DSYO3uJptl3vIIKxEee3xOhryWnghMEO7mHq8VSO+sOa1n1
JtMB+eo22HJRa9AaPaNM+g06ZNq8v2Ownn1Lw6YW87pkNpy+pkJyGQCLJqkp9WUwRjuzWe1L
pu5NuzPJK33uAnv5dz5v2oHGUcE0wD9It7vDxSDaPnw/7dT2PF29PXfs2ETstACQ2vE2Y/Sm
gqBD1BhZX64tTEgIfuxUKCCdFu/hU8R6WgGkOyvw5S40eSyhzKbLUl2J3BpnBvSS8Pz3daDy
gQqxB+A7e3zzxsjKrQABGK1U+O2w27zJjMOLwevpuP6xFn9Atazf7Wpf8kBAjjgEy1gxWraj
c9Z/LCDbAFdm31aIRKZ0N4aq5IteSLj5XDHVhVhyGSPSALR4mBeUq1oxyLemxZRiMuFsEe/C
p3ltSQRgYUf3x3zJp4rZqIowUa6B9kP7HAhFMO5pypia/8essLz5cagreHqKmqs86+o1mPLY
WJROMilokNKbmUCgKHg0e3Kz1c6tBC2xF513K+ohCole1DrLGXrRp4qYYit9002IG4ndwakT
wZ6PUSFLQYXrZVDpRAHokjNFFkM5N+mAKefjd7VFHosAld8XWGikCaByvsNb4vdaPOeejWC0
56bAjHJX4DWToL6bXyypQU+Xt3aL4zTUSc6y6bt4xkgZnLHOlFIMgr+rempU/W5ZKoQo64Jg
pXYwNl2FCZw8Z9iTFA5Dgqlb+FfhDWvcccmoSg11OALxPuBIjjuwyJIofUfSPafIQmB3S14R
YmZMz6mCQdYmeS6qtFKISajDQqGU8ial78ftZ2fV6Bsh5FJ7h6S7yS6rqICRlf/JV/vgjBWq
JFC6YxyHaXditi5fKGfH4Tw076u1FqbK71V/XNw6iDYWgfCqNByV5znzeUhnS5CxvuBm2RGy
Bh3u2JZfKS1pQnhUyVwFoyhfiIaOxha7YYRahYVtDbsDa/tPy/XhCKIO1Kpg++/1fvXslFW9
qyjTw+zj3SpvRDwCnOz18xjIHhhnmPfdwGh7GsMJiJjDparJ2Los1CV0K+37YCUzToej5U9u
92DnunfWpa7/DwqGZ1UkmgAA

--qjdjihavuqnpisjz--

