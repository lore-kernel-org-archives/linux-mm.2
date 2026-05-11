Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539F3CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DDB6B00EC; Mon, 11 May 2026 12:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74DF6B00EE; Mon, 11 May 2026 12:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8B016B00EF; Mon, 11 May 2026 12:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9789A6B00EC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:04:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09E9EA01DF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:04:02 +0000 (UTC)
X-FDA: 84755610324.19.C947D5F
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BF6F40011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:03:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="RfcKZ/We";
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778515440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dApXG6ORKOxT92uQJAxaYBkfzHSro0hmS5CsQzIt91A=;
	b=Rgm5PoQY4lD41HFUCZMfZP3GU+HngMMNrKThOsf/VLgxKAzofkj2BFHoLWSyv//RpzdqzV
	PQJztSzYHi+I+tMhOpyvXEfokbKzPCKbMFkJ5S1BZx13TFS+B+0xblRDpPH/6TEKjQRuzL
	25ws0TTDVCiRJ3kBgBqfUVqpyAGsR84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778515440; a=rsa-sha256;
	cv=none;
	b=SszXoRcpxlDzzsqgk8udpBBtntw8Tx/bvD61p9KJFxEpjCKxcjGBkxFD++w7fZ1H89pnFl
	f93aNWe94Sgi+lrn1Ntb+kLohdVYh18bCTy6nVLDJx95JvGYsStYvrOyslr3C0rERAxueE
	3Reg2csrWBDrG2GfDPPR9KCaolmV3GQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="RfcKZ/We";
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8e8c0c2d2bcso587298985a.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778515439; x=1779120239; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dApXG6ORKOxT92uQJAxaYBkfzHSro0hmS5CsQzIt91A=;
        b=RfcKZ/WeoI647vpQvOi/e/5cNvAS1YQ5qYK1kdM3JG5nlIyuNHi8cmD8hNM1qkL37k
         /tmAWzfIpFmRk2npSNaYLh9zpqA8M1imk33eZsg6OBVk3MPWp1zXT8MFhEa31K3BrZQY
         lrxXWBh+lc/rYGjGuqeidcQKp0yGLSp/ZiflQs0yb+X0GS0pzPbK/dHplyvOYOn0m9bZ
         nrqXoR5GZ0okFIV9Dz6HEJRp3Vu/+wcp5RypQ8u4wJf3WgmAposBI6DXIpQp/LHNAkm+
         tUbN3dg097OaacLOASMrD0D8d13IUoUe06HLwDLwRg3k3/AN9CbHtwTfyD6KuxNeC2rs
         9Y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778515439; x=1779120239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dApXG6ORKOxT92uQJAxaYBkfzHSro0hmS5CsQzIt91A=;
        b=rCJHydUnt3ctDqWmwYHt3etKNWDy5lInqr25H5KzHdzyhDZ1eR7q2xV88VM1YcK/Zg
         exblkKII6hGD//Gw8p2f2tm498I6mTftZFDLnU4hklVJzawGnf6PhoMy5Q2+o+NpzTxm
         xx+z1GnKM618J2eU1xFo7RwF+TwMOamAON2JSSCgMvYfDSr026jmgHx8fQ9tv5qOUvkX
         bNlxi04uj2AS+s8lgnzeADK5lzFN1P/q+vX3bbpgKGdnuKcu6i9AB1EJrZpKlXaNtmlX
         mpGYHhkvr/6XXqOMt3v/oJ8IHIzBopgi7OmoOTf1QAl+EgloeyA3Z5/cmao44MLgMnoj
         5+SQ==
X-Forwarded-Encrypted: i=1; AFNElJ/3XDJ0MzpHavzcVde3VAP/btvhWF7QDLiUr4VhDjKsbdqGxJJVv+9FMYm3nOHEn8caXJQvk0ySQg==@kvack.org
X-Gm-Message-State: AOJu0YzfNWQdHOrFLWBGDmvlSpTjuT2GRqTicS61KLGk/wiQWvF1Pqm3
	FC7pdBn5ZSRxJv39XtA6QgjHmFKKbTOwYjwCSiqDAw8xnUaX50fth/2HdUK2ivkM1Vc=
X-Gm-Gg: Acq92OHl4wEOz/NnwIBGpoHTKTHsN2bdO53n6Gv1cuVhC45WKyd8I4Fx7nd45BlpsZO
	SODTlveH1RDTeStd2GDE7SEqPWSKhaFaeDsKOIyUK0U9FxYrRCqEQ4Slr7epFfjc1NihThWIjjF
	cGD9+tuUI5kG+B/x5GQWQC4KSv89/lZcMJYYptubq1RTtfxbVqs/uIenCNSemv1wCwLkI1/Hs+e
	ekLo3q6vCNvEU2h2VMS0DA+LslVuLWeCHcPEUwRvdLWIeiNpgzVWJtxPGuXMDcB1lMNl0N6TPNB
	N2ygDyNYclYqnDuZRBct2KBbShk+We1fARzWSmJtU9UKDrNR3q8nj52xpvCuvAM23sTYN9YjEph
	VTzMoX3lTVCHd54DDIoBYtpD4xTJyvZ8wJOMu+o0mAnVWOyR8XCiIyyv43wIzyg3FOWJN5iw21L
	aCix/DKZ7KLsN9TC+J0gWF6go/DlI+GMbbEIalHf0ruvzL0ZfHXLhQJNUzBDoWJ3LQ+verln9OO
	gjFgHfcfFt8
X-Received: by 2002:a05:620a:410c:b0:8f8:c91a:212 with SMTP id af79cd13be357-904d3fa3d5emr3775977985a.13.1778515437606;
        Mon, 11 May 2026 09:03:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b9c542cdsm1091199885a.0.2026.05.11.09.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:03:56 -0700 (PDT)
Date: Mon, 11 May 2026 12:03:53 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 09/30] mm: alloc_anon_folio: pass raw fault
 address to vma_alloc_folio
Message-ID: <agH96dQDtDR_qYHU@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <96bbd5dcc37aed93a9b7733780bdcba4fdacfa3d.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96bbd5dcc37aed93a9b7733780bdcba4fdacfa3d.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2BF6F40011
X-Rspam-User: 
X-Stat-Signature: fd33jfp7tzbmjn6h3nbfaffk99jx9ibr
X-HE-Tag: 1778515439-758292
X-HE-Meta: U2FsdGVkX1+GMwwG2l0KAppwhYlphTibzs2COdul6RvberLkxqfPxktGbRc6d21X4YXrYyWpB6xPE/lK5/oP8aAl87+rfnNp8N5QHHwvxcRgC6eJoFqaIDuG+HC+bOtWAuO//Qsvpa3AOc9RWsAwKh0c/CDn4EktearuV/esufN6R47EpsumVJR/uEri2AUWE5XcdgbDk3KD+9GZpOM1Ns8rKUKqEUeYlrn/e6KSx+MifUOwt4UNZlT8eEoQ9Jjh6fcAo7111/Uof3UXEwy5Col38IeJyd1YAFSm9MRNrkkzJ7TC5hTmsObdVT5/XUba+polCfoy4kJXXSMXIfv3M9AgWahKN1ZtjwRDtvSVtt4lkmUa2vZ8W35m3CoOx3lazQPg+JkIQWOibZIquW/joE/K9uGRGzE55IsdsasCPLUF44DlzX2YoH0v9RerAMVbv6iCYEkbUlb62BBP6PpuartzpoqZ50y1g924lQHwRXB7ZTGb3AJrJoBRwiFzxtVkQa0SlJKm77g6IlCgeZY8wiGZNSES4RV/sWeCv3V0KwvE0sl6ljfk4Se4sQ2J+eSMC9IssFUz/dnpvO+dtMnjDV1IIYmQhi8bCrBoBlLm0XWW7X1Huuaequ2qvDOhOP7HV7deXwGjp0Cf+nv7imvRMrACgeVsMTpqJiNp+gBdVqmadwEUV/B0IGO/fHqJ4w0T7ma7knKqvM+Yt4G1AeEmHnb84w4RxFW2xFCAe+XH6hm8GaCDaMteD3YZOOB/mj0T0F2nJ5SfK/VCrUkDk8Mc2ScNBIP3rd31+eBiPEVOvlb9kSlGqJrsFsvFSHKa++qRaWlwUkJ9ppivLonevZXlG2vBCOmi5cSsyBeS/APr0ulSoq7q9iy38oZJzYVjBe6GHYBLV867pXhdHMB1E/EhbCBXYkl58v3XHPv+aeDevKM9SQejGzdFVqtyVTIafWV4ZIW4tiX3hPqiY8+2jFl
 X5JsTW4x
 VZPuTb6hPx31gsb8g976yTGfFghg895u5p/n0ekgN/xztakPURN5oY+CDhnD5UY5IhRfgzqwKc14sg1YRjNIYvFc1r3Vhik5VIhElbeR7JfT1LDjsmSGdznn1w5mL6BCe0epmZV2PbwnCjmyue+rl8wiwYRCNH2lfJl22VHY37T96Pl8SUVlrRPCksgpPrf2QELL2Xfs6Vdqn1AxKdctLFzb+uv/VffGrf1ZV1DZGJaKlbMitQU5oi531SnEDvaQT89j1hoBfBKb2dZasfcWK1tAeCs9I0uEQlZyPz90LsHx4ttBniVcZ3Buaog97610VJU5ot+I2ApiyWt50wU0l6RCgiWVzToLO8Xtc0Vee5bKld9zOO3F4637X1HQ9oPgPuxO72DOqay4usTQl4NWuc8BBsjlbqaPLDbnjAh9rCQLEE8djgb4bhVkwVCkUctw0FVLoTf2uDCiOydd4E/0S+733wogbB7iU4szcSfwcEnKmPoIb/2l8BNEQ8JiyF5/Vxs8qOaaLxIY6mKTkkl+qkxX4iVME5Y/bPctexiQRzAMPIfbTdqhwJ5J51zh3rj1rbBmlJQothrosbOSVFoIhP1PWz0l504sJzA5x9ZU2Cx4EuW0mxkAN94M3Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:02:32AM -0400, Michael S. Tsirkin wrote:
> Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> vma_alloc_folio_noprof now aligns internally for NUMA interleave,
> and post_alloc_hook will use the raw address for cache-friendly
> zeroing via folio_zero_user().
> 

This patch seems rather far detatched from alignment change.

I wonder whether this particular improvement should just be pulled out
ahead to shorten the series.  It doesn't seem like it would cause you
too much churn?

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh

Reviewed-by: Gregory Price <gourry@gourry.net>

