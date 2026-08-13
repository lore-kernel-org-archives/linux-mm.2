Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F0AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860D36B0258; Thu, 13 Aug 2026 05:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811736B0261; Thu, 13 Aug 2026 05:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F3F6B0269; Thu, 13 Aug 2026 05:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BEA86B0258
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:49:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C164516054D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:49:01 +0000 (UTC)
X-FDA: 85095772482.25.2D9DEBF
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	by imf13.hostedemail.com (Postfix) with ESMTP id 50B8F20002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:48:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mp+250lm;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786614540;
	b=MGC5VDGK3v+a+M4ASetbzpzWUBS0eOgwb3Ht/vhqnK4oFWSun+kJcgf/USicrZYtct8eI5
	Y+rTpE2zFMDWoM8jxw8wsOYVGiKs+y3wXFiq/4cVguac02V7wkHa/Oe74M3r+w0PMO8OUn
	mnt3+LAV/ETuO6M1s98LMJizOib5gf0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mp+250lm;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786614540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yc4BCEkZRAyryb8BFWaybJrU5gdNe80jdgx7sIohbQ=;
	b=mZEfp+gMz1X3Brjx2lzdysqaJBkbgmmKkO9HxJXdi0HKRJth1ZIDMKn11wTcPJA3KPXVmd
	LkoIn150kfvFSvxRQmzfZ6FxmzH5w0ahtDO2oY4ARkufTJeykjteSbTYE9YRGlja38IiuZ
	Jg6qCxghlDRq6ClA6AFuWAX9UXTnJy0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hxLyvAskyFXFCyh/Dk/6vFUKFMNRflI/0UakJG9IzIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786614537; v=1; x=1787219337;
 b=Mp+250lmQszn0CyYwKcybd5b7y8ogjPGVVZOjPBAvgEdNJ3q2K4pKqqUTJ7vWQZ4udN1e0XY
 iauHdNbxdZIA3E1Ddhp/uslDpfAgum133X1iAE2dxb2k1P559m+3TtzjL94GewDoGsXmnDmQRqG
 o04zR96lIiwW21yhjQukqdCY=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.111.29] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 9e4ce1ce2358bf45;
	Thu, 13 Aug 2026 09:48:57 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <58bf1590-25ee-4543-b07d-75465cf13546@linux.dev>
Date: Thu, 13 Aug 2026 17:48:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/oom_kill: dump top 5 memory consumers by RSS in
 OOM report
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260811062924.4123014-1-ye.liu@linux.dev>
 <an18ZbYWit7oiwHl@tiehlicka>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <an18ZbYWit7oiwHl@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50B8F20002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: z19ts7zfp5x43eh3qfoxo6qctn1dt6ck
X-HE-Tag: 1786614539-55611
X-HE-Meta: U2FsdGVkX18LFPmYO/gdsSa4eB1E2z5anBDm5sOuFTpEGRijyCGKEVFP/rxWXnRTNsLx/uGQlh3E+/AcvDTm6NiH6C6x10BfoR3HPLrJc6joZrYP86pni1Oild8I/qaqc0tEzzi4o6f/xSz8VtfpAYVzaQgLw/xHv+IkwhhraYPcUL5lM8N3zPSBsMEDxHpeUaETbAs0naNFfgN7AFNurbCnb4FjPug74UhEPyVk3H5VHEsBT9qsM1AOLOeFH37yDGcx49kL9PbT6ARxAQW6euqtmJPpWYM/7fjdoOfeTZIOOfXTuo27Ru9sqTdZt6cA/n1ySmGBWhn6y0LggFaouU0tw5iBeRA5FBRk08j4r1H0NKmawkIVIiodqpfhj6vX5SfmJm64NAo+rFYdu70j13t9+496lavHbz5jg+YGf1zW5c3gK2lowNctE9arQTAGfCYXXcpKIok5c5a/n9X7GtsOfZtw61xDWezt4EqhLbhRv/mPZd7Y9lZWVHApgE8ynJmuwfUJg55XnVcKCUhoTRV3MlXPOVetA6JLVBXhqJub3GhiXffkimBSa54YMmXSiYw/UgtdhQ5VJAiBS+aBODBBmRArzKmqqkoGWtCkPO+LPJulxA3xVv8I3ey0Ta5VjlhOLIaauZ8lpUZX/+qT3XkjxBYHLLcSXPF4OAxIHzbGDiZKtMWPl4A7dew0yP/2wBCMFU0gVMjfAir7SceVzG+oBy0vwhcDOD2Q4cE6DBcR3R2v5Yn/0Q71IlOIP4GFWndEIPcK5RItyGTf7NV5NMOJt+DYjsZm2kzZWkkBDc3dIYwYyJNNlBwsfhLZ5+SrVk50B8Fv01ZAp8JDH0WGw29A/ecpgTwfJ2noodVK0gYcG7JtHXwTA3No8du5O2pr9/d0inZ2BAtC9+I5m9Ac086A+dx32u/NWUm1SkGy7kg84ruAfdtF4boJkqzlM+Bj4LFpcudbLysHa40RepT
 nwlZR7rJ
 a7uMJPpK35KfASOEmpOf2aYTji0R7YXDBqz4os771gvqfwAeqYtIFJuNWRdNo7dVEhpaVbTnPMl98QeGCmkiZ+7ZyKZ3jevWdad0ypCXX/SgW2HaLEe6EH2/iSAheoLwn0pbwnDbxR40nvGxl0pcqRGV/SNFIKj9ZIwruuFAzqkXeWXJxNOj6sXZ0x9YaJhKUtOIpy+RXrXlhhXvMAuWH0Qi8WSPl3R/P09Vbk+MBdEZdTtw6iQqOUVbrYgei2lNPmh+dMQu8z674/0fLloXx3ihGmzCnrBCF7UXFobkUFGnixhxS6gb+r/36ldWbUvWlvgY1Z1WSNFrzHzwSUouZMRsQCzD0cVJt65pJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/13 16:12, Michal Hocko 写道:
> On Tue 11-08-26 14:29:24, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> When the OOM killer triggers, dump_tasks() prints every task's memory
>> state but in no particular order.  On systems with hundreds of
>> processes, identifying the heaviest memory consumers requires manual
>> log post-processing.
> 
> Yes, but why is that a problem? It should be a pretty easy script, no?

I think I've realized that problems that can be solved in user space 
shouldn't burden the kernel. Thank you.

-- 
Thanks,
Ye Liu


