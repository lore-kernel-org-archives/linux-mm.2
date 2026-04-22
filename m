Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF75FA1FE9
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668A46B008A; Wed, 22 Apr 2026 15:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640266B008C; Wed, 22 Apr 2026 15:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555A16B0092; Wed, 22 Apr 2026 15:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 476BC6B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:13:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1428A0149
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:13:32 +0000 (UTC)
X-FDA: 84687140664.23.ED4A417
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0E51FA0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:13:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJgKXsis;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776885211; a=rsa-sha256;
	cv=none;
	b=a+8WjwSQ8xZCtstHVXl+nl3cBgjEj25sxzwA/4AJV21yN54t3SwYib8UwkqNZOcxZXxjrO
	iq9eE9VDfUpQO0sclAfQ0IFVXOZkC6//Yf995Q4p48ZJrYcCLMfCt85cPvt5bLrYZ/mQLU
	ZXLKQuoKPzzgxNDXg0hCD5XudU4xM8g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJgKXsis;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776885211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MNSGbgRGH2TwbMCD1iAzgq26xIxtY2tCe9pYp7sG6k=;
	b=FAjgB2JeR8wWTAmo0rxVVzP23cHugx9CFE+jSU1fpT9w6DJN7exIgPrtcRr+YAxYBgwtcz
	YMO96RljZqSD0nuwA0p/qethvfZ47svoRzjlghZhwE+Wq8eT3lB3l65ZMhBGnLPyjgKOyO
	447qVauBfH+46b4BPj5f0geLTMP5sDc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0C034185F;
	Wed, 22 Apr 2026 19:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEA9C2BCB4;
	Wed, 22 Apr 2026 19:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776885209;
	bh=oLyo2UmbSk6yK12XQH1NDZGAAWxM/MNUH+J5zgzMcAY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZJgKXsisnKGfY0W43w0RGoH2VvTWTp548jVKfmeOvUSuLlnOItkB+ZNLDwfeYuhqG
	 7T8Igq3bKQE7XTogkAaewJPWypOZMhYjucKo/eBDB4pYJQ6UvIoymZcj+bXq/s/g+Y
	 362jasf3oGrSFKUvIcXb6k1OBhuUV3JA5FQ6d2dhKg8nFDlpVeQhmZd285m9/sS8xx
	 2G3Eey/y6C179ATEJ3HaEeItXdwoDKITvz9m+lnfNnGyxxu+RpedCtLXhnXsS4ZkPo
	 LlJZQsDmGTPwIKl5GL13N9aOwlShCK9lOioUJWLltaY/ZSsMGTr3TPLhOGhlQkQbi6
	 N0o5eHM/rE2Ow==
Message-ID: <fe573e15-0ce3-40ac-957b-03d63fd7a5db@kernel.org>
Date: Wed, 22 Apr 2026 21:13:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong"
 <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <2fef4fae-b7fd-4c27-9a76-994076e27b5f@kernel.org>
 <MW4PR11MB69364107F48CFD6D35AA9771A32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB69364107F48CFD6D35AA9771A32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: hgdt1mezs7149srzffixfde3fsbxtzp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E51FA0005
X-HE-Tag: 1776885210-799173
X-HE-Meta: U2FsdGVkX1/x7QeHZLsZKz5+51lZSk6F5ULG/WH0p5YX6hGMPI7nrVQC9mmlAd005Z61SSCGZFeIjM4X9f6wpkdb35kcPI8TZTBdKydQ3S8oDpO3QWhbJKX8BgWlbsOjo4oCEiyQS+LXGvPtncUWZp983UXENtsDTCJ4Zip+FbyGXTjCUGzcWZoJeaNLX+HvpSPQbnmFRCXS6MhetjsoSV/laUgs0pyBKKzVfDpsN4/Yzm1dSshl93BTu5QElabvF93H/hVspB+3cMxJub9S6r6wP+169+eys85LxntkiGTWJUX0Nk70XazFz1vBr6XHCe2EsteCNA8XN8WtTARngXpUsnROyzL980zQ1MbSpjOlY8qQjx9TnKGvqK1X3Q+Az6icd9UXqwtROPQsAmKmnwRewfgoIwcBtQm6XGa4hDoTa6XWQDX0YT6q4x9vR4Dc1YWn5ig6aX51j8sE14yRpRxsfrC8OnYuYlnDAqqoc1muJPvQe04opPO2/kQrgGsFGeX8YDjA5xmoSFPlpG1dT0Rrqj26DA8+07+X/WKFJhAz/7l49VFQ8j4B1Quxe+Ek0q73S1aDXrpNUdV73WrBNSqNipHKlGn4HoaWafyyYs7jVpXdckSPlvbp6xbL0USjH0HS83ARH3qRijRVVLQdenYI1jcV5f5ItRjQ2Uw4ubHq7tDjUmqHHI2n+uSmIMI8a0TAzFgseEXtENmCUwLQ/4OztJ+C/tjkZ/EBNQPTohf85bR6pF6qh3ImggiW7bhCsc4wEWX1540Qj9yyyN6bb60L5tktL7e1LeVSGvRfmY/KNiElSUo5XfqsRznKYQjQJJSZC0OUPdM+cVzKP+7F0hXV1q18p0viKUuONgLBNsZMsMKjV9GH/J+XqkzJZ3catFdjwjPilqjayO2e3q+oTZyuuRGERNTE4lte+B5WO3sCej6w0+pDxSiZkFyC8snFYwnbiVggwE0BRmwbcKC
 BipYJSRj
 OLxpCvR+ecj/WDCVsPcnryy0xK0WAorrt7TkkwkiFaUPIxObkx0U1Y/42eol3gFlfBfFdLQR64ZFVXhFReCJkOF7l8XnNak7V5u3M0+IX2u5LgqZQfem2x9tFUt0YB/haeZUi2MP+fKbAFBnvImqwv5U/Bm3xCnXVNQo4wwqVrm3ng8+eOopgupfz3GsGC76NVJbvB4quO6mTk5j6c3X+OFeFaqdqTKct7q/HnjxBkhDNirQR1bVbnSGPXhT08/mmrokjDipnbzbiCB2u+bxXM0gusmGwauxpCtnUGpFfzjKJP4We9ajulaTBWOAMKB5+Emvue/xqk1vPofjSuMOTs/JMzL2ja7hdX8PORS0S4vOmqoioeGP3ls6wDi9Oy9XsRFamw0gjW3L7BL3+Gk+/gjpIfwm2+yLhy8ErdV/RDZSZWrBhdikw1bQUrBukis9X0Os0dySrF4bgTjGr6Fo3MHP2gwmmCTqSdFupdDbeNYw1Vvg7VH2PA/AewQ/ZASzryNfWMzxXHpUkZfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 09:56, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: David Hildenbrand (Arm) <david@kernel.org>
>> Sent: Wednesday, April 22, 2026 3:47 PM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
>> Cc: linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou, Nanhai
>> <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Zhuo, Qiuxu
>> <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
>> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
>> <zhangchen.kidd@jd.com>; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v4 0/2] mm/memory hotplug/unplug: Optimize zone
>> contiguous check when changing pfn range
>>
>> On 4/21/26 14:55, Yuan Liu wrote:
>>> This series cleans up the overlap memory map init check and
>>> optimizes zone contiguous check when changing pfn range.
>>>
>>> In addition to providing a significant improvement for VM hotplug
>>> (see the second patch for reference), it brings benefits for CXL
>>> hotplug as well. The link is as follows
>>> https://lore.kernel.org/all/20260409023552.GA2807@AE/
>>>
>>> v3 link:
>>>     https://lore.kernel.org/all/20260408031615.1831922-1-
>> yuan1.liu@intel.com/
>>>
>>> v4 changes:
>>>     Add a new patch for clean up overlap memory map init check
>>
>> Didn't you also wanted to add a patch to improve shrink_zone_span to check
>> both
>> sides of the PAGES_PER_SUBSECTION block for fitting nid+zid?
> 
> Hi David
> 
> My apologies for missing this. I will include it in the next version.

And isn't there also the problem with the subsection pfn_valid() handling etc
where I proposed a change?

-- 
Cheers,

David

