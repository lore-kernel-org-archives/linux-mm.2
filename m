Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9417ECF885D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 20:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB78C6B002D; Thu, 20 Nov 2025 15:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F866B002F; Thu, 20 Nov 2025 15:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC146B0030; Thu, 20 Nov 2025 15:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEE1A6B002D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:08:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6687F140351
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:08:08 +0000 (UTC)
X-FDA: 84132071856.18.840C5E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B33DD1C0016
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:08:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUgR5We2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763669286; a=rsa-sha256;
	cv=none;
	b=dW+7phCXFA/Jj2qygMOv+j07oTa7MTxj1jjypD0dkamVEBWbG9nlGBTpkJe9DV5Hc/vwk5
	ZetE3WPZxqwZxpqpjWU2co9S8KapSN98QK8kGwMXYkVMQEi5WOmN9RzFxSipCua7MJNq4z
	VcpUcONqJMeYc+KE03jZpVs9UAoOKoo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUgR5We2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763669286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNa9iwEAN9AZjnVq0r0weyR2GTqJY3I3qxY4R8Ltv9E=;
	b=nNlBcdMIaao/Cxu23UJhqE1RqqZxj4muLUKyaQMzDTKQQLYVJNGkkkc7HsaLyofxY+Azh2
	l1kOqpZDc6Gyf+aPUNxr2xgBuK3qAOnXJGjJSIxjU0zfm36yQSn+UO8bZXesD7iIYnhdiS
	xOQG7UOAg0y3xBXDl4dgq//geUZTmuU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 308B660017;
	Thu, 20 Nov 2025 20:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFE1C4CEF1;
	Thu, 20 Nov 2025 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763669285;
	bh=VVP8DdbSUeK/J4HV2SMoyh6buJCbiFpKSw4KcUAUqQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FUgR5We2tVWz3KOYVUlN9XBm2aT9NIJuOBtVwZlHkIk4HijQ9xaoL+hJIAJzVu+1+
	 kldFCboZhalUhd1A6glgmSWS/am1dk6WrKFWuw3nWY/EqbPTlBjKcfpoJ8EbqdFi3g
	 O+NozSCVx3VB+rhgZnQj4yJT6++vwZZFZ2iN7liJIq42i19RJ9GsWPvnneOVvnmkEP
	 YVnYefGXWT/BwT5aKviXdVcq3J5EWu/bsgSaZiwmY1rL2ykMW8tSzOpU52YpNL1g1p
	 +s2vMiv7ehxSoD/sOABpJbOO/joYPl6Dou5XevL7Zm/WpOcVu4c53FBlovBXLvWOCJ
	 6rkhH4KPoRbGg==
Message-ID: <7fae20ca-d7b0-4786-8c31-288648db8ad0@kernel.org>
Date: Thu, 20 Nov 2025 21:08:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm: rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to
 AS_WRITEBACK_MAY_HANG
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, shakeel.butt@linux.dev,
 athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-2-joannelkoong@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120184211.2379439-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B33DD1C0016
X-Stat-Signature: dsu91bf15d55wwb1y3ass4znrc3sqbq4
X-Rspam-User: 
X-HE-Tag: 1763669286-615738
X-HE-Meta: U2FsdGVkX19CHiVHaQeDIi+G89Xe5TJHD8fvuPGDyOnXNtX8TQnoPdLf6uhz9QjtHpSdIT219oC2r8w2HMYPQNoBChYyiLudFcBs0PNMNsPKeQ0hP9PNZl9Gb3XByUVjxVeeS3gUCBj9Tz8YD6TIjATLmYETJiJz1PoU49uii8+KAt1zKpUDl1dCOy+kRwiugehdb5Uhf5HcS6poxUxUynuyPO+L+S5ObcjD4LyR66nupzs6TJ0AhY/OM2PMLeOfQCb2lQsYWZJDgmIPKhRGV0dnrhCUq/s0Y/4WPZE5vAnlBSwxJiVaXHYx2qll3PUhGbifu39SO3rjw0nIvekp5N2omUa/SQFj84cNQF0UJQ+TXanI6b7/tJoDBj0aXOSMZbOOtZqpMYLwWWvwIpNHvyvX6X0VRtdy07IBA1ah+2iWuhLfvzOnsTdLXYJ3OIFCkVK5ZNdGFpTkiGV9PmrmomdVrUmL9rN39YHNzFfRJF1qvTU/cjv0LE0F08KXeXbZk+I4eM+grvMhm1Wl5tgudCRgEBlaiYds0wt32Nvssk2/fP4y64A49vEzeZQ48Cli9OMTEJAQGKocLixh6yoxka/jvDd8Da9lXu6B4FC5KLBx4m638an8yUiDihRABuf3yzp8+EODhOB6eIrg8WIccpLtiCkN5rgrnNVNQiNM9SxShKsDhGPMeBo0ZXPMT9pWuqthjTkJNmIpZ23d7P/QUWoIZywrMCaSdDfylxwfLtTH9iJOpsmEJ3RxzQzaewK/wIcEzFS2O5xF9UIkfpbP8ZNyO3LEjhVGRSG6v/LcKZO7tnQ4l5WkRaKHiBYebna5gqdczOxTlTROwY+F4vN5bttSdJpxx94msOjqreqOotdMwQLXrdY/c9px7V/ZBScFUdgIKiVsncAixKwJ25H+b2iSCsNUJ6/yizyINuQCPkL00r+R6Nf6LF3a9kI3QIAJuyXOJP4b7gN0x53xi6u
 fNFCloY5
 TO5O+OQ3J+G3TLuKG7bFBJagyHvOFzDIW0z3UPxt4h26pjQguGdD+m28TGskmmp8Z5iYf1AtVhjRjaYWyn2G4G5NXkic/nC/MDxr6uYZYAk4iWkC+fEXFbN9HpZPscwZqodhJj7YcMMmLD00xgo664QB+xHgDbP7m8QTnkfqgh6mzpD75NHFXq+eZ6rSndTsfu2vzs3i7CS+i1V10ymhxqe0jjlEcPi79pwDFWVe1hjejLRiPfQy9MYBvDAOiGH0HRKmLw4pjmVoKxv0E7vPMFJmcPEB+K8ECQpYSMqUbGAYq98jta8J3PYwMTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 19:42, Joanne Koong wrote:
> AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM was added to avoid waiting on
> writeback during reclaim for inodes belonging to filesystems where
> a) waiting on writeback in reclaim may lead to a deadlock or
> b) a writeback request may never complete due to the nature of the
> filesystem (unrelated to reclaim)
> 
> Rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to the more generic
> AS_WRITEBACK_MAY_HANG to reflect mappings where writeback may hang where
> the cause could be unrelated to reclaim.
> 
> This allows us to later use AS_WRITEBACK_MAY_HANG to mitigate other
> scenarios such as possible hangs when sync waits on writeback.

Hmm, there is a difference whether writeback may hang or whether 
writeback may deadlock.

In particular, isn't it the case that writeback on any filesystem might 
effectively hang forever on I/O errors etc?

Is this going back to the previous flag semantics before we decided on 
AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM? (I'd have to look at the previous 
discussions, but "writeback may take an indefinite amount" in patch #2 
pretty much looks like what I remember there)

-- 
Cheers

David

