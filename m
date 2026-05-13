Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD02DCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE33E6B008C; Wed, 13 May 2026 12:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99BA6B0096; Wed, 13 May 2026 12:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A826C6B0098; Wed, 13 May 2026 12:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B41B6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:08:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 316EA1C0A9E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:08:06 +0000 (UTC)
X-FDA: 84762878172.29.1FE08D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A05280003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:08:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g1oal/Sm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778688484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IVvxFiz7cg/j9ttYTPyC6Nv82SEfAmdtb5tDMmFyl0=;
	b=cB7kb7C4MDsH5lbxj0fvKkQhzekD3aob6bizDYG5dZmlfQ9RH4xrg0KFB9RNaZ0PgBp0hI
	L1Ptr5De0VAaHVO0N1cy80yHAIWV8noDwFAJ+UAUA92zODfyGYJxjzpyP0MLFMLV/7RmQV
	bRGd6TpshR8dXXGB8M8Pyj0plHAqU8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778688484; a=rsa-sha256;
	cv=none;
	b=GYDjupqDOTl588yMThsy6AlG7bOER102UFzNwpBBn+ytl09b/GtWxKjQUW2LytxEoSERIP
	bk3ckHiTE0KStJkWMIow9rqD4LGvYUTeboeGkYWaPbMclwCip8MDBma/Tn1koT/LrCn2kI
	CNaJNyOWptOfKE7CUpAfS/yFsY/GwRk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g1oal/Sm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06C6043AE4;
	Wed, 13 May 2026 16:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0014CC19425;
	Wed, 13 May 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778688482;
	bh=s5dV3Zi4bs8mAbYDN7AwwP5y16K91uc+T+gnzG8BLaY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g1oal/Sm+ZkN4MPtagYCJpkWGo6YflyWlT3pUF5+YAOxzCUyxRVNrh0mfeDBxYXvE
	 8Nir+iQ56qD1lVapsllAoTK7b8lPMdpbzdFFWJNszZQM96nKwpzEfD4XH80OV5HKkW
	 5IiWGUdvO5vVLXAIhPHK57qO1XZ4YQ6txLrqJs+pvyMsjl/cgVq5k5QUd3tUIrbA9c
	 vzH/Ok5VLo6JfiAoHAwy9vnHUUnGk18Yc1eVXwFpzip8NlfAzhV6BjK73Agu6FrW0G
	 t+3af5YWGfFePe8NRQ+AtgD2lCaFbNPwCkeb+EvrEY77GH4xvgejcwjsxKwQIJweyQ
	 VS7aXNqHlqtRA==
Message-ID: <9f0b2894-ba79-4ef5-8be0-be8f4b5dd3ff@kernel.org>
Date: Wed, 13 May 2026 18:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: set mem->altmap after successful
 device registration
To: Georgi Djakov <georgi.djakov@oss.qualcomm.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, djakov@kernel.org
References: <20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com>
 <f25f1ef0-5359-4c00-920d-cdfc37cda968@kernel.org>
 <a3eea8f4-d693-41da-b8ab-764e6ce311ad@kernel.org>
 <fb932d7f-0ba7-415d-ab36-e948d2bbb537@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fb932d7f-0ba7-415d-ab36-e948d2bbb537@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A05280003
X-Stat-Signature: tf16xdph7qujnnns4bo9wfq6bkmcn95j
X-Rspam-User: 
X-HE-Tag: 1778688483-37732
X-HE-Meta: U2FsdGVkX18VD8HMebkNHd93n9zKK8DdbFLqDF5vFQmQfPnKxR2FcQ77655jntJWS3pxqx5sciELAe1Sf5/B7RuQiZEZd98OylG4kJGHkisOd+ODjILAfslUjCSe2cp7+HMacwV/iONFMl2TfBTlnOv8dmH5Sq7/5Goy/LkUa8l86nJ7D6u49U6NIdbpyEfCPeSJ75dnCnW+6+NE9CcHNB+4ZIZ2+z7bqwHG9oDwrHdLR1eSg3RcmnVzX3NRw0kIxd2GR/Qjmtyn0QjIUXjZL4OxYk/N86rKXOOpbRMBliSgKMT8rndjeV52qANX3ncJI+8w+aqgXGbBECMmpNZGdvJ8MkMrP6XBC2HQcny+INsmeswdzY1xN2eMUtm4KxY+c8gmbeT5KLPcHq+by4HLtwEOJkr74fRCMbGhwG7Ki1W8OyWfhZBlFthtMbemWormup9pBrKh6lJOgef8Me6Spa9uPjZ6z68Kkg5Lkt3R3SkFM34JYtHsBqr8G6k21YMpibluuwKfNgz83gaAV9cMd2oLB1qgdi7WAkgdlo5vJ7yUr/2CePmXM5NmRmca/f9Wdf0b4yFPN/hSV6VtDapLf4w9dxFajo4+Y0VpfXY7pH3Uqi3pby2LApy6cRozfB8N1sIc82yySxOSoeC3wdrhlmMWEZtI/iTX2Dg3lTEIoJPC718q2R6u+ner33CZSXOLelcVgkfjkVu1wuanfSomWyejxDpG/p0+r8N8LhsCrcJLM7nmRrVGdsquSz/qFD+JbYDs9C2EGvx9fo28wSy9tQ1u3xaiAd7nKbK6b86WizPEOOMrCbcWjBrt+pev6hOYRvgBiryqtjv0zA6HcTO4E9MOPVDDMpRR2CLVOqNq4MrV4N30lyz34HhqgZzCYhop0Kme4d0SdqQCGSCuS8g7ap2XJSYWKvlFjD51fTehX3aVyJj4RipwqOzcdR0gmW0dp8pnWFOkLbMjl9Tldme
 PH3WM+Nz
 LXt/aYzHNqZOkEkq2mUiwi2SAs1ceBUKImi6zib/Kj0nTWNgyZyq/YIPnQBgyjR9+U/Qwo2f8e5yfl5HPM/0XhN5bAjk2VP7pwqA/m+qCap43lISxEv9ScUMKWhi9fLfI2Z3SqQmTz10Rlz7GHTKGsCqg2S4N8MvneNJo/41p/oEvq4/S/h4ekq+arbojnqsrNbr9mUO1RBioOI8gZVDeT3bjzY1bdy4vh59ET2DnKlR6rqrgXbPspyYH/mrdKWV5TEF2/hpy14bPPVO95QIcp/5yuLvhwg1amuHX1OZqrTT+4YXRqayQChF0tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 18:01, Georgi Djakov wrote:
> Hi David,
> 
> On 5/13/2026 4:20 PM, David Hildenbrand (Arm) wrote:
>> On 5/13/26 15:14, David Hildenbrand (Arm) wrote:
>>>
>>> Something does not add up here. How do you get an altmap with virtio-mem?
>>
>> That patch itself makes sense, but the callchain does not make sense.
>>
>> virtio_mem does not set MHP_MEMMAP_ON_MEMORY, so it should never reach
>> create_altmaps_and_memory_blocks()?
> 
> I have some out of tree virtio_mem patches on top that helped to trigger
> this. Sorry for not mentioning it. Should i remove the callchain from the
> commit text to avoid confusion?

Yes. You can mention that this was trigger by modifying virtio-mem. But the
misleading calltrace should not be included.

-- 
Cheers,

David

