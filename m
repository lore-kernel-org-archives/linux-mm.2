Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BCCCD29DDA
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 06:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBF06B009E; Tue, 13 Jan 2026 01:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2D16B009F; Tue, 13 Jan 2026 01:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9956B00A0; Tue, 13 Jan 2026 01:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF4116B009E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:38:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A9C1140182
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:38:04 +0000 (UTC)
X-FDA: 84325985688.28.2C6CE61
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A64E180003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:38:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ffW932ut;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768286282; a=rsa-sha256;
	cv=none;
	b=lKv3j3K1rLCYLFcKWc9/EPr1tcwQS6QyrPCjsH581dHDil53w69gdZbUrSbviNQdiZETat
	D4w2OqcinefrhbGfJWsuT4ZMtLwR6uXJJOvW1L3PogfpCCXwQP9VojfOJrv8/YtW8vse0B
	B4y9cmb0Vtx5Ezss5SCxz9MBryWu++U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ffW932ut;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768286282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHB2VTiwHe/vc3UmYyzgVrx5abBH1msD+t9uqXPLaOg=;
	b=4ukpnky4DfhGHMufdq7VESchZ/s9kqrLvNXND+DL7QuJXKOmroTLzd5qIdq2GtPF/K4+ku
	/hMcCQ9OA8UXRTCtDTOyyK3hdWByfJKtZdiN33Ed+jIiTMq7NlZPc2NJfg+nJtI/P1BTMn
	5AN1GXi4ScDhZmbqvmT3wEOLl966RZo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768286273; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=aHB2VTiwHe/vc3UmYyzgVrx5abBH1msD+t9uqXPLaOg=;
 b=ffW932utukX2ji4yKL/XCqnUtgBCNXXitjmbIo6D9zbh2MJncPFR/O7EW46QssUG7pxqdv
 SR7V4mc+/OH7F8H/spH4frJRW/sd5WM0RKa9jGbdAjJcefpjo9kWkFd40mjvU+KD4mL18F
 pBJ+PtHPAOkFvQrTIZ8AgizhNlXtNLAotcK/gRkWzJAFbkn+y3GHqIlFH3mOUs2d/p4DGF
 T0eFtfRgGklmovCLvQJPjP7xXyyQrw0YuG1azaufSji8hUZWyawcbPABAzropO5pBwFYGm
 Ab+EvZnIHcOhOuiUcYBqyg0xW5a0dF62L36UdhM/rse9DOPwBxnymSFdAjOkAw==
Cc: <akpm@linux-foundation.org>, <ankur.a.arora@oracle.com>, 
	<fvdl@google.com>, <joao.m.martins@oracle.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mhocko@suse.com>, <mjguzik@gmail.com>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>
Message-Id: <20260113063736.29694-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26965e83f+27e4df+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <ee0bbcde-612b-4a53-aa2a-bc3f60302408@kernel.org>
Date: Tue, 13 Jan 2026 14:37:36 +0800
X-Mailer: git-send-email 2.45.2
References: <ee0bbcde-612b-4a53-aa2a-bc3f60302408@kernel.org>
To: <david@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 7A64E180003
X-Rspamd-Server: rspam06
X-Stat-Signature: q9e847axm55mrf74skt6bxdm7y7m8if4
X-Rspam-User: 
X-HE-Tag: 1768286281-226349
X-HE-Meta: U2FsdGVkX19XBRt1ifBfrAfOazeycC7mxJvdlZ6HU3D3AJSplObuugL21gSArhksYkgiO+3W1AE19oTKIQSSP/+y1dkw+tVGw1nBijDZ1tfV2ZcpWKvLNb3RF3UtuYTUh9hX0hXCpLOYhW57TMbOENsZWtebhNGunmqbjaWUDXM+s4IMDxwSdki2W+qqOLgSsWbLGj3rO/0Zg3zswLuaFLTxI5Pl1W3ZD5GI19w01kjESJBRSnLruvENYbXOl+ADFCcji2FkgwHPe88GzqBRdK7p0DutuWAdGZhlaMCILoZVDS3V9Ivjjx5xtBairmjT0QxM8OKh3YtHTUnLW8B2J73XByPQ/HqtrdAdoejOyMthE3j+rrLyXWKNOUfoHwbI6dZZPuilb6xzn4zgvSz1k76OdJEcuYd09wqZghMyvnCJ3Q4lYvt06EDkeZtaqKk45dSwAh0mNYjhaqxdL25zspXEUEKcvtXsq08Y04zTewSK6OybTqM4Cp7FFtskJk7QPq7gG8nlRjGsRLodgHDzfvhqBNHjqWhdmcV7a+lMbeH3OXWLVLr7O1jRCD8o7TdJ6X0BThgpusdcqiFP+IurbUNJIwPMsfQHi2gXWiR1MUbAfQ4p31YL48/Yqw856GpgamYxMS9HWfmHvT2rbPwDCzILaW68LPYhRwYSt3zG512MZP46cuAR5gX+sEr3tWswmUnwrkA/I+kgh9u2jMdjUt1A15fDNMoVSq2an8/KdrPa6PRn45Wg3DYoZQEZEJTFeIAfAXpl5xBBOYrMW9+H20qm1mfsR5gcjm8fke97+rKQcDtMB02vbK5m4L4vS1rSI0nWRfgXxGozbEMmKNIOvAtyVNrMxm3zHroH+R/2XIvVjqdUQmbTIyV3pak/BOxLle7P51bo3mFdZ6/3kNfayizvU+w8jem1v1E6HGJDSGXYu+yZR4e57Z1TLZpTTPUg4h2ea/jKX+h8CocM+nN
 xM4In/XW
 5xMreVcEFeR47UlcPeNiry+idIuSgRrj9rb3psnze2pM0qg/RdfUbosiNZ0QQlgQf3/9uUa7wca3hs3nxiu17E9q6IsW+wldjroHi/TUz+hyaaUBdfvwzmg5smN74b4oyp8jfIWoQS5hxXu4qsTOS8rfJHDNw5ZnAhdYRzXIgI+RKkkF9BHPQ10xa0oEoDvdaXAu2Sh9Zqvs1R8AYNrfKWbNGv93HZUnciffV/xzXBONPXn6ojxMUjSBtbBWKVJuvwKpo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 20:52:12 +0100, david@kernel.org wrote:

> > As for concern (4), I believe it is orthogonal to this patchset, and
> > the cover letter already contains a performance comparison that
> > demonstrates the additional benefit.
> > 
> >> I did see some comments in [1] about QEMU supporting user-mode
> >> parallel zero-page operations; I'm just not sure what the current
> >> state of that support looks like, or what the corresponding benchmark
> >> numbers are.
> > 
> > As noted above, QEMU already employs a parallel page-touch mechanism,
> > yet the elapsed time remains noticeable. I am not deeply familiar with
> > QEMU; please correct me if I am mistaken.
> 
> I implemented some part of the parallel preallocation support in QEMU.
> 
> With QEMU, you can specify the number of threads and even specify the 
> NUMA-placement of these threads. So you can pretty much fine-tune that 
> for an environment.
> 
> You still pre-zero all hugetlb pages at VM startup time, just in 
> parallel though. So you pay some price at APP startup time.

Hi David,

Thank you for the comprehensive explanation.

You are absolutely correct: QEMU's parallel preallocation is performed
only during VM start-up. We submitted this patch series mainly
because we observed that, even with the existing parallel mechanism,
launching large-size VMs still incurs prohibitive delays. (Bringing up
a 2 TB VM still requires more than 40 seconds for zeroing)

> If you know that you will run such a VM (or something else) later, you 
> could pre-zero the memory from user space by using a hugetlb-backed file 
> and supplying that to QEMU as memory backend for the VM. Then, you can 
> start your VM without any pre-zeroing.
> 
> I guess that approach should work universally. Of course, there are 
> limitations, as you would have to know how much memory an app needs, and 
> have a way to supply that memory in form of a file to that app.

Regarding user-space pre-zeroing, I agree that it is feasible once the
VM's memory footprint is known. We evaluated this approach internally;
however, in production environments, it is almost impossible to predict
the exact amount of memory a VM will require.

Thanks,
Zhe

