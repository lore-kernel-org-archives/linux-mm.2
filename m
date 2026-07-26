Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58419C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 08:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222746B0088; Sun, 26 Jul 2026 04:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D33D6B008A; Sun, 26 Jul 2026 04:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C116B008C; Sun, 26 Jul 2026 04:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D186D6B0088
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:23:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AE6580485
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:23:29 +0000 (UTC)
X-FDA: 85030238538.19.9FE65AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 96A88120002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:23:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TeXg6iMc;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785054206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EURZIPTZJFvZM2NBjtixgY4zUoPQrTRaxQBigdxQ/mU=;
	b=3fKzxCFsPykfa82reUjd2nsQuzUE+Tzcj5lVaNPc/Lofe15sssJzBJDi6qrLF6omByAr5e
	wj9YYS74zoL6Hm1PPCLoCm6jvFY2LjH89AJdM2R8ALgpW3ZEQfcqnCCSwHmYCcsQMbKHas
	/qfjDfpJUcYsAgTAuAWyO5COIXuSMvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785054206;
	b=Ykm49BJ7EkOrB+Le7rUvP6X7nOf79xKiORAG+dSjwmCQKPvYtUz4wjhl+L2XuiqvxVlZHs
	1N5rmyeNXcH3nEDchTEbg4t6z6q2zMfTheB6RxeBDHR+g5Jg/OViCAoV2GrUcdlQj1WkR1
	cRiez7JoNZYcOw7NCzTT99EtKTo1yXw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TeXg6iMc;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 996224074B;
	Sun, 26 Jul 2026 08:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB45B1F000E9;
	Sun, 26 Jul 2026 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785054205;
	bh=EURZIPTZJFvZM2NBjtixgY4zUoPQrTRaxQBigdxQ/mU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TeXg6iMcktCeyB0+3f1Wqj6isZ1zp0BU3PodckqWnMC2VKkG+ycD66oY2ApKlngBf
	 yAlCvF0EiSAcdRWOHejLHvFI2lp/BfVYEJaNEAezyC1m7Z22pItQAbp+G5n7Fw7F1/
	 7rHkZrbYeJQC0lUoE/g5t+gYdHVntH5IjWPqatLleUPfDUGmpwWFAv1WIK5Td3Iztu
	 JvyEsSwzlU8o+f2iHWM0Iqfkryb7ufpyENncD3S78477VweJHa2DypdYjOEzepQBD7
	 6Dyr29IFlCQZX6ZEICY+Ba6YdflI6c05BKNRGKONCtuOWHMgQXReJZs33Ey9qNuJz6
	 /Ff3R3RjZRV0Q==
From: Leon Romanovsky <leon@kernel.org>
To: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
 chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
 tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
 jgg@ziepe.ca, akpm@linux-foundation.org, namcao@linutronix.de, 
 ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org, 
 Gou Hao <gouhao@uniontech.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
Subject: Re: (subset) [PATCH v2 0/6] remove dead NULL checks after
 GFP_NOFAIL allocations and fix xive use-after-free
Message-Id: <178505420268.4050106.14417810250582879470.b4-ty@kernel.org>
Date: Sun, 26 Jul 2026 04:23:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f
X-Rspamd-Queue-Id: 96A88120002
X-Stat-Signature: 5znf5mbkfkmt758qray8msagf97z5ccx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785054206-612829
X-HE-Meta: U2FsdGVkX18cpbbphk31ay0gEdQYjAADqGHWoQO4aeiT9grJret1IPefsmFJMlsgj3jAHXvfCQEdLJh0noXqzDYZikdwZazZ3o3ES+u+Kg0cCGLdA5CjY0QJ2c7+O9TkfCT6J5WzyDsecs/GTZrzH3eR78/+ljS1UAKuEeQLBqB4Csk0Q8YyPY6EDliRe2m/ouCkKubjGWBrT9WikIgfOJ2QUPjonPrCmvHha/fQ0ajHwN++gusSVMppU6LOe3akuXrKI21ONzx32jgHh7k07QjdSRxagbOgaL8CxJBro+VyulXaYCUqeHjmnbH7k1JrjsnyknZlIkfCaGPF1aQDiMLG0VLgvb6CULqb/JF/olo7FZeqsaNgGmsT2cAh1uN2+hSYlgMaAOBqjHauidwkSdxvGEGNc+dvRWLAf4KRdu+1OVweMU864s8QlvDIW0fpqshbk2jN7TgC6nkStf5skieUKz4gWtxT1lkOBwoUrRutuRC3FSzgSYgKKjy0Aat44z+JaJCLVXXdlk0xVCqIVIUJMR3DctTiP3tSBtSyKlOs33hHP9qoecYQ8RzDokHKDLX22HgXdpqLvAFMgffNiA++McKYifGRe34VnhgFg7tmuVyYRgwLRil5w/5x/KRmBmisTbRxjXu0/WwO8QAulnABgbquiLbbeoGyD/8V1uOV/iVvdj/wtQJ6KDT7BNvkaA6i/gvpUUa33sX7xycdp4rYgIbD8VHi/Fkl08avy/O8P4lUdeFxHCxF5CkeLS+W5ljlVI2tPdvs+fUDGf97dt96EChNd6fTZgpPic1KeLxzzILXCDYmCh/DYVBdDo3h9ap3jPw4moV88yJI/61m/W8f5V4qeJ36xYU9xmRPv661L7iwXHwBop/CfFhiqsC2O+V7MtRanoMGO48v+aV+kNExfYaoMSuRlHdgdaUco4G30NScCNjDlG0BoWEkazGq3sch+w5mBJjVGOQRCn8
 TdcPQNi7
 6oj4r5WmL76OEQxLKtLXeVcecLe/Jh29ugdFuIngXK4qOq0IsM+nHxgw3VGklkAGN1Q2Gsc3yZMSdMNVnsmugbiJ62nGLrObA2ndnfIWwEXe52kpqKkX3s6EKXdopaDeq4aZZcSpleUy6NC/0FcUw12hfZV2B9uwVLkx9Gs+vYV6qVtYK0089H8YRz/LvVE3aYTfbVPasK6ivyo8i6FZKrVpdzb0X/zu5LR3UAgoqouh7TbMcCQQwVOXwEp9xVWjgY2c3ZjE9nqBNPxLviV22r1QIwz6uDPtlh2FF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 24 Jul 2026 10:28:45 +0800, Gou Hao wrote:
> Changes in v2:
> - Remove the now-unused out_free_domain error label in the xive
>   patch after deleting the unreachable NULL check goto.
> - Fix a use-after-free of xive_ipis: when xive_init_ipis() fails,
>   the error path frees xive_ipis but xive_smp_probe() ignores the
>   error and proceeds to dereference it in xive_setup_cpu_ipi().
>   Propagate the error return through xive_smp_probe() and check
>   it in both pnv_smp_probe() and pSeries_smp_probe().
> 
> [...]

Applied, thanks!

[6/6] RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
      https://git.kernel.org/rdma/rdma/c/a273210687f255

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


