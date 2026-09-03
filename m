Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C63C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394806B0095; Thu,  3 Sep 2026 10:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36BD76B0096; Thu,  3 Sep 2026 10:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281B66B0098; Thu,  3 Sep 2026 10:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 012C76B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:05:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 716ACC056E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:05:36 +0000 (UTC)
X-FDA: 85172623872.18.9F8ECA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B53DA1A0015
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:05:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckNGaMeG;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaD2aj64RBdEMELfyTFkH990wKoNoGi7GvA6hmcvB1E=;
	b=Zz4KY+aZjWhvgW7xjuLadV9OAMaY3hjgc73Oscyzpib+A05qEAwlj27edYKfpSbBX4GrYJ
	DrmuQwNvw1qDUWeJd5QIEn0zd4QFl75LbvsDHmUTXltBITVQUNb/8jYNm4Y8f4dzjHOYPM
	cFvBlXIiaYeUwp5ZWruLXJBc1Hsw0dU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444334;
	b=f5/jPIsajOcHaD2nzxTlB2RubG8cdGBJyUJTwJSTcpL6rboQq2PfI4a0D14mISmnxb+bA4
	/dqW/8P6VhyO4n1+aFSX0XRTy9WkQxjGZWXg2mVtZG1h/3oIrBwZMq0Bc+0qzFoZWxkhTE
	a1asMeWHSviPOAjjzDWZDEvZCJcuZvs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckNGaMeG;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C46034018F;
	Thu,  3 Sep 2026 14:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D421F00A3F;
	Thu,  3 Sep 2026 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788444333;
	bh=MaD2aj64RBdEMELfyTFkH990wKoNoGi7GvA6hmcvB1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckNGaMeGbq4NUN+udET1ZeqZaP+BGvezF9qItzpVRqi1NymBYkzNSg86+L3OXPGkB
	 EexP2DVFe5g98f91vY1sZHDg2Xrjipeliav9WcdTCsN3zRCdwABTgmM8MieUj9tfsp
	 86ccDTkqUoMikZZId9aNy+KFjTUAqk/ybNomIzxkG0aAFm+GO08/LvmBdzxRYyR+SH
	 e6tvxXoNGt9vheJJbfBxh9QgO+mYD84xk45nT2Uo5QWMB03U36BrL8nd1uMEyuDlDe
	 yEkVZ/bucO/W7E7MNvQIMZAJ83Q/QiE73ZY/SMFmKvg9bgN+2R4fRecNLULJBlNtLV
	 TAQjFgQCoQ5kg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Thu,  3 Sep 2026 07:05:20 -0700
Message-ID: <20260903140521.98604-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903124422.5340-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B53DA1A0015
X-Stat-Signature: gjht87ot1bp4io7uk93986x6brf94pwi
X-HE-Tag: 1788444334-391233
X-HE-Meta: U2FsdGVkX19RDf9qU2GfY5DyWThnHGtMx4wHhpbrT3eL5w+Z0EmhupEnDnGZ1/P+82OO+gPjJzN7Sa1zTuBxGbX7Je8fftRZryTxsGLsE5pVcpgRUj6wiNjWzUL1ZHeufYIcRcV5LilCLnZAtzcCvd6aVH0AWk6FahrlTAb/CTA/F7bwcjJXBM3I0s2OqPd0KyzTdxiqgIwKTk0ETvGVD78cH/sQUIjc0HLZ3D7yr7YuDeWSpn240AmRbdG7y+lbk1IfDAdk6j19x7qVjYRyjAd/uEhENKPFiBVubm81aGlxA/K29P9fKRX1ZBAmjY4L4pvAZJu9NiLLl0btsQwWhqahIeX3QvVMZ1GiB2tcfGKRwjcd1k8pUu/KVR/GMlrDlQ3ltvUxsiWnHULMXP8p2gJN/oZjrP4EkN3KwKsho65xB1TTSUpN4+VlwdOYx2lV233k6weJyrXFhRmtaO7iYMjs7bR14Pk8Ur/VUHCBAsxBlUwQntZAgLJzX/gjLzzhWj+oikISqu9Cpyo/m3AlfnR9T0/PNCFBEW+tKKsQyYoHkWg2XEvZSBprhGrDtPUdIjnsmvL+XcyCb4c65OESDbKmZ+3l4rHy/Br4NncODBt508QtvCbPzL4XzV4flk2IjUg41Zk0KlK2I9VmdZMab6F+NwRzP7eF4lMhlgDRoJ6+0BLH7dyf0clrgRwmFxY1jP6GsorkrbLYsX+QGlO9O//vHlFZegX2+nWwGeMInqTYbMmbcjPTwCkyBh6jcINhe3bzY+TeBdD9gMScV4CIFu5Rvr0Llm4A06tAkvhSFnDMIyNNTDcf/1z6pNm5sZOrI3CGB8OTPNkJ6xuB/8mTCFnQbqlwsJWok2Dge2P0Z0Oto12FqntTw1A3a7zXUXEFgFRPCIb/b5oK9LHyo1nMnZ92YVkHbz5djztx1pZs4C54w1J4ffJ6Xac1omB6ia4M72mO5bfN9nIdzxtJEDY
 9YZnyXhA
 yR4sveNlC2OR2wBAryUV3vvOY22I8g9Wm4Azmre4Z7kdNJsv0T/ajnJEXkkRQyH/pqkRmFJC1UINVzQlf2sD442Sb2DBSQsPyQnErgMQthvYGKdIjz/zGuLeNjL97y8LKVdOb0kEIvQ+GVF0BVGHrxEGxK56fZvvXeYL5feYqHf2ZhKP35MzpmDq/83KcrNXOZ+cTDUcTBYWhVnNkMUlnjSMgAnHDt1Wh0gPywPmJahmRd8T4R7sHUxwI4wWgCyqDM2ng44dLGqQtnJAisv9R7NMLYlSnPjnVeULgJGFe/tKwLCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 20:41:48 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Wed, 02 Sep 2026 17:33:50 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Thu,  3 Sep 2026 06:31:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> First, I would like to clarify my intention to avoid any
> misunderstanding.  My actual goal is to fix the semantic of the
> qt_exceeds statistic, rather than necessarily changing the underlying
> logic of damos_quota_is_full().
> 
> Currently, there is an issue with how qt_exceeds is incremented.  When
> the quota is set very small, qt_exceeds increases frequently.  This
> produces a statistical trend that looks almost identical to the
> continuous increments caused by the Temporal Goal being achieved.
> 
> The original intent of introducing qt_exceeds is to let users easily
> notice if the quota is too small.
> 
> Commit Messages [1]:
> 
>     mm/damon/schemes: account how many times quota limit has exceeded
> 
>     If the time/space quotas of a given DAMON-based operation scheme is too
>     small, the scheme could show unexpectedly slow progress.  However, there
>     is no good way to notice the case in runtime.  This commit extends the
>     DAMOS stat to provide how many times the quota limits exceeded so that
>     the users can easily notice the case and tune the scheme.
> 
> However, under the current behavior, users are forced to manually ignore
> or filter out the qt_exceeds increments that occur after the Temporal
> Goal is achieved.  This adds an unnecessary burden to the users and
> contradicts the core goal of making it "easy" for them to tune the
> scheme.

Still I feel the problem is unclear.  Why the users need to manually ignore or
filter out the increments under what situation?  Knowing specific and detailed
case would be helpful.  Are you or some people you know doing that and feeling
it is too much?  If so, what is the real use case?  For what purpose and how
DAMON is being used?  Why and how the ignorance of qt_exceeds is being done and
how painful it is?


Thanks,
SJ

[...]

