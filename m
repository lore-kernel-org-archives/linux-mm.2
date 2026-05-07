Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7DACD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 06:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0286B0088; Thu,  7 May 2026 02:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61946B008A; Thu,  7 May 2026 02:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4FA56B008C; Thu,  7 May 2026 02:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A31E16B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 02:35:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 441B740356
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:35:24 +0000 (UTC)
X-FDA: 84739662168.05.6C78CEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id D76A618000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:35:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K07V8f3p;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778135722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
	b=Rm4S+33A++eUA4h26sZ3gmTnF8UBlA5Cn+wcd0yilHqhmbSIxd6ekY495Bih4b2drwCwXD
	mzfUluJ9Q3uZilqjxtn522ONAAuiQX61/uRIwGtsM/GbwHEhKj9EjuRA0rjxqmtptJ53jO
	fdGZe6mY43PQ4XwW7phGXw4oiqtPXWo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K07V8f3p;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778135722; a=rsa-sha256;
	cv=none;
	b=YNlE3ydDJJS4VMjFEbVd05inLZBl7mJZvCgy0u3nKlncrY1X2k9kL/gPzmEbBALIOwfB6D
	dVpjqfMbVs7DaRpI4rkXV3BKCZGJfPki2lU0Een8gxHzS9Ng5y5pdnvXwddc5j5nhY6HcP
	sT+22K+Vf9sl5gm7TqJg8QKVBWFYCQ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778135721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
	b=K07V8f3pAQ7C9lpft8ptvrgjcwykEt5CZhW9BnftI1LNlpKOs3ciyIFh5sAfhx3Vo2IPxV
	9Iv1WHN6IjFoek+4AVHZWUZbRl79xcyLPF/vKWhcECrzoFtmU9wyvp/Stg8h0t/nZhmoA5
	kDiIWjZx0bSGOPeqYXkjQem0Z65qL8I=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-rPX6QTCIOcO9Z9qQnfis3A-1; Thu, 07 May 2026 02:35:17 -0400
X-MC-Unique: rPX6QTCIOcO9Z9qQnfis3A-1
X-Mimecast-MFC-AGG-ID: rPX6QTCIOcO9Z9qQnfis3A_1778135717
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-65d8659ae23so90785d50.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 23:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778135717; x=1778740517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
        b=Xsy6wesNfTsF7rnnSt7p2TJ3PoqdUT3Z5jrJh/Pj0du6Jevpi8lMlliQV/DEMkvjcx
         U85RRoBmfKMhpCydpyk7qQGBWL4IRXcTDIDVlKxyCilKQ7giZhejNl1z/iIY9Q5pJOs2
         e2HC+KxTzSb4ph3YKbrGpQq0FQm9zo12MjEbK8OyKLERui4GQ27ANeRqbq0DeHe8Mt0u
         69tCdImTK55eckRWUhOu9v7Zx+SwpS4zyTExvNKxtuZE5+JKy+l9kWkuWymmpcJ3IM9b
         0xv/bMzPbQFPFvwwuXD4UyamyolkwRdr8JaLzUZqDyN4HmMKe7P6SO7JeRZUpAbNIQyY
         tNtA==
X-Forwarded-Encrypted: i=1; AFNElJ/f1Edh8Sa5NuMQGlItefGmIgam/IcVpmeb8sgcXOePpxqc2SqgyTK9uP2+dWrWePYZAFoT/u7wHw==@kvack.org
X-Gm-Message-State: AOJu0YzeB6VEFPK9DLQZkQz+ss9qHp4swTLdwW8NUNku2mRJrRZn/2Dk
	QEQs4hxqqLzQtBKcg3O0Rq7rPVqsu84bLgsTNDpZIgYcujB5XEVWlDs52f+8kDbD8KcliyVRvjd
	W8bF4+Yynk54eXpYMY6WuK83q7ZSSj2rkHiGUDL/NU4aeuhsjHIx1yZ1xmmK1nQJVBQJW9UEHQF
	zy9GyB8e/mqJuxILXziQm40HkoKv8=
X-Gm-Gg: AeBDiet8jjQRKiadWYaws9qTSObgyZ4sixcuKl/4QU0doouTRmehtmeM6/vi6uJ42Xy
	H7RAevkTYnnoKve4biA19EruMGBQASJ4OyDezd8+KKpXWZR3cjbi0M7zQVgP9G2DRrPG3NJo/6C
	c4tT47CoPe5H40vNLv9OrJ8dBzQkH6bfxr/Az3DtUw5L4TEAWK1cDxlAOMqQATwlcfYYcn1TumN
	6hpY+lKqUU76g==
X-Received: by 2002:a05:690e:4145:b0:658:e45a:e477 with SMTP id 956f58d0204a3-65d7e72eademr1206492d50.2.1778135717198;
        Wed, 06 May 2026 23:35:17 -0700 (PDT)
X-Received: by 2002:a05:690e:4145:b0:658:e45a:e477 with SMTP id
 956f58d0204a3-65d7e72eademr1206480d50.2.1778135716760; Wed, 06 May 2026
 23:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260429152924.727124-1-ziy@nvidia.com> <20260429153538.727855-7-ziy@nvidia.com>
 <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com> <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
In-Reply-To: <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 7 May 2026 00:35:28 -0600
X-Gm-Features: AVHnY4Lrljxe6KvxlSyOqNI3gvAzejJ0XLC-pzb1vAYqjO_YkbxwJ0hvJkZ60ks
Message-ID: <CAA1CXcDj7Y7Z26f2o211fYewgrfBNOS7SfZ8Xroiv1ObC8dDRw@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 40Y3g0Eu6FfR0qh_FyUhtoNUs6-TIxKqFMpwPR6jHCw_1778135717
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zqo3ryaycsfi3m4izea4q1pi9ceq7w9r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D76A618000F
X-Rspam-User: 
X-HE-Tag: 1778135721-524559
X-HE-Meta: U2FsdGVkX18HufrchigJ2q+v1QNvbscthASZFgdC/Gsf5wM8UHA5qvTIdCQHKE0XtwIGeDVVfWVE5nnZPodeHBb3S5PWsrvGkpBYGtXaM4damqQFHqWfq4pdCzCs+xagQO6HVZDVAEUUzXLVlOt8vwKcyEOu528mDiw8pLe+yczZxjSHKaceYKztaFITxR7QNiGBodxfbCD2D+vlxgtXMa7jOUQ9m5kPJ2Uw2z/q2UQ51+nW+gctL/bVWEWugsvcVeAmMcWwGFrrfcTmRn+hNggxEoRHd/sL/D2zNNByL1z2nTFkRY0RSb2iTXiU4zFILzZILXdwl3re4BXYsMaKD69HLSzJAfdMzRyxpvBZH2okrZ3TnrBPUKczYTn6MOfPM/UajSK5xwbrmgidn5UAWPGORDseW/st2D8UZ2tL5RxxImLnfTNC6tZZ73CmfnDy/p/wP0fDyIyN3v7hTln9GEd+zEeQFg+qZo4j7dFMfxvHPEfAul0lXoA9LcazVRhs47muQcnW8nCDX6UdBxWB/yLN9XoaZRt7CwkZVDN4XvtUa+Fex6uRuRy6lNxT49c1wobmDTvuXzvsJGZz3ZkAiZbp0bgVLEaTSatiq35LPYXqaoCs+o7Yu5bZiP20uJEIV3zkJRGFgkrTNvLZDWeUYdL/iV30UfhP5ck3Ba5o1bNQkjZQO0l8ECIke9xceP7NvxAwraG0kixhYQekRq/7YNCklp3Ht9atEW7cDadJnSZEVmOTw/VU9jVR7V8WlD5bZA5KnTVXxSRXDUT2DRji7YnxZeEpF1aCWLeUL5t5FBkTqR19CKxgvVlaLbFMsaTakBWn0ZTLw+lj/ac2P8h+4ZSC/3nmyoDy8Cgq8ziEkHty4RA42eTmTpAHo0f+niDCBJa9X1lj58Vl785mWxHaMQ6qA7H95umfUbJKAcQvkBqYu0h+yD7Hw+hut2EqWmEQUt0Z6Os2lD0f27iwE2A
 V/WUUb/j
 UDAwCueQ1CuO/5ZSQBr/duvyjiX88nIClMFQrasvhnmvoQ6tI4TJEy4w8vabalBHJM71wpTrUdo6rLXs93tQsaawO4SSGVctjaciqKSvuzbKzaUCYa2PzL7sZ14klpi85En8SSCdGNYvfgFk9ibBFHgq0Z1RlHHLdpVTK30CMAoh5Y5KyXrbqlSaqBnuWgjPuQO/YfkcsNkMlbw2UjW+NclmPGk1VJQqJ7vtAjtSRHuiGbnDOyqJgabRKTIER3xq9DRxu41ZsAX+LBzI/P3Ljxt19MSWOGo1qkf+1G85I8VyhlbikX/e9eOKD56DVKJ6g1fdmiUX1pfVP+GUMxbAQZ+oqngBM8nV1IdcLuLRfh56JbWprbQZD7l9w5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 7:15=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 4 May 2026, at 18:11, Nico Pache wrote:
>
> > On 4/29/26 9:35 AM, Zi Yan wrote:
> >> Change the requirement to a file system with large folio support and t=
he
> >> supported order needs to include PMD_ORDER.
> >>
> >> Also add tests of opening a file with read write permission and popula=
ting
> >> folios with writes. Reuse the XFS image from split_huge_page_test.
> >>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-----=
--
> >>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
> >>   2 files changed, 102 insertions(+), 41 deletions(-)
> >>
>
> <snip>
>
> >> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing=
/selftests/mm/run_vmtests.sh
> >> index 3b61677fe9840..854c5c3e3a6ae 100755
> >> --- a/tools/testing/selftests/mm/run_vmtests.sh
> >> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> >> @@ -490,8 +490,6 @@ CATEGORY=3D"thp" run_test ./khugepaged all:shmem
> >>    CATEGORY=3D"thp" run_test ./khugepaged -s 4 all:shmem
> >>  -CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
> >> -
> >>   # Try to create XFS if not provided
> >>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
> >>       if [ "${HAVE_HUGEPAGES}" =3D "1" ]; then
> >> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; the=
n
> >>       fi
> >>   fi
> >>  +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
> >> +CATEGORY=3D"thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TES=
T_XFS_PATH}
> >> +else
> >> +    count_total=3D$(( count_total + 1 ))
> >> +    count_skip=3D$(( count_skip + 1 ))
> >> +    echo "[SKIP] ./khugepaged all:file" | tap_prefix
> >
> > This leads selftest runs to always litter the output with SKIP when run=
ning this with the wrapper
> >
> > make -C tools/testing/selftests TARGETS=3Dmm run_tests
>
> Yes, this is intended to let people know one case is not tested and skipp=
ed if XFS cannot be created.

Yes but it prints after each test case run, not just the khugepaged runs

>
> >
> >> +fi
> >> +
> >>   CATEGORY=3D"thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_T=
EST_XFS_PATH}
> >>    if [ -n "${MOUNTED_XFS}" ]; then
> >> @@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
> >>       rm -f ${XFS_IMG}
> >>   fi
> >>  +CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
> >> +
> >>   CATEGORY=3D"thp" run_test ./folio_split_race_test
> >>    CATEGORY=3D"migration" run_test ./migration
>
>
> Best Regards,
> Yan, Zi
>


