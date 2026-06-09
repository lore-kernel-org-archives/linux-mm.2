Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EBDCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F686B00A2; Tue,  9 Jun 2026 06:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3309D6B00A5; Tue,  9 Jun 2026 06:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F036B00A7; Tue,  9 Jun 2026 06:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 130176B00A2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:04:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9D2DC1AEE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:26 +0000 (UTC)
X-FDA: 84859939332.12.3D02020
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 394A71C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMqEQqfs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24LLS2IujXIsxqj/N2znkwF2LDRJBt9IcN4tpduhzAE=;
	b=DIWonpX7jEjVAuSkMofkv8fzVMFE7j72oMxYMaxw51dfnx0xDhqx3Wil4I3dL/9HfvwLIX
	ge5JZQuozKV+TVPIqWaY0fCaeqYLfqjHJmHdMgFAGsJi0ZahCo2z2F1dKyyAbNd1CJethh
	qoekpTjjC59NVuqhhQwsSElX5K3s+uQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMqEQqfs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999465;
	b=wMo2/dMvqbcNxtgcQPoUfcUHL3uUn7nQYWW5jAFnqemFVX9Lc77knEA5MYqX7i0Q80977J
	gnpVM0CkgyyTM2YkDVQEVctwFo8SzRGmRn3g6I/7r0wecq4VLnk9zzO2DVoARoPB9tN0bc
	5+bp26ATyAwBlb0Yz/Q+OlaTUTCY1os=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7835942ADE;
	Tue,  9 Jun 2026 10:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F0F1F00893;
	Tue,  9 Jun 2026 10:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780999464;
	bh=24LLS2IujXIsxqj/N2znkwF2LDRJBt9IcN4tpduhzAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PMqEQqfsqjHJVuhYQMqXBYsaeM5c11yAnSX6xVGwLIcYg5Yw3INpoCNKJskFiSK0j
	 QDyEmE5+nMlosFDj076ls0CDm5m7Wb6d0TTKmdbQ4Aksg4GCEjK6+r4Z3M7HLS6PCA
	 rgrUcoaWQXoGZ1cqNdEwg34FBd1FL51/1cKLXVFYirvtI7z04jfLVVF22jYrb5ELWc
	 OV71WWrFihbTS3XI1GQTka39+gd47rgXU/MpkDwvVgum/mFqzrkb+YFzV8mftijhv2
	 /GMNhKqLDCHwC/EXKK/UF6tj4yVrkG5u+9YPYsikuxP6ZDOsjXZu3/0Rf7v8yPgDVa
	 sqIOYM43j437w==
Date: Tue, 9 Jun 2026 11:04:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: New design
Message-ID: <aifkpYCj3CuERL4q@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <aiePVsiV-w-IZ8A4@casper.infradead.org>
 <20260609033042-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609033042-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: o3njh3hrcat96arwq7k1j8t6kyn97cso
X-Rspamd-Queue-Id: 394A71C0002
X-HE-Tag: 1780999465-308000
X-HE-Meta: U2FsdGVkX1/VUJYTVP/R3DOxd+pJyX708O8UHz2/afsLx2mPiU3CwDFEJNRQFm0siwyYYBDPfrp3chcMeCOBbPX38p5TimF6XdvfCB5trINMZrq4WET6QfWaZ/+O7hTC16XRtunIfXaOGDXhaVX9ZEuFllszlVXYv5C3wvGdkKwB0OeScmXlqBNZBM1nj8qzlTksYQdkKdtIV3tTuvJEiHO+ptgejqhKR1ngpoplZTJNZfZoMMokmSIo2cRJDwfoBQqgaM0sGUuOGS27KDp0SB2oiMgnOTDL/viyo7hOrXY4ibjcbKCy+ZOgbxvArFF621kwI+bHbVDBU3GJX0I634Khy2zm8Oyl7TefrzsJr01flr1w0/OokWR6fY07yhtkwHaE/mhstvmKe3oII6q/6JeabuPUoXOn4z6MAYIugDZTUK1XO30lEa0U6vXlVVVJfJzJocBM8cPz1V9LcxDVvubZbe24FLaVoAYHArW6YHWZn26riWn8IQ6/4Cq9c5ycuDKKQulb2ZdGPavtfxt6XAB8zbBUPFD327E7IKX8XS8kxQQZ/CHX4YT1Gw9pr2/ICMZspyQ+S9zoQopL8bwYg27x8W8VkGJELdQ+h5TI9dyn8DsPZGWKVhx2veXhkRepa9SdTrFpZNgRB2HfZrmFihOguk5kKLN+5J4RE0EiEB7wD0ERRrUnDMKnNWQWWEz1ptkfknLE1I0IEgRJpkQ1P28o+E5rAXa+1+J0PV1HEIPrRhkXDGPnk5eZ9aW6lwkyzZJJev/o5XH21umxQXS6mb78PtbA+zds8TafZvgyHt81DoG+cxrnMsOPNvG7hyyHRa6Xf4uBWVkpZsLffcGKeaneWgxxEB9tg5+A3+Zc5brkEEXJHYdmIJaxDQL9rSM/SyjIDFzKfDg3mHrP1Knr+BKlGSSE/AiSm2YRVe5JhORD0fky3IN4R6kmN/V2Rgv1JRI+cG57TMKa1uNHzAW
 7HXU32Lv
 o6DuNhQUsthk13j8PpOgxDGAKLF0iNzecBmRF1uVgCL5OVlFe38jOpZURx3mSfl3HWL/CyLjH4rdCZU+rsOXLWrmHvSsOSV8tU/stijxISiy9WHSDQ9OUTjQ/81KEFcJoy3GsvZtgy3k7s7Mjjkf6+JrhR5JnwIp2k/GeYhIPSrBucCcMTLa+PUuVh67qd2chf8SZEh/GqHJ79dFahGhxXjM2OVTgZ0L58jmJN60zLgeQuO9xc4uqMW2ZPr7YZ+448uypB34kojIx61AxC1fPjTbxz5LrqZJIUS4Uz9NYaBga6Exlbmd7dif5aRkyHs6YKJxIwBAwUf2vnuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:06:08AM -0400, Michael S. Tsirkin wrote:
> One other question: would people like to see it as a single patchset
> or multiple ones 1-4? Multiple ones would be easier to review but
> of course this means no actual perf gain until part 5 is merged. Is that
> acceptable?

Personally I'd like to see multiple patch sets, not all sent at once.

Rather - send the first, wait for review, and once people have given tags,
then send the next - rinse and repeat.

That makes life easier for review, allows forward progress, and avoids
noise on-list.

>
> --
> MST
>

Thanks, Lorenzo

