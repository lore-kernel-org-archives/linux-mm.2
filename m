Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F67ECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 05:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967786B0005; Fri, 12 Sep 2025 01:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910536B0008; Fri, 12 Sep 2025 01:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D81A6B000C; Fri, 12 Sep 2025 01:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6399D6B0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:10:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08D325A1AC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:10:16 +0000 (UTC)
X-FDA: 83879422032.30.B56FF5E
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 34A2B160005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:10:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LR+awPzX;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757653814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbPyCpu3W647hBHDQPOVQFsDCH+I95wEJ0zUtQfDIl0=;
	b=ywtwVzLPPahTMAM18asRKM74Whc5LduR/ROAAHNjZID18wNcEkWbRN8LkJmTRGbSRoBug+
	2JM3WcaZYuReE4ln36CDr+s+AG1gYGlwXsnYQLXMqbQ9kGkDfAfwg3p3oYuF0z+N9uc7Sp
	xDIzHCUQhVw9pDpVKMfGAiw1RhbY39I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757653814; a=rsa-sha256;
	cv=none;
	b=3yGsuZ0R84uhWdb4/I3llrto+Q+opWK6loj7ImL6vul6RIVoLTIhCvGGPa6hw9h0Mbla7+
	HZg/aYm++uTEHySpmDTnXlWtk5r6knR2a2R7jBN7wcZ05mCRI4x006Wu7kD24dUan4yaoD
	+TImg4EkXaBw0XEQ8Q1KenUqKMlkJCc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LR+awPzX;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b61161c32eso19135041cf.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757653813; x=1758258613; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qbPyCpu3W647hBHDQPOVQFsDCH+I95wEJ0zUtQfDIl0=;
        b=LR+awPzXK0S1RrSosuHRgXNCOmJ7wZGXk7LrxFaG/GSGwDJEmOqTxTfyrzjjVwk0mo
         vBlHpnQ2sfiFoibZqvGYI2PSfNJXJO/TyFA31IRQoQgZ2ZWRD8ghnENnBMOYce5Fju5v
         2Z/0/K/GgVLkhQbqMgZp1QArgJUOjzupP3dX526bDR7C/C7Ocw/Qr+Sr9a2gKGkY3U2b
         fVIQUPVBFdW69PFlNsL9w4vKYl6k+EYquSLGqMl+0dyrrWbMfPNid516s3PSTCRtF+py
         S3a7cAXUsnW3cSdfDhU6RVvaAggyw63nQkEryX7sgvYugHNatXeI5A+eIcVK6RF7Bxox
         d/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757653813; x=1758258613;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qbPyCpu3W647hBHDQPOVQFsDCH+I95wEJ0zUtQfDIl0=;
        b=o+6bzuBmlfUE+cui9ZNNqGyrquCsBwVH+kLhAMFb/verg+ZcZ+9+RrffArL+I52BQ4
         BPMMc+poDhEosiw+Eyd+wbb9/Vl0KBirMzETfrcbP/m4U4VtPAFVdsgakP8PZDEwintt
         eANxLMJ0/w7hsV2osaXyWCPCLsx5VFZeJ2J3bv9UEWExjvTbwocJDZ1JqCbZ2S3+eUcj
         LO3qzbVqf3TH/AWs9hXsmqJ57kDXlJSMYBw7R71+60b4EmKeeCxpxou9Z/v1K2naveF+
         YX9vykz0OY8EzHF8e1a1wMkgo7Ci6a3ua25PZfwG/yC0wwmAhINp3ef1IRFSc+EbYa1L
         cb7A==
X-Forwarded-Encrypted: i=1; AJvYcCXoYjs6Bk0atgckG7bg3+zaDAYP5kvY05sEuMz6sfd1kI6Ky+TcMEn5yCUlzSMee+OIjleSgRJQ5w==@kvack.org
X-Gm-Message-State: AOJu0Yw8hfVMRwG1HjcGw13pUasRoiEd8XN8cbZDiae9CZXrxh6OPMo8
	82lErgzuZH+6gqtX69Jl9iWd5zy/Q536uSlHXQoOjSYLcwD/e/vtpujbOH75+S4DeOSifaLwwNv
	57WOAvGqevgCysqwMSMWylop/G4+8hGI=
X-Gm-Gg: ASbGncsrdWovB+vcIbUi5N6XFDyzvxMAC048ruPDOIfvzVvUSgtoEAKCOIxsHjTtvlW
	jxsbshDCBYY826hp2wCBIXvnwoPcK/tlVW0ihrDaMKNFLwB8tpFkwweCy+hGri8waA12uKZWx/f
	fRt3Bm5PGyixbeHOboMz6zXXPWX+ogFUABgh0MaATMlSMfjkd3Q7i2whUnm6jel6D+cxNYcfAP9
	qRN4wk5BSp1VI9gCfqT9S6TavQMpNbzPT7m5p/tHvLNTr9lMQ==
X-Google-Smtp-Source: AGHT+IHg/ZLW8OL1W6sAQgPgoAtj6sEmZMsyMYpk69Y+kGyyxYWpRGNOcI81o64593HxM+7/IRbGxMx4DAPwyBrPpCw=
X-Received: by 2002:a05:622a:581a:b0:4b5:4874:4f92 with SMTP id
 d75a77b69052e-4b77d0137b3mr26934041cf.13.1757653813012; Thu, 11 Sep 2025
 22:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
 <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
 <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
 <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com>
 <CAGsJ_4wux1JOTQjT-SdWOTOT7-+eFMQLKRjKNrhE7vE31u5Jdg@mail.gmail.com>
 <CA+EESO6eNfb+92+uYDRRWdx4SJnHGY34QtzbWUpoB54yjvL0xw@mail.gmail.com>
 <CAGsJ_4yJYUbP5DZcmvpe7GwEDYnjMsycgN0TXKZoytrCk3VXxQ@mail.gmail.com> <CA+EESO7yPcWMgUv_-sP+h9qs=ndppYM-Hzwq5tWpg=DbOUpirw@mail.gmail.com>
In-Reply-To: <CA+EESO7yPcWMgUv_-sP+h9qs=ndppYM-Hzwq5tWpg=DbOUpirw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 12 Sep 2025 13:10:02 +0800
X-Gm-Features: Ac12FXwlrAc8yHNyRwhoNp1v9EgwoCTboeWFi7-eYrxh3trnePxE7thhtssjOho
Message-ID: <CAGsJ_4wrAcTuC+QuQk1qNOFQhEz=ocCmQ+QXta-BpWZeV2iJmg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: koiczkf756zucuurd683hcxx3bckf998
X-Rspam-User: 
X-Rspamd-Queue-Id: 34A2B160005
X-Rspamd-Server: rspam10
X-HE-Tag: 1757653814-73132
X-HE-Meta: U2FsdGVkX18DA0y0bwAQL8/FF5pr88jfdw+llWKsN+gWo7fAE5gBv0rFGeJRJnfwYwQBSCRXEIwRQ50wlppI9xA9sv3KH5dlaixC8zDJ7Y2QGqC62D5QHoPY4m5d6HP2q9lJefpGWm25bfQ5/ws9bGA1xHJZgQZAgm7oTVwWkLqmNx0aQxkySwxoeoFTPR4yieYB5StnMI6dR1iOWZYZ511TCFRNtuIwf5kRUEssD/XNTnzcSqcwUD3QnFF85JxVpWQik+Ha8Gi+qJAygfMQJqWDrAg+3Jqz+pSJPGYc98BGJkd6nYic7lWDKpHEmGIYO5cn82UIMfyqu7EauJZZoNe7YECIrxFYRv29e2EknMI2ZvI/vcae2XH725UOBMc8Qy9fIn/U2U5PQ6+1f3tKh26zX7zMu0sZUYWwyE33oy10fWbFyhsWunMpSll1qce/XvT/yfE9U9SGCmc9vPF9YDcmIaH4ZOT3ozac5m4ePGIAC6KyzaYlS15kO14CKS5qZ7l6udFnX+vJWzUh/FW3SpILQY1yKFpM+hHSGTQEw1AVS3b54etzPrVhzJqD47PCHSal1n73dfL9mLqTbbV/gFj584et9QQDG9P/4kF1gOs6bMZpD+1HtHfcwnzpU2mNKuPBn0SUVUIW7LxlQEY2MwjQLI8VZT3QO166GqK9Bjb0cbmWfa7uHSW+ue6A5Q9zxiq50alrd33qB739Jz11eX7kK9pRX7FcRVNwK7UyBtko7bazh4Tt/hH5mIuV2HWzxIbwh39JQZdCnuH38k29q6UJpd0slnm7KtqMfahTBdo5bJxsU9+Eak8oQwYjE6pdGe91aqJ2QKlAzSL/SRWZ29tsi6m3P+G2pdhDMhiJK1GHlZdl1v5e8n6ZkOjEcs3aoXJ5EAedj3+qfWlrkBcuhPLnN+gpefih0VlR/nOnEnxkPi/aa1F+HgeivAqfoAXQZhDF69BKXATFoXO1mXH
 NJr9QeCt
 ux0S5S9yhP18Unr6wA7cVDoQAMFOmZ8NtozkkbQgMppqpJZ15/qT8nyGxESDSOTJcyxfhQ0riQ1v4IwWIkVjBsuXZeL2KMbgX5TibvaOd9iYmCNlRvFDiKwOeVJAD32Y1C1WUhxqHJxgQwkhRBIv5NwT+yyPEaqBCQM4o4fKMdyDcU+4VrxaA5gjvDdwu4MCngwhJ7V7hamn/8X4g3hV+NRmzoqerdPuQZHK9/I3qIfevVR2NVbswTG1XwNSpbHJbxQw1QyiUjxCtKun5mPAYjHibLQfSTH8y/JQDQaDzlUu9pMwZELAcKQQmK7XGDJHSDcuhJqxTysd0nwS+VgGCSDZ5mSpor6IXCWNvyquFh3e621zuywparh8dDThb6MBHxEpXbogZtUWc/YRLg/qFw0zDEmZI2FTGe1tCgjXpL9UPqhYQBGQeVF7fdkD0BRV/6SBnkNIXg27e/bY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
> > > > >
> > > > > IIUC, shink_active_list() doesn't behave any differently whether there
> > > > > is contention or not, except when it's an executable file folio. So I
> > > > > doubt such data would be any useful. Please correct me if I'm wrong.
> > > >
> > > > Since we skipped clearing the PTE young bit in folio_referenced_one, a
> > > > cold page might be misidentified as hot during shrink_inactive_list().
> > > > My understanding is that as long as the percentage is small, this
> > > > shouldn't be a concern.
> > > I see. That makes a lot more sense why folio_referenced() is called on
> > > all folios in shrink_active_list(). I missed that young bit clearing
> > > before.
> > >
> > > Any suggestions on a good testcase to gather this data?
> >
> > I would run monkey for a few hours with some debug counters, e.g. how
> > many folios pass through shrink_active_list(), how many get contended
> > and moved to the inactive list without clearing the young bit. If the
> > percentage is small, we can just ignore this disordered LRU behavior.
> >
> Thanks for the suggestion, Barry.
>
> Monkey test wasn't successful in creating sufficient mem pressure. So,
> I used an app cycle test. It took over 1 hour to complete it on an
> arm64 Android device with memory limited to 6GB.
>
> During the test shrink_active_list() got called over 140k times. Out
> of that, over 29k invocations had at least one non-KSM anon folio.
> None of the folio_referenced() calls on these folios ended up with
> contention i.e. folio_trylock() failing.
>
> So, as thought, this patch doesn't seem to have any negative effect on
> shrink_active_list().

Cool, thanks! It seems to meet expectations, given that a folio is
a very small granularity. I also raised another discussion [1],
which, if it works out, should provide one more reason why we
need your patches.


[1] https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/

Thanks
Barry

