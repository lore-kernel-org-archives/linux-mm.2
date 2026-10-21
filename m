Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2F5606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AxZTXpap
Received: by kanga.kvack.org (Postfix)
	id 37FCB6B025F; Wed, 21 Oct 2026 17:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A126B0261; Wed, 21 Oct 2026 17:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5266B026E; Wed, 21 Oct 2026 17:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9BC16B025F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:53:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A995A03E1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:53:52 +0000 (UTC)
X-FDA: 85347986304.28.3EE2DFC
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DA4640002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:53:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AxZTXpap;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792619630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtRYkql7bK2+Mk9/MALlnk6mIy+nScSi0K/oMYikPEc=;
	b=k+WulmvHlsCWUyciHfSjyhWUT9ni6OIAWFLE/6nDG/AA1wAvZz+A5VKdTWgMliWCJ4mCDd
	bLos4mDr824zIGS470V2Aw0X8qXIycCer6n2B1jJR2fLXwAUkc1xxZ/HAyVMd8F2w+U7k6
	z6QfmcMoSMWjlTu/Y8ETfJxzkgE2u7o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AxZTXpap;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792619630;
	b=NerMMC76gDDXzLvjx8JwQqVWscOJDr4DUcMpk6bKQEHyQ79sP162krsy6oJWQLjnXG+vIM
	pqHr0oqfgppzrm2KlJVH+WEKFQ2DCffZ0J5Fz8hmwDeesuEte6uN559OAZYI4HQuGifhoM
	pP8JKeLKMBSNuAFZ/TbKT+/A9zQj6nU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a06e79e152so531526b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792619629; x=1793224429; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mtRYkql7bK2+Mk9/MALlnk6mIy+nScSi0K/oMYikPEc=;
        b=AxZTXpaphumknMknAfdcpv7Qhp1KylxAxYAcXmORZp6a2MH26wIwhjWy3pOgXwk/YK
         qgLWAsmHCbkWsHOQu7e3TVRDkATIhcU2zdxKkV0pn+KI/hYZLgvrXGJBuUa+83g/vx28
         0ymOfRPGR86rm2hUGOL7WV63NTzMbFLCk69kBd0z397mfwxjbpOGw9s9KztuXH3SL4cD
         IHUaASufyWDlTmn7H4xhwzl3kvQ/feBEf6fks4aONgGb6ILdJwZ1qbUNHvK1r9QDtXDZ
         85PSo3/ulb9+CKI+8FqlfqNfjYoWjJ0Ug8yPwFF6UckOonro2hHznvKcK30dxiwLGBw/
         MqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792619629; x=1793224429;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mtRYkql7bK2+Mk9/MALlnk6mIy+nScSi0K/oMYikPEc=;
        b=VxLxLWZgxh7/hRSA8nEusMDB3vNHXOAsCE7kH6evtWGmhPHLcbfIBe3irTWZcX76rY
         clXVfhb1LDNFJ2hFfB3jzeWHYalwN3MwilbjQMlB4HwdqD90QsHgUWcYsQa3YBoPrQ27
         GxRL7GO9FqZhFkDPlGM3JJZLlv0slKyd6SJYEzHqvIQ0VEJlo+YIBKfakbT+rhjb3OSY
         GRh756EdLyMxOkMEPKiNM+fSIjrMZD/yv+OHaGVmwiYsb+lI0adVyKe3ZlyU2faiJTrN
         hgENK6SygNBKFSbpWXDieK0FOWYqdG9e9tcrpXb5EDPwM3ENjoJZqTuFhyClWnonZD1m
         2j4A==
X-Forwarded-Encrypted: i=1; AKwUvBzTpP+SZFcAvU3hfKFX7dM02iXOKq20tEopuM/OgaIeUOi21o05+bOOc7+s1u8JrBARwbC27n9J5A==@kvack.org
X-Gm-Message-State: AFq9FYIN9hJWoR0yeISM82WSdVqIimVLv6zvYgUfnogcHlokB8pFSqq1
	mTkpd/PYlGtihlRkoxmxiKfC82R5s6W4hN6jejfMD2G/bbXGf5aAHPq7
X-Gm-Gg: AYBFou0pDV8begGl/X852Xk65O6wgDF33Gc8rwpTnJD98XLjwOI5gvpfFKPaBVaapY2
	pFpUniqwYGf4EgLKhM4LsvHPMVLpSMp0hrL7JCwd0eBJzDLvidxpUhfC4PRY1KMdWOoiZcPlkwq
	1qZ/YrqZcjU72+pVRe26QWqhNpQOsG0dSx9/dDo2WJsaQVfMtw/pKUGjd45U2v6qo33o86/XvHA
	Oa4XcFmFIX4RdfUn7yfDXQ5bcf8Y4vmNegrZTRTWpS0YOPh7kf3YtBlTDVOXW22w7JsUG0WZbWs
	srjK0b+//Nbt1+tMLLeRVlCe8qxWvsIalTIHdbh/g0QkwlF+fdZAnu2PnEp36ZOnPoPc2wbo0Im
	MHO/0wmxDrhO9Kk2/JjaUUfclHaxvyLfnD4yEuX+x4XdzRdeE6Du8y7ye8PINzCLLRGHFqoZCTx
	e13Z0w5jRWK5oOMDONv0P6E//PKmj2Z25+5QzyNMlKH6ZpptpO50Yc2HVysB2M+cgTEo1ptybtV
	31qjJ84BbblmiBWkek4WCYFRujwUV+FTl2uHivTCO3QR3I1ICEnTIhIhpyIeQyKbaQmR4JnghTM
	xW5eReHyeGkDLrTFx0fU9utkM6B1fV1RDkZLE/GLPpsAvyQ8Domb1FY7CQB3uA==
X-Received: by 2002:a05:6a21:4ea3:b0:3e1:885f:b4ab with SMTP id adf61e73a8af0-3e287bca4bbmr2324254637.8.1792619629160;
        Wed, 21 Oct 2026 14:53:49 -0700 (PDT)
Received: from localhost ([153.61.198.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895f8ca3sm1297288b3a.46.2026.10.21.14.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 14:53:48 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Oct 2026 21:53:47 +0000
Message-Id: <DMAUMG9WL4X6.12UEJJMJSW54Z@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jiri Olsa" <jolsa@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>
Cc: <bpf@vger.kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, <linux-mm@kvack.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, <linux-kselftest@vger.kernel.org>,
 "Shuah Khan" <shuah@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 0/9] bpf: Add support to allocate user page
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 7DA4640002
X-Rspam-User: 
X-Stat-Signature: y5y49yhgat7twjq6egehwiicn5w1jwnr
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792619630-55632
X-HE-Meta: U2FsdGVkX18tS0lss8GrquaBdRwfQycklvgMpFtTidIw7/m329u8Vakmjvrm3ZUUC3q7SpxlMeZYwVlOy2K63Ug6NtCe6MdGt1bZMrLDZwigi6/GIgcpcV7j2hID+iAOzMuJzuE6Kw4LzPk5KKbt/u1JT8J7arc8ovPfb+oC9MJExBT6XWYijseCxjba8I2FP6s1KXp9/E9Y0CkZI6IcbASuPXPeEIeTL9dZ3RUMK4W+CiNnYkZmHUjNJZOABQhRp6O7DIElkZAJpgjPXkP70R+ZjNzUgJfFfwiD/rgz0UoQhsDiKcj5UYjjlffemclEYLObHwvwucKRP4u3RUDUZXCg2+jXfgWMDCxg3k4lseRk2isTz2X6F31nJ+ISo9kA9jQKPRFgLGBd3TfdF67FJadCX1GeMO62m1LlQmx8cHrku02E281x9Fhoa3oaAUD7M5SXJ2nzmPBqrximJDGlcFJWaoRT5fzzmyOXdSGbEK1cTH+xAqkGe5xxRNKiwRbYTFw2Wq+VIzWw/Rl80Abrxz4WFJYhRE1yc1afFezpqi9+XvnIvzgwNJiBoOLPoalQ7gdMLgFmEvf8zvkr3nnU/HY7+9R8dRVHSJan4Erfr9y0uxEoEOPrNJn0eb4+GXs/ervcXtTqi1ON0551NcBsNuGvm5nws1HFWf3tqObTbXw5Ob21FCRmhFFcaNvw1nsbGgRYp1e3u0My0uWur9Ux+TIFgAFodrvcu7ipRfbqCYY3zj+GYz0Z1bYWemSld/pDt5Qi5EfGRULcO+OdFDDAnp16Iem0fHXhMUQvNuUByAeDKpnROsZGHvxhQyOAHyikJIRSdGjwChx1DJUBsfwFNx5mxuS4ba5OPBwYeLTUZ7URaLgDQEqGNunSQdAS03osZ4MNordLcAVOGxnieFzBLyPKv1maAxLE/6Lj/3UZXknuFJSaokhLj0j5UrGzQ7IcVS9fDXQhAINc3/pcOfa
 6KEFfkB3
 PqfncHV7y+6q/f7RUBDcY/Axc1c4oNHk54xC7/dppsZ5rXT6pINIWa0DzZOMTFxTy0ab/qDa9D2pa5ZM+GC0PTLSGOVG45zRZVZa5QsWi21qqRorfv69OiegRj89bKNqBnLAIwM/aloEWOoaMTlu7q59C3s6MujykssHlXZFWyCdiQkQ5YqXq/hJ24uW9vtjI66+LY8HB1dB17vEF6dwgld9Mc63TLpjWsZwZUNHisnRxubFWv9ZOTVQiMbfwwsy5wVQjSaSkvyyCwxxxDh+9aU0AuF8Q5re6dIIpcFuCmJsGi9aAt6mFT0mGOzGxlJkzOFIX+C7x2maMs7IS/4AxYN7/fCXg/Kprcbg9ryjxIuq8A2fqGYYdbm216eUtkpYfp75eI7KzEHB0ikCVvLjOOwHZTRe1thUUJZ6d0SvZ+bryLSrhXc6vML4Q/UBz+QNBMP+O6Ds9A7P81AffGStgjDl+ewpdB9vfmvxLubITX85i9cPlhwV2U1YbfP/i9xhhHNwY/jHaRBVthXXBvGPwvzuh4Q27yIBvNJmjJH4BAQWJ3jzRIY+9WE1niDKvlVFK+/ZyxWR8jda1UJhpfJrtC9UkBwd+hDoFzyznrftHvtS7+qU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 12:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
> hi,
> we have few use cases where having the ability to allocate normal
> or executable user space memory would help (like to replace function
> in live process or change environment variables)

I think it's better to do what debuggers do:
vm_mmap() with the final prot and
access_process_vm(FOLL_FORCE | FOLL_WRITE), like PTRACE_POKETEXT,
to fill it. It faults the pages in, writes into r-x private mapping
and copy_to_user_page() takes care of icache.
Then no need for bpf_user_page_exec(), do_mprotect_pkey_locked(),
the marker, READ_IMPLIES_EXEC special case, get_user_pages(), etc.
No mm changes.

Like:

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 648abe1..ca1d88d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,6 +29,7 @@
 #include <linux/task_work.h>
 #include <linux/irq_work.h>
 #include <linux/buildid.h>
+#include <linux/mman.h>

 #include "../../lib/kstrtox.h"

@@ -3834,6 +3835,60 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 	return ret;
 }

+/**
+ * bpf_copy_to_user_task() - Copy data to a task's address space
+ * @unsafe_ptr__ign: Destination address in the task's address space
+ * @src:             Source address, in kernel space
+ * @src__sz:         Number of bytes to copy
+ * @tsk:             The task whose address space will be used
+ * @flags:           Reserved for future use; must be zero
+ *
+ * Faults in the destination and writes the way ptrace(PTRACE_POKETEXT) does:
+ * a private mapping doesn't have to be writable.
+ *
+ * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
+ * fails or is partial.
+ */
+__bpf_kfunc int bpf_copy_to_user_task(void __user *unsafe_ptr__ign, const void *src,
+				      u32 src__sz, struct task_struct *tsk, u64 flags)
+{
+	int ret;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (unlikely(!src__sz))
+		return 0;
+
+	ret = access_process_vm(tsk, (unsigned long)unsafe_ptr__ign, (void *)src,
+				src__sz, FOLL_FORCE | FOLL_WRITE);
+	return ret == src__sz ? 0 : -EFAULT;
+}
+
+/**
+ * bpf_user_mmap() - Map private anonymous memory into the current process
+ * @len:  Length of the mapping
+ * @prot: PROT_* flags of mmap(2)
+ *
+ * Return: The address of the mapping on success, or a negative error code.
+ */
+__bpf_kfunc long bpf_user_mmap(unsigned long len, unsigned long prot)
+{
+	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+}
+
+/**
+ * bpf_user_munmap() - Unmap a range of addresses of the current process
+ * @addr: Start of the range
+ * @len:  Length of the range
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+__bpf_kfunc int bpf_user_munmap(unsigned long addr, unsigned long len)
+{
+	return vm_munmap(addr, len);
+}
+
 /* Keep unsigned long in prototype so that kfunc is usable when emitted to
  * vmlinux.h in BPF programs directly, but note that while in BPF prog, the
  * unsigned long always points to 8-byte region on stack, the kernel may only
@@ -5139,6 +5194,25 @@ static const struct btf_kfunc_id_set generic_kfunc_set = {
 	.set   = &generic_btf_ids,
 };

+BTF_KFUNCS_START(user_mem_btf_ids)
+BTF_ID_FLAGS(func, bpf_copy_to_user_task, KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_user_mmap, KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_user_munmap, KF_SLEEPABLE | KF_PERFMON)
+BTF_KFUNCS_END(user_mem_btf_ids)
+
+static int user_mem_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (!btf_id_set8_contains(&user_mem_btf_ids, kfunc_id))
+		return 0;
+	return security_locked_down(LOCKDOWN_BPF_WRITE_USER);
+}
+
+static const struct btf_kfunc_id_set user_mem_kfunc_set = {
+	.owner  = THIS_MODULE,
+	.set    = &user_mem_btf_ids,
+	.filter = user_mem_kfunc_filter,
+};
+
 BTF_ID_LIST(generic_dtor_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(func, bpf_task_release_dtor)
@@ -5266,6 +5340,8 @@ static int __init kfunc_init(void)
 	};

 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &generic_kfunc_set);
+	/* Sleepable kprobe prog can only be attached to uprobe */
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_KPROBE, &user_mem_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &generic_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &generic_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &generic_kfunc_set);

But I'm not at all sure that it's a good idea
to inject code into a process.

pw-bot: cr

