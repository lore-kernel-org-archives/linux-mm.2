Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB01F4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EEFF6B0199; Mon, 16 Mar 2026 06:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0932B6B019A; Mon, 16 Mar 2026 06:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B1A6B019B; Mon, 16 Mar 2026 06:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEAD96B0199
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:53:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A2D9885A8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:53:21 +0000 (UTC)
X-FDA: 84551614602.20.5ABB880
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id 05ADC20002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:53:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rlGdYpqj;
	spf=pass (imf03.hostedemail.com: domain of 3HuG3aQkKCBUv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3HuG3aQkKCBUv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g33pdxtpEHFf1UDlvSO++aA1e6glAPf5ZJ+Ik3YLW6k=;
	b=qwmnRJG2EhQYFvU1GvspBvfjchrE8x0D8bSQ27ybRAUVAtKQpvt1p7crqalBast5o6rznX
	Gg5I+WyRi0EkPhzQ5TKfbYrfDQfkbDMBb9VZ2no6kQoFvxO4Y6ZkryrJCi7QUMFL2wHQ8w
	wqr7gNIjJDJR8zmGXLlXoH38s/ymwhc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rlGdYpqj;
	spf=pass (imf03.hostedemail.com: domain of 3HuG3aQkKCBUv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3HuG3aQkKCBUv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658400; a=rsa-sha256;
	cv=none;
	b=GTG7CUvHb+fcqnnwZ8EYbWgf32MWDF40JVydDLK1r/gqTjmp072N6VEq1ZOGSLCbor4Ko0
	1wqcV/5NpNia6VakTsOjScp2aBBCQmawuRkXznEoP4RimZthlRS5Jy45UtF7TIFZ+oAEH5
	7DeSnnDO24mlsMUVWnAzp3rdYp1iwV4=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b41d45be4so800450f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773658399; x=1774263199; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g33pdxtpEHFf1UDlvSO++aA1e6glAPf5ZJ+Ik3YLW6k=;
        b=rlGdYpqj5pqLlysTe0/AxV4B0GBFTIzPX7hPvtWCs1A8b17L61/wbVCPO/AFRGX7w5
         eW18FLT5qHo5HjdDv+o96i+qK6pUTNp6rPFFiRqBfTXzwZADUQGZFzttXabWHIm4WQbP
         c8PhgfQp/oATR7xcE9HjYRv+AcVPJfrpsM75bvO7CwKrUf6xGf4gFUWaGRedTOa9ZFG5
         EgNb/yEdrjVkhfnLAKQR7+shjdzJBo9EWOOukkwxK5nS+BXAlaL8w+ya7la7xEses3Wi
         WRyO+2PA/y9Mo/+BGjjk3kcEyh+s9Fngra88GXeSY/ydaAH58ydrdT+ghZQR14JWoXaS
         ji8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658399; x=1774263199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g33pdxtpEHFf1UDlvSO++aA1e6glAPf5ZJ+Ik3YLW6k=;
        b=CVjGltg8a0/9vhPaImGgkFz6UzqGZxjuQeYjBg6fk7nZjw0AX+GIKyQgcJxfsFNB+z
         nHfDtwPbSqRj48YL59Z2EMKeCZpNtYfgzJLmAvT60Gt10UZ+rH/lghMoJw6Bn4R8HNj5
         66rNyqhB9y+bE8grBy6yhbt+iHti2nxr2GQKqDTOYrcC7gdqHWeCeiiKTWXo5q5wU0w4
         2lyTO879GhGPJY9kRZmOdYg4JpdwqZys36xHpgviYtyf+H4DxglnpixdVhT7AiwG2V1Y
         Xc0YsFJD3F/QOq/RbOrXPLRMYXWL0mynyOfYSg6nNjL7WmEpdOQHu1dPQlGUa/odKQBo
         8atQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsMznwS1u8lniQP9jvNwAKoWvGOfl7CWAsm+X8tP4oitvaKr4vISffa0mBhlYn9GVa/gOFUtiZtw==@kvack.org
X-Gm-Message-State: AOJu0YwDGSBUAmWKX++23Y5LTpdvZx3G4LNCEo6uK6rtW87XtQxDet3v
	NwiYD4KFmHHE99CahuEQ9dHcbJx5pcEYdXrz0Gjb+C8M18UISqUinAl2lbl6IL6de4u9eEXbbYJ
	/ihto1ckW8WPQdKSPlw==
X-Received: from wmfu16.prod.google.com ([2002:a05:600c:1390:b0:485:2e9a:31b4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4752:b0:485:38f1:5cec with SMTP id 5b1f17b1804b1-48555ac714fmr203380975e9.7.1773658398201;
 Mon, 16 Mar 2026 03:53:18 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:53:17 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-21-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-21-de9a7af4b469@kernel.org>
Message-ID: <abfhHQmMmEErFYb6@google.com>
Subject: Re: [PATCH 21/79] block: rust: add `NoDefaultScheduler` flag for `TagSet`
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 05ADC20002
X-Rspamd-Server: rspam08
X-Stat-Signature: tdufk7mp9e6xkms9mygaozuiiunh1byq
X-HE-Tag: 1773658399-345316
X-HE-Meta: U2FsdGVkX197MF43CJLa7jqsFJ+FuNk+e4SvgLmvnqNH1LWYsWYg3KhDixIsUphBYmk69ZnG5Zg/z+EShUA8min0MwqJcL+DBYNPF5b7ZHRkRs81EDGLrrt9EcQ5Xvv+GdMW7wvowL24bGUDfCfJGH4BQ9QWGjakW8drPNeiaXr/SgAaSZGov3WmcKQka6vUmEzQlXMHkz0Jp1DgpfXf8ZHhye8JGjho/4sflbZuXgWTvKOCr9YsDM4HJlSgByDu+oc/R09bEhoPgSsxOGnt5QAYDC2KHY8EWqzQiiWadATOVGW/YhRDBBivhS4HAVI9VLVAA+phWMGsDCG4kGgHNkCPc1HiyLtS81ThlYgmI6uW5IiQoHBqQFDhDRUmjn4C/wgqModt9HxSqzVJYi/JIxcFrueGFOBrm2Rwhc6Bf+09FZtyNKKzqfzSax8erDDcwXgL4gKvqxpOpRpPo9aeTQjojpuxNmGFStDN2juFJr9siGRQCywjiZwFHFYl6zOSfZ/bpYcgbFCYe6N/OQDm4FTREem1WiguXu6MnCJk4LBRh26wf2NznDH1ZHFbW0Vqi7bdmIHFGCo93k+ShFCW/p/MKyFuNFMdGxJ9xqpEPpn/8s8NG12N3VdStm9Rk4mOGgrROR7q5jdsfqCghPixhcPljtPbfM5q2tq0OniX0HUXHWyPoqtMvuJWtAJCCFeKWMq5O+05lNy8sp6f8s7JrjYEoV/84jbHfxEhzseIDnmKcsjdGDas5VMG35LHq3mFEYXoKJa0ilhvOa6KLWC4gZ9LV6ys3HKYYySxOrroPplYKNeoONPx336WT4xW3vhLrGWxddmlpyEZkEQ3junaQn7l+atXcRkxxhSnv12FtXr+liDQvldQDobaTjqVDNMgLRo8VregB/F0EOul/u07VzDrroziK/ihTh9QBz0hCpGHZuBw1yktEy9vu83czFFkG2P3ficH5/4GV9vRtgv
 ZGKQbWZe
 h0wrQF1I+IGv43Ka/aLjY81XGu8bD+IDIv0uElR+U1VNxejwgU5HX4CUMRo/QE7JMXEMMuUmBJ/odM6muShuqtetBQFY7rUypVfp5lSO+jzU0AWdXDeK7YF8kC5L/u6OshKKFrruCGjSZsO4mVVvPtG65eAy4SVso/cbZwej5h2i1CsEd4QKrgYF9lluXDWQbmStV0GeN0LVKuTPleNJ3EyWrAguxU/030YFJ4NX4N7PZsQPRgxFYb27GiKUVT9qFhwOl7y1C2MU5buqvRPWcdndqBXIN66sKo3vAeV7yZJ1n4JA2VGU7d11X7MqTpS0zPMBtqDKLr+m9KWonvmvL2xku8jAoNtoDjRGwn88Np58XjKMNn0hFz/MzjFPl6vKwQe2V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:08AM +0100, Andreas Hindborg wrote:
> Add a flag that maps to the BLK_MQ_F_NO_SCHED_BY_DEFAULT. This flag selects
> the 'none' scheduler during queue registration in case of a single hwq or
> shared hwqs instead of 'mq-deadline'.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Can be squashed into next patch.

