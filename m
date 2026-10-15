Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB49CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98EE6B0088; Thu, 15 Oct 2026 02:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49626B008A; Thu, 15 Oct 2026 02:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37F06B008C; Thu, 15 Oct 2026 02:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A73996B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:14:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E5041A0915
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:14:40 +0000 (UTC)
X-FDA: 85323846720.20.3FB9C85
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E50540008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:14:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FvNgevAo;
	spf=pass (imf17.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792044878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qv24sae+053Ylb9mtZOUO/0rpjI5ufdzb/PYYHOrXrk=;
	b=tvLOwWNAlXKV5vFOJSnEQuoiOO1FSFJ90W/pk+StSfPegRmX1/I16V/oXoAvWegyda41Xx
	/1NWN6YfB1Fz052n6lyvxauEYrIbMvjh51O9RBwtfvIeHq09AwkCejAZ2F8sYOb3lPwOju
	0JV7Rpc+DstSJkGhI3G/GUDKmBbVJUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792044878;
	b=yY9AUVesEl1BIFCzxt9bYS3O/UwRHChxnWwew5lIYjyFAC31sEc11X44ydr99vC+u21DW4
	4t05OJu22NFQH/glw331od+/06nrx8qj2ityxSZ7bTiMM9qieKi3MnZQpAc4YOSBOkEcVN
	Kosqrs6mhPbEs140YvIE2XW+iIRtzBA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FvNgevAo;
	spf=pass (imf17.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBB0F1516;
	Wed, 14 Oct 2026 23:14:31 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C38BB3F871;
	Wed, 14 Oct 2026 23:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792044875; bh=ZjHmUvD814tjkhysjYalQNoKk/0MhRSls02vcp1OVtw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FvNgevAoTv232YZhVkEm7d++ZVEKA0pJhUSWt3GosYUbkm5hDIEIx75W5Y33f7zs7
	 3ACuYSJGmk4lkTHG2VDI1rwU/6nPZByOqb8lICdTFpcigp3s+5oWcWe/dzvpsQIf+m
	 vTyW5mgvnVnn0rY2YOjrQFigPYkrjRFPF6rZ7Vio=
Message-ID: <3d43e4bd-7065-4ae1-bbc9-b034a9de531f@arm.com>
Date: Thu, 15 Oct 2026 11:44:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: mremap_test: Validate the preamble region
 before mapping it
To: =?UTF-8?B?UmljYXJkbyBCLiBNYXJsacOocmUgKFNVU0Up?= <ricardo@marliere.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261014-selftests-mm-mremap_preamble-v1-1-2e97f501cb56@marliere.net>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261014-selftests-mm-mremap_preamble-v1-1-2e97f501cb56@marliere.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E50540008
X-Stat-Signature: 1iq3f3q76y4tgmfwcdkn9i46kho7jaer
X-HE-Tag: 1792044876-638800
X-HE-Meta: U2FsdGVkX19jtwhsVRA5fmna5P+PIBWAOMg0sSHVRbdt4BbUwv9aTaS9nWD24QseegwGVfzmPfZs2xmDjHP3tuYCIlaoOTJw+tYxZ+Z2cYc3Qr+OMflKM+IY0mEJ26iNfGYmiFkZxx0EP3jFf2dyZNrz08mmyi7Zi9GIQwyrKuplk6lrGxR0UQ59WyUnQGeY6ycbxsiVqeVGdtl8zljjfjS3ksNc9GLWSGtBGmAJUPtSE1NtCxJnbs8C4OgQHWkinZYtdIGS2U+zYO550ARgGsutJ2RJYzQ2VwIsYFKy6hJS1jHJF2WQ6PtEIgWSmtauTTQLw2GJV2hJBarmilJ8mcS39PsoRrPZYKhVPv7EAj2xs55eNdAfC9l+tSAyRNVdVPF9LIqda7VWJxAlbHXQ7fEPWR+B33Xn4sI6hivC7Vmq7cL4m4tDZu0859HTl5jG1G8Tafudk1o+knLEBLL1exwgznL9TTFBks1yc9sYJNBa3G0hXrs2DiUKw0DuRsmIMOKOZUPD+2j8Semh8BnCW6gLc8/KRU+RNekGs4qB3ivWX19JRtIY3JsKTBFW30Gdk6CnqbgA9mWn6nQHTuge/5XIz5TLYyMJyJeLAFzzsEYNkNXT3A/Zvh9T41dGDlDPdqqm9TPKvo5qGhF73A91eZk2/M0XEn+8ajlzBqP0APbwwFKOSIXeZsJjA7T5XWSw7oE1GvaVGkOpo9gyPumbiR50EAH/WTFV2AcUxfYpgJGZHus6vJ6t5/4mUJxr1GEYzU+V2u+RQMxeC6Wh3MPPhc6adrw7NrNss4eLZSDsFjLpKBW8+1iGsMB16wihje48ELHvqw5K1fQMygjsHPsFGwj0e58veeRnxgxCZrIEoj/7+6XFeowkW0tX1G/QJCpZYVO1MNyVV74ogIsevUdyhwSyQpKhWwugu3AJfYEqXpwpHRwPnTPdxT37UZGLKmK4CIE4A6kwWv1yXiwQH5V
 pR76Bqq3
 qL7ki0diZk+YxJLE9sbGzlnZFJnhBk7MbJmQ0SdTTproboucq7UI9QekpIcf2D3hpVTwNRzdfzX+Lbv7uKAEKYN9s7BzbfelmxDyRavHVMhUmH82kyB2tKDt4Sz1CNW4IXJ4LE+mKQ8Ow38A/Ms6Ol8/CKhaks3LpPgV36LOzN6GpaD3pf8opxGRQqXnSBRriAQZVGBCdqxtQNlBOH90WClmOEevZPx9TcgVNi/ggqOyDOWkZrt96v35yO9Gjs1BZfUsJ0b71ze+v/myzlmY+F/jeIrfOPaHCoja82Vs+zCLxA0mZF2e6L0e8USoB4u40IzFqvt1hgi2seO0jB6N6Af2T17pBCPH7QbI9P6r+C8Gk8BuYj/y9zYXnxfKpKhsZ/+sTWeG/cGFosySgVxhim43pglwxTXbV1Yjdi86qDLeX2pr5kzYA24AqQcPXdIcAhXWHHUFDarZZbzoZd2rODp3qo4rudRqf4+Sh3bIhkdhyCnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/15/26 12:16 AM, Ricardo B. Marlière (SUSE) wrote:
> remap_region() checks that the destination region is free before mapping
> it, but not the preamble region placed right before it, so mapping the
> preamble can intermittently fail with EEXIST:
> 
>   # Failed to map dest preamble region: File exists
>   not ok 15 5MB mremap - Source 1MB-aligned, Dest 1MB-aligned with 40MB Preamble
> 
> This happens when the kernel's heap ASLR (arch_randomize_brk()) lands the
> process heap inside that unchecked range. Confirmed by correlating
> brk(NULL) at startup with pass/fail across 60 runs: every failure had brk
> land inside that range.
> 
> Fix it by including the preamble in the free-region check.
> 
> Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
> ---

Just wondering, should this have a Fixes: tag as well?

Other than that, LGTM.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> Hi, this sporadic issue has been found in openSUSE CI:
> 
> https://openqa.opensuse.org/tests/6270334/logfile?filename=serial_terminal.txt#line-6760
> ---
>  tools/testing/selftests/mm/mremap_test.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 131d9d6db867..8d4fa3025a9d 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -1006,8 +1006,10 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
>  	if (!((unsigned long long) addr & c.dest_alignment))
>  		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
>  
> -	/* Don't destroy existing mappings unless expected to overlap */
> -	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
> +	/* Don't destroy existing mappings unless expected to overlap. */
> +	while (!is_remap_region_valid(addr - c.dest_preamble_size,
> +				      c.dest_preamble_size + c.region_size) &&
> +	       !c.overlapping) {
>  		/* Check for unsigned overflow */
>  		tmp_addr = addr + c.dest_alignment;
>  		if (tmp_addr < addr) {
> 
> ---
> base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
> change-id: 20261014-selftests-mm-mremap_preamble-5f98ad625f93
> 
> Best regards,
> --  
> Ricardo B. Marlière (SUSE) <ricardo@marliere.net>


