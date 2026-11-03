Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4D1606A96D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VgvQYUgS
Received: by kanga.kvack.org (Postfix)
	id D07896B05B4; Tue,  3 Nov 2026 03:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8066B05C4; Tue,  3 Nov 2026 03:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEE96B05D5; Tue,  3 Nov 2026 03:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2D286B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:44:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48D6EA7D70
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:44:32 +0000 (UTC)
X-FDA: 85393171584.20.108C16A
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4590940006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:44:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VgvQYUgS;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695470;
	b=Hzobu3KM3gxJvxNz8prRFmmlfHjYTXN6rCLB2iRq4nwCP+dP/3vMS0ZKqnV5pwLAhTQBpI
	XsWRttomQCB0mkXNYMM5uhCkkVuAvcXQWQOscNN3QfosN+j4CdN1cxa84+GVAduYThaY2Y
	0XMPvqFz6sVlFUcuwweaqX50N9qjcQY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VgvQYUgS;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilisxbvbd8NSl3FqfuStr292wszm0PcMcOarGjNhaDU=;
	b=ZMxDCqGw6OnXRQe71EQiNXW9lW+jg8RfBOX4Wexyd5+eTiffdH0WUT46isH9qrUUSMiN4W
	MLlxe71CtmNtWeiK4jtVEvswS4/aPvIi0cL5IQfvin0/pzLMI4vVU0Z66aoTXdifEo83YX
	2oHtiQNwr9c7Z/kA0/qqQ5YGji9cPwY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XmvDp6Uab0sh7g6VkNQVO5JWlnHOPAP3vSfwuAggiUg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695468; v=1; x=1794300268;
 b=VgvQYUgSn9rJvn63grV0lQbWiRySyysEa4lJGYRUTt6r9Zr0ReglDaey6g/xwQgDVXtitFWJ
 KGKgRsrVEz28nKdTCWTFQnLaN6sKYUuoOkPgnanbmeqIrlrnvJAaD/VoVcI14T51pZ7tCeUn8xn
 seEDw49OCAJY7j2ukth3duxI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 90c7e1b874827c5c;
	Tue, 03 Nov 2026 08:44:28 +0000
X-Mizu-Trace-ID: 90c7e1b874827c5c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
Date: Tue, 3 Nov 2026 16:44:10 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D1D941B5-C7F1-4273-875A-B75178E0E69E@linux.dev>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4590940006
X-Stat-Signature: gprzwe7qdyezer4gx4kybad1nm9krprt
X-Rspam-User: 
X-HE-Tag: 1793695470-576781
X-HE-Meta: U2FsdGVkX19DPZJ3kotEqEw9r5Ub69PMPsiMGcvI++DQZQTGe3dnTpkyzbDfO9RAZcA8/FpTNVCMtcnlDKXrp/RORU3V91PvFoP73OoLg0dgFYNSl0agupOCnKFS9BxCObfaSDJX5mj9zQ78ftc0EdhgS5E8T8vfzA+H6y9JRyx0d8UdFZJFoKHHaBvguYDwoHnksCmvAxLTQc8DLXSZqiakSZcU4Kpafd8Q9Mnj4NiXdL2oNOvhlViNFXwby8i4EtTOpeLJ/AZWB2VF/yAXEgT68s2G7ByEQQ8Vd15iPLBISaYrW7yzN2aC8d5F13Mn4gpEOpubidrRLZRlHCClFGPMXVnL3V0zgVNESI4WYozEeGiP9JRUVZWRoN6nZKb2XSmW50t9NnwVX05oQu4W95GXNKoVvvgIbcfVDzQU8WJAME0SdivIsGjmfbHKUKRu7X37xp7mFaLK75hlvRQx6dhcfH87rrRn6ldfM+p62IqWZUsU48QWW29d7QkmP1lu+qKAB+IkywCyJNw1joTxShbx7T7VsLyFr2qa+ADddjykGTNSlK6DMHwBZJCY7oVRNiHj8Hovu7iN4einecg3ZLl4w3DQZMXoz2S2kUG9ELqhWczgfPAA0R16XqFnfZKuiWPClyeyUqQMsTpR4n0sqIwtemntGRw57xswFuELXo5fICS3Bj/PrNkIh5lDRrLox1M5dPa37l20U03Ol5iZjVseKK8N1yzx7B77fSSnyJUoGQFv3Fqp+fTe3Wd/s15ayiNftiUNPOEB8nujLy1ToFXwjm46BsUCKkUWqRW3XpmLB/zGw4aviR+9MBG/fq22qgMl/5X+CoQXWaIknWZfEQ0upxaUjWUvxcm5cpw81AsNs2Z9jN60Oq44RR0ShF76AdaGwr2jNuCK+8j5nYR5mF1PKe0KP2Y/vslBGh/FQjll0MNnWGwDHpd87f8fHPLvJ4k5de+OuWI2XhiDA/z
 mvE1vypt
 f4a4JRD+f4+KhuwhqBdTMFIIgAjou5+buBb+8dN2O7uAc1EXAxdpb8DGy5GsPFHAe8U1hOq4qFaLsW9mEdRLS/uDbJ1au35P38sE+frxcmFIOiflvA6qzakx/SRAkpIhLQWM5laTFQKVAISjfLBq87H7h+hjiYIcFp+T9/NsFhkJrdzWhB8RE38lGYfxqDHuYf5MvmGnrN3qZJe78+Hm4J73Vb0RiWGfkbRdcOLllJcUDfpBtq5EznDM/lnPiPbfSyH4DDNTeGduebf9FCWscobt1cgqcEEIDyCWLtWk/kv7XJjkPJS0at1MKFuyNVjA4grsD3O/KRM1+ib6RxJOIwviXyIjGm4GU7tVzuv+OzPXP3tw4cloFCmkQ+h6eFNlwtaS4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> With gigantic overcommit enabled, a fault during long-term pinning
> can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.
> 
> The folio must then be migrated before it can be pinned. However,
> fresh gigantic migration targets are not supported, so pinning fails
> when the HugeTLB pool has no suitable target, even if the original
> fault could have allocated pinnable memory outside CMA.
> 
> Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
> try the non-CMA fallback, or fail when allocation is restricted to CMA.
> 
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

LGTM.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


