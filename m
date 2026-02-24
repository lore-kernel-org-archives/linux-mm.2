Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A104BE9B269
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DB76B008A; Tue, 24 Feb 2026 09:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1FA6B008C; Tue, 24 Feb 2026 09:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFA96B0092; Tue, 24 Feb 2026 09:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82CC06B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:22:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D302140154
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:22:35 +0000 (UTC)
X-FDA: 84479565870.14.F2FA752
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 80957140015
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:22:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DSXljtQ7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771942953; a=rsa-sha256;
	cv=none;
	b=6AlyzEsd5x0cOi6DsfkIogvb+MoCk3xh1Qx/VGd47ws6gDaMfOxdiZQsQEyOR25KDF3Sjm
	vv9lHU84zf6O9jU8Z6gUERd+nH/2HYZUzW+SnboACkA6j524Ss6f9YHc4pF+M3AuP0wXnI
	/j0LZFX9wgWBYORtB+6oohmkHtTPVYs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DSXljtQ7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771942953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSb31zFXmK9huknQhI+p55nBi97KODseWc5XOPajHSo=;
	b=T4Z2J3TXGRkiZHuLxjE5RplsD4Mp2kT4KawHwveKjmYK0aWGrMnRC+WkkF6FQJCZ5entoH
	+6FaXTvNzpzUIdEXLXZ4cmkYKSTotvqDvHnXw1jea4l0PxUQ8r/lNGI6ikEGB/hIza03td
	Zpes+QBAPZqQ3QFk7ZgGMn0g9TLosdQ=
Date: Tue, 24 Feb 2026 06:22:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771942949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NSb31zFXmK9huknQhI+p55nBi97KODseWc5XOPajHSo=;
	b=DSXljtQ7lsBTnmwjZ18REZE2xI7apciPNHdp8TJGqD3fiGLjl/CTpFIZ6tSdMr8d2YNRdy
	KjurZzBJDehgCTdqfTjvi0+nyK6n80lcuGVLkkyKIqwHYrByfUBb+61f/QFl+VluET0f5r
	RRgzpvV7/vJnbd4ycQBLGqIS1guzdt4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com, 
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2zPzyoFUUNWdJ7@linux.dev>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ2voRA5VJytcfLp@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2voRA5VJytcfLp@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: encxhajfgoczzqxb1mn6sjq1cmga1u34
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80957140015
X-HE-Tag: 1771942953-843639
X-HE-Meta: U2FsdGVkX18m/CXTtP08CTfz2xHNNZKnfuEBxMGVKpk8q9VU79wDbI2/eDvd6cjrJyKkiSzf9DT78oDDkwx++DoM1Oft4nCkoA3O0jYkId+Bk7hbkZaa8f4uqtgrVHGrmzq/1nphpX6X6QX45G7GhWH7K5n+7NB3k/1Bqa5+n+GJg7KbEUMb3pERgE7NLllFGUC6+husr+HxeRSk4HJBqP5kI+cMONb16iWkkOf80R480OUteWeS7XGAvS7EQgTsi5lMyEX3XBFQtWBNtf1R4HR9na0jvEaqjntyIzxgIcLxLeI93jQRZaZ2nNI9+lhPUrwdS9vA6x1MAD09Tnn0TxSXahYbs10e7cIPxFaemxQn/E3UTXtbQN2SCigLJqCeqqA/YIV0YWnJBcjB3z0NyyNEK02oSGpTSfGtRJRee70UMmo5iYg6Uu2TJVDFDuOs9Xdvye5strn7x5P/Rwhf+rdLb+xNh8EOt7dM12IdyzIygj+CgDwQ+5USlqsrShWT1vSe4SFO+O9LnIKHUQWMMWxRziaMFfn7Q3ISAwBSdPpjWdGtMMMwYOEOVP4ypD/+1dElLhrrHS2ekEfHz7j+RzOrT7wGt8JDU8AYdPamZN5JzMxocFSIQng5twD8ajfsZa8gaM5DsP8jD0hBl6Yh+1rO7Ud4Vm7yEFqcVg6tdM6p+htbCRx+zduVFpPmED8V8Fv5QxFYCI5XRrP0j6CQZEvLGd0dLFKh0CFbdZkZ7srzaKPPQ2gTk2T/yLC8UdlERIrbsFChcRF48EPuGcU+1rXBYKRfFvn7NVBK+7O2x1pI6XoseeWVAyjgegz7BcqstH41KAUR4TtQ9tzgLhAAzEqY+m/m3BUtDHd/qlrPziHYadADoHlpvrcR8TjHFc3AJ52+w26qQASEAJCqHtMpJDRkGFRS0khRkgTVBRuxI9o8IuNRrGez5BbrJcfABro/fB5gBUJAvJ/CrtBE/9E
 HGNok/Y+
 o8o6dQrUDT29Qb4+n3mT4xYcQw/aDVlWXuwqnOnt4v2Y1Y2/RLn8cvunib3RFVAGUE0L3JL1EahjEZ1ocwk97Y5Epvm2FK4JBoMo5j9KSnnTusWeKTJ1M78ul+MBMv2bOCktMzxQ/oi8Vk03dVbZYO9q0QMZyA07ybUEj65pB2RB3sDA7uE7kT0ea1RvYG8fvmcai3KhjLk75qV+VixtCPn1ktEPP7Gy+kKPf61EPRiREvok0I+oUJHLJdJgNIbVsFtpbswfEV0n/EwDcxlsveQso7CMtOV9aP/pb7jdsIjwfWS9qrPPlnBdCx7vHaRK4MKDkUQ5txejth/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 06:03:13AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > allocations as those could be achieved by scoped allocation context.
> > This could cause pre-mature failure after the whole bunch of memory has
> > already been allocated for the backing pages but considering that page
> > table allocations should be more and more rare over system runtime it
> > might be just a reasonable workaround. WDYT?
> 
> Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> too hard to allocate PTEs is not breaking the overall concept.
> 

One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
use __GFP_RETRY_MAYFAIL to avoid oom-killer.

Mikulas, is that the reason you are using __GFP_RETRY_MAYFAIL in your use-case?

