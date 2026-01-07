Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D75ACF6BE6
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C536B0092; Tue,  6 Jan 2026 21:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413F86B0093; Tue,  6 Jan 2026 21:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F496B0095; Tue,  6 Jan 2026 21:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20C3F6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:10:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B879C1612E8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:10:30 +0000 (UTC)
X-FDA: 84303538620.05.CE9DD0A
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id D96E94000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:10:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IOZ4hBvv;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767751829; a=rsa-sha256;
	cv=none;
	b=qqR19SlZnF0UnKvUx9IOCIod5TQWqCqC+Gh29KAzqR7WWabMygkC1Jddtj5UWAQvZW1H2v
	HoXL33+olKmGXyzzJApjT/f5vgWXvENQoTwt3o/lBOeWKf0RG3C/LTyaGVLFqKoxJXqQBC
	OTkTsczqAD2xfh25HyuvwhNQy/D9uKk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IOZ4hBvv;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767751829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mmyXeB4/WeKNkS02hVA9T5ng+Bgq8Gxg5RkConGBWM=;
	b=NSI/Qg8p07qW7rQjpsr3GMIugOYw6vJCSNHRSfOn4tu63pI1EaW9ieC6JnTMhXhseGcVDN
	qHR7VTRyekc2IXYRpBKjN5srCjEuCoVbbDgadg68GZk/9qWoLjWZqofpTi6akPJDrwzAGA
	BLlEsSGVTESIw6OokZkzmLR6lUPYW+A=
Date: Wed, 7 Jan 2026 02:10:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767751826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8mmyXeB4/WeKNkS02hVA9T5ng+Bgq8Gxg5RkConGBWM=;
	b=IOZ4hBvvRBQ7fuYzm+KWpHkVBf4AZlNiL7h2z0ug/52NTxQtcoBlX8G1FW/EE3O9Z0gHVQ
	HEOnuCLvXEI+zrO618Mp0iMzu7qUB/gaqu8UJpewTL/jEaAaxWNRyUDtH4b6M/72GRu4zQ
	BTX08D+C1LbfmcG9tDNRZVu2adKzFf0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D96E94000D
X-Rspamd-Server: rspam04
X-Stat-Signature: xhfrffmnpbk17ui3p7np3qq7eo384qtf
X-HE-Tag: 1767751828-276615
X-HE-Meta: U2FsdGVkX18QIq8WHhvse6KST+T1xfPnJ5Pj5NNVzdvNgVIYtWa+iVMNstVvA1yIlpwSI/Zhz5S3ZA3retVw0y+1wnhL0FYpsjBaQB4jvdYMdFZkIHCo8HkTJZEgZy1CdjP4XYhF1S85cz9QqPrS8PAsEUfN2OYQ8K4vNGyxwpCUW60ifc3PvuDLXjCgyBsfDYhPwsL8ZYIkKXtQOpB1cO8BWN4E0CMqeRuUncDkh0xA+vX7lfXaB7FQQ4MD826bCTkY6tvqaAH0cSnFlw42q1WpFtqyx8saGnsF00tO3hHln4X4Qt01UJLl96WEs8PpmgNxKwkElDqIE00WiB1l+ggoVrBEW2Xo/je8DKgIqJ+e1qW7E4B1TDx1I30hnzsKT458stmNA7eVj8RAhb+/IqRkb8tyQC9fbPT6QZVsY9X5MvXLBmw5lV8C4mN9F1zawqZwgcrDXi0ijv6yNayBiVOKStgve3HQrtxspJpiuN10Rk568I2iGrt2rYTjmtrDsXd87rU4XCuaMWdiqIN22n5EVrSyd4rVwvNw7ZaPpWe0JuAX6zaxyLJ8k4ZhK2KwupsHR79gbUKwQhohXz7mWGWHOY2ghfdaSeYXOmRHShPqljLowA5mzWSLfmjJmrLJZcoe4ZANZgn1yclcGBn2TfP67p0ckYMCVlVHHHTdsYpKGlPrSeDNqD6i+wMxrfHQAUmYqWK+qHprMyn3pvllWPwieAKpUYNjiioKNg2oZAVu9y+W2ZmGvcv1cIEdztvmwfuZw9/8y5pe5IJe+Ol5NVdWXvQsVlC0TWyDDQ1MQmzlBmL47j2i7SJrPqg459oifq0oX2j+nY1Pe3cWJy/49BD8wy3+OX7BHV5XANXKPnK+bobxMLDhn4OCsYVg5+HzjCfxRJqoEsqD2PiXYyAJ/j/o6oF98EhKpLvbw0R7MU+FaC7pkLWgZ4TnSeloE0GQL0BLJ137Os0BbTtNoXk
 cblYpThh
 3Ctt797QC/9kqHziRJMrqiS/FzJET6pF6zXIbMIIr4AWXHkEo5QcXJ1SjwbFeGrPz/gfhM+4ZzeZ6xql6Yx0RFDFJXQOO6r6vgv80aSskD4kGeply3yR0yH4+KCCd8aAJ7EbHpDvXmmDFW8ioUI+8d4o2SZ154xIPuBl1yYoXth4iqyPZSCzSveOkUlr4qcQI4yNHjvO4kN9vRHhiiXtT+35BcU954SPPSHch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 11:06:09AM +0900, Sergey Senozhatsky wrote:
> On (26/01/07 01:56), Yosry Ahmed wrote:
> > > I recall us having exactly this idea when we first introduced
> > > zs_obj_{read,write}_end() functions, and I do recall that it
> > > did not work.  Somehow this panics in __memcpy+0xc/0x44.  Let
> > > me dig into it again.
> > 
> > Maybe because at this point we are trying to memcpy() class->size, which
> > already includes ZS_HANDLE_SIZE. So reading after increasing the offset
> > reads ZS_HANDLE_SIZE after class->size.
> 
> Yeah, I guess that falsely hits the spanning path because of extra
> sizeof(unsigned long).

Or the object could be spanning two pages indeed, but we're copying
extra sizeof(unsigned long), that shouldn't crash tho.

I think the changes need to be shuffled around to avoid this, or just
have a combined patch, which would be less pretty.

