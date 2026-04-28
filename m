Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E0F1FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2196B0088; Mon, 27 Apr 2026 21:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52A16B008A; Mon, 27 Apr 2026 21:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68406B008C; Mon, 27 Apr 2026 21:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6A1F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:30:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23D2F1B9175
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:30:37 +0000 (UTC)
X-FDA: 84706234914.30.5140F85
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf21.hostedemail.com (Postfix) with ESMTP id 564EA1C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:30:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=bLN2dIHy;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf21.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777339835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPGXCR+/vRkMXnOHF77K390YQwg7XtFDEASdQ5ggF8k=;
	b=tK6KCNr78W7i+XUkdOWIsKSQXWDMktBa+GKUlN2QyjPFaBz4W3Mp/ExlsxNYIN/gtoblLP
	+eGQYEmlEkyOCon08i8nrLsHRJcXYOj0ZC+EbWb9MmyctBabY6kp2HJGXS0AjPQ5DPIekT
	NLGGULEudRgJUBy2W5n8HJpnwytUz6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777339835; a=rsa-sha256;
	cv=none;
	b=aIVYRO9RIL+4cy4qXGPeXnuuX7qhuFX8zBy1xJwncnB+h5FTD7IvYn5os3VlzbaS3oaB2S
	+Tj1wKmLboLGgYIDVM7uVnakU+PHtOBw88c6R7EY5y6y3uf9l/QWuBnyYVpgXHfGfJO1dd
	GofOaCjOMrh19hHbJQIE9BBXZvLjyF4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=bLN2dIHy;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf21.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xPGXCR+/vRkMXnOHF77K390YQwg7XtFDEASdQ5ggF8k=; 
	b=bLN2dIHyFKBSnRnfmJuZbuRO4Ldw29XV2Vy5dJAkXCx6DlBFlFk+LzqoD8Vuh40851Djw4vl01C
	dmAHRaR+VSxERx9RosbUPvDBnFKl9XbarnKcU9yLEjTafE7Ch68PyPUdQRdpSOAkT23Csz8gwcq0r
	yWJdwSLXsyQeCEdWc5X2B6YdNubaMedUmBl0BChVV0rU+B3MxXQasGAF0uuhpej1Amsh5i4fjnMTd
	W57Z+wAoosfXqER3zpAXbeWT9TMwEO22u7MEtcFUX8I2xHODaD6uUqQS2By3649ZbsGg2enUROn8D
	ypW7JEfJBmxUUa8jWIyfxMsYQEMd6KUCAxcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wHXGx-009MBU-0l;
	Tue, 28 Apr 2026 09:30:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Apr 2026 09:29:59 +0800
Date: Tue, 28 Apr 2026 09:29:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hao Li <hao.li@linux.dev>, Thomas Graf <tgraf@suug.ch>,
	oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm] c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <afANly2Br1kIBPOs@gondor.apana.org.au>
References: <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
 <aeiHkG7X_dieMdw5@milan>
 <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
 <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com>
 <ae9wFZp7dS8QF8br@milan>
 <6cae0418-eabe-4864-b87f-b1f953de06b0@suse.com>
 <ae-MdIOcSkfphbHM@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae-MdIOcSkfphbHM@milan>
X-Rspam-User: 
X-Rspamd-Queue-Id: 564EA1C0010
X-Rspamd-Server: rspam04
X-Stat-Signature: rmim1krq6r4u8a57uhteakn1bqu5qbfu
X-HE-Tag: 1777339833-902813
X-HE-Meta: U2FsdGVkX19JBRRDfLSOMko7cOxVzBZo9FQ8mDhsWSZraEfWYkjHOM8UwtZbXkFGFCeCUAk0e79j+tjvy1DqqSj3uB3iHs1qEpeGGSGq5VDn5JPDa0pAFF54Y+RDIBcEd8fpuvfO+RcnX7v9sr7wVFXCJvRgdGBQkJNEdat71H2tFxvI7ebXcIl6jsPjJR5Y8aJ07l5iQbHpnhp5lnAiFvb4jqFH1ERlifwFl6+tlgMR5lXyf7gxCdwBhMM/bJbNqu6Q6io0tYEkuWoDGKmI8tJIHMIlW2JXr51O/DOdGgY4VBugySwxzptOJ97mKb6yrbzeq59uH4kdFo1cc5lGQENO91y7zALK2WVCGb7crFlQlXK2cNb2m6OTKS4Czlv/5TmPlMQtLk1OT1RQ3m4QcTLVlkrCmkb5OzuppZMlxJJruQqlCiMtaQaprO786mn1Y6rHyGuuPuydVPB8HH6E4wloiaDyhmJbdMTWwM5wgiKszYgIxOdujCerRNcCH1N3aRQmHk6U7zkYJe+ZdnxwwqoehXR0NqIaV9npt1g1h/C19d42kxvYg+AXpL0hEcPhbFDMb1Buyj3iQx/CNPMZ9BkqrWpp+LF62eatDikF8khMiwo7VZ4aK4MEVgbKuPsuL67aFIHKAEXferU3DHuN5Tsyc0GLjbpONt05LD+TRyfVLLdGasXeoytnJKYkh2wTHVXXhOhk6p50M34tDCA0GB/0jlzZv/EkzOFSpewpwXWBQf8DA5zcX608dlckDZjJxQdPZ0n0ayiD/3nUclVxAPgVmN5TWQ3oJQyewB68THuQsHOmm6UrCTRzwfpn2CY4iI++z3nvJdBb0LIZqmI4+Ew0J6BhtJ1d/YIVf/P5PlpGIKuPSQzdP+sH7nMB1wNLsXuSkQFOnhtJn9Q4k2H+urvBRA1cpu0HIj7emeELIYuC81ufbJhTc04eCo4+BPhuYaTcu0n4+l02BWGtF51
 hdQdac+Y
 dsmo8wBnpA6xRtSoLb36sP6kxNSR3z4p6U9dEpc7upJNSccFul/h1FvPf1cS4wIGLvwELdcvnhhY0D7LaQa88MrH+MMmVot5BR7Gmr1149VWqeZXl4n/hDH6aS49RfLpfGFXMicbgR25UrpnRaBw9HGqnvS+32eMP1BeBYUXqHbqvOkh5SYeYHl7Ija8XKnhko9wENzukl0Wc8zQQxbAME8yj/jrXw/PiF6BfaJjlAUsK736jypLy0kmJxCk8p2ELTEjiBJFKVlErdJLA1FJ47lbQh1/KQiCiKu79gAfh3blgZm3Qsn8NCF5WGbQaDKTk7gINGLttdRm3WgVs8cBIVQi1JvdtWgHT09ms8880bGWTiGG3NvazQBwdb7PedPQMcrOW5vsHXxyeXERkKOXnkale2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 06:19:00PM +0200, Uladzislau Rezki wrote:
>
> Like below:
> 
> rhashtable_try_insert()
>   rhashtable_insert_rehash()
>     bucket_table_free_atomic(new_tbl);
> 
> the patch for rhashtable.c can look like:
> 
> <snip>

If you want to send that as a submission you can add my ack:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Alternatively, could you send both patches to linux-crypto and
I can push them through my tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

