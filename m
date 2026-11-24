Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BBA606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jmN0r8uZ
Received: by kanga.kvack.org (Postfix)
	id 67C526B07B9; Tue, 24 Nov 2026 11:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F756B07BB; Tue, 24 Nov 2026 11:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C5B6B07BC; Tue, 24 Nov 2026 11:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9F46B07B9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:34:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FE3540C55
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:34:55 +0000 (UTC)
X-FDA: 85470561750.30.7A2A150
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F679A0013
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:34:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jmN0r8uZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795538093;
	b=sL4M6vHF43XoJW7vp+NP1UcdLQ0oNaWmWsUm8gSW//arIt2KwgUTCsWtL0qeHnaXdPctDu
	xbvYDMldpxGs33bAYEVqCT/VKAZv4KnWmKxFHjcA2OKBKiZ5Xb6fQZO2ZjH6JdLFCgKrEP
	xMFe0RcRFVE2eYHMzoQO+i5GTCs08mY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795538093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kl1lMLuqhZH+LLqHtJT6QI0oIm+dpJplZfZi0YBu//s=;
	b=2+LKi+Jjaq9v8GFWP9fVTmA3hcBd2Urwapkx2OIP1kdndTmySYszAGyVwvg/uV54FTRoOk
	/JlFVLcchdxMp4pvGpCKnDpyl9arVI8BXnOMafuzJTLCPw40m/okPfOXdOQ/g9CVMOGc5Q
	TUxERYLDuOxl4d8laS41pFDK/cuOa0M=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jmN0r8uZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-55be673e029so844911cf.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:34:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795538093; cv=none;
        d=google.com; s=arc-20260327;
        b=dr963EGRj2nm7RZqPs0ydr388ygoCrOIVqntTDzxTL8os9zDsGzHICqcZn3iYWlaUv
         QMOtRYNgS9ohOJb/66GSh5txurUuDbYPEW2SIsYedNAXeL5QWQb35k4xo1YSon5tUYsw
         ZqNVA7nkPoskc5Uir7+fjK1Jae7Wzb7uUxWFNZKV1jhnxufygiYIUG3gtHtiELGJ1FZv
         jcaR53xuy518JVZpnBY+LJswT1dXsSc813uekbGjHAOdGy5tdtTg83k6sbPDnQb9Y+Fx
         fUXD/TJ85InOmsVf6xtzEr4+LZnIACBAicvPNNOnGHmwQnUaIsJX30IYGdJvQkuMqklc
         AUbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kl1lMLuqhZH+LLqHtJT6QI0oIm+dpJplZfZi0YBu//s=;
        fh=ywJq5ot/O2vmTaCT4RAtRDrxBfZ9imhtkdDuF1I/coA=;
        b=bddcIvKjEpJ/PeNWJLtnhY8kNAFjukqkeezjEhvTD1HZcBY77NuSozEbl1d+qoZNsG
         P/+KubcWGOXGwLfvJg9Bu1qkog95fECtfqDvmK+FKj2lOiF+lYGycDjyeK2V/nac+9JB
         jbLSqDpfUFYVxdV2nGDckP2I8cc7fVKOCG2mqyWgOULKEWQWqaXSA9nlnYioiHcRGA9Y
         ZXelOV1PrUPBzsNmENzqr48AH+ixHRsBkDwUsJmb7VrjCbGeM6wUYPmnhuF7w441WxtF
         dyLv1OsRhZRj7CVRYqOt1uCOfSBs3OFN5d+S2SzEl0GNTDSFmiJLwooFiuhKcqkeduH/
         AVug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795538093; x=1796142893; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kl1lMLuqhZH+LLqHtJT6QI0oIm+dpJplZfZi0YBu//s=;
        b=jmN0r8uZiLmskOWJniWc6vKe/YwJBwkVRvpsBp6Sr/dCoaXWNcUrdEZreADlrpk0+Q
         pn/QLlm4aOboEpXNxU/FaFTEqjqajAgsGZj5+KRDBt4qd1dfW0V/B2FBEkSk5c8AiegQ
         vvA5zYKINunEynj54zfWugn9EgCxZgHxOuAQUGD21Z+ihLn4WK3FUhwyptkzZQWRf9mV
         FxmKZDfM/P68KV5c6rY9qd2i6Gw6PwQhoBN4jPwJRo6slU7D+BIbEVZkjwfWv+Yc/3By
         iwzADM90RpjFt23D2J1jIgk3CpBf5ZfsOUZjuNF/0VtLps0RV/CZBK6aCcwN3tiP2XjW
         JYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538093; x=1796142893;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kl1lMLuqhZH+LLqHtJT6QI0oIm+dpJplZfZi0YBu//s=;
        b=Uy4rkthAKnC7g2bI0fTkNpoOpuTkHhmhcfxk0jTX+FhNHTNPcOwbmZCZoh7Qx+VVeT
         o+pQBHnuABhz0o/BvpFG0BfpXIjMicgm67rrm2+lx1CbOqTc5GbqQ3xG1X5sj1xirTL3
         ccJRPCdQ/sj+WPgX5NGDJa6tibcZ9LE3FVTJ9zKxq70mzUkvEUc8UO84raxRFfr/t8lw
         yhoimImKbmw9u1n3sXdnglej0Dqvvej86/bAOPk014rkPGqSldQoR5rah6hiNur75DMO
         c0QVi8PfQZa1PylxTl8h7eQ75fWUT1zSX7/g30TWK8FneN2o1bsH/ItAjBYHd2qy/Bdg
         IQ8A==
X-Forwarded-Encrypted: i=1; AL+hErEBnJJ8aqhuk0rB/x01UKzZaPDvd9FvJEe0PwpFvWpiEupktA2bXG8tzTT5Le988lgqm41bC2jSjQ==@kvack.org
X-Gm-Message-State: APuU4Z916z3JRd2s335Fzqw1WZngNfPPy8/9QHAD8QvKQ5K70Wm6J/pu
	ZRXbJgWJJBF2EFfJLGIE6GAI0vRBGBnX8j3/cZFubGeX6tJNWElkmzA5KwQ076su9eCHnYtAx+j
	EoQduDoO3ioz82fwXt8k2I3n7uWNNRU+Y4Wcx61d6
X-Gm-Gg: AZFdTZcqKboEasMfZ/qsxXZzC1KEvv3pRLcVY/ANBa2X+BvNoBKGQAVz56aDqMkiJWJ
	VjL7o6oZaMCMOj8N7NoLex16L1REjng27mKE3kKoVvOAiOSGZ4ozdht8e5+qiTsf0cCcCagiiNi
	kNJnsdC5jYljXIWC/fbaA4EQeJ+TN+llwfcbfTJWonnvG5y4nG3ADnCwtQCO1VTzcuRmPlHapoe
	jd6wOS1emNxilbuRDOJosS0ooLvAWWtSG63WAJ8zMhFWO14T/wrv6Ucw8ZyHo90fx4bSZlcS3mJ
	CMVNVXxoJqP54VS6Pq+jUX4nhjNi1uVpb0mYktSHHDi3AJ+kR/6EqpgD+Zel3aijEcYO+/V7l3r
	hQMyHqj/jLPNai/nzuJcJklTfAbkHGgpTjwoF48QAcnnQuHCzYSwDebVu5G45iwBvygNkCJZypL
	KZN0rOOF1Y5CTnz3nFB+WQX/orLKo=
X-Received: by 2002:a05:622a:5c13:b0:535:30a:76c7 with SMTP id
 d75a77b69052e-55d88102d7dmr59797711cf.3.1795538092021; Tue, 24 Nov 2026
 08:34:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net> <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
 <awWz3nc_b8x3mIXq@gremlin> <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
In-Reply-To: <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Nov 2026 08:34:40 -0800
X-Gm-Features: Aa3M54psUndAWw1N5lTEQVLz0Ca1-n1kspbSD8lWK-ihjsexo1mFnquPILpy9Cs
Message-ID: <CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
To: Puranjay Mohan <puranjay12@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8ucwi6aahw9zj56azw5x196uihn7yhqb
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9F679A0013
X-Rspamd-Server: rspam03
X-HE-Tag: 1795538093-298725
X-HE-Meta: U2FsdGVkX184fjiBJeVHKi7Y3VJxj9YHbhQNRsQj2NwHSiU7IIHneLzisZJG9YOzJlFiGWUD3+Vpiu6M0gAPPuYB5jnmT0N6Yv5YHmNMLGByjdGxsEO/sBWO4H0gpVlm9d/0D4Lrj7MW/zAUqwEclxNddlgQQrZ2pVylCKA8mcloT+Pc4GcqsJ2dIFspFWpKYjKBTD2mhbxRA+awFEX1DuDnNua4fsxfbJlfJZ3j2nGSwXjn2ubWgX33rYm84eGBJSeZEQUlyI3V73CMaRF+/OjOEXBZ8mokD8lrdG1o8uhzNduqKEKGkceWx0+YrgaOkmfCCAmIPeNzJ9Z67/4Pa8ghFFnok/4sdxxmV8ZpXPwLHdcZPd0D8T9ig4vFcUhECjOZBPIWL2B0dG/ZuWayLrvCwgMd+dIna7vhHoo7x82X42KtgpI2B7LPwIXsumu1048hJtcx/KtqpN4OhfM36o1i+PzlY/QtzP3GMuUsIZUPcDdrv5+njEJkGKa92gDBS7avyIAynhwaPXtkVAYsftbBXR+Nn7U0hjPpxcd+jsfoZMRTZ+bM97AqIPUFJanSuLzW8R2cpBleQYdemTg/phTJHVHfM3nEiSUTVlm5bPzZJad+XF7U8ooemr4NLImUffN+U/fiirg7remLszFZkQTJsBaC1GzL57PQ7L1OuS8gMt19SjYVgX6/P/sUDrHRgEF7aYekoj6UryhYXHQyVTXMEve+QeiiyN4P2gPjPtCFU6604ovtTVCuyQYECpOqo05+W81SPLMHtoQuZuf9wwHl7iMNpXBE5yh/tsIrcVswsX6Xg7AL//tA2rcigel5jirK+Dgi62vMvYeR1f8oGN1mJ/pfpbX++1oC0e3CqjBR+vY07ml4F1CANLe7heE72t/jQa5t04IpAGVRyRfMm0jaeVKvr4gIZ7bOUmM0L/FLqm5Ci00Isk3oNDAuzD1w3IxGwdr6nNtG6encYXh
 UhFEQW3M
 19AfQ9hwJ6ErRUuhKIKncywdGFMNE/CNbN6THsA9mjGGYEgWEd1IXvZerm4zJtv3sV6KmZSVCh8G3PdTevUnN6H5bQEeewUI+Rl86SJ1wnf8JjpJoLNOGFlVKJeAQ0gzs732FgbcRV67ni56j4LRSgG7KOpDo/wiMvSCelK2RHEr8CyPxS0IJtydiPX21saS6zywF60FMJGTg0GcYCbAFRM2ldOVMScPCMe1g+6SFHHQbiTHmxHHpWb0BGfQ2POJpyPnEqrYHLdyDhjoNrLdlbhqd4DolG8lN2zBGybCXJ6LuTXFkITYpEz8uKKThjDYaU5VJgJOTxvkwZNpqrHBUo4bCkpAJtMa997q7w/A6oztkwlRx8k0imonPQb2/dfP9FsdYutuo7xNQGaIG1H4q2rfNRUxjnUOI6E+JHyMxfPX7785lcoyM1LLxWmnVud62uIvn1Mm6VFBgsO7nAhGI5lg7JuvfmvHCd/brGWNtAKWqX+ZA1UMjL+0EUst0sRFPAxMifFX+xA75VeeP7lM2dDOmmO0qZThTMPkJ7aigA6oK9MfoAvy9nIWAeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 8:06=E2=80=AFAM Puranjay Mohan <puranjay12@gmail.co=
m> wrote:
>
> On Tue, Nov 24, 2026 at 9:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel=
.org> wrote:
> >
> > On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
> > > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
> > > that RCU unlocking move you don't need other_mm copy and the comment
> > > that comes with it. VMA won't be freed until RCU lock is dropped.
> >
> > Yeah but they can be reassigned? They won't be _freed_ until a grace pe=
riod but
> > they can go back to the slab and then allocated elsewhere  right?
> >
>
> Yes, they can go back to the slab and become a different VMA.

Yeah, you are right about that. So, we either have to keep the RCU
unlock in place to keep other_mm comment valid (my personal
preference) or update the comment next to other_mm to explain the new
reason it is needed. Either way is fine with me.

