Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A51FCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFED6B0093; Fri, 22 May 2026 18:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069B66B0095; Fri, 22 May 2026 18:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A396B0096; Fri, 22 May 2026 18:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4FE06B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:45:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 974751A02DE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:45:20 +0000 (UTC)
X-FDA: 84796538400.29.FEFEFD2
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7EA1E20002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:45:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=W6ES65gH;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779489918; a=rsa-sha256;
	cv=none;
	b=7LYYqo8ZaFk2+hfiLwUtvWcddUkPH4VEtd87WdIytFdCBjy5HVjyev0uXTlVrTN+apauZQ
	ALervbC0LTL1Gs07E/peGCp23USRQY3sP/a1vodUItkA86tOXY9Fy/v/bpV9As5okM4Vx6
	BG1a2yYLV5f4z7Ej7B+bJH7IzYDEd8U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=W6ES65gH;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779489918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGhhwud0T2bSUGixoA5SMvgP96IcOgcTJzS7uIZ7FH8=;
	b=Qb3vg9WGNzulYgqSYdVd71xRiHtEIQOqXGb0sLcyeIkHDqFUUrgjg5bjNG+fwERghdWYFv
	rk51k9Pqbc75mjOtgTco3J8khMQZIM1tlJtTmfBT4Ih0ALapS9d9yrj2p93n4h7W83WkYf
	lB5xvjS+qpXIwRJFUhxc7JD7ZO5EaiA=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bd21ffaca79so1503631566b.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1779489917; x=1780094717; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DGhhwud0T2bSUGixoA5SMvgP96IcOgcTJzS7uIZ7FH8=;
        b=W6ES65gH+86r12dJW9MJqi095MV94EXQs1vppG3o6JwIlhLcsLIhJ06RMLrmokobXt
         PTWEgV3ZgYaV0Eyq5qW2W6p5gXTuhB3R/euyJ8CYbJXAkPM/7/1VAgjcXZz2l8Ov74uO
         79FsjlV/HULktVAxgL4zgq7WZShu6tRJTHqHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779489917; x=1780094717;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGhhwud0T2bSUGixoA5SMvgP96IcOgcTJzS7uIZ7FH8=;
        b=Dv9Wz6lFdVAC9M2zOOVD0DTYyZ8NrwSe3j2GHRcyL9hbc347OXw5A2RN7apUZy+xLc
         uC0c+JFtwcetNwkhIp0R23Bu5PdfkGZ1IY0d5jANbezAyin4CUIVSQ2yCRJqLaDIBt3+
         pzAtNvSVpxSLkf2iCL/iutq9NMtlsVJf2FWz2jqklwfyKBu9FFMvKMnTCg+gAxoaD/jj
         FsbqRlg+cGy9xDjNc+Dz/WacTAJ9pqkPl5Ffpfm6Lwy+Lh+TTkSLw9tIUqBPCBoodhiW
         y2kPRe4HxF0Zxs9kFCOC3CgnQlhciJTWsY6TfRKN9XwFBH7uUemXgxhM4RiInNKSlzSc
         k+HQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ExtrSNfc8nL0nGN+bqvPLdPPK2yuIWQwWq7PAR1Kfa6iMCa5Dpz4ugwPePxgTxzsefddukBmKaw==@kvack.org
X-Gm-Message-State: AOJu0YxczSp1rqvnxrYL/P6vuNANOSR5qA3Rb2s6oO/pqNuacsRrl7Rl
	Xvt/1hEbApa+pL8alIOb4ACd6gYYOs28zB+ILX7z4iSzPnjR8Xx3yi9i2qs2icVAamMo1GBwvFR
	d8IGWGPk=
X-Gm-Gg: Acq92OFzpTeUZRdfJlKsYHwjO1zD/otxsSqXFfX2djCnaV2mntlNaBVVxgKtju/oYqM
	7rnlbnbNuux9EDbQQzfBGrnXywqVVEVll9KIBPWq4zn44FF2fxwHXt/654isBDKSG1WWav0w6EU
	uCxYqrhTclo/GmrFHye31XcKIZwHlgOeRCNpoSA9aLiXuHpQnRs3bNU1oftCwJ5Ookqb9TJTvlP
	JDcusTm3Qfb+xKcQrd8Fs1sAcbnakAO8VNnjwZEvucCosvBNZ8ONmigdT0zK0cEnhMdpwjF/6+o
	OXpE7q19pgvl28oL5HCMrQjGpTS4lurHmT1v7CUvhqZfTUA+nrh95fGB2EJ4RNbWKgto7RgsPaN
	1/ll6ZER2hc/qm3uA6vtTd4oUcuzqj9iOKwzaaE4zbqgiYykFgzrBxqM0NzMrHA5ivoqMSLJBf/
	HgkvbxNyF+EQnvmSKawvN/zyXFK4sZKIAcH8/Mk37nVgoCIyg9Z3Ggg7khSe5spN7svDXRKh51
X-Received: by 2002:a17:907:960e:b0:bd8:fc89:cda0 with SMTP id a640c23a62f3a-bdc0181d01amr530526966b.24.1779489916667;
        Fri, 22 May 2026 15:45:16 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bddc264e419sm97231566b.12.2026.05.22.15.45.15
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 15:45:16 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bcda7765d64so1617574766b.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:45:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+LMEDGyXTlwVF3JJ/c0wofMEwagULnBJAOYyZfwArz6rGIGODAEcHDlfHhq12uDeDlZ6gvebzWYw==@kvack.org
X-Received: by 2002:a17:906:6a23:b0:bd3:329e:81e0 with SMTP id
 a640c23a62f3a-bdbffc5fe4bmr534033366b.9.1779489915282; Fri, 22 May 2026
 15:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260511214226.937793-1-minchan@kernel.org> <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com> <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
 <aggE2haQ7yGeHPeF@google.com> <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
 <agzNyXKIirm1zOob@google.com> <CAHk-=whqfr-M9ip9OWAUR1X6aOEy2P4gSWYDkbkTCc3E=jCz_A@mail.gmail.com>
In-Reply-To: <CAHk-=whqfr-M9ip9OWAUR1X6aOEy2P4gSWYDkbkTCc3E=jCz_A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 May 2026 15:44:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whMQsyjB6DOyWB73jPR4wrtcc++kZy4=hGQiRE+GxKh=A@mail.gmail.com>
X-Gm-Features: AVHnY4JHHOP3swFysb8Yirnvo4-2-fu_dlBx3L_5llutkMME2AiE0nERZWyjwO0
Message-ID: <CAHk-=whMQsyjB6DOyWB73jPR4wrtcc++kZy4=hGQiRE+GxKh=A@mail.gmail.com>
Subject: Re: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>, 
	akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EA1E20002
X-Rspamd-Server: rspam03
X-Stat-Signature: upm9bdgpjrojtpqb5f6ii9pnz9ukmyd8
X-HE-Tag: 1779489918-682973
X-HE-Meta: U2FsdGVkX1+2NR2wcQlTGxSQEU6kXhqnOwHQveM+YIDmEkqmMvQELpK6mk1wAkdBHBPbEfDstRX68rdBqQZEPppfUL5G9+bwK+KMeaF11tfbbIGfmFkdGI+yro1EaK6rbCqEnRcVujkPZV6Uaip32mQ+jUE1wqicwi/pAX7K7TJs6hE0zTmv9sb0nm6pb6axjPny8Dhm8RlA+QWAL4TAbVxnqj2GJo+JTxzf+LJ/JoVxdVA/G17lzh71C7AKle8jGgxbAo9esEN12+2Uop2GSoyUTgrEiyMYQtyOqupcx+L/LfbCqJXZ9QvHYyl1nImRSV1omJP67ozuqSjdo5T3JBsd9jm3H975mW5iYkGKHgILw8UHn0r8WorJOJzRqiC1NojkKthcCN1x8rk1F4ofzFEzRbsgToSIhJYb5vNG0b5Wj3ra5Ljx0OiFyfTk27oX0Y0OBSr2EVjjdW4evFF9Cw9o7j7ESAS7LyKy512+uE+1tHCSyxOfJuhGf877fa13w/saeZ0Jy1cxyHyxJZZmBBENzIpFBLwDu0fNpoR9/tGYXcBe51nSdl1tE7R+xej4YGmZJ+ykqg0d3J9SBzBlrt3qnLDfgbruzAyUZXFQ8B98q9ONpx3uJKIZmqXtwcRoYDIAIaNGcfoVktazhgUfdLt1sLRMu7JrMGdX4G9c6dbPS4MqmN8u5FYYpWvqWVmJ9HpSCy/2bSJi6TWcXntKLnNYgXS4T0S08SdmsoBpxnauC/zY4ZmfqfbdahLH/BeOpbWPTxaKvUAeZwxxhj0SjsX0Z8ScvJlKXYonejjrhdmKmzjCsnsxxV5Yaa8tCUbSk7sIrpI3sU4Zm1EolP/oXez3HUfRjS4CaMY0TQ/Mg5h+W7bglScFvoFkFI0aLs0q+8tEqYbSypinSKKzMheMq2dW7amsZxzLauj1gAiJktcmwU50lUqgqT4qhq0DqIyZIbhzFcmtfoL1UDUCeXI
 T7zXm1Ya
 FyQpjl33UqG9HbtwFKarcrFLkzmDjBPb4ThD+BjP5GHzHwUnKBACcYbw92CpNZElj2bbN9BbxSrh6KIbRaiuK6iQ5HFB0m1fKELr0TWGurgyKMPj4K15WHnfGV06nxVT46ZNhusKPr4AJttFOZ/IZRoVl1kVJi8gTZzMHIFrLofz4GIENVbPDXglOwEqIKmhcJw4gwmxEn+pbdaL92UQHzNHdGd+aBk4irEJog/TGjsBcqes4G4M143HbJqzO7C0GB/Sz6A1c1otzHrKixNradFWQ1Oju/mICHSWQrbtY/Vx8bwV8mZ4Qw4G/P3+iCYrzar3leBMjQw1jhlRA7Ymz6IGRuztFKrWxWDRp2CreWRwSP/7kQfesM29jz1GojxrNOu34sKVPuhWN5WLiF8aBn3iSgHWfV84k+tVEU93meIj1g+jBDNzrmGSuDOJC+dridBlVmvTnEUx6zy0Sll4yMvigrfdWUItDpjHNS9T9X0ubzou7TlVFluzJ+EHiP3g+8ODjDg4XqeX7yeNRMdtPHrqlnsX1gCvl1bIVekZrTBLi1O79U8vryb/o13TkIBA8O4EtjHsVSW+n2uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 at 15:41, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> At that point it will go through at most one iteration of show_smap()
> with the lock held, but that will be true even for your
> PIDFD_SIGNAL_PROCESS_GROUP_EXPEDITE case.

.. basically, what I'm arguing for is really to try to fix the
underlying *reason* for problems, not add new code and new
infrastructure elsewhere just because /proc/pid/smap and friends are
being difficult.

Let's really try to make them *not* cause difficulties for others instead.

          Linus

