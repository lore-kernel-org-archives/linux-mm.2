Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE40BC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4E36B00A6; Mon,  6 Jul 2026 05:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54F16B00AA; Mon,  6 Jul 2026 05:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46236B00AC; Mon,  6 Jul 2026 05:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9466B00A6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:35:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 266131A0170
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:35:42 +0000 (UTC)
X-FDA: 84957844524.12.62074F7
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 604E92000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:35:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7MLbwfY;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of rollokb@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=rollokb@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783330540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5l9gKFk/jvGuhbt+kDHMGw11EJgDNk5h3/iJVyYJ4P4=;
	b=1efRI8BTr8URbeQfGHQcjZJBHGEkogkO9uXmQ3aV77PjGAGLsan5oilg3qQf811QEpac7T
	jWG6oZulj83evgAgEO9ob0TvvC1iqW3JhuWcjgXiJK0wkSezmPFlihOkgF9lDRvAnJ2I3l
	kbY+LBF6UP2YKtQaELP4+p2/B9GUlgk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7MLbwfY;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of rollokb@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=rollokb@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783330540;
	b=A13OdJ22ZPj6Kp9Fuk7x7+x5HEyuUeYuuM9sw0ycdtWmpKiX7BrDByBsPxPAC43KgqV4hV
	WgD11JhlaXOaXWZs84F7cpUDCqz1UF2iwriSgfBguQkjvZgV6/4aAE9xwf0ktIQAGx2HFZ
	uo8dzCw9cqkWMk/1SccbqODI9pe8AB4=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92eafc94c9cso53836885a.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 02:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783330539; cv=none;
        d=google.com; s=arc-20260327;
        b=e79/WGmVfeUmKwJTF418Ahv7YplSa2emgsQJ14G3JK8vo1PLNi0tKH7vLXFm0ioJQ1
         RS0mksVvuM1nfGmTcpQDujaGdUyOgZjWsIEesBcKUnIaOo7kJPqk+Zntb2QBF/+Zs2D6
         oRMh99uihdwvirPImkYO5yNC4ywrD25FJr7qR56rBAXbeqpYt3pd694PLJiHY6SmthEW
         vSXjo1Kv3YWV3ryuQc1CQmFNeiIphzzHi9br++7FWsA+xNTfraUfkBC6lBf6T41FP2mg
         ygsut5WuGvUtZPC586Dtfod1DfWupbm0osSUwUbFhVjOOXEjk+NLdikuZRnWTVWt95D7
         nJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=5l9gKFk/jvGuhbt+kDHMGw11EJgDNk5h3/iJVyYJ4P4=;
        fh=fn+w96VkXycgVaXKEqpXYH0Gw/dhHJcRpYdWUeqWTa4=;
        b=iGxcbflJNcfKsx8S/XKYbD/Ex2FEqBifng8Zkmr/TVKMaLIxOcevVo4lMya4b3cfTO
         Z0d96WswXZm//9rvbBK/zpufz/rRNxLI+ajkaHU1V/o5vdhF4rSBbukIrvKZyxj0eqal
         8SX0Zq9SGIZlYm/g8eh6pocH9VqaS1mLUD8LTV4dtXJJITLtS2wvegF1FWrpnL8wqi6r
         ADv2SwvY0irsc3176nhE2E3/CxEbmvZ8OsYiKlMoE2F3fPgG767nyG9/Gb0vz2tKXwAd
         l3LdEdXA7Cnhfwjms8SwHO7CKjFepNLvdvL0gAMJfO08n8KeNHvaAc70lVSVRdJlqRmf
         +CXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783330539; x=1783935339; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5l9gKFk/jvGuhbt+kDHMGw11EJgDNk5h3/iJVyYJ4P4=;
        b=h7MLbwfYz9f8o7ZMhQbEzSrW1ZTzPZdQGVSEeu+lVPB1Ha4GtLP+U6FKK/9gPAb/ff
         b+wVqnW5quu4zYNoebr5qR9BgF/SemZmn2neTxBkc6+5xehydQKmxtHJll8HLOEafFrr
         XAc1utjNHYy2dZ/W24GL2TDnRGnUCf+HY6g82sFArNCpHFAEfWooVg4aEWn9JCgEgFSJ
         QPx2vRv+pCI01slwRX/uRwIJPVn3QS3HrOQXRygxCDZkFxpQDD/SEQWtU/Wc2658Ox8u
         I2c39vz/lVf8pnRMBA5LHnwpEwYNm4ZFMzVz54Ayu4P+jeokrDi4nLuu3GJSO5NJF5l5
         zIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783330539; x=1783935339;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5l9gKFk/jvGuhbt+kDHMGw11EJgDNk5h3/iJVyYJ4P4=;
        b=lyWG9lsBoszss421ne9+JtRs3y+S0YjqcVdqXWbusS8SGtQ6M+PIefUFh0pGebghh+
         gj10RQzBFa06sXcGkvN1YL+Dxaj+BJC2MVg4WalxjnsgvcPTQYeLZc8TyszZ338jIxvN
         GUShDcLQxpyJOitJIS+bn0JYNUY7w0TCmdJYp586rK1Y1yekQXgA/mHKwqXeRMqiZak7
         KenC3TFL/zlwZMomt6PxP9lXD+a1X16isjiq+XSzdtlBpcZCjilaMV8CckzjAgZsEZfk
         i+RXdGkwZwSuNtuB4rCX0bCFW60j5491JuYpKW5Vn6Ii6TlULUrhe361V31CDz6zpZId
         fpzg==
X-Gm-Message-State: AOJu0Yx1TWW3w+rXix0po5EUPRKLp0R3oEuW4tE4yV8TgcBwKEe8har0
	J08j22K+6bSYCMSAFtSvoC1y7/A2e/SXQatHzWhpSnc1Yag1Hm7vG6ebcpYpXwNUw0Xsngcu7lC
	ExBup+5fCFoDnzy6Ps3/GDfYYaF7BzPFvWbSOJbE=
X-Gm-Gg: AfdE7clFVWzL8fYLnIIIhJNdeQTOG1t8JcRe37w/qkPfXhRD8ZM8bF3cQNr2ZCkTSv8
	nLezX8mtKrAazkK6EgJRBHRo2/Kt3TLtrv8bt6uTQQmG8SA4/L9hBXdGNyO7tUlPF3y03LKdalC
	v6RX14lTusHCaPNzPhL+WNWxhome1owF1zBQOXZV6CRmlBRlPAXlPG//fLOMJtEcUleN9PjuOOp
	bQ6LDH9/1sRUyiE2Qn/ecGNvNMoIsWV4h5A8wjJYZjHYllRDrF+hnWLRu988O1F/CyLdq9T7DvP
	678MB+S1paTltH4c3PMJN4BDRDXU
X-Received: by 2002:a05:620a:470b:b0:92e:76cd:9594 with SMTP id
 af79cd13be357-92e9a3a30b3mr1252593185a.19.1783330539525; Mon, 06 Jul 2026
 02:35:39 -0700 (PDT)
MIME-Version: 1.0
From: R KB <rollokb@gmail.com>
Date: Mon, 6 Jul 2026 10:35:28 +0100
X-Gm-Features: AVVi8Cdq93o-zLZxex68UPGezKmDnpjldz3YEr3c-0EsuPE1PTyFzuk7gI-K4E8
Message-ID: <CAOkhyB7RZ1Ph7+EdYpWfsJQVu7ZF26DRR3B0wZ57eq4BY_en2A@mail.gmail.com>
Subject: Is there an existing primitive for mapping a file into another
 process's address space?
To: linux-mm@kvack.org, Bengamble7@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 604E92000F
X-Stat-Signature: 8jpebqyxgdab7uyuwpyinp7ut33p5wzm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783330540-622216
X-HE-Meta: U2FsdGVkX18svolnQ/9Bf99M9/8NaWUiyItEcAbxYOpHXWjH+ATVnrYaKdx7ZOXQZHdopprs21KYkJBj9EnMJ5u0Ugcmvq1upyyfh92jwZHvcw4FVv3pYaBkpvPHNHy/aRu1xbQWdmoWRdGY56/Zoz5XCRD5MMHz93o1jDVP+1pM2MIwH2WJDllyHKBU8brraAfCTFDRFsRfIgk2GwYCMe0Hj4UvQa5Ml7oMSURnlwHMmPsAASZCau9JIYKcnDKamRNTVFntUdO4d/zk36FSlDW4iLpqX1jRsvpvukwr+Cy4MqHFSmSAeXekoFeFACNUowZteYTPqVM5hMRktZ3fohVRsiO3cvUryaGlmz8iZRM8WJJYu1J5hJhHxJq1MomQyy9IbLzfZSRL0VFdbqqJeMcvpjarmZUroA/l+POgIwy2+e0g/2iTzsxHauS2RPsM/K3ecXCZbG6PxdqXAg6DStnG6L5lcHrv1+OeEHDZ5scoZ4Pi7yEOxHSIdOkFZLf9a3PZieVJa8TNJbRBw7vhfZsKuZk/Bpd3oGs0V4pMwfTKEzXZAcaa7grn0NHBBGfNPejBU+AIj4dyrDNgVNfCXktKxhIq6++sPuj/uv3J5z0lSXwUBhIKbJMQl3JOlBqsvMovNHz/K+pCaOZFw8OQw1n14q/PipY0B7AY80QVSk+DWF6p3jzAFBkrJ0sq/raiYrSB6oxoxyOwgZmyG+L19gM290Bl+9RkAS4V/ntjMh/vx5ldsA9XxntzOiiX9tqC4wnHjIhlfXeRAoRhaovmUejZKULoomxNofVSSQYeoC7M2Ak3ezZp9C0Ltq4p8+0dCHF9dBWUk0a2I2MoPCTVEQI15h5JtktfZCy0MKQsrSG8MHPrmgN4FaJZ4UjwICxGK8XYCT0L7tsoa5BHs8a1jRhG5jFpqLdZ03ffxr5DtMcD6qezXlVMXQVMKWXZEUL56AzZrGy4JsfcksdQofM
 F1QV1e7h
 xNerYj98y9QNcMmct7nA4qHxv1c0v+l57OwLLLbZDs93elUSelincTsHy4yvHU662j2t33F7Tedxk59/R2g6mFsqZfVgtSDBIGVx+LdLZ1ELuDB31sk2h0yvzACmUAOqLR+lxStWmUfRnWS8rTmiDVTg5Q+IW30d52jM+wWkCtbTBNZ29HY0ZPWos+Vy28fBxNTD5PmEVdIHhGktc+y2MA9dEkm5Php0hKfF8r9tD/VNLgKPreYG/sw7pQgN/U32PNyyzsvXU7j0qGXJPp4HwockyrgzDYOmUSCZBgne0DHfgLu2kvqFnRarrR/3HYqwVTBPb9u6t4Ip+Nti2GwzYD7XL+wVLJL42NxrXYtxCJJsRvgFWiAPA4nCG+xABxMeDCUwfNHqmYu+1ADrj07B/40WNFYcKS7XqencFvlpNT2nbtqvhc66OL2zPysaVmjipPOk8RMKuFn+lkRAfvGaKPHZbB8sO0PNJC+P4BKryDDsFSWfgZtjp+rzOrN8St6c8tDFj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear kernel developers,

First time emailing, so my apologies if this is landing in the wrong place.

What I'm trying to do: I'm trying to create a process that brokers
mmaps in different modes allowing for exclusive mutable access. I can
do this in macOS and Windows with the kernel APIs that treat virtual
memory regions userspace addressable objects, but I can't figure if
there is a set of more UNIX like primitives on Linux that allow me to
do the same thing.

Basically this is the flow:

  1. Client requests to read a file from a service
  2. The service checks the entitlements
  3. The client receives a virtual memory mapping that it can read or
write to depending on permissions

The client can't alias the virtual memory mapping (as in remap it),
can't share the mapping with other processes (either by forking or
sending the mappable object).

Everything I can find in Linux doesn't quite do all three things:
map-once, no further sharing, and no copying of data.

  - Sending a FD. A client gets an FD but this can be dup'd and sent
again SCM_RIGHTs and the FD can be mmap'd multiple times.
  - userfaultfd: can't map files into existing mappings, would require copi=
es.
  - memfd: closest analogue, but requires data to be copied into memfd
initially - can't map a file into an memfd.
  - fork + pre-map + exec: works, but only when the broker is the
client's parent, so no dynamic serving.

Both XNU and Windows do this directly, and the same way: the broker
maps the object into the target's address space, so the client never
holds a handle to forward.

  - XNU: mach_vm_map(target_task, ..., memory_object, ...,
VM_INHERIT_NONE). The broker holds a send right to the client's task
port and maps straight into the client. The client gets the mapping in
its vm_map and no port to the object, and a vm_map entry isn't
passable. VM_INHERIT_NONE handles fork.

  - Windows: MapViewOfFile3(section, process, ...) maps the section
straight into the target process. The client gets the view and holds
no section handle =E2=80=94 nothing to remap or pass on

What both have and Linux doesn't is a cross-address-space map: install
a mapping into another process, addressed by a handle to that process.
process_vm_readv/writev copy, they don't map, and there's no mmap that
targets another pid. That's what forces the fd into the client.

Is there a way Linux can do this with some incantation of it's API's?

I've written a small 100 line kernel module that allows me to install
the mapping without client processes having an fd.  This works by way
of a protocol where the server puts a nonce mapped to the real fd in a
/dev/broker device, with the client then mmap's using the nonce and
the /dev/broker device just proxies to mmap.  I'm not a kernel dev and
it's the first module I've written, so I don't want to drag a design
question down into first-pass kernel code I'm not qualified to write,
but I can send it if it helps to see the shape?

I feel like something like this must already exist and I'm just being
an idiot if I can write a tiny misc device that can emulate it :)

Thanks,
Rollo

