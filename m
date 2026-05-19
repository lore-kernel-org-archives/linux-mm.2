Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D63CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BEA66B00B9; Mon, 18 May 2026 21:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496046B00BC; Mon, 18 May 2026 21:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB6F6B00C0; Mon, 18 May 2026 21:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28D8C6B00B9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:33:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7D431C003A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:33:43 +0000 (UTC)
X-FDA: 84782447526.13.388DEBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 249F1120009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:33:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHkOM7ei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKhvBnjbEhbxc7TQFmpLjrcHhibKGZ6zJUHRBkAOMbM=;
	b=6Gb+VYQ3Yg5Ru0ww6rL0BgOSFdFQp8TfNe/mC/EAQbgk3VeiM7qrgKRpxEhKLXGMZAnvWN
	qD4GlzBRkyrTcOMTTxKCNNewpsrRnlcVMc6pGfr9LbHHNeNN6Q0FIhfABz//B/uNZq1YOm
	yTLLvNvXnGktq9oDh/af3312xWUojzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154422; a=rsa-sha256;
	cv=none;
	b=hdWQFK3zjqcP3PKLwY7EjUQWTvOOzf+nhgKutEYn8V2WOjV4nXmRDqdcjLBm07M9rz5Qg/
	5oAu2Pb26XteP7NffPAj4IV+6Bp1RjQMiivzwlf6aw6CRlZXuVNEcOAz7fKZ/D1AHGwhvN
	zDxUPVMc6g/Rlpeb3v1h/KXlbpjcVC8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHkOM7ei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 013B940308;
	Tue, 19 May 2026 01:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D97C2BCB7;
	Tue, 19 May 2026 01:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779154420;
	bh=oO9rfzgD0i52SfOvIc9QVYCB//UoPdVcUA7wcbwKLNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHkOM7eiYDB731zItDYMVhyw6LPz/p4X5HD+dTFN2F3kFpBcJruV7mtaqQRskiZue
	 J//5oFKSRd0Ml7EVOoDP1PUk/BqBo3d9yKNFAygZgEwzm0vf860xt0Ttsp3uOUtxcQ
	 T2clRMy5K9Gp1nKHJrUkPZXwzJUlglKKaPI6ks5LByZM1XaeVeZYlAGEv3pG5etVpC
	 dEBqA09oPVg4H4BVOtJWMLvH79QkuJ3+hjW6tIRBK18/0o2IR8hHQZkx+uqaPXzrW2
	 74MtSJ50q+NEySjPH6yLJJgcykUAV/dZqG/ZXnnBxZtP1Un7ai0+xPeU69rIGYw4T6
	 L/Gn1uGh44x7A==
From: SeongJae Park <sj@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: drop a misleading __always_inline
Date: Mon, 18 May 2026 18:33:33 -0700
Message-ID: <20260519013333.102801-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 249F1120009
X-Stat-Signature: g15mou5313i4n4o4kjcw1qckhqo991ni
X-Rspam-User: 
X-HE-Tag: 1779154421-878688
X-HE-Meta: U2FsdGVkX19xC2gszroPZNh3XK3LN1q0/jDud9npuVppKggfkreEDo1qCCfCzRusv0iUhMPfRuWbGrxeoFJYsHLRFsab4eufd10x5ty3HxYv95RvjupZcYIUdcrWdf7+3pAAyyiVDsoX1cji9YlSXL6r/ikClZxBLz5l66gO3shWV7jwif/MWG4SOsz/KGnjtO4ijz2CV1/a4iKusQ9USmLfwyucK2xdJQX5yrS4kP9eCr+zRdzAMEAOyN7u2WEdpygUs08eeuuzWsrLnB1QehrozSpw44OBCstm+UL8pOjjXi1k8Jhf9EhXRyRcge2fhXryAe7haYkZzdpFYt4hWotDq6TJMsPaUykzsmCWpNBNM372FMFM5PxlkVBdk3TcHCiISZVVPMEFXlMaZ2t6I0oqoeQbO99Gz7DV8EMsQWnQ1fqktEaa7XYy/kNSbFWRf7bGiKBMI2u+x0QD9z5K84alajAKGjGlyz5ADILGDdcu3tj8ztCw7IEMMWqzZjsC5eFvdjNsAbOxgU8MIdC0uemOwreuxOkZuRHD9ErmXpmvanIPJ/NCpGMKQSwQPuiOki8zkGsEwqwPBTjfj25J59zzCaEkIxJOw2o31P+Rm+PHLbZ/BmRdpkyEUgk1B4l8PS7NL7kKTkDxuixA2egl1n2kON7vHPeS1aZxaTlupecX4Zq2QIEUHC/F5Ylj1xyRkxkZoLejdGV+4SEVhnf2zHbzg9BHgD/777+T8N044RrbGX9C5ZHJb7qkvxstXu42G9ZD4Ehn97+vxXxvB8x7tjeokE7oRVQGmoBxsuO432P9G2OXWNHlinrWkBOnnXnYs2mfcNrxsjjuKgxXqeATmHgMk2PV4QjzzXGmmjwHfCrZgs7ATav9eXg87m1ibcp0eFekvXBuJbL0Waur7ilNCE/7qz9J/WpgyAactDTvsqr9a6E4hZVlk9E815BlqWNxuMayHiZtybT0eE3pe5Q
 zcwKGegW
 Tr1KSh+fv3U1dDiV3vaG438LlruxIUfi6PGAKMrV7EMKp4/Qe60y20Pyt7KcDe8qrNCQEOl3Dw6a5W0Ps5NCvlciCbEY50ZA/25gArURn9aDSCWJOtHeuPIIITUfDQYhEBCTL3mlFWG1v0/Q62n0tyT0CEAU9J6A/BzdCeOP7+b+f/4EkncM/tVft0bEo6/xGYzV2gp8h2tPlMYqIV3RjYkpK3xcVhTmEFlAxojhmkpJWDUtuiltcj6kzI1DQgWGEova5g8rVJm1f6wBL4U7QrqXz4yTwQezCDMlBe13ZpEZ6bSoYG916YyrjmoXM5q95N8yfuzd3vahEM1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 23:37:05 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> get_pfnblock_migratetype() is called from outside page_alloc.c, so it
> cannot always be inlined. Remove the annotation to avoid misleading
> readers.

Makes sense.

> 
> At least in my minimal config, with GCC, this doesn't change
> mm/page_alloc.o at all.

Same on my setup.

> 
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

