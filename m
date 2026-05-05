Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A409ACD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 13:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09456B0005; Tue,  5 May 2026 09:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA4B6B0088; Tue,  5 May 2026 09:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8326B008A; Tue,  5 May 2026 09:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 966446B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:12:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E3D01404CB
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:12:51 +0000 (UTC)
X-FDA: 84733406142.16.29F549A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1E4FC40014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:12:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M3880p72;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777986769; a=rsa-sha256;
	cv=pass;
	b=L/PPBLETg8E2YPtiW4HDHJ6rqcEdPJQmIlKS0GaRMMxa9SWi0PqmDh9ZtfoxAXLZU3k1P/
	6n9RVTu/cIaM/krakrwymsTBUnMF80RCLPgk8YRpINof9EeYF7FD1USPqkB+pT19l0Eb3C
	y646tVYkQej0Ggf5a7isZbpvA1uGWso=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M3880p72;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777986769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LltibOIvw4fGDLQWh4s92lhSPkVlgVdJTrd+4ZlmbBQ=;
	b=kCPLjoHbgexT4BPHMU6fwhbwnl64gjN/iJkWodHi40qbiPLCB9NDVn1qANqBft0FgBECDG
	miZC4oA/LKNiaAVLVw6Xcw1eSPQptmr3M5T15wKHTc5RDgzWZc0x+Yze2w1WgpXU/1ZqK7
	uP/d93gAQQcWV2UnZHWeqRyDhKs/UwA=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67b7c71c165so6248861a12.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 06:12:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777986767; cv=none;
        d=google.com; s=arc-20240605;
        b=AUHCpQWTc5fZVz7LEyfKdwQ027CjH6iTFeAY/dYgQrGaiBUIgkOsEgtSFfbCDJqwqR
         1k7NyvLHuqv60yWCLwC4p/ZtDdujrGbNT4ttK2GHUJv84srZQeI7g1Aod5HzvszztccQ
         pX+EiSl6HOUQG8reJ+wE+9KxtOcZP4taleYNYtNV8z824oFaAySdAXob8oNctPTvkK2+
         t7QqscVAW7d6w8J5sElWbyB+NlSxhID7CUemS8xLTL1SwdsDiQZxJVdJ+kdcwlqu74Bs
         RiPfOhnnvj2Jtll2TvrgLiZ4R5W8le5hfc3pVgNGkWDr+0RPme9B5JWxGkmHHJLS1yM7
         20fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LltibOIvw4fGDLQWh4s92lhSPkVlgVdJTrd+4ZlmbBQ=;
        fh=6S96x6wCpF7D5OKNJKT8cKvEHI+uxViuVl6IpmtQVNc=;
        b=UI3yKcq/vVnSnsupJPabq0/6IOlCji7aUB8pGTzvu59dR5cPwQIRZcH4Jl/Z8OhD2L
         owBYstsxLS10QBKWBBpEGVMpyBvJ4omZ1iIQY9PcUsVcrDKX0RTy72Xlki2HVvS7k3Si
         +W3R9/ky0E8rl3HoYleHBowDfDdBAzkyCgKMN3zt2QxMhMYc8w9Qss2BV3LH9SgMn7+7
         cRku0jzTiEP1mNel0zPJyBXZsbTvHI7dA8N6z99IKOXuQvjFh0M2LCnjNCycFCg1H67P
         nPtQi/bxWBO5EotOLQXp1zYYWVvm8koffgxfLWiEZIl9NMKPtseUwoo6Fleh8Y+q6SYO
         RqLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777986767; x=1778591567; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LltibOIvw4fGDLQWh4s92lhSPkVlgVdJTrd+4ZlmbBQ=;
        b=M3880p72U66HMw62xvVQ+7Bifffbz7557DffEr+15c9EdRM1xiH1Otv/ulRGkpC3LU
         y2GicjEArh1me9SkKwuIF2vexZmkw0xVTsw5L9G6BPPQQpV0oOSA6XuCRqe36RQA/jEe
         xHNFcBOjXAwe6gCo7ggIt5Bi09Lc3LImFpNheuEUhzwMNGohp+e1h32ZzKHcip4F3Bqe
         7CZfVd5R+STj3owDzUY0iyLx6WoATLha3sAYy5Dwzdx/zPD/1yuUB5O79azE9mkbISWD
         J8j0BdwcbakjnVzuukZRSuJf0xkKUXm/J/QbQpSITPtHMvwySaqAtUwU0lzPxxOBv2NH
         qK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777986767; x=1778591567;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LltibOIvw4fGDLQWh4s92lhSPkVlgVdJTrd+4ZlmbBQ=;
        b=lPh+sz2jF/T+34DzxlZQKb5Y4PmY/Eyl3vSO8BCa+7agxhUVNolBQSaYsSPmCcIrDv
         fkZM46rBadHDqCjO/3XzMJWf+Gb/mUUA5hssARGraxQKveRTfxrGN7hApnBNYvKC0ong
         lBB08riKKl70l04B+2BkJVblCP5hztUNXI6Tdu3PlcLbFaVi+96ZGwr5+MVSKpST7dOm
         VgJIzhyRwgACpzcVs+N3W1yAFJFg9GOGW/XfcbGmqbINpV4ObZpmTkvu88akrRUr7Kmf
         R4h2+PBN02RDX9fIf/H540rYLJjOYPAHeDEe2y9aoM8JSrhRrKLByerU4dyx9vK3EwQ2
         C0Sw==
X-Forwarded-Encrypted: i=1; AFNElJ+xH1LqkXIwa5tFVk8W+IxxiegX9FaeZSR2JucaTGWEShBYPbpUHRP38h6iz6wqjzgQfkM3+RY7XQ==@kvack.org
X-Gm-Message-State: AOJu0YyguXp4ImNcGDcGL70aYvNrJXhT5W1fxFZSDTUek4V2rAKp4P7k
	bYD/0mjlzPTUiOXp6JL5PAN6/itlY6E0e/T2UPwH+Yl5T6caeGw1ulnvOI0E5pNeZE734nz2J5I
	NePc87brBxILMywr2b2JiEOQV1wnNy2iC/ywGOaeltw==
X-Gm-Gg: AeBDieuSqYde/zDtKqTgVuz4Ls7wEklwjCH+mToVQnphuWRbxE6DJOjHyd0CUswi1yn
	Oydf5JWG5wf7ZFlhOiqlpwG4Von5PouLy4CpCBg3iqmlV8LjBS1nmMQSm5HBNI2VJXwFHK9OlBr
	TR+E99AgNiVBox62vvlaFlIuWgEB3EsUBouivKqq76vvAO/OLxVKxV1MvHTNp+0SiRSJ2KdtEgZ
	kpEAFX8Cl8t8tayqlTHk8SE88mB2ir1FpREhSmMXjicqMiwAitBIZHLYq+WZAMhyqFQpqTGtINA
	jwzJxYz5rUwX0rEKwYnd11qBKP8WwuDvLGimE9lZ/ZKxLxyKIf/xm+cMSvRXEs2NFkBaCAtZ7w3
	UllqiKYU=
X-Received: by 2002:aa7:d64b:0:b0:66a:8002:fe17 with SMTP id
 4fb4d7f45d1cf-67c19ffe781mr5209182a12.13.1777986766770; Tue, 05 May 2026
 06:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260429133928.850721-1-pratyush@kernel.org> <20260429133928.850721-2-pratyush@kernel.org>
 <331da42-b255-326b-cd5-28d07a7e2cb2@linux.microsoft.com> <2vxztssm10fv.fsf@kernel.org>
In-Reply-To: <2vxztssm10fv.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 5 May 2026 06:12:36 -0700
X-Gm-Features: AVHnY4KHtQUMAMfPdqf16NPl8gMvZWF2eDOKcz6Y0y4sDW-HbOmB-k1RVpzoleQ
Message-ID: <CA+CK2bABpL_QhFtEE4f5a2Wmkv3dKBkeYe68HoOjP7EBz7vXUg@mail.gmail.com>
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jork Loeser <jloeser@linux.microsoft.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
	kexec mailing list <kexec@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="000000000000a63201065111cd7f"
X-Stat-Signature: e9qu6uzmyninhbny7iawqff8k81na41d
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E4FC40014
X-Rspamd-Server: rspam07
X-HE-Tag: 1777986768-806056
X-HE-Meta: U2FsdGVkX1+GO3pWawZO4oA/4P3vlBSuuwRXyoZKynPuCiifXNULB8ccJLZQZkqxyunoyRx3yaJWzcFSUeEJ8ZWsUBT8/2WcK74TyW89OCuj4roKsR7QU0Id4cbjRdHxkSlzC7FCviRvpQULOSnPcDKTp4kOta/kryuJy4WwNZ/7hVMaP6kFBBUvHH2CuzbImI+xlCZnl4i8/9DMznwyyNbGfW+40txICDxRN52yLq4FRjPh6fHkUoEbkwiKCMXfqW2jn2UL776b17VsReulTRvJ2ea23NsZ84SlsRHLAKiVphVvMe0tZxSYcdYlIBtqP0in0v9WbxM2UERzEAk6LnDieZkUo1Xbpa4+BMIpT0fzNVw5lIZDrW0kndUMeeogzFO8u3Y71/xiueHZcWnXwqIBgVELMH0CiaWeoBJV0d3lR7o7dzxdxbWQ3iHxsWM6ajUgwOqvVgNbMgZJNaNubnJz+tbdXfZ/1yRkTufsDKLtRlvPwAxT1pZxGFPHLllj0Fbq5BqGBKpNzOvXp2KJ2biW3LKLlc6qgAl4T93mD+J4xf29jUIMAjzE2lCtKRNHRCTak1FKuazxOW/fqsbA5on04eElKpJqKUx4eIQg9ynVN4w5VPpjE95tqOsfweoOE7uZh27/SBTltkhH9GZkzFbZzOG6jAJ74JSzWNja6o1EmD+4V+oZr9XWzWgBW62cNMnZCNazvT5YlMupXPOBes9h6pq83nsDlnq7ucVon5I+01SoIDPND4Q3Wuf7BkDmSY4sX/ngPflyhXdwSYWegaDMKmuvVU/bS49UrhrZsCIPghooafH1Cv6FqoKBT/Hy7o1kT0GwZm762vDhxz6daPswhTAb29cThzFHzkTe2MlwO24FhutvF1wt09ymkc/X6wZaiCzTtvo2QBSQfO47U42/rcywk9SpYs6Ef6Dx2Fd6DS+k/qKVuXYtor6B8gYiumXhJYqNLsCh4L95dDr
 PIWq06jr
 9PbjatZqDSH8+awHi09VzkZZDqWhzpPwxxQ9NF16vC1d+BPoiT2XKEIavGq3SeLdfHuxVmenAn/S0nSfDsU7HCcM9LVkreyUS9SR0TW3biIej5pXUupoXv59Q9qgywot6j62LDQXw6M52rC7yxzjOetNMlQwyryWeO4sSwaBiIjMluqzhbRDiuU4XBDuxYxzbSPBbWqTV3H7GJ9INcqKD6/OGDlqrilAYb0/UNycQj2bl2mL4TxrpYLGSIzNMLH9Ne2n5qWBf7hwwzxTdE2octFT6KeiyHxdjUKnR6QOPd56csiDRoUtJgtrMhMERxQ8hHLZCC8Mrv5mK+R9vB/p4xpEPai8TJ/ArcFGy5Li/kKRLI98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000a63201065111cd7f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026, 5:54=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org> w=
rote:

> On Tue, May 05 2026, Jork Loeser wrote:
>
> > On Wed, 29 Apr 2026, Pratyush Yadav wrote:
> >
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >>
> >> The KHO radix tree is a data structure that can track the presence or
> >> absence of an arbitrary key, with nothing inherently tied to KHO memor=
y
> >> preservation tracking. This was one of the design goals of the radix
> >> tree. This was done to enable it to be re-used by other users of KHO.
> >
> > "Arbitrary key": Not quite the complete 64-bits, rather 64 - PAGE_SIZE,
> correct?
>
> Right, 64 - PAGE_SHIFT.
>
> >
> >> + * kho_radix_add_key - Add a key to the radix tree.
> >>  * @tree: The KHO radix tree.
> >> + * @key: The key to add.
> >>  *
> >> + * This function traverses the radix tree based on the key provided.
> It sets the
> >> + * corresponding bit in the leaf bitmap to mark the key as present. I=
f
> >> + * intermediate nodes do not exist along the path, they are allocated
> and added
> >> + * to the tree.
> >
> > Consider adding a note on the key-width limitation.
>

As a side effect, it should make sashiko happy.



> I think adding a runtime check would also be a good idea here.
>

+1


> --
> Regards,
> Pratyush Yadav
>

--000000000000a63201065111cd7f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote gmail_quote_contai=
ner"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, May 5, 2026, 5:54=E2=80=
=AFAM Pratyush Yadav &lt;<a href=3D"mailto:pratyush@kernel.org">pratyush@ke=
rnel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, May=
 05 2026, Jork Loeser wrote:<br>
<br>
&gt; On Wed, 29 Apr 2026, Pratyush Yadav wrote:<br>
&gt;<br>
&gt;&gt; From: &quot;Pratyush Yadav (Google)&quot; &lt;<a href=3D"mailto:pr=
atyush@kernel.org" target=3D"_blank" rel=3D"noreferrer">pratyush@kernel.org=
</a>&gt;<br>
&gt;&gt;<br>
&gt;&gt; The KHO radix tree is a data structure that can track the presence=
 or<br>
&gt;&gt; absence of an arbitrary key, with nothing inherently tied to KHO m=
emory<br>
&gt;&gt; preservation tracking. This was one of the design goals of the rad=
ix<br>
&gt;&gt; tree. This was done to enable it to be re-used by other users of K=
HO.<br>
&gt;<br>
&gt; &quot;Arbitrary key&quot;: Not quite the complete 64-bits, rather 64 -=
 PAGE_SIZE, correct?<br>
<br>
Right, 64 - PAGE_SHIFT.<br>
<br>
&gt;<br>
&gt;&gt; + * kho_radix_add_key - Add a key to the radix tree.<br>
&gt;&gt;=C2=A0 * @tree: The KHO radix tree.<br>
&gt;&gt; + * @key: The key to add.<br>
&gt;&gt;=C2=A0 *<br>
&gt;&gt; + * This function traverses the radix tree based on the key provid=
ed. It sets the<br>
&gt;&gt; + * corresponding bit in the leaf bitmap to mark the key as presen=
t. If<br>
&gt;&gt; + * intermediate nodes do not exist along the path, they are alloc=
ated and added<br>
&gt;&gt; + * to the tree.<br>
&gt;<br>
&gt; Consider adding a note on the key-width limitation.<br></blockquote></=
div></div><div dir=3D"auto"><br></div><div dir=3D"auto">As a side effect, i=
t should make sashiko happy.</div><div dir=3D"auto"><br></div><div dir=3D"a=
uto"><br></div><div dir=3D"auto"><div class=3D"gmail_quote gmail_quote_cont=
ainer"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex">
<br>
I think adding a runtime check would also be a good idea here.<br></blockqu=
ote></div></div><div dir=3D"auto"><br></div><div dir=3D"auto">+1</div><div =
dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"gmail_quote gmail_qu=
ote_container"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex">
<br>
-- <br>
Regards,<br>
Pratyush Yadav<br>
</blockquote></div></div></div>

--000000000000a63201065111cd7f--

