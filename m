Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07778CDE00A
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABFC6B0099; Thu, 25 Jun 2026 06:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84256B00BE; Thu, 25 Jun 2026 06:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1496B00C0; Thu, 25 Jun 2026 06:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B74F36B0099
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:14:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 464151C6123
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:14:01 +0000 (UTC)
X-FDA: 84918024282.07.1FCE15B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6427640006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:13:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CzFBk5Tk;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382439;
	b=I1F+CS9hzhy5dWWCsfZC8rU9nDSD7MnA7lUDM9l9bku7CXDlWJie0OhgaLTwqVPzfa+JgL
	/UDz5fKhbvY0bI9VbrpcKD8eoihu9AXHmYsIW1ynZts8CR3RszU0GPagV259aI/t530A0v
	DnvGPkkAC8kqC3NToRBRDkvBoweXwIg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bcArUR5Omfus3wVz5rbf78GOWoL7W/szQeqfimOQPA=;
	b=25b4FIjXeJ4sVELSxU4yF6ldEqFNJ8FJqSMUQSHdBT3r53xHyaw5I95ntgHWr30EdxUM60
	kHy427Z65s/XtJ/i3kmT6tbTzpV6kXl5zGjJr6tR9jUMd8UYujeV9/UqEfjrV+QkQlncFm
	oAGdmBV+oJ683j12vkZulgJ1HhJ7OpA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CzFBk5Tk;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DDC64360B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084BB1F0155D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382438;
	bh=4bcArUR5Omfus3wVz5rbf78GOWoL7W/szQeqfimOQPA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CzFBk5TkZMfJCyBMVUmeqkh5hScBSRF/jcSCUwp+RVbHyY3s59CKBuig8jP4pz1fW
	 /uRfGzYhSoMsd/eg1OhdM/rZtSX2rtrpdCJNtivnmOty40fAOJ/1x9Q9f6lwhpCQ3S
	 QVjp9MfBWG8PQ4E8lkTcmj4uXit/M6YUgHP7hNwLpHiflzY4Bfl29Bh6OIIl7Sp6T5
	 Z4ufr1klV7cLHylINhsCGioMlUW5mPOJE+bVvQd6Lzm+YfbCcfXcwcErg7h/u4B0Mb
	 3rolBSqg2ToA+EODYDbqQIGGnq41f3df3o8UfUrge4C2N3RBQ8ue7JvgepeXgYc9le
	 S7KnitoaRLoKA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-929a7eeb0c5so14675885a.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:13:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8MXbrjdhb3DLzfAYimkkn0P3JVGI8iNSZMxvQacV76wIEaDbEv+oRFvqEVufUPRXNEwr/IJTvbzw==@kvack.org
X-Gm-Message-State: AOJu0YxX4f9ncZ4VSbgJQmF120AN5ppWcZaGickiVWPsLJjAaZY9Untt
	gpalDghCHg549uSiNXoBDMeX/2HfdL/wrNXxXR3Bmmo86loUXqAOdBHk67CRwEH6NfPWJndM5xM
	T+Mn1WeNudGGtcjSDYSfsi4x7OnxVRRY=
X-Received: by 2002:a05:620a:6882:b0:920:7491:7362 with SMTP id
 af79cd13be357-929250aba81mr230338785a.10.1782382437379; Thu, 25 Jun 2026
 03:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260623125723.2503832-1-dev.jain@arm.com> <20260623125723.2503832-2-dev.jain@arm.com>
In-Reply-To: <20260623125723.2503832-2-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 18:13:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wF5ZZBbN4OLO_s443NqFTRrV2m468oa_1J+Q-2=nuThw@mail.gmail.com>
X-Gm-Features: AVVi8CfXAsF0mhFDEHcfpEmZtsf8q-xpjCdIC1iA0aFQPxUvcKzgO1-abrG7b3w
Message-ID: <CAGsJ_4wF5ZZBbN4OLO_s443NqFTRrV2m468oa_1J+Q-2=nuThw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, ljs@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6427640006
X-Stat-Signature: wpg6ti4jpqwhfgefxa5ixcngwbwg1hm1
X-HE-Tag: 1782382439-833888
X-HE-Meta: U2FsdGVkX19EJD75ne3kEeKfcVDVqjQej+FdVIGeEB6xmGbkCStbxPLlfk05G+v3x9TF3blu0rkd6b+E6k0iTCXZLsZIeaumfV1Gh2UFpt/0X5WYvvqbdGD98K14xwY7fZ0k5m6vFYGYc78ri8Tk64dHTW73iFYU6CMxNwQQTXjSKQAR2MPPDAA5FwVzDJU7nJaoyOxL4IjHkJ/CaayFOnRrw8WfSQQm7RN4jc7tF0kULJLy/88fsMekHXVOuMCkrhDn5s8HCWXC3nqv+LqAtILhD5CxKDFhOeutcBt4AJjCZq1D0vDdr3XYWHsnUtU99G4G51tJICNMPuxdUPTjYDk+5KTxsDziy9M7GRrMjVZiU7sjzekz92AifFI26fItQEQo5I7aJfYJW6aCaFDhNBwD/WluAcx3NuB2FKrzej/JBlVBzQ1nP72ffmDYsjiP3rIaZlOSbeyxA9UAstEFAWoj41IMikRSb9zJb5IS2MVjL9QiE8qpijCQWXfWY2zds5urU0YGJKWqQT87fV0QeyE6VI1AHQoNyP1BktupYEzVbGNkbTXyS5iL6N/KdSzf8QvB/WNGE8zmnlTowvUr+4XTsvInZhby06e6wv3h9ab6c5X2YyfIECVkVibzrOBj6uOA4mgGXsIpgp7VN8uo++Xwxz755SpVSj5nVsp7Qh4yH3yE4CFkGZMoEAqG728LAVQx7P3sGGdMUwhNhLX14tzlRY2O3mn/Dm6luvcuELdv65NHV06XbCm4mjUYUdxMB/uHhZaU8/6legdk5K0sudRXssmnlRFD2Mgzag4QCN9EeZb5BMyMx8lVeDCt7deFjETGmihLo8qVPunZlPdtPi4kR0qavgUCeX4G8B6e7G0qGn4z36pxEu0XSKR5LqjkdVfLVrHe5dG3DIwNtjpOz/VzXjooc8aRzI/aeXqgykNBCHsfavJJPCANEavsxWCYklNyN5u+X9JryUcktH1
 /0uXsuCD
 mhPGmqCvpF2CD8Sxpkqx76v/v9/x25JeosHdaGKCyo/uxTsThNNfN8oq5Srm4kD0bEqg6uhIvWKARstbeo5+Z+3droyfJTIe5qXu6ggYpsFS7tnYD6vXsUwwfmsPQqTBZEL9DjkRKOk+Wv3rbj0JkYYIwaYxIdxFB+ar5n6a25yWHhpQdH5pMXHNp3Nmum6yVZFGg6eCiGrHEctsktm82QUNdWe7fGeskkJnCyahTL1p4KeaWJ9Fu+u/b6Xxzoae2s8hn7gkzqgPdU70uPpjBd04OwTwbiK6OFaDICmt83Smk+53SD3Rc0rgkhj0/6u3ddsXBPEtbBPV474rsdkfP3NdeFGBRusa+f1uR2BUUaoYMeOqCkTgFzhBISib8YBdZaFs81frjt7mP3SSvOuDISyyCOhEShGe3yEKamA+yTzfAqDSYK1qkifYUJble0OzkjN0o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 8:57=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

