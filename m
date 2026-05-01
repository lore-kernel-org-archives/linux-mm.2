Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0BDFF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 07:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049B36B0088; Fri,  1 May 2026 03:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021A36B008A; Fri,  1 May 2026 03:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A206B008C; Fri,  1 May 2026 03:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4D366B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:14:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 744AF8C445
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:14:09 +0000 (UTC)
X-FDA: 84717987018.18.D1F930C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1A4F180004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:14:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRMF90bt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777619647; a=rsa-sha256;
	cv=none;
	b=BIms4R8q+LnDcMp0pt40GZ0bS5FzpDHi+KD9boJaFqVSMSjhcNCmhF4pZfA42cm2ovO+JD
	mQFwUdFR6EEl+PyKb+Mbe/vx2Fhi0+RzqumGjgkdMn10jXoAjp/AvvBtD0OHBNNfxxAh0m
	+z8r2IGPj7G9kwb3zYMyxOVzcp6V5qM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRMF90bt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777619647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wuiBgrSnuNWFFf3R6F4ASDCg9n9Aja6Tcjd2kviias=;
	b=2Ny9YAg4T+B7O1s1KVv3KSRRFQMj04561wWr7iDRTXBn2pPMn50/lLqionHsOtKhrYfl0S
	ut7YxMLUM/5UDNCm1WgA3vnF1koFXTkWF+bNFU10ReG9YX6rB0hQI3oKBOhlWiKrjIdCRv
	qGx6h90/4rZa6wtPZnvjApOme92m+r0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AADE6014C;
	Fri,  1 May 2026 07:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5CCC2BCB7;
	Fri,  1 May 2026 07:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777619646;
	bh=cQmKPuqMrDemevQCdVHNG3pm0Jgypr9Bvlq0WQ6tW3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hRMF90btORbLa2eELV9f7wF9G28pAwviSKeg8kf/SO8uAj0+IIjdK8sKON3mgyFXh
	 WjzwYIPSLUb773zLJVMRTnk0nTFFvpH0Is6BH1NQSOZnH/17FKYxk912Vg/JUMOVPd
	 xFiTD+pgaH2SYDDrGGdx9QQfyD1T8BUjrwKp1jSuZHYZaeUFcXDbfv8071teoUgRaT
	 buiCiOAlgU+lRytCwntfFFqT/jCbX+OaLBNK/EYDIoRY3ui5ENCdlLEMDzGTT1djrS
	 UgTU6VgOZqrRKwvSbY/KBY0bjVNXqn8a3lV9kphVuF4uXNiZrG1nuUkTqT9X5+FsrE
	 gXLoE0XyJEjWg==
Message-ID: <428786cf-6873-4cdf-ae57-cef43b174f8c@kernel.org>
Date: Fri, 1 May 2026 09:14:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [00/45 RFC PATCH] 1GB superpageblock memory allocation
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, linux-mm@kvack.org, willy@infradead.org,
 surenb@google.com, hannes@cmpxchg.org, ljs@kernel.org, ziy@nvidia.com,
 usama.arif@linux.dev
References: <20260430202233.111010-1-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z9gaej7ak98yst8staezkgyocwkt3sk7
X-Rspam-User: 
X-Rspamd-Queue-Id: C1A4F180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1777619647-20131
X-HE-Meta: U2FsdGVkX18xANPpS8h+XCvL2y2iifIfLSfaR8zUsPD3+OLKJukRktlP/ypijfKu3zJ5zsZ+5eQK2rXC/1Vkf64uPhqG/TPQvUwKzgIkxwYuYAcEPaYhmfm7irXYMD8w46JgZJ/zgxDPqXkuPaGy8mGTqouXW0Ro5UeP872wv/UzHWl0LUwflG+9lBmVDG26Sl5kRfnVGo6FOcFOCLUR0qAfdd5zneN8+sgNajsNLcckomeBHqobKCgJ+vUSu0wmH/kJChUuuMPMA7qFMn5RvELC/lA7hFcnFujG97DbfqUrSCUQrcr6V2KbPwJWBXZp+tAMC1yQVLlpzaDKp51Vv6o/Bc1F/awia6+rvzt/KEYDNZkyinDW8webtWrAgzAf7A+x+FdoFlktlZ+MqC2J7SUNB3yH1nuf6jDdsvBQzGhFfC6lkSgM+kcGHqaFJOjDvOheSS1FkMOUub6jEyMEDT/Uko0tW6ArLAawGsa+QTAm9XUqbZffLulGN+q+UZ5M3CukhIYYeoFk/NP/kZVFLxm7Weah6Atq0B/EQTilL82L39AmhzOzaP4ZsmfbYLbpNTjSBgAWjeLG9XnHd2Mn/m25LFDwWBv+NC0wPxGw3mZ+QMiVK6uuq6XX3Ak3Y7GKX1gXvpMzckvZ6v39IK6GWHXt97ItV8SyOkIdn5Ql4mf/oHcid8GzhoehxE/9GigwGKCT1N0kljajKlgmtJ9QCHkHntkIoJHoImHLWxriFW9Wlj6FFGYsUWfp2JW4KIUhaPmjF28cnqLvLb7X+QTfuJDK/WZ/U2djv0ZRwC5UqycobMLYpRmVVqPa+Ah0zfTBM9t/j4aN9TsIxoetVheq636eVEo5bKum4EZXWF2L8InB7kmG093w2KO/Q0c/Tn90Q+5/FzmPm5cUny8X7TCPDkdxyEcPOaoa4sWdV7+68O2n1Qk27GaFcmNwzmxGBq+SY7K6xomwhbbYR0oLttq
 za3qMy5B
 jC+qWcrKwWW866Z9FZcKXxqDkJIMid58KoiauS6KxZl2X2MWVoUvNY4+AJ0TSSmKRFvj5vzDuqTVtyxLub79gdZqkYaXj7Abwvi2ar6VFFWG6i9Kq/NR8DS5W9sAYtRTMsMDs9NRapOlIN5+hMCcEsO3wa3QGMesKoEVF01FUj/pGJwFNln7ii2ej77pj5r4XorW89ZamFhdcOGiTRtsv38+e1FcaadUWmCjWUR0YqQKoZggT2MM5LyXVSNXGGyxXYMqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 22:20, Rik van Riel wrote:

Is there some text missing here, given that the first paragraph starts with
"Neither of those" and I am not sure which solutions you have in mind?

> Neither of those are great solutions, given that modern servers
> tend to be large, often run multiple workloads simultaneously,
> and each workload wants something else.
> 
> To address that issue, this patch series divides memory not just
> into 2MB page blocks, but into PUD sized superpageblocks, and
> aggressively tries to steer unmovable, reclaimable, and highatomic
> allocations into those superpageblocks that have already been
> "tainted" by such allocations.



-- 
Cheers,

David

