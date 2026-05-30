Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11163CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 03:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45816B0005; Fri, 29 May 2026 23:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5E86B0088; Fri, 29 May 2026 23:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CA86B008A; Fri, 29 May 2026 23:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACC9A6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:35:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 474054032A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 03:35:12 +0000 (UTC)
X-FDA: 84822670464.27.FEDE7E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 823FCC0002
	for <linux-mm@kvack.org>; Sat, 30 May 2026 03:35:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s1RPw9w9;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780112110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIs51GCFclDB/Vc9140lREUf1aegrakGz3vmQyYrme0=;
	b=Jt20qgzuskNHINax2siTvEm8u8y6g9LgNf4iDpdJH3D59aEsa+BgkHHvw2ZQ/z5HdENlNb
	Sto0ovPlu9ngFKUrAkoMby6LLkoxyBqLPQiZ+P7pRTU4jiymgapjaUmg6vW9EWtRMeO56i
	TKt/Zt40+Uot1b8DCDt+XBM26Pq0sik=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s1RPw9w9;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780112110; a=rsa-sha256;
	cv=none;
	b=v4yVXxKHi47EsMq4qRYniZgrahRISZJT9aOkqCBBMsKblDIgsP2fkRN5sCOpsf79+ocC4Q
	0/tGoIEuKkhdlhVOsJghQvUlaejVPiDh0VRMApqfxNYidgddegAtEXO6FSMutzT0r3uwaS
	ARfqykakcY4oYnGPVCLuvZb1Qqn+9RQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9FD460103;
	Sat, 30 May 2026 03:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECF31F00893;
	Sat, 30 May 2026 03:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780112109;
	bh=eIs51GCFclDB/Vc9140lREUf1aegrakGz3vmQyYrme0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=s1RPw9w9TCsxIJbfW++ELo3GCo/O8fPzcis0yOe+0IWbn6nMJ/P2T5wryOB++OFT0
	 cKGqOnbBLqaJSEjKg8SNZjS981QOzDI0s1h6HH1zxL2kd5qnrczmB7wddj7t53jmzx
	 afJI97ktmOXsLJwjhBMj7JVSMrq8Xu/nBFdc5Jcc=
Date: Fri, 29 May 2026 20:35:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Charles Haithcock <chaithco@redhat.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Respect mempolicy when calculating surplus huge pages.
Message-Id: <20260529203508.a1813d90f7bfb638bfdc815a@linux-foundation.org>
In-Reply-To: <20260527224848.1753560-1-chaithco@redhat.com>
References: <20260527224848.1753560-1-chaithco@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y8ngzkii5rdrdwudi4c1effpmefdbpo7
X-Rspamd-Queue-Id: 823FCC0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780112110-666983
X-HE-Meta: U2FsdGVkX19TdDPf3tDHd9qbjAc6eLB71wlCGwZQ1B9sguwyLomNcBI0bXgyM4Fyyw3tX8WPAEf2GXlamRGgrAm+wf2G39o9CeD6l/cOK+i/GAmVOtVaa74Wo4ZsnthoeO8JBdAyKhVpvf895zkUoyy47mu4UFKZGx4jA4LkBARah5o0eVJJmuEUTWO3o476c2Wk0LEqVmgePE/5eG+95iiJDk2E3d4p2cKBFUgbZp7WjXRNZ/2AiSVjV98BvhmxqF2NbGxDccqSjJFfn9MZJnW3Jdf+hkgcd8Wo/87+hsbYsv0YPK5fAeufMkMOEQL30IE5W7e2ufOcLAArD4xZqfVrtklSrH4eBYbUATi1V74qbH6nKAwuVC3K3ciBlMi0Ls0Cwad0OjfPdakM8sbHdWG3lbXLaB2owyC41NAUeeNG/i9bJ8o+grhn4WAYHq8vwQ7TACivCCYyQ5uSIUyCoDcoCiX+MPa5Ylv3CfYm9X/yycG74YSHNSwCdcLeSD+Mdw/u+18ghfl5HA1hwSFW/7X1CjsCpJgMGTDe1RZrQ+MRyqR7pJVAxrhvU6WiHokAmWn8+OV2lN72AjfVo/bJN68OjyhVTvUq8zRTt5/tpuVAMp/WJZzjP9JiY/SaxkI18IxVk+ko7/m4WgosM1w+cozZ9B9+mpENUScltRKBn7sGkvKt5nulZo42STc2kJ9WN2Mf5N0a+2s6Ute+M24wsXvHz4RmKAe9Ju48mUOG1V3DY8W5SmcRCmVWIE2F49DZoXQjAFihLWvMUaPeM1r54mzEBx2o8SO+bxrYHy3KklK21bTwfexRDKlmyySznZ8JrTU87rhAymSeuzx4foKqPd4XMr4PI792wraMEk1Q5emzsg/azZ7AqlaO16j3uSDpV4oxSxcBx6SnTp8fjJWS7EjIarQqQVIkwY6LM2AgDWnvI5+eKqJdmvynd6MFyd6wrPM8AcRV5VkJbXjdYdG
 UJuo/UUM
 Mj0vgm9HWvLOHuLUHVlo1/FbbpxhaC9ctpibsExMq7vVUqR90ZNHhtj4xe5lym9p4CH14J3DOOnixFTHuv4tsoA8wpSHoU+1s0KSmhWL5p+AMFRnI7SF6FcXo4CqyGXToEr6ZPhsOO2ImsR7APyOVJsdD2B1MP3f5LhunCUxefq77xdBeUi1hxiVftEuGE1V5GjB4xTvuCow46Xoz2MsR1cbTbMVbHXu6n94tasW4erOA1/hGRxllH/4pVB6B0loh47O+JFFRDp5Szqov4UoOOQXoFigHAwJf+L3DQnx4FwfBZCNgXKDMeMQ8Oi5ZYx/YEA6zZ9N98cXwEmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 16:48:46 -0600 Charles Haithcock <chaithco@redhat.com> wrote:

> Presently, when calculating how many huge pages are needed when
> reserving surplus huge pages, the global count of free huge pages
> are used. When reserving with a mempolicy, the global count of free huge
> pages is used even if some/all of those free huge pages are on numa
> nodes outside of the mempolicy. Fix it so free huge pages only on nodes
> within the mempolicy are considered.
> 

Thanks.   AI review asked a thing:
	https://sashiko.dev/#/patchset/20260527224848.1753560-1-chaithco@redhat.com



