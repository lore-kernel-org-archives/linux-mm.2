Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AD610BA421
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 09:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA016B008C; Sat, 28 Mar 2026 05:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A256B0095; Sat, 28 Mar 2026 05:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8DF6B0096; Sat, 28 Mar 2026 05:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE7E56B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:36:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B8E4141499
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:36:08 +0000 (UTC)
X-FDA: 84594965616.01.9CF70E0
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D5BC1C0005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:36:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fQ4brK6L;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fQ4brK6L;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774690566; a=rsa-sha256;
	cv=none;
	b=K616RadTey4+agtYnNOUA02qgAaeRUqha9VTJk1Falzd9LEeYRcZf6i5jh574AgrDK1Tnm
	li30cWzWB0GeTHLb3gU3LjOKW4TCBH9813Z/At9jMWdlTduwSiPwFitnaLP9W9Cf+w3GjJ
	3xKpaAr/wH563SeGMvOCmEcrxQkDJ3s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774690566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0tXXkVj9kz6CKSAsrdagep4arIWjfRejhsyyWUGg9E=;
	b=0nxANMSyg1zXaRDT/OBx+8qJOXriEFYDdZ9AIdbJTieIH1OvtkeRWsNAtuXVPbf81wSM2c
	N3+1DOAHcwgjioH9BgmM2N2+YP7IRLC6hJkRt2tq23tvdA4d5YGGCP9LwrxheCs+VkZ+4I
	w7D7qyPCmiL1LS7BhitSvUsS0v1g6fs=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c766a95a72dso1961947a12.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774690565; x=1775295365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0tXXkVj9kz6CKSAsrdagep4arIWjfRejhsyyWUGg9E=;
        b=fQ4brK6L1pE2t00okXIsT8kNip/L5npXOb4Dz5BYJiOoUSFDbHKyhWTcNvV+Ca6wlo
         NUMpaNpGwgsO0SIkGW2C7WTBOqW1u+qqHrJnfQRkTXOX6GnIsupAxDbEvwT7vgZ/5f/g
         IodzVL9pvFP9mwQkhrn0i9nJR2wA6S+Z0x9Pq05JLydpbelPORUnstK2MTIjE6FMmuVX
         b/jq9Zhzsy6N1CwxM0U7HRy4SnThxRbq3VdHgBRu/RJzR8pwFHjud5S4DAWDSyceqJcv
         C7mjsYPl9FinhePp4kvnmQSFRf3JnGDjQ0ZWBI1/YYMLNL7wYtL3bFeonsGmJU1UDjVc
         vbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774690565; x=1775295365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q0tXXkVj9kz6CKSAsrdagep4arIWjfRejhsyyWUGg9E=;
        b=osLDiVGVBAm3h+jKJbVgqdHFZ6o+F8Q6NeUmn8aIWl0thIAevXT1jBkHi5EPheu1Dt
         Mcx+YK7swSArUR0AH2miycZocdoFdH1O4ZEQg8OHp70xFRUfca7wEb74hHtCZt/eXeWV
         Sbb1Fc2WPtIxzI9WIsxp4pFBHE49mGOfykzK4GKSZP5ptJtyQGV/gTB1Pn087J7/kCsL
         Nb0heI55ZfAJe5OmyWM0jT0U/X58iGhm/TbaZWU6tac9lEWu56E8EHOc88SaMpVOstUB
         RwtLTzAYykDJ2PkISmwwKZPGAO2/bGDqP0eYhUdfnYL3DSWV2ixPAP9urhZ7OrRFzJNz
         jNow==
X-Forwarded-Encrypted: i=1; AJvYcCUzGLV+auSUmx8axMfJ4+obJ4uR223IaJ0+MtMHbnpz8CLNkBHZRezZZ57mFSxNJpeAch8L4LF5Jw==@kvack.org
X-Gm-Message-State: AOJu0YyyFMFaClFL58T0OhqfncMW42d9gV/ttSvkdBZhc7kQ8SBY8HgQ
	LjrrwMW0kAr7UMmu/v2Wway/kl4tFQR5IVRyEDZgjismEd4mCE1JgPrk
X-Gm-Gg: ATEYQzyGrfW0OOHLphyzaq501XEPsGIpJ3Ifn6T8EXJD+GsqmKPVklC4TSU5kqCpVBF
	S93o3krcE/i6jS1kU0YpJ9jE4TLC9cNpCpPNNQE+u4GR8b/lwl2WjTmLwEQuROCFIbR0tghHBz6
	D2tsZaUt5ESFKSgF22bJRsHVJ478ERp2ZzXNBImPwL1ycrjQg3T+qlP3PKwzbBFnFVJILHkp7Qq
	4mpIILlR8bKToQEcjq7HFaDHUlxRDz9A9+YX3EvTgVuYuqF1VZWsXzm9nqxFw47n1DDdhAjDPar
	gipef/68Hh1nRqn/ZcCdEHBu9Yk1k0iVzvoWT94a2RzzB+bTLmFdiZwj/cucY1qlxPnUJ0jpm8B
	Vw8rgDUY+Mn+mbigem7LvZjzHMiqs0QlV5W9USUk9ox++SeLqkcv8Sr5rj13V8t4qYMAFvfl+h2
	W2bSiBs565ntgpr9oQcf3xXBIpW2ieCKtzfhHQ6Q==
X-Received: by 2002:a05:6300:218e:b0:389:8f3f:50d0 with SMTP id adf61e73a8af0-39c87bd1042mr5399440637.60.1774690565116;
        Sat, 28 Mar 2026 02:36:05 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85fc735sm1550427b3a.40.2026.03.28.02.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 02:36:04 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon: add synchronous commit for commit_inputs
Date: Sat, 28 Mar 2026 17:36:03 +0800
Message-ID: <20260328093603.10052-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328084524.5451-1-aethernet65535@gmail.com>
References: <20260328084524.5451-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D5BC1C0005
X-Stat-Signature: xk5pdy17jmfxc8piztn8p7y7o9iomzdj
X-Rspam-User: 
X-HE-Tag: 1774690566-334081
X-HE-Meta: U2FsdGVkX19QGPuveVBRwWPZS5gvmFrKV7FXWZ5dCGXnXMZTsAFJXZhpYaPGlKkJW06TTcGQgsM2Pg0PESizE2Sv6N39nnS2snofCHvNAWL2rLnkrzkEjItmOXPRsvXOOIGFKW9BbjYGRmAubLaywgDNvv3sjYnY5f53rt4jcpg/jRFoNklHKUL0yIFividjUI/Ln61Oh4UymmNORho0kJTSu0tjfWpqqBkcNHohufrQBHghrTgVaHua1bjUS3hdzID26PnutkBNIsHOwzwSSQ+986VUJV0s3HHEpOLG5aOdM1x9bFrsqIPy2VeD4LYq2Ha4cCDqczcLGCfwrelg3Il8br80tCGpn7TKHu20/5Z2eor0yJFnFSDd89Qp57BW4a3jOnr0omx9b2AnWWx8nKXGCwNlofCTBa6v1d6nq4KuqJ0jrzUK4WfdJLSKDEx3WUI0bUMAASeHuhTvDV5Nt6lSq0yML6cf2I9S0nFUmCn3Gmq/++4zUWvqqGd0CKD7jqNBAvYkrR7IvNcmDa5jZcSXUt3/d1hYTmXzH+icVTi4JMehMSSEEXn2DiGCVGPfSGPcfoeVmag2GGg47AduQd7p/IzmJkyLbJvWcpQw8GfKiburySaG8gDZSPlJH89PjJZw8g5Q9JD4b3wSeW6pJArM5CxMFRCWfgrE+GWPT+9tIHtDbFF9WKt07hpWdKb7OVhVCOzc1BonYbxYQAFeWqrUUVkrwTDs/oxQNCnkCD3LmO8YSFsiegZQ5ZmIfYSK6kF8go/48+611vFow3ThkWk3ZPr4L7bhE7j1f41Dv5IY3woWsnE1/cpLRL6i/cJx0xqAnJZ34hMkNbXUV0Mn7NL5TpCH5OLb8e9w5jXV2SKiA1zFDNbF9AkRC20IgNlMzscyK/UTWpN8AhSwJTgxFO/qo6rvWLIfdyGa0NaTuK3t8kEHgkM6HVqL0YsiXJV/EEJcR11QE/yZNgXw0wg
 kFOuWAIb
 4geqKBa4pIJAo9f338g7Iv94r1Jp+iDrEqt1JF/eTgAyWuhnHj6UaVBiir77HWLGuPGOpaPxmkMO8W6PvOfoatQNxgYsB1qXa0IIt4HD3b8wuMaNbv99jfK5P36m9rRAsogWRNtnKaqpYvGXuVQJ37nRcSMNxP8RwgbsMTDGDReNwqLBDxEpb6AZJ7+eXLysYx5sOP9aFHQdnYlUSPErHgG9K4dPJ8pgJA69D0ps8sLU/g+RbUUCCH7ncRIq8VHvaPpjKbJWdjx5558+oZZ0mc0cqLPlUx2PhV8tVwtqxX9TmPIWSvs7tDRSCiT2Q+8cnwRsyvYdn6+jGGfECQ01BnUsqokrH1zyKdxEbzS0rCnf1idzOTM0/S9FY47CUMPp5ygztFL4OrISxuvAW2/STtPCLFH5+9mlMZQqJr/EZ8ojnClmgV2YeVD14walCDwCNTrw7SIKh6bbp58vLBl6YBC3ReZQiPEJMRM1ebeKseUkDadExV4OljM0P+PLD2Id7F59+Ff6/imiJVQC/mNSC9s/EZaEdwbRWlukhqDXNHDtzR8f/a7R5mDTqHAG5kE6oZtEWpmGN5HgYlza5cSCqyKrho5uyGQgudF4It8I1fZxVrLv66O4iNxjzo9X0gL08G8SfQ54hddjUHFMr7pR3iORu7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260328084524.5451-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 36139818bf6b2abe505ab824b951e904796bcd67
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon: add synchronous commit for commit_inputs

This patch modifies the commit_inputs sysfs parameter to synchronously apply
parameters using damon_call(). It adds custom module parameter callbacks to
return validation errors immediately to userspace.

Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..3af6854ba3da 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c

[ ... ]

> @@ -349,18 +348,46 @@ static int damon_lru_sort_apply_parameters(void)
>  	return err;
>  }
>  
> -static int damon_lru_sort_handle_commit_inputs(void)
> +static int damon_lru_sort_commit_inputs_fn(void *arg)
>  {
> +	return damon_lru_sort_apply_parameters();
> +}
> +
> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +					     const struct kernel_param *kp)
> +{
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +	};
>  
> -	if (!commit_inputs)
> +	err = kstrtobool(val, &commit_inputs_request);
> +	if (err)
> +		return err;
> +
> +	if (!commit_inputs_request)
>  		return 0;
>  
> -	err = damon_lru_sort_apply_parameters();
> -	commit_inputs = false;
> -	return err;
> +	/*
> +	* Skip damon_call() if ctx is not initialized to avoid
> +	* NULL pointer dereference.
> +	*/
> +	if (!ctx)
> +		return -EINVAL;

During kernel boot, start_kernel() uses parse_args() to evaluate the kernel
command line. If damon_lru_sort.commit_inputs=Y is passed, parse_args()
invokes this callback before the module init function runs, so ctx is NULL.

Since returning an error from parse_args() during boot causes it to skip
parsing remaining arguments, does this regression break the system boot
process by dropping after_dashes arguments intended for the init process?

> +
> +	err = damon_call(ctx, &control);

Since this function acts as a module parameter .set callback, it is invoked
by param_attr_store() with the global param_lock held.

Could this cause a system-wide deadlock of module operations? If a sysfs
write occurs exactly during kdamond thread termination (when kdamond_fn()
cancels pending calls but before ctx->kdamond is set to NULL under
kdamond_lock), damon_is_running() can falsely return true. This would leave
the sysfs thread waiting forever on wait_for_completion() while holding
param_lock.

Additionally, prior to this patch, user scripts could configure parameters
and write 'Y' to commit_inputs even if the monitor was disabled, and they
would be applied when started.

Because damon_call() immediately returns -EINVAL if the kdamond thread is
not currently running, will this regression break existing userspace
configuration scripts that trigger a commit before enabling the monitor?

> +
> +	return err ? err : control.return_code;
>  }
>  
> +static const struct kernel_param_ops commit_inputs_param_ops = {

The previous module_param(..., bool) macro used param_ops_bool, which
includes the KERNEL_PARAM_OPS_FL_NOARG flag. This allows parameters to be
provided as a standalone flag without an explicit value.

By omitting this flag here, does providing the parameter without an explicit
value now produce a parsing error?

> +	.set = damon_lru_sort_commit_inputs_store,
> +	.get = param_get_bool,
> +};

The commit_inputs_store function parses the input into a local variable
commit_inputs_request but never writes to the global commit_inputs variable.

Because param_get_bool reads the unmodified global commit_inputs variable,
will sysfs reads of commit_inputs unconditionally return 'N'?

[ ... ]

(Note: The same regressions appear to exist in mm/damon/reclaim.c)


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260328084524.5451-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260328084524.5451-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

