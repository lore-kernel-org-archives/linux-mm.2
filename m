Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44101606A6A8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Yzqy+haz
Received: by kanga.kvack.org (Postfix)
	id 605B16B05B5; Mon, 23 Nov 2026 12:51:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD356B05B6; Mon, 23 Nov 2026 12:51:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3286B05B7; Mon, 23 Nov 2026 12:51:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4736B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:51:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42F67120954
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:50:57 +0000 (UTC)
X-FDA: 85467124554.16.CB2C39E
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 24207A000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:50:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Yzqy+haz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of namangulati@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=namangulati@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795456255;
	b=F2+VsIhgvnwXcPw4NBraDub6j9FydvcRhMm36/iWZDaWHjTaK5kfcu/krJv9esr0CTtxKQ
	2ryiDCaIYqolvI1TmZoqoLFXRmiH2DEa/OPXd5GeExpVP8GbOY7OBqw8kLClmJ6Z3AWumm
	Wi0fz+tGxK/mIi8G3V41bUkn4f+2+KA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795456255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
	b=xt/Lhig04Tz+i/pEW/uR3F5bV859TMzQ8VgvtukbwEvxG6I5rxvQEhz4Lbu6qq7rBykxN/
	Hx1jNR99o4LU8OG1XsOhP82tu0Dfm5BXtpkqbI2B0wrPCCbmb+z2BcI3P0QOyYVCm6Rsf1
	F3IJtooAAAYmCWTrhPO+PVzesnufGq0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Yzqy+haz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of namangulati@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=namangulati@google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb6860f867so102605e9.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:50:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795456254; cv=none;
        d=google.com; s=arc-20260327;
        b=FbkHkvQTHEBeN2vBrsYVs8YrwH+ZbI9FpMVtiWKgTSBx/WNnDKVnXlm/7YhXfBKcXB
         eFLdB6qmEBU2Z8lxnBX7R+gGaF3fN6k0YNXmK5UF+0GFyjmU+0SIg29QwSSDWmQ+Chu5
         nlBmZJSU/VdAmBUQotaJaNl4WhRX/CuhyVHYI/Sx5E65O0GxMLDFAjENpF+X67ZVo2az
         wATAjwxZsGvP2mpUJXxRHguDZ08nrIrYDu4rxWwFRRxlNJjD8/gY+aDefAZBLUbq714c
         QYZpUPE2m62Nn2PQhE3yG2Dhz2rDPCPqWjEuPN9g6Eg1SnHozwN1PMAV93B9PnDBDKNT
         9f+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
        fh=qnX86pBn3V+qUNvw604fcGv5X3pUL1RO1DK5BB3ord0=;
        b=AZDA4jk/0Q3RCDzTWfT7cyIoMXbknVjpkPCSGNQnzb8ykXRjw/jOYY8qIFhvk0RFp0
         pUbbH9vwtQMmPBwKpQON2Ot02g2sKAy/DuwCxlbMOL6633pr420ysl6wfc8GofQROzvx
         kWUgYj2Hu0RP+aJytljanYPfOZ6+jteYv7nGdikiTu8AZ3vZJRvP14Xwtuz4ucPld7Sz
         jGBdQ3yMpifKn9okZV+ltGZ8QGI1QxJ9peLfz9OOLHX7GJe4OprvOJfdi+TXChQ0TDZZ
         PBINSR6zsLX9y4oamyHe9wvXJq7RxEQ3pgeJ12cFev6W9WM3jbQWBLQIRkAHT+iTJjc9
         8Efg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795456254; x=1796061054; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
        b=Yzqy+hazPWsnfIgC3OmYRQadAXIgXXK14iWYaXew+Qqfj22EODRFeIYtLEasVp8xy3
         DPPCHr59HK0paGFZOqUqTkpbkQxf6/pQhh8ioMyBRQW72Zw1p15gqAPBVlI5lsThR3SF
         9g9JBl8mYrBLn4xruHZctoWgfZlCgpbFmt+9ct+JAChFVdJ1F6ENR6Jpw3St5Rlqb9GV
         bUXD/rj85cPYQSc6Lb/Y6x54uesym3z7hFpvbykdIr/pEDaa/Ua/yN5f3NEHeF8rZwKo
         E3FOj6oSDSqRbsaLFV+LjPizBuIjroIK8u/lhJvaTFSdcqOkPAsdpXbTlWPtNkv7rQzc
         0kog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795456254; x=1796061054;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
        b=d7ji1ifrsQ+7+9r81/AJzotmkZdfRN1ontA9b7Xx7oLuKthN+rSPqBt30aM3aa/gcG
         qKrRtLAi6AdfB7EtdD+uVRZCH//B7UykZn5cSolYx1lPPZaC7cScQo7LnhELZOMyXfpc
         yC0vFtyYFAOPlDeis7bXCWEMvWLMKO6sTwCuurO+gziyazAJZBUUVhBvmE+GMPF2H2LH
         ka1TYW07kgA90X4xnkWWwlODKssLb1Jm7yBFmD3wpaXdNwonYFrg5tGFY3mTRPf5bdVr
         7P1CXqZJQ1zxUlU3kmF5FaB605StqnHHoLJkCE1F0KOZiKnkzE+vSLeYyjJ2ioa8b3eN
         pWLQ==
X-Forwarded-Encrypted: i=1; AL+hErF72QcJ/n0tgmpIFrPWSt4MWRskNSQ3L/z6Pof0GTsSC1MBYfGapec6AX+o81MEAZ/WnuFHe3mjjw==@kvack.org
X-Gm-Message-State: APuU4Z/TFoPI3WlhPXGgZ2TrhXurxGKKjoo6GAxWKNGq/+lphAtFMl+n
	jmrYVDdW85w9EkHms7ntVpZ9v1yGSVF19kpqZ6PjYv3UTbisurTGvDc93eltBiEyQy9woIiwWP4
	ptIXU1xkJkmnnzPQsPuRKmOJXwernPesWLDmUZOzg
X-Gm-Gg: AZFdTZeg04KflBVCwSj0hqEl09F1pRoT7SegH9buDAR/1fEBOqu+dyhbJQi9RnT5gEh
	taed+WvQe5lGJuRyk7Oq/EmJI9+FFHOyFt622tL2jGgscyu/W79kJmz9MPdKh3xAXDpK6w2iLXa
	O3F/2MpeXbPxEQIvLmiNippAwUOYzIvVm+Mqvz1Shxn+ja9SDE/KcjiC1lAoHsekq8ThX5RTdYc
	z05nldPIUUdx7u6lRgvhszA/veLzBN0UG0bF/B9a5Ok58+FKwSRBgtAj4VUeUh95nr/kEdDh3Ky
	5SjvMW3zuGFcDpXaOrKfMwwEHNIeo4WMV4vwjZ97HEgYeOxSRQKLhSXcq8UJSVIlv7xHUM4lCZS
	o4FVDMMqhfZNOvUYDJ7onRMrTnGDfSwirAkli3lRTc2vQmRvQ8BfDszmSb5Cu0uMjXa4=
X-Received: by 2002:a05:600c:287:b0:4a1:e368:cbf7 with SMTP id
 5b1f17b1804b1-4bb909d0619mr1867585e9.0.1795456253076; Mon, 23 Nov 2026
 09:50:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca> <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
 <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
In-Reply-To: <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
From: Naman Gulati <namangulati@google.com>
Date: Mon, 23 Nov 2026 09:50:40 -0800
X-Gm-Features: Aa3M54qK7IY8ZMBupflhQ8_7jK3YPX7yjpTGqvTp5f5henwr9osR6FHQsicVdiQ
Message-ID: <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Luigi Rizzo <lrizzo@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Dragos Tatulea <dtatulea@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j4yims5e6ancg5wd3dzqg5i1f5f16q58
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 24207A000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1795456254-941241
X-HE-Meta: U2FsdGVkX18lM2qzY5VCxtO74gIJyqNZOZDvdf5XNloEfIyEjhzcdoz+b+fYXYnh6xBD8em2xDp+XhUrHsYEHwFJ/1VXFMOUkNJXqnzBqCHlmbX95UqD7/QwbmEWuC6zmF75qHjatoH4EyapZzgItKougoANsuaaNfcKjWflvbWHfPdpKkN5foiApaUZTi8DfQZneRYCVX1438D2TxEFSTtocfznypOE/qENuutqWG5HELgyCnSvo9TQ82nBsJBHzCgjwUqE/ohkp7124cmANlAAF6NfppmIrmgLwDSezkMQaQvdv2eIHBtZyYuONacdZQwT3sPoC6H6xtUKIyG8qVgLaltqQUULRIMJkK0dvJe6Jq10ZMJ4hwgy5RSKawvCmTDN33E8zSrDOeUprcPngOJu+/2I8m+e9raBEMjrWD50dMw1Nd0Sc6icfCLE8w71spnYgBSriKVoeZGFZWG86+h4Ap3eM7axqGm9uB35eBEwuBMSnrardHD6IK9XMYCnTDlNKqjaL/eJi+EN+C9tXBmYSFceNYDvdPYcrsRw93bj/r8FiGQxuIFTQYzE9THi+Tl819Du3sAE8SNsE2AfiT0zFzWKc/MTZC/pD83bn+GsUbsTRJ6zv8TJXKcF8iYW5bh2FiDeyBr0PYGz4SV6r5IBsEta2yB6pk3zWg3MpTkTtlNToqPJoVbWsSvydpj+WASRbyzAt+MEPUozST6VUbvt+mxdvS0TtVKlWKumzOH8za/ifgIyCn7rUJC+xoy620EcjQh33p7A/pxVr6c3FzDQV+U5gnxvI36I8mnDPOLPHLYUD6alsvA5rgpOtf8Gz4e6QnktgzciRXBoZiNJU4/DvAy6VxSU//MLbVhAoLHDbViFWFVKMjMpTBxqMMZtFKq3oheicBbjiJenFBUE1uad+mF0ogz8x7YxZEpMzUk+kwVc3gKC7II4+2IMZg0ioySfKVRnrN2zNy3cqHH
 50ZrcD5X
 /k0cT7t2kzMoZ3pPesUWsE48drzrZNxtPVqfujII3ZNrt54Bhvb6tnyCqPE7VTvDoyRPSf0OIs4vZsMF6DctrZZw3bFz3NGvId26CyPFzlu7uJo5IHoYv/XBr77+g7aqCI7pmV405qSDDRTOoRcIKo5l/DawOC/Zur3QuOSsuex6CEz5kDWqQT3Ue6SI3EUsTRzG1nsdBP+6Ila1gw7nVQEEwQzD3kbUPErgXPt92x5j4u14ySu8kl5P2pvaOpOTD9M4akOtznnstSZmwAsJrryW5bwl0CTQbK5qh9j1h0fI8zuz+deN1Yq7lyULswOzZhnUuGHbA/j84u3cSFKPQJ+q//dPnHle+42iagrFd3D3TXch1tON3d6BtuYEtEfXDB5f9JRknB+Yk/n/cac/zMq2DZi8FHsv74R+cjY57dbvyAS6Qw2q8IZRmyUexFZ1OPZxQZGlkqSBJ/zXVIYH4D8c4jKXYbWZ/Yw+EGEGKMBIb4GcLXnsrG2NfRtb8h8WSD9hAkAELd6yOkTl/fGEgwr3t42ZEghbqZ4i22PJiHC8cSomFW6kj3EFlMiOx3GaWgf1mWUv8HeGdWEN4SCk5YkI2wa2vu/Zv9+suZTIh/IhdPSHok5yZnNAQf1dHREtR5iWrpScy69VnwKBHy8dlm0thzDjjxpVm6g64
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 2:10=E2=80=AFAM Niklas Schnelle <schnelle@linux.ibm=
.com> wrote:
>
> On Fri, 2026-11-20 at 15:19 +0100, Luigi Rizzo wrote:
> > On Fri, Nov 20, 2026 at 2:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> =
wrote:
> > >
> > > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed=
 PISA
> > > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > > Documentation/core-api/pisa.rst (patch 25/25), which has the detail=
s.
> > >
> > > I thought the conclusion was to just do this stuff in netdev pagepool=
,
> > > now you come with an enormous AI series spread across the entire
> > > kernel?
> >
> > There were surely comments claiming nothing outside net/ cares or needs=
 this.
> >
> > I respectfully disagree, witness is the fact that e.g. there was alread=
y an
> > io_uring proposal which is smaller, but does not address applications
> > that want to use the standard disk I/O paths (libaio, buffer cache etc)
> >
> > Nothing has changed from the initial series in terms of size, use cases=
 or
> > subsystems involved. Large files are placed where they should,
> > the series covers the same three use cases (disk, network, CoCo), and
> > touches three parts which it has to touch: mm (most of it; it is a
> > memory allocator
> > extension after all), dma (it hooks into map and unmap, not a large cha=
nge)
> > and net (the pagepool change is a couple of lines; the tx path needs to
> > touch more places because the current stack assumes all paths have
> > the same I/O requirements).
> >
> > For CoCo, there are very fine grained controls so the bounce buffers
> > can be enabled only when they don't pose a risk, which in turn
> > depends on the threat model.
> >
> > Specifically, for network tx buffers or disk writes, the user-to-kernel=
 copy
> > is basically a bounce buffer provided it is used correctly and not leak=
ed
> > elsewhere (which is the design; of course the implementation
> > needs to be verified and possibly fixed so that it matches the design).
> >
> > cheers
> > luigi
>
> Hi Luigi, Hi Jason,
>
> I've been lurking but following this series since the start. I am torn.
> On s390 where the IOMMU is always enabled on our closest equivalent to
> bare metal (non paging LPAR hypervisor), and where we also default to
> an emulated IOMMU in KVM guests, the underlying problem is a real pain.
> We're also in the process of enabling large IOMMU mappings via the
> generic_pt API which are 1M and 2G on s390. So, the idea of making
> better use of larger mappings is very attractive to us and I applaud
> you for trying to tackle this very real issue.
>
> That said I do have to agree with the critique. This series is too
> invasive, too unclear in its layering, and most importantly it feels
> like you're trying to do everything in a big swoop ignoring advice from
> the maintainers just because it would limit the scope of a first step.
>
> I also don't think Jason's point is that nothing outside net/ cares, I
> think, it's rather that the IOMMU and DMA layers already offer the
> tools and each subsystem needs to use the right combination for its
> specific requirements. And if a tool is missing this needs to be stated
> very precisely including how the addition keeps layering intact.
>
> I don't claim to have a simple solution to offer, if I did I would have
> sent patches already, but let me state my thoughts. First I think this
> really needs an iterative approach with much smaller self contained
> steps and focus on specific issues. With that, I think this should
> focus on the network stack, while the io_uring specific proposal can go
> after the block layer. Also in my experience networking is where this
> hurts most.
>
> Now, I wonder if we can't start with something simple. What if the page
> pool could start by allocating in batches of PMD sized and aligned
> folios of contiguous pages that can share a single large IOMMU
> translation. The page pool can then still hand out pages from that
> batch without having to do sub-page allocation but would already use
> much fewer IOTLB entries and the locality might even help non IOMMU
> workloads. So, I'd even hope this could be enabled by default and this
> is actually something I don't like about this series, I really don't
> like having a tunable when we know that larger IOMMU mappings are
> strictly better when you have an IOMMU that supports them.
>
> I think that approach would also align with Jason's idea to keep things
> within the network stack and to work with the tools we have until their
> limits become very clear.

Hi Niklas,

I have been working on this idea exactly - extending the network
page-pool with a memory provider that allocates large pages, splitting
them into N smaller pages that all share a single IOMMU entry. I
breifly shared my approach in the v1 PMD series [1]. I'm readying a
short RFC to share shortly, would appreciate your feedback.


[1] https://lore.kernel.org/netdev/CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+=
BJRVYf3JB1g@mail.gmail.com/

>
> Thanks,
> Niklas
> > >

