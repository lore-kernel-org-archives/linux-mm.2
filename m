Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A5ACCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C08A8E0010; Fri,  7 Nov 2025 07:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570CE8E0002; Fri,  7 Nov 2025 07:11:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486848E0010; Fri,  7 Nov 2025 07:11:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 333C08E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:11:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F36C4140455
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:11:01 +0000 (UTC)
X-FDA: 84083695122.18.8A80D7D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5566A10000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:11:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHMcTbA2Qmp+ikXo6uXrRBMFP0WlUljXRCgUWUmqtJU=;
	b=QTVhVzy6/jTYw5kQNqGV2tEyk0AomjoEdT004MZgmpXbVUSYdWb0VjQfccEBa6tnuBpzL3
	dKGt8a+xv96JaAldXqv+SXkoR3/KO0ymlEtfDBXBv3/27pevgYyKe9BebrzwTVp+ZGBB2d
	wFC4+UyW+jHSc74+dmDprm3SjxVJUHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517460; a=rsa-sha256;
	cv=none;
	b=OSP0H1pfa8/MltUc6YHbbkrclQkHnrDZMdmVqArHe8D37W9VcqllhOdAzNbuwJzTtZv07H
	trA5kLFHoXL7iexEgA+1pik8K2/daWG+SPsi4YDmVl2GAWY3vT9JzwA6GfEEBAKt9K36ev
	8RzT9nLdYl65oMphaIgzdKa+4Y54fKs=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 678C4227AAE; Fri,  7 Nov 2025 13:10:56 +0100 (CET)
Date: Fri, 7 Nov 2025 13:10:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/9] blk-crypto: use on-stack skciphers for fallback
 en/decryption
Message-ID: <20251107121056.GF30551@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-9-hch@lst.de> <20251107041859.GD47797@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107041859.GD47797@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5566A10000A
X-Stat-Signature: sni1b8mni1x53fazgz6y78czk3co74zo
X-Rspam-User: 
X-HE-Tag: 1762517460-876105
X-HE-Meta: U2FsdGVkX19B05c5ASGooW4arK3kz9zKuLxnjJv+LR4DjIGbCzckyWL5Ptv54BUBct3RDmOu7ygB8U0QfIyUdA6CqrlwkL3H82GNlsmC1qr5IMrioThDfT5CF3Z0jYKBM/Nk4Uf5dTXOc+vW7msWtfPZ6Z2FA2v7ikxHuCzJT/Et6ha1t1mtY/byPoUucjIAjoG39NqZ3nK6B69+agpQQxkxdqKIlpFdLXJuZUba+GTqhyfXPT39XNXFC1qDCxw5daawKoFzWenPKCaqDWhD3FmYZ05Yv0iJ/PPFVXDcM6dgkNtj/toDIbDuwxDBGkWWg8RGv1UgTT9QdiLph5MDWRm0f5kRb4xNdmGLU6Wsi197hYZkskyFrMm0HPOea2WpZ3/w6DyatUm6fKr9RkxK4JQRq9fzBEhiLO08d2ONJh+y2DZ3ZEOtnkT7PXIRgNWL1kkOoZ92/vlZ8KMBoxsqTDGdZDpMd3oZn9RskuzX50WwRpUdUaikL9Wao/ytJROen0hKzEdz9VtWyi+G/Vzc0XEp50oCkGnNzjvrPp/mT21anLkP9RIE/atRhYDG10AClCntjes5gPPuLSPPf8pdNf18LldFgHtymIrW7Tu5QtIDTN/eJ74uHnW9MRw7/YuJWwWcp5wVgvQb/lkM1pUPeYEHkmVliYIP17ZIMh6fF8EilvVFtKgVwAy0eay8A0TQaXX4nKQYrReaMrxrjD63xxiPw2TCM7bEyfklnlptvel+mnmHxX5A8uZIMik/6nMfG6JoBJXd00PKPAVoQkhkyRtlGPx2Qva+lcdrQqD2xt7Oy9kfNBgA4oe6BZwMKGksg257Fmd9WxPvBbiYslfMha8vGuJPz4BfksdSou+oOxItxXy5fEH/As0kVqTHEExkZVkYHYe/WpAR1pmAbTZ0SBm3ozDviuZVlCceXYvZO/coua3JEpJfB7cONenDIAqUt+1gZ5d88v6lpQEoHWs
 CO01IQW+
 soLYyzWTCLfLtIuRL6jsc9h3JtPk9Ku730BCIhtCOpZq01vw0Bl4d6Lh0fJ4V/78zu9dKB5bsuvkDilQb9YUUvwzlPLvR5Zf+gc7m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 08:18:59PM -0800, Eric Biggers wrote:
> On Fri, Oct 31, 2025 at 10:34:38AM +0100, Christoph Hellwig wrote:
> > Allocating a skcipher dynamically can deadlock or cause unexpected
> > I/O failures when called from writeback context.  Sidestep the
> > allocation by using on-stack skciphers, similar to what the non
> > blk-crypto fscrypt already does.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> It might be worth leaving a note in the commit message that this also
> drops the incomplete support for asynchronous algorithms.  ("Incomplete"
> in the sense that they could be used, but only synchronously.)

sure.

> Also note that with asynchronous algorithms no being longer supported,
> the code can actually be simplified further because the
> DECLARE_CRYPTO_WAIT(wait) objects are no longer necessary.  The sequence
> of crypto_sync_skcipher calls that is used should be similar to what
> fscrypt_crypt_data_unit() does.

Ok.


