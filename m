Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B344D1A62D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1056B008A; Fri,  9 Jan 2026 09:17:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B5F6B008C; Fri,  9 Jan 2026 09:17:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFC66B0092; Fri,  9 Jan 2026 09:17:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE6576B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:17:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B96016095E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:17:04 +0000 (UTC)
X-FDA: 84312627168.17.2E6D192
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9EFE160009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:17:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvwk+ZHf;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767968222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PWTennRpZy73mk2FUlHWs0NRdiYSKcn9xWPWNly+F0=;
	b=TAQ9bFpyl5WSE+UykQJApLL8+Znuuy6x/1VvgDnrn2bkkyr+0VxqaeQqxOI7rAnidL5ha1
	nxH8RYB6tfxuEeqnXQdZdXBV56S1qlWisS7bQ0ho17SVgcoXN2p7OTmzsV+sYSoMx96ixo
	EWzl4NkzAVkBiscqNwZ8o2WF7VOETJ4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvwk+ZHf;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767968222; a=rsa-sha256;
	cv=none;
	b=4EdBi8nmbe1C6k63Ne0SZl1h48wIDY/EZFdZEXET2JQPT+x2tS1NPqMAF+Gssa3ipJ+0vm
	qVghkPLLNxDnZ2v8mn6ZbLQOUwGxER/8ySv215yJX5x18l/pk2aZWE59H8wNc9Iin0cS1x
	4e0AoCNAaWiPEq6CBbhW3Mvytzfl3OA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D23460122;
	Fri,  9 Jan 2026 14:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECE6C4CEF1;
	Fri,  9 Jan 2026 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767968221;
	bh=lr1JN13vUxnGXW4XZwSMKMxzqKHEMDUAlP0/wEVAxZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bvwk+ZHfeNASAzWxoMstgupKUoz+ibbXXstF8aJ7qI8Rs8xuy/m0jRYFnKcD2dvW+
	 61E8Jxr30IHaKRibBD4xVogyOzourgwuvJFep/aC6P3OPnoxGIPtw9rPJGuQuonhyo
	 Zvq9DhJ3uEcZxYKjC9X4IbiYrvjv7jY4j//r3LT2mzcIdZucNCo4EMxPnGNFIwIshj
	 /UzT0b9qbHldfAWFLh3Phmb7s7MlmGAoIIlhinIVF6iTgYBB0VZaK7JheDNwNJ9aSA
	 ttUCNU89c73+bSa4Wcac34KmA4fRkKOOIKA0CMY4i5rqXzT3HIlclCLskaC8e2zvML
	 BCFvmYUHFA7YQ==
Message-ID: <746bd1ff-b3fd-459e-b491-c62b160a956f@kernel.org>
Date: Fri, 9 Jan 2026 15:16:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Finding mm patches to review before those are pulled into the
 mainline (was "Re: [PATCH v2] fix AMDGPU failure with periodic signal")
To: SeongJae Park <sj@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
References: <20260108062637.82125-1-sj@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260108062637.82125-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zeicb4iefi5neenqi68srabiqiey65rn
X-Rspamd-Queue-Id: B9EFE160009
X-Rspamd-Server: rspam04
X-HE-Tag: 1767968222-296745
X-HE-Meta: U2FsdGVkX18ep/u2HCQeMdM9ZJelIbiQ4rjjYH05turKzQC52hZUwQnGiw8IXO+1EHIent8R2yRAgDpjswx7Nm8Ag2ibD3AgALOV0gurWsi57QVq4qduirhFWceLoGJNKqeBdJbw/deLuNmgjS9f1F50mZCmFOmM4VdB2Czyx3fwNJlq38BrthV2jj5fHe72ZyQJdNTXKbXdNJW+T/J+zqss6S645rBq7b1WLFHba6AnoN42JjK0OArulF9oXOm8a7ISDPnvIoee6xsCTI1PHAMdJNWAVu4bIKkEwfVMhm5Iavz0UWFZUYtySeorxF1ksjdYJxjuQLGdCCHyfuTCdGYf9ZyXtaZdjC/VChcV8qKixj9ZDUhtMI8rfudWajXvLCPhRZUpE47zy0UKxXmw0XYjRxwtevGp8Ld29G3e9sitBg1H5YIWkuFe58Q1kEczt/CXJ5Z1PEuMUJmsogmYzBzNz8eJbTnp3px9F1Oqgm6o2LCid7L8kDxcqhfy+YSnQKJLkqaBDssk5x204ADZL8LRu4qUckFymELSxq6tT7kB+Tg7q/ZSGiKjc9LxtvjaIQ9CANkzoiu9umLbAL4XwVrvb6QBpAJxUvZcJsdeDpC/aZTsG0zZ4GGZupws+8ZW9XJC/l4XUJYGXkXAnN+4RgGz9s9woqhsG1hldSpuiKIJlb6rg75aWVodU/zGCjK4WvTCrXvQ5qEJKqX3QCHVePPJNupOAxOUYCF9xoUxlVu3c+vWLm4T8aHZHT77XRikjcQu5mlfS6r0WYEmEsOWCe1JSPuqwwRhZPt47/JrUwSKVRlFKcatcsxAeV5VRnBGwiUkNmwsmc1GdNLsbvzf575XclSFT1Jb0pPdPiZoYBeL2J1WPV54f36zEhfgS/O+lDRWp6ku5k0yXcVeMm0r7UHPZdsjvuep5QUSdiwRxQYLkCyRguc1Uil0a1gfUmF1jZty19T6dRvD3N8HfjK
 4+xjUWwF
 8Nz+XRh0C7qQLKBC340SjiqKgz/F4LL/H1DLVgq1ZFu5sWqFuMOM27syFnW8dB3oGTCmrH5ihY04YtPnr8dA8gGxKuDyMQ+sf/3d7VYqbPgbL+ey3MkAGYHK71DjSq5qPtpO7KZa/CJSMSS0tiASBQvN/1ehUKMG/Xzs50iPoGiiDXyf312jZjy4okDVWQBq3376+JFfeCcdiu2So5gsKK8MWWZr/Meh8lhrmJBkdbFRoExoeuK5fQjwwbynletZl/VT4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 07:26, SeongJae Park wrote:
> On Tue, 6 Jan 2026 21:52:25 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
> 
> [...]
>> I understand your point. I don't think anyone wants to see patches falling
>> through the cracks. But we also don't want patches to get applied without
>> any review.
> 
> I can also clearly see both Andrew and Lorenzo are trying their best to make
> Linux kernel better with only good faiths.  I always appreciate their such
> efforts.  And both their opinions make sense to me in their ways.
> 
>>
>> Perhaps it's time to deploy something like Patchwork to help track
>> outstanding patches?
> 
> Nooo...  I'm too dumb and lazy to learn how to use Patchwork...
> 
> I believe we always have rooms to improve, though.  One way to resolve concerns
> raised here would be asking Andrew, someone, or some tools pinging relevant
> reviewers of patches that Andrew wants to add to mm tree.  But I think that
> might be too much request for a signle human, especially for mm, which is a
> huge subsystem that many reviewers exist.  And because the reviewers have their
> own tastes, the solution may not fit very well to all the reviewers.  For
> example, someone might dislike directly getting such notification mails in
> their inbox.
> 
> In the past, I actually considered making and running a tool that scans patch
> mails that not Cc-ing relevant reviewers based on get_maintainers.pl and
> forward those to the missing reviewers.  But I didn't make it because I worried
> polluting someone's inbox.  I should also confess I worried my electricity bill
> :)
> 
> As an alternative way, I was wondering what if reviewers consider mm tree as a
> kind of compacted and curated version of the mailing list.  That is, using the
> mm tree as the useful place that we can more easily find patches that we need
> to review asap.  If it turns out there is no time to review immediately, the
> reviewer can always ask Andrew to wait.

I have my inbox full with stuff that needs review. As long as I am 
properly getting CCed, I am well aware.

What needs review is at least not my problem. And people can feel free 
to be listed as Reviewer to get CCed :)

The problem I have is that if I am not fast enough to review/ack, things 
might go upstream.

It sucks. Hard.

-- 
Cheers

David

