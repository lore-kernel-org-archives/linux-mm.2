Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE202606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P28TG/jf
Received: by kanga.kvack.org (Postfix)
	id D41906B05B5; Sun, 22 Nov 2026 15:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1E16B05B6; Sun, 22 Nov 2026 15:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08D26B05B7; Sun, 22 Nov 2026 15:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967706B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:09:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1566512060E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:09:17 +0000 (UTC)
X-FDA: 85463844354.02.5844C16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7CEED180003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:09:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P28TG/jf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795378155;
	b=xPOhNG06fqt6dpeV1tXs/XgvTFqYhntoMHVymUM1cg7AqDlVtminvIV2AeZgxqKpTrADDQ
	7nW91det32TqDFOldrp0plPQyDRKLn94oX5rLqa4070mDV0zYKR6EqfncvEpDqE1YGMgqs
	azru8WHNbyZS+iVwCmb2pdsyozXJXsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795378155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgAd/VA0V0SFS6QRkanen1M9m5R72JoHXnNt9l1b0f0=;
	b=hFEE5hf5qhQtb5oy82/ZQb/zaFn1FxjmkIQmlSSQG7TrIUF/uzpeaKA5OKOyzscDjpr1QI
	fX+KW+autG7SdtMbZ4Ywul3mVzEayjCswkdliqlFdJlSb99UIAJVaR4T9cO2U4RT/quZuD
	qE8SuTCu7Aw23whd+AU1w8IZGCRlTV8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P28TG/jf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1FAC42D97;
	Sun, 22 Nov 2026 20:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F891F01568;
	Sun, 22 Nov 2026 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795378154;
	bh=qgAd/VA0V0SFS6QRkanen1M9m5R72JoHXnNt9l1b0f0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=P28TG/jfj557Y7MNEKVfg8PB17IIaPG8EaC4Ckjlz91mj3R99wSOaJlPtXNmt8Rjb
	 QUjgXZGIUX5ijXTicGbgnAkNvSfvrerDwEo0ccVCxYsOyP6YALLBbmtkxCFGLPmjFD
	 pDRZvJawql5AxieBhsba3ay0Ylbms82auYGDyB8KgQPP9vPfPuzc8pA4A79Eve+SRh
	 0zxbXKi/4chaRfYvPCYuW9WS+HHgIaqWUeEdEbVQZyi8onJatTBgKPxGqwdrdPGa7+
	 JPlP/KrqNBrHfel0Y0JV06vSuN1GW8oWBKgLQUki/1mbgZHRq+tN9aFty3QtWaqoDB
	 t6Fr3eSQU+EiA==
Content-Type: multipart/mixed; boundary="===============1507986254413833181=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <6d2f2a9724b36a8a1329286865eb8e8502d9e7541d523a21602fd3cb0315fedf@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-12-jarkko@kernel.org>
References: <20261122193539.3334213-12-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:09:10 +0000 (UTC)
X-Stat-Signature: gb9z315md7n7zbif66e7cuqpp11ckz4r
X-Rspam-User:
X-Rspamd-Queue-Id: 7CEED180003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795378155-155327
X-HE-Meta: U2FsdGVkX1+SqgtjbqW1ttJlXSODgU5pqwuagUf/4gGbCrZ3YjYtEAMgch6m9WHrZ+78Fra15aACMuCBIM5GFSs5jj0tbQ/3sc53Rd1Y/jCvB+swXkN0cIcMLLXkNJpytpFVW9WsWxXlUKGklugQwXaLk5uszf+PY3XjhTRTKx1BR4alxfXm09Am9IOlhjo5s5jQXkje/hdFL7DvzLF/Nmsg2zVBhMgiSEkN4yO7LTzNAaAOvEHYDmmVeNpaJCT9/5ugy/lEwmcTX7dHEw/wDC4wi+6aBYgv//jhN6l/MdUPWqUMN4ogX0CO2p5Ag77/PYSiqYH6W2w67sGb18c93t8ORpm4nwFssTTmWY8m2u8fuJAOz6lf9Sn3NfsYyrSKlc6Hks9HLHjycP2SMp3x0QFE8SLrb5bMSOntPVKqmTClxB6A42IqQqtgGMcCmU+d03Uqi4wX48ymoGz6vDBskzzy2HuUFxPlmCw7wRM4ehctQhcQ4xVnOBaIsJQa91V1ocVNwV7QhyDQhB9dnBF7+moodKE0nbkQIaS9M1ZghJPVgB76w8TgiDwN0JMeiXUoBADc+xZBoodDIwwpvAEK6uJ8I068AwstHQoXaCK88WNKt49sGslSpRGlNCYhjCrqQqBCtdIkmR4nxFBY62iyYnfAL6h77jykav7IRV4QTca96sNSPmYjpsAHJrFJnlAj5e7HShkePhBSO/zsUmPhs88xFCoUNTdFBWfAPUb7PuTAWPywXaHLPft6y8UqINNxre4LYhUqoPaz9xtacu7gsYB19vl+dG2zSdi3p6aN443aW0ZZGOZmONw5BLRPE5PcjmPLlwwo+NZWbRlFkC/+4BOaZB4v6FBW33zEZxaKrjjgHYyo0eaQVkJ8g0mjThPsT0gXGuZTVTxLTUwCdFVt18jI8KJ4LTWl0O8E07BfQhRiR6QJMlpVypP9YjbEtuRgIK9EpUOcoy8TyTha58F
 IArgjEaH
 ptnnC+cq9Eb7KtV5upfiStZlkC5TTpHEgDSfMZIPKxsUOxWKOni4MPaNDOffLEVyToZiUXguT/3QOh6WWJGm3VI/dlgNOtJD6+PcvBw1fM+JBze30QFT33YEzku2WXNjks8VeCARC/s8NudZfY81lmytBfjX+6Wojwy1z1j9opNq29Q6BrGb2O/aIUzctd++Uts0PEg+9rJF4Ecf/t/c+/CSn2yXjFUchqdU6VjbiJ6f1LUVKUTvqXh0D9vFnLAhkPqIbYuoTInXZqIeu43Pwe3hhpAkWtJAYcXQ//p8yBEHGGDtSoucT3Bx8/irklJ/Q07btyiyk8EDpWh+WSdjZEowD0PBUrSzk1lyF1aU82/YPLsOcH6znu+JvfWJwL9If82PPIdQgUI2ozve7i5VWkXrQdx5IGGqf0A1sAWbQ926+zhE+1qCHN8ely0Ih0IxL8knePLiKiCOjHYfjZjHXsKezglNv4AhY22m+Xxp90Hs+rYYTjY+1oqbPQjU8Kuu3YyIYyQMV7FzKfojiJikesvatNXq5S5pFnFIQgZVd0Ij67l//+lEdDYBilpOFktEQRh2YNMh/4yyLDKFBpzuoMSkYwqf0nxjVtWWX/medlk7fzpgoKGhfYv3q7o+qIGcP7GF/kYHACHRYRV5IyIk6Nmk0uktUHohJXJXOeMaimQXsLWPGSJiGFBf0UxTlJWREzVC1j8G92dNCNS3VNOimXh+hCO2u3MqLwnVD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============1507986254413833181==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Track init lifecycle via copy_process() and pid_namespace

TL;DR: Nits only: userland_copy() has an unused tsk argument, and the
rcu_read_lock()/unlock() pair around task_uid() in userland_exit() may be
redundant.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +void userland_copy(struct task_struct *tsk, struct pid *pid, struct userland *c)
> +{
> +	if (likely(!c || !is_child_reaper(pid)))
> +		return;
> +

This isn't a bug, but is the tsk argument of userland_copy() needed?  It
is not referenced in the body, which uses only pid and c.  Could the
prototype take just the pid and the userland?

[ ... ]

> +void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
> +{
[ ... ]
> +	leader = tsk->group_leader;
> +	rcu_read_lock();
> +	uid = task_uid(leader);
> +	rcu_read_unlock();

This isn't a bug, but since task_uid() already takes rcu_read_lock()
itself, could the surrounding rcu_read_lock()/rcu_read_unlock() pair be
dropped?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============1507986254413833181==--

