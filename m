Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFA3606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 05:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JirLoP/Z
Received: by kanga.kvack.org (Postfix)
	id A5E806B0883; Thu, 22 Oct 2026 01:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10426B0884; Thu, 22 Oct 2026 01:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE2E6B0885; Thu, 22 Oct 2026 01:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE876B0883
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:32:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25ACD80703
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:32:47 +0000 (UTC)
X-FDA: 85349142774.03.B5FA940
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7981218000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:32:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JirLoP/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792647165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKiMLBOs1QLQP3rpiUjYHRnraw4ME+Y8+IXUIx1Xl8M=;
	b=v/K7+uC8ThjhKWkGQDxkVC1at50MSQsoK+maAXZxWfLUupxSFo8UnwHeLkEwaKfRFrtwZu
	rbThFscmCbzZ1AOL+uRCI6zNGRqupepW8StA2U2ZjOUBQIZjFjqUjEQRm+CIMZ7Bd0oFSW
	6IGjMnHkkEJTyxBi2rcLEHsW3hAhMa4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JirLoP/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792647165;
	b=Wo0iIWasp2f2leg9gQyhL1prxWQnN7smFvSDVzpsFYPYEzVzHbarJOp8bJA7WWJ4SlTVKM
	yCEr5o6Jre3PScb9Wc5vuWeFrrfcKHYa+J7UkmZhKujzD5P/C/SMCryZ/PJdBxP7qZ9uuF
	c0Xc2D5IfSFgoP/o534vKV8ecMuMoT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E4F743F72;
	Thu, 22 Oct 2026 05:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FDE1F000C1;
	Thu, 22 Oct 2026 05:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792647164;
	bh=CKiMLBOs1QLQP3rpiUjYHRnraw4ME+Y8+IXUIx1Xl8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JirLoP/ZcBiqGI360sZ+JWaawS1Re5u9FnAmETbjVPyO9NL4+VYBhx9DsMweJjHuZ
	 tNilTk8f1fvWvRx4lhj33T0AOseMj05ak8XqbJC0SQ3z9Tfpv4EQuaUfs6Jxwl34+6
	 K1sS/tPS7Y0vhM+Rgs/IllugEjLJL+Z4eqy2BEFmSxXeigMTqrzo1Tr81TD/DwitEW
	 ZIF2+tYJptPxU8n0VHHLbSJXI5qAfmgB5+w7pPuXrB4iSt7pMnvF7A5bcCnbVszTur
	 NMXAiaQmMUUyfo5d5ZmanbxAugb40bFW3HoB4YWjFB43sh2bCRdDqzYkebJ+4M6oAg
	 Q89a2fLNQNsVw==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	sashiko-bot@kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Wed, 21 Oct 2026 22:32:26 -0700
Message-ID: <20261022053227.90608-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022041708.2690-1-ravis.opensrc@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7981218000A
X-Stat-Signature: wwacr1fwfguf34cg9ik6dczhofesxbw6
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792647165-438822
X-HE-Meta: U2FsdGVkX18Elt+vF8nanAhKA1oLgShjGjbt1X7fzudIvaEq1ZRpMXw3jENv9uVUM1GsL6GfnD2apDs4Kil9fWci27Qe5rkKmi0bWPkdZUKlGnFvvQWjD3mFcDN+l+Yr9V53UQk97ctJBYONkopLz1zb6cHYaDI2fHSRoQy1SWXRZ2bc4zuVX5wcXxw2kysxQQTOfmhdemE3Pj9plnwA7c378WNaOZJpJNtQwxPr5DjsKyvig6qnqXLT2eahMKT7aLGoqxBsBwsa83nEQjCW418QWvHBdSe9wpPFz5sSXdLUxjrniqpiLg+xkugXPOa81JDjAeK1PEUvLCdgyAIE7TTrowfAV7CWRDg1Ln13pUYla4lqDynnLslMUNVz8hO/f6jB7Y/wgHqM8KsIcVkLm9i4cFH3hnzRCZrJkE14BlhD4lgdfYhUfTjxY5x0qPVqUAKw/lcwIoHqX1hO+Ii9GQ4G98cyN53Ga4Xod/RB+XkjLLIz0zm3qqTjO56uIfi1/KvAoHhv30dLqsRmpYcebreGf4sDbp/+P6dJzCMjGaRe3QotXeJpWEwr30JfURWtcn/DfUG+371lO8jWWjfrfReI9YNfKs3FqN3DpOK3At3LdoTEX6aUqK3CY8GGNkew5va4kMC2bEmGAbhpDQTNqhR+7Z6Lzc/E1vSqRBfxN9SeXs2hYq0BjxxgOf0zSF+69ECgy1ZXOI9dsYXd2xgQNaPR+mB+8tkURiwcjE/jzQOsoCFDhRoeDYksGGTmGKQnToQqG13cKaUaBB3Qe//j6zNh75/jdqiyK7pTJVFIO1sniOK7dc7rmCME6qGHsbSAUl6SFsx4qKFN5xy3QbTC74IIwiyu9UFbLk4r/P66blNHgETmhl2WOMPU0BoiiEIAotK07uY35Ka0o67Of3dKYFQ6UfZ8VsnVOPu6m/VQkHKP/YSrsTGpCSWP/vhcNQwH/e9HEEXIektCVW+fy48
 iTXcv04k
 YQWhVqadaJebfOksrDQsjS0zHYKviD6epxhdgdiTscZRgCoZfVjTRQqRZi5czf29NRtw2w90LuthxmsCd/3wUNlKePE1UhHATCulHnO5UFcRMnb7iKz4FwxLa7D/KvxUm/fnSYX3ZTMYNsVojrLNuzXqBAvCU7Ajzl0YDj/K6ex51Cbu5uGm8UAdvc8uWARClvjJ1jaPViBzDJwltCbQlIiPAwdUPTFAqhQZt/Ehq8FerPMUb+iy8w4qF1TBRbJUuH6wNZ6IgzchF4JLJa0HRqkpw8M4Pn/BG6d2ReiFvej32jiMDVkmn5Avt/jT6KfHJgr4hIwNpn5xXqOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 21:17:08 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi SJ,
> 
> On Sun, 18 Oct 2026 13:08:07 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Good question.  damon_report_attr() will save the register contents and pid
> > into report, too.  And the probe in kdamond context will decode the instruction
> > and get the memory address.  For physical address, it will also do the page
> > table walk of the process of the pid.
> 
> I measured what the samples carry, to see how far decode would go.
> 
> On AMD, cpu-cycles:p is IBS Op, and its memory-op samples carry a
> hardware data address.  On Intel (Granite Rapids), cycles samples carry
> no data address at all; the PEBS memory events
> (MEM_INST_RETIRED.ALL_LOADS/ALL_STORES) do.
> 
> Share of samples with an address inside the 2 GiB test buffer (random
> loads and stores; perf record -d; one run per event):
> 
>   Xeon 6960P   cycles:p / cycles:pp / :ppp     0 %
>   Xeon 6960P   mem_inst_retired.*:pp          100 %
>   EPYC 9555P   cycles:p, cycles:pp, ibs_op//  ~21 % of all samples
>                                               (the memory-op ones)
> 
> How often the saved AX holds the target address when AX is the base
> register (perf record -d --intr-regs=AX; store to (%rax) vs
> pointer-chase load mov (%rax), %rax):
> 
>   Xeon 6960P   store loop 100 %    pointer-chase loop 0 %
>   EPYC 9555P   store loop   0 %    pointer-chase loop 0 %
> 
> PEBS saves registers just after the instruction retires, so a load that
> overwrites its base register defeats decode.  IBS saves no general
> registers (perf reports the registers at the NMI), so decode is not
> reliable on AMD.  Decode in kdamond must also survive exec, munmap, exit
> and pid reuse.  These are synthetic loops chosen to separate the cases;
> how often real code hits the failing case is not measured.
> 
> For the physical address, taking it at sample time, while the task is
> current, avoids walking a page table that may have changed by the time
> kdamond runs.  IBS supplies it when valid; on Intel the producer can
> call perf_prepare_sample() in the overflow NMI to do the walk.

Thank you for these testing, Ravi.  Unfortunately I'm still learning perf event
and therefore not yet fully understanding these tests.  I will revisit after
gaining more understanding.

> 
> So the suggestion is for the first report type to use the PMU-captured
> address and load/store flag (AMD cpu-cycles:p; on Intel, the PEBS
> memory events, which moves them into milestone 2).  Your call, of
> course.

Meanwhile, I will start with the current plan (capture register contents in NMI
and decode in kdamond) if you don't have strong concern.


Thanks,
SJ

[...]

