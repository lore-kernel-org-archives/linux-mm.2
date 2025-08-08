Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDB6C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AF96B007B; Fri,  8 Aug 2025 04:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712EE6B0088; Fri,  8 Aug 2025 04:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F516B0089; Fri,  8 Aug 2025 04:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5614C6B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:35:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F6CD117B57
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:35:40 +0000 (UTC)
X-FDA: 83752931640.04.9349538
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8083C40003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:35:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vsxtTfsz;
	spf=pass (imf04.hostedemail.com: domain of 32LaVaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32LaVaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754642138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/R1bV19pK3qvSZa+wMMUXQzKmczCiuKCY7TytXZ0iqc=;
	b=VV2NTlFVG8gycyzBviM6EPaTpcn3cc4xSDlTfoEpqHR8e4kkFv0kRcZj+9qrwCkvautQX/
	/9Kz7h6EogJdOwVqoVCdreBURGE7+9T/eZtI0wBzizB/RVQ1yeGlpWBLVUedAoIGfc72W1
	xznphMjnSSa8p64HWqLB3KZumIa5I48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754642138; a=rsa-sha256;
	cv=none;
	b=MVZo1U/sPp5RTHMIvKx254YlwsZHc/+4pXoI/o7ck1vl4dHEp0WbkW5NQojyWnXAlmbgjb
	t6YlL1kbNyf6uA7zp/rlzkeffZkDJFYRJ1Kc8U0on1eX+A70wMO4b4ZxQXhzlh4pxcXUfu
	CE3RnabVK6wF1InsiYxBG/K9CcTEPCg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vsxtTfsz;
	spf=pass (imf04.hostedemail.com: domain of 32LaVaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32LaVaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45526e19f43so6626945e9.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754642137; x=1755246937; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/R1bV19pK3qvSZa+wMMUXQzKmczCiuKCY7TytXZ0iqc=;
        b=vsxtTfsz5NPxJkoK743ciznEBc6W77/8yN5mOwGoPnkc3hSd58tDabIwQVJw6NL4tT
         JnOWxRq8zSbrLr6QxzK1LvvKM/AiiwugmwPx+XrdtEUWXkKoj15kFJ+lavBeYlbZ8yBM
         iz0I+ZcPdr1wXGS73O8+vg/tDbbpi/Jg4T28DmgK0hFXUBfNJ4O4zpTAGei3rFstXJ/X
         CtxSC59C2v2Q7ZYAvHi8q0BfhpwJqR8dkWa1Xa8Gsx3kdnsPe9iTBDJxkr3PIG9ia7Ui
         Os8MBPLXPzgN6HK2ih7Pz8NKxhGvDrWWAhhtXYzpy9xeErwq6+tAi5xcOOW4FNpqPgj4
         heMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754642137; x=1755246937;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/R1bV19pK3qvSZa+wMMUXQzKmczCiuKCY7TytXZ0iqc=;
        b=e1F2c6yAyXXdowApyv4yHQYzL4VRINyCxLehNfyub9S/WEyYBXAY1EgJMkGFnO36fK
         XjMvdoodMKEWH+ukfD/ztxVpXVwK9YyduI6e3bGVmsE3iIF34aRjK/l8gFI3hzmtZkPl
         XRKi8O9k31/K+ha/6tZE6ooZOq9UTDv6JFyrh3kmF2LOPrAwhUWmpkfokKSCppwrPdFw
         c23yAzfc82zdQzZwKf+QESdgnOHwbVh4GE/eRuhfO+quZ9Bcq0DVz85KxHimLAQW74cK
         QtxLTidKES7LSj3holQttxfHFtlgCJVhOpveG5AhhCACd0Llr3RMIiwXkrOIK43xsFy1
         /ejQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpeDBVnXZOs3cXrZqg3F3zf0g0fqJYVbdqboA0DpW5FRdOxyFjCpBoXKP4R9v/7pasOXvQzpMTCQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9l3d2X7r/hs+J6KXmrJZxeFHGW+EYwkn7T0LT4LxX1HVMw4I4
	84jPydj0BShQHIAj+V85oYoYR1C5oqwpbnoeiWjnaF+81Vuo4kgo0JaKVK8YTQqHd3DRvtKDYGc
	AJN8KsJpSf8hRqc3Fsg==
X-Google-Smtp-Source: AGHT+IGKioo4/mPR0GvMMcSDoArJNfBPaVCcGranqSUlVsAF0ZD3fGdgTPzyNQOZ/mXV9Qs7yu/HmncxP2+dbew=
X-Received: from wmjq13.prod.google.com ([2002:a7b:ce8d:0:b0:459:dcca:571e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19cb:b0:459:d3d0:6507 with SMTP id 5b1f17b1804b1-459f4f519ebmr16137435e9.32.1754642136722;
 Fri, 08 Aug 2025 01:35:36 -0700 (PDT)
Date: Fri, 8 Aug 2025 08:35:34 +0000
In-Reply-To: <jfqpnx7iatu5q3tnzwhuv6cav5y2444jyyjxnia3py6bqfb3bl@ijqc35utzpwk>
Mime-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-3-27a3da7cb8e5@google.com> <jfqpnx7iatu5q3tnzwhuv6cav5y2444jyyjxnia3py6bqfb3bl@ijqc35utzpwk>
Message-ID: <aJW21gy6HH0qUcAp@google.com>
Subject: Re: [PATCH 3/3] rust: maple_tree: add MapleTreeAlloc
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8083C40003
X-Stat-Signature: xua895634sz45pd9aiyd4kbk1odzd3z1
X-Rspam-User: 
X-HE-Tag: 1754642138-536835
X-HE-Meta: U2FsdGVkX18a+6zPHkLr5zytDvyhPX2TaYxaDqxw5anGTbbRle09iVrflDMMFmRLz/8K16DFFmO8RFpt61ktT7BbN+dpRUyyXm3uQjusgp867Uk3kdWIXEY2UnE9S1b0p0CjdFHld/lB2iWZBaTH66XfmIJNQgIJnwA7poEsyKnrZVXOlpIegSUmKqk1JD4dqCrO+L282LotjbLQNXY7bggzOjdn8AI7NKeU1dV8ZBXKxQho9mlQbZ/3X026Aw/AEMnWN/16zKHH+3iNNvhjL4f0XXxaj/TOtCeAYuOTtxlGaIPCW/jAK0uUoJg50x0Y6YsOHlkPadIyIdMka6AbYSByeY1tWGvdeWRK/Vodn/M/02y+hle2xl9LBrOtFfObqoLiGimssa3DZNE0MQQMca0odxifd/90O8t/DiWL9RpXil/npWLHTHTDDX+sfrM/TqfA2zfZxx0c1qdiqsewVRyf7y+I1VZNu2CgBlhFRA2eMW3yhl+7uCZZslDWszLZWpFh0H5UGSlAvKtk7KAlRT6RNgkorHFuc+oEo5Z4D/4SRJ5a0GmDceoTCJ0hHvbEOhlCGbUKO/XBmy5NB/f8kE5zruJ3dEWUhhrUE9qX7WulaB5iDBEGEB715AouEsR1cZLnWrVOCOTczot+wrovxS2QiL8QtcqjwycvzbHUXkQVT6FS0Xzap3FS8Kax29tVXvabhXM/bY8BqqZMLckCImtooz43anrxBWtpeXJxNKIr/jM+jyK+GEjpPx1UZVE65q26SNLm2MX318SOyz4NkZzvQCOCSYvNCOIUcxDvlqckKavk0PK558BFbYe7blPazfclqXO1EvLUnfzgXZlsGPKcJ4YMeZ8XZ5+Da2nVch91HZPzXK7KYzp5woSRBFKBQY7PrhRr8KjuaEBnTZavoKixdVXJqTmf5pdaWgxYXwqmZkH2TA4dn+wlntaJdXD+tqz0Rd7nTlRfsPtAgzO
 tYw8pXGU
 bj1lpNlN+l2VDp1dFKranq/3E3WRClReDXQM10WlNWr3iHdL+wAsPOskwHoxjLJrPXMoMeuUEAsgk3k7hC4vup8BEa/svTxSxga4KF3u/6nSTDzhUbWj6BjiGLxpHeL/qsm+JpNoySFYBc17XhP3O/E0/HrrplLI4u7/YYRQcQ32YkAgdPgqg2mSXEwpGjBa2jMKCHn0qVCoPcW7KgxzAyi970tzIhXHkCfEU39PWv47hIcqGlBVTwZPFDdDmLg9UDQtgHI+CA4+FqQsaJy4EgH5G3ncSruhtVzqmPa8el8XqrxisXKoFagvSwdfW3QITN7/Uh8VHk4dyA37up66LWTaNtPE4WBifDhsERXHd/ySYy6YE1mhRb5meAsjvVkyT+5evmNii7iamKFWY4FmOO/ujy6QS8Vj24xvxgFmUynsomg+9iJge4mIuKukEaJGLoaYMBlOEjPmUbFbk+tzBOYXVyLZQEcY0FIf8GuaIIZyOjHcBsEKoPU4mm+b8HlK1GIH7Vix9YgidOLHYYUSrcS37YBZrbkJjGuFs/kOTw3ASnNOvizXgdsHn3xHxU6KSsX+NPi15EXP9tvf2EdKU1aTo84ZPIBujQrrSR8wyc09yCcrC1ANxjDsB3VeGEr/yAkuLrKC8O67yzPbnDuMpbZP08eSaMrk+5EMl3QKaqfbwG/ogT1Sb2uUXLGlrluUF5OBXGRVPl1zRti5FVO+RSzgqVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 12:29:19PM -0400, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [250726 09:23]:
> > To support allocation trees, we introduce a new type MapleTreeAlloc for
> > the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To ensure
> > that you can only call mtree_alloc_range on an allocation tree, we
> > restrict thta method to the new MapleTreeAlloc type. However, all
> Typo here  ^
> 
> > methods on MapleTree remain accessible to MapleTreeAlloc as allocation
> > trees can use the other methods without issues.
> 
> I guess this is for some rust side error translation because the C side
> already returns the error?

Already returns what error?

The API here makes it so that it fails to compile when you call
alloc_range on a tree that isn't an allocation tree. That's why there is
a separate type.

Alice

