Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B98F1C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 20:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39C76B0098; Tue, 25 Aug 2026 16:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA526B0099; Tue, 25 Aug 2026 16:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8CC6B009B; Tue, 25 Aug 2026 16:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F53D6B0098
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:07:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D227B8019D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:07:11 +0000 (UTC)
X-FDA: 85140875862.13.E8F6A7F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id E62BBC0009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:07:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GKKj71yg;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787688429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
	b=1wrEWuliK4UfjI5F8PKeinGjrI3e77bEFghdfjQaUwFyQB2uRkYYXTN9ZCeKLjOF2ggPoz
	HoJUo4kJ0zqIuZWQbhDjJkS8nktaWzdPy0sjXuHY8aUWFhC4ZrUfMq44WDnjmoR/BvVnJ4
	MOn8XLvhb/+ecpgvZniEZk9A/Flz+A0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787688429;
	b=v0CyW+cLUJq0hd5YXlt38TW789huSvFtEZlD/453+bIZpBxXZxgLH/SbmN+GKzRbZP5UM8
	k/j8+Rp7xfyGalSx9dhUfik8tWfSQqjJzv2h+yVlZqkG1xQeBChl513hAOili3trHAmMjB
	I2JWtVVf6+N4iyojuiFNBzpaQnMH92E=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GKKj71yg;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d3b440b97aso6435ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787688429; cv=none;
        d=google.com; s=arc-20260327;
        b=izx3VrFlKySXSOegI6aNHiR0by9eD/PpBm9K7weP4Zm//5hARVM65ZgfVbmXFG2zeo
         LO4wiG8skJv/HdkgdTeDhFf4vH8hOA8Sq+J/vTezrsjvyGPPg+hG4SaF9prqqmZbuB7f
         J9qRq6ijcM55AbQlZA1drKypRn+bIgSIgnyrELcOzhH0ocpe7SAsog/Ze0aQFQGcNgAi
         bNGO3QvGyBRK+8FdKMkkgRGLcjwkuh8u39AOAyLGFq5s4DX4j71cmUZ2RIArwteMqJCH
         WW1qYIAoUqp5dzMt8XzqnxGX6SofhhN7D2qL1VVpW7/SfbxW87HrMwia24tHAwa1Mvoo
         Ce5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        fh=W5srpOP1OWTsfTDI+Cx0RD1E03Gaz9EScwfkaK7WChI=;
        b=L4JlQzYZWVnRtpfhjONtmZDMzqOdDM/SzsmuV47dWaA32TrBUp4RSV1OBRe8gt+9k/
         0uW7rXLKsiwYdPNsr9+GYq2G7SGNQwFBzIJ2pw2NYpz5agaeZFMAwlBchQ8/BNXzQzFc
         WeqJONKcZrU3Gkh4xpBuEOOLC+tlF9UIdUi92+4N/x4ENeuZIYQqGEuv5x/K0iLrzyj2
         W8wmpN8RDpaXS5GdxqwtxNIbSZJeh7TrQzZIbS8EfOfyo22kWpJaME0oa5jd9qJ0m2mq
         fpE3Dm5/51+ZEdpSjDmp4okSeE9zD5EC1tFbhJ5zNlSGapk+B5WkfF+GGiSakylsZKKA
         GzUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787688429; x=1788293229; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        b=GKKj71ygk3KAVYxpGiYsGAIaoHBbyZy6N0Qd0hlNBKAt6YCGsvtNzecaBepnIEa/yP
         Ln8xVCmfNAjuR27PiLLUCBw/ajt7nLXAJK+6UUf5AyfsvOaHDG8hCUqK9FLvt6lbXlYH
         OGqbrynnpZIWUgw/uc1h7p8nT+onqaWZOjlkP55+mZkM0SiTbZJ0/giLbAIRBIKpj2RQ
         ClUJar16/7RcHKRmWi5J8Pw7bejsZmmwZoMrqwJY+LH8uAXGBGLrF+i6VeOlKz8px4y+
         B5wUHpnZ1/tt4Tr0wxjBlFn95b5sMRmdTgOm7sLg9s1JWiyD2XbJoQzq8saYd9oFAtJV
         XgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787688429; x=1788293229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        b=ZT1z3DvcokeWpSlTzjV0JaGjkzHNC09dQeWyncVM898kTe8xkWS8BKIxB19HAqxN7F
         rDyEq8WmtgAw4RuG/x13M2n/kwXvJnXkALmBfgSJ6HEb2o56JbCa8LBR0z1528sPNeIj
         v90pkDpMbenPvLYQfGobv4Kosjp2+8uQdDfXh7WfbjhAOlLl6ubRKQhWR8qsCh0M4JZg
         ufzX2ZgOyQ5l5m6AaURdfipJjvoubI8vUVzV8I3qQiALpxMB1UBTVI3LHYbhHYYIbHfL
         wfpQpwcYhjEe65rn7HKFxX7erlGAX2xLE7jpwdH2GpjrINNmpNidW8M6vSA8UBkVzMao
         +rnw==
X-Forwarded-Encrypted: i=1; AHgh+RpZVsc3P6n1HN+4VdrF0ZYQ9jzUnEMifnZ/+APOWT1A4zZFS80Dew79dC07qT6ti+8sJtH+4qDjiw==@kvack.org
X-Gm-Message-State: AFuF++llX1OQxVnX6Rlf8g2qYorP3QWZ13+6R7tOCYUsUElOxnbEZoT1
	aAVhJFIQI7WfaA7ReDywfmtjNV2kVAQkPK8I/mfelFUYi07l9ly/g/CZ9Rh8glH/LmeVCwUXiYm
	zJQgVeihLdKLotYpTuQN9/GhikRBorDglFzPUN8V1sPlJM6vA0V6rLHsz
X-Gm-Gg: AR+sD10+2z+1vPEl0oQWkLRYsTr2gzoiME20htqvoUTvVM7Ym0PR0t/VO9uJUbM6xq/
	qp5at9pR9e9JiTmhPU2zw7g26gdaThy0gQnUBM8icqqUXhzH02hV1DAqYV50vUiuNV+KMxrWIKa
	NNudV2Nl7v1HANVtocbUR+H1XRuDg4fumtf6F90psYRR9a2G+y97K647SI+p8eBi70JZf55OyE4
	9QaMBJhc0gJkcmzu32eYqVAhFDinBq+Ym9NrSXgb7hstx5hdtryXomFV8Ngrb2SCeosVxGn7o+e
	sGH/q6yt3XCPAevTz5cTxUsGCdH98IZWjuSQuEf7iH74BGXZ8FMTg7KP3SP8mKbm4ekU7xBg81A
	dZsVh8q89WbigjBfQmDS6kCG1G3lvCA==
X-Received: by 2002:a17:903:4b4f:b0:2d5:c090:3810 with SMTP id
 d9443c01a7336-2d70baa1fdemr376215ad.2.1787688428259; Tue, 25 Aug 2026
 13:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
In-Reply-To: <ao3y8TtEGjniZ_4f@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 22:06:30 +0200
X-Gm-Features: AcwNN1U7imKfFFWcqWcxt2X9g3kXc7_YW65q6sOXIrpi9lP4BGYdXKwulbCkr7w
Message-ID: <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bce3ty9nausab7ama7663en545nkf17n
X-Rspamd-Queue-Id: E62BBC0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787688429-828152
X-HE-Meta: U2FsdGVkX19qwcepC8O8nWJKF1E7X/BqH0hDCBlr6ybXSxpNHIYJoacMxKzKOVyeEAvBUi2Q03zHGXBFRmimxe+BmSRL3WEEvm+Yizc3yo/2TH+3AwFJ6v5UyniPkahS+ajP1j7n8rEqKItUe7AJjJczB5iRUNI62zvM/Ygh0Jod1LVHMTqPwpXEiYpSIRSEHqlGf0oY3Veq7NlzZJdpFeDi4dXtkpLxrzKTMThmqf0p8Hg1K5k82flkkebUCICWppTKZoOCdlVGfz1Kb4QcSgII6s+VGAUBEfGDQDCUaTUEZcPOF5brX8ICIp4ZTIMgDO78z0maq+Ar6acqJjQRFs3sT3N4x+WdtyJBn1FPN8YBolOgEUpBUxKwZWWkbzxf/kD/A9+67n3lRnJ8QM6moLMx3IlKcQM5LvYCNSvshndz10+bPdvBr4Lkylhj5NvpZ7J1K6fdXVh8lP8a7d3CWOaR9nUyDHs4MPKJMYPJBBPv0z9UBBtF45I0IPg2dEk5wspjtlbyMabyxZ8FM6Z8QJMFJLq/2GnCvfB2xhVRZIZM4Rp2kEqwYg/lWe5uNYb6VOPUbqse4m5fUUcpqcD3JFi0Fg0/9EKkqy/O+bK5aH1k/r2wbDjfngKCUrrx/Q+vqsdujgXYXLlt4yVW171kn8FXEZBbeqVzKBxPxMBYaeX6pQFlMb8qahT+3w2AaDNo9y9BhMpwEc9W9LTc3kvhvBg4STUUTz2TdP6Gs2dYZ/tZIjgmor8OJSPQ2MFWPoyf0RRuTDSo69YlSr9Rickb1xPBeLGYHMrrKtsUNUxjrIv8xPv+88RikXmrozrCMUKbuw+liB9+JYIvFfcecMnu0F/9flh8HuQTi09dqOutgC4WUE01gNNvJMQk2T3VCuHUGr/PQddNOghdF5TQDnri7TxT1xgM0KFvU+/G5IUC445l7r4LNkrFA3ZH8dUH+Wq79Ni3IJgfl8Bwt0KL3j7
 NqWf/EWS
 rcxTOrUHVcoqLE0RBiPMSmVRAosnDm3+Yi5MO1Kix9RDyK0HhAbgS5qOhr3PD22FIZrq+rhvjt32/UuCY/2Fwf4UbLQ039bEv3iVURvRCeVT9LNWIE+X2sde/P8K0tCqTQLkgkfqEYJmGItcIZ2kXDcPoZwn8CJbWeusEGuthLoXEROWfBk4o9u6Hp0Hd9p9bfkAvbevHz+ZCoIOnZAx/gt0vkjC6L6pVBT/fgUQyTPeskHHRrFRwyf9FcB3x3T5sGa2+BnWnL3e3XRG0zspNdFd8T8FoLBIOV25FJbkhIedY+9ItesfPrOokfN69sg6CPQ+CNDsTtcRcIrsfMPkwrgeEnftNr4SWA8sMe1shJi6rmJyJSpMAAv9+XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 9:54=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > Could we strictly ban using get_user_pages*() for write access, and
> > use the unpin_*() helpers to somehow enforce that folios are always
> > dirtied on unpin? I guess the problem with that is that we have no
> > state that tracks whether the pin was read-only, and finding free bits
> > in struct page to keep track of this is hard?
>
> We'd need a count, not just a bit or two.  A pincount for all folios
> is on its way (eventually) but I wans't planning on tracking writable vs
> read-only pins.

My thinking was that once a folio has been pinned writably one time,
it should be fine to mark it as dirty every time it is unpinned, even
if some of those pins were read-only?

