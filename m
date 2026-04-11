Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC74FF3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 18:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244546B0089; Sat, 11 Apr 2026 14:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5636B008A; Sat, 11 Apr 2026 14:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AE66B0092; Sat, 11 Apr 2026 14:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F08CE6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:27:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83644E3933
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:27:21 +0000 (UTC)
X-FDA: 84647107482.14.EB3DBC9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA67E40008
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:27:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mlw4RIO2;
	spf=none (imf04.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775932039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hItD8FmmH44C7lkQPshN1XFwsXbgSGscwro6+HDM6k8=;
	b=UUunkGxFnSJInS4RddWG8RX3jIT3ssbT9dQOp1r95mkox1Fd5J2OSecqqdipyGQU7PvU/G
	ipRjruI7y+J0oqwb0zAqPV13dc086o/Q1bYwjrxDJWe+QhDA2YcISfQJG1PPzZtV2Syh8O
	Obukhdttvj14XDffdytMy5aBNX5xuV4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mlw4RIO2;
	spf=none (imf04.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775932039; a=rsa-sha256;
	cv=none;
	b=1fpCIKLioTRv9zZK0rQMaM5da3g4c2QJVX1/BhYpv5cDOl5uFqpMwnTieFjDcU+/jr61rk
	IFyqWfbHQcAI7iGfqEyrpF9U2Qo9O+o8XFbszziYqt77+chXW53DgqUwCoNEciPAfAd9Ji
	UFl+M9SOD6pHxKSfoCaP08qhrmoFyfk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=hItD8FmmH44C7lkQPshN1XFwsXbgSGscwro6+HDM6k8=; b=mlw4RIO2HlunldMU4GbKe5InnS
	kC48TU3cesNz1Md0KbUMo+2ThkJ3PrC5OuZgjbKNwITaGeJOFg/Il5kDexKIcQpECcXCqM7aUW4Rc
	SXLKiNxCmDfBVpnsDYd0zDtlTdqxQFLGN4AgzpTXWE/jxeMBemYMTbUqXq2k+9tYVwaYAJHc1qBLK
	ZxURLiinIc1aa8r8llkTEeyqO/TMvm73C8mDtMbEn3Q8YgnTWO9NDxA1+LEGqGbhAV8JFUWj7LzW/
	T3cL1TcK5y8mKzMInEjqhWjmYFZ8/lqPu+ZaJekzI97Tm9i50/n8XNv4T7Fna7zeD3B442eodG5oF
	hlMnPQXQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wBd34-0000000DiEo-47E8;
	Sat, 11 Apr 2026 18:27:15 +0000
Message-ID: <20aa1471-5257-4913-ae46-7b40ca0aa128@infradead.org>
Date: Sat, 11 Apr 2026 11:27:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm/damon/maintainer-profile: add AI review usage
 guideline
To: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260411174906.79491-1-sj@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260411174906.79491-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a9wdrorpp1hweh8pa6dq4ubkthkhwk3y
X-Rspamd-Queue-Id: BA67E40008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775932038-182479
X-HE-Meta: U2FsdGVkX1/MpCXvRQKGQeCCw4untHSxqhTVff/pX99A5jXutiF44bk9oKLXXYhxm6DpFDbebvkx5gqfvq0bM/jKyHrfFzyf65F+ukrl0xKmr36syuVpcGzbxgpUbKn6029/QScSOmfZUtsHlpWaOUqJX4+CThnuUnQYfKqZT9as2qdV7H7j9DudKlnYZqCH01CmGiENkU+F+g7JLSskZdyLWVVa1/aXaJlO95x5HsBc3egTIv/z5hjqRqFHR1rfwY8Vujwrh/dFbiiOTdcaLC76SOByAaanhQukxoiGEy2B0Ex1DiGG203iXvifKxRFYniXkdAzmKyNYgCd0paPqz1Yzp3GqlCvzM6NNCBZKiCTXOdI/wnoXy+5+UBLiPRmm8m8eHA5OBRs9Ib0ymd/KyoXp9yqWbvPNYYLXRpJrKnelWEXsTq0Mk+88xUgbk9XaPbIYJQgnvkn96sHT362CQI1UCMZznVwSCfuTWhfO/iUDKpvZbRdlBAV53T5kpT7Mt8Z9Gc2MdUJlEJDhiK1sckGl6Mt3wNr1Px+RQLUrr/rU3oCfUxLfJwvOB0+//cy9DiTUgBEvKHoBsvK9FwP2YNmuekqsUlNyQJ3KsO/eVrppdqIEMj2ADRxnjpJil53+zCcn6T3AW4HEEymf2VDPZ/kjyWJPPW21BQUobMLKZUp8kkTshGxyW5WxuV0b7hB8LfbCzoBIXXF0mG0jmffjkkE5+44hNAMkYFWD2mdmA2HajAGAL+CIfyyMbjQYwBva7nkF9X8n9dSAb10M3xm0zqpW9P8P2P2c4YpY9JPA+LeJnbdALFHjqnYAJPFH8Yl2XqOkqJvNZxyNERV79yc09Aqyn2MepzHzmZyP1jCm/obtm5K8Btb9ulxc1iGtOIJKpuyS6k8hxsKqBK4z15tg2GO2eFxZbiseJJlebi4sgMChkRuF+srBqMkubXGtBIEWfd0mgcuBzLSBvvjKlw
 SbOPtnyf
 IERBpTD9cGWGjtajrZg0IdqLr7Yqfz+UsGGyODKX/kLC6+nQqJMIOg+M0m0HjEyivOoRgNc4ePymfG/W6AwlTRGi3pGRiGfhFaP3nqm38j9gb+BoNQmBs5ny3cF5GBiuhit8JisHLSXuQTsdb0yogn7vza4t01k2NqOIvVc/CDHj024LoqLHQ5tbsZ9CR9FmgKzQabvfn3krky8oYGIfN/5HcJivj/aUZdn7S5wHY+yinxHJjNLoqpfd0rZ8nAMdfrw61omvBwG+TxlELl12m0XkM/oofdX+P3+P/iYTDEWAhdRWCzVim/IUrXu1UNSP5tMn1GPqfkEhYVtfKtPetSReXLzD0bXIMaTzH1NcOxBYD5KXxBXJbPWPUyzz1NXPmuDk2Q8NZkCDOj5CbZ/14z3iKCt8r6EAsaHD5jsnG2Wgrd3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/11/26 10:49 AM, SeongJae Park wrote:
> DAMON is opted-in for DAMON patches scanning [1] and email delivery [2].
> Clarify how that could be used on DAMON maintainer profile.
> 
> [1] https://github.com/sashiko-dev/sashiko/commit/ad9f4a98f958
> [2] https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/maintainer-profile.rst | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
> index bcb9798a27a86..5c23b1281c50c 100644
> --- a/Documentation/mm/damon/maintainer-profile.rst
> +++ b/Documentation/mm/damon/maintainer-profile.rst
> @@ -100,3 +100,24 @@ There is also a public Google `calendar
>  <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
>  that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
>  provide periodic reminders to the mailing list (damon@lists.linux.dev).
> +
> +AI Review
> +---------
> +
> +For patches that are publicly posted to DAMON mailing list
> +(damon@lists.linux.dev), AI reviews of the patches will be available at
> +sashiko.dev.  The reviews could also be sent as mails to the author of the
> +patch.
> +
> +Patch authors are encouraged to check the AI reviews and share their opinions.
> +The sharing could be done as a reply to the mail thread.  Consider reducing the
> +recipients list for such sharing, since some people are not really interested
> +in AI reviews.  As a rule of thumb, drop individuals except DAMON maintainer
> +and stable@vger.kernel.org from the recipients list.
> +
> +`hkml` also provides a `feature
> +<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
> +for such sharing.  Please feel free to use the feature.
> +
> +It is only a non-mandastory recommendation.  DAMON maintainer could also ask

                non-mandatory
or maybe
  This is an optional recommendation.


> +any question about the AI reviews, though.
> 
> base-commit: aeaae01df7d17b5742e22b65b06f666ddea76816

-- 
~Randy


