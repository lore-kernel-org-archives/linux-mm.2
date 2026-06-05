Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D81CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6D86B008A; Fri,  5 Jun 2026 05:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E386B008C; Fri,  5 Jun 2026 05:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294386B0092; Fri,  5 Jun 2026 05:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5C06B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:43:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6BCC140298
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:43:52 +0000 (UTC)
X-FDA: 84845372304.15.F831EB2
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA654140010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:43:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samba.org header.s=42 header.b=3cszkcrM;
	spf=pass (imf26.hostedemail.com: domain of metze@samba.org designates 144.76.82.148 as permitted sender) smtp.mailfrom=metze@samba.org;
	dmarc=pass (policy=quarantine) header.from=samba.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780652631;
	b=4K7GHFLtNnBFCAhxW5wHWCTKDcrW3lEcshgB7Ve0lUpHxCZbR7843FMgjVNWzqCCL4gUXb
	XG0lhO6BVIkZfjIx/OL9aDwsEQkDjmN4VWRegS5CLTuewS3V7110NXUFgRBRIpPiDKBL+6
	6QGAafffhknu/NlMo9FRy+YfSQyy+RE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samba.org header.s=42 header.b=3cszkcrM;
	spf=pass (imf26.hostedemail.com: domain of metze@samba.org designates 144.76.82.148 as permitted sender) smtp.mailfrom=metze@samba.org;
	dmarc=pass (policy=quarantine) header.from=samba.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780652631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9/ac27hGADmFEUeWK9UOrni0IAhBio+aj/EwSAvs6c=;
	b=x9cvxHHIDNXJj8u6C2qvCTP9G5fdlS6Mwc8+uojh5jUzEPpTRiMr/qE1bqGnVwK7IXVj8X
	B0i0KfyFAG4O51L+UTFNIiGYnriX5sqp5ipHftdRDu/701zHtvYutiHYzXTBNAMGFwZma6
	ngK2OpQS4pYNF8yKIFrfQYm/8dvs8vo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=t9/ac27hGADmFEUeWK9UOrni0IAhBio+aj/EwSAvs6c=; b=3cszkcrMUa9e0iFFaqn9tXeh3m
	srCm+/TqQ5cDc/r3RDKwMGy6Kc+ytoNbB1Q7eyNWVRWZ7jmfMaMMlpFcd/ub/AFHPv/JGAgz4EKYI
	HDkqgD4MR2wj2Cm1vrMMXPl9rshyLdUrwxBHoYlFYuxdrzKvfbrg79g1kN0oZlWOl0MP0vB/eRVX7
	Uw+xPIK98RTZpLVkYW4ouxNPO6fBSmLoxnNFL42y9K4f1J6XeK3tm1EzALd7D8D3p+oD+lTXxDlJ3
	Xow8nZQd7OSqhlFTLh5d7SBPzOu5lfpOXRCCci2oZhsEVpGnNZqWx0q5gERdwlu93RGuZBplxAgxv
	jcXsoEEXvF+NdRDA82SzGph7eEdIFtE0lud0gFktxIHlcrCchpczpNRQbXrtro2Mb07859aL51067
	1XCBjS50nJ+uTGzrVGLCD8tgBc6Qg7OqKFWIl7KZnxQ9IW6W+AWmRo4aDXD74v7VLIpNM47Md+TlY
	60QLHdqSou+luNHxXAjl4G7z;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wVR5e-0000000EDwm-2S8I;
	Fri, 05 Jun 2026 09:43:46 +0000
Message-ID: <512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
Date: Fri, 5 Jun 2026 11:43:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org,
 axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CA654140010
X-Stat-Signature: ouxb8qmhuf5ja4r46drcuq6t3jqecmm6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780652630-512470
X-HE-Meta: U2FsdGVkX1/bKX94Fk4ScW80TvamwJ3kba789VdoneiVlMpNxRg6QCTdjVCBy/74O8u9Pd5Y+c/80Z6mG3pNIuYS553vS0Fem5gPum3ivFGe0jzWJSRvpQbOb6moIqmYHJA9g2cBBlLOBX0IRW6EojvKxEDsUN6q5mDfRBs9ERsQ2O/tEOkA9UH0UxAnlW5PLx+xU/WchK/PE37eNGRFrHrE1C2/aWUZaJEMwKutM5ZtG1doP1GjK7txLlZItorr6SyAGPUcnCWSNAoQX05LRCqxAXDkfPHFzrYFwIJwW+fiHBRgwPApHRwzvoCR0G38Ig/rWoxMJCCpCV+zSpMos4l+cuSOITj6c4Ly2/4LPdMV/zBIT9BwOs6ykT9UoDooR6xwQN7yNVKdtTOg0Tp+JbR+B6L7EcIQUrxt3KpWxszwI5phT1+uSKevMbjuxva0Jbqw433ozKKFNWemXkaHBxInYxSIG+es0sW4ZUJfta0ejc92qzhqV5m2snGzVbLfD0aFXv7+P3mtgVSyzDIHhF7CxVidjTjFhBXP3sVKZouqvPef8KL83TBLSYOed0ZT9+L15C8+z5ZmEuM+gwBTKyXavn1hhWEGmQRFbIzh5iY/FyrjnidubcO1rD24NxvkjX0wRFPA69KJ3waWSsbnjodBZLmM7aiwZIrX1D5BxpZE5wc1ppTI/ptPjYgZPDL/MMQqGkzpYKJNGMN7G0hvZahw77cepUUAbUEpLQd5tbiLAS+HxlNvN1PXq5dV9AZ3Q3EFL+b1uIErYGMiCRy6uR4IxZZz1m849OspH12WNwtDAaeEHfM8RJYI0zgGga54YT3LsTqpkTFCp2xeTGdpTLEKzhOUSufKjf8xKJslsJreQwVZNxwbEKh/OURk+dx6h+lwHhta5bAkOmQX2S0RwMQM6FZP5fc7psoHozcWd9vOcEndaX0DquUFGrTmKnP3ugMcs8vZH8Lbg3hiQ1k
 //7lykBz
 VLWPWhHBpNaYfqKK4lMWKw0/TspT8FrEBs96ycVJIHsJmvqOhlC1ayQAnQlFa9W0R28shKLWGyNqeM0C8XzlgFZLH5so+eWfefwMpwBzXLw00/aaaWsJiDEW5tmUMCyzVEitq3wLrX8whzamYTr8GASG/gruPgKitdLedhrj+U67He90GF3dWMLdbVLrLq0uJZLEglAODiggB1jVwb7JFz71RuJgIo5rjwe5hVVxxM1iGlqVGS/Zefl4tzCK8W1pKsjfHZ6vJ5POIE+/m9REVTKKpRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

>> Am I understanding correctly that this will completely break zerocopy
>> sendfile?
> 
> Very much, yes.
> 
> And it's worth making it very very clear that ABSOLUTELY NONE of the
> recent big security bugs were in splice.
> 
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
> 
> So in that sense, it's a bit sad to discuss castrating splice.
> 
> But it's probably still the right thing to at least try.
> 
> I've seen very impressive benchmark numbers over the years, but
> they've often smelled more like benchmarketing than actual real work.
> 
> There's also a real possibility that a lot of the sendfile / splice
> advantage has little to do with zero-copy, and more to do with the
> cost of mapping and maintaining buffers in user space.
> 
> If you are sending file data using plain reads and writes, it's not
> just the "copy from user space to socket data structures".
> 
> There's also the cost of populating user space in the first place:
> page faults for mmap made *that* historical copy avoidance basically a
> fairy tale.
> 
> And not using mmap means that you have the cost of double caching in
> the kernel _and_ user space etc.
> 
> So sendfile() as a concept (whether you use combinations of splice()
> system calls or the sendfile system call itsefl) isn't necessarily
> only about the zero-copy, it's really also about avoiding the user
> space memory management.

I don't think so. Ok, maybe for webservers just serving tiny
html files, that's true. But for me with Samba it's really the
copy_to/from_iter() that is the major factor.

We can use io_uring with IOSQE_ASYNC in order to offload
the memcpy cpu wasting to different cores, but it's still
wasting a lot of resources.

For the case of filesystem => socket, we can use
IORING_OP_SENDMSG_ZC and that at least removes the
copy_from_iter() in the sendmsg path, but the
IORING_OP_READV of buffers in the sizes up to 8MBytes
is wasting cpu in copy_to_iter().

For the case with smbdirect and RDMA offload with 2x200GBit/s links
changes from only ~33GBytes/s are used (and the server cpu even if using multiple cores)
is the limit. Without the memcpy waste ~46GByte/s is easily reached
and the limit is just the network link.

Maybe another solution could be having a version of
copy_to/from_iter that uses async_memcpy(), but didn't
have the time to experiment with that yet. Maybe a new flag
to preadv2/pwritev2 could control that, so that the
application can decide what's better.

But without an alternative please don't kill splice.

A lot of people are frustrated because they bought hardware
that is able to handle a lot of throughput, but
e.g. with the default of smb over tcp they get no
higher than 3.5GByte/s on a 100GBit/s link that's able
to handle ~11GBytes/s. And io_uring and splice are
a key factor to fix that.

Thanks!
metze

