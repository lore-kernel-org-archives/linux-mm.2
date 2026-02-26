Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569E2FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3F86B0088; Wed, 25 Feb 2026 22:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951D06B0089; Wed, 25 Feb 2026 22:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DE36B008A; Wed, 25 Feb 2026 22:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 721CE6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:03:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB4D81403CE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:03:32 +0000 (UTC)
X-FDA: 84485112264.16.36BB4E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2CE094000F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:03:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kf7vD2PM;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772075011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHdFmfA6ydn2D0fyBZktjauNe5rVUr817jAte06w9ik=;
	b=c6dR2MPP7yllP7jWBd/lHxP4Aj6TutpZLrWgdfOd3LL5cVE997aY3BDBQfIdL28GrJeO6z
	dXb2Kmd94lX1Od41uznOv92xXcDRtpp4c1+9bvAuEmTlEU1JFzypHey+/VC5sHC5csEUaa
	p7YU4hH85f/BNVK6VsbC7CYYsrnVgpA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kf7vD2PM;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772075011; a=rsa-sha256;
	cv=none;
	b=sPv1KJ1zlwZEUN9xQrpl6r/BnQwMLWW10wo/Xw9mNkIoooz1OV24i9F88Y0bs7GzMDDtQs
	d17gebER0k+6+yQ+2keBz9gcBzvnVFSQ1laGc1i6EBuik4eFcr0Gty3kGxDutLGWQssZWO
	nd9hewAFyURVc7BakeATQEFulXR/0lQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 717CA60097;
	Thu, 26 Feb 2026 03:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D073DC116D0;
	Thu, 26 Feb 2026 03:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772075010;
	bh=w4nmxgg6B2apbZjFl/wiFqr3+gpq+vuQ3u1MkV8t4+8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kf7vD2PMlRugco/gixwl6qO61uIeodj7f+pX287GNC4q7nt63hRP6khor5FKThsPS
	 GsHH9OI7giafksCC0Cye9sdUcyIjZ+Uz3SvTD8dEBcfteBtTPohLvfu2+NdwUxLnty
	 2nUPZkCm4J92i4NLFTradHtn4rXOoFr0Vg/qg/RI=
Date: Wed, 25 Feb 2026 19:03:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, Minchan Kim
 <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, Richard Chang
 <richardycc@google.com>, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] zram: rename writeback_compressed device attr
Message-Id: <20260225190329.8f76b847d391c71d58988234@linux-foundation.org>
In-Reply-To: <20260226025429.1042083-1-senozhatsky@chromium.org>
References: <20260226025429.1042083-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CE094000F
X-Stat-Signature: yh87pry5kbxib8u1da7jm4ch849r378s
X-Rspam-User: 
X-HE-Tag: 1772075011-142146
X-HE-Meta: U2FsdGVkX18dLgYlHUsAWTTqboxM430XrUl79dTIOHh35NQHCGV2FHO6O1I7+41VAYhupCfbBulJ7uSW5KAJtcikDmS7eU6gq4DgRpcV5bNCCcB3Wrrl6k2eTfjv3SicPP08bZNFkgdGxE1vEMq1auvuquQvd90hddxGZllBmh2DxmLMtRLRlnzCbsVpu6lkLz8YZgFGZZbXQ4fbPKhKrAgcfN/kc6YDOLrKFj1SsLNbwAxpFAObe9S9Bggkm6k5bKGcoWfy2O3KHIPDKu+ZNg50DuRpVNjJJzd1ialK/CS1OyB4l+uW7TVGqgRff6/xUg9EsACS7sG10Gwm9LSc4PBe4i75GAurX/bCZE5/mlH0fSvMP2DHzBwvhBOl/B7k8nlg//C/PPMJF+L1jOWy+epzqhXvt5pJx5qoTUlQJR4E83y47hixvNO5u4p4ve6b9XnAgRIfXr65PVPYvR3boxyuH3u7L2pu2EdkhiUp9k9Sckr0K8117+ks1SfuXCUwEgXEOjbtMdmWFSStvQgHIu0GODewwV6vjq09tgQzxvW2gTSd8U1Jkesop0c4y3c3MKgvZgw6K20xqfnF84nb1yUIcoEbSPypDcTqwm7etsAQGpWPcsHXpGhT+aJtCvJNrCu0oZaxLUnwvRYEUrlYistlqbfO1wVRIHRoZAb14DZmZ83CLXdphyooQrtJKVqmaol/G+XCtrs4KuEa8G87+XcVWtxLcSUls7ZJuhXGp546nArumZDcIz4zPhyCKNUoiK5NMZYqDP/87V1ibOqBDodg6Wg2Fl8FJOn0CYcCbHcKZo+eNqYhQkpGWx084ePXOmz8rGhlS198mX6z720QpimYFofncr4/dUaY684naYkFd8xeQf73VbolSX8FILDOg1ORwZDPav/3ho1Eh4hYhpA9M8TfpDhiWCCCBf9hsCZd+w6yQy4FXiJMZl7QPuaLJVnwPBUKBaKCVbRJnfK
 auks3u3x
 KYqA18AQlCg+YMbaPez39QX0zIRAgxN2qZWq71q0qpSQ+dOTuhyOmxnBAxmIeFCXsYXu0Mtf0Hr61IaO+YZwk7dW2zivKP6e29j5jzm/mZrRIrs4/Qy8H+vFwh2FFdeCCxAN7lVLSS2UdNC48bHPUne4GCC1cFwI8+kdfE7Ii8i7i1Xi/luRJ5iKLRGHPwqHg5VGDRPjH+wzTufCFXU0HZmdReKjhEFJ0JPU2V8ncEEGHRGVWb0s2FxpxPscnrIX28Y6C2D9/oVKrqPq8fEra9FDwIQAiUAXnoWFyRFBflJC94yh+0C38a5bt7LFZetK6qux3iJNFMBUFPsaN2dwsGSbVoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 11:54:21 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> Rename writeback_compressed attr to compressed_writeback
> to avoid possible confusion and have more natural naming.
> writeabck_compressed may look like an alternative version
> of writeback while in fact writeback_compressed only sets
> a writeback property.  Make this distinction more clear
> with a new compressed_writeback name.
> 
> ...
> 
> Andrew, the code in question is in 7.0-rc1, it has not been
> released yet, so we think it's safe to rename the attribute
> without breaking userspace.  Can you please pick this patch
> for 7.0-rc2?

Fair enough.  I'll add

Fixes: 4c1d61389e8e ("zram: introduce writeback_compressed device attribute")

and shall queue it as a hotfix.

