Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2A3FC6165
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 23:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C716B0088; Fri,  2 Jan 2026 18:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A1F6B0089; Fri,  2 Jan 2026 18:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322206B008A; Fri,  2 Jan 2026 18:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA5C6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:56:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C70C91610A0
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 23:56:55 +0000 (UTC)
X-FDA: 84288686790.06.D3D7C1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3DF2640007
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 23:56:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYIYmUu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767398214; a=rsa-sha256;
	cv=none;
	b=DudkaY5DAiIKxeKvxHQcSUpbTOFth/KgTVw0e06eqQSJnVAwRoXTXuqMfJLSiHt0Hv7UoC
	HklWk0/qJPJEd5jt5TfuPwgbI67v2TpKB1P5nn8+xalCmlBHHno0cspik1Y4ilGjBaI//w
	r7+e+4RDUDFK6ukuw5i7rW06aag2dHU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYIYmUu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767398214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvEvWIniVEkgq0NPCD7flwQa1nehW2zJLcOBtAKFw2U=;
	b=qCEo7iAOR/6IZpmydkbyuHmslTZPAV7e0e1ibFX2BbUdNrL1Ghb2gz/adbXl5CkV6/Ao73
	UnFV1Q6Piam0gJNBHU0cy9RUe7UnwMzGyJBYRW5JEzbhCF2Vc0vQ3Vq3OQr27tj9fecp6j
	5dDsoxSQoR/hEQZuhgrrPaaTiC5221A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A8B6013C;
	Fri,  2 Jan 2026 23:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC3EC116B1;
	Fri,  2 Jan 2026 23:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767398212;
	bh=ybuwGpGfbUb5DnB9ItAV/BRz+NyDNoypHSY4MVr9kOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYIYmUu5TeTDkbQyjKr6SIiV06oIxmu9nmgM9oNxPQs0EY48rYPptaGdzqyI+peiB
	 krEuYKQUc8r7jJ7w/hEhrOVHm34Dldm8Mo2zjcAl37CSYxJcI0sGy6Vj8gWr6dlCTg
	 3nlZDjQV8UslZDXf5P/yyD3GK/j0ThK4fj7oeZlUivAPZ6a8o5KjkWLRmcTdWAh7gx
	 Ad/4pqkLum46gVJXVD05f8S3CGaKMTtEvAWfL6NCuuzx89vbP8x57vr641meLutwFE
	 nk1BBP4BwTrlOrfxGKJ5sNymnA4UyLY89TRJIE4s+Hxaqy+PIYsRrsBE+Peszs+fKf
	 6sf0qo11/2gRA==
From: SeongJae Park <sj@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg-v1: remove folio_memcg_lock() doc reference
Date: Fri,  2 Jan 2026 15:56:43 -0800
Message-ID: <20260102235644.54611-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260101225552.3423108-1-gthelen@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3DF2640007
X-Rspamd-Server: rspam03
X-Stat-Signature: k7wajqzjfh98eiz3arebh9dsp1cxnnxc
X-Rspam-User: 
X-HE-Tag: 1767398214-211722
X-HE-Meta: U2FsdGVkX1/HEcX4K3o5+3p6Gm4UtTwA7rci/KkEJhAy92sKaaFqGpsf2PH/1Js6ke+jzqi4osR0uPB4xjgiwDaDxDOVdAU739bw5ueBNk0OJEvOQmtKSiXuWi6ehyqzGu4eQLjhXUhQz9gka4UxOYMX8Oznqisfp/HBOaGYmf+RKh9+NF3Eyj32CJLwE34q5CKT0wPZJ1PH+myML4OJw63Y0mf8qoasMLYImaWQHkOHdo3gT0WF1uYjcvvP5PPKSTTbP95oJyCHIIjbF7OiJmB5k5M4kfIs0JnCjMmlaT5xnQr4XGMQvuEEJkYBwGtncN/Z5hstkyyTk0HFZmKoMFxidrIKGrImJYGd2cVl5OR4upyxzzGOyJNhvH1NlZ3xY9VvWJdJT++X5m859L6PMUBDyqaSJVytnc1TJliej11I4fsOXR7kBOECxSUYxTrNEjL3KtUn15BmoMo9RXCTYbPXlSQ6YVtKKI8fB1I/36o8j9ciHdZL595/hcyQeuFhwr6YkWLNgbxeKQOWKQ+JLdKgO9k8wENxCc0KQDJXg8250BWq5BBE10Epw3QEXGV7D8kFy2Czcp+YI3bGs0vvBwKLTyN4sJlBht0px0bpvSb37jFddlJHbGXqBNd9SmSyVwI+b27p6pG9LWkHjI9xRBeR+/jEGjXYBkz8eC++qZU4CWUvNOuXZfsCvTzwz7rEPkJzz20mTysi5kX+Tyb8SwhwFYkIRMyA3TK8VBCpA+rE4xSZgt8uMFKyra3rhY2lBr3Zi7MdCtPsOyCODTj4SzaIL8YOZetrkEdYX27kYARTCTktFkQjuNya+JELBZO7Sc8Y9tzHOU4AD41GKAc853K58IsoVEibWovdUllXFwDbdI+ictXUn3nu2QIdr+zoC3LeR2v8sS+BQESSoc9rCO0wFAvA5ojWElW4fL1Vuxfi5oagIjiMeSpPNpdg6NlPSELolKJoOzIs9YoKBiD
 0mmRyPFj
 jvp1VczfM5h+2ngEkUp9/nwfNPb2EE7XIyhFGxN+b5SW+wF9CGfxLLf6fb8u79/hm8/iXAFzkhzPcJcQ9Q7NzrH++N3Ehjnp39xeqVwxYh0q4phliwphJnLPf5DmI95t/3Ls4wXpLAlBSHM4zAW38nstuasg+Csv6FZtVHUbHbIe3tZ0gMkU3h5DCVmpEOmETS3drLlbhwAgY1bpIN3mkXjd4S0vRxVppOiM+V06U1nvky/hxxgJkJQIXHXktkCMVYqv3ZPl0Qpv6IggAmZN58wOJdV2B1dhDF2Zp/VJkKTPPbTg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  1 Jan 2026 14:55:51 -0800 Greg Thelen <gthelen@google.com> wrote:

> Commit a29c0e4b2e86 ("memcg-v1: remove memcg move locking code") removed
> folio_memcg_lock(). Delete the final lingering documentation reference.

Nice cleanup!

> 
> Fixes: a29c0e4b2e86 ("memcg-v1: remove memcg move locking code")
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

