Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61465FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3FC26B008A; Mon, 27 Apr 2026 03:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17B66B008C; Mon, 27 Apr 2026 03:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E116B0092; Mon, 27 Apr 2026 03:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 821A46B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:02:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B98CDC26D6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:02:45 +0000 (UTC)
X-FDA: 84703443090.08.96AC20B
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1901180008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:02:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Nt18B/1e";
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777273363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+yQBCe0d4ZRJ5bPsrJ9MMnmzAXjuvRB9nOtpkyNZnw=;
	b=Fpzw4dxK7So+1Qy0w6+OEYnNrbNNYRetC1s9FejfoNJUE/juK4Z6SEkL1YdRiSGJp+zgxb
	WfRgQrn5ekhntkw4bcLjQxA0AZCK9VickobHYgPhJ9Nrj/Qy3t9jLuLIMGVmGh/0qMpqSX
	CaulMvqHBhOJNSd4zAb+Ql8V6zdXHXI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Nt18B/1e";
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777273363; a=rsa-sha256;
	cv=none;
	b=BzqF1drgRNTlXckckKqUjlhJAbCoDSbpfixucVoGhvgiJylmhMoLf77aAvTAZq0gx28QQA
	B761szUPSE36ONaKgEv9KgUSpRPAa5OiyFWCKMKzmBguJq+y1jDP/03gdsYYOYkmZQ+BmQ
	lEdUoLPmk13aF6P+WdnbvrdEwYVSD/g=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43cfbd17589so7789810f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777273362; x=1777878162; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d+yQBCe0d4ZRJ5bPsrJ9MMnmzAXjuvRB9nOtpkyNZnw=;
        b=Nt18B/1egzpoRZfJr+erC3q3fSZUCYVvwL1v0fb3DYICBA+D5xbd1jUg9yy74sBwrT
         OfEwdSqca99YPQm/zQRY2l4RzViTU5vjT5v6CxOn/BXFHFOa+n0EB1QW9twLN9lGv+yH
         c5n0ko10AtQTVB3DRjbrILXe/kkxZM7PglSL0LkEv21NJdts+lvxR3gHSODfTYbSc97U
         27zTXYFCTcod8Ppstt45AJSnrJPkRCkA79z5T3FZWSeIWu0OLAfWBgLEJlDzcISqvU7v
         ZptWbgixZEo9eWMsliC75xvK2oLOVNVfAodOpzjkSV/Lv4s5EzV+CKKMfrb8udFgHRpZ
         hOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777273362; x=1777878162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+yQBCe0d4ZRJ5bPsrJ9MMnmzAXjuvRB9nOtpkyNZnw=;
        b=oK6rF+yeGSTdktNzxSFYgrEDw8LAyHTR1dISJ7yacUNhFfscH9Vj1mzDQKd+j3mhka
         Pd2gOIQmdHwyb6CUstjZvHnmRrcIx8e9JL2P24JdaJJGJCanlJbbkgi4UDR4erv4/AL4
         hOQ36/9c09gKExQjN3Z1EZ099/RBYKpNLPPHoVDSMzJtgG90QnqhH/I5rNzMUJ6aOOTQ
         aLuGxkRd40C/dJ1hy/IJA6oFY1SktdaXqakuallF/oAEFH0xRXXPUjMo3xHLcqeWo3kE
         fYAKCol49uXAJJ8ogZDASSYw1/Hv+rtvwQ3ijf7+hnb0a6YjV2Q+N3f4diYAMGEJpYn3
         ETEw==
X-Forwarded-Encrypted: i=1; AFNElJ80ALtHq9yBeCYpOTi5M+FmZT80825zmnL8J5C2osekMu9ohko/N+tgFKovmNe9bAw8g7LJI4aL2A==@kvack.org
X-Gm-Message-State: AOJu0YzceOwhZSbsLQSpsTE/kBnIg1pyLFLOsHOliCJymRWLwea15bVk
	/OpHONthDL1kgHgx2nc9IAtGucSswprSfx6A1TZ6Hex/l1cWsQxBaYZV4twAZRAzAGc=
X-Gm-Gg: AeBDietHk5VN+LSYstZWeOGIEp99fAa771fiMuPwPaOi8FICkhr1YnLJqhWI92VU7Np
	TOj4YmNE+tseecyJF3yDQckwQwEu4/Rnrg1VziZ8dRMIIN76wjHDQ3wCuOvTLi7b/IxpXZ4fXnI
	DR6wdGT9kWfpMC+izl1Pi1ZsaPU9AZi2JUodPillprGjAcDnlgn+dTZ08Qzr25Y6F/sixY5W6AU
	n1cGceUO/GlWEQHjd3in0wVKm0yOdcwE5aRt13uXwYPf5UfZDZ0XymxM+EjgAUKNqgI+OvnGaMh
	MRf0y89lC78nTEUXOUK0pkwgskeDIUgpSoPYdVkRHEFrmPgNjO9H69acbDeefvAMms54jUG+EYv
	zPy6zHgSy28iRGOTO+uxdwTmeA1uUUcm7Dh5OhA/FaUsEVoakpefdh8sncwkoK39mc94vm3uXOE
	4BWTkij4gJlqZ+KptvAOplOPwolws7kDDUMJi4/ditd8Kp0qY=
X-Received: by 2002:a5d:64e7:0:b0:43d:5ec9:246 with SMTP id ffacd0b85a97d-43fe3db2d0fmr64773276f8f.12.1777273362099;
        Mon, 27 Apr 2026 00:02:42 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc2cacsm79101146f8f.13.2026.04.27.00.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 00:02:41 -0700 (PDT)
Date: Mon, 27 Apr 2026 09:02:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <ae8KD_Tq0t7RvUy1@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aevzbx_Pk5Cu5exa@google.com>
X-Stat-Signature: 8ij1g5j7jgbdshywhrxe9kid7z9jrrxq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C1901180008
X-Rspam-User: 
X-HE-Tag: 1777273363-126387
X-HE-Meta: U2FsdGVkX19azjV68f2XXEMGhRWqoa7Ii+DTOZMgaqaR+BZe02xfggFCMDE+bHncgEj/QZt2Uq0U0BeHn6/A9t5GIQF3B9SVAKS2itOnrLrMJTI0ANDbNeqkF/I4AKyg79+YEXBrKOduCV91XhkPxvIa4VkzN3J7AYrY/odt1MgVGZc7PUVL7SOXjdhIjAVC9uB7nfMwS5aozDI8pw9+jVXAazzI8edY/GynKLk7hYm1sfoNQOUvOIMxZPdMSWn7vnAOSVrQAsD/FDtxZNO2zDGN97+LfX9fEKas16f9R5vA08PithQMTO3LbIysT7czIIqJK1U3/8qFpTdPeKp1+NFZx3yXslq8wRZ0wshkWvv3is3ynt4HiyYPnkaQ2Vn7AUTqDJuDg6b7QfIfWxQUX9cnhz+hEwwOBYG6XKKzofLhDf20tPlcECw2NO1ucxtK+S0oUkoJc8Qb75okY2rZkVV4ZHkmsVWFpmTqUF6AERwFPOuGFHuRxRQMGNX5M5Ssfpww9OWXZ0ASj+TNA7n/IthQNzxwP/Dv2/bRyFXNfN/KKQbyidcPW4Gg8d2zOlRXv0t/dHiFuFBVpakIzBYqGCGp4IR4jCEtUsGHc3TCm7A/CxEfDFBBCSXB0dUsfwy8JHie8UMrhdwcMaIhWj2eRSVaQ3p2fuNlAZ7ZKR3sP8PDpVdYiubvhWJJaEY12S1xDx+5IZ8MvlbOfPM+VOZLPlcWjbXt2W1S2KG5KiHdEMY+Xtq7g/61qZ1GXctv0cRLSVt18MLZcFoONHwzpIDqyZUR1qwQLdAAOoG9VQHWbTndvBziPjJwGCxRleehSggo63V/yXcIZXxgMO07do5WDgwo8oQoUoGYPzkrytf81TPK85nbRqb/gKjHnKXCCPALhGdKd6DZXaUtbOMCQkLbBNdiI0QCJt8LAnQRyRJWrVtsNMZp5sPIwSjtUIVuQGhgj68+haGhEl+9ZsUT3Q1
 o3dc06ql
 /fdmJwaA8AmgJ5O/KFUj63zqw55LI/IFr3jC+eYfRxBbDia/Nuxh5Am6wbwZmCB2L2ir1H1OTPNvL0OPD8vZtlHoC126NwpbdX2q13/5G669zPiWT/i62ek9zNSR7XmAATnsYbBjinOwDt/DX5CmQvM273HlH7KZtvTMPHutVNp7iaP1iOLrOb9ZUpZtrHnj4WbyMRJ7bAKm4QoWHJSsuXyA/rOA+k9ZU2+p8rvEOrGXfx7vzyyaWbAf67hfJxyblysDxR2erbulWId0XsQQBajCmw4ZP5Vgr3y9B7QwqsG1XaM2VSV+LCmcW++/kLLNNr0nbGWbHuib6WvKRIjfCdk7XmVvDLGDJL/gYDdbmJkZfW6qv1PUmOYMGB6JlFgmh7tx8V3YkPHmvmI1PY9x7UkjeRuaXZq6ns3/S4uoQrE00co0mulncmeSuIHZCVvO+0m2k0TnWOa0AAV0f9Wbl+VpwM5WFxAxu37YcLkOPi/ZHCw2nQNCOMwdhJgiwiLB+2v+eLFvESfqKcPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-04-26 15:49:19, Minchan Kim wrote:
> On Fri, Apr 24, 2026 at 09:57:20AM +0200, Michal Hocko wrote:
> > On Tue 21-04-26 16:02:39, Minchan Kim wrote:
> > > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > > prior to the call. This separation introduces a scheduling race window
> > > where the victim task may receive the signal and enter the exit path
> > > before the reaper can invoke process_mrelease().
> > > 
> > > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > > leaving the actual address space teardown (exit_mmap) to be deferred until
> > > the mm's reference count drops to zero. In Android, arbitrary reference counts
> > > (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> > > VM accesses) frequently delay this teardown indefinitely, defeating the
> > > purpose of expedited reclamation.
> > > 
> > > This delay keeps memory pressure high, forcing the system to unnecessarily
> > > kill additional innocent background apps before the memory from the first
> > > victim is recovered.
> > 
> > Thanks, this makes the motivation much more clear and usecase very
> > sound.
> > 
> > > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > > an integrated auto-kill mode. When specified, process_mrelease() directly
> > > injects a SIGKILL into the target task.
> > > 
> > > To solve the race condition deterministically, we grab the mm reference
> > > via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> > > Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> > > victim from calling exit_mmap() in its own exit path.
> > 
> > Why is this needed? Address space tear down is an operation that can run
> > from several execution contexts.
> 
> Agreed.
> 
> > 
> > > This ensures that
> > > the memory is reclaimed synchronously and deterministically by the reaper
> > > in the context of process_mrelease(), avoiding delays caused by
> > > non-deterministic scheduling of the victim task.
> > 
> > The memory is still reclaimed synchronously from the mrelease context.
> > This is really confusing.
> > 
> > Please also explain why do you need to do all that ugly
> > task_will_free_mem hoops. Why cannot you simply kill the task if
> > task_will_free_mem fails (if PROCESS_MRELEASE_REAP_KILL is used).
> 
> I wanted to handle shared address spaces.
> Even though we are okay with the target task not being in a SIGKILL
> state yet (since we are about to kill it), we must ensure that all
> *other* processes sharing the same mm are also dying.

Then just bail out when the mm is shared accross thread groups, rather
than kill just one of them. Or kill all of them. There is no reason to
play around that on the task_will_free_mem level.
-- 
Michal Hocko
SUSE Labs

