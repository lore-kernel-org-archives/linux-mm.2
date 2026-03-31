Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075AF10F92E3
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9236B008C; Tue, 31 Mar 2026 12:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E897A6B0095; Tue, 31 Mar 2026 12:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FDD6B0096; Tue, 31 Mar 2026 12:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C94816B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:10:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 756DD1602DC
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:00 +0000 (UTC)
X-FDA: 84606844560.27.66CA964
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9880B20004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:09:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f7OzcLhC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774973398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZGr9JAVPYs6bX/G9eK9B/dVw1nLkQ6GSmMoSIH+BAk=;
	b=aqGy96W5uNBFDXhhK3WpX89QCvQYqWFYxMiiG8CqQMbZnqY+QP7dJuTA9DzyAr15ji9Pjw
	5ptjqjRMJqVRGd0jyc83mwxEqCs7LsdmT65KGz4l/78DnNE677HEQ/OiqalfevpfI/GOF+
	oRsEDOqNTfD6gWqcjlIsQ8DHgy/Ubc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774973398; a=rsa-sha256;
	cv=none;
	b=2/FGGJ+rEPu/zzZoGXpYJsRWW4Em8CyEYE2nygjzZeRJyfnWXDRYdCuvQZEYJIcSVL0eVj
	6+LLXj5PUUTvHr7qoaQO3X7KturS6hPLPjoELhIiuzhbF57TZNfOPhGOXcQdMU7X1zLe7i
	WtgAaPtOeuMComY2gSWYOiTXK7wTWBA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f7OzcLhC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b0c8362d93so34790485ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774973397; x=1775578197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gZGr9JAVPYs6bX/G9eK9B/dVw1nLkQ6GSmMoSIH+BAk=;
        b=f7OzcLhCYUJ6mwjsTdTiR+OqWjCeIQG1i0ZNdWe/SPylm+VO9yg0CqAt1BPSTtNbTc
         loFVoLPT1gvEWoVamSTrxuw79eHQjjZo5HlD5ZlEU8USNUL9glnK6J7kzVVO1IbdM9P9
         tOFAtU5s9p0XVAmdwLxp03zhLLRG1DU1bN+kH0iGRaoj7616obVbbVG494T4oQZHu2LK
         bagXZ56bTgmkvQI4kXD9HAlbCn9TpnKEPJrEi+BgaWY47fSBbm8XVBk/i/QJls50i6Bf
         eihpMqXxvN0tmXbw3ZnK4OGsSS1+Fe9kPOsiZrtv0w9hJ+IAJcxH6OEo7OaaYL/iN9UW
         S/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774973397; x=1775578197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gZGr9JAVPYs6bX/G9eK9B/dVw1nLkQ6GSmMoSIH+BAk=;
        b=Oqa8qN7ewUb0MLR2NQqARbHb0HqC1WRtOiAnbjk6GrDvuuMZaLImUpK9AgDIu7PcVS
         F4SiRbDEv1uwXNmkRFB7qKHjSbrKDIFwRiLJkdwWyFEgTnXe1SgNdB6rWAIwnAcF2ubN
         xdwEV7V+HblqlGbCesRZh1Id/tFfHGhW4TdvuNcqLSEYGX3EwTp1/ITIj7LbAiDzF+xE
         lFZ+Z9mzQZ6+qcMXXT+/8wJFcGuZWNt9zFC5OTNsCjO8bTnGtDR6fYHYElbgY5ygdJw5
         sRBL2QWtghgkt2L+Yn3nZMwXgZTv0LV8y+zfBofAgmTgQZo6+mP5t6L6azIihJskX/yK
         9Yjw==
X-Forwarded-Encrypted: i=1; AJvYcCU0i+/aBreew9ET+WHoUn7c3lbw/KUixTbuoyj8Luh3IHSHfsXOZR61LpBiXUxiFf11G5zb3j22Yw==@kvack.org
X-Gm-Message-State: AOJu0Yz3hMOHwTqyXp5K3V+nx/EFq0Hhel1ysLLK+/MZl5yduZ+1utcj
	JkghB0kRhfprGC/GSH7Fh0zC3XaHq9uNL2h4QhASEyIYdqqP1AITc5rF
X-Gm-Gg: ATEYQzxU4CvZea2sBfKPb5Si3xvVRc3Fq6hXS4W/WaZ/BDXmlOTE47XChJ6cPhHQB97
	H7gOcyuRJkKsdsY7xiEjBLt8RTX+tOJmZt/wYNRYMqBVPo5nybJr3cw5QnQrlaJ7B5fj1rtUJsc
	ohC23NTJo1kb30ECYDY5q7Ze/adfMzn/k0klM0lo7Jm/HQEJv0hke2WH3HuljQcT681w/XyEXD2
	ZqMuCX0coNO95T6HSs8rHXA78LZL7bJ7PepxwU51uj/9JjmSxtij+WjlYHu6g48Wjnmyk4cR8Xu
	viamo97pP6fpNv2vBvlPgx+JFjuva8CcrYR86pe/eXA0dDQFx4x550wy9aFvalexkjloT7h15xX
	D0+MtrjJht5wJ5l2wj7Ljt/H9KnnOhRRKtj1HRz3RC9RyLZoTdQnsPU3dMyIo8K4I1r1rv47Otw
	/xWIex2/ZxTNQCiBwZaXRLapW2nBuHtblsvKFEhVIKeTArqcoKtlg=
X-Received: by 2002:a17:903:228e:b0:2ae:5163:c2aa with SMTP id d9443c01a7336-2b0cdc28166mr162032785ad.20.1774973397201;
        Tue, 31 Mar 2026 09:09:57 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427c6a50sm119809455ad.83.2026.03.31.09.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 09:09:56 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed,  1 Apr 2026 00:09:56 +0800
Message-ID: <20260331160956.16312-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331065836.4364-1-aethernet65535@gmail.com>
References: <20260331065836.4364-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9880B20004
X-Stat-Signature: wjkwt51qyxzuwxjebtca4ifyq9kb6rc3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774973398-885057
X-HE-Meta: U2FsdGVkX1/LbI5Ur+sqbXHKROAsjNkHOBohgSHRV86OWyKIyM8jQdWhXb1vnOH6gpwCMWZtaavRKs56DeYHYreFHNeeKN0YGTefgGq/ynxACZPiElUqbRjUAseWNVZJG9ycyKkhHe9uHJV1p/1mdvN7+3e2FRfPZyh9R1mmuP0HiRAXnKZ1sjBv5mPumUJ0ErpEV/CGk+SCuWoUGEVhRNWoy+qvBbjZcQnaUqehHrFnEhgRObG75sE37yDeo+gLmu6TjFBQsnsL2iZr25oO4fsIFt2jdWxqO0DSY6obb1iRY1WEyoR/ThebL4UjpRbuF1rtKyf1xeK/3R40XmKyBEBshsX8fr2wHbOBiMmL8btdUT28J5qdNvQj/JeUSOHWr5K9o6SZL20H2BypP5nr1iVFF+lFIIYBooz2dqywfh7Lhb9DiBDN4+VScdPvlleU3Vz7E5AXGVb+AcIxLVf/JdZddoBxu8UF8mxinROiGEx+dAQJDmcgSqZEspxCj7q1Ydgp2PRbipQtZ+wNIQIgR0Se0BN0I5SDzGinYKiXb2LvRxaf0WFg32LUSGKYarxSkvJynad4BSAvuEytmtVg8UaqJAWtB6ayVJiJ5M74UZ4t2fL7YzjhPAYvW7flwkgqvnxpcj0+wE76FDIj/InVNGXDOUubVagABa/feV9zTekwQZQ6YBuYgEmKzOAfYLtKXuQYV61ZiJ97CM9C0nFbdBv//lQj1e9jLmQsVnL1b/MYJy1MU4coSWIYOIG0ad/QWqPI64Dip/kktbePHurSss77KJxJkQ086I8nnUzLX+Edz3N4h4B+/4U73wvvuFAch1+NiqkeeXsDhCfAIlcEJR4bMmyGtLjGRk/0fXC30ZgooWYF3LfQHcA+fFoWr4AwgyMxadopmEYCZi+vECF+DnJYrML13gZZ0IIZUy2nXBVjF41XJ6OiM5i0HMJwPD3WU/Ceek4jp+7gvLlY+SY
 WCGw1ktJ
 MqzTKM0ndtSIsjk6vwNuJ2EGuGbJiNKDGecsXsj+YeT9ZCFF4yUrcXuafVg36vQBAHl2bQhS75PBzF7EsK4Evi5Y8aGs3Nzzqq0XqsQbOb98S+V5pQhAO6LkooPlIfmXojfsmOYtLi511aAeP4CwEHh6W0TBp/oRBvXqIBr6wq3NgLlog6JuZzaBJmWAXl/7QeThjMhE36axnTYtsFmjHeYQxoyMPxlIqd/fFVTyROgbB6fz8Yeft4AGEK1NaYzN9l7M/NbpI3PR/net7DvwCRuF/PwjuUqO/TGOnxXV7I/2bgfiRRPW2WWfrkOpwfMcIxVAKxlnI62GewQp4CFk2Rxbl8Fiadc/uzr/UZ14wLn39K8AfcBTkHluQ6I7DHwVbey13ACs117pN34h+g9FZiRsk0l68cu9UgSjT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Tue, 31 Mar 2026 14:58:36 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> [...]
> Option 1: Introduce a generic termination callback
> ==================================================
> Add 'void *after_terminate_fn(void*)' and 'void *after_terminate_data'
> to 'struct damon_ctx' or 'struct damon_operations'. While this extends
> the Core API, it provides a clean notification mechanism. When kdamond
> exits for any reason, the module can perform its own cleanup (e.g.,
> resetting 'enabled' and 'kdamond_pid') within its own callback. This
> keeps the core logic decoupled from module parameters.
> 
> Option 2: On-demand state correction in the module
> ==================================================
> In damon_{lru_sort, reclaim}_enabled_store(), if damon_stop() fails, we
> check is_kdamond_running(). If the kdamond is found to be terminated, we
> forcibly reset 'enabled' and 'kdamond_pid'.
> 
> My perspective
> --------------
> I personally prefer OPTION-1 because it ensures the sysfs state in
> synchronized actively.
> 
> OPTION-2 is simpler and avoids API changes, but it's a "passive" fix
> that only triggers when user atttempts a write operation. User might
> still see inconsistent value until they try to interact with the module.
> [...]

To avoid over-complicating the Core API (Option 1 or current approach),
I've implemented a lightweight, on-demand synchronization mechanism in
the module layer.

By overriding the '.get' operator of the 'enabled' parameter, we can
detect if kdamond has terminated and reset the module-level state right
before the user reads them.

Since sysfs parameter access is protected by 'kernel_param_lock', this
approach is race-free and keeps the DAMON core decoupling intact.

Core Implementation:

	if (enabled && !damon_is_running(ctx)) {
		enabled = false;
		kdamond_pid = -1;
	}

	return param_get_bool(buffer, kp);

Test Log:

    # cd /sys/module/damon_lru_sort/parameters/
    # echo Y > enabled 
    # echo 3 > addr_unit 
    # echo Y > commit_inputs 
    # cat enabled 
    N
    # cat kdamond_pid 
    -1

I think this approach is better than my previous OPTION-1 and OPTION-2.
Does this looks good to you?

Best regards,
Rui Yan

