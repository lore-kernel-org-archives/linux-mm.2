Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8260B606A90D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FLjc4Oba
Received: by kanga.kvack.org (Postfix)
	id 944EB6B05B1; Mon,  9 Nov 2026 20:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C8D6B05B2; Mon,  9 Nov 2026 20:41:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B556B05B3; Mon,  9 Nov 2026 20:41:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 614226B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:41:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C079B1A046C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:41:27 +0000 (UTC)
X-FDA: 85417507014.04.B07333D
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA086100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:41:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FLjc4Oba;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794274886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLtBIHtJK3uVpZ/8u5q8GXEFGNvOwwfb36TDfvtujpA=;
	b=SJAEcU2l8WpqmZ6Ck95AzmQhAWLERX1TOSMUUa/QyDSp39GaRQJWJgGpn3LyclksWgGHxJ
	c2a/J1PnO+BoWUHPwqjepCx+L+FzCGyN5YfvzvnwuoFMZQYHx9Atc+ie96CGwoP35GzZ9F
	xMR7XHoLaFWTQiCLZbpNp9IPnJMenbI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FLjc4Oba;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794274886;
	b=fpXHtCjJnNyPeimp7nCtLLwcQ2gRbW5CUYH7B0bcdJhOdr9VZnH/kcJ1zCKT69VUBjlI2j
	Vg4FwadmffTy5bYhlr1npA4gsvuJm81PIVldFhkGJHdtGNiYTauuAQ69nVpmJMWTtHngA6
	uW8X6+nW18jQlQ3bI7Bab/uVpSSZ1io=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794274881; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=YLtBIHtJK3uVpZ/8u5q8GXEFGNvOwwfb36TDfvtujpA=;
	b=FLjc4ObaE3ZtOifcFaf3hWuNU41TlC6b5hau+zMEw/AKGwIfJ4pde1KlsbCYj55CXG4uFj0hXklfv0jNN8YU/gtrM3IwOo9g9AJ8AtwAP9J2FknUdcKyhI6E9R2gzLJwVR5vVdGgBqqI8S+f3gfKtINxzIdZRVnVlP/5thh3Rew=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XETU7Hc_1794274879;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XETU7Hc_1794274879 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 09:41:19 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  Xin Hao <xhao@linux.alibaba.com>,
  Dave Hansen <dave.hansen@linux.intel.com>,  Yuan Zhong
 <zhongyuan@hygon.cn>,  Shifei Ge <geshifei@hygon.cn>,  Jianyong Wu
 <wujianyong@hygon.cn>,  Shijie Huang <huangsj@hygon.cn>,  Yibin Liu
 <liuyibin@hygon.cn>,  Fengyu Wang <wangfengyu@hygon.cn>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
In-Reply-To: <20261110001816.2186986-1-qiuzhiteng@hygon.cn> (Zhiteng Qiu's
	message of "Tue, 10 Nov 2026 00:18:16 +0800")
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
	<20261107143456.1590658-1-qiuzhiteng@hygon.cn>
	<20261109122915.2150586-1-qiuzhiteng@hygon.cn>
	<ef12d685-d111-4a6f-b72a-77bbd1369548@kernel.org>
	<20261110001816.2186986-1-qiuzhiteng@hygon.cn>
Date: Tue, 10 Nov 2026 09:41:18 +0800
Message-ID: <8733t9v4xt.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: bj3r1c1xus4hmqiob4jk3gk6s6zufnsg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: CA086100005
X-HE-Tag: 1794274884-76834
X-HE-Meta: U2FsdGVkX19/z95TdkXCSjrr/gxSlgJzd8RUH6jO8oTmz7wz0s84Gp0wn1ifNP0EF4pYqKtt7harrlei9g0yAkZcWpf/oi8ExdS6Dj0TBh8C97GrKWYIk2PIGHS0VtLonQxr4Pa8La0o/aoPKcfF3sQO5GtRHfK6f0d8cwv+Tfq17/FvK65T10CqOQVusuMET4MfhjvI3eLdccFzF5L4Sni0eikzux8oFjaSA6dz52hYOiLWwMqb2z8nZHJAhd9zE28RGsP03UCpxIPbVgrLQwzkGz4a5cn0Qt/NFrg7HjFtwF4LMRedEmhUnBUKKbJKmsAlBjp/SEFJ2o+sxjx7F+oHivO+NQIYgtiDzPBa9tK3QRCftTivrX3XnICuovRf6zau7XNnVPqYYcXtRkKVRQFcl9Y50xCCB+yHXgVb4QH3L1kBx6WHnS2nPmjG5k7+jS+3dgFUuguynNwDXBLUZyVOrdFcEcTjMLWsq9UswGq343FvpUEjqHF8wWiLgEFZwVywvwi0l8ukpTzKjfcwuEjLnjlJwqg+UIAzX3KhGkeeosE0Pw/Iqa/fyN3AN2NC2B2TNXiek/Y0MYoZfGwnnBGNBKtnM9dYq9Yarfh8oEMgRRB+FIsqIjBmp/hQNzbxaGOTWQR91t81e6dLAXGd3rNdE2KiiD9A0kQIvr7cpOCs0rq3DS2jl/Qw+WDlWUyxzANq3Th2SHBKt/5UXsgIrmv7b/JNq4CC1cJWci1bz5Es0SSf6ex2mnFZ7F+o/GDNncDIaVnR6dOIKoa4H1WbdNbx6HGjXKlcwgUrkpjBgDirEr1WyQvRpcHQVAr0AcX8bskxx1Mlm4ol1ytnlTap0F/8BwCHUP9EwQ1VEXPJNirNllYdZ50H9dncE7i80mTSPakaWvuvsr46UqXTM5W+PLksE0veXIq53mp8Mg5xlK96vZopddoexT6W7kUXejIwPQLvi1rvsN60EFwuFei
 FltllNki
 LfHjIqI2cFI/DjSsUmQDziq0sMG1TnQw/xQb/R1WLWupLAV51Kth6vUezuKOhXzMIbqDBt8oooRGb3MCJzTEqCkgNm5+UxJo5FjrB9FIdBQ2OP96KeZXYbRNS+vKtOwu8qb0Q2kMazjXxSa2jriF+Ke2vezT0kTU9fIa1ZEEI/aU3OmGsew+Ml6pWvFrgvIZVReaQaaKuGThuYBQOiCUMp4qGfS3WgAv8owTY/xMvwgTA0TC9P6zodJGOT4UsjcDrvDFqYzFWUQ6NFjbojjYc6oSRfHZ/8phBDXCI3ZmvP5ojRNPo/ngd7Y1C+xEQmMdq+Lq30QiApbkzHpbBDnpapq3gzlbvIcxZluzB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:

> On 11/9/26 14:07, David Hildenbrand (Arm) wrote:

[snip]

>> I am not quite happy about the folio_mapcount() check, though: as soon as we
>> optimize try_to_unmap() to batch better for large folios, it would be just plain
>> wrong.
>
> That makes sense. A large folio's mapcount alone would not tell us
> how many separate flushes are needed once its PTEs can be handled
> in a batch.
>
> Would it make sense to restrict the optimization to a single,
> singly mapped small folio and keep batching for all large folios,
> as in the scope of v2? The changelog performance numbers were
> measured with the v2 check. Or do you have a different direction
> in mind?

If there's any behavior change, please rerun the test to verify.  It's
fine to reuse the result data if they are similar enough.

>
> Moving the check to the caller would read the mapcount before
> locking the folio. My understanding is that a concurrent change
> could only affect which flush path is chosen, and both paths are
> correct. Please let me know if I'm missing a concurrency concern.
>
> Ying, since you suggested using folio_mapcount(), would you be
> comfortable with limiting the optimization to small folios?

I'm OK with it.  Thanks to David for pointing out that folio_mapcount()
isn't good here because we will optimize large folio tlb flushes.

[snip]

---
Best Regards,
Huang, Ying

