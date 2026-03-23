Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA72F4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249F86B0088; Mon, 23 Mar 2026 11:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221956B008A; Mon, 23 Mar 2026 11:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137406B008C; Mon, 23 Mar 2026 11:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05FE86B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:47:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCFB71B9218
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:49 +0000 (UTC)
X-FDA: 84577758258.25.3859E5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DDD5D1C0019
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPjnpfdE;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774280868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJG7rviSzrQ4mxNP46Y9gYTa/9q/Y+t8JYvzFfU3sy0=;
	b=kZP2VGbLOH/lAteX14fjfL+Ui4fvCcX0PPPbVbXZq49w/8OxFJoKeMCoO7u+r0zIFOm8CD
	sS6CjcWWmRGunYljf385qk6RbzijB36joa/fKYW5pduj336zQw4QZ0i9Qj4pbKPxtkbfw6
	Y7tdxNPxGr6teuyUeNgm52HBWZfB+dk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPjnpfdE;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774280868; a=rsa-sha256;
	cv=none;
	b=K9Pmv16LNZLC4Z+P4GQyqxGy1q/p/Dg0uiqcWtnLJKCciEHVRnZVUOvtgutXPMHssYE/j3
	h4alXfy8mMr2cu4Cofam+8xN/M2C3uKYfrEJ0FDokekZBt5yC+Z1NVg8Zwc0U5i6aZIkq1
	QpJsIUIdB+XKmGR+rA/CiH2OLcctotI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DE7743B0D;
	Mon, 23 Mar 2026 15:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1465C2BC9E;
	Mon, 23 Mar 2026 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774280866;
	bh=ykDj0Ppke/lrsvnXc74bDdUkqngFPXP4WoK/RTIL1I0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KPjnpfdELqJbpC4ncfqddvGU9IIIkup26qddC2aNixhFBIb9mHkF5A7epXJQ3KmSH
	 MuLQQp032z1JuZmOTzDCg5uhT0pMXLmk69mazn1wBoES5rRXYs+2i01B39tCb0fgwm
	 eMVmp2zxvVNKgA6OUptqx23bwS7Xpo/9N86ZlA8ang/MlqIECTmX5MKUewXXQzMnmh
	 QUNRieF4AKOOU9JlQtW5hTno4YlkFFGvDEgeAtLrbiTNsDF5KI83hQ66Af3sBzXk2x
	 2EQzT+rnWcdOU/touJNZDWaVify96eKObV19ON47GNNYH2ceCv+xCHG57JoxHjqvXU
	 vAON7QUwQBDNQ==
Message-ID: <cd30724b-15e3-4642-b19e-c464d0978282@kernel.org>
Date: Mon, 23 Mar 2026 16:47:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 23/25] mm/vma: convert vma_modify_flags[_uffd]() to use
 vma_flags_t
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1774034900.git.ljs@kernel.org>
 <51afbb2b8c3681003cc7926647e37335d793836e.1774034900.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <51afbb2b8c3681003cc7926647e37335d793836e.1774034900.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DDD5D1C0019
X-Stat-Signature: pinknyt5gjysknh5nhsn7n9mmc5zodue
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774280867-867315
X-HE-Meta: U2FsdGVkX1/uRunRw2CbJ5nlTKcx0UV8P+I6YGsAeEe9zqUW1xEQHkE0mk4UNCN69owWE6OXx0ISwSpXhaWj1HJLqQQ1Km586b0lEvnfLkCOniJEKGlaSPh5DuVYIMKTVjllydfZxWSPZktlPrriPjqBpDbSOQbwShb655sAAvvqFwd2ou1hYrWjrfDT0JRteMnl3KEZTSl+kQLqrYEI19r6h+bcs3sEafcSuDRdTGDKrJVF0wbrkR20htfQUlWbd5wVAKyTOlQHuY0PqyQXVub5ytj7RcI8bY7wGb8s/QR9zveBUSanm6N+dcxa0+ggpd8EfPAXLynZ0c6ec1HFUzDl3o9SDpKc67RK7qR/NHqNYT4W0yvzukzGk5nFAUcNsHe/hcy75S2tWWTjcOKWk2sMzqyQO4DH/MJi0BLU15eNQXD0ip/yJcK9CNDckdhpfwWi99UpdeXRR0IrhH0pKAfBaVFoDcoWP58oAvqePTBOEFaOk//VG3liW2kmidzh+2KSm/dq9iq+ark1vzir1DQbUbCdwGFgtouI1z3QNE4sD6EQYkwGPl7Efm1+MEEZu1VdwxUgLdzvOuf8V0O5dkOILdg5JYyunPoZeXDCGvywJFBMEknpt90pQColiMAJyYSV5DNmP+cQwyhBbZmzjhhqUnkQv2iVXKx3dbngC1rdSPlwBpKFtl71INx+JDmU8+sPJdmUZI33N8QMrVc1Sat3vTWWhSgUl73pBMBLf0my1dIkUdHWChcpebj9/Am5IhThan/1if+Y8d/1o2B6On36Mb9b5hvYqdqx1vwZy9KlWBndLm9uxuLDmA2r7X1xk+BsBsh5HSdRb506kCyWyUOr/mpUfbtx/1rPdhF5cHIGWeCujcxPod+QBPpW2jD9RlTPmRQAQykVB1HYDaZObfj9IVCB7JzKAWRWH0Fu9np562fHnS1vgHcAH20xDsu7kW49ySLx7IFppId5Jla
 k0Kk9IaE
 w3bE79l6lsBtWtovT+tY/MJ7waQ7xpIPmqwQZ8RaK817bSkVcsomsBZNqgsHa18ugfVGwmp47wxE9kY14bp8W2X/P1bmmsVXTO9SimqEuHS5UEERXvZ4ITkcRG6OMYV1BeQ7fPiewg03Z7IlcCrt2KXMSiRV2oHdEKmOvp32+D3SXrRu+tyPebJLM5P3/2PJJasb/y/hlKh1CLXlQNYHvNCEGVWNkZQJq+w1syhzX/BBEfQvi5TlgNF2mg4FhiwSniJTSapGRcvxOdzPlWsWjv6dp0ElFghlXT7FgTMXcqmGDcAgBXJGmt/s1cb2g90lHzHOzKC7OSM/2/zPGsauHZQodgi89Kf/B8y10nntBMSrMKPLGTkiOYAsvWOWShuo+jbBTgAtoxQRcFAQnzte9C7pYgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 8:38 PM, Lorenzo Stoakes (Oracle) wrote:
> Update the vma_modify_flags() and vma_modify_flags_uffd() functions to
> accept a vma_flags_t parameter rather than a vm_flags_t one, and propagate
> the changes as needed to implement this change.
> 
> Also add vma_flags_reset_once() in replacement of vm_flags_reset_once(). We
> still need to be careful here because we need to avoid tearing, so maintain
> the assumption that the first system word set of flags are the only ones
> that require protection from tearing, and retain this functionality.
> 
> We can copy the remainder of VMA flags above 64 bits normally. But
> hopefully by the time that happens, we will have replaced the logic that
> requires these WRITE_ONCE()'s with something else.
> 
> We also replace instances of vm_flags_reset() with a simple write of VMA
> flags. We are no longer perform a number of checks, most notable of all the
> VMA flags asserts becase:
> 
> 1. We might be operating on a VMA that is not yet added to the tree.
> 
> 2. We might be operating on a VMA that is now detached.
> 
> 3. Really in all but core code, you should be using vma_desc_xxx().
> 
> 4. Other VMA fields are manipulated with no such checks.
> 
> 5. It'd be egregious to have to add variants of flag functions just to
>    account for cases such as the above, especially when we don't do so for
>    other VMA fields. Drivers are the problematic cases and why it was
>    especially important (and also for debug as VMA locks were introduced),
>    the mmap_prepare work is solving this generally.
> 
> Additionally, we can fairly safely assume by this point the soft dirty
> flags are being set correctly, so it's reasonable to drop this also.
> 
> Finally, update the VMA tests to reflect this.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


