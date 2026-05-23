Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D03A9CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 16:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F496B0092; Sat, 23 May 2026 12:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630806B0095; Sat, 23 May 2026 12:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EDF6B0096; Sat, 23 May 2026 12:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37F836B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:20:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EB9DA0B7C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 16:20:45 +0000 (UTC)
X-FDA: 84799198050.10.31D3A21
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id A8DDA20002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 16:20:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bw6ufsDF;
	spf=pass (imf31.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779553243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQqOC5Q1VTx/Wh0wyRp5ePOnceO01hI9FXvQB9BCVGg=;
	b=xN25tJHZxWAOhz7r1E8hyAwsbSb+IH+/3ubj7lgh24N/aOt118n1Zjn8WICy6UQOVYixO4
	EKtS57wtS9daaHOPZXiza51Sjp7QoCpZ489YggMVicEZPg0wlsD7ftQr9qJaDVgL6W4bkF
	B4YW2S1lmxBQq6urUnvCpGxVDtnS27E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bw6ufsDF;
	spf=pass (imf31.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779553243; a=rsa-sha256;
	cv=none;
	b=eEJK9loKyXz8Ue9NJkcs9MDTlprdexBR+5nBJFSlx1Mjs1Tm75vm0RKEBtZzEx1Qxqehix
	VWlqlKYmsFEaRnzXAd8SAIQmreUIowKwb9gw0g/zQV6D4ICbrAWuBsLNWygQ9ZPUlbhvNq
	9JdV4n06WNec6HLvehWXkHaUACL+u3U=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39378db197aso85836351fa.3
        for <linux-mm@kvack.org>; Sat, 23 May 2026 09:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779553242; x=1780158042; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cQqOC5Q1VTx/Wh0wyRp5ePOnceO01hI9FXvQB9BCVGg=;
        b=bw6ufsDFNAGIHYIv/4kH32U3copyBRsmZ4zjNVWJVs3j0HHW9VUD2Xf8rFDQb1IQ/x
         5jLdFz+Wx9YnH8UYi1VxVA9J26xkR3NvZjZmUqA+36UISBLqWh7qKFlTm5ko7fXuJg1s
         GVO4XOUuKa50iO1WwJMrnyeclZAnNG0L1bYAgtVX+s2IEwGCCL656o4aw8JgphRVCVjc
         +fAVf66KiyjMTavhfd/HwYLY1QfKNz7cok46U3OUpnFYIgTPuBcQHpz6ZBRYGvGzNIgL
         b9j9liQkEFXeu4vRYKXGkZjXcO2SITpxJuSDan+bIf9ZmPWnElLgQBlFjdbodF5mBLf7
         k/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779553242; x=1780158042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQqOC5Q1VTx/Wh0wyRp5ePOnceO01hI9FXvQB9BCVGg=;
        b=aK/G/esG1KmFBB8VAUSU2xTG/7ZpJhY6iq6/71WeSZSjh6UDUslUp9QvjaZk5gepon
         ftGEvzlOuMLpTBiHnT1GMv0+WFs50YuxDsgUcBXOOOoUFpaKAWpVBSJikmnSD52W/rku
         UzNl41WiYgBSthSFTHAVkuMdX/bmbCZ1dZmIyAO0ecZd+U4Gv9Y0b17sb5pTderYoE8q
         XO/tZeDGYKLFZv0VrygQ1om9dUC/UrobXJZjL6HGwKZRuNDwJKybGv91thAKg3bZN7gO
         eYULmNcaCNcaL0m3E4djLKGWVZgkyDTXT+rQC4pd+MP5+EHGrY5yQ3ClJY8dbG/zpFKL
         j+Qw==
X-Forwarded-Encrypted: i=1; AFNElJ/gR6yOmSQwosROPhsN/8TRskcWipQpwmsYY2qjtS/2Ht+dBC+uM9X1WugiHjvioZr5cSBBLC6IUA==@kvack.org
X-Gm-Message-State: AOJu0YyXpBl2uLb0I1BGBZgh/0NBmDSowZcGG7jPJ1bVjexQl5eZobCp
	J6uFr5E7yvasDhtanJjnxuCg2QJE/p7C7HRedXgv11AKUYX99mq6B+FV
X-Gm-Gg: Acq92OE+jqTwrZHD2GcaUjxztj6e/F0wToLLuHxZIN3fVD99RuxMSwu6RK9Z78T8EOC
	Zt1s9tJ6R+V5xUmL6gKUBOYsYn+y3lU8Q/R7OkNMH/ME+31EN1DUtzRtQevK0Oap+NmDG6OyskT
	Jp2N1JnV9alCHpsSCKMHmxxKRimTmc44kN1wgt4TgSXWP5U9IsIDNYLRbrIArfPnLPcHVcY61wv
	5D0Z/xuLSicXigPPGeRJo+Pk2diwBunVHMNOGXonuJAGzBQv9gBLVXvj7rp5YxizYdyrmSfzNvp
	hHmXY7OhjitmUu3nPKKoW8oP7s6GGpX29kbM3eEtFLqcVRxtAKg7tQATTGTnkEwIsxW7WXZoJOX
	roZUU7UY2AbfWEf/YRktZni2/tmEIK6gYncCz17wSgrZgyhLfPE2nVcnSqVke9ww/IK14ypBBd1
	8=
X-Received: by 2002:a05:651c:1470:b0:38e:9ece:61e9 with SMTP id 38308e7fff4ca-395d8d108b2mr24995211fa.25.1779553241553;
        Sat, 23 May 2026 09:20:41 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca02c2asm11915421fa.8.2026.05.23.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 09:20:41 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sat, 23 May 2026 18:20:39 +0200
To: Jill Ravaliya <jillravaliya@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page
 freeing
Message-ID: <ahHT1wDkF4Dg3R7P@milan>
References: <20260507114854.41117-1-jillravaliya@gmail.com>
 <20260507114854.41117-2-jillravaliya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507114854.41117-2-jillravaliya@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8DDA20002
X-Stat-Signature: ddstu5kbbphjyh394scs93z6xzhkmfwr
X-HE-Tag: 1779553243-950664
X-HE-Meta: U2FsdGVkX1+wU7n9+KrDMSvuVy/s1FqvymgvVrMy++F14/ybdvwYRtg+hGkb3qjfpm/XpZATTex5nXNQJofC8fXs8Io1RKfxc21w/3iWQ9nGqu1uuwAF/WYYB5cZQqlB91WL2rPFYrLdIkuwvGtUMdEPwvk7gvkt30x9bn1oakwOLX/Nd7ToPvUIGKRO7HS6MPBASi1HumTNDZKDIMNNIqbZ7r8H6fdd/DG0SP5TKvH5v5quuWkjyTDX6grHJdfxNCRoFvEWF+wRbDVLyx4zaFFDQGEat2xYGRCbIV6Iz94Fz/+0NRMVVFpYbxS6g8u32193IKO1E6x+79LQgby4FH0WACycI/xbKsVbSvsPVJM9OEsMTBVnfRwLXJsvH4QFfAB6kbffQIm+QflcWligXzP5kpihcfJGlwWWNrPHMwuL2LB3Sv/Et8dGmop2yTj/WfcfpKY5VeL5Nf16lic2BY1CywD16fW59Ys8CO6VhaLlFY00dzr/hNjbpURC3hcMOwc6/MSZdwrCCFKxVTP7FtSnmEMtAalUWotyqLR4BDhvCmFbrQZpKVTqCCwqR4Uj7fM/nkhYutH/lAxvu/47Z1fv/iuNhm+NMNAuquMet/VHSTxAxhk7tQBkkYnZPCS7ymgkmicEXvTCW7y20xSc+SboIAM6qXvK8r5M/xvyAMADw4zPVUdcyYoV8NfmTc3wexdIeHCqj1UDvtv0fTgr5RtbKMHIECjyZN3q6mtSk9L0NenB1Xwd20dSaTB/U7YP6zb8UrBSH4xqkb0LRaWKROs8a4AOV85jTJxScz+fLXhARnuuxfPWEj/bnyheOj39MhFSX7sSoePebPO4N5bGoyGNWWSr7GSkjlh2TM+KGOgvqH7CK0CTpqhSZJffdfINsCL+YtCzPj7pYTG92v34bbA3bHlacP+YX7nbwv9fmmha3H7uyJRwy98Utyk1nbPOCmeSqaJPnZ1vMY/nIE/
 EwBPUbB4
 EXpBf33pp0Ju4Wxz7mdClau+5omPN9DJOlnnL//66oe7tEBL7/88peGwqrG14B6bzL6cgXicJ0LTT1HN18Y3zIdHX7mCo+25RFJh46F9TAjm9YIdTmEu8zju6UXIaKGAS2LmFVA/syO7/kydQBlxCZDc+cUR6WQuDCSwYSn3W+tj/SJXtoUg7mEt6hwGiv8FQPfs2ou4Na1n+b6leIiSto9rad4bi8i8XACSuA3sOS8blsJ141eQU/aWXYmTVJ57GAwxWn/QTthqZkUN5Mvw+0HdWAcAjkctf2IDepjOG9H7jjpGXowfGiv4y6OQG6DJSA0qj4wFrOoiZh/lMPFsh4WPQDC0ejsOtrUSpawZODIOz4vh+bpEmiGWIZE2/aaXXZUzLLadA0DkrA2EnxlOTKYsWAgq7fWBL45kpmRStWle24Sg/MYoIlHNbQeoXmL/7q6DsCL98r3oNqz5lvI8TiyPwsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 05:18:54PM +0530, Jill Ravaliya wrote:
> Add a selftest that verifies vrealloc() frees physical pages
> when shrinking an allocation.
> 
> The test loads a kernel module that:
> 1. Allocates 10MB with vmalloc()
> 2. Touches all pages to force physical allocation
> 3. Shrinks to 2MB with vrealloc()
> 4. Verifies free page count increased after shrink
> 
> Without the fix, the test fails because no pages are freed.
> With the fix applied, the test passes confirming ~2048 pages
> are returned to the system after shrinking from 10MB to 2MB.
> 
> Tested on kernel 7.0.0 in QEMU.
> 
> Signed-off-by: Jill Ravaliya <jillravaliya@gmail.com>
> ---
>  tools/testing/selftests/mm/Makefile           |  5 ++
>  .../selftests/mm/vrealloc_shrink_test.c       | 65 +++++++++++++++++++
>  2 files changed, 70 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/vrealloc_shrink_test.c
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cd24596cd..4eab7c76c 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -104,6 +104,7 @@ TEST_GEN_FILES += hugetlb_dio
>  TEST_GEN_FILES += droppable
>  TEST_GEN_FILES += guard-regions
>  TEST_GEN_FILES += merge
> +TEST_GEN_FILES += vrealloc_shrink_test
>  TEST_GEN_FILES += rmap
>  TEST_GEN_FILES += folio_split_race_test
>  
> @@ -282,3 +283,7 @@ warn_missing_page_frag:
>  	echo "Warning: $(PAGE_FRAG_WARNING). page_frag test will be skipped." ; \
>  	echo
>  endif
> +
> +# vrealloc shrink test module
> +vrealloc_shrink_mod.ko: vrealloc_shrink_mod.c
> +	$(MAKE) -C $(KDIR) M=$(PWD) modules
> diff --git a/tools/testing/selftests/mm/vrealloc_shrink_test.c b/tools/testing/selftests/mm/vrealloc_shrink_test.c
> new file mode 100644
> index 000000000..cf4263074
> --- /dev/null
> +++ b/tools/testing/selftests/mm/vrealloc_shrink_test.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test that vrealloc() frees physical pages when shrinking.
> + *
> + * vrealloc() shrink path previously zeroed unused memory and updated
> + * vm->requested_size, but never freed the physical pages backing the
> + * unused portion of the allocation. This test verifies the fix by
> + * loading a kernel module that directly measures nr_pages before and
> + * after vrealloc() shrink.
> + *
> + * Copyright (C) 2026 Jill Ravaliya
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include "../kselftest.h"
> +
> +#define MODULE_NAME "vrealloc_shrink_mod"
> +#define DMESG_PASS  "vrealloc_shrink: PASS"
> +#define DMESG_FAIL  "vrealloc_shrink: FAIL"
> +
> +static int run_cmd(const char *cmd)
> +{
> +	return system(cmd);
> +}
> +
> +static int check_dmesg_for(const char *pattern)
> +{
> +	char cmd[256];
> +	snprintf(cmd, sizeof(cmd),
> +		 "dmesg | grep -q '%s'", pattern);
> +	return system(cmd) == 0;
> +}
> +
> +int main(void)
> +{
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
> +	/* Insert the test module */
> +	if (run_cmd("insmod " MODULE_NAME ".ko") != 0) {
> +		ksft_test_result_skip(
> +			"could not load %s.ko - is it built?\n",
> +			MODULE_NAME);
> +		ksft_finished();
> +	}
> +
> +	/* Check dmesg for pass/fail */
> +	if (check_dmesg_for(DMESG_PASS)) {
> +		ksft_test_result_pass(
> +			"vrealloc shrink frees physical pages\n");
> +	} else if (check_dmesg_for(DMESG_FAIL)) {
> +		ksft_test_result_fail(
> +			"vrealloc shrink did NOT free physical pages\n");
> +	} else {
> +		ksft_test_result_fail(
> +			"could not find test result in dmesg\n");
> +	}
> +
> +	run_cmd("rmmod " MODULE_NAME);
> +	ksft_finished();
> +}
> -- 
> 2.43.0
> 
We have a test case that covers vrealloc() functionality. See test_vmalloc.c
file.

--
Uladzislau Rezki

