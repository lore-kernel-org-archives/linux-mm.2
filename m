Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA366CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671D98E0015; Tue, 19 Aug 2025 02:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649BF8E0006; Tue, 19 Aug 2025 02:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FE68E0015; Tue, 19 Aug 2025 02:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 463538E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:26:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B956157CA7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:26:54 +0000 (UTC)
X-FDA: 83792523948.30.821F724
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12129100006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:26:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DhhGe7P6;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3L/OgLnOcSI7x4cplo9CPMAzqlKBWESQ3/91Rjh12eU=;
	b=y8mTsZcN5ecV7BwuUZHBfBU20cOnTZ6Tjy4C9Ukx3kctzoTxoKxidcNIQs5WElsZS/9oEc
	y3Gm1PiW/TLFl0bjUCU2K/sWJrsrYdLPptXj5Ka+CAaF/hQXs7S7ackRW2u1g+5umRaGOd
	Sf/NFP5uMJp72Fi4AXcPo8e25ja8gOQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DhhGe7P6;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584813; a=rsa-sha256;
	cv=none;
	b=KWBNgzqGc/DcSIeOHARRX9bo0QA6nazrlL4trK1Vr27+pAe58pdC2nbnDO8Tu8qpYyeRlO
	qMm1ZyVSsTYg1rh69llPN6hJwSSzdUgDK9e5w591ZEHyISPyu983PnVJorUrqp4c29bTnn
	wqTmi4apAT0NSqaaK7rk7q6kBrpHRJ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 479FB5C4C06;
	Tue, 19 Aug 2025 06:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA0BC113CF;
	Tue, 19 Aug 2025 06:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584811;
	bh=kicNrrCw9YqQlyRsdO1xeCQwRKp96LX5HA2F/sl3g8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhhGe7P6CWp+0SNmU1X/6+oYjXC6tOXm8S2Xmzt59FjlOmo9SG/JlIZW1/wzy7BGs
	 L1XVEN4wMOEp+mwsyAJ1ljT0DqSiSKdubOSsq2zn4RSIjWIAHdMN4mRj8et3f8bPc/
	 ZHaHA0epbie4yaRa7TVPJ/HMKYbAYn+Z2vGtNGZEI3jHSzmS04ldpNkyafgCFng6dG
	 ko6fcqpCk5Qwghjv64AmrD4yZCTTnXf/v2TCHG1FPkxWrlHHMaQtJc3E00C0Roxzc/
	 cb/kXlN/CQqGYAtAxAW626r9nKnBABbzx8OWd078uLXddurSOJgH7wfdHxovYG7pS6
	 MPQobp+baz0/Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 04/16] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Mon, 18 Aug 2025 23:26:49 -0700
Message-Id: <20250819062649.40079-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819061952.39429-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bjk7ksonqjeejmd5rjdxgrg9gzh8tgse
X-Rspam-User: 
X-Rspamd-Queue-Id: 12129100006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755584812-345617
X-HE-Meta: U2FsdGVkX18Qcn2zUng0PHIG95iM32i/brv8XsnHw1yPc/mS4hl+RZZhZx9bwChBJ472FPmW0QxIUm5cSbMLffnJFPHgsU8YxIo1i/Y74ks4xRo0LpZMVWqvnnAsQytFn5uhh0YHtz3rNlZwkacl3TQusaEw945L3Da4T0OT5EVkN0cWv+cqzX/5YtyckuNn45ffZL3K9VnNN+JGcgE8W/DmZVGulb6pj+6HyZ/Gmx/LscLI98QjtwQVz5Sd6qeFN1jWvoXYw7j0F+Lu0wb66FAw3ZhNNskQ+q+GigDEpbEtXZT6EmQFds7kwyGlWLFCVFmf4zVGuaYdC24KOaiTd0HvNMci0PRANgHHLcaEW789oHmRI1/l2LsRWdzIR/9mK5I+WD9WpjCKmsdlChFlTlZlxs9BCx8c34fKxqV6Js1xPJ/SMmrlQziqCedKO3YLyu+BkNaCwYWqF55uYgcVj6xRF2RVJTb0yFUsIvn0CtHeWI72PrqeRdQ2cMSk8rkQDj8KGjzlA6OJEwwOf3hGmhbK/zY3NCicP34twShu7/H3kIi68zdD20q+VaJFqADPTFf7TN7TAq4WfaU+dPjZufV1rjkFHliTSF0qDMkETdxCFkTjhaicYJpEffVfRbUKOWVVSOhhvf3cBPecYUOYBJfvuOyKEYAT0NhF1XPQztJOJrwlSVdBLvb8/4Q7SzS2euJ+PS4nutZBoV9NdhyRi80jVmHJhwTe+jZ7XSf5qtneRAAqBUZnADnJyV5q/AQXRs0UoJJv/tLwpflV9PzWauJ8ZryfiNnrpx25RpsgjR+n0KvxUMRDkJxgUdwbn9fjxXzYAJ+RQnodfhlT5itR6O+8f/jmWK51trZ7iWmVXJZN428DZsc5LN+Z7sGy0HzoAkRBW3UpdnrY5lp5jOe9qQQm50q0WjM74lBwv5RnUuclhConFdltUVWOpQqus849AR6M6l7bfOgr9Jqnws9
 zQyhCkJs
 Hj8vv7f5Ehj6qIl2VC2RXKwOhEkxesO420CFFo1LWZ2BuJwkPb5v8uEC0P+3Hdw+W2MfQQTTAA24g34TK6Iaf7Ex0rXe3XCxRXf8uNptgn2VDUwE024eJ8Cjv1F4TCHPbHIC0/277dt2JkyUeEuD+Gydn7AIIiGptqUEeBtyu5optHnx8UFSm0L87x3nJ0R0a5N65nSNYNVhQSyJ68eHnVQyG6hftAhP1Y27wFii7EwQxA2990qhQDDQ5nh/T4od9OkYlrlVW8JQUxkeOKm5soiuj/FsG9joeHjAD1akiw8NURQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 23:19:52 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Quanmin,
> 
> On Wed, 13 Aug 2025 13:06:54 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > From: SeongJae Park <sj@kernel.org>
> > 
> > Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
> > handling from the DAMOS operation implementation for the physical
> > address space.
> 
> As I suggested on another reply[1], please squash attaching patch to this one
> when you post next version of this series.
> 
> [1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

Sorry for the above wrong link.  Plese use
https://lore.kernel.org/20250813170806.6251-1-sj@kernel.org instead.

Thanks,
SJ

[...]

