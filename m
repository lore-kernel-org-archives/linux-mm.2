Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85541C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 05:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CEBB6B008C; Mon, 10 Aug 2026 01:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358EA6B0092; Mon, 10 Aug 2026 01:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FEC6B0093; Mon, 10 Aug 2026 01:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E76F56B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:41:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 557AF1206B6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:41:33 +0000 (UTC)
X-FDA: 85084262466.02.C4D0C87
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 119AC80010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:41:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of dzm91@hust.edu.cn designates 207.46.229.174 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786340491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9ncFPoyeU+CoX9FPDpTDGQ1eDb+6ZmoOTfj/HqqNAA=;
	b=hh0BdVdHHhB/FEUcYa4eFQ8mgHP+Rmr4fPBYDdVNeQ2UPCQQkvxlqggp6OkKlWmixXWCOg
	KfUQkmT3ovB9H6sWsqBe0rHG5McKv+vO+v1SUnz1QQ9ED9casV8Ztt67N2VPY776RthWOz
	cqltZurUzzIZKd+SvSyJNzM/rBh50hQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of dzm91@hust.edu.cn designates 207.46.229.174 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786340491;
	b=GwWX98Rfpoaed7A5CRIxJl5RtlQCoFi5BVrPu22jheUMOWQmm4aw9trVXX6nssaYj34dha
	fgawLTINjtFijT1SavkUYJK+XW1L+RyCYCs8cfSVTQvJMJj2MP1iuN2kHElhpcR/6RPe25
	KFMWOoO4s3k+YOrB3gEyUdzjKkQ8Gvk=
Received: from hust.edu.cn (unknown [172.16.0.50])
	by app2 (Coremail) with SMTP id HwEQrAD3zTRZZHlqh0+kAA--.61798S2;
	Mon, 10 Aug 2026 13:40:41 +0800 (CST)
Received: from [100.81.40.43] (unknown [10.12.191.55])
	by gateway (Coremail) with SMTP id _____wB3QlZYZHlqpkA1AA--.42332S2;
	Mon, 10 Aug 2026 13:40:41 +0800 (CST)
Message-ID: <f14f7349-a827-4bc9-904c-13fe5c6e6412@hust.edu.cn>
Date: Mon, 10 Aug 2026 13:40:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] docs/zh_CN: update DAMON translations
To: Doehyun Baek <doehyunbaek@gmail.com>, Alex Shi <alexs@kernel.org>,
 Yanteng Si <si.yanteng@linux.dev>
Cc: SJ Park <sj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
 <CAN-j9UpTxLzvu7EruQW+kvvxivrtOaS3FBW_8dLc9TWuvLO7nA@mail.gmail.com>
From: Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <CAN-j9UpTxLzvu7EruQW+kvvxivrtOaS3FBW_8dLc9TWuvLO7nA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:HwEQrAD3zTRZZHlqh0+kAA--.61798S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYG7k0a2IF6F4UM7kC6x804xWl1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF
	0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0EF7xvrVAajcxG14v26r
	4UJVWxJr1lYx0E74AGY7Cv6cx26r4fZr1UJr1lYx0Ec7CjxVAajcxG14v26r4UJVWxJr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxAIw28IcV
	Cjz48v1sIEY20_GFW3Jr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU0yrW7UUUUU=
	=
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 119AC80010
X-Stat-Signature: 8o7yrki58b5pqtki1wbprqiikzk7urbu
X-Rspam-User: 
X-HE-Tag: 1786340488-220186
X-HE-Meta: U2FsdGVkX1+A6ZO10SoQ1q24aCQk6NOMvoUUQn0o7Zh9Q8YPqSRNhwxI9OIhNEFLVlMdXZ2mAMYsiC5SKk1s+tw9938MI+KUUU1Qf+/VsGnFmFCfUufAoLxe7lgLYoWAizx8msnqGC36/U4u6giVSUCZGh//q5TSY8iAaYfE99wqGequVr63qeKnVpBMoXC9M0wbFtekO61sY51AUbutuwu7IpL623fg797D6x0FPucJ61O9XXJS+SRAfFfmIm+YYx+PpbQMr86eIee39pyNTib/luma195EGlTs9V8E1HlIqKTIwQL8ZeqY9QPBKmhNQ3ucMxBYfCnMveEjJrnwE34lwkCUzYVdxe3S3kbS+F30+W5a+CUohGcJexSjsdJZBzsgBEonIb1opFgBxS0QZUhn+BIYx3w2h7OLKHXbsZB4Us0OFKTbqwbVM+uHOXYntvXcgFPEZoX8XMZTwcjiSzLR1GhVbCY5f9KtZRuia6JAsVO1e4UkOK1IJyB9Izuv0OrG9BwzjG4ACCgQvED3XEEaRKHfGn0T3KqqSCJ2vwJlIuzPNRQr0wSVmwvzLy5FZPazPuMwhxrhN6NIdIIc5ta314faDWSgITl/FIvxAkR4nFcEj5LtEki7D+Rk4aEdrB4/yWkmUnswD230VMWiP62m+G6YkpL0UjOalJNInSsR3P91iQKyBfMlSzfW4/4RWfO71HeYe8ezSoQxagL0vPj6wDaRNGpA7TDioPr/BbRAQ8M3LptcSHhSCT2xC0t18pGErjhVXxUEIvkU1vK1TdGP4f2/akTSIcTdsyQw6Fn6p8aZXohfOch38h5AmMOugstwA9pibQKuXpmkxp28nKNalGTuoFUtyDFjpCnX8UJdLtH2dLn+1BayynmkvxBzbFlpuRHkeHqU/Umh5VU59jaK9fmc4z6+zf+ngI4x96wFgPCXIwJexDGIOyT5E+N70oLYCs+UaqJii9ZL1pD
 VyQ02TEa
 vhS7wQGcY+1g2z8yIQHRmxRyIs7qMV2xhF8408MGWeNle/oSHkuCEHVmmgWhMXlwWDy1LiVEduN7K+Ei26eohdapKj9XSjH+ReiXp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/10/26 1:14 PM, Doehyun Baek wrote:
> Hi all,
>
> A gentle ping on this series. It is still awaiting review.
>
> If the current scope is too broad, I can split the series or reduce 
> its scope.
> Conversely, I can expand it to cover additional DAMON documentation if 
> that would be preferable.


This scope is actually a little broad, but still fine. The real problem 
is, this patch series is not in my todo list.

Now it is, and I will post my review quickly.

Dongliang Mu


>
> Please let me know how you would like me to proceed.
>
> Thanks,
> Doehyun


