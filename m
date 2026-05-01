Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22588CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC496B0005; Fri,  1 May 2026 13:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493D76B008A; Fri,  1 May 2026 13:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383CC6B008C; Fri,  1 May 2026 13:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 291C66B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:44:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C64071201E9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:44:50 +0000 (UTC)
X-FDA: 84719576340.18.8E01B21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F1D714000F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:44:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cokKUJ4c;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777657488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YAd4wJdBuwvuhq3A/51ZtTu6jgeC0RYN/Swb2V6zYA=;
	b=HlfnDlICvse02whyOslghqiWIYZ5OOrNSfGkdF/5Yp9lFxRmogRgQbZ4MgL0fkKMteDzcq
	1dpPjEeGK5Wc1Ym5dhcnfnD6SVkQzdO6gydnMatrLtCpgfXSS4j20o/uMi8mLJyHop587g
	eqgEAF0IwjBxO7pJIU7ufFFRu+LGAko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777657488; a=rsa-sha256;
	cv=none;
	b=rIxRPbAennlK8nd/Dvtm5biXV0Hh+eN2Gl7csUDif1odK7jByILEsQig0G1XSvzSQ+Yhkc
	z1KDVuJQG41WH8iUji59A1+r98pdWKwPgkZdW9ZNLsHSTf/yVAS7cYQ9YVvxP0+SKpDQJj
	NEHnlyr9DlN8kIBT+S7ZSl0bbwNNcxM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cokKUJ4c;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 637A1444BC
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D5FC2BD01
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777657487;
	bh=Hl2YiWTcbo74Gxc6IpUU70j+aHuYqyHn+c9GqocmPS0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cokKUJ4cVjTc6Fh+umuWaKXjfGu696YYSrhlsdu275noHQdipmmX0gkSiihTIc2Sl
	 fpYV1mlggK7Yc6cXYI+XurdET3PGISSUYmW2rPT5S58wxIfAaO5cGneYrdxbKBfIlB
	 XZEkY0bHXwj5IHxfWfRQxZg9bVbm6Czf+haANPTe/D+0YAlQo7B5g+S/t38bZMqyZA
	 Hvwafr5cJ0ewDjxPrc13qWWQ0oTeI8rTw7+kBgHhpYucb3owFD/0kIrKesBp3DFJve
	 SXoo+/ZlI3WZftzrouDPSabfXV4IkYxfnkLGV13yzz1iWbpLIbSY4Ytn/c7yT/Hw0B
	 9r576Ai8d9MRA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8b59772d441so6712236d6.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:44:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+7Kg7DluLRFua6L5GPJAOBwRvcIqZ+hYTMFr1++pXW5VcG2aCXwlgfc1lNgE79q+fA2WY/GW2/Rg==@kvack.org
X-Gm-Message-State: AOJu0YzzhgJBR1fAoLER/TryXr4N0jK1Hp9nFVma/kF/sfOgPRVPzHaG
	6eQ9e0tsdIBqTUQGbxKLL0c8bJTnDfSS3cZsc/yxA4Hxl8BXhRoNvP1l3CH9+aNohPxVkwjCQYm
	3wLgiJOhiQGyVgSD5m67LXbssBWoafjY=
X-Received: by 2002:a05:6214:260a:b0:8ab:4ab9:bb50 with SMTP id
 6a1803df08f44-8b668638bfamr8385726d6.37.1777657486245; Fri, 01 May 2026
 10:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com> <afS_L-5XeWIldTXA@casper.infradead.org>
In-Reply-To: <afS_L-5XeWIldTXA@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 2 May 2026 01:44:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
X-Gm-Features: AVHnY4L9r5jHmXxuaat24ga_fMfUkn2-2M0MEFhZDB6ITf6AdiWvpvcS2QZoKTw
Message-ID: <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F1D714000F
X-Stat-Signature: cc7pfyiqrkwse4koikfpnrabwfo97uis
X-Rspam-User: 
X-HE-Tag: 1777657488-635913
X-HE-Meta: U2FsdGVkX1/Zr0aGjR7CinopLBoImMCxhEb6DIY2MsQ6doXtqvG8ztuD0XQ6qw7+NIQp7k6NXRyPPK2eoeimZsuu31tTiOuGYMJ4rdWeF9qHWTjjnSPBb2mRKIKswHsCHhFQ9DdMKyeiJXGZY46FDdL2vRB4h3imQv67xU2ZkpsjhYKzMKtkskmrPFjPseVq0Ad7gaxY0tm3XyZT2U1ALSfjJr3PiHG8wDZH9UAOYAhyuHzzx009CH/WvxGuGKsuWJqmG84mNZqz/pAElopQY68jRZEoHq3e5jMxNlAL7hSXKeTVXNS5mhJ5FEqKV8nJ3hXJiLsHHHJ/IDo/ZkGU9QRmD/R2S9FOizk35Fj+rwlPTJiRyGmSI8oLl1xp9+vn9RTPn5pCZMiNwoHR++Ria4RUl+UmTgrwf20RdxP6HwiZ+8DkONhaL6rn5oj5pUYkdnR/21w4GTQC+uQ+NKCxdUY2uIQTD8IivC6n9mEoBCvJOuEFV21SLWQNk9U74E/DgoIDvmViObloIhNUNUnnfmbsCS3hzsLF/+0eounKdc79UDDVqf1bnLsBRhRJIlizTZ+///fIhf+mfVV19N82wORKYyV7c8eBp55r/giear9BI3Mta9JJJ0cnH7igYpBKVTmxFyCxk5okThERO1uXtWDr9LhulUYVYjWJq4nHL+dZGmLsjM4TclnjnFjse3pHKmz+U4L0WZOvibgnkRyRsqSOWdz6GI9tFDDnNj9/k1JE6IhB2h1D5RAT+S0MopJa6xj1rLTPTrRHhtIZo5MHiHBqeKRHNajcU8s8f3MYWo8KGN9SmaOhXP0BvPsk6JGom9SAxENOMW7tHZKuLrY0UdF72VgyGWrGr/Ko+arUXRuMvo56TyHpcI4+X8EXBbuII2+guuLRZoN33vcoNHzGcpiZwRVznD/54++/E0PGLUQOOSVlNOHw5Ki8SL50z1GtW1H5Xng2x51EAXQnAnD
 bOvkNWRi
 w7a2u0a+/zIao/wOvWB/o1RaMUNn4QyFtyULO6lkfpNnZ0Pp/HH3qziPefPntk/AfKindSZMtW7UkPNrsxLAbtwRh3Sludf5SEvbdV8Oso+qA27JPFRrUkaZ1MGRmv95m8mu274AgF/1EGQM1YoN8+zvu5RMjELI976Is3lEplRzbLZIrx516iSF99NinmGXvrjYVpoTk3Ao1cfRUwUMG4RyEIwWU5zk8T1On1aoYClZv1C/HpF5lgCUXMhr6JTqbhdrE2Bw/VYBvpcwgcjpgSfeopgX4I6hd8ulkhkm3nVvMDeNQzmiMAkHBUo1NkBfK8oIg6fleZ0hF+90wwaipyD+RXlU2/BHP4ARBMfdqWBb331SOaI3ytd847IKV3vploZGkGCEzebvb4GjpENZBy0jExVZFi05ALxRRdBpee9+g5bP2E9/q/yy6pZilXpPouZFrWxH4JU3Ok7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > 1. There is no deterministic latency for I/O completion. It depends on
> > both the hardware and the software stack (bio/request queues and the
> > block scheduler). Sometimes the latency is short; at other times it can
> > be quite long. In such cases, a high-priority thread performing operati=
ons
> > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wai=
t
> > for an unpredictable amount of time.
>
> But does that actually happen?  I find it hard to believe that thread A
> unmaps a VMA while thread B is in the middle of taking a page fault in
> that same VMA.  mprotect() and madvise() are more likely to happen, but
> it still seems really unlikely to me.

It doesn=E2=80=99t have to involve unmapping or applying mprotect to
the entire VMA=E2=80=94just a portion of it is sufficient.

BTW, the chain can propagate: a page fault occurs, B wants to write this
VMA, and C (a higher-priority task) wants to write another VMA. D may need
to iterate VMAs under mmap_lock, so B can end up blocking both C and D.

