Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D2AF45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E176B0089; Fri, 10 Apr 2026 19:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7BB6B008A; Fri, 10 Apr 2026 19:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6946B0092; Fri, 10 Apr 2026 19:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84CE26B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:58:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4760F1601B9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:58:24 +0000 (UTC)
X-FDA: 84644312928.28.AC0B1A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B45231C0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:58:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2fUmmAw;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3WkYMmZgmGlrYS2YM+kkZo67mX5qdbZZCOLLBg1VUU=;
	b=eim/N5xe153TYJmZfe3LHVICu9tVYCXYpIkjHebAiRPOLYdb8phfOfdTOaGHHDa2VDM2dL
	nDbdJau5O3p4C916qmhhwp9zuQYFajq7aNCX6NpuOuJ3g/ea7UAOCRBfMp0boUgI22MhHP
	qs6Usm4EmzZefsSZRodfzgG4dkO+aY8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2fUmmAw;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775865502; a=rsa-sha256;
	cv=none;
	b=lZuaGujaZwyjm0RoaKxX6FuFqdiGK5PJNCdx8bEMMlnkVXNr3S8ynNU86MkliYXkR9HZNX
	BHoDsh2rXNeTKXoWLu1vXPkGJvw5Tp4uuypgi3F8hOUfG0hCoIbvOGfh/hXBIJc/wn93cD
	zfqd9D4LFGVJQ4mcKfdDqakMexWgGQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3541060141
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF204C19421;
	Fri, 10 Apr 2026 23:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775865501;
	bh=u6dUJAiT+Pm0l56lG2RUtGPm/TrRVQse8BkRehkw5Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2fUmmAw08Qwd7I9H/YkS6V49OVT9cnwKs2ul0tRBzEVbsIIzHzcEZI5VmE2sQwPK
	 evshluf+HwhFM/S7LAg02cB0gfchFnW9Xomf4eSdo37ph8cKMumr2cq7SUqFG6WsE5
	 kgk/+mad9S5QkOz+1PYKWO5DImEkSTZ7J09KQ7icUugX/7oGr2+uJ0u9YdYZH02/Yq
	 rueOzDq5GphY6gWk+bvl7RZWgRge5k40vqrLjye/V51/NF+/B4UQ9AS8JVeu6dcUmE
	 Ay3awib8Z3YndRRjjnFwFyx5sxQ6L7LJpSfMwGt6Q9HqsG5lW/1jdj5KfJwgRc5tld
	 WhqgSunWu0Swg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Fri, 10 Apr 2026 16:58:18 -0700
Message-ID: <20260410235819.91133-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B45231C0005
X-Stat-Signature: g1cayrbgcw8djnaqpngm5fd46u5jzuq7
X-Rspam-User: 
X-HE-Tag: 1775865502-726590
X-HE-Meta: U2FsdGVkX19Gx/5ozX7Ewrc/c+ouHYYsB6m6qJqux0Ru0VRgul+d2XtyGwB9uqHSP3DBEMjlzWJCpYOohqwH521BdLEfIpbUvB8C8w+8LYTCBAVjA6OKaJddJXYbUBka2sx/l2vErSN7Na9MU55QYSHL9PUt+GRSfkIMUlEXWuDd8tNqD1M52Som1E+7lbR6gzHmNCZ0UzjIh3ODyCZYhtk/8gE/MFieKUJ3z+QCVeixKCh7iCnX1BqjsiKUAru4bffXuatRZj1ZPq67AHRQ6VoXcEe4Lz+KW0vgfwlheUsvCyPZ0WwAtZzWYxKKOd8YtMD0M9njG33joGIP7UHa0vTOrVDT5g6MZs0rQHt/v7ls6JnVX5iCUZ4akurWzICOk3uzocD4STQzjs2QdC9vA7tcoYaVLUq/1K6kQojyFOe9kwsURoSysJWLx49FI/x4Vh97Tb7yhFuhn4C58kJzQJHRwf/7PSgB2H5gZDSIw1bV1L+njgfatRos2vDvjwX/3oFpsiLnKdEUf7TCxcwByfmGT2XqVgqSMnvMbg5VP4zJXrhKJ6AdolLOgx8BKy32eVHRlTRr8BVu1sLgNFpUPOL31BY9CGZiGA4NgUQJ5mc4ObyUkyHXX7+Fsfme186gWn/FX5H4tb2ZWpMrSOs3RpqS4hdVGQe7s8HHDeu5xfJ7uuiZjIbwOq0BTjAX/FL5LxEthzzvatMEjQkUuLxZ5CNcpQATw1iu9lit8SdqY5Msbls/oed6HjwCK/HS+L2Dm6SdMly80LiCYDFrcQa1vDYA1yyjZ22/oW2teGyxFZUtDuD+JnZVhWFD34lNe2HF9TOyhBFFWQaunYOT/iueYcln3rCjrPlq4IeDSswl4V628gXAUpj8jcKjTAzrf1Z+l91HrIvs6HD4rACAA4H7bpbIPFE9Ymm/MyeVaqucTzV781/j22XZQMHknVlEvvCkcLQK3vqhQrCSlvO2R4n
 fvYC3GVQ
 HmncnkI7zztsLOl/O4RuVGdiuDBKmIkwZBBsumX1Q4M1F0atX0Ag/JMVhg/ZzMvWK7ApVEQvRPsr78iRQJ+Q2EUQ0UotpNa5g4lBMewrgLpdicK+E3pVRmiqZuPuhuhqXuJxEY0CU2/VFfTf5BO463Uy7Hyw4NcXazmlpM7mSAe2WQBSiL++0DgpE+kq5+0wqx0oJnvTIZWROT6qolSMEuqMioXbbdOrGMbG2KCgwyE4/BXylzo5mb0FkwZqQ4zHZjSOgZVbEGKTyWwfhCuiTr7WcLwWnAfWWOoGg+cSv/O1owK36hjSVZ6YqPFvJD5Jg7ZUsTCEQUySy0f/ntDtfPOkiOK87tBC9AB/pzMag/nr3MQCKk2/X9VioK4WY86bzUNaaJpj1j0zhlSVU433x3QWBXWAxBIwrcCbJPb/EyyqBH4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko asking a question that was raised on the previous version and I
decided to ignore.  My opinion is still same.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-5-sj@kernel.org
> # start of sashiko.dev inline review
> commit efc09e724c58ae44645ba20d1865e976eae67242
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
> 
> This commit implements the user-space ABI for the DAMOS action failed region
> quota-charge ratio setup. It adds fail_charge_num and fail_charge_denom
> sysfs files for reading and setting the numerator and denominator of the
> failed regions charge ratio.
> 
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 5186966dafb35..d5bfba79f105f 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> 
> [ ... ]
> 
> > @@ -1663,6 +1665,48 @@ static ssize_t goal_tuner_store(struct kobject *kobj,
> >  	return -EINVAL;
> >  }
> >  
> > +static ssize_t fail_charge_num_show(struct kobject *kobj,
> > +		struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct damon_sysfs_quotas *quotas = container_of(kobj,
> > +			struct damon_sysfs_quotas, kobj);
> > +
> > +	return sysfs_emit(buf, "%u\n", quotas->fail_charge_num);
> > +}
> > +
> > +static ssize_t fail_charge_num_store(struct kobject *kobj,
> > +		struct kobj_attribute *attr, const char *buf, size_t count)
> > +{
> > +	struct damon_sysfs_quotas *quotas = container_of(kobj,
> > +			struct damon_sysfs_quotas, kobj);
> > +	int err = kstrtouint(buf, 0, &quotas->fail_charge_num);
> 
> Could unbounded values set here cause an integer overflow in
> damos_charge_quota() on 32-bit architectures?
> 
> Because kstrtouint() allows values up to UINT_MAX, fail_charge_num and
> fail_charge_denom can be quite large. When these are used in mult_frac()
> for calculating the fractional charge:
> 
>     mult_frac((sz_region - sz_applied), quota->fail_charge_num,
>               quota->fail_charge_denom)
> 
> The mult_frac(x, n, d) macro computes (x / d) * n + (x % d) * n / d, where
> the types are determined by typeof(x). Here x is an unsigned long.
> 
> If userspace provides large values like 1,000,000 for both the numerator
> and denominator, the remainder (x % d) can be up to 999,999. The
> intermediate multiplication (x % d) * n could be around 10^11, which would
> silently overflow ULONG_MAX on 32-bit systems.
> 
> Is this potential integer overflow a regression that results in an incorrectly
> small fractional charge, causing DAMON to under-charge the quota limit and
> bypass the configured scheme quotas?
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-5-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260410142034.83798-5-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

