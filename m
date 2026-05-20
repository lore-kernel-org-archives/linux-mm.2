Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BA7CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37D96B00F2; Wed, 20 May 2026 11:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F8B6B00F3; Wed, 20 May 2026 11:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9251C6B00F4; Wed, 20 May 2026 11:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8142C6B00F2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:14:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EF401C023C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:14:39 +0000 (UTC)
X-FDA: 84788145078.17.796B91F
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 24DCD40018
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:14:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=U5GJiqZw;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giVGNCZYvusqd1LjrGyfCOwrecCKiCYrWPcymOZtX7Q=;
	b=o/aJ3j2RMtn6/6rSK1z1aF1w4IgWdRMl73YkBpfqtgdppQWS/wMWJHkDe9GgVNEBT7Fzap
	HWzXU7Ce7mESHWDWnmUngfr0x0vtrM7aQv5yhZWKuutk61F/vGpWyUYNrSM2JRW21QPY32
	Zo+sIuT59z10lTQOOysoKsO0afaHXkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779290077; a=rsa-sha256;
	cv=none;
	b=4p/Pkf4Yoj/RMsQAe4IM0W93+hVRsGffylXcf3mJtxZxlsc1Zmfk047xj/6CNt3yDY2VxU
	ieZ4RDgvYjFQcuMKE4NrrqKGnnEzLXlxvdmQEZZrc95G8brjV27HjOOEWe2BvkHqHlx1j5
	wkkQ9c8bzKldTAk3HhYt1E7Z5/wpwTg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=U5GJiqZw;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b9358bc9c50so765999066b.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 08:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779290075; x=1779894875; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=giVGNCZYvusqd1LjrGyfCOwrecCKiCYrWPcymOZtX7Q=;
        b=U5GJiqZwWm+Lvv1a5l+1N6BdKcE5V1ESJIvhd8QKsGxduiRifPseCyYV/2DtZ5C68+
         utvxPleRWee+Nr56ZiFvnBdQFrLRTNMdevffPxIbVl111yaag6zI8uKYPvWoVt5Ik1Ts
         +RtBf5RUdG06UNLrVtnOU9NJEB6ks2Fxz623k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290075; x=1779894875;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giVGNCZYvusqd1LjrGyfCOwrecCKiCYrWPcymOZtX7Q=;
        b=IGdItI1tEncQtHXzg6QwQ2YDn9GRiqpHXDFHtqKSIAld8BkVYfav9lDJTGY2AeOFUX
         A3wOZEfJM8nNXF6X0LFdqf9SM9mxPIBlFSbOlxcH74yvUFul3FWHfDgYLmp5DLbjXLBX
         NQWzmmQttcK64Cx1cTUDfxTPfqXUrMeHrg57TAsGPv1+gNFthOh0IBUbXd5Ok3PkDGhV
         btwrse9hZIG/LtsPfGn9NH24UxqUC2EDmfON4VSHGOavdX5pZzfjksCTkF4fh4FPwsxk
         4exttJ36NrIX3qfPkdJGoQRLiE0aQH9sxp8wksZOARSjcLbVeMMLml9hxe9YX6sfsqEO
         //+w==
X-Forwarded-Encrypted: i=1; AFNElJ9cST3bd9Jq2Ay5kwCERZZr+FHD+7UTIrI8noG85GFkWJkAco3fKGYpLnnHSbpyVOuuA6XRmTMYEQ==@kvack.org
X-Gm-Message-State: AOJu0YxYrG7RzCJo7Qf279EB0QkR7IriCpUXeYO8uYlTZpYxxXKUVnoh
	SZXBZRDpX72r+FL5woLZG2wbl36ZBusX0Mf+RWs+44pvfOPSLEQs0k5QV/CLdXMDF1oqJB3mJYm
	R2TDnXQYh4w==
X-Gm-Gg: Acq92OH2z/JVasM6FZjvF1/rNAh4iaPqg+AhSi3HHm39JCqpoOxFgCwu4hcU/siMy5q
	0wUX6Eq00ALAj99Lsz2STEsvXas8cZBq8EGjf4ZLzEw+owtXUAgHDowIO7hGElq/n5IiYymvCRr
	+AMHpvtqOJE3ErvlcTNuMxagFoxJot9hBojQsfp+18wZBCCzzb2EZ9DMBOtcYNY1r80yMIL+vu0
	1bNF53vQPQfpMA7cO92JFK6mikG5AnDLN8/wKF57BRvvASKZpA2Et2W0xEaMa9TS7Vg4enWbQ/f
	OXiFj1oVl00bvl7jFj9Umbx+NeFfJkvl8M55DWZGKOAzB9zByo9GFZDyDM4fv673S9JRZO9RXcL
	fdPpR/iAAxo68webTfivcsfVRCrJU0mWkY+ISvkQNClcf9HWPrE8X2mlV+HDlXRFxMyRuP6ZznT
	9NBGEAx336LfbggAwQSetkJ2p/T849r/0bjEXJdPNH30ABuO206X86COrpTJGaHyVdrS6gOZU=
X-Received: by 2002:a17:907:8691:b0:bd2:626d:68cf with SMTP id a640c23a62f3a-bd517929a8cmr1491658966b.29.1779290075297;
        Wed, 20 May 2026 08:14:35 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6831187a52dsm7771221a12.27.2026.05.20.08.14.34
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 08:14:34 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67f7caa33easo10745946a12.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 08:14:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8nRkTeB6n4q8WNcKrGNEEpICyp2FIgNKsfQkdpe4b9Vm5VftVhopKaZc6WqAn0dQqDbQNgtMhuBg==@kvack.org
X-Received: by 2002:a05:6402:46d6:b0:676:988e:8eb6 with SMTP id
 4fb4d7f45d1cf-683bd488f28mr11397985a12.26.1779290074405; Wed, 20 May 2026
 08:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 20 May 2026 10:14:17 -0500
X-Gmail-Original-Message-ID: <CAHk-=whDUZb6WM+99_aUuTK0n8UZYEbm7Y6cn2nbXp4oO+bNGA@mail.gmail.com>
X-Gm-Features: AVHnY4JrIyYiIhSDQJcysMhopfKLVBCfvkb58eEKp3mcrDL4jljIq3r1TdSXZrg
Message-ID: <CAHk-=whDUZb6WM+99_aUuTK0n8UZYEbm7Y6cn2nbXp4oO+bNGA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/5] exec: introduce struct task_exec_state and
 relocate dumpable
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24DCD40018
X-Rspam-User: 
X-Stat-Signature: gmzmawtqc4bz1ue1d6j3y547cptoqphw
X-HE-Tag: 1779290076-98654
X-HE-Meta: U2FsdGVkX18SlJe6VXOqWE9Q1CIL6vzkkq6JC4RVGLgeQe6YP6c0SvwDkfFk/jiihQzpoJ+ZKaSxhMW42N/pCYsGukBuqFXF8jGEzEE4A5aroPHndBmrkctPxIG19kaQsFxMx69gq8k/93gqvbIBa+s6jUGXzCZFs316y6eKs0QhNywLe+2X3RTFnOoNXslbB2aUBP1BtgymWbw34QG0UC5wSm5dPo0qEW/xT5cqZXHD1TDGpzEnyK3hXIZAzq3imfQjBDshLUkgaLftOt+EPe13OG2cVviz2P+c4S5YGuTI9VzXHwAb11h06hBNdivooN8St2LwUTLsB5h/DyqyHEUN9OGzeRQsXQ3b8/H5/nLRe/7cbf0Q33G5l9V7tR9GiKy+JfHtwk+8AkRfpx+mQMFZBeABG1ix21d1lEzDW/GcQ8wwo9SKowfdizVZvptqqBXlRTkbFmh+HHPpcUnOd8rPD8eAHBSIZZUS9fowYqHT9LufYfJZp0fIFZaUY7zaGPeeHDvjm9vPnCqlbRk/dv4x7fQpxDluvK+BH8ZGzO2RaW4chgGxANBXihGIoEAtovA2YR6nvId8nhh6zjcpC9Ajljh9lxsptxBNTBZrvsdnUUlDL9uogAZI6DcAzoxOXMhZOJl9MyjMhDs3SBtSDcSKTeIkDLJ9H4CvZTwmAqokK7ylYgfQjyQcx9tWq0YCOY7XTxRUiYzOTTgGK8QeDRp4kiGdJlTv6bON8ut+WRhwF6bnEAnylIgfU/VqG48bcg4vKO96IVTfDPt+5uqxryzRo55UtS8WArWt7djSL9rD4lqPULpZ7F6J7SCrRIDmMWhd15uyVlwK5wuUf1+rJ9uiRQ/a/TEqEOl1LMfVj2inD8S+j6/ugMBJZE8oTg3CknBu2n95ODvQtOcbN4XsaWjh2u6Eq+ddBvDlbk82ojQigbD5g8ZjGSBNT87N4lUHwXq47CEX5kZ7pilw2bv
 YKUxaLe/
 vtQ/u0/dDEkv1lLu7XRy+13jNtWLmiFq07Yy5BGKlHy7xSveWohqOzPr/OsFtEGHPHPEm6UEk9XzXna1QGTxoAiTmXQ7Ek4dE/27ea9SMlHgj2WK2u+LyjJqxX+O3mnSeAwi3sHJYtOClTM0RR2SlqMT/ZqDZPEQfcWwIqot6YuY7N152+HAAZ4ghvkXDqSTlu3qV7frCmiE2UOqDqRBwEAkXEJ3AfHIvg7Um++HV0de98pVQTpBy0cqI1Ywf2s5+s61kWgCqgeS4QtR+ISVaf3Bf5ypy3sVmLTSAOZcqWz+kw8DgmqGrii7bTaSrW++zQs4wTwqcaSqmPSGf1jIUVDxCLN50vYABT8Pa9w/+/SmlHt8FGmm2I6GqxXF6poQr8Lnw8ejR0iCO7oWCCpRTXYM5ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 at 09:43, Christian Brauner <brauner@kernel.org> wrote:
>
> +struct task_exec_state {
> +       refcount_t              count;
> +       enum task_dumpable      dumpable;
> +       struct user_namespace   *user_ns;
> +       struct rcu_head         rcu;
> +};

I like the whole series, and it all gets acks from me, and I just
wanted to say that maybe we would want to - possibly later - add some
more of the bprm information into this structure.

I'm thinking of bprm->cred in particular, because in some respects
that's really the core piece of the permission puzzle: "this was the
credentials we got at execve() time".

Because thinking of ptrace_may_access(), wouldn't it be lovely if it
just compared *those* creds against the tracer? The other creds can
change at any time, and we literally have that dumpability check there
because we don't want to compare against some new lowered credentials.
Checking the exec-time credentials would make all of those issues just
go away, and essentially make the whole "set dumpable" almost
irrelevant (it would still remain for people who want to restrict
dumpability manually).

But I think that is all an independent expansion of this series, which
looks good to me. Ack,.

          Linus

