Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828D1CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775E46B0088; Mon, 12 Oct 2026 13:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D82B6B008A; Mon, 12 Oct 2026 13:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE366B008C; Mon, 12 Oct 2026 13:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9476B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:09:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9CB61210E6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:09:00 +0000 (UTC)
X-FDA: 85314609240.07.C203BD8
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6A11920007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:08:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JPOqGB/x";
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791824938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHX0IQfMOf+Kp7wtTmLf5dvkyc6K5tZk7p3bCuK3qbI=;
	b=3lOBV5bu6Hxs1Ma/ok7e3pNkcEkKDDB8d0cLtVrf3Fw9q/yfJvpibgeY80aCmNA6A+p1GR
	SlueT9HPjGN5BhDRQ4ikIOMj4kk7vSocVAedA+2Hg7wEiBx9g5ylxkQLfxJ0X+UQWKoxDP
	bCg5WyHOi/Q8HVMOX0JPQjwYMbNPZtA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JPOqGB/x";
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791824938;
	b=oKXU/1TFj9wQgTHp8lQGJYTaFWbZCmLIf4S6Gb6QEq44JjUPD2kHaUzDRb15FWHtnFh/hN
	yf01o3f6DQLyV6zh5cIUSayPfEGXhP/FR7RPzmq1tJ1mtVXDzTxdcPzxFL9Fj972I3eoWk
	GZ0gp44CPe/zIu9ZXtfszkx5ktyf96g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jL6a5+5jBxh6aj08ydsTft9UH05ysF5Kx7zP21piuQU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791824937; v=1; x=1792429737;
 b=JPOqGB/xGnPyrn4fZ787j5XNLqdBG/igcKfCNEdBQZ7dozIJp9CCFVe8MSxUfgAEAhBJt2i+
 iKjpSFVwqV05rcx5CcumMKexOF9nXCJNbzXH5w+vYtmFYJoVCvGAUa3MvZJde5fGEINiwbvpkr7
 CPrfbjn6OAS7FkdjTxtL83Qs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0f25970896a4cd0f;
	Mon, 12 Oct 2026 17:08:56 +0000
X-Mizu-Trace-ID: 0f25970896a4cd0f
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 10:08:55 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "T.J. Mercier" <tjmercier@google.com>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
Message-ID: <as0UDixO6rPt8UHX@linux.dev>
References: <20261011223358.2327625-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A11920007
X-Rspam-User: 
X-Stat-Signature: 8sn6kj1bgmbfmgh7599aetgdwjut8rse
X-HE-Tag: 1791824938-493194
X-HE-Meta: U2FsdGVkX18iXgAzkL+UavEFm/ArxrkFaBdSWPpAv3tTHNK0HInDuZ7Z9SqwZzzdYR4YGp3JfOQIpExHKKZVcbwmQ/ajqDx0EWRwK8IzNANcpM5/D5y6Y2bbMo98qH3DhZVUvICf9iijDwucf0A5mW2DERvOvhWGzUEfbic80x4GngX3bg2KJ+V3OdtakduVAMsKAI2XUJF9uTXZd27QbI4jKCkjudVQQO78XuzpQNZTpBwsVMxITvyb1QOhV+aQeFGTv9HoWvQd1zZhNWruOAfqLRIZcZNfKkv8UNgM79p3xRytznb6EYdhE2uIg/yAMpjRdjeFYGdUwnx2HRHTI7mNlfRTU3ScBBI70aIGCvcUXYoGaH8FtQzoF+wF6N1f7ikXMyCjhO9qKrUPn6BXRjUI1fWS9gsVcc0ySN+CqrocB+Txu9uYf16KnczmrlbTiLTqaOZCqqp/KaJC3Bg8c7lwj2ABy9fbP5Mh9hD+9hwHVTXce+GMvc/885vRWda+o6RpdXsPTDcHOgc8OROvuNYE6A9e3kvIxu+27ShSHblgoayX+MoPmxQPvYRU2lB6/A2gCkWg3AsP68lfEdUk4jf1fy97rzEqQUUsJDdYkTCuY9MI4K+UcWSrUfc4VuFS/Z5Wuc5D5laA6syThqaTIXUHr0Ue5jGltMGjT3s6xFTZD9/jfHIOCvJM/TrKgDhJzLremPRbwn3wpOkz0pNcuXU5HQRByr4V/pQ4Cjt3I+etMhr04p0d7RxCEJv3leG61qsB/EQ2cIAGIow2SAc+LESj9+TKy/G9WvcwRneykT/TDcyaysSuBzcSzytVxaYi8nq0gscuwe4Btr1tygsggpummSA69hJzSGfWbHAMMP0KcQVTBKUF0hHvyVTppWPbNa9PsuslDWFUqybbIrOujQ53tbrM3Vkhwfy2cUKQaH5Ziblu+TBBeIgrWuKqDx0Mmxprt6HokGuTXaUgUIw
 0H/mUXIB
 GSHGcExorDw4OUYIEJENKN0M2WSsJEPCChRWoL5htla9rluRjL0SMyP/KRlW1TsePydqvUh7oqPUwKp29UGhlXupEvGFXCtcR/3aoLTTdOSqRa5MOk6R3llYU3YBCdJaLy99hn9+b33Yxwx/ZFsCpIXG74jwWBicn5fsxDekX8y/C4xuJ4RDVETx3eK8hp4IhlFQsdsP+bN9o//X1Z6e4zeG3tQ0txWzs3IuwsXH2y5x6Rui0RV24vGJRzUyufHTcHnKbzwWFK6z9gjeKnHYtSwP7s/KfBIKL1bYEG3RTjjDlJ2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 11, 2026 at 06:33:37PM -0400, Sasha Levin wrote:
> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> jump to cleanup before the inotify fd is created when cg_name() or
> cg_create() fails, and cleanup then closes whatever fd holds:
> 
>   test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> 
> Initialize fd to -1.
> 
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

