Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 441FCCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A936B025C; Fri,  8 May 2026 15:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB486B025D; Fri,  8 May 2026 15:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1816B025E; Fri,  8 May 2026 15:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6606B025C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:24:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30DC4120293
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:24:26 +0000 (UTC)
X-FDA: 84745228932.07.4E5CD1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A7C6A0009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:24:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EJ+Bh5mD;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778268264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5M6iJu7DlPUxbEPH/VA2ALL7KeBXrAH30EzIS/8VpTk=;
	b=w/UNbcLXEvvCjbsBQqbDt6sLfU1TWJTUhLIVFLgsMtZTCH6Sl5OkUPBl8iffK73MMsRNwQ
	C9oVPM9SKI13TRRlE9f/8Z2BDIauqmdHP41q5zjcqfp5nVpaFKF0PIrOVFFGuI6TWlYNer
	xTFENKkE+Pm1mQXfcZLYi/QuGp7AveE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EJ+Bh5mD;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778268264; a=rsa-sha256;
	cv=none;
	b=I8+1tIT/HIjFkETwr/jqO8h6mjX0kXByQP65UgPioFWiZOsN/6W8B0PyB2FBuAu/I1BG5G
	lNWuv7UzY85fd+ynfNk46X+6M0jcUr+8F592F8UkH7DvhvqHfrLOwFcg/kl6NjaZYHEr/t
	Tw6s+yaTn0dUVD5UBoV94R9KB5Xrtdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C22C960181;
	Fri,  8 May 2026 19:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C203C2BCB0;
	Fri,  8 May 2026 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778268263;
	bh=pONcesk4eW9hqoctdXvjsTH9oiWSx8NVPbwclBtY0Qs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EJ+Bh5mDoFiVGST/VZ9LwjLJKNxgl8Don7jXz5gvsv1Gl9TQxigrS7FDok0K37418
	 N+I720wtH35BOkVZermgSzgA0IcVOAtDvD6kv1LggkTgO8BHAcM0QPq73lvJ2cCis8
	 DIONaBMWnco8GwTjT1SI9czmvq7ZzK3Ph9Q6ieNg=
Date: Fri, 8 May 2026 12:24:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederick Mayle <fmayle@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, android-mm@google.com,
 kernel-team@android.com, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/readahead: simplify page_cache_ra_unbounded loop
 counter reset
Message-Id: <20260508122422.00ec86bcaf2fd3685332830e@linux-foundation.org>
In-Reply-To: <CAHCxdc5Kug-o8ubLmZgeQdcFmhvAMmAtNUc95t1kx3Wjggbnvw@mail.gmail.com>
References: <20260501011908.3630802-1-fmayle@google.com>
	<20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org>
	<CAHCxdc5Kug-o8ubLmZgeQdcFmhvAMmAtNUc95t1kx3Wjggbnvw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ram985jpihwm1ckpox8psp8wb8jgecsw
X-Rspamd-Queue-Id: 6A7C6A0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778268264-710174
X-HE-Meta: U2FsdGVkX1/TV6GE2jtwTIyIIE9kbiyepte/hkeTFk8CY8OJW0FFhEC7nWAPXr/Q9b5Sps0naNMiAR9MVUDVUALrpkcxLs7q46vbAhfOD6RtoL4BVqBnBZaeE7HELQGSajHeHrrG1zjrpRwSgdGSkWb748y5eBp0xoJ995JKj10Gmhqm4C0xu+XJ2p5koSpZ6yUSls2bSQeOTDuZF2M2tWkEP6U73232ByU18kfES3gAZyrBI6ziBaZbzWmqTaNNMnFfgJXtUE+52DrFzSD/UR5X4DzHelnge0kNLgXo4b1CgtNyM56EB/GmOwH3TdOwUHpuNhXFcEGV/bxTpRPwzY96alb1PI+6d/dOuKoYeCJDDPQZbT/p+W7mJwY6ybwGpadIwd8r2t5PYlj55on59BemtyzaZi50E2nTNt71dF4FonOzY0n6lMH3Ui8MHXhzWbSUxVkr0fycf296gFr1OPMMgpMsBC2z4DRtRD+I5mpGJYs0oGblikzlJkwnWIQVOhEWnBsrQbk+5g40vwcIEyQ8Q4fFD7eAJ7Mf8Uh/rnrMjIHIyM/95Drf3RGcWbXJ/POnSYaMGLhGfEQ4Ndk1AqJrIthz6wpUZGslzTDnfmuuRtFkh2Brvvq3KPU+AYRjh7sLTZZqQnt2Wk9o6G2gCuaVk9zatUXA2mH5lU/iTGN5b2ptKHbaLXaxPHkSRngtghgfvsIUMfGV6Wt1L+DAFYrTwQXMUdIsz+KpVnbF0c3U7IZXXiCVa3UPjT7c6Z5pMztYvAM+PTt633fzpSsMtLPiE/3mrJ85e2tYtxEhuLNZHUUfcAOJXPaAqkksQbqmTfCzEjuItKR5ahNLgfSmrlF889T62mYAtdnvAVd/NYNspyHZqdY1fjSR3ro+hKpXpwAcS6kGAoLEf4KoMH292UpwtSgo6N6UmQo7yupZw7VJH3RAK0TS0hLpAQ/uHRZYA2BRtJeH5RXbCHWgVSH
 NiLRujma
 ADqhnZoExkqcdoldeZcpmDVRCIJdd6yrek6RPeNYO8c+Sqxd+BRAvxHI9ucUKicqEhQh71JmzwNF7xOnXrLpnb0SmOT5fZBL2QS+qJ0qk9KwgWhsNqKublUls/aMUSfkisMlACJW2tAQ4WvG+OuBQ+Ex9Cj3CS97iwjT2bVTn5gLir3kUVnQdFpbIDTuk9brWInN5PZZfojJbBz2ioMPcNPxzDMGBrULBP3FqGcpTOMIAufsrsTwMHWdpZGrHpSYdlUi6Nq4NZpJn3expQzY/o8zJYMmiDIVmOqpii7KMCyHYcUKYiPdiXFdvujAO/dy6Dq5oo3kwdHRZz4eMZt2ViWhqxzx5oZH34tbSekQBV1RZZSPdy3p0ykDfD8HKk7mT1MqRB+1KD9HoYn2q8q3oOEMChQbdvLSdmSL8tS4xTU6x3Sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 19:01:27 -0700 Frederick Mayle <fmayle@google.com> wrote:

> On Fri, May 1, 2026 at 6:11 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 30 Apr 2026 18:19:07 -0700 Frederick Mayle <fmayle@google.com> wrote:
> >
> > > Minor cleanup, no behavior change intended.
> > >
> > > `read_pages` ensures that `ractl->_nr_pages` is zero before it returns,
> >
> > So it seems, but depending upon this might be a bit fragile?
> >
> > It would be better to make this a more explicit/formal part of the
> > read_pages() contract.  kerneldocifying read_pages() would be a
> > suitable way.
> 
> I agree. I've sent the following patch to document the invariant
> https://lore.kernel.org/r/20260508015402.735441-1-fmayle@google.com/

Thanks.  I suggest you turn both into a single patch and resend when
people have returned and recovered from the conference ;)


