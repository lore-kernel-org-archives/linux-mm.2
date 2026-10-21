Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44B760A2605
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm3 header.b=dMlx8BfQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=gh24kUPn
Received: by kanga.kvack.org (Postfix)
	id B07496B0685; Wed, 21 Oct 2026 05:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8006B0686; Wed, 21 Oct 2026 05:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958C26B0687; Wed, 21 Oct 2026 05:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE9F6B0685
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:11:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 727F6A7F99
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:11:28 +0000 (UTC)
X-FDA: 85346065056.10.0362F85
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48E68C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:11:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d Mlx8Bf";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=gh24kUPn;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792573886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPQ/niTPbDxR3MpsEpcgUMSUJ1Etb5QeryWpn+3WjQk=;
	b=kQfILNDUNscfuU4PQoVVK8LKcDP3uUtn90Ve+a+/8jdIIQpqt7lWIt5/CRVwsZHkGhBPiH
	sROjJmgeVoKROEClMEluw1oSY0GGAIdHRgZNueeQSmb9+bqkUmeE8y4MkVP5kdPMgOjGVz
	+sRVDJiR7bMHBcQfB98WkvagDpSgqqI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d Mlx8Bf";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=gh24kUPn;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792573886;
	b=x9zwq7y3eYGKui91d8cju+h2vojz66PtCzWTTjLpxW2MAkJh5DjlhDY6lfv1q7ExsSwcY6
	wpa5CcNndfFpF8rmdtyW95zI1r4R2Jpvyzd7jJwV4yAF8qL0WPf7gLzKzcU+OU+RDASRyZ
	3BkSjOdp5vwjhus2ttg3Bs6okr6LPTU=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 79E827A006C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:11:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 21 Oct 2026 05:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792573884; x=
	1792660284; bh=yPQ/niTPbDxR3MpsEpcgUMSUJ1Etb5QeryWpn+3WjQk=; b=d
	Mlx8BfQTxvyHTYu9IheLpNGX9rpuU57Dikae29m49ckW/QcQePqDSuh2EMmUjtHM
	7C8rIfQVSaxULH3wdOoJj6XevbFABktAXH6eD9yltF4wKQlOZ++QRRr2fxlLMxXO
	Ypi73jf/3Sxz826j7WRtXKXIJ+iuSCzALcnBaxTRtAUOy6256H2r3JkrFlzvIZIH
	/BkLOSNGxSjj9OLH1BHT3LqnCpcGSQJX5vNPCkAX1tB6vYGuZtIhaoiHnw+kEM05
	g3M+LfceC8CiU6SBt9kfQ3EDIj/6KABllufnau+NHEWXYqwU5kCOGqg3ZBuudifN
	UwOZd3bpdpKRiqlSOkZRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792573884; x=1792660284; bh=yPQ/niTPbDxR3MpsEpcgUMSUJ1Etb5QeryW
	pn+3WjQk=; b=gh24kUPnvU1GovUH1tV+S2Ptv6FXc0gdxtxV+4E06BVgB6maaL2
	zw76y9L/XPCsGGcm7BvC9007fWA0b7DTg+8SbWckK1DZrEihyLqnVTteHWP/OLgf
	yqlhS3RNmXNGMLg/y6ofpNi/NC5cnSnuYyRgc1WZpXkeH0wZA5OwgFNcNSMFEGIr
	RT4VdmTnIOQmgIoGAEX8MiGgoMqwrUYgZMRo87UCRMAMJlGlfFqbveL65KON1tcQ
	+KaFVGEndXGU3PzeeJhxOoUiVpviuY2FK65c9RW0zu/yYPtcVCXr5HxGMkvnAd/p
	rfXFzjxCe+axgA4itVP4zeVwdrsgaih4A0w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792573884; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:kvvVzYa1nV53Wrfef+wNRqlXzaROVb8pb4Aimvtc85PhOxB
	zeOThHW1FuxMd95KofyuMS2dIZlkkNyKiqB2pHz3XHyNEBmKvVjAxBXDj5f3CxF8
	2AMrss0o24UjUuw1HCRwX5x9q34EHeVg4Mky4s0CnDrqxXD1FfzqRiQId9tkpWLZ
	bmdQT4jRipo8sLYKdYERlYc099ZCWYQOkLkkP6I0IhhCQIM8DPDWs/pQQM+RRftU
	IBPSNaX40vB4woKWIFumv8WdxFPDsa/QdWt1Ih4ONwLXmK6DtX2jt96H6+YzHthl
	s9zcZeHa9MDtjWv4m4jw9J+tM/8k+KCgy54ac+Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Tc7ukHXWIvlZRrWSU2hLvegzEyJAUHfRT7hdKA32tuc=:H7eIvvta5zlDfEdK+OCeQCYCS9ry3TLuaH/l3ceYpYg=;
X-ME-Sender: <xms:vIHYaoLbq_vOjgG9MuUSzn3yM4G2ekjnPNuMzYWS7ZtL-gN11qRNvQ>
    <xme:vIHYatWJu9f2RPtUTXU3uKC44LD0SGVW997fLTuHyLtE64Gyv2NK5IdAlo0Y6pKvN
    EN4kDys8mzrKVdpl7938CWaOBWvUVE79PBp0zFqFv7NTMmviN4JYWpq>
X-ME-Received: <xmr:vIHYasGVdT5fjyoao5x102sz3KBM8YRx-ZZNmK5cIU52ledDpR81GEU13KY>
X-ME-Proxy-Cause: dmFkZTF6nJZYKXks1Bk+zdjRqyvRREPlE6EyeftPs8J54NlJxNXTwVEDnsb75ebaKWGUdi
    yUtaHEP1racnVl7qcL6IwppZun5muFsHcwTa9EhOdbeauVKGZOt786yRL7MjUpWkMNv4dA
    6Br5zwahEqFGtKUqX+JUQPHeZOfiRQoBUWrAa/gjj5NNgI7tFOp/RtqPTRdWBWk3CV/QaA
    n2jQBMWOr2wnnrTGRDDarS9m4P+kEs70/B3YxHkZ7rf1PVO2Ky+h8YrKzFe5ML9uYmoooG
    Nj0W2ce69tdivcvcB4O/nqVDGRRb9MZAgvDioWBvUcDn7TDOYH3VRAfJ3m3/hHfsQx/kfz
    0mMyqaXT6so9/lg5Yeuu+FdnwEUp3OX516ep7NrAZVy/F8WcCWHu3C2Eq3HXrwNzu+2TKZ
    GM2aSLqF128X1QD5dUSPP55ts6wBWtnX8VNlu27EiPRiyyrSTly/0/oteQnA24x3AQa3km
    EeVm6BApj3uwneRPvJ4UNRjqZ3nJzvbaaiu4RgBJKvvLZcqUV7bP+p1VE3/DOUHfJO0flS
    zr+b97AnW9ox2FCtrN51tQV7JjwlX2F1nnRqCTCtSalSPsS5S92jio1vNV8G78x3k+fbiI
    TRnQO6iePNvYg12YgOdRlwbeL7eeqw3jnOp9N9rYqUaE9atwboRXysIv8Wiw
X-ME-Proxy: <xmx:vIHYak5opkajdHLvaXR5msfr_8VBsIgR2EyyzZvp5o_WTZr7dzA37g>
    <xmx:vIHYaqcQ9ES_l2enZo1jQ2uIU6eV5yTuYuZbCQ3vSSJ9fDyO5RKBWA>
    <xmx:vIHYagmhtQ-FjFkYyX5xknAQo47VkwX9i73nYd9ZX-M7Dpt9AtCvCQ>
    <xmx:vIHYav83C2SKVO84e-QGQQfogkRDLA6tK4OtOGqryy23jhIJ4OWHOQ>
    <xmx:vIHYar3OOgd-nJUs5WF9i_OXsUxBB3bUtDqgnW_axXkcqwbdk_vVo_qR>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 05:11:23 -0400 (EDT)
Date: Wed, 21 Oct 2026 10:11:23 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: shaos <shawnq1@163.com>
Cc: akpm@linux-foundation.org, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: userfaultfd RWP drops a populated shmem PMD
Message-ID: <atiAML2RPQlCEhbB@thinkstation>
References: <20261020110759.960089-1-shawnq1@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020110759.960089-1-shawnq1@163.com>
X-Rspamd-Queue-Id: 48E68C0005
X-Rspam-User: 
X-Stat-Signature: ym95embxtca6e1txaadubijb9yc7pduh
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792573886-897905
X-HE-Meta: U2FsdGVkX1+wg3/l3z4QUTZ1Rq1+aCwgz7GjXaS6jB+28wlzZn9iuItpmZHU4XMvrSoekuxxgFXxxQFjjFSObYn6d5P+pzrb74e8vjqF7ae2tyBcgdGxaveKOvYpp/HUZiRcr/46Y03QNmKJibvZ+UX5rhZiMcxt9zdvG8ceFJj6iO9NtZ1h4zzBK7CpzQkCyx6WUnkkJ96h3UrwVgZTuUS8hLSsAYRbTLDBL9sArRectCZFO3206bgwYDNhRRNsK7q9+m8f551T86fRZyJKkL3VwpFpwH0RCF3/Rmbm2ZmbH/CwCwChM7ug0uSUBv6p/MMxZE1sITJlEYN8bsY/l3dpb5iOysBoUP17dNg1RFY6m4rwGje5eUOUJhPwvdESWgahPG89c8hg3gL+MIe8CzGAbOcr6QJRkJtFPNFF/3cIYLJZbWnM1uGyadW4jj8Om3+Pxi84L8/oEsQPwTC9Laa1QP1yb8z4NUQlWEKwpgK81M0IxvcoRVk8Jpz1idwdMXmYqiaN82d+pZ3Mo9t7wwm49Ygq8wxPQAVmRkk5J/itLL1macyeB77hHizz1VqDPnboIldoMWOemZ4g+0BDETrYWflci22LUz5F7ehu9uZwzNmwhZ9YVTUdWvbTtprsUR7pWj0a2vM/Il7kknuCSbCaOXprI4FnrmFx7oZ+M+kAPgzVH0eea2uQYTTSfEPFvXRB+Qfj7UqHL09z7QkmDHpqchqArNWAQtHyPtyEDiejjkpdfprHHQQV1Nv+pWfWzJ5MRjaciDD9AIaFGhXrcG4FohQF58CVYI98rsFXE7oyu0neKiP+veOtph6dffAattjg/3KKbhK4lA7ssnYshfz9jqanpblzluPs+Sm5aCI0u7Wsqs+fphKDLjdqnPrkMQhhEn/8BkZ9azxLY85ZNMhgX+cTi+KbPUip5S5pGJrn4TcDLmfykhkfy+xB9byiMPX2c7K5JIMxZSGaABm
 Ip3Udsa9
 YjyA8Mvsirf04OrL3MC+23xi2VC1Wt2O7b6XAWOKb9o7f7f7hoYQbUr2KYTU497/2+3IMV+5oWKHtROOU78bnqfJkVAi+6p7b7N6GhGi83Zu6HeWhQwQNVRjBVi+UClsxHaV5ereUQeg4Bp2x8c11sgz2CfQNcv8SpUFMBne5T9OEkyf3gVCGFRjJ9wiFM4jfVQGbylyZjeksawIrTbIEH1RkPf+ZKHr5RpZyFxYs3s+u+0RcXXGgq6KeCDY1vh5HBBuMHosb/2MbcQetMhOUp1nTkHIyz9jENGxLjJ5tRdmzwItIp34DyUZw4vcv58iAyqy/IO7ywqlD3EOgD1slqrI9xzwmSO0zv7vBX/YwOMmLNYURvJMi7u2GpLuYDznyaw1GzcBOKFQnFD+l2oEv0bAIn9Fs7gm+mrbE5FyWzg3ZCzuLpZCNNPSWHHbODrtDSMjHS3kq/m+1+ghPDGYQKFp76vyP4gWUGA7yioHToZ6nRhC2GxCeenH4WrFlt9KJCW8hBTwpte+GSRHIfKHpsLs9uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 11:07:59AM +0000, shaos wrote:
> Hello,
> 
> UFFDIO_RWPROTECT_MODE_RWP can return success for a present shmem THP
> mapping while dropping the PMD mapping instead of leaving the
> populated page resident and write-protected. The next read refaults
> the page and completes without a UFFD_PAGEFAULT_FLAG_RWP event.

RWP only traps accesses to present PTEs. Arming a PMD-mapped shmem THP
splits the PMD, and splitting a file PMD unmaps it, so nothing is left
to protect. Populating the page table would not help: the PTEs are
empty and there is no RWP marker to put in them.

I think the right way to deal with it is for userspace to register the
range with UFFDIO_REGISTER_MODE_MINOR as well, and count the MINOR fault
that follows as an access.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

