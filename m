Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8267ACA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 16:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DD26B008A; Mon, 28 Sep 2026 12:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE456B008C; Mon, 28 Sep 2026 12:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6036B0092; Mon, 28 Sep 2026 12:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23E2C6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:56:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E4E71A0288
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:56:31 +0000 (UTC)
X-FDA: 85263774582.04.23CCF6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9147140008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:56:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PlxyqhuN;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790614589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdMdQ7xNoZT0JPAPrDLZpRnRksX8EJod56eBhYE2+9E=;
	b=LdtxBkTieuxP9vU4XpGiea3BQb0KZ7Zh2ypOqywUjFf82shrW24wHzB6Heykh4B1N01gQc
	jasNacJwLG2EZJpZIeouys1+Qun7CX1nqt5qbYWrxdDgDBvnyH2SLzbGwcZ9TzGxFGV77f
	LLqIUbGx+j1IbOLQY9sDGQaK59v6Y7U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PlxyqhuN;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790614589;
	b=0VCN9Q4ei/Q2Dx3MyaD5HlzKWvs8CH3elP+adS+7rebfvHFrLYtUCTdZIazPew+3hc/77x
	VsLg1wE0i3Ee25W/smzQ8vBQZU0aMAxM/qEJenJCe6jT8nOpGdBW5tMVuA4NooF6TCooEz
	6dA4iw4EQ949Z6UP6EeXcjxM65fwkJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC00942E99;
	Mon, 28 Sep 2026 16:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CC61F000FF;
	Mon, 28 Sep 2026 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790614588;
	bh=qdMdQ7xNoZT0JPAPrDLZpRnRksX8EJod56eBhYE2+9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlxyqhuNqRl8HaNDmVdbT+HILDG54Fx6nLK9YGA8zHZwvvHeEUhVe1JQIGH8iTacq
	 8y5MEMW3W5MaIZPUOaXBuAOesY18jLR3zkhGNriuTfbwfyCl+PG+tvDJxx+YPjDyHs
	 wxGmmhsuinQi7MTzj6li8NyL9BFRWdAxmUC/DdvxJocRYPa8n9QMt0hthYAL4zFLDF
	 ctll5WnKHJNHpGpCACfOnf0NLGg9SZ+TI0ml/qJ+PLtJaACtH1HQa7C1zWEXhWPCOY
	 qs7b0qD7jhVRLBvlRCOa3eyuo4kKzFWahoMP/PIxbqj8dIuVrxrfFfL7gxMiNyvNCR
	 Wv63+0e0ws+mA==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	ojeda@kernel.org,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	daniel.almeida@collabora.com,
	tamird@kernel.org,
	acourbot@nvidia.com,
	work@onurozkan.dev,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [RFC PATCH 0/4] rust: damon: a first small step, plus a Rust prcl sample
Date: Mon, 28 Sep 2026 09:56:20 -0700
Message-ID: <20260928165621.18850-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b1774aea-aac7-4399-815e-19b830d883a9@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9147140008
X-Stat-Signature: xshg3io4eti59xp18shjdo4qzngu1z65
X-Rspam-User: 
X-HE-Tag: 1790614589-663555
X-HE-Meta: U2FsdGVkX18EUYSO4kERREAQProuS+jnCF2lMGWidYAz7Z+bmx+b0QzmG1w7x6wdRDsFqo8hcLRO1a7kR11hpv+lFPoSU57hKUJwYg2tlH15Tiq6xmDR3YfTfY9Dh54AlYgrZUVabWlrbUJe58VHHOrBsDMjmPPfA40bSO6ixFcVDT0bDRIOjJ6WFhtxXeor19p1ce5WVzu0P9/P/z3e5i4L0oFKimaJIclkwyS4NGnzXUWnKXfuJ9zJf4yNGkI4XyrdgFhF+tCd5vcyCMmXUXvAQqFLxr7kcc8acSTQkW628XJD/YyBg2iwAysAPo/AJc0k+kVcFKiaLTrf6bZBIFBenDVuFCo9LbD8VT1br9mSTPcNkoou+LrbyGAoCdqb5yiRrwS57nGe1gwd4ghvyTg6Jik2tTHuU0hBOpIJClyeYiGiFObyNZFAZbYxqtb4y0OCiIUJLpbppzOH2DdzXPOWw3E07darnwvRSwaHSDXdYosEDzy1NfMMhaUmD//W08/CuSmW95zvE8fNTqDHGi0yKEPbZ+lIbd/UdPQJUeh9oDgan5spyaoGoDr1+gjsnoVW+Drn+GzNZYVaP4jtViLxt4raSlfEh3S1gBjvTTUvWbAQnQpQASce2/ZmQVhYq3Ejzvx9NLVZ2ORe4KnSggfcr8ll5LVKIGfEldmr0S6RwI/Esysu7crbKbCRT1SXufSi3cGceRYpzoJXEn4eV/zMRDhR09F8cmxJwbhB3Yctv+I0vYo+Xb+nB7HEMXLMkUkznRV2blkQwJfl70GEXV/dsATd+NARXd2ksFiZw6RGP/PJ8VQAmGKt1TbYvoLRuxraP4KXNCMoqcxo3JEXNTxgFIwx2t3T1Oh8my9xa4LYdgq9TVTFgX9MLkphHcAOTb8aNK9bmXgf4B0QBMWWLx4EMPklOj4L8sduDEOKQZ5AB6FI12oFsSo+qLXhCbX8d/PJigmDaDFWar0ehwz
 IUsv2f7/
 iAYae5rVF6y0QBlrut9s2WcDHzzkNaMbze8FkjBh2S9ZR2kfRzZ/f1j7fmKlE65g1DtoZiQqMQblK9iERtPEWMjFWOPb4b85xaK1zIsAlB5hhvpdlqMJx2ci8vPgXFNWNJDh2UDkxlLCw7NwH8GGlUpzeEzckafMoJ5JIiQvmTLZsXqC0RFF88lCEK07tmvNb9u1V9QABHv28Z00vTK88SPt4Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 20:59:45 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ,
> 
> Thank you for the detailed reply.  Comments inline below.
> 
> On 9/27/26 18:07, SJ Park wrote:
[...]
> > I understand this patch series is a kind of experiment rather than for a real
> > use case that has a hard deadline.  If I'm not incorrect, I feel like this
> > might not be the best time to start the experiment.  Could we wait until
> > fundamental parts including module parameters support in Rust and ongoing DAMON
> > reconstruction, or my learning of Rust are done and stabilized?
> 
> Yes.  I will park the patches and restart once both are true:
> 
> 1. Rust supports writable/sysfs-backed module parameters.
> 2. the DAMON API reconstruction has settled enough that wrappers can
>    target the new interfaces directly.
> 
> Meanwhile I will keep working on DAMON in C as usual.

Thank you for accepting my humble suggestion, Enze.  If anybody has different
optinions, please feel free to weigh in, though.


Thanks,
SJ

[...]

