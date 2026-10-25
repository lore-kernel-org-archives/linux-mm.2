Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F34B606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 04:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sgDgkn2U
Received: by kanga.kvack.org (Postfix)
	id 554496B05B0; Sun, 25 Oct 2026 00:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE106B05B1; Sun, 25 Oct 2026 00:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EC66B05B2; Sun, 25 Oct 2026 00:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 019736B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 00:22:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8052EC04FF
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 04:22:21 +0000 (UTC)
X-FDA: 85359851682.21.049C81F
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CB4E120004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 04:22:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sgDgkn2U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792902139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
	b=NiH7ZtcqUWPdRqH4pvDyjXC0vmakjhn9Rxg4RXyyw0FWXou8LHvDlTW/znwtgbgcEGdtgp
	LwtAsqpVznBJPGn0/gYs8OCnfh7RxGaIf8PWDvhBBOCKjqpe5yUI1SMTzRPbX5KdrFPUEZ
	CLP22Txmb+cjoP8fnaK5XPFp3MSrLsw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sgDgkn2U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792902139;
	b=hW99xiAsRfFvAon8aQsa9ocP1dVaS4ZGy3QmKuhmR34lULo360OScOulMU38b2ix794tGV
	DnVU6uOYkOxVCxjir8yxdkwnWNaS0MsiR81VDL/9DLI8woERAR7YXt3tjwxRXE+8hkOD9J
	JCqsDcuX8LUp9okyff8OGAQl77/RDu8=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4395d31228so301748566b.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 21:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792902138; cv=none;
        d=google.com; s=arc-20260327;
        b=l/16RwbPbMLSGd8jcvlIm+dvye8FKZy/9awyxyXWlraW9Aqi6GMynMAZzyXWz0XP4I
         qAW5qM/J0Bc57uuUfPt9+sfzPyw2uzOd6QleOt8YIJlOV9MLa8eELQQjsRg9N9gib7m5
         5lveI2kyVAb3HmasDyUzDZh/MpEhLQhq+QzWh4JSO/vkzU2iWhZWMCpxsVdN/tjJ/nma
         c2S9HZg+6Me1KS2PA3gQu872eoyXKi065ySUjIcsSp3kYwZVSeuHi7efA45n/xTgyk/J
         CakgoIMElta2HjnszXKAGGEIcfKYLSR6CIquk5tDiiy8hr24EwEBLroy4umw1ngPtjJs
         Dl+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
        fh=LI47jyXAlMgRm6/hx90U8trEHd09UV9ImoXKu3B4X7w=;
        b=GHAZUv8K/uzsRCN4brmUk6rK5+KFQLIbCPADlOH8fyt8bGO0BdUotk0vVypAx537Xh
         9yIg1c1j2Hm3iNG4kVoGvr7uoKuCOsyd+Jr0NL4swbl8pQZ/4bLAqJOAPvWh1xNi5yju
         83y2/0pzh5G4k3Krw87Pm9ReDfKe8/IThwIeEYkUbJDijiiCY/ZG2lFfSyZYOOn0ZOu/
         V2Ij4/x96kwHcvshZ/TWJpaB/SQdRMC5jvLDgNym/x6wRj4dqkYNgVe5c2UCtMOS0zB9
         AZt4pdXXwUVd7o8qEU9bELYOqjVuoGCAxT3+PGhtL2GHJ6fAL+VaDuMoY4NZLJ/kJs8w
         Hy/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792902138; x=1793506938; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
        b=sgDgkn2UYlK2WL88sj+wZhGOIZABe0pj8zig5I4JeWHGX2/bSQJSBV/l1BTZFarzNy
         zJW7pRSHzhhuhlnXmHYVqoADX+ndiJzAmbq/6p3IHCmMFugL0OgUwdeiO+VMZATVtzy/
         BeiDFMXPokJiZG/9+W3NtEX6K6cqc66myq+v9r3xwOh/0Z+3W2dQ7YbaBa3DfOHF5bLH
         E8IxIeqtcJKVuDT56DOKB0NYBjbUY07elirL6C0p4YFR4Wf/Gmv74B5ZTvoWgTvQebRn
         BVyty5XBWrQw6CU5lSPMUqgxCsCRj+6ITWI7lNYlZeHDSivIewFwsPRPdr4Svh8sT1fK
         updg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792902138; x=1793506938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
        b=poHx2PO1IJ6NfXXd7sfHo058t3aQ0xeVKuC8qKuMdreI4IeYJHnWMZCjWK9Onh4uGX
         Vk/d6n69HlX2BAaCbROCaX+jzEEE4BFmJT/HAmyWPerEj3tsiKIpquZ7JzCktztXgrlJ
         gKWUzXltS8b2/XvMZcjA1N2iCpOHEKC8xE+jGbsRUvS83G9cJP3f7+dSJWkF51/TL10i
         qL4drQGjc8I9tt32OB8RJ+IOPKDm/tWfAzDl8D3wUHTEQaU1Do911SVALmMFDa4pul91
         0d+xs08Bh/bLzwKFmtAAiel32bTH72yy0msvrUhb5xCK2jNMaBzQdxoDYWswGGHLWWz+
         kT4g==
X-Forwarded-Encrypted: i=1; AKwUvBzrwJ4B0/05LcbxhsoSii0XmST7ccI1EqwJO4OaO6yuOPaimyD26wAgCeXRFbh5CwPTY3YTRbzFSQ==@kvack.org
X-Gm-Message-State: AFq9FYKMAzQ5hc8VnM4EHtB8nZHIt6usXEuUm7PNZ7aTE+odCq8kiq6I
	XcV1zurUtz251O01WD0WhzNSs3KU/gaAj3u+uyYGqEZ/7QRrvpsd2iewAH6QucTjMT37rtAOQFI
	9RP6enZOD2TBXg9HJCuw6sDvk50d/MEM=
X-Gm-Gg: AYBFou3fLA+T6rLi3YWqYNv+fUotpDI3JXNMTJsglUKyNh+cbgtapoFIvMgI/9m+SjW
	c4T7vdc/DLon1WYvCN/KXCjpXGcW7tHZsWxjld5v+86JULhm11NvxJZuWYRns76DkJQxZvvF0Ar
	LtmqZT9Xxzp3zTMDmue2HzlVMa+lZ7J4GVXcj77Yu2UEXA0DDTwSMBJSZ38DClV590I6rubEb+C
	no/Ho24t5NxkR8n3kMyoiVuCNwEVcZNCuaB6unVPu69+ViZXQPmm1fkkbGzNH+mAZDLbRhDHaCn
	T25DkZWbK+bAAt5vE62DFN8JvmI1T64viJMR98TNzyToyXkMHaWRGcnU36OaArvcwIGBqr8S06Y
	4J7lfDnF+wkdzFeVYJjhdTACMVVCkyZNITI0/BwZW+iJzCngvIp1oD/ToNIau6m5hIrqDBXS54L
	J2mT5BCmmCoXNMphk=
X-Received: by 2002:a17:907:a0c9:b0:c3f:153a:8649 with SMTP id
 a640c23a62f3a-c46bdacd060mr422491666b.7.1792902137803; Sat, 24 Oct 2026
 21:22:17 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com> <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
In-Reply-To: <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 25 Oct 2026 12:21:41 +0800
X-Gm-Features: AclHuK9AJB_Ij_SjIfwwNYU3XIUY4vB1BJ41W2msTZ1ne8yK1FWjUOt9jpj91Ss
Message-ID: <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CB4E120004
X-Stat-Signature: 743fot6gyi6bgnbhhwejyu1t3kjearqd
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792902139-876732
X-HE-Meta: U2FsdGVkX19JQ6TGiAzB6A1T4BnVyqL8wIEEMsTepKEip5qQnFNZFNsX3ATPuvHJ1WknxHLjbhu+EwzbNNBAWwlNdQd6W5uvLlhWjyzFZEQHVYil9rJ1L4z/QhEYhfir0w4WT8Mob3YFgo+ldIu8pHTgYtJD7m2XxwIcYVixzBGp16LKm1rpqRGg5y/Jn5LvnGcCKlT3MsqJ9mvUPmJoE10fJSCgpU8n98Vq+1UR8Ov+XyN37dh/cA+J22kutbuGWmjkUtHcjb8KHK0gM4r/PeiBuQJHxRCriAnH66zHjlhWvIjJq+OrE96d/8H7wlirZjaAs/RBwZKBd/qmTo6tz0T4Fcvwc97vD620nw2Z+LzypGhtBF2W4r77Ue8fcP2Nmka75fdo2mXvgr8Sxq908cT8AqUHOk2dWW773ClrKpQsAIY4+XUYYww5mcmxZJKkc8GmUX8G4ylDZ3EelHiF4+KeghBlsG5yfjLIfinRZz8Catox3vcPX0qTXoc0x9boayag2aCHWplvjAUefnE2NRotKbMlPLm0nPqdgVR2ghfneIIDxhKzIuicIKg5w4xoU/ZLjOhHw0bdjaTkc8XaSYIirP2SPkCwozDlAHp2w49xLZjm4yXGuSZQDcmlXKDEg5GlGwb2EabBDUKhIFsvsrkUaxuRJZXJvTv6x06MfKLyw9qWrGXiyAJFXJKkvkvqIqEncLdMsChA5lZppKe7xVbv/qq2x/PjLwfynkVfzOGwfUIBJrs8+pvNaf8uoYXN7Zpq3WQ641XPkaFHXPBX+iiVKfx65QAcoFgKlp48cqVgZrpAkyiEf128fVOr+H9gItMzN7A4VTs+3AVGhFkt/47hdohWmAlE+LXrIRLpdAWNH/Lcsx0nEcFhpCXX6GbCm5lgM9AB1oKdzQUmxkPU91toZS+dsAuSg2NL7vVb+uq0VgZkvkUtp8oOow4KM/+3LVYdL7l5NtVO/yGOuoU
 mo5HmEAN
 jTHE53kTsldwif7TJ7bXWWfz8q88mtXeQne+gNACHkr0wD/1NOEIXlhSOD5vkeFFFRZ+pRpGQ0wU4ZT9sQAXNPuRlcpeRVToNm1KSlb+W2TjCLyyPkxZJcMlPlEGd67EBbbxCkEqCCxB5RbjsjqH+oJnoOmYxc1RBYo0Si6th8PRlY+RP9fxICWrjMDXKngxYdKrwKoDe22noZaMqXF0PRPzkF3Ciz1ErM7PPaZ14EyGGm+FPWEwLj8lXHEKykoyq0UQtbKsfdK9YnmK7Br1XCR0IB1gRsbgWFUMj4ag+0Q0yU1pZ3dZODnP0vAes8siGy3DOrGE+lSj8BTvUD2tLZHZ5rhI2ZhTQDjCRBxHc0hjvGXx6jUoIlrEjulaL/9QW5LhFcUWMI9aDpLIUKSTgQCSAmSbVl8eE76Xahnm+qQDvLYEH55QdsjMj+n9q70jNKc3EJWnHGJUI2E4aP8ztfLxJy49x+ezcaj6Fe9TD7+CO17g7eoTc1tEv8+80LnRG0XEMoImhU60yX4DSnnxq1b/cYrxu/RRhW/kB7FzuvaSKfebeK+FRwKWDXWbMJOaDB4QfCiu1NHJ4iLJzwMNmhOAJA7p4Iu3BS+3dqahx/hxQA3M2/CJIfSvbUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=97=
=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> > > >
> > > > * Swapoff: this was brought up as a request, but we ran out of
> > > > time
> > > > before we could discuss the motivations and use cases behind
> > > > them.
> > > > Folks interested, could you explain as a follow-up?
> > >
> > > This is one that I really don't understand.
> > >
> > > In my mind, we have vswap sitting as kind
> > > of a swap VFS between the rest of the system
> > > and the swap devices:
> > >
> > > +-------+     +------------+
> > > > vswap |-----| swap cache |
> > > +---+---+     +------------+
> > >     |
> > >     +----------+-----------+
> > >     |          |           |
> > > +---+---+  +---+---+   +---+---+
> > > > swap  |  | zswap |   | zram  |
> > > > file  |  |       |   |       |
> > > +-------+  +-------+   +-------+
> > >
> > > When a page is unmapped from userspace by the
> > > reclaim code, it goes into the swap cache.
> > >
> > > The vswap layer then decides where to store it
> > > at eviction time. This is configurable by userspace.
> > >
> > > If the zswap pool is shrunk, the vswap layer knows
> > > where to put the data next. There is no need to
> > > change page table entries to indicate that the
> > > data was moved from zswap to a swap file.
> > >
> > > If we decide to disable one of the backing swap
> > > devices, the vswap layer can just move the data
> > > into the swap cache, and the page reclaim code
> > > can evict it into a different backing store, if
> > > needed.
> >
> > And in this case we want to disable vswap itself.
>
> OK, so you are looking for a way to totally depopulate
> the swap cache, in addition to swap files, zswap, etc?
>
> I think we can accomplish that by simply keeping the
> current swapoff code around, which scans through the
> virtual memory of all processes and brings the memory
> out of swap.

Yeah, that's the right starting point. The scan itself can also be
optimized to be cheaper or better later on, but that's orthogonal.

> > I also hope there is a way to release swap metadata completely too.
> > e.g. for fs, you at least have umount, and can rmmod the fs itself
> > afterwards. We also have many ways to bypass the page cache. In cases
> > where a virtual layer is just a burden, we want raw physical swap,
> > and
> > the ability to swap off that too.
>
> The VM cannot operate without the swap cache, though.
>
> That is very much built into core parts of the VM.

I never meant to strip swap cache out of VM... The opposite, actually
:), most of my work over the last couple of years has been about
removing the paths that bypass the swap cache (e.g. the
SWP_SYNCHRONOUS_IO fast path), to get a simpler model and better
performance.

What I'd like is for swapoff of the last swap device to return the
system to its pre-swapon state: no leftover swap metadata, no leftover
per-slot or per-cgroup data or statistic, and ideally no residual cost
in the fast paths (e.g. minor fault).

> However, having swapoff remove all data from the swap
> cache, after mapping the memory back into userspace
> page tables, seems like it would be fairly easy to do.
>
> Does that meet the needs of your use case?

Right, it's nothing hard, as long as we don't add mandatory new
layers. For very high bandwidth swap devices, a mandatory indirection
layer is pure overhead. I posted a per-CPU queue based allocator for
that case (https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-resen=
d-0-68d3d925578c@gmail.com/).

