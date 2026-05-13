Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD33CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633CA6B009F; Wed, 13 May 2026 05:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B8E6B00A0; Wed, 13 May 2026 05:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5485E6B00A1; Wed, 13 May 2026 05:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40BE86B009F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:03:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E04988E5C6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:03:33 +0000 (UTC)
X-FDA: 84761808306.01.983A7AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01863100007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:03:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bVvS9T1c;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778663012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoskaGw0Q8yxgeO7B8mlT/VaBXLrJmGxKMuQUmZVYSI=;
	b=OCOmlx//pIaTHI4z4PsSihpy/9ay69+zH3DDCjglyAyv6qiNMdOmIerfKFtH+qftheqTvS
	0oFtGL4r+LZt6f+RzMG4Xr/Z/9UmzMiAk9LGNE4KY60rCy+xrvl0jZYmcq6yM/cfEE2pSj
	Mok4Ogks7x3LHDnNEzcHP/iZUQkS/9M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bVvS9T1c;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778663012; a=rsa-sha256;
	cv=none;
	b=HzYvLI/RvzWumHKWJLG9m8kUXZVU4/WSKYYNEERler8J8ts6i5ulxHjUNBmqRbi4IjeH0L
	nNXQ1hILKjjq6DcJleS6CHtioAP2R7HJJdFTjYRP/BNFzb7rZr9UMJiRrI354PhIAbZCHI
	wqj/JEea0+iYhlcqrfO9z3a774KimyM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C12AF43911;
	Wed, 13 May 2026 09:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832FFC2BCB7;
	Wed, 13 May 2026 09:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778663010;
	bh=af40/5Zjdy1tSfCHnwVvLm1ZIi3gNr6Oj2YMmr1U13g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bVvS9T1cd0z9kuVHxo2CTpmRpyfVffPG+nKPrqSr831qn0xUWEnHd4ftNJoErk2GR
	 0G5mYUXLL1EFxF8KTK7/ycFU9cU2+4XTTUuuRC/vkCMEUnyGPc2mReuTru5alUUUiA
	 oENyBcyxHU2RbEAGYRA6wB/gg3RTlpm61qJpNUEmZga/T5DUIE+Aa/6hS+WJ7uNz7K
	 akL/R51Nqh5BBeJ1LWnPym5YN+r5xCe3gvZ0X0iLa6j6amEDFtuduL10+OtWIylut4
	 CAdm5Yaol8ENGbI2/vO8veatdcKJn1Ewp9+lpNYjJ3afKvjMxj/J8maTbpzEdvgXw1
	 svPLAAAHm9Htg==
Date: Wed, 13 May 2026 10:03:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: ranxiaokai627@163.com, hughd@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn, 
	"leitao@debian.org >> Breno Leitao" <leitao@debian.org>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agQ9FXDr_5ybD7AR@lucifer>
References: <20260512120557.49995-1-ranxiaokai627@163.com>
 <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01863100007
X-Stat-Signature: ww6i74stmxowjzxkjz4ryp6sgqmmidkb
X-HE-Tag: 1778663011-179573
X-HE-Meta: U2FsdGVkX1+oIeH9eJEbQtUFtLt5CEam6Dk7hJEV+kCUV23YgCbctSVarGkGWVJQu4pAr2RlE7/8c5C/WcC9l4bA1gfGfV+sO98Qasjz9+0iRzxTV5CgB+u/K8w9cSHwsjXj0bFUGmL8nDLFOBpT7pbZIBCmtJeNVv1P9M5x1XFPjsDCVPxjlzS73Gcyk7u2E8Lq9sIEJNgFeNq3AASzLfmejKPdsdw9TfxeoxqkwgWi73iVvNTOzHg0HTo0HCYQH+hYo5YxOxehaCvQMO+xz9vfkiJWJ1G/k2fWVAL2jJnyYnk1HYh6NtJGi+penPvIMzm6Mq+wy+tvrmZZu0BzH+L5hAJ2R/31sXEoeK3J97+cvKeFryCpNc9Hee39MC2zblgUftCT7XmTox7vF2X1rBMtoMABSplpXMCYTSIpRcGgBOR91K/ZALjhjC0RMUgjO7WOzMHSQ19ArVL6Z7A5tA0k9UeFhgVQ54i5ILoAKUzVzVJ8toPNlyVoLx7GjO8DrJ5MhqebrfJJv8CsNNiNvYFriQJwFAs/fDz21eogfVNoKcrCBgJ92bRjNKKZm/mLNvJmXxNf2LTqkrGbmMu5lDQMwuXNdVsI34VnUGm3s3SeSt49NL+hiAAPKmg7sV+iLFNgcDPQz+U5hH05euGPAVF+Qan+RN1b21cgjrjupb3lMKwYQkgVHNshN0Uco1xcwagSkdP9JzXvFGJkrPkOWzWKhPd8ASdCPRlymI49u3/7Eg1/pKmjX3KQc0TA6LX70e3CvLIizsEDDSxg2eVI4EG+pqe8EBZbXKu9+c0IvJaiEsvt9VEkYKs6Y/wDPQRiQ49MA9hhdSpPdIjVO1lKxYhK1eXUMV7vmaZw546kydD8Wd8qKRbHUWaGMQn+FmRSXv7cuyM8/N+GqMM/7UVvlv8d7hlT3LGz8q8BNTk2Cx9jm0vfkNKfDy4U6WLRqiajpouAAuXg98h/MKrbaXh
 zg1gLyxx
 wtWHy1hFTfm3G/EOYAncqPbgBiQE0tjtk7V9zPrriaott+sDrzROfZapeyOPtyY8X69AYYRqhDSqVlAvPT3aojt9Qnp+C74r+vcAKoohCGJZ+uNfNG1EXJYvulLzepuxZbqb2cbHPP9XC9ORfrRw6HbAGFDitG+rpYgZDcL05B9h1mnRsrvGQMjzz6fFDTYnzXwwPn0eJdtz7HPCMFIA1JYvKWWzhK3sTJtKjJhwBrpNkV2q72rmMYeqqFsIExCoKXGLAeydbu13szMTevl54Yci0yt0wxn9jyGxgUAbRcYKQ2SazdEVqUB3Jmni+mpkCUAh9E24xiZjY67G8ze6ZiyCqug8oogtALpSFXKrA+taTcb/gqy7eAJFdBvbJelTxhUb5pQWPxYUx+zEZM6JZ57f7C+xpXnvSPeCKmgBy8BSdmcK/8pDGlj+OFnZMHRmY/mfOo05MEziJ8R96ojbh13MB4wM9E87hVkbtT7KTG6ItlMmJXWIdIGaEJJZEnTXe0U73gG35l2neQv+OR9jRR29ypQL6C2hZqhSpBcWK12l5uSGiE2WGY+NrG3CujfPBxB42pCp9JumVfz4K+1GOoaTh6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc David also!

Unfortunately we put some hugetlb logic in mm/shmem.c too which makes
get_maintainers.pl not do the right thing.

I wonder if we should add mm/shmem.c to the THP section _also_ just to cover
this off?

On Wed, May 13, 2026 at 11:04:12AM +0800, Baolin Wang wrote:
> CC Breno and Lorenzo

Ran - since you're going to need to do a respin anyway, please cc- Breno, David,
myself and probably worth adding the THP people in general:

R:	Zi Yan <ziy@nvidia.com>
R:	Baolin Wang <baolin.wang@linux.alibaba.com> (Baolin already cc'd of course :)
R:	Liam R. Howlett <liam@infradead.org>
R:	Nico Pache <npache@redhat.com>
R:	Ryan Roberts <ryan.roberts@arm.com>
R:	Dev Jain <dev.jain@arm.com>
R:	Barry Song <baohua@kernel.org>
R:	Lance Yang <lance.yang@linux.dev>

Thanks!

>
> On 5/12/26 8:05 PM, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> > anon_enabled_store() with set_anon_enabled_mode()"), refactor
> > thpsize_shmem_enabled_store() using sysfs_match_string().
> > This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> > calls across all branches, reducing code duplication.
> >
> > Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> > all test cases passed.
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > ---
>
> Thanks for doing this.
>
> >   mm/shmem.c | 88 ++++++++++++++++++++++++++----------------------------
> >   1 file changed, 43 insertions(+), 45 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 3b5dc21b323c..0cc7872cc576 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
> >   struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
> >   static DEFINE_SPINLOCK(huge_shmem_orders_lock);
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
> > +
> >   static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
> >   					  struct kobj_attribute *attr, char *buf)
> >   {
> > @@ -5551,57 +5574,32 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
> >   					   const char *buf, size_t count)
> >   {
> >   	int order = to_thpsize(kobj)->order;
> > +	int mode, m;
> >   	ssize_t ret = count;
> > +	int err;
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
> > +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
> > +	if (mode < 0)
> > +		return -EINVAL;
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
> > +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> > +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> > +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> > +		return -EINVAL;
> > +
> > +	spin_lock(&huge_shmem_orders_lock);
> > +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
> > +		if (m == mode)
> > +			set_bit(order, huge_shmem_orders_by_mode[m]);
> > +		else
> > +			clear_bit(order, huge_shmem_orders_by_mode[m]);
> >   	}
>
> We are already under the lock, so you can use non-atomic functions like
> commit 82d9ff648c6c does: __test_and_set_bit/__test_and_clear_bit.

Agreed. I guess you're going with the RMW form so we can conditionally figure
out if we need to start_stop_khugepaged()?

>
> > +	spin_unlock(&huge_shmem_orders_lock);
> > -	if (ret > 0) {
> > -		int err = start_stop_khugepaged();
> > +	err = start_stop_khugepaged();
> > +	if (err)
>
> Moreover, I think we can follow commit 82d9ff648c6c's approach: if nothing
> changed, we don't need to call start_stop_khugepaged().

Agreed.

Cheers, Lorenzo

