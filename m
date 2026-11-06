Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC93F606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KMes1A9s
Received: by kanga.kvack.org (Postfix)
	id BC42E6B05B0; Thu,  5 Nov 2026 20:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74486B05B1; Thu,  5 Nov 2026 20:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A426B05B4; Thu,  5 Nov 2026 20:21:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 827006B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:21:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B99AA881B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:21:08 +0000 (UTC)
X-FDA: 85402940616.17.4883DC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46C64140006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:21:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KMes1A9s;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793928066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Unoc9ykJp/GThx0lrtdBnOWr0Hmq9Ix53iTlmBSWd4=;
	b=yK5S070evvmxH2FAxSVKD4bEkLIIU5NMobc09QQR9VBXV4yVBc7tut9i6SejWCWuYxEtq8
	xd9V3X+ZQounbrRTGH2463hAwHTKlOsjPZGxgAlV1pgIRGEcFnzqb0OMzHdNdPjbpz4fse
	i1qBjpfY1aZ/ahKZBA48hiy2t8lo6hk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KMes1A9s;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793928066;
	b=VYnJa7ToSacaPQd5UXCgx3LnZVMQw+4ERBLUJBrBq9GoJuBMj+XsaeCO2Cfe0c8vF53Rkn
	0CvrZfYaC67Vn4PkS4F6dKN7aX9Tyob7LisDiu2nTHfHNb04rXn/1FPD/qB1tqZaadJyyT
	l/mJ0Y6tXz6EA0hDlPb6/6rf++U+Ll4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1548E601E3;
	Fri,  6 Nov 2026 01:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7618B1F0089F;
	Fri,  6 Nov 2026 01:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928064;
	bh=7Unoc9ykJp/GThx0lrtdBnOWr0Hmq9Ix53iTlmBSWd4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KMes1A9sA4g9PG6XPVvWwq4m8NUsIhBXxh5nU/wyof25j5ItRx98EzpODxaK5nLon
	 yTx8RPDbOgpEagV+rxz0usgLwYAgIjV6kpO9b7yJ/ecSHddtQSEjRCllr+UsPOd7EL
	 LLtDmGNP26YX8RWu0HaDtDnY9emISukuJDELCSzE=
Date: Thu, 5 Nov 2026 17:21:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation
 tracepoints
Message-Id: <20261105172104.339c6f598a65056ed46e56fc@linux-foundation.org>
In-Reply-To: <202611052344.mDV2DB89-lkp@intel.com>
References: <37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com>
	<202611052344.mDV2DB89-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46C64140006
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fqpz4rt374w1g4yx3ss4cp6z4j3sq7ns
X-HE-Tag: 1793928066-456497
X-HE-Meta: U2FsdGVkX19XeUrKogB26dWduuiOqcb688g55H3IOPtHdgQ01eP+Uf41YH7G3woQeEhpzzI4b5VXpOCk9TOc47VgUEv0MuCGgTUV3XqQGs7JIsKOMJ5QkAeG2BOcSwo+DsGipeh0FH+06BFf48YK9SVm9OBRiWOXxF/Nat9zJ9F80w72Dcr+wrnuX/kxjMS1/i/Gbt1MnFEBxM8h1PoqcSFf9+V54VB5BTF8Q8pzPymmceNxthmXSIAKXo9fzWOxpcIvOT9D7AYCyyOPC5YjrvFMqhg+kIWZWT+FokR7wJ2MTwHvgyNYXXALf/l7ey4HrgxK7bxgfjXKazN1IIYL8huyMwjAS8NWHhBkOu/DD+o0orXgehtt083tRJ52Htd3PMhRpbsM3d90w5eaMo6lzlwZr6KhCox7H9fF6ONSmxCmea3njAyEOOIHEfqG48/yd4pU/w8Nryh/6Ku8UoxOr1r6ApJp0e5z1DNV2uojcRaO1joqm/Nav/d+Rx4A34YhEI/pEGxpvaCd3gTEgZ1L38gwAdVqB+RGicos7We7CXHzmgdPw8xlx2mR+xDQUM6rTuYXUdN+QwoLU98x9WfbjtIAOTr/j3O27gEwgrs4FRVwGA3QCIQUn/HzNaqt5ySXVglJgDN4Oeic4boywq0FCOhNgnAbR6K1na/+RN6VAD/Sf+iPDziQQDvzsTGseNv85XTxmeILnSvPcuYV0YHDZMh9k8xe7HTdlickH6g+mNka1hPNCWkHHhjwcjOVrRsyVEk7TUv6CSmpsiEyQ5rVoG8rN3EQU56YQVRGYYESePidJdW0CLgQpY78qvh40cNLpe96JFRlBo88tr78Jlkx8bHiWO+EjOimURdy/GimqAF4/cWIDvR9aBHUgjB+J2ccvO4Wa1UuhsPNdp/C6Gr1XvlhC0105dpidicEZMoI0MrP/EKVoKC82CRInoLnhIW4WMjOHK9d9sVEidIqZjR
 OAkFXUiB
 2h+o9tK/ztN6NwjxCU4HVnZLlR41tNrJ5+nLWXrZl/pT6AFuTcwSxpsqhTAud88PXvEH1ohplQ+1zxEFczH+r+eTtSY6D6Bf/AZk65XeUs/m/R7rDO15/B0ptbgS7JpuMvEEsd/r53AJlwXXwdiTvCb07hBxomyqxg7rvMveD/AQQP2xKjxwS7kcESeqhUNtvgqnkJHfk/O13RPX41c83ZKzmdp9FLoAxw2iWOTzcusYXakhIaUMirNYSdZZfrOXqCo9frNtqZwsdkUQor4NXBbsHgCnar7Dhw8fgg9CZbpHRH49Cit9zNihaAC8aHNi//oNjQ7PhvPk/LzvTn9FUFd7VSobIE/ePHMYSegRBft4KWSeU9T4cOyZf85xoxTr7BlvLZwAFZbr/pYcHTMKdjeboF36fP1Pji2X7POmTtbNFBz5MfTaW4raWYspLArQdSb5dlKqsj4UWjmZR1U7SLy8/dQQjsvDW8NTaGyd3YOUa/KpgjeIRuyJyLeG/kI0LUNoD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 23:15:33 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Abhishek,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on bcc036cfa1670a64500f6d857eaa71908b79e3fb]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Bapat/alloc_tag-Add-trace-events-for-tracing-allocations/20261104-190336
> base:   bcc036cfa1670a64500f6d857eaa71908b79e3fb
> patch link:    https://lore.kernel.org/r/37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat%40google.com
> patch subject: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
> config: xtensa-randconfig-1001-20261105 (https://download.01.org/0day-ci/archive/20261105/202611052344.mDV2DB89-lkp@intel.com/config)
> compiler: xtensa-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261105/202611052344.mDV2DB89-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611052344.mDV2DB89-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_trace_enabled+0x2c (section: .text.unlikely) -> initcall_level_names (section: .init.data)

Thanks.

#syz test

From: Andrew Morton <akpm@linux-foundation.org>
Subject: alloc_tag: force inline the allocation tracing check
Date: Thu, 05 Nov 2026 17:18:09 -0800

alloc_tag_trace_enabled() is declared inline, but the compiler can
still emit an out-of-line copy. Force it inline,

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202611052344.mDV2DB89-lkp@intel.com/
Cc: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix
+++ a/include/linux/alloc_tag.h
@@ -161,7 +161,7 @@ static inline bool alloc_tag_is_traced(c
 	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
 }
 
-static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
+static __always_inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
 {
 	if (static_branch_unlikely(&alloc_tag_trace_key))
 		return tag && alloc_tag_is_traced(tag);
_


