Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E2DC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9207E6B00A9; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3F56B00AD; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFAD6B00AB; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42A6F6B00AA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:02:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C6681C013B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:02 +0000 (UTC)
X-FDA: 85212682884.02.4AAAB2B
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEB30180016
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gmI0gV0v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8ygL8wnvNbDDwp9bVOKE2bOGvJgUY1pPihHcbtZmW0=;
	b=Fb2qkBQXf+tSEseU1j97GbAd9GcIxyWIG/i4iXPnwgdC06/vrn8HgI7ogjO2q/S/Qh567A
	dhnnko79PgMpwGNGTD6c9wR7L89agCQ279REnsn87vJ6LqMhdjDsZeFOTEJ3RN4p2Fl0N4
	4y/T01vUFTBXAAvGeDqS9oFFGzRPwyk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398120;
	b=ivkxXL5R9qmhWdTEj9GX2KthtfBRiZXeH21CPv3xSmejL53fGy/ASKg+aVnuwtKYic613h
	23z3yY6x4WlcVj9JRkqTAZ/VOrhjouKpSI1v3o/0H3BKnt91w61TjvqBwmUzQsSfIBywng
	wLx9VeoiJ5B7SBE7+D+UZY72RPLmAIw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gmI0gV0v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so3365900a91.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789398119; x=1790002919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T8ygL8wnvNbDDwp9bVOKE2bOGvJgUY1pPihHcbtZmW0=;
        b=gmI0gV0voyJwcn701d+amg98YRRlJgNucPx10VeXVLR+SqwY4JyaxA2/KpkBjhFJeY
         tZ7KAZ6ahT1/uMSIRHGkJAMYdE0mDB3YSxKJLPTmyabQxGloBEerYhjvpxa9DZU80wLY
         Ga2/xoV+LMTY/Q/Bsy0ygAvjFa/zmoC093q7bapyZuq26ABgwOecoudxXxClxBrcLLg4
         OPpuTYFlS9ZaljmPOwqbi/bLrPbR5mj3hDUsmshLQUA7+snb/wz4UgGWh5/A6kaWpIgS
         kL+qtEtiltUF1xZ3ZaeUkPLaLiTUpzeTp6P4LhBBoL+BfuQLIy0LyDGNDSTle6W6FbPP
         x+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789398119; x=1790002919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T8ygL8wnvNbDDwp9bVOKE2bOGvJgUY1pPihHcbtZmW0=;
        b=SZEBTyuQFH84AT3r+4OM+fhZvYW+rm0Haifc7+jxKzZrRyKioHn9lR/rvEBzd1uZGe
         qUbQkhXGhaNs6mTuxzVcUDd9bUCPLfEm5RvYO6GSBUPLJxLLHTQl0lrsErtjyUge4Ttl
         1nVk5m8BuYgYOOJWF3JIELoq1oFKV6BCbWAeEmgjxKMkU66au6k93QheNWHy48gKA4u7
         KNjKq/ze5/HZcNm3yBCpoqd5nOPTlkCza5VlTi4OYyfoknX/fE6qn8s08dd73bpMgDts
         rSqlJSNUSEB0r9TQIzCA5F1Gb0uviSoWmu32A0phrIQJTzHDO1gbYMp5sfEN11fh4qDl
         GtRw==
X-Forwarded-Encrypted: i=1; AKwUvBwW63NjERMsLPrFbc6Xg72OkVpBWKnPZuEJ9262S+Ct5VfeA3MetVvuELhuUnFVrqWw3WVzmeH+dw==@kvack.org
X-Gm-Message-State: AFuF++ky2rVqCVBUnklWHK54b9sCUU9xcJdOZn8K1YU6cRJtf63Y0mNq
	nHDGkJbL48lFj1v5tn+RfHAqhS5e1sFVoNvq9B92uVqOnMrVAPoDclsj
X-Gm-Gg: AYBFou3Rhf/hPz4vBWfS+BviYuWE0Ta4RBQ0O0iFnaaxPn51m6r/9uz4qCDpjpMZ4CZ
	tWStV8+1Ck8x225XhgUJdlr3ui2r5Z6F9WBFyfavP3n+0ss5vvnktu0UfM8z+RpAZuZLOuDXUJ/
	958Ag/hmA8p0e97g+AAbVzqUcd7EX99ZD1cNYwmRxZxm5+JuzZDf4JAQ0j7nBgnNC+SZzDb3Zw5
	tIdr1+sSvGXr/5YUzVeB3TRgk9ULe3X4N0YYKnTmdF0bc0CA7DaWQHuRBdiXTSyAUoSNxmY+nGe
	h7CDN8PWHLSXA3DNLne5KX46VE0af2UHSpc+///8nA4sfp/rqX8c5+zfVCzvTvCxjB3wIh83PGd
	iv7P+ePJ/mdzuEr/h7btUh7mMGEPfkjhqDNfkUF2BH0uX/bYdAen6zDieIUPokvepFDyvcT+144
	OWBntep9i2c5wYcPKgAojojt3NQgGjjY7aXqfbc6hNLsWjI4WqpKoa2eHKyexzVA6gPYnFM4M=
X-Received: by 2002:a17:90a:6d90:b0:39d:ecb6:8d40 with SMTP id 98e67ed59e1d1-39decb68d5amr4014856a91.4.1789398118233;
        Mon, 14 Sep 2026 08:01:58 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfd8c84sm50939035ad.62.2026.09.14.08.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 08:01:57 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 4/9] mm/damon/core: use damos_quota_is_set() in damos_adjust_quota()
Date: Mon, 14 Sep 2026 23:01:48 +0800
Message-ID: <20260914150150.1507525-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912200814.145612-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AEB30180016
X-Stat-Signature: 3wzx6wkuar1tcathd7wskh3ndc5qnwpe
X-HE-Tag: 1789398120-370660
X-HE-Meta: U2FsdGVkX1+BGs4kGLSsPtTYBa4JEmdJhX/MGUAoEk9OuMlZJSP+u6qxekun35pMa479/Awzoez8lyVzv+IZe1due7X14FCoU9IcavQzxa9CCBdsTPkC6cv3oruWaJC3u0UmkO2KYtwZvT7+zaTBKG7f7SIvOzEnl7KJZfSvjleP/bhDiip/YbC5reI0wDBAVrsboyke5W5upN7kocOQkDrTlWkFtVXJDxfMes2JwZDPRVP6ob780NY3AM6LTk62cQp02wTEJnxNOfyYiO41sbvJ3fw/RKLvqay/hK9Nq2FwqpntSFcys87IZYbqA7jxRwGYBeMUI1ljmyLJJm5FwrIrEY17zg+FD4amTSKzrhPFhTICjpneORKrEWMS2OVbEk5L02hErXzTfGwRd//n796Y65YCREPBb+MICGCVK0BgQsavPdQmDy42anOQaennXVSDJAuxVNTopN8GxIE63xkhS+wOvfiV/0zzXheNAnDhinWruYmxsIvJ7cGajWTtIbyjelsm09epHSaCNNisHqMtHl00Vj2xbvYJiamW+K6WUYE+QZBIK1dCyzUS2YAWXX4l+ir14nsf+1cYAsqvlt03tz9MuU5KKqXc6yk618IKXG7Ie8t/H7O/hMmLZeh1P3YZcJRRv1D7J9GeWFPBSIghKVQ+bkwLh25qEjFpvjRcL5e/7lfL76DK0tjteUxyGu12QLPKByvw9A3BtoYAD0fQu2Yk5oV2Qn1BEM7HbamF7fcDaHyNKY/Ol3Zd/daUH8b3JqPLyIhG58c0gv1ATCYNt6EjbZXBOwDBSW0BoE48Ntb4tWZeoRYecMsfE6W8DiQsmH1q4E9k2Ag162N5BVlcgnpMgQsB4n2nzC2Yzm4BcwERF37Z7rCGOwJx0zrWBG7Yg1QjZWAKH8KcBrsWwsDGTZJlj9oSBdMCw0ZHCI+cNO7Pa0xdD0YS+Yo8WvzhOerUBAHZp1vzCek3ZZo
 fCnoxv7S
 cOJl54AwQTqBjRio94X8gB5woNBD9hS7xeu/U8gZhTVu4Q8k1gzg2FkSY/OrNY6gyzwpl+mE5BysmPPiyycHe4EmZ0GxMikN7ihAgbHfHL8+H2skFNCO5vziB2a3SCZ2u5miPKNCplEf0HmNadwwnkXSIcOhT6cDlW9YOCu93UOuK3sLonizkJA1LtpU9ZwjKEgIqA4CWUQ+VWe62J9cTS25y5tmc0pPnEQaQLP9u/CuMRc2MQOT074r8/7ToyaJgK6pFzukF5Q8F7dB3Hm2js/TpyeBg+rK9WsztJhPl0O8zEC/GHEpdr1Y+D/8oqqYZAKFebClNcqB2IcQMpGs/wRmNGkpXNExI3/VI1IhbpHJMFhkSxznXN2HP7x9tpLamtq3h7w00BoTSWt4k10gWfW0c8AuK6H8SNTEkLBvIRwzd43Vv15n0M9jNRAo4zhVcve+sdUxTk4mVCi1z9KS/eJ2Iowcj/e4RJ/vp6ma+eGQWQXYQHKL+jwCJ+vrC+4bsQbKmOEbSQ4FxvbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 13:08:05 -0700 SJ Park <sj@kernel.org> wrote:

> damos_adjust_quota() is manually checking if the user set the DAMOS
> quota.  There is a dedicated helper, damos_quota_is_set(), for the
> purpose.  Use the helper.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index cf10f6d725c19..dd27068cb83e3 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3344,7 +3344,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	unsigned long cumulated_sz, cached_esz;
>  	unsigned int score, max_score = 0;
>  
> -	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
> +	if (!damos_quota_is_set(quota))

Hi SJ,
This is more than a cleanup, because damos_quota_is_set() also checks
quota->esz, which the original condition did not.

The path that makes this matter: damos_commit_quota() copies ms and sz
from sysfs but not esz.  So if a scheme runs with a non-zero ms, then
the user sets ms=0 and commits, the running scheme gets ms=0 while esz
keeps its old value.

The old check would then return early, leaving esz stale.  That stale
esz is visible to damos_valid_target() and damos_quota_is_full(),
which also use damos_quota_is_set().

With the helper, damos_adjust_quota() proceeds into
damos_set_effective_quota(), where the first branch resets esz from sz
when ms and goals are unset.

The code change is correct, but worth noting the behavioral change in
the commit message.

Thanks,
Kunwu

>  		return;
>  
>  	/* First charge window */
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

