Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E144CC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F196B008C; Mon, 14 Sep 2026 22:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30F36B0092; Mon, 14 Sep 2026 22:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23DC6B0093; Mon, 14 Sep 2026 22:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2816B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:00:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20028402E0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:00:29 +0000 (UTC)
X-FDA: 85214342178.25.F6A212C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5A59FC0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:00:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AsWED0K5;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789437627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seOLtn7PZjOcFpj74bjwxSYEG88tNO9Fy59lprCxUnQ=;
	b=Ej15w2YpCLk2bHU3IXAvL141XMMLiojcEM/vzTs7l6hmY2TVwVR39u+ILZNjKR6fu8FY4d
	9Sheqnrnfmb7mXfA1g+D0npbW9mZ0aMkhzsLvZ/TwTzrGZnad2n1FK+Nno9I/rMZsfZ2By
	pLnn46+E68TFXO0rwIjJg68U/jcPGTE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AsWED0K5;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789437627;
	b=Auxv8s0ydwtf110u6kcuHFjbfVFuFTDXoKgCHVSufAH4p7mWP/HMYxAvCnIa4dK8DgZavc
	65dMkL7NmlXxNvw9VALFpmR2KPrHkG0a9CHcKwQuNXoNDFhyUycLe1ou1AQqqhBymJuG+J
	8aANMa9hBHJqBnEE5rekoJwaHpfQu9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 280C36025F;
	Tue, 15 Sep 2026 02:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8B41F000FF;
	Tue, 15 Sep 2026 02:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789437625;
	bh=seOLtn7PZjOcFpj74bjwxSYEG88tNO9Fy59lprCxUnQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AsWED0K55GRxQa+2by8CN/aH5Eu+FIzfpnhXxCbY7do0WSyI9wDy8wdp12TmIvIVg
	 qlc7+DhAH2ZkbQ/cirw5BQZ/x/H1cFkRq9pkxmXbQLDE/6pcDGQO+LZjR+plypPG7b
	 o6d6oDlH/NV09BN1XhW3tamrb6bbP+TOeoflg+aA=
Date: Mon, 14 Sep 2026 19:00:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Brendan Higgins
 <brendan.higgins@linux.dev>, David Gow <davidgow@davidgow.net>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo
 Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Sang-Heon Jeon
 <ekffu200098@gmail.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
 kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 0/6] mm/damon: misc improvements in tests and documents
Message-Id: <20260914190024.358f167aea301b78d50e6a00@linux-foundation.org>
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A59FC0003
X-Stat-Signature: ab5qxtmztfc5atb8sk3ak4b1hhyh34at
X-Rspam-User: 
X-HE-Tag: 1789437627-206456
X-HE-Meta: U2FsdGVkX198k54ubcdMF+d3o5nY+Ek+6tEi9nbUMB0Wz3hzn2SQgCMbEWuMzNiipAxH+egVmmLlW0cMCtYjzUo690HaSoCJHs+QQg12QltOD7r6kcxlYSGi0Sb3mMG2MT5tAVXn8NAQjrJSi1z7SXGoVcShWmP5uOHCCR2WNM+nh1RXI7NTMaYpjKRe1wkb0fO4PXsHReARjSWlitNKX21tFLJCgR9AmsPh0fzNvVLYXItmJuBd3enblTyEQr2lIHreJROJn6Ny658bpi50shR3z8hVK/nwamSpIFAhYwDhFB81/q1UekY7s4i7R5S+qICY/42LIkG5shJ2v7dkzqGnNBe7glfF+ZAULmZn61igeo3Mx1bMkLzB5TJ24sBOt/NgG+oo64TMJhNlXaq0yfwyhUxE925eziCCF5le+b8ym6RQ8L8E8hmACN/KKdqqFJLCu6wK6zqBuMkyPO6pv7RttW0VR8fnyVq4MUlW2uOov6ouDx/nuoBZfMDMy3t/XlXygfGQCejfZhBJNRbXDQkjG6P/ddNb/N8RtTlh0+WVG8NO4gAi8d99lGNQl22KPysl/RS1Oge8kjtIwQplNgBJR3+Mku5HKZLg237Kl/6L367f5ld21XlfO54LM2rTR+i2yilMAXAFP7lMckzbVug20UMm/TL+8roNT3bcJecwE3l9ibNLsuQgo6xobcrjzReC/xPC3q5V6Vmkz6dCq4p6Y5HY90lQMF4grevdNjmdRzgu0phjCfP+o/gYoefOsccBAjCtswI9b4qqRkO1Gi8QGqGwcH0++5OyAxdjHgS96aNweXPnH+Skb0o0ni/H19EVvOa852y4yxTOs79Y4J0cmJUyu2q7ES1V/oEBw89nUyFhfO2fXxrDxrjoer5P8pKK5BXaLdKH7C/Ca+QRxK4O14pdpP8zdBqy99nr4fQKL+zf0b1SUlKZT2w8yHA8oS5djh3uz1AaWa+9XE/
 k0uWBDXS
 Jy17wzmbI5/k9BNBwWarfH2s+Ot2uIK4pjWgPSznPMelFRA70YJ3lzQU76aZ18HviTb/BXy5KiuQpm1s7oZHHRXEO6SHo4h6tO9ZilfbIGr0f22dvyn/v65oJPlNkS2zE7WJDh0ZCfcNJJN3EQVM7OPsgSELyzR+Z/5STBPInzzs2Jof0Pm+Dd4wSqclJNFiX6jDz6T69OJV4X1/yAJvULT6LhRdUQuFiKZWd9mk4ejhLs/a45fdHHIWfnlsT6EAZtmj78khhOtHHMyl4bmNV7xr5JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 07:19:45 -0700 SJ Park <sj@kernel.org> wrote:

> Add various improvements to DAMON tests and documents.
> 
> Patch 1 and 2 from Zenghui Yu (Huawei) let DAMON selftest to clean up
> its state and output after running the tests.  Patch 3 from Eva
> Kurchatova makes a few selftest be able to run with Python's safe path
> mode.  Patch 4 from Kunwu Chan improves coverage of DAMON kunit tests.
> Finally, patches 5 and 6 from Liew Rui Yan clarify and fix typos on
> documents for DAMOS quota behaviors.
> 
> Below are notes that can be removed in the final commit message.
> 
> This is a batched repost of DAMON patches that were individually posted.
> Please refer to each patch for changelog.

All queued, thanks,

