Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97EFC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F446B00D8; Tue,  4 Aug 2026 16:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFCE6B00DA; Tue,  4 Aug 2026 16:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF4E6B00DF; Tue,  4 Aug 2026 16:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42A356B00D8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:25:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB0E81A0173
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:25:29 +0000 (UTC)
X-FDA: 85064717178.24.F588B8B
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 050631C0009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:25:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ioFWyk47;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of utilityemal77@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKkjXnnqGQF2M+u6ias5bB7wHPmpsm3RwoGuV3wwepg=;
	b=MAv0YHfr3G0ePvVPw9aTy2BzKWNGJMsrtsDr8B/w6fyRrD/b6eiZCXgiHl7moY08LjE2CK
	8YlpyMySP6/45F2wBUQwrzrapmH9485buxSjKwyJkl9MNHTMWKiNAtuljrpGA6RDRJOSis
	NlLA9rLDrKjfVE/7bC6HGOzHQJLCAzI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ioFWyk47;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of utilityemal77@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875128;
	b=ZfusvOd6KisEdbtGsAv50JvSschdcq4ybdNE71npWYADV4aHTU4ShFA1yKUVgZ4UQdLgUv
	nBoZ6ZPzdUh2V02ffuvqKh3WQwGgi7XpFXKOX19qPWRABjvIMpNeDg+RgNfPI/HA5W8lIG
	P+dv0KHIkSBbljMkDNl/bUwbJlJVPlA=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-820100e3504so3179967b3.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 13:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785875127; x=1786479927; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NKkjXnnqGQF2M+u6ias5bB7wHPmpsm3RwoGuV3wwepg=;
        b=ioFWyk47aMFGxHVLVQ0F1LwaPw/mOrziUvMkEkORns60FPOmm/IJ097lN+HKVdAtiq
         NjLEdaxSdiRg1lIat0w564IgC7QDxwJH/ogJz9bQtGu/F/VmQlbxcNPYHOYzwbHqmV/I
         FCb6vd3a5o2nBrVCqrio7ik8PgrRmRtuzXXXqvS73iepgluWCvANi5Q80n++3to5/qa9
         zWRUGa3frYRXZNBcvurxQQMsqQOg5LRldz0Ily45cMNSkE0O9ZGJrPkJAlZDYJ27atjI
         lu3yU+G0KGDLvsiNs1kW84HFgHuPpZ2dMPxvZXFrn11XXYqk40ghFQVWoSoAn9ud17vA
         LSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785875127; x=1786479927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NKkjXnnqGQF2M+u6ias5bB7wHPmpsm3RwoGuV3wwepg=;
        b=o/3t48JiD69tmsBtk1H6cL5U5+JlfyE9p9InPr8touedVPYdRRF9UxjmUesNWc5nef
         WzoTKum5AUE6jH9rxTUrWrYhfVdx2sjXU9Fo1czFPwkN/PAtkUB7DH3mQn9YMy0+l6i6
         VDY1gYzrRnhA7hN3DsHlA670AS2krDTua1ferKmdTKAecmR+kAGErjG5jWQir1RdrjWm
         BaDpHsqEUus6hKLj/JPmWeVAz15VyaOVuzF4K85pVl6DB4xPH9F1tML9lWO1PIaRoSxv
         tft6DY7TIRepHPYUo99/Fmx64ham04+prB9Zb7VmO/qhEmvG1cRna/2JvUw0gJYU7x6q
         tmWA==
X-Forwarded-Encrypted: i=1; AHgh+RpwgSRoe+Lua4Pet++vMAybj+z4timTslo99LO2AwIHJOEdwdfkPnTTCknM7Ph8KVuCpyk1sx/rRg==@kvack.org
X-Gm-Message-State: AOJu0YxGK9b3Mg7j5e38hb02iEr+B/B8oIXDUU+sq2IHpRTg+zVQvPHM
	baJzRbXGF0+xlUGIWYNPlVs7cKlCJd1TMq24Xn59q8JrP0Kb5pJUo/SW
X-Gm-Gg: AR+sD117TZ2/RY+3+M6YdOEvgnTst8fpMnfnWP5RCmCiOT2hyoQi4uYav3mlnJjKpi1
	znl19oVuthOJ7h0OEqJbz6Umpi/t17JeaDUMDQ936BlZCx2rjVjU+eaTuUJZPfxl3GEfNf+PF62
	ij3ZIhAOZH9vqOvYjxIZjUgLjflqkS8zRKUldyUUyLSIsq4/XajFd7F17H+0ut1GkjzVHVvM5JI
	NU9+2LQ+BvLZOnr0YqHU6S8bpEiI4V8YACMKVCTOEbqE/VrIoUVLmIFPlIMntRCcaP59JkDGqCu
	Foyv4mWlFNtcGyz79cx55xg5K0BGxv5K861Af7+os8dsAEid4XGEke8qTezvJyHH508/ukJN50F
	mk22HnqemS7R3gyCQqejqmG1q9aAGFu9uiO6xT2Swg2LLnBPlpJzLo9Zp+by1Xqtl5KELyuM3Gb
	6QnpZgrQmVUDhIX7UNMG0i2UHQy+1YZdnP1D4oYt1nYj/+fck1gdBSUvKmgFXJv0vPIHnxFkXSW
	5HEQXgn69xofH9bg2nNXfA=
X-Received: by 2002:a05:690c:6904:b0:80c:b92c:77a9 with SMTP id 00721157ae682-82022293d52mr7702217b3.6.1785875126957;
        Tue, 04 Aug 2026 13:25:26 -0700 (PDT)
Received: from zenbox ([2600:1700:18fb:6011:572c:6770:834b:60f2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-820134ccc5csm11632827b3.43.2026.08.04.13.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 13:25:26 -0700 (PDT)
Date: Tue, 4 Aug 2026 16:25:25 -0400
From: Justin Suess <utilityemal77@gmail.com>
To: Li Chen <me@linux.beauty>
Cc: Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Gabriel Krisman Bertazi <krisman@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, Andy Lutomirski <luto@kernel.org>, 
	John Ericson <mail@johnericson.me>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, audit@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
Message-ID: <anJE8SfBLtkh6QSa@zenbox>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 050631C0009
X-Stat-Signature: qiykoye3ciyzsb86f3j9y77nqe4iwbfs
X-Rspam-User: 
X-HE-Tag: 1785875127-566868
X-HE-Meta: U2FsdGVkX1+XXnJ+fu+bljzOCTVqq0ALwZfIT8xfuQYlpqjqxovI8suMXJm0X1dF8aQZAd1Fhu7rJY9pXWLv23F+hgzKsLQ1qoTFK9qMFzd46AgwOGfuQyRw6Aj6aWARqnwEashQholD6hZH71mETbVmzmIe+ZyggvXYjB3DYzKSaeRCqq8w2FikNp7lnxI9J6ZUTzuGsRfiR+BZbSkZWu3AWuIHRdhf5CLqnxJEb8QinxU+542OwZCYGV7nlKe361D4bzgK6HiIvw8i3XwZ+sg6YaiQDyr5JxxRX1VuZkuVU/TgUg/1Fm4rp6C8vZ21PfGZNZN4+5IOGaVIvK16krhOPCdCUvGdJ1ZxFRVCrZY6xldpe8uWwg6zDDJ97k7p/nyMnp71XC4uSnO7iOQg3azp1qBtk6XEMg4LWHo/jsnQC3LT/sTbdXZJ7noGgyvSrXFTCmVCYYbh6G48X5JAgDHhe5h3Sf0Hr/YztFb1rTQ1XT5WXPJChtGaYwwf/V7xEgQjI8c2CKnTr6bK5x0lSx30GrFwoMTbdjJIGQJDsAGo6C4edDnVwpmc9ofpYKBoLCJO8CqanP9SRRXTarggFy41Mvv2G5WHNL1vsRyqjn+32CNGNrtRNW3NOXrhEbZjjp75+77c7t+KEgVTVh0ZeQTmjc5w4a7iIIQpoV3roVG6TMoW0jUSB9c+I8UzrStib28B/b4tvhvMvIbvX0te7NtCukKJMnHdTFStaZTrKVd5Iiks4a8JLLycZXrc8HtkXP0wZrX3v7sXv2eKqEnHGUj2HAkgLSK074vnBX3Kb1Lt2JnvDQOFjJ5KXqjxnB6e5VJNUTz/TrNzQQ+8ju+mkaAPXYsGHwhvTLjtWINRJpQ61TwGrLJMwBSNd7fBNJd2WoQHmDQQvGqXARWaWg/4I5SLTekiPUgc7Z6niKgvW9Z//hmn8LLzEqDzRRYux3Vth9a6jiwAxoO6DXSfvLE
 Ia7g9QAV
 IH7mBPVJwlDzhnUDFeAa9rsTt83Nw1HyjgPy5+fcmrrOjbSWXe04QDu7eH4Ttzw4zah7DEg6kgyJX721ivIhdJmHPEPCHFM7vrmnYBFQ6AHCB5wUpw1wbXmkUVJzcA0Rr5hineDydYFxliWl6pLQTMpMBgw/KprwhrJDBdOoSu8uExRLGmgGmNdlsyiPtxrjB7WUORqngMgz7E11eZ9IS3ZeGb6hXwvvfWZkBMZbfquCFxZqYXjaWWsALBGTQzZTceXDIn2VfkA0XUFWoxsQYKTVqV0x+zTyEUNfdbdXq7mkTWVr41FExDXzub/yFvUy8WoEUgiHw6RurHrN6TdegRJ0fqHdsZkGNQPy/bgdV98n+qLQKhv+wKzyh2nFqzmMmcEaY9hDmdTGFfS75gu8W/rfKWCSFrSMRbge4ipvVazrZcN+XW/wtlFj/5VT5m2Y9paJVOh4Qncz3HaRZiyEwWjsgjX2XhhhD7q4kXcTeZJTI/nOyUlL+7kwH4Mq0kRznIMd8Bea6mZApKVQWGjVP7xzedKr6k6FrkA5RobgqkdXk2/oiWLYkhUNIU8luHdcpBXwRcuPHpVgJf3JfQd+uMR7KtYnh1DxR9SUkx8nFt6eaHNdy9wjwFefKjVMXzQBsz0hZE1X54bKoPPLjD8rNGI6Z4j0rlbGr1XmCYYzQ8Q86DSsGFkcEumJb73vOGaFFDbRh6zTonUf9RCqaQw+Udtwd6mLQMPXFXDVjgtLk2vQJTODREiOD3FtzX3SktFzHBD/PLlNL+nkZ4MvXqvofJ9yR5SHADMjrrC5h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 10:31:26PM +0800, Li Chen wrote:
> Hi,
> 
> This RFC follows feedback on my earlier spawn_template RFC [1]. That
> proposal made caching the primary interface; this one starts with general
> process construction. Christian suggested a pidfd/pidfs exec builder
> modeled after fsconfig(), with enough semantics for userspace to implement
> posix_spawn() [2], and Kees agreed [3].
> 
> This RFC is based on linux-next next-20260710 and depends on two pidfs
> fixes that I sent separately:
> 
>   * pidfs: preserve thread pidfds reopened by file handle
>     https://lore.kernel.org/all/20260716052726.1032092-1-me@linux.beauty/
>   * pidfs: handle FS_IOC32_GETVERSION in compat ioctl
>     https://lore.kernel.org/all/20260716052822.1034228-1-me@linux.beauty/
> 
> The initial implementation is source-based. The executable path can be
> provided with the final run request:
> 
>     struct pidfd_spawn_run_args run = {
>         .path = (unsigned long)"/usr/bin/rg",
This should probably be an FD for the path.

This way it prevents race conditions over multiple configuration steps.
>         .argv = (unsigned long)argv,
>         .envp = (unsigned long)envp,
>     };
> 
>     fd = pidfd_open(0, PIDFD_EMPTY);
>     pidfd_spawn_run(fd, &run, sizeof(run));
> 
> Alternatively, the path can be staged before the final run step:
> 
>     struct pidfd_spawn_run_args run = {
>         .argv = (unsigned long)argv,
>         .envp = (unsigned long)envp,
>     };
> 
>     fd = pidfd_open(0, PIDFD_EMPTY);
>     pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
>                  PIDFD_CONFIG_KEY_PATH, "/usr/bin/rg", 0);
Same here. Should probably be an FD to the binary instead.

>     pidfd_spawn_run(fd, &run, sizeof(run));
I'm worried this pidfd_spawn_run just adds another varient to the existing
myriad of exec* syscalls we already have. Would it be better to just have this
work through execveat(fd, "", argv, envp, AT_EMPTY_PATH) instead?

(i.e have execveat take a pidfd directly).

Then you can get rid of pidfd_spawn_run which looks almost structurally
identical to execveat (with the argv and envp collapsed).

Justin
> 
> pidfd_open(0, PIDFD_EMPTY) creates a taskless future pidfd with a stable
> pidfs inode, but no task, PID, or process-count charge. pidfd_spawn_run()
> creates the task and PID; after publication the same fd is the child pidfd,
> and a numeric pidfd resolves to the same inode. Live-task operations return
> -ESRCH before publication. A terminal pre-task failure wakes poll/epoll
> with POLLERR | POLLHUP.
> 
> Source-based mode follows posix_spawn-style defaults. At run time it
> samples the caller's cwd, root, umask, fd table, signal dispositions and
> blocked mask, and namespaces.
> Non-FD_CLOEXEC descriptors remain unless an action changes them; file and
> filesystem state are private child copies before actions. Configuration and
> run stay bound to the creating mm_struct, exact credential object, and
> child PID namespace, so SCM_RIGHTS does not delegate launch authority.
> 
> The first authorized run claims the builder before copying its payload, so
> later failures are terminal. Pre-task failure leaves the fd taskless;
> setup or exec failure leaves it as the child pidfd and exits the child with
> status 127. PIDFD_GET_INFO with PIDFD_INFO_EXIT distinguishes them.
> Success returns the positive child PID in the caller's PID namespace.
> 
> The RFC supports ordered DUP2, CLOSE_RANGE, and FCHDIR actions in
> extensible UAPI records. This exercises child-private fd and cwd setup, but
> is not the complete posix_spawn() action or attribute surface.
> 
> Between task publication and successful exec, the child is explicitly
> embryonic and may not have a valid userspace register frame. Ptrace and
> pidfd_getfd() are denied, procfs treats the PID as absent to other tasks,
> and coredump information reports PIDFD_COREDUMP_SKIP. The child can use its
> own proc entries during executable lookup. Setup runs as initial child task
> work, and successful exec releases this state before exec events are
> published.
> 
> Seccomp sees pidfd_spawn_run(), not separate file-action or exec syscalls,
> and cannot inspect the path or action records behind the run pointer. An
> exec-only denylist that allows unknown syscalls therefore does not block
> this initial exec; policy must filter the builder syscall as a unit. Should
> later expansion provide an immutable restriction profile or action mask
> that seccomp can reason about, or is the coarse syscall boundary
> preferable?
> 
> LSM exec checks and inherited seccomp state remain active. Child setup uses
> a dedicated AUDIT_PIDFD_SPAWN transaction, not a synthetic AUDIT_SYSCALL.
> Should it be selected through the source pidfd_spawn_run() exit rule? An
> existing rule naming only execve() or execveat() does not select it.
> For source/child correlation, could an auxiliary record carry
> the source PID plus the stable pidfs inode? An already traced source is
> rejected before the claim; ptrace auto-attach is not implemented.
> 
> The implementation still uses CLONE_VM | CLONE_VFORK plus exec internally.
> Mateusz suggested that an initial implementation might start with vfork to
> get the API off the ground [4]. That is what this RFC does. It does not yet
> construct a pristine target process without first inheriting source state.
> 
> Missing posix_spawn() pieces include open and close file actions, resetids,
> signal masks/defaults, process groups, sessions, scheduler attributes,
> affinity, cgroup placement, PATH lookup/posix_spawnp(), and exec by fd. The
> RFC also does not include pristine/no-source creation or the executable
> metadata/template cache from my earlier work.
> 
> John Ericson described a real, partially initialized process that remains
> unscheduled while callers install its state, and linked an exploratory
> FreeBSD proc_new()/proc_setfd()/proc_start() refactoring [5]. This RFC
> implements the source-based mode first; a lower-authority pristine/no-source
> mode would be explicit follow-up work.
> 
> Direct process construction is not unprecedented. XNU's posix_spawn path
> does not inherit the parent's address space [6], and Windows
> CreateProcess() accepts explicit startup state [7]. Josh's io_uring_spawn
> LPC slides list "set up process from scratch" as future work and provide
> useful performance context [8]; I am not using those numbers as a claim for
> this RFC.
> 
> If the direction is acceptable, I plan to continue toward:
> 
>   * the complete file-action and attribute set needed by posix_spawn();
>   * pristine target-process construction and an explicit no-source mode;
>   * PATH/posix_spawnp support, if it belongs on the kernel side; and
>   * an optional executable/template layer for workloads such as agent tool
>     calling and compiler drivers.
> 
> The exposed UAPI surface is intentionally limited so the state model and
> kernel/userspace boundary can be reviewed first. If maintainers would
> prefer more posix_spawn semantics or backend work in this RFC, please say
> so and I will adjust the split.
> 
> Codex GPT-5.5 and GPT-5.6-sol provided substantial assistance across design
> conceptualization, implementation, patch splitting, code review, development
> of self-test cases, and test planning and execution.
> 
> Thanks to Christian, Kees, Mateusz, Gabriel, Josh, Andy, John, and others
> for the review and direction.
> 
> [1]: https://patchew.org/linux/20260528095235.2491226-1-me%40linux.beauty/
> [2]: https://lore.kernel.org/all/20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner/
> [3]: https://lore.kernel.org/all/202606011254.5FCBD65@keescook/
> [4]: https://lore.kernel.org/all/vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt/
> [5]: https://lore.kernel.org/all/ce71d6df-6851-4e4b-9603-1d55d8d522b8@app.fastmail.com/
> [6]: https://github.com/apple-oss-distributions/xnu/blob/f6217f891ac0bb64f3d375211650a4c1ff8ca1ea/bsd/kern/kern_exec.c#L4039
> [7]: https://learn.microsoft.com/en-us/windows/win32/procthread/creating-processes
> [8]: https://lpc.events/event/16/contributions/1213/attachments/1012/1945/io-uring-spawn.pdf
> 
> 
> Li Chen (24):
>   pidfd: add spawn builder uapi
>   libfs: allow custom validation of stashed inode data
>   pidfs: add taskless future pidfd inodes
>   pidfd: create taskless spawn builders
>   pidfd: add spawn builder path configuration
>   exec: expose execveat internals to process builders
>   fork: expose vfork completion helper
>   pidfs: attach pids to future pidfd files
>   fork: let process builders supply preallocated pids
>   pidfs: publish future pidfd files
>   pidfd: add spawn builder state tracking
>   fork: let kernel callers create embryonic tasks
>   fork: let new tasks start with task work
>   pidfd: create and execute spawn builder tasks
>   fork: keep embryonic tasks hidden until exec completes
>   audit: add pidfd spawn child contexts
>   pidfd: audit child spawn execution
>   pidfd: make spawn builder execution signal-safe
>   file: expose spawn file-action helpers
>   pidfd: add initial spawn file actions
>   pidfd: consume spawn builders on the first run attempt
>   pidfd: expose spawn builder system calls
>   selftests/pidfd: cover pidfd spawn builders
>   Documentation: describe pidfd spawn builders
> 
>  Documentation/userspace-api/index.rst         |    1 +
>  Documentation/userspace-api/pidfd_spawn.rst   |  247 ++++
>  MAINTAINERS                                   |    6 +
>  arch/alpha/kernel/syscalls/syscall.tbl        |    2 +
>  arch/arm/tools/syscall.tbl                    |    2 +
>  arch/arm64/tools/syscall_32.tbl               |    2 +
>  arch/m68k/kernel/syscalls/syscall.tbl         |    2 +
>  arch/microblaze/kernel/syscalls/syscall.tbl   |    2 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl     |    2 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl     |    2 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl     |    2 +
>  arch/parisc/kernel/syscalls/syscall.tbl       |    2 +
>  arch/powerpc/kernel/syscalls/syscall.tbl      |    2 +
>  arch/s390/kernel/syscalls/syscall.tbl         |    2 +
>  arch/sh/kernel/syscalls/syscall.tbl           |    2 +
>  arch/sparc/kernel/syscalls/syscall.tbl        |    2 +
>  arch/x86/entry/syscalls/syscall_32.tbl        |    2 +
>  arch/x86/entry/syscalls/syscall_64.tbl        |    2 +
>  arch/xtensa/kernel/syscalls/syscall.tbl       |    2 +
>  fs/Makefile                                   |    2 +-
>  fs/coredump.c                                 |    4 +-
>  fs/exec.c                                     |   30 +-
>  fs/exec_internal.h                            |   40 +
>  fs/file.c                                     |   11 +-
>  fs/internal.h                                 |    3 +
>  fs/libfs.c                                    |    5 +-
>  fs/open.c                                     |    7 +-
>  fs/pidfd_spawn.c                              | 1095 +++++++++++++++
>  fs/pidfs.c                                    |  478 ++++++-
>  fs/proc/base.c                                |   11 +-
>  fs/proc/internal.h                            |   18 +-
>  include/linux/audit.h                         |   31 +
>  include/linux/pid.h                           |   13 +
>  include/linux/pidfd_spawn.h                   |    9 +
>  include/linux/pidfs.h                         |   28 +
>  include/linux/sched.h                         |   21 +
>  include/linux/sched/task.h                    |    6 +
>  include/linux/syscalls.h                      |    7 +
>  include/uapi/asm-generic/unistd.h             |    8 +-
>  include/uapi/linux/audit.h                    |    1 +
>  include/uapi/linux/pidfd.h                    |    1 +
>  include/uapi/linux/pidfd_spawn.h              |   49 +
>  kernel/audit.h                                |    1 +
>  kernel/auditsc.c                              |  105 +-
>  kernel/fork.c                                 |   26 +-
>  kernel/nsproxy.c                              |   11 +-
>  kernel/pid.c                                  |   41 +-
>  kernel/ptrace.c                               |    4 +
>  kernel/signal.c                               |    2 +-
>  scripts/syscall.tbl                           |    2 +
>  tools/include/uapi/asm-generic/unistd.h       |    8 +-
>  tools/include/uapi/linux/pidfd_spawn.h        |   49 +
>  .../arch/alpha/entry/syscalls/syscall.tbl     |    2 +
>  .../perf/arch/arm/entry/syscalls/syscall.tbl  |    2 +
>  .../arch/arm64/entry/syscalls/syscall_32.tbl  |   11 +
>  .../arch/mips/entry/syscalls/syscall_n64.tbl  |    2 +
>  .../arch/parisc/entry/syscalls/syscall.tbl    |    2 +
>  .../arch/powerpc/entry/syscalls/syscall.tbl   |    2 +
>  .../perf/arch/s390/entry/syscalls/syscall.tbl |    2 +
>  tools/perf/arch/sh/entry/syscalls/syscall.tbl |    2 +
>  .../arch/sparc/entry/syscalls/syscall.tbl     |    2 +
>  .../arch/x86/entry/syscalls/syscall_32.tbl    |    2 +
>  .../arch/x86/entry/syscalls/syscall_64.tbl    |    2 +
>  .../arch/xtensa/entry/syscalls/syscall.tbl    |    2 +
>  tools/scripts/syscall.tbl                     |    2 +
>  tools/testing/selftests/landlock/audit.h      |    6 +-
>  tools/testing/selftests/pidfd/.gitignore      |    9 +
>  tools/testing/selftests/pidfd/Makefile        |   25 +-
>  tools/testing/selftests/pidfd/config          |    6 +
>  .../pidfd/pidfd_spawn_accounting_test.c       |  428 ++++++
>  .../pidfd/pidfd_spawn_actions_test.c          |  474 +++++++
>  .../selftests/pidfd/pidfd_spawn_audit_test.c  |  521 +++++++
>  .../selftests/pidfd/pidfd_spawn_common.c      |  512 +++++++
>  .../selftests/pidfd/pidfd_spawn_common.h      |   59 +
>  .../selftests/pidfd/pidfd_spawn_compat.c      |  221 +++
>  .../selftests/pidfd/pidfd_spawn_exec_test.c   |  301 ++++
>  .../selftests/pidfd/pidfd_spawn_policy_test.c |  294 ++++
>  .../selftests/pidfd/pidfd_spawn_race_test.c   |  923 ++++++++++++
>  .../pidfd/pidfd_spawn_security_test.c         | 1242 +++++++++++++++++
>  .../selftests/pidfd/pidfd_spawn_test.c        |  550 ++++++++
>  80 files changed, 7938 insertions(+), 81 deletions(-)
>  create mode 100644 Documentation/userspace-api/pidfd_spawn.rst
>  create mode 100644 fs/exec_internal.h
>  create mode 100644 fs/pidfd_spawn.c
>  create mode 100644 include/linux/pidfd_spawn.h
>  create mode 100644 include/uapi/linux/pidfd_spawn.h
>  create mode 100644 tools/include/uapi/linux/pidfd_spawn.h
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.h
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_compat.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_race_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_security_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_test.c
> 
> -- 
> 2.52.0
> 

