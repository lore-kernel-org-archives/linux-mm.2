Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938CBCD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1A86B0092; Fri,  1 May 2026 10:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9336B0093; Fri,  1 May 2026 10:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEC96B0095; Fri,  1 May 2026 10:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC34A6B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:34:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4275F1202AF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:33:55 +0000 (UTC)
X-FDA: 84719095230.18.70F2C80
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 856F3A0011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:33:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JlLp3nC5;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777646033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8jd2Ibhvngu1lVvyqeiKgt0aWWT1GOPQoZ/zlGkZL8=;
	b=VkXn5yVz7RFd1fLY0QEVZqkk6mecIbm9E7Kgx5ChTHRcsERiFUbtLUOOzv8QQdVO9+G5Im
	fP6gMPnuO89UbU3jMCBDP70EHdlg9XttEux9SZh6txw/2+/o6lhjSnlhDLZXvV8W3pZ5Ds
	JADLESLmU3dOBiSjGEpjtoGJwSflRf8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JlLp3nC5;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777646033; a=rsa-sha256;
	cv=none;
	b=cAkbor4gG77pq0lxsfJT1amrbtIUsqHdYr1CO+xyakWOWladWcAEATH44T6fPtHSL/OYy8
	hDHtl3ar7tdZ8/NIX+t2SYgyS+DXNHUwfbWs4hjTQPFtdGaTH8pfh4R9doeVHekZ/tWkSX
	VyvnyZz3oNYooaMOyjWfGein0EB1EgU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j8jd2Ibhvngu1lVvyqeiKgt0aWWT1GOPQoZ/zlGkZL8=; b=JlLp3nC5QFGk3BtYNoCroq6B0j
	W8vgg5A36MBeE73KXsh7wwLma6wYSWPSTTkHLwVBwvjVZjFOW3sgYis6Gct1JQfK163Hh61tV4qMp
	KMEh+6l5BPnjaI49jE5mhay65vaEoA+TXFSkRoeQUI4e1T2jB/Za29AARfRwBtumwLtBW1Ab37L19
	+bxEysJ3BHvjlBsh9nAxPA1FnJHLJ1h1GRnAXVUn5g+AxhgXfUXC6qFGQx5bOQA1LnB8y2nO/ajar
	uwjkKWnejgmtab5TkN7pECXk6Zp8p1VfQeopvoT7wj/ei6uY7GislSmeaNeUw/arZYxbGSTSTxmdD
	KVP2yyow==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIow6-00000008v1n-2Dtr;
	Fri, 01 May 2026 14:33:47 +0000
Date: Fri, 1 May 2026 15:33:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
Message-ID: <afS5yn5QreBFQWLi@casper.infradead.org>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 856F3A0011
X-Rspam-User: 
X-Stat-Signature: znmj747u6i5c74kjdcazribpwiui6ip4
X-HE-Tag: 1777646032-423721
X-HE-Meta: U2FsdGVkX1/F3VMmScPodhg5LolT5PgMIjUkIJABDp3nuOz4KixLs4yms0H6iY0JGcvbva1EwqPGq7y952xPOt11ExNNKBX7CYMzfQUeQYwCjY4RmsnzqhBKv0jDH7/UFudHTGFG/prl3SeFPG7WC8WySIRI4irvcugcU4q1rhLrpXYNyc6/A68vCYDHf9CueWWvN2Ui8NlVTM2+oEw2RidQNJJaO+G7MSX7qL6MrXDYqqa30/aMilTxYe/mICAGPm17K82NUG4xdg0AI3JEME09wE5NWVRDIJe0h6WwZb7ehKMcm/9OKax+IFVoSRe/yAOOPhSH4YdmloWBLVQbBAQOPTSAs48MgLMFyEnimy2oWaIUMKSAhHw/pCx2UZWh2BUi7L6rVefE1iUchFA0LBsxW95vVcgtcmDUmIXMf7ElQPxEwpXTLWv9ztWeMaoZq0ul3HZZ3zJRDiJMPwoLkp2CxperZOCsbK6jBcrS/qfck78e99L1JTcD1J6rt4b0i8s/Y0J+vAEjRNQMecFQesmLDdFi66/CGhV7gLwlTIj0GG/IIpK0z/BhatDuzQZPCLC/QeBVq++mrmJ307ncT+OkjXAWiUwo66A8SPaA3fBDJwsAWlvw1DX9edbHD66l84YAWO7RhN1qrMfDkQKdKGwn9seM2uhwbvZ627QhxhoprbasgVFSeu+Zg0PcHiXXeTzNZAFAhC/IoZ87EQ4W6JuNxjbAeWgDP/1XQZlnbjxYqiipWctKh0ttCDhqA62IY42p4PRgNIUn8SPX6vhA7W63pzGYtQDCRbNvdPs7JolBsIbTQzqx7l7wSxuCr2uKMp0Sh9oKlKXsiE4m+aly1HUa2+07CHDYQNTnAUwMJbUvTKYMxeerP8GTjGvRCcwdsoUrsVnO64JvuogTf6d4kEyYieLIGGtzOPvpkB96SiCO/wwMXVyMSNqUckgW2g2vwXCzlSLc2F2iRNbAZ8R
 QiDF5/JU
 dRjli+SXtU+DvbXQU1BUKmrrx5t2ENMZBs1UgfN0ZVIBlNYGLRPHxUtuCksI0TS+l1J/R+VWl6NdYVpqXfLiAoQcSr+xGJN8L2NjnuO26u9D0BUfY7g1Vh2DSoplT7WUJBZq3G6hC3K6XkuTSV3nBh9CdxgQ+X6cEdgiwCbGfPzsxUjH3rb0aeIuvoMCGvwGMrbVDEmlgTAYQsltH/UAyojoE5ZEg7JsCgA8AWpWigl8YKBgdpSYp+DnnuI5zJMbspOKTUut3ZbCX0DOUN6J/PJ4iorCHjZauSnLxfBxZxfYxC8wbBGZP4QUjM6sS6xBQDsuX0W/CKneONNmIDwBiPlzVzHO5iljxi13QbFPCfand0EHB2V8rK570pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 10:54:48AM +0100, Hannes Reinecke wrote:
> I (together with the Czech Technical University) did some experiments trying
> to measure memory fragmentation with large block sizes.
> 
> Doing so raised some challenges:
> 
> - How do you _generate_ memory fragmentation? The MM subsystem is
>   precisely geared up to avoid it, so you would need to come up
>   with some idea how to defeat it. With the help from Willy I managed
>   to come up with something, but I really would like to discuss
>   what would be the best option here.
> - What is acceptable memory fragmentation? Are we good enough if the
>   measured fragmentation does not grow during the test runs?
> - Do we have better visibility into memory fragmentation other than
>   just reading /proc/buddyinfo?
> 
> And, of course, I would like to present (and discuss) the results
> of the testruns done on 4k, 8k, and 16k blocksizes.

I think that Rik's recent work is going to affect discussion of this
topic (summary: with a "small amount" of work, reliable allocation of
1GB folios is possible):

https://lore.kernel.org/linux-mm/20260430202233.111010-1-riel@surriel.com/

but another aspect to it is the recent performance problem reported by
Amazon (summary: compaction takes too long):

https://lore.kernel.org/linux-mm/20260428150240.3009-1-dipiets@amazon.it/

Anyway, I'm putting you on notice that I may hijack this session to talk
about how GFP flags suck.  I may even have a proposal for a replacement,
depending how inspired I am over the next few days.

I still think this discussion is useful because we wouldn't want an
attacker to be able to make Linux unreliable.  So it's useful to think
about how userspace can make memory unreclaimable and if large folios
make the problem worse in any meaningful way.

