Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5C6606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T0RVULlM
Received: by kanga.kvack.org (Postfix)
	id C90AD6B05B2; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68656B05B4; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DA66B05B2; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 909016B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CC7F80684
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:24 +0000 (UTC)
X-FDA: 85397157888.07.B599876
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 84C1A20009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T0RVULlM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejFOU++T/9CCYj2HdH5u0LvKpWcRY11f5gk3oaVJvtY=;
	b=os5epXpCj1UDKw4J11FJ3glZWeORJafN06tU84zA8B/QznsaHB3gQq61EuC9aKQ6UW3dsx
	ScbaqvNw+u7Zp+6pjWtf98E6ImYLpglGI8imifTxtQWfFu8VR0aJbdVSQspeOsnuFOLC+d
	cb9vmzVUMitzLi5dJr8d4mQD4iMH1tk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T0RVULlM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790382;
	b=FUsHF2hiMB9IXVzCfi6VmpzkTha058USfIGC3g5o7isp9LnySwuLiLOdegKHN5mcg1xVXL
	i+jLjirMAYwuVTEY/+ytigSPwrfpRSdce3rndsjvJoyTgOgFaSbRsQ4KRruABhiXA2mhO+
	B17cgg56Lv41C4vRJhmVZ7RKB0Izkmc=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e46e449e8so326973f8f.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 03:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790381; x=1794395181; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ejFOU++T/9CCYj2HdH5u0LvKpWcRY11f5gk3oaVJvtY=;
        b=T0RVULlMIA7H99jRCCmu6ut0cB9riCCssPReaEfrBKz4letHq4N+WAxO0eVMlpPtPD
         mLS6oVlgeK4ALUy15JUNQXQpiZ0gaVq+bKO736Rp/Vwv/ra/bRBhknHvdNwz52DkxEEe
         H8pRBYXWfQq53QiqqiMpDqEZLYNz4Y+DueXZ2tR3RZAprGrNsKlo3UYKo2iykEBlcPQz
         ajc/DucEaPaT+GciYjKJxqfFXXnqnsxAOCpDNDIxhkxU/o1o9z5SemMGfXyMliFuO7gi
         wtNhMYX1A6SA/VAL8BefYNzfjnHh/D55YMEg0LWBHwsH8bH0CxbtzjLVDgU6bJIUSY4l
         pN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790381; x=1794395181;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejFOU++T/9CCYj2HdH5u0LvKpWcRY11f5gk3oaVJvtY=;
        b=xK9EOWeTrnKxvVWWe6bxbEUda2cf+BhPl0kWAD9LxxXR/H6cY55IRxZEEjc7Y1YDVi
         FNgn3C4jY6L/9NwVbM9nDMeWr9gOy/P56H3jweXf7S8pZabd+t4mqv8YieJhHjOcvAf+
         xtQf7yYiAnv2jJipCrO6NSxnxGZ19K/l0k4PI27AStJ98kBvVl4gOrpqG3TwfLKNfB4q
         9flH8zDjyaH+wehxnXtDRFzRh6LmY74w22dcSYhqlP67YuybQbtKZkS1LslhrLdXcfdG
         bBbge7FL+0KKdBSA5fDrLSDSWPtzKrlU6kWKJob7EQwpjtIyQElTqVke8c1mFCybhsfW
         CdbA==
X-Forwarded-Encrypted: i=1; AKwUvBwBfypb18kL7AnF+aapKzZ3GofbBrXdpda/p7Mq9CCsDqkJufRf7zvTdqjhs/sE/rAO3GHu0onJBA==@kvack.org
X-Gm-Message-State: APuU4Z8fQ15rpUjxVnDRHx42yo5s4+E+nSAoDE85kWxPAKosHp7zxfb/
	c+MJbD8LZs5Fy4NaTdBb2P0+iLFOG7NcjdcJYXPA5X7kV+n+MnYCpXZ4
X-Gm-Gg: AYBFou2EgouGDjZRc/GerUqgYDfHppz1r28jQTXOwUrlwI98QOprtoIp5Glp8jzxFLf
	QiIJT/SQDtVyWVKtr+cZnqOgHE8M8TiFwlD0Lz95oqsecH7W+KXnjTzX28p5894qt+x6zSayqGd
	K0iAdkJowF8drKn/89j+02zBqySE4yYxStqy0P52idU/nbrAZwFxq15xkA9IDNqt4TyaGYvmp1m
	3MPVoNFnUQnGbuoqjWJGXyNXGjUmUsAecrNYRN4RJOgkR7iDuKzUaHPU6OzaIDyRFxwykHYWEn0
	aS+PbYFhVrqQtMU9NM8HnuFa0DBvziGn4BNv8rBIPHRN8SGrkOvsBDmuQMz2E4v7bBxmle3A9DY
	oK+synRtdJ+tbL9OmuD/kMpChqqWeHXddyOz4pl2M0OgHbs8F+S9hWUGxXksDvDOK/sOTglhLSB
	s67Q1odq7nXTuCmmenB65Z1tZ1KqUmxH+vexDTrnP4ERRvw9dImVfndnQkVlTrogV2bpwNlBwjT
	i1V2pfK9n7XpJ/VunjyXXceTzLTRmJcNatyqgqUofpAvTfuUOUK5HqiHVnjqUfFHAsG2cbEKao4
	fRM2TlnGdtPGanr2CefCtsr2EOi89reH0If+ELqOEkF/z8KEZvGXlyrsrEfL9dmjYER0humwv56
	GyPSsDvTjUdId0W7L/tRS8jd7
X-Received: by 2002:a05:6000:2310:b0:490:a3e7:8af3 with SMTP id ffacd0b85a97d-490a3e78cd2mr650035f8f.35.1793790380848;
        Wed, 04 Nov 2026 03:06:20 -0800 (PST)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed92a753sm3704835f8f.45.2026.11.04.03.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:06:20 -0800 (PST)
From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven29@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
Subject: [RFC PATCH v2 1/3] fs: add filename_utimensat()
Date: Wed,  4 Nov 2026 12:06:02 +0100
Message-ID: <20261104110604.126717-2-meven29@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104110604.126717-1-meven29@gmail.com>
References: <20261104110604.126717-1-meven29@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 84C1A20009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7eatiksn9faux5zw996iz61g8xmy5ig6
X-HE-Tag: 1793790383-287093
X-HE-Meta: U2FsdGVkX1/waruk254x2M4N/yMtjEpqUUJyFmz/QwzzSGE4ep7R2zPLZZ4kBV67h8s8puvhB/TYt4wR7LZFoo4jPOJd4+DwCiCNPQqMvmIOqX7EtwRGApf5pMCoQJLzK/uLlNSsC4Ki3oS2jVD/pk0TZeTAg+Eig59KZsLugDdCIUqV05AlRGkGQRCpz4bKXI4lc+U9hDsOK6xu6c/2gLtsBNXtx9srlYQhNtFHdxEvTXIp+aKTbL1/V8jBamEF+CoN1B5bVYHrCvij3G9cclsj0lSlnbqID14zNjG9TQo13ADbYPdaTgrPrM9F95e8FRkkwnhaMPYGs9SRKOc7X65zEPlJq7gAgJ3h1D37s98YJP/VCT0ppgHUTo09PDvlPLMAua90iccXWXH0AO2nTmBvKARjR+lljN+ThmF2Sbe/85RYn9xDKCE3dsK4Ci0hKmR0koLQQhdKJzBIfTNTLCwe6El9IeSOoezfmIfP9pEDXVXwe0wGOEhreDIhCqIjhbnfSduB6e+JK6H8rKiNCoFoFqtn3wlQYB6jZGP1MyEdzALFfTuWKC/X3TgTnxvM0K8cDJZrlEroj8KzS+sg1rIv5qlWvHLxXKLBO6YDKvKnEf2qbfwNA5Q8arWyeyY02bbGypcUyqxJHEFXd6Zde222PG6mhW68OM4wEUX8YFz4YhClVqm0M4Ub8bJb6qNxkH+Hqqle/3ZHAf91+sI9ZDZMokddUZfBuo6Obal0mCR4KtV54zDIEnsn3PvL1vgOSUP5r5E5v296eKZHPt6NNFPGwh7X7VQrcWLNi8NvFVCrufs+rpL23/6mFgrERSyyrBbKIPFruEQ4MrygVg30DAn6WgVvaN/VjAQBltTP6nKEEXhsp0FDpK5k7kVmtethk6WODffiEs6DozrYlS0VgrsV4ptU0vQTwlXzoA/6+cISpv6PGhBHYBQ8HjLFzhWO70EMd2bkhi/kYgrvLdq
 2divGe+M
 B+rcq7Mw32jm65oHF4Wz7WGNYLMiwyATGvpgHC/CB7yW0FZYCh6csB8qS4KG+VFzPC4xTXnsyTVdDRDddcSNG75CPbfZdhP6a5jn24Htijke9CRM8Rf/lNVNgG2k2Z3eNJfwAqHo2a94dP0JGLdylvDzKAsHk0kop/eb8aNsQrlXMr1eMdyFgPuI8c7c/0yBoiRi4AjcgC8aEsdViv2BN38Kahc1qoyOHWtz+dVf2Z9s4+9xwKQ6/edjDiU3ThofnNdFA6Yxu8PGfrylzjbqRwJ5zearB8S+sd0HUqTXh/A6d/80VKlkSjLjhlz7b/4n7Cw0ob4PXsNr3AyskQTyU1aaDZtYG2iqpuCbOMQjvHOeuuZeSYjy2agGZFPo7VdRoHz6NY+Lr0pCvRMFY/zb0IXeHX4ODp0i5qlTLaiZGmYcanc/ByhRQVZ7rbOaykJagxAuFXoi7eLug1xuuC4cu9nX3uOTIDa0pARswgOBgDU13FfxypLWuticBpe58pYCKq0BugVpgYBfJFS4ffdGRh2G75ToWKh6tVvw4WcL1iMo6Wfd+ICy/vrH8bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Méven Car <meven@kde.org>

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


