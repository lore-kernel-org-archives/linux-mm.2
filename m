Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF32C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50316B0096; Thu, 27 Aug 2026 12:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01276B0098; Thu, 27 Aug 2026 12:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9796B0099; Thu, 27 Aug 2026 12:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7696B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:59:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0576740116
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:59:26 +0000 (UTC)
X-FDA: 85147660332.14.6DD058C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BDB6180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:59:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nd3nAdMM;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2fPqhbW52jOXFQOb2OokwPKsft5CxEe/wxpe9v4C+0=;
	b=Zem5X27snuvxB7D6IwNeI20nWmhfnXq+BnN9td342bnVUDAvblipoyxkMDmmQL89+wCrZT
	s7lasD+KL+enlp9E3yytRAvhjcnPN0uqIAa9ByiH7ChagHNVVRQE5s69AYga1YNSyLbgai
	6cQnfN/XFRAJwsT81zTNDGnKEUuMZiA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nd3nAdMM;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849964;
	b=l2J8VPudr6oD1CcTlhOQwZwiUs7W84mOzgVvjZpZpgCPr0k5oAckqvcL6qyS/0H7Wv+rGQ
	5Nh7Dd/Jti7LTg9zC1SmmFbG1Xqogv0JRwQXMZegBE55lXh9tAlS2qdLWfmlwXGaVu1Fd1
	0ioHqCQ2rs+OYvCg/8rnPvwq9n70ymk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A9D243EC3;
	Thu, 27 Aug 2026 16:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212F31F00A3F;
	Thu, 27 Aug 2026 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849963;
	bh=h2fPqhbW52jOXFQOb2OokwPKsft5CxEe/wxpe9v4C+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nd3nAdMMTWYEbBrAJwomzGYSh7ao8MyAXx57oXymtv0pVBZ5x0jyRzWm2CxtrIWbH
	 bOQa0cR81UCOd2A6cBl15Y/DkRE6NYc1Ed/8zkbqndKX2NCq2UdZZ2YWoHB2Vu/Art
	 t7yGuMgaGacr5cupOIB3W0dF4zNJIGTBGfy9HwhiUx5ceof2pwd9ls165joTWUSqE5
	 W2teb2UiPjjWD3YHtuiPCHX1BeBRZ2GBX7vNgqOWmjgiMvOm1yWHDCzQiReF+ct/dd
	 3RsBDYfAMdxCd5fP1NADp1dw2cjnMsqjzLFk/0yoDDz+MmwLqbpc7YoaJZMNZQ8aL4
	 7zgmchNnudAHQ==
Message-ID: <c063a592-19c7-4915-8a71-1aa87130fdd8@kernel.org>
Date: Thu, 27 Aug 2026 18:59:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
To: Jann Horn <jannh@google.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu
 <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org
References: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
 <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b3ss3zzjc4bpms5scqxqn1cgsarcdzbw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2BDB6180009
X-Rspam-User: 
X-HE-Tag: 1787849964-882762
X-HE-Meta: U2FsdGVkX19kr1d7R622HMxkvLxnkhnivyVTL9YTWbY+WkPtyKG/y0pSIsMHR4X46PPe6vpeD7pkMkBjmIqyuLWUsybD2za7XZ7g/teBYPutQq0NwIOWAPtdkC8wdRcoY64sqhQeFj6PG2qGoRP/IPrqGgeGNyTN6hi68aNEFUcxen6A4mv9sbHriQKfX4F2vWHOiG+O7oraiabnJG31aQT4X5QZjwVLvnr2bmMIrzs5CC5fVZSzLPhCzSJxdwypezQg1vZ0Rmx9GvfVjHAKq2aV0SZh6rsf/xB/+GhstGC92SEa59I09eHDNEGEECa6iai9/xrAJA41/uKz5tP5AQmr3uifpL/THHk0V62LooDAU7jd1guhKQJoPQLPLgpN4MkY1a2U53A2fuTrUTGbwS0Fvg8qsZdUhilNRtJ+B38jXi6XbAalb5nz7FUaY45h5McqWBDYXC0KHOINLTutKYmXXQyCvuCGWjnDTP8LCUYE0ym1cWOUs/FzbXUZPT0VHphsI12xiQsJ6YiHkiFD/LAlmMdrV2MORQ7IeXKcq1PzPFIIEOCBqfBvfnSconzjxHo6BTWc1aXk0o3Cv0zlpq+1ISCMBABLog/XKT40tQG4iFbA3uZO43BTZlQ/6vrNMYXb7aj803fooRovcmusoiarNx/e8JdkFaJudZVWl9PWQUi4DVOJhOn/cVgDewemEVmXC3cxiwPH3jd6KKrkZHrj/IbjWVWscctftdz+tlYk4QzCXQt2+Wt53byIEWo0k057NwQGh0Z5uw9o8AdbZnQSO3vIL/Nm4cKh0SnCOUYB5S4345Xx7PNdk7u4A8eiqR+KoWooTxwxoDFCyS34gfhzM8NjpBp03mE2QGL3/okTGQG7JEAmulo3wvWPKjH4g6PxrBAY4aYI8OdGZO7aM8HMIHpnV0QjDRrV/3kUkdMJFQCR2G1Yi8LrpUium03Dq6witqEkoogcGP9F8sM
 GPJvdo5j
 Fjr26Eta+WQbbA7p9ewIhzhq4T82VvCEBoF7+wI9JIzVuZpTBXOA7tR/WOUXHL/socIUS1zyiWv5F9/dHS4uhMkBTu7B8StDe1J+ANOvLKVI+Z6KN2G6h6BScnNQGEUCv8n59l2YxwfUZR9fZobRauc4eBOFja2dVwdOwut3B57pPHx0+EMqMGrUu1BrLTLEIgnV9MowWzDc6o1a9tIt1P2m1ZBIh28EK3v3umvcFM+Wk6Y7TPx6cZ7ypGbtY8Lq8YINTLikoc9e4lTG8C0dbB2HsVzaLtdZljOUPwx5ioMNw0GtU3dZjTQZs9zqoK/eUgq2CkDbNDjVsRuNk7mP+pVHcNsBv3AmWwW7ypiu3dy4FSB14iUjx3RmisIvN/aJ6CWc0Ns5cpdjiv6VzHVvG0X+5hOKi++Ju9vvOGx283Vo85gk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 20:39, Jann Horn wrote:
> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> good opportunity to block a process from overwriting read-only code in its
> own address space through FOLL_FORCE writes via /proc/self/mem.
> The security_ptrace_access_check() LSM hook is bypassed when a process
> opens /proc/self/mem because this is considered "introspection".
> 
> This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> that a process cannot create executable anonymous pages.
> 
> PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> accesses are only possible when the LSM allows ptrace() attachment; but it
> is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> environments running lots of third-party code, such as Android.
> 
> So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> such "introspective" accesses.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

