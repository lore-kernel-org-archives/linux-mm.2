Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0132BE6FE28
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 19:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645526B0089; Tue, 23 Dec 2025 14:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615EC6B0092; Tue, 23 Dec 2025 14:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521DC6B0093; Tue, 23 Dec 2025 14:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 403746B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:36:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C45ED1301C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:36:12 +0000 (UTC)
X-FDA: 84251741784.02.EDD33EA
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id B03458000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:36:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3aKnjk9/";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766518570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er4UcK44hax0My1WIKAtzudkhYIITu/rdMePt31Ulj8=;
	b=e9FS1mEf2sjAtdrwfmN0olpPMQBl8ieL9hlFH/Goh4kwssXXdgW3PRy90h6jM8gdGfRoHb
	0qq9vwFb0z178nBt2LEnmWr2AA+iWHUDjPcnGQqVV5pM3g+99NB0Ci3XY558+vv9zczZAx
	q2J8AWCrKVS9WSgg9v0bnF/VeZ3rku0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3aKnjk9/";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766518570; a=rsa-sha256;
	cv=pass;
	b=WBRYyE1pG0MA7FLthYHQ9oxiQ21A2aen2Px1mg1bpYnZy/I0YqVeLmmekB6vZGnsxz0ioy
	fIIvK75BflQNf/y6d4tpDvc79AwcrsGpYcE0SmCSTA9/0O88K7vqAkkB2Up80Un0rcv9w4
	3AJalZSjnr5hpYw1zpXZcaVhHcji1+k=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64b66d427e9so42221a12.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:36:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766518569; cv=none;
        d=google.com; s=arc-20240605;
        b=QiwqK/ecwgOej6dKGIQXMooDvhWubLdSQU8rynmfP8Nwl27RqyQNGmWPGlscmIBC3K
         aCocbeawbQ1yJUXXh6T2Urk9TDwJYWIZ/uwl/ovyLgmiBG5rOFU0N4+GYw/k01JioHf7
         /rEk10tNwHF3BErD88DMjQf/1c24m0jkctrgFXZWv6UX2bp0G8yNDeREwDKyMVtFj9F0
         Zq1HXIvPOPeLWBSKCpKDbGKz4dezCYrYQqOYX/P+HA/4aE8u7IU7tdZB4cJdaAE1eL8L
         nA76HVYzmbPEp7ol2KTC3ikgbteHYp+CGfcykpmJFPk/OctfwBj3gCcx6DIp+BZSkPXY
         Keiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Er4UcK44hax0My1WIKAtzudkhYIITu/rdMePt31Ulj8=;
        fh=XuC9jan/J9u6hOPtCLa8ejRnejWKQCLgpeMrYV86ak0=;
        b=hD2Bw1Hm4jm7slKRPvrNrENwf6C3kRd/cb/tQoFCjUfptDo0QGqYNs9pBAJm0iPWSt
         fNffW7gq1mL1YajplChrkIFRivSAoVc9bEWz457ybB36jlheG26Joz7OIdnd/NjGpthH
         1Fe5tYGzHJwPjob8RDTmrtH2EVZS5wJviPg0ayXHbAi8/qNv8gD9zsdlWexxZzW7h1ix
         K4dCNyqOHtjV0ZGm9HvR//aHeezFcdVDoTChB2GgBS1QDPZIWyEq7fGTka29AcE5WaqD
         DslhrS4rH7IyPS3bw7k9n+3vJkOXHsM2it53iBqDBWUfmEXh8QsWNd6u97PqTDYpM9In
         FNyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766518569; x=1767123369; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er4UcK44hax0My1WIKAtzudkhYIITu/rdMePt31Ulj8=;
        b=3aKnjk9/1Z7E1XMUEEbWkhDwUGT8DCFzGD8/7a0y7dKEcuhYoG7q8PyBJvZIp9vq1j
         z/fVe2ezzZ6VC38i2Geps5qdMW6k5GH9BAGUW7RoiFEXN+X8gZP9yd2Wc5n3LPKRH0oE
         5vspeocR8xZy5J+RLHklbjYIt485wwP1enN+svjgxKLH46bus1A0ZW+RhF3DstzEmO9s
         WebyGsM79ql4qLsGtbLzm4Gep8DbXSlQBs/x2F388PkCZggtIl8KYQ3UCI9zp/qoPJQf
         CNPcZ/kIqHMYz6kaS7R9lE4SlpF5hTyrFg8uEZgCcRX4k1El1X0l7ygNvIucytrNrcmj
         dznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766518569; x=1767123369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Er4UcK44hax0My1WIKAtzudkhYIITu/rdMePt31Ulj8=;
        b=LYpx8FZLIrxYqqDGLq33aAWNFuxTIux2ll1P4EsY8bDiAHhvNe2gMFd9iR72sugIIh
         R9OBJPQbGgF0JWXQ9b8VQn80pX7XJKd0W5BXqNNKOuwpUJBL2rlNM9/FVspqNOMhEK3F
         RxjffHllUM8LD3wksrBQavxenqJtDGdNrXToyqzrqkdnvcyvq1fLGTLHbd9qXWT/Pgw/
         a+Zmxcu0Q0FFp8uvU+eQOl9yvOql/5rv8w+WSXVVROI8jkxBY/0EPSUaOFKJPaeX7ysk
         PAj+Dwc/3gxSXNNX48rUCkyjryV+SstmsaG2VTcSH71tH1tMcwbJssZn/gsfh0IfUOrw
         VDBw==
X-Forwarded-Encrypted: i=1; AJvYcCXU2W4qP8CIXa9y3E+4vU1G/fTyrIu5oL0dJkok573SQ2Bcf8177dReJLciHWluEySKZc+zpLzgIQ==@kvack.org
X-Gm-Message-State: AOJu0YwrhQw8DWf87PsDFAfKSZ2+n8bEQlh/uGc/894TB7u9x2+kgLYP
	10Ww5nmUzBky3N1GltI6zS4cVmCMeBD5Os+0rO8YFp+OsKhHsFghzebH2u2GLyYfhtsHHDQ2Vss
	WTx1af+5hDZ496084tWrmth0jg/CBo9nADmdAnQVN
X-Gm-Gg: AY/fxX4UvqywAL+xX3SQAdSPVJM7n588pjkyXsjACREUsDROtRnhfSO3gL0cjcCfIMF
	IFHEJ+v0G8IKP5/pqpnISpRDeFIfYtYfOl6gfAEK4TABJRrCbsurk+UzyLC1X1O3rB/Mb0aVEAE
	ZkHh8XQpi+2iYDjXBouooFkkiXUKeFHcyWfKAAMFqn8+wJEIzxKdzlPmk0ykmb+q3xXEBBuDP6b
	xReBu0BUJVphduH1AZmlULotepLPuT2u1MaKvXMk24ElHPBoHp2pVJvw1msHFWFLfGnYmNcROzi
	+gNKMSjo1q/Z0hMTs1JUkDelJw==
X-Google-Smtp-Source: AGHT+IHSUP8BBOcIxkhoOKIjHkvvp94ykJIunjfeY2UpbyMETM1E9GUfcnQRlvMo0lPw+XuhqtVvc0KBmfVEhqsHRvk=
X-Received: by 2002:aa7:d285:0:b0:64b:4a02:f726 with SMTP id
 4fb4d7f45d1cf-64ddb833d07mr5128a12.10.1766518568869; Tue, 23 Dec 2025
 11:36:08 -0800 (PST)
MIME-Version: 1.0
References: <20251215-jag-alloc_tag_const-v1-1-35ea56a1ce13@kernel.org>
In-Reply-To: <20251215-jag-alloc_tag_const-v1-1-35ea56a1ce13@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 23 Dec 2025 11:35:56 -0800
X-Gm-Features: AQt7F2opNDNna2jdTR_ENU8L8OJcFQ11TWRZuykqFoB37dOAj3ZPnGQTFFYUNvM
Message-ID: <CAJuCfpGyyNVW6wUEaEWPxg9EfA+-N5kog3gW+MUy3zEM+iZEVA@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: move memory_allocation_profiling_sysctls into .rodata
To: Joel Granados <joel.granados@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3cc7duabnjhokg8bbig7igow8fc7f61a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B03458000F
X-HE-Tag: 1766518570-548623
X-HE-Meta: U2FsdGVkX1/O6l/wNnIZ6hUgFSo3J1pZeeIVIsrKtZ0iEYHf2qNBeIz/bZXWUDk87CoZiNfaaUxapn1MsX9exjNdwu/zd6Q8/K/CCRHKo11SaMDsg5vL9FBtRkYzHl2H8Ii990fDvksMfEDacmWXa3P7rhFhVOYmDNbaTPeJtoOr1hEPiNjxLMTEH9V6W+DqvNihXmEgoRSN9Z0kT2u1UAxpUBOqwb1yqcwOn/YIlQfOthGSSt5Rpoj8S7NwDHWmnAg6yXtSFKK80wArtkHVZKdzYJkTtBwCqx9v7JinH7Dz5dMgE4BzH54KJe+nJprmzZYJyRkhCSwN1Gjoi/OxtsP5wrIQCFd+G9B1GyFV2a2rlHcUNHflx8H0U6apB+xhczhGlLkK+jHH5Vo7ByMmSJ+CHmsNolQI6F9XA0XNJfStwv/OvAeQFd9a0iF80uwrkzYFs01VO+WOU9I/wabRKe1/AyqluS7QrNTZAg5Kp2vPgkQW89Zk8RT06WR8/ppPlsf3fMODxvauE66OEscIYFBWn+57k1t+xn9hIyieKJqxPL2qk9oZ4RoYJ8qf4vxXWzgLb8zV4rY7TYBEUWJX8WqAgTdF47QmnjtIk4POBcW+mUy25Vgoqm1wY/lBmgHgJYZ8EtoX8IN53EIK9IQJQkrDuOBmk1U7pjQ16wf1XDItUWY+VrCeNVmdA5nAXx42WpY4uNffmzJZCRrSfB4o5vGJdOyoexp7b1i/SzOoJ4tPsTUkL1xM8i5xFJOcYZlxW911u9Av9I+cgfyxMxwVHiqnBCY0NFPdqOrxnIFxs9piSQus2W6BvD87wAnw8z9s2TAYD5m789ZN5rrK8giKiUzEl673cdmqA/2kwS2lM82rJ5Dc3YXGyFjU8lMExad7tlRznRx0YjSQm1N9+GigDXVlRAkgWvUxHG/Ryxw62daGnj53KPmB8btLPnJymaHmzx7SAag0H+P+PagbTiE
 fG9qqm8y
 7PlzduUm52mf9odb3tlWCbkJQB/U/yWljXRzdyBbjiQLsLefw4b2oJWVfFqgsi1UYsQ485u81ARJoxKF495H+1I2JJEbLG61WG6XG3QNArzLu7BJiTsYmnv4uPArbQ3erxiqLc1rIQsBwh501NGuIr+UJNmilpHn4cyGSOCnCldvb9gle0+RwPQdhrv2LkY/fH+qF62M/qrynyEQ1YCie0EMuy75tB4JsFkanlWDlNdpHC99J3vi3usk82vfZSJ2KCoDxudu4N6o0Q7Ef/lRuGudivwzG8WsvvdES9xoxxWo7WycgC4L6iFekWwuM4/yGGOHiaXn5xnqjYt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:47=E2=80=AFAM Joel Granados <joel.granados@kernel=
.org> wrote:
>
> Remove the change in file mode permissions done before initializing the
> sysctl. It is not necessary as the writing of the kernel variable will
> be blocked by the proc_mem_profiling_handler when writing is disallowed
> (also controlled by mem_profiling_support).

Right. When this code was written,
memory_allocation_profiling_sysctls.proc_handler was using
proc_do_static_key(), so this mode update was needed. But now that we
use proc_mem_profiling_handler(), it can be indeed removed.
Thanks for the cleanup!

>
> Signed-off-by: Joel Granados <joel.granados@kernel.org>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  lib/alloc_tag.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 27fee57a5c91db8067c05bff974a9e801e0ef6a0..846a5b5b44a4e5f530605c97a=
200e03260e73d77 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -783,7 +783,7 @@ static int proc_mem_profiling_handler(const struct ct=
l_table *table, int write,
>  }
>
>
> -static struct ctl_table memory_allocation_profiling_sysctls[] =3D {
> +static const struct ctl_table memory_allocation_profiling_sysctls[] =3D =
{
>         {
>                 .procname       =3D "mem_profiling",
>                 .data           =3D &mem_alloc_profiling_key,
> @@ -798,9 +798,6 @@ static struct ctl_table memory_allocation_profiling_s=
ysctls[] =3D {
>
>  static void __init sysctl_init(void)
>  {
> -       if (!mem_profiling_support)
> -               memory_allocation_profiling_sysctls[0].mode =3D 0444;
> -
>         register_sysctl_init("vm", memory_allocation_profiling_sysctls);
>  }
>  #else /* CONFIG_SYSCTL */
>
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20251215-jag-alloc_tag_const-dc9d7c3f7a8f
>
> Best regards,
> --
> Joel Granados <joel.granados@kernel.org>
>
>

