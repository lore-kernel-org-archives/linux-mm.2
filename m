Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F06FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDA96B0088; Mon, 27 Apr 2026 20:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E7C6B008A; Mon, 27 Apr 2026 20:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5FE6B008C; Mon, 27 Apr 2026 20:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBAD76B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:36:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73EEA1B92A8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:36:09 +0000 (UTC)
X-FDA: 84706097658.13.D601875
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C46FA2000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:36:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oxaYXX/E";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777336567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9fYNipmj2jiWvfcm9j5TcPQDqWjOcuZNciZas0Xqqw=;
	b=oJNdAKbSzy5Be41XaS6SwoBG3Cc7Iy9vzqrh7GUf+2ZusLXGMsYRo/llgYxvYee9gkcb1A
	5AqgfMy1cJ8nlDjdnxD9yNTF4eJErnQZzA4MvQYRYsYXSJ0DiKy1OUEH2MUwrTtjSRWBgo
	V832m3jyXR3MoLjpfGtiU6iVbIKFPWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777336567; a=rsa-sha256;
	cv=none;
	b=BT4H9laJBWbYnZ/xN5EvQ/LCPk6k0awgFerngkTSFDtbK+HWWe5Fea7BEN4WzEvGmKKpUj
	shRJWMYFjBTm6urrLuR7kH7TrsnfDo2JYSMlebjWvxVFUiNW2rF+ZxZqE9Q754QS/RrCU6
	HFVd48BkWd54LZWxt6b1My43H6GBVB0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oxaYXX/E";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2AF3406D9;
	Tue, 28 Apr 2026 00:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5612EC19425;
	Tue, 28 Apr 2026 00:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777336566;
	bh=w2G8seVe7Pb9QrXacqG3WVCNlqodGQ4ZiOZhzYJHsms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxaYXX/ELr61hdvV5+eh4hrnDtONEmy2mtmezv1cWHoo5DWtA+eFo03VMe7VBXR/f
	 BIzU7JBQyJ7HtHkEXKSP9Cz6A5sxV/wD4rtanNSlYtXAv7WtLZo2jQxAYp/GEbYiBW
	 XJG1V7H5mjDh6MwvcSoPRnWkNP1wBza725SOdxMasvrLyrrpHjs6oDybj9mPNQt3qV
	 IMazqgkdcQHA+VPaY7vlxGR7ImCNaLI1v4GpyCNpkxEhkn1WE6Flk3FxTqb69b2Ukr
	 NupzIRCvqnq3fc2FS+nyLKYFpOKmuCzPM/kEIXFlr6XLj98XvPTQR5yWT8ZJDk8Bdu
	 PclGV8QKdcefg==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 02/19] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Mon, 27 Apr 2026 17:35:58 -0700
Message-ID: <20260428003559.113178-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2e2bee93-d68c-4b29-9ad1-1ef975fccec4@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C46FA2000F
X-Stat-Signature: xmz4s9xmitp1ruw11eri1rbx5s5rta68
X-Rspam-User: 
X-HE-Tag: 1777336567-361927
X-HE-Meta: U2FsdGVkX1+8tsJaWZcBmTIkJByzHybk6q4YYUSzNZby1smWlqhVWhzGUs3B3FGIpF/OTsgWPbqsZhVGJKzbxGnoycxgVgZWls8KcpLECz84x8iMwMCrvmAbH+fEMj6q7F4qKakjyHZGBQgnpit/bM7wBetiebNNfEyuRJ+tNvBg7i7ZzM5P89UCkb0GcD8Lu4rSwLvDw/VkcRxpE6eQzIaw/FX+HlSGyPgkwff8LQrtqCDRumAC9Ce28AjqnKy3Gg8YfOJrJ1k3tvPEuwfXFkXmDUDaYYZ40e4Yr0ekdWVeY+njBbksQxMtEDPOsOc4zx10KUVs3Z7LUYQ0cC6XNfkpvZ382zlxovWJx8HJ6wqiObmuo3jtMD1RgKW4dalUJ7UU9sRO46t4pry5TyFWhd7q1MOYkIzpgfmpv7u+ZXvVK9fCWP+B4tREJYPqp5wL6Gep2MFtDr6EdEsRtCBDpnw9cXel9ASxK0VCeNYlb/wU6jOnlJ8U3yqd4DIqbPRpeP8B0mCaHZr7K0t6WX1Y6GocM1Fpi67coAU+eCT8JauaCD+l34rBJQIm6/GEU7lcChDSFrbmuDP1ceniNacoZrQRtvDhcy61lktKEUc7aT0fbxajwUEbpnJ0WcLFUKgr8oLulThiyT/bny3yZZSLTUw4EcpXks9II/GoCNSpxk++r6fTZOdV5VMgV/tVMN+bpRpIUcGi7GpSAaxlsjg8XxMiEbOceFtB6aKRezooE8NkESMbV9YoIv+XKpYMAXJRM0OTVz/5ba9g4HVjF+faN5WLDVUjZqWV1bhwPtvBFttPbUVszj2s9QSJDXTWdC2XgjRKneia8GN5dyJL7BFfLkXJEZZZV9YHtbw7+b476hF93II97Na2rShhjWSEaQNdw+4BAia2MEWZZxbHKVSoNbtoahoqd/mQLoVgaMP5VR4CBwMXN7equRZb42UsOSP0f175yergEGEvMGPz8Fj
 OhHduoDJ
 8BXEci4w3vMpFfNUhoItMZkcuvYnfJj53nBTcO8HsmrRApSFNev/us+UbQxpLjVIJrzUqmFBqwGW2gbdxCdJHqiphrmoJwF7tP2/eFwDVhxHsVZxTQaAtqehf/+KPBw+BJ9EPxzoKwtlxntIqdAbAWEriYH9d6d7H7hjXO3q/vktnrwoRYwIHrb++3nklDK1UkYhAwkKgsJXV0c2KQVqMtNxybHSvje8kP+R6Ksrso39ESE3EcZkMwYuHHQuzj1LDOUda1ZnuCAtcxGNL9gaq+OPYpo4x0ROv6fq4xq1kYZUcoFI7yqGop5d/XA2TBu9OtFH0liYlpPl6bOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 16:18:14 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 4/26/2026 11:52 PM, SeongJae Park wrote:
> > Let damon_probe objects be able to be installed on a given damon_ctx, by
> > adding a linked list header for storing the objects.  Add initialization
> > and cleanup of the new field with helper functions, too.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
[...]
> > +static void damon_del_probe(struct damon_probe *p)
> > +{
> > +	list_del(&p->list);
> > +}
> > +
> > +static void damon_free_probe(struct damon_probe *p)
> > +{
> > +	kfree(p);
> > +}
> > +
> > +static void damon_destroy_probe(struct damon_probe *p)
> > +{
> > +	damon_del_probe(p);
> > +	damon_free_probe(p);
> 
> Why don't we inline list_del and kfree here instead of calling
> damon_del/free_probe?

I want to hide the fact that we are using linked list.  This abstraction also
makes it easy to control the calling paths of the data structure manipulation.
Meanwhile, smart enough compilers could inline these if it helps.


Thanks,
SJ

[...]

