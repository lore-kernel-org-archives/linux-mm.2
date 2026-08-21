Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5CA7C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D959E6B00A1; Fri, 21 Aug 2026 16:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46B66B00A2; Fri, 21 Aug 2026 16:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D1C6B00A3; Fri, 21 Aug 2026 16:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0F9E6B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:14:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36EB2A2CEF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:14:58 +0000 (UTC)
X-FDA: 85126380276.30.3C0CDC3
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4238A20002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:14:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gNYSuZ8I;
	spf=pass (imf13.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787343296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0pIspaluorHg++9gMtKSvKEaGqS0Ixlt3+2tHvNtV8=;
	b=EEZWuDnRB84fwCAhHcpBbjwQmTeoNspSUTCKR0M1uzuwCsod5YUiUUPhimywFAos8un4LL
	zt1a7H+NsNG4SMUsk6VL54QR6JvIjV3IbFpBXQoakG4ZDO3g6pf1nSvARPlViWxlAho19w
	kcD6FmpHMU9fWPNGlQJnn+UF0uePNEA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787343296;
	b=AHCZeuI5+awkDl1r+rQe3Bi/0xqU0Z931KGvPGIvZl3731cyTddzEBB+crErf3q7YtYqiA
	7vnl4lF4qzbtQWzdCbtx2uYlOe60S7TfbrdnaWRpsTVrOP6e8Gh8A3uIJP2Qtw81J1+FBL
	Za4Zv7rCsde3pTwacrkEhGplNita7wE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gNYSuZ8I;
	spf=pass (imf13.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cace91f112so16211215ad.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:14:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787343295; cv=none;
        d=google.com; s=arc-20260327;
        b=Z1OUt1n8za+GH3dDoomy2JAGLaXbhzNZIOE2Ya1e8TtK5QTS7ZzgmTb2H5j9TG39kj
         xF07Xq/r4pfM7hf7X/xV1Qu16k6dKDjaDpJr32zDRho9sjkxLfMFhOTRi/ooWcTNOR5H
         tz9yqC64o7n9dLiMzbVWwL5Zf1ZuuQK7sqpdAhT/QbG8M7tEbx9MU7AnWJFO6+EgzHm6
         MaloUOb8PSzu3cuqpsb80gF45mcOd0+Mw0fUKlYnx+LLTMDS8QRjeUXj4OaLUY1k2qKv
         PygH/c0OS1fFBjliu79ylz83r5g6l/fmecu3GgzMiDkKHQi1Zg5FlCKxhg+Wq1FOUvZx
         ux6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T0pIspaluorHg++9gMtKSvKEaGqS0Ixlt3+2tHvNtV8=;
        fh=LF/fCBoIG6MnuenUu4HPFwmVOaVx2c5rDsZ6HY1dvhA=;
        b=fDasaLwpWoWD6M15PbZQPKucqmoCwbS4r5u+YhWu7K29BS/N2/bHYilWg1TwuT3+6w
         XoFlCE+eu1KUJ1vOtCTxYGhzQIjHAQdZELrgRvaVhZpd0xBhi66MSZ3z74cTVeAEoTkj
         beGuTbvaYN5gUSixkAINdo4+SmHlO4lc+2LYBXmtBoeDjYd/Ru3ZF6UmFT2i/khrfKWR
         iRLFwjZRHP9g96GPkHCnB2DQ4y0PlepONV9lvkU8N4LJ3EMIEyJoJM43auyoS6soytra
         bV5WIdd3qc6MXcvcEBH0tcNApAeo+EiiAqmMwkGedvyyrx+2LCv6DlPdBynnfyO6X2u3
         AZyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787343295; x=1787948095; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T0pIspaluorHg++9gMtKSvKEaGqS0Ixlt3+2tHvNtV8=;
        b=gNYSuZ8ItEQ+fQFK0iGlTI7D7au97o1D8loeMXL4M3PT3CtMGw7ffSLV2K+jmCGjg7
         OnhlJi+wiAelP20j9GHLbX+fX07tkhASnqgdCgubM1gPsHfsiGx7m85Hfp/DOSIjt0uT
         bl3mpedUuNh/ZtO4rCyYUVJgaWb7XR+VDWGeJ/Cz/MGzs51pqsUqQK4/nIYckQRJb0NI
         jW4SHalz1UMp+h8Ic9O/J6SIpBXL3m2+v6dZShkyr/qYINs5qqDR3Rmc3uingNn5Zsx6
         smF4/s2fNVhNzXsA5BDEiHIWtVITzOvjPCs2rnYGlN3L2jDxibJ+6Azu8QGWlgIL3ZvF
         fIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787343295; x=1787948095;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T0pIspaluorHg++9gMtKSvKEaGqS0Ixlt3+2tHvNtV8=;
        b=lMTgFLW0nxzR/e7ADRMG+TgO3t6t9OEhBvDB6m0hKsCHvTWOLI2vSZYJsgQ1fljIyo
         ATCEJpv3/gFGMiK0kDzVDkZB+X41F3gxrK8sL8hbF4cfdse6gB5kmVQG3dE3HOH1bB04
         eho0Htz0M+V+VRKvGzEHtWyMEE03/QIYybswcnWMuqWBGlAHgpsZr7Ecw694NPuVC3Vy
         +GUOSN0aZOJqwJxgvnEANFxnoovHz8uFnVpHi6wd5P0/5fEPpDWU9JFfkFSHpFIZiHgD
         68P5Nv3nxFsTPno9NcmLtlFv34R8ErUni1oK33SS/VSDhSdZdTgaaWfveKu7dQ++xSbC
         8cIg==
X-Forwarded-Encrypted: i=1; AHgh+RoHFoyzRyeya6sKs10mMIGT0coQBaPkJlvo+Th66BwdZlNfHrIdqNlVbgp1G589Rqbj+t0qlMxFFQ==@kvack.org
X-Gm-Message-State: AFuF++mlVYDyP4BS4pAb181hLD4HjnO6Jo8MG0zhMADcfOiB6q2A4rtk
	wAhEd+iD0VF90lbduIc/rBzzv8dLPdmlVSxhn39TdlSR47MMwIEl+PJK4P02zvTI4YpvsigcCji
	waHoGlgvrGOotwX9ILIzn/P3EATEvQdI=
X-Gm-Gg: AR+sD10xc37xdDfvwqpTNdRC7mMXIztjCh1vN5NvVRGSsjm9hDWOOWT+9ogR+C/pAMc
	yKzkcqr00qqUIUfQ4XFFRQpkObWFkEnsHS+ysiwPNo0jhS/ccILVS5yqjFOxH5DgR06c+Q+qnIi
	xQBtEQVS0r3sMwOJ3E5cZc//cwleJ758+sNXiDbDYAgbfLY7u+tPchW3org8UghSC5Ahnh5yaHz
	ilWBczdIEK65OBRmSzlPpJbvbRq3uHBcrQ8FL+0rg7agU4Z3xJeVGk7IHaLVq5Kc6yjgc+PKxCV
	qEfXATtZwyE5Guy/+F9vlUVzhQ5I/Nhm6HxQ+Nt9SbWYrpl1ml4Yy7rrS7zdImGTCmwNA46nrZ3
	edfS7qNJtKuqy
X-Received: by 2002:a17:903:a90:b0:2c0:a555:80d6 with SMTP id
 d9443c01a7336-2d670b60ceemr14987675ad.2.1787343295021; Fri, 21 Aug 2026
 13:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260821114416.12255-1-anshumantewari123@gmail.com>
 <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org> <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
 <e7c339b8-b936-40c7-b121-1a4c14838dd9@kernel.org>
In-Reply-To: <e7c339b8-b936-40c7-b121-1a4c14838dd9@kernel.org>
From: Anshuman Tewari <anshumantewari123@gmail.com>
Date: Sat, 22 Aug 2026 01:44:43 +0530
X-Gm-Features: AcwNN1WbQ5JWhMiF_GD66C2kxCGh-FyD5Ug_Cenhm9XuMXanDweiD-QtyfaJotY
Message-ID: <CAJqi8kKaNsxBM86Hg4W09gLo2rj0+kc9dAvps48jmQCshUkxqQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: check strdup() and fix buf leak in parse_test_type()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1ki4qcfiyrndfuw1cqqyi64ns1nki7b4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4238A20002
X-HE-Tag: 1787343296-472626
X-HE-Meta: U2FsdGVkX1/h+B1cAOIjlcIi2VVh7COCD35UUS9Frtw8veIQJS2xkiqpOJfOwUBV3R0PzoTLmFB7AWMqygtGAhBRIzeuBA1hxc/7vbLXAbJpqGGM5tpjr5l/iS6MoqnRHGWVbWPWM9xIImNLLs2o7Ox6M2n106PIZr2RbRqce68pXt1xaPAh8P5/xLbJ9a9iq5Ml2buJ82RltXpkYoEzYlGo5E0tCAW5fGA5TqoKLLSMC3CSrKjC+IMtqzZE26yLky1AA8m4GbqzrXUVeP99tHI5Bi3T0ZBGcIDd6kHWHBb8cZ7NoboxnrJDdHg4ZKJirWCwHZc1xAvEl6Qbf/zP8gHnLOg8T4Ba5aw4mlt6uoXkoHCc3CTdrm1hCj/CMxgHSxMsemFs6Zj+01VTnCzZa/M/Pv2/gd5DI9i0xgsl+xBmuLKzL84Mgo5Uts5EtyyaobNs0BspZyZBdOHL39bNjx0Ng0Tb58ctYjEvMKI4LzbY9FWEkgNMSDxWkS4PMke4PCvIWin7ujHpjxNdicTRA95dKFG6NxnVzdqHl1l4unNECQ97hqrWb1W44x6u8y83YfXNHyXKX6pjWqIyYW7aEhSizNXHV8TmltyBVqgLP5X8e8lDj2+m9LdmuezSrlv38PdjzRmectsRuUUqtrmXePBuXy6Jk8DR5KhOAWwsZwMWi1B91UgKQ5StVAJCXkrfUv+LoA++/P+28dr5RNwE4vrxj+ELaqTCUl1yNbQ3acrY/ekuElY2TuObSsCx9vmqlzdZ32+ftDyIeupZTWg1zq5FkxtD+HOLC4lBfiG9YetliTWG2IFXER4MbfJWnsqMfMC76JqJImE8b5LRVIbmVMCHKPzn2FcPcCwWZnjwCY5X+2QlKcXi5QChwxivw9DmEFoo1601oWBVQvdWA9yIN9eP3qtLqLUrq4KuZ4/f1GeivvAIuNU6GjCqvux+fuAP4bhoHR2tgFmb8+OxN1W
 PHT80qWc
 zd2QpcRUSh2vY6fIkDxgmT93pQWYV1d3/GEDStdSPGcVkHb69qtEcnidZ8mceCmhlr4KlTyDBfaatdXKLOyUwbLY5aMTNMi1KGtn53ZEJcvajXx7l9GhvWDj+x0xpMigYAc+2xixThVWVfyjIS8uE8bszmfMuukkaLBnE+/Z7TEM+MN6g38QtKxcsqwSsUri/JH8TkLGgjaClEOsw3SYzYrPrJedUv5OQuWC5fb4/mGNpAvAkawkhYHEh8TDRZZazbjD/QbQhesmUuPtQ8uIDv/ZyGFxFCOmb3Q/WwMI46EHkXWwkVrltOB35iZWCanA81i3EI8TbLnIiOsUEKzr+17fldXro2bHiUvePaDgJ1Ax3MwKQYngJSXqbAYPiCR9aRfjrJ2g6jcrp3hdpSL8sovI1PsVB0LVEZwZcCi+Yh/HmNc9OFYJNkFYemqr5PHtqHGhdEI6RHL9hjdWO53q27mOFgoSG52EsAWQetzgp5eXYW+a7wsAT7Va+RYvpRavgcVr3FTluS6C/MsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sounds good, no objection from me =E2=80=94 happy to go with your version.

One small ask: since this fixes the issue from my original patch,
could you add a Reported-by: Anshuman Tewari
<anshumantewari123@gmail.com> when you post/apply it?

Thanks!

On Fri, 21 Aug 2026 at 21:48, David Hildenbrand (Arm) <david@kernel.org> wr=
ote:
>
> On 8/21/26 18:09, Anshuman Tewari wrote:
> > Thanks David, agreed =E2=80=94 strdup() is overkill here for a single-u=
se
> > parse, and dropping it is the right call.
> >
> > One small consideration on the approach: working on argv[0] in place
> > means strsep() will overwrite the : separator with '\0', so the
> > original string (e.g. "khugepaged:anon") ends up truncated after
> > parsing. Nothing today reads argv[0] again afterward, so it's safe as
> > things stand, but it does mean correctness quietly depends on that
> > staying true =E2=80=94 a future change that logs argv[0], re-parses it,=
 or
> > echoes it back in an error/usage message would get the mutated version
> > instead of what the user actually typed.
> >
> > If we'd rather not rely on that invariant, an alternative that still
> > avoids strdup()/free() entirely: copy the type argument into a small
> > fixed-size stack buffer (with a bounds check against its length first)
> > and run strsep() on that copy instead of on argv[0] directly. Same
> > benefit as your version =E2=80=94 no allocation, nothing to free, no
> > NULL-check needed =E2=80=94 but argv[0] itself stays untouched.
> >
> > Happy to write this up as a v2 if it seems worthwhile, or if you think
> > relying on "nothing downstream needs argv[0]" is fine as-is, I'm okay
> > going with your version too. Your call.
>
> I don't think we have to worry about other such argv[0] users. If they ev=
er
> appear, basic testing would reveal them.
>
> --
> Cheers,
>
> David

