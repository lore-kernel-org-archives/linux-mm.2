Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D660010F3DD9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 10:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0F66B008C; Sat, 28 Mar 2026 06:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8927C6B0095; Sat, 28 Mar 2026 06:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A84B6B0096; Sat, 28 Mar 2026 06:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6621F6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 06:51:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E74E4E1EA7
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:51:28 +0000 (UTC)
X-FDA: 84595155456.29.5CD4425
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 272EEC0007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:51:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="XxDEF/Tl";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774695087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6mIvddxM5IjpL3Qx7QZ8ftx4Ml3402nVTogMhOqdes=;
	b=jkQS2VvrbKeCfeWpP4/xQCxu1606hncLNy1mec2uvahZYxgRFCpVQm3JrLuoagu/DaTshG
	gXzPihUESP87mHMC/ZGLLwjtxduVq7YaekFrBh4RiAfAm270oCjSobkvZmMMUop7HgPKRx
	LJn/lMRiLSSXSmoDk4UbTOkIl3cAYVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774695087; a=rsa-sha256;
	cv=none;
	b=NvmPfDuPmbkfrCTtljjtDSHNJeZB8B03mWLGNnR61AkIHINUi85BiY8hFaBdVvRNoJBsMR
	1GMesKnIrcE94l548NA9CB8bxXQnZxb4GrGMQpUSg6dMV24agsgxIWtXzeOmLwdIYfKPHZ
	6tJ+wzUp8HVnS/TT3niztUCh97MsomU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="XxDEF/Tl";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cbc593a67aso320376085a.2
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774695086; x=1775299886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6mIvddxM5IjpL3Qx7QZ8ftx4Ml3402nVTogMhOqdes=;
        b=XxDEF/Tl1OxXkRS39KxzuyFmmLYPup/k0DOivjS6VgCCUwnibRr3w/dcSCkQnRek0u
         1Njo8PERqBhu1UCykMVhbKWkNEYd3mq3t1/X8Jg0USAKzGa2X7NMIdqr01mdbSI6QFah
         freML/eBW0fFaNSDDicdAn/iLbI1UpX/SsjupEcpk+ABBAbNa1zTQ56rebnBf28xE486
         sN7WwxxmruBay/0061CMlvcPKGIey8PamDqSDWIYQSfE+bQu7to4zX6EdJdvYnge87Uk
         mXA/jbdWh1xFBtN96ILpRZrbXXIIMHqfYPn5CNbC3TMsZ0h9MZ82G3KTOI/WmKbpYpme
         oZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774695086; x=1775299886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v6mIvddxM5IjpL3Qx7QZ8ftx4Ml3402nVTogMhOqdes=;
        b=dFaSD23b3dr6sftHK93y+VPQbE4QJEvHoBa9nAePPPGWSwhOVymUnmBoPlZW4BeZ1a
         y1gUVlX7YsXNntZOarC6BaOJLotUJFtFjwcVhToPWuwOzw9k0fBS9mQzzzkXP2Nuh7X/
         7ndSZxC1ZKq0FZPuM0vEFAIAszmtpRpnW2SpNnUiPkzbfdOKibzYVgJZ//bTbFjxVYm/
         6KMdtBbKUzSLbo0K5vU3zbXKEn+1/VqBxAMK1YieBYowvtWPxtQ3vyBkSyec7LJV9i8e
         Doi5vQ4SDSwdbi6uqXjaRn2BnFvOIXgmed8X2YZMKf/5hWOBuTq6ksT6fnd4Vj6nUGCh
         sZSw==
X-Forwarded-Encrypted: i=1; AJvYcCUFGvX84/1+WAMJaCkRwvGbOJBhRz37oM1dDX6CHNXlT6QKzCWh0MSqPXCQdZhW8jplP7fngRcrVg==@kvack.org
X-Gm-Message-State: AOJu0YyDJnS68BtRDt/PeIrct+glKLXJK2acqkUiGk60YrCy4vx7LbT3
	G30vylaiE4Pm0yes2vj2dtjWEIR9mC7Cyyq0XUsJZTsKGRHVKdvbU0l3cGpz9Q==
X-Gm-Gg: ATEYQzyQw7hPqfyMlMEXcaecKBxiG02yb7aQZLaTzH1ti6P9cZ2zhAcbfBNliK3QkIu
	9pOxUSKGg8e6mOK/pKLGMplgNiT6mhFsxcbHhgyzAWSMqCXIgUwLqcSzrLgCDX0MsKKgVH9aEm6
	QdFrFrQntFrZwv+4CqR/abdzeJRGpPESbDjBefIOy9VK9ugApCL5Fl6xr7VHRiKaSGQVSWB6Sur
	B6Rljod1EEogDL+WWpM8ZryugndGDqnvHFYu2huwauABp+E7tb2u+g88b6TLM6YE5EVcVp6UbR2
	ka/u5L1QpMcBrkY/g3mbwlW54Y3siRrl2NUjyl2L0ExSp7XknjGCWbVV9RPyhqFIXjokRztVAc8
	tup/sM/hNaokxxB+oEKZIu6wD5Ku4x7KDC7ua5zOQC+t6Y/HLMn3dMe1scZNAkyDrxNwdyCBi3g
	ZCSLaTmrTw/i8A6WZ5uv9pPKY5O0c=
X-Received: by 2002:a17:90b:1850:b0:35b:b52d:f34d with SMTP id 98e67ed59e1d1-35c2ffaffdcmr6074190a91.5.1774694693018;
        Sat, 28 Mar 2026 03:44:53 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a82231sm10415940a91.6.2026.03.28.03.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 03:44:52 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon: add synchronous commit for commit_inputs
Date: Sat, 28 Mar 2026 18:44:50 +0800
Message-ID: <20260328104450.14719-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328093603.10052-1-aethernet65535@gmail.com>
References: <20260328093603.10052-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 272EEC0007
X-Stat-Signature: jjtpwmxaa84y1qfudxabotsjnh18egt7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774695086-955793
X-HE-Meta: U2FsdGVkX19xMfEXm5UFYNK0wfNND9U4OirZ+wM4mk+OlwHFy47SokOnLj/RQoM5jBfRADClbL2Sh9Zspsz9CS0sDrQWij934xuRSoefDfqFiUwld4WxdH4uXMf5HNZvwrjABSPWyJhZJ8IFLmmHpQGwZS4Tbnro9HtV8PwZAnY+NieWtXIV7trFLegsS1uWurXMad6WMJnG35kVaEe8KiFTzjKZXnUZEqVolws5MM/V6IxIFRIgEM0pAVzAuY2Sr2JOhbw/2k6Cto2T1bnvEyA+rI6XUtymZeNbNDSJTNXD1G2IBCgzbEGrYNjMUfNJ8Zv7zrvNAW6R+qwAutml0lS0InMLg2erIBMCxfLyMG4f6AGl9cb9eM4G6kQ385onR1f52hffORo8CMvbahi1XtE0ebjXOuQG1IxQlKfztVKqyyXGxtCmKPhNFhWk2O7LEW7QUavPhLkVziy0Nm8QLPpF2w75OwiYD91OdTBruCtdDHyPzqQtW1P1d+hk/aHreFdlsvXZRXM4mLhqoguD4b60Lx7z53aQZpERCOpEeyO8TFTNX4TO47wufNZ5sdskz7OqXqMPiVCdkxxUo5YKIiPtWxC8A1pPR3LbLBN5a/g8LjN9p8+o00EkOTVoV+0r67P5tReHZnZEI92lHm0fQRq/sNSoPt0/KoHnWxotcjYmuLg8GxAL8r4U6cmj8Nj9mq2Ircwv6JVdw7KvH1Ypx2wHvVea7S2MQJu5Tkgdlof1tVFuW2D1uMM6g6CWQSSblfi16y3FcY16tP+/n3RYGK+HPeJTvxbOJs6fVuoXIj7MnkItSi9HbfkigGqmaDAbiPHqFHHLkp/I4Ko1PBgHeiUzRQ1OWq8nOoufBgOmEbUPZ/uFIkGIqOVYVMDa8Gf8ZtN2NNXQRPlgyBzayVoA5Tkng8jmu9ei8a1rEQ/dT45yK7hWu3KMrBGFuRMgE6NcSb6+BTJYCj3vLp9JgQg
 1v6+zuc5
 65dU8mTEn8j7ddpq9WFE15hJdkpo9AW4PBlVAFAuaetgOnhXZyQdji4JttKCfcvp64ElBwKX+qWNfmQqabZ8Nrkru04t3kpXH2mlzL+8Ye7jYMdVi0XihYADY3MwlEPPw/RUoGhDFu1XfMsKcjok0FhgJ0NHBBpWIhitfmnbxtGAJl29QMH78gTTXupqB/9QvHmL1+vR2G1by4DKhDRQihXwoiCU0kvGVA67KCGJRDbqALcDjMb9MTNgBklfEWCRgLYhiVdZFvMZUcH0FWmQO2Yd+qp6axsoCHzKgJQFhm2kd6tn2M2zYRy/AL/4suq+2sNVkYUaY8JUhlLwe/PQOVjz/BzK6SuTLhv67Uz8+f09WSmmE0wdDeeXjv0xNwwALnmI6GvUg7+wvkqL7Ug/F1bwIH+LJgB7o7iOY+quzffk819UImyMVK87Ho6LpeEq4jQKezd/syOjQ9GZ7CweWZ80Lr2CaOiCPWhz4Y+rmXrK7h7Fz7TbkjLtcXS0tNCHYka1cd4Ih/sqCuGmB9VH8fsLK3EXu3fB3q5mQT29Ls6vXyOE0qerDUejeYIfwkE/ugLBfQwig/jVqBMTxszjN4BtkSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +	/*
> > +	* Skip damon_call() if ctx is not initialized to avoid
> > +	* NULL pointer dereference.
> > +	*/
> > +	if (!ctx)
> > +		return -EINVAL;
> 
> During kernel boot, start_kernel() uses parse_args() to evaluate the kernel
> command line. If damon_lru_sort.commit_inputs=Y is passed, parse_args()
> invokes this callback before the module init function runs, so ctx is NULL.
> 
> Since returning an error from parse_args() during boot causes it to skip
> parsing remaining arguments, does this regression break the system boot
> process by dropping after_dashes arguments intended for the init process?

This is a deliberate design choice. The 'commit_inputs' parameter is
intended to function as a synchronous trigger (like a button) while the
kdamond is running.

Regarding the concerns about setting 'commit_inputs=Y' when 'enabled=N'
(or during boot), I believe this is non-issue in practice. I plan to
provide an update to the admin-guide after this patch is merged to
clarify the proper usage sequence for users.

> > +
> > +	err = damon_call(ctx, &control);
> 
> Since this function acts as a module parameter .set callback, it is invoked
> by param_attr_store() with the global param_lock held.
> 
> Could this cause a system-wide deadlock of module operations? If a sysfs
> write occurs exactly during kdamond thread termination (when kdamond_fn()
> cancels pending calls but before ctx->kdamond is set to NULL under
> kdamond_lock), damon_is_running() can falsely return true. This would leave
> the sysfs thread waiting forever on wait_for_completion() while holding
> param_lock.

You are correct regarding the potential deadlock. But this is a known
issue, and SeongJae Park is already working on a fix [1].

> Additionally, prior to this patch, user scripts could configure parameters
> and write 'Y' to commit_inputs even if the monitor was disabled, and they
> would be applied when started.
> 
> Because damon_call() immediately returns -EINVAL if the kdamond thread is
> not currently running, will this regression break existing userspace
> configuration scripts that trigger a commit before enabling the monitor?

I understand your concern about backward compatibility. But providing a
'commit_inputs' request while the kdamond is not running, is technically
redundant. Since parameters are applied automatically at the next
'enabled=Y', the new -EINVAL response serves as clearer feedback for
userspace, ensuring that synchronous commits are only invoked when the
kdamond is actually running.

> > +
> > +	return err ? err : control.return_code;
> >  }
> >  
> > +static const struct kernel_param_ops commit_inputs_param_ops = {
> 
> The previous module_param(..., bool) macro used param_ops_bool, which
> includes the KERNEL_PARAM_OPS_FL_NOARG flag. This allows parameters to be
> provided as a standalone flag without an explicit value.
> 
> By omitting this flag here, does providing the parameter without an explicit
> value now produce a parsing error?

To be honest, I was not aware of the implications of omitting the NOARG
flag. It was not a deliberate choice on my part.

SeongJae, what are your thoughts on this? SHould we stick with the
explicit 'commit_inputs=Y' requirement for the new synchronous behavior,
or should we restore the NOARG compatibility?

> > +	.set = damon_lru_sort_commit_inputs_store,
> > +	.get = param_get_bool,
> > +};
> 
> The commit_inputs_store function parses the input into a local variable
> commit_inputs_request but never writes to the global commit_inputs variable.
> 
> Because param_get_bool reads the unmodified global commit_inputs variable,
> will sysfs reads of commit_inputs unconditionally return 'N'?

This is actually a design choice we discussed [2]. Since 'commit_inputs'
is now a synchronous trigger (or a "button") rather than a persistent
state, it doesn't necessarily need to store the 'Y' value.

> [ ... ]
> 
> (Note: The same regressions appear to exist in mm/damon/reclaim.c)

Thank you for your review. :>

[1] https://lore.kernel.org/20260327233319.3528-1-sj@kernel.org (Lastest
but may not the last fix)
[2] https://lore.kernel.org/20260323150544.81042-1-sj@kernel.org

Best regards,
Rui Yan

