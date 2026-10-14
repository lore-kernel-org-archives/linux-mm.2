Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17AE5CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 00:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061C06B008A; Tue, 13 Oct 2026 20:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012666B008C; Tue, 13 Oct 2026 20:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D896B0092; Tue, 13 Oct 2026 20:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4ED16B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:10:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A550A02EF
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:10:22 +0000 (UTC)
X-FDA: 85319299884.19.2DDB455
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F96A140006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:10:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZP4EfKUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791936620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+tM5slpbKPsasUGwVhQ3lezL7cs5zFWMkBfCs77HNY=;
	b=3W1/2XlwkU6q8166jILfCTYJO4YSYYyeOquo3ol/xLbvLU0P/a4lulTlHeHn1yU+Zq2cDL
	KtpNRVX2cKSyOYt/+wO2oTVWlMmJ/PIbdBM6j/igrO1TsOzlpeGVLB2vK1NahyLkfOS9dA
	Umdkj6hcvvE7EXv4aM3e8rWcFLjnIoA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZP4EfKUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791936620;
	b=Qn5wojCDjfz7r7Ja3QroL0cW3JH0JYXW6NxbbPXuAVKM+CgDIWtl5yw4HkSCv2rSzHq6NP
	TnTG87670CMYawn8vBNUVlZH/ULWolJcGNSnuwWL9a6lhWZgzeaZvXxAWiyLBGUfSHWk7a
	WRY2YnkxOLbEkWxcrNogNWTE6bN7i+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23DA3600CB;
	Wed, 14 Oct 2026 00:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4671F000FF;
	Wed, 14 Oct 2026 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791936618;
	bh=z+tM5slpbKPsasUGwVhQ3lezL7cs5zFWMkBfCs77HNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZP4EfKUWSo+CgEYy4ewm1ypXx/l+9znvTg4BHHGn7q8r8Q7V/I2gBPqDGTmQarC7s
	 ErbW6C+m49aS0vmqB6hMwXDg70DwO3OfXF+ksuDjtR4HV81JziGJZtdvF04yCWz5LV
	 96FaBumLAn7UznlS1p62J/Cz4MqFjhZy+17amrta8Cm2B0/qIsEk94MInYyTqOQUEJ
	 4AxNaTWH6kTOkasF7ct1l9rkDYVV9Wdsy0KoVLgt7QgUdGUHe5MAFeKuHIAAgpp4hw
	 V8fH5Ls/YK8CM2NOe7RrCpVS9/ZqObSSZJcOed6JzgpSWekmwu810j34YTZn6FNN4a
	 nDM4pDvr5B4FA==
Date: Wed, 14 Oct 2026 01:10:16 +0100
From: Harry Yoo <harry@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Kiryl Shutsemau <kirill@shutemov.name>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: Improve page refcount scalability
Message-ID: <as690Xcu7FxIDYjf@thinkpad>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
X-Rspamd-Queue-Id: 8F96A140006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: rcsj537j4kxnayh9wgx9adddhyodj3s6
X-HE-Tag: 1791936620-836575
X-HE-Meta: U2FsdGVkX19fvewK1O96Oy6KNiWKRNgSul2m41aN0zmWRwvgahM+EVqMfyQmnZSz1HVJw4yCKqattRf/eBOtLOsjwDMYh5W4XzVfxAp07GpHkT60/g2q216qL/s46vuXKSj0CWtMWy63TgUUCvwk/d8tT2ZGoLuJdkL6GAGLQzqOjRPoaK1U0p7K12w01wTErLbaEPjvxlgX4OFmL+JEgKpTxlYWyt9wFuhJwiyXXgZivVweQleUxeM7Qc5lHGGCGlXcM1I8BqfwwI8XS5+/EgrwD8UYVWxZrTPFVBw6ltHREuJtIoemi0023AuZv+DaRKhMBKSJA+VX7/i/725uIvUjKWgXyPT+MycWppDmE8ew7M+BwfxUGa+ePKNgfuZpqrcXWCacmPstOdxP6grtWJd2pSxFqDX80PRwKq4O/XvE+FWV/bmPRB9MeN4ryKIJBcfO3IVrKsa+93TvF3/gawPb/sDcCwNt0xQOZGlFNhzv2O5lPwy3bwDyqfV8fHdKSpKeFHq0leEj7kmAszHyFI+zhOfn+pVoiN4W44mgVTiX8Qg3hRoSr5cL44jxQSQ8hMOc3YBeSvvf3/458AubysR8cyV/0sK+iBuR4PkqSxBD9fUDlTjMIpkqttz+k4okD3LWJ+fsFrm4zqrJFDdmVVEFFwXqFMDc7/71RCJYNljG1zwVPxV8gtoY1vcMrLNLpdA9meaPvkrAnvjuumQkzhnHjk2CqLBXUOMwxo8dqgAa+Y3JXZkhno4EW0b28NGuHnyo4I1wyiai2lEvJ8djjkOF04cJS+b1sGiR0xdFKM2hEodSlb5Co12j7kdJn+ja5djBH3z5zWZBGD/WruDuZfYNxgGq5DdPVXAC3E/TmPTTjlThuyk2aZ6+4DLS2Du95TNI55J9/gE0Muwi8+aFMj4XPWs7K1F/Ba68XNfCdklVwKDjiedmlf3VW/ZBZ5EIIVGh/wEdtJvSrx5BAEz
 tcBG4J5p
 bGTL3ZRt0IQfpWj9yLCDZ9n/t6zmGpxXkFfv8Fc9i4JGL5waqZ376lJZBIF9fv2j8Sb/zTEGTQt5B2NkKGx6Ibbq72DFt+A/Wz3TG/Y/eRQs460Ad/MQ8QMwZgaRb0Dd7cTSwOf8pP9G0UyU8NzWg0VjAHriBrtOHIHyY8BlZcO27z90/aQN7apMEAZhUrDI+EL2iSKMr5PVxVJ5UQGACy0h0yvsCFXpER/qGNx9Z6lAeOo4nC1dSeVoXsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
> Comments?

There should be a limitation on how much memory can be submitted to RCU
by the page cache, otherwise will be a corner case where we have too
much unreclaimable memory waiting for the RCU subsystem to free them.

There's a similar feature, dirty throttling: when a process dirties
memory in page cache much faster than the storage can handle IO,
the kernel throttles it, otherwise it'll allow generating unbounded
amount of unreclaimable memory.

For the same reason, when a process tries to create RCU-delay-freed
pages much faster than RCU can free memory, the kernel needs to limit
that.

-- 
Cheers,e
Harry / Hyeonggon

