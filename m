Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E2A607F498
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L2CsdjyJ
Received: by kanga.kvack.org (Postfix)
	id EB95C6B00F2; Mon, 19 Oct 2026 10:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90926B00F3; Mon, 19 Oct 2026 10:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDEF6B00F4; Mon, 19 Oct 2026 10:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA4E36B00F2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:56:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BE04A073E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:56:44 +0000 (UTC)
X-FDA: 85339677528.04.FA6327E
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6BA5A100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:56:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L2CsdjyJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of error27@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792421802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJKWEXJHZfF0BggswatoUj5xyndbeG3MBJPDa8wHg/Y=;
	b=xQ6ZK2h282ejIIdvolmVrLW3mp4A/udZI3sh6J+qRcI0e9es13XUiCaHkXAW6CodhmvoTo
	5eXCEZ8FMNAXbu9HgVU0EVXPEpAi6bLNNZI+szibeRkwTrNuQeMJJPyG1xD2d1swExnueK
	VFsmRolvUeS42ek35Zi8dmBNWgN57Ko=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L2CsdjyJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of error27@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792421802;
	b=7XBXTOmx1yvggBl5XIajpAn4UF9ONzABR7gG8CHIIIV4h6nSD36DzJlMCazvVCtpR7a83o
	r9NOiuAC9vkZUFR0C2E4R5/H4iUMdFS6s4Lel8bD6IZv0V+TzKyR4IhD1dWFIjOHrcM0CC
	ocDoGNGhHE6qq7FZn1DZQzpODClhnkc=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1df146015so11906565e9.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792421801; x=1793026601; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vJKWEXJHZfF0BggswatoUj5xyndbeG3MBJPDa8wHg/Y=;
        b=L2CsdjyJ0Mv6rRlG5PtmQXqZgRwKikmefcvgUzw5PpaNQ+QhTXDuKavpecMyAZqLAu
         izdSnqvklkiwfxWGNsskVS7Jcysp105FHDfAdLTZ6s1e0FEg+ep2pvB59ng1/VtllSGo
         oEbKKmjbakE0jf7jK5f+i6G0TbAgSNW4llzzea4FJM+JtSj/oBqgCFM0pDXK8ZIOvsDP
         pg9RsPSM84Yve17Kju4gShsW4R/yjzspyOTDVSad/AFHApuQZ3UuIzx8pFPbFRBQH3/t
         M36fIZMfO6xUsKxtTKinNYAUxh5ZI4Dl/X9kGi2yEB14BmlpM4Y/87KZ+fTCBJYBWwCD
         o3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421801; x=1793026601;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vJKWEXJHZfF0BggswatoUj5xyndbeG3MBJPDa8wHg/Y=;
        b=1l233JLY46nwN8QZbTq9ZJMHl1EZEzzTnbfd8zIiimCa+KxJ8/Nq/1Wq9YNWx6N6VN
         0Txim0Q5nVh9RLnVdKN2PKD3c9r3M2pI8rHQ3ksLsluhAROfCiQ5jywudAF60FbMz+I9
         gG68sJs9gSH5ViZaZqnBphe0GPTHbdBuCsG80hBGgVppQPaHiWjmJnPW0Na97UsjmKdS
         +zxhMLM5GzJo3Y+jExeWj2UaguEZJg/JM1C6ZV0dbYq8NuDVtXG4fL61yZvsCzLdG8ci
         y6vOw4P6E4a3Nsl6MKcaSi/LScAh1w0cmHv3JSGk96HIL/wobfloHXZ31vnpDDoMyPWq
         gGHw==
X-Forwarded-Encrypted: i=1; AKwUvBw2cpfGcSO7IJ0mSCVsnWuXieA4jWGTsATqECKpywRtLvTcHV/ITJzAfYldAHFTwX5ozS6AsK2mtQ==@kvack.org
X-Gm-Message-State: AFq9FYLJeFgpx8hAHh/S1JphwgIC5JuZEr3X+6+wSFB1NI/IBPJ5KXeg
	3YIGETsO0vYvgIK/rb+gWm2Rwsyglr09Uo1TLttPW4Ly8c3oBVKcM5KT
X-Gm-Gg: AYBFou3b8Xbq9N3S3Pmk4d2ADfi0Zn0PTMPM/GuGAaco15+hzByaJ8iuKURiCNNBRqf
	qmcjM/h+uYfYM5kywfv8AShB1K8il35u1VMijnrnmKANbejDUV67uyc2ynTMU2FnomzGH9BYkV2
	f4Ukg7+BEf3H+s7BvNgKm7UEz5uBrbLSke3c3fo4k6gCdY2H0BkzTt6Cdqei36pFzyNeNLTFs3w
	1VEkN6t4SBj/COuGBmHfl9cjKTRM8oF5TYTWGtXLfXaT9yTPymfk8Fwix7kuCImGmOJxXt/Efgz
	kCNRES8JgzvDVi4ZWVElixb06tuzrZFgpqiBqMpnY0Inl01JwFfF9SZLG1GF6EDhUGH8WxZjYbl
	QBJ6BcZCky3AG/qGN/xdoQ1NfO0V6n0AqDmLYbqBADkbeYlDeeuNuo5OvNB/trMg+5sgdBvaLIn
	PkofIbMc3zOhSNagZfDz1k6u7ZG/8aJYbp136MVksWqiYWG+6uyXITpfAoT53j2519zwk=
X-Received: by 2002:a05:600c:548c:b0:49f:dc71:e609 with SMTP id 5b1f17b1804b1-4a1d7610f2dmr171252085e9.20.1792421800470;
        Mon, 19 Oct 2026 07:56:40 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4c4fc4sm20913100f8f.15.2026.10.19.07.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:56:36 -0700 (PDT)
Date: Mon, 19 Oct 2026 17:56:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] tools/vm: rename tools/vm to tools/mm
Message-ID: <atYvmj4ZKlOfphJ2@stanley.mountain>
References: <atYOvqkdVSgjXZVM@stanley.mountain>
 <20261019135355.87175-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019135355.87175-1-sj@kernel.org>
X-Rspamd-Queue-Id: 6BA5A100005
X-Stat-Signature: mfxhxdg7udww43igetzf8ue39wtng3af
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792421802-392734
X-HE-Meta: U2FsdGVkX18hAGadiV+ps/70BFSHumvEHmRTmaBpmKTevNu1H8PZ8Fmd1f6GJSwznuhawsj+3Hbg3HMnpskIwLET4XUHZaLdEird87eQ1dopt4tlT6tR2asoOqS1rlXWpRUk5jkk+vGQIrGAYrRS89M8ASdpOLcGiYUYEPPt5AYZeyL8ifQ66z2BZQMEP4tZ3kDr5EfSEjoZfgQgYWCZwykWkGPkZnB7GARk1MMUHxTr4DN0cPYAeOtQ4s8FYZfx781aTOXavDi4TkdHj5Wez8aXlFNRKSd0y4KCmHzVX2mJLYq1D4/bd6sDBHpTnv1Nwl5UDGv0CbxIpRC+W0xc66b0esIZR7iLs641RcZRAUkeH5MGIIhAqujTJYZdoHdnQHHn4j8/mHVoP0UGcfdLKSI4WTDTVxGPL1kgi+RKtztX5LpdD45dkNfal+82QYw5EqT+0HK22aOKSrR7bzw9pifAV2cOIhXzAExnqzAOQQeg0ZLv/KV0nWUK5B2YJ3upYIjZWz3winGxB+fpAwH/5JskBjFi/NTCimcE0SmjTcrlJW8bHOtxXKlJ6kuMKowcIcZiXXEVIHetFxinQFhFVb+VG4vaN+ElgWPWAMyq/F8D2w/y+qC/FIu+Z6a/fpA+qWe83LQrLCec2Ihhnm2lcZ2qeUXLAZ04YTN/7gKvXTtyKQdk2S1eT4yxHYjSO4Mho+HccTekEltZzchccffpVYaeB5LW4ffPkWO54o8T8PlQp4TaSmVT836Ewi/7Jq7OW/Qo8PjjVc7p9OVVr/+q65W201lBiVtL0OC8ulbW+7xxMB7pqt9iHUFWphF1HAnhayykI6bp6Obs4NrfKrjXNzhnbPdfRqt+sNtkJUu7Bx7cgfaHLvgFNFTyQz7kv1Dp3TozvWH+dwilkFO9CV4Z3fUzxVw8t1+rc/ikn6VOKNIUb8cf47AeqgE8J5XCCRAjUT4Jp4TFqInCFxklV84
 06/PPnh7
 FhADjHN/74er631M0Y0k6E3U/kQYVt6abXckq7dVxNTdfmj8y7p6ZgAH30FMMK1gtQksDXEQpDVDvXWJmKLMnlnzWtQodV2qdAYoskhsNl20Crzg+huCsZvB9aYqUpG5SupBHcP+lt6v94fv51xVraZiVwd3K8y/R7uSqyNRT5Fnlt5e5pvxsZXNCgltKStcNMA8V40xQ3hylv/TMtbEfUSivU/XJguYgBSPTsGdI37KO2KJz52V6NdDSFws6GDR9QAYeRNc6p2wUCkCpw4E4jNu/flcQpZpr8ov0zKd5cnE+A1r54zXBoz9xYnhXbNlsVp2toJjU4fWfC/CX90Yp6jJJQXeky4k7nLhYMcOb4pqw3adngwVfjOhL1x/T6+5cojRQ4AAxpP4j5oAxGGliUehUxuuzC8MmJ7ueWBzxgYkloQnfy9I15Va5+y+O2cMCFeN35k8l2BH1QBr6FUJmKqGldeT3VmOcg0YSQhQo8dC06xRnpwZii8km/yQYe+NdXjVm8IpNEDzObgDadPFc6+iAqs4nZtS/lQ2Sxex/6m4APqKg3rYwvpagbsOpQKWR/klVt8s8/LUIcFDTOkOXBboRMAr4Hc7yBwMHT9QVFUig2GU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 06:53:54AM -0700, SJ Park wrote:
> Hello Dan,
> 
> On Mon, 19 Oct 2026 15:36:14 +0300 Dan Carpenter <error27@gmail.com> wrote:
> 
> > On Tue, Jan 03, 2023 at 06:07:52PM +0000, SeongJae Park wrote:
> > > Rename tools/vm to tools/mm for being more consistent with the code and
> > > documentation directories, and won't be confused with virtual machines.
> > > 
> > > Signed-off-by: SeongJae Park <sj@kernel.org>
> > > ---
> > >  Documentation/admin-guide/mm/idle_page_tracking.rst | 2 +-
> > >  Documentation/admin-guide/mm/pagemap.rst            | 4 ++--
> > >  Documentation/mm/page_owner.rst                     | 2 +-
> > >  Documentation/mm/slub.rst                           | 2 +-
> > >  Documentation/translations/zh_CN/mm/page_owner.rst  | 2 +-
> > >  MAINTAINERS                                         | 2 +-
> > >  mm/Kconfig.debug                                    | 2 +-
> > >  mm/memory-failure.c                                 | 2 +-
> > >  tools/{vm => mm}/.gitignore                         | 0
> > >  tools/{vm => mm}/Makefile                           | 0
> > >  tools/{vm => mm}/page-types.c                       | 0
> > >  tools/{vm => mm}/page_owner_sort.c                  | 0
> > >  tools/{vm => mm}/slabinfo-gnuplot.sh                | 0
> > >  tools/{vm => mm}/slabinfo.c                         | 0
> > >  14 files changed, 9 insertions(+), 9 deletions(-)
> > >  rename tools/{vm => mm}/.gitignore (100%)
> > >  rename tools/{vm => mm}/Makefile (100%)
> > >  rename tools/{vm => mm}/page-types.c (100%)
> > >  rename tools/{vm => mm}/page_owner_sort.c (100%)
> > >  rename tools/{vm => mm}/slabinfo-gnuplot.sh (100%)
> > >  rename tools/{vm => mm}/slabinfo.c (100%)
> > 
> > Is there a reason we left the tools/vm directory even though
> > it's empy?  Is it for backwards compatability or something?
> 
> No, I think this patch didn't leave tools/vm/.  I cannot see that on my tree:
> 
>     $ git log -1 799fb82aa132fa3a3886b7872997a5a84e820062
>     commit 799fb82aa132fa3a3886b7872997a5a84e820062 (HEAD)
>     Author: SeongJae Park <sj@kernel.org>
>     Date:   Tue Jan 3 18:07:52 2023 +0000
>     
>         tools/vm: rename tools/vm to tools/mm
>     
>         Rename tools/vm to tools/mm for being more consistent with the code and
>         documentation directories, and won't be confused with virtual machines.
>     
>         Link: https://lkml.kernel.org/r/20230103180754.129637-4-sj@kernel.org
>         Signed-off-by: SeongJae Park <sj@kernel.org>
>         Cc: Jonathan Corbet <corbet@lwn.net>
>         Cc: Shuah Khan <shuah@kernel.org>
>         Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     $ git show 799fb82aa132fa3a3886b7872997a5a84e820062:tools/vm
>     fatal: path 'tools/vm' does not exist in '799fb82aa132fa3a3886b7872997a5a84e820062'
> 
> If your local tree has some git-untracked hidden files under tools/vm/
> directory, the directory might not be removed.  That could made you think this
> patch left the directory?

Ah, yeah, you're right.

What happened was ChatGPT told me to type:

	make -C tools/testing/selftests/ TARGETS="vm" run_tests

That command is outdated since it's supposed to be mm instead of vm but
it creates an empty vm directory...  PEBKAC on me.

regards,
dan carpenter


