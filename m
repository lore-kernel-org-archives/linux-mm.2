Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A1B4D1039A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FCD6B0008; Wed, 26 Nov 2025 05:02:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06E96B0027; Wed, 26 Nov 2025 05:02:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CFC6B0028; Wed, 26 Nov 2025 05:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0CCB6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:02:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5831659272
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:02:00 +0000 (UTC)
X-FDA: 84152317200.24.34CC9E8
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 578A5180018
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:01:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=keZnNluA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764151318; a=rsa-sha256;
	cv=none;
	b=qdgux3WQRXS3bWHizjT9T2z0LJnlTo6v+TGRTGF45+5lnoLPToPVsam4fa35uula8DycFQ
	f8+phpb15y460nCPi5i3+/L2WJa4JdTIg40lycKGCwB5T7hsn7EI51bShTdS7AkvU55ZYx
	VJeC5FEO+d5/FuCzyc70KxNqRcJ7A0Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=keZnNluA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764151318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCfP9+1PjtPdWHfJ2FqP8KEugCsUMEGuFrLDP1hHIGk=;
	b=R433yCs+o4JENUbkZSAPqfBluMOj8fsLL6WwwlY/F157a+H6vK9C7xUHg0TsDZoMJSJw8s
	7PzJqGStsoeL0akvJE/ry4nqDtjfRqf0ymjQnQ7WKxwFLVJvc1gcf+wHrEBjJukjDgOwkM
	PSl0n1fmx8wywI9EILoMPzTLiC8u8j0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so11579395a12.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764151317; x=1764756117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCfP9+1PjtPdWHfJ2FqP8KEugCsUMEGuFrLDP1hHIGk=;
        b=keZnNluAVasmQkW2ajOHXP7OckXRs2NqrGdydpykU49xyXvKHb3T44R8z+JGoXdazD
         hKivWSqetzg4ITUU2fThSRO2BmsiCsNhqVaHr6zznCBolTcaqXEhiINcKB2uGzPGrKgR
         7YOpZQbAlbU52dEu0U4goqTPPjmKGRmRfHshUZwqzQSLxKsWO5hxMuy+uQNKw+hYCHsn
         KXzSWqEVpu9YrBTxnC7j2+5WWi/31InHBN3dzbpQ9ogCt4OkuHczQAjvSdiQE3C9TWXl
         UIeREQ6nrMRUWqKa8JEcFyC24TkF5sNicu/pz+vvWIb0vGItiZlnx2GK5dqegOr8ZxqC
         m1sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764151317; x=1764756117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DCfP9+1PjtPdWHfJ2FqP8KEugCsUMEGuFrLDP1hHIGk=;
        b=gHb69KMavJlCzY4UOyViPh5ycmmudjytkFatkiOlQMD0rtDQBtfSSKuzdUTJHmkXk6
         eb2PTCUbTImEzBBzOWe9LiOKENwNrlx8B/FEUGrzLfqTiCLQ9icEue4ZtoegeWeF0Tkk
         Kp9NNTmx6g0lUQwv9O9Z5H5CYhcINw1giIfAKaFTtecl5bkQQpCGTr11S2ZwWjS1YuiK
         w/9KpQZylMSuw3De7ZViMEdn9ce6xVhkhWVJXcVcpIdqjWfZ93hNjkq96OnrX1x+E1ZJ
         p+08MdoyshEKDLkXBLvfSxX5UQuMbdaF+oZXMbF3dbHM7fxU2wtAAddvXW98R8IBr3i8
         +7GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFrAMWMGSvsLSpxgHmUxTWfEiug8XX6wTo6btgzmJrycI9ufufMgFxQg2pYjGB//Hfs7FWESE9aQ==@kvack.org
X-Gm-Message-State: AOJu0Ywsi0psUJasXGZy6KQPW44bd9OjGnALtny1l233gNJ182Djj+re
	Rwb7s/UTERcMBY0+m1+aIpfnI6th34cfcaiKYgRIIi75ZnEWniaqSeABXb2sUQz+VxwLsuBojst
	JfMyHXL340kHhPW+WxmlCm2Cfd3aIcvE=
X-Gm-Gg: ASbGnctIUUqfjy9O5AFusqYUG8/Vl4C3p3AqPeIxi2yhN8blrWIRRRuPXODgELbpqWj
	C6U5uSc/jUsQM4QR+hJFzlCrNmxbyYDqst3itleh3dga9OkIyY4b4NcpmTh3O7MtdwMvciSqMVg
	rjO2jBl19qxLiBLWXosG8b7GkYMAlW6OnYu5RwLdhwuk6LvfRDLkRq3f6/aRYIXUAN46D1P3qgp
	BmE6DjWUxD1RMTHfdIzt1f8KXH8d+nQM9CkgNM6TrDBETcU+jPr+f5a35fumq3MldlqNk91JKQs
	Nvpv0FYoEjYxcfrMPRhAYwOWWpQtFqbKrk8B
X-Google-Smtp-Source: AGHT+IFZQa+b+MrngZDH8uiYIYJDguj8VY5gwboLSleum4scvA1fnIscdrJ3dUX3JVa6DKHezHNeIf53qbc7t2zpNbk=
X-Received: by 2002:a05:6402:2106:b0:640:ea4b:6a87 with SMTP id
 4fb4d7f45d1cf-645eb7858b2mr5639449a12.30.1764151316489; Wed, 26 Nov 2025
 02:01:56 -0800 (PST)
MIME-Version: 1.0
References: <20251121202352.494700-1-ankur.a.arora@oracle.com> <20251121202352.494700-5-ankur.a.arora@oracle.com>
In-Reply-To: <20251121202352.494700-5-ankur.a.arora@oracle.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 26 Nov 2025 11:01:43 +0100
X-Gm-Features: AWmQ_bkfm8M98iWu5ZHGWUM7R5WD2CP3Yc-PE91nMKG5sXwMyHJOOgltALfvnrU
Message-ID: <CAGudoHFgDEEBgQK5PrEUAJsb=iFpsT5OJ8+7W8PV0CGNePR4JQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/7] x86/mm: Simplify clear_page_*
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, willy@infradead.org, 
	raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 578A5180018
X-Stat-Signature: b7apjxtukjpje88dhbqi1pgycer9shhk
X-Rspam-User: 
X-HE-Tag: 1764151318-941920
X-HE-Meta: U2FsdGVkX1/CX34n4Sq/+ii1leumOgg+HYtdmyRGvyzptIrNb3H470JOkrhkAl5gwRoyyXRYT0kqLxhbAhOZlO6VJCpF+iSTPB74KANoS55/fA5kHZdy03BNRcAL6HhQE3AWY7cqtLrFO0bjifx7H+fgArKyp/AyVejytrfixJHEmPwSx3TSMsnjbVNkjWp86GR9khsXFHdWR04IIg6ayVJAzmfagEoI0/1JApj2xefC1oq4EtkElSBsgg5n9Ldld4oDELCwo0EBTXbDb69eg39ZHju6b7meQbDrLipKRl6tomleiUDMAl6Ab1hIDxnoaWCgdN/qDJvFiVZRfrqZ7SuK41VJCexYgo0VKBG8VC3BGsx9xGleabcHbqNzG2hu7h4SzUeOpcPSqA6jZu5mfsOXTmLniiLaM87/ki2mjZA9AdBGCO2TUw4CdKSZYTpErfNtE5RuN+sVxykOL+ZEJ6PGQ69ye820NlxVa0d9kcU+kcX8nRCz2S62/wQlUBrdEGU42eghhDMiiFDeKrFmxmSq+ZWXTigjbXjhGyKn0VD8uKTs/hR2pIGSuHes8QwbaSgl6ybVQoF4JZymj/3ku/Zw4vwNYfmRwBLzEi2OPUvD0wVa5+fGzyzljSjYlAZzsQTD7qhjFRCv9DCcJafjy2zlX20D//SUgG7IOVNFqqUZwFobwtSBJmX626/YIkr4OjTnIrLhA8sc3ZsVsluvyuTjItvOVW7kChaY9/B24FvlG8ja11VroBKZjfzgdfTW9r1APmiZnzVYSyYjTfM8mvFruFO4PRuAJHeujz+OLsuASv67KApnOh1sF4IpRG/TgdJK4MfM6aJNJZNRbijIz/0mWDGDFAm5fsugwbKvZ7nvxMmPuSwQ3HHk0GK6P42X5WY6t22XD2+GaOaOrDekkWRltvNiZ2q6DE6H+Qm91RiXeumeUgwYeXXkkYXX6/ypXlcEIv/v4G19xfWZosl
 RU/ZsDLa
 YocQpn9SvWtRZRbVtNgqT9+g6VN+ywYm5N8C+jsuaWESJ6OuKdN569PxNurOywYGPVYqTzOqgX+r+9JFX3UEWp/7Xx5WboRWN7TMJlXvtybFWq2nEspY9Um0QJWJGb8TxfBe97n5A1cClPI+2/2eYA+f0vnmnXZ4lATghQ2iUIsLe/kXcWVgg5MTiposU92tKd0aEGKIKPDGaePX52GW3nIAixYWeCGwA9Y/AhYWQzSkYsuBqsAvAigSBS8HzreBNbY7Z4cDJjUEjdw/lf8HA1Pw8vRgyhBi3b0Ct7Tifr/+jnhvNovu9/3x0qzhzgWZAcoSAhAZPpDAKLjp8xxdZmVr1RVyQkCqqQJXpNizDs06dwI/6FuHe0rxLiJBgWOKn9I6VJRjxKj60ZxoJM4e6+GsSgZ7miyyLlnuc830eI9wetvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 9:24=E2=80=AFPM Ankur Arora <ankur.a.arora@oracle.c=
om> wrote:
> + * Switch between three implementations of page clearing based on CPU
> + * capabilities:
> + *
> + *  - __clear_pages_unrolled(): the oldest, slowest and universally
> + *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
> + *    to write a 64-byte cacheline in each loop iteration.
> + *
> + *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
> + *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
> + *    trusted. The instruction writes 8-byte per REP iteration but
> + *    CPUs can internally batch these together and do larger writes.
> + *
> + *  - "REP; STOSB": CPUs that enumerate 'ERMS' have an improved STOS
> + *    implementation that is less picky about alignment and where
> + *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
> + *    at a time.)
> + *

I think this is somewhat odd commentary in this context.

Note about "crummy REP implementations" should be in description of
__clear_pages_unrolled as it justifies its existence (I think the
routine would be best whacked btw, but I'm not going to argue about it
in this thread).
Description of STOSQ notes the CPU can do more than 8 bytes at a time,
while description of STOSB claim does not make such a clarification.
At the same time the note about less picky about alignment makes no
significance in the context of page clearing as they are, well, page
aligned.

There is a fucky real-world problem with ERMS worth noting: there are
hypervisor setups out there which *hide* the bit by default (no
really, see Proxmox for example -- you get a bare bones pre-ERMS
cpuid)

With all this in mind, modulo poor grammar on my end, I would suggest
something like this:

<quote>
There are 3 variants implemented:
- REP; STOSB: used if the CPU supports "Enhanced REP MOVSB/STOSB" (aka
ERMS), which is true for majority of microarchitectures today
- REP; STOSQ: fallback if the ERMS bit is not present
- __clear_pages_unrolled: code for CPUs which are determined to have
poor REP support, only concerns long obsolete uarchs.

Warnings: some hypervisors are configured to expose a very limited set
of capabilites in the guest, fitering out ERMS even if present. As
such the STOSQ variant is still in active use on some setups even when
hardware does not need it.
</quote>

