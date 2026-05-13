Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3EDCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8139A6B0005; Tue, 12 May 2026 23:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA786B008A; Tue, 12 May 2026 23:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700FE6B008C; Tue, 12 May 2026 23:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCB76B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:58:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E5FC1206EC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:58:42 +0000 (UTC)
X-FDA: 84761040084.15.9E6B330
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0342D4000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:58:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gMni2HnV;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778644720; a=rsa-sha256;
	cv=pass;
	b=k6OfYrN7HVyRssmE/M81jOmj6/ZeztZkhHWq3uRzgjAUJ0+NKnu/pSqrB+4HuUoA6Uw7UA
	iDcWK6TotGgHWlTNHuZvC7QXqmr7tzPUk2wt55SsvFcia4BnPqR3n00g6TAkFDDe2lC0+v
	mC9zSYSGKNn3BMlF4fU0SbGUopqNEw4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gMni2HnV;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778644720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40b0mj9LccqvykOYFJDhNVL9/cfh3wCIRjlfxH+VtLQ=;
	b=qJvud1zFF5bWGhmptOxEGxOgxgGHTwMTqTaKgOFd89OV5gfyfMcHeVRi0Ubgufrm7Tq/pd
	1/kSWt8UNvwgh+rnTq1wnowBJBLrLZT3PPY99708Ud2C6vT2ez0i8Xew4yWXVXfOUFhUyx
	SrCpDSCo/9YvzePECgb0vEFS8PWyfCo=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so91a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 20:58:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778644718; cv=none;
        d=google.com; s=arc-20240605;
        b=TQTufX2pZmSTKxd1Gs2/NhTD4U/dNWcHu1gCSXEDhFUzT80Rl6irf3m+hqIjZETgWj
         ACW7AVQqkqnnsnxStDOBioMVblgb6qs93y4GpDV6unh3EA8drlYZUscPvi1kTFX+Gkq+
         aLMqZFfAHu2wi0Y6WtxJwUbWz8Ptbxtees0kZ1ByfCSe25oTCSt2bz/PbfBRzrOsK4uW
         903DXJbBH8pE1DT981MO/vxxr9jp7nbksAhhs/s70wCLfa7qQmtNXORmkQKKNw3N+MnT
         CkjMeZPlVZqrC7o8oRE9xqtwHxPaX2MmTTPs49f2Sdx/7SebKVQympRZ8RF+UgnSpDL4
         2fBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=40b0mj9LccqvykOYFJDhNVL9/cfh3wCIRjlfxH+VtLQ=;
        fh=RHcqNDEY9YE0LWaq4Un2bJZA32BwXEOJhYt6qoOSBuI=;
        b=IGS7iecJtnnso+WF72I7oLE06OWGI1Dhko9xFTw4q0tBVrMXaX/cMG8FyI+yBq5tzI
         oXPQCUWrg+WJ2OOJYWyBRhgUuQ2x/WJ4HehmzRuZ5SeKiqd+3B1NUsAj7QJe1n0iwBUi
         ncNpFa9F4zQi3qauQKCE84r31WyoU2Kx+waHd6cXhRVQlcTz1tfb2HglMsiNzZgeEG1K
         OouJLJp+pwmnla+K8cTImPDAwQYbHOhFY/ord+9HVbuyXzq6F2PEDKs/0cuEi70r7BdF
         LnT9XgDCdP6Z6EEtxxxj+rk8lvscgNWJHwJNdjpWCGB15HrkX8kmBpVMk3QiVc5f68rq
         N3JQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778644718; x=1779249518; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40b0mj9LccqvykOYFJDhNVL9/cfh3wCIRjlfxH+VtLQ=;
        b=gMni2HnVOR19WJe9+pqqoHVTDjL9eF5XnqFHw49zjaqEcfHHcDMYGw3PSqd8yG4t+G
         ZAJgr605Z7QjUJvjhqdr9S7NDvDzbS64hAVAjiXlPjaugigxKj+LKeTVFFYaZHF9Q1xM
         ufM0q8LS4RxQ91+apEswjirUkn7r24SD62TSvPjh8PwBwxsXaoorz6atxOcrivMJNEpR
         zAqzrl/o93viSx05uJV/Mcj1NrLGtrBq/dyV1c5rUeUJM3oaB0YAnmPqbVufAgWpJh4v
         yHhcwjCrwVFlQT9kKX/mTgwyh68XMyU7/fBD0epqiCA3qOYpHcRi0odcuumpF1xTdh9L
         IIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778644718; x=1779249518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=40b0mj9LccqvykOYFJDhNVL9/cfh3wCIRjlfxH+VtLQ=;
        b=UjJJs5ghgA/lWqcTWYiqG5Id2ItBZJAkIrj1QHF+MZYtXiVEaFlWOJrtNHFSaW8X0L
         aeFBE40m9C8sur9dPt3XZR2cKiJwlVEFKU2J6dJAk2E7aYykeB724sBdFTyQW3boBihk
         M6emsSGYAgVuYDW8nqJpecCRWTGvtzUUK8kTECbytnF6hNFp1TsTN2i8zeUBU9KjzCyr
         E6MwN/rjYoT1qVl+SlQJYmvviFyrfRbX45vf6SBUYr6W2gtK/boDIwmlOx/7Dbl4K7Z7
         So8BHRQaA6nmhLw32nNi3pabFTkGX6yM7gk50V44fMm0U8Fl1ymbEcnJc0erwCr0BfSD
         /VQg==
X-Forwarded-Encrypted: i=1; AFNElJ9N6/PNla423352JgyP0KUhXa8N5AMF9Ap7tn5GvMSOTR6zCQAR4v5Kbh9aL6V5rmTiO57n392EFQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/eyHxh0carAv+IioqB0mO5XePMxjcl0QYtEjqWMOl1LIhSye3
	5x4yYieVtc/RJrUWGe3fy25RiJNuaBxRyL4mJ3Nc2Eb/Hw6Q8dbODNDJ/hjgve0MuQMaJj8WIQU
	oUuHv2CaQNsk9Bd8jdIeN75kl3EjPE4NHleYILpAE
X-Gm-Gg: Acq92OEedJP6voYz56HEfszxZ2Vl9O/SOrk9ExWBSAHYGsWNkoY57pnjqfTn53TlBjC
	s0/Wt90PGWKelosmaHPlxBygFUjF+TRReXvjQbu3qBsASP83DrsWi8MrQ4q0/XWKUloatL55g+U
	CVbfQu11I541hFm4iQJo9Ql7bNnFqqCgawN2zT7p9JGrF1j4quXFPwd7cPJg2anKAsTRaKMl6Y0
	Vb1//NiPBoEjYlMCnVZirQiHdr10lBFC6izMZxMhh1lujk+AKfp9Hdv3B3GrPAuzPFraqh+eB8E
	Ry3Ad/Mp4A1kphLn
X-Received: by 2002:a05:6402:5050:b0:676:67ec:abaf with SMTP id
 4fb4d7f45d1cf-6827bf5f4b3mr22466a12.3.1778644718024; Tue, 12 May 2026
 20:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com> <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
In-Reply-To: <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 12 May 2026 20:58:23 -0700
X-Gm-Features: AVHnY4JDQcNVWDMwH3pin_nHYobX8urPy4XDY6wH_-41pJ7n237CNfSG2kbeWQ8
Message-ID: <CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 46md5osbhaejfg4s1oysq3cnw5jgqbb4
X-Rspam-User: 
X-Rspamd-Queue-Id: 0342D4000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778644719-892455
X-HE-Meta: U2FsdGVkX1+xr0Nv9Wyfs/UvjNhiaYZQvmg9H5ymHeierEAM7jS0LUWjg2NsYAwQwhdpMSZ39hhS+n8SCPJjo4GQiW4YmAOkxKNqwMzBHS76lhKUA/k8sJWJhAKU6/99zTZUOKtTqDTK1RtQxOywb7BT2TUugJamPW16SoCu6awcN4bZTpzATXpyLftPKJsfsxPthL/2mcIl3E4TKTbXFAmij1ulUpmDCRzhVkOzZxeK/YQ2GO5egf1mc5sZKBuh72iWORM5zVKBdoxBKTZqhS9NUJXdy9tznF+84h2rm93Qnig0IweMl4xezgwv6arMOIu26RuUsm4Fs+GEkpH2B74O8ZbAV5sYuKeNMoMZnFSQmypXeD7x6VfEFV3qFeXYmsag8sU/r6jCdypLvwYpdryxjUE4VYj8oB+xfefjV77AsyFfDSxwQwrJZUOb6D6EGy84j3oTj9klp/ygF2jiRFZVzcFLYLsiVTaFtTbZ124PON/T/mOrnEJloYaNlR1vEjLeZIlmVKimbplYGhOAwXBm1wT/4V7wZ1uO1gos530pV/pV9h5BGdKCEB73VSa5FuCXDjIbw30H880o4N012zCp9+7pI+WOIsOsTmiSXJua1C5CQ4QW0HfppCMFsRKqPdZNIdI84FX+LlOHd87gRLaKPP2Qr5cF57/ZFE4dV8s+R7tU1y3nz+b/lfbSySZlmW9VelQQEZnrtXd3N9O7Zu28Yac+JFHtwV7PaaXOjMHvWaNHVlIoraUwEZYYLn0itsJLfkIT4QMoQKvxz1PBR+Id420OLckj4Nx4OdTfFHpIzcUm5Y2Q7DZu9tp72Hu4DlM3+b195mCo3kGnWpswXiBj8C2g+gtQVsk3Mi46FzXIXXueQXPyUdtibFDqlXoK6jkW6pLPBSMsrsmiNnZ/BlHUJUX9fOoEt3UjCdTlQQh+XUq/pI0orOJRLW4rohcP8G2QyxMoOf/Cd705hPq
 rUKvEDTd
 6SG7pR8UezFhLMTyTTF5o2vxRIuXuhd3z2TS7QZYqpVzczIxc8ZdEkh28WjaHqOowPx9Fgob2G4vGUT+m9NwBxMTVyyk6e6J71+f0MP6Cuz5gtMQy8qC2zeVJOIt8TgGkDmXVr/G2IfoTexitlB6nSSciNXJJ/QhBuR+3baieujd6gImgMIZSwMvRzoV3jDyRS5bL3DmhbHUVIAEtimARfokeJiw1y2J4x1fyPio2QcWBU54jEqajColHohT3C5YQQpQSbZwhiw18TwzZLPvbHLH4WUCfecvEOzXiNi1RB8/V6gsYCkGFqOmNZf259Xfs2ipjSgiQytcRPpuYE+4qehy3JOeEgaZxZbFwCmePXcftsykYey+gFzmLyoxa+HCtBbSs/VLiPD/nLebnSe9hX4I2wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 2:28=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/26/26 08:27, Suren Baghdasaryan wrote:
> > Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
> > similar to /proc/pid/maps to reduce contention on central mmap_lock. On=
e
> > major difference between maps and smaps/numa_maps reading is that the
> > latter executes page table walk which can't be done under RCU due to a
> > possibility of sleeping. Therefore we drop RCU read lock before this wa=
lk
> > while keeping the VMA locked. After the walk we retake RCU read lock,
> > reset VMA iterator and proceed with the next VMA.
>
> With many small VMAs, is that overhead noticable?

It might be but the point of this patchset (and the previous one that
made a similar change for /proc/pid/maps) is to reduce mmap_lock
contention, not to speed up the read operation, which is not a
performance critical part. The original problem that Paul McKenney
described and which kicked these series of changes is that a
low-priority monitoring process reading /proc/pid/{maps|smaps|...} can
block a high-priority updates by holding the mmap_lock. You can see
details about this problem and the numbers Paul obtained with the
previous change in here:
https://lore.kernel.org/all/20250719182854.3166724-1-surenb@google.com/

>
> --
> Cheers,
>
> David

