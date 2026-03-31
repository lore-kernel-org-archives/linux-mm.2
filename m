Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E633C10F92FC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543806B0092; Tue, 31 Mar 2026 16:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F49E6B0095; Tue, 31 Mar 2026 16:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40ADD6B0096; Tue, 31 Mar 2026 16:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0156B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:09:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E28C1C41E5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:09:30 +0000 (UTC)
X-FDA: 84607448100.14.AC5F89D
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0D3E20008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:09:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fSltXYjB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/S10Yg5r6+ePkLPaA1Okih/qpU7AMuquFLu+r3+2gc=;
	b=ibjjrmC1KPolVDZeRWJOAYKAR1CYTzlzJ0waf1rSPSvL2/7FADeVKkwGVs9EfilIn52Lht
	NMc1+3Dyp0X1xTnjT/gBaCo8s9YU3QErdkNkHLG3GiCfjDMe0nCvHvmLDVImSWuUYidFEJ
	Za03qH4uXiSRs/GsAw7WUeb5H1omyZs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774987768; a=rsa-sha256;
	cv=pass;
	b=lm+YFUfmwNkjvFlv8oybObXpsB8xeKz2+sWyT/tDPL8sfYSkEPuZRq4dFEr/NYmWM/0G4F
	kVPC4+eQ7b+yL/PeYvIU+1lxq8K6JOI8J1Csxx6XDmaZT6T/yhhmjROegxWLjSiUeg31Sk
	a36ST2YLtidfnuwbfq17CybP8Aut0nA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fSltXYjB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6501d242e2fso4716437d50.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774987768; cv=none;
        d=google.com; s=arc-20240605;
        b=BNVQiAtFWpvEsDe4FFSJ3XxhUvZHD5kYNIf14O/jTIZKCYYVSGHhQPEsew+eqMU6XB
         KDkBGnTQUh6RoqU1++pQMK0V9RBaTc6lN+POD+baq2KM4mOGxCxXChKpyjkodDQNqkvV
         lWiS1Uc73fKiHT/vCg0Ex29n+7Y2DPY3xFAYhb6FvGM9rL0hGFqvLA4P8ebUmHEXfa+s
         w5ELLprY53Yak0/dSe3wafH8XZXi9F7hyHYWc9d8cjRSbgzWcvNc8L+a66AwlgcpQhlb
         TCSfT24Cn/pjcYfEIstYoGtHH0q+4f02e8QLQOXSozvgdDW6jMY9+FBdcKKVepa61bcq
         GJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y/S10Yg5r6+ePkLPaA1Okih/qpU7AMuquFLu+r3+2gc=;
        fh=CGTNTyBxHmfFtWX1QJEs4FsUQFUPZ6VA4BTxaSvWRbs=;
        b=FhmvbialbNEg/tEaHs/3tDY3nCWIWu+ayF8mUhCtcBIwYV+p85EwnUtdfwR7IIDt5B
         9K/fiuf+4nlTACgx8QO5RrFM8ZXi1QNWVttp/bdUNZEdfOG927CKV8tdN4dUpJQJY8BW
         kJnoF5rffRZkxYF+bZVosHXG4t8T5kPIQuoNudDCaxF1Nd3vdkIxkqQ2ba/bqSipE/Fo
         DBB4TOf4oSNZ3P/9zNm7Tkr3j2ywU8awE9YSyLw2Vc2heR2EanoCJCqkP1JRl2UXw/KG
         CMdNYF9E91pJqrKChBPMGkCVL6lmdC7OARJQHZn+533Mee1ZHjnpdEwN5jU0fxR7v/LA
         944Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774987768; x=1775592568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/S10Yg5r6+ePkLPaA1Okih/qpU7AMuquFLu+r3+2gc=;
        b=fSltXYjBSF2QLplZ0gSvWAAFPvGEDgL+406ZSnsmbyM80MOUGW2ti/sHfNN599GRAm
         HZ4gJl3kRIHyT//DCdeze9F/OEFr9uhRJKgTUVGr290TfDlCmPUX3YhESB/Oze9DQpKk
         W/shSGSXFbVl6lOcmmmt7ZJKtTQte5pXh6yaDdh9WFe1OEE+iVLk+WtFwP2Y2aAASQio
         2QbHcKeyc5fWCjoZXL3EHrXRKo+PPZQhIt9jvx5jm9MJors50ow6Ko9PTAvRLlC3/WXA
         rUzFQlYaiQsqpB/mJXSuCuQDx3q2z7HfWnHXUputbsRHAUMXXW1H1NzocNUdIBgEQaIP
         3K6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774987768; x=1775592568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y/S10Yg5r6+ePkLPaA1Okih/qpU7AMuquFLu+r3+2gc=;
        b=iN74xMg7DcKu9cnmV2uwGQ1AyqTBx9Pq9jLeXfkmWxlwmjT24VWxO+yuXODmnuJdmx
         vN59FjJoYlsXdWfi3HUR+631GPhuwJcC4fiMeQwbZUbWSVknQzO4u2cajSW9BDrYjFZR
         E7YmVFMePux1FHeXrjw/tHmpmPUTpOy6DyNLDzI0jT/ZIrLuuJRpxDJwnvADR289vGRA
         TUDIDLdNj/zL3eNez0pKB9lq4E0hChtunjE2IPVxlgCrc2SzwMgTtmEAY98ThYZT1W0a
         QlLnUHbacsj70aRoyBjW0uJRBrcs9ahaZVODAZ71it4awdpjhBXFpOra3c2DsNokYXBl
         cyBA==
X-Forwarded-Encrypted: i=1; AJvYcCXkXRxVTL4eCZ7fGvNjAb21r1Bn4tmxLSUn0UkLqsYDX3+W5gcHDa503qxHs5VPe42ZSI+1BnA1dA==@kvack.org
X-Gm-Message-State: AOJu0YxsU0xXV6wsWZAlrZlxu0WzwuamqAYBUh4xAiIanre7Z/7qJbNn
	gF4IhsYK8eytETRC4FHyC1/ha7VqP0rZ8qcWDLzb7Iy3H41o0IIYz5JNzA7Ox9EoJli+uDS4KK5
	2sixwMJEU/aA/qWXOYjG6vA8JpBQgIMo=
X-Gm-Gg: ATEYQzx77JECGXx1fRB98lPu56GsHio3BlvpsOjqsOMZCgRIpwHvXAmrbD6Nlnuope2
	8d4Dgcq/P+F+zxzNaUZRxGwqgf0lz473yRNNH+l1PUs/Jha5AVtjFQuwkwA33AeVfSWB6L+FSSF
	Dob1RUddCrF7c4N2CU1nUmjJ2EV+9eJshM1FPxw0g/2i32dFfMX6P5w945nM3V9L+xNciywHKOy
	B4AyMjiIit4qJSlVmFm4VfX0NLTMc1TOjTGc0SdI0HdCfIHpOLsraV9Ill0Vl+lzNl/EnL2ImbT
	sUTOEpjNDwMo64FcXbPEMCQnwVG8j7/NPn/oFh67eg==
X-Received: by 2002:a05:690e:1901:b0:650:2ff9:d660 with SMTP id
 956f58d0204a3-6502ff9d85dmr638722d50.1.1774987767715; Tue, 31 Mar 2026
 13:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175456.4065874-1-luca.boccassi@gmail.com>
 <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com>
 <CAMw=ZnQZm_k_mMQPmKwuBtkFyXXgAn9MK1NzmVbZst4nGu6xhw@mail.gmail.com>
 <CA+CK2bDL9=uNmy9hq=3D-w=MHYsY82FNCkqvNeNpnTnX6meYRA@mail.gmail.com>
 <CAMw=ZnRKEaWC0GiXWHpbiAchpZeBawOCoDgtq18B1UJsZpNN-w@mail.gmail.com> <CA+CK2bDSfOE2VardTc=QY2RyY0uv6yQu7ucn=5sWg17t78oMjw@mail.gmail.com>
In-Reply-To: <CA+CK2bDSfOE2VardTc=QY2RyY0uv6yQu7ucn=5sWg17t78oMjw@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 31 Mar 2026 21:09:16 +0100
X-Gm-Features: AQROBzBQ9Mc1C_QgnWw4AAOxRCJoiG1LZkbv24JzGWkrtj7pIANHvKTZSvghdTA
Message-ID: <CAMw=ZnQ++dDywZKCtv4k=9VDPHXWqPvuatrZa3JpKxN+X2C5ng@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: truncate getfile name to NAME_MAX
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 89aaur4r7nssysmnr177q815jb655nbu
X-Rspamd-Queue-Id: E0D3E20008
X-Rspam-User: 
X-HE-Tag: 1774987768-358418
X-HE-Meta: U2FsdGVkX188q1aCIYCszT6w+LbgYVAXxjx4O5L9HNiDSSyaw23l4kzEadGNGWNG5rbEFM02xZ4/kwon8eqJVWlPlnrSz8yNlMmQAdGdGuIjKHGinEPwVc+1KgDR28T/5sBUCaSXakHGTxjbOq6pQZpQTerBpKaq9LhGM8NMtPowH8LuGep+TSOtbIfXQxb3tT5EX61YsII5ur2et1mVArbz5efDu38LR3qTFEjg8aMfunBch91U0t7em6Pr/iXIA/j3PypmK01KoT3MG0upHvcC+fFRKiObSXpkUpIW7fgZ9ULYWIEfptFrLKzb9dnaeRM9Z3RBDICOQQK9iZIkbxLhKATrU751zwaUj9DKY9/bXm95JbIpG8WwHNvJTEz4vAbHBmqdsxW+MffeHoTPdNE3xNh3sLIni5CIJ2P/SV3noaXed2jzb5r54gnmLd6hDWOOnT90fyDFvZ5gdImvfQGPcN6eECCaEO4j/WEn3ItR2XvCaqlEOoFAWB0U3gkgw24dMenLaI+SBKYE9Sdygqr2gMAILTtE0RIKOnIgyQg/HXuGvDIrMxd47MQnY3m+x9fuBfdAT8I0kugoRSUlUiY3hrKSjmdy9CHBJiWLFnsy2p/qpmlYZWN0HjMCQG1gr+Dz/gYF8xa+De8/bFSXkbHfsT7XpH08rwDcKbuOQztpJhwh6YpJozENzQ6DpYsNS6FO8Oezwj+T1wZHKv48t/hrWiJmfXK/qYY6F7FeTx+fB6vU/Sc+8MHl1gJKO5xmmLXkesC7V8cLUPZRXPOkFFf4fSDBQweaNYl/5OGIGPCj8Rso7k7C4crpcj797Qp316q11QHfO8d9TiHTh+FQD3R3HMsv8+KisgAc3CBrmCMMUkJilDHYnYgS4vKFJsTeEEzq2O6LqgtE1Ck+JWMMNyA0IECNjQFh7RUtyoR1Ilyf50SfuypNAhSxgs3rhzo2MoTV17J2cpyvf4kHQaq
 F0dn8SAX
 Lpa34vvreAnrpGojNT+Z1RYFpej9n5iHeauMRZULNnT9BQKxw4pwt5yYBrKazOL2NJg7xSpToX4EZShQNVrR5wtpljGhehAN/J/nLSyxq+RLlB+IGqt9+QBFMXTm8rsuQ7Sddei7v5wJYEnq5Eqqmlfg+brNY5J8Tuoz5YkhP3IuS0Rpi5rKrNMFCO6LgBt0zatsLcKPeDg4/w1hvHw32DrGvsHQs7fjSMlILoSDnmp1jEXRvG2uZCjKMkv2kS75/ahEsnC0N4jRzrnFBkUOBp+Ky+rCCCyVfOcAzfcaF1I1zC/sPpOzMlFrbHr2bZrMl2bIWP7xUvgbeYey3qqwRdeNoYnBQ02BdphwYMzvca0VaGVGXfgipgvYusU76DBDbtx/7rcfCWVjniB7hU2nuis13+1wkBzojNuND2mqcirtR1qJ5mFZb59jgPduHdVh2BDyOvh/e8wha5R64z3miMfZU7UCHztrzsJ9dHHzu/yr1Vx6p7EeA3UKYORcKvWLpPxeukt7SgAG8Qn2f65yglp8VmFtsVDsGB38ChXgRL1Wc2b/AL7t7Go8nxkRuyPojlRoplvH8c0tnUDolyE04wx3aENQhgSrFtRWIHIEDc0EHf48MNhh1+QcpbKBx4cfRVU92Rj0JhQLDu4IOkWW1JbQByypmgZ3WGEBBNKzZr5tGrSSvOJY7nKSltGm1BlaVxbLFtp02WiB2oQOvG7FwmmrK+tzCYBjdG4KiEytCFuRfkBOCEYUhkQvOY/H5XmJrVTvuXvXLz/HQysLr460UfFznCol/g4U5AzMKLSF6TJxbdUF8iJscMsiyH11fQJ9VC44YSazF3FxeLlJY74LX0R2b+7JTcmfIn41ATnNU0YWXnKfBMYYlnh+aNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 at 20:58, Pasha Tatashin <pasha.tatashin@soleen.com> wr=
ote:
>
> On Tue, Mar 31, 2026 at 3:40=E2=80=AFPM Luca Boccassi <luca.boccassi@gmai=
l.com> wrote:
> >
> > On Tue, 31 Mar 2026 at 20:14, Pasha Tatashin <pasha.tatashin@soleen.com=
> wrote:
> > >
> > > On Tue, Mar 31, 2026 at 2:30=E2=80=AFPM Luca Boccassi <luca.boccassi@=
gmail.com> wrote:
> > > >
> > > > On Tue, 31 Mar 2026, 19:21 Pasha Tatashin, <pasha.tatashin@soleen.c=
om> wrote:
> > > >>
> > > >> On Tue, Mar 31, 2026 at 1:55=E2=80=AFPM <luca.boccassi@gmail.com> =
wrote:
> > > >> >
> > > >> > From: Luca Boccassi <luca.boccassi@gmail.com>
> > > >> >
> > > >> > dynamic_dname() harcodes its limit to NAME_MAX bytes, which incl=
udes a
> > > >> > NUL terminator and a 'anon_inode:' prefix. If the name passed on=
 goes
> > > >> > above the limit it results in userspace getting a ENAMETOOLONG e=
rror.
> > > >> >
> > > >> > Truncate the name to NAME_MAX - 12 - 1 characters to ensure this=
 never
> > > >> > fails (accounting for prefix and NUL).
> > > >> >
> > > >> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions supp=
ort")
> > >
> > > Let's remove this, this patch is not fixing an existing issue, but a
> > > preparation for future uapi changes?
> >
> > The linked patch that increases the buffer to 255 is tagged with
> > 'fixes' so I don't mind, as that's enough to fix the -ENAMETOOLONG
> > error in currently released kernels. The original version of this set
> > the truncation to the current max buffer size, hence why I had the
> > fixes line.
> >
> > > >> >
> > > >> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > > >> > ---
> > > >> > Builds on top of this just sent by Aleksa:
> > > >> >
> > > >> > https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-nam=
e_max-v1-1-8ca20ab2642e@amutable.com/
> > > >> >
> > > >> >  kernel/liveupdate/luo_session.c | 7 +++++--
> > > >> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >> >
> > > >> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate=
/luo_session.c
> > > >> > index 7836772956406..4a40c7fdfb44f 100644
> > > >> > --- a/kernel/liveupdate/luo_session.c
> > > >> > +++ b/kernel/liveupdate/luo_session.c
> > > >> > @@ -366,11 +366,14 @@ static const struct file_operations luo_se=
ssion_fops =3D {
> > > >> >  /* Create a "struct file" for session */
> > > >> >  static int luo_session_getfile(struct luo_session *session, str=
uct file **filep)
> > > >> >  {
> > > >> > -       char name_buf[128];
> > > >> > +       char name_buf[NAME_MAX];
> > > >> >         struct file *file;
> > > >> >
> > > >> >         lockdep_assert_held(&session->mutex);
> > > >> > -       snprintf(name_buf, sizeof(name_buf), "[luo_session] %s",=
 session->name);
> > > >> > +       /* dynamic_dname() rejects names above NAME_MAX bytes, i=
ncluding NUL terminator
> > > >> > +        * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12=
 - 1 to avoid
> > > >> > +        * ENAMETOOLONG. */
> > > >> > +       snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s"=
, session->name);
> > > >>
> > > >> I am confused by this change, the maximum session name length is: =
64,
> > > >> as defined in:
> > > >> include/uapi/linux/liveupdate.h
> > > >> /* The maximum length of session name including null termination *=
/
> > > >> #define LIVEUPDATE_SESSION_NAME_LENGTH 64
> > > >>
> > > >> So, 128 should be enough to include:
> > > >> "[luo_session] %s", session->name
> > > >>
> > > >> Or am I missing something?
> > > >>
> > > >> Pasha
> > > >
> > > >
> > > > Yeah we need to to bump that size, it's too small - see the shared =
doc. This is anyway needed for safety, as the user space call falls apart c=
ompletely if it goes over the hard coded limit,
> > >
> > > If there is a safety issue, it should be fixed (even without a limit
> > > bump), could you please explain it.
> >
> > Nothing specific, more from the abstract point of view - given that
> > this will fail with a hard error if it goes above the hardcoded limit,
> > it seems better to me to check it, rather than assuming it's going to
> > match, as that's error prone.
> >
> > > I looked at the shared doc [https://tinyurl.com/luoddesign under limi=
ts tab]:
> > >
> > > I see:
> > > TODO: this needs to be bumped, as for the varlink API we will impose =
a
> > > cgroup path prefix, which means PATH_MAX + "/" + client-supplied
> > > string.
> > >
> > > Why would we do that? Why can't we use a 63-byte unique identifier fo=
r
> > > sessions and an in-memory database that maps the cgroup path prefix t=
o
> > > session_ids, where the database also gets passed from one kernel to
> > > the other?
> >
> > Because that requires tracking state across all runtime, and that's a
> > no-go. The session itself needs to be identifiable by cgroup, so that
> > its owner is uniquely identified in all cases, in all situations,
> > regardless of any state or lack thereof.
> > The structs have a size as input, so it should be doable to follow the
> > usual process and keep it backward compatible.
>
> Overall, I am super happy to see LUO integrated as a first-class
> citizen with systemd, and I fully support this effort. My suggestion
> is that we step back and prepare a single patch series that performs
> all the necessary changes together, instead of sending a few random
> patches that do not make sense by themselves.

Yeah I don't mind, I noticed these two issues and fixed them as I was
going, so just thought of sending them as I verified they work.
Thankfully Aleksa's patch is enough to fix the ENAMETOOLONG issue and
should get into the released kernels too, so this can wait.

> As far as I can see, we should:
> 1. Increase the session name limit to include the data necessary for
> systemd fd store restore capabilities.
> 2. Make the number of stored sessions dynamic rather than having a
> hardcoded limit (I have a patch for this, which we can include in the
> series).
> 3. Add the necessary API to query back the incoming and outgoing session =
names.
>
> Is there anything else that you are aware that we would need to add?

Yeah also mentioned in the doc - we should bump the limit of FDs per
session, as for the fdstore I am using a single session for the whole
system, as we talked about two weeks ago. Apart from this I haven't
come across anything, but I just got the initial proof of concept to
work end to end this morning so haven't had a lot of time. Also the
per-client session is still in progress. If I find more requirements
I'll definitely bring them up ASAP.

