Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF515CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7378E0140; Tue, 12 Aug 2025 09:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EDF8E00E5; Tue, 12 Aug 2025 09:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394E48E0140; Tue, 12 Aug 2025 09:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2656F8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:36:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD44FB8490
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:36:21 +0000 (UTC)
X-FDA: 83768204562.21.FE2E30B
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id D935F14000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:36:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VAD37SaL;
	spf=pass (imf23.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfeqLL6dQOkRGa+2qH5Nfx6sExnoJH9Br0Sq46snNaI=;
	b=5v1yjdcJvEQO1Wn2+pUmEk3Ib2ezNSZ/wLYsls8WuTDjlErEDKYRvcqxcssuRBuktHDR1d
	5zMqS/ISX/xXuwVQVb96roouA4s3Ikd9QrawixBP0VBdc/zmqtmbhESev7ef/EqrzyB5wE
	mLT/cw7WT6FbCtMyEaM8aOwPJ2Nv2c8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VAD37SaL;
	spf=pass (imf23.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005780; a=rsa-sha256;
	cv=none;
	b=DhSe1H1OmAPMUPx6jLvPyTngHHgsAKEIa1P3qQREUIHRa1wSCT+hBW9zTZKJDkvQaqIWu6
	cMmGxKmEe0VKS8ZnDUXI710mTW+tAiKoiMRtPkKrufUWTl/9g4y3vIqrqtf5EU+wzjyZad
	JiQGJ6hqIDyZyUhpRBaLaiq31UgyHSA=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b78a034f17so4148718f8f.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755005778; x=1755610578; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfeqLL6dQOkRGa+2qH5Nfx6sExnoJH9Br0Sq46snNaI=;
        b=VAD37SaLAesZgEB1eD8C9K1vQvd+Xf/2I+ROwh22vLWWITG81H0yk9LubMRxdNKIa1
         rxI46KvbnSYmBhoAVIrlORvSRHMhDPQ0Z8Uj5CTMq01d5x24RP7a3N4siPgYueWPJ4sR
         yj73XdVxlkZnXXl4gO4YdA8GwBYklWH6mZNq3EM3elM7iKnOckT/S1U73tvXsh+NRptl
         EnnBGSyMdre+VOIA7au8CtKNsTvaVOZJnIcVTkdY4jl87NX4i+E4Ceyq1iaP8UJLJoYB
         ym974/JnjB4Z/VV3SbPQzWAHjN46vAQIBL8idTdAT5o8lJBzroHdurIbQk7CnjLgZ4gw
         oJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755005778; x=1755610578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfeqLL6dQOkRGa+2qH5Nfx6sExnoJH9Br0Sq46snNaI=;
        b=ea1YSPjfF6DomzEwz5M8X9os+8wjbtYCfCuTktcwNH3ucPCmgtrfzhdfBA+rb320Ir
         q0jxa2XybXjnePR5amX1IKTGcD2g9q6Y/VZetRyfBI2OfTlnSRzXM5T0JcFYT/OvyyEw
         kc0gEEOijE43/3GVz+p8PwSo+wRX+M7EbBEbFyycA/QOjFf6/Ezj0O1Ytd68HnZmluUc
         W7LMhP+aXdIIslUzEfFloxJCFHlKCUpvWowa01Ubbq3YDaYoRDU4pjE9TX40pUjRifbm
         HBh7Noc+QRYZuGb85szmFQFVsb0OVMCet/faw7TXU7m5gGnsnc/GAvDK7g/otDnFII0K
         RUYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW3QU/+jw+9aFiiYIwDCXjR7wvV9RP2vIoBnyPdEn8BhGmQ4lTrqaI9r98Gm24pd1FOVy9G2/gvg==@kvack.org
X-Gm-Message-State: AOJu0YxLbNJrTO0+9LTOxxAt/Ba97QXTsn5JD9Ga6w5qgX5Fexj3ImUJ
	g7yS3iUbN165mH9fVWOzTzSk06GHzJafnvwoOgjte5VNkiZuJpNUYnsSRGLYDGIndMZOfF2mSF2
	MorqRzae5h/iLT91FSg0SFjs63IkI9dChqem3A0Ql
X-Gm-Gg: ASbGncsY/ZgmWBzIbeZ3N615UW3zmvSs0hUHMccNkOFG2p7+iPqd0dIeWjpVCEmxiEW
	GQPJAGPuIBNW3ykMC+dW/YqvhaQMsyxu/wheVPqBJcMXEFvfzDCVtlDWBNhxfbrS9ds2P+eQjj0
	oiW1mO713ZdxVJo071S8T54x8FCeqhHp0D84WUPX2fojwrIrxhY38YzWqFPAHBY9cRgIB8d8R8C
	zqyMhq936wOc7O6JDae2A8gfdvHdSs9rJtv2g==
X-Google-Smtp-Source: AGHT+IGvi39HzBKuKECl3B4URDI7XM1LzzhtHLRMHVg4OfVEDl7Qv4mmJaL0Z/gOx5HNOgcCpFj+tchSrBuJVnqWU6o=
X-Received: by 2002:a05:6000:2010:b0:3b7:9d83:5104 with SMTP id
 ffacd0b85a97d-3b900b83ce4mr14406064f8f.51.1755005778141; Tue, 12 Aug 2025
 06:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250812132712.61007-1-baptiste.lepers@gmail.com>
In-Reply-To: <20250812132712.61007-1-baptiste.lepers@gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 12 Aug 2025 15:36:06 +0200
X-Gm-Features: Ac12FXy01SQUE4GxmHxLMqxN5BkDGNIVt8wh-Nzq-CeDX_ijk0ldVPo5VW0VQoY
Message-ID: <CAH5fLgi4idH+bU-fQm-kup66+-oF2MkH5CDWp0jguHbkLHqU4Q@mail.gmail.com>
Subject: Re: [PATCH] rust: mm: Mark VmaNew as transparent
To: Baptiste Lepers <baptiste.lepers@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D935F14000B
X-Rspam-User: 
X-Stat-Signature: nff48zud9cf4d14exd4y7fpec5gorea4
X-Rspamd-Server: rspam09
X-HE-Tag: 1755005779-152779
X-HE-Meta: U2FsdGVkX18UiK/TuUtyAOXLxOah+DAqzlqtVL6eFXg8DcE7XABY/ME7izQrZn8V2kloXBYDBqkT677w2KCp347hdJ2u/4FZUyXZdzdo4i7mge/82bSilQbipmemdbWnmMXB9lbzleIeNnwn5N1KVH8lGcrVdg6p6FlocH2SbCN77YSgD8hnnD5gS5QvWQyIBYH4buwbS0R87uoa9d+q0gGtFC2utcFVoQ7jkfCDwro/sNGBldikl1iaDeyv2UEReTBFIh1r+kcBuWvM7OLOA66q5ALVDdIrmV10abRhOBMKUCfRKxeEUnb5j4kiKw2tP21c8gN/kq4qr/+i0325RcZZaRL1poiZRMDwusC4mZ5dQmI9IssjaL4jC+0lM4lbZfJP0W09ix9j79Pjrvex5zAcRHCLKEAfv6lG9V1eHghwVopBHKLyuf/+LYfeDDRv8OFcu/y3XhXbeFFspF6RvbNdJqUt2Jt6JFnXn2bPjCA1HFhNUI6ipWydOxn48zb+tUdTahDL8+hzmoL24+FAxLydkwufSakIOMslo51dipNScZRWL8mUj4Ht+IZGLAGmFH1sZfXdYx3Bty+KNPj1saMriUGt+yBmdWMKvNoznqo11SBSaqn3hWiZ4Gqr0BJSRBZKuNkMVJRX84cWmySIeodzTvKCo96pL1GJMpLBwBAHSu6gemSeUTCMd3oGpILn0Gf1t/ZWxwDsDgTbXvZKIE475f9/aYiDxGyI8+8wbrvMI/mUdXg47y6gjuz1mZHx9OqnYoTcgbuWEBOy2tjxCet78Dd4UxorRm1ZzfYssRGpcx2zWsfuj87TY9WJ5OtUnnWCFjYrAPGBYwy93OZU3RHlkEzI7NmjTc5qhY5CurcknFCTDYEy52qUPlNNKmKroG5xdSgcL4EJvKjh0gofa+r7ko9un8RaQ+OCRPF6DypqRJSi97TXkrjVA3uU8hWteEOjmkqt4i2yaa/B8kk
 mKeSW1YP
 a8VJLok/iRmxwxbDtDg3+acnr540+3Tc9Y9IzEOulEpikf7o+1jcEzDeOkuQ6238wRJbF8piT2uVMkoPHSDEVXihUh5DBeBPHAau5+ZmKH2wzp8nnqoeALV6K0nSBY3hHeRYdrmv60VjVBFLyww3V1cXs3I4s3FU3FbKW+dcmJqmZJFYbT1+Wb1N5vIA3D/mrA0ER/SjfB3fE52ZPnXP2KJn/+HdohJLxoksoYxwLY6dpuE7O7ui9wf7/cF6AGTKX7lkHo7OHyKAzxAnz/Mmid9dfG4d/mbDSfyKEtL6a8UE48fMpXBt6+Oj4fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 3:29=E2=80=AFPM Baptiste Lepers
<baptiste.lepers@gmail.com> wrote:
>
> Unsafe code in VmaNew's methods assumes that the type has the same
> layout as the inner `bindings::vm_area_struct`. This is not guaranteed by
> the default struct representation in Rust, but requires specifying the
> `transparent` representation.

Right. It's the case that the layout matches in practice, but we
should use repr(transparent) so that rustc guarantees it. Thanks!

> Fixes: dcb81aeab406e ("mm: rust: add VmaNew for f_ops->mmap()")
> Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>

Andrew, can you pick this up? Thanks!

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

