Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0E3D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187596B008A; Thu, 15 Jan 2026 12:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1305F6B008C; Thu, 15 Jan 2026 12:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE20A6B0092; Thu, 15 Jan 2026 12:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC15D6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:47:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B51D11A043C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:47:00 +0000 (UTC)
X-FDA: 84334929000.15.FDCBF55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E5B5080006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:46:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aN/rWVsZ";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499219; a=rsa-sha256;
	cv=none;
	b=jlZonj5fpGcOSNAYTJwtPeALTV9iL3OpC2GmXWAUrPAno0RUy1n3aILk2kB8TP09HKfnxM
	D5n4LerkC0YqyRSQKLTsTLwnVciRRAELtTTb1utKlsuX3DuWmnC33BS94qmj21bIH9olXI
	1PXsqTEnrMepp+hMl2mjK0dUxgRdMAQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aN/rWVsZ";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6W9rS1L0fb44L/Qvc0l6GLZE0oaj4dGC2DB+JF1JWs=;
	b=g4wyv9shkVVOVjdOkZ5ZpgA9PowK7J+3g+PZ57niO5b1OONQLb/9CixUTNJsZ8jynn2uU2
	UnwM59r3mWsNTlRdf9cLIzm6+0ESG3o/wLGmN+VRRGFpetVKAtCtBwFnHpyGMb/lBmF9B5
	AwFoIpTL6mSNrdD5FB4PuMR2G452Usg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D573E44379;
	Thu, 15 Jan 2026 17:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDABBC116D0;
	Thu, 15 Jan 2026 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768499217;
	bh=KG3/QqkLWkU5xCkH5gCixEue8EH45XFlDtjNOlWXOCw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aN/rWVsZhxyQxbAGV6aAfpnyTBmZHYIcOKfGC1RzU/XnkFJoUcqg54DQMyMrB0bVx
	 e7Q3rJu95EnLHQbb+26Bk/i4pOpgX9n77m/D6KBtlYai56hGy0xSSBLcLZq8rFCmn1
	 GJBKhnpi889zYGezWxiSrkp5SyvbQsRcNyoihPAg=
Date: Thu, 15 Jan 2026 09:46:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 26/30 fix] mm: mglru: do not call update_lru_size()
 during reparenting
Message-Id: <20260115094656.d34a828cc6bde0e0f8511071@linux-foundation.org>
In-Reply-To: <20260115104444.85986-1-qi.zheng@linux.dev>
References: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
	<20260115104444.85986-1-qi.zheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: uzfz4n7ugusufo8pj31ww9xixiwq71xu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5B5080006
X-HE-Tag: 1768499218-555178
X-HE-Meta: U2FsdGVkX19Gn4kqUR2Lmm93NKI6Y1n122vwGHia1IyugpLameKAEz3f94bnH+IsC0dOyPcSpUeuclVwzcGYbCW/vE0sDHfdvUgJu6umyJp23s1r54Id3ujuWlEZbzZ84xXQA/s8sHd3O9xh8CIiOaGmSAEsExxlK9LVhJMD9ViwewsfNHUUb27mA6y7kdUUbpI+vfhd1MyogDCfJruN4qH924x2ASYRBYtlVcWT6vf3OmU4CtZMA2Aao1d2f2d14xVSRkJBzelnDUldiPJEcMnsWzZ0Lgvqh9N5MeUBy5Y8BW8N9dtJqySGOlF1tF00+XfY/jI8tHB0nHAwjW5yJ1TuqsnRPkPR4NyseLf0IfdjQRCDQ6MuGRyWBNxnw/l1HYcQmLXcFmcJNDHsAx6FKeuceMfblkV8WrnGSTX+fcPqchKslQ19EA6/2uLvhq/+DS6maRfCpAETPBF1LwbTxw5ZAb1kH9BLFgE47FipKiWcrmc5Y/P2LjvSMK1KCx8YsuqAw289ikHeb7u5hP64ZeRgK3BdWbnPOD5aUxqxfPYJOUenz/X7U0j454qUQihh1m50LRqnH/QALYt2s0mYuxDOXgpKi2eJylBUh6Qg6MD0J/N4O41GOHFc3+Mt8cMx37hDhiI9fgd3exG//kiVe6Iv/mOZaHrySeddR4Qts+tjbT3IwTLVuPjvxkVEB44dIOUYtxQOOQNzdI3fgV1PIAJ4Hjw/b3+PKm9VSpvufI9KeASzcjRerOjFX3/MLwwGbcrESMnMdDecDbIL63+PbPcwd4wXgYKK08vBFGIcT3yEc4b4JfYKrt1t9tUtPAqde9j7XjojXHpJPWdrz4J4Vh3tAq++QFeAEQRbUjmoMis48+OJywLXTAtQAcSRN1lIj3EcKWJ5E+BpuEKzYpgcmYZk+uTOE6wTlRFv5UdWZ6Ve4W1gKtRt0VpwQYMV/xNvYDPAUraneWmuf+a57od
 wJg0gI+U
 LEeXjXJvAn4M+cWDUa/TMtCmPBd+1u4AkIVmoxp5xdjN2QPPUDPOvq9VmU7QpPZwfldAEXhGOgMBIdYaG66fPvEJUb6MGyBXFCPwUB7AvA/oLvz0d+S4nKbH/ecMw+0eTIP4Pk2LG/xs2JweFBO22wqrN7bvPTrb+ekqaWrxVZrgCs0RPof2ZXLRTnLfhXoXopNNBSOcn9pGxfBrEBs0yu67YdBnXHLj0zta5B9wARzHDypbqYfRkHyYU8xMDy3PY3EJ7LxB/v+oI/H4aRVhdPV7JYWCYD2OUHo++24zedBVzslNuXMc3EV6nMwsnd/yeSSAg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 18:44:44 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Only non-hierarchical lruvec_stats->state_local needs to be reparented,
> so handle it in reparent_state_local(), and remove the unreasonable
> update_lru_size() call in __lru_gen_reparent_memcg().
> 

Thanks, added as a squashable fix against "mm: vmscan: prepare for
reparenting MGLRU folios".

