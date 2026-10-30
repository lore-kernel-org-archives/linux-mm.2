Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E523606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QlrsuYA6
Received: by kanga.kvack.org (Postfix)
	id 85A776B05B1; Fri, 30 Oct 2026 10:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BF66B05B4; Fri, 30 Oct 2026 10:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB9A6B05B5; Fri, 30 Oct 2026 10:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 501986B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:39:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D5031A04A4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:39:52 +0000 (UTC)
X-FDA: 85379551824.26.4A9C6E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87A1B40003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:39:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlrsuYA6;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371190;
	b=fNN3uW8+A5JXAdxs1gAuci5IqeKkvheswpazXFwhBLyAO8Qib1aKMIo9JjXbcH4a5k/QFK
	PC6snpcgz890KdWaFjnPTcRr/HiqYxGu7+ognYFVH9YkjS0hSo735E6Z1ee7F8K3u8O3S5
	2lXCLfFD7qqFhOG8mICz6mKe8B6rLrM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlrsuYA6;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKRevRmUwUIKRTw8Grw6ZvIs0InwSJnYXmbgD1Qkg6c=;
	b=7fGp7Yzr9qpffsx6SbVRtzy6L3oGtIZHLAGI8gGnT/5BxLvt6PMD1UPlwZn35Mu0cJTolV
	/Cp68kS891Vfd2c2WYzDAP5icyZdG1qsE8nsdMIYAT7fMVBV5u2qzP51tsfx4AR7Hz8ucd
	qJYB21EpivqC6E93yWmkCTo76/xdXaI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4B4343E05;
	Fri, 30 Oct 2026 14:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9CF1F000C1;
	Fri, 30 Oct 2026 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371189;
	bh=oKRevRmUwUIKRTw8Grw6ZvIs0InwSJnYXmbgD1Qkg6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QlrsuYA6mex7jjvoZN82HmAjIvobJ74fu3R5Y8i+QFMLcTfyIePVM7xN1dyaZmXL7
	 GjfsXTrC2E34yDNgbOosBLx8P1/GWkFdsQisfKlchJofAycGG2qTtm4EUPhnyJFIOI
	 JBk9cXZ8V6+rN2p4bMymv58olvcDnQUINMSfh8zSONnumclsw57PNhgNGT04t0Hrcg
	 SBCkVAQskvK73TvZvea/JgHI4FLvM28tAO5Wi0s1EsMv4sL5sTmSK5ZUfy1PvOI5x2
	 5RpbnlG7PUdvXlVAxc7dECd1qmUxZp3CahSsHL4TIMHfFgNcTZ6cxwUXleTIORKHQk
	 HPocaXD+1VfSw==
Message-ID: <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
Date: Fri, 30 Oct 2026 15:39:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
 Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>,
 David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>,
 linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030121113.GB3889730@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9ud13exhcqrqgen9zc61f9b51uzfdo7j
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 87A1B40003
X-Rspam-User: 
X-HE-Tag: 1793371190-408551
X-HE-Meta: U2FsdGVkX19upbW8kzKopcGhGkvvyFOujho4VGjmp5GIxwkoyz7mG04jGPouMCEqV313xCv+Y7KNcxpoFGM0eeZWR24LPdWVBfqt/jxpaeT7bzm28sg7sg6IzqtJ9nX1RWDe2BofJy8hVEblJveDLkzMYNEJiZGFgjsvuw8Ok1LXGJwP2dWCNAgMFPVjpU2Czlldl6h+1Px/rUVSdOr30/wDiJZA/L5zIQk92gw3J5EjviTRGxC7Oa6kc2vAi35O1xZ2pCqQ0OZXKINB6zQ2ewOQ0+Mp630RtPVHQ6AwvhJ9PrIpNPPRIcJ7PvI7t+dElfEU7vFOXO7CXCVPewODZnSiLzKOTkgtPz6ZXUEOy+1Hhl/eK7xQTaQ5cbPv0QE/5LxHDReWN1TRvdtKS5eIYki1hkvGPGkJsraLYj6+RA1C+amBmRc+KOPdlJZGLKVbYlgTxgvS0fQjWTYZjVBE3dcscMyAlCSprR3IK7Vw04AVSEkkFCIP7qvs7s4r4g1rjo4VdKtI+KXYLE1lj39pcnF4st0Mxxq7YjiYw1bmkah18TFiVTmL4lc+Y4ktrDkHKVC6Xm7ZFP8MQLgaDlFiZ3FvZmaru12RDk+idzbiU2DCgHXEH5Z4tC7p9brOnmmqI+duJvOPbCxmwwcgs2nkIX7k6FChnzJx9axRpRbQ+nU1AOtpsxa2CpPV9FQ0BoMIt2sHiPir54oGlHM84/wfLoq/tBmalDhB5i0PQsh63EnL86ka3huot7CFZgEB92xPVwOdjvc0RDfmoc2pF85tnJq8BI/0G6I0xWLG+i6jQJC7Vo3n66Cz0ica/eG9uqZYStKkVGVDtqRMh06BU7NVM1xOGWgxZJVyUrI0h2kzr6nir7NSm7xCKNOMQMfnlRc6A9O+FDyKp8raxFqdRK40CmcugIwXCWRToLHyv0UvAj8DZc05Ew7uZpOZOAxv3KnD+4PLD8Rj/fSIjW2C4T3
 mv3bYD+I
 rvVJoZBC8V66RwjVfslUb8UN4MYtjno9SklwTJX7Cyz2XqFUOG2dO5Cm5u4vzZEFfo3BG4QnVXyZF1fhO+hYJnEggBx2TsAuV+QjI/8W+XffrsZPraObrBd7Ui8jJyQ6jddhATS8rpv1nh6g9Q9xDeBoDpy2r459lsoQhnPncPxqD/gFtUnQtCzmQ8Tb49OgbMvnyencu+aInxtO3sAnrxOc8yiNFEm+kZUvNFXp2V5ZIiMn0EP1VhafC0VWi0XgoC7BfoI5lLnnki/uAsb2fs3jGT/aAReg2XgeYx679H63rOI/FbNU6GIWqPt0vaR18AmoD2eXIA3SWHtbbA6IAuSW+K3Q0JY9hGvjVGfvJIJnMG8zs4p+UsXcSkZlOb7gMoQEB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 13:11, Jason Gunthorpe wrote:
> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>> On 10/26/26 23:05, Samiullah Khawaja wrote:
>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>>> holes from being punched into a shmem or hugetlbfs memfd while leaving
>>> the file fully writable.
>>>
>>> Background
>>> ==========
>>>
>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>>> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>>> device for DMA. Pinning keeps those folios allocated, but it does not
>>> keep them in the file. If userspace later calls
>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>>> the folios are dropped from the page cache while the device continues
>>> to use them. The pin holder is never notified, and from that point on
>>> the device and the file silently diverge.
>>
>> We have the exact same situation when userspace maps anonymous folios into vfio
>> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
>> used for such purposes.
>>
>> User space must not zap/punch things that might be pinned elsewhere.
>>
>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>
>> I don't see a reason to make userspace (that should not shoot itself into the
>> foot) a kernel feature it must activate itself to not shoot itself into the foot.
> 
> The issue is live update doesn't preserve those background punched
> folios and now we have created an UAF attack on the kernel across
> kexec if you don't do something about it.
> 
> There was some notion here that with the right sealing flags we could
> tell if everything was 'live update compatible' and then know that
> these attacks are impossible.
Just remember that there was any hole punch and refuse to live update this instance.

We could likely implement "we saw hole punch on a pinned folio" as well, but I
don't think that's required initially.

No need for more shaky seals.

-- 
Cheers,

David

