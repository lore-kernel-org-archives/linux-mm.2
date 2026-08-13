Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DBAC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978446B02A7; Thu, 13 Aug 2026 13:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929126B02AC; Thu, 13 Aug 2026 13:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F7F6B02AD; Thu, 13 Aug 2026 13:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 646CB6B02A7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:13:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D258BC0234
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:13:28 +0000 (UTC)
X-FDA: 85096892496.07.374ACD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7C2DA0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:13:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q88b+0mF;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786641207;
	b=FSBI+vjoanghivZCIU+G8QhVeOzhV6hkMFqfjOBiB9q56UHIQnKPaD7swaWswhMWTrNh75
	ZUWGATI8I7xQZLjK3YJf3ZfzCynAmJhPvG0rcmPiqwrdgmOuMbS3A8SGlrhrJqrer6xHPj
	cVbW0WWY6BdmzJMRW/VMNiIoqNHgN8M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q88b+0mF;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786641207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUOC/FC4PQF6+s0qEZTpGq4bNKV31D5cgo9gvuc/ncU=;
	b=Bky4PkThlCp3MWD75X4edPSLm58gj5Del2pqe0XndVEXs8uQxyxgSLaM4zc3KyJnED4d9Q
	1wh6vYPVkLB4DE2Swq/F1ybI6gfheidGsW3Uh7e6oGKpHr6nN0y/yi+LShoudrkqJxCJbw
	/uzTRNWs4M3pHtxT8NkPvBGeezmvFbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C0C34361E;
	Thu, 13 Aug 2026 17:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3E11F000E9;
	Thu, 13 Aug 2026 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786641205;
	bh=pUOC/FC4PQF6+s0qEZTpGq4bNKV31D5cgo9gvuc/ncU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q88b+0mFOy7f5xOve/935GyjlURclUSFAIHLWIDPPl6nplURGd+Kurct98CZVpXWa
	 hOZIIyGv0LEq7+VRCnmY1+hggNdXUPLg7y1Wu66aH4+hnJ0LhlPqfzP5Krg076WOig
	 QcvZmdUcFZ8JJVSsInNW5LXdWEq9SEuzE/kuli+A=
Date: Thu, 13 Aug 2026 10:13:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, David CARLIER
 <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jiri Slaby
 <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, Kevin Tian
 <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, Pedro
 Falcato <pfalcato@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter
 Zijlstra <peterz@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Steffen Dirkwinkel <lists@steffen.cc>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, Toshi Kani
 <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, Vlastimil
 Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, x86@kernel.org
Subject: Re: [PATCH v2 0/5] x86/mm/pat: CPA fixes
Message-Id: <20260813101323.86405fa229aa6a80fdb53d63@linux-foundation.org>
In-Reply-To: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7C2DA0004
X-Rspam-User: 
X-Stat-Signature: cae6rjixdo5bqbgkptfwd5hu83r5z8c3
X-Rspamd-Server: rspam06
X-HE-Tag: 1786641206-195703
X-HE-Meta: U2FsdGVkX189MZdoZu25OFZ9UOybtJsZ5w0ZpVnoik7eEcGbiXE1JSRjE44Eb+EwcWBoU+oCkcsnPhM9nknhduxwydMiGxRw4w4z38INH8VhbQAKzs17l9HZjAbMgdhU4LuXBatawIfD0K3ri1uOWfF9UTTXmVIUfqGfDgUAZO+3M8G8M+Epe8qoEcEGZoMl9F6WYfeOVSurLnfvu9JNaXRtp0GyGbMwHI7gEzrFC+BS+DF49W6ZP2qwXJ9aLCMRBo9R5tQzkCcF8VlP0axE2ndiMVVGAYItL042QBnrFErNjUxK5lCsi4zoPn1hxlAlSOwubiZ6IsN9Sq/oCLl+V+JwoP4Co09uyk3SZOc6ri075IMlLxDkvmb+4kfEN/L/i+AZgQ7s3qIfUcW4vVlYjxelj8sgjm3QRjApZo98wn69ojS/7Gy9w9G6PvsJuuUe5BVWv6KGPC8S01+IiGJPQWuQHdSe7tePAP8Y2V0CVmkckVxQ6YDa6cFXLHfA7Wh9lbGwsTNl0VuW1ygzevn/St/+DN4/h77nq4UiOg/J2MXCC0SiTMLnUtcljyLxhV4L7n5wcSu9zR4HHp8VDyqijI0sG/kkJB1Q3sZiOmL82XcB0fmmWzWPBgAhYv0y8j0u/1F7kWEL0b+oX908Hg84l8WUfAhS+dDkgOBdQqfh7b8wkYLBq7UszFsxbaHSMaW7osCfU5iiLvXAlwDG425P6RefGVhr1yWmGw2PXyZLk9j1OCuA6wQnbFEpGZmf/B/zi+M2f6FhSHtDn34o8QfLs+LFRQ7OAB4FTFlF0ZoUnEMLDbj+ROKlYLsCIFHdM9llD6PD1baYi8/Ja6CAePAWbnhosFQXgg867gfq+xROL4oL64Rotp4SaZgdhQa2VkPaB7tesH/8sYYYaUcsesUjhIN/9BDOu3AoT+UQ7scCbLZh01FwQau6XDRzrbhS4+OaCuUVhFU6i2pbk031R5O
 AZ80A1Rg
 Ps7jinFTsgd5I5w1bLXQqNbImriy150wlvDQNT0MIZQy+2ubki1GDjyhjI4MtTqLTIW3SwI634mtOmMBQRTdw79Z3cpMUKmG3ZBPp3wLwjCuEuIhZzO2Szl/iXlwYnajficJ5wltsc3o8T6XUFlVRHp+n/7cDiH8RLn//9g9vrLMWGdoMWMSndiJlisKAjwNSmllNOJYHAEXUs2WK6EZBV+/nNqNLmHgpnJ0D9bcUeWBBS20tKROB1emT68zZqugDW0i+JjkGxMRTVP+A60TpHdjj+N5rKKM0E1Umi2KPmk/5IVqf5i8iC7vx/vgp15HvHUULVZrCzP92Taw0xZF1f5ly8vlAY7qz3o1NjsRDRybexY3ZLg2lEOrR/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 12:01:23 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> Some of the fixes got merged into x86 tree, some of them got merged into mm
> tree and some are still hanging in the air.

I'm assuming/hoping that this whole series will be handled by the x86
team.


I have retained three random pat patches in mm.git since July 23:

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch

just to get them some testing exposure.  But they're old.  I've heard
no reports since adding them.

There's nothing more to be learned by keeping these in mm.git so I'll
remove them now.



