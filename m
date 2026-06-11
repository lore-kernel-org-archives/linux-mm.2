Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C2ACD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E206B0099; Thu, 11 Jun 2026 13:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44FE6B00AC; Thu, 11 Jun 2026 13:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B0F6B00AD; Thu, 11 Jun 2026 13:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A69AD6B0099
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:23:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53CE2C20F1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:23:53 +0000 (UTC)
X-FDA: 84868304346.20.F0306C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CB99100015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:23:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KkvNm6Z1;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6i8jLVdQ9iH7gHU8yzBEQmG3u/XRRqWxD3Id53UKfb4=;
	b=i6pHGgP/0ncVkpNHhqdZDdw4RS8EMIi8XyFKA/du7jWyuFQzSgso3lrhFrbSgEiOHGZP3h
	dc54jhhk7Kn34QTTg0S2q5b0aDJo081SJJ8Snikk1xbjfmzXsCJL78w04bXIE112MQI2jv
	gOn5VVdy6DdxcmtlC/3Km2GkSVEyeW4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198631;
	b=i5Smhu0RcSYLmIX/6Ie7xF0f/VWtfBLDxclDQ69CYTDxMVBQPsQ0xkVLSLdmWJtc9m/yDf
	jTCZtW40yJZCvEdokSK0m9Cv46gBfAtAINYhpFdP0hSZKxQSVE/glMLuLFN0Qa8m+ZEcjx
	HgvIAIZL0BCqbqyevPSPg7aRvKuseGY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KkvNm6Z1;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781198630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6i8jLVdQ9iH7gHU8yzBEQmG3u/XRRqWxD3Id53UKfb4=;
	b=KkvNm6Z11ybdrl0st+1xRzs1NbFpbWKLtQTKBAZFyfT4/n49k1/aGYIofZokL6eZ9G+u6G
	hqqWnV7hZ3l6UozvW2D0m5snWdjWByr3LLQ7eq4Nf4Se+fDTylMfJ7rb5kS9KN0kJlMtbl
	Xqw7RYxiguujzje1h1NfSec3wvPrLVs=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-09XUk00GPAO72cmsAC1AOw-1; Thu, 11 Jun 2026 13:23:49 -0400
X-MC-Unique: 09XUk00GPAO72cmsAC1AOw-1
X-Mimecast-MFC-AGG-ID: 09XUk00GPAO72cmsAC1AOw_1781198629
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6607988ca90so170000d50.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781198629; x=1781803429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6i8jLVdQ9iH7gHU8yzBEQmG3u/XRRqWxD3Id53UKfb4=;
        b=bBwAz438DjqWZ1ceAwx/tx1rzF2PBJ8xO0GjaN2I4sIxS8FJ5ekLsQO8Jsi+VRPvxd
         CnOqJrOmEbO4rYxenbZs+nOvDhxGpVziIyfmlST1UQH55GmlEtpGxWNGm/H6Ev50JBa0
         Sf8NozlqmuaVXbxvUcHCwpQDLDw7CnJ/CG2hRar6p8I8ZU4em90RldRUHyDA5EAHRRb/
         ifHasi6Niag2Ha1JjjGHoYDHiJa7iKeNvXDeqPfLqhoGJcusvo4Wb8HNMzJU+emJPfgw
         r+F5+KBK6cbflsIRiWWDgwCihbtVgIy17qzerLrFbyUewXUhKOrNGktel4zTymYQz4XF
         8SQA==
X-Gm-Message-State: AOJu0Yz6qnmR+F55ocpxvO6IMbVC/Ww2jeUCOv+A2Thsibm+TZdSxP5K
	bkkqSl9dXmUcypOtv9/QBtBeokpgu4Yf/+jpESSVlBoWaEbtk7lCLdwyy4Is4hG/+P66wcu4ca6
	5gmcGvSMLz9sTQDIHtA3JA82T0gYxKmYI1YsKGoUQhLOEs3vFmBiU/orNXLIhifRIKcATrMQYjN
	EG+1wCwdIx8TMPepbF7eznmrFFqhc=
X-Gm-Gg: Acq92OFH9v/RfB3gZwhhkmAXsZpnKMUtn5j+JbORhUVz0SaiSTVJLx7PjQE28Lpe9bN
	1sbfRssk8hyxgPaOSSre56RdX4YR2Q2HYMotBHVhCzpTg0sISl6JK+7wtXrE8oSvz007xVozuRw
	U7Giq2rHHc1CKBuBQ6L2ktcDtTs2tamkKQ9HS8HF2nwtlaLRFuGwpIARtTHuHk8uAzx07alBH2i
	cZX
X-Received: by 2002:a05:690e:12c8:b0:662:5ec2:8e3c with SMTP id 956f58d0204a3-6626960d510mr2985920d50.4.1781198628583;
        Thu, 11 Jun 2026 10:23:48 -0700 (PDT)
X-Received: by 2002:a05:690e:12c8:b0:662:5ec2:8e3c with SMTP id
 956f58d0204a3-6626960d510mr2985896d50.4.1781198628052; Thu, 11 Jun 2026
 10:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com> <aireq_jrgKH0zsNy@lucifer>
In-Reply-To: <aireq_jrgKH0zsNy@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Thu, 11 Jun 2026 11:24:36 -0600
X-Gm-Features: AVVi8Cc9AyMT0x4hZewByKSnvCI7sNJtuPeLPz0ZADonrkvnlD7gQM_HjWEylw0
Message-ID: <CAA1CXcDbynmd=otyCFdM3W9gV7HseQ2qREMXGU2ngwbHwofwcQ@mail.gmail.com>
Subject: Re: [Bug Report] Elevated PMD nr_anon after running selftests
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Linux MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iwYQn3GbtM6XyMi0XF10gS51lgA32ShEAjnJi9LDx4Y_1781198629
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0CB99100015
X-Rspam-User: 
X-Stat-Signature: uq333p6ba1askowjcy89pwgtw33zktfz
X-Rspamd-Server: rspam08
X-HE-Tag: 1781198630-786652
X-HE-Meta: U2FsdGVkX1+44v5obbZ7YoPiQVUafeNa/EewAWWsek3I2kMI9wD4hXAtFDOTWhiFDvcVL3vkxNvGFEulU2ATWZguVHhhsQMxz0MK1BXgxfunzCbGJ5sX4Mww6YmOdI2eKPKvXuRKfuG14imMJcTvsJqnkll44R7cWa/YonLI7x9gwcSzpaAoon7ZJsBLMpi2TdbL/bMBtTTPc+94NkizzJmc1ZJ+4PKHzsincsqvpatPk1rWy0UsG0DEtsbEHcfP8jo5CpXdXkiwh7MAeJegFGdfrgB3vvqsYuzEXMvLSlUoHT1H/VrVhRcpf7khfn2fFdnK0iyDWXZg0HzpcFZ7u6UcLkBTOH+UlJEAY3mwyosFlTWP/ZvnvkZ9Z2fZYlqt0C90AbjA2sUvlJR5xmYfTRmEl5IyDqqvua7mAbsQfUudRDBN5EJKXtlvIK6LbsG9aNs9UDFkU8i7tBmH7BWeGyB0YKeiEoHfLF0OUiCxm+CDoTPvIv21xeP7y47qtA6CuejX3wKLxJzNIG/tBk5EqlQkedBg0MSpo+FhTZzS5iLz9ngcZYFFvKlcw0/wdbipvzJLDdtIbIYDwIEh7IsOtAgFvAx4I2eUyN71gh6VysDGRdNL1XXjkyyeqqgYLwO83j0mN0XVlQv2g+SwZAC0XVUo2ZH82wOtwXDauSfLW6l1Tqj7k/CPatKLlw/GP1MkwHAYNJEHPp7EMPzRU4gREwmKS8vLoyDjAnc2HX2HuRQot4ysaWbTpebziL3nrNpDbtC91JImEpfry2YgL2ldrRWbVmcJwFaHenZnAlZbUGTi+mFsXkQ4HmYkRlhR0S5M1FmoAfei0JTKK6ZHlsGB3R1c0jAeCAkrn/0jny0Chj8I2D5YjNo/SLih9h9yb/aEIHFh4bHdVZbDEOsSOpEsca8o8KwTMzt21gP6Ze+9asul90oeOVVYyiW4MThQUMXwAL/S41PwJvcXd1z1Zbk
 r/bzhk9x
 M94svWtHBocyIwqeZUU8SjVig1e/yN93XcxkT95y6jUpEcr5gPWae5Nvhap6y30yHn4wiDD7jbv5nag8X2t8XhtAr59jt6sEmZILL911bnm/T2QX5zMh4thklKtIdyHLnxsTa4BWYYnPU+OJyj/9+5izXNCP7nm0jHVv7R9N8gheTU5OVPDZuabcd4TReUVnwV7vRnv6C2vA5h+3QtjHnDth3658nOHd/59B5M6RmH4M45NGsneygk2lh+VkiH75uXsEgsMHM0uRAz4HePPyVfzAz/4nGiuJLy8rVRps1HvY8V2hY0rbKUOeT6fSBYAmooKXf7DUe3O/sRC+SQ8ihuHn8EdBM5p9tgJcMM2iXq2udNuEqVqpU7UpaBvXZBv2WeuIqpv6Ly+HwqD6GKrXDxCnr4mTklbpsGQ6Q/YpZCv+3riQr3GLtgDXobpm0cVeYkDpG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:39=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Thu, Jun 11, 2026 at 09:58:55AM -0600, Nico Pache wrote:
> > Hi,
> >
> > While testing my mTHP code I noticed that mm selftests caused an accoun=
ting error in
> > /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon
>
> You're not giving any details? how does this manifest? How did you detect=
?
> Output? Etc.

When running my mTHP tests, I always have a terminal with
watch grep . /sys/kernel/mm/transparent_hugepage/hugepages-*/stats/nr_anon

I noticed that when I ran selftests the 2MB count remained elevated
even after the tests finished and the system memory was returned.

e.g)
/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon:34831

>
> >
> > At first I thought I might have caused a regression, but when retesting=
 with 7.1-rc5 (without my code), the issue was still present.
>
> Seems to be a regression in your editor's line wrapping... ;)

Haha yeah still figuring that one out :) The guide on setting up
Thunderbird recommends wrapping at 0 which seems wrong...

Hopefully I have it working correctly now.

>
> >
> > This issue occurs in two mm selftests:
> > 1) hmm test
> > 2) migration - private_anon_htlb test
>
> OK that's useful, but what exactly happened? Any test output?

Tests seem to be ok (although the HMM tests fails, but that's not new)

>
> >
> > I spoke to David about this and he suggested the following diff which s=
eems to have solved both issues.
>
> Whilst speaking to people off-list/elsewhere etc. is totally fine, I'd su=
ggest
> engaging with the community as the first course of action is often a good=
 way of
> resolving things.
>
> Even if things arise from private discussions, which is also totally fine=
,
> please do give sufficient context so that the community can engage with i=
t.

That was my goal here :) Perhaps I fell short...

>
> And I would suggest that ideally you phrase things such that you are aski=
ng the
> community as a whole :)
>
> >
> > David would you like to send a formal patch or patches?
>
> So on that point, I understand you're asking David specifically because h=
e
> suggested the patch, but I feel that you'd get better results making it c=
lear
> that you want community input :)

Yeah I didn't want to just send a fix that wasn't authored by me, and
I didn't fully understand it. When I brought this up to David (during
a separate off-list conversation), he suggested fixes within minutes,
and asked me to test. This was the formal follow up.

>
> As one might misread this, and perhaps other such occasions, as you feeli=
ng THP
> =3D=3D 1 person, which I am absolutely sure is not how you feel, but phra=
sing things
> a little differently would help underline that :)
>
> Kernel review and maintainership can be rather a thankless task, so detai=
ls like
> this matter I feel! [and I realise I probably screw up on this regularly =
too so
> we're all constantly learning :)]

Yep! Still learning (and often failing :))

Cheers,
-- Nico

>
> >
> > Cheers,
> > -- Nico
>
> Thanks, Lorenzo
>
> >
> > Diff for (1)
> >
> > diff --git a/mm/memremap.c b/mm/memremap.c
> > index 053842d45cb1..683a77dd679d 100644
> > --- a/mm/memremap.c
> > +++ b/mm/memremap.c
> > @@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
> >         mem_cgroup_uncharge(folio);
> >
> >         if (folio_test_anon(folio)) {
> > +               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1=
);
> >                 for (i =3D 0; i < nr; i++)
> >                         __ClearPageAnonExclusive(folio_page(folio, i));
> >         }
> > --
> > 2.54.0
> >
> > For (2) he suggested
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index d9b23909d716..9fd50ea25d2d 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
> >                 /* No turning back from here */
> >                 newfolio->index =3D folio->index;
> >                 newfolio->mapping =3D folio->mapping;
> > -               if (folio_test_anon(folio) && folio_test_large(folio))
> > +               if (folio_test_anon(folio) && folio_test_large(folio) &=
&
> > +                   !folio_test_hugetlb(folio))
> >                         mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_=
ANON, 1);
> >                 if (folio_test_swapbacked(folio))
> >                         __folio_set_swapbacked(newfolio);
> > @@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
> >          */
> >         newfolio->index =3D folio->index;
> >         newfolio->mapping =3D folio->mapping;
> > -       if (folio_test_anon(folio) && folio_test_large(folio))
> > +       if (folio_test_anon(folio) && folio_test_large(folio) &&
> > +           !folio_test_hugetlb(folio))
> >                 mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1)=
;
> >         folio_ref_add(newfolio, nr); /* add cache reference */
> >         if (folio_test_swapbacked(folio))
> > --
> > 2.54.0
> >
>


