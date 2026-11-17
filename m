Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307EE606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PEE/teTQ
Received: by kanga.kvack.org (Postfix)
	id 41E426B05B1; Tue, 17 Nov 2026 14:12:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE576B05B2; Tue, 17 Nov 2026 14:12:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE206B05B3; Tue, 17 Nov 2026 14:12:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 096F26B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:12:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AC4F16056A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:12:15 +0000 (UTC)
X-FDA: 85445556630.18.3B3E734
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id C8FE214000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:12:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="PEE/teTQ";
	spf=pass (imf23.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794942733;
	b=5rxVu861EB4b8FZ3xBDlTUWBdS88MyPEWxHvneaCwGblt+p0iueGeJt5K4JrFUfgx1FqUY
	c71B5VbhaJAXgj8PR2xZsrb++DXG1Ocm6qZL8rJz4jBl55ujd65vT1cqSsoAz3AAjL/x8G
	JsP92C0QTLvfhvHeLD/xmzPCQguqp2w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="PEE/teTQ";
	spf=pass (imf23.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794942733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoGTYtJjdTBlgzzjEp2BKIQvSbp+BHYyIKXNcsaV2lA=;
	b=XKHUYvCsNfCI2n5ck3pwQ7RHGVkt+UATVy9kjjBConR2psLn2pNbLqWqwDQN0+HCD417sI
	m8v4izGhiAo9h8qn+nzAgqvk7o+7Jfs0b7B2o7pJacFDqy/Zkp4rHOuAlL9aPIWgY67+Qy
	xIbhBn/QdQ/xzG7G4KZuPjl2hMuQBok=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so272164c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794942732; x=1795547532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SoGTYtJjdTBlgzzjEp2BKIQvSbp+BHYyIKXNcsaV2lA=;
        b=PEE/teTQrC7up8+DbDyFBDXlHyCsLHqv5D9JHbud01bf6DWNfa9eZMmjdeohcvQiQV
         U+M336EaWoPa47j+d8tgDmwdfbOP66C3PvOY4SEwvtBT91lub0tPMMUAwaAqm2ta7fcT
         wbn8wEHtRqHwSzETW604XQHnUOvyKzTzYsqdY4urBQnd3LmvVvVHeqIHpfDFALLH54ZK
         ecNLfQLm9cqBW7pAM6NDMauWhtKYkQhLo1hfy7c7sO8yFXTG4/RIjIYwXwDVrkj5sc5X
         8SnSahFH7hCKAuHTIDuEY11h1R+IpSHZzeAFWml6EO9OXSf2t9o45jzKPL6S14rzAYeW
         j6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794942732; x=1795547532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SoGTYtJjdTBlgzzjEp2BKIQvSbp+BHYyIKXNcsaV2lA=;
        b=A3NG6X8pPtFSZr0zglhqv70VO0dr4hCpmlOBljuk0GhqSEjMr/kOToy8IUhlJdNT71
         dxBe+WxHYXyCX/Du+1FkmdNC50qWSiW1l0dmLXsnOfG5/HUs6mwmA1IQprH2fUOwSZqS
         pEJ+UYCHJf6lXmEgQ9ImCWyeW2+vqJI0/b8cGzy/SnaaxcdUflY/jzZYaTXiGMGNvCf3
         uQa5WndvAEYSxmCUwX4CNGMlQL0ouszLizjlLpfr4uiTzGudvtYrl4H2Sj4jHzELRfpO
         HgwqcKc9ObCYt0V7g76UfsleTZQJ2/hQ0GguTk+GCLzVIsk3Nshj6Zk/PuiYaFJw4rsc
         iZnQ==
X-Gm-Message-State: APuU4Z875R4inatCXUWg4M9W/JbTuOrDqHBitRwfVARXCZImBuAGxdfv
	17qS0QIUVN27QF7CsHkA/iBD5RgXozo+mnarB7XHStSfM1VLMseev7aT
X-Gm-Gg: AYBFou20M7zjuOQrEjy4uNMWBdEJmcLJKtWmYz1tFDoXCyawdwRsTC+68SIITWXNzXl
	7CjwLkuCfK/fD32YqJb3JEEGptQOJ9ucFSGANNMEi4ZbPcrZQBXBcJZwZz7tCcXpIlAA/OHiEVt
	PQn33Pw0fTJKzgNG1GE94eTNEdNcrCij+T2zB81xCCCtygQdjdwO5PUm1ayWf5nbwTi/myBaJH/
	MMg1Xv3SB7bkKGjohcCUgD/xvbNZGjubQWl9HfwIWOJHMRkDgJwJK3KjXEAVuc+zblnNgZSWxiT
	6xrkxhv7bFN71IfIIvs5gGAzKjZJo0jy2YkjQioALnXEFTeqVkAGYCaofLAOKi9vtr8qRIp5+IN
	tc1zQ4NyTOFAWBd+xABRrG2Vz7SSKM+eMfVjeyu9S9uOwZWNv1mNABvfd9XiJgy6mOcbl/9kRSH
	NGlDaxgw3BeX5byqsmnuIAneB5t/6AQgiOkoaM8zW5XX3AG5X+lL4blF/8Vzyqyjt95s9F+WcZk
	d5Vl0kxE+5ZMpvFpI6Kq3/vMy8vBQRlfTl0jDYoulIjk8Ek3/GbzDpdzj4dUGixU0ng0O+TjZam
	UUTsK0Jk5WXq4Wh/BT/JIX9xFjetHWxotv6t8+twDphLKYo=
X-Received: by 2002:a05:701b:2718:b0:1b2:6a1d:bf58 with SMTP id a92af1059eb24-1b543d4b410mr474902c88.38.1794942732411;
        Tue, 17 Nov 2026 11:12:12 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447c5b02sm211610c88.6.2026.11.17.11.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 11:12:11 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Wed, 18 Nov 2026 03:10:04 +0800
Message-ID: <20261117191004.1289281-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAMgjq7B=F7grQqhUP1wGPG5uYHL44QNS023Lg4Zw0ycQEr_C0A@mail.gmail.com>
References: <CAMgjq7B=F7grQqhUP1wGPG5uYHL44QNS023Lg4Zw0ycQEr_C0A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sr7n7mnsxbop8uioznzd4bn3ab9ok71o
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8FE214000A
X-HE-Tag: 1794942733-651058
X-HE-Meta: U2FsdGVkX1+VbWVigLsa44wRGk14HFhnSu8t4+nlZTzF5v/r8r2u+CR2XJU3/VnWrggOvqNM6eWDQsFyww53mWQ/VI66AqLju9tge4LeQHoIL59n/WX6i3QQnLrhkSgVar+QGZZeR9gbWxQhnz11P/9g/7Eg7nvylTLg5rxGQf7af0fz7H4U06OdfjT9PfvNx89x4f02O7MeCrHOsV9u7wh/p7hgyXTQ5zGSpDNE76eyC8QnwwVOPtnJjGcpmF/3HSalAFP3zAn9Su6mhHirm0nqgEjOUm0DbXPl090D2d44qLvGfBLOJaDynKQ/K77tv0DoadS5jrXLl8p+VX0DZCuYwdRcil1DqXlMyzXm6xOtcv+F64tjk2wy30r/3biRjoy2IoNbuz2PlHmFb7EI1zvs6YDSxNCKFX9VuEaMrFe433jKzVJMdcWk7NWlAedBe38JgraaLIaVQEMBcuI4NXPomIgHs8tF+pKV0XpoeNCQcvFPUJEaEpA2bsBniORJCLd9dMKkOhcFxoWuTJgEEhoD1F3oKB4to2+78ujE2/c836ROcvyCweRmWRjSTHqBOrU9FyP6uyA4grRI9CJuSqIhZl6vgAOB7xAZWcKzsp4JHV83pGrBl1l5Epcoo0hXt87GkCTzWRF/1Q/KVwP0SNiSUlzkOyWPS6hnzy/3E8pF8ZyE/4UDN1J0RgN/+tbGONpJA9LYACOjpTJu+2NAkWSrerN0MeEXbhLgCXtOJtAnKXzoOYkgMACNpVL0KgYf9SssPlcM98jtqL8ckRbIyNdChGmaW0bYSvlzN1QI/V+EalUEOwPgw9poIC1TqrpMdg8GQjfwWLMs/1vyBS9u2lBtekfw9FrfPvZP+KpCddVWGrSfqaiFulaFYSchQJYZhrlMiXfG4PMZGZAR0kTRcTRM5NcyePSsMo6VM87oQDSdEYMGMWHnaqVtEF1rRovlIQt0udgcQZlJs6ixbii
 LwEP4CWe
 JHv5ln7wL+rycYblgrpB/ROdsyfPiu4W/ACjXEaJOI/vRrHPFKe+GOZHgM9sBn3ryB9fYPS9NBbVdgTRYhfjRaLHLTMLNIOwIhRc7jijOXq/6/+MPyFfaPhLWLvAJWMy1Of7QdQf7Jo+nxqCzSWiOuIDCHXFYCqh3xlpHWj0rxxLeDEGsQYZjiviYk9ttWt8qzmw1w0ZycVQ1gKvjXDJOLaHk1skWF5pqlhYg1mxwvCgW2v5b02xhYWnjcxMaa6A2P1cdjEjBcLJXp314+QBUD2cFSxfbpe53nz345WfZcJIZ6aoAn/ACcslw3NN7nrFG6kqLJj7EbGVqF7mqPlNHWp/q9awgKHtYZhy5EJ/hemAfv2PjgeryO0UknOALRPw+D1Zp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On Wed, Nov 18, 2026 at 12:27:51AM +0800, Kairui Song wrote:
> Posting a mega-sized chunk of LLM generated unreviewable code is not
> helpful for anyone.

Yeah, that was a mistake. Sorry for the noise.

> So in mainline, the win you measured is no longer there.

Thanks for actually testing it and posting numbers, that helps a lot.
I'll drop this series.

> you didn't bypass swap, you just re-invented it.

Fair enough, that's a better way to put it.

> One thing to keep though: patch 1 (UFFDIO_MOVE exclusivity) seem
> valid?

Yes, mm-unstable still has it. I reproduced it in a VM (fork, child
exits, parent write-faults one page of a 64K folio, then moving that
page gets -EBUSY), and the fix makes it work. Will send it separately.

The part I still want to try is packing several compressed objects
into one swap slot on zswap writeback, so writeback doesn't need to
decompress. If I do, it'll be a small series on mm-unstable, with
numbers under sustained pressure. Any concerns with doing that on top
of the swap table?

Thanks,
nakixii

