Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C54CD8CAB
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88956B0005; Mon,  8 Jun 2026 09:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B606F6B0088; Mon,  8 Jun 2026 09:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76326B008A; Mon,  8 Jun 2026 09:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 981C26B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:55:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 466501C0009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:55:04 +0000 (UTC)
X-FDA: 84856891728.04.4E370DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8057920002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:55:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S12NdG3A;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780926902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5m0OrUso51DWZxaLpU6hhwt0mtSHqudSR2A+B8zIGk=;
	b=4aQ7mI+DR7OENCUd7tJoMLF40xIwyBkKAFlGvRY+vXtprQ2b9FtRp0aUdEOHye3vKH9bS6
	DycByNIIHaJNUfhsAq1QcWQvBuj2KkNmS6TfQ+DvQq5kSE/yl8ZmKl9cGUiw76zfWNA/rM
	Lvp2VoK9wDtwMbtyNCadyyZR599lwtI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S12NdG3A;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780926902;
	b=KBcQ8DgsY+/XIfd2C/l48FbyjIXz57Q/nHh+IEaUwzBYZatHIno+2tmZRDOsfG27CFTKt/
	A49ZMrfPDZtJoZXD4iylna+AZsk+pbV1Vmr/QhkwVF/f4BqpabLheg5/fiBV0m5rF7Wbdl
	bcK3JCdlwBHr/uGYxwLVjZPzfGtCf00=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8CEC60204;
	Mon,  8 Jun 2026 13:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A739B1F0089A;
	Mon,  8 Jun 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780926901;
	bh=H5m0OrUso51DWZxaLpU6hhwt0mtSHqudSR2A+B8zIGk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S12NdG3AelksNjnH89veVvFl/2lzV2kHIAxrFX+qj12jzWiq6V2AlQUII7baNzB3q
	 g+WhiasGnZ/F6SME10UMZx11bw0nc5uyiKiPbBf99foFWIA9z8VN2fR7Ah2eOdl9Ij
	 qUQTbrda8HJcvBn93PffL43RvuuQfyT6xjstxLaDhdW2pgkD9+kM+UwVSw7N1D7T1M
	 N5o2JbEOtLPIBFropuUfRYsM64F2mqu6LTqnFN/JWmdg4o3jv9Dr+NdiXe8C6kW9xJ
	 rk93de4vJjbnUWRs/IIr0pBWg1xRI8Cnld/l+ltah1GsZqtB3hNj9q3LBw+rdjVbtm
	 68GnzDmYzgf1A==
Message-ID: <4c21bee6-fa58-4d28-b6e5-aefc9dd67cb5@kernel.org>
Date: Mon, 8 Jun 2026 15:54:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/iommufd: Require write access for writable MAP_FILE
 mappings
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yiming Qian <yimingqian591@gmail.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, keenanat2000@gmail.com,
 linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
References: <20260607085320.73274-1-yimingqian591@gmail.com>
 <20260607120935.GG1962447@nvidia.com>
 <38b49fb2-c2c0-4c7f-ac5c-3e79d54728f0@kernel.org>
 <20260608134614.GA4111154@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608134614.GA4111154@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8057920002
X-Stat-Signature: wn7h4uzcnxw5mwur7ufh7niq5w8x3o1z
X-Rspam-User: 
X-HE-Tag: 1780926902-535848
X-HE-Meta: U2FsdGVkX18+doNK6PZXY8BDSl2ajYDPWpOOx06u7LCCEbkHN2KcS+IULiUTp5R5OC9/sYh0/PcoU/80eHkKjjKsQXSNTLEA6pKBgki/78Rt4ymr0LmdpbLoRW3Exr74IbR8SZ9Hs9Ap8USYavZMnBov+rzNsMusI40dvpbCNE97NqN9st45tne75i76WpQrN6+TpkQaRVFDhXXXloVhFxWkKO6nVIN3QB9TEovk/m5zTaQ4ticIQUAK21AESpzsg398f0CctnLPhHd+13ZhnnMViKNkfI6qXHIHiBO0ng/Nx2ziSKV78RpR0PU7pOlJ0yWDHvWx75eyA3e6ROdN4eBFVX/Z2uhoT8NkyA2iiJbHuLumRJkVb8VWPJWqJJLmNqXKS133tMaNxYrLkz237uHqj1wigjwunOlAW5PKWQn2HhOBDHFuRnMK0WcQofLupX5oq66bqaMxjEOP49iyP2zEV0aMXVR3ZYqC/NB/8TzGjsq6fQY/ES5tvP0623/ByS1hsdWKpwWVkzuDrF6LEZ1eMMAxiYRYepxXRDiJxmixBlIt3+MXAfbLjXIofMczupfp8BZxCBwzIC5+SsC1T84ognofb3ojcF7psA/ufAtqLZD8+IYAwUoGsXps6DxdxEEJsdAX2GFv3mdnrS7SfOj6D7UEC2eAMtZEu8bzEx0tG9rY396vkHXMWYohPwL2tjNQaITvghbJrec7YvAQqUsOa6B/7ZPpJmK4UqgC1dWsiBFLY6VRiGkb8LGnw/5asnqXMvM8CGw5t/i67RxpiusiIxDFIPaJrt0zCbWnuch6xSERL1Ql58+V2tpV5iSpH0MWQMo68tZ3hbCb6FgufTAHkecTJDRM6rewy7B+S+TEGU4QX8QLaC951+Y+MmcI2cXlHfPuc83ZOFXmnL0oe6anOYs6/tJsEklVkMFF1+ZHEsCwkOQiW0XBgyRX/j1p/shcKaEArbd+fi8vSHl
 TTHXiaNV
 EIaYIMNz6TViftYRP0b9VPAEJqeM5Nxut2fshTJgVFEvPHL+7/KpPuMDRCyp6og8CclqohvfGwoGXKEsff2hazpLGtRmv2r24OL4LXldZ4s3FIDucnzLz8cs+7KG49Cs6k5kXlZ8YGZTLy1NLCf7VxWfJdJhYe9xRirp2sVZ8DRJRx1xjVuU4vuRFCf+b4+ZRpCODTKLTbU9goMNLcU32qUPxATmZQ1+p3xmzC1nEO1spWDMbWnwQ5zXgilwKlGLaDwG3dGDdSCvLcuAaopc5qW7Ywm72rUwMnvnlJ/fGxClL6mcfA10Cg5O7vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 15:46, Jason Gunthorpe wrote:
> On Mon, Jun 08, 2026 at 03:38:00PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/7/26 14:09, Jason Gunthorpe wrote:
>>>
>>> This looks like an issue with the API design in memfd_pin_folios(),
>>> all users would have a similar bug I think.
>>
>> Agreed.
>>
>> Not sure if it should be part of memfd_pin_folios() itself.
> 
> I think it should, drivers should not be open coding this.
> 
> If there is such a thing as a read-only memfd then memfd_pin_folios()
> should accept the usual FOLL_WRITE and deal with it internally.

I'd rather not want to use FOLL flags (FOLLOW PAGE leftovers, to be renamed to
GUP_ on some lucky day) on this interface.

But sure, we could add a new set of flags (single flag for now).

> 
>>> start/pin/destroy kind of thing to manage this?
>>>
>>> It should not be open coded like this.
>>
>> The permission check is one thing that's clearly missing.
>>
>> Not sure about the mapping_map_writable() handling ... it's weird to rely on
>> that when we are not actually mmaping.
> 
> I don't know anything about sealing, but it shouldn't something check
> if it is sealed read-only ?

Right. We could do mapping_map_writable() over the duration of the function I
guess if we care about concurrent races.

Alternative have a new helper that makes sure that mapping->i_mmap_writable is
not negative (write denied).

> 
>> Assume we GUP a page and then munmap, mapping_unmap_writable() would be called
>> while we still have a writable GUP reference. Hm.
> 
> I suspect the user doing the sealing has to ensure there are no pins
> to the memfd before it seals it. If it already let the unsealed memfd
> out of its control then it probably cannot be reliably sealed read
> only?

Yes, that's my assumption. writable pins derived pre-sealing stay valid.


-- 
Cheers,

David

