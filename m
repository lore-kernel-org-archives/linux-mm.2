Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911F0C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A2E6B0095; Wed, 23 Sep 2026 02:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AE16B0098; Wed, 23 Sep 2026 02:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560666B0099; Wed, 23 Sep 2026 02:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37DE06B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:06:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBCEA1406CF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:06:14 +0000 (UTC)
X-FDA: 85243991868.14.37A36B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 403B614000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:06:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyfPW9I1;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790143573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8xknLz0/hAEOZEQ449Z9zgJEDzncDaOaGx5dlfb95w=;
	b=gsKNTc7AFTBWyjBqvOf4/4hNuk/+jK0yTgoOl9ZvX6iehhoKXDHO2A/zipUO0XFHt2E9nw
	EctZtl9OuCw8N1RM2HvUT6MD/UrkAJblgxa43FZ0phQxFq7IjwOYCbJfHGWHZRB0p9Avrs
	MGLFQQRTsW8smljzc1y+bIPVmWC0kig=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyfPW9I1;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790143573;
	b=c6oGfIiHdtcku0UXm7o2SJyzelHlIgSgGgQ1fkTfRi+ORiwXDSthWcL16b1g3S9oorQ5ns
	ASZukt0YggxSIA3GAVYTObDPTpHOktpLtN8+oQQaaV57z89xs5NeECUXuSLkxL9ZSrUUCO
	6fdx7Z1fJCLyGYPp47DqnUo/aKiLdTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4835600AA;
	Wed, 23 Sep 2026 06:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D87B1F000FF;
	Wed, 23 Sep 2026 06:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143572;
	bh=q8xknLz0/hAEOZEQ449Z9zgJEDzncDaOaGx5dlfb95w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyfPW9I1lpAhTu2TiVmhGg8gtfAuR6BHkCcubtD2LxpQjy6TXjsyBcQ+HALJPCUCs
	 Z8MHyZGN7Xfama31gTf/86hqq+ZH85617vaaht4hicBYgYI1XOrjuSrl71OPA3Npv2
	 kjfSVyOhh0NRxkt+lwrcHks4bOH4mq7EHj1IdMKeoCSYCGY6gwLuFURllRJAoooZS6
	 IBJukl0zq80eZDpiPtumAP13wMfQDgQTCbB6Z+NJdrjqr7QoQxKdIFhED4kxfGMeNG
	 XfL4TX+J1OPE6JXBXo7YVALVLzrkDYgtC6uBTYs/hFTPbYXMNCeU//QGB3ilJRcaCK
	 xvUF+CRBr8ydQ==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Tue, 22 Sep 2026 23:06:07 -0700
Message-ID: <20260923060608.4097-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923002600.1825448-1-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 403B614000D
X-Stat-Signature: qdnt7gz3n8j16beo3r71qkp3pbme6p4w
X-Rspam-User: 
X-HE-Tag: 1790143573-159499
X-HE-Meta: U2FsdGVkX19zmMQBvLaakHKffWvL9U4iWA6nCufYLfWRUEyxqGZ/tljZPQ0s1LAIpPHQkPpNaGg8J+GZpSx8Z1Z0JiydHeZP1mVw7RozuvyXlRFqrtmUq8mzc83+xZhV9LkOUQXytaNBlV0p7K1evWXfN/2FynCDMqQBxW4y1Gu1adtxMPNJJpE1qQdHT5OeCeyTMfj6ph2G+mMRSPo2s4s3BTzJfCy/nSEZqlXBexMzeQNEKmMZ1Dt/q27ehTopena6YQNl5s0L1FOUIuULoRbRusgTND+GDgkvu8VugxnCzt5DG6Y1vbBH7f4B6Cq1JXEq0R/zCOBTb81TnErlgkOyumuA0FzRCl7u77Pl+GDYIe/XOrFjOz0qrx2yY0dj5kXvdoo7477Cnkohgtl7CAyZ7yEBhEHjUK9urCvKd/2iuR6oNwTR7pp+DFU9VwhadcSa/mc33xRueVxXF+nX+0W6EImD8ou1vrkSQfXTtGGIIG7DLXbAlGLMMmMgDbyA1kiwCPgAbUmKU5vbZoXRgVSRz6BzXfvrv+C301qZ49818XPYWes0NLadZjn+1tbKSPfMnwtXNBzjitkxAjZ856r3JbXFVlDfcJ7KFU6/dlJsNapWbfW7jE2LHZ1s4T0teqR20Z0g7asPdOkZgkW3SgY2xDCoNtsY25lOsCqmdLiJ5hP1pEzXq6X/8SCOl8jgPxFeg8leMpZ209e1Ehm6nk8q/ZEQscA9zIZBQE0bGygSKVTTHqZTlIB4Zu8DOOn99Y6gVAQ8NV7OQ9kTMPGvABAwiUa22ZcJB4dQWWg5tCV2MhilWNVvpcWxxJJrdZtl6DLrvLZQr+UdsVND+oZBEcxO1gDYoOO96/ohPOpa7ov+hQDmq/Kes9vUngukoYgPpbIc9vTAjg/xggIFHeEpfY7UrtxgsBxh7WSYb0MKqrDNsyU2SdKdd/yyfSP2pfbibDj8TzCWp8ZtNk/BUOX
 jz/MR9O4
 14izPFNT0MxGSu59D5gNZ8D7+SC5sQAeLF69akNfFbFBH0QZjPvUC2mSfgIGEAtANTVrqkigOHoaeIYisJYL6mPx4XCry4+VfySoxbRbBAdCbjssLbJcXa2AX4laY0ABCWnVCj+Iwq33EoK0OCuLG2ctsLmg3vTuwGPjjXulD1GootBACQQrPLqxYT0moXPkXTYM75X4UAaXpkCi2pQ0eYfwz5OqGD00yFiIfYl7454NEn5leLz664j4Xr8b/rPjUHQLJRWo+Smm5dQ/7o69hH0uQwTiYgXdlLSgGptOounvJXGNTBvyzeK3UaSwmrfvMP/xOC93BITJsMlir1LJpK1jtUzK/zLOvFpGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 09:25:57 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_goal_tune_esz_bp_temporal() hands the size quota to
> damos_set_effective_quota() through quota->esz_bp in basis points, and
> the multiply that gets it there is unchecked.  On 32-bit it wraps above
> 429496 bytes, and a wrapped product below 10000 divides to a zero
> effective quota.  damos_quota_is_full() is then true on the first test
> of every charge window, so the scheme makes no progress for as long as
> the goal is unachieved.
> 
> Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core
> kunit suite, where the new test would fail without patch 1 on any word
> size.
> 
> v2: https://lore.kernel.org/damon/20260920023111.2466265-1-donggeunyoo.kernel@gmail.com/
> v3: https://lore.kernel.org/damon/20260920122411.610213-1-donggeunyoo.kernel@gmail.com/
> 
> v3 was posted before the discussion on v2 had finished.  My mistake;
> this version was held until the thread settled.
> 
> Changes in v4, from SJ Park's review of v2; the code is unchanged:
> - patch 1: drop the 256 MiB mention
> - patch 1: say what the user sees before saying the setup is unlikely
> - patch 1: cut the closing paragraph to "Bound the multiply."
> - patch 2: unchanged, and carries the Reviewed-by

From next time, please add full changelog (changes in v3, v2).

Otherwise, looks good to me.  Thank you for finding and fixing the bug with the
test, Donggeun.

This series is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

