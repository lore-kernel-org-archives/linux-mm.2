Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7E9C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5834E6B01A2; Thu, 13 Aug 2026 02:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D446B01A6; Thu, 13 Aug 2026 02:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC176B01A7; Thu, 13 Aug 2026 02:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18B8C6B01A2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:12:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D0DF405BD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:30 +0000 (UTC)
X-FDA: 85095204180.28.38300E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 515AAC0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FCmrH71a;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786601008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ns4GoDNqcj/9AON25YCP9GahdV/I2v0GEJ5Utg1AonY=;
	b=i8NcaUqjTp4BzT2fG0/fEph+IYTmt51KXRye4HeX7Wnpi9MgXlYiBJE2iOoHiwANDpKz/+
	9AL3+eVPF1igY2Xm9uxFFoibM1D45HslkNuTyMJHsOKbI0APVp3o8C7+XJrLhggzH+IyLX
	ukjensQtd1Jkp5CSi06REtGqpC1FYuE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FCmrH71a;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786601008;
	b=stuvlJ2TexHlG722UyrpU6CcoPZAIYibIrAEmGV+SoZgIUQEMUtC4wThFQfLYh2eAs0mbQ
	7AhyElE86aWytFDdHeXqmfRUw4ihQx4bjx82olEdZXc5hdtS5O1pvVAQNSFRK5zVl4adEP
	SLnuahKo8qbzB9SypnM0hm8B8iCTjBQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27767153B;
	Wed, 12 Aug 2026 23:03:23 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B05F3F632;
	Wed, 12 Aug 2026 23:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786601007; bh=urvzQP14xjouAFJaMxm1KkmF2FK+YkPxtlg+0tmM3dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCmrH71a8GibDaT/4TzLpR5i+19TJkV8Y7yUEveP9J/tnpZ41lNWsq0jvpmBepdWh
	 3M9emmtusN3STsiD2oIUPfk8jrriw7cyAgWrBFzUsYOHmzUnSzzBNBDES9ShVkwlc0
	 +Kv5zwJCzOVfLHIcWwsl8hCWFk4UC3OStKBDaUuE=
Date: Thu, 13 Aug 2026 11:33:23 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 6/6] mm: Drop pxd_ERROR()
Message-ID: <2ys7apbnfuj3ugfoqgbptgej3jjcyfpmdgbv6qbxupmwg6mefc@h5p33ua2nzlu>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-7-anshuman.khandual@arm.com>
 <1fb9ed88-67d0-4ac1-878d-0dc8e1135d19@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fb9ed88-67d0-4ac1-878d-0dc8e1135d19@kernel.org>
X-Stat-Signature: heanafrn4htws3ak7j4m7pcd751nxc8y
X-Rspamd-Queue-Id: 515AAC0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786601008-915481
X-HE-Meta: U2FsdGVkX18geC1AYwhsdEVc4QmjaCkSl4LeHBBWcqzDohsFom+Un7tCIoRU/N7imvNRb17aY2sgVBWPLRASBlD4uSHTvcP/6tweERdIMFYyQCaspM+rh4lUUliDDsbo3l+5gBkJIAZ5cBa2kJjclBnA9eWFmuhJNAJmNAFMAgFZmCJEVAMaadmx7uFO7rFua821AYvT3cVxug1GDDIP2Mzl/rwk2YbQgrLNm8BNki47UFpw+V7QH3Aku+euLVcUT3lWjCMO8wrUAuadLYEM9V1cZg47Yv9SaVpAIFmglZF7ZrR3Pq1Wd1SQ3E5FLe9Z6IMGouruBk7DqUoxk6usrFFgJPwYZ8LaN7JpCIYgSTiK6cH9bg34g+/J0hiTiCmsImk+YJ0X2BcQ8mxa0/HHwjs1MLS5wEa/SD8X12VYymi9DZqOpDdbgN61qdVPJCpz+7qASFwiG7hbW4c1BWBQO7Lzw8HNBdg7rQZi0C4E7RH1uvjZv1l4mE4r6fL0SVP+0Sdxb4cXGgxCeK3UGk4dzPq2Bk1ytUmNmOjsNEkmfkuG8OlpT5BqmCUEkddy/qkzP78d3uunnDR+yZEgxsO/3cqCqKTxgwd45QCxclwIp4shp1z3HW2fVF1JaYyKW8PYlHH6DnuWAvj37Mlpd/q9oCJ01f/k7w2vYrY1l+42yA5Sq+CBiVAQddVoACd9xr1S922VO4ZzxoF9xe5xnYCxBLLqeWDSzhaOhm2lok2pYcEAzQ3jAAF27Cpi4QOZU9ds/G9jUdJAkBcp/EKfRKcvSbjZYGeWOzf/tSmbciU+wEO9k/cYjpm/Ziskhar59InmSErmpdeX8eHOA1VzLJCPmjkxsMWguE9YRWZCFbBiPl/8nEl0BGuSpQTkDYOrYgJqiKSWfSJtAw6eZtSoEE2M5M+ghY4YhFzdxlVBMlfcrsM4yWcUOTiTRILqCKgwxMczU1UlvWY76fFe3n79FwJ
 NcwvrlcU
 +7ShWqbD7ghHBAUyGIzfPiLa9I5Qmq9h44ktp7CBzibkAPPFuGefIBobAtxnpp8jw1F14yXiwda0fLR/fT8yVEZ6K7wUJGjSZGG8nVAkOZfAJg0absrGsuUtvOhywXTVYBphxdF3q0yqvOnFsS/AKapLnrk3Q3eN87YBSjmiM11iHRoMnwf0E5+U2HzZAJU40A2qYarwp26Eat0M3hNLlOwJA8xUO0lEeZw9Eg15QiyXJw8o2KDr6E2PIfxVES7nDFwPAUnzjHYUFBZFkJZ6tnhF/hPyQKvVv6qZ/dBfrKnO1M/9AsD8DNB9+44+k5IWZqKDWY0aoV1NPZjpbIAPIrde5njA6c6JZaF44lZhtcRXhnQb3cD9erKQJZxnD6NCRw0AeuKGzNWzjDlAULVcw0svOXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:33:14PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 06:21, Anshuman Khandual wrote:
> > pxd_ERROR() has been used in generic mm just to print the page table entry
> > in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> > pxd_ERROR() macros have been provided by all platforms which basically did
> > the same thing.
> > 
> > Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> > page table entries thus completely dropping dependency on platform provided
> > pxd_ERROR() macros which can then be dropped off. First move all required
> > helpers in core MM into a header file which could then be used else where.
> > 
> 
> It might make sense to split this patch further up to ease review:
> 
> Patch 1) provide ptval_to_str() a header.
> 
> Patch 2) Stop using pxd_ERROR() and friends in common code, converting to
> pteval_to_str()
> 
> Patch 3) Remove now unused pxd_ERROR() and friends from arch code.

Sure but the intiial platform changes which now use ptval_to_str() as well
will probably come after the Patch (2) but before the Patch (3).

> 
> ...
> > +static inline void
> > +ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> > +{
> > +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> > +		snprintf(buf, buf_size, "overflow");
> > +		return;
> > +	}
> > +
> > +	switch (entry_size) {
> > +	case sizeof(u32):
> > +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> > +		break;
> > +	case sizeof(u64):
> > +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> > +		break;
> > +#if defined(__SIZEOF_INT128__)
> > +	case sizeof(u128):
> > +		snprintf(buf, buf_size, "%016llx%016llx",
> > +			 (unsigned long long)(*(const u128 *)entry >> 64),
> > +			 (unsigned long long)*(const u128 *)entry);
> > +		break;
> > +#endif
> > +	default:
> > +		snprintf(buf, buf_size, "unsupported");
> > +		break;
> > +	}
> > +}
> 
> Why not leave ptval_bytes_to_hex_str() in the C file for less churn for now?

Agreed - will change.

> 
> -- 
> Cheers,
> 
> David

Thanks for the review.

