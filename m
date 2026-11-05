Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA8D606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qd9Vkxqg
Received: by kanga.kvack.org (Postfix)
	id 9F0EB6B05B0; Thu,  5 Nov 2026 10:11:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C87C6B05B1; Thu,  5 Nov 2026 10:11:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6546B05B4; Thu,  5 Nov 2026 10:11:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73C9C6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:11:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E67980A76
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:11:56 +0000 (UTC)
X-FDA: 85401405432.13.7CE548E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A9894000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:11:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qd9Vkxqg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793891514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tw/aNcFF0dA5DXgMzixhUalk85FG8CPwafC6ZxgRlG8=;
	b=06a4n6F15MARVUdlLsy6YRLec3HSKQHsNJqiga4hEzj/cMJGVVODI/X0acYD7h5O3aAr7R
	DowALHPkUZTrEu1FzO6zYLyUFJWa0HiqUr0JW9QiJ20E/CdvPV42Tyuorj8l21XVj9xSmM
	7pzabvvY+HW0qiyRfKQOZc64lBoLrRc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qd9Vkxqg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793891514;
	b=W7loGNRd47B8e4VnIvY+r8ACJqOKJCEXjQDEmpkrV+VtCjKZfWUBbfPu1G0+vIZqe3kcqC
	wPXdoNVRfRQGJTEZmuTiZYQFcefgqvF4bhj8oGzg7PXo1ALhUc1fpXxi1BRaOmUKjxSAFk
	vLe0ESMi57WplKJa2mo/6VciHFqcU0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B7E43F5E;
	Thu,  5 Nov 2026 15:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D614D1F0093A;
	Thu,  5 Nov 2026 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793891513;
	bh=tw/aNcFF0dA5DXgMzixhUalk85FG8CPwafC6ZxgRlG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qd9VkxqgoS2SgytT0/JM5Az+BJpOIe/NbVuV3M42bSJyVnkO7KtGDSnJydkMmpU7w
	 NoTxgHrkxgLBZaullXIZcKz00lnrlHr5ZoCAqUJCzrwKim12vEBPjFvSLWk29JSodD
	 mqsBGAlz8cr1hZCMoV3VlO9m4YufCNp3GZqa4H/SCIdOKPYXxll5tRV6/REZIdT8AO
	 LDtms19QrsTDYkb+vOcKq4YHfBsmiaMjAnnckx/e3e+1dH5Mcz1f+zttej3zmoR2ZT
	 OxdfoaLuosWZ1yIrTlPpL3ycmx/R5VZKkv+A9FcTYil+J9kTJfariwsn6fAEbO+SqG
	 BUOHSIUgqSVOQ==
Date: Thu, 5 Nov 2026 15:11:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>, 
	linux-mm@kvack.org, Bert Karwatzki <spasswolf@web.de>, 
	Jiri Olsa <olsajiri@gmail.com>, Kees Cook <kees@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>
Subject: Re: MAP_FIXED leaving holes on failure is very difficult to recover
 from and can even be a security hole
Message-ID: <auyXeApQlV_CMQDm@gremlin>
References: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A9894000C
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: wboomebteny5q19ifat5w5eaxc5aq4za
X-HE-Tag: 1793891514-592877
X-HE-Meta: U2FsdGVkX1+xNB/7X7vww2eeOoiGuCkNryhewPLhNAO7nTRvSI/0zDFw7qQ2dRjQrdlWxwtB3zY582izcL2XD7FsJCsAiHjk53fFAw5DVHreMhPMMIcaDTTt0yhNofwiR+SsomxAW9B02apT8q93DXs4/ETlTciO6kb0XyICdno2rR0YxVe9o4YJNKQg3MG0zdF2+TU2EAC/2vY71aKzJrHF2QUf4ptvJ5vCDcWX71EssLHMemphpd6KsaVYtOLGEyULAm5J137OFHY7OwDdzvPqZuZuN/XD96w6oi6Gou2pRWZPOWKFzOoSb6j/f/tzQ5NkYj+MEUvZT3dMed1wz+yFjHZqZqGyk9Co8KyrERtadcJGdSSwzFwen4e15bALyGQ0+8s8KFY0cl4mHkZaXg+AAfzJDgPwgqwD5jTiQCvQ/KDT4UyA/2GIQCnpeAb/G/83DzQcd7ZvVucrJPhvNzqlgmZzB1EJ8ewHwCZ2Ftm4r9Kd98koJFrpA6f9rm9QWl0jMtA+zVF+Uf8mNaHtxicgnQArpLgBPEvZkZYCg7KIpinXzwwhGYJbk43uWhkiWtNMwLWbrXrvMYIPGA1ex1v72vRXdK/sLKsi8q+iUQf7Xv0kOuyp+Bz88CG3eEVUrZkN3ClBkaRvjoQKRAIEkXaPiw5ZEsfRATu7+CAqqBKgwHxvp0sFVRt5DR6Y/bucTNHPhUyHXQTeETSrbegGD7cmrvAvCBV6lxIfu3W90VX2dIYQBjGy6MLADssa0vx8UAwvzIDGUeKR0izgPSYHxNdQxJPj+M2u7fGqioUisd1YT0Vn9YDR3Y6bU228ZUrbMI7kY5Lm5ASTsqEByB0lTBH5xyWvoNxidoeqKvPyv7wB8xD3ZZvX0pe+cCKN9Sfo3ft26u0giUpipkOAQKYV+Ai8xGUJdPzX3ugV8TEg+JmuL/H6n3dikTTHOpZgJyCfXxlg+ddt5zy57ZAZEmq
 FruVLmmk
 im/QETfO+OmoQyQ6Wjt7KtSmGGC99zfaO4qmBeHQq6f3hpejSlkAnU0R9RjDDkkuu5k33VGVrAZr3RGEeR/Oexwc1DpG/6wTXFfJPDlTf6uMARcZUbOqbJCbBxJA9DloVm8R70hbGHhKGnFMyykkuiI1Vr7S+srVFZM5K/zjtT4YsK1N44VDQOEDv+JA/HzyzWMTvS7G7sTu/x+XLwNPX4WMiiiKoExf2X3Z0FN9pQ2aBZtGtlqjnFKTqINQ/2OO9L9oDgrVLeoX0RNSxjoDxuhRIP2s5QUXZH79B00bOEG7oWyXsS/7koG6PzlIhW7PzZ9TFkaJBn4hYgOzaNRG4R+zNV8qq37EAZZ0VrERqAeiGjB14A/6K8IsWpTptx2PPu+Vo34vX7naaKoMpfFXcfYTB5VCVsd1tAKC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[ please check kernel mails in MAINTAINERS - my and Liam's at least were
  incorrect, which makes it easy to miss. Fixed those up. ]

Thanks for the report.

In general linux system calls do not guarantee compound operation
atomicity, and any assumption based on that is incorrect. If you see an
error - the operation failed, perhaps partially.

Further, a failed MAP_FIXED leaving gaps was the case for most of the
history of linux. Avoiding that is infeasible.

I advise you to review the NOTES section
https://man7.org/linux/man-pages/man2/mmap.2.html on MAP_FIXED - your
suggested use of it is not recommended.

--
Cheers, Lorenzo

