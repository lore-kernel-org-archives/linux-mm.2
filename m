Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81995CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99266B0098; Fri, 22 May 2026 06:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71646B0099; Fri, 22 May 2026 06:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE476B009B; Fri, 22 May 2026 06:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA33D6B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:55:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C714120959
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:55:30 +0000 (UTC)
X-FDA: 84794749620.26.5F87994
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5B2F180002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:55:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUoZFdLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7rPRt5+x/pWO5G8x4yKT/FOIc1xp6ZgAsaxw5VSqf4=;
	b=TfQlhXK4UFrRooN48hMmvpFbJznkLMNAGjsOXXCdCfp73xWMj4aSMg1/d0WWIfk48X4Rhm
	wYP6FaptW1ejElgZSkXff+FkoZNZd6UXWmpGwoQ2GL5n+nE9TnTKr1vwbwXGIkqhNh74CR
	eWlKja35FRiWBupTOfidfO8nE9MtDqc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUoZFdLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447328; a=rsa-sha256;
	cv=none;
	b=4p7P19w8ujp2CZdHFNWkQZLCdy7iqf4dlbZlVmVgoNf4e4JZNwd+ZnUEhtThFdV/FK8cMp
	5dAIE8/Fd6Em0WnUXQ7gcfH7fg1/JXBgpsJu5PD5FwhMXboZlus4XPKGj5RJZ9pY2b1ZsW
	lh19L55//BclWU/8YbMrUtAbJggAEAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B035435D8;
	Fri, 22 May 2026 10:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7C41F000E9;
	Fri, 22 May 2026 10:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779447327;
	bh=D7rPRt5+x/pWO5G8x4yKT/FOIc1xp6ZgAsaxw5VSqf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KUoZFdLUDU9dQJPqSCO9C6gQSCR0wmQOHEkAhk6GV7lACRVbL8jphh1UpZBGmK7ek
	 x8+5sfXZat9PV90ys5OITbORfkRnxIapxJ3lUl0oiswBsZ048Cc7D3lHrworRgt01j
	 xoqdHBFCL17jXe/hrJczO2D4BZQOFhVBoNVLxtZS09ragaEeTvA7eMycy6vhck17RY
	 92BrXnNumkyhr8iHgiuwuNjtzVBjr79+NfmrtZJ1+MWfF5DDO9mRMngQio2UHQDfFZ
	 c5Kh7adfGIhL+2cykEmCtqhOLCn1hLDPKntm6a6dVbOGMIRN1+xCah9HoAgS8boRtS
	 3jEbf4Rke2fTA==
Date: Fri, 22 May 2026 11:55:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
Message-ID: <ahA1-QcSK3_hoC5Z@lucifer>
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-2-ranxiaokai627@163.com>
 <ahAxasYwrGvwQLKs@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahAxasYwrGvwQLKs@lucifer>
X-Stat-Signature: 5r71hzfjauqir5g3fjsojkiowzdai9ze
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5B2F180002
X-Rspam-User: 
X-HE-Tag: 1779447328-321347
X-HE-Meta: U2FsdGVkX18TZejTYak80fTMFNA/Q0GXQQQd67DxchIp/Iz0kMCrY6cnn3bIvKy9OVPQUHTVQrrjbhXYazHqP3GmjlgqAQIDveCcqgakLmhtNMN0/NXOK1qxA56DcKifiBK9LhSsMYAJPwkLQuIYobyAFPCyGD8xuUtiIpSGFlDKxIkk62K/4lUSL5/Ms3YQrj2rIL/PPweOZbnV7Ky0mhjsX94yOtZ4XUNbK/MaFRb288FkAoTaZR2fPNor5RRU5uKPzfTGH5+TeUv7nBLNhwiiizDy+dTilWKPRQiwJNz7hGZaaQvG8550sxRcawGxKDNAfBOeSTB98znW+wym1idU7otd8GGhwE5zb8kI1+4OQIcllsE3IbtkRWmeEZVOl0M1IslLIN9mx+1t/0C+0foTkh5LiEiaYRMg99cuTi8WGri+FdNK+If/4QT+61NJDuDjpd2so4sEw4uh41659wGDJlBUaXh9IPOX/QYDwvB6b2ZjPpdq0K8nLnpUVTe4MWkCZ3DKIQUDWTvpwAE2YfZ85mi7q80dw2p3nlLOjIml2jHRLVXdzP3MFZ2shkaZuVe6oLy/kstllbYSzqDDBwKxFWQrvwGgJL398Hz64u1sKAWHoCy1uI8dy0O6jO0bfmeQKb0kryc1FqhbIAe5Shkyyl0Q57v9SMYE3dl0GGNFBsqAhod8b4kEYjtRPYeTyfL+nwMTqxgHB1M0dEbHmftLjmoRFM0/OKHdZnBASVihj/ZbYHB6xA1riR7pUM66PdwbSjdpGUneS7ps+bDkVLoI8yA/+pwd7ovmx1XE/U064WiQcud2JbZNZ1vBGGAMIC4+bvZYmV+VyvnALbkjgKr9eFUUPtlg9+YdB7fVfa9SuR3h4FGnxvU9xL26g9Dp1BQ5e5yL9DzCyVuZSGp+xxKAkiOQWxm7msInYzY19FyxwMFweylHU5gXFVBcZdcq0RIeoYSuICRZMXPImWs
 KxQHFKvz
 FbuQkpvJ2h1MiKjQoj5KFUbfoMsLxxhLCV/m9xsFxMWRpnFhQf8DGJQOA7heJzPeHJ/tySVA9UrxXqQCj48Px/vSLKsy4cAlmPi8bJD7rWHZm364oU7lBIUUAjphgEpdclpxA8OfO1/Scw1m3cHVh9ELu8hq408P7OQXfO0PzyiBSrRZEk6SjbcQ10Q4ddyoSG3uyItHYusRWKrwuq7olD3VKv8rSsBHq2a1xv3OsdlynpyEoNST91fXoWGltNI1E5lmtp8zExWzyufIb2GPns1N46qppJGqwheV0iYiQ4EX7ty6VOXYB9UpcYGgyNT47rkJJIPj9uJ5nOf5W7kllT7yChR04c4PULW4N95aQqqxwfveLrQapjPnip8+0sjMphrkx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 11:39:45AM +0100, Lorenzo Stoakes wrote:
> On Mon, May 18, 2026 at 12:32:37PM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> > anon_enabled_store() with set_anon_enabled_mode()"), refactor
> > thpsize_shmem_enabled_store() using sysfs_match_string().
> > This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> > calls across all branches, reducing code duplication.
> >
> > Behavioral change:
> > Call start_stop_khugepaged() only when the mode actually changes.
> > If unchanged, call set_recommended_min_free_kbytes() to preserve
> > legacy watermark behavior. This avoids unnecessary khugepaged restarts.
> >
> > Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> > all test cases passed.
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Your From: and Signed-off-by: differs. As per my mail to the 2/2 this violates
> kernel process rules. Please either update the signed-off-by to your @163.com
> address or resend from your zte.com.cn address.

Apologies, again I (somehow) missed the in-body From: :P

You're good, ignore this. But do please look at the suggest below re: naming!
Thanks :)

>
> Logic generally looks good, but you need to fix your From/Signed-off-by and the
> rename suggested below would be good.
>
> Thanks, Lorenzo
>
> > ---
> >  mm/shmem.c | 107 ++++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 60 insertions(+), 47 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 3b5dc21b323c..46d2cfc30823 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
> >  struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
> >  static DEFINE_SPINLOCK(huge_shmem_orders_lock);
> >
> > +enum huge_shmem_enabled_mode {
> > +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
> > +	HUGE_SHMEM_ENABLED_INHERIT,
> > +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
> > +	HUGE_SHMEM_ENABLED_ADVISE,
> > +	HUGE_SHMEM_ENABLED_NEVER,
> > +};
> > +
> > +static const char * const huge_shmem_enabled_mode_strings[] = {
> > +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
> > +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
> > +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
> > +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
> > +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
> > +};
> > +
> > +static unsigned long * const huge_shmem_orders_by_mode[] = {
> > +	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
> > +	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
> > +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
> > +	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
> > +};
>
> As Baolin suggested, we can probably rename these for bervity.
>
> We know it's shmem, as it's in shmem.c :) so drop that.
>
> huge_mode, huge_mode_strings, huge_mode_orders seems good to me?
>
> > +
> >  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
> >  					  struct kobj_attribute *attr, char *buf)
> >  {
> > @@ -5546,63 +5569,53 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
> >  	return sysfs_emit(buf, "%s\n", output);
> >  }
> >
> > +static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
> > +{
> > +	bool changed = false;
> > +	enum huge_shmem_enabled_mode idx;
> > +
> > +	spin_lock(&huge_shmem_orders_lock);
> > +	for (idx = 0; idx < ARRAY_SIZE(huge_shmem_orders_by_mode); idx++) {
> > +		if (idx == mode)
> > +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[idx]);
> > +		else
> > +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[idx]);
> > +	}
> > +	spin_unlock(&huge_shmem_orders_lock);
> > +
> > +	return changed;
> > +}
> > +
>
> Thanks for separating this out! :)
>
> >  static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
> >  					   struct kobj_attribute *attr,
> >  					   const char *buf, size_t count)
> >  {
> >  	int order = to_thpsize(kobj)->order;
> > -	ssize_t ret = count;
> > -
> > -	if (sysfs_streq(buf, "always")) {
> > -		spin_lock(&huge_shmem_orders_lock);
> > -		clear_bit(order, &huge_shmem_orders_inherit);
> > -		clear_bit(order, &huge_shmem_orders_madvise);
> > -		clear_bit(order, &huge_shmem_orders_within_size);
> > -		set_bit(order, &huge_shmem_orders_always);
> > -		spin_unlock(&huge_shmem_orders_lock);
> > -	} else if (sysfs_streq(buf, "inherit")) {
> > -		/* Do not override huge allocation policy with non-PMD sized mTHP */
> > -		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> > -			return -EINVAL;
> > +	int mode;
> >
> > -		spin_lock(&huge_shmem_orders_lock);
> > -		clear_bit(order, &huge_shmem_orders_always);
> > -		clear_bit(order, &huge_shmem_orders_madvise);
> > -		clear_bit(order, &huge_shmem_orders_within_size);
> > -		set_bit(order, &huge_shmem_orders_inherit);
> > -		spin_unlock(&huge_shmem_orders_lock);
> > -	} else if (sysfs_streq(buf, "within_size")) {
> > -		spin_lock(&huge_shmem_orders_lock);
> > -		clear_bit(order, &huge_shmem_orders_always);
> > -		clear_bit(order, &huge_shmem_orders_inherit);
> > -		clear_bit(order, &huge_shmem_orders_madvise);
> > -		set_bit(order, &huge_shmem_orders_within_size);
> > -		spin_unlock(&huge_shmem_orders_lock);
> > -	} else if (sysfs_streq(buf, "advise")) {
> > -		spin_lock(&huge_shmem_orders_lock);
> > -		clear_bit(order, &huge_shmem_orders_always);
> > -		clear_bit(order, &huge_shmem_orders_inherit);
> > -		clear_bit(order, &huge_shmem_orders_within_size);
> > -		set_bit(order, &huge_shmem_orders_madvise);
> > -		spin_unlock(&huge_shmem_orders_lock);
> > -	} else if (sysfs_streq(buf, "never")) {
> > -		spin_lock(&huge_shmem_orders_lock);
> > -		clear_bit(order, &huge_shmem_orders_always);
> > -		clear_bit(order, &huge_shmem_orders_inherit);
> > -		clear_bit(order, &huge_shmem_orders_within_size);
> > -		clear_bit(order, &huge_shmem_orders_madvise);
> > -		spin_unlock(&huge_shmem_orders_lock);
> > -	} else {
> > -		ret = -EINVAL;
> > -	}
> > +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
> > +	if (mode < 0)
> > +		return mode;
> >
> > -	if (ret > 0) {
> > -		int err = start_stop_khugepaged();
> > +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> > +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> > +	    shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> > +		return -EINVAL;
> >
> > +	if (set_shmem_enabled_mode(order, mode)) {
> > +		int err = start_stop_khugepaged();
> >  		if (err)
> > -			ret = err;
> > +			return err;
> > +	} else {
> > +		/*
> > +		 * Recalculate watermarks even when the mode hasn't changed
> > +		 * to preserve the legacy behavior, as this is always called
> > +		 * inside start_stop_khugepaged().
> > +		 */
> > +		set_recommended_min_free_kbytes();
> >  	}
> > -	return ret;
> > +
> > +	return count;
> >  }
> >
> >  struct kobj_attribute thpsize_shmem_enabled_attr =
> > --
> > 2.25.1
> >
> >

