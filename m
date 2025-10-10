Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5FECAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 06:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DC68E0006; Fri, 10 Oct 2025 02:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDED8E0002; Fri, 10 Oct 2025 02:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25548E0006; Fri, 10 Oct 2025 02:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE0678E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:59:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65B28852FC
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:59:22 +0000 (UTC)
X-FDA: 83981303364.19.50173F8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 86C692000B
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:59:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+Rw5ZxS;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760079560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/KsRtAPQyYYfQyL6T3MHYdC3MZg30zHcUpFS/EA2b8=;
	b=E+PSJPv+6saoZWRecPsWUb8D/n7zLoLuFrUjV21puR0pzAJRlS/03BpkXX7Chxu+DVTsC9
	lS3ELPIJ7+lw79xy974BiNqb5PEHIScL/b8KXAkkhDHltRBZhfTQvE2ZbGHIVZ7O93B2qp
	BVXqt0blFqROr9vNKEPOxW2wXoZjBKY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+Rw5ZxS;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760079560; a=rsa-sha256;
	cv=none;
	b=Os7dTcbPNRMs57uvZsZUgX9fkF2BRE5QmC7luHaVe2c9f7MhozCvtQikCVEG7RcDlZe0YS
	DG0c8uql3WH+gtG7GxvwohI7B4yeELqClzqOg8BBxgGRtm94NW7ek1p1jngurezRMJBLUK
	jW2PCaPz4t1Nzlj5GQOjJg+vhrje3r8=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-26808b24a00so2773865ad.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 23:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760079559; x=1760684359; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/KsRtAPQyYYfQyL6T3MHYdC3MZg30zHcUpFS/EA2b8=;
        b=Z+Rw5ZxSWY7JgfwmSEdxRW17MCP+Y1u85gCLhSw2XIAd/tnSUFSZGfv1NsYZSPgs+s
         LGUABD6fMxPA8r+UbmcF/hYekS11XAFuFV6TRKYNfsZ1GVvIJdS34tmBCcKG3kQx3Kim
         3WYsk715urH+VdZgqyDLcBNAKG9eaX3/qBtD8rIde91hzltVAiWDdBe0QRP73/M1ehup
         nVXd6Bdpyt6Im+k2nsU8tTa5wyujw+XmuAAbF635+WDGLPC1x+DKa8Ia46mN8NFrwV2F
         7Tn7/t+rEPFYIvBpEKP1Y7kLQYVssZZ2kk/LSz5pRghqsoiKYmQOan/fz8zBIfHkAlCb
         CTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760079559; x=1760684359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/KsRtAPQyYYfQyL6T3MHYdC3MZg30zHcUpFS/EA2b8=;
        b=qaHKqq6RfI3ct1Ajduel06acqiwQLTZA+DqgelHIFmCzuCz3I9gbRjR682YyEiDqfb
         CwJ/FYRLY09qefzkx2SfPuFlEt7nLWMLE8rMT6EC+6ibOwv3i9NcE/h25ziEu+/DSoiO
         gxD+PR++pALrEUQgTmVUFLBMJGG2HxeSpfnxjI+1y6mopjyB0BYBthvEYyI8d6XWJQ2V
         DcUhrKVTfOQwUJyAbsyGcxUmff+Vt1lKFfS8WeBRh7K8uslQdbvnw0c3LUAro/HyB+lR
         gMoNEuxx7qFzuCt3l87uZ64oNAAS2uZ+2SsJXEmbxlZ/OwwRJRomNX90eyVI+Qb5hrbc
         aRoA==
X-Forwarded-Encrypted: i=1; AJvYcCWMigVOxvso4s9Ir9SZWgfXu2k8XeNIbHk0jkNOR4zho8hbLMyhpaY4i7gFVixK5TrLABImdyhoiQ==@kvack.org
X-Gm-Message-State: AOJu0Yxlm3tU9zOkRsbktOonmjbYAqGRMfe4AfyylRyua6JhB7UrQl4v
	xAJ4RuUM7BuiS9FItbP/tajehGEaDPF/aA9DRhPkIGplrP/yUOtiGeGThf7cZYyua8VouiUbgh4
	82kMiwslSvUlQsF4c5j4/SeboNz2MtNY=
X-Gm-Gg: ASbGncvbZl6Cv5ndI0L8iA5Rwbtg5+M9dxch8I+kWANg7EePV9m//eg1NRu1jPuHflb
	rVBO9Yqs27qrTlcMeN73DmtlkUxM/WHR1BSkgxR9SeB9oPAf9PACF1KbEFUcBsCUfrEBAH8qPNS
	7reQiv8EQYUNPQKmhzwuoOB5uoa3MRNBCDAI9ey6iUpfmeGpHAwPO36hEIIG5MeF0J3XSaF2shD
	PoBSv4Gb9hQIZXPkc6JjERNkbo2NaYchmgV7EgEeLHDKa0132SO5GhB1/qaitlvRn2+Z7rOG0m6
	UcpVP/LQfpy79YfcKEb94/oUpPhpSlxm5x1yZc6SN4Oc
X-Google-Smtp-Source: AGHT+IEUQCZh2bXNZHQ88G1WlQFzYGLfnLI6ghhtXSvp0Cccxl6SfEYz7wbupJhdzFbhRIa9rBWq/hVI+k012AHDODc=
X-Received: by 2002:a17:902:ce87:b0:27e:eabe:7604 with SMTP id
 d9443c01a7336-29027449af2mr78609005ad.9.1760079559298; Thu, 09 Oct 2025
 23:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <202510100127.yuqhg8uo-lkp@intel.com> <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com> <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
In-Reply-To: <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Oct 2025 08:59:06 +0200
X-Gm-Features: AS18NWBsqvp1_UAZLl54SYhCuFPQy0caeuUUUgRAWv4x_WbqElbX_D_UZSSrijI
Message-ID: <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ`
 in crate `bindings`
To: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86C692000B
X-Stat-Signature: d8idpfoaaxtswb3mxfnbxeu6ttexmxws
X-Rspam-User: 
X-HE-Tag: 1760079560-124681
X-HE-Meta: U2FsdGVkX1/zJJ/D1IwJ5dJvSOCFpHIdX8t5QvaE3hobuvQVLhbtHkoaFmwggjpCn1T9RcAf6f8pwMEoZqUo9ZaJykRMI/vvcKK8dyquLdqRmpUD+N+sut9fbs935/57SuxGoTHkpDeCcjHFMe/EzgllJIncGCAjkxSc/RrVPjI0Nn9l3FOi18M2kvzb9iD0ye3wjhgZHGfJlEq+lq+hpTmeiRVngD1WdRBrmtRyqsqYMBa1iI7XSJiKReGry8zsRyRRv0k9tIjWuNrQ6B+nA/8pG+Blx0tzgCk/bbqKj6cNxiRIOoa+YaNBhtB0b+PeGv5GSiIn3sDacN97dpmOx/NYx8t5WkHt2RxN0lCe46XOfw8c0SHRgpWTpt2KZquwcAnsBG/+tIN7ziu1UD/4Jo+aArRgh6YS383iL1V9+b7u5jVWOC1UXUPJsEbP+Uoxt8S8oBzziZrA0Fm0RosqQRIS48RqkrEXSMJ84Wz4aWyfkmloLYZ02G0LfaE67wJyzgW+yVoz0MEDB7hYZFLqSJt3p0uNDJm/o3ojX844Ob6j54TAx/sjnPjSuvpSqjpY5Xr4lmUpZ4U6mpBwIEj1tAPcibhDQr8CxYtpvYBT9R6nNSSZsZ2EsrNxymEwOrxZ7FjFpZQ5wQ9czj4YDupRn+gM41lIZ9N7iqxYN9HJ0Bvk+GXiPg0ZhlrKUhRgLbAdmI8iw660cfNTuTQ/X0ExVzd6/B0Bj8W+0ptgk9vhk37iOue4zb/UqT6RmYxCgIBKGealuIk6EIZuE+cC8QGGhuI5qS0HXYIl+TFhoxt+zf6efqIehTmxLsckUxlZdaIv/e1T4206tfg7vYZ1HOrEv3jq8tYn+RQb17MpaU9McA7HpcYqbkf5fazOVCN7bGi+xRnN7yDWS2fZYz6B4grjjwcgr+bc0OaaFgVM+BQ8kD8SPbOk9+243t4wsf2uok+FGmSjl01uEcvXvCx4XwN
 C4dK8Vae
 iKSXf4mK0xMT3n5VLLnhxua6aLZfl1rxe9xBWO7R62ZelGzDeZ2SQw4RFH1OO/4MzAmtGL8i0S97r3NGvwNScEt4sk3P5YpilkNvGi0MNzD/fL0a9XHm5L56TepalUvL2wyMa2VU70KA0n5nUaxCPkYZ1MS0HhBy39gUu3eMZ11n1eMTySfMUL7kteM8105oZAYstfRsAcc/HwNYxKKlaL2gQIjD+GQgqBq9NQmZ+9Y352ody3qbUqhh15Zlzb4REu97G6K8V/ZarFiTI+eTXF1xlAZdhLHrzH/LnU28XQBxRnvzmilSzrd7gH0OlsRTmzFaFjC81qyT2nVc/wbYQ8KJJDW6vQPdAtoEc6FcReRa98a0yzv7iKCnVfgp8KZF3/ejg480TcTSn+K75WYp/FDOkQJOh/YRsmOa7/LhIo1yPeOJ8bHEYK//H7uVEHUG1Eh/oz+eEWeVkyKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 8:07=E2=80=AFAM Jakub Acs <acsjakub@amazon.de> wrot=
e:
>
> FWIW Alice suggested the enum version and we discussed adjustment to the
> patch in thread [1]. I was going to send new version of the patch as
> soon as I figure out how to test for the issue pointed out by Derrick in
> [2].
>
> Please let me know if that is desired or whether you're taking care of
> it here. And/or how else I can help.

The `enum` approach is what we usually suggest if possible, and in
this case it also avoids having to replicate conditional compilation
on the Rust side, which is good.

However, using it here as-is means the resulting type of
`VM_MERGEABLE` is `unsigned int`, not `unsigned long` -- but wasn't
that an issue? i.e.

    https://lore.kernel.org/all/20250930130023.60106-1-acsjakub@amazon.de/

We may be able to use a dummy larger constant to force the compiler to
pick a bigger underlying type, e.g. something like:

    __VM_FLAGS_FORCE_UL    =3D BIT(63),

But note that older versions of GCC and Clang keep the smaller `enum`
constants as `int` (i.e. small and signed), even if they will pick
`unsigned long` for the bigger ones. Newer versions will pick
`unsigned long` for all.

The best would be to use C23-like `enum : unsigned long { ... }`, but
sadly we don't have a recent enough GCC as a minimum in the kernel
(GCC 13).

If there are extra complications with the `enum` approach (i.e. second
link), then perhaps just replicating it on the Rust side is simpler.

Cheers,
Miguel

