Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88C6CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 04:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC568E000B; Tue,  9 Sep 2025 00:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACDB8E0009; Tue,  9 Sep 2025 00:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C28B8E000B; Tue,  9 Sep 2025 00:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6888E0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:18:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90C4016032E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:18:49 +0000 (UTC)
X-FDA: 83868405978.13.9E36050
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF5FDA0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:18:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yClCobl9;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757391528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEBM8+ffGiTjPUqrdi1ttRJUnb4xuXJF6srj26ylpxo=;
	b=DBwka9vwIdzldLIEO3XT3C/kUd9E8ne+Wg9IeYYWXuUZjtLmckrGpYDxgq54ojQuTTAd5m
	YyzJsnjcPzSF0pkyPm38yeZIYBvNDGYKshcJugDTQM6s9UgE5QhkKTY5PEDr1slyeUfY/Z
	Yq1WcU43hKraMQRgGPMZ8b3cfeZcKyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757391528; a=rsa-sha256;
	cv=none;
	b=c6Q8ttisYj62TYePoTIJm+5zzt97jqjAFNYndfyR2nnzF5LBd3KpWO0qyha3EgnXCIkQI2
	OS6yJ+CFaaZomRXqttB0ouDxFDi5CjlbJhqfci5Y6SYbtxbT9Sm9fTfOdufkSGACcP/HGb
	SHXgQtq13fTGKzKnd/3w8cWR0jbo2xg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yClCobl9;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A32B64466A;
	Tue,  9 Sep 2025 04:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560B2C4CEF4;
	Tue,  9 Sep 2025 04:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757391526;
	bh=oirQprCJ1ESduAaLG341IAD0wVCBpr+7HmBynU9vLKE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yClCobl9sVnh1i5/FMXkKY1Bbi4M1x49V6PSeAguv7zIeJyc9op/jeClHjNhHueWv
	 6yi6GaDy/xDdg/iuAzfBQaFoh+Uw2p2Li3gi+MXpAAercb9l3Ahozq3Vk9pHKZbrkk
	 dPvO8cUmCXBhsdp9qtYoI+8CxcH0YqpeGtd9vhic=
Date: Mon, 8 Sep 2025 21:18:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17-rc1" <stable@vger.kernel.org>, damon@lists.linux.dev,
 kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] samples/damon: fix boot time enable handling fixup
 merge mistakes
Message-Id: <20250908211845.bfc7299d783c361b10ae810b@linux-foundation.org>
In-Reply-To: <20250909035141.7545-1-sj@kernel.org>
References: <20250908193548.a153ef39d85cc54816950f71@linux-foundation.org>
	<20250909035141.7545-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF5FDA0009
X-Stat-Signature: r7bkak1izhpz7e681dsu4rkng1sr7unf
X-Rspam-User: 
X-HE-Tag: 1757391527-498896
X-HE-Meta: U2FsdGVkX1/UkcNdycTQkzwpn3RwSKYw6mB9JCzSMYh8+tgjCmJsDYDHGLrvLW0Um+KPYO+pZt1wSH18I5SUDCRyk4MFvV/LHxDbVY8Wsy0mg6fDUv4JM9TXQ5wSHLnc2kjBMRhklsHiiqtRzK/j+Mc+CgEtGsNLwgBnwgt4JbEAhjjMeE9rE51BrVCP43UB0LlM2CGU++TIN1VFh+VpypSbIKN9m53Y3kBVJ7GfphZrw40HTvziAtfpf/CO/ky03XBeEGXV37Mo71yHEIG9Ta3oo/Pk8xWKWr3azGdV7qaM/2on72ksaBe4uTAheTR9ymehMu3N9IJpSApn2f88NkwIDw0QGzM5k5C4xIdkyqm8Sd70JN9TrRvfAoo+NWJ7MOvjX+BHICSdY19InBN87WlSRwiUKaNuhZ0RKDS5OBX2rXLgwUiUBwI8AjrwWc8Ug8woytAXzroR1qG3w7mlS08jrJCdO+qFekph7jP5maO3RNoXhA5smfBdf0THVbGXZVXFhM/A5dAVuPdgetq1YMWSMnYcS5vKNh3BtGYkJK+oJI5iH/YkKET5j9tfOcTG7dJX+5SReQhyUInrVLABqyH0kKjGbNyJe3jAhzm2vVQ19L6SXPgUUExbLC5LAA+RP2Pk6/3Fo1bONxn0nSWzwua+zZl51DnVxSC/ma5gNHN8YfbjG6QbS1scZRUkfRMcBkvp22T1Js6plIJMWS71I7fLOeci5QrNTFGgqISRLYH43uV6m1yNrfepu6WfBrPvseQ5cEjm1SQwTv/ANtuCyVH/0AA3qarO0aul5gjcM8V/lDomLYYI2vUnVE+AsJqwr1sTb20qIe2+Qyq8s5/QOc+Y9/8cwcIazFy4E30LlMdlrJ426BFnk+fMpGgJ9+5BUsih3MM3fIeKOOecqtR7/xude5raaL3tHPpZj4uIRwovq8bk82H7s7JrdpLkHCJGsleTjbrpE5SbFCERF5y
 8ycnhNwx
 TeB0KLI6NGN846JXf+sDjN0zAITdXpSuAiz/+hPEw9wwy4QZQqtGFIH51jM7NVcvWECOfwiRUQ9r5b244KuH7O1/+LbXnEijwHvH1ERlJCRtg5Z+JR6j97dolzICCh51dWky6X73D3Dink0NC5l6ElyZUH58Hx7ldi9RGXoy5piFI8rTkgOs3LfM/TKs31rnpcoPTDuQsxH9gpIBakr+SfvO8Ry4tRHvOQtfnQP5rQlgP3i/OkOGxeMfqWv929AqVEcY/cmaRL1aA/no=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 20:51:41 -0700 SeongJae Park <sj@kernel.org> wrote:

> > > Note that the broken commits are merged into 6.17-rc1, but also
> > > backported to relevant stable kernels.  So this series also need to be
> > > merged into the stable kernels.  Hence Cc-ing stable@.
> > 
> > That's unfortunate, but the about doesn't actually tell us what this
> > series does.  
> 
> Good point.  The issue is that the sample modules can crash if those are
> enabled at boot time before DAMON is initialized, via kernel command line.
> 
> Would you prefer me sending another version of this patch series with an
> elaborated cover letter?

Please just send out the appropriate words and I'll paste it in.

