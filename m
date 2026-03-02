Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3141EB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A9D6B00AB; Mon,  2 Mar 2026 15:28:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE606B00AD; Mon,  2 Mar 2026 15:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA676B00AE; Mon,  2 Mar 2026 15:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29ECD6B00AB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:28:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4AB51401EE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:40 +0000 (UTC)
X-FDA: 84502261200.20.814273E
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id CD35FC0006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lCIHkuuK;
	spf=pass (imf22.hostedemail.com: domain of acastroramos1987@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=acastroramos1987@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cy1Nwb53qJSiFJvxOZ86G+ObjYxLuYx8l1yPKp3EqhM=;
	b=dJSfpGQFSqGQ30qTOpKSDYd3nQD1KDcyIRNGqQ+Asta7LGGD7XuxaDFolHgiJ06ZU5c9xo
	bSEZUdYMfyylyVhu4MZis65Du6FrsqRBaECLsesNcGvmbwynAOuNDObP35Pkt1eAY0YRQQ
	7DokoXlBbx9+BylwEDrxU+CP/Z7yxIQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772483318; a=rsa-sha256;
	cv=pass;
	b=X3cMS8O5QXW4kWMPANgekDE/WY1i3YpBYJA6nCPcJL6Ry7Ad7E1giVLmVoWTH/TfoomPtC
	wO8VtQEzCVKOqFc3X3p6zh0DHtjH3vObMqNOpppD/tSfkpwroAkUUpf50w1pxEjO5g7fkO
	X4tevpWOXcl2p1NBpUJdFAW078hBVdQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lCIHkuuK;
	spf=pass (imf22.hostedemail.com: domain of acastroramos1987@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=acastroramos1987@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38700168abaso14294151fa.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 12:28:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772483317; cv=none;
        d=google.com; s=arc-20240605;
        b=gMs1abAO96PiNcZgR1YBAF8r3Srt7ES088DsFA4zr07Zy+A1jTBswiTbHkiiTwfPiF
         ASprU+R+ZqVZ4IKqULiquBsUdq5ItLGjJy0bhVkV/hlVUKwDa7PtX2THo7jcIi9ZKIlA
         lF7kfJzFX8CionOFIqvSUFxt2sCfZ5MmmCNt341n50KgY1avQZOZ9j3WQ7A9MB6Oin6D
         LWhZqgWRT1iH5wMZhTZDxetLhOySX82P/U7Yf6cvMCqcttqUjEchRhvqpUYApLP5PuY5
         NwybAeC+B8hd2yLg9x1Q885HLGDw06ePZmRuURync3YDVajZfoSxEyT3c8CZ4/Jf9Dtc
         RluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cy1Nwb53qJSiFJvxOZ86G+ObjYxLuYx8l1yPKp3EqhM=;
        fh=a6SKXD5w8RNHSQnQtASqeXdgn2NV8TCqrNv+TtQJw9c=;
        b=kaTkiihoyOo22zA7YWtnr5SqqoL8aQvCqFq6+jpUowDo9Bz0kUj+btWUo1x49Dm2sH
         cM2MR891BV7nhcPeXmFU5aT5psvawHGKZIKwOI40N8VXMrhUeaRfRDNBm7VfUAAIT7IE
         CMC1grRyWliu3/0MeAY6qWmjTfslZRoTis6OtS/F3vSgwYPS+PLmdJXvMThfHpYiNsGG
         Sb1Ebx/pqbBlvcS/c9q0dfa43E6fAjKEw3Z0dOJ12DPczOc8g0kMGJ1TuF+wQG3UM/wI
         OfT6QRrYV1x7tTMeGRQVxsZ2+HPKou4kSC291i7Sdr5bxgIA9yHOsssXyJ7Zfpra3Asy
         mDXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772483317; x=1773088117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cy1Nwb53qJSiFJvxOZ86G+ObjYxLuYx8l1yPKp3EqhM=;
        b=lCIHkuuKbcyA7+cSHeb4IxATRTTr9Gm9Cx3VTsFXBaiLnFzcTOVwX/zASP3syp8H3Z
         9Wqeasm3qPtMHPpo1FMQgL7DO1kfml7urOoH8JIexkME2JgE6Fhoa6kX0s/H3LXYmqTe
         hWrvTvoIcDfgDCsQwgNpCM6sm/nc5DHzk0UNtDOcAN/UiqJDHqy25Uh/lXZUwAhrI+YX
         ixSqnR1ZFA5SGaLwT+iFost81kw8GWkFhe6CciWw3BOqYMBmo1H/9o/y4Iqafs7YMRx6
         kEK/XSxEnJJDHZeBukuJXiL4/V2RilpK7s0l5W8dx4ClMand63JK1zlM8f7OhKC4e9dp
         E0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772483317; x=1773088117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cy1Nwb53qJSiFJvxOZ86G+ObjYxLuYx8l1yPKp3EqhM=;
        b=fenzkD+0DMUwUMD6977udaSlWK8+SUiW0/46gHxsYXi95sfXlabnlwG4ZW0+2JgCKp
         flasclF27/6dJNfR1bYDSOm5RzaLXJ5cB+ihG0JEt8ItYnuOsTLoqFBMRAiCnkKtZYXi
         awpNzDpDUM4s1zGVHDpU4ndBq1afZqUF+2BbdKPVVE8U8Ke42tu5iGgMrnfmlEarlRi7
         GWAON+tb99BJiXU4XqvVqsndCwKdLcTXV8F4Aa75AaSXZYhzVrDfnyGTSEUvKztP72xK
         jEZ3/cYG1WlSToHFwI1zxwqCuOYxjAJ9ktrApDtiUyAgXlZSvHgQ99UGdMX7h9c8NTUZ
         jGkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgSdCK3qy+aNopxTMKkGjqSi4wsW2mCRvgiXMFSr7AVFVSIv3Mh7euIwU2hTGmFr5cerWhWxu6vg==@kvack.org
X-Gm-Message-State: AOJu0Yz6AOSdilJ9CRVbGOzucEjX23anyw0afhEB7HpGDyIcfPZtIXf6
	YxdG2jL99jrRi/F79rBXUzIb/6ho+PB/5m5HlGDPWyGdZZcuoMACVpXTNmcipB71iwKrZYnS67p
	omrp+uqV5NCOk2RaEQYIzqce18EQa2UQ=
X-Gm-Gg: ATEYQzzjO8CQygof7mLsbw9zZMTAbgPx0wAG3HHoBsxr0+F8u4mRq63HK3FHs/GyXZT
	2NS25jM+fvZKxj0HFm1ub/IMkJaJ387yKPlIm0lTwUd9ALpO13N+YqDKQ28vYrUTd0DI1ozBRZa
	AQ+e/rcfxcmI5LJcHHB5d2V6yEhFzGos5jM9aInPNQwSfcVCaKKwzdez2BGyJXP2H07uQNC/5W6
	r+Gl9NHlem54RjU1Yo2blwfoxkAa42rWMIRyYuShT32XQkYbY3yqM5YcaakfYDHmeQdUr/4Xs8g
	tLy/wzJDLqXiox+f6l4=
X-Received: by 2002:a2e:a884:0:b0:386:4776:2a04 with SMTP id
 38308e7fff4ca-389ff144dc0mr91349331fa.16.1772483316631; Mon, 02 Mar 2026
 12:28:36 -0800 (PST)
MIME-Version: 1.0
References: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
 <05e134d8-f600-4ee6-9ce5-4b2ef199b075@kernel.org>
In-Reply-To: <05e134d8-f600-4ee6-9ce5-4b2ef199b075@kernel.org>
From: Andre Ramos <acastroramos1987@gmail.com>
Date: Mon, 2 Mar 2026 17:28:24 -0300
X-Gm-Features: AaiRm50-wwZDnrdnRB_L5wVboZlzOioJZN31aY0zHl_4JPkDe7dIUnTDL8NUd6E
Message-ID: <CALXtAv1j_6T-Pa6yML41YoAJUGykMxKjMBtLAVGFD0TOOz7U4A@mail.gmail.com>
Subject: Re: [PATCH] mm: add Adaptive Memory Pressure Signaling (AMPRESS)
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	rostedt@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD35FC0006
X-Stat-Signature: fjqqfdap9aeeapd36ucnksd9ab1tghed
X-HE-Tag: 1772483318-199881
X-HE-Meta: U2FsdGVkX1/fEdHpoIdAucQKTckSIMquvm394NDN73O40OOtUADN7HSVm+lHUhYA6qyDOjzYzO19ZQj8r9u/NTOofOIWuURWIvSE0kEPQlYrhLGQ0+9NLF9mEac7uTEiDkVE9NeHAM39xUD1FXwdyWKhhZxkNC+J8k1Ft7f6KgcQ7wUVe8papzIzeKBpMztd7gx7m9xQPbi8ZHyrV35I79QImHY+JMfOTVwMs3To8zO7Ab55a3h4ub444m7JOUMtCy9ej2ohEphZAlBaGiAfLKrIvPERndanUuo6w46CVpon2DMvw3/ibW4fDsmFHphwDTABbrTttyoazAUROwZGUFcvloCj4x6CddZZmwO60zxX7otgQIUW2HsqXU/YivwsprSFrQKPceNswtR+orCrA7aICBAUbBjC24pZ8v86pc+5VsdjkVhGTvbInHsNZYfSC7Ng0Bbs8KwSwgfxNJ9Q7nXsVDdsIhrrQvYeDEfoml1XHiE5XXVSEjjnhId3Oz23JRIxNzgVUv7zBvRv5c0WSKezHDNkI39al4smfQRwXWPTPkTyWREFZOx2Vvfh6IeWf8+2ckWGy68IvxYofAti3w6Rfc8XSpubYLVJFiXdVB9OmBJY5x1F+Av3p0Hr95lJvne/CbfiobAN88gfU0ioMRwD8Pcg37weWfMWTwJF7VMut8l5k5H6MktedFkglLUDVSulEFSFW54Sj7HGDdnl7T2Oqp2xrixsNMyyxjDbNoLah+1g+7TvL+Ve4Paghzm685nu9ZA/x1Disq6/zcORZCm4cCEGF57SwDuNjbXqnXfVTEBicxa6+MWYHjvTtqcRYHcmy1EaYxlMmthXtFDypbG3vXT4FvAz7QA7B9ijQRhFF900w735I+lExFs5+cVqdvNlw2S1XnRq3uUdYiDz7v6QbIEQTpAlvPHM0z7nO7s443eB1i3wv8gXpRabdjoFTwqByD3LqHSGSOPkXeM
 W7KOqwXs
 iQx+BRNlbzXfHTw9/2VlNlrGetk4952NfQnpmKml6uIbXaGcw5sfLjRYi+TXS2dhE+AJlHxxNSSSZqb3f5kBYkpVxKAvBj+MEdPc4/2kYckqMEQL2/Ewv84fIwM+5Ho00zLbp7lDgQf6ebrcGNQdfioJzbF5nn7HU0Gm35o2QxE/EUbmnEGzFIC3qu4B+7p1geQ3RNjkjp+UA9Dd4mqmATSNqYZzDrLnTTiagYYAEs+w7yvJI2dZAIBHopYVqTd1dig+7tKwnKyLtp0zBJfKQlu6UDI8J7FmTqC5DlfYyWKdc6AXzrplFAT1Q3sehdXA38voSnKEetyMCZmK5CiQDEG33U2eoR0bY/AA6UhGSR6h8lOuxGitZaioNOyobMuIXe2RYIjNNh2bqO2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:00:00PM +0100, David Hildenbrand wrote:
  > Which value does exposing requested_kb really have if there are
  > multiply subscribers to notify? Doesn't quite make sense to even
  > expose that.

  You're right, that's a real design flaw. With N subscribers each
  independently acting on requested_kb, the aggregate reclaim is
  unbounded. The field would need to be either dropped or replaced
  with a hint that scales with subscriber count =E2=80=94 neither of which
  was thought through here.

  > If apps have droppable caches, a better solution might be to use
  > something like MAP_DROPPABLE where possible, still leaving the
  > kernel in charge of when and how much memory to reclaim.

  That's a much cleaner approach. I'll look into MAP_DROPPABLE.
  Thank you for the pointer.

  Andr=C3=A9

