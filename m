Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CA9C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3B38E0068; Thu, 24 Jul 2025 05:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3888E0051; Thu, 24 Jul 2025 05:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893A38E0068; Thu, 24 Jul 2025 05:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77DBB8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:27:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47456B85F2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:27:21 +0000 (UTC)
X-FDA: 83698629882.26.E229BEB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E7544000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:27:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZZvEN+aC;
	spf=pass (imf27.hostedemail.com: domain of 3dvyBaAkKCMEhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3dvyBaAkKCMEhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsrwKI3F7bGxyMyCeBsCzUls3NPftVxNs1GB3kxRYJM=;
	b=FpfWLNTBqpOeenuHMjYhsimrkrLvbHsq1CCHhwnmutRWMiwv2w6r3SO5MgoaFwtClku2Br
	AFQ5CXfx+k9b0QHIxjt7cgQ5kcRpRmP/BeGVo5dBqhtdWpP5mFZil5YYqBxkh62rR6byb4
	hkzLvqb7mYV+WupxpAauMpfgIkl3X+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349239; a=rsa-sha256;
	cv=none;
	b=FG5fsYHhT/V4YhxXKYN2mhJR7vB1SaWHifVfDNswWwA3x/HgaTRI1g5yazpFCsB9PZKB1L
	40mP3yVm9hF+STGDYAfOicW8hct+bg4arB+qvFOxZ/Y/XmUseaYTYoWbNww6l1Q+vwMRcu
	YRc2zTK1cfJ15Ap4vwy9Og1jP0jVRIM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZZvEN+aC;
	spf=pass (imf27.hostedemail.com: domain of 3dvyBaAkKCMEhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3dvyBaAkKCMEhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso5577105e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753349238; x=1753954038; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsrwKI3F7bGxyMyCeBsCzUls3NPftVxNs1GB3kxRYJM=;
        b=ZZvEN+aCcRR75r38oK4I9LCfrumjZSc5pQ5sZGr0Fdd4PvFs24WjK3bmHTIaEX9YL5
         pTjgLJqudGOypkkN29Qn/P3+oKK1nY0XaBSsHbep3FEN05vCvgW43GtJ/qeUXbrczuzb
         QSxY4OMpk1+B4v4YzY4n4tyLj2BkKBetKxs8Uw7MEil5DsLgVu86rwKX36fMnPsAGun1
         njUvemhSn18129JYafU+OSo2xhQKZAA+hFSqTCbo+RP7b90GRT5ZYXn/bD1vp+SB69jm
         dJkRYs/qNQpWFVVOhRadIHO2q/4PIDvggBQHQCyS/i+kLG3IH7goUmExDbI804U5GO6R
         zI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349238; x=1753954038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsrwKI3F7bGxyMyCeBsCzUls3NPftVxNs1GB3kxRYJM=;
        b=nA+6WGq3gKASTa9PLVIGRVkaDub2wZQ9lob3Y8hBsYCZp+Cab4GAneKwvaI7lecNIt
         9HpNRIeBfrD/fdxiUzj+61ZTJ9X1j+2bDkJbMy9blJvP7UeH9AJsrptvcqcCLvaKzXHd
         cNYSDd08MEAxF9fMZC4rnmTytd4nkHTzcq1WnI1usiIZFc+ttwF2aGK9ZEEfYaoP8fIy
         2O+JsW1zSiTmEdQy1HOEHh/H1DZ0SSskXHyYjHVeCKUxNTjVuYsT6U6au+5WO878cJgj
         ict7s6klfZQRoO06rwOdP8zYdx1Ds4n4bPahdSi9vHXWMsKnvWO8eiGH+UVy84mJus0e
         I1Jg==
X-Gm-Message-State: AOJu0YwBj+RoGflLlEobwUCrzMlnh8fR/Ojl1CiOtVRqZX7IEibe4Nfy
	h+KUNv6xsxQjExVKMMMaVmM9XQ2lOVh/dAl41GcxsuESmHtV+bMyao6hF8PjyAqm8qFJdw2S7QY
	NGTSbP6mn3Z0Qd2g59Q==
X-Google-Smtp-Source: AGHT+IELtTR5XvjXT9CI/JkCboBp8PAzgWTU7RN+Nu/d1GBEMVnbisQm+epTaSt63SxD8yXeLjeB/JQjltpOZIg=
X-Received: from wmbay36.prod.google.com ([2002:a05:600c:1e24:b0:456:1ccb:7fbc])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4022:b0:3a4:d6ed:8e2e with SMTP id ffacd0b85a97d-3b768efff13mr4278297f8f.41.1753349238077;
 Thu, 24 Jul 2025 02:27:18 -0700 (PDT)
Date: Thu, 24 Jul 2025 09:27:17 +0000
In-Reply-To: <20250715135845.2230333-1-vitaly.wool@konsulko.se>
Mime-Version: 1.0
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se> <20250715135845.2230333-1-vitaly.wool@konsulko.se>
Message-ID: <aIH8dULJCe4FUd8I@google.com>
Subject: Re: [PATCH v13 4/4] rust: support large alignments in allocations
From: Alice Ryhl <aliceryhl@google.com>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, rust-for-linux@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7E7544000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5gk617kefqfeqfecos8up633chiuqhd5
X-HE-Tag: 1753349239-111268
X-HE-Meta: U2FsdGVkX1+6Olj8zLMZokekoHy+dntEPFXhJEZI1psVKuyqNtq2u9LDOcNWNQJ3pQ00LJyA3u5bxo0/oXr20bEZ3XEmZPfiR0msWwm6kYFKmj326fthlzfuT2Y2dq3rjMnvuRQ4WqCMuOy9paM4eQgY+DrdVmgcZGxcCXtzgeg9KVqWq7upLW6O3ChFKhXrwx0DaTuljI5JMnFPLNDtEfvX9piyXrMXff3gqO4xe5SefcKdmxFqMqdw4sZpcnKpDUrmTrR6iVCGlpjpf1rwCaovTRXnHs1uCujr4CE2y6IeAxa1cpMSLv26S/4gr0vZ0hZyrSln/86SOH40hKN7QTVPRtH76GaTmkSta3S5btZJ2PdZl9Q2JBTK1ZU8W70REYqDu5EnWBE/+PhWI928ZnGtMZemQYgBE+BpDlg/UC/QVRyxXaMYNwEQFJD76c6In0YwzQBCkpjHIpdchQMD7cP8pXJibVkfkZenQYqcauJBXhenwWMipgyhgTKeSj8JCnEEWIO5c1Ukwj2JdAHG7IjrlMOGBbfVijStHfamvisvJ9ehRAXv9XzZdnxPt2JKrwm9J96V6lOCmhBzmSdbSKIIetMJrVNGcHKb1f7A7njuJNpvYzCSbyKarAjn+Cv/iY3EaQPDM20m0giPnyPTkpuBdqulyMQ4TBuQodTKcIfBRFAX1GOVPjH/k4dogKrORW0RVGO9eexXEcLf0wTY8klPvDyq8G6+mT1krQlfgZZ3ovVzbWY+9mupwoY9TcEYXikZ7Fo/x/3foh+2umvQLCTZOxGGoWkoSeDu+R61U1rzeZ+z21QrGdZToROv2be5k11tweZnVVuVnqkwP++lQIorPWc6rrPRHF+biq1L+Nmi+zJhN3CWMibq4X12ThegX2fFe86YiprpJggTnsiUurCNnrUO0soe+/5t7jZN5QL+cF5/aBAx6CF1fONG8VGdMc4/JDk2aax1uDcW0B4
 gLwx+QyZ
 CW3fSayPYKrHui3K+OsNFC3LZHIOkZrw75qShrhtT4k2A8mjF0B9MRjtdu8BhaD/ZRwQz5XSkqZy429xbf6RCgvrdHYPBtmdJ0UciZKy9gMFBCU9N8DuWwL6qvVp3k9DGa9gGIfa8NMSmH/ixr+n8JLuS8eBhRAQ1E3PQnHgUDHgehQ8thjIx2oJx7swAEeXrdJ1Tq2JVlYOOnFKTE2zyCFiiQMjXaTbEPFdifzy4b3bFC05APP7QKbIkJjtDuXJOpZQPIRezEiTp2EzFpeDMa+TFAg8CtGXvedVE6Vy6e2MN9oitlkv3FO1naaDtqRr6SdwefCYzuAMlyWgF8KLzwmqIFQGqtPKRy40nSoCmPzEmEKL86TV8W/mI2aK8aTZlwzs0Avt46jDzAmhNrxvZtUKAGVQvpToPrbt1I95492ANnZSy/AccSuuWRSkRr690mrsD8MwoU7PQYAe0jO1X7DSl0O3SDbS4LLPtt2OLq3Y/OvAPW2Wl0z5mAwjr2M+C6lCFLjMUDO5tN0/C+yWUy8geC5hlV+/L4DmOdPygz/4JPlU/RQXX2E2mIq0rWwxs7Acy0KB7vD5enDp7mgsK+Eal4mGrkXk28HAaScD0bFRJBtfuE9a+J51sbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 15, 2025 at 03:58:45PM +0200, Vitaly Wool wrote:
> Add support for large (> PAGE_SIZE) alignments in Rust allocators.
> All the preparations on the C side are already done, we just need
> to add bindings for <alloc>_node_align() functions and start
> using those.
> 
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> Acked-by: Danilo Krummrich <dakr@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>

