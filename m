Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25472C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4378E0008; Thu, 28 Aug 2025 08:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC108E0001; Thu, 28 Aug 2025 08:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B808E0008; Thu, 28 Aug 2025 08:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3645E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:11:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C508A16013F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:11:35 +0000 (UTC)
X-FDA: 83826051750.20.27B7871
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6A24E18000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:11:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqiFCK55;
	spf=pass (imf24.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756383093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UGqflFI8eChQOA7+GEyiXkR47jGjc2vCRu3os6QQyo=;
	b=yzj07Hxz9iE1IUKlUzEnFkI65XjjgUHZosP2DOJcoJC+j5H4e2AQnFouV7MbpkWdqu2UUy
	FjA0UtO9PrsYNcsEOegK4UrR3/sOm4VSJuNUlrifvW2Lb3Y25p9wKCb9PKFbDNoXX5V+XL
	Z1Z+5YMx71LaNAwDpXbjFwhD+tIvwz8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqiFCK55;
	spf=pass (imf24.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756383093; a=rsa-sha256;
	cv=none;
	b=8FIpCS+KYULp4JSfOg6l4rahQYA/siI0n+g/qjcOQxo9/82ht4R5bsv+RAANiA+u9ZynoZ
	ci7m6ORspJo4EhMnJ0vHORKTlLnUTvDPm+ASi48cSV2VgRNinKRJoCSTWudgNOuX/0OzQa
	lynCdQ2w8s44gh+RD/4vUFwZd7inAE4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756383092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2UGqflFI8eChQOA7+GEyiXkR47jGjc2vCRu3os6QQyo=;
	b=RqiFCK55xQ3Jm/wvajwYwQjgzNFaA7s7iLPZC6dDj3HWhaWm1pxjuRvPr7Pl5eC3cZRBxw
	CKG8O765B28Scexey72stgNX9xjUZnZZxUTMdK+0JVxelNDuv8+wqyz79p29xbFbP6RIuB
	VULPrx9RjhUEynqAHKEsCarymxvM1FU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-TX7kTYfvMCKjnpoJqa0SSw-1; Thu, 28 Aug 2025 08:11:30 -0400
X-MC-Unique: TX7kTYfvMCKjnpoJqa0SSw-1
X-Mimecast-MFC-AGG-ID: TX7kTYfvMCKjnpoJqa0SSw_1756383089
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b49ddcdd5e9so1258812a12.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756383089; x=1756987889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2UGqflFI8eChQOA7+GEyiXkR47jGjc2vCRu3os6QQyo=;
        b=UMW4cU+Pc+NrNTFfUsWsrkNhjKKpScWq1oR355CX7Ifgie01Ju3G0/nnLLFzyRh8Ki
         fwhN+JgnyWxMn89s8YezeNqD6GayZ44TlNPOQSQEY4nSi7wBCpsfhOHHWxWLhVri3zyx
         izkcMr0OHFQo9lPh6C4vCktIXQ63/RLaoMTIbLQdHaK/hIaMgts2Ofwofa+XMaJZvKzS
         XTnJu7zttrvikC4jbiSrHH6xWnB666biPtbZkaJ5DdnH2yDc/KPcaEUlNYVYbubAeP9C
         UZ/FVkRiwGdZre279Bgsa+z03sOqdsApeWWllviqm+Paovrfa316mzsOv5XZwOHh71sw
         UJ3w==
X-Forwarded-Encrypted: i=1; AJvYcCV0lwGPkNsP/ov/XXKQi1ysE2XoeZbU7OehNsaj0D2UsdCY/HD7OM5D85+6WeJCM2dmxSF4J5pwjA==@kvack.org
X-Gm-Message-State: AOJu0YyHtIIRTKMOPLIVVGJj3PnaQMVzHtADHtvwk3r9VFRbDeHgbgP3
	C+tY7sb2lJIPyM4Ufkm7qPGM5cZfHNEg62enZdcCgkdoVbD/CRAdysRqJ/0Vt7FZTbXTWglBKI8
	GcTXGw3tr7E9stwXOikqGtT2ri3E0P/P9nj3CxH5bowpsiCO5OTQaUwQ/gd0wRfhd7KOkL2dk+S
	bw3zj+82BFaP7n05y2y/XQrB4b3WQ=
X-Gm-Gg: ASbGncsm7oj6vF+JOsc38kLHJe+qqQ8pq8AHWTe4fCujBshjE50h8mQVySmSaOjucMU
	VmAsH1oRoCD2O1tuDsudB+ee3Dhz/rRCIldulbIrUOjm9mW40QyTIzzUeW/z8YWhwistltwEIRy
	MclJhOyfX2JnhLzaAVlrzA4Q==
X-Received: by 2002:a17:90b:4ec7:b0:31f:42e8:a896 with SMTP id 98e67ed59e1d1-32518b8233amr27589473a91.34.1756383088811;
        Thu, 28 Aug 2025 05:11:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/1VuJO7sOj+w9DbBPxn7h7VRP4y4KKuh9IZVK6bmCJgpn+KrmoXKNVFrzEshD5AQ6z5yFNiOU64bGtA72s9Y=
X-Received: by 2002:a17:90b:4ec7:b0:31f:42e8:a896 with SMTP id
 98e67ed59e1d1-32518b8233amr27589439a91.34.1756383088324; Thu, 28 Aug 2025
 05:11:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250827075209.2347015-1-chuhu@redhat.com> <20250827075209.2347015-2-chuhu@redhat.com>
 <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
In-Reply-To: <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
From: Chunyu Hu <chuhu@redhat.com>
Date: Thu, 28 Aug 2025 20:11:17 +0800
X-Gm-Features: Ac12FXy5i29Lv7D_Qeef2pLLf4cwbU_o5j8qeJDX_02H1KqJvRXEd1sgycpMGA0
Message-ID: <CAKJHmxy_zT7kT5mz85OAbThcjYHHKoMRNwkdh8m+i94keQR2BQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/mm: fix hugepages cleanup too early
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dpoy1dslymMHblxrq73r4lPsaukWwnXU5oav915atyA_1756383089
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sxg6f8mxkmrdimk6jbezpzmk6yyyarbu
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A24E18000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756383093-18333
X-HE-Meta: U2FsdGVkX180pqnhklM7npGvBmsEjo5RpsK3dnQcVep7OqAIj1239hwDkIErjl1A1xfu62CAYPo9cQhHHDPi53UckIYL3M89VVnH2fEejAEqqrXcl8Mq6IFQAi266n+SlecshRKIeNnyKUCF4L6fyuIG7CtVcMpmXXnHih9wG0pfacMAY4deBPJmn/ZAfniq2b9FOgrtaSIDot8pcQCl3yDMyG2hU+uMEDSm1vLpBot8+ohrEvuB9VzRB9KiFCPbiEKfK8CXQ4vYWCCEZkFIxcISqlNtmeLsHrnxN1XyNx98iKLLr+FaQc7UwJIZo/aBmPZZGdDHXZHtOwEhqAaC97ISt15P0V0SrygaIqR/L5eKQ8bfzDhN3nvHTirCDISqIy1cDjfsEXUulv6k3b3TJbOcrR/qLVagAYHtsomQytrIdaT4um7t7sTd+E9gmUUtuvk4F1ZMoxoGpoHdtSWoczNHI4viRantV0JeG8x6SY25Pyb6ov00jiZ3ow0WTW0K786ZBHRKCD9RxvTLw4Xgw8BTlkIvsjoS74jp1w061ih4Ax3vxrlgqNitLVK+tu5jOGI6mWVmMWn3LgSPdO+S5v1CnKdc4lOlGn0bCuvqbCkSzDb6BCGCG1vI1dNERlU9vjrz1l4PnWztsCyLct6boBonPlFH6bbMWngkdrd2j6oBg9XmQZUPcKAlkAVHyfSN0VeNeqXppcwWc0ogNwVXQAo1028ik5/M4hV1NcCPk8RXAvedtirpI8xluTchlCumO3rUhA7rUzpyaPNqEDS1yPM5qmxAwQrM9wM9M35+2f3iOUghYZ149qzo3duNAJR2IuEBbI16PoW7FDYGwP57AyT7/7+uf/oHxufhTpVc0yA2l4Wkya5IQOC99vpWyidL/J6eKnsaDNxDaWU09JaqT94n/8LDcHgvaHdM4ZbNh8U6s02U100RDO+z7YmUgJNTH9RNhiqiFSsG9eR7Nh4
 s/hwrGJg
 VeK+5jdLYfRcoVoVJfuLtN7LuzeHWOPqjaithAH+IdMTF4ZpOiTEm8tAmleZ8dIy5ijnWKEQSJR2hdOYjvrKppTO4FRhXhStKegu7afUyLFFg+1QuHqehW+EZthnsMTqj6feLbwBpf7vzJolXBMhpNtKpkFEIrZJ4FGzOMvOzOmwvhwl9OeVFnWlK5lWAtxj3dQSNFcRJqaKzbPnEIt0hgEzAkzLE6FjwwAmP59qFIRzazL4XbNTwraDZH9BFIifhI4FGnu++sDVvTFIpQdFDA3SzSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 7:41=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 27.08.25 09:52, Chunyu Hu wrote:
> > The nr_hugepgs variable is used to keep the original nr_hugepages at th=
e
> > hugepage setup step at test beginning. After userfaultfd test, a cleaup=
 is
> > executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
> > /proc/sys//vm/nr_hugepages are reset to 'original' value before userfau=
ltfd
> > test starts.
> >
> > Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
> > nr_hugepgs which is the initial value before the vm_runtests.sh runs, n=
ot
> > the value before userfaultfd test starts. 'va_high_addr_swith.sh' tests
> > runs after that will possibly see no hugepages available for test, and =
got
> > EINVAL when mmap(HUGETLB), making the result invalid.
> >
> > And before pkey tests, nr_hugepgs is changed to be used as a temp varia=
ble
> > to save nr_hugepages before pkey test, and restore it after pkey tests
> > finish. The original nr_hugepages value is not tracked anymore, so no w=
ay
> > to restore it after all tests finish.
> >
> > Add a new variable nr_hugepgs_origin to save the original nr_hugepages,=
 and
> > and restore it to nr_hugepages after all tests finish. And change to us=
e
> > the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after huge=
page
> > setup, it's also the value before userfaultfd test starts, and the corr=
ect
> > value to be restored after userfaultfd finishes. The va_high_addr_switc=
h.sh
> > broken will be resolved.
> >
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >   tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/=
selftests/mm/run_vmtests.sh
> > index 471e539d82b8..f1a7ad3ec6a7 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -172,13 +172,13 @@ fi
> >
> >   # set proper nr_hugepages
> >   if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> > -     nr_hugepgs=3D$(cat /proc/sys/vm/nr_hugepages)
> > +     nr_hugepgs_origin=3D$(cat /proc/sys/vm/nr_hugepages)
>
> I'd call this "orig_nr_hugepgs".

Hi David,

Thank you for your review and valuable feedback. I will rename it with
a v2 and resend the two patches. Do you have suggestions on patch 2?

>
> But it's a shame that the naming is then out of sync with nr_size_hugepgs=
?

nr_size_hugepgs is for uffd-wp-mremap, the test need all sizes hugepages,
it's used to save and restore the nr_hugepagees of all sizes of hugepages,
it's a test case setup, not like nr_hugepgs which is a global/general setup=
.
They are not the same kind, maybe they don't need to be aligned...

>
>
> >       needpgs=3D$((needmem_KB / hpgsize_KB))
> >       tries=3D2
> >       while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
> >               lackpgs=3D$((needpgs - freepgs))
> >               echo 3 > /proc/sys/vm/drop_caches
> > -             if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hug=
epages; then
> > +             if ! echo $((lackpgs + nr_hugepgs_origin)) > /proc/sys/vm=
/nr_hugepages; then
> >                       echo "Please run this test as root"
> >                       exit $ksft_skip
> >               fi
> > @@ -189,6 +189,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> >               done < /proc/meminfo
> >               tries=3D$((tries - 1))
> >       done
> > +     nr_hugepgs=3D$(cat /proc/sys/vm/nr_hugepages)
> >       if [ "$freepgs" -lt "$needpgs" ]; then
> >               printf "Not enough huge pages available (%d < %d)\n" \
> >                      "$freepgs" "$needpgs"
> > @@ -532,6 +533,10 @@ CATEGORY=3D"page_frag" run_test ./test_page_frag.s=
h aligned
> >
> >   CATEGORY=3D"page_frag" run_test ./test_page_frag.sh nonaligned
> >
> > +if [ "${HAVE_HUGEPAGES}" =3D 1 ]; then
> > +     echo "$nr_hugepgs_origin" > /proc/sys/vm/nr_hugepages
> > +fi
>
> FWIW, I think the tests should maybe be doing that
> (save+configure+restore) themselves, like we do with THP settings through=
.
>
> thp_save_settings()
> thp_write_settings()
>
> and friends.
>
> This is not really something run_vmtests.sh should bother with.
>
> A bigger rework, though ...

Totally agree, with the c interface to do that is better. then the
vm_runtest.sh would  be clean. It's a bigger rework outside of this topic..=
.

>
> --
> Cheers
>
> David / dhildenb
>


--
----
Thanks,
Chunyu Hu


