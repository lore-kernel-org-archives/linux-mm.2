Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E3FE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 11:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969E86B00CC; Sun, 21 Dec 2025 06:56:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9180D6B00CD; Sun, 21 Dec 2025 06:56:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824566B00CE; Sun, 21 Dec 2025 06:56:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 723D26B00CC
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 06:56:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D290B1A0854
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:56:20 +0000 (UTC)
X-FDA: 84243325320.01.371EBCB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 634621C0002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:56:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlIr0vWT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766318178; a=rsa-sha256;
	cv=none;
	b=rkQRnaU3Eh9Etf1/i6jeJ1NvvEdEB2MSMY8of7cLfWeSdpdk1ykP2EeuaKi2V0emfGlzlz
	P4COP9C3ZjVru69mxJtj3uKuJodAmSfOabXjMparxZVpFxyxH2GKSL4xM4iikl78hzjsJK
	5Aeq4FYTt5pLCSTLtgudV5JFL7O54W8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlIr0vWT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766318178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCjjNpAq7py4ZgzH4dDChl16tZ45LVwU5qE17zmzSxA=;
	b=5rGoiKeElrn+R5skZ5ec7fuh/kBncdzLo1BcH3fmRsyQWQrFFJc6fsHu0mKm+mGYxuBgrf
	HakQAIgegHgyoIv4ThCnIIUKTuWZ7dTcZVLvBJ8G33QADJGnT2FxbmcAAmKLNqLkqnbNBI
	gDzJwjjJkStb23EFfcwVfjtQXCBRpNs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766318177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LCjjNpAq7py4ZgzH4dDChl16tZ45LVwU5qE17zmzSxA=;
	b=YlIr0vWTCV6BzDUsLFvSV7Q5E9Sk0lOGMokIMg8MngZaz2MeMaR16xIMktOnFJfzO9rSBy
	FEvTPPoVLaoMQB+qrBWWpsrcbSEOjPvUT/s/ZJAckff+3PTtFDq5xKo7n3edXKsRvM20Gj
	0+Wa65romeuqFCV16Zz+fXVGX7r6S4U=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-xePS8k_KNUyx4x9ZYPo2GA-1; Sun, 21 Dec 2025 06:56:16 -0500
X-MC-Unique: xePS8k_KNUyx4x9ZYPo2GA-1
X-Mimecast-MFC-AGG-ID: xePS8k_KNUyx4x9ZYPo2GA_1766318175
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2ac34c4b41fso3869919eec.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766318175; x=1766922975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LCjjNpAq7py4ZgzH4dDChl16tZ45LVwU5qE17zmzSxA=;
        b=XAyRo6vSN98WyIjtNtq32VJf7ClMJktpRkhl1ZcPz7nYV9UUvyzVeKHA9WTBrC4pSu
         yNMpWKZ6CYYv0W42/WNMPXR9noIQgBmqcTY/cvMMi6n17f5jQ8CgMYonuL+uW2oHFiR5
         86jLuSVxHRICTNtT49vwBV/8WKG/ftW43xiBWREZ1J8mm5nuXbq6vO+S+gfe0afwdjwS
         nIHhvu5ueRI2kUOrUwUjxT+yD0LZw/1lu9FoSwI1F2+1Rd0DOriyZsCN4tXhCGMv1Ros
         4RyHImtQmD1hcOktto4dwhWNHpKBDWbzfyB7v/AedLBmo6bbXAGkMz77gOmCgNA8iQsz
         tKLg==
X-Forwarded-Encrypted: i=1; AJvYcCXprVRKKGYrNn409BvCWxQ/RO7ixD/ivHrQRXgc9oSwlIx49WNd8JsibqZaQ8Fk383qp7DTIeEFwQ==@kvack.org
X-Gm-Message-State: AOJu0YwkdO5VqTihelrItUkP/4HkQ5h9At0fOoSPV/0WBs+S/Lw9P/R9
	dmiEshPsECLUzNAfhnlNJthY+K/DLVWPHOWa+BGqE4Xo4RaZPgEDETZBCtTbJnO00KTWz9BvPeR
	DAqMi2yCirRMDWbtHE1EfafYE3FcKLW/UjD3WgZfbqPS5uRhZp2T8cXyPXIypzYoEaJjLsv4PiH
	RNafIb3SOT8MHQDIthXEeOhBE7WOo=
X-Gm-Gg: AY/fxX5v24NreRpa9/rb6ZAMLwEX8zbXa+iB2cstBTgbR9ptTtfKmWPlSLWmAdextGE
	mhsyjQ9m7cvPwm5U7Du54wniglsg8lKxw6Fbu1UG+6wmtvs20Il0s5LRNJN2fe98+Sb6/llQIKa
	HEkuBAP8f4//MnCpFEIQgkTCFSm/KvZaoW9+Dx+yVaZJE4+NsE7C8yXTFCiMeCdSkl8Xg=
X-Received: by 2002:a05:7300:e2c4:b0:2a9:9125:ac0c with SMTP id 5a478bee46e88-2b04cb3be5emr12990278eec.9.1766318174816;
        Sun, 21 Dec 2025 03:56:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbDZTnEf44rDqj8hHqQAxV1KoSZTcLVemuS1ecVvfAr45R0qzwVV95SbMyrWAN6bz/OZrSlNFuL2khBXpkMVE=
X-Received: by 2002:a05:7300:e2c4:b0:2a9:9125:ac0c with SMTP id
 5a478bee46e88-2b04cb3be5emr12990257eec.9.1766318174398; Sun, 21 Dec 2025
 03:56:14 -0800 (PST)
MIME-Version: 1.0
References: <20251221085810.3163919-1-liwang@redhat.com> <20251221085810.3163919-4-liwang@redhat.com>
 <970fa015-9ec8-4903-8e2f-f3e847d550d1@kernel.org> <CAEemH2f67p=wqGrwYnoVCP1fR82xxwJv1xfbMmFrvNaP7LZJog@mail.gmail.com>
 <30a75bb5-7edd-42b1-9a94-8ffe017bdb0b@kernel.org>
In-Reply-To: <30a75bb5-7edd-42b1-9a94-8ffe017bdb0b@kernel.org>
From: Li Wang <liwang@redhat.com>
Date: Sun, 21 Dec 2025 19:56:01 +0800
X-Gm-Features: AQt7F2rnI-Hbfbtj1tUEzQSNIk4NyI7PS4n0WTNPViVW7sxU6wgWxbTOvJmvIYY
Message-ID: <CAEemH2cqZycJ2m1s=UDaCG0XfkaHc57632pbhNaDkV9py+U77g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] selftests/mm/charge_reserved_hugetlb: fix
 hugetlbfs mount size for large hugepages
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CqMI18AP7f1DV9PgBdiBFlOadS6wM80Ghb7ITh48HeM_1766318175
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 634621C0002
X-Rspamd-Server: rspam10
X-Stat-Signature: 61qug8hkx8m69knsdrmbbnnwxkpw4e1q
X-HE-Tag: 1766318178-421214
X-HE-Meta: U2FsdGVkX1+H0hWuBA+vX7mxJm20xrvjWkL/pgFTA6MSg+34O/7N8Q+gTjorvbMgQAmcxC1UDK8pN3MoFLmrk/+8dt9mzDvKf7cnQhGvKaWkmz/0SKgdZyhroKB1cFUeT320etukeego5ZUMNOEgVWMh768rmBYhpnteRANU9eieX5tGRF+rqeHN9dgl4K1qFfRmVLIFmRf8R7tzQi62dP7YTF726nKkURPaxnZ16xK4K1w0QDv9TD6XC1k4FccyHir1lWUasc1/WiRvN6jsMRJJICMwHvnjpDfn/LFqmMt3dN7Hz1eTJvhA7Kz1xEn6s8u43XG9ibv1xo4h9ntbCYIO8VXEGDxBZ3AMrL31iVdAHqV1nIgyYJ8nXmqUNx9aL0ChDuMoaV3axlvAw+QfBhkMu1x9hC6Y+Mf74QyG6bxnork9QJS181GGx+THHXJXlZ8miS3Brvu/uUNntJqI9qLyT2cXHzYrLF+PGD1jeXl8huD2la/kKOoGukIRSQ7sEDAzhXgTJ4WC/lCedWVAUIQABEbG+JtpLBwxKd4q+UtDyj/GmOys1KwFsR/MtETAEL+xVjzdMgkBnIZvjYmWq1pbd2arUyVzNelAVol0UJeP3QHCEE23vrE5KkHLPV9wIR9Hq54UMz9uMrB1rkaOzGiD76RRwOSZ8gyHY1nlGWMYC/xbP0pju43Nch0AUrTQuAZ/smjc1RFZQGzledU8uyWONZhx2K1rrvL1hRtUy8yt+O5r1BSRqIQ1la3V0rWtXgc2gouZx6fU0/8lAvjohKglN9uwjoUkL25ID3OAh2spwZlfi8CZmpZYCmxn+410L02RJrNH6eL8LjLwYyt8vAwsuM4m2rgCMC02wd2jUKhKFNE3YgmTWeI4dTwToxWcmhbD9j7P7V0he1MrUYPbv652twLLDssdovaWw3QsaVW9NqnhcoYSperLbifotocjF9xJ/CD4/C4KoDpPur1
 eyFyUTfc
 8pmG0iL2qmaFYBAw3+qxvqoz5PMZo6U4j3Drpot88dJyUrEknq+x1DUo859JrG5cGGRx92sSl7GqJbx0lkyPprL2BsdZQ1ldSS8+jRbOClSYAU28wE2XCHWzmCh7BqRNbPFoAy8YP9LiS18TNDc2iMRW6UgKn8YMBdzrpP6TpsUtrEPy9q6AYjbbCWiTFniVEhUnqkfpcj1Inx/i4B+70NBXuyR3gaCVpf4QvlnqugA2z/gMz/0uP8myj7VnotrHgzMxmuiYlbMZx9g9lcgfztU7nc9bKBaHn99XwmKEy6bXqInMjziXTT+dDDknO9K7cn8K+zxXm0DgDDGtG0PHtwlFA9XKWYOYAtT6GUg+LfXViasJBFn+DUUekN0dB1Vj1IlUxpc2Ym3+1kNVm8NgFK3L8/DdjCqbW0IHuDa0Se9pCYAukoUV93kRj+Graz6nw5EDOmweQA6FVYDdIJP0VfIYHAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 5:49=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 12/21/25 10:44, Li Wang wrote:
> > David Hildenbrand (Red Hat) <david@kernel.org> wrote:
> >> On 12/21/25 09:58, Li Wang wrote:
> >>> charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge w=
ith
> >>> a fixed size of 256M. On systems with large base hugepages (e.g. 512M=
B),
> >>> this is smaller than a single hugepage, so the hugetlbfs mount ends u=
p
> >>> with effectively zero capacity (often visible as size=3D0 in mount ou=
tput).
> >>>
> >>> As a result, write_to_hugetlbfs fails with ENOMEM and the test can ha=
ng
> >>> waiting for progress.
> >>
> >> I'm curious, what's the history of using "256MB" in the first place (o=
r
> >> specifying any size?).
> >
> > Seems the script initializes it with "256MB" from:
> >
> > commit 29750f71a9b4cfae57cdddfbd8ca287eddca5503
> > Author: Mina Almasry <almasrymina@google.com>
> > Date:   Wed Apr 1 21:11:38 2020 -0700
> >
> >      hugetlb_cgroup: add hugetlb_cgroup reservation tests
>
> What would happen if we don't specify a size at all?

It still works well, I have gone through the whole file and
there is no subtest that relies on the 256M capability.

So we could just:

    mount -t hugetlbfs -o pagesize=3D${MB}M none /mnt/huge

--=20
Regards,
Li Wang


