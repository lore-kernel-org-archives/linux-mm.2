Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57797E8536F
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F026C6B0005; Fri,  3 Apr 2026 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFBB6B008C; Fri,  3 Apr 2026 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8C86B008A; Fri,  3 Apr 2026 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCF0B6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:06:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6268016065D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:06:11 +0000 (UTC)
X-FDA: 84617418942.24.15D7F53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B1B15100010
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:06:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bumVk37V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775225169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3R48yOve1+5G1DkvUESORhXRIcXtl29bk/za/tl5Wg=;
	b=7redSwiQ1YV+D8k6QPtQBh1gQ1gNhq3Z8zvy+NYBeLtqFeSyg9PTkxyb/IZ58tHVGqxzyx
	oZ0PGbtwFacZfjaUV2g3OXuFhzFj61xYAKb9m3r9qMf3YmrJkmQX/eEpkktiwefV9p6t6v
	5yXXj3yx3EA9cIbrn+dQyh9+SDQg3Q8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775225169; a=rsa-sha256;
	cv=none;
	b=LoZ4nsA0r7nt/R/vNeb+2eC8UqwdSs7Pji9apWMyfGajsqa4RzGv0v+0D5OD55uTQDiQHh
	yTZWYWFP1WBneHSnyYWnh0DT4GQYPMVK2sL9gs+JcTLJPKwC3P2YKSuMwaTbL/lkKTgDsT
	ACp4t+hCRR4oxD0NKSs04W8248lwVZM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bumVk37V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C0B740409;
	Fri,  3 Apr 2026 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244BBC4CEF7;
	Fri,  3 Apr 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775225168;
	bh=ZQ69nE6BeRTP9U9zxzKQoeXDbMPg2+HM+sWjHvRdEQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bumVk37Vqdypmr+L6UCT9gZW9o+jaDTaVgnrBh3EGyv1VEnGUkB9PZ+XCfFtbSBJv
	 6lS4kXpukMf0e+QjHCzKXTxZzJ6cUa8QTwpUtM1ZEHK575MplGSKOEH9hqFfiOxMD5
	 fG64Uq7L/BTNaNnHr9xPTHCe08Hzo25liFq/YbJsW/A67hQ6x2Yss8GMtSVaJGtPYp
	 DMJ/G1uKeteLCQUnRIXn/nnN6dyp6t4jB3fY5ao5dSdYqqTKgKBX/E+FLUPYmFP+HO
	 MZNPGSxT2bC9uAOe9B4y9Ozi2X0lDa5zetWhMADbp/XWeQt6FexzNw+ePydKDIbEmq
	 MsraxYYaqvx2A==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Fri,  3 Apr 2026 07:06:06 -0700
Message-ID: <20260403140606.50524-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403043448.53045-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1B15100010
X-Stat-Signature: f531jjozujbo17o8p4os5wp4uirzddhh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775225169-132237
X-HE-Meta: U2FsdGVkX1+FkeTzWO4JCsdPbRUM14qCsZGicqkIcg9+kC6+oOdreu37AaHuL/G+kdc9h1mhZhcxI14L3oJlMy6pxtJiNS5zaxdtbTXaw47HNoHnwtfDChLv49cmJp5tEoIFDZVldeFy1XpIbcKHe44WJ+OYKrqQfIg8PCy4bt2n5zZTF+NXV8mubNd3D0/gQL1rN+KOdPyFhu/nLG6y9DCGzXgtiLha7d69/OTyCikBib7qjd4hMjT/lPxK37JyVqfNnlaKHy/9IPaqDwfrM0Ca662JMyjY9QVntWxWJvL1FIsuFMVlCslJrFAvLKhj7dV360vZdVzpXRTf22JiKe2Sm7c+JpJlMQEBYHyV+AVb6WAh2g8d+TXEngytQDUMvXbYVEFZ5Lip0m1mSSTHsMYs+bDcM6J9ghOhfrBH52unq/ox7+PKQ84Onc0mNk48ckS9cRaIraxgDwCpGTeYyFQ2QOCrFKpzCm2uZwmCPj72E3hUpkzN+OeU+bF3yNVVg6xUrwd6mPAmV/ml6Hi2uVfyoLBjZW5cXGvK4PBepU06pnwjB9FDq9gvKnHsoTibRQp/h2YNiOiw+8PRHqmjKCurAR3nOEQw5siExH2nNOMc/+iwSqXYtR8++VsDWzDr3JEoQKshaA/roIdxiLLQ9L4u4H8gdWycI9DsuRxOcS90ZlsPblmTytcZILrTOrgoVkwbMR+ChHS3G3Pjg+zPHgYEMCtiCKWPn4kuBxkjd1yx4gctr/GBAFVunNfg5HCjNY2L47FQEogSnx6vkxJSgT/NN/sv/zovypkjmG9dNIzWT17KI+egC1I2qWht4TrB65TzLEpOf+8e2deyjXs4PynJAyKcpxfRnKR0szpUw2xlvXEI5so9rL/vnyZM/EwS3gdqaQvpwlxifP6SWgkjwCWXOP6HMIRv97qWS+MjQF40gLwwI+bqy8zqg/KgE8m2EgivUUCXFR4wdnsyhVe
 uBupM8cb
 Zyn0Wv1i2FL4aZNe0uQmB3zY7Lx8yLbkQ5TdTUZXu7saAVvNXjLQt4CUDgaFtpu5MUcwUneCjIlAdG6XF0r/DB/Gji7/8ELbKxe9gE01U2fZ2AbCrxiWCaQypKoM66lXUGjTs8tMoqpjf/ZNvPdwI+TSYPoGsb30fVdXg4brbBCiDt0+IHIoDdCUGx0YaC1IpEswhtumHoiibgklzX4BxASCwA765Bjcq8/R7E97d5fpI12e7WXxddSc1e41WUUqqV0SA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 12:34:48 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu,  2 Apr 2026 06:54:39 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Thu,  2 Apr 2026 13:34:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > > - When the user writes 'Y' to 'enabled', if enabled is already 'Y' but
> > >   kdamond is terminated, we treat this as a restart request.
> > 
> > This sounds bit odd to me.  User shows enabled=Y and kdamond_pid!=-1.  Why they
> > would write 'Y' again?  Yes, they would notice kdamond is terminated in real,
> > using 'ps' like tool.  But even in the case, I'd imagine users would write N to
> > enabled first, and then write Y to enabled.  In other words, this could improve
> > the user experience, but seems not really necessary to me, at least as a
> > hotfix.  What do you think?
> 
> I see your point. I wasn't thinking of this as a hotfix at first, but
> you're right - for a bug like this, simple and backportable is the way
> to go.
> 
> So I will drop the "Write Y to Restart" logic in the next version. I
> will only fix the state in the 'N' path and after commit failures.

Thank you for accepting my suggestion.

> 
> > 
> > > 
> > > This way, even if kdamond terminates unexpectedly, the next user
> > > interaction will recover the state automatically.
> > > 
> > > Does this approach sound reasonable?
> > 
> > Yes, the plan for the next version sounds good to me.
> 
> Great! Thank you for helping me scope this properly! :>

You're welcome :)


Thanks,
SJ

[...]

