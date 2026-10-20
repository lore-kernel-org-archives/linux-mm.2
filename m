Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7F7606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXXraiGt
Received: by kanga.kvack.org (Postfix)
	id 4212F6B04F0; Tue, 20 Oct 2026 11:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8C06B04F2; Tue, 20 Oct 2026 11:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9656B04F3; Tue, 20 Oct 2026 11:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 075FD6B04F0
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:05:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80F6A80239
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:05:07 +0000 (UTC)
X-FDA: 85343327454.26.EC4201C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D639D8000F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:05:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXXraiGt;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeTkxtK9f/H2exSxElwuEwWkTqWW/9vOEjR8TQV4/fQ=;
	b=jCyk8FMIDbtlyS+VP9OscVMRDVc/zJeMM08PDuJI6XcoqHY/g/pLeIkabW9+dtBoCQWz96
	ViDJByOuHjPa/XN/Lz0+e1x7MjnXPoW3NzCHN4hleNYa5GEMmhLEpAQ/geQiJcorqkx/HP
	p3+jz+/376WNqaLOc2J5X/pSA8NR4nQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508705;
	b=8gHVDdsXHki70nXo0edew/IclZi61zK9h3liZzA/ru1UhFIaZCAmILXrLwbKDLjcqz8CJ6
	egZRaIBSoQZZOQJBYe2m5pLkNePvU3QRL0TCpjkUqqy6TUNyVKeYNAtzogMWMeAcmL7eU5
	tZHyM33Tw+jRjV2BXDRn3orjC79Xa4w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXXraiGt;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4509418DF;
	Tue, 20 Oct 2026 15:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7102A1F000C5;
	Tue, 20 Oct 2026 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792508704;
	bh=IeTkxtK9f/H2exSxElwuEwWkTqWW/9vOEjR8TQV4/fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXXraiGtzkkqFew9mZGiB5EamfG90+9VavaSRrk2C5yA/eLSi9D1r7mXgjIGbh+Pq
	 crjXDLCNBs5QS3S2KLPAxcw2ELXRmfDMhGOgJwbkihP9f5bk2xJ3T5bzxK4WVGTk+H
	 ER6NokF7DaeYbrk0sbYUrYJtoRibKKYHZVr8dm4PZRoKbWOMqnWCptR/k/hUvUHRel
	 +Ook3S6Z9VipyOPJXNssV2PnT+vvinXEAB281X5XfMXp1I1IN6Z+bgP0bMO0mz3d2D
	 AnQp7b3QSdqO8FFqJZ+SwiEpROaYdrziKh5MvCljvjnN6wHKvWJyvjrg+Uo6nWie1O
	 rOLuGhvJlSpvQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_value_store()
Date: Tue, 20 Oct 2026 08:04:56 -0700
Message-ID: <20261020150457.89830-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-179201@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D639D8000F
X-Stat-Signature: gpe5urzbqkr87z7h1an1hbrg4ri8ydrg
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792508705-263389
X-HE-Meta: U2FsdGVkX1/Wpl88BJ0EUM0mNkzIiYZnFNjZ+7MEEbXCuvFU6LCDC91WXCv6jkhG97uI3bqS3c0cpmZenIRsHVEas5gL/CGuQaNzo779L81oR7CaNHnZXpfNc7Vbvh/Fsh3IpUriyNy0CA0tQlIzLEqxz5hgTfE0f3CVY4INwf5UR9urLQ4CnHUxal9suKfMh2vkIPTeWfMI6uinShPbsYJC4SIHRONqf/rFg3iTfFJBPDV2Od4Rr5yFaR8cNd6svonTamKGaARTcQyeNF6/uKd4+adbtsFjC4njHUALec7/4tYlZbqkLEHDpQSzPjL7uSlJopU499QHR+NA7lkhMiuLhAy4kbCyYZowNmTBNXIX8Dr09rrcclvXh9goTKB3f3pPxbGY4yb13h/RhEPhYyZSrlAGjyIkOi2SYDTS1baRZRbqdJi0PjLGpp71w3YbUEp3LFqzBUQ5VXkG95MscQjOgZT9ZeC6Loxb8jm3hd8cs4u1l++HrxApjyKBkceuFdFAqbj4QYA+Lp7Duq8+iuzZjrFyPjTOrW4J1+dr1FMo9oTs6/z+JZ1VIlOwb516ig8KC37QwX0PheZE/vFAdXBNfOrq2tUk5ZXsd+s57wsm2IKbZR/ChqepGDGLlGvSFEldj8VkvqWj6YQFILH3Dlua/SzABU4IgPPSGmt/KyzduVQifZ+AvUgz/vnR9jGHj73q7Uu9vKKJNlwot4wbaSZYbDeqW1E3XwVJCPYNmMY+VeicWKA20EPNcwVZ1uVuUp9J5/gl1W6ND5sYc8MJ2P2rRHY7UvIYEI0GjKCHjRLfsCFsmS7alGRcoeYT+LuD565Sq5CfOUeHrdEyZBitPoJemmM6/9TxlYq3smQ4rtSQjyd7xLEtmgKzPdDaUz0F4U7WaxqzPk22QxtXLgA4S+/qi8wt3WMwIXohJq48kKs9UA89yKu2Cmk1YQBpJTTTTD2poAb9L6Frw1RA2RI
 WCO2Kb5W
 02jyA4F2JY8GfhITGCfJl4Gn5HjLD8Vh6GIn/lhLPkfsOg3xBk1070wn7htCItOR1IxUFfGAfPpy7MIZiMaGB8OBHsn55LjU9VcE9/BtAufY/YQ61+5xqYW7wn6CyCMh8MdW6H0B1akHOcx0k6yNk/aP28Vqq2stq9g1d5WtDeCW6fD5xnOKrWnuQqV8Wqr9ACDDVxjR9u+d6UcnVljMxacG9IYJ51pfG9mvbIoH66wcs51j7470xbT+Pi2f+bQrD3fkZMDc8uRAwSP5sH/SKhb6rmmwgjpiv/2pqpjmxR8UK7JpDYAisHOLbmk1XBuZUYyZq/Of+vppc4cS9ZG2x+Zn2DQcxhtWbnT/qtsk8Bu66vthqccuBjPgI6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 14:54:16 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm/damon/sysfs-schemes: uninitialized stack read in target_value_store()
> --
> 
> commit f43fea0015fcb1917385f72d150c59603a9ae43c
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_value_store()
> 
> This commit holds damon_sysfs_lock in target_value_store() while updating
> goal->target_value to prevent a time-of-check-to-time-of-use race with
> damon_sysfs_add_quota_score() that could result in a divide-by-zero.
> 
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 8f083611741fd..55298a17b653a 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> > @@ -1355,7 +1355,13 @@ static ssize_t target_value_store(struct kobject *kobj,
> >  {
> >  	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
> >  			damos_sysfs_quota_goal, kobj);
> > -	int err = kstrtoul(buf, 0, &goal->target_value);
> > +	unsigned long target_value;
> > +	int err = kstrtoul(buf, 0, &target_value);
> > +
> > +	if (!mutex_trylock(&damon_sysfs_lock))
> > +		return -EBUSY;
> > +	goal->target_value = target_value;
> > +	mutex_unlock(&damon_sysfs_lock);
> >  
> >  	return err ? err : count;
> >  }
> 
> [Severity: High]
> What happens in target_value_store() if kstrtoul() fails (for example,
> returning -EINVAL or -ERANGE on malformed input) while damon_sysfs_lock is
> not contended?
> 
> Since kstrtoul() leaves target_value untouched on error and err is not
> checked before acquiring the lock, wouldn't this overwrite
> goal->target_value with an uninitialized stack value (which could also be
> read back via target_value_show())? Should err be checked and returned
> immediately after kstrtoul()?

Good catch.  I will check kstrtorul() error and return -EINVAL in the next
version.

> 
> []
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261020144726.88978-1-sj@kernel.org?part=1


Thanks,
SJ

