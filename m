Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C0AC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574BA6B0088; Sun, 20 Sep 2026 06:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE2A6B008A; Sun, 20 Sep 2026 06:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED356B008C; Sun, 20 Sep 2026 06:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18AD26B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:15:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5637DA03E7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:15:44 +0000 (UTC)
X-FDA: 85233734208.22.B563EC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C11971C0006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:15:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt6Lliyr;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789899342;
	b=gkx2kysgPIVJYFBn10q4t4WvZLtVygb1w8trsSWIaT6aD1bV4ghuqjZCjptAEobsxlQd0E
	+Mp8BwvyR8jDmN/sGmAygkJInomHck0zPxMt9AwQ3+iP7XDtbhyrJJuIHT83zf0ES1ZKcS
	oXIyCmPinZ6kJLMBMWRcIo0La69XlTU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt6Lliyr;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789899342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mP4LBcsk8SbUUg5L9VQYHG5XTUfJqZzfjqBrf1Vbspw=;
	b=XK9v1G1nWQV96DepKZSvsGD/LIt3/BceBWMtOMPIeQnm2VmEnjW2cVhL7BiuBP1RB35gXX
	DXECAKXqo3+KSK0CwnzzeOpg6r52u+3+iDjGE/RgvA0labkeRGd0T+6AsPkT9pXS/4WkDY
	iOSjRB5zcwplqx/igrjvAfO8yDaSK3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A261740E05;
	Sun, 20 Sep 2026 10:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43181F000FF;
	Sun, 20 Sep 2026 10:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789899341;
	bh=mP4LBcsk8SbUUg5L9VQYHG5XTUfJqZzfjqBrf1Vbspw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lt6Lliyrx6wJvs1xcjP1ZckgcNwtCTa4efHtXdEYCNTCsp3h5+IAJN52pwnMfWV67
	 IAnW+MJIO7v78IZdnjZk8jhhCIfgG1AeQc84W7Mf7/+dBuBOgxKo2XwE3ecsCRJUfI
	 E5sCQV7rzmlirmW8XZd5EBCRKJy0Se/a+q/T656v+22BOZN7jfd50kThusNxn9vo/m
	 C4xq0ySGZq4ee0LE6c6E38p4Px64b25ynKt1hVpzZer7dFkjhK+ZQtJX32ywDuNEn6
	 1Mac9tq2Lzr88YUy5J80vQfCElejgza11vExf+r2z+7JBlzgEdqlA+9NqjywkTMQk/
	 aCyNI2cEh2j8g==
Date: Sun, 20 Sep 2026 11:15:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hui Peng <benquike@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, bgeffon@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: account unmoved locked pages in
 dontunmap_complete()
Message-ID: <aq-s1erMd9kCgrRb@gremlin>
References: <20260919210612.3028241-1-benquike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919210612.3028241-1-benquike@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C11971C0006
X-Stat-Signature: domwpff1qsjpchie4gt6yofibyzbxk7f
X-Rspam-User: 
X-HE-Tag: 1789899342-612757
X-HE-Meta: U2FsdGVkX18/VDJb1rZzd19sr8n7GqeCtMBvsgRiq9R7TNMfe9fKFtQVEj5E8j9QVHfXUvCNkMNDRW78LK6+Xa0rygunFg+ezjP2McavSZONsqy3msjbxMlvc/25XkvNUT9UF1wZyMM/UkEXIahKJEDVewA1dA8B0o/ndwIYu3yhxD44RgoZe0f/u6e7A7kfAQLgBqBxkweW1HIVIczW1z8X2gNMVfpNh3lv8lt+Ot/mqOPbIGqtCbBtRI2FnMQyuvdmR+FdlAWhGtyN1nHC7FDi9A1GCKRX1vfa2IIeOgYxlkBE5tjUIM8G0YYEqnRIIipNQLLoHKn66le61xjArMO3PPXmWnkwYhIm2jqH1eZnolNmnCZLAIXRM6owM5iRsaAqBH1GaTLld+m0TGi/NIQ85j66Bnknrz2GwbgRfDdYtK68ok39t/1JR4B9tG5zFMDe9K97khT35ppTugkgkIdui/J7manX3WSjIjppkUXCaFk7b4rAqN27ATMl1164VPie0ilnMJP23cgyfFR3zswQUqMv0q2Ex0xacTkguSMRaqC8LxG0cO4l7NZkcNQFhc0oFumIXXCIvrSDbtCEcyFf9vufa2Fqxxg/2v1kfpShUc36LjhJAoNnh5tdlXjUkw6BE6GQixiOZTnUjv/CAN5cC0gDW/maah6Sz0V0+IWs3yPC7xB7fOWZs4Jik4Zg7XVC98bN7NyJOv7QHuoQe31OlRAlsIR+MUp5kk6IbsZl7cJHmcn1knfb9NLKoSRyrXteszc3dP+U8I5ClO5dW9u94xSqn0ftiQ6E4J7eierE7z9ExCNjIIgPQmJb0+lcM5uBwSYbJKYSzgyXSn6D3VBlahTWcwbVcMMDZXwvhGw0Uoj+BOXR4nu7aDAGDm8caisbtNFx7bRRkV9mr2kt1bk4ibMAiTvQTFhkarrtAC7Tl0QUtf81gVUjxJPj1rtrNdvO4/dctsSwugn0XpI
 D8xtfm5Z
 Ht7e3kdd14NXUomjOTQs+I1VKzz2JN3m/JB2V7qZbwp5qalFCy1MGf9ZsihKmoAewp1quDyjpivikXM0kj5LPOfQDRnhjtgUKj6fFI9iuW8xf5VL7aF90tYBa87ZcFLKP2zyTzMnx8aNZhOQTsAQbnRcip2/L89IkSw2JJvwm8lc+ApCIxkxVhybXr+m7CvyzInjwmFiW1UWz02YYZcld1jv7FKurfNwXzSrdnLwjPvXe9rjyccHKCJLmQ4Sljj2DlVBZ8zZ0CLwCUqumkjTm5mQk5nWFD8N1ciZB/P7GR66LRRuz3dBJPtHSpjwfgITYN2yK5+ZHSzGw0WwnN5tvIeH1oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

You are engaging in abusive behaviour on the mailing list and it's totally
unacceptable.

You sent 115 patches across 40 subsystems over a couple hours.

https://lore.kernel.org/all/?q=f%3Ahui+peng

DO NOT DO THIS.

You are in complete violation of kernel guidelines on generated content -
https://docs.kernel.org/process/generated-content.html

I will treat the report like an AI-generated report and figure out whether
there's anything valid here independently.

--
Cheers, Lorenzo

