Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24949CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9398E000E; Thu, 25 Sep 2025 14:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0D58E0001; Thu, 25 Sep 2025 14:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD988E000E; Thu, 25 Sep 2025 14:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7018E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:26:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D55C21DF87B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:11 +0000 (UTC)
X-FDA: 83928602142.21.C08BE04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D78CF120007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=msYy4trg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758824770; a=rsa-sha256;
	cv=none;
	b=uG+1I8qBN60MEtKM6CHAlSDhhRnO0iXltC/47ziAuc7moEyKhlKlyKuWydXZ1dJOEC3VXO
	Memny1/sB2w8lwftMlM2JDgSqZxTL3Zwl8BDpJzWSIRCShVIid912NOKJbhw9FUN7e5ZLf
	mYEVyHjXkzmlPzOFc6adTgzYmq8rBTE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=msYy4trg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758824770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=stqWXpg7e25/sXrR4eml3WGzg0W4FR0BY56y2LBkyEU=;
	b=pGtNM28q4zTVj/xGLUXpFWnfZo+bSP0EnDb89mu9seBr+qY3mfEpcH5oGAGh+A7RJf3xau
	eOCyFpIGfg6P55vmNhCHKKq1YOs9NlrrLCkVnS9J5NZ8bJMjgYal5V0kffEU9zP8QX/DE4
	hKw79G8yngGvA/kY4zNvZZ/HDebxRPY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFF9D43BA2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB72C4CEF4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758824768;
	bh=DlB4tVCKpAVTusj26U9+rBCFaEApCKO8j4lQIvHJovE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=msYy4trg4G3NTgOcwOQo9ooF8EBcNWMEnJj0xXy9gndp07SKF4+oBEJtVkNcxHNVs
	 bo3R5MCOMZpGv3PiU+aQsKKFbKdxuAPQU5qAkgA0OHsWLrgb8qP/WwZ2iNs5WZlr7Z
	 FP2qQ7O3JfrJEtIK/9syDp6kNDeHHg2nDZ8wVQDUB4yeFZnvihklMIzEL37v3GeCri
	 VF4K8XwIkJA6KZvpiQRqeS2N02m/np2ms6LoD8WB0VhUQD/+n5iQrU+6T4wGr95fwT
	 P39XtpUAfEsWrvLv0GwzAv+PeqtsfaVhgwr31U4B3rnxN74aWBepEErICjY3tqJqdP
	 fk4/frtBiqHpg==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6352c8b683eso1151762d50.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:26:08 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx3cF+BnC8WtFLX6zBAmQ4PPvFeNFrlp5J8U7wSYJGQkR/umoTm
	OWnm5YGSSSfnrnEQpA5gTwdcJUcTYsfjSdzCd3EB9Fe68xeWDWuDVBA6J/xcvb5RjHqwVUw8aXE
	/PQ6UfDig9BcmDEfkRiDdopEvtT6IbUss1e9XFMN5EQ==
X-Google-Smtp-Source: AGHT+IHGREAbCXAjAciRgKHXY2OZCCLiSaasKLb9FrE385QScjxqqAd8ay+uBE5HIDnJ3pvKBQ9x68EoMs2kUhNZwj8=
X-Received: by 2002:a05:690e:805:b0:633:adbd:d706 with SMTP id
 956f58d0204a3-6361a85fff2mr3015529d50.26.1758824767818; Thu, 25 Sep 2025
 11:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250924091746.146461-1-bhe@redhat.com> <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
 <aNShH7WWxuBEvIuh@MiWiFi-R3L-srv>
In-Reply-To: <aNShH7WWxuBEvIuh@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 25 Sep 2025 11:25:56 -0700
X-Gmail-Original-Message-ID: <CACePvbU485gPMEvBeK2CN4Ept-zS3ZYXfcVC8Fbk83saX_2dzQ@mail.gmail.com>
X-Gm-Features: AS18NWAfClcOsfuVrBQRzh-cTJQjWfDRx7qyhLYeKh_Tia9PMncceMpBmwYCX_A
Message-ID: <CACePvbU485gPMEvBeK2CN4Ept-zS3ZYXfcVC8Fbk83saX_2dzQ@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D78CF120007
X-Stat-Signature: fg4ekan74t5igscdamt5ogshaxqyfzb3
X-Rspam-User: 
X-HE-Tag: 1758824769-712334
X-HE-Meta: U2FsdGVkX1+SoUfyL8HnNPl93aD1GGwVRTkhJriS4ZSOaXTV7xpXYkJF7KmEpcMqu0dmQOHTTOKTug01lc1yOtgXygdc5ssp7a1uop0+PbyXrRSr0D/Kd9EBM79cc9oIMqqodOhTe79KH+cLQMKb7WwcmQfzwbJbjvoQ62LMOZLDSxnhcbSnAYw7UIrYp+dcuATFfiWFW1E6vWYv3pnbJ7ywQA4lgtVsMAhFheHF52GAPsmaGwhrfX3DQ3oBKmXGYxWFH62FOX1amUj7Q5TdMwDe57JmP5nG0SDtrOiiDOvTWScXGwKaW/K6EN16NH+vDJlrjKZdZj5HYcL4+VZWRp+P3+R8e4mw3iCBnoOyhIYIvkiG/0k/+vBqXyZnf4hb5rOJbKWQ5vJRMrpO5JJ511SGOA6/6x2SdxMNkY9ZVVVRI5U0+NTaVo05xlh4ICQ+dU7zdocj+Ohx5AGTWIwVufooQMwmgj4khCTdJ2v8T4ge0QeZhrP9QT30KOekSImDfzdKglm5HTESUJV3191yLE69LeNtSsONiVlo9ud1H6y5p+MLjbgJZjahU6e6W3qYON51yB3nKDyoR+nj8RmPh96/Be2x/3G9rcfu1r2ZtXjBGTbTkmn2ZDyZCrIAMUHwX+FQiy2+78D5L8WSGWboq/LeKItqZwfwtsRH/yEdzUP1KS96tU21itlJI2p4eieijpqbigPKgIgoHh31v2lSdZ+3gJOjiG21gitbEvbasmVHKMv7nAxsl5VdCat0EDHeubViKI+VBjkwGG2oHbnBuLGrghzp45pQJhZ2vNZ47Gl4pft3Tpjv0f9ejU1EZ33mv5qSSDaPR2KbLZbBO9peEK4Qu9vlfecAdS3DjCB01/7H+U/sPNdsU3aNT2A8S/C8RKyX5RUPto0VVsgcXtrZ9z4RKIiK7TpF/f7mVP8CyHqGAB2bSMa/QP0NpC83/GujSJvATT5q6gpKuouQoyk
 17PtUUD+
 4mR3DUUQJuq1A/M6TyriHT8z3vL2CPzdat0HlnPtKOrd2q76eCmha6fgodXrgFEegE9SMCiYFBVXu0gQbLD+TWPF5E3gRNHfKnTT185cxcqWo/Uq1C34jUHX7OMAkxWAn5d1fa3kGihaJYQ6YsuDeCxXXJKiSrkujhSMiBLS34d0LeoXjNiqL/weCSXMf1gP0LxzqSazC6/F1JSHCilb0I3e+kdTLD67YkjCFvmZaOKQGUn4aND5XPOk9rXJopLBWUfWxkz8QYhjwc2xD8JMrenqFCpwDEosQrOTY8UToyz0SP1Ry+6J6M5jO9+dV1qxlVbWZDZsw4RuZrkU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 6:55=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/24/25 at 08:54am, Chris Li wrote:
> > Hi Baoquan,
> >
> > Very exciting numbers. I have always suspected the per node priority
> > is not doing much contribution in the new swap allocator world. I did
> > not expect it to have negative contributions.
>
> Yes.
>
> While compared with the very beginning, there has been some progress.
> At the very beginning, there was one plist and swap device will get
> priority from -1 then downwards by default, then all cpus will exhaust
> the swap device of pirority '-1', then select swap device of priority
> '-2' to exhaust, then -3, .... I think node-based adjustment distribute
> the pressure of contending lock on one swap device a little bit.
> However, in node they still try to exhaust one swap device by node's
> CPUs; and nodes w/o swap device attached still try to exhaust swap
> device one by one in the order of priority.
>
> >
> > On Wed, Sep 24, 2025 at 2:18=E2=80=AFAM Baoquan He <bhe@redhat.com> wro=
te:
> > >
> > > Currently, on system with multiple swap devices, swap allocation will
> > > select one swap device according to priority. The swap device with th=
e
> > > highest priority will be chosen to allocate firstly.
> > >
> > > People can specify a priority from 0 to 32767 when swapon a swap devi=
ce,
> > > or the system will set it from -2 then downwards by default. Meanwhil=
e,
> > > on NUMA system, the swap device with node_id will be considered first
> > > on that NUMA node of the node_id.
> >
> > That behavior was introduced by: a2468cc9bfdf ("swap: choose swap
> > device according to numa node")
> > You are effectively reverting that patch and the following fix up
> > patches on top of that.
> > The commit message or maybe the title should reflect the reversion natu=
re.
> >
> > If you did more than the simple revert plus fix up, please document
> > what additional change you make in this patch.
>
> Sure, I will mention commit a2468cc9bfdf and my patch reverts it, on top
> of that default priority of swap device will be set to '-1' so that all
> swap devices with default priority will be chosen round robin. Like
> this, the si->lock contention can be greatly reduced.

Just curious, is setting to "-1" matches to kernel behavior before
a2468cc9bfdf, if not what is the behavior before a2468cc9bfdf.

> > > In the current code, an array of plist, swap_avail_heads[nid], is use=
d
> > > to organize swap devices on each NUMA node. For each NUMA node, there
> > > is a plist organizing all swap devices. The 'prio' value in the plist
> > > is the negated value of the device's priority due to plist being sort=
ed
> > > from low to high. The swap device owning one node_id will be promoted=
 to
> > > the front position on that NUMA node, then other swap devices are put=
 in
> > > order of their default priority.
> > >
> >
> > The original patch that introduced it is using SSD as a benchmark.
> > Here you are using patched zram as a benchmark. You want to explain in
> > a little bit detail why you choose a different test method. e.g. You
> > don't have a machine with an SSD device as a raw partition to do the
> > original test. Compression ram based swap device, zswap or zram is
> > used a lot more in the data center server and android workload
> > environment, maybe even in some Linux workstation distro as well.
>
> Yeah, just as you said. I haven't got a machine to create several SSD
> partitions as swap device to test this. So hacked the zram kernel code
> to assign device id to zram devices's node_id. I also tried to use
> several swap files on one SSD disk, the speed is too slow, the
> comparison results are not very obvious, there's only about 1%
> promotion. And as you said, in reality, currently zram or swap is being
> taken more and more and become the default setup on systems. So I think
> it makes sense to use zram devices to test this patch.

Yes, I understand, you want to mention that in your cover letter for
the reader to know.

>
> >
> > You can also invite others who do have the spare SSD driver to test
> > the SSD as a swap device. Maybe with some setup instructions how to
> > set up and repeat your test on their machine with multiple SSD drives.
> > How to compare the result with or without your reversion patch.
>
> Sure, I will write these detailed steps in v2 cover letter, and attach
> my two draft scripts for easing doing statistics and output the final
> result.

Ack

>
> >
> > > E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
> > > swap devices.
> >
> > You want to make it clear up front that you are using a patched zram
> > to simulate the per node swap device behavior. Native zram does not
> > have that.
>
> Sure, will add it in v2 cover letter.

Ack.

>
> >
> > >
> > > Current behaviour:
> > > their priorities will be(note that -1 is skipped):
> > > NAME       TYPE      SIZE USED PRIO
> > > /dev/zram0 partition  16G   0B   -2
> > > /dev/zram1 partition  16G   0B   -3
> > > /dev/zram2 partition  16G   0B   -4
> > > /dev/zram3 partition  16G   0B   -5
> > >
> > > And their positions in the 8 swap_avail_lists[nid] will be:
> > > swap_avail_lists[0]: /* node 0's available swap device list */
> > > zram0   -> zram1   -> zram2   -> zram3
> > > prio:1     prio:3     prio:4     prio:5
> > > swap_avali_lists[1]: /* node 1's available swap device list */
> > > zram1   -> zram0   -> zram2   -> zram3
> > > prio:1     prio:2     prio:4     prio:5
> > > swap_avail_lists[2]: /* node 2's available swap device list */
> > > zram2   -> zram0   -> zram1   -> zram3
> > > prio:1     prio:2     prio:3     prio:5
> > > swap_avail_lists[3]: /* node 3's available swap device list */
> > > zram3   -> zram0   -> zram1   -> zram2
> > > prio:1     prio:2     prio:3     prio:4
> > > swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list *=
/
> > > zram0   -> zram1   -> zram2   -> zram3
> > > prio:2     prio:3     prio:4     prio:5
> > >
> > > The adjustment for swap device with node_id intended to decrease the
> > > pressure of lock contention for one swap device by taking different
> > > swap device on different node. However, the adjustment is very
> > > coarse-grained. On the node, the swap device sharing the node's id wi=
ll
> > > always be selected firstly by node's CPUs until exhausted, then next =
one.
> > > And on other nodes where no swap device shares its node id, swap devi=
ce
> > > with priority '-2' will be selected firstly until exhausted, then nex=
t
> > > with priority '-3'.
> > >
> > > This is the swapon output during the process high pressure vm-scabili=
ty
> > > test is being taken. It's clearly shown zram0 is heavily exploited un=
til
> > > exhausted.
> >
> > Any tips how others repeat your high pressure vm-scability test,
> > especially for someone who has multiple SSD drives as a test swap
> > device. Some test script setup would be nice. You can post the
> > instruction in the same email thread as separate email, it does not
> > have to be in the commit message.
>
> Sure, will do.

Ack

>
> >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [root@hp-dl385g10-03 ~]# swapon
> > > NAME       TYPE      SIZE  USED PRIO
> > > /dev/zram0 partition  16G 15.7G   -2
> > > /dev/zram1 partition  16G  3.4G   -3
> > > /dev/zram2 partition  16G  3.4G   -4
> > > /dev/zram3 partition  16G  2.6G   -5
> > >
> > > This is unreasonable because swap devices are assumed to have similar
> > > accessing speed if no priority is specified when swapon. It's unfair =
and
> > > doesn't make sense just because one swap device is swapped on firstly=
,
> > > its priority will be higher than the one swapped on later.
> > >
> > > So here change is made to select the swap device round robin if defau=
lt
> > > priority. In code, the plist array swap_avail_heads[nid] is replaced
> > > with a plist swap_avail_head. Any device w/o specified priority will =
get
> > > the same default priority '-1'. Surely, swap device with specified pr=
iority
> > > are always put foremost, this is not impacted. If you care about thei=
r
> > > different accessing speed, then use 'swapon -p xx' to deploy priority=
 for
> > > your swap devices.
> > >
> > > New behaviour:
> > >
> > > swap_avail_list: /* one global available swap device list */
> > > zram0   -> zram1   -> zram2   -> zram3
> > > prio:1     prio:1     prio:1     prio:1
> > >
> > > This is the swapon output during the process high pressure vm-scabili=
ty
> > > being taken, all is selected round robin:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [root@hp-dl385g10-03 linux]# swapon
> > > NAME       TYPE      SIZE  USED PRIO
> > > /dev/zram0 partition  16G 12.6G   -1
> > > /dev/zram1 partition  16G 12.6G   -1
> > > /dev/zram2 partition  16G 12.6G   -1
> > > /dev/zram3 partition  16G 12.6G   -1
> > >
> > > With the change, we can see about 18% efficiency promotion as below:
> > >
> > > vm-scability test:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > Test with:
> > > usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
> > >                            Before:          After:
> > > System time:               637.92 s         526.74 s
> > You can clarify here lower is better.
> > > Sum Throughput:            3546.56 MB/s     4207.56 MB/s
> >
> > Higher is better. Also a percentage number can be useful here. e.g.
> > that is +18.6% percent improvement since reverting to round robin. A
> > huge difference!
> >
> > > Single process Throughput: 114.40 MB/s      135.72 MB/s
> > Higher is better.
> > > free latency:              10138455.99 us   6810119.01 us
>
> OK, will improve this.

Ack

> > >
> > > Suggested-by: Chris Li <chrisl@kernel.org>
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > ---
> > >  include/linux/swap.h | 11 +-----
> > >  mm/swapfile.c        | 94 +++++++-----------------------------------=
--
> >
> > Very nice patch stats! Fewer code and runs faster. What more can we ask=
 for?
> >
> >
> > >  2 files changed, 16 insertions(+), 89 deletions(-)
> > >
> > > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > > index 3473e4247ca3..f72c8e5e0635 100644
> > > --- a/include/linux/swap.h
> > > +++ b/include/linux/swap.h
> > > @@ -337,16 +337,7 @@ struct swap_info_struct {
> > >         struct work_struct discard_work; /* discard worker */
> > >         struct work_struct reclaim_work; /* reclaim worker */
> > >         struct list_head discard_clusters; /* discard clusters list *=
/
> > > -       struct plist_node avail_lists[]; /*
> > > -                                          * entries in swap_avail_he=
ads, one
> > > -                                          * entry per node.
> > > -                                          * Must be last as the numb=
er of the
> > > -                                          * array is nr_node_ids, wh=
ich is not
> > > -                                          * a fixed value so have to=
 allocate
> > > -                                          * dynamically.
> > > -                                          * And it has to be an arra=
y so that
> > > -                                          * plist_for_each_* can wor=
k.
> > > -                                          */
> > > +       struct plist_node avail_list;   /* entry in swap_avail_head *=
/
> > >  };
> > >
> > >  static inline swp_entry_t page_swap_entry(struct page *page)
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index b4f3cc712580..d8a54e5af16d 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
> > >  EXPORT_SYMBOL_GPL(nr_swap_pages);
> > >  /* protected with swap_lock. reading in vm_swap_full() doesn't need =
lock */
> > >  long total_swap_pages;
> > > -static int least_priority =3D -1;
> > > +#define DEF_SWAP_PRIO  -1
> > >  unsigned long swapfile_maximum_size;
> > >  #ifdef CONFIG_MIGRATION
> > >  bool swap_migration_ad_supported;
> > > @@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
> > >   * is held and the locking order requires swap_lock to be taken
> > >   * before any swap_info_struct->lock.
> > >   */
> > > -static struct plist_head *swap_avail_heads;
> > > +static PLIST_HEAD(swap_avail_head);
> > >  static DEFINE_SPINLOCK(swap_avail_lock);
> > >
> > >  static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> > > @@ -995,7 +995,6 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si, int o
> > >  /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
> > >  static void del_from_avail_list(struct swap_info_struct *si, bool sw=
apoff)
> > >  {
> > > -       int nid;
> > >         unsigned long pages;
> > >
> > >         spin_lock(&swap_avail_lock);
> > > @@ -1007,7 +1006,7 @@ static void del_from_avail_list(struct swap_inf=
o_struct *si, bool swapoff)
> > >                  * swap_avail_lock, to ensure the result can be seen =
by
> > >                  * add_to_avail_list.
> > >                  */
> > > -               lockdep_assert_held(&si->lock);
> > > +               //lockdep_assert_held(&si->lock);
> >
> > That seems like some debug stuff left over. If you need to remove it, r=
emove it.
>
> I ever tried to adjust the lock usage, later I found I need keep it as
> is, but forgot to change this line back. Will change it in v2.

Ack.

>
> >
> > The rest of the patch looks fine to me. Thanks for working on it. That
> > is a very nice cleanup.
> >
> > Agree with YoungJun Park on removing the numa swap document as well.
>
> Exactly, will do.

Ack.

>
> >
> > Looking forward to your refresh version. I should be able to Ack-by on
> > your next version.
>
> Thank you very much for your great suggestion from a big picture view,
> and help during the process. Really appreciate it.

You are welcome. Thanks for the great work.

I am glad we don't need to carry that complexity any more.

Chris

