Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA476D29DE4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07BF6B008A; Tue, 13 Jan 2026 02:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEE56B008C; Tue, 13 Jan 2026 02:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1C46B0092; Tue, 13 Jan 2026 02:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C65FC6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:36:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71AD71A01A3
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:36:11 +0000 (UTC)
X-FDA: 84326132142.19.99E87B7
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7FDA518000C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:36:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BmQKeXpr;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768289769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUozRbnze9HzpC21A9V0Ws1+iVaj/6k577CuB99o4e0=;
	b=dQp1sWEz49UuqyrCLuSatMDjKDUZsDc6bGmICuOqeV6wBPvSv+WsBPHE8+mpRJ8JlehAzv
	h8zFYKu6vra1NRf00pO3hlAI2EARXVDhh1AJ+PtW3jgAGE/FXg2PlCOsxGrZUaMiX7BDMg
	FRx5ZNOz3NLUPtRuuiiz06X4XwSTJlc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BmQKeXpr;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768289769; a=rsa-sha256;
	cv=none;
	b=7v/68PFtyyDvXRbe51R85+aKd/qQjXjobjyFn4MQ6G5jTy9/HP8jKJb0nRZRTUkGZSk0EZ
	X5zXdIWbJNbqHDD560rD5g8F0yHAx7KWExoDjjFnqw7tn4hk7VKESczQTLOIc6xtMTZvWU
	4og7+ycm1D8Nl/dCyE/pX2Vz33OoTpY=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so4119962f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768289768; x=1768894568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUozRbnze9HzpC21A9V0Ws1+iVaj/6k577CuB99o4e0=;
        b=BmQKeXprXLqnUJIbsO3Unw1brQ3h6jMC+GyGbOcnuKNPMum8VVKC8vSkfTOKu7i8XG
         I+vpGG3HG/UXu3Am4jaUgdyIoRfAzLhaNu5VuWjiHHHFro0AGuiK50ZZeAB7IBMCTZsC
         Ak0L8oCQLwm4plcm/LdMXRXKBjoG5bDp9Z/a+VHsQlIjPQ27a0S8VszKPiAVO9g8Ny0S
         6qctWdmOG+CDkR8osyDyJwPM2pih/ePrqLW7dW7s08AlkbXgS4XmtaM59bCihng5UO/J
         NPlKMHHfWzQhuoEmrJlk19jBVvJeeE8trTXKki4tZ1EN5kpMavAGlpNghYFgUG5nssc2
         jwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768289768; x=1768894568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eUozRbnze9HzpC21A9V0Ws1+iVaj/6k577CuB99o4e0=;
        b=irO+P0d9+cZLhwybRJsJyrz6AOBrsRvrRXQ6Vb77HAMOdENiripz0Lk2k4HZiIU7Lu
         XetAFfVjvoh6wcjTHYkn10q4Ssjqr+JZq8luGa5Jj8uKcPndQAQESXeZr8qkYbgnGQt1
         rSoj9dRVgKXhxbi8wAZcamCzW/1g3B4DhlYAdhkdEV4UxzwNqk0/CUsnXQl+8bqsqUjK
         jkTtdKYj4vTdRQRVPsgkccWVZsm+RMtVl3TeCIVJf37i4JcBpaNhUthhQQCbpmBHdQYA
         utszffYEGoud6hNgj5dJWZHSjY3nrK3hWkvAzArJzVA/YwGEJFpicbvFJSp04MwwouZq
         m7wQ==
X-Forwarded-Encrypted: i=1; AJvYcCU45WxTq7lFCer11fhHSn52alt02m4u68YkPi6zp0DnhWxYgpVWKHxBA3NAhgAShK2cfdHe6Zpa5A==@kvack.org
X-Gm-Message-State: AOJu0YyRjA8TiA2lwmeS8SwcBsl48J5QASw4UJ1pRjIzr4X77dXQrpMV
	XbPhRxwpZLSnt15xNoXslDRADh+VoGEpSFtBwhOioTzWfNJ5zRhGs2S2dhq5YGqLfPJoFY+W/e2
	L57y3klVO4l7DuEoI6jLR4IKpQmMp7zM=
X-Gm-Gg: AY/fxX5W2JTCccDXmJJWQVMjleNtp06bvyJuQq11D3a/g762rblTxWskAHpd/PkHJq+
	5Un2kH0n/3XXiP9G7ykuCRBi7r/4wA+B0i7A1yohleY8OFEAI2QElSgBukh94NdOqBypC8xcQ8i
	DYPsdn4/CmFSj6FXPDgH5ecTWEg0g7VhUzn6Yy4kjRYEzNxEVtQgzGReASzrQDjOjkJs4BGBmzU
	3UOX21g8nvHnMrO0LeVOVGY0X38fqgI7Zlqmhw2g8lsrQivtla8GbepYKgsPwe+FMHoZ2Y=
X-Google-Smtp-Source: AGHT+IH9RAgZVfoszvmI2rHlHQQ/65rwZdAI+w8Ko1vSjYRWtReTjlaib+Hvfplj6jXWv7FNxUvUF0QpMOELK4Wju5M=
X-Received: by 2002:a05:6000:4301:b0:42b:5592:ebe6 with SMTP id
 ffacd0b85a97d-432c32f701cmr20640766f8f.0.1768289767408; Mon, 12 Jan 2026
 23:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20260108203755.1163107-1-gourry@gourry.net> <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F> <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
In-Reply-To: <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 13 Jan 2026 16:35:55 +0900
X-Gm-Features: AZwV_QhbH32JBJthS6KlFQhKn8wWXAfJ1iISfNLvWOTOVFurrrg7BnRers1QG9U
Message-ID: <CAKEwX=MftJXOE8H=m1C=_RVL8cu516efixTwcaQMBB9pdj=K+g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net, 
	jonathan.cameron@huawei.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, dan.j.williams@intel.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, ziy@nvidia.com, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, rientjes@google.com, 
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, bhe@redhat.com, baohua@kernel.org, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	osalvador@suse.de, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, cl@gentwo.org, harry.yoo@oracle.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7FDA518000C
X-Stat-Signature: 6y3thrqsq76io8kzb5h7hag47b6jhxya
X-HE-Tag: 1768289769-39933
X-HE-Meta: U2FsdGVkX1/BhWalv+rvjj+WaySoLtB7uV8pe1F2Q7JDUDjGlKrzk8X88TjLH4cWf9KvDhWBOXeyU6k2RcaPBwNsvmvpbiznnZTBnCG0L4e2zgHD1ZFML5tp33xFblxg1dHa022EJYf+La643TKgMr5PLtB4k9pODMY6fqRzv7qXEtvQUP0rnRAPlOM6erbloaJAbRtIbkd+ZQdWWemwvoUNNojViFwtE8m/B5fkP1fSW+PgFC9SEHg/hmI+glK3Bp2HOZ48X06DDs1968ohiRaIPRr6db5GeRxmNDm5+9pvnN5T6dkTleF7VCqNtcZ1RFzyyiMRgpB/1Fc7a4/YXP2uxtyF09E6+tEbr1V+lrYrnsoL6ZRag2LkdoazsweXieV8f9bBtTpgQMt5oMlQ86sRZ/+UfF6q2hi6PktbKteOR9xPa8HSaVetMA78gn7z4SnqhAG2ZeQCgQk5Ijck2amxSiodivo3tf+4FZeN6fEb42XQj1EfrZwl+kcg/xbtKWPk+kau5qmM9ldo+PoY0F/rOO3q4blvf3H+MJFzO4woCT0pzkEgo0TZmJScksMVFK0r3FcQ0+ii9K1RMsnrQ9R+/91CNpDfW2jCHODIe83mlRK/PJuvHITQdnE1XjaQfenZ9GsXEMcK+nrH+yqTqapf8ASgjifORf6pDWzQHJ2Z1SU1fCWj7Qm8Gv5eWj4qC2Og4j8S99y3bUaDJezKy1YIwIJYcw/K03yRk/lT/WW84aohxZGGq607cgmrPFmZfBX7bscqWT8iL14c8MOSdUt4c4qviw84b49OHgPVcsKdMQwfWE1dz40ebMdTzzG2FfptGdSNgGzGenFrvjuqBfiNEs08lOEt4A+EKtvJYvFhtoH8hJSURrmx6cYxemrOG9sBj7H0jX2CJZ+UbLc+SOBI8G76JyPDSlqKnGGUDU5XjA3zJXMPb1FTXreoOMZ7Q+D+PjoIRu2cYF6a9RY
 mwYp22KC
 uIpdotsS22FEg9yKjPipROzDlg9yTqKC4LiZ3yFeFQXjgd+nZqLZbS907Jb5LhViZLeRih5GTPGIDFrPpZd5JW8X2qn9cWkR/NN8K/zWEkyJqFU/9mbCBLFr79l36XD7tY+34KpMDdazV8Nt14W+MPMus3AP3Nd40qCHjUl6IGLUC33Wx6kuNBHdPxGCMpu3JNoS05ILG/82x8JjAT49jAHf+wEPHmWKK5HGkGUtmoSX5GQY32YXlhhtLUllFqszlk2VSqClWAJej9FMRIzS1xocH/O/SDNvoriwbu7X6TLuTgw8aL/K/DMLHLKJqOT1I4KXIjZvrWrswBF/LRqRoMbD3naTBAwtSeSB8gZPEouK4/4L5FeKWcRzL1yHc8fUOaEu8cvDzXjvhQae7mp2Bz8GX3c68Kn+8exKHaJTSzps5+FY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 6:13=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Fri, Jan 09, 2026 at 04:40:08PM -0500, Gregory Price wrote:
> > On Fri, Jan 09, 2026 at 04:00:00PM +0000, Yosry Ahmed wrote:
> > > On Thu, Jan 08, 2026 at 03:37:54PM -0500, Gregory Price wrote:
> > >
> > > If the memory is byte-addressable, using it as a second tier makes it
> > > directly accessible without page faults, so the access latency is muc=
h
> > > better than a swapped out page in zswap.
> > >
> > > Are there some HW limitations that allow a node to be used as a backe=
nd
> > > for zswap but not a second tier?
> > >
> >
> > Coming back around - presumably any compressed node capable of hosting =
a
> > proper tier would be compatible with zswap, but you might have hardware
> > which is sufficiently slow(er than dram, faster than storage) that usin=
g
> > it as a proper tier may be less efficient than incurring faults.
> >
> > The standard I've been using is 500ns+ cacheline fetches, but this is
> > somewhat arbitrary.  Even 500ns might be better than accessing multi-us
> > storage, but then when you add compression you might hit 600ns-1us.
> >
> > This is besides the point, and apologies for the wall of text below,
> > feel free to skip this next section - writing out what hardware-specifi=
c
> > details I can share for the sake of completeness.
>
> The wall of text is very helpful :)
>
> >
> >
> > Some hardware details
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > The way every proposed piece of compressed memory hardware I have seen
> > would operate is essentially by lying about its capacity to the
> > operating system - and then providing mechanisms to determine when the
> > compression ratio becomes is dropping to dangerous levels.
> >
> > Hardware Says : 8GB
> > Hardware Has  : 1GB
> > Node Capacity : 8GB
> >
> > The capacity numbers are static.  Even with hotplug, they must be
> > considered static - because the runtime compression ratio can change.
> >
> > If the device fails to achieve a 4:1 compression ratio, and real usage
> > starts to exceed real capacity - the system will fail.
> > (dropped writes, poisons, machine checks, etc).
> >
> > We can mitigate this with strong write-controls and querying the device
> > for compression ratio data prior to actually migrating a page.
>
> I am a little bit confused about this. Why do we only need to query the
> device before migrating the page?
>
> Are we checking if the device has enough memory for the worst case
> scenario (i.e. PAGE_SIZE)?
>
> Or are we checking if the device can compress this specific page and
> checking if it can compress it and store it? This seems like it could be
> racy and there might be some throwaway work.
>
> I guess my question is: why not just give the page to the device and get
> either: successfully compressed and stored OR failed?
>
> Another question, can the device or driver be configured such that we
> reject pages that compress poorly to avoid wasting memory and BW on the
> device for little savings?
>
> >
> > Why Zswap to start
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > ZSwap is an existing, clean read and write control path control.
> >    - We fault on all accesses.
> >    - It otherwise uses system memory under the hood (kmalloc)
> >
> > I decided to use zswap as a proving ground for the concept.  While the
> > design in this patch is simplistic (and as you suggest below, can
> > clearly be improved), it demonstrates the entire concept:
> >
> > on demotion:
> > - allocate a page from private memory
> > - ask the driver if it's safe to use
> > - if safe -> migrate
> >   if unsafe -> fallback
> >
> > on memory access:
> > - "promote" to a real page
> > - inform the driver the page has been released (zero or discard)
> >
> > As you point out, the real value in byte-accessible memory is leaving
> > the memory mapped, the only difference on cram.c and zswap.c in the
> > above pattern would be:
> >
> > on demotion:
> > - allocate a page from private memory
> > - ask the driver if it's safe to use
> > - if safe -> migrate and remap the page as RO in page tables
> >   if unsafe
> >      -> trigger reclaim on cram node
> >      -> fallback to another demotion
> >
> > on *write* access:
> > - promote to real page
> > - clean up the compressed page
>
> This makes sense. I am assuming the main benefit of zswap.c over cram.c
> in this scenario is limiting read accesses as well.
>
> [..]
> > > So the CXL code tells zswap what nodes are usable, then zswap tries
> > > getting a page from these nodes and checking them using APIs provided=
 by
> > > the CXL code.
> > >
> > > Wouldn't it be a better abstraction if the nodemask lived in the CXL
> > > code and an API was exposed to zswap just to allocate a page to copy =
to?
> > > Or we can abstract the copy as well and provide an API that directly
> > > tries to copy the page to the compressible node.
> > >
> > > IOW move zswap_compress_direct() (probably under a different name?) a=
nd
> > > zswap_direct_nodes into CXL code since it's not really zswap logic.
> > >
> > > Also, I am not sure if the zswap_compress_direct() call and check wou=
ld
> > > introduce any latency, since almost all existing callers will pay for=
 it
> > > without benefiting.
> > >
> > > If we move the function into CXL code, we could probably have an inli=
ne
> > > wrapper in a header with a static key guarding it to make there is no
> > > overhead for existing users.
> > >
> >
> >
> > CXL is also the wrong place to put it - cxl is just one potential
> > source of such a node.  We'd want that abstracted...
> >
> > So this looks like a good use of memor-tiers.c - do dispatch there and
> > have it set static branches for various features on node registration.
> >
> > struct page* mt_migrate_page_to(NODE_TYPE, src, &size);
> > -> on success return dst page and the size of the page on hardware
> >    (target_size would address your accounting notes below)
> >
> > Then have the migrate function in mt do all the node_private callbacks.
> >
> > So that would limit the zswap internal change to
> >
> > if (zswap_node_check()) { /* static branch check */
> >     cpage =3D mt_migrate_page_to(NODE_PRIVATE_ZSWAP, src, &size);
> >     if (compressed_page) {
> >         entry->page_handle =3D cpage;
> >         entry->length =3D size;
> >         entry->direct =3D true;
> >       return true;
> >     }
> > }
> > /* Fallthrough */
>
> Yeah I didn't necessarily mean CXL code, but whatever layer is
> responsible for keeping track of which nodes can be used for what.
>
> >
> > ack. this is all great, thank you.
> >
> > ... snip ...
> > > > entry->length =3D size
> > >
> > > I don't think this works. Setting entry->length =3D PAGE_SIZE will ca=
use a
> > > few problems, off the top of my head:
> > >
> > > 1. An entire page of memory will be charged to the memcg, so swapping
> > > out the page won't reduce the memcg usage, which will cause thrashing
> > > (reclaim with no progress when hitting the limit).
> > >
> > > Ideally we'd get the compressed length from HW and record it here to
> > > charge it appropriately, but I am not sure how we actually want to
> > > charge memory on a compressed node. Do we charge the compressed size =
as
> > > normal memory? Does it need separate charging and a separate limit?
> > >
> > > There are design discussions to be had before we commit to something.
> >
> > I have a feeling tracking individual page usage would be way too
> > granular / inefficient, but I will consult with some folks on whether
> > this can be quieried.  If so, we can add way to get that info.
> >
> > node_private_page_size(page) -> returns device reported page size.
> >
> > or work it directly into the migrate() call like above
> >
> > --- assuming there isn't a way and we have to deal with fuzzy math ---
> >
> > The goal should definitely be to leave the charging statistics the same
> > from the perspective of services - i.e zswap should charge a whole page=
,
> > because according to the OS it just used a whole page.
> >
> > What this would mean is memcg would have to work with fuzzy data.
> > If 1GB is charged and the compression ratio is 4:1, reclaim should
> > operate (by way of callback) like it has used 256MB.
> >
> > I think this is the best you can do without tracking individual pages.
>
> This part needs more thought. Zswap cannot charge a full page because
> then from the memcg perspective reclaim is not making any progress.
> OTOH, as you mention, from the system perspective we just consumed a
> full page, so not charging that would be inconsistent.
>
> This is not a zswap-specific thing though, even with cram.c we have to
> figure out how to charge memory on the compressed node to the memcg.
> It's perhaps not as much of a problem as with zswap because we are not
> dealing with reclaim not making progress.
>
> Maybe the memcg limits need to be "enlightened" about different tiers?
> We did have such discussions in the past outside the context of
> compressed memory, for memory tiering in general.

What if we add a reclaim flag that says "hey, we are hitting actual
memory limit and need to make memory reclaim forward progress".

Then, we can have zswap skip compressed cxl backend and fall back to
real compression.

(Maybe also demotion, which only move memory from one node to another,
as well as the new cram.c stuff? This will technically also save some
wasted work, as in the status quo we will need to do a demotion pass
first, before having to reclaiom memory from the bottom tier anyway?
But not sure if we want this).

>
> Not sure if this is the right place to discuss this, but I see the memcg
> folks CC'd so maybe it is :)
>
> >
> > >
> > > 2. The page will be incorrectly counted in
> > > zswap_stored_incompressible_pages.
> > >
> >
> > If we can track individual page size, then we can fix that.
> >
> > If we can't, then we'd need zswap_stored_direct_pages and to do the
> > accounting a bit differently.  Probably want direct_pages accounting
> > anyway, so i might just add that.
>
> Yeah probably the easiest way to deal with this, assuming we keep
> entry->length as PAGE_SIZE.

Yeah this one is no big deal. I like a new informative counter :)

>
> >
> > > Aside from that, zswap_total_pages() will be wrong now, as it gets th=
e
> > > pool size from zsmalloc and these pages are not allocated from zsmall=
oc.
> > > This is used when checking the pool limits and is exposed in stats.
> > >
> >
> > This is ignorance of zswap on my part, and yeah good point.  Will look
> > into this accounting a little more.
>
> This is similar-ish to the memcg charging problem, how do we count the
> compressed memory usage toward the global zswap limit? Do we keep this
> limit for the top-tier? If not, do we charge full size for pages in
> c.zswap or compressed size?
>
> Do we need a separate limit for c.zswap? Probably not if the whole node
> is dedicated for zswap usage.
>
> >
> > > > +         memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
> > >
> > > Why are we using memcpy_folio() here but copy_mc_highpage() on the
> > > compression path? Are they equivalent?
> > >
> >
> > both are in include/linux/highmem.h
> >
> > I was avoiding page->folio conversions in the compression path because
> > I had a struct page already.
> >
> > tl;dr: I'm still looking for the "right" way to do this.  I originally
> > had a "HACK:" tag here previously but seems I definitely dropped it
> > prematurely.
>
> Not a big deal. An RFC or HACK or whatever tag just usually helps signal
> to everyone (and more importantly, to Andrew) that this should not be
> merged as-is.
>
> >
> > (I also think this code can be pushed into mt_ or callbacks)
>
> Agreed.
>
> >
> > > > + if (entry->direct) {
> > > > +         struct page *freepage =3D (struct page *)entry->handle;
> > > > +
> > > > +         node_private_freed(freepage);
> > > > +         __free_page(freepage);
> > > > + } else
> > > > +         zs_free(pool->zs_pool, entry->handle);
> > >
> > > This code is repeated in zswap_entry_free(), we should probably wrap =
it
> > > in a helper that frees the private page or the zsmalloc entry based o=
n
> > > entry->direct.
> > >
> >
> > ack.
> >
> > Thank you again for taking a look, this has been enlightening.  Good
> > takeaways for the rest of the N_PRIVATE design.
>
> Thanks for kicking off the discussion here, an interesting problem to
> solve for sure :)
>
> >
> > I think we can minimize zswap changes even further given this.
> >
> > ~Gregory

