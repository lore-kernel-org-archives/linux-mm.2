Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0526606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hjxrae5Z
Received: by kanga.kvack.org (Postfix)
	id 0596B6B00EF; Sat, 21 Nov 2026 07:47:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007CF6B05B0; Sat, 21 Nov 2026 07:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15156B05B5; Sat, 21 Nov 2026 07:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84DD6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:47:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40F4914042B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:47:51 +0000 (UTC)
X-FDA: 85459103142.26.0AD7A23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81494C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:47:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hjxrae5Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795265269;
	b=cxN+xGtyZ1TMGfqH400dfriIX4eraMRQFevBnbZnNZkeD8JcQ8qDXyVmh4cPsjExLOIwh5
	VX0D42y8/IwmPHqfe32TaKg6ZDkq1ln6Q+Pp/95OlIGf2wu5S/DHAhK6J3OOSVjRwJyjII
	Lmrs3nf8Gq5WBv8L0tcKJqO04KV8Ek8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795265269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xn3iDLCR1hR1APvh7y3dRnnb/YU1FYh9u65VZdIFMg=;
	b=AzSD/g8dC6423tdYNlCs/fQidfTNJ4SUU1AHlc8dBkwEYc1mOcRzJP0OnWgLeJuPtimC2s
	iJL7ylOXJFjinogC+FZc2JXb6tnaNLcP0cWPEoz0UjlmKVdUDxh/4YDR0SUcRyfGWL2Bf0
	iIkZe4Nw3HI3d4Dj5P5DbaHEeU/206o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hjxrae5Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0388961597;
	Sat, 21 Nov 2026 12:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B311F000C6;
	Sat, 21 Nov 2026 12:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795265268;
	bh=6xn3iDLCR1hR1APvh7y3dRnnb/YU1FYh9u65VZdIFMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hjxrae5Z0feO/CrPZdN7oUltqm6RKHjuauex8K9jaXbOAR8XBgpW5Sh/jc75j4kOW
	 dOuiqi8lsrm+YFZ+vSpQgSY8KkJZFlOKen359RUWey39SHghKQOQhpStV3cqUWwvXM
	 Ka9ozrcfSFP7VLSkOMJ/DEzx6lIzie9WZN0mtMfCDqmbbvnBrzVcOzBRDRw3aHjczq
	 JBj+tGAXKY/RO4GBqd4zs294WwRi0joOn+fOECOjNY/Cn8tRLEkft3/l9EwT7VTr+r
	 4NzYP13XXA3kQAQ+y6vVTBkLK/xX7tl9HhWOrPXChZdLB+eWt7WnIWh2a6dG1JRdOf
	 A754XQ0PC+/6w==
Message-ID: <7cc5ca1f-fbeb-422f-bc05-55b3f6b6db20@kernel.org>
Date: Sat, 21 Nov 2026 13:47:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
To: Ding Feng <dingf3ng@gmail.com>, Brian Foster <bfoster@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20251121152246.1023918-1-bfoster@redhat.com>
 <20261120051319.44456-1-dingf3ng@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120051319.44456-1-dingf3ng@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ifxf55474htzm3grf31pkuo3x897mx7o
X-Rspam-User:
X-Rspamd-Queue-Id: 81494C0003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795265269-215655
X-HE-Meta: U2FsdGVkX195Cg/PDD+S7eE9u7AsqjjwYBjZg8OM2+TtxjE6qKNC/PPUz4IZeHxZF7+Q6l8kE3mlqRsFvtSbf8H3dRVLtfSZyIVBzI8MLDFI9YFEfyj3pSs+apSCeBSXJsll3uVCqWVOykBI8xnRQ1TSYPORKUPRhl/CwP+KGBWKN2Ov3yza97I6TrS3hQNr4mQEld8LxTGmzpA5rrl5lip6hMf96Bb7GieOq0mLCdZULtTbZ9woa+61fsMhnRE/jKPbAgq3CgHvuQY23EbevRJHAa9ANHZLtmUZtMlhzVwcYd2M3IzE20c/WwhLt9fDCVB7xszjsEsv2tWw6H5C8M4bQavUALUtQ1suqmNMfpTJtQMMNNQNviJ3bk1g6QSqvK1sWPxhax8cg1ewIuU3nG3kN19YfOodkEiaio0gGXQg2pBqYhsMzuObwI/n51+dqlpTGXBFn/5wx37+rj6V9gnEbg++yQJe0/a2fOHCA80TSAsBmqEG/zAxM8wnKeid8mC8YNSuHjEuJxvcF2MZmT5AWcch+c0kE3o1pIet6xFuTC7iAawUHRurZ7X8AsMhKhwp4YAgLZu9gM7LGUiSIqAoQQp9R5M3x2IXIurpOUf1RiueM56w4Z4Eo6lI0TdTyk2owH4YrqPkJUdEb8Ci5iWhq21H6xgU6vZSam9xT4QOLfX7gO5QUr9hXklWn73Vwnt+uNYXyF8zLFlxr6XJdc3/hYhmvZYFRiMb86xKBVnSldyTcCMQkmbU/H3OvDzXyY2yfpV+SWuQscEqi8gve7NM2nfu//pSAbmUd4v+vt9ipPHdku2mtZ2RbTTwe/p3dYnKm60efer4AHnQ2in4s9QwojL6E1NYZMsSZiMqlxWmjjPlfMA6pzzflo3Eega5xE1Ls1cefTq/i0SBvDQpNrt0xhB5Q/vnaf1XgFhQ6aNxrI1mbWFaONVB3EqSfRSfueqkMiadGW3PqdRXOe7
 T4ZoRwiK
 QDVZc4cQ7EnEAZqoUUe1V5JuiYhsZG7mqtx9OOp1RivbczpajcaFiPvn1H9KVBedx1PZhg3yVqWmwMvxoqsvywneJSE3ttCfLbU0/CAzFd69P1ePZQSZek6zBFRXK5GHhzh5R78IyP1BGYJoeihYPOYq97dku1NCrlzXIfSCSx5lsdQ6FA0bZR9n/lel8v8qLw7L+5bvTPOxpVtPaEghHcSkm9IomXeCPeFJPN39TapRM8Q2A02Ao5Ctdvjbyyg0k7YlP7UPXdyTm/ZI31hwZaTFcb8/qFIQDZ/EQSdfvf+GEKsh+NxX303/a6wCn1t1Y0HXNHz5jxbTBsve9QWmBhdGdqurBwXdJFbgRa//C3+EpM9DuZn/OE+c2BiobwiTKH6Vy73ilWD36U9fZs2nMDEAXbq+nQsLLVUye4HN9FYpMlrk64Z3jlj+DcZhUmbDyIxeAH4w6ARdH/LOiJlqNBXwyhXydA9kmIhtdzSfwFhHIf71+YbU8tZrIIJup/JJOvyY8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 06:13, Ding Feng wrote:
> Hi Brian,
> 
> I ran into this on tmpfs independently, and the series fixes it on
> v7.4-rc3 (65e4fd942). Patch 1 needed a one-line context fix (the
> i_private test in shmem_writeout() is now READ_ONCE(inode->i_private));
> patches 2 and 3 applied with reduced context.
> 
> Test: a 100-byte file, 'A' written at offset 50, 'X' stored at offset
> 200 through a shared mapping, then the file extended, then bytes 200
> and 50 read back (arm64, QEMU):
> 
>   extension                     unpatched    patched
>   fallocate(0, 150, 100)        'X'          0
>   fallocate(0, 1000, 100)       'X'          0
>   ftruncate(fd, 250)            'X'          0
>   pwrite 1 byte at 1099         'X'          0
> 
> Byte 50 reads 'A' in every case, and ext4 gives 0 on both kernels. I
> did not test the swapout path (patch 2).
> 
> Tested-by: Ding Feng <dingf3ng@gmail.com>

The series is from 2025. In order to do anything with that, either the author
has to revive it or someone else (you?) must pick that up to resend.

Thanks!

-- 
Cheers,

David

