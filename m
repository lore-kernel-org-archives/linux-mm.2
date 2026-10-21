Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C5160A260C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XcyyqX1c
Received: by kanga.kvack.org (Postfix)
	id 414336B020C; Wed, 21 Oct 2026 08:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB326B0703; Wed, 21 Oct 2026 08:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D91E6B0704; Wed, 21 Oct 2026 08:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFFDB6B020C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:52:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9108A4054E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:52:01 +0000 (UTC)
X-FDA: 85346620842.06.D21278E
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9AA8A0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:51:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XcyyqX1c;
	spf=pass (imf25.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792587119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mn8oXMgO7ys8gs1NirtIayuQ3LSb5RT+jR9DaBN+G6Q=;
	b=2eci5bVCcCKG1lCrDaxWJWVlP2KmgMnwo+Q4jFm/N0HPti2MDvjqlFWH1xbTG3YdbHr6PB
	LQ6aZS9veeiwU3sfHMiz99XvxgVRGdWW8bq/K/A0mp/L9QSwccjGjPB7tI/BGRzKIEAvq8
	UVRp+h1Bz6iGdEHIzI3SKDJjCOD9/M4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XcyyqX1c;
	spf=pass (imf25.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792587119;
	b=dU3f9oCjpvFGg5Xl+4ircFC+5ghJsiLj7wfHT8aAFoFMx1MmLrWbl/Z9xby/iMMuNIuAMa
	JzCjrb/9kUnEo6eCu7vzl0YsaZYICVTOwJP6sspNX/SKw0velPNNDpAfroRmiNGYQsHYoa
	H3mEunvApX9lqxi4RsrfFivF9vHP3jA=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40f29667e6so102737166b.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792587118; x=1793191918; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mn8oXMgO7ys8gs1NirtIayuQ3LSb5RT+jR9DaBN+G6Q=;
        b=XcyyqX1cjkhZ8317NeC9rG6n2RK+7MGvr+IcGLHQHAwj8VdK3er1ZCTyfjz5c32DRy
         zDAfA1nLXlDk0KTh8/8gplUfnOuHvtp5IkWSB0G8yVs2fRIG4ByHsEKiigqD1RK3dBBC
         KzSceJwsb4W6x10mPS/kwWXo6jESmMmv1yfRmZeLMAmRCxZf4SIhgLdaeHyZjIn5vPbP
         YPyB0qTDMX1dlG6D+LB5rRjuVjY0wkMyEvwZx9boPf+apq5u9cNY+vvszAyyUBJuO3Gn
         iT7XKA61n1qj+GhSlvbIlq9t1n+nFBdiIbFnOcFx+MKBhJXbHgdYxhtHkXyoLK0I8AX6
         Pbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792587118; x=1793191918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mn8oXMgO7ys8gs1NirtIayuQ3LSb5RT+jR9DaBN+G6Q=;
        b=TBimhAxDDHLXoyA/bXYMBRznnqnfJN0vgxq+Eq6dSikUYjBHw6nT/QrHvEY9LWFl2f
         TVyRRSiLuzNbW8OW1gx7Fmea5DtB5Xq1LMyUZKD4xOEWWtBRqPFlzCbWqP83bOQ9sA48
         yeC0yWFSSo0aqhnS6oJU1ao94caqGGCtidsgJXP8eWFS/f8CorNfTzu6FFdzBZNRv3+9
         WA6AootoFc6NmgKMLsMy7cdxAqmcKfV8Hfju7kF4cCg7qFS5YqzR5qxz2yXMKME6RCzO
         EpA0mcAYYSx82eYosq9dcQBlkngz1hcsuRdH9ejMKr9WQK3FKDb50q923T0gq89J64iD
         AE6w==
X-Forwarded-Encrypted: i=1; AKwUvBzOqzdLwTQ4NjhdTKl4gi97McC08/lQwoxf+dHizB0zfUFGlH09MGEVYfGHauNvBI4jbrlJ3oyK6g==@kvack.org
X-Gm-Message-State: AFq9FYKWxGQgFhDiFwUY43DXohOroXDQLpnL/HtzDkvJyF5L5Vopd9wo
	62gROAYTG8pC4wQ4XFtoyeg3cvzqa9GH4StIaVgixNP3mmRNNKJ3kWz4
X-Gm-Gg: AYBFou3MIbk86QtC/JdHA9CFl+1Va0a3sXvk7NA1Vu2m3cxKwtayaLu0ZQHJ3/18BKV
	41M+zbyHs3UwxqwgJtK37Xu+u/EWkFk/Bbkvwej9SNKUs6JDL4k6Pddm4LNR4no1uBJtmKUEVNL
	4Ox63JEFdyq6alAgCG//FniwBfq+RgNw4dwDm7ywxtLu1u1T/DaGbkX1oWM6yQBqgrGMKVZEo8i
	/o0+QTcwQyFHBB7u8NDqfygWc78V8KzcYO7ram86GOH6CLhBfQvCkjJa/+ISX2EFYRI9rfUrw6f
	Cz26jiBoa7quuzStdx8tAx9W+Ni3d5Uutexv4nBBZr7Cn8/7jj1y5EgsuRfATagJGa6Mhw+rl0a
	vBXfoVibYSos0aX0NRKZy1l9DQaCixA2hDnrGoRNrpq9MxtjrOop/ewg8/XcRtvHErK+0h8y/OG
	vgV74Iqo/1/pCeJSM2jSC1didqGaoupjvn3qoQBA53L5Md8Vxv0vEN56CB1id/NA2sdXPr/WMQ4
	r7u9WgUV5arnV9H6ENEqoD8ikqWKBTagA2KBgeezHskUePCnAbQJ55vEwfzYleg+c71W416eoOy
	gJ2eewZ68ytRxkTvMogmQnMFN7io5b+0IE3MwK9b7BxeRmk8kTKgmFsbph4qMLUuXk4iRa0U/Mp
	pKAU7jLofk5sznASX5BXpECJR4O4rearCRsHQ5lm00oT6k0z0rGlNa9HIalgBEbilAjxFCMOwds
	1Hpe39eremNYmDRG7T333qgaJ7
X-Received: by 2002:a17:906:99ca:b0:c40:9839:c892 with SMTP id a640c23a62f3a-c4679594c9bmr175067366b.19.1792587118009;
        Wed, 21 Oct 2026 05:51:58 -0700 (PDT)
Received: from Ubuntu.tail0f733b.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4679004464sm73128366b.67.2026.10.21.05.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 05:51:56 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Kent <raven@themaw.net>
Cc: Tejun Heo <tj@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	driver-core@lists.linux.dev,
	autofs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Subject: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs stores
Date: Wed, 21 Oct 2026 14:51:48 +0200
Message-ID: <cover.1792577179.git.krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9AA8A0003
X-Stat-Signature: ueampn6r4hcf8oaunxoj1ejjudfinhew
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792587119-596090
X-HE-Meta: U2FsdGVkX1/NxE6zGxe1lBYp+RsFcDhuzJnVF3usBNSDI7mms+q8DDF0dSV7SD5JzBdiMcow/fZms7Cw2JV2YfdoZld8GkTtxOp4Qi+jHOc8bA/yj/sIVBupxjKdD8sOSeh9PdQttuYK3SwHCcWLsa3BRl6PpB2hqIIRj+IbM94a84WGN8kGltFj2B6P0OlfsawiD1txZ8inzqwxVK7Seyqzui3iZK3QdPjHHl6e0h2RZdzsTPRgsYSCOqcT45kfTCB7W1UOYZbjYOYteNza9cuT9vVT7OePGlW8Od80TgkZJztYupa87Uw4cxpltTsMtoa580SVSoAMITrUYtUqBFzx3qcsq4heSadD9C6ZOrxE/oLoJBaDWz4gz6szEfYR9qDG07I/2fT85UpzSoo0nSwWnhzb+EYzPFrhWdujeR0P4eSJsE/A8J5fr8MwOqPJMR3lPIX61MAiyWURwqnYtBg9dsb0HUmvsKRaKdOw9skg83W/DhP3MsSL5+ODzf08LY3prR9yqL+d2DyEpd7crTUYpCBs1H+o+MaKzPR0FOwHjv1rw8AvzA4Yy5Atezoii+oAFI6n4hSQy7oEBL40ouOU60NASOqCGsbLfMH8PpRpnOeNJcpPrQr/wI/0itXKKFh8BvmNOUHZQSpHc0rUIwzPWQWXvJGhmrHYMQRycB7foNFdLy+njSxJWzNvQ9PPkyJ0m5y7wLLerFtlgGArPBL4q35T/zq6sxTxyfjvh+VQuhfXva/DXzYRo6ySO2UlRM9eUkIU/GOhGXigAIkHFj+M4Ikcb+CiNxngmgEeSAdJYW39ylfXXwvFX4GZue7/wCI94jTsC8RKgdmeYkeSdYbXULxa38n+RX7j8nvyJFwOjBvGftABHMOt9ly0Ce8NMz2n3JUpYI35V5MnoL9YKJn3QizFqS69yyZs74/EsSnaPcsXN5N//MDsWJBzYA32Hd87CzIqmI6cuz0PxAx
 7tazO5Sz
 nCMM0p9m5DGWupvi2Y+123dS6LBBaYPrlZhtQWnFxj87Vy6XFuuKdr5ug0iO9WK3j2nMhswMJWHXFTy6B71G1jccPm+aMzQrIbJB2sHrFwasWGqrkGGfSYHRCPKXeBjqDbLLV6jYtbIfoqDdvZr/gSK3mm+Fmc9jwG5d+atTrXY8ElVSzxWnJTtgFygmXPpiLCSeCYu/DsVmzUE1tXSV0z2tbYlSaxq1tFJP5LtOHl8s1hasP60J4ml7s7RT3DFzJCH2l/nO35pFI8EBlFu/+88zF/Jev8t2eLTvpIOCH+TtKgVUgI45//5kxDUIReumrFIiZN58YUm9wQRDURLjK4Juvf5SCGf+owZnmfxiFIv8fAMFZVgVhUxir7ccdvuk8EG4L8Tw+fs2nJivOSD0jlk9deBkwnsokBzlbkmDltCAmLfmLAtbBCAnwjRdnOhIGHoayHiEaiRVukBt81CyQ6idBpTaUQlfZ1zyqPLml8hfRnMEzThEEZGwqQ7eP/EfW17FpSIYcBAPTIcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot reports a lockdep cycle &pipe->mutex --> &of->mutex -->
&sbi->pipe_mutex. splice holds a pipe mutex while it calls the write or
read handler of a kernfs file, kernfs takes of->mutex there, and a write
to /sys/power/resume looks up a path that can make autofs write a request
into its daemon pipe and wait for the daemon.

Patch 1 stops holding of->mutex around the ->store() callback of regular
sysfs attributes, which do not get the open file and already run
concurrently for separate opens.

Patch 2 handles the case that patch 1 leaves. A store called from splice
still runs with the pipe locked. autofs no longer sends or waits for a
request in that context and returns -EAGAIN instead. A new mount is
refused before it is marked pending, so no other lookup sends the request
in its place. This also removes a deadlock in which the spliced pipe is
the autofs daemon pipe itself.

Patch 2 changes behavior for one narrow case. A lookup from a splice
callback that needs an automount fails with -EAGAIN instead of waiting.

The series was tested in QEMU with lockdep using the original C and syz
reproducers and focused splice and autofs cases. The target reports were
not reproduced with the series applied, and the paired functional cases
matched the unpatched baseline.

Krystian Kaniewski (2):
  kernfs: do not hold of->mutex across sysfs ->store()
  autofs: do not wait for the daemon while splice holds a pipe

 fs/autofs/expire.c     |  6 +++++
 fs/autofs/root.c       | 28 +++++++++++++++++++++--
 fs/kernfs/file.c       | 52 +++++++++++++++++++++++++++---------------
 fs/splice.c            | 13 ++++++++++-
 fs/sysfs/file.c        | 18 ++++++++++++++-
 include/linux/kernfs.h | 11 +++++++++
 include/linux/sched.h  |  2 ++
 kernel/fork.c          |  1 +
 8 files changed, 109 insertions(+), 22 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.53.0


