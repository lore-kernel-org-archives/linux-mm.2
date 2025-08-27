Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A78CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A7D6B0008; Wed, 27 Aug 2025 11:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10976B0029; Wed, 27 Aug 2025 11:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DD86B002A; Wed, 27 Aug 2025 11:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4E526B0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:05:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACA311DE02D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:05:37 +0000 (UTC)
X-FDA: 83822861514.09.36F7C05
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1436100010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:05:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=TnyaeUFK;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756307136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhSXA1eBN3oDPuVrp59TqMHXsvUj8E64vbrfTqno8g8=;
	b=IV2SMkd8AgRFvZf9OyoqlFo64jqXK4GInBN86W+lqHhnpR7zDcSlQCHjdBbtncK9bPRCoT
	ueg8IjSq3ywqhWYMntUektQlfSwoXnabm4BH1FFWDJaNcUJVh03zKM7WFqJj7VNB1ZxRuN
	66HUUkD4vjfbSQXa7fNsuJJ7Oy4kA+M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=TnyaeUFK;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756307136; a=rsa-sha256;
	cv=none;
	b=PByxBQ2MHEr76/0Nwq3gTgF74dRvuB5ZdFtB1dvyoTq3Wh2yiYdKOjtY7oMXcjk8Anmc9I
	ZLgAWk4BQu94Z9rJ7L6zrTsb1h96OSV1yjvTG+ss15YGFOasJy769xiN5Lj4KAjcoUocHy
	1adJhVpAgBYq41lqzXcRxCIGeSJ1awo=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so1025505066b.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756307134; x=1756911934; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FhSXA1eBN3oDPuVrp59TqMHXsvUj8E64vbrfTqno8g8=;
        b=TnyaeUFK8cGsIpgBsO3jQI0Gt2qXDl4Cva6/Asd+G3x2dZFX/lTZWzhphXgUPDb4e7
         XXedwtgO0Nz5Jc4svISU0aKb1l/+jfHDCt9BNt+GymFfLyi/dORgeFbNVjAc/OSYfWat
         OIiYoX55u2OTWWgbLzxo8XUAhDkuZyoEDWPstgnzXB6RbQEGFvggm3jx5yeivRVcPDSP
         G+Pcsg7wmkPGrWuO+M9Fvpp8qBn/dmsMPZ7W2GqAbeJGyJ0qSrYHazCk5bG5ckXy4gAm
         gFm2ShjeZYwRcqid2cFw8uYGnR2QSXcknMzEHsxB5jk1ku0WcqPGoYwOXWazXLKpLJ4V
         SQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307134; x=1756911934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FhSXA1eBN3oDPuVrp59TqMHXsvUj8E64vbrfTqno8g8=;
        b=DaXLV86Kj+dxq4Cryja3bCTRHYyZQsGkaVnc2CGHVWbJbuL8p913CPQDpw3qEruPKA
         9tSWF8HQ01AEYPwrTFCbVTU4MBbQ7EA/2cfJIpGsje6Q0DWOepqnu+8cQubYs3WKLIcM
         DRTRpGRbMl75fRueYwmAZ7wyEEvN07EozY3/E9ySjvzvgqD/t7IpZTZKsgQEQ8z+SUYx
         35tb1+OLe1bIekIt5pzGatG2VrhOQJS04j2qsJNWvFSE/gWyF4XxqsjXno76MkpSyCZ6
         8LTZgL7itkpxR0nbKgQ+O1q7cS6sLYg/Z5qUzMOIDC/gh+op3EYER2jxth5cY3HrZ+uo
         P+9g==
X-Forwarded-Encrypted: i=1; AJvYcCV+AieOWzkuOSgxaaLcc2b1iEkzxeRXjoSkfCkEHD85fvza2iLc8qph8ilfGeF80hqm+yqkTj7rpg==@kvack.org
X-Gm-Message-State: AOJu0Yxv4kB4vuDZu0Sy7n2fKZ2axvNw8MIPNFMN5kr9bNfDddLtVtx4
	m1yhDdzL9REk9uojrXCXUCtjP0uYkNdx9ynEajPY78jqXUihteZODyyTI7aDiGr7tfgWaGENI0k
	lif8Y1AbXKWuBFemD3MIoka5ShV+WkrA7XHf5y72Gnw==
X-Gm-Gg: ASbGncvYU/9QuyOPPDqsTCac2HXSQ5OtqQaYW67zod/wAR6lklpU5XS9nLfrKmKdeMM
	F2rkUz1LhZegD34D9I+z4vQXNNI0VuRRv7zpHUlUXkWj2RRoT0nmc+KYsqbsORc2g3ziMH0LUZK
	gKJ2FSV14ivL5L462ggzDtFcycNKeyYznGsxy0kF+vEABSvHCOsEoJ+NIlclwampi7k9uUSQGpk
	h089xzc04quDp9l2rvQK5kK0Vmk/c0SYNI=
X-Google-Smtp-Source: AGHT+IE6xzYxJ+pVDoA39WuUHLJ27/IMu9NOdCgtBLgruePT80zH4d4j5lHRG8no/rTlrdtPbbb2tg0xpEAitC+X7BA=
X-Received: by 2002:a17:906:d103:b0:afe:7027:56f9 with SMTP id
 a640c23a62f3a-afe70275e3amr1046008166b.17.1756307134403; Wed, 27 Aug 2025
 08:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
 <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
 <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com> <CAKPOu+_8_gfko=Sh-YKpbgcMy0aJB=m9yrC5JJKEZm=yeYPOgA@mail.gmail.com>
 <11a5d391-3a13-4376-98f1-34b529d3c583@redhat.com> <CAKPOu+9j5+w6ydvygdWnryZM24AFPSVJB_21VH8Odi_xdrNksg@mail.gmail.com>
 <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
In-Reply-To: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 27 Aug 2025 17:05:23 +0200
X-Gm-Features: Ac12FXw8IqVqehkIMKejb4kYAyB8VmKAH7ycfxA8rdmI1TSZowZtPojbuiaWO8g
Message-ID: <CAKPOu+8O1GroB0KDGcwE2ByugaTm_MsoU2c5NQAbk1NpYOo8Gg@mail.gmail.com>
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return false
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1436100010
X-Stat-Signature: 3gbyayrrbziycc8mrpearos3br1ztbzn
X-Rspam-User: 
X-HE-Tag: 1756307135-514986
X-HE-Meta: U2FsdGVkX1+qsFYvwLnNKaSa8Mj/1SmwQokedNQi57AiQodq2H5CQVgF5KNpHHR8I4BzqHqwEpMeUzsBc+iGYZWynZTtHp4Sl3c/d6iSqAQkczxAsoeg0rnhy+Ddfg5Z3X0S+0aYpgU1z8/CZiSZtWXpaXU3FB/fF+9e9nCEpctEnmc3EzSVEpFtMNUqkufybgWm09iZ0nZdeH+QT8uzgvnGhDozI/+fVej2C4qKh5UCcIR4Mh/a+xpPdZwtI5wRqo5dK9iRFSw9qlpDFZul2zhXrak4N5NigwNMH3Lc+vKhUjr4Yn20PFzu7x/QeStk+anHYB0cLcfxNZgaI0oiERo25fXFHX44QtGwOWYbMo0na9m/mOvq/N+ryRGwqjBtVKuWw3tyJn7KymDO69KTFQ02/+VImW57n/aEqHsrxI7/0UfEg7HNCv3g5qqBQebMoZl1NRrapu2tR05oX0SqCptSkN1jyu8BpoeogfLubdxfZyWaUPDA3yYhPkeeuO70jCQ0Tjo/B3pmsQnhyqmV17ZUsm5UJX1IKrahDgFon0EK9cLLF96n0Bcz77FAdnUWKYyi22QBWTi8qHUWwYJPavGQ27HOdJsALIUUIYULQbK9Y4hg653/PpLxo6A7KW8h15taNj3FMATQPWOkRS95LD7ce1/1m+KT0zKCdZw2ymXVa/OepLqQR+/tyhfqjGghLsaLzgyU7UCi/mrgwbsegqvmgEFvHFSxhCm8LCUjbOJ0a5EzG0RZU6e8y68e/5n4+xnzEXFYiz6ZxKilF2b2DNqQkP5xeCtl1th++UMaMpzjGUnjdnPFfwarll9DvnVKknNEHY+ksb6XQtfP+rbG66QoCqxQF+rRQISLPQGnf0fNv4a5iDO+qB4b6HXiEvI2Ot+Sn6h595RUsH//2SsNmbgaqTtpnE5cvj4MEwnqkPYggy0sy+tqU9UV8kzb7dLvUOPlgi0D1jA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 4:34=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> VM_WARN_ON_ONCE(!folio);
>
> Should allow for catching such bugs without causing any runtime overhead
> on non-debug kernels.

Aye. I have posted v2 of this patch and I have dropped the
folios_put_refs() patch.

