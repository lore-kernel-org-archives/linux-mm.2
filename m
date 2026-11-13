Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D412607585D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jgCYG3RQ
Received: by kanga.kvack.org (Postfix)
	id 5470F6B05B6; Fri, 13 Nov 2026 12:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F78E6B05C1; Fri, 13 Nov 2026 12:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1886B05C2; Fri, 13 Nov 2026 12:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07E8C6B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:23:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84A4A1C2F9E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:23:30 +0000 (UTC)
X-FDA: 85430767380.30.D61F217
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6B2931A0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:23:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jgCYG3RQ;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu5QMzc3QXUklBl5GRmDPmTAJYce2ooMnlaR9b715Do=;
	b=lETy+8m2HhvfH7/BFo+a/r+KLpBh6WVrUhd6eBfqZAy7ghMvTU7bvJqNmh03J25Xri01xb
	JvpXiI09keCpdFctdJTClWOZN9+MXMVimCfyase8bUpUJfS3zKnmTAhnWeFZQa9qqxMbTj
	giU7FpuhuKuXMhhLl9/oM/dDgw/s7Fs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590606;
	b=X8cD6rjSVCX9L66W3RQqOzZ9SaT88MwPzAZl2VEKjti8dOkuvVhnHC5Ia0B6djg1fcCQSO
	sMZZL4JJjQtP/Zw/5PXVwqpjbgG8hVAu5+4+2nBz58AzSpDNX6Qlz/P018oA9dGwOVCZG5
	n5aqdtqTXfJaA12NsrcliACrMCpg1T8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jgCYG3RQ;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so710604a91.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794590605; x=1795195405; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yu5QMzc3QXUklBl5GRmDPmTAJYce2ooMnlaR9b715Do=;
        b=jgCYG3RQvJnm3v+3je6s7WRbm/VrREQs9nzsakv6Q437bllARZqEHE4N+JpV59ENpL
         vNTo1Q4M5RvIq/epW2clQo8xIwZLZ8JvWCwA/AQ31C6knNOHo3sPEd7XsSdNjwijlq1m
         GTZgacxW24GE96Eugxor4QoIx5/g137xDyARA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590605; x=1795195405;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yu5QMzc3QXUklBl5GRmDPmTAJYce2ooMnlaR9b715Do=;
        b=1M627gx94w3LQYMt0dWr1vQ7XbGeGtdhGz/QVNRcFuTxnD3gVm2sgixLnvMf4bwTXQ
         sjh2I72JzRb68dBHXo5FQBmfSIxeu14oq4wznZOtG/2l8Ood+XHkh+3b8B/T+EzCoZrU
         vSRCF5hUBum3joPJ6zwHu8VlZ6uoB/GNbx1rcGnT47467d8hi3r8ZSM31E3z8Ki6zRB/
         58M37ym7yBnU5wicX8RiZyAucKVcWU7fu7LW+YpMyGOGZLx8jEWCkpwx6pnBRe6liLZJ
         ETN3yguVU/HISu9CLUua0/BP13zVoYLmoQ9Q6oSSSp3AdI58Qo96KDkUmOZfnwI5bCGt
         Pj4g==
X-Forwarded-Encrypted: i=1; AL+hErFO70T/iO9Y4ZLl343dMghRdSZP3POcO9xTMoWdA2BrILMhgyGcVto8Hc/H0KSCccXcuKV8omLSpA==@kvack.org
X-Gm-Message-State: APuU4Z9RD/uqrVCMBjKd+iid/ZyEv1GJFsWxWp86PRODSe67Obut4gPt
	oCJWl/7zyND20Jj48JDdDslHjLMjO/mcHPi9P9Om/VWupsm4++MEYzgsnSP6VCk9li8=
X-Gm-Gg: AYBFou0+Ie3isvh8HqHNw/QsY+rXgmFm7UCA7hk6Hi/+G8Nd+/oTbFEQThfz45K1qxY
	KSsokFWiX/HXPYgepNngFCxX6IB+IasK6/QsgbC3ULtBfZYABZ4PgzjGMY1bSzgxhGRYA3qj3+J
	Yzgw9el8Ps2kr5Sa9A6HsmEF3Z3c+C7G40xAXCELpVfnH7ys8wbRFxPon0dvEJIzGsmBdodDNzg
	qPFNWE9VVAzZA390yqfe/Yh6pkAgQ2ROQLhbuIbfuIXhSReK5l9t2xPS7BaFODVlAML6MbJnRhx
	j9KEKYh362SnkXFw1dbpl/P5lVoljoKCqtRdYG0IKoh4A6n4f9ShysxhCYc/JUkYWhwIOImzhtB
	fIAunQFsHOEaOw7QMdUKyrObrUHk0F967iQn0ARBxlTl9mBvWVU8X135euz6O89A2Lue+j5nluZ
	b0ItUJtKDCK60yr8grbJufq3yvSsq+rLd+R8yvrh51NiWxD0izGPX5XQVO3wdP7Lq28mspGkMUj
	RQ9fEB0wLwQiQwqb6boxks8IOzumKafvkXvutb+JDkV6vReM0jVJDu4j7MSUXg4JEXBNUzPVJuX
	laqbIyFRWBpJT+vwOhGxQsvD9u8xQtv6g36UzXCQH47BAK0igt7vAwH+tZkh6/QBX5HQzoRdCDZ
	atcL8lv5mXm2E+muuhmeOltMzmUkhTUjRUj8dtDhJDvK+z9WX3KwZLZ636/XluGjQCsHqLwKYxT
	ivDPyi3B/qM3EpNvqHZtdzRJ+Hc8bzsarIWV+1EJo40pKJkxUkp1QHKPZ+7Tw=
X-Received: by 2002:a17:90a:c88b:b0:3ac:a6a5:5757 with SMTP id 98e67ed59e1d1-3b1b0b5beadmr2012590a91.11.1794590605026;
        Fri, 13 Nov 2026 09:23:25 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1ae98151dsm5319144a91.2.2026.11.13.09.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:23:24 -0800 (PST)
Date: Fri, 13 Nov 2026 09:23:19 -0800
From: Chris Down <chris@chrisdown.name>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 4/4] writeback: report a slow writeback wait once per timeout
In-Reply-To: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org> <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113092319.f975912d92c98651@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ho1qfj1975ypywkn8o8efyrsfko9oymn
X-Rspamd-Queue-Id: 6B2931A0006
X-Rspam-User: 
X-HE-Tag: 1794590606-135847
X-HE-Meta: U2FsdGVkX18jyRtNjCyEjqpIMeL8rBFUY8MaAgXqOLEidMAaKhLnrbxK+GQI1VWU2xBBaM21ImA9p3R/1awhCg6Hjpr1Go4dRao6nl6DPnk5kodLDKzV3hpRbsGM2HY5tSR80w0yxQYJ9PPz5PrhtFNyRic2IlMIKCgWeG7XD6LVivE4lvW4A4Ku8QfvDCIgUCYg3pU39k7dx6NbK6XLON0ZYO3OWXPksi2886Na87S6dVHzqc1eJlcCuwTTVBIRe8t4fWdWHMF+hJr0MJEdVe2WEnzJKIS8WuDDEAV2xRoprWQf62pILvZ8ssC9vr394IAV0q0qXqPdrL8kxdl7ud8BzPzCyYffSqs/cDjLXdJ8dhinhzhzNHrCe2w7912Yi0iuGv8x7klEbbEW19HHjm4qXpTkg8aHIGzhYZFphII2g2EZiZ3NpxTwLBCOkD4xJmBrifWE2jNW3yf/ryxHxbWc96nunEUmWAfJ3NPiMwA/xdojZucfBH5AY1ta5BWueU2+fRa6sh/HmCebyWFW164F+pB1VMevpcQSc1NIXmVJsUJWa+tjTHp9Y72dmXUfE50TH6zsaLl+V6mqPzP0RHR4V5AdssCOXd7Tq8VeKMX+pZxc2z95Wb7/gk0o5ZZHET9OGJjtbJ76NovYcJIXlvYDdwgexSlHe6Fdf14usNHw2dREPA7doqBkDysPt0M+eDc6fW5WcVlH+2EysXFTD153D8DS69Mow2J6jGoN3+q5+pM+2AVwOmLkM2+dg3wafcGXL0DCqjZ/E1NVH6bI/fkGrJW3c2aTX0RNpLHEuavaywDaRBSy9qZ4ngJHi2/xkaXGnQATrZArk4XCG4gJsCCa7IVxDFvOVYuotRQ3aHnZrSUoBzLrXzVv9J0yfD+yxotyZLqZ7aWNHUrVQ2qOBEbuXhHxmYORA6bAA6xHuvt6jOvfqfqM9tJ8PazF2OIN0KsaOa9QrH5xO7+Wq3R
 5HgXhgsU
 tXfZYUd7lse3Ko2JkC/+k/fjZiQuWll2rxsEzHCxUWsp73FfyPzPVb0N2yKJc113j4SYypLRjfBesO5l+1aOe/unGgVmhYxzlL1Dafjhfuab0EzvvFYngvU5WGWJxOtRtMfPWarj7PnmiTWRNUNTiFpePvnDzm5q4xUWcZHI7jpLo16TuFwVXC9eiGsAuwBePfAvYMFqLCt2QpYAJCwA9b9bEwSVMk+URZ0zNPPTTkNUYkZR5FVgMkYiMhEDnQa9wSBjlIJrJAuNfMeK1d78fIMpDiTGreGFbuWO2JeCEvDJTn2rPWlK5jbXLX+JyayzPrqr/vcmcVKCig8HnYZB2X4m1cq9ob5+JLFsA29+SnG1uY01vFnf4055oaHHNgRppwc8M7kFpCTofRtiByL9IyXWwCHVUfqATJlLTEXA9bJf6m9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Breno,

Breno Leitao writes:
>The flusher only checks for progress between inodes, so the wakeups now
>land on the first inode boundary past the timeout, a bit more than a
>timeout apart. The hung task detector scans once per timeout, so it can
>catch the waiter between two wakeups.

This does happen in practice. With your null_blk setup and the timeout at
5 seconds, the waiter gets woken every 5.0 to 6.1 seconds. khungtaskd
reported sync as "blocked for more than 5 seconds" in one of five 40
second syncs with the default check interval, and twice in a single sync
with hung_task_check_interval_secs=1. With hung_task_panic set, that
panics a machine whose writeback is making progress. Stopping these
warnings is what 1888635532fb ("writeback: Wake up waiting tasks when
finishing the writeback of a chunk.") was for, so as Jan said, the wakeups
have to stay below the timeout.

>-	done->progress_stamp = jiffies;
>-	if (left && timeout && (waited_secs > timeout))
>+	if (left && timeout &&
>+	    time_after(jiffies, done->progress_stamp + timeout * HZ))

But this check can't stay as it is once that's done. progress_stamp is
reset on every wakeup, so if the flusher wakes the waiter every half
timeout, this is only true when a single inode holds up the flusher for
more than the other half. With the threshold in writeback_sb_inodes() put
back to timeout / 2 and the rest of this patch kept, the same test prints
no "has been waiting" reports at all, only the "waited N seconds" line
from patch 3. Going by the code, three quarters of the timeout would
mostly have the same problem.

The report_stamp you had in v1 keeps the reports apart without touching
the wakeups, so maybe go back to that and leave writeback_sb_inodes()
alone? That also gets rid of the duplicate from wait_event() checking
twice. With v1's report_stamp on top of patches 1-3, I get one report per
timeout and no hung task warnings.

Thanks!

Chris

