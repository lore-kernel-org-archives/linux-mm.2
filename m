Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F6DC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E136B008A; Thu, 27 Aug 2026 21:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524AD6B008C; Thu, 27 Aug 2026 21:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5EC6B0092; Thu, 27 Aug 2026 21:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D90E6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:10:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 827B11A0236
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:10:51 +0000 (UTC)
X-FDA: 85148898702.14.E577212
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E72D40002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:10:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=c3aNnNkj;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf12.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787879449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqRGrR0heNmSPrtTW9+v9FKZZ7RwzxehXvY0MCzvxnw=;
	b=wk3uGjQaVihZqxNbfUK3dSoGdBX5GBwrX7ieg2QsjlTw4z7B0giq4A/MAeJMQ5WeYXeqqX
	vPsvKXbzSF2QzLZBVyudP+oESbcvh5RhUKp4aznUDra3pVx1bnKJsLP4k60XEJ/Sp/qzYG
	8S9fFwgXUB1+d0XphEEncJcpBrCeRZk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=c3aNnNkj;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf12.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787879449;
	b=6hO7GB103w/Fb515RcV2lUXHov/R4yj9Qjjwdag0vB0yxH0CcEig90mhZldT3iwXs9FGxl
	Ds8CTnST4stQ2Pw02cmpLUbob0890I/B0rI0QbJco+A3GR/9dXh5FBsVSXXOWyGrauSrjP
	0LJgHdprWA4m9Hnk/H7TUBjdwSYr9ks=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-930c0f9c1b1so20984185a.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1787879449; x=1788484249; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DqRGrR0heNmSPrtTW9+v9FKZZ7RwzxehXvY0MCzvxnw=;
        b=c3aNnNkjPSYl6kZ0JuCrf4KMeU7zYrqk08Sjj6ijWyqk70CYGacFvcqD2Bm/LQO9Rg
         zSWqrC+80zUrDBMqt1ZCXUfI1DAg5ami8Z/gHJSXpbHwX0IaPic4yRBZKOhnnOXwDuQA
         BbL8bLq+o+wvBgGlJzciRj5kUq4Jbufv49KIvpsDco0MPox/Qg8mZLca4pt9tk8+sxZp
         PSq4R8A4ddTbUYuC4OUwttTY+m4G1XD2NCq53UCiAWstCnyvs1wQHxFo0jUzgppS3Ujw
         wiS2FVLNzfY1sv4vPhSLcACq6xspeavQDj+QY9yDYS9b/t5f8gZvp5jpxvJF57LXe+Y4
         gxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787879449; x=1788484249;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DqRGrR0heNmSPrtTW9+v9FKZZ7RwzxehXvY0MCzvxnw=;
        b=YYqcEBQ5XoFTSp4w9NrzR12Tkj9nj9qGHlyvWT7lZzD+wNCtY4JVkb+VmDAZ5FDk+i
         3ASln9anjJLA9UZC7jpZvcz9phLp2FyZgMTaHjsHUXKirfSB1PgtIfaGyxjv/cryQi3Q
         7d9b7agVDUuMDQNqh6WQWvVVQIB1lVZut9iSZNlcSErK1zaiTDeoJRqB3MfqML/pUHds
         9i0OkwUW+gZaonCf9s/ktnNjkaA+1eHhUDuGK9inDbBj+Qo734y8NWZxIvXFmuH5hfUi
         SKgwmOL4amb80FZ7VYKVUOdtn5z10G7ZxU2ym1uW/hJXsRZII6MIoWD4HEnj0wdnc1kz
         OQ1w==
X-Forwarded-Encrypted: i=1; AHgh+RocLwF5+N5c2kgpCNwCK7Lj4q8jVIQ3HIMStk5PIMHBcNtJLQRLQUvUyG35YhkYiZxH6PKlYms/MQ==@kvack.org
X-Gm-Message-State: AFuF++msFVXVT00MsNbvYa2e5MwAAhzYigxMemou08nXZB+/b0Bpv/nW
	cF3TPXV8trwVj3VW6fwun9ivuPf4sWso9NVsLgFDoJNgyyjhUcpz6B0+31hB/nXVHw==
X-Gm-Gg: AR+sD13Rogm8Nrg5Z5YvppXiN43hQ3HuS1vc7gB/SyqP8KtJB6+YU3iqv/oscHbTiIo
	Aq59tlpuTYItZEzznNuDvriBrziCzziIFvugeaCy8hgmVELErx80xCgKBNrn5XhByI0EOLEzCfC
	sOThgKTD2qLf749eTetGO4L5zr5HefwenZKi8d1xlPggmfMTbAbN32vD9x5TaD7ukPRLnFf1Jeq
	ZNHnj7iWbLLUF4dJz8tZnLo+7arvALwhB9TSGMdpwkWtYHB37DtjfkX3TxJUPsDxkxU9yjSL6BS
	/166BWF3I+9qukD4MwqWz2ZkAiX4Sh9JQyIoR5+QkkHkwkCe6VzI9d+RRA0fn8BUzezcyX1mnNG
	XpPry8yvY0rBlTL5vGry+k+cG5WtC7RDzZp7PMw1nQtTO6I9nz44XcWnxNWL+K6Kvuq2hOiQuSq
	Krmp9E+hdABD66kWo7NqoEfKwPKrFlyeWQ/CviF3wp6a8jzoVMyWDTGymlrie2SCcR1fh6cuJOZ
	OINiljxE7iJEdQ41yBBiFe2nVIE1Z9ORwX/DykR5Lce
X-Received: by 2002:a05:620a:290a:b0:934:9524:2e89 with SMTP id af79cd13be357-93913809957mr300256985a.13.1787879448634;
        Thu, 27 Aug 2026 18:10:48 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9391725670dsm34787285a.19.2026.08.27.18.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 18:10:47 -0700 (PDT)
Date: Thu, 27 Aug 2026 21:10:46 -0400
Message-ID: <de5f1c2fb1ccbb92beda6906e23ac457@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260827_1122/pstg-lib:20260827_1501/pstg-pwork:20260827_1122
From: Paul Moore <paul@paul-moore.com>
To: Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE  introspection
References: <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
In-Reply-To: <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
X-Stat-Signature: 6tfrexe8ruo8by4hh7e8jab57snk7t11
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9E72D40002
X-Rspam-User: 
X-HE-Tag: 1787879449-505353
X-HE-Meta: U2FsdGVkX1/iS+vxlE20VX6Jj4Dr8A1DGGg1XpVYB91S5Nssnm0lq/GpuGISXfwz3XppAVoCIUYNhc+GcYpWELzot/dGCAIUPN8g1VULfXq9i4cKxJQYbrdT9ruY2SQJDs2gJvHqFDvpOCLwDNdZ1UzGes3N1r4elhLjPaPxNhV9ftYxGIuyDRZJ4I8JusfqRtH+aqznLwoXzQRtrAKgzGwP4xZLIHp3DP9tHgsdj5WwnQWXEmq7mISOm+FVRicbTAJbG0RTM1bUOcqi+obON0OehHof1Ww+7+6TexWcKxW/9E6CdOrR4YYYSRgMz50LdRQa6dydasE77avcgDvKtG00G5dYuobpBcfyGV43J/hS9PArBp4N3+od4gDK9ygHsVHq1ClfqGQxe9w20omucILdttJzbkjHWKkjh/MJy1Dnjp2hA2N5rg/z/go+ob4GvpaTLxmRBAelnefHZ09inSHR3TcyuaP8OZZPwMo4eUQS8hukUx+KfaN1fdOTyzFNEsTBaJx4TtIgKeNPKORufsEWaxBzpuMzRn59ILUtghK4OOWKxYPViz74DZxHhOr/h+Wkaq179fBIsy8PR+LPtgkdKdrmnCylVVH7OA4OfSX/O7gUdOKGbfoSmXIzi20kU5HMzfZlVN6nwilY9aOB0kJz5R7qa2wW5ua61cjyHoss6Hiz8Y+iotNhXq5XfRHxNsIa6Cu7wn9RqiG5JElgNJ0uZugdA8pGgDLc4mdT6jhE4wp2STSGBHvHIxyckvUdXhXzlgpCVhsmKTAs6lrCE+8+2vL1axKpuO7J1CDsbolziQE5EaQmuyW2DbaFjMHrWHSdqQs2qkl7QpKRveg9ykOSsI0xW9Ldm9vY7qH0e9PGyOdCbNe668r9jVVdATwJhpp1gdh7CjcXaR/2Z1Kpx0TPHpnEwfzSdPq0/kM4IEGZaA1H3FtWdTxv/HCbRs41f01XjcsDI9OWbeAIvTz
 yU3rRErp
 2SMFYNvY5BufXsrmILIKOUsiK2pxzxHyceci51/eoGtG8an6PPbw9/0IpA/fJFJrfb6Zjlwk8mCmSa1X+2L+9IchAwaaPc0fduRpVGGikxWra+W2h70WSUVWfKco8Xo7XS9SYMqmQJSbrQLVbRcjNVsLQJ7gtShnqQXVt0MXbqSxdrlcj9aBaYHjbRihbTDg0OesI53nnAjHrL0Y+qBe5VCNp1wGE//tZ0lXkeZoehJ+LUgE9cGroyyqzz3RboWktMPBgVpwDkvjTGuTI9dtwRfi+nKulnxVwH+c7EWVqPnyJVS5lzdKXpuui16l9iFBJBZnsEyjbnYua+CWEXoMzJgvAlboPFCE6ndP1ZQM/xZZ+VmFBB5eF7JCYbDHoXudgTTiq4lmpX1stArk0u3P3CHJiNcDyBNlU0/RgMMtx35mhbS8R8UoTwhwNemOXCiwHFcw0aY/aCkpFUqovYLtmRIwEFy3T6gpnHEKFcr3J3p6I115PbguURd7UC19Pd7TE8DC7a4v22digwbYjhC+1qKObwxgaQmPTRaZc4v6h1fR3PgCiMsxQVzf6661Fkm4tvSfL/0H1exgXmzklq2A+it7ibjBC9WIeqIvWlsMyMCzi7i4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Aug 25, 2026 Jann Horn <jannh@google.com> wrote:
> 
> On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process can
> only create anonymous executable memory via /proc/self/mem if it has
> PROCESS__PTRACE (like when using /proc/$pid/mem of another process).
> 
> This closes a hole in code integrity enforcement that Project Zero has used
> in a remote Android exploit chain:
> It was possible to use a memory corruption bug in a service without
> EXECMEM/EXECMOD/PTRACE permission to overwrite executable code via
> /proc/self/mem, which made it possible to load and run shellcode containing
> a kernel exploit.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  security/selinux/hooks.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 18dd28b2bb13..2c2c60e9e0fe 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2157,6 +2157,27 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
>  			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
>  }
>  
> +/*
> + * Decide whether it should be possible to read non-readable VMAs and write
> + * non-writable VMAs via /proc/self/mem.
> + * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS, and only
> + * triggers on accesses that are not visible to selinux_ptrace_access_check()
> + * because of the introspection exceptions in may_access_mm() and
> + * __ptrace_may_access().
> + *
> + * This allows a process to overwrite read-only code in its own address space.
> + *
> + * Creating an audit record on denial doesn't make sense here, since we can't
> + * tell whether FOLL_FORCE matters for the accessed VMAs.
> + */
> +static int selinux_mem_foll_force_opened_by_owner(const struct cred *subject)
> +{
> +	struct av_decision avd;
> +	u32 sid = cred_sid(subject);
> +
> +	return avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__PTRACE, 0, &avd);
> +}

I realize not all of the SELinux hook callbacks use proper kdoc comments,
but I'm trying to fix that.  If you could make this a kdoc function header
comment I would appreciate it.

--
paul-moore.com

