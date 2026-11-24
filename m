Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E9E606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 20:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=np1dmelL
Received: by kanga.kvack.org (Postfix)
	id 38DD46B0854; Tue, 24 Nov 2026 15:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F716B0855; Tue, 24 Nov 2026 15:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255DB6B0856; Tue, 24 Nov 2026 15:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02BC16B0854
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:17:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EC0D160BCD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:17:43 +0000 (UTC)
X-FDA: 85471123206.30.66928AD
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C62140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:17:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=np1dmelL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 34_AFawcKCDwnpYrkYjemmejc.amkjglsv-kkitYai.mpe@flex--pratmal.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=34_AFawcKCDwnpYrkYjemmejc.amkjglsv-kkitYai.mpe@flex--pratmal.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795551461;
	b=QCbkUxhPPsFZq4t175CIwc3HUc9D+lR9kIEy7A3l4IYKNo9kvN3Xseqq5oGr9tDOd9U0PF
	blkgkQnImh7bvDbexBSKs2d3nDi2DODsLqeQx444C5hklWA0cyKHqBjyBBfmb5I10yWryx
	JW90WASgHW+Q3hQUPJMzxFEYtsJtoeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795551461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tEIWHNr59KovVpk7gJw0JqnDAdNK2se9vPrBzQVaug=;
	b=vSapgcZrnrZFrjqcyd6hptoOh6178az+E5P4FoRj8+CWYbwFTTA91yeo5si1PXyDzTE2RG
	XuHFIoEdKOrknDh4KskSPGpWmrYfXQs4rIJfCQhPLLb6NJ8kw9EAwvu8Rsz6lgAoixB38z
	ay03src8GvfGfQbcBbzfobtBCdYxzOE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=np1dmelL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 34_AFawcKCDwnpYrkYjemmejc.amkjglsv-kkitYai.mpe@flex--pratmal.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=34_AFawcKCDwnpYrkYjemmejc.amkjglsv-kkitYai.mpe@flex--pratmal.bounces.google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-382af5cfc58so4462877eec.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795551460; x=1796156260; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7tEIWHNr59KovVpk7gJw0JqnDAdNK2se9vPrBzQVaug=;
        b=np1dmelLYxoMxh54mRGhMDOQRPNtTPyUpwyQWPU6aHpJ8LTbP0UtiUsZdI8ct2GuTl
         +AAyFEpu+BeSfDygoJQtzstobtdxhihrD1hqhS/HBxxwRDE9c60JeELHVo+TQnAojbH8
         dIudjDBGtiXCjUwICVEpx+2dWFCIrVAyTwzo+jxIyOzFNzBW0LrWHQurr3QsTK1Ewjl+
         be5V4GdkcKs+HQzV/J7bve0graHnbzw/KOMOpT4+huHeVT9RzUwI6bDTmRDRBpER9L6c
         hqPf5W+Va3scS3GUhnI6TOuKcPEIJhF+uwgFS43gXU6/nlmWfWDSqnHNKF9EQnLMm0ik
         50Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795551460; x=1796156260;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7tEIWHNr59KovVpk7gJw0JqnDAdNK2se9vPrBzQVaug=;
        b=NhpO/5joo8H15/2kvxMuxK7D8bH+k+XUwaqBCUpWi43J2UR7w5k+g9ezrVQQVKk7Ez
         pEuakZOZS/C0Z5oRra07hS15mIxr8g3tXhOHxEi+SJ8uyeGP9sK38v6nVxGy1ahU783X
         UgDIzp4wBKIDjavIUqIdDSE2uKaBT7uHQIY1ssDsZbnu+IzMHvq5QcwRz18vx8wrfPRa
         ciS+MrndoXGgE/+AJwb+VOHgiJzwvMIzuIVs2jRhvC/z+ZSNJFuKNzVYQeG46GuS/bBO
         GVvL+1upwQZqZRPMpjtrOcXIF7l9P+MLFySpLFNduQG0ijn7Cw7BQqBMpuiUOwIsB/cW
         e9Ow==
X-Forwarded-Encrypted: i=1; AL+hErGhFTu9YqAAnxV7Ibn+H/xFzUUBTP5+801ST9GBDcNadSFqpTratUGgSjIeSSfc4wqL/SthOs9HhA==@kvack.org
X-Gm-Message-State: APuU4Z/IG5ofqKHgB0UO08fGamYIBkaZgeI0VuJwiBdyEVrVTJ4KB53l
	IWOTJfPghcN0y29/L9dyuX49KJCElHw4MeAtkZnDeFmhlnifkhr6YZytSPl1L+HkYfZFgzZX0xB
	mE1j47T6YFg==
X-Received: from dyblz33.prod.google.com ([2002:a05:7301:1621:b0:34c:9660:9612])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:20ce:20b0:37a:a9db:6bd2
 with SMTP id 5a478bee46e88-3856e63b064mr17431781eec.11.1795551459435; Tue, 24
 Nov 2026 12:17:39 -0800 (PST)
Date: Tue, 24 Nov 2026 20:17:35 +0000
In-Reply-To: <2d518dd7b8f7be147b9a957ad94f6c6641e4b5ef.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <2d518dd7b8f7be147b9a957ad94f6c6641e4b5ef.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261124201735.1311047-1-pratmal@google.com>
Subject: Re: [PATCH v11 7/7] mm: page_reporting: add flush parameter with page budget
From: Pratyush Mallick <pratmal@google.com>
To: mst@redhat.com
Cc: pratmal@google.com, aarcange@redhat.com, akpm@linux-foundation.org, 
	brendan.jackman@linux.dev, david@kernel.org, dev.jain@arm.com, 
	geert@linux-m68k.org, gerg@linux-m68k.org, gourry@gourry.net, 
	hannes@cmpxchg.org, jasowang@redhat.com, lance.yang@linux.dev, 
	linmag7@gmail.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, surenb@google.com, 
	vbabka@kernel.org, virtualization@lists.linux.dev, willy@infradead.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cc7mkstxja3s1o7bi3sq1oz5iynpk3nz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C62140007
X-Rspam-User:
X-HE-Tag: 1795551461-541023
X-HE-Meta: U2FsdGVkX18k3eS+6eQ55YJ5bUkgfEmGsNuOX8l+vTI8nBWU2w1mrzak29HggVTxEwufxDgYW/Y0jmhO3cqNoOij/HuvQIGxyhWwKV/UkCnFRTnb/J2w4cP5ZKyxBhttmI8vEUWLUSkMJ4wIoMhnLvkJwCcCJutlV21bW/nzw8PiNM4Ymud7PUUgzCLhsdnAj5BKdN3oJr9sd26lU8aND7jYqOXJpncaci51yWvN59vptaCQMo4QIwtiPtCFA1kvD/+y6I3CvCJgL8AMThF9Ls+wJxGGQP7MJuMTO5utKG2R/8tIm82mu8/zXohjSMdpass/Me1gcdUp/rfvCC2TOxQVjtErkwJaLs6ls/ZvZRTB+YFZmR0xtkZ3qld+liLzQwPkgTj6qjAE2JDfbhCzCWTUxjyq74i+jnTWF9XT1dN49yzHtD8Ab05EB8jvBDOV2BjgQ2eU5CYOCptLJsTAoz4z2nbUOkwwTO8wnRpso+EPCOKUgeU1/xtzHWLfLrv9zbTeR9J/4ZU8v88DjHfk6ngOaNGTwDlV5vw+uTC2fFJgFObrc72+HIrjIBXR9fnZ62jPbgWp1ET82NbGUNXMnZgpDxRcuID6w84Lav6Qeu6n2GNTrvCMY4upY7+wdRLuInvyrr9vF7j4GkQcc0trXYqjJCCNvaH7saQhLW51d56cEJw2FyLqkCnd20chxoU8ylL/zZSKNNQ9WsfGIQTai3sQ2pofl7sm37HZE094fb2pOo3IOntXc7KbDFLAFiRdvCin4P37/IrgOCfW6RldBSBmqrLeAJS5HgqYxOqGlv/4yR7Q6QUQp6Uc57PboKs0An62+r6vNAHtn7BOUIQ4J/QroUzvBoVOAaVeFYwjf9CTr4Oa9O5uN5oLj4oaU+ZeHqY3m+1OsJt8nA5QRmXgg3MJdyuznu8cmAaQRovs7e3BmmJba7vwK180+k3IDBhyKDIJWdyqozx6RRKUvCJ
 6t2eMkX8
 9FM2d9ChX69aQVSJ8OrTfCLBtKrO5HMwGAIwR1b740CMaLOR347pbqdRSHBAH3O0BK41MmADdvmQUKH8de3z5cSLr9PJ8ldnYzzvZb677giWFE+ZD9L90xkX9yyQXZaWqIumdt6nt1aG3OL6xq0fe6AKLn+JqctE+c0bVUvT5UhmPAbiBegvf+a4HwqR2SaAEozo1xLadkjX0HXHrY2Fa9+/ngx36VLtjGIMy5jR+WJQQ02GUzbwztpVWIut1SqHhlvVdSn9X5y7iQNkbutieDr0aq6IwDe6ar0Tk2spJKHrzC16oEAKAMAX2fv/kElwu5m+UWugmftENzs867177uG+948MBFVXT/6CJHxCG5bi8O8QjQhPT8jiR1bh2BcMUx83D/tUc8V4JUWj9O0LjY0xKIs9CAH59WsNT0RM9pHNjvnUcruTRoJwdwimxsw/8+rgskEvr3q8/p7D9BuqTVMbIxYkKTiUjlrVNKZnA7ggmTsxVSq+gQcqYcqiY4Svt9+wxQeewNHnME/FbOgWQeVLNk4ebqXTwzQTCPhBwoy+RHoCljQlsdXSw07mWjBcrb7ct/9+hFKBx6I9JhxJVRWhtvnfbCZd+7NRltzqP0o0OH7miM8uJ2etT9w17IJqFfKkns7E1NylwxhnQsHRouClGyQyf9bz/k1HSTdY8tnJxp9xxGciCbHedhPhYXJfk/BqZWuqKpBxLJ9P/o8UQfMCFw+aWZ5JhCcRHQG/7MSxX+1qRG2qFw1ZEIFOfuEy6yV5LPk7Yo26ZSFrowDQfMJQAWOS7T+anlZjU1Z8FC7zbZ56k2nsV0gKoU48E0bFqnI53twnTKBdRn/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 07:03:00AM -0500, Michael S. Tsirkin wrote:
> Add a write-only module parameter "flush" that triggers immediate
> page reporting.  The value specifies approximately how many pages
> (at page_reporting_order) to report.  And I mean, very approximately.

[...]

> +	if (prdev) {
> +		while (budget) {
> +			budget -= min(budget, PAGE_REPORTING_CAPACITY);
> +			flush_delayed_work(&prdev->work);
> +			__page_reporting_request(prdev);
> +			flush_delayed_work(&prdev->work);
> +			if (atomic_read(&prdev->state) == PAGE_REPORTING_IDLE)
> +				break;
> +			if (signal_pending(current))
> +				break;
> +		}
> +	}

I think the amount subtracted from budget here doesn't reflect how many
pages actually get reported in that iteration.

Each iteration runs at least one full page_reporting_process() pass,
which walks every zone, migrate type and every order from
page_reporting_order through MAX_PAGE_ORDER. How much a pass reports
depends on how much unreported free memory there is.
So even "echo 1 > flush" can report far more pages than requested.

Could we use this flush as a trigger to start free page reporting right
away rather than waiting for the delay, and flush whatever unreported
free memory is there?

