Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4084AD1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1266B0092; Wed,  3 Dec 2025 04:28:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8C66B0093; Wed,  3 Dec 2025 04:28:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A73A6B0095; Wed,  3 Dec 2025 04:28:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71EEC6B0092
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:28:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F221518F8
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:28:16 +0000 (UTC)
X-FDA: 84177633792.17.220F3AF
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 103EB10000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:28:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=rMc0xjqB;
	spf=pass (imf14.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.181 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ns2TzdrZVTfQ2mVS+gF3kQw0VyYvREhCt2c0Yr6Y9zg=;
	b=3586SwY49H5xiqwgjTdy86fUoDCQb0s5BfC9dhs8A/Q3ZpVZ8/jDq1pOx9bBTguql2hW6j
	9DfU/8YjZNaD0e7/QsEOsWzkSnHs5ZxBrtcJFT9UEF37YdeV1HZcb7GmS+vXXtslk4end/
	ucUQQUWGe+uR53TydIzMma1CKim8Ves=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764754094; a=rsa-sha256;
	cv=none;
	b=zdl2CqX60JqjFXyYRepRIq+Z8vqJPvETS/C/qIqPI+SCDFFN7DklGK5DhhiVJU8PpcQ+FR
	vIYuMB2KEmiXRoWWmrjfOYOhguKqqdR2inVYZ7c+wHom4ZL6szlj18m1iaoJPQiiQv+Jq0
	39R+H/ZdwLQ0E3OueGNWZUIHcO0tj9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=rMc0xjqB;
	spf=pass (imf14.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.181 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edaf8773c4so73522801cf.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1764754093; x=1765358893; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ns2TzdrZVTfQ2mVS+gF3kQw0VyYvREhCt2c0Yr6Y9zg=;
        b=rMc0xjqBfMZkJ/4CLAqyzM+2khh5ubBqpfzhLeYbD6uCp+dGakV+t4AFLaT87ExN4X
         qjFtGpoRv3gcos0yzQTCLvc6Gj5Ddm70kZ9KdM0ll4eYGROi52nv78o7K9g+lJzAihdR
         R4dLmdkJVEGa5p4mvGZKSPVXzFsQklvIoc/Xs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754093; x=1765358893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ns2TzdrZVTfQ2mVS+gF3kQw0VyYvREhCt2c0Yr6Y9zg=;
        b=rCidkI1L5seCc7uvQ0viEyIHh6x0g5ZvoOxLLfSUUxbmP4Cp+Mn/SCaZRhmh8psIiw
         HOKLIv78SbyjCPsr4TpgVXb53mPbOmSDtX985imU++3v79XqzwrrBnSfG3iiGXMDe7AL
         wyz0aj9rTk3cHn2uwj+kQyva8mQZcLpOPHELGAJyHMDzdOS4zyq/K6NNWRGAoGU/LXva
         ZPC9SNe++rS9w/BP9DOUZtEGJraU//YRdKRVPdBJHKeYpVxlAsD+eYtjfhcNhhzCC6go
         MLjAyV7pDdBdXiSpRln1wffIzyAwT7I1LSoA/TwR7QnVk1X08jp+QgO8CO9vQ/u9WFCX
         QObg==
X-Forwarded-Encrypted: i=1; AJvYcCUXlPJrvmdpVr7Rw+aq9AJGZTezo3LiBIsE1jCI5vj/WYfr2jfN+OCJYpvp8JXkNUPe13rPpgy+ZA==@kvack.org
X-Gm-Message-State: AOJu0YzgHN0LoDqs1cd/SjSqwzE8UcUEYB41lhvQCL5r4ZOhHLEIJDT/
	xT3XKQ5GuQn2Z/YeKa2nRq6YTf+5BZZO0aYa4+0gGNCumfS6yaJHUK0hSmsW1wf5tLP6YNjgIo6
	WkvrImiKMb8L7l+bfKi0YIHYpbFJHDe36kHMo4WHZEg==
X-Gm-Gg: ASbGncsqgUVLYvHFwNSgKJHPXHFwm2vOXy/kNz2M1+g4PdvkqsqD3gzlb4t6+KOy7of
	ndZt2i0y9EEJ8+o+Yci59onpPoM3C9tpv/u0e8LxOTfiCVSrGnraTuaNSEk6LjUi+FMjcUmzvbW
	XzI+/fU3z9HV4kzD8MFhh1YaBqY2V9nzMRqjuxOEcMcxvQQafyApD+0FxKk5mBcfqHITgYcmVlu
	3WqN/+2f30czumzB+4blkUHt7efj6tLktNDUQkyF8t5SZkIOYK8f2C6a7kWW3yHxk6vOhQ=
X-Google-Smtp-Source: AGHT+IGH4y6G7l0uWAM7MVs0ZUDjiX64KDLpg17aJDNSM/roeQAWJbNS+KY5jVjRbd5lpner64LysoyLNATeT3izA2o=
X-Received: by 2002:ac8:7e86:0:b0:4ee:1dd0:5a4f with SMTP id
 d75a77b69052e-4f0176da1c4mr19930841cf.61.1764754092958; Wed, 03 Dec 2025
 01:28:12 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com> <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
 <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org> <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
 <504d100d-b8f3-475b-b575-3adfd17627b5@kernel.org> <CAJnrk1a1XsA9u1W-b4GLcyFXvZP41z7kWbJsdnEh7khcoco==A@mail.gmail.com>
In-Reply-To: <CAJnrk1a1XsA9u1W-b4GLcyFXvZP41z7kWbJsdnEh7khcoco==A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 3 Dec 2025 10:28:01 +0100
X-Gm-Features: AWmQ_blcA_e4kaMi5shA7dS-lb9KIG0yD8t2lL60ZmfQjrXgcrRpZu3lHj-XY4c
Message-ID: <CAJfpegv7_UyTht-W9pimE-G6tZQ0nKU6fYo1K2hcoNSHYC3tpw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	shakeel.butt@linux.dev, athul.krishna.kr@protonmail.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 103EB10000A
X-Stat-Signature: mjadfhu71467j8x3hk89n5sayngd3o43
X-Rspam-User: 
X-HE-Tag: 1764754093-94980
X-HE-Meta: U2FsdGVkX1+PiJ9zps8SmprfOycfNBsGOpsXoA0McHSCnA6YCksXS+rUbp15b0OkNL4UkAME349tTUMAp6PZeZuCJ3+gXUVUXHtC1yh6knyhjHMjil2CyjCntYHPYiVNzd5p+Hr+cV9ca0PYf7dX1ABYqBKAyxSnRYqiyLYM1/Rh+oB6Tk6US6nQ2EGOG9+/oD4JlQp6b+0312TBFDaxFqT/QAM1Qg8LpDI/qMF+GBK23GNEz2NTk7dfVtB+Z5SwXIcIK01fmDFw/nNUMQ6rx4pAZQZvDGc5hAu4/TCNmg6tpLHtfPBcujEDt0g61ZdlzJJspRPxmLX73+KnXN/0ElKIpjSdY4T9vX9twAOZZfx2jDuY41JcCdGFuT703PHoygjSMP5JYZlqYNVAdPFwT2KGoFS0RwLF9Wv/M2fxaa8cmrOEwpDchiK3fg5m7Az9ITjEAtHIJJwNpLfxtbg8oDOMTbjP7/cJVnQzuHCqOcONhprj7t1tpoNfiXdOJAWh0JPRgR4Fl1bPR+E8bQpo5UC6b3M+egSIILkYAoxa7X9Hkfd+hdgIh+jEkQw0zI4D5AmgnleLawP1MhXbfnI4yWY4sR1NbzQR6xkkr7mDwLkhLyI8Zy+XNHvaKU8klH9MhwFzBMmItwjolsucUuGbpw3KSg4QlJAwTbVjw7ZtUgYsLA5ZN3ZfIMluFnu/4mHFSBBPsM4Iyksc8fYfg4dzN0KcsJKFSf/JxsGSSZ+3K3dojnRLl8Yny+0y6PwZgvnktsKS4w7CLo2N16HMZG0ktwBHGsmtEg4iCsnmsuized4sm5jhlw/syGeAFsJshWRbwSdmZeIUds+DVTSSL4sxlmKs4GLZzisZuObcdeTl8pd3R81eo4u54e/CCIOC37jXTxyVYYQIdlpdUwRVUJxTdmL4ehzXQOqssOvvXrdC+cb1tpO+zZVVy8htKYUvXIfg2FGBZJEgLh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Nov 2025 at 18:58, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Wed, Nov 26, 2025 at 2:55=E2=80=AFAM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
> > >
> > >> having a flag that states something like that that
> > >> "AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC" would probable be what we would =
want
> > >> to add to avoid waiting for writeback with clear semantics why it is=
 ok
> > >> in that specific scenario.
> > >
> > > Having a separate AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC mapping flag
> > > sounds reasonable to me and I agree is more clearer semantically.
> >
> > Good. Then it's clear that we are not waiting because writeback is
> > shaky, but because even if it would be working, because we don't have t=
o
> > because there are no such guarantees.
> >
> > Maybe
> >
> > AS_NO_DATA_INTEGRITY
> >
> > or similar would be cleaner, I'll have to leave that to you and Miklos
> > to decide what exactly the semantics are that fuse currently doesn't
> > provide.
>
> After reading Miklos's reply, I must have misunderstood this then - my
> understanding was that the reason we couldn't guarantee data integrity
> in fuse was because of the temp pages design where checking the
> writeback flag on the real folio doesn't reflect writeback state, but
> that removing the temp pages and using the real folio now does
> guarantee this. But it seems like it's not as simple as that and
> there's no data integrity guarantees for other reasons.
>
> Changing this to AS_NO_DATA_INTEGRITY sounds good to me, if that
> sounds good to Miklos as well. Or do you have another preference,
> Miklos?

Sure, sounds good.

(Sorry about the delay, missed this.)

Thanks,
Miklos

