Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE459D148BE
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545E06B0093; Thu,  8 Jan 2026 03:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5BB6B0095; Thu,  8 Jan 2026 03:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412E26B0096; Thu,  8 Jan 2026 03:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346276B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:05:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C98C8BA201
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:05:47 +0000 (UTC)
X-FDA: 84308062734.29.6954C83
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0C451140010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:05:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=IJxBUdqc;
	spf=pass (imf09.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767859546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nnr2K4bRNyXoL9NoGQXVILmrNEOTw2nzTzkEYOW5Qxw=;
	b=Vw/xvORLxgtOUm7EYaostAC5mtTJkpg9qXQ1m1dIu5cb0SEb4FZzKnmSUCOS1tfdt0PJld
	MV/qpKtiNkH+AaJ2xMPC4ED9PfkFk/PrHlWZHqtEmS1cVQuTyFpCSVWk4edNNfxIM9G6cN
	Las9KcTODAmDGZwhAlgnrzmC1A8QjfM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=IJxBUdqc;
	spf=pass (imf09.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767859546; a=rsa-sha256;
	cv=none;
	b=X6CaFhBv5nOHh4KeoJJUxzhU7xmgj0LXqHgb3KAzpu6WWrdq8UMXXDvrOiKzCV8znyOywk
	PRE0gqggQ7b/wZb26TUl/gp2syS0M2dB7ytFJyPhoaIYgEZ62m+JcnZizVHrBueO+YeMLK
	ujdbexSOWyRqCAJzzx9xUfJ2dRp6cBQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Nnr2K4bRNyXoL9NoGQXVILmrNEOTw2nzTzkEYOW5Qxw=; 
	b=IJxBUdqccd3G/9JLd1nt/xTOb70gE8wyBxgoAqC5jyKDjLkh9QvXcUu9lYjTE3wvhUW+Ad5yq3l
	hOSKYKrZnxszo9E9yjdE8nJunzxUcujx4FaNXIiyHbhl6YnWC78QgrnwojRi9fQQbEieYUC2vsXhX
	Y/K2r94erTPhWVFme84SWhtGBkT4HRtbjr/dYocgBN/4vrPQB4RcWokmPRyaBixtC8tQ+yt1F8O9P
	sqgYNsMRX+ajJP4QOsU31M8dGmKXel0lxq/eLGMHGP+1JYdYvhnFoGozLpHPEQy/iq7A5eU4Q/lQO
	V7b8Ywbc7D/oFkggxAwqSp8MEYAQ7F6r3hFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vdl18-00F386-0p;
	Thu, 08 Jan 2026 16:05:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Jan 2026 16:05:14 +0800
Date: Thu, 8 Jan 2026 16:05:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <aV9lOve5tabZqKSt@gondor.apana.org.au>
References: <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C451140010
X-Stat-Signature: b5krhs4tfhgjd8rs8e7cddiez3e8mcsb
X-Rspam-User: 
X-HE-Tag: 1767859544-623119
X-HE-Meta: U2FsdGVkX1/rsojeygW6iWyIGEto7sA+5wPlYMcxsiTZqQ0hvPBLuzdbI8e+q9jaQbe75mhWKT75ufk1OnnrRnNLsr1BlN6CwzA2vdfKUjaDRB6D3HRzMrnCfX057qplM15Btr2F7joziZuKUfa1qBS9+rqgVC+7BMHLPEm0vhwfzhcXYaFpgvq1OelCqTBFkY18tIrXo4O+kZ7Uc0dmtXbb358qrqJb/JwjOc8A1tfp8j+82XD8zcHfqwXmn1vXKwzLIecYyNA/6oKWMDC67OXCoXsvyYHPdRkBs7qRDy6obvaDa/ZtrU45R7pgCLHW3Y8XLR4X30mQSfMV+T+p546LZqgNvUF1jH2HfrbaT23MA1OtmDxm+ekFzpAGgzYinDU2YjqOY14rH7GxrirhqXaWPgTUeFameVh3jzsxcoc2cFxaVvPFq9GgXaP0eyvIVJTs5FK6I/KKzRk9fLP1+gAMvryFzi1UXIwpwjvttOub8oYzh3Crnh/vrCZ8AolKklO49XiKKTU9I6dPgvse4J9ERfw52xSH8yFoBZewppcYmk1nLIQaJQ/KEqAld6SQKAdiCop1hxVP2k+saB5uDiolXePaMyZrNn8MX/XX07hOKzS88zH4KhRWP59cLatkKa/ESfu9l3KTQIHmMYpM5TcXDELGhIg/DNN+q4+2KgFDBtA4t1wnriSoAEPWkqGll+XJxFnkzLVrwqTpR/SajDwcXBCVufhUbUpRBnGehI5bSNL8awVsyqRW2AgUTo7Wp7K93zytzA5Bi23kxtNh/TiEGJioz7raCLUuj6GxQFtuezD38UFVG1ghoorQmeMF+nR+lUql/AZ4vLrIgbdBJoyt/W6Loy68zm+ko0Msb7ZQMDFkiBMKzxLJosQ20aH9ENnhn6WYT0h4shheSGh2npH0YrLQeGToG9hxWkdK6J/9xVGhSeHaKX8NBW1za+ZXpKW1Yqs4rmcaarTImn4
 NqQzAMe+
 S1vYxbhXY4emIiPVMVFd8QEe4FgoLKjTRdCKaMKsPEKi8/iYltEvIGqdSzSUYIDMMwDDnDfM6hpZfVemmjzgWm2R3nV/rIQ5NhuT+QKhhnZuM++y+yUFMUrU3/tjB/OHn0ra13wQBoeDqf4tRE3rg81Q4vvajJyNxyMtlsqAknaYs4lxpmuT0SRw+7TLUL7GdKH1errRse3okMnxMWG5WLzCs/bnHdVm3CuGlGFM2X+Mgs1SWGYc1mF4FXM3aeqC0RV7Y96IJW8nl8wL454upaCH/gRDkmUpRKa2V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 08:01:20AM +0000, Yosry Ahmed wrote:
>
> IIUC based on Herbert's previous response, crypto and scomp already
> support passing in a discontiguous SG-list. So for zswap, if zsmalloc
> returns an SG-list, it will just be passed as-is to the crypto API.
> 
> If zram can also use the SG-list, then we can completely drop the
> memcpy() logic from zsmalloc.
> 
> Herbert, please correct me if I am wrong.

You're correct.  The SG support has always been there.  You can
use that today and scomp will perform the memcpy for you if and
only if it's necessary.

The algorithm-specific SG support would simply be a performance
enhancement that eliminates the memcpy entirely for whichever
algorithm that we choose to implement it for.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

