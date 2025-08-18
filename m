Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4455DCA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 03:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D902B6B00B4; Sun, 17 Aug 2025 23:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68146B00B9; Sun, 17 Aug 2025 23:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA52A6B00BB; Sun, 17 Aug 2025 23:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B83276B00B4
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 23:06:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E4255B081
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:06:46 +0000 (UTC)
X-FDA: 83788390812.30.CCD8589
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id A41C940005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:06:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Wu/A0SKC";
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755486404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shiI6/ap2frXgkN2f3Ln4r2JMBr3WLypjqupvCzcjNw=;
	b=MPUbBN43cx0uOKF3G0eubmpLreB0n+vB8nVcp1YspekhTbPrQmujd1Omfh+DEGWMyppQGg
	prrU9ya/yS9ym6zRYnbMsEQeHS+T+E5y5avweEOcUR19xFcWO4RLTqqCx7h4+CA4uSDsvl
	46sBhXkRtsKH100cHiA6Wn0SfaBg8w0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755486404; a=rsa-sha256;
	cv=none;
	b=kO3SG8i6E3WSQg+DEYfODdcPW/q6Gh+XEp9oRZTm11d0T9OYultD2pRkHR+PqSwGkZNgwg
	w9larGffY+zJeHaJIIWV8l7FhhMNYQoeCvUNe5+VECMBGFOodifEjr7Ngf/8hW5LAV+Oeq
	0wUFzMeeZXbh1sAkaUqX4/NmHEHBeXg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Wu/A0SKC";
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AAEF65C57BC;
	Mon, 18 Aug 2025 03:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F47C4CEEB;
	Mon, 18 Aug 2025 03:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755486403;
	bh=O29tCrJHU7rF/MV6Hy+n/kwRPq9NUr3UFlrphrwAj00=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Wu/A0SKCu67qPI3H0x0peUYytalBSwfEQra4zvXSxBLut7inuvgto+B3ExcvS3GlQ
	 cktoq94mtVbujmdWSd2zsAhaBsDjWT8rphOaxiSZsdspkAAiT05CWXcFLn8IHRWWDe
	 hIgPXGWMCXuq73nZulRf8uHz4OHAunRF5Hm/IvOQ=
Date: Sun, 17 Aug 2025 20:06:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, riel@surriel.com, harry.yoo@oracle.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [Patch v3 0/2] assert rmap behaves as expected
Message-Id: <20250817200642.c3ca3c89832fd9e0cb5117f4@linux-foundation.org>
In-Reply-To: <20250818022905.15428-1-richard.weiyang@gmail.com>
References: <20250818022905.15428-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A41C940005
X-Stat-Signature: n1djgdtfge7qwqkhq89791xa5csfeat9
X-HE-Tag: 1755486404-749040
X-HE-Meta: U2FsdGVkX18RucsiMUENbmb2SWwsqIjKtGuI5SRQZyGuFXtwRnQGdtrUs5dMbfnHOmjQWnrg9BzBRwGquOWedsBlmdXAsZmTNzW2nMVBrpO88DrmtpSBZCInVc8Xq8mBWgoxdf5OsbK6ZkwfiRI1blezV4fFYCHSCrgyLTX288RyB2zwwsmcruNNGyFdQN1YFBjDPN+Oy3gWr2IjKQ18EJ+cT7eOYOEJT5I4D5QkvyACRhhnF/U0PUVGpBmt8FqQhN+7H47/sD2kZXc4rNu5c3OtjjVkYTjzj25BxRxRjEs8DxGF7smI/yDfIBhXCiY54cXPEMDTS9b8ZMCSYwYG1F7Oe1FNlv6QVyBrc8bqhgFoWT2n5mlA1CtP5jImyfSoc0YZr/DKMHSzQL66M9CNcAm7ZebvuJfUdpEqOBpSx1vVzBPFXw7GBWtgGWsE5t8SEWjBbSkfryl9Z4bDZCBSSSonNhseAL/VkxvJksa28+AMWqszorPav9YhoxWJEcgr0LcTUbk8dqOXMIoHR+B4AeC1PrnMb8IT61o0Ok5jInlVyCMV/joixU/XDvAdMdEKY1ENz8K/YfbrlCf/fNIbz4w8xyibaY0Iibzo30PpZzavBpnqWwxLuLb8Q7bn+a6+q1+kNMncBbpBScxm5GQ2A+A/ZUGeQQMEL2PHyL36bnk1CNOFz1hHApEZ4ZqnA6BO/7LhqdJfR/IMov05LhAKfypyLtcigjVClz2+npOa5n1EMyhfJsZA+a/lKId5McgaVgaTxw3JyPT98GS3MLKxrOng6uJ1wYQr6Ne9JAafiMZixYNGqz4KTqEA1HKYviUHckjQNJ6WAGGXY6sSXFv/2KZl9kl4QTISck56FwBjxnjseYDguPNTxpLdXeG1b9KgBGoddc8234MYc5+u56zO7t68L/i7C/PeaFRJQp6Dt6qwds8eE5OPn4vfF0mAK4EooWBHWHdBcwmYuWEWS/Y
 qKq+uPA2
 QnE13oAdGtaWYT8HllNtoKpZ9TmzHo9xcvrQJOg88oLts12GlcSjoEUPrFpJDbBGpYsayEzZcyWD2cK5ywjhTq9f3cDZgSDBrYOQ/V9Y6lLxcTfkgSEaD1qSWRV64Td3E34CsrP6agOMqAs5M1U/7V2C/MG2hy56kfDaq4wKRdfxH0Exzzo1YYuQSaYJyOsdQGriG/olIkDu4wkQyMjXlmqrnOPxVuxnWzfXFSdJ7jQ8D0JMDbfsFSzzselVmPzHLJmSEnFoh37xDULvpxY8Z7esDXBrjB6HTbvh1ETySoMpOPbe+qpy+TW/4D0pA/n03FAKswVrxD2yOuMofI3Odss+hDHrRyRb783xeLi02SsapC/W2rK2WMLAduA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 02:29:03 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> As David suggested, currently we don't have a high level test case to
> verify the behavior of rmap. This patch set introduce the verification
> on rmap by migration.

I'm seeing many rejects here, so please redo against tomorrow's mm-new?

Also, seeing "assert" in the changelogs was a little surprising.  The
term "assert" made me expect to see assertions, such as VM_BUG_ON(). 
Perhaps "test that" would be clearer.


