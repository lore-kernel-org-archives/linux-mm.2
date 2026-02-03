Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2440DE87842
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890D16B00A6; Tue,  3 Feb 2026 11:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F066B00A7; Tue,  3 Feb 2026 11:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767A06B00A8; Tue,  3 Feb 2026 11:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61AB46B00A6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:18:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1692E14053B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:18:29 +0000 (UTC)
X-FDA: 84403653138.08.BC2859A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id CE31140016
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:18:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mVXjWgV2;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770135507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOULf69lSyry0MtqmDXMyWLgxB+TMslYOqfx1vfaXxU=;
	b=iLDhaTCFp9TTsb0SZwIc/ClNhOnWgKAACzTFWB68liza4HpJgHDxtR4b+q4yhV9uY9n8Gb
	1nSz+xLEwuqNey7OkHPOObb1ShixlVYsAJALITbWGhPwNRk9D87To5x7Mzybfr/oyYxU4O
	/vODsNIRMAcqFiIRSdqF2snr3qBrhjU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mVXjWgV2;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770135507; a=rsa-sha256;
	cv=none;
	b=B+h50K1jnCYqLs4+CCMDyfrbmVWX80Xw15j9xe/n+PqqmS4fCFpK5AnNsmdM8XaKNF+AF5
	EwN4quYH+3OG9q1M5I4DBryjX34cTexh0Mm9ExrOiC1MvNqUWkHbMgmc8QkPsWMre0Ek5z
	xnXuCw7rf9lCPOvSvRPg7Sp+6Z1z4yk=
Date: Tue, 3 Feb 2026 08:18:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770135504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOULf69lSyry0MtqmDXMyWLgxB+TMslYOqfx1vfaXxU=;
	b=mVXjWgV2fJRyHlIQbCbnB9hY/cOkoDdnn9pdQyzU0bDHlv39586bsZjVzA8v978iB+TP/7
	x2wKjuwEEVAexvqtDVc0XqUAnthoSTvuSDnBTRdhrT//jUefz4c83iVZe412GEsenrLiaR
	+TFP0r2fBdC5TS/Jg1yCuzmI1eRQ4co=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Subject: Re: mm.git review status (mm-stable)
Message-ID: <aYIdEKHZ9mss9ZJb@linux.dev>
References: <20260202184552.23fee27882d83b753aaf0e40@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202184552.23fee27882d83b753aaf0e40@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: CE31140016
X-Rspamd-Server: rspam07
X-Stat-Signature: pppxsfysg5z9gfubhuzrntxean6bj36a
X-HE-Tag: 1770135506-965562
X-HE-Meta: U2FsdGVkX1/4JcDksGyD0iztHb4ih6r8ZWKXaajszkaoSzaeCX76rC4onQ7gr++P2o8qWju4sYWnN5v74Ecjx6qI2CeVpWgQAKN/HhtBYsNHf63eSoKJmx9i4J5YMAf4P6satadCGsbvBpeUrI25POyklCRqClutjHOFw4LIcTVPXS6Fu5YgvMssAdXeJsFY30Wv4ciiU+N53OET7S/VrFJy73Vmb2rqIiDeTL0eWSfl6cj4SDGaZDPPTHfPKvUhjGUMv8LoRa/2Bg9m2w4rWtw1bBMv916EJJXzy24c8mC5BhEBL8II7A009wpwhUlPMl5XF2dAXrCHU+Xa6VZ+YkoivFVmlY0uh2kMuRyd7Lc8whr7aEW+cVrKdzH/+kwCFMVIXu7nywBtjEwpaaKcxNxQ0/u9q5NSUpSGjTiIh7JlCpWwxGcaVqf/AQj/9QMMLSSv3POgSdaXx0PePHrZcaKJlvguLjwIw9g8WkipWrWh7puRrlUjnjEndiIF38d1sGBo+J7uv5Ikd+I449MCGaUWYS+jWVhxKnQ6gIooGwQzKTUgTkzX2h+EbRY3tDcGDv9ZeMxCLhyBROd1Fzw1qVQnbhg5uOnavW1fCJAucGFRwzLBByXjzwAxm+K7ipmdN7e8S8EdiLZfddvi+33hjKN0J6GKpLRIAKUqkZLP0ngVRGYKic9tit99g3Ukv0OFMY7EHSQafey9HidzsLUSWLntpusaI+QjWYnN8kh1xmyqI3TuDepqJw0lHQUxLdGqoqBAAg0InOuzuVVQtXxCRMbtGtkpmMy5L9caB51D2aeGmKt0sBeOLURU6W+I+74Cx42kyZykTSqd/sq7RKFBa9nSQZ301gInfCCQBt530wQ/LUcGbzRP1tj6XWAJ1d0MvQKwAsgF1UUs0FCFscYOe9yre9mDELfe6NvHVk8Hvgji6w9U6NrBoEgpu7WSadtBfI48UOSN8KGkbICx9nt
 87HuflMS
 4b/hl/Y68mIWc7lfn+t4rb6AwrQCkw0rJjAROZcAZegKrxxGJJCq2uSzV/mfXz4as2/XJIJzQYzSK3kYKLH7ZYcg/PStduQOoySRsVk9a/peVaPpKtp8Mc1j8HLIE69a5HTU+wDPBMtj7b/Mi3aq5nDO1LP4YWW1ENoZS+7Ikp9/mkwrPJyZ/zx672HJxNLtqw3WzI4cimohwZhDr/2/kIgg0F7x7NfoC9mbDQ+rmDF8Bufc+SRAFuHttOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001386, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 06:45:52PM -0800, Andrew Morton wrote:
> 
> I wrote a thing, thought it might be of some interest.
> 
> 
> mm.git review status for linus..mm-stable
> 
> Everything:
> 
> Total patches:       320
> Reviews/patch:       1.40
> Reviewed rate:       74%
> 
> Excluding DAMON:
> 
> Total patches:       259
> Reviews/patch:       1.65
> Reviewed rate:       84%
> 
> Excluding DAMON and zram:
> 
> Total patches:       245
> Reviews/patch:       1.74
> Reviewed rate:       88%
> 

Thanks Andrew for sharing this. It seems like DAMON and zram maintainers
need to convince more folks to be reviewers for their sub-system :P

I think overall we need to incentivize reviewing for MM subsytem. The
netdev and bpf folks publish development stats [1, 2] for each kernel
release. Maybe we can borrow their script [3] to do something similar
for MM as well.


[1] https://lore.kernel.org/all/20251202175548.6b5eb80e@kernel.org/
[2] https://lore.kernel.org/all/aTBxuQSvtATrr3mu@mini-arch/
[3] https://github.com/linux-netdev/ml-stat

