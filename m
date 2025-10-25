Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BADCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 17:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F287680008; Sat, 25 Oct 2025 13:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFF58E0150; Sat, 25 Oct 2025 13:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15A780008; Sat, 25 Oct 2025 13:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE0B28E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:54:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89D1F1DCE42
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 17:54:16 +0000 (UTC)
X-FDA: 84037385712.25.974A872
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21016180002
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 17:54:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a1HUSyQO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761414854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dCnsJxwgqeFs7PKSg+Ud/3vJjVEQ1NvMAtuR/PgdkQ=;
	b=rTkWmoRzMp9EVqEoLBHvYU2z4HrQHfOY1Hq7Z3EZprwsEXRRbOdkPny4a2xvxlvqIypJSw
	5ju4SjJ+io+5PPy+7x0BPvz6TdnxjDaMYeLXXVsJBsniRI2eLrScH0uSShKqxKl6iSfP2P
	8B39xwM51fcuNG4Mro0zZdHIdLBJ+N8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a1HUSyQO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761414854; a=rsa-sha256;
	cv=none;
	b=108dtp8CKH/vC+fdfPEfrQjh3KDSiclas43ZoOdXorLUR6QZHxryNhWkQIDtnPFt29YiPl
	iYjFwV7QnK73ebVNtFEqFwK4GYb2TI856FTfgJ4w2RTcEYglM6VS8Cl8oRmm5pAnbpJtf1
	rwfJfgCNj8SfQ9LDUjEk95WbYEZEkUI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761414853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dCnsJxwgqeFs7PKSg+Ud/3vJjVEQ1NvMAtuR/PgdkQ=;
	b=a1HUSyQO3OeEXPML4yQrxyZWqSEO1LoJqHzZ1SFDWzzW0DeJwHgzpqVEEc8ze1YvPMz5s2
	9hby4VJeQbzTaaB3tCtDYTc/iECcyOEsZGeqLRV55O3onaskzEjy+U+RRDLOocWyDl8pgh
	LIpxtI3B1SYL18yv6g+bInsR2xsj6BU=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-UXDyqev6M1S9FgEUYAQafA-1; Sat, 25 Oct 2025 13:54:11 -0400
X-MC-Unique: UXDyqev6M1S9FgEUYAQafA-1
X-Mimecast-MFC-AGG-ID: UXDyqev6M1S9FgEUYAQafA_1761414851
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5569ecd7afbso6596081e0c.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761414851; x=1762019651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/dCnsJxwgqeFs7PKSg+Ud/3vJjVEQ1NvMAtuR/PgdkQ=;
        b=tu5rFLLLBDrH/wj1+aS82/VNqmjjMyfxwZM7RciNkYqBJqx0+Sgf61lSyqLEC9ziZB
         VY0W3eCmNINFh2yDPxixd04PRkpgL+LDxTnTDPHztCpCpPJvZw7uUN0Q+v2Z+FPUi1/8
         df7YdH8rXiNb94OQOruxfW8rho9k7ZRU64NW7s10aolFhJNLbAoLPZo/lJqqzlulBWl1
         7qkH+ZEmEidMjCYPrJiKaqd/qEIPOUt9PD3PuVSXYjz1qtbW5rBuHo4qnT9L+/umChqE
         TCO5BiGpQfHsQ1OZHJYceMaSW9IxZiPng6gR+Bq+0uYu7jkvOP5m1HahjzpO7gwLs3HV
         VzTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbYaBrcz8d5wKAQ1f5/LKSakKmaom98Eih9dxtnWECr1tjWS3xENkguzM1Y+JfnIt2E7cqpUiVvQ==@kvack.org
X-Gm-Message-State: AOJu0YwKYQOWBmZRgl/uBIphbFOgxj3C/Zm3nru26QvpalwBJeyO20Su
	l76vQM0MLm7AvFyEpEQVoGo1Es0jdkmB5mBlJdAXHhRo/heZF5siLVm1+Z4Mx4AXPcHD3xSBfux
	SkScdKDI0dBkfslCYwktKmVIxemPd1tia03fGFJus5iNoAEIhjUDChIPfSdLpcO5OW3VDnSa8ch
	X4oxuJONYDZkT7EwOkQMuwDYYbouI=
X-Gm-Gg: ASbGnctcUIZtuqp+rh4L2dViaTZ/CC6VfRHYnWAurDL0HZst3wbL4y/Uz7oSLFL4L/w
	6+yTrGmton6VSELcjDOAhktSOCVmbgNBWhxEfBBjdyqUxr0X7qbTZ1ojw6o3u7+7pxieL4byR/R
	huHAcRtKtJiwtXesWo8E39oIDob7wzd5A0F68d/1dNR2eZIxnHiSGLo759/IXik9MhSSmMB1g=
X-Received: by 2002:a05:6122:3707:b0:537:3e57:6bdc with SMTP id 71dfb90a1353d-557cf0ca71amr1998856e0c.12.1761414851367;
        Sat, 25 Oct 2025 10:54:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgJOnM4bluQ6E9wHerRSTuFkaWRsBJjcnsXXzTai3J0SUYVYp4MA0v1jkm9r0t070IOxhPmLZo8Pqr0ynFtfU=
X-Received: by 2002:a05:6122:3707:b0:537:3e57:6bdc with SMTP id
 71dfb90a1353d-557cf0ca71amr1998840e0c.12.1761414851050; Sat, 25 Oct 2025
 10:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251024084259.2359693-1-amarkuze@redhat.com> <20251024135301.0ed4b57d@gandalf.local.home>
 <CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com> <20251025105944.1a04e518@batman.local.home>
In-Reply-To: <20251025105944.1a04e518@batman.local.home>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sat, 25 Oct 2025 20:54:00 +0300
X-Gm-Features: AWmQ_bn2KbQ7u7-I7QWQqLSntYdpaNFjyE6UUX-03Ig8JKgRbXdxkCbCcGhJeXw
Message-ID: <CAO8a2SgZ8gZ0VdtBAeW8wLMDxa+Eq42ppr-99tUpiu3Tpwqz5w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph consumer
To: Steven Rostedt <rostedt@goodmis.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, 
	idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com, kees@kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, rppt@kernel.org, 
	peterz@infradead.org, surenb@google.com, vschneid@redhat.com, 
	vincent.guittot@linaro.org, vbabka@suse.cz, xiubli@redhat.com, 
	Slava.Dubeyko@ibm.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YukfsfHdUYxuok1VnRldC2rt8bK2wRq37afvVHtPOF4_1761414851
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 21016180002
X-Rspamd-Server: rspam03
X-Stat-Signature: admwrmbfuw6hgwiis1x7ji6om7xf3ybn
X-HE-Tag: 1761414853-216123
X-HE-Meta: U2FsdGVkX1+OuxYkPdbkP1vdjNyyEzSPEq29kX5wPs+iezHuh/n7r2gPaMsJclqqdLXw7n4Bh0jT+03xK546rIK5wRM26jfVJg4KfW1B/2lUQlzumzekvPna2X08pOXJKkMmsPlkNViQMOMtoltIePj7I8QRA8Pfk2Of93RmzUMN6S7aQO9v+Kidtr5rkbXRY7wO+cPMIvabnJNBzABpzHRf7yomTt1r3+TUFFNrIfwR5nwxt186E9gN7TIr3OiskIuxQPwp0Dn1ndexsdZI5sNm2miwDCgsHWOUueI5Yo3kU7thK8PrClX9YnUG+CUMzrknAQn27yGLbnCkAVfiywNPYD0Fc8m+FBL6jY9U7NaAJIqRm4PITpGRu7763YZ5D7KGbVne8IW9AFKsT0Ke152rfwagU0oKgj5wT21uswFWaHg/GIJcsFyx2tUHvUwf5HFENecOReKMw6Chm3XRFZZIJvuy46/BQ0Q0vxFrIPuKhKOwa1Po0X0vU15JyNSoHZW9LGfPUXa04AUG6BKFRbbS1k/ew/xcCTv37yG3LLnzDvNdbsogjD0TXiGoThpo5Wajk6XrEvhQnYthmSLpSg27Y5iBEvFsoWoHrXpJ8ozNB6CNkq5h2sjCoS35/oJpCsILibCMM/1gWbrZ7gp+XpRABet/4arJeuEgHWyv3fcvJ9AlU2+yqp+EuVUlMCkCwuBW+kAuYsgkR3ehVOFme2BS12tXHQHNfqaeeKfFW5WELJqV+ay3R1kYw5WHj2f7Nr+VfQVeR0DY97qkndTV7IbQ1YhcoQ4w5nVhLTaKNjApRnRtV1LCXBKrzdizCw4l6VyZY2QILx4Fp0F/zRk2gF5//y5lwf2Tom2bTtyO8b3E78n/cHFueZ7Ht4Fmmuid2xfKAI+BaPijYEF67LXqIlMMl+5ZdlGlvxHuQ+CsW2GG4wO94MU6y3OlBkYpi5ifH79PrgJhdRVCberxwwE
 sHok9ENy
 n3Wkny8HtOfVK/omBDSrgtupsWJzG/fs7WAf4Z3kc+GTJc9O3rKiVJrQkW70dOvztAxCt24qD7VL5NNJ4qjz+BGx0unt0tDiIc/NXVWuIRgQK5DDUwoAI1wLLVLpXD+U1KnmZb8JD/RLdj8pcVRBKt1RKVkKMtw+PIhW2BKsjctecpyHG6m2IFgaG/KYgrViQrl4Pxzf7+5xjmN9HPan1i9dmeJlHVBHSqruOUx0455o6DIW3QYjhQj3bmVyaOtHIcjqu00VmBxiucdiM52aQbLFf0q/pxMvfd9he+Ba86gkTWe7htmGBnnHi9mLf7liDtdTJL4SHcrCulbk/2uW1v56K1nD3ycEoBVZNly1woBxpcLUd2Gz00rC8EF+lOpDICH0LAtqx73JyglLMmbxFk+I+WPj31ztlQxZQHffLQDCnDhu9OX8jvR8e5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please correct me if I am wrong, I was not aware that ftrace is used
by any kernel component as the default unstructured logger.
This is the point of BLog, having a low impact unstructured logger,
it's not always possible or easy to provide a debug kernel where
ftarce is both enabled and used for dumping logs.
Having an always-on binary logger facilitates better debuggability.
When anything happens, a client with BLog has the option to send a
large log file with their report.
An additional benefit is that each logging buffer is attached to the
associated tasks and the whole module has its own separate cyclical
log buffer.

On Sat, Oct 25, 2025 at 5:59=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Sat, 25 Oct 2025 13:50:39 +0300
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > First of all, Ftrace is for debugging and development; you won't see
> > components or kernel modules run in production with ftrace enabled.
> > The main motivation is to have verbose logging that is usable for
> > production systems.
>
> That is totally untrue. Several production environments use ftrace. We
> have it enabled and used in Chromebooks and in Android. Google servers
> also have it enabled.
>
>
> > The second improvement is that the logs have a struct task hook which
> > facilitates better logging association between the kernel log and the
> > user process.
> > It's especially handy when debugging FS systems.
>
> So this is for use with debugging too?
>
> >
> > Specifically we had several bugs reported from the field that we could
> > not make progress on without additional logs.
>
> This still doesn't answer my question about not using ftrace. Heck,
> when I worked for Red Hat, we used ftrace to debug production
> environments. Did that change?
>
> -- Steve
>


