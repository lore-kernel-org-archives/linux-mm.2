Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A39C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 01:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA816B0088; Tue, 15 Sep 2026 21:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164D96B008C; Tue, 15 Sep 2026 21:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059636B0092; Tue, 15 Sep 2026 21:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C89596B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:08:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9F091C2956
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:08:21 +0000 (UTC)
X-FDA: 85217839602.23.DD11FF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 503471A0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:08:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i70aeXIS;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789520900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+aGD7aIOa+zzJYmZKe8hvODLP7Ng8RsJCihAMnlDYs=;
	b=KQ8+NqkZMqiLxJsPMg1k9wzmP8qbVSTqz30zfY7EwYWGkx+HW2YlUGb+5E7zwBRfnRmI1o
	zSblyNmB18cZCAq2noLrciJQNkV0ywwfRb7nIlLy0Cpio3oQTttQicu76BosvhUM5YWlC2
	5L1Hlh4J3inVgNMnGwuweA5YmVj7Ejc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789520900;
	b=3U9ZCTMhjUI/j20Cd4ELcFDMDXYyBXV1bYyDmu9tGwPsNqEwGcmmU17JZ3yjlSonb7nHg1
	RiwY4nyH7otRQPI6Mc9iI4uOfQrVqxabT6uD6Qaaoo7fDI6CgpNORqoyDbMIuEn0GY45Hj
	K4HjqvdMonpvPn4S/SLVhc1/S0liIak=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i70aeXIS;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D433B60008;
	Wed, 16 Sep 2026 01:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F821F000FF;
	Wed, 16 Sep 2026 01:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789520899;
	bh=d+aGD7aIOa+zzJYmZKe8hvODLP7Ng8RsJCihAMnlDYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i70aeXISLBRvXOCvYar/0XG5MN77z0h0IgHOjQyRiGlbaGHjTS8j8wzzQ5XXVl9lA
	 yowaL9/V9kzV26/FszQud20oWTyEmnTefoI4AY9Jwcf/kH3GaN3rvlRmDKBiM19C6a
	 a8X9yKYT/StG5srzGsxnxxUomHa/1g1KV6BbT3bt4IzM1od+aOSOjKxhYe+cPWzXyy
	 B2YxnuozLhs9FZc4x0DZkKOFh7YeGRwCn09uQmNpnP9xHqOwttu1F6omT922kdbVVd
	 KEH5cAlA7XMwketYySW6ht3aRIHu67VvY3mMkyZR7M2rEIcKo/EiyeuFVrXkBAKXrL
	 ITlpqZ42wAwUw==
From: SJ Park <sj@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Ge <hao.ge@linux.dev>,
	Abhishek Bapat <abhishekbapat@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alloc_tag: avoid implicit padding in uapi
Date: Tue, 15 Sep 2026 18:08:11 -0700
Message-ID: <20260916010812.102238-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915202404.3568029-1-arnd@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: z5g3gopie9meu6jk9uarrw6bdo4ob6ho
X-Rspamd-Queue-Id: 503471A0004
X-HE-Tag: 1789520900-190782
X-HE-Meta: U2FsdGVkX18LKjk1U1GaAakauVvHMe6dQTK9Fv6nFavBAFvQ81dQYlOJxZIXUjtjbaQHqHuwKSuysgWmVgqRkYD2zrxIRBoRmgxd54PXWHR70DSIDeHnk5PW3N6fnRIYHcXOwfnjEMIS4ABc116E+TEWHO8Ye9wUz1H7R76De/DSV6BlwQrpnlEb42JRiy9NAizDW1Z1KA5k2s0tzO6jZIZbPXIhHkZHQW+9dCntA6bZf+f6dPFQW9ieq6j21lavlrDWRsuHbtTJZd01qy5j/41WNqdx475VpOB4V3mFgxtc7Mbbfs2cWPy5OxxhATYIe+NqrH3aaia4Fu6aeWd+lmquL06LQpd4fXYdOfsMo321iJYnrh7t241yudXbSXF2zoJj2aZ+yNX6wku6HNclP+5rfI2fzKZbuoxKLzP5frqV5YG010iqon+bnEL9eH2Nx1uyEAeUFdGgjegZ7KZYR6GVDds967HTMYngQOjNZRcdsYtprr/U3rou81aYL+o9XVXyF+0TDb7GJl7Rct/uakMz2FMpE4ZNIgTu3G+qIik08wgXx7EwSp9SlZrfxn3/kI3VuxjXtr5xPrIYPL7oGejpObi1HqCRY26VcKmmw/xE6U+NTRIfLGtegkM63tOXQ2okwBszf8VA40k6IYOxIb+pBByDPLAZBxsAOsYV89iNbUP691L7A3vvyyqQENBcokU5L8icVO78jTIwh4Vba53q/FpkcGFkeO2we8w/tTTzVuUvtZEPydtO8lIh2nnBLlUIffyOvM1uCTbQc/psdUTu+qPnZh7+w1uvddWicI3iHi9yPib/XKkU/D+CmRxuA3IdhIxEPOliSZK+Dh+SaL3NfzCDhOL0mP/yE20kcozomhA+I9kfVZ+DfHFIRDo7jMcRgcXFhT1K7GCMlpjtdnoFhBFH2tmcai0aNcNxdnsv0VukplDXeHjT8cU0VW4l19nIXfKMIZc6v1z7qzE
 JWCyTnnS
 ClClfpJxLO/x/Eot3hXB0w34jRpHmgYvPjU6BH5QoXaCvBra+LOqhHrsl4zP2/mRiMTvRaFL6uZjK+leDlQ8wgHLutrZqFliv1b8OzHOXvRtKGDifrYI2FDoTqRD06txaQbXYlzNe3budp+jBl9N0boK8Wi0TuulSIOudtBmFJi298/1rjHT8MZBDFYK8yLX3a/TDUvGbf79Stf6uL8jQ4KlEJnpo0KZ+X8iNqkyAWsIlfk8kr4gMbYg//QfLVlTJXzC+zTurmyD/J5gEuzPdjLnJyaaVuor1gnMuFG2AK7/KTdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 22:23:47 +0200 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The impliied padding causes a harmless warning when testing the uapi

s/impliied/implied/

> headers with -Wpadded that could in theory indicate incompatibilies or

s/incompatibilies/incompatibilities/

> data leaks:
> 
> ./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to alignment boundary with 7 bytes [-Werror=padded]
> 
> The code here is fine, but it's better to make the padding explicit
> and avoid the warning here.

Typos are trivial and the change makes sense to me.

> 
> Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

