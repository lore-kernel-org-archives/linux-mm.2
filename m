Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D3ACCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 23:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987E18E0003; Tue,  4 Nov 2025 18:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938CE8E0002; Tue,  4 Nov 2025 18:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876698E0003; Tue,  4 Nov 2025 18:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74A518E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 18:54:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 075D588BA4
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:54:14 +0000 (UTC)
X-FDA: 84074580870.09.F0ABD84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 337F0160004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:54:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RYbXhYat;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762300453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwuc1y0OPc4RRPRt754fYcPZAFfr+KoFsinh8pft19Q=;
	b=TbR7dXzX/GymcRfylATvcjprR3G6tWxjen7aTFPF1JYwruyfF9UgPjAF9ecwnJr3gbpYfe
	Qw2ilsSp0a8XuBCcvdiTdO3Hd/aAmZcqnPDfcJH3ZoD6p5vKhs+E72Va09TUQXoMNGzbor
	2ln77/ImErZBaFnNkZ5HJiSOF3XFlKo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RYbXhYat;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762300453; a=rsa-sha256;
	cv=none;
	b=JDvxkpT2anLxSoDsHiyhdMRlWxnyNyXDTa5vkcV5C6Ankr9wB0UeddBNOJ2czeV+uxK2QN
	dBoH9WB+Uth/8tsIqTtdieNSA6UgG6MAXKNgc0PYboQjBVu8WdlHQV5twelSnwuJdQndF2
	eQE4kUjUXvRWYIywY5IViS9pR43r7iw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 054BC40813;
	Tue,  4 Nov 2025 23:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA070C4CEF8;
	Tue,  4 Nov 2025 23:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762300451;
	bh=h1mJHUEMMu+Mg5BL63eKMqT17Qr/sGrDoUVMa+6rcbQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RYbXhYataf5TgADzE6aadgbMz0TJb9bjEbRi33FOl0bTfA+k76mXrW5WFw+Vu/qFE
	 lhVUbZfcD25jWdsWejm1YyJPzNqeBpmm5tJlMLmyJ49I+WD0BuNQ1vbHmkvoIId6Fe
	 tuCFq2rGA9lt8ctacb7rJJn1EhsWGv5F4MeKJTo4=
Date: Tue, 4 Nov 2025 15:54:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>
Subject: Re: [linux-next:master 4972/5926]
 kernel/kexec_handover_debug.c:16:18: error: use of undeclared identifier
 'kho_scratch_cnt'
Message-Id: <20251104155411.64385f0726ec775d9f31f61c@linux-foundation.org>
In-Reply-To: <CA+CK2bBJRXX5u9sCkG+WKW_OK1biyBUfdcJ73yuUdeNv6QevbQ@mail.gmail.com>
References: <202511042251.paO6f5BZ-lkp@intel.com>
	<aQod7jDFBjw9T-u2@kernel.org>
	<CA+CK2bBYF5AndNHgqcb5zDbUOV04nE6xiZ0igcTdYf-GOU4aOQ@mail.gmail.com>
	<CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com>
	<20251104141501.48a1f76a3f83967f08d00097@linux-foundation.org>
	<CA+CK2bBJRXX5u9sCkG+WKW_OK1biyBUfdcJ73yuUdeNv6QevbQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 337F0160004
X-Stat-Signature: ary45qsos4dis9ctqdebue3z8n61qifa
X-Rspam-User: 
X-HE-Tag: 1762300453-721396
X-HE-Meta: U2FsdGVkX18VumMlRc57LIB9xqkOOQk4EHGD/Tf9hbGS0SThIb2RGiaXh4b2n/I3pdbnySdMQmUY3TGi1y5PYnd4AZ904F25EVZebmWIg6FKC34Xfi91jMXJqV8bW67Gxukx+fH4C7HZOaQ77Dnvk1YYnSQni+PN4UX6T5+XXuBeexoutDrCIiqHoaNWjbmn/Yv7MRFWa32AYs0e+2Kp0emmkYEE5+VY9Lff5xTBdB3jGuTq0D7kRkrbUdxCQdVNShK3PlbnDL6YD1CE62NmQAcil1+obMr9iPBP4VvyIeDQgKp87V/gRej6kndiKZeYT80cPkQy0r/JdN4FryYiYDw9GD0JtlmcWmI9UXL5MuSJAE7x5E0669vrtdHCCKjt4XLDXId4RtmT00X1xe5BJ+KABm+6XyTkgWse5BKjOIjY7lc4l5v3gsTVCPf9XGFUJat8mGyhkf7r/Yv2Zk7kxw3hm6MuGqXCaZtXkfMMiZR+VEbiwL2yKS/Cg+OkbLxtX0mc2RIt5+CgcTmNEvhwLjktTnOFbrRkIHPiNT9Tzqa3Wz9N5KVNrcIfZqjmK/T3AxSAl//EWAlhW/vzcx7mhyK5/qv4OVv27UsUM2dxW4L4rca3tJUMOfuwR5EzIJOIzo6JmJprKy2N8BlnPPVtsTxxW3jxTX74eeCmNbz3j4rh7MrPk1Zr/UXRGeXMA8A0F3xkfeCik7+rWvxVeYIUNxJA8iyKKZXe8unSClAWUewQYwC/iRHg0/dIM0FQc3z6+FbASeGjND8rH4o46OFBlbpvIbjWFCuwPyZihl9QYib+JHQ29Qu/KcEUz5uWYyyI7m8d/VQ88YhEV4aPp84AQpqnEPs95znSF0bFYWY6kMIb7wkM2D7ckulImo+9wlTFcGCBK55LYi0rhB+n2f1Kn93c/RyZ9UwTf5vl+N6EbviNgeS9hb9To7HvTN4I/kVbsSf88jbUgQys+/qpzyX
 zeTKbeb+
 FmOEd92MKZ3F3vOwQiriKRZHeWG5jpPqcfeFWf1L9/pdOxUqPd2CxC0Wk0HXtCbTLVFQJwn58ilWTHgeZxA4dDynjgKK0Ngzj6YpovCF340sVsvzlGzM7eQQHSKxijpMSAlWOHf0I3WoIz3EWqjvqBFF6PZab0/PJy7B930ECbX+6xebFurtsb87ztPv4RcdaUrZ4NiHYzoYKJOLfu8ZuRhcAGJoH4DZZJtE6/uts/HOC8wrJI2VPqizL6ZuDNl+HS5aq2oSegGe8D41O+7pIx8LJcNp0ZEOlsV63fxj7ZeXg7h4w0rdh4XFAGQdtLJtA/xLKIe69WXt4wbuyIK4zLtrTQaH/1I1PDmjO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Nov 2025 18:12:24 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > > -static struct kho_scratch *kho_scratch;
> > > -static unsigned int kho_scratch_cnt;
> > > +struct kho_scratch *kho_scratch;
> > > +unsigned int kho_scratch_cnt;
> >
> > This patch is making changes which are already present.
> >
> > > --- a/kernel/kexec_handover_internal.h
> > > +++ b/kernel/kexec_handover_internal.h
> >
> > Against files which were moved to kernel/liveupdate/!
> >
> > > Andrew, Mike, do you want me to resend the "[PATCH v3 0/3] KHO: kfence
> > > + KHO memory corruption fix" series with the fix included?
> >
> > A little fix against what's presently in mm.git would be great, please.
> 
> Hi Andrew,
> 
> This is because in mm.git you have patches that move kexec_handover*
> to kernel/liveupdate/ (and they fix this build problem), but
> linux-next does not have these patches. The patch I sent is a fixup
> for  "kho: warn and fail on metadata or preserved memory in scratch
> area" patch.

Oh, OK.  Please tell others these things :(

I think I have it all sorted out, thanks.

