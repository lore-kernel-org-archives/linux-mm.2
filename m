Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADF6C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 17:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A149A6B008A; Wed, 26 Aug 2026 13:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6826B008C; Wed, 26 Aug 2026 13:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B83B6B0092; Wed, 26 Aug 2026 13:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6260A6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:57:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47278A2E1B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:57:36 +0000 (UTC)
X-FDA: 85144178112.12.ECB9A69
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81FF3C000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:57:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NzrR4lfh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of wyihan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wyihan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787767054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOyt5LoY374Qkpz6cQhUC33i8CoGf2Yn2cDcltrm0Cc=;
	b=yY07t8/rmtq/W5fciRfz/n0E9Tom0yHT6VGo8/JS2i9IGEAgKprg7yHjHSDKNVP/iFn44G
	BJEzDCXuK8QuySxh5MKgg0t/3u0XDzaSiet0/DBW/7fMsDBc3Oi08LAAajoxNAwf2fAeTE
	XBiN9n9T7zu451hqWh8pRzOMGwapRLk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NzrR4lfh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of wyihan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wyihan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787767054;
	b=4DQRSAoG8MeK9+BUBvM/JVaV7f4jXQ6UkLBlzV+WhywddfoDd63onxhFTTrBhRurs68NQu
	7a4Kek5ugNBfq6uismMImRwSkpowqepGvdFMy7q1XsFo0avm4nEKfoFr33bMCmufS3qmTi
	lqJKWj1LOzsBCf+srLVkId2d95cjuvU=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d3b440b97aso10675ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787767053; x=1788371853; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mOyt5LoY374Qkpz6cQhUC33i8CoGf2Yn2cDcltrm0Cc=;
        b=NzrR4lfh1yXP+zzlu3qtsyxpvIwHn2hlozDH6zMLiB4sBKFKWjhys2LTCvCvh9Shy4
         YYcXVUgDBJbbbY+Mprdqrv2vy5TUZfz/oI8/7OChl61sVCd1ojYRlu3k7+CNhuieVO1P
         hdyd++twGw4q0QzCzvYaai/0NENlr/twNfuNmGCQ86nZhEiV4vAwOVRz5KoAjxiIPWVR
         IQqruBtCr7/9SpnUUn5lRssq2aGZymG0eFRMPhovJxBpk76+EH/yrlmNvHYXVg8vlLMF
         N1wsGZeCJX6H1zDYoEUR4vgFjyzEXI2/SX3FcCUOfJqVUct0SiC8UyhPda4LZeEL46Fw
         WsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787767053; x=1788371853;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mOyt5LoY374Qkpz6cQhUC33i8CoGf2Yn2cDcltrm0Cc=;
        b=X88SkZM+Aado2kwGXHjah+Cg3oDMvUuWCmUhMa6dnerCD4vNRrbAf05GOz1ZycMJI0
         HJVj0omuSJ6ZBkyB62kzQzE6XVICcSZG5kdmj5Uhwi7MMfRvnR/5HSNz8Q8KDSA+REf7
         M9AeMz+qNz975DQuomLAdgdzuP94mopeRicOD3Sln5lFHsOxN/TjrVKpH0Tt4lO2gtYp
         a4DnKf++yEfw1x1ZOH8TW3JZdqFdcQ3bRJnTOeyHJa6YhDUn08/lZva08UAKb4XugLbH
         tuOK5rmYW+psasew9XwBMNCEK4BglRJGxE1OxFvt/vs14Rd9SHPkicjN7KxElo1G+A34
         oaTQ==
X-Forwarded-Encrypted: i=1; AHgh+RoFjbsIzVPAlODeevgfMbxtuFqJHrTpeZY5bvy72V6lgklAgrPwURyCE9/utXQfr47Dj9/3z/PAlQ==@kvack.org
X-Gm-Message-State: AFuF++mZBrnL9vOUME1gZ4M9KiHKDKxKRKC49jc5QoRbIPWkCfzt/RQb
	VQJ/osmkTAZ6MwnN5ll2Vkn4zvXbnPQGEbpXghr25/lyj1sJl3btVUmvB5dtUxKFxQ==
X-Gm-Gg: AR+sD133YlhFFLtAoztJD4Qgnq4/TdK0UWEv4gBOdL2/zn92bd8fN7SIQM75K63xaDj
	ljdulFA3xXg+DMw4iVikJBbXRriQeTDzZs9bJMbJ/Imygozcu4HgcpA+I2KX5lKK09iPx/Qy1r8
	Er992y6Eh1ZPIEL7TpdaayfuvdZ3qqit0PE6uc5qI65n7E8YB1v/qG3+0cWbkROzWm3vxHrCFk5
	TO/EuM9673nm4k1Iowddb/J/U+NXn23BbhLj9KKTmTzK85T1gPqSHSGLx1UeQ5RCTnn2e/clmwq
	TxmtPG+BCbVuG0mbESiXym43jeX5/4Mjc0TTKIUc9w4sKMHS+0NRM7x39DL1ui7aNdWHBulZbrD
	IjLw6pLMcdUn39ymTB94+Ea45CS5MNMZL/lYs94KlSE/u/XFw8G1DL6aFz/sfC7Vfrf7kbh9ezh
	kgWbm5lOm/jK8LZ1hcVJ+NfiY+1qD4eVjgUHmVHHW61JxYsa+xAcAdH71obQZ645tj/sqzOvxpX
	osODhpEpn03dPq0TN1tLg==
X-Received: by 2002:a17:902:d4c7:b0:2c9:b404:b55 with SMTP id d9443c01a7336-2d72a6912edmr556605ad.6.1787767052531;
        Wed, 26 Aug 2026 10:57:32 -0700 (PDT)
Received: from google.com (195.5.127.34.bc.googleusercontent.com. [34.127.5.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645d31e8csm9002581a91.9.2026.08.26.10.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 10:57:31 -0700 (PDT)
Date: Wed, 26 Aug 2026 17:57:28 +0000
From: Lisa Wang <wyihan@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, rientjes@google.com,
	seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
	dave.hansen@linux.intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v5 5/5] mm: selftests: Add shmem into memory failure test
Message-ID: <ao8pCI3AaUssIO8S@google.com>
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
 <20260823-memory-failure-mf-delayed-fix-v5-5-d97a5703e45a@google.com>
 <8a99f753-0713-4194-8eb5-90da0724e647@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a99f753-0713-4194-8eb5-90da0724e647@kernel.org>
X-Stat-Signature: k6u48amqoi9kop9skouo618k6tdgaqn1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81FF3C000D
X-Rspam-User: 
X-HE-Tag: 1787767054-893108
X-HE-Meta: U2FsdGVkX19LRcBqarRnFKUHKPzIRcE9vtlSTr0/6/mHlOqeD5Z/S27Ah+qbFpW2eser+qvZ/SjW90JAGMWVVDmaqpJa3x3Q7CHxHkw0j8xcPieFxvNV9Q20UnFh2UoEbeOmW7XGw7ajPXox7bznhsgRRPw/rDZnrCmwjeeviFDN3rVlqIgpsH/+C2FZL1/GKICk36VaDKqS1VD2mybErh7hVNYGZM7kUgNd+gVFMB7R0QTryMakrhnaffUt1ZOuCkU7FxMdSFCBkRXFC/SC87ZY0laaUXn2hXZcrMDG1bcvxRvO6M2O8Oz5prRlZZs3ldNy8KDvCdHG95LuO1ZcUG5avxBtgREwaublWTYquC5TrD9MF1M5/haQBBpelNMRxwdsrunL7qLRRPkAkfFJHw/Z9iXG41ojx5oGekDo3Az0o9ckl2pZmOHhV11uo8ElFuHacu+jFum5hTdKDBNSF8NjICMTUVvVldS0XO1lWI3+K3PViFNlWPNCixpdkxZpQPtxvBK6hJfOHuT2t99Ra6kzIkSTSBkqEv6pKLwYfdUKbJVTFIxkydrBYOO+Z9fplgPHFNqbLVIqZzl2RI8gJlUlXAZVaaBdqzxq5Hs+Zi+zBPhpmqOwLiUvxh1wssbNSivLMeT4rTaYxmW7taZsg2KDFeGTMvX+LHZjP7kmzqHim+OWPq+ODFIq3z6HWx7sqCzh0opRzQ+KUA67SagYLSAq1lyjTalO6pObqxVmK6MmE45yTiIbTAhVDT9HPW42J+xQr2DgCFFrnCE37m/5YLlTNXe78aeb00tIvdFYtGmjbFyJhsZt/dImVfZhbcahgthwR2ZNt5cxOhENQYR0JtJPpozsEJETyi7D1r64NvUNuBcH+v/J78KdhNsqjZC4oLVXONqKiWL/GoKhg/rS1PO6zz2Sss8gKKkRGKVWmrDaspHRqSZQe/vbT717GuBerZ4PcszBip4GAS1oYq+
 /Em5fweb
 a+GUVb29gtrtkw0FW3FM5yPbBG+YQzcHikL2jnbdZZQ3C50UOywauscXUutKdjU2B9zOjtN4YwHboHL6dxulpy5hGMTLHjGyw8dQ5XtB41oVoNfqsgb1dlXF6xRzKgVL/HFKWj1p7GLZCtybG95K7GV3bAj3ltoJD9WwBkrhng9/3GFqdqdN22Amv7NgzgSHWoQhOyxiGTiSXqloddoQxWhBL6byhV0h7jq9eoIOaJ9f5lktZ+SjkXCjdI4SivKuF/6M3A7INCgTUk0UXGhVutwNV4h9dtTIjD484Nrbd97SOJhaNlAT3zFUKUrecClzJRzPgyE6/AncF5OM8CPESf8ljnsllaTEFN+Q0UgxDk4i2Aq01b/WSk7po6CFp1MvJP9ygPxl2Ff22t2MJJx2x2mm8Txmhn1yU4sqjQ4WuopXqc0Vw4tSKMF1fqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:00:47PM +0200, David Hildenbrand (Arm) wrote:
> > +++ b/tools/testing/selftests/mm/memory-failure.c
> > @@ -20,6 +20,10 @@
> >  
> >  #include "vm_util.h"
> >  
> > +#ifndef fallthrough
> > +# define fallthrough __attribute__((__fallthrough__))
> > +#endif
> 
> This doesn't belong into this test.
> 
> rseq/rseq.c selftest already uses it.
> 
> I think tools/testing/include/ already provides it.
> 
> Maybe
> 
> 	#include <linux/compiler.h>
> 
> does the trick?

Hi David,
Thank you for replying.
Would it be better to change it to /* FALLTHROUGH */
like the rest of the mm selftests?

If we prefer to include <linux/compiler.h>, we can
certainly do that, but we would also need to update
the Makefile and fix a redefinition in pkey-helpers.h.

--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -37,7 +37,7 @@ endif
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules

-CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES) -I$(top_srcdir)/tools/include
 CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm

--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -22,7 +22,7 @@
 typedef __u8   u8;
 typedef __u16  u16;
 typedef __u32  u32;
-typedef __u64  u64;
+// typedef __u64       u64;


Lisa

