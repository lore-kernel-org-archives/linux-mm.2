Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C38CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC528E00D2; Tue, 26 Aug 2025 08:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3F78E00A8; Tue, 26 Aug 2025 08:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11228E00D2; Tue, 26 Aug 2025 08:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEDA68E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:45:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5435F140782
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:45:08 +0000 (UTC)
X-FDA: 83818878696.25.CC73A76
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CE2A100007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:45:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=io1hjCgY;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2JcBs+CganwEkX4OprqHJ8amoc/Ho1q+lauapGtfgE=;
	b=gY95KOjCjX9Y5DBQNgOnV/2GOzRAYvIPkeCvgKVfSMy8+F1x6q20x/t5pd8TZACzuB3r/r
	1fM2ULz9e5t71TZ6WiEiIjaT0tC8XkeIxHjv9D4vMqi7XjNhgKF8pXpphbp2eCtHD8oLNv
	vTzWxUNR3jXVrwKS5WCAtuFmjNB+TpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212306; a=rsa-sha256;
	cv=none;
	b=JHVSZJhaqm1VYBbkfA8QhAYB7ucrZ1CL7VOEgtigyNvJpLUJPWByZxbItmAMage7NnEY9J
	ANDcyQfwxwVnjs1RRh61QJM5NQB07K+MBWrM+UVhAlQpCiQwMKhYW/EdTM/BWKCOU1yntM
	jAUclRnjLbG1Wr4M9bpNtvKk1oqLyv4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=io1hjCgY;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a286135c8so33291835e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756212304; x=1756817104; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G2JcBs+CganwEkX4OprqHJ8amoc/Ho1q+lauapGtfgE=;
        b=io1hjCgYY29eI8IX2uMmfR2yLv8OekvuqjZQF2GICzsgwaWkYcBROgk1K9PXEhz3Vr
         eNfDLqaDJjsPC172wZLe7X9SCDkpiFENlmZjRzMYpd3eRHwySWjfCflXaKxSnJKLS21L
         pFucWbXHj9a9YZQb3cOPFG8QUJrP/ITWehjIWIhQjeNm1PsM8e9aBLG1Vmvll3rJXa5U
         aHa7oBRWQD0/1WZlTghbQbL4EcmL6ggPSwlQkvXk/mJNTRjrbpB7C2FpjLxnqt1LqR1m
         Zpm8T/Ja/IJzsQa05aZVQXkgaBZIAV9Kv27oQbq6kWwPBID9BO64GfJ3TKqENStmKFYh
         si1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212304; x=1756817104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2JcBs+CganwEkX4OprqHJ8amoc/Ho1q+lauapGtfgE=;
        b=TUIaIT2ZWSDZBntWgnTtySEqZf9X5m5KGC54TaYhtAbU9fwUyRsunmemLJgB5e1kH3
         pK4ugUcZ81t7Ih3P7UYgtaL+XxskA9ZYjOpCr5UwKy4hqpJC4mF27fpF9dGTKe7qwlv4
         LkYWXDORAgFWpnMlJZjNydgLY3BHzp5COL/SFjfVLe2SrSSPD9KvNWUOKSYPaPQWaRTU
         /gaPHIHDiFdvXzdDp+mVDYbDiKGqX5g9P8MTrqq/TJ1ZwFLcrNBBnJFRl8agmGLCAISq
         vu4x73227S6m8wotbG+A2O3q1hpVyvUf4f2YHeOdGdhSzKweszpXBvG/5eawMNrIf6ut
         QvOA==
X-Forwarded-Encrypted: i=1; AJvYcCUuzjpt83aCNrm1U7gE/2WM3hz60fjacOLT9hYrba2IeXymhOPkhUVx21abGvcbkkMA6PkNcYmqkA==@kvack.org
X-Gm-Message-State: AOJu0YzM4/RgtPSDLdYq5xTaZUpTF+4MKBUR2kWSsAb5d0G6VjPRFm9O
	CJcGAeOtDEAtkapXCRRTOZ8XDjgZwm7QVqk3Wq+Ho6hvvcFRF9B5/Kp7ICvspuT5H0U=
X-Gm-Gg: ASbGncsl3OEVlTnVAy8W4JXaXQn7WLOcyJdmVvZqWBiCSgkbMqudE8hAhPASBHEORhR
	9xeR9pKtinyZPDTXCHFK+Jq3nZryBwvRIx1457M/kiAOKGsUS3v+vzgqJJlRgrj06A1qrTbwjc6
	MnZ9kmTqS2nMXSoXMQGgt+vTCbCkKNRqBXK18q32BneLckWQEvSV0xfgmOp9IdUwWTNkLDN8nMj
	aaJvp4OeKy5w2nFfMjb/HWm8ryqcRReuC7+45hKEMYoP5vXvt0RD1fgcaCfNxeFUsmmJCxkWsEU
	UcFOm/jtW1xKTMGiYOEYDAyBuJIzt9ym+eHzyZDRju4jApgdOhi5PZZUCSwDdzhDorUEeusH4UA
	l5MdS
X-Google-Smtp-Source: AGHT+IFW3ZA3OI4upIPp4NoeCf9FPmFZqJS7Agu5/RUEZiautDlaOmJQu85kPRquLo9rwsyVAOkzbQ==
X-Received: by 2002:a05:600c:c0d9:b0:459:dbc2:201e with SMTP id 5b1f17b1804b1-45b6870dda4mr7526655e9.9.1756212304089;
        Tue, 26 Aug 2025 05:45:04 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:a584])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c70b634943sm15982302f8f.0.2025.08.26.05.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 05:45:03 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:44:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
Message-ID: <20250826124454.GA1502@cmpxchg.org>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250823130420.867133-1-vitaly.wool@konsulko.se>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CE2A100007
X-Stat-Signature: 93xpps7g6mbsytu46rfki758xik6jdfh
X-HE-Tag: 1756212305-566991
X-HE-Meta: U2FsdGVkX19+chGYT3z+7alZrB8xXjRtxFPOsC4e1sFKl6LkCmI4eQlTdgVGdaEePkMm++4wL978KJn2CM4Re/MCyVuuIBfJ1cn0Fb2SN+Oo39c6uv5t7nxyT//n+fwEXipfcXT4Sf3oVRSr6Z5EDigwyYNz/zaiOxq7SbqHXxfmpJGsPKlR3aw1FY1ba5cSuoGYbNWizqWtFCVqchNb3ds2nXKbZP91K52qZ6fRIFjtsJEWGjflcYI37JPPfRu0NXH9Yg28FjM39fyQ8wEHrwPNVFOm341J/v1qEvBZPaxsAoXRK67gxbtdyGURbzgn9T3usuWrBRBB/GAvgt4sPUMFnwT9QAjb9U6XZZAK3psL9Ijh9QtOF29QnJ/zIgTaaNW+QwP+9hm0/Ym4VbCtJ+MnHC56EfEDB7hb8tF2J2XUi99NrY9pY9G/zLITIFI1gLCE9I8ocO3euzLXyRDM0l4HLY1Mt7THJtWh0jSz1v7z7ibT+06GMxiCghQr+FQDDlbB2bYWt4VZBNiJPUPCP+oST5mn4t5glnNp7HXr60gaJUM0YkvbMRsKbV3F4aNHgv01BuXD5WpF/5f9INX0WHzH+dR4DzxhwZ3kc8x8KdXrLidj5YcTcOlTTKomSUBSZ//OhfCS9QtrSzYJhRxmwRMmXgOM65xhzQOYRqPwdHsOLrjbEGwMf6ievIad2Qor+Gnp8NkZuxlMQn4d8bZnUAoFooxlh6kC4Nhe3T4fvvfamYHln39oVPUmuBGuWGlhOBbeMoOfZRJqvL7V00pG6+g2E7Ftg1CQ9IXTzcpRiz5e8qBVp6lB8sICv9PWDFqVX9OW/wN6tXFtuvEx0fZ2coeTmDNou+48CQAaFrCY+9B5SMZlZAnGmk8s+3SAEPF2MQ6xG9o8E+igivyjYlo6vSReClNQNpuvL39/b6mcNqpdV/N+83pNQGO3av+xUml1VMSXdzSMqipW5XzEEw2
 S1RUE8Pi
 y0u2cCGf7S/6r7AFJ40Pbtb9rm/De6z0Qh/dFgnG4xjTmWwL7cevh9+PCCp1uJcseezmfsg+3Nj6YwGtcup9oKYdYkKUeS4QZvCzULprbg/uxF36MLLQcDzyumqjTHQaDazsd5lDVZeFpoj8fDJbZg28q3NziXxczTa1TfOH+gvORiN7mUM2XjAfqJeSBYBxbtzvqEkEZ4N/sfd4CIs4V6qosOvFDoXW2QktcAcCYqIrhlS5pnHBpQyPwr+EiHA5WqCL4Hi9F1qoaDQJWRWlTb0YMAaAXmrG39OOth48V137rIgHPnSqC2bKjDZuCxka8v+MkbFjfD9n3tKjCLsRT9u6BZg+PIHPJ1eb52fOcSvS3FhylPWwIVS0TVsak2FDW17JI/d4vmO/zaM//F9V8X9TKPKbLN1RJ4yJlH5aRB7TGTSee9BP3y7qIdeKTnU0EL3NS/+EkrotbJ2NG2m5Et+rju90EJxDfRZRYu88x8zYleOtFIgZ8HcP4XG6j8T6qbrBW/dwKOtkFCAw+txsv5z7tzZUiAh9DH37yVIZvH8BAAelFJTsbYjjWx/pDC34yIrUc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 03:04:19PM +0200, Vitaly Wool wrote:
> Zpool is a common frontend for memory storage pool implementations.
> These pools are typically used to store compressed memory objects,
> e. g. for Zswap, the lightweight compressed cache for swap pages.
> 
> This patch provides the interface to use Zpool in Rust kernel code,
> thus enabling Rust implementations of Zpool allocators for Zswap.

The zpool indirection is on its way out.

When you submitted an alternate allocator backend recently, the
resounding feedback from the zswap maintainers was that improvements
should happen to zsmalloc incrementally. It is a lot of code and has a
lot of features that go beyond allocation strategy. We do not want to
fork it and fragment this space again with niche, incomplete backends.

It's frustrating that you not only ignored this, but then went ahead
and made other people invest their time and effort into this as well.

