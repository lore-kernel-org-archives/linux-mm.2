Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1452C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710338E0006; Wed,  6 Aug 2025 10:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1238E0005; Wed,  6 Aug 2025 10:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD978E0006; Wed,  6 Aug 2025 10:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9978E0005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:00:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB884115C9E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:00:48 +0000 (UTC)
X-FDA: 83746493376.13.157BD54
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 11EDC80010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:00:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="M6VTS/V8"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754488847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJG7zAGLSVwqJGykShuO6NkkFKjBxNy6E8kx/Jr5iwM=;
	b=325Z2CQ3IslmyGRHLXUsUiozejJx0VbrtN4TBbxMzqRPF1A7+QtkVSM0qsItgZcWw23aAn
	xdIt7APACEVHnr1edq5SulG0duC6OSZg2QuI1tHfDWRroX60FEeEv0X1mJQ6f3g4/O+vC1
	mLiMbT4r6nQn80rEQJbplX79H5dqxdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754488847; a=rsa-sha256;
	cv=none;
	b=L6/bBYLniP1BJ9hVdeHAtmINRsyt6Sw8kXeS6IS1Hvy8kv+Tn8WugxQtyXBxKomWInEI8e
	UpbJ4nqmjxnsUs8BXPC8BtXvNmg44sNAKJw5bHIbxJAmFuAf0lMrJUly8F5crbqEV5MYa6
	EY8a7r11vNIZHFb4WpusceVjfBgbPOo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="M6VTS/V8";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gJG7zAGLSVwqJGykShuO6NkkFKjBxNy6E8kx/Jr5iwM=; b=M6VTS/V8KVgVyoVW6zqS9EDX/e
	s/CA9feoJMEx0U8MeLWVWg+Vbxf9IoyClXtX/A86NjqSQbvQQkk3ULuHXNVIs4mN8Cr6dLK2Oc2eb
	SHQSLALX1rpszN38CE029vFlzoeZOGXUFSjCaE8lv8mtNCude3p7ID/skmE5eg6vsWX3iN5vNQJFl
	Q8ehjh4lrReDHmMKMnX8Z7DdpVnxGt2OWbyYi9IPnEnqoQJ7Le8dX/JLYDUk0drnEzuVElvvvpVtX
	jrczSPjUA4HR/yOO+pAb3YWVQW3A46zGWOnk3dNq0wpHiydQyWaIEMEB5XSs94B/jCc+u2G4CfJ6o
	ycApP/xw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujeh9-00000005C1c-1rkK;
	Wed, 06 Aug 2025 14:00:43 +0000
Date: Wed, 6 Aug 2025 15:00:43 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
	shakeel.butt@linux.dev, hch@infradead.org, wqu@suse.com
Subject: Re: [PATCH 0/3] filemap_add_folio_nocharge()
Message-ID: <aJNgC7f9RVr_rh47@casper.infradead.org>
References: <cover.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1754438418.git.boris@bur.io>
X-Rspamd-Queue-Id: 11EDC80010
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: roxa7z3itby4enqu1s48udwy4kfky11s
X-HE-Tag: 1754488846-494147
X-HE-Meta: U2FsdGVkX18pPpx6ShADMC+SuGK4iPLQrR1h0nGe47GborQUrX7h35IFG/shEfWYNgd7QFhswrr5FQLQy2QyzfbW9TjtmisdXa6YF3c5yYYibslKzvgeo9P7uCAC/1Xed7NhMYmBqzYZjAl9eA/w6DRsOkCLBmiUHOhuiYGrB8og20uA3cbfcsnJXWFOs5wQGCpy/2b9WrhJfwhv4Z49CTLPsvDXDRuHi/bQiex9zy5a5jpNyVhTySefbIloFCO143P6IzPUll7WxwMCzC5X7yONO4RAwm1LVwck2e3jMMDj5jWPNAb8/9UODtkmydTNFvwPrESpNmGaK6BwB3VhlAFjMp7bO1uDOSII0KcIf+R+63lgl0zrdFUUK39AOOjv0to6WzjYGKwm+4T71kh0RKHTlwfQEZ8spt0xySVoHAS1XbLcoV7/Ift8K0bVk+ageYNggvMwbcw8q4t5uukQImS8tQT/q3+RO8IEaBlGbxGCMjzvZktBe3VFlnZxScFAKCjcEkFwHRD5DgSy9yYddz+lkXTVGmVWs+69pIV6EV/O6AcyM+2Lv7l7j9sGfCZi5mn4OoARAQRSlmLb8n5mIpfOJjmwkntYgXTb4G9KPrdTXEWF9klvA8ONYlpSOR7aXQu7siBViRMhh0jzwmCTtxSA/SlFDSLNHAA+/+e9hyWJ8HFeqi1FSELngGdKL6jCMz928EblkixyFf6p5ZvlVawWEPQelrMhJFEvWPy1poxiQWnN9Jsn6z3LkHrK0/fRZ2qTQ2DscRcW5b5uOfsRtbFjgUbVH8CM7UumIzH6hFZTLpM/FtsFYqn1mc211gYvvdLf7oodLMK8pt2RnwlMR2v1OkObtx9M7MbN1d8fDulnAbUNXs6cAwU1TNAAyiT/kQStxdx4wki3+OKJQA5H4UNk5ewHwVxkvoFpM+2uBJtUj7U3sx4yVXN4uDk8us8G3+jQr9d+Ow9v0EY2U8e
 keCENxLS
 q7ST9UsCk071pqTXX1tyhv93z4/MOsiI942+5gobUZsT8oMKJ2AGUVnbmyeQankiNMoxZPK2RzyJmCzniaVr2CbDZVhx1CjpidkeO3SxcB0y66luO9lCkecku0RF4U3ja+5VyS1xADcenYcJOExOss5pWyFIRfIKDHvFZigNLuyAwmBTllmozQRhz5X799cXxdCoB/Pjx/5kl5DFV9dQ1ucPaktXjeN43+gTjvY9fFJdAmldgsMtNbmv/VE2oOJv79Xwq6k1ucLZ1uICBmdf9gu/4b33Ih5TGDM9ldt2xPcye3/RjGQdm2phFFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 05:11:46PM -0700, Boris Burkov wrote:
> I would like to revisit Qu's proposal to not charge btrfs extent_buffer
> allocations to the user's cgroup.
> 
> https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/

I prefer Qu's suggestion to add a flag to the address_space.  This really
is a property of the address_space, not a property of the call-site.


