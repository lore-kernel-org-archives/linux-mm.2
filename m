Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D5D606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nE4t4pYg
Received: by kanga.kvack.org (Postfix)
	id 9B5E86B00EF; Tue, 17 Nov 2026 19:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9669F6B05B1; Tue, 17 Nov 2026 19:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DAC6B05B2; Tue, 17 Nov 2026 19:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 686C16B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:20:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B763A0611
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:20:10 +0000 (UTC)
X-FDA: 85446332580.12.915C3EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2C31A000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:20:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nE4t4pYg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRw6fEvSDbVhRU8qh+aETvS7Fbkzj3KZVD4IK2wFBqY=;
	b=nfMvpRQs1N5L40vUAM/TyBHOMYVlSY9VVJmdHCQOdcs/5scz02ioATHSBLgzwTFzvlGbPz
	JCC77AIhZZppNb50cimnbGlo2Ff1kQ1GAA2FCheLVpumOO8BigreDlAuIEhMui4ZmrUg17
	FeOFaBTwH5FE2cgVGwCnP5BmTrL5aMw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961208;
	b=LwdSK/5XkH2ETZKyuQ3STIMzIagYs6igBv1f1pgYfKwf7eHtumQOD3UUDWscuiIBo7X7sb
	DEytwMrGDaD9NGoS13zDbxrcJzFpdQQT6PKXeKDqaAfLyJwVsz5B+xoMfjjAS3iVeVX7ug
	uj5geVBgfqXJjtETHRb4cfaDH6pdsZs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nE4t4pYg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FD6C45609;
	Wed, 18 Nov 2026 00:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929D01F000C8;
	Wed, 18 Nov 2026 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961207;
	bh=JRw6fEvSDbVhRU8qh+aETvS7Fbkzj3KZVD4IK2wFBqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nE4t4pYgB1yY9ZNJ1B2RKAkcSkBbt2b+/QxmUfj7BRSEob37v9uJVwIz21Mg+WLYF
	 IYdeailZMAmDZJSHiBV67s+AYO18rH1+21VTDvWQMEAm3MhuIKQr2tRMJ+iR5k6If9
	 oBpllGB6y9jz65V9BhzwSg+Bsd7KDeUe1MZ4i1AXJ0h2OyRioZzhCUXfXSQ1aQKtW5
	 Rwyuayw42nLJteTG0zs1fcob4RnjyOeDjZhlPtGdnkHZm77lKekdFigQE3Rc/QbHyP
	 EIc5CI23OVudhX6KrRMXjIPpRU6LmiSXUasWGvFxuYJ3epiEGHaTuWO1Q1BChVzKth
	 aFr3DEGeNKZtg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Mark Polyakov <mark@thundercompute.com>
Subject: Re: Backport request for 6.12.y: mm/damon/reclaim: use parameter context correctly
Date: Tue, 17 Nov 2026 19:19:54 -0500
Message-ID: <2026-11-17-1-daily-reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com>
References: <CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C2C31A000C
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1irmji5doa9h5d89pw4o5g6ffipi5duc
X-Rspam-User: 
X-HE-Tag: 1794961208-672873
X-HE-Meta: U2FsdGVkX1+Ck7av4qTW+QjSNyoF0cb2g6xUjS7baE6XhgKdIOTrodYpYKETWCG69az1mixMJAmNrWUtHRPSmJz7f9Jpq5AT2E9zogkFZMQRAXw/aaIKl7XFjjNmpYRJEoL7Od2udPyXtfailZSoFBh3NQ0MKscpaMrjiaaRP1u/Jgye3E8KzUouIdKm2NUnzbit2tf2jnRywE0Siz17X9XHmDPZ5bW+ALL2yxPKBGl1kJLqv4Q2RlVzWgx/jQaDIhtmsowC+m1aXeCBsWYsqU5tt4u8L+W/t6s8wCzl5OrhEJzMQzNdU6WJ3krrKeAgf5ZjugLY3jKVF9xGDlpj+l/6o7qc4HP/z42U6O0S8a7SqicaUBjGlzTe4ljawaL5MBd7SuCJVBgtqPCSZ48GK8SfPgNf+HIL4nab/VIlknd64hZBpahXT4eYBCImApnbwmx7MO/oEuw34NPj1TsvMvY9dAf4H+LkW9OxiI6iLte1KmkTY/o/ECqCY87lPgUQ8v13tY52P74XjE2CocMO0V39bqm5xlTBqeud3cZShSVsCRmX5g7G5Q0ziNQXz8ilzh0vR0rnT86HWk0hjz4r8vrlvObEheuEgsKT4KBU3+GneJgU+oBbQaD+s5Wu3iSoksvXQiWFg3xkAWBBtctItdsyPoaNwW7W9DK4IvDplC7+zoU98XGMrYGyvyIeZG1lYSDNoqa2bLKqILoRFyZYPzdD7FsJaO+Ul7JHOXRi7/nfS3/s9doKIftn90nIZilPv+XYyZ8pc51a/8AMntesZyLOZQMiU/0YYIJqgJk3WSoVYbAzFBC0lckJS8WKdQyjxZ9rrWsztpkkpMUM3X7sy7HwYu6e2HspJVeogzDScXrfpp7Czw/ovhhJCWxmCMCzTn/H0V2v3IRx74w5f75Ow3hhNTkEsNtXKSshyOoVZ7HQJO76rVGTXWGH7z0asm84v+16l87klciSeMZ51dZ
 w51SZzgz
 ocDYwv0MFIszh+Z3gk1Kr196ptvLS114QPDG6DDY3wnX6A92q1U5wyZHdWgoWL74gjnlaE5AysPV6aHqLDv9TmyE3gAjxXmFG9VvGZL8iu0ijA5wl2TItDgMwtkXh0n1U4Zet0yVmOXjtGfyO1+kJbFor+T40IOENsaySweU7JjCOawq+iPkcisyqaq2imRRqYI8jA18IUFQghqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> It seems 6.12 gets backports of most DAMON fixes but this one must
> have slipped through.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

