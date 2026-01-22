Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2600AC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865476B0177; Thu, 22 Jan 2026 07:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833826B0178; Thu, 22 Jan 2026 07:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714DC6B0179; Thu, 22 Jan 2026 07:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 566186B0177
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:21:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04578B6AD7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:21:53 +0000 (UTC)
X-FDA: 84359511348.13.855D2B9
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09201100007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:21:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BCaF5MOV;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769084512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30EptBzNKREQjciAE94dkKi4CBlW2pcTBovWP9se6eo=;
	b=5AuGW1/uOn6j15ZaOexHJ5OfJzQbfRcXMeb2rKzIMPQ6TMOPIM1Z5p6xx+SflwmRK4RoO8
	ji/HEc0c6ArnG8s2vurUIzgkaKMPiiGdOsMUGrd0X0SrKacELcixE2ccByG27wTsPWjdRB
	BRa6EYhc2j8d/RRUFzW9OPY2DhoFpac=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BCaF5MOV;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769084512; a=rsa-sha256;
	cv=none;
	b=CD6IErYpWLQ+gSWxW5NJ4cDNQHPyCNn7u8+yWh2Pp/czMm/ngVagKYSLyJagaCByVj5FLZ
	8vAkErnZLQCpZw00uFEoVCjSj5jscEr/fz14Qfp2DffUTFsTLCuNQuzO9qcHesmepz0v5X
	7kYKWorqivcItm013OzSoFqfq44jf7I=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so41011666b.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769084510; x=1769689310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30EptBzNKREQjciAE94dkKi4CBlW2pcTBovWP9se6eo=;
        b=BCaF5MOVQedtOnLjlpwDF8SxCyGWiXKpsPkzOtZb47HsdHpiiOMqOOi8JPpAlPwIPb
         GFMm4azEapqaUHTSmrFjP0cqq1qglv6Kq33yLFZvpJ6BSVZrKWu4S2NrCNpwlDvgij/2
         zFeb7PitALY4bYgTyrJGh6DAJ0VFzMK8KpYDsKN+uuP8kDOXZqvVC0EQIJ90LbNTBN3i
         vB8BvaSv2hWNiabDxkM5oIpM3qeffPDfkEZxTANWWhZCCRIjjFVlLk3oCqU8ai/YoYfP
         w9BR3sqHNpOseY3b7BN2HfC8EgBYOggnti77Dnj1jztwysvZh0pLiDoWvAZ3YjdGl0aa
         zJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769084510; x=1769689310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=30EptBzNKREQjciAE94dkKi4CBlW2pcTBovWP9se6eo=;
        b=QsAtYHicyUhGeWXYwPyKkvVBOb3inQiGpQA2tAnj1+aKxZsIyS+HKNr8ippVHngvhC
         aHurcyzLUHyxZpAS/yqFm/I6JN1y5lwKvYAGYnC3W2UG34Q9zcCPKuexagZbkteW1tcE
         Ujq3jQGQKhG4o4J6JRzaE+mW6TMKp0zms5aytxoHX54G0OyUe1HdnMCrhOrDpXagfcyq
         o4NsezmIFG7nGKusdh9vTA9VDjlhXkUJ4Zvmcmdn/YPits9NnB7/7AKArrZQRLVservW
         USmkudR+FfJF3nKynaqiD886zA8qRTm0WJ0MJ2scqdGBeu/7bdJ63AoWguM3cRM7Fkfh
         N8Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXTBadMDxN6BnAIDAqoXJcTN/z0SC9aCYj3uhyZCLtIByRC4Pw0enXje0Akyf29xmogTfaGeSnpjQ==@kvack.org
X-Gm-Message-State: AOJu0Yycz2WldKYp/fXDkeWP8tm5Vp+/ihVffEo2DdgkgYyX70iJ9K/t
	TV7lxCqcAgfg3CjImzCZHQWIHzPGJKPIrIwdJlHOxMIW9vXWLZxSaOYel8BCoQ==
X-Gm-Gg: AZuq6aIW0sCmkuiu6g/xXy7MQh35OhXljfc65/Szam6otNoZArKRg/8Xn2wSkU9EkJ5
	85IeThrnR2gh1eqH5p+RWlEzMmyCrNQwmm9MIOfAy29kJvsecCyxWJVebC8pzQqnhQrla5E3XFo
	cS6gb7mtWC+ePqPUzgzsHSyBWAGhAO2zSJEbyHmAwQw1sazMqohLY1A/JdFDxCejGEnnujVkJMf
	QUV/BFH+vCeRQiP7m59L0wlwcR0SOt7PWweHOE6UoD5YLeJysfJ7qmY2Tq4XvJEfnfw6xVI0b9v
	eHlFpIZCWVmjW/6GxErxh2b/uYeODrjfmFDOzxYW8527Q82mluX1Vc/yztX3VvbphdDUJJd/JUE
	D8M+MyaLCcNDdQ/48ULSn5kMsQ0V3PvGjcuIMQhbdtuPSEwwoUSjHPO4lk+40Zj0ieYRnCxrekV
	IUew2niVbqrrk1NAHGiQZa474ZUbNrbmogdMReqpeT6ljuP2QVz1lV
X-Received: by 2002:a05:600c:5299:b0:477:a9e:859a with SMTP id 5b1f17b1804b1-4803e7e859dmr122557745e9.22.1769077556776;
        Thu, 22 Jan 2026 02:25:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804706ef6csm51088835e9.15.2026.01.22.02.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 02:25:56 -0800 (PST)
Date: Thu, 22 Jan 2026 10:25:54 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Yury Norov
 <yury.norov@gmail.com>, Jani Nikula <jani.nikula@intel.com>, Vincent
 Mailhol <mailhol.vincent@wanadoo.fr>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <20260122102554.1cc7a2a3@pumpkin>
In-Reply-To: <202601220829.MgTMeqqN-lkp@intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
	<202601220829.MgTMeqqN-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 09201100007
X-Rspamd-Server: rspam07
X-Stat-Signature: dpxdsqd3deky75arijchjxiwefggoo9j
X-HE-Tag: 1769084511-390931
X-HE-Meta: U2FsdGVkX1+Iuaznj4QiHvvT+HC6znAGoIUvQJL4Cr5P5gV/ZvXKvp1wpJ+pOziSneDb2+MVeC3m9spYn0apFBz1JZNm2KpGWep7gfsGrYUyhsnpgXTEluuHgY183yf8IetcFzZGjKnG2GGJSnWZYf+tlE0iPuRa1ZztWAxzg2Hr1EQEHVyc534JBS8OngnktV4Y6SGy+jooONdZGMer+8arfc8I2Li1UdtTSWuIKJPGRbpP1daoy1ZF2/COuYoIM2BmVjhJMMPcFI8KbZ9VcJj6tDR79dRNu6TJE+o5wQnF+4qaxqi6c8TIltAboljVArbsiD9vYA4uRo2hI0ate/YLFJFqkY1F0LOJ9V7BC4nQw898AlaEs0J4nuMteyxwhmpiFXftevBAOO2rLLKXqh/1ekJ/c0cxIkZcuvdW19xQr937pMO+pO1DiLjEkTV9WVYLGf6pEr5Xb+cddom/yXpUF6fM9wc4Jl6N7AzodI56FmP4D+IlPEBcMQWlI5rZDQvzJ7ts/Tj/jUJf6XqcCYBKaCd/oAgzFDgrmyTu4stJpQBv+Yb9+/0CkeUrMkeoHGXlFmMnCF6a1DkEPgzxcupgj2+6Qn8L9yQKiHHq+Vbx64dnl2M6gjIcsOBv8MF+w1why99CjmB62zI5bvp2wkjhFT2Km/7a9oB6RlaNCjJ4TJax3LbqlOTw+HOepgHK5UR52OmfmXWFIXdoTy8dYtW5XjHuEOlDozfXrtXdKjpIAVtV3lMXNPUh9s1luC25QeYocc5F1pQc+wCykY3WSStDSpfH1Ohh2JOgTuhpeihgBeQHywXIXLAGsPwGVmhBXCmMYaOB8nxJAFVgAH+rP2eQMRLWx5J+k87TO31f1DP0I91KONeGx6tizX3jaFxmV3qJETu28K8NKUXMWLiEyy83Llrp6pV0PoGDpy5S7pA7YZAqJdWwdt2O7A2i75v/+jP5wg7EAkg2hBEq9Lq
 E/x+Rz/k
 zCfJ9v2xcJXIIb1VGHX7JMqvvvFLnPHmjY7q8SHTGDmXLKU6FeyD8xtZt52iT88AACQaWNmjtQUibEas4cZcjKCA1pMb3kwmrvyJ0XerQ3UV6XIqfk4vrNyzuydFLf7nESU3u0FJ7FPgOTNhTeuBTCkI5EbLYAorUthwwj21vF7ENF4guiHmm2sKfQn+/3XLFFVjEANyQPckRmWBneEtDdK04k74wqjgl6rlDf+gTjJ/Ut8l+mMOb7EdWzvjEAdF6b65pwA0Lhpjndy/LnHVwA+mWPcX/mLw8/n4DKIg4jOcNLftIqyW4GgFidb62YXhR5i/Mgvn+K+gl//28wZ4+Qcyqi/yMkHkEKlY9Vo5ZTBFA2X4Mt4t9T2XxfK5nVoZ0QaI32bZL2eCzqMcXT9ItpZfs3xoFNNRKa3hMe8QM4IJDozlkcx00BvQT3kFBBzBcjfg2os0C7edIVDlwdI78F7vZ2sINiZnHRofGbVT0NIrPRvNLUgUrmospPvcEpaltIB8Rg1aYveYk8hWsi108MWT7fgW6gTrctT8BpjkurnGPQaVxqL1lEMxwWLHFEk86JqVPFqYGn/QNMLPmDJvACP0APzW6pne957t44TaTO0OdaoRn9WsaoxH3F42CS+9g/TXd61cbwbUprWbgJwd7jjP4A6D9G8fdAcJfvjF8kGyk75aXeBqaaapO2uxgvguCixUqheCplx322W8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 09:11:53 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on next-20260120]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
> base:   next-20260120
> patch link:    https://lore.kernel.org/r/20260121145731.3623-12-david.laight.linux%40gmail.com
> patch subject: [PATCH next 11/14] bit: Strengthen compile-time tests in GENMASK() and BIT()
> config: s390-randconfig-001-20260122 (https://download.01.org/0day-ci/archive/20260122/202601220829.MgTMeqqN-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220829.MgTMeqqN-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601220829.MgTMeqqN-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/s390/include/asm/bug.h:60,
>                     from include/linux/bug.h:5,
>                     from include/linux/mmdebug.h:5,
>                     from arch/s390/include/asm/cmpxchg.h:11,
>                     from arch/s390/include/asm/atomic.h:16,
>                     from include/linux/atomic.h:7,
>                     from include/asm-generic/bitops/atomic.h:5,
>                     from arch/s390/include/asm/bitops.h:75,
>                     from include/linux/bitops.h:67,
>                     from include/linux/kernel.h:23,
>                     from net/core/page_pool.c:10:
>    In function 'netmem_clear_pp_magic',
>        inlined from 'page_pool_clear_pp_info' at net/core/page_pool.c:721:2:
> >> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers  
...
>    include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
>     #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \

This might be a real bug.

The bit of mm.h is:

#define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELTA))
#if POISON_POINTER_DELTA > 0
/* PP_SIGNATURE includes POISON_POINTER_DELTA, so limit the size of the DMA
 * index to not overlap with that if set
 */
#define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
#else
/* Use the lowest bit of PAGE_OFFSET if there's at least 8 bits available; see above */
#define PP_DMA_INDEX_MIN_OFFSET (1 << (PP_DMA_INDEX_SHIFT + 8))
#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && \
			    PAGE_OFFSET >= PP_DMA_INDEX_MIN_OFFSET && \
			    !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1))) ? \
			      MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)

#endif

#define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
				  PP_DMA_INDEX_SHIFT)

I've no idea what the values are, but the 'hi' bit number must exceed that
of 'long'.
The __ffs() probably stop it being an 'integer constant expression'
making it just a 'compile time constant' - which I added a test for.

	David



