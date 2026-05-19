Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD81CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E35E6B008A; Tue, 19 May 2026 12:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393FE6B008C; Tue, 19 May 2026 12:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA6A6B0092; Tue, 19 May 2026 12:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19EAC6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:29:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0F3D1A0710
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:28:59 +0000 (UTC)
X-FDA: 84784703598.21.2BCF590
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id D26B6160014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:28:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qKac3but;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779208137; a=rsa-sha256;
	cv=pass;
	b=F0RHNmnCQLDP8tuoLzKXg1JA05ByipTKj7YELS5WpA5Vzb8h1uy65I9IRlYrIJ4FF+AH9I
	aK7dpwjGdrAresH5SaV8Y3ZY69q4BaXvyteqWFdfmx0DvFnNrO1m6F/6PgGdapczHn5bG1
	d2y0S1IXlzL4FPPNRc8rm6LaDMkhn+k=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qKac3but;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779208137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgHIUZbE96lJi5/obMLvIptZs8Oy9Rc15UQ301wY7TU=;
	b=cNrNAMH3pwUa4x8W/B+JgkrBxJiP1sHUOKOhTORRE7Vq3AfFPv1KUV1iom6W1ga37iOTw/
	v498WwHmGG6ameUKDUSgTcqUXhTcAhRgN1Q/9PCASP7xMyfYvj9kOvRzo0jkt5m25g+QgW
	nUuCkxLbR2y46lQUNz4s31ppOysbzWU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67c1eea6b4dso476a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:28:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779208136; cv=none;
        d=google.com; s=arc-20240605;
        b=T2vgx1l4WSjrwcWxhlP5MumGRE9ovmFrZPLESExZtt8ECtkDOHEdP1Sc3CYM5XF67D
         TRza+dU7Bpw6AZtvWwIv6zjhne6Hvg7AGT1AeWScvHVQb8kZDGI33OoZBOvjRgakQ0t4
         TwBtrmTKJzNY5F/s4j7H3qgq6TfjqOTOiZNvzHnwKPhcodkEb62AHuh7Q00QYmP8R8ii
         FknMWtuxxIOLZ4iIhFLuyzX4bKu6/pSxUcX+PKCZ3Pdu0gmeIslLimbVrZj8o3tgUg+D
         niHrJTQbB6Y3rPJ7B2neDsA0e4pAkw9pXA6OiP7IgIT4wujAEqfZTrLtAFu1cfnrRJ3h
         NfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kgHIUZbE96lJi5/obMLvIptZs8Oy9Rc15UQ301wY7TU=;
        fh=K2yvO6mEr8TIKBzf5u1dJq85Ijhac82mbzKN0iYTALQ=;
        b=Q+YFmnx34YzeOCfthz0AJntiTtgWaEk5Lgl9X3nPKryXLlIhEE6vgC7g3kFtf6kkg/
         2xv+Ek7knvEJ3bUPmEbV0TXK7XFVRVfeVV0IMviemDmQUoUH7oS7QlL5XDYFElr7tsvg
         gb49roSzCbfEXYS4HkYiwTCow1llswrJXW4QJfeEJWcsYYclATmHcjvGz46lY7YARkV7
         aU1Y81+98DGbgXFB68HC8JZJbQ3lBrrX9H8QUMKK2knUw/MkSEsE0BBVzZIkC7hIUApF
         y6JVkcEm1zqfNKQCLwNsH1LW7FQ1blYvEJ7rgmb8eZEqSad8pwxqFewaOl77hhK/DiP4
         lrGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779208136; x=1779812936; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgHIUZbE96lJi5/obMLvIptZs8Oy9Rc15UQ301wY7TU=;
        b=qKac3buty4JNZ6eyVGzEnLKbixLwvXSWM5b/4A9STDgzPPv+zZB2FozEyK/zM/mTMF
         xL5DrE9bJL7+LxGOBPnaRyZEjf8BzYOEthYcTTe25S8rakDO0DtfcE0FLBpceAUnaQVh
         rjTy/eJ/xx2NigeUGOJzAZM8F12QJGUCoMaIk9HaRH0M6ixfUe2WiGNggqVh5CI2DyPB
         Ai7AuBu57VoazkrRvfDS2WRMHbUM6EKt/r9OqhgN5IP1s6Cs8OjnDqEhIZA017d0ecYP
         Oi/K+YaF07y4chGfjiFE8z+2I8QnflGTIUo0B8t79jDs1FUlUmdskIWcl4Hnahd8KpsN
         PlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779208136; x=1779812936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kgHIUZbE96lJi5/obMLvIptZs8Oy9Rc15UQ301wY7TU=;
        b=GzudxArPh4ipPMDOxBD/hcfGsmNvF6funKdlyKs+pkC+yni2yGrTDeptPpnOQOzzZY
         Q+cMA99VsDQj1cDoPIhm6FlB+82avnNc1Cqn34srIwXyk8BbLFidSjBn/ipSCtP4Y17E
         LC2gRPfGybGTLRdoiZAo5ghgKt9ZoAbVYLg3D2pbkbBTfWDnIoxJ671ZW/+0E+1vt1je
         PsAXeep+X9GW4gqJsnlawxDOPMgEK14TG0mxH0S5nXgZ3SHRfTVlU2NE7exO3BZdg5H0
         AFxCxxCdAzBnsGVbpp0w1UTIn8SsPbI5fB4/Awules3h+xIloSyt45cPnOPmCDhcTm4T
         Pyzw==
X-Forwarded-Encrypted: i=1; AFNElJ+WPX1KeLlNx2nZTV+eZ/xn2iBYT/ZqdKgyCcj4MVrp08voyh3fXzNXr8BHLMJa1HjeYC7vDVA/iA==@kvack.org
X-Gm-Message-State: AOJu0YxJoF7aaqv77Z9QtBeUKEgMZF4sYz+vy6oWRlpgIyp9d+f00JTu
	yfqbG/e/y9YPAs4tio6U6+0vqmXKh5YfOF9X38Ene8NnPBSpG3qV4GZ5uYRNRImtVhofmsqZ0cJ
	zeYPUBgkAzxJVQxoWwZW2T1FFyjgXA1TQiR77z21L
X-Gm-Gg: Acq92OFxgyRXE77dc4L7MjzGFJFZIcRbsrveekiRiC3VLXbn/1wd27jRCSWf8YMyPMD
	+ufZZ5DwodYQwGOFKBuMsP5Hh9VaHuCE70gGwosKTf0P5JJDaqFTr9heBXSgrKI2sk3TwZWbT2C
	ZWU0IcDf0r8UKT4CgY33I9atkq+v59GERa7AYhE55wucuvlJnXDtIXSkmax8TgAZ9kMGY++QcFr
	I0fX7AAWrD002OlixbTeCI2A42Nqp7K9UyY+GtDpbbF4vnZx+7uWAE7z//adh6NCknihd0JWtrx
	Llk2RERA458O7EQkc5kOD9afu3RIBrC/MzplO1rSRILRIv+u
X-Received: by 2002:a05:6402:a143:b0:67b:8283:6240 with SMTP id
 4fb4d7f45d1cf-684986edae8mr162870a12.7.1779208135980; Tue, 19 May 2026
 09:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260516182126.530498-1-pfalcato@suse.de> <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
 <177918418452.771415.4371785688744608623.b4-reply@b4> <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
In-Reply-To: <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 18:28:18 +0200
X-Gm-Features: AVHnY4KItrX90sdPIrOiWL_DdFaddul15rGgYiuLpLDe6wZbCoeUuSPEm4x5pzQ
Message-ID: <CAG48ez03iWJteZiUvRe6o6_O9N_G4BYwgBBvAXF2QOJvXkKELQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9oyh3spa6i4fimjqzrwuz4x6deybcooj
X-Rspam-User: 
X-Rspamd-Queue-Id: D26B6160014
X-Rspamd-Server: rspam07
X-HE-Tag: 1779208137-500444
X-HE-Meta: U2FsdGVkX1+VIsdVeLFq+nb95F0ibniNriT+hP/+TPk4BG8KRdmEuBfbj6Aq/+gCVCLLrB8nMvKDsp9r6T7ceCMOjbZeNqVUJpBn/WVVxwZF1qs9udsuGvZKx7AgWJTAFJDXQtvdwNHNthZv/uzRbkJZnk+kxuoJrrANW9d5R3r3dv90tx+599IMfjL4w0OJxp4/RsrYW0VtXhuBxfkm4Lf9BgdakgNXU4xkP8rZBM7AEfZl7V9EqEUck8pWBmp2/SDSuS9uyFPWvXjpDgHXqjDHtn6PoVQxCBUGUaY9xcJUHlvJlrihXew6OrmTgowR0E/coOW/+nRuMTlAk8jmL+/L0H2MMfGQ7lxqNVnNPP3VR7GEnCFuYDt7ar/PCzo4WilOOJXCIRIyy5CYPOv2WnQbYlkljccs+2dx3MVJZUNGTTS+ZQFmr4baeUykrmQjySXSMbVTe2imeHNpq6nLzyrYNJjl41Ea6KXgv98NxvBUG0Bza9kz6YAAJQRMJD9ojbG18jGXZqlLf/8UJHRlDOZWbjsiWl0uxzkKcneQ6qfdTO1LnmUs3F4IGwtbjl1P4S1EJD1/ewEyK1IA2xHmyeTVBLatwSs/MFFP90o9lh2S5NX43c8z0B0qHrudqm5dMy5GKhbN6d26Tm0/7Wa+DRHO4ES2MJ4a487Ln1f5QE/QzC5PPJnZ0en6qSm7DnxYSyIQ1/FRsniXcP1u9ZT8v3eBsdXdrhPSiqU3EIFg40Gxt5NIy2BMC8/rrxTBsjpEp5/QBPprSREuYsLVVFi0N2CPJ0a5lrH3VXS+5mluFkmn49uprPAvGaAHmZv/9LTtqZr8TF4W5VlmbIAwH+BGpqU7rcGeem3t3P8k2xYIz0Ezm9lj0HoL3qGaBwO34FuCuZQJJMABdZITOTUDkrttIB//9Ova7l2NdypoRjW3RigSqUF3KGMwIWex4qIVvt6OmG5qbPcuoK37X4vMXPB
 JZL9BMto
 vrSFxph/lEIyKVln0LrDOr1nIw1JJ9E9hHImP1dsgTLhw58TFHN+w8/VV3d41VVPI5TS3zhgt6qMczDtvRhd4GwA4vIZi2vsIHZWtN4rw7Jug4plZ43cLTTDo2mdZEq7kFuWMdhk8e/p9FeIa6VBIaaidHxVijUlHZ+42x1hauTYYU2NuKf7EAbIR8Ui+GUGR5ct9unrhFppXeK80RW2bgNrUierxLxLiBnGwazT38Y+hvy6s6ycD3Gx1MvWXsWINJdlHN63dI7DDPIy8a8uhpHFfAhw1BwkXUfIw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:51=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> =
wrote:
> I can't stress enough that mucking around splice (even if worthwhile)
> is merely addressing the currently popular attack vector and not the
> general problem.
[...]
> The huge attack surface was always a problematic position to be in,
> but with the advent lf LLMs any unskilled person can drop a 0day and
> the position is straight up untenable. In the long run there is no way
> around blocking access to code by default, way beyond the current
> splice proposal.

Sure - but the path to that is putting restrictions on the
availability of individual kernel features, and this proposal is one
step toward that.

These splice/vmsplice functions have been part of security bugs in the
past, and have contributed to making other security bugs easier to
exploit too. I think it's a sufficiently big problem area to warrant a
disable toggle, especially since this is more or less just a
performance optimization that we should be able to nerf without
outright breaking anything.

