Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DFAC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB0C6B008C; Wed,  9 Sep 2026 12:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9EB6B0093; Wed,  9 Sep 2026 12:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF46D6B0096; Wed,  9 Sep 2026 12:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEA956B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:22:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 571C8C028A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:22:08 +0000 (UTC)
X-FDA: 85194740736.04.32EA52A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 84DA8A0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:22:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrTCyR10;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970926;
	b=uWdGKg8Vazb+DIXtcgXSrpNvZhQducPUXzTPLEYic9I97Pvgmwg1LXwXpBYBgJDzHgBV/u
	y/oZ1rnrRLsNo35qV+/3OlUWRbEHQUuQEKYeP1YLEi/Zw4GtewQ3rmw5OjpDWIvWiybUP+
	S+h5pvMFvNCYQYimONTVhqCjUSbrq+M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrTCyR10;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVDwXOjHBRzDJvfzuWQ8YBF5gQR9D+1WWpyCaQv2V3o=;
	b=J1IaCltWkfNtF70I7c3oqbeUxG3teJKUr/WdB3lJnJOR1dbrBaJ9kIwsxVamwxVLm/Q3cY
	KP6dnuBXFdhqfXgld+ToaRKYsMWyOU0J732pa+1LKI9G55d9yT7jpKxabmC1N6MZx0en/9
	JKUtCDK8dUGzsmC1X7GXqfxrqjmY2M0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE7B04372A;
	Wed,  9 Sep 2026 16:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E191F000FF;
	Wed,  9 Sep 2026 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788970925;
	bh=gVDwXOjHBRzDJvfzuWQ8YBF5gQR9D+1WWpyCaQv2V3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZrTCyR10x3uA4f65mS7hxAFp8ku7cHmrXCRqUuYsbGL3uzYAwaspVYHVCKykwDzHG
	 faaXJvk923DDKhvvtU+iv4+5kdQfUP8VygglE4nhW97099K39oo+ozMIDbRDUYqwet
	 45Gm7xjQYlElkuo1iaJwAsk3oZNcGVTko1+yY4xdapWhFd54tK5nKolOmYzVEHiPAs
	 8nu650TEQ4Bg8zF+QTYLisbn57lwTKwIhc4+69a1C0QzJos9RfAJfyA9DEPipwgcX9
	 NTF0Jt8pcsvEec51ZM2gvemKSDif6g0/ETu8SCkbrLPIo42SWvP6ZPKGnkowPOFQbf
	 s/ySRFjiNb+Bw==
Message-ID: <835cf37f-d0a1-4e51-a29f-a1b83d79a940@kernel.org>
Date: Wed, 9 Sep 2026 18:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/22] coredump: describe the holes when
 COREDUMP_SPARSE is negotiated
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-17-ba32dd718c51@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260820-work-coredump-sparse-v2-17-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84DA8A0004
X-Stat-Signature: uyaoaf97cks9fgimrtw9dp58iepzzhko
X-HE-Tag: 1788970926-632800
X-HE-Meta: U2FsdGVkX1/5tFMMMJOahC3/mx5LZKJKEaKJAtnnQVRPt5HvWFEp8DQpNKJ9nXz4aBCs/9nUY2uNIkneX3tq6QZjS1SdkY/avQVSg/eZ8dwfbGeuO6wMqxb5Pu0fUFAIqZZAKSBLjDXl3bBE7HKTkKMQ9jlBStpY3mK+qiisV1/j0GCwAmTQ1sFshuPUl/AgXNZ5NvFr95lo/EJGcvMFG0sMQ1PbY5cBdHoG4VCcAuLLdNNpKZX9MfzXO0CK4h2AhOovCfjYcXbOX5QSLHdePbGnWyPM72fByZb9x/RafVDljyKEvG8+hE1mcSL7VvdXQGpSpH6sp9t0Rk3FDmS4DR0+JTmX8ov1zLs1vhJsfoSPekS2NQjH+SOFeaacGMtet2/PgJBptQGDDo0z2bfKbMqB8ZUWmbSyAwV04j9g3MlhY0CfrKKVae2I2GGMNXSxJUV4UXVsb2A+1QS/qgcY0XTeqS0OelBadw8A+UTYSUZYoSGTTH5Us/HbNPMW5j7nl59tA0eryNmxJ6Yb9YWguxWK6/e7CYV2nfLkTPM1vV3Cm9CIeVXa9ilXh4aUTrcoUHhFlGd44mJazL+kPCsjgGwbkuUH4qI16o3OKVAkr8wRZc+HJybKl3dbyNR8ODks/ZAZ9C4ozk2P4uV3HIUDrRK9v9WkQoMCiUz8MxKLi1UYdcpt5EJNFXCdSHqoJldwvvqLABqN2SYfGHAEbFFHlrcSC4L1x2b9MicbFZaFs2Iv4adcDs87DpSzwSTqPCVafilujmHudeDqIDB8b82iQ12e20YCbCPFVttVDiCJqFgkXVm6JgHcjf3bFbacfEgM9NHgzTVo2BtMbYzoYGrETmOqgudmcqVchGvrJ9nIoJNDcpTGO5Ofxz+uGDOtPA6VHyJvJ0E+3WIZHzlGrEwbTrGvXzCKY35g0H6C+Ey+UaPQPQIvIzelyfBR+BUDLGFBo68ggmfh4oRpTR/Um/S
 w4mxhUqe
 IG7e2IPjCxKUgaXP3giJE73ITIhyACBrxIB6mxIA+lIWNxRz6aVV7rbqcDyRtkxHoZBpk3M3AB9wbQ9zt8a0B3SXGSubtcZqEnYoU7whYe2kWEkLU/S6AGMFcqHSJ6CxuU0Xx2+mUwQaupHSJ7EPyC2iggdwuFI0X/5Y6AO/xuv2ARghn27FqHI4TopzXaDYDMgbhZ5AZ+c2pDT5R4yjqznRhdFpW5SgZhKO4YozZ+mU6ejqEUd2hjUQ+Qvu2JEHko7C5rFPQ9yi8IWkui2TAVOsdad3X789AtYbx/CuqJOs/NxI4Nbbk+kL77J5D9gzb8m+5AaPhWJJotA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 01:09, Christian Brauner wrote:
> Make use of COREDUMP_SPARSE. Refuse it without COREDUMP_RECORDS.
> 
> Actual holes are sent as a record with length indicating how much zero
> data there was.
> 
> coredump_write() flushes a trailing hole if the coredump is done.
> Instead of writing the actual byte for pipes and sockets, collapse it.
> This stops wasting a header with coredump records for a single byte. So
> we now only write it when the coredump can be seeked. TL;DR a trailing
> hole is a zero record like any other and the records still cover the
> whole coredump.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

I don't have a lot to add, the general idea LGTM.

What might still be suboptimal is that, for large sparse ranges, we'll do a

	get_dump_page()

for each and every possible page in the range.

It would be interesting to benchmark how much that still costs on large sparse
memory areas (say, a handful of GiB large).

-- 
Cheers,

David

