Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD14BC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 23:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B006B0088; Wed, 15 Jul 2026 19:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C4E6B008A; Wed, 15 Jul 2026 19:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DA66B008C; Wed, 15 Jul 2026 19:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E09F6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:29:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 825D91C0283
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 23:29:00 +0000 (UTC)
X-FDA: 84992603640.17.0111E99
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id C55A440004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 23:28:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sejcLQDl;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of sagis@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=sagis@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784158138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qLeRdnIYqFL2ZkvvJB0Jh6+9BtBNZEB47wJZNGFb0wU=;
	b=TryaF6grqeJc/9IZKyP4B/fPHOhn/P7jY1W22nZMzUCYjPZJFe9ea/43UKLTrj/LfQTLg2
	kzuVB1s1QpbFWGNs5yCU8bmptgxsPkgZl7aqdLPDkrnUyhjzYWpi0nDBRexjolYfp9dNh3
	0lBVZ4wHwDasSTI/S3ojIquXcPabU+g=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sejcLQDl;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of sagis@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=sagis@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784158138;
	b=oN4iwfdFROYgu8cUeeRZluc6Ngk0/8QlohnGgSeYEFrnHtekUYJFxuqLMJTvGTVvvYl45S
	jbL6otzH9LviYdKSjuUjevy0URpMef8BIu3tF9DMunUaJOuciFDt+SjmvAe0ayWpvpmaA6
	56du7h72db6tfYvJiQCu+fqe412Y9U8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c15a5b265so119341cf.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:28:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784158138; cv=none;
        d=google.com; s=arc-20260327;
        b=Tr0QRfvR3EInpWOZr4qX5VC44MhL3aD3uXD7Uhv1a0Iv8mjeHZpY/rjYbI72xcRRox
         GUssmauuF9vubhysLoMFpz38eqm6+Fomlj/sf4Wos0b/5rwg3JGlyeacztDV/4Kz9yTS
         pyJC7gqxQTTBf8hESOxy00B9UUXjVVWlP6IPvRXc4uXRoWdDn5HQhRUfJwAxTvFH8mzO
         p1P5gZMjAv1ibkCT7QnQPDb7xZWUOSFaZCFuErAeSNmubdll3Oi3/1OTkdVB5gXoiIXR
         Tcymvb+pompvSOsi1bZ3c1NnTiG2RLRIV5hXHeblI62PwVraQ22wz4cs/pds410d1oKp
         bb4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=qLeRdnIYqFL2ZkvvJB0Jh6+9BtBNZEB47wJZNGFb0wU=;
        fh=Zq59pp1ueMPHlTtJRAZDJUJaL3MvHuIRlkR312ytYeI=;
        b=Q+PddPd5U+wB7g8PEXC/sTs07RcvaPNaFZ5ruuqWtswE3KRbOHwBvxZ2cnC3XlhSvA
         9nrhKPfFDD9bn3bV3jrmEviPkhxWnFckvOE8SqYx9JNlBmcSeaCcbL3WB5m4NcCzU7jl
         64l6kvJlX92ZBWYKJIagwCi2fo6jpEzmWE+Nmm3ms/IGEzLTV290LTv2E9eKSGXPFLA5
         6j9ThvROzZzJyNFd6w0k6Mp3q+AJ2u6NkXpoGNnHyEA49/J9Hz4i+lchoB8Dq7kzEd4V
         EGSiPZFlt68+qtZ15kigSo+UihhOToDMMTmTJKBkbwXcABwntEahNnr2m0i4cZ35ZTCW
         Pigg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784158138; x=1784762938; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qLeRdnIYqFL2ZkvvJB0Jh6+9BtBNZEB47wJZNGFb0wU=;
        b=sejcLQDlpN2MJd9QT8io5pJjwN+xRY5NqhzYz55jTff6l5HtI84TwgAKxJc1Tgo5QT
         jksn6SB+sC4TkiN9cHf+wymxTfWuZFt9GcWn2LNRgRYuhG2uxxqVGoXOibs5xIW8kl4D
         WA1arPJCZmyrhQIHZNxTqGpEc5ZcpxUeblyDTW0F+kqKN2CjQaKkT22et4fkhFJVOzQ4
         hUbD7ekuKlE9XU5xZrIzhe2yHmO/+In2AaqsPX1LrbXSDcOm6YAvMo+48EFK2Oht7rh0
         A36Y0c9MnTpGcqYLMFj/z+QfolDXCPEUngMB4xsix73LywmBWZ0wgdRiHTxmbtvNhRqs
         alVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784158138; x=1784762938;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qLeRdnIYqFL2ZkvvJB0Jh6+9BtBNZEB47wJZNGFb0wU=;
        b=ILOLEvsr8JIjy35iB1M8L9TYWWGczOyATQL+8cUnZZVLDVlEf0FdIKbyo9XLbVTjIM
         j5ZU0wj48JqGw5LcZirYeKAmXwNIvUhyHwZ1OySVNBudJrcaM/w0ZAhamxeOSa55MacT
         vIlOYYfdy1Aw4wqrl+zEGcEhgDyAOX+cum6D6aXAbsiHkCn/9LObs2s99v6ZKyCJjEdj
         iCM4t6qQIN9NcXZtGOdcxrRpeT7LZJ8B9j10SExrOvR01TrtyN3pb4DR5ZMAoQZPGD6N
         h2MITBUMV2X8nU0dHyBWeTymsk3CPUZBviu8KjpPXKeVO+257NYSvnQRhIxKuisXjVXU
         CHgA==
X-Gm-Message-State: AOJu0Yw7TP4LXWZUatvyA+o9Ua2IBf/afyQPylScxO8cg1FYHIhJ6U/Y
	KXk3lM/Hg0S6D1cEj+esCOBfU/FCxGdwiBKUiJswaCm4aFgUe3NlGwWHk27Kx8ppZy1TcOASBEw
	M59soe2kd8oroaJcXWioqWWNOfDuqoDgfpy7mtCxk
X-Gm-Gg: AfdE7ckPhchT2FKfiUF5cddZvUeAuShVV8FZ5U8fGkyHtWl5UjvAAc3yngz9igdMIEY
	sG83bS48jh3mLj/FiO1okQ7n070Ol1SrLSw7SuWIjoiRcCk+YMe+OfstoLcpVRpOcXsQoVN42s/
	C2ZAPL3x8cLo6SDmb4PnPYSHIw+WLagOPxZT/nge8sQncwPuT3uL2St7K7UULAPK6Lkr35FlzBv
	dDjwEV3IaSO6ZgZ0Wmpi7q0/2F1W6Hzf5PmEKUkpqMQB/en0sPLnNvEOJB8gN/k/jCKFClsK2jd
	+JzSUMq6wkgWxILhbJQ=
X-Received: by 2002:ac8:584e:0:b0:51b:fe30:b8c5 with SMTP id
 d75a77b69052e-51f7d273d83mr3129991cf.6.1784158137304; Wed, 15 Jul 2026
 16:28:57 -0700 (PDT)
MIME-Version: 1.0
From: Sagi Shahar <sagis@google.com>
Date: Wed, 15 Jul 2026 18:28:45 -0500
X-Gm-Features: AUfX_mw5IkLq6HBWbNyFqtB_FJLQY-ss8e5iexyKJ5DFpuVyQE-Godhtk7slzLo
Message-ID: <CAAhR5DGpL6_ViMwQ0nKzTgOoziE_oq8JofpO-VtHBXK37uO-FA@mail.gmail.com>
Subject: Preserving TDX module during kexec with live update
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	"Andersen, Tycho" <Tycho.Andersen@amd.com>, Anthony Yznaga <anthony.yznaga@oracle.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
	David Matlack <dmatlack@google.com>, "Heyne, Maximillian" <mheyne@amazon.de>, 
	James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, 
	Luca Boccassi <luca.boccassi@gmail.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Jork Loeser <jloeser@linux.microsoft.com>, Chenghao Duan <duanchenghao@kylinos.cn>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	"Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C55A440004
X-Stat-Signature: nccsunqijo7kji7cb6bj9q1b4ask1rpw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784158138-426989
X-HE-Meta: U2FsdGVkX19hQyBBrNJUrpj7+iejf/B+kuHEN48BEr+dj5V093R0D2i1oxau55BbivREihdrEdrYQRh7BK96TYR1iwymvMx5nDm1g5MfGh8t2R1cvLiQWCWbIKirOmL581Wj8aaSZc2The3S7zb5r+Mx3X+nPOVal8a5OetjJ/G20zUaBTbeg21Kg6gd1r8gdU5kOddgAgimWRq4YauwgdrNM+1EnjAXrj12Y48tXJhFhvb+Dm+GWhlwZhk8AswPpFhEPLpP3nfglzZulmfClbZTkod0JPDK+vwk57DO+UpqwIJz47RkGj00NuMAykaTsIZnDI0ZwagTFrUkaQvfaQQV1jksdKkTnxd7FOyRGx9ISWYheY+vfEVcLo2w0oE7rdAY+n2/jfBI52OUYQlWJFmjQ9kC+SRWAyJD7B9RXnxP8HD9Ej7gLcl4fJPRMjdizkO6ngLVvF7gEv6tqZ2VZlEbgrDpvziRSq0iigQl0AdeFu6iNvISEN5qkBPvvTwz5uaG3yZaoGMUe4X//rvkRQzgeOGP8rBBdI4FJZWuLNXpJWSa5xbu65Wi7e4nycs1AIJiyPaWRk5GMWgFKs/itSiGsNbl+oP/23C/Q+LeFRjTGEDuCrNgNT/HAyZRRjLYotD8Xhlr6WRF7g3lDOCYoKIKl/AjQlVouVg+VDMC2OE2Kx8XT5b79KPmi8mbCfdqAH7Tkl23cBXpmX+LMez4CuJUfySziuWex5R0q/eblkpyipGBE6GvV6F5L87HZMfC+NFG7dF3XS/d8vsRnhxqc+Zr7XTP6yaJzy6FZC7RPDlOdOWJeaKpYeiAK1WRoV1o+37SsGKVOFHYcOHLG8AEQdAyEWRhvtBOpI/xAwOxhqXwhd5tiF1w2+y+SaBsKhBRdxF3evOU16CtdGW095UzW+sC8ax75YNbex51TlT6IlEPupbHxGtUWQCwkUoZlvyJbBeiaKFsjCUvv/WFS4J
 NDVP/KDp
 u4+KGHMedB9x0diP1bk81Jwh7SWRSbHz3DiMTgYTVJv4oDTqp5SxRZlxrfpL4FUZNQ1GNSCLRYOHpwfWwGF/NgY/7G5fPjy4i69Dk8d4qiGqdCd6XzVExEZ5w5HRAZfgxdpQ26dR9ePwQfYF5GTIKQDe7BDoZZJdDHftJKmXhI01Btv3QNR3xeamxMNpnukehuM2VSEEmvN9T6NmLn++j0YCpx+7PEpOSN8N6sZvCHSpQt2NpbP4UITX4k+lu2FTPxkYcfQh/FHOeCqvsB5YrlGb0I/+SZ4m0a4iSdjnxvzBYRh4+0miUf0ntaNndTjbB3u2hTQm6Yo46kEbi48QmR/zaVbHT/fpxy/hYgvmwVHBG82M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I started looking into preserving the TDX module across live updates
and I'm not sure what the best approach is. I tried looking into using
flb as David M suggested but I don't think this approach works for the
TDX module.

Right now the way that TDX supports kexec is by disabling the TDX
module on kexec and then reinitilizing it on the next boot [1]. This
approach clears the TDX module state so any TDX VM from the source
kernel won't be able to resume running on the destination kernel.

In order to support live update while keeping the VMs alive we need to
skip the TDH_SYS_DISABLE call and instead preserve pages used by the
TDX module such as the TDMR pages from the source kernel.

From what I understand, using flb will tie the TDX module save/restore
to the lifecycle of the VMs depending on it. This means the module
will be restored too late during kernel boot, after the VMs are
restored using the live update IOCTLs.

I'm thinking we should preserve the TDX module during the shutdown
stage of the source kernel. Perhaps we can preserve the pages used by
the TDX module as we allocate them on the source kernel and pass
pointers and additional metadata during KHO. Then on the destination
we need to pipe this information to where the TDX module gets
initialized during the KVM module initialization.

I haven't found a device that acts in a similar way so I'm not sure
how complicated this will be or if there's a better approach.

I would love to hear your thoughts and if you have any pointers on
where this code can be implemented.

Thanks,
Sagi

[1] https://lore.kernel.org/all/20260323-fuller_tdx_kexec_support-v2-0-87a36409e051@intel.com/

