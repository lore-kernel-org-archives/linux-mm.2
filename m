Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6743A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQj/Gx4M
Received: by kanga.kvack.org (Postfix)
	id 7014C6B05BB; Tue, 17 Nov 2026 05:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9646B05BC; Tue, 17 Nov 2026 05:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EED56B05BD; Tue, 17 Nov 2026 05:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E134A6B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:03:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 723C2A039C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:03:26 +0000 (UTC)
X-FDA: 85444173612.20.37386E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE8AC140006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:03:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fQj/Gx4M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLK+IGv2ggFjXZSuGp8l0UEwQwQwUf8yC75OsLJHlz0=;
	b=VzIVPiSToQEyKYLrQyLcdVTdOjiAXCL1Ts/EJZm82b1oxMTag8ygrH0/sHsJ+fHUma3bQp
	XK13ciQPI03T0Q1AVtgUurb+M14d12MCtb3xRZQ/PYyfb8lb1MQU6xstRMfEGgYIqM+86p
	rlo6cUAVl13C2uyEUrOwjZpYk88Kf1A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fQj/Gx4M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909804;
	b=1m2pFluz0nitptfYxsEOdQyWw/+2sjxacgs8nY2EQHYFeeZ2VxTVfLxD9Cj9Z5KzSdL8zq
	9apXsX35sLZQRVaSN7bsAWD/oopFf/DqphYIJUOQUei+r3YyjB1jSrDar9i9MoozrUEZRd
	hXUM6w4/B6B2u74gazOfCX6zVsZBTJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCD61407A9;
	Tue, 17 Nov 2026 10:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314CB1F000C4;
	Tue, 17 Nov 2026 10:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909803;
	bh=LLK+IGv2ggFjXZSuGp8l0UEwQwQwUf8yC75OsLJHlz0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=fQj/Gx4MpWTb0HS/QyBN3HDcXOn2ruyxu1noi4UPMonZE4mwguKdHXtczFhB6PLXY
	 zrvoMBTb0Xhbp3f74EfDYXeaSu+omudQ3+lHy9Map9SwVotVMNsvTWRI8xEXyNFK+I
	 9176wuEGJOZ8YP3pqq8Uk3rvsZRGFARZP+MZ/6EDeW6ccrjomOYAPtQNaZz/kz4x74
	 7hvpzyVC5oYV8SD/dYJgx2xIuwbAp8UJXfYB1QLHu7tasggTg/Y0OTWCL62q+FLlYO
	 7hQiTUDsT+rwQ5/2+WJkqs7Vmct9jm0UbaSEk9G5fF9tG07eME5aGR4QeM/Uijgly0
	 TNdqcbORy+cMg==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, ljs@kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20261117015009.611551-1-xu.xin@linux.dev>
References: <20261117015009.611551-1-xu.xin@linux.dev>
Subject: Re: [PATCH v4 0/2] mm/ksm: clean up scan_get_next_rmap_item()
 initialization
Message-Id: <179490980182.4957.9865090817609300343.b4-ty@b4>
Date: Tue, 17 Nov 2026 11:03:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE8AC140006
X-Stat-Signature: aqh69s8o6eawsyhhqmab997gdpy4ugf8
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794909804-120042
X-HE-Meta: U2FsdGVkX18+ixI9/2+at56sfcqoVbMhXVz2/YL/Q8shChziweq9/LhEI0RwCguyRS/7nclOir5S/D6VXR7Tw69uo7JHuKmW79ZrsbTZlmWQ87+/2brhcLIHNp601l68/Me4Iw0rzggcJfrLE+8lRumyS8psjaDtJ68yzsdbX2k5RlcqdphilEmDWptcxkCnqRkKL2JEtmFVSnE+ybtT2TKObl43S9euexbdaSljGcliMdqehxpEO6jtEbIcEVBzv3ecYOnVp16GjxIyyBuFaCJXhVbmiB8T+PHz7JWRj4ubGpecOPETHVcfOwhwoQz5r1ENkHA6smWUEADavaC6+N/DVTy6PsoJLXOddHJQYeNE3eVoQyhirvXg71ldPOz1jz6dvXBfxEYeIap7+2/UTSmScY4bNNF+sQ9NBD+ncHJl4/QLb7kjfqfatjhLlvaN+OwQx+jFIzyYKtioIsBwpaStaK1+Ntdzi7afRY7iAHBEEA6mFWqqsUKaHkOnKkdbFZvTmPoBsLteyfh52sr02dFOWB8aFVpwY4qV7sbYS2VGZSYJDgcU/0ZOW+ZNZxzupTA4dM9WjJ6P1Xqpd3vyT3qjvFiltzvkqKaFQ9rICSFCJ7UTT4dLjjoGGvFXfx2LlDMULmZ6t8Z5G1lAtHgYjJbRD+xhoRiS0Iw2LAh6Ksw2cwAXu0/+otMgqWnV8PRTylFV/26wdO1AF5IslilP2jN8iTiY2yqLdW0x1TIS7t566KSvLh0wABYN3b3prxoc6VYANCRw6XyaaZ2L1p8UOIqoqtbi/eTFzaSMPGGQj37qoLuMIhoLb3wzY12mtuQnlkuWTi5SeqlbNT0yboyXh7zdX9pZ+G7C3KmageyVOfkc3tbChN5OZibMHKZUXnWwEC8QEGC6aevMtXw/FS73Tuw03438RGdAivnnmNawnIA1Q/V9RfbHsLILQ1F0ZQaC0c7GHXqy2fGsydcVpAf
 +VVfptO1
 j+eMfNpKnOHFf3BqeRzx7FKYnh9gC1z36Op1Ppo/yLb/piv/eHHTpfEbaIgsMu8Gp6Vl4A/Rdy8fQnLTO9evKgQ/gNIHnvOyFN3oVCqdqijMzknSzQdXInrRYYupayQzzyDeRBedE6V5sM1W0V2JFZF2/zmXu0oo8oDSUIPdUk9bq3in0G35Gui14qoL4AuE4SnpqNk4bXVREhmqICm9efNH0dE01Qo3TSPHvOIk1H6whP9EBW9rTUWN3g4ujLGa7T1R1GuJpZS/JFe4sGtE6gaa6qCy5thwidksT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 09:50:09 +0800, Xu Xin (vivo) wrote:
> Currently, scan_get_next_rmap_item() has grown quite large and complex.
> When introducing new features, such as the only-merge-zero-page mode we
> are currently working on, we don't want to add more complexity to it
> and don't want to touch rmap_item structures to avoid unnecessary overhead,
> so we need to extract some common logic.
> 
> With these changes, the entry of scan_get_next_rmap_item() becomes much
> cleaner and easier to follow, instead of being cluttered with unrelated
> boilerplate such as stale stable_node pruning and cycle initialization.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: ksm-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/ksm: extract helper functions for scan cycle cleanup
      https://git.kernel.org/mm/core/c/c3ee56cc
[2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
      https://git.kernel.org/mm/core/c/0eec9abe

-- 
Cheers,

David


