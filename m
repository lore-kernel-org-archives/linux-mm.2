Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8841AC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80276B02AB; Tue, 18 Aug 2026 13:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58766B048C; Tue, 18 Aug 2026 13:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946C36B0553; Tue, 18 Aug 2026 13:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9786B02AB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 037FC140143
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:12:06 +0000 (UTC)
X-FDA: 85115033094.28.E1F4966
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A07F10000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:12:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="e64RtK/u";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYd1sLRIGdJG4E3yKre1shMv1h9nzDPpanMRuTlCer8=;
	b=2E25ZTsG92OZXQSKsyfu7UbFetAG2Jgm+Cgcmh24vUN9jTvYA3831pcriibBIsDS964RbQ
	vSO5RhrutgCzTCK7FfJXEmr9pkMCRJSKMNkxYttK8tpcEAobgAE6XoZHRt0vMYo2UIemRt
	zv/JWFoP17dGQuzywTT2zxtNkmWtYTQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="e64RtK/u";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787073125;
	b=P3cNjETLl1Qx8qcEuPidMtfX57jrtMWrhjXKgmpwZRG7UhsXsmXjbQcK8xg/tMTsYpNJMs
	bZ6CQ+9MIKClUaa0SQU+KUacRC72kY5KASM8/+IXYtR+7EQBjzqfQ6OnxhqIBZIcbw+dOl
	749L6YcjR6ect/NPezsJ4cwamiKR8Ok=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c15a5b265so369951cf.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787073124; cv=none;
        d=google.com; s=arc-20260327;
        b=iP4/+1gZIets/U3Zh1fXGjVnnfRbQQV/5j2gUT4pXz9m17KDJ6g88XQQfTgXcxdqci
         MHOqLGxvRDNSv/LZ8L0Ms7EvvOiaGxZa+LYEPG3+zvxh/YofwHAyE/YfnYjnm8Ngs0Y2
         gOQ6NDU7WebLgxKproCTCirUFWlP+RjQMNT8tUAeU1SCj8wBrnLAYd0opW+ak7bCPxrv
         aWS0IzO4iGz985uR/hT5MqgnhVoylVQrRbWwDBxOUrW/oyeEnAOQOCVgsIMwltcCNc4h
         TNRERaj6cUf3umSqV0BkdpJeKab8Jd61HUBf8i9HC4q2qIqNLvzhRizKSx4cAOLc4d1X
         5yKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CYd1sLRIGdJG4E3yKre1shMv1h9nzDPpanMRuTlCer8=;
        fh=9sOhRxFm+6VsZNrpWzoGxOsXEDKkOq6LFQ00c3l5Wuc=;
        b=DxTgss26aeqJQfMrWKRfTgbtCSpJztywsIjOgZ99opOT5LFhq+LvdObKNxxmQGr3Pp
         HO0LyAEQhJvS9EiaQi6s3rRSGEYBcaoJ9TKfPvH4Dq1kYFxetrMy/SJQNtVdr6dXRG/s
         TshFLsQPp35rM3ecKl95zJ8bPiYhQVSK4f/h3PzqYfujJpsW0cw+/Jl9ZvpU5+9AR9na
         RDh1GamW8FNlv11vGCM94KvXXahmvdhDlNuKFZVHcpXdcfx9FG8iJ+VVcqgoNY6pGKP+
         UUV0rlUCCQTdvJyLEQxwrMyxyiQq66iRDHWn1HSlY0twcsk68qi+DDSn/BSuilLrmOAv
         x5zw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787073124; x=1787677924; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CYd1sLRIGdJG4E3yKre1shMv1h9nzDPpanMRuTlCer8=;
        b=e64RtK/u0BWlh1UXoTq0hZqcM3Gmwg/ebaVV1abEMfBKtniaU07tq6D5YAKHh89kOF
         nZ1HEiX0MsKosffygPmLcSJogkMWqv5L7T7wsVIm1puss3uAhF5bg7OEye+Gxe5pE417
         yOhU/vXzT7Gqkaw0RD2hgo14OEGAmQqShddsdZ58g1APuljkuvMKZunn/Okq3EvfRk51
         rf2zMAa+FVW2yFz0hrc/zJ0NaYY6mWCFLeEPXmxRmoy41iR9P7pG6yypnqzbW3s6WZoZ
         UvG+7PKOTJA8lQGVdm67mnaycjooGNdAXXrCOIzgBtUHWOYB+1GbahP5UNlxjntxpE10
         xrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787073124; x=1787677924;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CYd1sLRIGdJG4E3yKre1shMv1h9nzDPpanMRuTlCer8=;
        b=ns05NPYPKrrsDYj9l/ZXCZGB9gMtQLh3/wfOKKvf/Jc4lZdSiLRGshBnrdKhFqEyxX
         sOempTWVSQGcogFvtPp3oTZwpRFIaHUCyj2cy3nQGFjaji9VQx6OyxM08FbiPJw6rsdI
         5KXyrWVlhKdi+dcXLEJw8JcTorPukNcKZn6Kn9j2ffUFa/YoiWjUr9KBi/54PaMa53wo
         EHBtjuX9Q3K1edsOfgDKbpGs3nttp98dfgawp9c+aKnwn7VqFRdpq4x65XzH6B1taNX6
         42vmYCwQh1XqACjd+ac/AMvy3DamnEWvq+RpG2P3PdrAreB8fCntn660C6L8rhHhUIWn
         5tDw==
X-Forwarded-Encrypted: i=1; AHgh+Rp+EdGRH/ZRrpHYJbeUngiMDMAbwaKCb3eppky0pYJOsGH49hK3D2bbeiDlF3tGMIMN0WzzDrX7hw==@kvack.org
X-Gm-Message-State: AOJu0YxPto3ObAs2iOJ7IIGOXOa8Kd437LgBgFoXTq2vQQC3PAdepLhk
	b43vzisDE94he80memc5Q8Zs3Y40d3zv4gJZBvMaAJOvpzWpFhj9FJi7RyBIlnqEZk7h2T5BahZ
	KNpcsoOLJNELIFPcxaPKOdARikL4n9K3eFzkL6B3M
X-Gm-Gg: AR+sD11JxV2I/SCfo6L4CBWp3uRdnJx1LIkc6LTr+BBjDZJfH55OrjFpZsfWL/FCVkT
	+4fT7h4cQ9aephwZter+w+ZZTG82lPZkUaRKUHmS5TfPnSWjbaHyvt6ZZZ0x3ucmedE50iCigVw
	sYg3B9u7EnyvkXZZ63HKUdGNpl/A2Qnpd6GSSEjCetiyP51pa7As574a8XSpOSo/WUiiE+Js9zz
	eWIu2K7Vwzr32w56hi4nVPfaegyhlfjQUry4e0IlI6oDwSJu796Ocplgu1L4Qrqn2iNSZO2KiDA
	GPRawd0VeXVIId3Mh8WMtzBxq2oP8IdGtmdxXSNJ8h9GfhLQn+CjncEfoZZ3iufXGTKT/lM=
X-Received: by 2002:a05:622a:2518:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-52dc4821345mr20258131cf.11.1787073123166; Tue, 18 Aug 2026
 10:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
 <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org>
 <ae1cdc48-4293-8b81-d142-3c656f2c2cfa@gmail.com> <CAJuCfpEOF3=Uu3cvoiH0tJoJhhRmwR0YLy34tyPC-2EE09xWMg@mail.gmail.com>
 <b248cc12-e083-ec37-e6f6-2a57e8cccd3b@gmail.com>
In-Reply-To: <b248cc12-e083-ec37-e6f6-2a57e8cccd3b@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 18 Aug 2026 10:11:50 -0700
X-Gm-Features: AcwNN1Xu8F8cBF0IwuEj6v4Tz3qtaHIU6Rl6oQsFGy_OcZmqTaVfiC3onkPpLq4
Message-ID: <CAJuCfpFzcpqG+g9f-m+-B6yk=pOU+PKgKRLVowOE65S127NWzA@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes succeeded
To: Foxie Flakey <foxieflakey@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org, peterx@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0A07F10000B
X-Stat-Signature: hsjk4sna7gdgxi4sq7a67u7af6tin3o3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787073124-134554
X-HE-Meta: U2FsdGVkX19GbjRGVF4ry0P1WeA7xPm0ZU0S7ahN/ceOhDk7voUVaVFaLx5dQKiNDBLHnQNOxqiAovnkSu6H58pGqU5CTj9mFMFEMAJ4gWWkRHr0RKg79vkfvbNzWsM2rcfB0X1CGGHJXXZ0Ao8qeg5cz834U4oYS1jwLUZ9Q8hzI+ZV1716rxiE4jhozU97L6H4PDkhc73Xm7qIJ8ZBHJlFp+oqWb9ROOmfpC2vnQ+r/r6QIVzlx0hrYQFECmjPeLeF/ELU8KHHWd4JxZ3dtKUMWkIWPUtkvoiXA2l4jPhJFeuT8BJSEV9fL1rHHMZh2I87LpCFzsyJvA5mrmuYPQ7I2sbb9Iu0jkI/LXyMEXkdOmx0Scpe1P1lckPk9QqKmh42p9FtGjnN0EFpjKy6SgHY7FvNvqDocO5RhyEK3tIwuXM1+FIbttdvLMX1WQRd6AGRA4XBnSQFeSXloGe3uI3L4bXJLsyBnX0vxemZtv9M/+rqya8cxWUdcIzGeqYrLaUxrl/h6D5jEG5/rWcrLNE2eek0WHS4ykvJCNICzE6WxqoVVDES/+fN039hV3p2czaui44Kr/v+DPKfjnGdl5eGypyUnVs/1wRRD+XJ4vbChEdhRhTBOS5R3eSRelD7HfJM6Ug8Xv6kEY9r3yUlbBNrQddCEMGiC2iyxjDz0GhRNkoCx2dR3ddoUWL9uSn0H649XK8EcSp8NG5YE6weVJrg8UiA5AJQSKu4qiSdSV1Of9tJSlQ7lZh8FamIZVJH5Brax3z4XnIIUJRBIEpRW3gI/IAA6+jyY5GGBCPrcrMyzzKHEcdhqAZOC4eVd2hS8a4sGh5dDSc/eg/FmeZlJBWJpDgdUBspm//ds0kw954FCyW722lCV+u/bSWlYccymcUzOhcJcmSmJGsRpFzIdpOXQVMh71/cO1jCIiNKWTuk641l1jmMq/IAjFbpEvK0YZblDYR09lhG7Y7AEQp
 JgT+yPNp
 4zBR5YH/QVOqRAWPv2uqbHrTwpEw05luif4AQSJyZcciGM54scm+VZxm3ZzeJS7QdTHyyJqJctIC6SezHH453RoQWZqBEd9BcCmmITqSuPOJCC5ano1g4GvgbPJUjjn1G67JMUf8F5t42NdCBk2id1ja0RHDmfvIwWJu7fbo+Q8HhqDwremGz+JGrZ1oiwjGuaWZYbx+8srcxzZf5b5D2MAWOtgbAKT2yEFcx9epOXe4EiUfSvPYx0Jk41DWwOkUgGc5M9QUslM2BJ8F3Oq08PncXozT2SCg6etNVxkb7Btv2u43XN+bdBhRCcIqz7kQR3wguJGG3LL6mgrRr4LJjAmjNvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 9:50=E2=80=AFAM Foxie Flakey <foxieflakey@gmail.com=
> wrote:
>
> On Tue, 18 Aug 2026, Suren Baghdasaryan wrote:
>
> > On Mon, Aug 17, 2026 at 6:13=E2=80=AFPM Foxie Flakey <foxieflakey@gmail=
.com> wrote:
> > >
> > > On Mon, 17 Aug 2026, Andrew Morton wrote:
> > >
> > > > On Sat, 15 Aug 2026 17:42:12 +0700 (WIB) Foxie Flakey <foxieflakey@=
gmail.com> wrote:
> > > >
> > > > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batchi=
ng for present pages in MOVE")
> > > > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> > > >
> > > > Yes, the pseudonym is problematic - it is contrary to our written
> > > > rules.  But I'm a sucker for fixes, sigh.  Perhaps if someone else =
were
> > > > to send me your patch with their signoff also, the rules would be l=
ess
> > > > offended.
> > >
> > > I see, I'll post the updated patch and work on signoff issue later (t=
here
> > > has been updates, I haven't posted v2 which updates the patch and
> > > description following a feedback. Why I didn't? mainly I'm not sure w=
ith
> > > answer for signoff)
> >
> > Yeah, please follow Mike's advise.
>
> Okay, thank you! I'll re-ask Mike again due I'm not receiving sufficient
> answer.

His advice was to use something that identifies you. When you meet
someone at a conference you do not identify yourself as Foxie Flakey
(unless maybe you are at some anime convention). Use the same
reasoning here please.

