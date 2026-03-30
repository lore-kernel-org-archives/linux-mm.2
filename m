Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6580E1061B1A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A6C6B008C; Mon, 30 Mar 2026 14:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB1E6B0095; Mon, 30 Mar 2026 14:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E17B6B0096; Mon, 30 Mar 2026 14:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7796B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:51:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDC9A1B82DD
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:51:45 +0000 (UTC)
X-FDA: 84603623370.07.76A4BEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2AAE480004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:51:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w+9Chuki;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774896704; a=rsa-sha256;
	cv=none;
	b=5z//fGZ6HswdfJSj2mvhMSs6uySjNdosn5c4Ci1t2J2jrgUgsbgcJEqt/8ggpPw9w6kvIz
	qaTjOGYp50g9v6N0me9/Y2yWVzEjgBMWcgon0hoj6tKUkBOMhSxH9LQFxz88Bnz3flcq7A
	ylanWGvuKZE5ZsC03evcJTAwhOmEJCE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w+9Chuki;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774896704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tm3teSG3pAmdvhWs9khRblA/lQhM+PQ5vnDKUjygpCU=;
	b=TreWFqi9e0h+ibm5FrdmD+9a9xdK94URXjcKJo9PRHmHunraV1sxUrfY4rOrIXAdrJOOM0
	4uJuEQckrUOVSjPY+El4V1zPJPRUlGNEP95A6WhNsYGou+F57zHkj7XJwZ799af732yce3
	0UWmmsxX6PABvrTENKL/UD/BmumGFGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDCB244397;
	Mon, 30 Mar 2026 18:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0FEC4CEF7;
	Mon, 30 Mar 2026 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774896702;
	bh=npYuzIAJhTb8zaBgQI9wXMwtR9qZ1KMW1VtR57baf/M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w+9Chukiy98wCQakcJYeG7xnclPuxLJVPdRtu74cbkYKj9tfCWsZIQ/5OLKnKdhZ1
	 n1PQzjxFyoChnvyfNl4umzm35AVpAjeZX1P7G9/EZKxeSiDZ18Sxd8n3czmQer0edE
	 0E34vqe7n2F0hD+WxROydSF98v8KFGaoIrnt+hcY=
Date: Mon, 30 Mar 2026 11:51:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>,
 hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the
 pool.
Message-Id: <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
In-Reply-To: <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
	<20260317014802.27591-3-kanchanapsridhar2026@gmail.com>
	<20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
	<CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
	<CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2AAE480004
X-Stat-Signature: at5sk8ynoi5pnubc5b79ku13pfsu91k4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774896703-200057
X-HE-Meta: U2FsdGVkX19/qtQu+Rt6xo6SPNa9E6yDsaJfQSy0hHLZfJeJQxZf9TkZ5P7i7DL0FmLUi3qQrJHB+AxCh5y1YYoi2Mtko4WJocAUxicM2J/uySh2oVuzxTQ4dqPyNGaMRnl0dPeBttNFhvmu6jljtiGDVwu6FeXgCKCyJmKgN+nllou8voE1DaFXkT6ZC0hhlyRnkK4yVhQ680WKFSNExn5zDABXkZYdO7DuQ0QhmXoxkR6c1O4WKUe/xmwQ/qrIx6fiBrf21zK6EitG8G8oji7C/yfeMltnihshHvIi3MLLE49tEmB50qw4rO477ptZTeQDU5WN+jUgBdyxioUOuzTG1gGe6+w3zwUAEJGkRTx0xf47Wwv6zohDl/WYJjmwdpNaj03QRXJQlWnKqp7TdyTnY+pE+ogZSd2Y+8rUUv2f4CE9lmf5pLRjsMepC07BSR3MPxtuzRqK1oKXpCokQBV8a4DFo+fJkx6RUIHqLCq21tiAefW/yWlfFBlI759qwZ1dh/GXDc1RVbIC76tKWVSK+oigqgphOntrJmXOA2OuiiGWf2faiTuLhiRSyT0sWASZQengFg2UH5CiASjBNH9Fv/jhpt602W+G7e1pJh8iVGuONZkJ8bc38PQyDJtypUar5Hoy9wLB0/VhCuiOrLI9bGiMSgYB6KThvTWaIujDXuIX8mi3XT2LUIjTXY0lg/mxKnGgrXDWo3IT60phYtc4JgfOG1514McuMmcxFC4dWFA/dlfpHg4/IM1RmcGbQ9ytTsX/671LOwhtrDv91e/gIcnmT5+Hu/EKAga4rYeHdUU5lw5nn9u2h/5f1rxZVFLX/QDLTwWnL8Y5thv24O9N8QGIFwndHWU18Yd50yynbYLVYSDEBZoJD9VhlRMlNYCWK8G+J6rfV8NTcBDDWr2HjplGuWVNjrPvillxLsGPSwGgwuJj6oKokaUPeAvB+/2tKC+i73l3hk2JFWE
 pX79pJDi
 0tl44VQJW164cYtpMp4uVjCTXtcZ2sFKquuMDe1x3Zzdw3M9rtIW+aytRG4l9JrhD6y2CidZHEd7uM2jKFuOfhIdSr/2RWIkZoucnkCkQVREiR1QLRLGZM2/XEv4SRPuVTicBfXE7eQU+5IQgMz36haxEnIbAAlXns+1e971vWjPbvpy14TuOrZ68/olBYJiPY+XzW81AhLWAX1COvkbXJ2Xw8bdYQkulQENXkcpQfT7Ph5kmktv4Oi5oSAi54xw9Ygv2e+kbzB/uON/W2iU1+q773lrS+OkKDhJlk405jixSt1O/1/HUPAJb7I7G/Bd58zBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> The patch looks good to me, feel free to add:
> 
> Acked-by: Yosry Ahmed <yosry@kernel.org>

Thanks.

> That being said, it might be a good idea to resend the patches (new
> version for rebase + Ack?) to get Sashiko to take a look,

Yes please.

> hopefully it will be able to apply/review the patches this time.

I expect so, but I don't understand why Sashiko is having trouble with
this.

