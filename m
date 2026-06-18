Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB06FCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80F06B0088; Thu, 18 Jun 2026 10:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A320F6B008A; Thu, 18 Jun 2026 10:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920D46B0092; Thu, 18 Jun 2026 10:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 660146B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:30:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D664B1C30F3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:30:31 +0000 (UTC)
X-FDA: 84893269062.06.8ABFEF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DF144001C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:30:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmvOiCQm;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781793030;
	b=jVZ2P+fX4Z8RzqoBhKLf+QNAb2NE++Vr8g0kKElxFeWJrdj9r7XUu2WGCe9MzRAv74hKlc
	oBSZtvM4iUlA3zNz1bJrlniTNsiml0gtYmhb1HQrAAB7Zmx2oHLJHGAAnGUXNqYh+lJV9n
	XSi1NQlHysj7IHqSjCEGO8/UY1bByGk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmvOiCQm;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781793030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vtR+TjrpHHmFHags4WZ6+/5p5KaBqxoHk0CbYvy0rs=;
	b=dGPPAoyl/AQvKHA4uFwSLtcOmd4k+7BGb9O+n4x1dsiezoIEXF0595m1TgwljUPsnWIbGT
	vD7fvQeAlf9jWD+laxjqgxMeA3xI2PvEWnn2/Dy5wLKMi57nU0O51UO4A2yIMjzELBU89+
	N6X5SYqucp9KdkeTZbArLo8A2YTX588=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0FE960098;
	Thu, 18 Jun 2026 14:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB111F000E9;
	Thu, 18 Jun 2026 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781793029;
	bh=7vtR+TjrpHHmFHags4WZ6+/5p5KaBqxoHk0CbYvy0rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YmvOiCQmVodx2octUGvCQzdDxtNKbcJlmIqTU4tmDqF0lCZuux41OQnmCaMdopaax
	 w3IWmQ+RS2UlAZ8d1rT5f5EG4J+UhpKlNTDxSjIfmQEpl9yQIiJojIhFrnzsQuutWa
	 vkIz0VwtfcUx+OTEwIW0PYUS/iLM1Rwrz/oOthBVg/BwV8zubvXY3+WyBtOnHWZjA9
	 I2rZUYCXlCMhDxirUaziR5SJVUn8H4W+ilrHJ3/L85Q+h/2LCW4csITCJHi3h5SEps
	 f0F4DZyNHwhfvcKgc56CSWIyioxXDBsUvwxRUsCNAHedjurK91mKzuhq5i7bYn3Srz
	 YJAAOfMTFS3yA==
Date: Thu, 18 Jun 2026 15:30:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, 
	Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh <kaleshsingh@google.com>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm]  7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <ajP_-zqVPtbzvc9j@lucifer>
References: <202606181547.617a6967-lkp@intel.com>
 <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DF144001C
X-Stat-Signature: iwqwhxcw6oawsytbri1g84psnjj4kn73
X-HE-Tag: 1781793030-621822
X-HE-Meta: U2FsdGVkX1+yTNWLvcOEzVCvuWIi7E+EsQAz+BEiS0aY3Y57dlwdyz9aNXWIBqNQLvzhfXcRuM4SYWLLWnjYCVMWWzGGxa18pkg29omp/9ccwTDGuvpdB5x/DLo/YoZVSdfe9+4DEVxNGcA/sY9K0YNu00PhDB+AJ6Q9/SFR759ojmnba2R743+ECE30T8p2CbPWpcxbHBRkIHS1h0hdWZYD2cuLW+wgzMFaW785bOxVejl4dMScNw76Owh5+QmdeEFzURvDVlNw5IOugbSjhr2lHM74/AWyGl/TVRjzlsR0HXDnkLq/gX63lQuOMkZwYUQ03zm2zQeD17SQsv6ldDKdiaHdg3wYS5ORJXv1JSNQJ79n468h4tl2xdp8Z8qF/ZebgfWt6t6MSXykFOGqVzqHo41CFnx6e0fQXGpXqz+Ln9KH5267Sm1R2TNW4ZlCo8cLkuwEZH+3bodUHJYVAwukwt6YDG5hl5tj3CKjv+1731/6Jw8InvkzAExFWnI3vLbdfu1RCruYar9pddukpp/NZSE6AOF0ixFjXPy0fNo2a61DjXVUn2dmwfOt873J6wSbAwUDluwx44yOgTG3amf6sBbF84GaUVB+JEonxupTypfKZZjgsHZwE0jXmjF1GEZ9gbAUODUbGwJ5t9dDJ+ujRwx1U09Yc0uiKnn1QHp3+iTI9y0cYZ/6YVYce98DIKoSUo1wQiLx06+Mqg8HH4x8TFsSWpK8xHAk+15sb5XvZDBwH9PLSQjt4zFyCkS3Y+XyXs4b5tZRW7z5AP2CTygtfFclksKv4lkgCh0TZHilQvEZS3wAyMdpKM2/dFtr5MDhQt9tn1TF5cb5D+jvchoCE6gs0TYjb6agIgWE4JMiB3Gjk7NUsCov6+LnsgFwsnzCJy8fvvMO1T8zCskuLP0MzwNzxjQ04/mJmAlspqaJawU+GXX06rK14MNT9FrkQ7nKVHBGPcErN/aqkhC
 5ohhTfig
 laMjh/huVsATk/dJErhLXeT50ptYXb7qYFiReHP2J4H02mj/8Wz43XNoY4GuJVGAdavA5KliXildtjRvVhSHQHUikA0XGdnzd7Ir7C1labqOiNDfy57f8UodnOf+EHs6b7MrVITSL2EYjuQmVGeJxyZ4qf5Kp5BeEwtKB0fOVWKkp1jbCwr7CmFwCO1KJmlytQj4t7ZTs5rHcFxMOrWrJoJRFX8VNFKwTZKZO3rNI8IrnyNBf6qN1FQ+MQe1WgsxQapFpfQryqUM/4hWTGEuxOw4I0RJn8f58NkJmkrjWdogpKhPegLFI6Kb/Pw/doZ+XoLVN9xHkKqDty43GAkZ/BVQSqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:30:47AM +0200, Jan Kara wrote:
> On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > Hello,
> >
> > kernel test robot noticed a 45.8% regression of pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:
>
> This one looks serious enough and real. It would be good to figure out what
> happens in this benchmark that it benefits from the readahead across VMA
> boundaries so much...

I think a revert first no? This seems pretty huge for something that isn't key
to the kernel, then a new attempt can be tried with this issue addressed
perhaps?

I seem to recall objecting to this in the past, had a look around and saw [0]
which has some discussion I think specifically on the VMA boundaries thing.

[0]:https://lore.kernel.org/linux-mm/CAC_TJvfG8GcwG_2w1o6GOTZS8tfEx2h9A91qsenYfYsX8Te=Bg@mail.gmail.com/

(Sorry to be naggy buuut :) - I see there wasn't maintainer [Matthew] signoff on
this, we should really be in the habit of _requiring_ that for merge).

Thanks, Lorenzo

