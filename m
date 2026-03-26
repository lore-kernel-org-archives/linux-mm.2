Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E457C109E557
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497FF6B0088; Thu, 26 Mar 2026 02:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448CA6B0089; Thu, 26 Mar 2026 02:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F216B008C; Thu, 26 Mar 2026 02:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 246396B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:16:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2BD41A0BCD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:16:57 +0000 (UTC)
X-FDA: 84587206074.20.B07ED07
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id CD7F9C0006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:16:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O7hlJtY+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774505815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaXdTogJeFPi3EmTAth0u459UDtlcsY8EDprhKyZo+4=;
	b=r00tZ/GqgDcEFGqnV5Y68IAmEP8pGWvVc28WYe3rVNH8GWyWVr7tTyYdx08V8ydSuEoUSs
	f4lXLX4NWBiBn0FxTWla/vvEqm3WdF9U47oA4Uh0tWxIwInAZBB17gibb/8OtqX5aVDQmv
	59/jrXutem4s7KL7waEibCtLcfaOPuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774505815; a=rsa-sha256;
	cv=none;
	b=2ax3zC7G4OE2vx288luUYCthHCjEB8so11JOSGdu7nt7EABAn4sicsAdH7nUQXqOgyEnmJ
	OuthTNnOcTEvZffTipTmnVjzoR82n2TOv1FcnkvfZHNEUihoRpz5y+BXV1aqzeXZ4pfint
	TBoPEcWfyG0Aza0mVt7h4g7JdAoZiFc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O7hlJtY+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b0ba3bfe16so7388705ad.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774505814; x=1775110614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaXdTogJeFPi3EmTAth0u459UDtlcsY8EDprhKyZo+4=;
        b=O7hlJtY+v4VirsmcFB/oQBLjhaEA2gHlLO5ulVdtfPrwgffAopeKAOro+Oq0EQNpsu
         +MlO6NtDaHesK8nzJqW/sRysC4Ywu6JcrdZvWCRrBICD7JcgunbLi4bmQSTKCQ7xt9TD
         aQS8QHWMVVK5tED5Hd1qjIfsmki3Z5T4kmHj9PM8d2mRkRA5ZMEeCs1LAlH5qovWLu5M
         sEzzJZEDj7Q7zu1mBd/7UlzaJW/g813Wz6CFW0fK4Srhw3s55TkvtRlFflzaP74FTW3Y
         HtqdYuWGhQRFf78DK3cusDLIiijRUbEJGDfJVz5c998yK5TI8sOVew0+RkLmJ9iSK2qJ
         PGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774505814; x=1775110614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xaXdTogJeFPi3EmTAth0u459UDtlcsY8EDprhKyZo+4=;
        b=k3lWSZMowCHR3BQCqngd0MeJklnoT1fQNnUJGBxI2RKTD/n8D7MQdpoOdnwu5DBpUL
         7G4cYpX4hoDdQ2zHjBstruFubTyMvfsG/PqTTpEkS4HCRE+jVTot6WKRJiRB5w26vnTL
         ElgoNO6bLzfAOlKEsiynw76OVIc/zNA8oQ4rSr+gpHYuBJdhbGFsSk+IWWguX/FdPzRH
         RNUVbK15Ln5NcBUXLe5c+PGWKlKMjGLP1ktev7oEdwtqa6eoxx36hVc8dV2CXupyHI3C
         XE2xe33g8QA8MUu/NU+QWtA/xjAllHCBbbdoyHFOkkWe6+FnMcVQQEES6PrCzRKTZNct
         wG2A==
X-Forwarded-Encrypted: i=1; AJvYcCUUP2dio/QIZSNal1GJPWNGuWbBDIvEgYm2v8nPgew0rHZBm/5/VAoD7wY+0gBq98OLQLO2zhRySg==@kvack.org
X-Gm-Message-State: AOJu0Yyvged4Y/SD4OcG0xRPJBAuIr+STshuEKFmV08EDPqwtcx2TFuy
	1BNMqdN/iUpZ8MhS1puPHs1qY1U9f7R9LI/UXAmjj+nYJzujLAHG1h5r
X-Gm-Gg: ATEYQzxkkdTuofvq2lTiW1hv94/TOQW9ZrGravjJZTnLQGAcLd1VskR3upSOrVtx+lU
	OWTjvnqL3srhVDjvb12LBz6ivPUxOX3Yl6qXqgQdHDfVUOlz0pw1goQevztoqvx7J6ZTbav3ETf
	kuDhAIZF1RgMU+QVD5YZZHp9BgUzvlFAdSHQQVUl7R0CivamHrjQMFd2+9gjRVyL+MHEBhXZJM8
	BC+tTYV1ixIClXAlUUj+qjtN+SUD5f7IE9/v3bhip+aVA+rPzWUxQNOhAaqx2vxAjw9yMrfHdMO
	6W75nsxoKfGTecK+7wG29yWTjxqFkQ/WDRB7bjnkfdpFcB85MvEOT5fGHK5AXl2iRlzF4TqwcJf
	VU0npXwLuHtNdv/BAM9zVsvurmAfnWTeYp4N4M5QhVBGOxZZlXKEdKJDdfGtqUVsYwqJG5+M5n0
	erSiPN0irgPA9YTmQI1ny3DWDgUxlF3fvQHOfePCPMVU5RbbNk4RE=
X-Received: by 2002:a17:903:943:b0:2b0:b258:2a57 with SMTP id d9443c01a7336-2b0c4945e09mr4741085ad.27.1774505814466;
        Wed, 25 Mar 2026 23:16:54 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8bdfe5sm18201605ad.61.2026.03.25.23.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 23:16:54 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Thu, 26 Mar 2026 14:16:50 +0800
Message-ID: <20260326061650.20569-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325142920.87299-1-sj@kernel.org>
References: <20260325142920.87299-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD7F9C0006
X-Stat-Signature: agstwp5xxkmhf5ms65n19ubo3gozajqc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774505815-969780
X-HE-Meta: U2FsdGVkX19gH+Az6alATv88zv2xy5cLRarSAq0rjTC62rEz5Tf83PA853vG2vsn2ew8wfWVfb06X5Bd9grezaBC+dHM1vZIlIjGX6YG2/gfO+x/XMBZ0k+Bl9ghQSJomIfi1SkArsNkoLE2Diwvgx6MqvoVNRXSHK6UHcgqy60xpyRxwO3sv/ddYYbE212xy7IKSko0T7a6hKTZa8cn3SQbtgoYfH13ChO+970gEHrLEbns3S8edWXez24TC57Au2Fr1+fn0AO98S8EIAKElAJ7j0XTJ7GqSDS8iEQgUiCCWSiJz2MGDusYXlgDAGRfMJS+ItVMU2spzR2dnyNbdU8FisRrG2VAnD+spMuGpaB3gxKK7RBcldf+GLgr+P/UPCrOWFV5WpQIvxpSH4di3h4nRCDuZWBGcqe/gcI0xzfszsqQ1GEKBh1yiwOcrz7mk+yhfScSNnjyXFl8a/F10TZlXD+RiVpeVDnMzH/rfS/B8k3v5hSI0D1ge3Vc68ibwvXLihDxxLYp3FboAIBruJ2dOICgeN6FNebMy4IqtAvmsf0WymazFo1k2jLuyvHA5GKxc815jV4QAv7OVuTa+OCbyqSX4Gbo2olb8pU8Vq8bK26vheAqKBWQ7rMcN7EdV7uepuHQ0U8rU/Kckoxob94KEOVA2A7tzzzWbCKcuMwQAGwE85IhQmKyH47H7/19lwYXy6razkZNFLJn3IgP50Qzdk97Q/DM71kKixN3s3J/ZwzVQgJZXomjx2Js/Ytg6doTIAmPuBqvhyTYB1DL1oEVxzPeBhaB8tbQtQDK81/sg4hwnM+7pWg5VINn9Knsmk9B/CbqwJ7WWUT3jE+Xu8IUwUBCVChVVzmVM6NxdwlrkzqJTR2GuyyjmH91bnqRdCh/rmbzBVJfZ8W3/dw8CrSpa+ggqdp49/BLY/g5FKsUGAaOnHtencQtk4m0svfH5x2faIIK5Tiicq19Quj
 Ha4wFUQw
 FLWJ4+BDoesNOt2xETs5KDtYprsMU8yxECJaw2Y77IKuuTMHashCxLVB6Ov8SEETryE/mt6zQau43Sqv3AJgICTUoZsMQSHGaOr9ehLrV0E9uiuhiukxUt3PvGIRwsoix6K0dGi5OzoNzfrKRU6QQJm8QvxH+lOPZckKU6YBQH8ySJxFb6BWznPRuLabSju142Fd0ijM3/Uw9025KVr13roqP+APYf55JvgZes66nMVrzaE8w6SYiZm3VxOlW6gLK7AIV451mqcKGa6AckzJoB+qBgc/8DV8WgCDrZLMAFYTdjLm4rHZ+DR7HL8mmIfb6Ms76mvN3bqGddfglTtuFcI+/9LvnNYSOWQxQgQWsCqwlKsgL6V9bJpzWmE+yJTpWHooPSbX3RFkqmfhDRTPRW9HS6Od8/uVzPpJl9dR3/OH/AoP9F4M2PuslyCHPiYMoxd4IOuoZneMX4t93kT4vqDsX2G1101LXBtEFGvU4t9bIRpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 07:29:20 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 25 Mar 2026 09:39:39 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
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
> > Changes from RFC-v4:
> > - Rename the 'yes' variable in commit_inputs_store() to the more
> >   understandable 'commit_inputs_request'.
> > - Return -EBUSY instead of -EINVAL when 'commit_inputs' is triggered 
> >   while kdamond is not running.
> > - Link to RFC-v4: https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com
> > 
> > Changes from RFC-v3:
> > - Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
> >   pointer dereference during early boot. (Found by Sashiko.dev)
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
> > 
> > Changes from RFC-v1:
> > - Remove question from commit message area.
> > - Added synchronous validation for DAMON_RECLAIM.
> > - Rename damon_valid_attrs() -> damon_validate_attrs().
> > - Exported a new function damon_validate_attrs() and declared it in
> >   damon.h.
> > - Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com
> > 
> >  mm/damon/lru_sort.c | 54 +++++++++++++++++++++++++++++++++++++++------
> >  mm/damon/reclaim.c  | 54 +++++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 94 insertions(+), 14 deletions(-)
> > 
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d72976..a2410f648b51 100644
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
> > @@ -349,18 +348,59 @@ static int damon_lru_sort_apply_parameters(void)
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
> > +	bool commit_inputs_request;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.data = ctx,
> 
> You don't really use the data in the callback function.  Why don't you just
> unset it?

You are right, thank you for pointing this out. I will remove the
unnecessary assignment in the next version.

> > +		.repeat = false,
> > +	};
> >  
> > -	if (!commit_inputs)
> > +	err = kstrtobool(val, &commit_inputs_request);
> > +	if (err)
> > +		return err;
> > +
> > +	if (!commit_inputs_request)
> >  		return 0;
> >  
> > -	err = damon_lru_sort_apply_parameters();
> > -	commit_inputs = false;
> > -	return err;
> > +	/*
> > +	 * Skip damon_call() during early boot or when kdamond is
> > +	 * not running to avoid NULL pointer dereference.
> > +	 */
> > +	if (!ctx)
> > +		return -EBUSY;
> > +
> > +	err = damon_call(ctx, &control);
> > +	if (err) {
> > +		/*
> > +		 * If kdamond is not running, damon_call() returns -EINVAL.
> > +		 * Remap it to -EBUSY to better reflect that the operation
> > +		 * failed due to the current state of the system.
> > +		 */
> > +		if (err == -EINVAL && !damon_is_running(ctx))
> > +			return -EBUSY;
> 
> In my opinion, EINVAL is a better return value.  It was failed not because
> something is busy but just because DAMON is not running.  Committing something
> to DAMON while DAMON is not running seems invalid operation to me.

That makes sense. I will revert this to return -EINVAL when DAMON is not
running.

Best regards,
Rui Yan

