Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B24CACD37AF
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 00:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD576B0005; Sat,  9 May 2026 20:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D976B0088; Sat,  9 May 2026 20:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CB16B008A; Sat,  9 May 2026 20:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82B6C6B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 20:36:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01C8F40303
	for <linux-mm@kvack.org>; Sun, 10 May 2026 00:36:41 +0000 (UTC)
X-FDA: 84749644644.12.5655EE3
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D05040005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 00:36:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RjtgBFF6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778373400; a=rsa-sha256;
	cv=none;
	b=sFXpidjJHZGxvgrEoXhypxnzl/MBRscajVVqgvmQoonGBsF+qS5U+4oOIfHTUN0Jj+z/LV
	JMTN6Jc49gxx0El/XRAXpxV5xUkiWilHf+kPeYUBO+7rQ8Yw8xQYSEyaM68Glx+LsNMAl/
	fip3he/V/vErR4JQzedTMMJmrRPqX/A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RjtgBFF6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778373400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMk/T8m2B72SvHR75gb7Fq5LKN2MIDxQg2HJVr5A6AY=;
	b=sSWqRmXF7UrmA6XsZQpKWq+VmzUDxjPwWTL/inb98MY+o6b0wi7KHQwlcFwxqRBJLMiLEg
	w5CGb0I/mCuXeLHcmQb5Quu+GvrdzdNshmE8b6IX0UMOJqJPgJLvUAy4cL9mhkGQtt7f9j
	bxavLJBq4U4tFfmsfc4m38FBrt+AX0k=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c80203b9d7bso1219150a12.0
        for <linux-mm@kvack.org>; Sat, 09 May 2026 17:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778373399; x=1778978199; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sMk/T8m2B72SvHR75gb7Fq5LKN2MIDxQg2HJVr5A6AY=;
        b=RjtgBFF63gP5QwIvfw2rKSVJS06qPXTs6XGq//9lfxxeHlw4Gyxy68u3I770kUuHJ9
         EUnk+oxMAaeTZHHyi1lQMBSlRtchJUKcQTFJczVbXEByfG9V4RuRCfTsdHAk0p1X71mZ
         knkaIW1PS2AsA40DbvLpDX8EgrCooWdZkthD0BKSi3fQ1K90Rey6zA56qk6pbyQJCblm
         ny3rDxpfMfzXrcP4o8e4HzhL7jLlvPYXyiulj0X0a5b4wdXptDay7obtOlFGo5282t33
         gXDvee2gzEqRqGFjnK1kTerSiVfj+LWGHS/wHlokomcmZg/bNdfLm8fG8QmIH0C+igZc
         tVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778373399; x=1778978199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sMk/T8m2B72SvHR75gb7Fq5LKN2MIDxQg2HJVr5A6AY=;
        b=PutRngUtKaedoE46VebdkDdOk+aQs3J3vUMzuYBO+PeDn4WxG1iZuklIiKwqjEPBAg
         xk1O3zgKEX8yuIt1e/KmTFja0dJ6Wh8BMw7goVfy/yVffYQOGN6L2JFRxyuu7y+BQR1b
         wWvN+FPhLdE5JFKwy/SoiEO0/WmjBCtwPMgE/Anx3uQLaBVXYNWyX4KjO9tFbHFDUdJO
         MZvT0ZxL7g9RnPCWySkHndxLq23Eddt7kArBIiSBNUCoHPiE5Jz3BYckF/dhLx1Qsw2A
         mMCKM/WGnGsZBaY2MaFWD23W3ejmnqjgMSVTAk2BfdoZ24WdPU+kQhjhreBe0hcmGYZb
         J7PQ==
X-Forwarded-Encrypted: i=1; AFNElJ97hI03ZDTSGwJYYqTICSqzjcncz6X2DZsKMQsPCxCpGd76oRrUNS7Evxiv+G1cMM6aBECbZA3Nqg==@kvack.org
X-Gm-Message-State: AOJu0YxtfBFGWBepMOWzaRSxuRnjclh9VpjcMqMRbrzRplbT9V3gLDHR
	KwcATbdO6ouUgV0ERAeNUNBOxjaKPGBZbETi8YBjmjW+lziEB04LNC8g
X-Gm-Gg: Acq92OGZ/CJ2n0KQqdSaWzfwev/0fpEfwGn96GuWD5juXSvrmPPl/Ktzi7CPCbkzQk0
	eKP8XiDf8gRWLamw5fGG8OQHkyfuz59YCf992FibhOb9Uys5z9PuOSOHOWxOyXejAfJpqs7ZOQV
	VR4NjuzYcBH926CbdQt1Aka/OyeQRQ2J+zrSQlY3iEJUTyIfbVyRWs0Ky7f7jkxdD/G5BXe358O
	N1iW0kbFIJAvqD3V1/6o8b/eFunketTViBEEXUF/Iirey3nbBPb5G4HYRX3lf1WZvnhSB2xmjgg
	8r4tER4ihhvxL9irsiLlA23Ake4ut8H0JcchHFnUJrsQsj0vVsRUGULk2uQep8K1RjYR+I/WsKX
	YTnvuilyaSRw8VqBJ0n0PlIRkvQaiQLLr7FM3KVqt5BVsWOoDmRYWZEFvgWmNVuRLPyBQ3g5pRW
	DBgOkfUtHgzKdqDFJ19bx5zxtkpODUnOunEEhbwDt+s42Ia6A=
X-Received: by 2002:a05:6a21:3390:b0:39f:94cb:1bc with SMTP id adf61e73a8af0-3aa5a901f0amr20946611637.1.1778373398887;
        Sat, 09 May 2026 17:36:38 -0700 (PDT)
Received: from localhost ([154.39.63.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826767bf53sm5290343a12.6.2026.05.09.17.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 17:36:38 -0700 (PDT)
Date: Sun, 10 May 2026 08:36:34 +0800
From: chenqiwu <qiwuchen55@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, willy@infradead.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-ID: <20260510003634.GB5833@rlk>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
 <20260508182932.ee1931dec680db80a8a8e660@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508182932.ee1931dec680db80a8a8e660@linux-foundation.org>
X-Stat-Signature: 7ujz6b3f31x76d1cac4aohr43334ns7t
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D05040005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778373399-555461
X-HE-Meta: U2FsdGVkX1+c6Wv5X1aO+BzMvkCUOK6eDziQ20nu9Rd6o9xHg9l1/n9o7JP5mNbt+C/ZQ0rLPb8DyzrP0gXNolIvBCI5rNkk7+2AIFgCEUMP1LiPsUtxoWbqw7fvCORTXVK1VzJrElYvrJJZPmxTq4dleVMqqhFBOw9BxEMsRZmBucatnW7C5OMGwWN2NyKMzRKU9Vq7tgcFe3ADLLUVN2y5k3ng+mbbdemHvsh/7TwbI/50SZlGmfu7jCEq1WCXcL9lekRMF3zoRyPsb5tRqZmrYjfXRfhdqANWGJwvWpI6HQi/f9AIxFJQE0ln25AjLucilXYhS6TKhNbpedZqBLqLFMJsQ6MmQOBpyYydFNhPrggf3jMSO3ccwm+aXrXNqwrEZaAXuGpBylgaEv1if6SbdmuUzo3DgQDmbPq3n2NZe7Ys6bkvLNDn9KZsb3zYfl7eE1iOK564Zp1PC2S+D+HiGxGPRpADacHlsnuNXu2a7fvoSKrHUo9kPLfiwo3I0RBJ6hzVA6E0Pdp7p1OdnENI5R5xjb6vWEhZ7QfbkHjAKVU9PVN0tXf/tWJZhD3yjIggb0bpQrGouWAb3o/ITTJm0SOLoVOPqT2o5OMaGFjmflVhdbjb0Jopf9fRdlCjtqtaPOhMOrfgfJyu9KW6OrKI+SHvrTEy1vOLbuhB70kjTuRe9x9OFoyrN2wbAwvxzhxaO+wJP8YohP2jhDJankTlhcAtGap7vEfpuawrahf5kUIehGgd2IFq/cPnpcLYEvXaj3EiuVw00goyW53YRsnImF6+27TsPAjxeGDcwCJEtYUdg87Qj3mP7xxE0Q+Z/d+w4GGhhGJV7UU9pWOBeFjH6lPDRcmgoiXwq2eN/1hMBhmmvonYryRRCQw6NOStFR5IQQT7zaqE7qKkpvS7p8eJzannqkyGXEPl+AMfR8iOmxlqbWoISArGpDrQNbG3zxBB6BW7XYA5BWW3NLs
 QpVnOK0I
 eAjA/VuBoOc97zycDOBmf93LlDOqgLnGmqvy9x25AOerGrslcYEZqIMF+JM0yiMY1/NA+ua7SZZcgdw5WK9sItsRVZ1HokX5whtdl9mf1aKpuwNf4ICGZwVY4Z3VnM6niaJLFFTUO6YNlWKBcziVHQpwwZIdIoiuGXwR+0Za5t9IneF7e+PYVjSG7PQdxzOcN77dSfmctvCcPbvHHl1Fh6pkMgRlD5DQI1DGWyCxBVTBEg7otfrXODGNBoqISxEJfZVjDeons103aTiv0rXqAKEcPmpCYT1MPhbuajVqzlFB9q3LL1RX7E4ePOORJVANP1j7m9lCN+1hF1N+3DRXoSJQm2iI7P5AykLDZ0YVgdsbdluwTSE6HqP/aXku5BnYUb+5TTsrNaK38YOcJCAhsRfDCVEkXECLyTp40LbiTushX1eUL4YNIPXulaCXYazXEINiPiodS2p1HowsFXoO1CRNWlDBDfiMGfIVKwifCyMUDk2dgOU+bvIwsmZ1vdG3ukGZUwk2pRAglxFUydm4DKblZ8UqQzkd0w/aYt9ISNGuSUYSLswJxZ2ee4lzIR4ID88HkyeNR56crgEgTR9S9jBeLT+HQxqvalMB8T1M8nJoPAjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 06:29:32PM -0700, Andrew Morton wrote:
> 
> Applying this to 7.1-rc1, my x86_64 allmodconfig blew up.
> 
> 
> 
> In file included from ./include/trace/define_trace.h:132,
>                  from ./include/trace/events/vmscan.h:602,
>                  from mm/vmscan.c:72:
> ./include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_write_folio':
> ./include/trace/events/vmscan.h:358:19: error: format '%p' expects argument of type 'void *', but argument 3 has type 'long unsigned int' [-Werror=format=]
>   358 |         TP_printk("folio=%p lru=%s",
>       |                   ^~~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
>   219 |         trace_event_printf(iter, print);                                \
>       |                                  ^~~~~
> ./include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
>    45 |                              PARAMS(print));                   \
>       |                              ^~~~~~
> ./include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
>   342 | TRACE_EVENT(mm_vmscan_write_folio,
>       | ^~~~~~~~~~~
> ./include/trace/events/vmscan.h:358:9: note: in expansion of macro 'TP_printk'
>   358 |         TP_printk("folio=%p lru=%s",
>       |         ^~~~~~~~~
> In file included from ./include/trace/trace_events.h:256:
> ./include/trace/events/vmscan.h:358:27: note: format string is defined here
>   358 |         TP_printk("folio=%p lru=%s",
>       |                          ~^
>       |                           |
>       |                           void *
>       |                          %ld
> ./include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_vmscan_write_folio':
> ./include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
>   354 |                 __entry->folio = folio;
>       |                                ^
> ./include/trace/trace_events.h:427:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
>   427 |         { assign; }                                                     \
>       |           ^~~~~~
> ./include/trace/trace_events.h:435:23: note: in expansion of macro 'PARAMS'
>   435 |                       PARAMS(assign), PARAMS(print))                    \
>       |                       ^~~~~~
> ./include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>    40 |         DECLARE_EVENT_CLASS(name,                              \
>       |         ^~~~~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
>    44 |                              PARAMS(assign),                   \
>       |                              ^~~~~~
> ./include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
>   342 | TRACE_EVENT(mm_vmscan_write_folio,
>       | ^~~~~~~~~~~
> ./include/trace/events/vmscan.h:353:9: note: in expansion of macro 'TP_fast_assign'
>   353 |         TP_fast_assign(
>       |         ^~~~~~~~~~~~~~
> In file included from ./include/trace/define_trace.h:133:
> ./include/trace/events/vmscan.h: In function 'do_perf_trace_mm_vmscan_write_folio':
> ./include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
>   354 |                 __entry->folio = folio;
>       |                                ^
> ./include/trace/perf.h:51:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
>    51 |         { assign; }                                                     \
>       |           ^~~~~~
> ./include/trace/perf.h:67:23: note: in expansion of macro 'PARAMS'
>    67 |                       PARAMS(assign), PARAMS(print))                    \
>       |                       ^~~~~~
> ./include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>    40 |         DECLARE_EVENT_CLASS(name,                              \
>       |         ^~~~~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
>    44 |                              PARAMS(assign),                   \
>       |                              ^~~~~~
> ./include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
>   342 | TRACE_EVENT(mm_vmscan_write_folio,
>       | ^~~~~~~~~~~
> ./include/trace/events/vmscan.h:353:9: note: in expansion of macro 'TP_fast_assign'
>   353 |         TP_fast_assign(
>       |         ^~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:289: mm/vmscan.o] Error 1
> make[2]: *** [scripts/Makefile.build:548: mm] Error 2
> make[1]: *** [/usr/src/25/Makefile:2141: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
>
Sorry, I ignored the rookie mistake which I built pass with the aarch64-linux-gnu toolchain.
Could you please apply the following minor fix change based on this patch?
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -346,7 +346,7 @@ TRACE_EVENT(mm_vmscan_write_folio,
        TP_ARGS(folio),

        TP_STRUCT__entry(
-               __field(unsigned long, folio)
+               __field(struct folio *, folio)
                __field(int, lru)
        ),


