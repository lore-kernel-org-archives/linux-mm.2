Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2B510ED65C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0267D6B0092; Fri, 27 Mar 2026 07:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2916B0095; Fri, 27 Mar 2026 07:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9E26B0096; Fri, 27 Mar 2026 07:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3D2A6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:45:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36BF08D7F3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:45:12 +0000 (UTC)
X-FDA: 84591662064.18.FC4B656
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3DB3980015
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:45:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=wp.pl header.s=20241105 header.b=Fut8Pt2f;
	spf=pass (imf02.hostedemail.com: domain of stf_xl@wp.pl designates 212.77.101.12 as permitted sender) smtp.mailfrom=stf_xl@wp.pl;
	dmarc=pass (policy=none) header.from=wp.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774611910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClyMAST5Ou9swdngfYyP3nxlyzXf+yDAbxpymoT0Rjk=;
	b=FqLk864zy/woDohsmaGRl53N8JwYK/HXUFgoXdRkxI0PbvNb5QYtG1PClJzBOLdwcmOFp/
	lV6gC48yLXMROImuGWEe4zkVWQ0VbrwwmNKF/z1k6+SZ4nGZO056QnUYQoKtvWGm1WlY9z
	6qgZGN5aTQod2FUmwR90Zk/dKD187Uo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=wp.pl header.s=20241105 header.b=Fut8Pt2f;
	spf=pass (imf02.hostedemail.com: domain of stf_xl@wp.pl designates 212.77.101.12 as permitted sender) smtp.mailfrom=stf_xl@wp.pl;
	dmarc=pass (policy=none) header.from=wp.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774611910; a=rsa-sha256;
	cv=none;
	b=zTQ0iGizfdGUBHsTQMZd8IyvFcHSc+Mj6OcNYfqUbWN/VlunNBrZKI/tIQEFRlp+tzjXAK
	Q0NI6NPJG5AlFX03Z0aN3dMHdTgAZVKkviGY3fzJQvfy2CQ3HhOXMI4/t6lqA1uu/+VwP1
	dqVnnaaNRHfAEkPsZCTnbQPiNXtW9G0=
Received: (wp-smtpd smtp.wp.pl 26322 invoked from network); 27 Mar 2026 12:45:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774611903; bh=ClyMAST5Ou9swdngfYyP3nxlyzXf+yDAbxpymoT0Rjk=;
          h=From:To:Cc:Subject;
          b=Fut8Pt2f2FcKLZeKZU6PsuAH1IcmaM6XxqTkZQ8XewDKGzJKsPg+X/Axp2vAWRCc3
           3qnAY22THiRL5JSsDnOi6LQ5NhDheTCBhr6BOTjaYeOZ6LBEdep/O+evxzNJJbYD04
           K6A0diSmzXF22FjSBUU+0UZq99GX+WHfShkvuWqv8mc7O75d/HgkPLFkPzouFhag4n
           1YaqJDXLW+SaLHU1+xH4m1VlwmeT/qC1MOuFnaj01GZlMeDtJD8dOe/Dc4s25FKJFi
           OYova3fSHcfORauEu1dzJScFTX/KaH+Jbztse2qvin+3/6KGVc+cqlQ0xYFlhoy3qE
           i1MDyFUefqg3w==
Received: from 77-236-5-223.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.5.223])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <jackmanb@google.com>; 27 Mar 2026 12:45:02 +0100
Date: Fri, 27 Mar 2026 12:45:02 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Brendan Jackman <jackmanb@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com
Subject: Re: [PATCH v2 2/4] iwlegacy: 3945-mac: Fixup allocation failure log
Message-ID: <20260327114502.GA16800@wp.pl>
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
 <20260326-gfp64-v2-2-d916021cecdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326-gfp64-v2-2-d916021cecdf@google.com>
X-WP-MailID: a5b414377b8f46f1eed9309472d3c6e9
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YTOh]                               
X-Rspam-User: 
X-Stat-Signature: ik1aqth7k7sthhygoy7c4amns4hy38x5
X-Rspamd-Queue-Id: 3DB3980015
X-Rspamd-Server: rspam09
X-HE-Tag: 1774611909-493227
X-HE-Meta: U2FsdGVkX1+RB6NW4q5Svb3z9Fs/XdgRhdLbtmnTDiO+lFz+BGi5DCFZQTFd7SuGkBEQQnn2utCt7TZagFlL0wgdt5vmiVbS8+gsyjr5t3o2G77+gRDBlUMAtGVSQuuiro5jQn5T+zDBUqlY1vDCcKnwVFlnlwF0dZUPvTl201/TIZEO4ArkhVfMaJqa6LeBVt+YbWrb5ZuG1Aysqg59+W7e3wFQGLW6y261GDj100IACunY1e1vAkIU5ZK0a2ZW+N8ec3oeIbAxwgvDtj5kfHK0c7WBlJD/u8OU/2WpkILuJ1YP0GEH43bOavZVlPb+RQIIcK/Thspn54MRQthCarB0FYGE65ngLYilAB4GNRYUWkAvoU3W3cWBKVRSnacGs56a8O4yakLi0K7sJqh6Ax9gnI8gVL5OudbF2h/m6P7g7JCyg03IlrXgtAH1NCVrXsWGRKwpMw0wDQNCYRel8nambJqkqXm/rOpZN8X36lcsmAT5KLZqyoMAoyYx3KLU5+5RIM4a7ObsmwJHTyL3NARuiQN5BuWBzEo/czvukz2g2u6Na08FPoz532ZMHuDyKWTWh875UkR2bsxzc6FI7JPdRB2ErKBkaUDtdx1Ll/nCIAkcL+KX7ILOaQTDVEIH4lUJL4UwH+0kkjiFtcvHJdQgDTkBRSvMGMwiEByHROVkKi1qYtJPHnkyDiGJRKFtf64mPL810MkYVFUjzXuwdWK3H1RTQJIOthp825N3j1aWtMHJF/hniSVWqC+KujI/iw9ndLuiUPXcFVUtZQjOh+MWlrld2QqoQ1ZATXOjLOj646u1JdeZ8/2+rzMD4cLTpMqruR9W6xsZIpYe3NOrRdTrsdYnwpubM78Ui5vBtlQrzl2sPUs/KWghBLzRLkY3Y8pf1v4Qtr/0ymvBfIaK2eBi+ymX4n+x1fep1akkaLte2e5hwy5FhJ/C922cbXTys98IK3ks0Z9zm3V+h1J
 o96viTT3
 ZrfGs261zub6ec3MzYNofmBvgRYgKEbcSEjBFC6M9qsvPGqiweQHTLkz5xw6Buz9ZOKp/L669IkQ+RAoSuPQclDMSxRY0NX2pAVV4OxyB/NWV6iqAKK3ONgZvzNw3QZ/waZ2T4vksObRgfOs1d0cKZkHR78emfS8ZaPveR51OA19l0l8OxrnonEsjnK34ipO6wscHtg40pcoI55jsdPSiXQhh4cNuxoHxIHnvPSWmtz9ZNal/8mdN5ZfL85AZLckBatJfamKxPjpnsyea0hHtLSO09hkpqqo1Cz8xpVdxSJbr55XPjGn3vXDhQA1jV3cVWQEqhFH5/maBf538OcQVkNedDfIo+IMhdB3TAnNuPuGEMBV/VOJ3qTGjFOu0GCljaCGf8Xrrf4dPx9K0pjYDThhJ/LiyljMKguW3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Mar 26, 2026 at 12:31:58PM +0000, Brendan Jackman wrote:
> Fix 2 issues spotted by AI[0]:
> 
> 1. Missing space after the full stop.
> 
> 2. Wrong GFP flags are printed.

We should also initialize gfp_mask = priority inside the loop.
But this can be done as separate patch.

> And also switch to %pGg for the GFP flags. This produces nice readable
> output and decouples the format string from the size of gfp_t.
> 
> [0] https://sashiko.dev/#/patchset/20260319-gfp64-v1-0-2c73b8d42b7f%40google.com
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

> ---
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> index c148654aa9533..88b31e0b9568c 100644
> --- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> @@ -1002,9 +1002,9 @@ il3945_rx_allocate(struct il_priv *il, gfp_t priority)
>  				D_INFO("Failed to allocate SKB buffer.\n");
>  			if (rxq->free_count <= RX_LOW_WATERMARK &&
>  			    net_ratelimit())
> -				IL_ERR("Failed to allocate SKB buffer with %0x."
> +				IL_ERR("Failed to allocate SKB buffer with %pGg. "
>  				       "Only %u free buffers remaining.\n",
> -				       priority, rxq->free_count);
> +				       &gfp_mask, rxq->free_count);
>  			/* We don't reschedule replenish work here -- we will
>  			 * call the restock method and if it still needs
>  			 * more buffers it will schedule replenish */
> 
> -- 
> 2.51.2
> 

