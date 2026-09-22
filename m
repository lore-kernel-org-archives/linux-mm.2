Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7660C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B801C6B0093; Tue, 22 Sep 2026 13:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57D56B0095; Tue, 22 Sep 2026 13:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70806B009B; Tue, 22 Sep 2026 13:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 682716B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:21:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C778C1C2C46
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:21:47 +0000 (UTC)
X-FDA: 85242065454.08.C8F6F73
Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id D170BC0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:21:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AufhQVwm;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.230.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
	b=yP6ptqQZSDiXUfPNxa3Wmyz4fB6/7NhvMVvCaHp0qog3hgFXcFnEnG7hl1auZ8Z9yGMHDU
	tuAC9nJJkG0st9Cxx188NBbfkjdyA8ehrkWASR2zXinAemPcvskRvTpA/p3UH4D09qieLn
	EdNzUDZY6MhoJ+1VVVb5PoRa6dU0PDY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790097705;
	b=CaJJr3FG72gSFbSxedQwU6iRw7RHdLhSVXRgqPDji4W2tVBgokcoQygibjik/0MMc/kCiR
	KuqBPtOySkkK582m15MwNr88jbIzyf0RXIl5SdsK3yDYRFca9j1mjZpjfZ9FOUYjx9ms6U
	iDXaxSGEpcl+IsOP99+2PTZqNVox/EM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AufhQVwm;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.230.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff17443dso359491fa.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790097704; cv=none;
        d=google.com; s=arc-20260327;
        b=DNzRvueHNlPr935W/439pnNcOegCNxwk6RZbPog1D6sOavHywpMiveZRalxUFA38XQ
         JS2aMr2n1uVxNN4hgHH+2fvYlam0LBL3FXmjKmyCPiGRWr9+QSii14HZGsDVwSb23E7q
         czlyVZRQveQrSY5HcS5eY+MH1dEdCmDAQ7749WuKpu2mS7VEb6iLpvAgahY83DM715kX
         uQ/CEOOmw05fIaIkK2ywwkZFnUYk9y+ckRjrxS1iPbK0OXe4uyxgqvNsOa/ka3YpNNmL
         0m+6Cly/BC2ZSG1PP2EIfQixBIusO8vAQeXUYUWjsR/fp1JVS0avvZ4T6ghysZIGHjSV
         BRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
        fh=584l1KMinDFOgXChRVc/qUwA/5ODhTxmGtwl0JO9DAw=;
        b=GpxqKny8+owdf67RhV9crH08p6QvKlDlfh9ubJoOMk6JEY7kfOGvhml0+H1GAjg+5L
         tIE3KifFLIcvAZGmkLbn1Ww//gPJZL3E5oxBjRGTstAAvu89H8ROXaedglPT0VgGzy8u
         mM5ckr0BlqAQXnYYET/Pu7Fdhty5RbyYCELIMMXMGa7MTKxxyfkBbJmxG+TmFIA85A7t
         ngDNbvPOY4VZixoVjHHeiLoP/Vr1kf0u5GI3rm74MCbtG7Fgsri2ONDMYXNK/e5MJ3IY
         0aAQG4BrljOqJK4EgJpmSnGDIFXdg2MjA6TxuIVvU1ggyv2qy2x9toatfZhthbHDj480
         50zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790097704; x=1790702504; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
        b=AufhQVwmSDaHegPuPU7vnOesZnnD6CCbcfTNzVCDg958pv11NaSVPg3dZcY/Xo7Dc4
         E9WeaDBucARF9mvPHr4iURoAKZRz0a2qWteRNqY1KHRLuI1EcEAF7EBz485J3oOi321R
         6LZp0Pv0H0+2TFb1fC4WsOAmxGr4bo2dYfGBJsuYYlcOKlgOl2JM0LQk/MjO24xuCl3E
         jUJaANHaYHs65sDYaf77TelOaC0g18aKSAfFPSJ71R2Ntg6Cyb3m16jSlqLcpG2i2Ix7
         +isuXK23UqlRXHayQUNsCE7KUuleZSdVs4KE/iGxl69Ey94u3vFxQzYCFaKawk9GuX/1
         QFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790097704; x=1790702504;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
        b=gtJPCfXr5SdoRbXdAWjPJPIU4Tf4sua/4REJxAtlxdigvgW0Faj5pt1hzVaKb6jbMS
         oMcJZ9pKnU4p75feDxP5uSA8E4JitUVQSdPokpMCq6usYmjLSYYSdRnzSL7EXW5kOEtl
         VllBk1VJNxkD2uBRu9kU9gZm+jUKyd4XXTq0AbCPJaKiVABBfnZ97OIgVDy9ahjwA65Y
         QbyN/hPOvmamVIzF6z2IcBXNVW3s7Me3bgqthcXBgXYj7dV9sH/t3NQws+OX9bUGReSM
         IQz1jkLqERHYYaVigKkwJxn93eL0+nfCMVlJ//jexAmWLG9KSrAJqokZcj7dnhsiHVIO
         D/og==
X-Forwarded-Encrypted: i=1; AKwUvBwzVSvyiG1UrC37DVBgwtWIdyLaWyjlsOUQbW0+aLlVE7gviPCW7ezxBBJ1gnKfJJpD97vUFntrZQ==@kvack.org
X-Gm-Message-State: AFuF++k0P0CLsnn2Ec83N/eKoS+xbRHpL22k3vvQlBpK3a8HTSNdSUeW
	uAjEQGJ8RoVks0ldrQWr9Z4ce5MUEoe0G2Q4k9N3m+xardlV43OjtIZjcr/D3D6LwyljXcIKelY
	FMEufrenGaB7gNULVh1iM5E6mfz3x2Hg=
X-Gm-Gg: AYBFou3c2/ReDleWLZ40RXq5SCLWqlbnWQTyI6dLnjWbVyLivROlPq6PMOuMSoTrsq7
	qEae+iFP/2lM82wxk27W6wbi/WVnHWVb+/wScuQw04UM0nM/FvcT5llAiBF11aNr2OWOF68ZrJ9
	euW6fxOoFRCutpovs/UgmJcyQuEtzXcDJJhtn5QgeRaTxtplR2S0HEigX2jRoNGLpeMa0tQGxba
	ppoEuvn1cNOhBm8+icwii8MMWUZKUvLhgMWKYp+lqiLPeoR7jDDYyshLvABQXbSFmkOuqp/KuGs
	lDp527lL7/mZ0ZGQ7PMSgxQe0WjLbKHkHzld/G8vTD+JDQVcdMdOwQlljjlCyINNW+1nFu0+k/S
	igYjKDhWNyww=
X-Received: by 2002:a2e:a550:0:b0:3a4:850c:5900 with SMTP id
 38308e7fff4ca-3a5fbef79e8mr29852861fa.11.1790097703647; Tue, 22 Sep 2026
 10:21:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F> <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
In-Reply-To: <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:21:29 -0700
X-Gm-Features: AcwNN1XXWGuPHcmN1XUaSbD201MO3zoYy8czrwaKOr1UiYnCbEj6IM0vycSKfC0
Message-ID: <CAKEwX=NKC=N-YaiwZK7HPM4MfX-7JG_KeHukS0+vjHqMZTV4dA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: m5chb9qig4frj68oy4hn4mi4dtqdacdo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D170BC0002
X-HE-Tag: 1790097705-205530
X-HE-Meta: U2FsdGVkX1+php80M7aO9o5PG9tPUoW+Koz6ztAZOtpAzjYIuuP9AuKg4Yq7qVFYrcPtWYVk7ldBbCRyie251Nw1Hw2oPb8Z4WJggLMITm/xyPGujhtuUplTICD/8wOsSJzYpxYLqjgNmlha+UX3ZRiJNWahiUKQ6uRkKA9f7ve98Ua13G6XldJKZTEAz+ttMIISN1OiYQXlDPTXT+FAGYlmRf7p4yXOKS5V1SltZ/rGTLqmettiNC1omkyvXzSG9j4JGsOBNN416buHq8rK8tZxnVjOB86mokvcLYs8PWT/ERcg2VQnEAgkMo85luZodjpEQ0WeAZuxc3VGn7V0NuJ5cjuEBjj2b5OOqxmXKval56VwYns/3603Bzv+cCOswyqr1uQJQI9RFR0D+oQGzNNohjuhbUIqVloXzlN7ngJzcdL/Xe7rXU0et9jOGU4ZThk309dFZmBpAixoLMnuLMblxVRK9HYrPV0bud4MdZXik378R5hu+ohEZ65G/8zwAt7BLAGvTXxiaMH8RDz9Ubj3qlu31ZwwVI9kezLY9zBhmKCch8Rw0Bred6g1JyexXjIkjGMZnud16+rkpH+TDylPwzdg3AWGSMlhjzU1K/UT0DArInUBAwcaDAEqSKPCC0QW9GLi0AVd20fLMmfcXn4ouCwceGg6Jtp0yigePVUUB3JnryyHRx3OGZOX2RA7nxH8YH+02K8F/qP64NyXd5SRTxZrQEqmkUwFuJdL/zOnwcfG+DcRAEv7pxFdvHgreMu7H7af/6/9wK0jngWfx+cZAx7ucoru6vrM898D2qOK7Vb57uNtiVKdiJ6XtJ+8nzpvK1vz8Q5XpEb/gS+CKtEiL64ZPPZlMwC9Dfr/zROtePlTWZoQtHO9I9gQMxgXqw4T68+lwe2Zx9na8XBunRMv9Y+qKCiYnW2i7Eht+2UisEqOXntG+o9JEjBLF+LVv/h7kh7eUrsahEQanj3
 z5q5QX2c
 4EuzgagIUsZqNVwRQQT0wUySZZ+tW/a7fJpMQFYe3NnIO2ChMxKhTht+1CGOpkBvGKnGo9SCDevIf9yfc/rk2RS6XEHDqT2I8X3+q8OSHQ6/aEqwfiCOnnlotbO/ecpy+f/qfSpSJg3tSYc3gkBIwNMeYE2P+V9lb6NkITcrG7mzS0Fd5N1AdxkJIi7p5ea72MJodNwKxMy2vlwPz5RZEqmN61BuD5nl7buIa3EyPhW79Bo0djMg8J73GqCKLJkRr1hq7IkRzjFcLwAsNUpyOs9XD6pFsVoO9ND2WuH6JgAIBNvI1/nRPxiBO4/DMEGWNCOwNqi5Td+PartLPJ+m/56kdRNlHp/6EkVEouR+LtUsPOv9lacQWxoiUEIGtBbQcQWkKOHgYbMBWikX1tvfJyrX4k6Gaty/pb0MSzoWeDhx1guYJbcb2BpavxsxRrE+SzVtUezh9vaZxNfcni7EpKDyF3PaAzUPiw79kZviXBaKzf9lQFeFnSADu9RZNGPprIM/F/BhnKJjNzXF6/BPKPfF0xaqaBntVZ0eGQ1EJmbKBXPCNOOAcdxnGasT4dwHaOUb4fc9ypAQRoNiUYbcFUeRYoTwJkkr0D2tNBX3jzvH/crcD6AACko+7P4R3P0HkjIXC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 10:15=E2=80=AFAM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t>
> > wrote:
> >
> > >
> > > You can't know the compressibility of memory until after you
> > > compress
> > > it, and requiring a user to predict the future by forcing them to
> > > limit
> > > the total amount of workload compressibility does not scale with
> > > the
> > > number of workloads of variable compressibility of data.
> >
> > You likely just need to pull a SQL query on your fleet to get that
> > number.
>
> This feature is not being developed for just one
> user. It has to work for everybody.
>
> >
> > > That should tell you that your model of reasoning about this issue
> > > is
> > > ill-suited to address the problem.
> >
> > That is what I'm suspecting. Nobody in a sane mind would want to
> > zswap
> > 100% of the RAM and maintain reasonable SLO.
> >
> It could make a lot of sense to have some default
> limit upstream, that says the zswap pool is not
> allowed to take more than half of memory, because
> at that point the compressed content will be
> crowding other things out of memory.

I actually am skeptical of gating zswap usage (both pre- and
post-compression), but I would like to note that for post-compression
size, we already have that knob for zswap, default to 20% of physical
RAM.

