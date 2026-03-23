Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2022FF46126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F266B0005; Mon, 23 Mar 2026 10:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6BB6B0089; Mon, 23 Mar 2026 10:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4242B6B0093; Mon, 23 Mar 2026 10:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35BAC6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:06:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4B6E1A0B54
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:35 +0000 (UTC)
X-FDA: 84577503150.10.6C1A9A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 510BF40002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tXhhZoDh;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1fynzVfrwLMYPX1ASbJDPB2n+rf7StFOgEyLAUbNTU=;
	b=AvAB03+6WnNbQvkPE7s/kWpgj/KK7jjte94seVVWeyrmh9WzZmN7xl8RZPwKMV/li2CbGG
	VZAZj7BYOn/AclxnSYuz34TVeLVGgT1yJoYIDdO89cbjxMPW7gmAK/4JbDyjJVk3zAE4IO
	TEqIuovIo0qo0Z4JRk/Hbxhq8h//zkU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tXhhZoDh;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274794; a=rsa-sha256;
	cv=none;
	b=U+31LT5qoy+SDPYAP+ocSPAFtV2kdGVU4Va9TLG6+jh7c7vVskkFFlBa6/FbSwwvfeKThQ
	00IRgm2FBLCi+Ss4A5oletKGJerxZrY9t64AkXxIlzIpXsGsONP2nZi5c6TQ1RB1JRqr81
	dDVwqyRXiDhOGcSH/1pvexc5rD+uJWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58BD2407F0;
	Mon, 23 Mar 2026 14:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B53DC4CEF7;
	Mon, 23 Mar 2026 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274793;
	bh=kWkRZysw2zl4SGpODfVg1gRksORKKSk2p5v/lAci/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXhhZoDh1xlzRdtNioCo5fcVnBOKPPHc+KSgUrYbO3t0sBRMiC4MB2a8Ri3/h4IPJ
	 ke6jfsPtz+uLa0gJqTpRFHXy7aij0dZlbfeRf/fYknU30A919f385bz9Y+ZPVX162z
	 AQXFlIK7lpJb8BVAthQN7HKrA00jK3/wvGLps3dboqg1v/BiVVrE0wCqYjVXlIXc9J
	 GctHQ8JQu9LqET0oUeFuLFwjlVz7eKQz3DnecDARvsFU6XmQi2LYq9ZYVSR4EWmnIW
	 6qhOkLDpoqE7Nyzfh2qeUcO+exHZdP24vNi2CGFUCRpS33eXU/s/FEzyov5wHwrFQ3
	 ch3zAp7q5MrLw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/damon/core: Performance optimizations for the kdamond hot path
Date: Mon, 23 Mar 2026 07:06:24 -0700
Message-ID: <20260323140625.79976-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322214325.260007-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nqu7q7w76xhw7hgfg17q19ouc5wdfu17
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 510BF40002
X-HE-Tag: 1774274794-419204
X-HE-Meta: U2FsdGVkX19kJPTeLJzvOwX4z1LtDVqzaBOsFmv4bd7QSfpxhptySte87+99YzhPKbrV/NbxHGZyRKNYZvIKFnR7Ru8Ge/TI1swov89xE+ZuECc+s3ptceHqflRDpPIFn2pz2zjtzBo94LlezWERuPCIkAzjQc0p+MleUJg6otdovbSDeGhvUBNSNj8Bm6+iiqS+SAJABBvo84NYpx2rHqbCblzwGRUkgBzto+W9iGTd2rUFDYMY9R/FU+0oWQ5Y1e3Ysz/Nf0taOp6403IACdarAmVU+TC5hFb0E0R8fR/PRmMnmC5eowX1EmVWzhxcfqwnqEr86jieuNjgT54/dRZhx8m5VI+c4GTKgdYnaiTDVV2oEpzMPqJ3oD4sgYDej67SFEiOgPpVoWjbNIhuChCQcuBUjmawRqFsYrugV/D0CfwS5oSzVptiRf5mEkTYYhAd5oj6FoUAMAM7fk3FOyGSpe5hlKevscFQHQ7heOlu5YgL0xVDRcjquGrN85Q/gb4pmX61ze5NlGoariMOoMy72qgRTE+L5pNAxluF4bg+/vHYFMMOixrVeNjuTq+uVzoT1YrL7+4U9aDEjtUSYqA+Np5yT9S6G0PsS27OlAci0noT+zuQ/dQBMf6mVmJwLUl3YzqU2bi5ykQww3aBnI9LejicadWjLzKoW8yyLCrfk+zTqBFNiJ0k0JEU0fUqAFKX4rcdnrrgf4TR9lDnv4w+DtXXV4eAXt3BZcPo80iiNP2+/rvO9ydrj3DrnVYaFjGJ+LgFvY46TwFRfUemEw2wxp2u0mDXtFqdBqWRlZGGX4tHmlZO4v1MOkXWOGCsgPNZRG0irb7h55mu8YsaJ1bBmVVYVHGWQUxTMi0RF0ImmWPAGVomSsurvasHYDKJc9K+yqn+Dp2e5FBXzRguD6jSyqp0ALOq5z3Og1C0zod90YvzKhMFLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 21:43:23 +0000 Josh Law <objecting@objecting.org> wrote:

> Hello,
> 
> This patch series provides two performance optimizations for the DAMON
> core, specifically targeting the hot paths in kdamond.
> 
> The first patch optimizes kdamond_apply_schemes() by inverting the loop
> order. By iterating over schemes first and regions second, we can
> evaluate scheme-level invariants (like activation status and quotas)
> once per scheme rather than for every single region. This significantly
> reduces CPU overhead when multiple schemes are present or when quotas
> are reached.
> 
> The second patch eliminates a hardware integer division in
> damon_max_nr_accesses() by using the pre-cached aggr_samples value.
> Since this function is called once per region per sampling interval,
> removing the division provides a measurable reduction in CPU cycles
> spent in the access rate update path.
> 
> Changes from v2:
> - Fix multi-line if statement alignment in the first patch to satisfy
>   checkpatch --strict.
> 
> Changes from v1:
> - Use min_t(unsigned long, ...) in damon_max_nr_accesses() to satisfy
>   checkpatch warnings and improve readability.

Thank you for adding the change log.  Please also consider adding links [1] to
previous versions.

Also, please consider giving at least about one day before sending new revision
of a series, so that people can get a chance to review.  If you find something
that you need to change on new version, you can comment first about your
planned change, and wait for others' comments.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

