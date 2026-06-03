Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E35CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663B86B009D; Wed,  3 Jun 2026 11:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614316B009E; Wed,  3 Jun 2026 11:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551686B009F; Wed,  3 Jun 2026 11:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44A8B6B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:32:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBD701C1A06
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:32:21 +0000 (UTC)
X-FDA: 84838992882.08.F7D6334
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F461C000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:32:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBjAKwNW;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780500740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phx5JcnRqGG29OmuItoF1MyG6kbDGtyE55/LgSKTFQI=;
	b=d+ZjghMSBjMPsJiiOoExLZ/RCXIWmmrLHNCe7PA3+vo0puO3tH2xAVqZoKEUChFLdmosF2
	Cfvv4EUpV5O1RccV7cL2LiPJcj36oUvtsIL+FXtoxxruo+aBR1WztF7hi3bUzdtah8FrGg
	kDIjmPs5QBpt/ih7k1pC0H/fzeeSJ4Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBjAKwNW;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780500740;
	b=NlZ95nkafBNLxIxnSglfyWjba6fo17+ru4SXKylOpWfPyEU0TLFZqvI4cVagym4aZoM5Y9
	TUANw/ctaay+Fvr+e3yXxAjlGYo9jdTg6P2rJMvBa5GWeu5zgc9SfXN0Zib5c8EswCAHS6
	E8qaHhK0QyrfGoxosM70JhQf0YQLEcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97A12601DD;
	Wed,  3 Jun 2026 15:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D931F00893;
	Wed,  3 Jun 2026 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780500739;
	bh=phx5JcnRqGG29OmuItoF1MyG6kbDGtyE55/LgSKTFQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NBjAKwNWWkdXPnLE43ZMJidLUxB8XdsOO9xqQnl/3aN33mYlvXyBD3L40D4TN8vtn
	 uPM7V5kP1pgyDn6pqyCu6K1Zbb3c7r/VoZNKKqc1/WQpvjiMSG0K51pcZ31ROU4/dx
	 dO3AgiJK+1ObA9c/0zQEDY7f/1YZet57+UbbHYGe1KwCSMV5UAJ5iutGFModUrXm8a
	 pGAozlH4yewc0IpBUO2V4JFgBEjRMrJxIsr00TrJ/tB+cCuNC+DVasC+GdC4Q1xZm7
	 dMpCDpG9dqVLnCzUSC6/n+bfeSP8W6sBWZdD+XIXyO6dqqAIpw+7PiOTGYg9mq8AzP
	 D1rxX8HCPL/BA==
Date: Wed, 3 Jun 2026 18:32:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/10] sh: remove NUMA and SPARSEMEM support
Message-ID: <aiBI_QEmeVSBb2HY@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
 <agr7XvoWn_-axX1-@kernel.org>
 <adb1db8d1fbb9d219fa041776ae863aa2fc09270.camel@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb1db8d1fbb9d219fa041776ae863aa2fc09270.camel@physik.fu-berlin.de>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F461C000F
X-Stat-Signature: 8odrzbykiazegihpq653pzszgs7qszoj
X-Rspam-User: 
X-HE-Tag: 1780500740-187413
X-HE-Meta: U2FsdGVkX18RvzH3l2XwF3ShiV9U34xxYYx23wAsNr9Wb4Bos0VJtF7YZtXn5C0rctAbRDxKn7kHsM7Ol8Wsp9ZHj+ehtyADGPgXo51+sL/ElVZOydsPGWFQrUQLUWqJ8WIm2pnpAGgO5pdHUqkm3rl3pl4Gp9NT/itxLbYWAi/bpltbVYsZ9jU+gHIa20sb8Y2o2c9ihpO2uLX0TqNDoRGGpiqtXeX4C42l5DP3VrMK3N8MRJyj6yFFUSxOqtePg0Hu+LKgCf1hHaqw8/Ak8tL2+CShIDw0VfcGxfsWxr+xAaDjLXA5ioUHMU6I6t5b/QepYbC4nbAHgb5Step8N2221Ppi4HjDiBsYj+X+y5p+QISdB2CiQRVvYUdgGBVgfqGlTBa87J/jet2YM55wVdN0nnSPfsU/iwzHyyFuTEg5va0usyC1fiSSB5VMOamL8Uee6yzVNgol46zT74bWdEHOlShvSttmzz2boELkoEhS8r+qo7/gYaeFp+SYaNmsPLUX+vHnAVk6pEHmNnL+J/eg0h7x/nGKCYqJJDT1mp0SjaL01D71BlMfCY5Mq4btFD9LFh4GKfz2LHANg9pZpfnRImqCdjKWdevsgJf0/0m/NGEshogHrqMgHmmbk4lV+0HYIMO5iA1kevtDvIC6MmofPWIFD/fT+vFSmzGiuqcpkpoRFN85ANlLYnVutGddW6BJmRhdL24B9Es/NkwlC/ncxrn1D2sO0tq17dpYoAc80wtAWPig7ZHFyU5oIldJX13v8NtJCgYRXCVpBLGCcdXkBxYqwft3owqWiEihUVLBiZ12wH+OZWABGIr/KVH6GUxwTOz75JFBLY0T45BV6tqgjCjxkY67p5qGTv7wvL91yvNw2Yv1Bef7Zifbya1t0hNp9UgVrFwJXNlz7hPJA/bKff156u2P+omExCEzcZFqRNmWjZecmeHN8V5wu/Ll2KmzYcwP/YfAjPzli7z
 PccH/rlL
 98Gu2Ss+dunkhXUBz2VgKsyzHECHsSagDC4IaAXbOfj1YB8CrI442o7CdP/3fy1MQQO0w4+QjHpTna67BaWTsjZq2fA6rjbt5BE6kfic0nmiOcqcKSCL0Sm+u6wo137GXMf/RV9MqmgY4szny4ZEAnfHDM7/f/QmeUlkGwVpypAINSYs6mDKZhOLda4XPEOnvNuAk5mf/fD2rVCIv6I/NdBGgNdLQsDoYIxtcY0VN9A6+UnISrwT6m56d8EeyHefZu+8z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Mon, May 18, 2026 at 02:05:39PM +0200, John Paul Adrian Glaubitz wrote:
> Hi Mike,
> 
> On Mon, 2026-05-18 at 14:43 +0300, Mike Rapoport wrote:
> > Gentle ping?
> 
> It's on my TODO list for this week!

It's sad to see this being dragged since mid April (if we count v1 and
there were really minor changes in v2).

If you don't have time to take care of that, just say so and we'll take
this via one of the mm trees in the next cycle.
 
> Adrian

-- 
Sincerely yours,
Mike.

