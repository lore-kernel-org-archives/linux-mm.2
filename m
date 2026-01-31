Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5ABDE6BF3C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35C36B0088; Fri, 30 Jan 2026 19:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3696B0089; Fri, 30 Jan 2026 19:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC47C6B008A; Fri, 30 Jan 2026 19:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBFC36B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:15:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36BE61A071C
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:10 +0000 (UTC)
X-FDA: 84390339180.30.17D95D5
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 07F6D40006
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Jo1oQbqP;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769818508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV4mmOV+uOXX/Y9XduJfQAli873FtpKVEKD92eDGYCM=;
	b=TLll80eH7jd9i+oUehN+DIT8l/3k3uW5sVm7mmFmC5CACY8H95DRL6w20WHFKtmON3j7VE
	UE5qdBRYldZqB7ehsuxeMrOWkah6ikdBLlk233SvxNdI89GBUAzA1e2gxXjUNhNGXsAIdx
	eoQAFXIn1G/tJTiy8pVi536D63b46c0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Jo1oQbqP;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769818508; a=rsa-sha256;
	cv=none;
	b=N0NJsJYw6CB61+IVNlti3GT9nT0beo5D1wpNd1Gzudd77V3iOoOpB5J32+UEmnKeNA+ogp
	fBrqCK8xc61bk9MaLZYaeC/Glvwuhljv0kSOGMCftrlxcc+D3TolF2VZudix2eFJR7bL5K
	EUER7zsclLMFQQiWba96mliL8ixaRY0=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65807298140so4433091a12.2
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769818506; x=1770423306; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qV4mmOV+uOXX/Y9XduJfQAli873FtpKVEKD92eDGYCM=;
        b=Jo1oQbqPFKL7kdOfeWaaD4XZslG2Cl9cELvGe/19eZoUj/WPO9rgh5xFM8tC+USJhg
         odMBlx4wrItzCtlCahecFmcIbePKQj+1mB33lbP8qcCgdjg8gffPZQJrgGYjP0UITBbp
         u9AHtBsZVlxqVgVUJfDk5wXUZRZk9FGA99fuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769818506; x=1770423306;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qV4mmOV+uOXX/Y9XduJfQAli873FtpKVEKD92eDGYCM=;
        b=U0Dk1jrVQgtjZfmEZScK3MgsuGF8GZqEjNy7NgV6l9yYNatT1YgR3sBx8n/WDYdhhw
         mZlqPNMrwwPED1Xp2noDoWwdlDLm4FvQgKPfqAG2aZynqkOUTERdLrGB+LidcrFGfgEn
         iaiU4Yve5/IlewPhPjc70TqcNo+uGcCPfBhrTrru34GtHwXCmQzPSalte8yXBk8wpTBw
         5x6Ffm77bzo78NBmwcGCP8TFL69JXbxv8DYSlIQHsrIPqascwn5rIdTYst1zkDtLe+Ml
         cYwrFH22GmLNM3JS27L9uYBodmwZeuiZv4O9VHdHKJmgpSadtl1petSB2WXXyxbngBI8
         lUzg==
X-Forwarded-Encrypted: i=1; AJvYcCXNPDquarpm5SxoHXrvqLIwBBZz4bzNsLN31WulaWPaOKh7nljwpI7DYQzZ3FqTowWuaDkm/zJNmg==@kvack.org
X-Gm-Message-State: AOJu0YyCdsI1RMBFjCtn3PY1F+4AcqiklralZ97HcKe6YNeDpqcZ6oAw
	fkBkTfORgyTtoJNfnRhWshAAh6t6AyAZELiTspxB4ascvdJfGOBAnWP4lAGsd6ceMoelw74rmPL
	s463BMeA=
X-Gm-Gg: AZuq6aLsoLmxFe4AQJfJ+9rYT6vZjCH+hLmV34HfGSqrOcxn9B09ozy6ZVYts0PO7S9
	tsk40QkuRpUUrV1Vh7NUGK4pV1gWh0OQBOrJveFobCHqMC++GmaXgZk3DDnkCxo3k0w2uQ9wnTf
	ivAaTGhJG5ZiWBGe7EDQWFliAYeoWbMljjbfJoGolMYVfccc/7kLWvXV7a0fI6rg7ssSxQmaFo7
	G9ObzXuj7RqkzoEvsL1ocT/iVBbVU8AWuLFyhy7VBUHBXo9lNNbVTfUhULEz0yAzUqkL2viReqU
	+fBm1HnKFsJbOXs0BlttQv4Ud09A6D4T9Bh0h7lfD2DA1OWjnLKT5ifY8nRmXmGFnhpTyca6HAc
	n8VvHsmdpkPlMlvpaIZWU05Vw8oSZFW0FT22FtwGvxX8SoGG6C0IO3IhuwPO8icDD9XI8fr4s8k
	of6sRfwdQTCnYtrWyiZO2BICNiPr5mIzqotBXjALG0X8KBS6Zio5zbx9mmGrhK
X-Received: by 2002:a05:6402:f15:b0:658:cc59:1608 with SMTP id 4fb4d7f45d1cf-658de557d1cmr2088651a12.14.1769818506227;
        Fri, 30 Jan 2026 16:15:06 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b46ac0e8sm4658858a12.34.2026.01.30.16.15.04
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 16:15:04 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-658b511573cso4635801a12.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:15:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW3hkH6wc6hF1JjvnXFSU9VoBWX2VyBeYojFzTKNBFcaxZ5jo78AWTtgRAUfJN/PUIK8ibMsZrFuw==@kvack.org
X-Received: by 2002:a05:6402:1d54:b0:64b:4f44:60ef with SMTP id
 4fb4d7f45d1cf-658de593957mr2779765a12.27.1769818504441; Fri, 30 Jan 2026
 16:15:04 -0800 (PST)
MIME-Version: 1.0
References: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
In-Reply-To: <20260130235743.GW3183987@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jan 2026 16:14:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
X-Gm-Features: AZwV_QjK3epqif7-e_sBGUc-n0f418Z3nV80PkvQC8yX5DIdQ4ynfWKt9EE0KMI
Message-ID: <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Samuel Wu <wusamuel@google.com>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07F6D40006
X-Stat-Signature: porwqq85wanhun6o4oitci13rj6k5hjj
X-Rspam-User: 
X-HE-Tag: 1769818507-562617
X-HE-Meta: U2FsdGVkX1/ymm3IYUlJu6EsPkH54uT8KRu0NKojiHkBCLtiVdZxtt/x6f8E7SHcy8FRkX3EkcUOKZodOOnSYU5ZlIBBdR+y+LM7FDxSpl7z/h9zw/zogNKpqizGVoyflYXW+BX4HcQNS3g/0KBaHPeSLuanlM/IjKPBURaQKrVmtV8Bixs0cPXh17F/WALSUtC9Jm6hT9qrF6b4aemqXZZVEBoDR4vB8k++RrZ9tNZ7p5cnYjglUNFXBqzulgVnoxgjvQVB8epCpUJhIOELRy0bhBDpWpb+VEWILf0J/v5xlHraq5Qh7VNPe+/+UmyqACsAAN5hQmK/+r0I1CdO6ogbfvP3SO90fmvE1pw5iXOFsKAnVGqIf9jaZrzlrOFNwVccwXL1TSQlB5k02bXqbzfLfuyVZhBT21XFNmiJF9DXkAW8fa89zkQR/dKa6JvZ6/EliEG/oEvLqHKjW7u8NR2hVek8/sUG8P1iGkVcR5Z4rlvAW3PjZeYr+tBJZ7yDSyE7s+BoPJRW2/oz0eB+4qUJRdLvAKAdl1UDmHxnV47mpCct9gmqMgfvi/MELPYdSSySYAyKrFyv38NR9DlSvYOe4Vyt2GsszgywKOndZ3diMq4XO7p6twkRwlC/Mc9Pec01FQVD9ldALTHzdQtzX6xDexSGoHn/5CjxCLgX2btIKLCHgcz+NW2WxVSI14axMMAForwqNN1UeB7FGGEHCI42lRGO2TgIwmey/uopPvn3husa+0cGTRRmFQYgAPnelxk02G7Zjvx+1uXG6IA+jR2ytOar6etVJhOzMNXssQMlPFG3h5cHcn8IQK+utUe3YuRrWFvCUexcofcQYLU87hSGHapKrj4HDSp39blKlOBE8aIDnOK96dnM9oTWUDxt38p6wthoAv4sQNOHbPzz7Mr/dw4IEJqMezA7Xh59G8HCMlu31hAY4LnYgvCuWGAIJ/6+tuHuoDgahnkPCEd
 hqCxRWNu
 gq2wfS/CnjAqSYZSeT5+eb0jHmkUaem3l4oZnoCsT3GXQFWm2Mk/MB4SvjVnljIjJlsr+QH1NjhJjx2iZYz+4pzF6vIzu9ODBT/S94dyFfF+8G5fCodDlYQKOHqaKHFC44bZfTLtgw2/F/N5/xJjUKgUYuAAIaIzP1caJXUuec6QcaAy1eqCQGITJLPDQHpQJ+bF9aB8sUB3w7tOSVQcsKygxzLSZ0TUVNBcsDadMIqmgX/c9JRhZGZjRbQnC6X45fkUM6syORf3j6YX0Z/lxWl45LpH0MT/Wg3W5cozaqNY/vP/75yV0zo2zWiIU43B2GLAKR7XP18uqFqidZcSgbtNQqv0tlQLnYvsQ9u8byxGDGdgqIolsLLcHyYIHpMPcGHr/3lrQBYfD+ShPkY7WeDtTjesfxoSuPdp8nc3BTCJuhn8XN6jz79LqY/tLCbdFzMoxetY+2wE0njwUONMBBX4tYNxeDJZhLQ7jMwB380vxAHe9qmplMvC4S9VzfQpzy7Xh1JySen3XNvaRNi3oxmYJmr90QqGZjCQrMRLLl3p28/w/NrI36L7/HacWp8Aus+bIli2viUoRsYZ1T5Sv0tW81TC/1kXQ0R+wQg8SKceBcQFOjlAs513S5Js406gmVGKpyBwCVe0izcoefl3+umWkaxHB2CDs/XoZvKG8gjjqq9CqQFs1mB3oBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 at 15:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> So we have something that does O_NDELAY opens of ep0 *and* does not retry on
> EAGAIN?
>
> How lovely...

Actually, I think that is pretty normal behavior.

Generally, O_NDELAY and friends should *NOT* turn locks into trylocks
- because user space has no sane way to deal with kernel lock issues,
and user space simply shouldn't care.

So O_NDELAY should be about avoiding IO, not about avoiding perfectly
normal locks.

Of course, that horrendous driver locking is broken, since it holds
the lock over IO, so that driver basically conflates IO and locking,
and that's arguably the fundamental problem here.

But I suspect that for this case, we should just pass in zero to
ffs_mutex_lock() on open, and say that the O_NONBLOCK flag is purely
about the subsequent IO, not about the open() itself.

That is, after all, how the driver used to work.

                Linus

