Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1960E92FE3
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 02:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B746B0089; Mon, 29 Dec 2025 21:41:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4CE6B008A; Mon, 29 Dec 2025 21:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7756B008C; Mon, 29 Dec 2025 21:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19E216B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:41:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B31D13C5B9
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:41:41 +0000 (UTC)
X-FDA: 84274586802.26.034AC38
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B7EB140007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:41:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="B/fHVAtJ";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767062499; a=rsa-sha256;
	cv=none;
	b=m3uvvoSkv8mDJ/dyFIRBTI8LNYaE1d/hxtWB8j+Um1vFtWMM3JmrMh94Q4nC+gz2P44Vpp
	HXZicAqJf2FCJElpPsuz7aBBtw9Ih3Lsnim/M2K1hHCdvTZq/vBU0rGd3mQ1za/WpO9xIv
	2vKkOFYIp/7e2/2M8gAbc9cJcMf+n6w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="B/fHVAtJ";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767062499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuyBlAAtiqXwXnsGaaUroTpLCkz20Z8FGXFlzJIDhS0=;
	b=oAelqcKLK6oxup/X9cpksAYJzw99feoC1EU0/AD61qbv2rOacerWjyfb6E0Fi8mcdFSrrK
	dvzlgZw2jjd9VUZtJx5s56k8BOmyCtwSIfFOCeO9la3aVdPY+SInxjjNTepO3osy7jyRQI
	ceSk9qbJ2Hnk7t2/r4xciDc1YwYlf2Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767062491; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=nuyBlAAtiqXwXnsGaaUroTpLCkz20Z8FGXFlzJIDhS0=;
 b=B/fHVAtJqmicDLAslkGTzU/m3ZJz2K+kBerRf9SRjEpGGfVmF80VvdealAEHjqjcUYwDjN
 3C2ahUut/tzk3lZS1P4iev3/naQJC5G279pnZKd+a5M6EIQvSspZDE7jsKQYHAl9O1lY8p
 5NEXIx9H9iGCRMu8T9lMhbf1c/8SzMNNhLXDyu83RqhK6Z7uLO+OBvwFkocwog2PycAVlf
 OWkVwsREcE2Ucu+ysHpGu0TBw9p0i5AAnc0WdcIijO2Xg+rsMpfqJZWk9VxexY5JCm1sdr
 CgvIf+8InNR3C4QQMyqf6uyWRRe0FRu80hDiZwbg0LXrszoBk2RtqBONwmHI0A==
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+269533bd9+9a2c64+kvack.org+lizhe.67@bytedance.com>
References: <CAPTztWYMhh3+V=-jXaMz5muTsj8fBX29umgJcsW7JfHA2LouuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Dec 2025 10:41:16 +0800
Message-Id: <20251230024118.5263-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <CAPTztWYMhh3+V=-jXaMz5muTsj8fBX29umgJcsW7JfHA2LouuA@mail.gmail.com>
To: <fvdl@google.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH 4/8] mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B7EB140007
X-Stat-Signature: b8ck9zfk9dmu6gs4emp5zepnep43jrpm
X-Rspam-User: 
X-HE-Tag: 1767062497-866213
X-HE-Meta: U2FsdGVkX18/iGhsRVnN9jRQsrhTutmmyVylgGUH/kpH9DLrw8N7xqoIo63P6vfd94LIb1JcUdiIF5cu+PhutCqfehQ1jhiyHtXBYQ0crgVDik4kE41Hpl1Mh5uvgbkjQ9GwYfoTW439/Bg33SzDV7oxx3CwwhIOF6CnjxTDdMOozLb9gOcT3PY67ScuENXOaf/5TVZ5Fk6/ca1SeNlVbej2236mpdfNNbdVT4MtKFvxhliAbDsqErEao8g0X/B63zu1OQrF2xRmH4xlrejIGMVdnFtVtBt1Y6GtwswDS3x+o+TYsDYEJI/Bb3ZuTSWrgshkJMuCXikrCaadv6D7BQavtzsMJXQ4ysnfzHU5+jCexAwxp5wGFLeJZOhjpR/KItnFzKBAP3qooo870+YObt0ireGtaDzz9d0a6scn1O5gucTYsnwNcda5AxRa7nAaLtgIC1J4IsYvmInyfrRNq01HRAPWcftTCBaW7BA77DDOsFMPnOowynLas6EU+rk3anKVgzxjtV+/cwKoH4kUsZF3LoiREF11oh7VI1lX5nwpz26K43QyL8hf++WRPxgh1ZNqFhn04nPMUtVQ56xnMKkC2p40VnZEv/4bcXcxvbE3cPZB+sVC7ZRXcjKdc+xsHWZ4QEfLeoWQXZ2U52S/v/mz9RzHyZ/LgSIIVKnzgedUNapHhL3tzKiFqab19SsUwErLVAI4+Es4HDLJD7pMAYQnh2FQ+kEMeF8AN0gw/t3y43nIAlydsJOZXsvUR2GaP/kHE+7lm6ErnA2ItR2o1qQKr3Uoo3jvtde5GBCzEWBfCfXfGj1A4VoIV9eEAvHSp98LRteza7DrMpcGOmE10O2bLkbANDxTLiPbDrv3p0/8eRD4vgSqjJdC6O6S/JKQJBFfZqzsZ5uYj6QZefvAUWUGjj569tFIfhPbN0Fe1igQmDPLL83r1p+X8Td6zWKkAt4G/pq/y41TWm9lzs6
 JlX1+rXQ
 MwJFdcy6S1BSO8rcmjPkmI0MYiFstIGpq6uhqgPvf7OJuel00t7h8H4qQNf1o16FS1pa3eLpd7bWnVxf/xZrbpV/Gjt7jjIulaGWIR3sE/jOHUe1PN1Kmf5m1K9yvl/WTCsCmIKe0bblQ+6ciT28OCHuStOla1Wwhnj40Rh/dAaGG3f21hokcpJk++z/KP4ubOac0G/X3Y2j63idybktUG9PNS3rHYRgwJw9sOQ1r5uDD34NSa1+8MkSF3L1KwI7xuS08zETPr16affN8b6znGbrXMJS/AIWmpJxvbRRStU1YKjWs76/lGXscz+lSuLWko4PT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, 29 Dec 2025 10:57:23 -0800, fvdl@google.com wrote:
>=20
> On Mon, Dec 29, 2025 at 4:26=E2=80=AFAM Li Zhe <lizhe.67@bytedance.com> w=
rote:
> >
> > On Fri, 26 Dec 2025 10:51:01 -0800, fvdl@google.com wrote:
> >
> > > > +static ssize_t zeroable_hugepages_show(struct kobject *kobj,
> > > > +                                       struct kobj_attribute *attr=
, char *buf)
> > > > +{
> > > > +       struct hstate *h;
> > > > +       unsigned long free_huge_pages_zero;
> > > > +       int nid;
> > > > +
> > > > +       h =3D kobj_to_hstate(kobj, &nid);
> > > > +       if (WARN_ON(nid =3D=3D NUMA_NO_NODE))
> > > > +               return -EPERM;
> > > > +
> > > > +       free_huge_pages_zero =3D h->free_huge_pages_node[nid] -
> > > > +                              h->free_huge_pages_zero_node[nid];
> > > > +
> > > > +       return sprintf(buf, "%lu\n", free_huge_pages_zero);
> > > > +}
> > > > +
> > > > +static inline bool zero_should_abort(struct hstate *h, int nid)
> > > > +{
> > > > +       return (h->free_huge_pages_zero_node[nid] =3D=3D
> > > > +               h->free_huge_pages_node[nid]) ||
> > > > +               list_empty(&h->hugepage_freelists[nid]);
> > > > +}
> > > > +
> > > > +static void zero_free_hugepages_nid(struct hstate *h,
> > > > +                                  int nid, unsigned int nr_zero)
> > > > +{
> > > > +       struct list_head *freelist =3D &h->hugepage_freelists[nid];
> > > > +       unsigned int nr_zerod =3D 0;
> > > > +       struct folio *folio;
> > > > +
> > > > +       if (zero_should_abort(h, nid))
> > > > +               return;
> > > > +
> > > > +       spin_lock_irq(&hugetlb_lock);
> > > > +
> > > > +       while (nr_zerod < nr_zero) {
> > > > +
> > > > +               if (zero_should_abort(h, nid) || fatal_signal_pendi=
ng(current))
> > > > +                       break;
> > > > +
> > > > +               freelist =3D freelist->prev;
> > > > +               if (unlikely(list_is_head(freelist, &h->hugepage_fr=
eelists[nid])))
> > > > +                       break;
> > > > +               folio =3D list_entry(freelist, struct folio, lru);
> > > > +
> > > > +               if (folio_test_hugetlb_zeroed(folio) ||
> > > > +                   folio_test_hugetlb_zeroing(folio))
> > > > +                       continue;
> > > > +
> > > > +               folio_set_hugetlb_zeroing(folio);
> > > > +
> > > > +               /*
> > > > +                * Incrementing this here is a bit of a fib, since
> > > > +                * the page hasn't been cleared yet (it will be don=
e
> > > > +                * immediately after dropping the lock below). But
> > > > +                * it keeps the count consistent with the overall
> > > > +                * free count in case the page gets taken off the
> > > > +                * freelist while we're working on it.
> > > > +                */
> > > > +               h->free_huge_pages_zero_node[nid]++;
> > > > +               spin_unlock_irq(&hugetlb_lock);
> > > > +
> > > > +               /*
> > > > +                * HWPoison pages may show up on the freelist.
> > > > +                * Don't try to zero it out, but do set the flag
> > > > +                * and counts, so that we don't consider it again.
> > > > +                */
> > > > +               if (!folio_test_hwpoison(folio))
> > > > +                       folio_zero_user(folio, 0);
> > > > +
> > > > +               cond_resched();
> > > > +
> > > > +               spin_lock_irq(&hugetlb_lock);
> > > > +               folio_set_hugetlb_zeroed(folio);
> > > > +               folio_clear_hugetlb_zeroing(folio);
> > > > +
> > > > +               /*
> > > > +                * If the page is still on the free list, move
> > > > +                * it to the head.
> > > > +                */
> > > > +               if (folio_test_hugetlb_freed(folio))
> > > > +                       list_move(&folio->lru, &h->hugepage_freelis=
ts[nid]);
> > > > +
> > > > +               /*
> > > > +                * If someone was waiting for the zero to
> > > > +                * finish, wake them up.
> > > > +                */
> > > > +               if (waitqueue_active(&h->dqzero_wait[nid]))
> > > > +                       wake_up(&h->dqzero_wait[nid]);
> > > > +               nr_zerod++;
> > > > +               freelist =3D &h->hugepage_freelists[nid];
> > > > +       }
> > > > +       spin_unlock_irq(&hugetlb_lock);
> > > > +}
> > >
> > > Nit: s/nr_zerod/nr_zeroed/
> >
> > Thank you for the reminder. I will address this issue in v2.
> >
> > > Feels like the list logic can be cleaned up a bit here. Since the
> > > zeroed folios are at the head of the list, and the dirty ones at the
> > > tail, and you start walking from the tail, you don't need to check if
> > > you circled back to the head - just stop if you encounter a prezeroed
> > > folio. If you encounter a prezeroed folio while walking from the tail=
,
> > > that means that all other folios from that one to the head will also
> > > be prezeroed already.
> >
> > Thank you for the thoughtful suggestion. Your line of reasoning is,
> > in most situations, perfectly valid. Under extreme concurrency,
> > however, a corner case can still appear. Imagine two processes
> > simultaneously zeroing huge pages: Process A enters
> > zero_free_hugepages_nid(), completes the zeroing of one huge page,
> > and marks the folio in the list as pre-zeroed. Should Process B enter
> > the same function moments later and decide to exit as soon as it
> > meets a prezeroed folio, the intended parallel zeroing would quietly
> > fall back to a single-threaded pace.
>=20
> Hm, setting the prezeroed bit and moving the folio to the front of the
> free list happens while holding hugetlb_lock. In other words, if you
> encounter a folio with the prezeroed bit set while holding
> hugetlb_lock, it will always be in a contiguous stretch of prezeroed
> folios at the head of the free list.
>=20
> Since the check for 'is this already prezeroed' is done while holding
> hugetlb_lock, you know for sure that the folio is part of a list of
> prezeroed folios at the head, and you can stop, right?

Sorry for the confusion earlier. You're right, this does make
zero_free_hugepages_nid() simpler. I'll update it in v2.

Thanks,
Zhe

