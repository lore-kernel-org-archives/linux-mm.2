Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC331CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA556B008C; Wed, 10 Jun 2026 05:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2246B0093; Wed, 10 Jun 2026 05:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7BC6B0095; Wed, 10 Jun 2026 05:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABCC6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:01:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C87181C31D8
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:01:00 +0000 (UTC)
X-FDA: 84863408280.07.30992FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 311B240002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:00:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UcMwQW8b;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781082059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xZH8EKC20wOL1zK8SrV71TOgTZvNK+Q2MCOpHnV0qk=;
	b=0l73Dkdc9RFedi1vTYl1taQ2gHBLj7Je4ClRkGC/7FFjBkPaGoVUAhRPk/iBj6+JLnruoD
	gQBkKQzjvlMKdmK/2xGF28cCKerLBpzkeymKyzE1w1P4qpBcqmFLFsrU4/prXNqoDthDK2
	FcKyCEVIQFV9+Z+femO9lnpTIfM+pbw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UcMwQW8b;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781082059;
	b=aIyvOKAMZfe3TFnuOci03J7KcyUfirij2Hqphr4EwamAZYMWEfuQeGm9pNPcDmspYMJ6WD
	h1boQjF/l8VgT6nFQE/jqAJghpiZHQcrmvwIogQ3BXI6ZHFuaaqyXuXZSRcsEWctSZ2p20
	UnRuLdmtmbiPtrqtLbHHVavPOkk60DA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C253F602D0;
	Wed, 10 Jun 2026 09:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCB11F00893;
	Wed, 10 Jun 2026 09:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781082058;
	bh=4xZH8EKC20wOL1zK8SrV71TOgTZvNK+Q2MCOpHnV0qk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UcMwQW8baf1BbQC8hY62Pe9fOuFUnJ+5pZl56Q8GGZ901VZZ7ed02AStcU9fGWSPK
	 RNZbKC3ojytfUijJoHkpOibsRZmdqGaZjlzHyIx1FqbZHuasb8+2IumKQAHzKqbrUC
	 1E2Ja++z70UtQYNDfXHluXf6YVky4NGxticx9hHKT2lA3NG+fFxJr8zHWCLCfgqSpW
	 8IljHP8oqDczRHMlienVePoW+DKWjNR2B8pmrgbIn9GOViM3ZohwRoHMRXHotvBPzI
	 mwi5yykONmqUrhu2qjxvzLeYw46n6hwiQGXVAIYRcJws7Dxu1wP2501nAwCA+ApuGF
	 aDGHfJiKr6ocg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Boqun
 Feng <boqun@kernel.org>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust: page: add `SafePage` for race-free page
 access
In-Reply-To: <aikJoacZW5JMEx74@google.com>
References: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org>
 <20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org>
 <yztg3fMt3nlpoB77WlDBGmKhdPr_eF3t9L_v3G6i6BFUxNZbti0dHS1WDhIQDulHmXZ-YxOcuKuL9Tkr9pRI5g==@protonmail.internalid>
 <aikJoacZW5JMEx74@google.com>
Date: Wed, 10 Jun 2026 10:48:53 +0200
Message-ID: <87a4t2hjbe.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 311B240002
X-Stat-Signature: i7wz1afwag86aein8eicqp3udr4jao8z
X-Rspam-User: 
X-HE-Tag: 1781082059-241128
X-HE-Meta: U2FsdGVkX19D9cG6Df6qHy8aonnu1VsJOQpkvQvMCEb9Rqr5PfPjo4/56GEvlW3cZ4dKq8zRePAEzW+iu3GkzLbbGHocXUyhkXXWABh6fXAt5WjK9d0R0yFGTT0XZkb7pf/OlHUl2Qr98GGH4S8KqGvgN1bn29iJm7lcE94Qguq52usZHrMiAE6eM88J+uXRjYBRTr4sY3S/iUSb7z3WfZA1Nl6hxv2cB/gu/HE2jvBwse7s9lHc7MhmfOoET0skJpbWNHZdJ06coQYhlPXD/Qn2KGZPNtXkT72wpzm8jexDxxiPkEKphrmMQgFdakTzY76EwI/zPaljgSiPdaquj0b0bDYlbk42tBj+LBzXjH3EGEW/L5h00Q1AEAgBKHuJqzqje70yztEHj7tN8OR9voRgOSjtbcgMNvXiAJEbV/Dr/cXF794dNzJjf3DGAMSW6jNq0kjwxSJjp3845Usrm7/QoboD71pe80QVoNacEKMggWOFYSSBoquFG6co8HE+36qENkEXHI+BpA2jsT43pYSNo3uKqPoI3dxOczQRVeT3V42yC0cWsNnrx9iLn/gOw3rwdfcLxtMHnazOAWJmkJl+khaAZip3kdV2EWIx3Tf4iIUDJnvzNNC13+DCn4SFg2BOvyBlvWBZK3kx4h8RiAOmqOS3Ei609USgvfyWGT4w3ZJuiCJ0/8gnvVgHRAcYz1O9A1/wXhx6LfPdDTcBZrlpZnA8qUhtam/XW9kAvTGNBTWBUce2G3rvc2F88zhfIBb0MjLl+Ij9Q5rqfa6ylSEPjRYTcA9WPyr9LI8NjBaMwMk/3fzaAMe2Vl7cl+b18zP45G+dtyZNKGvO99r9wzYvB7hBCWJKA7BHIu2CuznEUV3Zbf1YuSPXLs/oUk3Pq1ROy/4vl6tAi5SgOHKGxD/E64Jt5kCJUiLnCuztCr8AodWOfTzX3mQAr/1HBHEz0C9pDPThRmPR+bBeoGB
 ymKdS9Oe
 b1agICtU7k4ibgwxpJz2jdcMA9vfnJomvIgQ9KAu+oD7DFWdsATJfGfiAgdj8M/wCOSX5akclyLSI9eloN+yTAsjVj8h5v2ldA/2QpEqb0lvOU0VLOFXL8+KTbXgnp1sym+IHr/B4OKrMiU/hZwVsmZnwPkvTFIzQvB7yupAPBNX8glwQ9K0SMa7z3+HmVkphaDHwDyd++zBQP+bZ20xFT2QhE+4pS55K3hVQi8b+GDeUH0XY7ZgBQWKQs7JzAuFch9ei7HcShS/dw0tm52apC5q8h+B+qjUhyNxy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Fri, Jun 05, 2026 at 02:49:14PM +0200, Andreas Hindborg wrote:
>> `SafePage` wraps a regular page but adds an invariant that the page data
>> area does not incur data races. This means `SafePage` cannot be mapped to
>> user space or shared with devices, and it becomes simpler to directly
>> reference the contents of the page.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Perhaps it should be called ExclusivePage?

Yes, let's do that.

Best regards,
Andreas Hindborg



