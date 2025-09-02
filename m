Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C72E3CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E27F8E000E; Tue,  2 Sep 2025 11:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA5F8E0002; Tue,  2 Sep 2025 11:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D01C8E000E; Tue,  2 Sep 2025 11:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09F3C8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:12:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99A5A84AC8
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:12:40 +0000 (UTC)
X-FDA: 83844652080.17.ABDBF64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE19E1C000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:12:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fha+upIT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756825958; a=rsa-sha256;
	cv=none;
	b=iEPSa70NvNO2hwGxrjW3DCCdFi3lbDcxkaIuh66JEZGJb1MTM/LiTCyUcr1JA5iD7oZMHn
	w9+uI2QyuTLbZrEqSS+wRbTgHC6CaFWkQOPezeQ8tHkpaiqol6pUcgAuCiiaQBx23myFJd
	KB7U1NxGB8/mFneIRyF7hdbZfSQnu0Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fha+upIT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756825958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eU5M79LjKC4+cwkd5Ag8mxW8khc38EXWtzBPf6N3YXM=;
	b=MpvP8SxYeHgoaR2/hJPtLnvhO0tRTOmI5K1Vn3Ng/U+fVoKBSHdug5nK6Lny+6Cz6C7iMx
	7kb0OGTkkJSuT0QtCcM+/KoepFnWdElt4AgFVpKxe4BH9/u078Prkg+IoJ8+qa/mFKqJsJ
	mhO0v0JfBySHsbKyZ/dxyWU1hzU0b8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 310196020C;
	Tue,  2 Sep 2025 15:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB76CC4CEED;
	Tue,  2 Sep 2025 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756825957;
	bh=Qm0MENDGoBpJreb7usssnkk4Erhkc9mDyI1kYmenU/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fha+upITUjR1W0/UPbGo5pqDEYYHq2VFch/hzfP45Cc4DUFZMu/U1HZBKmEZDtzCu
	 iBDx0UtAvG1Se/1xc+9eCfwZyjV/3B8QlHOzcSsDpxMRslOobnPh84NMMkD/x0Dv/g
	 xRaeCkokcz/HiStL81OWybnmfeke8xbUFORD+3qh2QF881mhkN4aMXU+IZJA96/1Sp
	 GT7K7ZaoP9kdQDHPvQM6s9ZrnoBcNhmkS02rGDVOVe7xI1V4vOYoP+D+XPHVNyGzze
	 eB8+jAUjKEOBQZvHIRChGOBN8u5j/+qtdlLin+slLI13vbKI95OGhjjit3j4/QyXxt
	 xBDYlmqE/1jCA==
Message-ID: <1034c70a-da67-4914-b23c-8d006b7611bf@kernel.org>
Date: Tue, 2 Sep 2025 17:12:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/16] pinctrl: qcom: use generic pin function helpers
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
 Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <aLbt2euqYQM5xXuZ@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EE19E1C000B
X-Stat-Signature: 5f9bwhs1q7ffq9o3twjgy39jkqt6npa8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756825958-968283
X-HE-Meta: U2FsdGVkX1/rHjX1JN64FnTWGXXD3bDCvmyeHvY3im7/nl3a13/bmXvzsTcly8Ej64PkXoVyb3Fl4b3KQf8iRSnZUHZSZWI8ls5EZtpCHoh5hL4q0Taq5OmfYncmAzFxOSj4kp4+7yk3v/ZSYLSVdeUxmK+7RwW93xDlWiiv6ehYwPvu7RDSYvxShP6eT7eYfCkMcl3OwOBWQRxYCYLVhIKBq7ioqOuS2a5b6tZZSFPhNVQDuExtIHLD/cEc+5ps/W+Z97drGJe4GIPPRJ5VXsvIle98AYlMZL+NH3zXRr69BQH56Xt8yEmxN6txc+miViYgRS/isFam/kK0RUGk5Sbq7K8cAr6LWB5zXQ2yIxcujsUSbHtuybsSIuNHa1G5RhhcACqcGrWOlNVtbGj3hHwJtZnv+rTYZrFAf4ykY6cYdIARtgNN+UtT10m2vkSSsD2kD7/IMxjbsADtICt2gmDU/jRAGlbxatZgWB1oTMEP6rT6FsKYTn5SPcFM4aQ/c6uwybT+6tdg7w5TbUmzQLXKXDSscf9Xi+I8FH/SMGWeRFfUt34fnMd7qOfg7kKQt+0CCQR0t0cs4ZpRa8IVI4EdIPqEr8TngNWayzPgcnVzb/u9g1Sw3sa4Rr9s7Qu21PZ4tBM7bsjd7OWrrenUfo0VLiRZbhIcTVhrxEVABdHSRjfHRsmx/YrOCTOdsrgnBXsPrK1U1Txh28N4k8Xurz7hypV4Z7sqlh7jC9LSf/+I3zx+Je4TPTveDinwnQfEO7TIVks4fumIu6Hty6QOU1uLkDA0B/O8QQxwMPWP3znsI5AvlPTTltyU6oBg1uiDd9qepo/CALPne1dWBxrF7qeByNqGmBJY16oQdbPnbSq5/tfTtxlccFt4s9cSf0irXDGAAfksS01vB8jRM7Oq3PyJnOak9NHG7/9UR6jQUrHzTNTHfZA+cmTx41Kyq8vICfkjW23zCzj5ouZS63D
 1Cnl4yOR
 qitcJoJxs+zNWLmf6A91A1Q7qZY2v8sm0Fyuh0IG3VAppYUl4/52SAn7GwJlg/k3ij6PWXnEjefJ1VrwIv2EETr5jfa20fQ0eQMssAeCQeH3akC8Z2zjpB0X64AFq4FHn0lFRBBxgDLjxp9xrL/+f0xVF2Gochb4IUhKbJCPAUs+ftk5mYkoj/z5NgFcBefcIPlh+F3CY3P+Icqgawbb15g6LqHEZRGz4/kMqwtZk1vrlScmYT4KD5RF0+Dvkr2TCBdb0d8+Lr3aLA3GioDtTGnKq56dqjtGI7j+XCVnjNfDbQKNBqXoEmEpfXjlZxE0rk2ZZz/uek5+gm7zAxqhzTRJKrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/09/2025 15:15, Andy Shevchenko wrote:
> On Tue, Sep 02, 2025 at 01:59:21PM +0200, Bartosz Golaszewski wrote:
>>
>> With the pinmux core no longer duplicating memory used to store the
>> struct pinfunction objects in .rodata, we can now use the existing
>> infrastructure for storing and looking up pin functions in qualcomm
>> drivers. Remove hand-crafted callbacks.
> 
> ...
> 
>> +	for (i = 0; i < soc_data->nfunctions; i++) {
>> +		func = &soc_data->functions[i];
>> +
>> +		ret = pinmux_generic_add_pinfunction(pctrl->pctrl, func, NULL);
>> +		if (ret < 0)
> 
> Why not simply
> 
> 		if (ret)


Because existing code is as readable? This is just some serious
nitpicking which is not actually helping at all at v7.

Best regards,
Krzysztof


