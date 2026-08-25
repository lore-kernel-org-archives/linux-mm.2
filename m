Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A86C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BA06B0096; Tue, 25 Aug 2026 15:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3BE6B0098; Tue, 25 Aug 2026 15:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24C76B0099; Tue, 25 Aug 2026 15:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBAF66B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:31:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38B00C0188
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:31:04 +0000 (UTC)
X-FDA: 85140784848.26.C7490F5
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 45DCC1C0002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:31:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z75Zgxez;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787686262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNgSdype1mNwitZBXug95FkyN38/VTRy2nwLEQed+5U=;
	b=YMKTqsRtK+Uos7frDEqHxAx8SUvbxYJUGTXE6JxdEUI+Sxw9bSCQiOvIuKsJtdt29FOJRc
	jr7wcDZDNZEPIE9V5dyHMyFkOqywafoonSadzvg2ede2tRF6XCpH/bGTeaIQTA7o5GKg6Q
	zOxWBehaaj1WHtnHm+8/pjyLa89dWwM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z75Zgxez;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787686262;
	b=tb2xZd2vAiTozG8zm55rDDBz3tY03oi5yOOnugCGd5OYPtO97FUlojSDiOrT4vKE73ol4P
	WYvSM9qfQZwqLEheaQhBV0nmSVI53zaiHhbpzJkP7H8ahLF8w5fMcEgpuSjuhdm5dgvR9o
	9W+PhrNlxjBv6RChaFcP3xQQrWitgUM=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-45eddb6fdccso134895fac.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787686261; cv=none;
        d=google.com; s=arc-20260327;
        b=GnjBuIVAie2MNIcc4POiIddwe2KDx6FtYUqSzanSbAzCufCtQZ0e1C+MEoGrzY/Eea
         LWeQnaa+/orDG69PMqiO5lV+uTzLighadusyPiUdWACysk6YIdQKRQlxjOikDTnBNGpS
         oRZf8jCAKd+f3L+3YhA/vJSKC+a0v/U32Mz4Nczoice/0xG9I/OEkwiR6jIZxiUO1bnG
         jiEm/XtgasqaXjBimjIQU+zzb1tcNdPqYQtuxZBdq/tvZqAXTFx//QIL2a2Mr290Kq8r
         v0H7S3ypLZsSfISpkLZiykoGM+pSR7eNtpC/9EGkn9C34MqAtKksoL/TTLmsEQxA3s5W
         yfTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dNgSdype1mNwitZBXug95FkyN38/VTRy2nwLEQed+5U=;
        fh=1luO7D9rF5z3DottuZSsKtZUmpil+A88qKumwgSMZcg=;
        b=UZYqZdjRdnQQkvJ7GXQzcU/amRPNmnJ/KUeoGo0lL5j5hsyE/fLt2Ag4JM1bRe/Gs9
         VpJ5AGEPrP4446eV5h1Bc1lqo+SnjqIkIqB6AH5tfs2OaOyUoQmIDD8MqghrCyf3EpZe
         28SWVFrtmFc+ET1Rf0kVo0g+VrOtlfDyTnPOMzVxMg6wkBPOBo56wNeyIXzZoNBwQc6M
         gVy/X756VdaXf1Exldej4Jr9MDHLxA+RTXv9a6pmMgtR8ARy9E2YvCfeLMn0662PyJfM
         K+7YQkkvlMacxyMNatpOlZGpTZXg8k8CdaoP7WabinzPARUH9z4bUPo8AyiGGkVp0jSZ
         CzBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787686261; x=1788291061; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dNgSdype1mNwitZBXug95FkyN38/VTRy2nwLEQed+5U=;
        b=Z75ZgxezAVyNj6nMQ46CGeL4HOjhibIAGbE/iMiOQcgn5b0w9VKYAFGpGSIm2COyw9
         +GqKDC+cvKEGNkWOzzwGLnR7poh40hPZZnei4XTLuFWlYdRbJgJebFfm/NgKENYUWRSa
         l1ZnvzZm9cRtRa72xKbLkE4udiYjlyBoqhPKRvUd7XZMrIQMnMHwl7Uh3ynrIlGkEjbF
         EX49vw2rronXRLcrftxwDFNKY7OuDD3cct5fLMTzrw3DUVGvtJkMoxDXKabKwm20V6H5
         msQQGDqDVtn9ove0fi0OsRh4hLOKFgZF8+nKspPfeuOSDKD/tfzIDDFHU/gpTE1a0Koz
         0ZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787686261; x=1788291061;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dNgSdype1mNwitZBXug95FkyN38/VTRy2nwLEQed+5U=;
        b=HWnmytoThCZhuXkpVR0RtEj7ul0t5zSC1Jjxc7IPZWvZcWsfQ0Hff3jDQFv5sEOosl
         lC8VWNA5rDFRPoEgelMlmTEzsLOSfoK/e4Bl2x/ahqLSlAKjIWQJFfinuvHRXhktjcj5
         ICDwDaksWz5ICTD9/G34AXraUdUPfloEZs6y7TP7rorZ7G/TSgJTjd6bRqQLpnZP/U6H
         yt6LtJ5RSwlEhdddXfwIn1jgqI8LD8RK642F386t+gtMfLAHAvaICGfLsreqVTkBMcyD
         U5G3NVV0KHToYH/9B99ewkX4W7Aj+YCk2WFN4Pz5o3EqmxXOVvPnv7AaJaW+U7R7sZUV
         1SZA==
X-Forwarded-Encrypted: i=1; AHgh+RpFnDOh9ajdJIUja8P5TDjRXG8sreibUVTWmB//0VCLYLcRBn63MyCqr6NG+T0au/HjgXZMha8iTg==@kvack.org
X-Gm-Message-State: AFuF++k7UNrjPaJ/ufTC+4SDYn6aZ4cXOBqLCCshX9O3fnft3Nmpha5S
	aiZrbaiquNkava3A/AOjiird8TScrMynBzoaAISVXWfpYHU2eAp2kJg+VIM4fCCuksiVxVlxUmi
	2jK6bSVfrz/X0CCDvXGYKlp5CsQbvp7w=
X-Gm-Gg: AR+sD13XSOvo+L3hM9Pz0fO0olFGP8DDLirSDulR4cZssCEjWaY/r5FHBSVwjf4yuE/
	fwS4JxeM+2O0yJ2JhDMlBSIjbpGI6QGMO4E7W1ykbOO7073tPH9VfWbtdwlzKRN0ubRiUZwsBoJ
	j4eN/NXRrv8nQni/SQdI5n+NriOyUn21TXUmyyR2XMd4oFgAQLc2RK2DEHhwrQ5kWB/G14wEp69
	8098+lekXISpyucgAsD8XGDUBBB9T6/JlCnAGmtMueYGZ9DW4CX8lBXqbaR/1ySsyx8CgA5xpTp
	tP/1D5hVWLlpnCrUZxspYTZXTOGOGHVyCGrv5uG3uJSkBDm4nhAjEN4=
X-Received: by 2002:a05:6870:6110:b0:455:9a0a:f40f with SMTP id
 586e51a60fabf-4659af5add6mr1857019fac.12.1787686261101; Tue, 25 Aug 2026
 12:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com> <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
In-Reply-To: <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Tue, 25 Aug 2026 15:30:49 -0400
X-Gm-Features: AcwNN1W7w3jv19S12dsWPPPWvBnTdscjqtDJ6w6TlqCes7086WzzU9lKHcWHgo0
Message-ID: <CAEjxPJ7ecY4msx_tGxW1bO9ywDpB0wRv3GtQyu2SnsGV9May_g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE introspection
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 558yb4g8kohyctzm5tcyuphtu8sd3ddu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45DCC1C0002
X-Rspam-User: 
X-HE-Tag: 1787686262-696416
X-HE-Meta: U2FsdGVkX18SHDoB5l90G4SUxI/qS5Rb3du+sXpNeywrjNNQ231RLxr1LL9Xug7TUgTT+2TNv0cl+ZScXA+wnAhWqMqZaZzwKUYZpK7F9rzSh6A2WJh3QrQIV4R28Q36ICrodHw6BuOzii7w93Js/Mj3t3nMkzWM51/sZHrhMpM/4E68f4xsg6jPeAEXKE/OxNz7Ljd1JUDe2G19ODUAruFU/vfqIHwsvxnDR/UrVJhi2sykwZsojZjkNye0ipyJREGIckv2COe7RPOYwvNP+cndhn0bVlYHzkzRrIc0mhK/WxajOl8tDXLujez+vr1NyjmYMNTlecm7PeXGPjIVpAuW/pIu6Ww0SxMvvHgvY5moDYdp0ytCriEFCvB9gcGsQ/I61P6CCvK63k4eY7SAScEBU0cWPfqLVEYoA49YpLrlmBLbZOgZT0QzdOpy5T3Gj11K8gw92DWXfe5OWUHbjIdDHD7OfB0/nXBWsQKHIGb3h7qGTPpnnPCktvCLXFfnwrEZtWr7yJPp7H1ul7hLVHENHBUKdYdW6tm4u5m9iH0Cu3ys+PclB+nLriLoKBfbAnVANTrom1IsOPSm+sszKlgNyJ3KTgbqbWDhLTu1ud6H+0quuBVAyyooWRkZkUT5ODmWzYtG2275Z65cwv4DeK49AXX7cbRg+rxf19uQI2eGa+9lKO4c4XIOJxTQd5e+uUW4K3NMiKCy3FmnjooMlotungVZm1zticvUZwJTd/SpwHgx99VOiRqBoeu33Yo2Oael4ZxzZ1jLSJ6EuhoGHK5dF/W/Idf02yuxXteCGXBoKt9QkSsDyMBHzSeUXqEoQkbdM7I73Tonzv1QVeRXKdGSoAFtwZyMzxR1BYfoYNvM314Em6baO4+zeWYj5fOUpM8aKSCTSmseC+z9WpL650KAT3UcfYezbevDCvB3Aj1iUYDlWTdbmV3jBsT9oR+1w65ylEIehw1Qbxq38Fs
 eB/Q2JAb
 UnPwqTV0eqjR365NzX/ZBCI1n/iCbNPyngDgfymLh27TAD0YHOaxx+Has8E29wlXwiItTOdTYnJgXbp8DOwpXyqJlbbXiXJSZxZ30HU7dmgDv0UrOZBDy7jNNS7TMwmd3OM3d5rJ76z7McC7D8Iq9jH6/Zsy9vEUmE9gMqiNM1yi+Z226CcOlIvOjwL+5oQ0mmViNrWLpP7ByZGGBg0SfvIVTWrz9fKJYeNNjS2aB3/eyLl9EOnCFCZoeF0sBFsZIATlLBk/l7ubCk/0K7M79TcUlP8FaDqw1r246aEah8QRpA3u5fYI36PFsEhagD/LkI7yuztwhl8qQWXTbwzs4wT/WMpw4IsmW8I7Zg5/GJCiFUQQJ0NpIcnFYjJtld6l59AkRqlNGTzqluuEWc3MIcqevWep3ZdK9GqMtOblxSEabDiE3acVG6CWlpEM9L7zE5ucstt3hgYFxBcvxL70WAcaKk7xidLySvqaSLS3jTRF0xQiM3gbX//tQspsTpjw/p5KDjZIFsjHUyCj3nmdhCghqug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 2:39=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process c=
an
> only create anonymous executable memory via /proc/self/mem if it has
> PROCESS__PTRACE (like when using /proc/$pid/mem of another process).
>
> This closes a hole in code integrity enforcement that Project Zero has us=
ed
> in a remote Android exploit chain:
> It was possible to use a memory corruption bug in a service without
> EXECMEM/EXECMOD/PTRACE permission to overwrite executable code via
> /proc/self/mem, which made it possible to load and run shellcode containi=
ng
> a kernel exploit.
>
> Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

