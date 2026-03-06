Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74136F0180A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DE46B0005; Fri,  6 Mar 2026 03:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A556D6B0089; Fri,  6 Mar 2026 03:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E826B008A; Fri,  6 Mar 2026 03:25:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 840EE6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:25:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3246614048F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:25:10 +0000 (UTC)
X-FDA: 84514953180.23.DC05183
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf21.hostedemail.com (Postfix) with ESMTP id 624731C0008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:25:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dVK42jQp;
	spf=pass (imf21.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772785508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hwjmq5zFDGgRXaXsLSL2S6bS9/O6gUN6TgPSpphuZE=;
	b=uNfhJdMHhByLGsPMEAMqMwzf85KpKN1qrL8yUEpXpGi2ax296VAKgjogDVe6HW6IcQUixx
	zVnwtCUpbVQe0/OQNpZ2ktwzwnbJLvTZ7Q7LZWLrOi0OnQ3S8fyl2ovuQpWPgrdKPyeKmb
	Gz9M0mMIWPLrclgeBhhNL+JkJxoedvE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dVK42jQp;
	spf=pass (imf21.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772785508; a=rsa-sha256;
	cv=none;
	b=N/QsYkLtUn+J4CQdVvjpLB/GqrpYi06xrcjCJtk0aDmw7MALDP5SZw4qW3bL0qpAxWFNyL
	5v+2WMAHvFRX/iDjV2y0iNZ41OOtNFjb3KlZOpk+RWa9X3jfoZCiY26oDd6aYzA/2jli79
	aUAUlh5VEP5SfpbO2An5LP8DH2rEfOg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1772785496; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=5hwjmq5zFDGgRXaXsLSL2S6bS9/O6gUN6TgPSpphuZE=;
 b=dVK42jQpKpKcXnXfJgZN+K0M/FStcxUNMtEQRTR3viAYRY6kIdGC/H/gWooAzBawLJUOKJ
 icsJyI7cljYog2q3Vc55b+50Ym86jFW1swASKA72VBAsNEFGP8stgE1qfLUarDCqeHlyy7
 qex/xsK5gmymppoCyIU1h0OUCiVuVqS7BrMNmdlSIMA40HwFCZVZMcsdVxB0gWZ/xuciVg
 0+w6mGe3sa8Ol4yS4Q5X+w7mks91oMi+xuKdk1zZI1ghSAKvsBxe8mniyZ+Z6q7PEzSkxK
 b7MkrKFBqTmjhV+u173f0L8A8MRxx8bc/CVk9pqnhgvepFzNvWwhD9NrC4n8lA==
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269aa8f56+3e7454+kvack.org+zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260306075757.198887-1-haifeng.xu@shopee.com> <20260306075757.198887-2-haifeng.xu@shopee.com>
In-Reply-To: <20260306075757.198887-2-haifeng.xu@shopee.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
To: "Haifeng Xu" <haifeng.xu@shopee.com>, <akpm@linux-foundation.org>, 
	<david@fromorbit.com>, <roman.gushchin@linux.dev>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 1/3] mm: shrinker: introduce new function get_shrinker_id()
Message-Id: <61cd204c-4c1d-4146-8728-bd315b0c6617@bytedance.com>
Cc: <muchun.song@linux.dev>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Date: Fri, 6 Mar 2026 16:24:42 +0800
X-Rspamd-Queue-Id: 624731C0008
X-Stat-Signature: r7s1dp1d5tu3ktyu5tz9cxh3brbh4ysz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772785504-667250
X-HE-Meta: U2FsdGVkX1+LI4sXiAPD9QaizBIH9MdPUs0GQdJL2bvWz4P3mAmAMhkEKFjSQJ89s0NeGaE+BEGM6qvQxMSljJRUDjPWKVSuHV74/nLyHIvAQiPfTFCPPJ80yYNhJNgysa+o4W3V0B8VIsWQbEdpmt6uVFJU47RFUQjb9X7h0lkacK6+VQ3vRyEkRuhBo7a2MPtOQXEkDK0yqjD0caDq7x8POKlNSNoSx1v4Nokv0HW67B+yQBuOtCds3jFX/tw3EXno7IqSKGC2z67pNHFya4a0ZFwcUtoHQzrNnY4Iqw1DVFfVXlS7ioXww7TubmwX5CMHCqCClEubZl4evf7OipaWPCOdUBXpEby8yLBa9Hd5+lN04YCrRvDG5lFkG/BmWMd+6V47EUpxpBBDBDaGbMFlftK9Yai04uyVIoMoKvT9+FyjA9oLeVcH65Zvz8gf9igbURZa5bHd8A1J2yEaAecwvl0bK4Vo7mk/WtHUY5uvCPTSMa5T+a2zmzpPfM/pIQdzmPLlc/uijA55rcEqnjtv5DyZH72HspNQ3i0GijkpUTsSmJwEyztCEBFeWhA/ePv9wAi3lVB8AQl9Kfcs2POlSplVSlF3Ss8qnaW/LKodiRZc50DLNB6t3f4SfDhVhCCzWGIM2InIQWnq0tzv7WXz2qnq3J9iXgF+AT2/2MrKlpgcVzG8H7Q3Fdvw4TKi/Ll3aY++Z61F2wpy/bK4jrHSE0TvmsWAqsMg7O8S1G7zMz9n2Xa845+NABgOPsv8Dh2tDveGVv+wXNVHRmoGWl4C68FoC8FQCESQx5ribK7qczQOWhfxm3MENNh7WlSigtwYobug9t0hij/VGtLjzfjaq6T/kBn79D9bD8jIlVhUSEHOldVqOcJ+zsDNu5PzY3TfdF2AfmGL+NuifgQjJVb2cz4s2k4Ti2UsO/byYYoulHLknxoDH9y/A5cBiD/PbIHwegymBFfIO0RkbXk
 yGB26wZ5
 Fv3kfl+iBl6B6+JY/KRZSBhUL1pLnzKj172lr6kCAJsNstx/PpjpY67VoptEMtAfNfRvqyUpyWurbAMlIxb15avScCUDYOtES2SS3RUH2BGJEmPvn92jz/Vl8jTTfKIgKNNanGIASMqAQTdQ0WUrKbDcaLwd8Q6jHDRh8oTUIDSRbbfWHviiRr4BpMuAgw1rkfWQ4IZR435IFrHr+9iohzLl2ZQdM0XgbKAy4Bk992vemZP62Sbdg25HbhhwBzosCyObPHY3nhiZ9k4n3GXMRKwfa3lQNCOiFcjdAcgj7FHKNaoTmOyGelHnATVyUvnXFz0SA6ku85z9KZ7s4bKG3Xb5GA+V2ISSFKVb8ShDjyLVDKpWT3GVe450rzrloHW0NvNCA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 3:57 PM, Haifeng Xu wrote:
> Use get_shrinker_id() to retrieve the id of shrinker. No functional change.
> 
> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
> ---
>   mm/shrinker.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 

We already have shrinker_id() in memcontrol.h.

