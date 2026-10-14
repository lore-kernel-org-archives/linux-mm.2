Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D84CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279CE6B008C; Wed, 14 Oct 2026 06:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A506B0092; Wed, 14 Oct 2026 06:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140BF6B0095; Wed, 14 Oct 2026 06:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E950C6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:46:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9041F1C3C9D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:46:21 +0000 (UTC)
X-FDA: 85320902562.08.1EBF0FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D8F421C000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:46:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOqgqTRF;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791974779;
	b=BB+D/qHWILL5h/l+pekiDiw7FlfXBnN3/AKWo1YCJ4CKCIqClOdink61xHU11eQSKIL2q7
	7hfXXS6h2Bx2On6lXkCF0AiYgKQw31NJVs+YV+e8c7XIDt999F1msxpgymyQrEElgZAxg2
	hxhVu0B+PgvsvczR+oToRwz7qjGA1mg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOqgqTRF;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791974779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYK1qhYcVcdQcDNNIM9nzsgVfyv8Ia9LwUnyZa4iqeY=;
	b=jk1pPUViPQcOtfrU6Nj3ZtPdmxMVRmjch1tQMsMwqJuQzmpufdkl6wz2zD+mCjEruXBiCp
	yVb2RP22+hvfl/iyip0teA25RPWrY7tHR9mTRQ7Og3/WEvZovYJYRC6mgX3KMxKROsDn39
	dqJqDp1EgjAW5Z1as+Oidehj5LNpgls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABFEC60218;
	Wed, 14 Oct 2026 10:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40691F000FF;
	Wed, 14 Oct 2026 10:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791974778;
	bh=TYK1qhYcVcdQcDNNIM9nzsgVfyv8Ia9LwUnyZa4iqeY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JOqgqTRF8PjFk8EfMu0Qmi7BzkEvqxHG3gNNdLN3WURkSXE8+gKlZqK2Ou/J280fQ
	 H5yD+9OerHaEisTJR4B1e1m7ydqax/pxH6RQYNZmYbp0ptM+MzzLkbFwao21CXom1J
	 VAJOoelpGWotlIuM8x81Di0/x5ZCGCF1Jas8CA8/Gj3FmSchsMlHA0gxw44Ryb2yQ0
	 RAEH8pa5Nyi5TZOKfP2qWvbQz7WXMoqALEA3hCybP76pqKzet+ahGtdpHIWx+iBJXf
	 /o5d4wY0AIbLCctdVl/iq8hgMEbjvppgFkACtJC5lo1QXOU7J7wN/ccjvVemkh/9gy
	 piZ5nPhIKRmBQ==
Message-ID: <4c8f620c-3b98-46b8-bcd8-d73210214deb@kernel.org>
Date: Wed, 14 Oct 2026 12:46:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improve page refcount scalability
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux-MM <linux-mm@kvack.org>, "Paul E. McKenney" <paulmck@kernel.org>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as6ckC9NJVB8JBuV@casper.infradead.org> <as9af-Jd_rVZvMlC@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as9af-Jd_rVZvMlC@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4njtc43xgcpoy16d6ibtghj4f8sywmsq
X-Rspamd-Queue-Id: D8F421C000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791974779-396600
X-HE-Meta: U2FsdGVkX1+PtdtaLAlPjMPRMdewLrER/FaFum7i+kJNGxjaB71QDCgzkAdLFIOUN5nuzw1mvoAsPJGMmn1p/jqvEcSll0jViR3GIuQtmlRZYGUloDQiunKloqQ5pFfncWMw0IILLjfpk2XmpkP9DTwCNOWaSeUSyCUH6eTh5GDr6hd4Xj6LtgUbj5Y6M0Mtcyiqw684zSBZvxoIpGNMDrN9o3Ug+kUIw2xIVLUcJh8oB1VyJzkgdlMSb9IN89qLzeTMTFlpdCHvSRTc5pocUd8l6/nM8O3mN5N9xIRBHV+0ivUEcXUzgKpygulVnO37mwLacOQReXUpcV3qLwU6MbyzJx4CSe02n+AlIANrkzXP0CqDxCeBjthS6jZNooV5GjFqYiEyxFttTD+P7CoC5D01CrpRcJY8PS8TRlUzJEwenBvIRBJ/8G+A8PoJXXSEYtMVaYFzUXbJ5yW/4+BNGUoridz8dnvl8FQG6LV3sqapiwPxzmL60zwUVlH/m+J/XJAGY/2kF3g+IHn0X93MFvr9zYDuajYLVDY/2vlDpDOIuvJxutEKEBXi8cUS6+hSxqZnd7q8No/BA/v9cjyMXJj9uSoZZN9n+71d/mVfYzpGvDc6S4i6wdr6TXN1q+VXe1tX3UiNJLJzgmXLP1PRAuve2tBnNYlJJXGc4Dp83WGlDTaeeKzm43p7Z1/VMazMECcU3KX0a4ZlLlO0gsm0XtP+IC8QBIw3+ijV4ThJfm76Ue3+FaSqqkzNiTF9djgBdtCQYDkHMba/bAAF6PG0hXpRoWLr8FPrr9SYfeCO0rT0Cv7lBYgq+3AiMZ29gJZ8RB7vkTC3STmHBIM5g+yWAzeeHEkBBRQ8irjgs5kwo9ohjmbVRdlZuv+TkH3nRWRHdNnVOSDl10bENc+rxkf12IszpISS80eETE/T+KPMyfS4Dotuw9JJoND/UodIT0QfzSbR/NSwF/lVmXsf3s8
 J1UB1lNn
 5hNhA0NsKF3EUipb5cgU0Pnse3mz8Xpln0Drkpitv1tZ1uYb//rxvbX18b/MskdF8rQRHZxqCqatxmfA9IPTDYoR7wo97Xc/Wue3K3IB2OoRBBi3ANpaaTOXOVFto+HgQckameXOTxvvN2UR0KWPqOpIm5kJCfQ5Mw6/jI8moJ97N1sY+xj5oH5dlcpVmtSgMMs2mr2KNONSne0wRg2h11O0/DXdy0p6XA41ecMRr+pARmetfBAvPj6WUbx3P4KLE6eAEa+b4ZVnvdUj8LV+VhE3BJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 12:36, Kiryl Shutsemau wrote:
> On Tue, Oct 13, 2026 at 10:03:12PM +0100, Matthew Wilcox wrote:
>> On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
>>> The fairly short series of ten patches basically enhances folio lookup
>>> by noticing when folios are hot, and setting a "delay relasing this
>>> folio until after a RCU period", and then using that RCU delay it does
>>> not just the folio lookup itself under RCU (which we've done forever),
>>> but also the actual folio data accesses themselves under RCU. No
>>> refcount taking needed for the fastpath where we can just read the
>>> data from the folio entirely in an RCU-protected region when the user
>>> copy doesn't cause page faults.
>>>
>>> Unlike my original approach - because it now actually delays the
>>> freeing of the underlying folio data - there's no need for any double
>>> buffering, and a lot of the original limitations of my original patch
>>> go away too. That improves performance quite a lot. And by "quite a
>>> lot"  I mean "I see a 23x performance increase on my Ryzen
>>> threadripper". Admittedly that is a very artificial case of reading
>>> the same small part of a page over and over in a threaded loop on all
>>> CPUs, so any real life impact will be much much less.
>>>
>>> Anyway, I wasn't planning on posting the individual patches, I think
>>> we all use git by now and probably find it easier than fetching
>>> patches from the list. So it's all at
>>>
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux rcu-free-v3
>>>
>>> and the commit messages are a bit more verbose than I would have done
>>> it myself without tool use, but maybe it's better that way.
>>
>> Obviously the numbers are compelling.  And thanks to Kiryl for figuring
>> out a workload that confirmed my fears, then remedying the problem.
>>
>> I don't like the PG_rcu_free flag.
> 
> I wonder if you would be okay with a 64-bit-only flag? Those are less
> scarce. That's the direction I was looking at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/commit/?id=59b23fdc4bb0d008e2a30d24156177eeede8a577
> 
> I don't think we care about the scalability of 32-bit machines here.

I think limiting this functionality to 64bit makes a lot of sense.

-- 
Cheers,

David

