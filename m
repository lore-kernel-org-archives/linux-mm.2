Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5902CFD353
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5411A6B00B2; Mon, 24 Nov 2025 14:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5192D6B00B3; Mon, 24 Nov 2025 14:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456D76B00B4; Mon, 24 Nov 2025 14:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33B276B00B2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:19:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0127D4F42A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:19:05 +0000 (UTC)
X-FDA: 84146463492.09.4CD37EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6C86A1A0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:19:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LDbj0ZQG;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHZQrxncwBTWCzeqGPkR8xDH+h7aQjoOcp2UJdYjxiY=;
	b=iU2t+yOktZijSpQY4vDFQ4ofSRNBai9B4iOlWDUUVb9ZTp9SsGPegT845CFTrHGC90Pr6v
	AUky6IvDn+TnqDZke551JovrMtHimEYY9Z49xXTggT7Mz2cRnUEORql53AeQhJN7QS8SdM
	9PwCazBBtBhwU12f/6ZWV35uDGhf9q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011944; a=rsa-sha256;
	cv=none;
	b=xCg8wXmxuBS4f3SJuiH9LuIiXxtUE4zafvAYci25xVCssz0KS+lr6dOi+nAD8VWsnKgBjH
	E6Dkm+fGvVBP8ad4nCYbhzl06yXwNy+g7Ytct+Q1OLYX5JjyFC+7WVSvCJqUdyl7XM3pvH
	R4GvxwmE6uDq9/koHzG0CuwFIQVuA9g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LDbj0ZQG;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5F4F60176;
	Mon, 24 Nov 2025 19:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A0EC4CEF1;
	Mon, 24 Nov 2025 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764011943;
	bh=t+5nJNWM+Y9E1sZZFzFFdEKO5nYArGysP+lyxJ+WiWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LDbj0ZQGFEs1XljlcIAl5AguNWlJ2sdwfP5PuvL1kBcnHlpVMc0xttNSffAMR1DfK
	 JTJXG3YjCb9GKC6nsQRhf/Uka9XG0q8hHih9tvEWurJ+QxeYXGj19IKUU0GS1CvSht
	 DaHyXRnSe/Aqf21+xtYu4zGuaJXEuRhh3jqcGCfB/IpDBYFDgotbgGttBLck1n7p3u
	 t9xcPkZJxd30PJOz4thDrZvu2CR7bQK2zA4bMLE7OXXN6jk0LNLrCPzZsqkc8A49NX
	 SStDT2QQmUxLLLF1hsbLkW8LQWAnTDtD14xB9qDvVZ2FeHtGoxLWUmI4DLzcHMBqBI
	 TJOD2z3d6twYQ==
Date: Mon, 24 Nov 2025 11:19:02 -0800
From: Kees Cook <kees@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bill Wendling <morbo@google.com>, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Uros Bizjak <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with
 __counted_by_ptr
Message-ID: <202511241117.CBE8ADC2@keescook>
References: <20251121193957.1655580-1-morbo@google.com>
 <20251121193957.1655580-3-morbo@google.com>
 <202511211525.05CB7E1AEC@keescook>
 <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C86A1A0008
X-Stat-Signature: ue6tnit4jq39yy3rxon7rkt9wgftb78i
X-Rspam-User: 
X-HE-Tag: 1764011944-550845
X-HE-Meta: U2FsdGVkX19WMm6nUWYp8g8N+uHwbbc/nro3N3gmGn+4ZxQlBXWCj8ooi/V2ArptYx9FZB2FVqrrDeuKAg5qP1jTj9ZzUldPu0a2UrkzLGnjSebbkspWWAGDDvcSc/hj4aw4SvZHYJNQzNt2DKngS4rUhxF4HPsFlX8j8ncqCQnj6nAPOnmTJchiG6KPaKurz/MSIt2HZrKkMjzPMnQYbpbwNLa9giZU/3pk0MRJX5GPWk+BwiUXv0UXkOtN+ubgm/gILiAsyXNxSohOtQxnnqae4s6DtOyeDGddsdtRuCHd5KsojUqKOdaIbDrpsxJLTJpPipetoO284P54Ospl6cz3POhDocUSb+8IHVsq4qDAXRoQ0ACBn6VTp5yalnRNEYlL9YuEB1q3LdIduELh6UD/6/8XBPATOI8NqfdqBiHq5YF3Qc35vFk6l57OmJmSGkuKOFQypYii8HULePvA5ZXlYHZnH3fLnsc/M/HTKWuvQLWekbC7ZvAwyjJOV9H2BIhAh3gzqQsK/fkANLmHHpKyrd2/YUh5Lb9Jx3tMKylrtOQZSSxRKjtqhg2qVVWUAKK4hmt7J8SeHxxy15HWDent9FmUq3S41Gs3socy+Gber8Oqes/+Tuvk9hS13gfbP7upFH1AFgrDtFWvsDFdmfpH11hA3aZPqZzjqg9pHrQL/E4ClugB67F8yNd9ZPvucQgt8n7qb4F1XvoW4m7unUnN4HL+dM0hS3mePShy/VMihY4qFRq5zXyG3uAt7r5xS+9t0dNshKQV9n/TMWN4wMTbG2+apmsJtaIFZpd/Wh2mfI+oTJvOD7gKwBTKjQ1YR/NI78vRCiG0voTVrFfg0U+I4KWjpRLfVI3WOPB1ykOX/AZ7RQUeC+P4WDZ1kYwrhudpuq+TivVO5+tGiFaRGbxQy4psXErB6J+JkTMrxlLs4juiKM/ZYWL4CcTam3AwlubQaGtV5lL6rpoZki/
 7n5y5TM4
 mB+zvPXITctZOctjMaVZ9WNSQmz6D4PVEEq7F9RtKpyEjyRdfLcdXmiculxP3KDgS3frMefITUZCgjwWBBfL23nRamGkJnAPwB2XMpuckI9AeeUOYLYqtxFa+OwCKOCXCmh+CW06VISkzB1FcaVXPQZjCd7AT0XLs0tpteBaMn5+ytVCgofK0H1YJKl+vkg8/Ba4oe9ov25BBJ4sGHrCNFtYw+u1Ys8klaUvOt4u0Cmlqn8km2zRxa2yosLiFMEiOy1nfUgV0C+y05JHKTIXpC0Pr+c/x5IIlnRTWVfN38MFBL58NK72N42A5a0OaYFcemzHERsZuX4PmyHrMx+/8E48hWh/VXONvGmgPYpza4JEkUI2bm5wCuYqyNnbRdpDQRoFL/drGGkJe/+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 02:16:14PM -0800, Andrew Morton wrote:
> On Fri, 21 Nov 2025 16:30:43 -0800 Kees Cook <kees@kernel.org> wrote:
> 
> > On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> > > Add the '__counted_by_ptr' attribute to the 'regions' field of 'struct
> > > memblock_type'. The 'regions' field is an array of 'struct
> > > memblock_region' and its size is tracked by the 'max' field, which
> > > represents the total number of allocated regions.
> > 
> > As part of any counted_by annotation patch, there needs to be discussion
> > in the commit log about how it's been shown to be a safe annotation
> > to make. e.g. in this case, if all allocations of "regions" have a
> > corresponding "max" assignment, etc. If just "git grep" can't find them
> > all, using something like Coccinelle or CodeQL to search for struct
> > memblock_type::regions assignments can work.
> 
> How is anyone to know these things?  I can't find anything about this
> in include/ or Documentation/ or in the relevant commits.
> 
> There should be a comment at the __counted_by() definition site, please.
> 
> And possibly write a Documentation/ file then change checkpatch to
> direct people to that file if they add a counted_by?

This is a fair point, yes. The documentation and discussions around
counted_by are very big in my mind (and for Bill), so it was mostly a
consolidation/reminder and some extra detail on prior solutions, but
for anyone new to that annotation, we should have collected common
guidance. I will write something up.

-- 
Kees Cook

