Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2562CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 10:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48916B0005; Tue, 19 May 2026 06:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9806B0088; Tue, 19 May 2026 06:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE83F6B008C; Tue, 19 May 2026 06:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 981E16B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:51:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C3EE1C0D9F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:51:38 +0000 (UTC)
X-FDA: 84783853476.17.184EB34
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3C425C0011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:51:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BNtnNwGZ;
	spf=pass (imf22.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779187896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D09mIwXGgfWvJMWKI8G3+s17RZoSvUCDdrOthBfqo6s=;
	b=ZgYlvg8/jmWxFuAbFEzT6tPxwKFGkba2417zOib3xUJWrVgWoFFW+JVFjRlHQ6Hjf16mpL
	StB6kTpXNzlLLP1ZIySssd6/0wli4UaNRuPlSLJzyx4Iys0KkMJYKQuTYUCgAFMEgYmzhl
	tKypn3CobGdd4CxOnT78BLX7OVQyOhA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BNtnNwGZ;
	spf=pass (imf22.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779187896; a=rsa-sha256;
	cv=pass;
	b=kcjMLR6VCPsOf27orGcug/XhCSga2J36HM6h6R9bdffT4wPCFfD13RI/nrzZwsEyrRnNZ/
	w8VzHoq1IQL2cBxS82ojAxL6rWCrcyb34ak/jL76AEUiGm2xi4Oz2IkJVMdv+9TYAkLcuS
	pe3xcr5crY6/8g7QcbTsgTfbPwEoHn0=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-686af4e582aso2229527a12.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 03:51:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779187894; cv=none;
        d=google.com; s=arc-20240605;
        b=KDcvgBqafJOvNK3j+2G/z5HvKEcsjrgclMNzhX5N3h/75OjieltynXBjRfCRvZd4ty
         7KV2HMlSnqu9CfTwse4n7oAM0GeChVZ1SAcUi3JQzelnboy8F7DMSWz1nqMmukIpb06/
         CzljuhLtV4dmvCP/hgkQVTuQFuIIT6kXvKDs47KT4STwIVlCPrYXrkE2vxGP2hagCDM0
         brHvMToJvl0Fj40/Wsj8MQR0BSzC7n87RIPXA6VNWRzzg4fEFUQUVupBTDtq5GQhMo/P
         YOV4zqQNNhsJP3y9cUDEEwp1DUC2E9SYjkA431Ryd4HNPytaeAlktoyitLu+UB3FxWfq
         TZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D09mIwXGgfWvJMWKI8G3+s17RZoSvUCDdrOthBfqo6s=;
        fh=m/44MEYhnFYsi6d3kgbM6njsEGH7pOpek8seyNJNA7Y=;
        b=O+pbsTXlsEMTvJFXcxJ97bDhQRjPgdvXnqB/owlekNb8fFkY+m/Dcx1YD84jDSOygY
         2FI8wlobnDCjk61YPh6gtehyU4mjwzQFmlIFexnEMtgCvM4iNf7Iedq2NM90jCwROyF8
         6b9ICzXY5+CdyHt1kbp0AZAwBswME8vd80xDf+HHOfh+DSfqARgjHnXykE99Y7M0dz6P
         07VXCREQEimcbI9sRK12nznH+BHY4tzQsewzVdFRzgfzLvrvOgyt/hOE5bIOuIeT9iGw
         VJ8vnRQWLqaFggEAOyWJBtuIUe2SWFco0xdVNE8jCwlsbgjVoC4FE3r4CypxD9LKB+Pm
         GWIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779187894; x=1779792694; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D09mIwXGgfWvJMWKI8G3+s17RZoSvUCDdrOthBfqo6s=;
        b=BNtnNwGZmMiCz2MIN2hgfw3STrS4N9/8NiyxLn4Gr5aaVKDpPooamhF83NfT2dax1b
         qRBVCWssD5LxZInclkmBGMewn1KMMOjZ7twdjvdmjA5FDmgz/PKQBm2zJiBdgnkBO2ix
         mhS9osXyMeE/F7OkgMJokQPkat23zZUtsdxRSCJhAW4fvJy3HPS2E/CIUWHZmn+BZx0z
         mVKyYY7rjo1vyfqRnlWcoGvBgBv2TBceMyqD+dWbdz1wddW8aEvlfWjqA+g1kGYJD4L4
         S+BIL3vb5RJAMqeiBl78BvZQR843Y11kUyQahwMT1tbkfXWuOfL9PhV4luoS3xrYTTnN
         RAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779187894; x=1779792694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D09mIwXGgfWvJMWKI8G3+s17RZoSvUCDdrOthBfqo6s=;
        b=rBcgIcmz2yyCgYY/drCjPmwuc+L68yCiFmiJ1sanmFC+7BDosDKkytqn4ss/1MRvpq
         UmbIDE1DYdZ0ESVglOjvTUROqVAnByu13eqS1NXOOlEd0tHuU+brtFTilXjrUj9D1zRb
         zoipSEvf8gd3IK3FcN7Y3YhBoxbCUjDk0inCJjv6q9sdR9xwGfjBkEjtwu1NlYqqUZeK
         e8/axGB6u35t9gp8CQt5sDek/+KuO4D/6KM6hvtzH8t1bXT0TnQ+Pj4mWf52ekeEWi5M
         N1ukrK96SU+Q7VwzwDeXe0QyJyiTCmOpDCbAoP+ViQpke1BHiJqkPvKaTUwlm7iXCnm4
         Oj6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/+t4vJ+GJAFzVWOEFne6klHsLXH7QV1cKmmsHhyQClYp9WA99HHkQLk1yeipFZhwhq+At5angD1A==@kvack.org
X-Gm-Message-State: AOJu0YzXcEaFhV2XUBaYQs7TcK5iiQw3Ip7pGCHyTZ+Nj2u0nxyW5qcm
	eK0vJeWcP8kSRppOU7tdRAF2GOUyCAX4c6rwRoFwl0RRPKmcgZcIr6xeZsxkkRd1jk1OhEkuvKY
	elaW2iscQEqk6FX5af7FXg/Wlgvd12S8=
X-Gm-Gg: Acq92OFdAD7qn6GbCzsbHWe+sIhQ10DXU/oUWosP1v5rXGnRAhuJm5pyM5+wYCzjNmX
	e8DcEGoBCpZ/f4538lGvTZE1DQig1cYiVBdf4LnkH6EbFkfUwncsgf9rWXUmmYcJirEmAxsL3m7
	7hhuy2tMCVH5aNkQaFUZhzGP0t+NrVnyu1UbUz6N1C6o43nBTUcFPIKSeiMQr7og8nUofT3ntbR
	QmlSy3++8ivnIii2Zcj+BAb67R2ylk71FA6fzR0TttWo/N0or6s6gsTveiaWXWMKEE8FZFN3L/z
	qgfzvO4cBKR3P/c4JS/OLfdG3AsAH6lBkgi7UOM=
X-Received: by 2002:a05:6402:22e5:b0:67c:1c12:3ee6 with SMTP id
 4fb4d7f45d1cf-6830abcc48fmr7158004a12.5.1779187894290; Tue, 19 May 2026
 03:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260516182126.530498-1-pfalcato@suse.de> <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com> <177918418452.771415.4371785688744608623.b4-reply@b4>
In-Reply-To: <177918418452.771415.4371785688744608623.b4-reply@b4>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 19 May 2026 12:51:22 +0200
X-Gm-Features: AVHnY4KxwAsZR24cEVgsWChCgk4fjPFWjAc3-R7St5PMsRGg6TL6NPpS0u-UI6M
Message-ID: <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C425C0011
X-Stat-Signature: gxu9purjxzogpt4kjomaojz7u4fqfywm
X-HE-Tag: 1779187895-853701
X-HE-Meta: U2FsdGVkX18dgrRF4X/u3sXdQ0KLK75WwNcml1QzMaer/FpOQlTJBO/STtZKi18c5+raV3MYfVhR8B7nHt+CH/SPh6si5Oru6xpDWnOrntopyFjXX2/Vic2SzCntU6OECUvVxizKQPerIHecCm8/HiU8O2ECvFp65YcxljKmg1KWXLbuxQP0GMFdhO2aBiJdKdhG1OrqQd0faABM9uN3rF+N+ODVxh3+PgdacWV+l+IHAt+ya2ArZpfdrR7CXvVAQM6jfqQbiE/vraJ8HVuxkMsNt7HTs2tp82oQZfa8P0pvHpFDYoAx8TPJa+Papmkn3rP8HKXGVCWlepGs+Ii0LuDTCI6BRFq3xiZf4bI/Y+94Nr9oeeHEIHcR1xLkEjB4hby2OiVCcfA1McKu4A1aP/aVJOj1xHhu0ERfuuDKk6DN0EObwFGqeUFYGPeSoYw7vXpK1z9adEFwl8I3xqwW3Y2czjHK+rVruEoNE5w8dIzz76vmy+tg15C3DCkSGeOR/KZS+eprQMdVBG+6pqTYkblpnQS8ce1OPb9itqHiGSOpoCavs8Z/cJuQImT+gDp4RWE95buTnNpYB8N7Mpf4ft1q34lpcxN2WzByePbn3+llKd+kvUbiMBbn7noNnfXoxnR9zU7A361E9pBrCdvMMv8C8Leq3H1lbz8PR+eqbuRXKqpiunqvXRoGmc2d9JKjrRBs4WJXvOo6juMFgQ1IlqbcjW7pLApd/2m1tUxoXup3cqZVWgZVCst66UCiqTKfVWSchbjHyuWDb6Qv0ASyqSE2yJjJFt8vKU1i3YaUWAXGzCUXTIh5ixKKapVeIRGGNeIGdLnk5GGk9p52wEFFeN3K/7a0D5+UH8ZE8zF6CRjbnlihgpSsgYPEWQGyPBYlJveJ91XoXnWjTGefhWYbNp2oxCtkliuGEenNVLIVpI7bIe3WKA1i+sI8Jq1ezVY868tuc1UvhNoS8cL451E
 nIFVkpS4
 4xW2yWuw24bjaWa9+4+cip6d63w2zMDuV30v3THRTqpQ5fU6kkE0FnkEmbmMgxC/oCaKbE7c+iq2mWVrorEnNA6xo/x1SzvcPpVCOZiDsMxyTYnDeBuBSTIlLi/bh2c4BQSU4eMvcVQMumHdU+eNj4Bbag6r5OWZEkG+hrA4hJuoYo+s1+zLn0gqr/Tf2w25uQu6menfFrr0qLK4qQ1nn/CPDqgVneGhzlxaxSnRqiJBJ8U6HOzPiJ16gzKxOmyj7R9ZjncSY6Y0ngw1nU5SJJ5rgU1mLemzx5hQqaEI9cifH7mjbS81rf57jLNF7wnQd5psRcQiaoyu/5qTvZWIXfJCs4FFQYPzzm6wxSBkaWyPH/9VrWV7OzTTTe6NCHBZ56gx8MReAmT7LzgK5MMXS1bemDPi+gudnx9vAMIoz6EKrLwFQKGHEzInbI5j7IA2+yvfJrpvxAr1nQXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:49=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On 2026-05-18 20:59 +0200, Jann Horn wrote:
> > I feel like a sysctl for "disable all the splice-like interfaces and
> > zerocopy TX" would be reasonable to have? Either by blocking such
> > operations, or better, silently downgrading all such operations to
> > normal copies.
>
[..]
> I think blocking isn't going to be useful as it will make it harder for
> distros to turn this on. So we should degrade.
>
[..]
> Let's discuss the other aggressive alternative: Can we try and
> unconditionally degrade to copy. This would affect sendfile(), splice(),
> and vmsplice(). Worst-case we would have to introduce the sysctl
> retroactively.
>

I know at least nginx uses sendfile, but I never benchmarked how much it bu=
ys.

The original patch as proposed filters by rw perms on the file, which
I expect to exclude nginx.

While kernel-internal copy is still going to beat a userspace-based
read/write loop, this is still going to be a hit and I expect people
are going to complain. Afterwards you may end up with tutorials how to
re-enable pre-patch behavior, partially defeating the point.

How about denial of splice usage or degradation to copy are still on
the table, but based on a different criterion: whether code involved
is "known good" for lack of a better description. iow the kernel would
maintain a whitelist of "safe" cases. Random-ass AF_NOBODYEVERHEARDOF
does not make the cut.

Common-case usage would have to be audited of course, but this sounds
rather actionable and would provide hardening without much friction.

I can't stress enough that mucking around splice (even if worthwhile)
is merely addressing the currently popular attack vector and not the
general problem.

The general problem is that the kernel is expected to be able to run
with untrusted unprivileged users, while it avoidably exposes a huge
attack surface. Of course there is no way around providing a bunch of
syscalls to users, so *some* danger will always be there and one has
to expect that even core code has bugs which will be discovered by
LLMs in the coming months. Even then, there is tons of code which is
currently being audited by third parties and which has no use in most
setups. Instead it gets autoloaded in response to an exploit wishing
to take advantage of its bugs.

The huge attack surface was always a problematic position to be in,
but with the advent lf LLMs any unskilled person can drop a 0day and
the position is straight up untenable. In the long run there is no way
around blocking access to code by default, way beyond the current
splice proposal.

