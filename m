Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629AACAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995488E0007; Mon, 22 Sep 2025 05:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CF38E0001; Mon, 22 Sep 2025 05:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8831D8E0007; Mon, 22 Sep 2025 05:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 720DD8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:33:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C943C02F3
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:33:36 +0000 (UTC)
X-FDA: 83916373632.18.D4B825F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40AD940005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:33:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ROz0DKns;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758533614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89qPC2dMk40SQhoKG37yGCiQt/NY420sGfty0Meng0w=;
	b=WltfOGxS2QnmhVsQWEVUZjEj74T+yN0MkuYmhI2pjR7vMUtlSnw7nYQfgNFxQshYZgYz5u
	tYDGpWW6jwYcAFQN1QiW9ueAyNLikWseWPZsZ/KuEnYtDhxGVXw/dEeV0vvJgWDwtyr6xm
	u7NnDsBrcR3h+b3LW1STTl13C26WAV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758533614; a=rsa-sha256;
	cv=none;
	b=c0rkR/FhY0jToeYZVUCqmiao8tjW0vmmKSlPKWgOX6IDYC2AZMXj/KCDF2HfqV+TIonTEX
	37aMEfNa/hhPWy8Owuu3dofH0YbgWMwtQMEusEQSC3WVypHb581aSDd7mr43Avxsx0lWDF
	41aA7yaGlt/eIKmCmCjJHDTU6HqISgY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ROz0DKns;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45df0cde41bso26945055e9.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758533612; x=1759138412; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89qPC2dMk40SQhoKG37yGCiQt/NY420sGfty0Meng0w=;
        b=ROz0DKnsVCoYexFWXUuMgYFHT0yiUQTbjVNNKptiDyFFOLIiBckr/J8kqpiI2gRtn7
         XB5eVSkWT39mejeII1TgxnUNrvJ9vV40kZWCF10XHlZ08CEibivtVI7TQTwRlpmQfzis
         Zx5Bih2c29FVgm4bp/2dhIC+WLoEpaxFNTkFrXEJrxKVZlCa0M9TmzHHBwMspHrDYYwI
         +sz89IN7kvIhn7j7t7SVmMe2GxX61zPaKUIY3DUVFCCd5//Qv8Pdm1vWst1prXwklhXu
         knml91mXiwtlGxl71hUx2+038eLpkvZ8PlRRLETFiN04/PEeGhokdwQWqy5Lqbv7eqW/
         zBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758533612; x=1759138412;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89qPC2dMk40SQhoKG37yGCiQt/NY420sGfty0Meng0w=;
        b=bh57LCACEXKSem/ftn08yLj4L+QX2QubYl8w6pvrXQTHXi5SnGRTWdfCygrlIDUB/F
         9u8JyoJ20oi3CxX8bjqmmNJNV+MX++t9zTre7UIM955K+w4rrbzOLMjQhh4hnfR0ibnR
         C50TRPSucYZue+Ugw1cu3o8/7sCbSTTRuf2RRKUH4tC+Ixx/JXk+99uHW5lUKhU3b3yK
         Sg4zMucp6S95hS0QzhMeyzb3EJYFUF+vwQFZTvv6dQNCJ4GLj4eMXDoAWe9glzbUZDcw
         tQGQHFNKjmYDZ403Mzh6dBvyjJx1g9y2byLFKO5bfTspsIaqhcsD7PDGPZORneH72B3T
         /1jw==
X-Forwarded-Encrypted: i=1; AJvYcCVP4KgBw/mkJlXYjws00CPmv8Mmj7nsQh0H4zhar6IUgp1NAOf+S8NYeBkzJMWFdAv7tcxsSLW1MA==@kvack.org
X-Gm-Message-State: AOJu0YyyNrc+kveh3GRzJsNFO2+EJo4vMp5CGUWwLrreyrAZ1mPSQ82n
	k6yCQxlKCIKS/seBSJCv3ofE8/yL3L0Bx7BGF5OrFkvr1allAmvZ8wY+CSkPQWE2ZA==
X-Gm-Gg: ASbGnctVDnGz0aWFdBTDNPz1fUKPN7nKlEtH7X/ApE6dHP9LFu5HjaOhHmzW61mUZZ7
	gfHbhvNZl3dDOUwE2pLsUFGAdBZN/+WBb19Y/oqCkYBBEdbzR9d1I8joDWGuRbaXZw3ly/EMigs
	dQI2k6lPdKvLdpZdYzyLYJnexFLaMYZ6w6Rt3DkPnH3xwYZDtPAVJFrh21BGAqgr44WxwGMyW3f
	ZChHDgbm3M1zG7UYnE1nFMLNTtcNWp7xSKlx77DKj86LQEal4eccbMOzrQ7xWyYR/JrHfiWd66R
	3P2NaSlp4nerIhJVCkcWcK5Qo/SUPHqIfTsL0EzWxvaFUIsn36phPEubuztls88P+pmZJgmqiTh
	fpZZ2xkeliwmJyvApbo0KWUhP5s4yvMXG5IyMl5pwzj+AAO+vCvpbu2LRbGM=
X-Google-Smtp-Source: AGHT+IEkoU9ognY1IS2/WNXTQHBehT3iG6jr+rUMfSA5BLARxzu2twytBIMtwJpeHRGrTnG81Cn1IQ==
X-Received: by 2002:a05:600c:46c6:b0:45b:804a:a65e with SMTP id 5b1f17b1804b1-467ebbbff33mr123610355e9.28.1758533612329;
        Mon, 22 Sep 2025 02:33:32 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:8fed:21ad:ce77:2e15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46d1f3e1b03sm39713145e9.23.2025.09.22.02.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:33:31 -0700 (PDT)
Date: Mon, 22 Sep 2025 11:33:23 +0200
From: Marco Elver <elver@google.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
Message-ID: <aNEX46WJh2IWhVUc@elver.google.com>
References: <20250918140451.1289454-1-elver@google.com>
 <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162>
 <20250919140803.GA23745@lst.de>
 <20250919140954.GA24160@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919140954.GA24160@lst.de>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40AD940005
X-Stat-Signature: xyi8au8bjz9nj51wr6m9cmtbw5kkzj36
X-Rspam-User: 
X-HE-Tag: 1758533614-293463
X-HE-Meta: U2FsdGVkX19NGJfdf5RD89KOwJTD6xFai/tgo4coJGAqFg35EQAoJU+pg3EzVeXKsLXfx04FT8/MVjYRDKAC79wmeJ6rfBhbewlLIKPv3nAaM99sZeF5f3LVCryjIktt9ttii8OMvyPm16wr1oY3pKiFk2kNnFNRkSA/JASDIJSG2a9falSVd61OhOqvITTk6ipTufNgQCKpQh0H2ugtPj/bK3jSlvuSoJVL9quMhjH/04CeTiNNaO377N4oL8w+YYgso+q5AJM0uzyLQAvbquXML53irouPh8agT01pRf9EUyajjYpjTn+4K/1d1kIo2mbcJxmGloGbOAPdq+bu2Fenj0btoC2MDdx8zc6s91MpzMpj49BTC/+JQkWKRhIn6OTEDzQ01ZJDaVt58UZ61STN3kFbzxgbWTUtkU3dmOR5yOnYsmmX1Julltb6l7ZknQf5Qx3upSzwgH2nC5JxsjbHrV/kldCNhhluRhxjS/5dwCf0DSokAV2bSebR+v7NPU6myHQJ5XsP9vVruzY+ENLCUkD741pVljCsfNIl2nyJgEAkgdGaARa431J8OQqkcqeuscNZJKEoUnUvjhRcHM7ZmOnAm9jJOq3TvnCHapUHx07SNQpv1ogkjoGf0SVS0V0KnZqqsGSv542UscdbJUhut8a0rjCrzk08QwVEmqa5fqGOASGCN0n1zw2QbQrS4epVPUT/a3nqFiKR/Jkh5iiioTNYAlxYEeUd6a5E+J1R1z8j3UR80RznCQuCgHkEuKMttGkXNXUiSNmY1207eLghKzMdk9h/a/WPtN9FrOBmy52L1w4Ym1aJ9tEIo19fKJKiUX/G9LJpNx2WCtPGIEVdb/0WDubp2oF9rw9B/+k4lnp0jPuSlPchkJSEQg3Nv+ZmOkoo5fkbJ70MK36vQxkYCU9hkLbm4v7fApimMu9wBV9iQzexoBEOi2l/FhGO42uexin8UUJtXfivw8c
 bRz0sGOg
 u7DSEXrvYizzjEi11muFDin+/O4KwsZi7tY4kpyjEAKpxuyLCNLBKZMfuHbKGUrAxrSDbmRS4O1emVcYmTSvk/V6y6GcuUN8C8U9s2Gk84om33KWpjvh5M9HKn2w6t/Wi5RKZMleLWCwy5zSBujWRIo1ypxyt7314ypP41sYqquWWy8Ru48G2x1ymc4E7s+gRIoOuH14Luj59Rli6IiWkGFjXnEGrtUBnxy6tknbbYINmvfs4euAl3F+OEqXFaejaxbMY1hW+kJI4lLHi2wm2AHST5Xz6WB0mDkj+6Fvn1aikHtCX4KHX1/QvCoZdd1yZyR36SJTp1O1n3DyUhStGvrJQLtn8XVLSzD6elZBCIdHGOXTerjaGu144rGeATOpTZkyT704oOADXb1sK05Su1AtunoLmZVM3HkHvvPdQF3FDrbyvOwFEMrVTOt6H1jGawkf9DqvKwEgLd+4RW8T9nhS55O+hyXFsz48nw11eXjNVAdn1ZneqW5smkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 04:09PM +0200, Christoph Hellwig wrote:
> On Fri, Sep 19, 2025 at 04:08:03PM +0200, Christoph Hellwig wrote:
> > I started to play around with that.  For the nvme code adding the
> > annotations was very simply, and I also started adding trivial
> > __guarded_by which instantly found issues.
> > 
> > For XFS it was a lot more work and I still see tons of compiler
> > warnings, which I'm not entirely sure how to address.  Right now I
> > see three major classes:
> 
> And in case anyone cares, here are my patches for that:
> 
> https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/cap-analysis
> 
> git://git.infradead.org/users/hch/misc.git cap-analysis

I gave this a try, and with the below patch and the Clang fix [1],
fs/xfs compiles cleanly. I think the fundamental limitation are the
conditional locking wrappers. I suspect it's possible to do better than
disabling the analysis here, by overapproximating the lock set taken
(like you did elsewhere), so that at least the callers are checked, but
when I tried it showed lots of callers need annotating as well, so I
gave up at that point. Still, it might be better than no checking at
all.

[1] https://github.com/llvm/llvm-project/pull/159921

Thanks,
 -- Marco


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c39251961a3..f371a08e5d44 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -140,6 +140,7 @@ void
 xfs_ilock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
 
@@ -183,6 +184,7 @@ int
 xfs_ilock_nowait(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
 
@@ -243,6 +245,7 @@ void
 xfs_iunlock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	xfs_lock_flags_assert(lock_flags);
 
@@ -272,6 +275,7 @@ void
 xfs_ilock_demote(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL));
 	ASSERT((lock_flags &
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d9ac9521c203..9c4ec3aa8bf9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -472,6 +472,7 @@ xfs_log_reserve(
 static void
 xlog_state_shutdown_callbacks(
 	struct xlog		*log)
+	__must_hold(&log->l_icloglock)
 {
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);

