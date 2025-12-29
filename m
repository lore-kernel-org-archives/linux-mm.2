Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A92D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 12:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759A66B0089; Mon, 29 Dec 2025 07:26:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6BD6B008A; Mon, 29 Dec 2025 07:26:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A236B008C; Mon, 29 Dec 2025 07:26:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 516986B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:26:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E63A3C9FC8
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:26:12 +0000 (UTC)
X-FDA: 84272430984.21.495C8F6
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf19.hostedemail.com (Postfix) with ESMTP id 564951A0006
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:26:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DB4Mq7z8;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767011171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+W6DGY7qIcPDVlcv8bt7iI6QjbF6AUeFe1xm8LEWDtY=;
	b=EWV9Qp2yZ0DMUCAj36krz2jq/NcxsjYAh+ObXfxNBNHSsmKazCA8uV5mHPn1dingKVGpT+
	W38mr7eXMboDZiDoEwCsyIk4T1BSDTp+/WTZbXLRWrV37t5/jyPYz+6CFAHLtTAhWvLZLG
	JQYZ+cqQ1GDWdhCwiNHqrZiWxwxfRLc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DB4Mq7z8;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767011171; a=rsa-sha256;
	cv=none;
	b=d40mdtBcq0MhzDp1+kCEayDPteOyl8rwGIwh3gl4o2gXbP4GdxNZk7byEGi41r2/UpH6kp
	A75/YYenzieIFbMwAnLBIXpjsaUBzLwx0aPcZw24Reys6VMb5/Zu1mPFONkshMlpJ4OGDm
	VEvc3xf8vcw6unOPCrlSkbf1bV3nxG0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767011161; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+W6DGY7qIcPDVlcv8bt7iI6QjbF6AUeFe1xm8LEWDtY=;
 b=DB4Mq7z8+o8OzcpUo48XK0VHzln1/I+kYCEMhl5Se6Zb8wjKI9i61lvccRcqZMDQbwy4HF
 +ZK3SwIeOZYwKBJTLx1ZxpV9rqJGGb1BOyO8uOq2lJO2H940KRYh4vhGzg2yQoEqN9+k4M
 Kj69DktgMeSlLRhxUzJ5CNPO4g75D1WjNW3L7W9HKzh4zF/pUx6l3phFmYckEF8IbQpw2L
 3F7npi3wVIo7PsnV8rFbekvDtKWXupvt15fgzr69sUZKcJn01nr7VLo0PxG1j9qpW0d115
 frj2QQFzoUqUjXdAavfLNYjl1XMFGVE9L4kp/SVn0q4HAy/x2EExLYkXknCYIQ==
To: <fvdl@google.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAPTztWZPGAijX2eAt_tKfF=XDnN2nXHRBXPzh0xsE5Czfw+FAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
Date: Mon, 29 Dec 2025 20:25:37 +0800
X-Lms-Return-Path: <lba+269527357+5bbae6+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH 4/8] mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
Message-Id: <20251229122537.6903-1-lizhe.67@bytedance.com>
References: <CAPTztWZPGAijX2eAt_tKfF=XDnN2nXHRBXPzh0xsE5Czfw+FAg@mail.gmail.com>
X-Mailer: git-send-email 2.45.2
X-Stat-Signature: aij9t5a4cjtg48fdbn76sw7if3mrpif9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 564951A0006
X-HE-Tag: 1767011168-163707
X-HE-Meta: U2FsdGVkX18k1UVamoDyMoVRpFPB01nErxK4/wq4FYwirMVYvyqwbvn5uJ1nUPKrwoAy+ujt4ABBhb7nJVEEbIMbnq5d5j10bg6NcjB4Rpbr0DkBaaqw4i0MPuhHKdc+KUZ5F+yoeLs/TNmik3B3jct97vV+azWkuXQW0lWK46qJHBkNCPD3b128Tf6tsmGgFIXGoRRYEr5feuiUpTwKgRghCiYN6GGng/EhZEQqqtnJNOr2BIYkwlcItEE9c0ftwkdm1Mu5f4Z4GDRm1Oi1rBgjusIoWrVYiWuzD3N2vUIfHRaGLXhvoVXb2wUXk6LR/ssLSXid2dpz6GCLFx2XG/vEtSD6VG8fS5Su69eYQS4BbMqGoHUqaN042q5U4DiVu3Sc5khzfeUq9V7Twfnx5JiXjg/YIAWC5pSmRNWcOGGwac8EySGm3KAqIFP4ibuNGN7p6ypcVOip7xY2m1l8Dqz+x4ItpmerNyvryhfiafMqJnLHNSehW2PSTlVd1BF3laETV1M/wi0W2H63OD95qGHd1M1ccxR4M2x2jjjL6csexaPquKVaVllXdgvpQ/gPuxiNnIWz+5zmt7N0H0cQUnklr6FhcXpoQ06L27H50nG5qgICWRx7iel9YH/jthmckmw+fgLMAFunBr1ykpV0ep21XriyXbEQOc/Yk05l+4i1k34hpnwmnmKTBceaOK68WEXYmhWw40tquhaWTp2KYBuaLfz2A3m/a0ADaDlSkdTsr6WfcE7EsCSVdQOqLe4G92ganT876GtjIsAoVSHns9z/dAM78yKKWaGiixwPaBB52X+8lsEegrkwFBBubIYi0KnineMG+Qu/2Xx/05yFDVsj2ODYydmtIv0IDTa9tYJFLiPwa0pCJT19E4sEs8W42cu6xuSNCG4kwog8C3+oXuUUNqq9PnJeAEalCs30GurMzGDT5s/r0+8/PusNYD3LxeuxjtEooxTdcGxp+Gv
 nqqW7xWG
 HOlRefiXk6NZsFimgOQ3SGDFJ3NmmEHNNCMSy+6G5ESO+l5O3+so8kL7E3+gsuHIyKi7PWDNJtQcXqKhVapOfftG79uoNbxuo843nFUbHKGuOAsrndf6MwP8ZGiCVtIK8u0Ts+CQYdZpClt3lLg/VKCl/5v6a6a2/L6Cyh15rI4nB2PvxgRs3ydIzOf48Aa3xN9GDgkp7bB3anqEIn/ThOkwkYPf7YvvAwoAA4cbb8PHU9j7ZUm52tZPfw3pn2RygbBHoVmn4A+YviRvWPsc/prgOUcPweJsuaO9fzFdWTX685yU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 10:51:01 -0800, fvdl@google.com wrote:

> > +static ssize_t zeroable_hugepages_show(struct kobject *kobj,
> > +                                       struct kobj_attribute *attr, char *buf)
> > +{
> > +       struct hstate *h;
> > +       unsigned long free_huge_pages_zero;
> > +       int nid;
> > +
> > +       h = kobj_to_hstate(kobj, &nid);
> > +       if (WARN_ON(nid == NUMA_NO_NODE))
> > +               return -EPERM;
> > +
> > +       free_huge_pages_zero = h->free_huge_pages_node[nid] -
> > +                              h->free_huge_pages_zero_node[nid];
> > +
> > +       return sprintf(buf, "%lu\n", free_huge_pages_zero);
> > +}
> > +
> > +static inline bool zero_should_abort(struct hstate *h, int nid)
> > +{
> > +       return (h->free_huge_pages_zero_node[nid] ==
> > +               h->free_huge_pages_node[nid]) ||
> > +               list_empty(&h->hugepage_freelists[nid]);
> > +}
> > +
> > +static void zero_free_hugepages_nid(struct hstate *h,
> > +                                  int nid, unsigned int nr_zero)
> > +{
> > +       struct list_head *freelist = &h->hugepage_freelists[nid];
> > +       unsigned int nr_zerod = 0;
> > +       struct folio *folio;
> > +
> > +       if (zero_should_abort(h, nid))
> > +               return;
> > +
> > +       spin_lock_irq(&hugetlb_lock);
> > +
> > +       while (nr_zerod < nr_zero) {
> > +
> > +               if (zero_should_abort(h, nid) || fatal_signal_pending(current))
> > +                       break;
> > +
> > +               freelist = freelist->prev;
> > +               if (unlikely(list_is_head(freelist, &h->hugepage_freelists[nid])))
> > +                       break;
> > +               folio = list_entry(freelist, struct folio, lru);
> > +
> > +               if (folio_test_hugetlb_zeroed(folio) ||
> > +                   folio_test_hugetlb_zeroing(folio))
> > +                       continue;
> > +
> > +               folio_set_hugetlb_zeroing(folio);
> > +
> > +               /*
> > +                * Incrementing this here is a bit of a fib, since
> > +                * the page hasn't been cleared yet (it will be done
> > +                * immediately after dropping the lock below). But
> > +                * it keeps the count consistent with the overall
> > +                * free count in case the page gets taken off the
> > +                * freelist while we're working on it.
> > +                */
> > +               h->free_huge_pages_zero_node[nid]++;
> > +               spin_unlock_irq(&hugetlb_lock);
> > +
> > +               /*
> > +                * HWPoison pages may show up on the freelist.
> > +                * Don't try to zero it out, but do set the flag
> > +                * and counts, so that we don't consider it again.
> > +                */
> > +               if (!folio_test_hwpoison(folio))
> > +                       folio_zero_user(folio, 0);
> > +
> > +               cond_resched();
> > +
> > +               spin_lock_irq(&hugetlb_lock);
> > +               folio_set_hugetlb_zeroed(folio);
> > +               folio_clear_hugetlb_zeroing(folio);
> > +
> > +               /*
> > +                * If the page is still on the free list, move
> > +                * it to the head.
> > +                */
> > +               if (folio_test_hugetlb_freed(folio))
> > +                       list_move(&folio->lru, &h->hugepage_freelists[nid]);
> > +
> > +               /*
> > +                * If someone was waiting for the zero to
> > +                * finish, wake them up.
> > +                */
> > +               if (waitqueue_active(&h->dqzero_wait[nid]))
> > +                       wake_up(&h->dqzero_wait[nid]);
> > +               nr_zerod++;
> > +               freelist = &h->hugepage_freelists[nid];
> > +       }
> > +       spin_unlock_irq(&hugetlb_lock);
> > +}
> 
> Nit: s/nr_zerod/nr_zeroed/

Thank you for the reminder. I will address this issue in v2.

> Feels like the list logic can be cleaned up a bit here. Since the
> zeroed folios are at the head of the list, and the dirty ones at the
> tail, and you start walking from the tail, you don't need to check if
> you circled back to the head - just stop if you encounter a prezeroed
> folio. If you encounter a prezeroed folio while walking from the tail,
> that means that all other folios from that one to the head will also
> be prezeroed already.

Thank you for the thoughtful suggestion. Your line of reasoning is,
in most situations, perfectly valid. Under extreme concurrency,
however, a corner case can still appear. Imagine two processes
simultaneously zeroing huge pages: Process A enters
zero_free_hugepages_nid(), completes the zeroing of one huge page,
and marks the folio in the list as pre-zeroed. Should Process B enter
the same function moments later and decide to exit as soon as it
meets a prezeroed folio, the intended parallel zeroing would quietly
fall back to a single-threaded pace.

Thanks,
Zhe

