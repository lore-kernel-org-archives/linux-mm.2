Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5800B106703B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74876B0089; Thu, 12 Mar 2026 10:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28926B008A; Thu, 12 Mar 2026 10:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E996B008C; Thu, 12 Mar 2026 10:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7396B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:27:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F26B989DE0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:27:12 +0000 (UTC)
X-FDA: 84537638304.04.ED002EC
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E0A240005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:27:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=RHQl8LoY;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773325631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abaAiQ/E4WeFRyf1X1ywTrn72K8d6oU3/W8FRhft/hs=;
	b=uTpL+NCeq+NED4U4WFjC6sRD1V+6G5onboeyXQWoQNSHC8JYZ0tQAjSXWxJJSqLdkv0dly
	wSs1U8fdEv4v/9s0E24k4BI7WuBfja5XoqBBL2Qtf9bAt5PkhUjH0lAAtnIt9aRploOMu+
	3LiMlH1XL0qh3jj16DTxSeYZzPs3N1I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=RHQl8LoY;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773325631; a=rsa-sha256;
	cv=none;
	b=Nvf/cHyNY4vWdJDFueTfybpjxdgHtEI9mUL5xKpQ1AK835EOiK4Rqab/lOohadqnSfJoZ3
	I/h+i+2CJcnIFq8YrYC0e96XGKMj/jtpcLl3ekcFVnEqg6hvGMF/Xq8zcpUKsagP5V5caV
	iz8zc+Xb0wdOyH7jTnIRt43iOlNTw8Q=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd767d2d70so115561085a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773325630; x=1773930430; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=abaAiQ/E4WeFRyf1X1ywTrn72K8d6oU3/W8FRhft/hs=;
        b=RHQl8LoY0CsUVnddRhSU2CSnduZj/xLMy+MYCGXROxeBx9eNI4N6CKPZ2NE19JH1+g
         y7s6BBjK0foCHcdLksn666IWip2H0Z8tMJVknvXyTS8Gyr8HiRknerNntjN8MgJvKzxS
         pPDpVZ64HB2i8cRZnbSM08oBuUqSxO75JkCLpfAo6sk2hGtibnn+kDzZdmv9U+jCiXQ4
         esDvUDksUzOou/J/AWwTBCpYgk7xoh+vaFhbPMYq90TIpCTLV9Diqz9x1lcpX3gS/pOW
         NX3Ch7OhOOamBMAavBZm37/pVhizu3XuPXL2yukqxRSU+gbsZTUTi7piQA6U10bxqqgw
         4ABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773325630; x=1773930430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=abaAiQ/E4WeFRyf1X1ywTrn72K8d6oU3/W8FRhft/hs=;
        b=NalGTR6XmX1NUrbgWZBmHVBkzGkw5VF/5mawe6RvzEuqkFy0AZfp1b1Ygr021WZPu1
         nzefrluYIgwD4emMKdLPaUB5D/lvHtxqBCscRQWgyCLvuLk8OEOtMy5Bl2UZuoaKqpm9
         2jvy3PJ7/bPre8d9hlV0hIZspe1XfEIDLQd/x7T18TSQYo6YWNVFXe9CgZt2Zm9xHEUl
         9ZXKvi6FpXrTFYZ80o4hnVxDqovlf7Ms0MIrF5ohhnUxztaEM7uw5iVFomLGEt8qmfr5
         gm7uJ1kkdIti6UZlRiMIxVYrbZ/a2ZtG05u9NFIUo45/7S2rcms6tDvy2pZIqWFJWvGY
         oBAw==
X-Forwarded-Encrypted: i=1; AJvYcCW5wRSZs/XmTylyF1zCsdyiRrNBhwZxj46N8AjKxmq/AN3RxKqd9oFvvcB2GzpHLA5xLJUsdr++TQ==@kvack.org
X-Gm-Message-State: AOJu0YytSt2xBiMD+h41wPmaD/acbg18GS1BxEG/wkMECzCmRef8qgZM
	jWmU0h/TeCjuCMf+7eI4ds/9PHYFSE/H0yGEQ33mhC2LHC6SfXx50pvZmbLs2l9G3nI=
X-Gm-Gg: ATEYQzzFD7ZlXBfgcJy3R0Z1E3YUU9segWNI60/WtGVm/5w0KJgMuWFrZ1ROLYaADVF
	yA52svuDOgiOPL8vS5pROigwFOvad3QwKLjLHx8gMquEV3sSHNckK5U6U2Osrs6d3ui+gIlwy/t
	zPOReLXZHpi12Me1A4r6UadsSD5GjDREDE90+01MbZ5XjocPF9mlghoCJiYfJDzlFgQ58Xm+UyG
	9ZiSRzCcG6Y6ESgA6Sg4J89QA6BqwTAQvTKe9jmftgX5sRxSG2U9nBsNM2VxHwhyswBfL4JEFep
	pFTMkF6QWwFy8q6e1AWf9laiZTxUU+Tf9zxLNMaHDT8xPoSjfPoWeCQQsnv42PAzY0EhGuzLnoq
	24mzgHgBNhwSCF/qJ8FUtr8HHi2HabHsH5XCwZS8skqMh67n0o1wAW7gPd4a5Z6O+K/yqTS2vnd
	BJZxT/9FZKAsfU/5WdSjTImQ==
X-Received: by 2002:a05:620a:6cc5:b0:8cd:93b7:ebc7 with SMTP id af79cd13be357-8cda1a7cf07mr806659185a.74.1773325629905;
        Thu, 12 Mar 2026 07:27:09 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda71834d9sm291561885a.14.2026.03.12.07.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:27:09 -0700 (PDT)
Date: Thu, 12 Mar 2026 10:27:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
	david@kernel.org, ziy@nvidia.com, willy@infradead.org,
	linux-mm@kvack.org, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	richard.weiyang@gmail.com
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
Message-ID: <abLNPEFw9g0Vp8Rh@cmpxchg.org>
References: <20260312104723.1351321-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312104723.1351321-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 0E0A240005
X-Rspamd-Server: rspam07
X-Stat-Signature: b1mm3rp6j33g3wfifumx87gybrym8gp5
X-Rspam-User: 
X-HE-Tag: 1773325630-722481
X-HE-Meta: U2FsdGVkX19SZr7XCZ+P72PbpjqmOlJ8XFYJJWKDYX+WzEktAaqiJ7aW7j0XGbyKI04NcPtv5/sOX3E0LSAGYoEnvNmCxRUSSGoAjqrIwxLqOm28WaegB3kLors0BdzAP+2teIDdl+1FdRDG/ZEwPeg2eaAR6KcKvw7M1TVNwn1tOOQrApEtq86gNwYd05UzUxpoOVbelOY/ffXN8FQSl2kno4mGWPCfzROYLIfMF1GPZv9rzkWIGp6TIDbr7jfo+gcby6o+GodVO9T40vaJO7IEDIHbzyQW5EovRsMsFpgb1Z0+izb1SqtlkzGBYGFI9ezvORcdW2mYxg/YiCjKLEW2M6TVGQ8DwuQOUDoNwOWAzEqiXMdd21IbODQ8tCDlPdDWmPErzNo1Sgg1OUNbpibOSNltoznCpXWVRP6K9j1U5p/ARGjC5KF+9G7psKJ81poNTMWU2pKsVzsS3G/gkgShJxzUagfAvoxb5Qh5kotfZeAGhPAqX4HixLccJL+u6DBFNwe1XUASGgNbvdMECJDRpEI4k6qd7nckrmdrBDEZ7fwi0yPaPK1MsiD/yzwuKffzSZcflRveXRWXmUuIZ2RdJ7F0ru4zqryNQ/I4hMV0j6LWy4wrGwh4B3eJ2zxG45H+MEd8c9iVuHmXtPt3DW63W/3tyTWsm+UJw9wsPUNtEAImOrl7gzbRBTD+If0nCVpuK2Se0amRiXe4vuy/NsM8pS+OOTe4SfTqj/IP0BntYDHyAhvcE05CCOTEBh4SaRQgOgzPaTQreNmNzzMYwuJWzaaBKJONJe1rk/n2CMn1vBkUG+cA5UsqBNadeFAgwR1+sb+5PbbFyLaB8K+BfjKPlOPAzyrDoubWEuwHqttb5/Nrlfg6ioW55eUpEdbISL6rn0+T6Z62amM4qrEBVGjFB4L+umpAuhe9iyjm4Gxe0+Qmazgm/A08oLj4kiSS+tvyvtI58/aPdDDvAoY
 8XRP/P7I
 cnagLzf79n+i3sbLnNjbnDLhY3bAVd+m1fNQ8v5NrXAnKCzDSP8BXkQmzilc7r6RKydj68vXzxF5eLJC6HMTGzxCFcurFRg3ZRa0F7k2JRlo/HVP+ipyaW79UEqNOBUAwK2Wu4MjKGgS7lafY3ANnOybEno4Bpca6Auq2XDJagpGydhL9zZvfA6JsXckaNUXYfc+ylDwkQiMNZT5j7O42bymgh0w1vDmgJ9yFUck8ewK7xsXX4tymAhFHA1A8f3rVc1GEtlLlSK6Fo0jrD35cXwWPTocDAigzszVmgEeRnwoti2lmN9kiwiqkKIMATiAQnV1xV72aqpG6WHk/Zcb4hpW6q9+h7B5kXtjcxwJLOPFsLwnhXtAadNItNe7HQlWMJx+7mixlbVc/HKBPznCfSJEx0JWxTN875PK/mdiNuzmCYjlRiLInfFOxXKt5giBs7EznOucpLz05Z5E/HOqx51G8lTp9kBj+3wEi09rLXA+Nmq/oVMGYcBZz4hLUQw6pLLr20JJnC1Twk3DVfMvIkVSsu9kGAg6FM6VF+qUaYtn498w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 03:47:23AM -0700, Usama Arif wrote:
> During folio migration, __folio_migrate_mapping() removes the source
> folio from the deferred split queue, but the destination folio is never
> re-queued.  This causes underutilized THPs to escape the shrinker after
> NUMA migration, since they silently drop off the deferred split list.
> 
> Fix this by recording whether the source folio was on the deferred split
> queue and its partially mapped state before move_to_new_folio() unqueues
> it, and re-queuing the destination folio after a successful migration if
> it was.
> 
> By the time migrate_folio_move() runs, partially mapped folios without a
> pin have already been split by migrate_pages_batch().  So only two cases
> remain on the deferred list at this point:
>   1. Partially mapped folios with a pin (split failed).
>   2. Fully mapped but potentially underused folios.
> The recorded partially_mapped state is forwarded to deferred_split_folio()
> so that the destination folio is correctly re-queued in both cases.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

