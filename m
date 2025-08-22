Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFA3CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93EFD8E00B7; Fri, 22 Aug 2025 13:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDBA8E009D; Fri, 22 Aug 2025 13:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803EC8E00B7; Fri, 22 Aug 2025 13:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7C58E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:16:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D29716020A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:16:44 +0000 (UTC)
X-FDA: 83805047928.14.43B3285
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3C53D20011
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:16:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="I/NBSIlQ";
	spf=pass (imf13.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Reiqrhs0SwE9AhkJDRm2RhHstOruGMKD+ubZZAq37oQ=;
	b=RvDWvSw6QJaU1N/eVfIRdk5/jRenMTPV5HxCF2SS0bPMRjoglE8rxMEYZJ6YiW0j/tUJWn
	M+0nKXXcFTPYRLbXRQNG80iSJn+mbt0LDLWkLgKANEulCtyFemEHIx45g5cja64I5kJblU
	TJBzAcJ5qHldhVImkC7wHj6Zg1R5/NQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="I/NBSIlQ";
	spf=pass (imf13.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755883002; a=rsa-sha256;
	cv=none;
	b=vkVqMqaWSMM0Kazr6Qyj+hkd5BkLGQXOwZJmRJ3r32c/CfI1f0TNE7iBmOY/4FZ6j9xoQf
	wFEg3nM+BsF5f/E1w1M332dY6tFNw5MGRmT1nCXvs9H4G/kLSOx5G+yOSJ0F9GvG1iJCv0
	RJtk9Eiz4xqWphlrtzfvAri1MHhnilc=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61a207a248cso627a12.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755883000; x=1756487800; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Reiqrhs0SwE9AhkJDRm2RhHstOruGMKD+ubZZAq37oQ=;
        b=I/NBSIlQyG5qNNZhsO5k91QR/W8+eYSMX03xK7JfGsJf/JBQ4CqXgy4/0ROPtPItlE
         EA44WRoCFfTnyiOOEMfa2kjmIC6mZ3fi68RSovnf/8L/dNNlP5TYhE9Kk3rxlrQU3yBb
         s1Z/qu/IaO8UV4Qo45YXsRBlpt+JU/60SB9UwnF24H9bYcb8PN3vp4xnJebLYeM9h+hj
         n+b36qqYOc4p/8dUXYqP6YH9PD/iE+7uoFBhYML0cANiFPUYlQLl3ZUfnUNr7Bxc1B/R
         J3iocDlpstagBYGBBPC79jEGo4nw2dE67mRTTPN+Uuw35prZ1u+BftCj7tYMYQGXDe9w
         bKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755883000; x=1756487800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Reiqrhs0SwE9AhkJDRm2RhHstOruGMKD+ubZZAq37oQ=;
        b=iihRCYNQqrYmQC5qVg9nQ/NNb9deX86h8EqV4PKRfFCFjo1iQZbaxLezvVd8MijQDr
         kJtm4NeV4sg6SPejlQwRcUDqQaNfSEqJWbE+vg+MAvDYN+W8cRq9m+PVjlN4OzirFrTW
         MliJvgESqaBcCh6kW8TuV1HT9eb+2yogQikzdDn+D9TQhL6TnBboMhiGMi9CNCqKIemj
         bUYcUcx1sfW60bWlFyQxpaBJ7mboh4aLXLG8dqMXUngf4ap/Z9h+WEPCmQfT34zF9yiv
         z6OXDF+g0euA4Iz7sIusmFCSUYeLZy/1K0YnbARLmBFWvgSFrHrfPNYe8BQW+8bKI3Xt
         e7KA==
X-Forwarded-Encrypted: i=1; AJvYcCVrl3q0XIgFUHr7k1nrUC1zVXVGG/lIUk4OQOZEo0u+1fadB3CnLFYuf0yIv7yWbPexTgM8rVqUQw==@kvack.org
X-Gm-Message-State: AOJu0Yxw3XQ+gtoXvXAFa+O20cU3H8+HeLvJ+g7JBrBTmKxtUzfIBhOp
	3KiQzZOLKj/vaT557O8BLnWEGCH3eRQ3mc75nl4lLhQhpdSBTdMkyM0a1z+zasLCE1ISVuaN3V5
	LJNG4yY4b9qjAfRALZ1K1kGW5P1Bp4rozw2fkVGzC
X-Gm-Gg: ASbGncs959yDqmS/Bqt+CFS/zSct5B5Yjg+HG6fhNMBqAukKi/TrNQHDMf2g2YGspFf
	cgP4t8Dut1NwKnxNz1bcMCSJt4ePzORueN555HLRPcALr/t0dw/v6bpEss8Tud0ODlNxtEKJC+s
	Wsjd6exbIhiDDXStk1itiwmLmpOAcCdkvLLClZqC44uWhiy9UJOzfaaPhGtKEJd7xh3jEmcGX0y
	wqPtBIkBlw/LTJMXbz5TagoEiMdzeEnNWb4MMeLBNem
X-Google-Smtp-Source: AGHT+IFXIGut26LOc1CQf/XCARjxaINOLYEDzaorWnc/UwNjcbcHiAwfR23VgucQGTTwO2zZuZmzdzyyz3t2YgMZl5k=
X-Received: by 2002:a50:d69e:0:b0:61b:f987:42d9 with SMTP id
 4fb4d7f45d1cf-61c1a3c18aemr96810a12.2.1755883000214; Fri, 22 Aug 2025
 10:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
 <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
 <CAGsJ_4xccre0rz5zgRTA=NbFzF4FLS-ZUohgLFnfTGY9Jdequg@mail.gmail.com>
 <3133F0B4-4684-4EC7-81FC-BC12A430E4C2@nvidia.com> <CA+EESO7_-64GU5v1FTMXbemQixPX+xo6SGm8r0txohZJLs97cA@mail.gmail.com>
 <aKhIL3OguViS9myH@hyeyoo> <3972cb48-2684-4ba6-ab78-66460a939929@lucifer.local>
In-Reply-To: <3972cb48-2684-4ba6-ab78-66460a939929@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 22 Aug 2025 10:16:28 -0700
X-Gm-Features: Ac12FXx5T0E12LSSvBocUhz1H5FP9e1ihWkMaGNO3Tf3CJxonVxzYrWcs24n3UE
Message-ID: <CA+EESO5nE4uLhqgGaGTbSf_ke+TnZjw+ijJqys6omNpaaEF9Lg@mail.gmail.com>
Subject: Re: [RFC] Unconditionally lock folios when calling rmap_walk()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C53D20011
X-Stat-Signature: wgs661zdkjex1eauu1thoo85ijtiotqx
X-Rspam-User: 
X-HE-Tag: 1755883002-247030
X-HE-Meta: U2FsdGVkX18nphi2YoEcP/tvKDYj825R44lzCQWigrWDuHA58qCdUOCEPByIqDeKaQRf48bENithBTzK3/HjRL6yudmZ65sVaA+jQ4KxpA6cMgr/0jXzZiIJjenh+AeqAOVKXuANmHq1ivbjnpYar92YNQd4ZvSbUXj4anX3VsEosFdn04nmTDK1rqVAF2cq4hDuer1a0VDTLYOcUxsJdsrft6E/sQcJ2IipV8LDM2bijQQdLeLNoJnXKyiHNhsX6dSQLO7U4IaKwXGek9GVP92jrnO9BEa71o/U6dNpJDY73TqobLgGU5VI9l2TW+UO/oF/1djCcNsSAZ6D5HY3Je7YC+/pLJhFpbYiZ4Ee23H1GKk2FhlSKUpzKgwfP/G4qCMvW9zcoXwJ3VCwmISVA/SISLLA5qh6PhzflBbX3iQxq1K1oDlHlmSFD3K7IeYMzv04IB6eQYjUoKltYh4XhOlfc9G+fkKGtrPVR4IegJlMea9oupnAVIsUiF5tPIlOLPGSgy9UabKGBOyPJQZGNMkzL+FfafQzc8XjAoHS39+65vkLBNx2VCtIA6BAmqk6867WLR27s+FTf1yIG4gH9zf5vZuLu6z9TuDEgWdH4J3v1Obifh/ruoSAp25vFtslk9IkUzVFlQ9yV5tJeRSB6hMZ6+ElRT4QaNZay53J8xRMMVctmYkrnR+3YSB2s7VSP/kJQNkmZ3xCKYaLbRqahJLh66Tz/AJTojNpWDbclCGAbPuu6dFMwdQlpjDe5e6gxaRuZg0mz7xb9dGp5k8lqnmaBCEhlWFpeMS1A9bqvwSW62I5xuvtpGGdtKepIcV5dM1E/6nFGx2gzQH/xwxWGFSP0PSkcZ2ZmXCWpiqndaSqxjEzICrmggs4TM2OXPxKbes0emhWB1mA1GjJBT79CwoehPF2MCHFsXYVTP/IGzRHTX2XiOg2FUz3WR5Jjn1Ev1pGunhj2vYxyJvccqy
 k5dJ/98O
 K88xsYB2g1wq5LkidUv5R0OQfRG/6ksRN7eJ2rC4y+DKflEMh0bWR3reQ1G5dRv2Fw7xyIxGUPlm0u4pDAExAB9yLXEYOWA72x1mS4d5niKndkbG2FVm9BG7SAc1rVIbIEA1iLcbGRPbfXzBeETRT/KnjSbrzNWzmdphG6sTZHzqfS7iEBgk083pA9hNMTcHB/NXuhByLvJV7quCeDyWmtsqX3CK1fQbq7gL2hmH13pw/9aPQYXv/36CJSKp8dinJJdjo7c36KULUqeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 3:50=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Lokesh, this is a mess :/
>
> I've been a reverse mapping co-maintainer for 4 months now, please check
> MAINTAINERS before sending this stuff out. It's not really impressive to
> learn about this 2nd hand...
>
> Also I cannot get lei to get this mail to me, no matter how hard I try. S=
o
> it's _really hard_ for me to respond to this.
>
> And you label this '[RFC]' but I can't find any code (unless it's lost in
> the thread somehow). It should be '[DISCUSSION]'.
>
> rmap locking is _extremely_ sensitive and the discussion needs careful
> attention.
>
> It's hard for me to even track what's going on here or join the discussio=
n,
> could you just please resend, correctly cc'ing the maintainers/reviewers =
of
> rmap, and prefix with '[DISCUSSION]'?

Sincere apologies. I'll resend correcting both the mistakes.
>
> You've already got responses here so we're inevitably going to fork the
> conversation, but unfortunately I don't see any way around this, because
> I'm going to miss all the conversation that I'm not cc'd on.
>
> Anwyay I simply can't engage on this as-is, and I really _want to_, becau=
se
> rmap and the locking around it are issues of PRIMARY importance to me.
>
> Please try to make my life easier :)
>
> Thanks, Lorenzo

