Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA4FD78783
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171296B008C; Fri, 19 Dec 2025 10:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1022A6B0092; Fri, 19 Dec 2025 10:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0037D6B0093; Fri, 19 Dec 2025 10:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E60216B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:14:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70C121402A1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:14:40 +0000 (UTC)
X-FDA: 84236567520.07.C3B62CD
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 68DB014000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:14:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZmY9YTAu;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766157278; a=rsa-sha256;
	cv=none;
	b=72zUYwz8MzRaPeOeh7h9p/hQuMemJJSxcvyMGE7k7Nd6gG6gM5dytIdDX0N/AeBcPLXDYo
	ztrkUyDko8TiUjg6JZ3Z+pb05dg4ah1UTN8T+fRBtrodcT5gjRMs1gr7ianlQSngoUhlNR
	qDYSwHTTb2ifuuCLxkqRzQg7gC7xTTc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZmY9YTAu;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bu+2UhDyr8oNj3zxOVAf6TDIA6PfTPU1OUzVkwJ0dNE=;
	b=weUj7B8oQ+m9AVApCfpO9PPwzGxJ8dFe9RnA/RIN3FDP2N8Lls2ZTi/Cb6oIevO5HWWWa8
	BuKIXM2iKGLCaDj5svD5qtBjlkbGFpcXlc19nQ/Xer4wX8l5TWlJ/M4Gf6XJr2nl6z0lPe
	uWfOi6VUB9SsGdiMWCFOtEOqoS+1S5U=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88888c41a13so20595616d6.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1766157277; x=1766762077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bu+2UhDyr8oNj3zxOVAf6TDIA6PfTPU1OUzVkwJ0dNE=;
        b=ZmY9YTAuECzLPYcF8buyyLN5DAvHTbzVreHcZVPibjNZ02QsgekCa7CV++1oh7ENU7
         IN6lnUYSlOYskIuCkZWv/AdUOz2yHgOapRYxq5VQYCsEzxu9jQGWxcrozuaKphg5DKdw
         WGBB5I/o9QMwPmSoGBFkhT1uctY77JNcsYBpfIZwROajcUOo6ddBYB2Wks91+sDSX5Jo
         N2oTZdMdSvZOX1hL2l1M9KrpfmhfV1Pma5Ctl1zPjN8OCXOqb6c0jKCnPsGfWCuaZ4++
         yao8PuH3izWw+fBmA0njtcee57Sgti5h5ELwxs1wOdvyQ6N4S6KT8sQMgjBQlb6q3DMu
         iqcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766157277; x=1766762077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bu+2UhDyr8oNj3zxOVAf6TDIA6PfTPU1OUzVkwJ0dNE=;
        b=EM4SdTINunGLGlsm/MprQeYNjAndlwoaFwkce/q5MVkon26SFKeLBIgz17Hj3aH+DA
         fCIXMesWxsZityYsedLfmWiU9agxX83XYjTRcwYQHLUPL5rrkhgZtJwM8ZFQS/WFbEU0
         li471Is4vw/lBgmpjynrdSOI5e4GoE0ZKEAxjvUcYNwO4647HFK5VAf9hl/DLTeeFT7Q
         SR64R+59ORRCBmYm2EjbF8lfp4PUTZs/XG5ypQDFbCqc3+BHUmjhr7pfFWU60SvWpsjC
         THJguggT9pH6r8nrQ8E34ZW1hA8dPJhK+BhgBKi6mIOJXFvg9ZamD38w7PIR05GXb2/A
         q8dw==
X-Forwarded-Encrypted: i=1; AJvYcCU2vSDJBTa8L5TNTfUts/9NBZK+TP7ssG6uqOF5VHKlpwsgk/asPYwIrU1qtplOsBOu52Z7iXG/EQ==@kvack.org
X-Gm-Message-State: AOJu0Yyv+kZ7DtJm9tZODACOMpEvIwupaxHL+Jq0WYzm5IHvHcvXnyT7
	r2QmxXnD7DLPKEWMyY1NMqddbvAzQlKbqcHP90urUZMkYqjkN4EfsLe8i9dqTrwQeLg=
X-Gm-Gg: AY/fxX4hJw25ElhnHyLeLUIvCb0XQ3GEy2f2pxsJfDAcgdjgekrAZdyP0CCkiZtZBC+
	vqAASv7dUO1xz9E/mTpz/my5Qv6Vyojx3lxl5s3Cvy40SZo8FudUVa1YKkx3bmAv8TOU/SahRdP
	h6VW2dCIaC3EwJaU6iqAe0yA/0lRgDftrE2j7aaUq+ZhO+SPKdSWq50xQZMlMRQFvJnphStESqA
	Lx7wKipXwohx+u5uVdi7x0uADSpwyKVyDMTsgtIWC058sprpZ30ph1wio3NUKbQOmgor155uDVI
	jRZ6oVDEHo3wc2NRz5LbWufboKkZ3PPUoH49ovpw+k9M6NJnyvpgxZd/l9LR8qUtzZPJmKvcvWl
	+GNBQPUNoFgRLGMos8Ffsq6ZztYDWHARCP2xmj6jL/jKeSxGzD6FS8bIhDA39vy93jJjWCcDwH7
	9C6WgO8YWP9rEhenS11AleRkXnXxnKwdnL7w9Ft0HyftXvVZUNbnh7Ewpo
X-Google-Smtp-Source: AGHT+IFpccyEL+iZKcyKf39srRplzey4v4m0ObAaVXPx8Si8//BYqbNk1PZ+iX8dYDJiLgUevufXLQ==
X-Received: by 2002:a05:6214:23c6:b0:88a:261f:6af4 with SMTP id 6a1803df08f44-88d8404df6amr54276446d6.58.1766157277272;
        Fri, 19 Dec 2025 07:14:37 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623fd14sm20785516d6.8.2025.12.19.07.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:14:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vWcBe-00000001YYV-2m7p;
	Fri, 19 Dec 2025 11:14:34 -0400
Date: Fri, 19 Dec 2025 11:14:34 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
Message-ID: <20251219151434.GI31492@ziepe.ca>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
 <20251219140557.GH31492@ziepe.ca>
 <aUVje_QZvJ9rjedp@google.com>
 <20251219161153.420d1c46@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219161153.420d1c46@fedora>
X-Rspam-User: 
X-Rspamd-Queue-Id: 68DB014000E
X-Rspamd-Server: rspam04
X-Stat-Signature: ae1ibmwkzpyndyesoftykdoxmahjwygh
X-HE-Tag: 1766157278-551867
X-HE-Meta: U2FsdGVkX18KWPAN+IVeMT2WzIHPmUmqwrQ3w1+1u7HCrUFDE20l81lVjn177nmJxigfrXm0JG31x6G6onXelKeGof77oXgdF1lEGD9JMzDlxN7wySI0kyJA+UiZycY5lv23QWMnwD0jQSB/OIVFis/2icwM4K736VRbvjBB+6UI7VOb77Aspfokl5RU4eY6d97eEMGWzhfFluH/7o2ycsJdeWsO8lRxngI3W7DuSbzSbYkpEOS038JlLqQwXL1Xswo7JKshcCJriO22YlnUGMj0r3NphVuKJjCPzWtjm5SSjo273rQN/M+931weGmMfLKsxJvG6KIi5KmrQNpBhsM4LFYebHYZbDnKvoqLvfCpn3+kYlwAmpCgPpJAaG6/glqRCjtAAowe0+gW2X4m9T88g3Ehojpfm8x20yTpSBAX77mOHFFfzuPbHbMS6wGt12gsGn0ruaUfT+OOXKhvcvmlMRR7GPO2JZIUan9vhQDjkYRsLkAq58Lke6SJafICA7RiCvHbmMub4cj+8UcLw/SW4llfXeDi2jjMMKfBPnmLf1I75XH/PwoYQzXZUIFjLag6KF5JVCs+4n2IzId/fc2uVv0bNFmG1zIKZWkVSb4vNCagWDMwlD+lht5IhLDTDluIWLwlB+rYe2xu9PQwoWsIwqb7cIqfabM82Is3T7yIGYC09CCWoTk23QoZs0S7O4Q1K+wbHNC08hrLkCTzalg4fDwfRA5+DSLwAl2dyIvGg9b/1CaIGWQBsZqKJGp4k1tj/u/uJLFW8s5Mk1g8LgyU7BGkDMuNEpeY2C2+WDlKQrTOvcXCaazeEIazZnjY5eQZezRZaMXrknhV2eB4P906t2Raft/8FaCBYjrvC7Bly7hsMPxXxIFfWA4mPAcWBv66WU9551lj5cmBmteHSEPLzKCrbosnksLfJX74H4sknBXUuA/EZ8BzB3/kehjawYdUEYaean6kWh2eWkjI
 sd26PGpl
 ClB60thl20cEtfL7qKee24okqfT4ryMn22Heav88KLzYsJoj+jsU+25e5BOinv95+H2D411OMYHwDRyflYqzAWvEUpnYLFoisq/HpL7PlJpIQU9VoI8WELxEcHmLtdeGyMOvC+HgGviTtZAkd1cyA3b9iQjhL4oxkrc5hpUUPSltiN05E0Efszb31u43W33QyNVb8rimQBPLN4TjrIuYzvwlMo+VWuVT2A2XdtwbxmUUMKK3daKinwXgWdf49Bz3OYprE3ER6j/YQR75BMYmlpNHufXLQLQ5IWrrrsE2Vi4CQ8R8La0LZk3EnpGITESE7PzNhFoMjSy8JBhvQiyDV9qk3+YnK3KMTwiVx61m7hbFGP5i8AaVjZQPdTMea3i97qYKv6Qz2jMMXCyVX4waveB49WNBUO7r2/lzDVvA3hLqNZvLaxrY9BkeJMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 04:11:53PM +0100, Boris Brezillon wrote:

> There's actually a confusion between TLB invalidation and L1/L2 cache
> flush/invalidation. The things we can decide to flush/invalidate around
> map/unmap ops are L1/L2 caches. The TLB invalidate, we don't have
> direct control on: it happens as part of the LOCK+UNLOCK sequence, and
> no matter what you execute (map or unmap), you have to surround it with
> a LOCK/UNLOCK to provide support for atomic updates (GPU is blocked if
> anything accesses the locked range while an update is on-going).

That makes more sense, so these GPU drivers just flush the entire TLB
every time they change it - built into the UNLOCK operation?

Sounds slow, but is a reasonable explanation why they don't use the
callbacks.

Jason

