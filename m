Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D4910ED659
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA206B0098; Fri, 27 Mar 2026 06:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1456B0099; Fri, 27 Mar 2026 06:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDFE6B009B; Fri, 27 Mar 2026 06:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB686B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:58:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3C3C1B9738
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:58:33 +0000 (UTC)
X-FDA: 84591544506.30.79EC0FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0DB35A0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:58:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piymFor6;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774609112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25AaeqQl5ik4DE2qY7hwKe48F3Qntmq7fZjEkTsZCW4=;
	b=rj4JcgFGkZhvDZFg0Pj4qkWWOQweXS4Pn9OVpTtL0rQUV4tWxeTblhWT361OhxCdZNiEQl
	HVPfsioT1LV6C4MIPYN+YvwVOnPzhM0hhPuIPNFkj58G49x4Z81TUrSZvxN18DYdyHRphi
	IA/9UnO9JQ4Dl9DkcbjsLMu230fFPNE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piymFor6;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774609112; a=rsa-sha256;
	cv=none;
	b=6v1FzjAGPm8npfMjmuldJ1TjTdJnsQidGO3nDOYOX/Fs8xEMnV8YCwHZDpgKbjHAzd3Q1f
	7o7ev5WYouNqmr+2HpRUvtjrYxNA+WVw4pguTz0nXeWXEJgQtl8w+f9LbrAn6jfXbJCSjh
	xZrGGiqHq6W7p8ksJK/Ddlbmws/TPIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D715543F2F;
	Fri, 27 Mar 2026 10:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C027AC19423;
	Fri, 27 Mar 2026 10:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774609110;
	bh=s8xXfl1mX3u33WiFFWFbrh4M9MzMd9HN8QFhbwAkBKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=piymFor6hHlsvu9d0DWBf3VCgej6vCBt81opao/rdhdloTXa9bDwIuOUodkNDt+dc
	 i32ykfa+tFgp9CY+M/HWEF6ylntguVHVLSzUoT1r2ca4SYmrOege5IQaWIdfrJW2d7
	 upJXV8yLy0oX71v5FJrqmOMCB6+yx4YSbNk7jKGT8O6Xs7QTMjC6seOMWAozj7rIWR
	 OTAv/kLr5E2p1d6+HEEr6d5oxF70VAW9GjiPSVaP6rjoWo/sToPv+HIuL4Wo3CNBO2
	 5zJOzaqXk3+gvUcy3oPuUsg2PQ2OUukv2zLXyjL2Y0BDnWl9ffKFH7K5iZSRsHnthQ
	 9hNhdyhUNzzfA==
Date: Fri, 27 Mar 2026 10:58:25 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: akpm@linux-foundation.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Audra Mitchell <audra@redhat.com>, linux-kselftest@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <237317fd-d2e6-4e9c-840d-fc60b7d8883f@lucifer.local>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
 <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
 <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DB35A0005
X-Stat-Signature: hnrqzf9hwmot8fkc5o6a8qb4dihbgadx
X-Rspam-User: 
X-HE-Tag: 1774609111-934844
X-HE-Meta: U2FsdGVkX19Qz08i894hTbNuYzIuZK5I9JtaFN1Gm9BtA3e7C3rjsQO+UjJxsOBmbC8imzwaaECasg0iKpvXasfP3bRn3RelRaCv3i3S05bek/1xxjIhF20sC5YjeZ6ua6nKnoxNMOlOgMPvp3oDhHgk056S7qHNX1ScldBcGhJTuwrzeicyTPwWmzc6aLD+qUo0YM369X3oRYAP8ooZrV62P4Ql0XDdOgSqwu9fcFnp49WAYoqfiGeNL8pUWCKUfgSgHoPEhtbRxa+DqFMb6JofFnPTjfhF+9HOHGUuPR2nxwkOnxA8coOzcCj8bnU5IuJlWosy50np0zkUFD8+QrMt7fL79UT6EOGRSzl4jsCCW06ErEFJoh6oJyEVTOsfUQWPr6Osm9svRTDslNGNB9LLcZRcz/QF6Rtswd+EuWP6A9Gfh7Fyr70goLm5PCtwB7/xvSuwxybhDMnc6h2wzmfuoa+UTXswU2NKFsFB73YqTlLtMAOR1Pl+xrcnqN/xOF+r/8i37zpAM6UOxT5wFHefUO53dT7/esHoZ597mJMKyNZJEFmaIqnhks2/Uca6vg34yjoxkPncPFEE5lW0uFBdhWAJqiJTPTgQKc/nuSvt3+4mOwq7ZvkXIGsKuOQHo/cBWCOX1dthWAP+oE4wmqhhAUi7yAxQzUhJQVyz/vposMUvUvfuodu748zFpYNtLDQU1IFvT81KcvYknfzV4aGcyLpK6vQWooLP7Zs62+1CnlOBYE1oKqcLjgmNaHQwClvxljIfBVLaKgyGxc2TFWz9piQ+BGBhaG3JXybbtBjtj82rKKAmHyq48teVi6Xg48MNIcbj+11rnanYrkCq3l1kvDYrFmYr61lSbKAKbdkFP1ro/Or5XsuRV7XUpvDvGg92i7aeeFVjN2nu9yfklQpLcPGIgs9DZEbpao1HJCEbKPVT8DjAHXI+u62Kh/WNZvdIyLZNznEneNUXaA4
 b6oIjh2n
 JdXNrouSf6qYvNcxwW1tkpumF/ElYmiM1eZ+mI6d5n+z109EhGrRsBMvKsMy5kSXoeUWUYif77iyNvQnaBhfdHEiMGiaXxao4VSLR90pCwx2C8eEPSnMbgTqi7UZ3vCwxtJuUCTzmxLtw7X4Dt069toSrRCJNsOau5VkfoCqoyoTbefSDjXfAr7goI9a4FN/WJ3SSIDIGUypgxgykrObqUbyd0fqM7DQ++NGLnhnKqOB5aKaWVTJ3cxyI4lPrl6e/RgnupPQA730n60vIgzV0IehQj4br6Puwo3Hcut7hW6dckNJmtzgQgqkYD8ryCjEXdreVib9OyrZywAZ61QkUSnVgUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:52:24AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Audra - to be clear this is discussion about mm process not your patch
> specifically.
>
> OK again I'm starting to think we just shouldn't support fix-patches at all any
> more.
>
> This is an example  of a change being done in a fix-patch that's _really_
> causing issues.
>
> Because this has now caused mayhem in mm-unstable and the 'kinda stable-ish'
> branch now won't compile any self tests.
>
> The fix in [0] on Chris Down's test series was for too many args to this
> function (the patch changing this should have been rebased on mm-unstable and
> changed Chris's caller there).
>
> But now since this patch above ^ got yanked, that 'fix' has stayed in place and
> now no mm self tests compile.
>
> And now we see [1], hilariously.
>
> [0]:https://lore.kernel.org/linux-mm/20260320195751.5b08b3e32ca835c3451d7bcd@linux-foundation.org/
> [1]:https://lore.kernel.org/linux-mm/202603271115.uE9vpppi-lkp@intel.com/
>
> This kind of massive levels of confusion and 'I am just trying to run some self
> tests on what-should-be-for-next' is just not helpful...
>
> I think we need a for-next branch that actually consists of stuff we genuinely
> mean to take (i.e. review has settled) instead of 'literally everything because
> we move stuff from mm-new unconditionally'.
>
> Anyway we should revert the fix in [0] because it's broken now.
>
> Cheers, Lorenzo

BTW, even _at_ the fix-patch commit hash (28edd9c5a25c) the test builds fail.

So I wonder if it might be good to at least do build checks of the kernel and
also tests (tools/testing/selftests/mm and tools/testing/vma) before applying a
patch?

As that would have caught this right away. Breaking the build should be
considered a no-no.

Cheers, Lorenzo

