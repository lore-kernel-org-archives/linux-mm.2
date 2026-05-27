Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77581CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9A26B00B1; Wed, 27 May 2026 09:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AF96B00B2; Wed, 27 May 2026 09:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A016B00B3; Wed, 27 May 2026 09:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3296B6B00B1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:00:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA4F6161966
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:00:09 +0000 (UTC)
X-FDA: 84813207738.07.B30958A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id A1CBF40005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:00:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KRj0xV6x;
	spf=none (imf27.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779886807; a=rsa-sha256;
	cv=none;
	b=oCwXiuNuEc9bYJuMmHd84Ypwdld67V1FT2Ksk7MIyzhfgZyaGTDYcnOsbA+ripZM19kYBF
	QHOybbTIrgfSpv2TfkON7k303cxUDOKWAnoB7vuQ2DgLNePGWlvdVzshL9nuk1d/aMqwIF
	OIHxgKZ4KUPyIbSntMp6CW1eD14FnP0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KRj0xV6x;
	spf=none (imf27.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779886807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSOTEpS6jnOnkKRCoQQoSeSU8dByk24sxPymLSbbGcE=;
	b=rN2iucjMmKmZZM9AWyW6VX1WVa4m7MjcquQR+OGniN+6Su2dCyixPwMKGzugrXPrSbpj4n
	XVZOHEt1Ggb2FWyl5sDlqGlzoHzk1BEb79CbwsF5XPWZPnYNIvv6wNlWFZjVGKY/rYmi+e
	S6GXh6I48Y84zjcP55OSRIY5GBpBpao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=XSOTEpS6jnOnkKRCoQQoSeSU8dByk24sxPymLSbbGcE=; b=KRj0xV6xgukBl9D4xsqK6bZu1w
	dlb6+dENOCzrPokyPEyMx/A/gnulxCC8Nx++F+gqtsSfg9ClXRpm31kYxour0RKhesUZlRvTUFuRd
	19M6/F7BZYFc/d/YQVXxi2aRol6wjk4whwR16kRtSjpvF/JEF8P62hjtbSKs9ZYaGGLhnDdLMw5mL
	/0fgeUmYAN+QGS97ENVQi4jvijWsfdJq5nO4yD9dVYRbOLO39dr4iA5+ulp8Sq/8WtiFXraw/grNl
	j061BWxTakH+C5qFKHLDH5NrEG+CE7bdtola8Vdwh9FhPMYYePVoT2Ta0OQURkR/NFiZZXlYWpP79
	cs+2kb4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDrd-000000048vG-0eXC;
	Wed, 27 May 2026 13:00:01 +0000
Date: Wed, 27 May 2026 06:00:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ahbq0RdUyLIPiItB@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1CBF40005
X-Stat-Signature: ht99n8atnxr4ochig4dpbg5igtdexm6k
X-HE-Tag: 1779886806-372210
X-HE-Meta: U2FsdGVkX1+PyZrkWTw8/Z068g3ZV3AoNtFSBVh0q6iQkky52ZW323duvyOLeVqINxjuBXaBV2qcT75HZtefsliqvwL55gRpZ/NT8PhztA6HElKlg9T4+6/o4GaKpkkqzMvxbjPz2RmSjB2F6c2Qs7+c+/xCfS70Z81bL5qqyaT6lk+BvRNSe+rLTij22jmEZgRcI/u2uaEFyegPSJPz2S4BEtswQF2UN/2kUrcthgdJvWamncREqiYj7Y3rBO2VvrtOdvytFI/HXmyhpij/vGSU2KOkV8/2jI9hbPVUZwO4WTSV5/muG3i+1zFTdS3iNJpYFYw6wrKS/pwibac8k539HaledlZSQFIzNjduDzUFE5BdxKI90nnQbnLar2g3lbEQGtpUXTsDzY4Y1NbbDt7wFYRjY/kJGlxNbT1JfpSovij7fqBrCMZ2Oc7zPoc3eLslyuXMpfWClaSy0bFWM4yJSNc6I5l1SqBKpDgHgdMcNhbnCYygpHsHn3lm9APqdR5T36Zwg0YJXkP7J7ak6mzwNx9ME6aT1Rqyh6ucUOX6pqtW3n8aZ9e6rI/8pHbB9Mrv18eLzUB7K1haMS35tnzGZcj9WrwmLCS/imkSc8Q+gOdqC2vY7Wm7RsS3vxiFCXRW7HfrIF5to8a4GsFihLCtPRDSeDwhCLfnvgh6A0XSSNxq5Y2c7aRY+ZrnPlvBNPpOzxDdHpSS5LSs2qZwzb1fU7hu/y/nPQoyNSWtFZUkg7r+9gN3yZg9BnisepSsoeeExTKVj/8rfko9kP4lAPA7vFFkNDAPwCq5KIl4fP/05GPgsx1BbmIUIJyN6T5oFFIS/ZEEQQxzIhte1cFMqJQE0fbZMCWeJMx4fQ7v/MNHgrcwJuH7yeFcUXBbM7ZWBNFMlfhObVS0W2pZ9f6hSK8taK3PHh4kED24Jca4trf3JdFWlt0X65MqUb0cG3CHC9b5rD2FiKN4nXjTI+l
 Diuhz9lA
 ZuvYE+kFebY+SQUHcPi6w+qKEqLw4F+XxZim2RCFVeCblL9wV9B135sURj/uzThMlplfgDN6kGT5SzWODuAP90u/w5aXiBXrP88k9QuDs1qOt7Ngj8LseyIpn97PK5AIyaIG0OP2OD8kDuL9syv49hNedwQRto5k+d9jZ4U7TUd0jze7dX1gKdJk9GcZJ1Mc6f3RQhuBkNz3R4HV23WO5J2xiDXMqjkRJtAdRZa7wPFAZFF9gbzBGPzoHTEVq+0jw4sjq2dGw6mSkR3dh+gm7IqTPa2j0CJP/vBtwD/yWti2bN7mAceXxOJSUUWDzRPqWyBmngMcDc5GOABnRXZ+sQGVVpamWUoXqhh52y6Lu+mOq6zFz5D7RgXC+y1ZNWnpPPxzUJhBEakR7hxUagm8DnY4WKUU9nSJMAWR685gtG3nHpUa0olvEI4SPCwb1Bfr2J1VB/EcfzMleSSs13i3a1feqV7aknejFAgjKzskaSercH+7nllFBWswe36Y4kABxlzojDNmtGKSE1dEGiYkwb7RQ7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
> > I ran some experiments with fio on both XFS and a raw block device. Five
> > iterations each for 60s. Results below.
> > 
> > TLDR: Removing the delay doesn't significantly decrease user-visible
> > latency or otherwise improve performance, but does significantly reduce
> > throughput and increase context switches in some workloads (e.g. C).
> > I think it makes sense to leave the delay as-is. Thoughts?
> 
> Thanks for the test! One question below:

Thanks from me as well!

> 
> > Results:
> > 
> > Workloads (all `uncached=1`):
> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
> >   F: rw=write     bs=128k iodepth=128 numjobs=4
> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
> > 
> > Mean ± stddev across 5 iterations:
> > 
> >     metric                     delay=1           delay=0     delta
> >     --------------------------------------------------------------
> > 
> >   A seq 128k qd1
> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
> 
> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
> the completion latency should be at least 1000us but your results show p99
> latency of 36. What am I missing?

Yes, this looks a bit odd.  Unless there's multiple threads submitting
and somehow the completions get batched this should complete one
bio at a time and be the worst case for the delay scheme.

> >   C rand 4k qd32
> >     BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
> >     p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
> >     p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
> >     ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
> >     cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
> >     avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%
> 
> I'm somewhat surprised how larger is the completion latency is here without
> the delay. Is that due to a contention on local lock between the IO completion
> interrupt and the worker? Or why is the completion latency so big here when
> the case B with more IOs in flight, less bios per run, still had significantly
> lower latency in the delay=0 case?

Note that in the past we had major problems with workqueue scheduling
latency.  At some point these got mitigated a lot, but if they are back
for this workload that might be one reason.


