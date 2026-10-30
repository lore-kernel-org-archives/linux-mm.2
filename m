Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3780560A2605
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F06+831i
Received: by kanga.kvack.org (Postfix)
	id 5A87B6B05B4; Fri, 30 Oct 2026 08:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532546B05B5; Fri, 30 Oct 2026 08:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420AD6B05B6; Fri, 30 Oct 2026 08:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 140BA6B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:39:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46A2D80648
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:57 +0000 (UTC)
X-FDA: 85379249634.13.20C22A7
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6063740005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=F06+831i;
	spf=pass (imf07.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793363995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KaBBNRkubak3FMTFfY4sBxEh/vBQKes4YxguyRgqq4=;
	b=npUuSKg5o/l+/WAVmE3VZUYRrWWg7jaOzmpMbYcZUiR080QYsB1naEghtHXSc1eTpuUWKb
	GKlnFxdRGZkzf8PTtkbIFkhrF7AsoxG3lpIgfnVtbMCalkYyQAyICWDWvQOuMYWlwrNQhu
	2+XXmXzg1X0ReYY3/6i0AbGF7WQ3BaE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=F06+831i;
	spf=pass (imf07.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793363995;
	b=OsqnogIibnkKaxme882+YQ8fon8Bgc9ZvMxtlF7E0Mx3WD0swffVEGYPWSdiHrauugcmxu
	BLsRDKzd7qCtsu4vrqglqn9rsz8l6bqqjH1hh2vf/FXl4yk4cd/ORMgZLeBdHMBVlt2Mfk
	A0kCETIGznbt2wcFqmryfdGPWYOsuI0=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e4831c028so651049f8f.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793363994; x=1793968794; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1KaBBNRkubak3FMTFfY4sBxEh/vBQKes4YxguyRgqq4=;
        b=F06+831iVmZupqQlldj4CvzU46qcDueIfXtsdCgX3f0mVzXjWx5oKKTQq/8saK/pxw
         J0y5b8cbnMDwekkrEnPI26OoI5gLx8FxQ/9Ev4nWTOh3DsDtgnn096zVOwf8PEyEX1ds
         yGRsbSwuHteBD3hYGnXz3bsFwI5T3asLwuKAi5FLQ9J8/CfrBynF2kGkIqFfRdqoDHkO
         XPaLjMwFKFpw+hJJmeB+tVmwf1EALvj/1aE7xVdbKzk35c4t6HCglNvZ3FYM3lkvuIOV
         kTTHGjDY/dQWHQFcfE9s59xU8ntZSkPPgzYt/jALmpMyKNbtlCtcR66zpb04vI0i7Tlx
         gOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793363994; x=1793968794;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1KaBBNRkubak3FMTFfY4sBxEh/vBQKes4YxguyRgqq4=;
        b=RWYPQl22EYURHWmxmc9Sg+wl1GywU96zurGwmhdX9OOgfPhiRGyxsNOtfbhTc/DoJl
         du5C3wOCNHrDoxBViHTtxTlFnCabaMwp8y92wEHbWXDLcpaN2NsWJqdRUKxOa1DAjuo1
         aKnPUl+9RvnpmcjXOPijMURI2VtaQWo8W7u/jlaIblkloacU2XqYEadP51Xu86mrL09A
         cuQNgGfVTdMqLzJHcLKsWg3F6gxfm36gh2CiZ/mKEzbQyZUEm6rIgFx2HA9EILkteTnj
         Eo8ZO+rdqG8yXnZtlTRRnThaWQkfFtRiwCTo3Yf/wJhCvABQSQ5UMolKcolmA5LCyn6T
         d1lQ==
X-Forwarded-Encrypted: i=1; AKwUvBz0KO59r0f4M4mpsGpu7MeL+1tp5uV91bruyix5eJT2Kag/Z7ec2KGKM2yOMNTXS8Q/WWgaYqnY3A==@kvack.org
X-Gm-Message-State: AFq9FYI+ZyOh83tmIWnLTMwOuBFNy7bgVHSkJCLybccA7jb93q8dQLkj
	zr+pRr9zYGzXBA+qHVpCShNxrTK5j2wYFeFp7QnsYZNlr4lFk85R42xI
X-Gm-Gg: AYBFou2MSL7Iu6v9s8CY6wCQMYdP2SfwIFajGEphASMcoab8jy7LTcpmZS7gM01iC7P
	7HKTSBhS1I1P6gq/WeSj99lqG1ZqmXxwhvvEIbvJoeR0KMHXeBZdTuFrDt0E2asqg3akeZD/tij
	TrkHhA7+4cd3IIl3GjjWMLrKGNTdftatyPdWSVlaCzZUDXyOsZaagyTUsP4sP1zZxRh5yReZ8PH
	PwAXJu7N5eqgRKA2BFdlr7FsFmALmnfGVHcwx/gDRefxB+ucSAKwgEX6B2KXAxwdBBSfhjqyapY
	kgWFPdREQP9M/OsYMinNPGB4h45RI8Brj6iZnjnjHdD4mRmAyNlglWUyRV2HTf8DYLOJofRBYEF
	1ogyxZ7eeqj8eywJD2d2MIRA8PTEiwEPKZ//DGm0z7QLzxPbHZyHNdeUnTnzmRlGG62ylEJvmgU
	qaRDo73KfA75f5tseMY43Of2LW7lm3rF+7un0w5Ebrsp4ccdTtXO48CSc0gtyFSFVOQueDBjbC2
	7CKi172zwBZnwupZ7r3V2JV2ummQxj63jQ/183EJZMtFQZJ3C6iDQ8UztlvXmW0biuLaNzMTmFL
	fjqP9/iAWEVEJndxCI1infM3ZY9GGf9P+VgvBZfFv1JvLl+WERWrnxhGfCTq+bg6B/HPYok2phB
	d1uEtGOOCTPBQjJ+/L6s=
X-Received: by 2002:a05:6000:184d:b0:48d:fbf2:555f with SMTP id ffacd0b85a97d-48e6e518487mr4939043f8f.55.1793363993996;
        Fri, 30 Oct 2026 05:39:53 -0700 (PDT)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a4csm3088971f8f.23.2026.10.30.05.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:39:53 -0700 (PDT)
From: "=?UTF-8?q?M=C3=A9ven=20Car?=" <meven29@gmail.com>
X-Google-Original-From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] fs: add filename_utimensat()
Date: Fri, 30 Oct 2026 13:39:43 +0100
Message-ID: <20261030123945.1704118-2-meven@kde.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030123945.1704118-1-meven@kde.org>
References: <20261030123945.1704118-1-meven@kde.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6063740005
X-Stat-Signature: maumicd6yds5gsbd3u3jhuuzqxmuj6ug
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793363995-558652
X-HE-Meta: U2FsdGVkX1+LginDi5Lh1c/td4Gcc1h9KGceBppd4LKMgqOpasSzeS4rQG95xehZM7RXPPTz4gOZ2x/izYsOBGOmNnQV01dRsPKB40qzUpuwouUbDkYRb46uzSZeb0EUjIbCfi0k8iLiQLvyto7VXi2S6GEgMzQ329eIXPiNa8xU57J7S0FjRTOvc9kyO1l3bwcAYUbB25PS8O4PBuARrDhD3AFx5HLoQmsW5CLWYtW8A195HuyQ3ChJiubFAWj1pCK7E3bxITk0lzMBOa7SH5V1LgUFPGM1OVEkbk01OjmHq0/ZnO1FcEI4bNhPK5IVonPiGc0VXLKndIxUlB9jz0rk2YBfxTzqqFOvgqUrmaH/ZH0K/KGdVEQN/xlFnJHG6hMokKA7Yb/+FkykbVBPkN0Q6UZSsaXn23Jz0mbXMm7bAOYkFXMzUeJFzc6Je6cy0dDewReMwELnIlcSiEc5Wdb4q92ZxJSAA5EUcO2zBEpdI2KBXVXrlt048Pl5dt7PfhpLTJVIwbjUn7F+0lLSaBnIaQO9KXPnAyJ7S4shrp0vm3WJqDjbZlO4IRAXkUMcKpqrXl2wXYUS7GdRkQBReKfmv5zuRMPBHepqDFVmwCGxDAxjwoPZpXKqZ692x7eEic9atmb5JfeXDVRL2APPYuTpmpyYyxKEDXe4yYPlt6HbAZaKpbw7QlSsDPzNl1y8009kCg/wcfsbXyjncBlfsXR4TMC7cv3r3aDMaRfGd95uznpKH3P6fU6KoXczeUdZITIdyOdCB7iloyrF3hovAkAaBHY2y+KmiOgGQfi6r/QlQ372bOc5z2MY22J+vvRTeIK9mMNfRtfXe3bZSSYTrRkZwqecD8trVybShT3mVTbzMCj0vF2H/sowheBLRtiOVlDjT2HiKO4ro2RmR5E3jQBiZfbWv28OK995jiDwEQIDWyeR3+79n6ewyZYD23EhtDz4eoTNv4Mz93rhpqP
 dxTQSHft
 9JB5eLNV3z4B0PYymeB9090obiOMdr92KIyf/PcwaG4xXNiLNhAuwE5urj1S0qkMkNdLdzd4+YhcDDvLgMGEq8YqGHqtPfTXHHSn0ke5srgmZLsWj9N+GnYSoriGkiIkki1kVYUy/1jn1QYmkACF1cb0VC7NMpn5Qt+QxuUQbIIZdW0XbomwPDzQQicHt4FEuLqmQwkWhDuBW1pvRCeH9OZ9x2QxIS5oH9CISfcEXsGeG11gpSkFhciUe0FgmA/ua2tWhckVH/J4E2Eoj8NDqg4SWmZIMCs3m5vz3YlD6GPYCD5Ufg+f3QR192LgwKOaP9UYAu0/RB0eAHOvdXgWWYI4zd5Da4G9J1iMtRCyCWa7BXzb0c4W4v9smD2cYxSotsxjdPcwu+nWaj2cqv5r+UuCHjYRfeqksA4sf0CRuVk6WixWTEl+bSz3ZgcqXAOpbTfWAVtrqsXlLbB1gYNaYhFJcqfkMqAP9bSxMQhFO82OtO+LRieh83xcRL0TAsfxWm/St8s9wlNAGi0Us7ZkSi7lhrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Copy utilities that preserve timestamps, like cp -p or a file manager,
set the times of every copy after its last write. To do that through
io_uring, the request needs the utimensat() lookup on a name that was
imported at submission time.

io_uring takes the path of a request when it is submitted and looks it
up later, from a worker thread. The path ops it already has call the
filename_*() helpers of fs/namei.c with a struct filename. utimensat(2)
had no such helper: do_utimes_path() took the user pointer and imported
the name itself.

Split the lookup and the vfs_utimes() call out of do_utimes_path() into
filename_utimensat(), declared in fs/internal.h next to the other
filename_*() helpers. do_utimes_path() now only imports the name.

Signed-off-by: Méven Car <meven@kde.org>
---
 fs/internal.h |  2 ++
 fs/utimes.c   | 12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index c658c8a5ebd5..985b2bc5895e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -63,6 +63,8 @@ int filename_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int
 int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
+int filename_utimensat(int dfd, struct filename *name,
+		       struct timespec64 *times, int flags);
 int vfs_tmpfile(struct mnt_idmap *idmap,
 		const struct path *parentpath,
 		struct file *file, umode_t mode);
diff --git a/fs/utimes.c b/fs/utimes.c
index e22664e4115f..8072f05ac8dc 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -79,8 +79,8 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 }
 EXPORT_SYMBOL_GPL(vfs_utimes);
 
-static int do_utimes_path(int dfd, const char __user *filename,
-		struct timespec64 *times, int flags)
+int filename_utimensat(int dfd, struct filename *name,
+		       struct timespec64 *times, int flags)
 {
 	struct path path;
 	int lookup_flags = 0, error;
@@ -91,7 +91,6 @@ static int do_utimes_path(int dfd, const char __user *filename,
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
 
-	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
@@ -105,6 +104,13 @@ static int do_utimes_path(int dfd, const char __user *filename,
 	return error;
 }
 
+static int do_utimes_path(int dfd, const char __user *filename,
+		struct timespec64 *times, int flags)
+{
+	CLASS(filename_uflags, name)(filename, flags);
+	return filename_utimensat(dfd, name, times, flags);
+}
+
 static int do_utimes_fd(int fd, struct timespec64 *times, int flags)
 {
 	if (flags)
-- 
2.56.0


