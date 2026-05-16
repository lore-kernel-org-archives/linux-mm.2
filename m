Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0134DCD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 23:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289316B0005; Sat, 16 May 2026 19:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239EC6B0088; Sat, 16 May 2026 19:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128B86B008C; Sat, 16 May 2026 19:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F41CF6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 19:51:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CDDC160A84
	for <linux-mm@kvack.org>; Sat, 16 May 2026 23:51:33 +0000 (UTC)
X-FDA: 84774932466.19.2DC1257
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F8B2A0004
	for <linux-mm@kvack.org>; Sat, 16 May 2026 23:51:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZtoAcCtX;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778975491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEuDl9BbGL0tz01PdR2cvYCLLSzpkzQiU2vp6zLIhhY=;
	b=lx6fmMoe+lGDinNIBtwgLI9Jz2E0E7J9qgfoFqOpFGAYcFWlVBAHsU+PLfYxB225gI8zzK
	FB+s7G7DN3Nxjb24ur/+YA1uo/Q3kicYqwNNif5UssZhppVhXMFrEdNb+MrllUbZEgsl6b
	kVHcQ3RbmnhFWro9NcpkW/fMAKlIQXw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZtoAcCtX;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778975491; a=rsa-sha256;
	cv=pass;
	b=PYJAnDHAvUaesz5ZFpkiVsIWMeoAVbObGmgDA1kwhOtQtUfEFHPbPzli4QQdhm6bF7nIau
	fP0nb0vTLeFEpBr6S49uKk1Kca8tdhOINktYbrIAidLN9PFrcKPeVBX/b0S3t3LIdk3ox9
	JpL42bIFUVhuoR+tATB9PoOUV/Bq6Ko=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so2695347a12.3
        for <linux-mm@kvack.org>; Sat, 16 May 2026 16:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778975490; cv=none;
        d=google.com; s=arc-20240605;
        b=jeO+lpMxkIpI+aLnzZCsQy2HGUO3RYzPjlav1gO125qs3NS2B9Wb9b454nWA0HBue9
         RTowQVYjpdhfPZu3Mai6DuNxDKf2ICCLlofu+VKJKOD8H7+vXUlPZ9Zhd1340QgQF9Dr
         P8At3BCpCqWndNcqYMmeEXrnqXYrjGrZ59FANvtpKQ9sVMnqz2rYcQ44g3mZwhmk7dib
         FMIz5/ySKc4qHjgH+c+4CBWP/yGBoi6QpGS9CTYuktrgotduEeeIi/adoXV1L5zp5/61
         3fj4OmMAPpTbV1+T8pSMuMzfMuMJ+xQTeEFISMDFoQIweeXLtp50WQ8eRDCG+ZWV2lGb
         aLjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aEuDl9BbGL0tz01PdR2cvYCLLSzpkzQiU2vp6zLIhhY=;
        fh=u6QfcEVbj3lecCN8/UNrdn6j1YdGqZWqE37GjiNupSA=;
        b=Qg/nTxCu+dKyMwgRxhI5QG3ocHmY7tucJekbiKXUuDcjQHUbS3jXeCHo41DNMJK4IJ
         I/EGpje7vMntUS25XMMuLpJwVx0Lab6oIFZqDkBBjjWPV1o+qKbSFW1aOAAIGgLO8DEg
         0a1KITHMnmpvIZQdyF2OfJta81D7pwhIvnLpZeAhbuX7SgEDx2A2jT7RYtXz7/nO6RAb
         qHMZfE0BDlIL6+9qdjwlN90VF/dJyOuCUubip6yB6yofxehb6OVtFS1RTuJzvMXSEqok
         vt/BPp+uVk11nBgOJHmcTf/dv+BFyCeYMMosDo7lRUM56ezJ/JqjmedNI1W7JLw7hKQL
         qXnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778975490; x=1779580290; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aEuDl9BbGL0tz01PdR2cvYCLLSzpkzQiU2vp6zLIhhY=;
        b=ZtoAcCtXYqvZJwUp2xqdG8eLUn8RfOVhMBY1VfoKX6BtxCODGdgy+uFdtZGstGU8dq
         /SX93CAR/25EQ80YwLDP+x2qIKenOlo/YNd0ism29FCpuu44VVxZ0/ctK7B0OLUTSLd+
         18/CQ7oZ5nvV6he3lzNJUuLS8j31Ieh+7I9frUx1vfwoe5cjXRaOfZqWcUKgUYJ5xYOi
         ckJbMLa/p7D2H+gpxpH6ND+Wkjl9kDTD1l5NONdXv/Rvg6KhOcwICtcDpa10c622cezF
         vr0+pOmac8cqGn7AmpJNVda5hSmYTx65BA6t2e9OBg8ivw59zK/FgbRvLXr2LWJ8jH1W
         jAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778975490; x=1779580290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aEuDl9BbGL0tz01PdR2cvYCLLSzpkzQiU2vp6zLIhhY=;
        b=FlSLJbV9N2hLyP01kIukBMw12z/X2sXeCdeMnYwFSSqg82SNoq7zFhrPm3AuBhdMy2
         FrrRYi4JxtlbBdpEg2AeMlreKdv91T7o/WOOGhCtlUFD/mYul5Il79Zpp8tSospEfZsR
         AyddTMhFuI3wvArNWW3pLrjC3kvWcctzwWprrnWgYI2o9ciCgn2WgetKhGNA+hG4+Koo
         FDfkg042TSowPQOL7Bl9wFgXBK31hSDWwucwky+jxATclvB+7oOeHGVX0pYGM+5jkmeR
         jkKPayACaDRKAq3vgKqfnHqi/a2XLZ6OafUjQ2ySsNqtORg7soSA/YTJcnyBV8gVfzk6
         4JfA==
X-Forwarded-Encrypted: i=1; AFNElJ/WOPG+O4fVtyFVCZj/faDnUAaJvxwYO4gU967sRcOUqCY4f5yDdtooLsvYf7mF3Jztrb/c65j26w==@kvack.org
X-Gm-Message-State: AOJu0YwkW9BqJy+S8u6ZyyJbXglRFPIj8gbIY3UlUOxb8OlZCFuRJsMa
	c5f9/ITJ+rQDIakEU6im9YpYIrWmu2zwjtMtOtoyaxqhxckAXdxYR8C9RQ+7yHvE5BDmZiTxuvc
	vLhFZVSwn+1yAwxzIrlT0TrG3ciJQlVE=
X-Gm-Gg: Acq92OGxNgCMXNXnoPvBWktBkhVC6UDTePGu5I3aK9XP8m54/ccqtsYYep6CB0W8gJb
	iW9NEbaLZA3y4Aq0xYaXHIYX39B1x2TrtOddoKYv0ARtvxnf3C7NQxMTOswoUN3WbV9OX2xOlW+
	xl5y+ad/CGcSDcmW6+lZaMOz/v06j5N0lmEGB7D3ec7SES4dKWk/6Me/Lg7fsx5ewarg4lbjccn
	up27zeRsQnpxedMlcc90G8b5UOSI4giRUXnBiSbMSxU7oHYVqwItY2t7OiEO5bH8Jn24KBTYehV
	/8n3zB7p8oQlOEQUUDHzzO1AvrYddZn6IhjuJ4+OM4zZvHlkrg==
X-Received: by 2002:a05:6402:11d1:b0:676:67ec:a2cf with SMTP id
 4fb4d7f45d1cf-683bd08fad0mr4189598a12.20.1778975489646; Sat, 16 May 2026
 16:51:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260516182126.530498-1-pfalcato@suse.de>
In-Reply-To: <20260516182126.530498-1-pfalcato@suse.de>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 17 May 2026 01:51:16 +0200
X-Gm-Features: AVHnY4LQyyzXjVtPQhJb8qVVp3yQjS1Vt78uw12X8MN5Nrm3AJq0RnjAefRlP1U
Message-ID: <CAGudoHHeYbPWQbz+vXoS-Oi4PhxX6rh5XsMUkZetyfdnJHNj=g@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F8B2A0004
X-Stat-Signature: 6jcehteoweatdywai6gyj9zcmsdhe1gm
X-HE-Tag: 1778975491-766723
X-HE-Meta: U2FsdGVkX1+YyLmztlrSC2lZKe1m9jL2smeylHsXhxtS/LVPF1Y3lKu0uRqKMZ229ggHBoH3C1CtbQGVmXjN6pMlT2eKSfsnqN7a3KRHDn9onU6ULp3zbkTs4Z+2PAoWuDzIDHaOzzg0l31qE5ocdpGN//ObySXsCuJO63wXr6Pbf4EtW72+PdUUBzdtXsNbOz1yEwQ3fFDjVVFFknxcuIn3rqoBXdTiFhEQKEfIsXgbn87AtglRVZJfJPofHIs0kOQOhwYE/pptAlr4Dvuw5pdcddlCslEvlqoA94O/YzATMbkmptfHxpEBo8FC/uiSEeiIGm0bfTGwSQakfGUqxMNxDviSidbVTcxQv6692WERPNzHfNCVvcsuRFuY6zavjiRnVf0jB68HFS5hW5bFX9xBwF3jZuFCN5rNW832fFo7yiPHEalFV6f9/ueW80HFttsYBtzZsCBJztlVYjcOz/ITGHd0rwvfj20REcZYW25oUpcYGCoKbFylmLMKc6wXpoMH+Z/2DBl3OCiLghXYdo1/LxhzEMCrGDEE4AT7Kovi9kCAAp1qySAJzIgl8cSqiudxPp0b+RgJUEXMAxMtWsjSdjFq3EjTcqznHm9vkK0jgrAiGqd4+7y+OOWesUsh09jxDYzDwjw34OsErFrbSVN7qIm7HjkIT1NlSsW2ODNjArnVkz5GgvLvhtoG7+VQyNm60+8eC/VJDzW31PbrR90R0mhJwb5Yosn0whKd8AkGcIr3nl7QLkn//jzmi/uNrfIXzO9w5uvvc5sP73VOyKf077gl+sgwb1CzAOAZUlU9qZmWL9XTgFTSvuslYr+bo3q17wRSDNF5k5CHOTsuuiWvkv755iE36huipaqrMR+3GoyTSYj+2vH/ZEMIEh2LYUu7k1eEQpY8urtiKMgZET07pyhfNDVDgPaqGfp+ubx7d9R19vXBnPPosdXkXF7FPQWYcRJJ5zfo1B8Tfv9
 BCuI0w8l
 pZ0vC2lH+Wk9TjLK09efKzZt4Qsr/H+CyZJz6MdVDxtMST838TsTMNiOUeZPTmHLmr373O8PlBlUCMsVEavtufRmatSBfeoVqW6OHHpNEfiKdqeG6wEwJEXkNMnDpHltYDsQ0VMrfsU1lRJOYUqy5eB81CdjkabfL+f/ptNLcozCz65PlqfEV20cXGe+50MUxqaxtmCKqJHWpjoWpllgUlbUR04zRI29JJkMsuTvsIiIWyCL2jc3fKPqFeMDH/I31q6e3y3hfsyMQu4uBCr1WmAjAuK+bC/s6t6b7YxLMGgL3bWxP8Q8pIbLIEvKWEQmUafR78RJXyPB4iC/uPJ8Ad1rfgMJGblMws3zYiClcKDEmbGUNKhhb9Pka821je1FcufB2Gtpt3Cv0gYO3CjkIlptAshfPxdLC8zoDuSBrcw4zICI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 8:21=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> Since the advent of vulns like Dirty Pipe, Dirty Frag, Copy Fail
> and Fragnasia, splicing a read-only file is fundamentally unsafe.
>
> As such, as a mitigation, add a way for users to block splice() for
> files they cannot write to. This eliminates this whole class of exploits
> that use splice()+confusion in pipe/net/etc code to gain write-access to
> files they can only read.
>

The patch touches stuff I'm not familiar with, so no comments on that front=
.

The core idea is a half-measure which will at best buy few weeks until
splice bugs dry out and there will be a new attack vector du jour
which people point their LLMs at. Perhaps it is worth it as a bandaid
until a more complete solution shows up.

A full-measure solution would git rm these modules to
fuck^W^W^W^W^W^Wprevent suspicious modules from being usable by
unprivileged users to begin with, at least by default. Of the cases I
had seen so far, your typical machine either does not have the thing
loaded or in the worst case does not have a legitimate reason to
expose them. Someone(tm) would have to figure out a sensible setup
where stuff stops autoloading and there is a whitelist of modules
allowed on the box, and even then the functionality provided is only
usable by select people.

Back in the day I wrote a LSM which learned what kind of socket
options etc. are being used in a given workload and afterwards only
allowed that. The code never escaped $workplace, but the idea might be
a starting point.

All that aside, is someone with access to many tokens(tm) racing the
bad guys vs splice bugs? Realistically one has to assume there are
some more waiting (as suggested by the patch) and chances are decent
nobody has to be caught with their pants down even without the
aforementioned mitigation.

