Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D2DC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13CE6B0088; Wed, 16 Sep 2026 17:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4EE6B0092; Wed, 16 Sep 2026 17:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CA26B0093; Wed, 16 Sep 2026 17:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 911256B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:34:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56E9D16017A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:34:30 +0000 (UTC)
X-FDA: 85220929500.20.D2DFBD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 667FD20007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:34:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YnViTkjq;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789594468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZHwbu018oziF0YzB8Dbq35UuDzuxoPLASxubSP1C4U=;
	b=NcKtG6WS6/mZa+HbnErYeAYtOP7o03TAD08cwHGDj3VYhegSoZnzLu5Lyq/a4NrjsoQR0I
	qoUAH4iYdVzaCoJXsvovNKjlDdr+5YkIX6/7qBGvWC6wXWDWXE/tKu2xwR1JoFL/XA4/Nk
	gNfNgM9a7mfYjlfZ7loRcsx8E5R6w+k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YnViTkjq;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789594468;
	b=0TTSh6sYiI6P5AYqis+t7yN8C7Rp4VjLASe8L3+FdlxKEd71JyTM+QJ2J5PLXC/gllakHu
	RQ3ozTQero2e+PHCcdhchMcstxSfVPhPznK8ID4b4DMf0BefrZ7I1SC/8KnoM0vtHGgnhd
	WSGqTWE41dHDI9s06M2jyXeZL126qMQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BB1E44043
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7691F0089B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789594467;
	bh=vZHwbu018oziF0YzB8Dbq35UuDzuxoPLASxubSP1C4U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YnViTkjqjY2tdIpaDUXdUNmiEKWVN7tDIwtoA47ULo6c1zBON5U9i9XryxY4Wk4TI
	 oPlXK13wF+5QrpWoGZVW3PU9C4j/4/dLl6HXJquqUklrLRpXvCsGTsO9hxTGeQpS86
	 oKKTlJ05ArKPO8r2to0x3Kmc2v7+XU+mB4Wy6LPmuM0Im1oCbxNjLI2MsOtS7kvFaD
	 cPBmsUk4rhAbukEK6Os8Lg0YeAINRFFYxi8BpUmPzGhMWSQ2mzdMM9yhWjV99+ACj6
	 /3a7P8VUrFymUFg2F+33txnN3e6YaVHvUJYfnMZZ1JWR3Cb4QEWVAQWvjfuNXF5Jpm
	 nZjZo4bf8CtcA==
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb769ca02so1049641cf.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:34:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzLi+q6OIjzKz5b5EauKkDUaoATtfcKnrXVicgovq+Hg5oTexCOWuPAQR69J7DBxQfN0BwSUO7seA==@kvack.org
X-Gm-Message-State: AFuF++nSyXSALdVhaakYssswaHpEb3j0ecn0UOzas1aCR5FsvpB8PXzE
	6u4HQiuSye+NSE3F2ZvhaVe7PGt18OdeJkW2UWTlefTBZHYDdg9NYxLKzaV6xz7uzRS0ckgzT/M
	VgcxGnhea1as0etBamw1L68MK//mHuJY=
X-Received: by 2002:a05:622a:1a94:b0:517:5b2c:6aae with SMTP id
 d75a77b69052e-5327edfb4c5mr88841271cf.13.1789594466802; Wed, 16 Sep 2026
 14:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260916123846.1242548-1-ridong.chen@linux.dev> <CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 17 Sep 2026 05:34:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zQcj-EdqK_j5uuMQxWZzac5a9akz+jmcJ8ewPRJH6MnQ@mail.gmail.com>
X-Gm-Features: AcwNN1UtLY7oHGpUa0GVuFEMOd8HB5GEXBkaH1H60YU1bEVxMibMdR9fZ4kb6WE
Message-ID: <CAGsJ_4zQcj-EdqK_j5uuMQxWZzac5a9akz+jmcJ8ewPRJH6MnQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v9] mm: vmscan: retry folios written back while
 isolated for traditional LRU
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: wgsg8ezsibjkgfbqzq8epqotyd53yckb
X-Rspamd-Queue-Id: 667FD20007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789594468-156180
X-HE-Meta: U2FsdGVkX18CIhXh9ZxO3+WK5yLs5Q1eCKPQ7f2WhAorlQYIydARnQoPlr39/Y2iDdfeoYhMCYdAN5nlyWb4M8SOfnBVU5Ge/lh9B2tKxQgjmNL9a0y2G30ELnRXaJwB0b4Gbpm77dygvV3JE20DR+RHNFPXpXKww2su+x4kU8NLMQvdRioF57wd1oh43OqRtHl8uYZzN1/DS3eULxHRFjcvFYiQWpVhQgUjGPn8B6W6w1zBAbju35l6nZSaJlb68Tqmb4x3VY4pn2GTt9W76MiWiSRIqdOK46jBjVTMEXyOGKa8LEoNxG9S+z4C3IoRkWY6kFtpwKRCcDJfPAE+Vq3642EOxf99Y8ZZMrEWZKFmAuVsyfNScgP655OQP/alcn9tGEImYMABhav4KUJ179qxRqlSgcr9fi5ZKy2hhh3pgPyySj4UTHnXqU4qFY+nqT0Ke02toCGK5Fh0uBvMT1uO1LouOOl6okxLBmDhuBlCM1qju+SlfPb6A2ohVi34DNh5RiaUg/9KuugHjDQIrq3H/raaejvdV5RbKAjaUXwvL0HsBNhROvhBqmJBTNBjlwUUtIW1uy5LGsmg8Rdo3dFtZ/WpG4/CjzH3R4r1QiOhn/vrRn/RkUAec8uifPAtBaAp8rrBJlt2brGiUSGfvbTe0F/9NhfX4fLst3IcTbfvQo4xNdKQmlESXB7DQyK4OLa/p9/3nv2iuzKWcbN5NuIoXE4dL1qzMYJa6KmfLurGMvgLub3A214s4ZJW0P4NsmRcuA7ur94nkfz6uNqPVH7OiPMnQbKYZ8J4rWpz80m5zNWgeRFItfIHLhzvrefmAAAq9XvUOpTwPT61joneaLUHTcy8dOUT1IqV4oSENTllfDq+7ZxSchoG9NaZbeyttNo298QQM+oGibrv+51OxtK03fTnTDPAbwON+dNgr99Hc72GQOxHxD0o8Gl6xuC46R0D38Gmnx9MVjwkhIL
 6m22o07D
 zKtPpzIqfYN0pv3ffnuIXYUcX6pwjxCLhUpr9z6IVNYQK0d0u+Ean1BSHhpo8iXGQ+8Xgm0GQX7wwom8gA3LUNIpZTjwUa5zPTpFFOMgW6eBLSPtZ9DK6HUFPMqlNRi1ASptITAG0eMOmeF6XEaHQzcpQZ8sWRJMaziwdDabiSgeCStgrSv9ahlDNB/YpOn3peS8nz9ZsshDL71X6qMn4SzdwVr6JvJ2sCO0KKdPZIA29hi9QbQe2K1cACEwLFi6A0YEtCk1HhU6gUC2E1rlIw+xanVw4wOfnF5NuHCQOf1b8w6KOpmCBKrLXmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 5:25=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
[...]
> I don't like the way you describe the problem as "wasted" swap.
>
> The real problem is that those folios skipped
> `folio_rotate_reclaimable()`, so they were added back to the head
> instead of the tail, where rotation could have moved them to the tail.
> This resulted in a cold/hot inversion.
>
> The swap entries they are using now will eventually be released when
> we scan those folios again and reach the head of the list, so this is
> not actually wasted swap space. You are probably right, on the other
> hand, that if those head folios hold swap entries and the swap is
> full, this could prevent the reclamation of folios at the tail, making
> it even harder for us to reach the head.
>
> >
> > This issue should be fixed in the same way as mglru. Therefore, the com=
mon
> > logic was extracted to the 'find_folios_written_back' function firstly,
> > which is then reused in the 'shrink_inactive_list' function. Finally,
> > retry reclaiming those folios that may have missed the rotation for
> > traditional LRU.
>
> I wouldn't necessarily call it a fix, as keeping the swap cache for
> those folios can sometimes help with future hits. For example, we may
> hit those folios again before they are reclaimed. So it's a
> double-edged sword.
>
> That said, the cold/hot inversion is a real problem that we should
> fix. Ideally, we should find a way to restore the missed
> `folio_rotate_reclaimable()` behavior, conceptually something like:

BTW, maybe we should have another patch to fix `MADV_PAGEOUT`.

Thinking about madv_pageout, we are supposed to reclaim those
folios. But because the swap device is fast, they miss
`folio_rotate_reclaimable()`. As a result, we not only fail to reclaim
the folios, but actually promote the very folios that we are supposed
to reclaim. This seems pretty problematic.

This is probably a common problem shared by both CLRU and MGLRU.

Best Regards
Barry

