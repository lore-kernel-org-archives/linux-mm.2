Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB48606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oV0pcpC/
Received: by kanga.kvack.org (Postfix)
	id 3708F6B05B1; Mon, 16 Nov 2026 21:22:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB166B05B2; Mon, 16 Nov 2026 21:22:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210A16B05B3; Mon, 16 Nov 2026 21:22:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3CED6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:22:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 905DE1602F4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:22:52 +0000 (UTC)
X-FDA: 85443012984.29.66D1578
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6498160002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:22:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oV0pcpC/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794882171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3H1mpvRDxjYxRQV4+mRDY8Md93q+YJNHbYdI+GkXXs=;
	b=xUJ8g7L20IK4LJSWrBdEnky/l3VTcMvklzbZPqDCv0tByRWIb1Ll9pz9uL7a77r78R9MIe
	S/Lph+/VXUvcpwHdeIDVfSwVx1+KxoJ671uvpxKbu/Rf0aWt0JlSO5At0GlOvgGYRuSxmH
	NwvLtfHCnbXxAc4FuIp8vM9cJ5efEgs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oV0pcpC/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794882171;
	b=2YwTR9WWZ5NL8C0fMMSzAhy+TEeaBaEu0WmXvmE1tjy0shdpQJn6SdiGuSTOFp5EoDll9T
	AgH4DtmyMdVcCJGPIv6mQkbvHiicXwBuWiNSk3oEib1TqlPaMU/cWRcV8n/eM5lS3lwhpK
	RrjixJFJzHJ6BYw7az0RgdRpddxyCYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E9F062448;
	Tue, 17 Nov 2026 02:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A391F000CC;
	Tue, 17 Nov 2026 02:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794882170;
	bh=/3H1mpvRDxjYxRQV4+mRDY8Md93q+YJNHbYdI+GkXXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oV0pcpC/ffQh4rYzlim2rjHX6x8pya+lJQW+QWen80nRL3PhybSB2Dju8jm5K/nQR
	 MGx2I2IQ/i5dlPw8fMOqfIf4Vhm/ETKoxUgNhjW5F16sRAYsyuWRIXy2Dp3qfRqAzf
	 Y8DxfYWDS1WTutcjkOR1czWMIX5y4t/WG67chhmR0/l23Bl1KBqq479/K2qPjJyhIW
	 r4HJypnvf7N7V6Hokp/vKvAdiaW8QU7sjUQFKTw51fMt2+OGI3kP4hHvtLISko815d
	 yBFFLEYp89wdkBS4GICSJVimhvFbZg9eo3YYm7STwI/hVGS+brGP7huF61E+dvLbCk
	 h1fm4nf2Jak1w==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 3/6] mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
Date: Mon, 16 Nov 2026 18:22:42 -0800
Message-ID: <20261117022242.110258-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-3-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ernynw1aoa6tetjup51u6n51xhg1hep
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6498160002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794882170-293381
X-HE-Meta: U2FsdGVkX1+dxdZfdZf2XDeRenUe7gL8X+oPnnCEiIxA/6ZV22E5XBFSvMER7oyWrrBSw9rsHsZApm8REZZxpvquemeaQyWABKuhGu6Ts2wRFrkTv+9ui0D5YTxC0ekmV0yPd8xjbhHqw35X6z3uYNjbQ876mTlkgBsr25J+dulRk7pzs1qS6YZtfx6wbSai6SSV++3uGRUDyaAjattVzrpvgG1nA3Rjr9iwrr0ER7CjHaWAEZCwsjcSuaYkBvAerHLtrCTt+dzzqMt+PSAkWN3zbKoR6GjGcgjVc1i9sE3mcu05ZJP754ZMGmlE3KQSZFptRgh+cQ8FeucZEqhAx0TwI4++xkXbMCnSj8xEcdrI19Ws4raqnG9K0XluoSW9MRHiiPgZDdNmQi5qCpMQpUQJSCYJ964N6v/K4uAZKqtaAW2O7B3YvTwvWP7SZ+W89QnwKv9G5Ydy2yJJukju4fdwnNabqAqRmk3sDbuEHWzuqsC91/u6+PIVZBgpYBg5uiHiPKlB6oQSwOrzjcqds9zsOCX7ud6mWYzLBePRiC5ST+lQU8OKMI2aE7w03+VSvqHgisUzNO+4cLOB664XRM3cWSeWVIXRbENGRdkVzwVLAq1UOphCo34A1aGype1oaKuXSqO0oFlhdYL5d6ygobxwRFBAsVu24+MjxPxmZh1/RcWfNF1raQQyOPWmIgO6p15yn+iLfQRlJ8FJTmP8v5KLAt9hhs/67uoyDPc6dSpfzpX+y7kQzMxZLtjxYL4ydUTiZrbsyUp3KjHk9xQY2ZB8EN1Td+f/NFFDXlbrH888/ah+w1ifgw6GTH0EZkqF/ksFvfS4+wRcn9hFpBq3/X3FrUtXmZWHNo2ln97U8A9i31RFxQZf9STv7+4MbwiknxEt7i+ty/kAZ9OaqKlVyUH/3kqRwzEXS/p+2nSYogWmb/Qvwxcr32v/tsPzf65xO5ikQ+2j8PJRDgv2FgR
 soRWCRkS
 OazZ/X8SfRyTqaE4/VSaN3eKEWaH43cPFEiBxAQJIWyzfICZdzmYT36zQ0Uf7e9kcG0Zc18OTeHz2LIwwOVL3vVes74XrQSwuoilpE7hPUMORpRNvwiRlqbR1+WVjo1S+5YQFRDIajx3EcWiaC8C9gALfNhUPYoFQXqf2V9bV9f8G1/Xo5GVazRkFoVM8eGs6+QGnvB9cBvHSkCCNtrtvvO7suBjIXvFOOI05HWR5eFKjHvnnqPB2OmeB2oqm1gySzMIPe6s6I/I7thJPZguWELBIYnmiM6SPts1vw5DOkyQOuKZOJ4HddO+OAOaJU06WCqPbddeAWskKgNKR3IwWAEGDwcwBbDudVEXqTt8wMZKlRHjwuFux+E1Jo5MktUWvDbxiKwUkF/nMmpxMXY71qOs/+IpajDVPO0y1JnXYtbWbelpOYoD7xv/k3+10mCkYWXM4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 19:10:06 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Add a kunit test for the sz_ops_filter_passed_last DAMOS
> stat.  The test runs kdamond_apply_schemes() for multiple apply intervals
> with a stub apply_scheme() operation that reports a given ops
> filter-passed size, and checks that the stat is set to the value of the
> last apply interval rather than the accumulated value, and that it is
> kept unchanged until the next apply interval is completed.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
> ---
>  mm/damon/tests/core-kunit.h | 92 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index a5ca4bfe2f0d..ec83598fff0e 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
[...]
> +	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
> +			NUMA_NO_NODE);
> +	if (!s) {
> +		damon_destroy_ctx(c);
> +		kunit_skip(test, "scheme alloc fail");
> +	}
> +	damon_add_scheme(c, s);

Sashiko concerns [1] the fact s->core_filters_default_reject is unset.  How
about calling damos_set_filters_default_reject() just before
damon_add_scheme()?

[1] https://lore.kernel.org/sashiko-outbox-217563@kernel.org


Thanks,
SJ

[...]

