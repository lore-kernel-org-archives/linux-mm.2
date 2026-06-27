Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B840AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDDC6B0088; Fri, 26 Jun 2026 20:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADE06B008A; Fri, 26 Jun 2026 20:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D7C6B0092; Fri, 26 Jun 2026 20:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34A456B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:15:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5C0E40640
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:15:25 +0000 (UTC)
X-FDA: 84923773410.07.8EE216A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 038C4140003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:15:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bZIWrY54;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782519324;
	b=vLnyM4LPYIoY3GGVvzgrsxGA6Wf1k3dBo1bz0NyIgdokInx9u++AJjO8ybMZvLIg/TN3PE
	NjDQMs/f+4lEjkOvxvzS2tU3R0Sl108p7frTHItsF+jElYN0AVXLsJ6DwgvcEcpeI3FDjC
	Ka+HAYfOQqFhAT/B4dnsRwYTR21p1a8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782519324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KRY5OrO7g+cPT9+7+2igg1BzSLFiMUr5YncE0LQ8JI=;
	b=55xShhjwzCsFPdMuPM4d3N0nRgKJI4Dc8E0C4vHB2WuAD+/uVbsbZCwIUMI5fkPNrOAjIW
	H7JK3zHjjQG77GrZ3LFzwXTfWC3+nhAl45gsXpkoSnbJXnDDU5yiXkqB4TDHJdtU4+an/m
	DKVBifj9s+DeOCIbjCvmZGsGIh/H/xE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bZIWrY54;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEA44419D1;
	Sat, 27 Jun 2026 00:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444D31F000E9;
	Sat, 27 Jun 2026 00:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782519322;
	bh=3KRY5OrO7g+cPT9+7+2igg1BzSLFiMUr5YncE0LQ8JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZIWrY54veV5+26gLmgy96EhnXGzoYWtKD9q8OCpYYLYxx/YzJKpSL5p5SqEWDvjX
	 imioq55UvWyjm87pKOZ7aZg2U5eVnrPytxISK7GDFf+ekRRyS3GgB71UzPIU/0v8+S
	 WAeRNAIxaT7diZkxZ79AbNy1y1spRBkgXyUpArAT0xUE92jzopDZN9/qWHnEzXXepT
	 k90gcdox90LlKNifdSL6AOTstVp9zYFgeTHF4XZKXDEcVJxl1Q1SNUNwgExi3z7gdU
	 Vgb8z4D+CbcOtZaQQae4UzEgs2K3BJtOEmUjxuC4qSGi5iJssyRNlybi743yW6Pniv
	 VQq8JjLN9iQEQ==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2] docs: pagemap: fix flags location, member name and sample code
Date: Fri, 26 Jun 2026 17:15:10 -0700
Message-ID: <20260627001511.85842-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626162710.25844-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 038C4140003
X-Stat-Signature: ztjhbrwxjd17epp43q5zu9fzgfqq1aon
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782519323-67541
X-HE-Meta: U2FsdGVkX18O3ebi1qQa/yA1otyXZnUO+lMqb6s2UIc5nuVY5i5AK3wnagGdi7QA6v/ynPEN0ROeg5w6MSaBEUaItJfJyWz3JEv3tFqtyudVbhBBX2DU9eqiGA2BEVM/M0oX/1Ro74xWRZbf9HFiJGo1z9JBzoGJJNAbXVFQBbJcwxgcANTF42l1MoJh/5U1HE0PQx8rTllwws8JeFYmSv7CToypwN3bdBXttr88n1iI84CJgAdTnYG51gm5YylzilKk6jnefFIYliMVm8z9WPGjSL84PsH6haboanU7s8In6ZbX6vXHwc5ItUcu0Ta37/NpAxiLKAfXZ9SStDkWNOSFzyiU5Y/+6MOh4gRXXyJx6TJjN7hoX7TytuzaKH8Nfi0By5dN5tYKUj8xwUA1AyZS62t8q54wjI0KCv4HnmcBlcGi9Zlso8Mh8Mma9RxDVhcOOulLP8xzUlsQYNakYK+iJd4fKbjNEUQPfw68D4lkx8+Jgqel19f32OWmCkfasDrXvbzoV1ZTx7nPXBNdMnQv390n9Sba9nrXN9Xk6iWE7JcfHpmbnzSuHXAJzLmLmvU4do2wX7BJEdO0xUi4SYxO5wU/quvENt0PrJcQLGpIT0A6U7juVX7TR/4voGK1PhUX+fkRxz6TDpm7y5WlmChiG/hcZW1T4cXsLwPCcDkflK+tWgcm0yhxBAy6e7W1V/4g+wmWJasEBnbpr/FGQlp6lGe7HHRNtw4GgBq66XvekZkVFXvwvhipHDk/hqcVnAgJGbk6Guu9Vgx1UrlKVz/nsrN5h/nSTsso3EQxrCJGDIfAEwVquxS4S5juSts2hur7RhJ5CYvMrIfgDwukYjYW+ZiDlSTsa/fnn5eVEfvqEVuEbXZdSX4s1oxPBF+7h72zWa+sqmdZ3tMp7jpZ01QVpZJXTf0C5sE2KMfNyURrUZvNL8m5O+YVV/LPlgBIB0SlPyXQQIM/B9XaDzi
 r2PqWLep
 9zqsJqOwQJZGwx1wLFmGg5GPRddn0vaNY1HxgSlHdXKI+mfOVYc0chsZgH+Z71LC6jiUn+ZtFS/hf3oovOYNe5KUS5dbPmN0UGk25oRkuRPwYyzvpdSijrTyUHbN5eGKYC33Jpi0P6Os7MyIGHkuRq+0LdkfUQrMuH+6Db2umQ6apzug7KqlTiw6hG7eNXKVPsajq5IuZRmb7uqfiJvrgMTQFhzNMugq0YMocfW9DaytIX8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Jun 2026 00:27:10 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> The userland visible page flags (KPF_*) were initially moved to
> include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> stable page flags"), and later moved to
> include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> (Scripted) Disintegrate include/linux").  Update the doc to reflect the
> current location of these flags.
> 
> The member @walk_end of struct pm_scan_arg {} was wrongly written as
> "end_walk".
> 
> The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
> The second one included the wrong category in the required mask -
> PAGE_IS_FILE should be used instead of PAGE_IS_SWAPPED as per the
> intention.
> 
> Fix them all together.
> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
> ---
> 
> * From v1 [1]:
>   - drop PAGE_IS_SWAPPED in .category_mask (David)
>   - fix typo in commit message (David)

Good catches!

>   - didn't collect SeongJae's R-b (as the content has changed anyway) but
>     thank you for that!

Let me give it again :)

Reviewed-by: SeongJae Park <sj@kernel.org>

> 
> [1] https://lore.kernel.org/20260625174447.24292-1-zenghui.yu@linux.dev


Thanks,
SJ

[...]

