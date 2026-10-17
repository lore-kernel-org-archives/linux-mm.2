Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF7FCCF2C9
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 20:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004806B0088; Sat, 17 Oct 2026 16:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6B16B008A; Sat, 17 Oct 2026 16:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DBC6B008C; Sat, 17 Oct 2026 16:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B659D6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:18:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25A9BA036D
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:18:34 +0000 (UTC)
X-FDA: 85333230948.12.2E80375
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 738BD1C0005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:18:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WSe2nSLh;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792268312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAhESF2COvNcZpbBEtxaDnp4lDWPBoATUHnjiDJ7C6Y=;
	b=JdhrzhrdEWKSxBMqWXaCN7qCNfGU2ojzcteP+CzhIYs6IetxoaHXi8qUHxgtHrTcR1wP04
	qjXylngXNe7cH/HdgBveviHM3UAbSbDUGpp0YUImrXyfiS7HBdsQyfl8sa8lrkcQzoG3BR
	oNu3xXpAWJ3b6rNiynkyefzOtGqt0pw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WSe2nSLh;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792268312;
	b=DFENe8edjBAkIqStC+erNqF7HdCK4bV08yH+aZ+EHavjHppt2/xTxdpwCP8kdEz6q0DlnQ
	1H9GSKko3vEldAZXGD5IZ8Y8awfOm3mErCk6N0U6aIbmif9I+4b/XZngHWfrPB6V0PU7dx
	EjicQ5Qb4/v9gmg6eXi6TrmMnSeFpBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE77C60AB6;
	Sat, 17 Oct 2026 20:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009F41F000C4;
	Sat, 17 Oct 2026 20:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792268311;
	bh=lAhESF2COvNcZpbBEtxaDnp4lDWPBoATUHnjiDJ7C6Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WSe2nSLhoarMc88nXYKJ1TgMSop5g7gaop+Z4z94vHqiXXNE0zFqr7efSgtk22PJl
	 IudNt6TcEJx/DkN11rFzUyiYj8DN8txkgDbgG/reLq/Qyt5pvRneSXsInMobRvJQ5x
	 ydBVHjJrQDo9kc7imcx6Dcy4vuKdyxqkA43Bosbg=
Date: Sat, 17 Oct 2026 13:18:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 baolin.wang@linux.alibaba.com, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apais@microsoft.com, rlmenge@gmail.com,
 stable@vger.kernel.org, Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref
 with memcg disabled on cmdline
Message-Id: <20261017131830.d698d0a474745243d5d5b7f7@linux-foundation.org>
In-Reply-To: <20261017050928.128582-1-sidchintamaneni@gmail.com>
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8d6daofjcys4t4i6afy3x1ezmg6jjb7c
X-Rspamd-Queue-Id: 738BD1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792268312-369487
X-HE-Meta: U2FsdGVkX19qV1bEtWOHDymv3Ak7CS/YAdBon4ZzNkinJSH0ykJZTCe5GUgKIM7rDFknDBVTQXbTf0eAyX7tjUB9htFiNY3OG+MTJm2RSbcdhi+j5u5B/GYsTd0F1kwC3BsAE3+q5oi3aDYsy9R1V0MPhMJiGHoUiSulHSUIIR+QM8h5UxcuJi5PDkoqnNnnwNm88wse7ie5Kdm7a3JHx3xsJ+1SWnqhPOzZzBQVtuSG3yzO06Mdg1Zp0pRBNRZ7g55l+Do2cqWsBhWjJkszDeqv0jygHyJ+btoJycOhLQRm0T5WGbN0naysZWvmwNdY4OkABDt5ok4bq5VADFq+L+JtX8sCnyI/ghB21Hkv/2VIjOwb86y2nz6A2qa0q6X1mjqwESgm6mnbUzvJBID/3Z0XHuPYfSEaVGaDMIt4bPwuGXazNVPGkbm8qvQr6hoal+omZpca7m1+T6MrIiobgt6/MKzy6koc69krbDWr9TzdQl6sQPUrJS/t1BoRAJZ5N9ga6D1aN/yteI6EiCXqEcIJamSdHGoD1wJ8T4n+Wz+Z7zV99mQSopEz60fl79VhmM4lsVaL+1gL5/z0i6gfh4853m70XChMG5dxoKn5MfBQmjPY7iBjvYHNvssjME0gXVOFYWiYNvImFKomZ2Ccl98pSM9iInkSTnJrXAp2fJqxkUZsNvNw8rwMCVNPaHYzngfBQ0RHKrXhsi9oUXVnoXHd0pQgmyqq4R1s0ON3nEEOvRa7DzgLxuY9j+WlpXvGTeLYmkg+huf7lmsSEd7kk3pi8BNbFLQsm29kJT9fM17W8o4TECo0USJKbEajb9C6n/GktXQ3oOfQ46rLj5sEo/A1Wcn4Zl+mmODHC/J1Hfthtki9dXMsdFfgIv7eV/9Jmfq+csZUBNtuIQpMck/u3Vy5Gc3YK0dRYLsvJ1QTVY9uJKICiDPzDypOV0bA5iPJ/btYnStRT5cMQCAeHro
 adOmxjT5
 HNYd9e+pq9aWrcRkb+ewhf9VZkXBxzciaeMFG1w7WFKSw3JUpnhw/yBKNyaD7Q9/q79A1mkgl4fZjjIDK62vaOlz10U33APOvfmwSzms5mJ9lW7UdH15T/42gT46bHwV1dG1DIIJfNXzQCuAvEyJ9khSnNbmIgXkenEbkUUQLdj8TUuL08wSq4ejMoRHkQ8sp+4NuS7bJgkbz0Rd9sIr0mHkQuAN1AGk6pjSlCSwaL8W3yydqw6VvuVL5fI+MnGbE+/WX/K3i2crK8iMcPnammau3Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 05:09:27 +0000 Siddharth Chintamaneni <sidchintamaneni@gmail.com> wrote:

> When CONFIG_MEMCG=y, lruvec_pgdat() returns lruvec->pgdat, which for the
> per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled in
> lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
> first folio_add_lru().
> 
> With cgroup_disable=memory, lru_gen_shrink_node() passes &pgdat->__lruvec
> directly to shrink_one(). If direct reclaim runs before anything has
> called mem_cgroup_lruvec() for the node, which can happen during early
> boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
> up dereferencing a NULL pgdat:

Thanks, v2 lgtm.

Maintainers: please review and let us know whether you agree with the
cc:stable on both.

