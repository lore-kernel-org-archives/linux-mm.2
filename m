Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15582606A336
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rq12XRzF
Received: by kanga.kvack.org (Postfix)
	id 1332F6B05B2; Mon,  9 Nov 2026 04:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4306B05B3; Mon,  9 Nov 2026 04:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15916B05B4; Mon,  9 Nov 2026 04:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3EEC6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:15:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AD7AA05F7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:15:34 +0000 (UTC)
X-FDA: 85415022588.11.F73CDF4
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78CE4C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:15:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Rq12XRzF;
	spf=pass (imf28.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794215732;
	b=OeT4GVkT9j6/PA2w/gno8FD1OCF/U3oOgyCUqt1wD+Oh/WizcJOaIfx59xazMCq0QvhUgy
	Xt64qMRUC2tgRg2/oFmGlG0jaJ+xdmP7fcMFdwj8iHT85AtCc92di54lqHB9AVI0PUpLvI
	/CGRw/Ku0xxyN3J2CzSkM+zgRlRDe3Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Rq12XRzF;
	spf=pass (imf28.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794215732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAZcXDlQZddbY3M/muInvcNY1JTv1MgI/C6goEt1No4=;
	b=e0eJdI6fSHBPScVbIWoY39ViyE2PSteIQFcSv5k7rCStCWXMzNiv7cADCIYJyPjqaR6zBA
	RtEkZYwYxg/kn2S23Wx3OuPeVHwdDuAWPANqcyZvjOwwji4JXf2piarDkO3qmXxfYpmShT
	Kvt3F+E90us/VWRQAfe8xdGllpMRCI4=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-14394530ec6so740808c88.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794215731; x=1794820531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nAZcXDlQZddbY3M/muInvcNY1JTv1MgI/C6goEt1No4=;
        b=Rq12XRzFS6ucPicTY27qZSnUZcdnkGshJq/gysKeHkRucvebzPnloX5xve5Sapmi1J
         B/8dHt2zZeuyTa5M1SdsqtRz4LCL036Sks8lQRXCBtWOBB4OaO/GD5Oz1Y5AXp1E2fTo
         E+alcDi9r6ghnY5oFUVMciRR8tFqU96I2R1ULak/HeNk8Sth3CC4FcrPj2o71skGGKUA
         kamH+PYPCTTZ3qtb2+4/IYTU2UYqJ++F9Iift2J3NOPcd1YgWeSqpOOa/b/VuQhQ4ikm
         lp0hOKkhayI2uNHq3UefmObsX2FKGJLkoqIJnG3DBdCqTufcN79/uo02lYYLwcY4iFqV
         Fm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794215731; x=1794820531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nAZcXDlQZddbY3M/muInvcNY1JTv1MgI/C6goEt1No4=;
        b=zg4ruazXyYb2vseuV5ZHWE80Uln6JeAIm3gBiyY4sac3cQMOADQvYj2+V+8uKSwq4U
         12PebEEnbakulP/P4SoZy2Dm3Fc8/BFNXUvb4ACTe4UCVtyUH2w0skbaezupfnWnTz+n
         TsSOamh+Pw1JTarih2w43xnpjyr4KWCA8S0uounJNw4+bGc8CqM4VkFCF/eiY3Shk84c
         R2FrreIcyLtftzKq4dXLm/KiSiiKV6gW9r6jE0DA0a24a0/TJmzh3RS+3QGFAYEdmGVg
         U7RsZ/M7cjzJhIa+mT2zTvDoWZQljRMHhG7qp7qm8TMn/EtsEhufhP10+/vCjmVTARKT
         sEyg==
X-Gm-Message-State: APuU4Z+do2ajuGoKAEvvmq/MH3WHK4PihwL/IGfJoUYtiI8K9+voaKG3
	z2a3mm7uIh6/MLG0YM1AFhT+C7+rpCk2oTdhXOhXoQDFVyAZOfOB2+B7
X-Gm-Gg: AYBFou1eXUFqn3XmnudAJVPwMje30/m07jQNj3Il0qAL6yFskoJV6Ji76caE5mTcBuk
	XIL+emmN1f3nXs6vquLpJVpmNQKHmlBLUKIYxJYZbdERCl5mlIYhBbZSfADaMYHeE1wWccLps/b
	4Xs43y6q12IoZ+teJuwmzsK5uwwEqQOhGO3NvI0GCiJaDdU0KGog50YwAd5n/rY2p98qwrWIm0o
	+XnktyH9TNpBeRHwRpFi6/jCBdPvjODsAHv7DXarHfuRt8YSmVoV8zw8+yibSTfujZ6zVhutIxM
	/NnIf3nXuOTwgEIHpjPbtd3kJtQisTZijPyoQJQbgHMxfq42IlY9Fcf3W8IKNMe5MO7rOjB3xum
	ZZxedh/VWwySAu6OUEe+Z64Rv+VIcrWq5XHMT0UK8/37tQQMna0LfzlM08f59yBUVouCwnTqdtl
	JabjcwADQyfLekjjO1Pd6fre+BmSnhkHv7s2nSNa+Z6rpvtTZkc3yk9xElRu2Qopho2iDSo0Pt6
	GARkNc+6736o2qjT9N8M3Ui3SViJo1syaq70qqYd3Yu1BYKQmh7S2BIavYl44k2a7IvJ+zusIaF
	it1BEzAoLcYyL9G15uwzqBFTTDVpx3eUIpvyoSADcoEn5Ul/N37AFkj02Ayqi9NOiQ==
X-Received: by 2002:a05:7022:e803:b0:1ad:4ef5:ffed with SMTP id a92af1059eb24-1b39fefb9e8mr5783381c88.38.1794215730818;
        Mon, 09 Nov 2026 01:15:30 -0800 (PST)
Received: from LAPTOP-KD1TH5BD.tail375eb4.ts.net ([47.11.106.86])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b375604109sm14379505c88.10.2026.11.09.01.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:15:30 -0800 (PST)
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
To: akpm@linux-foundation.org,
	willy@infradead.org,
	jack@suse.cz
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	fujunjie1@qq.com,
	vishal.moola@gmail.com,
	roman.gushchin@linux.dev,
	Trace <tracekotae@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/filemap: restart mmap readahead on sequential faults after many misses
Date: Mon,  9 Nov 2026 09:14:44 +0000
Message-ID: <20261109091444.128521-1-gopalmalaviya53@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105192517.228523-1-tracekotae@gmail.com>
References: <20261105192517.228523-1-tracekotae@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gdc46ws3bgdzam9hhx8j85jzqj6696eo
X-Rspamd-Queue-Id: 78CE4C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794215732-71934
X-HE-Meta: U2FsdGVkX18ssu/Ov3lfqwcD5ZVME9eXwXYGw5TwHvVT8k6WqxUZLvZQxf3ydEzBVjJLr4vl7xxFLKm8yKzmlvS+LK2F1sw1VVCM8LtzLMT/hkGG/+8OaTKz6y+6cQ09s0fy4J/qDY4c87Ey78WK/pvlsZvfZfgfMSnTQgAFFPPnpQlm0kNbaqAx6/MWrp7ep+gY/eUab4ohW5GIcdYJhZUBsTYjvwzJm3v8EmEeM9LO1WuQSO5CNCkaBjo+va45991sA7ePhqzkaqx5V/Bzw7aBrpvFtlnIqlR1jav4tF7Pz0694GdhhULO/XVhKKUfKxQX/eJasK7ScmsWplw4YFhxj1J6DPiZ+MvnZ4+lfeETZ8IyG2JjCHomVwNJEshF5O8ZybOw6nWV6vQmK4mAfaH4TsEnEqbND6rPvS6PxUX6GV23BJUqITGsE69ehCmyc9z5BnNMgyo3VZ6EvgMeG5VnENUk+aT7Vlr2UZaUk6wwj31sMXX4vtZxNXnu07KQqmr3nHbG9D6YPw+1c3FPNsj60kbw8yhu3ugvdllmm5AIgKUm2jltfUGfeb5hA+33wIUVDbom5nFe2cQ2QQB5KOZnDfnVxScoHkDayy8z43cLcHm9EWQq9odLIaoVC5NcsGfjeFCSZ0Abu6dfyiavifDLtsxXM46aw8+cn/lI1CHhRl3WP3FkWcxA7DtlbjQeI1UWlBobG+6oY+VyO/4ARizySWoURX8H8J9XVaLOeAKSLihMqrcv7SinZGfk4rglhVPtC4rCu38TRYoyiDJxIHaYbwraKvNBpZ0xX4njpJAUWq14MXy3r8kGYptinuM+ST7/FvpiHHWOIO9YrV8bZhPTvDWLl08/g2aCRnc2cxz8rjdWP6jTuqkCSVlmBNw8awPT8No4w3a0lssEe6QRJCNJklRcJ8F7IFhUL1BZSqX6oerLW5nyydgbCuRU442EKL6eNqhQfyrBZwpiYmN
 QniyUoud
 WlpPRo97vBKrR3EtRJU3X/6hkESQ6aGaAbL29pfRgpSeL6LcahxX5FsbbQ0IZNQVbhsRKO6l76PsaeLg6Fy3FDyNimGA/R5w1Aidbw2ep4nEs+JxDR2r4qQB33/ooBN4GZujX0w1oY+WsewdWdo3k5ab0zV+PCVot0wKnLrxjezPL7XgL4c5j3YaizZ3QFb97lt765vud95ZNJrRoXeWe1giZndxz4AAO0GjGTFG77oC/jAD9GjDm/Y82oJhZfhYZEijtmMi3Z+satxwZrjPfaHccIXGkROaa3UJBZ0Tl0+ZBXYeeZQgs+MW2zqGaLVhH5xYbeZ6SterB9c/qsmUM/s6pzyym+87pzSoG6Mp7YUYpEVnQRzWf21VEiLfAvVLzjz2jd44uR4hMdAXwP5wMKRAsaD+LJvG8bnBwwzkEf3I6Q07h93B3BN9HFWzzJpexIx5DiPRT7VWVbxXXAbflHN6xeGIp57gqMeGkMp2TUD9zJWCg0Zn8jVvLdbTgQtdPaWVC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 9b0fcac3cfe7 ("mm/filemap: do not count FAULT_FLAG_TRIED
retries as mmap hits"), about a hundred sparse mmap faults push
mmap_miss over MMAP_LOTSAMISS and turn off mmap read-around, as
intended. But mmap_miss only comes down on hits on pages that
read-around brought in, and with read-around off there are none. A file
that is then read sequentially gets a synchronous single-page read for
every page until it is opened again.

When a miss above the limit is on the page right after the previous
miss, start readahead the way a sequential read() miss does, with
page_cache_sync_ra(), and keep mmap_miss at its cap so that hits on
that small first window do not bring back full read-around for random
access.

Tested in a KVM guest (x86_64, 2 vCPUs, 3 GiB) with ext4 on virtio-blk.
"base" is mm-hotfixes-unstable. "95b8e" is commit 95b8e432265f ("mm: use
zone lock guard in __offline_isolated_pages()"), the last one before the
series of 9b0fcac3cfe7. Commit 0b9c0aeba938 ("mm/filemap: count only the
faulting address as a mmap hit"), the first of that series, gives the
same results as 95b8e for the reproducer.

Reproducer from the report, read_ahead_kb 128, major faults:

                                         95b8e    base  patched
  sequential only                            1       1        1
  sparse pass, then sequential               1   16384        2
  sparse, MADV_SEQUENTIAL, sequential      512     512      512
  sparse, close and reopen, sequential       1       1        1

Touching 1% of the pages of a cold 20 GiB file, larger than memory,
MiB read from disk:

                       read_ahead_kb 128        read_ahead_kb 8192
                      95b8e  base patched     95b8e   base patched
  random               5656   215     215    344731   1032    1032
  stride 2053 pages    6545   216     216    419003    992     992
  random 2-page runs   2992   215     528    173093   1099    2248
  random 4-page runs   1570   216     594     86797   1266    2301

After the sparse pass, reading 32 regions of 2 MiB in turn takes 512
major faults per region on base and 2 with this patch.

Not tested: NFS, the GPU workload from the report, and other
architectures and page sizes.

An AI assistant (Claude) helped with the analysis and the approach, and
wrote the test programs and drafts of the comment and this changelog.
I reviewed, implemented, built and tested the change.

Fixes: 9b0fcac3cfe7 ("mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits")
Reported-by: Trace <tracekotae@gmail.com>
Closes: https://lore.kernel.org/all/20261105192517.228523-1-tracekotae@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Gopal Malaviya <gopalmalaviya53@gmail.com>
---
Notes, not for the changelog:

- Keeping mmap_miss at its cap is the least obvious part. Without it,
  hits on each small window keep mmap_miss near the limit: random 4-page
  runs at read_ahead_kb 8192 read 25896 MiB instead of 2301. A cap of
  MMAP_LOTSAMISS * 2 gave the same results as the full cap in all tests,
  since each new run sets it again. The cost: a reader that jumps
  between sequential runs stays at 2 faults per region, where without
  the cap it is back to 1 after 16 regions.
- A full read-around on the adjacent miss instead of page_cache_sync_ra()
  also fixes the report, but random 2-page runs on a 2600 MiB file at
  read_ahead_kb 128 read 379 MiB instead of 76 (38 on base).
- At read_ahead_kb 8192, this guest's default, the reproducer shows 1
  fault for "sparse pass, then sequential" even on base: the 8 MiB
  windows reach the next sparse pages.
- Patched results matched within 1% over two runs (the 32-region test
  ran once). checkpatch is clean; mm/filemap.o builds without warnings
  with W=1 for x86_64 and i386.
- I can send the test programs if useful.

 mm/filemap.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 371a4bbd06..1548021472 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3398,9 +3398,27 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		/*
 		 * Do we miss much more than hit in this file? If so,
 		 * stop bothering with read-ahead. It will only hurt.
+		 *
+		 * But without read-around no hits are left to bring
+		 * mmap_miss down again, so a file that turns sequential
+		 * would stay without read-ahead. Remember where we missed,
+		 * and treat a miss on the next page like a sequential
+		 * read() miss: page_cache_sync_ra() starts with a small
+		 * window and only grows it while access stays sequential.
+		 * Keep mmap_miss at its limit, so that hits on that window
+		 * do not bring back full read-around for random access.
 		 */
-		if (mmap_miss > MMAP_LOTSAMISS)
+		if (mmap_miss > MMAP_LOTSAMISS) {
+			pgoff_t prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
+
+			ra->prev_pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
+			if (vmf->pgoff - prev_index != 1)
+				return fpin;
+			WRITE_ONCE(ra->mmap_miss, MMAP_LOTSAMISS * 10);
+			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
+			page_cache_sync_ra(&ractl, 1);
 			return fpin;
+		}
 	}
 
 	if (force_thp_readahead) {

base-commit: 09f140d2cb078edfcd08a40a23ead0bdceea30a4
-- 
2.43.0


