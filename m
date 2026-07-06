Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A7EC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE986B009E; Mon,  6 Jul 2026 10:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667FE6B00A0; Mon,  6 Jul 2026 10:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C756B00A3; Mon,  6 Jul 2026 10:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 276A66B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:29:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A080F168B3B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:29:36 +0000 (UTC)
X-FDA: 84958585152.26.961C44B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D6A1160006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:29:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grXeyKe1;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783348175;
	b=Thn6kXBP3/8yl5pcfqDGBItd1pWu993zw8VktVqawedQq5U1/d+OeWDTx2klm4RFOzgpst
	GptEh2zhexCYUs3U7hjQP7InWvQ6oCBjJCxzqOUM+XA/8Vk8wCO1oCwU5lZBPogKa2hlgN
	MFmF0WTBdbNljqOuC7LuNs/RCRQfcy4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grXeyKe1;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783348175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBCRhKZI583zCcBg/zj8+qNKFcYvMBYzCOYKUJEwpkU=;
	b=dSUeTSNjfiszE25eY6r91khsn3nbrx8zIMlXk/nXFNLdtoQPYPyvNPTJ7L4XlTLdGXPzRr
	+ZO9zIBan/n81/713yWOuah7qYrcjeb6uPq1njIcHd1iqBcs2KKwgDfFuhkx1ZUUqYPPa5
	GELUaBgtEglC1BlqlLNqhA35/Fw/sOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5342B43B7B;
	Mon,  6 Jul 2026 14:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CAD1F00A3D;
	Mon,  6 Jul 2026 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783348174;
	bh=SBCRhKZI583zCcBg/zj8+qNKFcYvMBYzCOYKUJEwpkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grXeyKe1dw9UXQJWwPd6e3WCw6WWVG0VN47dubQw6EL4/mx1gGIZFP0Y7ME+5KYvg
	 yh4G9UUzszbFR9q6qW54Ebyek9BAoIZdFx4ki86ozkUCuuwL51TC/y9akZ/3zwYOU7
	 rvEDsZVMIZJQ1WmsEOdhhwYtFFIRn+y4ep7jdesJaUBrlejcJ/0Mb7a0JG0mBFWaxy
	 3ms1xNB/vSZcHE4wvEn60qP6Lani3uBhMi70R3IlllVow2OsZbZRzp8zZYx0CXEqiL
	 QD9EbcBaUV78/0ezFV2bfY87Qh1e1kKdYA5c+wfav83OKa+jftcPWonwPF+jxqaoKp
	 NOJ7lHhzO0bHA==
From: SJ Park <sj@kernel.org>
To: wang wei <a929244872@163.com>
Cc: SJ Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] selftests/damon: check correct path in ensure_file() not_exist case
Date: Mon,  6 Jul 2026 07:29:28 -0700
Message-ID: <20260706142929.93146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706134305.5224-1-a929244872@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D6A1160006
X-Stat-Signature: bj4rte7nu1qofk5f5ng86xzedfk97mh7
X-HE-Tag: 1783348174-653764
X-HE-Meta: U2FsdGVkX1/LbSn2MTuqp/GsNs13QXCUa2p/zs7rWPfVgj7sZ4ay3DvvrR2gV0rgLKIgAvGD+zQ9ZH0HZGU6jqhI0Lgh2eBsdo2xJZlwo9s7V1/YR1EHw7iV13wu6soR+fZFF4w01Op66C4uF8qX/RpsmLzaDmW9jwrbU6+7i/vtT5kSDV6ULEdPVIs15hDLNgjwREPZFzdqS90IFzKG1vAfVPoNqXKBYFFCRAV4JsYVmu6L5yuCLceZrn0uRBvHTwkNCnygiixzaqK9z+GxTh2RDb+g0E8iOHAtjDgOKZm5Zl9i/iFj2dmYbeoa07g0PD2DbueQ3PzoH1W+VhVcF0CYryzMUCzUZc2XQDlm/98RbV0B+IESMkNAKym5aHiNEWR9UDQyS82gWEidt/qavMZGdA7AaEFDVhnSQhfIEVEfkTOYhL8fwfbztjhlobuOIdJyYKLGtf4ZaxeXjrsfJ5gN2tJ06FfCopC9c94YvWvR1iNiO7RJS79XghbIRA6mt8ghJxGxONvZlF4q+7GbwBzukYmtiN0tJgLUKDhQlZ9aK9yN6348oY+A7prRsAQVfTeA3wTvA2QQ/qqq781JPBV4PYRPfLqw+c8quVu7ihUR/Tox2w+oWK9BGgjtW62ReesnKWgfL5B7hkTxh/v4VA78d2axRwJPq1QwFOoX55V+i8SZ1mLujyje73/5UC6hDisnI8JQGoqWxW25PcnFnK/niyortfira14gmX/Mw9Rrc87RHznsWf4U4vXulj6mZccP2hBpsyMkFBplW5FhQXPk55ATnMSS+8mjre9jQuPHE/NxqTFKWfKXDCvh4tI1nhy8hRz4QVfZr5juAepMiyRPcptuHLbAWd21c5SlMZgrAgAQRmfAEJNjMmE0mweaYElbH6qXj6nf9NXHSkdO1nXhHOqS3RxC5oE7F99OOc7qKUbd/W10gD79cOKkldqzMsbvzemd7gProgu80R3
 Q2eOOPzq
 bpvUzEu2m1sJ0rTBKoHPhymjHYSROCIws9dvR4Wual9qLL85wACLitKeRyAhS1fe+qAK0qfRe8EfCA0P/5aIaN5q9yGfrHz0ln6OHEY1K5gS2t+h906m2OAvmCDRhSBX+YSuB5PfPQz+tuoGMfKXD31e2q4Mk7//IwyMWfC1EE9ol0Kfbpr8wHkC2BW6/HMqhgkTb9ABISYfCLxsAChvHQlYzJwO62HuiuMQlMYXfcRjOsXSZAh5yKpNSsX2xv39RNTfAputRYDcBqRLzB9tF+DoN/lmFfWZW7/betGVityytUUg8fG9fTwoaefUNTURx653w0IKzrzzN8gw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Mon,  6 Jul 2026 21:43:04 +0800 wang wei <a929244872@163.com> wrote:

> In the ensure_file() function, the "not_exist" code path checks
> whether $dir exists as a regular file.  However, the intent is to
> verify that the target file ($file) does not exist, not the $dir.
> Testing $dir makes the existence check effectively useless --
> it tests the wrong path and thus never catches the case
> where the file is unexpectedly present.
> 
> Replace $dir with $file so the not_exist verification targets the
> correct path.

Nice catch, thank you!

> 
> Signed-off-by: wang wei <a929244872@163.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

