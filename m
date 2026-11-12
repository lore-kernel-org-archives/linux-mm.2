Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA10A606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgL6tMTt
Received: by kanga.kvack.org (Postfix)
	id 0D4736B05BB; Thu, 12 Nov 2026 06:06:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0856E6B05BC; Thu, 12 Nov 2026 06:06:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD5B6B05BD; Thu, 12 Nov 2026 06:06:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF6D16B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:06:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75D101C3D3B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:06:53 +0000 (UTC)
X-FDA: 85426189506.18.8EA8BF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D204F40009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:06:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgL6tMTt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSq1qT4UA/SFFJR/GJu5ROIhm9ZxkHbbkGrHiDg+96o=;
	b=tMSLbL266rApKpEvzjzI3mOiVoif4kXheIxe4zrxm0x3e1SKWAasFtLaGpGo4r5J4+92yv
	atTX+zrwhi/jOQ6uqUxmPgEjoznQsfIqazl4azFdwN23qcbPA38eOSUitB1PPQdv+0uOj4
	P/E6hgI+Sjx3W8NNjJ1QaP5FwXx87jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481612;
	b=B3BiWjJx6XMDjjogvBf9nJItaWSlRex4D6GepQVJ3fh6k+SureQghKNu+PJ/+mTyeWXDqb
	gJsCtLCzcP7koOClwxq27uD+8CaIG28nV3GaCxmHR54dEgvFOmLAY0Y5HZlIP29D3kxs/j
	aewUFxor6Ce8FGAid92G5m0KnF9Poc4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgL6tMTt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BE8D44DDA;
	Thu, 12 Nov 2026 11:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007A81F00A05;
	Thu, 12 Nov 2026 11:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481610;
	bh=vSq1qT4UA/SFFJR/GJu5ROIhm9ZxkHbbkGrHiDg+96o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CgL6tMTtg/S8q8yyQ/zzYtg9kJGnRqNf4TdTF0m8ZeWqRXWL2/Oi+iirLh3VdN7KX
	 /0rI4Xhikgv+80DYB8hHzH+HE7Xd9l/cKADhJoww7yeq2yT0f8VkH7WvzEaS01VtF0
	 0/yy+UxDZIbqt1F516bbUZckJ69oh7MkXOYItH/jk6t+E+yJ3BOZlGS0lSAubIMpYk
	 YpVBtER2Ihm5gyMIDsO72fULol91zd9fILGJjGhutuKzecoleh+Rg2ePnBFDYcI6OQ
	 aDRCDVlVxM9EnkeradPkM0L/mqk6J/1bSht5CcFMsbZPb3GgmQ4bFfavYVN9z5mRQM
	 eixxs/EhIbtRQ==
Date: Thu, 12 Nov 2026 11:06:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
Message-ID: <avWdmdtniATARDTX@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
 <avWW5t1BiD7pbzIZ@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWW5t1BiD7pbzIZ@gremlin>
X-Stat-Signature: naxnxqbgncwjqfkhhwg58swtdy45iatj
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D204F40009
X-HE-Tag: 1794481611-738521
X-HE-Meta: U2FsdGVkX19VdhPT5ypfg+080w2u8l7SprUGAHTI812q/DzPs1UDVcAAH0803iLxSXyG7dLAcwhXOzsAxgcFuqT9NZVrViUYtDhHJfNP6rIGzITdFQ9XLGjHPbtVet1zrkRIPTmuiymhWKC8tEHrYLctep6+CUAxi+1qM0fClclDHsHeAZoFlfbqK47WzbtJ65T2TEGOdQVIfK1uVT9hBZ+C799jfzvu/dPyuA05k3HpGZlVZWMGsoTSnWnnOApG3DtT9u0kklWWVneguBzEJjW/JAJUFkkthWzLqZqp4L4KpoWqk7QKVN+8+7ElZXfE3SQVvkpO0o8sH5I0tSvIeVh1fWUzOKh1yCPOGKgQhUhm6jvWdLjfSnWWdjBYWuOjCQ8K8fZjuZrn74WvSCJKvCMOYut09RJNpsbqcmQx9fvWyQRv3f3YHrjN2RIzVeeev4QU9d5+DlI1NtbrMK/sREopyusOHBn7V+RnQFt1v+ARTWk3WBTgDWSoIlPPCEF6oFxJKkXtMqyb/uT7xvyfsOZT1BoofRUUCDjey5WeYr3QCmLQLsIcrXoOjaGbf4hvGVuWo9yetswqla2MeMIIb2mVnefUQomVeFOMs1667xZCqmTWEf2CB5TJPcionrsPKVpHGOpGTM79ltkMt3kCiUgSNdfZ5XskleUpnhS990QqBhhPKYmCDWmVF4/c0O6aT0CHp+3iV87Zs3+Zo5hTrzTTn3U70w72O9kNQYXi53rTVEhyABdpVCxgXzh+wLjQLFDZMMBrRT35pbnDUACLbNn1jsjn4WEhGr+/sVSbzBZcLDW7gKQuLPMJipv1w0YsyWHCHbw8zbe4VexNOmRcd2pTYSS/hWzTyf0bfncRpyLRTWkJv2Wc2G33/iHoGYKJSMFDNyPXDtCK/jNlYsAwcazBP9VXUG3IsUv0COwtVDP0OG+iiL0Xq/FNoxEbmoT5w6zkf3sY6jlMBzOJ/1t
 hGHxNQqI
 tQYL0qf+jaacfqGjg2qc4sRjpxdqCUZWndtEZf0zH+ZU2RIswDSci4dd1NuYIuTgpKSpkfjlSHlnblr57Ape4RoffskpP35MKhxOpE4J92nQ4eJmuxa4dD+jXzlCXOJriwJPR1BYE0wVpPlsM0tISOVNsXOhvO9ecuKH8u2aArruS91nZom+TDGZhcKMTdTJmN0DL6zFpN+g50SEb5L710zoNHj1NbXJ4hx/sypIKSF5EMRT1BvC/j1Rsmd5I/l8M7ypaNh+CqR/1XiWCb81PHUvbxC+PTE5CGAOrRhwO/eA17pEvb7OpdPmp1U+QyFGEeUs6WeEFpcdhlZG/lbzrRhQvmrmxsEYpGndmKRtF48JgmGEGtlNh9h77NA4OkImTuKFW1eHITktpXrZKVzkrS096gybEJ3kaSFHUdXepYIMjDLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:03:29AM +0000, Lorenzo Stoakes (ARM) wrote:
> > Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
> > Closes: https://lore.kernel.org/linux-mm/3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com/
>
> This report was super-synthetic AI slop
>

Oops, let me finish this thought... it was super-synthetic AI slop to the point
that I am not sure it's even worth referencing.

--
Cheers, Lorenzo

