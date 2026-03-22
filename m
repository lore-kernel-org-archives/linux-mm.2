Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D137FC72DA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70BCA6B0088; Sun, 22 Mar 2026 15:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BBED6B0089; Sun, 22 Mar 2026 15:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1DB6B008A; Sun, 22 Mar 2026 15:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5836B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:26:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CB8B1608F0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:26:51 +0000 (UTC)
X-FDA: 84574681422.17.9518846
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 82721160002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:26:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UiZD1+x/";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774207609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FYe/fkOL0nbw52LQUk6QcDrHm8WitcsBXB7zzlUT3g=;
	b=eKHEtDBuH3uvqKo+D8OhzGHzg/dYdvJcqvCixq6EKgZMxadA/XaiowYtnp1b2UHi2xuVsK
	GuovFjh02WX6BhaDlvqyt8IXz9X0Cm2f8SW+8nLa1IcR9ME/THnWtSpoFqVmGMEZho7x2E
	YGb/yM+WgDb2ncZEZHJkWr3sFujv30Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UiZD1+x/";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774207609; a=rsa-sha256;
	cv=none;
	b=Z7E4Qsj12bC2zHXp8XjnWn8corWJctxf265pf73lBEBmZczlU/Xc/3DMLdc124RiTcZgwq
	ZiMG38ZNRWVlAwm245X2CY2Yq3P6WAMboFms43XwywTnCgMIZYzXgRoU4pDV2Z0XdDIQM+
	jdJEWoHxXGTIOcSDt/47nWXHbyJ68d0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7717340585;
	Sun, 22 Mar 2026 19:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACB1C19424;
	Sun, 22 Mar 2026 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774207608;
	bh=X2DK8H4FcYtPiwS5iIb457FtPn7QN07ZkhbMOTso2XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiZD1+x/nVOYnkRO5qYh824b+4jHHTlKk0D8ItIlwe6xN878lJgYIeLdhlrMnIT3m
	 RMe8k6LPrBU5LA0ckrvSPYCU7l3PIE7ABUVuU9E+B7W5QfGLG/4PSrBhWsAX5RKmSz
	 o3qrMQvaL/KvVM4jFc1ilhEmqkK7ZzoVpw4QaShx/p4G737WNesAnW8Ck33sV3FP70
	 r0rKJgsMjEWE+pZ82cUiiKzHemb60reqp8ODiBFS5EtojiM9tQV3ftjA00FTgxfmWI
	 pcd2OUb9Y10IpYCrlf8IxEwu6RCjnA4fiHL5yMvuu5GOGZpNWlLDkfJqCQidVSnm+A
	 advWRx6HtLSXw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: avoid use of half-online-committed context
Date: Sun, 22 Mar 2026 12:26:40 -0700
Message-ID: <20260322192641.87848-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321021628.78887-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 82721160002
X-Rspamd-Server: rspam08
X-Stat-Signature: ouqgp9xprkieypcwy3hgz1k6m1zr7wi5
X-HE-Tag: 1774207609-893627
X-HE-Meta: U2FsdGVkX19xSmsctXGsEUz/V24N4YCzwKQCYZYR+VllKCJV2lqf6v0NkrZ37gbX6gjo8TH5veo7zS+Ec42Qmsd2pJko4ssh+Q0O+DvQAOEGwjIPiKDHjA2Z2dgLkuGvAW8f1jFYHj/RG/t3uzCVGXHCQD35M0ME+d6cbOvY/JnGI1KdbygFlVwVV/m84IqaEhmYPTXbflOhrw3K9xpStkOW4/Mg0e3StOPblgjk9WBgawlt5aoI4Vr+J2cSlmIr9JTnjZ0/VsCbfcx+ieq2tJ9WROvbQ8X5ngWoAJZr7ab+1YPuIATcMvIqQGefUJAXrFZlC8VVOvtoUuL63lwVV1WgoJi5IJODHGtoQBhz7ss5jkZwdur6PP2wPUZ73bjOEq5R20qXa21X4yyRmL3bKNl0x9dDEF7doUt+AQq3PtRQt+XSnj5Xo1ye/mCxnX1et+N9GpE3HnQqYiayrlAx1DGrCIbpRR5KEoqA/nWkpFrknJBALcgXXgOa35hEZIwqBfAiBT/uMcWjjXQgzS8B/4dvfNRypts8sQ7VEBaM+wCTevVXKkqtOikMvdW89T17j9v/aBafDaSZdn7QfQEV2+Q5mqT2UROO2CM5kF3r71yFuDH0WpJCw0HmPqh9Pvorz5bcetipD9k4h0rEobBUblPZwnO8Qz9/BjYwU2jQnN5ukqU0uxKiLgXZY4ucqkgQf14DE3kzN/GIyUmhdWxALnk24NQo9YkrIUVjP6Lljesb32GXMv9e1vcuyjBDvS3NuxmUaU3eUScDTsZHzuyG5Jxs4XfmS5tugf43MBqNfesT3dcQo2GqyVDbJxJQdc6MiKrLahNByp9FL1hdKaMYtbWEi7nvUNejQvC1ilsUVzO0rQCNB6tQhLUPjNXdqvm2IqOmSKwm1FVdHirpzCdtmM3Ayl8AyrsoAYBKb+Jh7Rzzgh13F3GwWEXHwMs6F+YV0oSoNgZztxLkIqMEpqU
 EeEc6bSh
 25jO7L/ARpYbwIRgjNn2OpkNp35cXDvjUnJEniDIbYBwm5T9UjAHDIVRIirIhsp8nrnqapEet9Ia47vSFOVTcwL8+F2BEMgnuFtKmu5AIUdl4rP7kygP3sZF0Jljoln+Hx2gnvmUJcVNtU6L5vg2G9I+O7zghyNOXBf5IIhGb0uhq7rqCi7XAy0e0bzafU8s5BezAFcgNBar9LvOSybmbYfdNtZ3UO6U0fDfIjlOD6wBRBtcs87iXxPwq5+2oZpR7OpshY1Yh0dkf7zV6GRgc1+Ulvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 19:16:35 SeongJae Park <sj@kernel.org> wrote:
[...]
> By the way, I am also doing monitoring of sashiko.dev for all DAMON patches.
> It will be much easier once sashiko.dev's email feature is ready, since I
> already onboarded DAMON for that.
> 
> Meanwhile, the monitoring using web browser is somewhat tedious for me, so I
> just implemented an hkml feature, namely
> 'hkml patch sashiko_dev --thread_status'.  It receives a message id of a mail,
> and prints the review status/result of all patches of the thread.
> 
> E.g.,
> 
>     $ hkml patch sashiko_dev --thread_status 20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com
>     - [PATCH RFC v2 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
>       - Pending (None)
>     - [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 7/7] KVM: selftests: Test guest_memfd behavior with respect to stage 2 page tables
>       - Reviewed (Review completed successfully.)
> 
> I'm planning to implement another feature for formatting and sending the review
> result and inline comments as emails, probably this weekend.

Now the feature is available on 'master' branch of hkml.  I started using it
since yesterday for DAMON patches, and it works for at least my workflow.  The
documentation is also updated [1].

[1] https://github.com/sjp38/hackermail/blob/test/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list


Thanks,
SJ

[...]

