Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395F5FD5F87
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745786B0088; Wed,  8 Apr 2026 03:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6076B0089; Wed,  8 Apr 2026 03:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BDE6B008A; Wed,  8 Apr 2026 03:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 52BD36B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:54:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 180FB140A2E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:54:12 +0000 (UTC)
X-FDA: 84634625544.12.255F071
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DE9D40002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:54:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BqVokPVv;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775634850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NpN4Ql5QJW1mJw2ku/aI8vo1FvJxW0UxXRO4fL36Bk=;
	b=HO2RwB+M6Vc60ueiMGjw9f2C0tNgY27OusN/W1pxbf47VpstBHU7FYVb9UJlJcTJowU/6q
	mzdcMbQuIDfMR5AmaVpgNSjZ3+H4dJINNaJXxFlHdgtEwTcxrj6vlCu+hxLxKZrfE386XQ
	mJUyzj46+CS4kh2Jvay/IlvVFNa0hBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775634850; a=rsa-sha256;
	cv=none;
	b=xNIhpMfG+j/v7mN3CRPlE4UmykLCYysKHutcJMB/CP2eWZAlhH/LRDExfc0qfVGdkrXOg3
	XXf467Cu0c/RvxG5obYkDobhqqYhuAm1xAJNNOS0YAkIGqlKEFHD0kW00gFvn3p3TgScir
	VlB4a26NdCtNZG6vhYzPGIePJcj77I0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BqVokPVv;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70101600AD;
	Wed,  8 Apr 2026 07:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D011C19424;
	Wed,  8 Apr 2026 07:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775634849;
	bh=AsIwSVvXdvCgTsCsjMmwzorkzN1z/OiWFeFCQ2nhdMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BqVokPVvZ1I0WlzrkqlMDQMlpZNQB9N/qOPkBiT0LURAhedQrNDM1lEezottPtKSI
	 WPkTYEj5tHLq9G9eoDJIj36r3bo21CgiCJ2VO3i7b+WK0hnTv7B/YZOJr+zg21WdTm
	 oJhhdCUrG0h1Fb6vjvrgcW8ONwX8jVn6F0sul1Oylbwr0NbttNm0GjE2EgKWqH6iC0
	 hTKKAv9rMxrt2wcGIHcY0OCPBl6yIdROcCapjrR10JCfzj0FYKnq8AF+wRxMZCypZG
	 kE4itXhxK2L15K6iR997oS2vMsRfP9O4wSD44fw4DPOSOHrMCDb91RJKkcmNotON1S
	 KCnywlu1HDv7g==
Message-ID: <aad23494-7729-468d-b4ea-2310d75b13a5@kernel.org>
Date: Wed, 8 Apr 2026 09:54:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Dave Hansen <dave.hansen@intel.com>,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
 <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
 <8a5e4afd-cd0a-400a-8624-79c1dc9e3ff3@kernel.org>
 <fee59f61-cf62-4a60-9d8a-4543a02a9c48@arm.com>
 <efb2dda7-144c-4e00-bd5c-0b57a1244fb1@kernel.org>
 <971a511a-f311-4e2f-8b10-85d11e07bb0a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <971a511a-f311-4e2f-8b10-85d11e07bb0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DE9D40002
X-Stat-Signature: 3s5t38rj4gutjsj4qtcnrekimifjnu3j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775634850-728301
X-HE-Meta: U2FsdGVkX1+Qx3HdOmbKAY9IOv4rQbFwSOgNOMgfT38UYNgUZsYM/qOkqJ2+k4tIO3AxQtPedMVNlw6FffH5XrfwQ0EAgESweO/8wKHVSZ9pnmSMvHINYTGJlDAc16VUhaoq9CGK/zv2Agp4t8DJtZgD9x+IyW9ZgGuHSRomVbwlqWEBBK37b/hjnZkKyXr5csererER8ys8g/QJ0H312bwnB88USqq2iJpDpXPzlYbpOhJknZVjCnW3gkRyHMn01dgfC9TTmGXAfWbmousJkKZnRVQ7OJ9XsUFfOdTduIkRk40SgD1dkoNvL1xmtDn/pPJDcWDvar0JcQi6bCJ4AsmJtzv+8GXkkcF9v1l6ROT8ybeBgUtsWmTBUKKJ2Cx6R690hs4LT0ZH8k/YGDulEO0bYuYj7Zwad35ZFd8oL1gOcgsiBUcZy+Oj0Lur5ebdE+OUMjT9mepdDHcMsI0sk0r+a037OnhAAS+1981ch1McYzHj1be2CLBlQHaGcSYVXSREBj2XR4oYEwXKmtfuHUUX3beirSuxBay3LHvEQ4O/bAwbtpi1Up8Bj45N50c27IGK4lDERWaBak9xnQkhearT91oDOhf2ARl+jy6JebM47GQsmmYrghUGIJFQEysjxEKNySrXUued/trfx7VZRgW3YPKdU97AVmeIpMJflpCBj+DhIy0dyus4JoVr5zij5xewPAuAcVZT42aUeTWa1/xIfQOLtLcgWNdWnNNoflKr1Gwshou2EOkC5O+XHBy8Hy6EflXQd8SFSCqvnNHbY2as7gra0gd8CmoK31aBI33UZ7BEjVB+VtmigKmmYSEQCEvrsgNrmDsiZkEsFCk/99r8+vshVA/V7sGpUXyqZ6UTYQB5NW34eraR5OnoBp1H6TWV2ddv8YyZOg/wBi5xV8LlszjDEYWP2X4axJS4YhkwY2dBUfw4m4LAblXcENPnW8V3oeWhy/Oo+6aojtP
 jov7bpw4
 h+0ghKv/DwOqIsg5bxwYEbmvTQSwk8t645iabs59YUsbfYm2kdlJlPmpXj2s+0qH0zmOmyj5s9HWO+JV21rU7N2bX+mdeZE1TZcJp85lC8o+eywA83WiKwjN1LmKKPhRVFrw6Z1Ww1HOLJB86QrorbR4bxkFDpicWJOh1P0HdMNMIjOuY4dDDNHqM+kTtsa5m4m3xuF8GBvXFVOMrKNZICxxxjn9KfNidH2BNtStKHZwTOnwYfDKrgABeveAfD0IjOMYwd8HtQ4xivaQuWHTs1h1x34i+O7Y4b5nL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 09:50, Kevin Brodsky wrote:
> On 08/04/2026 09:39, David Hildenbrand (Arm) wrote:
>> On 4/8/26 09:15, Kevin Brodsky wrote:
>>> Of course that's also possible, "hardware" has to be interpreted in the
>>> context of virtualisation... But granted it is possible to hide features
>>> even on the host with the right kernel parameter, on arm64 at least.
>>>
>>> "If the kernel supports protection keys (pkeys) and the hardware feature
>>> is detected"? Still vague but a little more accurate.
>> Can we just talk about CPU support, to avoid using "system" or "hardware" ?
> 
> I'm not sure how this addresses your concern with virtualisation though,
> unless "CPU" is understood as whatever CPU is virtualised? But then the
> same logic could apply to "hardware"...
> 
> Either way, I'm really not all that picky about it, I don't mind: "If
> both the kernel and the CPU support protection keys"

LGTM

-- 
Cheers,

David

