Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622B6CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 10:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990E66B008A; Fri,  1 May 2026 06:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967FE6B008C; Fri,  1 May 2026 06:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E336B0092; Fri,  1 May 2026 06:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7616F6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:12:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25B5616027C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:12:01 +0000 (UTC)
X-FDA: 84718435242.23.CC4CC4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60DD280003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:11:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=npK9hDSH;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777630319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LsYmmPW4HC1jOtOwpgcXJSncU6zAKjTVlj4fTdxM7g=;
	b=0gaAVKCAhzMzPPr7yIwDrhX6tqG9cuZtNeypemQmfZk1m3WAsBwrlLtyVC053f37vdPtjF
	15YLDlbRdc4XV084MpW1MOmCxQ2S4zgvXLf3G8smslVxgPv88xoKiIsGEH/Gg0og1DG5C4
	jQ/xeMNZ4aHpygafGHwnd6PLGaI7CFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777630319; a=rsa-sha256;
	cv=none;
	b=e3lu8yelnL/+1NpmXRm21iSHQ6b0etEpvs8lE1DJl5GnGVTtTROOgnfQnvhKikCkt10GwQ
	q8qolrOCeF0FvOLR59QfCzMVNJFmnfwzii2m+qUt5TLTssBwqT1u6GiHOj7+Yc8CYBWnJD
	3/LQKi7V2A61isB5fFcNSg6bF5XWPgs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=npK9hDSH;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25D92439FF;
	Fri,  1 May 2026 10:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86218C2BCB4;
	Fri,  1 May 2026 10:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777630318;
	bh=8LsYmmPW4HC1jOtOwpgcXJSncU6zAKjTVlj4fTdxM7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=npK9hDSH5xIFQtWSlLX113XQF534nSdD1bHdAFCX9kwpST3gzRHXAS64ciFIcoTxs
	 TZLLyFxMnsNwoQH6B9SuS+7rhRxp3w7Jfr+FZIcXIfw+yWPMhyN1cP4gY4QfSPvXTe
	 d61UjMXhMCTuia0poMZsUsGi5q2Gv6UKp1C4cOUg=
Date: Fri, 1 May 2026 12:11:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/5] kexec: handover: add helper to check preserved
 page ranges
Message-ID: <2026050114-glazing-bankbook-28bc@gregkh>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501094637.38650-2-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501094637.38650-2-crisjacobmaamor@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 60DD280003
X-Stat-Signature: ak77pr6tp3xoyjjzeu7op7s889ndb7k1
X-Rspam-User: 
X-HE-Tag: 1777630319-236442
X-HE-Meta: U2FsdGVkX18pGzHugvyKvh+1EdnfwyJ7NndI9dJ66Ymrs8jjCqX8JQbpdsMyYUOORd8HGAquXPzIqT94bsIvAFDVp8o52kB6PzzcrDYX39zWB5jzZiqXIiyL5IuoY0+g65pgmY8z75NI9WvDyUX8xAYOyKRPDXLZIyTfWBmy5UVBtht6KmIVLlJ3t0D7rF6gQ0xD/NEojcsLqi8yzjN37ca+/CSjXf69Qf82R/spJvUmc6Dii0MDf9cL69nB1FBmRXmz67GKo5GsVKjxUOQCSmlPB61boq+8tdVy2SqoCXFR080mMt6ZaCKD4cV3Deyq6BzI6uK/rJMVzlWed8dhiVeHn9eBxBgGDHHJeB6EixxkBtX+/z/A5St5H0kAyQafXTGTU0ruf93XRYU3rUzbt1mEN7F3PlDS4LkfTfcy49n4Mbbn1JOY9LqRY4JjaWeBW8x8eaFtV7eucFXzNpEdiBV727mKJgvlg6VdjWEmvHIebFGJ22CJ0ymwE5d/0WqC02UAY8EedAdDh//22uARLX6ZdAHxnAo32FlM6NCkvYRnrlcWmYld9q06pritRpV6Pr+29Uh+IHKmYCX92RF/ftwd67v7EH8QGG6nHYhJJeONSUZCgiqwX0KiC2atgF4Jd3UbIfZFEN7T1le95fgj7+MEiybkU2vLiuzgPxXDXwHFJzBGhtn8RH/xOcEjHHZBBlPDPyRQQjRNDgizKKUdQ4CrNoMnc6wPoV8VzR9khIaNeJlS30nXc3rfunliolTaxFBHgHkh1bS+te1mJbEriIPEe6n3FQtTqYD44OdcsW8aTsbttRmyPITGAgCQBENkN2qFhM0TcrTR0lTpVIKKEkdqnGvHQVENzY40OF91tKuxcua9k8po2PQksgBSOOCZ7oR8KxMaqY3xvQ/HFoAuBVkHFvVWKdVPJGkn0nZ3XuHOXOFSQMYcxQ5W0QqaiQ/qSvMz2tEPBLybZZOQdZR
 pazIclTE
 aVClUUGzKE/Zs06E0VBr4x6Gtuyw2VIQBRqz3tegdu/k5cIjBe9tbSUbBnvSKyaCzx1rLLYy0POhWqdKuWirUhulEGiBuST+8HoL5GtksQ+mp7GjPWyZFu9uBfmKThmH5dOjLWDCN3vigfsg2SA8gRAKx+LjDjK97jqW6BEgS1gfubpPdkg6TX09R/dJE7DU1NZeDLrcPye5PU5G4W569TEj2vqPLuzUI4qAqlsdZLYgGRu4EILcckh1O6VAB6IOV7CArbVxKayq8NL9rsyVY7BBJHc9yYYkMQQFliye5/fcEO/MJP3Zc4T0gyiG9O/Ln0NLeag6uTJxNJdl8Pclq+/88ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 05:46:33PM +0800, Cris Jacob Maamor wrote:
> Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>

For obvious reasons, we can't take patches without any changelog text
(nor do you want us to.)

And when a pathc is "RFC", what specific comments are you asking for?
Why don't you feel this is good enough to take now?

thanks,

greg k-h

