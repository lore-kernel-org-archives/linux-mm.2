Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82328EE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 12:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72E16B008A; Wed, 31 Dec 2025 07:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AAC6B008C; Wed, 31 Dec 2025 07:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D804A6B0092; Wed, 31 Dec 2025 07:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C40446B008A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:17:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 561C5CC555
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:17:08 +0000 (UTC)
X-FDA: 84279665736.27.8F731BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DE8940006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:17:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2FXsXPx;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767183426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVUZ3u7LQJiIrpM/cutUgb3ISWuZsQhirB9FFgyYc38=;
	b=mscrU9+FIJ15gi8yr1LBEgeMa1wMA9NjUTYgNuSLO0bQxgbVThYPeb9eRYGM9n2VbtxbmW
	u4fYZhpWJhdxNa5aJrupmZoe7qzbpIKYC60uvci8Uk/Y4ntchYXizQLMgMh5YomakrQt/o
	lg4OiutK93aNlgOntgIAz3bFKvRt1SA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2FXsXPx;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767183426; a=rsa-sha256;
	cv=none;
	b=6fx6V8zPsHZ/OK/CpcRWFynQbQcbXORI3y3dXkRyWBP590zPCPdlzmLQkfh6cLcqCDEcal
	6sYu36GQYr0quzSkdD+gAnpTRCK4CW1j4wpp1DS88sKqDYaIAB9hpDcEmKwf4bjo9AtKz8
	X1KOmb2nCFoh/d4cK6f8qpXnZIjPo7M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A6614389F;
	Wed, 31 Dec 2025 12:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585A2C113D0;
	Wed, 31 Dec 2025 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767183425;
	bh=FK7fi3Z65s9kSMh/SpiPpIc1DpnX0VO/ReyLuJU7LEA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q2FXsXPxu/PwL7UyxuLTqtUiylFmx5/NYI/S6t8L0sLSxCip71sdyXpt186CmkpOB
	 dGuFvOyacuzUBk/wamn8rt9TstXHqyQPFXIp1y0M0CzLZZEobLKQXfCzW1wJKfKNoM
	 OLpeVzByxQ6M6RYfx6yUZTHUgXruxZOnIM86+DoUpZ/LEaNqA9AayBZiRR5jMsc3nA
	 doQRUts8R+BMMpM24X+6kB8ODa4/PbaDIzt4mA+baSBoC8MZigfZ+0lxzrjhr8bHcv
	 Zfm/TlBW7cX/Le4yiMbxUB767u3vyrvwB44Ik58VDHMm9l46Cx163Z+crjwlWHHBxC
	 p1p1i+JpEF20g==
Message-ID: <6e5c60e7-3a9f-4953-83b6-422ca080ce52@kernel.org>
Date: Wed, 31 Dec 2025 13:17:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled
 codes.
To: wale zhang <wale.zhang.ftd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <21cnbao@gmail.com>, chrisl@kernel.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, linux-mm@kvack.org
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
 <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org>
 <CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
 <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org>
 <4029d13c-3bfc-4ace-8da0-3895dfc001b1@kernel.org>
 <CAHrEdetx_AUGa8Qk3JF-tgCZVJsfnfcLLSkkOVc_5ra6K6Q6Kg@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAHrEdetx_AUGa8Qk3JF-tgCZVJsfnfcLLSkkOVc_5ra6K6Q6Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DE8940006
X-Stat-Signature: fcy7ts1wb5tmigwgp6uwrnwpayxwb9pj
X-HE-Tag: 1767183426-188877
X-HE-Meta: U2FsdGVkX19cKt16EJ6dqMh2EDs0cZfYP4p8fuzSbeYngXcM/tBuZS3jzUwowvw+cRO6jxpoQvL+g2qQXX+sR36wvh/i4TTos22XF8ffsUrGsM8xsMi21DzU0V8tFEKFKEhrvVzmnLnQLBOdC+ZZbUru30G2KF3OWvOjg5gF5f9mJz7o5UIctoTv0XZcI9gEFX+Hkj0JyGqAtXyTMBKxyPglJ15fHwNppq+yZz5mxVaNQJFjiXUxVLicFMWyK2vLajSODdONUk4dR0T5Ktzm1dZohFvYJ/ylBwSQlgRvx8wVrf8Amw1Jw6hfSWQ0EeQQmVmVyqD9WVowSwrbrkAYMTX7Q1cc+r3HMPAhDp28JUFgeIUGvznIo/2MO0xiIo8WpBl8V4/nyn1JJBbTL9peWvOTlgN/HilLiavgW7r1N9tj0cKXtGD/Y4V+FlczwPtMNQRB6jJhTHhkB6M9BXW6Ag/0CvvabShoECpvq1AIZ5p2RKfUhkU9vQ8IlKBdSAYGR1jDSV7hHlxXwTjlUAJC/gqrkd35ER21NryMWL+sE4YIALHoinjkLnr6GgsQcrYbe5EYv/QIlQ6GxNa8CYwjFVoIMdrJQOEwqnYhUdBcVDbUS1M0Kdsc0LnVihQIJlnmZliTBK7BeJ4lG+dBr+aTVedFrc6EJxuXQTtPps555H9VSc57HxyxnI487jET4O3XENxeB6KBtmqj876OR3YOVUvZOHuWDi9tosExrT5mHlwqZRDhp4Zyolz92/0fqTv8g+ErOxTGOtiz0eLgmJ1DNfrzhHEMrHLSYE+q6/e/48hVRfgcjBp7KfSlXfe3ubVPUP6gMJEhgk4XZYSyKfj1kuncOasG8yCfKz66mq3W9Mgeo2ycRowffReezog2+tITD1ZjXVX19WOwtfC4ViXeB+EStjvUIvkrogF9oD7dXlfATAOmtSlhNbigVjlM/ZPyEbZYX5ly+8WU3EncTAQ
 r3tEQhJa
 51PfoNPSmtHXLhIW7nFW2I8uV6NrEY1GI0eMa6LZRnO424h1gmVXZO2Iy0WW3jmvBUHlFRh4TQbbjxhLBkp++0TNV6rtE2Z5y8Pm7db/KLGhWGNPHOAkwhz6ehDIG+tQAqv5zp73WxATbMh9uvE4aU6OGVW4ol19jXziOe0UysG56wBBmbI5L65aO5z21AW6upe0fCpp41i3BErNbi8puWKKZGlv0kR2LIM/hgyq/474sotkYtxTcfS65ZS1Vph4vSQvQGqnI6mYTl4+m7D1j4hqmgzH78g8DBFkJkd1am43r1aLNN7PQBtMOvlStzojGMkUW0kyDinQ3SXTKqpqpF/MMiGbmdwWz/Q8lg9f1UFZVN4g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Hello David,
> 
> folio_inc_return_large_mapcount and folio_dec_return_large_mapcount
> are only used when CONFIG_NO_PAGE_MAPCOUNT is defined.

It's conceptually wrong to leak CONFIG_NO_PAGE_MAPCOUNT in something that is
CONFIG_MM_ID material at this point.

> 
>>
>>
>> So if the following makes compilers happy, fine with me:
> 
> Apart from the solution as below, I can't think of any other ways. Do
> you have any good ideas?

Leave the code alone.

What we *could* do is

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d9..ae495c225717a 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -354,11 +354,8 @@ static inline void folio_add_large_mapcount(struct folio *folio,
         atomic_add(diff, &folio->_large_mapcount);
  }
  
-static inline int folio_add_return_large_mapcount(struct folio *folio,
-               int diff, struct vm_area_struct *vma)
-{
-       BUILD_BUG();
-}
+int folio_add_return_large_mapcount(struct folio *folio,
+               int diff, struct vm_area_struct *vma);
  
  static inline void folio_sub_large_mapcount(struct folio *folio,
                 int diff, struct vm_area_struct *vma)
@@ -366,11 +363,8 @@ static inline void folio_sub_large_mapcount(struct folio *folio,
         atomic_sub(diff, &folio->_large_mapcount);
  }
  
-static inline int folio_sub_return_large_mapcount(struct folio *folio,
-               int diff, struct vm_area_struct *vma)
-{
-       BUILD_BUG();
-}
+int folio_sub_return_large_mapcount(struct folio *folio,
+               int diff, struct vm_area_struct *vma);
  #endif /* CONFIG_MM_ID */
  
  #define folio_inc_large_mapcount(folio, vma) \


But then, I have patches here in the works that actually fill these functions
with life.

So leave the code alone; I'm sure that is something with more added value
to be done in the kernel :)

-- 
Cheers

David

