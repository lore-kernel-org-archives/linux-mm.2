Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D93C531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E68D6B008C; Tue, 28 Jul 2026 12:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE896B0093; Tue, 28 Jul 2026 12:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC296B0095; Tue, 28 Jul 2026 12:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5C46B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:48:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B327FC03F8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:48:55 +0000 (UTC)
X-FDA: 85038769830.15.71D5C5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2261A20005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:48:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRXc1Fsv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785257334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mpr53o5xn048mORlTpkeftfNBVvFhPpp4N4joDXnfPw=;
	b=vqHYw8qyfzX9xGDsVwGv1vbSYYsoP+Kp9rSg+E2qIPpeG8DJeqxGAXWVwJtS5o2aqaT9Od
	7d5Hqlt0Iv5eC+fLJdbSjjSD70miD7XaMttg9AT1LMvroa0ccr9fafcPFlV5g9Jw/WUt9X
	PDdfILeW977D5VaT4oMmfiFyW+/0g98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRXc1Fsv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785257334;
	b=C8EhWJoY2ZLRaYubf4oEv0Md1khaXGc3gAxjBPUfSR5u+OW/n4vXrWhttrddl96z8ijn/q
	gAFmU0fuAyV0qNeOkeu+nX59gqAulrYR1ajxhqU+yUfks5nrcPfY8Yqpbn4duQe8Pm8qIq
	YD/ZZ9WnmzJ5t6FXZJ2zfYexMec9QdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7779144026;
	Tue, 28 Jul 2026 16:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B42F1F00A3A;
	Tue, 28 Jul 2026 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785257333;
	bh=Mpr53o5xn048mORlTpkeftfNBVvFhPpp4N4joDXnfPw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=QRXc1Fsv1U9VteDFxkII/v/v0DebIa0cUbezprpMeQqfxtvnDeOdUFlh3JyBE1BxJ
	 wSjsa5zp2EyGBYVsNdL7yqXNRqKzc2pVnPZymvgmVEB8IJ17PGaY02rD9KsLAuMN6p
	 TifWgkJ/6dzAemeOS8wXamIYZ38Y6JiO44hWFqx9kjec4m+GmnuWlqq/TKIsjXTnkk
	 NJGNBRMeUMPzLof9Z+rrw7pddoJ6gxckrJm2pvEXo6wad7iP8n73PrjzpCgHL1alMi
	 yVHcY2oeyGQUnNEz5/QMfcHTtQ08PG63y7klrk6zrM44b6x1QwCnhp5YXuG4l+szv6
	 XjxWjIUFgwv/A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 9/9] mm: always use the zone-device template init
 path
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com, 
 david@kernel.org, kees@kernel.org, mingo@redhat.com, rppt@kernel.org, 
 tglx@kernel.org, muchun.song@linux.dev, linux-arch@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260720120259.1545-11-lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
 <20260720120259.1545-11-lizhe.67@bytedance.com>
Date: Tue, 28 Jul 2026 19:48:40 +0300
Message-Id: <178525732063.1556190.16834028754418994747.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2261A20005
X-Rspam-User: 
X-Stat-Signature: hmjkbffqqacstb94kmcbkdkftqpo7m4j
X-HE-Tag: 1785257333-66840
X-HE-Meta: U2FsdGVkX18gkHLhTU9o0eOo8SvuZLmA4MZyXRadaDQgOY1bXtkVfyS9N99JuwtzbYhhoRsTu/O/hdHdQ8ayAhiKa/0iFWH0aFzu+SEqKw5q4deJj5M8jkdzrzsrnBxVqzu91lepMFw8baW++U/rqeXaqg0MEZ0a7sv49t5nRthqzK4+oQ6FLlJNEloQrwQOk4j9jLVc60tX/cG9X7pnNj8NOjBTWMGAxTZV1cwcO9XVCiTWBhDx+Pwb5/ZYsyDnrWXj1Hfb1DdOOX+CogB/krLQjedY/8ImIsGsUMgrnvZJmQrpSNZVgPGX/c2TaurkADSbitG1RtMV/+qNoQ25OhRoxEzzXZwZlIjMENPiKSCc76xzUGZcFs/BMgMtTdCVBg+nnFF8LczpXVuB2BvDXQayX8Pc7aCmTiwZwmQP0b7P0E1nH2EMEGtaiXZKQWgP0daBzc/KTl1Q5OlRSLuRxVY5ddD6QwqrpG6BPGjNN4DY8dZLXoF+sSaMDzDHn9O9n+jVuRj06F1k+eQAepkcCsQOBzJaYT8Yya0dcZ/gRj8VkOdsz2rUtQ3a2YRHmhyZf3EhoCZFJsNiUePs7FCzk9uC5KZNcSb00YTZX3e7V+lhod5Hl7lYIXDB4S2vFEiqR/fipa2VBYV1OWc0M3iLsz00IuvdQznazF0Hb6gQhYZQw8qOIGh5mzR5YaeHozv9KsqrbLToFozwf8Igtl79in8twsBy8Cxp9xLSHl2TqnKufip9dUyf58LLFICTb5OkddHmPDbbHLHe9cqjvllmdxE0X6AqLxlIbFxyMwo7G8Dxfu0HxAGaP385NGoQ8+uCJNBngSkqyzz2UGPY9RfKiB+xeeDuAbzljTvzTDhYYMvFuOQUiofyAJaj5wfOrW+nUxaMnKzVqvhV+gPIPzGdNwUQkrOBHBCggs33l/3lx/YN7XwnzDtlqmwx4bPQgu47dxjAC0mzZRPX4iOwT+D
 hAFXro4N
 te6RCG1pHUVP0Raqhwm6oispOOmu2ohNifcbffkInBabqePZPZ0dG7PSRBd4zygT1Z6KR4VSbrdlNTkvoxpe4sdjIP3N5/YJ/bC52ycrHj/D7AEf8Muhjvk9iBN8Tj3DhfeQUsMTqV24DW1hDO1XpSOINAOTbmdEHOGaJ64GTdpuz6pdtGZyMsYNil5+dOSkFZcOwCSHyj2K6byc943yY8/iE9bXFQIa1178N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The template path still has a local opt-out predicate for the
> page_ref_set tracepoint and keeps a non-template fallback path. This
> makes the code more complex without a strong reason to keep the
> separate path.
> 
> Use the template path unconditionally after the corresponding seed page
> has been initialized: the first head page seeds the head template, and
> the first tail page in each compound range seeds the tail template.
> 
> This keeps the first-page seeding logic unchanged, but removes the extra
> non-template fallback from the main loops.
> 
> This also means sanitized builds no longer force this path back to the
> per-page initialization stores, and an enabled page_ref_set tracepoint
> will no longer observe every ZONE_DEVICE initialization-time refcount
> assignment. That tradeoff is intentional: this code is still initializing
> struct pages before they are handed out, and keeping those local debug
> special cases would preserve a separate initialization-only path while
> making the common code more complex.

Just fold this change into the relevant patches and don't introduce the
opt-out at the first place.

-- 
Sincerely yours,
Mike.


