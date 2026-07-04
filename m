Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F91C44500
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 05:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876206B0005; Sat,  4 Jul 2026 01:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826DA6B00B5; Sat,  4 Jul 2026 01:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719776B0088; Sat,  4 Jul 2026 01:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47D976B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 01:58:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE3EF1C7B41
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:58:26 +0000 (UTC)
X-FDA: 84950039412.09.EE6EFC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 30C831A0005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:58:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYFOk2kT;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783144705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V83zC+ABVvPZfpSItIVfm+fybD7L3iVSBZB+nvmmqYw=;
	b=xpwq+m5jZ6w//RDOfJlJMvVorv/Am7bEj60AM8gvFzuPrrE9HaGCq5UDPR23NsDms8PJFf
	JtdwGyDq8KrXxVfWcRomMxOlxdxJRldXACO4GgeLkDhqNwmmMNmvpfDiYG70S8a8UfLIKX
	jnNWapvGYhZ0z5T22a0RYvHJTEL8elU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYFOk2kT;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783144705;
	b=lv4wb4XE8a616Aly5bZee8p6pw0Py/fa0+4y7oRgStcFvfjf91/Q/RIxyELN5jAxdHey1O
	hxUHOet6gCnQoZ2Ez2N5Qk++dhTQdJOfzfEDYkckEKS3UDfj9QlmTl5GYbeNvSmx8eazQb
	lA8SbpvCS3LuFwT3AxI2ZigoWU+t7+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0C1743970;
	Sat,  4 Jul 2026 05:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5E41F000E9;
	Sat,  4 Jul 2026 05:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783144703;
	bh=V83zC+ABVvPZfpSItIVfm+fybD7L3iVSBZB+nvmmqYw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XYFOk2kTGPelgRFBCFOy1e5BFq8MR3j2nf5Ucpe7/CKek5scCr344MHbsGfXFuNmW
	 SM7L6Nm0FhGYcdqcF8sq95YTmN0Jhh+1bvL01+d4I8L3OqZb4nzcM0a44QZmuUkEqK
	 GL49THk2qh/CLM2VQDUspnlQBGKR/fve39dyxR7GqFTAptP9L5MO2Hq3rvvtkOWVZb
	 Tn2Lg0iLNmYHqqjLDR/XddQRkS9/G3DRPLcAYbxwcsrcrXuPBWPj2upPA87MZvt0mG
	 oG8Ag4kev34nRzv78qXAbeBSXty8O5zELZDATZ+bH8paUbrgk/ra1kgfGxNbJW11hx
	 muNf0rKM83uCw==
Content-Type: multipart/mixed; boundary="===============8802271696774654361=="
MIME-Version: 1.0
Message-Id: <c48aa4a4b43fe15d313761d70e2113405c73ad058911cd87d573946ae1740b9e@mail.kernel.org>
In-Reply-To: <20260704045617.487664-4-ziyang.meme@gmail.com>
References: <20260704045617.487664-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH 3/3] selftests/bpf: add memcg_stat_churn_percpu BPF-vs-memory.stat benchmark under cross-CPU churn
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,roman.gushchin@linux.dev,kernel-team@meta.com,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ziyang.meme@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat,  4 Jul 2026 05:58:23 +0000 (UTC)
X-Stat-Signature: baezg1orbmwirzbqabuodzb6yf4arq5t
X-Rspamd-Queue-Id: 30C831A0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783144705-886350
X-HE-Meta: U2FsdGVkX19IY5g26YoAEY1A7kB/e3xT8IZ3OiIVnWWtpy4L9KpObdSLgAhX5DAcrAHy16ImhguE6otJZu9tsmnOddvGbVXtJGubJ852+I13nHOKudtX22rmeq0ERcCW4COzQg6JYNea7fyTmEyuWh2eCBXZgtxQwVN2yG1UENC75KYSoU7XBWq4qgjFQ24VpK1+0jfQi/u7v3z8aa8ZsWWiei4c45qIc+poxDB/XfaymzpmyWH7QxjN3ZakmR1ovf6VWzDTro2GyTZqvYlbtClI/jT5f0/SH9sgig5mbVI2ERibaVwu03CmStlV5fEI6AopOJLKszio0f05XUw+6c8M98n7jF0V1CERvJF9vMxPu+QUQObbdPPbFlDOo/V+bLE9raMGvVlI4msfCYAITzzJm74aZHRtah5CsU49lVozQkLLwzdaqqo+0Jw3Xsss5j2ek0uG9nd8SlOHtvloolmyxu8MTdfM9n0Dja+FPmRGPDgn79sqY/A53q1XzhrFgSDFTain39k+8qpDgXwpt9uC2Bg33dEqHaartc3PefdZ8srZGyICnaGYmwBxdCFRDWGIzl0A4TPxPX/H+GySUlTN+z5hJnZDEPcTE4lp0JTFDNtZGl9lVBQZiwemXREr4tcDN9Xba5kRe5A446e0iEFXHP6Mn7WkC4izDWvIoRKB9TsUm5Q1V0fZXjiYWwzJlQei0oYLkHwmC57ZMRh4JQxLdcQWo6LkLPxBNRhK3AM7rvKWULoP+ua+10gtpy7zSqv8kwW2cBmM6A5Ji2kTI/SIV4eOg1Y0Ek9P9XWw2SuGQoJ3H5I27HG4xoIjmSzap6ZI/1lRnuWMMBuk5+1TUYt1Vws/sprbnqgr7H8xFMaPN32CRU4NdLK5KVeaGuiIljBskwTSVsg/j9OlfeaSED5kW5eU90o52zXkkWC8VU3zSkVCoyv6Dcji2M9x/Lo/qsR7D8Is82ff9wnxrJB
 CpDBJNm9
 C0hs6VIKgnsyI+JNt5JlBdPtN44jbgrKilO+FE3hnEEDBzaLJINqjrVLdQZtZNqnQDi9FZZkL0Wt0Jl/5741+jDeuNESwKt4ythP9nUKgRvA0N7Fx5Tki0YxnZPeswiKJ2JDvJ3VuVRWDW34RoNPD9fTul5HzEFY2jdsBMToaTMuOK9rpxe3Em0A9oh7LwCX+WplpJ172TFsVrRjaCB5gz94alQ0V0n1kxYzjf6IOBTo0NbJzr7q7aML/KDMFfHeyyx5b2DWp4Hf/OCVLZV0j44Mbp0AmYon4tN7mMLgksrGs3HDMdeaoVjKSyCa8CPMmAsoo82e/tCwSPssX9MTZIAWQDbBFJEa9MfmT/qLGUYzevAali1hkYVzGU5dvTwU7ocXkoPbLANijQPMNLJ134bISoLa/duNlz7yeAQv5WEykeJwCIE9nXYQskQGVkgKgxo66nKDn7FOW3GYdCoTiNF1phrDVdwFXdX7xW0zfXyWUz8OGC97KAzsGjNGp9cbMPMcYvJpx9WWQFlkU3Z2FhjSCZzLevXjljHIP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8802271696774654361==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn_percpu.c b/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn_percpu.c
> new file mode 100644

[ ... ]

> +static void settle_flush(void)
> +{

The settle_flush() comment explains the reset with:

> + * ~15% window asymmetry, enough to invert bpf_matched vs bpf_full on
> + * flush-dominated cases (e.g. "hot": few cgroups churned from many CPUs).

This isn't a bug, but the cases in this file are narrow/wide/widest, and
there is no "hot" case here (or in the sibling tests).  The timed reads also
always run with collect_full = 1, so there is no bpf_matched-vs-bpf_full
comparison in this test.  Does this example still describe this file, or was
it carried over from another test?

[ ... ]

> +#define CHURN_GAP_US	(50 * 1000)

The gap comment just above this says:

> + * pays that flush inside its timed region.  This gives all four reads
> + * (file/bpf x matched/full) approximately the same start state and folds the

This isn't a bug, but the sampling loop does one file_pass() and one
bpf_pass() per sample (bpf_pass always sets collect_full = 1), so there are
two reads per sample rather than the "four reads (file/bpf x matched/full)"
described here.  Should this be reworded for this test?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/28695985027
--===============8802271696774654361==--

