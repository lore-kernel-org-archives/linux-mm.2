Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B18C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 07:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED568E0003; Fri,  1 Aug 2025 03:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DB68E0001; Fri,  1 Aug 2025 03:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CFE8E0003; Fri,  1 Aug 2025 03:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 076DF8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 03:00:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1993BE9E7
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:00:34 +0000 (UTC)
X-FDA: 83727290388.16.2F51D72
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id D2D7C1C0005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:00:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CvHJl4SC;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754031633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOdACm39398ZkN2lU2UZXEP/gEQUsiO20iyEfrmnlog=;
	b=meHxCaf1+NHWPLlz/EIEECB8kLefD+WHDZvXV2XIaGesi0Pmx4yHmqt9O97QxmCrnaEf4Z
	swB1yBgudEFRVPyS4WRoP1LQ6xRPS8HokCNgR7HohKrxfnregyxUNuB6EWmyIbBwqOJ1zP
	XS2MK9cYwRYH5TYTBRMO4SrwDKsw+6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754031633; a=rsa-sha256;
	cv=none;
	b=e7FuL0OyRHyBq5aZBpEZ57Gs4pfW5cTifv4z0pbpn0Yi8CnjvYAFLC5qM0Q0zjJ9S6xhnZ
	wyHC+9U14FFfkXkcr9N2pFmJ8pPl3hIchdr2HL7PWw4fpQC2+6TEkBoGXQTr8C4kg+TQ7r
	g7ujsxgLho9SrtPpmulZPKccctkE6GY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CvHJl4SC;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b79bddd604so910915f8f.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 00:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754031631; x=1754636431; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lOdACm39398ZkN2lU2UZXEP/gEQUsiO20iyEfrmnlog=;
        b=CvHJl4SCyjnB8p99a48W/QpvYukrQla2nPMGAN4dsZE1PLihmjQGv0rCPqAxpiFbBA
         sZXfJyPNqyVK+F+OXi3wv23NDlKaz5Tmo3V6BdFJvFo03t21KxbGV+uw+kb8Bg28uVR8
         rAPsXLfzhLE2Ie85yGTw+UAFwv585HRdLBo506cyvvBp/FUEuzvNSMzgRttbZKs062iC
         qT73X6ryBIenA2RfUliS1fnxndz2wvwPXXwq0RNF6He8NoDVGER+/o1XyOaNqwpv3/qb
         iFetKBuOLeLb8BEs/BzgyoOfbEpzrJMPtJAI9UnllzXngVJaKcZJgafaT3/Tgd+/Wq1O
         4NAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754031631; x=1754636431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lOdACm39398ZkN2lU2UZXEP/gEQUsiO20iyEfrmnlog=;
        b=fEBpRPBtwFJA/0GTysmK8H+JtKvMOrSuK/XZ+joT9BLN4kECaQKWwn9vcMwQvU80Zq
         Azr2Gri90nJ+mm1gqaPKSB/s21Od46CvCq6ECmNL1RSjY/H/zcAXXC4lvzshAJetyxOW
         AvIH1I6+BLR6XeGDq9AGUEpX+0stl2uiZvwA9Eaj/59XvByg4OJUgUznRLxaNFAfUvUS
         0VUMafl7os/3WRZHej0PV0CFGY5e43gLbDBM8u6UBH2/1iAXIeORK3hqcPACBxN0Avs5
         pQbA/eooxoGYQPqRKKkRZgckzCvoUUih1O9eoWBaUKMhfldoyxrPtLda2d4/9Q9frC68
         0U4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWyNBg4ntxGxRTeZzh3YwFdVBNet6pE1yUJSDNDbMSalAisif+vR7Czdp6t7bH9CFpj5d+2p87ccA==@kvack.org
X-Gm-Message-State: AOJu0YyhLDTSyoVBsesDsp0J9ai2UW875u/oZNoIOwXN/mvMHxlzZXhG
	LnIy01Ml6djVZGXuZkN/DjkwI/LjeSE+SVDQjizftbRjgM/Jmihkp37CKYzheJIMWSw=
X-Gm-Gg: ASbGncvwOYFszq9sX4KCriqEGosLi4uXiNIzUPJ9gYjVP6N0BV8O5XrvjEizuG70Qld
	eOy5RXUtjK2oEWiICpx/k/ApmnDcK+0FBTF2RQNETB+GNtj9XByhG2I536fmO9MLVirhSYdXCTU
	eHYQZl/TmMwueVMRG7MenV/9rXgKZN9F79IbWpPHFz++n1EqiJXS331dT5bCFWw4Rt5LofPdC3X
	Z/wGRGabwPDcLDc3AMo0cgLfpoqp0rgdSqXC+NKKBmlg3pQZUSlfAf5qA7aIRaY2kdhNTdrx8q6
	M9kJuVXx+/7rho/IrNfMGWnQn80M8GCtuV7ya1kdRhlF0hqDxzftISL45K1/I4aqHfec5q5s2uf
	+bAKch88z7gdV791oObXgWWVaVa1fe2AqfikA5oUnWQ==
X-Google-Smtp-Source: AGHT+IGpo7vCBRl1+3LNZgziFjvZCIsV7Fz+AW0zycTpGAfpOewwiyDA2ffkkvBUhcmMNKx/L1CjEA==
X-Received: by 2002:a05:6000:4212:b0:3b5:dc07:50a4 with SMTP id ffacd0b85a97d-3b794fbeb87mr9254839f8f.2.1754031630614;
        Fri, 01 Aug 2025 00:00:30 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47ae8esm4762632f8f.61.2025.08.01.00.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 00:00:29 -0700 (PDT)
Date: Fri, 1 Aug 2025 09:00:27 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <ekte46qtwawpvdijdmoqhl2pcwtfhxgl6ubxjkgkiitrtfnvpu@5n7kwkj4fs2t>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
 <fq3wlkkedbv6ijj7pgc7haopgafoovd7qem7myccqg2ot43kzk@dui4war55ufk>
 <CAAVpQUAFAsmPPF0gRMqDNWJmktegk6w=s1TPS9hGJpHQzXT-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x3o5euvcxbwgpnyi"
Content-Disposition: inline
In-Reply-To: <CAAVpQUAFAsmPPF0gRMqDNWJmktegk6w=s1TPS9hGJpHQzXT-sg@mail.gmail.com>
X-Rspamd-Queue-Id: D2D7C1C0005
X-Stat-Signature: u3zsfj351mnziskygsnp7hc338kximmx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754031632-667715
X-HE-Meta: U2FsdGVkX18BW3yy/ING/916lnX45Zlvz/YzYX6lZ06MwBufsqqeF01GGklbjG7EnHFXoFtvmBkzG6Ib3Kq/La9jI7whUVP+tGfKju5y3HOGPjRu50VmshVLkMMlaZlK8qRpkKApH87ub0v1zZGiKXxLPq2kZhJufUZBlCDys9WQ2JFDCJp2TGyBJgK+byjlo6GeoVdFiJOJy6QjLzO1Owx/l98R7wF4fPYN11C/mrFDjK/NlutWuh3BUOzaAnzZ4BheFZwPJDPbocbBGT0CC5u5rbLRzU5f4XgP0Gi6/O+ydGGPsv/0kxUkGfvclUxSEVpwbxCguOrmG4vtcPY9XGNHPF7WTebiCi0U704KmGK3edvJAIaxURKfOTsL9lG/p4ZBNZYo3jZEp6xhqJ9VM6nWLCA5qQHvZ3ToGYRXmSq5tzQfY9k0QLDlM1CAG7bQQJMIjFTRldYagmsQ7DkFwnugow0YMoQSLm7Ed6k5WqlDe/V7j4QRDtpyNEhq/36tXaysNmW77VsiZPHxyHhKkAU5JP2ZDaR8CMfb2x8rHOddIwbIC8zOnLevXQ73Typ7LwURFzyR3NHvvKgWfyAe7UcWdCyUAiLfznEthyEU75+G6rcypvDQO8eEklLyHadW0JIDKyAL3gef/AS+9dNaObWm/n1yRy7fTjL2is81EeGIdUhXr0+6Potayl/QgyaQV57Tg0XL3iDRfxtJH4KlbQZsV0fLYOO2nXblXRKpMMljqMlIb5PzzYPM3xVg9jHXfM02P2bJPydyP19zMtkvxjOWLGHlcUNBkgyae/AqcBOGYx+Crzfy3prmbT6EgpWimWvuccU1X5cL7KpBuP2HlN8o0iFT7AagksdPiTeEYnW3okDqzxMkzEld+qDTaQkBTz0/hSOVy3AdcoVeG5FS+un7Z+182pUWqXIHGkys+2e+Ql6FtfLGYZCDBiJd72Zjr7aRy/0lTOJQW3Wwmbx
 OwCweu7/
 n+k44MnKXDP2kr2nK4yH0LpRIAgykSb6KL1kSvNu85ALquw0I/yoL2DYVmnaHJ3oYKRRJep80df2gUA/SR5kVTD9LFvGe6QR2KdvnY8WTrHVCJWXvwQCMq70I5wfoD6LR7/SaEbEHULejuPuo9Qu/d8r008Dm/AN3WIDEZiR1PMWqes06y2IqZ136wmcS8ohvVYEsiYnCMuJXlTZ+IbPQ5ji2lZWBks8dsUcZO2ifMk2OF7sl70HwLVksHFbrv7Z8EDJ4OykvBpK6LdRLSCSkfvigBcutjga7CiOxl6W8aRyw4OTdzmJGo5v3CPFOSFAoJVUo6vSMLTKOCXmt2uMmFS01JPgnyWWmXhkNwYRIq0Ib46QTNxbJ7W50ZghvIOd30s1oetV+VziTLQtI7/l4OHgX6m30ti3Gv9Md6rMWG7gZFAn0U020oA39v0Lued4XgAbkpJnB4Q1WqZA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--x3o5euvcxbwgpnyi
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
MIME-Version: 1.0

On Thu, Jul 31, 2025 at 04:51:43PM -0700, Kuniyuki Iwashima <kuniyu@google.com> wrote:
> Doesn't that end up implementing another tcp_mem[] which now
> enforce limits on uncontrolled cgroups (memory.max == max) ?
> Or it will simply end up with the system-wide OOM killer ?

I meant to rely on use the exisiting mem_cgroup_charge_skmem(), i.e.
there'd be always memory.max < max (ensured by the configuring agent).
But you're right the OOM _may_ be global if the limit is too loose.

Actually, as I think about it, another configuration option would be to
reorganize the memcg tree and put all non-isolated memcgs under one
ancestor and set its memory.max limit (so that it's shared among them
like the global limit).

HTH,
Michal

--x3o5euvcxbwgpnyi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaIxl9AAKCRB+PQLnlNv4
CJZtAQDyxJKYOwR+G5PupdcFpWcem+e2vcVjekmcUSnAefb9SwEAmlcDbWaK+JWZ
zsvVOKp5n3NQmuq9ouqRPxwf+gbdlAs=
=J+oe
-----END PGP SIGNATURE-----

--x3o5euvcxbwgpnyi--

