Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB49CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 20:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAAF6B0088; Fri,  5 Jun 2026 16:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB696B008C; Fri,  5 Jun 2026 16:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A426B0092; Fri,  5 Jun 2026 16:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC666B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:55:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D05CA02F4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:55:13 +0000 (UTC)
X-FDA: 84847064106.14.FC84A86
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.83])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5304100010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:55:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infinite-source.de header.s=strato-dkim-0002 header.b=QN+LVqd9;
	dkim=pass header.d=infinite-source.de header.s=strato-dkim-0003 header.b=8WCLaVWz;
	dmarc=pass (policy=reject) header.from=infinite-source.de;
	arc=pass ("strato.com:s=strato-dkim-0002:i=1");
	spf=none (imf05.hostedemail.com: domain of kernel@infinite-source.de has no SPF policy when checking 85.215.255.83) smtp.mailfrom=kernel@infinite-source.de
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780692911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
	b=1V4ZIAhQa/7fbg1RU12rVjHLS/jYtVF/m6OUtVMFGKcTgFVrzjN4RWo1F3pNQ/mvUBM/k2
	L07W6bVBklCAEC/Xwyt1uWQKey5P++nDqWV9G8lj+KaUcQjbeLkZVP4mEX3qNUlOUNdGD0
	ij5M95/btmdZrZnU+E4hvo8nlDXhQjM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=infinite-source.de header.s=strato-dkim-0002 header.b=QN+LVqd9;
	dkim=pass header.d=infinite-source.de header.s=strato-dkim-0003 header.b=8WCLaVWz;
	dmarc=pass (policy=reject) header.from=infinite-source.de;
	arc=pass ("strato.com:s=strato-dkim-0002:i=1");
	spf=none (imf05.hostedemail.com: domain of kernel@infinite-source.de has no SPF policy when checking 85.215.255.83) smtp.mailfrom=kernel@infinite-source.de
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780692911;
	b=pgNJDzNmRf+OwGslSbr1hSgy2GOE6eLNJt8LtKA1BYCDGb4asnaljbGsT13iYVBhPb/H4S
	OG2XVsz6vXObtaV1zLcvz5307NRazE6y2O+wg5FC/0IEszIY95cVvLxSbjfN9/OFoUGUGV
	5q1OTTlwcWS2vqcXTGpsSQ7+DhNyqFc=
ARC-Seal: i=1; a=rsa-sha256; t=1780692890; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hh6lIgoTvUllGPKdx4NqM37Z3SF8LMp0ir6sZ5owEEk2q+iyku+p9P7kRvyaP5a5Je
    M3UWuwAPZA5fbGvy3uj6818OQdtroD2lLFkf3fuRCuFqcd2Xl64nwVAih7smIDfpUn0Q
    c7Eo7Vv1iGEygwBki/yfC8ZguabC+MPAxuGMTTKNFOWZtSl+bGQfabCP5TcUTI19kB85
    qNcTuzZgGOb2SJGKRylMVvx1qcHvH1y5+KftAdRHktrEnanFXMb943h2YwSTZn65ERa8
    GoUBTLXZfEFhl2OCSaUbPdwNnZ9JQFMETWQ7Xx4Il6DCg5V2HwY055f0aUjfSvtVcbM0
    ZaaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1780692890;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
    b=mW0kw25xNVqlyNoCKiNir7K4Wa6ubcpkH6PCelWgzXQPwunjJMVGM7/LcjVF8YXHy1
    yqPNxtmPyzg/t4B5lhMhMY+8kmO4A5kem9FUerITV6bn7GumCb4X92HDNo7jBvcyXDe/
    xi/rzkfvTRpyvV4BJi0xZV4HCsPohirJagixrEroGMqyNHAtdbxcBNNBLttSStQj0CMO
    iNrispwkk5pcEBWGvpfUMNuFXq711PgaG7p+azV290Qqs0flcOpW1ye+CZ8VFjKRi7j4
    zKA+ww//vjcofx3SV/4HQaVzT4tkvXmp8xOk1TyouzVXoC5EFRdPY/4ZhdcSm9baL8CF
    GvLg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1780692890;
    s=strato-dkim-0002; d=infinite-source.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
    b=QN+LVqd9GFndtvOCtdXeHdLoDQKUV99KE/r4wqHwhZj240RcZNueQdKolOkD1VpIVB
    Oc8Z0kOpEBJsH80PWib/FOzXyxjgiXNfxRQ9OzBkT5vJ7ee9kYSppu9cZYvrqRiY1WBv
    s/mGiD7HO9kD+dIFxfOw6XfM6fmVJT/OAHEtLdD91brHmwK5nWO4lPEc6+uqMGlB1882
    K3FKQvYlosYKDWdudFCB/16Z44IaD9PQXTA/knGRn6InGle36MKg3cc7wAU7muk9sh2v
    C35CyTzMG/N7ezxeVM0oD2TXAqdAdr3z8vnfk+Fdgg9Wr9xPxx4C3pUsDpcAu9z0jlPj
    Z8dg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1780692890;
    s=strato-dkim-0003; d=infinite-source.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
    b=8WCLaVWzkyF+FJqcLNijVyFBuhYUe+qoh+tOXBMn1wQUQAg06PmA5C7puyuyh3N7GY
    r95LcM6D6YmdR1gmxADQ==
X-RZG-AUTH: ":LW0Wek7mfO1Vkr5kPgWDvaJNkQpNEn8ylntakOISso1hE0McXX1lsX682SOpskKNgu1vdp7pXN2ayNAkRm8xGwNyBO1pryZlEoFdH8nUdt2z/2Kw21ZBog=="
Received: from [IPV6:2003:de:f737:c700:4ed4:78b0:5f62:98a7]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id 2b9b8e255Ksn2SU
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 5 Jun 2026 22:54:49 +0200 (CEST)
Message-ID: <0c9f58f1-52f6-481c-829f-6f5a70ffff7f@infinite-source.de>
Date: Fri, 5 Jun 2026 22:54:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 David Howells <dhowells@redhat.com>, David Hildenbrand <david@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
 <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Content-Language: en-US
From: The 8472 <kernel@infinite-source.de>
In-Reply-To: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qnwkwdef4bmxidzq1b41xmmzruponfqj
X-Rspamd-Queue-Id: B5304100010
X-HE-Tag: 1780692910-965640
X-HE-Meta: U2FsdGVkX1+UQ0zouuQvqcuavprhcfG66FOMMWf/82p3a4pGzHWgeMvOKPkYbJ5nxhIBcccyqIcHI1FvgecoIAzDGjrmHvUDoaOFOvttDsvzeA2FABZkZjGBjO7QJDAOkTIqRlV5+pGP1ucsC6G7a+2lh7sMQQdbGuHaItdqw3gnN6qSsX/X/PkO4haKIhn5ehLGje53iyw+LApJDqaOjVx3yse0IteTr9aQJYWsxDzg8octIlTfBXzzu7C/lzuX75/TnMwkyt1VFbWS+VDOiCyIvKGLf9B3cjEgreAZeYFQh5r6Nn1t7OZVlWRZguVn2eIDpWlc+0VazZfLMz25qYgwSA4b+NvnlNm6htAVClVmFbB/+rp50eZbFA8ou5BG9XCm2OUiNzhQSD9nEnekeKyryfb0oKot3iTGiOwWyOIbmGQ8m+dV9WnpG6W22PbbY1qj7yDHPyQEJOO/Sgk+sI7+3ySDSjceqaByhVcUEWT3RnyVs0ljknyX+zKovFzFyAjogBftuIVMMDMG08jPlefmZPyrLsmN8yYtJxLWMbP6e7Vp397S00a4spAXFfRHt5wQ1DQCB0YSk5jkmE4S/lIfq12hjULGZp686Mrt/QExeBp50F13uD5MakD1qTqXQw8SaOlDkQ4SNjtvHAJCbz8TA8cAQ1CxygQ1MWnBxWBIDxaPB9viAi0hQzDQ3GzQx31P36hTqHugdR5MTnu6vJ3pH8rfE7I42O8jiuDsgLv+WFTlwFDdLpik4V1OqJbtWS7yF31tPVLoITORxj0V4ri+LhH0JWLhXzA9cK2UL+NJ+LIY/Rf+1O6qkGn2y5gU7CpR2mWmm+XH2z0DAxQ1J4zC95Rr5I7IUadZhCqJfNPtoDTGydYbE8+gi8rvnxqkimGKl2fQ2FrBNclCTPR4OZPQ60Uq0NSYlUPwJLx4Pyk1JlwiUcWWqe33mRJ6+AouiDkIXV9It1JyiJSfuX9
 K6UxIIuQ
 SByplPehRfWHya5TUN4EjSapSYnIoMAQfRr04bLD8Ioagv5ewn41qWnL/hWs8Qbo5zc/2c38DHn1vGchjYefpSjAFA2xa6JeMeGx3hBXOk3gcok34Lz4sBp6VhyMk7WV/w70HwZdL32ZE8ee42/oU+Btr1GNtTTcelygf4GUS/WkfhuyS9u9BBXVbaMtgso/4BhV6lg5M1xdrj6QUrTmfOaDY30k2UyXF9KY+qAP2azm9HShBFpWppYMeSIJXtAhcQJGB+allF4XgGVhsYYeLtkiC6Xf8/KIiP7h93b3VV6iPzAEz9XRXYbLRLtWSAdYmbUGarbZ5mAc7uCtt0TfYyGO36dkf5rOewpmIxOXKHkcc1I/QvhpQ2gXvfcB07wyr4PiPtM6G6D7s4OuoVSs6MQl3zdadS2+TmDrTBFbZp4vRfPtNomqoUP0wtRdA8PRiUv+rkxZxcgVsXtxe67JFMe4/FzKPN1jua9uhj+Ub2MpVu8M8oE29j2OgW9sOoMeZPhhtf7T3QDij6t2e6zLFee5hF0EBzV3IC7CSW651vLiLeD4E4UiwuBYT6FyQWpyIMt51ul0i5nPeZrze9BZZnYtECoqecngAFLi/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/06/2026 17:58, Linus Torvalds wrote:
> On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
>>
>>> It looks like you're actually doing exactly the thing that I thought
>>> was crazy and wouldn't even work reliably: you change the
>>> common_response[] contents dynamically *after* the vmsplice, and
>>> depend on the fact that changing it in user space changes the buffer
>>> in the pipe too.
>>
>> No no, it's definitely not doing that (or it's a bug, but it's not
>> supposed to happen). I'm perfectly aware that one must definitely not
>> do that, and it's a guarantee the user of vmsplice() must provide.
> 
> Whew, good.
> 
> In that case, can you just try the vmsplice patch series (Christian
> already found a bug, but I don't think it will necessarily matter in
> practice - famous last words) and that test patch of mine, and see if
> it all (a) works for you and (b) if you have any numbers for
> performance that would be *great*.
> 
> There aren't many obvious splice users out there, and even if they
> were to exist they are typically specialized enough that you have to
> have a real use case to then tell if the patches make a difference in
> real life or not.

In the Rust standard library we use splice as one of several strategies
in our generic io::copy[0] routine. It selects the strategy[1] based on
source and sink types.

It tries

- copy_file_range
- sendfile
- splice
- fallback to userspace read-write loop

sendfile or splice are skipped when we can't uphold the "callers must ensure
transferred portions in_fd remain unmodified" condition on the manpage,
which unfortunately includes some particularly desirable combinations of
sinks and sources (such as mutable files -> socket).

We primarily want this for reflink copies and to avoid the syscall
overhead of a read-write loop with a small stack buffer.

Any additional zerocopy benefit, when it doesn't lead to unstable data, is
welcome but not critical. E.g. it'd be nice if sendfile could do the following:
For a 1MB source and a socket with a 64kB sendbuffer it could zerocopy first ~900kB
safely and then memcpy the last 64kB to ensure it can't be modified after the
syscall returns. But a "just memcpy in kernel space instead of zerocopy" flag for
sendfile would be ok too.

We're currently not making use of vmsplice. In theory we'd like to use it for
copying from `&'static [u8]` sources since the type upholds the requirements of
vmsplice, but type specialization currently is not powerful enough to
select based on this lifetime and it's unclear if it'll ever be.


[0] https://doc.rust-lang.org/nightly/std/io/fn.copy.html
[1] https://github.com/rust-lang/rust/blob/ac6f3a3e778a586854bdbf8f15202e11e2348d9f/library/std/src/sys/io/kernel_copy/linux.rs#L210-L259

> 
> So you testing that thing would seem to be a great first test of
> whether any of this is realistic..
> 
>                 Linus
> 


