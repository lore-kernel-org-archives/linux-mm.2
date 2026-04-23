Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F4CFDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2DE6B0088; Thu, 23 Apr 2026 14:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463A46B0099; Thu, 23 Apr 2026 14:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379906B009B; Thu, 23 Apr 2026 14:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 241F36B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:14:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA6B51403DB
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:14:10 +0000 (UTC)
X-FDA: 84690619860.19.946FE96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 012FE1A000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:14:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FKsHU5y2;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776968049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqQ9QsUROgQ4S02kfyA13hHN3mHyTjzMI0AqTx00WGA=;
	b=gn+xBqEUao4P/A+MVSyEUnChYp1gnfAVfOwQrXO6ZVnEiB8SvKrDzmfFrCEK9y/YrwhtJl
	q7ioTAZA/dGExsfCr98kobGZOETBgSUf2NdvNzpwYkDqsUMS0m8mLh7PoL4ggSNqC+Muuw
	Hyw/wc8DxQrB96TaHvISzemkh0hJIVM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FKsHU5y2;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776968049; a=rsa-sha256;
	cv=none;
	b=i48Uv8VxKL8iUz/916x0/+K+gopqNxTmALQJy5JLiro8FaxtO65YPRd0Yip3YcM/fipoQg
	6ShbgvPpHOecexCxI/rtHm6mvXJ6WolW+zcFhFZkJ3Kd0amNKBH1VLiIpdEaRAQX+qOjyr
	9sSZ23a/F6IRXzyagRk18NJrM+UD2BU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 509B660181;
	Thu, 23 Apr 2026 18:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B75C2BCAF;
	Thu, 23 Apr 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776968048;
	bh=wqQ9QsUROgQ4S02kfyA13hHN3mHyTjzMI0AqTx00WGA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FKsHU5y2YBMvZKTJ4sdMly6U+7qTR7yrhtyFlCL1XxziOKR4ZWff5sPDKVgDzHOb9
	 vsAkeojfOHszSouNxOzpMONI4jmnrmrewoOpKZ6eD4YGXrnzWQqw40bJfpMPHZ4Osk
	 shTUjArFz2XKFHbCZ7QFHy2V4wkQ7+83sKHj/py8=
Date: Thu, 23 Apr 2026 11:14:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko
 <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song
 <baohua@kernel.org>, David Stevens <stevensd@google.com>, Chen Ridong
 <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, Yafang Shao
 <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, Zicheng Wang
 <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, Suren
 Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang
 <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, Qi Zheng
 <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-Id: <20260423111406.10a88a4d80dd0e3145c661c3@linux-foundation.org>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rbar8oar4w5pz6unztkcurwumez516im
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 012FE1A000D
X-HE-Tag: 1776968048-337760
X-HE-Meta: U2FsdGVkX190SjTdZDHGdrrd+nIeyiWMpUT8b6c5hzV21q49jwT8gXZt5Se75bORABc8nhVaH2/VoTt+lkjyBKOzT+UwZOXGc2B2vLyWX+pwwcL4aNRr3vCTP2CYnZecT6y19xmSoGeylpoUABhRuwFPkrryPyJ0B1o30Pr2Te+iAcG0zX3D0rGrDoaoO7k45NAsUjfV/wD9l90MsttM5eWpGzNvFB2cnt40ukfycXSDpAc78WCzPwcJbBjiOv2/nKuwj30bFcikztiA4T5AQPDASKTRFwiqFDpbkIiUF83XmNmmmQvuQzU/l+Y4Bp5eiDXn/ncHnMaKucaLV4AYKik0deKYw3ZOXnl79rQcbURxqfO26i3z1HMk/OAAiZ4URNg35M10x7FhgyJ12PJh+S/wDKJYF98vPdHHbN/XGW2XQLp+psDyqR8woyO1hWEx+AjgGijOaPf8NZT70hKYnnSeAVkaDsNa1RYMR5vKXAD6ClG9sN+sZv8t1CvBrueLdF8SlP/C+z7mBfJoNG4MIYtcJfeLPra7CFzNOzx/Ax3OAJxwdWlqakcql8EKElJlJd1ItJO8mw+kB4pTGKD1TiCE16Hyzv6f6MZU8uNz9kvjoI8OOS/kC0lwqtKVpHFtEqQAb75g5ZRn8bFyEG7cVhbMSlsVwFqCEySEZXeTSbLb39J8U0RVb109NqW/yL8zfqlJOP3fKYDI4Ix6KWIuAGu1DLvPpJg9+j5mvWa8Gkpyv7xSRTHKWyZofRtqtuX2Ic7cuomAGQQKbxFLuCOZ5LoqCxnGzzENXQ3tQs+VefYTntdP2F8NwamVoJkP90JZ2LGMolE6jextSpHoQyjyp2cPlHwMQsBIXImsMtarWJoYvDeCCWEPhNAieknUZ2Qn22/YAX+10EHKjLgb9Bi1fQhLGl0lj359GI19fQ07htAwq5jA4BTuEEhiIsw8Uq5qpIJ67iZ1YYsLNiVEsVr
 KYKT+FNe
 w8jFshtRZxPx0XR0mRolenjFgzN8Gj4gH7Kq/0+NzJUPzTHaNL/zFZTRrfLn0JgpFP/egeZXzSNIseBgACkLcqvE/GXIMGPppbJpY5VUqYc5R1JtCSRdOY9X3rjdXRQlFs5CczJ4W0FOw1dv28+uw5jq8Y7qsJu2hmVNR+8Ue/3uEIK1xC0q093E6KbfNotpFNKW75WJyRLKcnYkj/neBfSxbMtst8uhQxMwYlQ5TpCWvX5pi2VB8NC4O/s2YiVTnO9Q9ayhIgjQBj1zhjQC6BHdH2KFgSeAOHfH1SeZlJXeS37aWedqvrB5dDi6b9huVodUx/sgFERxBZEDNl+dE4uAYF1kFN4TDOfR6ZEmPW+4Z6B8U6HBzccKTnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 01:43:11 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.

Thanks, I queued this up in mm-new.

And thanks to all the testers and reviewers - it's so good to see MGRLU
getting some attention.


