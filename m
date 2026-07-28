Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA48C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 07:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4D26B007B; Tue, 28 Jul 2026 03:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B856D6B0088; Tue, 28 Jul 2026 03:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76FB6B008A; Tue, 28 Jul 2026 03:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 605666B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:27:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E013F1A02F6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:27:44 +0000 (UTC)
X-FDA: 85037355648.02.02FFED2
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id ECD894000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:27:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHfcSUTz;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785223663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jftrX6lDinngHjdgigXRLobwfxyYWK7HW27rdPPfohU=;
	b=XwLjfVjkAh5/yWcX/oenCK6NrUD0YococKJM97XxQ+1YlzQdUSGYL7ISL/U/UgIVv8WSo7
	TYLSPUkN+/KCCOB4HFB9QFYo9OzLqaHpn39qYdXHM9XtL+6Q+E/Ql1ioaepdQGyYNNHkW9
	lAVgV2+z0pKkKZV3ULr6DKLNVBUek9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785223663;
	b=ADkUANCsjZetM0BvQIUoJss+/nyMZWvNCPmkfdAIFq9/mTIGpLQJkFn+E1L6V4jerO55FJ
	MTiGg7fAJ6wgSfbYmrQovpuvOm2t0sokovgtChk3u1fsd2N4U0q1rmkqYu4FhJh1QJmRac
	WHY5VE04TVglkucZZe6xE8Cr8wYi4oo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHfcSUTz;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954df200ddso23010055e9.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785223661; x=1785828461; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jftrX6lDinngHjdgigXRLobwfxyYWK7HW27rdPPfohU=;
        b=dHfcSUTzMdjX4z81XWI3vdkru+P3iAckwv8OLiRnPhF0GxNwS4weeiYlC+5b2ffYsV
         81c1ky+sbdQNr0auCGfzLlUMlbOsoWuzckSkwM5QoSjHfHQsdlsiDliRwz5hrQcKjzDN
         VNlovq27ceZPwVWIkPWIV0m1hQuLERi7i/ta9pmO3WYRKEJXwIA5upyA79bHrVE92bNE
         4JMvnZRujdINhRd1p+gdbyXcEsLQ5Rvt1u2e4/a5Zhk8GHl9vNJWCWeUXZKits9x1t0+
         OJ81tPaq/JV8x0WAnl67QKfVg1RUkEFErm0S/1MfQClDDmephttsmC68Yfh9sU4mnbbe
         Mgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785223661; x=1785828461;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jftrX6lDinngHjdgigXRLobwfxyYWK7HW27rdPPfohU=;
        b=L2rs0gFMag0/5WSAwqYWr5SFzST+coFTkJTEyxn1kq5mNUPYWu5QHCELs/de2JSRD+
         57nezZbDB32rHRnb7dDL6fHmX0Wn79LMZNXoFCuN/oS1Rn/4ux+mNaDauHKSTl+SGgfG
         K09ppeYSgdZshKEpN7yL0K+zYTaX3aUvri8Ht+tUpIzxCizeKCansrckbtOu0nZuq8XY
         eJPlwEuslQ/KpeyPzCQfBePL/9dcLUQmBlluIEnwu+lu5i9fqv674gqE2Myr755q6sRR
         wPUVd0TiXZR+CniyhASYRM2CZ0A3dFZ+h53z8Y3OBZcTswQecxbKjQyyd2pOFWiH8Nj9
         27VQ==
X-Forwarded-Encrypted: i=1; AHgh+RoedxZnYn9req3Ei64645nWw0DS4R2Xhu+fmaUiAGNqnUG05n4nOUdpw3BoLtcxN4kNyUYKHGO9gw==@kvack.org
X-Gm-Message-State: AOJu0YwvB5V+X3bBvaKR0L43QlPvDWpSLBd1JyJjDQ2WtXLEG85NJkUV
	S4RgD901TxxkIX0i8yQEbeMHDRBm1B9Qqv9WL/HlaWgzHUJCOTuk1Gh/6zrD2EM1rns=
X-Gm-Gg: AR+sD11XbQqvzaM4Y6E2hwJcdIYIDA7pyM1C7T4EBCAi740cDnb0kdJBvq1b5YDmomq
	+e3kCI//2FbbgG0DoQI+AfyMPfzKbLb5yu+ohFGZpMa264bFFx3PLIsNUIxnU8N3+Ym0PWgcK1W
	YcQ5niYDr/5bKJCRir17Shjw51CT+y6CnvS4BkFy3mMmziSFcZgL7SJn23YUi0R5j3g6F6KlHbq
	JtSBhBXPwDmE7ihb6k5GGOXH9NSeIi/WdFSHRWaH8vjxOlW8J2cUpf/MCJgx8itiFlJQcGaD3cm
	us/C6MHOxVAPDEqefUndIRvWm2lJxDoODOVXx+9cM+/bc5cLENn0W82H4PGowb6oP4kPM8mPR6w
	kBoBDUgZ1PXIWhrVk5gY7Fcapo/eHDohAk+6YfAP44gO0D7qIWWIFSaj7+jcDW6olWeybcL9laP
	B9+5ePC4wuvw==
X-Received: by 2002:a05:600c:1c27:b0:493:e974:41ac with SMTP id 5b1f17b1804b1-496c643c6f9mr11555145e9.16.1785223661467;
        Tue, 28 Jul 2026 00:27:41 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c4632263sm58920795e9.15.2026.07.28.00.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 00:27:41 -0700 (PDT)
Date: Tue, 28 Jul 2026 09:27:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amhZ645Nhj856JfO@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ame7Q-0eVRrtt34j@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECD894000D
X-Stat-Signature: 5rbpip8gfdmu7my4pqoypz6keds3j5sm
X-Rspam-User: 
X-HE-Tag: 1785223662-209279
X-HE-Meta: U2FsdGVkX1/oY2xqSuhgeeHRHCYsv2Wfsh6A6GzxjJhM3dEl1+tyA7ARb1aHFCo1weXmeoy5GLIpqafRlKOvx7yYMsefzRootqjw6RBJ/wQ9jwj3VpZBampMewxdTY29V2LHssE6tX+TnJJMVvrkzqplZM0LqoO/wsHXl19qYr4sWkzDYCDSwHC/XRcyNxcci2e0/RyX+GxSUXiFAqZ9FA7isNECUKGIyYfa4a5t3TO3TQ35rGEZiuE7HMt0NRsiHrqIH/c8uqw9N/mqgTCxOyeS3RP1OfJcwupWlamepSpA5Xa6RWFw71TllJujjZMSkPWEZbK2uzg6lorqyWo68zCwkDrzC/V2Szca/8WuYSqawXuNCu85Zk/Lo51RTB20ZFseq4t6+MKXbY0UiC3aYytrDW2vM43+yUfS70dNMu9BBB3XAxEH/ebIDrtQpqTPWlZRDn22KxL/nnsXi9EDgsjK6KNjaxRIy70Ci6zRJdyLuqjV3JQgfZB6W2pglSc7jBtHG+834i/7tfLyoHV2ZLd4zqn8DaDenoxMN6fWwm17QuL3MvGzurNq2wU2SrdR9Cps8aMxfIohrb5VowcQZ4TBcnSDZHao5vLzERL9mVYWeENrC33NgnxsPiHRm7PrtPtz2vDroLfAWqv0jJyjrZ9GsIU931/zxzvPVJ8Fqr22EYq/tcG2BLB++ZW6XnzJqsudcVxEMY2298bisZ9GjJN+5ruAKvyyg3GFV6oNX665Dbd2xHV9hT77x8v9hWCV36VzBfCeD5M1Up6e2EF2iMi9oK6Yhx3pRET5soo8/dFEBEkqpv6bgbFOhzIK6ByZQman1L3VVRUFWEdDKK7rD2YOp2OAGAMi+S8jAT8Dc7pFM1BbGopJmy3ZLsYCE6joWyzdZ/VPLbmoESZ/LPhy3kC8rzVk3xLnjZV64VoGwaxrbVogtjtLIIeM32ICi2i+w2898i2WsqUhhn7AZ0m
 Ir8c6cG8
 /zLIIqkEOkwtfnnEwkVTT1DTnbtK0ZYk1BVyNIDL9RSPCHlh43875Y6XX64grx2deY7Pkbo9koCiLHkpBQwKLF33sHggCkoJu+9CsQDmfFuuM0g8mY23/PbuSFVx1WWk1fOhm/539oulCiGuJ7Hvj2JFdYnbnghrMSWUlTaegJr3qt7JBJmix3sXwx6nelYZskjVJG6EK1RZVE5z+BhngREks3Y306eVbzD9i85fdMmZvoaEV4xVT8TrPM7l+t+n306dDeV85gZlpgj7N6peu6gF446qpPuivRa/wUj0VGWyEsXtTvBhL5dtm1RcpsbJWRbFGX1X7jD2jzMiUqy6WJwhc6LMaELEKdFiLw0Hmbscyl6//zDJ/+nMFrecFIynfVEd60jwoxniQ3zwG7u0iIWSED9/KYiOktazbGNVVsdN6K7IDA238MBcXzZtZVMXCvnTo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> 
> [...]
> 
> > > 
> > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > It just makes it lockless. Assumption that a dying task will do so
> > > quickly and with bounded resources has turned wrong on several
> > > occasions.
> > 
> > That's why I kept it as RFC :)
> > 
> > > 
> > > On the other hand I do undestand the contention issues and I can imagine
> > > that the existing solution doesn't really work well for huge thread
> > > groups that all end up lining up on the oom_lock just to learn there is
> > > nothing really killable anymore because they are the oom victim...
> > > 
> > > Would it be just safer to bail out only for oom victim threads. This
> > > would narrow down potential runaways for oom victims which should be
> > > more limited than any killed/exiting task. It would also give the oom
> > > killer/reaper chance to work. WDYT?
> > 
> > I will give the following patch a try with the reproducer I have. I am still
> > improving the reproducer as I am still not able to recreate multi hour slowdown
> > yet. I will report back once I have some results. 
> > 
> 
> I have some results with the reproducer I (AI) wrote.
> 
> Setup: 20k threads, each with its robust_list head on its own page in a
> large anon region pushed into a zswap pool (writeback off, so it's
> unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> every thread faults that page in futex_cleanup() -> do_swap_page() ->
> swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> in a loop so the oom_reaper can't reap the pool -- matching the host,
> where the reaper was blocked and the memcg never fell below the limit.
> 
> I tested on next-20260726 as baseline and then tested your suggestion over it.
> For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> drain the 20k threads in a VM (hours on the host, where each invocation
> was a dump_header over netconsole). With the patch the dying tasks stop
> entering out_of_memory and the storm is gone.
> 
> With the following suggestion, the threads of dying tasks stop entering
> out_of_memory but the exit time doubled as each thread has to decompress the
> page from zswap.
> 
> 	if (tsk_is_oom_victim(current))
> 		goto force;
> 
> I also tested by replacing goto force with goto nomem and the exit time halved
> i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> through the reclaim loops.
> 
> Just for testing purpose I moved this check along with goto nomem just before
> the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> below 1 second. I think what we need is to detect early that the cgroup is
> unreclaimable and the threads of exiting/reaped process should just return with
> enomem.

Do you mean, something like this?
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..66f1eebf8c22 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and fail the charge to expedite their exit. They are
+	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
+	 * further charges.
+	 */
+	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))
+		goto nomem;
+
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 

-- 
Michal Hocko
SUSE Labs

