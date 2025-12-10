Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF30AD2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 05:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053C06B0006; Wed, 10 Dec 2025 00:59:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004626B0007; Wed, 10 Dec 2025 00:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34776B0008; Wed, 10 Dec 2025 00:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF7FC6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:59:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 436A912E10
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:59:34 +0000 (UTC)
X-FDA: 84202509468.10.52F174A
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E3F780005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:59:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Hs9Wbp0R;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765346372; a=rsa-sha256;
	cv=none;
	b=pvADYkr0IB5yKO7n1bZQAzNkcwyhFBnthItgt2whZOZutlhXuB40rhoeiIyc8I2ynt1BFK
	AgWT/m297kVWe1XdHlauNcN+Es1q/LlU2rj//pW4Ff2JccXoJMgrHY6UiwbAjNmGRKUVtp
	nn2yYk+KPhmFqQEpv2xx19VOBL33Hhg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765346372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkKmEmlmy8ELaJoQUHf2BKQunA/3LKCRjsVDxaDzqrg=;
	b=cFr7E+5vX6D2s7L+Ouk0iQxj9VNyvsEOIRaeATXmui9Qlulw8K5+x5btLlAxPB04xZrurz
	CUGuzMwldNiu93zBg+546uRDFWcIMsSJiRlfD2V83tI3JkAIIgifM+uOFnTagyLzVK8hbl
	ta8LT5R8YQwNagblvaSngPxdveVOJzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Hs9Wbp0R;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-641e9422473so5433673d50.2
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 21:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765346371; x=1765951171; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkKmEmlmy8ELaJoQUHf2BKQunA/3LKCRjsVDxaDzqrg=;
        b=Hs9Wbp0RCO8wp365ZW+gK8dGeiiRmFzsJebvltcH3MDbAZ8n6nrGX6qM3+idPsyUN9
         vt5nZROqVZeKbsQxUJEjV8MGJxS3Ds0QTj7hgxEuoLepIeiVdb9zo48Ut16BSplA/XwG
         uzIsdEL5De0Cc9M13iRxloqrfRQdugwpu9pXbRLs+NPc9RcMpSSUBXx9LmpRLVTQ9HRr
         7Se6uqBcTzMNmsrHFTVJs427KFL4LWTIIsjnt9qebB4YWykEnz5AgRAT3JLJvI5NeaGl
         3MWkc58cA6sAW0IWc1cdEYE8BoEUb3zEzqstS2Rv8jCyQ+WSHkN5Ucw6pfJztfV5ybWi
         hpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765346371; x=1765951171;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AkKmEmlmy8ELaJoQUHf2BKQunA/3LKCRjsVDxaDzqrg=;
        b=KI4nII4wFAMrukoCmYrl0rp8/oNMZqZqGha+BUropVRKDBAXLJy6KSLNck4iD6yLqi
         KiBFwG9cVTTLs0GjI/qhtTp40TY9L/gNZ/7M40dUIBqLP3SvrM6xXeGpvzU3CAZMeykF
         s57CftFE+j6zNtEPDTrSlPD73PPUU4Jqb1nCCdgCnRioCU65rSUUvLUfKt3NuhaANG/s
         debHH4JWCwNaZdl6BXkd6BwHRvQOsPt1HqS/XbRn9siu+YZ2f4cr2Lni/rgoxvkPJzae
         mqlTdPDrkgE8escmHrkeqnaxBR/6fKLVAE9fl6AnByQZ/BfpTtrg/eOrDVLrsgGiTk2v
         1NUw==
X-Forwarded-Encrypted: i=1; AJvYcCVXFBi/O1/3a14xuy66Jh67CNEq6QEkpT9bNEEqQb0JrxsM758jNAYJOHE41iW70y9joMAwumDs/g==@kvack.org
X-Gm-Message-State: AOJu0YyPOytFGmKrcJR4vNKjl/i1Y1VVmg91mMvJnhLgcQEfIDuG5EoC
	c/xELdYDdw0Qmdmed3klu1NU2jRPpUwmbIJK4UXck4FQlZWGzZ1fVtI58XwUmjzgvA==
X-Gm-Gg: AY/fxX4BdzBa6/a+XzHVnnD1deFfmKOCtxisJcxg2uI3iiq7SaEiu6BLpiPU/KxPlAL
	Sy3iaH+GJqFNSWpN3bpVDOBpWOk1lwDC9vV4ZoyYoCisrvnjfLdJpkVuk/wbtNTLCc2s4fDaNfX
	A9sEIIM/WGUdgls1JNrSS0qXE5J+FBTYuRkRgfXN12T1SHEmpjmpQKWXi0tImuRUb91qe+Q0zCL
	uViaGgHPAQBoF53O/sQiRaxsONthlp9Rak2cThhy5zpVElGLrb5oIdV53sOUylYWq5FT+47ojCn
	5w5Lq2foiwjLBhNm5R0PmkxVyH+5qTuhXCeF+qPtDf5/fiG6Qijs15ScTPLv2weO1C89eQmtRAC
	gsHDfd5PC1tffggPNENHFJ+fgbAOBD9DHm9J3He7glm+MdKxxk69Z+xKZZIKHkMdJOl+Ks5WLdU
	jg5K7dO5ubEXuo5R9iMP2+R0W3D4L3GNt4ktkSY5Efin8kztcFTpnzz3tLHv6ZPZxZboiUiFjBy
	SiKJXodfw==
X-Google-Smtp-Source: AGHT+IHnYfs/FNwfsBlpEOywYrB4YmggQz7ScEEsHZ6ji5edm/7oBhWYVx7J+CQpa4h3kxU6P5oVKw==
X-Received: by 2002:a05:690c:3382:b0:78c:7b51:bdf4 with SMTP id 00721157ae682-78c95a4faacmr21928597b3.13.1765346371280;
        Tue, 09 Dec 2025 21:59:31 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b779458sm67535757b3.35.2025.12.09.21.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 21:59:30 -0800 (PST)
Date: Tue, 9 Dec 2025 21:59:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: =?UTF-8?Q?Ahelenia_Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
cc: Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christian Brauner <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tmpfs: enforce the immutable flag on open files
In-Reply-To: <mmfrclxjf2mmmohiwdbgqhyyrlab33tpnmtuzatk2xsuyiglrp@tarta.nabijaczleweli.xyz>
Message-ID: <57e2e227-e464-bd7f-f69e-573a772cd4c5@google.com>
References: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz> <be986c18-3db2-38a1-8401-f0035ab71e7a@google.com> <mmfrclxjf2mmmohiwdbgqhyyrlab33tpnmtuzatk2xsuyiglrp@tarta.nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-805250018-1765346370=:9638"
X-Rspamd-Queue-Id: 7E3F780005
X-Stat-Signature: f9oz3p7kb3iqq1mwfd65xexp5tfqeqzr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765346372-140071
X-HE-Meta: U2FsdGVkX198eeCNwq7+GNce7fo12doylEu2zINBDJhlF3Xvsh+/Cq1hrEe8xN0NazPttiCSPTKT8rhtFc8KPwqFR43QnorM7rlRp1MGGLldvr8DhiD9Cvkj4VVvV+Ne5qfst0xUkyg3cEp73nXwBgWvxIz9b+7SWN4xHWOWeQLGx8iYUg3K2dQmZnXNQnjd1Tu0jRo4yl+xp1ITB93oF0U9fIiXbPFRG8XeSdigktwxZtj8+KMfSWegu6WqzKZFHvEZmaJLg+oiPopXaC+7avwRhYXYCkDIAoxivAShKMaJ3cZ6ICVzWcAu91sUwka/QmqKOn5mRSCkXqr8Hw4ZNWxL8T0iOXh9FO4mf7lfhJoWw4W/6LCglXtgFFtTwGZBfvuDUj9PX0kxybZK0sH7nbCrd9WeBxuo4XXa15d50vnzrKFTwJUcM9skW8vm7LzhIUZYvcE40bmpnTry+GOazYLOveJG4ZJfbieQbFkeXDDYLqxGSzV5kv8jFwHPZlLLS2DCak/GsOafU2dTBznr45H6u3c0Px4eorz1EPSfUZgmXvhd8Hf/U1OBjq6aL19JpHNhtdxg8wglB+f532lXnLNhYUrsPX2D2c/wcYN7skABqPgdW57Kq4VnQO4+1jt+wTzY8PwhjxZywwHwYm0FIJCud7zG75t27JlywvVqmflKat/K7sfYAUfo8vfNtnFDKGN42ddHVkYPZZeC9F9bcRk6mprI9G5lDb4jK9jaxKRz/NgTXN2PQWUqQNx4V8t6R5oL5hHJp3v2iZOthusE48Zf6kU0/0SHz3knixg/w0iJ9prR7KAGm//frFNRQbW+5Okwa+19UVM5+uGCul9VPdBfD0U61jJqKIQNr3jhdXk1c2H9FcsmTn75apd08UQFx4e0osgWH5w2zJjm2Pp1Jpfm9Zsbl2P2/Fnm1MHcXx9M8kWYErmZFno1hGW6BnPbZ0Pp70ZjyXpp/mq0jgD
 HHYeNb1r
 bjRcYt/EwcZQvV6liKyVED6wzdTW2SnP5qm4/Bg6p0wrzNzxleYYXw2SteSUUnAa/YZFw6JDKBSI6FvnT/eWr1FaGXc3vgMiZy144lIwmd+nowjZz+ySUV6HZp5v5lHknCsK2X63fnFroQlZII3qDOmsYWgA17bVRStOV1RWHmHNkDfLJsYCD+vs1hUn6rRmMtV5ZJkdM7goLJGW1JBNO/Y6TDGZZyUQEBpHf92YgRpFJm//6w8mJtDlRoPQO/KW+s9iRHoGFDNF1DGP94jeZiLPdWIrlhtGowh2MqgvMd3L1eHE+VenshcUqjQRvZM1lT5NU/pRHicssYG4cXSGkoK3ur5mKVr/7MJx6x7J2BLMfPzBqQqrAVrJ1S9+vktK2epa8v1c/AkfQ/NXgl1RB8NDUJPcpeiOtagKAKU19oR/R4XrYp6PRHP/hdJl/2333fdsWRIuHjhjc0Edvw/aGn8uZ8C+V6IDKQ4Bxl+t3gvseOeeT7PdQMPZvfjSZ33uVinBHPBvngn2oYNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-805250018-1765346370=:9638
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 9 Dec 2025, Ahelenia Ziemia=C5=84ska wrote:
> On Mon, Dec 08, 2025 at 08:14:44PM -0800, Hugh Dickins wrote:
> > On Mon, 8 Dec 2025, Ahelenia Ziemia=C5=84ska wrote:
> > > This useful behaviour is implemented for most filesystems,
> > > and wants to be implemented for every filesystem, quoth ref:
> > >   There is general agreement that we should standardize all file syst=
ems
> > >   to prevent modifications even for files that were opened at the tim=
e
> > >   the immutable flag is set.  Eventually, a change to enforce this at
> > >   the VFS layer should be landing in mainline.
> > >=20
> > > References: commit 02b016ca7f99 ("ext4: enforce the immutable flag on
> > >  open files")
> > > Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczlewel=
i.xyz>
> > Sorry: thanks, but no thanks.
> >=20
> > Supporting page_mkwrite() comes at a cost (an additional fault on first
> > write to a folio in a shared mmap).  It's important for space allocatio=
n
> > (and more) in the case of persistent writeback filesystems, but unwelco=
me
> > overhead in the case of tmpfs (and ramfs and hugetlbfs - others?).
>=20
> Yeah, from the way page_mkwrite() was implemented it looked like
> enough of a pessimisation to be significant, and with how common
> an operation this is, I kinda expected this result.
>=20
> (I was also gonna post the same for ramfs,
>  but it doesn't support FS_IOC_SETFLAGS attributes at all.)
>=20
> > tmpfs has always preferred not to support page_mkwrite(), and just fail
> > fstests generic/080: we shall not slow down to change that, without a
> > much stronger justification than "useful behaviour" which we've got
> > along well enough without.
>=20
> How do we feel about just the VFS half of this,
> i.e. open(WR)/chattr +i/write() =3D -EPERM?
> That shouldn't have a performance impact.

I don't think tmpfs should implement half of the ext4 behaviour (at
write time) and not the other half (at page_mkwrite time): it would
leave IMMUTABLE on tmpfs as neither guaranteeing immutabiity, nor
behaving in the way IMMUTABLE was traditionally supported.

I do think it's surprisingly asymmetic, that IMMUTABLE should forbid
opening for write, but holding open for write should not forbid
setting IMMUTABLE.  But that's the traditional behaviour, which
surprised you, and which those ext4 mods improve upon for ext4.

But I couldn't find any filesystem other than ext4 and f2fs
implementing it that way.  If the VFS and other filesystems agreed
to implement the stricter IMMUTABLE (I imagine relying on i_writecount),
then tmpfs would probably be glad to participate; but not go its own way.

Hugh
---1463770367-805250018-1765346370=:9638--

