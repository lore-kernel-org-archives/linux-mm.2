Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A39FCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6253D6B0005; Thu, 28 May 2026 10:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5D66B0088; Thu, 28 May 2026 10:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5125B6B008A; Thu, 28 May 2026 10:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 440CB6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:22:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFA0A162014
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:22:12 +0000 (UTC)
X-FDA: 84817043304.01.0DA58AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53B99C000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:22:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTAXXti2;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779978131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCxXOOp/yUx121CEZTpw8nvD7NIGGxkDJrApCRJtPic=;
	b=sAwo4IqJPT5r4ILhnAsBBJfIkbYZcuZ6l/0mHlwibC9KhbMHO1HKcCDfkxFMxKxnjy1Na/
	oJZLyJdCwpW3kC3m2sT5ZMn7SeV/3rPDrLBPi0DwGD66Tes/0wlRzQWD1Ux7n8uxVLIlY5
	/NNTTMTnt4v7Jq9KppaeKEZdKJXYSgE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTAXXti2;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779978131; a=rsa-sha256;
	cv=none;
	b=rDczXcfUlOMYimw+oQQTqRI7ExlHHFErjD1ubIT2f8v1+5rz2QzZfKYZOiIqOPuC1g9W/i
	AhBlpvlANviCRXnI6uwRZRn0OqY4JeGDvzjZ7SwUxjNe6oZVnhvw+SMHN2n9snP+g2xDq/
	6dctJpZM5cVtT0+1SMgH6HaurRMEXiM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA0056022B;
	Thu, 28 May 2026 14:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DB31F000E9;
	Thu, 28 May 2026 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779978130;
	bh=fCxXOOp/yUx121CEZTpw8nvD7NIGGxkDJrApCRJtPic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BTAXXti27ObzHO7JJa82WJQDIFybIQl3Ih24/PYynO1I33Ne3ZjCd+aUCVfpDsLus
	 GNvMVLrmFqWare3t3JHiVxvl8XWnCf5b+Bs/7GcgmFIRcWHUJHOgT/5H+lRJo4ae03
	 vz7ut9HtWRsPzGmxWNTHExiWalQzyDC15RQUklKAkXGuD4wClFs52mm/rrmCc0cW26
	 ghettlNwW+FRoRKqBwwxYXzApjqyun5nzWoeXGk/gX6GpYcnf9LM3ygCqrnsD916CR
	 hg+ioPTRsTqtHDoYCkwkblT1/0j8k/WZ+SoSbJBNDUzggRqamwR38/sqGcy+78f0O1
	 kuEutGDK3jdxQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org,  linux-mm@kvack.org,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liveupdate: document current compatibility status
In-Reply-To: <20260527153725.1770394-1-luca.boccassi@gmail.com> (luca
	boccassi's message of "Wed, 27 May 2026 16:37:12 +0100")
References: <20260527153725.1770394-1-luca.boccassi@gmail.com>
Date: Thu, 28 May 2026 16:22:07 +0200
Message-ID: <2vxzqzmv3980.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ynok5d8xhku7skfwp1ipn6c5d3mhh9ti
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53B99C000C
X-HE-Tag: 1779978131-247469
X-HE-Meta: U2FsdGVkX1+iTmzehiFUfQFXOrzh2xYX9397oonxrIPY0frDThgM55OMDZf/Uva0GuU+prX0K+px4in7UoAMVX3SfOYvNcH8+qBr/tWG29PwN5FZURbUXBMheffmmsMB77KbJvzU1I5R1d+htaEgkHUxh0Cm29M/exdt28GZEpcihjRi1R/GkPBzg1VaEcU/jtxO2grFUovUFc+PaXrz/AefnCCIDyQBykLp3q+OsXknZ0t8KMDTUcoLpTe1YTqUxNwqVLd6J6ouenx91V02KlQ3FjD4fMjdO4tK4Nzrk8qSs2t8iZIwvJcruvLTcljAlEwWSAZE3oXyTo2yiYB6yTzNY5KTUz/iCoYt4D7ovuBQk9BYDj441/1F0/Iy3ElKLFL2WIdd70HWdcqUuA0VQSdbxxH/DasK7G3vSL3llzqnqVBMC5JwOjW+zocEfuKKBpRji67dXMHTwOIkuR5sL6WTxu6foQ3vApCudp0U8UCjyQyx7kL6cs4CPBwLm4FHpohQdWSLbs6BwHCkI6qqowfiq/3kEoGmwkkDpXvYeepJwehhqTrylsn2dRBeaYXfOi8VBhv6bUXjrA29b+VhH/2V/dtqBgY1uxK5v2u29JWoKXrfIkSPvlt7khrBUFYe0CKVl2Fzi1BPdMr6rXV9x15uROI0yPdfCUwLnOT1mI8eSaurRBuqwlN+szn9RInTFgbfzUr3Nw8lX7IzMgPDhTMvNdCPJuAAEIHII1Z3TVOSGawY4LgNm+jQIXDrLqm/7j+PWP7jmT5yfRm6DHbqbodOZ/yZfRxmkZaX03Vnlmfh7e6lHwzU36FqJo3g2EaWP4ye6jvllIgdcuEJt1gD8wv2i+eFrhmWCuXD2tk44QCH010xFZShuJo0v9ofRRTpX2vq0ozcQNBHMVP6TuEYvlRDke7u2xOOIf7bXrBQFOiq+9KLylXcQWBf09souUvOCpPAJ+sojQK7ov6UbzS
 hYTydjYk
 tksJepgw6f7e+18dx1OuPLKMpm7luHS8JeLhJscDxinKiszfrI+zob9kGki07kIai3de6ySIsTkqwuB23emPbZ7Xdw0YXmU5Kg+zU4eBoPvhozQoKbjg6p6LuYLwq7gBKywJyClDJ1n03ixBiPnGPyOGDI2I9+vQJnABgvpEzYC0gmyhgLEF0VOmoGfxvkdiWcL4WkPzQw58UD1HOmke04SBrTaqqCnTB3umOEGdo3rG39ysrKfkzdu+uiJy0BRtPDRejHe7j7yT4FmK9CumoRELhUT33rHsAGRmR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27 2026, luca.boccassi@gmail.com wrote:

> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> We currently do not guarantee compatibility due to ongoing
> development, so mention this explicitly in the user-facing
> documentation.
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Acked-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

