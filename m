Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F97CFF510C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCE26B00B8; Tue,  7 Apr 2026 11:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DDE6B00B9; Tue,  7 Apr 2026 11:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB0B6B00BA; Tue,  7 Apr 2026 11:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02E226B00B8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:55:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82FC51B8BD9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:55:08 +0000 (UTC)
X-FDA: 84632208696.03.06A1753
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D71941C0017
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:55:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvGPcHGp;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775577306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiU4+ZxRqUVCuaD36LE5T1lFBx3dTJg0unOSnqmtDm0=;
	b=sUmHDq5VBHBlEF+3/iX0CO0/89UGd4Ed6+kwiDKlgUS/DoC8FZKPq07EAcdXzh8f1cXy0P
	G93bnsdWTVYrqb/GhMDUYYDUCFSTE4I6SaKIk5riIglWSqos93ucvhvOTvwgW0ZT9mDA6Y
	Sdan0CzICYDOkybOoUHojT5oJ+uNJss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvGPcHGp;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775577306; a=rsa-sha256;
	cv=none;
	b=cpSECk7x9Zh4QIJUTFu4cMOCMqfCfQHwbBtXehpGqfcdblvS2ms2NUAFkIhPZZEhMeTnVV
	pJkzIP/tMkzron1SdAmHkQW8ssiSm+NGD4ru9hcuWCYDI7rZPuLqybEPJlhTXIJymg+ky+
	lzsqaDE4SiPZzw5dKRKnJLhw//iW71Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B3E5600AC
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B660DC116C6;
	Tue,  7 Apr 2026 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775577305;
	bh=bpiOOia207x4yViF+TMnhqBm+TS6r0k5rDi7kdxXoqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvGPcHGpE6KxifNE0rA+t9kjNcOVdBVB8P3GNs3s1w1LXs5ObQfjTP973GmttIyE4
	 oVMnN7lH9vc8k+09gWz5W3bAgDLR7l/t6Vuer1CW86yU/5wPuyryOEDyceg2bFHHhJ
	 1tRgze+8qWfMjnh8vS1CTC2Ff5oqSf6uZd6XiWCTUfWa3aS3Lv91t+M728weIVjY0l
	 qtRyG3d6sDcpIVQDRWV76keeVXu7b2018sAElcp2gWSJKof1caU3UC3KWi06C2LAHa
	 9g0n1s39o87pVsfg/wxe09bMWYNDKQOKbQ3FqtBc+rBl/p4znEKZapqW4bxKv8hnAd
	 gH3yag2fCQZKg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v3 03/10] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Tue,  7 Apr 2026 08:55:04 -0700
Message-ID: <20260407155504.51888-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k1h5s5hnjcesb1usunnr6b3bgmq675yn
X-Rspamd-Queue-Id: D71941C0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1775577306-357049
X-HE-Meta: U2FsdGVkX1/67QjHQzNaJ61IBoIJqLvwGdNeW7Zd7vC/RPgasVU/ENUPTjSlS9Nzcidm4j3uO/oyEqbK6AO1MF/+me4v9MsV8z75q4tF4XOUR4MbUKDGGpORUZjLUx1FlnMxDKOZPiY4gw70wfwLJqbRcPGXPPXOUZpR0eFB4Xm3ck97MxULKa5ol9OJpwPe0x/NKEk/0sRLayyuc/+n0JoeO0eflgYlVf9HeQ0U8hAiI2JkiO0fEZ2LHS715Ksnnx2evcaLO28g78XMJYCA+laMxtMsbp+QLUvd4oulECyb+ZIwk+U+u2fnG4wH1HpWbSGUXecxIG9706a+AKGHVpGh7SB1KFoakCxy2dG8HeMka6KqH6UXSc3YrZEg3wK3LrgsVpk6XVIgvXd1UJs0o0GIV8BNZbYAO8PDGZmv+y6g8QlUFVzJwbh+XDSdrbfSMI85CvKtOC+OGXZpLQAetXLISz9Kd6RYUCRVS3Z9bSUXd/QMu5jGlGE4X9a9iuG/+1IA4Qf5lVI5IAn4kfnXfJjIY48OrD2CyArydqHCNGQMvJkcnZysbP8kto15FAo1QXymuSnRJNcyYWF1U3V2+pdwRaABYKPilAyDym9+1r+65b/0VyoMf0VQjqWrZEEPESq32/Y99efPObRwKP3V6Kp1qvhFfNPOiiq118U//lmi9xVsFbCklLc7NCBQ7F6/uKnGfel9dCRfzW60iu/hZZL3QZ8IxphSZcQjuconsvZ2vy/jxht/Vhp9vx4WSCNntotiN+ROdtI8rlxAFsaEjyUNHwbQJ5AwZ0HKf+HLniVN+DcWo1wvU66LPnyFm7q/fZZZ/U72h5ZG7ck065jp5+zCiti+b1jk2v5xKv5wPU4LCeKjiHAuBKHVZdJQCcdNyLlKSigvnlZrvHo8aXdsuY8nxCg/a69WSIjvo5clOG7CUn7bInvHHazlhwQGib/9efK2bXBNa8WzT/4tXHF
 TyU5HIlH
 Wvj2/L5zD16OGQudlrQB+GhmhQZIOo15YjBi2Cb2opGgYaeqJ57t4ApE2eD1Nz6m3jGpcRrgrkuaeBGsoy/8RcomYlQPvSe6z5oJGNdiEcHOR/K+atwqY1WIbKFEV3yfBatLFtkobEm0iBlXFgSSmpH3ohi5xCvj8/0ibPvTGsROsJC2sa78oWyU1P77VcZjcuQOCgKn0kXATdzwYpXHOn0P0wacEnKoD6guLgZzc9T/uP8Zn6i6twmWYfuzvtz4fy8XrHfRzXjOB5UfTy5xYqPnG4Bk8q0Bbl2y2oW4rAXj/kvkgaLWDoz+feQ+DlqSoxbXdg2RZFmNzMsOaaiukbrw9xXjxFqd0KRPfxJvJR4V+E4kGhrkGB88miuXkYsr85m+Fl8bEgX6kL1mC+3q09DwQrGCid23fE/O+T8UdPhG+t0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko argues two issues that I think ok to ignore, so I will do so.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260407010536.83603-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit 233e1cffd501d91418c4d1f0badd7f5b509664c0
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
> Is it possible for large values of fail_charge_num to cause integer
> overflows in the quota calculation?
> 
> Because kstrtouint allows values up to UINT_MAX without bounds checking,
> the multiplication in mult_frac(sz_region - sz_applied,
> quota->fail_charge_num, quota->fail_charge_denom) during
> damos_charge_quota() might silently overflow the unsigned long capacity.
> 
> Upon overflow, the calculated charge wraps around to a significantly
> smaller value.
> 
> Could this artificially suppress the accumulated quota->charged_sz,
> causing damos_quota_is_full() to incorrectly return false and completely
> bypass the user-configured quota limits?

As I mentioned on the second patch thread, I will just let this overflows if
the user really wants to set such large number, since it will make DAMON
behavior bit weird but not breaking something serious, unless other humans have
different opinions.

> 
> > +
> > +	if (err)
> > +		return -EINVAL;
> > +	return count;
> > +}
> > +
> > +static ssize_t fail_charge_denom_show(struct kobject *kobj,
> > +		struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct damon_sysfs_quotas *quotas = container_of(kobj,
> > +			struct damon_sysfs_quotas, kobj);
> > +
> > +	return sysfs_emit(buf, "%u\n", quotas->fail_charge_denom);
> > +}
> > +
> > +static ssize_t fail_charge_denom_store(struct kobject *kobj,
> > +		struct kobj_attribute *attr, const char *buf, size_t count)
> > +{
> > +	struct damon_sysfs_quotas *quotas = container_of(kobj,
> > +			struct damon_sysfs_quotas, kobj);
> > +	int err = kstrtouint(buf, 0, &quotas->fail_charge_denom);
> 
> Can the lack of bounds checking on fail_charge_denom also contribute to
> unexpected behaviors or overflows in the same mult_frac() calculation?

Ditto.

> 
> > +
> > +	if (err)
> > +		return -EINVAL;
> > +	return count;
> > +}
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260407010536.83603-4-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260407010536.83603-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

