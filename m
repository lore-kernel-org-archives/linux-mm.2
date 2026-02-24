Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7401E9B262
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE7B6B0088; Tue, 24 Feb 2026 08:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6BA6B0089; Tue, 24 Feb 2026 08:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D036B008A; Tue, 24 Feb 2026 08:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEE846B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:10:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76A491B4AE9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:10:09 +0000 (UTC)
X-FDA: 84479383338.04.E3EBC00
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7B5351C0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:10:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vBUnboDs;
	spf=pass (imf21.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771938607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHmLfEoIM1CK3zmKD5Au1dNJD5+SaRgc7xYd5V7yZqE=;
	b=xsEtBD/0on8JuGavwzIJz2hYoscD9cd6u5RtOoDL7pJIhHlz39W7VzWDHyQhJ577lRnLRu
	0sPorUujQGgMVQoM648Yo4JK+xzEZm6283Jap3nJiX6JQY/CNYCtrsBdIeXllxXmEZERT8
	6kxnw+2AH+RL4HUFJIQrBygxyMYSdsM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vBUnboDs;
	spf=pass (imf21.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771938607; a=rsa-sha256;
	cv=none;
	b=Pwr/RO4VIlID53gojeIlyDs2XJlIifHUkZ7JmK+I/UnCXIegBVxNy76vG4hBXbW2125h4R
	JPZuslI4LaQYBrMbog0TxhHiHB1UBMQwlFlVWFI7nmLG6vx8DfyriBGe4fsR2IrHvnc6LW
	iotvChGEnW0DCnpJWoSVXaTyuEUzUJU=
Date: Tue, 24 Feb 2026 13:09:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771938605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iHmLfEoIM1CK3zmKD5Au1dNJD5+SaRgc7xYd5V7yZqE=;
	b=vBUnboDszDrSTC7QiGdYqXIqUsnhzZtkBEA7USdkiADpAfHtm6T9DfjxqFbBXytJE/L6tf
	VArkOf8r/dQ6ACwRXGLIXwSKcO5/2Ce6K7WlXo7QHh9xSLKOPcT0T9ZXHVvQDlVPSJhahv
	JWl83yCyyqPB8h4ZtUK0L5NzrygQuY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <rn5qoix7rattqns5ut7q6wmasjm4x3usfbh5x4e7yg22fzpiqt@744cbmehelmt>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
 <20260220151050.GA14064@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220151050.GA14064@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ajpdw5mjb53wtbjsqnzc4daaexi97cp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B5351C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1771938607-76503
X-HE-Meta: U2FsdGVkX19HyxAAUAnobc5gMm2jazHx/+eXk5sDvrqigWUIjQxTP69GmG31eVLe+5z8y+8DZSAy7moyhU+JJQuTqW4BovLZDZTyIcf8aWcbJKW/D3m2Rp3pHVB+jnYrvMUWuqXCVLWmlNkUH31O6sTM/9bMG60SbRgezlctmlOlT4TmDWsFVK+BCfnprq6QL6qGG7fNsPVk3z8wJg+XCrJCV75GdHQ1dElOMz78KeXovVAKvb3fY6j7HNvBKTS5AHxv7PIS22mjf0qEaGziWd0FyU0cPHsf0UfzHAzKl9ujv3Ussx0Ss0zavu2zf1q72koh1Sb32yGJCZYDPNneFHq9tR64AAlNFH4suRFQIo8ydzQ9UHMuLOpQ1kyjO4Q0yqKLyP8NJhuZp4/F6Z+okG6rxF4Pkkx7Gqq3ygt2DdRUsIf4Q1Om6zR4nnbNUM04toTRG2WiDF0SZYZnWgohTy/Mtux8wtQTXtsCIvSu9Luw8+TTA0NNJ3IAkthBY5ZtYOf13RF62uu6Yy57BNOob4iBUt7PyQa5ZtYpsTQwddeVdfgb6V/sS9xT59LewL3cUdChQYeC7OziFPfV+xpaX3M/Vrb4dlwCZWKO5P7zRcLKJ5RcR7TaKcwlxxfy40gGFnReozPdrs1ePFtRNeHrW9oCd65DjLm3Ne695cE3zc79OtIYyg9HYhGx65BoN/G4IKmPk/Rc5Ge8CoTn3FiWMn2c+amzVJ4ZzqhKsyfRO+/oB6rIkW8GwS9ViG1OxLcHQYop37XzsCRIU65jhzLSgpmX0S+BcE8aauM8jCimekM2k6Jkb/tunFdAb6RZ7kKOA8z/FCfQH6sC1K/X1jUI3bUP9rbHkmvmQ7wJeQJSZlFr0W6MDYw9Rp2NrBf6BR4dkKkLtXMid41h28yoJ7Q9zWYWjfXciRHRqJGnxiziE9JwsIYztFb2jYxHyoea2rDS8xsjgT6PhyEWx1OQ6UL
 2Hjd4Hig
 kt0k0NGbtlUDF+0q97A6A8qRjb5ipLTRdsE/zOEVfTKPorTXaC5uUDInBM2K/1fEsCqtZU7YRPrRvfocmKQXtMFuVoGLO5INbNoaWIaMMjM/oDYOCHE+dPxQmcHa16eXnl9OXOUaT5pqa+ht1W/1G1xBGvAbdh7wCcdIhnLdLtR+/CJLhYCW2FBIMG5wef6XYLEDvvMcmc5iBE5PwRe9xBmnMR8a9ICJcFOkuKP+4CQqqxHW0PJl9cq9To8a/Dkrg2Wt02t/XURUGr+ks+B3aWK7GgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 04:10:50PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 20, 2026 at 10:08:26AM +0000, Pankaj Raghav (Samsung) wrote:
> > On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> > > Hi all,
> > > 
> > > Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> > > for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> > > remains a contentious topic, with previous discussions often stalling due to
> > > concerns about complexity versus utility.
> > > 
> > 
> > Hi,
> > 
> > Thanks a lot everyone for the input on this topic. I would like to
> > summarize some of the important points discussed here so that it could
> > be used as a reference for the talk and RFCs going forward:
> > 
> > - There is a general consensus to add atomic support to buffered IO
> >   path.
> 
> I don't think that's quite true.

Ok, s/consensus/some consensus/ :). I do get your concern that buffered
IO might not be a good fit for doing atomic IO operation (I also
mentioned that in the proposal).

As you replied, either direct IO or writethrough semantics might be the way
forward. That is why I mentioned the first step is to do a prototype of
writethrough and see if adding atomic support on top will make sense for
the buffered IO path.

-- 
Pankaj

