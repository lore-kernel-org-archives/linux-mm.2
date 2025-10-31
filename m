Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4B4CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579C98E00FA; Fri, 31 Oct 2025 06:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503408E0042; Fri, 31 Oct 2025 06:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A238E00FA; Fri, 31 Oct 2025 06:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29B938E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:23:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1B6B888E9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:23:24 +0000 (UTC)
X-FDA: 84058022328.20.7E04B3A
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	by imf13.hostedemail.com (Postfix) with ESMTP id 125192000D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:23:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of postmaster@kaiser.cx designates 152.53.16.207 as permitted sender) smtp.mailfrom=postmaster@kaiser.cx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761906203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RmEi9obaDFyfraozI40urtGI6ee7JEaoa811gdErnL4=;
	b=N3wKxow/5NT6ZuTNm+9U+ly9k5dM5Eb3LKmz5xZEgl4nXxKLW0F+W9i4FI6WvSqvzTbDhc
	EIKPOEZ9+7k9ekLvxPEsi0hOeBOCKnFUImu6yPB85Zrb1cz5ql68wJ1bx1DIgB1mPMNfSd
	n+wQiJSc+zMX7IlPVjhZ7MiQHSgqSfY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of postmaster@kaiser.cx designates 152.53.16.207 as permitted sender) smtp.mailfrom=postmaster@kaiser.cx
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761906203; a=rsa-sha256;
	cv=none;
	b=d2uHZ3wSkB69FCDwq6cEveku9+4bNLSgmfwmHT6TKnpOG63IbUBJ5P8myyQAKyprxqyzeM
	e0xke3Cbm3G4iUWojgFR6pKaE+KCQ1N2/wR2/KMD3N8qneaW5y/1p7dUmk5nIvUJg/ihxR
	UbDHx9ZCwArnKHwCVH37ZwoUGd3ZdzM=
Received: from martin by akranes.kaiser.cx with local (Exim 4.96)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1vEmHa-0067HP-1L;
	Fri, 31 Oct 2025 11:22:58 +0100
Date: Fri, 31 Oct 2025 11:22:58 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: fix tracepoint string pointers
Message-ID: <aQSOAkBbFkBfYxPs@akranes.kaiser.cx>
References: <20251030155537.87972-1-martin@kaiser.cx>
 <20251030193206.22bb773e697b6cc385d5aa67@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030193206.22bb773e697b6cc385d5aa67@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 125192000D
X-Stat-Signature: 5odmb5jd5jexmfkktprtz3stym1sp1fu
X-Rspam-User: 
X-HE-Tag: 1761906202-609403
X-HE-Meta: U2FsdGVkX1//Wrv82eQwcc7W14csFdSWokIi/U14cHVjgtXBsX7jHtROFG/MB2Y5+S4tIWw3OTkgm4YnP8F5nz8bkEUUF9w+4rMtNt1/x3TbSUVUGJLiEHyV10OP5oZ9RftCsj+31Nc75wgZC9Smr/Lv9A9vC/pWOTUC6vd3MU+9FDyhCD/1Is0W68tcnMQ2FgEwrZ0fJHaYXVyeZB+JDka0CK7gDW+fn3SVt/U2IdUUVaVOU2QK8UvoXiRLgr+YpG85OVqJ3fS4SW/NV1uJz/nWsE7e90znWm9gd9AxNBa+8LCnsAAFJxEKr2ULv6V6qr+r6HhQyzgdy/HyRVe4BHF5fTS8DyACPxWg4sM1bYaMjwtmGTedZJADIPyGw9rhpeFEZBo8z/gYzvfN0THOicj+iNjSRUjijsZJEoLjQiiowM8Zw2MDGFJDiHzRr3yob9d11JXGltJwu9hoRZPXv42d8UztNptQb8nvDy/BZmtPXzxANEtRifBXan4es4LKUmXB48WFUdV59big0lyol1tGmlQ1I3iCyFeJGiXnfesoc0iy2g56DrF7P73QmByqyvi6bnZDYh34Biao12gANyDxqxT45RQ/JiRq/xbrDGZ1e6e2cZ9JijDol+GZnqhOal28WzZGFnKZf8wveVeh32SQnE6l2QpZQsmTYvLRnAoqD+N8jjltlznH2jG2E+8+6v+HPQPwr1Ij4pH1XEWz11Mgdi2TC9V10GhojRbl4nlz9ASseWb+1zTfK6pKzGITcwgmktq9x31vZoYpTLbkvby2Jjj+R0IADrIS5yZDnfLxxoINCE0In5aIJGLz74zJpy4F8+Gewd8K1mfIX+hqZb3pvwkLCX+FE3Pzxqpr2Kwo2aEiJGjnea/d+F2uGxtv8ysaBrTG/zpj1BmZa6QtJuj7WDuebEU09WGUbgn9VpRckOTYZLK6nOqdP6iBXVkxqPLVjG/4oP+P0JLV6DL
 XtrJuquI
 5HFUHEvhXF0JaeDwfc2Z7xfZajK4MnhkGVyd7YbVqeWyihGUZXT7zHBgRq5A3CrgDeTZLMt9GpL505DUBXbsSjLuxCuLVkceWQBoqyEtdXyTMfbBZqq9A1m+KqBn5yfMOdq/FXGNzhcf0J7uh/Ih1uEijL080i0qsMK2QeXC6WzVgqbLMejQwo6MuxmTClCKCzhdmoa+firOWOSKwnI3EKe0JiMC7i8PBU7H0rG07xWOJczkjV2QFTrAzc7e9lqpJh9TGsqfiKMXsrX2/i2pMyUx01AIJV+5MSFGPkdWCpAnh4ys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thus wrote Andrew Morton (akpm@linux-foundation.org):

> > -	trace_ma_op(__func__, mas);
> > +	trace_ma_op(TP_FCT, mas);


> What could cause the storage for __func__ to disappear as you suggest?

I see your point. For __func__, the compiler generates a local symbol in
.rodata that should always be accessible by its address.

One case that doesn't work without my patch would be trace-cmd record to save
the binary ringbuffer and trace-cmd report to parse it in userspace. The
address of __func__ can't be dereferenced from userspace but tracepoint_string
will add an entry to /sys/kernel/tracing/printk_formats

Best regards,
Martin

