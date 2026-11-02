Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B0C606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QeS4Sr8R
Received: by kanga.kvack.org (Postfix)
	id DBADB6B05BA; Mon,  2 Nov 2026 02:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AE36B05BB; Mon,  2 Nov 2026 02:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5EDF6B05BC; Mon,  2 Nov 2026 02:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99AA86B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:11:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ECB8C0C2C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:11:26 +0000 (UTC)
X-FDA: 85389308172.09.C68184B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C819840005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:11:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QeS4Sr8R;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793603484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtRFjMNFkycltbDQSBe6mjghdVPgzyjFuuR6JFPrfYE=;
	b=uYjWKngZZOBdGLpFRULriGYH6KZfD/Jcf1F6ilfUav9bhwAUaWGgTIAN8jyKa9r7iOvD+E
	euPol30B8LYXz7fPykrzraEvQc5s79Fm7gLED8F3udXE/l17jQVcNEn/vinizJJlR+5JIm
	GHY0Un5OYPQY3upXedxTq7yt0fcqciQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793603484;
	b=GHI7zDDKA158/O5TgmKJ5sC0thxO9qNcRhMmz3ymGS+dUPbwL9O9w8y7hxLT1el+HlKVca
	+GVhZlqcMdOsXAFBYwAOvZtxwEh6kiUXKIZFe07vKkWHcdV3Yp+7byQPSPmnqZcStbEv4f
	lyYQHtRoSZ6WB7Rs52ArIRiGu6qb8LA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QeS4Sr8R;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4110B6061B;
	Mon,  2 Nov 2026 07:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291B51F000C1;
	Mon,  2 Nov 2026 07:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793603484;
	bh=CtRFjMNFkycltbDQSBe6mjghdVPgzyjFuuR6JFPrfYE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QeS4Sr8R57MXnLyGnjzHxTFPdNuY//IlNr1Qcr2xjFpC1lEzVcNYrMPiPMqheHwWZ
	 N6UV+g0eeNcdMCIUSBur7x/BtlK+vs/Z3gipyVnctAL9EKvwP4rd4H1xJs5a3cJLFp
	 FsZZkWgN/pvg0plCTwoLMJL6NnzA7s5xsYReeM9w=
Date: Sun, 1 Nov 2026 23:11:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Brendan
 Jackman <brendan.jackman@linux.dev>, Byungchul Park <byungchul@sk.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, Dev
 Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, Hao Li
 <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins
 <hughd@google.com>, Jann Horn <jannh@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin
 <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, Peter Xu
 <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Qi Zheng
 <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, Rik van Riel
 <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau
 Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, Vlastimil
 Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, Xu Xin
 <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, Youngjun
 Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Message-Id: <20261101231121.1c2be902d925dc2e67388000@linux-foundation.org>
In-Reply-To: <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
	<1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
	<20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
	<1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C819840005
X-Stat-Signature: 4drhjop94gj9uxhjf4qt71riaipz53yg
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793603484-237354
X-HE-Meta: U2FsdGVkX1+u95CD1r5MHJE4FK9beI6uGfzOg+GzzypBFMNu6ECoylckn4VdFA5lnAznJ0ciTg4UlN/FvS+wYdQPDfKQTtTZPQrfQOaFEvxjo04GYQxXhUH1KC3OW56R2wvSBYQk2odeKV6kvxkfutgU971LqleALk/BlQfk5AeLAR2fyFAmpukguI8zBejQoUOUabE9TtG57jNT+zCb4W4o8Gq5itgyPF/IB6E18ZpNcCnXydfL6voP511dNhP51IvLTX5NzRRKspx5gyYjuL7y9FoaYP7MQSAfhdrKSxDEWvFzsc9dUfTYriSgJR8Jh00DSDSAjnHTqpzvwNUh7ZZ237Xd3tunvIfclvVCSX2cLanyrhAWBj37n6BPkNebXX5bZzNybbOe3QuLpFAycEsBNY0UD0ZRVTyjdmLj5JrSg8rvNTrh69iZPpyOW8LNhT68Lxf8k7ojqKBkm1UbQXffRiLsfevCKPwz0ucrCtnnmeLoG5VmwfvSz6iUgZTW4Jfs721r8H/sz6NJ9xIKPVd7//9iA1Yl1RqUlQXGl/jHSQrcYqcg+71/tWPL0FnbBgdwSFfXqqFXoyzX4dvIeFgOlUhPMU2pTbJ/k4I04sPwQ3cl4EODfyNv9pnLymHMJZD/U5tvoFkbiGEimX9H+q0rxV+HrIFT37YT1bFrAAb9RXmS941GWcV0h2LqLwx6U69SkLdjtGspMgTRU4WQoUqXxyErW5cSdvdiZPBIiX3lsE8ymUjkPXzTqwbDijh3Mbu3oGbGN8n/GTmvu/JYxhC7trpj7gtpQH06t8F+dhPlIMe0+Z4GqVHK1Y8U+HhKGW/FsHlMmuGS8A9IauVuwfgK68jzeYLaiGHML2nTp/veqXJ1pduzk6JrMxc2VwqU7g+b9R6ulTkhNIj7paCb2V0RHxcvw8j0Vz3gTPOfs8Ftu9mZQsObDesII0Dx3SLf3jWDw/l8YCsCMCd2Gct
 oaAwxS9B
 yRPHYstELvAePkj8xkDGp/E1xevol5cTwv9DtcwYWg0pRjk8ViBX7R8pclo/NdJOAJkYub4W7eA+zHaFAPk20KuQcDtbAFHCnVluWW+8K+uwduwY98eeqc8QcPj6fDyBTsY3SwRv92shcS36o1KTNff2m5VBciSy7d8GZQpjCj/WLETxptG9GSRzVBGsMzGbWyW/UgzC2hxC9AE8LbnKtyUMUHdp2hWhGOPQnNzi7fk3Tbc25fCogwrljHJ3BI2spikpfmo+KrEykOyAt/vIHZX9o0fm5WJBSFD1XlkKXu4FUuCWnlvpWV95zJtVJkKic+ECdOHquf+VCY+2EnJ2oa604LG8xcJrs9HbIzRgBNaYFpA2bYp+0TFvWOMkRK1PDp0m+l2qxMJSMnsy7GjyVGkO0UBLA6TjLEm5iLGOvSR/BiCz74oZ5io4MCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 07:47:46 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > -ZSWAP COMPRESSED SWAP CACHING
> > +MEMORY MANAGEMENT - ZSWAP COMPRESSED SWAP CACHING
> >  M:	Johannes Weiner <hannes@cmpxchg.org>
> >  M:	Yosry Ahmed <yosry@kernel.org>
> >  M:	Nhat Pham <nphamcs@gmail.com>
> > _
> > 
> 
> What's up with things like KASAN, KFENCE, KMEMLEAK, KMSAN?
> 
> I don't have a good question for that.

I've made the executive decision to bring all of those under "MEMORY
MANAGEMENT - ".

Less obviously, did the same with XARRAY and MAPLE_TREE, on the grounds
they were originally written for and used by MM, MM remains the most
significant user and the maintainers of those things are members of the
MM team.  All subject to review and alteration, of course!

Damn series is 12 patches long, has been iterated about 25 times and
I'm kinda afraid to send it out!

The result is presumably not perfect, but much better than before.  Now
all MM components are contiguous, all mm/ files are accounted for and
all obviously-mm include/linux files are accounted for.

Quite a lot of mm/ files are still under CORE and MISC, which is a copout. 
Ideally I'd like to eventually get all of them under one or more
components.

I added one more component: "USER ACCESS", bringing the total to 49.  I
expect a new CMA will need to be added.

There are quite a lot of files under include/linux which are shared
between MM and other subsystems.  Many of these should gain a
co-listing under the relevant MM component(s).  Haven't addressed this
yet.


 MAINTAINERS |  215 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 148 insertions(+), 67 deletions(-)


I spose I'll do a few more passes at it and send it out later.

