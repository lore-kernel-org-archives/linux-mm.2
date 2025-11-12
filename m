Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 320FACD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BC58E001E; Wed, 12 Nov 2025 10:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933868E0002; Wed, 12 Nov 2025 10:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8722E8E001E; Wed, 12 Nov 2025 10:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6678E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:56:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FC0E13B470
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:56:33 +0000 (UTC)
X-FDA: 84102407466.02.D4591DB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8D27B40005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:56:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MI7on72x;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unTZnhIKbo/kPjktubhrqmYbcE5u2DsI4RiHT1r059I=;
	b=XS9DfYgT8bmi5U1vqBiZmFyFKW8f6W4j2XnJAxz0Aqvb+LfBUemxz0nSznvMCW/tOKmgc9
	o28YY8nQxnf2WNAOa6L47jgz6bOOHrD6890ICU5zkpqdILg2GxcsC5T/oBxzVgUvQSnd1T
	yp/Et+ef4ABdPNsc1aAabT1VHTsP92s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962991; a=rsa-sha256;
	cv=none;
	b=Xr3qwlbadZdxIbIkPbcfUQ6RZ9HbuTmdnj9ebrmFkSRXOJR+b9xPtVe7iR6s4G/FTkmE+E
	uS+AY3RCTvlPDSZ1nm/dGyi4twgsEJ5BYnrzodjLEULYkOgRfHbJSqrEWADwDWofLBwrAO
	vngHA1zkADPxCxyWNi+F1TTc0cYMQGo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MI7on72x;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=unTZnhIKbo/kPjktubhrqmYbcE5u2DsI4RiHT1r059I=; b=MI7on72xw2kf/B0fnp/Td1CmSV
	cU9dbT/g+mZGa1UNpCIHupjk46WxBL+uRHMUEeWxwLRSkXz17Be9Hne9VcX6KQdww6djkwn9ioHUy
	aH17QCGTqVUWDLtpdaZdhL2ibY70RahsDhZ47uDJKzVCKDXDHtAIkciT+X+oZPq2xGTQKnUjSXAt9
	XcJ5YUbQ5SdLn0wYzI1hCu+1eqmst/T2SVkPRcnqOc56dc7Cpc1aK9cytD0hdTWtwVmewWHNt5GAY
	CqXjbe2HM5IMYV/N8UWZhtq+Jn4qR3w4265TBNhvAI2OMRzWsEptBnvVN11hXrCNrX7VeS64P/vMI
	ednyePxw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJDCh-000000068nw-2KVV;
	Wed, 12 Nov 2025 15:56:15 +0000
Date: Wed, 12 Nov 2025 15:56:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
	dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	nilay@linux.ibm.com, martin.petersen@oracle.com,
	rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
Message-ID: <aRSuH82gM-8BzPCU@casper.infradead.org>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
X-Stat-Signature: ahsj1mnx46k43y5s413uf3roawoyczim
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D27B40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762962990-811539
X-HE-Meta: U2FsdGVkX1/fQWF4u9Krz04tW0LLb1b5P95jV+AWnHdBv/svZhkub8U2cO5kI2ylx48MFwbYjTKYd69y3IGvsniliZ5MayV16x7W1MgmTAzK61XKb2x1HLScXSv/i4HYEsnwBWdeETnf/H/8DUr9DA/xiZqZR2qviShHo74sqfCBtY2QoF7+GWwc0dCLqdYXuAd65rerWZfGzUGS4E2hL67VvKmd8kXrMFNZO+/cT1Es/RgNiFs7bfEeWf7G1grkB1ZyzZdGm5gW6qPMphxV3TMfdZLbXupJ0sFYiFavXg5dSL7jwEylFSm+vzrGSFTgwHfr2aWaHqw4BAdJsa53otHq50XjUtsuHvZZ8PU1wwGGUCkiwwAIzuP+fnfkdniKdVBUYrnBezzOyfTKf9gutyQuFjT6zMWfsGUnCTZlq2EHoSehFm6Ub36LPccwLivsYXTjfNCd2ntuTq9uJxdXTScZYcqLeG/pKJXvxyFCBwMNJtM4XwRv8H7TqCOinyAPDwwUR6SCx9B1w0ER5Lab/gy1elDHaSRUSJvj0vbJfTcH2lmaO6jnEiXu48Xd+uEAibjLtTLyrqeMfDdAy/DjGmegMJEUNGAGtLUgdTwyslKcc0QLa2XoXN4DPJqwkufgtpFko30cgFh1K7FbIibjWISUT+n+d2tcQ3nh4gCowrFLKuWA3RLshMccL1p1iVNljFPGzQuA6Nfvqrn4WKkY7kMA9+Wo3Xc6LTiJyHeFZU57hKB2x2+xIGQCc7tAJHtiGSebMoxSKAvOiY2+xSHDw5hB76XlN1zYQQl8kUUiAM+PzBABoo8UMysDkZ2l3qh60L1yjnq0LDcNADeGsQj0YZZRgq/y67hQluWhuzt7gOcGzn59IqCgNI0VgDbFb5RnFBNeUNERkkNqgaYGopk/Oq67tcFwymM9N3ZjugTXKeFe0MDxqCWmB+nQ7PkQY+OwlqEQz5pxCvA1MeratNb
 nF7j4wuT
 IGFbS4RFFBNGy8YXDZFfX20Hi1AT8oG5baof0t4iK+RQFU1EM9MTRtScb1aqccQKzFKRsQsDKTn9dbXAIjcknMb0p6kxklAgprylhV6BEyvrIl7Tn4kS2U/xZ2OQ7xBOqm+AJF8fqB1YElsIfH2TvIGvh2yCH0n3Z0ojOFP3ZXlBabyZITvMWAsZ7ZAkjZ6gtmP/Vn3usA+NhS9FaH1D8bZDs/ZUdn9TXf15taZ4kV3Cy8yw8Ez8ErhFgy/wC5f6/h9v4ksh6jge2z/VW9RAYXlQNWuhN+C6K7LGGgXPs5om0gcfK+KRr5GYhEb0HxRiVFRS9i79OFnfJA/Y4w5oy4B6H8DghtJ9TwObGwIeE1niic3Ljw3xOafCBkH6D6o7U74q3MGzTMLqMMhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
> From: John Garry <john.g.garry@oracle.com>
> 
> Add page flag PG_atomic, meaning that a folio needs to be written back
> atomically. This will be used by for handling RWF_ATOMIC buffered IO
> in upcoming patches.

Page flags are a precious resource.  I'm not thrilled about allocating one
to this rather niche usecase.  Wouldn't this be more aptly a flag on the
address_space rather than the folio?  ie if we're doing this kind of write
to a file, aren't most/all of the writes to the file going to be atomic?

