Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74654C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A91D6B00CE; Tue, 25 Aug 2026 09:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680AF6B00D0; Tue, 25 Aug 2026 09:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5965C6B00D1; Tue, 25 Aug 2026 09:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 307FE6B00CE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:47:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E4C21A0372
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:47:33 +0000 (UTC)
X-FDA: 85139919186.17.EAEC938
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BE22100009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:47:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lTubj3bz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of jannh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787665651;
	b=m1OjmtAXzos2PwOe+lVz4iAifJLgvVi2Gw6JqoP/dsCwU3g3/LiI3+NFU1MDSwYc9R2qGD
	uirQiMBM6Wtq4K7aDLWCQER4r68grQus2uKJ8TXyLdzfSAiBXqqEYsbNYC0vGSsdcB1/5V
	xybwdc7KvZHmp/UvlPOZY1ewZlB45Ps=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lTubj3bz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of jannh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f27C2IG9jxEp5m5m+A45U94PwUHYq9WXQ+b1ZTPnZCY=;
	b=4I5Zv60Leg0B7HdGNR2S5ZSqgf6NQnCyBwbIIWq2MFFUybIU5MD3bLaulVO4AAU5XCZvHX
	I/wXLdobKzmV4Z1mnbmwHrvUh09COMGbqn0TqObgtnbdM0Mkej+d4JuBELA3iFyQPMKqHs
	VLbzYm6R+pKbQ+0q2ossOIp3Ka7UEho=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ccdf36f63dso123235ad.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787665650; cv=none;
        d=google.com; s=arc-20260327;
        b=kUeYTDeCddtiLN7NzDhI/k3uHb9HzwGalcsns2GQDNXzfTipDXH6y1CKPuseCtZSqt
         C2xDP0QarJiULuIfzOcVeTwTO/dBLdQqem/uT/1mIRd0Nm8j42vyjNYnjvQ/NjmSFk7a
         SZQQ+e3SaqP2m5lqGq14xfdIwUEqywCJ9bHum76yUbRGzF3orzUIumgo8ju7IYfXgVY7
         bC0fkFymfL9ZN1cmcysITczyLw+G4VB6nLzqg2tehQcVGdn+BNh/TJ3204uPH7TkdJS8
         G/tVr53BZ89AbuxPJxLsqx9233Bd+waz7YnWKu3FvM9l3PIME/cVhr5CBty7Z0jtyy96
         6DQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f27C2IG9jxEp5m5m+A45U94PwUHYq9WXQ+b1ZTPnZCY=;
        fh=wRVWpNPzKVNg/Gy+FTdQ4+LFmkw92T0HJEgF13H48Jg=;
        b=dAZXXB2Rno/Q/I9PgdJ6on0dVEawS4r/baDRm+GGYIvRrfkWQoIchYxJRIckSLaO+9
         FMmHZ2g3VZAAnj6WcD7OMmUfjo4lbW/tdkqjoCcaen4jCsCdzejDloplYdHblySdwRB3
         V54AY38n7HpzgFMes8uclCGKqeapPh0Zst6hjq0DnGpsUGfB9AZc+RRxV/Z1WeialRHA
         z70tXez7UXbX26FF4RRGOoujjcblEUm1H9sH5BXs25YLgTsOXNPfflU/uMObpbyf/JKW
         xhwGmZyGG/slvBXXBxooIPjFJZ8ZDcnTPB7BqvX6eAP8juiuNdKOx8ZcYMhJr6FG8q+5
         L9oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787665650; x=1788270450; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f27C2IG9jxEp5m5m+A45U94PwUHYq9WXQ+b1ZTPnZCY=;
        b=lTubj3bzLS0z7/9HYrSenMfUy4qACNYsFH51rPGC9Bkyo4/yksAvr217BOU97lIuHU
         b0RehRTQAUashfIUuRuiSOYbvS9gg48NLDvg0nxE48/oAPDY+LlW3+nPwkyuDdgLdhIh
         GiAZIvbl46YdfPjXUUeudpfpoS2GrWoulWd7tvOgjX6IuSm371qNfLOGIsRlnRPTfUSh
         /9Ze7in8etVyqoa5l2vzu1GQqu/blmB6ligv4Enr6JY19hRKat51vxpix8v705JOBh9g
         8DNQ4WfBeXkV+/oemgDwfDK8J7xv8G+Sk0RCsl1GagprGN2+N59k43Ub3YDV4WeE8x4F
         bYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787665650; x=1788270450;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f27C2IG9jxEp5m5m+A45U94PwUHYq9WXQ+b1ZTPnZCY=;
        b=qcgwscFMeVJ15JQzfF0yIEsrjItlQVVfh5aSxv4uoRx9G+RBiJLn7Z3/U8XY5XUqaO
         ivBhl84wY13M5yl48d4komWAK/mBjV4lw+KDpkETbZ6k2lcztdm3jqBAF4tQDNPLouab
         kWcXfcxjou3BU2FTITU+w/nLLSev3XKVjdKlJbBkUjzEtWiQ/qtZ1NHoVf7gi5M0oe6m
         hCGYzjANB1DZKeHMzc6qMTEhC9jGiKoB7ic3j7RSWAUm6etEH5s3W0CnlIugKtMdAg3x
         crsAPFrU5z/ttUqClPAjF8azCFazrz7JAKyCFFe5tPCkz/P9MlEIC+/nJyBNEY6hNnv5
         ZlOw==
X-Forwarded-Encrypted: i=1; AHgh+RqlaV/7jZQle7mvmqg4dWRhhLl1STnE8g5Di2QMcChFkRdBkbk0TqkakQFa+c6+5fjTu6WpAgiR4Q==@kvack.org
X-Gm-Message-State: AFuF++m3Rpkaq2vKqMs4M0Isrk++gsVmwBadZsr+xybChEkzAd3hXNL9
	qerpf+7fAHyAdCDYkuuYhdaLYu3sKszDrQyfBF1TTmAnk4sMHL3KMXwVKEBZUSe8mkMIQE4bhOw
	pAU7pCR2T4/6hjVn0UBgzjQMAvCNOlgpunSL17GUL
X-Gm-Gg: AR+sD11qGc1r17w/q8LoRsIoachh5OsWOBrlaSnw6RpJq+VVKT8wrTpPYZR/hcWcIdK
	Npo1UPt70B9mbpeA0ymX10617V+5jGPYQ4DxKBAA+TPpBDG5SVIZSc6g+BKaZh0IbP4shbxfa69
	t608h9f/YxZpIdSy5w54Blx7f5o4pVguDAGbuBXpelQXaSnr4jKL7yN/5AEkDjJyZMepJ/vcMPw
	8lBPuCydsFvf7+EF2t0YEk+elMpWOA0IJ7NtA7qRNf+EN28lquJs11Dr+ykfn7Zg5AgQzxqcxvc
	MYRxRi9d4VpFJrIM+b9WoPsKYfKCNnlngIMRvzkJnqzJS5pOy0D+FUXXRPpPHL9hcdAqPj29dgK
	xLNd+TE8DuCZ675TFTjPXdPHVeAeiaQ==
X-Received: by 2002:a17:902:c394:b0:2c7:b1e7:501e with SMTP id
 d9443c01a7336-2d6e0833465mr5727505ad.3.1787665649437; Tue, 25 Aug 2026
 06:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <20260825-passt-semmel-primitiv-37712c04e6c6@brauner>
In-Reply-To: <20260825-passt-semmel-primitiv-37712c04e6c6@brauner>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 15:46:50 +0200
X-Gm-Features: AcwNN1WZJkxp4obi4wAiUHBJBjq7knCxVUW1syYekpF7g7n4ms28g-sCd7iZ7lk
Message-ID: <CAG48ez22J6tYZv6cG0TEoUFBrbhtWh6BHrZYBWuD-ee1hVr4ZA@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Christian Brauner <brauner@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, 
	selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4BE22100009
X-Rspam-User: 
X-Stat-Signature: bzu1rw9oeyz973dexkamctskhuyjxf5c
X-Rspamd-Server: rspam06
X-HE-Tag: 1787665651-796096
X-HE-Meta: U2FsdGVkX18WeNxYgm5BFZKW/7lXyuvP3+CFGh+QBQgXj7w+j9TAKwpEKtg4tk1g95+7SVUyjIALKuRY3uvmxtFNTdCDsqaX2KMpElqKMnq3rEmkyp3sj2K99vF2CGgvRBjrTqSFEhl0Kf7ClMqNrtiIafihDqBvunZr8xgpvAL35EKh1KZyQ2AzN1otAE/g3NnGyWxNF7c3S0bq0x3hp5u/T8SHJwSCNLeHEp8JLiM3DQVTiH0a+cG0ANBwp140QOaQu/N9DgY52t2L/vI0Pd44JqII9p6JE30SrWPeisFDL5bTis9tZtFNy/ltV8WfMXrNxvAeWCeXwWXPYqwhKYrmllbiLKy6NzgZN16RqzpbOO2AhAbkggP6qWBvonGgOzIgRhSBuFWrfvHLlEExWtMmeeto23LluVIJU7C16tY6MYy6tQeYMWTwr9szoRH6V70okGHBCmctzG/lK+GNjuaafqtSGJ03X2t16Hu2OxzNyU2XGO4LLUsZ7F85u6PWJT9cjmSmWa5rp/K0zwW4bz4PLc0ZjO2JZaVKowMB7YhdqXp6tC3AyU4mnxduXr+G2kGEb6Mvc3PA9IgfGu9FlhC/XCNJUkDC3zmEIV+0IgDxV3RqbiBXaYZIM/Gei9z8y4DEaeViBaRr565prd/4uewg6eOKReJD/KRDRCutisNxopWWHHN/TegqzQuawzUgvtZa1DAmln36NPC05WQ9vAWFZM9GMrYpc64icNT1exP2TZkacBL2SamuQ4ctbU5Ey5sy2IRFWIubGBjr5igTHt/7MkE0YkrVihmzhbRByfxTQkY7zzgCsMh4kgZa9fBgzMMDPrG+lrRUtAptrg5lRZi4voOs13gy7K7ZIhHjFEvPxrHPSzhkzJJ0UVu7ivvIVTdLNX5QQo3RVCW6BwBhvhi6nJwOrqLeEX5kvNom0mgd+bKFaEui64gc+18Xk/xXsbof1XjkrrWJp4c608F
 ATuiHynw
 yUKASiaP4RufLN/BosnL2CbGmKtc/AvV1pnooiOykZUW54CnL1Wk29TwKtaxIoOdmxS4o0X6xgjLPz7iCaqQkZ18SsV7cKCTyEyEdW8pH/BiQepPEOBg5pPrJ0pjBox/RxJNlgUCv1/gMUm3f+XtoV3lE08aO/EpYQ2FX6lmnt8HC+aJkyCEiTkXELeSys6JD/zsAWvOmYpdj64zEa6DV1T3wpqVjxiKta+UvEVAYFv4vLeITILd5d6xV4cNQRcFXKRxC4EU54OGzazezyvsOfii7tji441Ef4UooxmOT2NzQO6LbRNCMGzQF7pdSqWGqG0R9p7fMJckzOc7Rp8CiBKvdvUL/ixSESPiXUcX6zbNUqx/UjDnEA0vYxp1O7ShtjW2HpsnNFVtMb5dwTQatLZ3RZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 3:13=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
> > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently hav=
e no
> > good opportunity to block a process from overwriting read-only code in =
its
> > own address space through FOLL_FORCE writes via /proc/self/mem.
> > The security_ptrace_access_check() LSM hook is bypassed when a process
> > opens /proc/self/mem because this is considered "introspection".
>
> Useful. I ran into this issue just yesterday in:
>
> https://github.com/systemd/systemd/pull/43511
>
> Btw, it's kinda annoying that PTRACE_POKE{TEXT,DATA} still allows foll
> force writes even if PROC_MEM_FORCE_NEVER is enabled. So ideally there'd
> also be a hook for that option.

You need either /proc/$pid/mem or PTRACE_POKETEXT for installing
software breakpoints. I think if you want to completely block
FOLL_FORCE through ptrace, you're probably in a scenario where ptrace
should either be blocked completely, or at least restricted to
mostly-read-only operations?

> The other thing - though not directly FOLL_FORCE related - is that
> process_vm_writev() isn't subject to any security restrictions other
> than seccomp filtering either.

It does go through mm_access() and ptrace_may_access() unless the
access is same-MM, so it can be blocked by LSMs like Yama.

