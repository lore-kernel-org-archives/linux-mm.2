Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F02606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NFvQe5cd
Received: by kanga.kvack.org (Postfix)
	id 136946B085D; Tue, 27 Oct 2026 13:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C12B6B085F; Tue, 27 Oct 2026 13:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3376B0860; Tue, 27 Oct 2026 13:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA06D6B085D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:30:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A72331C44C7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:30:25 +0000 (UTC)
X-FDA: 85369095210.20.F293C8D
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 924B8180012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:30:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NFvQe5cd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
	b=DMvstlfzIxBi/DX6v3koYT5mq8s1psasnIyfDJggk5vEYvITw/B7DLF7ZM81GLL2UdXxEv
	bUSQP6dZo/tjiNOauNx6MvuIrDsOyBXCS5QwfKK8g+tVlXS/R9YRcDZipbIaVMvkQYQYRT
	tuyoCD9tOFQj0rs3fM+EQgiQyYdDYQE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NFvQe5cd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793122223;
	b=8rH8zkbgXnCA5wlbOERlFcbery+Gl+QHRYcX8DJkLf3ULL1nuYEppuEpX6XdoGjYOt2ODN
	w2X7yiIOvGhW3kQ9Vw8beH0CYUQb064LLc+0cjiIhjBKfmEf5nqLILgcfRduNVZTnP8kMV
	Lmd9YqRMBuG7nn7OXlBAcT4ESjv4TpQ=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3fd91337baso7588466b.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122222; cv=none;
        d=google.com; s=arc-20260327;
        b=NBCOoyDKALliqrf8Ecv6363HLf7InoY55NG9tYMXYZtL3DYI+6wS6tSkKN3CC9xilQ
         JzV+OowQiWzg4aD9Jrvwc1KwuV85rmBeaL/W0re1dZ25/bQIC+j7MI/nz5Fs5VGHzYvW
         5mOn+/fAxaFC65GHQIm7cnKplnEo3Dht28zY9ScoZlX5XsbmyEfteN80CAklwsSNmtgz
         tWeYY05xVF9GzT9ubxUrEMPyWLnAjsRAeEC7EKvg7YuBrR1KpVtkP3xN6wSb4vlMdrsp
         HYspUQBEoFTFXZRh/iifbUsGcTvPumJEdUuvTvYi2rE+Ek6xVyVM/RXJtLn216ja/QiG
         1DDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        fh=EtCJulrjw2Ih1Q7m9g49hf25ub+VQ5/pUZ2KYa0PzJE=;
        b=TQk7Ji6ru6up9w53EGiEW1sWwlkPc6CGui/OEthE4cvcDeT8nQkNjg3JBHjlx8ETf/
         vUz6ArZEiLmydxRFb0mt+IIg586o9DMD92BJvOrBiHZxZEhXIbC1sbOsAcRyrdgqRxUF
         poXu7yniTQijMu1LBaF3ihdBGwJm3ak560PEiJUvVMd//E4wOP0JCA4Oo4PJxv2Xu6+j
         ZNwb0Ft6OcY8AyGn/8b5SgashtAT7gZYbaXr9NrPLq7WQSC1ehlQX8BxjXruzd+XMNwu
         pFdaXSYfWVUVixKlhyASd8umjWSD/+YT76uiEHqCL6TQBloZYQEzehm+5+LaMn8EVRED
         Kafg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122222; x=1793727022; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        b=NFvQe5cd1/vKD48Am+6I4F6ZbvOntjr+FlA4dmHvsybUtayo3xU3HR5/iixsJ8Am7y
         FAoYJlvjp3lsnY9rmseNg931U83EaF5Mc3TrT76bdIqoYMAiXzWjR4gjd1nkIuC1iz26
         n74kthyhdeqziK33Qsxarl35nK4sDURd6IbhhaCsRgMNtd/BojLG8XMtTYJuxz3g44KX
         lHIjqarlzqUscqj6+VTF7bCs6a5aYT80h3ch11DwmRybJKY8uI43Drdc1u5fxsXTwlLY
         8AGMiBMp2mkJBXYfHegYQerD45/FtpWWCXGs9DsQhPzjecayV6lRHM9mu0ETTXK//1ZY
         hU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122222; x=1793727022;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        b=n4KKTfxtcS1eILATmQG7CGGAvV/DLfEB3I+D0Yynj655rGrgcHciYyxWkeH5bY30zH
         yIKzuQeLcmJDXFCJADPiDg+1Td4wczgUAfc6llZFc8jTVEQkuxAJSGbvuVJMMFJJTAD6
         s5TcvH/1Z9XRLk8VUxdP+jhfEnfWKiApNBp1o9sBUCFnaAUADIjQeGq7LUzGEdH64MWi
         1CttI4gtkOo/gorPwiBG5Vh5XU8rO7beROcV53SYzKEh+CAfsMn+Ru9aZggKkFKjKMG5
         UX32SJ0SYfhFtbVnxrMsX0zaEMP/c7mo2o45cjrKXxiQDFMeadwQP6nFpIoa5lbvsmOG
         2rUQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/108+VEjaNpQQlCZzXcPb/7MEC6evOEv/GJmjjtiS7hRERQafZdTykvs6A75CoUsBKPmx5HV1kQ==@kvack.org
X-Gm-Message-State: AFq9FYJKSHw8wcl4BR/VrCudCcfpobSXRLkBmYP3boNcRIAKWhSSB0ti
	k4KGJEo5dXfCi541uZkl4iZS+lc8a1sqc+vnSRJD7KiHP7wr73kFSRsNFolX4+91h8ragySZTL4
	cX4oqniixwH1kS+0qbWDNIVEswBQAxRsA1WN/F9QT
X-Gm-Gg: AYBFou00CNx0O6TggV5ypoQW3GgDA0C+AvauJ23DhhHWeUWpDC/nyPkesd2Uw/IiiHJ
	7YoVBRgeCsjf3aHMugUgsqeMICP5OK9o7LbFk3hmaZ0zgMvvhwJNACe7g7rTAZVK/SP3QyADCMY
	5fGU00BYAAPIAnz6exL3aGrGS2BF+E/QiyUvHggIhy15vC6bi1rpk5ZqP8hMxkUYBWhEbF8d2xC
	IEQfOaR3IdnHi+1qgQZO7EZ8lVzjjofEefTfIC0GV4x/xGWWeZTuSi42l5Bq2qpSBnVU4Pg4bgi
	+ew1hClCJhbkzSnKDxI29/1DV9ib0YXgcGqNgEBqRsdg3qJLkxRN3SV7G6zx4ghSWo4hMU+fCmo
	a236IJR7v/firpR9xzzyHWmg8vvZUb8GErBVufVAXOUwqtQSemqb8oYuOhv16RrkorGGdjzwkq6
	bZlHDI6t7WaLyZKb9n/xw9z/WFzN1ysPWDZgW75OsdQLCriFcWXlMC9dNB4N+wJRiR43eE3/mGo
	pTs81fQp1OxT7AYU0TWCYnFz+25bRxS6w==
X-Received: by 2002:a17:907:80c:b0:c46:6a50:40c2 with SMTP id
 a640c23a62f3a-c46bdee2675mr1178260566b.39.1793122221137; Tue, 27 Oct 2026
 10:30:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com> <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
In-Reply-To: <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:29:43 -0700
X-Gm-Features: AclHuK_V7ZmMdE83iy-wOvaliSqHMUcbKVcnfqQwnRgRgjPYRFDHKTZOMwXOk5E
Message-ID: <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 924B8180012
X-Stat-Signature: nidq9bdebjssbxisnyh9dw6r6eai44ma
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793122223-719313
X-HE-Meta: U2FsdGVkX191XepT9dB2uQ5xmFtGrMhWWUs2o/sr9+HTBy0jVBqoecFxax8H03lsvinMTuKesCf/KZw+MJ4vM5+O9w5hNDDzRAs/a1E6Eqmxp5M1mRreQBMo/lu0lHj8PiQ0apqLdRejsXqvdL9B7l6u/Dllm1vnjPjFH21M8vTGjFXk2D8Q17EPjDjwbWLLO1zwQNUKjgJ9WrJpy9coL0+klBh9BzT4w3vhyZjC+Fe1/iau3IUBAzSH64pul9s0/o71/crmSs5b3RkKu+r9EYawQD7Oypk8LnAx5ZLVsWSg7thJYdkwaoMRYN7kA5+phUYsulLRZFzCUGGViXfnMcTZKv3ZWb3mDPkqPQnL4wJhLMuzjxbtQJC0mG5vAsFsG9S7PkaZHenH9m3sYZyOPC3nUHcF83dnRtEAGVbOtecN1aNPFbn/ygBnxceg8mE8NfqX4vqqdoq4JlueIAJvue+fluFS8mXniQZ37OCVAgNEeOpxHgZOBXXBGzXXKLNR1XaXSPXl1/OwVG/0tJgGLM9LObEmwqCyrp3+m9zVu+qx1F2BsIYkKi1nSpa2m7urWgK7IgoJbrtbOEro7Q+VOZh7nSzFynxoKV5f91tJVKMCRoTi5UHUG+byaPQPVkDv8oUIiMu50QV+4d2os5VNAgBUUOZxfGW7yILFUYvOmEnH6vi6/3zDudnJkzDasn4y4FtP5HAvHxYayatWGbBbZ/hdNUPBLPHRAsYVjLoYuEwwO68WKLqXFHc5uA9R0DVCN9pV3r8I/Ly6G6NfSl/cTt9nwDNDatRYq1/744j0KCGrHGvuebn+B6tuSYVkAbwiwOJKiHhQZvpe/aeDiiu9p4mm12rLamWQI1diGxzeB7dggbIAWMa8zVrJu+jF3uz8VP9PtTz9TFMUGhkAU+cbU7sap49PSDGugMlnyToAHHhg2pMImALPweGaAlqUhoeB6lKkOVXNgdraDVwXRw8
 ChFyD+pp
 GCUr+JGBPe7reov0YVeGp1shD55tr6j3PI2NjVit2XlmrXGvoh4oUdBOwCV8ZX4Y4NlFma9qB8ZUw4PMapuWynjPkZ+XrDqiN55T9Mi5dTT0swqnx46f0MQ2Nlge6XEAH9IkTUm9vaZsh6f81qTJoouZfpuvPIftSa87HXi0r2nUk2zqOUJ4Zr3Q2lHK14XgswIJrmOr24/FEnbPR0YCooH6T4CmPp7lkFl2/XWTN3tn4CfAajq/gq8+CR+lFpqKJHt0XWlB+mao8fzOfUKl7Iv3HulaoaHk3yrGsiuvxQsoAr3qg4Jzm3i5QcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 5:13=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> >
> > This series comes out of a set of bugs that were found in KVM where the
> > kernel can sometimes write to a random process's user memory[1]. The KV=
M
> > fixes at [1] are still required, even with this uaccess series, as note=
d
> > by Sean here[2] and below in this cover letter. The beginning of this
> > series includes fixes for similar bugs found through static analysis
> > with Claude Opus 5.5. I don't think any of these bugs are more severe
> > than the KVM bugs[1].
> >
> > We hit one of the KVM bugs in production, and it was challenging to
> > debug. This series makes such bugs, where the kernel is doing uaccess
> > without an mm, much more obvious.
>
> Nice work!

Thanks!

> > Such an access does not reliably fail. The user portion of the address
> > space belongs to whatever mm happens to be lazily loaded, if any. If
> > the access faults, the fault handler refuses to handle it and the copy
> > fails, but if the page is already mapped, the access silently reads or
> > writes another task's memory.
>
> This sounds like the problem depends a lot on the architecture,
> and to what degree they implement lazy mm switching. If an architecture
> makes all user pointers invalid for a kernel thread, this does not
> actually happen, right?
>
> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
> the current process is only set in user_access_begin() and would
> not point to any task here. Without ttbr0_pan, it should be
> covered by cpu_set_reserved_ttbr0() turning off all user space access
> for kernel threads.
>
> Should this perhaps be addressed in architecture specific code
> instead of in a common place?

You're right that whether corruption can actually occur depends on the
architecture and config. I'll write a note about this in the v2 cover
letter.

That being said, I still think the right thing to do is to have the
new check(s) in common code. Instances of improper uaccesses are still
bugs, even if no corruption occurs.

> > =3D=3D The New WARN =3D=3D
> >
> > The rest of the series makes the generic uaccess helpers WARN_ON_ONCE()
> > and refuse the access when current->mm is NULL:
> >
> >  - Patch 6 adds uaccess_should_fail(), which combines the existing
> >    should_fail_usercopy() fault injection check with the NULL mm check,
> >    and uses it in place of should_fail_usercopy(). This covers
> >    copy_{to,from}_user() on all architectures (including the masked
> >    user access paths, which never call access_ok()), the
> >    __copy_{to,from}_user() variants used by KVM's guest memory
> >    accessors, the user-backed iov_iter copy routines and
> >    strncpy_from_user().
> ...
> > The checks are deliberately limited to generic code. Accesses
> > implemented entirely by architectures (get_user(), put_user(),
> > clear_user(), and direct users of user_access_begin() or
> > masked_user_access_begin()) are not covered. Please let me know if the
> > new check should be placed elsewhere.
>
> I would think that user_access_begin() is a more natural place
> for the added checks, as this should be called exactly once for
> any function that accesses user space and also stays out of the
> way of the copy_from_kernel_nofault() etc.

user_access_begin() isn't used in a lot of places that I want to
catch, including the KVM case. Roughly:

  kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()

There's no user_access_begin() in there. :/

I do think user_access_begin() should have the new check though, so
I've added it in the v2.

Thanks for the feedback, Arnd. :)

