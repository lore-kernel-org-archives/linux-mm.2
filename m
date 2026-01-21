Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA829D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D46D6B0005; Wed, 21 Jan 2026 01:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181FE6B0088; Wed, 21 Jan 2026 01:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F3D6B0089; Wed, 21 Jan 2026 01:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8F756B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:43:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 943F0140804
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:43:12 +0000 (UTC)
X-FDA: 84355029024.06.93F94B1
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id AEF611C0003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:43:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PmisL8fV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768977791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGJUEukW1YF975sFGms4Vf9mUEAliFTKB8iTKnSd2tA=;
	b=XpOGBxnXkw/54yQk15ynukhWBGvNARX7wMggH25hmIqyn6qVsFpzk9kC5P3kJ6Ow1FsvkZ
	q4+lRSbb+cuGZ5/Gn5WwNtNlnZLuWuNzIJb3sJXjrblMPdoL+fHE24/fLppqJcRGlsRzlo
	Jw7MenFL3IroqSAUxRb/sM4eB6q691o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768977791; a=rsa-sha256;
	cv=none;
	b=obtBj+cLEWMEPtN5j6id0asvTe85Pxve9bz8umxZATNp5Xck1pjIhIjrQwZBZfmIHgrFqC
	OmCf6b8tNbFTFMWilbll6tH3Px0OnkCz84xTtQlMiZDxB3TA/O/IVO6zn22/31oCIZ7Nv3
	Mmx9z0UxRgCgniPSiY8C4lgmXi+0DDs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PmisL8fV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Wed, 21 Jan 2026 14:42:49 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768977788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hGJUEukW1YF975sFGms4Vf9mUEAliFTKB8iTKnSd2tA=;
	b=PmisL8fVwidYRQ+1wKoRmywBHe1c9OlAG1/f/voGSFPxt6M1UjYLJ1L+RfuwuIPbNtUL7P
	QxFnWHe3Llnl25im/zg0TMUTItqt6dBizeIPepolof21zfnIeVPrxVDabKRkeBoXCMaBZV
	VFl+rVnVrirg3EbJZ77csqQzMU/XIQ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 16/21] slab: remove unused PREEMPT_RT specific macros
Message-ID: <v6govsosryla4nzgzbfo3eeiziabn2tdprzhg3zcpoxkxq622f@2ra34j7326mn>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-16-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-16-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mi5rmxza8i6egbzqyf3ps74ychbsecbf
X-Rspamd-Queue-Id: AEF611C0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1768977790-232296
X-HE-Meta: U2FsdGVkX1+Q7oakKHCXk60cOi0Qzefo6vnVcA3Czns9iAW+eNZZm8Gkg8+RyaIU3oBobb4GrZjKghEEb3DKPLttJGTAoPpUPT7K8re4/ZDce717z4IQyC2k9eQCqz/cU3LxtZ8qzAVKvIUDT968SA5VECB3963OYlTn6v8mknA/20y+fbWI54ZUU1HY+dKsOrvaHxAz6j+JzazwlIGEQAYY/CONdToYaOUcYCEpRwU5c4SMI+l9li7uaGRsIyoof4Z3WzYlbrp+X//0PmIENrphjENsw7X8jT+0a/2L2kDqkaELvWjKtP7hab0r9cEcNFdxMmzQrLy7AF5LHnVf8l/VpA+GNt8QGNcoA2YcNk7AJZcqiJ6/qzPKO0ShExmITXKRwl+IK9ftOM+Vffm5QSYpgaZj/n9piSMojQsmXkMYexlDOt3ofW6TXZoOMb9xiEfVe57tK1XUzDhrF4v84lNjRn9X8Xb7e9W1dl3Yeknv5wI4Y94ymQXOBOOHvhTSZdz0qEQL7CbM9gpoYLVz6aCrPY6B9QD5yZyv95Evg+BkK3IQSeXh2Sb8B5BCElMfqwYGnOOH4tNnBqBYFl6AOCWmFmVG4OJioPkpRuOxVx3HHOxW0jZKpHTt52WiIearuz7mxKkH8KTQbb4I0FIzA1Emz683eEpQTflda+wRxpxy4+rY4K6pzZ0M1QseL0IRzlx+fHvZvch9uVqZdm3Li7QkUQ04lgW7o62LO8INzPuixzwACLT6VeDPWMXqGQNb5cpWMwljj9nqUACqWAh8p5he2aTabpfemx5EOJpnagvQwtbdEKxYPrOjKUgbjM9MCDmX8s0SNVmfDnXSQEp+btM86X2DaRW9QAExZIoXrLZXbH4bgrSVuy6SHEm7dgwLhJCgT8iC2HkR32v/kZyJ5bNFXj2dsaBKcNRljNSbDoOHTgRR9LXku5vqqsQu7Qva0AImVKC76QgkvloCpfm
 w6Q+noVL
 BmWhPCnkVvnBPExPbPQYKljCDO8ldtSBYVBZMroGu7n/baCFH1Vw5VtLmjd1sLHA/Lda61+kXL+9cimtDACTdRgzO8W3w4vxAagyvKMXHuTJpaAwa/8mW+FtUXzkDvWnU/ax50nX7ms453gmAtSiVDQASgvBsVJIKKjOZzJ4R9hKo7KPJovaaVAbF6YEK6kEZEcyV7/XdeBurD6Kdvyt43MiHVdvgehLCecd5Tl3yxTjCaAgHo4nZGvSGLijAqX6TCY4rS8h8gFu6ImNBPaIM0wC5yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:36PM +0100, Vlastimil Babka wrote:
> The macros slub_get_cpu_ptr()/slub_put_cpu_ptr() are now unused, remove
> them. USE_LOCKLESS_FAST_PATH() has lost its true meaning with the code
> being removed. The only remaining usage is in fact testing whether we
> can assert irqs disabled, because spin_lock_irqsave() only does that on
> !RT. Test for CONFIG_PREEMPT_RT instead.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 24 +-----------------------
>  1 file changed, 1 insertion(+), 23 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

