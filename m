Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B322C10F286F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 21:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77BB6B008C; Fri, 27 Mar 2026 17:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28306B0095; Fri, 27 Mar 2026 17:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16ED6B0096; Fri, 27 Mar 2026 17:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0A866B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:15:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BB825EED8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:15:29 +0000 (UTC)
X-FDA: 84593099178.19.81B5C42
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C101140002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:15:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C2+73Eka;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=yuanchu@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774646127; a=rsa-sha256;
	cv=pass;
	b=DmcwIGBJkbSfHWySkh8CtF72BtG3myVMTbqsPZDzDv5hEqydZ+VUDEKM+NrCPYzkxZfokF
	q9ZObNw5raHz44iPke1grYkRCAMV81yTIItHwpWejybFCytazHleMQeYkyO8olJRluSZuO
	EW7LCS7eJtoaf2x14bjIYCtAHMTWJ8g=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C2+73Eka;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=yuanchu@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774646127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9G+l7JxKzfAroZ1agVjVRKGd8W2oxjDhIIqYa6p0iFI=;
	b=2sEGcS1aYQVtPrkfc0gHps6hSkYPis3bkdYdq5hsDT5tKDb1+cvmsnTu13zm+Svt4VE0Iq
	bKShig37YmomPUGQ1DP9V+wzp5iTuXGbhCPvuDHmPzrzhZCKfTnH7Ha6/MWE2ubu8Mv2ea
	BmJMtbxS/+z1oXfAnEi4hNLXzIaMNoM=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1270f10a774so1001c88.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774646126; cv=none;
        d=google.com; s=arc-20240605;
        b=EAelozlrD93ylR/46bntLgF7lk1li1p5UIlZQh6qgVMF2g0eSkYLcuF/VITf8wQs3v
         9YriFFOZPY1t4DVfIB9PpwAqNF68aDA82TxN/Fy3i2uTTuiW7anJF4slCMWSJGXUEYMP
         5jDKX0gDqJxT+M5yMum6w4NDHWMu0lxV9I9HiTj17u6CKnRYGx5qC6xomOD2RphePCmw
         /WP/cBMcPJxPjBbt/m5JtPmxlNa7Dwa4traNi7VWjv2fuY67ZuVpZ/l8AqRr9I9FIWaV
         74fRiqCTrnEcHcRYsc/0q96OpN5K2XlmEKN1vsjsJCYzh0urLo2pnIHJZM7ZN3n71vW9
         8Giw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9G+l7JxKzfAroZ1agVjVRKGd8W2oxjDhIIqYa6p0iFI=;
        fh=ulzglL6pCpNY5B7EZoDbwuZh5Z9a2knqhhvWmJXcBjI=;
        b=FtqK3xO7sM1QzlWiWU/aWi80nWK9hOfFyy7hLCX3vaiV8iG3n5UQ6S2d+8eanlDlp9
         8czxaVD0lnveD6UUU/AbgrO8/QvxRMPxsntCLLkrrzIMlRE2hOz75lzxk5ei9MtbVNsQ
         FwRNHLyO6lu+cYngzV5nmtPF70JMJSiFeeJsgS/L/ErUfXkByh6Qn7LMMcu2tfWCEn+1
         N0M3+SY7Nb/1xFTDxJipXrciPi8nGcuhFP5sldbaYLd/V0drB4NLfKBrpopLyLTiC3im
         j+uWMX1QL+ig3+wcREZoVuDP2mXlGLxWVaR9LsogYZjPrU1a7x2lXaxUmQx32h4A3mPd
         HFtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774646126; x=1775250926; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9G+l7JxKzfAroZ1agVjVRKGd8W2oxjDhIIqYa6p0iFI=;
        b=C2+73Eka+wl1+7SccYQs/9W4vZ+HraBajN2NEA6KzpP4Jh9RuEJ6ZCFgxebTad3dh+
         DGlCxuo+54PEXaPOTTOUtGRtH1jiCh9VEcqCgxYAFiv6s2/m+kf2h0K5O48Fw482sjbM
         Wx1YOeGO6i880W9mCICdzxNb5PEx7JtICMuV+qxg3ebvEEZqnwoSisG3dtEoZW3Eq5bt
         U0n2+CZbQzS7KDtHqdfbZoFOhV8LplATdvj53KE9surrcyonizYtc/ACn5LWchGXBBks
         84H1BkVsoarJUzryb1QFh5kfLKSyA8HWkx8ikd8gdeRoUwFh2Ooo4pizFrgxpJIla4tX
         0mqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774646126; x=1775250926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9G+l7JxKzfAroZ1agVjVRKGd8W2oxjDhIIqYa6p0iFI=;
        b=dWK8pgsovWZK9VY2pXRKUaHoj0by0II4Fn2aTUTFAjphKPHkue1dOG/OrnB4+wqWgu
         d2cBMUM46qdH5EiP6KYUTKPUIABOFetgOsJ23S8xE+fhJcTgg1Q7NXK54uNqufYzO+Qi
         I3lkot49TuR9vaWRPOr3LqaHxD2XIdxA/71m7K1gwah8SPSXRXYL150IH5JOH+FXhOkU
         n6RadLSpmy6uLLTmIB3yNQo54WbmiTdLyXPWj9Jsouir3B7s9pdhcG9OXYzeEm3Lkp5Z
         UcAtIT0CtA7kZIYm4dlhsySJ/kgTU3kxXp7PD5ymf8EFtKtPVB4CCT0GGrU5X24pVAmA
         2lzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCEXqc4I3kTLe7jrQy+ss9mBdqhrRR/eNUYseRDza8j974qWuV1KRU2Hr2GmNgy7zgTt+ZZz/ETA==@kvack.org
X-Gm-Message-State: AOJu0YzCvfXckAal85jGFPZ/nT0CTTep3ZGnYsgGyTP4AF0edjirMPFv
	e5374XSYUcRP6SlkUO5khM5mHZ4oKjQ65tQTS2dr+7ZirFxeO0njZW1Q6OHRK2fsgpdMY1eiEex
	jQkvvJMm7hl3u+e2p2nxUcKUTo4P0p/2sdR1jEwV5
X-Gm-Gg: ATEYQzy47pmdgi8UtMc+OD/sDLmp8vFW/EbKTFgnpaPrwemZEevFC2U5VPhqyBtdQwj
	G5C3HFy9RSjAoMISn2gQMHfU8NfUSTp8NgKvB1i76rcQEOqsCO3n+LJms+CLn8+KoMb2w7v0iY/
	sr9FgdylKBD768m2RihfSGAbcdxf/qF0vxhTQy1kBtKIuw2hNtAzXZRF6aPkTO0FVEQkIsYuMql
	B5TjOwBeXTBBabKcmKRADuolBC/6Ql3cb16be77d0mX8gEkeRTBuk/wGpieEgUP6kBCX8RtjBAp
	xxuIT1LeQ+N785toLgwsZ2dCgyk0qqQeMxyq
X-Received: by 2002:a05:7022:628e:b0:12a:8cf4:6506 with SMTP id
 a92af1059eb24-12ab9337654mr57740c88.4.1774646125355; Fri, 27 Mar 2026
 14:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260326185629.355476-1-ljs@kernel.org>
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
From: Yuanchu Xie <yuanchu@google.com>
Date: Fri, 27 Mar 2026 16:15:09 -0500
X-Gm-Features: AQROBzCrNAVLZaQ9D7prHvS74ONazG-7POQd4caXsR5ejJtdE2C7LuszPo3OrCA
Message-ID: <CAJj2-QG-z9uETNMeWmnp_F3BoVM1up9q1W3NO8-MJ9ddehVXQw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C101140002
X-Stat-Signature: xqgjscgyajfm7ygh6fug3caba9k6jd9c
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774646127-383671
X-HE-Meta: U2FsdGVkX19x2PsNgkl7RcHp1vVJYc5HeB+KP3j6Fkf0wrzqMxrCrV1EMTJGn6qTCjyPhPGlfElmMy9b74DM6Rdpg/Psi+EMTndg0WBzY/y0v6tfb0ix6Yy1jMkrmEIRvWdaP+Ahz8qTs3wfgV6fqWULt9zssqd6x/ozpy2ICn+ixnNSbSgH61ALpqtX9uYMJe2aU/q+r2Ot7NvrXagyvgYhzIlP/DAcG14n/yXrAFjuh1AoGL7pqUyXtcSkUB72BSzXb6PEa+Uv2aZvvibTmz3ySNNbHoBJvazUBxoqImXxNU3SrUOkQRsGXXf4L3ftqlI3JaBOjEtCx2AWAQQ24T1x3kLon8QB4TzYZNoFWu2Qdyut3SW3i/P2JrSr6PitRQEUNZC8IS1fm7I4KZ97vdL43XM2GejmK/5Y5i++x07IV5beoTIE2He6DJgBVT3E1RNQ1KkQYoNnKJMjxv149GHbCyK89xGiccfNzQSFdG6FS4tVhEyxf4YQuXu593ocvPMQ81cV6L2hMedPMjzzrWyED84JaorzGneV0zLVUf3ET9vV/XIY2clToF7nYnqcws1695WO/1IL4rco4FxSZaZyxNGhPqt3t80Elentzy43p9Wl20yY6+TmI4qxS8ErS1yKquWMayoYlRSj5DSb+hhAvdUgi3QbmZU6W85di/uXLE9+Mc7DQMcqfK+GyHDhmaEkT0bjd7afcqtPYHbicpzkcrg+Q7WXR1ukGdFizSwf/CPkm3+7Jkn58kYZzMw4SjpmjynhUXSaeVZn2fKBsyJeUQoVcLdAsuDKgc4hBwUbvc5CFX9TB5wLU/HQPbX++Kz1izuBnmR83qUpEfjL3HUbcAk18X04gNrAmvt784otsYQ9iUKVUL1g1Wah66MJjR2RgcyvHidafV4ApOSMkRNBF1k7rvwGgb4eL2UxAXiIERPHeQz1rB4RPo8GJlT17kC0DNP+7z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 1:56=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> We are moving to a far more proactive model of maintainership within mm a=
nd
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
>
> The MGLRU has not had much activity since being added to the kernel and t=
he
> current maintainers who kindly stepped up have unfortunately not been abl=
e
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
>
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.
>
> At this time nobody is quite exercising the maintainer role in this area =
of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant wo=
rk
> or review.
>
> Therefore add further reviewers, and at this stage - to reflect the reali=
ty
> on the ground - we will not have any sub-maintainers listed at all.
>
> Each of the files listed are shared with other sections in MAINTAINERS, s=
o
> this doesn't reduce sub-maintainer coverage.
Yep, thanks for proposing this change. That all makes sense to me.

Acked-by: Yuanchu Xie <yuanchu@google.com>

