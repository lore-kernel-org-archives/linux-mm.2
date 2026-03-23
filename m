Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FEBF483E1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35256B0005; Mon, 23 Mar 2026 14:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6126B0088; Mon, 23 Mar 2026 14:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FBC26B008A; Mon, 23 Mar 2026 14:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4336B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:37:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EEE18CDE6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:37:30 +0000 (UTC)
X-FDA: 84578185860.14.014D124
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 46EB24000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZgXntOn;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774291048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRg2GcmKeOdJcz1z27ZxeccUDfslqg/RH/olku101LI=;
	b=PwtcP9rU5hfYfhz8DmFDCaxrZqpIWU1r9DYzDiXIbkniN3Mxz8a5+FKi+vuNtk0UKej/BY
	kJ9gso3v1pdTUNT1MoBYcEz36ZGIxxY9PTBgj+JGe3SGJuY623S88Dr2q9P1CIQZcMzcws
	8hmNivENJRvjKsFZOna9r3LT0YQfNkM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZgXntOn;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774291048; a=rsa-sha256;
	cv=none;
	b=PmG3Nyu4KL3ZWMoY5p7GKLx1NfZAPY/VPbfVCiwpzUH3e1/VTeS8McYyR4JEE5v2oMMU++
	+BP4PCNXfkYmdw7pHactTpfrDSR/BLAFamVSRk3vrranUvLO94FJDrCVPiTyU48N+yr8nc
	RK9L8wmbN8c1B3Rm1wFpS9ikDWs4jWQ=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82ae378fff8so2327830b3a.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774291047; x=1774895847; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRg2GcmKeOdJcz1z27ZxeccUDfslqg/RH/olku101LI=;
        b=TZgXntOnZERc1kmCNuV7bT8lFWey7AsgUmiWk/AuF4l3BkxM/NLZLgywcdor9Jd2UO
         SPqDSPK1zAEvv2l/K5O7lwo8Qk2TcHSf3IvPDsKktasWzI908obSqkeK+romIvchjxfO
         tE/UriGKdTEYwZairHAVB4+KkXWOAoD0iE/6YFysudaD3sVrEe+1+97hI025Ag25HFhl
         YJAVkJduBxmX+UVmdP1tUt72B2Sft1KDyWzuVl++UmAOAz+5Y76IlYCK9Ec05JpdPnEf
         mYbBNYrToXg+GaJUiixOGysn5P7YXYV6ILY3S4PiWPj82DP63fpzivNUbWyQz8IZNBz7
         BkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291047; x=1774895847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bRg2GcmKeOdJcz1z27ZxeccUDfslqg/RH/olku101LI=;
        b=Cxvvxi1NUylp1iym5+mgalxYtsdG+B8BuwrDBTTXv2Lhf6TiWx2G1+mRJKJIJfEs+T
         xes8M5d6s+2Yy5F8k6dwmdXUv75rzr0Fukg1N9IRMN5Pjny0Hhj5/3C3RLpTJpj4Aoc7
         lmuBVS65w/wcGmD3OFbOdT8NbVMuZtQOHauBvMfqr5qUJmKcG9hw56I4l8AS5Pq+kGms
         3BFijXoib/STgMSQIEdDl99Hyf0gxfGu+zjxzA6sSRe4sLGGT15U/vMAJHbUunDADhYz
         RCPiODfcgQSnDWhTP37e+T2AYBZYXUQ+GWhzxizp3bwaVMOe7P/0QFR8dUOwe797vlnD
         UU/Q==
X-Forwarded-Encrypted: i=1; AJvYcCURKyc8sbDDsQkgS3MNCA15LardlzzhH9ToKflWLZpbNe4H0fgJMpr5uewAqOpug83TwQLcrAeY1g==@kvack.org
X-Gm-Message-State: AOJu0Yw3sboLmUuYwr0gUYzS+QKM5JFuYIL+W9Li7mEc3ImLWhKcoHpJ
	CVt7v55J1z2+WnuQPeMn1vk75KuIeJ3AbjyIATvqqsAppEST6di/cfZM
X-Gm-Gg: ATEYQzzKeFhLd358jlcMn0ZJm7uVF3kjsg6uSH2lLwPxjUEejrZg3zkNayhLmkVHo9F
	v7QQzl/jSn+hLtcMti8dFQrntfrofXOHIeNLhfmy3bMyVnROktKZVR27YWiwlk7WrMlS1X4ACRn
	NMp/L4PZGTBItnWmbtItwMUVkLePL0dW/lB5oCDBZ8iVlXr26FZ1aMsnmGPYHLhqG2f8qgm+Z1i
	mQ5H5KM/ya+1itPwGsC9l9Y+R9rd5fT2s30pwA9WyCmEFzPHTL/WVOGCBxqdq4sniNCYn0JMEmW
	mIjEeMbhEKXgQl8FbFxoaSPK/8D2F5vfAdm75ANlTka4hx2cUWhsQL5DVOd1RvkGepDNOeFvpSy
	NizlRWpqyrdSYAn4SHDKt9Vmj6mSWfD/4Jyl2MZVuo9xv/fooHIRw46qQ5Lb6YRm5+TCChG2kec
	9e6B6MJQOd0JQXk7HGTCm0Ejm+5E8=
X-Received: by 2002:a05:6a21:6da6:b0:39b:a48e:6a77 with SMTP id adf61e73a8af0-39bceb68288mr10367425637.37.1774291046971;
        Mon, 23 Mar 2026 11:37:26 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74456fbfb0sm8198280a12.29.2026.03.23.11.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 11:37:26 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Tue, 24 Mar 2026 02:37:22 +0800
Message-ID: <20260323183722.42045-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323150544.81042-1-sj@kernel.org>
References: <20260323150544.81042-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gfnx8ry3foshygmsdhkpwanopon5hgds
X-Rspamd-Queue-Id: 46EB24000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774291048-221889
X-HE-Meta: U2FsdGVkX19c25Pzf71HLeg3uv9+wJilYs4pF5rJWRzPz0iwFXrl5S6GEH/r+q55hX9MDQBC9gCQjltXg9nxL2uFdKLfN64ZaBIg/JAXt4/GP2gdHA4e2XfpCOwDNjRQ4A9UjGSKrCi/P6JSCCQhlPTmw3G5x1lcYrxQtY4Zf+D1enyxVp2jaT+JplDg6P8zUWLbMZDFxVBI1yBBqfl7JEbfDnwPUn9RHYGMEGQbXb707wrndZzpRc4mqEbob4sc1B6PpgnXl5cuRVJ2aPqKxbE6WTKnXD6Os/yLkvN4jXOdWOMZtPggHzx+QB8detxghStsLBTvFdXVaklNFYLyth1VjTBMTd5hRHvS/EFkILJEsRuYM1hnOkphu09jiLUE94gesc/fGYvYcQDDd4XG0TLvBi2RRRjqimmjxNVozM7zBdpyxiDLVGVgDbUsN8fQz+5rxlxKxbm2iZfwP/T11ZBnhXF+lPxmxMlFm9k/gGbA9CLPNNunUksEy1bzvAhN1+r2gOFPWkK+WT3Chiqk0HLCEwhWDOVNjRTAwLbbMNb01ZkWplX3IK+9yQciqZSnll+iofednHD6g+K+8wDsxrJDlMFSe4bxYkDsF5uQnsbQedEy/fZ3ljt9WpA5xbcAUNdo63wz6wkT4+9x9HYu2J8mVxVkB0AnWdh0sG0cUUp5wk6rgdst4Yr7jf9egL7ZP70kHcbEhpBi/3TPp+pq049HxD6PaiTWxmIs3xgXV3E399zTs3Kytqq9obtQOIP/bTrxU1WXAF4n9Qx/gW/cS9atBwPy1PbrYyKtp2xbdauWdXjM0x+gBlJVJozo7CzwsOtON4bz6PmW0q6SyD7duGiWa+7dWycryNdOXFJ2Y20ExVXiK54vFd9C5TUp/afGYKF9PKVieQv+2fvqZYxWJN3Y5l8rJSodmAMeGzsy1e9z8v0zJA+1Pk/BgbqHN4LlClG60VtcpK5Y/t+QMy7
 zmk0jvFZ
 82fpBKo9PjC8xK1diB88F3tlQI/ujBmPaQm3KhUF2ZJKhQlIx4GrHOnTCgVUDviXw+4EGhBYUJDUojvycFybkl/5VNesSVx+VAtt38YNm2B77PeZYAhvITQEjbtTlAmQaefCpBttP4ziM6V/bC81rwpyvvItmAZstZMdv/rshdB6lY1OcGYopZo4bHdkgxNGZECQD60+CRkiYdq673S9pcRH0iq9Q0uijsWe9BugEFRS+4NeV4g+DRJqPNSFRCkOYa0jaayzNPNLZpTlFhd5u8xcVOrDDa8B2KsMTuj+tdLcHnMEFaogBzqbM/gcsaNZBO7zCUUP1qMpEylEc0Mmwk5uTaSLp5rRmIAiYrtpQLJEPAC40oZdqPvMx/E93GTk9ujUhmi3zdrhK2xQ8DdOEprcgsMluIV+pwuz0i4F1HxcHicmEfTfKvOlVjWZfKEcOV4UumT217cd7PNqE6nidAUjSQetMTdxt+K+ybBzkE16VUd5YiTBMci6YODpn99JkqaMWYCPauVKR+th0/NtcVmKryXizkkJbiz1mhrWqMWPIWHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Problem
> > =======
> > Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
> > silently (no error returned to shell), because the validation happens
> > asynchronously in the kdamond.
> > 
> > Solution
> > ========
> > To fix this, the commit_inputs_store() callback now uses damon_call() to
> > synchronously commit parameters in the kdamond thread's safe context.
> > This ensures that validation errors are returned immediately to
> > userspace, following the pattern used by DAMON_SYSFS.
> > 
> > Changes
> > =======
> > 1. Added commit_inputs_store() and commit_inputs_fn() to commit
> >    synchronously.
> > 2. Removed handle_commit_inputs().
> > 
> > This change is motivated from another discussion [1].
> > 
> > [1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> > 
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > ---
> > Changes from RFC-v3:
> > - Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
> >   pointer dereference during early boot. (Found by Sashiko.dev)
> 
> I'd prefer archiving sashiko question on the mailing list so that others can
> also read it without have to visit the web site.  Please consider doing so.

Sure, that was indeed my oversight. I didn't consider that others might
not want to open other websites (or that the link might become invalid
someday). Next time I will try to archive shashiko question on the
maling list. Thanks for reminding me.

> FYI, because such sharing is not very comfortable for now, I developed new hkml
> features [1] for helping such sashiko review sharing, and I'm using the
> feature.  Please fee free to use it if you think it can help you, too.
> 
> [1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#sashikodev

I will try this tool.

> > - Removed handle_commit_inputs() and its associated polling logic as
> >   they have become dead code after moving to the synchronous damon_call()
> >   approach.
> > - Ensure the 'commit_inputs' is properly updated.
> > Link to RFC-v3: https://lore.kernel.org/20260322231522.32700-1-aethernet65535@gmail.com
> > 
> > Changes from RFC-v2:
> > - Removed damon_validate_attrs(), now using damon_commit_ctx() for
> >   synchronous validation in the kdamond context.
> > - Following DAMON_SYSFS pattern for synchronous commit via damon_call().
> > - Link to RFC-v2: https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com
> 
> Thank you for adding the detailed revision changes.
> 
> But, please consider waiting about one day before posting a new version, so
> that we have enough time to discuss on the previous version.  If you find
> something you want to change on the next version, you can comment that to the
> current version of the patch and give time for others to comment about the next
> revision plan if they have any opinion.

Understood. I will post the new version only after careful
consideration. And when I have a new ideas (of next version), I will
clearly comment on them.

> > 
> > Changes from RFC-v1:
> > - Remove question from commit message area.
> > - Added synchronous validation for DAMON_RECLAIM.
> > - Rename damon_valid_attrs() -> damon_validate_attrs().
> > - Exported a new function damon_validate_attrs() and declared it in
> >   damon.h.
> > - Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com
> > 
> >  mm/damon/lru_sort.c | 49 +++++++++++++++++++++++++++++++++++++++------
> >  mm/damon/reclaim.c  | 49 +++++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 86 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d72976..37b3c897e822 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> > @@ -39,7 +39,6 @@ static bool enabled __read_mostly;
> >   * the re-reading, DAMON_LRU_SORT will be disabled.
> >   */
> >  static bool commit_inputs __read_mostly;
> > -module_param(commit_inputs, bool, 0600);
> >  
> >  /*
> >   * Desired active to [in]active memory ratio in bp (1/10,000).
> > @@ -349,18 +348,56 @@ static int damon_lru_sort_apply_parameters(void)
> >  	return err;
> >  }
> >  
> > -static int damon_lru_sort_handle_commit_inputs(void)
> > +static int damon_lru_sort_commit_inputs_fn(void *arg)
> >  {
> > +	return damon_lru_sort_apply_parameters();
> > +}
> > +
> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool yes;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.data = ctx,
> > +		.repeat = false,
> > +	};
> >  
> > -	if (!commit_inputs)
> > +	err = kstrtobool(val, &yes);
> > +	if (err)
> > +		return err;
> 
> I was not very sure what 'yes' means.  How about renaming it, say,
> 'commit_inputs_request' ?

Indeed, that makes sense, I've now changed the variable name to
'commit_inputs_request'.

> > +
> > +	if (commit_inputs == yes)
> >  		return 0;
> >  
> > -	err = damon_lru_sort_apply_parameters();
> > +	if (!yes) {
> > +		commit_inputs = false;
> > +		return 0;
> > +	}
> 
> I'd prefer doing !yes check before 'commit_inputs == yes' check.  That
> eliminates false request case earlier, make my brain cleaner.

Since 'commit_inputs' always is N, I will remove 'commit_inputs == yes'
and keep only '!yes'.

> > +
> > +	commit_inputs = yes;
> 
> We will anyway set this 'false' after damon_call().  Before returning this
> function, users cannot read commit_inputs parameter since this callback is
> protected by param_lock.  I think we don't need to change commit_inputs value
> at all?

I think so too!

> > +
> > +	/*
> > +	 * Skip damon_call() during early boot or when kdamond is idle
> > +	 * to avoid NULL pointer dereference or unexpected -EINVAL.
> > +	 */
> > +	if (!ctx || !damon_is_running(ctx))
> > +		return 0;
> 
> damon_call() handles !damon_is_running() case.  So I think you should check
> only !ctx.
> 
> Also, this exposes commit_inputs true.  Next 'Y' write to commit_inputs will
> make no effect?  Again, it seems we shouldn't change commit_inputs at all.

You're absolutely right; I realized this during my code review as well.
Changing the value of 'commit_inputs' is indeed unnecessary.

Best regards,
Rui Yan

