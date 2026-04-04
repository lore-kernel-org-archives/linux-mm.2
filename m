Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA22E63FF8
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D0F6B008C; Sat,  4 Apr 2026 16:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EB96B0092; Sat,  4 Apr 2026 16:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734056B0093; Sat,  4 Apr 2026 16:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 647D86B008C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:52:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DABE1607DF
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:52:43 +0000 (UTC)
X-FDA: 84622072206.14.0C0D5C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4EA958000E
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:52:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3RuPKPe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775335961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUhXiByf92F2XGnnvpdSzyjYQO+oi2cqnSVXhH7ttw8=;
	b=Rg4FxIQuppTb4tqZD+BYReK8Z7IjYjZMVgg2eq1Jb5c2EIlL+1uD4p+CBG8bffQyj0L9+v
	WYdhWnvUi79nrpPRkw+7QTmBqTDt2JDRO0hwy5zN5oVbmOZNHUQjX58oJp2JOibMc6I04u
	iSFDf0XzGzK84BNwkmO6O50lX3snAeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775335961; a=rsa-sha256;
	cv=none;
	b=i2n/j5ymxsTDFlUW6DPjjr4F3TmTk1p0UiiUnwQUhR7nB24F0fW08eZnsrOhSQUw6wcckp
	ZiAFgygAYuBfW17I9bAx4TwALI2pMONg2L23zailAud4936ahsCF+6vbrcOkF/MoU6MKqP
	3kyMLHfQFb2wWW6XnMuXMesf0ylxhgk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3RuPKPe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21CAB40926;
	Sat,  4 Apr 2026 20:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99F0C19421;
	Sat,  4 Apr 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775335959;
	bh=7kjl5Z0GP1aijdZFzpfKWtsCIIOBoEr3kfUnJsk2E94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3RuPKPekgG2Q5g0yCtbfxBxUqXoJ5xUVdvpsj+/LFLyVlr7U+uhFpmRoyWVpybGU
	 Cl/cTXJyKftSZS4xo8DiBWBt+y8RKTFW/PwrRfuSRybVgNIaAfOcnyIdtDZOqV9c8b
	 MH9CSNRULfIQAgCWNoz8mwY6Rks+iEYZ1mdC+osb1DYCKXXnYdrONwig/i7JctBoyo
	 TwtxH/YicsQyAHPzGgZQhQLJxcmY/8CMfKPbJYF26DU9Akw7smNcGtZEcd8s5Zqo94
	 Org6Bgqr2jqsRJQfQAEkcbcO8MjcrFurVPfcvxE4kqYv9IcsQns5IHZjSLh9FVqs9F
	 foFB3xZZ1600A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/9] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Sat,  4 Apr 2026 13:52:35 -0700
Message-ID: <20260404205235.87148-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4EA958000E
X-Stat-Signature: 386iz6t8pkpq4fr5c87rk9cr4z6smbud
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775335961-610792
X-HE-Meta: U2FsdGVkX1/P81TMDlatF0yJA216sE4vgDBPtOLxAhmUhat/yAOZiq4D3rLeHIDTSI5aIA9ot0nvMbOd/QqNZHmNK/p/5+lFhrRw1OEYWHttCckQosLoSfwOJj+gJ99iyNRPdg9kvMJLBkyDljgQgOVDa34QuZ/2suWCXgy58uy6Se3lkwYJOeRIjX08CMDTjIPeZ1s2saqeGojVGfssVlRawONuWF53413C2O2OnCmKMzCO9n5yVoFt75x3IThnnkCNgJMxKGSK7D3RryNE+Z8oAYF/98mxfo4CLhq92G8mr6Z/leGem11JaxVQDFjxPYyWXObEdblwLz/C4SUzr4lgek/GSXbpeYpXZz2r0gYYwVno6/bE0kYHpVYswLAZgc1qsCYIWbuldmeKJ6xj5EWfeTQlXQwZkhZiUNRW8D6jCaOJXXOiL0g2xvpqFxmZOHsm3al6CEJQcvYHbqsLQLD5FKSUkcNvIZ04hceae0noN82toKcI0PZIao069YSmF4m+p8Ka0+VaWy6xMXx/aNlQtqEAIz6m47wkuiYrcqv5+TQTjFq+0/lMaT2R9TW7DNOLqJvNCb7aTwJG0aaaOyq8I45mx+SFLjHnoUFD1n38ItAgyGHgCw5r1s1XzX20RqI65EJ3+afDmU7ONKzd1S33JM5GRqabuq2VTQcTkXh1nvrrQKr8HQXCd1dyqtV16LLosEcHH/7lgX2m9ORajyLpsVF+D7un8Zgq0fEcKXQQp8uahDhAE+caKOak5AjHp75L11Ld9h+RBdLT6YbQ0Hifx+ds44L684wosfDVeaSnjcEYvLVhVsk/Ep7lA9zIhfhUAh3VaPfRkeBNJUdzERhIwmh6/QHDVy3B6DFZkT6w5NWEeRxf9oUE9NgIpG7KeLdtYGp68AxtzgCiLNJzpGrW9ZwMWl2lrarp9tNe0yAdDmyiD0dILGTbZlPsleZSQEgCjxnbxHqXZ0PyroV
 q8K3D3Dh
 lajnWgkpb1QEx0VgZZxdTIYq8epkuIVTbuveigpfaEQhQh1MIltm8AaBxYobWeImhv6/vz+Ed2AqevraXh8FeBBM2RPqoasBgqZgKJRmc+m5xuFXBlbmZ9UK14Gv0o2dTpjKz9TFQd8vOYM+xcmBeaqqhTXkHPoI7KVueWt7h648VxBbAHikVGlP4fSB9nS07njSQKVwyHA5z8Ujl8SOHPH9bWZCWiErhfZHmk/kaICLDofU/FK948GKbxZPluoveA6bBi3iyOjhkxCZsjScCjihJ5KWZPnSKJBIjZyClKyWnvkfKbzBXojvbwGZS9VJtw1KxU4mgZ1sTuXg184YnhoiwS0EZWHSWWiazxV1UteSpeks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko found no real issue for this patch.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit ee565644ac37e8bfceab5e62746d85906fb91b43
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
> 
> This commit implements the user-space ABI for the DAMOS action failed region
> quota-charge ratio setup. It adds two new sysfs files under the DAMON sysfs
> interface for DAMOS quotas, fail_charge_num and fail_charge_denom, which
> allow reading and setting the numerator and denominator of the failed regions
> charge ratio.
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
> > +
> > +	if (err)
> > +		return -EINVAL;
> 
> Could this lack of upper bounds checking lead to an integer overflow when
> the scheme is applied in the DAMON core?
> 
> If a user provides a large value for fail_charge_num up to UINT_MAX, could the
> charge calculation in damos_apply_scheme():
> 
> (sz - sz_applied) * quota->fail_charge_num / quota->fail_charge_denom
> 
> overflow the unsigned long value?
> 
> For example, on a 32-bit system, an unapplied region of just 5 MB multiplied
> by a user-supplied numerator of 1,000 yields over 5 billion, which exceeds
> the 32-bit maximum limit. On a 64-bit system, a 10 GB region multiplied by
> 4,000,000,000 would similarly overflow.
> 
> When this overflow occurs, does the charged size wrap around to a very small
> value, causing the DAMOS action quota to be drastically undercharged and
> bypassing the user-defined limits?

That can happen, but shouldn't cause a real problem.  Meanwhile, adding such
overflow check would make code unnecessarily complicated.  I will keep this as
is.  If it turns out this causes a real problem, we can consider making this
better documented or updating the code later, after the report is really made.


Thanks,
SJ

> 
> > +	return count;
> > +}
> 
> [ ... ]
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-3-sj@kernel.org

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260404163943.89278-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

