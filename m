Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2579BC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAF06B0088; Mon, 28 Sep 2026 06:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C4C6B008A; Mon, 28 Sep 2026 06:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C956B008C; Mon, 28 Sep 2026 06:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3FB76B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:25:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5964FA0167
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:25:00 +0000 (UTC)
X-FDA: 85262787960.18.89B5EE9
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	by imf27.hostedemail.com (Postfix) with ESMTP id 33E5640004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:24:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NswKtore;
	spf=pass (imf27.hostedemail.com: domain of ruirui.yang@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790591098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksFkQeR/mSa3Mz1iwDhfUYANT9IVs/8bPwbPPKQtI4E=;
	b=erHgF3tBdD/EwTcJpYmzUna7sRB2C3lLvE6RxN5MOqXBgunDCUy7Jo4TQ61rCrH8LeSw50
	GTn22K+cI2/R8jwpdLZhsq3LJHvR28C4ACtbdUQqoCbD4OxB27Onrx6ae5yqxBtvzpyLvY
	7tmvzClsB9fAmEybxjzLEmBkLoUVjsA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790591098;
	b=VbFk5m8/sodiPH+nhLKzYOxR+EjUltPqOQKD/7TRquI9QsZf2ipFha3CYns4h6v8tB6dJK
	GpadXIOQdBPDYjKDU8TnvwAynENPWraMgakp9vAz7rTrHRIDiJR+Cd8/GQf2pobvhHNO9K
	tBulz1e7gTEnU0U65rJekvMeBEmUF6w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NswKtore;
	spf=pass (imf27.hostedemail.com: domain of ruirui.yang@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2qsLTZUYXNCuyy8IDZLxqiAQMXwe8wqDNcAp0qKJ77U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790591096; v=1; x=1791195896;
 b=NswKtore9qYVrR9vagccDrfbHyJJ8mLoexTlyQOOyX8nMj4mDLBKDtayUHTK03wcMnHqDgCM
 ZVCDSG5PnHjsONqAkaN6ghYKpdJ2i5doEGIlPAvGqf8fa8E9AEY0WMPLwQiy3WKspmMYcd8PTA2
 CWqwGR1xLv1bCr8zwYC9Yq1w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8692f2c2c9228f5e;
	Mon, 28 Sep 2026 10:24:46 +0000
X-Mizu-Trace-ID: 8692f2c2c9228f5e
X-Migadu-Flow: FLOW_OUT
Message-ID: <9c47dad9-2716-4ae0-b6e2-9e6b5c718859@linux.dev>
Date: Mon, 28 Sep 2026 18:23:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, David Carlier <devnexen@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kexec@lists.infradead.org
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
Content-Language: en-US, en-GB
From: Dave Young <ruirui.yang@linux.dev>
In-Reply-To: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 33E5640004
X-Stat-Signature: dge6pg3xajq443ad3nfkex17bc3ihtht
X-HE-Tag: 1790591097-806413
X-HE-Meta: U2FsdGVkX19/KXhAstG0hbNu7tCzGz7dW3lYp1eQ7pvMN1b2GdThTfznEk10lfwkTsiV75Hh+PR+ba5wAzghr9o5p56dFQfZj4wPN4iIP9VSBJFppTmslKFtXMcT6JcLTD2Cv4miR/S2s4VjN3VdPO4vdF6wq8dYCYQ/neJLasoLw+L150weFz+fYqa8qapK5uDLE0XVpT18u12cWXm1LF7wVkYz+X8IvGcmoDm019ug4cWUJ5kzZ3eJPKAysBzYmSfnGVmKdFRy2TNC4VrypXhHD3jTxRSxSM2qdSaJVBL0PGJIeTtiGgB+1B7UkU/gskgt708JC3lrKL3/dGtU9/GhzaOIWenUhDPYuq8z7Gm2CrOYnL7FvT+7WXGysy47F41YBYQZR/0c9LaSyGHTvuRKAY2Cs3agA10h5K4ZqY80IvFmj+DyakPcnFM5dS96Jk+Tn0NbV9pefaZj6H32sfbWDpasBWMgfhF3WNcIRV82/HXej0wYCzPT6oprAWSL7wghhhinhlCh0ba50j+ur28QT6FxNXHImfoDHZke1sSaAg9zcwRUOwH0BwUah4vBQ9ZhNR3+GjnJUYfy1osfNd/Dm5pcxNpuv6CEpYOUCzeZiFOr4BShECKbUh665OCG/psBmgfcqKYrkMMYOu5a7z0KqFfuiPs5gNJ9WHXD2FjXxYNCexAqrpti3omJBVsZQ1mP3P2fFKHy2o2NyAk6WZ+ZVfdzRdH80TPOtQYSf4VjkQ3yZ1+Kspfl3LuT3twCKT9af9iYdbQwXIEpkStrRwJXVNq1UxT76WPUZTUN2jtOW2oV6waFIOnk/N1V1pPM82snbCpXSXnKAXnUdieWK4MQU5yLwyJJ9Ee8+15CnZ4VdPz9pMgIDu1JeHeIbBeLH8C7BUJhN0v+hM2d82nT2pAJYHiPbllYUkS5VYV0TtIj3au0H9xBJLDGK7eQqmlcpZnyqOucErVlDqY9x2P
 yNB1BN60
 0EZ5j3aCfNhuWXAZgemni0l4LZnrVqs1tYwiE0BlFV3BsEaiQQM7tntAFtNusZMcAsKNt1s59/d6e2rtGlJVAHk8cBEq1q9z0aEAazDlU7FwfaQgCJ4SzbKFEsT2ZWXr2OdbixASloyi28dDGVUe/1CqPb2nh45zPK9zB5Eq02XhnZxorEdCl5mKIovFduJLad7b/8TzZuYzCQvVLKAK7+5wBFSrKe4tjF5JfSnRAXZ2OF/Rw4aITrbvaZULX36znC7opr68qr07blKb02BZ1Oot9uKMYzvVNFJSs8N+k9qYeUTPFLCcyotEXi7kr5HV5oCrctoxH7ICJfsgAV20VZBp7uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 4:48 PM, David Hildenbrand (Arm) wrote:
> The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
> needs similar information (although still relying on
> SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
> 
> Let's just export the value instead, so tools that work on vmcoreinfo
> will not have to guess.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
> SECTION_MARKED_PRESENT and further cleanups" [1]
> 
> This patch can go in independently. It would be preferable if both
> go into the same kernel release ;)
> 
> [1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
> ---
>  kernel/vmcore_info.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> index 5a417f8a922a..7833a36064a8 100644
> --- a/kernel/vmcore_info.c
> +++ b/kernel/vmcore_info.c
> @@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_STRUCT_SIZE(mem_section);
>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
>  	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
> +	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
>  	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
>  #endif
>  	VMCOREINFO_STRUCT_SIZE(page);

Current crash code looks below:
#define SECTION_MARKED_PRESENT          (1UL<<0)
#define SECTION_HAS_MEM_MAP             (1UL<<1)
#define SECTION_IS_ONLINE               (1UL<<2)
#define SECTION_IS_EARLY                (1UL<<3)
#define SECTION_TAINT_ZONE_DEVICE       (1UL<<4)
#define SECTION_MAP_LAST_BIT            (1UL<<5)
#define SECTION_MAP_MASK                (~(SECTION_MAP_LAST_BIT-1))


And it does not match the kernel for below chunk with ifdef
#ifdef CONFIG_ZONE_DEVICE
        SECTION_TAINT_ZONE_DEVICE_BIT,
#endif
#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
        SECTION_IS_VMEMMAP_PREINIT_BIT,
#endif

The last bit could be wrong in crash.  So all numbers should be exported in vmcoreinfo.

Thoughts?


ThanksDave

