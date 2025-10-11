Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E735FCCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 21:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C678F8E0007; Sat, 11 Oct 2025 17:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18A98E0002; Sat, 11 Oct 2025 17:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07318E0007; Sat, 11 Oct 2025 17:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFFD8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 17:47:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC4B046BDA
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 21:47:38 +0000 (UTC)
X-FDA: 83987170596.07.8273013
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20DCC100002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 21:47:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VKymfAhz;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760219257; a=rsa-sha256;
	cv=none;
	b=gtRyFYr7C//+vKnqNTfNtICNDibm9WeBtRZCmgD5773p004Q85YKk8dPPx0BXKyrwnP/wV
	NmP8reATp8BBNwnzQZFOjXeLK1zRClHQvSdoSYzZeDlmlxzuVI1tRl5OoMhMOSyoaghn9M
	YML9aFS0fhakwlCWzqwxaOIx+WSX4Tk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VKymfAhz;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760219257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edG0NGbrr85u0FtLnw6wkiSc/A0YKw/98Yub9scsGaw=;
	b=m+Kn++WQ03grWXHd/NxHe+/EjkvTK0BomSb5vYa3Q/xciaSk1Kq/ixIF5i+Rk7HpAIlsiQ
	OHTNv5QBJh8PzuIJxUsnCXuXzohv8Pr8lVHSH+zeSoqCfg9jz0LM7PKokpbzRuk/kpya7/
	5Detbge1eBcwxT/0R/JkiFguolkHsKI=
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-42d7d0c58f9so212845ab.1
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760219256; x=1760824056; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edG0NGbrr85u0FtLnw6wkiSc/A0YKw/98Yub9scsGaw=;
        b=VKymfAhzex/VEv5UuDc2MFm7HczyFMjdLBe6CZSxoIyGwvgyNjeiCHUFRRLcEfEaez
         IHfOC+CQXPBwlFGCDiZIg8ApvPl/KxgAmD6EnCTLPT/88vVqF0tgwKKyO37Ycx96V0Ge
         ziaIes0ln2086y4E0kcAESmtuMewN0jdIisj/mmqIvPZsOuoXtP5W6UMbuoOVUl0QTk8
         5U7+NMFf9W9DsPVebKXRZppS+RfyLN2g7Gb5lhpSiPsqzj1LiOWenLGGSg0HzqAcgEXF
         DKIPhCwi0+ClU9h3E53BUw5d/QjeHWR290yVcwc1uryKqsXw3uNrt0XHIc/7awQeAgNc
         kJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760219256; x=1760824056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edG0NGbrr85u0FtLnw6wkiSc/A0YKw/98Yub9scsGaw=;
        b=hzl3qwotfzy+H9mXVyuC0/GFUjJ2HGIZah5mI4HS3HMjme1VE0jq6wI4+fnQUqLwFs
         XO3fD0FPYIui+ISd9ieyy92vacT8oBOVt48q70U5Bb9o3tZ82vhdeiDEuxxeNsMHhG8Z
         eAHyx7XfbOly7fOQDSLKJmTIZLB7hpp8+pvzyEYpCwUlyAANPqBLOOez5gIusr57r0TR
         khqwGCxnK00RVOB+6kZZzdAoyyD3M9zyOga/ZrjjmHezrMZ/P37AX7EJslIfULCA3OGP
         P8jkC6DEv7IRZ66W0yBrBiBHwhm/MLTNif4pjZlkIBIgVwAkLoCrMKpsIShCFgaybd7f
         We+w==
X-Forwarded-Encrypted: i=1; AJvYcCUq6/KaYfLy6PexxhWMHlISTvRnk8bSQlFIVPZ3zLJepZsvjz+ylPDWddbj3dybu8JE/hQnzJTVWQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0cCrWqDlg7tTO0tgrvfLzWntJFCozyOxbt2hbiglhj7uiuDfC
	ML6MZWWnewWTjr5MXjoL8OLnDBVY4eDtNiucFmZ97sSLKcFa//kSKn6olHSMYLQ3Y72BhuzWaUb
	gQ6uIhMOZ/N3CaGCuuCzfksYzVETOFNRvvJeGg1Qi
X-Gm-Gg: ASbGncu4adqyzIggRshzGvH8BQvdmO5RYLCT/agA8pq/VtKP7bmkSJEgxNPQ/pMh9HM
	+FmC1JEXbpfEA/9JMjbj9GZm33YCKGS05n3m+j61/7IyKOowUCGxyEoitGTZ0U0PmfjwgT684Mq
	iNuziymjBQAfm7KD6mH2NsNY7nfLH4ln8UjDE2FdLbCNkQcz/FI7ip2MikZ2W7KuQgWO49FgQcX
	9MVad/DuC9PFDtka2AyYnZzbpRwEV0=
X-Google-Smtp-Source: AGHT+IFFaqWGr6zppAMQlQaEOPe0SaZYdxA84DzbcLcqHShRGwrEbPejok43SDIXTETu3rLoVc/dTHFUc/Jq0m7QB2s=
X-Received: by 2002:a05:622a:808d:b0:4e6:eaea:af3f with SMTP id
 d75a77b69052e-4e6eaeaaf5dmr21268691cf.3.1760219255521; Sat, 11 Oct 2025
 14:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-6-surenb@google.com> <202510111059.aKceYLLH-lkp@intel.com>
In-Reply-To: <202510111059.aKceYLLH-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 11 Oct 2025 14:47:24 -0700
X-Gm-Features: AS18NWDufVi4cEGnv1sKGIKBBNV8Et6IGfR8sPmz2Ei8b77bsJTwPJgzvhpHvVI
Message-ID: <CAJuCfpHKr392MiS=gnjpomwdzTnesgBpXSkVk5h87wLJwo7qVQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/tests: add cleancache kunit test
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	hch@infradead.org, jack@suse.cz, willy@infradead.org, 
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, minchan@kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: hct56y6gwgwkkx3gf5heha4mmui85cm6
X-Rspamd-Queue-Id: 20DCC100002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760219256-18415
X-HE-Meta: U2FsdGVkX18OXp+G6P9rHVA0Y+NPrCd6CfCogDjR+FYmQGJ2MDEnwGRhU8DD01TRriBhmObNASyv4cbWko5GmkMwNn7zlL18I/0zHCvDLiPEhLeO8jyXZysTjb1Nx9SeTUr5XwOmUf6cITMOKEgrkrNJm8DfLG+SKHJgfpo9eEjCuvCx+QNC0+aEH/+IGorGjA1vnNNqhCrS+ShGjWcbcevRdjiEKvYFgrYPNoOBFPN+R5Fhg8fFMKLiArR2AcErGqaOWUPc8F+KspjH/qFtbmFGUbB68jJPF/ioKqRkgmTiQDBzgDdoMAx6GWq6uWoadD/551B+TIUxY1rIAPnNuWVLVAvT9s+eiVrlHR7q9pNkE9zi9jYVVjYxwSbLNfVdODBFJnBKeR7f93TpezH7sv2D35/RooqQ2GQiLARS1YAqdGsiYhE9IiNiCTqrQJnjOK/3RYQUtK6zhdnrTb60jHB85sJZtUuDtKhiHEL684CcbybLkdGr3VxYEkrV/ZmFaA9BQCX4GNu6vVQ+aMouziaehzeq0E/GfWOKkukYsKs9PC1DOP5j0dhwxGlvbpQhuQLgOHsdy5utO3fmO5cqC20MQYsigoSJO+N/P82vdU8rxWUX0iK1P7WPof6RpmoBYRddwJFV43OBGVUZgtuSxeBKBuDRuN4IIaCVoqhyjIgvtgVBKhyyWac4I+A7cBeWby+VPK1q77t4sLMdxmd31U6AaY5RztL9MPXPwu4EqeEmoIgb4gzjaQrGYKFeBSBO/KzqG59JQUkviskwQM+CbaShHKgyNfB1IFuu+6vw9ib6lRpln7ih8Jsr/6UzM6hbKdHjxj2hCJ2hTYgrzDmxSSeZadOQFr6Omk4FTJO7uKnE8XV+WeBcWbon7x6t5WtMj5/UDFcHBNiNYqKyC85uw2b74Bpb5YOZEZI1unHy97s+DU8JiNAILWKILSawEfTeZTsvrj0QfPKyNXFcCDY
 eBO3ER0v
 ZfnfSuvM8calS6hiCBYhrtx+pCHs5XhuYC6nvpwy3suRHMNhqvWCfi/TaLXwb1gdsRRaaxMVRs3L3FWrcbqW+tM2/x5uiPUY3Qj1p+tjJfTJKictsKb2xnbb64qnzk5bjjAjQrQHkYLSzwtbvc439L/ym9jt+WT3W8vyfYXHN4ZD3HFAbGRR9Vd2IshSweOZs8EzGAn/5aX+opKSx+CNP2v4U/ZXhSrhTRpbogSN0DCsd0kvGYNzKHM7kFMNcAvHPXdUPC3j2aZEDh59IWnuPC9nXQvFTPVK8w2rbVbd6l7LfdUCHfOWqN1YrLQpOfS89UmqbNbR7bzOyERngUTBlr37Z99OGy7OfXOkY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 7:58=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Suren,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on 70478cb9da6fc4e7b987219173ba1681d5f7dd3d]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan=
/mm-implement-cleancache/20251010-134501
> base:   70478cb9da6fc4e7b987219173ba1681d5f7dd3d
> patch link:    https://lore.kernel.org/r/20251010011951.2136980-6-surenb%=
40google.com
> patch subject: [PATCH 5/8] mm/tests: add cleancache kunit test
> config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/2=
0251011/202510111059.aKceYLLH-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd70=
8029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251011/202510111059.aKceYLLH-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510111059.aKceYLLH-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> mm/tests/cleancache_kunit.c:358:6: warning: variable 'unused' set but =
not used [-Wunused-but-set-variable]
>      358 |         int unused =3D 0;
>          |             ^
>    1 warning generated.

Right, I'll remove it.

>
>
> vim +/unused +358 mm/tests/cleancache_kunit.c
>
>    353
>    354  static void cleancache_backend_api_test(struct kunit *test)
>    355  {
>    356          struct folio *folio;
>    357          LIST_HEAD(folios);
>  > 358          int unused =3D 0;
>    359          int used =3D 0;
>    360
>    361          /* Store inode folios into cleancache */
>    362          fill_cleancache(test);
>    363
>    364          /* Get all donated folios back */
>    365          for (int fidx =3D 0; fidx < FOLIO_COUNT; fidx++) {
>    366                  KUNIT_EXPECT_EQ(test, cleancache_backend_get_foli=
o(test_data.pool_id,
>    367                                                  test_data.pool_fo=
lios[fidx]),  0);
>    368                  set_page_refcounted(&test_data.pool_folios[fidx]-=
>page);
>    369          }
>    370
>    371          /* Try putting a refcounted folio */
>    372          KUNIT_EXPECT_NE(test, cleancache_backend_put_folio(test_d=
ata.pool_id,
>    373                                          test_data.pool_folios[0])=
, 0);
>    374
>    375          /* Put some of the folios back into cleancache */
>    376          for (int fidx =3D 0; fidx < FOLIOS_PER_INODE; fidx++) {
>    377                  folio_ref_freeze(test_data.pool_folios[fidx], 1);
>    378                  KUNIT_EXPECT_EQ(test, cleancache_backend_put_foli=
o(test_data.pool_id,
>    379                                                  test_data.pool_fo=
lios[fidx]), 0);
>    380          }
>    381
>    382          /* Put the rest back into cleancache but keep half of fol=
ios still refcounted */
>    383          for (int fidx =3D FOLIOS_PER_INODE; fidx < FOLIO_COUNT; f=
idx++) {
>    384                  if (fidx % 2) {
>    385                          folio_ref_freeze(test_data.pool_folios[fi=
dx], 1);
>    386                          unused++;
>    387                  } else {
>    388                          used++;
>    389                  }
>    390                  list_add(&test_data.pool_folios[fidx]->lru, &foli=
os);
>    391          }
>    392          KUNIT_EXPECT_NE(test, cleancache_backend_put_folios(test_=
data.pool_id,
>    393                                          &folios), 0);
>    394          /* Used folios should be still in the list */
>    395          KUNIT_EXPECT_EQ(test, list_count_nodes(&folios), used);
>    396
>    397          /* Release refcounts and put the remaining folios into cl=
eancache */
>    398          list_for_each_entry(folio, &folios, lru)
>    399                  folio_ref_freeze(folio, 1);
>    400          KUNIT_EXPECT_EQ(test, cleancache_backend_put_folios(test_=
data.pool_id,
>    401                                          &folios), 0);
>    402          KUNIT_EXPECT_TRUE(test, list_empty(&folios));
>    403  }
>    404
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

