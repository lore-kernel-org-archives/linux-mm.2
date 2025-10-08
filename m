Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C38CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621AC8E0047; Wed,  8 Oct 2025 12:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9508E0002; Wed,  8 Oct 2025 12:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536A28E0047; Wed,  8 Oct 2025 12:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43CD58E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:29:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C710213B7DF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:29:07 +0000 (UTC)
X-FDA: 83975481534.27.869EBBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1F332160010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:29:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t2WFr94n;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759940946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAlWkXP8yoPSFJfKOYN2IH5L0uH6at3rppYy1RN9XCk=;
	b=IKyFuftQ6GioZs73RUvczR3Ivl6qHrTasjUIENaMBkXAbCs66ompmFOJkbiQmjeXwQ1Es9
	nTmY5jpBei5+jQRZD3IN+fvzbTwsAnr92uy/7/OMlrDfYdZj762bk9699lXhhwji4WyXQh
	jxgkz+hseQyiSl0dFVUubA47kyhQ7i8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t2WFr94n;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759940946; a=rsa-sha256;
	cv=none;
	b=dPCJwL6112WxUEh+az+cTsfz22dZzSH2nvIasioOPSXfFN+Ufnr4E+wNqF2jmiNlNdEbme
	48wRkUagbe4v6spHqLJw+aFlrRbblYhXXLWVuwP+ELLxovSv0j8XYsXNyvBYWxXl9tCzAA
	PkuNjAbM+h+lfp+W2jvCg2Rih2QIisE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2D0345796;
	Wed,  8 Oct 2025 16:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EF8C4CEE7;
	Wed,  8 Oct 2025 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759940944;
	bh=JVQxE9TnJdgpGTrkD0m9zQf/OeSnxvr0yOVTLH/dUZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2WFr94nH31O0NGpLab7G3P1+1WO+wC/oYzHcqO4iw18yOqKIpSpCr5qKVijWddMl
	 mUze/11E8cDL1vw1ibXJtuKSwSyjFvfxsum9AbJNGF+omAtGgef2NqT5SNQt39jDFs
	 QvIS0gqFcJHwkgTzXTfxInEygAgdUZXE8Q7zpBmw/VDRzPhrsCCB79iESd6UFkiTT2
	 DVQ/a/ftenFCvPV48lZWMTLNpWcCIpwCaQjg2Fm5J0RMpV8sKOzRqru3CYC0oP9aAj
	 bl+u5V8Rsw0/5EhZ/EGRkLKmyjaLP+YT35q+92T2xDz6f76No9WsFdt4iPSo3NuwvD
	 KEiKT4Pjqy9lA==
From: SeongJae Park <sj@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Usama Arif <usamaarif642@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Date: Wed,  8 Oct 2025 09:29:01 -0700
Message-Id: <20251008162901.6652-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <x6u2afqqwqpoabtpq24n64owlwagolt63csvaibg33p6t2ywuf@beayabw66enb>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ynzxx1odbfp7fp8djyn6jj3x8fw3s3gz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F332160010
X-HE-Tag: 1759940945-4480
X-HE-Meta: U2FsdGVkX1+jvkGKMIipIKbTF18RRV4eHiVvTww/mcOLibndBSFHTnloTkQpIXOkNIhdV9Hk5ScbDLcakfUGFwOQ2xAbWLTlLaNgT2fqIZftZsyH6tp0F2rZjDmkxRn0Jfum9KzuieOqX3wp+KIlX8vqLLdYPxKv7hSvr2cQs+SCi4bNYAbBqrIRnBN53jry80768XQA8TkPKpBYTLujIxOa9Coh7d1aGRo8MCfw17bg9t4umSyOYK1MJzAAxh9cfqSplJ0PlPF0g59bPVGEAs9ATIR4rEG8SLn2eHWq9ioivuzZ6+YoDEzioV1Zyx5NxUTgXCGV/9oyACMj/LD6xYuDQYbpWJDuw/LTIqiBpQw9x84QLTj98/YoI7ryPhSqvyt0HlcObNgM8iNDf/whFMofqttsp8Y3Bb4z9cjlVLz2ZNn/8pZQp4FtlNzBX0/kdubuFldMvpVQidt4cNjWeeak0RXZX7UaNcdc3OYdEreIme2KngDE3pG+pAjktDpLiYG2IcNVhardXP7I82eblnSI3E4QXNB1tZ8rR0TmfQqrbtlUCJxSrx5HsusfvaePf8P0hyDeCJjIlR1VAY0qnbxk6pk7+6cS12Q1x5R8UfZOezqsnCTLIT9oboln0NHGthM3yKJ0EYKWtuD98ZmKg31q1kXG72pUXEWFto348uRy9Jn9N9Hr1F6U+NcmXjaVud9ysIhX9f/XAxzHVhXip78DnBFJfz09osHYqh0dA6kB11gDT2K/netcuHJyM+jn0EtosZKKHJIQGyYjTmXmZxifN+KPom8mTm45byMVj4PcmKLRfTyf0NAjO2dUeY1tREVB3I0nu9giv/oruwuYqf6m3ESyQchPygEvdHCIV2FsiWuVH+61cZKP3CJ5VaX4eOcvB+2GRarWJAqGk90P/4tvy05QlNSQrWI6BwnMhFuAyiOXt+Fr7oEYxHw7/PuoRo0griC8Btfy9taE5fw
 Hjd1JJf5
 qtHW8b2E+bGvncQKeh0qB/Szg/x3VJkQIht3PAK9uxlqx5PovS6H5BrctfKyDQM+OJ/r9vz3hN1h3bV3u45b+ku7BjahkMIhBhJRrs8YghIjsp7FOnu8M4P/VBnYP7u8dhGAlb0SMNtfIMPLXF5AEvzAxIaC1/I7awi/1u17wJXgK9KRkVMt0Re1fS7o+0hSGKbqn7B8Dr3II4yv0H7Ov8A4iXmy+xtW5Gt+lkqvzVwr9GebrX9bDRcZF0pnFXuNK2OdM2twNtXKHo1mGOXrabU9b0NwgbN32b3HUQSQpoyWzhpm3VxQU14XkamXpJpO5fYQFttycI0TrzgeDvXpnPGkWGKTey7qWIWcepIMz8Wb+1FdKV1Il4qA90DgybSX1Ix3/1FuHOsXNpPthx8Ud+bZO9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 11:33:01 +0100 Kiryl Shutsemau <kas@kernel.org> wrote:

> On Tue, Oct 07, 2025 at 12:53:13PM -0700, SeongJae Park wrote:
> > On Mon, 6 Oct 2025 13:25:26 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > 
> > > __mlock_folio() does not move folio to unevicable LRU, when
> > > folio_activate() removes folio from LRU.
> > 
> > A trivial opinion.  So the user-visible issue is the incorrect meminfo, right?
> 
> The user-visible effect is that we unnecessary postpone moving pages to
> unevictable LRU that lead to unexpected stats: Mlocked > Unevictable.

Thank you for clarifying!

> 
> > > ---
> > > Changes in v2:
> > >   - Rephrase commit message: frame it in terms of unevicable LRU, not stat
> > >     accounting.
> > 
> > Yet another trivial and personal opinion.  Adding a link to the previous
> > version could be helpful for reviewers like me.
> 
> You probably missed recent Linus rant on Link: tags :P

I didn't miss it [1] :)  And I pretty sure Linus wouldn't be angry for this,
since what he dislikes is meaningless Link: tags on commit messages.  We are
discussing something about changelog after the '---' line, which will anyway
not added to the commit message.  Also I'm saying a link in a general form, not
specifically Link: tag.

[1] https://lwn.net/Articles/1037069/


Thanks,
SJ

[...]

