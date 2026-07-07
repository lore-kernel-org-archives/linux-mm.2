Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5EDC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6756B00A6; Tue,  7 Jul 2026 04:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50066B00AA; Tue,  7 Jul 2026 04:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F676B00AB; Tue,  7 Jul 2026 04:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66D7D6B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:00:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2F41120386
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:00:28 +0000 (UTC)
X-FDA: 84961233336.16.89BF877
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id F2ADD18000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:00:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tvsgU7RZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of richardycc@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783411227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbAkDKiQdAHlIjM23fXX27BCEHDb70qexB45VCSeVIM=;
	b=D7otV9epYeI0Z7Lthu6YqS2poct1wNNynRe03u2MIw3/zEIezviJMgRMRG3VprMrFsUmNl
	5xAif//zEQ1k4Tt0Yydu0FSpo836H3leY/0odmErdwrW1LfZnwH+hItCDHA6cK8DB2C4X+
	Hw5yQJJ/8R+gYBvAU5s09S5lVu0Bi5o=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tvsgU7RZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of richardycc@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783411227;
	b=aFY6s4pyfCdPGev2luKbBnho9XzKoRPlVQa1yRf0uoYJKyocbylxGFYZ7DMvt7hw9WIKYx
	A8tfuePlcTL5h3kneeAbmlmlsdH2mFcc/m1gkw0R1GGQwl1H9b0rzrrDSJZlSWwM6Rw8fK
	Dov8+cRSSa2c6F9WZ+G6s4WoVz4o2kw=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b0077d7053so2270e87.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 01:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783411225; cv=none;
        d=google.com; s=arc-20260327;
        b=AnwkV2tZaG4Co622XrxqPZ+X7ILI/kh/EHHpDA9cx6Ro1N2w0iIY3B6LVyg5SOiZTe
         pRSN2KIy6b16GCLCf2/fqxWVgdGIqgkseboaU9W/SBl3wG1vo5FTQ85+stG17U1vLbxi
         ZKatw4omv3Wx335Evh8ZGNlS+qUY+wRLZRlTYZekCDYN9FetPHjPLq9yCwmSVv9WQdU5
         WT7s98PNHDp2cefWbsMyuN6rYMDOGP5avwDXHeWGzbDRsxLGvbR4tHDNjyocA2P32sai
         p4OWNvquxbBYasly6OQXRb9pMANf+SOTSaCLLKNgwkArjS3Tps4pyqIa8H/mQ0YLIwkQ
         wA+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DbAkDKiQdAHlIjM23fXX27BCEHDb70qexB45VCSeVIM=;
        fh=L0gnifNQjb852G2cY6spb1KglK/SjTkVROPmICaKWqc=;
        b=sOZ6Yz0c2ZXqsdMdkdfI/7I5B1cgMLwf3f0/A+zPJfz8yJSNdGGRHxms/4t4JaoL73
         AJb9+ZjfO79A0fAfUBCldtdWGXE5qDfWw3z/mcT9sY3072njTYq77KsNVdIvR149lVvS
         lNrZXxAB7agKCUizi1kV8kze4oJwDRcfth1twLFZDGCc7x6YidV0ysFCTwUDUXgtbgyi
         KWukN/0XaSQCr/MDCg/rn9AzfSIF1GYMPQBGNesjM3HPJNNT6ZX30w6CcsgR+MzFq+qH
         DkREqJULGorURVCSr4zssP9SIiasRsg900p4nZhx7RzE9SQk+a/QMJOUkeKz3wy6eJZM
         GiOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783411225; x=1784016025; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DbAkDKiQdAHlIjM23fXX27BCEHDb70qexB45VCSeVIM=;
        b=tvsgU7RZygXM3n0OomsfY7PHmIwAtdmwluflphlSeOanfaZXvejHcIGt+u/AFMzPIB
         SUcQibpIbzK7Zb2uvqy5EmTmkZPCm572O5a3hAV0UB/6R2LLplsXNSNiYFXToeTXz+n1
         NGfMzYZeLfSU90IRFZH00dszaeC8R8DMU+YO4G7hkTvb5SCoockHUE+cyrw50zME6CfD
         ssanu05Yw2B9lrN7Zmq63t8BrxTeCwxJ4PZ8aKHs0CBOgZ128zPImmp0EB1iq2cdYIO/
         klYTWyweo85JkB8RzJ9YvAEmdfOSaCttr9qZdUKAK9nDL7/Cr4WpejeANYC86XhLmMa0
         dg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783411225; x=1784016025;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DbAkDKiQdAHlIjM23fXX27BCEHDb70qexB45VCSeVIM=;
        b=FNWvaWTfvtVice5Sj4VN61ATtm2GHEVZxm4paHIKiR+VJh1acJE8fNqnL4NHXWV3jj
         kEvtFt8pCVhlU6seWqMkBOhq/xuw2TvUaixIQZ6lQil85xiv7C2GU2tFSiWXWlF1y6pC
         /h7fcYFrJtnXaDQnkyh/+sYimprD6BabpLagSMd1O8XwLw4VjEbT5p7+Rb7XpCbsrkB6
         bguJXLmWZPRNpX57vFd8EkhyoUhNjjD/odAbDo5DglNX4WwYova3R/WRNoz+Lt7c7s6H
         TpH6MwrSbdG90tjNBgaAzGcjlVQa0NIfg85JE4v7tCEq4EOt2AufYkWyMxupY+Mecau5
         vQyA==
X-Forwarded-Encrypted: i=1; AHgh+Rr9QTbhAObnkE/mSZZYV/KS4ihaVhtjPuRa903a/sIC3z2j6kz+f+E7X4F3JZIcT9W4SHr5TI2Q/A==@kvack.org
X-Gm-Message-State: AOJu0YyNwKhP0N0rqxGqm/d8/Bn4dGOdS0cWBE/C3yynW2hQYoyTyDwq
	c/BPDvANI2n6mtlHex3lCRu6XVzzFbiakRQ9iVC2Ret9VDuebDLzcYv5tigv81/imPwfwkx33C4
	9bcsikJ058MSMPqY87h+KXhWXz2GpWfjyW+T8gNw=
X-Gm-Gg: AfdE7clKYlV9EOO2pzfKGj28qjaqiu52H/GTJEW+pbYYlcKScbEty3Hj0HkNViFQG6f
	O5poGHNjX3TgIHI5mYZaG9eP2V2CqRWl8NKf/oLDd3vuSLWrEwfzKOYWRNnV/7v9u5JVBzCw33u
	Yeef/Z5UPX7ISqtTibHMQMgHEo34Swec9tD92J/VAYwVNnF2gjFMZEa7/WhZ19l511oU8JDk22+
	VLFEA2pRz7i3SuFULg2ll6PxCEx/30VTvPFJhu5oJ1U7DlCGO5mdSAPmumUbXDJX4KRfZy6hHo1
	aD0saA==
X-Received: by 2002:a05:6512:3da8:b0:5ae:bfe1:737b with SMTP id
 2adb3069b0e04-5b00ad0be3emr126280e87.10.1783411224922; Tue, 07 Jul 2026
 01:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com> <CAGsJ_4z+NfRbT0KYJA8Oe0QZ5nKUDLQFwE01Gy6khj6kq09JZA@mail.gmail.com>
In-Reply-To: <CAGsJ_4z+NfRbT0KYJA8Oe0QZ5nKUDLQFwE01Gy6khj6kq09JZA@mail.gmail.com>
From: Richard Chang <richardycc@google.com>
Date: Tue, 7 Jul 2026 16:00:13 +0800
X-Gm-Features: AVVi8Cf3ibBWWIWOluFT0ClIxymtOO0JsOIGpXKypqkH0c6u-2_EYE3zJqMFF4I
Message-ID: <CALC_0q9fuKkfB1HnXjEALGii4uPeS-jdXcMUZjs5trAEr8mP3g@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hzme9t5bupeu57uooa7rkjuejaoybdi6
X-Rspamd-Queue-Id: F2ADD18000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783411226-357897
X-HE-Meta: U2FsdGVkX18pTp/I+c/6vXDH8GLuOmDQJ+vRgrNeAwybc/wu7g69pio8ULbGRTQZhQoVKigGKcdBjFjyOgTgpEOYPWWb9zbVlsqSgqoPfSk5yfFtJ9T5wTxiS/iRXY1g5THjdK+pCeaG6ubvJJDbxcrtksFjCACbFIPL9i/+22LukVLjmqNFB3rVAGlUvk34f/msFTzjyfuEjJwfxxP5i//hkSewq730YGjSU9/DvVImm2wkwW9g1gAbxtRYY7aJRHKkIPSsyWIFrj6HBPQYHfELK9cwTPxDP2hSAGsbNVbTGa4JBc56gz3XTl4kGDzLD6xCh4JY5SX70wQPaazOfK1s9HcbG9enSyCdxEA3RxkYsV+eHg71fqbGW/lVD5S+yNcVSHf8WZ+4hkoUEoBfi/eNwdGxvRL9QTsk0d+jPwNu30YwbJnBEEjXDit1rPJoWoNhCVMuQBJCnP99idDrd4i3meuQOa/+h73ZTOi4T6ih/8OBNJnqa+tPx8DvN75iO/6lsHEvK9LPDb1SvA4KRECEQNcBZRviqtqLL6OzXWRPQIlzQ9u+bPEg1HxRA8pI4//UkMEg2dvf8P4FGXmt/yOaEszgztX2WvaDSao4b984a13q8RJ5omZAkkB5013Ihz77uqWrptut2bEmG/l/0686z79o7HvTyjSMShzb/iS5LkwtLXa8nSKqR3rO4IF5e6Fzp/ZOZMir0cgq1/ElQ2Y4iK9NJz9u++balah/rTBHrhzT58LGozNeoSWV39ZZ/A26e4xpNAa2dUeyvCDdXvDPhUmL75O+CU5ueAZWEMrAYh2U/vFQIjYpTZGsIPRarNBo1aF7MEF4BkL5kFo1VOM0g+tZXOJ/diJ69Ac831J5bxDKNC786PTJ0zW7tBxi3Q1a6M6KOJ0THmERdUlx1EVL4zoJlbfyXKbFlLncYYqRTDHCkdTaas8SkgayFcUgCGbJxVrq+AC84++JBxg
 Kastan7E
 17+HjdyFR/Z6ebvexIEcZ6RxlJoyQHNUcu4RJ33qksg3C4i8ht0Bvj484Y5fr9O600/ZXeaJIssDx1ZuOkoB4Tx+sa49RUB7o8iJB/l5hw0q+J8Or9GdypgW3ZM1TfFXpbaoRaVdJXC2fe6JfzXUX2d6ljXXFooi8wdS7sZfJ+/OMP3Xdq7W/Eppkw+oLcXslCJphfpCWShQTk9NcChFi+d77FWiuoQJ4xFFdskRFmr9SEuIp0oAjWXgbhf+WyysA9Hcvk9T/8GLNM6vki3dUbUIIsOKHUVBwsKAs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

I use the following commands to test. The CGROUP_PATH depends on the
platform settings.

echo 1000 > /sys/power/pm_freeze_timeout
echo freezer > /sys/power/pm_test
while true; do echo 1024M >
/sys/fs/cgroup/$CGROUP_PATH/memory.reclaim; sleep 1; done
echo mem > /sys/power/state

BR,
Richard

On Mon, Jul 6, 2026 at 8:54=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Mon, Jul 6, 2026 at 4:12=E2=80=AFPM Richard Chang <richardycc@google.c=
om> wrote:
> >
> > Proactive reclaim (via memory.reclaim or node reclaim) checks for pendi=
ng
> > signals in its outer loop in user_proactive_reclaim(). However, the inn=
er
> > reclaim loops=E2=80=94scanning cgroups in shrink_many() and evicting fo=
lios in
> > try_to_shrink_lruvec() can run for a long time before returning to the
> > outer loop, especially on systems with many cgroups or large memory siz=
es.
> >
> > This latency in responding to signals can block the freezer (both cgrou=
p
> > freezer and system suspend), leading to freezer timeouts. This issue wa=
s
> > specifically observed on Android when attempting to freeze background
> > cgroups while proactive reclaim was active.
> >
> > Add a signal_pending() check to should_abort_scan() for proactive recla=
im
> > paths. Since should_abort_scan() is called within the inner scanning an=
d
> > eviction loops, this allows proactive reclaim to abort early and return=
 to
> > the outer loop, ensuring the task can enter the refrigerator in a timel=
y
> > manner.
> >
> > This check is limited to proactive reclaim (sc->proactive) to avoid
> > affecting reactive reclaim paths, and wrapped in unlikely() as it is a
> > slow path.
> >
> > Signed-off-by: Richard Chang <richardycc@google.com>
> > ---
> >  mm/vmscan.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35c3bb15ae96..fb472e924fc7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
> >         int i;
> >         enum zone_watermarks mark;
> >
> > +       if (unlikely(sc->proactive && signal_pending(current)))
> > +               return true;
> > +
>
> Seems reasonable to me. I wonder if you have a script to
> reproduce the issue. I'd like to test it.
>
> Best Regards
> Barry

