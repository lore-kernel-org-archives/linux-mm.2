Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F107CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0E46B0088; Fri, 16 Oct 2026 10:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A826B008A; Fri, 16 Oct 2026 10:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F096B008C; Fri, 16 Oct 2026 10:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EDEF6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:17:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B615CA0459
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:17:06 +0000 (UTC)
X-FDA: 85328691252.06.80AAE60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9523718000A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:17:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAXAfP9E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792160224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2VQkAftmXnblL7IeVaeDeAnYYS9mQ6ICu4SlOn3GcU=;
	b=c1EjM+DxeQWwIAtupnSv3NolZLQfImoLxZpxE2pQ2hNQIi8tjLCnT98CLU15h54czlxqgI
	shdTgRH+bTVXQx78R2gbX6ODSxiE5zUFxb0/C3q2syq/va38HIfKB7ASCCNXrIWBlC3BFr
	OQspcq6HN6V/unVFbaEvMnZ+xWazAMs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAXAfP9E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792160224;
	b=7MTxzeH6BLD9mm927sQv0SxJaU9eAPsp3seE69p9xUqpi+ffh7vMLDgfGV+eTkagHFn6aJ
	4qHkaOi5cCuAcc91XFr3Rhbx8shhysZCBq+jeMXbtVEKZc86piL+Hoaq3FCcn28BWLYfyP
	j4VFdn0zCmstoMqQfjN7KD+tMl06EmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6BAB40F3C;
	Fri, 16 Oct 2026 14:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE571F000C5;
	Fri, 16 Oct 2026 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792160223;
	bh=b2VQkAftmXnblL7IeVaeDeAnYYS9mQ6ICu4SlOn3GcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAXAfP9EuBjp2chpB8buw2ql+T/nNSCBvWeodlkEX1c0xKLO05HH6nVmzSZ0ckXoM
	 7ixtf6cBxqV2F4XjtO0nDq/LrOwREGst5oNVKujYyBK4o80v6zXeCd0WrgXKAlB3wG
	 U9DkTHD7hz/Us3hNuORN3cJghgiZad8Z2kzh+O5x/EQApZKqUnAyTkx+Xgm9lDuT6v
	 jI9e0dqvrE9gLdxD6l7wIxWn48RqlU+RVGqx7PwMRC/nR1JdIDSzApL71IedVSk9HV
	 9uU9wfiboBGpPHijAN2efJK2CoiW8+4S8lHJeC7HrAuR5Lb5sitBRIKPjzRgEEcESu
	 5CYoHfhgUE8jQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Fri, 16 Oct 2026 07:16:56 -0700
Message-ID: <20261016141656.126278-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179207592479.3.11595453180868898703@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: durq1nd3zz7g7zerxi4fqihqn7ggpcex
X-Rspam-User: 
X-Rspamd-Queue-Id: 9523718000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1792160224-298757
X-HE-Meta: U2FsdGVkX1/k1LS5DshNbkw3cL8aS7Fqv6nsxOKu5rthExhtIXYaoIJoE21iW/lH9SlJOUOW80VIPwhYYuhVtGtT9ci8kuNcDRBxpEk3l2LKt85LIR0l51LX8UXsq9uaLTKD4/cfnmP8aaP5TEd6GBu5yvcNiFg+GCo7daX7g6DDcq9Z38lCdPl6sBPj2Z98rUlOSN5T6SfXvs/z7rF7fQkSmgOsMenPVeDp05RhjA/sW8q1n7f8fz53AoVwjj/jvfHHANmaaFWEnSYgoxSEB3ehPCuGYCHMnviZzksuhBInIcKK2zMOnjMUAdaCdM/mLx537ReJIZlraQAzcWPkJfDTeGMNZlTYJg+JP+PkmJ/m+vMG7HORz2T4+22owHSSaCIMri+MT5ddzQajAQ4UX3fJYcSH/aTGG2f1y53MgSmJKFAgsfRw/8ZN2n6mzNgKkPOAnFuLl7L/UC3TRrrPeFumkz/7XW31F79FzinmvYSOEhXAM1RybUQsWR1jlTBjXui7IeahTJjGZZdierjpTuncTY0pFfIVubzTUyhW9DcQJs4ls0buHdRrTvA2VKOqBUiNVPJlVV5EphYZa/rTdwr9mQ31r+FDRQu38QZNX2pPqjnQ6AlUgdM1qArMCkqk34xdENXlLcxZftS/ucD+o2r+qe4HaCS9NNH1bEWxg3qWRsuQBAJs+2fNNSdJWcBSBZrUvnkoA7bGwFSxX0g17sDYrCZZzL3Z/KNmtkCXggHO9CaNJGHf45UQRzTKixZsHCkWv3x/6qHln2Cbddjmi5BX+9Vz5Q0+jM6AYJY9vxqaA2vyF/wjpqPp5bNKi6UgwmewppUWyBw0/YNP6sEkx9K14a+brpnWI4ZFpySyAVltI7tpLV5/qqPLEOCI8u0fDASncDvmsWbwn/ugl9b0w5k+H+EZ598Qs+LZFqOL0gZ2SpEm7pPac7DQoGBG/R/nib9t5qB1oz6SGz8FNLa
 NdlKGTjB
 erwgWyKkTmGcyvcAX3y01aIzv7qer2JUx25ZJ+lhfIuxcbmdKvMLg9dA4usE47EcDkEaYhAclUimQqnouGqX98UY+YC+UFcacFY4Fi1GsjvEEx2eAqtU8eVPZetQtYEQmrudmAhn3yni6cc1vBDvxXkShdokEc17EaOMRI6kL7eZiN52paCDAU9dx0B+aWFwWd9bbWF5tPoS9Rii2fj3eN6PJ1DZK+IdXUzNsJvjVMU5RmOqVRN5nvJoiGT4AgiZOxvI0RAGChntoORraEa8KsGTI1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 22:52:04 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> On 32-bit, accounted_bytes * 100 can wrap before division by total_sz.
> Some entries in memory_idle_ms_percentiles then keep their old values
> instead of being updated.
> 
> For example, a 256 MiB i386 QEMU guest reported p0=19200 ms, but p50 and
> p100 were both zero.
> 
> Cast accounted_bytes to u64 before multiplying and use div64_ul() for
> the division. Compute the percentage once per region.
> 
> Link: https://lore.kernel.org/r/CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com

From the next time, please give context about what the link is.

> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree, after slightly modifying the
commit message for the abovely mentioned small thing.  We are now quite close
to next merge window.  It may better to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this series is not really urgent.
Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
will request adding this to mm.git after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really  urgent.

> ---
> This is against mm-new ad9f2d463666. With the fix, the original test
> reports p0=p50=p100=19200 ms. The i386 kernel build, x86_64 W=1 stat.o
> build and external arithmetic checks passed.
> 
> I also ran 38 before/after VM tests and 20 same-image controls. Throughput
> was close overall, but median kdamond CPU rose by 0.0053 and 0.0221
> percentage points of one guest CPU for stream and sparse, respectively.
> Some pairs had 5.91% lower throughput or 15.49% higher scan P99. So I can't
> yet tell whether these differences come from the patch.
> 
> 
>  mm/damon/stat.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c

The above empty space before 'diff --git' line was making 'git am' of this
patch fails.  I manually fixed it.  Please do not add such empty space or
something that could make 'git am' fails, from the next time.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

