Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E924CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7451C6B0005; Tue, 26 May 2026 06:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5DE6B008A; Tue, 26 May 2026 06:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BB36B008C; Tue, 26 May 2026 06:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5032B6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:55:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F37A31403B4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:55:24 +0000 (UTC)
X-FDA: 84809264568.07.290FFF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B62C18000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:55:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQhSbiEt;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779792923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z70oHizJ7ex+aoYqfaGSxeSyab+OaN4r8N3FuWXDzXE=;
	b=tNyg68OEguXIROM3Op/l38yUk9Yr0NkfxMmJVEQqtmBKoikD5cWAYg+lLAnOn54ez31qrg
	njS9CATgZyQUoBO78d0L0GkuKaIDf8sHKrNNo2K+PPOqrngq5qoUA1azKek5oEU6pH0nWQ
	XT47j5Mxqy1v9PXpqrDj2ke2OXQ8IKo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQhSbiEt;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779792923; a=rsa-sha256;
	cv=none;
	b=IpJt5POP4Aor0tuyKUR3bAFUjNpS1KdUqGpY7/nDApYCRsHeSvJ6+POQYsmRP8HCY9XCR7
	C4C+Ll0MhqKe4Z83mJsSYdSM22FLwcwXcjVhxg23t8T2mNJPRViH+XdKJ2LoqqOJdJVM6D
	CSgL2RwFG3i8RZJTlRF83OspZm97ynw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DBB643644;
	Tue, 26 May 2026 10:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B711F000E9;
	Tue, 26 May 2026 10:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779792922;
	bh=Z70oHizJ7ex+aoYqfaGSxeSyab+OaN4r8N3FuWXDzXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JQhSbiEtF2zHTc1FZ80/xc+K7/7ibZfKZyzTqPpP0cYRY/+Az00NKJrPI33131rao
	 cvSbgR7G4c78S0IFTAMbA3i5bHC/x70mWJjqnuN1p2+Z8xwUZdkPqavgap6yAh4iop
	 auhqjCGeazJ4Y2VWXTuneZawIX5KzE+hk/Oj6RPBIAhSrFqPtjdQpmOMiHZCj6V1S/
	 3akAO5YV3v5h4AGSdn+o3aAOJXtjlo3/JiyXbl++XNWRwke+ZE5DdbN3b5OcFFvdMz
	 mQ/N4Mua2XqtDRapzIxdZQwUig2cLj/WZ5hLZbrlXNCu/T+2/SUJrUIEgjeA5XB6IO
	 AVAaW0kElJe2w==
Date: Tue, 26 May 2026 11:55:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Dan Williams <djbw@kernel.org>, Alistair Popple <apopple@nvidia.com>, wangkefeng.wang@huawei.com, 
	chenjun102@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: update file PUD counter before
 folio_put()
Message-ID: <ahV7tJ2dq4wt2H_W@lucifer>
References: <20260526101355.1984244-1-yintirui@huawei.com>
 <ahV1WCxlXhOKfO_S@lucifer>
 <65570a39-9738-44db-bd05-837b9e54faf7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65570a39-9738-44db-bd05-837b9e54faf7@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B62C18000C
X-Stat-Signature: trab1wiwwo1s6ada959kxftyny96muat
X-HE-Tag: 1779792923-841824
X-HE-Meta: U2FsdGVkX1/z+xOn3Ney7yqqcVHdzGUpcop1yr93EJ8I+Rd9KLBYL0nsZ5uz+rIgwxBwzHXG4PVnqFjga0VvD+Uj7/nDuxLvOB+EF0GLZp3ny2cVWal2RTlhVxyDrDAFVQk9OhQM1FvTYwMiKKpK9Pa068JVv1bbffApRVJnL/UUCCe2lngU5yY36NWpLTwQYPVPggujfBwuP4595NanhmTBQBD0MCjIN6T8hIYGZzHIdi2ARUke8/EwVcfb8GVJt++FKBeSsn/itjvp96wo8GF3jbL8saUSlqNuu6G4fkmE30RRdQ99eyc6e1RS8CfwI3u/UPF8GJw+tk9fbSsoRPXvEsqIiqlT1RALBwg1QoNlc2U7DGkUSO+nhMxm4JWrfqKxysla7CrMJWrPkFJJhmpsOqwDzCeSAqt7pySxZntryPhIYWlr+eGkT/JRiYsgdEWj1Jpql05i+jTfCBj1d6FEUaOpuruX/ILs4U5LS/cpwUPMdbk9NPSSSxqKaWAMzZBTL1uPHk1+CV5EFN9QK9G/FBPMSqeydSyKSYldBvjr4DangQdE+lQ2lSJHmTCsNcNih3m4SpUQMB2x5OlzXZIF7MGlBHmUn0cpoBJpkixkujbebYuXzF4zDYu3+EZMwnzhl9ok31DZtfCHgyoVYzhoFiZSJ5XxM9nXyq9S8dyFLr8dklKsi+ByLIRncw9h0MFQGOY6+VkrZsc3M5sx3YIafHOqDIIV7F4jGyMZfi4OcVrTRSr7+NZRjPyeu2EsuwvvVaesT9ErB3SL6MoRQ7QIFEk+avuJIzkiyO+9aSnbcL6JYtGv5si74KQqGabOGMCFlqaJCk+teo/MvFguDUQVMGhCHNOmyKE8NPTxx7PSlnhStDxTM3uzhAOx/dYmGr4Ei107Zpe4+bfGTUXZJEElElYdmCLL+vWzTPCtWK2atNz7OYcUPB/QVcD7P9obRi5E0ZW2hNcAtbvyi7+
 Yi5KuYNt
 GjmO7Gk51JCJDQNh/Fnw7bbKfVIKugq/dHpx9XAhodKcS0XwxOTR6Zhx96sNhi6kboACnZU7LBx/rtdAMFLef0HKou6Jxvk1dZ2vF8lnWNWXCQJw4I6kxYXA0MGqNnbDjGHwES1102W1ba/oTZE7tab9qoLTvz2rMJsklU+d4FxxV1MWBGrSGw3/chIYsquMRz+abu/15b3zKTCpYd0zpEvMB8n341KOCjTV9FDeb+ACFUA0EW08A2yzsJOE/q59Q0TV8vlzYIkKFeetGHma/P0ztePSHZ3TomQYAlfoGfcINgOIQAVP33FCTdzzt38uNLhgp+UpaQauJPcFjNEj/VnHNUJ5qtnplGrdC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:53:05PM +0800, Yin Tirui wrote:
>
> On 5/26/2026 6:47 PM, Lorenzo Stoakes wrote:
> > You sent this twice :)

Yeah oops you didn't, that was just the PMD part!

(Also my mail client may now, ironically, duplicate a reply...)

> >
> > On Tue, May 26, 2026 at 06:13:55PM +0800, Yin Tirui wrote:
> > > __split_huge_pud_locked() updates the file/shmem RSS counter after
> > > dropping the PUD mapping's folio reference. If folio_put() drops the
> > > last reference, mm_counter_file() can later read freed folio state via
> > > folio_test_swapbacked().
> > >
> > > Move the counter update before folio_put().
> > >
> > > Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Yin Tirui <yintirui@huawei.com>
> > Patch looks sane to me, so:
> >
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> > There seems to be an identical problem in __split_huge_pmd_locked() - could you
> > do the same fix there?
>
> I have already sent it as another separate patch.
>
> https://lore.kernel.org/linux-mm/20260526101337.1984081-1-yintirui@huawei.com/T/#u

Yup, inevitably hit send and only then notice this :)

Cheers, Lorenzo

