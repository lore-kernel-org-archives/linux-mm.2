Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F31D60A261F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Jl72npAv
Received: by kanga.kvack.org (Postfix)
	id 26C6D6B05DD; Tue, 10 Nov 2026 15:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243826B05DE; Tue, 10 Nov 2026 15:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A896B05DF; Tue, 10 Nov 2026 15:24:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E76C76B05DD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:24:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88E14160A78
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:20 +0000 (UTC)
X-FDA: 85420336680.22.F46274B
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id B514020007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=Jl72npAv;
	spf=pass (imf03.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.169 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4CgF1MujLyKKs4MDsPCH+PRIQeRT4qSq6PrwqdYMBE=;
	b=01vl2KGhLajxpESqDoJjGNya0FGTaEOYV0/XXgoBPO0VeplKtBGr37cuC8+lYhpsBEI6F+
	YWWTzvz0UnAMkR6lIBPg7Vo/9PWWsgmjkNkUpFtwpGqUObVWinxUULD0js1Zm5YDO5sOBP
	SgGY+oJp+VKJkVxx51gXvNTTjOXfGP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342258;
	b=klS5YaqZvv5Jcuuq3f48M9jsEdu7Zfm6ZqQPj/s/CkGPbc/amvSQUZjVl2DV5IUtKfe+7T
	ScjAkVCPawle+zim9LuQwj0Y7W/6fuITxGCTLdkJ08ZqXcMrW67H6HRmSls245BIfA31k4
	9SINipnVMM8ELadH15pRGYHh1YMjY/k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=Jl72npAv;
	spf=pass (imf03.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.169 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3282db206d3so1708486eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1794342257; x=1794947057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U4CgF1MujLyKKs4MDsPCH+PRIQeRT4qSq6PrwqdYMBE=;
        b=Jl72npAvDqyYsoBPdJVvfAJU7Ht2StjxcYCsMNabCsoCTldODcyN9tvXe5Tt76PMMV
         4u/uoMOoj2H+cSPdn1SHUmGNYWemobytlSMveFhgtKdTkiZCl5xcrOc3MB5NdmtP/l7A
         xrof0sELfx5G+AZrPStdLth8hhrHMwbhAfZujaTby4vVeL5iBJTZbUd9nG/2cXRbmsQz
         iauq+lyq7Ftdrwdhx7/OTUwzjxGl97WNzksw/vYWWtqkA5bA+61GfC+erjYRdKw5IAQe
         j4JibAPgdm3bNI/BoqkVepmdlqsMt2b43p8hWuxacM+DPBvYLDwvkQSiIlddA6QvyGo0
         y8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342257; x=1794947057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U4CgF1MujLyKKs4MDsPCH+PRIQeRT4qSq6PrwqdYMBE=;
        b=RupfZvRkfyBVfWcES8SmoQ52dJ6hHRe6CTtLLO/IX8TdbpjAnDVDWOSPvqGSd6n9YW
         Ghq89pG+b/X0QDJ+jJsj09w6No04wuwjOhV/GiDjMjb40bo2i7hxKYciNkfxuEaChfPb
         gILuxZBD53qHBmadiWkNTMN58zuFMmBcRLTUUBZ4UdEStsu1XvrcM39K5yWurwWL5N+c
         CSEGkzl2Z2TPn9DvJaux842HeL3tEudn3HPtUErkMa4l6td8zsbGGp3QOqyrR5GmIQI+
         Sy8Kg+6mTisqJqwH9tK3QbezoZCiU30BOzEyIlcr6F33gLvo3ERPiS7j9zJxd8+pMCMF
         QOpA==
X-Forwarded-Encrypted: i=1; AL+hErHRSdMdUpHUtPOYh0EOZc7IxpI9T+X+9BLVll/xU9VdaGmV9T5ffnQG2jhzGtC6tb4aZT5JB2cO+Q==@kvack.org
X-Gm-Message-State: APuU4Z+cBGA4VXw87SsuN8NrtK/K3jJF8W+sX4Qf6Y7nJETwFkxXWPkz
	E2kLxGJH01wGBTmwXaSLh2DKydFwoxSxuMn0VjI5S8Fl3yQhuB/Kzpj6X+PCZXPJEUGQ
X-Gm-Gg: AYBFou1u8Cab50JDO+N2/6AywBAyt3r5rbv4w0cC99q+IEXqhzqlwoQrTGL912pPbYn
	fNOTL5zzhu+n3rZSo4ev8i9KwHQMR2OP8BJIkBZYif9ZfBvUeYteJpTGjdamp0loiD7i6Bb5Vnm
	3qwi6nXNQryMNb+86KqL2GPf+GFj6RySsVR7Cm4EMuoDT/OSXWOxhkvb6+5haFAz7fDSzSIyL9p
	GCzPSOZsYSXsGtG1+pRNXRGXW1WYtxjHo0Q0BWiS6byL0G41EGpR2DvajcipwnOK90hcPbtHRE3
	240nFjSCue5V6KsZRHTEnW8nnNDG1aozvQLuRAOskdBx1b69or2RI9ZkA3qk5heY0PxlZNOPg7C
	TrSasH3VNzOeaFIaTCfcVGkbVuAgwkBD9T2Ph51TZRaQAA/lCjB3aDaVrU/cKckfbHPMnRwG+/I
	nwuPVVWsLb5e3WUSrEiwwmSgAbx59CBDt7nsuojQVvu1D3UEx0GEK/eeR+sT3fwz0DiCEHv8NwD
	AmawlKjwyj0ALBMOzV5XFCt+v4SyX62fno9JyM4QXuK85Y8+QLi72xWQBmpxkMOVrnVLhnPm+84
	hSOT8+T1IF3pxSuq/NyaMijBNwHdGaivMOvWSe8aPsHOVjG3PO5KNBveP6hAoXRabyd5jC2JUkJ
	TBV26o4tIALPU1BjoOOJmlySZD9oauqpTohfNjBosBh1r7PmZZniRvA==
X-Received: by 2002:a05:7300:b282:b0:368:2548:c08b with SMTP id 5a478bee46e88-37685896be0mr560200eec.21.1794342257246;
        Tue, 10 Nov 2026 12:24:17 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:147:2742:6545:702a:2431:7dca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm10076615eec.21.2026.11.10.12.24.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 12:24:16 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>,
	Kees Cook <kees@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Subject: [RFC PATCH v3 5/6] kernel: add KAP checks for unshare and setns
Date: Wed, 11 Nov 2026 01:52:45 +0530
Message-ID: <20261110202246.274-6-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110202246.274-1-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 9mwnogcd1e9yqhpsgohqfaicdwn83mk9
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B514020007
X-Rspam-User: 
X-HE-Tag: 1794342258-2653
X-HE-Meta: U2FsdGVkX1+k5XEq+nbDpo9xj1tHxQ/v1E2GybNX1BvH2CYzZBm6pmOPeCMj0Sbu7OW469QhHJ9Bw4TGIf0iMC1RqSHoChQl5m445BMCBEanyWmhzeRZ7VdS1XRoQybzNqkybFBr7DYtqHURMn37VVhFS+G0aSzc+vXHeVach15c4f5UdOJnemCkxjVZUBfvsgXI5ZN9L3C//xWX9KecSDos1mOYoTGvku+uRUpetwI8Dgh/jovErvxfpv1gQM9xUzREN52xThGsSVIxu1jzPJMl747cob02DHi/1RYey2d8ESEx8HjTRA2jXi9wPhPqGfREVP5jih7k63e6PEjqs4sNxW78FMwbpBU20rh6wKdXpmNljnFDL3bWasLPH7NS9CKEHmBb5ZPd+dyXTJr1eBdddIiYjLqbIHxBvBvfeZYvGQxuEWul/qosVmBRbY/MZNFfqMQMeiIva5wQq+DPl/vYIO2bZmVr6DLUGadPk72VnW3xhesjVd9cqoocICbWHzyQKMCRYiKkgrFl1gidCMLrRU+F+BOSug+de50JAFc45eBK5SOxGbbQny6DcJL8nf3kOcyMeZRM2s/NzhhC7fTkQj2044uc4drvGvCx+SlSTGDt0NQ2w1G2yKRH8dSVDNYDGXgCrUixt5lNLjDEwN2BH4WVC7w4oUVJfLzV0tuSTcy1ncpW0zxD/b7YJX/HH6hvIHKCRmnG7plrKf3I7mLX82hEPLWFTjJ2P4y5KfSO1UiCA3JVJN3fkH2FEyaS4lnu7pWLv8Lo+VnKHEQc9Psaqf3nk0IEZtZTKUdfInntjYTNcAH2LHbLcj0w93eMG/wb7v9UlnPbI0gtlastWzBSovOZeMaM9eztTNx5FfKO+u7Yofug08CCm19eST1CApalrJuINd3EErF/6xyypXnSzb/vb/w/YyD2pKqxngLZ3fMmBhgi2ywzVq4J3NOi3Dw5zajUUP8T3vJZx0A
 /TNBSQJa
 SBTqtF0A5dg+tlMtcdvRTHlG5BK3F5rXa8O74ZFUXhXWs9L/1qNOwe5Aq8uqjf0PPXH6gYz8R8VMbulogwqAhnmOczlreP4UMiR1j8lDTrti1jCgjq+JidZWeJlf2xodHevOvQFSVY+KwVVrjp78ltNurjm1WyfLGRz7021hZOhsgJPd+h1+XQBHQBbzUEhMcn4Gof0bS0pGE83F4JxyBk52jiLiXGIFbN6OyPuPn4dbovzWDaQHGKmlN34WA0gcY2GkqW02s0iGBXJ7ZZ2LkKXaWbJoZEiEMTjIBC+VbuIXC4Ky4tzkga80fzp3XPbF6FW6EivTzi6AmbSsH8H3XcNZchiEJHOZI/+aBby3RBsJVnTqmus2zNJ+iu/r9NQARFFojfYiGjoTfJEBPlHMkTCcuvLfs9W8sbfXZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check unshare and setns against the bound task's authority. Neither
has an LSM hook, so they call KAP directly. Every namespace type is
checked, and setns checks the type of the namespace it is given.

Unbound tasks are not checked.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 kernel/fork.c    | 4 ++++
 kernel/nsproxy.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index eb198c8..4216a2d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -52,6 +52,7 @@
 #include <linux/cpu.h>
 #include <linux/cgroup.h>
 #include <linux/security.h>
+#include <linux/kap.h>
 #include <linux/hugetlb.h>
 #include <linux/seccomp.h>
 #include <linux/swap.h>
@@ -3276,6 +3277,9 @@ int ksys_unshare(unsigned long unshare_flags)
 			 current->fs != current->real_fs);
 
 	err = check_unshare_flags(unshare_flags);
+	if (err)
+		goto bad_unshare_out;
+	err = kap_check_namespace_flags(unshare_flags, "unshare");
 	if (err)
 		goto bad_unshare_out;
 	/*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 3fb1595..d41d7f5 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/kap.h>
 #include <linux/cgroup.h>
 #include <linux/perf_event.h>
 #include <linux/nstree.h>
@@ -589,6 +590,10 @@ SYSCALL_DEFINE2(setns, int, fd, int, flags)
 	if (err)
 		goto out;
 
+	err = kap_check_namespace_flags(flags, "setns");
+	if (err)
+		goto out;
+
 	err = prepare_nsset(flags, &nsset);
 	if (err)
 		goto out;
-- 
2.53.0


