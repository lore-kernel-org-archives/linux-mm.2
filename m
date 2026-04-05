Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5274BE9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 19:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938FB6B0005; Sun,  5 Apr 2026 15:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9AA6B0088; Sun,  5 Apr 2026 15:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF7E6B0089; Sun,  5 Apr 2026 15:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5E76B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:30:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09332850F4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:30:59 +0000 (UTC)
X-FDA: 84625495038.17.E756063
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5696880004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:30:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=frzN249M;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775417457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YS97nbYToo2CLQY8j6NJDFBB7DerLuebCGe4nozSUSI=;
	b=IxYF74F+CrGsikSS7KS/fB4mWX8NwY8KgNI3eQjkC0D5VRhWzJN+ymJo2P+GsZV5ctq6hZ
	V93AFBITNlwox5BepqwhhvcWnpLAt6ZSiYjLzp6oQ0+e2m921j3OUos8u0GF8uTJ+aW57l
	r2VCfkZuru937kgOXomZJaksxLo9iS4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=frzN249M;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775417457; a=rsa-sha256;
	cv=none;
	b=dUmbCkalYHRYiPdSvRCjURYRq+zFOWk6ch7Bif/Z2gr9N3e3zzQRpTAkNccs3CC6eQ4Prf
	UTSRYwdYBbpSop0d2INCfVxRhksTVXT3X+QcmVk7BemiLTGKPLtP4lfXtJwfZ9qMbnBCFy
	30HUZB/8aJpQdiiMdjlehhptxhsKt/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DC2343D13
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA6C116C6;
	Sun,  5 Apr 2026 19:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775417456;
	bh=1QNQpNTSfmMxXoXrDaRFueB6QVa4xuggWaTGAyI39qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frzN249M9ZZtE6NffDbKgnymInCMFwlgQOSgoKlR+VfwCW7gJKiFxzzRIqsSWYoXT
	 vtrRjQX5lYA22DSvRDYM7RkINm8p7efLN2acOYQQ/gNuiNZ1lEAGS++Hsox3CDm3dM
	 27jqchn6xHiHZvQqYlCJs2n4Y9JNXaEzS5Or+QaP017CYqZv5AeHQOWIuquD8q/Z9i
	 +OY93FSHujJdFUWfEbGhNYaWvC4KiLEgpAAJjkHrHPK1iBoMGDub80CgCGRVRBWHcR
	 GsS8HvnM3J1DC5HMA3y4g+PuLNycGRLgWU33YSZfVuX3hejtIuSGCkOhp8HFAQgl9G
	 YQ1TormpWOIcg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2 2/9] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Sun,  5 Apr 2026 12:30:43 -0700
Message-ID: <20260405193043.110172-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 93pdt94u43prp4waqo8k9hunn8iph1n3
X-Rspamd-Queue-Id: 5696880004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775417457-651746
X-HE-Meta: U2FsdGVkX1+tfDu4S7Cd70yi0BLwuGxV5SARZOUwA+HUQ5ll35VzSBdMsouEUlLKBG3lGKITHovnsTbcRVMqNFQmq3bBCgTlT9EOnLjnowo0U/mlGzGwnK9ygTPypdWTqABPjk1mWb85sII8WU3a/4zNkYobuEuXSuETe9QlDY1WK01k9e6rOsW7LyBVmNw+RTaqoTWKZLk+7lfVD444AK/02LWX28QuvJzrgysKTtIwIJI/ZenLOt+LcT0rEp9sfFvBAdBKC56UlFoCWTsvDiHBlQo1S/kcN0q+sY/m/gd+V+1lJbdfLBI9vHNSrkNLnXCeWOhxYT7cmHzbE5e6ymei7vHFIs4gw25mlXQfc7day/XXrFwoeCo5QOFmuVCOuK1uFHQ4gPqY8x5cu+A/LszBd5uVUBwmbT33eDWChiMXnRcr+OdvIIFwzrsBwC+Xm9Cpnx2j3ThjzcAUuaPiG/qQ+SEOln25mlRuqoUiyy7ixywxoZU6QG6s72npebji/ZCot6eOk+jAiHKGcQxZABlzUKX86GGJbkL5ohmno1UaxR2vsVyju7yUkBVBK+cmf2n1PcdInH9Vgh8+76e5uUL5FZs/wmmNCvP1NmrzTobPDBgcOtYw+OHpEHob5/eSJAenbftu2HSX+LhdGx7/UrBs25uD6vBox/LUmgKjwgSTsIwW+eq413qZ2cA13JejZXpU2qoH2UsVtvtKuN5tjFdChkFLydd2L5hjbNe9oBv5ejQIE9q3H1clGlDDA344+5xsG9yjOcvkQKo8W2LNS81Gsyx1G+KXzISN3K9D9+3ewdiAcl2E2vamTWSQW5zFTRFLWZwZ35fnXwMWPjb2pydT1rfSLJZa/Zjxq80Qpr+h6DWFUTitAC2YDka4m1+R5+JMhtt8LSqHcQF92BQsg+HHUeQax9Lj0LDNmuXMnlYeQClplaJRyfKOS8tHKsI3vBq73gfK3e2Wg82eEFT
 mMXJgAcm
 vw2Io0SKsKIXzJTdD+mHZS1K21fPLKfcvxjrxF6kt8FXHRwUICv7AdU4wkwfitzfBcwZJ/DLkP5ROCUAcgwxzcMCcNuHP8nbWTqc2URU6vN+NVCzAn8DQXCiMjHmQUZ0JALA9GFicwBceJ4xdsdKdRdmNrDBxp7aUW+ZbF91iImNLwQbQs2w5oBTdYcj5+v2blX1VFc4lVnuVpW35RKuH06EkFNzau6wF9p3aGsHyb8hXv3lObplL1fIdA6EmtGElhdmsFEQU3PBPOJgjvlw+gRfMTwW7dmfpGs64rSs+kGN9IuZ9pq1scav+03cSJVOjj6Tw64OB/Lta2SfGRkN7H/Fj97P3FDnqEbIrluohQT2mkyFeY6qGnLQxOnNheicfM/27ktxsKZN6Xjpg3P9Bet4nuxRd4h4SnIXKSxa0kOk68GM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found no issue in this patch.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit f076dcb3d9e8a7170daf7c4fcb085e3a2c869183
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
> 
> Implement the user-space ABI for the DAMOS action failed region
> quota-charge ratio setup.  For this, add two new sysfs files under the
> DAMON sysfs interface for DAMOS quotas.
> 
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 5186966dafb35..d5bfba79f105f 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> [ ... ]
> > @@ -1663,6 +1665,48 @@ static ssize_t goal_tuner_store(struct kobject *kobj,
> >  	return -EINVAL;
> >  }
> >  
> [ ... ]
> > +static ssize_t fail_charge_num_store(struct kobject *kobj,
> > +		struct kobj_attribute *attr, const char *buf, size_t count)
> > +{
> > +	struct damon_sysfs_quotas *quotas = container_of(kobj,
> > +			struct damon_sysfs_quotas, kobj);
> > +	int err = kstrtouint(buf, 0, &quotas->fail_charge_num);
> > +
> > +	if (err)
> > +		return -EINVAL;
> 
> Could this introduce a regression by allowing an integer overflow when
> calculating the charge ratio?
> 
> By using kstrtouint(), fail_charge_num can be set to any value up to
> UINT_MAX.
> 
> Later, in mm/damon/core.c:damos_charge_quota(), this numerator is passed to
> mult_frac(sz_region - sz_applied, fail_charge_num, fail_charge_denom).
> 
> The mult_frac() macro performs multiplications with the numerator. If a very
> large fail_charge_num is provided, could this overflow the unsigned long
> result, especially on 32-bit architectures?
> 
> When the calculation wraps around, quota->charged_sz could be incremented by
> a small or negative-equivalent value, potentially bypassing the DAMOS scheme
> quota limit.

Same question was raised to the previous version of this patch, and I decided
to ignore this.  Read the previous discussion for details.

> 
> > +	return count;
> > +}
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-3-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260405151232.102690-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

