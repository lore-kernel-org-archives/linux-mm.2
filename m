Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B08D2F7C3
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 08:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4E56B0126; Fri,  5 Dec 2025 03:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685786B012C; Fri,  5 Dec 2025 03:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574A06B012F; Fri,  5 Dec 2025 03:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40F136B0126
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:57:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C121687883
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 08:57:22 +0000 (UTC)
X-FDA: 84184813524.11.A3DCF7B
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id BEA2F80002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 08:57:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZpLojT+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YufMQ5I65Hkpn5Hic+07etJUK3j3cSwHPywbQmZgchU=;
	b=snA+2Tfd1wp7ACJW+LP31KuIe7+OM6o+KA4JLxJb7wQurAtaGPeF8siKaz5jQvUFKqmgFu
	oCFiFun7F/NMKkBi74UvlgZhfj5DKWJvzoJi8y216EbdM4Jf1fnGugllosHM0465pigqwj
	ouwCWEcZAf67U1OA9HwwtX/TAEHWDTI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZpLojT+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925041; a=rsa-sha256;
	cv=none;
	b=uPXIewW+D5FAW5zVS7d0dsa7wvU8AfuLKS2O7quUwiz85PBDObmPZtAXYDVQ1T5kiIE3pM
	kDi1fjxsHo8KwdCJAktEZtCY+nNObpq8f0LxOsVkBlQxus9oG38eYmOvPcGPT3SIwncZ98
	uTH1+biKOmnP6wqSZfg8cBSGmY39LLI=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b736ffc531fso309910266b.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 00:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764925039; x=1765529839; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YufMQ5I65Hkpn5Hic+07etJUK3j3cSwHPywbQmZgchU=;
        b=ZpLojT+f8V58l4V1cYfRIPQTnZNuZgrjkagw0dWvBqRgOQ/uPRoEbGeM2Mx431Q9Je
         8o81sLbGFMBQDNXAkxwa+qyX17OLhz+aWvOwIK7jcjdQMpMrNRLvI88FnCn/Smk6QCL1
         yvKTa6pSbE7ySU1QP13UoWHTgeKyLmr7l6gb4XG1/74sXcrdAOItcuATzK0smjQTU9pd
         RydeQNwnGCnkCD5NKnwNmO4DprVew37gMlWMSfMMPn2l2JkFGwR2IAQbBIrIzkLOPhi9
         icAzlow+SotvMHZhrzy75cMhwhNiZri7eUNgHbgY2dk8wxEw6mbmNaqPQYUqZKp3t6Qx
         SOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764925039; x=1765529839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YufMQ5I65Hkpn5Hic+07etJUK3j3cSwHPywbQmZgchU=;
        b=F+5fykhNRUrNY2IUY2+xYva7VsbcN8pmp/23/D3ivuRzmL/4h92YBawhWECBAuwSAM
         k0AnNWylfgjHDyc+1zlj81vPvBhhceLv9iAtHyob6o8WedAKtvSRpK87BC1JaQDFwj3Y
         fahJUlh10ZUO8U97WGQ0oUdIleOJJchPWDtCNbsy3wrvQoyNHkiu7K153bgq9fqDocXB
         wVavS4I0jjTGFtBpd6APY/HQRTxctQZXL23/UtXuJt/CS1tlrm0ptUx9hAYQevHYysil
         JQ4c9HUpEm8cHp/yQrK9HeBZJFu1bpA90E7NXsqvZD7HVVSsN4r0pgDE7CnccFNBCLHX
         nGxQ==
X-Gm-Message-State: AOJu0YweFYepOM62NMnY9mnGLichakK5BrqV62SPBIebjnx9LUXplmFT
	X5/hfXZCIXUKjmUOv88eFT6kRwvr2wgwik7MkEuy4uy+pgXpnk/HzT0NTsJHOb4vS0h2fhTX+mP
	UVJZm1gN0owbnP9Iywi0mRhZmbB5Wj5Mq6QC6noeIvg==
X-Gm-Gg: ASbGncvjVA+AwAKkqenK4QCQ2o69hCQcMCCMBqoBbGTv39/B42OGRsK6ZrrHXjCBPYQ
	8TQvLtSMDxk4EmkolDHDTB0ScFtE5/k72VDXPOYRI6uAwzx/MIWq3iGzaiHKvh9zD2ltsdiqjlZ
	M/knMJc5YIhaDjWUUG3k0WGD31wsl6OF4GM7+sSrru5ydtbqggVPfze+y8u9oM7JAgsA8KfJjhg
	krBZi11qi7O4/NP2Iosi57h06RI79T77m5uEWxe9gyKW2X4QXdcaDrXyhynThq/d/TqWggXqcBX
	+T4T1CeQV4B65PGvnmTdC8gYQFw=
X-Google-Smtp-Source: AGHT+IHxODZ+XUinmpZr9cMC2ojqb7y12pTDmf+XPH4xo3lRXwEMthJsZFlpvs9M8Tw27noij6BlHCRUSUWzvech+oM=
X-Received: by 2002:a17:907:a08a:b0:b5c:753a:e022 with SMTP id
 a640c23a62f3a-b79dc51af60mr966117866b.29.1764925038395; Fri, 05 Dec 2025
 00:57:18 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
 <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com>
 <cxxoqqalrna65kafcpig65kt5gziwe66cep3luf736lp3hmqtu@2yqkilusmmdj>
 <CACePvbVGdx4YN=TCKuLF9TzCQg95OW8rnWLRrKENS42xc6q9cA@mail.gmail.com> <gmwsdhkokyhchjucnwjw2j7nxps77lgc37lafxpjdecfjqnvic@j5d7maxz34zk>
In-Reply-To: <gmwsdhkokyhchjucnwjw2j7nxps77lgc37lafxpjdecfjqnvic@j5d7maxz34zk>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 5 Dec 2025 16:56:39 +0800
X-Gm-Features: AQt7F2rBazyDtGzp_VhDRr09jWFaqzjlRMYCg8rXEYaesVYBOq5CbMPvTASRaiQ
Message-ID: <CAMgjq7CF9RgnZCAS-+Gv0LAvkzzHk4jiok+_6-KOFw-o+s8E_g@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: linux-mm@kvack.org
Cc: Chris Li <chrisl@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BEA2F80002
X-Rspamd-Server: rspam11
X-Stat-Signature: jnmgmgkwck8wcrp1xsuky3uz3eotygws
X-HE-Tag: 1764925040-514144
X-HE-Meta: U2FsdGVkX1+b9+j6PPfxmN2FaYppOfoSZVzGwVH9SFTeZBbiAtyEKqoKrTwRGiZRf5oL3GclTqNE/XW3ORyhgPPKpCENHQyQ9KrcKWHEmZupiuQW30HKsHT0F9SbPYkCh5tt1aDfX5hxej3Amxk/PhsMD6qXngyaZtnRoUB/vl9m9jaTYGNdAWLjlY1rwTjFm2wjiWl7/OM4RGKZ+GZLijwJaba/+HlwNDm+wCyy9EjElM7xPEg5qIqhaY5FmzRXVshckvdX11nPdEgZYXsBiRAgX4S+LLhv/i7OwSG3Zn/3cMHQAiMuc8bTxw6rIO0+p2jWno4DLmgiBtj63TsD5Dd5j8UKUGVLzoiUgbRf/Cq2kh33E0BkoAcb8XPMlASBWKoRe1qR8jCE+xYbc1YshfFR8eiqG0W3L9kN4fykv/0hpt4QshF5FmXI9bjVWqgQ1z4Yas4MYs0OTR7JR7a5bEbZO4BE95Y6Qi0BC7ASgurJROiHkj37RqCUSLSbvJcYFUmUilxfnPyo0pMbJGh1ZN5renwuzyDiLdpQZdo1hA3EFbw0rkyE31L/hDtZOv0Th2vsxVgY/YKP0q6YsJz1GwEyOt8s7nn6W0zJZMx67ScVOK3Nhv9pINuqXN/A3HLigBhFvQQJJXJ2brlKp78z0TxALu6LLfeESZTBLskJhyzZrAiTJIz7Az1nMZM5jD/CPfwL7EOIqvdbLGa78F6Ar3NKImBYTK/QWLJuydenPCBqN/3r53iHy4I4SDhVD6UcY9RgBUcF7EbEWROLPicKA9mevmwa+8PLQzr2oqj/bDaVCZ8mkFFXwm2SBnZWLIq4p29iPolfhyKa88ccEi2wauTTpd9reHKH80VYULEmfVYZ/PEkwRwgpeV+v+mct4LD28M/CmdFf2Mhf/TTc04ooMpQWXddvJuE74bNGHb28m0EGW5A9sqHM0HNOJsvwzNVE1vWts2KZ1Bxnn6RGc6
 7CybZKnw
 fzXMsXfv2Mxp52HqMCWnQnIVU7t87OjklsslH6wVRetSF5y/DiG6yhj3GBKFjkQROCeRyrcF9V9U55u/cue/IuzsX4grbF50DTjSTP3c7P0AzoTJoS8yjbMf45skO5+48VUQ1p5ppyREmutmAIk+ToU5Svm6z1KFJmJ+gzHzlmWImRw28dFYx4KXun60bie5GGhIsU5w1sb/jNxkGhGOV0XYPSvlkcreIAsthUjZ3Ls/M/7TWPca84G4krcX/ceHZ+TMympo6dkyf41RyTBZxn33bzI6y0B+SPz0pnFmUZUt/SfEEGgkeDEbRH/EqAmE41NPPw5/Qt/rXdg/rwpff2Odp/qxJuLMSNhPNoO+wBZS46R+F/oae8ZXnAmQTGpwJAUW2fQp0W4W72u2AR5YqALRQ7LssnKbPZYO3fUf5vZMN5UShXW2xjRtgJQqqwSj6gYDXNuR88o5OKFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 5:05=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> On Thu, Dec 04, 2025 at 02:11:57PM +0400, Chris Li wrote:
> [..]
> > > >
> > > > > oversimplifying a bit: Chris mentioned having a frontend and back=
end and
> > > > > an optional redirection when a page is moved between swap backend=
s. This
> > > > > is conceptually the same as the virtual swap proposal.
> > > >
> > > > In my perspective, it is not the same as a virtual swap proposal.
> > > > There is some overlap, they both can do redirection.
> > > >
> > > > But they originally aim to solve two different problems. One of the
> > > > important goals of the swap table is  to allow continuing mTHP swap
> > > > entry when all the space left is not continues. For the rest of the
> > > > discusion we call it "continuous mTHP allocator". It allocate
> > > > continuous swap entry out of non continues file location.
> > > >
> > > > Let's say you have a 1G swapfile, all full not available slots.
> > > > 1) free 4 pages at swap offset 1, 3, 5, 7. All discontiguous spaces
> > > > add up to 16K.
> > > > 2) Now allocate one mTHP order 2, 16K in size.
> > > > Previous allocator can not be satisfied with this requirement. Beca=
use
> > > > the 4 empty slots are not contiguous.
> > > > Here the redirection and growth of the front swap entry comes in, i=
t
> > > > is all part of the consideration all alone, not an afterthought.
> > > > This following step will allow allocating 16K continuous swap entri=
es
> > > > out of offset [1,3,5,7]
> > > > 3) We grow the front end part of the swapfile, effectively bump up =
the
> > > > max size and add a new cluster of order 2, with a swap table.
> > > > That is where the front end of the swap and back end file store com=
es in.
> > >
> > > There's no reason why we cannot do the same with virtual swap, even i=
f
> > > it wasn't the main motivaiton, I don't see why we can't achieve the s=
ame
> > > result.
> >
> > Yes, they can. By largely copying the swap table approach to achieve
> > the same result.
>
> What copying? Using virtual swap IDs inherently means that we are not
> tied to coniguous swapfile slots to swap out large folio.
>
> > Before I point out the importance of the memory
> > overhead of per swap slot entry, the 48 bytes is not production
> > quality. VS hasn't really made good progress toward shrinking down the
> > per slot memory usage at a similar level. Not even close.
>
> Nhat said repeatedly that what he sent was a PoC and that the overhead
> can be optimized. Completely disregarding Nhat's implementation, I
> described how conceptually the overhead can be lower, probably down to
> 16 bytes on x86_64.
>
> > That is until you propose using the earlier stage of the swap table to
> > compete with the later stage of the swap table, by using the exact
> > same approach of the later stage of the swap table. Please don't use
> > swap table ideas to do a knockoff clone of swap table and take the
> > final credit. That is very not decent, I don't think that matches the
> > upstream spirit either. Please respect the originality of the idea and
> > give credit where it is due, after all, that is how the academic
> > system is built on.
>
> Ugh..what?
>
> All virtual swap propasal made it clear that they are PoCs and that the
> memory overhead can be shrunk. Compacting fields in the swap descriptor
> (or whatever it's called) to save memory is not "an original idea". What
> I said is that any memory optimizations that you apply to swap table can
> equally apply to the virtual swap because they are conceptually storing
> the same data (aside from the actual swap slot or zswap entry).
>
> The other part is allocating and freeing in batches instead of
> per-entry. This is an implementation detail, and Nhat mentioned early on
> that we can do this to save memory (specifically for the locking, but it
> applies for other things). This is not a novel approach either.
>
> The comparison to swap table was to clarify things, not "knocking off"
> anything.
>
> [..]
> > > > https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1G=
sFf3uv9asuArpoYLw@mail.gmail.com/
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dquote=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > > > I think we need to have a separation of the swap cache and the back=
ing
> > > > of IO of the swap file. I call it the "virtual swapfile".
> > > > It is virtual in two aspect:
> > > > 1) There is an up front size at swap on, but no up front allocation=
 of
> > > > the vmalloc array. The array grows as needed.
> > > > 2) There is a virtual to physical swap entry mapping. The cost is 4
> > > > bytes per swap entry. But it will solve a lot of problems all
> > > > together.
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dquote ends =3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> > The above prior write up nicely sums up the main idea behind VS, would
> > you agree?
> >
> > I want to give Nhat the benefit of the doubt that he did not commit
> > plagiarism. Since now VS has changed strategy to clone swap tables
> > against swap tables. I would add the points that, please be decent and
> > be collaborative. Respect the originality of the ideas. If this is in
> > the academic context, the email sent to the list considers paper
> > submission, the VS paper would definitely get ding on not properly
> > citing priory paper of "virtual swapfile" above.
>
> Okay let me make something very clear. This idea to introduce an
> redirection layer for swap, call it virtual swap or swap table or mTHP
> swap allocator or whatever is NOT new. It's NOT your idea, or my idea,
> or Nhat's. I first heard about it from Johannes in 2022, and it was
> floated around by Rik in 2011 based on discussions with others:
> https://lore.kernel.org/linux-mm/4DA25039.3020700@redhat.com/
>
> So no one here is trying to take credit for the idea, except you. No one
> here is plagiarising anything. We are discussing different design and
> implementations of the same idea. Sure, people have different ideas
> about how to implement it, whether it's using an xarray or a swap table,
> or what exactly to point at in the backend.
>
> But these things are usually hashed out during discussions and code
> reviews, and the better approach is taken by the community. You are the
> one being very defensive about his "ideas", making it about personal
> credit, and creating a problem where there was none. No one is trying to
> steal any credit. Kairui's patches introducing the swap table are there
> under his name. If we extend his work for the redirection layer, no
> matter the direction we take it in, it's not taking away from his work,
> it's adding to it.
>
> >
> > So far team VS haven't participated much on swap table development.
> > There are a few ack from Nhat, but there is not really any discussion
> > showing insight of understanding the swap table. Now VS wants to clone
> > the swap table against the swap table. Why not just join the team swap
> > table. Really take part of the review of swap table phase N, not just
> > rubber stamping. Please be collaborative, be decent, do it the proper
> > upstream way.
>
> There are no "teams" here, you're the only who's consistently making
> this into an argument between companies or teams or whatever. You keep
> saying you want to have a technical discussion yet most of your response
> is about hypotheticals around teams and stealing credit.
>
> > > > > Disregarding any specific implementation, any space optimizations=
 that
> > > > > can be applied to the swap table (e.g. combining swap count and
> > > > > swapcache in an 8 byte field) can also be applied to virtual swap=
. The
> > > > > only *real* difference is that with virtual swap we need to store=
 the
> > > > > swap slot (or zswap entry), while for the current swap table prop=
osal it
> > > > > is implied by the index of the entry. That's an additional 8 byte=
s.
> > > >
> > > > No, the VS has a smaller design scope. VS does not enable "continou=
s
> > > > mTHP allocation" . At least that is not mention in any previous VS
> > > > material.
> > >
> > > Why not? Even if it wasn't specifically called out as part of the
> > > motivation, it still achieves that. What we need for the mTHP swap is=
 to
> > > have a redirection layer. Both virtual swap or the front-end/back-end
> > > design achieve that.
> >
> > Using your magic against you, that is what I call an "after thought"
> > of the century. Just joking.
> >
> > Yes, you can do that, by cloning swap tables against swpa tables. It
> > is just not considered decent in my book. Please be collaborative. Now
> > I have demonstrated the swap table side is the one with most of the
> > original ideas and advanced technical designs. Please let the team
> > swap table finish up what they originally planned, not steal the
> > thunder at the final glory. If team VS wants to help speed up the
> > process, since priority is one of VS main considerations, now the
> > design has been converging to swap tables. Please help reviewing the
> > swap table landing phases submission. Crew, walk, run. Even if you
> > want to use the swap table against the swap table. Reviewing landing
> > swap table code is a good way to understand swap tables. Let the team
> > swap tables to finish up the original goal. Once swpa tables have the
> > continue mTHP allocator, we can example any other VS feature can be
> > added on top of that.
>
> More rants about hypothetical cloning, knocking off, etc.
>
> >
> > > > With the continues mTHP allocator mention above, it already has the
> > > > all things VS needed.
> > > > I am not sure we still need VS if we have "continues mTHP allocator=
",
> > > > that is TBD.
> > >
> > > As I mentioned above, I think the front-end/back-end swap tables and
> > > virtual swap are conceptually very similar. The more we discuss this =
the
> >
> > Of course very similar, for all we know it is possible they come from
> > the same source.
> > https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3=
uv9asuArpoYLw@mail.gmail.com/
>
> Your lack of self-awareness is impressive.
>
> >
> > > more I am convinced about this tbh. In both cases we provide an
> > > indirection layer such that we can change the backend or backing
> > > swapfile without updating the page tables, and allow thing like mTHP
> > > swap without having contiguous slots in the swapfile.
> > >
> > > >
> > > > Yes, VS can reuse the physical location pointer by "continues mTHP =
allocator".
> > > >
> > > > The overhead is for above swap table of redirection is 12 bytes not=
 16 bytes.
> > >
> > > Honeslty if it boils down to 4 bytes per page, I think that's a reall=
y
> > > small difference.
> >
> > 4 bytes per slot entry difference is leaving free memory on the table.
> > Why not grab it?
> > Do you know that all those swap phase II..IV just to save 3 bytes per
> > slot (and clean up the code in the process)?
> > 4 bytes out of total 8 or 12 bytes that is 33% - 50% difference on the
> > per solt usage.
>
> Cleaning up the swap code and the performace optimizations in Kairui's
> work are a lot more important that saving 3 bytes per slot, especially
> if it's only for actively used slots. That's less than 0.1% of the
> memory saved by swapping out a page to disk.
>
> >
> > > Especially that it doesn't apply to all cases (e.g.
> > > not the zswap-only case that Google currently uses).
> >
> > I want to ask a clarifying question here. My understanding is that VS
> > is always on.
> > If we are doing zswap-only, does VS still have the 8+4 =3D 12 bytes ove=
rhead?
> >
> > I want to make sure if we are not using the redirection, in the zswap
> > only case, we shouldn't pay the price for it.
> > Again that is another free money on the table.
>
> IIUC the extra memory used for the virtual swap can be offset by
> reduction in zswap_entry, so for the zswap-only case I don't believe
> there will be any additional overhead.
>
> >
> > > > > batches). In fact, I think we can use the swap table as the alloc=
ator in
> > > > > the virtual swap space, reusing all the locking and allocation
> >
> > Yes, you can. Is there a technical difference to do so? If not, why
> > steal the thunder at finial glory? Why not let swap tables finish up
> > its course?
> >
> > > >  In the "continous mTHP allocator" it is just physical location poi=
nter,
> > > >
> > > > > Another important aspect here, in the simple case the swap table =
does
> > > > > have lower overhead than virtual swap (8 bytes vs 16 bytes). Alth=
ough
> > > > > the difference isn't large to begin with, I don't think it's alwa=
ys the
> > > > > case. I think this is only true for the simple case of having a s=
wapped
> > > > > out page on a disk swapfile or in a zswap (ghost) swapfile.
> > > >
> > > > Please redo your evaluation after reading the above "continuous mTH=
P alloctor".
> > >
> > > I did, and if anything I am more convinced that the designs are
> > > conceptually close. The main difference is that the virtual swap
> > > approach is more flexible in my opinion because the backend doesn't h=
ave
> > > to be a swapfile, and we don't need "ghost" to use zswap and manage i=
t
> > > like a swapfile.
> >
> > It seems the design has converged to the swap table side. Even the
> > "virtual swapfile" concept could have come from the swap table side.
> > I'm flattered, copying is the best compliment from the competitor.
> >
> > Now we settle on the big design, the rest of the design difference is
> > very small.
>
> No, the design hasn't settled or converged on any "side". I am also not
> going to respond to the rest of this email, and potentially other
> emails. You keep twisting my words, making delusional claims, and
> proving how difficult it is to have a technical conversation with you.
>
> You kept mentioning that you want to keep the conversation on the
> technical side, but when I tried to have a technical disucssion you
> quickly drove it away from that.  Half of your email is basically
> "everyone is trying to steal my cool ideas".
>
> I tried salvaging the discussion but this is hopeless.
>

Hi, all, I hope people don't mind me adding a few words here.

I think the key thing is Chris wants things to be done in an optimized
way. He welcomes others to collaborate, as long as it's properly
credited.

Upstream development is tiring and there are conflicts in tech detail
and ideas, making it hard to track who is more credited for one
implementation. But he has been super helpful as the behind the scene
hero for swap tables:

Back when I was unfamiliar with swap and sent the long series to
optimized it in a different direction two years ago:
https://lore.kernel.org/linux-mm/20231119194740.94101-1-ryncsn@gmail.com/ [=
1]
https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmail.com/ [=
2]

Chris literally reviewed every patch of the first series super
carefully despite me being a beginner. And for the later series, he
pointed out that's not an optimal direction at all, and shared what he
thinks is the right direction to refractor swap systematically with me
off-list. Then we collabed to implement the swap allocator. That's
also the key prerequisite of the swap table.

For the swap table series, I already posted a completed series at May
this year that have implemented things basically covers until phase 3
(almost half year ago):
https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/
[3]. And shared a workish branch that covers until phase 5 seeking for
collaboration later multiple times.

Despite swap table is already performing well and stable, and I was
also providing the info on how we can solve the VS issue (And the
redirection entry layer idea was completely introduced by Chris), the
feedback or review is stuck. And you can see VS is also stuck with
performance issues at that time.

I was in a rush and struggling with managing that long series, getting
it merged or reviewed, to enable next step developments. But lacking
upstream positive feedback or progress is really disencouraging, and I
hesitate to implement the later parts and even thought about giving
up. Again Chris helped to organize and rework a large proportion of
that series, so we are making real progress, and finally got phase I
merged, and phase II ready to be merged.

I thought the best approach is, having a clean basement for everyone
so we can compare the end result, without any history burdens, then we
can discuss further developments. And we are on track of that. And
IIRC, VS was also struggling with things like the direct swapin, slot
cache and other existing workarounds or the fuzzy API of swap, which
are all removed or solved by the swap table series.

We are all busy and may be unaware of others' work or history. (e.g.
Yosry once pointed out I ignored his previous work, and I apologized
for that [4]). It's understandable to me that misunderstandings and
implicit interests exist. And if you look closely at [1] and [2] and a
few other later series around swap cache, it's also getting very close
to the idea of unifying the swap routine to then have a common
metadata despite I having no idea of other's work and it is in a
different direction, [2] has already done removing the direct swapin
and use swap cache as the unified layer, [1] in 2023 is having similar
vibe, you can still find same ideas or even codes in the pending swap
table patch). But without the cluster idea and a prototype patch from
Chris, it would end up catastrophically in upstream. He shared the
idea proactively and helped to make later work possible, and so we
co-authored on many larter patches.

Link: https://lore.kernel.org/all/CAMgjq7DHFYWhm+Z0C5tR2U2a-N_mtmgB4+idD2S+=
-1438u-wWw@mail.gmail.com/
[4]

What I mean is from what I've seen, Chris has been open and friendly
and I never see him lack the spirit of sharing the ideas or
collaboration on that. As for the current tech issue, we are
definitely on track making major break though, let's just focus on
improving the swap and make progress :)

