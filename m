Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F905C5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77A16B0116; Mon, 17 Aug 2026 18:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C281F6B0117; Mon, 17 Aug 2026 18:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1D96B0118; Mon, 17 Aug 2026 18:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEDE6B0116
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:08:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FFB7A3589
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:20 +0000 (UTC)
X-FDA: 85112150760.16.7DDD7D9
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65A34A0006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SMQGrN8e;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TbSdQcY7KD6I3WslktwD+M/q5vUGGfVm2gu43i1aVI=;
	b=78xAdDhLwzEoYNCB8hG6SRoHbc46C18tPAN7+ji5ospPYM7U4jGIwOkIgbXpeVjul9Ydd+
	PsxA8KUQFqQstOoSwlq8qIo7J9gKZliLlFa4ExQOnCWpLjxpsnVLxGi40JKX1t98rYXqWu
	hVVcE5yG29xPrBgh/4zxmzOwFPy2Dro=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SMQGrN8e;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787004498;
	b=U9ERFg0dmAt3hsqEnkI/0EgDL2qo8pAntbNtd0eCp4yVJxHg4pm9QiLwAnl8bIAOzoWkwI
	NkMx9gp/nik3D0zvP+jm55lGkDU3kON5/rbOplXsGUY1zzvXCgHYVZhTA0zSfLAdTtV7gR
	GZIlnIq7UCnUW5Z5gWy2oxKjIuFD7tw=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e53581361so199757985a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787004497; x=1787609297; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TbSdQcY7KD6I3WslktwD+M/q5vUGGfVm2gu43i1aVI=;
        b=SMQGrN8eVyV6F78j8wCwkBH+16gjcFpR/SDb24ujCKtrdKaD0xbhdC8fJQiD2FJRZU
         vOt1CsqXIx4VgN0LzZmucpF1ZcU/kj5pXIyLoJLbObPMRnN47ErnGCBQCfgYgRA0+MP/
         88V2wzs/QBhPFkXda86OIbLFNqWYl8O+Q3trC2QRcpWD7qKEZgDDHZEJwar3PIlnUlTv
         NWiLRsyygfna1fKKd/Ouy+NoL7IJ1fohBgBcSrOxvBWA97/nAXAh1ynT+qAwLLD5tQl/
         Izu5hL6hPzhihiA0nUS6NOM7NYXG7NuTNU49KMhp1BmrYN45Ws6J9GSzE81uDl8ncffO
         FFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004497; x=1787609297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TbSdQcY7KD6I3WslktwD+M/q5vUGGfVm2gu43i1aVI=;
        b=UFQNmhxDDpJ1snGj48nqqoNmYYMNDZ052mKPSsxZlHHCEK1W1wG/lq9qX4L4wWRiIq
         E28C/N30hF0kZAIezNFd/PCeCgKGzTLRCgPisjSJh1pxfCxfEopbVM2sahCUe+p4jRwb
         yqvpStt92JwHTtH3pUM/t/nmMw95QRZxIF2mreyBZSvtG1nG5wyPVpvIQZjC+a4fS11I
         1IqdYJXzJzBxM5zQC4yIVi1JfB/T+gCd0uH5QKN5lV4u5ES7JY7UmLqdRejHhSywJqlj
         JkNgol/foKLS/Q69UsmGqTI9FmNu+AzswBbpWoc8vR/z41hIkT4AyOWcv4DQdIoXKJGl
         1PgA==
X-Gm-Message-State: AOJu0Yyk/a8DshmeuH0MD7ISewfStLpYYqJ6nLxGhuQ6Rm4lwrqEg75c
	ujZbZEFWxn3XJStJMasXhWB5g0XTY/KXf2jyo+IxC32l5KaJkf2QCrWcinzW8rOC8Rqftl6/2yi
	7SSOH+YI=
X-Gm-Gg: AR+sD10kQsgyOXO/XvMJ4tCQ66tsP6Pq6T55FVbIbXgKxYkQ0cYYWC8pxgt8Q6G5ws+
	V3+LGcU/Q4NZWLAsO8jU1f559da0NJFYPGuadrPWtHHl0g/L0ecHFQC55G+vLHkgNA/stRG1ikv
	Txu8SI7oN4iTP5JqmwWL9FWvq2BYZDlZzcT40F5yNHclaQDRSaW6Cf6V7tAgOnjMmNMsCwvwonU
	K+g4J3+ZcFEn6jzlh5I6NbtgZd/qMpdLKCy/eWPPR9AaeH5HFZ91twch1u6T8nsGinFpJUP0mCm
	LIreCbiBwf0b2Cvr9drlvyZAgYGsoDPp3Eh6MPfGJABH1HBAACL0a0OuAaxUuQe5gmNwloNGVYP
	Le10tPlVOzZ1Kw+13EiyisOQkAaMAFjwSpl4cVcCNQSe+LGJ+h4pIcuNAKrVumafJaMXddSBXIs
	waFFz0ELUxDla+BgnWMRwdmZOjlzazLbWoEEQt8TfvdMLp2YswG7p9+DwCoGe+dOD8Epr7X1tOO
	bw4m4tZUyMkdGFBzhEbcTnXPd3u8xrobXRN+TMGS7henMHbWA==
X-Received: by 2002:a05:620a:80d:b0:930:c12d:b915 with SMTP id af79cd13be357-936d202fbedmr2459244885a.18.1787004497552;
        Mon, 17 Aug 2026 15:08:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ce78csm147108885a.31.2026.08.17.15.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 15:08:17 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
Date: Mon, 17 Aug 2026 18:08:08 -0400
Message-ID: <20260817220810.1175596-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817220810.1175596-1-gourry@gourry.net>
References: <20260817220810.1175596-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65A34A0006
X-Stat-Signature: 8twsmbm7a1kndp64fkpk5t6heswzzwmo
X-Rspam-User: 
X-HE-Tag: 1787004498-960135
X-HE-Meta: U2FsdGVkX1+0/bcMMcb89liv9LIlkIKviGOnAw89o3pP6WPh5YHJOv39u0v720V8YrT+qt2+F+8CLRWv9eLClDPvNSqq3Oxj/vhb73bnF9HAkL0Lv/S0JjJDJujVBY25KYp6T2L69xsIGbSJvU7UYm0lbG42/uFJrs8LI8J699lf4aUlg8yq9MONPiflb9STss0O8/FFxXtgid+l8QlH7SJV8ZBs5EJ2azQO/akNbJHeEDDaKWDVP+aKHkty4wHWe2M8SE99TmzZ1duJKp/F1r+KsLAmoJv+bjxpLl1Qzif9TA3gq/HA+yiRev6OzW4yT0/9/WzGhAu9vSsX0ZH/Zdx2HOy2m6omP6UZQj6DT6qRsuM2dvs8qbUZsyvzrO4s6YH83jKt4fh0szRdmPyjiHJjHg4G+nYjWG9QyjhxanzMiaSFUPmUE5WP41HwlsIX2hboj2Sa1CCBuZwtgJj/gnzX3ZbOcZSIWCuRY8Rf+2XgJJ50NaUULtBLs2t72Mfrfsk84o0K8lh9HXwd6sos5n8k8bWkVvQBrPy36M7G+0LdPKmK7t7c3gEkYDSTOGZMrrlkni2jR6EX7gQ31u7G2IZUltgVMpw8BCf/wlfEzJDpEam+gBdIBQ5IlkgBuRsLMAZ833pAR/BJMmz77UxaxhyvbZkT7Zi9oj974Z9uti4g0lGH+zDUMBAHPbMwffjf4s0vwhNzWEhBOQi/ZVkyoUd2bRQ4VZnuMd7opg7c/uF09ZKi/9KhESznXNr2I5TuwDHUczlWdoaTK5+dJzWrA+fTm73o4w/qi4zICuMkmWoyPzULMq+3tizVPZt8f/6vKMuMl0LRlY2CeNo0ZKj1/sPEE3z9pUyFcGmR8/q3urrmaBYFHQ2xSXbr0qI6FYK+rCoXKlz8Nn0x34dboFtA9zIxQVEWNq9rrDrYkpaYCFBABy4Bm3z6Cgj8gOS0LMV4wdNz3Jp0eQRm2RZbrbi
 Z2WrFBMl
 BGdf4RNyifoVzjGd0MFnAfxG8jzhDnaYhpCE62Ke1Ec6G6ZBVMKGO9hWCSPduQrgk9sOQ5y13XIVZYQHuQvXhPZsdhCmHC0FauN77AFi7lnFo+ewd5nEgd5Jym3+lHb2GM6xNdt9ibQ4hyJAmVfCtzolPGWHQqxtJ7lNFCljwGARxOOBDjMh3y9pr4hmh0uQrMxzxi/GL/p6C1wU7yJSr08e7/7khPTUssPeWI60nffZR74pKkN5oKDuXnXvBmZD3IYpKaz+RHFSNU5RU7pH12vC8XST5Ufc/VNFwla7BAUkbN2ozGIjpVtLGhknuV2j8iEAA1Rx79PGVr6RzkTwuraywwfL8C8QoqlhRRqYyZFhoyrOvUYREuf3SlFX4SgqbPIj/Zvze8l5tH+ckSXIprNHuFD9dlidLWqUkP1Gh8AF+64KQrDvJSxyb8yHrsRByJVSR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_huge_pmd() resolves the folio backing a PMD via pmd_folio()
and marks it lazyfree without checking for zone device memory.

The surrounding guards do not cover every zone device case:
 - MADV_FREE only operates on anonymous VMAs (DAX mappings are excluded)

 - !pmd_present() branch rejects device-private and migration entries

 - present zone device PMD (device coherent THP) is not filtered.
   Unlike vm_normal_page_pmd(), it performs no special/pfnmap check,
   and would be marked lazyfree here.

Bail out when the folio is a zone device folio.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43a..714773695bbff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2381,6 +2381,10 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	folio = pmd_folio(orig_pmd);
+
+	if (folio_is_zone_device(folio))
+		goto out;
+
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
-- 
2.53.0-Meta


