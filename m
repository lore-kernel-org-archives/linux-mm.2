Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA5ECA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0306B008A; Wed, 30 Sep 2026 10:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598046B008C; Wed, 30 Sep 2026 10:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485C76B0092; Wed, 30 Sep 2026 10:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24AB96B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:24:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB525A742E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:24:24 +0000 (UTC)
X-FDA: 85270648848.12.382AC36
Received: from mail-dl2-f40.google.com (mail-dl2-f40.google.com [74.125.229.168])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC3551C0005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:24:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cys2Z+NY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.229.168 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790778262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AcG3Bf/TJyVMvU8LCLEiBB8yyyCf0GJT1IqMscVjJ4=;
	b=n6qnVK/v4XuKlwc1zmpBzYgR0nApVzDznx9kzrBpOb+dwIZR6Pv9S96UkMAhvwevRMjXws
	rcPzEh8c9+fwNbpVNjmsByo2aa7Q83ugbDmwiuh0odUbcBxwWkdbT8v47/l6iCEsXjvQaM
	nlDqfo3DOBOfubHEeWCIrwpU8UqaOtM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cys2Z+NY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.229.168 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790778262;
	b=edNfD2/3hj901QtYTsTRVxLYsd+u4wv2tMTJs/Pk1rgPlo32Gzjcbvi1sz3Pqvuuu/vZ0B
	gOm2j7giiR5fKhLWXw2yR4S50a0hkkgQyarA12usZ9E66Clwy1WIfQs8UC/Tfzn8DFrXqW
	Dd6RmunWGPSFHPShWhzMyLC+3NOIG84=
Received: by mail-dl2-f40.google.com with SMTP id a92af1059eb24-14c96a4b7c7so164030c88.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790778261; cv=none;
        d=google.com; s=arc-20260327;
        b=rDiTlT7zRzVgg1xzBeExmK5KT/XXZcussWaW2wi8n4y3M5KB9YwbxCml5WE/musBG5
         y356mKbnLsJG903kl9ntTnD+pSIkJ8rY83GIBtNKLjn+elbSQHtkXHqRfcqSmbhXwa06
         zOumoCB7zdr9PKc/Sp9r2h0X5uA0shIb3W0q+auhNba4gBZg6g8/G07Fg6b6IPtD5Xue
         VhysaL+mgCEh/8eWLjUGYU+YsFB5VEZqkjzChmBhO4F+pSlouhLjEHlRXXAXezRdIc2I
         8xHL2qVTqNOyZ/bE+P8stn++6Xr1H4lH2ir0nIxGyI2FaUYdirpKE/VMo2BZ0YGRnpYW
         UB0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9AcG3Bf/TJyVMvU8LCLEiBB8yyyCf0GJT1IqMscVjJ4=;
        fh=R0NkrBMlvzidGbT7NCOCEzYtZwVSerQTPiemaU5w058=;
        b=rfmmkwHvYT4fBA6S6zmSb5BAwMShWXkCBtro74ReO1FAeMQRzMp010qGdFf/0Eb3Cz
         eSSEDR5XZQ7Fz2rDmRZv5cd7R0cVVUny6qzksvo/9aaiflIWiF5/W/VWdO685DQ6CZZ7
         pWkjIXgYtREWB6eO6VIkc1I/2A3VXLM00KsisPkL2oxkPvqVooHXqk6jUzaRD8ATbVJ2
         DWZ3B8ycsEEmBCzEsh2J+rer3rswjHckGCX524W4PEMl55H5EYV16bOeyOHBglyFFnTa
         dgtObyFuV46ZAoT0TRqd5hYo01zMOnAVrwpjggrj38B/9L6xgFka4KC5StkGS/snw5/a
         GpLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790778261; x=1791383061; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9AcG3Bf/TJyVMvU8LCLEiBB8yyyCf0GJT1IqMscVjJ4=;
        b=cys2Z+NYGWUNvr0nMzDVjfvHSfyTTj56ga/8tyG0Qu/7h7HMwYoY/QKDDFXsE2nbPS
         HY/ItfUTWEGdDVPqK/HfMSLEZ3Pt/M9PipKA41WUleaeHZXryGfQQ9kusTlj4E6APdZa
         Qjf1odykAb6SleTQhqf/3YQ97yi8j9yzLEFGRbXepU06bwlE+WWAV4WLBf24A7O8y5r+
         g9utbFybWR+dJk6dU98y8o99LHo/hgQybd2FXZjMe8iRBOb9dcdhzrjqQl1OV1BbKdJ9
         9hU56uh8LYtmNBWlAnYN1wiuxMoBkET3AIbaYWSEgaqwlrTjxxghmYC9hf9GQXnQvBNL
         cQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790778261; x=1791383061;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9AcG3Bf/TJyVMvU8LCLEiBB8yyyCf0GJT1IqMscVjJ4=;
        b=VXpmrMeUd9xoQs2F44omh3vJI+CkByXqX2DrSR/sr0uoLTLjUAwCp2tad4epcLVc43
         ZmJzvA0t6JsD12XXX6jfg9fM5dhcCBDVlTfaKIDfXHsHhY8TFXqVDV8PSMGMRX9kxJQd
         5aFlQ1tjSFz/BHbaRxJ6HGFLopyGbq3RHBc0w228AeAKbewhK+MauYBrnnsu2hZAx3AY
         /qve3Iu/DwFlRamPVtVqsRl5fAkHK83TMJXwWQB6d26YuRHdFqKubDGa01wWaQNyjDfn
         68PI+VpGETDuXEuLFvicR9z8YMsC/qtIrolZSuhaGmnjZn2D5Mhvep69vCTdCDCy2WEV
         IriQ==
X-Forwarded-Encrypted: i=1; AKwUvBzgJ/i2ngxFRn4pf80652S1xzHjwt1nyetFVT7m7LUQYkHJ2Xo8y/6jCYfcyeXCTlsyH8jn/QvqnA==@kvack.org
X-Gm-Message-State: AFq9FYLDF1amB7G4MfoA4BfwL0Fj6WsfTllSrAWKCE2kMp4K5iH8mc+S
	vNye/7jYw1ghKE0og2jFtlfSmN9ZRfHv2b7ckLkzvkBbQe11YxMYuZFclmrNp/+h8lQoUw4lNQN
	M163k3Ql7GOyrS+PMU3gTYIZLF+sBimw=
X-Gm-Gg: AYBFou1Pyi80TvvSREqhd8omymh34fp7nFvCzT11zFKfaVlaA+l2xf+yG7OBWoG85UK
	CA/ItKAdhQ5S7rOD4uJK/KipLA6zJCAgnpMnJXBlKKA9vRbUgX1wb8gtMdEwsDnN/Vy4Rv+0pDY
	CERt2E/ciP6hw4qpElw8iZbGIi5kV/67xT5go/WDpzTlEXoLmNeo79LirlpIELwN9Zrc6S4FcCn
	9jyGVvL54K9tDOQObZNRxhipATDWMgBKoc4x02XJ5Y9aNtFrJHIFUkH3cUSY7hPhmuLiQ66HQ/s
	3Y3DWJF5Bx5Q8qvcEMXntxnr3W3lALXZ7/89So9+kdlTkD+DqKut5gXN+JgQANDKfefb67wrXN7
	oxIQ+56Phx2lL+3i49hSKeOnEAItmx4niDy3XmHOJrQzMmJobEhngN7v58q8xsi1AeuwsgWJDuA
	gw5YobRit+/kYWZOJjnfl5Mo33nQ4W2Q3m1bVhMIkHXUWUZ12w6T0=
X-Received: by 2002:a05:7301:7309:b0:33e:6714:3945 with SMTP id
 5a478bee46e88-34cdeb6be9cmr2983232eec.2.1790778261266; Wed, 30 Sep 2026
 07:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260930123645.302318-1-ojeda@kernel.org>
In-Reply-To: <20260930123645.302318-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 30 Sep 2026 16:24:08 +0200
X-Gm-Features: AclHuK8GB95XWuO8LKxnbuc-rexw5qTBlkNwTjmQZMYAdkZPzMK378NIg3-sfCs
Message-ID: <CANiq72=kA67u9vmvAALL8ibWEX4AnvkWB9ncj2Kce8DtxVpW4A@mail.gmail.com>
Subject: Re: [PATCH] rust: bindings: fix VM_MAYSHARE blocklist entry
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wss5eszotby9uqyow676mbsnanxjbdeh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC3551C0005
X-HE-Tag: 1790778262-889472
X-HE-Meta: U2FsdGVkX1+MU6qEet6d0z3kFMH4e/zNiogccG+KwNhI6lLcnKejr5AN+M7ST03HIpHYkFuU0BIi0xNDS0DbQLatyxBguMv51nnbQnLXDX4b3kk3G4NOYEMjsyuiOUqXappIDSPVkqpOxUuOB5gaLw6NUYUIBHf7FeXqk5adU1OM1GQ0S9+Nw7XCenVujTnCFQY6lwmV5LZCJ5xt1LhmdJsxFFSXpx9nnNqIWY3p72dkgwHG9tkuA/2CAbnyaDswvhyh0XJcujWoqNb6AVhOw+bPD78o/o5boW2xFX8Q+ySaZrWNOWxRu0DfnOscUbIdUl6+DeWKesgZnIlN46ftAyj0NhMUuskFq7295RdqFOdCrwR36+Q0H3hrTJLzZKQN8UBq0937s5eeCtftJJrBKk9AztJbR4VEMRk56yrmNNHU5HwI5IfFDbm0oTyn8uji0tTcs9eRdLnKctmrRGOHFyXMaFRVRDmrqbV56HAk432ZmK6KJ480kxzzsuQeVu0R8LQbUX8Qi7pCaliKGeXs/++FlNgwcuGspUsUNIGan5KjX36/iVAci/IjaZYLNiXCIwW1OFlA0TZ3f5B1unJT95BWtxftF5x9vPNOjwkpqE9t6eVhQni2xfdx6locPiVe5xWRwtmke1MOAYjpO3Gk2SsUifg+Z+pQmuECKyCA2dNX67ZcBLrjY/12EUo9v0iMA2HRik7AuhyT9Xy1tAO4Uy/yPnnFESqtESKE1mtx7cWqH1dciDnXGRHVAaYl6FLLPUOnpembELqEkihlcODAUj/3aw+DTardPokzhiPQzwquKex11IRewSIpgRJEJsOI1w24S6KEl+S7TgNNNp+Dei5i4qEQ86UFBLwex6J2Z7Nen4/Vrrm2f36fmMZJ4KMpQvbcrrkTNBFI5XwpplW2i5J3c4SK84PKFHjc2vNgLmJwOiqCFJc6fOmkBaSL3nki8y2T7h6o+q1tCQOHZqF
 uP8Gr2IH
 1DWkKwIqQsQw2JQwwrESwvHwYxhTWwyM8FIRmhVBcmopJ3qV2Z/ODfvtsCQwGNLJL+OVqcuwY6GM0Uzq8j58q5jBDdcRC7gRooI5NkCZTBEcS91LHbupafXQzNb/QZqM6CKSxPj9mIrm6jS8M8yfaz4sZrEJVqsZjjgSEuSBZKCS6ehB0bS8zhlVuV0VW/Wfsys1P/cQoyTFXjbMpBYb0Ot2uBjZKzHuGpABEzqd2tgStzOQYuKGJrvOVkA6k+8nhMfQEoVRf5LdrdSr1Dggx1SE1FGBHFMs1POLvrz5OMKqJn8uoHyNct4TsVVoOcvD0oqaH3za/xMxGx2FJmss0pNg+TOol+PUquRLQGmLWZEZSdFUHCVUmtQmAEFgYNE9P+48gd1CnDb6if2+zVd+AB9Lw415nHkAPTY3JVDO6FXV3xwg6GCPo2o2fV/l2IdQSx3iL5vSIRoQKISJFgr4KUEmzt7QIKT3/a17BwHs4dwudw6e9xLmVHyiI0xU9OV/HB3xF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 2:37=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added constant helpe=
rs
> for the VMA flags and blocklist entries to suppress their direct bindings=
.
> However, it listed VM_MAYEXEC twice and omitted VM_MAYSHARE.
>
> Thus fix it.
>
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` to go next to the other one where I noticed it.
Thanks everyone!

Cheers,
Miguel

