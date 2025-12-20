Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F200ED637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 05:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9776B0088; Sat, 20 Dec 2025 00:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BB56B0089; Sat, 20 Dec 2025 00:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375166B008A; Sat, 20 Dec 2025 00:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22AAA6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:26:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4D7B58E3D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:26:18 +0000 (UTC)
X-FDA: 84238713636.15.20F0381
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02E2B180003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:26:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=edgP2vMF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766208377; a=rsa-sha256;
	cv=none;
	b=uWG+mXGHuYtHabWC6Jw/FUgJGZ9gnfJfx47Hi6qXt5IzrxhRQC6T2WZ6KT7NgJ9+nii1Td
	anezJ2HfkJwVCcxZn6NzKsD0v+989Nk6RKp9pZ+2GVZbD1btj97E3AVLxaMRDSCfSwHOc4
	8S/keHJ250JxcN21+RccPGgue2cwpfE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=edgP2vMF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766208377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikv7T6uUvqOajqS4ukR7vYik/6qml8vwUs1HwhWK7Rw=;
	b=Tl7v9PNIlKSBiRoIt2mtDrG17+LhqMPP493sSXGQDGDe2Ee2fc/Sl7iSaMHt4ztARXJAXM
	Sov2o29O00duf5O15CiE16QdauYMISb9C0X+1pSicnUyrQpdyEbqZ+XRHjuu+DY8/B+vTj
	l5EIMGJG4ZPH+XqPjmmjUhKgoKBaSyA=
Date: Fri, 19 Dec 2025 21:26:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766208375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ikv7T6uUvqOajqS4ukR7vYik/6qml8vwUs1HwhWK7Rw=;
	b=edgP2vMFfvj6dMDrwktqwCDCrHMTBuTN7yxNF0bqlaGM9mvOsbMAOIfByjeRYXZGNFAjsJ
	GKro3G4TvgasBG6wUS+UJJFz2AwgFyY+Iy1mPSo40NFOPiP1KYGF9vJbbJTqhAez9KnWsT
	Xlu4sySSn00g2aM48pC8RTJRcawULaU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v2 7/7] MAINTAINERS: add an entry for MM BPF
 extensions
Message-ID: <e2nhpy4gwzoh6xkc6upew4yehqqonfawl6pfhivdhw3kte4lk5@zdwgi5iciq4v>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
 <20251220041250.372179-8-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220041250.372179-8-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 02E2B180003
X-Stat-Signature: rekrdq41hpaif475oxicwsj9hda64qcs
X-HE-Tag: 1766208376-508658
X-HE-Meta: U2FsdGVkX18QhD/NsX5DygwBEMi/9c3SFBpcuPipi4cX7HubfzSVsdUAlEHjs1kD90K/rs00Tryla1vfDH7uaUxTeLf5dZWgwvAIzBrcSW3behN4tksxfqDYFwUSUOt9KZ5MZ0nnti1BGe3VT102FT17vc7YckQ4YUG8NkF2Txxv+UdWU5uKksPGEk7qB0HfmETt2cyjJBzZ9W91W3YOdO4AfSoAFyfJnDzgWB4EEN+GK1RCS3khdJmrpQT86q+Vz506X+O0iLXGb0nOmjKJSvjE9j0TwTN/UDWSTlNSrioxs7dvltTfix4kEeJhHcy3qJ3yt9VWtPMlCE+vMftmY9KmM+kqOAeXFP3RL1SDw6qpicTc744nzbKkr1yZFLw8I/Q4HEBVerVR8TRVj+smX5jaO2pb0+MNdILieOb8+Uxf7PwKliiYzn3ftFRc3heO/AkqKSXRptHdlkZF47KnbEWDP+SjnCGbotVzspAiUlyWlIze19juWTIghvh+CxIY7sQvuBHvIFxdEdMUjY9es2oMNHqNTMus5YYxUrLnKxjspCDt6s0i3604a31VIKEM7OMiLeh5hPM920oLuG5s3WPUqDaR0ozbSaAcZo4MNB/eklBD52Fk5irxR+QywJWhs4a3a3HemVexeznNfsG5tedF04tqycGerNcGC2CxfpR+n0U46KXCNOU05flSiF/1C3G8Z/4hRz4k2lq2JWidncMei8w/LLMW2M+glVTWbhBPmhKpr6hZHdZ05uyeH7PEweLvP8ytJcjQGcoC+Hd3mcNmDVoYvmLfb0sD4htON3QS1cjY9gUB0V10EugsnTOeYukF9eUg+coirTCQjkJrCtUNoWR3F/gIBtZ9B8pDV1Eoay5uczbRoOBPI0Ejz/OnDJUv7YEoHxZUXo+Inii3sMV3f3VwQF4nM0EhuJo/GSc3hEXW0eN+vxbiTS2OZwPh40VdrF2eHFhfQfQWNli
 Py6SeNO6
 RIq0dSAaR0l3n2Iq23LrUmOf2H6LH55P+6SmgC4neNku9rMoEaC90X9NQdY4xYQUsRkw/Z9+h9yp/5PPKRqBLaWyUzhkGvUhIxGv5QCCJBnTQf1z7n74E10qEFVxLvyLKdeD8i+6bmnldculFzfW/LVPy5oksXS3XvhbgntjA++2edEnS18r5m3FClHx8XIAhicdVRFuQAqUQwhVKb+4I9aXCSktPau4Uwdptrq5UMnWtrnI6182kvf8F+khCcIlEQkgLxqX50w0FxNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:12:50PM -0800, Roman Gushchin wrote:
> Let's create a separate entry for MM BPF extensions: these patches
> often require an attention from both bpf and mm communities.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c0030e126fc8..59e3053e1122 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4798,6 +4798,13 @@ L:	bpf@vger.kernel.org
>  S:	Maintained
>  F:	tools/lib/bpf/
>  
> +BPF [MEMORY MANAGEMENT EXTENSIONS]
> +M:	Roman Gushchin <roman.gushchin@linux.dev>

If you don't mind, put JP and I here as well.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


