Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8B1CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 11:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770098E000E; Tue,  7 Oct 2025 07:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D2A8E0005; Tue,  7 Oct 2025 07:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CFB8E000E; Tue,  7 Oct 2025 07:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55D138E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:41:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB9031378AB
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:41:35 +0000 (UTC)
X-FDA: 83971128150.11.5868785
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0914580011
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:41:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=UyFM8PuM;
	spf=pass (imf30.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.51 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759837294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVVqjeLxgD3i9O/wIhyqQFIwAYLCkkVJe0hgD0tYLLE=;
	b=wGw93CEUDrtm72cxDcyp7VLDfMUhfOhhSVpysQtA13CgL2DsYprbmr7+y0/8sai+QaoDpz
	8XfoZwnPUh2BPs2Vgj9w54/yYfvJ+cSPrVYNGOQyQMr75SpuevDJjS+Qgae0T5LA6N+kHx
	PGx9xJ1LieOc1LFha7hNX48CT7dmE10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759837294; a=rsa-sha256;
	cv=none;
	b=ujG+3M3FHGs7p75RioYeg7ospKuMge1CB95O6BuaYvNUlKAK2qSZc0y5nwcUkJTEkf8fqv
	0UWtvtY4rnteeETBu2AAfp8NvMGMI/w4Q5C5ilpqhpzW9EmZNV+0MmXKPr7jKeoMNO3iIg
	AnficIiMJJnOks7BN8vPUVSyPQTqNC8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=UyFM8PuM;
	spf=pass (imf30.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.51 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f2cf786abeso4112047f8f.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 04:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759837292; x=1760442092; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bVVqjeLxgD3i9O/wIhyqQFIwAYLCkkVJe0hgD0tYLLE=;
        b=UyFM8PuMOkLOIcDwA7QDucNT3B9OLxMIvTxciLxPhHAfh8NtskZ0v111/lMRTjyxEK
         m+NZ1mbLyCsKM4Tkf6Z+Q4Vmg5nFoXqMB57Vu3pP3PFIUfFhGmTzvnZrbpzgGgtlQ3n4
         ovMMhfxRYOh6pU/E5JIaHjeC7b/1NmCilRj+IWEvTp+9/qz8CDP/Hqw4ZJuaJgZYoI29
         Pqw+xs1rBYsCZKhep6Vgf80qQDAAGznBmbQRSpZ0GGC16u6FxsrvdOHkuO8tP3giFO22
         dBzABeIILy89jaBa/kzGBJlHoNGB3tZKc1iXmWk/AXxjBGEl7hLODOS53GvojVU4EOg1
         Fhvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759837292; x=1760442092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bVVqjeLxgD3i9O/wIhyqQFIwAYLCkkVJe0hgD0tYLLE=;
        b=CjqQ432pm1IQlalW3RZunTLiSSM9TxswWTqHBUQdtFqW3sDkAy8m24XXrhh/r/AX9M
         J26Na65k5Cm0c+Hz4sTWQ7wsB89kovQPqeRXP5jiAdZrHlS51Aaow2ERzyIB8+8FoGj2
         K9sh+7q+aZlqG+8/X1GSLNHbOcvlEeja36nQzvo2rgV52h7drRoeWcK6VblL6QuvcFe4
         XcV8ZUSwa8id9RlvdfIi/IAUfaXZExM9QQ9NDtDotZqP1SH49msScj1olg19HkVZYuD5
         rebL7oZebJHQhxw6w4LgSQ/0TRC6+G7qUPqqn93RmLmzMQmEUaX+F8l9DRqusO67Tgha
         FjtA==
X-Forwarded-Encrypted: i=1; AJvYcCUUXLSAuxNcYeq7Pe0uJwNXOkhPyNIsyJHFB/kFsee4jnuw6CYSQfwWkoDdy/LKcKVAJrZzEJ/CDw==@kvack.org
X-Gm-Message-State: AOJu0Yz4LnxH6+YltNENilUwfGoGHNfwb79pFj6A2U6gVEfCOLLTcDUW
	w+8pTsxjN25lm23SgTjhQgPhAP9E1gkRID5vYLU/F2LTnFShqJunVr02bFJSanErYzE=
X-Gm-Gg: ASbGncseblMvGDx7nrHUXUSaKIuX9BqZJ5qYL91VOFzOai2S2dwM6lGwWdG6piI+kHV
	6beiChzx0mwdhRF2LXVgF4pgRbiwGnkFZIsUkfgtthq5XzIeJzdJMDM49C2FpmxbIau850rSWtG
	JeKd4vzFovzRo6V3T/lbC8WG8te1eDy3SpWgevAu+vN+R24TghZQ9sa3Oyj79m/VQFAgA6mtIN3
	ATnkGpbnZZPolAbGqLP4+uAjwWqS9yK9Mu4/Qaj7rb1BGm5rdEN+or1ihqQwYgtPRjmvCZncp0z
	h0/nOeS/loH2NdE9G2VnzrWaanps2gdddkeCC7gOOQLb0xv3BclccGyfwhpdOi+vZR5+38hella
	plhMB27KyjQiZ7JGAOQlGqJPnk50vfEuQmnH5fVLeDvJyzMvX36R1QYdk
X-Google-Smtp-Source: AGHT+IHo8VdTXjwgD8/FNS6LOiLHWZslBDzZ7hsF6UeuCg9fTBT7ziQtU3T/lhLcM2+wkl6zCLMPDA==
X-Received: by 2002:a05:6000:43cc:20b0:425:7c32:d969 with SMTP id ffacd0b85a97d-4257c32d992mr4484683f8f.5.1759837292372;
        Tue, 07 Oct 2025 04:41:32 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4256866060fsm19573612f8f.14.2025.10.07.04.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 04:41:31 -0700 (PDT)
Date: Tue, 7 Oct 2025 14:41:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: David Hildenbrand <david@redhat.com>
Cc: intel-xe@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [bug report] bad error return in walk_hugetlb_range()
Message-ID: <aOT8aOJ88g_TxuEX@stanley.mountain>
References: <aOC9HP6nB0C45QnS@stanley.mountain>
 <4c3b148e-9019-40db-8ca8-2166ef011c75@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c3b148e-9019-40db-8ca8-2166ef011c75@redhat.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: rg88i8oxxnrw6pr4ha4sodn67cgdmg1b
X-Rspam-User: 
X-Rspamd-Queue-Id: 0914580011
X-HE-Tag: 1759837293-751318
X-HE-Meta: U2FsdGVkX18k7647M2AqJAfotuqMRG9RMMNvvGAZNKoJe5q+QZGUiai/5ot+Tamnx2nWwrnWDU8BK6edTaHnAWvQJ/IK+ITRYCz+ZT+BQJ1E4d3won1ornMcaY52XTjxVn2PeY8n2wAurTbIBj/wObMWiw6KlqpdegEqYNtiMBxnNiYiDCDeDvE658YcveVRhIwtbwn+CohBTN90YtzG31sld0hhsaDv2paqm2yc2xGDXjO+NY7nXZqygntl+BlnlAYS7bhdqMJSvyieuSW2fy/xFhWMyhc/kLZMb5Rp48YEeFRxCindYQ91iecrcRKgcdMsfRgDjHIGXblFxKln0Q/hxmpAWWdjmE7Lbxk0+mnNhcpqIwxJ0pfZFIG18K3nPKZOoW/kTHRyVUCnSSB0WBqhrZHVT7w7pBOEJbRTqKonpK8470Xqf3ioP1O1V8aEMcNXA7zX26iDqsKXa/k610kwLp0+2ZewbWjQOgzQGQfEGjkvkirNDc078h040aYvPQpaBWYArY1LrDSVwNr0QAVBscRlYfgdcPIblBK+ecr8mrnIthalbuMXAUntz0XhjiCGanuWbYNvlzYZbO2mz+qPxG7NI1ezJcZNYm4Bdt4r/vBMlCFo1+dpuEhQP/103fDvoXAQ7TeLirGClhhd5XymBfd5S3+gMhwIHBnMapMvlsZL1dhKfHpODO4zZTahyjYJivQ+cIqutsfP1Np7cUhy0LdomXEk20fJduv7tU2KvZ7xo1cV2z6pQD2qbQmbX03aN5TmifgD0eOOQzZxJMvwHDLu7+F3Cy/xRmE2o+AAhRD7y5ax2xsGBZuZON0CUFnHEytE111JQyW6Au2m4nXIIfr6sYt9BfTZI9fMVTAEV8ENHx5Cfw7gHw/6QZc9w3Y6obrNwINWH4OA2Lfeld8SoNsr3KMZirv7IID3/cYrHCKKG2ZDES8Pxx9TO9/1nmaiEB6obLM9UuuErJk
 uxLKUvUu
 hwwHBR27A5ULQWXqfoE1gSs2RY6OzQQBtFZ8bcX3yZYKLYf0JacDLVMyk44WMtFKJjbQ0Jfl2ynqN89/hP2Ku1XMVJ+ccUG3euXDqSbNqPCNWXNbwZqtf2EKKCstPDRGwJLIIi5UR1hhosvYHSIvOg6fYL1l/fDs1gRfW4BMrOo8gx/t1qYgAsI8QlYw5IVb8rOf8S2NINP5SEKAoVaXz9LepU+1tSELUlepB1z5FIQ5udpn0bAx2R6pyofyW8Mx8mRULNLT6jgLuErO4IIP+55ToNXgIEVwbBeW3hXS9PqsaS3yVd9lXu8/GypujGEjfL+3yclZxM+i6aWmWtpWqtKX7wxe12k5VjQQ30zdaThPWl55VR460kJeGe+QJTpud6XneuNLlzl8ggvQOCj45bTsLcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 12:13:40PM +0200, David Hildenbrand wrote:
> On 04.10.25 08:22, Dan Carpenter wrote:
> > This is really old code.  I think it's a bug in hugetlb.
> > 
> > 	drivers/gpu/drm/xe/xe_gt_pagefault.c:353 pf_queue_work_func()
> > 	warn: passing positive error code 's32min-(-12),(-10)-(-1),1' to 'ERR_PTR'
> > 

Thanks, David.  Yeah.  You're right.  My apologies.  I tracked down the
confusion and this warning is actually because Smatch thinks that
hmm_range_fault() propogates the positive returns from walk_page_range().
But actually walk_page_range() only returns positive with certain flags.

Someone explained this to me in Jun and I said I would silence the
warning but I forgot...  Ugh...  Sorry.  :(

https://lore.kernel.org/all/aECCaCP3BGGGUUa0@stanley.mountain/

I have done it now, below.

regards,
dan carpenter

From fb706e39230f6f2bc6d68a18837171ea4c1fecc6 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@linaro.org>
Date: Tue, 7 Oct 2025 14:37:51 +0300
Subject: [PATCH] db/kernel.delete_returns: hmm_range_fault() can't return 1

This is pretty tricky code to read.  It doesn't return 1.  This leads to
error pointer warnings.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 smatch_data/db/kernel.delete.return_states | 1 +
 1 file changed, 1 insertion(+)

diff --git a/smatch_data/db/kernel.delete.return_states b/smatch_data/db/kernel.delete.return_states
index a1b3553a9f03..cfdf252e472c 100644
--- a/smatch_data/db/kernel.delete.return_states
+++ b/smatch_data/db/kernel.delete.return_states
@@ -30,3 +30,4 @@ ubi_find_or_add_av 0
 xe_migrate_copy 0
 scmi_get_or_create_handler 0
 alloc_frame_masks 0
+hmm_range_fault 1
-- 
2.51.0


