Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003E1606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iLViwbFr
Received: by kanga.kvack.org (Postfix)
	id 0DA936B08D6; Tue, 24 Nov 2026 21:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08CD16B08D7; Tue, 24 Nov 2026 21:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3776B08D8; Tue, 24 Nov 2026 21:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDBC96B08D6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:46:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3096A0DC1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:46:57 +0000 (UTC)
X-FDA: 85472104074.07.C7F9485
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 06C3A40004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:46:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iLViwbFr;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795574816;
	b=Lf2sk/facUNoqus+erXe+sxRepKRj1nmaCkhsshlH0VYBpoxiwaItKHSUYHzeARHYGUysg
	4Oxo0cWiCKWHNyt23lgR3J2YTuBwhkXPVRCB0hlHj6/i5bbPCXqnUzdQE1S0BejazjEqv/
	0eOm8/V48i4lZnphZZoatkhVCQ0ucjs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795574816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBs2/sUNBfor4ZHtJTf22aCZgoIprVHJR6vT9Vi57+4=;
	b=ytjX5eVUf4zU+QdkTRkiKK2t54tswck2lkxj7kxl+Mq+p28gQUEaYjCpg5YV56uyvFxuXQ
	8m0yOIzH331hpPxOG4W4yebOMylt0TtZaezOFzM+HOHBUyIkmNm0oEB1Kmt10tC1gjE0y3
	Xq711J1vNRPM76rQddbLcNrwnRXE1tA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iLViwbFr;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 019C36188B;
	Wed, 25 Nov 2026 02:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E221F000CA;
	Wed, 25 Nov 2026 02:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795574814;
	bh=LBs2/sUNBfor4ZHtJTf22aCZgoIprVHJR6vT9Vi57+4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iLViwbFrY9CPjLILqEqUdMW+frKVtQhVNoz4b5wrOn2at1oLEhjI2nDNPwI3yq+C0
	 A5lwpzKqQgwlWDHl5e2+2xh+SOOTASgBIT78+ryZLjcpoAsNiV04fhhsmwyCihSfj0
	 oXNh3lpUar1nahJ7f+ydJLCylbHSUz0Ie5ILZM+8=
Date: Tue, 24 Nov 2026 18:46:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xuewen Wang <wangxuewen_ky@163.com>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, sj@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Xuewen Wang
 <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1] tools/mm: page-types: flush pending idle bitmap bits
 after walking
Message-Id: <20261124184653.d6e1d627154d526e6cd85d27@linux-foundation.org>
In-Reply-To: <20261118021253.1691428-1-wangxuewen_ky@163.com>
References: <20261118021253.1691428-1-wangxuewen_ky@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06C3A40004
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: exye8dh6fpmdp7kshawtgpmgzaxzpc78
X-HE-Tag: 1795574815-607513
X-HE-Meta: U2FsdGVkX1+rxpadhXTlpobOh9IDAfixk42r2iDB3EOtgfuRUXpNcojtVqDkWFEtMO3JLhTKGFAPSp7Z6hTmRVUgUBsrHss/RrLKoPCbDF/YTeea3JwcOBpAu7vXj/Tdk6/jnFAi60Ueb04/AVMnYwvaK4W1Z0eDVZJitKU7caor9wYQltPxW1DRheuIlnV4DWHGFnui7kS57lDPQe2IrHgYiETK1ZTKBRDX8tx/KxI1BbfYr66h4v4vgR4u4kxAtDZiyMOAGMFB4hC3WfrZQAPq1xIy8/mjTBjkTVkLupm5uswf+9X60e19W1SOgTM2kCiegV2tqxFHxkEJ/f1Zy7u32nPyQVFG8JLyv3MXrqswUhYlI+zSVt3JzzRDHUdJXEbThRMZW4MAoez4/HdNl7wh/kRkOmbAaEXGBk6P57DF7hrL4p1EyoyAbVYHnS+b2u5hgXS6ya3LT7yFauit8O9NFaOce6vY8o35pMEWOTb9p6ovSctZUXk3D2TRqb4Ddk5sK5GzwOJkuSe5sIxlqdXJiXtOPkeY8cDxKCqGbd9dOJCgCqOQc5hxValqBy9JI2iqdEvl/zGd0nvLvBvBP0rtlOG9WDI+pGGLx99ilJveznJ1Cb4U9LkpvJPdsBrFGUsnSZto83uaU06RqOpKTiHLCLy5xLpn6C656uVP2cyM1ymjwHau+tQsL9a3i7lN9Y3ts1hL+HJ4ZZANQQCfWLMD2uX+NkVFzRgeKW5GKG1gHmqXCbzVqmNRTUSlpvmAt+1Fi1SJawQ6kYdbjgGI7mh24wzd4O1A+qTh9Va8OsOh31uWhZguGrcSdf3v3Vxr8QOgKa1PK1DovqJs1CQ0ssQuHqBHt0843J9OjnVixr3/w+UijLa9blkHwmw5r6HvErl60HiszdafQefM8eSV/Z/lYPfYN0XVeCaD+rVyodRIoWE5Eqq+r8IYw5/A1+KUOKpD1H3OvXLr1B9mwmp
 0HkKt5j3
 zIaT+9UZ5RkQWFXHt0TznDhCQbF2L/5t+iw43IM/xZrRXRa9fZM4c2sOKl2JNhmYVWzAqyHe80tqMil55GnVPy6A2Lb8/WUCQMHTt7ju1qkC+3nPycC8vSSCvr7RhhmOTnrf/pglVjzVixfPrvkcWaNVwoZabtiD+Z9kmjYTq2mqbM2fTXs6LSdqryQEJ+FGVDXtYko1XstpHqnMNWANZC2cnt1uhXh9wohecs45onqMZImklikR6SErhE8oTG7HqBu0l4qdfVxJY14cE/pdt5WSaZA6PktANAICMejg9hN1rgYZ6EBL+VjKkIVXzLq4dk1IqNEViS9RnnBqERqTE1k5wBaNga6lgpiqz34l5YVvAE7Ioep0hDZxnXCj1q76AMbrkRUB54iRK31NzvhrVKxleKYX88dkCvJv2qQl9y6cbGALWCFcMMUVi4Cc+TlEiZdlU8KB0ukiGRGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 10:12:53 +0800 Xuewen Wang <wangxuewen_ky@163.com> wrote:

> From: Xuewen Wang <wangxuewen@kylinos.cn>
> 
> mark_page_idle() buffers bits for one 64-page bitmap word and writes
> that word when a page in another word is encountered.
> 
> walk_addr_ranges() tries to flush the final word by marking PFN 0.
> If the last buffered PFN is below 64, this only adds a bit to the same
> word and nothing is written. Otherwise it writes the pending word but
> leaves an unwanted PFN 0 bit buffered. walk_page_cache() does not flush
> at all, so its final pending bits are not written.
> 
> Extract the write operation into flush_page_idle() and use it both when
> changing words and after either walker returns to main(). Clear the
> buffer after a successful write and skip writes when it is empty.
> Place the final flush before the no-summary early return.
> 
> Use 1ULL for the bit mask so shifts by 32 through 63 are also valid
> on 32-bit hosts.
> 
> ...
>  
> @@ -1364,6 +1373,9 @@ int main(int argc, char *argv[])
>  	else
>  		walk_addr_ranges();
>  
> +	if (opt_mark_idle)
> +		flush_page_idle();

Very minor, but we shouldn't exit(0) if that flush_page_idle() returned
error?

>  	if (opt_list == 1)
>  		flush_page_range();
>  


