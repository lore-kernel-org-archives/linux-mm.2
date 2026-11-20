Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FFA606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dhsqP3S+
Received: by kanga.kvack.org (Postfix)
	id E20D26B05C6; Fri, 20 Nov 2026 08:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0D06B05C7; Fri, 20 Nov 2026 08:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99356B05C8; Fri, 20 Nov 2026 08:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8E96B05C6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:18:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35DA980F9B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:18:52 +0000 (UTC)
X-FDA: 85455552504.01.AAC82C2
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3753F14000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:18:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=dhsqP3S+;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180730;
	b=gVpTc/kxXAxRXTsmsyQ6ilumsq1nbShrpefJtVXu05fxjo0tXwW73nKFTOkYofiKGJykH3
	YJIpqnB3qzJR4z3Go+kFQjpg5rN4eKTcD4CslVcEE/Yf/k4Y+BbuY1sg/q83o53S5PKLOv
	/WPvXuqhJZcbpZN9fUYF9KO6/OOJGi0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAQTVNIYZ/0Tbx2obltQhn42YTPBHmmwY733kBIibzM=;
	b=QYY2dcnQ07FGRtxGw11npDdxTNUMuFej/Z+ixEiVMu1MOWVIP//Cea+pFw6ap9DlKEScy4
	fOODRDCbaW/3xHLJ+RuTE/Y9qdz5lEXD6KPXKm5IHNWW2vlv6HU7wUVz+WgcChUjlI0Xbx
	RGWivchwfKrhAgXtjfqpYpnoOmqOvIY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=dhsqP3S+;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c513a854320so160219666b.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795180728; x=1795785528; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YAQTVNIYZ/0Tbx2obltQhn42YTPBHmmwY733kBIibzM=;
        b=dhsqP3S+rpglvDaJOdEAjO1QE49cYVjdRvV+X+vaNkywSQOUZ9qNCPXtAu0/kEUcjW
         RPluhIB5KV0pQNSFP6VC5rVZKMwugfmwIYrw3M71wj+kV35HYEuk6u0hU6qlY1VYZY/P
         1WZs2NfZZZaVVy896RqRcIkq/VmwdcYeJ3lxRLmj9tFF19w10y2rKtat27fkbFfDxs0f
         Rnv59xEPAZi1thK8feEvpd9pRB1ePvvGWtgLQbOEFMihOpkbcamDOsTNBtasQshmezdp
         SMGzs08+LX+MC2AMlAYtQdcMgC2eMa8m4UMJsjxoWDdaYuDVVXt9LR/NoGFP2VPuynIC
         /Wrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180728; x=1795785528;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YAQTVNIYZ/0Tbx2obltQhn42YTPBHmmwY733kBIibzM=;
        b=jDzx4uGEsQh7W4GejAWs2AP4H9O6ICuWYaD3FQgxlXStedUN3Fa9GO+Phb4ZiRzR+n
         sQypmzf9K9T+udBgNg+DHNYw6OE3E+AEJMIoylWOuKAqMwyQXmf6XjrxvSToCE6Y3OM5
         4Pv+4o/uhAKdc7jcj5T9GVG7D9udqOgEHksqYPiu4Q2Vd6zHHJg9lT0YLPXW+S5UxNqY
         sdIH2Gh2vzD2F75+8RNvcq5PvLMojSMStipIkvzGA/K7qTf9XiM78plAORfcXAGO1CK5
         j6folLUwETpY2UPcUI8HU7KFGoqQQ5GcFFTgkqYKZe2gUPS6hrGDu6zypjh47UTChlV1
         CQ1w==
X-Forwarded-Encrypted: i=1; AL+hErH5uGivn35jOwH7TCwfUo0N6DvEOJlnrCxxnhyJSgK+29AQxwTlRIHcaI3aK1B1L/mleZV2jPGFyg==@kvack.org
X-Gm-Message-State: APuU4Z/Soj5f1Tq1yLUpoxn8maAGtI1o+zpcqfbgboQWH+EPUCpBYpwO
	Gmi+mSFjn8dJgpoufxZP+wjAk1dO28JQEApkiGHEroxTvUqW5GkePYzArn7+u76inV9u
X-Gm-Gg: AYBFou1TexOULH/3H8sGOTTA5DwvfyEnJ0GGBeVi0O8a5N3pdRM5LcL2qxtLkDQWY/S
	pp2VIEjfYlEUY1t4q5HVwT/dLtoNPhs5V7pdLm4M5gkzBWr6MUalfFZpXTh+1HupTE8AdoedMEL
	oSaPuXrUbYyD4lcf6+7lB/fC4Ql4mP+JVXvtwYJY2Ovby7U6Q03Bizjsrqa/ghhTdAT6kIqvBCU
	CBEZkywesjyex4lT5PdePPD2t9/XYfCohaF6pShrGhbrdLYYeDwoqWFWWelrfMPXdngkrz++Uqc
	9X2lkF5dL7a4XEiGkWz1HkwyehWon6uSgcI3ZkB5WPx0ru/KUzMZtBix8zpaevHmz/m61AYFCk+
	SLJlbDH4NKbsWoAlx21+P3r1+o8fqgomCSi+hEI4dlq9rEIyYAd/7xNlRU8dSV0cTc9GawFuT6Y
	hO/ydW9TbIklG05FVxLl+pgoUQADwXnBY9VBSIo1gK3Lbei35OG62agqD710UZPVlO7NypD7Wus
	nkoTajo52z85dkg9xOTJ7dPpl3crEH8gKJjBYDfroIXs5petCm4rkq9OBUV+3nmaVaKI6FFuiHB
	gaVHVhwg6vRGATrBaksbDK9EqTiWMxfl/2oTpfvOgR540CIbr3952rS3wWLjeplNQQ==
X-Received: by 2002:a17:907:a890:b0:c41:55b4:d88b with SMTP id a640c23a62f3a-c513ab14402mr338807466b.43.1795180728386;
        Fri, 20 Nov 2026 05:18:48 -0800 (PST)
Received: from [10.0.0.233] (tmo-084-188.customers.d1-online.com. [80.187.84.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513acfe3b0sm93731066b.8.2026.11.20.05.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:18:47 -0800 (PST)
Message-ID: <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
Subject: Re: [RFC PATCH v4 03/14] rootns: Track init lifecycle via
 copy_process() and pid_namespace
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,  Andreas
 Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski	 <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
 Anna-Maria Behnsen	 <anna-maria@linutronix.de>, Arnd Bergmann
 <arnd@arndb.de>, Ben Segall	 <bsegall@google.com>, Borislav Petkov
 <bp@alien8.de>, Casey Schaufler	 <casey@schaufler-ca.com>, Catalin Marinas
 <catalin.marinas@arm.com>,  Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 "Christophe Leroy (CS GROUP)"	 <chleroy@kernel.org>, Chris Zankel
 <chris@zankel.net>, Dave Hansen	 <dave.hansen@linux.intel.com>, David
 Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>,
 Davidlohr Bueso <dave@stgolabs.net>, "David S. Miller"	
 <davem@davemloft.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Frederic Weisbecker <frederic@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, "Hallgrimur H. Gunnarsson"	 <halg@google.com>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller	 <deller@gmx.de>, "H.
 Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Jan Kara
 <jack@suse.cz>, John Johansen	 <john.johansen@canonical.com>, John Paul
 Adrian Glaubitz	 <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
 <corbet@lwn.net>, Josef Bacik	 <josef@toxicpanda.com>, Juri Lelli
 <juri.lelli@redhat.com>, Kees Cook	 <kees@kernel.org>, K Prateek Nayak
 <kprateek.nayak@amd.com>, "Liam R. Howlett"	 <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Madhavan Srinivasan	 <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Manfred Spraul	
 <manfred@colorfullife.com>, Mark Rutland <mark.rutland@arm.com>, Matt
 Turner	 <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, Mel Gorman
	 <mgorman@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko	
 <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, Mike Rapoport	
 <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, Nicholas Piggin	
 <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Moore	
 <paul@paul-moore.com>, Paul Walmsley <pjw@kernel.org>, Pavel Tikhomirov	
 <ptikhomirov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, Randy
 Dunlap <rdunlap@infradead.org>, Richard Henderson
 <richard.henderson@linaro.org>, Rich Felker	 <dalias@libc.org>, "Ritesh
 Harjani (IBM)" <ritesh.list@gmail.com>, Russell King	
 <linux@armlinux.org.uk>, Serge Hallyn <sergeh@kernel.org>, Shrikanth Hegde	
 <sshegde@linux.ibm.com>, Shuah Khan <skhan@linuxfoundation.org>, Steven
 Rostedt	 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Sven Schnelle	 <svens@linux.ibm.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>,  Thomas Gleixner	 <tglx@kernel.org>, Valentin
 Schneider <vschneid@redhat.com>, Vasily Gorbik	 <gor@linux.ibm.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Vlastimil Babka <vbabka@kernel.org>, Will
 Deacon	 <will@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Date: Fri, 20 Nov 2026 14:18:43 +0100
In-Reply-To: <20261119224312.1037966-4-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
	 <20261119224312.1037966-4-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kqcbrx6dr7ondwea5pk74irhhzihbouc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3753F14000C
X-HE-Tag: 1795180730-738647
X-HE-Meta: U2FsdGVkX19Dx2c8Bx2yapns044QMKIos3rDJ7TfHv0DUvzu4nBD8iGlYIXVZ3PJubLZPZPXApB45OAaRRhbI3K5HwiMP65lWkWx2HEo/K1UXvA5Gf8EugqQuXkvFlYyYFAsLVpRZ61P8tVxBPOKY+WsPVZInKdNsqJtWQBC9atrFSNlEbhuhDGwCTZ+joYmgYriOiDSDzmTOZ8+dgb/Y36RvZoBJcYj6hj/+jGSmnRG4kWVbNxnrL60Cx0OPvgbvmbACyZQvz8kmj5V3gXDC+jWE8stUcdKxDooLITPsrEp+9WF32xUTyoe5A6ji+TUyUSZibjwd1tx/HpN5Jumfbp5WzxSciwa0m1JUHjkyPAbB5N0I9cxjCUJYpESRPe2Ogu1ggi+QUX8Grt1OIhdruEFbTB2UQLMtpX/UY3siOQAK6lV2sQSXHS+cY/WTP1PSvB1yYpKtNqWgBLkFIk34cjQlKVwA2GOagjoGXoMMve2B8JqRCvoLK4+AWdnuke6bGAroFS7NQIQDGUVhyfIwgVyv35vop1wmiJcOIurUfopD/a9tJYhLrju730dgZW2l97zmrHWigq1MXSd56Y7ZOL9TCv/DvWue25Au+ccSIIiKkb8x+w6nW/zZezGY6DeMcJSeDg/e5gJeodd0UvINz+9lMDwZ8RFa9DVMNtgHguu/b+HtHeb/M015EBSrpCBhnElIct4xkPn69wcbesk17Ho/sx8htQ1xJtxA+a+RQtImt3z47/VGfV996Upu54YVqT7kGL8PLJfv+HUTZwl9cIaWKviFcoHH9qm3n2bSlt3nEG8cyWNiX+fO23dE+/fCBpAxaFbNhY3GcGQbxJgoUtCf7CmM09UtxaJzUp+ApiI0utuGcqcdGXq4XyhoN2XGbgg78TgDVlI/ZhLfbfBIgDWZ6yRUma5wuj3BlTHXS+ZOtE3ReWPGPxzfTWRd9ZqGsWy5GH48lPMo52dqeQ
 I4u3jLz0
 WUn2geeADX0kb4idICTBB38rrTer0Qx9gL8Dcj8joUTFXVwdX1gc51lvOexc59aBMFmU+B/V80cy7Lx//S9bR0n4XfsklO0ubP4llY955EoxDK2bnF3MYwbJ4ukmJAXAO74SO0mtl2PS3tA3p4QqRaM8hiFY8U1GTtC8Hh+zWM0e33ZdjALWIVvFkvSdupRH5ZPUQUGzA50aDfqxC7DrhjS8QUDSAn++w3XPyWZoJgchEgZmX6iPoWQTDRY1lXU/aAspuP2+dwpEJBTHiBLsQq65PBMuSnEvSl8+xkn8mfjRCCBTlZiVoUvIj4Tq7i5Oy4cLn6Pp+HRcRmUFxeyTyZh0rOM8Vt8Dqq7MX6ewHFrvpdqrmClOZkA5staGCDmBbumP1s9q7lJ1AB2yExWKyyrpM8G0keGb/7dxh82hg94wBpsnxQS7AHx4tnwvjdGBI7cYsJasKnLTf42eFfjg8sYI3YOazt7drhGISVwtjL9b9fS4ehonn5jEKMJaDkiYPgfmLKfHL3RP6j+wjc5T5rOa4Z8tiygQ/xK/XsTYWcco7wGfHBw0rB8IZPEuIpp1X6JdgPOGvXEvnJR1nYq93VV7sRquCg/Tz6Vwd1fyAF3Xw6TILsfiJIEb8g6k1g5LoExG42/mZdnPy9FHb8ezKvs0lz+4ShV534Vrm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-20 at 00:43 +0200, Jarkko Sakkinen wrote:
> A root namespace needs to record its init thread group's PID when
> bootstrapped and capture its exit status once all processes in the
> root
> namespace have terminated, without serializing normal fork() and
> exit()
> paths inside the container.
>=20
> Commit the bootstrap child reaper, bind pid_ns->rootns, and wake
> waiters
> in copy_rootns() after attach_pid(PIDTYPE_PID), and invoke
> exit_rootns()
> from zap_pid_ns_processes() after the root namespace's PID namespace
> has
> killed and reaped all member tasks.
>=20
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> =C2=A0include/linux/pid_namespace.h |=C2=A0 4 ++++
> =C2=A0include/linux/rootns.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
15 ++++++++++++++
> =C2=A0kernel/fork.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +++
> =C2=A0kernel/pid_namespace.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 2 ++
> =C2=A0kernel/rootns.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 38
> +++++++++++++++++++++++++++++++++++
> =C2=A05 files changed, 62 insertions(+)
>=20
> diff --git a/include/linux/pid_namespace.h
> b/include/linux/pid_namespace.h
> index b20baaa7e62b..6fd959f4d0d4 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -15,6 +15,7 @@
> =C2=A0#define MAX_PID_NS_LEVEL 32
> =C2=A0
> =C2=A0struct fs_pin;
> +struct rootns;
> =C2=A0
> =C2=A0#if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
> =C2=A0/* modes for vm.memfd_noexec sysctl */
> @@ -45,6 +46,9 @@ struct pid_namespace {
> =C2=A0	struct user_namespace *user_ns;
> =C2=A0	struct ucounts *ucounts;
> =C2=A0	int reboot;	/* group exit code if this pidns was
> rebooted */
> +#ifdef CONFIG_ROOTNS
> +	struct rootns *rootns;
> +#endif
> =C2=A0	struct ns_common ns;
> =C2=A0	struct work_struct	work;
> =C2=A0} __randomize_layout;
> diff --git a/include/linux/rootns.h b/include/linux/rootns.h
> index 3f59415efadb..0557ce75195d 100644
> --- a/include/linux/rootns.h
> +++ b/include/linux/rootns.h
> @@ -13,6 +13,8 @@
> =C2=A0struct file;
> =C2=A0struct nsproxy;
> =C2=A0struct pid;
> +struct pid_namespace;
> +struct task_struct;
> =C2=A0struct user_namespace;
> =C2=A0
> =C2=A0enum rootns_state {
> @@ -41,6 +43,9 @@ struct rootns {
> =C2=A0struct rootns *get_rootns(struct rootns *c);
> =C2=A0void put_rootns(struct rootns *c);
> =C2=A0bool is_rootns_file(struct file *file);
> +void copy_rootns(struct task_struct *tsk, struct pid *pid,
> +		 struct rootns *rootns);
> +void exit_rootns(struct pid_namespace *pid_ns, struct task_struct
> *tsk);
> =C2=A0#else
> =C2=A0static inline struct rootns *get_rootns(struct rootns *c)
> =C2=A0{
> @@ -55,6 +60,16 @@ static inline bool is_rootns_file(struct file
> *file)
> =C2=A0{
> =C2=A0	return false;
> =C2=A0}
> +
> +static inline void copy_rootns(struct task_struct *tsk, struct pid
> *pid,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct rootns *rootns)
> +{
> +}
> +
> +static inline void exit_rootns(struct pid_namespace *pid_ns,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct task_struct *tsk)
> +{
> +}
> =C2=A0#endif /* CONFIG_ROOTNS */
> =C2=A0
> =C2=A0#endif /* _LINUX_ROOTNS_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a7..08fc28ad1eed 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -83,6 +83,7 @@
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/perf_event.h>
> +#include <linux/rootns.h>
> =C2=A0#include <linux/posix-timers.h>
> =C2=A0#include <linux/user-return-notifier.h>
> =C2=A0#include <linux/oom.h>
> @@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct
> *copy_process(
> =C2=A0					=C2=A0 &p->signal->thread_head);
> =C2=A0		}
> =C2=A0		attach_pid(p, PIDTYPE_PID);
> +		if (thread_group_leader(p))
> +			copy_rootns(p, pid, NULL);
> =C2=A0		nr_threads++;
> =C2=A0	}
> =C2=A0	total_forks++;
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 127a5fd23e70..081c27aa85bd 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -24,6 +24,7 @@
> =C2=A0#include <linux/sched/signal.h>
> =C2=A0#include <linux/idr.h>
> =C2=A0#include <linux/nstree.h>
> +#include <linux/rootns.h>
> =C2=A0#include <uapi/linux/wait.h>
> =C2=A0#include "pid_sysctl.h"
> =C2=A0
> @@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace
> *pid_ns)
> =C2=A0		current->signal->group_exit_code =3D pid_ns->reboot;
> =C2=A0

Dear Jarkko,

> =C2=A0	acct_exit_ns(pid_ns);
> +	exit_rootns(pid_ns, me);

We have a very similar mechanism around pidfd's to track exit
information for a task. As far as I can see we already have (struct
rootns *)->init_pid reference, so we can get exit information for free
(look for PIDFD_INFO_EXIT).

Kind regards,
Alex

> =C2=A0	return;
> =C2=A0}
> =C2=A0
> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 3bbf7677080e..bde7cf4baebe 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -183,3 +183,41 @@ bool is_rootns_file(struct file *file)
> =C2=A0{
> =C2=A0	return file->f_op =3D=3D &rootns_fops;
> =C2=A0}
> +
> +void copy_rootns(struct task_struct *tsk, struct pid *pid, struct
> rootns *c)
> +{
> +	if (likely(!c || !is_child_reaper(pid)))
> +		return;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		if (c->state !=3D ROOTNS_FORKING)
> +			return;
> +		ns_of_pid(pid)->rootns =3D get_rootns(c);
> +		WRITE_ONCE(c->init_pid, get_pid(pid));
> +		WRITE_ONCE(c->state, ROOTNS_RUNNING);
> +	}
> +	wake_up_all(&c->waitq);
> +}
> +
> +void exit_rootns(struct pid_namespace *pid_ns, struct task_struct
> *tsk)
> +{
> +	struct rootns *c =3D pid_ns->rootns;
> +	struct task_struct *leader;
> +	int status;
> +
> +	if (!c)
> +		return;
> +
> +	leader =3D tsk->group_leader;
> +	status =3D (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
> +		 tsk->signal->group_exit_code : leader->exit_code;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		c->exit_code =3D status;
> +		WRITE_ONCE(c->state, ROOTNS_DEAD);
> +	}
> +
> +	pid_ns->rootns =3D NULL;
> +	wake_up_poll(&c->waitq, EPOLLHUP);
> +	put_rootns(c);
> +}

