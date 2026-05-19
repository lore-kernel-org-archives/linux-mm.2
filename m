Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939BECD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E3D6B0005; Tue, 19 May 2026 14:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046116B008A; Tue, 19 May 2026 14:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E876B008C; Tue, 19 May 2026 14:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB34E6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:21:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A6E2120827
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:21:38 +0000 (UTC)
X-FDA: 84784987476.20.EABA729
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B0D9120003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:21:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ieDKz018;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779214896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxztUpQkc+oYoV60aAGxfNnNqxyt9Qiie0vehvZmWfQ=;
	b=qhthT2sOtB04vEMgbwGRuG/BE78nUN3NNy+RZ+5W8PKTZYSc2NGvRmZZVNbtKiIq6KoqOu
	OI+f01BOW4e006BaTTJqDmhwyxBX+LXUkOXVQLhzqvHdFjEUZjPFXqYmtTT9kn1CK0Fqz3
	y9wj8LWcV+/JHMxVa2K7IgR24GiNov0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ieDKz018;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779214896; a=rsa-sha256;
	cv=none;
	b=YIaXZLvRFTOrYC0l7xboRQ40QDaiFWI2PpESC0Td3Ywrze2QbVCwyb38ASVJL+vOEiWiIQ
	4EEKqG51Q1tR4+YQSx6yPW6+DfDq5K5+zXeEaYLvP4dVYbfcmwgDVs3l8vrfEvrD0aqKpl
	CHwZP6lAnSqLCtPhwrZA8w2Mj2ZIACA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779214895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OxztUpQkc+oYoV60aAGxfNnNqxyt9Qiie0vehvZmWfQ=;
	b=ieDKz0182k/PU9F45YmrOGKmUAZ6+DjL2/L84hx9xLJ+Lbp6RmbtZycForrrNKBwTZ9RMQ
	PWwjCz9I4L8peSad542qv+xLO9Nc9Zop7gB+ju46pVugV3WeHrujXiLF2YD1jdf1UHTJlF
	2t0OpmO6IIlmQeK8ECJe7Ez1gGHRdu0=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-AVcJocpTN42eQNfwHxeklg-1; Tue, 19 May 2026 14:21:33 -0400
X-MC-Unique: AVcJocpTN42eQNfwHxeklg-1
X-Mimecast-MFC-AGG-ID: AVcJocpTN42eQNfwHxeklg_1779214893
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-65c7306e432so7190466d50.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779214892; x=1779819692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OxztUpQkc+oYoV60aAGxfNnNqxyt9Qiie0vehvZmWfQ=;
        b=T3+qrBmUCPIjhqdJkupHkpVVt7thjVOJv0l5mFwV8eR82xYajZezbv3Yc3iZLfOOaJ
         v0TQUagezfIX2eGTg5s5QyNpTKMRGxZvzOMBSRmTsrt6/IeLf97iZ+KJoNdji1Iawy7E
         tKlACCnr3IiQbuZhOdRyIKUnUJOaZwRdYpQ/x9zPhySykbNZK6TgzVv55HyLPEVcM2E4
         LLLtPJZmfQqVWWST6IxVY/nr8qldCpwPBbAX3YbSVTQEtaql6D4Zll2s1yrHI4D2lM2V
         GpBkNBDSmOZeQhQnpOoQncSG5JSQHQjOR3JjAnXei9QW37dwgFhFK6DOK9PMDY0RArrq
         o6zg==
X-Forwarded-Encrypted: i=1; AFNElJ/HlPwPeDaOb27RWCG2z6Hb4Fl0rM6U4dYXiY/LG1zr0xgBmeaG+DmCR3SHNyC5wN3qymd4mpqOnw==@kvack.org
X-Gm-Message-State: AOJu0YwAIYj/BCTXPbxx2QjbH1VNyanJ7mK5I24PLH9gRuEvgBWUmaZ1
	CCrw0bKrERKoVapNEQplHiBppqVBFI7/ByyDsj029nhGBfDWKfrfj4U5POIvUF7SCYrjHB0918K
	gnma2GPXngPX5ly8aW4d7N0fL8sBkrC8vHLYy4OlCBxoWku56jdXIIXEJiEGd+a4+cukxqqyMii
	ev8W/zIsJvYxHmsMbGnGsvY2qIL7nqP7i3ml0XTQ==
X-Gm-Gg: Acq92OHh+NUlxZIQ0puyzVzAAmdh5lG4H4W5ZP0tKUn5sVeVqiDQ57kZtd61fL+hNoI
	WMuJZgR3ul/k3FZjKOQDHqdWXtuCwjNrJi3vjuG3DsSm8RVsEArY3DbIYjp34IiMVN/2V1lV056
	nfXS2VeYN90x8NU2hdWhxPuMQUHYJVerCiW2UkCrePLyo4UO3NWp/O8s5MMUWMU/0DQENYV5uuf
	AbAmg==
X-Received: by 2002:a05:690e:1699:b0:65c:5b88:849f with SMTP id 956f58d0204a3-65e22893f96mr20651126d50.45.1779214892485;
        Tue, 19 May 2026 11:21:32 -0700 (PDT)
X-Received: by 2002:a05:690e:1699:b0:65c:5b88:849f with SMTP id
 956f58d0204a3-65e22893f96mr20651073d50.45.1779214891824; Tue, 19 May 2026
 11:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260511185817.686831-4-npache@redhat.com> <20260512044444.71798-1-lance.yang@linux.dev>
In-Reply-To: <20260512044444.71798-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 May 2026 12:21:58 -0600
X-Gm-Features: AVHnY4I0H7_VzBvKWPdyr4SDWj9fF1lT1UTvqSSOtSQqNmJ-nBt_6GnPLA5-X2k
Message-ID: <CAA1CXcD=-kia9FPK75DggewQk4x52TvzP-Wwoe-CrcMx9wTg_w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 03/14] mm/khugepaged: rework max_ptes_*
 handling with helper functions
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, usama.arif@linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pcTB5cM1aIG3artfQOLTqfPM7qYl9Fgaw8vwOaqHdKk_1779214893
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B0D9120003
X-Stat-Signature: 88jk5w69grhojkryd4xippw364yyrw5h
X-HE-Tag: 1779214896-62864
X-HE-Meta: U2FsdGVkX18+DVw5eIDrTL6OIE5qdcLCKaTeG9aoGAFBCTSlF49SvneIkACkChlYATpb8peDLp5CpjWzySpbZrmjly5+t1sljjVHVt5DEGreEVO59zn27lTBtCzkmhBx//4Goax5LvB1+ailuPIyOe/yqL/JdLa/km4C3T1G/S9H7sAU0AdCIuziOILnYeCjchXeRQEjjG01UQE1a6SznwhZnOPN8SjsFuhzrtAg8Vln3CU47J1xNhEiiiRMW4z49lFUs96qdpv6r7xm4MstNKpNkiwtgkkEBbI+22CraPHnFmbwxW9LG4BbTseD+6LUXJ598GldQEEMcsSH1M4JQKfo9SIopbA6fkKq/ZiN000619yimk38y61VOzyCTMTs5YeNX9alWNNyZTMyRS+eOofkkuL9e/9ah1UXUNyVxr4Pdpz8rGBP4JQeNNki+emGRJ47kTt/x7hVns81Eczof1eCo1n9INx8uw+fwKfHLaaKW+FTlpXfiH5xXJwMqOahh2cmc4D8SoOJ2WSUzTA/s4J3537XAsmfxaWEEVfPbq4OmiFbdWL9gi6rPVi3tMomammFrqz767+tKBEU6qqOFWLPE9JsMhgxsQsxvro3eC1RtB5qEos8VyseMCsYUSqz7JPMTFyE7yjXhWtPqpVbvY5klIFLkC/MTd7cKUsOZL4W+1S+tEvlsZiFs9VlQPs83H8IdJmvoy3IdpynKOqgqKDLwNbDxfvje6mGen9Q0bHAr2ZPCzSLC/zQZqbKRWt8jLYcTp3KXUVjjzlPG3gvoTR8MB75ZTnWkpRrAhzLlegssQMu5vyldWmDKiXD0i/UyKCfHnxJZ7aKAudIq1C6/LHQ4LzP1lGdaF0rgajBN3gx1vhAOJM1J4zjQd9i4op/oxHYbY6s7g48n8Ktg0xI+y8NsD+1kz4JS0wuF6VOYUMA8hHrqzrq/MCghZwc7QYCjjGOoN56t8clY6/FS9W
 Do1zifOr
 ZTUhlPRWCReVwVjGej2hHbn6d9VOMldKaRy44S/FIqgvQtef9lIexMSnObeseF3r1bDLbaxQ1HobqnWTm0ZUcz6m4qgs3Exxi44y94w59wyhcPPrNl78UbbBJWrq/AFzik2BwpdEsHnXQUKv5LDk5zZ5dwjGuzn+/f/mDYWU4wxriiSWjEMdQcGIESPvlCxcef5QPDSQVXVLVi/ocpCxJfBUZIQ2lxPYcLT26d1uj8GHonwlPLQBVsQJRyRc8fICqE6UxaskAl77PMm0IOVhzbkZiOvbFiomihPXpVL9t60yyJitgoCQTuV79CMPosf9+EK+NwvFwy3QAOcKYkBtqOz4y48DKEYG/UNGDF/3fEWD7Aq4Q+RLvmK7cyAfLEqZ3IswvhONeI+7lvYuN21zZDeglgct0TzeE3EhDu/1q+VL+HfDZq65g7iD8DP0uOPrdA0MH+nddBgTa6K/HVExpM39Jew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:45=E2=80=AFPM Lance Yang <lance.yang@linux.dev> =
wrote:
>
>
> On Mon, May 11, 2026 at 12:58:03PM -0600, Nico Pache wrote:
> >The following cleanup reworks all the max_ptes_* handling into helper
> >functions. This increases the code readability and will later be used to
> >implement the mTHP handling of these variables.
> >
> >With these changes we abstract all the madvise_collapse() special casing
> >(dont respect the sysctls) away from the functions that utilize them. An=
d
>
> Nit: s/dont/do not/
>
> >will be used later in this series to cleanly restrict the mTHP collapse
> >behavior.
> >
> >No functional change is intended; however, we are now only reading the
> >sysfs variables once per scan, whereas before these variables were being
> >read on each loop iteration.
> >
> >Suggested-by: David Hildenbrand <david@kernel.org>
> >Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >Acked-by: Usama Arif <usama.arif@linux.dev>
> >Signed-off-by: Nico Pache <npache@redhat.com>
> >---
> > mm/khugepaged.c | 118 +++++++++++++++++++++++++++++++++---------------
> > 1 file changed, 82 insertions(+), 36 deletions(-)
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index f0e29d5c7b1f..f68853b3caa7 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -348,6 +348,62 @@ static bool pte_none_or_zero(pte_t pte)
> >       return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
> > }
> >
> >+/**
> >+ * collapse_max_ptes_none - Calculate maximum allowed none-page or zero=
-page
> >+ * PTEs for the given collapse operation.
> >+ * @cc: The collapse control struct
> >+ * @vma: The vma to check for userfaultfd
> >+ *
> >+ * Return: Maximum number of none-page or zero-page PTEs allowed for th=
e
> >+ * collapse operation.
> >+ */
> >+static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
> >+              struct vm_area_struct *vma)
> >+{
> >+      // If the vma is userfaultfd-armed, allow no none-page or zero-pa=
ge PTEs.
> >+      if (vma && userfaultfd_armed(vma))
> >+              return 0;
> >+      // for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
> >+      if (!cc->is_khugepaged)
> >+              return HPAGE_PMD_NR;
> >+      // For all other cases repect the user defined maximum.
> >+      return khugepaged_max_ptes_none;
>
> Nit: kernel code usually uses C-style comments. This could be:
>
> /* For all other cases, respect the user-defined maximum. */
>
> Also, s/repect/respect/.
>
> >+}
> >+
> >+/**
> >+ * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map s=
hared
> >+ * anonymous pages for the given collapse operation.
> >+ * @cc: The collapse control struct
> >+ *
> >+ * Return: Maximum number of PTEs that map shared anonymous pages for t=
he
> >+ * collapse operation
> >+ */
> >+static unsigned int collapse_max_ptes_shared(struct collapse_control *c=
c)
> >+{
> >+      // for MADV_COLLAPSE, do not restrict the number of PTEs that map=
 shared
> >+      // anonymous pages.
>
> Ditto.
>
> >+      if (!cc->is_khugepaged)
> >+              return HPAGE_PMD_NR;
> >+      return khugepaged_max_ptes_shared;
> >+}
> >+
> >+/**
> >+ * collapse_max_ptes_swap - Calculate the maximum allowed non-present P=
TEs or the
> >+ * maximum allowed non-present pagecache entries for the given collapse=
 operation.
> >+ * @cc: The collapse control struct
> >+ *
> >+ * Return: Maximum number of non-present PTEs or the maximum allowed no=
n-present
> >+ * pagecache entries for the collapse operation.
> >+ */
> >+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
> >+{
> >+      // for MADV_COLLAPSE, do not restrict the number PTEs entries or
> >+      // pagecache entries that are non-present.
>
> Same here.
>
> >+      if (!cc->is_khugepaged)
> >+              return HPAGE_PMD_NR;
> >+      return khugepaged_max_ptes_swap;
> >+}
> >+
> > int hugepage_madvise(struct vm_area_struct *vma,
> >                    vm_flags_t *vm_flags, int advice)
> > {
> >@@ -546,21 +602,19 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >       pte_t *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> >       enum scan_result result =3D SCAN_FAIL;
> >+      unsigned int max_ptes_none =3D collapse_max_ptes_none(cc, vma);
> >+      unsigned int max_ptes_shared =3D collapse_max_ptes_shared(cc);
>
> Nit: could these be const, as David suggested earlier?
>
> Nothing else jumped out at me. LGTM!
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Ack on all the above thank you !

>


