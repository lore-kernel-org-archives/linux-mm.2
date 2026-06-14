Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7B9CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420116B00AB; Sun, 14 Jun 2026 08:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6356B00AC; Sun, 14 Jun 2026 08:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C946B00AD; Sun, 14 Jun 2026 08:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB686B00AB
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:02:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3766164F21
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:41 +0000 (UTC)
X-FDA: 84878381322.16.EE3E39F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1CD9618000B
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgRL+DHG;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWSdtbQlJqxP48YULvGZFlse5tTUXxbf+XtbPMjiKPY=;
	b=sewpkyHrr+mg2KXOLWQBLI5IeDPfgOHhrCxmkEQR0j9ddvFF7/utaKD5QHYT2Arc4VoqmD
	m/ty4GUDomEBeH0NJqvclzC4k+OrhOB5xFxgbK2iGF8bGNP8uZuBvFI/iDFQ3hzBvhrczj
	qQhHQQTN82r+S7i6EJaZInJpLTVFOus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438560;
	b=ZnOa+W0cmyg+N3qKjuj+Kpkpp96HxolsFtf7V66wdObZZf0JzKXZX7Ith3ZkbfeeY/8QIy
	bdINK+6vC1CFcfjlwoj2FEWd4kDiKUMVTDqz3+BwDFsVSKaKZjy6B+98LiaHs/4RaxemZt
	JC5VJ/3Ynal513+gD4z8zJdruJlHYEQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgRL+DHG;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63AD06008A;
	Sun, 14 Jun 2026 12:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190C31F000E9;
	Sun, 14 Jun 2026 12:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438559;
	bh=GWSdtbQlJqxP48YULvGZFlse5tTUXxbf+XtbPMjiKPY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RgRL+DHG+pbx6FyKuwK64FgghxEPzcl5tUxL5BTUMlsHB0LchxHi1fxfSVJrW2SHH
	 GYZR02kBSzZjr5QDD9fIwz3Wi9RVXgytCPB3HF7t1+AC5aNRVRBMT8KxB/OuXo0eFK
	 /xmAhTC9vpOFf55oqpl5NLhtIQH01A1L+3FnGLzh2LfEA+m3s9fRLXNYSe8v1fG8Xz
	 wypsOwAUwy9fbfkWrbJfgKrwkQN7mQbWXavpSt5w0WfxgQGDq51Ggn6B3C1rvhtifW
	 Y/4m0rlF6IiJQNas4nmS+diqEc8H2xF6oCdqnPzxELGmYhE2Z6pf1anaHBR2GYyQj7
	 iB1cccqHPfdbA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/18] kho: make boot time huge page allocation work
 nicely with KHO
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855109.2123877.12981752740377469952.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1CD9618000B
X-Stat-Signature: enk6wq51rzz5wp9j3x85z9umif1q6ggc
X-HE-Tag: 1781438559-711366
X-HE-Meta: U2FsdGVkX19jUF+5QEi+ZL/rAE7adE0dSuHJRQCHjimBFvgve0mURB8xMl1OfbJFPo7DQlhz7nv3wAlpA9iPsr8l7vVgBoYuZnN31oLvMlt2gSqv8tf5yVKRMOkro3oVRqvGhQoDG+ZrNQxkavmowrBX6t262/LOCm/CtX3TNQoyDUtrh510WQ/W2rgZ0MTrcjZ3yWKFvS71FyAvisoI//DSuUz4on4ju6lOlX0Cp9ExWehSNMk5OLCBSLQ3WovKfmobWwgAw86gRWxNBuMWvpvVs73GID14Qz4YX4VS6mXmbwv9jlr5nXSje5BU7JD8qCSMXyaGFbXX12qv+p2ksmgdJ4LlxxrraAawpx/f1eQawhL/w+yfawYLc71vTeIZwtcAIPhVx1aUup/rZs3vntUE3XREmGtzS+QrLyPhFEpEimWDCN31bn2Cs8EbRt67sKWzghU7O0tCtUiCzHzVjsUSLkViIN0zFsU+k4TRepmWAwZyKVI1BnSfkZDXuBz6msMdGHqtUg6Klz5ZuSztssDLYPj2NfwrEvqZgH6jIF4e47QVopxrSAP3MmDcL98CyQ4Iyyjg6IMie+XoKd2axdO9pF0EYJi60gvVXePnIa2one63jodUzD2AMp6UHA3EAgpV5SkDsBfIeC64tuLgSvU6hx61x3HOOeAED7iGTU4U0Gw9JjBdVgrPRiYgPSz/iSnb41mHtlXA76IOeMRYMYjEEPNJVyVxX9KKZcDwsgJokWpRmY0ASiPBkxzYcUKsNs4fmbbonwiwJzWvTI7rhgI44dzScEopgeOlsrUFA2B1k0vpZpza2qleRlohM01cAfOxPZB0gTvmSgvcntlujOudoXGJdNtgVJwX2IFznSAx/B2YFhC9Ln0jiYdjTvYx3Tn88lsO5b3sWA14dwrlqufxXhKNfWBJZYz1zJnUfU/iKYUNVzrWraWAQdhjnCg7peZ/sbORArmQHSbKGQj
 HyQ8t2+h
 LwgqArdJhWPYswsgbwL6nEbezF/jIWTFJYEaxL/IBRwGIQUJp0nr34zLXw/Bf9za0WqP+oRd9/l3QJmzlvYEJSBibc47Dkd/4N3WoTmkOr0t/z4vHawLlEOup0syP8tMTfqDKMq8GzSFv7BcCK4zSLskuAyNKm2nqM1Qb3xOjXvRbPJo9v14L0kAQEwaz0yBwA5d6URA30/3xf4OU8LZ1SaKga9HJwUUPqxuh/hHzduE0i7yAVhfgk687Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:33 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:

Hi,

> [...]
> allocated from scratch, they will fail to be preserved with the upcoming
> hugetlb preservation series [0].
> 
> Fix this by introducing the concept of extended scratch areas. They are
> areas that the kernel discovers on boot by walking the radix tree and
> finding free memory ranges. See patch 10 for more details.

Overlall LGTM.

I have some small comments here and there for now as I din't get into
all the details yet.

-- 
Sincerely yours,
Mike.


