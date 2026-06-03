Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EDECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A436B009F; Wed,  3 Jun 2026 11:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B626B00A0; Wed,  3 Jun 2026 11:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021A46B00A1; Wed,  3 Jun 2026 11:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5EBC6B009F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:32:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B83051602D5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:32:34 +0000 (UTC)
X-FDA: 84838993428.21.195EF17
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40C6140011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:32:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VFy0qMAQ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780500752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdBrjWRKLAumno5vFkve2ATlSCQiBIWYVQeSXYhWLKg=;
	b=4/gdNmM8/KFayr+zYBNwVFSzEdKH/yTJVjhabDnelnQEK4oHnugACYbcn52fgNcmF/KX+k
	2wN3xd+oc2dylC3yWO5bkNL1FDOhiApCvlw/1r8dwsYIbz3jIH5xxEviJUUis6Exw6V8AU
	+TjRovVDV3bDqYiklZE/kfK63wqVMI8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VFy0qMAQ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780500752;
	b=TEQkKjITwx25au2MA9W7yKe1R9/z/BMl1Vr1JfUNOHpFwTLlHKE/o8mDZCGFM/Fq5PhAIz
	2ZT/3sO8iI30Tjg7lLlKQQabn/pvK5qCdMi6UYTwAfDoi8RROWCX9YkYE6vWLKGpTiCHit
	Eav4gkqLg7Eqh48O+D+d2sqtCodUKB4=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68c1630159bso6802432a12.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780500750; x=1781105550; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EdBrjWRKLAumno5vFkve2ATlSCQiBIWYVQeSXYhWLKg=;
        b=VFy0qMAQpl2uxW9rQ7WhDQekg8UnC5Q3J0WrVzRoyFdUYa+W+38pAZHKCl91tOmFkW
         tg84L2YW2/n5qVuUhd8oQOVIww1VNvIMEBcPUUJEY/ks0aA5kmlKN82KnT0JuoU0Fwzs
         44YqFn+mk4lbSV+Xzb0fC/ICbboJMTY7eJpvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780500750; x=1781105550;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdBrjWRKLAumno5vFkve2ATlSCQiBIWYVQeSXYhWLKg=;
        b=QEkcmfQ3Q374Vc0Vw2HQVzLRhQ/9VwP2S21IKtsToDfEexQBETSYVDrP38rO9PF93p
         YH+pLgz6nfqOuIZqov2pOhuSZrXsIHUjH6eUpsw7A6/qDGLxgVDx+PwjzlUDRw2qeLC0
         otIMwRysg6UEciSFoyOPdLV22EP3afMDLGZ2866jaHneZsLdet+qNvDXMs0MPqt8Lg/h
         RaDkEg2oW+WeV97ZaTR2tgMvr2mGfybYCHKOTjrsl/e1rL0UPrLBrMZZspLormoaMt7h
         h0uAPfeEfDj0WdYZyQY4B0OtYaXiJ8ji7bNJObsvRrUFJieFE5UnMexc2KLKgtSHTXXl
         Nz5g==
X-Forwarded-Encrypted: i=1; AFNElJ8ueTWums6Dz3AwYUwMc1gmbecKJ6wU1fQwTCsW6mPOIwXZOhxhFJDsOY0tavLDCHjylZ9rFyfP+Q==@kvack.org
X-Gm-Message-State: AOJu0Yw5ge5OU4GdeUF/VAltZDzMd3WftPH9GEiS8b3ALt/w7cLyGPbk
	1m1QdcdzwmxFuXrUU7XIel6bitfJCYvu8x9+P78VqvihAOHrZXlKyM7U2C5TlrW6DFzTEfYvMTF
	mlyI7410Hng==
X-Gm-Gg: Acq92OFUTkWhqDCvwRU0lXT+rjecqdtq6q6zfa66aSroV08dzhqf4Bp+I/4rFN3Jv1y
	Ri5ceraNKGuz3e7kRRGDHeZpH1i0jUnpqE5qV9arWw6EJxOJkYVVY9k9P/tpvI/wdGNsdYHOjQ+
	ceJcjloOwI5+v2kP6qad268Y5qvaiXxC9PZ/296tynhvUu8cmSVYnYFI/xKHuIqdOUepMoNOqgl
	uR6HiBoO91xpzkCjEtuPlVZdx66Ve7+0errs+YrLnCRHeAR+rizNUTaF+uT5obqEnkJVO/fjXHG
	Y+HVnPrRMGh2iyLGhsosEpiefIPgodWO61ZDMQvMGfyi1DR/Uqzh3oLvN2zP4creStstHyK7pEL
	xOF9tSoCOSvTho4jtIMMuww9+ujy6PHvaqn/iVK4lMlIaGG1I6DKz/daUzPBexOi5mmEd8p8K5G
	dkrDLZOhV7UJL13p4e1/P10zhSv02uOEULlrvR83nt+FwDN63smMBmtPQgCbbnAt4LYGr3kQ8/U
	gDNC05IgB8=
X-Received: by 2002:a17:907:c289:b0:bee:19d0:dba0 with SMTP id a640c23a62f3a-bf0af9fcd20mr202814266b.48.1780500750244;
        Wed, 03 Jun 2026 08:32:30 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054dfe3aesm174358966b.37.2026.06.03.08.32.29
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 08:32:30 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bec354815b9so385606266b.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:32:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+jElk6npUJZAyA6Rl5gghbNThJKNCXlJudn9uKlXbSXnzomcNtrQ6XN8R9SU0FQ0wmPEBi8HOH3A==@kvack.org
X-Received: by 2002:a17:907:3f0e:b0:bed:19af:f8aa with SMTP id
 a640c23a62f3a-bf0acf0f958mr176902766b.13.1780500418629; Wed, 03 Jun 2026
 08:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <20260603-navigieren-pleite-stilvoll-60e6da66b1d4@brauner> <20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner>
In-Reply-To: <20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 08:26:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com>
X-Gm-Features: AVHnY4Kj73Z8AasW6cIfq1Oi-uE8PGC_0Rj2_P-0GPM116OFy2hMKOC9XAw-q3o
Message-ID: <CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, 
	axboe@kernel.dk, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5x5uptb3by7716syprf1huu89d7garzy
X-Rspamd-Queue-Id: 40C6140011
X-HE-Tag: 1780500752-13197
X-HE-Meta: U2FsdGVkX18VRn6qOE+ys2vZhzccdykhbjWW8qtsI92S0IQa0EmZbwNeK0MJVix5OobSL19ubEq2xypRtXYIZjlh0UuO4PBChqft+EUqh24gFuZ2oII4K8QCYoSROm187VUMCJh/QlcorgW3WoU/Es3Sy/vm49azAFf8+ycB6eT1A9GL2uX6sjPFrc4ysrDzCqhTjBjkM5hcmk8cQbjxlSp4aT2Z9gtdDi0gE8Hj8gNFbF6TW0FonUtikgkpFrL5wqrALxMus4EH61GfR176IiT6b/ZOOiOQSCMHj5yON82ZgmRPQMjjFhSx0MzU/TRXsBsheYbpU0PvgQGTriJIOtoM6pYnuM+Rzzq86aO2FzfgHZWyq02Yk4KhTDgRmra0W9yIbS672iia55hZmLm1HofZIvfCuKnBvB1ZHeQSA42EMdQdUWt8G2UYlx76hQvGJs38fzDJfJr2VVM+BZVora/N8m3CeXW5taNCON4+pE05uPAh6rcAldNM9/avVBNE9Bjpz0R4VgDxhk+BY380Xwxd8ecQbkSPRmmRYP3Qbh3RyQTlpjdOqzxm8AC/vrp8cLSHuxDU4Dnnix45uv6IAKVAbvJ+aq+bxtfkgLrfEVDMJWuH8Dra9NzWudDdAJwQdGBzu3pjI3WvZNafp+Qe+bmwyVXbsHkgI+xC7uuNrXV6l1kIzWkeBM8KF9XKGEhYVmrB0PHsR0WXpgNiWQ4rHkxEGEceDzeFZ5ty+WrEDmUkKCT8nNC37+vLQpyBOS9gg0gZg8iHTqAP5N++3xJCkTiMOqnvUObTFo3w6eB9glU8V+lqjmqrvfaNKseh0jBK/AZNV4ZEfvSIHMd4vTL9gWMjNYq9XSCXXTxjdmmFfFnbNSAZ0VsbnZ8/NKTDyUdKd8P23t3ueJjNx69hooUXw0gHKae0rLSYivasZxDzFYC6nlJ07P9D5IqIo58Ew8vWDG/D0rA2Th0+tJs3Bqk
 vNjDiB4C
 c0nKrQGSJ/LXWLADwwEnoEHF0BEX7pHteaPKlV5sfkHNzGtmCWLAJ/210Q/Bsss0mWLPKc5bQ/VukqOp9BU4HrZ0VP4DA8bmhJpTIN5R8V2hkds5VKMoFZhcnx81mH06mDYnADYYJ7CNktvhcqwSKwIX53vG7Lr4Hx26vkaZNrJOJh4+GQl6Ly+beKjbFqKu24puU97HELx59018RJE4L44SjfTme9gkNxQQecdvhkLvibSULsgxb//Q3A7bRJbM7GxfPS8pjiCmLbGC7wI5g7o47A+AE2fVoX9GcrDgY4SMqNOG+904lqtcc1axIDw00YXtB6yoXwRpVIyL+6IbvmYQsvzasvveOk0l/OJvT8m8UI3Oxay3oib9Tw9ih18R4d8V0Osx3ElYb99kszbRboV4k1m68Mke34sO1VTY4CXXF+5EHU/WEBGXem6BPhPgbWwQdUH5odPb3My9HCVf2zxF7pRsDyvocXdlM1ysHbS9Fu9vqLj6rwkvb5iQDaVVTq9ILEra9dOJA0lCF+soRA5FjSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 06:40, Christian Brauner <brauner@kernel.org> wrote:
>
> Prior to the change add_to_pipe() returns -EAGAIN the moment the pipe is
> full. So iter_to_pipe stops and returns a partial count capped at pipe
> capacity. For a 128K buffer over a 64K pipe the first call returns 64K,
> the test drains it, call 2 returns the remaining 64K. Done.
>
> After this change do_writev(... flags & SPLICE_F_NONBLOCK ? RWF_NOWAIT :
> 0) then calls pipe_write which does not stop when the pipe fills. It
> blocks until the entire iovec is consumed.
>
> I kinda think we need to preserve similar semantics.

Ack. We definitely do need to keep the old semantics.

Looking at the patch again, I think it's that

    (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0

thing that is broken. I think splice_to_pipe is *always* nowait - but
has the special conditional _initial_ wait.

So I think the RWF_NOWAIT should be unconditional to the do_writev(),
and instead the code should do something like

        ret = wait_for_space(pipe, flags);
        if (!ret) do_writev(...RWF_NOWAIT);

but admittedly I did not think very much about the details, so I might
miss something.

Which also then probably measn that we should just keep the legacy
wrapper in fs/splice.c and we'd just need to make do_writev() and
do_readv() non-static.

Because I'd rather keep wait_for_space() internal to splice (or
alternatively we'd move it to pipe.c, rename it to
"pipe_wait_for_space()", and change the 'flags' argument to be a
boolean to not make it use that splice-specific flags etc).

            Linus

