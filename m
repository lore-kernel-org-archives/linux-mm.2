Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050C5CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 05:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBD190020D; Fri, 15 Aug 2025 01:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C9D8E0002; Fri, 15 Aug 2025 01:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1F990020D; Fri, 15 Aug 2025 01:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58CC78E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:51:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10ECA117D77
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:51:57 +0000 (UTC)
X-FDA: 83777920674.30.48EE213
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3E52840004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:51:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Bhed/ZiC";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755237115; a=rsa-sha256;
	cv=none;
	b=XMCsKT+vfd/KTk5LtOiUq/HW+g5V7ZZX48XCzL+sf2h1nZSFUlecYTW4y96apf9Bcl5El3
	zH7N7JUUKnir20EkP96exXiqyTt8jFwd1aTVcWiCSj7lAa/eOjF4Mtcum2OLvtjkTcm9Qk
	p5xv/pHzG4UuwljU8EcdMSSWfJIghWc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Bhed/ZiC";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755237115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yPIUpNhjQ6AEsRDjGeq+2bkZwxUUqcPh43FblPu4aOQ=;
	b=hw2HXVg+HT4CCimNI7VzS3usquuIHAib2uHqNck9L3gCqxkUH15KUC7B8c+TayJL8xzeOG
	Q5EpBLZ9XvLoyNotdPnTaTdjfP9T16ZcGHeFa1oeA3GawNSzWcSU36NIkHwLkmeRarUd8F
	alM2rcMGmOCdZRIGPAp1EYaiWyy3J2M=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e39ec6f52so1215843b3a.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1755237114; x=1755841914; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yPIUpNhjQ6AEsRDjGeq+2bkZwxUUqcPh43FblPu4aOQ=;
        b=Bhed/ZiC2GlGVF2wYYh8H0yoKDTGgHoUTYX/4t7YjomBnS8DTQPsYT5RoPZHpme19D
         7FKbHYOQsvrtrdsOdsFBiCT+5XyfR+1h0QrdDusiLkSPO1fUcsB1F74QsZ3MkYX8NdpY
         DNbSVeJy2nC8RkW8l63wWNtBSBaHUT/3/uVnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755237114; x=1755841914;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yPIUpNhjQ6AEsRDjGeq+2bkZwxUUqcPh43FblPu4aOQ=;
        b=PeN5SvHF70Ag0EFDp+0u3fRwOhctLCYp6EAyxDE1zOwUqfs2u/0P+0f4x8hvpme0TP
         y1Q/6YB7l9pukj5+06aJlKGa3bsc8ECWs68QUSQ1aB+X+16sPASCKUIO3Nf1vY/nXi6i
         BtfqvWIBd6dgWk2/hYmW94BAXyXIDsxrpwR2ZiPbTAAmtf30/iekVd+o1dK6/Swncr6u
         BtfszcGHjUQ7JoArW0UPoKn6+k85nVK45DY7t+roXVH6WhSR4DL08OKMjkbu1tIu5JBV
         Dr9WIB6y1Jk/Ax8HDvQqCm1+R49grs7pkixE1WuwVzgeH0dppJrAQo69NzKSS2mr0P4C
         K5ag==
X-Forwarded-Encrypted: i=1; AJvYcCXZUB5zQpDb/5/L/g7y57KSs17obFjWBlW9sCB7Rp1+ikw2GsSyC3J61kYS0YHWUX1CcnIpoHHyGg==@kvack.org
X-Gm-Message-State: AOJu0YwAA5RfdQnsiNtyLBqf3skLZIhvtlzX2UHF4iKi3r6mWAzi+bX5
	yTcRP+K7H1kigj3KjRbt3Sbb/eGPdacfJ1TIegd4RNXjz86WH2ddcSwz3f3j2UdFUw==
X-Gm-Gg: ASbGnct1RWen8AFknkj6MXFUG5Oqv8lAuyIvZUteq3RCg24KAr6c2aWXjqu9hROXH2P
	T5qX8QmM6kLaNxFjetXjT7u/S4dOjo5djoDIz/hKxSkmbG4T7LE5elukONGHoS75i1fWOQvn8dZ
	METFDMQVea/FusyVw/XGQnde+r7FUkqlQc1JxIv7cG0oYxMrsyqHq8LlBK7LWlh3vlErSFCXECJ
	CRxRD2rBIODJ1zpGdpZTxP4ZHgVMm8gQuKV2k4c6ZKE548WS8myLhrNSbtgVZaLp9fnl0ksZop7
	GvJqyxc/4KLj/wcZJEhX/TIE2AlXnftEQhFbA7d/Z8313Zb5aTgpOdKWquDZHO6rYdqfa4mcGI9
	JwyzTNlH3S/4LEUYPCoNoWLk8
X-Google-Smtp-Source: AGHT+IFJSyBpiKOo5C13YIk4+PTK+ebPvaiWmR1lvuCNUWOKdDoo+4Xpqje9qDjgOndVHMPSNmSjOQ==
X-Received: by 2002:a05:6a00:2342:b0:76b:f0ac:e7b2 with SMTP id d2e1a72fcca58-76e447cd663mr1100191b3a.13.1755237114143;
        Thu, 14 Aug 2025 22:51:54 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:df07:bcb4:bd69:d61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4526d1ffsm379278b3a.16.2025.08.14.22.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 22:51:53 -0700 (PDT)
Date: Fri, 15 Aug 2025 14:51:49 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Suleiman Souhlal <suleiman@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm: swapin read-ahead and zram
Message-ID: <7ftwasufn2w3bgesfbp66vlchhpiuctxkhdxp24y5nzzgz2oip@pi4kdyqkl5ss>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E52840004
X-Stat-Signature: 3mnyjg6x67txu5nj5w39abrqrkfs3hef
X-HE-Tag: 1755237115-532940
X-HE-Meta: U2FsdGVkX1+QI5433JIgs0LEdNRVW+mIfOPYPTcQpnI7X5O3m1ynGdVi213/5XDTZMEtSUE+9vUrA17Lq6BpcZrpr7thw2ckiWLZmawaxQUyxa8xuYQ9xQBU/gT9qc+F2dY5K9Qenp8xKUDgxZSxq8efltyOAYksXGan7O1InyVLPJbkZJ+I5vsRB3YC9xMPFZaMEiK/sQ0tLPp7pDTHUHTty2VbjQ+le4vxLlBIrN0/s2Ov+1fIXV+Grr1Am2uOYewvRY7bPoIy1aDoXrCVzD4By8156aSlVc3HxKEp2r+BM/xl+tCynLYeBYLfpb99Q/OTnTQgXi2Gsm1thq+dvkK5tWuxcxEtAxiirrRY/Ip69rEoR9rlA9Iam7IHR/4h76pBmKoEtVt5u+9n50J9PByYOSEduE0S3F9d8k2M+jnaHvOBImYa+vGHEooYohLcZL1GFUHcbFJaAVIJOOsJ9DS+HB9EkgtcEM1SvXAQKkSteRkR00lDoCz0DIY0DqPitV9SjlA7NccaYMt1wo+mP/L5oze7AHBavt013v5Ogczn4QUtaSmUVxZ8EWLKUMnrM2Xfm0BRPZr5jJp2MA3IoCg/EI6VwgoCYY5CXW3YRIgQU3TVc6R8KHQvLv2Jcnh79ZeLpHVmGuMhlhkN/2cVv+XWY/hH7G6jMqtTcH0Cu7uXT/60jE1OFInjnxC0fQEQwBUQc2rDW2GvGvUnkAWFnECFRN6HL2ftrCn/KWFgzqYvbyEPdwquCWWRxaOXDDPyI3+BDJs9Ey42pVuamjmW1oJ1obDdI86ZbluCbLyXwqV7b6KeaJ4m0rxzLRNihd/n5tuedjUGz6UWFUAVc49pcYFx6wCdDaBjFbk3d/yaGCbleum4OX7ZkLyoFlOwHEys/8q/XIJ4kRDa/+LhghE2RYO9nX86g7WVEK/VYAyEfiNemjFhEktIsvyxxjua/uIH4NXkljNKdJxWB3FhStf
 NrnBm7Mx
 jjuK3o48veAwujEmlX8qXOTZ0Md/OKdEEMNLduM2z605hiNT2cg1XbmrY1Vz/bGRmPIkl7ktVJ9nreTJe0gBbBS+g/ILXO41Bcf3qJpps1ZvohgZbBlWC7PXB9yDMmYq1QyMdCmIkXipDByUJvuQ5oxgvEfl1H3djpe2FCJBqAmD4Bki/1GSTn6jRNWz54xLnl1TnuBAUKAh2bCRcFduEH3fd7UqxJSqaDEI+YSWH5q1z0wr/fuqca1jFQW2+EJwM283fceuRtpw1LLOmVH0bZ62B0AiYwEtEPioV/LZFPdHXWRyVX3M899NPWZH83i1bXW0FfNPhNjx2F4Fk6wN0f66fV0D7eM+mqJS7UJi29gspB9I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

We are seeing an unexpected behavior under standard memory pressure
test with zram being configured as a swap device (I tested on several
LTS kernels: 6.12, 6.6, 5.4).  Namely, we observe multiple, repetitive
reads of (compressed) zram entries, sometimes in a very short time span:

...
[ 1523.345784] zram: decompress entry idx:1615265 zsmalloc handle:ffffa28c8be3ee70 obj_size:986 num_reads:188
[ 1523.365401] zram: decompress entry idx:1615265 zsmalloc handle:ffffa28c8be3ee70 obj_size:986 num_reads:189
[ 1523.385934] zram: decompress entry idx:1307291 zsmalloc handle:ffffa28c70100b50 obj_size:788 num_reads:227
[ 1523.405098] zram: decompress entry idx:150916 zsmalloc handle:ffffa28c70114fc0 obj_size:436 num_reads:230
[ 1523.475162] zram: decompress entry idx:266372 zsmalloc handle:ffffa28c4566e5e0 obj_size:437 num_reads:192
[ 1523.476785] zram: decompress entry idx:1615262 zsmalloc handle:ffffa28c8be3efe0 obj_size:518 num_reads:99
[ 1523.476899] zram: decompress entry idx:1294524 zsmalloc handle:ffffa28c475825d0 obj_size:436 num_reads:97
[ 1523.477323] zram: decompress entry idx:266373 zsmalloc handle:ffffa28c4566e828 obj_size:434 num_reads:111
[ 1523.478081] zram: decompress entry idx:1638538 zsmalloc handle:ffffa28c70100c40 obj_size:930 num_reads:40
[ 1523.478631] zram: decompress entry idx:1307301 zsmalloc handle:ffffa28c70100348 obj_size:0 num_reads:87
[ 1523.507349] zram: decompress entry idx:1307293 zsmalloc handle:ffffa28c701007c8 obj_size:989 num_reads:98
[ 1523.540930] zram: decompress entry idx:1294528 zsmalloc handle:ffffa28c47582e60 obj_size:441 num_reads:386
[ 1523.540930] zram: decompress entry idx:266372 zsmalloc handle:ffffa28c4566e5e0 obj_size:437 num_reads:193
[ 1523.540958] zram: decompress entry idx:1294534 zsmalloc handle:ffffa28c47582b30 obj_size:520 num_reads:176
[ 1523.540998] zram: decompress entry idx:1615262 zsmalloc handle:ffffa28c8be3efe0 obj_size:518 num_reads:100
[ 1523.541063] zram: decompress entry idx:1615259 zsmalloc handle:ffffa28c8be3e970 obj_size:428 num_reads:171
[ 1523.541101] zram: decompress entry idx:1294524 zsmalloc handle:ffffa28c475825d0 obj_size:436 num_reads:98
[ 1523.541212] zram: decompress entry idx:150916 zsmalloc handle:ffffa28c70114fc0 obj_size:436 num_reads:231
[ 1523.541379] zram: decompress entry idx:1638538 zsmalloc handle:ffffa28c70100c40 obj_size:930 num_reads:41
[ 1523.541412] zram: decompress entry idx:1294521 zsmalloc handle:ffffa28c47582548 obj_size:936 num_reads:70
[ 1523.541771] zram: decompress entry idx:1592754 zsmalloc handle:ffffa28c43a94738 obj_size:0 num_reads:72
[ 1523.541840] zram: decompress entry idx:1615265 zsmalloc handle:ffffa28c8be3ee70 obj_size:986 num_reads:190
[ 1523.547630] zram: decompress entry idx:1307298 zsmalloc handle:ffffa28c70100940 obj_size:797 num_reads:112
[ 1523.547771] zram: decompress entry idx:1307291 zsmalloc handle:ffffa28c70100b50 obj_size:788 num_reads:228
[ 1523.550138] zram: decompress entry idx:1307296 zsmalloc handle:ffffa28c70100f20 obj_size:682 num_reads:61
[ 1523.555016] zram: decompress entry idx:266385 zsmalloc handle:ffffa28c4566e7c0 obj_size:679 num_reads:103
[ 1523.566361] zram: decompress entry idx:1294524 zsmalloc handle:ffffa28c475825d0 obj_size:436 num_reads:99
[ 1523.566428] zram: decompress entry idx:1294528 zsmalloc handle:ffffa28c47582e60 obj_size:441 num_reads:387
...

For instance, notice how entry 1615265 is read, decompressed, then
presumably evicted from the memory, and read/decompressed again
soon after, almost immediately.  Also notice how that entry 1615265
has already went through this cycle 189 times.  It's not entirely
clear why this happens.

As far as I can tell, it seems that these extra zram reads are coming from
the swapin read-ahead:
 handle_mm_fault
  do_swap_page
   swapin_readahead
    swap_read_folio
     submit_bio_wait
      submit_bio_noacct_nocheck
       __submit_bio
        zram_submit_bio
         zram_read_page
          zram_read_from_zspool

There are several issues with this.

First, on systems with zram powered swap devices, these extra reads result
in extra decompressions, which translates into excessive CPU (S/W compression)
and battery usage.  Along with the fact that each decompression first requires
a zsmalloc map() call, which may result in memcpy() (if compressed object
spans two physical pages).

Second, the read-ahead pages are likely to increase memory pressure, as
each read-ahead object decompresses into a PAGE_SIZE object, while we
also hold the compressed object in zsmalloc pool (until slot-free
notification).

Setting `sysctl -w vm.page-cluster=0` doesn't seem to help, because
page-cluster 0 limits the number of pages read-ahead to 1, so we still
read-ahead.

Can swapin read-ahead be entirely disabled for zram swap devices?

