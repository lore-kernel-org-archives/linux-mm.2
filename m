Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6036E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE006B0088; Wed, 18 Feb 2026 05:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB7A6B0089; Wed, 18 Feb 2026 05:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8516B008A; Wed, 18 Feb 2026 05:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECDB56B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:20:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A23C658F6D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:20:52 +0000 (UTC)
X-FDA: 84457183944.09.E6F0729
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5CB0100002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:20:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="l/2zQYX+";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771410051; a=rsa-sha256;
	cv=none;
	b=KR0DsEqzOrX1bR7FJe9x9Va0vnJ6EHDHpMYdW/Qbc7Wyhj2SMol6rLCucwxvtYinyh//Ef
	htmr7DRgvH0eH459KBtLGk8YhjN72FCfMtRJyyOg1xALG4+ebuHrKR7I5rbfCx4rdSkOji
	D9tiz0jiNxZMLcz4L9Q6YrM3h8FGMLs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="l/2zQYX+";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771410051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Mvt7uGvnB+vId/or2IkyiRiQBX7EgdHITq/A1Okw/0=;
	b=ucZAJkfIrYMLQEPX31j1vqhVbKW3WElBb2W6//ks6zCRqXY53nMYkZwg3mYhPWC2xWbitN
	WCx5IwdK83aw7/Gcy/jV3l2hGaFIG8d1b+sxzA3UbeG9lW7x2AwdelDKIbP0qVfYnkNWSz
	Im69LY6Elo0Jdf4DwG5ea9XQI0lSA5s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3Mvt7uGvnB+vId/or2IkyiRiQBX7EgdHITq/A1Okw/0=; b=l/2zQYX+WjoCZHG1iHis9Rcgro
	0c0XPqszsE+bHq0QlHfg9CVjzY5RK4GSvUzTanAFlogh1bMWyLgBqLz59DyTNSKsxPCc+FNuJgpz0
	jbV0KvkdifSKzhZaIY529D5h5hhLjthcDi+lxJR2vOyXkAnkdOLbt5LdPOoghljkuZpicMsVqHcJK
	CtEKgBs/JGaJzX8beRVfzbgwMDZyg18+lew+G4aG7TEbzuQg9DxcS4nJqy7X8CmGJ4bJzbZgMxvPq
	VvCC/UhnHl8wWHHhuD+F39MTTLhwjqzaVF049a9NVkzrPfCkJCfPXi0rHt1KtYApXj14tAHz4twxN
	BE8XqRHQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsefn-0000000HFHM-0Lhz;
	Wed, 18 Feb 2026 10:20:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 952E03031D4; Wed, 18 Feb 2026 11:20:45 +0100 (CET)
Date: Wed, 18 Feb 2026 11:20:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260218102045.GD1282955@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aZRY9HthKwVJrAf1@google.com>
 <67aea464d25c8cafb3113eea62c8221b@garyguo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67aea464d25c8cafb3113eea62c8221b@garyguo.net>
X-Stat-Signature: 6qkaywjha3n7kbzhs8us9g6iwputiaig
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5CB0100002
X-HE-Tag: 1771410050-233250
X-HE-Meta: U2FsdGVkX19iAmUYnVb3phq2Y8ucPQS0SKymsOJ7PfT/J1j7LqHUiPo4BzlIlHHmTeQ6Yyo3eKpZnyStQZg14JzXJ0OZjOWTYNy0CSYVIEKI6Mcbqx59CSmOQm2NdhxwrBML68QlCkN8Fw5CGdIH16WCkpzWwdPGTuo9iP5Q45+bapfaNk8zK5COHmqXuH1ooH8UazUMkzXd1y8pzeL05Jic5RlU1s66MPJKAOo6oHBg5m65TBLuXJm1UH0mkVhYwY/0KTUhEMkeNbzlE6trzz0dvlU7DxlO/21rcy6GIJPy/asBIQxq70TY7wg9H/OKv6SjcdbTTWF+NykKfXPQJ0LIR+w8Yj7qJy146nTjsLcsvRzjWXXvh2zW1C6uPfxN007cubRTto2pkrB+Fxv9WMXgRxfp9QzfVYNgIjXxp7vGMvR/nrSZShyLA+1nELqxljth8KBkhmtYN+BAe9nP0Z52u86NNMN3rMnWL2yzMfW3mNbWi+7Y5BAdPfEC3D0HWIBFA4JVwfhjQziEihd8D60TO4CiRY3W3RoTqEHjysqxr8MT9245gMAmViJm58LADQ3+7oUFCfMbxzZvjf0ib1roO2xoD7Ox+G3V8u5uJ81/KhsoQc7t6pdyIpTRpAS6vAxLA1mTEM6syXKKG6oXXmZ3Vbbk/YCq+4Tsx65gMP4XlssYTD+8EivjNgW/Y86rQ1OUUDF/LQvesVKefItPKTleJa5UXNLUF1HHYXzPItX/mBxfbuP7z3pZ7MWG6o5rscrGB1X2C58yfuAfx/S+OoSmvF2VvSl+dWYTiRsLvVq4Hx/viM+nRv/+oeNUR7Q2Ui/VMtYAbWHV4rQ/XE0WX8gs+GAT109qEl1REyXYvrByW1Fz/Nn+l5x189mUrhgtftcfc4qYxoCoW/asFRIYBqAc7Djqfl5/FSV4Ds1SkL54X86xiYVWS7r6puBFsqu5J/kmTIdX+KAYyNlWTpg
 XeFzUZbT
 +stRG4iBqJWe4lFZJrC8DLhq1QjSwAUfK+dZk/KFF3BGFEgtmmlXXJvjzZsxV6uUDd/lhcxCYxcFYXiqtHrP11FaClitUNCaNPOZqrmw/xDzlduXS74FWgBbugmRKwB8ZuWTOSzRPRSBXieXIbYSyU2ADhKzmhFTCJPbXXtndzOqSmE/WeeJ9e3y3RivFonzvyf9IXyc0FoA5B4FT3gbogIEHspn6Jcb9yjPcwAJfiNvdoPSQqCAxblQhH9FGsbacn2klcE3h4tLuZBxr+4Dd3YSibsyOQb/s5qHn2iq1UQ1sezazYH3W7vut0qhqnOGZ4VuL35pfju0O76I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:10:15PM +0000, Gary Guo wrote:

> If we have this in stable, I think it's sufficient for LKMM. However
> for Rust/C11 MM says that volatile ops are not atomic and use them for
> concurrency is UB.
> 
> I recall in last Rust all hands the vibe at discussion is that it's
> desirable to define volatile as being byte-wise atomic, so if that
> actually happens, this would indeed be what we want (but I think
> semantics w.r.t. mixed-size atomics need to be figured out first).

I would strongly suggest for volatile to be single-copy 'atomic' for any
naturally aligned word sized access. This is what we have with
GCC/Clang.

If you pick anything else, you're explicitly creation interoperability
issues.

