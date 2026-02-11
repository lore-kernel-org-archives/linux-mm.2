Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167DDEB5979
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 07:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7476B0005; Wed, 11 Feb 2026 02:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254B46B0089; Wed, 11 Feb 2026 02:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157566B008A; Wed, 11 Feb 2026 02:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00EC46B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:41:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 884E613A124
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:41:26 +0000 (UTC)
X-FDA: 84431380572.21.886CA4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EB9BF18000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:41:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RriaZAzx;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770795685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqjmLLGucz1/MfkAA2AyTb9IrjLJHdQUIvqfh2AoOrA=;
	b=QoJdCbz5xvss0HF+oE921Vj6bqziIRmt0QVdBw7cCp86fQfqwBStYgxQpZQhXIOyckpl3Z
	1y5Xte8ZXcf9wbLDLHLVXeB4DqxI9mcxRfkCASUIJqdt3ixnWnSJmNU2J/vuz6d0Xnr8iH
	7Soge7Bv484zzmszrJqC+Muc2rk8T9c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RriaZAzx;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770795685; a=rsa-sha256;
	cv=none;
	b=W4DJVBiDGwRWtiiCf6c7HJauCYoDn9W3edl1ZdFuXIa/H8QPPEO3d1jLxGUmiSm082pUQG
	Im03vbNq2VXbDsUJkZ+9v7AerFcKd5H4x1y7gZtc40Nmmp86HUJejnYdjJZag0GTz59oDY
	/Zp2w7bLOYALo5EGxBy6objXC0RZ0oA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B571C406AD;
	Wed, 11 Feb 2026 07:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4343DC4CEF7;
	Wed, 11 Feb 2026 07:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770795683;
	bh=6AY7gjXvSQQSCITnjIyWYDj0BZ2Owzifq01hOOgMo4M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=RriaZAzxE9qwBIfNXdcaeV/8IOoG1YBuN0+DyKycmOKjAWzD0nBnKiUTdtBpEbsXE
	 44SzrIyW4+a3MglOx+md0jlBa7HzbYgitehcWkCU9Tdj7JWolTayOjAdlrmPlb30V4
	 NdkUkxCgKQQc6O6vwkaKomjtR3vTp5WDE19jCpso/MiQtMtcvNI/oOVX1NDqaO3OK+
	 UjsfoNAJ3lIROZJlf8Dd9sJtQK1R7Cv+KnxqWnQGHKPTnYZpvdUUxMVTUDlxwnZX5i
	 AHrZ70+Y5dg/hmQ4YucjMc7RJd+5QOv9PKzakwmpG+9umYjqW6rHFlfmjgLwrwEvme
	 pg1Kxb2y1RG1A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
Date: Wed, 11 Feb 2026 08:41:14 +0100
Message-ID: <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB9BF18000D
X-Stat-Signature: mg57ywgnxncc83bokaucjfwa3iy4dyap
X-Rspam-User: 
X-HE-Tag: 1770795684-580484
X-HE-Meta: U2FsdGVkX1+SmLzT4SdS4awcNFQGwO/RAHFTaZdH6EHv3qAMfSMZGPIr4usELB6myv8MH9hBXHpWKCV/JyiAOekbkLiRJCI7Frcf+5mLCS7oG3DTnfzMvElg3V3Aa6/EpQGx9UAv8UHFbgOXCe20Apwa641P6d5nxIIEBYnYzQMGc7jKrli8QPUNZlbly87lDXk5qrwmFUiWS8BPsAa/LOrpt7+aahkCnQWVNL29xi+crOmrpQrKHPvQj4aD8A1zhaiwTxl4oOwdOPobVPTjp6y1wBGGoSqGRKqqHY8zG3NPb0pUH3Vd+EdadExGC12yQ5M117yQLrx7bD1skMBSRuoopb94rTB2rgyxccxRyjCH0ASqX9owA9eg3cefUz2UzstqiuJdltha6CdW436Pi9ciUMbk7F7ktfxDha/MDLeebBKO+9z7HUNJicLeq4IWgxzBJoODWGzPKVjcj7JLZjPNzq3vwT48gdV2bwxAFGwEk6sdgXtFiSjMGRxaHONHT0TAYOkbgpMjJ2o0CoGw3MhrKeYIrXLqwyWUj23A+ZNH+u7JMGD3Wp8ONs/zlceFQTq04bXONMdoXl9HVCfYaLMt/zPFqWWQ88WFpNYMDvDrYR7ijBUBwi0Y+9ATgezgxSzXjz7KeOiIkr2rThKa7GlwwBzNaDm7LnzWcjWPvohJgI/LeHAW+dIIw/a8Nu3IXG+FJBy5STa+FeoKVnYOBvXOlXtryg3TbUVIpisKRMyIOygLqIIqBChCEU77/9RZX7lKoi08CZuAii31PbtMM/YNMlgbo+dEd1cL5tOMpjxw0S+KblAMaD6Cyq9R3b8UdjxmhZtObEjZK8tBWt6bWm58Nq3j5rXX4eFjerdoZSZ5BK0KJ3cz5BcKHNyGs8Bds85CJ53ROXXPqWys1BrWUfOYtNj3FM5UaBCT/39kaxeULlPy9Yxky5fWSV8HMZvdW68hU0O1T1cNcWUJ/VN
 UKWiqHPg
 jBNJrjGdJIFbS/FAZYVWh19z7csExToUw++o+OfA0yvKqaBscYJvP5vNBEGjtqrrSBnr7FNxg0jnovldnGbhJE+gvH1SoNOAqmvKgMokY+HiXsaRDbm2fZLcoPBWFejcptcN/SQwlEilJp7jLnVk5DniS9rUECWZ0yvo7n+A6r6HTt6xmDvcFwpi3/knjeFR2Fltu+0TQnVkwsJQ6IiesFHnkzozySHCHqkpOMo4u8PlERWPTeTO9FqE4+8oEamnM7M/1wYIL7HT0ahOUUj0oIW3O4dqcLW4HBQhD+mp1r6z+UDZYzj9oRWHklpGZpkhHvb54dt1gWc/Q04c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Liam R. Howlett" <Liam.Howlett@oracle.com> writes:

> * Andreas Hindborg <a.hindborg@kernel.org> [260209 14:38]:
>> Add a convenience method `contains_index` to check whether an element
>> exists at a given index in the XArray. This method provides a more
>> ergonomic API compared to calling `get` and checking for `Some`.
>
> I think this is going to result in less efficient code for most uses.
>
> Most users use the results returned, not just checking if there is or is
> not a value.  So if you find the value an xarray state and then just
> throw it away and find it again, it'll be less efficient.
>
> If there are users that do use the xarray to just check if something
> exists or not (which there probably are?), then it should be in a
> wrapper for that code and not the generic API.  Otherwise we will have
> users pop up to use this method when they should not.

I agree in that I would prefer matching on the result of a lookup and
using that result. This is not always possible due to a limitation in
the current implementation of the borrow checker. Please see my response
to Tamir [1], it has all the pointers.

Since we cannot use a match statement in certain situations, we have to
fall back to something that does not borrow from the collections, like
`array.get(index).is_some()`. I would argue that

  if array.contains_index(foo) { ... }

is easier to read than

  if array.get(foo).is_some() { ... }

And I don't think `array.contains()` is going to have worse codegen than
`array.get(index).is_some()`.

Best regards,
Andreas Hindborg


[1] https://lore.kernel.org/rust-for-linux/20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org/T/#m95fb90870c511491f4f487dbf852c689cd0733f4


