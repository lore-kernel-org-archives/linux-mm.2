Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7EC606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DZMCVqGY
Received: by kanga.kvack.org (Postfix)
	id 4017B6B05C0; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1E16B05C2; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C286B05C3; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E57CE6B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D47B0401AC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:26 +0000 (UTC)
X-FDA: 85420941732.30.BA317F5
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EE0F180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DZMCVqGY;
	spf=pass (imf24.hostedemail.com: domain of 3t7XzaggKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3t7XzaggKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlJZl+UE9pf/QC95ZJSnwsGYNSdLtTHc9yxgINOhNxY=;
	b=v/kWgnJIwPXiOY3PQY7P5pOHEWZJQlDd/5p1pDaz+65Y03r1de7IUa4/W4jV93S87xvL98
	jeVYGG5hwRIsrGtNaQ9Unr+LD5Dl4daGqPwjcFd1x78HDk9CTuOhK+bYNbn8KNFHUesLIe
	CRrJ0aTsM47nNkcstiDTF6kwUhjBRJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356665;
	b=JUdNr/ln2i4eLh5i2W8nxCEc6XMBoiff7KQ+8RQ9HikQKUAGmbshEpnAatxKy+FQp7UKVO
	JJVUv+Z5jf9/x7qq+/W9WvWGA4xkI62b6nres9F9JVMTT2qaLhDu5P0u1WrkjNqxN6H+R6
	r5Le7HASJB7WxDz6iVja2hxayx1w7PI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DZMCVqGY;
	spf=pass (imf24.hostedemail.com: domain of 3t7XzaggKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3t7XzaggKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4a68926c8c4so2601132fac.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356664; x=1794961464; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlJZl+UE9pf/QC95ZJSnwsGYNSdLtTHc9yxgINOhNxY=;
        b=DZMCVqGYshlDj/0SRNBPxXbQnqUh76NQEvsv7LBXf59Vqk7Eb+yDYr+sFYbMQRtoHb
         ysbkfzPSx2Le8Yb/WU0VePh+rbo/Fgc00HbXDtu7ATgF2UccQUcskHxkldLpkqyLxhaV
         bz8o0nsFm1gKa2TmoY2jJVPH4r8dAFxLqUXYVfaxIAJdfUaH3I8zy3lFNP7OfVjc0Nxe
         9btsHKj2oRFtgDxg4zHGzbjVQqLNPUOj/5h/Q+Zt1RECOiY1/6ZJ/E2IyqfFQZ8A+diN
         XSV+NiU+ipQlvnnfgmNvTsYxJhOb8BPFM69rexwA3+r7erxhEpb4ZOIlVeV64cYA94xk
         sm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356664; x=1794961464;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WlJZl+UE9pf/QC95ZJSnwsGYNSdLtTHc9yxgINOhNxY=;
        b=FEeTJpVzx4trVzWE1THYd3zV+7mmyHbt8QTtUtnlRVVhux+apyJhEkQbRLC2IMg5a8
         tOoE3IisBenmwHGZwPjC6fsSG5ZmB29rhE6tUMQJgkkl+zawq5LunnRXP0a0cYDFPCbR
         tWhgPgeNB5a9ZIgAJsMyvYlnils8frNvLpCHRiq4Yk7YFh3p17XANDp3uOhrjU+4LjaD
         nGsB0Exj0f9uBU7sVo+4H1d5MY+Ocgr23VlhXvOn+lH2/S/6RoQhoCn8BNrIKwqvKwuc
         /eBRcoWDDGmRJzP4zxqLE3rRpW5XsaDoGrmotpHTZlGOpMEGHY77hi1eroN9o56/hytu
         90OA==
X-Forwarded-Encrypted: i=1; AL+hErEPpglPjhuNljMk//KLn5Tu3hT4b3VetQXLpL130zAY1dDJD4HbNdUZTqdJeMbEQRq6v/pLb6weGg==@kvack.org
X-Gm-Message-State: APuU4Z9VTLic41nWWvjpx1e6oLKOPcCpoV1LdhadgyW50LNqzvDs+JVt
	JEX5kbfOIgEdyZSkvqbrP1lJ1/hVhsnLyln46zavyqu58yYWuAvuxjPR7DJ35VXAxJagFbEMgEU
	Amn+ezHJLgc6TWg==
X-Received: from iovs14.prod.google.com ([2002:a05:6602:2bce:b0:9c7:8645:9285])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a01:b0:540:5827:6d8a with SMTP id 5614622812f47-56b98d23beemr555789b6e.66.1794356663846;
 Tue, 10 Nov 2026 16:24:23 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:51 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-14-dmatlack@google.com>
Subject: [PATCH v4 13/19] mm/shmem_luo: Allow preserving tmpfs files
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1EE0F180004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: tbqrxb3n98ry1qmscjuhfyywni59kkrh
X-Rspam-User: 
X-HE-Tag: 1794356664-779258
X-HE-Meta: U2FsdGVkX1/EXDChjqkMxrOz+VIMZ9CN9SQ4phgV3FypsA1T8IrlOQPYfZCu3/jEFSx60Btn5CpQR++w1PerbU/LfjP6B8BdN+8IPRyFHkT8LEn9U26MGS3YIKT1e9w1+t3RU0YqEzwKg8O/7AgPcRbIvLx3JMn7h9DyOTibiEmOhVCGJZwZZCOmYhDdFyFMECEtPaDbZDGQdLabrn8KSWqWMgfq5eRsHzX73Vzvk9n4cuuJQ8W1IwzMQHfjgwhZ+PopIHvtr/9Ws6BXoqTnkg4dqxK3V9l9qr94UVmvxVewUQx/GgirfQvqUJAO73gcXOG/qpZVeVaqX4VFavsw3fd6NbNXI8N+nJep+EyKgqjT0XK8CevdV7jcPU0p7cj33oAL9LPT55tKUD2jd8HF5/xsTogbrhB9K09Gd9FCTpnrohQk1EIkmrS3Pgftbwv9pFXAzkm2ddn4IFCkNXKSpLPMiAlBAdWDa7UxnWdRsbGDoAtW6Hmp264L4UMGKjS8vXVuTpZ8FR1FcTyjuLCMG3sGAs0rhTrvzKHcGluCnfKLrzwYbftS3GK+7FbCC7R6OZf/MxSPV47a9ye84Wly2lKtWJYjsBf2p11VXgBq/6FLHW8p+iF366mmu9IvHpsiE3qWM9wffmrygzhwgfVJx1iGUgsJ0IjUkowHGm2Snij2SEba1NpTy+LWkTwyi3e3PMV09aVsqH4+o0jC+LxYgRzRdyXR0pAGFXR727CWriLNbApZujSg4ZL+N3IBKTKBPq3AYtTTXZEh7csBZSNjQswDj/9FM5t4bnOUMqHkUNMlC3Yb19dFpL/4YSkXXNxSHBplLWa91pgNjLViXvqQ/thsdC4q8gbz806dyTjgdhhlmn6Lm40CwrY/LuxQ22QX8G3ZJHk40VdxnukOtvM9kZ8vakYhrrI8JbkxyiHICoOlJYxEjXvHo59Gys75v4djaRgRmLdfXWctIZWTufQ
 nzBM0kfl
 hEO4VT3HgbxM+PRm+xcTmzzFHJAv7WZvzzfUhJnE4Te+oGpEw35rKfUB0sCNdUWLyREhWX1x6L8e138W0he1ibn1GzMohiQOCe0h0kMAVdcTB+49L4p4SIFqMo3Z394CXaK9ewEOZgqsWg0YP4rlBHbUYh4DKMrYKREZlAn1QOw2dyIs+knEXFb/+GWRD+ZhoJoVhlO//mCnBoSATXQupDzln0wDzry5C5kwsKACPJyel2NSke+c/vyPT3y/Gyzfh2DjpQngAVOqDXCSREyQybY3mh3tGT1d89ECZT/1DTterqUhCzME7l4UbjeVmWKWiVzwjfI7j64bZeXSMIKbT9KTZAwscL+wH2NbW3l4pNtFJ8I2jGL2OIewEDc5OTDWDReP1uQB0MnhfySHksmEysPAKnwO7UawemVhlez3XcxID1ustsBv2CJ4pibgBWAerx+XYOAJduPNmBGwN8bLular+zn+6J3gf8Vp48oXwByOCCPSelwS1eoAiSngl/gjdt/wCTYyV9/cGnOqAtWvcinTm7dhVJRpK8xCezUR5MMEXjAVGUv6Cw6FIP9p7raWW2iZsQbWPI1BOyqcqDk7O5oqxhCtfLOxSnlhL1sswIUXcnGaDVpImDO9kw5XvWRGRoD7ifhPxT9kAF6nZjAWFDRZf7CzdmyHvHDVUP6wrzC4UkPn49FQS5yX4AO/NYadf2Ozt1239d5B39rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow preserving files on tmpfs mounts by dropping the link count check
from shmem_luo_can_preserve(). The check was meant to limit preservation
to memfds, which never have links. It isn't needed anymore, since tmpfs
files are now retrieved into a file on a tmpfs mount.

Userspace can keep using a linked file by its path until the Live
Update. The path of the file isn't preserved. Userspace creates the file
to retrieve it into, and can then link that file at the path it wants.

Preserving a linked file affects everyone who opens it by its path,
since its size is frozen while it is preserved. The permission check
added by "mm/shmem_luo: Require permission to preserve a file" covers
that: Callers need permission to write to the file, or must own it if
its size can't change anyway.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/shmem_luo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index 7242664ee4ae..94d617b15489 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -757,9 +757,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 static bool shmem_luo_can_preserve(struct liveupdate_file_handler *handler,
 				   struct file *file)
 {
-	struct inode *inode = file_inode(file);
-
-	return shmem_file(file) && !inode->i_nlink;
+	return shmem_file(file);
 }
 
 static unsigned long shmem_luo_get_id(struct file *file)
-- 
2.56.0.542.g3ef89b7020-goog


