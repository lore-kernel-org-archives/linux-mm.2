Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E77CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77796B00AC; Thu, 11 Jun 2026 12:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F396B00AD; Thu, 11 Jun 2026 12:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9657C6B00AE; Thu, 11 Jun 2026 12:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8658B6B00AC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:37:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AD5390FD9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:37:30 +0000 (UTC)
X-FDA: 84868187460.23.443EFC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B7ED0A0015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:37:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gy7H0iuv;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781195848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lo2BJAapvZJXWOBDzrRCDmN5WtMov6d+Ohtu+DitNMw=;
	b=vxsAUx2rq96pio12zwtZ6BVYCFVGTCl9lS+1V0HltgoIuafUXQxij+0/LWpQwtvvMyme/c
	3ZeY+QAPg3nvjnnVJWV++Yv+foYAGdD8A4nnl4Qm9Y/qvbYBWxrslt9dkyyaEkxSzkPRRn
	2J0yNknl6RB6HjLEo6n1hUahQqR0pO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781195848;
	b=T54G8+RgDKMXU/eoRpPRN8Ay5IJKDHJEphq7NqIaFFMgqS5wOdtc6SGNegBV2b4ehxajGZ
	+H/rvA4wwIE0DGooGSsygT/HycCChw9Xp6+7Z+V608LqwC4QMfghxMdUc005aMsHq0evKt
	O0+y2gy/bL7bGyeYrTiHtdoDdxKK3ew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gy7H0iuv;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781195847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lo2BJAapvZJXWOBDzrRCDmN5WtMov6d+Ohtu+DitNMw=;
	b=Gy7H0iuvwtQLYLxnJ9X3AxhXcQ5dXhoz8rwlEuxg2FJjkLZ4MPuXX4jh9g6qNSuQ3up9h8
	2wjDhIqslmwEUf2GkmQvQlje6Bd8tJ/nVLSU23d67DShuk/vNNB3atFOGK+ACPhODKwf+Y
	Y3pDoHFhki5sLhtkOK0rt2OHNnNn9bU=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-FEYp_JJ8PnKXxN3CklFQAQ-1; Thu, 11 Jun 2026 12:37:26 -0400
X-MC-Unique: FEYp_JJ8PnKXxN3CklFQAQ-1
X-Mimecast-MFC-AGG-ID: FEYp_JJ8PnKXxN3CklFQAQ_1781195845
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66053e40709so113689d50.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781195845; x=1781800645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lo2BJAapvZJXWOBDzrRCDmN5WtMov6d+Ohtu+DitNMw=;
        b=ZB81KXbqS5kKspFholdoSjTTRWJV6Zwc29B4lRrUZGtG77jwcvVuseKSs5n5UXu4G2
         0/qlGW1fUalkKwGljw9yA7ovdaPRx05u0KG1NV73PmvqGK9aYvQbF7m/Z9iMrGhO9dFg
         mY/XQ79WVvXBkEFPJaP5Y3OPPvqfk7w2ABXOFkD5I4Cy8jVKk2YnQBCNP0kqWMWGu/I5
         nNr4N+yqb9sMbIymm64zrOAeLw+PbSAOiWiCmMCOVHtFFs/xK0nEwFoOyWxWTiHqNBM2
         v857ybaAdd/bVK04PvtxjdqAAyVbJ1ByUsPRmLaA8OShh/zdhD/JG2YVb1h5V5HK8Di7
         AB7A==
X-Gm-Message-State: AOJu0YxR6O8lW6F61oFtZoi6pkwjfzvQmj5uJlVbfCrigeO3vZv1jm5L
	jGtrpGiQ7IdkV1fezUYfYN2KmFvdH9wKQxK72bOeIuySxVh5cr+ayPaOJSvLG/AdsvfBQQWpz13
	pNrHH3Ehjk8qlS6fgU6UyxBI+CGaaE3T9F8XbDqxAt34PT7sQwJPJmHZcg3rW5FUj99/l+vd2f9
	iW4MPWe7h9DFhs3AgTeoTNeFSKrVA=
X-Gm-Gg: Acq92OE67qnoR4a2Nh21upjnL0azW3oCZKM3nYrAa+U0LyEzshxjWpA2un9anzhrs7v
	YkDFbAjO2vQRNknQrvkRKFGDjKyg7Z0MPWHKQQa3soFTjfkMVtDKgnC2/Fr7DV6/CVQhakzW4tc
	qnwv4nCSmZyLXsgzzAemmf8xQ56QBvoRRwbYEePvTK5MqdRXNcsNihhAzr4kQhIQwGcl5ODluxT
	Jq1
X-Received: by 2002:a05:690e:1c07:b0:65e:9e71:7942 with SMTP id 956f58d0204a3-66269821a84mr2395909d50.37.1781195845234;
        Thu, 11 Jun 2026 09:37:25 -0700 (PDT)
X-Received: by 2002:a05:690e:1c07:b0:65e:9e71:7942 with SMTP id
 956f58d0204a3-66269821a84mr2395891d50.37.1781195844844; Thu, 11 Jun 2026
 09:37:24 -0700 (PDT)
MIME-Version: 1.0
References: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com>
 <7e7cbc60-e9c7-4a63-9d4b-4e8fcad7bfc0@kernel.org> <58760bd8-4979-4fb1-96a3-eb94f0e8ca0c@kernel.org>
In-Reply-To: <58760bd8-4979-4fb1-96a3-eb94f0e8ca0c@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Thu, 11 Jun 2026 10:38:12 -0600
X-Gm-Features: AVVi8CeRiWREUqKN2Q_Og2MjBU5y5YTHpA1HPOjpENVr0n3Tq-KSA69EjhcH1X4
Message-ID: <CAA1CXcCuk+3T98i01fAbQ-MSDX-f6ZdpE7kTbC_TwKObJ9siwA@mail.gmail.com>
Subject: Re: [Bug Report] Elevated PMD nr_anon after running selftests
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linux MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j15ls7RqlsfFW63RTfSpOeufa9YoE2mOhtQB6HE0rLM_1781195845
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7ED0A0015
X-Stat-Signature: ch3ktufzhy8uagbt7gebmjp4ahcbz3py
X-HE-Tag: 1781195847-740554
X-HE-Meta: U2FsdGVkX18Nl4ggSaXhFxPHaY2D0k3sKy5WMlE4AnNlK1ezJxhwz/ygFtecd/Pxr+FS4GpcbcvesxIMilZ0C22pxqjKXsfERkHdVl5WeCamTgrx4od5z6tqJOsyQrQJ5wyTZSAiQfrdh/xmjZtwcRc6GSMAU2dORpzna/icwPk5aSu+gSPA/OFPZ2iFnbeBc7zovLKNaPXzrJGsUdIgEr09Iv7+h4CdUIGVRNDJtiPiaVmxHQMbPDLvbOIP5s+i5Qzxp3qcDu+xywI+rozLIQpa2Oz6aU4eyNZp09ZT0xakhp5006paKH1rO2wkR5xbzdPjkdImAE6pvsCwx//Dl7WAMYAqcaWAVOxVmMUHjiImoIjPRhCfkUFD3HWj72dpUjdcu6AhNbuBbSn7GJV9YGsLIPaNKT+EdYR6EvogNNTsFGvPJ1+FuclLUr/dgMJ4W4CMavR67JXCtGJdo3zUUGqoRpeRqMoRRGTNUwbY1jf8b/UPRkwYrtjsCo3+UIwehRzJmPVrr4J2tMdt6PMsLzzZIxRq7cjR8Q7EWJwwF0c9e1cIEw3KWD9lrIH58GKpx5f64xuMp8reIjUoHyOLXpwSNzy5Hhdo6i0lreb9pt96k17PvTbzP9u3gTyFsRrUml4Jf7ve7iV18eB2SBq42J205td/wzLIZQ6k9iJV0o+vipvTcRoKe8U14sO5DUeqCtt8vHR68BmdNvlEMYtNhOoKN8WSrUEpwUkgukMzLX9vQsvcITtmVMLGqTdsfAF3flbMfZVsUUJqz2k+b+b3XERrUP+amKA+dHyfqa3+eB1K+q+l0rww2uU2Y+yvydVOMHup8cNZwD3yp1qRRg8MoqNoxpvW/+Nfd4rneodDvOKFChENQ0J6/kCPOGAYHm/c3W7CyD9DgJVbnVDH19sG6Az7YV8k8G/epTenSE4m0QtTXL31f7/zRYNLXkczs1Mhtll1sQe19kYxrQykOGc
 GWppc3Yb
 Iqb4T1oTEauZTBKMyAOrtDkCGmo8xuJX/QZOXpHzK1BOecNX2mWeTn7DT9j5+B+AIlKuXIJR/EI84GWhHUasUGP5rFdQ27EGydLPIJ93LmR42qKCIvDqGa1Hn/XHTDDtRspuGQSZq0OPU29oQIQ5zCtG34BdZjo9UZGHVf7tJAxe5GziaccOeXgdxcTco76nxLwKn0o4ghF1F+cC4oAox3iWYONsoZdEEfdSDIUAQPfvTGodzpf5HGKlco12D0qAod0bI+JKRKd+knoG4pkWpGJiRlh82J/qNgrMI8ORSh6yQWD4Fupwf7waillNBZROxpH4UaEY4xnPVZ2J3O2E+US6UkY9ZcnGKRICAou3Daa65isoq/hebM64twKNRlQVlkXicCVlLwvptgIWl8L0cyWSqmkT1hRQQF7JdH16VyRj3P9XwJ6R46m2K48rFsLLLzV0Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:24=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/11/26 18:09, David Hildenbrand (Arm) wrote:
> > On 6/11/26 17:58, Nico Pache wrote:
> >> Hi,
> >>
> >> While testing my mTHP code I noticed that mm selftests caused an accou=
nting error in
> >> /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon
> >>
> >> At first I thought I might have caused a regression, but when retestin=
g with 7.1-rc5 (without my code), the issue was still present.
> >>
> >> This issue occurs in two mm selftests:
> >> 1) hmm test
> >> 2) migration - private_anon_htlb test
> >>
> >> I spoke to David about this and he suggested the following diff which =
seems to have solved both issues.
> >>
> >> David would you like to send a formal patch or patches?
> >>
> >> Cheers,
> >> -- Nico
> >>
> >> Diff for (1)
> >>
> >> diff --git a/mm/memremap.c b/mm/memremap.c
> >> index 053842d45cb1..683a77dd679d 100644
> >> --- a/mm/memremap.c
> >> +++ b/mm/memremap.c
> >> @@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
> >>         mem_cgroup_uncharge(folio);
> >>
> >>         if (folio_test_anon(folio)) {
> >> +               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -=
1);
> >>                 for (i =3D 0; i < nr; i++)
> >>                         __ClearPageAnonExclusive(folio_page(folio, i))=
;
> >>         }
> >
> > Wasn't there another issue with hugetlb?
>
> Just realized that you sent this, but somehow my mail client got confused=
 and
> hid it.

Yeah, sorry. Thanks for the message about the email client setting I'm
probably missing. Thunderbird may actually work for me now :)

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


