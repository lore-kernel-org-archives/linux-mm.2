Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE49D185E1
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAFF6B0005; Thu,  8 Jan 2026 06:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568A46B0088; Thu,  8 Jan 2026 06:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4400D6B0089; Thu,  8 Jan 2026 06:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30FE06B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:53:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B95BE13B870
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:53:32 +0000 (UTC)
X-FDA: 84308636664.25.A374002
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E10B7140007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:53:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5e8ZpsZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767873210; a=rsa-sha256;
	cv=none;
	b=UBlQMKz8RZEnMMGOqV4LS7/pawPvKgqkJ6XYVY8uQ7IrzHq6PpZJg9zJW8qio8U7XiGPrJ
	4iwWtJMMIf97DQP3L37e7Hw25drW/zO3Zr5lLsbptPo/Lvpjf8w5ZsxnOthudyvlFIT2PK
	EdNnw5kHQk1s4n7jyOpP5oPSPOYWPds=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5e8ZpsZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767873210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUXqKdkkgAQk9/MJptFrfPyY7lKiNwXhjgFHHIAiQU8=;
	b=yw1L1qy1xcUZBapZux8nsiRWZgaZfdpdY0IdxjBK7BcB2jOAxWMEnJs2gO9FMMt9uOvc5H
	TRAXYUqPxk+/9ZvUMjMHnkoNKMEs63B4Ry03EYPJL43rzn9mGFJ3ZgMFZk+a2zUlmhHyjQ
	e70uHLsQ6+KlvSt5erFOx4CIXUHmgE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DA6660136;
	Thu,  8 Jan 2026 11:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6870BC116C6;
	Thu,  8 Jan 2026 11:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767873209;
	bh=cemYfXaFY2WN3IjYrb/MiX/1d7RlDZPBC4WV8Eho1Lw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X5e8ZpsZLbl1lkwkUSHz7Tf88QvC6bbLgUb0WlvbV8et/FYJ4H4EgzEQwRz4EjfGq
	 iiQ6b+KeNia1LA0IRIQv0sgfyHYrplp8zJYesEMrQasb8xlmDxIrZChArrvwzBd+W0
	 tCLNm28WBLHUweSj5QS5tw7tOKqP9LXwtcmS03VeL6jfF6MrKCNy7mizXcUyDZMnps
	 ETedrbockt12Id1dC7+SSjrkgCOhVvbKcJccdTapksUZttEokY2I/+IWvtylw1iV4K
	 p7Pjx7zKelUVjApXah61l272RsMqXn9zg3pAnwzPj6DPaKpxic92aTQ3louWhDjLak
	 HtlddHSOT2YMg==
Message-ID: <30372a67-8c94-4260-9496-dce900abd48e@kernel.org>
Date: Thu, 8 Jan 2026 12:53:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
 rdunlap@infradead.org
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-2-smostafa@google.com>
 <1a6aedcd-34c2-4e26-b07e-6eb8d423b759@kernel.org>
 <aV-KDEGlplD5EkBx@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aV-KDEGlplD5EkBx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E10B7140007
X-Stat-Signature: mhndi7cek7tusq4umxx7cnpi3jaaji3y
X-HE-Tag: 1767873210-604553
X-HE-Meta: U2FsdGVkX1/cNWdfY2pDElYn8blX7OjkBcrDl58MjH5Li6b+tkrlFwzr9xI9a2m1978qlh9mClBX1OcgIdYngUyi10uuGoiJx+k6iHJEzTF9Q6Wm13372+WxVQmHowIvRZhEu84Embnu/ScxqkEz3b302Lfinsz4570Y/DrJFFn+duYU1I2I/iRlOJELO0KVXkm+nSSksqykA0fHlsaQ4VRDeHJ+o5qpvDgJCwBuXf+sfewnTDKtBXk28eL3osYxiasNK2ram6+tlJUx5xpr6mQPWpAVQ+xX5fD08m7cfENLooURZ5FsVrzXOBrKWd7BCTZ+mBBkVYHK3aAzqOpt765gWCrmw8m0isvhyB248pHbWfse0+iy+iXCraVqJ6Gqzt02ZkM+nx17xhsL9a2/sGwEO7gwx1RI7MxZwlm0t8hv3qGItAEarOaNJkjdNPl7r2khnyIqk74DAkuDyiLdE7UxfwkVWqwS+2qEAFLJgie1FlEJLR4vp5BE/4X5IEWfeJX8SB2GWMtt529ZZ4wVJif3e9KNvuhcjDGVH/sFVKGZeBlw4StVyi0my5XOHF4/NGt7jKscXYJtbz8nBaijf5LW493RbbG2IV1YC+g9xfSVXn3Dmen9HKS8c4QnSvjNYmFVl174AQatHT+eQCEuWDFyJTxGs0o4hR4fP7ZaVP1iPCL4xP7FwD8uwmtGp7Yn8r1EPV9del2mlJGaLOTgdY4CzZ285ZiK/yGaVGPEBK9R+LlXj5/BTItJ86G5P8xGm05dIVqPfFIzT6v/YTaBzJXU3azeF95VJETRf1uwZ1QrjMyULu8nz1S9mqCFtLEy6QFfE2TorEWr0UhSUYcWfNgev7wWz37uRPMbz+Qa8wUMnEGymduXjYEVZn+5o1oEriyy88vPDk/sBMb373ZBHhW2Fy9lpTUwkPaXJOA1U+8h7gxToJAbkzNmMGgIDRpAHbDWzycwYL3Mkxkxs8Y
 HhT/gOoq
 XRejZnDo4dqEanZHDvyGRj+fMVMB/GatJXqmEyFrs8GUoT5cIF44GySeM2ja7sx6h/PjQKnJ52TMUBV8jkEBKFm6v3e2T/7fWECGGw/l1JCuVOhP0UXG4KgK9z8ChQ6sgJlfuTOF/t2px30qqHGXvQyrmAtK9EMW/tEIwRcxXdlhVWbLOFuJYNjQ9nhRu7/duTg2CV4OMclUHcTrm1wY4gXEI+z4Zbflf0EiM3JrjyFZ3e4A4+ClVJ4sC/xVq/u7OD/YXi7VSp40/TPq+FGM88veyBdNR2MDZ4d3Sms7ZVPgsA1riNAcBd7RsW6biQs2tED6kbbnh7q3k3b1OZyG0ZiK4JlNjOh4FgMU5NkYltXL6NLqwSIHzK0XIcBWbMYYm4fXK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 11:42, Mostafa Saleh wrote:
> On Wed, Jan 07, 2026 at 05:53:50PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 17:21, Mostafa Saleh wrote:
>>> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
>>> page_ext.
>>>
>>> This config will be used by the IOMMU API to track pages mapped in
>>> the IOMMU to catch drivers trying to free kernel memory that they
>>> still map in their domains, causing all types of memory corruption.
>>>
>>> This behaviour is disabled by default and can be enabled using
>>> kernel cmdline iommu.debug_pagealloc.
>>>
>>> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
>>> Signed-off-by: Mostafa Saleh <smostafa@google.com>
>>> ---
>>
>> I think I acked it, but maybe too late for you to spot it
>>
>> for the MM bits
>>
>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> Thanks! If my mail client is not acting, it seems that was the
> same version(v5) also.

Maybe my client is having problems :)

-- 
Cheers

David

