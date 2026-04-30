Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED89AFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40686B0088; Thu, 30 Apr 2026 05:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF13C6B008A; Thu, 30 Apr 2026 05:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E073F6B008C; Thu, 30 Apr 2026 05:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1D8C6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:07:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67F7F1B9C39
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:07:45 +0000 (UTC)
X-FDA: 84714644490.05.13CB158
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85681140003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:07:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BNCuJrao;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777540063; a=rsa-sha256;
	cv=none;
	b=aw4kOHZw3m0urZN6BSN/LK48hMPBx8KXRGs4guTszG1dOrrMKxtP5UpP4lUd/9T2dd5lQU
	JNTKFz9aBrAKKdZtGIU7YnpvJF+dUAbBkGQvnal9H8vjJuM8sPyKEKgN7vVMXJFUhwtrVY
	JzlsOWelM0xpV2ESicHIX1GsCKGAbmc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BNCuJrao;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777540063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sW9yUuiuOqvKVvfAL90obEUno+eOlkGZaMX/8MItf4=;
	b=eO+iLMDM6bbALheUeBSYwq0qxZrAaY/327tDEljmu3hyXoQvES6zV1VdglTNOiSVYrm3pC
	9oyyaT4OqfUO1Y0CwJpJtxOPQVbhOgissD52cmDr4a5s5rQMwoa8/rWmZx0+iRxCgkCaed
	4EPfhMqqL0YkocnyudmEVWOlsDi0mZc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777540058; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=6sW9yUuiuOqvKVvfAL90obEUno+eOlkGZaMX/8MItf4=;
	b=BNCuJrao1f3aocvyJg7/ySRHN9toyNrGuPLCqes2iv4PoTt0hI36S/GsuNWa6h+gOfyF8mbISas79wY/JlrF5mKnPsrCDdip2Qn1VGf/Fw0aoIfKCysUETICBVI+a66IsTnZGqVsBC7bmsl+5WShVO4PbtDIJ2W5HiJLOQYNwu0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=46;SR=0;TI=SMTPD_---0X2-fQ.Z_1777540049;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2-fQ.Z_1777540049 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Apr 2026 17:07:36 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <kinseyho@google.com>,  <weixugc@google.com>,  <ljs@kernel.org>,
  <Liam.Howlett@oracle.com>,  <vbabka@kernel.org>,  <willy@infradead.org>,
  <rppt@kernel.org>,  <surenb@google.com>,  <mhocko@suse.com>,
  <ziy@nvidia.com>,  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <jic23@kernel.org>,  <aneesh.kumar@kernel.org>,  <nathan.lynch@amd.com>,
  <Frank.li@nxp.com>,  <djbw@kernel.org>,  <linux-kernel@vger.kernel.org>,
  <linux-mm@kvack.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/7] mm/migrate: rename PAGE_ migration flags to FOLIO_
In-Reply-To: <20260428155043.39251-4-shivankg@amd.com> (Shivank Garg's message
	of "Tue, 28 Apr 2026 15:50:39 +0000")
References: <20260428155043.39251-2-shivankg@amd.com>
	<20260428155043.39251-4-shivankg@amd.com>
Date: Thu, 30 Apr 2026 17:07:28 +0800
Message-ID: <87v7d8vmsv.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: rxproxkam3acwzj9riyu9fxpobruqwbr
X-Rspam-User: 
X-Rspamd-Queue-Id: 85681140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777540061-316089
X-HE-Meta: U2FsdGVkX1/xlGZvZALsWqy80YeMstjlgNtdcxqN1mddPW+xWUk6wcB2+zQeghNS9QsDsHTI1va1jBxBB/4/snaAVonE4syKniO+ko+ZRXGFvhs9v4Fxdu35hKAJA4ZT3EIBkY01Ec95tNioekhyOv/BJOu7DVCX9FG/E1VlvOBem2xlZAKax9MpoSyseWg36MZZvKYjMdhORP9ydd790gOQodY+GA/kTNbOPak86KCDOOufwacOzDFj5xW2Gmw1Oy8sIZUAOe6YR5ijWMS6d/UgS9cDFHxBRI4mKlL4bdV4eCmI4ChFXIVUJ1jqLPQLgDHLYMiKws+mhOsQMevp5mVrXVxtFVz1R2vQaDZxmlIG3wckBHcd4TBrvuKqWIz5tpyFVgGA5xZln07MyXA6uH8zJDqH1vFnx02Uz5VC/4xWyQp+p3/u4M1ohE7isNlXcx9m+D/Slg0ZWW8Uu8tZyPdKMBRE5rFxpuYVArNgtTzrvY61FAy9qehKX7h03iKpkctg5ni9lLSSJMY6iqmi2dxWbJrIZGt4D0BLvCKwSYCsf8FjJ/uDIt5Hy+k+lo5Wg9Se78SPAuH/ptBpWzIrj7GqJEHPqmde2+LJHbNxI8e0ho6RunTmoUlMaN9+lsz746R45NNA+NuslgYElyAf6dO6ydyNGrQAhQ5krxQtVWpRPXaEtNtedsDP3Zn+8gw2wxh+iCPE8ysiXAibdRy0ZTKw49A00YlfolXK9vnRal0IbDNC+7Ps7RIRivPpEkOjOkJWI8NoSzqAP3CG4RXqSaPyyhChtaBTmCpjya7Ckkfy9FaOFNaLpSe5/BE13eOvRmcs36LNURxdJQSIO90I3eb8jvmxPyTKgR+9XgoMqyfIBl/tsTBnNp2AcoTdvY5wgADUU1rSLTzDtzfoQ4kmorjeQmnKJYGEIRlZQlZnNvBRmHLiZO0dewWPmVfyTe5N+WulUqh/Ekt94ZQLZ81
 AX/nMSxO
 OA/Pqe6L9hTD1WJqSlGwvekozt2gk3Az6LUc6lTQkVSqcrSWw7NDtzvTWcrkMA+5iMvsphCAr6t0smdJq88TT3GlPP57OEAdDyA3n6y8wkCOct2FQZanapigeabeFmmEnWhj+b9BiOPp1HRQGsC72XeiwM9RqYKAnjkVD/ezJWN4OKvgQmuocRwEgwy9lytRNhjCKiqHjYRR3TdyEroyuZkkoogB+1TVql7vcrHoT+sWSqPtpqh+cHMgfHHRz7Nu60YfAsD18z+MafNNJ/Wl0XdMmnI0Dqvoo23ZQC/Q4NFlt8S058qEMnfh9kDe0VMXHTlOHe1BKFcgCk4vRHsZbkxwFn0B0zmvrleMxf0wcP91b/bVU/fkaXDSDYqeciQB1OJoL/9KXQ2hLQTXkmO0L0mSGP86Mjx/okUu/iowdv4uH9MhET1B9nZc9+zeTkVxiSDz4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> These flags only track folio-specific state during migration and are
> not used for movable_ops pages. Rename the enum values and the
> old_page_state variable to match.
>
> No functional change.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

LGTM, Thanks!  Feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

[snip]

---
Best Regards,
Huang, Ying

