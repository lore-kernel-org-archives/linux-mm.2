Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B709D44C7A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5546B0088; Thu, 15 Jan 2026 11:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D5D6B0089; Thu, 15 Jan 2026 11:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD306B008A; Thu, 15 Jan 2026 11:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE736B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:34:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDDA916041C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:34:07 +0000 (UTC)
X-FDA: 84334745334.25.86D6F10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 17E29180017
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:34:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=quFB9Of5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768494846; a=rsa-sha256;
	cv=none;
	b=A4UD88oGdTSyBjgNnWXSahgRFAByx9WuXmXgElc7uVMqH5AUd0iGSFNRboUkbdUSmQuj6w
	QnSzGKjliaZZHug1c7UClraLeMcLTwu0JWTi0KHNGv0nGHwL5EotkxIfAl2Xx1246hKCuH
	Fo7o7/ob40Pqb3a7eQHH5VpyyFFNOmY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=quFB9Of5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768494846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nig7yH3SuIFztXEniKHzh3YF8SfC3vJxnJ3N5O0Eaks=;
	b=lbYvoyCC/IiM4jzx30/DLuS24rlZc8bF5uzQhv67SxSUWYdBLkD+zcBU9ZVCPN0jPFKYrU
	0BU1/vFqxfeWqhtkuYEIxyQuezkMxdNguojnJAvnVLFYF1IfCLWUnCerWt6SXG4cNMdhsW
	JRIcl0v2fpJ32cYI6RNzKsGdf3LjPdc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3FE143FEF;
	Thu, 15 Jan 2026 16:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C67C19422;
	Thu, 15 Jan 2026 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768494844;
	bh=8hxhpYwatqg4ec2o/1bKwmlVi3StWJTQEmDCQHBf2HM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=quFB9Of5eORu4Ot6l7yrlb+gSDrL7IV3sLfpi/BGIn2H5RovR9oIfLoMmaCjZF0UT
	 aCgMWFBfwSVPIcRSBogpaoSibyzYGdFaEWbRQ7BYgQdm/JAinkyAwmmoMDoMQB8jet
	 w1WlHBNhXCkYAa0S7greRyO98Vwu06B1uqXshcYQrAGpK5+DYRPN2deju3oBzqIVGy
	 R13VoFjcpRxkKR8fYKdRz74vwVOKSm4AjkK4sW7rP+1AcSSbJY7y4XUNCTsFbaYWkk
	 5G3Cx2mCBnDJnuVrNyMGv0b7OYo6/nsxYV5WX8wVOjAu+56KS7Lo19VFPw7E1dePHH
	 SIoChbZRn1Rmw==
Message-ID: <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
Date: Thu, 15 Jan 2026 17:33:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON ->
 CONFIG_BALLOON
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-23-david@kernel.org>
 <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: setgzokeku1zxqpc18yhk5uds6fw6cf3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 17E29180017
X-Rspam-User: 
X-HE-Tag: 1768494845-21991
X-HE-Meta: U2FsdGVkX1+lsg0OLI6JMxXBAvymbjjD0W8BTGF0pMTtJ5PbbISnkkgAuY9+Cp5ZzhPItCoHyPnuFWQ47FAxbPCiBVsU87BfyDOQWf1qtINDmq3FlTy8rJnbmmBjYYP/l6KO7Iqhnx+LTQYaLjPyr8EXTpKmxQ9wNY7nNR9vojNd9bwNJQwI62/ZKdzrPzyvJfb7LbBSKkhOqMcOu6D9lHqXDHqnuFK3d5nGJFjzXBBl1i3eAiDxGXByjhQUBBRabh2HXJd3AWHPkf6Bby4X3uljVIlFhQlkmyfWlYNcQPKzMHvtlTRaDzoYfEk2JcIr5RRcYbZSdYsfuM8IVf02KDgV8Z1TbBu/QGmqvj2mGP1jrzJsvESmHf794sPI6gYM0RghmaMhE7EFIFQvENLs5RS83u/dlyjufAjBHjLytUwQr7ezY7FK8XmHB0xd9MlmLGx8fcS+Ov8mRa9jq0xTgw2dOYQKmBl9kxhkDv83txcWuVqw51Nm90027CoFeZ013gtZUjNJUnr+luO+UedIT5C+wv8IUBf1GMJs31k0vlSGRxL/flpp5tOqeCYie5DrJ/KOzUl5HOWA6SBJWtoGPAYPaJm3wMk8FRwr0YV3Mh+ZUZSLr+MVCsmDQPqhyjs2bmjdcq+PRGitVUTGtQjF6P1a5fsIj/0D1z+YGS8EDy/IPyoCyc3EeT4Gi9LuzYPP6AjO8/SzLq+cRG1TXOtAeLUqE2xpULCq7GfvyD1E0N4eIXGHbDLhTpB4Bv5Nxtulv91IoFr4VdwzLEsW9oVR2VpviRw22Z5kNaUpYUaL4AYnclhuVjN3CHrmLY7VzbZaX0iLHsYjGzVUsiXTD5jLTLMsDxt9jmzhCfwCztRK/F6uJUZlwGcswabMm03jRwRB7f6Yp/EEJRGu7ZDt/W7yPBmGL3BKJiDP2XvB1fcmz4Fjs2kPBoVmsfTcUc2ow9TkOXzdYg0phtiLzdHJFZm
 01ZFNIkl
 Avfp/VfwO0aANk+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 14:55, Lorenzo Stoakes wrote:
> On Thu, Jan 15, 2026 at 10:20:12AM +0100, David Hildenbrand (Red Hat) wrote:
>> Let's make it consistent with the naming of the files but also with the
>> naming of CONFIG_BALLOON_MIGRATION.
>>
>> While at it, add a "/* CONFIG_BALLOON */".
> 
> Probably not relevant but cheap for me to share :) so grepped for
> 'memory_balloon' and saw:
> 
> include/uapi/linux/virtio_ids.h
> 44:#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon */
> 
> This maybe relevant (I guess this isn't actually used anywhere?) though
> interesting there is also VIRTIO_ID_BALLOON... hmm :)

Yeah, we want to leave the virtio stuff alone.

Now you'll learn something you probably wish you wouldn't know:

As you spotted, there is

	#define VIRTIO_ID_BALLOON               5 /* virtio balloon */

And

	#define VIRTIO_ID_MEMORY_BALLOON        13 /* virtio memory balloon */


The virtio-spec [1] defines ID 5 to be the "Traditional Memory Balloon Device".

And in there, we document that

"This is the traditional balloon device. The device number 13 is reserved for
a new memory balloon interface, with different semantics, which is expected
in a future version of the standard. "

That's in the spec already like, forever. Likely, at some point someone wanted to implement a
new version (for whatever reason) and defined ID 13. But that never happened.

So now we have these beautiful two device IDs.

I'll note that the spec also defines a "DEVICE ID of Virtio Cpu balloon device as 47". But
no changes really happened in the spec with that for the last two years (only the
id is reserved).


[1] https://docs.oasis-open.org/virtio/virtio/v1.4/virtio-v1.4.html#x1-4260001

-- 
Cheers

David

