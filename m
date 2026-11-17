Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43618606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AmBxm20J
Received: by kanga.kvack.org (Postfix)
	id CC6F36B00EF; Tue, 17 Nov 2026 12:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F3F6B05B5; Tue, 17 Nov 2026 12:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB946B00EF; Tue, 17 Nov 2026 12:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99DE06B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:42:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC45680580
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:42:42 +0000 (UTC)
X-FDA: 85445330964.08.8918DEC
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 979B7140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:42:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=AmBxm20J;
	spf=pass (imf23.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.43 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794937360;
	b=O4/Sf/fQ37zxNvBiG3qMtBSxQo0sCzB5BgT/SjGX78J0cM6swDvLFqx5nE1PUMFSG/Dj8n
	wMg/5RmrKvVhXzlcPr5JiA5E2fsv28Ponq2cu2B7Pmm62Kt5dIG7O1f5zE4tdog6b5A/wO
	cUG0ki/iI0OnEo8auxWC8thddlhk9N4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=AmBxm20J;
	spf=pass (imf23.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.43 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794937360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
	b=TiVIacvbxGqHapwzOdgUTdYnW6pRvhcu4X8HGyhB6uf5PAJnCUcV+/qh2/+4urWNOpCvda
	dz9WMl0GzYrXgbTZdfxHYmfnoguWEwYbcis3OFgrcCF3U6TnJAjXIX45VrJo/WV5B/poWZ
	NpwtDStTaOz86F78bMCKT0Rz+vmUU6g=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bcdae234ecso3174e87.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:42:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794937359; cv=none;
        d=google.com; s=arc-20260327;
        b=MHroBVUoq2XcysixfgqfGwsMWI4R860HLrNmdzLyLO1f2nHUcRwVdE1YR2k489I5bb
         PO2vXqxMZcyEqn5U25hJP8rGMFAwauLmPALaKlbu9HAY8lK5u0AMSxHfrjpMOWgpiV96
         hvjmAOjYAiwjKJHVluURpcndDvyoWKdoZVqyCv6SjO15W4LQOILAs29guoAKWySwhhaf
         a6oPASPQA0mGw8Z3ISAqDE64b2m1EJy2gxwAxTid+VDVsxKsejRhZvJrEVUu2olVHTta
         NwWvQaJkrpztHJ4x7m4o+VQI0AYrhqnFVXqbK29W1jelrZ2gyuRvWAdoFggNfADFUF18
         162A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
        fh=S5wy8cKy1WfDpyt0aFqHpNwKfT3LEI4pI7WFhcfbQKI=;
        b=qUhrCSDvl1srMEmjSUO8c/x0iUnTfsIOQSBON8x0HCGqrsNzFxAqCly+KNe3YWWs2T
         Ht32AezBulk+4yi8G4QXz0XZcbkWlCvfLK7VW0CutYxGGo6t7gpSBV3h45Co7zmPyhmY
         LP0rIPK3uvXjwF1cab8vPntCOUWzhpoNI1X7ONBQI5/Tbj5zgyFVn2wOEbMZmDFcEEaH
         E+zr4MkUyCsKS796Wpq+r87aCloQHy8p0yL2Yeilncv5rjhuzzNblbKmgunCQdCXQjf0
         skiySB7MdYH0Ww+4pILG47m78XY0N6jZ2lQjMd/y8pMrZxzRxb6Uc1CCoFvLmap3jvNN
         BDlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794937359; x=1795542159; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
        b=AmBxm20JL67Vp+qwXiLQa4Smhb64pK+mmIgIK6vI8BHZFZNTm6o5/GIXW4xnOb+uLj
         7Y43rnARDKH25Exn1/KetnvDmqPPMy0taQxboaala5tnxvm6Q4yfSfUgziXXJaj4jKpx
         6rf0EM9H2lotUOsPau4h2fMhGEhkdVW8FODtjlewplmr48S50izOsakdx35oN9XKnBWO
         PNdRyQTgdwcrDjokc9BXc/cpIvS1ndXzEr5CsAmaovkqZUw3gD7K2jac+/dqDRnmBJyu
         K4a+NZyJ1PpQdwmNcc9YT81Rm8P63p+Y6IUWWbybRsdd06L/Nat/YX7YLZfw6I4QuRF0
         f4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937359; x=1795542159;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
        b=VbpAiARenoHW68MB9gTNuje7gYsuFVFaIxJGJfsymNHcHkt9e2ee8I8bazv99FYwl6
         Gdc66gt8l3AO9m6gJ8sqaBzKZy5N9Q0EkAFEprYs0mVyES4P8H2tC3JrVXbR6gsayES2
         8zS8tjdBxhYmYjtsYZ87kTcOizxsPEdhL2NFD3M7jRr/OD+FbxlhVZ21wZqHO/cgZ6V+
         ozx/iPtI7+ukn+EiWMrscLQXvzmhscxBfEASDptD66+RfSDj7OTkbtvftwU+7AFCvFx9
         3b5KT+zZCY1K10ZjaQQB+j1CJMQDtl7VbAIYOtxkiAbz+jRE1fzry49Toi7nfHE1hmml
         CdAA==
X-Forwarded-Encrypted: i=1; AL+hErH6r9NOQFEvmTelELD23aVHtERePm+oQjqPOfeiJMQp1ZhCZjlWYtwefxSjK54AFqJecdTYqqSKBA==@kvack.org
X-Gm-Message-State: APuU4Z+FBVtYvEG2DPDnDsGazZdPdA0EKkrGr2OG+9KXopNmjBkqQ8m1
	AkYz7cqawLXShZRnrAfVc7tM+5T7YB4iE6Ahh2rD+r8WoAaadqhLQJxOo+ZgPiO35C5U30soNy4
	rXg2SuHIyUBMf/6SZgnWIeukMnm+2jvHKQpRY2ecQ
X-Gm-Gg: AYBFou2AN/yURIqx0JpxhUYqMJ93xqeqpIUN079h3UAuPUG6L48gRJXuOrpzIh8hzGk
	60TAxxvwBbOrJ5TzaOEWUurzqZRolLPtevS1Y8XE/4DZUaexeah8Mmx3rPtl42sSw8urAS65kli
	7z0O5mwrg20hvZDzcrSJ8Rq1mJ3qvsGKlJfJVAw3fz9ftlVF9MmkSo7HjFCmupxd158EPZcGQAa
	h8NWzIrY+WHN0P9gsKiejIRg10aTx/pQkJ3+/WbgCp8M7sL0ZJWC2sNsLk/e8SV+XW2/F/aiup1
	Qc9CNl0U+OVDV95Kf6tEYH5KqveFhB4UUgpIno/fM1t6aQ6Vsj2ZWDJMypzeVuyg8FktdBkKVmp
	nFx+h/aIEhVLyyJmDKaWelifZSpqLcFCldw==
X-Received: by 2002:ac2:4bc9:0:b0:5c1:4ccf:f0b8 with SMTP id
 2adb3069b0e04-5c170a0bb3cmr7252657e87.16.1794937358574; Tue, 17 Nov 2026
 09:42:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117050841.3289652-1-jarkko@kernel.org> <20261117050841.3289652-8-jarkko@kernel.org>
In-Reply-To: <20261117050841.3289652-8-jarkko@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Nov 2026 09:42:26 -0800
X-Gm-Features: Aa3M54o6AJsup2EB_D5C3UIkkriS8wK22wW9apyv8KKATx5_DoWBh2HrH9mfDyU
Message-ID: <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com>
Subject: Re: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 979B7140003
X-Stat-Signature: 7wei7yrnqxykc198uyodhnrm8pkiznde
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794937360-625316
X-HE-Meta: U2FsdGVkX1/kG1f+yMontO7rhXsxuT6aAS0VDBimzhaqJSCOP4grgzwitwECOA/hKzogoMddwdCPSH+fic0QTTfNehsKJllwme8QJNpVy3H2EjpSJU26cZFuv5YDUlxSS0pBfoWHydVBbxVHYA22zBMalQ/k7AWGaaJYoEZKGNex8YJ7Tz6eiZosQwT8+tMvLPo5dLLbjQ9ZLC8ZU39UD4BHvflVuWCwW/hhyXw9fhHJaoHHnw7OPOKS1BwOf07fVUwZ9dKGNRxh/9kJjc+SZXBPIMOGRqh+4F+8fQNsZKpfLM5xBXA+QkmYvB3gU+dnN3EY3uMlpUl4WpdlOkgS8Yq3aPUGZLHz9SrObaUr+E+qyMU6S4Hwn8/Ys/0NLpTHlLVrNL+ScQGGLhZkughMNa0eYlDMA9G6/AJC1YH9BvnuJwgBztASeBnoi9nTAkxBI8jHoKcCeF+flsB5MeH5GRnrHnMgwrO7IIXxZ8tIxYbbsup85fQJ8JIDb7hdNVhKZeVyh3khJAk/+uFvXjbTz77MOZFGOebnYkDUD1ubosow1g9uO7kzhyzN2RCoJclHM9K3gl257mD4C7cEnAnFlpwzNHzEna72BSB9zq/P0BAEoGl8/9ZOROADn/CHujJEPAMT9jTnhHJd+dO5LING8tRXufhVmag1oPewHcnZ/yN+cMY5h1nmi5gWXBHIyCn0N/pGNwgj2VAmOFcGAorQN4jCVpJmGE5PkozRjHn6GazhNoIAA1zyKpzVpPRtbEonns7a895qxhzNAA91/n5cIyb8Lp4EpNAHiucVqo04V58ATEplPc25bnUKehaTdePUk3/XNsJXtVjF5eT9Pvy2r6cgWMfKw+N3iTTBJkOyHrXgzegKpKebejURmlJyzuJctJ2/ac/FAYNf2cyi+AkatyEC13qHjOJuqEsBpVeojm17mtdHJHKykg2+O2KvYWcIulFrXvleyC/QoTk1bPg
 HkaCgN2+
 L+GRKl3uBB+W/sY7hCIq7klxJGyrXmb3YFgpWKgoNn0mJEtmudJTJ0h9CHwVWUFaKvKcBjyAZ5fD0vBXUZO+hrOYPaMCCBY8tbgTS7kjQ2U1cHL5kG08n2OPumbJdc6sJr1SYt0oIKmYs1SDU/Utot9fykKNiiwwa5TEIJmcumkTzxrvXPdFfWb9Q8NJrSRgnYAqvl2Anvc8EyTRLCZ8PU4N//MPbbTNyiKl5JzY3HqtoQD4egTp6UhujRvLnSMkGhljcQztrc+EKFA7VSOvWJqTdKkJGIX7uRl3O7tdYTJSCjapLZ21onbBjYRLwxyEKbRBV/soIGu7mRd1oIzYE6X41RQ++i+b3hMYeinlWSYC1L7ElYDfqdV0e3IUCZuV1TY0oEUE0GA33h6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 9:09=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> safely mutate process-wide filesystem state in place before spawning a
> child into a target namespace set.
>
> Add the rootns_enter() system call to fork a child process directly into
> a rootns whose root mount has been installed. Transition the rootns from
> ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
> process so it becomes PID 1, serialize concurrent entrants on waitq
> until bootstrap resolves, and admit subsequent callers into the running
> PID namespace until teardown begins.
>
> Require CAP_SYS_ADMIN in the target user namespace, forbid credential or
> PR_SET_NO_NEW_PRIVS privilege escalation

Why are you disallowing this if no_new_privs?

This isn't necessarily a showstopper, but fork() is really quite slow
in many cases.  It would be nice to have a more spawn-like API
available.  I assume it's possible to open a file in the target's
mountns by some sane API even without entering that mountns, as a side
effect of how the fsopen / move_mount mechanism works.

--Andy

