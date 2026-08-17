Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C01CAC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7C86B0168; Mon, 17 Aug 2026 18:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978316B06B2; Mon, 17 Aug 2026 18:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5F96B0896; Mon, 17 Aug 2026 18:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6875B6B0168
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:35:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1E2214083F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:35:04 +0000 (UTC)
X-FDA: 85112218128.21.8286015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 24FDC40003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:35:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sA83lo8o;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787006103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tPX9/9lA2HGpLu7Wg6cEAm7Z/kVrysXnxuagUqdMIU=;
	b=HpcIgfVi/c7mqstbP0Gq2uQVITMqFLv7Gr6pkx4lqU/NDMVyZ9HZtXFzH/SIMeCJbNYFAj
	Af2WNVRLu1wDIq2BtqmC61k6oMrcfDbaLwVscuad0p+PLxP0dRy7KZGBf47Wf1GtvuTLNv
	moVxePDvV6BGaOJXNAPTSU7yHzripGg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sA83lo8o;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787006103;
	b=tKdZ3bovAcv57+A/2tTCihMecokm7IRjPKD5o6XLB6v5mppPH0iVGsLiWg7rcXMoK8FP+V
	Dt96pH9o6+dvjcs/A42HNNjCb5wCQR1uyBeKO6JChI22tBXMRyKpVNvO3lDjJiIiLcTwS7
	YN4mb/5WG/7imy7LEzAQ0Vo28GPsU+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57DB943BC0;
	Mon, 17 Aug 2026 22:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1150D1F000E9;
	Mon, 17 Aug 2026 22:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787006102;
	bh=3tPX9/9lA2HGpLu7Wg6cEAm7Z/kVrysXnxuagUqdMIU=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=sA83lo8ok1wmkMwr/ZGIZ2goQzDlXsCzamAyzAIvL99C/9JgPHezFE7D66o/bZT2x
	 bDrZTOW0okeCLy7Oz1Rc/YwS38s+MHW24zMItGUNVTWAOWQGdgay1X67hb4ldKC93M
	 JGP5NjPB3AW1W33lmewtdx4LUpUtIGzhW8OAc3fc=
Date: Mon, 17 Aug 2026 15:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Foxie Flakey <foxieflakey@gmail.com>, rppt@kernel.org,
 peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-Id: <20260817153501.ee2ee77976e1cd5b1e1c813b@linux-foundation.org>
In-Reply-To: <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
	<20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w99ga6ocmbyot49mpicozkr7wugq5e3a
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24FDC40003
X-HE-Tag: 1787006102-112456
X-HE-Meta: U2FsdGVkX1/ecjad3MxuiXQDk/k+S+TKZM/Bdm1ZQYfDZw0X+YrG7HGa8Oo36aNhuuwp6Z2uVDuS2AYUSXubM1I44/JxA50G8mbGjmIyPxbiFDPhQf+BA7IEFTV0FzT9JN9Sf71rIhrpE7s1V4fR63MMdR3ui7GiUvm4yneaOo7Q+csuGqFQs6C82q9qPX/I1ioQxoe9gOoeqqRe6ZNeJWYQOKO5lx2mrnB5i5JHmieP+vnzzFYD8sq8cgvZSSSTgk63DH7TiRQaRi/Ke6dSAR551YaZEuwxClPINGjdHgcpcRRN6/R0qxhklvIMqp2z87Lyb9dpk4dPf2O9/f3jdRcq2TxnXNIK/HYjE6jgRe3TwNS/2dfSwPnf0pWTptJlgKBpfWfoCO2YOPJrsqPCxFLgHbXS39bV7suwTiDojDMZxUJxjIPZchER0qnX2547SKv1h2leAIPXxFFp1IM0MuYtP9Ebcl1P9bYACJUVaUVzcmt0O7+wS1Vab4GCIeCM/K19monEHQvGehhayW+IOhfqxPbNk9zwc0yMxRs8+s0RI7BrJuIcW8GIWd/dzU3QnHZKMpsPebQvJ0aLbUS2TreNAoKF146eRuul0MAsQCSqQVwmpwyHfd9uItINI9wy1udTDB2TCWL1SZE9p3p+qw0Bf38ps6F+tg1eKUDJbAExJIw4xk094S+Jd0VHvrBeG98kdd/2/E5YHT/48tFFm48jESMz2iyB+sJmtANZRC4RSKseJtAH56WA2tPcPjVJS7F4wlOT+H5rtKoa3gelJKAjmnjtcdkcM0s6VpaJ4WmU6W3IwTZNUxsAFFu+DCUlkXdvl7AydrCibyZEnssrV/TLvTnPa1MxxP0qAFVr7svo3xkc6DgQkaLk3fGQnjPWWgbtMVLDaV9sFYkf8wU0L/SuwAxhFRv8wYYBCySuwjhmW3rT8v8R+gbkgkj0U1i7Pb3Rj34n3oHIYkolnPp
 Fqiid/sB
 jXUyueBPoSztUjllun7tTuieziCPK66JUJ5lhgIvNnkPcW2VOGoBOnhytUaLTMDa/RsPp3usToZSE+4Bxn0Q7DxSQxdmAP9fqO8WcGXFZAMIs90JILi1eh9uQZTKg7EX2nWHzm6384CEiiRLzkAC+BPq3S+SUgdtgD3PfPV2VT3GAUfeU8Qc+iJT5mTR1KrMj9sw5qRTM2wMDxH5iI2V4B+HNwYI+XVRFGwsFa/e2XhkczwTQA58OJg2ISQQWyXOMHHJZHCpUay+phH4AGraeLabjLBd8ZYCJk08Yt9HwEyTQPihTjq2Y8tOhuswB1EOUTejptrj8LFp4brhLRyKrebtbRWyfQ7Te0UMk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 15:26:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > That behaviour manifested into this at userspace
> > 
> > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> >                           ^     ^
> >                           \     Kernel moved this far in actuality
> >                            What is reported to userspace on struct
> >                            uffdio_move's move field
> > 
> > When the previous behaviour is
> > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> >                                 ^
> >                                 Reported to user space via uffdio_move's
> >                                 move field

Also...

I assume the above illuminates lack of coverage in the uffd selftests. 
Is it hard to add a case to detect this?

