Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4E5C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9266B008C; Mon, 31 Aug 2026 03:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0016B0092; Mon, 31 Aug 2026 03:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9000F6B0095; Mon, 31 Aug 2026 03:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC0E6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:37:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0288CA035A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:37:25 +0000 (UTC)
X-FDA: 85160759292.15.DD774A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D083C000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:37:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqOrzr4l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788161844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6u4YzIWHtkU9ystADvq+TmxhJSTLpTiJEvlTgSovaM=;
	b=S2ZoPoCWb8kxCtKj1G968ppz8VJxucogFGuoFO/4ak9f7wdbJoWb/faRXOXsTR+0oGLt6s
	lXHOVum0MFU2NOm5+wjz+6tkkZIDLe3OOlQcV0yun1Mx2IlvgwXJabVFNTPXC+zF7kv4JK
	9buKVVq9vwnsrBydKDjIdCtFLyHZReQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788161844;
	b=iVRIssGSUzEqAQzHXapS6i3T4FTUpw5RqUxZakmNgWRnFhY/HluqEfVixSox3T2wuANli2
	18GhVZ4+FqhLXC/eWU481SRUGFRK4goLd5+xp0zMwSWBQbhvqX7P/HyXvRyiJGf5RAyl9x
	cPmvY9fmgvk8xfBSPyW0rZUtcoCwrMg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqOrzr4l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15A7A601FB;
	Mon, 31 Aug 2026 07:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807FF1F000E9;
	Mon, 31 Aug 2026 07:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788161842;
	bh=/6u4YzIWHtkU9ystADvq+TmxhJSTLpTiJEvlTgSovaM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VqOrzr4lVKwvi7loVALD5Yfb8E0qq5ydMfagKPHGBuRO3dKFmEPHrVj68msnHSn5a
	 fUhddW4gGfUW9LLRl5dzELOMWH9UeSAzwM2O0fwgaCbwGua3I2PcJhjoQmLlqaS8MO
	 OVz940K7kiEmo9w2qroqB40NwT3boLxS2bge2tGDQrHoUXG91qnqJXOf7rYBQ46UQN
	 Kw4sqFw00LvJuLn83zvoya6C7c3i4q5TV7ID2UN24CotYHdp/YHR1y0i6+pZT973qz
	 wTUdcVZaEhxYKaa/65lxsUDaVu33FGedjqD5BfF+w6cOPN/PZWz5tWBcb3TTiJiZVi
	 AU5BjR50LutQQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/mm_init: remove zone_absent_pages_in_node()
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260827144151.486192-1-ekffu200098@gmail.com>
References: <20260827144151.486192-1-ekffu200098@gmail.com>
Date: Mon, 31 Aug 2026 10:37:17 +0300
Message-Id: <178816183737.3691663.7482057515031348878.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D083C000A
X-Stat-Signature: finyzp7i4xcjnid46ckoo9m6nffb8efg
X-Rspam-User: 
X-HE-Tag: 1788161844-101815
X-HE-Meta: U2FsdGVkX1/ZpZzTQut/M9sL4JhxeEawjWFMJE9cWAGqmUjq1wLce7OX5uhHnNkaa6AiTvQMmGXttswuj1lDKci48Jjf0s3jR98wv++ak4HYWAGqYk6yCzXD4oAI5pjiY505MQ7KSW42ICatTTpyp/RACUTxkRyPNhbNL9ZeIWosHUOT8VGyepUy2+XOWrLmNCHe9tgyyuPy9V3aXTYKO25126Yfi5u4uLzxCkh45SryQalhe3/YRz/qzoDT4vTp1ElyX5UxmtP/46q5801w6gOeeW3mJ7q8gmF0vkR1y6XSqS8bGVRv7qN+GvwCjsuE2hyb18SAnWEJYzUx9g8RVwgaFuVmT+2qCBjn+O4y18uhtHHoNubgdoc9G4ageqWTq/pNbU8ADO2PtlrB+QWbZRrI8Ynb7uKN5wA8t0nT4p4yUxKmGU0TMSdk+6VQPZxviCL6pke8Rllj0qzr3wzBOaZzC2g0sLVuizusKlwW7h06HvQqpZjdZior9AXaMJtAbLy+V3Yq9y/aX9iey1u3ogUSJYEmfbrGSkjFMuqrxtg5HXHOskwkUPpQ6jXvPsggqk9fasGwbsMuHNCzeYG47RSy9U6u8isMOR1I2rGeuKwhgzLAsnVmMWPoq/0l5qem8rhHhYEpKKUvXcoDxvb5EP7WA8eh4fnXmSPJGZvoNzPb84sG+LA1N9GWYcNSBlV253IaRJhkXv1XFuUNMiYO90MUKlpNgUMs4mVjkxFrCb4JtzR3DsDMc+pUregZC7lNzlSF8iNc6H2xXugn2EJA8DpbGfaAtqBrT8GuNWmZfyIygnYgyd+RdcCAnpMUmWr8KyY4gIFk3Cz7N1TPdhpxlltrzaPc2j5iHofFVs4RHuMrCDBe2oALelXOOEZDkGhSCvD537tzA0XQuq3wCIQWDC4YXjIsXYJ4qRHmhCghU6Ghs09lZJgRiezbRHHeJLnBckyKTU4rIdD96hUNzXd
 dUblRX0x
 LKzFlcXFDFML0lpNrN0BJuDgW+CFLQBboMax744qF+ezVGz2R7GOHzi4xsHYGPrpiIBw7pgCi8Dp71ClPQJ99ahW3nzkIPFrGsFqXz8bRZL70N07lHT1sogWPOtAV/KsBK5g2Dcp46rZiUp62tJ52xXYGxYceEs+b/7il39eS8FtMOcTV744T9oi0l9O3NJsjEb8t/WJ0MLBOHBb6Ujae1xfd8hQL5bC12sA4PgzMng4MNOySFvB392HEF0QPZDICA10CEOCLkMvzAIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> zone_absent_pages_in_node() returns 0 when the zone is empty and
> otherwise calls __absent_pages_in_range(), which already returns 0 for
> an empty range.

Right, but it loops over memblock memory for an empty zone to get that 0

-- 
Sincerely yours,
Mike.


