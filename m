Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE42E9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 19:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C646B0005; Sun,  5 Apr 2026 15:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD1E6B0088; Sun,  5 Apr 2026 15:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2DD6B0089; Sun,  5 Apr 2026 15:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0107F6B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:41:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A734D1A011A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:41:06 +0000 (UTC)
X-FDA: 84625520532.27.3FD7B4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 25D3120005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:41:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OrLDzWmF;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775418065; a=rsa-sha256;
	cv=none;
	b=E0BUZ2VW+NOqxoLuNCuixuXjcPA0HjMwX+Df9JkBoOvmm8YfHjKvHWEOTB6/9byjCyhd1F
	fFb1qvRBNeaqlcbVfNeaZe9yyd+fVgN8MkW9Z2KswaXVOf5GitVmK2PWGc0Gjng5O4MoUR
	/nEUFAPt603o5W4uA2d76EVIaIscmqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775418065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kKBXPPAQT/5kXqMDDqaGMm8+qqg5tejIdDujz4kOBk=;
	b=vmvMKP+Zr7H1LoD13meCIi1hzQ78cvW+l22Vj5mLz18agzXypFBR8difnung30H7BWCYfe
	X+0YSh/NJNkntfSGq4gVWT3tuW767EQDQDhDlzUx46EDMTqW/O/PPdZpoZZAyb2bR6zbMc
	39PqRlsZsKdPoi2PKZ7Nh7tOyb9eNtQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OrLDzWmF;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AED760103
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002D5C116C6;
	Sun,  5 Apr 2026 19:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775418064;
	bh=DGaCv3yuy1SMBsA/JWL/C7jzP/beOyE7rUQqr+dAcS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrLDzWmFqW41w3HexDrBup9TywlrR389YD3EJvobttbQ1v0kL17sxLfTw9N8VXVEz
	 CNw6FaphRVyf87J5G8uaV3SR3jeGB+sB1A/VFTcOElrL4BZdAUVa1Gr9gpqQTBwW/r
	 s2zv76GQRGJ6Mn09f9dgQHzYlKpkXmUf/s93WdBe1tO2eXATXBRfuqd+8QrcGH3zH5
	 9sbZJGjZbNVy+a6A59I5W/ZFpFvu8RsQmA0e6uhVCdO+h49c3oVb1lWbda+UU2ormN
	 Yz4396S0dCyuEwE+y6ow47mug94l1vsdUr+CtiHTlsROOtfCIBh78xzQoNONnTpD8J
	 tqHR8olvoAUbg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2 7/9] selftets/damon/_damon_sysfs: support failed region quota charge ratio
Date: Sun,  5 Apr 2026 12:40:56 -0700
Message-ID: <20260405194057.110507-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-8-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25D3120005
X-Stat-Signature: s9adwfexxb3eezmxe8dknsdriftjuq53
X-HE-Tag: 1775418064-752953
X-HE-Meta: U2FsdGVkX1/7erGQPZUlqMnbB3Fgc99ZsyxgBZd097JWx6NeVqmKpiIFOLhJ8LVoZEANqnQ28BTz4L+mWHYRTihPGZFmERmX8KEq/2wYXgSSxBMPTztHP+34Phyf9UuwX0lTgsPrpw1I6MteEygpvFSKKXBrLZIyT5yQf7XV6VN1HqGdkHLjSPUA6mthxs0GiubUe6C88hrCrGraai5RNdp4SthBhVKBKRd36ZetDMEk3sSsbkDy7wnhAQlheOOOTVMgII8N8p828jQ9Vhmg/Vd6HH7eju5AHchTVAwJopUzYQaSfOXeimxcsNvPlAUd0fUu7N8gbOTn6oSD5NIMBw1EPaSrwBM/rl8Ir8y8Ag2AwsBKVdF4laj7i7vQKQ2d2AnC5U2dDvgAc8oyxGY5gt1XP1TL2grAxbt/9LkRth79T5r6eAWgs7hDyZSXhyMijvB8QUHlhVp96nUsMUcgClh0FiAW18lirwz5G8fDPCBE0IOh92DHGKiH1M8AVvhoS9fOd19xYnuVAEyBdBaqrGiXRpjQPg/EJKKqpYkojhJmF0RxBVGdYn7B+sLtlOuOgrAs4E6oX+HPd2/sRTadovsblgN/8HOHiQelbWkMvqpqgH/MxoEeuokG4MJzNOBAGQMUXLtlcbsPnwTtpXmmW5pjLCqK/umMXl5pF8Ve+eIfUm/gA9ma1WvzwAIyDV6We0DWwEFVkTPOT7vNMLfQEblLmAHob4bRo5O1PxiA0hS40VjrYqoS3NEkZFournN4kUhNjqPtP6QwaT2Nv4QugsviOiVRUfUBITubyAzZL2JIuyB0ximDLhE5M4iXHEeq3STMvtBAGGzVgjaIjs/QlsQb6gV7OBH4a7Tm7oF7wkIxI2QzwZ71SeKujckNm0GnEtZ5kg5CWehIrtny/VCQPjVfj8+uiG22dr8rxSNzsOXxLLhpAabq47JUKP69/ZvkNLPSidZHy+fYsSs+ay7
 mScjBFJd
 f83JzzrrzkKsV7lK1UIN75L0AhaMKBzhEu5ICsTLZLVIt988t8GC0y9Z8yzLD/8ll3ELjYJWuN6jOH+5rVa6Qtg0Uk7SztFIJp0Y7m5SrDJzSIbf2FIScyv5LlVmck7Y/FS58VUwDQxR/JFQyzmwEVuSeGZZikuiK1FsTmqraj4pZTLnHrHc52+zGpQXD5MaIvmYMK769k3op5HIw40I14ZH9WFEbUU0sOoQGemtT6utDtOoag5GlD/M2NZGww7EeC0GGsSMiWI9YTvqvf+BC3yUw0ia9MPUSUYK1idPuYjJaBTNxkIoleOMPW5NfzKXEY0pdBZGNRP8s7bbzXrB2O82EImqXJ58txX4Nu4IZKoB0uF1lCEIBz2VqxXHA633I9j29ZSZPgxQ98fILMsQ+kxP6lG3GEPDZH4mvY6FJx2/3SBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found a typo and a false positive issue.  I will fix the typo
in the next revision of this patch.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-8-sj@kernel.org
> # start of sashiko.dev inline review
> commit 47cf42ea4e5f609d65881ae5f8f8491bb884a8bf
> Author: SeongJae Park <sj@kernel.org>
> 
> selftets/damon/_damon_sysfs: support failed region quota charge ratio
> 
> This commit extends the _damon_sysfs.py selftests utility to support the
> new DAMOS action failed regions quota charge ratio feature.
> 
> > selftets/damon/_damon_sysfs: support failed region quota charge ratio
> 
> This isn't a bug, but there is a typo (selftets) in the subject line.

Good eye, I will fix it in the next revision.

> 
> > diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
> > index 2b4df655d9fd0..0f13512fa5e6d 100644
> > --- a/tools/testing/selftests/damon/_damon_sysfs.py
> > +++ b/tools/testing/selftests/damon/_damon_sysfs.py
> [ ... ]
> > @@ -132,14 +132,17 @@ class DamosQuota:
> [ ... ]
> >      def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
> > -                 reset_interval_ms=0, weight_sz_permil=0,
> > -                 weight_nr_accesses_permil=0, weight_age_permil=0):
> > +                 reset_interval_ms=0, fail_charge_num=0, fail_charge_denom=0,
> > +                 weight_sz_permil=0, weight_nr_accesses_permil=0,
> > +                 weight_age_permil=0):
> 
> Will inserting fail_charge_num and fail_charge_denom before the weight
> parameters cause issues for any existing code that passes arguments
> positionally?
> 
> Any scripts or in-flight patches instantiating DamosQuota using positional
> arguments for the weight parameters might silently assign those values to
> the new charge ratio variables instead. 
> 
> Could these optional parameters be added to the end of the argument list to
> avoid altering the existing positional signature?

No.  There is no existing code that calls DAmosQuota() with positional
arguments.  Hence no change to this patch is needed.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-8-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260405151232.102690-8-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

