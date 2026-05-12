Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA080CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B49F6B0005; Tue, 12 May 2026 13:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C6A6B008A; Tue, 12 May 2026 13:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9926B008C; Tue, 12 May 2026 13:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 105D96B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:55:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AE7D14058A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:55:29 +0000 (UTC)
X-FDA: 84759519978.17.7EEF215
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C93BA0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:55:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rK9NMs3X;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778608527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTM+TwJvhC/LItMQbPLjDuaF4442XP50+NLVEyOxAWU=;
	b=7DJJjJ10nF2B2AzpeQYgHfAWT/sczAF4s+2hrzNXtt5y/ZLzriQVsIk7R5u8v3qKN2wvce
	jUH7h9tzTA3xgnqQibcr/sBSeZQrYzFJt79dzsqb/ioUBx9sWrSF7sbD4l8poSE8lywkJC
	4cX5R+3S71vTQsCHbQLztTba1EOfwr4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rK9NMs3X;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778608527; a=rsa-sha256;
	cv=pass;
	b=b9w6p6h7oQAy7bBhofJygDrXhxESRm7cDjNAGlfs1hQrVXAtdJA+RZa00bo5qhnBrTuf1V
	nAM9tMY4kinNqYoyRoJGY0aZWZxOKeKS1W96sXEtbfeLPpRkPUfBP4CugIQsFaA8wO1nn6
	PUpCwrw7vOYBOgwbV4IyhahzLfJYDjw=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bd124546379so317988566b.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 10:55:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778608526; cv=none;
        d=google.com; s=arc-20240605;
        b=P6YBkAE/Ysgcc+svWT+/qDY9/cL6zEJ2NYFnOLUwpPC/Jb/yaHd7qntXtVHzx6nz4z
         4awmzv0Uysou8WdymKVvLR3NjTygdyHfJv2ONHzwN9udpnM0XVzrkv/3VUXbPrTo2U95
         oZMnuxg2nbci5ek7EVyIy/zoiOCCjcFVkW7JEymjoKBt8XhQe5i9hBOTijGDuf6cIZPL
         VfM4vJcV66gMVq+/tWMsdjxQN3dvhFXILf2/QB2ENDNjjboatyqz3oS2GRb4dCeCyL36
         XTwESKEtENToHsPtjWn9bVCksf2J7qiRCwgOh/Nqguv7mN64J0Ox/ksQmkcUnFwqCcJv
         rITw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZTM+TwJvhC/LItMQbPLjDuaF4442XP50+NLVEyOxAWU=;
        fh=wtYRkXwhuUYih6j8Crb+Oir25Y5zdXng6A3p5RFNE2Q=;
        b=QzBkdrHSoYCc0THlthnOcD6n8qT2XMgRbYVwXAZHYyGq28QBcaDNZaCDH5O63l2w0O
         pRGszqD+gvlHipmLxMip/XrbM5O0xGU25AIMTuxHOwlH6JIiooMM1hFLStVP8Ftw+WPc
         hl58ivucvEHVbsYWtDtDBmkgk4NRVtqtu9Zq0a0tIGa4Uc+p7wFa1B/1abqxx64Fwsfi
         371Dseh8v2KvkWCawklVOf0el8gtNQ5PQ8e0QvudC5g9hbiQtfx38c60HW7KwUMjUq6s
         yF3FUd4475WX591KfyByDNF+B3RxHc/TPW19hJ8wFo5iKYPAePB02WMRI5QLNHep+lvC
         0z+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778608526; x=1779213326; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTM+TwJvhC/LItMQbPLjDuaF4442XP50+NLVEyOxAWU=;
        b=rK9NMs3XF2nTQgwSze0ewcrTg+F0RlyB4t90FMB224Mt3ZrjATDVGfEVKaJIlbXYWS
         5CtIZpFDQpKSAV0ZbEWf3WAmgxetsgmJRgSBpfs7rqqCykMToNG42BWzEbVlnYButawR
         xRD8rzjEu7gdmOp3CxlaoG4u7CiasO2KYiO+h3ty8AWB43TlAxJBtG7BtyseEdrFa5Ru
         LZXufipVsB5XWx21sBGGa+YeYb0ypINTlrXjNGV9mLgHWflangGOyRqESLMt1PtRunmX
         CzcYNzEdlpcrXIcmFmaZU9T4aOjPK7tDeH72BZyT+MVE+BlMqY1nBixQpKy5HVd1STPX
         PNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778608526; x=1779213326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZTM+TwJvhC/LItMQbPLjDuaF4442XP50+NLVEyOxAWU=;
        b=glp0/Ft4yhY8BvyjavIW+3Q1pmRmldCrCxl1Ww5QM+LD80/QU55Erhbxh1wJNyhqWR
         P6SBVSMjBfQEHOstbQBjEgRh2tD49BbbwBkOKgUasczosSVHu6vOhl+RgI6bRBdMLHBN
         msf9epB7g8p9DUUdcM8jfELiKyKn6vAU4eAgWeiZfI4cGStKkwD/sQMDaF6Kt+aH1fSX
         LYAqbwcZ1veMdH8mWxrJDcz0cY/H/w98tMnIK1sur1C/3StF2c478IPIX/vtDjkXB1Y1
         Uzn2LCfonY8nr2b1pu/dbUXOI3VPfA0wXtOasYZ1RD3LIcdfbfTn/6JvxpA9V+9+JALC
         sbFA==
X-Gm-Message-State: AOJu0YwmFredlMwEsgLi7BtDMQZjhKljTfNbOw6rbQWm/wBiokauc3F7
	/uAorrNBVeIURJe6v4Uh04tQmOPvtSkeB/7z0iLr8ASASs06RZQ2vAB+DIubNkFyTuMqHesat5e
	uqex1wYB9G9MEw7SAYAXWUyI+MkxWpO4=
X-Gm-Gg: Acq92OG1vY4QyOJxSTs/ijW9ZO1CcDofbO3xRyAZ5KgZ3JJ0x6cKPHM1/i1RdJ2RcJ6
	zGUUDBKpJNcp6R12NYQsvXryWB2cR4U31Mp1cqUAUXhjLF4GA5yXRid0No6ioI9HQxE6ZK3oBf1
	yTSfDMzQ3CSiR9+r4Hfu9bib5aJUokMuXvI4BBBjrqyznly40K666Y0K9oe86VyB35FcdNdccyc
	k/YCDgPHvvgi7Aken7h/T2lbMFfGIDqauZ3kKw+kTH5mPTj83OmFB0eCSoIRpqVV43tUFYfjeIh
	EuaShhfQQjj9PQ5E+PLSfAJonnShG97S8KpaRqPZ
X-Received: by 2002:a17:906:fd87:b0:ba6:5728:39f7 with SMTP id
 a640c23a62f3a-bc56c72d5ffmr1809514666b.27.1778608525528; Tue, 12 May 2026
 10:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-4-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-4-baoquan.he@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 May 2026 01:54:49 +0800
X-Gm-Features: AVHnY4JTjgUftUZpn4vshSoyN9eYMzVKeYGMlwGJqlSc2Z9MMDwWttDq03zqmmA
Message-ID: <CAMgjq7A_u+hm=ySqYR1CDrjXJWis+RVDBKkeQC-aNWs62R3URw@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, baohua@kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C93BA0007
X-Rspamd-Server: rspam06
X-Stat-Signature: dafsrreugkmeqfg3z59kjoqysemx178t
X-HE-Tag: 1778608527-631344
X-HE-Meta: U2FsdGVkX1+kRdYt1LomZZAwW7v5TuTWBmJ4tUarTIR9qqBXtZk3Zs304uihxQsuEA7gKHPiDZPfAWp9BwL4dvBQ7MEf6T4UmnyP3reGYemkDxkufDIcZ6duc9vC6Bv+0m79iFxpm2/3wdKFC4YnJ63K1Pbv21OhesIkN11w0TusHSldHuwFsO2Wn58+WX3J7mENMTcJbxxEGm3tYLNG1Ekj/rXIusBkRdoq+cvIoI9ot7VhpAfnfnXlHszCZGdSvWaySIk997L5h0iF5o/pBFdkjtfs8slFsyU+VglwCrnMtFw4YgXzagpMhor9xT2RNIKX0HG70BR7w0eP76LGIIJ/M7r8l4gdFPR7jTwirH0+3ll/3iE1dLhnuJ47N6H1qw9VKJs/Q4N4I+cGt70TjA3/LwZ/PBH3EO6+JdNvTjQdrE1OHdnlgDv4MBYyweo6Vcx92alSxaPd1pLAGU3Yr+k7RmOFoD3FwgqpoAaxZVTXPb7WvAvBYY55gZnQNKwxc3pRhZhW+NfHVhHmHb3YJfcXGKNRnfBEZ0OqYlgX8Y1C+/XmY1RY5yZuFfGZ6I3HT9fVUlcPSwcGHAMoMxVA92GG99k/rZuzOcPpnuGTqTjVd6upnFfupDsDLZtTCu9ES+d908p0/bz8ypfVcGQoZ+qIRZxhsC9tYfIa9H3x212lXB2tZJAB2AWI1/EfvjmWzHZg4n73qRdkW+ogiK5l6gm0jNlepiQe6vvODqfWU++j2yU2hYgy/9+SPZZkHR+ROW6AYGuvI7+70v+1mE5mF8rNUmCOMYOk1pG1Akryjlnj1B1IpyX3N4LsclmitQivO0H9jP/c2ggmIq00WanbspYpZkhzY+aco7i3sQL6j3huw6797Tf0mlU2Z5XgkWH0Rl2cHMQeWldXHiS4xTIlle4ApEXwT7hj7Q4F10mxZkVKkM+JByHIomksftz/6ySN9cm1BMb0+x2DW49JFFN
 Z9KTQXfG
 YkdQQfth0Enk9SUnF9nroewmWflIHUYe9MEDXiKOUQ3xUB/tp6TVqGcvc0gPHjvb4zkclhks6orDj43ChdeZdm4i2Mikq9vv7LS4b0umkG7bIJ8ki0BadWjuEEVn4YpJxeL23xGHolpc+pkyScvUCiIrYMOkvSge4HbuefMEhi/RNx7/9XzbrnSso3AVgtVf51yGuqyTUI6lSg/TK5lzTush1JQYqgos/g08kTxBd/it/97h7eSjIsM1KYHHjO34TVvoqZ8OU+48UNVCh44isGHhs2u9pdEQGIabaLme58qzP7toKeL6OZUz9S6PhuKalHrWwlJxCAIouTgDArYm1PobHvyo12FAzs0UWNFJSgpaqjogy3V+HUkpDU+za3EikMhQuazJGpbtn7ycCxMHn9dzats3KhZnr+RN98jnSl4fwjc/cL5YIra+xow+x8d5SuRtJA3fclPKwK61HV+R2qnyUpTLBLk9soEpZylGmJmek9x2K5+EgSVqy9pSAxWaT/B0HRb2TGOV3gmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 6:42=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> All these swap_writepage_* functions handle a passed-in folio,
> not a page. This renaming makes them consistent with their
> counterpart swap_read_folio_* functions.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  mm/swap_io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Acked-by: Kairui Song <kasong@tencent.com>

