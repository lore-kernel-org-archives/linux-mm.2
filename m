Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED105E93807
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 21:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4DC6B0088; Sun, 12 Apr 2026 17:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E659F6B0089; Sun, 12 Apr 2026 17:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B836B0092; Sun, 12 Apr 2026 17:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C18496B0088
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:37:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1560D140B4D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 21:37:31 +0000 (UTC)
X-FDA: 84651215502.25.8ECBDE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C171180002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 21:37:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4JqhYPE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776029849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97nfrv7c5glKG7PeoL8LC3HBUjFov+7hkmeHlrAwiQA=;
	b=UDWISI1VkJ+Fpg9/4OsuWv5bHXXa4lyNofc7RzvJmia9noQ+ZkA9QFKad6sGdJERbT6aQH
	lD7sNOGGFW+9xKsuXtynHoL/l/FZBYmGkLn3oV119CWtZpmDZ11443FSvIbrt5IDC2/XZA
	vkZ0rw2/Rk5Zl9xiFWTtmlWap3/llPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776029849; a=rsa-sha256;
	cv=none;
	b=BgqqHOJZ0eM31P8uJcWbZep2CDsHl4GRMaFx0EcUi9Xm1qENfmBKmk5ftO6Wb0ThExhIp0
	ASlz4fQ1l2kzHVXzWwuj6Fr38cB7CgUde4QWuAwEr291AnuKF05hSSetk+AodX91TIJVzo
	apNGFg3f+hSgwhBlohayTxXY7F5m7Yw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4JqhYPE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDD9A60172;
	Sun, 12 Apr 2026 21:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259B2C19424;
	Sun, 12 Apr 2026 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776029848;
	bh=xVt5Bhefg7H894rjV3Pjcx/a+7sCpLUN5Kj1JbeDq3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4JqhYPE1W6SVq95v9wml59sFT3uDnbcCblooAg2YHv+6IWa9YtylnfZi9nx8bcX4
	 Ag3hff1pjFKdEAmTTIiNCYrdenGRVyGgjE1Ah/1Erf4R6xCiN1IMkhiNi+/S82L0vR
	 ytdn1w2OxyzC+3NNT1WSg3+OCmnqkltvMMk6UmIRyTJOBaLqxtWxqiXIpKD6sk8IDN
	 vd3NDipLLitfrh4Ul0dFyaI3xabkU6mQOEh83Cud0KsxHPJHiUyvXpYAmIPFqLguT9
	 z6R9NhhLG/rwbcYbS1E0DVFPDMXG6ciSRelm0yr3xZfouSvR3OV0pz6QHIerzoidyD
	 kwvW3io7ZakIA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sun, 12 Apr 2026 14:37:19 -0700
Message-ID: <20260412213720.89145-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412190455.6685-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C171180002
X-Stat-Signature: xtbteg1ad84hnet4dm5n5d3xf4ap8zwa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776029849-539336
X-HE-Meta: U2FsdGVkX1973/iVIlSoXwEAb17GY+zZeONbFYK4yQQGu/PlKq1Coc06RW2lJ4IFx6AXtwWrsow3bsOmyZOsLUzZFj9y/3DOrUV/5kRDkD6If+VBmaUzfqJ57hHdajsZLEuA8NQcIZT19GBObif9P1R3L0qz4dNXFJ6+YtqZDe3P4Rr3U7QhYw3OVcgbr7lCdre6beBHqcO0tX/+0LWOn599QflPmr7dfFcIQZvNVsC2IeoDXzA0NEUnbT139XjsJwxA4pcybByzWnFhJxRSqkVMe7B7k4uvWOz6vYiK4ucmyA3XAnA3nXN7OfjtNjGHjru7Vre8O8+EDteJVzGlui6iojRCkKNeXQhfJwmj/7hjdOC3X1mCQ6gM24LAiihCudk0Uh6mRtqkPBRxjm5Pu3/Q4GykieY4fqrDYQ7/Fu5bKBP5vW9xLjS19UrafoyH6aZNiHyPSe3n9W8zBQ8O/Uo6ABeOxuGxn4SZYqDGgI39fa+LUVllZtF7HgaShKQRu0XAMmhWyiUS5S8wioEXaZxEs8GMb2f3adAHaczSquQqSJ2EgVkICk80bODoLibWFsAVakH64TOR9ofvl29k8co75XrmQf4Gc77xDr/NOxhiWYNeyB0P+L8pQKJzvYTsAFeXWt/iIfIznDPUpqTQ8EQhs0Dj800/2gcirjeoZY/ZbwDpHP0IspJjBocfNR27hXluYI2oW+Hur8DnjB1L9wbaC8bD283G04WfzAK5ciyOJAsb5cGRxRxX8R+9/h+G/2mH/Du7KCvpIizZs2EGj1bZqcT+BTuIOj99aydAKPgjONPfcXXdvBGI/BIl0X/PSK++QlvhlQHZucnvO47rSSIrvB2XUaxzckBKxedE545xw1w875Rl4eam+3JJHQjvzUzA5U05HCjnxpskyg6Bpsyf7L11CG9j1DpTIxtkWSMVxXbrkCKy/Vf2qjUAuHZsTZliJx2TebiEPS0TeB5
 w2ltFU4w
 C0//upwVDfymzb8g4Fs/xiKZ7ui431JuOtD0ssvKTFtbzLKedIYtuCr5CgcVKdJM0zDujgWQ4gt341sjRpblCO+FtsitZfxgZEBiQ0kDlGZQXJncvyR2eN7QK4DFJs21DmT67rkSRFPpZ6cUafU1zUyq0B+3b/qhQgIS4DZxKJhSvR9ZWo9Cox0XW5njb3L15H56V3bIm0AMFTXOL6cLl3LihoBiWoB4rH5U+XLaphnh7kwzUglxsB2kzEmjonJs79KV+heeuWYSFpE7jNXt/GjHYbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Mon, 13 Apr 2026 03:04:55 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> Thank you for your detailed explanation and for being patient with me. I
> sincerely apologize for the confusion and the extra workload my unclear
> communication has caused you. It was never my intention to hide context
> or game the system; I simply misjudged the priorities and failed to
> provide the full picture.
> 
> I want to continue contributing to DAMON. I truly enjoy working on it,
> and I'm grateful for the opportunity.

Thank you for your detailed explanations of the context.  Those all make sense
to me.  Also appreciate your will to continue the contributions. :)

[...]
> > Next Steps
> > ----------
> > 
> > So, what to do?  Please prioritize series B, if you still willing to do.  It is
> > ok to keep doing series A, but only as the minor user experience improvement.
> > Clearly explain the whole context you are aware of.  Don't Cc stable@ for
> > series A, as it is only an incomplete fix of it.  The fix of the one trigger
> > point is just a side effect.
> 
> Yes, I absolutely want to continue contributing to DAMON.
> 
> I realize most of this confusion came from me misinterpreting your words
> or making assumptions without asking. So this time, I want to be
> explicit:
> 1. I will remove the Cc stable@

Please also make the description of the patch clear.

> 2. Since you suggested prioritizing Series B, would you prefer me to
>    send a revised v5 of Series A now, or should I wait until Series B is
>    settled to avoid more noise in your inbox?

Please work in your pace :)  Pick whatever you willing to work first.

I'd like to avoid delaying series B too long, though.  The bug is not very
critical, but better to be fixed sooner than later.  If you have no enough
capacity, please feel free to hand it over to me.

> 3. I will focus on Series B starting now.

Sounds good.


Thanks,
SJ

[...]

