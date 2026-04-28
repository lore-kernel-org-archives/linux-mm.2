Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C42FFF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 22:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F63A6B00B1; Tue, 28 Apr 2026 18:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE786B00B3; Tue, 28 Apr 2026 18:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCFE6B00B5; Tue, 28 Apr 2026 18:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3351C6B00B1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:26:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC14AC1696
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:26:52 +0000 (UTC)
X-FDA: 84709400664.10.8447B64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B519340008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:26:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jxU9D3Wz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777415210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lx4eU+DKA+jwMEBJiXY20ka/7pMvc08kWLmasNqfFR8=;
	b=4/c79KQ/oOE65wMTqG6aKntr1c/QLnwE3eajecWOqxVxCDF9C6VdR2dXG8iKvJvx0tVmDG
	vHrP9GkQqZzCmjv9FEO9uKwpiWQ54ZW0L88uVhVRy/LnXhbF0ydhm/y6kvPRwCKKmEfMrI
	DElkiWBm4E9rkeP6rEiVezqcqyK1V/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777415210; a=rsa-sha256;
	cv=none;
	b=SmLuybxQ9GSkgJXzAuCjD3fjH25b+3Scwo18XdYsTbmF3hDF4JH7REeIzosviYU5W0p7cp
	MSr613LRV065aYczwKqK1l7BS8xktPjCwNvYlcF4+vCw+MevB2Oz9nEPUGPVUTPqvHmWEx
	9MzAn9dkIdWIkrcaypUlNhtK5zEs5XE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jxU9D3Wz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74EED44310
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5550BC2BCF6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777415209;
	bh=aGBgcfkpJIn1mZUGK0H6N0CE6H7uX4eNAuxwDVkfptk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jxU9D3WzDXEh5SrzUxrigumbsy/wtd28xHMlvJJxaP72zxrHUfIaPgU5xZVfEg/U6
	 Jg7zXyTqDVk5VONFqJ3FJyB8K03Se5MJdq4u7v3BONF3/pEhuSmgiJ6/SImOZVt1g1
	 mXNyaTffE6Itk/7YjHwu6SQYVqfCsJZ/shrvLHAW+tDUt8gadrRkb4aYhx5wZHx+Om
	 AgtmQhOPqO1Mbi+y4ERw/A6vlhI9vhB7mmv5KVNo5Y2r/oQOqvIAe4h8qs3ugCTwYp
	 YBnSfXTek7Pud/AuWoiRHBHl1M9mgWTG6l1tu5AVsrg9Qg/FoOIVyljrEXj+utRTFt
	 gtN219WLjgfHw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89f87257904so98400296d6.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:26:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+ZI4iM8Gkf/uwgnIsfgPGFI2iXvetWOlrChzBgjDEVyVQm7VmVMfbXMXBXu7hbagSRryyBD8EV4Q==@kvack.org
X-Gm-Message-State: AOJu0YzI9hQM5h9Ux0Da7nTLySRCDVkgRgX/RVUBU1sJ0FWSg534tMtl
	R3sHdT+P+ZSpRCrfhm/f187oXIoF3bZxHlJu6Alezu+VX5ntxdvhNDuGfR6oqMlfLt1St8im5zb
	pWZP+Q1tH38FYeQO7o2ORneKW1oyPPVk=
X-Received: by 2002:a05:6214:262e:b0:8ac:800f:10d8 with SMTP id
 6a1803df08f44-8b3edc82e4emr25442176d6.3.1777415208477; Tue, 28 Apr 2026
 15:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <CAMgjq7D5M6ru4bP0EsNmyODnnAoPcpa4GSB79=Gs4EUabzsgXw@mail.gmail.com>
In-Reply-To: <CAMgjq7D5M6ru4bP0EsNmyODnnAoPcpa4GSB79=Gs4EUabzsgXw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Apr 2026 06:26:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wsde+xZDBysLFBFHvkoJbM07b5tWS-rvXn9x9+m24s3g@mail.gmail.com>
X-Gm-Features: AVHnY4JTYf1SLkpLyyFGkQrHxxVJIdabrF2uIk_hbWcGRF89SMBzzOghTGQ-kdE
Message-ID: <CAGsJ_4wsde+xZDBysLFBFHvkoJbM07b5tWS-rvXn9x9+m24s3g@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B519340008
X-Stat-Signature: mhbkzy4qsf7iwjt1dttz69p65tq4tgmg
X-Rspam-User: 
X-HE-Tag: 1777415210-63595
X-HE-Meta: U2FsdGVkX193TBIQShFtwqdR+/+0sIcTedpbD7crCUX+xR/kw8nmaoyE2iX+80ggexnHDaVX72LJ1oBJSQj46MDQbD12J4jctdKP+BE8kB8a/8hKZhWo+ADU4ZBJb8V8ZvNeh4750sQluzJ/H+ElVa0rSWK3cD/nvkE7EvZi5O493n5XAb9yH+huBoZFL7in2N8HFZQQWLW4dXznkqnSp682RCvov+v0cAzSuRSJnA3BNnr3cl/AWktRz3GQFCHnmbKdzOgOx1Lsl8kmSpliovVJk4LkPTBUO1IPG+aG1iqj03bP/CV+TW2mlVM9ocMIcHmtK5pbDz7Zh6G6AQlblmSbjZzOn+JVirzNegx8t2TcMTfFCeA2Mc+kstiEQLSbuBGNeB5nNGYcKg6zd8chgpYWnIWKPINHRJmsGSOVuhGjth2X8nA8HOlcNWcEwxXxdYIlbCtP41+UEsSTj/aMWdCeo+VC8I+IXt5VE8GJBaCeP6hXTpTURlt4Jp4F9wUKAhJPCUnToZlLzJQrTS25dEx3oowytlE/c1u60u4oxYX+z/rbJDUhig1Q6qVoHeQZQTqXsrI1crEOoUcC9vx9p45nRD5ofLW2FKv385LxIbkMBqprj/zFqMSVFfHm/Dk6Bf72S7DNZtbLzioJsNeSJyBiNLrEIZk1SdMUYshbPLvVPQrAFlg4cTBSblrXuLmBVnoJfsTGROuw1I8tumm7Oz9+ddJZgwOopsCEbKa3wfSOZM/3J5dPuxKhq6ex/9rA3hijCEZEKTLF3ODoUziTcZmRNqMyIf3ZtparucHSvX18K/POui1OALcZ6MhKFR0Ho3+BrefbSlDPO6uoHmeklMkham4y/sIkAkji7xznbleq6ez3SBlNTs8WbDDmS1Fzetz+8uUBoyWIFlidU1irlIQROHZQwviSRqkhgnKmz6tnze2qSIg38AwDcwXdIF+apQnquPKq+N5hjTkXkeM
 6T/hGD2r
 Oe+c+mzKDBqYejilAZLHr3t8jkrgy6mz5rI/x0/HqdqQo8cV5RsyGB1D7OlZA0LZf2QzKmFXpymH9QINyTbxDqr5N9cNAmBlDAQacYOTltfyB/03iXo1yGi/+1nmIz7KQ8Xg6eZnjfGBA375x99vLD+mP4U6+E/F9xR5iFAvpmw5XUm2PCGuT15LvgGMDkxuH8l1a45AwjspFXkdr4hSllw5ViHgXPwQFCIdlJ4vcjuc/MalaBxqN+RQLhh5dOgg6mlpeP8Y756Vl/IbY5FF5K3hBHWDlyFZUBbrkIH1FfOarMGphIflw3n7Eg9zGbcSJOCwOpd+C1Gq23/BJ5VP+rghZ0wyQQInieoKaG/NWFuC02rk9mYzTRZiU2sjqH/dRCR1Wfb7kP7EpxP6wT8sReDD72rh26UbYyBfKQphaYiVhbiePm8qZcr9KqQNtuBk7yF1nJlCoJxDw8Y0PMXt9qMT84hUV9CT9jBmsKYDZaJwUkb/BBXfc1OnX8p8Srnib1/yaKKp260bC2AqzOHuzEY1zu7lZ3yIqRSp2TTpRmJHg2emVqIiIWFZqC+FznkTG0FU8SrRMcgeTZDQHQO4rpU2kReUWdnlj7u0BLRol218V1iq6FNlakfqZ15gheTdBLOSuZTVIBYE90il7uezlDqfG8Mt7fF2RoEwuE7lL3k1wj4YRrARQmjjUukt/zQd9sKyfixfgHidrlAbRK4vwQO8Jz2wQLRU6boerQC8Ck7lvCZkvuxhLx7KCEtIcn1SvPqH+B1ZKpCO6HF+M7tyI3O5cwGWvnaYNHEjR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 2:55=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Apr 18, 2026 at 8:03=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > MGLRU gives high priority to folios mapped in page tables.
> > As a result, folio_set_active() is invoked for all folios
> > read during page faults. In practice, however, readahead
> > can bring in many folios that are never accessed via page
> > tables.
> >
> > A previous attempt by Lei Liu proposed introducing a separate
> > LRU for readahead[1] to make readahead pages easier to reclaim,
> > but that approach is likely over-engineered.
> >
> > Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> > protection"), folios with PG_active were always placed in
> > the youngest generation, leading to over-protection and
> > increased refaults. After that commit, PG_active folios
> > are placed in the second youngest generation, which is
> > still too optimistic given the presence of readahead. In
> > contrast, the classic active/inactive scheme is more
> > conservative.
> >
> > This patch switches to folio_mark_accessed(). If
> > folio_check_references() later detects referenced PTEs,
> > the folio will be promoted based on the reference flag
> > set by folio_mark_accessed().
> >
> > The following uses a simple model to demonstrate why the current
> > code is not ideal. It runs fio-3.42 in a memcg, reading a file in a
> > strided pattern=E2=80=944KB every 64KB=E2=80=94to simulate prefaulted p=
ages that may
> > not be accessed.
> >
> >  #!/bin/bash
> >
> >  CG_NAME=3D"mglru_verify_test"
> >  CG_PATH=3D"/sys/fs/cgroup/$CG_NAME"
> >  MEM_LIMIT=3D"400M"
> >  HOT_SIZE=3D"600M"
> >
> >  # 1. Environment Setup
> >  sudo rmdir "$CG_PATH" 2>/dev/null
> >  sudo mkdir -p "$CG_PATH"
> >  sudo chown -R $USER:$USER "$CG_PATH"
> >  echo "$MEM_LIMIT" > "$CG_PATH/memory.max"
> >
> >  # 2. Prepare Data Files
> >  dd if=3D/dev/urandom of=3Dhot_data.bin bs=3D1M count=3D600 conv=3Dnotr=
unc 2>/dev/null
> >  sync
> >  echo 3 > /proc/sys/vm/drop_caches
> >
> >  # 3. Start Workload (Working Set)
> >  (
> >      echo $BASHPID > "$CG_PATH/cgroup.procs"
> >      exec ./fio-3.42 --name=3Dhot_ws --rw=3Dread --bs=3D4K --size=3D$HO=
T_SIZE --runtime=3D600 \
> >           --zonemode=3Dstrided --zonesize=3D4K --zonerange=3D64K \
> >          --time_based --direct=3D0 --filename=3Dhot_data.bin --ioengine=
=3Dmmap \
> >           --fadvise_hint=3D0 --group_reporting --numjobs=3D1 > fio.stat=
s
> >  ) &
> >  WORKLOAD_PID=3D$!
> >
> >  # 4. Waiting for hot data to warm up
> >  sleep 30
> >  BASE_FILE=3D$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | =
awk '{print $2}')
> >
> >  # 5. Running workload for 60second
> >  sleep 60
> >
> >  # 6. Report refault and IO bandwidth
> >  FINAL_FILE=3D$(grep "workingset_refault_file" "$CG_PATH/memory.stat" |=
 awk '{print $2}')
> >  FINAL_D_FILE=3D$((FINAL_FILE - BASE_FILE))
> >  echo "File Refault Delta is $FINAL_D_FILE"
> >
> >  kill $WORKLOAD_PID 2>/dev/null
> >  sleep 2
> >  grep -E "READ|WRITE" fio.stats \
> >  | awk '{for(i=3D1;i<=3DNF;i++){if($i ~ /^bw=3D/) bw=3D$i; if($i ~ /^io=
=3D/) io=3D$i} print $1, bw, io}'
> >  rm -f hot_data.bin fio.stats
> >
> > Without the patch, we observed 12883855 file refaults and a very low
> > bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy
> > hot positions, continuously pushing out the real working set and
> > causing incorrect reclaim. With the patch, we observed 0 refaults
> > and bandwidth increased to 5078 MiB/s.
> >
> > Note that this patch does not benefit any platform other than arm64,
> > since commit 315d09bf30c2 ("Revert "mm: make faultaround produce old
> > ptes"") reverted the change that made prefault PTEs =E2=80=9Cold=E2=80=
=9D, after it
> > was identified as the cause of a ~6% regression in UnixBench on x86.
> > This was due to reports that x86 uses an internal microfault mechanism
> > for HW AF. The hardware access flag mechanism is relatively expensive
> > and can lead to a ~6% UnixBench regression when prefaulted PTEs are
> > not marked young directly in the page fault path, especially when
> > UnixBench runs without any memory pressure[2].
> >
> > Thanks to Will for raising this for arm64=E2=80=94=E2=80=9CCreate =E2=
=80=98old=E2=80=99 PTEs for
> > faultaround mappings on arm64 with hardware access flag=E2=80=9D [3].
> > This is also thanks to arm64 microarchitectures, which incur zero cost
> > for HW AF handling.
> >
> > It may be time for x86 and other architectures to revisit
> > whether HW AF is truly costly on their platforms, given that
> > the original x86 regression was reported 10 years ago.
> >
> > For those who want to try the model on x86, you will need the
> > following in arch/x86/include/asm/pgtable.h.
> >
> >  #define arch_wants_old_prefaulted_pte arch_wants_old_prefaulted_pte
> >  static inline bool arch_wants_old_prefaulted_pte(void)
> >  {
> >         return true;
> >  }
> >
> > Lance and Xueyuan made a huge contribution to this patch
> > through testing. They truly worked over weekends and after
> > work hours. If this patch deserves any credit, it belongs to
> > them.
> >
> > [1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjp=
t@vivo.com/
> > [2] https://lore.kernel.org/lkml/20160606022724.GA26227@yexl-desktop/
> > [3] https://lore.kernel.org/lkml/20210120173612.20913-1-will@kernel.org=
/
> > Tested-by: Lance Yang <lance.yang@linux.dev>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Cc: Kairui Song <kasong@tencent.com>
> > Cc: Qi Zheng <qi.zheng@linux.dev>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: wangzicheng <wangzicheng@honor.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Lei Liu <liulei.rjpt@vivo.com>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: Yuanchu Xie <yuanchu@google.com>
> > Cc: Wei Xu <weixugc@google.com>
> > Cc: Will Deacon <will@kernel.org>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  -rfc was:
> >  [PATCH RFC] mm/mglru: lazily activate folios while folios are really m=
apped
> >  https://lore.kernel.org/linux-mm/20260225212642.15219-1-21cnbao@gmail.=
com/
> >
> >  mm/swap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 5cc44f0de987..e3cf703ccb89 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
> >         /* see the comment in lru_gen_folio_seq() */
> >         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> >             lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> > -               folio_set_active(folio);
> > +               folio_mark_accessed(folio);
>
> Hi Barry,
>
> Sorry I haven't checked everything yet, but just a naive idea: What if
> we just remove this whole lru_gen_* check chunk here? Only keep the

Do you mean the below?

index 5cc44f0de987..499ad49c1b51 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -509,11 +509,6 @@ void folio_add_lru(struct folio *folio)
                        folio_test_unevictable(folio), folio);
        VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);

-       /* see the comment in lru_gen_folio_seq() */
-       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-               folio_set_active(folio);
-
        folio_batch_add_and_move(folio, lru_add);
 }
 EXPORT_SYMBOL(folio_add_lru);

If so, this essentially resembles the active/inactive LRU. But I
assume Yu Zhao=E2=80=99s earlier point about mmaped folio access still
has some merit? The problem, however, is that readahead and
prefaulting may have made this assumption less accurate, since
being mmaped doesn=E2=80=99t necessarily mean the user actually wants
to access it.

Dropping folio_mark_accessed(), we would need two scans to
confirm a mmaped folio is active. This seems reasonable to me
on platforms other than arm64, since they always set access
flags for prefaulted folios. The first scan would clear the
prefaulted access flag (which is fake), and the second scan
would confirm that the folio was actually accessed.

But for arm64, it seems we might slightly negatively impact PTE-mapped
folios?

I mean, I=E2=80=99m at least convinced the following might be correct:

@@ -509,10 +511,14 @@ void folio_add_lru(struct folio *folio)
                        folio_test_unevictable(folio), folio);
        VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);

-       /* see the comment in lru_gen_folio_seq() */
-       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-               folio_set_active(folio);
+       /*
+        * For architectures without old prefaulted PTEs, we need a first
+        * PTE scan to clear the access flag set during prefault, and a sec=
ond
+        * scan to confirm the folio is active. For architectures with old
+        * prefaulted PTEs, we can skip the scan that clears the access fla=
g.
+        */
+       if (arch_wants_old_prefaulted_pte())
+               folio_mark_accessed(folio);

        folio_batch_add_and_move(folio, lru_add);
 }

It could also be the case below to check whether fault_around is
disabled, if it=E2=80=99s not too ugly :-)

+       if (arch_wants_old_prefaulted_pte() || fault_around_bytes =3D=3D PA=
GE_SIZE)
+               folio_mark_accessed(folio);

I suspect the above code also fixes the fio workload performance I posted i=
n the
changelog for x86. Let me queue it for testing.

BTW, it seems we can also fix set_pte_range(). The prefault check
feels quite useless to me=E2=80=94just let folio_referenced do one extra
scan.

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..bee58a8fee0a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5593,13 +5593,12 @@ void set_pte_range(struct vm_fault *vmf,
struct folio *folio,
 {
        struct vm_area_struct *vma =3D vmf->vma;
        bool write =3D vmf->flags & FAULT_FLAG_WRITE;
-       bool prefault =3D !in_range(vmf->address, addr, nr * PAGE_SIZE);
        pte_t entry;

        flush_icache_pages(vma, page, nr);
        entry =3D mk_pte(page, vma->vm_page_prot);

-       if (prefault && arch_wants_old_prefaulted_pte())
+       if (arch_wants_old_prefaulted_pte())
                entry =3D pte_mkold(entry);
        else
                entry =3D pte_sw_mkyoung(entry);


> one in workingset.c to do the folio_set_active so refaulted folios are
> promoted like classical LRU, I have a series to restore the refault
> distance based activation for MGLRU:
> https://lwn.net/Articles/945266/
>
> That series from me above is a bit buggy, but easy to fix, I can
> resend it. Some workload benefits a lot from it, like the one in the
> cover letter. And the latest MGLRU is still not performing well with
> these workloads.
>
> Is there any evidence that folios that are allocated through fault are
> always frequently used folios? Because classical LRU has the exact
> opposite assumption on that. Refault distance based activation is more
> battle tested (I'm not saying that is absolutely right though).

I agree with this. I=E2=80=99m also queuing some code for testing
to check whether reclamation has occurred very recently.
If so, we set the folios active:
https://lore.kernel.org/linux-mm/20260428013520.47417-1-baohua@kernel.org/

So basically we=E2=80=99re on the same page, just taking slightly different
approaches to checking recency during refault?

>
> Will the performance be worse or better if we remove this activation
> here, and instead only do the activation through folio_mark_accessed
> (not right now, see below), page table walk, and refauting distance
> checking?
>

As explained above, I think it is probably sensible to remove the
chunk for x86, but not for arm64.

> Oh and, right now MGLRU performance badly on some workload because
> folio_mark_accessed never activate a folio, which can also be fixed
> with:
> https://github.com/ryncsn/linux/blob/b4/mglru-lfu/mm/swap.c#L393 (I
> hope I can sent it out as RFC if I can finish the benchmark and
> tweaking before LSFMM but sorry for now I'll just share this link...)

Thanks, I=E2=80=99d be glad to read it once you post the RFC.

>
> This is the LSFMMBPF topic idea I proposed, there folio_mark_accessed
> calls folio_inc_lru_refs which will promote the folio for exact one
> gen if the access count goes beyond LRU_REFS_MAX, making MGLRU
> frequence aware and much more proactive on certain workloads. Testing
> with YCSB on the server and using that on my phone are both looking
> great.
>
> It also remove the force protection on eviction path (that "if (refs +
> workingset !=3D BIT(LRU_REFS_WIDTH) + 1)" check, which is added about a
> year or two later after the first MGLRU release), that force
> protection is causing trouble too cause some cold folios with high
> historical access count will stuck in LRU for a bit longer.
>
> In general I think it might be a good idea to weaken or maybe just
> remove this activation here. Need some time to discuss and verify
> though.

Yep, many thanks for your points.

Thanks
Barry

