Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336DC606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558186B05B4; Wed,  4 Nov 2026 11:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531BA6B05B9; Wed,  4 Nov 2026 11:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E5C6B05BA; Wed,  4 Nov 2026 11:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 146FD6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:36:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 098441C415D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:36:09 +0000 (UTC)
X-FDA: 85397988858.30.D67EF97
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5EC2E2000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:36:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wCjGeI6Z;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eWbBWnFJl+uiLzhbPXd3D9E7kgIone5xiQRAQoBq94=;
	b=ynbe1IR6McKxy9cHVji+HMibEoyDeJ0LBQNbrIt94KvZVgbDsGVYwGYfAzyyw2ZGSt6Xeu
	qizmkBKCrz1bpnB5z9aAWe+p5STXbgWgLi4csoWTZCr+p44mEJh7Bjik1YLfJE5YwFrBco
	eu3j2nncv8UYojcQSGdjXozCIl7b32E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810167;
	b=BIhUL22Eu3790tJXV3D7cE5cWtMBu3ftcrVqBqfdsM/h6/jYezr4/kTmBhenvLKnvOV8Qf
	HwqToW1VNbORYIIZvfZuqmNGXsQNO4adABxPZg2bqLIZYL4XEQY7fU1fsgrJAfKo8Y41k0
	PJa3mRlGPmmSnnyRDaMtH/EtuwIdYoQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wCjGeI6Z;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ck0BKnLiDu5kTQsaHCMIpLW/PX9Nr/jcRPf51hdq1dU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793810160; v=1; x=1794414960;
 b=wCjGeI6ZTYzB72AcZahHsWTRJQDfQ36wYmXE6dn6RY/CNegdZvHiHLy5aX3D+8suz/prsxcN
 MeCycpuBQ5Ih7AY5m2HvwZUQlJg+dS+eX8U8tv61bbOrcjLywOZOqXhnpQTYX8YdWl2Y0XlYEEE
 lBDKO6ENQHHuRhXTwdxWyXNA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 86022f17ab87f471;
	Wed, 04 Nov 2026 16:36:00 +0000
X-Mizu-Trace-ID: 86022f17ab87f471
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 14/30] mm: zswap: reject high-order swap cache allocations backed by zswap
Date: Wed,  4 Nov 2026 08:35:51 -0800
Message-ID: <20261104163554.3508359-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zN+9F0yh0bTDsysumziGc=zgs7vZMLvt-nWPhxq36wT0Q@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EC2E2000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: yaww1qzdxzjn9sda3m5youezdodn6u8a
X-Rspam-User: 
X-HE-Tag: 1793810165-354459
X-HE-Meta: U2FsdGVkX1+Ma9gCHVuMWHw/oqwbaJBGnl/FsKqgcL+Rwf32AvIw9k1dI+40kDAYpu//apEfULP/O5UtyT2+Vt7hyLz8IsPrGp517DSS5B8/rXE4B2nTth8Gq34BKRd3uCV1APYSAdrGnuaVH+7Lqdi5M8Rn0v7zwFbK+vhE/EjjtZpdVQza/Ao6qF9tIgTkfhlULdRdl2AvwB9aDAXkHGjGtANlJ5PLh/HzGGu9GRzh+AOUTx13tYfsbpUNTsjDbpYmTCsAwB1mcKvfS36DC+0D2YkqsP3/XU1D/lnAbothF+eHJij4g++JCEHRY0lx1QmUBy6E2zCHzSG2qG18w4qGmZKnGtB8AdpNqpABTOG3xoeO+7jZW8hF7O7AhNaqKeJON7Gtzn91OheJvwZdMYT8AsjMnH4nWZOMcPpqaClX38i8zDk8UFJGzVbybxxp7r8A/WnqUWR89rSVM4jpDew28jqY99KMw4fkLQSK/T8fkshhoH9LlL9erENUBhpnUa4vvxtBvdhHHeIcm5VxMZ0B57GVoXK4PHETJoj/4V/wPvm1SpZlLe2NDLXG81ZDCyybEbKbsR5Cx653FbCdsUKJotC5Tx71S3vPi0NleJrd/rpQQetalsbtPomNm6b5kThTyOVsDkH6WmRnj1LYmFsO4OTuKkpqL75UzlkaMQ8bjypRTYXk2PCAdnDm7M98iCFwYzQtdFd2Dvs4ie0hLQqE0atQj/FAJndSdIRIPkP2mPCclznCv9nbiUDQT/2vI947tXV8pAnAgCv8mXXyv+2nw/IZvF5Z3xI1ijfYiU6vUbGqXSgsOfU5MYEXnkPbkEUEFmhogL9+a50l39m7Ra293wFPIii4WjDyhYZTXYcJmteMmu+ooHac+vcQXq0G0ijqfq910kMHCNpsvNZC3p9VKYH9XvZ5C5B3LtWciAXzX8CsQXutMeH93yYcJoNwrOL4xV/haXzE2pPHtX8
 TeTCUvAJ
 /6+uNmCNoFy98IrcWlQSI6n8w+Tuitb+PG41sjjUts2F9jVCJcOSBtKcREbkxdcOozG+Ha0mva1MZZXW5V/FmTuM5hke6+Uf0Sa/w3fxty4VTKdVtMnC9fn5+28k+AFA/I7HrMRiRHN7n5rK6ufjtXcGhnuQnNGYlu77UhNBtbMUCPDG2iusmw6x+CFjSmVUYAMqJqwtYLcU6ZH1Iadfj4axyHSnFSlkiJIVOJKTP2g0kdhY3madonhbjyIGgdHj5HAgUP6uqHeJEjvR9S2cIFe8VLyjRL+7RZUxY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 5 Oct 2026 13:18:24 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Fri, Oct 2, 2026 at 2:56 AM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > zswap stores swapped-out pages one at a time, so a range of swap slots can
> > be split between zswap entries and the backing device. A high-order
> > swap-cache folio over such a range cannot be read back in one go: the disk
> > read would return stale or zero data for every slot zswap owns.
> >
> > Reject that in __swap_cache_alloc(). Do the check after the folio is in the
> > swap cache: from that point zswap can neither start storing nor start
> > writing back any slot in the range, so the answer is stable. Callers
> > already fall back to order-0, which zswap_load() handles per page.
> >
> > Export zswap_is_present() for the PMD-order swap-in users added later.
> >
> > Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Overall looks good, but I think it can be split into 3 patches (one of
> which doesn't have to be part of this series), see below.

Thanks for the review! I have followed your suggestion and split it into
3 patches now.

> 
> 
> 
> > ---
> >  include/linux/zswap.h |  6 ++++++
> >  mm/swap_state.c       | 39 +++++++++++++++++++++++++--------------
> >  mm/zswap.c            | 12 +++++++++---
> >  3 files changed, 40 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> > index df6cafbe95dc0..94746fb71bb65 100644
> > --- a/include/linux/zswap.h
> > +++ b/include/linux/zswap.h
> > @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
> >  void zswap_folio_swapin(struct folio *folio);
> >  bool zswap_is_enabled(void);
> >  bool zswap_never_enabled(void);
> > +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
> >  #else
> >
> >  struct zswap_lruvec_state {};
> > @@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(void)
> >         return true;
> >  }
> >
> > +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> > +{
> > +       return false;
> > +}
> > +
> >  #endif
> >
> >  #endif /* _LINUX_ZSWAP_H */
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 625c185a1ca4d..251b48b2c60e1 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/kernel_stat.h>
> >  #include <linux/mempolicy.h>
> >  #include <linux/swap.h>
> > +#include <linux/zswap.h>
> >  #include <linux/leafops.h>
> >  #include <linux/init.h>
> >  #include <linux/pagemap.h>
> > @@ -466,26 +467,27 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> >         __swap_cache_do_add_folio(ci, folio, entry);
> >         spin_unlock(&ci->lock);
> >
> > +       /*
> > +        * Now that the folio is in the swap cache, zswap can no longer start
> > +        * storing or writing back any slot in the range, so this is a stable
> > +        * answer. Reject a high-order allocation over a range that already
> > +        * has per-page zswap entries.
> > +        */
> > +       if (order && zswap_is_present(entry, nr_pages)) {
> > +               err = -EBUSY;
> > +               goto delete_folio;
> > +       }
> > +
> >         if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
> >                                            vmf ? vmf->vma->vm_mm : NULL, gfp)) {
> > -               spin_lock(&ci->lock);
> > -               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> > -               spin_unlock(&ci->lock);
> > -               folio_unlock(folio);
> > -               /* nr_pages refs from swap cache, 1 from allocation */
> > -               folio_put_refs(folio, nr_pages + 1);
> > +               err = -ENOMEM;
> >                 count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> > -               return ERR_PTR(-ENOMEM);
> > +               goto delete_folio;
> >         }
> >
> >         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> > -               spin_lock(&ci->lock);
> > -               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> > -               spin_unlock(&ci->lock);
> > -               folio_unlock(folio);
> > -               /* nr_pages refs from swap cache, 1 from allocation */
> > -               folio_put_refs(folio, nr_pages + 1);
> > -               return ERR_PTR(-ENOMEM);
> > +               err = -ENOMEM;
> > +               goto delete_folio;
> >         }
> >
> >         /* memsw uncharges swap when folio is added to swap cache */
> > @@ -499,6 +501,15 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> >         /* Caller will initiate read into locked new_folio */
> >         folio_add_lru(folio);
> >         return folio;
> > +
> > +delete_folio:
> > +       spin_lock(&ci->lock);
> > +       __swap_cache_do_del_folio(ci, folio, entry, shadow);
> > +       spin_unlock(&ci->lock);
> > +       folio_unlock(folio);
> > +       /* nr_pages refs from swap cache, 1 from allocation */
> > +       folio_put_refs(folio, nr_pages + 1);
> > +       return ERR_PTR(err);
> 
> Nit: You can pull the refactoring into a separate patch (as well as
> most zswap changes, see below), so that this patch only has the
> logical change to bail for higher orders if any entry is in zswap.
> 
> >  }
> >
> >  /**
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 507f2d19fd2a4..f5b5827d30084 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1587,11 +1587,14 @@ bool zswap_store(struct folio *folio)
> >   * @entry: base swap entry of the range
> >   * @nr: number of contiguous slots to check
> >   *
> > - * Context: The caller must keep the range pinned, otherwise the answer can
> > - * change under it.
> > + * Context: Unless the caller keeps the range pinned, the answer is only a
> > + * hint: zswap can store or write back a slot right after this returns. A
> > + * caller that needs a stable answer must pin the range first, as
> > + * __swap_cache_alloc() does by inserting the folio into the swap cache before
> > + * asking.
> 
> I would rather avoid naming specific functions as it will go stale
> quickly, and instead list the ways of "pinning" a range.
> 
> Also, generally, the changes to mm/zswap.c seem orthogonal to this
> patch and can be a separate patch (which would be clearer if
> __swap_cache_alloc() isn't named here).
> 
> >   * Return: true if at least one slot in the range is in zswap.
> >   */
> > -static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> > +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> >  {
> >         pgoff_t offset = swp_offset(entry);
> >         struct xarray *tree = swap_zswap_tree(entry);
> > @@ -1605,6 +1608,9 @@ static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> >          */
> >         BUILD_BUG_ON(SWAPFILE_CLUSTER > ZSWAP_ADDRESS_SPACE_PAGES);
> >
> > +       if (zswap_never_enabled())
> > +               return false;
> > +
> >         return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
> >  }
> >
> > --
> > 2.53.0-Meta
> >
> 

