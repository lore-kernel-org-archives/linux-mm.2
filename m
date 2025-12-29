Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C89E92FE0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273596B0088; Mon, 29 Dec 2025 16:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221406B0089; Mon, 29 Dec 2025 16:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157876B008A; Mon, 29 Dec 2025 16:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05F156B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:28:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B65111609E6
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:28:41 +0000 (UTC)
X-FDA: 84273798042.11.87647EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 079E640002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:28:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHPY0Zio;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767043720; a=rsa-sha256;
	cv=none;
	b=Oe86YD52txREUkMypPZ/1fN3YmZApOMFT8reYquwa9e8434zkQXza7IrLHWw9Zg1d0CFxm
	UftDaYpUg3hD5ReTalx0ZQqtbluQjRXl5mvTsT3b4QGMpLwaXPpWCKX4K1h7kJf43/EYVe
	i4bfmVIT7qVu7v4OePsTATmiJx71EwY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHPY0Zio;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767043720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFBTXFUtqPcg1tLY2+KvZ863A9bOk+zjL0Z86ZoeYHw=;
	b=qgukINTWOsnoFcqapj7PiITJ/8zMV5zPm0jFNRTB8OApMkjhu9f/poyKb8mnvT1Gd67KYG
	TnHWFcsr851zQIuXKRHrFzrT+qEQltPQpZ/BrEPR5ZyznrcGNA9FxNeC9CYeOznifgASjP
	QFeJBZZd+1UyE+SUCVTAChtFRJwqpY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F5EE43F3E;
	Mon, 29 Dec 2025 21:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F370C4CEF7;
	Mon, 29 Dec 2025 21:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767043719;
	bh=SVRqYR0GXBh37EIJDTe7QP6vSom4boVYlTrlJiH7Y3I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jHPY0Zio4UWt0Jmie7XDhylPHKe4oeCNafzP75gZq+v2MHP/cHARsw1IvKXp6pZs3
	 VTYUGouFCZwVkUTMADLvPuHp22ZPOzpY/hEBy61azE/0jQl33SnjvIZ/fAXdRKZyUS
	 C0fVsk8KmYItSJo8KycqEcqD1J5WeUUu22DFatpuQ0Zvxg7yOCosB/EBu3u3jZAfjO
	 jrUdmThHREyv8RBcILupv7zDt03yOYEnTav0jTYjUsvYfBCxQI+Iw3RHvYXusasxGy
	 qgm20EGBgpnFZHnEdqjZNnQ2cPSrWDLkAPsn+PUi80K0IDOhqeoPic9S0U22uMTwNc
	 hY4CnEv0Ihteg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,
  "Pasha Tatashin" <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  "Andrew Morton" <akpm@linux-foundation.org>,  Dan
 Carpenter <dan.carpenter@linaro.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  Samiullah Khawaja <skhawaja@google.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason Miu
 <jasonmiu@google.com>,  <linux-arch@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <kexec@lists.infradead.org>
Subject: Re: [RFC PATCH] liveupdate: list all file handler versions in
 vmlinux section
In-Reply-To: <e4d1c333-7e22-47ee-81a0-2efc4ca6b17c@amazon.com> (Alexander
	Graf's message of "Sat, 13 Dec 2025 16:10:22 +0900")
References: <20251211042624.175517-1-pratyush@kernel.org>
	<e4d1c333-7e22-47ee-81a0-2efc4ca6b17c@amazon.com>
Date: Mon, 29 Dec 2025 22:28:32 +0100
Message-ID: <86ecod7zb3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 079E640002
X-Rspamd-Server: rspam04
X-Stat-Signature: duoooah7km4ouir4js3338w58y6ue59y
X-HE-Tag: 1767043719-458785
X-HE-Meta: U2FsdGVkX1/zKlSIs+1/vPmqSiGYDesQA64XB4WvxJKr8LS7ChmtxTGm6O/z1ge3fK1EW8UYKbPn/9JpEIa5fMAydbKCHD8pLemcJj7DeM3H1H2eHC0KwWXPERgVxjyrpDMRXd2vWpOfBQip+DmP7WvgmGJSNQBmwpzbko7H7CG4AZ/ShpMVhlKUE9ntkOZNKE7OdwJHBpMTAuFO3+zmp5GzNeOzrUIrJjOgnzswKpMLe9B0G7C9dGPRV2D6r4GzV1z77ooeHKX8rjJSjnuqAiFDMXtPKbm8aY+ROayFlUhfpX6LcLdPo6jyBlDNUEX7/VyAK9s6UIW8HBK3D7li8rV849sxaVQRqfbMBOD8fxKrVTPSCCHmxsH6tUwmvJdFBtsKM60wgDdsvqz13zAUftaSBv9YAW8D0Z9We3WUp1IbAMBQQnBhd2CiR5LoV1eFUicVtsSM82ZDoF03p7rfBFVkgKHtDU0n8V80xuJo/zOJQgRC1b1T4fuVaulMR15EVQb/Gv8P8ZiEF2+kGSbeJFUx3MJ+jS8RGlijvxgIKsW6pkiwFg1HFnT1jZfFxzZfBoXfUa3jT0u+ftdHPwBZsSmPoCsJoETpVrOAnjhXAkLPKceDrMX2dUZD2Sx5NFpZo+vuUgQJ7/BGRANkvxlgOEId46oLw8tQuJvvS0CRaTUlmWoI7kiaa8BYdjFB8Vo6EDqvQIh6KMGhmlyYg+d5vt2XGumAqtY+/N16lEQDTA7xssD6ZF7D9XZ+dD2OVF/IMhcl8nlt3ynEOct1C+A2IbPGpngC7lqnDffic/sIQ0DDguZ6kOZYSht/ln9QKbnq4fK/QZyG5DnZJp7K83KHRHXNhIih+P/JZrRoSbKLz4WBfFStvAttrOYgLrAv57BH6n69SeUPuy58SzubaQLwWG2PP9Gl55asQhVnaMu4Jw5LnCTPfx4N0oexu0TgyKMkQYpjExuy8wKBAeZf2cD
 Prtd0s4w
 eBCpc+objycoFrqN36s8TFLJLRcqgy9CAlpDk9m33Ow7Fa5/9Lw44sn6mtLHTnQGjMe6dy16FmXBtYNNmmHcDyZO2UGxAjzsa9Hl5tD4dH+/TIBM9QAPGWtgWZEppC9yYE8aVWXuC1wC/fLzTYlcQuz9MckKjpc/uAa7Lece2A5FBTmXusESbaCyRIUrvyVITC0dn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 13 2025, Alexander Graf wrote:

> Hi Pratyush,
>
> On 10.12.25 20:26, Pratyush Yadav wrote:
>> As live update evolves, there will be a need to update the serialization
>> formats for the different file types. This could be for adding new
>> features, for supporting a change in behaviour, or to fix bugs.
>>
>> If the current kernel does not understand the same set of versions as
>> the next kernel, live update will inevitably fail. The next kernel will
>> be unable to understand the handed over data and will be unable to
>> restore memory, devices, IOMMU page tables, etc.
>>
>> List the set of versions the kernel understands in a section in vmlinux.
>> This can then be used by userspace tooling to make sure the set of file
>> descriptors it uses have the same version between both kernels. If there
>> is a mismatch, the tooling can catch this early and abort live update
>> before it is too late.
>>
>> The versions are listed in a section called ".liveupdate_versions". The
>> section has a header that contains a magic number and the version of the
>> data format. The list of version strings directly follow this header.
>> Only the version strings are listed, and it is up to userspace to map
>> them to file descriptor types.
>>
>> The format of the section has the same ABI rules as the rest of LUO ABI.
>>
>> Introduce a LIVEUPDATE_FILE_HANDLER macro that makes it easy to define a
>> file handler while also adding its version string to the right section.
>>
>> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>
> To support multi-version preservation and resume, how about you add a "profile"
> hint to the handlers? Then you can tag the handlers with "current" and a
> "previous". You then expose one section table with supported versions per
> profile. And that means you can from user space select the local profile to
> serialize and match that against the target profile of the target system.
>
> It also allows you to support more "profiles", such as elaborate downstream
> version combinations, that upstream will not have to care about.

So in essence you want to tie the versions into a "version set"? If you
want to use a new version even for one component, you would create a new
version set.

Interesting idea, but I am curious. Do you see a reason for grouping
versions together in this fashion? Why not let each version be changed
independently?

-- 
Regards,
Pratyush Yadav

