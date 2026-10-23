Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5326E606A333
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=L+xdbXgZ
Received: by kanga.kvack.org (Postfix)
	id 72EB06B0093; Fri, 23 Oct 2026 17:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706D76B0096; Fri, 23 Oct 2026 17:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAF26B0093; Fri, 23 Oct 2026 17:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 402176B0093
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:52:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4FD980222
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:52:15 +0000 (UTC)
X-FDA: 85355239830.02.D168D31
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8FC5C0004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:52:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=L+xdbXgZ;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792792333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jU1IZAOHq9r8Ir5hIP1rjGnLwS+weWaNtdurABD6X5g=;
	b=lrEOJLEVwGC/JD3xoUjaBwreFTZMJkac4OJUOGnfOevkvq2xjlJCYwbDQmZNUChogR1n35
	VjMn99Cqlr9McOr323thFHM96o8kTFDOpaZuRRDgveJWaCsOWTnDBeogTFC0AuaO2w5XBA
	pWwMWRMXfNp2LRlepZJKwQGNIMB105I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=L+xdbXgZ;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792792333;
	b=EsMmqVp3XIrUOHd5sy13UEviy5e1OBqzwtZu8Iibg34L4N2z6dGkK79r9PZvNJQenQvqwt
	kCTkUmdGS9e/1UhrTVQlyz0DGfpMU4o2URz2XniFwFebCJePYk4W2EuBJeWsGcm5aXOwj3
	2oI1tRHfNXWu349Ss1nQUjwtXQvlS/E=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-917997ab0d9so15468726d6.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792792333; x=1793397133; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jU1IZAOHq9r8Ir5hIP1rjGnLwS+weWaNtdurABD6X5g=;
        b=L+xdbXgZn6rHOBzVJ2TO7a/d/rfgjLMW3oaJSfHd5WWDcaViDv9NICS7AFIVvxvp8r
         WWZl4zFooSjQgSecgHcXvoHQ8G2tG5EGKv7sBu/BJl6hcpYLvTeuc0XmC13OBw1YUkvb
         79wzFHNRrodjHTcbIiXOEXr0tRsV5DwTgaFbC2aJ2fFU7EVbuRRxTm2ZSIYoG10w2DF0
         wwL2EN1fEIQApEo85Zv08fJ4lS1E9SQQqALrmNYgkKe0osGbtycvdDo0kUDRxPbaJ6kF
         Q57PVgkkybHmpJjTKoXqQMcZepzaw97zHTEAt4Te7dDhY5gwaLBV+OSOYhNeDityuQo4
         D6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792333; x=1793397133;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jU1IZAOHq9r8Ir5hIP1rjGnLwS+weWaNtdurABD6X5g=;
        b=IRGcq3D1LASoGuXhz3NO1cC8ojj2972bMe6YTX/Ta8jXBjkp7Jc2ssGNKKCBg0hStU
         a+KadzALQS7fOHZx5wrWVZh3tSDY+LrVvH7lzJ4fQSGP+Tqxq9nQJBw3FuJgfJqAh0NW
         qabHsPnl8RcH1YVregxcW58Rret4jt3HowJi4V2xxXCqNdC9EyvraxsEeHmObPq+Z8cy
         zp2sD3QYy0TrtuF+FsioPDFkyMb7o+kBPNluRjsZvobWakv8Ouo1RzQBrF8v6K6hqzta
         S7C1Yo5cp2lZnMuUX2yigsZLTRT4xl/WOkn4fQm7Yd8Db8lQ/aEFLcPpPF3Az9VUyjxw
         jGOw==
X-Forwarded-Encrypted: i=1; AKwUvBzDKHCVBAXepNFWFHmrWT47dOqNaVK2jM2H8ksheclzPmMMGKs4dtyVwnJnUSc92BCzrD/AChE8pw==@kvack.org
X-Gm-Message-State: AFq9FYJUJGAa5v3YxlH5jtelohudhJYionvRWeAHbjQ9XT6R5ZSJnek9
	rDC55dcL64DTTL2vry2WAjlX273VZ+5Rk2TmrmV/z8VzoCKTSpkfAwx1JRQJo3gwVC4=
X-Gm-Gg: AYBFou0eE290BZmCrrisP1F4P+1ncrKbUdxhHMpg7/wYbyoGvVjmcM073GnMQRMtwWA
	xVI+ayefsH4r+atAwC+ct7r0TNeGUhXxLSP1vb6m/nZ69bbtjc6nZ7VnXa1t63E7/+EL+JKZd0+
	goUvePCOuTVcFWN8gkNY6BeOA0tVpXPKDl+ybUPUPrZzObOzvhUcBPHcylkzdinEqgZj8iyQ9RD
	WxZkIhSLShEd7W8CjkPta6byQbQl+TC5Gff35Sy5u/l9og8mebJAWH38c55riXkHN3517k+yRPu
	cLTyY7WELFLXbX0Ifoy2X77cxe9meeV17oCGooQeIlptv7eA4osVEQM8kbot88MfIeMd2rkJaTJ
	nZAgfJ8+lkfEyXS9AOnDA6fWAgi+zW5NomR8g4hOE/JqpBf9ghv3aS86ynzvldvxNbjaFMf+Od1
	CtKRdF5qUuZubvSnjPQkadFdy9tUmdYFJcaXi8JKiggotS3EaJDwDGWKQCvUMaGCnKKZGb1Dk46
	NSVpUVhSBKVQJtFPYkacARZldE1boHpSsG1wiGZFkH3TsEUX2HYRMsgQLBTxyxemTeyOzKpdcyz
	aj1vkwAhbi8qpbbRzODHIUMHxOU=
X-Received: by 2002:a05:6214:5c45:b0:91b:8870:3930 with SMTP id 6a1803df08f44-91c48e76cf4mr5685596d6.45.1792792333037;
        Fri, 23 Oct 2026 14:52:13 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c6f3bcsm5375386d6.29.2026.10.23.14.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 14:52:12 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: Path forward for Virtualized Swap?
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
 YoungJun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, 
 =?utf-8?q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
 Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
 Meta kernel team <kernel-team@meta.com>, 
 Linux Memory Management List <linux-mm@kvack.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 linux-doc@vger.kernel.org, 
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>
In-Reply-To: <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
Date: Fri, 23 Oct 2026 17:52:11 -0400
Message-Id: <179279233116.3784731.9576593182600250610.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: D8FC5C0004
X-Stat-Signature: zx7u8ocgnrqncujcpmpui6o7h16kkzge
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792792333-795236
X-HE-Meta: U2FsdGVkX19EKHGIA8JvD5dR+z7h5fNJJp2hFPYSsx527MoBm5Ea62VnDL5aW9oX9sH0Z++WKc87wMNt66o/6uQX7yqdTplYclUK00D0h5zUNxurLiMAtj+A0Xlg5SjjzwWmCKi6q+m1uviXnq/5E6EZYb+U0MMArt9UEImpDchSGBUmis964/tmfmcnE7+qHwt1x0cs9PWmvRMGEzxlbcTj76nTQOUkHeLwMipvel8I8P3KeWndPw7OMf/sROJZqGedd6akjoVvEG6bQvnH8q4ct9iwgwtliHmHrjIHdL/mURv2hjhBCXl4kZ90e3oCG7mLw+N1Knye6+tcv8iJiRy09a5/TV3mnRmbMw9jncGfa1VD87+yDJjc6xwCcclRC8TGg3oZ6kHbITtXJXvXQrxmkImqE5YNHXkdm8x7Gn+UWyq9X8Ayx6Pkll4vfsyj8jbwVccamH/QxEpVNfh+Nv4ipUtngWH8uA7QSBK/V1+CrTlwF18Bs72er8AueWfdtZ6FG/BnABXBy89dDpPYfYznXLE3knreQ8qpvkT995bDYQjulbaJe1dC4Synk1OpSD+/J882pGtdostd/02RG+9/pLT0Fcpd0MbjWXtxdr1inUsr2xLgyPa/JH0wq/uWb4Cv2X3craotl3Gg4ydU9JSIFlMphxyP4yHc4bAFv3KR8WUOEX4Aq24DRoF2VMyVcpxdoXri8eLHX9Y3n3pC5v4krGc3b5/RgS7kfafMy5O3ctNiy7NYhdgWOBgNUsNjsLGEQM10DDyV9ukozYYRTn96mdcmiEHp+Ah7vE+TlSMQNA0mRQDqPWbMfrgvWxiV3BB+G2lcyLjKIEyXEqJuOG15wf2I6vJvHM9a1h2AZdA9jelfC2O2HjE26hWUKvM58LUyZ3e8E316slhyXt1Eusy6zshC73pOURBiBfXj/YLn195UbDXzYq4y7L2U32+98YLit8amY+Mj8Pw8ZVm
 A+Ut5Zd4
 eC1iDuLJo04DWnQV8tv67hCpq4YYmYRQNPnH2i4mz3+L/cHV5jZ8eablVyPpguXTtoZCQi15NVEqhcptq4c0FdqKyxamOdUWmhfHwBySfH8Gpot4fks2MotlSkyUsnZIKJUlmQAGVTVgOs38OLFg7EpVuqH1Ntcr/EHtQ2LxsTqEOjBjHtmSeOFOs9M/mfM0hlklsvVklQ84Hiek1GPzeuJ6ORGnarqUUxljTtIBYIxAxW2Jj4dpkNkukTw8WwzyoswHVGTdCpUHkgzySrRXBgg0/DjrjLZDamtUNJ4OX03u+YgRKJY2EfMp9Pi1FkF5SaxO29OmZVSKYkA6nXNXsJNGnNWPSbuhB2xlcPUTacV8lvgvwEptCWhZ4XyzrI4x58ThP2X/hyzUYtaXGQMZM2SKSshODZRnOCVqxkFZJPeJJSkRS+yzE/vHfrvTAqh0Aof10ALFWCYrvWpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-23 13:25 -0700, Yosry Ahmed wrote:
> On Fri, Oct 23, 2026 at 1:03 PM Rik van Riel <riel@surriel.com> wrote:
> >
> > +-------+     +------------+
> > | vswap |-----| swap cache |
> > +---+---+     +------------+
> >     |
> >     +----------+-----------+
> >     |          |           |
> > +---+---+  +---+---+   +---+---+
> > | swap  |  | zswap |   | zram  |
> > | file  |  |       |   |       |
> > +-------+  +-------+   +-------+
> >
> > What exactly do people want to accomplish here?
> 
> Today if you swapoff a swapfile, every is swapped in into the
> swapcache, whether it's in zswap or on disk. With vswap, you have no
> way to trigger swapin of compressed memory in zswap.
> 

This seems like a missing interface in zswap, rather than something
vswap needs.  But you could just write this as

vswap swapoff {
  disable new backend writeback (swapcache fault-in only)

  for each backend {
    backend swapoff
  }
}

so rather than vswap.swapoff() you'd actually just want a stop-bit that
says to disable the swap subsystem writeback behavior to all backends.

Otherwise the user can just disable each backend individually.

-- 
~Gregory


