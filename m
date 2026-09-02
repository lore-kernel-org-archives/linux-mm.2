Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBA8C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D516B00B5; Wed,  2 Sep 2026 17:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F205E6B00B6; Wed,  2 Sep 2026 17:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36646B00B7; Wed,  2 Sep 2026 17:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB5B36B00B5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:58:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45532A03EC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:37 +0000 (UTC)
X-FDA: 85170187074.02.376FCC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C2B2180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9gTzEyE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUEKUVKXoWUOR+E5mhSVvS9WmDqloii4ItdH3VZMoHg=;
	b=oj0zXZfwkFRMpWIJjnxRMTxgzhGcTKgYvbzZLR9ORk5KWjBVoPrUllLEAq8fp5Pr0ekfrC
	A1xcc7NwtudCVbgM32DOlzSLFRbHXRHIBmaT40XbqiIBgnkDK9UB6xyAf+LRuoO8OjIbnH
	7F5s0pFoWDz3iapr4PVxv2zs30dC30c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9gTzEyE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788386315;
	b=UsI3ObF/NNePHgVMCk4eP2mp6rd4d1CgjR5apMXg8DAPT4zTqL0gx9kH3lwQ9/kUJ3NA1a
	1zXKsOQmxK4iqHNA7MxQ6ymftFshuzH8jC9LbSXvZsWH0XTlzrjURR75TD9KBnpAycDM5P
	d3edROJimzxsoCqU7icbCUTZ/g+lu28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BDDE43EC8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAD81F00A3E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788386314;
	bh=ZUEKUVKXoWUOR+E5mhSVvS9WmDqloii4ItdH3VZMoHg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y9gTzEyE1D2IE5W5pz95T3iFb+ofXbWImJd7iRdzou8DSZBItv6wctqhjtO8dJZrm
	 3s8h9CUVHqZ3aqzzhNj0kJkXJIkmFU11bELQlkzXKbA5kjVM3c8hTKmpX45xtikA7o
	 5ZSrTmFuO/FFbancEG/OWyU420bZrYWCx8Y65pv1TuOWPWyjmyC2znViJ9HnOyv7ku
	 1TJSGEd0liAjcL6uL1T7yiO60WaFQbMUGoTQaVWDMGAnIfUP396eoGmfp/sp10Sr06
	 C5pFeoooHIuYQAd+a8PlHJVX17d1xTtvP/gBRvcyAbwa023+SR+n1iSUbN9Ev6gtxC
	 3WY8kuhE3cIaw==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-936dfd009d1so40687285a.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:58:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxhsDTfw7sQRUCS5a/gFGV4UHR08x1mj5RQLeokYyBKpHptgcrfqNGDLe+OGstILQOrVBQl12AzJg==@kvack.org
X-Gm-Message-State: AFuF++nPIicRXljgz+r92ciD5ZLmF5zBwMy4y2Dq0G0V9imVRBH2QEla
	heFuUikyB9MlCi46NI2Ub0faSciMlRkKJJ/zwdgR9tNM6SVjKxqLlhsn6Spdpwgf2k0uwoGboBF
	P/neAhBOR9dJzU5w5aMv4SG98uchKpxI=
X-Received: by 2002:a05:620a:4916:b0:939:3f4f:7254 with SMTP id
 af79cd13be357-9396e00fbb8mr203781485a.14.1788386313684; Wed, 02 Sep 2026
 14:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <apcVhWzEwkwHYjB1@KASONG-MC4> <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 05:58:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
X-Gm-Features: AcwNN1Wb4YyzIhIHf2Y_bgeEi3d3VmYjR46Ow-3xSRFk6c1cEBew419BsDFxt3w
Message-ID: <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>
Cc: "ryncsn@gmail.com" <ryncsn@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"weixugc@google.com" <weixugc@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"yuzhao@google.com" <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qoe3duwj8poe5c5gw8crdncnp3romf4i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C2B2180003
X-Rspam-User: 
X-HE-Tag: 1788386315-614152
X-HE-Meta: U2FsdGVkX1+t7FBT//vDwH2hTvbLZVsnAxAyYJMyFv0xJsj2Zr44GH9bKOWMn3PFEgcp0lA3U+KRZCcnaNP94q3Z1lVMfOHW1w+GqXOWvARN1dY+ngT+3PXkfBzL9/6FUHMTyMJKGkbm7FY9vXKzEWKn5eBdHHjb04l/u51tuydt3LX3Qe3maQ22nch+ih9NSvnx75Wld+Wn7j7jps7MzubTM6eLC7YqD/humWHbp6M6ZDdkEIcpeVeONlFiAje57dJVj3E2IiEWi5ZjBjJ9okl0rdgd9RkjQxvCMOG6tLNLdD1DLRq4nxznvPxVzTSQNmi7NT+p+oApiY81K9/5k2VduxQS/ek5GX7DEQ3ho7lDBupLt3ebajQ200a97icOmYZIfzu9lAd3k4VI1SZY2W6wHePjYtW4s+6NDXShs04rxNOIbVK74wKHWALlqhc3511Fjox1Eb7Z2oYBQ7kw/F5EOwNkhlJnBumHvheVdJe+mb0AWp+81SOpfWQ8pGg53gOJlOld6tY2CLO2tyC+UpR9I34605SLWv6z6AzCgJrKO7q4vmtt6iTPfNevbus3Pdm+jwXPRzypjaPly9eMQzV9IgwFGxw5M6vAFInqEmZG3LDnADQCQAQFMI6gYC7eIf7hnpIhEqbxVSCo/OHsyziyGKirV2+5HamJMPJzsH24xgosjaHz1Oygo1RMnNzxB1kAE/zfSmAjD5GB61QWmBUt0qqsYgvFrI+wuGNLtEmR5rOaV3AeLM5n3IlT8cdBv8Q65h00Q/pPYW/qrbQtyDpASuWi7/y8eBq3pqEcQwTygP8Jg5XenuNf9+GSS5jcK1lfYSYL2+Tgi4Wj0HIpHLMnT75D5sdND/l3qNNtrCVl6Xku1NmaIcPQ0W+72uhj7LPh0iOQrGaaybm/OuYyqyFQpTF1YMp5xhLK7F2xEOPmawOz+ArP35MYC7fKEdLEAeIXdG8fL6JVXzUajcv
 Bq/dOJNp
 KDVC4EtGm+wKILrsT7L8en0eymZFO6NOpDoqlGAkcz7zrT8wHV20cSfyr7lOMruw7nsw9mqZUIeyFtAkVOv0p54jz9KcN8dwgS4g7v26LoeyFt/vz+4wwaTzfUTIgrLWklE9+AK1QMS/D3n9XK+wmAGUjlP3Wh9RM0jQp7Yvq021yY2EFr2wGb0SJvBxeYvYGE/+6TlcD/EfQWDt4F+ae0Zd2tPcyrpD+zK9Yhase1ye9o+qv5hn4IdfD4phnqnPgqBJla8c8P/Oi5+lKe42pbFvkZ3RobAIcVMSQZ1ZBrsBx39ck/iER3SUB5P/oPxLtvtYRP7lP2YccX4J/OUB7JcBqZxuq9EnLN/iEoTw1yeYwnHEMrI7vfuS4AYgvoJ9bUwTJtzncJsmX8oNVVcRQj32OFkZUH36rw8RF611vehfSCA8EbaPLyHD+UJ1cQx7Jlc6dt98P8uGojOGik/g8XqnykBrDXDY5HrGlVgcRkwSQ0dgxXEG7mb544TxcR3BCAccwV9I8S9eFmGSQsGoXWLniO9JbQgE0PDP+n4T7QFFHLb4Hf/azlNN+oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 5:52=E2=80=AFAM Ababneh, Ehab <ehab.ababneh@intel.co=
m> wrote:
>
> Hi Barry, Kairui,
>
> Thanks for the feedback and suggestions.
>
> > -----Original Message-----
> > From: Barry Song (Xiaomi) <baohua@kernel.org>
> > Sent: Tuesday, September 1, 2026 3:05 PM
> > To: ryncsn@gmail.com; Ababneh, Ehab <ehab.ababneh@intel.com>
> > Cc: akpm@linux-foundation.org; axelrasmussen@google.com;
> > baohua@kernel.org; kasong@tencent.com; lance.yang@linux.dev; linux-
> > kernel@vger.kernel.org; linux-mm@kvack.org; qi.zheng@linux.dev;
> > shakeel.butt@linux.dev; weixugc@google.com; yuanchu@google.com;
> > yuzhao@google.com
> > Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault
> > folios under refault pressure
> >
> > On Wed, Sep 2, 2026 at 2:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> > >
> > > On Tue, Sep 01, 2026 at 11:06:43AM +0800, Ehab Ababneh wrote:
> > > > Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace
> > > > folio_set_active") introduced a regression for workloads that rely
> > > > on readahead to keep sequential file access efficient.
> > > >
> > > > The problem is that MGLRU can place fault-path file folios in older
> > > > generations, so memory pressure can reclaim readahead folios before
> > > > the workload touches them. In our Cassandra read benchmark, this
> > > > raised p99 latency to about 9.2-9.5 ms and cut throughput to roughl=
y
> > > > 41.8k-43.6k op/s; the revert restored the workload to about 5.5-5.6
> > > > ms and 51.9k-53.1k op/s.
> > > >
> > > > Readahead is important for sequential I/O and mmap scans, but it
> > > > should not be retained when the workload does not benefit from it.
> > > > The goal is to keep the optimization without keeping readahead page=
s alive
> > forever.
> > > >
> > > > This patch provides a middle ground: keep the original behavior by
> > > > default, but temporarily protect fault-path file folios when
> > > > repeated file refaults show that readahead is actually helping.
> > > >
> > > > The mechanism is dynamic and self-tuning:
> > > >
> > > > - add a per-lruvec readahead/refault credit
> > > > - accumulate credit on file refaults in the MGLRU refault path
> > > > - consume credit in folio_add_lru() for fault-path file folios
> > > > - keep the folio active while credit is available, and otherwise le=
t
> > > > the
> > > >   original behavior stand
> > > > - decay/reset the credit as generations advance and when an lruvec
> > > > is
> > > >   initialized
> > > >
> > > > This means we only protect fault-path file folios when refault
> > > > pressure shows that the workload is actively benefiting from
> > > > readahead. If the workload does not need that protection, the
> > > > original optimization remains intact and we do not keep readahead p=
ages
> > around unnecessarily.
> > > >
> > > > Benchmark results for the Cassandra read workload
> > > > (4 nodes, 720s, 100 readers):
> > > >
> > > > - with commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> > > >   replace folio_set_active"):
> > > >   p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
> > > > - with revert of commit 6cbdd9726fb5 ("mm/mglru: use
> > > > folio_mark_accessed to
> > > >   replace folio_set_active"):
> > > >   p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
> > > > - with this fix: p99 ~5.8 ms, throughput ~51.9k-52.7k op/s
> > >
> > [...]
> > >
> > > Just an idea. For an short term and easy fix, what if we simply rever=
t
> > > than, then only protect in_fault && folio_test_swapbacked folios with
> > > PG_active?
> >
> > Hi Ehab and Kairui,
> >
> > Thanks very much for your reports and discussion.
> >
> > I'm not quite sure we want to revert it entirely, as that would immedia=
tely
> > regress the workloads improved by the commit, such as the kernel build.
> > Also, for example, Kairui's cover letter mentioned the LevelDB benchmar=
k:
> >  "I also retested the LevelDB benchmark from the cache_ext paper [5].
> > Interestingly, mainline MGLRU already beats CLRU on this one after a re=
cent
> > change in lru_gen_folio_seq that bumps new folios with refs =3D=3D 1 to=
 the
> > second-oldest generation."
> >
> > I guess we could instead try to mitigate the cases where some workloads=
 are
> > negatively affected while preserving the original intention. Does the f=
ix below
> > address both of your cases, or is Ehab's case actually different from K=
airui's?
> > (The kernel-build test on my machine looks quite positive. It not only
> > preserves the original optimization, but even provides further gains.)
> >
>
> I agree that reverting the commit that caused the regression is not the
> optimal path. I expect there are many workloads and scenarios that
> benefit from the behavior introduced by that commit, so reverting it
> could unnecessarily regress those workloads.
>
> I will run the Cassandra benchmark with Kairui's MGLRU-FG patches to see
> whether they address the issue I am seeing. I will send the results when
> they are ready.
>

Thanks very much, Ehab. Could you please also run my proposed quick fix:

https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/

Best Regards
Barry

