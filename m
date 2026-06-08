Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FF2CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7136B0092; Mon,  8 Jun 2026 10:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697636B0093; Mon,  8 Jun 2026 10:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD5F6B0095; Mon,  8 Jun 2026 10:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ABE76B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:37:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C55A612015E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:37:17 +0000 (UTC)
X-FDA: 84856998114.06.FC8D161
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F90E40007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:37:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j07VGJdK;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780929436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBr8PiU7vWQLlPrHpDw/6kTJA2t7TuI3TV45DUb6XMk=;
	b=ewpoiU7XLArUtngyYLdKSNCTSZD6UkJdw8sU1c9diEabJfTgBspkaoENHkM+So8ivOfmoX
	9NRIBKF5j7i80GVQzPEa/Iu96WfeFCue1gK+SK34YsKe9muBf25A2/DgnMIxZSvA35bXTR
	M4ORKMBg9DY6yBC56k4sKgvimPvAmCY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j07VGJdK;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780929436;
	b=l0BS833Z2QVgqoyPpBvW5QRCIyzjGQu1IqOmSIXRYrxP5IKrUGO5h+ivjnnDY1hDQfclpz
	+4/Xqtz69Jf8ASC+PgDZLAihOi93gNudnd4dcwShUWwFLHfOd0A2vS2JIdNwxh+QBtwa0F
	TEhB/w9AMC+g8J8SdP1IV8xSfEHGZWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74076601E6;
	Mon,  8 Jun 2026 14:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFED1F00893;
	Mon,  8 Jun 2026 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929435;
	bh=uBr8PiU7vWQLlPrHpDw/6kTJA2t7TuI3TV45DUb6XMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j07VGJdKbzFDO+1G3fCQcS/gaDMdymxx1YOSKH7X7jb31os3dUjM++/1kZEPnDulh
	 eUlPYtv5XNpiuWfWqR+TUuYJgTZDuC7ngGx9nL7apAYOK2ovAUnsdDUsbFlIZdIYTr
	 /SnezjuEcnGMBpKWcWAg5xrtRgxGaUUEDNUQnzGNO9uRSKgHQIW3LE3ZK9oQz0QxqO
	 V+D9OLBU/P7nLaWPoir+oEXoA8tC1pe6p+DQD4qhFWcbRy2/8c9l3BPGgk0YM++aNk
	 NcFGPalvOvcd6eKR4K8wZLpA+jxg3+w4XI784IDl/o/A5rLQzUNMMFvA9Aq2CMr12m
	 RfVCXpq1tljaQ==
Message-ID: <ef14cfdf-5f1f-4e3b-846d-fe1462042883@kernel.org>
Date: Mon, 8 Jun 2026 16:37:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org> <aia-q026facbptoT@lucifer>
 <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
 <aibSPsc33YQiYSMI@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aibSPsc33YQiYSMI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0F90E40007
X-Stat-Signature: h5r13b7aex8gjf6jfg5grjgxmon7wdze
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780929435-279641
X-HE-Meta: U2FsdGVkX194Z6OEMWNFv1yt9zznoKwVr7eAzVjqK0VOXbTCx+qn0sHnbJUO+fxPGRnGS55YO14t10l4BCScHXcZJsNA0Du/AdGF/y/cb+V0DE3ra7R6y7vrBaZlh/9g/e3s8v1sxfvMGgJObFuyl7ENjj3ZitOhNQ3ya+cfU0ovD4s6PG9/Rv7Y9JD6MGT3qDpazwh5Z1/Gkzf9FqAwtVCr2N65hvr/ZDatMFCF2gddnQr6buL1VkUAtVYFRfxTyz2h8URoMWLCgtALvFzu+j0n6MXjr3+TwGF00E1n2yGNA/GlRKzyGdYH8mJ9LFVpCDKlGL6OsG12uWv1fZQFAMPoVOrG4D04HsyjZTviJzb17ftw0ZPuYBEE2F8VQcvdJghTlk+vU4Hmrj10qaObI2L/mm4HiQo4gffBT1BUMyrKCGxouJCIH2HHr0R9tRjfv7XdFVSoOQFtc5es3d4E6D/kbRER2ZoY6sezZXs1Y1KcQCJ98Qf9tBuv1X/Id18DG3SF2PzrlmqVWi8nXZXr356FmlCotY4iVqIXXdVPOZO9chPuNQJHv/cZiHifQ9pxw+qVBXuyf6Iud1dgDcsFaGihyXj2l2q04KaKICWRMv/Pr2A6JkUE5iBmwgs2iqXAwCjfYMVOoJtVbxcchO2+ML4iSaWLGStLdjIxCGEUsxnWepnPele7r4lBMYMOmIdNFm9lHLbKdd1vOnQD1oVMk2yCVX1yjKzEDUL4jmUZHEmwnyYx+qKcD0ZR1Dm8o9z8nnMXgG0ESw60FcoqaAtvNeykw7seUQaOJIXBTky7ctdD//dmjYSVD4n0wof+W2JB7QsEBh1jvnPuluqKh4HZPJbPopIY/FqqeDmZk9RAJt4KE3NITfa4medR9BAs7lZDcud4jklfdL/IgN8MpcIeB/K4/kHTcVyCZPgfffbB89FcSLo0Ta1E1bSPg7fefRfamv0mIwh5C1AQqMuLDpC
 H1IMxd92
 pTtWTh+X4WFB87g1Plce7JfiBcitQx+Czqhw5teMEpVPU3PtZdjUg3DPklHBNWdxSc2XVjmQh3YjZgb8AgGt7qZSc0BIRhBAWJHLUek7pAhv7E4AQreZWteTWndP/rKzh19PN2LI4e6bpdXi07OCKeRVhTWKxTjLweMf4CPNIWmBkSdOwp0oQRUQ2NGt4AtUAFzqmFjkAwDGsJ0NObs4K5G9BIbzybc2f2DwfKgvFKP48BkufuT7qtIFAH0Q7rWMJg3jFM/pizbFt2I0TLjapy5yvJBGvwNam1PIIGp8RzXCGD3qT+vpUSnCBeC9kAAlXh7mUJAGS+MvzPEvNcLfHcPs5vKyiMMSStJLB58+195DaXtaEKLKNihqhIFTBQkgfnOcx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 16:31, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 04:26:18PM +0200, David Hildenbrand (Arm) wrote:
>> If that means that we would handle __GFP_ZERO consistently in the callers of
>> alloc_frozen_pages(), that would also do I guess. We'd still have to pass the
>> user address down to some degree, through folio interfaces only at least.
> 
> What I don't understand is how the kernel page allocator needs to know
> the user address in order to effectively zero it, but the hypervisor is
> able to zero the page without knowing the user address.  It feels like
> somebody has x86-centric thinking where cache colouring doesn't matter.

(not commenting on the icache dache mess we have to drag along)

The thing is that with free-page-reporting the memory is already zeroed by the
hypervisor as part of discarding that memory previously (e.g., MADV_DONTNEED)
and allocating fresh pages on re-access.

So it's not a question of "why is the hypervisor zeroing less efficiently", as
zeroing is just a side-product of reclaiming that memory in the first place.

-- 
Cheers,

David

