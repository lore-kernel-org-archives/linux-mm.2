Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27955CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 04:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0156B008A; Sat,  3 Oct 2026 00:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E700A6B008C; Sat,  3 Oct 2026 00:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38296B0092; Sat,  3 Oct 2026 00:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB536B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:11:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8B26C08F1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:11:23 +0000 (UTC)
X-FDA: 85279990446.18.6AEC46E
Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96E2E80005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:11:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S9tfRV69;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791000680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUHl6H14yvaLSB7sDXvqH9cJB/gMfh/FqJeWNxmljqs=;
	b=3LRZ5zwZ/GlvQyqwXg9/j3W6ToEh5DK+Jy1rxvAMsPj5TpiQnFhQ3thDlsm8Bk6KzN620c
	5WilyVKCTTRH7bKP1+6F3qai2HEO8/QKd0YLBCzB7AQzxyxyleLmJg/islPJ+TyqY8wfgn
	6Z5RemE2RknI95KxFcZxwXjE9nFk7/k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S9tfRV69;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791000680;
	b=H9ueLofYUnu2TCr8SxNv2/hQIdUGm0VjU3yoevROmoL6l1MrAzzb4csiT8V8vP2dGLqULd
	Aa9RtSHdZbqjVMpDHfk03o6k8jfknGdkoP80BDwirk5IbnchnmP8VKlXZAipvPHNbtlM5x
	fJUzS+ChKitMsRlwzDXEfULmGD23MS0=
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa1d00daaaso155866a12.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 21:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791000679; cv=none;
        d=google.com; s=arc-20260327;
        b=ixl0/BDt8/no+cKk1fMwl3qyQhsdTo5jmpzmXjFd4KlG8HHFnAI/cYD9Di8Vng/X5c
         T88p4l2LH7SlNfEpBFAOnRG9j7LszfNd/5Eh7ruCnkoKRjnKlM39BAdEHd9Dw3/0Yn8G
         9nZ6tFOdInhQlb7sxaA/udcZy5e5khud2y10t11RGyhwZOwrqqb273H05StvZQMQDlqH
         GlsYT/G2hsv1gC/2LIUMrBsFBK2w9LxktAMkHhb6vEvZ/GOZntTukKS2tSNlPCQ9+Bog
         ofe4MtnfDjpI5HI7MiRnYa44X+WPLcJeCkDmdL9eW7tU8jFtAlYxgSqm4YTOkTetHFfl
         IP4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YUHl6H14yvaLSB7sDXvqH9cJB/gMfh/FqJeWNxmljqs=;
        fh=SaElBN8HABs+mQuCV42fr8vr05ER3lSJd3Pnw7e8aLc=;
        b=pYebdK0iwktVQ0Z0J0jCMe7Tmf3Mawtr88Pa0lj9UtXak9to61HxCboDBxfakRB/59
         tOVjoIkdN6Voz+IQw3mZEKLgtmq29uH9HN55k1fFJ1epTqR93VlbNCKg4DLr/7YemMZ0
         lJZ8/WAC1z1OtyyQ/gu/JsyAsThxkrhgDEj/Op68FKKUaiG0y/13vrWCaBm1mLasU4Ew
         vyY5B3F5ewya0RwBMASoslcMM6SFPcyJ4Y4ep+3sMz1Hmu8JZURu17FCSUcDbaNb3PMM
         oM5rDlafEaCJQZIDSRmKRB7ktWpUJ6Lbp+eNa/HDxCwfFbg7CmHyEhMlN3hEW/sjqxrc
         xrSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791000679; x=1791605479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YUHl6H14yvaLSB7sDXvqH9cJB/gMfh/FqJeWNxmljqs=;
        b=S9tfRV69sy+F/8MpwN7Sl0Lm+fIp7A+prj7FJtk7S41XBs9nl8VV8+Si8Z6R9PHzMt
         r702pFUV3wyA5QXQU3AZwfbDuZUQ4NtD0FBTf9Vci5mAhAFNww2JeNCkTjkLvEI5z57h
         272p39HOFNE01/eVJrn/Yz9GWVKxf0PHYCdTvFqnj960+LV6j3xF10CYufLmnlSf6A4k
         LFhV0fE5w8lTJ3BURX8m3UW8mjnoQCVD99fdCXFWWLPZvFjSbumnlz4aWaDQ0yjnZZYh
         JU+bQohTn5bGlJ9vSAi80AUl2+VTrs+KSbbp7XqNhAZo7BlCL0fxsGxyHfMHwQoPl0tY
         ix0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791000679; x=1791605479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YUHl6H14yvaLSB7sDXvqH9cJB/gMfh/FqJeWNxmljqs=;
        b=wNNIiyRcIbScYeZYJyi6ZU8VSOf4RBtck/tM2XjjXFOOzjkCINRnonivqlCI4sFJAE
         vki7Pd69jnMcwmRUhbGuQq8mAnW2ybyn5vYDLisFeLC9gzPWte0VNgAsZ18xyeQYBa77
         fsuT7XZGwtBsMqfhz5IRpRJUxoJzXJ0eGxytzo88tQlan3kM+8MLlPYlcx06QlHThoKL
         Fw34LAfiWjzRrxTv4cXoJkiWBCZE8qafvcjzW5GNGEojk1YA5qOe4s3Q3zKnpg5TBtT+
         aRnqs2BoZPxct7VQ3NdlvIivABXRJUXExsMAawCl/4FQviZ4b9tz8DUQN3QDNSoRItTf
         ZFgw==
X-Forwarded-Encrypted: i=1; AKwUvBxhXYyUCdYx8Oq/SNwPAoLJkB3cF795Lx0S52OF0rmc7jlojsxhO8AR154rN0V1LVgEjNE0lPhbBA==@kvack.org
X-Gm-Message-State: AFq9FYIDr1G0d7CHnX+l0e2xYIPLHNHzRy6h/bpv0Z3u8vUdhWay3vmR
	mToFzs4vp509K+NAMTfrGw4+0DwIeeTtuCReMRnBOtWCYRUzp2/qXVD8TmVRX/USliPmvYnq+dW
	SsZK7WfWybWukbUJjQuQloZyhp62zEC0=
X-Gm-Gg: AYBFou1+SRxI4Mc79WSRW3DeX8/B+XXAet8xEX9Emd4KJWNptivfy7E3VZjbuipFoqS
	POtDTzvSC2LejD/XdPXmxLrOmiA0VpiwZdTZ4xoaZHiBC3L1gjcFjlSRbO/arVJD9bH+HZaIh76
	VkbDOO/YfH5ggJmTfD6I91QsvV2VJni8jzRt4S/nCO+lIThj2zEGRJN8RZHmpsxShW1hHxPaODj
	d5EX5+/BTVDO4SnUMuTUNr1lyPbPbTr04Wy7qGxowp8gS0yEM210XD8iG8bnoRIngsb6Km+fewR
	LsHRfSw21dWouynfXW3Vme0HuAKoJ6mozeVApJJtJxkCgCxEz4kyzPS2
X-Received: by 2002:a05:6402:2707:b0:6ac:ae5a:a9cf with SMTP id
 4fb4d7f45d1cf-6af9e35c2d4mr3118447a12.34.1791000678732; Fri, 02 Oct 2026
 21:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
 <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F> <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
 <ar_zftIk5caN-5uV@gourry-fedora-PF4VCD3F> <CAAiJnjrjtseaUPo5vyqGZeDAt4ST6eqvaXOCWvdaTUsx2D3v5g@mail.gmail.com>
 <asAjUfNg_80sA6Yn@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <asAjUfNg_80sA6Yn@pedro-suse.tail5790ac.ts.net>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Sat, 3 Oct 2026 07:11:07 +0300
X-Gm-Features: AclHuK99aE9LoyUHkCU6GQEqMyloaCkYaqytGdPVY98I64--lyyvldBjve2C5fI
Message-ID: <CAAiJnjqSMPCzO2wYg1YsUK9Nz_8Wd0R+XUxpN-YBa=3DpEMpTQ@mail.gmail.com>
Subject: Re: Poor memory bandwidth performance between NUMA nodes
To: pfalcato@suse.de
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k9sdf9fj7kyz3n9zb6ttt8y8qmf5ra1u
X-Rspamd-Queue-Id: 96E2E80005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791000680-877804
X-HE-Meta: U2FsdGVkX1/S/9TI/9K6vmNVF1QQ1cRP7M9EAuM0TIPKUnqdhthOvUuTQRf75nowwEBVk7vrTtMdfm8zO2fqXfMCGGzESpM9uPGpezr9cdxQSlsKzKmics5tLlXcMoIrsY3M1Z/DDkbiwxXh0a+UiWGn5L2RMZu6GGMJPbbpJb82HK4kM+LwlEuE+DTsVs6hO8XiyKNa6Dm8D/1PT5ft31BSWdzn0eQURZh0NMmBqKc/QxwezIJv7EGAfsVQYQqaHibtaPo7smqV/e/qTIbwkoZLxUkItXGmCy4EfFqqW2lKQ1ixUBtPdYa1xje6cRi+NjtYulykz1MdMz7QpVy7QHZg1DtklFgr0Pa5ouImdJK8e6XZRUgnR3Z1a5On9eEsj3CZ2CBSf23iMsGWnovrTetx6/rNVcU/B4o1Zhj8Dx99P3F5IytLAVZ1CiH/3/qM4fzF7Rqs0eFjzvn4VoG9kmf958NSYvnvoODctLZOG3UfFcCd0kErYkIxzH18B1gnj4rH9fJcmy2hwAOns57i43EIkC21MyhKG5STiwRNvoCLPWhhvHKwYnl1wnhlxi9lK5TmgnmSCuLeoiSWKwBj/z2zkFl0a15J8JqrGHGki4DtNhOGLLqlFHBRIigDWC4Cz49nd054AaX6ul+6JImkJpQ/xb9lJaLUG7FbIqcTkuQvT+re09qcnfqcrgYe8PyIjBQuFHG7AMflf2yEMjJZXAXtCzi+al8UF878FGJEKzGTDW0gqPFRDD+sA+dRNppzsDgWSQwO+PTP/C+5QK7bS2cBchw7rM1/Y46wrImdgNKZitqXTFI5o492ENKdDZtSOYtiqCXt/yNvD5Hq6sosqOD5vZRnY/0lvxUzA0fBl8nNYjEouKfWBMVEKZa4o3rRBhxDphSlRPqb0gKB3xCsVYfT6NVrN5yuEePJZ5lgoS8YMT41Kaf6NUB4jKSG1TYmA615W3biRaYdWPPgtyP
 lddQlQlj
 yRQd+OHVmwPYXj2vUnYH/5pNzeqfwimKX2/KGUisnqDWzQbAN2fgGR/GiNDOdFcyt8Jh+wLsuuyqTj7PWTuiSZtDuMPOZ1tp/anIDDxMzcLVaYx2LE6kp93F2BXoBAHT0ljOdr5kDat8MTwyeAd0woamGtDTyV6WGORQM8RqxdyPyf1pHVFSTEPeu3LSlNljf8IjQ7Np0lHm9S5AIruRm4F+XU4y1FXXiumQnp5fvDKXhOJSL6xobgdb1YLEo8fpMWFzZJFTqvXJW9qf1On5Qcpf0zrl7ND5TcQ53Ita6bx5mj2IDoYGolc1LueruLLbakkhOKmb76T3//SdJXyPlc/+ooprAOXFr255wN17S45d3ZsuP2dsKIFh5I5F94Q3O6MACKY7YNErET88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ...are the struct pages on the pmem node itself?

It was ("map":"dev")

I re-created with ("map":"mem"),

[root@localhost ~]# ndctl list
[
  {
    "dev":"namespace1.0",
    "mode":"devdax",
    "map":"mem",
    "size":3234108276736,
    "uuid":"3a3f75b9-0f03-4ed0-8175-4b4047d16615",
    "chardev":"dax1.0",
    "align":2097152
  },
  {
    "dev":"namespace0.0",
    "mode":"devdax",
    "map":"mem",
    "size":3234108276736,
    "uuid":"d67528f5-0f41-4797-bff7-3b175d1cbc05",
    "chardev":"dax0.0",
    "align":2097152
  }
]
[root@localhost ~]# numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
22 23 24 25 26 27
node 0 size: 386590 MB
node 0 free: 336076 MB
node 1 cpus: 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
47 48 49 50 51 52 53 54 55
node 1 size: 387055 MB
node 1 free: 337345 MB
node 2 cpus:
node 2 size: 3082240 MB
node 2 free: 3082240 MB
node 3 cpus:
node 3 size: 3082240 MB
node 3 free: 3082240 MB
node distances:
node     0    1    2    3
   0:   10   20   25   35
   1:   20   10   35   25
   2:   25   35   10   20
   3:   35   25   20   10
[root@localhost ~]# /home/anton/Linux/mlc
Intel(R) Memory Latency Checker - v3.13
Measuring idle latencies for sequential access (in ns)...
                Numa node
Numa node            0       1       2       3
       0          82.4   147.0   173.8   237.5
       1         146.9    82.7   238.8   172.3

And repeated test with stress-ng,

[root@localhost ~]# numactl --cpunodebind=3D0 --preferred=3D0 stress-ng
--vm 1 --vm-bytes 300G --vm-hang 0 &
[1] 10761
[root@localhost ~]# stress-ng: info:  [10761] defaulting to a 1 day
run per stressor
stress-ng: info:  [10761] dispatching hogs: 1 vm
stress-ng: info:  [10763] vm: using 300GB per stressor instance (total
300GB of 6.52TB available memory)


[root@localhost ~]# COLUMNS=3D500 numastat -p 10764 | cat

Per-node process memory usage (in MBs) for PID 10764 (stress-ng-vm)
                           Node 0          Node 1          Node 2
    Node 3           Total
                  --------------- --------------- ---------------
--------------- ---------------
Huge                         0.00            0.00            0.00
      0.00            0.00
Heap                         0.06            0.00            0.00
      0.00            0.06
Stack                        0.03            0.00            0.00
      0.00            0.03
Private                 307200.75            0.95            0.00
      0.00       307201.70
----------------  --------------- --------------- ---------------
--------------- ---------------
Total                   307200.84            0.95            0.00
      0.00       307201.79
[root@localhost ~]# migratepages 10764 0 2


|---------------------------------------||---------------------------------=
------|
|--            System DRAM Read Throughput(MB/s):        844.34
        --|
|--           System DRAM Write Throughput(MB/s):        840.21
        --|
|--             System PMM Read Throughput(MB/s):        783.93
        --|
|--            System PMM Write Throughput(MB/s):        801.99
        --|
|--                 System Read Throughput(MB/s):       1628.27
        --|
|--                System Write Throughput(MB/s):       1642.20
        --|
|--               System Memory Throughput(MB/s):       3270.47
        --|
|---------------------------------------||---------------------------------=
------|

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMM=
AND
  11275 root      20   0    2644   1764   1644 R  99.5   0.0   1:46.90
migratepages
  11355 root      20   0   10916   6200   3896 R   0.3   0.0   0:00.03 top
      1 root      20   0   26012  15728  10484 S   0.0   0.0   0:02.57 syst=
emd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.13 kthr=
eadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-rcu_gp
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-sync_wq
      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-kvfree_rcu_reclaim
      7 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-slub_flushwq
      8 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-netns
     10 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/0:0H-events_highpri

Samples: 125K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
54514328868 lost: 0/0 drop: 0/0
Overhead  Shared Object                      Symbol
  45.48%  [kernel]                           [k] migrate_folio_unmap
  18.24%  [kernel]                           [k] clear_highpages_kasan_tagg=
ed
  15.00%  [kernel]                           [k] copy_mc_fragile
   1.83%  [kernel]                           [k] smp_call_function_many_con=
d
   1.18%  [kernel]                           [k] page_vma_mapped_walk
   1.07%  [kernel]                           [k] try_to_migrate_one
   0.99%  [kernel]                           [k] folio_migrate_flags
   0.76%  [kernel]                           [k] rmqueue_bulk
   0.72%  [kernel]                           [k] remove_migration_pte
   0.53%  [kernel]                           [k] __mod_memcg_lruvec_state
   0.53%  [kernel]                           [k] migrate_folio_move
   0.51%  [kernel]                           [k] __free_one_page
   0.50%  [kernel]                           [k] lru_gen_add_folio
   0.49%  [kernel]                           [k] rmap_walk_anon
   0.49%  [kernel]                           [k] folio_batch_move_lru
   0.46%  [kernel]                           [k]
__list_del_entry_valid_or_report
   0.46%  [kernel]                           [k] migrate_pages_batch
   0.45%  [kernel]                           [k] folio_add_anon_rmap_ptes
   0.32%  [kernel]                           [k] mod_node_page_state
   0.32%  [kernel]                           [k] up_read
   0.31%  [kernel]                           [k] lru_add
   0.30%  [kernel]                           [k] __rcu_read_unlock

Samples: 175K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
66480019193
migrate_folio_unmap  /proc/kcore [Percent: local period]
   0.01 =E2=94=82       movq   %rdi,%rax
        =E2=94=82       movq   %rcx,%rdi
        =E2=94=82       movq   %rbx,0x8(%rsp)
        =E2=94=82       movq   %rcx,%rbx
   0.01 =E2=94=82       movq   %r12,0x18(%rsp)
        =E2=94=82       movq   %rsi,%r12
        =E2=94=82       movq   %rdx,%rsi
        =E2=94=82       movq   %r13,0x20(%rsp)
   0.01 =E2=94=82       movq   %rdx,%r13
        =E2=94=82       movq   %r14,0x28(%rsp)
        =E2=94=82       movl   %r9d,%r14d
        =E2=94=82       movq   %r15,0x30(%rsp)
   0.01 =E2=94=82       movq   %r8,%r15
        =E2=94=82     =E2=86=92 callq  *%rax
   0.21 =E2=94=82       testq  %rax,%rax
        =E2=94=82     =E2=86=93 je     2e3
   0.01 =E2=94=82       movq   %rbp,0x10(%rsp)
   0.01 =E2=94=82       movq   %rax,%rbp
   0.07 =E2=94=82       movq   %rax,(%r15)
   0.00 =E2=94=82       movq   $0x0,0x28(%rax)
  99.10 =E2=94=82       lock
        =E2=94=82       btsq   $0x0,(%rbx)
   0.02 =E2=94=82     =E2=86=93 jb     26b
   0.16 =E2=94=82 67:   movq   (%rbx),%rdx
   0.01 =E2=94=82       testq  $0x2,(%rbx)
   0.01 =E2=94=82     =E2=86=93 je     e2
        =E2=94=82       cmpl   $0x2,%r14d
        =E2=94=82     =E2=86=93 je     d2
        =E2=94=82       movq   0x40(%rsp),%r8
        =E2=94=82       movq   %rbx,%rdi
        =E2=94=82       movl   $0x1,%ecx
        =E2=94=82       xorl   %edx,%edx
        =E2=94=82       xorl   %esi,%esi
        =E2=94=82       movl   $0xfffffff0,%ebx
        =E2=94=82     =E2=86=92 callq  migrate_folio_undo_src
        =E2=94=82       testq  %r12,%r12
        =E2=94=82     =E2=86=93 je     1b0
        =E2=94=82 9d:   movq   %rbp,%rdi
        =E2=94=82       movq   %r13,%rsi
        =E2=94=82     =E2=86=92 callq  *%r12


[root@localhost ~]# COLUMNS=3D500 numastat -p 10764 | cat

Per-node process memory usage (in MBs) for PID 10764 (stress-ng-vm)
                           Node 0          Node 1          Node 2
    Node 3           Total
                  --------------- --------------- ---------------
--------------- ---------------
Huge                         0.00            0.00            0.00
      0.00            0.00
Heap                         0.00            0.00            0.06
      0.00            0.06
Stack                        0.00            0.00            0.03
      0.00            0.03
Private                      0.00            1.02       307200.75
      0.00       307201.77
----------------  --------------- --------------- ---------------
--------------- ---------------
Total                        0.00            1.02       307200.84
      0.00       307201.86
[root@localhost ~]#

Anton

=D1=81=D0=B1, 3 =D0=BE=D0=BA=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 00:34, Pedr=
o Falcato <pfalcato@suse.de>:
>
> On Fri, Oct 02, 2026 at 09:55:32PM +0300, Anton Gavriliuk wrote:
> > > I'm unfamiliar with Valkey, but you may want to ask how contended tho=
se
> > > pages are if they're actually being used during migration time.
> >
> > > Do you get this same behavior when migrating the same amount of memor=
y
> > > allocated by a toy program? (i.e. known idle pages)
> >
> > I don't think that there is any contention.
> > There is no processing, etc.
> > This is a completely idle test server.
> > I just populated 300GB memory by key-value data store.
> >
> > Even if I use simple stress-ng instead of Valkey,
> >
> > [root@localhost ~]# numactl --cpunodebind=3D0 --preferred=3D0 stress-ng
> > --vm 1 --vm-bytes 300G --vm-hang 0 &
> > [1] 4353
> > [root@localhost ~]# stress-ng: info:  [4353] defaulting to a 1 day run
> > per stressor
> > stress-ng: info:  [4353] dispatching hogs: 1 vm
> > stress-ng: info:  [4355] vm: using 300GB per stressor instance (total
> > 300GB of 6.43TB available memory)
> >
> >
> > [root@localhost ~]# COLUMNS=3D500 numastat -p 4356 | cat
> >
> > Per-node process memory usage (in MBs) for PID 4356 (stress-ng-vm)
> >                            Node 0          Node 1          Node 2
> >     Node 3           Total
> >                   --------------- --------------- ---------------
> > --------------- ---------------
> > Huge                         0.00            0.00            0.00
> >       0.00            0.00
> > Heap                         0.06            0.00            0.00
> >       0.00            0.06
> > Stack                        0.03            0.00            0.00
> >       0.00            0.03
> > Private                 307201.14            0.74            0.00
> >       0.00       307201.88
> > ----------------  --------------- --------------- ---------------
> > --------------- ---------------
> > Total                   307201.23            0.74            0.00
> >       0.00       307201.97
> > [root@localhost ~]# man migratepages
> > [root@localhost ~]# migratepages 4356 0 2
> >
> > I see even slower (System PMM Write) than 1.4 GB/s,
> >
> > |---------------------------------------||-----------------------------=
----------|
> > |--            System DRAM Read Throughput(MB/s):        842.67
> >         --|
> > |--           System DRAM Write Throughput(MB/s):        851.34
> >         --|
> > |--             System PMM Read Throughput(MB/s):        785.27
> >         --|
> > |--            System PMM Write Throughput(MB/s):        804.57
> >         --|
> > |--                 System Read Throughput(MB/s):       1627.94
> >         --|
> > |--                System Write Throughput(MB/s):       1655.91
> >         --|
> > |--               System Memory Throughput(MB/s):       3283.85
> >         --|
> > |---------------------------------------||-----------------------------=
----------|
> >
> >
> > top - 21:49:22 up  4:53,  3 users,  load average: 0.97, 0.78, 0.61
> > Tasks: 774 total, 2 running, 772 sleep, 0 d-sleep, 0 stopped, 0 zombie
> > %Cpu(s):  0.0 us,  1.8 sy,  0.0 ni, 98.2 id,  0.0 wa,  0.0 hi,  0.0 si,=
  0.0 st
> > MiB Mem : 6839822.+total, 6432377.+free, 422358.2 used,    790.2 buff/c=
ache
> > MiB Swap:   8192.0 total,   8192.0 free,      0.0 used. 6417463.+avail =
Mem
> >
> >     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ =
COMMAND
> >    4507 root      20   0    2644   1764   1644 R  99.8   0.0   2:20.63
> > migratepages
> >    1592 root      20   0   82184   5056   3932 S   0.3   0.0   0:07.26
> > irqbalance
> >    4993 root      20   0       0      0      0 I   0.3   0.0   0:00.02
> > kworker/50:0-events
> >    4999 root      20   0   10916   6080   3772 R   0.3   0.0   0:00.03 =
top
> >       1 root      20   0   25528  15488  10484 S   0.0   0.0   0:02.35 =
systemd
> >       2 root      20   0       0      0      0 S   0.0   0.0   0:00.06 =
kthreadd
> >       3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
> > pool_workqueue_release
> >       4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> > kworker/R-rcu_gp
> >       5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> > kworker/R-sync_wq
> >
> > Samples: 26K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> > 21652648047 lost: 0/0 drop: 0/0
> > Overhead  Shared Object                      Symbol
> >   21.77%  [kernel]                           [k] copy_mc_fragile
> >   18.88%  [kernel]                           [k] clear_highpages_kasan_=
tagged
> >   17.81%  [kernel]                           [k] migrate_folio_unmap
> >    2.67%  [kernel]                           [k] __folio_alloc_noprof
> >    2.09%  [kernel]                           [k] smp_call_function_many=
_cond
> >    1.89%  [kernel]                           [k] try_to_migrate_one
> >    1.74%  [kernel]                           [k] folio_migrate_flags
> >    1.69%  [kernel]                           [k] page_vma_mapped_walk
> >    1.14%  [kernel]                           [k] remove_migration_pte
> >    1.01%  [kernel]                           [k] rmqueue_bulk
> >    0.88%  [kernel]                           [k] migrate_folio_move
> >    0.87%  [kernel]                           [k] __mod_memcg_lruvec_sta=
te
> >
> > Samples: 111K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> > 56222244297
> > copy_mc_fragile  /proc/kcore [Percent: local period]
> >    0.00 =E2=94=82      cmpl  $0x8,%edx
> >         =E2=94=82    =E2=86=93 jb    43
> >         =E2=94=82      testl $0x7,%esi
> >    0.03 =E2=94=82    =E2=86=93 je    27
> >         =E2=94=82      movl  %esi,%ecx
> >         =E2=94=82      andl  $0x7,%ecx
> >         =E2=94=82      subl  $0x8,%ecx
> >         =E2=94=82      negl  %ecx
> >         =E2=94=82      subl  %ecx,%edx
> >         =E2=94=8219:   movb  (%rsi),%al
> >         =E2=94=82      movb  %al,(%rdi)
> >         =E2=94=82      incq  %rsi
> >         =E2=94=82      incq  %rdi
> >         =E2=94=82      decl  %ecx
> >         =E2=94=82    =E2=86=91 jne   19
> >         =E2=94=8227:   movl  %edx,%ecx
> >         =E2=94=82      andl  $0x7,%edx
> >         =E2=94=82      shrl  $0x3, %ecx
> >    0.02 =E2=94=82    =E2=86=93 je    43
> >   58.57 =E2=94=8231:   movq  (%rsi),%r8
> >   12.21 =E2=94=82      movq  %r8,(%rdi)
> >    4.22 =E2=94=82      addq  $0x8,%rsi
> >    8.25 =E2=94=82      addq  $0x8,%rdi
> >    0.53 =E2=94=82      decl  %ecx
> >   16.06 =E2=94=82    =E2=86=91 jne   31
> >         =E2=94=8243:   andl  %edx,%edx
> >    0.02 =E2=94=82    =E2=86=93 je    57
> >         =E2=94=82      movl  %edx,%ecx
> >         =E2=94=8249:   movb  (%rsi),%al
> >         =E2=94=82      movb  %al,(%rdi)
> >         =E2=94=82      incq  %rsi
> >         =E2=94=82      incq  %rdi
> >         =E2=94=82      decl  %ecx
> >         =E2=94=82    =E2=86=91 jne   49
> >    0.02 =E2=94=8257:   xorl  %eax,%eax
> >    0.06 =E2=94=82    =E2=86=90 retq
> >         =E2=94=82      int3
> >         =E2=94=82      int3
> >         =E2=94=82      int3
> >         =E2=94=82      int3
> >
> > Samples: 187K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> > 84234492777
> > clear_highpages_kasan_tagged  /proc/kcore [Percent: local period]
> > Percent =E2=94=82      nop
> >    0.03 =E2=94=82      subq 0x1a5067c(%rip),%rdi
> >    0.01 =E2=94=82      movl %esi,%ecx
> >         =E2=94=82      xorl %eax,%eax
> >    0.03 =E2=94=82      sarq $0x6, %rdi
> >         =E2=94=82      shlq $0xc, %rcx
> >    0.03 =E2=94=82      shlq $0xc, %rdi
> >    0.03 =E2=94=82      addq 0x1a50675(%rip),%rdi
> >   99.72 =E2=94=82      rep  stosb   %al, %es:(%rdi)
> >    0.09 =E2=94=82      nop
> >    0.06 =E2=94=82    =E2=86=90 retq
> >         =E2=94=82      int3
> >         =E2=94=82      int3
> >         =E2=94=82      int3
> >         =E2=94=82      int3
> >         =E2=94=82      nop
> >
> > Samples: 223K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> > 88021056491
> > migrate_folio_unmap  /proc/kcore [Percent: local period]
> >    0.04 =E2=94=82       movq   %rdi,%rax
> >         =E2=94=82       movq   %rcx,%rdi
> >         =E2=94=82       movq   %rbx,0x8(%rsp)
> >         =E2=94=82       movq   %rcx,%rbx
> >    0.04 =E2=94=82       movq   %r12,0x18(%rsp)
> >         =E2=94=82       movq   %rsi,%r12
> >         =E2=94=82       movq   %rdx,%rsi
> >         =E2=94=82       movq   %r13,0x20(%rsp)
> >    0.06 =E2=94=82       movq   %rdx,%r13
> >         =E2=94=82       movq   %r14,0x28(%rsp)
> >         =E2=94=82       movl   %r9d,%r14d
> >         =E2=94=82       movq   %r15,0x30(%rsp)
> >    0.05 =E2=94=82       movq   %r8,%r15
> >         =E2=94=82     =E2=86=92 callq  *%rax
> >    0.05 =E2=94=82       testq  %rax,%rax
> >         =E2=94=82     =E2=86=93 je     2e3
> >    0.06 =E2=94=82       movq   %rbp,0x10(%rsp)
> >    0.04 =E2=94=82       movq   %rax,%rbp
> >    0.20 =E2=94=82       movq   %rax,(%r15)
> >    0.07 =E2=94=82       movq   $0x0,0x28(%rax)
> >   97.01 =E2=94=82       lock
> >         =E2=94=82       btsq   $0x0,(%rbx)
>
> ...are the struct pages on the pmem node itself?
>
> --
> Pedro

