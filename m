Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDEBC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CFB6B00F5; Wed, 29 Jul 2026 10:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01BF6B00F7; Wed, 29 Jul 2026 10:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3DA66B00F8; Wed, 29 Jul 2026 10:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C19A66B00F5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A89414069F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:50:47 +0000 (UTC)
X-FDA: 85041647334.14.A61A701
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7504F40005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:50:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2lsqEoY;
	spf=pass (imf12.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785325845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RW4sNREqQBsxBWcBVOxGkaAhxGnf2SK3CsBZlJEr+CI=;
	b=YfQ3gulEC8vg1Bw0kirsITfbJN8NvPmDnHpngVNPVHv2rUnio4v1d+2bn+saLyqkKtcDtU
	4APy1WS9WwsuFt3JES0Yp1+gs7A9nmdpqsrcwoEVMyTtP6GNm4zCjQst+sCqaMMHmTZTbU
	PIlL0zUEPNlpFC5PH5zAyR+jfJfzHsY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2lsqEoY;
	spf=pass (imf12.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785325845;
	b=tLSG0e+8YwUg5RC2d9g8SFqE+oGlqOhzYDj2oTmw/xzEVb12PA0LuB8CJaeqE6/lbd5MVN
	k0WR2bVn25nT+zmpIa+3RstZESyJORhxY5/sMaI3QoaGv/OVbenx2QNRtyD4QmbxiSFITD
	m4HwPeNsuEUs6xCPzprrKDQA8D7Zw7o=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785325840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RW4sNREqQBsxBWcBVOxGkaAhxGnf2SK3CsBZlJEr+CI=;
	b=r2lsqEoYAQ1KGpOstBBL26uqJoRA/RKskIVz/NmP2P1yJGaJGxiK351ItTrzmwafZrTrgF
	N3Vc5HNWYU1L2pUZk/uW+BQB/+yzxmdArbOwj40bXQCJd+LfcHhw5WJrU4lzVIGwsJfnLj
	EmJU9F1CtAj8Nu+CAAOxOxo9skdsMYc=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Jul 2026 11:50:32 +0000
Message-Id: <DKB16T0X5I9D.2GCNPBS9VC95V@linux.dev>
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <brendan.jackman@linux.dev>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, "Matthew Wilcox" <willy@infradead.org>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Jan Kara" <jack@suse.cz>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Chris Li" <chrisl@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Joerg
 Roedel (AMD)" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Huacai Chen" <chenhuacai@kernel.org>,
 "WANG Xuerui" <kernel@xen0n.name>, "Thomas Gleixner" <tglx@kernel.org>,
 "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 "NeilBrown" <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Trond
 Myklebust" <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
 <iommu@lists.linux.dev>, <loongarch@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org>
 <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
 <al5gQgnBCjNCSD_4@casper.infradead.org>
 <51810eba-2a60-49f9-b879-7f806546e600@kernel.org>
 <DK5767A146ZW.3LV5JXS7T4W1C@linux.dev>
In-Reply-To: <DK5767A146ZW.3LV5JXS7T4W1C@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7504F40005
X-Rspam-User: 
X-Stat-Signature: zop1h6j9rwg6mhmtfi7gxa8n8woo9dif
X-Rspamd-Server: rspam04
X-HE-Tag: 1785325845-961212
X-HE-Meta: U2FsdGVkX1/R6FDXtyO3uNzXh0oXYaQKY/wiHGjuHp203qrx5GMhhx7R60M+64FbaTprzTJDD8Yua9U2GpQ9uAR9Vl4pIuCJpbwydJIb+UdBGWcPh1kS0BgY94T2f3P7xnEwfIgw3xqXwYzq8ggHr9tyFKEzbbfHW/6jubLY0RGPZkBTo88fbnqVNaJ5EPi2RB906LRO9H3/aUGFeJsrku/U1/fv0VGRAVOPnNCo8qsHukuzsw2r8xnQYNad7ApB+m8Bw5Qk9UgoY7y1cEBUN5ts6gYEJUa7NDIPrWgYM8wgL45oeddxwtiWEojwQVrGBJ1q8zcQWz6Wub3QbImTB+YkfjutRZ/4Ab4JHR0BmaVGim3YGfRXDLrE4LBELhwYJNifT0UpZIbK/Jb/zkttj5/rYBMPttd6yUs+tCRoVkxr8s9JkGHHhsW/wsPbD3E6LbIxQKg+XwdxBQ8jRXpaK/JWm76Vm1ON/8SFEXoCZnxMGtF1rA+H2mpyJVcJfbSyKC8QuKTowhEQLrmL0n7M6mG5A5usO9eINPLaG5yNOYSazl95Y1VLcYYF8TwcSAJ3vaMqz1m+mFklsaTAjljDMUxhv3JVfaAZlIM0X7LvBjqcuOao9jT0C/3v8LxyEA7doiHfwYzXVU6kUmc4WHQp2+IruNIHlAigS52QPAXVyemOCF6V4FBuLQcaRqJnr4nyTHnczRnfEAsPpcguUcLSsafsBQtBO5bE0JfdBQ/6vNqK96/qtp/yldJDor/OBiVO272RE7RlymrsJJEp7Pq4sp44X39iXU//XL7wBLW/eRDtSNLleovEYvIekN3RQLx3JFts7+2qeeCFNEBpC9FtywayxB9L4cr2nHEK/chiAnCyeAyFur0J+n6LBJq1B4xYigNxdNB52lk0Ybzo12yEsAMgCCu5ro5AIiLc54qUpa3vAWPGKdhelWIGcqZTRQ1CMcitTjHi4ujakIh6+wM
 t10ksBGy
 xO5Xl8bCsnZ0Ju+x55TQBemgTbdwc33j3Wlif2iR1mkqAGafl0j9n+dD9FsyDCNlya0qov9Mi4A4f2ZXAqUHR2qK8z7X4WKmqwPLj6o41YF23rTyHN98JQ2N4wxpB8kajJ0rbT11ZEx3uU6iQUSMxCp/XR6BMSzzhVd7IbGi+MZ5f4waXJjOSrGPJszRGjXrnid+Clp2CImi+9aZf2agI4l85lDeH6vBZCeg42keaSjHHlZAB9Z952oSsicPXy+NPcNbCYM9TDxGIQ/hPPyR2u+Pk04fRBN1mALCXEbyqFBJ4sZOn+boVWjwzhrp+8x2xsWv7CDxFHmpc1lTMW+BrsZymTgeMvhpXdZKdTZbaVDX6eu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 22, 2026 at 3:15 PM UTC, Brendan Jackman wrote:
...
>>> We have a long history of people just moving stuff around in patches
>>> without knowing what the intent was if it should be moved.
>>
>> I guess this patch is not critical to the rest, if that's an issue.
>
> Well, for ALLOC_UNMAPPED we really do need an alloc_flags arg for this
> function, but we can always just go straight to what I described above.
> I.e. I can create the __ variant + wrapper from the start. It's just a
> question of whether we prefer:
>
> - "Yuck, there's a public wrapper here that we don't actually need", or
>
> - "We hid this mempolicy API and people might think we'd NACK a patch to
>   un-hide it".0
>
>   https://lore.kernel.org/all/20260703-alloc-trylock-v5-2-c87b714e19d3@go=
ogle.com/

Uh yeah so in v3 I did not depend on this patch, I just went straight to
creating __folio_alloc_mpol_noprof() here:

https://lore.kernel.org/all/20260726-page_alloc-unmapped-v3-25-6f5729aa9832=
@google.com/

So yeah I'd say we can just drop this controversial patch and move
forwards with the other two?

