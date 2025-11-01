Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2844ACCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 19:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586D28E001D; Sat,  1 Nov 2025 15:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538DE8E0015; Sat,  1 Nov 2025 15:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4274E8E001D; Sat,  1 Nov 2025 15:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 329698E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 15:46:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEEEC12BC13
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:46:14 +0000 (UTC)
X-FDA: 84063069468.24.C52EFEF
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 183FCC0002
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:46:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bt6NhuXw;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762026373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSk/sZRQi90GHI3IILQtj3YgPAQn3xbHNm/4+VGi7to=;
	b=Vm2aj68Z1fenJF9u9Uw6DER/hNZlDuKiROS/MXl8Ya3tZ1ydnWb5S4H+Vbh0MqMha6o7cg
	hC8ONwPCyx45ajGIMN78fJlNgz29OU5+cGJM7C3B80c4A6SBDQsEFvOwzsI5wv1CDECfPJ
	gG3tkFNFXjZXzog4NWYWWT6u1KEx1Xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762026373; a=rsa-sha256;
	cv=none;
	b=j9AbAVEBzxG0xt+3wd0Hp9krWZCErSZbdhwHI7YrK/3ujRv+m9l1PMUVA18WOXyhJeUmBh
	ij4N6jEXfUxQKCvoqCFH1G4RfvjfvdjrJP7eWeU1T1cSh3wCNWXjtJ4PwDgxPCfMAFk/xk
	xpByt3PcBvZXssynyoiryxIKT04Aulc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bt6NhuXw;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <57bbade3-0707-4045-b39b-2053434b0b7c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762026370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qSk/sZRQi90GHI3IILQtj3YgPAQn3xbHNm/4+VGi7to=;
	b=bt6NhuXwWlyIZUWEiIsROrc2jyonkIZX/DOSReszd9+6z1Nhl2up7ZnTMedodcIqC9ozwX
	W6aLNMDub//7cjEzYGIR3b7lj/p/0Mp4ex4mSvTR50MifJPiYezgJYuplEidrWU1FkCTxz
	qJsT50eEfIWOMW9JdydU/DYe9lZNic8=
Date: Sat, 1 Nov 2025 12:45:59 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v9 9/9] liveupdate: kho: Use %pe format specifier for
 error pointer printing
To: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
 brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-10-pasha.tatashin@soleen.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20251101142325.1326536-10-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 7mrr56e7xmuubtz6je8rfhg7cqodeg9a
X-Rspam-User: 
X-Rspamd-Queue-Id: 183FCC0002
X-HE-Tag: 1762026372-961978
X-HE-Meta: U2FsdGVkX1/MOzs0JKAhN2pSpSjKxiX/ENfLG1sSLdjPtz/eUuPnAIC0mXdIA0d8VeGzXM7EauVKFDael10Rl1P0qy4RI+y3NVcFJ+ADOCKoG2tGpAohc2EYPWCfbOoe2NBqARjFGkdMCd/9Q/PYZqx1nhiZcGzwTh4PE6s9NEVQdvUnDAyPtHn9+F/xeRD+GIKDd/x9Rh1IQit6JshJ6LB88dQRwE1F1xDYqZDrLWsxPdtDUWZhdv4ir65P+Wgy52NvbJx2YwQ+gypKDyaxPNMYwZebuKTuI5/zfyP8J10YU6vjNCzuQaoQUPZ1mxavWeZPyfImqcyitLEbP57VZvQePgbPLTdg5SXMNvZ71G+F8dIJr7YmabcFWOSAt3r045jBWisXYGFAupAVo1N0B2rwgis+0tB06kNL5ciaOFzetuxdYincEuOM5R9OqUY/6Bvlkq91uwPxs5Z8Iq+FluFrGzj2cdX4zxMIeRKvsnj9rb1TKxKxF3euQUPu9ftBuMpgWgLVNUsh4ePeiP+UGrySqfbXfxr1uf6UmDT1ntZ32s/ZI6KZT8HdScmliKmQQ8NDQDX0BevktFhWz+w/xpOFwB1FcYEIAfggCRPFgnnm0YPngyGUBQtoMiTMq6WXJcZETl9aeFrvSu5P5vELMqMBBABOAZdOnm/oNqKBoVs+ldPBlZn/lGH7QqrGVQiUoKgMe5bS6YnMHfuymHxCsdlQEueWqcIT7zjhqYS8Ft2txhtehg6mcNhVrX9h6t1teWeOKvXeC7ha+sbasJ1Eam3eSnETGj3P4ZgmeCfLMD+j/cZvM1ceP5Nyr4XDSEUXGBGMbS9pSR9qoT1x70quJJYd3txWM0IkxhxMYGC7D+P9LKR+OOcc+UQKFFgGbZEs0eHjd3Y/7OpexB7utdAAWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/11/1 7:23, Pasha Tatashin 写道:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
>
> Make pr_xxx() call to use the %pe format specifier instead of %d.
> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
> -EINVAL) when given an error pointer created with ERR_PTR(err).
>
> This change enhances the clarity and diagnostic value of the error
> message by showing a descriptive error name rather than a numeric
> error code.
>
> Note, that some err are still printed by value, as those errors
> might come from libfdt and not regular errnos.
>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Appreciate your help, Pasha

Yanjun.Zhu

> Reviewed-by: Simon Horman <horms@kernel.org>
> ---
>   kernel/liveupdate/kexec_handover.c         |  4 ++--
>   kernel/liveupdate/kexec_handover_debugfs.c | 10 ++++++----
>   2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index be945c133a2f..167c761988d3 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1448,8 +1448,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>   		memblock_add(area->addr, size);
>   		err = memblock_mark_kho_scratch(area->addr, size);
>   		if (WARN_ON(err)) {
> -			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %d",
> -				&area->addr, &size, err);
> +			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
> +				&area->addr, &size, ERR_PTR(err));
>   			goto out;
>   		}
>   		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
> diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
> index 46e9e6c0791f..ac739d25094d 100644
> --- a/kernel/liveupdate/kexec_handover_debugfs.c
> +++ b/kernel/liveupdate/kexec_handover_debugfs.c
> @@ -150,8 +150,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
>   		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
>   					    phys_to_virt(*fdt_phys));
>   		if (err) {
> -			pr_warn("failed to add fdt %s to debugfs: %d\n", name,
> -				err);
> +			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
> +				ERR_PTR(err));
>   			continue;
>   		}
>   	}
> @@ -168,8 +168,10 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
>   	 * reviving state from KHO and setting up KHO for the next
>   	 * kexec.
>   	 */
> -	if (err)
> -		pr_err("failed exposing handover FDT in debugfs: %d\n", err);
> +	if (err) {
> +		pr_err("failed exposing handover FDT in debugfs: %pe\n",
> +		       ERR_PTR(err));
> +	}
>   }
>   
>   __init int kho_out_debugfs_init(struct kho_debugfs *dbg)

-- 
Best Regards,
Yanjun.Zhu


