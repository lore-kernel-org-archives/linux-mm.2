Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B57C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 22:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1A56B0088; Fri, 25 Sep 2026 18:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582796B008A; Fri, 25 Sep 2026 18:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471606B008C; Fri, 25 Sep 2026 18:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1536B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:40:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D44DA6E79
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:40:31 +0000 (UTC)
X-FDA: 85253755062.10.4C77A28
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf21.hostedemail.com (Postfix) with ESMTP id B113E1C0003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:40:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Db3EgWZc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790376029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFqGMEzuiR+FgtU2CuuIsa+lTdqtZOje1xzY/UbInTk=;
	b=ilSI8qIj+n+JN4R/NUGasXB4uE4cG8v/fItVBdLrvp6fBorLxcvsHbozuDNqXTvAHOLq0l
	3YWoFCaiGGfmfW/mZaUGz7twsb4gbJrhJfnMpeifO71IzghXmuze/xEFJED/R/M6q5pbZe
	3I5WRWtNuFtbuJ9wL+zCSXrKbam/wXc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Db3EgWZc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790376029;
	b=yB5fRrShRDpNHdVyENW3jaSZgi6I4LpgTOJarX/gImFt7M665+ZFBMIS45Cl5NJcy/bbo3
	ZVooW+BWNQSWx2Awj2ckHFu3G7UcKaO0cc5hUIs5gXPq+zxBeZ2e65rGhtUk9HVlKJeqdy
	4z/8gDeNVKYeX1Xbvysm4lclCLyGIp4=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48884b021dbso190099f8f.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:40:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790376028; cv=none;
        d=google.com; s=arc-20260327;
        b=OD8/DI0nTdaxTFRGh2tV9+m04ZXa7tAWfAUSzOYE4EdHQw/2+yyW7h+dxmWi58qC3M
         559w9brZ5HE+kJM0GpKFNNu4AnGGzTMvYXuazxeg6Rr0T/dQENVwv4J2ibm73MqOoxC0
         Ph3TXzMVQw2vllCVvVU0x/akxfR9+kK84ghIdc7kkV1c/LtOzFWLOdR1BkvWkLKZQCYj
         oFGcVhmM/RNhhMHrBOqZGt3AI8+dbSh5ZBQ7Up/s+t7mdI2U+vqdc5EXSDhqJuax88Sc
         gAlgwqo4bCDWso3WtjWkb9i62Aq90N9mB8FMmjK16/qMHuW/hhbsknDa5DGCt8DO3ODY
         djIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pFqGMEzuiR+FgtU2CuuIsa+lTdqtZOje1xzY/UbInTk=;
        fh=iAPdXvbJm00zzMY16Sd2X6BtTlnb6L4EohlRQ0y+NcY=;
        b=PMxf6UuQrGJ/Oim7Y44P/5EpzaqvWDBfXP4D9k8hhXX+/nbQeFRE6SPT5MDjkrT5mv
         yXgoL+9cQdbDcB+h9FWYI4Jnc2A/KWAfSFaLFT0V1ANysb31nAtwIjgFoxA8x9aDbjrq
         BG57NvXRIsDwP1nsHat4JU5O5G2ARKwfpjfJHNjiuPIcq59R4Ql/h8qLL536a74062Nz
         qVQpv7apZxzComHyB6YoUhP8SYKIoTIqe05LjQLAw12eQb/vE8LbloRThIpWrR3pLIrl
         aoBD2hRYpAIL61k0ppIIQVuCIJld1UdD2ovTJmT94QQtksuCN9tprZ+MuSxODfSPrJBE
         GvVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790376028; x=1790980828; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pFqGMEzuiR+FgtU2CuuIsa+lTdqtZOje1xzY/UbInTk=;
        b=Db3EgWZc3FAyj+Qh+6YXB1atFksEXl6l/UyaAdVUlMTklTZwMc0KmjT2qNk0sYpOiW
         bkrUgrBurjcGOhjElsRRZevDKz6YP1r5eMVRZ+N+QCuvxDf6u72yz/8YZHwA2bCbjeWB
         AuLHGZDLjxdmpae8XLD+36wdM5rfeQX5GPI/PqQy9gcE0oGzpxHAjXEnDeoPR1zpZkH3
         QFQdra58m4bPxAv1c67mz0X4GCvqsqCnsK6bdKOdVJ8wDyD+iSQ2ltZ0LH8i6AvmbC1a
         TF2xWnW0ur+jBgHpIJPhT2fjkce1XJ7eRQBz3gP9iPkFSxVTr5s9JQkTn28hk0U6hzwZ
         yHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790376028; x=1790980828;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pFqGMEzuiR+FgtU2CuuIsa+lTdqtZOje1xzY/UbInTk=;
        b=jCUh/z6DZEFcqpDKoymF2+HCkrADRn+fbKPJEGKdZJDjggI2AKqMhFj5R4iMXVa9bh
         ZDmsPYunXfdRgJCXt9zVy9zi+K7RxnzjBriAcvLWu/xwNzaP4iZaoHa8yYMx36559G56
         rbhW7M8ez49Wr6hDJZz4rUVv1LP7yiAMa9BqF3C2glj8cCTY2CEg2RTZQrV7/dKCqQc/
         mvMf12rvwEuvbSG+mlN3ltqDcFU/jAxi4G+sgAtyMnVBaYPGX1F4uRAHBDwd64Ovavk+
         OvbHubVoYlM6Gopyz3bbhrxpdZG0Mh+bWyzfAjSZotdOJ815MkbUal+mFy7UpKiB4QrK
         kwkg==
X-Forwarded-Encrypted: i=1; AKwUvBzg1HIpXRBp/RWCjFgtLx+92FNZ+kC9CwGrNmWYxHBKAcjy8PCVRq7WEzrlUIV8zgxo/nmRM6tCow==@kvack.org
X-Gm-Message-State: AFuF++n8z8enp1NYahovrB70xcMXq3n4ygLENTlqE3cFsUQ2PxEEZ8cN
	g6io7ZPyNAnCwggtPquqdcFnpPR4+2eSCtEM7gr35/uAkSKeZGERoDo0hRIZajAQVJwRoRgiXSj
	3noaHQNlUB8n9V7IVX7A60WIYnBizI/Y=
X-Gm-Gg: AYBFou2yUJBk/bA+MbMHYWeLQpTYnmVdGwU4RAMriNyOOpsdd8lAW+MXFJUu6Pz2PXw
	qR2spyy0OAVlt0xgxZXfkX7r9MZgOZ+opaTa6hd/Z4ChnPDfmnoSIKrA5iKryKpMPSjEVU5Q4ky
	J2bzgo3YZVu1+cMr8UW35HCKNXIPVRHJnZ2KxXxInKjX0+tf6uspLSknd6nYDLksFaob5uQ/hiF
	jG48E59GPT59RdkIaDuAkzKpss901JDLKqX7RSpuovoZ5Ez8DvkI6Hxlbb6iQwck/amDmXoXJ23
	/TjtYbAIT5bav8QPF8mksuaGtclirJ8laeKFezS0cEhnVy5wP/4t0ozM11aougVO8EHANRFwUQ3
	UK6ykdl4e2rracZyyi21udiEcfKrnLVqGoF+L2A==
X-Received: by 2002:a05:6000:614:b0:486:e787:9b88 with SMTP id
 ffacd0b85a97d-4887177d840mr13033233f8f.53.1790376028069; Fri, 25 Sep 2026
 15:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com> <CAGsJ_4x_Q1Ku9r6zfC-K-o87juQ9JNQ8=OSNp+UZzW3MPtZXbQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4x_Q1Ku9r6zfC-K-o87juQ9JNQ8=OSNp+UZzW3MPtZXbQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 25 Sep 2026 15:40:16 -0700
X-Gm-Features: AclHuK_WmzhoAX4RwiO8DEbPhaD401c3m-YR0CkJYzIk_HfJAFpyJCsYT8nzb0A
Message-ID: <CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B113E1C0003
X-Stat-Signature: 1t1rnkghejynwfzhi734cco7d1wf5ii3
X-HE-Tag: 1790376029-707969
X-HE-Meta: U2FsdGVkX18tJmbVrA+cQui4n35WI/XdF9KFziX0myR/Uu1eQHmc1SIHJV1wfAy7c+yVZbqkEz1tqGXoioXUd7YhLnKR1t8RKQVMcoHfKuzaW2oqE9Jfv3r/9ux0cmbAzRxSg/kfcbx/Jfc5rR+AZpqorJxMX0eFMjHG+f1m3c4I4H1es1yoGQCYE9rZDMMPQNfA2aV7YTs16gq2ewt0tXtRsEDHl4L3RZUFUs7wq6NGgktO7HC+CA6dR2dCL8Cbz7HERQe+hfJzsCQiEK76oRNd0MBLTVLCwiy6CaXU1QUEBkEqEnQ5N1Whk2xeEsmo/Zf6Ai2gOiCX3EabhLqG1HY26dHr7JD/8GAm+yDWbwrsiBm7x7vWEX5rnEydtWl/+SGhOtfYq5u3vuEh8QlnV12TU+OnFqr5S47EAZB93qpBdZZ2vrXQfBFRbnNrgzDPiIWxfPHIM7z9i6DFW4wz/3N4FZSSVc7teGwD80GxUBj4g4KP/sXmzBn1J9gs71KdNexkUNL6Pd9bjpcQ22Ra6zICZ657+cKxKZmc61q5db4jLmVxF6WsLJussry8/S5UwVGNu9SWjCe9vCZhN8erEyCoZ2x9t4llWPjFNYVcAtxzUWcNtMNfkUJXYiENPuCMM89Z0KZh51maa0txXOGxSr7+7vmeMM+YrKVy6LdG8/srmsjbfVs99Da55+QUuyW6qYG+zTzBAFXT7Ex7BmOC5gsBboQh034hitpbwKyoYyaqQDoesV01rwM0KZhpBDWY1ctSOC6JLQBgtX3hu/goP/7bgYSALhj+1LDQleCWXi1xQ/ix0XJLTv+BAKRsPQyy/mIYXlJ2vYd1PxhusO3KCnSpg3legtAL4XQlSeodGl/7yeQxueNAzPI+/U2mxs5iORhiyfbZ7jArq4sjsxzqybI6Sw5XjTw9g2DE5+lyM+Ep7d4+37JHof1LbB1leOhVO93fsJGvuBzyVhkm5h9
 iuOpgUBl
 jIw0+X1KBDwKmUQAXaXtVzJf4IK3EWx6VJFa0TamfKfUxMeX2fWNWpqMM7UlW2mkz1+tDTe/bNfWwpuTY0eM4HZIUMrOzV/2yr6t5cuuQVfHXACXdIvVWjWsMdWUA0ZGJ4bJsvWf80fDADNlcbUXDqJ0458jZMC1Y4mxrkgTOQ8PfQ05T3OsYptfBF7xLCSqeWkiUJzlaKoGmKXKtgzRbUrg8107j3l/rbZZeCukVGyeEwC7BKdIW67RaZi+QMOFaOWxg2Relb9Cbo0lZ7/O30rX/e8FwbLUKVD7l0CqjcKRr3RCVydO3+nM5uM/Zug/IkAM53NveE03+0vHUOykIm0ZwsaPgBq3DNZTMDs81g9iI7mMMLi3trqoZqqWbecQEZoOM9BknoXcpzdiH4TWcegFe3yylSJjlYPXlsF5pFcuTlLd9/ngvt2gSTBvODMYb8ZKPgyxLztm/qa4Guf3c5Jsa+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:00=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Wed, Sep 23, 2026 at 8:44=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Mon, Sep 21, 2026 at 3:12=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 9/20/26 18:20, Lance Yang wrote:
> > > >
> > > > On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
> > > >> PMD-sized THPs that are mostly zero-filled are reclaimed under mem=
ory
> > > >> pressure by the deferred split shrinker, but this is not done for =
mTHP
> > > >> folios. At Meta we would like to deploy 2M THP=3Dalways on arm64 w=
ith 64k
> > > >> base pages, as 2M provides the contpte benefits while the PMD size=
 there
> > > >> (512M) is too big to use. However, 2M THP=3Dalways causes memory r=
egressions
> > > >> unless the unused portions of those folios can be broken down and
> > > >> reclaimed.
> > > >>
> > > >> v1 did two things. It scaled khugepaged_max_ptes_none down per fol=
io order and
> > > >> it queued every anonymous mTHP folio. David objected to the scalin=
g since
> > >
> > > "David objected to the scaling", not quite. The tricky bit is the sca=
ling when
> > > collapsing (creep).
> > >
> > > When freeing, I'd assume scaling should be alright.
> >
> > Ah, apologies for misinterpreting your comment.
> >
> > >
> > > >> collapse had already rejected proportional scaling as either letti=
ng the memory
> > > >> footprint creep or being confusing to reason about. David and Barr=
y separately
> > > >> objected to the queuing, which adds list_lru lock contention on ev=
ery anonymous
> > > >> fault, and hurts lower-order use cases such as Android's order-2-o=
nly
> > > >> configuration. Johannes suggested keeping khugepaged_max_ptes_none=
 absolute and
> > > >> simply not queuing folios that could never exceed it, which addres=
ses both.
> > > >>
> > > >> Read as an absolute count, khugepaged_max_ptes_none also implies t=
he
> > > >> smallest folio that takes part in underused splitting. A 2M folio =
on 64k
> > > >> base pages is 32 pages, so the knob has to be set below 32 for tho=
se to
> > > >> be queued at all, and any folio with no more pages than the value =
stays off
> > > >> the queue entirely.
> > > >
> > > > Em ... I'm not sure max_ptes_none should also become the mTHP under=
used
> > > > threshold ...
> > > >
> > > > Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> > > > collapse uses 16, while mTHP collapse turns the same value into 0. =
With
> > > > this series, an order-5 (2 MiB) mTHP enters the deferred split queu=
e
> > > > because it has 32 pages, and is considered underused once more than=
 16
> > > > pages are zero-filled. So the same knob means 16, 0, and 16 dependi=
ng on
> > > > where it is used ... That's a bit odd ... no?
> > >
> > > I very much prefer scaling over using absolute numbers as proposed he=
re.
> > >
> >
> > With scaling, I don't see a way of avoiding having to queue every
> > anonymous folio of order >=3D2 to the deferred split list at fault time
> > in the non-default max_ptes_none case, since any folio can now
> > potentially qualify as underused. This drew some objections in v1,
> > particularly for the Android small folios case. I read that as ruling
> > out scaling. The objections were a) the list_lru lock contention and
> > b) the limited upside vs cost of splitting small folios.
> >
> > For a), I don't think there were any hard numbers showing this is a
> > problem. If it would be helpful to have some benchmark numbers, I'm
> > happy to run a synthetic one (patch 3 applied (which adds anon mTHP
> > folios to the deferred split list), only order-2 enabled,
> > max_ptes_none set low enough, all threads in one cgroup on one node so
> > they contend on the same lock, each thread faulting in a large private
> > anonymous mapping). I'm happy to run something else if anyone has a
> > workload they would trust more. Johannes also mentioned batching as a
> > mitigation. If the contention does turn out to be an issue, I'm happy
> > to prototype that and measure it too.
>
> Hi Joanne,
>
> you may take a look at Shivank's report:
> https://lore.kernel.org/linux-mm/08f63301a58f0e0c38480553295ad9af95928da6=
.camel@amd.com/
>
> It's not the same lock, but the problem could be quite similar to the
> `lru_cache` case.
>
> The `lru_cache` work for mTHP order-2 not only resolves AMD's
> regression after enabling order-2 mTHP, but also improves overall
> performance. before that, there was a regression after enabling mTHP
> due to lru lock contention:
>
> "
> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                   Base       Patched    delta
> 4K                109.60     109.11     -0.4%
> mTHP-16K          144.10      99.00    -31.3%
> mTHP-64K          104.75     104.25     -0.5%
>
> mTHP-16K was ~31% slower than THP-never, due to lock contentions.
> With your series, mTHP-16 performs ~9% faster than THP-never.
> "

Thanks for the link, Barry! Apologies for the late reply, I was out on PTO.

I ran your microbenchmark on my machine to see if I could reproduce
the results above and to see at what mTHP granularity it stops
degrading. My setup is a 2-socket Skylake, 40 cores / 80 threads,
threads free to run on all CPUs with memory bound to node 0 so they
all contend on one lruvec, running 80 threads x 16 MB x 200 loops.

These are the numbers I saw on the base (unpatched) version from
running perf lock contention on folio_lruvec_lock_irqsave ("lock wait"
is all 80 threads summed):

    size                 contentions   lock wait   folios/MB
    4K                       1075221      321.4 s         256
    mTHP-16K          4203612      392.8 s        64
    mTHP-32K          2064073      190.5 s        32
    mTHP-64K           212012        1.7 s          16
    mTHP-128K          117993        1.8 s           8
    mTHP-256K           64532        4.2 s           4
    mTHP-512K           32485        3.1 s           2
    mTHP-1024K           4313        0.3 s           1
    mTHP-2048K            725        0.1 s           0.5

I'm pretty much seeing the same results you mentioned above, where
mTHP-16k results in more lock contentions (though I didn't see a
runtime regression. I saw that 16k comes out a bit faster than 4k in
wall time), but 64k results in significantly less. For mTHP-32k, I see
less time overall spent waiting, but 2x the lock contention.

I re-ran the benchmark with the 3 patches in this series applied, with
the khugepaged/max_ptes_none sysfs value set to 0 so every folio gets
queued (the worst case) and measured the queueing cost by switching
shrink_underused on/off. I saw:

      size                 runtime delta between on/off   folios/MB
      mTHP-16K             +15.8%                                64
      mTHP-32K             +11.5%                                32
      mTHP-64K              +1.1%                                16
      mTHP-128K             +1.2%                                 8
      mTHP-256K             -0.6%                                  4
      mTHP-512K             +0.5%                                 2
      mTHP-1024K            -1.2%                                 1
      mTHP-2048K            -0.3%                              0.5

which mirrors the same pattern/trend as above (eg regresses at the 16k
and 32k cases, but not for 64k+).

I ran a perf analysis and the delta doesn't come from the deferred
split list's own lock, but actually from folio_lruvec_lock_irqsave:

      shrink_underused             0            1
      runtime                     6.00s           6.86s           +14.3%
      lruvec contentions     4206376      4234324      +0.7%
      lruvec wait            406.4 s           485.8 s         +19.5%
      avg wait                96.5us           114.5us
      list_lru_lock           absent            absent

The lruvec contentions count doesn't move much (0.7%) but the time
spent waiting goes up 19.5%. I think that's coming from the free path
rather than the fault path. In folios_put_refs(),
__page_cache_release() keeps the lruvec locked across the whole batch,
and from what I'm seeing, folio_unqueue_deferred_split() gets called
from inside that loop. I don't think your lru cache series helps this
directly since it batches on the add side but this cost is coming from
the free side inside a section that's already batched, but I think it
should help indirectly, since there would be less lruvec pressure /
contention overall. I'm not 100% sure about this, but think it might
be possible to move the unqueue from the deferred list to outside the
lruvec lock hold, though I need to look more into this.

For now though, I think it makes sense to have a hard-coded minimum
folio size for the underused shrinker, as you and David suggested.
Based on the results above, I think having 64k as the cut-off makes
sense.

>
> >
> > For b), v1 unconditionally queued every folio of order >=3D 2. v2 added
> > an optimization patch for skipping queueing entirely if max_ptes_none
> > is at its default value, which would also carry over if we went with
> > scaling. So I think with that patch added, for the objection to b), it
> > depends on what max_ptes_none Android actually runs. At the default
> > max_ptes_none, nothing would be queued at all, so a config that sees
> > no benefit from splitting small folios would pay nothing for it.
>
> I assume your case is that you always use 2MB mTHP and don't use
> 512MB PMD-sized THP at all, so you don't have the conflict Lance
> mentioned? For Android, I don't think we would enable both 16KB mTHP
> and THP either.

Thanks for the context on the Android case. For Meta's case, that is
correct, we are deploying 2M mTHP =3D always on ARM with 64k base pages,
with the 512M PMD size disabled.

Thanks,
Joanne

