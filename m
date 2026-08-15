Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11B7C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06ADC6B033D; Sat, 15 Aug 2026 04:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B836B0343; Sat, 15 Aug 2026 04:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C736B0344; Sat, 15 Aug 2026 04:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA4486B033D
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:46:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2894B120317
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:46:29 +0000 (UTC)
X-FDA: 85102872498.01.4B82B84
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 36A8F40003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:46:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=luw7yxoP;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786783587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7fNVFrdbRObpGAx18L1bHPOCx3k1Oy0uZjHGSI/yj8=;
	b=2ndGFxYAL135UvZKNmy+rkkpg0NlitJMFv1JCoZfh6YBVmxa/Q3gqOHGTvsiZ6wcB+KgMo
	FeUA3A74YXQM4wqzvdFXgvxhWMFDdFEsJ4+1zO2dX1Magn2ALI9DW0INgAYpPa6YZXyco6
	XhivIx+GIVf7c6dKLO9nnulyvFnMwUo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786783587;
	b=F62M3zoFOLphzt9HsqsMLnRlRk50R7qUEmwlzj20Dx2K4cpbiyTgh0aDsn+VFtoD2eztTk
	9SUbcd0ds03XETV6HG+IPFnXVT88VLtGSm0g4opIwMMaHo4FRtbxOjoONs3P2ntpvG9oe0
	BnBzV9Ac680goSrzH2zmqlfAVnw5rg0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=luw7yxoP;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-934956bee57so185388285a.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:46:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786783586; cv=none;
        d=google.com; s=arc-20260327;
        b=POr5LoQk3A9+YZEip1zapSbICyFFRl9bT1WVKXq+25FDCLxNADg0Rt3llo73akGxRB
         LSkpAkzrKixHrcCBQQV/CHM6/ZfstDT2r3nP6pw8at+exD1idiGnaHvlxuEL6Sq0pAhK
         ekT1XD6kxETiEq7GRcPwprOr8OiR/GMOYXQZsmwNjH9WBqx2aJWb67TrY00O2ZWAW1tq
         8GeZFIFw1lMQkcca/KIBLbxxVZiDaqUot9yJnxFb/fwJDrCO8UrLPv3iWLCUl7hS4PCR
         8BbZeWW9sxYLAsXtIr+9IRiBwhP70sES4Jd1q/NRaTaeaQcC2a9iPjD5clrnwF08uVnf
         L63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q7fNVFrdbRObpGAx18L1bHPOCx3k1Oy0uZjHGSI/yj8=;
        fh=4IIeFk49fIk+q323BHkh5f3Ox6NuZbE15PBjPVFrG+Y=;
        b=hVtrvUHgy/ekq/SlAoZ5FmSp0KCMkPhuO1YufxgOnSeJ1kFia8PcuXtOS4k3Ixnp9E
         oaTgB8+o1RnFGSwpdtwfGHQfHV4rZZwxV4hJjwdI/K4+d2p2NwNLzTdc0NSj4MYnqLJ1
         A08Pc8mWjepAZQLcfeAvn1Yoy+MSuxsp1OM2u8MaKvmGk5kePftobuzvPndmspaavCwV
         Ml/NEiZ/53xYIrKWd56culcxabE9vMQKjtNmdizQdQVIdUgr1o65qDe0/OtgOhM2NUTy
         F6TwIe9r4+EOSaIT118bUZYKupL55sdmGwmwwHoRiC4Hip0skAa4Z/gtw9zxkydMLghq
         KyWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786783586; x=1787388386; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q7fNVFrdbRObpGAx18L1bHPOCx3k1Oy0uZjHGSI/yj8=;
        b=luw7yxoPoCsn9nDOpeM9Dlf5fmDxAPb+9eJRDzRuZUxS2bm0R1kz90MvBt6jehIzuT
         n08dMhv+5o7srK6IlKtulPLIac63SugiXaYpJzMRxdl8+d0dez3XSHi+lSeiOoijEHCi
         JkEmAXu+s/UdVR6fOy3/sgDcWJwVU1YvOUJVnaI/+dummtFv//KZ9IplH2UsrsQQ7Pzm
         exlgmmsz3fEbmSSKcqxZ78G9sVs8zY7eZmGzM6GOzhRSBWEIio+EPMYBCtjVemB66YQT
         Q2RQNeRTuzXPP1LmpCMNEkIFE/iqZ1EP+/rxpzgM+Z9TNzkJ1M7N9HieZWcwP6wFNW1o
         FHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786783586; x=1787388386;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7fNVFrdbRObpGAx18L1bHPOCx3k1Oy0uZjHGSI/yj8=;
        b=dlNhSs3DsDHyZ8mK9Kf2QTqhQ9Sf27E4KbzR4flBVTyXD0mVdr0wuDJgZySGubXu8M
         sMd9Q+UXFb29I1zl45+wx9xrdp+2EP/hq0TlNa67CIX1QLXzXaRVKa84aQBWYKm0gAx7
         AdDPtXmOJM4o4G1DlmDlJSZV9f9P1EetrAi35TGqbgvx4AbijFdCxCmAvncdT/3HlMWQ
         FrVhxFC1YYd2ULxgqBUdFxoqgjYAFOopFz1mJ33GnoneYN+kCkjPAIjU/uAC0RlU6DI6
         5nN9EG89BzDxI079tclk8eRIB15SZrnIWB3OOtBIeUdhhaLFbZnE/HSfWdT8/FK609Gd
         EWeQ==
X-Forwarded-Encrypted: i=1; AHgh+RqofnWTCf9dwJ7s/Hw0xOsaAZHCNDBJTc4nVspluv8Cf8roqNJhKbYDJzI80hoCwsmRQCKYboBGSw==@kvack.org
X-Gm-Message-State: AOJu0Yxd/nQX1Fojmo43iPNfrs5SBk9Td5C91IH0xZsdXFHfbUKfutWY
	w95ZXF1b88F6+kPEh3uGae6HvINp6Pg0hq8SrksdyuiAZFnXGc9UMVUxq5ySHwCTBnFSzH43bMM
	PKVh68MFwMVFD8MYvvQxQqRRa/0jZ3yI=
X-Gm-Gg: AR+sD11WZWw5DhcWtZSQ+HD+yIFjy7TdQI2Y6Z2E84V34atRpg7BGfcD3a2JW2B5dG+
	2OkedDemnl7j4qCZPwWijpfpK3c76wG6sAKdbtZS6mjK+yB2BFJQae/3JfYo/OBuKHTxSRw8Mz4
	paimOPPtcLPwh+8UFn73WQQgZa/Mk38WKeaTxXvSEgI+sNgC41CdD9aPjCzPPqY5v5XidpCWoLH
	+4fFmQcphGVNK8hDfa/gt4QVZxSS816Gx5DOo7uKaY8HfYK7qR5W/nndNpm1oLS80GADASgV1z9
	GuCsyhKQc/bPXf/QT+6HS0gV4emlEYFhnjJSBoJHXw1Wi99MMSeHRmHJ8Smv5+2M+jQ+XRUo11r
	Xu1O0M87FnVuhxQXv149qZqY7Tz0ubFqdUSD+ZPj+XOi2qfrHfAV+iSY=
X-Received: by 2002:a05:620a:462a:b0:936:e8c0:ef0b with SMTP id
 af79cd13be357-936e8c10514mr112115085a.19.1786783585744; Sat, 15 Aug 2026
 01:46:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260421230239.172582-1-minchan@kernel.org> <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka> <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
In-Reply-To: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 15 Aug 2026 16:46:14 +0800
X-Gm-Features: AUfX_mxk6AG5EpFTGVPJpVGk0XPutuQz9ikJGFNdLSaSW6mkPTVoOt5CEs_37bc
Message-ID: <CAGsJ_4xn=rTM2YFhJoDopGoeSw=4PKAuKR9Nd+SjqMqxQnVaXA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org, 
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com, 
	timmurray@google.com, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6tieiz71rauwk44ujwkmaz16bikb1fbd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36A8F40003
X-HE-Tag: 1786783587-750684
X-HE-Meta: U2FsdGVkX1+Y/fIcyBUg9QHrM/TI9Yq25Yv2I9hYZtPovvgGS4cmJRLAjVTCEy5ko0nOAiEAaSK31QNswIpq0gzn7fAePpssb5ny0eYLURxwLuyc/npQvG4LKGuzw/461L+IULbs8fOS1kkpxh3En0/xMflcGtbSBnakBlhwiCzsow/2OxP9Bmqexhga8tmGgvquHXktDwN/LEh4sp6iOxO8pXPidcbWQErbVaHA6c5PFbTS6GTNBV4C0zzW+S9k/GatED1NkIPo+ucF/vI3wR1AfSV1HPPoaKAlOWCJ28i9HWgpqPBXIWYkqPWO27Y3JShbhaHUn5pkn1xyDgeC+v96BwAr/X3s4AdKPW/0HvJ4kvKJMSn52lOZLfEN6hM6i9FcJhQCiy28t0wvp9hS/5u5vBRjh2TFw7grUmnJIWxMDlO7FO34aT3ztxLiUZGjb77SpPzrPvKBO95dF8y8URsNaZKfuUcgox/vBLKOpFZpYgAk2ScXCe4pr7ACAuhSsPDedJJ6MfzSYqU7by2tKeNRomkKgyePnJufPQiFAvxb2fCbaJI84V/D8ZXPmPk7Tgg7pJFKq83BMmUsJeorDjRx1ruG66P6pXB94niTy0Q3YiNYqK65MBkpkWn/ljEs4T8W79cA67QKuD6M1Q4WgsJqE7PawuExlY2f+txjWMW/AHasTR4VZg3pZXIfS1Chwivc4d5erE39l+cbzaWc/FqNn/4f+OtJLv47lFAFW7UDAfbPuH70kdCzsOW4/U4g9XzG40zOT+spQf6pQDjMCWmp0LISWrQlW8OQFEQk6JpHW1kYVdBg4KPilcpzS1cdKzdiPzooAIjEAkeizLPkra0l/tTVVB5YtXgkCY18WpdqFdnES6rXwC2Bj7WpSwhTA/uM/EIT7fi2BNxp+87eWHM8AiZ0DTpuCRJtP5330t/ilycbtlyZ3dlMl1vWs/0pT7hFO2dBs7h8Sg+m+6b
 Zfy2GOxJ
 NI39+U2dnRMN4Fnqqzy9zViMDQ7PPsLTUKe3k9I+HOHLdGmOUCmlkC2uZJmgHgNcLBehs3BWnHX0IueJN+ssG9eSw0zhdesmtFUhBA7NOWsD6Vo7A9yfW4gKV8tM1ZtoGoh7RS1Z18+a5/a+AmSm+LU7qd9v971RsEf2VLrC5tXDjuOK8+NjcS3CTwDpgzqrcyuYeOBSAEAiO8ixRPJPVJdpCQsDtNpYcCtKNVO2KI8QPoAtkEAr28Wku+b4/LQeUk+vUha8+TU8tm6EVqPTMwhISIQa/v9fIlLxFKlg4tdeabCz5FWQNm1iurFfpHd80H+1AL/NqIUJVQ2nGISCynE1wJqc4LWShuOzqrsczZHN8XtxrXXgwWWWBPulANfTdg1FquS7G6gqKvv99byS/QzxP2Su3gugm8DcEro6NMro8n6t39mgYcKkIYrYvoyx+T0T9ZXTHIgl8H4th57Vayy8N+ReYZ9iFFl4LeAHKV97oh5iZLSB4W2twrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 3:58=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/24/26 09:51, Michal Hocko wrote:
> > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> >> For the process_mrelease reclaim, skip LRU handling for exclusive
> >> file-backed folios since they will be freed soon so pointless
> >> to move around in the LRU.
> >>
> >> This avoids costly LRU movement which accounts for a significant porti=
on
> >> of the time during unmap_page_range.
> >>
> >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> >>      exit_mm
> >>      __mmput
> >>      exit_mmap
> >>      unmap_vmas
> >>    - unmap_page_range
> >>       - 55.75% folio_mark_accessed
> >>          + 48.79% __folio_batch_add_and_move
> >>            4.23% workingset_activation
> >>       + 12.94% folio_remove_rmap_ptes
> >>       + 9.86% page_table_check_clear
> >>       + 3.34% tlb_flush_mmu
> >>         1.06% __page_table_check_pte_clear
> >>
> >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> >
> > As pointed out in the previous version of the patch. I really dislike
> > this to be mrelease or OOM specific. Behavior. You do not explain why
> > this needs to be this way, except for the performance reasons. My main
> > question is still unanswered (and NAK before this is sorted out). Why
> > this cannot be applied in general for _any_ exiting task. As you argue
> > the memory will just likely go away so why to bother?
>
> I think there was a lengthy discussion involving Johannes from a previous=
 series.
>
> That should be linked here indeed.

For some reason, while looking into Android reclaim performance, I=E2=80=99=
m
re-reading Minchan=E2=80=99s old series. I guess the lengthy discussion you=
=E2=80=99re
referring to is the one below:

rfc v1:
https://lore.kernel.org/linux-mm/20250412085852.48524-1-21cnbao@gmail.com/
rfc v2:
https://lore.kernel.org/all/20250514070820.51793-1-21cnbao@gmail.com/

In v2, I added a PR_SET_FADE_ON_DEATH option so that Android can
enable it while other users can leave it disabled.

Maybe there=E2=80=99s a chance to wake it up again?

> Cheers,
>
> David
>

Best Regards
Barry

