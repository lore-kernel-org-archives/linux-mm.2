Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA11606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyOa9O5u
Received: by kanga.kvack.org (Postfix)
	id 8762E6B05B0; Mon, 23 Nov 2026 10:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D9B6B05B5; Mon, 23 Nov 2026 10:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789CE6B05B6; Mon, 23 Nov 2026 10:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60FC56B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:43:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E880BA77C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:43:58 +0000 (UTC)
X-FDA: 85466804556.08.32B7289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31AE41A000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:43:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyOa9O5u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795448637;
	b=76BmRJvGhByMqZ15HVonosouTDVtAcPTOgrC5bvNG12vhjtg2eLJo7L1iTnXLyddfDEpjc
	pnS3OOXLOmk966BnezZ2LO8hMEx7nMVV3DV5TGrR9Ta6ZvgBdqnQ+gWqD5BevahdCFPrvv
	XB1P30QAcb5p5ZgnZgfHIe8MbkJ30Zc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795448637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBPO8PLZh/UMuGqLsh8NXe6Y8zhuf+A17Ivj1B29j0w=;
	b=HaoDjd8Z4bTmda6yyO6SCUPw6r91yuSrxmI1kxmxJZwjLjjSMtE+B1uDn9H3bjigktzy/y
	bgsnfXck0kL4Em5+iZycCXoAi0MO7tCtdnZmr6bxBAhym6/SUFrhnGFrKeBE01K1hxdGMV
	FAkPJZFMf0Vb70Wu813BLTrn1yeBc8w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyOa9O5u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D1274504A;
	Mon, 23 Nov 2026 15:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB5C1F000C4;
	Mon, 23 Nov 2026 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448636;
	bh=hBPO8PLZh/UMuGqLsh8NXe6Y8zhuf+A17Ivj1B29j0w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iyOa9O5u1hxkBN1iYeKSim3KOhj5jcUJNMQDYXDnqEGOmkJAMGeQLrzTFh+WHpntx
	 K9OOvxxzjl/Gl0PvdxP/UjAT1CWNjcoq2ZOneGSusAJrVZ9VP/fOoxIf10b+nHAYzi
	 StubXUlwEjKuzg/YW4RhCym6lkQYF6qrDRTz1IUVXl59jzKgZtfboNav3YeXY+qk26
	 7gsSgU/EiYkcQqCoTPiyu9qpfqAtnXhK//EFtHDaVs4anY3dcqWJ3IrAtLkVRYaQpf
	 HRNLIEihnz/7iJkFyCWrAs3j0Rwg0E7Rwdyz+szoCV774CKQb9TDQcTW0R3qTCQhrC
	 Z1ycA4RAGW+PQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andreas Hindborg <a.hindborg@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Daniel Gomez <da.gomez@samsung.com>, Tamir Duberstein <tamird@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>
In-Reply-To: <20261120-xarray-entry-send-v6-2-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-2-1f69d7385f70@kernel.org>
Subject: Re: [PATCH v6 02/12] rust: xarray: add debug format for
 `StoreError`
Message-Id: <179544862193.2286374.1413505668892113541.b4-ty@b4>
Date: Mon, 23 Nov 2026 16:43:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 31AE41A000F
X-Stat-Signature: o9ttkkt9iw8dr8e3rizji3nb34fnd6s8
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795448637-145286
X-HE-Meta: U2FsdGVkX1/ugo7u64/qgHasKFddvSThzmMVeeo8wVActUs9KTMugzpffn5gLY7dRgOR81inWYOgygadTxwr2SIqHbKXXL0IugFRbNt12l5qGFgmiA2Flxngtd9mgeDZM2/rPOQlUQEFW5gWGQ2HrFvEG/eL/2eJvn/fiT21REFkksYD9K2UmQ03/ku606NEP4JMpthFITuCR0Nz1v/7CA25IJRXHQf+o6tjygPU5adoxztEsvSrZawvU5hXosyxz45k5BeYIQj7yoOViwk2t5Y7jRjHWi6oQelmIbmuV1H/QpthIFyVDqlRsa0C3ZQOnwMEwKrOIUQ5+dX3IbzchDpBodlzrpWK+JyWWb0RVbaWg4XSy60rVIoME+tXCGSgf3vf4/RtND54uf6VChpBvqKdWyD096JBAAscr+DsqSuI+1JuLlwn7aPr+6YQEyGad0ugOOduOZGDHGzFAbeDIDZFpmjaPzheAw4LMdrzQlz6jN3u41tGi2FHneH0E8GbXLfApckfz69TvPwiCWMy434WFtDMUJoTVeoMgGlTyLO0k2r0hHpvCgG4z2vKg5jAXfxhetVWHmyE+RzaYOdcGVhgMRINgerEpjQG+6axiCR3FjvgzPhCMb88MpXGebeMSDv4SpvgsuQ4k5v0wwirw7cRuXHGl7659vsQRafdvZHMULYmEedM03z5MzcNJ5t0TNKqycEAG6WqQzy5PFWrXpNJPrmZPU/azcqInmmAGAYdzEhygFss2u8CQATh2IeYgYjiNHgxV/bumdGm8Dh4c4AtPOa6BqJ+ttXDX1o1hcbKeZp7VNXh7EnVSE5qEKBxDEkgq+wC76Cz9Mb5BGfaLhqS73wl3Cp7Temhh47qLiQl6JgjMUVUj7Q509K8KmeB8unRDtLTmZ/J47ItyZGnmnrOV8RI6HxpPNRM1EFmCN+DQ85cFLx2SaIH06t1cObCPPkMkFZnOYONhvDUsM8
 jAr/N4Rq
 tBHlwKPxFYTZ4St2BDI12bOxJDYheQO5ysXN7EZ1yiLibbkJm05w+eoapI36pSAECr+UT3g9RUV2piTnP2HXOUxauOTpm5LXWSWk+nmSPT8RtpkaxW5qkKzviXAY/ef7Y84Z0edpz4OM1QKwAo5SWb+6GLfc4EFAGgJvQJwssLoWrNauoZKJqYTcEqNKOrTESnqrceNsbU0m2jAsanSW55JaubSIH0e1DTTYAq7ZeTK4Ye47X3uhTcnfnFFH7vpheP/zHAwdfZxYK0Hge0nHve4FQS8HWbVLfUJ9kFNAJUV3bMXt3KZBzc+cfaz4pH8M5KwKjzKmIP1xHGR8nk7jgRc/3wK0YcHXMoF3p7Y/K+tWK6+zuDHM3xl8s15RfE2XYRbnRGQUccP47SNGMZ8zH+1GogXu5u6P9hZ/m71/A4pMBFLMfpvPWii4aAll0yImSfQQee/LS2XidMAdogPwDeXFoMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, 20 Nov 2026 14:10:13 +0100, Andreas Hindborg wrote:
> Add a `Debug` implementation for `StoreError<T>` to enable better error
> reporting and debugging. The implementation only displays the `error`
> field and omits the `value` field, as `T` may not implement `Debug`.

Applied, thanks!

[02/12] rust: xarray: add debug format for `StoreError`
        commit: fe0612239662b50da2fb7b95409be1f3aa7a2f1f

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



