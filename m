Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57BDC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3A96B0096; Fri, 24 Jul 2026 12:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84D46B0098; Fri, 24 Jul 2026 12:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25F56B0099; Fri, 24 Jul 2026 12:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCCA6B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:37:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04CEAA03F6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:37:04 +0000 (UTC)
X-FDA: 85024224810.23.87CF15B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81FD818000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:37:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mKYOehCD;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784911023;
	b=DMJiKun5JZTb/GIU9UGUB7LwB8c6U1O82R7qMAYFndPvbck+8RiTCCPllDYtq6wC+c+IeW
	yeoSVVBjhcitPSL8VOacodvSyit1SG2vG7DJ9Rj7YASq+StST26myvS1xJiuH28tpbGrda
	btRqSdakmq4fbHS6hO0hcFRKAWmiAm4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mKYOehCD;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784911023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxJe9WdMixn6k2qpUgoe6ZJy8Nr+Gq24YeAx3VHkQZg=;
	b=HXZBe6S5AypY8aw+uEQ09WPx8uDDzNrLnq3iFthVmEFW1oLTa7cmw9GuMNAKxCeXzK18UH
	f63UMsdHlgZEHK9cKwjXzk7RnxT9S8ehp0DCoXRWv9LIfeMzwCDan+7OfVlTaUElnaq0is
	TrnYOnb57jD9y2G8Bz0PJvNe/mRZJko=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uxJe9WdMixn6k2qpUgoe6ZJy8Nr+Gq24YeAx3VHkQZg=; b=mKYOehCDV+zJ2Q9gEsebdo9Pfr
	TLx5bfwKed1Kbdna4aebNWZMLyioGLhE9I/JvjKqOOGbxFyhPYdUmYCYmdhcKRDi+dj/lK+yxoqNn
	Jg0eKoKFzWGksrpCKuKAsbveIRJ4MUrmMOHy/ZGmlV6Wfivr0w86pDBkYM/2rFEoVNHMwfcQxE+Wc
	50GCj+O0/D3IVRiRHcybTQE+3suU6BvhQwIdfYB7ipf9YNFVstFKAyIYATKNX6y51dDaILY33S9m3
	aJVGPUz1TFCPgPAGxQp6MPZ+ZYFNcBgQhA5Yqul70bmBAxDdTn49BtpjNlY8XULQhNfxOhHJqTeh1
	L4T7oQaw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnItQ-00000003vYD-0Y2N;
	Fri, 24 Jul 2026 16:37:00 +0000
Date: Fri, 24 Jul 2026 17:36:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 14/14] hugetlb: replace hugetlbfs_read_iter() with
 generic_file_read_iter()
Message-ID: <amOUq8dF-H4bfbAx@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-15-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-15-willy@infradead.org>
X-Stat-Signature: f4c313xha1dp5ko9f9mfju1ehm4qqp7y
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 81FD818000C
X-Rspam-User: 
X-HE-Tag: 1784911023-58854
X-HE-Meta: U2FsdGVkX18IymDCAtmpb8bsdthF9L4O22FLUYfr/gQN+7ciI7J0uAEdcXQAat4ifAGv3D8W3KKvsgAyH8et5OJpblUjztSOeR2IwkOSYa7Wp9s+OiU2JbrkVNVIG4Qbn+hT6sCw5Xt8SDnAV46wn+nSfKsYoW/YTL8+RXeDFSw0oF4Q/oYClknRfvHQyqdgUS25zyfP6AMip9V1mUe7sgyJWtqDpbQrVBv/wVlPtyKpW9Rg+OaFtlepMkPyMm4AxP7s1Nfmd4spc/2+71Ccng5RfRMUKjfZ7u9iw6rNM69ybBfflUYvPe9/1RsvmZuG5jRriIrgPDsdXptWU7BH1SAbWc2PY/VzgyhV9hsIjQfKEshbmjjYUMU7n7Ut3Io4p/jRk46wMv01h+0dv27tzp5Y4ALK05zNC2v13pVuECliUmi1q5pQCoXMoNQjDr45So9bpNPd0scg2Dsd+9kOBbz/tjxznVXKacuk2fT50kn1NOWQQ6dv5hH8RTRGfFOzX9u56hIe+jsKBukTXSSWEyvsTfxd4YLk69ARZGvfyBY5VhEIf4fsicHsITwNnjiyUIwDBtJ/JWjwvJVyitIEyGnPYbUTI3mzdBCEKduJ4qDuk6lCnUNHD+Wb7PEAABCJnQyOSrERA/OKRR5yQZ9PC1VzDpNdaBHVq6PcZ68QolmsSOk/nJWXSPOH0wc1IXiFf+vC/kqIczRRNN5ZwTgMOxz7mZ2P9oYWm2S+qKN42kRsz38wVeT1vW3ROfk8Vh0c9g50mHNpNQ8t/m9IWKvDxDLlfRofAd2BysSCUGdq+6+Iwano4CWJdewXiUZTAPOHfzLseVchOzyrHsVI9y4r5Pk/J1g/30zaVbp8hyNiqXdf5zAnAtewjyirwAi2ig0POV98Q68BJFxmkaVSNUqdKeLKdY0JB49VzRMzZ4ha77mZRdjdoN9idX1NtpbkC9LX4IgnB/6t3PheYAwysGs
 iF287Rgl
 43rjIIEReJiPD3Me39wXJOgocNeBabBXZpIt3UiHrrTKPeeJBXLZEthPAtswtklgpP6tzpzYNFL/eQLL+LGrL2pOjmklWfdRap/iyvkcgQJWEi8BnCCi3qaBfTXG1ZSqig+4HsBncjlQoG2UHfcwSU1zRUTAB8luBmBMrtAUOnWyWsBGwngaOdU5hI7T0I9+EyRFkxXUt7ebH2z79wd+c0DHmwrPKE9gAm/kfnrM1WCP89gl96On8gDTaWQUWH2b+E2dS7AexEIno7+YYZZVx6FeikaFQO8HhL1JNsnsibgzO5awdkuIetr0SxN0KzY8p7h06wosrbNGCFtyLOOkCcDmn+STBHuOUP2rZFR7JpPl3OVEdI/iDNt3mxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Sashiko review finds two problems which are already addressed in
earlier patches.

