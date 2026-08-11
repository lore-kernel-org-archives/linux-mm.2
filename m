Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C113C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6AB6B0093; Tue, 11 Aug 2026 14:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4570B6B0095; Tue, 11 Aug 2026 14:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C4C6B0096; Tue, 11 Aug 2026 14:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 034C26B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:04:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78FA58017C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:04:28 +0000 (UTC)
X-FDA: 85089763416.13.04C6870
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8064B180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:04:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ahacrr4X;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of jyescas@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786471466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpNzrVyhleOpri3sjKIcTO++EVgc9m/7toza1fv0Xeo=;
	b=Nx+rEu9ipABW8SFVfEl5mVpZ9enDgjIRuyYjh0EIQ+gMjvmpWB/BUti552ZGNe5NomQxbW
	KKoXcGuBmz4HFSafEKBJKIpxduxoSbZhBGNk6Cgv9gHEcRXKQ5G0+D5dy6FX4+OLzargD0
	zS8kgHwqS7Ao3s7w3ZW/cJKccGHj3x8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ahacrr4X;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of jyescas@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786471466;
	b=N9N9cCCnaGMuxtkEnzFu630c+jj/hB2e49U0ql6Zdo+QXZFlOxGiC/JNXSGwyeiwPK3hCH
	pqkLGz9AWMm4Syz+VZv2Zapji/p1iwCmMfJWMWWzlSzUCRp3h8x45EiGPnTg7beyzEI6b2
	usEzksrL7RNS3uWAVgAU/d2c3r/2OWA=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a8173142so855e87.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786471465; cv=none;
        d=google.com; s=arc-20260327;
        b=pARetmMPV6USD01miU9uqbLDE7nsvKXQiNgFVvZY7YlJzDBRWfBVmYTqKMnprwE3xN
         ZItLoLoJNdTMfdVDbDYVBp/+Hzcl32Wbxdo6CbjCI/4lp/NvCiC2dPSBOxI44KDM0T0t
         5xn8tlC+apQbbYOfJ6rT0rIG/HnHmMXNZmUv7GhEuAMY2IhbD4YRsZ/0YrNwHYYTVs8P
         aVW+qImnr4KSkp05KG/45rKZtQ8fDfMd2WCgTS7gknHfe8Eh2ZjMhWw13IZpy94PPEc/
         lmJ06WDeXR+/0Mi+UiO6yCfz/4FOztBbPIaMGCJQ2ZCJ2FN9k1wYM7E2ZNbtGxYcmf2P
         OnTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DpNzrVyhleOpri3sjKIcTO++EVgc9m/7toza1fv0Xeo=;
        fh=yTGStPl4Kn5hIJgaof7ysGYllZgkD1ojFMPCJhETtWE=;
        b=IzOb9hZUO+4O200xxPAfrmAOq6VONIeW4XqcDH02OsSrvoQ0Nr1H7LzakVhUzgPhRZ
         Fwdivn9+rZWIQAvU0WXrky998AsoWoZmPs0w++vMljNdyt65N/6+3NUBYJ01Z5fD703c
         v4wbfg/TB4TF+KhUPsDCnnMP06c+f5kkxLSqJv5KIaxRZ46Px/z59gtPaCiZ98wzA37u
         cjpDD+fMBJetpzUIxA+5C+SB18tbVPF4DRSJU7VQru74dv2yUKs14QTUfvFJfqgG5yXl
         +YJxNgNa3YnxiXxxqdqXtHRKtDygSgatNmw2Zu/mZWrxcq1vFa/6Mv+JVeaWVaY3GyKb
         KPLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786471465; x=1787076265; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DpNzrVyhleOpri3sjKIcTO++EVgc9m/7toza1fv0Xeo=;
        b=ahacrr4X14r2fXiOOXXkp+QNYYjiMwNdf+SVrcO7rSd27HnX5wJAAr2v8M5yafVR+q
         vE0WOs6drgxkezd6P/uwVAUZttd/gn0rhoS35ujwp0FbwbT73/6Z58CWwWunJcJ8le+L
         OEWUndiM4Dd6fUPVUacCEz3fQdUXPXMx6CBAhXCmyd4rOPuPHCiMPzhEDWbk1K8gAY7V
         xbOrkX6zgCmajXWXPg83dAxdmi2Ef9fd4sTghc+bF7oZOKxSCz3RzV4tBnM6GKOTBQVX
         4qg0DWx5/J7Gda+TxEOgGR4hdpxeY3+3g3uDu8ZGI7AQd+NCP+J88C2R5vCvAxIX9GJG
         t9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786471465; x=1787076265;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DpNzrVyhleOpri3sjKIcTO++EVgc9m/7toza1fv0Xeo=;
        b=OqN+UVwaTiiN2Azt5G70+pSZlGaiPjnwM5PtV9IbYkdjqsGvbi59vVFFn8U3SMPpQ8
         S4Lt7x0PXbRoFQyCF5VotZ5RFAMSlQtVDRpHm+a7YgJsX8leEBLyxA9xXdpNwxwycXZ7
         n9Jh4LNaRacilfwK47+5O3zicgdIk1P6tk1mPBlT4z4JiAeqkRaFJwFFF+f7gK6dUyhP
         AVvDI+4Y86y5oWee30B+1XIp7Viy9vCKDvC7TipU1yYVtSdvu7fn8yoUQBG07bYYQDb0
         5UD2yqMS2zTIjOeFYtdJsF1cPEh/Y5O3JbwdNkbR9plBonrJK2XhqVKRyVi/k1oKHGOM
         b89w==
X-Forwarded-Encrypted: i=1; AHgh+RpTa7clqdiecPycFZTbYzlezPh4LWk/lS62oPbaquNx4XphwjsVaHj1ju/BzL1MsBrvJCus6MOKEg==@kvack.org
X-Gm-Message-State: AOJu0Yy/pAXklN4rihntdP9DIPdHIbb1ffTYwizg5CEo/DS++Lp2TJZz
	5HA3TpKEHMzgYExfQEC9CCcvYrRFUMxjhAy50gc17VZM7eabHPoSrfSG1LxhDhmS4wY+MwsfOG5
	KxrJBFcNYFVQW5vJtHRMvMiuvF897s9oZ2VajScBf
X-Gm-Gg: AR+sD12Yhyei0bYnWv1icphF7eox1/ClKiPIUwHtlZVhxy28QYY3Ohg+1JoImORg6Y5
	Bl91GjTO0Xdy2V3G/2y3qTXWbCgVVcFHZPkl9ptmTRvDKTmaKww+CLWOp5zXAUkmtWcK+M32kJW
	SLVmPQHjjPOX1jfm0KJXf5sSI6MukeAhsjWnI9CT/EiVSh/CaKDB335vqhMcUtMqywML2V1Hnbz
	qGGA4SuSaS8js6qtxniZLPatWRR5AeSaAenzehgv57dDpsl80Dlohl5lStovy+VloXVNQ2CkD/f
	48hfCcNLQUChezwgiWsJsLRVz+oAUntDY8Oix6EysufK1iNf68p5YJqy96FoxD6g3BGcR3MQQzO
	y8NI=
X-Received: by 2002:a05:6512:3e1f:b0:5ae:bfe1:737b with SMTP id
 2adb3069b0e04-5b44d1060ccmr17383e87.10.1786471464008; Tue, 11 Aug 2026
 11:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com> <20260805222242.13f1f24fe95cbf13292a01c3@linux-foundation.org>
In-Reply-To: <20260805222242.13f1f24fe95cbf13292a01c3@linux-foundation.org>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 11 Aug 2026 11:04:10 -0700
X-Gm-Features: AUfX_mzEu4KQUJA3igggjGhM1t6uxYHAYS-tcuI9ZWGeIMMlx4JCq48_c0D5XZQ
Message-ID: <CAJDx_rjbTrQ_O-QFG5_n6AvVH2EENwOObdHd09EgCh4=cb64Sw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8064B180008
X-Rspamd-Server: rspam07
X-Stat-Signature: 7k3yizdokbfq37brw3ry15d3m37phtnd
X-HE-Tag: 1786471466-815806
X-HE-Meta: U2FsdGVkX1+UR/lUhBpq55WtKLh+LLe2obPdGdtZgDj7CrqQRWmTGm6WnWJKkniT0o10on7UhZfXSVOujKDnBKlvqmAu5K5/29o+hBTGWLRWL+kjBZG91zDynp3zVjBDdZ1Gb0qDJLgUKUbZnhFH5H2Qoll+VCMBTPHV8cnjrY6XVMiyl1c+Y6k71fqqFmkXevQXrkUQZYnuofNQGWux0VAWOoImdj82CU3jZCz/hRFL4QQ/em4izVg7AVzp6PMWeV5buMquPgr1fcyNAwOY+aVGVgOXSRJl0etgZDRpkuielaipJSw/vjVf8kwrxZRS0y7D+KOhPQq8ufDf3UvXAl9hZ9Zn5QNYtckMQSib+E3Quy39q5Fl3ftRPfDoYmB333NSu2jyADrUKPU8tegA7K7u/g1HYJ+TmLf81A6R1MYJQ2v52YKyzSQDbJb3Z8rw5GrZPijJqRwySgFLu+5gO6oi3K/p06+DnHFK3Ab7SvLkwiKysfwrWLI5MRRjzdOYfRnzAG8xnI3uny0DxguOen1V3Vh/gZX0b6hFmvf0rGy5ILPc7o44I8HdoYlApXLemsanmXckUAuD3q/wD7NzxzZzn4j750Q1gRD4mMovKqB9R87kvXTP0nyzrOIRhuK55gIGA1WcuFFIKIYeXECtyq0DxzS10Z0e1xUliundsTKII9/3tebTuDJl+eREpviEJSl2/luOnpxmsoTGH9LKmnSAIx5J14nUD9WXY87OBq8ItYjygGKsKTukhizl9Es0dogx91Pmvfl0GGt4cAV8GwfDjayyRMpuk33t50cAYRntkfsl6pZ4b5lpXykqaQ3fKJdVvos46KyEqZQbnYHvQrRxkd+6sQN9SGobO5QX5zHzhzH53OMo4WuSUiG/hTJCcQV2lfEdQ3tWEfAs4zEZ3cFhXboeGBS57crSmMD9M66cOycR2/rmzy0WA32FyNIbT4ukcUfLyTKrmUU3JrC
 Ai21NAtU
 mXBDY8uJamS3IxWK0h+YkqIkqGA93Jm2aLsEN+UjlXmmeLCWesfmZDi+Nt8mpsyXJWkXLEjGaHnID7gAFkT3HNHZZEHR4ITMdnd07pn2/5xHq2yxTxuwtG43/NhXBHWyao9A+1yhtUAnoRFIS6OJrJ8XZiSFXDrBrLGUUSx2b6LKaWoaohhiJLBNV6gUDFFRuQ8bdFWInJhn2fnWiZOQJ2HtZFwnFg57IJz3jV5GxjjQHu5HmH4moQbIjuqEu8xxRxOLfE7L/AYB9o7xzS0vbjelJnEk4i9UDWVnK9aqNesA+WfzHPKUb22ljr4/nMAGwWFBllF9czw3ubiGS92Q39A+aFaVpEb+ROOn6acDdZekv6sDzqvpqv8XuyAdnbMAyzj+Ue2qjy0fpJfwOipMjl/SDF+LXP2mE5M9LHAvCKZZZ8d7thzUIR0i6vhWj6dv6dNT4aiGI2rWDrD41Cw79rLl7UivUmanB4899AlXU4yjTL44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 10:22=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed,  5 Aug 2026 18:09:01 -0700 Juan Yescas <jyescas@google.com> wrote=
:
>
> > This patch series introduces the Page Alloc Hogger. The Page Alloc Hogg=
er
> > allows you to allocate memory pages from specific nodes, zones, migrati=
on
> > types, and orders directly via debugfs. This provides key benefits for
> > testing and debugging:
>
> OK, so this is targeted at kernel developers.  And they may indeed find
> it useful.  I see value in us developing a common way for developers to
> apply well-targeted stress to MM.
>
>
> Probably everyone has their own favorite memory stresstest suite.  Most
> of these will be in userspace[*] but I see there is merit in doing it
> in-kernel.  Any perspective you can add to this choice would be
> interesting?
>

Thanks for your comments and apologies for the delay in getting back
to you, I was gathering some examples.

I think some scenarios and tests are hard to reproduce using userspace
memory stresstests. For example memory fragmentation in one node or
fragmentation
in one zone, or fragmentation by migrate type. Testing memory fallbacks, et=
c.

This proposal makes these scenarios easy to reproduce.

>
> Some usage scenarioizing would help.  Is this being used within google?

We are planning to add kselftests that create memory pressure in the system
and test that kswapd, oom, lmkd, compaction, etc., are called accordingly.

This tool will also be used to run benchmarks comparing 4KB vs 16kb
pagesizes under
various conditions (low memory, high memory fragmentation). Currently, in o=
rder
to create memory pressure, we modify the dts or set the mem kernel paramete=
r to
reduce the available RAM and then cycle through apps for hours to get the
memory fragmented. With this tool, we can create memory pressure and memory
fragmentation pretty straightforward and then run the benchmarks under thes=
e
conditions.

> If so, for what purpose and with what results?  Sell it to us - help
> your audience understand what benefit it offers to them.
>

That is a good point. Although this tool was written for devices using
less than 32 GBs
of memory, it could be used for servers. For example, if you want to
create memory
pressure in the different Nodes or zones in the server, you can easily
do it by running

# Alloc 500 GiB node 0 zone DMA
echo 128000 > /sys/kernel/debug/mm/node-0/zone-DMA/order-10/migrate-Reclaim=
able/nr_pages_allocs

# Alloc 1000 GiB node 1 zone Normal
echo 256000 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Recl=
aimable/nr_pages_allocs

# Alloc 500 GiB node 2 zone Normal
echo 128000 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Recl=
aimable/nr_pages_allocs

or you can run this script to allocate 500GiB across all nodes in the syste=
m:

for node in `set 0 16`; do  echo 128000 >
/sys/kernel/debug/mm/node-$node/zone-Normal/order-10/migrate-Reclaimable/nr=
_pages_allocs;
done

When my team want to reproduce memory issues due to fragmentation, it is no=
t
straightforward to set the memory into this state consistently with
our current tools.

Let's say that we are debugging an issue where we have enough memory
but the high
high-order allocations are failing due to memory fragmentation which
was caused by
pinned pages in the different page blocks of the zone. How could we
reproduce this fragmentation
artificially in Node 0/Zone Normal?

# cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order 0   1    2    3    4   5
6   7   8   9  10
Node 0, zone    DMA, type   Unmovable      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone    DMA, type     Movable      1   1    1    0    1   1
2   2   1   3 708
Node 0, zone    DMA, type Reclaimable      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone    DMA, type  HighAtomic      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone    DMA, type         CMA      0   0    0    0    0   0
0   0   0   1  31
Node 0, zone    DMA, type     Isolate      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone Normal, type   Unmovable    492 445  301   31    6   3
1   0   1   1   0
Node 0, zone Normal, type     Movable    387 366  357  345  341 341
329 303 291 278 559
Node 0, zone Normal, type Reclaimable    861 825 1516 1387 1176 832
473 371 361 226  10
Node 0, zone Normal, type  HighAtomic      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone Normal, type         CMA      0   0    0    0    0   0
0   0   0   1   7
Node 0, zone Normal, type     Isolate      0   0    0    0    0   0
0   0   0   0   0

Number of blocks type   Unmovable    Movable   Reclaimable
HighAtomic   CMA   Isolate
Node 0, zone    DMA      0           1472        0           0
   64    0
Node 0, zone Normal     20           1796      728           0
   16    0

We could write a custom program that mmap/mlock enough memory, and then rel=
ease
all pages except one in each page block. What if we want to fragment
also the zone DMA?

Using the driver proposed here, we could fragment the memory with this scri=
pt:

# Allocate memory from Node 0/Zone Normal/Order 0/Migrate Reclaimable
echo 307200 > /sys/kernel/debug/mm/node-0/zone-Normal/order-0/migrate-Recla=
imable/nr_pages_allocs
for i in `seq 1 307200`; do \
v=3D$(expr $i % 1024 !=3D 0); \
# Release everything but one page from each page block
if [ $v =3D 1 ]; then  echo $i > /sys/kernel/debug/mm/free; echo
"Releasing $i"; fi; \
done

# Allocate memory from Node 0/Zone Normal/Order 0/Migrate Movable
echo 307200 > /sys/kernel/debug/mm/node-0/zone-Normal/order-0/migrate-Movab=
le/nr_pages_allocs
for i in `seq 307201 614400`; do \
v=3D$(expr $i % 1024 !=3D 0); \
if [ $v =3D 1 ]; then  echo $i > /sys/kernel/debug/mm/free; echo
"Releasing $i"; fi; \
done

After running the shell script, we have fragmented the memory;

# cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order 0   1    2    3    4   5
6   7   8   9  10
Node 0, zone    DMA, type   Unmovable      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone    DMA, type     Movable      1   1    1    0    1   1
2   2   1   3 708
Node 0, zone    DMA, type Reclaimable      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone    DMA, type  HighAtomic      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone    DMA, type         CMA      0   0    0    0    0   0
0   0   0   1  31
Node 0, zone    DMA, type     Isolate      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone Normal, type   Unmovable    492 445  301   31    6   3
1   0   1   1   0
Node 0, zone Normal, type     Movable    387 366  357  345  341 341
329 303 291 278 559
Node 0, zone Normal, type Reclaimable    861 825 1516 1387 1176 832
473 371 361 226  10
Node 0, zone Normal, type  HighAtomic      0   0    0    0    0   0
0   0   0   0   0
Node 0, zone Normal, type         CMA      0   0    0    0    0   0
0   0   0   1   7
Node 0, zone Normal, type     Isolate      0   0    0    0    0   0
0   0   0   0   0

Number of blocks type   Unmovable    Movable   Reclaimable
HighAtomic   CMA   Isolate
Node 0, zone    DMA      0           1472        0           0
   64    0
Node 0, zone Normal     20           1796      728           0
   16    0

If we want to do the same with Node 0/Zone DMA, we only execute:

echo 307200 > /sys/kernel/debug/mm/node-0/zone-DMA/order-0/migrate-Reclaima=
ble/nr_pages_allocs
for i in `seq 614401 921600`; do \
v=3D$(expr $i % 1024 !=3D 0); \
if [ $v =3D 1 ]; then  echo $i > /sys/kernel/debug/mm/free; echo
"Releasing $i"; fi; \
done

# cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order  0    1    2    3    4   5
 6   7   8   9  10
Node 0, zone    DMA, type   Unmovable       0    0    0    0    0   0
 0   0   0   0   0
Node 0, zone    DMA, type     Movable       1    1    1    0    1   1
 2   2   1   3 406
Node 0, zone    DMA, type Reclaimable     293  293  292  292  292 293
293 293 293 292   2
Node 0, zone    DMA, type  HighAtomic       0    0    0    0    0   0
 0   0   0   0   0
Node 0, zone    DMA, type         CMA       0    0    0    0    0   0
 0   0   0   1  31
Node 0, zone    DMA, type     Isolate       0    0    0    0    0   0
 0   0   0   0   0
Node 0, zone Normal, type   Unmovable     566  377  261   33    7   3
 1   0   1   1   1
Node 0, zone Normal, type     Movable     290  352  344  336  330 329
321 301 296 279 559
Node 0, zone Normal, type Reclaimable    1109 1024 1928 1641 1168 521
498 374 361 226   9
Node 0, zone Normal, type  HighAtomic       0    0    0    0    0   0
 0   0   0   0   0
Node 0, zone Normal, type         CMA       0    0    0    0    0   0
 0   0   0   1   7
Node 0, zone Normal, type     Isolate       0    0    0    0    0   0
 0   0   0   0   0

Number of blocks type    Unmovable    Movable    Reclaimable
HighAtomic   CMA   Isolate
Node 0, zone    DMA       0            868       604           0
     64    0
Node 0, zone Normal      22           1796       726           0
     16    0

As we can see, it is pretty straightforward to artificially reproduce
the fragmentation using
a script.

> If this proposal has legs then we should Document/ it separately - that
> big block comment in page_alloc_hogger.c will become unweildy.
>

I agree, I am happy to move it under Document/ if the tool is useful
for other kernel developers.

>
> One could consider plumbing this into selftests/ in some fashion, but I
> wouldn't encourage that - longrunning torture tests aren't appropriate
> for selftests, which are nice and snappy.  Perhaps a new
> tools/testing/stresstests will one day appear.
>
>
>
> > +obj-$(CONFIG_PAGEALLOC_HOGGER) +=3D page_alloc_hogger.o
>
> page_alloc or pagealloc.  Choose only one, lest you drive people crazy
> for ever.
>
Good point, I can do that. Thanks for pointing it out.
>
>
> Sashiko went totally nuts.  Have fun with that ;) But I wouldn't do a
> ton of work on this until you've heard positive noises from the MM team,
> Guys, poke.  wdyt, is there potential here?
>
>         https://sashiko.dev/#/patchset/20260806011048.517229-1-jyescas@go=
ogle.com
>
>
> [*] Back in the days when I was trying to get redhat ext3 and 2.5.x
>     MM to do something other than lock up or crash, I wrote a userspace
>     thing called "usemem".  In recent times I've seen people quoting
>     usemem results and wondered "is that my thing".  So I looked it up.
>     It is!  And it's now quite unrecognizable.
>
>     Because, obviously, people found it useful and so they used it
>     and added to it and added to it and more.
>
>     And I expect the same will occur with "Page Alloc Hogger"
>     (terrible name, btw.  How about "pagehog"?  "memhog"), if it is
>     adopted.  People will use it and will add to it.
>

I agree that the name is not good. I like "pagehog".

Thanks for taking the time to review it.

Greetings
Juan
>
>

