Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64644F436A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 14:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43036B010E; Fri, 17 Apr 2026 10:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3976B010F; Fri, 17 Apr 2026 10:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09A16B0110; Fri, 17 Apr 2026 10:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4FB6B010E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:00:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F353D1401AD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:00:16 +0000 (UTC)
X-FDA: 84668207232.28.0A4E34E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EAF9718000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:00:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mjWMdGUU;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776434415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8arHXLSPY8YG/lPARRC97g447VNnxztFZlOKMb/mUA=;
	b=xHH5N5POagHaJJBVqMm458NA4Uc0Qx4euCG82TdA/CIOofHZ6k2qBK58ivK3CH4hWbUVyq
	n21iCFgcdi2033x+9pOOkJ052cwV+C3NqPSfsGkURQhOscdOV6viZ1g8iF49XdsQ/luVsI
	lw343zVsmhKjj22v0icq6MLiY/+LVEM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mjWMdGUU;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776434415; a=rsa-sha256;
	cv=none;
	b=2INlgOecu0QZVYyY+oXKckCdv9tBgIqC/Swvt1PNiQyWERgc8HSOvfuOAQg7dDezjb8IsP
	8HPCzIYEdHc7gMKeUSA+hdowdIxkjXsSWBW506sa11odOW1staieHB38vFxP3vmgQtAvrg
	nFkanwCT2WZreW/MYcI2D6qGCeq5Naw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9259A443BF;
	Fri, 17 Apr 2026 14:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA9CC19425;
	Fri, 17 Apr 2026 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776434413;
	bh=raaiP7xTUZt9W5HYdV3r9B+bLOKlUxJbEO+s7SeDAmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjWMdGUUNYk0TmEBlehXA6BS8dNfVhMFqczXF2N4onF+NGJAdUdkIA7LumxB1ifjg
	 D83CP65pYewn6ZJVUGd5WkCGUgem5+0tT0CuYh+JvRX3A/1Cw/Ym5dXwx2Usa+cZM1
	 61q/4EYsKPML44nYi/Vis7AUHSAKGwD0MGUEShsQq4uQvqYy5zxgHJI0k1FP83SxiY
	 KcQ8j14T6Cwg9kIBH8YlGnEL8WQtVdukR30QHSAQju+5UeS8X3v9736kiSkRw63WWN
	 v7NW86Ov5yQslnkhzM/pW14eIGTNXm3BCDf1U2Z2x3gZVXmBkMgN9ZXp4XKPX7hYsj
	 fuYgjobGY8ZPw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Fri, 17 Apr 2026 07:00:05 -0700
Message-ID: <20260417140006.78938-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417042701.4077-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EAF9718000A
X-Stat-Signature: swce5wjrghqxuppw8ruk1m8b5begpdsy
X-Rspam-User: 
X-HE-Tag: 1776434414-777927
X-HE-Meta: U2FsdGVkX19GBTUvDcRAqtbQCPS4fqwGiG/MFpRm9Ljq+F1ZyrV0/mpNsMjo8a9farIzIytwaofyXjLxgdP8hHYSl+lixQKKvoDaT1h34nwLht4PDAfUag6UHFPtbMp2w4xDdFHgepKZYKMnbZwj+46pj3XZW45VnsiA5tiA8tDBQ7NMFk8/CoskuMn86zxiBzASK4QkASCoxOu1qjHAxR7ltVS/hTtlY0oitsMrwyWDCY+DqWhQptu2tgNcBZXsnJuvQ/WwFCa+kVc8ahIwFgiqLNYTqABYkOvGUvHnFP/NNMoBGklhRQosBrcV17to9G9hPgnPKm4eQhmIC7RlpreU3JMDyOdsKISflFa0Gl/k7vc6JZB5UDQ7/1WRP0PCxCbb9r/C5i17lDQ6LfSQo3jC/xdrkQ1ATTU6SW8WUOuwEZ+mHyZstETF2Oy+htOI+OFfLqOHGBqPmAcWNyGBThS1SJI5Q/H/LGGoRKaX1GK1OuR+u4E3VCf72usQA2IzHrvsT4zaylSUCnWOvPkqrNV54YsnMSksEOZ15zQ0nLCa1+/b5VjA4p93uydbfswwy1aFVhITIDwRjt8BmfrvqL8f7VeL4fXT2NhRkOmoaFRQkZ2+KFA3oZi3InN9zj+M7vnx+qo7pi7C40FdizKzLzU/8nYkGcBMc5qXZw6MT7rBpPfr9c8sVOZRY+KeRtl8WH+FHSnRo4AJ3HhyhSkIQwIExL9InukkQlYEK8c5baoWfNbrdKbNz1RUxskh86MIh1erdi8rD0VcR5jUSC0KfuT1gN+4uomVK2MbcgQ3Y+UixVyDNMLYJxMvjG/U+5VmLSaOm6dtptDoO82JgA+YmJDQ/TNIfaZiZqGz6BOWjBdqIhvOfRq5jIRB9AqKyodz0Wrd3w0wVouyTI8f7OEGcpboTLv+62mUElVRySTmbdCdaz2jx2iUeKMOUzhLunI5+IKFTyobHTd13xUVimR
 wHZHzZs7
 72wjuRLpfjQSIA0kj/LBZneAC+lvKWevswJ1zJwq92rIriviB6Qsvmde+v2JYq/s6aoEdKSn5ymsKivVj43KfJqeo2oh5MenvgmeAZDQFN9YmdvJj3ickFCHOY7R965EZY6Qr24osFe8n/+iTI1WSmy9WkRb896bR+pXOjuPDOszLC8IZ4XQg4JsItMRYufQcfeAXozgf5xEFFvRoBU7H/k5ESkIfQd7YEz7ksm0QIs8kboB/cwL5szgoPHmoSJf9ITvZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 12:27:01 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu, 16 Apr 2026 18:12:28 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Maybe I suggested too much...  If we decide to take both my suggested commit
> > description and the above change direction, maybe it is difficult to say you
> > are the main author who should be primarily responsible for any followup issues
> > on the patch.  Of course you will still deserve to have credits.  Maybe
> > 'Co-developed-by:'?
> 
> Yes, I've decide to adopt both your suggested commit description and the
> implementation. Therefore, since you've done the most of the work, you
> should be the main author of this patch.
> 
> > 
> > Meanwhile, I feel like the fix of this bug is taking bit unnecessarily long
> > time...
> 
> My apologies. I have had limited bandwidth recently.

That's not your fault!

> 
> > 
> > If you agree, hence, I'd like to take this over from this point, and finish up
> > the remaining works for this patch.  If you also agree, I will also take the
> > responsibility (authorship) from you, while keeping keep your credits with
> > 'Co-developed-by:' tag.  What do you think?
> 
> I agree to hand over this patch to you. Thank you for your help.

Thank you for generously accepting my suggestion, Liew.  I will do the
remaining works.

> 
> > 
> > By the way, I hope I'm not making you to get me wrong.  I'm not trying to steal
> > your credit (authorship).  In my opinion the authorship means the
> > responsibility (or, who to blame) more than the credit.  Putting right name to
> > the place for the responsibility is important for the long term maintenance and
> > evolvement of the community and the product (Linux) in my opinion, so I have to
> > say this.
> 
> Thank you for your explanation. I understand your point that authorship
> implies responsibility, and since most of the core ideas for this patch
> came from you, I fully agree that you should be the main author.

Again, appreciate generously understanding this.  Please don't forget there is
no change to your credit.  Without your contribution, the fix was impossible.


Thanks,
SJ

[...]

