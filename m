Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7829FCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29A86B0088; Thu, 11 Jun 2026 14:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD99B6B0005; Thu, 11 Jun 2026 14:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A946B0092; Thu, 11 Jun 2026 14:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A498F6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:11:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 718D91C3637
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:11:37 +0000 (UTC)
X-FDA: 84868424634.03.37226DE
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8EF6480003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:11:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VMKovCdF;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781201495;
	b=t9euCuecz30ruxw9BCQVdXQC+TdFkyaRwYNlxVmaynTMYl0aSugZAAQxOfhltRCEk7DXM1
	ZgXpKEjgf06mrB6ujbhIXtndEMcgbnlXM0ZOZ4lUPuzCl5JO2tKocTXhZsVJEpt00CgurC
	607MwoJA4JMtY5ZngO3mvTVb8ts3mhc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VMKovCdF;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781201495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOgajm4rEsS0uuxJzvMIbIsIc3zZLl8o5hVXXScM5mw=;
	b=iUOv2V7EgoLIa+wyNsEaDPd9AFkVMk8tRp6LJkCxJLFSOBE1JbMRXK8sAt0rMdNW03eBQc
	raEqJfSLCZIlPOKBqnOWPv0SenW9bZVjRPVIoD6v9g6D9hFHIuHLgZGJqGJlODjTVSGQYO
	PwqHiTP7tYNGfz4aemNVRrqIdM3D3cc=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-96395a59ff6so55291241.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781201494; x=1781806294; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOgajm4rEsS0uuxJzvMIbIsIc3zZLl8o5hVXXScM5mw=;
        b=VMKovCdFAEtkei3wmfH9k7vFL5Tg4G7zE3M7FpQ+8ns8UTEIAX2ipd9OEGuqJjbvug
         cyJ14CYUMt0TvhMFPsiSoGeLi+zuOZUmLibalZjzOl/Ki/iiljbuyKGj+2yOA7JbYdCR
         XqugI1cuTiJ8k4dsbqrHvqqobnMnjbA3k0i0yfvUvDBm+UzkxwYBs9ows0IM50DDhzpa
         8qh55KYAtmERZd4A5mM2PWSfZNQV8kYaDCcIrL4ey9dSESYbH+xYoZpVlVo7uPJvoQml
         E7tamOObzg/cRx6noLLZYoTzDSnKK/94gQx+DqIyFmz+PoEc81+WGqT/ouaqCwBDMy2w
         066Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781201494; x=1781806294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOgajm4rEsS0uuxJzvMIbIsIc3zZLl8o5hVXXScM5mw=;
        b=kRxpoZIlJBjLZswq96QUqfjCvFX4nQXE/ZdQj0rGZVKJbUQBYWnDj0OXQLwDRIopGN
         vmRuYhrVHX7Vm9GYLKtPSvF6eVHAT9nsXs8d+DEujVm7I6+3XHt9XVYRGmjEkAkm4wZM
         H7Ve9f+hyEXJb/Y9PzXsz/0NbgA4Gdpg9iMgmAL9IugDoOa/1s6a7uVOhA1N+FGSGdC2
         85KDzdK3UZixk4G3xwch6w7sDKRr4vcJ2x2YZ8pmIN3ix7sZ3M2heYknBSSD8dIpngr6
         YBI2hcO1x6etipLaHjqGAnfaNX4+RvOOg7fr1SbX4na4MSu95C03hDjybuZeWh9w0vpr
         OoQQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XV1Zzax/Tg30QJym61z9MpmqArTgRbsaYaD/Zl0JSYwf60kYW52Vk6vKYsh2vxa8i7zcDuWbZWQ==@kvack.org
X-Gm-Message-State: AOJu0YxV7CXsP1IRdlN3GDVtQP+2sUtH/nwroAMIe4XNxJdhe1POjo9l
	0yvxfquUcDwZRVM7RJ06C/X8YugoHLyP5rdPZnUFeWnjzVv3R+q0ZAq1T3V0+YWjdOM=
X-Gm-Gg: Acq92OH+01ZZhPCxr687jqbtluzbar8k93w1wa7Htzjfvg3ssU+/k2kFidgXG1KME6q
	3/3NbRwQvMDFheR3TJyH0t+PDUc4GrIEj3PQ/xPs+fs6BpKlRPMCiiQbVPMqxtUC2Mk5zbA4Aq/
	0JwcTB7oHXlEBC8YdZGV0fiBZkMrmvzbgd4i+d5Vlp92YNTZrd8e9NwOyNoW1NIhu1GwiyFjori
	+8XLV6CHeb929kHOmHnsSAvSvXOjEDHLpdGlh9UU1cJ3POeGSzkXMOPhr5W5ANdFPp5kWMtmOF1
	3pxBtq88sAT1fWFqw86freBFwTVDZZu9HAQsO+14cn5Pxn7wXwJIAOCmgNbrLrPFiYnZ4akeol2
	+wnz9Q2xtMQR/umYDbO83OyDSRtV6GmWC1QPA5cyPgreKdi3/vmgcckjRvVtq7570YdJ5QDbCq+
	1dmXBv9YoObLPZBaMsxxKGFcN7X6OCJTQfdLxSUeFeX0LOWbFv7jU=
X-Received: by 2002:a05:6102:5693:b0:6f0:3c5c:6ad with SMTP id ada2fe7eead31-71d5f2c31e9mr2569788137.21.1781201494610;
        Thu, 11 Jun 2026 11:11:34 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d301c237e8sm562906d6.17.2026.06.11.11.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 11:11:34 -0700 (PDT)
Date: Thu, 11 Jun 2026 18:11:33 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
Message-ID: <air6StonoQPyaTEP@plex>
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
X-Rspamd-Queue-Id: 8EF6480003
X-Stat-Signature: kmz9dxnc83yk1khq3ysj8gntzerdqqo8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781201495-882475
X-HE-Meta: U2FsdGVkX18iZvzrZoJdiFd26s3hCndY5DdIzBiG8bKPYYmOwrLaVaYEoLf0BKzREhGzaTevoNjkuLgbNrOtn7SNecfcWo0sLuCysi9lYASz16e7/9f2jNopTfB5h+G2xxWZOhKs17QLId3Cno4/N7cI5pxiyORd1urMlKVHj9CGm8XDGsd1TL9Xfa4Fr7Ws0TkHyd5NlEWbuCfBMhsZ3Zr8bsmfYY9sqsSJ+gBB7sPheLS9jhw5+9hor5oUTfyryAXt3Fw4UpJNKPxwguqsmYmBHLwRfuIXecNfbKT7yI7ALDR2mSblwgi0VSobYpObAfUK9H3QAmKcpESjD5EooG7K3Kx4WXkEgJQkPKrzf6m/LOEoI7uh0lQMuWOFwDxd8G+VWU6zqOTrQZ1augcZaf2JsGz058u7S2hF5MsgCSWMopWtzcG/dNtmH2dA0RMEcNEHXFmY2nXChpAOk1JJN4UJeW5eSb4+96EkSoJ7GDwQ9Wklnvx+11E31HqnmwZ1SW/54Y+mBtXjp86krQyBcvboi2vt/AGYE0H8Bgkyo75YzigZy7/WpBqg6SCfBsNWVVJ40pVtrC9sfT9SyCwMZutA19eNXkWffz0rBNXa42S6R7AmRNbsTz2KOvGUiTrrctptRC+7HRGmbcLjasYapaCTvCJgD4S4mzS8zqYO5mSpJ++0hVFrlz9YIZIuJtdmPApfGK66/gZ5VFrMTmki0vP2s+A6+7iCyFhCn2C/vGpiL3+ZD2QDhd2hOsnpJbKNpHnBPIq/s9eAFcxPBcQ0GmIvQFU/48LxH+ChsSPMdLTbjnS6LLqp2by6YNRkc9IjaxZhTxtm8SqmFqb+8fVcNIoGbnP8jIUGNfULYW9zUWzUUhZgHYD0v1loRlc1RHUURMeA9gMvJkoX9JwId6h32nPWrJBUobtN1FR8RNn22z3kmiLWfCHq3Nrx/cVqBgWBGFydG4kfxuejQSzW6Dx
 t1WKYZUv
 vKMGHvGzYu5sY/p40PWQadyeyBo9ldkxKPHd5VgFAwfI8b6rM9FAZmoS6kAzzQ3zoKHFEL4RgKuyleloy2B76By4/TYApki2fXKGT9JcHPorTEp62ZPpgRIYBJroHCXGLfNSIjjOjzw8CjeqvRrC0FKPOgRb9PLwk/tjzq0beC/+IAq3JINkdRn5Ph7khQ36pxx2Z+PKUwa9IwLET4BflRcz1eeW50d91vLjvXodkMB9YDfioiwtOm39zBsj+cqBTDm+AlkVGebzNntxLHt2LJgBMYNsBDurf0cqTFDA3dEqHCiGlugNAr9rsmx1KpKkvu4wbPPZZiilpNVQkALQ67g0S5FsT97c0gTZqOB+G3MH4lY71+s6jEF60yVZhbTmsTGkfd8BdcdD/S6Gp8hO6bzNR1vyxWRBVyZ66SwUjRZehuxduUGd/0x4yoxmvxAPijxyf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-11 10:30, Tarun Sahu wrote:
> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> on args->serialized_data before checking if the physical address is valid.
> Since physical address 0 does not map to virtual NULL (due to direct
> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> catching a missing serialized_data, leading to unsafe dereferences later.
> 
> Validate that args->serialized_data is non-zero before calling
> phys_to_virt().
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> ---
>  mm/memfd_luo.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 59de210bee5f..10f3983b0060 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  	if (args->retrieve_status)
>  		return;
>  
> -	ser = phys_to_virt(args->serialized_data);
> -	if (!ser)
> +	if (!args->serialized_data)
>  		return;
>  
> +	ser = phys_to_virt(args->serialized_data);
> +
>  	if (ser->nr_folios) {
>  		folios_ser = kho_restore_vmalloc(&ser->folios);
>  		if (!folios_ser)
> @@ -522,10 +523,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	struct file *file;
>  	int err;
>  
> -	ser = phys_to_virt(args->serialized_data);
> -	if (!ser)
> +	if (!args->serialized_data)
>  		return -EINVAL;
>  
> +	ser = phys_to_virt(args->serialized_data);
> +
>  	/* Make sure the file only has seals supported by this version. */
>  	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>  		err = -EOPNOTSUPP;
> 
> base-commit: 9716c086c8e8b141d35aa61f2e96a2e83de212a7
> -- 
> 2.54.0.1099.g489fc7bff1-goog
> 

