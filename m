Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953CBFED9E9
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0B36B00C2; Tue, 17 Mar 2026 20:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7966B00C3; Tue, 17 Mar 2026 20:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4396B00C4; Tue, 17 Mar 2026 20:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEFF36B00C2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:57:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B617160407
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:57:11 +0000 (UTC)
X-FDA: 84557369862.22.12F9CF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B72E91C0014
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:57:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJG33wLP;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773795429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKRWNm9LPN8oEAUK/1d0Ox9Fff2t3gWtJ2nGTuUTF+o=;
	b=D8u/O4t4IAIdtzBzkm3mQMAmkfHP+4HYuEJHllaYIMnWYF3Ooot5Z6gMSfyQgUOz0cWZ9E
	woZCfPN+KMtu1Z+TPX9AGv72KxRxdMnfCMENNVzPwTyweFsCKZuK4vqpZ+Eo9ZdJ9ykF1H
	pNHMRiKjsDinAkY/oGSpABASvQs3AdA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJG33wLP;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773795429; a=rsa-sha256;
	cv=none;
	b=JGyZ1QpMmephbyN/+CYZzNNWIW6izAEECAEPBzRKsUBsMHJsrbzYCAL+kicbwtdBa1teuz
	Yh7uLwBQ14OMl1hICdn2yhehNm7TDxdB0I7isbOM2wd6pamzhQugkb4pek5p98O4Xr3DaH
	lSMEfvUsa6h+pqVf6TTyK0ttbw9l1Ic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D8D543F62;
	Wed, 18 Mar 2026 00:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9F3C4CEF7;
	Wed, 18 Mar 2026 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773795428;
	bh=BbrR2yJFV3QE2pVvXjPV/Oc51nDEnob1bgUAljOu5qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJG33wLPwj3WjUdcpfyd8j6tRg+gqdtrGvXRBOP25HNsfbdtdQ9XbzlzW3wfA7pj9
	 NqLjqgaQauIRPD0x5wewDumvwEBVEXVSqiLLSUtZMOJEFjjnopO7qonduGURUjYqK3
	 YDydcKh1CXnEDbVRo7WQGL3XI+v0k/Slejkgxrv/NxBIt+aQuy3ZA3VzlFrBrErzHW
	 Vc4B5aoEYJFsXmA3Uq9NOirbb3r76SjcvO3j0+R2vYfCxiQzg4J968QcVug+8+B+gX
	 BzNHgW0WLyDJ8qSMyf++gdCzPoPquQmL4184FlAabces/Bi8XfoToU3VJwZhTImVKi
	 Ju7iWpnHwcjuQ==
From: SeongJae Park <sj@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] zram: change scan_slots to return void
Date: Tue, 17 Mar 2026 17:57:04 -0700
Message-ID: <20260318005705.132331-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317032349.753645-1-senozhatsky@chromium.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6exjkptbcwiru5nyxfnri743pf6zzt3n
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B72E91C0014
X-HE-Tag: 1773795429-701119
X-HE-Meta: U2FsdGVkX18Cp+QFJsWiVVKkHrGXEH0K+XErgTWytPhRoL4rCL08ZlDnWb67oNSU8oXD/KeXh5ak1H84BJzZR+EYGN63BwdBFA4s49zkBD0SJiSVDlLkt04djh5ZDe25oiH1hsJjM+Ev74y4iFN+Ebgjyw0G/MQ/XBvd1JjTrtRjZbhntm8XPFn9s25gdWC0OVl+v5RrpEeQXWRWbO1lG51vQgnWhkGWc4kH2wGOq+Dx+1hwmvhTORk5Lai8YrCh1ODWtB09IIWeGDaJ4lQNQZdeyv/S3C4kVozZ35PDRDD/RQ3l3xn5cr0tStXsTSTlxBlq2lLFhn97XC+0tHD+HMg4AXshmix1MCY7GWZEpUlda5Th2PHka2b4OiI1GM7TTt2UKBMtD2kywd6c0KIEEVkkvqyyJEAQ99dfnGTQVxB/Y3tQvB+OSk3vz+IILDpqGDpqJzff2gbGxhEQyiP8R8oGyIQZQbfLVGoAIr7itIuEUw2bWLOhqitD5BlFtRjarirZAAfm7VuKiaF1CCB5OROJU+i1shs3Otu8u86u/NyQkOPCJvSAt3w6gVq//1hQJKQixoxfg72lWAm0fk2/o0h/sIyv75sIGcZB2Z7fRR0U88roqsTOHOUiYuQKwEHinj7J16MhX1e7AzR2LJZBugJkqhSPhmLKpcoeftbK9QoeY1CO+ASmPSdRKeNdjBJFD5ucaBsSJGc/vjQ+e+4eFiK7l70jPiglV47lGBbkfje5V6D02j19EQX6g/sjogZmL4wzsF1PI3mUygZBA5UYa1W3pKtDl6xTtLOBt+8p5bHSdesNS7ietIqPXrt88XY/qAy4AopFWH6qDOLFJfKiSkd2zEitQCYvElpnvFEGjfI6W29JDoAjODRoWSIurtvsW3hAEbi6zwTThxAXwReOuXdpjiBl7/T+mMEIV+Xiv9JljBdqv4qOHvPwCcBHXvwCWZKvSXvrYB2mCm0wbLH
 7yamgyuc
 W7H/q/IkNPCVF3O7DeLu62aCXPM1nrNs2TrMX4Bw6CeDbtlSmCogCQa4EBSY9G+QNjJdJRISA5ZXdo+UZHIwORqrZpCcmDy4tmSU7gY1v7rzUF+OMxicbJOAoj2lZKQrap6CQZ9oyeiP/hL+nPpsGj+kga2jqVhRUx9jazbaXK76tww9+I0w0mpEwFH3wOyVl8Lyd6uU4uqLbEAXcu0/nsQ8iXAX76htBmRrc1sdd9uyhpMwK3RpYMOr46gOMH+CcAPhaUMaJuynlwnQ+3GTHLRvMf9nUtOwVVb+AoTBl+n6ncBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 12:23:19 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> scan_slots_for_writeback() and scan_slots_for_recompress()
> work in a "best effort" fashion, if they cannot allocate
> memory for a new pp-slot candidate they just return and
> post-processing selects slots that were successfully
> scanned thus far.  scan_slots functions never return
> errors and their callers never check the return status,
> so convert them to return void.

Makes sense.

> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

