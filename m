Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8868EEB578
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448A06B0005; Wed, 31 Dec 2025 20:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420766B008C; Wed, 31 Dec 2025 20:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356BF6B0093; Wed, 31 Dec 2025 20:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2330A6B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:46:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C06BA1AA401
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:46:01 +0000 (UTC)
X-FDA: 84281704122.20.629EA56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C03B140004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:45:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2GuGVamo;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767231960; a=rsa-sha256;
	cv=none;
	b=4JLaDoZOm8MsDYmapJ9IIr4yQpJcKZlqbf/Xy6WhXnT7gn1iKq25wPs6gLv0qRTPT/uTRO
	mbB3bs4m37k+zjysJUhqOQc5HAKe8DnniHxDqj0PYOW9+BU3yhTxD8kxaK2mFajvG1AsE6
	9oCX8sjhxwU1mbWpf6zfePeoG20rVrM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2GuGVamo;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767231960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Pp1LBs8B6KEDCZUc+rmyPiDXAlze34teA088oesF+0=;
	b=PySOXW21rgaOaRM6Siz6G+HlLXCtYmi3MuagPHmX+ciyrIyoDGbvyHGPeKiJTcinNcsE8A
	+aItoQkB5HlV6apfizs2LHcA/fR7H9gjjwhJuS/st4wZGhbRRfliWo07VcOO2MDEncZ4vb
	nqkFMmoFrO7AJqNeF90HKzRvsZ80SWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73E6660008;
	Thu,  1 Jan 2026 01:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE56C113D0;
	Thu,  1 Jan 2026 01:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767231958;
	bh=UNY0vPgkg3Epp4W9bRvRyXpNTLs9vlhObTqtdEhnGJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2GuGVamo5yhh08W9+NMzdq0RZNyFv6hR+k8OqAUJPLYGi+PWQ7SRBtw2n/xtKia/k
	 R7IxzUNnhLAhUnKN52tuutfCohXrmw117ROmB0DuUpOrZ/lHiMYWlMMtJ+qjG0cH0c
	 sG17frrd+zPq1C5jlgJmqArFxF9ddDwhdyCIvnr4=
Date: Wed, 31 Dec 2025 17:45:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 rientjes@google.com, shakeel.butt@linux.dev
Subject: Re: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in
 format string
Message-Id: <20251231174558.6a317049e8d08cc323ceca64@linux-foundation.org>
In-Reply-To: <20251231122117.7683-1-kdipendra88@gmail.com>
References: <20251230123336.ef33f8a55df71f3e3f782532@linux-foundation.org>
	<20251231122117.7683-1-kdipendra88@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C03B140004
X-Rspamd-Server: rspam03
X-Stat-Signature: 8gitw85i13ngaaey1brxd87o5hkmpxoc
X-Rspam-User: 
X-HE-Tag: 1767231959-489738
X-HE-Meta: U2FsdGVkX1+dYfdM46HnFPBgLDKjbuieEkUxAnXGzNLTqGq/mfunf0VG2cnzBoIlmbG7XpxpjMyd6YIE9wUf3B6i+iT63W8rCWam9TyjUEkWsUdN3Aq1/EEHSJeyA70djtpEboQXoDz8hLTkUxhvAUeJ4UFPOiWlr/UZ9UbGI79lnqm92Cv7NDecMPZt5k3iGgSMPj9lEuhLQ++9Q6NRbJVJKcnlb9e3mj/h8BfDYLySxfHFkHd342pThO5ZZGgJ06TDyEVYa09T5Jirzq2RbvTogWRmCJp6eysPa+IeqH9F6mpW/9n+MjbA19+2VQ1pHoyylRhVRwhhJ07R7YKY42pf4EvWaZdnTd5HHKLuqLF0ewIrlIGeJEDLaTjMR0KyAHcvfaS+om27XJhr/V3zY39plGd8RGCAbjgcTzgvgcIqKKbRhK8eeKYpHZG4Ahme5n02dcUfXuWICPj0W+HQ9KwXWkbIKj6hBYQk3okhL/yb1PkKkVA6te9IqKnO1KJJFhJSkVUZES/pTXsi7F9TkZrOCbvGLcHkcKHWWHyL+mVdFD8Pj8hRuOCh7rdnDSoUlboc8jqLED58uqSfNHRYXY8VEHRZygiR/nGwYddVhvyj3hW0kGqJkWSNzr99Fjb3cjercoIKCgkKDQn1SaWrvx6Zp6aK6Qe52+RoIKdHtfLqqyF2L8ZBO9AVzE70gPonnRQ4azGBDH0cXlMN0MVK58yJcbPU/jt18sf1BT5Tn6y8skW/bE4Z4N+CHCbtIE3mef6xPOlel8g+4tjy/tG+VppjSWe4VaIr8FEv7kObziNfcL293WsKDW0BUQmVhgWp8T2sUoRKAjKrqO8Nz0GKIoYF96HmPEt+xfQNyci+kf/fIFq+T/1EyT5dGp2mPCQA0IrcDt65gUXhISYvLGJV6/6LU30Jz2kGkk/uM3eC90tOG+17VyDc0yzsrtZN/eyxxXRPl0QEfJHwoGZASuR
 K4ebWaB3
 6coHAjYlN7avVSfeZ2AV2BCjrjpGCT2gbzydbkm9pZVw1Vp4HLyBa4fkIAfXvZDUQjZ0BdhHMc0C0YWCsv8PEa7CWz3XkeNXYM/p0oYoYtTGllo62U308Y04I2LD3sOMF0ZmRihVvwU/wn002XcJ8laYlrDMVbNU/m26AKo/OoIuDTDZKFZPGp8vuIXzKXO2lMjQ8yS5viK7nhqKUR2U0WtPgwvF54XXIVQcHQjlo+SQNu4Y+WG4M6pyHHN2nb6HGIea/dAfpC8Tx+QfTbH/h53Lnx+36j7w3CV6xp5tuUvnzmyOoURi+nzFSu6liFVv+WbQM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 12:21:17 +0000 Dipendra Khadka <kdipendra88@gmail.com> wrote:

> Since the value is already promoted to int internally, using %d is 
> simpler and avoids the unnecessary cast. The checkpatch warning 
> confirms this:
> 
> ```
> WARNING: Integer promotion: Using 'h' in '%hd' is unnecessary
> #461: FILE: mm/oom_kill.c:461:
> +	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
> +		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
> +			current->signal->oom_score_adj);
> 
> 
> WARNING: Integer promotion: Using 'h' in '%hd' is unnecessary
> #961: FILE: mm/oom_kill.c:961:
> +	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
> +		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
> +		K(get_mm_counter(mm, MM_ANONPAGES)),
> +		K(get_mm_counter(mm, MM_FILEPAGES)),
> +		K(get_mm_counter(mm, MM_SHMEMPAGES)),
> +		from_kuid(&init_user_ns, task_uid(victim)),
> +		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
> ```
> 
> Checkpatch flags the 'h' modifier as unnecessary for this reason, 
> and many other subsystems have moved to using %d for promoted types. 
> Hence, I think this patch aligns with kernel coding practices.

hm, OK, this code is pretty lonely.

hp2:/usr/src/linux-6.19-rc3> grep -r "%hd" . | wc -l
50

Consistency is good.

