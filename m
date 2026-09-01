Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 850F2C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9022A6B0096; Tue,  1 Sep 2026 16:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D99A6B0098; Tue,  1 Sep 2026 16:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817046B0099; Tue,  1 Sep 2026 16:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61C106B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E79FB404C7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:45 +0000 (UTC)
X-FDA: 85166296530.02.C2EFF5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 52E0414000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oK7KIXR6;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788293684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYAL/uAoi+EN4roiOHSrXabP2vbnl7qcOw3MP41npbU=;
	b=x7H+3TrCBxQa+mKzpb2FOjG/571Q+FV0bDa6R0pRhEcs4jDymXFqJPGcUDlhGBLbPkBtd/
	VwQ075yjR/TLT25dxlA0mG63aDGxu+a9LZbb3VtUCo8n/XWs7A7EiXi6P+biP5sY9LJR3i
	3asvMP6mkvlelHHWN40FJQZOyoTMSJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788293684;
	b=4oyatAUG1cL8+JxsY/xHXeQmW8CuLHfpF4mpGSSpLf3XuTh10GVfaNMRKE1hfseiKRdZvB
	XR3ww0bLhkcJkYF5+7usgO9UYFfEEiZGjhH8Ntc2B4DHI2jylwUsCDTQCDOVShI41qGEl7
	ykdS8FMVsSyNBDXg1DVsbg5xjONgGqg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oK7KIXR6;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D443760232;
	Tue,  1 Sep 2026 20:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30A11F000E9;
	Tue,  1 Sep 2026 20:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788293683;
	bh=XYAL/uAoi+EN4roiOHSrXabP2vbnl7qcOw3MP41npbU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=oK7KIXR6KUMFaGOJIUsL9dZOFAkwrVf2yKPCXU01KHGex01sBreWT258WZzUfcFn5
	 N93Z1YC0ijmCWwzdoNGAU4G9utTIZGp5IgWf8X4H4hbfF5zVWFBqKBg4YeUMPjN0IR
	 GRqaT6bQ/HcAeFBzveARB1bTlhtt6tGhp5xI9YMBwzO/d1SEgK960i+4ONjpEjdAwa
	 7tG2nwlX09g2Zqlhw5BescVjXG5aZz+VId6dbPlddwI3F+7kLFJCguutYFwbYGa2Rb
	 BvAnrQEVhQOr9OmQCQw70saSaDN2Yet3d9/+LJIvw+JtUjv3/nv6xht6k1tPEvBw4K
	 3vqUArPhf7QvA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 08/17] crash: Extract crash_get_memory_ranges()
 helper
From: Mike Rapoport <rppt@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
 chenhuacai@kernel.org, kernel@xen0n.name, maddy@linux.ibm.com, 
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, tglx@kernel.org, 
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
 akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, 
 kees@kernel.org, thuth@redhat.com, gshan@redhat.com, jic23@kernel.org, 
 james.morse@arm.com, ardb@kernel.org, leitao@debian.org, 
 yeoreum.yun@arm.com, sourabhjain@linux.ibm.com, coxu@redhat.com, 
 tangyouling@kylinos.cn, hbathini@linux.ibm.com, adityag@linux.ibm.com, 
 ionut.nechita@windriver.com, liaoyuanhong@vivo.com, seanjc@google.com, 
 fuqiang.wang@easystack.cn, makb@juniper.net, piliu@redhat.com, 
 ebiggers@kernel.org, jbouron@amazon.com, mclapinski@google.com, 
 me@linux.beauty, graf@amazon.com, bgwin@google.com, robh@kernel.org, 
 takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260826092541.3905933-9-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-9-ruanjinjie@huawei.com>
Date: Tue, 01 Sep 2026 23:14:00 +0300
Message-Id: <178829364020.3691424.10343800427604677653.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52E0414000A
X-Stat-Signature: e37x9o5pf6nci83yqb8x7jyxci568b15
X-HE-Tag: 1788293684-859325
X-HE-Meta: U2FsdGVkX19PTMGF07XPfnFabbUDpDFb2+jXuF3kU4RPB8PcdN2HkqyJFQGiV6DnJ+6L58TTzwQ+9ygYgwhBTBRQBpq6Mld4/tWkiEzOD+oCEtUJZgKGI6BDHOCSPn5z5wW22RqVIAkU5G36e1rlBnxofqkshJF3XALZ4gzk5jycDyA4TQX6aegIYw/qHg5Vfn/nb7R1MF/qLLNybMbjO3Pjn4csRvGC/SmTXe16qvqB/ZNbVK+zekSZNouvOfHfUvuuRO1/vuiR8Y3SL7OzOPV3qcX1h+BpZ/1MqrZsWRbsYjHQX2S8LJlY9lRvMDLBwc1I25wWTXIckDyyaYyvnqJwd+YCqr5mpAvP5/Jf2zPWLnRj37m7OSL/FAy50ggw2d4xNdtjSIMV5jIteeVtK2HT26jn0NmvRMPiXS9J/SKkfeCZnAXdoFXQGzbMhhFLiQMjQp50lbI+pUHSsl8xnK8lu/HmzCLEcg4p3e8DwMPrjIfmnsGCUCSKgVTgz9wq409yKVJsE2hs1bIMAQqlVg0ur1xFr5MvI24UOauIIuoxGBkk/iQbLYiyEOscyqp1jwYPGE8H7RDU3ifEnZcNNnhEWLrfJFolH4J5TD1KFj0h/XUktXstBo4PWxW+/CMCVOehhUoFjxvechDcf3rnpRsbanQW6ZA84GthdsSMTu2rt9iSAeeek87DcPOwbqhKTemvyZg+kFucwvtR5V0nHH9RGTHeZt7dcRk3cxbNji1XGbROidrXBg1Ij1o3q/alcfD3VulA65LEQmWEF27CHO10XLazX5ZAesWp3vdW+Ya61w7/QWnn6ezuY++V8SPaQDykTVfip3n5btMrgrjtTPO+FxZmCupsFsfXX3rYp7uccfIyvR3d4ZS5WPkmFGol/TftESf1QLFydTKxWzalSjtu6kqbXFBZmzLZkQ93QT1iv4Xj186OS4uZqC250/beWjld4Qign+mU5wLF3P3
 NOi3oJOx
 l5YmeNsoIL4oUXDwQIDS7q1DlqSVUbn/V7RL9q07awX6R5e8+BHp7FfMpRuSZEo8DS4SAvsB3FrSuvafS6NdBNLLou+NRBfNQtJV3JoFd/QWqbCFSpAzV3SmkGkSwRABKZ/YCCVqOAKBa/Z4zB0gHPu60WiGWo3b3qUNrUXJItwImIAjkeHJ5zuYKOYh4qRp7RI8aEBN7sUh7QkaO6OoJoVDxyk6u+5x8mZvwcy52G7wxuKKQrp2+uudw5d/Bgsvaiku3/Zw+h2Nj3DLSdVYNTqEf5NC81Ihzf9anXzeMvRZPWPfbvqpZlmQnGbbF0EJLwjlOXj31+/ITQqs8W3jNYIhHp73hEDEt4mMsikicDgZyG2o1pXPnMqRCEu3NK7ljeTpQi62wtEJkqmXKsz/PHth0pNM/cmUxNQgHG3BSVgNZTNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> Factor out the crash memory range collection logic from
> crash_prepare_headers() into a separate function. This allows
> the memory hotplug path to obtain and modify the range list
> (e.g. remove offlined memory) before generating the elfcorehdr.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>
> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
> index bc087124cd78e..619af312bd9a5 100644
> --- a/include/linux/crash_core.h
> +++ b/include/linux/crash_core.h
> @@ -62,6 +62,7 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
>  extern int crash_prepare_headers(int need_kernel_map, void **addr,
>  				 unsigned long *sz, unsigned long *nr_mem_ranges);
>  extern int crash_exclude_core_ranges(struct crash_mem **cmem);
> +extern int crash_get_memory_ranges(struct crash_mem **mem_ranges);

No need for extern here as well.

-- 
Sincerely yours,
Mike.


