Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63493CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB0C6B0005; Tue,  9 Jun 2026 04:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C3E6B0088; Tue,  9 Jun 2026 04:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791866B008A; Tue,  9 Jun 2026 04:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64D8C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:38:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4C411A0296
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:38:29 +0000 (UTC)
X-FDA: 84859722738.08.8171DFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EB15140018
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:38:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRvIog5J;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p720QhTHRxdWFoEDw5qbgqIlfAPKWWTlU+46eiRjaog=;
	b=mkHkuOMqIWuyvM49cZXz/obZwoDU2nmvavFIN4hjpEhFHlvO781+yaHZBjGhfeCBg7j/4/
	bksLhIFNiOj3Fj0semmsPZHqpmrYqTZ5G5MX/bgxREELd56WBoyr1TfRzp4M2VocXI2dhF
	KBu1gWFSy0pC+WJbTebHJ0GrCuQ0x+E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRvIog5J;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994308;
	b=ziONFZS6a038zoDHICwNJbiakga5kshg8oCyQ1GPoJDBJuMhAdWcyAiGICIfqJnr/owfCt
	d5rAc6xpGKyRHlZtMGCp+y5yddP/izbc9q3z3Z9EbEHQ/Y7yBn5Fl0wgabDzzRiSJdLftQ
	yquIYf0kIUzUh7n9N8f/czUrKKtJ5gQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23E2B4372A;
	Tue,  9 Jun 2026 08:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76021F00893;
	Tue,  9 Jun 2026 08:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780994307;
	bh=p720QhTHRxdWFoEDw5qbgqIlfAPKWWTlU+46eiRjaog=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dRvIog5JWI7j+wllPCBO45sSXiK3MhL5NbtyhUKuBQyAgZYJATK67JNBiehFRSyse
	 8AMwKMob3qMthWQJSv0f+BCAmUghC8vhj/tIzUZWlq6kydkVn7N5yRXP+rko9VGTOP
	 o2BGEl/jz3ydzr0heFATEa58zyJR6PJFlcGsjp0nS1oRJxwDuwgvdNqojWfbJYdAGP
	 fERPcKOHKdDYZLXvVQsY/m+SekXIHEOB4pb0GnW+4tacs56xaStQgLmXK+1yApfK4+
	 PdvYtwW0J46ub0V+HpyGRBWAOub7p57VCPTJj1sLiT3aTZPEb8jb6g6fhFeRa7lVIc
	 KtMUnPzRUck4A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Tamir Duberstein <tamird@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Daniel Gomez
 <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Gomez
 <da.gomez@samsung.com>
Subject: Re: [PATCH v4 02/11] rust: xarray: add debug format for `StoreError`
In-Reply-To: <178067251341.96312.1551479010624701516.b4-review@b4>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-2-965f6028790e@kernel.org>
 <178067251341.96312.1551479010624701516.b4-review@b4>
Date: Tue, 09 Jun 2026 10:06:21 +0200
Message-ID: <87o6hkgmte.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1EB15140018
X-Stat-Signature: age7gjikuku15i86wf5qp1xcqx9yktnf
X-Rspam-User: 
X-HE-Tag: 1780994307-602691
X-HE-Meta: U2FsdGVkX18xsaALyG0Hh69XryqHVzspTAfcZVHlBBceNt84tDYpQBstJb1UnziGyCO322Wy1NWpyBTJyWXGCknBktr/znEef0P4SU8zOCwsRwLUuLiZrzTKibAarTFmeXbyoCs9qdYeCaMkRh9ywHMD6xaLCXlDag6fRfejxPwqgLDGYRulMHlVyD5hEjSPiYl3ZND11c0cUo+gRZsF3TXVkfNuVBL+Vrg20/YDRTonA4Crrzscegv3wl1Qi6zTMa9q2eGng5otNwNJK/P2SH+uqbQLmgIrqrH5aEvGUQqK1Bt5/qpYYL6mVADFacr9ZMmX7+grqaxIrQxTg2LFaPrE0Z543Qt2TgAvM8nwwYGWZJHK1yIXWYz38mwcoOl/NOP9/rzmvf6//mxEkv+s4HNNkHCtKzKCmfElZ7JTq9nls9xl3e511QDPQvVmdYezBWTv87KuxojA6mspo5Gw2Q/7f4wnnVoa0X26wF2IUQtoIL71OSbLgsoUoNPB7756R6s2VuD1Zc9SyA9u38bS97YkNFIk1DpwzoHwwVKndStdFFS3rSD/cLuKF5E+2QkxHPtHUP7KOBcK2HP7GExioc+YW99ZPYANoMOwtbxOkSDFCMu9k4Fgm2fyqkq+2ky1wJiQ9gyzeHAKtqjEoST+DxF1YrLyWe9pRFVxEW11D+EXO9rUBmbtsqbXbm/6wnDZZ4zJQXdrhlTJXAAE7YTvDvaxQtnhKe88MqRRrrDDoeqSke9S7ueG3m32UJMDeKUwUwDrkxdZn5WvQc+2iO/u3LZ9RuqRFfO0E25AuiWPayJERHMJZ/KSpsllxMwB3BsJsD1N2G/Hiu3xgFHvQt78ocXujEinXQt8nunkDMPR5R9/xNGlIGdhias0Xzx2RO2Nk0yFTb0Ezl/Hk7U9EAPhm/gdLC0UQnQgrjppqK0V/GDlj/kDZh3bHYb5lWnA5rv/BCPHDo2V4p86DYn5AR0
 uYgWwJjK
 CoTV/4DsVmqKYbcSeFhRm8smz8cSD1+vnId4rS+uH2aINNvSoJtD/b/cxUtL1OP/NpVt5RtJoHrJoqB0GiyRzBKhXMVEvxFyDdyRdswxdJSIl53z0H7nOHz850U2l0i4dss/gRUgiiPdArrG3vyc6AZeSHVAxjq4zrfIkgZWigMRUeF4Zzu5mznkLPeLna1bcRzVmahUgMC9D397crevFMpXGbsg7hOvIRjyMCx8hTQ3gH2UWggt7n3076DYG3cuK9I+Dxj+WmLCmvD3XuD92jwySy38PV3cmZY3CGzeC91XyDEFOYJ1W57c65/MPc6MAR3LTLf8p+dWGSB8SI/Gnbw52hy7EN8wReEh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@kernel.org> writes:

> On Thu, 04 Jun 2026 21:58:08 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
>> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
>> index b80fb7a262d0..d54942aeb201 100644
>> --- a/rust/kernel/xarray.rs
>> +++ b/rust/kernel/xarray.rs
>> @@ -193,6 +193,14 @@ pub struct StoreError<T> {
>>      pub value: T,
>>  }
>>  
>> +impl<T> kernel::fmt::Debug for StoreError<T> {
>> +    fn fmt(&self, f: &mut kernel::fmt::Formatter<'_>) -> kernel::fmt::Result {
>> +        f.debug_struct("StoreError")
>> +            .field("error", &self.error)
>> +            .finish()
>> +    }
>> +}
>> +
>
> Maybe an import of `kernel::fmt` at the top would be cleaner.

Ok, I can do that.

Best regards,
Andreas Hindborg


