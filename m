Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB6910ED641
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF126B0095; Fri, 27 Mar 2026 05:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0446B0096; Fri, 27 Mar 2026 05:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C65A6B0098; Fri, 27 Mar 2026 05:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58BD56B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:46:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC20413C561
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:46:15 +0000 (UTC)
X-FDA: 84591362310.13.6FE13DC
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3B5618000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:46:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YBK0IM8S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrZNs0MjQhxXBzOfGc7tBO+I03dvigZjrtPot04fzAQ=;
	b=F8AoLATxNc8UePzLMZuIJsGso1fIZ20HZtEIix86ovRKbtUCDk4PmHA+zQa9TWho7qfyn8
	uDkDqNVvsNANEFfGaQvcjBTJfLWpR3NHxOouyo33JSqx8oEp/B4XSPPCG61fu7oKbEIbd6
	kgA1lKGpgS6yXfOvRmoBMy11chJYXOg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774604774; a=rsa-sha256;
	cv=pass;
	b=ymhcdSepJFiveCrLX7vaBeqedDy4Ya6z/Hu9wpMPdrXURBuZ03qMWLwrnbWEMbMg5Vdnks
	BfPKbGk16tBp6kC12E9qbhp4YuUElgY+G7v7AyUion2ht5X+6DDjFdZoqEQLASLrWFhZFJ
	EB6jrVWU6qX6SxZ9YSaAdsCFBpF7ZJc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YBK0IM8S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66a87eb232bso3149521a12.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774604772; cv=none;
        d=google.com; s=arc-20240605;
        b=Qu6tzOSO9lUUEd/2NKgQDN+vCietIiUrQhWw7es0PA5VtcjujFj1AB5e3lMJ5v7mVr
         ewtvINAU9MWp+AZdrbMlJsWqGMDfosjFfz3VsHE2tP/X/GkvPNE1EmES37+fAHJC9gZS
         0tb6Hea0P+SmAL5aqo55Iix0R1fWhKFkFSdgBsq6FxAKxdHKBaMlVSQKjRdbCiMMSJDZ
         p6/hdlRCdSfx256JlPkhC25mYSJQiOM0H2Bx0VID34I6haSdbSx0iP3UgEBTDuHLyoh3
         pjpaCmdPmq0Ky50R20ZZJMz8aDBe/t7wIuFR0OQdP+LP7Kut/jikbkASA+T1yem8DFbH
         rjPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NrZNs0MjQhxXBzOfGc7tBO+I03dvigZjrtPot04fzAQ=;
        fh=a7mEsz5a/nCjo7Te8ORxUAm8lFyvJ1kICVO6UI7Q3hE=;
        b=fKoHkWj826cz/64HcKkYnfBzSDxnxerlW0AeHLQiRrGoYuPfT5AjjG+2NACL7cFmTc
         WSCQfRNhSFS+HxsfLvkZkpQ+8uYvlslQL2hO6q+rOKqEptW9Pzcf3VWbw0x1txqoc1iX
         Qt3Gd3WFyxLSGs8700sKev+OanVDsq9ySpvzGhubt8/fOSejm8/AtOjzq+lqpwItUxlI
         V8otEG4/VM+HjwexMX2fltdjjqfQgT/mj2efFp4RGz8LpdUDk8B8Q9l7y+H+XKbEx1Fq
         L5ynBFVPQ2zgyM2A/wBZu38KG33mteauZQrDrHh0AGFczwfNs13HlyrAwFOrXv8S3/w+
         pM0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774604772; x=1775209572; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrZNs0MjQhxXBzOfGc7tBO+I03dvigZjrtPot04fzAQ=;
        b=YBK0IM8SqCBzLtBOsD2F8ygcP0nMx7QuWtqDYfklCoVVE5YiXDXSuJyxGND0Ghr/ib
         +ZJ/5BlZmg0BzKrFtu6vHyLgaZfIRJ5y9aAFI9rFe/LhXHNIHPx8UGD/D2QkPARy/nT/
         eM3jJJytapisPxunihIALyaGvChE4Nbz/9xiDladrx7xaOc4YgyWolKnSIuedzYOde7c
         xP2VtxAEzidlw66EvNO0xQJk6bgCn9M1Nm0GRofE0U5kiPUEsPSU5g37vlsZzqTmRHoW
         YbxbB3O3VijE+/vu1TGD+Pc0peN2FcmPgU3+DH166AmHJJocUCugBIQonzTV2YbElRX4
         Z7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774604772; x=1775209572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NrZNs0MjQhxXBzOfGc7tBO+I03dvigZjrtPot04fzAQ=;
        b=M71usB8qtKSdTpc7qvDZguyM1Rex4f4E5QUCpWBEvnFXNfb7UMciK2bO074mGKkGhn
         R3hVw/jx0Q7v9EZ/05qv0PURFZ8GbvM9kTnKH/o/ybpF6k9jzXRPElO3WsfTuWY6MWkE
         AAFva001vhM6ZTL3eOOse0tA+A3icsJ53vEgD7klSqu0WUFQSYqT/4NhwfDMizchaihG
         0v4sRfa1oNGs3tn7eVfO324j41XWNDf1uSqrYEYTh5FhVD/EC0W95z6QF/MZ5v5B6U1U
         PyKdAXFBmWCgm36EtILuLkE6Kjk6Eg7vvIeNFiGC5BF/9AAsuF6W7FfUCs7L8mdJPuJ+
         uldw==
X-Forwarded-Encrypted: i=1; AJvYcCWCnI+PentS72HibiRKllnnAGh9SxXLaiYWkURTtR0kBgITVd9s4x32iMmasy0AsOFMftvOoWO95g==@kvack.org
X-Gm-Message-State: AOJu0Yzn5FLj+NA7hY5OhsY9QiQO3rkgqUVa7annvIqhJ6qNNIC19M0M
	9tBJBdovK3ci221n3DWSOqc4qNC5ps2LQ6h6vmDiB0sG122L9k4/CAHIP9slG7UK08gTi6SJsjO
	VVT3fPyyw+rceSTCuzgTl09qSrjevi5E=
X-Gm-Gg: ATEYQzwzIH46MSWrsnLFOfXlBRkcIEdhr8LY7FWNdloc+Ho/wCqHKPYKR9FyHfeQO78
	OtGV6dJ/5yFyQshh1XX+AmrK0C3ByV6G+5buDCI74qFP1eL22+kKbAnPejMmSPu/QBWaSztGIUl
	QQh+AHx2DlCQ/kurdW5XRKiJVDDqJqT1AU2SWCOCAg4qJ6BVuJd4qCFxydDDSXIeSk22UpHzDlR
	9Ii4BYUvTspBb01ZCzlImlrdKEaZolF+GP1Sn90sdg3lcisfeyoMfRYxiAkQK7ObubMbsYgZDoB
	p8EOn1YKjuo0Q61v3zHpOne6oX9eNopnAsu3LdA=
X-Received: by 2002:a05:6402:52cb:b0:66b:19e1:b83a with SMTP id
 4fb4d7f45d1cf-66b28e6aeb6mr1007060a12.25.1774604772007; Fri, 27 Mar 2026
 02:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 27 Mar 2026 17:45:35 +0800
X-Gm-Features: AQROBzDOQL1iTL6NkzRNq1vmvx7I7uQIBlnZChiMf_A01UCWVrCuN1uM8FpwZEE
Message-ID: <CAMgjq7BmZYEp_3bHVCWD696Tx3qAoN8mafKE6M2Z-fTf1hTWAg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E3B5618000F
X-Stat-Signature: 8npxex87qcrbnwsip631sj1zgoawbxkp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774604773-642120
X-HE-Meta: U2FsdGVkX180Uf5GbDatf/4BPbPdt4yo82+56V5uB3LBmT4YH20GUMGOowCTWyr2jHc2xIyN1AldmLI8Yw2+ddyCOMiDgffb+tnkrxHtezcZbpxQt+0wF/eFf6+ZmHG32nA1rxrKhV+xGqYJJZqCMUMqmo4M6Jtx6A+Mz4ptGSkxZZV8vYsSWtzSP24RscVzgQB3g9pFun77VvnctSjlwX9hoj2ZKIiwMQdECMvbvpDaerB3ouWXArwaWNaHQNbW4akEzvSJPYLjJm6HISef6l9QAb36+oNtNHtKHQiUDt0GMCU+H1cN2xf6zLDNjGuanwJsffRZqnkOW/4ReVw7vNJ3WozYe/QXli6hnTTfhoRgfoRZTB5zpGWjex9uQMDq7Cl4IjW0L9WzqGGh2h934lXnYzVKTZwxUFoTO7XeJd8m+ZYfHqM3BNuzqpvqPGQqvpJeoUITmP8FPrefCM5IvSW08USUtcq8hEV+UqQJA65VfMSTH5GO5r7DIXFrI+93k0Mppx2BMIyZRPOQbGQw+os2fPucsbDQ6Mc5n7V1sg6ZGxsWfmsY9K6y38fyCPwV6eixgQLI/TBtnsxyfasakuxO2xGoJpFfYg0MQeHVB0IiDGJImfi+O3uBTod6FbSMIi0CJ2VvALosI4kjHqdR497Q61P65ePT3jjfssHsfJ3+Lq1spV0v/KhILUsQqpWgYPcGmH3NfylzXf+0bIqwRmb1usiUKCdot0y26j/OptiL1rRHlDlsFPf3Y22jaauDgLKNBiQma3WEw5LAkzCIdUUXkxU95wljv659zf2iERCJitHbN/PAL3L3OYWC6fv9XdrRdmEjmzD4J3xT5/l8MLfMWI7HlKqXrTQH0vo6nyOILClhGc/F6CwQGFFfClgHDHy3/TRG/4ak8r7X0JldyrtzBchN206OYarPkSUsqZJYpD5Mr36zx9WKiCL0wS+L93J4GyH+gOwtU8RxJTr
 EQI1Iyql
 uFFMgxJhFQRl/jiBVIBuKDbf+RgpYR7UiPphKih21cRJ9eD1Jv2/sB3QmVVGcZMK1Mj8ANm3xTNKbDc9Em9cKKy0f83IA9re0ko3YT4HRCjeI+xSN9t4kVsOL8lFhpPEosCgnyj3gQxbsomLeToH7tr9pBoGczdTskAn/ql9jvQEBrCqCrtbsvrLGC+q/6eR/b1aDGmDeXhIIPRIfvvDnIkw0Y3Xi1GfCHo7cbNCmwZArWbIR9UqFUcjQLfom/9QOPtOOzLE2qBI9MGtS2FXBSZDzSieSTKmrWPNAw+ckkoWqTtkiLexzGtG2PDlmA2O5/hqNQrDpIzZOUutsk5uzXOsOt0vdki7zXo1F6Ty5Ol5Fch4E8X2GsZwE0NyW7nEV+W1kQW631Cj7cXtcBINvJfoW6X4sj3/c0ZgyYGj/reeVNpV1mMcFAz6gyoTJQlT6rkWf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 8:06=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv=
1.
> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writebac=
k
> on traditional hierarchies").
>
> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> longer attempt to write back filesystem folios through reclaim.
>
> On large memory systems, the flusher may not be able to write back quickl=
y
> enough. Consequently, MGLRU will encounter many folios that are already
> under writeback. Since we cannot reclaim these dirty folios, the system
> may run out of memory and trigger the OOM killer.
>
> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>
> The following test program can easily reproduce the OOM issue. With this =
patch
> applied, the test passes successfully.
>
> $mkdir /sys/fs/cgroup/memory/test
> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> $dd if=3D/dev/zero of=3D/mnt/data.bin bs=3D1M count=3D800
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

I've been testing and based a few patches based on this and it looks
good enough as a bug fix:

Reviewed-by: Kairui Song <kasong@tencent.com>

