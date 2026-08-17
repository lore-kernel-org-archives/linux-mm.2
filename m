Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0679C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4146B00F7; Mon, 17 Aug 2026 12:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64AA6B00F8; Mon, 17 Aug 2026 12:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52356B00F9; Mon, 17 Aug 2026 12:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F59B6B00F7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:30:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DEB41607B3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:30:04 +0000 (UTC)
X-FDA: 85111298328.10.462C59B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CBD3100003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:30:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwOEf1yM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786984202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSt6Jc5NlsZOhtaj7jirxeAg2gOOIvG336WvTpXoGlo=;
	b=rLJEub91Xx631eC03v99O22CJw5Ta3jOocItXDQgUVCVWQZBpVRutec2v1FPd4RY7Ug6dx
	Y0joVNrwA677FL88VjIp+bR3m+qUA8bRwEtlxoyGER0NQOmROr9wm6kxeJ7ayuo1M4GD3t
	hOiFGWtueSqBtkC5VoGZJ7bcL1MTX/E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwOEf1yM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786984202;
	b=K9ss42QohKdxDlfCL6SMr6HOttkUzbQWLnLoP/MAs++oXhujAngpEWa9jGkXOrs3P3qxAc
	2zA6UCNhGs6JQ6CAmffjexefxEyBGr6/pW6vSuJ7E0Ucdf6LTazGrZhKattfoCkZT8tGnW
	NIV7qjKVTUhMi+LDWiRuxExQiwYB/2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BED4600AE;
	Mon, 17 Aug 2026 16:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E011F000E9;
	Mon, 17 Aug 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786984201;
	bh=SSt6Jc5NlsZOhtaj7jirxeAg2gOOIvG336WvTpXoGlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VwOEf1yMXe96Q8PKjzX/91j8sVh665aI2y+5Y0LVVlTqa59ZzxnsqpuiV+lPJh7xy
	 hp/j6q6dCpnWBF4zkNWvuAWUVRGK77NUas9YyofzOEjg99k82gtnT3w5fzYDTpHE13
	 whYrmxu1KdPAG2BxjYzcp/UnAHHSxLFZ6/4iHV5+b7QlNB5vGNyLuanxXGX9WI4+N9
	 GViRqRz1c5jBvZZD656cAKEfaTcLGC4LABq+Bo2drpmytDMH0pSzgqTMfXVs0EcXor
	 b5oySlCYcDOxKEuwP+ndAMV+oJJpalzCLVBUoUUlTTrMtYOXb8MMzn3V1lve66+718
	 JFDYkl7W5qwWg==
Date: Mon, 17 Aug 2026 17:29:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <aoM10Z0wAKOMzsEO@lucifer>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-3-vernon2gm@gmail.com>
 <aoMynfFI2XK2UXXN@lucifer>
 <cd555188-2b51-4559-a315-0e8af6b2572a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd555188-2b51-4559-a315-0e8af6b2572a@kernel.org>
X-Stat-Signature: 6xfr1heyeceb5xcnow14a6sq7srrpe6d
X-Rspamd-Queue-Id: 9CBD3100003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786984202-310916
X-HE-Meta: U2FsdGVkX1/71hYolGkbD0wTBBPeMCxvFeM/IUP+UafyWSrMp5JqqHTi9DJ7mF1UlI7LLGgdM0Jmt5plBE+tS30N1mgPWuB9/Ql1NK0SFoBzuSs3avvOjzyNkOo9f4XYtlfCEGGStC9goQRoEN7vf5nxNoJgucg8qywddKbe5Q3/j0EPKWHdHFoHwTeuItd6eSTWiGz5Sb/AP3uRIbz8AQrklHf3BWV3cbqeVDBnRqS8t5VZUilCwvm2/1fvDaeVUB12OXVeUeV5zPenDEBGVAyPYsBCbwhwzlBRMY7F12TBWOrM60oURjaVSLh1jvZpSwosW7P6/OLDTewNr9cLxpBQFrznWuXOdD+hDDrnhwT1fZ+hXiN5+nBVgKtKdmYBnSl4zxgKJDUYXipYfzaqUyVqSBDjq8gknfO3kE4uSwRNkHCxJXdAOWGMvbkFN4c9k2szSxBFmrobNHV9h4+euaoGv2mjs2iniIkjTppafDFAFCgdL9s0mNnGHcruqM3BhWCqDbtwON05fPrN0Lhf1k9v85ZzDjhB0EGbfbJYAXWUWx4HW0bNatngDZmFSDZvTys9bQfvQ9ayQJ9NmlnwxStlMmv53qN/nZ2ZhPFfJfFvg3n47Hp4iTA9nJVJhVWaQlPUhlyYZ4DzlvbnmChE1vfsImaQmmwZAEeAYB9FUsC0z0Gj6aRaP+1hEuOhIUVMWsplw4BX108BF9YfEHJxT95zVe5DLJjTbkeoQ7AkffmXt0IsMKxTPou2PHt2h0sKjSTDwN0ozAIRI42aqq0xIDKwzJAo8SHPHQM1BRf7wxtcOBedkX+tirfA/kf+EIZ4hCN94CAC3LzdeOl3K0LdfFYoFkNHpvtqSpHJMNFcHDhnkmi2XUEPrI3gP+cCj8C8bq1cpZOkP9BtX1E8JZRF0YPOH3io8C1f6aWB05hLJmY6qZt1Omg7RF1pJv/p2OHFJw9nJeM5D+PE372WspB
 QVWQt1sB
 OlxcVMIYaCb/je03SA9E8rACiCNZBr53L13KZsP1173qKpKm0FO7PWe46NQrIZMZDFbrRUV1/sR0bJ1VKS1/ArogqSQtbK1LKkfCi75yudSmXjchaD5qpwi1784QY2Oi2n/Vz1YtLM+LmITvYGyIm4BVBKV3PKM8glkFaBuw1Hs8um1G6x0sh0jLAHdaJXDyzWRNZe8w+tdSzVjMsUvEoizp2GdAxs/yOoS2CC/UrIUZGJCHVb6hvPFPM4A2/MgiudAEQtzmfyu+zklcmg7C1jY2FcgL8Pd6VNlf6mV8YElFZji4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:20:02PM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 18:11, Lorenzo Stoakes (ARM) wrote:
> > Same comment as 1/3 I don't see why we should be storing a pfn value used
> > nowhere else just for tracing.
>
> I prefer it that way. Even if just for tracing. :)

This is moot because you have to store the PFN for lifetime for museum-piece
architectures.

But anyway FWIW:

Yes I agree accessing a now-invalid folio isn't great, but the reason I dislike
this pattern is that you're tracking this state in a different way that now has
maintenance overhead (if anybody reassigns folio or does weird control flow
etc. they must now update 2 things and etc.)

For the sake of CONFIG_SPARSEMEM and tracing for a value that is not at all
intuitive as to what it means, that's not great.

Let me go back and review this again accounting for the lifetime issue that I
missed first time.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

