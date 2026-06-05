Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E66CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882786B0095; Fri,  5 Jun 2026 11:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833BF6B0096; Fri,  5 Jun 2026 11:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAE56B0098; Fri,  5 Jun 2026 11:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3C76B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:15:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3308814019F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:46 +0000 (UTC)
X-FDA: 84846208692.05.1DF34FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 670404001D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmLAYhfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsE0MWm9RWknf3vEr/lnGCDxSan/mj8St/jdV9gvrPg=;
	b=2qk5W6TU9pL0OpZs94Tp0VYwb9cWUfNfxR86kx2PiYKdpp8CG+quuSLKAdepLPnZXmtXkU
	OETI3b4LGofWIaiLggBovmdDZD8wxx4fIx4YvyuNWTQVmwc5UC5XMXkRkUAfbAh7VwmGWK
	2jYIBeVnzI6Q+6bGFRrKmtP4BKyFefE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmLAYhfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672544;
	b=U+c8/MFab5N595stZjLpYHbB82GOlBE9xyO0n/YtuXQmwL9Nq4azXubyX2AauRUScOQrwu
	SapAj0drv3fbw0Zs2XhVV77wwm9AFRuaD4NVJb2XyxPVk4uD+lOwA13gtBb8HL+jvPOkiL
	20O4ee3lnSuPYogS0UoyufKiDuE4yjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F14DE6020B;
	Fri,  5 Jun 2026 15:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2F11F00899;
	Fri,  5 Jun 2026 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672543;
	bh=RsE0MWm9RWknf3vEr/lnGCDxSan/mj8St/jdV9gvrPg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=EmLAYhfLU/lYkC+kiwmTU0DMhVcgVG88rZuc84btTFw2S88Z1VQjCcGp9ojAuTEZg
	 sgvXVN8rmlHIu7YAjwQxMj5BeTVmI4DvmeYMZrM78+cmYI4h7hnmfqvxwbUqxsYCyJ
	 eOFqzBL4T9282GoM/yb/YZPNBwoIFGcfpVhWqQF8BAV/qQhoM61WR3MpfySCB1J1xl
	 c8KmFEDalPjozCmbpzGdFxBwR76It4ZjRoSW+i98qwMQ1v5+N3JjXdieHZsWa1shNa
	 3uhNFdDBSYFAL6S7Qb3rh+7AJsqA8Ma+CkBQ+rlkS5e4KEv7UgtF06bxgffQby4Uc9
	 IJk3M09dsIS/Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 07/11] rust: xarray: add entry API
From: Tamir Duberstein <tamird@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Daniel Gomez <da.gomez@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260604-xarray-entry-send-v4-7-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-7-965f6028790e@kernel.org>
Date: Fri, 05 Jun 2026 11:15:13 -0400
Message-Id: <178067251358.96312.14084909265600226392.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1561; i=tamird@kernel.org;
 h=from:subject:message-id; bh=7/3ohZokdRnzNHERRuARU9gC+/joNlb5cQbAU87A21U=;
 b=owGbwMvMwCV2wYdPVfy60HTG02pJDFlKL4Rm/hKLfv/7K9/3JRPuCcz43miydGfSD8WUR3c9Y
 tZIaO2d3jGRhUGMi8FSTJElUfTQ3vTU23tkM98dh5nDygQyRFqkgQEIWBj4chPzSo10jPRMtQ31
 DI10DHSMGbg4BWCqt0YwMnyoO/WwwrRhi4XutHdVopqKfLW/VK0nZNZ8YHii4j1r3UqGP9xhU/5
 7Gpzc7xQZmu5w7jHzfdsjvH6bV2xvOG7FZ93KxwcA
X-Developer-Key: i=tamird@kernel.org; a=openpgp;
 fpr=5A6714204D41EC844C50273C19D6FF6092365380
X-Rspamd-Queue-Id: 670404001D
X-Rspam-User: 
X-Stat-Signature: a7376rh1wxstkmoprdq5qqfj4o7xejyu
X-Rspamd-Server: rspam09
X-HE-Tag: 1780672544-39650
X-HE-Meta: U2FsdGVkX1/o5SodGG1PXdTGgg3RMMD5fgDg1BvNE5omBMiNeSAJd8NN99Rg7/wG5hOLPaBLkrzbh45b0BcXH6WsRBrfel0HYrpGeMwcmz6CerK93EU/+QQ9zx8DuHCg4set4OEjJR28hWmimIAufsEVqha2RFXqzx/P0BZTV8s19vDgFGRBo2wor0SHJE7bL1vWdADhGpChfDHviT3WWRq1+EzD2ihuAdkNEjJ/P238WzCitXDPjJfk7dhRIWEMp6kLH1o/VCLr4kCIs7+aoW01Evqqzs0l4zhIJFha4J6VS9thh7kuoRa39dQX3rBSzjSOkamhgBxIUb/2gGPdi8D1CAnYiD/SBMAKG/Pijli7tnI6xw3VeZF7sMtprdj2nIh8KRh5NaRuzyyaAkJrRzLjb3/8FSVaI10gFsz3ZPyawFiyOnmuzXNGUxKsUt59wiDNdnQqBwNmgsfh3Ta8uAqf8nEE44CGFfz1tEc4OfwlD8+Qlt7//al1kY7XmTO9ISuA9gCAzRjR8eb3OtqQGlQz9pPhIPoxHBRTtd1/SogfONtCcP3e8vjLYC78birGXWet5YBJMVnast7WXJiT3Ra5PCRgAFMwyWkRAZSCML1tCYHkahNby3SXpeKXt1rfAFpOhOCoaADCsPg+91gWtpiTLrfyh8ZsqFjS37iXZw9057QYqvulTbWUHs1WmAI5vqz5eIZqKMVWDFVZvt5TnMqlfz7S8xCsQfDR3hkV01OgMD9IDtdY6CUrgfz6KQcJVLj1UnZ+Oj1OU+koRyNPXqiSz31OwSnh+ALXlIBZUbrXH/l5eVrpjMv7NUW6nRvbLu38YtVSn+djBgUt+rEq2r9MJIPOjf0BaHAxy8+nxIfmANwNQoHmQKXAeHOy+46+oDSzKs6/iVLJU5DtVF7Dj4mFTqmxsI95Bl7vrCY6K6C845Z+QprqKvWgdh75lOC8FRnsFzMvKLVgWjoTL/G
 VikfuXrP
 dsRoDCNc21tGVyO+2FB/LhNGPkFehS5qcxvjTDpB2rQ2FU300zUNQnzBCmyYLsLJgWTFyWrGVVs7v+hvfiFPePeYiTCrJ2cSOxYQi23ExGgJuKImgAJx99PXgidXgpEyR1PQNG6Bl138HdJaKKrBNb/FX7vAid4CJZAMeJtGeNm9kbhZPRjDTdtVYBJV2uCC/I6+0SPdCzXV8afvm9LOTGppJrFYn4fQ5/2Y5/Xrym14luorVtNCsx663v8rIHZmPTmuJr/44x+z4mqumQaeCy29eu07b6ME414wN0Tjhmlm1CJPnPuvw3gLba8dgup2UYe2i/bWSAwqVAamlHg+mtd4i8GRks2eRWETYB5NkZg3zeSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 21:58:13 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
> Add an Entry API for XArray that provides ergonomic access to array
> slots that may be vacant or occupied. The API follows the pattern of
> Rust's standard library HashMap entry API, allowing efficient
> conditional insertion and modification of entries.

There's a lot more API here than this lets on.
`find_next_entry{,_circular}`, `Entry::is_occupied`, `into_guard`,
`insert{,_entry}` (do we need both?), `index`, `OccupiedEntry::swap`,
`Deref{,Mut}`.

It's not clear that all this API is needed, and this message does not
attempt to justify it. It is also inconsistent with the split in patches
3 and 4.

>
>
> diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
> index 08979b304341..19fce6862c78 100644
> --- a/rust/helpers/xarray.c
> +++ b/rust/helpers/xarray.c
> @@ -26,3 +26,20 @@ __rust_helper void rust_helper_xa_unlock(struct xarray *xa)
>  {
>  	return xa_unlock(xa);
>  }
> +
> +void *rust_helper_xas_result(struct xa_state *xas, void *curr)
> +{
> +	if (xa_err(xas->xa_node))
> +		curr = xas->xa_node;
> +	return curr;
> +}
> +
> +void *rust_helper_xa_zero_to_null(void *entry)
> +{
> +	return xa_is_zero(entry) ? NULL : entry;
> +}

These functions already exist in C, but are `static inline` in xarray.c.
Can we move them to the header instead of duplicating them here please?
That is what I did in 79ada2ae ("xarray: extract helper from
__xa_{insert,cmpxchg}").

-- 
Tamir Duberstein <tamird@kernel.org>

