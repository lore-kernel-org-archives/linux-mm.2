Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC58C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AFC6B0098; Tue,  4 Aug 2026 13:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BDE6B00FC; Tue,  4 Aug 2026 13:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A7C6B00F8; Tue,  4 Aug 2026 13:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD5A96B0098
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:28:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B6B3A0243
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:28:24 +0000 (UTC)
X-FDA: 85064270928.19.F97BAB4
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id E45521C000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:28:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=M1zeU8qZ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785864502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMQxCLJgeqLxaC8AdoGbjrTjmuR1B3PyJ70bBmktR7k=;
	b=LyNae9y8r69FDwsl80NMg1zOzIS1jhMDOqfkBVS/XIlFDDFu9/sruC2xJ8usCwK9P/kzTY
	io1AbmY5NKaGO62sGsrYjAJbGL6haB+1JnM6eTnjvlbrN4TZ39PKplKwLZyJmhAQn4V4Rm
	aWn0cbjP+2p65raXUr17i+XPMBoZLS0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=M1zeU8qZ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785864502;
	b=hcofl5msPo0z+0MrxFAqQSXZeHfNq8cqxgN3PSKD8fVienpxU30tZnSBPBGwHn9bKkR4rh
	K3wyacmoVUEctQNwWxn7FabTbapKGMUWNvHGJTx4DBe+To1WtX2YxkBCtBwKkyowhFohuu
	/vmtSQ3C2ce1denfCknsWhlb8+Nf4Rw=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so27795766b.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 10:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785864500; x=1786469300; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qMQxCLJgeqLxaC8AdoGbjrTjmuR1B3PyJ70bBmktR7k=;
        b=M1zeU8qZ3eDKWnqvgw/exhsuKs4qr+nldVqdF+xuvjOA3x6qenMXCXkS9aKONacisr
         8ezlTZr+a6qqri2AKFVv3fnoRvwgfrAu/VDjqYYqv7QFaFpYmBJwxxrXY2WjSvDzWEfg
         bnla0OsRO7hEcDAJke59ir6ygmS+hFjONPXNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785864500; x=1786469300;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qMQxCLJgeqLxaC8AdoGbjrTjmuR1B3PyJ70bBmktR7k=;
        b=AAPDHSraGACSOKHzPAvDQKp82QU2AMHqzKDz6xhq+I5esh/gA8DkXdz5zcO/aST3Bb
         LkrZeMYiIbHoqRpEEC50KLZL9WLPjuCqkNBNXd9BO4T6CbMUv9KysAoZ7pIrqvXkBmc5
         2xb+1L/Er9Zl/NTCk9M3+EkfWjo0ukU+apvxq8xGA4miDuIHT6wPryfVFV6os9kUC5Wn
         qX+hFzQUYS1qpO7+CXP8aJyC60dnu6Qz6wHhbDjqvxrlvJH0CUv4WlLQJVvaAdglwFfD
         VwlUGscZmsHkC2o6ExVUrLbOVlJqpXrhLOFHTrKafGZUsjXxpSbiCZBww6wSTCIrJafk
         k5/w==
X-Forwarded-Encrypted: i=1; AHgh+RpD9y6Hfs+PvBVi6Hr9VGfZ6EEMS1q1Po/pNO+8LYDW7Om0CLfNL2sXtAxadguFHwCO/YlbGk2eQQ==@kvack.org
X-Gm-Message-State: AOJu0YwXEt9nIGOQOCU/9hqwTiDxdAjIur91S1ohitHBJ4+JoTrAayZ0
	ZwM/NYwMFZweOlBUixJV6nUK7cP6uZvz3uYTYbWW00Vj6cOTMRNVkgsWonQF9i3eSBw2C/x+qno
	JURKPNt2BgA==
X-Gm-Gg: AR+sD124EfzM2dwu3O6rqXesY2UIj+RPADfyC/rxn5UsH6nNpXefVRj8e7oSF6Gm7Wg
	a4ZToP/NFymKorUHoA3GZweu1pL/NCog0gQTo+rxLfX+a7YrfcTGLyEvhO8wHwQffgeLAXsiirx
	Eq+7A3b8sOGCBjwliDu4d6ncJ55ejZe0JN5stF4CEDRX0YN/+n5SUxoqPGiHo7ld/h/NeAxOPtn
	Ep2SiDS5SbHQtNUNwSBBdry01dDCNjyDuPy4BZP+ga7yQRywUCBtO0tRI29I1piZ9eqFYohKJjN
	akih0XuE+qr1qIrelNr+tcELYEhWR7QMMUWOBeL7A3vb60DEphiJO3SclDPRV3s2n1yTrlUqDIT
	SW1Mdb9il1cRX+zbZ9T20BHH9aRC/XgXVbB7xTviod4wFJYePcrvXwyMOmk8HnF5FHrMrcgK89b
	0KYotUGKJDZU76MdP1Y4h/QQmwa2X+OIdqYmenoAAOFiO9ptW8l+/jfMTMGNX2Ivq/Rp97Rgyp4
	ZCgVI1Z/eX8f35fEkXnzb0pTvBzBE+HHJgmkA==
X-Received: by 2002:a17:907:9301:b0:bec:64d4:3872 with SMTP id a640c23a62f3a-c2039ec8d14mr2918866b.24.1785864500269;
        Tue, 04 Aug 2026 10:28:20 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20363e71ddsm37569066b.34.2026.08.04.10.28.18
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:28:19 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c197e7e4e94so23911566b.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 10:28:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro36FSiWGNdgT/TI2Z0L2+ByMKS1p7OgiEvKbhVqyLMjlG8u6h7XtNOjjFv0n0mde5JkfZuCIf8/w==@kvack.org
X-Received: by 2002:a17:906:9f8e:b0:c1f:1520:56d4 with SMTP id
 a640c23a62f3a-c2039eef631mr3030966b.27.1785864498518; Tue, 04 Aug 2026
 10:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org> <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
In-Reply-To: <anIXr4Kbn59Ac31Y@lucifer>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Aug 2026 10:28:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg=7QNs-g6MgswMQqYhGgz+N-8E=cphaQs1jQRN61_2wA@mail.gmail.com>
X-Gm-Features: AUfX_mx-6mcM4e2v7OXIfeWa0mf90unJuraAWyzsuvI99MhNN2FXKW2aco4PiMA
Message-ID: <CAHk-=wg=7QNs-g6MgswMQqYhGgz+N-8E=cphaQs1jQRN61_2wA@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, "David Hildenbrand (Arm)" <david@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, 
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 6jnesgtmm7obg4sgikeictqjaw3nkwc4
X-Rspamd-Queue-Id: E45521C000E
X-HE-Tag: 1785864501-687212
X-HE-Meta: U2FsdGVkX1+l/h2stxpfHtDzRdKYCkKHsPaS1/wgFvKsk6vUrQZ94xEKtgKhhGaUxetfJGT7n4O/bWTkA5PxUHRTXvPWysUxi+L00C1Mw0IrLGDMp7weVBfjr+GxDQo31dNqOkt96k/WnIjRETsWJe2HA7SJjCv4aobRYAcQRrF7yaH2v5XJebbr4fYojwaZ/VfQcQsoytDuXiiickkdbzrL2oE0QattybvMJR0ukg9Zyi7KaNgKGOmvzqdqq0VCxhfwm+Z4lrLSbGTMxkDThsDp60D5aje8JkjV46z5QIajqffKwx9oznjq+C9hs3TXbFJFAtmBE6iST1/bFbFAgWERdsgRQJa7mHLI3/1sDW8e/BiFGOSdmWds3+fOuIm2KsYx7wcTogKaeVW8LHQcd1hKo6OhfTmJ2yHWyc7KjGYQ/5E6QI5TysHMio0Kwpgz+MHzu4PtLK2I3nrzKwFifIwVTCIkubwEbuPyZ1thy0bsrYTW4gQoXYdWdnPmnB75DwnXagaCut272XwXOfky8jAWme/5iaC2TFLDQONRGGPHGmyYtOvAWdoo+GOpOr5k53Zu9Nq8QS6RSGsxnnFV5mAX4NeQ1nxzvzPtfTVwFCDvgevWjZbSupuE2C6055OveD3IUGXU1RTRDa0UxeBAA0pqX/07FJ5elyYu3b6n4u4KfvVDLgHMqQIPS+fKv1fUZ7QJu6kt8Lpy1Y9NcfAKJ3Ub8iRffVQ3La5w19xOtiB5FoEWp2JxSrAPFzXvW2SGDeg4uB3ZPEVgF9KcpvzppvIpuz3V4C6SLd/b9TFA86o1shYFsF58pQerAiYNMhm6AxEwFHc7Phy+8rvJ3zyl2mhuq3OxwbFc0+O4bNNa4qgJ8N/vTtGeNR7MMm95HCPIakAEKeL7f9Q9DTs5DJwcSbV1pvs4tq6+2EOp90BgmsRbP2dYDR4wZ/YCe2p+MvxM+DfdpHf0uyicmjhSkMX
 +/dRRPWa
 N2VmXRDS9zycZmi49Jl8ldtGppOC0PHnB+VS5HEh6v8DWOPPZjAPvoGhdBN66maGw2yTheFMAl/O6lykLa8KT7xvrq2vMJSq9I2AgHGWW+Y32SZl7eDUujcu+iYGxjHOgjztlKEu8YDqsibJoMAfF6NGKhe64FFZOM3NkWTwR5B4NOVjP4WHvOoxPZL+U/4ho1XvCGFt+MKl8u1uxxSuRLpdWjwhvyRCAL54lHyJkujK+kt1uGn0U5yWbXp7IevqOhfWFTbz+AHjC0uhyAFlAiFC8sHXWCpHv78w2TgPI4zJSM9pbLX8gArjsfObginKmXdLcd0cjuI28jNk8PvY7WuO5lyekrGRfS94hMTYIDKaunu42uUSbkQxbKoyVa+qF2gUb6B25Q1eUO8AysaisWKFafglH64LPWXWf2aHadHwOZhuvGjaWVXEPVOolvrDHUCuko+gfv61BzfKYbKqyARB+vW3xQpkr805SsbPE32saH6wqphYNMsvspk+JJOjWRvFaj8Sz+vep4y/CzCuMMbCUATKYvTzzl/wKXHjzOR4xQWyBp9TMaZET9bR1Yh2WpjKg2Ge/pzgEpyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 at 10:24, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> Well :) it fundamentally changes how mm works - now we have a whole new set of
> kernel page tables and PGD's that we have to think about.

Yes, I'm certainly not enamored with that patch series under discussion.

That said, I only scanned it quickly, and I'm also admittedly less
involved in the MM world than I historically was, so I don't think you
should read *too* much into my opinions.

              Linus

