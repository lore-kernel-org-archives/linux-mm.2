Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B43BD74EDB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9436B04DD; Fri, 23 Jan 2026 09:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687196B04DE; Fri, 23 Jan 2026 09:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD436B04DF; Fri, 23 Jan 2026 09:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49E996B04DD
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:45:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 145DF8B419
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:45:04 +0000 (UTC)
X-FDA: 84363500928.08.F073A5F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D14340006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:45:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="yD/PCj8t";
	spf=none (imf07.hostedemail.com: domain of BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769179502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snVK1veFV1gsSfQW62KqY7I36fn5Lz9zL5oe6gesiPw=;
	b=Ev02dZsM7GbAtFgeJjgh8QLVMHnDwnKFg8/7AqC3A72GEI9D4I7i/OhuRh36bvz5NuF6GO
	qLYRwUgEulS6TE9NCMhAjRa+9MylG6Zs2d4N2X6pHglMOkcFzNg0CXTExB82gZ3qJo7LT7
	hTuboKxmqDhkYyINesrCiqhGssteBH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769179502; a=rsa-sha256;
	cv=none;
	b=vB5XdaW5XoS3GVgW0sSFtwMFos2BOgv/AraMdS+lx8uTdOJd9eIu/qbJpFFGIVwsIz6kc2
	nqn9rMJmjGtO15F6fLsALOkhNgBYvZ6NjfXvSZezihlRC8iAUq0bzDVyd7YJ2yc7w8f+Hj
	MnP0hc7uOcZjdkfVOgZMSC4Nvd9bPek=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="yD/PCj8t";
	spf=none (imf07.hostedemail.com: domain of BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=snVK1veFV1gsSfQW62KqY7I36fn5Lz9zL5oe6gesiPw=; b=yD/PCj8tH8iUKwuLmGuuaRZAZ4
	b9Y4GP+ZFXRJxd8IETUTeRpoMA9EGtzEYyd7gQRocXKZRkzAHfuVOV4PzfLQKIDyOXkcfW4Zl6viQ
	xh9Yo++ttvJ18GBsu1YZsP44o10p3mUEuX2PUV3lwLmTeWHAWERBvlPHzJHKp1ZEia+p4LwwOPgoG
	LKQRfArxUM71d08Br/pmTk2inJo4ASiFz15PEufQYhrwjyh1XJiHBCzG1eKScbTU5xR3UEQeyqIuH
	fxPqKM4C9Yhsb/7bPjVv5KH1i+PTsMRKCmZ5iqxgYrtnr8lbdWgmo3r6UkTGnNG/uAlx9TfvyD1tF
	4aDcDj+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vjIP6-000000093cF-1yfQ;
	Fri, 23 Jan 2026 14:44:52 +0000
Date: Fri, 23 Jan 2026 06:44:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <aXOJZBZCjjsbv7-e@infradead.org>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123082349.42663-3-alibuda@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 7D14340006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nbzjbqf1bf6a7zarmrnjyzeu9n1bs63j
X-HE-Tag: 1769179501-459723
X-HE-Meta: U2FsdGVkX19B3WkJOIZa4kExlcENC6wr5BhpHQb5dPK9QMuC4hnJSHulMoBJX7whtM+ymTO42k3jwkWaG2H43P8RKwQoTyNgafpq8yWghGG9gS2eIVObij9fGeVTO3XeSry/q81GTnc2LiSbvPtLs+kIdbJjQrdCi4M83UQjRPRGamJZAHiCQvKimmhBziGIvNVLhl9DRF1Dy4FbbM2H59EsEkQgmqdK9QseBRw5SYlmdjoXUcyMlEFOEEfWBypTW3hcACfsjOGZdzg2Ad3Tiq2382kyYG1F/wnGMgIPToQL2qrMExiAOmO15oKOjvnkYmH2Y3i17s4uyip6d/up7KP2ZPZ7xt+rUMglYcuP25R+B3smDEh2Tv2Xn3pxFQM3jLtIwxCc9lSS+pr8IQF5tBzwGYPYuDQIj0ouoTfbQKr45nZsJXaI6onyZesaSxgPNEQVIs5JHGB98PJb7AKoKCe3pb1B0u1IkhfF1rX96O+0/zwn/a7377N6v+eQE2OY+Xj+tWbdagchFwwaGL8rxJXr1MS61pfbJfaFEhNI1cYYhJsumSqMse3a8zmLIstB1QFWgIdFSsYUrIN9KhKli6JYLuOqkTjX57gW0DsZZJDbFKCQMNPrMYiVeDDzuAPmivwYmOjPJBaPHrrrD559ydRWyHGpXzZ1V8FrA997FZwDI57Lo+SFkF6ftIKWByF60N016n/5bdhw88eiXE38sCaDiof/hYx0Alu/Yom2PaF3U+ktQmwaBF9PoIc4VfpP3cD3we8nfuELHkDAFIEuK5NeUkFNm4vUPdG3lDmjGX3RGGTWkVNN0DzhTyP7lOLaKWgI5vUFOz2yh/vkeN6wVQQ7KR1JAbxtQWzTK3ZE72/VV5047nX/5q3erSg7zR/R8StNR4uhqjzmNeevMJKlCKWGqa/IQ/tZiT65enMwzTfRn17RPP0rGCh2fZltBuDgSRDiUTkaoz1WUw+jmp1
 Et9N4dsa
 vlvg1WJlElVqQOsGTgGw8/lydSd7K5ugZWuNLOABY27yGinTu2oYnp4iZmktWmKP41G+1VmOTAPhq66s3yKT+q5Xd3qrd2ZxLloyfG7e2AdKlWhLW6zV8PwCM2vOEoXi2LHLiU0ZwEJZpXSwayitfqSMJN8dd39uyae9aEvGgEazRmiHjPoQo1DSFkfTLCDVgviipZp+2aiS7aWJpuHeQIe3I5vM7e1bnyQgLnP5NiiAH1k9tMw55I5L7FqdqOV4FznsskgInXxqig3TMOQ9UsChoBDYmwk5C1TQNWa1VqvegyphWaL2OTW9wSzbTBNgUAeeoRLH6binV0N52pcDztssVvh5zQhfp3rahz8BwA3K1NF3xt4U5Emk+XygE2YCsP2B6V1sHECCdEwCPr/YaDXC8xhowRPLVdGeTmWHv9lIvU+wxIrplKlAGcWWw0/FCYQXLL9MERc35I1LgAUkDe8KEDZ6PEEkeywZxi3wFUwtl4hPb9W7lGUO8egJkA/s+xXq9upds0F9qzm4SAFsbSZMBx422fXv+2jXRZffCrt3s8bI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> find_vm_area() provides a way to find the vm_struct associated with a
> virtual address. Export this symbol to modules so that modularized
> subsystems can perform lookups on vmalloc addresses.

No, they have absolutely no business doing that.  This functionality
is very intentionally kept private.


