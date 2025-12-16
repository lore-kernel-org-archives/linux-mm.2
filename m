Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5F2D609A2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1396B008A; Tue, 16 Dec 2025 10:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082136B008C; Tue, 16 Dec 2025 10:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE416B0092; Tue, 16 Dec 2025 10:12:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD8C56B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:12:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3DF11A0423
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:59 +0000 (UTC)
X-FDA: 84225676878.09.4AA7959
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93AE840002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HCETSXKg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897977; a=rsa-sha256;
	cv=none;
	b=DzY4rSb9cOCFTX+2U9alStbgd6FRlgDbM2HJmhczAGrmCxCvhBwNC9OdFi2qDJKfiyTaEs
	/uetkuGJlIimjSXIcSetKEgSnR1orZm7hldR0UjIqGPsqTOKqHPgEe9jJZrwCcXOgXUQiM
	5wg9KuixKg2g0YulqsIVea6eW+wOli0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HCETSXKg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2RaB9SM+pvwUf1QmqN2DN92hZRXQJ2LlXiPVs66C+PM=;
	b=Tdqtmr6rT/vwM82xXoCMQQdDXjs1jiffxVumBYIakogpMprikMeaXQCTEPbcVOsHWLNN0b
	h04RWWGj0lyytgEeOWiInUP2E8PM9EKbB6AZDwCYWJB/Kta8Yzj0AR15+NkGKdH+PKPmTy
	dhMsfPxppKQZ3nvRVRbgQvku9NDbKHM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso30584545e9.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765897976; x=1766502776; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2RaB9SM+pvwUf1QmqN2DN92hZRXQJ2LlXiPVs66C+PM=;
        b=HCETSXKgy4S5Mzb0grt722ShTmhLTm6zG+MLj0Igz9PF4C0reT3XN7hlzkj/BuA5l/
         6wBC80bix+Jp839urqQtzpEJWwPSIfaLHUIEXrIfKK+WSFoumKudqTAU7/vzlAas5Bhk
         bFxm6+zI9eq0Q7Y87xvrVxA/uG6hJ02YG5cQ4q4H8SoW3iEWNHQTpo/b/ZHlYslcjQqe
         Y1BhkfGZXv1Akki3RAKX8pqVEJNz2z51xrIS7JP08DoW5W/7mUaDdpncoyh+PiXPkmFQ
         5Jub8L1hOOQhiWBORXeXK/gy/n+LU+eGR3FS9rYXnudPpkjJDNEGKVKErv/KEYqNhG4o
         ikvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765897976; x=1766502776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2RaB9SM+pvwUf1QmqN2DN92hZRXQJ2LlXiPVs66C+PM=;
        b=Z2ihMonRxo0oSF02ORi4gkNYTC7bJS4Xcl6gYncqRdim2YLsDXBC1JoAc/aaAQH383
         /7MjRT4AQ5B6GdAj74+9IZeC1FaSzA7Y1Tk3OZs6pWpDZrE4Ia1i2JUiieDVk20G775h
         js13U5t/U8LZUCEohDlcMMcMjNBPKQH9rq2kwEYprxAEDvNJu1cBZyXsMRkFAkyU9G/D
         aJwyQQDWeGwHB6BLDM/Z4RF5XQv+Nd0i1K1SogYwymro/Dnt8YdAOnKv5qeuxNfxiBdT
         5zNv4ZMr7p3xeDhIv4lLn+WZ2bqGQv9m2WZG01TJqEL4M06+gT/yo9qZpIYQR9q86au5
         ynJg==
X-Forwarded-Encrypted: i=1; AJvYcCV44GPNSh9SccZZs1b/RLZbfQBpcuwEwzq14YD2KCXaiY6v+i1w2RpsVAqGg+842Ypwt5dvVoUNHA==@kvack.org
X-Gm-Message-State: AOJu0YwLegPbdMY7xWHjA2842lVWyfRo/QC7LvZGqfr1qcYzRNWvZe0i
	WkaJZ1aZm7XiHaM22PqaISDk6MgSHv1OrnzUOCTv3MHlgt2J2EHodxQ0h6zwZx39UO0=
X-Gm-Gg: AY/fxX5PScaLyaXHpKxudenCTaPtCbmmUqLoCvEDbkmD3UIbvnBNHHyA+0upMFOuGED
	XZ0uY7nQjDM0y4yba5au4nEm4gFEVS7AgS+mI1zKWXAdpHF2Os0+UguXpkeRSChSzfQgTG2uqfi
	Jtk7GdVNhERD3z1kfjgsPUv9GaS4NsYtdnSlPEp6KbiypNtSk2+3C2CNyrqye+peVppU3NcsFHQ
	JFzM3Uei8sbN6rbTcNZ2QeIu6pTiDQIM3ChqzgIkPDq2W6MwMz5omYoztYO4OuNPJ8l5I/S6Odr
	syA2+9a0UI6a0nD/eGmbJHzyQ/gcl/BYJKzDRCiKgNfrhPxhRyEhapLt7t8WN21Zqiu/eqlWT4q
	qQDwrit2U7zg8tOZW/y49l42TQPB7ZR9/IozLWmQnnrxENfBiMk7vgN50Jk7ASYxNuRQdfKKxEo
	/VA+qlQDqnN8r4ww==
X-Google-Smtp-Source: AGHT+IFg1h+oSthyGc4tPORkNrPPpnVeUr6FNMPfEJgnXBupogksrkrfKGsIU7DtuK9+emJLDR1CpQ==
X-Received: by 2002:a05:600c:608d:b0:46e:49fb:4776 with SMTP id 5b1f17b1804b1-47a8f8c18d1mr142495795e9.11.1765897975942;
        Tue, 16 Dec 2025 07:12:55 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd90b81e6sm12034075e9.3.2025.12.16.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 07:12:55 -0800 (PST)
Date: Tue, 16 Dec 2025 16:12:52 +0100
From: Petr Mladek <pmladek@suse.com>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 21/26] printk: Register information into meminspect
Message-ID: <aUF29MLUj3YRh4v_@pathway.suse.cz>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-22-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-22-eugen.hristev@linaro.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93AE840002
X-Stat-Signature: r8ctq65a8bdrmje7fqzxhbifn88seh48
X-HE-Tag: 1765897977-221369
X-HE-Meta: U2FsdGVkX1+lwooiaLOc0LhxByJXuOZEPmba1xG9aqTb71EQXl5gfroYPupIfVAUUM+BmLhO0+HdcXtsog5r7T43LRkUtqgYziZjHP0MaiPpogMukDtzQysKH/y8veIGTZUydJPkArj9mJgJU0b7w8pSSvAw5UvP30fMNe93f3eCIqo1VnZcL139GiQL3/4iZXgpKEeZDZDRuMgfKj0ceqktPOR9Uta3R4bby82NJCwY/o0kyGW6BgH8FMkFd+ZyIAsIhsaHyr95RmcIp1MyEO9CupFyhNXnl2Aebz9jzthwrUJvTYkNicwG0If2aK1cfvgu6ODhlrwe4lqBkBVhdfr2muuL/Xk9zZusISMplU8PkM1Tt1n8hi72NNM4LShMpcyJOyVtRCKObihyJx+EstmQPWB4eSnsCOuHnbNMEo8nz0v9pnZOWwcK910OCmr+sjn128Z/I/CqxIKbBC+SP4VIG5aFxFp3AibNg0JWP2ZhtEdpfff3oKwBKWK8iitNPahqI5HpcADNfj11plknRrBJb4JuiGwa+PEIhEL6qEvYeosRcSTZWAbW/1W8LpoQ9r9Zjsy6OKdmLFJUZgv1A8n3Qy/Qnk0I+aOhTqPfcZ9LD/soGLJ9RjqRqba9lQOiclf0I1mChbWIkMDjkIj74t1bAbsejb6yfLlUFqVMn7uAyNpgDEa2LJIXld1v/KW8DmQyJUwxIqGuwUsNciOwA1COcHqwtItes9xaVontHI8jAIoEb2LaMZ0V6qkgQmhuMNX+CQo4sCOt5K7/fqwG4NshA2YYQSdfaeEXUDNvV2bFMKP7jSetwaDj90YNtYI0qCPi6LnxO7nwUGUJHo5xMPKBNWRoYDsPebS2svhKOIZrh31reNkUWwdllThSlmCz4zBol8JpvmtSCq2GAJu7I9pcTyeohLPSmsCXDmoPFVnovSSuvYkLEgyJBPmt87kckUVvn8BVn0PCAM3A16S
 aDZmexOI
 wX9NYnLvoiXbELxtksoyj6ZmlGHZGb507zqq9nw5kRncnalliNetUpMEaPY/76rBMOJvO6EOQLPk6iodPSYkfWE7rZjYVeGdTAO9IVQUdyqS0vt0BiJVcE30Qlow+2VVPE4eaKik9WH9MXUlS8tZjTQQkdU1HYyJdJLCG1+ZGjJdIbhiV8UVkVmu+UlAy6qDdUfvFTqjMLAmiSnT+kFoAu7JwY3NqOolgHffEgxUVqhJdnXXYlU/MnTzgzlGSdy+DknbBmGmNtBI7gPzTduEnTc3hsNFWOMaMbMvaL+z62N0z66zBxYP9WVT2HLUJItSpTJ7CfcSiIVYpWB2qZHhDKgA/xSxCt/j0jjHIxkEkhFzhT3uefFx93KMcmH4yZvJViuKwKolLK8J2Zcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 2025-11-19 17:44:22, Eugen Hristev wrote:
> Annotate vital static information into meminspect:
>  - prb_descs
>  - prb_infos
>  - prb
>  - prb_data
>  - printk_rb_static
>  - printk_rb_dynamic
> 
> Information on these variables is stored into inspection table.
> 
> Register dynamic information into meminspect:
>  - new_descs
>  - new_infos
>  - new_log_buf
> This information is being allocated as a memblock, so call
> memblock_mark_inspect to mark the block accordingly.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>

I haven't tested this. But it looks reasonable from my POV.
I assume that the output from the "log" command was from your
synthetic test so that "crash" was even able to print the messages.

Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

PS: I haven't attended Plumbers conference this year so
    I do not know what is the current state of this project.
    

