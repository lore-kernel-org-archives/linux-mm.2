Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FE060A260E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQ1LZEED
Received: by kanga.kvack.org (Postfix)
	id 4938A6B05B8; Fri, 20 Nov 2026 14:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444816B05B9; Fri, 20 Nov 2026 14:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35AAB6B05BA; Fri, 20 Nov 2026 14:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15D956B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:01:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A690A40182
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:01:49 +0000 (UTC)
X-FDA: 85456416738.20.D882199
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 046BA40002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:01:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQ1LZEED;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201308;
	b=JAdSPua3jfFL2eZHCZ6MdiHKHcioTPwP5N1geOJgHCYmyxQCC7WxlpNCzU1xunhcLqlqSV
	TTz68t2rKvlfZ350gYqce2zuHKgONTmpyovigkseMjFns9OLWj3np7Jl7I2vK8jFi/YoA6
	WSsidUbjJQFFxOvBbTuQ2kDFx7DgtLM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAbXwSHlaOeW7scWA+gsgK03fkcumfiN9Y1Ul0ztR3Q=;
	b=rM+U+ZhR4JLNRjteXaZJbND7jmnIayC10npWwhAWPklw0mHG4QMTWJCKLAoTS1GBt5A8z1
	geaK+GDluLsQFbn4MD9nsWgpspdlnqiU8yRQk+ktYxaKUouQ4/CFNOyYGQXT9FSk1nrp6Z
	PznOaRu2HzM+y8xWH2UWpRB426qGcoo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQ1LZEED;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75AAE61F85;
	Fri, 20 Nov 2026 19:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A581F1F000EE;
	Fri, 20 Nov 2026 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795201306;
	bh=jAbXwSHlaOeW7scWA+gsgK03fkcumfiN9Y1Ul0ztR3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NQ1LZEEDRLTXfx2Bbod9UFTu8QRPTlWXQpgWKnXFF2ftGYX0kGP+sicczSIXP3BgB
	 TNm2f/Pmwp4WpLdfA4qRxWQIdF8mzgzIvc4GlkibwUkm2VfgLKUm3VSt7IhvMQl7KE
	 4MRztHy0i2f/0Pdjf4MVtB64Sv7xvsFNjaIQa5QFZxXmJwbO6lkNH4KJJBN8c2tfLE
	 uMDcBaTvoXGX9j7lp8aOFR9N1+5JxmG2yiKBJFLpxKxqxqgEe9RAHI40aIoJj3E84b
	 skJKY1TjCKV4FawPSUC+uPEB2iPXJkI8fcfuxnlwy37kRAlvCtLjMv+yqZhJWL6gYL
	 zPeel2LWt5xfA==
Date: Fri, 20 Nov 2026 19:01:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>, 
	Yuan-Hao Hsu <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 5/8] mm/gup: break out gup_lookup_pte() helper
Message-ID: <awCZDX2IG2VKgSKx@gremlin>
References: <20261116210127.3837898-1-riel@surriel.com>
 <20261116210127.3837898-6-riel@surriel.com>
 <avxXgTBaJkPN6XOh@gremlin>
 <89e41824f1371b5880029f264e19b5d0589ae22c.camel@surriel.com>
 <awCD56Ncl5_Tjrl6@gremlin>
 <5f18488c8234ee28e9c638abacf4961311d866f6.camel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f18488c8234ee28e9c638abacf4961311d866f6.camel@surriel.com>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 046BA40002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: h8nae8gpjft13p1waox5e7kyyqh9b4yx
X-HE-Tag: 1795201307-25365
X-HE-Meta: U2FsdGVkX18y7O7kq0faGywXkTqpVimBXp7le66EUsVXT7DFWRALf/iWVuSBrnDMAV//0g/bRTM00IZplUVVxs1KMZ5bqlkmRM67rkkMTbG8S7sHHdXP126DbPom4jmcywcTdwLAndr8yf3rveyrentEBzqXySBvvIULkNi5HZPxtS0h/yp0+jXceH+O2hw+3ExRlkvqJwL5087zThym2kvBAjD7WpmqDCLl2wggt8paQKn6wYLqxwkZM3EYEgejORndpUJXcWOhrqd4ALvV0rnF5+GGSvfY+2gUCxjKfTQgS4V49hXkSzAEWlLK1FioCRehpoKHPcE3a/3oPh7uCfuatfcHDlPsGNGvXhqEp9TiLwuR2Aq/8FNzuN8+CnKmUvZzVriw6IbO+eFSflxISxVpLbjJKO7zvELxyLgCCX9qOBEVKDCIA8GjsN2GnPfUZS35Y6sZFJ0TIlz+iNqQg3ltYBoi47BrSwvYLJ8JNc9FEzvixzyO9rMGjqwG8tVROx392Xga0zejKxzEBpk+KB6AJn+YwHSoL0MuXx81Ux40CaMxthTVe1ZHcU+6WtESCbQyDnEADcpUEA3bt7v6OwYs+vP6iz+W7IkqQetoLRJsQreBMXQZNn9gZrfrmnaJZdpS+bRsyn4AYZ0oqQgOggqXIu3ZDyXgWvWfZKj53ZlRRp9JPtUVOVJ42fo+xigxW2ajvMtzSo7JPIGkzBK99GAO7lyB6LRvn6/QuNS5v41+elj/RDWzSPIw/C0jXbqbhl6jxIuY284V7rnlRXxkTL76rCZ5+GupyM/UvfP+P71hXwZfgbakjGroFD7LOA/iwNn5k7SKZsW22HDokjXbi7BkXdHiJYzmLhrf/KvfiGZ8Um3q22fsBzXq9gUFMTRFeKOHnW1Xz77AeJSFv8l82jMsxwEr0F1pRuj9x1BdozJpPrJmtMRUBDKGb8xakKyrds/gTRi7NfJCMSvKqgP
 CrQU2oLl
 rStfNjpQXJjKSffmLJ7YBTBN6OzsCYSS3UcDp9NG9gWXL4vVwjzPC7PfrTJhrdIu5e+S81Ns6gqCU/l1jUPzMeLEeLl9l9OdUmjPUw+3/gDMJbxhJC4GdxWmX09fvYEbr6Ke/LPx7UloS294n1eV/1GR5GouKlNeGEdqxTD8CoQ8T8BWC3G28iUmTAMCTgxXl2rVHCJtEpSRlzEKMjdp0ARTXCxzDJCM9+l3xKMvoFFrntCB95onkgL+yNNbNqDeahpSKERvUtbF3jmI9FxMWmNQKU+WXL4P7haLfTFNzb8hOgcufCH5myf6zVrEcrHhKUANW9E11faL6YODxGLMfORSdEDiIzmRn79qkNsXsEHaeNv5TfBdrOxja/ZjgvN3XOGg3cBUrXEQHjc1JHs0hQevHFjMc5TrY5/ZFWhWs0OgPSFNLuFLMWWMioAXnUtseqkHuKDAKw8ef47aIiifQYh11peVMtm5k9AKIzMQtBCRIDI50Fujp6BOCakFwzebNfLcFGbRX0cvCEn3PSv5F55dE1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:10:47PM -0500, Rik van Riel wrote:
> On Fri, 2026-11-20 at 17:33 +0000, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Nov 19, 2026 at 10:04:04PM -0500, Rik van Riel wrote:
> >
> >
> > Right, I think I need to see it in context to judge really :) but
> > obviously we
> > can't be introducing completely dead code like that, even
> > incrementally.
>
> Agreed. That's been cleaned up now.

Thanks :)

> >
> > >
> > > >
> > > > 'need_no_page_table' isn't a great name either. Maybe is_none or
> > > > something?
> > > >
> > > Maybe pte_is_none?
> >
> > OK, let's see how that looks in context.
> >
> > Since you've not replied to the rest of the reviews I will assume
> > implicit 'ack,
> > will do's or what not on those? ;)
>
> Those are all "will do's", or rather already done
> but not posted yet because I'm combing through the
> series for other nits like that to address.

Ack, thanks!

--
Cheers, Lorenzo

