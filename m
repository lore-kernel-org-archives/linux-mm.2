Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E4B606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQyowssI
Received: by kanga.kvack.org (Postfix)
	id D2CF26B05B2; Wed, 11 Nov 2026 16:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD606B05B4; Wed, 11 Nov 2026 16:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA57A6B05B5; Wed, 11 Nov 2026 16:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0096B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:35:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A3FEA0437
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:35:46 +0000 (UTC)
X-FDA: 85424145492.05.E3B9344
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 60151C000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:35:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQyowssI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794432944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiLrJsK0i/ckXgWaDlbef6TGeEOzJ1BPFASM5Mf1Dm0=;
	b=UjENzq6ZyJ7m+DIRIzeTWi5HkYSjK/q08a1dr0GHiA7IspV+wA+/qcrFQsGn0b5kN2j7pu
	MuTnvjYmCvpuXbHvcRfG1138JuDnQqe3dbFfdNZKmvAliORYpqJ3D2RGtXFCsolRkgaTQd
	5ciVgSyjAM3jyvQKu9agdsoU3eu/uk0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794432944;
	b=JcLMIuFN2O6fsbWc3mwaLoATq1/asY3bcx3aTulRk7ijzlAHSS4pNzX+SspHHmpFxmA3MJ
	fpISJzo1eak/D5oppaca+MgY2yao6H+gQf9WktGTvfb2k4T9r0IuAu+6Ys7WJKuBiBlmvI
	XBtyZcWL8S/AgwvHDEPnn745tqFJ4Bc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQyowssI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A1AF600B1;
	Wed, 11 Nov 2026 21:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5761F00A05;
	Wed, 11 Nov 2026 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794432943;
	bh=GiLrJsK0i/ckXgWaDlbef6TGeEOzJ1BPFASM5Mf1Dm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TQyowssIWW+ldhbXHt3ypnihvJY5A2V8A1ANyggKEptG/EKnniGrg0vMcNbDWRxpM
	 i/K1Jqbjg0PKNkaMzI9cYXiqL60QROS9FkYFDVY/AOGa7uqFqrQi05tzQDAh5By8V1
	 fvr3qr2TkFfEx6gIKUJbXu7bXksFRI11IHQgncEMfvVgMck+Me5vklonxrkX3WqKDx
	 IibRBU/J5lj9H63TRIzC/wPCdGWNFLgCEGIjDN6zFndiUvXRA4DltB5+eQ1RfClMiT
	 45GyZ85VVFDJeQ9h+N02CT2I1yfVLT59Ohc0PNkK/j5NInFd0ple3lV86gx7130wWi
	 CpzhVNiOBej3A==
Message-ID: <72f286d5-3f1d-4350-b463-09f7b320cacf@kernel.org>
Date: Wed, 11 Nov 2026 22:35:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
 n3rd <18670333770@163.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "ljs@kernel.org" <ljs@kernel.org>, "ziy@nvidia.com" <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>,
 "security@kernel.org" <security@kernel.org>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
 <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
 <avS5QcRj85yAm9ll@thinkstation>
 <71e24630-4c71-4518-a9b7-68cf3597ce80@kernel.org>
 <CAHk-=wh=cVrn+xs3fZiPW=kJbFQLwf_C+c-YBCR2K9s9aNE_1Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wh=cVrn+xs3fZiPW=kJbFQLwf_C+c-YBCR2K9s9aNE_1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: edaonoa8edjkk7apj8hu8fat9m39az83
X-Rspamd-Queue-Id: 60151C000C
X-Rspam-User: 
X-HE-Tag: 1794432944-212630
X-HE-Meta: U2FsdGVkX1/2ES63e4FEyW4UWmwFuvlEufZ33fnqdfxDF+jvcgjP6yQrAPzY2oJMP0LU3cAuANJe5gVejjy4K7pq1Xsr9YrpcxPQgEuzNFlP9ID+3JizRt+2PIHKosc8Zi5wcIlxLE7Hf98hM0Mrpfp6ueSMTN+Q1kqOhHrO5G3TJDAKSVtfCcbZIabkxS+OccDldiPph7mtR4IjjM9iqvll4mml/Ry7ZmdO860ZDsiblaxGFTw1wxZZ22JPWJigmOQFC0jgCjT0OV2DsDhtOHpZtAPnjRs0ybV9YuxUt/07TKyp3p9lpaWRer+sCOhZwqma54qlb1YX5ExAEyZXlMLn5M29lIi05OFxAlWYCO/MG229Eg35uerxj9ByJlrkQpF84UWh005RzrXoAWYslfDzZaEFdG/YYwPaVqG0To+PM4IcVdEU9oBOJCvAz0R9uxXwSsMZKBepQrI39u71q1JmBlfNWSsPwV0rnIN21XddsGYk7rjFi56QmAlsZ47A+w9OxMtE1A4NUnlicASh6Us5BKsgBGfD3qQtp4QWr8Qd+m+P1+jxqLvkyPtYZKh/Wb+yIXBHzU0SRrBe35OvGclNl4xD7uydcK8ffOqP9+CzahIVe8s6TeUYP6wm2nhW3iO+x+WrD4L4LJYWy3NVzyS3IIT5uZGO/MiM8k1+UJqO8JFkx+shkBlHKfPNxlz2E098xXWb2tQdB3IzXq3ywERpba7PSIPhMYXcR6FJOp++1RI3tlNHJZ9V+d1U1UXEtGu3prtdKbxdhzDZXAL5gtvIqp+8Q/ZPHyxb8WtowWmPweMzb0cNVXm+qe047mUa99xeozGNIfN2B+II2+IxEOOVZPlZGn6hcHbvmQgxe/Y2AQoY9RhGdkF+0aeu2/fdi8uGQT0J3lYARWxxX48k9Vn2bYDy+mEc3KkIkPk4VYaEZm1tURRHQf1rTzsP3HQBYhH1QNeTltXHjpMn2Pu
 WVFM/eQf
 Un0yP1HckQkErWOMpdaNIthiP73YcKLExRQt5h/yCrtPzCGkzpMYKCijsuSTEWgrTS+ZprQIsb4NjE3qMO7V1SG7QLiLLJkdtP2VYL/D5IoJWEIdFBkKATnpiMsqvalV/XCX2tQDOrj1B13Gw4/SAXx7d5C2+hl1VdyRVXSq+lFv/5YIWa5vnNxPaanBvI9BWhJ4lg774FWpuHOvbP1ShdVJMDp08a187Hv0NLxe0tQzN+CsOOTTcNvtyZDBDBuHj9l21o89cj+dlz88oDeqyPUNABJQ7Dff4HUWwBeA01YdTsVasjoB/NQn93eFDtXjvtarUdfznAjWlQiUs0GyPUtoMPqiYLNsG/BNI1wff06ZJEoFlKFl/WIqW+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 21:55, Linus Torvalds wrote:
> On Wed, 11 Nov 2026 at 12:20, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> It would be a lot more consistent if we'd just add marker support. Or is there a
>> good reason why that is explicitly not wanted?
> 
> Let's not help people do things that won't work on older kernels for
> no real gain.

Uffd folks usually indicate such things through new uffd features.

> 
> Is there an actual real-life user that would care and be enormously
> helped by such a thing and it would increase performance or something?
> That sounds very unlikely, since presumably re-faulting never happens
> in practice, so just tracking it in user space is "free".
> 
> In the absence of some real load with a real argument for it, please
> let's just document existing behavior to the fact that you need to
> simply see the re-faulting of these things..
Just to express why I would even dare proposing to implement something in
userfaultfd: in Kiryl's series we abstracted the uffd-wp PTE bit to a uffd PTE
bit, which made things more generic.

Abstracting uffd-wp markers to uffd markers would similarly make things more
generic.

A quick codex prompt tells me: 90 insertions, 95 deletions.

But most changes are documentation either way, so that doesn't reflect reality.

Now let's ignore what I wrote above, I just polished another uffd fix and most
fixes I looked at throughout the last days were uffd related, which is starting
to get annoying.

So yes, no new uffd features.

-- 
Cheers,

David

