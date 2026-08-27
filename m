Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09FFFC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D376B0088; Thu, 27 Aug 2026 10:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F3C6B008A; Thu, 27 Aug 2026 10:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D630E6B0092; Thu, 27 Aug 2026 10:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B48346B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:25:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44E8B1A0444
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:25:29 +0000 (UTC)
X-FDA: 85147272378.17.561EE9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8ECA318000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:25:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osRi2eil;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787840727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOHcl+YD8gEtCi/bTLqLwavhY6q7rxK7kXxUHkLzivw=;
	b=InIjP0y3D0FrdPXLkbDhl1V8kzTIXIOpMbH5bG+nVdl9WifqRMjq8k2E15y3cs4651rW1X
	fEZwKg3W0fqZQoLvYDMQ9WvOPBAWYMYmO0ze0FBVr/w3ZMyBKjZcmErAGcAzjvIMmkKdDx
	sU+cDLj6BYexVGJpUy66UhEXRUqUPbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787840727;
	b=lRi+0nPOn/v6ynptnGFOOjbnx4QTwIY0ZNviz7NPdscLuYyK0PEwuT19eSGlB2TWRN+7nv
	gRT5OtKSOjY3Uix0skACEtJ0tUFs1huC5NtiQAFxVVvZjcuF2wUaRovMN8cbS3ANqqGVmB
	2edShqhVXMLI3aOmUSSXOEv3zgc9uAg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osRi2eil;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED150417EE;
	Thu, 27 Aug 2026 14:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA59E1F000E9;
	Thu, 27 Aug 2026 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787840725;
	bh=wOHcl+YD8gEtCi/bTLqLwavhY6q7rxK7kXxUHkLzivw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=osRi2eilwJMpP8iQBumtcvElkQY5/jAyAodwAUYUZpQIGAIonCFR/gATTVx/Cpx3t
	 Ts7zAsbkS4xom56+KVpOtjdAvfaSNjshVrGIAM8bjaxkJdUQLNkXLSfFQuzQp7LBcA
	 cB3aPDc0VGczsta8PXenJonGz1+gw3VcheKyWBLewo1GS7NJCyMsQruqejGX3xQOB2
	 Mjp2Jshitw9yDoq5YzBTLkpuh5d2yS42fIYx+iEFwWyqyygbw6kPHY+woutAqRUzd2
	 UdbVQTaYFCP9l8jlrao9qcXDtLoVVcRATIEjLjAt0HjemlpQAKhE2wnGKLF/azIReY
	 x5NnsCKwK3BQA==
Date: Thu, 27 Aug 2026 15:25:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <apBG3YnZcHhlvU3m@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
 <054cf257-f5d6-4041-8c83-902af87c736d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <054cf257-f5d6-4041-8c83-902af87c736d@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8ECA318000A
X-Stat-Signature: 6nqymb3psngsh9ddtxr7htxtr9ip3bxw
X-HE-Tag: 1787840727-191277
X-HE-Meta: U2FsdGVkX19DFiAv4lrlsUHLFLlW0tvPNHUkLGtOyaengCWXkX3Xt7x8H/PyG9CE64w8v1Cu8XVBHkaeCIr/EzgYo5d8FYIuoIgxvvofG3ZUAr2s1UKTb2G7DDFPd7JRAreUHppco8MPkl3+i+X1in0k2xCB6q5mbcF0RNmfxZipYM94SJK4AHjLpyDwJ4Pa7VzncxIqeVQBwzBobFR0Eyo3DtoI8saZ/xMK+CljPMPBt1d0p0aqEEHalk2M0s+jaaS1P78vnxtEhmjRC2fKTJXzYyysrPR6xYm/d9/uw0/qx+oLLwpnHouBD0cAx0uhR7s0CtPbYzoUrro2oBwrGzyY7GpjxuwMDfOFnMTTlGBHrW8jnV9RgX7QymCg6GLEf1gKCyoqoOTLuf0qlNmkqoP/QRc3bJWzLMPDX/+pj0LJk8rFeHUSCDHcuFyvRQrGOqt/FZsv5iv7CksOle8yj9RTorEuOshiZDG8w959i+9DF3cGVQraaAP67DEq3x0xOdQttqTSiplWCAyhuInMKeNwmmOocFffNNVB+Qh+oWdilFQkMwS6DpIuhOWx5FhB04dFq8/3r4RGFbDkmoxhI+kMvPi5rQ7yZuKUuqBrMm4gxs9NXUy5AzQFqu/QiPPuy23aN+3v1fXc7Yk9Z4ZEEhzeLYiIrC/KyzGJ0pQhML7OiIE74oRq8BmnPuIn6d5EwP5F18mPLSdgRsKzHj92zf97NP8TVB9XQzL51WM180VZ/LCmn0xJ033vR6GCgfXTntZ+DoBmXFdtLMAbRoOO7CR7QDiiu5xXPoVoTx/y1ARQwe8VKyfsef0BghZ02YLSYJswFG6reMnUkAy5uNO0OmkMxqPD5o5Vxn5InjHvCpNQNegk2JozgehaDDh7KkVna3nShds9OIDuGfXVx6AWVc7l6Es1ee8NOk2+jvZDa0dzEFzPiXlltOK7lK/r8GbdvtBAkVLee9USM7jcP8V
 n7A1VHBg
 Femc1Vf0K9sfVxWxIgQU4Zns7EBLYXNIUos7Q7d59/GX2rfCl6G4NH57YVB6HIfybYf79sEX9vBLaBrxi6PiU2wrtL6Hh8FkFIKuDDwvcOyxmqN4Nvpxof7lM0QC0GHJVE6bX2SH58AEbTsiZ/G0DCLhgyeAMKXdI19fQAU7j2avNevqW2hG7PcOz5i5XZQaL9SqeaOFwKqP1v9Ox62qm+XR1Wa73Hy6J52IPGp0FDKojNe0DfD6KKyI/XIyBjWcFdFBF48K9ZQdk/k+ebReL4YOZNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 03:15:47PM +0100, Usama Arif wrote:
>
>
> On 26/08/2026 12:31, Lorenzo Stoakes (ARM) wrote:
> > Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> >
> > 	~107,000 words of review across 948 emails (in 279 distinct
> > 	threads), counting only prose you actually wrote — quoted text,
> > 	signatures and attribution lines stripped. That's a full novel's
> > 	worth of review commentary.
> >
> > 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> > 	and your longest single review was 2,404 words (mTHP collapse
> > 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> > 	of your top-10 longest reviews).
> >
> > 	Estimated review time: roughly 300–500 hours, centred around ~400
> > 	(i.e. ~7 hours/week for 14 months).
> >
> > 	1,615 THP-related emails in the window: 948 reviews of others'
> > 	work, 278 replies on your own THP-touching series threads (~31k
> > 	more words responding to review), 382 patch emails, and a handful
> > 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> > 	emails), June 2026 (113), August 2026 (111); quietest was December
> > 	2025 (5).
> >
> > Think I can be happy with that!
> >
> Ah so sorry to see you step down, you made THP genuinely better!
>
> The numbers show the amount of effort you have put in, but they don't capture
> how consistently useful and detailed your reviews are, with the aim of
> always trying to make the patches and THP better!
>
> Thanks for being an awesome maintainer and hopefully you will consider
> coming back soon!

Thanks Usama! :) I know we started off with some fireworks on review 😅 but
you've always been fantastic to work with and it's been great to see you
develop as a contributor.

BTW, I did want to say but never got around to it - I love how you've
approached the PUD THP stuff - i.e. getting the huge swap stuff sorted
first, gradually building things up, etc.!

You've always given interesting sessions + input at LSF and have had great
insights on how stuff interacts with the Meta fleet also! :)

It was especially interesting to hear that 512 MiB huge pages have actually
resulted in far less memory usage than you might expect :)

I will still be busy upstream with the 4 other maintainerships to keep me
busy, along with series both in kvmarm and core mm so don't worry I'm not
going anywhere :)

And as I said to David and others, always feel free to cc- me or ping me
off-list etc. if I can be of use for THP stuff, even though I'm taking a
break from the maintainership side!

>
> Thanks,
> Usama

--
Cheers, Lorenzo

