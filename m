Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A62606AB85
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yGj5CUhI
Received: by kanga.kvack.org (Postfix)
	id 446686B00EF; Mon,  2 Nov 2026 11:20:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7B66B05B2; Mon,  2 Nov 2026 11:20:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9126B05BF; Mon,  2 Nov 2026 11:20:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E79A46B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:20:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 656D9A6E45
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:20:20 +0000 (UTC)
X-FDA: 85390691400.07.4D897CD
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 74E3740002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:20:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yGj5CUhI;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793636418;
	b=DAjILDOVvlVxIKqnJO1EQqrZoxL4bvbZ7nmdIrKBNskn8U0CSTM5fn4KXuh3WvH3UGK3nP
	+ksmpFIWjucOQEIGmoj7sXdV8NBEabNHtooo7MIkjHIt/3AO/8TNR7KIch6oIyFf+FmN02
	U6vR+5NxxxMnFaPuZZifcLVwhKu74Zk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yGj5CUhI;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793636418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnY7OohDI6Xd9ZoeABmlC8B9GNptg8MziyLV8aKueh0=;
	b=j2+YY8VMwwjqkrl7Xhawk/GX7dKweSm2i3KGaZM+h2GHVFQIj1X+uuwi9iVHkwnjp/Tpo8
	R7mdx/jQIjodI+7i75DW22qcYOy/t6hBSKpqb00WT6MsI/MMUOtcoWz4+BWmPA7KfTC9jC
	/JQWiq1qBJTGowJ4llML+eo6kLgD1E8=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c468bd799ecso397111966b.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 08:20:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793636417; cv=none;
        d=google.com; s=arc-20260327;
        b=czbH9O0cFqLEQCmqtdpYO40s++gF1mmPdmsRyoFzID9S1Uy2XvD2sgDrLsdpsVbmEo
         KmD0j+5URnWG7zM5WFsNhbJQDONprazTt9Q/9ZdzNrRM6A7uzlhFb7Z5TiJQXFNRUozt
         w8S0r+0mIjtdkYZmeW4sxVIDUBKtxmzV36Ke6wBbMMaUxfpD8Me/MqQpqEHyZg+WFw4B
         ZMf1vEYsxzE5pGSMMRtfvG4nqUKwMmAdsD32fqYuObtJGYUFHhWtBV+TXIRqlKPCCTZu
         QK+fN1XRrnSGD9Z3DNAwnqgOhs+wkl538t5dxKHKOQYpcBGOgKaBJ4SWacG7uhNC+uuK
         XeHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QnY7OohDI6Xd9ZoeABmlC8B9GNptg8MziyLV8aKueh0=;
        fh=P6dvm5BAZ9cAL0VqGwwIyGmq0y9skCSnHY+7hxG8+dQ=;
        b=d/EpeYV8Bi8mp1N4kZ0h54vo5jE26dMdNzEb5KxsXp7qv1/qRZSQwsHiwWOS4J7XXC
         5HIcHhtvh9zCgzb1YpFJmseiOQvmkDqkxItRZ7R3tOdrBB+5zsNlnanUQnKQ2ISdhN5O
         tAG+v2oAwyn+aZwgDnxGAdyV4c00xBd+Rll7yomNF0kutsqjva8YMvi4McT54HsXDrpV
         SFv+IpJ5iEmFxWRyMECMtAD3iTkpeWSqVBHa5lKUoTmfS6cLJwD0SSp9huA1vZeK39/a
         GB1JxBEBp0ZrWyXJRWbkQYDl1Cw8K9ohjSss7Jc16LWqYcNOECpap5PMhNcymQAXvl4w
         9toQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793636417; x=1794241217; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QnY7OohDI6Xd9ZoeABmlC8B9GNptg8MziyLV8aKueh0=;
        b=yGj5CUhIzf12X0eu8dvPe/NoPreW/kPErTafzqV7KoPxpErTg9jSG1cYktSGazyp5l
         diIns9esJNgkkAf/qkGYnfSnFTALK4G2B4ZLALjfDL8CU25YFS0ZtMnby6V4P+zwqiqN
         ZqEMt5i4u7yxDmf0t7VraTgJu+nGJ01BcGoQTI2rL/hAwsxuH29aY9aLMTNRtLy/PiKT
         V2yXg9L6vHPrGljeMoiQZMR1WRpuvPMp5uyE8zMWRpGnTAV5dxNda/4c7NYRc3X/5r7U
         DOfr+DedS0cMr7Lo6h74DrtQz/HTF+KXexNwLkJrz6dv/VcnyADNP9WPZOi4cMdnLbON
         rQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793636417; x=1794241217;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QnY7OohDI6Xd9ZoeABmlC8B9GNptg8MziyLV8aKueh0=;
        b=LRWGiQZqkTXgSBC3U/Qxi28x0tHvRTiTpX4PdzaOiDOxCpC0N4bNA8rMiwiSnciO6Z
         skc9X9KfihTPBYtqw/HwG3lf803IpS43ldiHqMtWEXaSN1pmuhtMi0UI8LBlxY1BRZTA
         HLslrEbZnjYcnID/36FzrRIs3i5B2SKo9KE9uOcQCCJtSl8RNHUaFTSu2aTFD4IyzzXz
         keCI5dn4dcBpKZ6RvLYXnO8k/I8DpbearYLfiZ5OEv6DGjDgcBEF2TjBNS8UmsJTRu1j
         vzwWvPRq0VZQ2MnaZexrW1HRWYrBqam79sUqBziFbNxr+WihJXMtFRt8O4u9GS1GfbZa
         GoUw==
X-Forwarded-Encrypted: i=1; AKwUvBwxGxaUGv99h+kROA3dOk1DfjvQUZ5bKL4kjLHAVc2HW+qIcEiNlMeaRmG1YZDiVg5zutIIXr2msQ==@kvack.org
X-Gm-Message-State: APuU4Z9MiSnzBK/Ow32VMwUA9JHFPHwHGp+HnVVPuAjom705Bodj5T13
	q7JYNII1UGiQdlRaHV/zf+thuaSRG6iAwnEhBOrl1hJhp+OcfALpMohrsgMnTJ9HwLbfppCBoLV
	FinaDC+Ao2rU32n9C4VsgVGR483w6kiw=
X-Gm-Gg: AYBFou0fqDG0UEW+Zfripjt/MG4DqnVYjHS+xNuMOWUBtWsyAkWIcgeP7ijAmRUqkWf
	JhwxWW1r9gDz6OdiB88EoCNLcqepqnJDud48pXZioVW1gsMFYC/adYNeY4K/khXCLElp5rGSdCW
	KR8baiPxiYiFMsuowoXZ5te7dzpAp5ADq7zTt44lr8HBOzsfpRUMpuCZ5qJXQIQWXWcmtMGt7uw
	VeSz6FjRvjn6KYDGp3flwFsSFr+fRfww2MJNvRMSY0S4vqO+cs2xYS3zs+e8kMhmroOWxI3feCF
	MBiPZaQo4REGKkDQgzRlEB5DFs5vFSyzTTZuoc+RR91KCUmcmQ++bU+qkHTALdWsOaymjYYW+CF
	EFcuGvDPOTjyZBWAgOJ1fyuYDp88K3rS3wdHZ9wDxpvPqoRT3InN8PDzoQHX4PEj/b3WVjw==
X-Received: by 2002:a17:907:1611:b0:c46:8c2b:8f7e with SMTP id
 a640c23a62f3a-c4ca73f3c48mr811452966b.0.1793636416788; Mon, 02 Nov 2026
 08:20:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
 <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com>
 <CAMgjq7BjOeboPMP64PfGDoY4yMGq0xR4E4Wa66U0+gsd2tnu+g@mail.gmail.com> <CAEmasaV0D3ezZyWf0k_84qXOa1c5KyUjvX9Jez+RXMDPM7FdBQ@mail.gmail.com>
In-Reply-To: <CAEmasaV0D3ezZyWf0k_84qXOa1c5KyUjvX9Jez+RXMDPM7FdBQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 3 Nov 2026 00:19:39 +0800
X-Gm-Features: AclHuK9HyATHKuvexqnNhF4HVqiEeBaBb9rsGxy0GEXJeq9AC8rntCtucEkHl44
Message-ID: <CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 74E3740002
X-Stat-Signature: n6xafa1ig45rsx1k1i1cd6e5gn96i6nj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793636418-509430
X-HE-Meta: U2FsdGVkX1/1rmo1k73YKzHpNFqahnkRS2d+WCXmXV6Xx0Nb2CfCXJoGjsfCMGSDpTScQ/fy3Jn2rq1I6yBLhaJCzuWWEGAmeFq0244M9lIQyCntz/j4DjWHGV2dGMB06lN916wp89ySxnjuhm6RGtkmcixlydnbXejNXo/pt6PPCtBacPMz6yHiKv8CoRCHGwAcEYc33IoVh/3PqMDZDoXMV9dm1bKzEX/fUZDj6u36KJd4ouaTPAzzZ8iP9DVi40kKfn3OCWl6fQ98CRLVz+YA6p318RFmbW4AadwLG0L5lUfBtHpAg/S/dra46h/D20EA/XxzHxntdtHR6UhjqxZiv4XoIYzTYJjyMwxuHOV7O5bKFuQrlDFxMqcexqqPS9GgjBaExyYVXqAxXDAYcAx+l4A0TulOM3U9SsXfuS4YLNoMto+J4zWQ4ueLOnE5yGxztwQ8jMtI7vy/ff9q3PJlZeaGD/z7D7zR0nDAx16wviJXHQNb7ywRNnQW+C6sqCZT19DNED5GL6aibCQsekYp+WUY5704wLwl1jsV0Zm4va8/VJo4NvwlbDn40Ykmtr31vG4HF6lqJQlbhUOs5TzRC/JRtFCR5yEBGDY2f2e0HcGm2OYHLL9s3e9TElw6uwL6hnND+xgMG3yLZd04no9Vk8x0xS/gv3daNzQWBvtQkzldEcq8omj86/EIb20O4Z1d0VVnWyDOtA666Tod/6j1My6iqlrYMKCUB7LqlUUuh1JbNaKosRlR5G1qg3gU8g4l5HaQCr1pjuun8siJAtxPaDEe66uH34FB9xxyoji0y40TlPraI1B2K2okD4GuALsmaT0cQtZogC2nYSk2CsvA7P4g2pqMoHc26qMf7lghJ+e8IWZZdFBqrv5Soh+Gntw/hpShp0V62QwfZG7wuriZfYGlZ/5kF0gdg8meC/X85/P6dz/oa0XbdbvHvnRIrr6RL26VIZYjKAiE/Cm
 n3J3UmcF
 vSEfQ+/y70tNmYMurli8RkpZHxDL5r85yqoti46aERXPCB1eCxRbXl9O/Tnjm0AY65ALH9MMUKHFZroNCIBOa6oq1Hu31+eBA2fIry0wdgG1fO1TzFaMOttrdcaqcqt6WWsieqeJhFYv3ordgM0P24QP+m+3b18NiXu/utv7Cwl/weJ+f1nCahK3i5hd6Pvi9bAphUGJarNWcNii8bJpPQfNIS5nv0xsPky8Fn+bavT4fugWZ6XBJ+hv4lFGr9JUnVt97j4QZUSYMfM4fXgZB7yHgxnmvKRy/1XDlY17Wt8KvdjXoAInsb7DRLQIW0d62rRDLOcb4utjUiP/648zOE0Z+I7LxbyrO02SjXUGlZR6cuRy94MQKvwrgt9rHOpk3hJTl2lKZKQ7ec7cdB/zD8QWmk+0NY7HYtHgH9gCD9S6RMJCN0w2rDWqexauAg1WOQZJMPMSFJ3x5iXCp+DJBDpwUOaHwaPlkoTsRU6DWfzM0f0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 5:42=E2=80=AFPM Alexandre Ghiti <alexghiti@meta.com>=
 wrote:
>
> Hi Kairui,
>
> Back from holidays, sorry for the late answer.

Hello, hope you had a great holiday :D

> On Mon, Oct 26, 2026 at 2:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > >
> > On Fri, Oct 23, 2026 at 12:17=E2=80=AFAM Alexandre Ghiti <alexghiti@met=
a.com> wrote:
> > >
> > > Hi Kairui,
> > >
> > > On Thu, Oct 22, 2026 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com=
> wrote:
> > > > Perhaps we should instead always scan the full clusters and revert
> > > > that one commit? That commit was only following the idea of keeping
> > > > the allocation more compacted for that series, it looked good at th=
at
> > > > time. Since fragmentation issues can be solved in other ways,
> > > > contiguity seems to matter more for large physical swap devices.
> > > >
> > > Oh, okay. I thought reverting it wasn't an option given the good
> > > numbers the patch provides.
> >
> > That patch is 1/3 of a series, that series yields really nice
> > results, but that one patch plays only a small part in them. Or
> > perhaps we can limit that to SYNC devices?
>
> I'm a bit scared it would not help zswap with writeback on, unless you
> mean actual SWP_SYNCHRONOUS_IO devices?

I mean maybe we can just scan nonfull first for SWP_SYNCHRONOUS_IO
devices? These devices are less sensitive to discretely distributed
I/O. For other devices we then prefer to keep the IO pattern
continuous by using free clusters first.

That may just fix the issue you are facing?

Or maybe some threshold or quick scan in partial_free_cluster before
putting the cluster back to nonfull.?

