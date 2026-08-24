Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F8EC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A1E6B008C; Mon, 24 Aug 2026 05:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513F26B00A2; Mon, 24 Aug 2026 05:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDF56B00A3; Mon, 24 Aug 2026 05:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1560C6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:06:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7823D14043B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:06:01 +0000 (UTC)
X-FDA: 85135580922.20.9B4E227
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A00C140006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:05:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=h0wcIS9J;
	spf=pass (imf26.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.179 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787562359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
	b=ggmh9gr6mznU5Daxjk1mGZxp3JdaVNf+ibVYGqpiUwjOMi6rsaba3kMOD6+6zhrnG9hVNk
	Gs8/9csJof3KrlKjRfLlyojvJThxRvxBH4ZFMSJNWt3kv+BYwOcniuAIMIPoP4SWo7PDG8
	LS/LcWvwEwySCHdeQb9iHgF9G5dXZcA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787562359;
	b=dljPX0xAhMoJ0TSQDwFnTeluxE+AQdarJPtGkHZ0mQy8ou6L4e9VVAiVM0ErsDTEHiPBlr
	aAtvQqxBGPIW0Yim7H4K/afyKCYMzhZa/1VMNXSuhRKhoLrXT/HMNrs5PP+8tckPyOQsNu
	TcxtoylWt1Z+65PCvPv5W0Ebf4eZ0D0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=h0wcIS9J;
	spf=pass (imf26.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.179 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93695893ac1so185709085a.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:05:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787562358; cv=none;
        d=google.com; s=arc-20260327;
        b=TOLFpi/ZpWfGqYYhFEULTLGG5YHLgjqpKCITIIvXNdMNZ+JjGICAO78wWZ79pk24E9
         keQE9st2n2epDGsABeCsHbkLg6KTVZe2whgkZdj0EqpxinSXzjqjP4Exvje/sXF4yhEo
         FH6FfxvJnBfd+81BPzZOKHynQkBlIxZLGZgeOtWrlrmIAxxhSvtK9RqqjjJ94aoKPDIP
         GJUXGAKKsfZv7V0inqTVwcqn0xr+LqGf6y1WC3jGWGWSoyG8tgxni/LNQ3nf5VzV913Y
         0Ohho1EMH0phOkDRJj4ELqqVc2wu9EOOqyR3P5PvZzSKEr3v2CyZ3ZD7sntu+XzzXBLG
         yBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
        fh=Z+yNMkwrDK3+ECr96az0w+SqDi5VS8Cm5x2tabqiLFo=;
        b=L//sk5ldiTvqmgWY/50HhxcocMDylaBtWx/vwU1JT7IFILKg775EHXXWKKKOxes3Rl
         l++0rCTlN6ccSveHBDrwAMMkIWcWXWyrY2+UVPP7CGxAMPcfYyxi2C2JaS1rLN9pnbTe
         xHVyFziY+pNpW/r2hOlMUJaiz/XXM7FZayhSsBhyzuI3RlW0jU88QUyC4rMR4k6CY7Pu
         OXBu1eazmPA4GGHDe5kcKSYmXZwU27prX2eFL0NJVvWx5onosg3Avg5Xr8Rb9hJt9xqX
         EIuV6Gnk4XKbz82varMM3LB/glQxIeL4Iu/MhCII5ws7xBocvUUVMXdk2HCIdyB7AR73
         ppBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787562358; x=1788167158; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
        b=h0wcIS9J6HTP5UE0L15d8oKd6yfVlWEsr6GtkHCKrk3nMXlo8TmdBNW9QWWBzE4cdy
         3I0a+NZd0xhneZlSkg8vwpNAFFZu0gtQ2ZXiKIebti9O/CzhwKexbfjDtS+WKTyiKtcm
         mizvbFkb0djlimjLQctdOVE7pNoggssKj3rRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787562358; x=1788167158;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
        b=NHE62ORIjdwReQCMqvgI/B7TehgYzL7KIU2Y8Yd0uRc7bfsQVtu3sSN+zDXdIEgQHK
         HIZBXEohgVLXbL0/JwgOjA3nmsC0SWMSqweQDRVECa9K0q57/uGyERkesggM6cKUal3N
         r0yy04No039GT/ZS72TqtMO4Q+jyUn1Zjcr+BiDVr/lIEqHR4Rtb9e0IMzhaIhaq58y9
         LgbVDVa8WMCseV//fiTZ894zUUo5nc1zWYQXLlYVujlJDk/NUTP8rEb/5u9+Vr1D7vMg
         BFmzQp+owQd/BMF9rBvbDxxkrJ9QiNeZUOjxhDqKQmhiqlRaXHp3flQtWX5sikrWoyGz
         c5Lg==
X-Forwarded-Encrypted: i=1; AHgh+RoTQlsp78dEtK8j7YOxk8+TKmqScvgjdkcwUc79PmyhWq+o7uBrLkM1olYafYAXvVzNHFkJ6y/8QA==@kvack.org
X-Gm-Message-State: AFuF++kaPxgGrMDTRVQkZeFcCv6x1TpNh4S4jAkgxB/4iei1T2gr5eMC
	2wzOtCIQd2k1VtkKfQb2uxUlCNXKdl2JV8hsnnokLNtCM+QfwBtHXmlbDvrCbRV0yccgZ5CHtde
	7DzgmJgBQwqkaElG4kToZvWPypWjkJ+AffJ7ltLhDtQ==
X-Gm-Gg: AR+sD10EcLprxPLNLYG/1GyKqGiQUNF292J95SDvk/+JXIC0vYFMglkbz4b/dDCYvTU
	0G311NhfWebwHXtpsvId1pFOJdr2QACBdRiG6aVJwUGv9ihaEWp7jkQ/mkf09GkcNKKB7SWd30C
	IcXXvgACzrvCwj0TgxwesLW29LUHAGYNts0Lr3MBVwTSpLJpdC/+ALYZfWUSLasBhz/VkdIJ+A5
	u5eiJFSlul0h9BXg6GrUlsuI+sO0dkgV9vFWQEe0c0a2AyvtKBAkdxVg2ua1bZo2GwYhqT/CH+n
	FLOByU64oFszvgBxyZsuGYrbOEZXUtO5nQRf0xQ2SskXKud+h93vwnqQu7is4UqhIT7PuvCpwks
	HM9A=
X-Received: by 2002:a05:620a:a2c6:10b0:92e:bbd0:260c with SMTP id
 af79cd13be357-9373957655amr1668397485a.36.1787562358062; Mon, 24 Aug 2026
 02:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
In-Reply-To: <20260820193343.3852967-3-willy@infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 11:05:46 +0200
X-Gm-Features: AcwNN1VnwXUZIDZ1PfaZZEyLrhKwB3yAlvrDYfoxcRnFp4RHIk-2JE_xMlB98T0
Message-ID: <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: wp4g6w83nyzw686y1qnauwp85odsj5pq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A00C140006
X-HE-Tag: 1787562359-207179
X-HE-Meta: U2FsdGVkX1/Gogo7PZWNuyBmChiAvfrmHgkLqhJRxEkimGWcK8Nf8CIF2+uMk/HLShPIpqiSpjjqQtm8XTt9iA+Aw4rahcK82fgn3ATVYbexUApCr7apvPtYcrVtMo4oVThRfWu/+u/6YVIWk4rBZhUNOfCf0UKw3evySXAQZl4WKkp8AID/8prPrNILgPJdHBmJ0xywnLu0rjv30ABWyzhAEXGbtwG15mJgAYNVMrV0g68aA1vwhyvPDsVBlzputywSix/hT7h84xmCJvWQymNmOcNYLOH4Pmy7Hc5sT7VSYfn3ctYvIelvM5OJC7i0+5FXoSvcMubTpY0A/ezQyU8QDQDHHN5GqRhrp9tr0zELNdNGYEI8/Xdl30X3xf6T6AiL1T+UzB48yWmzbooFFVzqk9MuJyr273QaSwLMxFVhyS2g/xU/v+PiU425VUQ91TQns9AEFaNjg86nxaOs1lHWY2nbb6l6ZcMGgb6/qQvO7C680MKEBIGBQbWUit1dglU550MuUb6GLr71lzEapHZEVlMdJYWRK3lrreTvTmPiSP75fbtxUHhkMOKAjV+0jcEo1HvjY5ut6tHK7rWO687AbkrsJVAATzMNDt5TX90QLeMVHVJdIGeQpuECTQ/HAovbOfduoouif8FbXtiTV0a9hN/JKQTFYfo25DKjWFpdu33uOUMo+U7BWWrGuew1gAR6CZI/JNIk1K87tYihxk6N3LL6OJO4gww5MPtnMMfGTRU5k8e095TPmn4EBucOhwZYWEUFiM7dxevOgnWiXgTdWDDoamE2WrAU01s3SiIVioVEM+/b2ildF8XRjZMDnQ7yMeOFJ8t/qE9RGJGZwLpWY3WkYEWwkwyoD9ULs6pW4Q0hj5XSW2vPWN4RGE1zSY7GKpRoUs4GkqJWSTbtPmYvvnR0aBBLls4pH87XfI4xgr+jSRowWMdzbkcaSyNU3e7r2vlTiiPm6T09a2h
 UeY28peQ
 SUOu/4iP+jrwQDlNxKWB4uFoFuZQ/BD3Y/HlogabAs92KuMFBurJRKUn4zoIfF1NKJRGJlovpMbyIJc5cuwJ/Hhs0VdbEr9dBz6DTdFzToBcIFH3UI0ubWUi7YWvuVHi4bJaXcR7CExbQajDBpRLJ6F1GDk3JMzv78C1MemFC6UCxmQthgnBgs3pNcda2b/vlW4yVxXF5LpIYyq5evywlgeoTko1Ma2iIsWXA3Irx8G7obXnefJ5f4pFysDw3e1kbocygS9T3n22ebk4RZn7wYITSpab0kId8oKpkyU+IGz54B/d05Yf5JI7cmlsGELOVraTA1KRn2s8893BxBiMEZtCZWe/bADw4Mf8g8PveZ74IHJj2D6LpyMHBqzmkFjZoXHgLd51viLXOYX5d8axx2TIfGXKvvuriMHcSS67LEsO/dmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 at 21:34, Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> FUSE relies on invalidate_inode_pages2() / invalidate_inode_pages2_range()
> doing writeback by calling fuse_launder_folio().  While this works, it
> is inefficient as each page is written back and waited for individually.
> Far better to call filemap_invalidate_pages() which will do a bulk write
> first, then remove the page cache.

filemap_invalidate_page() suggests to use invalidate_lock to prevent
races with pages coming back.  I'm not sure that without it the
behavior is identical.

Maybe add a variant that takes that lock?

Thanks,
Miklos

