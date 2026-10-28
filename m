Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6421606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngYis3e2
Received: by kanga.kvack.org (Postfix)
	id B52D56B05B0; Wed, 28 Oct 2026 01:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04286B05B1; Wed, 28 Oct 2026 01:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19B56B05B2; Wed, 28 Oct 2026 01:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88C006B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:24:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2921F408A4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:24:35 +0000 (UTC)
X-FDA: 85370894910.21.E83BD59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8F00080005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:24:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngYis3e2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793165073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJZAZ0A86kifY1NPYX8XYC0xWNprTevsjHMyzxjeHnM=;
	b=HiTEcACU+CfKWoTyEfyb7aJdfqhxH/UyePbeGbmu/Oiwef4uMLncCfNCjEL9oqolf3bdXM
	v/MEEe3IpNd2dfGmaCWLyZr5mbiJmV6Z1p0b8oQvq1bWk2+rRob9CFoB3QrrSX0HI30XMr
	V1SFkupjv+7KFNISo3yBgfv0GspkfIY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngYis3e2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793165073;
	b=MLqljtXYkH4/v6kFQlHzsv+L2NA7+w1PpccFyqbfyqRpmRQsFhXA6iKcst2s99uEW3Pk30
	vk9SnE9tHuRrRHkYMKN3XaJv3hr586zn2hsE2MH4BkLSAssVraixNc6jucToyeBlwwQLup
	yeOl3F10qqWcqQc7wuIIrrDuYHpsj2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0AC43303;
	Wed, 28 Oct 2026 05:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4059F1F01825;
	Wed, 28 Oct 2026 05:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793165072;
	bh=oJZAZ0A86kifY1NPYX8XYC0xWNprTevsjHMyzxjeHnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngYis3e2wvUOSJvp8+0jEGKSRDYMAK9HDAntN9cymSinu549gET696m3116YIejwJ
	 5XIWt/Mp+Inwhh34rmXQnFzlmSbXuxweOA+gSdcBQjRlwCxPXq6FAheBvqJqQdZzNA
	 E4wKqnPVfaQAlZ4Q9i9McBUaVFtLkG+c7NtlMpsqccENGbmjhCiPc3cv70cYXmodue
	 eiab7TSuTB75C1kUmYTF2sV0N6KN9Ul50EVqFwxf4RSWnUpOYVgSmnti6Ms1sTCTGr
	 di74MpOpebIVO3Xyh3IelZ0EUD/1U+rRwUvsu+S/FEDd8MSxu6L20KJk588yv9LuGR
	 pMMcssqoPeMDg==
From: SJ Park <sj@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
Date: Tue, 27 Oct 2026 22:24:24 -0700
Message-ID: <20261028052425.154616-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028023628.795637-1-ruanjinjie@huawei.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F00080005
X-Stat-Signature: 7hxyi53rd31d1wmbwrtug7wfysenqiuk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793165073-373363
X-HE-Meta: U2FsdGVkX1+ZpFk+jQ/a60DGYRDVNKqQLF4jlo6/l0VjKWnq0RfV495Fgp9Ewomxvpiawl4N+bfi+oznR1ugtsbFQbil6u6WqGHvbSgjnTUdwOtn8D0EYXB6L1xeesgCb6JO6Ez5vrtI/hvqx76qR2FNT0OEXsWLrbLTDb5s8J10dB6rDyzQC71iycQF+fPa1lxQ4kpar9GZCBllAUY+4f0aqGJtbh2z1pX0tjoM3qKHJgZllp2XaSG7PRFxxnEsyoaftTgnsoMqwTtfu0RYo9KvWNJDyNgI2dPjjOZ3rAb/Rgkuw0oE250QeVx0NvUQFPGPFDQC5jCEtkYTANFsTxjFKa3nbEk5BiXd7UZFEATbKWXQEXIiDOT4kljwh26s5FAhYqvpuidnFce6vz5iOM51ILRWZmbW22qcDhGKSlyDe0ILuhda+qyjSZVkMBaFqvRox2foWwgCo+DzU5bDB0z3rih6d+Eqq9WociywurNx040m7d6znbSEBb5ezuzGUTSl4q7a9J36zShfyb3rng8pITH118WSyzhPVN8L8Em/CVa+oIF+sJJACmfv7Go3hAnT0jdQyyKpiL4/Px10BHPHHjiz7ii2CG3JJXZjGT4J0Vt5fWZjqsDaRKchVhM2T895H50GR/uZy8kxw9KX239f1N7CmLJu+ehQ4rg8ve2eTuKYSyH5OQCSy2H3E1q00uIxLnuedy7gvEiKCVPWZeqbRG5NqF7ATCOqBPx5UUFTKXJUgBGq7n6Fqi9ELpOstZ4L2ocdf3lJB/c1Xl/sY9/cP5ukhl6+jUp1UQP5eAHo9I5yxvZIHYlqKvH8UTI9x+23qjA7CZGCEHSAfuKWiwcr4scoxDrlutYFRZmzXkJkIqJgfT2H8xq+e+IqIAGkt581fZwrTKQqfU56Ef/jd90MiFxeE3CQRps+Z7eFvnvPb8o8vuu650+92N/M04cZg7/ut+bCSSXKkFyCEYp
 og4M+1kG
 hrYyv3DKk/TjRa1fJPuFrrYyFJz/fyl0cnbS1gy4pamJcBPdWA8cF38KJHRxu1iPAMrWhA5mLFi4s5rNe7c4jQ1mONzLSzQeMo1iwlVDWGs3mFXVbIvWNMDo4TnfVxPWwClpriOzuLzqzNX7cvLhNCO8m7UzpZbaSxGRUzg2kX7E3pShYlP9oCQ0jINSIuW9UnFu89desb6ZwXMcX1Cy9tJKamk9FyttbTeHNhoCjqhW+LLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Jinjie,

On Wed, 28 Oct 2026 10:36:28 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> DAMON_RECLAIM runs its scheme only while the free memory rate is
> between `wmarks_low` and `wmarks_mid`.
> 
> But some users want to reclaim cold pages even while the system has
> plenty of free memory, and it is not obvious that the existing
> watermarks parameters can already do that. So Document the setup.

Thank you for this patch!

> 
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  Documentation/admin-guide/mm/damon/reclaim.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> index ec7e3e32b4ac..23fede7d1cdb 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -193,6 +193,13 @@ DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
>  watermarks.  In the case, the system falls back to the LRU-list based page
>  granularity reclamation logic.
>  
> +To keep DAMON_RECLAIM always active regardless of the free memory rate, set
> +``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
> +``0``, respectively.  Then the reclamation is limited only by ``min_age`` and
> +the quotas.  This is useful for reclaiming cold pages even while the system
> +has plenty of free memory, e.g., right after an idle virtual machine is
> +paused.
> +

I feel like above might be too detailed.  Particularly, the second sentence
looks too detailed.  In a sense, it is not technically correct because of
'skip_anon' parameter.  We might later need to add more such controls, and I
concern if this kind of detailed documentation will limit such extensions.

What about keeping only the first sentence and dropping later two sentences?


Thanks,
SJ

[...]

