Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1606C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9246B009D; Mon,  7 Sep 2026 02:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969DD6B009E; Mon,  7 Sep 2026 02:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858E06B00A0; Mon,  7 Sep 2026 02:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 659396B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:11:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAAF7A4BBA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:11:28 +0000 (UTC)
X-FDA: 85185944256.25.A04B819
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B6BD1A0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:11:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVs8Xu5r;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788761487;
	b=jHYrW2Vz03ofnSe9+XoFsGr5Ydx1Z+MowG4F41Ew0P4leJc5hYvooVKEZwu7YOw8VqvV3x
	48FXyOmoSNsq0s1rFPLNjc5us6mJlAoAxzJpYvcjfcSa9mFaBYxBnVbBrCULpM0/s3fQvJ
	Bl8klzk5m5gcYGw5Glif6m1GkLn+Dtg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVs8Xu5r;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788761487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3dmwjKWC6Wefq3ZCIghBfeiIweYofYEsPr73KhRS2U=;
	b=iNAiJNKvcMTjkB802UhWjAoHLxCvmtLhFGxHQBDfFQAwln9mgdO2rvI8pEGs3dEeDt5atX
	B4kJIVBd8j8x3UMHJOpKOpMKZpmWD0zgcQr2scrUxqO8dOmVo4xUHHE7HbE+QUYMgGrOrJ
	TxaRA9IgvZkBsd+NnUud72aQFwHPp7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4384943E11;
	Mon,  7 Sep 2026 06:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B1D1F00A3A;
	Mon,  7 Sep 2026 06:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788761486;
	bh=P3dmwjKWC6Wefq3ZCIghBfeiIweYofYEsPr73KhRS2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lVs8Xu5rqDz7930qIA7wlWJw7qb10AZRIm5YTTMxjRCX2t4BjgpcgVLZXPFoE2zuV
	 4M9SQHuqpn/loOucuyWXztqjFxihFRGD56lGccTw/1aKzhqr+FH50miDZnNnJJTcge
	 hrFj1FJ/PnBupIUwR4OzjlZwAhRsQglnRhNbbhTtDkDe+eoDZPXiFLVvXUzM7f8S27
	 KEdQ1IhnCiQ0qOmOch6tMR0gQjP7UBAb1uLBnTN5/9d2zn7ISWoLN9N/5bnBQKWNjQ
	 tkjFcPJIC12n54uQoRw8+/rW2Oom44GLwphExcwF37vyG8s3lzkoYshwdmTmvDwhXs
	 KhuinYov4BKRQ==
Date: Mon, 7 Sep 2026 09:11:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <ap5VhownyptYcTw9@kernel.org>
References: <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin>
 <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
 <apgSCyj-h2xVc2ss@kernel.org>
 <1d7f8806-f4a0-fda0-a361-a011460ef308@outbound.gmail.com>
 <3c19c24f-5036-4bbe-b3af-e5eae102f34a@kernel.org>
 <49245a34-cc56-736e-b2b4-168c2a0b1df7@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49245a34-cc56-736e-b2b4-168c2a0b1df7@outbound.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B6BD1A0007
X-Stat-Signature: o15cpw9d6rtaa5pkeesu5mxkot11k53h
X-Rspam-User: 
X-HE-Tag: 1788761487-871123
X-HE-Meta: U2FsdGVkX1+TvBM3XT9hogRn3HyqBBuwXqekymz/uv/1TmvF1Jn6yVGbt/6wJvxllvEKe4gp0hV2zMIMoUYL/VifFDVkL/vsBxM7C6Yjt3opxmGYwTqTsQQOFq1lhYHEQuv3Go86AY6d5l/8E4G0wp5ojIS/9nc36Et9UPl50OomwtfLPXBuEsccYfMuITxCB+G+5vpI7ORu2TdXp9hLTmkzKkgYVMCNJQRjm/hGx81d45wzbr+GA10DF19ywYhoz4r4GvGoeILaC08zT9Tn4jUeXx9HuzmVMQMfMbjZhrqNLawYnooemNVaFy5JKCURp1Oc3+D2lX7nBKGjySa8pLYTmLTvUyoCcEYkvv/8mzvp9pItx4qFyR3swPi64Uez8aICPPyLmPt3K5RLwNGdTsHhniC0A0E5OHTXfJbmbsZy+TwRw5VG3bkY5QFSdAwMHRpcIDs0JVQPToz3AMoKxHVj49LCIJn0ch7u7A5StNF+iaUAuNV6KFW42nbshaj9MaaJXZesFYFn/GdsuBqkQ3sAESPnUpeujpDBfxD0lmoRP7lkRdXhdASYzoeFbG13cPnXtIxmrU88GInC0olHIwIrQQlQBn13MShCE5a/qWlUWECaIKasjNl4JtOeg0CTuDJEv4hnirBfXcvo+9lWpy/kd/xb2WHX2RFo2aypuAQ6zpD+hB8KTJ72F6krzIAhcOYmOlBks+cX/OWEI6CdRm4nSJF2RktcM1aZ7fqQe2YmZjPXmzZe+gBtx64dMBwpyQCqvX8y7G2lfOBL4SpyID/5HqcoxIJazORGIGL/Cv7xK3ZfuUXYpq4J/Ef+l+FrTOGPPyznInbXxS0yzzTGMMn/Rutu/4WSmuvnFGWK72nakWbx4xk4zc3Pq3UoE2uBW2b4uRYVS2WHFe0srLQTK103rDV46fAvCpH6RLX1FOg6AUgi8cPNr7YeANqjNwZ3572e9tGEor2ZwBKXDSi
 VUhVVxUl
 5FVfRo2WYasWTJqCgAB2Zn3WBRFA/qxA24FRvF2ILJ/rUExI5BrDMUD9XSWt0UfCxrJS/bXaud5DMwPenpfRUXR8cACLQIxV6SIMEJqlOxXcCFPNoPZuFWvTf3ZmSNUXPgMw4Zic7lYrA1yXIa59MpNHnlauSEGyubg7qrco8CG/W0yFIhBOMMTWDcCKDatKK4bEUIIQmHLv11Ivd7toD/oJo464FqCivBAI3qn7eN79ONBhk3afNBM4RtoIB4n8UJnJdZRUZLBpBcESP1u4dRavLSCie4tHF3HehNU+zP/bZ4aCd5KQRf45tTclAYMiJkhyiBrl5tYFiv8S5LfB4KUPnlK39K+FHvKouPP02HAN9Dwd2hGZkpN5o4ltgkQE8E5Xo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eli,

On Fri, Sep 04, 2026 at 05:29:16PM +0200, Eli Billauer wrote:
> On 03/09/2026 16:28, Vlastimil Babka (SUSE) wrote:
> > > Replacing it with a kmalloc() is confusing in my opinion, and requires
> > > that the reader is aware that kmalloc() falls back to __get_free_pages()
> > Why? The reader has only to know that kmalloc() will provide such a buffer
> > (up to sizes that the page allocator would) and whether it falls back to the
> > page allocator or not is an implementation detail.
> 
> When I see __get_free_pages(), I automatically assume there is some ugly
> low-level memory management going on, which is exactly what fifo_init()
> does.

However you allocate memory, there will be some ugly low-level memory
management underneath :)

> kmalloc() feels like something you use more for allocating memory for
> a struct.

For that we have k[mz]malloc_obj() now...

> There is no such rule, of course, but this is my subjective view on these
> two functions.

... and using it to allocate struct is becoming a rule pretty much.

> As I wrote earlier, this is a matter of taste. Maybe it's only me
> thinking like that.

Let's agree to disagree :)
I think it's more about using the right tool for a job.

For your usecase I really think vmalloc() should work. Presuming you can
spare 256MB for fifo buffers, the driver can only run on quite recent and
decent hardware and memory rates there are way higher than 400MB/s.

Even the slowest DDR3 is above 6GB/s, so taking a fault to sync page tables
on the first access is really a non-issue.
 
> And as I'm not the one deciding whether this patch is applied or not, it
> doesn't matter so much what I think about this matter. I've humbly voiced my
> opinion, and that's about as much as I can do.
> 
> Regards,
>    Eli

-- 
Sincerely yours,
Mike.

