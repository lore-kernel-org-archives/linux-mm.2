Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3549ACD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969B16B008C; Wed, 10 Jun 2026 19:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9411E6B0092; Wed, 10 Jun 2026 19:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856E16B0093; Wed, 10 Jun 2026 19:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 761CF6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:41:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B1BC1C187B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:41:07 +0000 (UTC)
X-FDA: 84865626174.01.24F9EA0
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2EAC816000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:41:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cUa6p8YN;
	spf=pass (imf08.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781134865;
	b=VFvEsGFDPXXBBZaijFuLYJfXnKaWUBQ8ms2WERRNBwxDWoZgTeBd5Z6pxy6ybM+yWf2ll0
	W2HezYvTcEK+rh+ofhBR1wCW3Jf5RArDCLdSUX3ZoWYy4yRlrPpfFuaqOfxFYKo4INeU4K
	nufReM2Hduuv/h9Imw1KOX3UIezNKq8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cUa6p8YN;
	spf=pass (imf08.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781134865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hItbBwzE/UemJbPm5Fn7DOlYpjoWK0GBfBYmIwvZBe8=;
	b=ezt08xCwIZUsr5OksnkYbm1wRdqydJMUFG09YbUNkJ8NennI6XlahrsR9i7zqDxMPaxFLZ
	TSuhafudeaGf3bm/bm3UPRq+mis8BFoZfixEoWpS3m7O9Zwl9dA7iYuSTNNkziL7n+QYe1
	Xva+H9QCDP0WhD3mEbompUKE1NPwHc0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso2607545e9.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781134863; x=1781739663; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hItbBwzE/UemJbPm5Fn7DOlYpjoWK0GBfBYmIwvZBe8=;
        b=cUa6p8YN1A5ZQhGUCPFk1G0wsD8v/gwxMTYaBPxANbWgM5Gk5akMKnrrQE9xo/gaM9
         wzihCYrT3702nQa3scv7YFG+WT3Rctp2/yDOfmgt6T+RWjmqQvkdV/aXahXdHfFRKBTA
         21UNo3cCPTqSSHO3Y0pSSkhX0jjhCDL9udnJBXQh9qqKUrn08CXFOQyOZTgVw0o401q/
         Vd7m1czRpxU0w1vCbRPI/ads0MCTQmTAvXh48S+kxXxahGtfB3/q2mlkJJIwFRy/IWdm
         3EwJUnObGXmjeDwY65y03l7HeZpuvUp4fW36FsGx7PEW0plc7vIa8z7HJDI91/xC3gDE
         bVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781134863; x=1781739663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hItbBwzE/UemJbPm5Fn7DOlYpjoWK0GBfBYmIwvZBe8=;
        b=OxSOncMJcmCiKLZA6Mdc9v4tql77tLkvGD0X22LvKUOEkyt4LCFYU4Qsw+EJjYThdy
         /PrQwuo/PmwWZEP5RSMP31eynQDXndghgpY206noSd9oPArZQaDUVW0SMrbRncjf+Rgg
         SROj+Ob7YblLJyVF6SzBTbjW/wLLJtW3w1T89uPnsV6ikGJsHXsZ78mjvnhHdWwSuiGD
         l1pNV6b1ji0kmFAsQOQhuYVnf/wJUf/ZXAbANENkWJm2AoEKrfgXev8iNhi8vk53+ztx
         qJ/R7I8EwisQQtrQyzYe+6YYdJXXCtTNvu4LgWCYAb24TQgjzL7Tklm8IH5KwD7+19w/
         KxPQ==
X-Forwarded-Encrypted: i=1; AFNElJ97qO8ZWEbkmtgoH2I1oATNv28GvPwWnktgnMCU5t+Yoi56RmHuNhZn3qUdouDKOOa5twx/5UY6JA==@kvack.org
X-Gm-Message-State: AOJu0Yx+Gt5Mc7eyMfXUidlb5BqXwo1FxqHLofO73mMkIQuF+j00aYcj
	IJxbvcSThzx2K99g1AhuLBjhzWYqqGBc9Qiu4x89IMWWocS18qP9L3XV
X-Gm-Gg: Acq92OG0iQGEY3RGnZxFxMXxNgXW6BZ3HoQAEzI24/TFu52PcO4LUVZhT3GLZdNhA4a
	9fZ6kh58S5xukbH3ymn6WknhOmCGpAg398BdVISOtpIPmT2kWo1s+nUrAuNxfhpEjMzvmiUSin2
	SS4c/fhTNyyFUXq4PvtZ4RPyh/LVZpyg2iIV9zbyzj2GTX3tAYzdnk03DMkvemkDl5NNJ8rWMXh
	Imq788uR07BrpZtAHnj/KXvCD8h3yDd75maZSYfH0rBKDRXJ4Vb9J7lvxbwjPqKGNHuozIpKtI/
	ma6SPQajq6MU5VxecH6inSJ8/TDJlBMlnfn/NqxeT67snUeeBjOQpf4OdKmDP/GVt7fqxMccpMb
	lUTBRwQu4/gGUj7Wh2SUa8EZ8K4cxHtupQbIqNHLhxc3JNmM3f+ybNqDed7LPNVBEqum8tc2ah+
	MKRBCOBxFpLXAzVMeotokN13V4K+Ni1BUfanKiOYRmHhF9LMImDdoaWKI2rUfmYKkeVa+lzP0nD
	IVinP4gxw==
X-Received: by 2002:a05:600c:1554:b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-490e5318363mr872135e9.15.1781134863322;
        Wed, 10 Jun 2026 16:41:03 -0700 (PDT)
Received: from f (cst-prg-85-110.cust.vodafone.cz. [46.135.85.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e422e321sm4497435e9.0.2026.06.10.16.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 16:41:02 -0700 (PDT)
Date: Thu, 11 Jun 2026 01:40:56 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Li Chen <me@linux.beauty>
Cc: John Ericson <mail@johnericson.me>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	linux-arch <linux-arch@vger.kernel.org>, linux-doc <linux-doc@vger.kernel.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>, x86 <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <hd3i6pxxohsjesyid7nhuic6ppp6nyoxxpwa4mny6riqvpyqec@mylfprni2yaw>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
 <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
 <19eacd64508.26b92c022125848.262962729296162879@linux.beauty>
 <4e049396-377d-48a7-a34c-91318413a876@app.fastmail.com>
 <19eb181fdd4.6d028f442844776.3737831021032223216@linux.beauty>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19eb181fdd4.6d028f442844776.3737831021032223216@linux.beauty>
X-Rspamd-Queue-Id: 2EAC816000C
X-Stat-Signature: or4q7pt5q4nfe39s38g1b4fd5dy6qg56
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781134864-126548
X-HE-Meta: U2FsdGVkX19kZusPAQ3shqNxJBp3rKFtC5K0CXpBh9WiIWIE9Q5ZyPAJ8dtpEluxHsDGX/Yg+Mrq6hMWzEjFgfGUJ6u84qqkd13xo6r8rP8h94ZPrUkb9uGirfrqsdBCUI4/gT6F/8cH0EYBz7UbtdGJR9V098sL1+ptLUPOn3Qb0boFvGTyTZaK+2LOJi8x0OICeFQaAYY6LYSr6mUd3miok9Y78+v/YwznAECzSI6+n+61xiR9/WzAPZRncmRstTgyJYgkVYd1FPyMs5CMpoiCaJcP+/IlDR2Otv5iHm2/vLxkU5bdSbR1YEzxqfzOQMwQlpLkTNd0gqBmQK5pe/7+y6hrwU4g+nN0i0G0dLXRlp53XUG/SYsoa97RF3qMYck+gdhpc8RehECeazj/80s7HOvFCgSYSnU7zMD1mtUfqm80QvfwB2dqzjw9AAN0IFoDr5anaNG5FyP6bUrrX7JmPOJMrorkz8iLtZDQK5DammPFYULkGJOfBgOTklLYy8dyZ1TFwyso9nDK2npHTYuowcQ797F0gKjSqZdXs5XNbWwknffNJwP4+KQkKgq2VZJ0oa6t0fwdn4EUqLBbqm8OUQBUUmaskdrrPAOC8IrC6uzcU1+KRO01FiCB4JQQFq4j8x0uD9VsjUQIfa6Ws9Ctb4EA9qUezk6Md6Brgws5kEX75eKB3/qMDfoZsyybLOgDONc+0he26qCPMovO/I0f6i4eeHkO3W8KSwtk8CIplRQxzuAGzI2hc3ZHAN7z4d06XErbUbR36HFluQyjzZkfFa+eQi07mycAiH7/+gAeISNmP+CLrdku2mf5fQZ05eDs/Y4hsiC5e/GTl6rUYsWOBYl9keNanVLvJ5Pe+uzoQEaHZ0CmuECpD6qm8WWGBrjJn8bPxi0uUnsRbfgt7cjX2TQkKmz9jOvO/yXp7Go6wZNNqzOMLirewzUNq6Ig8VulVoA59sH6++Xy0YB
 L1cJgm9c
 QIlKaNugVypPik4Zm/8vaOGdS8CGVekD6K/vK/N2plOua+OGHZfqZPygXcBEkGDaNyF3BpXwl9a01VDEABKtEJtI7oV05x+iVaXm40GIGYB6jkDvPaxotme/czYH/dxplhUFMMg+L1TgGhOoZvwYdM2OFq9tyZihp53ZTGbwP9CiZgQYA2HQTZiz7So3JtrolpHlqph9X7ikadaN92pzEAwhhb3chXQ7THcqDIdYtnKEqYEuJBzhJeLtSJMVoD5/ug9x0JxBMYl1oTQLiWfdbX5bjPuuDlmfjJq+ofL+KEQWPGPSbV8u0Svt+NknpBec/dX7JgxBM8n1WfUweDhrx69g9hPX5+qzOBe1JKt0qzipkROHSe6Wdv4AL0uL/oIoF66jDvRy3SGbu3MQfPYLsB1PrrDXP5bv1KmrOm3bBg46a7BbyTR9F8XG4Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 08:29:06PM +0800, Li Chen wrote:
>  ---- On Wed, 10 Jun 2026 01:27:47 +0800  John Ericson <mail@johnericson.me> wrote --- 
>  > Hope the above answers your question? I suppose my ideas lean more on the
>  > "future" than "empty" side --- there is indeed a thread in the thread group,
>  > with real VM/namespace/file descriptor etc. state. Moreover, state gets
>  > initialized before the process is started, so the actual start is a pretty
>  > lightweight step of just letting the scheduler know the now-ready process can
>  > be scheduled. The only thing that distinguishes the embryonic process from a
>  > real one is simply that it isn't running --- i.e. isn't (yet) available to be
>  > scheduled --- so the pidfds holders are free to poke at its state.
>  > 
> 
> Thanks, this helped a lot. I looked at FreeBSD/OpenBSD/XNU after your
> note. FreeBSD has P_INEXEC, OpenBSD has PS_INEXEC, and XNU seems even
> closer with P_LINTRANSIT, described as "process in exec or in creation".
> Linux does not seem to have a single equivalent today: current->in_execve
> is only an LSM hint, while the real synchronization is spread across
> exec_update_lock, cred_guard_mutex, and the exec path.
> 
> I am switching my local WIP from the two-fd builder model to one fd,
> closer to Christian's sketch:
> 
> fd = pidfd_open(0, PIDFD_EMPTY);
> pidfd_config(fd, ...);
> pidfd_spawn_run(fd, ...);
> 
> In my current local version, I still use copy_process(), so the fd points
> at a real task_struct/pid that is not woken until run. Following
> Christian's point that existing APIs can handle this not-yet-running case
> with ESRCH, I currently make ordinary pidfd operations that need a real
> started process return -ESRCH before start.
> 
> I am not sure yet whether Linux should grow a general exec/creation
> transition state like that, or whether a narrower future-process
> lifecycle is enough for this API. I will think more about that when
> working on the pristine process version.
> 

As I tried to explain in my previous e-mail this approach does not cut
it because of NUMA.

Suppose you have a machine with 2 nodes. The parent-to-be is running
on node 0 and the child is intended to exec something on node 1.

When the parent-to-be allocates and populates stuff, it takes place with
memory backed by node 0. If you allocate task_struct, the file table and
other frequently used (and modified!) objs in this way, you are
guaranteeing performance loss due to interconnect traffic to access it.

Trying to add plumbing so that all allocations respect numa placement is
probably too cumbersome.

The primary example for that is looking up the binary to exec in the
first place.

userspace likes to pass paths which don't exist, meaning checking for
the binary before any hard work is a useful optimizaiton. Suppose the
binary to be executed is in a container bound with a taskset using
node 1 and the content of the fs part of the container is currently
fully uncached.

When you perform the lookup on node 0, you are populating a bunch of
metadata (inode, dentry) using memory from that domain. But the intended
user will only execute on node 1, again resulting in a performance loss.

In order to not do it you would need to convince VFS to allocate memory
elsewhere.

So I stand by my previous claim that ultimately a pristine child has to
be created (like in this patch), but which also has to do the work on
its own.

Suppose there is no explicit placement requested anywhere. Even in that
case there are legitimate workloads which will eventually be forced to
exec stuff on another node. Even these have a better chance retaining
full locality if the child process does all the work.

Per my previous message I don't see a clean interface to do it.
something quasi-posix_spawn is probably the least bad way out, it will
also allow userspace to easily wrap the new thing with posix_spawn
itself.

Also note there is another issue with the fd-based approach: the fd will
get inherited on fork and will hang out in the child afterwards unless
explicitly closed. Suppose you have a multithreaded program which likes
to both fork(+no exec) and fork+exec. With the fd-based approach you
have no means of stopping another thread from grabbing your state thanks
to unix defaulting to copying everything. There was an attempt to fix
this aspect with O_CLOFORK, but this got rejected.

Whatever exactly happens, NUMA is a sad fact of computing and needs to
be accounted for. The approach as proposed not only does not do it, but
it actively hinders such deployments.

