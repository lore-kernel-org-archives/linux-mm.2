Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99844F01821
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD08B6B0005; Fri,  6 Mar 2026 06:04:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AC96B0089; Fri,  6 Mar 2026 06:04:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35766B008A; Fri,  6 Mar 2026 06:04:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07476B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:04:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 200C8140535
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:04:17 +0000 (UTC)
X-FDA: 84515354154.03.2CB0427
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 221514000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:04:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciWYckOi;
	spf=pass (imf12.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
	b=CVcIQKtqbdez77T9x4UG7hWESXKmA2NT/Xce+eqTaNyWGvg7yVhoGqrD7opKu67TQw32Mi
	N1nNgtSm9Tud1/ezgbAy2MJwS6nsIuMYlrkPI2WFYo45FcYqkmqjgot0U8FqO9XIBTMle1
	+uZ1lLz0Z4cWGe4KFfjVmLPGv+Mnhi4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772795055; a=rsa-sha256;
	cv=pass;
	b=rZgD5UqnrRZqRNweWrtca9V3OBzyxQZR/AYSo9GImpOuW13tBXoPqxr1i+66M8rumBtPtq
	74T25u7kQWT2P1LNUAwWNHMw9RUCXEDeuWv1vgnzhEYj/hOnUieH5ahW6IvNFJ+CF2+8Gb
	WmyhwxUImW1ZtjStGSU9YLQjEYDqkB0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciWYckOi;
	spf=pass (imf12.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-464ba2bb3aeso6711455b6e.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 03:04:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772795054; cv=none;
        d=google.com; s=arc-20240605;
        b=aEqcjqj2vpEZEbdTHPb3tJh10btcJve0NM9pCzNCqrzYodtvATBPL6y8LbIs7fywm2
         wSYridFQYfIa6fwGKFcpop66bb4ooli3Fn7C9sm2KfOgfyPfbtMvH5dW1CWLR4INH2il
         XoRLCJI7Shg1zZa7R24p0S1Qy0sJM0FPMG2NfOiyjNacl6laEfDj7zsIcpcnimIFLmlM
         CdtifXoMNECk5WSw7F3JbBJV981O94mHxbZawKtWX68MZOyunuqnJtLOXlfNidyGB7nA
         VIslsMbLkUAA/0f77by1VHmqWR8Rx1oiPaNwHcvF9uFSlhjH/vE98fimugGCWQEu4Dwl
         jZAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
        fh=zjDmdeXq4+v7p9Bs3SiXQ6FShqSDvpB/ngCMicMQYOo=;
        b=KusTPgPfopm78LznJXd5Vjr1VGQQLGk8t0L7HlcG5ssvv/6CYomYgVwz+sdA76/6Ga
         4jvfqiNxrgrAvcMBELkdWZnxCpa/PADoYPVWwHSpskrwvXP26hHhM2y86gRhd3Ib54tQ
         kUGXRutezqy3TgIggHQ0TeJi7RAoRz5DVQF50cFaZaTIClDZOX5Ahiybhk3eCa7HW66K
         8LmeWQwi/UG4bxWNqfS+fyoWZOmTdr/ncpnJok7o/HmvNbC2K4j5EzA0MlE114vUDvTk
         e1dR3VR/jNwkd0sLzTvXAW5eZsjApkLzq5fJZVZl6N4B4MD/osJ+EbrO71CiN85wZ/dZ
         rUKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772795054; x=1773399854; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
        b=ciWYckOiVCk8LgDJUeOkSH3bzkwX/TtHeJI9Unukz1tDhhZ2Whh6Og+zVzz7kESMvt
         MRLRb7WhVE2+ftopxT6GkFnE/eVpxjg1WPKaE9MPCgg6sjTYFnjJCrs/cIk05t939yqm
         thgfbax6Mcuw2pITGqLxCuEBdI9T4k2wRLSqoSWAUhxM6oMYgYoFcwUe/zpg0rHjhl8X
         hsTWiKPLNs/c8Crs891n1PlBP79gEWQgSGVOr5NtD6a1kW4wE+HeP7dyQzft9BveDa9k
         nsBSWt1ybI+eo5p3QS7wgnNENBks6FymJTKAhlsHer5SMSfzORUYwp3x22Y86oxt8bRa
         Fq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772795054; x=1773399854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4FBAY7Ptj233wihUnQns1LO/raURJqSuY43ghIQW2sU=;
        b=X3PW+n4Nqd//OA9LO5UAD04sjHToUEowqmdk3MFG8XoHw1ZmaCv2e5zEc1UJfHAsOR
         0p2p/8q2yzWNuK78jDC0BCuVSuZN4+CmRxS7S8REfGl9KQiSYOfp58hN92DXAZWmXNWY
         012X6E5l1aWx6GapU5XKnjCchtUf7tkQTSOql71utmwtxqG9QdRc/fGxUZDREh3EcXoO
         lZYWPuT5d756K2HSnBhd5Vp1a2FYvjYhSTeKjJETn20sPjhpbuN0tyrkupAX2OIHs5o+
         2xQnjFoiX7jdIkg9KW8evPJq0QRBjUFvjrcOuvrLGWkyRg/AdN5tgHDPH/Pp13h/Ewi+
         /8/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU57AaYjM01fmvSH0+RIWA3f93W57HV6vW5MoF7OYcNjySfOGFtvUg7k7JrTB7GOFWKjXSAAdoEGQ==@kvack.org
X-Gm-Message-State: AOJu0Yyji96UvDNlqFoKQF2+a8i6gZx6pzmV+kmmDQqM+FNTQl5yaHt7
	bAnuKmXKLLsCmH4iiz1IjFrrr4P2D6CG6JiLqGw/hRaYlaY3P/A3xcRVRlHOm6iDdLfAB/c2fg5
	O8RcWFXwyAxvBp+wM5Ha7Ju5DPwTXp5U=
X-Gm-Gg: ATEYQzx4OyfoVjCvb7N6vkYx3Jr79lsJXfYSpPRaDg0e6tAvDSEezSgaQRUI9z/Z6N8
	d71/5I+Io7UTFvEEcSA9ffQKRLKu25gEFNgHTL3hr/W7YobII/byrsSgKQKKT3uCKGnLJpohITm
	8k03hKKaCuyQrnFtNb/CP1noI33q8KPrZ+nUafSAvbv/Zqnk0dDF0ZzoEqXyoRPOe2YcciojOcm
	Hi9SI2Fsarg+3sRBFtZNhRhHhLkFD5E8AmDDOlJE8YWMPz+8xYjwI3LCj2KBLETRq9nsrbu8wGW
	yy3Qnng8h3MW0sujvj+K5If1mk4iC28TttYdLFw=
X-Received: by 2002:a05:6808:1522:b0:450:b87b:1ec4 with SMTP id
 5614622812f47-466dd0f715bmr888114b6e.15.1772795053874; Fri, 06 Mar 2026
 03:04:13 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
 <20260306094459.973-1-jiakaiPeanut@gmail.com> <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
In-Reply-To: <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
From: Jiakai Xu <jiakaipeanut@gmail.com>
Date: Fri, 6 Mar 2026 19:04:02 +0800
X-Gm-Features: AaiRm50fj2zUudpYSke1Ww9X_50G4gGf4UxVg0WDage5_ANMvrcVMJxjNhrQX6Q
Message-ID: <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy.shevchenko@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, glider@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 221514000D
X-Stat-Signature: kwxsqo9ou9fdprqqy99pe57akqdti1p3
X-HE-Tag: 1772795054-428877
X-HE-Meta: U2FsdGVkX18x453PxmwUIQS7s2vHzoJUYRM328Tt4gBAxLYFVcpNjvjbElTtKMaksWdveg+2qGclVqjZtkpOAMpUPc1MmKJq6b9Kg24Xvvtf3tEmuRvaiOH2HIsPUtkosmcZ9tB6FsfpKnJcRow33w8x/06cJtVptikj9L5kSD8hi2smI2t0QROBArF1zp4fx7ny9mNuMbJu2p7/3WCi6ioepB/IuPVE7lTOWJFw62g9PnOXXOo0VEXipHbLZ2rGpYOASxTzEkj4dEWu3N4ajX+4mU/BSVnJOAyRh60q7ZrKJn55DoHvUHrXpTgPBCTwA1Ne+4x0VjVrjO0nuOwOflpMNl/99w+c3d09Cdy4r4RBT/PDdslYg2jGvBsC2Nf75x9ZizOOLhvf7EsOyvdDRdz3MYfCHBIMoFCkWWeNwiiMnJB/TWl51Qrs7ZeLnwQIz/y62kEwGUJYWrmP7pdt0aZczmpIeoRigHqTHoF4nLyX9lWqmBuMm45VdMo2CY68VCo4PlN1bHWXNnXZ3Iy0MbEPYv8vnzPddfzke+u0BbQAjZPlhYwuBvzqd6yqPpNlIbs5vJjBu23Jy6iRMFdijk8eSEzl7sDMKzQ83ntfM3JALK4oDlKWqoD348G3P4feVRp3WE34WZFMZaKYCI93LkoeRFLCXSQPu4GzzXVXbOWgzrO68vyLjskDNV7TotNnjjWNCUVldSe1jjgcQiMwDtRq4a3icSxKX9KcPpVNS0PI4S6vcx6K0R+T+Uch/WvxDdb4WP9UMh180I9ABcKj4uDkxOFphLXYyve14+J7omJMJIH2TxFPcxpakHLuGdply06Nh/hySX0kXAD0pSWBEV9J6jWrRP7Aiph02Tb8OO37bQtICPGBfMoGwVyq4tCayRTCIf3FiH9AXhCl0aKhsKXlvaNxaJcZWB096wvSOKeXpGZKTGIARQMp73/gRYKlTbL58UuAezg+8z4qQot
 RQFIYiQ1
 i0t92OqzKiu13eBSrmnwj6V8oyCAsBBnAZMtuucxqp9nuPOQUmAAbR8MmINrfI8839N+8PTQoq/2LxsBDDu/XSTfIYKqNprm2SayvaA/rkLABucp7rT+JDKnlsy6uBKW019AxFkHFrNL1z82QYS4BCTjNYBuu1NAR6QSqkcm88iouSKffCVy2dhIUYjPQMfITkpAjyJ8FlAkandbyMO/y9q4dxa0wz2C/GV0jnOsj6YosQiUkITJvBUAkyrDNJCHBCpUOpOcIU8uFEQGK4Nvau3hemw0WRnu/TqGQnxLHo+aFejFDfxnB67fUb0cjrwsAwwExNp2PcDDUfKX6ThxXIUNwtlAGKCzwryKhRHvPH9nHtQQ01+bCHkKBRWEKd+2+Wt8MR9L8kJ9G9tGpmz2wcIFkyTgzJO7/41qGCqIZGjECtS1y/rDGX6DnGDBiTyihL8z9/G0ZlPA4iGqCoH4Xcn9tzUsG7mg40rt3JX06IvCgbMWVkSrp7RL2FZ7JCLg3QMn63F4jNpZya04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

Thanks for the detailed explanation.

Would it be fair to say that KFuzzTest is not well suited for testing
kernel functions that are heavily influenced by or have a significant
impact on kernel state?

I agree with your point that "the goal of the framework is to fuzz real
functions with realistic inputs." One thing I've been thinking about,
though, is how we determine what counts as "realistic" input for a given
function. If the generated inputs that a function would never actually
receive in practice, we'd likely end up chasing false-positive crashes
that don't represent real bugs.

Thanks,
Jiakai


On Fri, Mar 6, 2026 at 6:29=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.com=
> wrote:
> >
> > Hi Ethan and all,
>
> Hi Jiakai
>
> > I've been reading the KFuzzTest documentation patch (v4 3/6) with great
> > interest. I have some questions about the scope and applicability of th=
is
> > framework that I'd like to discuss with the community.
> >
> > The documentation states:
> > > It is intended for testing stateless or low-state functions that are
> > > difficult to reach from the system call interface, such as routines
> > > involved in file format parsing or complex data transformations.
> >
> > I'm trying to better understand what qualifies as a "stateless or
> > low-state function" in the kernel context. How do we define or identify
> > whether a kernel function is stateless or low-state?
> >
> > Also, I'm curious - what proportion of kernel functions would we
> > estimate falls into this category?
>
> I would define it based on "practical heuristics". A function is probably=
 a
> good candidate for KFuzzTest if it fits these loose criteria:
>
> - Minimal setup: KFuzzTest currently supports blob-based fuzzing, so the
>   function should consume raw data (or a thin wrapper struct) and not
>   require a complex web of pre-initialized objects or deep call-chain
>   prerequisites.
> - Manageable teardown: if the function allocates memory or creates
>   objects, the fuzzing harness must be able to cleanly free or revert
>   that state before the next iteration. An example of this can be found
>   in the pkcs7 example in patch 5/6 [1].
> - Non-destructive global impact: it's okay if the function touches global
>   state in minor ways (e.g., writing to the OID registry logs as is done
>   by the crypto/ functions that are fuzzed by the harnesses in patch 5/6)=
,
>   but what matters is that the kernel isn't left in a broken state before=
 the
>   next fuzzing iteration, meaning no leaked global locks, no corrupted
>   shared data structures, and no deadlocks.
>
> These loose criteria are just suggestions, as you can technically fuzz
> anything that you want to - KFuzzTest won't stop you. The danger is
> that the kernel isn't designed to have raw userspace inputs shoved
> into deep stateful functions out of nowhere. If a harness or function
> relies on complex ad-hoc state management or strict preconditions,
> fuzzing it out of context will likely just result in false positives, pan=
ics,
> and ultimately bogus harnesses.
>
> The goal of the framework is to fuzz real functions with realistic inputs
> without accidentally breaking other parts of the kernel that the function
> wasn't meant to touch. Therefore ideal targets (like the PKCS7 example)
> are ones with minimal setup (just passing a blob), have manageable
> teardown (like freeing a returned object on success) and don't
> destructively impact global state (even if they do minor things like
> printing to logs).
>
> That said, I'm curious to see what you come up with! I'm sure there are
> other use cases that I haven't thought of.
>
> [1] PKCS7 message parser fuzzing harness:
> https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@gmail=
.com/

