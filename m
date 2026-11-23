Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FA8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhAuS/1v
Received: by kanga.kvack.org (Postfix)
	id A60F26B05B0; Mon, 23 Nov 2026 08:27:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38926B05B1; Mon, 23 Nov 2026 08:27:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975796B05B8; Mon, 23 Nov 2026 08:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4F96B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:27:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19B72A08F3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:27:24 +0000 (UTC)
X-FDA: 85466460408.08.DF197FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 370E7140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:27:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VhAuS/1v";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795440442;
	b=w/XdpIUMKZua5F21GkxH8R4ysy8hnepcTY1trqJBeG+vUFQgT2Ue0+PHujCh2kxJVtct6V
	oLZG7+zQwgqwKx+jlJxaYbqwBqc/3aUTzNRqA+WkpsKYs+zLBUhIhUvonpMMi+tb0nNky8
	bdwpsktvzxeMq6Oty3AmkXvgXDEAQO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795440442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJWW3lAYD4SS32dHbc78BmhWsFKqKKOPG4WVSgqL+ZE=;
	b=Xmh/FuHecErRrhQ03xLWgRxJA9aTaYWAfcSwRZpQbxqjKijgqc+pFm3CXXpxxA/z1CGkyc
	1B8oWtJJdsX/54dHRUNFQjTHgXa1CracKEurg/FJG2tjfyjVl2TiBOfPvd4cd/B7MrwdJm
	nk684rMG/ITA3X2GiNir//2eHerAz/w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VhAuS/1v";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22830442A2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB69F1F000CA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795440440;
	bh=HJWW3lAYD4SS32dHbc78BmhWsFKqKKOPG4WVSgqL+ZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VhAuS/1vfW959+qJtrgNkgsp9BQcjJ89ZYVRqF9lApBNYmRhuL1jCe/hQIJS5a0A9
	 GUvRbCFV5jCYPWhITNYsRb0hDaVRh2HI/zspmCyG0VPj7XNguNNlfJTvH0XzOH7UEG
	 BF82WauajIjmSlowZTIpfzv/tq1fCIdVNMavzRR7Yvsnku/5pj1grRKShsY944tZqX
	 nzLvcA2wtkrxzNc5BhUyE4BaWOHGybHQdoD9QO0gC4PuWkFoAHBhXxhuKwd9c9BKwh
	 Xfx0AA9pcn0cvfhU1SEo5z4KHHNUEa6S0eR3NGJPLo8oTih+RDbYCUqVMIl7LRNU1x
	 i4C6uVAqqWqWA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-94961bfe1a0so220517885a.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:27:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHVmZ+x2u4hAkjuz5u6GuNh3jyS5OkzonR+r+0tNv3pd9enpqzqlxshm7gh/HbP5cO3Q3yQrH3glg==@kvack.org
X-Gm-Message-State: APuU4Z+Pi2YunfdxlGVe8TCwbpDNrRjUOsI6Nf3+O+K4xVs+Rsw6DdYB
	eRoHE0J/gVNrr393lbKxSQ/Pm3ENGjCsKUW2Gb9OYWhGNZMCp8IhQgBndTObw0GSUVWy8RtTgq3
	hfmx4ngyZBquiNKVvYXDE9BfXS3BBNyk=
X-Received: by 2002:a05:620a:31aa:b0:949:3066:5551 with SMTP id
 af79cd13be357-949bac80948mr1952036985a.79.1795440439933; Mon, 23 Nov 2026
 05:27:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-5-max.kellermann@ionos.com> <CAGsJ_4w3cP+tgCGhTFu5p27Wi-9AFCneQgwLUAUg7X-gvX=e4Q@mail.gmail.com>
 <CAKPOu+-Pzp-ovWNq394yBD0Qa5zCLZjx=sE3ixLs+WLf4EgZBw@mail.gmail.com>
In-Reply-To: <CAKPOu+-Pzp-ovWNq394yBD0Qa5zCLZjx=sE3ixLs+WLf4EgZBw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 23 Nov 2026 21:27:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yV=RvOMqpmaxFJGeBorPm-mz1VGoTb7_dLs-4pvrD56A@mail.gmail.com>
X-Gm-Features: Aa3M54pg3_5VxI8d6rS-DICxqkbqp2A05_T4kaagAVAVzN0pAmcXIWNuJR8gCys
Message-ID: <CAGsJ_4yV=RvOMqpmaxFJGeBorPm-mz1VGoTb7_dLs-4pvrD56A@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ar11fo4pkdaxsnsqktsp8nf9x7xx5pjp
X-Rspamd-Queue-Id: 370E7140003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795440442-517626
X-HE-Meta: U2FsdGVkX1+TgtVjCE+qUf+XfPdDhAAJM4bPZJzmlXuH+X4p7G/tbYTOJ3LlhLTWH8Ixq7QiFKe2iV4HMN8BFv2xOXVQmAdBMEeaKmNscfXAoWljr01fUQBJ6j4M6U0L+X7WEUhqTZPe1c0ojj2bWfiIXl3vIJqYEF/W9G0zhIrn9f/gZw8IJHFXWW2UlfRmpTXKzlDspY8BOPb7eOHKuM2WvFOYS+ZScuarwTSvC2g3agB85CuXF76E/tfo83/aW3mDqCF4nkLva1SX/XQVQc68JhR9XOUgr4A7yaBTISGitvod6aeLgBlB2PaG6Uc+WMEZodGyaUKNNpD4dI0HGWD90iHIcPKwq8BvyM3eFzzo223daoLGHDOvzw19aSLapvd6TVV3mrIsPm9mL5JymsLkL1mQcwuuJgawXVLzi6pI5ALDpAje7NdBUl+2tXJr+xgf4RjS2PzuIoz9OA1jhzsSpZkkxhtXZNM/eVsYgo/TjLXN9/1KvyPS4jjuPIf7Bz8kgUvVmmJytJTHTNSLhzHdlwa+AE0EkDNRCbComxkYYL6D6hhr2hDCbL/Cb+hn0jEE6rvpmn3AZQtVH/CvKCK5LtvUt+9IX48aADfQrA+lxJuprKgJba/RJxVSqiwEAUYBpMFOl5/9VgtUr/o1+X44+6SKNh3O3g9niZ01zwp2xjVUrXXQZa81DA4ebDGm3OBlxi+2jPkrDZAbC0L/I0G99lwUxAb7KDCFUKI+Ev1C+FCbnis9UjHDSKde5ip4fr/9sX/PzFG4t8TlezcgBYlW6rIMknPLXxh7C9H+aQtaqRtg0a25RGbZHWrfcqabJS5+96uzFWgmymr9IXsmvWA2TuMKRLe1GBlTgFp3ZGWHkXd4XCP1XErunOfATwFn9awcXMv+gk1Cv4oEIaGlcEshoMicg1qWmgDafpvRsQq22XCkCfB1JKBiJXWNojtZWziarInHt49r3t1+KVZ
 RtcdsIwk
 QgGhbECFCcYgNea+lbWRvoSU45FmMJTeotvZvj9CKUR57or8AAXOEPjJUv5KKs+fAp3LZ7rsIn97lG9ZZI1vpzLk77KXrUiadm3Fcdr7nPFG1VBFvfusWZvHAwMZTH3n3ughEhVxrbljM4Gzm2n+s36edbdO+mxhIVtr4kXZnopoFurnwZaxHFRMTOqEiPn1ThrMcLT1NIESZ9xEW3YlVyNjHHdYhSstlcqKuCae1rMh/OfX7ZjBSx5Fco/8IyBxXAfqxS+MvBAjitzDsmJYT/EJa4Q32cgk4LrqWD4Q9sLMKYFqPqp+2D7zaN+m9WiXuuflzQMl5//rK1VpAa0ep1E+3QL12/bq8NOO3XcN8vU2Utz+TcJPb4s6RyVA670f75aOaX+IGlqwKmRInWI9xUTNDp+cHF1awlvd0bL/HHK3mcv05dl1k3yZFwM5MqSHcOqfnZHJzu47p/AWANsLMMWQqlV+MOblNrIaJMUFkkC5R1S3U6Aw/toA0dzTSnddBXZ1E2y5YyfaPvlYiPs6ZUYMWIgGfxN2bIwlfc/mrBudCQR/vNJBDwPc0EZ4mMFZ4WWH3c1fTozbEjEkma/3aIlc3fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 9:13=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Mon, Nov 23, 2026 at 3:01=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> > I know it was my suggestion to avoid unnecessary calls to
> > get_random_u32_below() unless we actually need them.
> >
> > You then pointed out that this would move get_random_u32_below()
> > inside the spinlock, which I had overlooked. Sorry about that.
> >
> > Have you tested whether calling get_random_u32_below() under the
> > spinlock increases lock contention?
>
> Yes, indeed it makes a big difference.
>
> My initial version which always called get_random_u32_below() at the
> beginning of lru_gen_rotate_memcg(), prior to locking
> pgdat->memcg_lru.lock (but some of these "bin" values would never be
> used with this patch):
>
>                   &pgdat->memcg_lru.lock:     103487653      103501074
>           0.06         301.90   195317628.84           1.89
> 113777275      116290184           0.04         339.54    30052760.20
>          0.26
>
>  Completed: 681 (success: 1, EAGAIN: 680, errors: 0)
>  Elapsed: 61.23 s; requests/s: 11.12
>  Latency: mean 713.05 ms; max 7470.24 ms
>
> With the get_random_u32_below() call moved inside the lock, however
> only called when it's really needed:
>
>                   &pgdat->memcg_lru.lock:      99442644       99458122
>           0.05         342.95   243043664.06           2.44
> 102985677      104642320           0.05         231.58    34095676.89
>          0.33
>
>  Completed: 548 (success: 0, EAGAIN: 548, errors: 0)
>  Elapsed: 60.66 s; requests/s: 9.03
>  Latency: mean 880.18 ms; max 3847.24 ms
>
> I did a few runs, and while there was a lot of noise, but the
> difference is real and reproducible.  Surprises me, I wouldn't have
> thought this would be measurable.
>
> I guess I'll move the call back out of the lock section?
>

Thanks for testing, Max!

Yes, I agree. Let's move it back outside the lock, even if that
means doing some redundant work. The cost of increased lock
contention is much higher.

Thanks,
Barry

