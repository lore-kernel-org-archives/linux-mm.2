Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F71EB5965
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 05:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7939F6B0005; Wed, 11 Feb 2026 00:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7411E6B0089; Wed, 11 Feb 2026 00:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619576B008A; Wed, 11 Feb 2026 00:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA456B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:07:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDF29138B37
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:07:33 +0000 (UTC)
X-FDA: 84430992786.07.17AE3E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7871020003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:07:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yt4r16Bz;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770786452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBuuxltTKAXl/yzZAgw0qG78+5kd3eQ5QBMaQcaGzzo=;
	b=1U8mg8d1oq0ZBQFjJaGBna1OtoPo7Db22eIwQOTGCln76FQVO+LfSe8/TO26wA3VR1Z/o9
	OH4Ndp5JUFccDHOPVYLErGWzJeT/nh4HwQ4MB6DkKHwpnz427CJMOS1t1QhRvZTQtA9Hfd
	uhAOeI9k+XMbitBZ8EQfYOkSb5u5AXI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yt4r16Bz;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770786452; a=rsa-sha256;
	cv=none;
	b=f1+t8nWmeiBVuRroSs2jxPvjLv1XwD0h2UPk4dvqzXLfWOJiP3YttM9wDLEznHC21ckJtS
	mt4MhJ8dlcpXpCvuZiaOMKvTwmTpSaDFyhNPJwNs4v+zTeI87dSVtQko98pBFfD09wp4kX
	L6AEP60vs/ctmVYnavUcNYDyig07zcI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA25960130;
	Wed, 11 Feb 2026 05:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7713DC4CEF7;
	Wed, 11 Feb 2026 05:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770786451;
	bh=UTpjsZww6YPPiWFz55VMFdksp+RP1wddMHWtM/ylmIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yt4r16BzYI4WeotGZ0dx3l13TAzZEJ7pDFFXMu0AraLYNQiFZTqgnyClgwHC6VAE4
	 m9wCXzt8mqsrCWV6v9XxCcQQKZEdNj3xYxOXX+E7P8IiJ6rUWAnsoJJ6pu8J2Xw/f7
	 Cj9giHjT3BwMx7ngk+oJLDxYVWpPr2cI69sDAU5qdSvL2aaP9A19J4apIyhCx+gngp
	 pPjfLr/8THLNbPIrmbRCoj9ydHZYAIf9+bUugyIiblY3Fv5bA6MGkbvRPnz+7QgA1l
	 U1FnOUvC5jDQ9YKZF1aB0XJb4iNIVIAK3a+pGY9wE+5Orwzsiu5I57/etCCabfuaKr
	 f8RK5y/zFN8wQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Data Access-aware Transparent Hugepages
Date: Tue, 10 Feb 2026 21:07:28 -0800
Message-ID: <20260211050729.69719-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211044533.69515-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: hxjyuzphaw43gqmosqwqmtb7r1pmpgzj
X-Rspamd-Queue-Id: 7871020003
X-Rspam-User: 
X-HE-Tag: 1770786452-921725
X-HE-Meta: U2FsdGVkX1/zKoY3QiHG2SjqjiqQefh1l0ZRl0Fuck3/TCS78vXXyKa39q3il7cizoYkFdp7pkehmbjab3wmoIc5ajgMSBNqszwc0qA73BdRG26l9En3Wy4TdgGGkwuHABV5GN0fmSUL6tpF0NVs+oH6oJG9rh1Ac/WfERVjFNvTSsj0GPCI2b+fKGdOiDNV4CLotlwAJsSDVLCULIYW2+8juOQjw+uisDWneNkr8EWD8oph9tvAcgv6i1OmGrrgxASILRvqbQ6XmJ+fdHuGn2aImNIAs8Vf7d+6sg1r9W9RxKN/1X1CD+QUtzBSt2PfTUTj7Aps5eLvIpEqj6iIqsZxK/jWqZZpLLnBw+QGzJv1OVKQnMi5utH33IsCnLpM7ptINHzIPImndYKbrt7ZvkVOKme9f8v+bZLVN9GbafPiGcnlHGzozybtbFnTmvUOJxEZnHTBwd8p4r7RDwWWL+KdMkRpsDiNTm03DcsK9b50gyWwhFzscrtOy7UtUD+m57tNRqR3XT/g7wTFp7TxfgflFj+ICs83qYQhFCfcEcHR+72lQaEpDFUQcfqSaiFIthC5TNelnRMVyNPxJL+QPxgQX1Zc79T9l4zL6HSDKfcBQXDqamGmEi7qZqB9U6KaXmJhpQGDULeQyTGUsvdfV30mqcFpgdWcM60d8hUIkgjOS2TFAi784YOra1ZUwfH7mZ7QKuidaOgvq2spKX09hO0G8b6Ug6tflCbowkYR6N+3V01BTJxCfVIKUj+2Fxs29z/J3vXwxJ9CxmWXuYpwhqQlIRxyEnrGKxvy/VrG2y/PZzwBsKym12Bkns2SMbGpne2fxDVnD7shY9xieT5KuYjaQWNNoxK1SKzEVZpCLhXZ2sxgKKALXAHLdikybVerlKkZkWwJeLUjWusrBX2x6pbD+2fHfG/ZKROXo7hhcNSNYsZj06/W2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Feb 2026 20:45:33 -0800 SeongJae Park <sj@kernel.org> wrote:

> Forgot Cc-ing damon@ and linux-kernel@.  Adding those.  Sorry for noise.

And lsf-pc@ ...

> 
> On Tue, 10 Feb 2026 18:28:55 SeongJae Park <sj@kernel.org> wrote:
> 
> > Hello,
> > 
> > 
> > Transparent Huge Pages (THP) could be more efficient if those are used only for
> > frequently accessed data.  DAMON is one of the ways for fidning such hot data,
> > and hence there were interests in utilizing DAMON for access-aware THP.  A
> > simple experiment leveraging MADV_[NO]HUGEPAGE based on DAMON-identifed hot and
> > cold memory regions was conducted as a proof of the concept.  The experiment
> > demonstrated [1] an 80% reduction in memory overhead while retaining 46% of THP
> > performance gains.
> > 
> > Multiple discussions for further developing production level access-aware THP
> > solutions have followed.  Most of the discussions were made in private, though
> > Asier recently proposed yet another approach [2] on the mailing list.  As a
> > result, we collected interesting challenges and ideas for the production level
> > data access-aware THP.  Some of the ideas are not yet public, could be
> > controversial, and missing important things that more eyeballs can find.  I
> > want to discuss those in LSF/MM/BPF to get more ideas and make high level
> > community alignments for next steps.
> > 
> > [1] https://assets.amazon.science/b7/2b/ce53222247739b174f2b54498d1a/daos-data-access-aware-operating-system.pdf
> > [2] https://lore.kernel.org/20260202145650.1795854-1-gutierrez.asier@huawei-partners.com
> > 
> > 
> > Thanks,
> > SJ
> > 
> 
> Sent using hkml (https://github.com/sjp38/hackermail)

Sent using hkml (https://github.com/sjp38/hackermail)

