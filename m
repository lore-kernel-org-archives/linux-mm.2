Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF65BC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 04:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A59E6B0088; Mon, 20 Jul 2026 00:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856976B008A; Mon, 20 Jul 2026 00:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C176B008C; Mon, 20 Jul 2026 00:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49CF36B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 00:35:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADBC3A087E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:35:50 +0000 (UTC)
X-FDA: 85007892060.01.F671805
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id E7AC71C0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:35:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K+XZc51l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784522148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdWX6Ff2gVM1G5blx3T+Y3zQJjFhvHV4u/q40zy5x+8=;
	b=JGXWV032XOb+isLOtk9D5ol+CCRxwJ+Fad3Tx5mRCOj4YJrItMqtqV/hfReExwTndsc1vH
	Nl7+goJrhrr2PMVh14L2hznd/Jh0TOHsYIJJUTcbpel7B0eYKw2+w50QUaxfrPTv94k8wD
	MaKnKrBsFs07U7r5z/UAGCHenq5A+9c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K+XZc51l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784522148;
	b=AOC9iu+0uUUbAzso1ngbhewhY69vTq/MNX26K+87SqKRDRkakSQVmhW6aQZbu7/hmU1xIu
	PtF03x0fa373M5am/5xn7pttnbJ/4MY87voYXX+K6Hmu5DMQfa8TnvN0AMUk/8yFF2HlOu
	iv/GCiWO/2eMV0qyW6VKBFFfGnL0Fkg=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8423f236418so4804446b3a.1
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 21:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784522148; x=1785126948; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mdWX6Ff2gVM1G5blx3T+Y3zQJjFhvHV4u/q40zy5x+8=;
        b=K+XZc51l5LK9qXNP10DaCx6dLwpikLAumpFqKDdIQZDIWlEPJzALJlWCgTzhStDvyc
         osSE/p2p/dV1F26l+bsHoEk5347T3q7zlvOtRtnFu94CQpyNsZxdKvupmDQw/G2Z1bff
         e6F+qaCWeIQ/rLO7OJ+qS+J8IVh55fwwYEE/09Szkz65v9bM7s8NifM9o2eE3HXyZvUz
         LJ3CoWWlcBhV07czoMwR/dBv7z/uvIMl8VnQE9GlTGg3ljjPgPYzVXyti0tn6a+r3EwS
         YiXNk8+KFbDEt/DVNaf7J7zg67xQBUd/xOxgocaoQ0LJFl0XuJsvgBShCcTfyCUX7q6A
         7GPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784522148; x=1785126948;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mdWX6Ff2gVM1G5blx3T+Y3zQJjFhvHV4u/q40zy5x+8=;
        b=IDblL5RjbcjXMo5bP0mKueXolTEaNKCeWEwCJAezHLQzoHJFh7frthXKlkzcURZ3MA
         TSRTb0M3yzZcwlwY5LpAiNt4g8t0OpAAViY5LtPQa/vsMjBA2u1WqARSG4q9zAKliwqI
         DPbunh0TeKRq9T5RumQdVBuUgd5vPnc9yooyk1xHw1m0wfH3JyEeULCqoDVNHU1SQH2g
         SMyxioJCBnZyqyf+k/0N6eFk/inikxluG0YRX2YYr9NPwKGnn4GLy4QNJkH8h9e7RwnU
         KM4Sr813TZ6XnmugLKR6qfil59IlEwKhF3PzfvmF61kQ3tUFy0MkzIeN3uz2T/o8WANB
         w3DQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpl+stLGSn6Z0JTCD3DvBCnq4Xf4m9t2GAUltAxfVKkU56xHUyJRUTRE8FkmfNXBJNF9HmcdoJHVA==@kvack.org
X-Gm-Message-State: AOJu0YzBM9SGsftDt2cpdUUOHTLZH9ecY9v8wpU/eOord6Or22KKNldN
	Eay6nC5vkm9EZTygHYow5qLkx9l2gx1HEnIPpB2WmzIqOo+RIxoqeqtl
X-Gm-Gg: AfdE7cmXDlPQ4XH5kfV5ljkEfC9zPTgvf5vkIEPWcbipPJ5qG4XQtBfvvCe32rjxu/f
	BhT2fCyngJ2GtssPlOTCkBdqYr9WhPKvF1YJiKnH3x7/31ezCqgfU63gTFZEhDvxyZubYLLoriM
	4zmWq3rUndIeL+ju12GeJYSbabhgyUeYj2XMcW9V/2hmfc0oYfVQJWXv8oBRE0d88GIsutZa7JN
	U3j8U7hMFN2NlRW6fsS9m+wGA8GdyZdYU1dFugpRbZZXoMo+1FfKnDeHB+meOazDrdAGEC+dyZq
	dBWOEbYmftkL3MidJKUdBy5mU4pzAVYilYEDnFxr7DE8RQ5efCj9UpyojX6+pS/lze0NDTBZ3Zl
	kR7HHtRq1bZZWNT/345b3pG9xIz3ss/WUUnO00RlWFqwJEnJ5Z6KqgKewEYqBTyTqDz3DqsZLx6
	GwvWy2nTmewvCraJpzi+yX3L+d0UGqiiMs5D/gaDQH7qUtw80=
X-Received: by 2002:a05:6a00:3e29:b0:848:7fea:93aa with SMTP id d2e1a72fcca58-84c292a0ec9mr11937266b3a.21.1784522147429;
        Sun, 19 Jul 2026 21:35:47 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2adcaa0bsm4970874b3a.20.2026.07.19.21.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 21:35:46 -0700 (PDT)
Date: Mon, 20 Jul 2026 12:35:40 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kiryl Shutsemau <kirill@shutemov.name>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Hao Zhang <zhanghao1@kylinos.cn>, 
	Hao Zhang <hao_zhang_kdev@163.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, stable@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3] mm/huge_memory: unlock i_mmap_rwsem before releasing
 after-split folios
Message-ID: <al2b9eCBD3Rip7vk@KASONG-MC4>
References: <20260716095424.471052-1-kirill@shutemov.name>
 <20260717195851.609269e143b4b9eb857f2a6a@linux-foundation.org>
 <al2XTQLWB12sJQG5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al2XTQLWB12sJQG5@casper.infradead.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E7AC71C0004
X-Stat-Signature: 7gezsz31jfmbz76kzrtimtm1n3ppj7gu
X-Rspam-User: 
X-HE-Tag: 1784522148-701291
X-HE-Meta: U2FsdGVkX1/5ysBEmIkkqXWc7JWaZwJk+++3zfBTk408JAI5VAfE6zRAKqlgV7iDsOeKl9oiUdqbg5M3BJCsd2TGyylSmF1pfWC6QlfSxmH3+0x6ujK2bnsCdwI6LU9o/51ihZJq1korI2+NbaZV7XhniKG1HmAb1R7xHU5y0gQxbe9W7evuzKkxukTPzXwU9bABfnlqFqqmwzfJ0cMku1eQI5+m3r41GZS+QTzjI479+A8uK0jI56js+lCpP0rEB2PWoGh8AFmF0aQuppVj4bDIu5K2xJG5YSGbI107iD1hNl+3k/53tURgRGHUE5FpeMZziNsnc5UOafekQVPhMnNKArSuNdC9fd9btZuYNB7tDNGVggnNk3VhNqLj0ZQzBLHOcvsYXJkNNW2iMoeRAczQrTen5mu7V+8EgyPDyG39ABmO5UGa4y1Gn7kz+E8IUrtEMnbUBYNNWc/cdq847Y/w50aFvbwI3IMoUSodxGgjhWXi2LFAQyRsu2PgoerHDuGzZQNXUZVhmHRWVnreGPytAoqO0tbMrFka/coik88b1y4TYwTGqjt5wg90rdk/uZ+3A9e8+eg1j8LHpGiIa72Tc3D5Z4Kw4Dbi2p0N9x+R5t8uV8Tx7DodG6OyLs2fowr8UkYeyYBcpKIS9/yNObvgb97wRY5HZnPWXMG0O57O1UlH+AEoOvMNNcWZqURJYblQPDXBpP6viaYJ/hLcRU1I+MADwT5yN+G015obcgd+bdPBH9cXNvvcPIPOit8DRWiAFG1Exps+b37u5caDzlqPuKawKPAFi73R8PoZqIPOE0xQ/P73ZA5pp3fXeQfh5aiaSH91jb4+e9Pw5qJBMdLu8HXLDgX7MYZWlQUtK15z9ZQ8g3uE07eN9h4QSBnuEj40RF10zg78A5HoT8ezOtC0L2MJ6tYZfP9zQNSd8kvI0Jg0DO+f0enDMS61XrSSCOYJ53tUnJIbHazLza0
 VD0rl0Nu
 ufYqQIHj35XSXCSPy4/WMIvMPE7qUa5LGYzME/v0eAXt4gi+iCjGMS7B8yPcaMvk7RNGJ70JG29CpAVusJLHRvAgZEyP6rlrTxVHJTbd3poAOH3W3lbwuFa7fqnyty7uZYVIlFL6g8yqToR219pBR5qggSv4HoD0H3RxWKGDpWYjkdcrRgCvOApYndp6dkMNPXJRBE3U4AVQ5e6+Qfn9TJlVlHguN0uffRV1pHQxtLSnzFCbLd2lIIEAKRTumkbEyrnLlM63Ki1Gk88V5TykctfcIw+G3vV3hiXyz1ldkD9rXhDsCYixCoAjKDRjHmNNapOhqdXOUUQE7gP0MNXbRnq/sDcT63fBknnkWKjcG7uIS+JNDg4f7j4VTY9jODF676vGeCtQYbC1Qxxrx0OvaSUBBa8jpon/N1sbdhCeLZmedEaHsyvr/JepCCWSShcvHMYnvjxjn0hCyCP67KPSJMh5ofH/J6bmq6ksyKSF/y7ifPpD1XrBXakAALGGQ2jTCK9Sz6KQsl3wVp8FcCLZXvzBb/QUovkzwhj41RcVxF2ih0kAr22Oxhqe87A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:34:37AM +0800, Matthew Wilcox wrote:
> On Fri, Jul 17, 2026 at 07:58:51PM -0700, Andrew Morton wrote:
> > (why is mapping_set_update() a) a macro and b) undocumented?)
> 
> commit 62e72d2cf702
> 
>     So make madvise(..., MADV_COLLAPSE) also call xas_set_lru() to pass the
>     list_lru which we may want to insert xa_node into later.  And move
>     mapping_set_update to mm/internal.h, and turn into a macro to avoid
>     including extra headers in mm/internal.h.
> 
> Take it up with Kairui.  And whoever it was added that patch to
> linux-mm.

Right, I initially wanted to make it a inline helper, since this function
were a macro and later become a static helper, so it should be super cheap
in the hot path. That requires to include extra headers in internal.h
and that looked a bit more uglier and every internel.h user will have
extra header dependency. Moving it to pagemap.h also looked confusing
along size other mapping_set_* helper, they are completely different
things, and this help should stay in mm/.

So I just partially restored how it was before b64e74e95aa6, It was
never documented though.

We can make it a function for sure, open to suggestions on this.

