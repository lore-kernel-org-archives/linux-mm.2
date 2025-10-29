Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0016BCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F618E00C5; Wed, 29 Oct 2025 14:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0168E00B2; Wed, 29 Oct 2025 14:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF1C8E00C5; Wed, 29 Oct 2025 14:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2968E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:19:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7E9112B0C0
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:19:42 +0000 (UTC)
X-FDA: 84051965004.12.1A48DD5
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E6954000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:19:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ia73V3f6;
	spf=pass (imf04.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761761980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wthfBbpE09QD/RVLl7/O7vaLWiSY5lI9YfKCDOez+Hk=;
	b=ZDZNZZ/4ayNHyAZL2ZyreRTuQIpiP8ngeVgX9RndBwyqFt6Qin32B/PRqeAYG6HypQHJA4
	cQ4QnNU74dvY6t6ZMD3YneMFahRem3H9XzsthNqfeN5aExV1fMNuXbPCCKoD6rj6lC4j6t
	7LlIbb5TRlLX87ESN3rhnkZZb3ADGfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761761980; a=rsa-sha256;
	cv=none;
	b=8at3DLXews1ezmNKU9uurQh09F6lnvM5BQiYHuiHeJEDfstnAtt8KcV6RDX/w7R8Ic9KMN
	wTPI8BRAXSLYdwYixKRtqgk7mMkZslbTHYSvJpH3QJk4a4wbBgG24CfjUnWdvft9+09wvH
	+oYfQZUdVlaNJeVoDFVryu/HlsXS4EM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ia73V3f6;
	spf=pass (imf04.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-592fac6c37fso15444e87.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761761979; x=1762366779; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wthfBbpE09QD/RVLl7/O7vaLWiSY5lI9YfKCDOez+Hk=;
        b=ia73V3f6JlCxwHi1wdirxljY/76FY54NstInNB1okb3HtQFjDI5PXKLcC4gV2PIkov
         pJXsqBdNEnPiFs4VJQcG2CYp9tJMuOGmomVsNCLPAgt0Q3hGE6Ri3N3Qp3vAVH+7U1kj
         qq5mvCg+NgEi/dn6AOFC+DnhohTCaVVy5UwH3cZRM0nb3HwxK8gRy1JIeUIK9JSPAj6H
         iDXiZviRq7art3M3xl0EV9xxBKkZuTayGSuV/y+v9Mrfsq0gPkJOLZbtzfFWua9DLvv0
         44IqDPY92s2l2M3OZBqZVHfMoa9CN+DwOKj/kqyNTKcDr8T1A9jHrzr2jfCk6BATyRP/
         gTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761979; x=1762366779;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wthfBbpE09QD/RVLl7/O7vaLWiSY5lI9YfKCDOez+Hk=;
        b=dgNLI5BU/38FfDLWI6jIfbOJ4rmV6LFN1WRQ4nR9BBFgFWC0n1YT2SeX95hhVhExIh
         lWZhWvVUGRbcOBn+djGY3t3UO0y5pZFqJCHeOTRo3jjWqYbYVZ750H5lsidY+D06RYo3
         fVAj4wpylyTOSW2GvuHhalRTyPUPLQ8lFe/Z1vTRkC33N2Y6K0Z2JAqxgbDCRs1LNGYw
         nfpRU9Nse2M+CK2YC3kZ+EII0Fv41dAWI6BOZK3utY16Q1E0fbzExvAEYUbWER5Z5ikb
         iQwlNgcTJzWDFygWZXOKJKSA6Wd6wIHoQHnb9zCqUPKQOXDNOMHp2UofUc6XsmemsYXl
         kEEw==
X-Forwarded-Encrypted: i=1; AJvYcCXnk+yb8ShTOqy4KKytvlNjb8Li8hMJHIC45D09JufIwGhVQzRX0243cziqlIlqqaGOpEK8+9cYuw==@kvack.org
X-Gm-Message-State: AOJu0Yxxs3HvPu1laJpo7uornrmToxmYYxZvnJE513Oj1m/3a6u0Fp9O
	mL65Ftx24kJvoW6kl1P49mY1cMLsiJbwTtGZWIefqBG9c/V7zkSYmmE+
X-Gm-Gg: ASbGncuGhjxRaNp4x6KvWBP5o15bmnsO8/qcuJWSVnJSdczJ7z3qKAkuZe7jiHZHlKv
	eXF9QDTHA01nG7er6oJLzCjdyPgcrbt6rv9Z4OEY8BOd/F+6QmsRBrb50OPQ21fAJAIMFlpgvg7
	7eMA+TZnBdKq9xxnjZ+MEfgkHbJ6+i2UKlU01r6+n/QkWVPC8pGekwrOnyofGzY7kUVBhcPVYVc
	MaufahajLddSRyVfzTn2Dsb1fGdgnkCSakQkKwkqh77/c64h16AdzU9kVvQLazUdimxOkWu6E7+
	Ptslvro9tLe21A2xqvC/mlvAEkexzOE05mLH3XvaRZH95jLmsmCyIVlwgST//BElMvcQr2GX1xK
	UUVtFRpcP0nPRbPZiTGLgqFzpe4WP71lQ75PLK+K7mqM+bSYhI9mwTuxBEvFnm9mzaa1AKZVHys
	3KJhFVHw==
X-Google-Smtp-Source: AGHT+IGcxS2YrYY8mFvpyEsx2SVVvK+7CqZdpGtyuXWAue61BYvtDz5UP3WnSAs93IWo51I4vfsEFQ==
X-Received: by 2002:a05:6512:2390:b0:581:8db3:d5fe with SMTP id 2adb3069b0e04-594128657dfmr849225e87.2.1761761978381;
        Wed, 29 Oct 2025 11:19:38 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-593ecdb604bsm963255e87.5.2025.10.29.11.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:19:37 -0700 (PDT)
Message-ID: <bf8f2ed4-0b3b-4ddc-9ce9-0d0b1a64c914@gmail.com>
Date: Wed, 29 Oct 2025 19:19:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V3 7/7] mm/slab: place slabobj_ext metadata in unused
 space within s->size
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org,
 vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-8-harry.yoo@oracle.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20251027122847.320924-8-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: e7nxo5qm138c3okmrp8fzit5g5pwdixr
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E6954000C
X-HE-Tag: 1761761980-934492
X-HE-Meta: U2FsdGVkX1/PdkvmWXL5ugqM/RvgU/5b5c7AuTOsdxEJMe3LCcaRmt6J0fSurJxcwn9jUlFTGQ17E1KNroa8AZMF55ukesIyc3zghV22KXU+ciVrFRTN5MhvPns+cJkMVwG6qRUoyhy97mDpeWvFPPM85JBDlcLaYDqRQWrXEunLz80yCn6IUNxKEBNuTEoUy30duyQ1NMa/w8rgwngd2kZmcCLV4s0ZlPKcWo5uF5Y/WxjgC4a8rkbupf1P8FuzQe+sTXBNW0I8wS+amq+ia+hSw+pe1Rz2rTv5PQYF7GhMrcTJm1Vk0TbYi16Xzf+1nkJ6f+omu2kv+EKU4uIwXU4+Baqg+Py1Hc/DycSQ5r0VMJUn7B6ZI+6tW0r7o/Bo+yW+JEWzT8M6o1m6356GJ+cGgsLTyogKk6TSpDlPg9WATK4G/DPCyB3E+rDXbahPdNMgwd/lTIMrqJZohVVvUR8XqoLjeSX7bP1kSNw7ftmtZyQNh1pQXUyQAT+Y6935Ps2O9zXRdLsOwfV79dgJua2Ra0ZPCC8WfnM6Vpf+I4wOomBxkyGMjTq4iIk5tpKoYGJ2a07nkBYOIOeSBXKYDZDmJmDi0Ift+mbRZVkKIicFfiQSBwi2IDLcK//VqGPJrB6FL/VYOv2jPSuouERCbC+KMpgQXtc3p2oNEjPUW7QVgpVDznHhydou4mmqG3EiuB9LBQBQaPoDsuggAwRERZA+pfdwb0A7p8JlS9oR8rZxvOrr4jvlqL8k5/Q0VUAYaOb/zvkkLmD/cjuK9psKYBX4CanCUGGyEbcSoSggasAoN+9yJ1kZ8HCkPlbroxHpcdc9+8Dfvp3xmGr+KxkvV6yq5x255y0vXHCfPHDSl62i2BDMPsHltDR7Wn/X10/XgSySFtkFZStoL6C1wd7Jh+UuIAK1RYzIDZw36tZHde8U/Kn/gGb2nx7TqEkJ1j854E/OXetpDl9kmjefKIQ
 dA16VSs6
 nEGSXSmuwC35Ipt+bcNoQxL6rDr4XwJL5rrK7Pd8xPYyzV3oMynOPfGT0lfwxTQkE9lXesbJufYJRsOKzjU5EQmyuaQcgfAktjESDLz57zerbIZGEU3RmmhEZCKha2ab+L05xGj1W697CwyTwWwf8UmaLcVR5vjQQw9anQO0uebyV0jjuKJ6rcskr1/PG3Pr4eOUz0O97X6ujgdvnY8DcFyOHvAJ7XEPCwxWJrAnYbn5uTfUP84r0THWIMoaspOLoXDZNlrrfdS9N+nI/Za052vVWhmKLwi36LnXAPJWcN50dQs7MCAwW7hqnWSoTuMP+ujDXIbQgjd2BQrgKtVY8IJRYIV/EY4eASLU2IRX3BMLLsUuU+ThFDOMUiAhAHMGiFP5SIIcjeSkDwCD07EQs+xSNOWMS0q5awRd+Jc07LSznOImPCprZ+3XZwshVT+s4TdcSCAaG2A2uXDmkw8gSWFc1q7PZJ/dwaff4Dw+fKS15TvmQaH2o+t/j0IxA6pmlBaLDyCg7ZC3u6HQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/27/25 1:28 PM, Harry Yoo wrote:

>  			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
>  		slab_set_stride(slab, sizeof(struct slabobj_ext));
> +	} else if (obj_exts_in_object(s)) {
> +		unsigned int offset = obj_exts_offset_in_object(s);
> +
> +		slab->obj_exts = (unsigned long)slab_address(slab);
> +		slab->obj_exts += s->red_left_pad;
> +		slab->obj_exts += obj_exts_offset_in_object(s);
> +		if (IS_ENABLED(CONFIG_MEMCG))
> +			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
> +		slab_set_stride(slab, s->size);
> +
> +		for_each_object(addr, s, slab_address(slab), slab->objects) {
> +			kasan_unpoison_range(addr + offset,
> +					     sizeof(struct slabobj_ext));

Is this leftover from previous version? Otherwise I don't get why we unpoison this.

> +			memset(addr + offset, 0, sizeof(struct slabobj_ext));
> +		}
>  	}
>  	metadata_access_disable();
>  }

