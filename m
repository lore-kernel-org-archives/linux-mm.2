Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D134C606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaCv0r6x
Received: by kanga.kvack.org (Postfix)
	id A60166B00EF; Mon, 16 Nov 2026 21:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10C16B05B0; Mon, 16 Nov 2026 21:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926646B05BE; Mon, 16 Nov 2026 21:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 778BF6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:11:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E489C1C34F9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:11:10 +0000 (UTC)
X-FDA: 85442983500.12.01D172C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 59A571C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:11:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaCv0r6x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794881469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIU3JLNWHpOdjhC1oWugb/pA68zhrZ3nKPJMqP131yI=;
	b=ZSm0LMtradfsa1vjxrbbqhUG3IuS1GFJiTdAlZ9nl50/fzEhZf7kpfybjWIj9FUgERAt34
	dZy1krUQ5/1bpor7E9rGafCNFdZVtC16aVwvlPwuJpptbkq970xMhFwoLKDic8daUFNUkr
	ObI7xlp6F8vc1mFr3natGE4JRp9eHkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794881469;
	b=yKW09xCkPLqtJ7DIG5NPLjP/eS+Ddce6ubFqDYiNmuB3gkA523cDYOYqqoj7wp/k0BjrTe
	/tvyKLw8PkrOZWpIBKd4025SdYu6GgNvo/w3K7s7VTUEOQv00AXNz3+xxhMHoKJ4mxMsTU
	IHOoHyGi+TER2sweFKff3MUJrfAvjOU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaCv0r6x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 860A760F25;
	Tue, 17 Nov 2026 02:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCD01F000C4;
	Tue, 17 Nov 2026 02:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794881468;
	bh=OIU3JLNWHpOdjhC1oWugb/pA68zhrZ3nKPJMqP131yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaCv0r6x0VGJLSAZ8LFq+GzvYSLaiP72qGaZOkYrzPNMoULqActDR/Aa7+Tj3GBUs
	 RNdlgyuNRW29fJnli8IXGFb6reLbapmp9cwiRSXrsPdJSXbuLMmEowGS2gjtQr4xlX
	 yqaJdxmBT63IKgHHhI2UY4yfk5EAipfdiKAi1P9ZFrdREXdUitqiDOifb2jOJKYvA5
	 kbAkJtug1feq9gVaoFxEILGPE0ScTUXmBvU+hM/Mbq+flHarDD8rorfXrsKDOdcMpr
	 7dghR6L1ao7Rum25NfXLIr9FTLRdGFuZqqTHAm8gDvNUtxwVliePyBZZpslvvW//Jh
	 IE+COOfIQ0WRQ==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 2/6] mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
Date: Mon, 16 Nov 2026 18:10:54 -0800
Message-ID: <20261117021055.110011-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-2-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 59A571C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wx3yhxunqoijp7mkd4sq65ffhfa4ciwt
X-Rspam-User: 
X-HE-Tag: 1794881469-637586
X-HE-Meta: U2FsdGVkX1/+lqmem8xvsyqTmuSvyBSaOtFkgqp0VGRU95G15WZCn+kmHEMvjvg3qvWaMTTIQgKUnBHs+QNJHP13+Z3blNungKRMwD/zVirOB+v2oS1hC5Mx9MNJ6U4wsskyesULZgmjCdl56DzNXYI8DgOj4O9KHOv0E4n8IAU51ozZlzWlu+whyBRAAziTatyNRAEAGLQQCi/OXBx2BmkV1Zoi2ayiQ1hNN3pi2Rc/kQEn86X6qCDRIWkZh/YoIii2dQF3BKgEvp3puZ7fgjcIPVe3gAxivMwP7B45IH6kXb2fogIkuLWaxaqr0YnaYEq9HI4Du168JAixOtIB0WOM5RZPER814SYKxqe9djwKiTVAQql3Jg6BGxkmgS36PuBKaAM3w9uWzLr8gnHEZuWE/iM7PDxKCWB7M86mvzwzpNR1X9jtcA9mjcKmI2g2MTlXzZ/NpQU7O7Xh3phQybI5Z/eBQYL+IT8zXC+bur0F4x7PyPUWOcsqGHZZcbfyD2dgPQ4UQ3h51kbGE6+f5ahMo/HI1Q8Of8+Vd8lt3KifTgVgCBCBVcHOpfFLfIcjbYgybT31SlE0esRk5PB6buOD3LVzfSQz0mWyVvVeRbcE9+DaB6aoNiuFok9Gv0VjJtm+QzhVj8SQiMMqp2562ct6Krs5jo219pb6M8Q94i/gxkeUanaVohHrVPIn4q/n3cdmcR+bV7sPsDS1ozh9R5VJNMAUFhLoWu1DNtwocvMAKwu8cVhbGfFx/ZHIJRpvCCD/JNJ6ChDd2sLP3/SF4pOfTQnwRuRNlvLL4038seNGHA0a+RWlSveTZOX+UvCiuoiobbDcXeciv3xadngj30lj/7EqPbtiMSF6EE4/RUeD5DZSnrplqm/xyRMDt6MDNq1hBY6bkmmmET94e29lPtoReOlEELZon3rly+5SpGDX3xbgqdHsL6qocvONp+32np9x9H+ezrbQT9F9lp3
 IrWBH93Q
 Ej24kf9I2GL58UOJnNwSxdxyj75TcEWZy4aCUMAlaNfFX4sS8aYKO7hArALb8gFundq1A/CQJ+27ka940SAjbtdP7qOY7goyaxIbMtml8vB7/HcVbETBkcyCTJ9KwyfuN5CThQDhzmMR54NmHndhQ7RHcr/zPkvOCghjcYz/hmmH9DRC11VkbhhXGH/6Bvc3i6RJu3v16y+tVwwok3vtwdHGPCa2pSJiKYu+M0I9j7jO1KMaZ5+X4usPDNNjNKiW/VxIzqtfmtPucETh1cG284Mb/6DX8FF5m0+TrM4m2fu79dvEJNY2TfDJ4YyJhzRmI2mb2tte0tXFNbqeqkNYq3FuGGEmVNqLk9Bik6fklntYDzQo60gMWmY48C3q1R7mKjXpZwSmH2/kOPZBW7Zsr9iYlOA6NzkJEGy3BDkApt/7WCajdOLEF3EVqKtAMr0asFwO4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 19:10:05 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Introduce a new DAMON sysfs interface file for exposing the newly added
> DAMOS stat, sz_ops_filter_passed_last.  The file has the same
> name as the stat and is placed under the DAMOS stats directory.  Like
> other stats files, it is updated when the stats are refreshed via
> refresh_ms or the update_schemes_stats command.

Looks good to me.

> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
> ---
>  mm/damon/sysfs-schemes.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
[...]
> @@ -485,6 +495,10 @@ static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
>  static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
>  		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
>  
> +static struct kobj_attribute
> +damon_sysfs_stats_sz_ops_filter_passed_last_attr =

Seems the above two lines could be in a single line without breaking the 80
characters per line limit.  Could we just do so and save one line?

Other than that,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

