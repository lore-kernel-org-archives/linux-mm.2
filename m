Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F21DCFA478
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676076B0089; Fri, 21 Nov 2025 02:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF996B008A; Fri, 21 Nov 2025 02:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7736B008C; Fri, 21 Nov 2025 02:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 386256B0089
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:45:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E35E712FE92
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:45:08 +0000 (UTC)
X-FDA: 84133828296.26.7DED0FA
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id F17DCA0002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:45:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=OaV0nAYl;
	spf=pass (imf15.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763711107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JE8n4ef2V3IJTTEd6KB/XXyiRp4NHkcmBEBh+dWI+Eo=;
	b=nD70ZPrwyWGQKqlJZaZ1oS05vNfAB20PP6hBvl/r52bwZ9oVBzS3/2jIdQVrXz9ERDBS3h
	QI69Ymp8JVPLggTusOpAm6bScYxjV3GiDhdUkSiyAa212fWZtuKmRNz98Qamvr+TBWQEYI
	3huwEeYJNTISH70uliJHrCIhOSa6H0M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=OaV0nAYl;
	spf=pass (imf15.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763711107; a=rsa-sha256;
	cv=none;
	b=w56t7jYR5VHfcn6/XGwUwRAz0F+ZClAO73xiG3Mu4NSBnXjFyixjllDhupk+Yhcc6QX7QC
	gKVvvBFjl0ySULcfaq1gwlYeBd+j5RiaiQLjeGOCHTe7jYD3czjPCx7WJs49MAwqBpzpXE
	UUeYaru2Mra5YVSe7RBYCLOIp542BqU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763711102;
	bh=JE8n4ef2V3IJTTEd6KB/XXyiRp4NHkcmBEBh+dWI+Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaV0nAYlcKk2X/m58z8OrlcGD3Q4LqZ8Fs7LVdOMBRjMRQKOCSmBQ3DSD8/pnE/+P
	 CkIPtQM2P5aTyxLmCVWWmyuv+hLUJVNuVZO3S0ZLag6X4/YH1JmCP4QGsl/YMxRdW+
	 yCT7/qTXY5TBYvf/kujez6fd6yluVDZ3tqzSV+2M=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id B3BBF8C0; Fri, 21 Nov 2025 15:44:59 +0800
X-QQ-mid: xmsmtpt1763711099t8hwyz0vd
Message-ID: <tencent_7F5D453FDCFFE315AE59E73779635F865D08@qq.com>
X-QQ-XMAILINFO: M+6QKz8nsrJQcV7g5GXCXdXddYR3xutlAzsZVSuzte29feLFnTOMxmAPEh9kNF
	 iDDT3V2c5wgSVJkE/ig65ixOvVUbF4jFsJDbGnJtVXftiC8voG+nJ1gMX9glvPqdrknDM9f6WT86
	 vOxTMfql5WwcArtW7X5Hdk5hHgKQqlVblqg72Yb+eP37HYVbuVIRxz0uZ0yxtWwfJ+fuYb6YZ+MZ
	 p1zenSbyTzr5nk/0mqz3RqYqRMXi7CuNFfUHY0sqzRcwyCi+2uGT++rWItcHPzbZ+n0Mv9+PG7/g
	 BJL7qXFHhJfZgqXifzMY0sNidPjG7NOCLRAiO9T8qLnrZ/ZYuO8WCkwepVmaaRMOoo23Ki3rjdkC
	 VPtEEEIEfMJC8c5JB6DrLbBS0pMVEXIdGdis99zvz+iLAgXSOh7pwRC85m1D7R2YJK88wT6lvQAA
	 4yaPywPBVd2ZgckGZMQbCMv3xSyakKIKu60fMxqDc98depHRS4PK+A0BjMgGI5Wn3QPe3krwE2of
	 t5Kh1WWe5Hetwu2jDmFocSdkidVidFQHpKHh+ylcqTDrT3Fsxn6no7B4ChtDZa91vX8ya46ikAif
	 Gc1gYUVvd4Dtq9Ln1kqa/QViYhPKgCPJiP65b6jc8vMf05cWim/XRR4T/6aLFwHjPWN5KWvOkF8Y
	 vjdC4O+ADC3XKKJ1rQ4tn5DcKqepDb2QaU87xKj7hF/DLKoIjgwu0+Nb8HXk2EQDlcp5gR8rFeTe
	 tusEs/CKE2C1mDl7kD4ExmjrE9Ehc3uPI/6xDnf1eWXymidYrMKBauo03sW2cY0w/jSxu9BaBoG/
	 EohW+UgeEDvZvn9NQn2gKQoSVZDeQ+La0qjGxGvb6n6LsxGWaSrVP1ht3cSxTwq24ePwxL8Pms/S
	 woPi0ONgLsaEkR14q8BGgPxOKkPUawuBef/Z9FjY+PlCJ3nZT1abP3SGUW+9r97NHPepb0pEhM3C
	 fIU5j6M8yeo/zHTWewXSd/Ux/B7zmK7BVacfbYLd64Y/F4bsDM1GwY7jxlfNRDgHAF/EmRkmsS2j
	 dveR7kHANYytpKUZHfXbKcLGuWvWuLgaj4yLiuoIbNqWXgPlwzoMp/j4b40FV2tXA08uP0dijXGt
	 lQrjpHMXlLnShJbWysHOXMmLz+5T1B0UfkxLvY/cpixufx+8I=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Date: Fri, 21 Nov 2025 15:44:59 +0800
X-OQ-MSGID: <20251121074459.3000341-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <upyms2wnksojg6ix7dha74bjm2gfhv6ieef65k3f2our4r6fp4@kjtpmu4mtbay>
References: <upyms2wnksojg6ix7dha74bjm2gfhv6ieef65k3f2our4r6fp4@kjtpmu4mtbay>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F17DCA0002
X-Stat-Signature: wbsgp4b4xpqjuxmmmbp6kwco7wqyezmx
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763711105-278777
X-HE-Meta: U2FsdGVkX1+r5z9Vhpl/HBvIeNqfVl2oN1rcp7iteeYk2SKIowdGx2ldXIt0U0oCsP/sV1Tdwd7s7TK4A7qCY7+FLwwndaIdA6pao0n47s1WSab0VPB8WZyjfCtSLN93K4FgtoC9U26IL3bsX+xI2uaCk0Zzo/Odd7kXnU8lXvVweUbnTKz4iEiZfmJqEqsMjCqbuBx0skc3352YVkBjpmS/72H7IFVw7rgchOsy9GPzuLLfKOyAQ4yh4lUwH2CBP5/nT6iYVkPSJtPPaP7pWqtPyBNg/45oAl/QXBYsXOoorbYn7g3jeeOi79oQJOKkMez2v9K5SODTdkOZTjpKFQdvbqtZTpHw2/WN+PNQg9g0wj1rAKTM2Nms3kXH0kUeege3StUVhmbbSUaN/nPH5sEtIq/m7cN8l12XwPlm6vpdAMcg28O5OoX85ATvy05nHgwISTpW/SkKgQu2M+zpSEh4qiLGaVlHDzKqfufJg3BqMvYJuvEfWkjt3E0Ip5dEaF/mTSz0T/WQvPJHoXxLyToBTdzoexZeqsWM7YLRPLrLxXm6Tm790SEOeqDMsTsAvwoFjkYi7umPOYu6gk+10lIV9IF9a03Jqua9W4fBw0Un+1Vkmf0JpjH49mUgKO7hRqNvewk9B86zlNSFrbUzZtK6pyO40XXVfAIu78s+plWEZjQo45Ycz4OxHw0vZQk/aj0ERhOvrYDQ4oP1GVOociI6i6fQF0b6Sz5CFWQdUvEgVEhu0AJBEAYDM6QYVjiOoiilkWTl4sErkhlkVD7TDgJgWLhBs9OkUb/f+9c3ZQJJDo9GLwg4UHdgDTBd2QiIaq50nfpfF/1E6cxGsYxkl8aYUu/Rtyc58bTQWcgVsmErUQ74TBMt974g89/zBvZ5bJLmxMnOhn6E5M+hoM/two1ndZ6JrfblsSC4fyxBdCjn6zJeqn4xrmvjsuRpzOeSen+T9NlIXgth50bYB5x
 FMYAu/h1
 qwT0JDjgJYxGWZhG8r45b65d8CgswtWPLNw1c3uOMXt6rqtyPGEFJcxeorRDnEgIf75Nra4krfWmcVygoJWU5KcxeQ9nOrbTskE0AAI79qymvdooC0qs2GQwr7BNloXcJnH+bIEm2CvgElVIxGHos1FW739030bZHhbdMhus4hGbhL+Ur8IpH+e8JwbKGaATQPP43Z8YtgVYG5iGlt+4s1XlYcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 16:32:27 +0900, Sergey Senozhatsky wrote:
> Is "before" blk-plug based approach and "after" this new approach?

Sorry, I got the before and after mixed up.


In addition, I also have some related questions to consult:

1. Will page fault exceptions be delayed during the writeback processing?
2. Since the loop device uses a work queue to handle requests, when
the system load is relatively high, will it have a relatively large
impact on the latency of page fault exceptions? Is there any way to solve
this problem?


