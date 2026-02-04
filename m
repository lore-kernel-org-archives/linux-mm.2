Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09753E9D402
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456F36B0092; Wed,  4 Feb 2026 11:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DFA6B00A5; Wed,  4 Feb 2026 11:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357916B00A6; Wed,  4 Feb 2026 11:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 227CF6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:07:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE2A61A01EB
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:07:09 +0000 (UTC)
X-FDA: 84407253378.06.9C217ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0286B1C0013
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:07:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XnzGhoQx;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770221228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgeg4LpFYkGts44vRDwLwUa+VYSDlRkllv2N4lJEvvg=;
	b=zvM1qKrMn4fgTaMuhpuaEaeMPCZ6FSfCvTtT2gHJO+wiermg8TAcCulJTjH8PLjxjbCFz5
	iTmufDb9JQAIvmwbDluHsVvUPkMjUL//U7lR0S5bcploTPIlYpkFJDx6c1ZaMrVMuXzLmB
	F+ppxT90S73Fy6bX/c+A+dxTCVxL8Yg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XnzGhoQx;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770221228; a=rsa-sha256;
	cv=none;
	b=quAAlGAuRpsH+7rIkUW9OoQI5DtGpXHrJHwBIlDip70xf7f4l1oDTfMhj42pInkgcyxkab
	jJ7OS+Bgzik+aO8N10hYJwMyjiu2PljKBIul99qwamPZ/4bk1IjFJqHZYX17YaoWr69cF6
	0DiyeqwerYakx5JHJK8FljsoJMthwCM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF5C343386;
	Wed,  4 Feb 2026 16:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1A4C19423;
	Wed,  4 Feb 2026 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770221226;
	bh=zgeg4LpFYkGts44vRDwLwUa+VYSDlRkllv2N4lJEvvg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XnzGhoQxZKf3UQUh2YoZFN9qW8ovu2POoWF9WjU6+PWtF+yVh/x/ub22/QXkV9h+Y
	 xQAB+vpKbZNTxsxvYOGjMKFs+zhQYNcpvhtzg5hwZy7PC72ma7i23uU5zASOCB3d7U
	 JE+DG9j6685I5plBOtUzYIFke4zPfub1mdjahapJr4+/uYqYwArr2iW9Zzh+tL+4i4
	 qocUIrDo/U8co47MA3m34ke+IGQfRBAohAjf5uTGNfYgwIiciKP9K7vnqOWNzL2cSf
	 u0QkyK6DDvaohsw0x3RfqmciFoHurjoxlEfTbDT+pLK5v/6DvUWtiQU+mKsVxN/335
	 +mgP920c5zjTg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin.linux@gmail.com>,
 Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Asahi Lina
 <lina+kernel@asahilina.net>
Subject: Re: [PATCH v14 1/9] rust: types: Add Ownable/Owned types
In-Reply-To: <DG6AIA0QK77C.EKG7X4NBEJ00@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
 <20260204-unique-ref-v14-1-17cb29ebacbb@kernel.org>
 <7uftlTZxNVxMw7VNqETbf9dBIWLrQ1Px16pM3qnAcc6FPgQj-ERdWfAACc5aDSAdeHM5lLTdSBZYkcOIgu7mWA==@protonmail.internalid>
 <DG6AIA0QK77C.EKG7X4NBEJ00@kernel.org>
Date: Wed, 04 Feb 2026 17:06:50 +0100
Message-ID: <87fr7gpk6d.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0286B1C0013
X-Stat-Signature: gc1g5tx7atoz8zbsrpq4z6fmx4grxmne
X-Rspam-User: 
X-HE-Tag: 1770221227-717125
X-HE-Meta: U2FsdGVkX1+VZ1OO1Shlf/K4S4GUE2F41Oh+dtL+8T7l38N/R6Q9lJnNoCFPNK8HeT7D8HFML8Er0kxPFzN6UvzG89foII2VBAZ2+S7mTmnlbgAzNSE1p2uKSs+J7eIcBPmPUAs1e2+XZ4AP+4kI7cDj97L/l0+uz90posDlzv70L0HZhvTSIeX3yxAsh2rZ1/ExfmITE90wErXn0vpE0Ap33FeYeDcuBUvuR1StsNW2n/qoRBkE88hLbg91Mzqh6o02q60GQB78OuqQSwypnBv6QVvBZBDkiZ3d9kZcz0oJWJcy5m6OqOD9P0rwYw5AXVxD9uL9MVvmjDohAp/xAFV80OqyuwxwASqlk0IK8Q3mQTWOH/rZboJWBmdLbNu2fdxUaJNpHCaWncV+p7twmdYJd2l/x/wfEBqT75gTzcDp1JeIX2NxHlcJEHI6fDc3iJB3lsEiA3+v9hcAjnh2j11Ld+6uzOaBECMseQvPbhGwL0GjW19/CqA/EW3wHj87ASn0IANi4M3xsQgY94yjMEAAMXuPyUfUvDq8pxT1z9w+790oagJWz6135Nup1KqDIcjqTztD9xkSVi/j5822OneB6vA5orZz15i/78NttPQ/0ts6EskNNL4929sjCU4jrCUNayW21wdb0rd8ZXtkArOHqiKByzlffFYVzDiWtJq9W8JL3rwejNj/ItRh6lAH7XFqvWRf7CQ1c9KKGrXDTN/BrlhSiTKP88WgE/Kwg9nrrjDkCOZ7fKP723KMLHOc9WUxUEt8YZIfal8Hg/B5Rbhit0KvDMTXOF3JARBG7JmqymtxuwPFTzVzldodkiGj+A5JaL2DbbtqmBbsxMEYV356Ef7jwCpDrD2XHBoIwqvpSacp4hCnwVgM2l0IkHfeS9rfBXGyzCdjqByF0te3t71yjNedtfQjAUTp7tqCax1PjJcL3qWVvIPQG+wUf59AtiT89y2sEYZo+kc+hmi
 cC8/+cI5
 nQ1nuSlLjkgjuSciO38OJRq/HgBtyAS9kbmguKhzNL06iW1uqLUO9xbsJl/TYA5jdnLpCtdfmGEbGQIUQApnW6bMZezNjUzG1Po2iHBojvRbE2x4ke8MUoMVDLBXGSvN211055ozKWEWa6PpOtudmpXayon5RRvYN6neUoxaecI4uARuKE7R7O+kOwwA+O+jCCaXdKaZTo+kSVhubUoB+V0ISIhpWM0+ktfZSHuKAErs+n0e7FAv0mZ+q/+/UI3vaTfwY3CimJpgwTFoyB7ZVh0AGGtPZEILfwgWPOOjJAo9SGLFEbObQhnGoBCLLO/nK3OLk36YLLYk980s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Danilo Krummrich" <dakr@kernel.org> writes:

> On Wed Feb 4, 2026 at 12:56 PM CET, Andreas Hindborg wrote:
>> From: Asahi Lina <lina+kernel@asahilina.net>
>>
>> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
>> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
>> `AlwaysRefCounted`, this mechanism expects the reference to be unique
>> within Rust, and does not allow cloning.
>>
>> Conceptually, this is similar to a `KBox<T>`, except that it delegates
>> resource management to the `T` instead of using a generic allocator.
>>
>> This change is a derived work based on work by Asahi Lina
>> <lina+kernel@asahilina.net> [1] and Oliver Mangold <oliver.mangold@pm.me>.
>>
>> Link: https://lore.kernel.org/rust-for-linux/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/ [1]
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Given the From: line above, this needs Lina's SoB.
>
> This patch was also originally posted by Abdiel and Boqun and I think we should
> account for this. I mentioned this in a couple of previous versions already,
> e.g. in [1]. I think we should account for this.
>
> [1] https://lore.kernel.org/all/cc28d048-5e0f-4f0e-b0f2-1b9e240f639b@kernel.org/

I had a question about this in the cover letter.

It is my understanding that the SoB needs confirmation from the author
if the code was changed. I changed the code and did not want to bother
the original author, because it is my understanding they do not wish to
be contacted. I did not want to misrepresent the original author, and so
I did not change the "From:" line.

I want to be clear that I want to submit this patch the correct way,
whatever that is. I will happily take all the guidance I can get to find
the correct way to represent the work of the original author(s).

How would you prefer to account for the work by Abdiel and Boqun?

Please advise about SoB and I will correct the series.


Best regards,
Andreas Hindborg



