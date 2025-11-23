Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D5BCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCC96B002E; Sun, 23 Nov 2025 14:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3C36B002F; Sun, 23 Nov 2025 14:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2076B0030; Sun, 23 Nov 2025 14:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B35AF6B002E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:48:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 556D7140196
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:48:02 +0000 (UTC)
X-FDA: 84142907604.22.7CCBDF1
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 915ADA0003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:48:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BzI3goa/";
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763927280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOLeUSo3o5SBFlUfWe5vQkS+cA1Md4hcupDnroSWT6k=;
	b=eDc1syO8rqYQXgrqEvPaGTI1hSj1/AZN756EH6bxuxf92LhN4qtW/RLcVVp6LhOoYB35qZ
	jeQgSfWItgHunR3UyftuXVilzrueontiBqeAzCpERhf+P0M+3+XqwsQUlPeSjBMDWGTbpb
	OpCIjJoljEJ7wzFtjnB8M9uaIZQToG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763927280; a=rsa-sha256;
	cv=none;
	b=7eWjdc5e/6WcPjklMVXUINxh0osSa/2OblbwRUzZk0Ju5xdbMVYaXZUCAAyg4jIlK4FCbV
	KGhsHW4vwmr4PxzNnlxzvTPIY0nCrAo2zsoQM4Kf5l/LLUFHFYes8KTJ2b5yefAR5BPdFE
	mrq58KVq/KbuVAu3fCFfvsKQAt6Y8T0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BzI3goa/";
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b739ef3f739so119520466b.1
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763927279; x=1764532079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOLeUSo3o5SBFlUfWe5vQkS+cA1Md4hcupDnroSWT6k=;
        b=BzI3goa/GJ1LnE6PnnoPS7GYbj6d+GSOV/sIg26pm5eOZYoF1S/JYlNRpYoSgTl/kt
         I7NWptdwbsimsS5DT8CruuCzOT3BPpw//GCjqbUZFivT4s7/IAE9/SprgvOeqVKdU4do
         DBBsO7orWOE71js0PcdVNTEhgYAD3ghbXst/qnq8cp02+kskBigPv8sCNxTJMy3FkvcW
         FDp6R7+x7J/o1zpk3m++K3S7tq8NlqxdkijhaHa2kd5g9RQZkozpqjLWn/PK88cot4gT
         kuN8VWXgGzAMpSAyCIWuIUmxA1EaLP1tRddDp7Lc7JQq+7W7B8+yBJmuSoyI2tluTu+T
         nvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763927279; x=1764532079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MOLeUSo3o5SBFlUfWe5vQkS+cA1Md4hcupDnroSWT6k=;
        b=Qj2m63bdQ21pAMWoLGylHxRY4jpmP1WQE+OeKrUhn1dq+972BZQC+r//tqc9xNLnUE
         9pQiWMJtK/tgAJQXOA9a+RoZkmRmpvLUr4GDiKxq8sabyzU+SJZVD4Ni9CddUq1GyIqy
         JR6us7FM/xrKtH+WoMhX2r9dT6GtZgz4tQRZl/Wm9LF66hWLOaazAYvHeL4ZIKMt2BZ9
         HeGEFBpgEkpNZ/dWeMOP1xfqYbxy6OjdyFteVFXsgrr25nwfOuIb86ywx+oL309KGIVD
         vKjQiUwWCCgMx0WaJRh7xlvf9SpaXUdAQybK7iMyaXYJIYV8muDhIJTGfupe+9YW/G1h
         6wsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpk6oeh7RW2ZS/vXB23L9XjoLzUF/CKjPBc7WIIjw3Pt2gHE98Jc8Sd7Y8DvbeEgqG7Vp/6t2NdQ==@kvack.org
X-Gm-Message-State: AOJu0YzfhsclgspK+dfUMo5YTJdW3ARdDDJ+czte85yLRZ+avKZdoUoP
	qzXlfLZKEzScVoUpCxJM3AF9sRM03e81MSlbjuCLZa46zBXwvqfrELn+2Uv4cjJ1vh2hNxSzzUa
	G0YbEN5M5i6zzzNCrVfBQg6vXipFQ+4o=
X-Gm-Gg: ASbGnct/K5ZfhAEUiPLu60lH31R9isrjHKpVUB3yZnqSzD/czt7jISSA5xaidCoCNl1
	1CGbzn3KjtvSicSZkDwIYmwEkmlOAvrr4Y5yNfDaaQrkQcz59Lo7zKhDNpjnpQysLkmHq66qK3Q
	CCcXyEG7XhGQgLkx9vL2CUmp19bEmXg2PpbTQMdwvsHS09sjiaEa1UPHP+N4nM9twUZGlGFBoM+
	U7vGgQVkP7pTan3FMWFoZ5FYxYFAE1bpLBikUb4ueybxqvf9CRJ6UcwIj/OVRhLHVDv36A8TcgF
	cyUbylBw2F/UE3PE5kjk+L6EfA==
X-Google-Smtp-Source: AGHT+IGs2vL+Lx1oy6cfXH9OqhVPQ7cphVjDJ/WiyUA5zh7IwwTVXMeWBp90eaLtC0aueXAO+MGkPiJALwuVIb+l7Dw=
X-Received: by 2002:a17:907:da3:b0:b76:4c16:6b06 with SMTP id
 a640c23a62f3a-b767151c777mr1043412366b.1.1763927278915; Sun, 23 Nov 2025
 11:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <20251123063054.3502938-3-mjguzik@gmail.com>
 <aSNZVv6BZCZcRsgs@redhat.com>
In-Reply-To: <aSNZVv6BZCZcRsgs@redhat.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 23 Nov 2025 20:47:46 +0100
X-Gm-Features: AWmQ_blsncgMWSpZrXBnevLWPVFUW0BRu0-qFUmSDK4m4riyE3H2iHrMuTXBOsk
Message-ID: <CAGudoHEsUV+fe4vY7G0FF3T_bki=Nh-QxmLk29+s6ySMqyf-Eg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ns: pad refcount
To: Oleg Nesterov <oleg@redhat.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 915ADA0003
X-Stat-Signature: n31p5u3q9wp9gbggzrtip78hbqpd88qg
X-HE-Tag: 1763927280-86829
X-HE-Meta: U2FsdGVkX19RdKRXKVeEMDbPIZMbr+isk8nw7nwAA8XFmvFGy+nsH+OitmMc4QAMF1UYcen0Nlu/RJ6K7omY8+jORQ85xBDOmpSwxou2oVZjAhZQNtUAYrufKd+tEAzZAIYioVxYn0j5fgrzco3mQvcGucex6sHtYMBVIZRst4/WWGv65hof//1Tl3Mq/8K2C+5SDHBmnCLVZ21FhHid4CCo45UWHPK2MIyfX9lGH/HplPXxQjlde7Bp+ZO7uggvRcYqEZGuJxITU67x0R8pg6CGoM7wXPdSCqpWtKbZJQk6TGbx/W6vTFvNe8KC0e+x6VwOd5vxkzmh/6SWZB9zQMjKZR2C023dmqtf7irCygfeUoIwJ/deliXBa/oHgvf46f1F/zVtb7m0hy4+Z/0//k6vjby5W3T5hmGFMYqhECfI8suE83tYyjGeuSwFJQAxVY2vFBTD/HTX6cI/CCtgMuYHK6iupR7LSsDvlrC9EogdjPoBBOaeg8+J/ng2N8s2sMp/DoElc1eIfWv/LINObGcF/YUJ9ed/Dw2tU6eHirONb2Z6Rx62H58QxkBV2CBwHiX6BxA0Fq0I+4oCrDLZBV8BqIjxaUfroN/j6HieKarKvJaxcDeQhjY9d0LNyZNjhyMrCwKQhWzFU36PyQmoKaNydITFX+llX8ylJU6jjg04lljPRZznR2IVwOvfnk65M1FbdLNwDQ9zC5LiwQ42yGyNOJ033VCERrcHa4AS/WL3AKeo//yBOCPiZUOtvvgT6+raByvlkXrqqKLjJmnua5E+gKrlGR3eyCjbIT37MxYGBaIw+/Mx9+uHxiHwHbNNxNaRUql2anQ/PPWyVPOK2wvhDX0veXXJRT3kamcpWr50hn7x8TnH5SvZsnu+2PC9PUNBQedQuBWnkbPaG9tvp/vgXSGLl/vYs54wp7e4wU6lH5JR96pfEKsNejnlFoeIS4xhzFKgVYIrc8NH1ew
 1UYZjpPo
 MCwbkxx935kX0Xsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 7:58=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> On 11/23, Mateusz Guzik wrote:
> >
> >  struct ns_common {
> > +     struct {
> > +             refcount_t __ns_ref; /* do not use directly */
> > +     } ____cacheline_aligned_in_smp;
>
> Cough... stupid question. Why not just
>
>         refcount_t __ns_ref ____cacheline_aligned_in_smp;
>
> ? why do we need the anonymous struct?
>

This would merely align the offset of the field, with the rest
directly following.

