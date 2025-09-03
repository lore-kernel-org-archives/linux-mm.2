Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02114CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083BF8E0001; Wed,  3 Sep 2025 19:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033F46B0006; Wed,  3 Sep 2025 19:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64438E0001; Wed,  3 Sep 2025 19:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0AAC6B0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:13:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71828140734
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:13:12 +0000 (UTC)
X-FDA: 83849491824.26.7F61406
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 64090180003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:13:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e6ZzwxBB;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756941190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGxTBfrf5rFsONCC9HJBGQ/kdfQbCEnToA5Y48+NVH8=;
	b=dyhPg2lGwQJqegUrqqf1i1VKcvFa4OKWdsOH85Ivpc40EoFTKuCVMhiPhT5hKI+AdhSPsc
	jUjbOrxLpkpHtqUpHA7dK8Pgo4Bbc+kwBXMUdTTCxv7ejCCZAFFc1HqQMSjU1NfizY/7XJ
	sLNM7Ie1bKzaeBkdQacnUcxvc5EV0FY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e6ZzwxBB;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756941190; a=rsa-sha256;
	cv=none;
	b=AZohH9xzERXAVv0TTufUzA/6h7MU5iwzHutmSCGsgfsRWb6ttAdQ57n+cHVVyl2R2lyCx6
	X9d7x0FR7A9Q7tP5JT4o9k0ZFtsyxkuBTxpOvk3gDOZH6n9yertt9+7EN8fNNIdKnWt956
	2ukx4XKIiRyx7HMEGCJ5P0KTkqpeNWo=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-80a6937c99bso53240085a.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 16:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756941189; x=1757545989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGxTBfrf5rFsONCC9HJBGQ/kdfQbCEnToA5Y48+NVH8=;
        b=e6ZzwxBB7y6HYFVyermoGy7/knBP8hlqOMJAKiBXgFV/KaGl57uF2UAWLxWBUglX5w
         nqjHNGDWD8LzmbEk8OfzWrVugK7CvpoBU07cmRXCyag05qh9MVPx4gDg+VYwWwRdHjFS
         ygo4n6NHztBWbDFngKlmhj1maYiD0k2JVbJAGc6V4L62ish+W6nGcAc1UHu5fvVqZfaA
         wU5gNeHYMWzNhXwdxJZ2h06/IO1Aodaoa99ScJCM+PlCqYY9HeAngZWOboet3W/pWamt
         ZBfJEvMHxwNIhwQsqTasF/8VfXjWfpqiUAJ+TeSJ0HxvA2JOzLiLdNr6xxd0gQTIzpDZ
         YeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756941189; x=1757545989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wGxTBfrf5rFsONCC9HJBGQ/kdfQbCEnToA5Y48+NVH8=;
        b=EYEVtDPAZUVpZURcu2RVJiNGfz9dxCt7+cipN8JFSZeyxovQZuHFtPYwTetvtQGGUh
         H9PQR/zTOhO3k+ZC71tGBUU5d5LzAQ8yRISo++/vOFBD2i2xiewxEiUzsBqqFANZLsOU
         64LDJcL64EmmSCiFyurEP5bxykg9cDl7cp6mjFGcWx9sLDrLFA7W5iN1bV3/BEhmZUE9
         r+N3BBHQ6E39EnhRdiFuLzyNwjkEBSwuoW7Vadt3B8Xjn+dd0MDJ+ZaghAQHsbLe6Mya
         PVcA8OcuVcH+8QsRGUsxphLt/IKlKYdGOxa6yHCgvOZhWRepz90xWB4ObYumaHi7RJxe
         Irtg==
X-Forwarded-Encrypted: i=1; AJvYcCWbZmF+gDaSvjLL5WsqIIfr3qiW09O/ACJXUMIIne9bzemcWQz4OSD2FCNoneib6snUFGNyQrgSNw==@kvack.org
X-Gm-Message-State: AOJu0YyNoydBcFtxVOw5OjmECepcb0A3fp7KkyXx2h8SAbnF6qSkFG4K
	45OiWR5qG4Tz01xck9Y5SJT+kd0xPyLQDuHr7sCdQxPi7yqSBSYidcyiVkbDPAbeLtHhTNYGtn2
	sM/18kVkOlUU/lPp6LsYyaQepFyEkoNkX1aR0
X-Gm-Gg: ASbGncsW2NK9qLjzArlswIV4AgwArhhSM9rakJtthDfK0Vvbsbu/CKAyONVwtzIMzJ8
	XAwbdT6HuB4rn3pTn32d2+WrLghulA3qTeRpoe76oFSg1qiWllo1WNhB/Z4Cgo2tiszYFwp3qB8
	S5f3CeUZV6ULOi2u9YYnDghA3/m7Biz42xtDl7WA/9ER8UDZVPTpj1WhPjkX97u8w4zNnYVrxZ6
	3+Qy6qZ
X-Google-Smtp-Source: AGHT+IFpau2abrWRbQ6A4uKGUrJfNNMVYMekyYwLs3CQEfWWKl3J8XeYxo0PNci/3ZoHXqJZ1hj9M4S7craopEe6L+s=
X-Received: by 2002:a05:622a:1214:b0:4b3:10f0:15cb with SMTP id
 d75a77b69052e-4b31da3fe45mr211322051cf.38.1756941189320; Wed, 03 Sep 2025
 16:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-2-joannelkoong@gmail.com> <e130c95a-103c-40ba-95d9-2da4303ed2fd@redhat.com>
 <20250903200210.GJ1587915@frogsfrogsfrogs> <701a1718-fddc-4ae1-817d-d9549ad71a09@redhat.com>
In-Reply-To: <701a1718-fddc-4ae1-817d-d9549ad71a09@redhat.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 3 Sep 2025 16:12:57 -0700
X-Gm-Features: Ac12FXwgoZxlIzrq8oeC0r9blKti-Fhf4qdYBK9a6mMv6r07wm-GvRIqwEqP5kg
Message-ID: <CAJnrk1bxDbDv_7QTdv9wXKum11t-hk3cU6wQ01NB4bPvV2HWUQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm: pass number of pages to __folio_start_writeback()
To: David Hildenbrand <david@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, brauner@kernel.org, 
	willy@infradead.org, jack@suse.cz, hch@infradead.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6mt98n4f73s51bektrep9u38koecc8z6
X-Rspam-User: 
X-Rspamd-Queue-Id: 64090180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756941190-366107
X-HE-Meta: U2FsdGVkX18Q35EfGyFVKoVPJE/oNeMFrpykHwn1ufIu7Wbi81urbgGHx1mdjJ4Xb3tIbDu+87IS3qT7M/fahuUBRS+5f8l0lpzDZjlBKKdSAH+eSTJRUffqsLwxlhdocSrVBqNg6OyPNynhA59yFWo1+cQPwRSprhZfvGA44FOITKX400hLCnwaSN/+VQyspuoKy9DAk+ylFj59sNy2lL2L8haj53dt0lndCym5Hlo6HvxpeXBpzEvAbYf4CVrqJVkEHTxkCVOtiQmS/ajHX4Dn69L11m0zPsMbYQ34tA8+VvPn2wrFmrjg30emGPUq8RZpkcSeEJyVeKnUg56DW4Kxwxc39ArrAx5YJQcahWrm5h5unCuhOim0/mrnvEeTc2Zb2y/0XOu83n4WdWGZFkmEYT5zKrhVViUUSHEJbFTLyf0LPBOC9rUN5Xj8mXw1HrxoR0j+2hPMZoXT9XZuU4k5VNyT9Bpa7N7b08GveUxTlbtMxCgk/n/zUrXXr1h2MfQelXIbrzgrbzp4Bxc6eVXHC+mMR1igqX8ZXcGUsfFLA2Vk0y9TcEg2TF/+YlRSorODf0cM4J0BHx7p1FLEk1qYzqc/RUGZxMvKIjDVZh3hf2xGyfUvsEMt2AaFFtEaEpWSsqxrSPhN1MY52XeBwvuf+n1kW9QPpyNyd7w+e0X7AQRvEiHHiFnrrdSEH+7otfCMP79AerDecEJJIzd7npC5YSHwAePXJNZ7owUCguXQc5yOGw9qeb0wwA10z5sT934t4wsN9hjVH5RqXm1gYitWR6NwQUUCPs9jv3H485C5Pp4/aGuze3f3Dc4bxt7MueRtq/bdgo53Nz45vKfRkpOEJi71qdz4kYGMQ/lyje68GIePuYTlqrsInQJr5fFB4Xf8+VRSmkJh6B5vOMnxT+Ivsn2IfBeUF3SFLBvJNbw5cpDQLoqhRiv0BcTBNijfaToDiTg6iKg1UbT0cl5
 1Sza2ze8
 Nwh9Cz75AdcE3m69ZMCp54428kuDJT6zu8WeeBexe4WVSkcbooRGUFXSheww5sNJImIxqa9vjvsG/eWQY+KjDeQJCSI21Uyqrr/guUBy3cBIP5+kAKskwKpxtSQzhB2OCYK4GRab/nIjyTMSPOK8tmz0X/v8DpwKpLMtY9MYNL0RKsaHrUHLNCJBzFXsH9WlcLvNfrCxm9rQ5EDE5mrPyba2C/czSRR4LGyvRvd4AJT45g1cxr57BgsXLmDvp/D1phbsHFcyQ7NDJ7tc2itOEj+43I+kPfEywFtMG5BCI5TiEwx5sQWzGpEo+y/o37eYuUtXsEd1Rh5xlfOhAc1OVAdS3zXByUkzw6RmSz11MOJaMlbR1yacFb8AVoXNUpkx6KnHepTvQveA857TaAqspRUyeIw0oi4aXRQT5Op1NBY5SQ08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 1:05=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 03.09.25 22:02, Darrick J. Wong wrote:
> > On Wed, Sep 03, 2025 at 01:48:41PM +0200, David Hildenbrand wrote:
> >> On 30.08.25 01:39, Joanne Koong wrote:
> >>> Add an additional arg to __folio_start_writeback() that takes in the
> >>> number of pages to write back.
> >>
> >> Usually we pass something like page+nr_pages so we know the actual ran=
ge. I
> >> assume here this is not required, because we only care about using the
> >> #pages for accounting purposes, right?
> >
> > I think all the "nr_pages" here are actually the number of dirty pages
> > in the folio, right?  Or so I gather since later patches have iomap
> > walking bitmaps to find all the set/clear bits.  Perhaps that parameter
> > ought to be called nr_dirty(_pages)?
>
> That would make perfect sense to me :)

I will rename this to nr_dirty_pages to make this more clear / less confusi=
ng.

Thanks,
Joanne
>
> --
> Cheers
>
> David / dhildenb
>

