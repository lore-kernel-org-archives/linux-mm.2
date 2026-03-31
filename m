Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A68F10F92FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDA06B0092; Tue, 31 Mar 2026 15:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E976B0095; Tue, 31 Mar 2026 15:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF756B0096; Tue, 31 Mar 2026 15:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAD296B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:58:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89BFEC42C3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:58:28 +0000 (UTC)
X-FDA: 84607420296.18.51C7345
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 55FC940003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:58:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bIQz+TGG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvbjGMrw6sSXQtTsWR0wzJ0JMKxByG9x973fvHacnEc=;
	b=VG7Q53C18ht/w5u6RH7Mu/MT/4ppS3BoiAoOE4YpK6uJB7H2s4Pajxg/DdYkUwvYlniEu8
	cmIH/qO0ooaUJbNc5EvXj5Vj7HYKFy5ZAtHULsfG8xpRZ0m+jHObKHHC3gyZtEO2bsGfx5
	AzT7UTe1Ri1IjsBktBO57OC+yCUBHpo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774987106; a=rsa-sha256;
	cv=pass;
	b=2fEiqvKbhhx7ePbQ2xSQS+cj5pLn1gIyE1p1Ly8fxmKUPLH8T2FRoaFWnrARr1AKlMH5Jk
	fT9Zb3hT7PHb/kLQ8XM3xChpSd4KFWzJMaV3vfGvfK1ZlLLpCb3mPDtKSdEzuPPCt40II+
	tT/rfsMbzeGSOB/Yz4ndKEu/BvgnXRE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bIQz+TGG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6618bc129acso9015058a12.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:58:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774987105; cv=none;
        d=google.com; s=arc-20240605;
        b=OSKfzv52nkbE+XpfSyTljZY3TQiJ9k0V+sEu5bEOz+lGmxFTX9wZeeeXdEtwpP2PVT
         4uBbGXNrwBki9svwQaT7y8cHes/+OzdFBSsQAqywEqpd3070Wo6MvyzJvTc6tLK3PBAY
         KI6B4JXNgrNP8WTUx0akE7b2RoS2zrOHGljInQBof/Qkqpx7skR5gK0NoGwEZC5rvn4p
         HaQJs6b7uUnwBP/V4zygbUMVeOogohNuB/gvpx83E2qiahO4s+Ojh+5l1MknwpwjfzCa
         eY7V1ftIShBLXGl/k4gZxq4QN/EkehmghVZVnaCCRWmjhL/+r6ZtO/KNHjo2ZnqLaUHt
         FsKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CvbjGMrw6sSXQtTsWR0wzJ0JMKxByG9x973fvHacnEc=;
        fh=nDHRTS/65cnstJtTRdQvbHXH87jhBL4zsV+dIAwp0I4=;
        b=dj8CPNPilb8HutbSNjZj0K0yxPdB5oCvhzJh6w94HAW+vaEejkjJ0WHp0oOQkj5ZSG
         UP4+zq2e0ymI1pBDw/DInN+DHHck3Xbjh2uPxpQXe2PnGhnqHejNFaPTmK9Da3tstBAP
         oqaplEeUclEihatpespa/Cv4SAagNScwh2dSMYOZRgrFVqteKptDRY1eJYHAWGmHzPWX
         ijMytNIIr5FPgbl6+rAktw3DlJKv+6rOODxT78OYtQxUGPD8peD/uG/Z/yLi3Swh9eLE
         1fQ5U7NfBTshSboqdd3sDkRDeeOcq1XERgxVBoaxyF2kQ6ECuobnlxc2mAn/dSIK1W2s
         8ArA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774987105; x=1775591905; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvbjGMrw6sSXQtTsWR0wzJ0JMKxByG9x973fvHacnEc=;
        b=bIQz+TGGeOoMLHxrmK4m4urJNdoTarGHcJrsKfFIc8hm4bk10h34XDhjj1fL2KdOt8
         eQl83QktRGansBSoVMcH/fQlgXHHydtIGHGkZetnYRiZDO3sIHagVekSPYZKfZG/MJ7L
         KMvW4La+UqiYhYsisee0yUQFEvQHbuHOOo9PVdwhHbVVhQ6c69pUZ0OD3bfv7CKN34bt
         okH/A2T2PhY4HBN9YQZmfk+wcCrQnACAQWr+zR3RXTMyJk+iMKLX24CItvI90iWvBfde
         UOYy7fCaDyMi2UDpRJll6pNTbWyBT5Unh+hK00i5PHtcYmp/DCsMYu7WmnzGFTYJBU7u
         /cnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774987105; x=1775591905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CvbjGMrw6sSXQtTsWR0wzJ0JMKxByG9x973fvHacnEc=;
        b=W3pVwqgDuLrk5qfjtUrlGS/yFJUuQRGzE6sspDvj3Ri+XY5z5DRglF35EUHqa+0gOU
         hHFnGvUExTJQd4B9az/yHS7LmMIgCiEsMVDVgvDTofLhZyEVKbh+3mLkEhRTeiVdv4WL
         f3tKRmOJOKBBHa8F1RLhFu5i2or0SyHE4JCyMTnLvpa133/8bWhxH9zczwS8S6l2uWW9
         +WikJqVcDgRFwcOVv1okPx3uHXPwF/O2yvMZZoGzprsz3T6pZOFZcQbbSQhPNq2Uqwj5
         lQ/rVykmFutpXqSHB8IXU3DphmP3MxLbB3Zx9jZtf0QjPMFc8R0HjLRkzeMrPZnvQA1t
         W8kw==
X-Forwarded-Encrypted: i=1; AJvYcCUqzXm9VeYphQqNIZ0AOFIVL/gacinv5WptGipRHt5WMoDjs2d3UL221AJtbnSrFZckCVzJ0PfLgA==@kvack.org
X-Gm-Message-State: AOJu0YyGQtTELnYuZHW5QfOUL/J7L26aO5mhjfkRTFDf1TxBNmcV/ZoG
	d+obsYqJqBxfse6JFOfLW59erZW8lRj9qS0G1V6719F1cgm0Q21A1SuHPx9tQUiEnYUQxMhRe+/
	TsqTp76USXlWCe5XDQhpqE116jpezIXt/xbsh/UjanQ==
X-Gm-Gg: ATEYQzwVZMYetr2l+mE6c59dy+SyWYNrKI9qRnOvb2qjqa/czwzaNJHTNqalSMFzztn
	bsGbGc2ZWJs2+kgtcAmPEKhTydYM+uaUlwnrzvGWCFTnnmWji/883Zt3fYF/lxDwVybze+oB4Cn
	EpKl58YXA+cO7ezsGBhx2OUp3vlQ2Fh+IVGTiIz9+FLwLbjqokPpL+QFKlUSYwEaLNvW2lshYeq
	+3T77Egdc5/yYLAmql1Yqy4kebCs0Xn5vy3DbcjIp9Th6MYJWaXARCQ/lMElqnbWLuPKaCHYpyA
	ughm+Z0HlCjyDWEKlFPirItkYagx01eRxU5L8g==
X-Received: by 2002:a05:6402:1286:b0:66d:d07c:a8ea with SMTP id
 4fb4d7f45d1cf-66dd07caa9amr52754a12.7.1774987104740; Tue, 31 Mar 2026
 12:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175456.4065874-1-luca.boccassi@gmail.com>
 <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com>
 <CAMw=ZnQZm_k_mMQPmKwuBtkFyXXgAn9MK1NzmVbZst4nGu6xhw@mail.gmail.com>
 <CA+CK2bDL9=uNmy9hq=3D-w=MHYsY82FNCkqvNeNpnTnX6meYRA@mail.gmail.com> <CAMw=ZnRKEaWC0GiXWHpbiAchpZeBawOCoDgtq18B1UJsZpNN-w@mail.gmail.com>
In-Reply-To: <CAMw=ZnRKEaWC0GiXWHpbiAchpZeBawOCoDgtq18B1UJsZpNN-w@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 15:57:47 -0400
X-Gm-Features: AQROBzD0oAOC_h1ZImCURxvI7CwZiGV3FDojPlJTfAKD12_kRIP0nvfRHxNVwpY
Message-ID: <CA+CK2bDSfOE2VardTc=QY2RyY0uv6yQu7ucn=5sWg17t78oMjw@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: truncate getfile name to NAME_MAX
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: dy1jaknpbg6xrio5mwkreo5k586w7qps
X-Rspamd-Queue-Id: 55FC940003
X-Rspam-User: 
X-HE-Tag: 1774987106-636711
X-HE-Meta: U2FsdGVkX1/IdrdvNPpblaKOICcNQGu13PNjpNi0uEzLmXQifUv3tRGJ4RKI2hZzvsVwOYRmMcnHoFNhlnEN4M/bfBfBb/G5J539u4wPPnluGW+aHgSgGZMQUzUImwSTAo0+jXUmIof4VxdaGjmgYPkVEKmOd5UwkzUI/SBC3N7blYW+iirYK0Lg552YwtWMJp8NvCSWwKrJYmtiB2t0IiFG7p3l6pbbbRx3Xt1wS57iGQPVfzApZKOcbRRkHwmxrc6rGtgz4kIc6JfKRCgyl7bnqJRX0W58dWVigeitgpwyHPBzaBJhxM69gj+bStFVL1tP6J5Sa8IwkzdO4c72NDD+Uu7s1RjWSAmhWCu6CJqpaTCUhVRsfSPUDR6jZX1PSYs+znToFKqukSODqfTEwl2POLBycpwxOW67GdI8cIDIc60KRCbzu3HFAj2Ta/eYowbom+lz86RLZUMNZBUXgtDln3x7HRrWuxiWN3T190PnNsb4gTNCYsw1qHM+xfQPxeEry3NoavjQv6R+5Ya1QC47DSADpuUurebIi8SWSjtHGtzI0iJ9BSUDltWTFWSidK7/DG6bqjfziC1rGD9UHOqZxmtQYcm6/d7Ec5b5nu8vQ/q/NtvFd0lQvUU/aA2LwqZI17s7JJaciUdRJCMJhbNjB3DGzV2MKN4GIGUn0mXIzkbVsmgGRbL/4id8A6TeqAbczV/HNEHBySjVqYVcI4EzVxZNbeXGH8F9Pu2SSqgNjDU65jbBC5Eqkx6I5CV4crEoxL+mjdEmj2vgp+88RsYH4oD7gNqrAo/iXhtnf6pb5gKJXg0JILU63lzdszlZodsDPPn8jFPgNs6z4LT2m4OZmxuRnIL/O/HMWVYte52N0YVV5qcAuCbi3qtAiWNDY35LBqsLexxq52U18S+8WEgxH7yeWeUgOpPGIiWK/k4ZAbgJsk/L973kThAuqFYOJ/W53kktEzf+i8XgmOP
 WakK6N/a
 jrbvJwup8EEiLijadIsWPbo1lyu1qwEknhZALf7yClWERb7RrtGVA9wNSgAY8HZyo/514H9ObO9fB6RoHaSYghTHXAysBWViIhEl2rA81VvJRTUwXD4lB7zpgCW2PARb3QoyVy65Zu80ozeJT8XjFA3/WP2UZmQthFFp2tanyB8k9rbpSPqtka95FjJSX+/sF+cUAMJ8OFxAbvUR3j0kPimynJeKyAyBEN0LMlt3QVq4G1FM8/V4NQguP3HVhuHPk7f3G+6fpwxk5zV/7uUMcW5FJixyEYgq2BLHBdnb2SkwJRmWyBDH5T/ZGxVYSHIZEMJZI+xudw9Tl4+VV/wzZAAI+iFzgCTmK/Sz2/OptkeaQDFFOqE771S3yp+VFPWTZNKS8EXcm4gscl58DprDQ4Amb7yXEDDLPTjt4w8cAGfPGCyRCii57sWdrHPLTd0a5b/7dph6eTh4j3RtRG9Nuy3FAmdd+/4NLA2dZCFBAPXrZvrvVzR3GfiLifSgrVFZEYUXwx8ZGWNVGJA1CYkxY6M697LxdCvDlYU/UkCeDqC++cV2P+Pm2FKsRcyDlE1JznKt204+9lG2p6L2brblpVRSyf8goXI5PhWGXzN5m47VDfnYLqUL3ITZAYO330U6GQce0MSvg/nka/INtJhNcrk2WVfSB7O0BHRZIdDKH++oxWPo4BFnh0U/Ep3cO3nFcKI0NT1cCDjpcYjWtbwYMF5M4jbzvy62l4BShS4TwjaMMHBMpkEVki7JIxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:40=E2=80=AFPM Luca Boccassi <luca.boccassi@gmail.=
com> wrote:
>
> On Tue, 31 Mar 2026 at 20:14, Pasha Tatashin <pasha.tatashin@soleen.com> =
wrote:
> >
> > On Tue, Mar 31, 2026 at 2:30=E2=80=AFPM Luca Boccassi <luca.boccassi@gm=
ail.com> wrote:
> > >
> > > On Tue, 31 Mar 2026, 19:21 Pasha Tatashin, <pasha.tatashin@soleen.com=
> wrote:
> > >>
> > >> On Tue, Mar 31, 2026 at 1:55=E2=80=AFPM <luca.boccassi@gmail.com> wr=
ote:
> > >> >
> > >> > From: Luca Boccassi <luca.boccassi@gmail.com>
> > >> >
> > >> > dynamic_dname() harcodes its limit to NAME_MAX bytes, which includ=
es a
> > >> > NUL terminator and a 'anon_inode:' prefix. If the name passed on g=
oes
> > >> > above the limit it results in userspace getting a ENAMETOOLONG err=
or.
> > >> >
> > >> > Truncate the name to NAME_MAX - 12 - 1 characters to ensure this n=
ever
> > >> > fails (accounting for prefix and NUL).
> > >> >
> > >> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions suppor=
t")
> >
> > Let's remove this, this patch is not fixing an existing issue, but a
> > preparation for future uapi changes?
>
> The linked patch that increases the buffer to 255 is tagged with
> 'fixes' so I don't mind, as that's enough to fix the -ENAMETOOLONG
> error in currently released kernels. The original version of this set
> the truncation to the current max buffer size, hence why I had the
> fixes line.
>
> > >> >
> > >> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > >> > ---
> > >> > Builds on top of this just sent by Aleksa:
> > >> >
> > >> > https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-name_=
max-v1-1-8ca20ab2642e@amutable.com/
> > >> >
> > >> >  kernel/liveupdate/luo_session.c | 7 +++++--
> > >> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >> >
> > >> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/l=
uo_session.c
> > >> > index 7836772956406..4a40c7fdfb44f 100644
> > >> > --- a/kernel/liveupdate/luo_session.c
> > >> > +++ b/kernel/liveupdate/luo_session.c
> > >> > @@ -366,11 +366,14 @@ static const struct file_operations luo_sess=
ion_fops =3D {
> > >> >  /* Create a "struct file" for session */
> > >> >  static int luo_session_getfile(struct luo_session *session, struc=
t file **filep)
> > >> >  {
> > >> > -       char name_buf[128];
> > >> > +       char name_buf[NAME_MAX];
> > >> >         struct file *file;
> > >> >
> > >> >         lockdep_assert_held(&session->mutex);
> > >> > -       snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", s=
ession->name);
> > >> > +       /* dynamic_dname() rejects names above NAME_MAX bytes, inc=
luding NUL terminator
> > >> > +        * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12 -=
 1 to avoid
> > >> > +        * ENAMETOOLONG. */
> > >> > +       snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s", =
session->name);
> > >>
> > >> I am confused by this change, the maximum session name length is: 64=
,
> > >> as defined in:
> > >> include/uapi/linux/liveupdate.h
> > >> /* The maximum length of session name including null termination */
> > >> #define LIVEUPDATE_SESSION_NAME_LENGTH 64
> > >>
> > >> So, 128 should be enough to include:
> > >> "[luo_session] %s", session->name
> > >>
> > >> Or am I missing something?
> > >>
> > >> Pasha
> > >
> > >
> > > Yeah we need to to bump that size, it's too small - see the shared do=
c. This is anyway needed for safety, as the user space call falls apart com=
pletely if it goes over the hard coded limit,
> >
> > If there is a safety issue, it should be fixed (even without a limit
> > bump), could you please explain it.
>
> Nothing specific, more from the abstract point of view - given that
> this will fail with a hard error if it goes above the hardcoded limit,
> it seems better to me to check it, rather than assuming it's going to
> match, as that's error prone.
>
> > I looked at the shared doc [https://tinyurl.com/luoddesign under limits=
 tab]:
> >
> > I see:
> > TODO: this needs to be bumped, as for the varlink API we will impose a
> > cgroup path prefix, which means PATH_MAX + "/" + client-supplied
> > string.
> >
> > Why would we do that? Why can't we use a 63-byte unique identifier for
> > sessions and an in-memory database that maps the cgroup path prefix to
> > session_ids, where the database also gets passed from one kernel to
> > the other?
>
> Because that requires tracking state across all runtime, and that's a
> no-go. The session itself needs to be identifiable by cgroup, so that
> its owner is uniquely identified in all cases, in all situations,
> regardless of any state or lack thereof.
> The structs have a size as input, so it should be doable to follow the
> usual process and keep it backward compatible.

Overall, I am super happy to see LUO integrated as a first-class
citizen with systemd, and I fully support this effort. My suggestion
is that we step back and prepare a single patch series that performs
all the necessary changes together, instead of sending a few random
patches that do not make sense by themselves.

As far as I can see, we should:
1. Increase the session name limit to include the data necessary for
systemd fd store restore capabilities.
2. Make the number of stored sessions dynamic rather than having a
hardcoded limit (I have a patch for this, which we can include in the
series).
3. Add the necessary API to query back the incoming and outgoing session na=
mes.

Is there anything else that you are aware that we would need to add?

Thank you,
Pasha

