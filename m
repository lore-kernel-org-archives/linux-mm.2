Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30263CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8218E000B; Tue,  9 Sep 2025 16:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F7E8E0001; Tue,  9 Sep 2025 16:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78EC88E000B; Tue,  9 Sep 2025 16:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66C438E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:09:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E9BB16059D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:09:30 +0000 (UTC)
X-FDA: 83870801700.02.06A008D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B03A140002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:09:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gioA9rPF;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIavL6Q3Ip2q2nE3QhJWaekN9zisbFp9u0xqsk2O2kg=;
	b=u0OMvQPLCk5uLG7xDvlmAWWjA9n0ZekBFK2zyVGZsG7hRRLyG+9mhE0xKhdyiUspHzA59L
	UUoZ5t+8YSYmSyt4JiZdhcYLAkHBbFm+N8P0uLQAC0k5JsUkFkoksk4Rsj/Jope7yAlml7
	LJMn8QHNAKxnFoLSTx0+Gk1xISS/wuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448568; a=rsa-sha256;
	cv=none;
	b=gwymLCtE7r83Z3K9ddvOJtcaD+qfU/paKcj9nAAqu28D+8Z7DLOr56e3dQ/FBkLEcoChTD
	GIeuUs8nH/ib/pClrIlCI63GiHeZPrAz94K8znGHn7l+sCI8D46xxGBBUT4IMksKZUU0fk
	TlO4W8L2CfFKGX4HhuyK7pEOdXE27CA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gioA9rPF;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 9 Sep 2025 20:09:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757448566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RIavL6Q3Ip2q2nE3QhJWaekN9zisbFp9u0xqsk2O2kg=;
	b=gioA9rPFWSH+UvL5/HKK3p882rmySyZ73qJxY4LAfrVtdm+uLI4RtfrBdAlAk7vmV3Gc0S
	odZGM7JFeGt80eex4fZHx8JfEL8lcq7TPkBRvcBcD9Vrl/9SHoDBMu554+u+7iGwmw8C+Q
	m0VN4ynzZi3IqVJ6VpHzseIWk5dkHhQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Message-ID: <3dmy2gxowbmq5wmpjtsb26d25k5fjev2geykik3du2ltmhrj7z@nfkwjjhndet5>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-3-hannes@cmpxchg.org>
 <rcxmemdxbxuvtag2qv4sjxoh7ho4z3bz3od6i76rc5yholx2rc@vncn6iuuee7b>
 <20250909151639.GF1474@cmpxchg.org>
 <pmpmejmw4swnconhf3u5uzzhwtki2fdnwvt73vf7lzkigrhwmb@sarxlksng7nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pmpmejmw4swnconhf3u5uzzhwtki2fdnwvt73vf7lzkigrhwmb@sarxlksng7nb>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bswwghipok3mawg3jtnzkrgxx4wh635n
X-Rspamd-Queue-Id: 4B03A140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757448568-963287
X-HE-Meta: U2FsdGVkX18AflszehBWwZbHDJ8GrwDJ7xdV848jLwNAgXAdHDNhvnO8Cf8VOBxX4JGUNOVJNzt3rNeDk907FbD2ZSaT4q5dm8kKX/xcxd/vRCwdxN7Utnx/CWOZIcvymwMvYKlkegIPWb9/NW7uxy91dlAtIS7L4B+Z8yL0nQAJ2XhTCXgWG4ZgTG0892gkYofSwyB8slOyQEnD7UvIjemD1GPeOc6P0x4dTRI2xH4RRc3+0AS3cX85Wsh+sXYvc/yXkBnkDSRuXNyBlLVRF9D/dmAr8fWprdu7WugB3qWkFe5nj3Jt/R3RXzUne9g286Wr81CbLLDdsQvIpk/1PiZK+D3jsaNyQs1Xmv3o6BY99jVbE4l/k31DHZTEm6FZbsBORyAzDVJt6B28UVss9bsTPnWiN0O+2mtIig01g+QojDjJG3r0kY27bFopj+1xZ4UloP7uOtvM7yQrB2y5GGFMH2BxrCwBdQsfhzOyvuKkFBg0W2c0hJP2kfijt17CLdvS16woQfp+osakVSepU8MSOF42XRAZMbNUEi6G1uJXU0kYwQpjXVDg487qS/e7ScSOezLQJcBNZWstY8/iibdt9kxBF3EAGmOcHBMi2F8h30qVE1jExLQeDwfwjHSzBdQyIqzaxyf13zSkmpP2Tg4a8tKOohfr5lLM3JwMxHKdZuizNPSrNst5TK6LAn7axugMkBQlNU0Fn2++wecE3v8ulUneK6H3yZuKLsX1CzzW4k9E1p/Kw4ADgblyfUBr11ztHo1isQ8uX/gM+9dB5qnqtJ99TWFqE+ImE+DMLFbe+7iDRDD6C2SGAjuaRW2CajrDWnI34jkN3qaiH/k5m/p3VBNGgW0rPztj5ZZ94sC1QLkdgft3TPgrsLevXeDiczHJFtQm6cXhs9YPDsm6ZACbaNusuBRd77kV8aCrLtib7DSNGw0ZcghprkdAzBQ5LG+pOvDQnVABLbIfPEs
 ZSsZ/Gl0
 VMfc8XLsR7lSIcdRT2AexyqoO1BxNvmb9WEa8rWAJngSB/vzOXxyZL6JaDc5WqXbjgqxQiGv7HN88gpDzBXzIrn4UbrZSdhmDHQbY+f68YHcyOcFPCscxiY/lPrEeqHHwbuvwUpb2qla1oxXbk7vZF4jWBncrmAwhYJIOOPDTdzRCfF6qDkv9K0mZSdxGS3F3i4NuaWcyWgu2iu7riawa5gKzkBvz3h1xLWhrcEMPkpMew2uccMThgM+ngj+JDAQdwImyQlvlMF0h8Y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 08:08:12PM +0000, Yosry Ahmed wrote:
> On Tue, Sep 09, 2025 at 04:16:39PM +0100, Johannes Weiner wrote:
> > On Fri, Sep 05, 2025 at 06:58:47PM +0000, Yosry Ahmed wrote:
> > > On Fri, Aug 29, 2025 at 05:15:27PM +0100, Johannes Weiner wrote:
> > > > With zswap using zsmalloc directly, there are no more in-tree users of
> > > > this code. Remove it.
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > ---
> > > [..]
> > > > @@ -125,45 +122,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
> > > >         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
> > > >         default ""
> > > >  
> > > > -choice
> > > > -	prompt "Default allocator"
> > > > -	depends on ZSWAP
> > > > -	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
> > > > -	help
> > > > -	  Selects the default allocator for the compressed cache for
> > > > -	  swap pages.
> > > > -	  The default is 'zbud' for compatibility, however please do
> > > > -	  read the description of each of the allocators below before
> > > > -	  making a right choice.
> > > > -
> > > > -	  The selection made here can be overridden by using the kernel
> > > > -	  command line 'zswap.zpool=' option.
> > > > +config ZSMALLOC
> > > > +	tristate
> > > >  
> > > > -config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > > > -	bool "zsmalloc"
> > > > -	select ZSMALLOC
> > > > -	help
> > > > -	  Use the zsmalloc allocator as the default allocator.
> > > > -endchoice
> > > > +if ZSMALLOC
> > > >  
> > > > -config ZSWAP_ZPOOL_DEFAULT
> > > > -       string
> > > > -       depends on ZSWAP
> > > > -       default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > > > -       default ""
> > > > +menu "Zsmalloc allocator options"
> > > > +	depends on ZSMALLOC
> > > >  
> > > > -config ZSMALLOC
> > > > -	tristate
> > > > -	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
> > > > -	depends on MMU
> > > > -	help
> > > > -	  zsmalloc is a slab-based memory allocator designed to store
> > > > -	  pages of various compression levels efficiently. It achieves
> > > > -	  the highest storage density with the least amount of fragmentation.
> > > 
> > > Why remove the prompt and help text here?
> > 
> > We shouldn't ask users unnecessary questions. Zswap and zram are the
> > user-visible kernel options; if one of them is selected, they should
> > just quietly pull in the zsmalloc code.
> 
> That's fair, although ideally we should call it out in the commit log :P

With the commit log amended:

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev> 

