Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5110E606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OIDzYVgk
Received: by kanga.kvack.org (Postfix)
	id 577B26B05B5; Tue, 10 Nov 2026 23:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528436B05B6; Tue, 10 Nov 2026 23:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3936B05B7; Tue, 10 Nov 2026 23:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 118786B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:23:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E17E2A70FF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:23:31 +0000 (UTC)
X-FDA: 85421544222.26.81220C7
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2497E20005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:23:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OIDzYVgk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TP2cltB6myhAN3zqq3XC6T8gNcR9V3LAoG3G2EM6wY=;
	b=fjEuOhI4t7xy9Ksn+ciE/E7PKp7nAAAS1TUxMoLYR8Hnlwd3mBSuQW98XVxRLFl4NikzQP
	3jFDIIt9BTNgKj9RK8TtQlXzU73+3QAuzY6CEGcO0Gh6Um2aOd2NLcxf45XcyryV5Kmh6k
	ymYeGnrj0I1UjlVabliOge8qeIwHZ4A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OIDzYVgk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371010;
	b=vFqyifRbfUGLoCIIZ2jD7CL6YuW0mjKRHG0d+ioj2Ko/qXnkin7Q/GT4EUEr0zqL8xE/3K
	mGRKQ2x6YUcOoJINiCit4yR6tvad9A3vuCL19Soh77wSO6nUMmyhiEh+LRvWUAVTjPKB0H
	XXigvlFxwh7T4KDWDCrQ7Fo6i/dTqKI=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37600b0db49so914007eec.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794371009; x=1794975809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8TP2cltB6myhAN3zqq3XC6T8gNcR9V3LAoG3G2EM6wY=;
        b=OIDzYVgkTL5FJOaBnBI87qw1y8gp6gbo4d3kZZIiGubr92/noBxxNbP+EF7f3ANvko
         6ajL+b5NbjMg1iISuZdtAlsR8w3uItHvH864XDRtLTWsRGKUTNntV04h3uRX4vUqviFW
         3Dm96dwtc6tRCPoJbHsWGde9D0cOP+GW7izaRqVc3L97BdJ+NMnzwFEnsUcCS+CgucFx
         N0FENiixefqIoQvkYYqpgV7W8PpYYdNIXt6cjj0T7cT8LI1Wo+Dx0KI7/TcPCkzZS3+E
         yZrXKtvRK1KYL0MajNEwejWEmThkz3pcpkCSeSqg58lFfOh6tF8WEBUsIEY3AMcMpvMy
         GXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371009; x=1794975809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8TP2cltB6myhAN3zqq3XC6T8gNcR9V3LAoG3G2EM6wY=;
        b=cEhN1iEe6mP6yFoH01kj2W9zyX3zLDcXvhFVsrueWp+02AOpzy52P/yS0JLsNDQ9LM
         KIULhNuoP4HGw9AB1BrUTp/ncC8QyaCsjdGl1/ZX7YpwmvHn+gQ6RurlH/ZRg+3nJCoz
         vOPpwwH8Ikt6ZbSZcwPzGRSz3CNDBptE+CNWLKTdwt8LOBN57O1fUn5kFKVv5YWDfewh
         bObfCMycqyGLINGQnnXdiUif4MQnQLKdAV5XLCSX+NFH907BuvnanPj6ltW4d45tccCR
         Obp1IXLfqrgb+9thUVxlKwmFp3pwViYtbN+QyH74lmQ/BhMRorws17oZUEYf+RXfpSgw
         +RlQ==
X-Forwarded-Encrypted: i=1; AL+hErHgveUcW7bhkzOIVzMJMcL2Zl325NiTote6umoCZAj+ZuycaAeRjgjgjvq4og3uinGxdjfIgcHnNA==@kvack.org
X-Gm-Message-State: APuU4Z/yb5i8eNfvmds3Q30suBUGdi0DtkCVAAPUy8Q4t/de4D1Bojgb
	7mSI9/8xUm2PcBt+qe4NsnsGBW4gVh2ndcqpSdgfI3AphAQkuzAILHly
X-Gm-Gg: AYBFou1ZWyJjWXMFSdFB0cVq8DK7Yn1TXtfwQvtM3nL+Wboi0JzpKMQ+4KkfUIWcMCQ
	MVYl9momjVr/ZcoIVoISYKEs8JqrSeHl9WvH9rWaZf/Jv5PmyrCbv8HSQl5ff2CXUpMxr+7KqkU
	SSE0bCKEKTJbJCJXjZ+C0bQyL3svNV7qxUS1+fn5ZF14JxsehPqrmBPewarLjlfNdrzoU2OQHH4
	cXBLldfFc1TJmzPaBx+lnUkkB9hk7DWVhSzQke6SLQuDrRUyo8Jg6uh7VtmF2mCk5icAhfskV7z
	vxEJQbx15sJKHA2T7DqdKuhkf/Nb0CWmzqpkHPg+EGDACRatJAWzCTGaplpbIK157x8SBVXSR9X
	j/cU0KLBlXMCm0qin1vTCv1i/vT/kt++3SH4FkOZusPym4dGMqEvkZtFRHBDOToU0Hu+RS1CS+I
	mf7PhKtLULqE1de0ORLxr+F/hgA2VdrVTVCJYNIh+gtqvbS2KkwezyP4YKYOJsj7bbmXlke4hi6
	nkI4HZ2rLOxQI131FgYiuCmOhierY9piWUa7eP0rLIhyP5T8QV8i6GDbJBW0gwDBhr/sUSbVG7+
	ldO0unDn6n3pNu6un7KdB6yMSyV5went1vKuhd9y/TjcWsMSAYqai/5rl0SzuOBHTHfxDKCx4Gx
	+4LPWCzeSvgQ=
X-Received: by 2002:a05:7022:130d:b0:1b2:3e1d:17ee with SMTP id a92af1059eb24-1b3bef0a955mr1889024c88.9.1794371008492;
        Tue, 10 Nov 2026 20:23:28 -0800 (PST)
Received: from LAPTOP-KD1TH5BD.tail375eb4.ts.net ([47.11.96.168])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b11150sm15985536c88.5.2026.11.10.20.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:23:27 -0800 (PST)
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
To: alireza.haddadi@it.uu.se
Cc: jack@suse.cz,
	willy@infradead.org,
	akpm@linux-foundation.org,
	vishal.moola@gmail.com,
	fujunjie1@qq.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	tracekotae@gmail.com
Subject: Re: [PATCH] mm/filemap: let sequential faults restart mmap readahead
Date: Wed, 11 Nov 2026 04:23:10 +0000
Message-ID: <20261111042310.191979-1-gopalmalaviya53@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
References: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2497E20005
X-Stat-Signature: 4zo8s7iut93y5xtm438dksn1ra4zojkb
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794371010-237346
X-HE-Meta: U2FsdGVkX19I0OmDeyfeaj7o8gtoOiVWIpH+iNwRfC9n2W272wjrJI3pG0TMk1QIeRA5IK8bYDPYZ0mOuD4KWE25Xkn/06mB3qSfDft95iXU56xOx1FpOl8vaoifjh+K9V6JYgSFt1u/Mydiw1LtaUQSUY+CfhrxYN4/jRE2hHyJHlmPwW1NxusvObCmLUiSTVa8PkktB+NuEzIcgX3NlCdGkqa5XrQM/6hUM967AFs+FieuhPQoumq4ddaPR0yQh9EsejRokwc4t+gLdUQfy1bRTqGuY4jIU5WssSDV2vc8kqJKUfoYx5GnOQrAPsnCVBCV6xYJXKk9/3HMVEFn6GdTVDr2ykfTZCXVgIjm1ff7rpFN2EkmstsibjR88JUxHYLQJWdUnijWtF9EqIy6goTJy2HqAW/3QXtPd8AbY71flNCiVU56vvURnumoeQlxJrzPY2ZxMWmDUCjmTBAJMKjpfFP8aDAsMVz9w6MvRRXa7q0KHDXTH1Ia1znpYzsJm9Q4VxhVceYqtI7sgwXoQHRj8nCamEbx5LsFCLROisFHU2PRj4DkLntGAHxy4XYJH/RmiiLeERkQuzx6zARI3RNwVHoJFkdo5Q/k2bmCoKXtlG3dJyhKvJw8+zXFgmv4dXaWfX9Ddf2neBJTwdlRAGL/BQbyNCd5/ir6cvAphxSXMC6Am8beICA8cjprasJi0CX8Unw1veXyrY+16/DWSqDifpBwoXFyd5lJg3VzprwfzVuFH9vPew6cIcdNcb7+rADtPICagwx1m1fCot/rpdTJo79SNFMkqmD1crH8hJFLdVDRHr0LU9TqcoJ6ZTcJRieAl/YiCi3CzY5bmZjCcceYl+0OxgTrIrfnGUz8l3jKHhzmk4IQCS9wWVS2efL5wur+HJoXoAWzDyMZgXYWls9jgWs1fkyOPMMpRpqAoLvOzNyFRBLHK3oPYXSuMb+gAxRrA+gwTR8kc2CLUOv
 mSKRvAp9
 kaRDrKaG4qq2DFm+fywAXbto86IEluDf6n+UJMcn7t03SeljrvHzkdDqlzluNCM3/OcLBzR4/RDcGYAT5FqUsnpl/TohMuo6H73qRvQui+tZsmGLK0x/5HwDngR1npJhdC+gWrT2HM+hwzZLnJHdEbm1ehzogQVW6eiSI3BAdtFspCHSlch/Z7HnrYf7UxcAEQ0ecGM2tcLzUNypLgpc1GqNA300L7vwIR3ENNtwW3k1fcIYJxCHnGFd2WsfkBNU3011irWVPuSgERc/ogJqbmXvXUAHnpNX80aP0m735HVXJNUgpJ7p0SOgRoueRa8+wRqBhBAMzaoCzwLzUIeF8uBcpnTsV5+fWtER6lRrCs8i0yH2rRD0YtaHZ4adEAsbPjH5o0W+NwKogFXywSG3JmAOntJNpoin1ot48J79PrHqYqeDWuxqzyKNvDdozwuQ2ngEUhzg6MZMcxkHP9WtawcnhdCq3JACT2U8bxGw+1sRwcEyiGJNWSxmY3hZNIt882FU0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alireza,

I had sent a different fix for the same regression [1], reported by
Trace in [2]. Jan prefers yours, so I have dropped mine. I ran your
patch, also with the v2 change you describe to Jan, through the tests
I had: a KVM guest (x86_64, 2 vCPUs, 3 GiB), mm-hotfixes-unstable as
of 2026-11-08, ext4 and XFS with 16 KiB blocks on virtio-blk,
read_ahead_kb 128 unless noted.

The reproducer from [2] (2000 single-page faults 1 MiB apart, then a
64 MiB sequential read), major faults in the sequential part:

                       base   as posted   with v2 change
  ext4                16384           2                2
  XFS, 16 KiB blocks   4096        4096                2

Touching 1% of the pages of a cold 20 GiB file, larger than memory, in
random runs of 1, 2 or 4 adjacent pages, MiB read from disk with the
v2 change (first of two runs; the second was within 10%):

                       read_ahead_kb 128     read_ahead_kb 8192
                        base   with v2        base   with v2
  random                 259       234        1057      1070
  stride 2053 pages      271       236         992       992
  random 2-page runs     257       373        1135      2538
  random 4-page runs     240      1146        1200     57748

The 4-page runs at read_ahead_kb 8192, which is what this guest's
virtio-blk disk gets by default, read about 48 times more. As far as I
can tell, each run now has two misses and up to two hits on the new
window, so mmap_miss stays around MMAP_LOTSAMISS, and each time it is
back at the limit the next random miss gets the full 8 MiB
read-around. My patch ran into the same and kept mmap_miss at its cap
on that path; something like that may help here, but you and Jan know
this better.

On the Fixes tag: with the commits of the series built one by one,
commit 0b9c0aeba938 ("mm/filemap: count only the faulting address as
a mmap hit") alone does not show the problem (1 major fault with the
reproducer), and commit 9b0fcac3cfe7 ("mm/filemap: do not count
FAULT_FLAG_TRIED retries as mmap hits") does (16384). [2] is the same
regression, in case you want to add Reported-by and Closes tags for
regzbot.

I am happy to run these again on your v2. The tests were set up with
the help of an AI assistant.

[1] https://lore.kernel.org/all/20261109091444.128521-1-gopalmalaviya53@gmail.com/
[2] https://lore.kernel.org/all/20261105192517.228523-1-tracekotae@gmail.com/

Thanks,
Gopal

