Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E340CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FC88E0009; Tue,  2 Sep 2025 11:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826458E0002; Tue,  2 Sep 2025 11:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BB38E0009; Tue,  2 Sep 2025 11:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632678E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:38:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6A9D1DBC30
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:38:40 +0000 (UTC)
X-FDA: 83844717600.26.F13698D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C03C180016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:38:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zh70MZgO;
	spf=pass (imf06.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756827519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7uae2n06rSYI5IcLTSg8p1le2edkOnWy0mpbOpJX2w=;
	b=CJKGXBctbZbgc7n/J3dpgVGxMItmgzcq1qDkDwkcH8c0V6iSqI0wpqheAUsLQaj8k/YjKo
	zMzfHbAhz5wtpkum08J+FjZfuN4AVbOvXNYVPDQLLw5kpEpOV/oXxfhLsfL3pc81C8edOJ
	2e7Ah+Z6yqWaNwxVMNpia4mzwOdyHpk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zh70MZgO;
	spf=pass (imf06.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756827519; a=rsa-sha256;
	cv=none;
	b=ssUZ+Vqgxn9dYMfvbiODgfofoHJ+4LxwCDMoZHj8e9ZcYAGHKFl5XCCahi3uWEIcpdLCtE
	oWlOcJA+OXUfhyRC5BuZvljMBiNlTSZwZkIwWWSp067UDvdbHxXb4ue6bkKRsJZzZTw523
	fBGpBkkVhkF2WCr70PQ8TXtBvxtC5aU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 466B26021C;
	Tue,  2 Sep 2025 15:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DD3C4CEED;
	Tue,  2 Sep 2025 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756827517;
	bh=v+DuYfBUiGbE23dCrrZocBSYiEeU9i6PmQBrfDGbt+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zh70MZgOxvxIxj6UMkzT706dj4grAuw+KArw+LrHivUyAmevwHRbmzsy8tdhtqckQ
	 ctnQW14LrxH7lpGTWRcPysIxgPyheRuMy9Tnoya1qMd019iqz8ogyz/ZzskmCsRTY4
	 F6vO7VOs9YxEPQ4KZXd48LQZlpVHk12uvjES7uMNnLSDH8kOAWc5bmmaMvxzgl8PYT
	 QFuBANh8pcFrndFTx8KlSmz3GDHmSM2T49B2D/EK+RnKYtzD4IBBt8MHQCCaSTZdMa
	 hyyllZ2BaEg7ss7qp0XMJFqiosZEUGgYOmQQXbvtOguQ5wDzIV/4TdwKF//sOzHuI/
	 Cne8GehwJZyYw==
Message-ID: <5c9f8c2e-6785-4464-b2cf-f8a6aeec42ea@kernel.org>
Date: Tue, 2 Sep 2025 17:38:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/16] pinctrl: qcom: use generic pin function helpers
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>,
 Linus Walleij <linus.walleij@linaro.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Alexey Klimov <alexey.klimov@linaro.org>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andy@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>,
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
 Tony Lindgren <tony@atomide.com>, Haojian Zhuang
 <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Neil Armstrong <neil.armstrong@linaro.org>, Mark Brown <broonie@kernel.org>,
 linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-12-bb091daedc52@linaro.org>
 <aLbt2euqYQM5xXuZ@smile.fi.intel.com>
 <1034c70a-da67-4914-b23c-8d006b7611bf@kernel.org>
 <aLcM58IEH8hGYLnx@smile.fi.intel.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <aLcM58IEH8hGYLnx@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C03C180016
X-Rspam-User: 
X-Stat-Signature: qprndu831p9q3aruu1nnju4yduwhck35
X-Rspamd-Server: rspam09
X-HE-Tag: 1756827519-321293
X-HE-Meta: U2FsdGVkX19sLXLtsKnNVxGKHExcyfRV00vwcrsFKaOroxqM3kuBRzl7NrYu6TxiIkY4eyoN1k0+/pqp7bCMcOQznsR1dluJTbGyhT2dqWHVm4MIgc4HliCNMhzVjjk5rB74X48v1YjzlERBLw6BaZQdgTJFIhRAHOSI+4Vlov1PG6F2s6Z2u+PjVcd0bDshb1+EGnFRNPOgaVYVOGQzRVvbmLyirHG8/7oLqIwZ8N9ivf5ShNbxSdamxA/p3O08tSGat6VaGaHN3n2a52ZAPSjY23F89zRHYVSCwjA5FpLmn0FYnLUBSS5fRPcwDr4xycOmPFOvjw4TgFrnHdtHiXefbbpDnjJYwvQ229f0nhkqVAfpFtg1kkP2Xp6/1r8voq1D2VCU0tQGpDLUj9Xl3k6aLIEpN2aS5kk6JdwZIS9FQwme/MZjqWJmmitudh71fdMueGA7yIt0GEVW3jsEB5gAOp98v7KMLWqXMA09SebuWyBE4LG7z7dsHYO6MYja7N1sn7492BvKt2aECoZpFOqtp5cTLewQyjLWoh4npAzgToegzdWkQS3D8cY9KBkQUjIb2zLM5EzcVul89Z3YzxW3WLd3CYqNOOEJeaf/sgdF4ZgkaeqaYm2rib9WtxXUm5RqGviA/o8+QXowPFcbrzJ+ga9jlT+jIcEYUbnQpaKWS32IS5DzuQmnUfRSXhQGuKkkp794IzR39e37aKlJg1ohn8Y8Rm4vCd/znqIdfi99KPgtCiX/Ifm1kMdzmQ9z3rnyhNp5kZuFjrfa7+M4RXHRN+CukELLg1y/h0VwD1beHxcwNQKi2cfr1xHz0W82109TTAAajNpAQ5U/OfbvCM2C4V9uDLofQ7R5x0BvbHx8QoNs2qhKFGihgOS5ctMLu2tRR5oh1un2HHUDsPeEgfQzoL7L0wnE9w0zv/KItpV+PEiBMl54BUcaE6Pd0F/X1DxULACEtp7K33xREwY
 m4GUDLkq
 GzRtO2CAJIhRysn6GWSrP72H9cLtPOE8XLfTKkY9pYKv4HxIu8FetI5QdQx7DVyhhHFCGkES2vcOp+q86ylsCcqKY90y8Q6fiboWpM5L3VOWTEpOSLljmGloAo97wP/4HkZDjCS1qnMEBmztS/dnr5MJkLFQ+JHoe3t8Ff2eMDufVojeRa8YX56Wa5WzneqBLOufkrRdRYhZeePf1Lruttw4J5mzyhNXcbdNHJFryXTwZCwDFFqQD/wGJufgoqBPS6P7Hzy562f9HZ0jbziwNhB8WIrOiWdY8lPM7VJRghTInZJnl4aQTUJMQy57TGRM9zgRre1HeOTDsraln3iVxIe+rGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/09/2025 17:27, Andy Shevchenko wrote:
> On Tue, Sep 02, 2025 at 05:12:24PM +0200, Krzysztof Kozlowski wrote:
>> On 02/09/2025 15:15, Andy Shevchenko wrote:
>>> On Tue, Sep 02, 2025 at 01:59:21PM +0200, Bartosz Golaszewski wrote:
> 
> ...
> 
>>>> +	for (i = 0; i < soc_data->nfunctions; i++) {
>>>> +		func = &soc_data->functions[i];
>>>> +
>>>> +		ret = pinmux_generic_add_pinfunction(pctrl->pctrl, func, NULL);
>>>> +		if (ret < 0)
>>>
>>> Why not simply
>>>
>>> 		if (ret)
>>
>> Because existing code is as readable?
> 
> I don't agree on this. And Bart explained why. So, it's an API requirement
> after all.

If pinmux_generic_add_pinfunction() was returning 0 or error code, which
I assume you thought this function is doing, then your suggestion was
nitpicking and existing code would be readable. Requesting (ret) for
such case is really not helping.

If, as it turns out if you looked at the code,
pinmux_generic_add_pinfunction() returns non-error for success, your
comment was even wrong.

So either you are nitpicking which is not helpful or you are finding
fake issues which is counter productive.

Best regards,
Krzysztof

