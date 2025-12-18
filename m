Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26ED3D711C8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF416B0088; Thu, 18 Dec 2025 18:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3306B0089; Thu, 18 Dec 2025 18:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0CF6B008A; Thu, 18 Dec 2025 18:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3436B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:32:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCFA0160386
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:32:28 +0000 (UTC)
X-FDA: 84234193176.18.63DD28F
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E461C0004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:32:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mZeeORnn;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766100747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znUu4iyTM1oiivtQQANinir/pn3vhmDUcWkoXmOrzCw=;
	b=6Uyor7iE6sXRrbmqy4W31KlBHqAQDlpUjM45aHMsCs3nAyioMo8q+OLNf/pKsKNHYfW0yh
	uW/Q4JDwmiEinpDZChlpQ0kwTd69fH+iwUwHgikK5vjiVkRA9TsGk+Rv4staApN47W1usa
	askj9EWI1h3FGTMdmzuBSGF9saS5qqA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mZeeORnn;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766100747; a=rsa-sha256;
	cv=none;
	b=D2zhNmTHauyYm45aPMLTwduTjWrvBBE7b4y/a7F7nyYFH3uhUIUkpiveExVt6hgMzA7E9a
	gddaf70Hqo/SGRbODNjOndijCAV2mPOljJbvt4poLsrtuNli5S8xgKBv1zYHTaBL2sqoMq
	Q+ufSqEbSpBpNLLZ0iwmvvOQj4UICoQ=
Date: Thu, 18 Dec 2025 15:32:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766100740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=znUu4iyTM1oiivtQQANinir/pn3vhmDUcWkoXmOrzCw=;
	b=mZeeORnnPCcuHw8dsEZQDI2WdN9vuBbYrrsD62m2CD0c24Z39EBB2r/1fCcuJFbd1Mf1EX
	n2sFMoPYyWcKjbzNfQpaSkKy3HbCoTXLVKPOWrlJERy2zqqRIL8imM+Hh5Zk7lthPyck5J
	XggoaZhme81XkbP88esIJNQN0Jd/EDQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 02/28] mm: workingset: use folio_lruvec() in
 workingset_refault()
Message-ID: <dcbaqw5q5lu4thhv23b77sswsm7xpgvaptpv7glf3geeetnx3x@uxhq3wiudypq>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <08c00b5f429b44a6df3f3798e43046ebd5825415.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08c00b5f429b44a6df3f3798e43046ebd5825415.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E461C0004
X-Stat-Signature: na6am5b7zf5rj5kg84uyfdiiaa9amuju
X-Rspam-User: 
X-HE-Tag: 1766100746-729953
X-HE-Meta: U2FsdGVkX1/jzioRSEnELD/13bZumsgzrZh6jDgLDfIuwcHPy4S1KCL0k2xqS2YkK0RpRzbHwO2410kwIeTGSMP8dWW+BsxlHlrIApC17T17fn/QNF7DxaeuIHmOu+CoZ96aBpTmrvw9e5xhZRpk+nfqdtUQyNOpbvQ0EmMnUQeeOYu8AAUwmgO6R4pqL+lfLBhJgiuZEqLOmpn6lori91/Ap1SW/9v1TBjVzOGYZi5HPfLDjtrXJD+hNoreiFJVj3YnRUcRwiBLCP5dbmUUL6d3TYkgemdZOwhNzzmXVBCUVw48pg6Dl0gdZb1CGN3iMuv3tZqszGCqrUPk/LQAkYnTBy8ZaW0sO6NLyKeYOOsfXFJcCiFPehOr6QiBPOyIptUBb2h3zunROPApVJjC54FYn5gTvZeOp9DUmEHoKVF01MS3gkn61K5+Rpce2hCz8btxZVbdjXBrxxXT4BAR+rxTng//KnA/e1mE2iiqXh3xVIZuOc3gJJ/nBuXLCgH0lwTpNwp4eoEA3jXGIgv6yJ2qRcpxBLyHhkdEQNU397Jui/MDN9wIHHnQkPii8Du4tug2A+RlojYJ/rab4VkhcqL0jo3BWkz7cLqgnp19jMITd7h5FN30bH88SinTsJYYlCjuD+/iOql0m999NB0ycot01LvWK17RtBDvmb0NYYWmP/2Zc6sINkPeYHWIG99w0/MEtq4HsgyhIFjRyZKmiOLNtTxEkFukTwo17rRrux4igylppEG+0GlAvf4Jl1RXpNtwl9LK1kWTbyCISZ6KF0Qdsgcy8AmGpr83xo608/0pZxzz2aw18PQW7wgWbT6+WJrmF0C6fIHh6sbkhI6CxswkG5mhsA+wf1BqLhgwhXLiyv/RqSMAwMOv8DQfa/ScrjCWaV7qXhDhAjfbQ1MpcA2l1GuUP5bz95moYcuQsrPVnzP00sanItG6GvvoOG5EVQrxQbydb0ViDUqfkSd
 FUGcEeXd
 bSs64v7wu5RaANuaF7zxN0s4Ul9GQ2OlZ9LRbkDKsY6h7rvC1s9J/Y0rZXZ9OlVsnkxpj8XEnJwi+OtJKXuEknv4Cu7vV+FA/AouMmjPwlPHFzw3u91b+IQxUsIbHyy6MGCFG1S84RbgqHEc/CW457TJTpjT//07NtKkpFq29u3mg9QuXcUhwB6k8fx7gzDRYsqDkyVLIs6QChLS14ZRUVCMw/uemOwPkjexacDIxQY1z4ks7pG0OSTx7wkbb1JAtl9Q1NGbpXFHHc4HkdHsjZIphGFUAotmgYXidV9jcqXE/RPVi0k2ge/xe+Z2GC7f2ooCPckDBj/RZMPjU32PVWNKmSYhws1q3z6RUkO5NMKKlueE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:26PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Use folio_lruvec() to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

