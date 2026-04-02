Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B867C111224A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55D56B0088; Wed,  1 Apr 2026 20:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06AC6B0089; Wed,  1 Apr 2026 20:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BF36B008A; Wed,  1 Apr 2026 20:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE316B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:53:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0872F140301
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:53:22 +0000 (UTC)
X-FDA: 84611792244.03.89E3654
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FC1418000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:53:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qeS6QIq8;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775091200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CufYZOSE8Q4XRJ1M5HqlvxY8OAhgIiHC10Ezh+EVjRA=;
	b=ZiDjgl+PXNjUmLBlASr/A6L0LCK4ybN/sXBK690jH8E9sUb77uSVhqW3/J5PZYCVAJX6Ba
	nxI+JgnL5ZiZSwyV/8I44SHPo7LA9a60oCliav2RlPCcX+z1IOMWwYVk1m/8zS9ZY5XdCz
	8Erkae98Gr7UJHKUGDTSwtAjdf4BwYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775091200; a=rsa-sha256;
	cv=none;
	b=4Ah3PbALjBJdN0vVpYlAbs/WADfPW6ihjzX7Xez4b987GX45Z/jSnQqeF80TK7PgibcdxB
	lC3tqgoQOI7XkeVhpsmE1vsDudizAurwCR/ekVHIbT944U8B4HXXr28BPRLckRa8JdLLhy
	iBG7ZtGdIiytPCxsc2I5do/E4agqaxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qeS6QIq8;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2787600CB;
	Thu,  2 Apr 2026 00:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7599DC4CEF7;
	Thu,  2 Apr 2026 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775091199;
	bh=Heqgb7NWHkMWzwMf+PoAhuEbIF6130mJkPVYQSEzLG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeS6QIq89XY62gAlnLBVLWW43xMqPQFvvVVRp9Guc4N9IRDQ60qL97taunEnhi+dT
	 cDUhUioyXSOSV2hfgd1TVIXoznaPXo4MwlVgKd+vykQp5KAl0dvENZAOH69vM/cdp6
	 FOt+fMIUG70uN1E70ScpvUc+cwUmjRE3LGLduAwdScgwAYu95hKlhORuVxzLzd/gax
	 +cAXpeQPcHJ5Fl7Lbx/jRS8Fc/bqd8vUDbC5iHgZSdFDN+WC1egbD5rt4teTJAQH5W
	 EXfqWEYiGmehwzJcGzCuIAC1Kar30Y9aoe4mf0airE7bSLnZ6ShLJCyb/Wu2fVx2M/
	 xr3mq3odzqKRA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org
Subject: Re: mm.git review status at 7.0-rc6
Date: Wed,  1 Apr 2026 17:53:17 -0700
Message-ID: <20260402005318.64637-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331213956.2f3925ff0dd12eabf55b7c37@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8FC1418000D
X-Stat-Signature: kjjksaizztgzx3adfxdzkm6b5qht3bor
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775091200-94723
X-HE-Meta: U2FsdGVkX1/gdOFtccYic26IUEuvFFZnpD2LS3aSc9FDy5QKp6waCDXXKDK57Kt4jTkgKhwJrYOd7CKXm9uVkUbvnRtPZ6VXRYmqeMVqCPmRvI8YQYVu8G8NCuAHdzhfvF7EWhaOd+jJ1fUNFu9gtCk19P6bzzc2qdGREvIm6AcIZ2RYPvVKNo0lhosOnNc5641BD8+44Qr+vFhxX4Qgz3p1xvASl44wg4UU9MNk23U12hzun0haeUKvspPaNR003YkoQrxlRYDgTxCUJvPlRBJlRv3DJPlX99XeijGeux+AAyveGynfO24dl7ivHBLgMYO3uzYvthQ+lAF2HTVBcx8qbY8cI/2G5LZZUR9NjAkKHiD68AwWqEveVlF9ytyTZoaT+tjY0PTvPSmjNUZtb5ZUEApiLz5TtOYFUzeJVIdsiPK5VjhT9uwL6bsTnvb7Q/wfoXxMLaAUAPtjvB2/P9J5q/9sHo5Dv5KqnscyyI3ZSSVxb/b+yONgx5HqloC7XWJdjjuDCw0d5Nq5dkjaE9WBC/Isxtm6Npsbc4mcl9eG5jkb5KykaMfYb7VBkAshx1tgWmEksX8AkbY16ovjPwbN+lpgw2rge3xBFYm/LRwRqOHoxFdFeFl1Ds4WP+r1WTsQawH2yu/gUWt/lc2Yr/A4hTFy2Wop8B9DCb++HeGBM0gHDM7ye0zlDpJnhaLOWUgCN7yTVK2qW5zHwp+uATONFMPNas1N0LxPoODVuvOM8DJRiSwiXqZjbNcVlFNVaS9f3aRk3l2ec8BGYRFiwFw9cHwL7XnBIsol1zCZrJMB64HTFUw7zcop70/Tle6j1nvOn/YCaAqjaMKMslwyu77RKX126FrR6CnSac44V8DXoNPkkJtD0EkeJMSQeAoCziLQt2egEAWr5WuERxRL76VJTvrjYCADxJiLaTA17enINRXNPjSXnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 21:39:56 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

[...]
> People, please let's not see an enormous flood of patches the day after
> -rc1 is released?  If you have new non-critical patches then it's best
> to send them out when they're ready rather than buffering them up. 
> They won't be applied to mm.git and they may not get 100% attention but
> it's better this way - spread things out, at least give others a view
> of what's coming up.

Makes sense.  I promised to not drop RFC for non-hotfixes til next -rc1 [1],
and was having a similar concern.  So I will withdraw that and go back to the
normal mode.

[1] https://lore.kernel.org/20260322003459.86313-1-sj@kernel.org


Thanks,
SJ

[...]

