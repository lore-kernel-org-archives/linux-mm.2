Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DD5CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66EF440149; Fri, 22 Aug 2025 12:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CBE8E009D; Fri, 22 Aug 2025 12:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79C7440149; Fri, 22 Aug 2025 12:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95B8F8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:44:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F323C027C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:44:21 +0000 (UTC)
X-FDA: 83804966322.15.620B847
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A9657120003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:44:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Juqfm1fJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755881059; a=rsa-sha256;
	cv=none;
	b=7eOlr+Nyn8PxJ7N9HXGpFlnbiIiCwntdotdX1v1PyGCqcK2Y0la1RQDP6fx6TRDMK+2JdB
	T6cQKiRXfQ7k5cYdTP6sE17M/dUdQn5xoL/QyHIEEuy+Ga0kwpKWNzn8kToZk/IwOHmRe0
	LocxkRA1eHmWy6+2jcdNYgREHs14pHo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Juqfm1fJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755881059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1aXtfGe9BgEEG5tu6uKlXO+1HFUBglg4deKt3aFS6Q=;
	b=bRkA04iTHYn0ObYHlU2+Ec1yiemSTuV2KP75AyXcaUYNXLvPJ5iShJAqHj4jcI03uC/9fS
	dx8dw8yO5FMzqN/KSubDeAXcVmgYBI07xrsiPi5vn94s8uF6T8/jPCFPQDSnOAQEMkE8lj
	5kYDY7NxFgpL8E+nmp6WYDD3eyIAP2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3A66601E7;
	Fri, 22 Aug 2025 16:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4328AC4CEED;
	Fri, 22 Aug 2025 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755881058;
	bh=k1cK3Xue+HD3m7URxYZ8fT3eh0OpuLIIwinvJH3zioM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Juqfm1fJRNO3ABVAETXZytIvmf535GRaCb+cbkSlgeNhd9xtSDNs+2dBL7vSGlB02
	 1Z9zIhoBqW7uG9ep8bRXLd/57/FlY8gxMG1/lSKs6/k7IW5PgHx0Gy/av57PE5DZPa
	 vbQdOIYRZvkkLiHn4wUZRfdNfiSfkFa9kzPQzT3l+RXnRoWXUAeK4ei9JgqumMJqtV
	 6H0olStRqs5gvsaxkNEKQ5OHDjPqTbd3F41Nuow1w9cZupyss27jLPXiUxQ3ywWs5e
	 Yq4LgEbhEWXZ1MGtWMVpF3qG8ZeP4wBwwxzU8TzgZ9qIRnqyJYCwh8JuYINrWbhODA
	 t+rqQa32fN/VQ==
From: SeongJae Park <sj@kernel.org>
To: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Fri, 22 Aug 2025 09:44:15 -0700
Message-Id: <20250822164415.52517-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAGsJ_4xLKVM+1LqKzbwjd0vB_OYnb2E-h-Wb_C2bBxiSdU=3WA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9657120003
X-Stat-Signature: nnjxoj78emyjoo7t3ibbkzacx8dz61g7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755881059-163837
X-HE-Meta: U2FsdGVkX1/dI8az+FEwr/1sj3QZMuK+oAzI+Ry6t/IX1TxANJe4T9Hpc68eUGNDbrtvD4eUSU42vBL8fgDDJnG1VpzV12+TKTQSFcAg+TwySEsrvNgkLlwzb+obNiSfTvfXSjE23JFEBftBa7jVxUEh9WS9uh13zibJXAF784GQrMa5g7REarjlcmQq9erkGDXQpsFu/LZv2nMNJyjy6cEKJrxlA3KhcQejSz21Noy/XEk+Yl3JMmuumg8UgSCidmerWhwLstMlqQCZvffHb1gA4C0Fr9O+Gr2j9nE1NqsH47wZRgxzJXmXemZHZ4Zaanqe1oLxDysizDs+HOF1PoAWPBtoXVr/M6wJTHITjVIzlbsKLbdkPThWdRQJ/2GdQKFNHRYjYPzJ7KQHWn5EpfMqnjU03HFeZo8564ZzTvcvN3tVRVNRd6fdeTY5Q/HtABPxjQEmogiBUUpQ6tgIQp0nBgc6fTnYWlsoEgzOqu8RdM6LzJYEpPZMRahzgkikqvRqWmJ872j5++8lEhwq+8G3PGSLbDnYYw3j2NVesB6zhaEOUfzmphP07wHhxmQtjItzkxaPXRKhVXdX/h+2SZpkxt8fuBo5oD8bjCRCWwMMWzkK4HENUE6dTDl4jpoZWssoyjBEVYmEVkg7tpDGMX82hfTx/rDZ4amswvHLTv5xI6SbnARApKKcvKUv43Eux+4zK6rffUPAE+XGWdz3YoBJ0ROUlBHJb9AmnZOX89zcbNQG+DYUrA2z04WXaAdX3VDgPlDLkZF0Ii5hqfEoLjrYLFWGWiS1IXKYhs1OfjZbEHiyHA5xYr9IVOB9/sMRw0Rh++mbOFGnYZ5EwAXgEXXhU8NtekJ3eWE+1zv0fy6ACNiDE3GTRQfJu/wBG1w21RuonGpFbCy/sIkouMODPoDQLic/LFF5kxaa5Iym5kx1GbkvuW8aPx/LkEvoIyvvZVf5CUCNqEJy4FbaA60
 mXIvFwns
 hEV7mS1rKiRex19Urp3L0LwHf9NT3iHXTdFmJRg8a0WdsIzLnVnLsaOcUQUP2Q+F1V4AjVk/xypkqXE7uPYBwQn1e2ijO+gdnPZsk78dihum8rNpQfLHXEa8AK4TjBvYifAmqMNuiv/BYDexxuJ2wy8xalWr1iFT29gB3ceFiJUgwe2PXrxqZKlxRk7wN1e9o5EoJZEnYEbQPoc3AhcI/YypPdvYTXCygAZF/gmmfD8dNmzxkdtBs8rplKfSHYeXR0nRU1JsrAOFBtF2Fh4PEEO8Neg3x+J2R9h3Spvg0EahXxBFQVg27J4a8Tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 12:48:27 +1200 Barry Song <21cnbao@gmail.com> wrote:

> > > >
> > > > 1. remove it,
> > > > 2. keep it as is, or
> > > > 3. keep it, but account only -EINPROGRESS[1]
> > > >
> > > > If I'm not missing other options, I'm tempted to the first option (remove it)
> > > > since it doesn't change any existing things, and we can revisit later.
> > >
> > > I am fine with 1) removing it. Maybe add a log once print error on the
> > > error code if -EINPROGRESS, just to know such extreme error has been
> > > triggered.
> > > >
> > > > Please let me know if I'm missing other options or if you have other preferences.
> > >
> > > I just don't want to hide the extreme error case but I am also fine
> > > with just removing it. It is your call.
> >
> > Thank you for your opinion, Chris!  Unless others have different opinions, I
> > will only remove the counter (option 1), since it is simplest and we can
> > consider adding another counter or error logs on top of it.
> 
> Yes, that seems the best option—to remove the counter for now.

Thank you for making your opinion clear, Barry.  I will post v5 soon.


Thanks,
SJ

[...]

