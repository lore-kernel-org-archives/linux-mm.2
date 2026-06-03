Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486AFCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5328C6B0088; Wed,  3 Jun 2026 03:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BBAC6B008A; Wed,  3 Jun 2026 03:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B8C6B008C; Wed,  3 Jun 2026 03:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20CBF6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:50:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B048C8CE07
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:50:24 +0000 (UTC)
X-FDA: 84837828768.12.309AB82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08420A0013
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:50:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L2Up9Zp/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88hbOu2kVMzvRDy1eOcozFAmg35YAXSjbmJFuM/mDK4=;
	b=glP8QPNd6lNa+eM3YHk9dBpgD1y1l29P0a0jW/grwbtGYtdLS8f99ZckQC0m7hNIzEGDP4
	KgYMCF1el9di/z7DUvfDo19hpV40UAGi43v04NWsN7TU9N8+iA7W7ruBJTgt1B9quLC1RH
	qjHKOR2/JvN/Xcwl+A/rqT7Fm+dZOzU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L2Up9Zp/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473023;
	b=3Nmi2dOjOb9/acUucmCqn2sWKuoFqOrB2HcHdWX+y0zeUS7EgTU6TSAFMvPIL0Eqr+tJgu
	8jft+ZYvOSsykQVcJiEeZjcatlKlkgtdaEv4jy+w0DYCiQMffsDZFXF92bZt+dXO3sUiCs
	SO4YoKd3x3ii7PASS1naaNIWmRPTOA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DCA060222;
	Wed,  3 Jun 2026 07:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB7D1F00893;
	Wed,  3 Jun 2026 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780473022;
	bh=88hbOu2kVMzvRDy1eOcozFAmg35YAXSjbmJFuM/mDK4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L2Up9Zp/7tLPcWy426HJxpyxK5jrLwIKsJh/I7EJrRqcMVmPW2D3+n64+taNy6XZD
	 ZwdSTJ3RON53sNMh72dYcdBngzi+//cBXjPCP2TR0P2pLDzeSCUSNIp2+t/UrFFG+f
	 l5kJXpa9fMPly8p1SjmScFTJJ15uQW2Zu81INbFDgDLPz5mtcYEx1uNknRioWz8unX
	 U0un4cVpgXwBSRBNNymxkAycgiZmzK55Txhoa8kYnHkznYtABdxBsIRTGYEIQQqIYB
	 F0JhkZF7PR8dLeyUevRBWaTjlMrnD/sVqHpvTV1ougk40oJuqlpF6GsQKvj5/BOxGQ
	 cyjSy6gZLovcA==
Message-ID: <df22c9ff-6705-426e-85b1-b5018590d723@kernel.org>
Date: Wed, 3 Jun 2026 09:50:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 David Howells <dhowells@redhat.com>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <821ed41e-5b2f-4d17-aeb2-71b0361f8e7f@kernel.org>
 <20260602184440.GB2503276@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260602184440.GB2503276@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 08420A0013
X-Rspam-User: 
X-Stat-Signature: bgfz4pn181xntz9haba766tuj7eopowu
X-Rspamd-Server: rspam09
X-HE-Tag: 1780473022-757753
X-HE-Meta: U2FsdGVkX1+lKvixSyERaigwO45zLllgN2V+CG8boUUC1I1nzSG+M48YF3bF5J3GELHiPve5zj2B+pN4YMDNyjrRATMHe3UEvLFGTI0or7hMivptZTfzxgHsadXu8sm1mdngR9erD0h7dzSuU0ngFcdVEhGbiGqiYFfD2c4TTQkv4yxdkBEsqpJjYUi5lEM8G9/Hdd21sH1Xv97wZBOTJ/2P477t0wyITecZPPhZwnBd0WVEu/fs5VaWk+i6dA9UIiUZVxNsS2qesLbYo4h2CUTjSLqwO5kZCpjAoxfvaLLmUv855coTjKJx1JJHEn2CyWs1gnbqxtTUH+N44wEGK7AiQSwND80dTZVhpfuAf1hrx1tPhQEsjKk/Sm0bn34Iiwnn17wfKjTyzgKbC9jDCs/VRSxTemhuXOKdyCmLfrVHTNJX1sAcI0a02jV+SZ+BlWlhA+FTvbpz8rfbyxkv4ZIr1Kf+ffLMWkl24IcPXSfOSmqj1uRdA1Nvh4pkYWS8yc0V4aU2WDoK+WnEXI04r3FaCOLtW/7VIekZ1jsWuJaaN12rQyMVzVyMKeuzBiQkR7jVMx7Tvsmhs6h0e9+LJozoAhB2brMNJsU11yiMuZxQlWF1rhvu3oT/0NVKigRH/je0NPPUxfBJBOCRetqu4QC0uhLdm2T+0GhTKwuxwFVy0wE7CBXFnKaOcBpBCPyCSIHXGrXfKaxx/mHK19OGPoaqnpyClNmRArCYn9qvYefS+IM3euNifqCGL3QeiMcE5dNkSXmFqqIhUzNT+IJ/ceIfEFsChlMQpmgvaMrTt0Wo19dcAMmYM/r8fWNznvXzh35Q5kO6hXBnUqB2geuP58sh4Zc84Rza7PCqolEK6kepupwrrf+T/uq8kEIQIvaJkXKxx+E71RwXZf3abNznCUaOiyccQ094Wx285e+AjgYYrk6H0q7/dxrUSo4yKMr+qK2GHVmUUM/ViShMTBN
 26ZbkGEG
 R5qFlPUT/hgn2e3GiGFrkI/r5C/xgf8sGg/iSAqPDVHKCPoS+ECpiQfZpi8IDq31LY24OdrcaWYZmA0zj3Lr2Jx5BvM6v7HSeqNEQdK1RCg0AHSSJiM8HY7KcBZkRQB2hnxFYGDFN8ePemCJbHY2NcZB1pA2Ahdw3V1C65eY1MqSK+3/1fqxZZ3K6bJPP81I/wkVe0Ke3yd7MExANKrzmNxLg1sSRVxM+QfoLtr1XW2tPh+Krsfuz7EdYnLnra5bn9eqPvBnUCnDD7bLnReGStix7Ig684i9HAN83DeeYD19WCPj/x+CC9FbUwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 20:44, Eric Biggers wrote:
> On Tue, Jun 02, 2026 at 10:25:06AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/2/26 02:28, Andrew Morton wrote:
>>>
>>>
>>> Well yes, The patchset seems sensible from a quality POV.  But to make
>>> a decision we should first have a decent understanding of its downside
>>> impact.
>>
>> I guess most (all?) of us ... dislike ... vmsplice(), so trying to remove it
>> entirely is certainly very appealing ...
>>
>>>
>>> I haven't seen a description of that impact in the discussion thus far.
>>> And that description is owed, please.
>>>
>>> I assume a small number of specialized applications are using
>>> vmsplice() to great effect?  What are those applications?  What is the
>>> impact of this change?
>>
>>
>> I did some digging, and the kernel crypto API documents using splice/vmsplice
>> for zero-copy[1] and libkcapi [2].
>>
>> I did not find performance numbers, how much vmsplice/splice actually gives us.
>> Playing with the kcapi-speed tool [3] (specifying --vmsplice vs. --sendmsg)
>> doesn't really reveal a big difference at least on my notebook. Not sure if the
>> parameters I specify are reasonable.
>>
>> I don't know whether downgrading vmsplice to preadv2/pwritev2 would perform
>> significantly worse than sendmsg ... and I don't know what the default would
>> usually be (default to vmsplice or sendmsg). I might try finding some time to
>> play with it more, but I doubt it, so if anybody else has time ... :)
> 
> AF_ALG is a mistake and isn't commonly used.  Using a userspace crypto
> library is faster and is what almost everyone does anyway, as it avoids
> the syscall overhead.  There are many other issues with AF_ALG as well.
> 
> 7.2 will mark AF_ALG as deprecated, mostly remove AF_ALG's zero-copy
> support, and remove AF_ALG's async I/O support:
> 
>     https://lore.kernel.org/linux-crypto/20260430011544.31823-1-ebiggers@kernel.org/
>     https://lore.kernel.org/linux-crypto/20260504225328.25356-1-ebiggers@kernel.org/
>     https://lore.kernel.org/linux-crypto/20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com/
> 
> In practice, the programs that are keeping Linux distros from disabling
> AF_ALG in their kconfig outright are just iwd, cryptsetup, and bluez.
> They use AF_ALG just because it was mistakenly thought to be easier than
> using a userspace crypto library.  They don't need maximum performance,
> nor do they use vmsplice, splice, or sendfile.
> 
> There is other highly niche code out there that does implement the
> AF_ALG + vmsplice + splice thing, e.g. libkcapi.  But it's just not
> enough of a reason to keep zero-copy support, especially considering
> that AF_ALG has always been the wrong solution in the first place.  The
> fallback to copying the data is fine for this deprecated API.

Cool, thanks for sharing that Eric!

-- 
Cheers,

David

