Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18978109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B9F6B00A7; Wed, 25 Mar 2026 11:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECBD6B00A9; Wed, 25 Mar 2026 11:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB9B6B00AA; Wed, 25 Mar 2026 11:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC996B00A7
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:02:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04F371B8DB8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:02:16 +0000 (UTC)
X-FDA: 84584901114.30.A705045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C199F140030
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:02:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o5xu8osK;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABEIty5HU/Iuw2OOS0KrKkDWBoGWz4KSwuxsAu6g60o=;
	b=JXWr1bWvANFroRCV+FswgDz9dBBh8+NOFct0PpjNKbV/pDe0qgYxzilfFixfv200jECJVe
	+OQaU6wRSsJ7c8CnkyEN7LEadK375i2jVD0IbrxGG1Ugl/az2TlIi/NOhpEYxrNfscUH3/
	vEdj7VSkyiuYtKSGwuuLm22bCBIN9UI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o5xu8osK;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450934; a=rsa-sha256;
	cv=none;
	b=CZfqPuW0ZAsul6kvMwm8c4nVZhczK8CEHSO6+O0rDjX+gowCnYrwGrDhnClE242WRq3MGj
	vz/tUOMHWbAKIEAo7TSV4j/isPW7ZiX4HQj8txZg1bDxr4HPX2MDHgZyaE30Tq+mmbVQeA
	ddDnBtge1rdkBxB5PpGnWyvdPcGBgNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5771600AC;
	Wed, 25 Mar 2026 15:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65A8C19423;
	Wed, 25 Mar 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450933;
	bh=ABEIty5HU/Iuw2OOS0KrKkDWBoGWz4KSwuxsAu6g60o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o5xu8osKy2dzrUDPwu5yoQjTng5YdYUL3822flT0paQIdg9e/BTFYyiUK9l+GQOaG
	 daL6PA8y7R/LiFqAwSF8+W30Ek/zrLCrpDZbuIxfPHWd722GOizks/sJQPO3WIHKiY
	 CfDNk4/1DVhqBnJgdYHY0uK3+4lwi7i9/0fMohc3KEBmauqq+wXvQYmkggDaiV/9jd
	 n0MQgsXT85KVQtgfFBS2M0U4e06lcMT25UiDWCpuonb6xPhwOwgSeYvD8zeYqx0TuD
	 fdzP7hlGmXznOEkuM8BsQ5FWz7XNoTgdBwslAWj6jJVjwgry1e8erDJNwQxk0gKP2h
	 dThIHrt9f4cog==
Date: Wed, 25 Mar 2026 15:02:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag
 test
Message-ID: <93f1aa28-1c1f-419e-ba9d-c4b9204336e6@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
 <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>
X-Rspam-User: 
X-Rspamd-Queue-Id: C199F140030
X-Stat-Signature: y9quddtn75h4mmodhtkx5bsfx9hzwrkg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774450934-772596
X-HE-Meta: U2FsdGVkX1/MX3snuuy5l5RfrqSza4OIF4E6Yv20shmTP2lxqAWWv9CxxLBBYrO1H6EUIBu+X8hg1NgD1BGp3VcyE+CyUhOFAgh/GAGlROc/layDZ20cs+lXDKUlTEHiFsnnKaY4Kshklosih+FWR003khzAxPhE2cmjjy/ptUX6j5j8IkowYzqjOMvEarQsJpV3ZtMMk2zyE8kp5/hNl4GAkGuPX9YLFRTf67z6XERqP+OD+FQH6mWxGI8icPLkOJT2TiX+AwwfM5mU8RrqYqKiTbRNjl18cwCgxHYcbKalrQZbBQ2H5qAX2fUoGqWQ+74pW3Dd+0v8J3zZqdYzs1TyYrcMKQvNlO16c/c0EgGkjw8emPqLibboJZuPQXmNATZUMZYdDYSBmA5qXqB3QV8NBPQrBSl1bbI7KmyFp1+ke5f9YlEwf86SGIoRklDmCdLzrsft2zJtdpQKWhTdgF+I8vRV3qXW2IaR++YggMTtTNiO5Vd371KTUK+vQS+HnYp8lwS2Wq+0TChAh4vXR2VTU3dgeqfePeX5ejLS7k/ZqMNw7vYSlaKfdclRXsQOtkNXBIMOUVWEoEHEWMOqHaLODwm9iDZbOz7SSR3wjcloYjxc/OlLaSswxUnD2xFc6Zb5mQ6GChBt0EYK2CQ5gRpyIZ0ugUGgzIZ+oTVQ4pzdfXi/Rzvll9DTgUAYIGMbvKRseNJyXgeCGwfd7t6+Yd1jve0LxypRFGDb6NKiPWvpOrVpnNgLEhJk8TIdgWiUed6zTGYVb3zfb2N/0pYnrb8KOC2BJF6oyNeXwSXAmUhG7HE7m3m4caxJduHYjM1Yw5iSkES2dVXBQmtylvwPk//fpBThE1vHvY0FR5oh9gNy6kID1fBpJrnKguwXizIkC4SVIUiEF0kjwN+QuQNo6bKK4O49xRgLAbXRT4RmJkCc6fdsz4nmIT1vsc5XyfH4DUMgTgWy8kwxMcvztLw
 wvUBNBZa
 m/67YcvgBqi0io4SpgWxwFj8NYmyRm1kNhtMaNYiza5GCwp/jHdFe5xAp1kSEpln+yFrO/Af1oZxRsXQk3QMkMtrMjYUC5mPzQFpiA+EfMSEP7wKyyuP98r6CVQqbt3frf/w+QGv9rrYC0KAzvZlffQ3CUTQNLZjJGInQFIPtAwb0K2sEidcRwYRnJt4SD1hp9KjmsT/JLMS/ZKMYqUfh89GwLy8Uyj444wcikwUVL3iw5y5hrvY/Be/W8kyE/x7oMyli87OliaNPPj7pavsy8hndJxl8ucVNF0vX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:57:22PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:17AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
> > clear as to what we are in fact testing, we now have the opportunity to
> > bring vma_flags_test() back, but for explicitly testing a single VMA flag.
> >
> > This is useful, as often flag tests are against a single flag, and
> > vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
> > confusion.
> >
> > We use sparse to enforce that users won't accidentally pass vm_flags_t to
> > this function without it being flagged so this should make it harder to get
> > this wrong.
> >
> > Of course, passing vma_flags_t to the function is impossible, as it is a
> > struct.
> >
> > Also update the VMA tests to reflect this change.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> This is a lot nicer, though I am wondering if there is any difference in
> codegen as well...

Not that I could tell, this was more about cromulence.

>
> --
> Pedro

Thanks, Lorenzo

