Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDEACCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53CA80090; Mon, 27 Oct 2025 15:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B8B8000A; Mon, 27 Oct 2025 15:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67D580090; Mon, 27 Oct 2025 15:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C565D8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:51:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69AEE1601DF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:51:33 +0000 (UTC)
X-FDA: 84044938866.02.3B59FCA
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 799F2A0012
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:51:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KHzMkrlU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761594691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUw2mZCfH1yOBKTSy9rxXAh/jPqUNSJVBaTxVdNrEJg=;
	b=opuKpY6sm8ap56vAWpDeGcdLc3aAHFFyaV7B5qDsCRjqOdOao7h+2FKJ3lXSdCOUXKGSsT
	2e9kaD4/kg42iMsh/qTFtLheBoChHe28F3nTSsO9m3wQkI0Jb30MmGdiG5PlkUKR8ETVGj
	YwHncmzihGymfZ0iG9idK2wSbpRcVxw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KHzMkrlU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761594691; a=rsa-sha256;
	cv=none;
	b=5wwMJbq5Lg5SJ+CpErw8MUBgwyhEGaPgODTRnkp21wIVdxXeYxGwXx98hyCgbWjL4oVBPm
	ieWGsCBwcwdoXDN0uWxeFkh4/Uj6TYe8LM0bwnHak7ARLL93npM9vBQJ6n+S7gEu9Awld7
	Tt0Fsx+Y+BwWXv1EFBzH1yZz1rmHHsM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4eccff716f4so76771cf.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761594690; x=1762199490; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUw2mZCfH1yOBKTSy9rxXAh/jPqUNSJVBaTxVdNrEJg=;
        b=KHzMkrlUfwKmA/qagRoKnIoMBLUASDPu4eEX2FWRQQ0Lmodx94qjeD/xgt9pRAheEh
         fnDsrudNhIFmYWQEsveT283H21nRM7sSkOTvUxP7iZ+7ww9nXMdg4pyfcJ3q1D1B7Rhf
         0Eg7nUdMQefys8EACCAZ/g3I3iEILaoVW0LkqJ7ypMNgxxpzBfAi40S/NXao6yX6VcZl
         eKGG6IaMGXT3ra+YNiTx4YkbVwya3v7wKyDVAekZClvxYhheS8Y3ItF7og0J2jB42C53
         xjNkkXeCN1jx7vblAN6XsqO7IniwSca29JdU1xOIwlXTnFaEH59VTZ+FolG8MlXSmu2k
         y/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761594690; x=1762199490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUw2mZCfH1yOBKTSy9rxXAh/jPqUNSJVBaTxVdNrEJg=;
        b=vNHGDqk+E8C/Ua+5iMQ797K6XxkpDQMr133y27cvThRLYkIwklLaerwI2/qeQqmryT
         2ld0210l8ZQZigfhnzkh0OD4KgAkVC1ALnH+p/vMOrxvqBU8ih+FTCFW5FffN7q3Kt6i
         UZBs8tfFmQTgMwHMjPLXoINjZ5YiCMM5TQr2qyAkMJpwUlD6BLthdzab3s3EhLjl08xg
         VRjr2PrIVWOaDc2BA31kNFsRFyL38QvWgusWafSWrgYY/bwnlWDOT7Nl6vOSfTdPQ5L8
         wzqCil6XSwgJZ8LW48OSzWsXV95DqMYhSmY5pdSr/RD3dH5UbNpPskuXsIXrSp7OHq9I
         WIHg==
X-Forwarded-Encrypted: i=1; AJvYcCWNaB6lU2qXGjrlB4H0YoTwdpuYrzh2AVHruE2O//L8Bllqpk3ahC5hZ4jf7C+BJoNR9JiajvjW+g==@kvack.org
X-Gm-Message-State: AOJu0YyzxW8JGkBgy7GxixZoq/Wx8zSewBzuVeTADEXEwRa0HiiYjDZf
	H1ALaiYWkkbWuokTTIUNhtm4VXD8cswZA28W9lBh3nCcdXPlJbp4AO8xNHOlNmxcbVZAJO4QGwW
	xSoA2oTt1DqutcczAToTg+4dLcb4U0wFTf/ArdpA0
X-Gm-Gg: ASbGncszf1huD4WUbrSnHRtOaUuFyr12arVQ1Id8dxGR075qyIOmRuXMJz9L4yh3+09
	HwsGmjJWh1s9YRGfPTV0W+6CPa5OYIKnhQKT6fC1OL/Qi+H8c+neRXur0dXoHOzWWmQMsRJIA+s
	bICSHkxf41ERtj2j7+vX0CrrV4QJDv82KNhCXvJWkHoalACcah/DhTTuFGys9ZL3PyQSYy6PldY
	SBhuf7p4ATOFrVtWIexBRkmKINZ7i9gDAWkiquZlNyHJbrkfdxNmp53YoYDRwxcw0iXGQ==
X-Google-Smtp-Source: AGHT+IEmicxEYEPLgQn38b6v1mJfTIvyLMT/qtHkmyMNLHlEBQmcYJx6gF8JYoLZrM0kAWrtv1hez5d7WlrSFzFFVW4=
X-Received: by 2002:ac8:7fcb:0:b0:4e8:b04a:82e3 with SMTP id
 d75a77b69052e-4ed08f1af35mr1416621cf.10.1761594690047; Mon, 27 Oct 2025
 12:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com> <aP8XMZ_DfJEvrNxL@infradead.org>
In-Reply-To: <aP8XMZ_DfJEvrNxL@infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Oct 2025 12:51:17 -0700
X-Gm-Features: AWmQ_blGO7QUW6nBgXPDBNUnzq3Ln5ah_SLow5ox4iXfcHmzA4G72ZsuhQ4Fq80
Message-ID: <CAJuCfpH1Nmnvmg--T2nYQ4r25pgJhDEo=2-GAXMjWaFU5vH7LQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Guaranteed CMA
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com, 
	robin.murphy@arm.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, minchan@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 799F2A0012
X-Rspamd-Server: rspam03
X-Stat-Signature: wjp5u88nqdrqbijkgfbmp67qjya4eyhp
X-HE-Tag: 1761594691-734492
X-HE-Meta: U2FsdGVkX19y+1DxMTE6yN0ctUfih7ptnek2xlBnnOZ1/+RcTHiGPZ6BoU4sPq1LL9QbEjsMZlyVGwkalnLL9gYmLs2IjWAi7WzNOUkFrd9Vv4g0kKTmMs/DEsr5L/cJDlYwzRW/nTwOb8hGrwA6DW+yaTr37BIzNadSB59VT5nkOHN/hT+YFCx1a+CKvWpfJMphmUIbozN7M4lJsgcB+odNpFUmIUb8p3CG4Orxs5ADDWdhLmfCVjed+WkXqn9z1iRugL2T43LlRRp0MiE6f/RCtfXF72NiOYSVUjupoTVDeleVXC869hTHfzT/CqkCJaAbkl9bdxyYJ2iVa8NF0HVb7Xfg+KoqW8cFiFB3im39+MiXz+I/mbUE9MySy4tfucUHnCa4qj7DJ7IhuCZHiphih/qyqbRVe12jiCSmVhlnPn2LpSX6zSvW25AsJPfF1coFgFHK9+rZz5etQiuaZL+VZEXNiWCUHqbirm+krFvLVMaGftcEoUO5l7n8FSi4koH5M1H8ZtgavNrDxHrE1tKEcqLavY/0gWyOzsuEQvk7tA8Qx7cbbdUcDA7/1CN/zBzgpcOv9qqnhKlri3c0PVZH9+g11BLCdpWixe9Wu5fKP8gYdb/dQG0yR6MVsTeSaUJgIqHeD4M4pN/nsHpfivmRVI77Be4oqWjx/lUtSw210lp1SRFaat3+gN5hOIBwxvjn5k9CJa1dm94WPj0Oqrr4FWENWVDfMbAfQK0sYPGzYtEyfcP64GWN8aJtEBX70OO1dt/pJlZeSd19IV7ZdczKGgzlSi0jREPLfSOJuEl1GHItX3YJr1kwA00yrSYS/alskW28tYvsGltvDe9a06BiFVlCU6uZfRzJqSdpBvRfg+zgI/pyBa548IlJRsXCydkbHeEoYmy7FhqE+aVWN7KU5ckVtHvenAkcQ5T2UwZ1Yh0Ev7DICVUFwoWMd/u1Tjhs+ACfyjvgWmxBQly
 LAoYkFHj
 fEDy5r+VVncXSZQY/UuorTkHEmeFGZFMVAqFuLYVBn2Vc7nWNbVDyaMBYRIUB8QzxwtWTDpgnbWI7aAVrkEjoMaeZJXiO15xoS/bAPksxVm6Wn2t0EqtL0wdNoDqQDuphAJ9VrdbnZW/qqwnPiySRNzHLOUB0tFw1OAr3o8OQu472BCnwfx3IFcG5keLuvTJ/kCE0kUhZj6yJ/BcjK352/bui0z/4acQT/0tYzjnJT2L2K78EWYA9ZMi6jhDR3ldB4wbvPsXC+i/7ah0+Ts5U3XtuqJVstohXU9HvnO9/VOJ9H+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 11:54=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> Hi Sure,
>
> jsut as last time please don't build empires with abstractions that
> don't have a single user, and instead directly wire up your CMA variant.
> Which actually allows to much more easily review both this submission
> and any future MM changes touching it.

Hi Christoph,
I'm guessing you missed my reply to your comment in the previous
submission: https://lore.kernel.org/all/CAJuCfpFs5aKv8E96YC_pasNjH6=3DeukTu=
S2X8f=3DnBGiiuE0Nwhg@mail.gmail.com/
Please check it out and follow up here or on the original thread.
Thanks,
Suren.


>

