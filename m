Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA30606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=NAQsZv4u
Received: by kanga.kvack.org (Postfix)
	id C54176B05B0; Mon,  9 Nov 2026 13:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B636B05B9; Mon,  9 Nov 2026 13:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41786B05BA; Mon,  9 Nov 2026 13:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 827CE6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:01:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C9CF407A5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:01:25 +0000 (UTC)
X-FDA: 85416347730.03.42DC578
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id D3B482000F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:01:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NAQsZv4u;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794247283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gt4VMnvmrWa2nAQLESYVbnrfaPMYEizAsDM6TBhtRVk=;
	b=VcTLz9c1VfgvKUnAFTraro6hN1sfluRP1z1E/yuWS/4xNoFVUU/khj9bhUoAStJMziRTQL
	FyeUhnEJnpeK2qoV+oBvi5D657FPYNeWywBIYRrW4+29RS9k4wId6BfCzghNQXXPa1uo2S
	r08qPm5Wq6DaHagOHp4maZP80ULsQeA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NAQsZv4u;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794247283;
	b=Pp93curw98JIwkUQjqyDDaebklYSAkvRdKa8SAEisR+UiOM7MC/L0U0aUH2CjAGzJ+0EF6
	Hac6OyH+fltQjamFremYFeVVvCamYdDKJHSJ9qgQ8QNzhn9G9Tkn0/KDUzwFRw97wlU0W0
	qXhSfYAI5dBiJ2ELba3A6Hf0RIMHiIw=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b75712fb57so154598a12.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794247281; x=1794852081; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gt4VMnvmrWa2nAQLESYVbnrfaPMYEizAsDM6TBhtRVk=;
        b=NAQsZv4uZXqYbVsWo3LBs1pekXmc0UHr8erHFyKRRywc5erPI1IvA+vh5Y6gH9oBE8
         h7y5dP3NO6rB3D9DhfscJuQapw6SBEnjtu0JAEHF6Q92JYmPtc1A0DKR/WoPWXCFNLN1
         h8X8c0S7MA6n3vxgnAR6iOYct74y+nKUjefH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794247281; x=1794852081;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Gt4VMnvmrWa2nAQLESYVbnrfaPMYEizAsDM6TBhtRVk=;
        b=eK4Pgwe2IEMPS2GpVBFdCPvoT38NAWsGBt8+W8YNdzNLPq01mBqZmRBz1eUD5jp3//
         zEzdB44BfYY4kAGUIUSDDe855gKp3GcEeJ8+nCqAqMpPJ1h/iHkWWMaw1MvUecd0b73m
         9hJUf2oQdONayKKHATxCLNS5MHbG5PJ64+2oTy+e3C8B0K9NmkW8vbcLdqJLSz9R13P3
         wAGYjKkfxbRs0v/wsO5Fdb51+0rVENQ10Nu+nizOA9H6oOUORmILbwKgHadwQAZnyuik
         tSfLdzcNTFTadikKKGK4JDgYuWO5+A1IoVHmsM3vMEUHgK8iNF3yzAdw4U9j/t3x1YDE
         PS2Q==
X-Forwarded-Encrypted: i=1; AL+hErFC2O7W5qo/q8cn1aEvTYhq3vyu+eTzoy8HAHbodZRFk5F4fctxvKRnSg/ZmB2prP6pK7sG82jfog==@kvack.org
X-Gm-Message-State: APuU4Z8pegyThASAAZX0vGdq5SPTPCQES5D6d/ZAtvOv/7DDwFb+kWdN
	2MLVSjFrVn5HEr6TmL02aw8Pgtz5JbhTSwpKUUdKMdR213ex58et1AJbGx9gavcBmRdtBPeg0OC
	rg2K6yxF6vA==
X-Gm-Gg: AYBFou04jaFqZxmIaHqaspNQbkEIDyZn4eXn5L4xyFAa3gbzA8MwZtEZSqLxnZtXgqY
	3y7PAt+vAXdd1ew1RPhXp4c7b6cWqF1bJ5q5TJaxiadhQQVJDMNT13l0o2tNZjqSz9d+YXgBDgx
	vcqi1EIh/oPW6v+vGa/Pd0noPLnWltPtP5G0mpjlwJMA5O8W0g3ftwmhHicesMgwSAo2AqUELCo
	ajQdzk4KL0xdFMzuEVkUNj2GUhn1oCH/oxVYjwYSD0+6mgYlWHznpu1eJmfrcSxrA+lVsssp8l0
	zfB+0UpGc66xJHJjjE5sacBWvapU2psE9Fn4JTD2dbVRcN3m5jq/ODrXYH/0kIv1ued6c0/u1KN
	FrV/+R8LQjDjRZYa3SjXNm2H+cbos4JTTEPyn0kMwAGJaJQUJPAjdflLsUWTa4fbNttAtdVSOoA
	f+XDdVxdmU64oXuWhBazU5vvoPFXmBc9aCsErRAWfeEySPj4ryhprYrxigij7ht8RRDAAoJFewj
	ZlKNBGd5XTqW7nUhAllWrUpMsMbg1hLt0nMhh/IqnzAjsfDP1oOcqe21sEUSwu1Y8jNsWAX0wxD
	cx5CW3gPlWmV5C3wz8u51L1DLJO48M0vr2OxZQIlmNkxNTbRpfNfqezUUhii9Aw=
X-Received: by 2002:a05:6402:210e:b0:6b4:86e1:cc67 with SMTP id 4fb4d7f45d1cf-6b756ae2abemr300694a12.27.1794247281005;
        Mon, 09 Nov 2026 10:01:21 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7509b1adcsm430875a12.17.2026.11.09.10.01.18
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 10:01:18 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4d5cb1b181so159848166b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:01:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHBW1GY9c6guGh/oPmjgLwehdyMe/BreyZ5Z5FqgUmWTvz4uWxEA6ZqzM6P29jegVUUv7PnRhGZWw==@kvack.org
X-Received: by 2002:a17:906:478c:b0:c41:b94c:4538 with SMTP id
 a640c23a62f3a-c504973c481mr7202666b.47.1794247278274; Mon, 09 Nov 2026
 10:01:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104130118.2507513-1-kas@kernel.org> <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org> <au2lsbDkyWt-To0C@thinkstation>
 <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org> <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
 <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
In-Reply-To: <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 10:01:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
X-Gm-Features: AclHuK-A_qW69_o6tagKDJ1G6Q8E_NGG5rYMm4wqMXtGYWO1MbLxTJtWgkQTGLI
Message-ID: <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Luis Chamberlain <mcgrof@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D3B482000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: udqb7cdjt93ngy75a87up9bj1srq1kzt
X-HE-Tag: 1794247282-311642
X-HE-Meta: U2FsdGVkX1/wCHDLb0Yfwzw2K/Q5MFUu0G2qx42hRTEvrSIvmmTgF6BSsmOZsuUEShHjKAajIzN2XrlbTMR3eW1DwTyd8pBBsjAKsE7zLg0GZSq6mKs7faCJgxCzJ0j1lxMDb4CZ+X5Dayja5QnVTxLQ2MukZu/P52y+OpOQZK6esB1+iGrPIDm+wbJK0cVSCPxtaarq2qvrG4q0ArDp6cSV/p/mrpSFQuHexi7Hl6a1OEsgZ/vYFDrHo3foLbOB/3dG4UCjOzkQsobOta0UzzslLqaEW3BqNKO5jw+u/RM3PxQfeHyoqtNVYOw5IfTbzndyn1mI0QfRnSvb7uYPdYTe8KQtg3dsc4ft2jIMxkWyuHoJtwc9xbCWii1n5H8L+LfugmnytbgAzk1zW4OdDCnvKJfCCanfinU+9BNBQTJ/rGZKO9yDVw+tKGeIJ9vENWhhYrc25EtHMEZ4n099SbtWhktC4PYBWCIcBA9AndgbCodj6DgxyyKIxwO88gD2W283jb5DpxTI6V+W3t1VgWEH0tNpmPUyZj+57fuYQNAV5cj+J2EsSwQksCgfT0zmBm7mSmvoLJlkXJpoqnxiyN0yxVUelUC4b8F1e+HS/AwjeDxRKAeb7VE16QP/nwlaB2qIDpDrg95fdBCn5xwsQ3ofytAxsUoAcJjO8c/iwE5GPupw8lqHLm//1Pdf3VQRnlqtK0Kep/DdN2Y6hyWaaNX0FTR4rUP/alOMwfan67xc8cOzx637S9Vg7aWWzBgAdsGQGmz2xWh0ZGn4f/gAFcjPTTlh8Bnp/jNZ03Y0lGWRIcu22IWeGpxOMuYa6rxFhvKIMFfIlbAYoZ9UnTMOxZQrw/RGAKgueqLXtVfPoW/mL00iia6Oeu7QEgrh7V25rhA4ctrqLHXuma7gyRXjg+CJWrYG5QukpnU1/BnwT399ksu3J2vMgua627RcApnS5c2Sl7dYd3OZOJWcPLP
 oMLXIUwF
 hhKdrGktlIvenjE9NBjGBAtIFrz+3RNz2WpPvYSU/Mi3tdyyFHZORjVVoZ5h8UN8uzRrju8E/6D7laUwcWkma6aC/klu/wr5pLfZY7kCm0jshNLxEhhi93zhvenUY+G2mjQMZfrDGytJexh1HFiqYvEbY7I/mRbZfef9GVaubfVI28H3muLwAQsIIVdHQshtP+BxS8Yc1VHYMURtLNz3LCfGD/ww8p0GpTNp5MKkL9fOjhlHsUv3EXEpOPunaE4yJ519KGxzxzEVopTo5ItikPSOL9n2+OxM+ykaPoYRU/7TScSe32EOJWdQIaqfUq1MdjUtazrdUQ0xSR2zivWJVtIDXIcxUAsZasMQj5F09BImA+GQC+IVmexS2UnmSuNShkeaZJ4YveG4XEArCd+BfibUjZhAypOHCki0/+zYFQ+OvmhfTN5+cfhcUS/5UtXfTNCj5e9kXq9rvLF1+0zZ315f7rgd/dG1AcB4VWAfM7F8riCgb4MjwRvgr5jqUApkBLm2qfMwUborYVWhfn/trBXZBg5A6LN2Fx+19UoaH6U4RTT5Lg0gQshlm3kbOdTx6ZNbi7W+DpwI11/xfM6idDss7iMT5Z6J3TsM7R9xD9u9WQHABFShXJy40ZQ1i+WsXJJ0u/FnI3jO7rGQQA5Ato/ZP0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 at 09:24, David Hildenbrand (Arm) <david@kernel.org> wrote:
> >
> > I think trying to corral it into some special case is the last thing
> > we want to do. It only makes things less potentially useful and more
> > fragile.
> Let me wrap my head around how this would look when we decouple pages from
> folios, where pages might not have a ->lru anymore, or not even a refcount.

So for an example of a place that already does RCU freeing of pages -
*not* folios - look at the TLB shootdown.

It's very round-about and hard to tell, but it's using

  tlb_remove_table_free
    call_rcu(&batch->rcu, tlb_remove_table_rcu);

and that then does

  tlb_remove_table_rcu ->
    __tlb_remove_table_free ->
      __tlb_remove_table ->
        pagetable_dtor_free ->
          pagetable_free ->
            __pagetable_free ->
               __free_pages(page, compound_order(page))

(and I might have messed this up - this really is a rats nest of
nested inline functions).

And in order to do this all, it sets up *another* page just to contain
the batching (which is also RCU-free'd)

Now, the batching is probably a very good thing in that context, so
I'm not actually suggesting this should be converted to some common
RCU-freeing thing.

Rather, I'm pointing out that we have existing hacks in this area that
have grown up over time and would have been a *lot* less hacky if we
had had a proper RCU-freeing page allocator back when that whole TLB
freeing code was written.

So I'm not saying "we should unify this". But I *am* saying "look, RCU
freeing of pages is _already_ a thing, and we have complicated hacky
things in place for it".

And they are complicated not because they necessarily should be
complicated, but because we solved the TLB shootdown after we already
had tons of complex architecture-specific code in place, and we
basically ended up adding that RCU phase on top of that existing
per-architecture complexity and abstraction.

*NOW* it would be actually fairly painful to try to convert the TLB
shootdown to a new order. But originally, it would have been very nice
if we had just had a "Oh, mark this page for RCU freeing".

(In all fairness, we also did it that way because some architectures
don't need the RCU delay simply because they have some other hardware
page walking infrastructure than the actual page tables the kernel
builds up. Not that those architectures *matter* today, but some of
that per-architecture inline function stuff is required to basically
isolate these kinds of decisions from the MM code - that deep inline
function indirection has a reason that is entirely independent of the
freeing side).

                    Linus

