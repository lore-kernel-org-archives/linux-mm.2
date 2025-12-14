Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 783BAD59D99
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 23:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D99B6B0006; Sun, 14 Dec 2025 18:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1676B0007; Sun, 14 Dec 2025 18:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7B86B0008; Sun, 14 Dec 2025 18:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2926B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 18:49:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B98BB136736
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:49:48 +0000 (UTC)
X-FDA: 84219721656.03.D2E64AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12554C000E
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:49:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="RS4l/RZH";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765756187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yACnCQ9LzRbZJCfVUDbjIf7MgAPzLBZ+q+vV9dcV1Mc=;
	b=Gcl92oTx/5+tbQqlzefQCFENwLTn6tkiJ87Zwl0g+IkWThIyHH7oTqLF/1dMdHrsXJeZRX
	FmJ13qpIe4PbU/L7bk63wxxwuSBu1X7a8zDFnk77k5f0YeOp3WkB6Qf0tveLAx61MLUCIQ
	HlrXjMNuS8Pw7qextfOHKHAK3J0PwME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765756187; a=rsa-sha256;
	cv=none;
	b=t2z8YoTgmA/1aEvpdlznMsy/XD9rBcRBPxqUxLqb4G0wirS9PvvDi+Jof0Sck8ugC9XRni
	58UNV47PNjiaGeYRKZ2iOtjz2Eu4ZiQtfsz899OtQyoeVESW4orqmIQAUsim+ftbI5paDL
	/va/f92wZoPhXpJDF5caTQKEBeindHU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="RS4l/RZH";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 178D76001A;
	Sun, 14 Dec 2025 23:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C77AC4CEF1;
	Sun, 14 Dec 2025 23:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765756185;
	bh=Ah7HCannd9gaGWJFa84Zv3eVPb3Lkum8nZV6/3inVQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RS4l/RZHDooKtVB05At7vYIs8ePU8T6hnTv8ahVsuEi08OIL99u9pP8En9iILpv3O
	 38Aj/BeJvAL3Z8xFUpsjzqO7GehatUgB8vyqhSE+PsI6Wc1etruP4Q9bjCzutdDqaA
	 hSK4GTnriwfXlftGpNUwhii/vNnqJv2vezdgKQCQ=
Date: Sun, 14 Dec 2025 15:49:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, yuzhao@google.com, heftig@archlinux.org,
 oleksandr@natalenko.name, bgeffon@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
Message-Id: <20251214154944.6a6e91ffb00677a5164074e9@linux-foundation.org>
In-Reply-To: <20251213083639.364539-1-kartikey406@gmail.com>
References: <20251213083639.364539-1-kartikey406@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4mpm3nyp4ppgpu1e8kcki36tgbcoiu3k
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 12554C000E
X-Rspam-User: 
X-HE-Tag: 1765756186-488325
X-HE-Meta: U2FsdGVkX18JgnU32augqz3Px7Pf8siBGHMQHpTsxv7SY0L99WlU7EanT//a0jLbzolmeYuROMSOzMRn8s3Ux7shi75baKiwY9LtGojHxFv4O3JF799XCHVIC+R5fxbMKj9dwUR4L6WKuiwVa3djx0bLCcf+nVDUU72dFTMom8q8wvkuno+GrfxeYv8cKHnf1zPg/AsIFzUemLFad26ckX2+Uvf9fXeXUkmvz8Sn2y6MrktGR4cOeo79hAFwTdMddlFoIowFtgDMjK+lVBSZyDXuBz22H4a9ic/sOPAOAorMKCOZQEMQlUN/S9pbBVPlCzoN+hRMPEfE+NbBqqTardAcOJ5WeUFvKiZBnczolmjQ0+n688xddkHannoTdinPRJ+BKm2ygm/wICACGav0YygNAu41wQstsG7wq2OKppX25iDSjXfsH4AAEQnMCn6sWVwSI9mV0uN/oUIjbr2hwAtYc+bdBGJ4zgHXPlRVyUrXSFfTlu50MCR60SeTRiYDGXsD104gGSJsVkklv8ejMJ9rTAKBEYsel6ZTc7UI/Oc8Ntv9POjpgrU9mtxWaxZ+yUy5m/mvNaqSLfwlMK77TPzqQxLJuKcPn73HuHjAfZCafuRz5VSkF/t+gpZEnuOmx811OZRv7p+T8jbKv+AVBhzalxxRovOLXqh4iQXQxW0zzoxr76+wZY+5gyIIVRyBX0/8W4/MtFe8gKfc+y5WSbBJpYT4i1E2HBF9EX2gCRqSHAhPf0VxMAzHFuwM93Sy3hUZjbLiX9HxaNw8yszPPJcNbFJmZVaFCoY75gelTNNwgjfg8RCE9cLvwgf/M4g/t5+biI5Bwr6fmIaMnI2/ljitNValoSFVQviQyzEFssdr6RbFk7uZecsfwZp3fQ+0M5llz5vN06RDAopwA4sSO0phj+pkYZcQSM2THXviq52l7LFqS9p3wOy44U1G3Er4mKQtuhSJIjxTVn8yFQk
 YdXLMzC2
 2NdU2eQpqR7h59DBrjSVCKN0CR1E5j/zgbunBkQ4pnO4qf+Bc247ev4HgHifeb1hRRdjJ6EpCCLaH3Vl/6vpTy9muYgGB9j6FZD5t3QAuAFxi06fmnBuBmprYgxhW1KeFAcqE+dinb616p1WBGcHYf1rjRcuIdBlmFPG2JkzWMyYzJOttCDbNFk2Wgfsc/kWUQhKAqQZtvc3L0wifFsLeyIiESvosCZ1juHwcMuTIM7g+841JWkVTL86jHH281RReLWwSQq7u9oShk3Nx5yeGJKbjlR538SMMLLYfwpGk0HQMdQIpkVSYHC3SKjP8dmlv+ZiRyjaoMJwSL8b8PvGV1wxjkMgjOB131C4qwaB9FfxixKetjfYKhrKTFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 14:06:39 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:

> When laptop_mode is enabled, may_writepage is set to 0 in
> try_to_free_mem_cgroup_pages(). This triggers a warning in MGLRU's
> lru_gen_shrink_lruvec():
> 
>     VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
> 
> The warning occurs because MGLRU expects full reclaim capabilities to
> function correctly. The call path is:
> 
>     mem_cgroup_resize_max()
>       try_to_free_mem_cgroup_pages()
>         do_try_to_free_pages()
>           shrink_node()
>             shrink_lruvec()
>               lru_gen_shrink_lruvec()  <-- WARNING
> 
> Unlike kswapd or direct reclaim where laptop_mode's disk-saving behavior
> is a reasonable optimization, memcg limit enforcement is a hard
> requirement - memory MUST be freed when a cgroup exceeds its limit.
> The may_unmap field is already set unconditionally to 1 in this path,
> acknowledging that memcg reclaim needs full capabilities.
> 
> Set may_writepage unconditionally to 1 for memcg reclaim to ensure
> MGLRU works correctly and memory limits are properly enforced.
> 

Thanks, I'll add this to mm.git's mm-new branch for testing.  I expect
a few days after that I'll quietly move it into the mm-unstable branch
where it will receive linux-next exposure.  Further progress into
mm.git's non-rebasing for-next-merge-window mm-stable branch will
depend upon review outcomes.


