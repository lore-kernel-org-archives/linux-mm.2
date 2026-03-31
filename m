Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B87BFF60CF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414136B008C; Tue, 31 Mar 2026 03:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB4E6B0095; Tue, 31 Mar 2026 03:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328126B0096; Tue, 31 Mar 2026 03:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 250BF6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:13:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9A698C687
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:13:40 +0000 (UTC)
X-FDA: 84605493000.01.CA023C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 885DC4000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:13:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YUzq448/";
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774941218; a=rsa-sha256;
	cv=none;
	b=GMIBmZN3Dk+2AP5HJZui7auLpqFuuDFek/tvAZx6waC29rYSXjotNtqhRdMmxfpJvWJCIU
	K7GC6OFoVmrxDrW971ibhNxRbAJBQ7VWYGeXgJU0+Ez8zGfpzdGzRnkjRkT3Rlw+nXXNy/
	i24+vkmAbZ67xnw8zZTYxoWO1vY2Kbg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774941218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHJZFHs0FUFKH1nrgiAFz2Owaw80mef2K1q51SyxNfY=;
	b=xNAeTD70Yt/aE46ZctCzjnxpwvHUCx38g1u6DtsgJshxcK5wzLV5TB6T4D89lawzG4XN/f
	UfAkGxRLBNZEofMFmJvKc6jlS81XxjUDrV6ZLrWpeAK6kDeX0JfMY9oPZsA2ZVp1I4PpNK
	7j+DNVo0gEDGtIapRQtqvcQLr+CtQfs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YUzq448/";
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774941217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHJZFHs0FUFKH1nrgiAFz2Owaw80mef2K1q51SyxNfY=;
	b=YUzq448/f0fGRevRn662kdIpVO2CQUd2N+Oh00l0EW1q66LRnJFCKUP2/m4K/HYKB8xyaj
	HooYnSMmrQvtfo9KJpjcPUabiGistvVXrWZj2yTGwkng7vWXgvrrmz/o6LWvLB2kc7GGIE
	IeG1FnILwVzR3aJW6j9zBwGbiZQHro4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-t3yxx_tIMjuJKp3iamyiJQ-1; Tue, 31 Mar 2026 03:13:31 -0400
X-MC-Unique: t3yxx_tIMjuJKp3iamyiJQ-1
X-Mimecast-MFC-AGG-ID: t3yxx_tIMjuJKp3iamyiJQ_1774941211
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35da1c703d1so2306710a91.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774941211; x=1775546011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHJZFHs0FUFKH1nrgiAFz2Owaw80mef2K1q51SyxNfY=;
        b=GgIm8wlJxOodwMaMHcz8GUE5QcZ/oQbcDk13aMFwaPMo4b8rmAgd3gnVWJz8jTNpL0
         xJyVo222/z121zRMsI1+gQ/7EWSDyjzdg0ZdMkGTKq2OKrVu5KQy7PQmzqb2wmDXYDK0
         3LWTk9jIPfZYWjQCW0itPAcVPscFAOFJ0EVAH6l30D/WN+X5U8CqiquaWbQ2ffltNht9
         BM2Mxn4312jha6j/9ZNzkyT6uobJjsdBDa/+qlOoOBFBiHsXDa42byevQpBitMPB3R/w
         Pl3a3wbQUM22ewnNNiIRd50tc+THuxyoF1y0u7wMxfNN4u2BHW2cZow2zf8cpqLCvZdb
         FDVQ==
X-Gm-Message-State: AOJu0Yx1Ypds1Kkw2eZpQWUMO83H9C05LI7P2i29Qpw+xsCldYj/nKcM
	GC9mCQeWFoL4zAjA99B8n+zg0HQrUah/iZ7LdXjwZWBD5swmVwrw7qiyq+pdAo+Y0lZDztWeKnt
	MizgzIlWxge/ZksUY2qh3zbTS6wwpksE7+7WWDAttciWh2RG5kt3M
X-Gm-Gg: ATEYQzzqVCCvh4eRnwDcgfQcbxZTPTV1xlviZieV6FdJv4F2Tw0qBm1EQPfo62VfnvS
	SaS04Ya7CizIYvTC8RFA56++ZySc0vid1YvmcmTjJFmni09O9YGW/iQIyCkUgEAahgi200rm9ve
	FkcYKT3EYAMfGdFsD8VDPBn9vi/1iGKQGiJ57tlnMU9EtkDuxWuW1Y5Y9czSyg0hjjII+a3EUxk
	eXjxTYwPVV9rNhOI7vvsOks78VnGZtujaGS0OeV14tAJNZ/s4HFCoCyxciZdmc4sOgEH4tSlC2Y
	5lZS6iQ5NISvrl5Gl1WtQ5QkxYA4OeafjzxPMGYKOlgkx4acEPM0Q5Rg1sGKmG6Ky4KvTB3PQNW
	OG7CccQ41+rQUzzBsKA==
X-Received: by 2002:a17:902:e78e:b0:2b0:61f8:9f01 with SMTP id d9443c01a7336-2b0cdd21fd8mr172318345ad.44.1774941210817;
        Tue, 31 Mar 2026 00:13:30 -0700 (PDT)
X-Received: by 2002:a17:902:e78e:b0:2b0:61f8:9f01 with SMTP id d9443c01a7336-2b0cdd21fd8mr172318145ad.44.1774941210399;
        Tue, 31 Mar 2026 00:13:30 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242787bc7sm105451085ad.59.2026.03.31.00.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:13:29 -0700 (PDT)
Date: Tue, 31 Mar 2026 15:13:27 +0800
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] selftests/mm: fix cow/gup_longterm link failures
 when liburing flags are missing
Message-ID: <act0F2KTpXFFxmdf@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
 <20260331040156.119158-4-liwang@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260331040156.119158-4-liwang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0rV2_owT4Ha1UFOhFlXfPxpq8oTnKp0_CX3V_rO9-LY_1774941211
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 885DC4000B
X-Stat-Signature: c8xr18ew1r8pacp1a8gzw85w5m7xh3t1
X-HE-Tag: 1774941218-194302
X-HE-Meta: U2FsdGVkX18PrdKr5tW/bU8fgYdXMdrXk8D5/rpau8AYuqnkCexiifUzJu9e0ELZThGUf8t80HlgIvgW9Igxw+EFxi2M33BaLjjkAqr9QRE6DJ7PmBOVGDCHP23HowxQYHaii7hl4/42T6DdrshuY6bjZLGizjS6Uljw3sr/vO03uMOfzAGZYI4gg+LEgfeNZWrxRL/70XlB3myrj1xFCY8XaBlujKucCJ5bQrbxR1Sbg5t+6gCp9CneTR7QAQOOTQFaRuVDFd9qBJt2R9RiT3LvpqQuZNL44XnFFCiIoaSa/h3avGZadkzrcvHkZLcf1QbfxmbR64vsxkYuaUhtv4xGjDQ6g7Kghg9DpT4gaJrmpvcGDWPsEjcdZMT7RDCS3zZM5dMdcVZFhF9BsjbT7IhLMaqoThoFe388CmNARe1z3f31+d5AObXefsOYoYnmVVnoezq92cjU+AsUdESluCmf+allMsZdgKO/4qJMSzmmxoOzb5Wh/bsdZ/rHnY/GbVxfWApWOqoVCinoF2TyQr93K6n/iR6JQIxA9d8ku/ikqpmW6rarTbTb3N0SFj7vArwW92SQGfdLoHgksNo3Y65qI+iCL9wnuBQ6T0wc9NHbTo+/4tO/Ph5cOFxkXQU8skk61j0qO/FcKtd34UKxwZCmss4Hc85yUgJzHNzNNSGLvCCFfWn9s0+9YekNW09DCZogXhk7HOpYoiZt2muRTAIsBxveG4eBO0XTzhD6Pw+TAkzCFWXyhgXWYGX8L2GI63zsQRK8FCXlgbfu4DeQYYCvOaX7RKjo9GnjlrKPKmqR7wnL25dEjlj7jxCs9zjR/DYRfY0xrlpAL1CDZ0bghjbmy28a/co9sCp1/nQtKXYzbhrNmzLkspqcj5lKr5bAwHVplBp32ssGMxOswMCxikFmh/Cu+fEf32q/k2w2uY04zpxCrm80GV5aMJS9SDKxsvXFGSHbqf1VQsEEz9G
 XlSexTZ9
 T4BBS+sxh1pmKC/7We6Y0S8452TxbnBE5jqDAeFczS3vBxUwH7tx6XLQpxfCsM0lxElYeXdiATJ679oQWCTn+SgmC00a3fk8V6v53/NihSfqSkcdGY+J+9+l5l/1kjCj3L9hlUuuJ8XEtRlyMGEnBCMFNgusfb3WoKvE+R1kVelPGU8P30AfsEA77+egkcr9oWixrAU4ywEu5OL0giGBNx2HBUkiRVaEZLcOWgnjQmo1Yx+FIsc5jXfMFzcjx7JLIVBvA1gxmPTPXNrtbfh/EY6k/xMWw55gfmv+BJrjpA6DFiyPog5LTeGNcrvbY7+0mQNhGj4MOdQsoc2bQYsuoteHRDrE9tZFEv/YYhzfdUgLHLCL0m30AvXt8VKkNIFBcmcpcSYnjD+Wk58m/cMNMJcA8Cq9+7iRfuU7hEsF5NW2qZJqnUYkrws5stCqixOkdnT45hnysIF2XhrbIjS1MA0NwqDeIpj2L3ulX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -10,6 +10,11 @@ LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
>  
>  include local_config.mk
>  
> +PKG_CONFIG ?= pkg-config
> +ifeq ($(IOURING_EXTRA_LIBS),)
> +IOURING_EXTRA_LIBS := $(shell $(PKG_CONFIG) --libs liburing 2>/dev/null)
> +endif
> +
>  ifeq ($(ARCH),)
>  
>  ifeq ($(CROSS_COMPILE),)
> @@ -55,10 +60,12 @@ else
>  PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
>  endif
>  
> -TEST_GEN_FILES = cow
> -TEST_GEN_FILES += compaction_test
> -TEST_GEN_FILES += gup_longterm
> +TEST_GEN_FILES = compaction_test
>  TEST_GEN_FILES += gup_test
> +ifneq ($(IOURING_EXTRA_LIBS),)
> +TEST_GEN_FILES += cow
> +TEST_GEN_FILES += gup_longterm
> +endif

Please ignore this one, as Sashiko points:

  "The io_uring specific test cases within them are already isolated via
  #ifdef LOCAL_CONFIG_HAVE_LIBURING and do not require liburing to compile the
  rest of the tests."

I overlooked that two tests can be built without liburing-devel pkg.
Sashiko is correct here, we don't need define IOURING_EXTRA_LIBS.

The compiling error comes from a temp file in check_config.sh, and I
am not sure whether we should hide the error:

/tmp/tmp.kIIOIqwe3n.c:2:10: fatal error: liburing.h: No such file or directory
    2 | #include <liburing.h>
      |          ^~~~~~~~~~~~


-- 
Regards,
Li Wang


