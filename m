Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14CCECD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D7C6B0088; Mon,  8 Jun 2026 03:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD756B008A; Mon,  8 Jun 2026 03:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECE46B008C; Mon,  8 Jun 2026 03:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3006C6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:56:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8C84164ACC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:56:44 +0000 (UTC)
X-FDA: 84855988728.17.624A7ED
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id C79D240006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:56:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OmyAQosU;
	spf=pass (imf01.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780905402;
	b=ySOzcxSf/bnnoqqKbQr0wFYYr+ITMRxbBTSFbXaGbtd9cZNDHuDAXWwKxA+LX05jTcieHH
	9+4JjAlB0/W1I5t/Vimnxy6xcuZ33/fGwWmLbSwIdsWj9nOy2Q7iLYo2lgxmiTuVRDv0HN
	k1zed1kjMLJqJkZiUSUQTG7bmWzxgvE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OmyAQosU;
	spf=pass (imf01.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780905402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7MhUyKLpco5Pty2ROnWb6vWgtSRv98FtHcFuzCTDt0=;
	b=izp9uDlwtdQYCphYZYQDlAbbZYT3vSdFPrylcmgi1Xo53Js/N9/b4Ip0YyFScSr0a+wyGx
	KawsvN8OfTD724vc1KOp9n3H1CsxjakSn5fxVHTWDB5sXt+EmVlOZSY3rKFL/VAMHcgQQ4
	6xj7lDQgsiJtj+8dQ4ZSS6E+vSycwX0=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec49f7e35eso521783366b.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 00:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780905401; cv=none;
        d=google.com; s=arc-20240605;
        b=hBzHjU9bVP2MPPxYbQ8DM9ESV7q9DOoktPTWENaOkqTer7ybTsg60KcO9h49SdjePw
         48iS6Wy9UA+7kLoHmccjCK0InMToCEYqtf9ZKUW0V7XG7+xVi0UHS3W8Ep6xjpvBzadY
         u0rOS8CGOkeFdwBaeSA31R5Bkfaca4THUr0mLPVYDWHdkuXkPhL2qb34tu588JSLcXzh
         +jhgNby6gbPdC2cBIDFFHyV6Klrb+7z96qGg6WikzcjaPJIXb+1I8IrU9lh61qbsfMdd
         bgeLMwP+qYOWpbHlUP1pZcVGyGTlnODyV2VMlW0wQudKNCYlMOeyjrn8uYpPQAYX2Cnq
         r+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=v7MhUyKLpco5Pty2ROnWb6vWgtSRv98FtHcFuzCTDt0=;
        fh=qoaKFD6Wezumw5euxU8SBakAAqcjUXI7uKnaFlGvaBU=;
        b=QtEJlq3vNBqoOwlgM1jFSzZ+W0Ktde54rv/87hMTOvMV2VqCMUyVUAhn22IDYrrhos
         kkSIoqLrGYlXcO8JZrjDkKFOrL1sWSsvBlKzdeZj9Wp+1rdfXStpm3XDpY0rXbXDARsF
         qqRMoNbm0K/IhRicZ6dNetW0rOfFu3cv5VfGvPPyOPB6hX6u6YzlmXhHBNlATc7L5jPW
         L5pehtRnPAw+lhw59i7Zf7eaO1+YYnvuOXFIYQTGMhdTIWqBqQlUOAyc7H1bmJmuYX2d
         /wfmJc5IvaH2daFeHcY5qezs6tLN/tP5xGDYOujTjfA2YzhgiasLLv9XFHjfex3FNCpA
         zpzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780905401; x=1781510201; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v7MhUyKLpco5Pty2ROnWb6vWgtSRv98FtHcFuzCTDt0=;
        b=OmyAQosU+THYkw7iSV8luyNs5AA0nZZUDentNa5JhFpx3CxTwk5TbqL/NoeOEVEQyU
         HBs0Ud6IbQzmLKq+RGPHkwKBV54pfe5E8GSmcvCRBPgu1d4m6BzEfCYJv4X5pReAQDmg
         Li//vKuZ6+7kicf8e8qzVxVz4FjNCHkXdTHuxWYJjkfxRJfR5tyoZep0J1uTDk3eX952
         KGZmtD1Qqg5Jp7FZCS1+ZnT7hhLa9q9Wyltx5d5fOf9b7mCzeSg6h/p7jCmo3wK27HNe
         lvMKG8Igx7SxjWiGyW5gQ8P7KL62piLEiPZjX/k6AM6v8ku6ZaAjuUTcTMXWSJICdT1u
         ylww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780905401; x=1781510201;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7MhUyKLpco5Pty2ROnWb6vWgtSRv98FtHcFuzCTDt0=;
        b=EqODtZlTqZX/x/dV0W8DjMICCbJz9WhSqmQ5gZRD9G8yK5/rvZ9jRYqZiX/xfk2Tna
         7PdH5q+zIuCtbmHWUNLu4DPz+bcgEd03O2WpNa3z4KLfvalWtGD7MVrp5UwTZcngvPHj
         2j7dtyDwwwdAuWIv5rKbzQ4Hfe+ySV/8WvN8Rxvt71lZuR/0mN7UxuWyyfSxc5EOKlgR
         xRHfEjvFiMjoWMXMHi7XNE5fx/g4kBuIVsYsE3Pe/BMhGWyrghlu+GMDUh/9TeA6qKAL
         +uZ01IrGOE08urs8lNGS/jTHCfri/LE/3z9ycm4wRwQjwUHG4ZP0zjFPvEqjBxp7SWlU
         ABDw==
X-Forwarded-Encrypted: i=1; AFNElJ+5mw37zntdzBSSqsWAZ2GkZM8GGDvUwDDTdpjQsDIgKWW2VHuTbaWkH6+y0qAYdaetJWwyrMq7xQ==@kvack.org
X-Gm-Message-State: AOJu0YydVZcj5hxHNSwon8skiU1gYFPMba5ARBo7ChB/aT7T7k33mHOC
	giUpyQDkD86tkiqJKYchU2dEheIN4Uc0Inc2wQ3WcFmQIJyN8DtOgr3qJzUwQJKl+y1GkunIxwg
	6hx1ogjU6VyriIfBkDnGNBIkckDnBMQ==
X-Gm-Gg: Acq92OG3q+wicsfRwBiONdRzwMemLFWlX6xTB11dArBjhXH4k+YZOV7bFCSWwpE/KIz
	vlMSrVdwVXpZMkHj5GynsG7Ai9L/TIQLaUmN0e9LIhuJ9BnqNokUYHc07+Evtauw+ex7kq5d03D
	0w0njmjaOSuSj65qX69cvHApYXWS6HUXlXqQXJ/0HjyW1JQuscUfXCKxppY7EgyjJBODctdebP0
	FGcENjDILf4/kR420yaZYK3nDIhZBcHhmjZTm1sGKMI5h5j2MH60ESbH0YpNGl5h7TFK3z0Tyx4
	V1LQrwNahS38YCqzd3uttosmh8Lkor5VpoJzM5OANd8qRwej1MYRH2M/zTMtZVEcnLW4F6mYggc
	2KxnkDU7TIW1V7oT1Dw==
X-Received: by 2002:a17:907:96a1:b0:bd5:ca8:768c with SMTP id
 a640c23a62f3a-bf37234aa66mr653540266b.31.1780905400661; Mon, 08 Jun 2026
 00:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
 <20260607070645.9559-1-med08elkadiri@gmail.com> <7906bad7-4e64-40c0-a724-f55ac44e12ab@kernel.org>
In-Reply-To: <7906bad7-4e64-40c0-a724-f55ac44e12ab@kernel.org>
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Date: Mon, 8 Jun 2026 08:56:29 +0100
X-Gm-Features: AVVi8CcGNyoLbmamtMoNx2-0ZzTmIKgNBdQkv4HaB4rzJNFkS3LOZowcqOrQKLA
Message-ID: <CAAMeuQQFgyS1KR9tG_fW3yXhftmt1Oo7wALnc4WhnNuRG0x40A@mail.gmail.com>
Subject: Re: [PATCH v2] docs/mm/slab: document cache isolation with SLAB_NO_MERGE
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C79D240006
X-Stat-Signature: po1wyu1ezj45nb766p9s77uh5cx16e1j
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780905402-641821
X-HE-Meta: U2FsdGVkX18FIp3/TW45/6pLFemsjY54PHIkxd4X80IbQIVr9PpaXOJz1O+20U2P0wHfdGCuaf3R577cpvCVznhdpXXIwoen3HmzjVbc4K6phvwatzQgixe8EcJLqWgxG83qmHyNYokzuGnPcKAjf/ow+xzJwv3wGBM6sg6Hwf7MxT1NNMNVUIdc/UgCtgXw6hfetVWs24mc24q9KIJabUtwsdl6KGSWCkT6qfpcxVZVH41wWXSLa8e3aJ16vzINpG8d9Nt8rIY2QM8bxyS5PYBhfVPfKvzORM4jHT0vZtAPxNwmoVSMa8cCG2OVPeGHecnK9NXUsAWI+R/ojUJGuMX63DPRx8BnTMBA0pwt4zF+Zm3QKi5ZxLGucxebwRL8Y/7604jgjP6MdjUO/CJmaM0LsKYkJvxXl/zO0K7i09t26Bn+pt79APBYb1H31V4xS6/5sfPRL6jDIhPcHWstSxiz8iLjWdzckNvm4s2u+RvroC8q8VwXNMdsZmyXxg1REYtFv6i7RPacoiCKlTOyMLwBTdGv4TDadq2L38PBuBn5xS7xutXrs0hsrOTu/cX7wvpS1QqC3ecu0ppuNe0XJ4qZiVMyqYYMFMZIvIp/kKk97hEPNsvez2zPaBt21SI9lygIdTu1v2u3p0Me/lhtx6TS1lyuebuE8HxCNmDSbAESo2uxSJGRCXO4t5E0hEvXVugNMzyEu35VB1mBC02SRa9pqUQnc4yzH0qk1/FKRdsdKJ1dPw8TTubA8St2xPB0oh3Ip4FeCP8bZ2Adps8pCo/Ya4HmwfHKEhFMYoWgGICaUYVdP5yMgUUpy2ww8L0y0NXXO2ZMFYcRiQREbe5bWXeaS8J3y8WedSnUglIQR6Fv9kbpgX9a9JSlxoIicv2GI3dB/BhnhEb2cZvRQ415NTFWppv6ux8ehKnFSUUKd/YZcqQqL4lN7jx5O72g+T94su+87YZc5z3QYubLp2p
 Cr1zVgiR
 IeVRrEdDo99i5weEG5zIMaJJqCYvEvdy1gyt1pQYQqOZu3rmGqUWifCzWw4GCgo+64ua1h261EbC7PiiyMoXJ7lZTAEvjb30HNlVCoux0e5NbOhBGSz5jmrvR5eISQ36UupTmzWePFWVnch40wWALPadKmBx9gBgR8HFjTubBk0nGU4an5WgBTvMc71KqWQa19dKza0bcs43nuJipcGcafi+lBy7XlBw1YVeA3xjkiAKSc4NJb2bP0jcPfj6FcMsS/xKHEZV/3c34P5ZzgBWoAeabT9r40Ycs025ezOvaG8+muU8AOsMvAgwKIsi0aT6YUCD2oZvb0+td4KulnH00TIaE1MUt9jsQWobWg5cPdYt/8Vd0zVJxImMbc0AsgICSRBtEURRYnKVwcDCG5UvVrlG/2Dfo/Ovea0EM6OI4jdYdu8MHpXfFYJXkYrh8Vh81Ew55
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil, Vishal,

Thank you both for the honest feedback.

Vlastimil, understood, I will drop this patch. I can send a small
patch adding a comment above the SLAB_NO_MERGE define if that would
be useful. Otherwise I will focus on code contributions going
forward, written and reviewed manually. Appreciate the guidance.

I will follow Vishal's feedback and send new iterations as separate
threads going forward.

Thanks,
Mohammed

