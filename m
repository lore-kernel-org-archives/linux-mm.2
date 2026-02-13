Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B784DEE36A0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 09:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117236B0005; Fri, 13 Feb 2026 04:56:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4E96B0089; Fri, 13 Feb 2026 04:56:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F056D6B008A; Fri, 13 Feb 2026 04:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC17F6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:56:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7620413AD7A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:56:08 +0000 (UTC)
X-FDA: 84438977616.06.BCEC9F2
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9510140003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:56:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=EMjZHhzh;
	spf=none (imf26.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770976566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDYDTByfCr5sjcIDyB46vkL24aZkVlCApIFEkRWzZM8=;
	b=rZAQNa/UJDC0v2b5z6HsAaaEeWcCYWvCjLVFurxuZzSVGBm7SF1+kv3efq7F82DdJuySSH
	Zx6DDlAicwshVgtzm0iws5shkNA8QUBCUO6F5ym5lMJXN6r1ViUjhMg/P4PIsaiJiLu+MG
	9Db+e4gLKLVrnZ0rF+V1xEWWA26X0zs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=EMjZHhzh;
	spf=none (imf26.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770976566; a=rsa-sha256;
	cv=none;
	b=LELOZRWs1oENSPDJyzdI3pjFxluLKHTUOboX71HOul2ELI1Kr2Wo1Y/dO0DdCcSBe9MjKS
	kmuyyDZqUP3pzzihYwuoTBmJ4oaA6r3r0ZEJsfHFN8UJCEv/uLIGpVqCid0gUnUG7Bm0n7
	QosZtrNzn08iigW7tCll4upaI2dgMQg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oDYDTByfCr5sjcIDyB46vkL24aZkVlCApIFEkRWzZM8=; b=EMjZHhzhGxvSC5Yf0Q7yLcApZw
	Y+VETKQiyLWLMxF0u7OXabgg9DIcIyYfpTErH1Gi0PFJG9v8EgtWtFUZKTByjh4PiO4u3dv0KPrvI
	+E9sGLu5dEEZD8EmCAKf5kWZ4VisQnLiR0F0j4+JeuhNxauTBPXDILaqTIM8qlOOmLmVrufK1Dh7g
	ChcPiRPd/EU3cHUXLWNpL58ujSNCWcDnswzRfbtaaPefAAnfK1/KQa1Z9lf8au6A0VrdP7qaw23sW
	AfnxeyeM0Mm6C/J0FflXHqDE05mL2UrJ//AFJkPJjXIdh2VM+z8WZpylomLkF+L0y+XzdA4GovrGF
	nrkY017Q==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqpu2-0000000C2c5-429V;
	Fri, 13 Feb 2026 09:55:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 44FD33007B5; Fri, 13 Feb 2026 10:55:57 +0100 (CET)
Date: Fri, 13 Feb 2026 10:55:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 3wmjudu56b978otgs4gkxpehd8n1rgi6
X-Rspamd-Queue-Id: B9510140003
X-Rspam-User: 
X-HE-Tag: 1770976565-975409
X-HE-Meta: U2FsdGVkX1/M9iSSmo7qgdUuqfdlTrkGJ9wuBqjFxdfdRFrXZW2IZKNNd9LynLMPA5Z4CnNtvcNhIeLsxt3cPz2ceWp6M9TgchSybzq0u2OHeTViIqcdB575IDSb8O/HvbMyayCUhAlssCnYZmEupFuK24y8d7fZP/LRkh0VOVQeZMicubgVG/SJYFqL4kw6vJkj+cnJepVfZ4dhcQDKlkePm5RwIk9w5S17NpC0r62R8qBYOlZT6/QqJGdFufRL9C9R4WJCPDDQ/pb6YXlPQrww80Xgt08FeL+DYGYIticZBuobK4hThGQqil1Zi8DGvfq5sQe2Dhu9+/Ny7pOwuVvI/Cnvq/q3Lh1K7FojtaKDzFdT6urRqvAU5jLDdx669C2c/ZfuLXlpzj/I81TLLMq/XVgzH+o4nvZOo3yup5XluRQX41W5H08Nu3yWGMpSWzI92ImJjpZZxkPCpQYPGR9KFBAH4sohMbtLySUvF4A8xFxqpHPJ8xWKyKdwdS0YqzyxlKSpxg+QdFoM3h6gwUTVIuEcHzzHv8sPq5IBnV0zKDxM06EUPcfctSJdFYRZxAshNjdQo6Dm+OKD1DdVGgzTtG99LPrbbiHoNfRtF1asC0Qowd0w7bn0yunul8f4QZgHUAAlTYNdtYG+6jWBrfxBhUmn6SAa/Umu9sFnIKnsqzPl+5Zs2hReaAAiC8+5ceC8UP15RooUmSiMdBOtF18gbwHrzcomt0+1lDDjL/RjFz6yf7Hiq6qQsaswOz0GGy7VAIweriXeQxSDJC02GZyZisZmG97aw1bmInpNsVivaejd0foZtDqzJWseiRvGwa7OBvJJ/82VtM0z/05NtdKf2MjmN5NLBdKCEes6SbCoJmKEJI3ZqJbOlP3AiE+PhhW9DKyycPenqp5scoTuAzK+J0IkDUwKMhgsgzMbn5fBrKSkIuLEsF4F583LWVcoG3vGhk5k2FDexkRkgWU
 oXGJ6WYo
 eKD4HSX8KKcpm3eqf3ROLrgGKKHqyAQwNK/445LkNtHrC5ZboU37rWIIr1b7vYTSNNPEGjtCnPwCgTmjc4M/P0HeV9nGX0VdHfaY3LwPopm6BwCcA5RWm1rlBONgoJWyj2oitbZ8M2f0hMBVLPzNl3JcoP2QI+I5qJyNnwxiqXrgTxVxk4GgLh3ZfKNgWmVlHdwUU4tdfBOhSdka9ZJGuhCGWh7psIRNSOvxol9qEP+G1rcTCFzN+08S+hsPTnDvljVzELw6vIC++4w4AI5OfqRALVwWp0sUGO1/gnvK2V7R5387+6VBSqE+KmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
> When copying data from buffers that are mapped to user space, it is
> impossible to guarantee absence of concurrent memory operations on those
> buffers. Copying data to/from `Page` from/to these buffers would be
> undefined behavior if no special considerations are made.
> 
> Add methods on `Page` to read and write the contents using byte-wise atomic
> operations.

I'm completely failing to understand. What!?

There is no such thing as an 'atomic' byte load, nor does it help one
whit against concurrent modification of the memory you're copying.



