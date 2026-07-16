Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC48C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8506B0145; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B056B014F; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB956B0145; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31A106B014B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 443FE1A01A7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:54:43 +0000 (UTC)
X-FDA: 84994785246.01.0DCC434
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E7CC180005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:54:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROn1OsP4;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784210081;
	b=SA7PHmKkI1kSma9Wr09l+Aq4a7ofSc3HiJRMkPi5OD5oWhlN0zxhobui/I8M24QyzXlYIh
	VUZLQKjZELCfFj6BdlphXqB5rcb+y0IYmiZga4+T6wzrB647qvRg+ymgQutnz1qlSi/qSo
	Q7neJJH/MAu7oZGgCBQDrn4lcc8IrrE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROn1OsP4;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784210081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Irz95G1lM/HF+OWbwi2S82U6C5Yrl98ngENc7Q/VU8=;
	b=Wfuhsbq5mseLs46x0rGuRA1ArHTiNt80X5FS22M2Nc3cl22fXhg3Aau8njCcyPLF4OEwV+
	GhkBjSnZIkoUOn1hAoqqmA0OvWNykj8NE/JnrLjikJoyo+VFPax8Cv+bL8zCIKyZBgM3B0
	uPVBVZGCXoI4To1TYKwC4euYo4+PHOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE69440DEA;
	Thu, 16 Jul 2026 13:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2101F000E9;
	Thu, 16 Jul 2026 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784210080;
	bh=+Irz95G1lM/HF+OWbwi2S82U6C5Yrl98ngENc7Q/VU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROn1OsP4Gw9erYrgPy++5eJ1IYm8t7d3aTrjX2+NrMsKNM2z2KOYgSwkoo8R/x9kf
	 WhQYLNDc7mZlrkE6sh7TsWs+aE1qVLh1takK9dX5xRxyXm1sxFNh4mZnXxvSdQ/5Vz
	 IIGN/zPhhdy7Gz/FP+Vahl02yMtT1FNm7vR8CYHBINkmrI9k7Lh1uFXib9HyqGpfdW
	 ckuegMf4+HWU4fCgGT4Ivf7oJktdtGVSdBnQ9EneXi/kecNczmQK8VfGDReeCDdUuo
	 5iLiHP5t0WEBp7o0m+hWknT+PJiOKHpkdGI38fnjGCS2uGwW4DkJk/VWF83tPrGNNm
	 2LeyqtzS46Hvw==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] samples/damon/prcl: add module parameter description for target_pid
Date: Thu, 16 Jul 2026 06:54:37 -0700
Message-ID: <20260716135438.101815-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260716091444.284702-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E7CC180005
X-Stat-Signature: 13mw43khz3dtoud6hya7k7zp9ji8n9b3
X-HE-Tag: 1784210081-681167
X-HE-Meta: U2FsdGVkX189cdt5B6CbmBOekthN8aJapy0IILiW+aOBay2ct3l1Oqf5tZZ/oe1Bo5BIT6NIT/i8aXgKHPb4WPBoTgXSnScjlfWJaAVJndALaUHHCnDSl4h7WwdgObapSCFBEQsQ6pxv94SuXKfv7lEkPGZ90y0B7+TUynAZXWfn/kAmwlXPOeHRidcAzZcMCEbbIe3GlASjzZthBstfF4SXTvOy086PG+sr0ZTLnfWYDjmNBzx/NtbDm6a0NWMbCeiE/T/L7tTyxPHQDgBPN2XzIH8VqzLMvqjcKChzGw+WvCMozJggOok/FmhKmOEVokPNok19GQPrMO5sVbTV/D7NLOegcWCL/6XvH9ubmIo9XwL9N2PhnD5aEINkbuq8tf9YRdarnLDIYnBgUUVZvx2lY0Dxv6bNO7rjAe15wkIgz0V1ijKiBeLPps4rgj7idERhg8Ff34Zhp2PPjXDe89N84eF2sXOGPRzU46+0eqBOOlpo7fMCbY93QRstFfrqYbVRa+Fxi8mVz447kPkFmyty6+Gy52Fs6FKivUCQWPjxSNynlhNHI81QvUGp9bZuiU5lf0bwBHzCOuSZAS1Mgy6C6U9VwG1f8/1MT0fpFaB948/8iHcUqldzvdPs8kk/mBJjuaN8SIgHLy8lcguo5BwDOXdZ/vdqrsd9AHMB8tzN23uyQTn++h/iN2+xtPzx8E/953RKUuLnfFaL60J5TuzAwovyTj77dWH2/HXnN93O3sLuFtSCE7v4hKG7tasOm4p5ckdFePnSDuY+clUFeUh02Io6NMmqUhJVLDaAHXLZFIkS1F3b2Mgyt0PG6yLFWffQthgAvLuWpK7At8G6l5f/ynHJs4NtBWPfO9R7EBk2Ote8vWSClWGVGqP0RW9EUSfptvaNgHgx3Gzab03eGcMKwPN2IxwdJv4nQ/xFvATDuJrq/EJnVlsVbmgtVqSYYYtBkdIHmhPuIctHpfp
 Yjet4H+1
 RlohOM0JYDKLt0xyOQr4+Ow3hp1oUhouTAxf3ejWtF0FLi4hPNGfADTGfqRf8dJChLtVJq2POFAEnl4QRQ1yoXHw6dPgdZ+IkFq7BrZCAsWLxanVziHjIRuav2Zzs7mbRZwdkuOpYyfVXYs+yLO5n0q5hG4OeiY23Y4L8UPdiBiowPbrQtqTzELTB25ayUZdy/RbLzuwFhlw4t7xyh7XmUtHqHXBje8IIJasqPal8SuGZe/3hN55/oivfrOsgCq0FCOyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,


Thank you for this patch!

On Thu, 16 Jul 2026 17:14:44 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Document 'target_pid' via MODULE_PARM_DESC so its meaning is visible
> through kernel command line usage and sysfs interface.

But...  It is a static module.  Is there a way to read this documentation from
the user space?  If there is no such a way, I don't really think this change is
needed.  If we want to document this, we could use comments.

I show 'enabled' parameter has MODULE_PARM_DESC().  If the inconsistency is a
problem, I think it might be better to consistently remove MODULE_PARM_DESC().
It may also be beneficial to comment why we don't have MODULE_PARM_DESC()s on
the module.  What do you think?


Thanks,
SJ

[...]

