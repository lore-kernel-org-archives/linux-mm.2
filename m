Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E7760A2611
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e9no14pv
Received: by kanga.kvack.org (Postfix)
	id 48E396B05EA; Tue, 27 Oct 2026 14:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466006B06F8; Tue, 27 Oct 2026 14:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CA86B0720; Tue, 27 Oct 2026 14:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5C36B05EA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:51:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81A8DA879D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:51:33 +0000 (UTC)
X-FDA: 85369299666.21.54E2269
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 91E511C0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:51:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=e9no14pv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
	b=79NOjnUiDnxnKy2/1yuR/BjCAQeLeycd2O5meLmRVFTeViGXKxHd4gcc0D9cXXWb23twVa
	zJ4w7UhjYFeIdbkVeVUKqSdgaGNwsr3f+O9HsVhIxZ0ml1SWsEo+TRYlODKgkmiUqPILwk
	UPozA0Hfle18Ls6jLfHQABQ4M2mLkqY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=e9no14pv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793127091;
	b=1Ch5eGnJ2qEFgHjyn2FSxAOn+WGkiP6sG5ZJhiroog5ecph1JOJyR+bD55z41ADe2xBPdL
	Y+GadQCsCKxX8lxG8pQ+WrTLFwdNr/dIqT7he4DT7N5crIUBsQdHsQDIWyWrN6qt4XNT/F
	j6ks1KshtYijLSkVI5PwMnbs/x+zQRQ=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c3fd91337baso21459666b.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793127090; cv=none;
        d=google.com; s=arc-20260327;
        b=BhplwE54lJnL7E6NXanEAjE+GEbGUwmA4IJ0JXvAVZgbhQqHEsl+4HrwPi3+LqW1V9
         5dJkYdS5bCub8vJiXKqlkVQtdGOmc5vcHwdranegRO0oatVSSyehPXssJS9tB36+HypD
         mfFshcI5nGd9zIHjKMZr8HhqQBGMAnMogHFvetVhNsZJC0NZ4KwaRz91yQhHpONO0P0i
         dFy/ApEdDK2PsztvSn5Yz8TEIpcR9Y37y0ImfaaOqu9tyB+GzNAaRzwc94vnjiQthWFW
         spWH1Qm1CJtMB2z+IMPFX4QyQgHGBikF6S9PzEHp7d+7pfI3XqsR3Z7HSFeDVQR16TLq
         alCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        fh=JXaGyO4fI5POBC68YBpqm6N/PL7zcfY3Lc1PiM+a3Hg=;
        b=NvV3r7PNUoxxe4/6eL0eI1BturqF1Jikyw0MxY+n1inrDBpcxgwnbUNmKaeLk1Vg/a
         sCMioUJB6RUpbb1OSqIEJ66Rop9+oyZtt/dYU+zwSwvpB0tXDuOnjBXwPTPyIT6aZsi4
         68Avn/Ioug6HbumQ2jMgKvhkmkQ/ut/NqbZF6VY8XMh8zFXWjwmsqSqxLpPYkJSaKJMI
         f5ZAMZ4wjcjprPH4EA+72ZIFAjWimVMyTh7ls3eGgpVTMYFIYoea2qGeQ2C3SAB7hBWr
         rPRNMFWsyyF/2j3DGPpH2slHIgWtNDJNQeLLXZvsLB/fCByb9UK5TKtqtM0Q2DMPwdG0
         3FsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793127090; x=1793731890; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        b=e9no14pvf1BQFszbG6oHQ8xM7eWtCKUt6VZ4HFStxe42y1cwhfLDyPbnt89Vgq2jjb
         wwZs5n2xRBQa9GFB1lzKarHBJyjoj1d0j2joYAQVPdDpqqAqLbPDuv3JvckisVpp/v48
         NogLspZ1CrLgpYQ/vrfDsqgtkKUWl9WmxwrNTLxXZ9tDK/C9iK0BZtdp3qzZYBB3Zpdf
         ZoORd7CU4FtiSm2wUKMzztSTvbGclBj6qZGRCV0l8RQ4BCoR3irgH5QDeXlh7xXRcIsI
         BHnRLrlXzF4Xy++g6lQFNcM/6n1zEm+gAc7OMv7/QzLuMNJeYOGjgG87DpFtU3Dybx6S
         GaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127090; x=1793731890;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        b=yoWaEtglS5VrHAFofBP4XAJYL8BPmWbILewI81jIcw1q1qrzV8rY43tzbPClYkop5n
         jjCEUjrh9jjXAEoK2Yg/EWahGrxkxN8ike8jwlQfmHOeaGg284JKcVZKV/7s/H1hW8e7
         uSXKH4QAnaDrKxBSBQ4eIEoKVqSzelfdTJEQyUx3zeMcactg6JzTEwgUJSVnTD6GOSdJ
         Tk4mmTepUPkQozV8uRuLXnNZWWIrkh1b5JD8KY/qIOAgR0SMFE+ZkV8RNtdoFJMMl+Om
         XVi3Kd28zn7ev34qXsEu+Kcw5B0ypdQqixHgtN0xHZx3q1qgZSc3mgVnH0Z+EIrvk38n
         M6PQ==
X-Forwarded-Encrypted: i=1; AKwUvBxC5MpJewtPeRkPyxQMwS2/FlgFYDFeZcxtfswdAZ1YTS242+W3fj+l2/89VzYb14xYwMguY6K0Bg==@kvack.org
X-Gm-Message-State: AFq9FYJufiyZkADXBZUJgqiI3Et6iqzrSSugWHp36DvZ9CVbvj6iGCAV
	X7rcXc/MpxoGIvczytwkHyAYz77TAKGt4cXBD/2RmzvfXby1zE8BqsZ+TF+BrZwZwOfA6E2OQBf
	lF3zaKYVty/278wUx3seIh62WNUx3h9RcB3W5LL1T
X-Gm-Gg: AYBFou2YM7h+tDLhTw2SeN+KYzZ5xqeEhu+5ti5eiMpWJ91dCz95SQIukBM7+nF1ozt
	FEusar6WNyiOk10e/cjVg/Krn5gml9DrZ0sS6ZaXsMxEsAHqSojaeyNb5ynhuWJ6/fQMAK+0nGE
	J8FQjjleXPW7+RTpVOt3Fz/YAabP0Nx3Xdez1rMgHfRq+lXSv7zeLpK1ecMMxqBi1wHNx4yW+j7
	/fhWHpIO4J4/7ZHE4KhmNLTxI6aqEXsYG+aJ+/2qq3Dt4Ve6YY361ynBTuJLqp8M2p9ZJB08EzE
	1SWwqXX60ZSEN64wVYcdi3sU26lDk+dLhHmf0kYyfTtW2YSJ0WlrAqgOFUiSaecohvI0AKJfr/w
	hiMfoEJgZyKQ/p6lxTw7D1qj70y3GRPhE5kFVLRyzxTmbxQJ4KRvqFUDvBHVwpTxvs1K0N+LC9j
	GpAFZGgTooL9pdvrxAcOJ4Ynqn2fww+zXR+sANqZfnNxrdPVXnOWM0xC42fhNrilKRvv9ka8tSE
	R+2NF+qSZ8ydMUTY+G3/KgWLrSxbWRY9w==
X-Received: by 2002:a17:907:a08a:b0:c41:8e21:4d5a with SMTP id
 a640c23a62f3a-c49bdb68d78mr15531766b.5.1793127089381; Tue, 27 Oct 2026
 11:51:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-4-jthoughton@google.com> <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
In-Reply-To: <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 11:50:52 -0700
X-Gm-Features: AclHuK8M0uftDAMQJptfiH_zotg0NLNK0vqcV1a8EUqq1l3N0gBPNm3WO8H3TD0
Message-ID: <CADrL8HVHCVoh3AToNzFCe7KP=yC8byCGCzGYzzBEGYtYNC4fJw@mail.gmail.com>
Subject: Re: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when
 current->mm is NULL
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, tglx@kernel.org, 
	peterz@infradead.org, kees@kernel.org, arnd@arndb.de, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	jmattson@google.com, axboe@kernel.dk, asml.silence@gmail.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, dsterba@suse.com, 
	mason@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 91E511C0006
X-Stat-Signature: en5qdaxngkasctbq4g3gyxiekoh3xanh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793127091-43432
X-HE-Meta: U2FsdGVkX1/bt9C7Gw4LHZlfB15KdW9ZnqbS6e12Km7ndgEyZG3HV8N9YoIjLQXFRboBIk0qzFu1x/tWSOpTQGA/9WGABqnJbBuXQ7JhroAsfahLBgxRBRI7r3taX77i/r+DZlgmsFsPoQTPjdRoolZsqeJ9YQD203lQgh50DcDPWfmU6jAgaO3OAukxnSd/4SsH3ejZUdHZlRtdC9KgwjNHwJ3QuBUvLAqGLZVt0966cnLm+vS+Yq7CVRFUziu75tfdXwwxketpEvQSZQTdPKggZIulNAqZG78ayxeQOuciqgoH46oL+PfjX0VFiw5SVWm8a2kkRAKHkT/Dq8SQYXRzwA/b9AmDNxelV3sybesivtyte/o+iVobQ/wUg7R1/Abc7GWtIE97u/4699vihwgJBdsIg3K4ReXcW/7PofU1xjWkt/1nqmYW/HHZMa2ZGn1Zz8JjMKZbPET7IIJ7paJfqyN5jKpDTiOZ/RAi+4VejVjDTZbeBEVUE9jXwjc9WK55EFtjr9W9k/a52T10MQfrf5oQcNgvrLawXB7lCz3vzijRfznuBvy7fN43tAHmFZesHNVnAaScRZrfmXnZ1QNXXwKnAbrS0nAT9xp1goSQ1lbLBC+OHEisDFvy9J7KdIn916QYpvZUwmuyzOQcgeCb8YzRJwMLPZBm9YArgkuSrHCX7sDMhSEe17AdhSWJUw2wvqpztwNdGDhaSCjn+qq/H9btkAA35A3dsWqb7HCThFAlOu/uA2itxWLTNuObiNv9vUgv7+ODpzgcg/CGnqesgNjQvjEZ9cX9+1yKF9fSr9SzGlM4uSsFw6WFvlHOtRdX6CuV/I6u8JjMm/2bbeWWiympt+7OeFNsoyeCyj4BPJNDtCOF2qYr1awilSJJtrifsJzoa2QOMyUJx305xwU9Oj1vnzDDxReJ8CmtrxwF+9+8GeQekgu72436Rffm8EhiPmgX9c3lO4LzcHN
 uLihxRmA
 KusSFZ0EwRzJEaz8nWjCKXBUs0yx6CA6vNVoG7SounozkxbCjgIdOhld+XPIDf5TCYfvzYXvlEMVxFy5+u/xYu86V4MUPq98LCuuiZ0Xlk15we40u9CWyvmnFgF4Kuc/Gn2CAnS9hQjyN9JwyM3D7v1URaE6UlVEX2f0f3Kbmni2c0VDA8qk3AwAYps520kwaVCsqQIWZ+k9HorQQe4xmC8MJbK4ouf6Z0gIUKhEy7AGIxxBa2f3c1BNKjOC0kMz30Byf9PvtpG47/zRKMDPgH9w7H9bOTJ5uP9SutefgbHJz6NJkrKNE1CPiJ6ORVbjL+RXsCs4sebTL07rZ1+F4jzeFW+r5EKnH+1Qa2Ii+CwBmdxQysPii+xiZlgxSZceOxEbgyBxD5OGUq4kD8SOsHc2ftg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 3:30=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > bpf: Fail sleepable user copy helpers when current->mm is NULL
>
> TL;DR: Commit message only: the security_file_release() example of a slee=
pable
> program running from a kworker looks inaccurate, since such a program app=
ears
> not to be attachable there. The fix itself looks justified.
>
> > bpf: Fail sleepable user copy helpers when current->mm is NULL
> >
> > Sleepable BPF programs can run on behalf of a kernel thread, or of a
> > task that has already gone through exit_mm(). For example, bpf_wq
> > callbacks always run from a kworker, bpf_task_work callbacks queued
> > late enough run from exit_task_work(), and lsm.s or fentry.s programs
> > may be attached to functions called during exit_files(),
> > exit_task_work() or from kernel threads (e.g. security_file_release()
> > from a kworker running delayed_fput()).
> > In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
> > bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
> > call copy_from_user() or strncpy_from_user() without an mm. That access
> > does not reliably fail: the user half of the address space belongs to
> > whatever mm happens to be lazily loaded, if any, so the program may rea=
d
> > another task's memory.
> > As there is no user memory to read from in this case, fail with -EFAULT
> > without attempting the access.
> > Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
> > Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
> > Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> The commit message gives security_file_release() as an example of a place
> where an lsm.s or fentry.s program can run from a kworker:
>
> > (e.g. security_file_release() from a kworker running delayed_fput())
>
> Is this example accurate for the tree being patched?
>
> bpf_lsm_file_release is not in the sleepable_lsm_hooks set in
> kernel/bpf/bpf_lsm.c, so btf_id_allow_sleepable() rejects a sleepable
> BPF_PROG_TYPE_LSM program there.  bpf_lsm_file_free_security, the other h=
ook
> reached from __fput() through file_free(), is in untrusted_lsm_hooks rath=
er
> than the sleepable set.
>
> For a BPF_PROG_TYPE_TRACING program, check_attach_sleepable() requires
> within_error_injection_list(addr) (or a syscall prefix when
> CONFIG_FUNCTION_ERROR_INJECTION is off), or an fmodret set with
> KF_SLEEPABLE.  Neither security_file_release() nor bpf_lsm_file_release()
> has ALLOW_ERROR_INJECTION, and the only fmodret sets are in
> net/bpf/test_run.c, net/mptcp/bpf.c and bpf_testmod.
>
> That suggests a program attached to security_file_release() is never
> sleepable and cannot call bpf_copy_from_user() or the KF_SLEEPABLE copy
> kfuncs.

Great catch. Yeah, the examples aren't right (but the fix is still correct)=
.

> The fix itself still looks justified, since bpf_wq callbacks run from a
> kworker and is_async_cb_sleepable() is true for them.  Only the example
> appears to be off.
>
> Would an example that is actually reachable keep the changelog accurate?
> For instance, bpf_lsm_task_alloc() when kthreadd forks a kernel thread
> (current is kthreadd), or bpf_lsm_kernel_read_file() and bpf_lsm_file_ope=
n()
> when a kworker loads firmware with kernel_read_file().  All three hooks a=
re
> in sleepable_lsm_hooks.

I've adjusted the first paragraph of the changelog to:

  Sleepable BPF programs can run on behalf of a kernel thread, or of a
  task that has already gone through exit_mm(). For example, bpf_wq
  callbacks always run from a kworker, bpf_task_work callbacks queued late
  enough run from exit_task_work(), lsm.s programs may be attached to
  hooks reached from kernel threads or from exit_task_work() (e.g.
  bpf_lsm_inode_free_security() when the final __fput() of an unlinked
  file runs from delayed_fput() or from exit_task_work(), or
  bpf_lsm_bprm_check_security() during a usermode helper's
  kernel_execve()), and fentry.s programs may be attached to
  error-injectable functions called from kernel threads (e.g.
  btrfs_should_cancel_balance() from the btrfs-balance kthread).

I think all the Fixes are still accurate. The first Fixes isn't very
obvious; re-checking it with Claude provided a pretty clear
explanation for why it's accurate:

    This is the subtle one. In 07be4c4a3e7a (v5.10) the sleepable LSM
    set was just bpf_lsm_file_mprotect and bpf_lsm_bprm_committed_creds,
    and both always run with an mm. The LSM examples above only became
    sleepable later, in 423f16108c9d ("bpf: Augment the set of sleepable
    LSM hooks", v5.11), and bpf_wq only arrived in 81f1d7a583fa ("bpf:
    wq: add bpf_wq_set_callback_impl", v6.10).

    However, fentry.s was already allowed on any ALLOW_ERROR_INJECTION
    function other than __add_to_page_cache_locked, should_fail_alloc_page
    and should_failslab, and that list already included
    btrfs_should_cancel_balance() (called from the btrfs-balance kthread
    via balance_kthread() -> btrfs_balance() -> __btrfs_balance()), as
    well as btrfs_check_node() and btrfs_check_leaf_full() (called from
    the btrfs end-io workers). So bpf_copy_from_user() could be called
    without an mm from the moment it existed, and 07be4c4a3e7a is the
    right commit to blame rather than 423f16108c9d.

