Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E16CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 00:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0986B0007; Sun, 24 Aug 2025 20:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791D66B0095; Sun, 24 Aug 2025 20:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7006B0096; Sun, 24 Aug 2025 20:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 529616B0007
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:17:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA4D31401C0
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 00:17:27 +0000 (UTC)
X-FDA: 83813365734.06.C9B4300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 117C2A000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 00:17:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xWdozaNU;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756081046; a=rsa-sha256;
	cv=none;
	b=devOs/oA9yFdIMU+OO0iPnV0cCdOH6kZI8xcjcoED3XExbHRXVNmszq69DaLeV+Bguj+Fq
	6VJzIlUi1aYyUWtjysXH8PvRoBgpasREZeEB2zbCVpt9WcoBA+aojJ8LUfzJmTlU6jrQlR
	hwsdrwWNWQn27nnmdWk/iybRqgTRdws=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xWdozaNU;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756081046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LGExPFq06Jg72HR9++kMuMOHkDGt7UXctoAScatuPE=;
	b=wojQX3rGKefQRwz+WW8IIM3O7GeHWFms/xapjXVyOTwJBZJWvcHqu8X6lyP6kYYj1H9lOw
	YORQ3GRiwfYXMIMRMY6vswPkmVdLGzzOv5JYMEB6zprX0rKx2SBpuf8K+SBhjowwGMENUf
	zs9oZVpPE7j+RroB5NZzVxgmbkYE/Sg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D7A84441D;
	Mon, 25 Aug 2025 00:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D48C4CEEB;
	Mon, 25 Aug 2025 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756081043;
	bh=+Za+wb6QlHF1oKYfGWLR5av6WtH0xmMNI+APb0Y7x4Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xWdozaNUWTmGFXHzJFS5GZ8QXqnbZtN3AvSpzBqbjScoXDixsEO6vXIenhumbcla4
	 8/5+eJbB1Bh7BTq9IGPn4zRCdCcX2vahmbtONiBS9f6GVrHlE3CjuR3vTtTAM/am5i
	 j04OlJ172kNwu77bDTGfxdPhs+SB323Gn6wbzooE=
Date: Sun, 24 Aug 2025 17:17:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: ally heev <allyheev@gmail.com>, skhan@linuxfoundation.org,
 david@redhat.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kselftest: mm: fix typos in test_vmalloc.sh
Message-Id: <20250824171722.ea915592ea3bd060c6b17a38@linux-foundation.org>
In-Reply-To: <aKq25rlqbyYDaWVo@pc636>
References: <20250823170208.184149-1-allyheev@gmail.com>
	<aKq25rlqbyYDaWVo@pc636>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 117C2A000D
X-Stat-Signature: 71zk7bezp45dr5k1c86gfi575ap95cih
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756081045-694313
X-HE-Meta: U2FsdGVkX19w0rbBq8F/7rl2gu1syjwL4RMIl5bOkPJRkfdC24wIgk+YLfhy0Kk34nDnbvgFlbapMSV7LO4iigiJeQMop8SU8CPnWtm/z0DxwdcXvY457/YSdTQvasP2F/m1mc/sOwDidI1kuMETeaRJmg91AU0ucQNxJD80vT1f2F5vZJavqluXo2MsyFo6Moma04oglZ887GNesAQp3WPs5XQx0liF0vrjvwpT8x+WAkIWGk26Av3bZwj2bt6PssgeSzbZ15eFpPtYqjG3VOdFNjB1yPtKlMiy+0r7lgHWutCe8mlf1z8lu7f/dOiNae5+MgSiSdteemaEzWeYGsaDLQ/YaR7iX+imE4Sy11yWTPugWtCC70mstp3Nmh9Kmxy2J2x/KbEQgY3aZ+fWSxZ1SrQ2g7DyyllbI1Fy9MrBTXv4lYIyTqHV5UfitqEFwIlQHSVVQGzPpMLBUT/ruX0cjcIgYGvpuZDEVtqbn/Ai9RNx9hSei7UTT9lUMesgb7LeW0GyAd3ol919hWAUXFq7OHKeRd4Qmps9Umk+3ZFuNq0A78QZpuu+5NwwADMuw1qtFji/Y8CZ1XcFTaZM8LKDIiXcVpEtCwwxvFiSGnAHD9tD/VmFYQFTuuEaiYgGq58LcdMqSKFzeHlXyn3haADKR7pC4y7EIpXZxLriFnW6aQYcwOScrxQVLtRqsObKh+KjTDFPHucPzPS6zbJ5XKPd9VY0VbtVuTLMC+QhYFc+jDZOTCm3xBufoBILvF/JNxtUfDn1l3DfjhFnFE/7HCbLVfRw/XtyvkmbpljprAWngmn0egXDypjbUBFtljYc/nLEXjHC0sR8fp6dYSfkCo8llX4DRncYGkKenZgt6wB40kss8jnZ4vh3f5SH2dxRL8WjXxypVLhdQMpXZyDWweX/t656sOEzCRHi/Zee35tss4p3oowLshfdVNBRhufSbXO7ibohr7S89qUp6yW
 Y3myZnzf
 x1soebvHlTu4S64s3qgbdJlDRnNq9pqlPK/dL7QE4Cd1EmqUhH6sXH+NE1wOyxOBpqjiLPg26jod5PDVuMgJATzYR15ZL95QtCQ+NQWS0Fb+3V0QSzGe04veDfzNz9UVphnC4nfmsv1Cbsf2MSz09CgdMokHVaCFYOxm79aU3O95NV0K8XmfbohfZ+vuQFLltrGQeQ12Q7eOL2CDBhdCdhZcJFVwOnjORpp4ZLpPFjT119Zah0KkMomfyhZ8tEyd8RTvHgFEFYBeCHGaTrIVINnd4r+AIzDtCoBCynyYdXQyTaThC9FWVCHqqE+mwslSDhIRb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 Aug 2025 08:53:26 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:

> >  run_stability_check()
> > @@ -160,7 +160,7 @@ function run_test()
> >  		usage
> >  	else
> >  		if [[ "$1" = "performance" ]]; then
> > -			run_perfformance_check
> > +			run_performance_check
> >  		elif [[ "$1" = "stress" ]]; then
> >  			run_stability_check
> >  		elif [[ "$1" = "smoke" ]]; then
> > -- 
> > 2.34.1
> > 
> > 
> ./scripts/checkpatch.pl ./0001-kselftest-mm-fix-typos-in-test_vmalloc.sh.patch
> WARNING: Missing commit description - Add an appropriate one
> 
> total: 0 errors, 1 warnings, 24 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
> 
> ./0001-kselftest-mm-fix-typos-in-test_vmalloc.sh.patch has style problems, please review.
> 
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> Can you add a commit message?

A changelog would be identical to the subject.  checkpatch is being a
bit excessive here.

Oh well, I'll add the obvious text.

