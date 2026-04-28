Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E7EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 18:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2426B0005; Tue, 28 Apr 2026 14:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D0B6B008A; Tue, 28 Apr 2026 14:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54C26B008C; Tue, 28 Apr 2026 14:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE4956B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:55:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B29D8B911
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:55:28 +0000 (UTC)
X-FDA: 84708867936.01.EE20203
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 33B60180002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:55:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dWgp+dOx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777402526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9HctQvghZ+DCMWiCXiDqE5/SyrSB6mkl5c9yO+0fuU=;
	b=ZY5jK/mz6zXLqPSnPTQ4/pmd5zE2eS39Lo/2MT2mCFoklS4OUOqEqmjg6ScajOiXOxDmde
	Qhc31N3i9xSx7tp4Xya1VEy28XnNBlPIpF64AhIMK9Fr5roDINmR+cpnI713f9gVWjwKDh
	lqzoddC+gpy06zZen2rbdNRSt5edpAk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777402526; a=rsa-sha256;
	cv=pass;
	b=gk7ge8AM7KKcnbam8wyLPPAx+JOwMjC+1zvP2ft+RRnXohYH+KNy67vOi/92nR2rT0PNcY
	IWUgy5yqldvthHGa/Gs0gaq2xdx/g1lIEBQp+8tHjmwvpCeF2XQuyXiOuO7JnP2dxQuoFE
	tk5D+pMgzcuVvJGs+u3DuqTI9kq0CP8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dWgp+dOx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-672c12e95e9so16502843a12.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777402524; cv=none;
        d=google.com; s=arc-20240605;
        b=VL1xgKqYHFH25PKsX6wr+9aQQfEvVJD/HKqQu32BcCgSPyTDL+CRdkZSk3Hj8V/wIl
         +AqBElRL3OXvrWZR6pxToyhyYltSGfutaSCqEDnRFBmdzYcpWDbl1TNXTAWW1RQCpPAj
         pQjpEk0IPXmbbW6KZxydwNlz3+7gPaGjY8HtBecpN9EAnqPUzIxE2ii7u1Z+09myHWmE
         6oHpYDxCeeX/pdPE/UP5rvTrOeaKFEmsZk3J/Gl2sWXQuq5B6fO5UxauN6k9XRwnUq8u
         3NRbLzfrTqrg2SAFa6KdGPmGFV4ISoLyYHgMMFir/S8wr6gQLXNLLughmihLkF0Enft9
         Wp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9HctQvghZ+DCMWiCXiDqE5/SyrSB6mkl5c9yO+0fuU=;
        fh=LZYYIKJqME1X8J/OcWEQYTPzjVHHTfDlstgW9zVZs7I=;
        b=ISDmr8j2enBgtn71HiamJAx3dzsm2itaYbCSmYFhvq4yulPJ/wRhs2HhWkUZd07eOk
         KkaWrWvHv1i8PbE+FclgM0Aia0LHonJh/E8tLjccKQWS79INHY/8rzrCdfWaYOqQBorp
         npPlfaer5PAT/XwQK4ibWnuKHnSGgnK9CDxpxn3yXvxJ2C2rp5EIyukcB9HKLtoZ7YRc
         gAoGrqJbIkWn2AlnWr8Oqln3N8DlyqcQUY93M4DOJLJE+Ra1DZADNhYzBEgKgg00sSbg
         meAF8TIQn2V+dCRU6fT23yqflm5nFrefYUpfwQymHCIwfzz3MR4lxgbrW/zl9eqWQXaf
         H60g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777402524; x=1778007324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9HctQvghZ+DCMWiCXiDqE5/SyrSB6mkl5c9yO+0fuU=;
        b=dWgp+dOxKWrfsyEmJWOOwIyArD1t8+Q6Ys3WtlWHuWcSeij+bXyhA+fES8CdrzzR1L
         uz4VP9HKmLWBjFQydqLPmQq7aUkt/JZ9pCb6LSuURR8V5iSBqNbiL4Ldt8Csya6Eiuq8
         c502ahJwHPtSzQDhJiF8ZeOJP7dkPBmdU8jc/aVLXnhtIECurW4Yan4UWV7TmbmRLqvQ
         /11ZGr/FrMlfs9849zB3rGuJwG9DzT9eSpdF8ibTjIBQyYO5VJzgPbX6/DGIlQTCIEmZ
         YKDhkacKu51PBj57S1dTvVX3liR2X/7V2RutDzai2hQ4A3WlzSRLwOVem60Kg0R/j174
         z+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777402524; x=1778007324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H9HctQvghZ+DCMWiCXiDqE5/SyrSB6mkl5c9yO+0fuU=;
        b=bjReAtgS+atoMyaZIjmStTAgCtebYgAXgEhz8SYIh8xx2EgjvoNEVJG+eVbCHbEgz8
         mYwPjxpgNQO1zXJynd3Db9vg+uZR05DIRxDEI0S7g0UdqRkwwRGww4EXLxH8GnLUHpGz
         75FyVtqvYmkblet4Zs4Mjg0O+gisi/+QfWYyobL0OlvzEKjCho5XgASDHwdWhpytqhi6
         MKWsU4YOZmFQumAfmCCKht9rELpnyQsElbZN6vXmuXIPxO7Xe+GhYasWnQX9w4m67IXj
         YuXrehKbrtj0XG/IqCSYgKS/YpJ3AF2RJCTpE60ZOdj14USDxlX8qr43D3nlkH2kRnhK
         tnoA==
X-Forwarded-Encrypted: i=1; AFNElJ/a4sMM/7yob4vIs/zWPQJpPeJXq+sWE7EnUCrvVJlSRBi62F9BuUzKmIPbmdXMMen7Ng4RWRLRQA==@kvack.org
X-Gm-Message-State: AOJu0YzygqXts44gk1pVxpY5KpO2msNtrfmgttIWAWGe1jf4gAjB3QWA
	pWIYfbCFssWBuffSxQf8ZtfZsILrjjbqc1ebUAcqRAXOuAbQalj3ZxldSueWB9XtQB+uyezURxc
	NmHjjflBS8af12w8ZrECSTZDSVxlsIms=
X-Gm-Gg: AeBDietR29ASnXjW1mi4qlxA96DPkbkhmhWvsUFbPZMuCR1j91iy77/eW1szwKI/ZzN
	QBS+na5SKvmbNQq5Cia0gMVsjHn3jiXkxsby/qoQgO2oBmKDlcVjGyigjbUnNyUfTf09qmGIJsD
	yvr63vRxprv85uD+vzjaqe/fKkleg0vvLD99QnlV9cXGUNwV8mjgL0i+w0MVqYQJM70sN5WsjcG
	gMI5gcSp8128X/ONknhWG5PF4WI7YsdG0t/ggkisgrLiG4YWE+Rbsqlo8c7jT5stZbhM6WZc7B8
	LmS4GD2VozBrfvnmWxs67RgnzW1WWLqablNA856NxxbcRS1rGty/OSh2mQYMSg==
X-Received: by 2002:a05:6402:2b98:b0:674:e53b:f27f with SMTP id
 4fb4d7f45d1cf-679bb05a722mr2276549a12.11.1777402524344; Tue, 28 Apr 2026
 11:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org>
In-Reply-To: <20260418120233.7162-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Apr 2026 02:54:47 +0800
X-Gm-Features: AVHnY4Ioc_H8NflpZETiW3jE_6ryKGTeZhw1Odcn-aUd74MnaFCBs5Rn7JpQ0gw
Message-ID: <CAMgjq7D5M6ru4bP0EsNmyODnnAoPcpa4GSB79=Gs4EUabzsgXw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 33B60180002
X-Rspamd-Server: rspam04
X-Stat-Signature: sja6i6z3tdmbaf51rykxe693qa5di8dk
X-HE-Tag: 1777402525-310147
X-HE-Meta: U2FsdGVkX187iyJJjxkMzkYUhkvfrK9ibmozQyMKJ/3B6kY3cOopA5ldJ4nEDiAaYr+DRos2xHBVn0ce0fzcdFCXxA3JP+g3fKi2x0wDUongu/k9p1Ugr8hwvAPx8/IdOfaOi1L4gFqXoUa46/llwlG5DOM96jERPdJmbPjaA0irrjNNGQ9Wh3ChSb1pp4CI5X/iNr2XGbR7Umx1kc0g/b+okHh5+F8t+eoC0ssc65HhZDtCUYQvyjqRHTJsLZ7BhVn01zGe3A68fx1wLQcA1X/o7BPGZTR0KoOotv5UZ+FcsVY5ndfwCV8t1vFOfP8ih6RAcwtFE+DGpCMZZCJZ1QG+GU9pxq0DlpjkGQUFZw2QEdsuDL1l5bYOwA4mApeb8IRuLuc2fZzLflIZK9tu5hQDFsjlahb7wxKIIEB+q79QZ3qn46WpxyE6bIFR16bWrPYkvUOzKhKoag9DnfPzW+scTWRxZD/vxLS5NTVOizlQ4JmKd++2pkRyQUJHVOa0U8z5VynAxKn4bBu8LsBIgTUQ+jym7oggkt5GxL6Q3+uQ/XBiT+D4/wVMjpWz6rlpSzSSSKnBUzT6cX8ax9HBAy/dFlIg4sBwXPXR/efSbKy9+pNlFSQTIUg/zs06U5OMMV8Qt0rTKRWGLRtFojGJHNYHyH3giEQrw68RT9aSDOq8jTf4FgYdGtI8IHM1F4ER3xKFdt3G+K78rnbfL5bT3inT+Y+SM59c2XmQagFb+jjEu+K8tH3YdYzHXSNypCM455Uv+bWgzmly/wOZ8yyRYFD0QYL+qWAv2yfMMpCDxrhorS9CvcZI0WVdB/ER5HxRR6ZDRtV4LUm348C5csUN65xTU5HDyOET9PceCnejTYQshCbFmSF9HR2cHHk87v7XYirEWA0O79J7juP+0z2ckTJtZQ08HFo22klJIoqZqfFIMccscI504+1oY5T+O0c33KKlqeWuSyY+oz6092K
 rRnkSjSc
 URCgwPMtWE9WyrEl0V+Mz5lKSBBi688KcCd9M23197GUkwacHHpZcKKZwNkvqIr+vMTRlyyj5EGvfk5x42RlvzWBVL8v4X/qqoKYuBj7wumy+lxG3RJ00xrTiwTIG21Xl0nwYKi23KBvsrzSRsRDiM/n3w9SYry0UoAKQAFgcn7PLSEPwUBP1wpgCPUaA/ZEzcn1rTrzANY5TlemhUxfteIbyjvOYJZ1GfnwdijMi1Y2QxaWBr++72DhXWJUE6qCsczT2P0JM5PWOg4oGaLABrTbnSQfUS2E9PC95086y+i2poTinGpifbNdd0BVCOjwR3P+Sbl1y5IZh+ObwWkqrXbeC68uVJxrt5nOIB/LYTMb4qlM572Sy4QMo/OFevdvuzxyp1De5f46vLcy7spXhD1/5pzVvhhsQIwH2JV1lJL99MmaJLB0fpQ8m9IxOrm/dxfncz6W4x0NitWeFGNhAXa5ocb3VrB35ZxZF+LqE7Y0lNl6qmKTUgbjH4c03u4oKQz8AyfZ39YjmeCcR9YsM++W5jlOp++mBjjur2ukxE64+UKnisYUWjHTm6pASj+9WfCnT23ntzjxMUatMl+N1Dgy7giJfs/MHX5/yEDyDe3D7Elg/A77cZYGVg/FFHtskMG80KPGY5gH28AyFwPP0GtM1jRDMVquYSDM2UsNmQgcK/9fkjkPAMq3SkqemqYAB5hB5LZySjIODT4Ge0IW8hbNwUJje9VKQxuZwyLVyjNDJ1nqNGb3d/FKUr0tkcvtLAkL1NnSgj1qsMtaShD4qt021jJVYketuqRqDHm29JJ1wDtTYTWMqJyKnyxro+EZXEtFnjOkbzR2xSuJezAxh6a0+zKjDjuQe5qRWyTNPng7XbDYLIEiP18hshnROBV9C3uEtbZL+AE4US1LjpJrA8vmj7NVhwjiWpxCTOoaHAXqvWBP9SWg7Wc9BT4twvUX3EolMZF4XAim4bE0bShYBZ0/Kj/GQ
 KyUDUhAJ
 N0lX6se+EF7mQbJCDL6zpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 8:03=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> MGLRU gives high priority to folios mapped in page tables.
> As a result, folio_set_active() is invoked for all folios
> read during page faults. In practice, however, readahead
> can bring in many folios that are never accessed via page
> tables.
>
> A previous attempt by Lei Liu proposed introducing a separate
> LRU for readahead[1] to make readahead pages easier to reclaim,
> but that approach is likely over-engineered.
>
> Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> protection"), folios with PG_active were always placed in
> the youngest generation, leading to over-protection and
> increased refaults. After that commit, PG_active folios
> are placed in the second youngest generation, which is
> still too optimistic given the presence of readahead. In
> contrast, the classic active/inactive scheme is more
> conservative.
>
> This patch switches to folio_mark_accessed(). If
> folio_check_references() later detects referenced PTEs,
> the folio will be promoted based on the reference flag
> set by folio_mark_accessed().
>
> The following uses a simple model to demonstrate why the current
> code is not ideal. It runs fio-3.42 in a memcg, reading a file in a
> strided pattern=E2=80=944KB every 64KB=E2=80=94to simulate prefaulted pag=
es that may
> not be accessed.
>
>  #!/bin/bash
>
>  CG_NAME=3D"mglru_verify_test"
>  CG_PATH=3D"/sys/fs/cgroup/$CG_NAME"
>  MEM_LIMIT=3D"400M"
>  HOT_SIZE=3D"600M"
>
>  # 1. Environment Setup
>  sudo rmdir "$CG_PATH" 2>/dev/null
>  sudo mkdir -p "$CG_PATH"
>  sudo chown -R $USER:$USER "$CG_PATH"
>  echo "$MEM_LIMIT" > "$CG_PATH/memory.max"
>
>  # 2. Prepare Data Files
>  dd if=3D/dev/urandom of=3Dhot_data.bin bs=3D1M count=3D600 conv=3Dnotrun=
c 2>/dev/null
>  sync
>  echo 3 > /proc/sys/vm/drop_caches
>
>  # 3. Start Workload (Working Set)
>  (
>      echo $BASHPID > "$CG_PATH/cgroup.procs"
>      exec ./fio-3.42 --name=3Dhot_ws --rw=3Dread --bs=3D4K --size=3D$HOT_=
SIZE --runtime=3D600 \
>           --zonemode=3Dstrided --zonesize=3D4K --zonerange=3D64K \
>          --time_based --direct=3D0 --filename=3Dhot_data.bin --ioengine=
=3Dmmap \
>           --fadvise_hint=3D0 --group_reporting --numjobs=3D1 > fio.stats
>  ) &
>  WORKLOAD_PID=3D$!
>
>  # 4. Waiting for hot data to warm up
>  sleep 30
>  BASE_FILE=3D$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | aw=
k '{print $2}')
>
>  # 5. Running workload for 60second
>  sleep 60
>
>  # 6. Report refault and IO bandwidth
>  FINAL_FILE=3D$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | a=
wk '{print $2}')
>  FINAL_D_FILE=3D$((FINAL_FILE - BASE_FILE))
>  echo "File Refault Delta is $FINAL_D_FILE"
>
>  kill $WORKLOAD_PID 2>/dev/null
>  sleep 2
>  grep -E "READ|WRITE" fio.stats \
>  | awk '{for(i=3D1;i<=3DNF;i++){if($i ~ /^bw=3D/) bw=3D$i; if($i ~ /^io=
=3D/) io=3D$i} print $1, bw, io}'
>  rm -f hot_data.bin fio.stats
>
> Without the patch, we observed 12883855 file refaults and a very low
> bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy
> hot positions, continuously pushing out the real working set and
> causing incorrect reclaim. With the patch, we observed 0 refaults
> and bandwidth increased to 5078 MiB/s.
>
> Note that this patch does not benefit any platform other than arm64,
> since commit 315d09bf30c2 ("Revert "mm: make faultaround produce old
> ptes"") reverted the change that made prefault PTEs =E2=80=9Cold=E2=80=9D=
, after it
> was identified as the cause of a ~6% regression in UnixBench on x86.
> This was due to reports that x86 uses an internal microfault mechanism
> for HW AF. The hardware access flag mechanism is relatively expensive
> and can lead to a ~6% UnixBench regression when prefaulted PTEs are
> not marked young directly in the page fault path, especially when
> UnixBench runs without any memory pressure[2].
>
> Thanks to Will for raising this for arm64=E2=80=94=E2=80=9CCreate =E2=80=
=98old=E2=80=99 PTEs for
> faultaround mappings on arm64 with hardware access flag=E2=80=9D [3].
> This is also thanks to arm64 microarchitectures, which incur zero cost
> for HW AF handling.
>
> It may be time for x86 and other architectures to revisit
> whether HW AF is truly costly on their platforms, given that
> the original x86 regression was reported 10 years ago.
>
> For those who want to try the model on x86, you will need the
> following in arch/x86/include/asm/pgtable.h.
>
>  #define arch_wants_old_prefaulted_pte arch_wants_old_prefaulted_pte
>  static inline bool arch_wants_old_prefaulted_pte(void)
>  {
>         return true;
>  }
>
> Lance and Xueyuan made a huge contribution to this patch
> through testing. They truly worked over weekends and after
> work hours. If this patch deserves any credit, it belongs to
> them.
>
> [1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@=
vivo.com/
> [2] https://lore.kernel.org/lkml/20160606022724.GA26227@yexl-desktop/
> [3] https://lore.kernel.org/lkml/20210120173612.20913-1-will@kernel.org/
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: wangzicheng <wangzicheng@honor.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lei Liu <liulei.rjpt@vivo.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  -rfc was:
>  [PATCH RFC] mm/mglru: lazily activate folios while folios are really map=
ped
>  https://lore.kernel.org/linux-mm/20260225212642.15219-1-21cnbao@gmail.co=
m/
>
>  mm/swap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de987..e3cf703ccb89 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
>         /* see the comment in lru_gen_folio_seq() */
>         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
>             lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> -               folio_set_active(folio);
> +               folio_mark_accessed(folio);

Hi Barry,

Sorry I haven't checked everything yet, but just a naive idea: What if
we just remove this whole lru_gen_* check chunk here? Only keep the
one in workingset.c to do the folio_set_active so refaulted folios are
promoted like classical LRU, I have a series to restore the refault
distance based activation for MGLRU:
https://lwn.net/Articles/945266/

That series from me above is a bit buggy, but easy to fix, I can
resend it. Some workload benefits a lot from it, like the one in the
cover letter. And the latest MGLRU is still not performing well with
these workloads.

Is there any evidence that folios that are allocated through fault are
always frequently used folios? Because classical LRU has the exact
opposite assumption on that. Refault distance based activation is more
battle tested (I'm not saying that is absolutely right though).

Will the performance be worse or better if we remove this activation
here, and instead only do the activation through folio_mark_accessed
(not right now, see below), page table walk, and refauting distance
checking?

Oh and, right now MGLRU performance badly on some workload because
folio_mark_accessed never activate a folio, which can also be fixed
with:
https://github.com/ryncsn/linux/blob/b4/mglru-lfu/mm/swap.c#L393 (I
hope I can sent it out as RFC if I can finish the benchmark and
tweaking before LSFMM but sorry for now I'll just share this link...)

This is the LSFMMBPF topic idea I proposed, there folio_mark_accessed
calls folio_inc_lru_refs which will promote the folio for exact one
gen if the access count goes beyond LRU_REFS_MAX, making MGLRU
frequence aware and much more proactive on certain workloads. Testing
with YCSB on the server and using that on my phone are both looking
great.

It also remove the force protection on eviction path (that "if (refs +
workingset !=3D BIT(LRU_REFS_WIDTH) + 1)" check, which is added about a
year or two later after the first MGLRU release), that force
protection is causing trouble too cause some cold folios with high
historical access count will stuck in LRU for a bit longer.

In general I think it might be a good idea to weaken or maybe just
remove this activation here. Need some time to discuss and verify
though.

