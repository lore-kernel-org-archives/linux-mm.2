Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE37606EE99
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClskhasM
Received: by kanga.kvack.org (Postfix)
	id DA8A66B05C2; Mon,  9 Nov 2026 04:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5AE66B05C3; Mon,  9 Nov 2026 04:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C5A6B05C4; Mon,  9 Nov 2026 04:52:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5FD6B05C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:52:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F96D1A0636
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:52:02 +0000 (UTC)
X-FDA: 85415114484.06.B19BEB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EBDAA0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:52:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClskhasM;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794217920;
	b=22zcJBes3cBVO1BW0ETlFZqgxBaMyVTEoNUkq3RKryXRueaAhzxkixa5PnhUwMk4uosITn
	1vIsxb+7duLtJFeFYTF8XVHEFK5suv7dRoleIIX8v10nPXiVeyQi8pB3Rn5G2tj33NS6AB
	4BttnRz4sBmel5z/Wiu4fBIkCTAJ0XU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClskhasM;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794217920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPClaJ9k3pZ7M2HgIHwRGL9GY0oByLTbIb+UN2JvJdI=;
	b=MUZPYNJJTlLBWo255dVvRxxwmt/JmnrwNbKTvY4jx5cC5Ni48rcIG+Rlu7ST/IyYiiXhSy
	COsH9nBWNSLGBZiT/SeS6ITNCPOSCzJ8LTAUs7yUn6g7VISKurOJw3bCfBgvpff62hpL4k
	tXmKfRlikh6JT8j3Bks/vdBk9wd9iho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D152963062
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7077B1F00930
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217919;
	bh=BPClaJ9k3pZ7M2HgIHwRGL9GY0oByLTbIb+UN2JvJdI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ClskhasMy/BO/ZFdZwG+TW51LQNe0aK6dpQ2tXf3zXQZrXEHcm8neQwkSGJQK5bn8
	 LSLm+/HBxMHZMxvoJu/FfopjGzpVjathiWg6LhLTjtHomqOV6NScv+voJMgOraZPB+
	 /ycD4F1aoK068VBjmEHIzTpz6UCYVE334qo4AAnvYskYS657GvVKuV95oqJnh/isCp
	 Ew07MQtp8jOpq34koBR4cll0v4jnwrIVmL3RYMomGUCU4+PMwbvb/yi5tiY3SPEdBZ
	 YFw2QOk4Ib9EJpoMe7VKixgAJAlLv7+MJTeey2wVMPTTTLYNNHu/Q6loLUjbENBCIP
	 uVqmfBr+FuxdQ==
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eab93a9862so104155e0c.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:51:59 -0800 (PST)
X-Gm-Message-State: APuU4Z8mm3e8ev4Fx9F6BVphfpZnIkYEMQ5/YFGaV99637v2MSIIUWdz
	mcsSoyD1AQSCw2SWkGWqP5LHtyT03zoRnNItX3UCI1IF36/sKRTnwTkKkDtYHTnpqaYegU3v4c8
	XDEEo5ZRnRbVgJVbMFHVidns8kYX0hGg=
X-Received: by 2002:a05:6122:a012:b0:5ea:c9ab:bd86 with SMTP id
 71dfb90a1353d-5edf9435d18mr565522e0c.21.1794217918356; Mon, 09 Nov 2026
 01:51:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com> <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
 <CAMgjq7DeC23zak6Xur=E29qo7JPNvQUMtbbO34Y62jrQjQgStA@mail.gmail.com>
In-Reply-To: <CAMgjq7DeC23zak6Xur=E29qo7JPNvQUMtbbO34Y62jrQjQgStA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 17:51:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w275Z8ruQHNMFd9uL+wJgAusU2+QN-cwS5mZcBrg9fRA@mail.gmail.com>
X-Gm-Features: AclHuK-xWTO8SHWDNdqRk7rNXhHpJft0o90jKbimD22mK-2buKuHz7N9dEvOsNg
Message-ID: <CAGsJ_4w275Z8ruQHNMFd9uL+wJgAusU2+QN-cwS5mZcBrg9fRA@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b7rktastendgtuydpdeb6poy74acudgu
X-Rspamd-Queue-Id: 4EBDAA0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794217920-588986
X-HE-Meta: U2FsdGVkX19dAHZ65oqfaz6dXqZpA9TitqgklhLTvuvby5o4+BZp5E8qRYqx9HBj4qe4tAeg5LnarvDHO6n6dJHmrx3+4Zi49w+1mD7hNVQElowwqvlV7fis0Acd7jPvsidgx5PT52MhwFmwRgd2Fpqx5DW7ff6io1j31s0unK6lXaQshHRtMWm0q7KTtxChL1TB3NZ94eq7g2Frs+v2wmlJBVlM7hIwCblXwV4yTY5EMOuT2zgKHZyGFMY0STzO5m+737eI6k0FAWBnN0x916FFkfiR/QLhCcJ5v6NQiwuW21TyMOEC9PTWW9EK88mt70CjaPR15zJjayX8mcD0KKUMc6WJG1OgHPcwW/DK5Qd4n1/0CqMjrF27n0wsiTvW6XuocQ6Hfq8VKs0Dw0MQ6GpzDkCohq3N8vNAhNidlU4GCnb+eNqiwzKe9k9wfTfkQzwbrcCO3xJC2Upi9ZtpskV5XaNHQ7pSf8jg0Bhqw8Dyrb1KdX9ghTazQa/he3ulGSURZIjhqcG8aZq1B7X8dmS+vJswygN5GijclJ4Jv7ZC/YcJ/41TlseDNwcQ2PqwDJ1LNF9EaVgd4wL/XI3RHR79eWaS1bCdL9i/a0Zvocysnbv06ijsSRzXQt6ou23DkAQWVh/pG5zWZ42m2fIA9nf692wV0xGiOZCtHuWqmLu1tOUeKz1XwuCUdrRDn7L6K9d8SvctkF+C7jcBZwLJGHhhMPeOskU6Z7QywnXcd1tQUxDnXpyQY9zHXJR2Rz6TpwBVC4vZjVR2OBcREOLBi6sZdnut3xVbEPFrtt4+AKLkQcDnNXQvE94u+Xvtxmf0f9rM+YN8v9rCmjMG/BZAX3Ll0uR/IXnL9fvDLooFNaZKgWYnX7aCOZgM7tIfHQ7o+U/4+grNn33qMCPWc7J4Z/0Jwy+jABFU532V/2Jacep/NBZDL7w7KTH+t1ba44RZRHeYOTbCodjViFE+eGJ
 L72uqxyV
 O3Q/eLZpBbzrWHDwsbby0t+C9RzW8jBhdLBsQMgUEKbLp2ki1K1RcmJRbxm4lCwKSX4kBHQ2JqAYUfkpLl87U6HBxKqqa+TLrh2+c62kgL5GWLkboltaiwjadA0K16GXyfBbNiQcWGWjKLAJScijv7Wrj2ydgaY0eej4zI41ruQTUi46Bkgm0SGpgItY0ak0+OD3ZFF+q6kQsgtV0BKZtfVFEdaE78txB2VxkGGbk5rRP1x89kmNduCHpN0CrntRWXQxSnPeYMKNJjOmM3x9aKd6rp52rKUOEpU2U/hz2vnqPJdHCh7JD6kZ2aNASxrtvc+d3moWuvvS3hXLrgnBRXAHCuLNge+LPVkE6ocONsz/WRgFs4YU2YF9cFZe+TheWSKHPaR/lsBu24HFmNXq8be2SGj8+PCFUVup/u3IrDi6/F1wZAbspEfIf6JYF/obfDDe0EWNmweh5LQfzB55uoOL+kL60Oaf4gc4PEhmiUYXT9eFTv7Eks67WJ0YiCSkhyXkKjd0H1KVMi3cmGud97Z7Wpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:34=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Mon, Nov 9, 2026 at 4:48=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
> >
> > On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Pure code shuffle, no behavior change.  lru_gen_update_size() now onl=
y
> > > updates the per-generation counters plus the promotion move; the
> > > addition and deletion active/inactive accounting move to
> > > lru_gen_add_folio() and lru_gen_del_folio(), which know the generatio=
n
> > > and can apply the active-window test directly.
> > >
> > > The unevictable case is untouched: unevictable folios never enter
> > > lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
> > > before.
> > >
> > > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> >
> > The patch looks good to me.
> >
> > Meanwhile, I've been struggling with the names of
> > __update_lru_size() and lru_gen_update_size() for a long
> > time.
> >
> > Given that lru_gen_update_size() now only updates
> > nr_pages:
> > static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> >                 struct folio *folio, int old_gen, int new_gen)
> > {
> >        ...
> >
> >         if (old_gen >=3D 0)
> >                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type]=
[zone]);
> >         if (new_gen >=3D 0)
> >                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type]=
[zone]);
> > }
> >
> > while __update_lru_size() only handles
> > active/inactive accounting, could we rename them to make
> > their roles clearer? For example:
> >
> > lru_gen_update_nr_pages()
> > lru_gen_update_active_inactive_size()
>
> Hmm but __update_lru_size is also used by CLRU, so it's not a
> "lru_gen" specific helper. If we can merge CLRU/MGLRU, then maybe we
> can rename them?

I did a quick search in mm/vmscan.c and found that
everything is MGLRU. But you're right, I missed
update_lru_size(), which is part of CLRU.

   1     62  include/linux/mm_inline.h <<update_lru_size>>
             __update_lru_size(lruvec, lru, zid, nr_pages);
   2    279  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru, zone, delta);
   3    287  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru, zone, -delta);
   4    293  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru, zone, -delta);
   5    294  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, delta);
   6   3355  mm/vmscan.c <<reset_batch_size>>
             __update_lru_size(lruvec, lru, zone, delta);
   7   4101  mm/vmscan.c <<inc_max_seq>>
             __update_lru_size(lruvec, lru, zone, delta);
   8   4102  mm/vmscan.c <<inc_max_seq>>
             __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, -delta);
   9   4632  mm/vmscan.c <<__lru_gen_reparent_memcg>>
             __update_lru_size(child_lruvec, lru + child_lru_active,
zone, -nr_pages);
  10   4633  mm/vmscan.c <<__lru_gen_reparent_memcg>>
             __update_lru_size(parent_lruvec, lru + parent_lru_active,
zone, nr_pages);

Thanks,
Barry

