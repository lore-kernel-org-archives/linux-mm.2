Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D3DFEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249BB6B0005; Wed, 25 Mar 2026 04:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FABE6B0089; Wed, 25 Mar 2026 04:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111226B008A; Wed, 25 Mar 2026 04:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2CB96B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:59:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 982298C40A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:59:11 +0000 (UTC)
X-FDA: 84583986102.10.358A8DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD81D140005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:59:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iERiDiLf;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKPAoXysMVsdVB4QWCj3imwXrWnlYrYuey5ddRMMwF4=;
	b=glfHD1aak1O9o0FDSnaTn+eRQmCkW/PWyDLkpYTxkJ1dOcA3cTXo7SoVJmXM4BfT9Vt0Vb
	hZwt3yIs56PAKCHEvHy9jDKdHD7dAk5/vp+Zz2SZMt/EwjqL/OAr5Psa53lm5OEFI6QuCb
	k707OHj3eqOaqyjUEn7gcoEYW1Y1nhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429149; a=rsa-sha256;
	cv=none;
	b=oPxB0o9xopd2BfjdmxqqIfAFj4FM/255n8WxyhKKLiv17zDX9i5uAHhgOmh4LJzyD+kDJe
	BpNqtjIMrjPlU483bo/GPB6CSR+6ELstf82YgRRTgMzLNSf8k4r0rYr5RRkI8D3dBJUl3B
	q6Lj5mzJh2PAxkKZSZX/peUYk3/JZeI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iERiDiLf;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F78660103;
	Wed, 25 Mar 2026 08:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D434C4CEF7;
	Wed, 25 Mar 2026 08:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774429148;
	bh=Pv7urIhMMBL2ocxusGwdyHEj1oFC8nFHlp57cSBJ93M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iERiDiLf++5bl/FDoLs/I4SrbVtH64RIeByQPlcqcwrGq9EcOzuexH5tWl1gGtFQj
	 FC8h5uxpzmBNLtL6bH6tsxJbwuClunaNI0YiMtJkxq9gw3V7fNNnQMKOv+wsvotj+N
	 45xdhriy71Y9rawAiZZuQQpO6JNmKQIwWeSZ01trFFXQdJG4NdJL0y8w/PXn8CCabi
	 lc+fVFDMSIdw+6D3b4ukWEiUMlgyyRJGKsiBc5ChcvFYF3RYKOKiMB7LiyMQu6MBu4
	 dnwNQyOOPhhy+xWI/iyjRaycgJFkZ54yh6GfFODyWneHxdajE+9VBP3pqSd3/yoEqy
	 FNQdbf9x0yvyQ==
Message-ID: <9203050e-eda6-49a1-97b6-a134da2da313@kernel.org>
Date: Wed, 25 Mar 2026 09:58:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
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
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <d0111a86-7fc9-4e2f-b652-9ecbb894ada5@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d0111a86-7fc9-4e2f-b652-9ecbb894ada5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: mwgriqwy7m56q9f8soup5aogepbspr1a
X-Rspamd-Queue-Id: DD81D140005
X-Rspam-User: 
X-HE-Tag: 1774429149-927299
X-HE-Meta: U2FsdGVkX1/SNV1k5Kg6/vXdIDmZPG70z4qrdjkMyPZxbxTDqsQpOYRSxExm3es3lHpP0YpWSfpUX4HVXp65C7i4DfItXrY4dO1/maKU0csgCydUKdG4CZR4y/HOh9tbK6BnItR4LQBDJfM8zBDR1U+srErEPEeJQsC93P+VlQePt8SQ0aoo1ZYu+mnvISFEbOKozFV8Qs/8z/Iwh/Uqd0Dl3uFmMnZJEMWScb48yipm6TrMrBQCIUqOg/Trn/b0SoXgr86o6aqsfl3JKYO9dUHL1rdWVBsOwHtQWza1UE90pKglikJMOKnHcmk+k6R/P2RTYF0BlHgoSFRrFMFKN4ElVSSPxMxWg5lG8J2S63r5wdOWSARtTOZhZvayRgqFkGqC5c9PBbIvRq0YtAASbwpBi0oP7k0jM0mcVd0v+9/HpiinFC55WJyPA2fYj6QSb4soFCSxrZNTAhsajEWDoeAmYUh3DGXC6L6FuQUkVbVewLi0wsKiK+rmaq+wDDTLMnmmddwwIDqc+KOtGMUyohiYY9IGhCj/HNIWOxojYPx/svK6apApUyB/OUPnCr34QRba/lykgtgo8qYBS8Msm89ym7heYJWc4QQ25/quGMCPt+fA5RzP6451mPAGq+vNDPY6F0NxRJqxQcr5G9ZZGpYo4sYPw9mhTLJpyGKgvDTQw6Wm3RybhTWoBEhLGioy+UxQKmAdlHMlSgWNuFHrCSuQBoBcQk/bU481h/2Reheirlyct5t4JL7SH1HTkxzovtf6gz9QLrA9stat9zT4UNAl4mHM/AJA/gCX01+fkLetFTM2i40C4Gh0ik+gisatjDpdZaXgfYZTGTUCtWkgIL+Q1eMKpe7pfef5kVZ3LFzgWFhMqX9Weg9OR9GnKLOCve9KlvoCal793k3RWOaWzvpIZ18EsfasjUuA2FbYC/5VJ9WrdeyvvxM4yK4MXGEO/pERbcV85zXYi8/Td3R
 YF/77Dl6
 2gvoTDvF7yqpsA4n922IKKvxUtPLGjuVY+7dqMNq2sQUuoOwAcccWjvsHrINyUJ31KK72+33c1ZrB808XQPfahx0p9cdAFv+AMoyTcUTmlkKEcrbg/kE1M3/7FSOwphW1tK5CMyrKrlA2ONedP+BTus7FHWuEjcSym0F6pO5Wt8NtJPeRewe9WOxHHw59UUJIRMsyYXuMxy/6xLu0tBXVOfFuFuRK4QMaNW8Cx/uJ4r0Zkc2aUNQvIZLV4C5tdjNvzTNU54/2DUM+zbfiYmpNe31m0TcRB/3cfGtfF8m6eQU6VoNQ3C7W+ipzn8NWtRc6T5ul3f3IjkMWZ+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 08:31, Vlastimil Babka (SUSE) wrote:
> On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
>> erofs and zonefs are using vma_desc_test_any() twice to check whether all
>> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
>> vma_desc_test_all() to test all flags and update erofs and zonefs to use
>> it.
>>
>> While we're here, update the helper function comments to be more
>> consistent.
>>
>> Also add the same to the VMA test headers.
>>
>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
> I thought I saw David review all of the series and so focused on other
> stuff, didn't notice he skipped this one :)

I think I skipped it because it looked too mechanical when scanning and
I was like "ofc I trust Lorenzo on that one blindly". So I missed to reply.

Tag provided now if it helps.

-- 
Cheers,

David

