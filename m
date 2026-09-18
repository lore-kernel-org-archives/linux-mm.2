Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80222C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3A66B0098; Fri, 18 Sep 2026 16:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874446B0099; Fri, 18 Sep 2026 16:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1F86B009B; Fri, 18 Sep 2026 16:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59D5E6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:43:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0CF2807D9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:43:45 +0000 (UTC)
X-FDA: 85228059210.19.982A723
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4C1B80008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:43:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sRguR3+D;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789764224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5ambLtJv/AuCg2Coh5juy9jqmqcd8mcPlwipY+ptBk=;
	b=hn62xqDK+Vc10AVlIoLkPzeQGjttfmIj+FkKt9TJJXe+hPe2Jsb0UaZYjINf81A8MtVEgm
	46wGDKMcETcILMuMth3INUTdOhKMqJihjKJkQCmHeAOpQRgXGdZ5yjGRKIzjU2sFebWmkz
	hCcbTXi3bbZdQ2aAQiSHHxb7KIzJxa0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sRguR3+D;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789764224;
	b=7Or8DSmL+Kv/fweugSAu3oR3swLqzLa3/ZddqP/dVDYPf/2g0J6VKLo25gX3e7mQMVBmfP
	AzxUQn150iZawVIdOPQiQX4QFfAgm7GVSwtz5jYpq+OrgzygXN3yG7RQsEKUveqxmh+Amh
	/Wc2sVhiqYTUxO27Yo4LpL2Luqt4/+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 572826053D;
	Fri, 18 Sep 2026 20:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BF11F000FF;
	Fri, 18 Sep 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789764223;
	bh=s5ambLtJv/AuCg2Coh5juy9jqmqcd8mcPlwipY+ptBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sRguR3+DzyOGGRDDZzh1ApJrkGYDqyORnnvJ88iY2Aw8UWAGYl3NM+ahgzTDYCNI1
	 43gfg1whBdkDPOtx1iSARXCM0t1z/GQ1LGXdyUdJ149p0YR5KdlJxPDwIk/RlwNx1t
	 uzb4TdoOIM3UqeyRUCvsdl8NzSYJmN8raMNiQCWs=
Date: Fri, 18 Sep 2026 13:43:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@kernel.org
Cc: Breno Leitao <leitao@debian.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: report RCU-tasks quiescent states while
 undoing a range
Message-Id: <20260918134342.c50423cfe3b2910e899226f2@linux-foundation.org>
In-Reply-To: <a67e8b91-ebc2-4d3d-b6ea-d221b297fad0@paulmck-laptop>
References: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
	<20260918123239.8f25b984ca280fcc11ef6e6a@linux-foundation.org>
	<a67e8b91-ebc2-4d3d-b6ea-d221b297fad0@paulmck-laptop>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5x536tfbzgwf7b1dynw3gzc4puasxo7f
X-Rspamd-Queue-Id: D4C1B80008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789764223-342907
X-HE-Meta: U2FsdGVkX1+rbai/fCU5UdzZzRrve4eT9XMuKbvLDdMy5rETYXdsBrL+mCkQuei4yWl5p1j7i3NVog3UISsdM0I3meMJR6DVRMdavzhvBRZCDYlvSk9wNd8s9NqwXAl3ckJO/ZKAILPMhwH57m7EfydGOeaRo2ibwrzGJmzIeyHXZeNjz3mp5hE7n92p37kzdqgBKnnpbmn5r7iqHZr6br4A9JQBv6mlxR/yhytfeQ8GfWvxtUuJkcL9rdi413IGMMefdeRCMh8s0OBHvh2Sv9+MwuiRZ6Q/9PkDNOIJgZsmtps3co13FCte3NSaq9p3Hg1X0r5nMPUSlpqNmLjCLYSeif6p9T7wf0kyfcQgcrc5vIJCif9RhBSHY2K0cdgr7codq6UOb7dyee7YR0y9LUD3ag548Bsl8MvATxLsgeDQPob30eyDNPg1ZRlg1nd4V6PLImXtBFT55cA0IaqEwC33oj5idSMAP9vkiIj1BzFO8WfPwvvPVQT8YDZ3HGFf3N88lvdKjA2ISuhvMSgEBCvGSsW9yh2LR7exFDHBlFMJ78QmL1tAwYQm9EWjxrK3HXyQ5qPi52PXQAaeFtjR7aD+nE1Z6mE61ulsm0S/HI+ehe/05dEF0U+HuUobnmRRx4gXDs9lz2OxZEQZ0T6CK5CFA90/LKUF75VHBN21MqotU90k58Kn08zXUqcLe0CYg6UcinIMX4jWtRv/bUEkadT4uKF1TNmBk8civ+ujxbbjMRrT+/qVX+ZWsS3yck7WVvaxDHnBPQGOrZQ2G1vkYquhl7xUN9qfqhUVFYbu3KNdistsiG31kwXlHJr4+s9rp3TollZB3cU8iv0gxcW6NebAunXZZmCqQZu/HFHLTe4ut9VnIzY6gpoKY8w8n0to5wYYlXa0eMFrHRl6ejumO+MGfQ3OpYjVBH0C5/UoUGARSrr63ZQzZnYaQR9wmcaBQS1Frfu1AXRFcd3XdpW
 ihT6keLY
 BmesjkG8NqJ9PRRmtlBi7g8TEIEzXyl6dSAn7fAdzBqduTyCosM0OkQ/UcDS6MdgjMiMtDJ6qbRoHH0t0vRx+hmZBTZVCvurDT8R/1vRRg+TyGdWcItkpy3ue27K8H2qUwznwPAQ9M5Nlx2uXaKu7Mzs0/4E3S8GKBzrShvpbIKPGcXxzPqBc7cnLE6KXSOMFTbzLk6h5BXxmGDgQALx+uBVAgIvctn7cw43L15kSdFbfdqmbqFa0zue3rDYc1CM4aKb5WSQRgBt6j1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 13:24:53 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:

> > 
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -1367,7 +1367,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
> > >  		}
> > >  		folio_batch_remove_exceptionals(&fbatch);
> > >  		folio_batch_release(&fbatch);
> > > -		cond_resched();
> > > +		cond_resched_tasks_rcu_qs();
> > 
> > Won't this change remove the cond_resched() function from old kernels
> > which really want it?
> 
> The cond_resched_tasks_rcu_qs() macro implies cond_resched():
> 
> 	#define cond_resched_tasks_rcu_qs() \
> 	do { \
> 		rcu_tasks_qs(current, false); \
> 		cond_resched(); \
> 	} while (0)
> 

Oh, should've looked.

And it appears to have been this way forever, so
s/cond_resched/cond_resched_tasks_rcu_qs/ won't break old kernels.

