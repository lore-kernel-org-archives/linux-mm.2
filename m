Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917BDEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043746B0088; Mon,  2 Mar 2026 12:18:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C5D6B0089; Mon,  2 Mar 2026 12:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08206B008A; Mon,  2 Mar 2026 12:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CECD76B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:18:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B0941B6FEA
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:18:39 +0000 (UTC)
X-FDA: 84501782358.30.3D9B515
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id A429DC0010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:18:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z2WUpdj0;
	spf=pass (imf28.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmjyFqn2IXkUrXbwMN6/szcLPp+gfk/WNKWPoNt3xHc=;
	b=F5+gSGqgLlJrHxGye04bUjY6YGNWbHspe4WV1bd+tRYUNU5+iJ6ukvx3ipUJCTG2p1Czo4
	RutOzyfIvDUW66Un7t9u+qyqn6vdUH13ebxWYibpSCoom7/BPGfbIOIl3J2UnpTg/d/rnp
	W3Xb1TRD7VPxW/ZHhSklEYDVD6rWWLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772471917; a=rsa-sha256;
	cv=none;
	b=F4terdlk5VdcVB5QVeUXtaqxnAH26B3ngcIH3eW7eH52l5Bk4N9VqvMXXXPGvZtURHFiYb
	1z+6iexufia0w7g7lXUetQYhtXEmQW+ILKSPD/6Nliacr0/j+IgNIimsFmYvtSKHPwZNbm
	3L8RJKNWNWOzLNqI0hZELPa4lIzHok4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z2WUpdj0;
	spf=pass (imf28.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ae49120e97so105955ad.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772471916; x=1773076716; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gmjyFqn2IXkUrXbwMN6/szcLPp+gfk/WNKWPoNt3xHc=;
        b=z2WUpdj0M45VibCPAPWzwW/MUytd/hHe7t3xqn16f8nsghkVR25cWPsC9MXAPuHniT
         uP4ZzvhPU43FVCVN7WtoKmKixkyGy+QcXOrTxboLt+zbKECLymqE0/KenEjzPHBKVWva
         06Uo1qafUHYkWMR/fcnReOvTQ4+cwq45qcyMtcID1evmBeB3CtmGHWfPJGlgp9e2ECWT
         f982NZiJELJ16QUeCGgl4uKDXH85UTXlu8B2I9PCC/DaGRPrQU+y4Bd1LEl1r7yqE4sn
         rPV5UC5bNNvjaB3gl43uYAiFoFFfQaEvsbwEWXjNDzOTcmFxqoFvlJiIyD1gj1tD7U+H
         vVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772471916; x=1773076716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmjyFqn2IXkUrXbwMN6/szcLPp+gfk/WNKWPoNt3xHc=;
        b=tW9/nMele20P6SzO0pszZNs45jX0Cw3yLqWnTq2inmSgsoIcrWFZxgCs58aNVPGtLj
         BuIxP9yF9oQuJF0TrYvv+Dhsyx7S2i37FbE4pBVlsEFOA/h/9Io84WOMqAk1PqcoiBGH
         MN+0jCHw4O/ixeeMT4tbsv5g0yfQaLd0GArHdrNzbLsf9ASrqj22E1Uny7lLiTWPLJOQ
         0eHqILHJDDzAnJOkcYRKAC0g0II/yaujADBallb1rXfE+OW4y0MKUazBr2eD0RXfXWgx
         6zIJRTY9Jlco/SHCwTE2ZF9h1bVebysKdU/p7fuFUgVCECv50+1L3sr+8MAOuKHCA50Y
         ZKAg==
X-Forwarded-Encrypted: i=1; AJvYcCUSv0GeZGxraFlqPVw87XQlf4npoFgU0r8RrApC3Kw/3C8sG9xY197RcxoQ6lnF85Ok/MwovaR93w==@kvack.org
X-Gm-Message-State: AOJu0YzGUaIdT12oAuY9tk1+bvSOuI0VG4gnDjfpr5a4c5bT3/Y6S8Jf
	P6hnv59U5WgmUqP1xdU7aCwwNHiYWS3NEI8ySJibK5AiUsqHBH4Mq4MU/B3ArMmH+UMJ10z8gah
	kSxfJuw==
X-Gm-Gg: ATEYQzw1J5+HIBjBlFrYgjvYjAS70Q+42hL22pRYchWSVxA6FK9vJYb9iHn9x1FjAQ7
	FPf/TeF4tnNJGlMReNeXTPt+9zpJiLmCAp6SXyih+FV364dZfwZRUft8nl84tD8IMmwFPsyG0yE
	pfTw4XNSkpjT72ADXXddTk3sB7r7YCDAwNsqQtNQWbq/+HYmwGpcpBkNMtePcL7zeVawg0J1pC1
	Wy+4qXnrNH434O2v+SAn0mw78g7tYwCzMLDPTphYpdrZSonKVdTWC9CzjMlN5h5DQ3A0PYIDJhF
	729d9punZnY5BhgYdgTUqPLBq+l+OuzLYwuWLBodUAUNr0UA/ru2rFQ1X0fHb/Jfu9hNsGlENNr
	8qG3VQKDLKu7gbdEBy68w2a36YG+35MvGNevwZ4v8LuSW9tem6cKmcTB7iognaxap0bxTT9ikPj
	FZl3Yl2mSusRu3yGh3OHQ5R7by6/oWPn3adZBAC3oWQ/VLDmdpjVzu3DEPuoQHqe4Uremqtb8S
X-Received: by 2002:a17:903:2d1:b0:2aa:d5fd:5d76 with SMTP id d9443c01a7336-2ae3b3868d1mr2934195ad.1.1772471915887;
        Mon, 02 Mar 2026 09:18:35 -0800 (PST)
Received: from google.com (154.52.125.34.bc.googleusercontent.com. [34.125.52.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae4802645bsm55239085ad.12.2026.03.02.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:18:35 -0800 (PST)
Date: Mon, 2 Mar 2026 17:18:30 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jann Horn <jannh@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Message-ID: <aaXGZlfAmk-DCuBW@google.com>
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
 <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
X-Stat-Signature: pnqumrsec6qmunap6ngs3gb63j3t8qu8
X-Rspam-User: 
X-Rspamd-Queue-Id: A429DC0010
X-Rspamd-Server: rspam12
X-HE-Tag: 1772471917-813842
X-HE-Meta: U2FsdGVkX18S526mXXp1YzAFarxZmOYReJYQgQ7RnxcqKJRg1qD5hEl4tdXriaC/n40B664mIHe5Trt61hVQghVCCqIoyg0qT1f7frASaFP8fMkkdotoDRITrTWLwvmbONtlmfUmMJVbccX+b2KXPx9raUieIHUtE2C0BvMk2BHuRFY5DONg0nImCx/ITfiUTxu9DuhuHh7nvXcqk8gSiMokIasN8BGh4+oKA7TwGAgVZMKuU6ekTtAgPN1VgDSs+UIqxqR6oNJ8VhW+wuqXelbtQVfOo6H8TdXoqPsgLF0jFClgg5Nb6fElHX6fGFZ3+dt5ezmWsNACvlNfsFmD/xvbhsRfWh95/YYTR74YczUOQYeKplYZtc7PLhlbHWyPBmsYG2p0h804sKRST7QG3uSliX9zUZyQi+vEnTUXruPEKV8ivz10N6qxUOL1NJ3johUCo9r80c+pt9VmeopSNM+D3ybZQBRacXcknYF1qENFDFc3lOtQLrV8OPAYStG2Vy/Pcv4rqXa1vVCvCLrPcu+qwIgOqbUMO6cYv9FVhHmtMeqqpeP/Zem9or3zbrxvIiRFhWJHiflkkUwxH4EvjyZCW6bpCg2he2ETP/AyCbjCRm0GTX4JcQQ1Dgqvdl+cVulhcjGoUYpGpW01Miq+fEqWUmlSmukXkuj//coPpCvlCzTYxREM9OUHPG1UIkc10Tky9J1QU/wO/H6ZWvi+J+/adR1btloPs3RuyiA/UeS+6JhE29+zZVpeV9XkMFOg6355ItzCFZ+l8ecgL6oY0TNZhx99qaZ5+hzQ665RCRx1+KskxWjsyeZEfPccU8PI4BG73QMeLwDHNCCdV4C+W3KuSrqhXg2HTYKkV77bSwL6R/xO4eRjMmSP2134kbESnsM2aqt8azPLGMyo+TJZ/n++BUetk1ODGXZVkIjw/5kW/6778GpbMb8WKw+1sjXbz6FEBHBbBT8M7E7/i2S
 n0Dz3pz5
 UvsexD7MItIEG9efefSLmqMMKeWLBueP5MjvP6p3fl5Tn8EHyfjeu9AXtu2e3LDKDMl4Q7AayJLuQZd7t9OvHyTMEbjm4yD1BnLQnGii5GUR6qQg/r9ecSD3icrvzA2zeEeNp4ZeYtym7Sw+19BNS1TuM73Kt5Nzepfc+W7zvjZU3NQWCBDWDEWZUR9539T4LNCffHWT9IySIGb/RZ3JTbKMwEO01AQ5GHdaXToiE74BwWQV+s5bM2JstCslvgCN1n399SAI6hqagrJqxozxVAPwSg8bhuTyfpbZ6JzKxwR5WmYd8o5hgJq0d7gUfV5ycQAw81FoQsIUB15wQzeYOB3e92wKXYNHIM6yLKlRBzXVVrMT1grLl/tGStI4+nphsyzq702yI4CePZYWcuEGlQr5SM+rDjDIPLBgL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 11:53:26AM +0000, Alice Ryhl wrote:
> When installing missing pages (or zapping them), Rust Binder will look
> up the vma in the mm by address, and then call vm_insert_page (or
> zap_page_range_single). However, if the vma is closed and replaced with
> a different vma at the same address, this can lead to Rust Binder
> installing pages into the wrong vma.
> 
> By installing the page into a writable vma, it becomes possible to write
> to your own binder pages, which are normally read-only. Although you're
> not supposed to be able to write to those pages, the intent behind the
> design of Rust Binder is that even if you get that ability, it should not
> lead to anything bad. Unfortunately, due to another bug, that is not the
> case.

This all makes sense to me. What I'm missing though is why not reject
VM_WRITE mappings all together? Is there a downside or something that
prevents us from setting this check?

--
Carlos Llamas

