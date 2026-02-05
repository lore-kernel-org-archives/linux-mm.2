Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77351EC1EAF
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCA816B0088; Thu,  5 Feb 2026 07:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75436B0093; Thu,  5 Feb 2026 07:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60836B0096; Thu,  5 Feb 2026 07:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 901E36B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:46:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BC5F139C79
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:46:39 +0000 (UTC)
X-FDA: 84410376918.02.2C9CE42
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F2E51C0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:46:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gYUdZK4r;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770295597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJxzf/DAKGtqPSrm9/DmJuhRV1AeX728/3K6M5fegUM=;
	b=Uc0dTLRSmPwX9iWarNG8gc4CpxdYqynZ0Tuoyrkx9QgVnm0rSIEpyYz5DR96YWilxJ6vmw
	3RZmX3IenayX3zC2kDb6Xyp+fVjNkZFK/51E+6RiYJRgHLWbGFOZ+V/EefAKmvNJ30RGZU
	I3yCbWxDyyHyHt+A+BCNirbv5F1aZCM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gYUdZK4r;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770295597; a=rsa-sha256;
	cv=pass;
	b=4q8qnkU5MAqFRhadqoPUKto3oH7WslFmQ851v3tVIfhq8ytOS8Tm671VbZ382aKZlrr2md
	PvCcKkJw17kUEx6B7MpXZW3ZDbL5iIdpwuQH1K9RpxwRDDgr1ZxIMQG6NghUemqO1DM8Vy
	hZ9Iy2ntOhK9BlRWKtmNcFUVyjVaN1A=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38320cd563aso10055611fa.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:46:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770295595; cv=none;
        d=google.com; s=arc-20240605;
        b=cvy5uEnR5bHVkxpnF2XpN6c+MC6FNtuefeBXVP7/CCfCQ169fjOEIQvARYN7QynHvC
         kO96J+c6IKPX2WB/sC663fTe5vuZ1xj5CPg4/4OIYGXi3h0sgadsAzb+MwPd6mGvMRyJ
         t+MrqBLJODw4iUgHpYHNqQuKicG49coackSAC+rbQiEKRja0NKC54WFHo69KlU3BujmJ
         v5qTj64NNr6U7YwoJTWw1ywtacJIb7ZuTxLIGANyzJl8hFXeaXJQetq8KxSD9/D2tTWK
         MeP6uKEvEiCqqB1uGcGivShC3syNPak6sRK1PgQSCHhDibwc6ywgCC30FOd6LrjjB+iy
         r8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PJxzf/DAKGtqPSrm9/DmJuhRV1AeX728/3K6M5fegUM=;
        fh=ZQe1qyefdrnXaA8U5dFotXo6s7dEBF58Oj5jNukPaFI=;
        b=SdqELn9xtVKxS0L0Ah6ZacTRtwKfY9MopMC9G0aKkaTwDuYMKmq92rpja/KOcovwll
         wn7+YUDVtQiGBGJ1SQ1v2tsO1FrI3j2TxTM1Me7jgt/eucXENMwBWx88Iyv0oOjve+FB
         U8DN25mvn6/uVYsQeQoSa8Xx4I+slXWfPF+2Os1hjbykBA9eo+7b+WV9/6+Ke5x/nA01
         2TPfgQ3naipTxOIQH4iLI1KBpZ50C7AwavJ8DV0Lls2KlBkxyolipBn9L3XbYC4fHwYl
         jwJlkW05TlWq28jNvVlTr30yv0X2F/55GGKF6uahsckhSB7zBKKoCK2gHweQwJ3LbdRh
         JuiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770295595; x=1770900395; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PJxzf/DAKGtqPSrm9/DmJuhRV1AeX728/3K6M5fegUM=;
        b=gYUdZK4rskEGiOFBJCure4h+la4aaqnrLzckU2a0KW8/hAfjCvLptUzzktDr6z13gk
         KcdHXTmOJ7Y6jh4a+ecdIiB4j9FbAW/bTvXr84bKOo+o8brIUXBksOrhLwfftfgN6zXv
         vDq4b9/l0svxlkUv95S4BtF5qquoMtbjyV+trzEA4R8h44FUNlYya6eaAXnM3yUhanqe
         qWe7RF6K53dakyb8dQDKkx7AiEo/gCtkVMT9je/V3RW9tcAWRYhlXqb1yZMIcbZCUbAT
         CibDQ4RtuP5PIE1jopUJjPsIBKnmpDyqXTiO/dvV+QU4nnH88aJSFH7B/SJSO3TtTKbr
         li6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770295595; x=1770900395;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJxzf/DAKGtqPSrm9/DmJuhRV1AeX728/3K6M5fegUM=;
        b=nHzdlFPtNqm77Z/Kxw7icgy32O23gDGtUeqjTcLpGPzjE1cMOyX9LkYl7PwV1WURE1
         1mf6kw/mbZ97wNp6oSBiMUAqDt1q1tBus3japk1hbl4BUnGooXFdlcw5DQxCaGs2JYtp
         sV5J6o5pV5k7EhGVvg9SStBvNHd6ZjjKOEnKbAKiLNI50L8lsvzDCDyyM1wFXAZ4IuYw
         WnRatitt+NaRPDOkKSOwW30SeW62AnZpxFWJScpFIqFR7f1FkH6GrUBrnKfnyowPjEh9
         euHbzff8X1c/XP0UKPZDA+g+OSSunGG4Zu/JDxNQhelKh8jaslEPc8X9gjIZ76tr2zXX
         a6iQ==
X-Gm-Message-State: AOJu0YzMWkK8n4xdyQGk1y8Ml1MxBggP7zyw3DBOtX1fNYkhFn9U3uop
	CwCkcEh9m/k7FL7UpnpgsnTU+BfFvgYFqQ52s7r4uKHBv13pgFd2zeYFKcoezuiaLo3l8ho06xj
	JheL1K07umOtYtr7W01q1q3vFCNMqcRU=
X-Gm-Gg: AZuq6aJvcjydJZGyRmFArJObUwBPMgXTto1t+zsFYFg8PVafB18W/nBfq5g17gIgheh
	4ITorXN8UfmHw6KYuOyJSQd4sp+KppOVwOTzp3UCM5mMIDUA6V4iXfijVBGPiRoSXeGXcZ8xBeg
	B2SDiZ9wIerwyIvJCJAWtyD0fkHuWy93RRiDFl20v7HWKeezbepUPup7cOTXfH3CfAoI1J+CmQr
	wMPJsp0Z3obXGL063QlrEHfrmTcANUkEWyeS8OzcyfCCgL6U6/YJRHruW4U56ECNse3bp/BhUK/
	l3xP6eCuQbkaYvsWZ8nqiqyjd4T01r7tLrZu6kQEsZc4FGu9qaAVejCXuSEWbsREq535c04AeZc
	9Ljcie1PYWnzq
X-Received: by 2002:a05:6512:4001:b0:59d:e03d:1cf9 with SMTP id
 2adb3069b0e04-59e38c35679mr2239817e87.38.1770295594902; Thu, 05 Feb 2026
 04:46:34 -0800 (PST)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org> <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com> <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
In-Reply-To: <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Thu, 5 Feb 2026 13:46:23 +0100
X-Gm-Features: AZwV_QgbjbYRFk2XSFb3xiYvCW8oZG7O1T35pSwFfqEZ6Pf5SqEiNCpVdIaCHyY
Message-ID: <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
Content-Type: multipart/alternative; boundary="00000000000014eb20064a1310da"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F2E51C0008
X-Stat-Signature: pyx355bgp74jhfsy6p4ppj49p5kzdn5n
X-Rspam-User: 
X-HE-Tag: 1770295596-888199
X-HE-Meta: U2FsdGVkX1+8TsxKwzSzn6gfAOaVkKEj8+nKHqKX483P8OAJgddfAKHpKureCUGs+Ru+hM8NqGMgcT/0krmIukSF1uhrdNPospJ6dByZVPIOMNfiozUbsGtDXU+Rw06Zl5wg3LEWJVySuwP99Qtj+7hwF6cZn/Q40DViax9HfckC9Wa4rHg/9i0lT8/UqeIDT0nKlZXQ72wi6B4gvDENRaNujZEepm1jBcnitXUSJBZEdfl079aFxu3dF1FumSy3wcWXYG5QbIDSkbL3cQRE9hmqV+vu6VVpoqNDtHqD1u/TMOrCD4e0bk3KYwbRk4ca5TsdofmDcZaeQtqfDa5CzaUds4FesOqCk7SMns4g6HNg8ahM0u1liTf2bcUjXBYYPXVH5eyCcO5UOThJ7AMyISF56ZlqHvkDOMgrDXu/TT+tdfq2/OOftmYRCbU3UuJsWELAG10tiKjEU1y4NI4NBKmNBhlMxHEN2KNaru3cxoe0Z5cqWqNZwktCJ3y/6wJcpm78yfXeEqklL8TNiSEhSyqDLXiMjYuKAJnEIwkBu2olXT7oyAa7UR34kXsTHsHxkFxe2BojTy1hA+i8zfZt6X83krXWwCO2uZxzdG4zQISd7/QGHZeR8GJJoB4aUvIl8ysZ1kORUCOEXNioaf9JyZhGJHtWwNLnT8KDb+u6vIVrQB+CCgSgnkCeKTP+Gf6tNTz4ezF1AjYUihK8qkClXp+dqBi6kW4NtG3EJuabWeUDd96lqSHhlHzlssA6QK/oW6zX56ZqrjqL+ldqraYFUoO3G5EBX6lkF7y62tPFBLYlIKR+qnWrNT/ieT2SSVerbGdlQrL6W4qddk75cvspJd55SzDp5Eqh0kjiQVV7uaZGDBQnig2S4ZFPIbLBPo/QXAzZUfIy+75iQEK3vJOzKbqcXiXW3Ii87swohCOjEIYXL6YccyozTMm6YdDQk8879IuRGIQa5F3ryUs56Zf
 nl4LxHa5
 h0kJBSvUo/6OnZWvKjwuxOH+aHA9fu/kgP9vDe9VPmyo5EVRVeIwchfR+m2ywUSuYe+USJh3Y+98mGJdsm7n8FAzIb3+2W+P7ITTxm5KkduNST/OzU+/8iOhkC2uVbtA/nl5zchXEZ78BlKMfyThh6ZIWUwV2SYTgu+5XuxMBa9a7HJuibhhTq0YOrmbVfZtIabLPYRu9N7fTevWfHCUrYdtwW6juajanoSPbEFH0TXeoEHAQe4rfoABsoKkYMNNrQBqFkkzmOOY0YApA0yrELLOK20GYa+6hqESYzAO028sJP1Irv/94Ugakh8914aaqiN9/DFLKRPJxKUrhHPftbpVr0OrsyeoputW8nRO9yhr0FLsgk85GlIldXvSG37dnwGqC8Z1FMOW0PbBfVPYjzagursfJIs6xvegyXThOYnI7519xZijrJwWMmV2CZ6OKxoaKvstY2W3AjZUXUx9SIK/2+XBN3Ed6Q1MtKX5RyBbEAOwkjPVpSRfU7Nix6fAW7KcNUU3+upEBeaQ2dIrzrY9TOOLTkfE2MpDudZmXGWLjGshLGOJBc5KPfk15pX+1rkW5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000014eb20064a1310da
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hehe, i cant. I dont have any CPU only servers :)


Should 2MB and 1GB one act the same ?


--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


czw., 5 lut 2026 o 13:44 David Hildenbrand (Arm) <david@kernel.org>
napisa=C5=82(a):

> On 2/4/26 23:50, Tytus Rogalewski wrote:
> > Just had another crash and it is still happening in 6.18.8 . Here is
> > claude output this time as i am lazy :)
>
> I'm lazy and ignore AI slop. :)
>
> [...]
>
> >
> >    Feb 04 21:42:16 pve12 kernel: BUG: unable to handle page fault for
> > address: ff164aee00000000
> >    Feb 04 21:42:16 pve12 kernel: #PF: supervisor read access in kernel
> mode
> >    Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - not-present
> page
> >    Feb 04 21:42:16 pve12 kernel: PGD 4602067 P4D 0
> >    Feb 04 21:42:16 pve12 kernel: Oops: Oops: 0000 [#1] SMP NOPTI
> >    Feb 04 21:42:16 pve12 kernel: CPU: 125 UID: 0 PID: 783442 Comm: qm
> > Not tainted 6.18.8-pbk #1 PREEMPT(voluntary)
> >    Feb 04 21:42:16 pve12 kernel: Hardware name:  TURIN2D24G-2L+/500W/
> > TURIN2D24G-2L+/500W, BIOS 10.12 11/14/2024
> >    Feb 04 21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x6ff/0xbb0
> >    Feb 04 21:42:16 pve12 kernel: Code: 08 49 39 dd 0f 84 8c 01 00 00 49
> > 89 de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff
> > 48 39 f0 49 0f 43 dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b
> > 45 c0 41 c7 47 20
> >    Feb 04 21:42:16 pve12 kernel: RSP: 0018:ff643a4c403439a8 EFLAGS:
> 00010287
> >    Feb 04 21:42:16 pve12 kernel: RAX: 000071afc01fffff RBX:
> > 000071afc0200000 RCX: 0000000000000000
> >    Feb 04 21:42:16 pve12 kernel: RDX: 0000000000000000 RSI:
> > 000071afffffffff RDI: 80002fd0000002b7
> >    Feb 04 21:42:16 pve12 kernel: RBP: ff643a4c40343a88 R08:
> > 0000000000000080 R09: 0000000000000000
> >    Feb 04 21:42:16 pve12 kernel: R10: ffffffffb84588c0 R11:
> > 0000000000000000 R12: ff164aee00000000
> >    Feb 04 21:42:16 pve12 kernel: R13: 000071b000000000 R14:
> > 000071afc0000000 R15: ff643a4c40343b08
> >    Feb 04 21:42:16 pve12 kernel: FS:  0000767454f93b80(0000)
> > GS:ff161c21bdefe000(0000) knlGS:0000000000000000
> >    Feb 04 21:42:16 pve12 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> >    Feb 04 21:42:16 pve12 kernel: CR2: ff164aee00000000 CR3:
> > 00000080dff18005 CR4: 0000000000f71ef0
> >    Feb 04 21:42:16 pve12 kernel: PKRU: 55555554
> >    Feb 04 21:42:16 pve12 kernel: Call Trace:
> >    Feb 04 21:42:16 pve12 kernel:  <TASK>
> >    Feb 04 21:42:16 pve12 kernel:  __walk_page_range+0x8e/0x220
> >    Feb 04 21:42:16 pve12 kernel:  walk_page_vma+0x92/0xe0
> >    Feb 04 21:42:16 pve12 kernel:  smap_gather_stats.part.0+0x8c/0xd0
> >    Feb 04 21:42:16 pve12 kernel:  show_smaps_rollup+0x258/0x420
> >    Feb 04 21:42:16 pve12 kernel:  seq_read_iter+0x137/0x4c0
> >    Feb 04 21:42:16 pve12 kernel:  seq_read+0xf5/0x140
> >    Feb 04 21:42:16 pve12 kernel:  vfs_read+0xbb/0x350
> >    Feb 04 21:42:16 pve12 kernel:  ksys_read+0x69/0xf0
> >    Feb 04 21:42:16 pve12 kernel:  __x64_sys_read+0x19/0x30
> >    Feb 04 21:42:16 pve12 kernel:  x64_sys_call+0x2180/0x25a0
> >    Feb 04 21:42:16 pve12 kernel:  do_syscall_64+0x80/0xce0
> >    Feb 04 21:42:16 pve12 kernel:
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >    Feb 04 21:42:16 pve12 kernel:  </TASK>
> >    Feb 04 21:42:16 pve12 kernel: Modules linked in: sctp ip6_udp_tunnel
>
>
> Yeah, same thing again.
>
> Can you retry without vfio passthrough to see whether it's triggered by
> that?
>
> vfio recently gained support for installing huge mappings into user page
> tables. I wonder whether it is related to that.
>
> --
> Cheers,
>
> David
>

--00000000000014eb20064a1310da
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hehe, i cant. I dont have any CPU only servers :)<br>=
<br><br>Should 2MB and 1GB one act the same ?<br><br><br></div><div><div di=
r=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div=
 dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">czw., 5 lut 2026 o 13=
:44=C2=A0David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">da=
vid@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 2/4/26 23:50, Tytus Rogalewski wrote:<br>
&gt; Just had another crash and it is still happening in 6.18.8=C2=A0. Here=
 is <br>
&gt; claude output this time as i am lazy :)<br>
<br>
I&#39;m lazy and ignore AI slop. :)<br>
<br>
[...]<br>
<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: BUG: unable to handle page =
fault for <br>
&gt; address: ff164aee00000000<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: #PF: supervisor read access=
 in kernel mode<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - n=
ot-present page<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: PGD 4602067 P4D 0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: Oops: Oops: 0000 [#1] SMP N=
OPTI<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: CPU: 125 UID: 0 PID: 783442=
 Comm: qm <br>
&gt; Not tainted 6.18.8-pbk #1 PREEMPT(voluntary)<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: Hardware name: =C2=A0TURIN2=
D24G-2L+/500W/ <br>
&gt; TURIN2D24G-2L+/500W, BIOS 10.12 11/14/2024<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x=
6ff/0xbb0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: Code: 08 49 39 dd 0f 84 8c =
01 00 00 49 <br>
&gt; 89 de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 f=
f <br>
&gt; 48 39 f0 49 0f 43 dd &lt;49&gt; f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff=
 48 8b <br>
&gt; 45 c0 41 c7 47 20<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: RSP: 0018:ff643a4c403439a8 =
EFLAGS: 00010287<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: RAX: 000071afc01fffff RBX: =
<br>
&gt; 000071afc0200000 RCX: 0000000000000000<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: RDX: 0000000000000000 RSI: =
<br>
&gt; 000071afffffffff RDI: 80002fd0000002b7<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: RBP: ff643a4c40343a88 R08: =
<br>
&gt; 0000000000000080 R09: 0000000000000000<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: R10: ffffffffb84588c0 R11: =
<br>
&gt; 0000000000000000 R12: ff164aee00000000<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: R13: 000071b000000000 R14: =
<br>
&gt; 000071afc0000000 R15: ff643a4c40343b08<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: FS: =C2=A00000767454f93b80(=
0000) <br>
&gt; GS:ff161c21bdefe000(0000) knlGS:0000000000000000<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: CS: =C2=A00010 DS: 0000 ES:=
 0000 CR0: <br>
&gt; 0000000080050033<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: CR2: ff164aee00000000 CR3: =
<br>
&gt; 00000080dff18005 CR4: 0000000000f71ef0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: PKRU: 55555554<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: Call Trace:<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0&lt;TASK&gt;<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0__walk_page_range+0x8=
e/0x220<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0walk_page_vma+0x92/0x=
e0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0smap_gather_stats.par=
t.0+0x8c/0xd0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0show_smaps_rollup+0x2=
58/0x420<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0seq_read_iter+0x137/0=
x4c0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0seq_read+0xf5/0x140<b=
r>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0vfs_read+0xbb/0x350<b=
r>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0ksys_read+0x69/0xf0<b=
r>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0__x64_sys_read+0x19/0=
x30<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0x64_sys_call+0x2180/0=
x25a0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0do_syscall_64+0x80/0x=
ce0<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0entry_SYSCALL_64_afte=
r_hwframe+0x76/0x7e<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0&lt;/TASK&gt;<br>
&gt;=C2=A0 =C2=A0 Feb 04 21:42:16 pve12 kernel: Modules linked in: sctp ip6=
_udp_tunnel <br>
<br>
<br>
Yeah, same thing again.<br>
<br>
Can you retry without vfio passthrough to see whether it&#39;s triggered by=
 <br>
that?<br>
<br>
vfio recently gained support for installing huge mappings into user page <b=
r>
tables. I wonder whether it is related to that.<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--00000000000014eb20064a1310da--

