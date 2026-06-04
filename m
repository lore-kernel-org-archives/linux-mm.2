Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7BFCD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED69E6B0005; Thu,  4 Jun 2026 08:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88156B0088; Thu,  4 Jun 2026 08:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D9F6B008A; Thu,  4 Jun 2026 08:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD2696B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:09:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75B65A0758
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:09:00 +0000 (UTC)
X-FDA: 84842109240.23.918D5DD
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf04.hostedemail.com (Postfix) with ESMTP id 671E740007
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:08:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f onYTS8";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=foArchTn;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780574938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxzDdGArql93wl+UDTip4AmU9SdWM/mbV/Efiw72poM=;
	b=p1OHfpQ4cGUgT1++uagec5LWIVxVyLnT4gjZOVnTuQyNPfkp2qsuAQ1KF1/661GvO6xeYl
	AWxCPxBsIzZhIVez49dIXue4jpOLL/6JmEQ5k2PeCNXU82OzCSPsnRDZ2CdNMuywHMiJqb
	41JR8m0B8aMVq2ghUJKR/xSxUPqqv5g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f onYTS8";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=foArchTn;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780574938;
	b=b9s5+8Oh4JUEKl4xc3a9qFBXy5eM20SEfARURl28wAqKlzJEWE+dBDIbrxJVfhichl0p4C
	OlNq7t+btFP36QYj4Ss+7++4OqZdHzkkDXQFOuPMBmHbJ0t4x0auduEC8UzoNv4C7UC4qb
	KgQirbjNt3XzIDH1COPlftqh5DDiqy4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3F0357A0137;
	Thu,  4 Jun 2026 08:08:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 04 Jun 2026 08:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1780574937; x=
	1780661337; bh=SxzDdGArql93wl+UDTip4AmU9SdWM/mbV/Efiw72poM=; b=f
	onYTS8G5WUBWZfTiCbDP3DcEcuE97J0Ktk/ChzGZwcFIgtynCX79lY0cRZFEz7fQ
	1r80+80/JxgyQUJA1vgn1YlnsjlNzMBAlqZt5O8EtTzqEtRnQijqDUGH9qCiQF3K
	TLNAu/ETJulHhAUcmyA8KnQFxzca33TYZXTUagVaNnOF4WxbUapoDNompZVCOi0C
	9K667/Zf8U2aQ+sPMIX3oKiCksS2IUWgQt5tHFdqUDPZDaL0Q/cvLfQPDTS3Db/J
	YORhhSmgBMCFdhWLjGUu4h3jvOaLzV5Ctg8yNfvbQPT45/mH14zxYVIF37fC7cC2
	y1TIKEpoPnpdYTBWQPBWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780574937; x=1780661337; bh=SxzDdGArql93wl+UDTip4AmU9SdWM/mbV/E
	fiw72poM=; b=foArchTnRc/UV/WiiEQTQw52VFqwKQI7f9dVTI17ZsOxATDOGUU
	IYlUc2IiRGlVHA4IJx5YS4o/CXZUZ5PaOAJiTouZxgLm07sA0mdwkix8c/mcyoBl
	sTfsRutqMeS5Jrj1TBXB8uGPAgKZCMiyax6O7B1EGl27YuvvVhAiCJ5N8PqwmhSg
	5PhAqfLAkXX4wHyJuwvbCSF/35s8ouEjstDVBRS4VHz3Cbh3kmzddvx9OdV7pkzF
	vFj9TRW2dm0AJARNNSYb9UGEV3vbEZFi+Q+zNXcTbUrVS1AU97RPkEXhFs81n5HC
	G/1NvS34gfmU0/nbbEMTadKmeuJO2vjrJkw==
X-ME-Sender: <xms:2Gohaouw1B_yZKHmaCMlGFrN4cfsprMFkoxBmkX2Neer0JrQZZ88Fg>
    <xme:2GohatDc4URR__ZxS_w92tRJ2jmxY1ZV-Y-fw3ENmbzgD38wfmuMLUxMVhh89ObxZ
    vRUxezf1vVYglurJ6FcNWs_bODIcVLGUuyovqEMzuavewEyUSxTfw>
X-ME-Received: <xmr:2Gohajbv-EqKDjLrEC6WA77TZQjxg02tsDU6UVleSBQP7uRWU7v-mhatTKLKuw>
X-ME-Proxy-Cause: dmFkZTEyVRy6AhRXjDucvybhkcH7HdvssV6wsU+WT75hdzOCdR8/jxXF7Hmp1JSEuezI8g
    hSRI4mCzUdC+jtxZJOnQkyUOhQN5ocyyfr9UBkjiWqnAFJmy31gbxmAf91CP7OPWJHKk6i
    I2EVkOyH7cuFYgAswWFNyUaX0Gj4wdPFosaKq3uT1Ko1hejU4mwr8moJ1jy8YO71kbNsL9
    0epn7Xn1IaMomabO7PGoMLq6xTyWn4suJBGbZy5sAdZPxpQRIpGW3CPsCtjctOUpcIcfGZ
    QBdaRD2VrUQMGs/JpRN0LenF7LjmW0ORhA8SBXDhNZJuAas0cQjkTHVizuHluVLo2Tf8K/
    4npwduDZZSOTc0C6pGJ0/epY7WhwleTLswy2iHMmSpxgZNTlTWIZJHWG7A1R0NPYD2IKm3
    Ki8Naee8zrEaaybxlXEJtKzLWNnJ9yTSdtTBM21YwkNCJpnlD5nA8RZR53NdBCpJruEnM5
    MVgWdbpB5OYB6bpSomCw3mr2teKthhc3sMPP/9U4m670/Lg+px62Kp5dyyamnmWOiHUk0Q
    9ekGHbaZwBm+5il4O0P/+isTbLUBCuP9uhkXxCLEVdt9IVmaPACaGGzbjeySZFiugupbJM
    WwZOZ9N00+B2OrNr5ieVW5q8iEhNgd5p5/1qv92OHrTxwdc037bRbv5vY6PQ
X-ME-Proxy: <xmx:2Gohan-9Y6BOIPDdueOEnNgxQj7OKlxCwDUYXGAPXTuiw6TTPpexdw>
    <xmx:2GohavhQHc6pnEQ2rBuPphrJYDi9EsTyngKTwcqNMo-EMEwTuRkZfw>
    <xmx:2GohaqiHYK1whEngZYhBQ9eK-PLqj1xlIgmDM9oEzptC2E9amAUWrA>
    <xmx:2Gohal7O1sA7w8ZlsdeFUP2-c00LtMcS71WK71kUWGhLXdsTj4eT_g>
    <xmx:2Wohal1S3eLkVsHmajPCHaE1ScmSBxo8zQuzHhr47PAPFOAdp8mJ7pov>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Jun 2026 08:08:54 -0400 (EDT)
Date: Thu, 4 Jun 2026 13:08:49 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT
 and UFFDIO_SET_MODE
Message-ID: <aiFplwrPTalpnQqn@thinkstation>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-7-kirill@shutemov.name>
 <aiC9Be5oxT8u1Z6E@devuan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiC9Be5oxT8u1Z6E@devuan>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 671E740007
X-Stat-Signature: a6esspbqfgco1xwtc7a7g18ope1knhti
X-Rspam-User: 
X-HE-Tag: 1780574938-645167
X-HE-Meta: U2FsdGVkX19jTllzhEDOtCkIIVBdJiVCqOrUy69KHN8HfulTAMnNadwnhe/CoSZndPHUrE/x4itjqDgigIq303kZuQAXbHjauSEHwcAtgAHA2T/vLsjv4RhqbMmxi2erdPQUXXYKLtUoXrsIW4/cVrb5eJbTb8BlpReVhHbVYpQe9KPP5b0LSqt4mKxzZnSV4GQ16T3BPRLcWo3IOi4v6DNfHtgZ2q4VjSBj9SaSzDOqlsmfkGE+aasd1wIrKYiERuSipnVKE5n+eakUQsdGfVl/XEAcsQF0MBvH0G/BtgU6cU3wxatSnhH9hTxpckXfO0KWxPMl8rJYWUwbvs7dsrv80wPUbivk+mGRRv4zr2V3SVVjyLP7XS2cTEBdXPQpMeEamTNOaI4koJBdx19ajO9dedYL/feZkrYzmVetfQ3hNUKYbiPzhhkFN/JYj4ZRMyMZq61Z7QgTlHAhA80Dpa+Fhdbiu7QLH1/Urr4wEXUno+MZo2cVlPa9sXP/ZcWhW5pEqTFWXiQ4Hkc27lrI9QmznD0jAJ6HDnfSHYdM/qMAWk/ppvUiqSuDiT1XqmCF4ytAqVtMBMFT2CIhw2Ve5jIOK8+R7nDIwK6cO7VcsZue1EtUVhQWzotMirgjYqyqveiL4JcLRsnPV5lVw9oAvaleBCM1+2cZV7c8C7eo/sz1tI1jH/IBKN428qmEV9JfkUbpTwase15e5reMCOe8hNzP5M+fGxVp0L9jaIWHaWrMTv/BC1sQRI50uN/YsP2BIiUp71ZqehnzCbSjo41yJCk9jw1FoDlvMcsi0YPgT1JE3Rq39ey2RPtnRkMkNMCYAX/zJ5LtVzmIaUU+QuyomorZvNpE3u8tguZG+qpj6Of2pg6cWONiJbnRR8kbyK8npEFHJxR87se04Mo7ZKFhtw+Bhjt8T5l52pr1IWH5HvInKjNjDZd+s9QK2EyVKPb1hamv4czg4RkAhXVhw3U
 TRbN54Pk
 mET8dKc6D+PU1YJh5PTMElN80yFd4OsGnKdM7R4Rs2coHVVhDghy+SSFvZgWdaMtHp6VVeE9RNn829JgxbgKgUKaSDj+l2hnKP8lm1HluFi73UbbW5cqdaLpBnbFhyMqXBACXWcNN9zWY+dxYxc5c1GY7IPCkt0aDV9DIJd3oVy7qpUWif3ssuG/XuuK1BrIw+oRV7uM6mp9jmtX8low54G36fNAsG3lgRewsG42GUaT9phGA9Cfc7WIyXxMhKRlI+si+5tYAv/G9ZuQ4pmsRyudT0OAK5YGxy+DQl6i4lPZxI8mK1dmJ7aCLTz4ijhM6eQqGfGcjMJVKsoW4cGEMrLarKpJdiZSdzLut9mbRm+H5Bd9whO1D2Wv9fG82rjAK49u4xSm6/HPKlackrjp2neTI8yZeNJ58i3Dknn64NYUpL0jQl9e3GQFvw1euUjNGV0y0wuv80k7cDLxyrj6EBFfXdb3iz/fQerq24tdI+BXiu2Z9JfiJOugjoQTQF3QnP2oq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 01:47:42AM +0200, Alejandro Colomar wrote:
> Hi Kiryl,
> 
> On 2026-05-26T14:41:49+0100, Kiryl Shutsemau wrote:
> > Add the two new ioctls introduced in Linux 7.2 to the list of
> > operations supported on a userfaultfd file descriptor.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Patch applied; thanks!  With this one, the full set is applied.

Thank you!

But it looks like I was too optimistic about Linux 7.2. Looks like it
slips to 7.3.

I don't expect any API changes in between.

How do you want to approach it? Do you want me to resend it with
s/7\.2/7.3/g once it actually hits upstream?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

