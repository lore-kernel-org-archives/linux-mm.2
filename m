Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96989C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 22:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E3D6B0088; Tue, 22 Sep 2026 18:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455FA6B008A; Tue, 22 Sep 2026 18:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B5F6B008C; Tue, 22 Sep 2026 18:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6876B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:00:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87B13A0658
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:00:03 +0000 (UTC)
X-FDA: 85242766686.07.B73E3B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 100751C000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:00:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YKF9oE+N;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790114401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mM0cgRvC/5kn7Lvpmed1628Qv8jGLnHSmTJkgn9H91Q=;
	b=iM24aUcpLqrM6idDpkN9nm4TCUv8GIfvoEVlzxBgu+ZH7b7P6M5HgbXu2jp4QXkbaXffVY
	EL33PcyHxAgZlv/jRik4oXnwVjfpBxiw1r+U9rzbrRgcfaKINIYkhUA7adw4sEYRavhgwS
	Oj7k4a0onTzhPyHuSkrmNx6mQ5m3C8Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YKF9oE+N;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790114401;
	b=VVePzwOIRUdijnjQscnKSxMy7ECyp56au+2ue8ZgYHFFMKxm3XCuWyYCDHqX9DwfBQ5uzk
	LjkIbw7amb787FxgQ6pPDAcmYE42y1xPLHMDho0uWODcGqdHs7BEx3dHNxFs/7HWVcJTDe
	3gGbU6UYhf79+T55dTdrmNWXqdTSGxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790114400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mM0cgRvC/5kn7Lvpmed1628Qv8jGLnHSmTJkgn9H91Q=;
	b=YKF9oE+NNo6ecaaBAmYbAjEQp3GSOj8dnSarYpuwavx+gSBlsJFatWAfOe/kmPTpeT4kSL
	8Nf0adB8rWACDxqurknAFKpvBUV/av1b/JE0madoigBIbgKTuRdi+317Uersiluy/pj0jz
	4DIar7rCG1gJmfbzVwARL+HZKDrdIhs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-L_mS7JZ6OPq1HXVvABbIhA-1; Tue, 22 Sep 2026 17:59:59 -0400
X-MC-Unique: L_mS7JZ6OPq1HXVvABbIhA-1
X-Mimecast-MFC-AGG-ID: L_mS7JZ6OPq1HXVvABbIhA_1790114397
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3a3395e2d7cso1016301fa.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790114397; x=1790719197;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mM0cgRvC/5kn7Lvpmed1628Qv8jGLnHSmTJkgn9H91Q=;
        b=V43hXTw6vsgfgEEm5uTIvJLAHF4IGfSY2Ch3yQjOBf4xG4wEz4gb6CxMzvZyt15AYv
         7bxftzKQxDB6fwXnkXjNSlmFQsu7QjPPOYFwsv0XXo/FbU12Wh+AZwvYMxNP6scyW1ce
         oi390JMFYn7ziFHezStxre4xNeRclDXo4UwgtVTh1bsc3dNjT/Sby9MIyC54VBI93aqV
         YPfeyzAg53cHcNFedwryl8+Bt/znZHtngzOMrZ9ZmfhHqmSNaauzyCnBxm7irDYAohYk
         GwYwL1JPnBOkfJ/HVavA80LrY/0lIBPfC1mb04exgW4Mskmfe3G33M+OFHPgBOw+B5Mc
         6bzQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRZ/m/lbcMeZIRrtBdknnb09HJrVFS88r/0o9WtFCWZecDw59MaB7ZJ8y/CDZ8s7zB/FBwtkg4Jg==@kvack.org
X-Gm-Message-State: AFuF++mC6o2dTyDZ0oXhNTO8RXm06XVzXum0mMiuo2QJDcadeVutGgYP
	ST6yPWSjJ3rMBx4SHYxyvkG4QVYukuOIl8yTVAE1Qhg/ZT2htfxu5ZT859GrA0qdTBneUlrXcQl
	G75hMIMwcYv2k2eMNIQAObWN4y6WlSUjT/PFibme2820TRNQc+4AGMZ6f3Rz1XguLxzPijjhu+c
	aUVhWAfyAzi0Qmc9Z+BjuaA/YsXHQ=
X-Gm-Gg: AYBFou0qZDym7gDT924QfvpVRkXrnxh02+Pgg3T2wQz9h+r+7xsF3mLkLV3vumPQE54
	XPDJ1iDat/eQwOrIhkx+TTuwEBhcBlXdEIVV4NI/iSLKt9ULaQq9tayfLCoP5OCfLD385/PJeoh
	iz78MEMf4asNmQZgK/yQhsGgJQACVlpF0Gsd1Xk1aZe7AnNszbVu3PWIFmNZsO+orVz/dp0No=
X-Received: by 2002:a05:651c:a345:b0:3a5:afec:9cf9 with SMTP id 38308e7fff4ca-3a630636639mr1373771fa.7.1790114397209;
        Tue, 22 Sep 2026 14:59:57 -0700 (PDT)
X-Received: by 2002:a05:651c:a345:b0:3a5:afec:9cf9 with SMTP id
 38308e7fff4ca-3a630636639mr1373541fa.7.1790114396764; Tue, 22 Sep 2026
 14:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev> <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org> <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
 <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org> <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
 <004bdc87-8c8e-44f8-93c3-1ae0a47051a9@kernel.org> <CAA1CXcA50Lfeo+JkhhRc5b8TNzBETj8+z6iMVuqwUSJhyo2G8w@mail.gmail.com>
 <1da189ad-a7f6-42fa-a1ff-a26cc5e5c563@kernel.org> <16f9ea47-99c0-4483-a12f-190047c1411f@kernel.org>
In-Reply-To: <16f9ea47-99c0-4483-a12f-190047c1411f@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 22 Sep 2026 15:59:30 -0600
X-Gm-Features: AclHuK9WwgmixPJvrEj0pD6SO3OEeVNSFswDyCTO-YEmp1_v-PaHn2OEu8s3wfg
Message-ID: <CAA1CXcA1iREtxkZzwc8ib5h96DQzX627W3-gnRiafdjRG7BKrw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>, ljs@kernel.org, 
	xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ubc7tMqoM1S9ZK9tteVWXSW6l8yn4y_Q4CXFsFfFK44_1790114397
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 100751C000B
X-Rspam-User: 
X-Stat-Signature: 5zdgthsui5s9tkiqzjc7aiorb8un445g
X-HE-Tag: 1790114400-698151
X-HE-Meta: U2FsdGVkX1/PoCSpqgBjDcYaPq4APzUiCZfUVtAeDLhwHzl1jnm6c2bWCu7VTKswAZ1imXLBk49sBNB6p3SVCJ1cnu8Kk+axizbxuR3oKcuPdCZOIm5fjrnQKTD5mGu4u82dejiHIQzCv8zvfoS7uFaNdVWE6J+wWULykyOd4iSSa9SKVNMvTjnk1Z7owNKHNo/vdG++KwI2cECDdih35O6VsAO35morOgcUG+F1JCKN8JUW4ZDMqb5VE3ODeG4JKt4Fa3Ayzx8o5eJht0lFQfWtvoGFin4jXPKQi95K4LcT1qL50HkpN3GvqCvIS6NG9HFPzOnqvZIe3bvBa/Ob+s+TC+8s5UiD2Xx+zgu5fv/jFo++NWK8/PEBwdfixPFjT8bvQIGKSRor3+G7HJ97bk7r8s5OQLgKSUK6E4cJfrCiLY6vyMBHNJpdljgnxcdqhE8gcr/v4fGu22hjMkN5IyGNX0ci2kMuoSfeWjBD8lZQ7aG8UoB78FwMe3hbXyeCUd3nQtaPIJySfccDBCYD/cGIihjc9PGqOOH/EHH+twr7R5i2o+LbXk7asint+VpCLX8Ou6oYA6zDyoKLG6L1uUIM5KFqEUFUk2mXIf/VKNn4Obb9AepfTn+RuBWz4iHM4wGbQGtwKZwrQ1ARkWNSkZvYXvJGQhB5U7IN/5u28k0xabIVqSmpgRLqijSAgOipGwnhhjZ1UsHn6cfdjT7GwV/B8ly/WN/gO1Gi4NeiLPB/syHjmQSqZ8e21+ewVlL/gZ7W1sY9/SGyOYyoq14o6Q31S5d9St0KavkYCyPKMBRxmqYJVoIBmFYOBQDUDDzXUv5GiKlDLO+lbmZE5+ztQslu3pWrK1y37EZAmobYvxmtEnKfYo1wsLatktFsU0gn9Mhuv6GSV8jyJLm2KTsQcItL2SZ4UIESupYFHPbtxQB31QAu6PrS7FCMJAW6V+MwjDB4qAXezNvFiDBLrw/
 tdqP3l7k
 AX5Hb5kyKfa1m5kvCBU6Fa4oK01sbd442Alslvkl0Fgz/EXAYrdH1BA9KsgBAa1bqT1UC+LYtu6O+33E2e8PX0PuZUnarEWihN2b5iCJ5HhwMoKFpTp4kvBFHIG6OkNk44W8BBEy9+B54Y87VgPKkvLlLFQehZXZSBYdH75sdhQSvC4rk1iqj2UsxUAwyYQdrRx9PUlPIwFMLqKNOuKfRWsFGgr5igPJoDgboiFpVjlAuyx8LWJJUc9gIlZeagnhhHG3A/M9UtjKDa2heGsUam5i6BbGlAwTQ+XnBsQw8Raoq6K0qjORY/tlTqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:52=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/25/26 19:34, David Hildenbrand (Arm) wrote:
> > On 8/5/26 18:27, Nico Pache wrote:
> >> On Thu, Jul 30, 2026 at 2:34=E2=80=AFAM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> Because KSM takes care of it?
> >>
> >> KSM only takes care of it in the case of 'use_zero_pages' being set.
> >> If we stop KSM splits from reclaiming, we regain the intended sysctl
> >> behavior; otherwise, KSM splits and reclaims indiscriminately. The
> >> secondary effect is that if we don't have this toggle set, the split
> >> would still reclaim these pages. KSM then has to process those pages
> >> (despite them already being freed), wasting cycles.
> >>
> >> Your proposed solution works too, I just think its a more aggressive
> >> approach (stop all VM_MERGEABLEs from split-reclaiming, not just those
> >> that are currently being operated on by KSM).
> >
> > I think we should really just stop two mechanisms to compete entirely: =
if A is
> > active for a region, B is disabled.
> >
> > Not trying to follow "who split what" and operate based on that.
> >
>
> I took another look and there is just no perfect solution.
>
>
> Option A: don't let mechanisms interfere - if KSM is enabled, don't remap=
 to the
>           shared zeropage
>
> Positive: same KSM behavior even if some other mechanism decides to split=
.
> Negative: reclaim cannot free up these pages immediately (waits for KSM),=
 and
>           having the deferred shrinker split to then not reclaim any actu=
al
>           memory is stupid.
>
> Given that the second KSM run would already deduplicate these pages, I am=
 not
> sure how much reclaim actually matters.
>
> But taming the deferred shrinker is a bit complicated (no VMA available).=
 In
> configurations where the deferred shrinker will never trigger a split tha=
t's not
> a problem, but with lower max_ptes_none it would be possible to trigger.
>
>
> Option B: don't let KSM splits remap to the shared zeropage
>
> Positive: Fix isolated to the actual problematic part we observed.
> Negative: Different KSM behavior depending on who split a THP first.
>
>
> Assume KSM scanned the range first, and then the deferred shrinker split =
many
> THP in that area and creates shared zeropage. On the next KSM run, we'd h=
ave a
> very similar behavior. If KSM runs first, you either get zeropages or
> deduplication to a zero-filled page.
>
>
> I would not go down a path where we would let KSM skip THPs entirely.
>
> Maybe one could teach KSM about "the deferred shrinker is active, don't s=
plit a
> THP if we are to deduplciate the shared zeropage"? But then, whether the
> deferred shrinker will actually split depends on the max_ptes_non toggle.
>
>
> Gahhh so complicated.

haha very much so!

This might be the correct solution below, similar to your logic above....

static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item
*rmap_item)
{
...
checksum =3D calc_checksum(
              if (rmap_item->oldchecksum !=3D checksum)
                  rmap_item->oldchecksum =3D checksum;
                  return;
              }
+               if (folio_test_large(folio) && split_underused_thp &&
+                   checksum =3D=3D zero_checksum &&
+                   pages_identical(page, ZERO_PAGE(0)))
+                       return;
+

Don't let KSM split a THP if it's a zero page (unless the underused
shrinker is inactive)

We also do patch 3 of this series, which disables zero-page remapping
if the underused shrinker is disabled.

With this I believe all edge cases and feature interactions are now exclusi=
ve.

I will retest. Let me know what you think, and if you agree, I can post it.

Thanks for taking the time to look back at this :) Sorry I've been a
bit MIA too, I've been focused on some downstream issues. I've been
meaning to review/reply to the high volume of khugepaged patches
recently.

-- Nico



>
> --
> Cheers,
>
> David
>


