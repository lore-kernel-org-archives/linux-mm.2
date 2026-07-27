Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FC9C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289D96B00D6; Mon, 27 Jul 2026 11:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BC26B00D7; Mon, 27 Jul 2026 11:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B966B00D8; Mon, 27 Jul 2026 11:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D67D76B00D6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:54:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A2E04063C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:54:34 +0000 (UTC)
X-FDA: 85035004068.27.FA0DDE2
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 764231A0002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:54:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dygq4SCI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=uqbarz@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmKvKNorZ8eo+0x1SEqZhPBbNO5fNI3ul2oMmN5RAsg=;
	b=yPH8Dv1FdSOXgMKzhdApfabATiHZz/XG6ElhsSJ/ZY5b5uGwS0NCQ+UTCpc+9rHMHof/CL
	L9kCO5FHgIsjm/LLiXPbEFSxHCFarGTngRjL0CmncjbDo0v7qYWz8LAhGcxuviOirhp5fu
	czw5dSTjM8/sfGJP87qhd7bP/gRSudA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dygq4SCI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=uqbarz@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785167672;
	b=C4hRTuwof1qUiEvhQTK7Z379zPZ2A/IoUQRd2KtGC+xv7FZaBihSN9pxU7bOTk9gObeYD7
	knAJLlYLpe6QYXtx9CGBJQqmfidLn0t8QjrAKUrP5ZGw/QzUGKVnAwj1F1sdb+OzMS3dYl
	0HbwT3JozIEwbrWAsXWr0690j+3837w=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso19721655e9.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785167671; cv=none;
        d=google.com; s=arc-20260327;
        b=HixZDVDpJikWcDax/w/t+iopRvJHwMJ3F3/ICjEU4rQCg35ojwqtL17s6w3OsgcZMO
         iONL/f35vHEbHP3FUZZPJhVHcDCtMTaSsfYEo09fK5w7UGG5VOA5Pq/VyV8hhSyI/vPV
         wRmA/t7PcAYeEyggVC3CvZ5shKSn9Y25ktsCmNo0Q7MUyD7ysuy5E3xXk9FQdn2Auz/v
         gNgpT/qM1rV9bRPh9YjvPb55HkHhNd8PtbE8aQgNzTXFl68M2W2SlTeMrrQdcfCKlSCz
         gGkJ2GKhAIq+f+9jUWeO2C1KZnXQBpHVX5A1HkbmjwDr4EtOdyrc6cR5y9LNjYxPtzp9
         d1yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RmKvKNorZ8eo+0x1SEqZhPBbNO5fNI3ul2oMmN5RAsg=;
        fh=nP2+jNJS8MDIfG4WTLNxaEc9LKJPq343li2lx+V4emo=;
        b=pliOO90uOCX1uk6/6iuZhsDFDU4SqowhSYydWVchysFHKvNm32aVkJ0BVZd7SnsSLq
         nuRmw7a2EdnmMNfvt5FnFuPl7SlxqP3iLAno+ulJ4gYAhMq3mXN5Jcymc5XWXao5efXO
         Avv+J1rE0eGjRcGnaw6w/+6XanZ8sPFlY6LbBK2RZ/7Ia3SbyDF6VPwXinUSbGnMFMXZ
         vTOe/iUtlCMCyqof/pUSKwX89GjKJpY/3ukVQ4k9nl5Cd3ejr/WOz/HTXvu4/Zvolshn
         waZrF5B/T9cUzIbor/ewgh61rifgBGdp+Gpv3yX+ZjWmLfsU3c9Z22RPpKVE6eP3Qkcn
         KmcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785167671; x=1785772471; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RmKvKNorZ8eo+0x1SEqZhPBbNO5fNI3ul2oMmN5RAsg=;
        b=dygq4SCIJXNfhJVx+x00hS00JFE503fahbw+Lja4saJ038sz+A4RUgE7XsBLILjc6e
         AmpPM5rdCcvssbCm178TbCD1cEe96mZ8almfhZgjrYXVtEpXhbVmm7w0dGE0qUzD6Jcl
         //uriOOoJmoFdknOnW3NYQJsYdDltLZvyxkNb3XBnyOudM4P38h00KP597194yETpmLo
         Rd/IFSUS8Cqj7n4+z3vE2jMmyQBQXp04FByFyhG6QvFnIwGDdOaOqm+cpPOaFLYBIl8b
         Oe4U737RHf5q/U0y4eLTP/pAIqMtwkKfupJsIOxq/w+Kg3bGiwppAXtY9VsbQHxCjXqy
         vtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785167671; x=1785772471;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RmKvKNorZ8eo+0x1SEqZhPBbNO5fNI3ul2oMmN5RAsg=;
        b=IqMI4blTWVSGsV/mKvyY11G+upA8S217SpN8+vrxqdUNYzEuTqUy0aWrWrE77nuHsS
         xLc4V2BG0xt8SHujOo8JxkSXAfuhlLmwapyWsScTYWld9Xergh+ELyOdAJyJn6I4ZMaX
         5NcBcyJfXAxof9NnycO//JijO/E9/UqHIPPHQT1hy6pyGXu6g14vcLIJAFqqRpBS5cYU
         dYWVoxq8l9Rg8AFzWxLcD3MIIdDnMhyrHo3LmX+CYE9iq2Z3By1vqFYUnxb73VcG1CTi
         VvHJ8ICDhYw47n3bWGrFDbkNWWenPBrqbout+ywuSg2cAj0C5kXVcg8jFQh5raOv4ole
         4fAg==
X-Forwarded-Encrypted: i=1; AHgh+Rpl14c0c7wLSkhrHuUlcBm0h/X+sL0xEOE90LD5+Mpety0/93D4gjwmE/b4nclvAGyDiCaPxC0o/Q==@kvack.org
X-Gm-Message-State: AOJu0Yzxr0L49270q08mdO3HhGhgJq4yv71KN+wwh8qNbezTU/eTid9d
	machXYTzEaRy0WNEyEdzLIe4CeVmWnr7d7aMsE1oZAGFhrxw4a/G6GhhVtyvUxvPt79JAfoUUJ5
	SDyTvewhfcAFFbj0iFI+xF36Gy8co7iI=
X-Gm-Gg: AR+sD12nVzixIV/iLQ86wIpEmSOs34q0jS5k3rEqKkmho7YFk+lcUV0G3ZHQc2ujv8o
	OzsOgKidg6g4XSEz5BVu9mWPE25e4DlhT2npfq8rA9ItGwLitSR5mJpWmlz0+2a5Q9UdsFChFz1
	DH87wbRpNOfyAfkIXGA4hFVvGKAGaACCIuGYyCIet9hZqchYUwZNFUEeD1X8ajzYD7r01yAMXzy
	UYQS7cbwOPCEOam1Vkh/du3i49Hn7bVKO0hDNznu2KtaW2+oFx3Cyjp3bMlksOpzjsbkv5HTXE=
X-Received: by 2002:a05:600c:8485:b0:495:5943:b76c with SMTP id
 5b1f17b1804b1-496b57281a2mr118833645e9.34.1785167670709; Mon, 27 Jul 2026
 08:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <4146d4f5-c8fb-42cf-9dc8-a9d4c26055da@kernel.org>
 <20260727154001.4102341-1-uqbarz@gmail.com> <amd8LmZdA6SPMAtE@lucifer>
In-Reply-To: <amd8LmZdA6SPMAtE@lucifer>
From: Hengbin Zhang <uqbarz@gmail.com>
Date: Mon, 27 Jul 2026 23:54:19 +0800
X-Gm-Features: AUfX_mx4SPdCoHFxdTYlk8762rdsunOP0VsEn87w1iHDyKzzeYQ2VdFY8P-8v8s
Message-ID: <CAMRBeLjwWJrqtFQpCoUMqOXTfi8Rk+-jS3O8WK7DDgL8QuYGbg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm/thp: serialize huge-zero folio state transitions
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: multipart/alternative; boundary="000000000000e090de065799bce0"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 764231A0002
X-Rspam-User: 
X-Stat-Signature: aymfauunekfqxeezqihxrcga5xdmez6o
X-HE-Tag: 1785167672-56036
X-HE-Meta: U2FsdGVkX1+UheF3O0d4+yGQHWDNWyDr05UbGEefn2cAkz52PNOM/zlMyBJmEiWEpeNtWzWpPiq7a+nCa+q9uDk2kcxkXLOACjCQGPlyeE2QVvStuMxXl+HJ68vA7J4oxYDilSeWeIAVeNsqmK+rw+6TKt8pYRR/JC4LkHLmBE23HSsYmZWEfS6H+JV5HyUVMvOA1dufGCH6O4N4/EaepBh9Xwwb6aEkCNzEknGwheNzl51sOfO5uNKaVDjzxO+JGVjGnxw+vq2tuJHmUaVANXNFw6O+afhNIfgsFQmX+HcauuOkABSpWZOB82VtqKyGaYfxaqfnSwd0DVOIFXpnJkpTbAL7dpUdjsdZUqr9N+onf2/j5kQ1Zeoi5WPSkC6VfguQIWOXAHLUdMoQOfJvbBxYrBvtSn/Uiherw9BXKVJa95HxU9MYVXnovnIMB+TsXwcrIzpQHeDKl/LY6vFjCwDZNaRk1RKSa1vMpIsS/fc5muCeDuQfxiptKGW2QCUZ5qRxVJ1lRWZ+0GjOX4fPFEAH9+7vQ6vADpIrkKdwi8hjMSl7ixLJUVqED3rhjS7bHvY+8BZ7Yu/JQLXY4FNJHn1LCDNTENpf1rcuLCS4t/mhaIlgYZvQ7Nd/uciQnbjzgd/kdlC/8PfZEhDAeIHYMFpuRZmswv9RZJNwYFCEQ9ZwI8GhJ/jJVp/dcU5/FPMgve11kCl3Ppzx6in2uhCmDgMhCMMxRZ/NzG6d1nPLMhyGX629vQDDGKLo64GZWAt1BKHn4lsSBNBB3sGiTK83yaD4RJCorvonY9bxFNxGUtkxcwMsF7eOFd0mKYSioEOsnWCzn6gw9hnVLGeyscxw7ATYQl8nSUMHunGpeaKh/g58Vrv1Jj9gT80anTOGIk4TpCFO23pFo8zvtJdqt+UsjNcc5MtTPmjoH3Fz60RRma++BkJuCCESr8ITAkL3RBlmMNjdYQUgwWqb/oV8QUG
 p4QHF/wc
 j/6trMpf7VMdDpYD/NqpS+UsTmCBezx+M5FkLIgSXiessEMTZznFqCKqrjj5gy+jPgllf11bTriEGa2eD2Z8CZSKE5UcBF5d2wBqkO1IL84djk0BB2HKVLyd8MoGQCKBid3FwQGpvrK25WZ684IvfTL3LvNaJbScUG9rJC6y4+1709Djoxp/iAhP50BQX+uUfOpW42VHkfZRyEjkVetR0T3Og4zD4+8ny/A/hFHDQIHM79261WkQwy6+FseCO0ho0u10YCCMk1RsLrA8ZJI0ppmct2gISQIfTRRr55RhgY0fsEwFEHFq9NO3G5cvyOo180XQu6nfZxtkv4nsS/MU+vWvd7wMLkZE+4quqII4V84/jMgwmswhAs38781iJHKnCOaqDPZrN6b6Rd4p3pkE7SP3y5bf3/anfuNmzIZPwnILTXN48fmQau5xUIu4l07x8ttvdkzoLPEAnk/u9VLABwz35NbUJnVE69KO6CjjbWqK4TkEZ7KVxw3q6jYUWaFgPuX5AGG8J6RJ5rKZy/0QkgWtmSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000e090de065799bce0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Lorenzo,

Thanks for the reminder. I apologize for not following the expected
submission workflow.

I'm new to the community and will ensure future revisions are sent as
separate emails after responding to reviews. I will also allow sufficient
time between revisions so reviewers can follow up and provide feedback.

Thanks again for your guidance and patience.

Best regards,
Hengbin

On Mon, Jul 27, 2026 at 11:43=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org>
wrote:

> Please stop sending new revisions in response to review!
>
> Respond to the review, then send the new revision as an entirely separate
> email.
>
> Also do not respin this quickly, leave at least a delay of a day between
> respins
> so people can have a chance to keep track and review, the workload is hig=
h
> enough already.
>
> Thanks, Lorenzo
>

--000000000000e090de065799bce0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p class=3D"gmail-isSelectedEnd">Hi Lorenzo,</p><p class=
=3D"gmail-isSelectedEnd">Thanks for the reminder. I apologize for not follo=
wing the expected submission workflow.</p><p class=3D"gmail-isSelectedEnd">=
I&#39;m new to the community and will ensure future revisions are sent as s=
eparate emails after responding to reviews. I will also allow sufficient ti=
me between revisions so reviewers can follow up and provide feedback.</p><p=
 class=3D"gmail-isSelectedEnd">Thanks again for your guidance and patience.=
</p><p>Best regards,<br>Hengbin</p></div><br><div class=3D"gmail_quote gmai=
l_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Jul 27, 20=
26 at 11:43=E2=80=AFPM Lorenzo Stoakes (ARM) &lt;<a href=3D"mailto:ljs@kern=
el.org">ljs@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">Please stop sending new revisions in response to revi=
ew!<br>
<br>
Respond to the review, then send the new revision as an entirely separate e=
mail.<br>
<br>
Also do not respin this quickly, leave at least a delay of a day between re=
spins<br>
so people can have a chance to keep track and review, the workload is high<=
br>
enough already.<br>
<br>
Thanks, Lorenzo<br>
</blockquote></div>

--000000000000e090de065799bce0--

