Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D20D61013
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 13:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423586B0088; Thu, 29 Jan 2026 08:21:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA7E6B0089; Thu, 29 Jan 2026 08:21:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7056B008A; Thu, 29 Jan 2026 08:21:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2A26B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:21:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9988085E7A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:21:02 +0000 (UTC)
X-FDA: 84385061964.29.ACB7497
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id BB37C1A000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:21:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=nXGiXogu;
	spf=pass (imf19.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769692860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vh7VpdWClqvupBRtUyQ4oaehf0QJg+QlY6j9lsmTLm0=;
	b=lDqC1hldePLVjN4jNHM3J7kq68BuuZF+bLj0q6KM03LLPeIs5fcyozq5ICjp4faU0PBej1
	R4bGVWJLf5Jrkmwm80XXPw3KoLBo8RfXNUmtyYws7GUrwfs8EQFIyD8zlFjqSVNXnGFbTc
	Bsf18xQ7s0xDci+uH64oj3WbI1QO+mo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=nXGiXogu;
	spf=pass (imf19.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769692860; a=rsa-sha256;
	cv=none;
	b=yMPqMjBvWAZatI5P6zIEM1HjHNMyKEJHTLPQ8YkA0fPeRlA7RpnhBpaHtXzEc/C64z0kgf
	kqQV+QU9U1seph02Y7gaKFPf0mhx8XIRJifsBzTUMOE/+aHm298HOxWZuyqdPr+bGjMyLC
	XcuDwgwjvcss44NHSpf7MYCCgr+G2zE=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c59bce68a1so74695685a.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769692860; x=1770297660; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vh7VpdWClqvupBRtUyQ4oaehf0QJg+QlY6j9lsmTLm0=;
        b=nXGiXoguw1J2tjPeCt9oa/xJJC6o+NIouY0fBSrDWhKoYpmKp5Ybs2ldINXzYxFs2f
         47nVq86IkUt21fi/nLz/SWKPa+2C5Ju+dXpKNhzqsnXmkDrzra+x45WNpL40VK4VCUaw
         /zJ7iPbaF5Hmyu1EDz5+Vl10026E+TgAn1OmFFVM8ROWUyC1EdGtjTlJvQ+GQuEU+QiO
         fMDKUElO+lFn/4NJapQvGtjIxNp9dBNwf85PIAHi/mB5JDBT2tHvUb6cuYHomb9hkmfv
         UGvR4d6irSCIZvTAz4ckYBTp6gBQB5GmnIid9mJU+qRsqGuf9KNxKZlRenTIVWxWesC3
         qFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769692860; x=1770297660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vh7VpdWClqvupBRtUyQ4oaehf0QJg+QlY6j9lsmTLm0=;
        b=eurEaeE+vegZHyv/QnExEg7lTlVawOjwWbbF+TO0+u+h7lH7aiPnmkxFFR+GNEuHsu
         djipUN58W6IZBwZPCPMSKOAIGbjnOn6QhcjRo2Y46YrUA/7WA//O2K9/CxebE7XxyU7V
         mjZgGRiWGzw2rbDosOAV86nruDWToOt8LoefZ+iZu+dYKKlRYbrGQ/IqDs3Rr8z2PYK1
         mTlzNIdRovMlAA9xDPe1PE0+sc4VSJqpxqwHR57czv2dC0NVCTk1fnc4Dh6MobIBSHRm
         igmySn7tW1U3A2fkT2H7HIwYslrbhwrFaYlNQzvYl5UN+V/sqwyVXJa/wqvaEz6rsiDM
         /pEw==
X-Forwarded-Encrypted: i=1; AJvYcCVftkCcWMAb79zKYRIw81UslbpgNa/Wo2cMcw9VmvMIJhcWmjbNOii8XRC9nrEFjsS30nif4Y0yNg==@kvack.org
X-Gm-Message-State: AOJu0Yw5wSEZ1yaG6slAVpw0kE7ixtYpH/yD/Wz+5a7eAruSHqkO+E9T
	8Cl8/XWxN8O1ccVyHRf5GLd0W17D6tfIf57MHSRcNtyca7H6S+ybrsGyAyPpj1kCU1Q=
X-Gm-Gg: AZuq6aKcyb9vm78e6tLXOUfsQSJVny7h6/t5s5Hfi+KwxAn0RbrFeliUQ24RvZx7Tii
	yePN4Z1bNfV4WHCZqTNFfjnTs3ErM7AkPZs1koM/h/bvatnH2fv19Af2lolkTm524eNrPu/GBOe
	leZL08StA70nEUYw2ojEWX8IsXk7WhaAMTTLHUSCfu4rgA7hirnrbop7RugNGrtBQZbfPBSZJmJ
	is+6Tkewu43sjsiZuMuEOytIcvbG44qAIk0OVv75Ry5pZrNziiQ6YigbRNleZzGtETfvA9o0FBj
	OOt5LRrEm7c/p4qkv1ycDz9uOXqDTTeomjknEF3PN+oaJZVLiYjbLUpiiQDE0QoiB8ELttPtLV6
	TT3wIaDvnQj/I53LN9ApzoWM3Dpi9aJK0fBPj8su7vHlmto79ecpboO/Vwy4+m5ueoYyBK9Wbu4
	C9l+8YZUUOekOPQy8j+C0Hd97NFkD0g7FlO5zJr60GKRrTLGB/evozyHnTn7VXKlvaJYs=
X-Received: by 2002:a05:620a:444d:b0:8c7:177f:cc17 with SMTP id af79cd13be357-8c7177fcf62mr589344485a.46.1769692859712;
        Thu, 29 Jan 2026 05:20:59 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36a5fb1sm37087576d6.9.2026.01.29.05.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 05:20:59 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlRxC-00000009joR-3Dw2;
	Thu, 29 Jan 2026 09:20:58 -0400
Date: Thu, 29 Jan 2026 09:20:58 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Leon Romanovsky <leon@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <20260129132058.GC2307128@ziepe.ca>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128180629.GT1641016@ziepe.ca>
 <20260129113609.GA37734@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129113609.GA37734@j66a10360.sqa.eu95>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB37C1A000A
X-Stat-Signature: q6zoespejm1rary36o1djyk69hsqpo8k
X-Rspam-User: 
X-HE-Tag: 1769692860-964413
X-HE-Meta: U2FsdGVkX1/V1Kjlj7HJir8yqn+5/CSU7KaO1x3GxcHMsMbtYeZPfCl84JZKenc3SxcGI0vVjqIQMUM9qeLg4PgpHjlRjluwyiaFKjoVTfAoUoINjTSqbKN3+NjShr6D5HE6h9+wIk8W+KNLB6uH9+saV20RineoyaOmY9nvsSZWxnjakb3TcW58/FUdStaLET1lj78CIduh8/MZ/P9XwbVyD8H11Ftq5Jj14Sxgyc4HPzfuPTIESXY8vHQEAJAQcyBqvAxkwvhvdGlQvArgUfr/DuHu/QN0TzeVl8y1iM7av/jHZ7Iv9s4vpNVGzoWuGEy50lTFXMMNGl7FS8fOR5yfqzDxQFV4m18ORyvCNwRqvSjSmHVGo+b5iY1LIDuUmbRSBIWGeNs9Tw5tyPFvrtitkNy5tJlo91IdGRCw+xrflBxuRh9sVhqh2ISrJHV9+5tR6t0YT2WKuIIbyzQNXX/xYXMtZy4j7z95r6RU8x/oQH9lWrhbwWmbkNpoQgb8vYm6BODNAAK4UPEamKXt0dus18g69zIC881y5rrkLEFelP6gap0VkKqqlXp/3Ra+AGJdaJMuaTyIm6XzVFpLD4xZnYDfpvLy+CveBgV/auxX+KGH82CEbCvdbFWA+Fh22HlhmlD9pEf7/LyFCNmwI9FwDYmcC8Z/+VGkbG1GtxS/ueth2Ky1vV8y/oR/akASY17ZM4asI1xgk8KQRS86OENDxHZl2m5tf/toDW//AJgj2Usn/BODqzdeLcZe88d7rcAQTsTXBYGkikcwWbGXpej09O2xjuy/Am4f/NPtAeCcGSjr5Xw2cwri9EIE/fEiB7acFsSZ2WATJzn98hQ0GY6+AOjdIf5a3c3p4dTtcJ2+OSFjeJ9jl6wprm+aCXdTopx/6rV63zYNlxaI17YotIHd/eN1cnuP5FGiaqxNX8ptRglSnSt2jxO64T1hv/6F9Y6vPwv4xbo/aYHJmFv
 qGXoixIU
 7Gq4SHjatx9VGvsuDB95R4yyi1luPjg9lxYpAdJWDf1WN02TyRUKEYDdN7tOd08fLzWa+RBzGSpYtVrLG9H0qz7f1ua8tQfe7XTll5wDRNU1Ys7adPkCKXJJ02SC9bUi+mLHUMWMMeSHfpGQdyLClfja/7l2QVvUKjNt/dfxy8/QehA8w2vGCsbJZlirFwpPYsDH5kBljW1k6XVMaTskYDs+I9co2z9Qg+8/1Z5Hscn05ajkqLf9IPbK9C69t0wHLM20opRT8uUVpRfmgrE2tYQtOtw9d9lOwyaD5plT8Rqr7tcP2ZiLDPks06QdUfWNB1Xi7IO1ypl/Yo1Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 07:36:09PM +0800, D. Wythe wrote:

> > From there you can check the resulting scatterlist and compute the
> > page_size to pass to ib_map_mr_sg().

I should clarify this is done after DMA mapping the scatterlist. dma
mapping can improve the page size.

And maybe the core code should be helping compute the MR's target page
size for a scatterlist.. We already have code to do this in umem, and
it is a pretty bit tricky considering the IOVA related rules.

Jason

