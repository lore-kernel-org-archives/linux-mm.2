Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557CDF4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB78B6B00BE; Mon, 16 Mar 2026 06:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A796B00BF; Mon, 16 Mar 2026 06:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9468C6B00C5; Mon, 16 Mar 2026 06:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1B76B00BE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:52:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 444B61A01C1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:52:39 +0000 (UTC)
X-FDA: 84551612838.14.20CE346
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A6BA1C0008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:52:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ej40e13S;
	spf=pass (imf21.hostedemail.com: domain of 38-C3aQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=38-C3aQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2E+qOfGop+QubRQ5BjqIf2g5ptnhpPI53+IOJpnWpE=;
	b=jZ2g3LUNniCJDi4bWNEgn/GcIpguTqmHJJoiwhalT4Md77co5/kRtdno1h9rdX2fDHVbpp
	lN3RvGtXzlsDcsuhuoz40JNAKVitRLDF8Tcg5XxMCILeNDvHh8yQRZUF+KSbkvo7u8yQ9C
	oN947gFf1IO12/9++awBVu6uBiezULQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ej40e13S;
	spf=pass (imf21.hostedemail.com: domain of 38-C3aQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=38-C3aQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658357; a=rsa-sha256;
	cv=none;
	b=wYEL3ulToAlBe/h2TH/jL2PGUigq7XAyXz7wdnBsKjoVDi/6VXYpYuE4sHYWmtrNPxYKrY
	PsjZvd7IJH+AGCbvoquaWYQ3cYrq/0LlD4llSK/PSovgu9NudkalXeMoxtCoPT9HtgZ1Ym
	zLLJ+oP36/otRMcBoC2+stf5OByiQ48=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b9360e9f43bso143448966b.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773658356; x=1774263156; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W2E+qOfGop+QubRQ5BjqIf2g5ptnhpPI53+IOJpnWpE=;
        b=ej40e13SRN8fhyFMmWyT6qVtLrquJa6WbOJPieEZPV6EG0npQivxbERNRkVIz4q1Wf
         S5j8DE9pmyTbcVEu6PJ9/JHjgSil9X+vAfGeqIAxd2V2wIwe3MdH2DcOnbHiOFKDVQxH
         2GfFkS2HMdFBYX0pXFq7OA82jjWklEIdfcxSgfHlwUCtP35ZUrGg8ZJHq9RxBdtO3MiX
         aFwA30IlkQp7Ngmypq1h3KT+k0nxDW1ZBfyXuo/dfMMzgbFaGk8mkdOGm9XV7aS4b8/L
         9W8S4isDVdUNyl8xbi6NQ/IvXqUBX5F6AS6z1XpemLe6j7tyTXvukDavg5hIslIPjAmA
         kUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658356; x=1774263156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W2E+qOfGop+QubRQ5BjqIf2g5ptnhpPI53+IOJpnWpE=;
        b=ePN3sSFEEtosJfdifCkfc5Yteg9WhA4tWtWpZ2omUsU72sFFfhlTbSNRalzXKL6/np
         cAW2jL4LVpRFVEsStelTVP6uItapm2Dg5zeCqBrQtVlfj34iese2kn7Ifr2mYptdk/mm
         /ihkfblQcIVS1/ojg65YwVqNET/T9hC1iEn0xjd82k4zVwcjmhq5HaFKCX1IdzqtiayV
         a55J8WyWPo7bIjDJCZAzCUiAqVqJ2FyTdXPuQSTFlgXe3nNNuY8SxWxezOUHJzLrEnUa
         sitqtrMHAGk4Gq+IpNfPW0VTNYAx6bmFA62G0A4FbOr2Q+wRmuLBlECpnE5hZSyvYSNo
         55dA==
X-Forwarded-Encrypted: i=1; AJvYcCXCKeWfrbbC+Lcaq6dS18VPsokUeaqMa+nSF/4k4rDp5jaeUJXnC5LIJPegcAq/ldspYYLTtHyZwQ==@kvack.org
X-Gm-Message-State: AOJu0YxLjWnRxOOyBK+sl0X4/vSoGG6SVkhU0hihwX6QLbg+Uy/XVJnr
	54ysc5DmfSyetwpieEbaqTiw3MnMYBRyUFUw5/OlANlB+Vsy4FJTng1/PlmZHnH30zwoR/keiDI
	g+sSiJS7WA//0HJjXeQ==
X-Received: from ejcuc33.prod.google.com ([2002:a17:907:c8a1:b0:b93:4f5f:7d88])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c0a:b0:b97:a39d:ae3d with SMTP id a640c23a62f3a-b97a39dc4c4mr350209766b.44.1773658355573;
 Mon, 16 Mar 2026 03:52:35 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:52:34 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-20-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-20-de9a7af4b469@kernel.org>
Message-ID: <abfg8lN2L-kVVrOy@google.com>
Subject: Re: [PATCH 20/79] block: rnull: add discard support
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A6BA1C0008
X-Stat-Signature: rupwwd4z1y6jubpeonrhoaqnjiod59ws
X-Rspam-User: 
X-HE-Tag: 1773658357-788873
X-HE-Meta: U2FsdGVkX1+fVo4Z2RgV2h10qW1T+oXNe0Y0fOfNnIpTwU1BqkYztcz2udqeZ7nMTqJcesahAJ010m05hHh5emsF+AWZuzRfgXTJzboDjVngbrLlo9hv1EeRHY/smlsmxrT37Dv2TfoDNMYWkJDbaKfNuzWQ70NBbcXWtqYX+bmbI05mrzuHcok8WEFqLg9N0MLyMnnpm2+ngyTtfuaMOi8Z5klbSVyZhlMpVz6PUjPpSwxUpfw7HbZdYYGGu/vIJ1N439y+/fXJ9bOFZXy/JCpeER7ZivLiyqAlYaGcuVhmMrCHOjnGUq4sCXoVa6RAzUjcL3kqmprjoWrRl9/L59T5bw8FJ0vrJtL6PJgeA+A+ZnDTRE0IUqe4j3s26/0HumzCHO1oqFdykPYBiXvtcdId+FrVnf89N9yj+y5Gy7jGE94gea9rWj0QC5m5mtlHz9z9iIhuex5hiTgCaMqOsQDOz5xlmIJjhmPC4iveP742ujkqea5XtIEALK9Sx4QML99p7sSa1ccHP+gvhity6UfKP42lyKWAGDemd7XzxNLKPnc7ttktzEzNWEI+y++MAZjx5/nJoDfjJlipYBOQJusJKnOQHtyQammsIzXpcKhARObOqisjctBw4IZblp6CUvvaO4W3NoJwewqI6CgIvrlSjhhw0WQhOZV8uW3mE+PDNHGtaxbaMfrMpZxT0EkT02O+yEGeStP2nCv/4yJeSZ9IWy46At/suuYp0MEkFfGAISmslOy/7qGvQJLNBnNNeqwPJZRpLb+66OkKmosUNzX1yq8/WDjongaqndksX3HIohneuue8sY14HVIz4O4m1RJY3RoV244v2ix7pg1uW2q1XWw1qP5eOoOE/xNgeXRsKYCbAzAw/s71Y5lGFSVVZp7ALEcjIgzuRNQnnT8fQHhpQe5WcTQXpJR2E0fpqDhCnnbTvCAjd2bPWZ5s8ABAQhAMrwfLAESgIt2LecI
 flhqpDiM
 +atr6Wt8F/Mt2gX149Y4mg0GBQMjYX6ZuLaRVz1GKpce94fysEc1nQi/qZrBje2oMBPZk7Otp8iYik4fhrDQigctMgjtfHlNb7TXuxJJrnQ9PraAzUxzf5VvgXRMJcBL36o3MKMHysguar95lKEP3zl4Xusu0BB0YAPDLI7m5GAYcsJmO0Lbfz6giYGxvoTLf51FZB55HbdwvWd2cz8XzkupRy0SJMccVr4y8fSfpqKtzFyDgoDkSimphpCAKjlPInkn6BgVhYPt2qh3SPlaqnG9WYpyixfKIkKDL7wpVi7Yl3yYP1yshXEPf+dD/ljTyY2GnUPr1IdxLafwQaSSP5SfgfDjXKGmnfi/sGxraghPFmBf3+n5AeDSXst6sIMqCc40kqTM38QGX0NspJEPUj7ULs7KJ/vESTBv4OuJMWRaa03D8T/QaXWFRVH4lN0zwdLr36S8+R8vDLGuzhIOCPRGJJKccacqqS95HmwIb93JCFvyxnmZOwhrReHEAr4jI5JcSpqeYAZG5JIsBjJ0IIKLU6bt52pYAc/slOg840MULrNV0R1pZ7F4ST4kAL/q/t3rpX/xuaShC0sV+I/1gkqmIpbcmmZPkvhxhVxneYF/nbsDNqDHUv2JaTAwXdoPnMrpzvHGzcKa975qtF1nGd1a0HofSsGvx4G+T/mYcfhhazf7iWVF/8gB8pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:07AM +0100, Andreas Hindborg wrote:
> +configfs_attribute!(DeviceConfig, 10,
> +    show: |this, page| show_field(this.data.lock().discard, page),
> +    store: |this, page| store_with_power_check(this, page, |this, page| {
> +        if !this.data.lock().memory_backed {
> +            return Err(EINVAL);
> +        }
> +        this.data.lock().discard = kstrtobool_bytes(page)?;

Similar to the race I mentioned earlier with store_with_power_check(),
this is also a TOCTOU race.

> +        discard: u8 {
> +            default: 0,
> +            description:
> +            "Support discard operations (requires memory-backed null_blk device). Default: false",
> +        },

kstrtobool again here...

> -type TreeNode = Owned<SafePage>;
> +const _CHEKC_STATUS_WIDTH: () = build_assert!((PAGE_SIZE >> SECTOR_SHIFT) <= 64);

Use static_assert! or assert! here.

Alice

