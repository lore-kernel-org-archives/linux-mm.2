Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BEFCD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 16:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7547F6B014D; Sun, 31 May 2026 12:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705486B014E; Sun, 31 May 2026 12:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B9A6B014F; Sun, 31 May 2026 12:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAEB6B014D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:25:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDADAA042E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:25:03 +0000 (UTC)
X-FDA: 84828239286.12.B9B40DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AD3F120008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:25:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HH8R+L8H;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780244702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4xwiQThCs7F6+XmjiaWulJyRMq8uwTndHHdVcApUeA=;
	b=zc9j+JXPBH+arvG3D4dzYOeqg7dpobwJJ1dFkJ6GSWhHes0LNZ2xU5qaey9OVjb0kOkaSQ
	33krAT/+W6xninzS1HGCRYdAIWNhWVNdjS9PAGlWRO1mmNKMVpfGOzV+4WH5O2qo4++yQO
	HGqR21izi0K99+JU8S2iYPOAc5qHEcw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HH8R+L8H;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780244702; a=rsa-sha256;
	cv=none;
	b=nf+k1bnfrNrYQKGldkvhKbdf8N8aC5jziitJqKPeKrPk78fSUhNKNjS8seeVg3fjk36Ey9
	u6eqgj5aJeSpvmWqO1I4jib1UvZp/oKbDN74eRKSYMxC5kbR0Jzn4Maqj/94UMDoNKuTgj
	H0452zMNtfGoZ/BO3nqJLC2w9AmDhW8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3D42418FC;
	Sun, 31 May 2026 16:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955F81F00893;
	Sun, 31 May 2026 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780244700;
	bh=a4xwiQThCs7F6+XmjiaWulJyRMq8uwTndHHdVcApUeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HH8R+L8HsK2swvjdoSOvXv3+R79dEhpbNVvX6VDjStjqIShSbGmPEwr2fYd8Dl/LK
	 JLEb6N5PGpp/LY+/L5yvIBi+ueq4Q7VOfEcBRuhqgyDHs9HTFQGS8o1ICSzilFwmn6
	 t8aRDA0UEoUXgw6SMCErJ8xPNmPdWjvU01VmGRVqPoEI2d7cwrO4eScHqNfW5XuSnm
	 Wj83jVeKR7nPAZCE5vst6YxFiJB+zgJyGJLW/0LXURwk4NJ2NIJfa0pmrpHAUQX0SQ
	 Q9jOPabpqBfkIXQtWhqJDs5JrQvOv2N9RWEZOPZ9OzZns1/04r5Xmmjq0oUHjQcVgq
	 up3Gnj1ihLZWw==
From: SeongJae Park <sj@kernel.org>
To: "Kunwu Chan" <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	"Kunwu Chan" <chentao@kylinos.cn>,
	"Wang Lian" <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix stale TLB young-state handling on arm64
Date: Sun, 31 May 2026 09:24:56 -0700
Message-ID: <20260531162457.98724-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cfa837d8641972b79a404f4f9d489644dd6675f7@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: d31eb5wzpqy5srz7e178u3dkq8ggnrb7
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AD3F120008
X-HE-Tag: 1780244702-571448
X-HE-Meta: U2FsdGVkX19/g9Bo205PO9m0hf+ZaaddoD/5B7iQxvo0/bJIh97o5OWh8FI2p5wIeOWE/4y4Dr2mTAK022OhBpVFC8zKZ+hSmICnpRdZqPVEjCY1Qa0gJQnCJI9eLXzlgIsOuowzMIhiSFbpmXSpvjQz4z4d7rzGvX7lujmSOaYQi4lfEWx9Furom4aBqnoqyIecakqt8MJv6SznlZArvh6F8bfw0sIrrKDJSGnCtbUGrRi901pivoKOShS+WplwfK6+T/bTBBvMtjGMFsrNfwbU1jRqo8SRTk3xt4N5w4CgcNng/mCWahZBQzkNbAbFPpLjPwVunb1XY+dCU3PaD1Z47TccY+G9X91qkDvPAvRLvu7qa//2s+4EFZwwt9wIKL4Jwp+otwIdKNG5HJL0kaV7I6pEBIjz1HKTaRydUIxWtBo1lbVw+IkWK/XFhTNbM0mlELhF1+bWC8/6idisV+j5X5468XVtdWlxblWJf5fpgQS+7y5t8MkqkXW/k/yOcidvWJBkSJMIxZsF/B4e105IVar88E8wHg0lAcy2z40V/O9YoUwjCSUcT4H7TclrqfuxqUQTCVv+OwfWLr9E2gdTAsYhB5QlRYMF72DBUEIAF0uh0R1bf8xZe8EeNZ5AmLrgEUZfv5bM5DBgOaeibaHIby72tY4VWZXOifxNFDAmNzEYzLujIoeHkdRmB6eEQKQsWKxs3SkjZFQz0HuErJjRD5lrQA3Dx4kX0dLyAE4eYK2QvS6sBGEVPeyUSBeWbrs1/GDQNIpWs+EMNbu7cE/an4FGTWPhqTR8QiPT3S4OL8ucgtAYkkwKtMq2SsSZMRUEsydJVh2fuh9Ya3mkp5bwLLHRPzBSOJ/fN5Vs1qEg379HA0TO+Yn/XtdHmLOBPcp4H3I8Rj6P8jhdbLkatoe/HLXJDl2cQOBPMYgqbvlrebhTMdqCV3kfImOHR9L3QR7Tu3rZRZEiPMFlrD4
 KpMk0C12
 seEbEUAA1HwJ4lh6hl0UcCOX0z/m0gMAecnJdVFGT4Z4aBcbzFXLxC6tEZUQgqVzx/0ZI/F2zTVCSs/sPBGZG75kpTOYWicun5BRtnsTO+pYIE9AlhoyMwc0DpI7OLKO8uE8DCRHL3J1JA6gQomm4PSeI9QuqcebFIXiTUO7ueHS6y9wBtecDXjS6ykdMAg6oo6gHkCGGgHKUgpJgWFL8o92A8PvFUktGd94c5iyNZsxCm2LC/X9Y640wEA3xmJ+1D0TO5HArPRk7jXQcbxqLOjyA83gVAgsXbrUeFIQddHbkt16O8FmH4lh2qu5u0u887HXBS4jZ06bu/GHMmx20NHFmlWEYEd4Hg5aEOQpz5LUOEIpjp/9LAoF2inA9SirYNLJryB+JcFDEQFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 12:16:49 +0000 "Kunwu Chan" <kunwu.chan@linux.dev> wrote:

[...]
> We think that makes sense.  Explaining the rationale for not flushing TLB,
> the limitations this can introduce for tests, and recommendations for
> choosing reliable test working set sizes would be helpful.

Thank you for kindly accepting my suggestion.

> 
> If we later find cases where the documented recommendations are still
> insufficient, we can revisit more intrusive approaches.
> 
> I'd be happy to help with the documentation work if needed.  Please let
> me know if you'd like me to prepare a draft patch.

Yes, please feel free to send a patch! :)


Thanks,
SJ

[...]

