Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E10AFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0B26B0005; Mon, 27 Apr 2026 05:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8C46B0088; Mon, 27 Apr 2026 05:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F55B6B008A; Mon, 27 Apr 2026 05:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 303926B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:59:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B79634014D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:59:11 +0000 (UTC)
X-FDA: 84703887702.27.CEE6470
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20DEB140004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:59:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=IVJGI6U1;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf26.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777283950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPFSoUF+y9tTAhI3ZpwF5vBbCeTHcUwgJRJay0ZVA8A=;
	b=YuiuCBuUIoSWSaDnjDysxtKJXXLXbzARsHJsYtbaCTEjv6jqseJHlOFGPyNH203A2e0oF3
	xOp4TdozpRI3q0ipiC8nK9Zd67bnuCAysM0yttN2mJ398y68Xb8eGMtUGsrhQWad2iz5PH
	yYdb1z3WbyFgV0Ojyp0WMNBwx20mjTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777283950; a=rsa-sha256;
	cv=none;
	b=YRtIQJu1qQ6mIvvzxLjFAmBDCxvbbeH94NovAGrhQml97nDBcoMvkoHCO0Z+GEAgXBVyTe
	2tAFly5zo7byTinpKQzuymgiGIzvQniGxDHso7uwsSi+//HayAvQ+bVQi0mAWReT/Jcxat
	cyJZ+E1VIQuP+pgDYXGlOxchoNpEY6E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=IVJGI6U1;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf26.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 1522541098
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1777283948; bh=PPFSoUF+y9tTAhI3ZpwF5vBbCeTHcUwgJRJay0ZVA8A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IVJGI6U15483RzjpCycZTLDH3dC8Sqm0N7vdKRDzcC+7ZZA410eMgvvW2ol/3S0DR
	 MfV00z/6STmhXDgcCuKOCH0ZOJawtY044tKRRmMsTRzYSD5zsGLdRe8piJZZmVmQXm
	 bkME+39PVkHIAcOgTG5SZOmnQ27DV2gOOhShC2sJ3ydsKnm1OVYt0IqTnAbgT5xEsG
	 hKkQ1OG1gHRxyxSolje9e7sDjTJBgSNxZV/yhsRtcvT8trAQXhMin947LjzZRmh9Bd
	 bEayBVqK/sst22eaL1Jf7vxpluqMWWixG65zslfkQpjTI0vUUFxV81FbgLO20D3yA+
	 8DvVaDUDQt0bw==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 1522541098;
	Mon, 27 Apr 2026 09:59:07 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Charlie Jenkins <thecharlesjenkins@gmail.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Charlie Jenkins
 <thecharlesjenkins@gmail.com>
Subject: Re: [PATCH] Documentation/binfmt-misc.rst: Specify aux vector for
 "O" flag description
In-Reply-To: <20260418-binfmt_misc_doc_update-v1-1-c2e9601ab868@gmail.com>
References: <20260418-binfmt_misc_doc_update-v1-1-c2e9601ab868@gmail.com>
Date: Mon, 27 Apr 2026 03:59:04 -0600
Message-ID: <87o6j4pvvb.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20DEB140004
X-Stat-Signature: pufuw1z748413hhs4qz9wksqkk71dp3w
X-Rspam-User: 
X-HE-Tag: 1777283949-226223
X-HE-Meta: U2FsdGVkX19+PYl5lfBPc6+bwJFlj3D8zGPDJ6Qo5BxiL6PvDmaH9mHJ2/eehTPBnyN5C77bbkm3/4rnIrvTXqY0NElBPsRwRiunpRJ1/5R35lkpWlgXbVKK6JLEL8xpacrT/FuA0XyDLjK9Z2l2s9qk0ek+UfIPSBEyBKArS/YnU9LYIzT6DAVatfV7W0n8/FQ7qim4VvzXr1jHOyC+nA/JHQgbSMQHWYScTqQ1hJXYMBe87IeU/USX8rjzw3xPDvZEtIMy24AyN09QJLoOimNnLFJ9Ou0rX9d4oLAybb7flk4fO//CaRBIlGbmMEl4wHGuxdUrNmu3v6AfBXca3XMeJWChE1RsyUhXWpxJqXydjZJ1/iFDjx86OBluesekqmkYM6QONc6nd30aXdfDh7j0eD46X5vpbLEY1Y9lrUzt4wuPR8drxPQXtZZTa8ohros3XjQOsqp/yd0S8659MyF6fZ5bsf04htGwkiTLGmeKJKLsdmUiymNyWtSG3V73xr/xB+rYQ9UUHQB/ueZBnoq543HMybYTSO/m8OYitt0meQfHPuJmwTNHOV3RmH7xz3ZcDPQ+opuwhxDVK77BMluhR43ixD4QV+QT1Coyn3BdrBIL9QAlz+F7puZoR9qx464ACXuPClmLWbqWnyxiZYbl3gVxC+AHI5P5YjKN/hjlkq7uSLgzBJ4kZ9X/YaIaI+YBmQWVuzrTX91ND38fmiJAlgg8vHGPBXznwQRMTVMOnlkCOmB+2VHVxL6S8vADJMFpFsgAzdITHyoaZf9+bpH8YPL/4Nh37zlGBahpz+5+1g6US5mW5GjHbHWUZtvgGS2SssJdiFmqi5EJVF41uEhf8g+250triWm11vExtUWeUcatCCo4EJQuu0cBdtmnfG+uDR1PNsVUiK1ETmscAqYR25Pu0/5CHjA5Y7nuMf6gOwP14Nr+5AWAj+BZMbSYrsC1o9h1kfwCuOOb39f
 CZ3J2Z9d
 WFLa8HgdgmeQAg7cnr+qdYUzUFrovxIZMNaL++5j0Z03JauYx7+SvBmc3BujE8QWjcPpoGZ3krrBNiAxe1JiE8KZgXB97Dd85LyLqlGNIjnQKYHuM7HlL/3xM67xS+cR2B6m2WjnoTvxJkomrIbsMBqNcccQFmtGj9jbX0OEZIMPOoHvB29SeH1RqEJY7j9IR0LN+AmSoUgH3OcNHQa3FonQBthjAqAPXWVxqNRZPUktAV0/p7nZ5Nyg9hnp+BTsfco8cHc4IRBLqhAxLBFcUXNo9kKOYe7B5nh4o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Charlie Jenkins <thecharlesjenkins@gmail.com> writes:

> Instead of replacing the file path in the argument vector, the file
> descriptor is passed as AT_EXECFD in the auxilary vector. This appears
> to have been the case at least since the git port, update the
> documentation to reflect this.
>
> Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
> ---
>  Documentation/admin-guide/binfmt-misc.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

jon

