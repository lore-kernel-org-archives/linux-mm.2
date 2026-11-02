Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0DD606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=NfCzOQUG
Received: by kanga.kvack.org (Postfix)
	id 022906B05B1; Mon,  2 Nov 2026 06:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15136B05B2; Mon,  2 Nov 2026 06:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C2C6B05B3; Mon,  2 Nov 2026 06:06:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0DB76B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:06:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DCBB40C86
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:06:17 +0000 (UTC)
X-FDA: 85389899994.05.A2B8DF1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id BD8BD40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:06:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NfCzOQUG;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793617575;
	b=WtHTrDqP7yQ6aEm4IpPhh/KqlF8qwS5E+xg8wZDO+jhIwqkRUNtfzvzOdQ4tScLtOc1GFD
	cs7Ap9muKyFAbgcnO6em4QxU7n2qGaexpCF1fjvPvkEN9wz5umkVVmgUjzB0xEhurT1vLV
	gGzDce08Ka4lqkllAmOgOt0nddOBk4A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NfCzOQUG;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793617575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhafRCmdfcdXVx4Hiqwg3dcxBOA4joIid0EOAjhKCP4=;
	b=5ECsHIxo7XIGWY9OG/eJc7AvDEBXLG6gCPIWEXK3a9OCF7EG0njHttIMFTQMh/8cS6dsUL
	bCq8HjV2AfEY4UEjsgZIB/HpCytvYHh349MjIC9hP6C9sRFyhyP32yOdcmv9Slfv7YdYi1
	bpZjNBQMX9PFPOynUUHIltpvy1FCvMg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bhafRCmdfcdXVx4Hiqwg3dcxBOA4joIid0EOAjhKCP4=; b=NfCzOQUGQuNL9GGK3rskljQhUT
	mhMnRXAQdoB9mzxfkX9TOncmoc1D4+LXQGz0+JfEQbb8QoOLL6umIw3/JP+2+1g0ZnIZ8yDBDHVfT
	jxYQr4jc7InTKzv2KPzR33lQpAiB2levlSH95fHbqhmRREWkhEBq7uKRELIB4iVk9sD3zyHy0uHwN
	R3ZzKAC48Z8UR4HzCMDmotNdXVWtsPRvee/KC1I04JG8Jq3zwGhOFM9JEBVwpvX0WryiSJWlOYIJL
	t4r8w2uFk+ICXi3+g6MMF/6Bo8/EXqnHpGF0sh8pnqG3c/4b4Ff3zoeFPRMcoor9t8/ioV6Fp8S1L
	rl2ISKgg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xNprd-0066zW-2N;
	Mon, 02 Nov 2026 11:06:09 +0000
Date: Mon, 2 Nov 2026 03:06:05 -0800
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: kmemleak: scan modified objects as soon as they
 are grayed
Message-ID: <auhuASGI3Y30ERpn@gmail.com>
References: <20261030-kmemleak-gray-drain-v2-1-3ec29a96668e@debian.org>
 <20261030120625.c2aa64b3e6378a2e78f2f676@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030120625.c2aa64b3e6378a2e78f2f676@linux-foundation.org>
X-Debian-User: leitao
X-Stat-Signature: qk1ixetdph4y98khbyyy13dmo9h4on3a
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD8BD40003
X-Rspam-User: 
X-HE-Tag: 1793617575-199436
X-HE-Meta: U2FsdGVkX1/eaTHSpOAjid8ljwG2GAnC+cBz3cbaRyfXqEb4x530su7MyW56l4Pfo/kMm7jQLgOJDbqQ4kTPKuWHQizS4CAFx5UPZAGW8gDCnac1bYMwIaVjHmhSsld5TM8CbMOmyppNUXUJpvVe22p8mP82pj/wn9r60jbBRrR0RgLr79CJm6fWGgGHQxOTJF4WxQJSDd4LnSmo+r/QswbRqYyiWgyXNm21AaGeLN2W0yGxckdih5XPXXAYyflwzzVI6KX1+z/a5wB0uBfZ0dSOmqynAlQg69onIjFGBbJ8Qh19QyGOdXrDkdArK9+7JjuKn1Fk2eLjjEySqEHyXu0sWmUmmvMzTOz+G8W8cAxJh2Qfclifi4JjmXbHyGn2yht5P8xdG9sU11KMDVkojE9gQ/jhx6TEf/8I3NOOJNhr4KXhKBMTRrs7nZbP05PxsYT3/UwE1zunsv891nJCW5SKo0/g56ErrUR7lfrrRQMfOOgPrgwT4rqzD71DPdDEg65QNL/GLU7r+cUOd6esHdAO4wE//c7w5yQTV4Oo1aOnYMhd7w4xZNeoPyjrQP+lgLA3FVmY5oYDzuvVJ4SlRk8sd9iTmx1ARrSf4OkGwULm+y/lq/fNDBJcEQQz4foPFTkm/BpTK/3mtRS+JKhyLvGQBWxqCSzBPMgk6pA9XOUzcnL73Z+gBIdMZxHOMP6qjMWReK7JwmKovLWQJqdIKMg6rncu+smjJLsnrU3/RJOclWa2JYLZXu6QMTXgjHObKafeEH+zSYHkLQFm57jiPO+Fn4SoOcanosC7PbZiHE5skp8NRtefIPUqAQq9Wg+Q9luuQQ6idw/DzwUs7Yv40ffpwUl7jGMJZmmIlW2jwXU+C2aZlnwSfcPuVcSSC8LN7aA0NUn+oE+IQmSnsXSIhWgJ/lgc3doI+oeRkleN150bV/QgsrtO0yDp+YYDuubA6f7uLBmpwWJ0qNIgvgm
 o04uysQg
 1NAwk4iWSIkaZKPvTFkASlqxiXXTVkDG0gMbdUDpEB7wt4B642TO+E0LrZacdkAoK5MS1+YEvh9Po/KKbQN48Ib6+31+6Z04tMbPkzPxt5hIMYQ8hi1r/ELammxNPMH+HDYnuOAyO9A685zlHQSucESZssOi7w2uq8SSeBUkmcDrdrDvdnE+K1gv30h/CuER+PcZLaya6u23YDzG4qThZ7rZU6HvD/t6f2OIwN/gLqRh6Y2Z4tfaFDL33t7SZ2q6O/BpiKtHkQ5Pt66P+Tx2y7j3UWG61L0pvnqGJ77qdXCVN+Ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Andrew,

On Fri, Oct 30, 2026 at 12:06:25PM -0700, Andrew Morton wrote:
> On Fri, 30 Oct 2026 11:31:10 -0700 Breno Leitao <leitao@debian.org> wrote:
> >
> > Scanning the gray list after every grayed object made a full scan 41%
> > slower (1.72s -> 2.42s, arm64 guest with lockdep) when the pass grays a
> > million objects that do not point to each other. Scanning it at most
> > once a jiffy keeps that at the baseline, leaves idle, file storm and
> > mmap churn workloads unchanged, and still removes the false positives
> > at HZ=100.
> 
> Thanks.  I'm thinking
> 
> Fixes: 04609ccc40c4 ("kmemleak: Reduce the false positives by checking for modified objects")
> cc:stable
> 
> Agreed?

Maybe, I think this is a another new way to fix false positives rather
than a issue/bug fix itself, so, I would keep the Fixes:/Stable: tags
out of this one.

Thanks for asking,
--breno

