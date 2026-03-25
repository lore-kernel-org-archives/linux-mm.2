Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79DD109C055
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38176B0005; Wed, 25 Mar 2026 14:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE94A6B0089; Wed, 25 Mar 2026 14:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFEB46B008A; Wed, 25 Mar 2026 14:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBD066B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:28:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FDCEE0F19
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:28:00 +0000 (UTC)
X-FDA: 84585419520.21.9365AE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD7CA1A000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:27:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ahl4PxDM;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774463278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpBw4RUY8JjxM8HYPYakB9zRBXoDbpL5Vame81dIANQ=;
	b=4iJziQt0Pm/riSkeJSQJ7QW78XYS4M403DRSJWBNTKEkYd0gZKyPWEaSMilZ4BMNydD0c2
	OirJYtNUQ9unm7jjsdmmrEpvP50iPHflNZiho+Gcpvr23e9F0hxjBk7RwbH+T9gEacfuDy
	BAngZT21M9BiKutidcd9Xc8TU1cZpy8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ahl4PxDM;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774463278; a=rsa-sha256;
	cv=none;
	b=WItGg8z4rQX8IngInVw1e1m5E1KK3bLsvUpiZP7yvCOrx9eCS/Q6VA5C4ymD8DmUDgBuoW
	Dak6J3NpVdxaz8Wr8Hb2RzbgkZZwzI8WKbw0VHl0Wm0V7tHAkzCi6EXJGGXAxelBI5Z5MP
	/JBuGFoNbvC4bf5q2Z6od6Lns6EJYqc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0850D60053;
	Wed, 25 Mar 2026 18:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DC5C4CEF7;
	Wed, 25 Mar 2026 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774463277;
	bh=hpBw4RUY8JjxM8HYPYakB9zRBXoDbpL5Vame81dIANQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ahl4PxDMAZ4buO2ISagSICzQMCXJfWkl7I97eQ6yR1mOWfRwIu5UCh/gTbztrdxGC
	 fyA4HaqEAQXvNkPRoB9oqv1WPgBs8xAqNMYN0V08jI/FvWZ2bJt3m2qa09whBmgni2
	 JtFJg0xwVqAE8hSGnxFjcSYieb7qyA4v+ZsDWGt0=
Date: Wed, 25 Mar 2026 11:27:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
In-Reply-To: <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
	<20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
	<959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD7CA1A000A
X-Stat-Signature: 944sifn9ffp8t6cyy85uok1wad13e4k3
X-Rspam-User: 
X-HE-Tag: 1774463278-737602
X-HE-Meta: U2FsdGVkX19LY2bxaaxhwQI8YvfE1UbVQirnh0za3ZCuqS6RPfZuO11k7VzLjlKZW2c0Slp6NULeJMQRcaajlcWxhqtrLJKMKSf4HzfK78tSzrpnBk9v1sfd63+kMcFj8OuBwUyYCmtoaIZrjJU3OgatxlMS0p/ZmP8iwVrECJ1TB9Qr6QZDA306gvExicEaNR5P4BkYnJMoRsFDRXjfZKyYfJV7nd5Py4QCrClsMUR4lX3au/v5vP95nXQ1BUwmIRCLf3GQaQupt+zomuGu4oVAwPqAYBs/plHRsp70uYuIa9dYMJUeuf7deq5e6yIaL1zy+m1FIhMvUbxtGoiJoFIDZ2Y6KNtlHxvsJVQyG9XHBqCh7ZUfVooL2LkJeG9NMrud1sFKHfFy/UKtfSKDHjZCxyDHcdMCVItevH9uMiTjBBZU4Zbrq2iOD9Zuwc2mvJNL7XLULC6lgdc4WfP7+fqBJ5YduwKDqTdeTcf+SSOTGmTzieFS0ZRt7TZDJYoX2EQtIvsy/pdwqEJr7plrWQfAxCmgoggTGH4vR1m41oUujDjOMCn8xMIyjZ9JdjY+M5WWTsl6Da0G9l0aBAh1rMNAO6RrOuKmcbOBCusGdO69936fjYJGgEmapTo8pO05qk5LcpCB2ddNtE7KoZ6o4Q8EUGYI54VbgNMCrFcazELxzRTE2gRtbqCkm/KSaxLNad3PtAqq1rt1FA+yD+h/MU8a8l2wlLpNZ0lbzFPKcMl/0V7ZEM7rY0BOIfdjQxMA2LMUBj9yEDhagvcaxBeK9bPHoeODlFC1OjW52/Z0b30HyaTDsWdqwYNGVC+a5T1OBrYzLS2HZKg9Y+lSLTzxu2baJ5T2BIh/99MFCXj9fWHWvRGAEbGeavU8XAWn3jPmUPqrbBBbpyRvPlsZUZiIHUyZUuktrCX6n6dFTMNCm5SROgcwfULuTvJaKw1iaUjoHG5LV6vrxGY+PoNTae+
 c0BEcwqU
 55Ok7PoZlX5ePNica3GDw6WmcgcsanWreN1fJTKmzaWCvbR0DPc8bMaukImtEfzleWR9sFXFP1bxE4FfQitqONpRz5eFoDreZcA1sIomdSBuLZbZUt8tFA9t/H6izeWoY9AQ684PtlzcwmqCEU/+2G73EV3tjdrNI/z2hZyX0MbFHLIvNkx6jOoK0OUABzDhoY1O+WGSP2RU7yO86/txhpXUx4/U3EWvY/r1PhQwxh6O0WZ27v8nDce46Q7im7ij7XDnjfx4ze8a5/Di7oJwYLtws77IDOUJy3uBhOul+bb2/9fpEkoDqIj5VkXhSrfhVf9RO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 16:23:53 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Maybe 'into an inline constant value' is better?

<bikeshedbikeshed>

How about

: Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
: macro) always being inline, as we rely on the compiler turning all
: constants into compile-time ones.


