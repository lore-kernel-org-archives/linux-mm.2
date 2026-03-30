Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55098FF494D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8196B0095; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D734C6B0099; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBCE6B0096; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB7ED6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 694501B88D9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:39:48 +0000 (UTC)
X-FDA: 84601778856.09.BFF5860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CADA84000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:39:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="12cePyq/";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="12cePyq/";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774852787; a=rsa-sha256;
	cv=none;
	b=Er0TWn2XiEHHMjHT6GXY+wDeNzkFpB15NqFS7Pd72k15/docgB3bbXT948mEHt4GDKvgPj
	jI1p8McivErA/YYYJwr3pAvGMqhRiqsxZ7SmlKpAXTbeIx49TxL+vkl0bHb3Z5X1OLJqGs
	hdDahqM7i9MGTAg9sXXyBk5ZEyIbRaw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774852787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxYrv4yFaOJHzUU2F8T739DFeOCnitOxLOMK0PJLgtQ=;
	b=dk+fyO4k3FIE712GuTjm1D7Kp2cWuoG7hfE1flNywGfQ0/EfOuMcF3azPiu68hHwtuj/SW
	HPoFwy0K3w2DIF9JRBZLAoDRzshapHulIncndMtqS+gWf9mJgTcbOxtaKUZ8vHUsNqWJQW
	k1Y6zM1yOOGMhqSof1mTfPA9bGWX93g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C158D44560;
	Mon, 30 Mar 2026 06:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B72C19423;
	Mon, 30 Mar 2026 06:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774852785;
	bh=myvvPZhxJ7EO6K8GpcgKd8hCovuJkekPgOgGCxsiNq0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=12cePyq/2vCuqfJDmg8TcTYpRMJ2OMOWS47EIlYsDlGjIaxMww4e0JilOZcFMt3/H
	 Lu2p19FVnGvIACrxhCRtany7kefk5oTWkjqCRJUDE2p9sLgrhSJdwU11RHEJ8btwoj
	 C/eznQgM0lXfTcIulvncGxHg3R94KrXlwdCK8KFg=
Date: Sun, 29 Mar 2026 23:39:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "# 5 . 19 . x" <stable@vger.kernel.org>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo
 Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Roman Gushchin
 <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn
 commit_inputs vs other params race
Message-Id: <20260329233944.4bcf8a832a2ee1533c4a6613@linux-foundation.org>
In-Reply-To: <2026033013-drainage-stylized-43d6@gregkh>
References: <2026032915-library-embolism-b48c@gregkh>
	<20260329193226.59025-1-sj@kernel.org>
	<2026033013-drainage-stylized-43d6@gregkh>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CADA84000D
X-Stat-Signature: xjcstsf6r4g5siiromxihax377kbcajc
X-Rspam-User: 
X-HE-Tag: 1774852786-315048
X-HE-Meta: U2FsdGVkX19+iRRjZzvQPaz2G4BTrhjIXTwTBKdfBiB3C+ZDsldLthe+c/B5jtoHB3u0JX/IaM6C2C36Pu3EMcNYVR4svNscpCQ6sbKSM18jtd1vnETR7PikGojAzHSjwcFhl3I+S6wgAq/8gH/KEXdGIQn5xw8sk0p/BRvCSDv+xYzl91QxB40HNCyUmk1Aml2GsYM4BBRP8GfZ451wMysVQP/00NJW2xGcYiANQnGF9aGobEResKSIgQE7FK4ynckDhAAd3XdnusAmXDlnUxg46zq3GQHvXY3Hdrgw7X/gXhCXSEFD2iZronTZJ1TsojB9mQN5VO6mL/mc6J9xeGRJKRl3Z3lyw63YGJTYumPYfPvF1jMTOjx5nQuhzg1ESv7l74MU+fKW63GvNfbf7V86eLVYW6DSzbvgRcu9Zl3vLeOW1VH+kfaj8LXCWZCtXnpEEmKjlDDNlaBZjBdcGzQKJlRDhg1FZnx0qYAf/vO6ftKAf3i/H/SkE8D62sZongZ8sJxN0cy030D2di1uI9Zjfz3QTAquj9MC/kDDDzKkQbdX6iIPQLBivrU3zHUV9o9zlH4/EwqaEzYhklftv0VEgjKvU0gFJFWAReK+lTDUuq7dBcv3aX1ZVogM3Tf914oZitD1zbHt7y/IHqoSy6Afek8iesf3kSeOUgJj1pcoQf+l/1t4LtpA35vLZ2j9Qyjj2TRtG3zfLWgstrGY907dv0wj+GValHIzDbZCaNsaGcq5qpNqmqMXiEHbYyisPkLB9SLyii8MrJMjFJeFVhdyjTFhlH8bQgnyz1B/wL/HtJKqZ1p3Fvx+XNc3WV1EsEF5YvvthdcPbFw61rt5ATnrPXyCSWzZbzZ4vTSPuTMmbGCrKhS5HNPACPFxze3UR4U/IcM+gtxyos5aPcu7bXSYFVRxp8Vkwr5LZgPbMqPmaMqwcf16sW26fot6vosMV0r2qlCov1DRfMbe6pp
 QoSDLH2q
 tqcu+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 07:47:54 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> > And anyway I'm supposed to share at least my review of AI reviews, in mm
> > community.  If I ignore, I will only make Andrew have to reply asking that.

Actually no.  I see you're using Sashiko extensively so great, you'll
hear nothing more on Sashiko-vs-DAMON from me!

