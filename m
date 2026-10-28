Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAC0606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BEWlXAEY
Received: by kanga.kvack.org (Postfix)
	id 384B16B05B1; Wed, 28 Oct 2026 09:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B146B05BC; Wed, 28 Oct 2026 09:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A2E6B05BD; Wed, 28 Oct 2026 09:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06EF46B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:59:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B85EA08B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:59:08 +0000 (UTC)
X-FDA: 85372191576.14.130D713
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 986F918000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:59:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BEWlXAEY;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793195946;
	b=A2fI73VWTu6/xVXALkOzUgURUAyMH8F1wNS4bNoZ7aBwXmAbA5L/EpyvryxLTCwjNx0z96
	8biiLYDbSqNDO+fFC+iZDiRPpdSsPVT/LO2wC6r60PIxjuvDf/R6qXh684T5YC/x4n4Gam
	RixcDX2q2FlEvMKjH1MgJEU0R1rGmy8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BEWlXAEY;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXtekahorzOsjNCbZ4FQcmlw+T18WgGmFphrz4/AcQA=;
	b=dp6dWpd6cb5Yd3iUN08i88aYth5zYlLo8DKrXxibOVitn+siGV/GMAHj5wKrS2k+joOXdc
	X9hhx3RYAgiDoT5Z9fHIU2dIRvG9/H04bKS4eMN5yKRCnWiZig6U1CxNV8ShiJsWJgDpvR
	Mo8LMKsl+Ztzv3JIYRk1x9y5wA+3X4I=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c45551fa84eso83545666b.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793195945; cv=none;
        d=google.com; s=arc-20260327;
        b=NbEjvuWtbQ8nc7dxwZAw54jU8+uAi5oJkOFdhqLT8DFAAVzpxKm8rITeaB4ffy8rxM
         sUrnFxf6Ijy1h5jq35vYjaCTavfc2qI2iuSEPqv8moENGPZpmGlrszHFpdm3YFR7DUY6
         52vEP0DFd/THPh60tyynwud3J3vdJnwETyCmp8QyX/IihrRSr7lBf8GKPeWTgEbS7Mfg
         j/YNMdyqzV8HkrcXU9g6RiNJx6+fp0zkrl2NLW4T692QxTdkGP9WUsDASXHXPUMbQz4G
         Jx0Vom6Lrl/pHc+6tWpOxwImhj9OBeTjzQ95bBGYEIfmA+EBGlgh8/D8kDUlPvkJfVzW
         uqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MXtekahorzOsjNCbZ4FQcmlw+T18WgGmFphrz4/AcQA=;
        fh=38oTMd49ln4Slt8LgUXafQPhVSwS4/YwygPnNhrB8sY=;
        b=LbRCRAvGa/DJ9Qn4tAJzGFpakQE5ibiFZy+orrW2TkVx8lvOs7ffgHp1IMtoZ+7S9+
         Bb7LnRMQB8hnhbTt8UPqvxavfKJTDZbgKcWXqsO1Z+89Dl6VIsk2o/VcI5xqD0/VWd0A
         IsMscexB2ArTp/NDi1ssz8SIwt1Tut1F3mwEUkr4ChAukOKDYTAPy+mg+l+lcN0If2h5
         V+gCtbM+nM8u2WyraQzpSopLAF2PWxwCZTJS7lziMbvbbBhMayJ4vd+IE3PmAFV9RKhN
         IOzC3YqxAHdNvpgQ5xAXI5WadPWJDaxpak+VyXU+9c67FP4xa16L/NTHSXQEwY9hbv2Z
         t2hg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793195945; x=1793800745; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MXtekahorzOsjNCbZ4FQcmlw+T18WgGmFphrz4/AcQA=;
        b=BEWlXAEY7GAfSSMw/087cMsIydFrDl5MBmgRlQHc6xstjmSFNc4D2HGhIent/g9rTt
         p6JsqVUYRdScFWzjye/ArGTDwy5Utob1Nvsbu5QsAem+KzfTDusti/mttlUauoRPW+Ff
         gCWem8tIcQpuT81VP58Csi2T6/Vi4N9QQ+uSO0RSehCfIwndS02aKbeH/z6bXc8kuHqL
         VKiDbS7wua4WTzXt0bfREncNXfAcXsQeR5kUXVK8/K2A6CjrXqNxlA69abERdTBiX2NN
         D8gzNu4+1XZlkTP2VzzYESN6HyvkupXYSEU68KGzW0wmqzZczwSAidv7554TpDv52j27
         vFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195945; x=1793800745;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MXtekahorzOsjNCbZ4FQcmlw+T18WgGmFphrz4/AcQA=;
        b=n6a8/WxqNHi69XR26TzEzUU9A2pCjg9hco88IahXKHSnPGBUp2Hdpg1P5LDSrU/R2E
         Ln6kJbuEVdEVawzJ2dkMy3DwZ5jDywEPCMqikfEkZbTwxnUmWu2/9CoQxAszS0nPqOsl
         fckJZJjYeCDseff+xlX8VTgu8+WLgua8cPdv3PpArR0j0vvsMAPh0wgHXrLCZmML3XHw
         UV9rIs/q1zYFi+6ctVtWF0ArT/zkCfRvNLYOoqpV/QoHI4i1WTSBoEn+ZijkbRgNY6b1
         ZWcN4nGW9+jjnNlMtajmw5gzI8rIdnNtZoACbeJdEyoH64MuKU1tXQs72uazdqHKgpq0
         +N0g==
X-Forwarded-Encrypted: i=1; AKwUvBwKA+tPbHq3EkxsIVxKpSnkmVS6T7Nie2HeYS5Ztekey1AE/YD4vKkWlqoLFCqwC1OkGzChg2JO9Q==@kvack.org
X-Gm-Message-State: AFq9FYJckIEg2wQjpWR0G0m0vszkqBPCaFo/aQ0ylnywUdEWKxJ+qLNC
	tlmn4tmoGCJWgBeibk2I2Sp1zbN4ulXbeh6CK6m4dAqClGM90uSXZ4XEyealZ+Qccqeuiyd59n+
	WqrWAeAlHYGxpsX72fAjN6APo6h9en1o=
X-Gm-Gg: AYBFou1ZTF9XKDhMxm4GadEnPBxkCHwoWPKq41qsqfcjh7RPixk9l0+SZemdpf5bpdV
	WxwAtx1qouKJ19/A8SzAgue69T/KErg5KvL0/GX9i6eKDasfSmfPvLc5eW7CByDqCRhVFNylI8Z
	CoR2cGuLhGUciLzq5wZ6AVAH54kfQG9TlUBgkQ74+2efVMEPqbxtCvoODCXR74Pr+E5+5qlS/mj
	ID6D4K+0X/h+rJqILWQc2NAJdeNA36H34+l1NcF0iPZirKk3rjn3LkniwAyY35xgSaiqcyB9YzR
	E/UEzARKxnv89w+AmP37TZnpauV+b+rcm83tt2WjX+aRwgvdPnVmS7ImjpG48Ktp8AYIEZaes3x
	mtL2pN72SPpwiGzBio9SsfYIMTV8BLItIU/zOGBidfvsJJ9cM6+2guFmJY72QZ/U5DoWtXQ==
X-Received: by 2002:a17:907:d1a:b0:c26:1648:a062 with SMTP id
 a640c23a62f3a-c49bdf32adfmr219095866b.29.1793195944905; Wed, 28 Oct 2026
 06:59:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com> <CAMgjq7CcSxNMx9UxVjjM=W11fhd8sh3PgkHKt2kvdah3fy6kXg@mail.gmail.com>
In-Reply-To: <CAMgjq7CcSxNMx9UxVjjM=W11fhd8sh3PgkHKt2kvdah3fy6kXg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Oct 2026 21:58:28 +0800
X-Gm-Features: AclHuK8kNJugcrvL3BCcn11H0oNLCsIwQIynOZcysJvsIYXRWGdp-kejpft0XcE
Message-ID: <CAMgjq7CAnUh84ZC3iR73s=1iLGJX5HMj9QqL09tiJX51MX7-sA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: skip oom killing for high order allocs in kswapd
To: bingfangguo@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fn8r6ocwpyey6yingh6dwk9sbgw5y14q
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 986F918000E
X-Rspam-User: 
X-HE-Tag: 1793195946-473417
X-HE-Meta: U2FsdGVkX185v6FffEUghdRNfKtkJizfnvWrYLZNPyS+PAlvxpG+wgFwFUJg75P2MyQJzWBfqqSMwDxmK8wAH+3/N2bctJ6n/S9AAq/WSosoM7/gLXQS5gqyKE1GSQbYtwDXM9Ouvo4CB6a4RZ0/pV/P++6OIfdqzR+KaP7R1l3zmncGBxGNie+hev/xjkM9N/dYGVqospMISxyxfOwvl7pBLb6eaFYuLbqHxPP+xYLi+yuMMud0f/BHddOl4ersHl+WaqsTh/U0P8cAmF8qRF9CnyFBBValZuKpws1tcp0yxu43GNGrrUDQbWFiUxeTa34LZBTV1Lj2/8j2a/3pO3mM4dCTDovlvZ7z9CG2rdMFCAEOGUTCHOK4iJe2MFnvZqchzTRQ08bNc2Ki4H0UmJPNPVejREI8uOYndgcdq7zY4UGKKxDc1tzA392bJ+RQlEgUrREY0Crypde0kcefFhUujVWckGC2ARZa8h2d58RUnoxC8ZaOBoVaRrTSFIZWvTtiI50LU3X+pUmJ0Mhl1aM/iziz2tyL303yCWo/LvAEoHacrGX+aOHh+7i+cqaeQewrvIHszJkhDD3KCedx3YHPED37NsUNs9biWZhJRFmsbEuZcv5nU2q2FneiZOkCRzE4aSt2Qhxjinxka2dcqL/XSz2JuSGwzg36VFOiX9Z/PL8VNKGwjquiKln0pTMCZBxRZ1lFhCTDslyvm6nxgjqdsI0er1DiPzI+azixYk+QmYkEpPBuq4ND3SL9/Gx2NT/QrnsGbbirTiclhHrEQNBbHKe7QstUzSu7Jb3Tj+wcw/jHRY86ydrv9Kg2eBXYQbJroD5AOGknht2CkMU7gaQ57ZHY/LcDrv3MB8+3LEdj4IOd1qKTvG53mne6WJXlla7C73ltUp9UT4fm3pImgihgwr8gYn8zxK078/AjkJXj8Ff+yojR3tqAW94vXMnGUo8kPiTcA7cmDt8Xczi
 qEufj5bf
 9nljwGlVMzdjD6/8Orzz1RS4nA6S37znclRGUKcBzNptMz8v3kCqfpLO3GSOFJvcQ7LW42m+KwT142gOK5zRr2i2jmCMEjbn7AzMaJgPiNgyBthRu23bEHQEHmjaVeddRz/DIeaTzEoW8j27rKLKKIIcVGVFZE8CN/s3t4lnzwpE0AUkfoBkrfXr6Onv1sigTWQUqJQoJApSoVkkrFSWfkmbgBHkTxxdpb5OCM9DyNiSfkJYFsIsYyB/K8cTUoY5NJYNDd9HgZkdlx5LiqNgFZQowsIehOqiJsvrQ6fFl5XNJSL4g7NXQ3MN1QBSQ08lCtKug9tg+iDQizUJWJnDovUIVlsWAzrClBZbMB3KFDbbBg/V0+BoD8EOdPGehdQvG5/E5nzWVeXswREyLX43N2eXQWGPBXPwzaBnbQ+x7yzdjzmA94LGqjlHjqE9yXyCu4TNQBKD1vcZCdJ5N3cmb/7c5tI+GydpcJKw0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 9:56=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Oct 27, 2026 at 10:21=E2=80=AFAM Bingfang Guo via B4 Relay
> <devnull+bingfangguo.tencent.com@kernel.org> wrote:
> >
> > From: Bingfang Guo <bingfangguo@tencent.com>
> >
> > We observed that when MGLRU min_ttl is set and the system is highly
> > fragmented, high order allocations (e.g. order =3D=3D 9) will fail and =
wake
> > up kswapd. It can not make any progress, while pushing generations of
> > memcgs so that they all end up younger than min_ttl_ms, repeatedly
> > triggering the OOM killer in lru_gen_age_node(). Then the whole process
> > repeats until all processes are killed and the kernel panics.
> >
> > Fix this by skipping OOM killer invocations in lru_gen_age_node() for
> > sc->order > PAGE_ALLOC_COSTLY_ORDER, which is also what the normal
> > allocation path will do, to fail high order allocations without OOM
> > killing.
> >
> > =3D=3D=3D=3D Testing =3D=3D=3D=3D
> >
> > Tested on a VM with 6 cores and 6GiB of memory, HZ=3D1000, MGLRU enable=
d,
> > min_ttl_ms set to 1000, and a workload that fragments the memory then
> > allocates 2M pages.
> >
> > Without the patch, kswapd kills all processes and panics the system eve=
n
> > with plenty of memory available. With the patch, allocations fail but
> > the system remains stable.
> >
> > Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective protection calculation=
")
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/vmscan.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
>
> Thanks! Really nice catch.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9959ca158ce83..b32777468ead8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4407,6 +4407,12 @@ static void lru_gen_age_node(struct pglist_data =
*pgdat, struct scan_control *sc)
> >                         reclaimable =3D lruvec_is_reclaimable(lruvec, s=
c, min_ttl);
> >         } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
> >
> > +       /*
> > +        * OOM killing won't help high order allocations. Skip and let =
them fail.
>
> A nit pick, OOM definately helps for high order allocations :-D, maybe
> something like, the OOM kill is to prevent thrashing whtn all memcgs
> are younger than min_ttl (and maybe merge with the comment & check
> below?), so OOM for fragmentation is definitely unwanted.
>
> > +        */
> > +       if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> > +               return;
> > +
> >         /*
> >          * The main goal is to OOM kill if every generation from all me=
mcgs is
> >          * younger than min_ttl. However, another possibility is all me=
mcgs are
>
> This patch is good to me on its own with a nit fix above.
>
> And checking commit 30d77b7eef019, you might need a Fixes: or maybe
> even bring the check back which was removed in that commit?

Oh I noticed it's already there, please ignore this one :P

