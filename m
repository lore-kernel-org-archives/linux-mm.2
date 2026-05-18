Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76289CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDCD6B0005; Mon, 18 May 2026 07:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EEE6B0088; Mon, 18 May 2026 07:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3E16B008C; Mon, 18 May 2026 07:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 798DD6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:16:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CD6412083F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:16:15 +0000 (UTC)
X-FDA: 84780286710.25.43C654B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 87CBA1C0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:16:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lE1hz4+7;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779102973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UDWihxFEvM8w5om1mSDAarMB+mKwfYV2CkimYg1Vy0=;
	b=8bD6hxFn/m8veejsCGXhcZCNSZrOM1moFNme9DADXHrKM4tRmSdCshj0iIo+SnYIwkO63n
	ZTO1mLahAe8kJ4sO1ZUy3TRYpJLkAk+b4hENvMSuxciPdI3eITMojWk7mfjmtba4XhFhjX
	TV4fN0ZKZqKyoby8kl8f2IPqgoLKrJs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lE1hz4+7;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779102973; a=rsa-sha256;
	cv=none;
	b=oWI2Fjh/39Sq7f9pnaOG7xNIRwETkK88hy2dC4korSXfn90G3Xw9eKtNZiq2J8DvLAD2Fx
	MFxsfBsizQKgPIJ5rvqB03d+p/Yv0lrXydpbRvD0FMU75AptydwENGTYz+YqSvf5ZwpRPA
	yrGt25NcLDrYmBCZPHg6aB6N3M/2z5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED12B6001A;
	Mon, 18 May 2026 11:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A48C2BCB7;
	Mon, 18 May 2026 11:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779102972;
	bh=Rsq11OBDmWjRx182/cbkiwGJKi6eYGncgB5TgjY/gwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lE1hz4+7oqBojincmB2fStMEcKBUpuj8ENsXqcz8xlDIc7vaEo1mWYs/ki95PUYxh
	 KIrP9pTthgboqGbWRubTDV6vmiUPTX0GgMXgjn+DJc19KsGeV4HFtWjiFVb+g3F6Km
	 q3T7X5Wudff42EaiaT7+039pZeVYYZ2x2XMAcW8vG1CMWhBpsr4ixXImu9Iev+ZfTt
	 BGifyuogualEE0A3ev/fxY1pNMqXCZhQrcV1edPKq2dYT00l5599EdAWUdcbjW4wct
	 lLtXAuwYlBBKuxrdoVLe/XuzGBpSlpIp5VA1m/3HSF/TYV6PvJfEiK1h8tVCXj1Vc1
	 QqC3/iN37gDLw==
Date: Mon, 18 May 2026 12:16:07 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	hughd@google.com, leitao@debian.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agr0aV3o-5Iqwqn5@lucifer>
References: <agW_BR8qNsxzAKYi@lucifer>
 <20260518020208.55676-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518020208.55676-1-ranxiaokai627@163.com>
X-Stat-Signature: 1knshrxpur38upthjz7zeukmmpaq19z4
X-Rspamd-Queue-Id: 87CBA1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779102973-266960
X-HE-Meta: U2FsdGVkX1+nuzgqHDGvJJA7BFszGnuKovfjodkgaM2ejnkYXfBARiWJuBd2Wpt4yLfWbYi8f8013r90FfvmcJVDtwer6iT/jvuvhyE+SYb3eXWlp382iSxDPOOUq4/XznSolmnXcRrhZxqDNiNc0Sgo+aS07Cy/D0rLtKUY3rXJLVyuPb199Cm3mJAHfhE9OZtTYCi0nl2AWIh2NezpwUEx2Az2ogRuXQsG3+AnzK3m15OXb9ebIgtO1lrJuh1ZKA4+1wV1Z97zJunzanVojmr4I72Vyq2DZdTSm90lKDvWEWBpo2YcsERJ0R2T7uzKUi7/WyiCl6z5bUPlfSleBNXzeZ1ia/Univ+XCgCiINBWQ5Koqn2RFgPxK3GBXjiiOur6cwnVwn6uHAU3t2hrtknGpyaR9mHDuYeUoSigid1pbvRHt1PLa2zEJw0OpY8lEYWJdkH4259AZUSMWtGEcUFyoY04SyqV3DF5pvSqRnjVPAKFXQWRP+XnMADT1wMU+JAN61IiOGMjv7ycGkm9/tsn/OkdE79uksh+M1mz/V3aUiYY8ea/IGh3A6zF8gVy1wn/cO8W8BqA8ZC8gp7lnA9EcaPvr9jqcvORLkW04DkPwM8v/myGVd4ZBCCcvm2NVLFr4Ouk0n/qRm41KfVTPlcSbramulgQxjpFHiBCwvW580AQorWaiMYE4DAllc2GL39UfO6ftyRMe6FHZvM8qFUNjSUmhKg65Vyk5xjsmxSbkyN8EGbBoDIL5rNek9+nUbrTpgk/rSFpy64SB2GLJOdTTzhTZqOtPSoEFyOU52rVU1/opjeSOSLXOqwi8U6ZXlpVzVnMOTowuSBfC8tnfct5C7NcsSgLj84pebqL94J4yfZUrtvgTllhMBVyanKlWgtJqBiHi9xMfUTEedL7598AQVlSDlX+R6Be7jRyRxBD9eRNabbBFv31u1T99HzYE/YWPDtYe1GQidG0e56
 w9eHRKgR
 Rlg3YNHPHO2ffQuW0Nn0uGk6Q/iJvqoQVQbm7cwkfCxLCW7rmEeybLnrk/ALj1bNIq8s7OdTgGu7KXO25KyCPQ5UChcnaAc/IPnMH0RCiacydWAdVxuN7SCjcdHYDZOpLg99pfH5YeWt/nbBx3U/r0bQGSxOx9iFT0ltIKDWQNIlinjEf0Iz65f9IXWI6YL6ytBj5oe7430FVgDuxedhryknZHtj0kZyEvDC8vnIAq6xuv0wLlui0zL61mZWOApLXIXLImzcwuzmTCjNtqOoHQ4F/PaXDDksbJ8HGKAKJ/l4wVBoa5AG8+98gdMyZCIO68zSOOwuCtW3yJvnga2ufwByVNOxU610VeTC1XR3kYZ8EyougJtByEOK27P31TGVJDDgJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 02:02:08AM +0000, ranxiaokai627@163.com wrote:
> >On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
> >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >>
> >> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> >> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> >> thpsize_shmem_enabled_store() using sysfs_match_string().
> >> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> >> calls across all branches, reducing code duplication.
> >
> >>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
> >>  					  struct kobj_attribute *attr, char *buf)
> >>  {
> >> @@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
> >>  					   const char *buf, size_t count)
> >>  {
> >>  	int order = to_thpsize(kobj)->order;
> >> +	int mode, m;
> >
> >I hate single letter variable names (yes I see set_anon_enabled_mode() has it, I
> >should have reviewed against that, oops :).
> >
> >Please give it its type of enum huge_shmem_enalbed_mode.
>
> Hi, Lorenzo,
>
> int main()
> {
>     enum huge_shmem_enabled_mode mode = 0;
>     const char* type_name = _Generic((mode),
>         int: "signed int",
>         unsigned int: "unsigned int",
>         default: "other"
>     );
>     printf("enum huge_shmem_enabled_mode underlying type is: %s\n", type_name);
>     return 0;
> }
>  ./a.out
> enum huge_shmem_enabled_mode underlying type is: unsigned int
>
> This will cause the following check to always evaluate to false and
> does not validate input parameters like echo "xxx" > .../hugepages-xxkB/shmem_enable
> if (mode < 0)
> 	return mode;
>
> So i think we should keep mode as integer.
>
> >> +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
> >> +	if (mode < 0)
> >> +		return -EINVAL;

OK fair enough. The C type system strikes again :)

>

Cheers, Lorenzo

