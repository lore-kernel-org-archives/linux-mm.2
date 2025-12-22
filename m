Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A140CE66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DCF6B008C; Sun, 21 Dec 2025 19:56:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB3E6B0098; Sun, 21 Dec 2025 19:56:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0ADA6B009B; Sun, 21 Dec 2025 19:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEB7F6B008C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:56:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95D6B13BF33
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:56:19 +0000 (UTC)
X-FDA: 84245290878.06.05537AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31AE0180003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:56:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZplUHLtO;
	spf=pass (imf24.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364977; a=rsa-sha256;
	cv=none;
	b=oqHgEmrmQVrzWzNnQEYEfYHURmgK1ilGlsKIgY4m7A5efVi5caZd2/SXZDiXILHyR7d2s0
	/WrkTNGN/l1cjHl1a6Vb3gIokeiveoCsnrKHFBbObDer4U92gkQ/ITXrIIRMQ3knaWzTvL
	ux9FOh+gCLZ3NYi7t6i4eN6GYUxZRF4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZplUHLtO;
	spf=pass (imf24.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NMCIq06x6X5N8QIPqgKY8o8XY7IL1HTrfa4Xt9yLJw=;
	b=uaF8dNC0lqG0gKbIAjUQiINPN4VuZrMxsJuD+4cfC+GQknjg3+6Be+UN+3iLeCGAUmnC3T
	EwE12yB41XGs316ZBN9ZpwChsfiYNX6jpBSuG+k3vULKh+OQDBp//4FY7KP8pFGvzLVhtC
	tdHtMp0IrWbEqhH09HMCZ1QCH2F0L2A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766364976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NMCIq06x6X5N8QIPqgKY8o8XY7IL1HTrfa4Xt9yLJw=;
	b=ZplUHLtOqNNDaUIAHbuAzTvd/p9PPiJmtwW+J3gMDt0UALkMeo8vymbHYwqAK73sXVdw2Z
	tevkHerQDnRs8FTb2XrOqNL0E1qX82kKz2VCSX84UtOWgRlRKY88qjJy7x8WOCrOdlrVkp
	LcjbHQC5QRY9FAb9Xw/N47CLFZP77Xk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-0hAJbS5gPyCRj7vrQb9-mQ-1; Sun, 21 Dec 2025 19:56:15 -0500
X-MC-Unique: 0hAJbS5gPyCRj7vrQb9-mQ-1
X-Mimecast-MFC-AGG-ID: 0hAJbS5gPyCRj7vrQb9-mQ_1766364974
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b99763210e5so7034250a12.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:56:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364974; x=1766969774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/NMCIq06x6X5N8QIPqgKY8o8XY7IL1HTrfa4Xt9yLJw=;
        b=iWgPmDAWUEPm3ehH1dxggUfsQFgkdAi68QUs4RyhLlns55z/hAoceX6mjQTgARCCTL
         OEQXb561h0DPJlOTGVan8qL4rYprIwcpLVdhe8gD/oHntGImySk+RR1saCWH7sy7iFET
         wPYnoDM7urpv9f7qK98ZnhPscgB3xfZZsqdItIrTFQZNRaeuKBVQeKdWqgblFTZgi3rC
         +3fOhneSshqg5WBJ+1pno/Uryn/bC5m4d5hAbWuK8O6fAGFup+5COGuBObVgx87WRu6M
         yTEqX4iyGcp4ZZuqW31q80C0K7Rm2EBrSGRnoc8FHEk2PwSI2ztDLUeq3wwKAVWN3krg
         k70A==
X-Forwarded-Encrypted: i=1; AJvYcCWwN6y3wac7X9gzCXW2VyiUygr8wlECdUVzIHhnMiT3q8Ov4cfS8td+hrcP+1GRUkXSmVV7KZdt1Q==@kvack.org
X-Gm-Message-State: AOJu0YzeScNuEKZlOCcNzBjWoS2E8L7EBwgMITLRrCvRtE14SBqNR0Yk
	Z1o42AnbCYNwy7McbBm9IfpVsq/uiTME4c/mZlJfYIbTY4pzGpytkVRZhJYrOSgiMJ4w2p5K6tx
	YXPtgms+YO1ssT1E/eVHUipQqsTugJ+ZWkWvkcQDwPVkhoYsUHgxWWZ868rLgmcnJUF2EsaDQqp
	tjTHn7NtB57/Lnc2NeZw40DPcekQA=
X-Gm-Gg: AY/fxX7P76GRfKtjgAU5c29bA8K6Q6DDYYcDq+EFcONRRTfyC42xibh0f5nAEBN0f8O
	mcc7xf5KFd5xQkeZwE2IbZtdwWFTDal8T812szeSFWNkqTlCF57rlZZqvm1WmQTeF3o3btXEoSf
	jQROlHQVq1DyizrVtTM9h2pK80qJ3dQLPqP/8gkvexxSZbD0QrEthbdFIoifJ9MmiQblI=
X-Received: by 2002:a05:7301:fc12:b0:2ae:5fb4:c5f1 with SMTP id 5a478bee46e88-2b05ec8580fmr8756380eec.22.1766364973906;
        Sun, 21 Dec 2025 16:56:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0029GFn24iMMCw3XfWWVMPRTwXTkFaymfwbymZKK/ZbqfRE+pohNx1p4BX0tdPi90xo3sUbGz84BHevp2vwo=
X-Received: by 2002:a05:7301:fc12:b0:2ae:5fb4:c5f1 with SMTP id
 5a478bee46e88-2b05ec8580fmr8756369eec.22.1766364973450; Sun, 21 Dec 2025
 16:56:13 -0800 (PST)
MIME-Version: 1.0
References: <20251221122639.3168038-1-liwang@redhat.com> <20251221122639.3168038-4-liwang@redhat.com>
 <33d5bdc7-0fde-4a97-aa1a-f8565e196ccd@redhat.com>
In-Reply-To: <33d5bdc7-0fde-4a97-aa1a-f8565e196ccd@redhat.com>
From: Li Wang <liwang@redhat.com>
Date: Mon, 22 Dec 2025 08:56:01 +0800
X-Gm-Features: AQt7F2o8rt4dEdkF8DAco4IG4TTUWxg7AyWZZTuM29XF18apL6ox-9F2z5tlIYs
Message-ID: <CAEemH2ehOUyDqHhn5+Mu2B31dCpOhDv6AL7sEFU5Vt7nSST=Tw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: Waiman Long <llong@redhat.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5x5uxCSxwo4lbmh5Aeuh0Fx4HsyJ7qw6bZupQRReUZQ_1766364974
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 31AE0180003
X-Rspamd-Server: rspam04
X-Stat-Signature: 8hh6mbwmzqfn6bz6mwntdeod46f4t1hy
X-HE-Tag: 1766364977-101987
X-HE-Meta: U2FsdGVkX19G1X+zbdMpqF988mS7SkxqU3rxwQ21e6Y8h6UheEBozd4WoTyTzPCwwRTdAYgg93NoIH69O1x5fynGVgOc3uL5tmtC7DkO44cam76Q0HSlyxkmXClqa6E1diwSlGodyTxaXpHsXvPwtlb+qGZhwbGlPYaoSPIbhmC1YkCUPxyR+yNi6lod1fsEYNlhsK30n76nxWdpLhdgNw7KbL8OBdcrZQ43ByJeKegO0XWZ2/SJA/QCTAOhvvAthsTlKOVsv9SobVp3UzcLLmDSIOVearuIlHJ3dcToN4gMfPQ6C82/2SDHqi3NyKYXxYorCwaG53EMi+niiximdbkEjTszvZZhKmUKeoQysHWPzwxj4B6Scg4a/GnNn+vaK7qvmVnQBl6DIKFeLvPY4b350ga9YAGTO7sE8YfapvDI7hN4Ss1JO91KBhvJaIThstVK+fkGEC5kQGhnpQFNUEJQHWO+hL6N5TRILKEczkKmzErSik8kl5PN56dhO1fWPPZRPIQ10x2JYM56j5TXztwphRaKMKC/ei5337/xydxPeAfreHGEi2sH7V9XhjLLtF/mwflk3ko66U9WT63CqMPRzzRrI607QUzphaDfPWEMav6SC22lv9+GLAs+k/BJaW9Jegifay5TR+OQuEVJAjqgy5HQAh5aDd2EVu3WwCGwJzasRpNcr5CecHJZJ7EynUmf0jxESU0Zbgj9WonaV5j9uwJ+ptwunn41/nzgIJ8SDw5dzoL5ATBhMq84ZSNF2sRPp8bTxfhYlpTb/gMXF5QYwdFBeJSadEntIz1asw32NVjSfjYv2HeJn+NU5aqIurACrRBRXQmjj83mTfJMmSVdKxK9ErtndRYtuU89H0ZJ6O+z+42itRwGKfUvrLVpQrfd2ct59ev3xZVrakFaC6t/XIPXMB7jKYWAli3w7YQuM7auZR4ZDi3xZsA8rQJgYqb3I8lNa6g+AjggObf
 f36QttoQ
 +4TQH2w2vz2X8NiV6+x1dBs1FaIyj5KGbp0DLZnJQhEG/clZdzBdITyo0cTHFF+vuwm8dZO2lXD4pH7T5SenWtISHIAfVDY/qDGkMdwM5UT0WAceotAS1hOJuS9wKR6gftLX5oxeJyXjAV7ox6dYm4Zn9I+v0gpYlbMwjdkT78IE5Kzp8VWhD9TlHre7en7x/F6ezk9KU1GNfZboWFN4kh1nGrqBqyfn4fZWt/yHKhbR5zTKf56d3/DeY3UMVWgcM41fRUVNBJMEwvDZUMrAZjwla2wP2v0toBDT2oQqe4LZWqlL4GmULx9oaNs380e5xmj4fV3dqZrnPgljx6xPFzCxe99KvwXfa8+7mMvPvDx5HYkO6uPri6BNO4QW2Sc9QNMOC5va3PV5LK3yKoucPIPxUvCQKpshx9Gudgw+GTUTnbWTiKhGY26yjwb1gkmnuEiaEBvrXM23mgM0pvJpzAwA1ASacB/SxE09rVrmIvgN41lDsbJASx2butyURbZVgn+r4eY7vM8Swk5ecbQMEQ1vqKsXi6HuaGxfD10YT5IgtFssJ3OQDMx1YWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 4:30=E2=80=AFAM Waiman Long <llong@redhat.com> wrot=
e:
>
>
> On 12/21/25 7:26 AM, Li Wang wrote:
> > The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
> > unbounded and could hang forever if the expected cgroup file value neve=
r
> > appears (e.g. due to write_to_hugetlbfs in Error mapping).
> >
> > --- Error log ---
> >    # uname -r
> >    6.12.0-xxx.el10.aarch64+64k
> >
> >    # ls /sys/kernel/mm/hugepages/hugepages-*
> >    hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
> >
> >    #./charge_reserved_hugetlb.sh -cgroup-v2
> >    # -----------------------------------------
> >    ...
> >    # nr hugepages =3D 10
> >    # writing cgroup limit: 5368709120
> >    # writing reseravation limit: 5368709120
> >    ...
> >    # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    ...
> >
> > Introduce a small helper, wait_for_file_value(), and use it for:
> >    - waiting for reservation usage to drop to 0,
> >    - waiting for reservation usage to reach a given size,
> >    - waiting for fault usage to reach a given size.
> >
> > This makes the waits consistent and adds a hard timeout (60 tries with
> > 1s sleep) so the test fails instead of stalling indefinitely.
> >
> > Signed-off-by: Li Wang <liwang@redhat.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: Waiman Long <longman@redhat.com>
> > ---
> >   .../selftests/mm/charge_reserved_hugetlb.sh   | 51 +++++++++++-------=
-
> >   1 file changed, 30 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/to=
ols/testing/selftests/mm/charge_reserved_hugetlb.sh
> > index fa6713892d82..447769657634 100755
> > --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> > +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> > @@ -100,7 +100,7 @@ function setup_cgroup() {
> >     echo writing cgroup limit: "$cgroup_limit"
> >     echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_lim=
it_file
> >
> > -  echo writing reseravation limit: "$reservation_limit"
> > +  echo writing reservation limit: "$reservation_limit"
> >     echo "$reservation_limit" > \
> >       $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
> >
> > @@ -112,41 +112,50 @@ function setup_cgroup() {
> >     fi
> >   }
> >
> > +function wait_for_file_value() {
> > +  local path=3D"$1"
> > +  local expect=3D"$2"
> > +  local max_tries=3D60
> > +
> > +  if [[ ! -r "$path" ]]; then
> > +    echo "ERROR: cannot read '$path', missing or permission denied"
> > +    return 1
> > +  fi
> > +
> > +  for ((i=3D1; i<=3Dmax_tries; i++)); do
> > +    local cur=3D"$(cat "$path")"
> > +    if [[ "$cur" =3D=3D "$expect" ]]; then
> > +      return 0
> > +    fi
> > +    echo "Waiting for $path to become '$expect' (current: '$cur') (try=
 $i/$max_tries)"
> > +    sleep 1
> > +  done
> > +
> > +  echo "ERROR: timeout waiting for $path to become '$expect'"
> > +  return 1
> > +}
> > +
> >   function wait_for_hugetlb_memory_to_get_depleted() {
> >     local cgroup=3D"$1"
> >     local path=3D"$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usa=
ge_file"
> > -  # Wait for hugetlbfs memory to get depleted.
> > -  while [ $(cat $path) !=3D 0 ]; do
> > -    echo Waiting for hugetlb memory to get depleted.
> > -    cat $path
> > -    sleep 0.5
> > -  done
> > +
> > +  wait_for_file_value "$path" "0"
> >   }
> >
> >   function wait_for_hugetlb_memory_to_get_reserved() {
> >     local cgroup=3D"$1"
> >     local size=3D"$2"
> > -
> >     local path=3D"$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usa=
ge_file"
> > -  # Wait for hugetlbfs memory to get written.
> > -  while [ $(cat $path) !=3D $size ]; do
> > -    echo Waiting for hugetlb memory reservation to reach size $size.
> > -    cat $path
> > -    sleep 0.5
> > -  done
> > +
> > +  wait_for_file_value "$path" "$size"
> >   }
> >
> >   function wait_for_hugetlb_memory_to_get_written() {
> >     local cgroup=3D"$1"
> >     local size=3D"$2"
> > -
> >     local path=3D"$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_fil=
e"
> > -  # Wait for hugetlbfs memory to get written.
> > -  while [ $(cat $path) !=3D $size ]; do
> > -    echo Waiting for hugetlb memory to reach size $size.
> > -    cat $path
> > -    sleep 0.5
> > -  done
> > +
> > +  wait_for_file_value "$path" "$size"
> >   }
> >
> >   function write_hugetlbfs_and_get_usage() {
>
> wait_for_file_value() now return 0 onr success and 1 on timeout.
> However, none of the callers of the wait_for_hugetlb_memory* are
> checking their return values and acting accordingly. Are we expecting
> that the test will show failure because the waiting isn't completed or
> should we explicitly exit with ksft_fail (1) value?

Hmm, it seems the test shouldn't exit too early.

As the wait_for_hugetlb_memory* is only trying 60s to examine the file
value, if timeouted, we still need to keep going because the test requires
CLEANUP work and exit/report from there.

The key point of each subtest is to save the '$write_result' value and
examine it
which controls the whole test to exit.

e.g.

This is an intentional error test:

# ./charge_reserved_hugetlb.sh -cgroup-v2
CLEANUP DONE
...
Writing to this path: /mnt/huge/test
Writing this size: 2684354560
Not populating.
Not writing to memory.
Using method=3D0
Shared mapping.
RESERVE mapping.
Allocating using HUGETLBFS.
write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 1/60)
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 2/60)
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 3/60)
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 4/60)
...
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 60/60)
ERROR: timeout waiting for
/sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current to
become '2684354560'
After write:
hugetlb_usage=3D0
reserved_usage=3D0
0
0
Memory charged to hugtlb=3D0
Memory charged to reservation=3D0
expected (2684354560) !=3D actual (0): Reserved memory not charged to
reservation usage.
CLEANUP DONE


--=20
Regards,
Li Wang


