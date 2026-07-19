Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 597A4C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 16:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256E06B0088; Sun, 19 Jul 2026 12:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1A16B008A; Sun, 19 Jul 2026 12:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8F36B008C; Sun, 19 Jul 2026 12:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B92596B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 12:22:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A3A816061F
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 16:22:27 +0000 (UTC)
X-FDA: 85006043934.20.1F3E0BB
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE3FA4000A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 16:22:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TZ9isuLV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784478145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXPllgzpXlDPcSqjRNXdzqpvgSvmJH0XLIFd6MTukVQ=;
	b=rnCq+CYKtPFL7frjoWR5KIgSW8JBO7ZwpD95zVF52aKJRcK0UngH6vl21P6VPpwcSLgKXW
	eYS8jaXgwGTFZBYccZRYHxEAfXTVDZJHwSlROvMRiqJuQ+p4hoLNON19rL/sAmCP7gIuQO
	UCkDxMvi42LYuETEcPxEDKtvwbU4V4U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TZ9isuLV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784478145;
	b=F7jM9W8jurndYzLyLEMg1Wkv6c+8xnriKMx0ze26uj4pxQvPjVPIZdyZk2FduIfGlbGUpF
	5gbqs36LBxGsd1wxsEHfWu0NU+h8BjfaKLIaXyNT/FuwicfgskLH0ERVw8wyYJgWk6l57C
	F5rYXjwoSvtCUvlUCehuEpXc7qEDgHY=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ee88fce572so71302056d6.1
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784478145; x=1785082945; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lXPllgzpXlDPcSqjRNXdzqpvgSvmJH0XLIFd6MTukVQ=;
        b=TZ9isuLVxwcxydZRIPJb7XYD/VQe1PhgKSPkKRdYiCPAt1eJN61zlu8VRP2Y1UjVFW
         hXATVFOnfgbCIv9m1oy7i/SiQTHfgv4E68GOj/Q6ZXjjoisGzXGDi15MTsnkBIUlYMg+
         rupq6LE3ZISB8v/khj3eSA4bwIExatX5whmI77zxNZsa08Ahz/9KLsRvnrrSetr2SXGD
         mZdth1iHbQ0PPEQFnli/OHsrGqoHbG7hl4d3NUvYETUtKMk7LTSBjAQNZIVIV2fWBCx/
         wbgL3EwTQhllSAeSSg6GryK37jcN5jATnI4JiDFJ0S7eFBEMX1kHYjNRq9HJxeaofbTU
         +i6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784478145; x=1785082945;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lXPllgzpXlDPcSqjRNXdzqpvgSvmJH0XLIFd6MTukVQ=;
        b=jJCn+lNtjsszDlTOBqyTcDFaYPbN1snLu7Zp8eal4IdLZDgvt69bKcdqrfrc1uWU0c
         QJf5IpB3Ov3sri/pYbeZkyOBAiqfNb8pIR11jMafVBnbJoc7wvS74dtsB+ouReOPfM8X
         lCNiLo/z4E67vYGUt40NkvbpVxECqPQei+S/I4noiWXVnMd3qijnmpPGS5TWBU2Yk8tJ
         OMZG5mQiG02vCYqnsXdN7ZwZqX6jZpmJfOdg1ZyGudYhLHgebSj94aPChS60+0U5Ocgv
         5JyZlzaE3aGL9Q/ETd8bj84gdA9AYd3xsqdPxXcZlH/3KmRTLRZe5yxJ5H+iSFGlc7rC
         eUAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp8GBuu/8fl2Fju+7O1YUZgIlmOp6CDqWFPMIIAs6cVOaE8TTSpHqX8hFPlLZZMcgr/lcrHU24GFQ==@kvack.org
X-Gm-Message-State: AOJu0YwXXA3sUzpKlUQGt722dRjJRjZu42UAzNOZNCO1CDyeJyr+XpVZ
	HDdg8u9NDxycHkmpZCwAuuO5HbqPEO5HJl0Hocntl2kCYECgzqEi8qCvQqC69+IFaX4=
X-Gm-Gg: AfdE7cku65sHBN5MhLf31abtFYcFp2lcH8MPmM7nlelR2j/OyBRXP7IrEur67Qa1BlM
	RvNrAZJvOkjVoQIhcLxToMGeLXn0gjtvy0/UPJ3PblNeX0oVzOxm4gBJhi3oqsUgCx1pabzCFR6
	3NuIziWuYYM240uqAdCNYR3naFQFsqXPokCU5P/6rRSwyamW8RLCnPgkNYh1tOrAryEOPq34I0f
	g07PDBcQOwFxGJ3AWO72GQKQ2mRbeVCMVJyepLM/u0h2ds6PSqrklBUyv/JBf9o0vFPhBOQtLut
	caVhzW5uOibTWi4GYnEgUOJpFK35yFPZWuqmew7vTuOJ97bpnhZ2OCUZ9dmp8Mx90yE90cBjd81
	cgr0SNSBetiyTkFLZ2/JFdvySInua1qnl1/iOPShiPRxLiwz3J/lbX646cUsP/mP9fFlnK20ICx
	TH2kfZu85GOgoXZJS4Y6DEtD0OAXpf7g==
X-Received: by 2002:a05:6214:3f92:b0:905:6e01:b9a3 with SMTP id 6a1803df08f44-907783a03famr128579916d6.31.1784478144692;
        Sun, 19 Jul 2026 09:22:24 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907786b21d6sm71687696d6.24.2026.07.19.09.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 09:22:24 -0700 (PDT)
Date: Sun, 19 Jul 2026 16:22:23 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, "open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
Message-ID: <alzw-bO6OATl2mdT@plex>
References: <20260613012521.835490-1-skhawaja@google.com>
 <20260613012521.835490-2-skhawaja@google.com>
 <2vxzwlvljyzs.fsf@kernel.org>
 <akIask9nPTEAhd76@plex>
 <2vxzse65k938.fsf@kernel.org>
 <2vxz7bnhjnpa.fsf@kernel.org>
 <akvT1yBvIbvft1H_@google.com>
 <2vxz4ihxil6m.fsf@kernel.org>
 <alrDpAMknlYN9jL9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alrDpAMknlYN9jL9@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE3FA4000A
X-Stat-Signature: qxxxkif8qtb3abosswy1w8et6ees4ask
X-HE-Tag: 1784478145-929026
X-HE-Meta: U2FsdGVkX19WEwmz/BpRSo84fajotNgy+FM6q90iKGbmfoeYrUfjxD/VptjXAofoCja02y+nI/wSPCqDXYtwv89sf2gQ9DnCIstVVX3ZNmQqxB9DVO8NEGOwN7Wi01TEouYlgwU6I32uaUUKwglT8a1dBjDamsCVOkrf3vNuNwwH4ULjFFDna39kE4UaWyB5DIGYUYDULmMjo6rNI4XLn7xS6ANkycKahFLEuNWGu0sPBIAZTwF+8oLsaFXZUnltEMCNEmkd8+1qJHcLMG7ESgBPPit/pqA+Aq5Pw22A8OHmM4q30hgAn6JCQWhnt1B80YMnbt7Cfmgw/EsiJH0VCyz83KcpOvSK28MeMM2fVrOjRJaLnFdO8kf2Avh/7pRBytJ8lS3i5EggDtDDJumngwyjRsAFPZYtw+WUA+Q0OfSMirdrZG8hg/HeYJD77Ybp5LpZSBHq2Q4izIeU7FI2x+dJpCGKPlb9giEbzWjHh1Szmp/XJkrlSdhrNcazdFPOKV1UXddHMTlSuvsamtQjPdgNsz13l1ci6qDPNy3RYxb+tmoMa93Z0f0mamgkmceobpy8vOc0/Ipuwr9P42KfOYTaXgyGTG1R5L0OMhnVxnJbw/E0SwNfuOj0tpgqV6lNBOwUUJtsEdWe1QfT2DSQG5w4bDlYUtWWu+v5EVQUJ7xzZOb+RWsLLRRRAr6ZkT5zvc2OOxudzdjamZ+doejn93Inr4ZWLdfKU42nXggS0jAfkk/1wd0P4cSjg9NHX7mz0Ig5WngDGB7GQ8CeWPC7xcaNr25UtrBCW6vRIqlcPuf93K3b6VHwGa9D9+wY1nBPbXGDyzqB8vfbWKqj9Bmp0d6KNwwTDjonoCuCUHRbozP+b/PubVh4MlaHIzl3X/sibZfHJWySZSPEhqP6oMjFoC+KKtY8K5tpCUVP6nkjb61A+QkY3RoQFh5NfmVB+LtWOU6F210caclDC7VJiET
 PHRBhNpg
 17VQfs/NPnjFWRNuQSIFp/+s+Gr+iCdxV8xDldFPVHMRfan4BqMAclVwnVpZrpR8MCsRkX9PIRBp6hx+ULJh6kwiq4ESpzOVo9L4nK+jPlhGcfJAgYaPkMVAjS61ch3jSyexSQLg3uR0/cy+WFubofCkv8xjrSHe6ErRZ4V3qAna1o/h4lukuhtnx8nJJVXGrjYe1Sc882agprVzuNd4hgJwskIBzT60J04Dlo/F7AjlcjllO1PBKeLk3krkQ6IqqegdS3CbNzy6DZSDEjRgGucD2NA6CVvgiUZWG23eGhjD6dWTS5UBTZ6x1Ok7V74Ll7y6w/m9iggb+FMWemjJAZGdCxALERG1FqxvprrXp7ZZTk9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-18 00:36, Samiullah Khawaja wrote:
> On Fri, Jul 17, 2026 at 07:24:17PM +0200, Pratyush Yadav wrote:
> > On Mon, Jul 06 2026, Samiullah Khawaja wrote:
> > 
> > > Hi,
> > > 
> > > Sorry I was out of office, so couldn't contribute to this discussion
> > > early.
> > > 
> > > On Mon, Jun 29, 2026 at 06:50:09PM +0200, Pratyush Yadav wrote:
> > > > On Mon, Jun 29 2026, Pratyush Yadav wrote:
> > > > 
> > > > > On Mon, Jun 29 2026, Pasha Tatashin wrote:
> > > > > 
> > > > > > On 06-26 13:57, Pratyush Yadav wrote:
> > > > > > > Hi Sami,
> > > > > > > 
> > > > > > 
> 
> [snip]
> 
> > > > > > Actually, preservation can also be performed in an order-independent manner.
> > > > > > While a handler can call liveupdate_get_token_outgoing() during .preserve(),
> > > > > > it can also defer this query until the .freeze() callback. Because .freeze()
> > > > > > is invoked after all files in the session have completed their .preserve() phase,
> > > > > > all dependency tokens are guaranteed to be available, completely eliminating any
> > > > > > topological ordering requirements during the initial preservation calls. It is
> > > > > > up to individual file handler implementations to decide whether they wish to
> > > > > > enforce ordering at .preserve() time or defer it to .freeze().
> 
> Quoting this text from pasha below.
> > > > > 
> > > > > That is the worst of both worlds. I get your point that LUO doesn't want
> > > > > to enforce dependency ordering. My arguments against that are somewhat
> > > > > subjective so I can live with this.
> > > 
> > > Pasha replied with some interesting points already, but I want to add
> > > some clarification here.
> > > 
> > > During preservation, enforcing order gives the following functionality:
> > > 
> > > - The token of the dependency (can be retrieved during freeze as you
> > >   suggested).
> > > - The dependency is preserved and that means it has bound with the LUO
> > >   session lifecycle. This guarantees that it is not going to go away
> > >   until the session is closed.
> > > - Once preserved, the dependency is in some kind of "immutable" state.
> > >   This might not be required by all dependent FDs, but it is critical
> > >   for some.
> > > 
> > > These ordering requirements should be clearly documented by the
> > > associated filehandler so the VMM knows how to do the preservation of a
> > > specific FD properly. This is actually similar to the memfd seal rule
> > > that iommufd preservation will enforce.
> > > > > 
> > > > > But then you can't let file handlers enforce it as they wish. The
> > > > > dependency ordering is uAPI because it directly affects how VMMs
> > > > > preserve files. If the VMM has to keep track of dependencies for some
> > > > > file types and doesn't have to do so for others, that is a terrible and
> > > > > inconsistent API.
> > > 
> > > But as you have already pointed out that the VFIO/IOMMUFD circular
> > > dependency is resolved, I am okay with enforcing dependency ordering
> > > during restore as well. However, establishing an ordered
> > > preserve/restore mandate in LUO at this point will force all future file
> > > handlers into complicated and buggy design choices if they have circular
> > > dependency or different lifecycle requirements.
> > 
> > Not really. You can always _relax_ the ordering requirements if a need
> > does come up. Because all the programs following the ordering will still
> > continue to work. The other way round won't work though.
> 
> Yes, this is a fair point.
> > 
> > > > > 
> > > > > Ideally, LUO should handle the dependencies on its own. preserve() can
> > > > > give LUO a list of files the preserved file depends on, and LUO makes
> > > > > sure all the dependencies are present in the session at freeze. We would
> > > 
> > > This again assumes the lifecycle of various FDs and that dependencies
> > > can be resolved during freeze(). Some file handlers do want order of
> > > preservation, and this scheme only guarantees preservation dependency
> > > without order, introducing hacky dependency state management until
> > > freeze().
> > > > > also need a way of getting the dependent files back from LUO on
> > > > > retrieve(). That would make sure the dependencies are properly enforced
> > > > > both on freeze and finish, and the enforcement isn't left up to the file
> > > > > handlers.
> > > > > 
> > > > > Unfortunately all that sounds fairly complicated so I am not sure if we
> > > > > want to do that just yet, although I would like to hear your thoughts on
> > > > > this.
> > > > 
> > > > We had discussion about this in the live update bi-weekly today. The
> > > > conclusion we arrived at is to keep the current functionality. That is,
> > > > we don't enforce preservation dependency.
> > > > 
> > > > But that also means file handlers can't try to get their dependent file
> > > > in their preserve() callback, since that would implicitly enforce
> > > > ordering. They always _have_ to do it from their freeze() callback.
> > > 
> > > This has problems at multiple levels:
> > > 
> > > - This indirectly sets up a precedent in uAPI that the VMM is allowed to
> > >   preserve the FDs in any order and the file handler will be able to
> > >   handle this.
> > > - This will be very tricky and will force filehandler to have
> > >   complicated/hacky state management to handle dependency. Specifically
> > >   I do need iommufd to be preserved before preserving the VFIO cdev that
> > >   has an iommufd dependency. Not sure, but I think this will also be
> > >   tricky when we start preservation of VFs and SRIOV PFs.
> > > 
> > > I don't think LUO should enforce an arbitrary rule like this unless we
> > > have a strong reasoning behind it.
> > 
> > It looks like you, me, and Pasha are saying slightly different things.
> > We all first need to take a step back and lay out our proposals clearly.
> > I'll write my points down, and I'll try to reproduce what I understood
> > from discussions with you and Pasha.
> 
> Thanks for laying down your points clearly. I'll reply to point 1 and 3
> together as those are entangled I think.
> 
> > 
> > I think we should focus discussions around the below 3 high level topics,
> > and we can figure out the implementation details later.
> > 
> > 1. Do dependent files need to be preserved before their main files?
> > 2. Do we apply the same rules to preserve() and retrieve()?
> > 3. Do the rules apply to all file handler or can file handlers choose
> >   their rules?
> > 
> > Here's my take for 1: Say A depends on B. I think it would be a good
> > idea for LUO to enforce that B gets preserved before A. You already
> > mentioned a few reasons for why. Similarly, LUO should also enforce that
> > B gets restored before A. We can figure out where the actual enforcement
> > happens, but that would be the principle of the LUO API.
> > 
> > Pasha suggests the opposite. In my discussions, and this email thread,
> > he doesn't want to enforce _any_ ordering. So you can preserve A and B
> > at any time and you check at freeze() that everything is present. Now I
> 
> Just to correct/clarify, quoting Pasha from his earlier email in this
> thread:
> 
> "It is up to individual file handler implementations to decide whether
> they wish to enforce ordering at .preserve() time or defer it to
> .freeze()."
> 
> Basically, a FH can choose to enforce ordering during preservation or
> not enforce any ordering and check it during freeze(). I agree with
> Pasha on this point, as it gives FHs the flexibility they need.
> 
> However, I see the value in maintaining consistency and simplicity for
> the VMMs, we can enforce that dependencies are preserved in order as a
> principle of the LUO API. I am ok with this. It might become tricky for
> any future circular dependencies down the road, but we can relax this if
> they come up, as you suggested above.
> 
> > see the value in this idea. It removes the need of tracking ordering
> > from VMMs. But I think it is also somewhat dangerous, because what
> > happens when freeze() fails? VMMs need to recover and restart the VMs or
> > retry live update. I don't know if they would be able to do so. This
> > path will likely be less tested.
> > 
> > But still, I can live with that. At least for memfd, guest_memfd, etc.
> > this shouldn't be very problematic. I am not sure about iommufd.
> > 
> > So in conclusion, I would prefer to have ordering, but I can live with
> > no ordering as well.
> 
> As elaborated in my previous email, I disagree with enforcing a
> no-ordering policy.
> 
> > 
> > For 2, I think we should apply the same rules on both sides. Mainly for
> > consistency. The VMMs should follow the right order for preservation and
> > restoration. Now again, I am fine with both enforcing the ordering or
> > not enforcing it, but I really think the rules should be consistent
> > across both sides.
> > 
> > From my reading, I think Pasha does as well, but from talking with you,
> > IIUC you think retrieve is a fundamentally different operation and it
> > should not enforce any ordering.
> > 
> > I do see your point but I still think there is value in keeping things
> > symmetric. Unfortunately this is fairly subjective, so I don't have much
> > better arguments.
> 
> I agree with you on this. For consistency and simplicity, we can apply
> the same rules on preserve/retrieve both.
> 
> > 
> > For 3, I _strongly_ think it should be a LUO wide policy. Leaving this
> > up to file handlers will become messy over time because each would come
> > up with its own rules and for VMMs there would be no consistency in how
> > they should use LUO.
> > 
> > I hope this helps focus our discussion to the major points. And again,
> > we can figure out the implementation details as we go along, so I didn't
> > reply to some of the points you raised in this email, to not distract
> > too much.
> > 
> > [...]
> > 
> > -- 
> > Regards,
> > Pratyush Yadav
> 
> Also I think with the next revision of this series, if Pasha also agrees
> with this, I will add documentation about FD dependency in general.

Pratyush, and Sami, thanks for the discussion. Here is my take. As Pratyush
mentioned earlier during hypervisor live update upstream meeting we agreed that
LUO should not enforce dependency ordering. The ordering must be performed by
FH, and it is up to us as LU reviewers to ensure that ordering is checked
during freeze() and can_finish().

However I would like to address two points:

Enforcing order today and relaxing it later is problematic. Not enforcing
ordering is the most future-proof approach: it solves the problem of dependency
graphs and shared resources. Once userspace starts relying on errors during
preservation or restoration to check ordering, we cannot undo that, as it
becomes uAPI.

The point that a VMM will have a hard time recovering from a freeze() failure
is not important. Missing dependencies are VMM bugs. They will be caught during
testing and will never actually happen in production.

Pasha

