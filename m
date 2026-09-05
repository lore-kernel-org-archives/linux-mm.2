Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B19CC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 00:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5136B0088; Fri,  4 Sep 2026 20:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E862B6B008A; Fri,  4 Sep 2026 20:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D752E6B008C; Fri,  4 Sep 2026 20:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA9276B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:39:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A50C160259
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:39:16 +0000 (UTC)
X-FDA: 85177849512.06.EF3EDEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DA0A4000A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:39:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AvEUS6Nk;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788568754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6yHFneG9gGinH8AjxIgMQTUoNVBxKENGCLfZaasrsI=;
	b=u2Vlc5sJXC0pEdnpJvoudkasV05ZBUgzKavw1LP7z5TRVN8lzvVOsdp1J3IFM0di82vV0t
	pzWi9KIJLPcHv7gbhpQNGkJesv5+2ss+ShppLjwbTsxgbPkp7T16ZD9c7MfVuMEj/qD3Zi
	SME8CNedy99m4OyGruUyywjwrt4p/ys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788568754;
	b=MnG3elJ1G95b1wlx2gdECmQBDrtuts1rZ5giSEEU6KcrdLHHKN0PLvSagU6QSAt8kVHfup
	YXub374a488imPJOkdlLzaSPze4seIJYyCvVtJCy/L8zRNxzfGDeHjYTZ2c8DIh5nGjP1H
	QrX5JJcNE8pae8NQbBwUqOD+dJiQ8+E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AvEUS6Nk;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1096640603;
	Sat,  5 Sep 2026 00:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D931F00A3D;
	Sat,  5 Sep 2026 00:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788568752;
	bh=R6yHFneG9gGinH8AjxIgMQTUoNVBxKENGCLfZaasrsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvEUS6NkSPVMlhLKLbX4UG/OOEsSVFr+j2sipzgAeUCj3XXQVYOf++b9ZmlhvDZ4q
	 DFTpeVidIZI7mAkMF/qb8aHoEa74O7TLMIxpP4s+nxD1ecTcnoOyGf0jbPieAOYGB7
	 h9drwFWv90dkOKxZ9Y7j6R4mGkvkGdAYaMHh/FhV1/Ga+u1RzNtvhYMc7rlL+On7/s
	 doRwWJSiAg5GZUHLxieYCQ/LTGFryZ8+xXMVpH14u/AeWx6xnlLmi2xBsB5reX4oqv
	 dowANEravTfM3DgtsYhMDa7DenvWCIgFVQ9N7w0owaE8JUCj6jkLfjPmD7XurVHKra
	 2MBu2bavNDQWQ==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm/memory-failure: convert process iterator to for_each_process_rcu
Date: Fri,  4 Sep 2026 17:39:05 -0700
Message-ID: <20260905003905.68362-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904083001.553587-5-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DA0A4000A
X-Stat-Signature: muxiaoo3jxpp8gh6uxemfoaq7fb4spzm
X-HE-Tag: 1788568754-495006
X-HE-Meta: U2FsdGVkX199ekX+GBWyGAbgHvn2zo4y6DmFI+zhcIvqGqPzT2RtbvISOmJHlpecr+QLAyUOUOXzf52FKrmYUmKhOmrfxG1/tKrSOoChEbNJ+17Rol+cmmWCBqFUSQDjuYDXv3evWXJHYVZDkB7ZwrkLJaRO/HqjOhWkY4V9W6IsTiFlMmTUEeKsRec4/gxYNcrsncfRQFU6GuevgvCSjKL5rT33FG7so5h06J2Dge3A1jop8MhpoSQOSiXG3gaAvcm+JPjVtVvFr0gVYGKnouqYK9RkKOZ2J3zOdrEA92//nmfTvhY9oglbjf8/EpsGzrEc+SbX94xXIKKYyhUDJtKGb0jijGzqpmJnz2BdBTKpptaeVATpHhUFt2oZxl87nUv1G6Esu4IUYY3PBXt8gR9MQd153TUcL7j5q6xo29mS2zL9Z/ReQiBLElfD7uTW72f+cv0jhsvh1SdzRvHG+6SW4sakowDWuUxkBBe1uvu1QiLb/6qDV95se8HCm7Uj2UMcxJBQOfCvXXoCuwZRUN2QvxRM/lDaT+19CYVveRMJt2N9dRKvEGR/9fSXirmPODwLNTO7/FhXInbBEO7Ijkn6KszCpAGdvPn22DiflfelO+IARD6t/V+otNLiY9jUNal7q7umft1qJo3IoMYI7qSwnVpNr+Wup1WSIEK4R+u9hI6hnCWkFxfLpLPbM2wePx3AmMikrBKlAz0dSL388NP2vy292ONZbb2xgfqUe+LTe2+0ja9W56aZzOVIAk8DAv04JlvOIaED1CKYN/JvXljv3ZSWxrjdlCrgSiKKkpv4VplTuontr+VJlpWSIXe3yPpfjY1h2QDnHtsEePHUjuf8dpsCsqfndWnO2nTQm2R5PzSr2k3WZ/lUBMl5iGcblJeYDQ1d2HsD62BBsOSSB1Lr6RTOr3LDP10JQFsiF76Soez1DZSRlF0+NMwS/FfGeHJCTn+1S3FBPRDOUC2
 pFNnmUAN
 I/8wtpc4wXiQUNWOb9JVc/bNcqMoeaMeSGKQ1Yj1v3DL+WcUrqtPqugyGZzPKuRlmQipOJJKqB1/DSfL+emBkbIAZkcBzCamd5NSxfEsQHCXQZ9op3RiD6p/XFvVDqtnZdWLYsCMQWWzdCZEd2GEfbqY13oSGsSw52ybZlpqptjIpkYY2iIyvmqAaLQD+9gvWbzg5l4biTqYRaXKXqFSQqdyyMRxbuLCkyvix+jBFkNwfONzaZDsJi1zyEegGxc+a7jgk9/+Tif/3aIHHYuarUp4GWOMrZF54fVwlLeZLGMEDwmYh18NrHLPI8wWKO/eZOcAYm/X5rRVJUkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:29:56 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() loop in mm/memory-failure.c with
> for_each_process_rcu().
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/memory-failure.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..63a2ff08ee33 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -555,8 +555,7 @@ static void collect_procs_anon(const struct folio *folio,
>  		return;
>  
>  	pgoff = page_pgoff(folio, page);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rcu(tsk) {
>  		struct vm_area_struct *vma;
>  		struct anon_vma_chain *vmac;
>  		struct task_struct *t = task_early_kill(tsk, force_early);
> @@ -572,7 +571,6 @@ static void collect_procs_anon(const struct folio *folio,
>  			add_to_kill_anon_file(t, page, vma, to_kill, addr);
>  		}
>  	}
> -	rcu_read_unlock();
>  	anon_vma_unlock_read(av);
>  }
>  
> @@ -589,9 +587,8 @@ static void collect_procs_file(const struct folio *folio,
>  	pgoff_t pgoff;
>  
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
>  	pgoff = page_pgoff(folio, page);
> -	for_each_process(tsk) {
> +	for_each_process_rcu(tsk) {
>  		struct task_struct *t = task_early_kill(tsk, force_early);
>  		unsigned long addr;

This moves pgoff assignment out of the RCU critical section.  Is this fine and
making no real functional change?  If it is fine and no functiona change, could
we clarify the reasons on the commit message?


Thanks,
SJ

[...]

