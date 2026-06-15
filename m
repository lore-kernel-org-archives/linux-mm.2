Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D1DCD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 04:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507AE6B0005; Mon, 15 Jun 2026 00:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF766B008A; Mon, 15 Jun 2026 00:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F59C6B008C; Mon, 15 Jun 2026 00:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFDB6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:10:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B56E165C1C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:10:17 +0000 (UTC)
X-FDA: 84880819674.15.CBCEFF0
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B85280004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:10:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kCBkhTt9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781496615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLKGUqhqQ1vZwTsHa4HAqlBUYr7V5S3XZKe4bVT8MW4=;
	b=UdQlDh1Z/e7pz+ffDFr5B5P93StW4df1Y8vdB1bY7bjGHWRTlacJ3EfVMWh4KrvpIwZjda
	82LI1Z7XF2Q8UCB+UaxTutiWcAGi+ZWDs3KJW+D7gLO8TAFarC0rW+2lybvdOTv05Y1BPE
	A4yO+/FimwNXCvwWIaHjUjT8+0kT4VQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kCBkhTt9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781496615;
	b=BhryqkxanueoUEifhbINJiMytGE0jGXUmnkwiPDEY5LyVpSNn7v26Syvs2XB9b4jjj3FhA
	3RXiaAyPZ0yrgYGQIEAH3i56fk3472N7jTz0KsBDTFpp3iF86J/aL74igpez6cBGUvKEV4
	5NhdJFj2z2EquNbymRr3DX3D8J7oqlY=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5175d339e8bso812241cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:10:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781496615; cv=none;
        d=google.com; s=arc-20240605;
        b=S5mcyXuUOwCrQZEShxcs2QU3Lo24Dnd3akRofR3HaTT5Gy2VvY6+x6aHcDmiYgJGOX
         NdNK7OPpGAbcO6eyXduOQzJbcWJzzLYWoJZ5TaAKtpUvnK+IiGcKP/mF/nCJYqRmQyRa
         e8jG1CD/Z5uGVCmti8eYtP/+OURcLIf2bjrgiO3PwBPtHmFwI56gZE8MFlrp6Ttr1y91
         FBQbhBYXXBWGqieHzzaNwOd+lpYvQjT9RqeHVgXWasvwTRpTlrMx7PNOmPKHfvwoArhd
         6Fx/h8r2sL2tl4HXjx8DvHdwFK/H/gzzy/1yA0lZ0WjULsK4r3lXJ6HBQ9UdWh/YCzQp
         ECcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iLKGUqhqQ1vZwTsHa4HAqlBUYr7V5S3XZKe4bVT8MW4=;
        fh=1RdOQxRn1ZpWn9jDivm4MwdDtDWaYL7sTm6j6dZbz0A=;
        b=FTPYNrQg/o1JZghd3IHITHsgye2UZ949BDwb57Hssj8e4m0pqr7XLEO4NEzVvIrMpt
         /q2mJWNaAdzRo0wDyOjm5eMWtPZYX0dS8tcNPDxFsjvSJ1SWx6k56rxs8XOjvSgm9UyT
         ckSG9eNuSuN+mRsPKh3dpCdUxRIQBbrPe1IQxNOuh8QpnjgSrRoQZb7HvTDdycXFJ83O
         NgtXgZiSZGp24DbgkQcfjoRJTAW+SeilAMX1I3hiM7WQZukc/9zRmAQV4B+IW0y5u3/d
         LZ5ityDb5AKvXf+THjTRuNymQ9GqNXxaOgtdk+0PG1i1OiQ9dBBdojQVTaJIzXSgsSbl
         CMNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781496615; x=1782101415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLKGUqhqQ1vZwTsHa4HAqlBUYr7V5S3XZKe4bVT8MW4=;
        b=kCBkhTt9ddhBkaktW8i0NN6vrmZJbOTKsz0cQwGJLHjtNDrIq/P7u1hz4mU0evk6qC
         B22S+BRjWMOWtY4ER47MkwGxnixTJ/X4EJDniHBGoYvScVNAllmUlqLR8/H0xlZftOXf
         owe6hJyPSwjwlijh3B/fpcIVUs/w4mQon8G4C0g0Rrb3oozY2Q8FIKVw/cVC2kcWrj9K
         eYicPj7C8eE6jF8XBiKLAiMOXOXaMcWEZVKWkPe89BxAlybrATZSv92k/L/DqwsC2wpt
         tH0KLLLeMIQW+1DVuen6ktm4b8GLzcJrS7+maYnpTTRWwb3KzqcH7N9k3wk18XJIMotp
         tgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781496615; x=1782101415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iLKGUqhqQ1vZwTsHa4HAqlBUYr7V5S3XZKe4bVT8MW4=;
        b=K1NZF3i7UrntaoraSa2pNAs5Shqy6vvn/ezefUTavCL0B9A4G/0qPgvAcqJPb8dh5j
         jxQHN7zIo1NCcaqL+KTHXJzTUNf7p84f/PLjUAVtYDqTABkny5jleDEM6pnZDvS/L3BU
         +i9jpTnLnti3XLfLVLyFIugO8Z9s5EvxW/VpAlOF/UL2fZcdsrJC2I2Q1Sy/K4ScDu8s
         NCoWNgWNHdpYGLRsSObxt4m0YZtwYWvSAoSWt89RR8CNmxAzHv4JYxkpelxMMZNrSLTe
         YtSBmFxwIiCX13GYSO69OPXRPlXuq3DmY1cKETvg1jyUlm9/zihZQPvC7cbtiPSPU0/9
         ipeA==
X-Forwarded-Encrypted: i=1; AFNElJ9NI0Qd2P5GXZhVF3cDiAHn46ETEGsbesbi/5c0lI4lBoIz4Wsn1Ah734RDKc73ASH4xlF82/ZPiQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3/SK47yDLzikkNwr/Jys5eiQGt0wg47ru611ukuTlmtGXwnwD
	ZyRhmQYSG1cwkJw+CDJFfh2m9TTTNmXBuvz+5tvE55B8zEA+udqo8dNPpvRHd2kRFzwd6wA1fgS
	4FhfCF3jQkaGM9XFyGOtEYyV4YgWf+6CILIx3Zn/B
X-Gm-Gg: Acq92OHBj4mTSvOl61tHkrCJIkgQFE1EhLWBU8v2HJBDfKp5l19UqtswSoDtcxi+sch
	yuU04Wcx581Y802WzmO2WnGTaAJmO/3yE4rlpDv3uniqjZE3wKhu4m8tnlgg1I69tvZ/sXMYM8h
	AJDXo+d9FQDmxXKUy1mR5pDTtEG1l/0t+ek60Lozh8TSEV8zXledNYaBs8zIMaNXsf7f94SNrFE
	7THqhuFxj3YZWzFkt5Bicah9G+Fj77yWZl8Xc9hGnePTtCWvFY4TFplr+Apbd0vADWSRJxQc0SH
	o+896g==
X-Received: by 2002:a05:622a:1f87:b0:510:fa1:73c5 with SMTP id
 d75a77b69052e-51954a9c4f9mr13307001cf.16.1781496614188; Sun, 14 Jun 2026
 21:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org> <aiuX6SRATJoaq-jH@fedora>
 <0546df1f-616c-44b5-8a1c-f96d5f33d8e6@kernel.org>
In-Reply-To: <0546df1f-616c-44b5-8a1c-f96d5f33d8e6@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 21:10:03 -0700
X-Gm-Features: AVVi8CcO41aAq5lFBicCgK1drW-0d_MEvn4CW4JK61tK1r4R4tO2C0QXI1U6dPo
Message-ID: <CAJuCfpFSv64mOvJ8PsOaX-ifdRH=HXPYtOE1iy=SPNRiGKKMSA@mail.gmail.com>
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B85280004
X-Stat-Signature: p7qy597tmfdoxbd15do81kr4njpt4dno
X-Rspam-User: 
X-HE-Tag: 1781496615-483911
X-HE-Meta: U2FsdGVkX18w+G6PJvqFvwIXQSIRS+3Ck6DcmSFte3HmalATrcgLE1/X5/JDR0GsJL7aQmFc1CJF3+YFMjPI5Dj0GclXENBcfsmPUTdNaQ2/C0uFsK95tCBYrfIleaRP1jqd7bQfIwcIIusHY7oSrDLrU3VlRmhibS9GkMhI2vi8r/NjR9U6HUizNS/u9BhhPvS7RX0nDpQhKduwTRM+0c0jwGxabrmHd1GSs51HfeMXqXySeCiCfEtJ9SO4E3GnUcXDQca9WMG0qbgL0SP6fSw0fGywQLW6s5plxJcwZ5jAKfAb8p8ywtyHmoI0FECHBKrpoSGvVzPPZOImQnvl7ZqvAP3GxEyqUlqCMC/N+fpQNuAIaHIUDdVPokXdUk6Rm3T09roE5iBVS1iKjGgsBzvrjcno01DC+11dvndglOnLctx0CLFNLocgiqcu3R7K4fw+/2YVutrNhYNb+vrsWJM7slGsClCkZ++FJkBKok+u8tkn9cFKVxN0pEFkvdrJ+1J7I7RX9JBW4qnALUfTeCuMbwTsHfjnIUItI9YZ5mi5o5wRcbwZGYhFUcjX85HNZ242IFqWC+yxHS3CjAYOTBN3ZVDGbnoTSdkbioao8Ocq2CCvZIoHkeoBHBTMoydNHXKhY33X9vFYQuCIcBSd7qgVzex1SW9YoGF90xe8unZrc2O4Y9s6PA6cPJcPTU6ERfHQFy/FL88m149bzhBqYoc0lZrfQfJnMTyZIdHed7uZEuNA9hdjomrAeKHn7HvsrGBkU5nUVpL2y14keYQ2bVRmi/+R39ScbPMo+LDesVBYsTqSKSNhItITHjR+0FaZ8K7p8TYOGiPalqTdTOgVJ173wWLNKJObOntU87FVWfHYZDSCoFVmOfF+mYggJ0jr7169SUM9z6tKSWNYf44gaiH90XnBRT1XSYA4h2CAAaFXMtbBkqyEIJvN9XruXHYJHSSycYIe4aJh9rscHNT
 RJ+xX3RZ
 FGAkBjG9BK602yroOZSFx/q2kV/P9X05R7c/V4j1pW2pOZIY/TlJKghEHQv69i0/18KC1kycbILNM5M6VD0QGURASTbOX1RVF5fFpC+XqCMYXcERFifEQYZoJ1OZ1W3es9V7QgcrDgZk/q3CEceIlpnJcN11ujjhzyLPU2eO1CQOMImgRvgsizq9qgBnTDjruFrgZzSfuneb/NjxFe8Os9cu+ucMtmHy0nyoI2g6yiuBLZ+7CrMctBsiwBpWmg9JJTfPrxxWmhXGJh1kee8BQ8QV4/SQkcrGUdaZskGivVXOOQkSBFAyOawCvtELtrkZgTm6pmzTGgntLNvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 2:59=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/12/26 07:26, Hao Li wrote:
> > On Wed, Jun 10, 2026 at 05:40:10PM +0200, Vlastimil Babka (SUSE) wrote:
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -3378,9 +3378,10 @@ static __always_inline void unaccount_slab(stru=
ct slab *slab, int order,
> >>  }
> >>
> >>  /* Allocate and initialize a slab without building its freelist. */
> >> -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, =
int node)
> >> +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
> >> +                              unsigned int alloc_flags, int node)
> >>  {
> >> -    bool allow_spin =3D gfpflags_allow_spinning(flags);
> >> +    bool allow_spin =3D alloc_flags_allow_spinning(alloc_flags);
> >
> > nit: allow_spin doesn't depend on `flags` now, so it seems we can delet=
e the
> > comments:
> >
> > /*
> >  * __GFP_RECLAIM could be cleared on the first allocation attempt,
> >  * so pass allow_spin flag directly.
> >  */
>
> Right, deleted.
>
> > Otherwise, looks good to me.
> > Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks!
>

