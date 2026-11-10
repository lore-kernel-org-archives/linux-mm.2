Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFAB606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GPPpWhI/
Received: by kanga.kvack.org (Postfix)
	id 7FFEC6B05B2; Tue, 10 Nov 2026 18:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7246B05B4; Tue, 10 Nov 2026 18:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECDA6B05B5; Tue, 10 Nov 2026 18:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 391F36B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:26:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1AB5801A1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:26:17 +0000 (UTC)
X-FDA: 85420795194.25.316865E
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id AAE98A000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:26:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="GPPpWhI/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794353175;
	b=G9Qx2RA1BCA9yD3vn7Py5dqHIF1i/wMkOrBU4xjAqkEqThYY+aIDoJW77FSgvA0qSD2eZq
	b8O/x45DJNXzUv1TdXNDHfhAYcFruTSc4WZL2rCmchSSDqdCcl8xBvAqazLq6a22giGjZM
	SBHS9H+pvO4I7LgKXtxXccInEiZrCb8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794353175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0g+GUjuFGWMtETfij1vLH1PWtxhKw/vsoOibkr4iiw=;
	b=nKiiXSw1i6jwjsKoAZ1PBqDoG7sZ6B6Vwu63Jcpa3JkowU1NY9gPOX7EzF+SI1LAD+lUcA
	uCbR2ZANdW3RZQD7x+A05Ra0hyQ0iR1Ul5lChOB8y5P7lbQRpf3Ur0v4zjP2o1kWDhqhbR
	P5NLjZWMLniHFMogPCIegrXX9MnWcUY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="GPPpWhI/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4b467581b98so24373565e9.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:26:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794353174; cv=none;
        d=google.com; s=arc-20260327;
        b=jCrXHsQjIkBy8enVrlTlSANmNAD118x3nIgl7lM/Et6XE13+QytcQKBPt/98MlIzd3
         TeJic/9lIQYtFvwn9JlxjSJMhiIHbPWsloEpDRQf9NvHMmhIvbbXAF1TQu09a2+LaFo9
         laxmw+zm7yOPjibi4pzv5xfLzuf77bMC4DYlFDbGlJAeljT32f2JEcvBZAKVrUIgMQtL
         f0F/ZSIb/9qoV0vtqw6u6VtihBAopNQmcrTHkvZ/vMkyNv5vN9V/DoEId/SUvNlvhUpW
         AFOnZkf4mA+JMCyq+1BIzhDGMepRb9eN6Ps2e5NfASzEX8EKkDwW6E3kwNHDbrbpQQse
         S4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g0g+GUjuFGWMtETfij1vLH1PWtxhKw/vsoOibkr4iiw=;
        fh=gHvim6T26GBcMMqtMA4DahHHC+txpSId4KMeAWFazM0=;
        b=R8zTXfK7VJxxI46+7+Ahb8787QEdR5uxhCZET+2/uWCzzsZQy3/ikDqCb8inCH6zGy
         rIVsogAgVZS6X4eBHg2iSdCgPgZE6mWq0fYKw2byraIjCEfBNbaSIDow3hSyLx5UKYTk
         rdTIGwO5fF1hSkqqcsr4+57bltNmmNHGb60jWnUiJxhsfwJSlA/n1VtDHBpEnlsaSxJU
         Wg/LWsijssbVMzBikG229KDsLhwmd460h1K/PH90ddaL6IBjubQvsli3bOQf8XUQ7mW6
         +m8B7mfWCb/sOO+EOekvWC45Yin0CRHgiGP13hlJEhDu1IpFJEMeaP3S9Mak/swuaB9i
         iCdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794353174; x=1794957974; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g0g+GUjuFGWMtETfij1vLH1PWtxhKw/vsoOibkr4iiw=;
        b=GPPpWhI/tFzTg04TflOXazejPoCbSwkAE5d0Itq2vMDIOMFtDVtagdlmp6HmKkGYfm
         kYDeJ9hN/X6km7uViBbK1s02MxjrZ0PURVvaOejL/5gtHNdBUa2c6zUzhmxyUTs7YO3r
         ykcGQD+muj9TyZjmzW1vhRxIV1fCTWCjRLANzhvf9nhJ6oLo+25LUoEJyp9ur+euiufK
         kdo8ite6oWXNaf9kfPVWSstuZy1BGpeM+eHhM1KAwRK1MrKYgmC45SmwBqCcqJ/ncQ3v
         rf9xraQKdg5wP3m3b/6a/eYZCsv7WwvXmLjzvXWWevq1sCv2BeFmDC0AX7LrOAQEozYX
         ootg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794353174; x=1794957974;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g0g+GUjuFGWMtETfij1vLH1PWtxhKw/vsoOibkr4iiw=;
        b=1S0TVbsCU/HiiXAJzzZApkAs2gE36XMJEZwteS3DXED1B8hZ6n995wRwpIBwOB/aSx
         PjJUNdvJiAdtwv+WuQvDF5Ph5ZBoTaKIzsSW5vd8alGtI8fc317IM2kFO/bSwhkFL5Uz
         2yqzcDTeAT09Q1QxWitAhSjWZEvyR42Q7RQ8OboTdRbRpjZvEDviIKPWd5STSkloOK0m
         JgwkPbGCF3Xp/deD2yt9rMy1YP+e9ntmGG+47mRGUIIg86bymv/zGKkIZCzJ6GrvA6fS
         INBnKeUY3Z5hmRAtyRchuQxVOBKQCngHLyUvCI1wigdGQBr3vL6fZVf2uapGHyR2zi4f
         Rguw==
X-Forwarded-Encrypted: i=1; AL+hErGVnNMlcvgyrR5nPwOECqdeucS8Jg3dzqCYZGzY6F+J9FFXXrDxW+hYFtsfbQW5xQQwaL6SknI7cA==@kvack.org
X-Gm-Message-State: APuU4Z+9ilzWo0juqqi6AmMctUBYj3/WsUdCoyMiHz+WVJGcLABvNgm8
	bD8FBtPJr6abkzCvt1Osor2tS7TRfDZEdtwUEGvJf7jLVqFWvTb6jAHhd//1YG62yAHa8BiE1NY
	E+9WVbVvL+whwJyMskIKym28ZhsJ37ng=
X-Gm-Gg: AYBFou2W6ktqte2u/i7Ojsml+ZKocs8fqmoBCYeJtkZKBjD/a1qPChKLU4JjvEbFNOI
	938InWOENjqKk5LZ+mmIoNxj/x3Qq6KXsVbxQCs+LPufMwcxNmNHW967dYEtrFMV1dAGR6v6iMP
	EX1sfnwZaleltic3toxT03SKfCqzfzkBppx2lxsivd8YvYd5IR68A915/bhzrvckfzKLjoTze0t
	PeapzgpPdPJiEGZSzp2HIstI3RaICyuR7e/Xu5dgzbWFjQwS3x9NYY5rgMHG2OspcyrArVu7yyI
	6DHEfm/6IOtDtI2YLeVwpimrjZJ9hOoklaMLBOT2e0PET5+nNg/D3d4IKrizZ8a9AtPMj60iIpY
	+rb0639Iu9weB3tTWlEHkRzEYs9EWdRum6AkiWOxQLD0vdhLsOkChdJzu9gwCCfcjaDsZBPXurL
	KTVZvBaL5tbJQ3lmU8jg==
X-Received: by 2002:a05:600c:4f4a:b0:4a1:7e76:d02f with SMTP id
 5b1f17b1804b1-4ba0938a45bmr10883095e9.14.1794353174119; Tue, 10 Nov 2026
 15:26:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
 <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org> <CAJnrk1Zn4xvO2ySmmgk3vqXUKwz5TPHMWtRdKgma8icWsug9Vw@mail.gmail.com>
 <520a5027-8c46-4111-b6f5-44ee15c1a267@kernel.org> <12D9952F-7AD0-4D55-8E74-603418C4C29E@nvidia.com>
In-Reply-To: <12D9952F-7AD0-4D55-8E74-603418C4C29E@nvidia.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 10 Nov 2026 15:26:02 -0800
X-Gm-Features: AclHuK82zKfv57_3FzoQqQr9fM4ukyLmkckjBULwVbmv7FkWrQZ5BSPT8VS2Lik
Message-ID: <CAJnrk1YxOUidqtNehoPL-_DknyT10BUWU_5GBJfg=amY0OAMwQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, SJ Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AAE98A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: w1zihxez16u74aydpyqidihqqn1ezf8x
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794353175-276330
X-HE-Meta: U2FsdGVkX1+FifYLUQdsNxEt9bczF++S1k5RtcGdmi4XfZJJ55IWATsjNkJC8NxmDJ6hYYvb7X131j6Nc/2z+7rOfJgMOy12/WWEF3okw5xBIHDqgvtLNwtB7rPLPPeD+/xI2HmQAbd6yz6Z5PQHVJOSBCFguc4MNW4xhHkXya1hoGnd4+7tACw5rVdY+GNBDlTdFFYEE28ZTqq0PA79PWTDgNnxfJjXo4XgPhS0DZPHLLgg2w5499InVsu+4dHZ76YB7BpgDJ/xQnVjqSlYxENwKJ3eJUBTnu313LmXdxwTrv0XcRlz3bccbm4hDQbKwPDle5ze0rp1AQWt+dU84RhunU6+6/JAlwqF73at0fhNWsimSfD1Ihe1wsZsRu4n1O3S9yZAVYaW5Bl2/Xdb+m5Pp4lGKyLqth8OcwmYqst2HszFxRNZFoaiieHa1dfBQ8R+3iVlgU8u8MsXY8LEL+r7d6uiVJsNZgrUA2FW2RgFQMHaE53JTkwUDHz7/5C7u2NtFum9cN9u+2qqEQ3Ea7qar1rQNt1g5KBcOQ+kiwxCb2uywMqyezhjaw9a8Vcq2etCGXB6coZ0RMKGEuzG1wExapBHNnSOrWhOafmwLTcKAVGFBiuLoD6XPsQtjsZxBuhqQsvTg8soZzT9XEiQMB6iJ39Ol6VfsJPSVFezA5RMRfQLx+/2IUaHaRtY2EWbeSMNsf6pWIVDBkBkvwaLLgKyWFALlIqd6hkezjaWcy+PeSMi+u7vhIoLlmprwcDewuC0UGKmsHJuq1gNCxj7+9igWBwtfx3m6XZeqxXxBjT/XBfIxlSJIG3e+MLIiSOV5Su+LBQOBB4/U1MCm3Koq2MgwJz00LjMsdk2ntOxtq8tRA+keFd2Sfp93CJoGQXar4KBkyDKsnx1FSgXwWVqPK0XclI59l+W7Oc3e7LpbUAxoBfAVlxQ1OmLaoqEBSYAEZHwXOrD+U4aetnzp/M
 8RkV4qCq
 zm3Atg6JXKtig3HVmA+MbW72peO3z2IR/hVLjaukMxh+akmgSecVRh0JwC+keZLlqMxGTX9Sw5DLSjMmQZnGlt9t3nzg7IwoDcBoTNrudRSUZWK0bcTBtq65fJaZ7VVp+zmEaow/kIzr8gFGy1IOv8WOWTXDHTyfk81woKZJj3JnEsOeNovub0bgvww6sa63dLKAHFxFwfaQkz9GjkfcHSiRqQy8YYHqdKNzbedKU37Ens1L+1I5WUFX5elD0M1y2NwJi8Nbwpa7+BjmfmR0VaKA5fDLnOhrPb/qJlwjuw8+b/sw481UFW8X1VFL+xVB6AbckVb0WzKDNYYT8qNlgqRkB0IJEYclL+UK+i/JFS29px/oyYfhldqYQHMq8+kMgQ9YCAYoeT75bK03q5LIWp5ogIqr7aNlpnFwEJCQnANuqXrgfC2SHKYrmc6ey6cqNs7NwXZ85GtLz6RL1gGp60ILR1amnMPDeTyPRLbYz2S2nAKt5Ez9nz0/Z53Mph/dgMBZdF4wUOkdvJwtuMgXDQH29vyv4Ua8mZoNvO5bz+KkTSdrEq3uK9ltN4pngAU4ljCvsjXh59E1P/6MimgeKDhKM2aPdtP/zx0TUggz9JBRdAlsl609YK9PBtrzDL+viDPGvv5mhGTiFJgA4QReVwV1sZVOwVvT2IBU6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 1:05=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Nov 2026, at 15:55, David Hildenbrand (Arm) wrote:
>
> > On 11/10/26 21:21, Joanne Koong wrote:
> >> On Tue, Nov 10, 2026 at 3:49=E2=80=AFAM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>
> >> Hi David,
> >>
> >> Thanks for reviewing this.
> >>
> >>>>  - A folio whose split fails can later be split for no reason. If th=
e
> >>>>    split fails at folio_ref_freeze(), the folio is remapped but stay=
s on
> >>>>    the deferred split queue marked partially mapped. The deferred sp=
lit
> >>>>    shrinker then splits it without checking whether it is underused,
> >>>>    breaking up a folio that is fully mapped and possibly fully in us=
e.
> >>>
> >>> This is a similar problem I raised in last year's LSF/MM:
> >>>
> >>> https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=3D&files=3DLSF=
_MM%2726_+Deferred_folio_splitting.pdf
> >>
> >> Awesome, I'll make sure to add in a link to this presentation in the
> >> cover letter of v2.
> >>
> >>>
> >>> "
> >>> 2. THPs erroneously detected as partially-mapped
> >>>  * Failing migration/split/eviction after stepwise unmap
> >>>  * Remapping the folio will not fix this up
> >>> "
> >>>
> >>> The news here is that we now copy the state to the new folio and can
> >>> consequently split the new folio.
> >>>
> >>>
> >>>>
> >>>> Mappings replaced by migration entries are not really unmapped, so d=
on't
> >>>> queue the folio for deferred split when try_to_migrate_one() install=
s a
> >>>> migration entry. Pass a flag down to __folio_remove_rmap() and have
> >>>> try_to_migrate_one() clear it for those PTEs only. PTEs that it repl=
aces
> >>>> with a hwpoison entry or discards because they are unused are really
> >>>> unmapped and keep the current behaviour, as do all other callers.
> >>>>
> >>>> One consequence is that if part of the folio is really unmapped whil=
e the
> >>>> migration entries are in place, zapping the migration entries does n=
ot go
> >>>> through the rmap, so the folio is not marked partially mapped afterw=
ards.
> >>>> For a split this does not matter, as the folio is split anyway. For =
a
> >>>> migrated folio it means the destination is not queued until a later =
unmap
> >>>> notices it, which seems preferable to queueing every migrated folio.
> >>>>
> >>>> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped =
folios")
> >>>> Fixes: a2e0c0668a34 ("mm: migrate: requeue destination folio on defe=
rred split queue")
> >>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >>>> Closes: https://lore.kernel.org/all/sashiko-outbox-198104@kernel.org=
/
> >>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>>> ---
> >>>> This bug was found by Sashiko in its review of the mTHP shrinker ser=
ies
> >>>> (https://lore.kernel.org/linux-mm/sashiko-outbox-198104@kernel.org/)=
. The
> >>>> migration / rmap code is still new to me. This patch is a fix with t=
he help of
> >>>> AI, so I'd appreciate a careful look from people who know this code =
better.
> >>>
> >>> Don't we have the same problem for try_to_unmap() in some remaining c=
ases?
> >>>
> >>> See below.
> >>>
> >>>>
> >>>> This was tested in an x86 QEMU guest with 64K mTHP. Splitting 64 ful=
ly mapped
> >>>> folios through the split_huge_pages debugfs file no longer increases
> >>>> split_deferred (was +64), and migrating 64 to another node no longer=
 leaves
> >>>> nr_anon_partially_mapped up (was +64). split_huge_page_test, migrati=
on, and
> >>>> khugepaged selftests pass.
> >>>>
> >>>>  mm/rmap.c | 29 +++++++++++++++++++++++------
> >>>>  1 file changed, 23 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/mm/rmap.c b/mm/rmap.c
> >>>> index fa34e1ccbd8f..e5d17481c0c0 100644
> >>>> --- a/mm/rmap.c
> >>>> +++ b/mm/rmap.c
> >>>> @@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio =
*folio, struct vm_area_struct *vma,
> >>>> +                     /*
> >>>> +                      * The folio only looks partially unmapped whi=
le this PTE
> >>>> +                      * holds a migration entry, which is later tur=
ned back
> >>>> +                      * into a mapping. Don't queue it for deferred=
 split.
> >>>> +                      */
> >>>> +                     may_defer_split =3D false;
> >>>>               }
> >>>>
> >>>>               if (unlikely(folio_test_hugetlb(folio)))
> >>>>                       hugetlb_remove_rmap(folio);
> >>>>               else
> >>>> -                     folio_remove_rmap_pte(folio, subpage, vma);
> >>>> +                     __folio_remove_rmap(folio, subpage, 1, vma,
> >>>> +                                         PGTABLE_LEVEL_PTE, may_def=
er_split);
> >>> We will not add such magical boolean parameters. I have a patch to ju=
st pass the
> >>> rmap flags for a different purpose.
> >>>
> >>> But the whole thing is rather ugly ...
> >>>
> >>>
> >>> You should probably look at
> >>>
> >>> commit 354dffd29575cdf13154e8fb787322354aa9efc4
> >>> Author: Barry Song <baohua@kernel.org>
> >>> Date:   Fri Feb 14 22:30:14 2025 +1300
> >>>
> >>>     mm: support batched unmap for lazyfree large folios during reclam=
ation
> >>>
> >>>     Currently, the PTEs and rmap of a large folio are removed one at =
a time.
> >>>     This is not only slow but also causes the large folio to be unnec=
essarily
> >>>     added to deferred_split, which can lead to races between the
> >>>     deferred_split shrinker callback and memory reclamation.  This pa=
tch
> >>>     releases all PTEs and rmap entries in a batch.  Currently, it onl=
y handles
> >>>     lazyfree large folios.
> >>>
> >>> Batching resolves the problem in the common case. For the remaining p=
arts, we
> >>> should likely just check in the deferred split handler whether actual=
ly
> >>> partially mapped to then clear the flag if not.
> >>
> >> This sounds great. I'll look at Barry's commit and rework this patch
> >> to batch the unmap, and I'll add a patch for the check to cover the
> >> edge cases.
> >
> > Take a look on the list, we might have already had some attempts to bat=
ch in
> > there (we just lacked the capacity to review them). But maybe I am dayd=
reaming :)
>
> You mean the last patch from Shivank[1].
>
> [1] https://lore.kernel.org/all/20260813-migrate-rmap-batch-v2-7-3c5424c5=
55c7@amd.com/

Thanks for the link, Zi! I'll follow up on Shivank's series to ask
whether there's a v3 planned. In the meantime, I'll work on the
deferred_split_scan() check.

Thanks,
Joanne

