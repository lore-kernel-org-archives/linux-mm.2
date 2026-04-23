Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9AAFDEE38
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3279E6B00B1; Thu, 23 Apr 2026 13:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304656B00B2; Thu, 23 Apr 2026 13:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED7B6B00B3; Thu, 23 Apr 2026 13:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 100A16B00B1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:44:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C78961C0495
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:44:14 +0000 (UTC)
X-FDA: 84690544428.17.680D607
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF419180002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:44:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MHUuzRdB;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zC/Rvuafxmv1NRQo19/P/Pi+8hYq1qGRsY1yAUjYcA8=;
	b=4h+w9JJMssUA3LG3p0Jxb/kVH87AVcXps0lUR1aM1ahmHD2grriTJ/fSupLCuR9mQX7Ha+
	VtR6+A2AcrlCEDrI54Cx/6BEKsfuH3M6H2+oMN6NbKV9dUFs/C2Axg9/5lXSTchhA/qcBS
	jHOAA2HH0sdl4tOKD+1CC5INaZr4IeU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966252; a=rsa-sha256;
	cv=none;
	b=vckXvHlzykwhAEzX2mK7VZFJWdqRxvd+e7ongR9sKNURlAA4VD57ui86RoM3aoARDjR8aA
	YGvMHbB+nDDsm+GhU2NsgtjYqoB3RWnKYq+SsOLvKAq+fmwYfLBs/fChgmlgKuMgk8pvqA
	ToWwWYh4kKVSkd30yLUF1yTZMBBmUNo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MHUuzRdB;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d75bfb259so51719741cf.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776966252; x=1777571052; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zC/Rvuafxmv1NRQo19/P/Pi+8hYq1qGRsY1yAUjYcA8=;
        b=MHUuzRdBmtqc6DNMUJv46YOiI+k0345KMOpW57DqwiARSmMqTOZ7SP5aqZ44UzduOi
         E+b4LXcYzSRY86SUElckaVwx8NQjX9fazbJsxzKXLWUQsqQ7jWIq7XK58dUvw16hw/uh
         JUXw6zzwvvF9BHUBHKwVYGVegGdNRoBI3fQNdEzxRVfPuXhkMiBUAVwIkdr1YUEFtWvA
         umL0JL++nz9GABb7MOE/kF0t0HGXfX7HZjjKFwKS2AJ8frFZV959M6GzvR32SEzAQGK2
         QTg3zeVVrrYaB5CyOjw1sQnPMZiJoBsg8TBkwKCx8uFYv/S4TUKPvrI7ki0tUIOv9CdQ
         INgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776966252; x=1777571052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC/Rvuafxmv1NRQo19/P/Pi+8hYq1qGRsY1yAUjYcA8=;
        b=BJnfQEwAjWS9vzwy15YcqrgAenb8mN1U/MD7Q+K/MfOn3NCpdT1tLTOP+06cT1+3Uq
         ovxWjwqXbeMVC+jCraW+ZFwrFGFtw4yZkd0DbENhQt4g0DthzJXR2/DqnbhyxY46oiCE
         Xe2DktFQagGw+Z51LaSBEhwH2fM6p3yqS9RJIOCgEI+rEpavZ2dZ5YdBwtbJ0FBbAwG3
         z1nqhKIxpP38XgBLV8tQPXDQ5E1xXKtlZbQ+kJcrhdDLbPN5BP44G33C5U3jFRzG8Mdr
         Cj8O+3DQKDARG/syBB9SLTolMu6rgnmNKg6CJ/rnGP3gTWBNX6q50HjiBoTXLY8VREhw
         9aog==
X-Forwarded-Encrypted: i=1; AFNElJ/OEhBGbYZNg9cEKHkYRZJIy/CrIM/QgIw7rmPlOWEu28Cj7l8FOV/Tr5jHbAhi3ArZ2a3mL7CWlQ==@kvack.org
X-Gm-Message-State: AOJu0YzPda74f90Zvf7Zx1+Bs0ukzUGUF0/zyoGuYS0/zNEjDyUxerjU
	SThw1NhPe5+RPOHaoWDcOcHSg4Oq9QXMhSOT/T/0NjC71HEiP32TE2soccLH81tJtNU=
X-Gm-Gg: AeBDiet86IlAQHwMXeM/Lq1PKQczOMclle1WkOfa2jZfKSWrNapTK8zbjpzIyTR3C8R
	aGh2QcQU+F68YZlZwwxa1OePxQx3EK2ULHEjliy8MjTg7bGcGqGRjx7xMo1vHE+OaoYFtK6ob9Q
	ldTADBLL7uE4fENk9J1RplOSMlVRf42B9JL8lSdboeAGHzjd4KGj2ZqOUwOU2k90+2gNwvLecyI
	ZEBGciT6FnTWT5ZhhQoKDAeRiX9XbUZGuz3NC4/ZU86NRjf8zkqz6h4/5PdGvxuoOJU4Jo67RjH
	9jX9/aYhMsjg9Fqp8M8WFgAdw3hjJCTfuYoqdAFVVY2kJCdTM4ZW2BryQsb/mGr2ZAUtxTuCPY5
	USbMtHLaqkMS2Gle2wKTtqOy+9BetJnCFWm+jSxq+1k/ZfV8ToIg0XefQ6v03e1XZppR4DJnSxj
	iybPwYYNGX9mZvHFXaZncalnYoKNNCNrwubtm+K9pjsusyUBjy7evefb36RC0UKg==
X-Received: by 2002:a05:622a:5818:b0:50d:65ec:a071 with SMTP id d75a77b69052e-50e367fe18amr407627591cf.5.1776966251944;
        Thu, 23 Apr 2026 10:44:11 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae61332sm156030426d6.24.2026.04.23.10.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 10:44:11 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:44:10 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 3/3] selftests: kho: test with deferred struct page
 init
Message-ID: <aepaWxfdHWT4Q-mi@plex>
References: <20260423122538.140993-1-mclapinski@google.com>
 <20260423122538.140993-4-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423122538.140993-4-mclapinski@google.com>
X-Stat-Signature: 3i671n8ufwi9rkh8zypid1apicht6t3t
X-Rspam-User: 
X-Rspamd-Queue-Id: DF419180002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776966252-196215
X-HE-Meta: U2FsdGVkX19rbZRR1+rvXUX2ivGktDz9LQqfu8YBsKQXqvtM4SRxpTst03EUs+b8aTPv6Zb6DMdns7gi6h3DABuiAT2ZY9Tx9qXRSdOGxz3LYMMf9aCf2Waj7KM9PgjMfTwq/2g9Nbrxa7kaT4ruAVmdwOeaDk/EVZVhyrw3ku85p1wIJHLdxjkkoN3fRAuEWwxfzpv9lkLnHF8jg+G424Aq7iT4FOASuPhR1QO5LZzZOfQP8/1S779Z/abU6+OGGlMmXmZyxCh6nOumeKNktLq1wInQGLn0zxd3K6CgOFDfYqZfz+76Fj60rgoUrOCC2NxCUWC6Q+DBH6W5b4vccGreVvSnWTCUtpRWfXjNyd7yvwQ3iq0waiFmlW2N5p0mIW6MVvIv6+6Bx4n3jDHt6K334k/Aoh95EQ0Si3+DRE9bQMc4hnN9nqjcQIDB9lbFMxSd6j0S59hW80mL6HGt7zvN5Kx+RLUL09Sb/roHOPurrw9JBSBMt7njWxebiAX6X98ozpO3OSwjUnPQ/9xAPdcuqu40wEdhzzX1BAicqikLfsJLSbTo6kfStW20nrf8qMLtUESVoO2mWbJ9mpgxitH5cp/6Cb8V8aW8yP1OrFol67fRow3h0WKJgWWG52x2qA6y7snQNBPpwjQ5cEPX5k5Rbu7kRsaCPqcpTMGjEDvRGDCAvPn39XV1PS6IwuI5NPHT7mG4fjwEujVbR6CL2PkQTMtggv1ot6EePaJHT4eTQ2eNG474qB48Iuh9p0NXCJiMGGhsgDNVtaSYT7LzvP4e4gSWKlLEPfO5zPyqOaIs/3t150CSBaykQBoPaaMyDoYarFoLKV87UFAFTZDoR4NX1qaa8iJdM2dV4PTQ4jO1pEwKqfx1Pq1fSkglJNj8ugjhFdmmiPssM+Iw8b+eBmc+X27j3jTWGs088DG5n3WPqYR+DlPpDRL9dicYgUtmGdHmDG41TkP9fBo7rR+
 3nFX9Gsh
 rAb156J5FQeckjlfLtmVMzZgCsCqP8I1J5e7dK2KJ92ivvPcVPDUymO6vnSQoYKpYFAcgOSzGSsfme8vN6FL8R33eBgwdIrx86dqlBMJbutyFv7eXQbBnh5YG9U5vKiubzKax2yd4ioW/CLtZiiY14DIRd2WXEIVjRHWb3uhvYPBvCOsDRU5TXAzn/sZlOwx4x0hOs5o9S00cD+OlJSjMJg79zwdS8sCBAHRwFE7qGOFG/RvW16gjxfAyMH6BDUxK0b52vSS3bf/khhxeWcRthqN7EWtLZYZynQafu3RyQgCLUeNNHdO+ctj2VFoh3a68K7EJFGwAfWLBwvRqD54bGIc6l0NEGaJE//GamnUA7o5W/Q0e/v8IPs9hqUz/J73a0PK/kGdomQoLmVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-23 14:25, Michal Clapinski wrote:
> Enable DEFERRED_STRUCT_PAGE_INIT which depends on SMP.
> Also enable additional debugging options.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> ---
>  tools/testing/selftests/kho/vmtest.sh | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
> index 49fdac8e8b15..0014bd76e88d 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -59,10 +59,14 @@ function build_kernel() {
>  	tee "$kconfig" > "$kho_config" <<EOF
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_KEXEC_HANDOVER=y
> +CONFIG_KEXEC_HANDOVER_DEBUG=y
>  CONFIG_KEXEC_HANDOVER_DEBUGFS=y
>  CONFIG_TEST_KEXEC_HANDOVER=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_VM=y
> +CONFIG_DEBUG_VM_PGFLAGS=y
> +CONFIG_SMP=y
> +CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
>  $arch_kconfig
>  EOF
>  
> -- 
> 2.54.0.rc2.533.g4f5dca5207-goog
> 

