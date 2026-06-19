Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1583CDB46B
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE0D6B0088; Fri, 19 Jun 2026 10:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD6C6B0092; Fri, 19 Jun 2026 10:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD37E6B0093; Fri, 19 Jun 2026 10:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880C76B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:11:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07423A0460
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:11:38 +0000 (UTC)
X-FDA: 84896850276.18.2072963
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 76C5AA0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:11:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+HldSM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781878296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ipm4VnnCUVKjt+hErgryje+qavsLSdr26B/MMNK2kNQ=;
	b=TPz4uGIiwU1C2mMS2LiR2KZiLZjX+1UR0x/l5mhUBy5BN4cVRn6TzxGomqP21A2pNBwsRy
	DmygQI6bEd50B3robCrehGZGZvX6iPIKpZ6Df4DhIepVdUFUxCCA+Ek/v/2EIs9ZHULR/z
	j1F18VszFrt7jNqWkmpql9TuH2NWJcQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+HldSM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781878296;
	b=KJ6tVunLtrWoPucMPPH+UoMZIXii1JcIZolwRut04XzFtYfTLPzjXaVeIeqYi+GAhovEJE
	qMeZDm3a2TfTeI2eDFLEIoR7B7MbON09KCUR7A0Xx+DUDW4H2vrEr21CKyinaw3/jiZpcZ
	n4Tx/z2TEwOL6jrWRl00iFR+kvgcL/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E30246020A;
	Fri, 19 Jun 2026 14:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4A31F00ACA;
	Fri, 19 Jun 2026 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781878295;
	bh=Ipm4VnnCUVKjt+hErgryje+qavsLSdr26B/MMNK2kNQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=L+HldSM1+o+tWkDbIG8K43jsuVzgtp7NdNSEk+Jfu5jaNR8rxpCcgZQ1MW+aX0c84
	 ouXIbhwhAm5lGTM1WmZActEB2i26IaKhRotfbVrV6y7ZtrJFbUSh8fyun8qtAftWem
	 /zWPuOMsg5zELZf+0Ns/LUncVu87F4uUCHkmHWFSedkUVNDkXLW3w30OT/4k/nxMx0
	 uWnROWM2Wa1zp5kmF86bOyH8vgVmiXn6lepY2aJlhkfkhLCJpu9AT1MjcbTcVQZ66u
	 5ZOTyvO9Gx5ZSwSrtrL8e8MfzACbVoRLnAmhuTcrUtEsF94lZ7t3KEtMpEPmkIrYne
	 G74ICyfzZFn2A==
From: Pratyush Yadav <pratyush@kernel.org>
To: tarunsahu@google.com
Cc: Alexander Graf <graf@amazon.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Mike Rapoport <rppt@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kexec@lists.infradead.org
Subject: Re: [PATCH v2 0/2] luo: migrate serialized_data to type-safe KHO
 pointers
In-Reply-To: <9huzv7beloza.fsf@tarunix.c.googlers.com> (tarunsahu@google.com's
	message of "Fri, 19 Jun 2026 12:00:09 +0000")
References: <cover.1781615759.git.tarunsahu@google.com>
	<9huzv7beloza.fsf@tarunix.c.googlers.com>
Date: Fri, 19 Jun 2026 16:11:32 +0200
Message-ID: <2vxzmrwqoc17.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76C5AA0003
X-Stat-Signature: 9t5exon784wqhy5pao1h14g6ocy4t61m
X-Rspam-User: 
X-HE-Tag: 1781878296-380523
X-HE-Meta: U2FsdGVkX1/PQ4XhvhVKOkJmDkaTtW7NVSGlG769iRHNmyhbEXPX66ZEkq8fAGqD4aWLKyhmla4Uh/nUDpcNahHh2zsbb4RUTwaMtF/In0ZZ7tQVubEfrrIS56BzyNlmeEDFYV/JG5lVIv7CoDAmVN5iIjF/oDMpxUEy+AQdwZ/sahHgfZj2tMdRAukZ77tkOzN7Nga7nxhOh2BQfAr69DMVRzsXcBAoW+CH+lbaXQy1Ws5KlEXxfEyX1iWf6UtOul22rKXDCERUqu9f8HN07ZIQgcGiwsmufRCvNjSm68JFdN2CZ+P4njc/McjNk8UA2c6cG0U8NcLbuuXphGPoEhuHsPdJcdnsVIvXoNkltaVDWfaDoZYPgKAPKNXxENHwFDodkK3e8JS6F8LuPIiqp8anbfRIOzsH0p7EbDPiahcIOI4GfrqSbZxIztEbReNbf332UiiPMP5mt7xIgstyiFXuraAnI/CTIESMCXUGimwdU6GSyoOYnNayP+j96NoaRjpNlUJBP8hLTi5mpGnWnU3FIcmc3myBpoSWhQbcURyaSw8lGADrP9th0Y4K+Z8EX7NQiR507DnXNqsviyYPAK5IhpZkbGuBiaFsESh9tb6BJ+XWuUJaxT9EB4ZIVWSbgPY4c66s/rO/9Mq7hdvktrqJ0cJePnLCqeX3lWxTjN+LK0s4jwfkSXW7s2ejVBKHB89l82l0MQpR/eDjtIVoaY0zPB9L2M+H/u8SlJXsxTD7HCVHQZtKvCQ6QLVpY3E88v5xAbq6TzkuCYW8y2ugtuQs/4LXXB4UfncmXuGUZ6/wf3CtwhdJ/NZl5E61kqxTywpJKuQCCUQKYRHd+6W/YMlYqKDkqcEojAuZIHA6umGsWYA/fQU/vEmdXvwv94p6AaXnd5VLWqoc6VzmCbfr6SUbZFOtFbqTOXHKyitCZNnqGdDC/27Pfdu85ngeO94nI+CvjdA8G2L9lwQzEJD
 TxFGdkyn
 y/n+9w85pp9pVsErENJvAxBiFkH/rAaD6Oms+ghqdVLltuxYu9ZelHM5PSF72WbyKy/+MwwKWAI0h0FV7Qv6ss5Gi09zWcmbf0asKvZupJHkBFKV4thiXgC6sMsilte2NKPE8io0lKfELRHGz7ojrPj9bqHqdtr+VbpjmPu1cff39KUCYCxOf4YGqjAQXAtXlFGs6yXSNVxMVqRdKa9VLYKPI2NtNQOhwyx1VMF35jOdK9Yj9A8igbnF8PmBfup4Nfg6SHAw9IEUBxQWZTtIgYtNlSlHvq5mlAIvqS9EAE1pQEe7JY8jvKXZRiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19 2026, tarunsahu@google.com wrote:

> +Mike, +Pasha
>
> This is currently rebased on top of mailine, also can be applied to
> liveupdate/fixes with no conflict. I would like to know which release
> cycle we are targeting for this, so That I can rebase it accordingly?
>
> As for liveupdate/next, it needs some conlfict resolution.

Base it on liveupdate/next after the merge window. Since nothing is
actively broken (as far as I can tell), I don't think we should take it
via fixes. We should do it via the 7.3 merge window.

>
> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Covvert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
>> This series also takes care of resolving the bug with memfd of using
>> phys_to_virt before checking the args->serialized_data value.
[...]

-- 
Regards,
Pratyush Yadav

