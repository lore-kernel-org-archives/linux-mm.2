Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EAFCEACD6
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA8F8E0024; Fri, 14 Nov 2025 16:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374008E0005; Fri, 14 Nov 2025 16:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2897D8E0024; Fri, 14 Nov 2025 16:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 131E58E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:53:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDB6812E5CB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:53:07 +0000 (UTC)
X-FDA: 84110563614.12.01AB91F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E1BF80009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:53:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1jjvEUtR;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763157186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHIpkf/XC/lNswcjMLEXiiU8bDsom4mKKWe87AK0Kws=;
	b=PrQenklFVfnE6QftFmfoT5+7of33tejv1RCdmBfuV1n/i268Qsp1rq0+NJz1v8xSizp9Qu
	+paEVMDm6j9OVgyWBWrUjsAQvWLkMqJzW0LHdYL9nTTESvbEbO22t2TQgA1UIe3Wk5vGAm
	XmAU4MjbcKOYU+NSG9QhitBJGY3+ehA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763157186; a=rsa-sha256;
	cv=none;
	b=GuYVxSr3TtLqS5oUdps9ie+inf7VMXuJR0io7J51++pFqceT6692UaJp1bk7RSLVImzfp8
	7fkM0X7LUFV+GqyDjCPBwcZmjX/prsqJaFo8j7sEp7onSNfVob8gyJ0fn8vsFvJzOI7aOc
	b8p/EYYAAndiUYC3amfLihhvrcK9rrs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1jjvEUtR;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79E8460189;
	Fri, 14 Nov 2025 21:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C113EC113D0;
	Fri, 14 Nov 2025 21:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763157185;
	bh=OioRQDnf4lhCgkjSXiw+WwXRHc4hatCt51SsKc1i+ro=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1jjvEUtRxgda6i5U406a00pzwyzeUzq5A45UQpyVxmP3DaCbefDV6VywV6bKKk4ql
	 DKA1isuTAJIAovWHvYZ4KcIX4whmhxzGiMvNCVNPOqn1u6/WSaBqWV1fQ4Fi9UNmgu
	 GPPg7UwpJmzFoNYBQDb2W8iBJip8MB452xJi5UM8=
Date: Fri, 14 Nov 2025 13:53:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Message-Id: <20251114135303.878b52f6db3dea4596f4c11a@linux-foundation.org>
In-Reply-To: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E1BF80009
X-Stat-Signature: uuhi8kif53zm4cg4cxm1suqj8ex7g1po
X-HE-Tag: 1763157186-915884
X-HE-Meta: U2FsdGVkX1+qzSmmH/0AVVCadaIUTEzI/ISnBx48XLfryW29SXWWWzel8kCl32yJlqJTiqj7N+DiHrpXjYNGOW3VSzzBthKhYZQtXxMVNr/9RVZX54MM5irGtOPr5P0AmLuz33MeO/vpTWWSBLcEU39eJLr0yMy6yASMKVEVTEhygtxMJCO7JjGr3+dycbT+woPkXuzC3tDLvFfLujM2bEoey5Ng+pRdenWv4LJMukCLgfjGgwqfrhnNjqWg1xLKXcp+LZh/2TaoDlkXIVs5QLTUFdObLMgUfa66WiWvP3SctYnk0s6rimNjkrduCNv55ndgJIpvwZ3lD2bo8YIwHfvSwRdPp1VEkNu+6on9YoII2bdYRo0knf2vaM5N3sruba7F23EkkIGqC36Ul9v0V77yZo2PXAcMzquxAU1E5qx+SoSeGRZ6kFW+W2kW7YSj18YwucEKxLSh5QRbqkPlZx7UyEnw1w5KYI6JnbN5i/GJ+BYm2N16BFfq96kM70mj4HP2/Gl61NokBYALX3GMXBgr0ee2ThNIV1LpNRUxCKsxDckf1blgHI1yrVPlqpp2jU5chV6Ii6rG1vyJzZ3btTn1lgOcjuHXIrWZlakqTc/E6UIkXCRBeY9UsxxFkfgQMuzl/dtmEAXyGWyHjk+FHEHJX+QT8NUtjwN/1vI9hiSm6hcVxicq/RJBIadTwGcMED2JJ4tsAXkBCJbq190rCjIzSb8GLNO/I+wWw1DtD3AVp/19gByNWh58k7a8RE/VYyvN2WcxShmp/lX2zQSf3W8TV3XXFLpXOsZtkr7pZy+fGqlDGw8js2wlZ5GYhJr5HHqXfqDuKu7lUkfvyqwQFVpJAgzTBPIEsEXme/ikR+J0lCSD5OGTNj31YGPHDek5H9ytt9s0rfaagcOvuLC/jr7trv1gsfvrcZ5g5XiQAAwV4b6iz77p6sUI+QB+1IcxsaHNwjRz9lU02ya4VbI
 xQfAJ73e
 uzYtXrr05tsyV3StlgnYHz6Wz1hK2kPOlv4rlc2p6/kOYlgF/Rxuaj60fLwisKSFzVS903+txRWURsZ5XEL13qavx9WVeEHdjsVYWwwsauDMFjw/a8us10yhZln0yf6xOor2ya+lxqBTzXWyRZciK72sZOW01qoXNTYFbkaXSTQF6fu7n45USTq9mTjVnPvAo3JNGa0C7ZTpVUI8SbsObTr2/AhBi2zuYClc2kOvqhD1/ruX+19BEzmjnaWqCfIdU1taR+OYH84EQU3mg17Vmuv/ZtMFMxzrBFfAZH3Uudfe/HDm9OAz6UR2QDOKBB2pZxYk8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 17:53:17 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 

userspace-visible effects?

Documentation/admin-guide/mm/soft-dirty.rst tells me that this can
already happen in other circumstances so I guess it isn't very serious.
CRIU inefficiency.  perhaps?

Please review Documentation/admin-guide/mm/soft-dirty.rst, check that
it is complete and accurate?

