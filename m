Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35FD606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SnaAXovy
Received: by kanga.kvack.org (Postfix)
	id 14D446B05B2; Thu,  5 Nov 2026 04:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF676B05B5; Thu,  5 Nov 2026 04:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D256B05BA; Thu,  5 Nov 2026 04:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9AE76B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0B3E1C42D8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:44:08 +0000 (UTC)
X-FDA: 85400579376.10.B3FD5CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2BE26C0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:44:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SnaAXovy;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cl0o/t0hLxvs36DJVBtguhBYlsrgjBilx1megG1I2r8=;
	b=nkeg/D7SeFK1o34HiJXAO9RydlObFolkZ0+KtV9VJoLVVEqVaqInwbr8lKdhidTfqrNfTl
	P45Asy+woSMDwEfTcS/Memgs5dBMgItsjFSCcPn2PQBaP8mMEdTewyXmIh3g39TF0NKZtc
	Lx52D/IMiaJC9w4VwvIGNrxqweT2ZdY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871847;
	b=7LJnLOX77nOdI8nLCGW6ex2Gc6wiL0J39Sr0YrDszsCApowJbPW7HckGQQkYIY5knyWWJG
	gGTOarfQPjh11xLSLL4atBDLSg35raFb84RNSxeEHq5JutgbaQI77trg+04B9YBHfuV/AZ
	6jTBUTD2EHOQvLxVKKl2w4vdPMP+7VQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SnaAXovy;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52705602C3;
	Thu,  5 Nov 2026 09:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9AC1F000C1;
	Thu,  5 Nov 2026 09:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793871846;
	bh=cl0o/t0hLxvs36DJVBtguhBYlsrgjBilx1megG1I2r8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SnaAXovy1H8UlqhL0W41aHdl7LU+iElNq4bVxi3JEp+eYu+inX6ZifHzwmwFhurW0
	 mZSu2awsd4OVHoDE5JwyccftaHI0wlWtuoWbjCT0UcSDxBR864H2/mTFCG+eh4a0Tx
	 xpm1MgB9bPGbn2Uzw1toqrmxpsnVkt5Yg4gb1fvLVsr5WhS1NQpenRe0Ks1yH0jpcM
	 rFRmv5OhAuAgH4GaAjVz45ZySGFBfTghyLX0PRQTJidSgisBZdIR1/qs8TtcDbd97v
	 hx4NoNODBMpCFp6oCvD/jEUE64r8cvnfZqOl8HysxFO5MbWTttyLkGRdKYZJvFtGCY
	 tnE6uNp+JF+6A==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Qi Xi <xiqi5703@163.com>
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Qiliang Yuan <odys.yuan@gmail.com>, 
 linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, 
 sunnanyong@huawei.com, xiqi2@huawei.com, stable@vger.kernel.org
In-Reply-To: <20261103080557.1632382-1-xiqi5703@163.com>
References: <20261103080557.1632382-1-xiqi5703@163.com>
Subject: Re: [PATCH v2] mm/migrate: fix softlockup in do_pages_stat() with
 huge page arrays
Message-Id: <179387184168.13108.151326476173298230.b4-ty@b4>
Date: Thu, 05 Nov 2026 10:44:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 3mso8xoq4hxqdzhzwkf1fd79o7y8fu9f
X-Rspamd-Queue-Id: 2BE26C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793871847-599822
X-HE-Meta: U2FsdGVkX1/XLrY4LAKmqI1oT7GTbvc2/N0Aed9qXWvWXSqO5tQPYbnxZQCkK0N8n3nW1sZbGO+u9MgHX9gUD9W4zd71b5x2S5y8mMknswlWuzWwkRCdslxa/BZVykKLMSqdnGLvi4YyK4EBjP1c/tKpzaEu3ICPNOArH6yw/w3ZV7JJDI4EslyDc0fPwY0PiACW9j0Fst3Twm2MGq9Kgdrfo1zvgAPFbL3rUgJuj/EDIjbFfnYgln6PPs7IO2KphVLKXEr+MoZoWhmjUAJ5hcpAh7P5D+ayAAGZxecFuFarN79yXmdhPieJecadB4ZMha8Z4SdWp0umHRZ+vWJjslWnoh6NSD8pLRjl5ng79aRGC4BG/IyfNgeIZDQwVnh3bd/PeCrkrt/FHDFmHqsVyixnDUHh0Yo9liGOTVaWjzeXii2wyNTOoEc3lyfWKiXSaUXZjwlaFbLPtFQ4o7CiL2Hr+jDV0JVp+iqqRhXCnNef2+nQVWZaRKUFPwq4Ds595Obr8HjCWZiF9tkxEDn5HVRvuG3+aAd4nAO+oYyreFU0qarvzK+eSLbPJRVyyKM7/5UKhCVHW1dbfaqYavB+z6AtCPNtQVnaoCh4c/Qyn9N6A8RXmOosJI5CgC837VUDQvMxbhZgkmGT6FSlfY4ndose7k4WCpVI23Z0FDHaoiMDa0R1XF3EuOKfL80WpxQjw4DE9/IoI8XRilEjtkqwQ8gkepQgtVB2gLQWsEYWjGFH2Q4m+Sc8/vy4yN/RvzpYz4lvAqp4H2S+2QBUVyxCE1s3etMPCaaKLoWz1/hYSv8xFVVFHcJ69/P12ij2931Uv9F+2Bw+donAvlefyA5GX+yZUbUiDx7qoiQLXLipgpyVbJBkW2Br7L7eThBGZxDVHFx6NvJlQnkuw+Le1XO4yiCsvL5G4/dh/p6FQSbexDXZMEq1D+JxFog1mh2eJeCBhiEpodMqOZbiiVm4+jb
 lOQHt/Zs
 NErtTYImY+a2wwPJLGvRLD9H4T4KxhI+RxhR6e3u4ncbe9YNSDWJ0CHv4nNQKnTvKfi/87xmomEPpdZJVpYCeuMb6Gl0CO6ijZSzfJb0oaFI3fJ65lJChOfywjRmr4lIZ9xWpRjSdvosy8pjs4xILPtTI6CDptiZdbIPHhkos672Ib+BB8j59rhircZwQo7iF208qznD9euTOhDHgtw+7PUeJHyAIdSoicUpBZ/GIvrb+TV44DtHwr1qavG+OyAohY3ioazigKCL1aahWKJSAaC5eOIuMeHxJKZxrOdbD0ozR99B3t91DelbHX/hkcobFoGBaPMUKT49T7LlgHMyhHmptihEfDc9MfZ9u7wX1H8nqgSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 16:05:57 +0800, Qi Xi wrote:
> do_pages_stat() walks the user page array in 16-page chunks but never
> reschedules, so a huge nr_pages can hold a CPU past the watchdog
> threshold on non-preemptible kernels.  Add cond_resched() to the loop so
> long move_pages() node-query calls yield periodically.
> 
> With KASAN and function tracing enabled, a move_pages() node query
> (nodes == NULL) over 10 million page entries (~40GB of mapped memory)
> reproduces the softlockup on a 6.6-based arm64 kernel with
> CONFIG_PREEMPT_NONE=y.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
      https://git.kernel.org/mm/core/c/10f2ae9f

-- 
Cheers,

David


