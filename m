Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED1AF417E0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416D06B0089; Mon,  9 Mar 2026 10:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4F66B008A; Mon,  9 Mar 2026 10:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C4F6B0092; Mon,  9 Mar 2026 10:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15BA06B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:27:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D381D1389E1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:27:09 +0000 (UTC)
X-FDA: 84526751778.27.8A43CA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0CC38001E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:27:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGOYkD+7;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQvVKqF233NZrkjkgIAx+pXfAvqIY/q5i55v7rJQPmU=;
	b=mYr4ZbqkgsLXprdMN0LiQp3Ce/ievGuoeFIy54IUpiUWRTpH++oraS+wrSaX3A2yGjgV1F
	L3nYQyxT4iYNRyvqPWCSvv1lHtg5z+ZCHxIC27Tlk7n/BeJMb5SCjB0trRpUiSgEiVWBgd
	xcBkqYr7hwmq1xb8jxKSxJmFk11cQhA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGOYkD+7;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066428; a=rsa-sha256;
	cv=none;
	b=bETBNIDGjGs35kdAaVVBzZb6kgvWpvcdK3xRYnisnD9k3K5b7ZyTFIOlPXKAkqujBPVcbB
	v4+gTLmBPkMhUtbHeimk4BnOer3+WfsktkZnEylyFWt4aKxdCuZyVOTlEa4Y+HUqzegxsB
	xL6vw7onE0j4oUEXjbdyWtFtyAwSUOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6EF4402FA;
	Mon,  9 Mar 2026 14:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C2AC4CEF7;
	Mon,  9 Mar 2026 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773066426;
	bh=6IdD7SwRZOt8VyOImAFXr2cyhG+5woWeYcGXtRB/e+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oGOYkD+73TN7zSPRmbSG3AbS2Mt2Gp652nhq93jzi+itj9o42TeXKkvkl4vxru63q
	 wZabVdMTzdlf+BX8HaEdz/2lBPHLydCE+fd41NmhTfwzdacmc35DVffsf3dOID9vjg
	 ayCsp9nHhn8Nh0sEw4yml+53cw7PMAS6eSu0R1tQhD2BcZcJVggd6PSFSdPmKdOz63
	 3M7PsH/MQeAsUt/jZiTCvQztG+LNjG2accsgwcK5ybBQW5bH/7k3LLzrBUVTyNHwWS
	 MaIxb/9EGdmaOu6IJdBktrVm90OrnkbAp6QFt7IVl0khNJZGoqEw87NVaoPPzNie+Z
	 IG9IW94XbzqrA==
Message-ID: <383e1567-0966-434e-a818-f70bff1d5220@kernel.org>
Date: Mon, 9 Mar 2026 15:26:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
 Yuan Liu <yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
 <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
 <24ef67e7-6f0f-4544-a50c-90c4de368c40@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <24ef67e7-6f0f-4544-a50c-90c4de368c40@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E0CC38001E
X-Stat-Signature: yeac4895886b1dddup7k87kywk1d7ap4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773066427-577199
X-HE-Meta: U2FsdGVkX187GefjHJKx1I/jSUNyQgnfoDCMvG0ENzsD/qGXNoNqJ4LfMp2Uw06nvrkbBcYIZMPnFneN/r982B60+E9/L8EEI63VuoAIgbU8Z0S7hLw61ctanujlAMOIXMS/cvJyvVhhJgjMKHCB/H/VuBaZ0S35PkRtrhf4zXN11S5ljofyzQlkwbro/NjwD1teVNYZiadxGlYvtipwgtZFyGmVYG3kRuZ1yAtLLJjC3pmqFX/HSIrKSPCME2nWLnqRtWvhmXTY0sq+R7WTX+y8/xX1B39oBSxOjONMugytA+hf62qy7DgcEd11myikpB8gpC2Wx5UVMW+h837RC2mCRDiNIzYOqvD3nlwgKGcsBhq8H6ZcuZfuYFOJwvkJwEblIKWQCMOx/sE+AgXM1aQCod06NM/knA5XoXBpkM4HnqwcVCddew/gmzkzA8HLLrlYMR46/w35jhy2xWltMlqRnBiRPkQ2npl6MnSnOEGawWA21uKdNrOyK67HsFJo3VpHNWQ/t5pSeWdXM59o/NgDrYDfXgshKmOPqg9mKdLTKJR+CAWB5DEuDrKxrv28fY9tvJeyvhvwSNxjvWCKABvL/6tCRaeBx9QfGTyqFGGeB0Xxl997mkYfosvLTT6pprTF54R8pW0CKopqG78ZrLwIA1dc+A7u2Wsy5iWnTeBQWHPIaFlsr66FhKlVWkJA0NiwvYyJ7q/NJzQ5wg1nXCkSR8FWZxVAi4ewGyBW5t2oyHTYTiBmvyflnkeiWYvMWHu2qIqhehQXs2I1oleaU+k+OwdO6YIuwA6/v925NhuSQ5Zev9OPjC8BxiFXKnHCKFGeDmeasC9yifRT/kZUEbd7K9t4YXNZCFBEK54AYtt8aJM4Y6Wx+ISj7yPHj/ObKtF2wMN+26ngYYEF9thm2SXV2APLP3DLZ/Wp3B5vuyTLsEE6zkQo9hUJs8wjr3IR60SoBzSGcMY5TH4hpH/
 4E8wLmy8
 vTd3awjXAb2VStc1pjsI0V74NzihxlKZnovtk5umaK3t5kbj63VDpTERACkz4gJKQdoK7+1XEubJ5a5FG8KlMUcmboV6ygkt2W23KHyl7IggaNYCBG0GC5Eq1R35mfTwP13ZyPwzytYTQz69w1/K8uFoifbdfcnBqNQVNEPoFzlmCqDrVulc2hbtvc7eBKU2jb9L/Ndne97lOo4+nrB6ILPqzTPJp9FQWyUpfIXpvBGcN4nkN6wM1cWYGdXIwStfuY6Z0iOmaFOhcfEX2DECra4o6OqFGYfzhsGuMVjSWR9Cu2L8WlzxRXetQFjmG1Uwph6qff3zKY8aErHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 01:42, Li, Tianyou wrote:
> Hi David, Mike & Other maintainers,

Hi!

> 
> Just a quick update: Yuan and I created a new patch based on David and
> Mike's code, updated the documentation as well, performed the
> performance test, double check all the references etc. We observed a
> slightly performance regression, not sure it was caused by the
> environment configuration or we triggered some unexpected behavior. We
> might need a bit more time to investigate. Will send out the patch soon
> once we have confirmed data for the performance regression. Thanks.

A performance regression would be rather unexpected, unless we somehow
don't ever set zone->contiguous=true any more :)

In which test / code path did you observe a regression?

-- 
Cheers,

David

