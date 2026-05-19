Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB13CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272906B00C2; Mon, 18 May 2026 20:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223436B00C3; Mon, 18 May 2026 20:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161146B00C4; Mon, 18 May 2026 20:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 087BD6B00C2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:14:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C31314010C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:14:29 +0000 (UTC)
X-FDA: 84782247858.19.722CD66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6056C40005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:14:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ff1x31yB;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMoa0QdjvmNXPTEbCMOGavC2x1OhoIdwkILLVOAuuK8=;
	b=EwYaQsclyo9PJQCZQqpQpIvuvdJKM1V0Olxod7V+ne7w+uC0ho8KztmK5uK67n1TlSuN03
	S9RBgg21gSW3XMXnH/7IOs5NUCcbY+E9o0eclaogACTtd8vgpvwuy6uqcIakidjLQv92uQ
	qP53WVxq4oX0dxr7Xq4zU62u6mIU524=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149667; a=rsa-sha256;
	cv=none;
	b=q67KR2P4b4Z+VBaVZawPMQDQr8bEN9NTLejLe7S0xzvsiovd4NEMtHehAD2PIEGckW6ENo
	Fo2l/g6lNx4kKSX1aaBFVmRsa1OsSgZO4Hu+cgPwLpTU2+YsXscaWYYm7x79rnHMgdSZ5k
	JhSJHDFqyXoLEw7zrcFXodwWcIeLfvs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ff1x31yB;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3234E429D0;
	Tue, 19 May 2026 00:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE955C2BCB8;
	Tue, 19 May 2026 00:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779149666;
	bh=8hLUhlVeBXvtNXvffC8pq8Y9YNMUWn0sJUa6zaFn81s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ff1x31yBZu9wy7ExxUXYqdk+tEhi28kEmD2qHZJDJFO7aIYpg6JVpqHGX/v8hTDSO
	 8HKBifj2nQ9oBiERhZ/gISU/NvyQFm2XFYW1kRfj0I26ODj0weh1wHe9QOtvUFyRsM
	 LvbMWQAyOE1H2Gx/jPGvis4t5zCKbEqWv0pj2dM8=
Date: Mon, 18 May 2026 17:14:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Message-Id: <20260518171425.e632dd85e0ec2cf995ccfe10@linux-foundation.org>
In-Reply-To: <20260515091942.1535677-1-zhen.ni@easystack.cn>
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6056C40005
X-Rspam-User: 
X-Stat-Signature: gxpfdjqniz78hhcnwsxo4n89t5dzdwkk
X-HE-Tag: 1779149667-701386
X-HE-Meta: U2FsdGVkX1+YulCxQ0q/a7DoS7FimpOsvnaA7cr0MhmauTFwyCGwrReppJNvzX/c9kLurFEcxJg+GO+BZag8NHc61vsSzOtsxGkZJBpv916jUu6p4JjVnJKW7kRurXr5DqIQSeu7k8DFVdkDvPLtWYbVoPml91F4nfQvsytSrwG2EQiOn5kETMoJ/rFUkOWYtYKRV3wYnxMLb6ocCEaJlMaRHY6wMSF3duDCB+mCQtf0iDEO6OpZCFV2pCQSoHN723jEUFLLoWy6x8q5PHD2DFnxiB/gzpMG+SaIu3IfE7pyS43i5zCEXrWv1vtLUV9PZvz64b3yYMUg4VJGu2OJGCqpHEd3GW6NZhjqKgCTvdtkAChmczIrAjs0G+cQcWxqwGmQEWWFXJkJuei6sf2VFxoJc5IPyJFhjIJaOStn2O8jwstik+FEq1XFeasP091ftkdzH4bVFjNih0PPKQwk8EVRZT45FMifNCXSpC7EIrmu+0/CzjU0z1UlXVMe4qvF3YXOZSdHMhuZzryd6dNprXg67wYHUKvbte2G9sprwse39qgTIggG4Yxh1MkqK0o5rcnIIK3kbV3A0OK3Itjl4WYNrVOGT4RfZs/7vRzKgiSA5TvLk9FyyA5W6K9kppnlMRM0lIUKSsSaaRAp7Fahz5uEc+GibJkRsa7Jqf/w01rlfrXG78yNtbnKk1VyU3givJ60YHDaXJhmwB/+jclPndIJGSG/D6ZJNv+xHOdcv67NMeOyhplJU5DKcq4rc5U5K3TwmgWCEBbxVdDaMCmVMBCLpduFh7oN6DB2tIJIlTQsriNeAPenhC3IbotooD8dJWnU/Da6EYztfWUHQOH5Z9xhrJHhopLx9LVy/LQwwcVrKIWwAmppnDiE02xr14A+V6XWLOq9X8E9QacBGg4WeyrXE8nfegIlT7jcDT801qldVwHXp5p+LqNWVyJf+3I1w95wUBVYohRq8NOfYE6
 2dAJOdtr
 Ld66Ayxp8IgpCpbQPy3ZbzOPti26IV3yxdgb4GuZCSy7eK7d4MRz5uhCU9C1QJT4T8Bf0CSANhaL5fBa40D6bQ6KGDdGZmU/SJO3UMsqL4UaBcHN4+7asyFZ97swU8iO5ogOIu1EFcWKFassnklFbp782e/AF9zoWrLnXkffvhNUVjIPkkFCBCSO1GqY6uOATZgyMRWG0Z7ChnZubtQSvexN6G25KFFOkffOPJisNcYgpme48j7vUJqXQahz4GMZMsARSWE0IoEJHZG8xPL6W7HxvplU2rjWKbcKz2Uy9LCvSG+2OAxEWShx2FdGyE4vyUYsBwP6vumF+vFcZzDJQqAX68kpONVAwYi8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 17:19:38 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces per-file-descriptor filtering capabilities to the
> page_owner feature.

Thanks.  AI review asked a lot of questions:
	https://sashiko.dev/#/patchset/20260515091942.1535677-1-zhen.ni@easystack.cn

I scanned the list quickly - there do appear to be some things which should
be attended to.

