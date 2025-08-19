Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47127CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C256B00FE; Tue, 19 Aug 2025 02:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13B96B00FF; Tue, 19 Aug 2025 02:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950B36B0100; Tue, 19 Aug 2025 02:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 881846B00FE
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:58:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1070614023F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:58:48 +0000 (UTC)
X-FDA: 83792604336.17.34E6AE4
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 23B5C80005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:58:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=L7OvbqE9;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755586726; a=rsa-sha256;
	cv=none;
	b=tD2WiTPSX4HJb5M9sC8+XrbBsgbhWocXi1/sBRSZUplw96ZDpy44fiLGrG2wZN/THeuVfF
	FWxEJo+89NqavqielFzke2U7eiY6svkxFecD4oofQCxOjPYrbeOIoQOYlRhJ1DQfCETat4
	+5RCjD6yA4mIu68G2TQCBFN5eOHLevs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=L7OvbqE9;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755586726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kq5SBlKMmDuDBO8loOgdkG/hYJi5QFPMID/GAlamcS8=;
	b=wfjxVd/l5V0fyZqvSIJ+gRhv9F5gp43ysuZVtFTAD8kKu4Voe0TuwLLhwQfQC6GlN5wGj1
	s7qlk+PynocAcOio+LA9xh+a86A9wZ9zLvHGv6G86N7G0hpC0n/+RBvRCwpzS1AtPfh8Kh
	kJyZq2Bhn0HS9d3MyGMRBMCA3/RQNNU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=kq5SBlKMmDuDBO8loOgdkG/hYJi5QFPMID/GAlamcS8=; t=1755586726;
	x=1756018726; b=L7OvbqE9SkBBsfAajD883FY+7Y92E1j3/n97Et69FmJvz4A7Cf6+iz4wo52+g
	GR4MGdmdjiVSc4eg6HK1UlYYHSmGgzsPh35h0Mui2tBUFeIULN9+ao+VwidnUAdWhQ6o07sqjnHVP
	uoSF2j/N5iYNHRkzqkg24JB2Ii47htsK9s6hl0JorYgOJgyDXR+cNSXG6b/GzC24EK79/zEh4km+1
	QpwjW79fVBGL6MqENr/0tbHNOyl15vqgEHsOuAwDVnKtHYskzJkG3fHmZFHe5w/rT0SVx+bUTdBn6
	KHwXxsSCY1haLjLHqzazzaAyce6btTJ1cCuVgh9ZrOTNiDk3SA==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1uoGIo-00Fy46-2t;
	Tue, 19 Aug 2025 08:58:39 +0200
Message-ID: <9967d026-1566-4a6a-aa1f-c3d5833bb172@leemhuis.info>
Date: Tue, 19 Aug 2025 08:58:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: alloc: add ARCH_KMALLOC_MINALIGN to bindgen
 blocklist
To: Danilo Krummrich <dakr@kernel.org>, lorenzo.stoakes@oracle.com,
 vbabka@suse.cz, Liam.Howlett@oracle.com, urezki@gmail.com, ojeda@kernel.org,
 alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net,
 bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org,
 aliceryhl@google.com, tmgross@umich.edu
Cc: rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250818180923.192042-1-dakr@kernel.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <20250818180923.192042-1-dakr@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1755586726;2f49bf7c;
X-HE-SMSGID: 1uoGIo-00Fy46-2t
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 23B5C80005
X-Stat-Signature: xauw81ws4chxe5wzaw5zb8915yuun9rz
X-HE-Tag: 1755586725-598930
X-HE-Meta: U2FsdGVkX19DqG53ZHUGx/aHTkDxzvCb0eM2KJKgTOlszEaxTfoGaDmahPoKiggvRtlh+f0JCYwqNQJm+X75CHd0LVLVRMic6i8Qguro5doD8JxB6z8gPXtJ0FL6FxkZXqUPRoFSa6XP4R046VC6qZ6UrG5xxjuBIRY3EyTZ+DsAdTTXijqeiVhZyAYSwj8ZtLc1C6MZxWk86PU7Zd+vQhunzXGqXrSVY4R7XTPY6Xl9bJ+rY9AnCS6uUXYu4tB+TA2/zlj691wtvmthi4AXp96RzjugWrv8pza+7TccqMOpH/zw3RIVfcfuJWjN6eHE+6E/WNYxBLP5NUVTJjgu7GRfeQAJysWIaTG5rXtE+M9RLdkPPrbDXEaJgbOPUkD6zuIMqH68Qa/9lOoEhCahR8fdoO8gck+XhbbmW9ya1+UzDrl+UYhhwOuliu0+r3EEYCdSKY9F3reNKIdW/25E781Z8iPyxpngdLvNye4xfppuHASzbEJL7BjPfcH/9tZ1fZddKawv9tCSXtUBF5F7LkhKZR7L64bpjo0b+VZ8EiE7An1PxFl5ZWkCjr6pCehCACye1YOVcks5M2pIigaMFwigiGZaazviknZohqt548ewMco9RJk36mRRdKfqd9KiyaufyU3ue8a64eJqKA9pvF7ava4fQmWXCoDjhf5SWJmZ7VsfGWrPCVzIjc3Hlv/zOWs1I9gtg1jYqAHOFKOgx33mnkrQjV+XN+0l7bmNK3vrW5EqnPI88WnuP9Zm2TWh1TXhp6UgbIIgcyz6D9n20kAMRrf81ZbE3Pr2nDIcckmotdYxyf42K37lY5Wj9pflNGjPiM83/N+7+Wmqs47mhh1puuKhFqVTM6ctJ6R4v/T0/Nz+8iMVTEb3POQmXhYLb2DqzDn8HZ4UvUGQgLa6OyQ4RJEJas3lLmdMaUeAv81RMBq2j4fiTwPCJG1RAZ/wEBfieNtghjtyqy+ArMH
 Qb47xowu
 H1TYp/bsWUByYbJILyIPv6G2ikLUF+1CtyGj2diP0OuSIMG6Cy+bgpgiSMaMzpdu4Yvq1TNYyi8Fi7WRphzeOI2muq8Xst2P/nqCe9lWBxbxA4iUbzITMxz4dXSpXcZpw3qF+5GiB0vgJbglHa83bYPtMEyK+JnQl3/qjU7NoPMqfmNfgPy9j1baKu8jmHQVIH0tsXDdj12sARVHnDb02VvrWW1Zk/VRbJi+8pTygPCj0553J7Bh0CgD/bJBiM+w/JtaUn7aSlwrPxM+ZqhtgNXoNR/t9JpugehaVOir7FqhJHj4v5MK0zUYd8WBD49Qa4U1etIZEN6/k/tVJZ2sUlV4oaY8tOcqcrzH5LezN4iaYrWmvlmrVU/cqmUJ/wxwUsu3VRyFk9nXqVUJVWr7XkGamessZtSJvlQe5Z3nsgmOTI1hjDaxArN7CV1p1PdlgBsgrp8iE/HQSUgxOVZMspnlUlEive4CeqE8FYuPmYcFhjpR4G0i8kwSN/IkLuyuCV7gxclPHQZD0l64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 20:08, Danilo Krummrich wrote:
> For some architectures, such as X86_64, ARCH_KMALLOC_MINALIGN is not
> resolvable for bindgen. E.g. due to being defined as
> __alignof__(unsigned long long).
> 
> Hence, we have to create a rust helper, i.e. let the C compiler evaluate
> the expression and store it in a const.
> 
> However, if for other architectures, such as arm64,
> ARCH_KMALLOC_MINALIGN does evaluate to something that can be directly
> processed by bindgen, we end up with multiple definitions of
> ARCH_KMALLOC_MINALIGN in the generated bindings.
> [...]

Thx, applied it on today's -next and everything went smoothly:

Tested-by: Thorsten Leemhuis <linux@leemhuis.info>

Ciao, Thorsten



