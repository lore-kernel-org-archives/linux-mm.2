Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6506CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8BF6B0005; Tue,  5 May 2026 11:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0946B0088; Tue,  5 May 2026 11:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CAE6B008A; Tue,  5 May 2026 11:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3EC06B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:26:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45C268C8AF
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:26:56 +0000 (UTC)
X-FDA: 84733744032.04.1C0D154
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86E3812000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:26:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jkh0r5F2;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777994814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZbNiDRinKz9RcUmXFzS5y6Ymf8Nx9aGXEWFFtozfyQ=;
	b=om70s0aFGglqBL7bVAtbvSrEHjCFM9KJPVSYBkC5Nteiny+IpfGOZ9j/xpT5jLXPQAU0rO
	FD9LCEXd0Socdyuc0TalvnW0zfT7l/rXVBOhVCIDcJ2lIfQTPrYDsSNJtJHoZpXwl+OKiI
	vzHANC+CT9M1ub7gRXYm6HlQY7Jc4CA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777994814; a=rsa-sha256;
	cv=none;
	b=ZokUjrt8LKILv1g795//iVc/ghaazeDzbOadrPbxYns+vNwduK+u4upoDugVAUATP3+CEU
	nMjnDjL7MH5CdNIxpFOqKX3agwImbuQacCFFoI2fdXGYPXkntp0JolTbanqAJ6bvQg5nSd
	2jmglJGbnHe2M9oZJocTBgKC3h1ELvQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jkh0r5F2;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5261140751;
	Tue,  5 May 2026 15:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A823DC2BCB4;
	Tue,  5 May 2026 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777994813;
	bh=qhIk7DdTjawjgIvIgyqyVn4S1RsP4sp7HyNeTVlVPKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jkh0r5F2rWtljYw5n8/UDDSlSrtF9vbMiarOekkNQMD+w1RRkTpB9HNJjAztp6K+M
	 U10268ztkioMbO43MiA/VqGfvg15JWhvHQ7JVcflsIFVe/gWeDOYYwjJd1eNhQCFRR
	 Ujg/CC3ah4KdEuIVt535EZr9TyLy+FWhyQONsQxhLHTriQcMp1OLci7ZD5v7d5aXcQ
	 JTI2fSBT1z/Bh62obiPPSxwptX0A5AjWBPPzp6uOyUD/RYDVP8k3SF7z5YVLnpPVm9
	 moOqNtqGhAZLwycx8TuVROJwAt+42XsgEktxeQ5ogfVJ1snLEZF4UP1ZTMPxFFmQZa
	 yeCqiUMx6lGSQ==
Date: Tue, 5 May 2026 17:26:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 30/54] selftests/mm: compaction_test: use HugeTLB
 helpers ...
Message-ID: <afoMNE60ZSLSCQ6g@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-31-rppt@kernel.org>
 <daa3e21f-0c48-456e-a4a8-198a8c907b9d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daa3e21f-0c48-456e-a4a8-198a8c907b9d@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86E3812000B
X-Rspam-User: 
X-Stat-Signature: jk8mn3zk3dk733ojr867nkyue7jhumwo
X-HE-Tag: 1777994814-262241
X-HE-Meta: U2FsdGVkX1+eRRkxWyFVB91oxwkgzYROEZ4tB/uPmhXqSwNv7/EHitvlDrPmnzcwsbhAcjO+AZCv3xBzKPmV6vcsTtNp0IienXmMX0CElVlIP9mpvNWGISNPQBPuypyPm3jBLNG/NG25+4TC8d3beGTH0zgbQCDo9LUWF5u20gkOwNJMQx2pexu0Od6HaQvvBaB77ET1if4OVl/k/UxUSY62tjfnMgf+qTgbnMa8T8eOCGLBCMJ+tX9BGqrdSpxGl4+nyMFdPnVy6ZgR9KP1tJ54z1r/Ose1hUVl3RmgLOpsVJfYV0XhNTwu+HgzaZb4JY+6igr+J9JXhDGPh4KPlunp+L+lHy0eUYp2UA2IDsu2um46SmZgrvmuOSh4O2qty+XWWXamsrwkFmbtTqfk3XgzpKlXDcl7BqrXHOoq6v5K9n34MMo6e4zbKVmpfW/2CrrJUyAYpR2MPZpHbt67QiHXoqkW65VVfwxtfDZXbJtmb2ut9dLqG3sT6839oYSRkvUlT/sCQ+xmXTX9KOzyAdNWlPHy5ZLHObFLtSjVnZ17UxurcQlRztWGn7HHVMNfft9EBaJV79GjnFKTT0KY9wzI9gzkjomwFkoQl0kfmnBjL/YdqtfoYNimkvhYX0PNUM4yhOoCZ0Njx1sEkF2ZTEQ0+Ip8g5gFjukSxuhKPEkNDHxLqCqk/prCgMENayaetxGyUybxp4DyxZl02Xn7grfsOwu5GTHEoR60cRwPniFIdvtggETq0/wkqKQp2aYoZPV163M7yGm6mCL6NO5cNt6ZDLX1CJqQhw4m8ErZz/Rq3fUh1A7Ty04Lgqv0pu8YdaG1BTi8JJCom7wBBJ1O0Td+aTpRokMBonCL5J+gbISXzdlNKEIIr49tUFc1gRfvokvwNZxdacnynNDVht1gePglVARkI+ITlUFrjt/cxq1hn17zDQIp1PFSdOkJZAsZTVikPFi8ck6IHq9gXRC
 sYN93v2H
 9tmjSf6y9py4Mz0n1igo+o2eZ2/oIdxcbCQVrlFskVfVvIG1jpnGatZlTz8UAJ7efJ7MXoFiBRHMVOe0L7pZHQD2DRuyJuln5IktfHE0vIjlqIOSfIKg9cKmkzrIU5RaivbbvjEWSNuI8DvbWGSONiqthrJb7jrfhWO1gcZEAqBjZ/Mn0Xsrfqqea73b2jYyDUvaj31FuUYjPLJMaHtbLfPceCMChNXb9rvzmhEl5ButMpp8nYYjut4ejY3UFvdB1XlQBXCYLmKYsVUx73FfeL7r429ZZforWJjkUlujC3x5s9qRUO5O4leqD+gxXB87x3F1D6kfsN37HTAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 03:37:31PM +0530, Sarthak Sharma wrote:
> Hi Mike!
> 
> On 4/29/26 2:12 AM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > ... instead of open coded access of HugeTLB parameters via /proc.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  tools/testing/selftests/mm/compaction_test.c | 113 +++----------------
> >  1 file changed, 17 insertions(+), 96 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> > index 30209c40b697..962a50c3d66f 100644
> > --- a/tools/testing/selftests/mm/compaction_test.c
> > +++ b/tools/testing/selftests/mm/compaction_test.c
> > @@ -17,6 +17,7 @@
> >  #include <string.h>
> >  
> > @@ -161,48 +120,10 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
> >  	ret = 0;
> >  
> >   close_fd:
> 
> A small nit, should we rename close_fd: to out: now? After this change
> the label no longer closes an fd and is the common exit path, so
> close_fd feels a bit misleading.

Thanks, will fix.
 
> > -	close(fd);
> > - out:
> >  	ksft_test_result(ret == 0, "check_compaction\n");
> >  	return ret;
> >  }
> >  

-- 
Sincerely yours,
Mike.

