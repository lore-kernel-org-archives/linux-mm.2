Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0EDD5B86B
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 19:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C285E6B0088; Mon, 15 Dec 2025 14:42:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7736B0089; Mon, 15 Dec 2025 14:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAAC6B008A; Mon, 15 Dec 2025 14:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDB56B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:42:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33D9D13A29A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:42:48 +0000 (UTC)
X-FDA: 84222728016.14.4110A66
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D18940016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:42:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZQR+XNZy;
	spf=pass (imf12.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765827766; a=rsa-sha256;
	cv=pass;
	b=nMjZdNpZIn6h/HEhJxed3ZxmqVDmLH5LXfBJvqpw1QoECn7fYLWao56Yk4nYyFsCKZ65qE
	h0tF130SfY92K855JnMOSieRHOI0Lc6BGPLuXlHs/cg8ERcCUbGjrOT7KbZpioE3iV4vrz
	+Ibki7fz0V8BXnS1bldB7j34rKCwl6I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZQR+XNZy;
	spf=pass (imf12.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765827766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJK7DebW2Fy4H1zTUhEfN0T6cHVTAmggPb7ftVfboPY=;
	b=2yX6vqN1QYrI3Mi5XzTwdikzi6MCxFlUqHa4VKpMF0PdDw2s92HSwwpk0ttziT+0+6QsKc
	H2adNf22TfEfTdnJfrAzdhCFpRqyl2fUwyYiy8SPDdTuha5a8jxuxqMl1PTxY8o2BEp3pG
	9PyiNLun1V97nyNAGw/O1TPM2KNidrk=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29e7ec26e3dso735ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:42:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765827765; cv=none;
        d=google.com; s=arc-20240605;
        b=Q/g7vGN3NGVoB0b7KUfZBND3W65006mRdWhLs+dMF6nR+KVPTUQof5Qmi2awxngTFb
         +vDenDepg6mo6RbXRHW982uCj1AKaxo7N4kgEO6IEbKML+rQp8F3e+qSl/+3prtn4t/n
         nXNeMV8oY+k1H4gFdG7fDpOMbPA1X28NcuOp1qbQ4s6eKXZSg95PSH9MAkYCLwU5Hgds
         PjqEgWPZ7UqQp8VPb/w1Jx6kiBHjlQnao7sz86MmoGJUkhNIsGAm0KHGcYaEG2DSNtpG
         RUgyT3qvefac4RI7wMGSym51KCDIJ9Eyd1Ge4mlingkLdt4ercN5FV2SLWnshZb8pxcV
         +C+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oJK7DebW2Fy4H1zTUhEfN0T6cHVTAmggPb7ftVfboPY=;
        fh=xBBxv4mc5jdsdSAFGpjtL2l2lbSRDatBObqFauf6NEQ=;
        b=ZOOAH9oCq3HLQD9Q7QsGzNtKtJpXP7ox/KfqGwdlM5DPrNzAXEDVsMmr9Ex0gwdtwg
         SsyPP7DlcEMlkmXDfKqG/1ke3nuEsNwyory2V1OadTyLQsBBtHq8LKl6IOOsTnXwqSlA
         hbVspzv+QHha5EpayJ5r7vvx9WUUJbD7mwNTDxS5Z8mb/DXu1CHivcLZO8BoucttuanQ
         1CCb7z3KK+2D1i4hBquhKwle6D7XSHIYpKDzr9YyLqJIfGd6QhSVAemhWpt5Eh3ean1+
         Pf0ctgkB6hFvoUuKxx6kfdpJoLMGjOdR9JvYHR4uEIcBgY/kU2TVXAlUq8zZVNfsqyJ9
         sOpg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765827765; x=1766432565; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJK7DebW2Fy4H1zTUhEfN0T6cHVTAmggPb7ftVfboPY=;
        b=ZQR+XNZyOkUUuNB53NVthj02fznG0mV9YfKZDqsGlbZ1zSw4DaTDJdsurclTzLPrGf
         mYX3btetqQEC/R82gVTeg0o9C6e2khFA5u04hd6xNOzTZHPy2lIDKMlbDukZo14EVPRS
         +Yb3udUXIm0/thJ0tU171Z7w+yrWP7wkkVuVM+/6s7HDuYsCtUVYhZADUx9RzdjNACJd
         2m5x6tq48BI8mt+YbMrXRTBKx6lpdPgy2CJrVOxGyO3pSHBIyeO3RAFHx0M5XFL5+eEg
         FCg0aOLfN9frdxUyIjFRJghtZVY2AebyvoNlZDm/N6MDxIjhFjASxYFceGpsxQHJrqlC
         Kanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765827765; x=1766432565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oJK7DebW2Fy4H1zTUhEfN0T6cHVTAmggPb7ftVfboPY=;
        b=EHgyLzhtOsCXgnZW7LjLfkYr/puILoUc7QKCs/vEaHZPPSdodStRpfZbEAvzyfcLsK
         PKx1Hiwe/AY2ae29GW8XRVTDUkRM54/Ti6VC37SFroKmNBLbKoHsYLPqZ0MRe7em0FWi
         ZWrP+utU9HzT37UeGhz1895xzH/Zt1Mvs7O6Z4ECF4W76q9JQKo5eQR4s5Znp1oMQ/HH
         DZoRdr8dsK6nJEhp1XpTUjg7DrHE7klp0UqaCU4aT58dfJlkxxphEYf9ihMoFmva2rBs
         h+vzd4/+89fEM+Bxr9M9225Ger70gW+Mn1hEA5JZ1koGZMPebiCI/WYpi7/DuOiws1/k
         VYxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrg869LQ05yMi86kG1e1lZq+D0k4pE6/OQPl6eGpj8NRjyOf8K3QOtQRXv8BUXzAJhpXnd4e870w==@kvack.org
X-Gm-Message-State: AOJu0YwbVh4NHBUTw7cfNPPIqdNG/+UZlZb3MZCpGNjoh6uJ59B2ZwJC
	6AJ2rSXdLF1crC5rU574nJUPbXiMMVhdDKIBjcYcp9GacVchQkxnYc8ZwPWntvfuIt2NUKV4RCI
	3Txq4xTh1Q2xgDdrRtiZFEg6f+PyvVozbfwz/+F7C
X-Gm-Gg: AY/fxX7MRmix2RUy3VspF2nSf5r6IQnA2uuCjUrCr1oU7zASPHcxBR6EKtL/5mJKvxl
	hRR9sYzNtFoKNOUNxjVSJdnSoZbrOk+mQrj5mbhDiYVq3LXbLSExoNgFodnmunh+SFBxl4GZM+J
	i3n4m50gpcPbDcwJMFqd7ICvFw/muvcg0ZbZU1vCXxbDAY44swHiaijFUXq5TrClfjvhc5A2Obq
	Pa4vrrCOKfnQoHpYRKLgQfp42eLZd1azPmR2R2/3JIdskAJc75ccgsjJXu/vWIx4YbQHeO279zM
	bcC8ErdIWgapifsLgElFRNO45467oH0a/Rs=
X-Google-Smtp-Source: AGHT+IG5BDHyj3f8nOxxUUb1eYwpJ7BC0QN/ix6RLqhgk9p3BA3zbnr7NgILF0MS6JoNpUcovSsuDOsA2VYHPWdhwrA=
X-Received: by 2002:a05:7022:7f15:b0:11b:3bc:9ea0 with SMTP id
 a92af1059eb24-120544b2ebdmr49473c88.6.1765827764286; Mon, 15 Dec 2025
 11:42:44 -0800 (PST)
MIME-Version: 1.0
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org> <CADhLXY6tueNOZKqjWEKU697_pTGuLyiTdm48CHRH=W6udmQVZg@mail.gmail.com>
In-Reply-To: <CADhLXY6tueNOZKqjWEKU697_pTGuLyiTdm48CHRH=W6udmQVZg@mail.gmail.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Mon, 15 Dec 2025 13:42:27 -0600
X-Gm-Features: AQt7F2oJG_PXhnv2L1oncG6hSJByNGD4tm197lwEoGidCrs03HCRsY34HgGkKuA
Message-ID: <CAJj2-QHV09Rh+s2AgDtC815YUJUnYgTs0EE9YbDvXdPM9DsKug@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, axelrasmussen@google.com, 
	weixugc@google.com, david@kernel.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, yuzhao@google.com, heftig@archlinux.org, 
	oleksandr@natalenko.name, bgeffon@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D18940016
X-Rspamd-Server: rspam04
X-Stat-Signature: fpr47cssfwsf5kratbcge7pbisgcg9dd
X-HE-Tag: 1765827765-481368
X-HE-Meta: U2FsdGVkX1+M0z2PkpS7KJLU7o5N7gyje2hbphQExgNsp5hVeisDYBSs88bndrZVY8u8fJvHm/pKQYCglDvi+IGfnSU83JHhv94buRvL6gX3Y0SK+sWjPxBOVjj1brQWO4u5HadEJ0ILrYrc272dKGDPFX+cH1I8FuUFcjw2Sf9By41k/Y+CZQOyzQptGYuQnHH9dSO5DT8td86CUSwEtySbMzsasnTSKazDaDImrbKQ7RLfbS4Qzx0XEw9IFpdXFoKEawt0dR08KV6QqKgjrP4IIDVZeXKL1FWhc//5SF4Ma4R/FHmvHoyoiKsq4CftnU/4vAOlkYPZWo600N42NCQ/GMsl3CknLZLJWUMkiYz2+5fwlvZ+qgghHSScQpkh2yW9tbRVOTzHXVAsWHH6DQAygzW1MzhOfJHJIXHKxjNmDlSGdds9C9oQd4gB9A/09O/EdM4Yni3JCZrmDDfimSmEMmsAQq48brSiB4SG3VvEs+ptH70D20Odu6FpD/HVEtwCWrvctQCh7CVLtFnmQsfRApsXkP3HU2bwMHy0g6GMKaWyX7w4yHCCW75/jHMGoYLnNoyeixBu5S+BX67qV3L6glsCfF5/E04uhxShH+N3JseQa+LlX9bTPQf0sNluTsv9E8HwqzW/6zXLBDkZ2idiIoY+2WAYjCe2RJXWJUshrTLgIuNv2YY10u56ZgqJkhUt+rbFirNxXtJkoeRLosCoEPlvJvIwo9hcpsr2LAmAheU5H07D2uN8IM7deGmNNwArRlOt7J00CQg2lnMVbM8RqzCFUql1ib4X777iBrt8WKaNNTH/B88VWDP/0sWmErUDpC9nbgmMPxkeNP/RA04MGHsaq7m8yRL+SEV6zRpb9glVErsvzPc7vLufLEczwl1wE1XyAZhc8o7uYiiJx4kgWcb22kozd+uk9z++yUoKjNiayfmK1jlAwbY7qca+WTxlD+hy8EDoNDGeXLh
 ZF3lrzmP
 pZtkJIrc5kw5FZYrBkUQmhzvrujf7p4Ge4yTYzMK+GWTREwKcWNfEjLdlEH92OQ1R4LkRjkYJb+phAPPFKYFXbf/ICxOKcTGrAMQoOWA5MLZDhdsZ9coZRo7Rk4JK7FbbrxeGy8BQSlD+NbOzPq1xdLOEPHAl8IvYEqmasTb6jDlkNc2caySP1h+NlF1efCFM3H6KvwbgGhzW0/6S9rP7fQjl/QW8C5hXxT+9FaEvUJH76vj02mpcarXkPyhvcf+IBOigNLgFpo/e7JAjpPvEV1jG//K4SN96LNqTxYtgUAyLl6fuejpz51A4o+Qd6uOmHOsotzubqGWJdLbYS5ED/6OY5EkQRHcgpv+ACBBf6/iK1/5xPzFyi89ycOdD3xaCC1yST5T+TmelCQaLZdF9tt2iage5HkhFtfE615qOcs30tt5bfHUXYJ/v3U+aw0Naksr64VCYSPvU4ji+6rMu4z9y8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 10:52=E2=80=AFPM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> On Mon, Dec 15, 2025 at 9:42=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
>
> > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> >
> > That seems unrelated?
>
> Sorry for the wrong fixes. Correct  Fixes: ee814fe23daf ("mm: vmscan:
> clean up struct scan_control")
>
> I'll wait for input from someone with MGLRU context on the broader discus=
sion.
>
This warning came from commit e9d4e1ee7880 ("mm: multi-gen LRU:
clarify scan_control flags") [1].

The original rationale:
> 4. sc->may_writepage and sc->may_unmap, which indicates opportunistic
>   reclaim, are rejected, since unmapped clean folios are already
>   prioritized. Scanning for more of them is likely futile and can
>   cause high reclaim latency when there is a large number of memcgs.

As far as I can tell this was a sanity check to ensure
`lru_gen_shrink_lruvec` avoids extra work for minimal gain. Perhaps
this shouldn't be a warning? Always setting may_writepage in this case
would free more folios. I'm not against removing the warning either.

@Wei Xu @Axel Rasmussen  Any opinions?

[1] https://lore.kernel.org/all/20221222041905.2431096-8-yuzhao@google.com/=
T/#u

