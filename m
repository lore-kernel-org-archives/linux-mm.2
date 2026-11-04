Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC58606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=MhrkgDaA
Received: by kanga.kvack.org (Postfix)
	id 575C36B00EF; Wed,  4 Nov 2026 03:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F046B05B1; Wed,  4 Nov 2026 03:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465006B05BA; Wed,  4 Nov 2026 03:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 130396B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:26:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B08F1C2263
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:26:56 +0000 (UTC)
X-FDA: 85396756032.16.721F4F1
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA58A40002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:26:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=MhrkgDaA;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793780814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+vnesPE4t9lKIynjQF/EgK23seabQisbWfdICSw+rI=;
	b=a6ebDSGWpXyVP4Fj+2h4V0mANSRNyP5x5l1TDeizmVfMhSmUS+zpgYxL4izlpbZ8jn9uni
	zbRVv8TTI87M8JFPSjGaT+ffmdC2hyQ6PiY8DQRiBXse+tO71NPldlMgZ2jSevVOqKW+gt
	3CRUt97IdtI+ryNXY7pQKzB7kPQSDoQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793780814;
	b=MvwGOIAIZDyxvRun68a4uNhX6GUlBIQmvl00f4Yv6oiE2Audoth2tDz5MfaNFakGm+SpPW
	DRQSGY3Eiwm5P8dMHtJ1Eit9VFSDXMrFYwKD/j5503dUiHIaBdEFe77zSJIeobzxNbTdpM
	cWq47Otnj2ZPNrkFlKprXvPFSadbSIs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=MhrkgDaA;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b4b7dee316so368529a12.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 00:26:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793780812; cv=none;
        d=google.com; s=arc-20260327;
        b=bfX5S12Q3HIAluv7Q6qIl0jmlB7rrRmtHmwv9KsDI/D0NvYlGJ+31HrINAscLiX/Cy
         oZkV1GFgOVKTj/KY+zbClw0sqKsyGyg40t6mYEN12MFxwnaXNBeBozT74MORCmzr+xMQ
         NlyoPuxMKp9vAslvGa/ZI0AxH8Kq18ssUbJLYcxTuL3caAiPBlrdAdARSN371gQ883DD
         wytu5A7tBAPaG/71N8/0cRXMFB33NMe6y8/D9cRbtXXMeQ0eiRE4bWvmDMlBv7upw6vn
         KkbYVGh/uORVT53FjpKMvQFOHiAQEDx9heVyq6kTviyFQLTcy5aIdMYFYpE7RMGNTOke
         oYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D+vnesPE4t9lKIynjQF/EgK23seabQisbWfdICSw+rI=;
        fh=1I0VtgOqOEC9YfLSe5lg2FDVHALK+RFykLW1q3+zx8o=;
        b=PspbMIf9HNItY8vqFXgqxaUpPtJFqJzCMa33Re4FueDsUDeMbdrSdDVH/JMaHfhqJx
         GdbPXu4cv5zvunH4ynTa3SF6cRvjuEGCrj59XFwIXTZbiNB76IGvCRaizT/F1Ltmxozg
         G454kMidQfJwJitGL+3p1xuM7F2Jv688KuAB2S1Whgb+ZhJBcJjsnopgBAuISkc9wj8W
         O6b5VdmzP2qLPzvClWXpEvJhjo/0bzqwpEdDwyRu3sLhyT89Ms6DKzM9WMFtFvBbnX/S
         anlUViyI+kMGwKJEdAERzeicnOaB5ef2g2t2e0VTIIpvy7juHOpjxYCBN7B5fWgR1hy0
         UdMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793780812; x=1794385612; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D+vnesPE4t9lKIynjQF/EgK23seabQisbWfdICSw+rI=;
        b=MhrkgDaALVjwUxtZMi7eQdORXPmxeNzwaDYzAJTh8hJfa/414qfr9Bd6mGXj/mwzgE
         J//SRVW9DOOkUPf/pAdDggTDaZ9+Aua1yCunHDdcVZOPcEp0wF4a8ekSvEZiXWZ9nPXK
         brjw7CfajQ/KWUWu76VO9bnonfoYHluPTPFYXUt6CpznLtnuTIDmA5CoDa5F64vrj0ci
         1y1i3iCZrb2MeOB5mdKTv+h1mxObioHHDbx9GRj/G9eCTxn4O0I53oi8K6t7AtuAP019
         1buVxMNTBkV9PXohCdRP4SMZtKGAgFlne+mxn1OQb1XhGVbZ5JVhoFe6JAQV2V7xqa8j
         cBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793780812; x=1794385612;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D+vnesPE4t9lKIynjQF/EgK23seabQisbWfdICSw+rI=;
        b=UZF3UHTeUz5/kb0lamPfQ6XmiKLAGQqbBdTnzveL2TW1SAu8Ii1KfkxhlGwMeRHe93
         rQZLBJ30DKSl1+LOKEdVeh7kJ4Eu6CinQfDEgJCeAhoXZ652H4bs17YIvbg0/YN/Mxpn
         fC1wINT/W3g3xFEYgo1oMMrU6VFt38wbRL8qqeksyA3/6ijGIXYIEN7ASVMNs+nCqljI
         gsT1cy18hXQSeD4lEglT4P6RMaB4CTJCNSW16WSkPKtD121iBgbWQeHYnwPhle1B32an
         caLHNqRhfoVtejCcCsYDR+lHyLSn5iatLD5OvCPmQiMtDQYga/yFJ1LA71h07bhAStXE
         N/FQ==
X-Forwarded-Encrypted: i=1; AKwUvByveK9i7mw9nqm4ubAT5T4ZTfKNtyqoAPGsa9dEaxIB/GOQ5T0+CEC5pxzDXQ3kMdq5kfepNIKqww==@kvack.org
X-Gm-Message-State: APuU4Z/Y2U3a1m9/E5LJ8NkE3RbEgBxGGjFLZo3EHTduMmpNOoA7ElXd
	hW9I8ys2kMSyACoMaTkaOhvac0bk35RXLcCxbxNP2vjfLsSmVPV6wqzfk/rWZGBgUmyzTBwEHa/
	6k3D648F6bTupdhFXgYoTfPwZOMl1d4DZ7ZGXFeFA3w==
X-Gm-Gg: AYBFou3TPDftaGQFfKS8MKrnBFw/DgGuqP+4BOGefJi0BMbEYwl1lHEL9x9jGcZPSnh
	Yzg8hSegn2wKOCm8XSbvDZWIls4o7G5KLCRjRyz6hd3h/syhglP6YpD5Gjc62LCTfrjg4gcZgy9
	COaQTmi3zh8J7DpSCxY8crlCEw5U+XHSXtGWI0BsNC1tXfraEosMeuHnAFbrMSwqtxNDDwPtTj/
	bzrCu1Pw4x3YxZGXzs74dLOvy/FU6qXKxCf690iZyVCj6cfSLegsy2hpJyKBsduUaWGajdnFhXr
	lt83YQ8t68rhk3j2PqOHcX4SfYXF05dDA1r7CF5AinundkKFstFm7TqRBYzgeZvSaqFGdIwQQt3
	A3jJV1jomlu06WaEDRSH3X9w9QgYDAA2oeKJXyxN33SwxQebK4Hvpw1K0EZ5eGuc/pQ==
X-Received: by 2002:a17:906:9f8a:b0:c3e:4f41:e2a6 with SMTP id
 a640c23a62f3a-c4ca7974a58mr1321997366b.6.1793780812002; Wed, 04 Nov 2026
 00:26:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-5-max.kellermann@ionos.com> <CAGsJ_4wpd-e+xjm5KwihVziAeVnQp3XYG=+-BKmx0SVEhmyqqw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wpd-e+xjm5KwihVziAeVnQp3XYG=+-BKmx0SVEhmyqqw@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 4 Nov 2026 09:26:41 +0100
X-Gm-Features: AclHuK-KpECaTGoo8CunTP9HlWbpvRsPjMgrhDBxpI0Zzac6pPc7vrwid4sHOVo
Message-ID: <CAKPOu+9textOydxZYng=Bo9Sf91Wq_7rv5r2pBrhXOfiex=qGA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jjjh3epxas8w8633p15mccrcate9da6j
X-Rspamd-Queue-Id: BA58A40002
X-Rspam-User: 
X-HE-Tag: 1793780813-347527
X-HE-Meta: U2FsdGVkX1+OMnfiiGUVHSDeFOJ9f6cjDFS/lYAkVx7dv+mUeqDlYzO47U5rxh/bz04+8ei+h6F3jly7veZ/9910tjsn5B/o5eSy3MnRQED5DVg02kTLiMsT2J+cCbjtY86O+fAn7pZO5mBTNBKWuPA1iWgosSMIlMzwaWeB2BNu/BH9KSIOiravPc4waQ8lboW0ce58483Ju/KVmlVMySgx8c2xtRpkzB7q/Miz07YMSHYEAzeFyeq1yidM/anHnnyv5R1QdVBuMHxUGVugnVNK8YPDsX5hO0B6ZwjB+0YDy994kEGvPDrqBKh9iwbTcob5A5oq6FL4zyexGk+FkFM0AR/As5kuiw7y5M4TaC9o/pR0PuWaCKC7r3hV32G5p1DehT5bN3dBRN/zZEUqWysJlgwviIhDUDRIx0GLiliNPi1nOsn18cVnSDevrcTw9PJVYe+xwYjNqqZV4aSsisen2Wd497eW1ShAGL19VBM3Iy/uG6rHt0QkGVitWhbRwn9FQC3tw1w2+ZZaO3HYDhD29g+L0XSZBo7FcsvC3X0R1PEHvxYkWqy6GKcRbkt6lcwVrSzz09DzupSciBUW3As8L+LB6rXSij98RjwyquWmvTXRzOCwgsZirl9YkzQJY3sF7CnFGOPF7QgdhRHCoKB5at0b3UN+dQqIfFls5UrfyxLmN7Gbb7OIeny9HrPQ7c9eNI16/q62nFy5qZsgsWYlkMUpi2vC5b3M154JL6b1PJ93ELA6OhYA7f/2gEErl62XoT8oLP+4JbaLI2zCd/th52kRUAPw20hsjAZP7mgIEZrJPV4IRxjQ9+YgscwXNLDjc0bzH8HQTlx4XxI97AmE4zMPlFemKyHvvPJCeV/tFEYAUu+1HjOYKB086CvS9czAPLLxNu4kY6BY+/199VWiXHEbkyr1BzUGlFOmuJSaDd7+Awv1V2VOpBIy7420JlNy0nHiZCfZSJC4Qkn
 rmOlMahE
 HBKJfWzHiV+HwGLD/Xef006TJEOuJ3uXlQOfc120USL6abNZW3fMkW9liUtNW5a81XOaHwlytCovdMXlA3KM9+atdaOff5p0ujqPA+HygJScDcvF3AbMTXGV8tpe2Kp6YGgHZ8+76ry5/FNTCOap97bp+gEG+NMUjThCHiatpiGpFfsXa4bQAlHG1qqyxgP/7A2R+mz6hGQzDj7QMpwkUIRNMm5v9JeF3HPbkVw55eYEo8AwbvAUch1abqrjf80vXCUcYoJmwZztcV3U2PPNEzlQNq+UHxjzJ7rFZqK+Pb5TzSDWoqbxaAeRDqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 6:18=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
> > In my micro benchmark, this increases the request rate by 36% and
> > reduces the average duration of each write request by 27%.
>
> Could you share your microbenchmark somewhere (or post it here
> if it's not too lengthy), perhaps on GitHub, so others can
> reproduce it? You could then refer to it in your changelog.

Will do.  A note of warning: it's ugly LLM slop, and if I had written
it manually, probably 99% of it could be removed because it's
pointless garbage.  The LLM wrote it for me before I had any clue
where the problem could be.  It helped me find the problem, but
uploading this garbage triggers a bit of shame in me ;-)

> I think this is a correct change. I wonder if we can
> reproduce the issue even without concurrent reclaimers.
> In other words, can a single thread running in a
> memory-limited memcg trigger it as well?

Your question is not really related to this [4/5] patch, is it?
Because this one is just an incremental optimization on top of the
real linked list scalability issue.

A single thread means there is no spinlock contention and the linked
list is only walked once.  I don't think the problem is visible then.

> One thing I noticed is that you may not need to call
> get_random_u32_below(MEMCG_NR_BINS) upfront. Could you
> defer generating the random number until you actually need
> to rotate the memcg? I wonder if this could further improve
> your microbenchmark results.

Good idea, optimization added for the v3 patch.  I don't think it
makes much of a difference, but it really makes sense.

(And I still hate that the Linux coding style requires having all
variable declarations at the top.  Code would be simpler by
declaring+initializing variables where you need them, and additionally
it opens more opportunities for compiler optimizations, but... it's
the way it is.)

> Anyway, the compiler might be able to defer it for you.
> I'm not sure, though. Could you take a look?

The compiler is not allowed to because it is not allowed to make
assumptions on what get_random_u8() does, therefore it must not
reorder the call.

(I wish C had a way to express a promise like "this function call
won't modify global state reachable by the caller's pointers", there's
just GCC's "pure" attribute which is too strong here.)

Minor note: deferring the PRNG call will move it inside spinlock
protection.  I think that's okay, but it can theoretically have a
performance impact, and I'm not expert enough on this part of the
kernel.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

