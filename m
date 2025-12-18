Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93BDD6ACD5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0BD6B0088; Thu, 18 Dec 2025 04:18:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140F16B0089; Thu, 18 Dec 2025 04:18:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043066B008A; Thu, 18 Dec 2025 04:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E89716B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:18:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CDF661087
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:18:10 +0000 (UTC)
X-FDA: 84232040340.03.D3BA172
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E7EE44000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:18:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ab6Q3KvJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766049488; a=rsa-sha256;
	cv=none;
	b=D1Do4YaU6gWB7bTcHxm8VuPbJaQOawUVzFB4pp6t8lVHXDAr61MpGrRCgX+uA3lzVppJXa
	VD67JeojxB8KM9kFin6O/D6nLHgHwlZNjIW6iElFgNwUqtWsmDUAEoOseBWw46hKUE6IZp
	mEqUMraiedeYFBJ5kQM9MP+PYuYJQY4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ab6Q3KvJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766049488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2xAodYKcOeiYb55/bclscYBobcVpNj/ZKHlgjIxkVk=;
	b=P/OhhifK2O7yoisNvHYC2Iv/HhynwwIw1pYH3RXboNc9lNuBD5QT37TfNXQluzxX8mbAxt
	uQCH2GJqqt5YkmE8iTD+5P3f1WBSTfWXJ7y2InTuYwFH6q/eh4Qr/OeSpxXv5GseHS4bxx
	0qXJi6M1osxH892aqsiRuRZNaPu2f24=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BD5660010;
	Thu, 18 Dec 2025 09:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD39C4CEFB;
	Thu, 18 Dec 2025 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766049488;
	bh=R/1cioPEOc1Vk50SGuTN9wyMBRaVyyQItGpm9Hs+iiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ab6Q3KvJgMBLV3G4RIuyN+yILZbFaNvZnEhCAQ3x2PTBQiDhfDretICwWC0nupJUK
	 NxuSN4c32MWWrg8GkkaMNM45JWaNGUujMFqdJiiysdKSVePOJ7JLAyqEkxkslrTsoT
	 k6jL3iCaannu48zvDM5lzxptx90paltEqZWDcXRd/o4HcA9u5Ra3nemNbDUthBcv4t
	 WBAPSdwDEHVvJi0hwRC2gA+kH4wlzCt/8D+iL4Q+LBOz3+q6cWluXuR4GHmR/bBHE5
	 aLq+UeAiGNFJSaZHyy4YtWDgM/IdzHBTor6TY6LSzbC2v2AoH2f+NGXLHJl7LQpYKD
	 p3YPr6iXT/Qqw==
Message-ID: <c68f94ff-a9e2-4af5-adf0-90fd7b593949@kernel.org>
Date: Thu, 18 Dec 2025 10:18:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/khugepaged: make khugepaged_collapse_control
 static
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-8-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216111139.95438-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7EE44000D
X-Stat-Signature: b4pc6xk11g56mpqneejqsce5kd48peqf
X-Rspam-User: 
X-HE-Tag: 1766049488-804252
X-HE-Meta: U2FsdGVkX1/83kPyqfLGdgZhxuUy2gvs/hKcX9XRTROtqaOB7sfelXvL6kR9ciZzuat7W0f0xJ64TeBi2djilJgzjX3unz/ejXkSKWfbls9q+a/pq203FiuV9oXCb1ERK1yVsNAq5Y/ldTSC9HMf5+jAML9oebH7APydzAxIxu4FkOvrxvFylJ9TDe2vc1FRq15MP4VobP6L8BOwcjp9j1A0GzBMEFj4k0C20RmrwaKhRYemnAeQ4662Fpwou0Q14p3VLHSR7XxZkk+woMnPNGGSrKS/rsX5EPb0OnhxQbd3uBCaVjF2CplZkuSoRXSweqcfO/0OFzOTL4O7kEXfDgHwHF156Fny7IhyB9CixBbt57sV5syPb5gB3rPdVwQHd/+JPo941kT882wDtd+8EDY5dEd9kZI+DWS8jBVUSWBFXIYp6EkLAJdx+vAD17+08gf1AHg7/bqb5QUOQ2AEC6jPSVlH8jBmVbKoz45igwHx7Tol+BK8C+OacMv0TmWsgLcdKsdK5hGMwW0RzvDnYpbfJ32m6DH+U4HlU6Aa75WObbpaKji8SRqqaw6XuCX8BIauBcYja8gKW2pI7d6qM92mT+7t2HxiEy0vNCoLLPPkgng6n+2jChcL+yQ3pzc5jEakuCpAoHUryTAIEqSpct4PtFgIhNgV0AtqNK8m9NDt6wiWEz78e+sjLkDO58m12iXOVbO73QXmsdYSNwk4ttc3u+DJuENceAXF0y9aYmNLV7F0HndjxCCXS/ZkGWx9TsaK25oYJX1fA7QZZMzX3vtPLBmsJiPqC5GYJEZlpx1ZY5zD3RKSCbr+kFhfdf8ldxRoqFFloWRFx7Hnfatdro0NfMgVCXFNjnsMsgilvrR/Lc5XdXNfeoe5odFAY4sJNQYmAT5www9huWZDvza512+xmPUirD877Q8I8OjhdVlxAgE8rrpksXk/NU0NLcvdEg85rKGgUPF0YFw3rM7
 gWY7azEy
 bTgpbWbbz7JPMSCMK5jS+/lhe29nLGb7SBoi71OvDK9BQosaU8Ff4WshAAwfj7pFvjc+qcbWlt+JWfsWF/n7izIXAOePITM/SmlO8+tlYNbBqZHQAcQhkHG84GnqaZGLkPPoDFFUQ1qpicrzV1NI4zteG7DVm7izd2LLqcHG2mftryGVeG19gCoqkOS9gmKYB00PQHoW9JZmu3hlu6ZolHjm7DQPMfYUdiByguEQIUOtUCQovlamUfDE5amq4yuMN3QH8to/vtwgyxNzOIofBRdSnRST7o4mBkNb5Om6+pJq0qMgp5a1moE3Uke0m4DajR4zzztlIyppInwONrXA+x//GkFS5Algyc0vq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 12:11, Shivank Garg wrote:
> The global variable 'khugepaged_collapse_control' is not used outside of
> mm/khugepaged.c. Make it static to limit its scope.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

