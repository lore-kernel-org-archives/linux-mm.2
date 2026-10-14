Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C57CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 12:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B38B6B0088; Wed, 14 Oct 2026 08:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3645E6B008A; Wed, 14 Oct 2026 08:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254106B008C; Wed, 14 Oct 2026 08:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01E3F6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:56:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63FC0160553
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:56:33 +0000 (UTC)
X-FDA: 85321230666.09.6FBFC68
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 936251C0008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:56:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NxeJfyaQ;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791982591;
	b=Wys+MvpdYoeCDJbBQUqwjaD8Ol7kFUVhtkVprmmDay7GlACgMSc+nKwnv9+nALF5OxY51f
	wA8KSk8pNAvWTamWa9ETKMkhOmbD94vJ9vF0ceo1vxWhoPYREKIe2WTFdN0nTEDyjd+nF/
	Ev0EuBFWOEhkNWFFQQ9NwMuXXdnjNCA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NxeJfyaQ;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791982591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfEQYJS10SzxUn0KjnMduakisOWn0z9unME6AqbuJxQ=;
	b=KB2s+SZ+VKGX5Dc4+WKAySJJOmZ+C8hD7oim/ckoPb787/y3vf2t+Waua0RVhUtXkyhLdA
	MAo5CadM2ShI4bRQymBEzPKClnxF3+Q60NGC8NB5ozQkl1RcwlYm0r7IPYW0pp4eC5BL+j
	M7pq5OOj71RjY1/hOtB2qgyf6+zxGRg=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-930c0f9c1b1so426786185a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791982591; x=1792587391; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CfEQYJS10SzxUn0KjnMduakisOWn0z9unME6AqbuJxQ=;
        b=NxeJfyaQG+Nne36Buin3Tcgzv1vqeHr/frjhxBxeBORH/82HBBe5utgjRWhP04Hq9N
         9/bsQJXFdeiqXo82zPWpOwMWQ46SNLOPI17CXKb9++Dypcckjg+r1Q/O/9AQjmyZwrar
         qnpYN/li/T7wMoqJ6u3sSPfDcx5vxX5HwkpFdKKYYoGOqZU/ceH0f1IIHiHQfxKbJ4to
         MPynDPbL9yVRHfZj7r3qxjWcsPD2gOycztrWYz+4r2dR3GVkYuiCYcFm0ubsfEby+w/V
         mQ9fEjqJWdVeeEp+eM6QjvbAELMTIxHF17U51Ooa+T8TMMb18H3OeI3sh7dzJe4QiC1n
         9few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791982591; x=1792587391;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CfEQYJS10SzxUn0KjnMduakisOWn0z9unME6AqbuJxQ=;
        b=vsWqoTmBVbpBGH/s2un/eEdtvE/PcLcOERP80ad6JfAlia3s8QKxuuR9eyhK8W7ziM
         pqgK4xUEndwBYikjOkvPWf2or8MDnkJ+n1WxNUdVhfL6nIci/X90q97OoWnu4DfBDuOB
         xpDLhcirwmGrGe6N7D+BRDxiIQN/PUVo8ymQnIOFtzrTLXv/iFywPPmcICpZm6TbPLxV
         +jIm4e6GDJN8D+yizu3+60brk8mFeSxP8nkhH3pYnrX/+4CPH3WXxpMee+/YZdHoq5IF
         NWlN6o0gQ30UlT9US3Q9+iMoRm96FFW0D3IvWBFM+2he/dFCDPkLKcYAMiL1B1SLNXtN
         fkjA==
X-Forwarded-Encrypted: i=1; AKwUvBxZvzjtmYxi6ZJlnF//uWGYab7gjE2LNs4A4VpTVmni1ZeQ747ajofIEsNMPUWb68nZSveMo82kAg==@kvack.org
X-Gm-Message-State: AFq9FYKiXgqkz3wb6zR3MIA7eun/QQaqMX2VhFeKSZ4MVD330+/JbEmC
	UZC9Djz/A2GLBU59ViKg2PuyuS+++PJstVhJ6x4Bd9uyMyL45mMO5T4g+KyxzF8ZnAk=
X-Gm-Gg: AYBFou1gDzD/VZjYSqU6EJKE2aJOCzSQQD+w35gGYqFAjlQk1YnHcTNQ4c8EPQ4PYds
	W11Q3foK96mhB6P8mynpRhNkO5kuvEaFfplXgM2tlkqRmEWgG86x/7JbENc/iTBRA3o9tWjWBHk
	QRFusCwvNL/OV62neph7mByG4OctSF91MBOwYWDswmECIWhiuF7S/2RMC5O3qDpuCDpFTEX73PM
	jVNxYEVu39LRwex/u7UNf1ZCYIWj+ReU1vykntxtTOLeIRmVI1icXg1/ZJfOvWcOUk1vWhxGa7+
	eAb4ZYbB9XIPwFXrvBfrR1kd4WLKIgeqUTbpwSoBo7fI0lY/5BoTfXbeF1ucEtGnUaEII++qsNS
	tAfZMr2thQKt2U7+/66oZKKFFuDZ3mKxn8pnxkHSv5zq6DlX4ZJjREqneE9W8TriFktltB70Fzr
	UbBZr+N43aMf0g+s7VNeeKVsQ6/iji9LRML/HBHpGqoNcqj1XJRKZ35Jz7VyG063kHRsgIbCWma
	UJKnejiBXw7iasu4x63Q7dT7QhH8THUJknPPnJ7ROi5RumnFK+Nv+U=
X-Received: by 2002:a05:620a:601b:b0:939:a45b:76ee with SMTP id af79cd13be357-93ebd1dc726mr2616142685a.23.1791982590639;
        Wed, 14 Oct 2026 05:56:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50080b7sm483166685a.8.2026.10.14.05.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 05:56:30 -0700 (PDT)
Date: Wed, 14 Oct 2026 08:56:28 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] sched/numa: fix scan-period ratio denominator checks
Message-ID: <as97rD5uxYva4ayg@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-3-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-3-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 936251C0008
X-Stat-Signature: 97r9tfa3essmcbmbnmuwcu9938apfkh1
X-HE-Tag: 1791982591-337524
X-HE-Meta: U2FsdGVkX1+zyVMP04RrA8GgGiveZBdVYU30FmofHcvLizlkU8pc+/7mzk2y4XSzDXpJkAYKdwXZYwRDxKIHLytNUlOuEY25Udi0IcljTo1RaV76S26k+cMzgVHL/erJMgE0UiTamfQdRMe7JZY+nJn2Atb6/X79z19VgEr93nZ25aj43hJYoZ5jJA3ZscyEY5ei5MEFIllt0dh8BQENIS87K5KGqhburUhbFYsZ0OcOWmCCq9ka3jZEgYjk40zXDn1nLejiscVugXzeWFaMxvTtwcdn3Ndql8XImU6ZLuuXOTPb3V3TUcr+oSI1ByVgOGDePw/PJBvqnXWY1YGHgu34kuZma83ZVWJcmacw0zAz43sLaty9EwKy9GozCrEJ8ZNfMQJzJXQV7XPShl0C9JOJQ/Wny73WG6atf31UPye7O6SuBn92TIZQIAWeSPZVw73rfW7iyktSJ2OTDjsOZ/kqhFGqEv/XGGRwZ5EFctsYvz8V8dJRhbG+aCz3Pk7YnjV8e2hu3oe8z+HCgh3sAwpQOjdMnkisZZl7QUC3SSLEBCUwhSs1f7mzINz8MA5QteKDX0GhkXmVcppiXbZVNDbBG9UhxlnKGY3TAQGA4LleUMP6rrFn2+xYcPbZPpzp13mXTroIIjhMu5BtDjId3VNkMBL70MfFgYq2LN+02mIWiK07gaV4JjT7UDHMAzEU4jKySPQnljk+NXeuxAVxvbvTLgCtz8JfDCiNUGJO/fMa3bA/rmohAIVbxIqx5g1sQG4+Y+F44XXZ+ME7Y9Rr9PWnPTotpLoKDt1AWMEq+36Iz84GLXHedBiuiSZDQQmA83gRMlUlUwojqfni7FE9eQYMFMKlBIktrLa16QKul7opCJ17XON8OwtGNV1gToEtwTiSdzT2JlbLWsraJmQXmGMBCeL02Kfptss3OjdbxMxBfzLMOWo2pJZzpgnGSVFUzBKBt6QWWbfnK4vlK8l
 DtZsgLgA
 tcFRlAnluwk+Zbje2C28BSW1mhu83HPFDNgsjZJ9XyOl82/3zuiDvX4UKF+yMqm3bHYmPVM8fQkAUJ21FnXzSYSuxemipehYTXpRMEIUSkGIzRYOAR1P+/HCrZIu99VAkbdjmdot8bbW2L5++Y/IppyHaiUpmabnC77eCcfWOuM7ct9KAhqdUjdFLY2iWXKXMUPHMCN0FhOlOCCA+u23nUXYAZtBfi0GUilMqVgUCXjp7xOgXTxVJowXoZ7Cl5hqwKip1sKWy/hE8CNUKhornaXqTos9YCBwVdYZ6pkbsdlmKF5ZlGek6xrF8QeIZ12NjP7QhPkkVN4/DcGbZjeyLd5tlXVO8XouzjfnPIfCRlZJIuViapxndUgq7Z7mP717i4AMVk/q8r3fj5xX45pZRC5DTRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:43:43PM +0800, Li Zhe wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1053437933ee..76532b8202dc 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3698,6 +3698,8 @@ static void update_task_scan_period(struct task_struct *p,
>  
>  	unsigned long remote = p->numa_faults_locality[0];
>  	unsigned long local = p->numa_faults_locality[1];
> +	unsigned long locality_faults = local + remote;
> +	unsigned long type_faults = private + shared;
>  
>  	/*
>  	 * If there were no record hinting faults then either the task is
> @@ -3706,7 +3708,7 @@ static void update_task_scan_period(struct task_struct *p,
>  	 * migration then it implies we are migrating too quickly or the local
>  	 * node is overloaded. In either case, scan slower
>  	 */
> -	if (local + shared == 0 || p->numa_faults_locality[2]) {
> +	if (!locality_faults || !type_faults || p->numa_faults_locality[2]) {
>  		p->numa_scan_period = min(p->numa_scan_period_max,
>  			p->numa_scan_period << 1);
> 

This does more than just change the div/o below, it changes the behavior
of the function overall.  It's not clear to me this change is correct.

> @@ -3723,8 +3725,8 @@ static void update_task_scan_period(struct task_struct *p,
>  	 *	 >= NUMA_PERIOD_THRESHOLD scan period increases (scan slower)
>  	 */
>  	period_slot = DIV_ROUND_UP(p->numa_scan_period, NUMA_PERIOD_SLOTS);
> -	lr_ratio = (local * NUMA_PERIOD_SLOTS) / (local + remote);
> -	ps_ratio = (private * NUMA_PERIOD_SLOTS) / (private + shared);
> +	lr_ratio = (local * NUMA_PERIOD_SLOTS) / locality_faults;
> +	ps_ratio = (private * NUMA_PERIOD_SLOTS) / type_faults;
>  

This otherwise looks fine.

~Gregory

