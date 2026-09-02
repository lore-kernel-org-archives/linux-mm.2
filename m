Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA56C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 22:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214416B00CC; Wed,  2 Sep 2026 18:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5976B00CE; Wed,  2 Sep 2026 18:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3846B00CF; Wed,  2 Sep 2026 18:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4E826B00CC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:08:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79AF71C0FBA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:08:24 +0000 (UTC)
X-FDA: 85170211728.29.E414233
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7817F4000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:08:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuHhDc5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXwkquCI6LmZGWEehEfPtdKpLqHe4vbF/JANGMpvusI=;
	b=MWw1nBcmiPE/N6AhZJUqB4C38T7OGI/Q+8Lam5iYm3jKioL+FAsz2//lVNwpiVMKKdWCoh
	Pbh0deFkSZBT7ABJVZSAU4KQZAZuTCcmzz9PPTOLRqRME/5pjsmj8C4pmVC2Vxhg82jV+P
	QjUSkUKnYtOmXX43iHAcxC5R+r6JwMc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuHhDc5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788386902;
	b=qzLMByjONA6d7zP1QynR1Ap1vGLuLKWEBz1L3VN8sj+xecRSR/JAfzHqc8KePv2/3b5LeQ
	b9SKYvqkUJddnQ/kFhY85tFBuc4qSPlRf9rcoeYvZNn97zHifBne6hQWKKdm5nBSQFsscS
	dZCMM9hy9BaqSnSd3zGf5T9a/UaE2X8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97807440B7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E951F0155A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788386901;
	bh=HXwkquCI6LmZGWEehEfPtdKpLqHe4vbF/JANGMpvusI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fuHhDc5PRndfYJsjaoKrh8YW800YD8LXwVGaGjOJXcXGwNjSeoF9s4w0hwDqtCsm5
	 nzzZnan34vN4n5y2ECh93wTNq7TWWLslr/MtcZUQzJliTV+NfudrZc0/vaQqqaobpX
	 EuvpAT7B+IBHv+Af/963EbQqd5ZtRMBFhXL/Hx9DyGAn0cOl386ZU4koJjBi6QKEzH
	 0GWkkCZuICrlSjG3Jsm+jPMlRa1G+xOhviGR6qzNvUALo4uIUXZeevQlqPPI9iBYno
	 fyxPTEx/Z+V1IyjhyU6oLhRY2Lv0CbSSczmVVDjm8Uj/Fc2N6YhvvKfSSqdXd2tr2U
	 XsQ6duomzawlw==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-9392aa26b25so179050885a.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:08:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw05tVN08ZlnDtPogGFDMSBj2y3HBvvSskNvq9Ml1dXryQ9WuNWI+KEkEEfz8MN6XWsL4RET3996w==@kvack.org
X-Gm-Message-State: AFuF++m7viKVnuOe5oNMr+f7d0YH3TtRMl9GU/kjHraT8dO6VNa9q/5/
	0MALIf95MeqZsCywe4I6d7yVb2n+holLdvfyQHCcBhSqZ3jpKbgtALzfbwYSub9ZIuoQ2aDTYR8
	OMX18IzDMmE51MF7Fv1QR+GH82r3ocFM=
X-Received: by 2002:a05:620a:3196:b0:936:31c9:6c57 with SMTP id
 af79cd13be357-93960cd1611mr870285685a.7.1788386900768; Wed, 02 Sep 2026
 15:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260829074204.45304-1-baohua@kernel.org> <20260829074204.45304-3-baohua@kernel.org>
 <apfZQE1X6zGAsBb_@fedora> <CAGsJ_4z=A3EGajzL8F5H+0fwyzh3qqMNACEzo20J83m+T8bbZw@mail.gmail.com>
 <apf3ivSCu9kQfM9F@fedora>
In-Reply-To: <apf3ivSCu9kQfM9F@fedora>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 06:08:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zfDJ2+qG-NHQoSi=KOPdsfi3YHL63gZytDGUhW1HOpvQ@mail.gmail.com>
X-Gm-Features: AcwNN1XFDhZ-DAqDQEdt5t8zknTH46vTp3nSSajFNh_qOLjujxTdo9wNIES4DYc
Message-ID: <CAGsJ_4zfDJ2+qG-NHQoSi=KOPdsfi3YHL63gZytDGUhW1HOpvQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in isolate_folios()
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7817F4000D
X-Stat-Signature: ufb81ncoc7tf93gt9pdxgn1ggidi4awh
X-Rspam-User: 
X-HE-Tag: 1788386902-329045
X-HE-Meta: U2FsdGVkX1953/FJ6PyBgMOutlF98EoY6WO/IL/vLeoQGsxN3H9wG5zdxzKzPQwsCKpTfbM6gbhJdZVRzW41ZvDaTMlSxTinUYOfFR7/b7GEDgOPNPSg1MtW54O1cDiO4IgPSBktnbTOx9XZwuZIj+2OE9GWHcS6ch/JJt9906f3EoXuWF5dIfj1koUHoAvj78BjxjITURp3p8HxiU7U3kU+Bh4mzztYm2QNLIuBACVbDy1FLcFOhxuGwlIUxqDGii3RpNcY+RpY2pH0bOBxGeol2+whB056qqML+RoKYNWKcp5eslNkHNyCIuKhJr7sOcZQA/cql/M6/xVoA9bpuua7Jo9Oa4KPLtqY2OR+Pft6li6o/mtvIs0j+5k15PMjwUfpHkoK0splY4xYzbzTkq9gLhtWq8fhuHP6ZefCzEFqE+e3axiYo+qxuw8KNL9fVsvRru4qw+fUJZvvVu2Yxx1vPpj0tCOHNv4mGrf9/Tlszm3/Mew4cFvJWAe9KvN2WIcRvLa5F9KRuxLIt0pmUx0ULemPUG6LnwURwrhgtWQiySEw3Pfh9KGYEWJ1nUMItAghhHYcwDsYQXCUypfMze+v5+kg9VDggD/vJ8GHu6f2XGOt5fczdWTzsPPXBC1+JeomALJ1ZRGbSu6mLZLm0Y+8miKaDDIjXR5UvMWPNuCAy82wv8x7q4vLuMfKYwK/RV2Nmal1ckyAkijCNWOxtRt6kCwd95xaZXNq6hu9lLNGlxi/hKi6a1zIwanustZBAvgHJZbUPQHxyMLsrMr9YfkldsO7sBKglwvehtPWZ18NjO/ze1Wvzll0EmwM3qceg1Q93PASwNbIUmbq3D/RkeR/2rsXSThhKEEoWg7bNcAmnchd5917rXI62Q9UBjoP2DJRZv8nWv1mqAjS9wEVjCLpRsoJ8rvhYw02CLyn0u+vEWCz2bR1cG/pYBdJ0MqpIw8U8G9fWkgdBxFLExj
 VPGaPqV9
 7Jo7rzk4IVVn4NeuGl8Wgf1Q9PlfEd/DxBTbfkop50VE3YRHPlybL7fUfDWFL6XYy7LzJZR2gxJXsZSV/AhcIwR9C841PDlTV350/KGPqlC/n7C9xejVfJLbtOCz+O4iuDmcM9hWJOsWWJT9DYP/2eFTZ09P1lwhezIHGoTBzEDxC6gbSNL7roBkr88ppmQrUW40xRgVyrPGytkZL7yCGunmVBfG47sYDvexoMgQEI9BrPufMz/ZibBtvF7wTk1QytzI5LkTNWy1wjBkry2bGzjRV0VxgJEBcRl2GwlJ9doBD4iieUAXWaLVYoriRLWo4/LuPikiRGL7cuvr7/uE81OYOzTnRkimAzSu6H907Ln8SZkFZsRr3ULyuccJcUd7VFFP6i4npvVS1OjvDXiZdQ9B+1ibxQujTIuXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 6:17=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> On 09/02/26 at 05:20pm, Barry Song wrote:
> > On Wed, Sep 2, 2026 at 4:07=E2=80=AFPM Baoquan He <baoquan.he@linux.dev=
> wrote:
> > >
[...]
>
> Hi Barry,
>
> Agreed on the one-line change for the (1, 200) case - I traced it and it
> now matches mainline exactly (no extra third scan). I personally prefer
> the for (attempt =3D 0... ) style because I feel that makes logic clearer=
,
> while everybody truly has different code taste, LOL, just a weak opinion.
>
> For 0/201: my concern is that on no-swap systems (swappiness 0 is
> file-only), the same-type retry when the first scan is busy may be a
> no-gain run if the file generation is dominated by protected/ineligible
> folios - the retry re-scans the same sort results. But if you see a case
> where the retry does isolate folios on the second pass for single-type
> reclaim, keeping it for consistency is defensible. Do you have such a
> case, or should we drop the retry for 0/201?
>

201 only applies to proactive reclamation. I believe the retry helps
avoid having an outer loop. For 0, I ran a kernel build test on x86
with swap disabled:

# free
               total        used        free      shared  buff/cache   avai=
lable
Mem:        23991248     1315020    20554564      331312     2121664    220=
99256
Swap:              0           0           0

#  time systemd-run --scope --unit=3Dkernel-build -p MemoryMax=3D1500M
make ARCH=3Darm64 \
        CROSS_COMPILE=3Daarch64-linux-gnu- vmlinux -j20 1>/dev/null 2>/dev/=
null

With the following patch for counting:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf2786c7247d..e8d5603cd56e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4913,6 +4913,28 @@ static inline bool is_single_type_reclaim(int swappi=
ness)
               swappiness =3D=3D SWAPPINESS_ANON_ONLY;
 }

+#include <linux/proc_fs.h>
+
+static atomic64_t tried_isolated;
+static atomic64_t tried_not_isolated;
+static int reclaim_stats_show(struct seq_file *m, void *v)
+{
+       seq_printf(m, "tried_isolated: %lld\n",
+                  atomic64_read(&tried_isolated));
+       seq_printf(m, "tried_not_isolated: %lld\n",
+                  atomic64_read(&tried_not_isolated));
+
+       return 0;
+}
+       return 0;
+}
+static int __init reclaim_stats_init(void)
+{
+       proc_create_single("reclaim_stats", 0444, NULL,
+                          reclaim_stats_show);
+
+       return 0;
+}
+fs_initcall(reclaim_stats_init);
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
                          struct scan_control *sc, int swappiness,
                          struct list_head *list, int *isolated,
@@ -4928,6 +4950,13 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
        scanned =3D scan_folios(nr_to_scan, lruvec, sc,
                              type, tier, list, isolated);

+       if (tried) {
+               if (*isolated)
+                       atomic64_inc(&tried_isolated);
+               else
+                       atomic64_inc(&tried_not_isolated);
+       }
+
        total_scanned +=3D scanned;
        if (*isolated) {
                *isolate_type =3D type;

I got:

# cat /proc/reclaim_stats
tried_isolated: 12096
tried_not_isolated: 23061

So we see some cases where the retry gets isolated folios, while in
others we still encounter promoted or protected folios. But my gut
feeling is that even if we don't retry and instead go back to the outer
loop for another iteration, we'll still encounter those folios, since
they are still on the LRU. We would just reach those folios in a more
costly way.

Thanks
Barry

