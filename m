Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BA6C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 19:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CBD6B008A; Tue,  8 Sep 2026 15:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40EF46B008C; Tue,  8 Sep 2026 15:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3246B0092; Tue,  8 Sep 2026 15:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03DFB6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:47:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70CA88067F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:47:32 +0000 (UTC)
X-FDA: 85191629544.14.09F8D85
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80A9316000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:47:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mQsZ1j9c;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788896850;
	b=Vqr4f0+OKPo/a50DjA/7NwkLqGAbyFIPSLEzFDX1knoUOSm8uzT79CI4q8ukzPJNuRLf1Y
	glRg1mZQdmjyGgWLC3YJfN5aZyZ0k5OXx46X81H2K6Q2b2R0nrq2KuY6vXOebf5F5P17iS
	8fhXgYKlDdTWf31ISvqyb6De2mYG8bM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mQsZ1j9c;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788896850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iY5QnsT4qlVhjZv2PDQCFtybqjTxSMGZqhX7XmXrD0U=;
	b=6cDvGBPixKLEdN5eQfj5Rkzr8R0xfd1fv7c9s1eEcZ1wVQHDntvkUSvQh3SBO89QlY36n6
	/WzJ3IeBZYcrgX+IHKNHNbqDSw6L1PsUP9GaeRmcqn8rrtbI/dp+Hp7dZFpY7jylg46Oiu
	mMl7iQO9u/XgFkHJAMmlPA6BRXywcbs=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39931869b4aso471459a91.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 12:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788896849; cv=none;
        d=google.com; s=arc-20260327;
        b=gw1LwDM28IgTWRAgXPKxYDpsRuPptOzRZHVfmEd6HgK6W3I8OzIPQuJ7Jqd1/PeuhD
         mEfffq0LdaRZ7bloSbcMgycoT0PQOF5qkjhS4GvZFrcIM0QiKbfY7Ut1CxwmtxMTY5yP
         UAItySC878lLiHCd7NPxdT3sbsNUdW+kbHxA+MYOrvNtJJ424vZ1T4CfQWlzSsUYHXmx
         RASRfNVr6rDi/6F3U9GhZR6S73ZLxgaEq6LPAGluoN1NmysaICeOxwUyJ8HdI6Xy6ykB
         oJx09PNPwn5VrrHpSyn7kP3Na5TfODoqLEl1IlGblFCjNgvGFfR3ZaY+//jmakP5cPHa
         XL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iY5QnsT4qlVhjZv2PDQCFtybqjTxSMGZqhX7XmXrD0U=;
        fh=Via/RlYkbPr5P9/WnsiSFGOKfDHdPBZqvY7+HOnkM5E=;
        b=fpd9QioG3RRAlH75YDsYNWZkcoF4DeTapq+zmBk1o+nO8novOGucZtoLleHzNd6/OV
         8q4FHHA8n0CL/fQwd2/jvoD403O0EXpEoyDefmevPWu440/77VbIrbDEl7UoAR5RvSg3
         G3bybH/9oUmfm/CsZRZHlsqMGfO3c4ylAaOb87ujoXQg9YYDG3fmr8Yy+VRg9gOgonJu
         JsXQs7eboHcJbXVPNCiMBgRB/mLrl5iea+XgXlw2l3XhQXk+hxn27qtQ0q3v8S+WH5r1
         SjSBgh89rchtvRNVpCsaRUJrV11c77kk507OleYeJhh1KBpetqYcH9LUigDriebOk3IZ
         R0Jw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788896849; x=1789501649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iY5QnsT4qlVhjZv2PDQCFtybqjTxSMGZqhX7XmXrD0U=;
        b=mQsZ1j9cTSavBYM4twX1tRKGqJUeCXCnX4Bt6F4DNk3J53Z9k+blxMbGzlkvqniNlb
         Pyy1iDNmMaQknB7d7jST/S9jmqT4MvaDOeAiVZcLBIaLK9Zf0OZdNfJjLRGnQzNYhElY
         bspeN3uPYF51E5XzorSXTjlZLDkkBGHMmOQoMEYx9Uq4WwKzarFrQFCsEwiq03Wj9GJh
         GLsWjJjsG/x1Iu9Ir7zQcIvne2ArqXeT0T6Babcw71bfwrMy/dQk7yKNoLex4gDF2hnc
         Lf+ig96Xt/S8c/JeNgqr3WBUC6jufoKD0AFUfUuOCqkg/wv4lmqxaseXEQLvOZ08/76k
         9LfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788896849; x=1789501649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iY5QnsT4qlVhjZv2PDQCFtybqjTxSMGZqhX7XmXrD0U=;
        b=L9STyXSN7DDiqoQkuZ+1vjIcnMKp35XiE3uPEP2h38rlYv7sqbbtzwRTSNPcqhpy9R
         vIG7PSOsFw89AtBW54wFwJ1nB78fNgX1engCsCjqakSNFeQiU5vT4RL7irwkI55is1L1
         tQs/14hMAJtXa16H2KTpXhWARFUAdmFAKN55Jb3FOUFMN6OThekue2oEK22svvS44dvZ
         bC49Y8sQrp5uVkR7Sw5K65lRKp6n+1+Hv21IpGXsHDYioYxmxYC5wna226RC4hLgVuun
         Uyjue8MPxRUNGIOxxCsy2M/1SftXcjM5+jO/LahpyjCIWae6rp03awDrn9ewR6lGEMPH
         czrg==
X-Forwarded-Encrypted: i=1; AKwUvByZc1KlkZNbKikyolEYAkIjEZfc1czl+h4ruw1UR1HvLbzQ3ANkFNJk7WiyiRSJ9A/LGqfyJxPmFg==@kvack.org
X-Gm-Message-State: AFuF++mIT2B1KaOoT44wf2OsZgmCQ6ePs7ERrfI1t3411s0gwpA3NDRr
	JC3RaZHsUBBStF4T/3J/n2g9YNL0/xeQJKA18Facmi+VYVN9KkilJ8UuvemInaFyC2HqnhJ2Yrl
	vm763BiRePFKOK8iV+QPL3CB2q26Hzqw=
X-Gm-Gg: AYBFou1r/AnsOyqxtRBQUpFmCg2PSYwAwp1Kpv/YrJoluQZeVy++NxhMLdMKMOp6dnY
	Ku1p7d9E/13ac+AryoDXSNZvlQDh41SKeegJdG91wKMlp8s+ueI1bJy66/EzxCmaz1B2nSYCExC
	XlBSchOEMj9Ddh2DIIRoD0OsMMerulLIEXdMPJGmQWD+ZLgIJBLfyFBG09cfKaT0vNEy95qc9bT
	bPqtSaGFewqrvcjOsI1Ooo454/U6Uz/nYg1ZnkIZ5/hvb/DcM21grQhuWFK8j658imyAjSbMh5E
	jnYE0fO/oEOsYNuzyrRy/eMz/5ZGW+OuDzYVP7hjF4Y6biBqRjCT9qOHewOZy76sK8Yv1pFKclH
	zxlD3XeJHnT6WvGqrJlODKWwpSYKqZbBDrg/shJbcO0+LVfnf2Zepd4+ei2ALj2+VtpyAGAyuKo
	hIGWrxB3NkIlK8FTYoQrjgBnE1DkApetSJeBlI+dLqBeF7ryUrMv4=
X-Received: by 2002:a17:90b:2801:b0:38f:aa76:88b with SMTP id
 98e67ed59e1d1-39b3d7d056fmr21707651a91.4.1788896849093; Tue, 08 Sep 2026
 12:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn> <20260908-tyr-ioctls-v2-1-88bea777df67@kylinos.cn>
In-Reply-To: <20260908-tyr-ioctls-v2-1-88bea777df67@kylinos.cn>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 8 Sep 2026 21:47:15 +0200
X-Gm-Features: AcwNN1XXa9g_iZLSTKQDHhq0xMt2HPgPqo8BFVOYoRvUTe0z8qL0cOKPZrDxOdc
Message-ID: <CANiq72mdp9hS_U=Mtf5F6Qv8M9=m38xOXtCP_a4c_QtkwhpFEA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] rust: sizes: add SZ_4G constant
To: sunke@kylinos.cn
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Lyude Paul <lyude@redhat.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
	Alvin Sun <alvin.sun@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 80A9316000D
X-Stat-Signature: 3qjh7eetmcw6k414mdpteifk9w43xon8
X-Rspam-User: 
X-HE-Tag: 1788896850-239684
X-HE-Meta: U2FsdGVkX18b3xNJ0VnpifFnvJcasT7EQdg/UFlhWgukEs7fhRHMalzq9BJ8vhiMJTFAF4SxXUql8trc2Nk+/Wajl4MIkBQKaEqQnrchBQShXnogdIWd2s4GWJCAzJre0PdyrnsgR4SebQLCyhIqFUsVOK62O1HD5avIWe5Hr8SAb3XkAYNoQ63PlrqLD5MEpHcFI8dMgkU/Q6Dm6U9KFJWWYx+HoDbK32gD0EoXZMyDjyqLwpPMfAeWM8DzDH4lOsLLrTo8qCYnU4eLQW8GOuULr6JXj7nc6qwULtHTjz6/Sos+D+Sh3Cw8aWdRaIKi88Y3y6Pk9B7M5EtlGxoVEP8ACwsM5YdoiF7YIMvs6gj/+jyiZ0pp8ucIf+VIW7RutA8qfJ+NhhOGXiyCWexSScF1+8HIrwCIOvKyrbcPaESPJ6KCil1tGr8GYmh94X+r2PZxkU95rp5f+vGRoh1gE36HzqQTujoDdDzY/zfa5KjOwHV+S8T8+LVMSSnMnjBGc1tfp2W0+kb2HJ2/b25xhf2G0wapxFWOkB1kcTDvTDoBDSKWT/QadW427SiKXaLwDc4lw6CVw8LxIfzh2XtIUiFjvu89dE5sGqRcNRyor7gh7kGKO/zD6uebx0TJ9ydbtvIXivh6E/oaL25mBqC/AJwuQjPA8x+Gs+7sDRPVYu2BONg1zLI7spTzme2Ctc9AmTfnrhHs2ByXGt4/6L3hLRyI0b2J3uAMAC+CSnTNb+Y0PO/leAvOx1s1TIumnk/OQV/FqBJcSoPdPymxcRcr86Nxy4dd5zn8YrB3priPqyR6lEUcHw7jCFOc+48n5z7ArhE12sULJxUC4KGg2gY3QYhdu4ast0IeuSmx8ghDxRJlevwDhIdwfoPOrF6zBAuz/9oG6LMWgR5LYhgOSicCmnaduAB29YyVPCm7F4MkiNyeHcqisyskIYhJmk4tf6ixUGl4n5LwTPqaV9ISpmt
 Niw/Vw27
 Uaoq5CpbYyxfE7cGhVdrCRDu253c0M8MzbkD0LK/Sdtk6efiTRjYcOT6UNMVES3lQ2l/UTTo0W0xRqN42TVaxogks+owi0cMtHyLtQ7vFBA3W6SmydHAv8P7i+Kz9T3lg4WrOKACl2Ya016wBQDQbLQaFSIlyE1Lc3CwFxVKV0WsXdGpXu2GnSzqAZHVnB+0KSQIlXx839YmsxkEkesCIxxOqOS4jQnuT5U9PcDIrZKy/me5m5DNm7Aq3HV23gSOlZqkO1UgQ9XztbrDjmRZFucU93kaLlE4nQH+8tlqlTvM82jGDiRCk8bvD5zgeRnQAhpg2Pw0YjwQuk8Cy5KWyPT07gt79Ijn7WWB3JcuzqNjdesf6SRwU76ssFM6gQ1YhFx+Bahge7TUpkD5zywVt6RZZyICbrUGdfG7pD2vNpaPFyA8/9MOQ1QhgqenKzX9hhN5JfHqmryXann3uRIA1YHvrlRrcwvI+PwqDKh5M+i3exeBIik/jj4db6EkCnVctyDDP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 6:48=E2=80=AFPM Ke Sun via B4 Relay
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>
> SZ_4G is used by the Tyr driver when splitting the GPU VA range into
> user and kernel regions.

The message should explain what changes, e.g. a new paragraph after
this one like "Thus add a new trait that ... and implement it for
`u64` because ...".

> +const unsigned long long RUST_CONST_HELPER_SZ_4G =3D SZ_4G;

Is it added here to be nearby other sizes, or something else?

> +/// Only implemented for `u64`.

Intra-doc link: [`u64`]

With that:

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel

