Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68109C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4216B02CC; Thu, 13 Aug 2026 17:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0348B6B02CF; Thu, 13 Aug 2026 17:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E667A6B02D0; Thu, 13 Aug 2026 17:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDBF56B02CC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:59:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A4A31A01C4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:59:11 +0000 (UTC)
X-FDA: 85097612502.08.71B6C7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6CEE1140010
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:59:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giWWTG21;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786658349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YAHKs2zBGdstKw7oa5V8gKeB7X3PSLZw26tL2EAoKI=;
	b=6IBdQPKlDyGdmgU5qoz57iwzXhGnMchB9IcAk/BIxQeCb6f0A1YsF6RaFQNaZ1ohIRyWr5
	pA9BhsaUIQ4rqBQrY67TYakOVkDG136/l5Z/cE1vI4Ov1glzuf+p8zodwk+u7Ms0w6VYAV
	GwpiIskh44iV5a0HdAa6z8I1nAslYqM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giWWTG21;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786658349;
	b=WCFAh3g8tWQkeSNIjjUhxcBtCGkocI2w3CYzYLF+MqyXVXC6bbcfjutHaZ/6dCqYptDbMl
	zWdhxmyU9KK+uPcFzrDaDR6MyKd+U1JjKfmzUGsfDqJEsunVrpfAGSvygu+uhBb0782Vjo
	wxuonymq7Oa3+gSSTd5OHTR12yLRGK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 704A1600E2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246751F00AC4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786658348;
	bh=6YAHKs2zBGdstKw7oa5V8gKeB7X3PSLZw26tL2EAoKI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=giWWTG21JcJyI+OaWF6tu28igcvbpYaVZ3NcZGOwP0lEnOsGI45AFIrIzYFiB0lhZ
	 YSavTsuSVJV4L8kv8IgQnYbjGawZQurn4JWwR+jRqLbknX9h149CIgFiVkK2w3Tf/l
	 uV2CG3W6pPu1bDKO9AyGGv1Voe1aESdg3EjP4hlUYZXbxaECIdJVZqIhBu0gnAUxiW
	 GmHJtjS7TcXk6/0NMPp3FMaKdiFusg10UkH2sndei9Ujhb7lDYcpGq7yD0r1h0i1zQ
	 MIA85/SMfV/GuAe1RByk9xJJVbE2Xc4Nhp5loYrH+AVqREvPL5HUmZy8BQeGa+6S8i
	 QIqYUKDZarCYQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-934974844ffso25668885a.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:59:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr9Gd4silSNHUF2eARFa9mczcVgTHp0gwHfg9/va0p278BlahAH5X87klswbwXA8Jwg6ua5KuXZEQ==@kvack.org
X-Gm-Message-State: AOJu0YwVm5kvSO69MGKDNrGYuuAv87WkcarhpsmPq38ps5v42AyShfi8
	uYflkukDMYQq78rtzuoW221ES1O+ovkWyF2Q02lKCIwU/e2K8ztW1q/7FzoQ9keSr9SuQpbYx5s
	oHHZXXox+5wa8u1LbYstV5iCsWgsS/do=
X-Received: by 2002:a05:620a:2a12:b0:915:6c63:b9eb with SMTP id
 af79cd13be357-936d23d2375mr86005485a.47.1786658347490; Thu, 13 Aug 2026
 14:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-5-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-5-db943a0d0d6b@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 05:58:54 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wrQRGjqavMzWgi2+PrRr1ztf4QRZEb6HKm02OF8nEBUQ@mail.gmail.com>
X-Gm-Features: AUfX_myLKGGG6uT2Wxkl-00dWnpqQoadFBvFZJkATesXkrs3xgsXawD2v1-oYtw
Message-ID: <CAGsJ_4wrQRGjqavMzWgi2+PrRr1ztf4QRZEb6HKm02OF8nEBUQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm/vmscan: flush TLB for every 31 folios evictions
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6CEE1140010
X-Stat-Signature: ecfa1o7dpqgp6ms4wgazscsqyzixfy9s
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786658349-937214
X-HE-Meta: U2FsdGVkX192nEdGL9ZxCl2q8bBVVvOnqKHTAlhycEUJ7csJomLSyuLGzTGJGZpgvX4b9UelLSZHCuCGyM77yxBqA73vw4ST4lWlWYycYWBv6r6oyM9LbhUH06zsf+DENJ/61NeC0aDVNZefVhfmKJo54iId9SvlnvwjiC3YdsOIftKL7aecBBWL3xIyFuOrU9vuN+BxSwBD3Gf0zoCySuz7IdmUQ4r7R3IH39LFp1c773QoYYA9ufIATc6hg4KsSM3UbVSLq7VrhLlzs/JroGa0n1BCGGCDKLLUc7DQTSXgWcZrux1AWRgAM4CtiAq/QQE899rIRvDkXN1QYe0W5mZZCdcOcDuGrnRPBHfbzw5eVOKSUzeVnl4QPb6Ozxfpqv+8VVvnKoQzbwHG4fAVr+5hqPchSDw7EzxlIKQAnpo7VYSTZJZBb2arySSGSBFVL3Hzukn9VIu+8IJWQdNKtLHvTlNTc+lXIpUjl52lbAhVsiLU3j2ITMXHh5OpyG1vlfRUv0QJmyT7j6nyY0Iw18b0xow+SkHjUMJ4UPQLPWCulyt5tyPlywJzGzPWqztRC5AJlHQ/t5Ezml8gHaGh13MdnfS9yCGGn4CcytRCdk8vzh1Ap36gs4I2dqK9VUq/FOb3mm8mfi3zriU00821g9NyiUSM55EGspuxed2/9Ij/eWuz1bsIAJLfGBhdwToaNgqceTe3NngYGNy8bApWqg0LTfuv3JjbF6Gu9BMD7VLPg24Dy/bDj+xxnPGsIUM/Mn/wL5jsZ2nCJFzdmVeK8bR2ifbPM7+fhC0eBHeVo6Knc2s85lU3B9Z/XpvrdVio2uLiiZBfCwYENkodHbNRTk/7pY3azhUlmjc0I/U10krRIzbhgE+wY9Tucm9TfIfWwMgIdH696mz4nTENlrFspMsnQYBEWMBOBSV5Ket7oBKk5N+TeR2Trsv3TnLEhjFehLV5b6nSKm6O6JbNSzE
 Uz/rpH5w
 9ZAYyT1n+N+9sflWfCgL9CDvnnk/lNGS2eH7LPJbrallSHpNQcT8ytQVcBSvAxisUGvto8Y95ibkQ99j5TFMN8YdqFl4UAGJE+8aw/gZYr/BubeTRWeCJy5cXSANFxHWnbfHa3w3OOVQxT6sahBe3Fn6UgxZuuaD5K0vWDedrZhIT08GDT0K7wj9V6gicMDD2fK3vPeAMM5/CdjIcXikAHpS8pcL/1q2IGZS6uOYd8AOPTLEz5cep6Rjuc5Kf38BiweWXBu42GO/6V+4Bgs9N6ckBZQnLFET8U9WmyvOfmH8iiKoIqy1Zjcn0YgdqQFlTadtJPUfisB80cqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 1:08=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> Currently we flush TLB for every dirty folio, which is a bottleneck for
> systems with many cores as this causes heavy IPI usage.
>
> So instead, batch the folios, and flush once for every 31 folios (one
> folio_batch). These folios will be held in a folio_batch with their lock
> released, then when the folio_batch is full, do the following steps:
>
>   - For each folio: trylock - recheck still evictable (writeback, mapped,
>     dma_pinned). If no longer evictable, put back via ret_folios.
>   - Flush TLB once for the whole batch.
>   - Pageout each survivor via folio_try_pageout().
>
> The recheck step is required because dropping the folio lock between
> shrink_folio_list() and pageout_batch() opens a window in which a
> parallel swapin (do_swap_page) can fully complete and install a new PTE;
> once mapped, a parallel GUP can pin the folio without taking the folio
> lock. Folios caught by any of these checks are put back via ret_folios.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>

Yes, I think batching the dirty flush is a great idea. I can clearly
see that IPIs for dirty flushes (smp_call) on x86 take up a
significant part of the flame graph when building the kernel in a
memcg, so I think this is something we should pursue.

Could we revisit this patch after we clean up the previous ones?

Best Regards
Barry

