Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347CCCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775916B0005; Thu, 28 May 2026 02:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726446B0088; Thu, 28 May 2026 02:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BE96B008A; Thu, 28 May 2026 02:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B876B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:23:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06DFF40218
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:23:48 +0000 (UTC)
X-FDA: 84815837736.07.1FDA219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 53EAC20008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:23:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDEGgVG8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779949426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RgJd/j+vMw4rGJufzEiUADtvpwL8OLKBT5M1pXfwa8=;
	b=RBoGs+cqKbOXDy+Oh/VzpWr7wF5wG+v39FC24G/L6p/xxoFHMGzm0TBZYQkMdCflyqNVOl
	D3n+WdFfFy1JdUg2nmBJr4eY092TQNipOm0vmlOhNeK001Kzb5Tss1Ak9xPVr7FMWWUvwv
	G5kzKtTzlQUW1bNDZLh1XX/jjy0vslM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDEGgVG8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779949426; a=rsa-sha256;
	cv=none;
	b=SvMS592Sd7X93XqkkpEgbOTN9FshgR1UfiBEE7/K2engsr8pMSL+ce6020yC3CmMG1RmVX
	vZRCJYF/emcFuCBnRV8waUaf2JPJZdzGzXQ5FT6fCWZtWiefzHvybe0ClNvTyOEcIS++22
	vkZJc24Fqrsj8LYZUDfnwW9+u0jKGrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CD2C404B5;
	Thu, 28 May 2026 06:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BA31F000E9;
	Thu, 28 May 2026 06:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779949425;
	bh=0RgJd/j+vMw4rGJufzEiUADtvpwL8OLKBT5M1pXfwa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UDEGgVG84Pw+wHmviNQ5eNI4lTxiyNPcShJqSqyPl+Us1cz3Ezq14jtDvAg88/3m+
	 Xj1mBTPKb4iHYalhZuxc7x5r4MD6GET3+M/V9T0Hk2tWjkXQfPuoyq+kiaOa8wRwLV
	 o3FMtFQnaKC7VJFMES1Baw8drUKUTUcsqNv1IogCnnb5QSZJv7zQZ0A5kKGLg1xHK8
	 rA1/bWqezRA/lM+928OusBqefoWFXk1ptC39QwHCjFJJle8ISwQINoR4H01pcOhWN5
	 KdcsjCcuO/orh1LYyXIbVFKnul+seX/hxOXvzylyTk8oD17sZXWYVrXFMgjVdKme2H
	 C6Rm0bRuLDm/Q==
Date: Thu, 28 May 2026 07:23:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, linmiaohe@huawei.com, hannes@cmpxchg.org, jackmanb@google.com
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
Message-ID: <ahffSyK30HtBYDe9@lucifer>
References: <20260202194125.2191216-1-jiaqiyan@google.com>
 <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
 <ahXFPh-a_Zt1Q_r_@lucifer>
 <ahXVuBoNUeEvLRrb@localhost.localdomain>
 <CACw3F51tWMjcCX-xkfUEKb+nUo+O_Q_gpAi+UhiBL+8i+T8MQg@mail.gmail.com>
 <ahaNtdwdLvHxFCg4@lucifer>
 <CACw3F51nnzwZ3cYqBXU33+DfiAfDd1r3BoH_7DD55OD-4mxH=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F51nnzwZ3cYqBXU33+DfiAfDd1r3BoH_7DD55OD-4mxH=A@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53EAC20008
X-Stat-Signature: rfd7ppzcrcerg4gsnfq5bj4ucdegnzdp
X-Rspam-User: 
X-HE-Tag: 1779949426-407996
X-HE-Meta: U2FsdGVkX19CpnXXgDK1akne2+s+PB1//ndMWl/VqFKfnu5FYgpUf+EpVh3p+PDI0Ml0CVDfbBXb+Wu7XMHs0PmLm1KQFVEiT8w3rpgwwQiUkIAfjXfytWmiKStgSiqbJSVFOEzhIvCVNxoBgazNSih2laCspjazT3l8NF/+Z+2GXcm5HNLaISI9puaaY/yffgLbHVzUO4+hWY03PdrjmHZZXA5+UO5vi7Gv/wcAuN5ixu4B+/6QA8mTOGSpP4s1qtRLZgAd2oeuBpm5+U4Uh1f3ZFG4k7+UoTXVufjSlGsL8dxjW7LNvFBWxEg/n3sTLvlwbt+rtBK94UU/3P1wkISzDXtiAA4YALC5URqq3uJ7OUWeN1Ies+jMozC1z4BX4DCjjx6dZED5xOjm9crXrMk5nFOUSqq5+HSgInxVA3uJ1cfmT4QoLLLyXMCrrD+oHwKztAmlnM5+y8KlLrpcYqcqsXbmNgp2vjnGCW+r1vAudZBRr/7FY+cdsdZNPci8QdJaGXukjCfeRRYJ5SJCHEZvlKCZH8Nb1XUlBqe0tl0tnYCQ8iNDIOErixmgozBGZOrSpx2dcW3yIIFINKbBFbkRWty56lMjpLxDhNP872HdMku53P6Z7xG2Jd6O0w89BX8SWhB8pdezWE5cObZZHy4mnSKv1/bmngJYchHphVxT7eWIl2MMVneRSJvH6qBx8uHSVVvLW/oKuKibHu9KUQHuzNX53NAXn94wmOD1oW4bf72GLdbUNXmkLdW93EuwmL82hoHOVaWQjsu+VsF2WLZ7uKGfJ4ivPwdNOZHSBSBlzMNNkCBt+nHnFxqgeTJ7HLZZfKZw4mXfmL9lnoaBiMednJxsGu5B+PTDCqr2NiiiSGNG7fqqXPZd9c1K4N9oOtSH5DHEEDj44P+F9lF+lpBTSk6ennIt2CUasEcOyntkRm+agQ74IMZ3qgDTIBFfhzhV1LVABCvfd7JEtSA
 2gN1MoRS
 7CHc4ievandaevrKvgOyY0UUXiZJ3FuPOxpZLhAoycYHuCkJn5Lpiqp9P4imvnOpIi4vdyjfuQGmd10nHCad6LDcYRS77cYe75Zdbd2LvvFip5L8ryaiJbJIxRmGZJc0dWVJt7Z9DxeKFXBGYF+zHcw/4kNEapWFqJ/UUwSZ1tmETMszNT7IktQHpqqqS4riDOfEXy25fQXE+5O3ihvJKs71dzxqCGU1q8KSl1crdtM/0OuiqYkm3q8TCO6I+JcSW3cHtSNHLk671N/u35WiATosVVv8+CDFiWmSpp2MCrajpfRuGTskTKV+bXlJGLGcdqb5rCBvBNLQJ+T5YSR2Ejn/IEIEWBAln6v/8IZLcQtmHfNT8NC6GFyNIkrDDfoeP3E8Q23hCg9w0TZF2tgOZsbZUcouGKptRjacl3hdjjuz8bv4pIZNCtjDYynvsjAvDs4ZvBlyQWR3MWCx3It5fH55BOTGBkhb3pxf4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:29:19PM -0700, Jiaqi Yan wrote:
> On Tue, May 26, 2026 at 11:36 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Tue, May 26, 2026 at 10:00:06PM -0700, Jiaqi Yan wrote:
> > > Thanks Lorenzo and Oscar.
> > >
> > > On Tue, May 26, 2026 at 10:17 AM Oscar Salvador (SUSE)
> > > <osalvador@kernel.org> wrote:
> > > >
> > > > On Tue, May 26, 2026 at 05:09:28PM +0100, Lorenzo Stoakes wrote:
> > > > > On Mon, Feb 23, 2026 at 03:17:57PM -0800, Jiaqi Yan wrote:
> > > > > > Hi Vlastimil,
> > > > > >
> > > > > > Could you and other page_alloc.c reviewers share your thoughts on this
> > > > > > patchset? Thanks!
> > > > >
> > > > > Hi Jiaqi,
> > > > >
> > > > > I guess you are blocked on review here, did you intend to return to this?
> > >
> > > Yes, as long as this patchset is useful to the community.
> >
> > Yes it is, thanks!
> >
> > >
> > > > >
> > > > > I'd suggest attempted a respin to get some movement here as clearly this slipped
> > > > > through the gaps last cycle.
> > > >
> > > > This fell off my radar, I plan to have a look this week/early next week.
> >
> > Thanks Oscar!
> >
> > > >
> > > >
> > >
> > > By "respin" do you mean I should re-work the patches on top of the
> > > latest akpm/mm-stable or linus/master, for whatever the changes in
> > > mm/page_alloc.c and mm/memory-failure.c since Feb?
> >
> > Rebase on to mm-unstable would be easiest, we're late in the cycle now (rc5) so
> > this will probably have to wait for next cycle, but doing this early makes
> > reviewing easier :)
> >
> > You can either do a v4 RESEND or it may be simplier to just send a v5 where the
> > latest version is just the rebase to avoid confusion.
>
> Ack. I am preparing v5 on top of mm-unstable.

Great thanks!

>
> Interestingly, I notice [1] introduced free_prepared_contig_range()
> which does almost exactly what free_contiguous_pages() in my patch 1/3
> does. I will try to re-use free_prepared_contig_range() during the
> rebase.
>
> [1] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com

Nice :)

>
> >
> > >
> > > > --
> > > > Oscar Salvador
> > > > SUSE Labs
> >
> > Cheers, Lorenzo

Cheers, Lorenzo

