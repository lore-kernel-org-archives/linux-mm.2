Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470D1CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFA26B0092; Sun, 17 May 2026 14:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790F76B0093; Sun, 17 May 2026 14:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD5D6B0095; Sun, 17 May 2026 14:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0766B0092
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:58:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02CB712056C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:58:00 +0000 (UTC)
X-FDA: 84777821562.26.AA23270
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 518E9A0007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:57:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j12Nyp5J;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779044279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16+zieyMTrJtMicSjolIgLH/2nyTkE4OachXDRLPQoA=;
	b=cN6v3kMhc2f7Oegms1NMbVBc4hgClvUHk4TcTER0AWb8Oc90jMmf6CCObGRI7qe3PEDa/C
	WHWnKkZX7vUqhDXhvHJauIh/dtFWrORpobWsD9/1QL47tg/TXkgVIpGBpXCDRRzOGzW0wC
	UYc+hTe0pzDij+C574XuctFDsqC0j+k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j12Nyp5J;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779044279; a=rsa-sha256;
	cv=none;
	b=ww9Ld2UPdoOoNKgkOOpcyZOZy5BFZGheNTsd6Fcvj3tb8KeWOucPR6UhfpanSnlL8NRyhW
	DUNfqvfM9Jctl2NyuqHQAokYb4snZzpjVzcgEURF8DjceJFPa8hDY5f1BBJsD9g+gJtIv7
	25ge+EKliqMdR0DBd0L7JuU6EK9QRi4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEF276001A;
	Sun, 17 May 2026 18:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F758C2BCB0;
	Sun, 17 May 2026 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779044278;
	bh=lgp1Y0cbFZdL+vpyXlbpNuIdHM3vcSmyQNICRmFJU1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j12Nyp5J5wC6T9JLE39GMfLmW4mELfC1pSEmPH/aJV0RAFEGIIGLiDIiiUTuW6pyU
	 dGLt9gMFIH8v5i5KeL7WsmgjcClNdVlp6e1kurv57KswdNv24MRqFKcoVbLBNmwwJ3
	 Or+CqdG2/GxZdeUGuSBkBlIaqxntMEf+WuPAY3AEFK7NjUlmIgjhcv4GQUeWEDIPcr
	 uxY1XiesgRFCXsJ1wN7b3TeGgU/pt95P2xUxHkJtq7Lki8VWMp+X3qe1NcvGA7Ouy7
	 9QzW0Sk9lKG2x+vs19TEAdKq1sAJ/uzutqbwSrbBDSnA6Db1a+HgHyETqzLxjR0QEE
	 3K7phS0J2JO/g==
Date: Sun, 17 May 2026 21:57:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V2 01/14] mm: Abstract printing of pxd_val()
Message-ID: <agoPrkN4mJxSYJp4@kernel.org>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-2-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513044547.4128549-2-anshuman.khandual@arm.com>
X-Stat-Signature: pjar6xxh6a47eqygkruhbaxwiy14decn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 518E9A0007
X-Rspam-User: 
X-HE-Tag: 1779044279-646299
X-HE-Meta: U2FsdGVkX1+PwLb8eIdJCvS1dC+4dz40E0REBt2w4u4COezbHSs2GaY7hoENsjH+Ye27U7kFRad5+AvGUkInY5WCP+rJlNAUh58xr6wB/c60qsJmttN5LRVtxiZb5WeGmHkmps0WOdf2x2waRnFQMIS7J7bYDrqLL8ReJNLwV9+bCjfz2z2Z0GPMqx9eNiENT+rOP/Mm2vEgH8krCttmBa4LVw6tEJ9jRCBpAzowjQ2f3IFXiR4edeqhO4551rTT3tLVKQ12ie1dAQ24oSKjtvuWLpal5Ozi79M4++fRzaeByqMOeuBTfUCNiHfQpwpAH7C8yIeDBaSHmkybsuuwbc9Gm6M9TRPJCIhNybpiWguA4Z/QKLaNiWhhzn06Zb/vIaN9XFDwMe9rbMxctQkhNxCDtY6qNgZCCXv9+Bkty0C3uY+P8dlWqVhMtSjzUbCxVaScndz4XIjUpcmfDJhP0JlBT9nzF1rd6K1zyNXTmpMP/4Zi0d2q/VL/Tkn8t77W7DE+ua2yTqBbkOgy16AzF9o//NJD9GzMV/tYSk5i29ebUq3zS3l+ar0+MxbWmgkuR4Z+7JiF24AM5Iwz1Y+HKUwfHtmp9LVNGmbAHFJR5v82cFxIPW98tC/MYHSvooW4qJNbuDFUobLPM/5IFCempl1OJXnITrSW8lVSF5f5zX1ZfFMxVLBInAVRga7a3ebS9JiI8L18Opike+Asx8tdEBY0toNbQg9ErJVFmzcyjBzw/mHWfYr2Nw3TIN9EeHuIPoW/RD6BjTT6bpqoKVxK6l8aoUHNI75SQFAKfvH/iCkt7wRFgskHSCJOAhNO38UxqNqHBj2V6PLzfFB3BkM/dOUx6WDKyb9XT/JKkhfGkBn+lEZskmSup/3F7R2b/JZqwVFsLXixVWxXLCCcbEQDwheLAsyQhFVklxoUP0LQbHqlPiUXsbd2hzrQ2AaavmoxlDFZ634e3Z7ilYPCM+c
 GcWfEHV+
 dT2bJIoEX6A+2JFIxKPhg9Jy9NVEvL17m/rNcYmWu4LRrEDUwqew6z/I2LWR/HmpRIsrUMr1jFBdqTyjYURFJP9IF2TusvsjJ/16RIv4aYNlrXEayO2r6xVpb0ngQVLWpz8K5rkLuGGlYPdJsMkkiybhMxNSVTUXb08euXFIi2Olda+YbO3RZBwIBj1KVmmLnrd42Bua+42pHLnSAZSFx2yGoIrND9stAqY+AS0csAqBaj/LwvJ4hlAIDMr2hK3CLjMijWLByYRrqwSC4q+Sx3dl8UW3SfXO5cTtwyObXVk7R4apOU5aOzzyGGyH9c3dzjL//W1IqqUl+1W/nXdU7GI/odGtp+FMq37kFQnInxx5IDBfDXgjPm4DWO5+r5W04wE+6lRBKhxRpOGna6Ce9ELcM7MSPdKeL3dgXqWKjCWH7Tedw1oeb8l37Bhqt6G4R9hZxKx4rEEoI4kpq2l7lUN9E8G60vO4VXp1mI+jXv8u7nebp3sLsXmP1Kgn127WRiuCpdrzjEYCkGzBIg9PvqL5qyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:15:34AM +0530, Anshuman Khandual wrote:
> Ahead of adding support for D128 pgtables, refactor places that print
> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
> macro to prepare the argument(s). When using D128 pgtables in future,
> we can simply redefine __PRIpte and __PTIpte_args().
> 
> Besides there is also an assumption about pxd_val() being always capped
> at 'unsigned long long' size but that will not work for D128 pgtables.
> Just increase its size to u128 if the compiler supports via a separate
> data type pxdval_t which also defaults to existing 'unsigned long long'.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in RFC V2:
> 
> - Moved pxdval_t definition inside generic page table header per Mike
> - Restored print format in __print_bad_page_map_pgtable() per Usama
> - Renamed __PRIpte as __PRIpxx per David
> 
>  include/linux/pgtable.h | 11 +++++++++++
>  mm/memory.c             | 23 +++++++++++++----------
>  2 files changed, 24 insertions(+), 10 deletions(-)

-- 
Sincerely yours,
Mike.

