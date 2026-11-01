Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5840D606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fke4hQfB
Received: by kanga.kvack.org (Postfix)
	id 678D66B00EF; Sun,  1 Nov 2026 02:35:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601AE6B05B1; Sun,  1 Nov 2026 02:35:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9346B05B2; Sun,  1 Nov 2026 02:35:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1658C6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:35:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FDEEC08B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:35:03 +0000 (UTC)
X-FDA: 85385738886.06.BC64F09
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 328DA100007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:35:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fke4hQfB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of shorne@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793518501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMfjSjcyrqnI6elm+AdDS/CkwuBjoRxXW9M4kovCuBI=;
	b=RVRbgcDAKAQ9JFUfWVIpls1EpczzwCczGeS0TT/lKIWZpRo91COuSnUPN0E9M0W+nNtwG6
	RxLmMlcPagLlMqCYpwBBxZTHpksfCVADb+NtOJwlK7hdmMw7It/QmC+7fZii0P7i47Z4Dc
	ktrIEpEBjemaXJ2O08B6A4fmx29itIc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fke4hQfB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of shorne@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793518501;
	b=FuyPya+mjjJ68NaQJgrtAUNRcQXB1RC9AMxvCWKl0avXsIrDzS3yQSsjGe0Covlncqhih6
	W0MQ/rFsdYEV0JE/Oimb+rC8ijnM/D2aOxRJ9PGV7Ix2fuFWQSKj0gNHn+3fvtxjFpKCLz
	dayS22X9R3+k482hSuatwUU9O//3ZJQ=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso17166935e9.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 00:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793518500; x=1794123300; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yMfjSjcyrqnI6elm+AdDS/CkwuBjoRxXW9M4kovCuBI=;
        b=fke4hQfBcXdgabhrvYBW61N3Szok4RdY2H4irLrZ4nRb/WfVK0qh49H/Qp+YzzWT3q
         BD/eO4ewcpdoyEz8DIjoCpDkM/HZNo4GenIo+0BQ/QRc3as59G5skMrpt/eUztgwuxh1
         E4EGD+EH70hHNg+fRwCbnlydsqSMqaDeBw20nRn2NkejDDfHroU48CGIpFGUkMGakzY9
         Ve6Ar5BsLah+uf8bPPgyMuMMJnxto4PVZv8QFc2lPTPTae5kx6gH2stzfF5yL/YUAYda
         wytWcEdCznYi/auTmdJWw3/a+z9XOijWyE1ClvzqpRrvGhjWyzxmwJCH+sCryFPe9vvK
         wFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793518500; x=1794123300;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yMfjSjcyrqnI6elm+AdDS/CkwuBjoRxXW9M4kovCuBI=;
        b=2B9W8v9AwtSzqnsIT2hdUlKI+tk9Gp6xJYqVYKfFe765xLs6Uj3HFRFsGjjlVbYEiZ
         s9KHjCfpTBVu/3+JJOFj/NSF/ziCNoYoxcShP8wfqk3Cux6lPzoeyairASfT+aQVu9IR
         SJFuJXnlnVC48h+mYbqH7Q0b9iDoy4Q3T2Ix+bT7RpO+FgBNKB8fLToS6R7dyRCKOoZb
         CRDhDpOro4FxFkAbl3ML2fIv8ddFXli+OlNUi5L6zPHwxGa+0TR0cV7HPF+b0O7OS2ET
         FzFHmS3tefzObQ/2Y2NaE8yINThLROIvLwGQqcOFn6NARUgjtqWaIc5GPPCbh6KKWO7H
         KVcA==
X-Forwarded-Encrypted: i=1; AKwUvBxnU8SEwUx4KCuyjqJczBS4KHXQ5s4jpu70FWo6/hsC/xi54vCb2I6RMbKi9G32nDttXAnrwLwoWA==@kvack.org
X-Gm-Message-State: AFq9FYIzTYqzOfcZwCbOC8WBMCgmNgxM1Wew/sCYqEZWh8u0Mo0COYlC
	z7jotZiro2nPHYtpO7HoKeFbcD1bV1sXvVfTi1cfFyOnGVqEaVFanOeG
X-Gm-Gg: AYBFou0ctdkHVHo5LmH+DmyJnVQRnSlfrjzDNi8gJMw2YvRR4WalHjdFAHjG96OWKIq
	xAXCcJJwnP/y0+ea2ImWG86/VDbzzgdrRZErsFfk6L5x6By7xHmQMgNLq83I6hBJrhnAEK9AZcd
	6X08+sJGAa8kPsF/4zsM8vU85WYf30JUnyKYgGDJGnCZ4kzW46hVWD1JnmCxyksUxph3RIUqm+j
	q7DqcYD02rHk13KYEcaQ2eUwj48s2QJpiJTO3gMaERUO0Qod+eQu696gB20zerdnRVxyAD2WX7F
	rchLSFpEqs99n2koRY2tUTySMLu+12JKUTzyZN/UIKZZMazM0nN5rdpQqwZHwI9OaOtfybANPSa
	eWFq6Ul3L1y8fqcnQseNPnnWRZgLYPwSmq+U1LV0k7DVjcZbLJqdnAJEPVEywQF6zRO/fQptDgd
	CEPvGOfinx+7e3kHaMgdHLZ9ut3vZenbmCvncapx8EQebKMT7XE1Ko9HxdSKsTQ/b9GgjMuxRn6
	hLqltaAu45nbs0AkJagWORRXOLZ4rerWXEy6yIO9VQJiBV5fR4UOumHTp7eNnlPVrX6H4svZLDU
	D3KuHm2XY+p+QxZKqyLdcFB8DQYCC/4qp4ZppENznGLYV+30NK2Q38IobWDd1651O1mGhpW0pZB
	x9h8aVCtX7jiLQbAd8TSNri/SF5g=
X-Received: by 2002:a05:600c:19d2:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4ac1737c51dmr154466065e9.5.1793518499393;
        Sun, 01 Nov 2026 00:34:59 -0700 (PDT)
Received: from localhost (brnt-04-b2-v4wan-170138-cust2432.vm7.cable.virginm.net. [94.175.9.129])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e7a1d9d71sm7150261f8f.48.2026.11.01.00.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 00:34:58 -0700 (PDT)
Date: Sun, 1 Nov 2026 07:34:57 +0000
From: Stafford Horne <shorne@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stefan.kristiansson@saunalahti.fi, lkp@intel.com, jonas@southpole.se,
	broonie@kernel.org, linux-mm@kvack.org, willy@infradead.org
Subject: Re: [PATCH 1/1] openrisc: include asm/page.h before folded pgtable
 headers
Message-ID: <aubrobg1lV24DH4h@antec>
References: <7e6799e4a26d4c87b28bfe1d0bab7d54.1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e6799e4a26d4c87b28bfe1d0bab7d54.1@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 328DA100007
X-Stat-Signature: a11m75n3sjadubebsfs86fy54y83msqo
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793518501-941706
X-HE-Meta: U2FsdGVkX19OiFiGOgdexMpdZySdP9NizRX+FXpODIJY/OpJVkFahjk/182pDU4D1eIo38V4zhaBnBFlTBBBFzd4uHLv3m08zMG8MMcRbs2Niaw0PBuQPSBZWbrsqsG2zcwTnLxNgVyj6hMrGqbUIttiZTVvfRGacHG9UxvHBs0jM5tBV35qj5oBdodQpFvcX41pu2TFeuEpX7aiUPaY+VAnMOh142y7BgCS8EpFRrNOd7n1D3H2phacbM4eLJNImfm7Tg7WdhGuUghwxv7W2ylwwI4absj8kXyIqzOlkswzuOk1c0SSD0nS2GmWxnIXjrb6pGBRusiSFqROD5CmZisQbXWMWQHTCqq3K1b6gT3Y2SDfEU3dizUQo9R+VFCsfatx2OasqEESPBGOPm7hCvA/lm3+LiIvnUlWO0BXXF7ig+1kS5cTBhh8j5iJ1GNxaG9gjkBXQuotys02DS965X2Sc+eeq2sriXSHrwWiyug/nmm5qYaZq/H65XT++/ZP42G3PlLWeOHWr0KgrGDSJz3U5oB6urv7VaARk/9lXnLKt4omQ2rXqicYcFLX4iAAqfFlNOyTZqmkZh6bxMWUF2Puct2r23cZkt6iCd3mbif5gnuduFTBiO1qpWGOgwJfEsnuJ+MVnLqiRYGXCtAvelq9BaSupKZHik4c8I4WacHpSuthRXjgcbUJCW8K7nVqKhxmwn4gvuk+LJCzcqVV5H4XEvXdUnzLhNXFLXLp+wgsmPYqfCgVdvvKlW7m7VAgjnhMBXLKhEZeZkxNVOH3G6ROOuc5zYVpqPPmIj8lq2fUEQwrIwkcxy8RVg+YWgyP7Vhs3bdHfFGSoo+AGroGLs1xGUWjYwYujlm0XdaarTYUCGt9/PWvsol76cq92+vluf3/w64b4L50fchijmisN1Bc9lPoSzwc+9O0cCSXO49rXVpacO/+CtFUW7ZRdv13Gysmll4LkqPsDukjOod
 C6VZxCAS
 qXa1lo6InYkpCwMyPeq9ac/84jOMa2Hc5a8gN+Tvcw6Thc0sAOZ9B2FSuXsdi6ygxJTU4p3KMPfpjTKkkStv0kzhcHqUq7HM4gh9W05RN62r1hriWThasreYVXAFqwCOBdTTOZZIRzgtQOp/Ld9DQA1lCbNMPaMC8n/wEhOeXR/77D6aUxD0FsgEAM5BGF+HwOHRzN4BDjMEz9vGJMIH3qzDfLE3Fggb4GkOuzw2smW5zmEk2kHP5mp98FO8MLZY/1emD1tswGWpN3f8S0m0YMfcvGd/mIe6A2/sO5gW/NNP1wWClaYc9nn7BeeL0uAkilBhsw62G5ubVyHfD0WT3AstVahypUAaxfiiEx7Z9xT/naNpfsobvFyU5dIoORNsgR28d1kcGX9XjWPw2CgMHgiIY+eGIJv/tRZ9O8ocIVCRxw4z+eM94127gQE496S14Dfozq4HvPYF4WLUYrbiFx0zlsOFBB3PVFQyrRTlHTYVzQebDZchQ3h9jaKV1QX5hR5TNNOYS6JJUi2pFyBIdQ8OuV3wwNuEgOs7ebVO6jRiEgfCaUF6iiIr2EvV2a1cfSVt0Q2RkzprvK0Gh7ogq2CSEx85eYyF3aEo+Ie4jZIOGlZz7sDjGsKIKn90kwanqeRq6+aVj1HxaNhHbqUSY41fjvOgE7P9ZES9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 05:52:47PM -0700, Andrew Morton wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: openrisc: include asm/page.h before folded pgtable headers
> Date: Fri, 23 Oct 2026 17:37:53 -0700
> 
> An OpenRISC allmodconfig build fails while compiling the DRM TTM KUnit
> helpers:
> 
>   include/asm-generic/pgtable-nop4d.h:9:18: error:
>   unknown type name 'pgd_t'
> 
> The TTM header cleanup stopped including linux/pagemap.h from ttm_tt.h. 
> The remaining ttm_caching.h include pulls in linux/pgtable.h, which
> reaches OpenRISC's asm/pgtable.h before asm/page.h has supplied the pgd_t
> definition.
> 
> Include asm/page.h ahead of the generic folded page-table headers.  This
> restores the missing type definition and allows OpenRISC allmodconfig
> builds to get past this failure.

Hi Andrew,

Thanks for this I will queue this.

-Stafford

> Fixes: 2854902575ac ("drm: Remove pagemap from ttm_tt.h header")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/202610240135.uFA85jSq-lkp@intel.com
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> Cc: Stafford Horne <shorne@gmail.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Mark Brown <broonie@kernel.org>
> ---
> 
>  arch/openrisc/include/asm/pgtable.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/arch/openrisc/include/asm/pgtable.h~openrisc-include-asm-page-before-folded-pgtable-headers
> +++ a/arch/openrisc/include/asm/pgtable.h
> @@ -21,6 +21,7 @@
>  #ifndef __ASM_OPENRISC_PGTABLE_H
>  #define __ASM_OPENRISC_PGTABLE_H
>  
> +#include <asm/page.h>
>  #include <asm-generic/pgtable-nopmd.h>
>  
>  #ifndef __ASSEMBLER__
> _

