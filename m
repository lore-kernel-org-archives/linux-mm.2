Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9467CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 18:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E646F8E001F; Mon,  6 Oct 2025 14:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E154D8E0002; Mon,  6 Oct 2025 14:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD308E001F; Mon,  6 Oct 2025 14:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA3E98E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:15:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5086CBA938
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:15:13 +0000 (UTC)
X-FDA: 83968491306.08.F59BB8B
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2849C180009
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:15:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="M3Dy/Glr";
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759774511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+IrJM7m+IGfKJ5wujAoW0yQ4XN9nNk26XjqZOP2OaE=;
	b=UtQ0fVVdnj33iB8btGjz42VGit+pflGL7gwkrdoJxwxlB6S0gHci7Umid38hK9PtlIFlXI
	yyzCW5L9ud8JHILcsYlC68mhkyGeLa5FgrtyjqVhhOdPk2soe2xhRIy3JoSyop1fRWDdY8
	bVhvfX9yEaIJYEcfWPCZV97viLYph4g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="M3Dy/Glr";
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759774511; a=rsa-sha256;
	cv=none;
	b=zjEUwbo7fm90AuSAptEOy8YHpxiVXRabFrfDKKHJGEegB1MSyj4mVmQcuSUEz9IYzvcJJc
	ArXzxNTU/VOhzhfsbAUJIxxMAGgw2XpmK72xHPDcmsoEs/pKSB3KgxoumQjmZCMY4SHvet
	ChPUxqO+XaFyyrEs+5Q9CpBmlVfuhGk=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b4c89df6145so346616666b.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 11:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759774509; x=1760379309; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G+IrJM7m+IGfKJ5wujAoW0yQ4XN9nNk26XjqZOP2OaE=;
        b=M3Dy/Glr2ToUQtOelJFD+If55arJ5ZLtunM5qXPIicCOV7UIolFQ0L/SguPzc1eBXs
         SavcbBdBICQ78/xMotjF+xKGoQNdt0fh1FFRrRVwANZihyTdeZLaq++L8tJWcdO6DQAI
         CpeE3bxK/fGwA5G0Scv+cB2KvbKQtQGVT1sxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759774509; x=1760379309;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+IrJM7m+IGfKJ5wujAoW0yQ4XN9nNk26XjqZOP2OaE=;
        b=a+ejkBP6+E62l8gmIKS85AWNzLLoeRpAvRmkL7aDywtbo5QOZWyidiG/HPlUInXxh+
         qPB3wS7MWEpgYPPpGVhyhPJ7SprVnminYNdj+4y/QM3EBMzLUn/nlEHWQEO08tGH89il
         FAdlzg3DC1OIPBVAw7n5Er0f6v+CgOw710HbOI/YmLK9e3bZbXzTCccuSdAnO7iYpbV3
         DGk6+AiqRIauwmLebklAKbeXcfbDrAMtS6QDJx2mdURyyeaO3hRQZgylhtCNQ2TtxCTd
         xn8eKOabvYRngYK3M/U9Fq4cTI7TLtbfQh1Ao2HcQunzUvoH8rdR3BExzOi09BKW5PLG
         zMfQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/WDHuQpLtQJ7lVPSH/8UyNEaAYJOufJF0xxg2KlYT3hEGTKsCiUYBWI3cExX23jZzxs9CrWo1dw==@kvack.org
X-Gm-Message-State: AOJu0Yz5cKytyzIo5HT3Vb4WxG+DtUTRghIofKWAryWwhZdQvr5nrfDY
	slud6sH8gQurhYIg4bU5+V3wVJt0KzZ81ChBS3aNRO+odmpyyEbIeJCT6f8BHh/5a2nkIPYv7EY
	rHo8QfUo=
X-Gm-Gg: ASbGnctTGZgQYHv9KlaJALJJs41oPyaMuhwrQvLiyi99ardm5Ld46WS8fLlfigUp0hr
	nlBXrFqHi9QafKTwzDoQnLbeQu4vsiOMIuDruuVoAI04ZM3CHdar5hcXV8cIYfd/4wTqkULLPV2
	ptshGHjMlo2zF7cgeW+eS0VnQDRwTHCU7Y8cOJpSj9biaxDHfK/q5KwwkiMXgChwjxImbs+Z5CG
	0dwWcLoGHhQnXPGJVPxFUX64tpjsVTD9lHW6PoKE6ImrrRiX12ov6EoDoVe78ksrQFixlYM7jHK
	ktOiSZc1xDGxw40YM0tHItgCPsXLK7mu5B9zq3CjWyF58/37c3+xaIgWxeSzz6UERsTly/KkreN
	/JkU3vCPwkMKk95NyNc4bYqQzP6JdXqZaTBX2p1sb7iLE17M7gu66fdIIS0FWUcWuqBq4HJhRQe
	u39bnSoQlSBt/rate/FBFKmozfdZUUK5pdWpVvpgTpcg==
X-Google-Smtp-Source: AGHT+IHfhstwWcLpxDZmZkfp61yCJis3CTcP+zrXXJ37OywOSoUN+Zm4DsT27O59rNEFujFQ5eCGLg==
X-Received: by 2002:a17:907:3d0d:b0:b41:79ff:250c with SMTP id a640c23a62f3a-b49c2148126mr1625101366b.23.1759774509010;
        Mon, 06 Oct 2025 11:15:09 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865a83f4esm1202484166b.30.2025.10.06.11.15.08
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 11:15:08 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3d5088259eso770227566b.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 11:15:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWMOMM68bAh2aoEye675gqbho3g6mMGzpwngRo07Q3TOrYBZQcIrvwjgem7JqmvHoMKhWZYtZjDFA==@kvack.org
X-Received: by 2002:a17:907:97c8:b0:b3f:b7ca:26c5 with SMTP id
 a640c23a62f3a-b49c44b0c80mr1722317966b.59.1759774507739; Mon, 06 Oct 2025
 11:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com> <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
In-Reply-To: <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Oct 2025 11:14:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=whG4TYkS+Ns0hbx4XNbvQN-BAvq9_ABJz1bgBsA4NPDAw@mail.gmail.com>
X-Gm-Features: AS18NWBukV_xtmU11JJsDRqxO_VMhKc_Ul7jDhpyeBLq29Yx3q9wMoG-6X-gkno
Message-ID: <CAHk-=whG4TYkS+Ns0hbx4XNbvQN-BAvq9_ABJz1bgBsA4NPDAw@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2849C180009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: w9k37r9sz9bzoiuxsrhgwymy49sopj9j
X-HE-Tag: 1759774510-47404
X-HE-Meta: U2FsdGVkX19QBYuVWYKfynbuPsrZtRmk/jrpxlkubAN9zEpJRPoaoYRGmfavWrjj3/UjagWAbqdeEZ07jbaFMgldNl7tnl4qNPT5JwhSBIV7s/w113Ucu1cntK3eAia5lDN5u6K29jW2K2G+jpuioaeWES9CEACAsvGRms9bYHuuqyBBZ+AWok55syEmgVYUqxabXcZFI/9Nvxla7fEJ23+1XRJTriFXj1h0RENouLfJbA6vTl297SxIMiPkNB1gi+GpWvp0SBsiWOcjBSVUSMgozIWgDc7zbBlnCYEhmHZjroxY6gv/To3EtsVLr1v5yFvRw+C1Ln6tMUo6D0nIqpgJCaqnuOv2gCJjCN2JTCXBaTYj/R64tnmGT5K+0wpBljawm1mqff/YtaiFrPGGRo5qp7a+L7bFFe9d6qaA2eRX+oHnU+UFubNWMAphLQnn0xUyBHhu3rXsjaD1R8Y0nOrff50Aer/ChjLaONzodkG/Gpc4si6KvJZCWMkf56nO/BK3GFgy035EmSVm30Z3saA74sBmn360AeON5A3EkAbP82cdBl8bdwT+2EQozD52XVJN4f8RCwuGfGKOGBQrioBL4nAb1QC4DV0SBOO7yOTo+4DTfSp+hHoM0SYui6tDLXnTLwqXIIYNEWf0EkGL3h6FQdVyQ+Kp0abUqaICMmwDkfVo+MizHHfiXnouSQG9U04wcZaMwjqZjZ8sksueZYMDj7f4Lr8A8VzcQTBLYKWoVPpzaCIfDgxU2RsqR9ML59lvteezbK20sp57h7V3J8hU1s+yaCixobvfoqDGomKaknjUx3UsX6LYxtAhBnbosdpn36qzfdR8zXE4YFHqdmh4tVqgluivr6dLcn0IY5oNVSue3iCrWwsIFHP3CIxXo8VUlXLImmaZcOK0KZ/W/QqiSiPk5GVHnSajEkwbZbFEMV0lgT1X8CMt+o6MDnjg5E18FlwWK+u9I16oEyd
 OOVtzG9B
 HJ3RC7TWaGf9t95T6jiZAqY12aLpbz6ri5l128SLtuLrQSLYZJHkCAIvqN1kqcycLgbKSvaVc7Z9gyXjyo0N5vk91qMsXXkzL+zRc6ONBkKFen6JrLHEpuwJuumZv/Br5mXgdx544y9tW7+8QPdZCcQ2nmXvY/2/llnTjemPOxthax3Z5hlPWR3aus9MpP4htI04DT8EA/fysBkKluXb+tJMuW0baL/DsDoe9rN7Mgiwd9W115nHfD8ZLwhBB7nVWnQJH0u/V2wewYVLwdUGVE1xl4kCLCwolpFiJ5BxGMN3VHjyaE5iOS89/kV3YB05RVkZzy9eg/sr26tWTCOWQdzZ7uGRq7+d9C+t8dhS86U+Fn/LtACCrB4kZ6OaS1j9j6BpyswSefGVtnJUGX9HwkGVdMU6BE07h81f2VPwzeoywdZyP98bmsfWzzGeMKuvZmQZgNQy+ZQTnH5lAmmjfOt8zQW8rcNhiRq/SXXc0uODDYuZPZvtzg/gW1H4jImHCixDw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Oct 2025 at 11:04, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > So I think you can just change the seqcount_spinlock_t to a plain
> > seqcount_t with no locking at all, and document that external locking.
>
> That is not a spinlock. It is lockdep annotation that we expect this
> spinlock to be held there for seqcount write to be valid.
>
> It is NOP with lockdep disabled.

Ahh, right you are. Complaint withdrawn. I had the "lockref" kind of
thing in mind, but yes, the seqcount thing already have an external
lock model.

           Linus

