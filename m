Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD3E606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 01:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OAu6YavJ
Received: by kanga.kvack.org (Postfix)
	id 2DB3C6B05B2; Thu, 26 Nov 2026 20:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284966B05B3; Thu, 26 Nov 2026 20:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AFB6B05B4; Thu, 26 Nov 2026 20:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E50AE6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:29:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 622391C1F8E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:29:38 +0000 (UTC)
X-FDA: 85479166836.30.68FBDD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 987241A000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:29:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAu6YavJ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795742976;
	b=bORLLeolaB0rm7GpvvjZTjFtoqBi+FIYRUFaj46h+vOIho72Vv3w9Q2en5m+IG3iUR9xuO
	x2g7pm3q4JrYdGE+yd3yBWBtBd0QXB1fI7ESBW36DZGmYtZDhD4UmOOxvNgnmFWoRHnd0Q
	EBe1JhnWnyL8B1TgCRLpLydP2o7ZAt0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795742976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FypYXM5FeA2iJfnFaCkHl4mvsBvM61RuBeAVlTRfmR8=;
	b=vm24VshJUXPi7xh4GGF5SyAEte0MX88ErXfRmPDYBp6ZBqzHp6KWsJkzasPm9IDvCAjlzc
	48+BI3X2/itPfOYD6VGP8veh8x04G05BsukmpHn98kjiHtfSFsbiCnfmHH43dufzuOwNkK
	oW3u8RX16096Fu+7MMnDWA/pzvvWM5M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAu6YavJ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B767E61271;
	Fri, 27 Nov 2026 01:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DEB1F00899;
	Fri, 27 Nov 2026 01:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795742975;
	bh=FypYXM5FeA2iJfnFaCkHl4mvsBvM61RuBeAVlTRfmR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OAu6YavJh41VPSLRJRpjQ/Hc24PBModRrha2Mh+24JGmFScd1n222ZX1YldYj7FZx
	 x6gYJxpydzan+PxQv2spXTqG2W/Nf7Lg3F2Kh3/rC9xfaVtUOTD+pwKzAiiVhG6G7P
	 ivo8P5qcyJsg15VxNV/K2bUrNlT/Ktc72LmFmXNo=
Date: Thu, 26 Nov 2026 17:29:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Zhen Ni <zhen.ni@easystack.cn>,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] mm/page_owner: document shell usage of page_owner
 filters
Message-Id: <20261126172934.69755dd97d3716e83fa25c2d@linux-foundation.org>
In-Reply-To: <20261126-page_owner_filter_shell-v1-1-cbbcff2fcb08@igalia.com>
References: <20261126-page_owner_filter_shell-v1-1-cbbcff2fcb08@igalia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 987241A000A
X-Rspam-User:
X-Stat-Signature: yi589xqhgc57eoj386mjauuyj9qh7gxd
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795742976-830730
X-HE-Meta: U2FsdGVkX1/UYDHySd0K/wZXzeKnPFUWh9ZoI/Iws3RzZ3K2BpqvVj/Lx0mdvPCfsKrDAJQfGaqG7q4wDUcedaSRNQC/TBJrgHcYuqzKFOUKoRPr660tloIcwUyZOsSEnSPe/3duR8Do6g586sCsrIlIqQnpY3M2S5rPL+twxCVGfpQZrL/lBZ9ytyD0unR3boZ9RNkU79HdHylXvpQF3SNfY/T308e1LlV2yVeDZUnxkJ4X4sUlv4rLT7/kjQUYMsaJoC2Dk2cQkOjz5t0X3ciyu0n8+9MyISx7+aQVAWlOUglnezvwbYENxRVzHBUKvySBmHQL9VnVz/4mmLkwIeZqMYoPUG30chyzoowQpYHtDIwM0IPRs+AuBpYCRMoKVYJ0pU7LoiOh6hkyGoYr35zIZVQvVp7R753V9OC7qLdY+r3VrtIUEgxNfUEAwvGYoC3MsBiOpojFgNqBsxm4eDM/Mq5tT3MWQmSkOuGBON/Mcx7OHVz2XiCz+j5jmqY31PbX/bmatS3FiVEgRXqkpa/i0/7ZD1orliqMRMMrnsOOWAr6HE7I06yGsFf9Czzt4MfIcazxYMGW/w4i7Z7A1dBE7UFk1e4kjow89ce42AQ9wd/uPPWBQPn6VsSQTRyB5/+3Szr3xIfOON96yca0aYQ14/cgG1G1RN8eTqgagnvYY4Vmux2aGVvRSAjkW+kRMMaHBEJwWK1b9YhxK+96HVFCD0h4j/4qM6VEgVS962zjdmppXFt1JqdSgSRB0esivINFCHZyR1o3eCSac12N+cMG6DxVn9nC/0YSpII3ZXgS0fzcelnU0PXwvQ7/YHZb+v3vc0pg9FyGcgh5vWIporswJGTUHF2/tYAayDj/XH5mwrLaR6Xy9GrHfFZwxbAUKOSCe/yD1OLWdH7a17XZpt32P825kKjSiZzzru56XdWm5teHCFipkbPw12yuQ8AmWyR2aFvTA9NbBDXnOCf
 twRt60ZQ
 lJXTg7YiNC61HnAk5LTT2Z38+Ajm69yp53Cmbi/52na+SdFpLQuEZoEKpY0VX5hipCV6rpScTzMcuUgs7UdAzveeJ9cIozyS+0+q6Fq69BR7GKsMkOHeC35hpRli5rZbI1SrM4LOX3r9+XvWDkfnQg/muxUNjO9kY1IlG+jqQH0UbSQBeASJR/5UGhDP1Y1zmje9TuWh5OWe5lgUZRxbVpaQEUOMjQfNnSu8+71pqUNUycv8iLecyExlL2uB2Kl+PzwoI9LzbndL9f5cRoabRZ8CFRIjSKZBfozmAVW77NoNMjFH+jCXJwvnaPMyVXARdOVvZyvSg85oQvJa2v9cEB0BRP3CjNysAVQr/ouzA66lb7y0shIC0vqKGW3kePZA6ojOEgyHr4grVtCJn1lAgY610YfI+ZQgZRIkAkeQ6zwtkNyZVBZbKPdNbpRwsTvxr9EVeFJD4pnBFKGG+N20pPOhS7VKflhklR787POzJhrnk+L9rUd1rpSkgBK+NhQl5S9uTrkJs3PS71c7ihf8Yb1DkpVrVbCwtHFOo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 13:40:02 -0300 Mauricio Faria de Oliveira <mfo@igalia.com> wrote:

> Document how to use page_owner filters directly from the shell,
> without relying on the page_owner_filter tool, with an example.

Thanks.

If people don't want to use the tool then they can just look in
/sys/kernel/debug/page_owner and figure it out for themselves.  But...

> +	# Open file in read-write mode
> +	exec 3<>/sys/kernel/debug/page_owner
> +
> +	# Write filter command(s)
> +	echo 'mode=handle' >&3
> +	# (and/or)
> +	echo 'nid=0' >&3
> +
> +	# Read filtered output
> +	cat <&3 >output.txt
> +
> +	# Close file
> +	exec 3>&-

The need to do both "configure it" and "use it" using the same fd is a
bit subtle for script development so people may find this small
addition useful.


