Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0CF606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SkMPJLiU
Received: by kanga.kvack.org (Postfix)
	id 7CA4A6B05B2; Fri, 27 Nov 2026 08:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753346B05B3; Fri, 27 Nov 2026 08:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CFA6B05B4; Fri, 27 Nov 2026 08:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6FA6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:34:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C95C6C0394
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:34:13 +0000 (UTC)
X-FDA: 85480992786.03.670F225
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 090C440009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:34:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkMPJLiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795786452;
	b=Qhr2d3O1rlLAYWkBsrFSPRIMPfkrb8xifmT6umWAz0EmL6+cyKdtHuRljU4CLbiCdBjeX4
	BPTJ6de7gpBypu9vroO6Tq9698sBVhV+6VQGAynvbqPpjwTLr8vVEvtsjOi60FdUBMyQCY
	/H2UwzWlkhoF2qepp5WdGDkinj8n6uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795786452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bw7AcYTFsfZOxUWb2+TTJQRmuPhHuS1MdESo/HgQ9UM=;
	b=IwMuxc2CUkK3GkL7x7Wv+wrwLFU++BhfXVTiwluXJ0vHOfgyvIJJclRNjwzquD13ETLZJu
	AUopG349W2qwRzKHioLfihtL2Q6f22Mfr3zaikwejy8AHNbBxJAvH2LWyOFJ/ayvJQn63X
	E752nKvXsSm5JkYW6pKRUe0Y0B/00qE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkMPJLiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70C3D60E0A;
	Fri, 27 Nov 2026 13:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625521F0089F;
	Fri, 27 Nov 2026 13:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795786450;
	bh=bw7AcYTFsfZOxUWb2+TTJQRmuPhHuS1MdESo/HgQ9UM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SkMPJLiU39IRzi16voxJldgz9ENeR2wqtN69W5zIWr5davJPyjjQAt27K3cZcJmwO
	 0U/ym5LMEBeq7YxcjQhB7UPsATwvDEz7DEZb02mr1XvVJj3goxAcvlOOCaomJQ+XM5
	 mPOq0IMN4CniQSJXUNTdN03yWwDz/+MFxSLBtrIUvU6YZfvimgHFrft295hvtacR0V
	 AzcSO39+KQOYyYURqnb9JSURl59wVlmLuSslUL2sqds/fHkMxaX3FzY3S9EBV5azNe
	 5ZTX7zCZl9RSZvosb9ngHNq93kXom/905HkBXZB7tqEfGO4MQiyhXNMVciFca1hVjJ
	 M8OkMdw1MT03w==
Date: Fri, 27 Nov 2026 13:33:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Tal Zussman <tz2294@columbia.edu>, 
	Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awmGjkhgfr3R7FP_@gremlin>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
 <20261126022418.3620783-1-tz2294@columbia.edu>
 <50045fa1-0b46-402f-baf0-a08d05282410@kernel.org>
 <awmE8VSlF2VTHLGu@pedro-suse.tail5790ac.ts.net>
 <9c524f3b-d27a-4360-aa56-d6ca4ac1a6ed@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c524f3b-d27a-4360-aa56-d6ca4ac1a6ed@kernel.org>
X-Rspam-User:
X-Stat-Signature: 9bcd8bn65f6qt4zcu895t934s9d33hzr
X-Rspamd-Queue-Id: 090C440009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795786451-636150
X-HE-Meta: U2FsdGVkX1/Q+9cW0+JZYL0nspz8kpPcq5k2fRAwHvNdVq9LMrS0NF565U6agfJaZ2RxQXYJsX0Jqgq5EuhEIeAt5u6H1MvAWTsSzMsAQT/aARHVAFEtJEE2NWSLK9Hz2f6S66N0Tlk+7f6b20utQuxVrvIVAnZivHPvRQKUqrqQ9/oJYIgbyhqm/zdxO1BjngLULrQKlV5krcSjd6RS8yJNMOcfAbJ3J0LjUx8RSz7RlHaXp21U0o6FrM41aqYHeIqJNXAdvTVjC8Qkh5hPOlwuy87GrFoJTIroWOAj+1iRCWPi4cYZS5+u0/Un4ZF8nsCIBQSedhLrwBNgpBzAzgSzWWVxTwJ5NKpLHAjOFksRK5/arbfvn8n8TlGCLNHekuOdhK5cq8m2bUD/LZ1js1GHoHY7AzGB9B9lMTyY02OtlXSLLjcKXetFKNzdf0fgs70ZySQm6m2osV/fozYCeWPEvaBd8aqOB/dFUu4wTb9g8XwN8bAyhpZ/fCT0J4JmcbxuPcYcKLrrkbrGzL4g2vN6DYUfveQVhrvG0vZbyeDNo1QwByfmPWwmGAvCNUelTIwX3M/f68M2B52WMYaL0FFDj8mcYoVmAznjAvEJN3Xd2qutXUthTEZ0OROsUil9daF/mZk0HbzVo79s3tFk0lHSqZxWJ+uJTM7f7DlRoqblh5EaaMKbUbcnCd18nL5R0oAmqHTcNBlcgDVzhHUrGkyCsUzpA6+YxQCrzJjZZ2A5FZITqMjqULbJ9LMmmOfMTt/QDQt9IFz4ORPRZXNnzV4FXHS1vqDILq01Yi0t2MJQjJF1F+68siXxm+A4DFhBUt8WUZ0kkb8VY9m3Jm++6hFy/bnH+6f8Zr0MSbUqgGdn7g1ASnZjOypIyOMVwdoNSYRnc3vLJHA4nK77aOHFJWSWHrY4Hyzcx6MRsBaOVNum6Oe6y9HXWg69d+6GXtj4bqw0QfLZz6t6cUfFzfA
 IQgprC93
 MHYzmBomWEKOWwS8qSwnjfyy3irfTGhXFwQJkNYAlFqMzWyJb+sEtKyoO4JRxf4M8oBXuUGMxD3QN4nSiozqBVUc4AaAqE0ttVZxcO3nzfBCysnbBLnorTpnGqcVeVBjmxL/KgYwyrKyxkUYVMz+gXGOxMj+72+v7VIy+NPyfrC7sKO5NRTG841gRplwccM61ER1F0vFPN82PvG1pC/9emXp4m7sGGybZRK1c7GCbQYzL1/7IitkqCUcC+1MqEp/HpBOox0IpcMpxW0V7LTHdxR182E8XO6LAoKDAEqVlM0tk/VQgPB/nSTFakFrYaWSts3vbVYKKr3i4s1brl2a0g4KUHqyBmNRWCQvYtWGjqc37IkMhKijMOPlPBXabneh2Ep+7h6GVjQhvGVALTIaHrMKl8AwtsJvvMjzK+naJ10H/44EL4iTCnJb4o4l6Y028AJWOv9G14+xS+bXZ9//Wox5UweqE5ugJv6F6Bh9ZGoVcETU/PqOsfuVrv1FJEQzV0xUsaXIZ8SaUocTsFFnlLuQr7/DDGLa6yQ5cBphxdyHWQps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 02:31:12PM +0100, David Hildenbrand (Arm) wrote:
> On 11/27/26 14:30, Pedro Falcato wrote:
> > On Thu, Nov 26, 2026 at 07:43:37AM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/26/26 03:24, Tal Zussman wrote:
> >>> +CC Miklos
> >>>
> >>>
> >>> Coincidentally, I sent out a patch to convert fuse_copy_fill() to use
> >>> iov_iter_extract_pages() a few days ago in order to remove its usage of
> >>> set_page_dirty_lock() and address a different race. I think it should
> >>> address the fuse side of this issue as well.
> >>>
> >>> https://lore.kernel.org/all/20261120-fuse-copy-fill-pin-v1-1-72a0d888f140@columbia.edu/
> >
> > Awesome!
> >
> >>
> >> Oh, nice! I was assuming the usual "we use put_page() on some random hidden path
> >> or core code" would make that harder.
> >
> > Right.
> >
> >> I recall that's the reason why vmsplice
> >> still uses FOLL_GET years after we discussed that it should be using
> >> FOLL_PIN|FOLL_LONGTERM.
> >
> > You almost gave me a heart attack, before I remembered these vmspliced pages
> > aren't writable :) That's a battle for another day!
>
> Haha, sorry :)

Actually, because they are VM_MAYWRITE and... nah kidding ;)

--
Cheers, Lorenzo

