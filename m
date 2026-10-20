Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6545A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nBgmagcy
Received: by kanga.kvack.org (Postfix)
	id 843786B0405; Tue, 20 Oct 2026 01:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4986B0406; Tue, 20 Oct 2026 01:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A4D6B0407; Tue, 20 Oct 2026 01:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC446B0405
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:22:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB92C14082D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:22:00 +0000 (UTC)
X-FDA: 85341858000.30.CA0E649
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96AFC180006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:21:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nBgmagcy;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792473719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MIsDqFQ3ihoPCDCZv6W7JkqazHoCN4iCAhc1qoiKLY=;
	b=Ep41kkYZLmF2vlzRPpFa86Mnf5K1QYXmmNZLv/VZKMomAlnOFlsBc2+vWvk3jwtOI6epvl
	tSk3QTcvlgwRvUlgxwcJzEkOtG1SYYsGlHaOnx3gMNG/xTYs6ZBbpLo16gdqhuMbRcseIm
	Tni2ctznoQeXxHjzieuRByvvzeS9AZA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nBgmagcy;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792473719;
	b=KgBEw0OMaLgYstDeLlxprHKLZJd8Cpz485e4n3YF63MrLzGOGAp6oshIPeW53XvLbWjegq
	yDi9mjLjeE2mAZl02owzznFcx2OlWFC1o5Gmi2MiCFBVPZmMt0PW76dyqf3Z6/ZSUMJbJF
	E23qPV+aY5HgDLJVHHPYHulWBZLagFg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52A6D1596;
	Mon, 19 Oct 2026 22:21:54 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DAF03F7B4;
	Mon, 19 Oct 2026 22:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792473717; bh=1o8mKDhc+h5Omef+qHo/0xtyFQGZ0v3bKBCuB7AmPEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nBgmagcy6gXNs2r1qVZzAn2A046/Ya8MlDRVZ4VZN5idWhICsLIq++TgG70EeFiNq
	 ORlW0zUDtNd+geIAAi2Tc6ir6HXcZhsoT/NBksqLegc8kN9ihaCN/9C9MVxoDlOUtg
	 hWmz/Zweg7lkaK0sv34MJs5RR55TwGm5mKk0sZn8=
Message-ID: <bd7c7fd5-8543-429c-8618-4fb881723890@arm.com>
Date: Tue, 20 Oct 2026 10:51:48 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/kmsan: skip vunmap_range_noflush when KMSAN is
 disabled
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-3-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261019054531.87652-3-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 96AFC180006
X-Stat-Signature: m78fxrmuqns77r7dtpscyybkuqtq64rh
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792473718-716703
X-HE-Meta: U2FsdGVkX19m/fitwNnCLA6cPAY5Jj1KvUble4droac46tI4BceflMqiHP9tUUMGHK77RJKkfuBHs3XqU2522udwBmQUfuWLKdqNwnbSEOT3Ptp30h7kOd/I/yxRbFe9TWcqXsTm+q+qx4x+4jISWKU9fWaprUrjpPRont+4ZOFqjwS8Y4WL7Vod5wfjoeGnQtZTY5bCxir4H8svH9Wf3Cge43swd08kHup8V6aE8jRzS411mGHiRPfJgelLV8vLgHjfbgyb52usE6GAbDkLAFyPbEXTS6BrIYNmwhXxtB854cs5ftFVBXsP6PzhhpHn5mwcMi1KRh72LxgCjV1Cu2cOq/DYumYGfXks/I0rBqoQvhqU4duo/fC44HdpzfFvhiKpaXD33WvEqqL5GrzOjQWN+glBa4TdYlL44hKBfX/O8qH55fVplzjh3k8rofkVok+8V1n0RAeBpVA584pogSv3BzbhuTvsKAMJBxR6nH96VCYje9D/d7fFkKsz1IRF+DKThzrrrFZYNxqBUz5ALCxSM50MsVX2q5k+wvqbn/vW5r69jStOfCsWsTjlKX6pvPn7j7YyZKt7yJx70MRJpjrLtyqxzxoSniKyy6HWGsVDyNR1eZxzVkfA2TC2bPeuvG/bR29ODYSobUsHv4pbPxrzQTxYsZWTEJihjNBF0h+YyzC/YF7O396A1MDyUx/bfFOFCL42g4TvRZTh+Mq9uuiQLfGDoEBjN8J6EFvU24rJ2pt4lkdXhA2A9l7BbZutxVdC99uMZoN88XoSfDSK1rP0Kjz2Nt+nzDCxVcScdMr0dyvWaA8p+K6SOuXTNXJ6q4768oudK6pVUtuonA9Ubhq5+xSPC4zvCTyncYEC2rFWpujAIouhkecNsC/eiMp9NxKNhTHauO/O2BSX5kHQj4LntP2sBLPJeg9DDq28eMPDVufQtw+gFvA+mSg43k/g2q6zhGYKuHwhtrMB9Wc
 NqW/1d8u
 n+7xln1Ml2lqWDqahLparD15m7G96UNfKhJj3dVPmXVKfdyN5MO5IkCBYkWrwm7tnS+c2fIzbLIaKCuR8RRtD1XTpZJyAeBQwf4Pfi5x90chDN/JJi4Hb4PY9bnY5haPzqUKjgcSWALynFSoVGS1RnxoPPUhZEZP15ssedTBhIVq7H/lUOMGOh14rVyFe9BmSDGiey7PR/PhztDlxR0Nw+vAqHZEfGHNk/G3VKuRGiRIRYIQyUYm6CGMgAcdQzGhinUaXNG1WwApwFN8QVy2BftEDnQERysAhcwfrAlXP+o6KU4dppLIscP+H74SEyCtlNZHqrOu0IuMIp6wvFfXbk+LDTdJi86QG7AWQuexht7e2L/TPf9Z+2gnReUdXO2ddGNsfd9dg8qU4+QgpaSwuVrnzBXfA+fU80C7Bag/NqsM/nB6mlHPQOD/1MXlNMNboRZUd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/10/26 11:15 am, Hao Ge wrote:
> kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
> false.  The unmap side does not, so it still walks the shadow and
> origin page tables even though KMSAN never installed any metadata
> there.
> 
> Add the matching early return.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/kmsan/hooks.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index a706666db097..107f66841274 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long addr)
>  
>  void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
> +	if (!kmsan_enabled)
> +		return;
> +
>  	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>  	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>  	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));


