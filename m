Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CB7606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FD2BQvqv
Received: by kanga.kvack.org (Postfix)
	id 161576B05B0; Tue, 17 Nov 2026 20:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138D46B05B7; Tue, 17 Nov 2026 20:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0040E6B05B8; Tue, 17 Nov 2026 20:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCF186B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:52:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5017C4060B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:52:10 +0000 (UTC)
X-FDA: 85446564420.26.CD3A607
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B26F1180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:52:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FD2BQvqv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794966728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zyx2Uxy4RUbuMas+e6y49K5/oKqZCnLjsukdPhSewU=;
	b=0Y+dqiSamy8RY1QhIyIiZo1CZ/mEDK0eDqziB87cC2MUUq5uw2EuPitHoKf61dmUqZooAL
	aC3hiYG6gVFBvGJmB1DoFdMSZGOmcxlg5iD22Mx70p/zUsj6MUcNw7yY+XS9PVaREHNzpo
	8bcC9vGLQuZOEe9OuvQPLkbTIIl5kuc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FD2BQvqv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794966728;
	b=MrYG6DoLrfG03GiYs/lsrPuEfPAibq3FudG4bCsA+bNanazqEYwNy6n1LK2oyf8fVhyLcE
	94juDh7CAiDrbYY62DHmuCiNhAAVZt/M4+QczWcFbrcCuvaZWWnj8FmmOkkvgaD9TpNk76
	CSO5OYxngo/zEdLH4k+OqSAwEJ82JjU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0172E61EDC;
	Wed, 18 Nov 2026 01:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEF31F000C4;
	Wed, 18 Nov 2026 01:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794966727;
	bh=1zyx2Uxy4RUbuMas+e6y49K5/oKqZCnLjsukdPhSewU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD2BQvqvD1ebkI4yVM0HQcKAE7af/nMis0MsTjUR2Kjz0eWrGbp4I8cDd+Um7qeYv
	 VANnsw1ZrawZKhyDGXan3S/1i/RhExLR9Bp7d+8SdkPl84QdsxZ9iGPVpY4CGHkI7x
	 TF8zPVqK+vYtZuSok0CD6KnNs8Je0CCSLZBDXYPnA8MaEP63M4R2GyP2UwqEHKQs4P
	 134VcKgsCX42/UWsYnMXgJcgUxD2I4zc9A6zhs3RApNjYrUlirAyFJWOzRV4dSuThn
	 W2/ls1HO29Z63HN92pqWJfUfbs4Kg3CdKLIJ3UViTwmzABYwTmuTLcE1NqzqUnELFg
	 ARXqlSLEmUlqw==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 1/6] mm/damon/core: introduce sz_ops_filter_passed_last stat
Date: Tue, 17 Nov 2026 17:51:59 -0800
Message-ID: <20261118015200.95836-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-1-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B26F1180006
X-Rspam-User: 
X-Stat-Signature: rihgt1dg4m5am6981zi5ghefkya4n4gp
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794966728-954823
X-HE-Meta: U2FsdGVkX1+D9jaTuDyCZgGZgnF3Kgi9eO9i47dIbk7aX31VJXHuzQspnfRblAnJVdcEOsBhQtM04E05pS65CjuAjG98DBraqbB0CF1XRqOnoSw8AFvjLJ7KINFwWEhDbNBax3BL4+0kF/QHXk3ncsSrAR9Z0ReeZ9UJpmVDSrE0vZk8VdDgWah6ZRUODTjIZLlhAzmw1IBJvVwXZ8NJZOk4bV7LddXteIf7kacF77Mzn7wBlkVpJCVf7rBCsS3wQrWos4ECEuSEClyn4AypPRq5nWIu1IHkkP6Fiq+9uSLVLz35L7O6QiMEjPnDwrSfg1Sv6pWaEooitbGdRB0vH1W1IVPOu2AFpuVDbQy88Y24bR8IBHqJdLSeR/OoAxaxin/SHaOEMJ039jXHXihFnF2qRLwQGTqvTFPyDoi4jDjLuC6oGCZkfuIDr2Dww5P+JxIXVbB9tCqQq1XRw2e82GMs7sA2S1DTksWmkRuUsq17URO15kLlDGKi4tX7e6vd2uKmzMXlQLyiQhWtDaYP6Ll7gC6ExIOPCjKfBQIWLtrbTwFN/njfbTKtJ67osD7HPgfsEipS2r2OrWuCW+hzPmLrdq9nOJFwfIcbiCFVXBljLZxPV3BhVLXRcES6hiZA4VzG6S6Try5UWsnvCC2wJP1af/3I3wrRjPJ7YWgPwi32Fs7IEm1KVsn0A90Mtfx7wnZGrTaKeD4pqEakBCI75agEnmLDGIwEJFJJ7eumK9DxQkFS2ShJJicaCWur2MQliyaqzSm/9MIcykMwoY5XwQ9BPsZAIIyLOCGL38/wnysgwAGa7yehackdzuLb2pX1CG0p6ExySe8wH9S0jfnybv62dNO5KLPgQhzY76QtUWyDMg0xf3+7CK78bUIrrxKmh38VmYFBHQ+ZWu9EcW323zcBvA81VH/EAor+KPdl3btzcue9bPEul4qSTxe1dlkGziUo+AiXoaVc6PRwHTd
 /fYyhxiJ
 oelE4yxMl5p+5sqrCSaZZJ2wtnjqR5r3EVfNET0CTgDbBRIcEBpe4/4Jid/VZiMnumLJFuUeAeXD6QdxFy7bhhsqoXMf23qoew1jgUU52ROQiucIECzCOJyTQB2nvBrYWdpYI+x8zUB3B/9hDOgWr2CM6l1JjxRwCrn6h+nzWP+qE1rhhhtfd5c1/cEvMfEVM4a5fAeGpKOfayBseU5obzM7kVXE6ylVvt3W7Uulu2/epj1Ouze6Bomz+DvpbYa2c7hrKADpXte6n7hq5psh5f1X8KbdHkD8AJTdT9ELkEO4jvHBliCPySOOvp6mHVVRKIJHdKDsbkbsUU4K2y02Uu1z4nqMGcl1xjAiC7jaAQtS50FHgICmXC2EaDp43mWg//E5RUrMetIsDXW2+XbCD+t7sFCNck2DH2TzhJKIHwLko056XWA+qwPxnlhFz63KgKy3g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:15 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> DAMOS stat sz_ops_filter_passed shows the total bytes that passed
> operations layer-handled DAMOS filters, accumulated from the beginning of
> the scheme's execution.  Users who want the amount for only the latest
> apply interval, e.g., the size of a workload's anonymous memory that is
> cold as of now, need to keep the previous values in user space and
> compute the difference with the help of nr_snapshots.  Because
> nr_snapshots is increased once per target per apply interval, the
> computation is complicated and error-prone, especially for contexts
> having multiple targets.
> 
> Introduce a new DAMOS stat, sz_ops_filter_passed_last.  It is
> updated at the end of each apply interval of the scheme with the amount
> of sz_ops_filter_passed increase in the interval.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

