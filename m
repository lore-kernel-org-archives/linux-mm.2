Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C5ECEFD05
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0556B008A; Tue,  6 Jan 2026 15:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962BB6B0092; Tue,  6 Jan 2026 15:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F0E6B0093; Tue,  6 Jan 2026 15:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74E406B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:22:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28EFBC3314
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:22:46 +0000 (UTC)
X-FDA: 84302662332.02.07695AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70EF42000A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:22:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KWij6/rF";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767730964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ro86d78llnorjEUSoz9F2FCRoS6/jtWi1JIRnw2cjjw=;
	b=0YI6a3HnaekamCnO7EO8pYqTHoCeSmI4z41TtGkBUVrVuR+/A43AnbFs8K3LD7syHIz5N1
	GHMcNtgUuYW1CQi6iSJeHRsKZZuzFHO1cv1dZTPgFnczD38Ujlnxi/t3aGHwsvyQCuaAb+
	MINBjdb84xBtVx/1fPH8HhGAOF2cZgc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KWij6/rF";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767730964; a=rsa-sha256;
	cv=none;
	b=7vAs0RQqj73NUc3jpc17tmMtPYRu59zaMfV9LCEHFh+jLFt2w2Vp8CHz/PLLR6TYhBjz3e
	+hTO6lq4PVBI1CmOhroqPxAeBwpKHHTY2G8dinT+PVn6teIwX/zE+kmizIsgxVO+0lLBRV
	3un/FYY3cV0WCJett8H+BsQpmce/YP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3BF960007;
	Tue,  6 Jan 2026 20:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E56C116C6;
	Tue,  6 Jan 2026 20:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767730963;
	bh=GFeKhCKKI7B1c/vMGce0HHzLo76WErLXd2zyd+pdItA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KWij6/rFxZhPb08Fd5cQeSqdb9NnxIVpHITnF7vyFiKxAWp+HWC/jyQzj5elVsUBu
	 dmnVDXU/jFyiglcuByyTVLOqkTEZ4pA0mKzNy2db6J0gwa76GtcoeLFGgra/UaTSAJ
	 0rODLK8UEbkrwms0easno6yeul4g4zDUUHwXYWfKG/rIyOAxtJp0EOkdaBYirzaynb
	 iaPbXk+XJ1UnwU3kOZVVclXKNzOrjQFxZW2PfvBdvTOcR3NSkQ8DCmCIOhlSzMbejv
	 Q+mRqPNAS9JqSuQVjxOXe1Gb7B3yppHM+YZQK1r7a2j+UNAB9VCha7ncqHdP6qRk9x
	 Troks4MFDnp7w==
Message-ID: <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
Date: Tue, 6 Jan 2026 21:22:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Gregory Price <gourry@gourry.net>
Cc: hare@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
 <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ntq6sp7c1hrk8kphde1hi1ckji1g166q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 70EF42000A
X-HE-Tag: 1767730964-257224
X-HE-Meta: U2FsdGVkX19UzSmoGYAYlp4Te2VYJpinWub5iQq6WxYk3dD+BQfENAA6BKOTpLgD6DkveAMk/bhqzZgEsUZBtgNOoDF02joRXNbnm+2yrTEBMJik9vIQpV7evTsNyhmvZqjKHa1clmWR5xltR+KB8NpIoPTyJ0Xld7K4+kU8YFD9F2lVpmX8jdX18WImlUg8QKTVsnexH9P/Gr71ANG3qSdGgzo2X8h7bUK2E3q7/9mMdd3hcBB+YXDzJDI5BDvekYIS2HxPbZjZ4q/9V0da/SD/864DrcxVhPoen0PkrGbdQi45lcsbXiVtE23LDmfi0404sRZwn8ltK/jPdz7YOdzoiG7tmFvfCx1YvQfSqpTxvtn5LQ+xgrUjWBjEGx0B6DETTlQdCUxJmX9E4NZ7dwZlaFzS7g+jzDZhK91kA5rOkEqeu5yCwiHOQB5cVGUj4wOAANF05iZO6jnyxYAMPK8HKZomlsQO9cHW5uB/UzHAwOajUrQOpsWYcee5n8XhaNlPPAJmNIENsWihSZlu+GuyFpWnuN/YCU3SjFcKeS/bKafgqN4lzMQFWvjBXARLE3l0i5gf9Iv/2ujYI3nBllT7dau1TWYOR9bI5xfXfTQ97LwAP3R1qa3TZvgjZAyftIjET4rgZs/kgBbyDxjo7m8yKbmHpC1pUU12VTBksNw9Axv0AYGJZYwfSI19K+M3F6zRlWNlaGgZo+SMuUffTKMCw+bHQf9CFRGXf3DOalT0nXNKKM/wBvr01Yt1cP0rYVes5BwGsYB97FZjlIK/l8ZO3vY2/9Uvrom3OWg/rvIbpBqDtFjZ1P/+2KslPe2IEiwAFZjeiUcr37kb2ikrnojPo7CmjH0rrJ8NxDZN0dK/aGYiAPzeZe44w+PXK/EqNOQq+2lZFWjaUejyX61JTWL9oQshAB0ccXatctdCYHxdcguBrJH6wS6pxzx/KdZOBT7yW8YFkoAFWNoUL5v
 2su1qY+1
 bF87+BsHoJKyM6eZBkKMCJLPjgCrpXjLZ80cPK2rAF4VtIUnwAYOuUpdmqxp24kh2dPoDBsd3MAB7ha88b+ErWT+zeGPHCDqZVOSB3cdVM14OP+/Tt3UbaUlrBJ13hRQtvvGx8bFWdIJcLjSjdahrzN5IbUFqpIUUeqllXa3TjFMgZtXH/lVX5GmlIf6mMbHOacsOgPbBa3sedlcWwXVEkbzSrgMSF+AEUykulZTozznBlbWVfTpUa8gFFKmnfmlTNOL04FopZPFRsaLcO6Qxt6M3raayb1SXdnla1UKSjRxD/8u28BZ0JyueDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 20:59, Gregory Price wrote:
> On Tue, Jan 06, 2026 at 07:38:54PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 19:06, Gregory Price wrote:
>>> On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 1/6/26 17:58, Gregory Price wrote:
>>>
>>> Fair, I'll revist this once Hannes gets a chance to chime in.
>>>
>>> This was effective at getting the discussion started though :P
>>
>> Hehe, yes.
>>
>> Another thing to look into would be to provide a way for ndctl to just
>> add+online the memory in one shot, without having to go back to walking
>> memory blocks to online them etc.
>>
> 
> I think it's the opposite: offline+remove needing to be done in one step
> while holding the hotplug lock.  Right now, I think you have to do
> something like

That's what I note below, yes.

For the udev vs. ndctl race to be handled in a
good way you need add+online be done in one operation.

> 
> daxctl offline-memory ...
> daxctl destroy ...
> 
> You can't destroy and have it offline the memory for you in one go IIRC.

As noted below, we have offline_and_remove_memory().

I added the comment:

/*
  * Try to offline and remove memory. Might take a long time to finish in case
  * memory is still in use. Primarily useful for memory devices that logically
  * unplugged all memory (so it's no longer in use) and want to offline + remove
  * that memory.
  */

Nothing speaks against letting dax use that, but the tricky part is that
offlining might take forever, so one has to be prepared to handle that
(and letting user space cancel the operation).

And for dax devices that consist of multiple ranges, it can be "fun" having
some regions removed and others not.

Something to think about :)

-- 
Cheers

David

