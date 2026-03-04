Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764DDEB7EB2
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAFEC6B0088; Wed,  4 Mar 2026 04:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B672E6B008C; Wed,  4 Mar 2026 04:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90016B0092; Wed,  4 Mar 2026 04:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96A566B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:27:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A367B9C09
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:27:05 +0000 (UTC)
X-FDA: 84507851610.14.A7A467F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 256AF4000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:27:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VlBgAzUM;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772616423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8twELACDM9U64paumVt23gtTPqKgol7vS8inY1FSiaU=;
	b=Q7/vayXtt7Gyq1W6Ir4ztReB/CW7PVYFn40Bi5eDFypY/QiYdX21Q6LlqkxqAd1os/mJeO
	a1VjczcqO/cp5PX+rlk7jIg0CtZtlYzyMi6VIUUFEYMVXkmvgoAsJZnJl+Lga7asZi5EXr
	kJX5gk4hBeO6BVJmjs/pvKi1Cuzk5tw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772616423; a=rsa-sha256;
	cv=none;
	b=wmge2uW7ijXbGobXV9t5O/I49clpHFkch2SsJ7DyWDud0tITe/E7O8uXvXqA8HdNlnl/Il
	MJPhtDBe468Njb+E10FbKZVqAgrLXg5SF+FU4XT1kYuVJZSc8EFe1cPXrsz3kEEOvG4wXO
	KbOR2LSum63fLyVcKawPfqQwj6FmJsU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VlBgAzUM;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48375f10628so44214675e9.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 01:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772616421; x=1773221221; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8twELACDM9U64paumVt23gtTPqKgol7vS8inY1FSiaU=;
        b=VlBgAzUMP3UqukYBHmG3Vu0S6SUBZoFHHR/HlC8ef67rqb5S1fZvAePk5/R8X7sAnh
         J7tcDBJMGCCwz/ejkFEOts716iI01ibTZ1Nyts/JuLDTubiM680ovmUhTDFIr0jVQbUr
         t/Xs0uJcRlDzNGerjZvT46TM4yxfFSLd1x9og+Dt+kHBDR9CgKg48pMWZ+5bt0bdtAT4
         eSFUTEsm/5Q1KdoG+rqJtWONPi2jrVrtl/j2YWS6x2ms4o/Bm2/wLB4FfcFljjOINPUY
         fvzlpczP0oPLpxgd6dqsjc2FONX7eHb48hRBFbWT6rEWUrt+JMxsSmCCQeT13wmgxODP
         mycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772616421; x=1773221221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8twELACDM9U64paumVt23gtTPqKgol7vS8inY1FSiaU=;
        b=jnIBdIseml88WUNkwWIhYeGIt5bhJBzIdJZ+RCXMp+d7wOzos5sYNvmfq6pLQ+PxPd
         x9bsFeil/8Vr4OSrYs00PirinpvcPeamBzX+dyV1mTwT+8jkoyYZKAxuuy+4lb3m0rYr
         9/xeaYUGN5dTDl3Wcz2+o32e0v4HxJSXUA2ouUTN1bFOB6JLTCku30Co4qAWDmaFxvnx
         YTcORrExRMkxeYhT+q9QR9BaqZuJSjojC4wHU/6uTHWihvr3wqfs34fQHpG0+PMjVxKi
         F4Ep7SLxvXsoJHob4qz1H3XJ0l7S/i9iOeECUiDjhtOXzI7cANaSmlHTM2VBn4fp5B39
         BWZA==
X-Forwarded-Encrypted: i=1; AJvYcCUrVXhxa5G7IMZ3b6VOeNl3kzT5KV3wQ25GZnM3SzKENH4ybheLKxrGI2moCIAeK6fNitqII4IFwA==@kvack.org
X-Gm-Message-State: AOJu0YziVRBy9c54FeNE8Txbz0Rly5Liv1cA65aoXZ45tlxqdRz0NWam
	OzAr234h/bChGdvLIp+2CpMqjgAs1FJ+g0JWxeOmCaj2LJCgcVi6HXHPHYWeh822ZGQ=
X-Gm-Gg: ATEYQzxGP6TvZi/7CgnYHl60JcB/zUGciADDAgnnnH4HlJ3CZLXMTrcd5UtJU+YSfcu
	kkMkJ8l3rw4NzNNn30YHHcYSjXXQj2F5eXehNZkx9tsCU4JEnWnXULDAU9/92AoXWIiM+VecvKS
	7jQKHWy3Q/uicm8y+hnbRaCHHKQ844541/01mLSI75wfm2sjXsWwxjLm7ERNVrZuNmq0UOZWVaI
	tGrtp0MrFpO46YEqgv2eFwgrXtRLUaoXS1DqSIS4O4c//R+zBUTyGq2Xhww0mLEQ6hkb2GYE9Kz
	7hJVBREVLztGnGMFGQThIukw4cFhM3cAySsqxTopl0Nrei8axAYTApHhpDfgSbSyloMZhkIuv/K
	vRyymG1AWIj/3NuLbitrriksFf/P5NU1sMuWNw5DlQl70W4Ywmd3FDBkgAhEAJxUR2+cpgaAcHM
	uFMf0r9sbEbWnhvpiMUPx10D+qbbjeD5sQ7qsNTWHQaQ==
X-Received: by 2002:a05:600c:528e:b0:477:7f4a:44b4 with SMTP id 5b1f17b1804b1-48519828e36mr21546175e9.1.1772616421409;
        Wed, 04 Mar 2026 01:27:01 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ba2a58dasm17129264f8f.27.2026.03.04.01.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 01:27:01 -0800 (PST)
Date: Wed, 4 Mar 2026 10:27:00 +0100
From: Michal Hocko <mhocko@suse.com>
To: maximilianpezzullo@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Terry M <terrym3201@bugzilla.kernel.org>
Subject: Re: [PATCH] mm/vmstat: reject zero vm.stat_interval to prevent
 busy-loop
Message-ID: <aaf65GSNmBs-01uf@tiehlicka>
References: <20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15@gmail.com>
X-Stat-Signature: idn87t438hst7cn9khnoergh3g886jcw
X-Rspam-User: 
X-Rspamd-Queue-Id: 256AF4000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772616422-439686
X-HE-Meta: U2FsdGVkX1/aHjprrt/j4o9/FYv94/5uL4bicUL1LY6aEf9ZLkFTYbTAHnHJDvEQq7kVicGTcSoiS5F/YHey72yIOaWUxSHj0H7FT0352lk/pl7NTBCx0mQ7fI7HAUFq3fPG+7AGW+Q0MpxAtNK0BmOEIlmZUmS2g8+fQgfamW6mBpDPLYh+J9jxotEyvtS+3TJcw+x1pwujfox8xhGF/mazp9QVxaXzqfpW0mM87MzDAGlWcWJrNFutwt8kV0l7KC4WnU2RHzLqTGbcNIa4UsC3sVQTVk9rqaJ7/G7V9xT53hHCdoaKFhVBplJECLruJ//lsdu71lvsv8vktA+MJiNLVHwxU+liIX89SfZPY9ZEKjvITN00kqHqA6XJQUxuG0XB21uP3++MdRpApu0zfAgnf+TXrQZjIdhKFoa7VxD+95zsPpgewa9N4rTP2As4etnRRaHmFEV+HQL7jnClcDTp7ydaeQ/Bb/a/pbRN1gyy+Hb/88EC1lda5ietgU0jWTrqqE8MwGiayuM7Z+5Lsg3WUjkuDkO5YESIMhrhsCuPTVa6sjq0+l6lVZEmkqR82a/3StcdOThS9dN3cDEdaME9cqy3UinUiAeiBw6edzh6PdZQDPvp4hJJIb/AYe/aArD4K3oZkkiu2cry2XwYUauRS+sbbk17xcHhUDriiLjl+9MFBvCQGB5E8KKvoe1+1SHlplgiqabz42uA/E7gMhQ/vLLW7zdwt5VUE+LQ8BMdlklSunaJySDzVIesNOStBzvj361Vmsz/GmRcyWapKe/ao40WkSumbeKiLend/AInVZYGi7YDe0Ezi6Kp4Rdx4rwCUEBQfxVIDBK9yDw4a6xAj3ggMLhfxhY+z8h1pZAud8mPvoeVTHae5BUC6brGotpD4ZRBbzb+ebUakfKaVxHV/C/51+Zqxb74Ij8HZ9UEQx5R0gM4UW9MtnMi6M0tYDeJC20X1fd0fnzmmPm
 PDL2qYkQ
 cmhLYQgK6JvVupcDfzO+0SX23Cez6RXlYidqvBU293zW0qc1yb+dQiBE5fZ1EMM2MDL/DdjOr3luJa8I6SIq2jcZ2foLV7Cz9ywAwfSQl3Dq0LrehA1C7je9N4Ms1pUvgpI2zJb/kIH+CC/tgIyiqWbT4oaGbHMva7CeognbjWKsO8N3Tw5MD0itjEPNsFYYUcHtszlEB5/HeTvXW7ltajCrWJJn53V0WDr5aJGN/1gkJO5Y99fMBuR4PiGAY1H0BR8snimJyGumnFzbo5Hwos777iHfZ2c5u41P/L5wFjH8M9hgFpHLU8zl5g1CEmseQbG5UniK7z2Qwh/bigRVmwzcHBFYg4FUpWWzAzQXkYb/Rm+I3cbtvbBreJ+fJgu1T5OycIcieI8omoh7uSrLH/gwv+zVP9Al1gVijKMPOtrnTk8HQZg1sfXYY7h5OC7y+shLm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 08:27:38, Maximilian Pezzullo via B4 Relay wrote:
> From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
> 
> Setting vm.stat_interval to 0 causes excessive kworker CPU usage
> because vmstat_shepherd() and vmstat_update() reschedule themselves
> with round_jiffies_relative(0), which resolves to an immediate
> reschedule and creates a busy-loop.
> 
> Add a custom sysctl handler that rejects 0 and restores the previous
> value, similar to how dirtytime_interval_handler() handles
> vm.dirtytime_expire_seconds.
> 
> Reported-by: Terry M <terrym3201@bugzilla.kernel.org>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220226
> Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
> ---
>  mm/vmstat.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 86b14b0f77b5..6eeb4341b215 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2114,6 +2114,18 @@ void vmstat_flush_workqueue(void)
>  	flush_workqueue(mm_percpu_wq);
>  }
>  
> +static int vmstat_interval_handler(const struct ctl_table *table, int write,
> +				    void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int ret = proc_dointvec_jiffies(table, write, buffer, lenp, ppos);
> +
> +	if (ret == 0 && write && sysctl_stat_interval == 0) {
> +		sysctl_stat_interval = HZ;
> +		return -EINVAL;

So you update the value and report the failure. Nope, this is not
correct way to handle that. Either tou check the value and fail before
any side effects or you correct the value, report that to the log and
return success.

I would preffer to not do that at all. Setting any arbitrary small value
will have some side effects. This is admin only interface and we expect
those do know what they are doing.

NAK to the patch
-- 
Michal Hocko
SUSE Labs

