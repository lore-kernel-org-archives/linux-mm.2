Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7BCF46445
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD7B6B00C3; Mon, 16 Mar 2026 06:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45ABC6B00C5; Mon, 16 Mar 2026 06:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CF86B00C6; Mon, 16 Mar 2026 06:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21D466B00C3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:38:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A51F91A019D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:38:29 +0000 (UTC)
X-FDA: 84551577138.28.7A13745
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id E03A4100005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:38:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CygSPxUe;
	spf=pass (imf14.hostedemail.com: domain of 3ot23aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ot23aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SXYFbMaZyd4uq2jz5cd/WSU7rtMrzbFvz22tvMMpB8=;
	b=CK2sZC64huOhVoEq/XtPc2PZ3y0EB6j+tPmFWFAgvpoxWlkah0QGXHmO+pUq3FLmfdG292
	Eg6+9qd89vdp8I+Sv0ePt0yZW5uq2TGdtAqF3XlQRlwGCqbKP4YEGSKXe+W08IIuaKfzSs
	sgiPrHys2G+A2cGq07tJYHwgmaskweI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CygSPxUe;
	spf=pass (imf14.hostedemail.com: domain of 3ot23aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ot23aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657508; a=rsa-sha256;
	cv=none;
	b=SX4OIgaXLeLDaI238GNnPDlrRZ3XBahWnrbGoKehmrNt3JvkT7EbdcoEwj9pHQXfvfcCWm
	UFDYJFAvOUEjZW404pvS+CR09Z8VE6q9i2s4tIRdwvbS2eqjyuEoZ0huTemUEiH7gpnV0e
	IfSQ0g3Hy4dsMrDrTzdZvGHdNbbEv5U=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48534941525so61765075e9.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657506; x=1774262306; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SXYFbMaZyd4uq2jz5cd/WSU7rtMrzbFvz22tvMMpB8=;
        b=CygSPxUep7xvAqdZ+lEmio+JPjs+TkZpq89rBFQGd/OMQVXVcvRaCiI/KbZNXWARTq
         zsYJ7ezGdB99Hso6LWpjAHw1CHuYX4ahCsjcBejbLCQOnrGKMvAvbHp2A+vlyuXd1Vzi
         P3R35AA2SvEcoxCGjsCuD65s6HuFIJ0nemRvuW4xy6c/MzJy1ITtawyaoAPBxpjh5b2Q
         AnzOe3kw0tpoUk9WzipmHWLhczKPpTplOcZ3+mYamXf/fmpiphk0xu7LkJjRAoq6ggsM
         meWKwJrAef6/ZO9PnzaN2keh1irbNABVehI0ihTXp+bVtHMLA7EQfOifjatpMs2vcyuW
         /XAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657506; x=1774262306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SXYFbMaZyd4uq2jz5cd/WSU7rtMrzbFvz22tvMMpB8=;
        b=WMAAKEyJwNugcbyQluUFDqIvXPDu2SxFo9pFFfvJeqQZfgcqiZ/sEtOZrYDfZK9olT
         xXKKvMDDyzweXfoQNN7IwPdCqos21UqsmogzTqvTkCg3XYuFa9g9LG2nHxDddSLxsdmI
         mOMlPeQQQm3GClL92cURPzSkT/6ETVoKQzRsRYSPZy/uSHsRCyfOKUoQcEuSa/VfeA8F
         MRC2S/hEoAxl3qU3veJSiT2qas8jWwxcMLntHoESOAWGV/HhyBXFWa3T5bufOLbBD1fV
         wdWU7lkptrwThxFA4cQCEvSn/89HCM4sV20+ZCwZw3NQ/PP4B8gcEWzPBNRwOi+Gc6o/
         6gYA==
X-Forwarded-Encrypted: i=1; AJvYcCWpG0sCUcFbdANwdLFgSWr18syFd4sFcjB07HBl+uvZCtCF4YlkM3j6ykxf4zzfNDDIuQIgfmFngA==@kvack.org
X-Gm-Message-State: AOJu0YwusFoaDOI/1p3G8rWQD7MA+VllAl+a8chOzOdPvrKocfFbYQa/
	RQSuiTV7+Xl6AQ9C4ZcwVlNJRSrENr0Yf2Pqc4esKeTq+kroZZVz9+VnnP1CWfFIqfv4Rnp/Qkc
	ymUIGWQ2zy6h2YWZ05Q==
X-Received: from wmco2.prod.google.com ([2002:a05:600c:a302:b0:485:3b4c:3e34])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a39e:b0:485:3ca4:4ef4 with SMTP id 5b1f17b1804b1-485566d6ffdmr140263405e9.9.1773657506198;
 Mon, 16 Mar 2026 03:38:26 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:38:25 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-13-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-13-de9a7af4b469@kernel.org>
Message-ID: <abfdofUwfh---inT@google.com>
Subject: Re: [PATCH 13/79] block: rnull: add memory backing
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: ac9n6k6sqmtcj8n1ngrb8jeofh9ntns5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E03A4100005
X-HE-Tag: 1773657507-169005
X-HE-Meta: U2FsdGVkX1/viP0q1suQ0jtWSRGWC76ITuOsyV4OrLWtAgP8mFI6l+EtRYeHx/J9w2H3FZLq2ygFPZrDFJq1NuL9kIBuwTL9Vh85Y1uknfSF2o+yBaoopyhI0K2ACMqxcppPdyJLFwDhVkK86cyz4oYr64HpAZVEupAK2FHE09592mvmQaXatBJw67SmX6JlAPIjft52TqXcbgE2H4GtOI1ovILnWm2c0eiwHPXnuwn5BjzSOrsjN9CFWfpXTz4FmUjrTibYI5xdaMF54AqFU5yeDrcuzh8hkk7xrf7czNymYeqfuNC4eO+6Gizy7gv1LKUWf7IkMysveRQG/onyUBg3s8ZOVg75rqpI2G5U9PrOJ6mJMfDZZaOiful6SFcx1pKIGQOnM/pts5F+AECjpXfrIwtd8C7+FQQ/e6z+g6MGXWv3RWhTpzpJaZjWb5+0UTvp5zZ/JweYNO4z38SE4pghTUJfeoZnsc4EKA6wi9N1q63H+G30LXm8bSJgNk2nkMWb0RZacHcn2cThHvauNWmFAkZKQD6kOcpu3MqBzDsAK8YBvSbjhpEaav+DBjlPNTYmzdR414QIA2ebEIFQfLqP5e819L1kTtXsWjkbc+7zZgG7YSZd5w9fXtVC+nnJrFkUqbN5dS/XGaz5W8v/AO2WrcNuGzwXmw12M/AChg+j5Hz0u5rYbHhtFRupeEZuxw2JpIHck/OXoSEkW+eLgzx9UgZGrCdr29eOhmn8sYcnD6vrrul0A6ynvuXKphzsrkY0tOmMwlmkZxzjBWSj06k2i4hVdqWW3T+SiRu5z5YjMQEE+ITEau+lg3DwjR92hMdPcx3rYYdXjQvnILzouLEHLU+E3dZoSJECM9b/HWHKXgfnHM4d+4LG8FYJPyb0mBSbHpVE+VqhFEhZ4+u7dAcLlR5JYImUyAfMHRWPd3JpJ13ga/X3jEDQCTWmvWJENL3j093piG8Lvw7N2BE
 gEvX2RhJ
 8Fm8SqyQpUH0jDyZOaw2lfIyWbgvnEtkjpBAQqtdhXqQiikQ4TcYZBXrbgocaCp0Obw786isa6zQg56F3jd/jLz5CtnrwrKqq73648xFnWzy5X8GtiI+2idTUEscwtBRRc/XCBJaTJ0e48KgJisFUGOVfVFLpd1TJG0o7leo/i2yC7G8XHXfC8ixXMAoDsbCkHzk4mA2DTec2dO3jfVN/FSFZty2cLglLLSDOfL2mPnUVGtGtYWPHEssLbUBE+7+4eLqHfGOxvmyJ4oMB4tisCMeuwGkj0Cf7HkSc/4VXrAs4INxP8ljhlJWM7MolNTUcdgWmkAKt6wD1OVJelDCC3UNE+1SaoBQ8/vYzQWLGA7nYR9EB3WDH3TVXUYspHdZOxqviutXqs7r7e/36vITZDTt+gZhqvQ+RwwgM/waNJunryLDuTKr3HXDbhmHGRGUVZrAyP459+MJQueyWeIHqUHZJKP7b9AIMCBMJdlhg8/SxEZU/cOoaKHN7dtfReaDicIsWocTTAMs+mdzA2JLxaLC6fMZD6/NjTIPmho8+lapjBl4gM4gLCymVcGGaoor2c+Grp7ncNva01VPu0YKWXv/XiMvPUTQ1/wnql6vl+JuWgspsGRwPUigG2Fw51lfHjUO3jxjvV886Oi3gpoyRWIKR/nXjFDqPLkysHnJExIS0tns7iZ9KGRJhUbqIXnutu4yoZm2T/b00xx0TKlq+VShZLQCiEHYztdw6wTDRRX1pfcO173kWb3AI3yE3brRU9f4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:00AM +0100, Andreas Hindborg wrote:
> Add memory backing to the rust null block driver. This implementation will
> always allocate a page on write, even though a page backing the written
> sector is already allocated, in which case the page will be released again.
> A later patch will fix this inefficiency.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Same comment as elsewhere about parsing booleans with kstrtobool.

> +type TreeNode = Owned<SafePage>;
> +type Tree = XArray<TreeNode>;
> +
> +#[pin_data]
>  struct QueueData {
> +    #[pin]
> +    tree: Tree,

Why this type alias? Seems cleaner to just say

	struct QueueData {
	    #[pin]
	    tree: XArray<TreeNode>,

Alice

