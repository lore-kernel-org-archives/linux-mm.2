Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B6ACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28926B0093; Tue, 12 May 2026 04:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB21A6B0095; Tue, 12 May 2026 04:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1426B0096; Tue, 12 May 2026 04:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 826036B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:02:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C56B1603E8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:02:37 +0000 (UTC)
X-FDA: 84758025954.30.A993280
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 501D814000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:02:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gFpbfVAU;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfRcnEmG4L1C60ic4jCNkQQaD5s9vtpkTF7+A4mU6Uw=;
	b=le5Imyo1DuAJRYVaHCFu5vkvWaFaNgTbAPEwtxp5isqVwjCHRhsZ2k9V4zhJ/qwLERTnnh
	uFCSHkG2g8h70iuVAqyhUFPhux6+UTT+JalcgjPQjkxrZWzqCxYNuQj7UNZZO9TmWwiA8S
	hVBwBmIQ/tIqlx32CGi6o04dlDRq1ZA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gFpbfVAU;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572955; a=rsa-sha256;
	cv=none;
	b=ZTfEnKlx2SujrWdYhKBuB3tOmVQ7cPbBkmKZOXkO5JqVutGjXN/bpWCp+ofQ5HHV8UAF98
	uvucsLlIS/gHWImzH6yfsGmpb2rGUtn3Kgb3XhalWw5GNX+d7+piI4d+GgKxetvaxA53Vs
	OGXfhHpxP98KlkU+L6otwfSUvnia04M=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so57830455e9.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 01:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778572954; x=1779177754; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NfRcnEmG4L1C60ic4jCNkQQaD5s9vtpkTF7+A4mU6Uw=;
        b=gFpbfVAUP3PwCk9kq+RYT4OxaM9sC5QCa1HXNZZDCga7EeGOT0SIqpPvlA8RhXo/zR
         weBp2pa93NsCNro2zSmCYEffaebxhdCxo4lJYkkmE9guXHJjpsecWJUX3pRzh9miRSGM
         KZ/9slH+iTCKWCcnrxNYyf9rARk7u2uSenogFjiTixzQPWxQqvkm4znO8dYTfRfrdtEX
         gksBcJB5CwJq17ac8UPjzRT0LFcc8Wf0IbYeiF6E2Ac2CGE2Xrcm4opWUFtCx/b+kCoU
         6O/gAWTSxpmbYYYBl2j5Q60pFPKtNcexRJa5WdkoV00sr23J0pbR5Yy86RoW8tnq7BBu
         7ASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778572954; x=1779177754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NfRcnEmG4L1C60ic4jCNkQQaD5s9vtpkTF7+A4mU6Uw=;
        b=nSn8yRy4uVcO4dy1WcDHOC4yPUMAjc7NnJ0/lMCVfamv6nzEj855goAsyfkI221ilK
         NaJJGuvTBz/VivikJGwlMr+KeYm3k/ZIlBfmGeh289YoNE9crXdKOxCO1rKYXCmqPhut
         cX0hCru10zuoEwY+DniMD6KXq/m6TrBfxkoFtZosWJnS2gqkzeXnwYL3z3nyjLRRGaG/
         rCx7e9FljSXsxYsZcFl2suekspbh2PNmsdwvg6to4NgloGNXwz0Rk8F5J7BWVhMz/+uc
         FU4GHSyJdow4A5AJhITggWvXyY7xnMil9946kuT8IzMQoIUxK30FbIVnTTwOcmWfd8AA
         pzdw==
X-Forwarded-Encrypted: i=1; AFNElJ+LJ0AJb2+lXUUKExKTEE2ZsL5u+3hd+j6nIt47A5HmLAity/JSZMMG5XnMGGAux6aYuKL8hlCY8A==@kvack.org
X-Gm-Message-State: AOJu0Yymt1qLCkvzyTM5YlOooNkgjTSt1sWjL165OVXVb8qWUlY8Vt1X
	O2T7nmmLYaX1qnfqpUG0yUBdE3O4OYL7pXEUUrfbbORbftjXhJtAPEgZ
X-Gm-Gg: Acq92OGv6Baf36i376SBQuZw9FjJLR+FP7AjtFHZ3SXQvasOt5auwujFowolgLpZ1ev
	mjxXDLRvw6xytmuZqJLhl80bu+3JO01a5QPfa+1TdmWOWzNEuYL9wku7+e2gBuj7X1yPmk94DeY
	0uTrKHjjYHgOf/W8lbDShIcJ0NaGvCtVRjcfXWryNcJUSVGXl7NEnb2HRQK6XrAIncDKoM8z8wi
	f53M2l3HBQ5ER2Cgq4rgI6VXuhqvcDoB9SNJLHjYHG0ukZPj1+vQP3ASmgRlN9nRwAN7zWZhno4
	iPySBZd9xAIA5ficG0OZfgX6duNQogVih+9MGT44DZ1iZeBkNqp5lP6bvbwMHE/fSsWuD0BaFL3
	5yb7qMkYqRVBTZgltSM6ZNi8UlgDOWmvOHSBQmflAUdRMK1wGVe9MX9d5n6WvMcg3RTqrysM/ga
	sk+dKkfC/Me/Xcwprvg2rE7m6ZRIWoAJ6IIUkX9XGmMl5TfPcr+kCWo7H9nJfVIUNIghBaZwApj
	ro8tzzCLX9XeIUz49yo5V4hNXGaSR/USk1ltRnitl5f
X-Received: by 2002:a05:600c:4695:b0:48e:5d91:cffb with SMTP id 5b1f17b1804b1-48e706c0662mr199733775e9.10.1778572953433;
        Tue, 12 May 2026 01:02:33 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e906a06d1sm30409515e9.1.2026.05.12.01.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 01:02:32 -0700 (PDT)
Date: Tue, 12 May 2026 09:02:30 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
Message-ID: <agLellX0pB1IZZlE@fedora>
References: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
 <agHPIcZHHyzBjcGN@fedora>
 <s6hnqm4bbi5j2ergudihydboj3uw7gsu7te4dfmjgv2qeosfbd@yvhp5oy3r3b6>
 <5280b6f9-e6d7-4854-bbdc-ed5349a478ed@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5280b6f9-e6d7-4854-bbdc-ed5349a478ed@columbia.edu>
X-Stat-Signature: ahqmcqcmwcigpxbnpayd1oaao6n58uyu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 501D814000F
X-Rspam-User: 
X-HE-Tag: 1778572955-203067
X-HE-Meta: U2FsdGVkX196d298eyO946PTFNHXI2mDZTgmj3v8+2uantJMP8drtVNoQzxOgbcdqqnNGDo53PfNkGL6qvKmfy2zoaXJ/T0fJIXegq98gLoasah/lpL9yyBtmJWSC5eYS6Crrtgvs6WLOX47PeXAYpTrkpUE0guLwMFtVdLx45vDbTbcZDvAACrWCV/YEIkmKG9p6DIcwVBU3mYrwdSz1psrfJ8HY538hs4i6wMlkmJHjtS5Xla9zuIXY+fPWZLGP93CLgxIVa2s2ZaEn0IxTWlRpERTKQWOwK1/hwNwkcSWmlfXX+L2V8BR2xeVa9+YfeviwJh1wo+WDj2fvr5U9mNgbrmUhpaAGBTizcbFoaWb5FM+S5RT/yHLA2NoJRPgnzqHAFcUDiOvTuMhRolv82+Z/AuefzM+pJ5n6h7MDy7K+tLy5MZ04S/RV+lrhSg/FFA650K9T0PrxqdkoXGoiuVk3ectBwZEelS3ph+i7Zx0EgX+iLsWV2uHAka5D0SiguevVixOR79mtxsz4LQ/SJmjAgRud5cbSlt7ubFpjkxjvQyOEQyxsAxEPUHQroCOjJJ6OfYDDp0ZFbjvl6AVHXPq8h47WNV0Qp6IMBFEYe2pCDOF63IELBU/tRuTGzqKSJLlF6Ne+V7gvMaKhdrgBQtfOTbyQMlhzSSlsBncjvkK9SzW0cGuWt3MXo5fQW5phGxSXgQobSTq9zRHi0RX/I1vZi950dLFVrgM+1wNoE445tgYLsJImAmH78gALUiPnSJKPK5YehJTDdk4TZDAbHZLmJ9A64SpLsyK7gdr25TiVw/e6p29wnmsMMmQ+NE3ZHwhBiDK1D2JtYK8t/28ck8zfwqUPMpt891F/Bc6AG5j1YVddQT9VPlVtIsTCbOIExqwhXAJH9Vj90WSxWmBlL5i+AHTmTKiJPomUsW4MnX7k7dwLryxzJdwI5QxIO4Fw5RW5QjIOTO8Roq/eRW
 8XNmusIp
 N5/29gfuCKUgVNhUmVRUINeQ7BUo1EQFy30Q3rCK7MkXaS9aZ7uu736QS/tOOsiDidLaJzpgAqXaatiEY2NG1IhVqoblpDsi+FltdueKkFGfVm70hMBz6FZ4tEBoQIQKOTHR4XcNxKQPm9spQacN5Cv36hqSZpNPRajV/pkbhCfdSU9Tiq+m7nvyoop6ciPoxIagbTYDZRVpzFmtTYJ7EfUdBePEFXpHkogdkBkO+gJbEd68I5ueQ7rQ1dlEFv0kepJ7X8I1n2LadZM0GzuJM35tVSWDnBdsJKCl7nIIpSrFXmAOO4vA7rT9SzBR9qaIHNdplZYEhZYfeod0cUJExDUKFCwNP1UuDjRM1tCARQSRmoCXh4RyQ1pYlVM0bAZDv0NDSI5jD7I0ug6r3PGP3LormprFijVfgaNA6M2PYsmQkC3W2KoIv/0pnQaXAww15PdSlY7giIvhrAMzhbhLkTsaDN/KcHsXHHc1/8iNbxVk0Xoen99BGjC/IQdxIilfHfcje
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 02:15:41PM -0400, Tal Zussman wrote:
> On 5/11/26 12:26 PM, Jan Kara wrote:
> > On Mon 11-05-26 13:44:17, Vishal Moola wrote:
> >> On Sun, May 10, 2026 at 05:54:17PM -0400, Tal Zussman wrote:
> >> > page_cache_prev_miss() is documented to return a value outside the
> >> > searched range when no gap is found. However, the no-gap-found path
> >> > returns xas.xa_index, which after a successful loop is the first index
> >> > in the range. As such, that index is misreported as a gap.
> >> > 
> >> > The sole caller, page_cache_sync_ra(), uses the return value to estimate
> >> > the cached run preceding a sequential read. In some cases, the buggy
> >> > return value can undercount the contiguous range by one, shrinking the
> >> > readahead window or pushing borderline requests into the
> >> > small-random-read branch.
> >> > 
> >> > Mirror the fix in commit bbcaee20e03e ("readahead: fix return value of
> >> > page_cache_next_miss() when no hole is found"): preserve max_scan in a
> >> > separate variable across the loop and return `index - max_scan` from the
> >> > no-gap-found path.
> >> 
> >> IMO, this way of fixing it hurts the readability. I'd prefer something
> >> similar to the fix in the original commit. Or...
> >> 
> >> > -	while (max_scan--) {
> >> > +	while (nr--) {
> >> >  		void *entry = xas_prev(&xas);
> >> >  		if (!entry || xa_is_value(entry))
> >> > -			break;
> >> > +			return xas.xa_index;
> >> >  		if (xas.xa_index == ULONG_MAX)
> >> > -			break;
> >> > +			return ULONG_MAX;
> >> >  	}
> >> 
> >> If I understand this correctly, couldn't we just do something like:
> >> if (!max_scan)
> >> 	return xas.xa_index - 1;
> > 
> > I think the easiest to understand would be to do the above two explicit
> > returns instead of 'break' and change below to:
> > 
> > 	/* Return start of the range - 1 when no hole is found */
> > 	return xas.xa_index - 1;
> 
> I can do that, but I think it should be consistent with
> page_cache_next_miss(), which does index + max_scan. If the xas.xa_index
> approach is preferred, I'll change it in both functions, and also get rid of
> nr.

I prefer Jan's suggestion, and making page_cache_next_miss() consistent
with it sounds good :).

> The nice part of 'index - max_scan' is that the kdoc describes the range in
> terms of that already.
> 
> Thoughts?
> 
> >> > -	return xas.xa_index;
> >> > +	return index - max_scan;
> >> >  }
> 
> 

