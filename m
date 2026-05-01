Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D5ECCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109476B008A; Fri,  1 May 2026 10:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9E46B008C; Fri,  1 May 2026 10:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11F76B0093; Fri,  1 May 2026 10:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4B9D6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:59:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95CA0A00E6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:59:37 +0000 (UTC)
X-FDA: 84719159994.30.5D48535
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0907BC0017
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:59:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKD9lzFT;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtctmsuga/7Znhv8QnMPp4ZCkprYt15mrvHNUm/jGzI=;
	b=nq2h7dxfeUyWzcJfCgfM04eF9MjXoAwQLJvVk1dNwhkPed0xjMID9DGnQ0eJ+kcJC/KhGp
	U8FkhC6Fiwlc2TV1GNdCq7P2yT/FfvdXk4HBzocuUs4oQB4hVMcDeC0vC6jYV9kaQCSBUy
	86HG7n2kIiMq8SLin+NofH6kxynoKfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647576; a=rsa-sha256;
	cv=none;
	b=3m3O0Qg6thOBf3aWwe9bDE+CbfDPGZxMWVpFToqOb8svQ42/f1/3S7Yd4IiZjn6Qz68And
	pkqn15RHhDd0h6Tl0tfhSB43icrLx0yNDS50P/FDUUTnBoQxL9mdg8ZSDl1EA9ezackAGE
	2hIhTQ8HfFBczRDtFEMiAPiZujz42pI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKD9lzFT;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 661C8600AE;
	Fri,  1 May 2026 14:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D12C2BCB4;
	Fri,  1 May 2026 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777647575;
	bh=ycaiT85yjqiIS6M7LkTtnedf3KKXD/JBbKq9kh+z724=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YKD9lzFTYLBUZN6DAKHoiMTYDc76aRpVVAhVDNRyrUGnmPjOk7oaQLU/9xN0XHEOg
	 WjXMR/NJAOMFLBahDRsfvDm/FymGhQmmgawSrG7+SapBrX0vKzOhBUsFWI2rPA8lXR
	 OkC2M9WRZSdpFJXDe+NCnxMlsxw8Z9qFHdeImFUOzSrI1je1+5opkiRMf2B56a9i8T
	 m3eOZnC1tWfsO6nhmK3UjPxocE6UMwQNzeB6hcbGnQJUKe0pF554ineboBD+WL2JYJ
	 s2DHdreQCK8rUByYcJD2kDqLTYIMqkDevQprG5hQrAh+Z8iplkFpIM4EYMf+3zoBce
	 fDGzG7jCKH5DA==
Date: Fri, 1 May 2026 16:59:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Wang <li.wang@linux.dev>
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 07/54] selftests/mm: rename hugepage-* tests to
 hugetlb-*
Message-ID: <afS_y1FhZCvqet-D@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-8-rppt@kernel.org>
 <afRhx6-lEe5bxkMD@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afRhx6-lEe5bxkMD@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0907BC0017
X-Rspam-User: 
X-Stat-Signature: yztntngos6iecofkeodd8ozhyibbmgj1
X-HE-Tag: 1777647575-58511
X-HE-Meta: U2FsdGVkX1/SUrlxQthl7wdBZxQAca8pmFWCIEq5pQVw/wu0tNB4YOeMgynYYNEfJj0MX8bnEzYzO9bRpfyuXMFjOJ8JdCp6tem1UYfi9GozfbLCKTAkJ1OBnsDVU+gEGMicjk4mt7PVc+YC7JkDvqZ/YNW0J05at6Ty56Lx86gHPeinWwwDaJH+w9QdcbGfQmNv/SdEEqUiqQFj4OQ3FAcAzDRWhoY97TZ3N+J4jyxBiOoJhy/Zm/YNHnbi9kealDnz5Q/5XxopUXPaJd6t04DbxqxDx5cju2wZq1JG21mO/kcO+A7tykB6+NeozAa/8NUX7/DcDvGopPjV+ZTF2ZTwLsiKoPFPs07cvo3x6+dkJss68/Fbh35kVlhAyzSq0O2u4Tj6ThgsH3B8gQn1sjdDdn9/tz39EPYemZghWuZFZ1Dd2Ry+d5Ih+7SZGjMRDOTQSoXIOvS8AbtV8KLiVVzsum2udOwBqc1BFHpoNWQ4aYM+978mkiNr5TRX8UIMblfwJFmj/8MtcKOr6ocW/THgcrckNPkRe5TNMyiy05CMvUKYW2TCqcDcRwqbiw/AAPqT16Jwv2QcB3w7Een6cNOvVapB9ipdQQp+E9FgoId+g1qCAeDwyIX5vLtmy8q21PXe0lXsKHaOZBu/3XaF2kQ3JQ8a3Bwu44CmEDXVumi/5e/Mw03F5AzHjXF+riO7cmpwP7+iNgLFBQh/8qTq/qwf/k6u1m1ZPD9f4OfZ6RdJH/6eDTEHcphFXUvyI+mq7INJmAoL0L7G6lR4gHGNjKAA9rWYvzR9Cij06alQA0SiTCPW68sq27gyJ6fsQgtzQH69/M5sHHGuuWPUS5+IP3nraF47Cr0EMTNX5TdcV7MxIhriwKZGhmX+Iy4/eDL+xOLSAf3MWH4QjI3vw40UCfi+e32xM71rifBDK9pnGsPTxlpDV48xrzL5kx8AVIinz+9ZuoYtps/EHr8ql4D
 q8b62s9z
 zHXLncBr9z7UuLxXo8wnoY216/WPwhO56P93Hn6ohQCO9MdAzof8a9NR+hDGFTmljC+Nti4lfE8n5Sa4J1Y5Yw3koV8gPgkqfOOy2/7gO/smmhxyenSW3msVPMoFks9YTIdP24K693kBCEdS5NxAPu6m5h8t+lUwRevUtGu7q/12zmzldVgyBpEHhgSKTeyg1wxFXti5VC3dISYGiYthio+ZMEnExjavSErVYoEz6WrfsFw7UwV83G95gPugJkJqO+Xgl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 04:18:15PM +0800, Li Wang wrote:
> Mike Rapoport wrote:
> 
> > --- a/tools/testing/selftests/mm/.gitignore
> > +++ b/tools/testing/selftests/mm/.gitignore
> > @@ -4,6 +4,10 @@ hugepage-mmap
> 
> >  hugepage-mremap
> >  hugepage-shm
> >  hugepage-vmemmap
> 
> Maybe we'd better remove those old files from .gitignore as well.
> Otherwise, looks good.

A while ago Linus objected to removing old executables from .gitignore :)
 
> Reviewed-by: Li Wang <li.wang@linux.dev>

Thanks!
 
> -- 
> Regards,
> Li Wang
> 

-- 
Sincerely yours,
Mike.

