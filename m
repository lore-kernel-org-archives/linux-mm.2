Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72CC0606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNt9MexY
Received: by kanga.kvack.org (Postfix)
	id 909836B0154; Tue, 20 Oct 2026 06:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB396B0157; Tue, 20 Oct 2026 06:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9186B0158; Tue, 20 Oct 2026 06:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54CCD6B0154
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:57:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD5341A0119
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:57:52 +0000 (UTC)
X-FDA: 85342704384.08.460AA41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 255A180006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:57:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNt9MexY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792493871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLh3GTHbeQEaUVrh6opDuRvseOhCfKAJJU5WzZ/c3QE=;
	b=nmR6j6B7+wurfvHseEcQimfsgWBDi3z+Pq706Q5Sii8Xfe7tcRulpO3f1zw4e1+UIarNGf
	x/wASPykHFYeALsZBhGkB8MZ3DYRBL/hTDCz9j8GqHe2+mj7dav4hbXpq9pAy4JouN7frf
	TT9drqcJisHWapIX5P4GZl3G7sEkGho=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNt9MexY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792493871;
	b=RXCEqoBVs84Kwb6uBCH4BCtXqmGc3Ols5XjXn0n+niMT2cJdyX5cCKs0atIgoqrWgjGxz8
	q5jb8wXUCQnRa4S0BD+s9Lj/L33YPWMV4apfcaOq+XRkg+2eLkaOzusebHwDmk14ngoNJI
	HLsCnGF59J1JWB+Ppht3tAomKqLuz8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 919EF60220;
	Tue, 20 Oct 2026 10:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B4D1F000C4;
	Tue, 20 Oct 2026 10:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792493870;
	bh=xLh3GTHbeQEaUVrh6opDuRvseOhCfKAJJU5WzZ/c3QE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oNt9MexYHHjAFDpAtUK7Wg/Nr8gWi0LjtrU2RPEIVE6L3R/HVhBwT6fwIdWL7OPBU
	 DBCp5AI0OuSXjyeTyVh7g2U2/uoyquZDzzYRi3bm8hpFcuZfaO7JxJFCOi3wvKdBGy
	 l4kPE8ea1YuseBmAIEBLnyHOW+yqOzziNIT9Gx76yFYyrZqiFc28fubj2jdROq7cOu
	 WYEYOjk434Y/yaSp2VDsPunN9I2cljeJm1vKoeaheAdZWzKKVc6U7jf7bNUw21ZGiS
	 vmk5ZdgBhCmk7dv/i7sDGGMvhAzKERfJcpOr50xhm3aW33j/DmZPKO3Ruu2Md2egqA
	 kqtQyXrExTjcQ==
Message-ID: <ce848b62-02f0-4b34-95e6-d30416e20336@kernel.org>
Date: Tue, 20 Oct 2026 12:57:46 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: retry private VMA locking when unmapping folios
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261015170551.2656546-1-4ncienth@gmail.com>
 <23623534-a163-4ffa-8538-b5aff7daecaf@kernel.org>
 <20261020102012.1775940-1-4ncienth@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261020102012.1775940-1-4ncienth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 255A180006
X-Stat-Signature: w7kx85bjkuszcyupaxpb3u954eqxt8sw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792493870-953619
X-HE-Meta: U2FsdGVkX1+jdVvIPsW3NztWTb9XxmtVkWGtYrPCCgW9HPMi/hiH850eDgP6SnbLhBAkFkGICmv+8tRKsbu0ELWxix5r6Dp2OAk92sDQl1NfoRnqMc9XVMHxHzLXFpWBeEwRjTDEBHa6KVzz88Zk007gqzcf1Q+kMX3OEDp0w+t/sStPp969JnpCrzfKDBfdT41K5p67IE0+G1mNLs2+pf5/ChyqL9SQQHsRIeixRkpmNaNmx/t/+rAdELQ/g5jE2h/gU7UAqAGISoeMgsvh3OGrZz4tz1Y/r9g0EeJ8sRyGkmIrdm2Fo5gWlqViqF3YjJWbzY2U/RfySOLMKhMU3Omx54uOID7lKhqgFet8tJQ7uHzSKdJQrqdRqJ1a+Gsx2oP5v/59Z51Cg3mEf08+aPKvaBoAQyoGmSP0C7sbRjNUwoTzTISAV47sqD729Jg7yKtnA/AgmHiRGMlu0c+xVmY1UyYDRqZ2b1ZL+NLu/qmQvePWx2jaz3eQyk8aR7PxvYnb9+AM948HOf1CyTjz1C+g7XBI9z0mGpF6HT7JqICdeo60tuJyHi5CdKITPZbZEAqogIyFph3wdokC+Khry2bIkMGunlXqpu/XOPeeXJQsOcqAp967iTqn5ulYBwycwjA/y8an0QIgzYWJ2o4/3Vm5SIaqtJv5sOOfrnHnMz8aNx0Q+nVXt/vjTXiqKRarIav3fyyQfsSp8dduqthvPRysW3JwfYyn+sJVnm3rORBG6S7OjaYr2e18rgoD7gei6d6gfeG9zhzW6C5kz9zxedXQmngGIdf6tuMfFOGMjEfI6taMBBSRE7OaJ1tDK8mYAaGMydivNyGSUaRMFTZpsLF4AG/2ogol5ffPgQwBmfGR048NYnb7T9gPWPX9draiTRdIzQSqFLVUYa/Qk21rw+To0eFdYHdpEoPitxniGnkxZ4+G7LDKJ8CJpoFM98EP5+129uicdc0xEHbsb0Y
 d7zc1cEL
 PvlvmXTh5MHqTPJDjQrGI21T+TmsZG2qJDSbcuKm8tGqdlbSvc1RCBYnKrg/e9XPVjUZz+U9qH2JCTNkwCQGxnRlZc7xe0aIF/+ByZx0SXuRiuVNbgFYQqLjqrG4hHcE7LqNgFpqO0qRiR1u7FZMY2nuIWF+Sb+wVmzuiTVT2kl3Nf+v16RM5yiZr6wG5p4IPmNO+LttTToEF6eL+ucW+uRNmzJkAYoXgBEzH6TsiAyhuWBDvwEJ3CguFJwl1ucxC0MkvDHuFs7lo3B3VJEL//4XMhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 12:20, Daehyeon Ko wrote:
> Hi David,
> 
> Yes, that makes sense.
> 
> The per-index fault mutex excludes concurrent faults for the folio being
> removed, while i_mmap_rwsem keeps the VMA in the mapping tree and excludes
> concurrent page-table teardown.  So the private resv_map lock is not needed
> in this path.
> 
> I tested the exact diff from your message on v7.3-rc5 with KASAN+LOCKDEP.
> My unprivileged mprotect()/hole-punch reproducer completed 1,000 rounds
> (64,000 hole punches) with no KASAN, lockdep, unexpected warning, oops, or
> panic.
> 
> Please consider my patch superseded by Josef's fix.
> 
> One small typo in the quoted comment: "i_mmap_rwsem everybody" appears to
> be missing "excludes".
> 
> The quoted commit also predates the current linux-next policy change:
> `Assisted-by` is no longer a recognized trailer.  `generated-content.rst`
> asks that tool-assisted discovery be stated in the changelog prose instead.
> 
> Tested-by: Daehyeon Ko <4ncienth@gmail.com>

Can you overhaul (shorten etc) the patch description and send it out for proper
review?

-- 
Cheers,

David

