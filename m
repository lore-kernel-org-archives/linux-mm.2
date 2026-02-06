Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9099ECD9BF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02016B0088; Thu,  5 Feb 2026 22:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF906B0089; Thu,  5 Feb 2026 22:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB786B008A; Thu,  5 Feb 2026 22:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A76F66B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:39:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C2691C663
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:39:02 +0000 (UTC)
X-FDA: 84412625724.28.76BBF5A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84A05160004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:39:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bshtKSPT;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770349140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTBjnhIwPP/H7hU4cLwHhPICu7mAw2RH7SD8jP2T9i4=;
	b=xYW2ZG2XyMQ0MxD8YdFnbkO/iCAAC1E/qKFvTTUHZ7d6Boq0buRjr1txgDrL1d+/6MeuoR
	ZR0KA1UEw8G+VUsP0xrj5djeLqDzBdRT370u6e6lcniIQEuJqVLyTIMj1wRqdoniDj+bHQ
	PxMIzYOc9nKBhFU6PxTyS5Bb6YdK7Ts=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bshtKSPT;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770349140; a=rsa-sha256;
	cv=none;
	b=A0TM9P0v8caQwAZTl7WtNuxCr3U739uECZxvohR8IAQcQCi54O5AWTqr32ZvuT9iK+CwYH
	YrPAUWpJUlznT42sdWD3WzqoOQ5UwueZBhXbFkd7ozyCQr0v/78MQVbEGbXiZHxD+MmZUB
	bke01TjB4aTO6Ay0Scao6jpLC6FMy+o=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a94450ae14so1554505ad.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 19:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770349139; x=1770953939; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yTBjnhIwPP/H7hU4cLwHhPICu7mAw2RH7SD8jP2T9i4=;
        b=bshtKSPTm2xTwYYuMMcbG5Gl7gVwtHB2zSmyAKZM18A/vimf4m+z52ObaNuvoTcSNY
         4a7ZVz9VCyD3dwFcyl0Css2TfFKP+XFOhmjI+GLfLKfnMJFVRpOKKhRm2Q57JhibkSjK
         //PPJv9JsFocAcyI5bbsb4y1yHkJ3zVMiR5aI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770349139; x=1770953939;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTBjnhIwPP/H7hU4cLwHhPICu7mAw2RH7SD8jP2T9i4=;
        b=Iwm6pB8Nyq9j9f4Q9Z5QQOS9qXO56PH4xGu5dv2/xRSSJpqZTvp9AUsG7dw2VtW+T7
         TzOqw5Bcp5GS8+zOxKu/KHsfEjXW49ZrWoX2BuMXev5uGZA1jzu8OjaDch2ocn4KUVZh
         oDg4Xy6YHGah1XC3SBNtWE+pk/w7ykEtC14nafxRBcM/fq/gE9SCHVdwlT4MozlLDCPj
         zrWXRLKz3bE9GrQygoISDnc1fqtjAjfkCjbkTxNi8Wd0/NVNons3SSMF6lfi/dWXpJKB
         72bh/Ph7zSEyJTdcr785u9gqOdW3jAIfUH+Avb+cQ3jrMNnTjA5aO0XZyQKo/FlGuzE1
         HC0g==
X-Forwarded-Encrypted: i=1; AJvYcCWY2A6dv4RLxTOdN+KSZm+wxisSq4jbScPxoO9UNxRY6shCI3y8cyztwaqGKdA75/ugosJU4Bia/g==@kvack.org
X-Gm-Message-State: AOJu0YzclrcUzOwdJcjVMWv42za+uBxrKA+5aSh9rbVCnDQn05svFLPh
	wAefwKGo7YaSmjRtrd3qtPatlahgFrcJLeTL1ovMbi14jIj20HfpoCQgWNrC3+b32H9qhZg03d2
	ifhvyxg==
X-Gm-Gg: AZuq6aIl/3GB5vONz5W1KoY36ckGr7+otEodSrEEbcq1AmtRL4OUMpGzKyf8juGzuhv
	y6Yv9YZYe5/cskiZ6GLes7E5tL7qO6byznAGFVVE618Hk2yn2k3JY263cyJS2sAqz6/X+9ejESh
	gRCP3XKxJkqQURRDgy6TfVqRsBz2UAMTedKiAr/3Lbf95QuJNPAiTpKo1hciMeUEKyTcmfLqA+j
	sh9hkvgXsIdvvaHxAVQJszj5PhJzEpmcbRRrIc1MPsKKEXkEDq0TmZ4SOOk5Y1aA2sKBQxX76cl
	bCbbN+F9ErOcpL9iMY+F/mS7P25GGb3arepjj2fQbvsqgmDVg7EeVQUd+KMxMeUC+4ju7iAH08V
	Balc4GBYx3dd30u0R3yAiRvSQnHGbmVH3FIcKCw99LuPNLwZiiYHyboDz6aQWTn4Ci5gnwXOpVs
	LqkrSVxf36vB0mf5jWKAJGq0kGqv1Z6zGe0evGrLzS65PsLX99I2htm3FQoYfYE7I=
X-Received: by 2002:a17:903:2412:b0:2a9:4ba4:1920 with SMTP id d9443c01a7336-2a95180f720mr15456205ad.31.1770349139388;
        Thu, 05 Feb 2026 19:38:59 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7c0a:732a:f36b:6acc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9522128a5sm8363605ad.86.2026.02.05.19.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 19:38:58 -0800 (PST)
Date: Fri, 6 Feb 2026 12:38:55 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
Message-ID: <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
X-Stat-Signature: oro11izd1h8k4eqt99owh5j4jsozo51m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84A05160004
X-HE-Tag: 1770349140-424718
X-HE-Meta: U2FsdGVkX1/UWkNi22m7mM0iR5BnavyrtpG8JO0i8+9YahwGr4YW64cotfX91i9X6gxto4kqUGNFy5kMAkBtAp/Xi8YUkls5X+5WwDeMqfMqrlg4saEpL1aDEqz0tVdWrPFpE39V5ckNMd3YyfQ3sFdtJpjcqfk1Pua8wYlKWm8H7tj4rl8mF6FJEkcN3Ka3IdX5xq9PeICIo9j4boAOGuSJukkgP5Ki3ztOIpMzxBd/zSUddy7uoarDXH8H+m1Qi/mLYZGzIqDyvX3KpOUyz9lNqMd+RDGl8I/PqJF0r9SEpM/J4CLTBJBuQAJAZL/svTrLY37MccKF6U9yqz4g78frAqsvl3Uy4shUWAkbfLFtB0sqCdeXfeqlgXYXpeNGrDKclcJfqvOFJ606/8zn2EAw4jZVG6NRtDav5GG9QL8HbCx8xP+4bJf0ZaO+aaCRKRdqtU6hEqIQ2Frl5nta1nB26B7PsvWIHEnd1qi3YZw2pEOSbzjk4h/N0AVNfsCupqscK1q+bTpfUesnAImkVLEMrfkIZytO1LV6jOQHapsKw/ZOWTwQpAgWBWQFfvSZsVBrN2KVyaQn6rS+luzfdos3pYFdBTTOLfCWQlVt7P4nLJ1JbsJkSL+ERpoBvNRAAIMk/aYBjRQFw4pBvTPcinzc6otupZAg3qXARtc+dLftHHIrQukQCj7reJPEpDcgVuLr5qMcRvqGDlHLd9/5ATAR/4kupe64zPcEjNwz8OoQkpzjvfNSw21lnYFeXHqUxnLramf4pUVuqOgnyBc6zBeK9GVm0JO1Nc70p9IxBP5FRQMAQsiv31RlZvO1nSUm7d2EQ5UKzar6EKF/yfV7xfrA8zRG74VG4pHWAobCg3TMkNTw/T+7cqwAHTcHYcMTjUofZ9tKFmVvxXfQGuDidP3xXReomlj/2eDbkcTF4Y++53V2enVg5NxX/DsYSp+XjZwxq185EV0xKO9geVo
 41IdGVK6
 vKGvE/pLh4MWnne1U6vPgW8pb5n+acMKwJDF7pYovf+TCXhQ1subhIo2XPhe1Jc5JJh9Kg8Hc51KFCHp3cd7KtoeqKVjb3d2wrgZ5JTcrtZtB6t2gLmmJpGSOxhVaQNI0zuF51kXdph946Pn//OY3rR06+l0bsovA4lNAoeeMkDF/pmbQlGp2RlcG6kYCCIjotjtaspyVgELyyuij6l/T4/0demckQHkn7Zk5Q7g3tvq/uFg0lvBWEyocHhJT0FxZgCF3R+ONoadiCvP+qt6m2tbQ9HZz4/TNsnUb5bSBdMekpbh4Urexw3GkpVTeOROKhMY87pADrWfqFVd+fPTe7SQj54wikPdlouRqvdlMB5igoMcUlt8WLWjJ6UzplAeLUeHGKx+H4eBRWaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/06 11:33), Baolin Wang wrote:
> >   Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
> >   task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
> >   Call Trace:
> >    <TASK>
> >    schedule+0x523/0x16a0
> >    ? sysvec_apic_timer_interrupt+0xf/0x90
> >    ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> >    ? wait_for_completion_io_timeout+0xc5/0x170
> >    schedule_timeout+0x23b/0x6e0
> >    ? __pfx_process_timeout+0x10/0x10
> >    ? wait_for_completion_io_timeout+0xc5/0x170
> >    io_schedule_timeout+0x3f/0x80
> >    wait_for_completion_io_timeout+0xe4/0x170
> >    submit_bio_wait+0x79/0xc0
> >    swap_readpage+0x150/0x2d0
> >    ? __pfx_submit_bio_wait_endio+0x10/0x10
> >    swap_cluster_readahead+0x3be/0x750
> >    ? __pfx_workingset_update_node+0x10/0x10
> >    shmem_swapin+0xa7/0x100
> >    shmem_swapin_folio+0xcd/0x2e0
> >    shmem_get_folio+0x237/0x580
> >    collapse_file+0x247/0x1280
> >    hpage_collapse_scan_file+0x26e/0x380
> >    khugepaged+0x43b/0x810
> >    kthread+0xfb/0x120
> >    ? __pfx_khugepaged+0x10/0x10
> >    ? __pfx_kthread+0x10/0x10
> >    ret_from_fork+0x38/0x50
> >    ? __pfx_kthread+0x10/0x10
> >    ret_from_fork_asm+0x1b/0x30
> >    </TASK>
> > ...
> > 
> > The system is using zram swap.  I wonder if khugepaged should
> > be suspend/freeze aware.  Does something like below make sense?
> > Or is the problem elsewhere?
> > 
> > ---
> >   mm/khugepaged.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index eff9e3061925..fa6a018b20a8 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1894,6 +1894,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >   		xas_set(&xas, index);
> >   		folio = xas_load(&xas);
> > +		if (try_to_freeze())
> > +			goto xa_unlocked;
> > +
> >   		VM_BUG_ON(index != xas.xa_index);
> >   		if (is_shmem) {
> >   			if (!folio) {
> 
> Your analysis is reasonable. When the system is freezing, khugepaged is
> still trying to swap-in shmem to collapse, which prevents the system from
> entering suspend state. However, it’s not only shmem that will swap in,
> collapsing anonymous folios may also trigger swap-in operations.

Right, I thought about it but wasn't sure.  Could the inner loop (e.g.
collapse_file() in this particular case) loop long enough to fail suspend
w/o ever giving the outer loop (khugepaged_do_scan()) a chance to freeze?

