Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1C1C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E076B0246; Tue,  1 Sep 2026 10:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E67E6B0249; Tue,  1 Sep 2026 10:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3233C6B024A; Tue,  1 Sep 2026 10:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 115B06B0246
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:31:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E50840441
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:31:03 +0000 (UTC)
X-FDA: 85165430406.08.1C10EF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 99BF94000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:31:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RzZP5Qky;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPIRT1eDM3lMbQhKVz12Hh9ErNZglXURkwle2X65Z6U=;
	b=bz7/hEcX3cDMSZgsnQN5pLi9fj+dKCv/9NrqTAWYLu/G5r9xG+rPEuCkap796j61YXrGyh
	KGiRL3sOr7ttU6BjlBEmNvlzDiIrecQde7eZhSQTrFXM1ZGg3smtBNCqfjESOYGM63NvZf
	H6jmjXXaFGX/3SAIHYnhStNG7h5TPeY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273061;
	b=b1c/d6MWzHLUnrK/cXI8mylJFm+hR0iLx4tp/3gYA2zQY+l3TBZGrgOEhBvg1te7gF0b7O
	j/16DYbfUKsySjYjU+1Ruygg/Am9ssYoKU233dBiWRrX+Ibm0o1TwKRxcOOKvjXcTOjUGy
	4m0wIRh56S3a/cTEmjdxElOZmpAMQ4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RzZP5Qky;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A185140848;
	Tue,  1 Sep 2026 14:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427F11F000E9;
	Tue,  1 Sep 2026 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788273060;
	bh=zPIRT1eDM3lMbQhKVz12Hh9ErNZglXURkwle2X65Z6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzZP5Qkye+TEPQgaY/tN0jMWyT7LGaDsLqJ9Tr36PoeeG7oxxYlw0aM9c0DYPIrxj
	 t1SJrCeGUhXt5LcO77+u5dYOBdos91jotme1/vqxbKobvCAd3JrcxJ1sFuyI2WcbFT
	 agQc9UxGsk39+1P6cZ0pVmsd68eGEGB/ZMutc/6GslXELwUQq5FqIDhBfphhnkdGla
	 csyDOpJvxBOhV6oxtfSgLeOoD+3AI462ZWbUiBGRK6Nmr5toULI58spGcnZ22lnc98
	 j88tA1CQWE8c2CKfzpcshfQlTIBLwBp2oAMYtJ0tdQqYJgz5bF1zjV/PgO+3ZUtgdN
	 T0mTNwaMl8E8g==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: fix DAMOS bugs in core, paddr and vaddr
Date: Tue,  1 Sep 2026 07:30:52 -0700
Message-ID: <20260901143053.101196-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99BF94000D
X-Stat-Signature: bt887hkq6f6pwiwc9rkzxoyem4fnh8t4
X-HE-Tag: 1788273061-178395
X-HE-Meta: U2FsdGVkX1/21RJObzPpXb0JFWnd3w9wW1vdqIgTQ2G96woUTeSilTLz8fc9p5gXRGan/B0gUrhy4IeW978A5JiUb6ZYf2dwe2WSbhiiAPODle2/gongfMOb8DiLil+vDA/vjuKllZfgQ3DhN7FJ0AJHGN05HmF3bX78d7fr1NIvG4hB50dgVfFEBAc7Mguv/by7k9PBkyPzK1dANk32B1ONDFu/n5jxIvYVsyiXYDgvD/YruuuADdplyxU6szrSbjF59/c6ySdH6P8S+cBO+h3PESBhKE3rETKoXwoLDWA7phA4oLz+CE2YLtcg3hjh5Nc1U8V0Jr/dPrDKvtxbSyeuPfJchDH4iWK+mCItALQT+rfk7csluH1icvQw4DRQZz0BHhzkqYXv87wbyVgBslEwGkEK0T9TXAkLvD296KtY0HY2hy7WW78syXnqCReR4X0jb8QTbVE9T4sHEuxIT5HbIPql4jIl4OaY3EF7lQPG7rTk90UMEjFj+J4iKFEnAYpg+jQXYU78wlaypwEJ3vFYMOUfh9tyVCfDS47sTcWxDBLo4Sly3wxu35/vEO0cAcHm+xpsgF3OKJwenfkHZ9uh6COOuRdLIjg2Ub7WMqCakGYtJzxQIGzt620aIaMCQUTGowBo3MTkPrEa0qE1nPbal+gRK7qPVahSW1d1Ky9xAWxIUXxXL+HFpEjfe61eBXFMpEe3G4C3DAqSFCAEBbiqqhHlrWEYtJkwd5Vsf2EMnq9TqAuIDpgGjNrdGVH6JrRD8D0fzc3pNolxka8brHHWr3U41spYvtLwes5mZXkCE/vBWpvY9bqQ4+szk3Cmi0BT7dWRt8KXtAXwU38q2E4gn1cRWSTcJ/iUxRcpjtu+Xp6ChTIOTKjMDiLPQOQUHXBJUAIP8bCFgD4ukrkD0A2zfni4XWJtuMQWqbMATAH3vArDX6Stcr3cR8b8NjWXEd/0PG90hsnh4pqJ3rZ
 5lw7vSJ7
 OqbX0vjXemE61odSoEM1lfkpBpsPblGjMNqBnjELBq7k0IfDntrmYG/qY2IOQrYnh+7KxNIbZkAryrEO6ZTJ9HtfVYDGvnJdGuqaT2jJv3r2K+mWivAGyUe12NDkaFV4CUEIbq6I0MwusKmWS1ON8+mAYrLVbgxrvoL1KjwIQM2XXJCIL2/ta/sYVzg6h9KgLUvxjMi+HMiyULskv/TLiZam3eYD1xMCTfLwB/szzTrhyCnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 06:18:41 -0700 SJ Park <sj@kernel.org> wrote:

> Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory
> allocator under extreme situation.  Patches 2 and 3 fix wrong folios
> walking in DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in
> DAMON_VADDR.  Patches 6-8 handle extreme and unlikely memory situations
> that can cause divide by zero and underflow.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

