Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640A1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F5C6B00A3; Tue, 30 Jun 2026 01:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6EA6B00A4; Tue, 30 Jun 2026 01:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115B56B00A6; Tue, 30 Jun 2026 01:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C25586B00A3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:38:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 244C21C6BE9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:38:51 +0000 (UTC)
X-FDA: 84935474862.28.B7453FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 65DFF40006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:38:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R86JUREA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782797929;
	b=kzGGbpi3CXpuIlz4SVDChNSpZeEvi9snN+wKaKO8wTOfZQkc9I0UkPrAfsXh9ca/k2N8lO
	VnsNqIGJS1+19t8QTyn0tCk8w5YPhMoeWmTfke1f4GQImIcCSUWPK7h/P5T3qL6aNmABhW
	bASYHcbkXn7YP6bzwgFzoI1VrAx0I6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782797929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wPcm/Xetdm2u1ZsAsdit/mG1QKFMGsSy/lP1k1Fymo=;
	b=MT89gbulWDwC1GE0zPuOvswRk3u8jgt2y4BUnIna5K3drboum+6auwnO4MbnWntc94hskn
	MaKc8WYFS/fsJBas/T6Rx/sePVAhsjIcK+M1BAZ0wtNltRtr4s+q23SGD1uIQXoNiGDrig
	a8q8Z6wsiEak6lQgTjNfP6jdkZttIxA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R86JUREA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BEFB4600BB;
	Tue, 30 Jun 2026 05:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2506F1F000E9;
	Tue, 30 Jun 2026 05:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782797928;
	bh=7wPcm/Xetdm2u1ZsAsdit/mG1QKFMGsSy/lP1k1Fymo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R86JUREAVLX4ULzfoTYjiYDdOZfMIayeZs90it0vFa8kQ64Ls1ie0TAwLP5123vs5
	 g5KD2E6E0wFmYPJtTnTOyxnxHreqJ27IsO+hMszlJeDAub0hlgwa+XlwwpZdhSmt53
	 b7x28y/AtxeJcNKfWqeNaANQEuaPFV6o4UcdLxzENTDDklldkr17moKQlRn3dChK2L
	 F9oIJ/pg1wmOxRdmoDuajZiM/ZobAH01ip04NmGhPqS8A/47CCBKyRGhYamu4hbLV1
	 Dffj+dDIJCjY0SqHA8fllTtPrfen7PiIkCqW/+WEZmPzykGGPKdTYWCIGcOahHhWJm
	 ym3B6eh7F3GxA==
Message-ID: <0c386af6-353c-4f76-9f28-bd1a77dababe@kernel.org>
Date: Tue, 30 Jun 2026 07:38:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
To: Barry Song <baohua@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
 linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org,
 jp.kobryn@linux.dev, kasong@tencent.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 nphamcs@gmail.com, rppt@kernel.org, shikemeng@huaweicloud.com,
 surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org,
 youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
 <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
 <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org>
 <aj83c5ix_YCFMU-M@linux.dev>
 <CAGsJ_4xbYOVvonZg6d8eeuKcY9SUic3zXLbWUvxJrbf=U9sQnw@mail.gmail.com>
 <3903def5-e823-4fe3-9784-b6bd63470516@kernel.org>
 <CAGsJ_4yRKAhRqtC=ieGV=gQ0-x2aYPDV6QW8_akkGiJsmxkbfg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4yRKAhRqtC=ieGV=gQ0-x2aYPDV6QW8_akkGiJsmxkbfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65DFF40006
X-Rspam-User: 
X-Stat-Signature: dxgp1txwpifdbj5bfyo88ncr45m3jco8
X-HE-Tag: 1782797929-413639
X-HE-Meta: U2FsdGVkX1+XWutglrK/ETCWWT1PZj7o7m4KPvAKW8vzpxgHNMajRnXV9QcZkAPOhBzB8qlVCr/oIvV6cqkz1ChYz6Ksfg1OE744ZN8NqDF3wXGC6vMtOHOnW0TSbiC770iA/Y7okNcSjmQY8BCkgkOF2XhMuZL1DFwbLGBbDA01eh+3zRHh+2GYs1OJil07Pt9W8j45Uu5n+q/Xz7/IoQflZ+3bc4eS6QUUZOEYR5SXMtFAzA2A7KTR4CEHrOW452q2c+AHgnVkVTfEsoZgFb1wk0bwvWe8Lp+8OHx30YDjOgcwJtTuz3xVufHIWHrBQBMkb1rAVqW/uCCpzODVecFKrOVlh4C3p+juSD6QEi//41//uYS92Ehb0xpFaxwm1kkSbmdkNfEv7jhwqFUGXMk2uSbVneMYY4u0+k0fcAK/55eNHsaxE7pBArIN5GGD8vOh9VCav9Kpdf3RWc/8SQR/0P29HEVlAL+oGz3hYX+PzuXA+WopJmBYkpTvAaQvNrTDJqwJ31sg2KX+9nG4xsG4eUXLCl6XmSnR/kZywWYbhTv0rID511vbcm8x84FYE8BDkH2zaE6zrEnpu+vuJcAYyVVVVtd/NGMFQmc2FwE5rcAE+kvkd4j9BJ7Y5Y4QrOD59860vhhtY5vzs8zGBVuDLmO4MKS4xA44eplfyE3pABsknzpbGRFTAeZ4P4dFDfNvt0reFVn70JkUwKAlv9JCGLZAD8RXAzPntrP5yMpZchGpfxgv3RBx3Q9y8VCMp8+WR9aENU/RTlF/iMIuO9V0OZrb2+8xUpwCuupsg58KQlOXhdpT6RNc7u9HSLUS2KM8emiZjErSCH1FfFH4veoBgxcr15uSrEmJvmbxp7StUHHPAP0Ycr1IN3j24SSKVwXDgZweCMHhF4V0RxQ261/h+n1X3gFyPIrTS9q1cfoYUuJdGpdG7UAE72Z8SVGC1DG0J6ySvka2o8Jus9y
 6tbbPkoo
 xW0yQf+Na8fBmudnzpgRddeqNQRdxEy8Y8NVO/JDOsxPlGZ1/l5sILMgIFNvF1CsWj3veNJdT/owcA/XP8hAykvCmgBcRpqj5WOBqIb6kvpBqr3I+CmQPhOp/ryM0R0W22lYNUQWH9TIk2NFYFRFfrsUah0/x+DMh8KwuVQ99w4ode7hzN83I5iwuz2AWXJv6py5xONjnyWcZnCzOAaZ/KDPHvMHfprJcdoFRF7rBXWN4gSGGo8Ns67lwrgNKA49J0yqweQ5x2JOxv3nn4+89ai8aMXDH4quns+jMoWfooSc2PkIqRUxemYr9SG0pXbNepLdPgBd03kEpqg6VM0aSh6gQR3tmfx6N5uwglFBdS5QCnRIf8JPu6/9Myk2FDc/QeLA8zyYaM/ZMCLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 01:16, Barry Song wrote:
> On Mon, Jun 29, 2026 at 3:52 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> [...]
>>
>> So yeah, if Nadav's reproducer works even without the drain (which I assume), we
>> could indeed think about just removing this optimization here.
> 
> Yet I think the problem is resolved with the exclusive flag.
> Right now, we can still have cases where "exclusive" cannot
> address it, such as:
> 
> #include <sys/mman.h>
> 
> int main(int argc, char *argv[])
> {
>     int i;
>     #define SIZE 30*1024*1024
>     while(1) {
>         volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         volatile int q;
> 
>         for (int i = 0; i < SIZE/sizeof(int); i++)
>               p[i] =  i;
>         madvise((void *)p, SIZE, MADV_PAGEOUT);
>         if (!fork())
>              _exit(0);
>         for (int i = 0; i < SIZE/sizeof(int); i++)
>               q = p[i];
>         for (int i = 0; i < SIZE/sizeof(int); i++)
>               p[i] =  i;
>         munmap(p, SIZE);
>     }
>     return 0;
> }
> 
> I assume this is less frequent and less of a concern?

It's unlikely to matter in practice I guess.

-- 
Cheers,

David

