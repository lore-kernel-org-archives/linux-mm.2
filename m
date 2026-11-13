Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E48606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEbn3Ucu
Received: by kanga.kvack.org (Postfix)
	id E77EE6B05EA; Fri, 13 Nov 2026 06:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF516B06CB; Fri, 13 Nov 2026 06:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA7F6B06CD; Fri, 13 Nov 2026 06:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A216B06B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:13:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBB318060E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:13:18 +0000 (UTC)
X-FDA: 85429834476.20.48F5CA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2EAFF40006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:13:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEbn3Ucu;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568397;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYPIChJtLZR0TjyFHbX9L6fpST0b1RMxFFvviYHMHxQ=;
	b=QARztXBbCSONWu/7nWzeBhsIK/F3/NhG6XSHrtRZeD0+R28bpBZjqSK8jeNIKkNwuuho4Y
	Wk4J8pYw0oHfB17pc3rECcuK48L5SCTP5OGaeiXIoWVHknoadZFWFfJvv7SgIyTAOQXzxs
	Fr72czJwLnDOCk+bG/rOZuFPqUiL6aY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEbn3Ucu;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568397;
	b=0wbpRqnNuCwdaKUDMKCLQe9dRs0D0/c+/sW0Jp5CTxIX58qw+kzKew5LL9ysqwsrwsIWAm
	ta1MLNroiX7OEMXNEKrjR9HyoD9Ix6DJvEX17mDaXoLLM4Ti6VOaTI726DM/XFiheeLwvv
	L2C20VhDiB+5QuaR9vu+H5JMGlDIiZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96EAF60D54;
	Fri, 13 Nov 2026 11:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6311F000C4;
	Fri, 13 Nov 2026 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794568396;
	bh=zYPIChJtLZR0TjyFHbX9L6fpST0b1RMxFFvviYHMHxQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QEbn3Ucu17qc2JuZvB7FvTBnG8/LnVWeXYxTLhwBTJT+wG+kLETIfzjHdlM5HNDiy
	 fHS0C2sXn7gXo7GY1uf5ANChWu/o+vQYiZYEget/wwE3ub931VushGc6jDjeOnl9Pu
	 PmOqWGnx2thMOsghwSXZ7GEPTL/NtACgqWH81waDb06WdmQXTk+7wxP4vbDaYAiDQ6
	 ElDEIsiTnQBz5ea+jA9g3yOnGsPF5qHwugFWI4sbO0yMG6cWVKTTDVCC1lkX8rn9KR
	 uMFqKzcgW/m23M9SsTn4nn0+KqAAh9O8ERA0f9f5TJ8mMGXMHBmZYgcUGAcS8hE/9G
	 BcoVUBRnaXasg==
Message-ID: <sashiko-outbox-212685@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com
Cc: baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, qi.zheng@linux.dev, shakeel.butt@linux.dev, mhocko@kernel.org, linux-mm@kvack.org
In-Reply-To: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 11:13:15 +0000
X-Stat-Signature: gkcww3fzqt9houf3td33jauw7x9w8jwq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2EAFF40006
X-HE-Tag: 1794568397-678460
X-HE-Meta: U2FsdGVkX18fLhJIqwrSgJ8yoiSX9O2UDuO3k8dcbJawAoWGYu3rBtIcXC6FyO5f3bWSN0WvELMyXerktTSrpGMRpg7eEEeNJvcuNw2mBB0+uX2iKudsRI+IAYUBixyO3haIa/kn7JlFQdOM4r3ehNLbQwQB+pi7qWWJngHIKt/QOBTW4o/2ALblLQPy8SjsHApWSs96VpClhS4mG7XHlqp8BnvlfB2bKfySvX/qbKet/XqVKw52ZIDK2FYKxsq6/WnjgCdIuMP3OXw5lbgyVM8ngcJG2EK0H+Ez8M4v6MX+Irk4SuXuAO9aRpalOHOmebWReQ9IE16OGoPlU5lulIsK70571GArgI2l2RR5e93Ypb6AJbfi4mm9EJ7Gz14h3do9X4eVkjm6nNnbsT2n9WmxWKAty1YU2/sUXE93Socj9iukvrEVtmOyFkmI/HAPaTUZm1e1L8jOTCcY2ukqeo6Qi8gFHWYQTjBKytT5CIBb/T7CK5nM3hnyz1rMHU1ByGB5nyyeN6+DDKPHVKP9kx9dhZDxBxbclAqwB0hZjQCCNLmASXGILQq6h9RrN05MOibevJJhWpW7GL3cUtUJwJdLMnSjFylVIRWGIiR+M8YqSom3+awaDw8ef1CZl1OF73nP7+rfJagdKp1DJUHLQY4rfL23FmBe4uY0DHJ+2dVVVtz1PM1NE29IY2edloWPgLgLGj1aiUTH2klPrzuO0FVOSvH+2XtvwAKj3poESFiLhfk/OVwE3DiIINcdXtMdlXXYTxcvlGFktXSJ3t4qfFt8m1oWZMmjeSYnh/e9MPyUjyAon1nN3f65aP/YNw/ujPQmXTh2ZjdZ1zw6gn9n+tYeqt0QxAegMpR7O2sg3DHUZlDD34F1eFN+WWatTOKK1CikSbNoyQaKQlMh8UzdJyIM7RE0TIIQikbzqYTdGpoawkZkPahLADgPTyZPbhDPHAz+c77yRBkLDabBb78
 8KQX3Wpi
 U06mJiAVr5d9sPsuC+ALU9L1W04dOBS7MiJjp6ow5/zjaPCZewcduFIq511iqQOKCdyzqhLdckC873FOdX6ZAre8rF79J/rFqH3jskHLy5mQAm074sOwckZYZPf3lL10D+ilArpKVL7HwG9EfvLMnaDEm8ed4+alGBeNzMJ8KH+7E/pB5Ddg0yEkm9ojyeWq9dtnzI7QzDWZLW0gwj8rq5IdiHzm8gWUWALRE9AxIUnxHnPBsqaLqVOqX194z/i9ksmvqbU/yemXAv3sBntqAnpXySOeOG2l7bpgaX3Fxr894KrT7ZTSEnGdn4r39Zk5LqrMJrxMcU2bunuZwrw4Lb7bMfn2DrfawLMjDu5aEfj1j9IoVE29lOhdAupduwM3w1x5sP3IqORMfJyMzdj5PdHjwbQvTMHfFz+x7bwKPqi9N8e9HOi6Mv10wM4i7JPtLP5tyzlPAslFshp7yV620edVAG9SWQWwakAfhDHlQSzSw6uSPWxyz2tDv6cglDXiRMqU5239BSoHM+2wvB4Qa9MpwFMrqzuNsfNoE867XdmPouT4cjUk/NvSNZZ6VzTPW0KhveuFF3pEgZa/HUHG1U+HropXaXNs7zZ1cc/G6I74HBZMZzpRTT9LDypPfsbOzGvUE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm: mglru: call to undeclared pte_table_clamped_end() in
  lru_gen_look_around()
--

commit 921adf1dcfd3cc8b15e0745e6085a76a09ac3fb5
Author: Baolin Wang <baolin.wang@linux.alibaba.com>

mm: mglru: use pte_table_clamped_end() helper to calculate the end

This commit replaces the open-coded PTE table and VMA end address
calculation in lru_gen_look_around() with pte_table_clamped_end().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 25a224746c36d..cb8635e41a38a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4340,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_wal=
k *pvmw, unsigned int nr)
>  	walk =3D current->reclaim_state ? current->reclaim_state->mm_walk : NUL=
L;
> =20
>  	start =3D max(addr & PMD_MASK, vma->vm_start);
> -	end =3D min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
> +	end =3D pte_table_clamped_end(addr, vma->vm_end);

[Severity: High]
Does this break the build when CONFIG_LRU_GEN is enabled?
pte_table_clamped_end() is not declared or defined anywhere in the tree,
so compiling mm/vmscan.c fails with an implicit function declaration
error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/b2386c5da61f9a15e60=
daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com?part=3D1

