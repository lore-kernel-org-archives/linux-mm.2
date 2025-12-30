Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E8DEE49B4
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95C16B0089; Tue, 30 Dec 2025 15:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FEA6B008A; Tue, 30 Dec 2025 15:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D116B008C; Tue, 30 Dec 2025 15:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A73FB6B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:48:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 474E513A3DC
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:48:19 +0000 (UTC)
X-FDA: 84277325118.18.6F5D55D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9D4ED140008
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:48:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jwwdB9tJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767127697; a=rsa-sha256;
	cv=none;
	b=c4RlCEND0VegizlmH+779J2LK+asvjbGZho3j6WvgW+kAYv2rrElRVzaSJQjqWc6a4jFTh
	fdVRl8cF3KkKmiUyOoXUiE1rUvXWXxo6gaasha/V1RwLt9xrcMGnTeNXf6iojahyh1JYFp
	GaPobeCGl7mIWO0vTIFiC6d83MmMVE0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jwwdB9tJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767127697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zJxshmnhegaVuUEClOYsX6tJYCRX6yjEFuAcQKbnug=;
	b=aetepVva/UVdUzbITxOz59LKRQqaJI2FGa3rXANj1QlsTue2FHUCR83axLGAcCJmj/J1V0
	u0GqQv634iMxHA1fx7DO82fsUlc/tGwbcWBg1iBM2pJGNLI0OxCCA/lKIdRsJPcKJ9lsom
	6IK2L+gKzwAv6seUTDvfXJurHl170iI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDF8560053;
	Tue, 30 Dec 2025 20:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B05C113D0;
	Tue, 30 Dec 2025 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767127696;
	bh=CI1QY3Zhmo3JGMHKjbGTc4dZCu2SEwDklZzLYrrVq3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jwwdB9tJ8wCvyrXDYUQBt4xsdU54ACfHuSLuV1YgOntgKTVurNK1YmmV6S3S0XgQK
	 elLSvTVLikZZrm5DpKhIAYPCt+FmOAqjdHlJE+XptHs+JBgY4m76cG4TZBpY09gOcq
	 YUNCdOqVElNWTq0olaPiglEO8iLx7cO286EJq74KX0gQ//D8cls/j2K9ziUipm6knt
	 BQIVKHUHNL/qjAY5PepecD32TroNstc7u3glDcp7SzkPL7ZG/Nb64U5Dv18ryQd5jI
	 FjbOMpIboPXHBWYF+8t8z5id1yTISwuPorGrgTZcvyLXou9oPN10dptOtKhTP5qdeD
	 BN0S4An7A+TDw==
Message-ID: <d1f9ce52-6849-4d5c-aa7c-968f105eafa9@kernel.org>
Date: Tue, 30 Dec 2025 21:48:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove unused function inc_node_state()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org
References: <20251225015445.16727-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251225015445.16727-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D4ED140008
X-Stat-Signature: 9chd97qajweo4u3q5bw9986ws4f3qaoz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767127697-617610
X-HE-Meta: U2FsdGVkX19wDhEF7fIhl7pgL78wPOy7A5/MLjXjK9wcH35AzwOSMH6YHTJ8h5S/fyUDLIDXh47dj2JftGrEbsk57mzcdKdRW4LHQg9gJ0kDZS/fZIiQNv+Rq/tOcFR5W+YJuiVJd8vhHvHwhEsKTmswQ02Ek072J61tqb6N2oPfzHI/BBXBoisGnft8SOs1HnC+ru1PhPA+RqUsy2MhcReULa2FhhSZtfu27n3sZDyd1JrqrDXXrUlIGdYVsV8aPfOKMydXzjAz0wu4vK/id4wCJmcWf1z3lO5SKk0lAZ8406aFUnyM71eV+PRnLQRJp8smOz87+QLDCLp3S6Axk7lOSIxk5zBThr2RRTxyTVSBmq3laegXpT6IcjuY0k4hgfFdYbdU935iDr2SVDRJfl08Zqu+KRQiAnXnNytMvIcOXbhAufvLk9NtcIfKuMlPdFh0UAWDwhv7dFY1y5BtiZ8MhPiLAQBDYQ4qnCcO1w5A8S6VcU1EXbX7ozq3CfsWVSkOeJQ+xips6DjaUxsiXxKDzHDz09MVCIqh700/acTqKm+J8TXJQhluFi2B5hufGix6JNjk1v50F9QQXbkswAy+oiicMgVozF7pe9l3nljue0V7oKnHZRN2LG0Vj4YTVZ7NeCuLY9bylvQI15nOySJpgfWrggudLp00uVNmzDFiYG438fQe0bvsLbB0XjOwz4673+x+ytuW7TiwyrqXxuLzrMBt8d5Xz4IeLtSY5oo0QZhgkGrkfIPq1Dwuex3pE5Xpek4Mk8JvCARiy+D7AP3fnj0p3uXlktkCL6uoZ0zLpx74A4UdQwm7fyj8ZzwAtzUI3QTmjM/XRD0eOhV9Y1lg/Vi3dOCQ8tMhGgn8MOB7BfWZjBqvyNB2dXm7TlVcFQ77fKs38lZdovugqe++hi04CbE9AxGzghox/KbFSIuguZOhFfBzw34N9h+x/YrU7Ox33kLJyxSuPXXvEVC
 yNmxM6Pa
 Ypwmw0aG0kX+RE1ZqfeeISQbvwCVHIZX8UgmF9HifpnhEPVKUS0FLyMmuBRXAf1HtZL0u5BOQOq2etMLkiUPTy5b5Vxb5bA5G3Ycn2DnKci+fuD7S00N0LP91wmulplqbY2tP1z7B77OupzRsjBxDyHiwCmIC9+0bcpC3VbZLj2OvTHxB9nj729oRWQBkuux+MZG9fYe0xn+5vPFA6AbLpUZcG4S+aMymlBLxejijX8YZeXurJHXV8jaEk0KzBdqqtR+hx3yLD1rPAMyYZ2jzE9Rb8n5hfYSUFABTSCGh72WGaiD7+apjupgV8mpldoJcjcGO7Dqi3GRg3doe2DZTahtM1E527C6Hsl8Z0kl4mI/oEVEJPGjJ/ru9B9iQEuG6tIuNcKPWpYQNyKUnEGrBFfYpXYakONnbW/H3A2fpzj4B88EyCynKNR3uIARLECy/3KF3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/25/25 02:54, Wei Yang wrote:
> The function inc_node_state() is no longer utilized by any part of the
> kernel.
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

