Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C20DF33A61
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED426B0092; Thu,  5 Mar 2026 08:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AC26B0093; Thu,  5 Mar 2026 08:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89DA26B0095; Thu,  5 Mar 2026 08:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79A196B0092
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:49:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22AA2877FD
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:49:25 +0000 (UTC)
X-FDA: 84512141490.03.897BA66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3457D40013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:49:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rN9Mg1Xo;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772718563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZFRaMNTuI/107pKBR3Mf2CwjNmpowhYESpzBPTNLZU=;
	b=1+yLkGuK1k4v+48t8TsZp80K4WSeEOwHmOO53YY0Obz4ogNUTqvmMM0ne4iyjFSzqkGBDD
	XRCXEwageD+b1S3MjE0UkVqJ5x3ApCaU9d3k7Mq0nJcOm4Uk8LhQy4hhgKiZ2Kgu2IJSMR
	mzZtwZadTJfIUCsitLPVh03Q69xTZFU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rN9Mg1Xo;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772718563; a=rsa-sha256;
	cv=none;
	b=Lop/Ps9o9NfbDds07KVHYUL75xGRzeGwW660RIC2UK2FKLreMe0rqzd+FfwsWeLX45B6xm
	WG8DLmqzr34PjbfDMir/y0ze09qsLmATQNDrQXQMHbwXlmUIblHX/EuYOPSM4KldSXxJeh
	TfH3KhPf5wUnctKv+sHuuMhPUyK2TgU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30BA041E56;
	Thu,  5 Mar 2026 13:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA06C116C6;
	Thu,  5 Mar 2026 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772718562;
	bh=Ngs/xKaVv3ePswv467lzqMPd6HsCR3EcDxlLqTtPdyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rN9Mg1XomC1GUF8ax/B819NdvCW4vBDBA3XtujwILny2IxFShUMyVdEZiSrGQ6UT8
	 VcQibdKygm0Qaad97xG4alrLNs1FX30k+fGf/ccSNBBsRT4lJVrNaiV6IlGXZue8ev
	 qO79VkSBBHK/R21/JLVqdPpIaCJBt6QH6Hz7Sw88nPBxPDRHN30VQb3H2QgHkIalXp
	 A7QABCnYBZDU3/dRwJw1CDhWBoec3weU7usauzUplYh/g8XapYTMpUNBI6vNaoc6GW
	 QoKHeyN1BQtJCqcKUGkZttN9SEhfIVmossFYVFJSNwfkW6XdnWXm2sFs1FwlPg3FBw
	 P/RNBhXPlSKlg==
Message-ID: <6d67be9a-8cb2-4339-9680-30b0ef5b0a72@kernel.org>
Date: Thu, 5 Mar 2026 14:49:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag
 test
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6fdxbqqo8hiitdka78d3td6opzxcnq3s
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3457D40013
X-HE-Tag: 1772718562-644519
X-HE-Meta: U2FsdGVkX1/HjksjLKN3Ng8VD2phLGe/ujMkBDesycZ+nD7X6VEV1ladPbvn90FmSyCNUnPxBenQfX+SmQAjCAhJ6w7PfKJ5PQCDSoQkmKDxr9udOXKUmWJX0TqwjhjidPqNCYg1s6DhIzmlKoj9X+m971d7PSu5N6tGtLtw0nCOhgMsHyzCG8EDwfmCUVL8avqbyPnZJDcuuvJ56d+D6MDh/catoI8nHS7TlIWxe7UTRgXGF2NUOSgR/AMdVtAC39EpcgGEw5S0zZifhuyRmLMtMv+g6HOUh8hey2TvgA087u0mrKo6iyBR2wAkGyLy0EdLczwSG4wAaQkd70jXbIWrwPlIMvf0aZv2lgJq3PKl2RqInOLcPbbgJ3lRA+tCYjGmprqENOEJbrmkEqL/o46zzX8kEIFqXPetvaO0ehsSIoSyiGZ4PVHzDlqYRPs+PGyuiCMPfe8R+GORKu0+4MuSVwI7q2oJLiWXQX6hHdOyLYNZWoZNv/QvRgym0OSOlXB6XoOzpMiT04h0kFo5WV/2suNliWGJ/QNQEJP3Gd2VcjiTDmDUtLU80H0rc1NSglEOYe9vgqSmhPn8iFQIlO90BvKMreZMiq1nFl/2jJkW61rIf4CvGSejNxn01phQGdLKROWOeKBXbfg4uGHiFKkezDqGvaLVmSiworBKPOltJ5dCw095mLGIbjBkgzlPYM4yvQf/qPuQvi80D7F9txH11/8QJqrkTjntCAx8Ox5TkeRKUMyHves86MQMVW8A57rsv52uiulb2aYbdD75LZ6IbyUcieokydOwvNhlZSdaR/q2NdMqhITDy+OnadCtJIcSjNf0lVjMqGwAj+XKNeEgDpxOhkbDsYhJJrOgMEsrFvxo7dAOef/nZFeYjK8yYxB+VaxOjHRKM3RY9qB+PEl39BpSVzqKuIz2QdjxZqTFuOQj3jkhOUQgwjOMwdVfSE1wC+d5TeiiCuyeMHP
 YdYIEScD
 eJcP3TCsW3N+TRrzgdjQgP2fBBQBb/UwxJieYeacW4LTekEZGiauvttsE0MkcpJW3F8CYRiOkgK2oN2/jLxy6MKg9T5Imizq0BIOKQPBV181IkjazOHjxaDw+AnwotzCW49uj84rOEHWeauEgMzS7bUBdXpyL2Ysgj7I1tUWJnhl5g9+hW2KX1ZJrmJ8zvn/SzLmNDi9jss8MGqvwhntZYX/oTb6XKNM4yU8uSXiT1rSgJ7wLNL+75yeeLB02KFwNdfJQmOczvdw1a6mlbVhyaQX+j0XfU5ZfDf1mSISN5ijj8oyYqgUf+zL/EwZ+0cRiDHou7fBm6hT8hGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
> clear as to what we are in fact testing, we now have the opportunity to
> bring vma_flags_test() back, but for explicitly testing a single VMA flag.
> 
> This is useful, as often flag tests are against a single flag, and
> vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
> confusion.

Agreed

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

