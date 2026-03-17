Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9BBFEDA00
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAED76B009D; Tue, 17 Mar 2026 14:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D600A6B009F; Tue, 17 Mar 2026 14:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CBB6B00A0; Tue, 17 Mar 2026 14:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA1686B009D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:37:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A3E21601BA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:37:34 +0000 (UTC)
X-FDA: 84556413228.30.A7F462F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C08B740009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:37:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xBLlVrZS;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773772652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1fPag/Ma0Or3n9BwLwG0BHnymxAfli1gvz6SmhvgXc=;
	b=s93b0hnTx2zWxTaWThLQaKODx/xBgvwCarsrbCxBPXasHgGmgTkpdroSawers14x2szyr1
	bD7MM5+QsNuOhwcJBfYm2Hz07WOuDrITlAcjF0fxij5SlE76LZcasUULywntPgdUwyetPa
	+g6pMDqVeCptpIdT1xa48RFGMeqlWOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773772652; a=rsa-sha256;
	cv=none;
	b=G14ShQ+l5HGKmMDJQyhqdUWSLYBSEX41FZ9FdV4J+OHo/5VN82G9HJaD/OVxY7/PYG1JdF
	+n/i9dnKuqNXxjhquEAlcgJ4oiDzYTIZ86GegtUrIVqeDvgjct7/OqpJBuEPDSlUE00hYN
	9Wqv6bogoUTpOEACh9xOqO6EsZNZTLA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xBLlVrZS;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7388F4400A;
	Tue, 17 Mar 2026 18:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2CDC4CEF7;
	Tue, 17 Mar 2026 18:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773772651;
	bh=X1fPag/Ma0Or3n9BwLwG0BHnymxAfli1gvz6SmhvgXc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xBLlVrZSOfM9FPIB0k7xOsujepC5gsf6N9xIoEhu0lP7W7dyGaurgbK030QQFBJLG
	 uvPeZNqE/I/Hpo6HjsIoE2XzGgo2h0w/sf9uQIYKx7uXY/WKXYI1NsikK3REwoNNky
	 L+q5URynkmWbhbeuvVKmsijD61veTJYwQWSeDvI4=
Date: Tue, 17 Mar 2026 11:37:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not
 available
Message-Id: <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
In-Reply-To: <20260317094419.1429259-1-chuhu@redhat.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d8n9a696qfbbozozbuefde1iz6otzk11
X-Rspamd-Queue-Id: C08B740009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773772652-118292
X-HE-Meta: U2FsdGVkX19BD611Divbk/Kveao9G4tgNGCzjcy+BozAH56m/kaocBq8/DlfZ7ssmThayCnpFh37vL6ZFqNIu9qCs3LED+Rr5l6XMCFXuevULe/Hp+oNxPaVVapeM9ZBPmFiX6/9/ERXZ1tPHdV6URgxWaPyX6B8+a8dyt8EjdyRoNBwtBp1wYt2jcpCZ6B3nBMu1Ykif9eFaZaxv0c3LQTUly8lH1SbCbjmfsu63LXDkllYQSVtsxSEqRbQXGDNmuSAMc/MqC/ZuIXu8PSzL3hjcqrqRB5r3XrYD3EiK1Oo4+as02MO0hPQNkws5bBQx4hdXl+hEA2yq2K0AImI6NexpzJa6uY1ZtT5bdTvS4R3LxbzLr9Y33HGLy3EjRFjQkJ0HGDZQt3vb9CyUibo7Bed5KJ6l7rA+74yB53rjBasRTR1DKWuMiTIoyHiPGvgNNs2HH3SXsjTssCO4gF9hZcTdwdMxZGzs1RNQKtWIEbcCWaeCuSiB8i9fx0QgBiL6jFowdjl2P76Mf6VUwyIB4YEfkePp6LdEF1QJomIuIpcYzZr27MJ98hZ0z7j3Kk8/Z3txBPHqm4piHKPptar1SJbSl104H6eaq9bzRX6PYajB1IJ/hC1hlwvHJQi0VIEo4XpTX7muLPzau76noBWf7IGO9/j7W7Ycj7nr6j3Y+E3oKpbd+e//ajh/UEiYr7p2/KjM3PDfJb7NwNrwHUkdWp01nSCiaox+aRuSnywVplqsIsBaVKzHaz2M3KIoMdVoQN6dBe+tkhtlj2eXQHmRf24VYyVvSSL0WEIoA6Prdb9EuHs2JNyXuM81RaFUU521s4dcZyLF13oEI+TlgXA1ZUjcDUYMM5JYERJmZiLMJcCXEI2EPWf+HpKBWV+ONGvPX9x7+sIqTSGSTg+jf5r9DOuaMgZq41HrxWaF5cLhQthXbDl/j4C5r828tqWx7/D/4EMG7ZjHZByP95cHRx
 2M1+5Eoc
 5+UCqSh3/jWpBcTI3JPEJR9XEWpfhc9nYqMWcezu8OAisAgN2hsQ5zqDuVyFYkLzbk9P6/AHGQH7ol/731PJs2Ema468TgF4APMc/GYdP+OR5kf+Tfr3Rrw25/rfVaMh6hhGjF4kPYkU2THGjwXJazflYMP8rYf96lsnzhhhfgFCTmLCUFj+P86Wpo3vc6q2CiqcqmNQociK2avRR5iB3CHPIyqxEPhGJ6zv17/69vfJVyTDj37340ejk9bE1cHhqIN7WcnttwMheH6NssaYaBJ1Scy/GQ/Vz+n2m8BuU7e+R3RhUXNRv+9KUpFToEpW1bMHA7CZ5/kW69sQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 17:44:14 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false negative.
> Mark those tests as skip when thp is not available.

AI review asked some questions:
https://sashiko.dev/#/patchset/20260317094419.1429259-1-chuhu%40redhat.com

