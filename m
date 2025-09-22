Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5113CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EEB8E0006; Mon, 22 Sep 2025 05:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156318E0001; Mon, 22 Sep 2025 05:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093048E0006; Mon, 22 Sep 2025 05:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E98F48E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:33:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98F6F1605A6
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:33:20 +0000 (UTC)
X-FDA: 83916372960.05.246451F
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf13.hostedemail.com (Postfix) with ESMTP id DBDAD2000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:33:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758533598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddHiekMPfP+Dj5SGMmG5jsJGTgq1nWKHn66vR3E7oFc=;
	b=0lR0wz2jOCNAPRKwpFq/eufD1LNh+fnU9QEp8FAg5KuicAViZN22J6Rk/V/NuRmwbl0DCF
	cZhbcCCHEpDr9lpzmGy0Y2V9RiH0VkZzryniAE6tqV78xwm/BRLHTU1HsWrNpt5tKspncE
	nhnCC4qdb4Rbh8l7RBHZYZJmpDUsvcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758533598; a=rsa-sha256;
	cv=none;
	b=v3ab9q1M4+8oSu2OejTcBlYEKVKh9xEU5TFeAuAmlKD66p9c4BxiRoZVDiQrOmC19Qc7GT
	hQtouMdfAc8pGKG+MHF1vJTAf7MR4iSYhgsIY/psnotPcdE0P8/OhurqIR+WfNzrXecnSh
	lEr4uWd0YRfveg9CspiHjDjgYyRg9Ek=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4cVdFf3Vtkz501bS;
	Mon, 22 Sep 2025 17:33:10 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 58M9Vu75080767;
	Mon, 22 Sep 2025 17:31:56 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 22 Sep 2025 17:31:58 +0800 (CST)
Date: Mon, 22 Sep 2025 17:31:58 +0800 (CST)
X-Zmail-TransId: 2af968d1178e17d-217fb
X-Mailer: Zmail v1.0
Message-ID: <20250922173158997VPIUgFcs8UoazWb_JQIc9@zte.com.cn>
In-Reply-To: <aNEG5W0qLPKKflQA@tiehlicka>
References: 20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn,aNEG5W0qLPKKflQA@tiehlicka
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <mhocko@suse.com>
Cc: <akpm@linux-foundation.org>, <shakeel.butt@linux.dev>,
        <hannes@cmpxchg.org>, <roman.gushchin@linux.dev>, <david@redhat.com>,
        <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>
Subject: =?UTF-8?B?562U5aSNOiBbUEFUQ0ggbGludXgtbmV4dCB2MyAwLzZdIG1lbWNnOiBTdXBwb3J0IHBlci1tZW1jZyBLU00gbWV0cmljcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58M9Vu75080767
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 22 Sep 2025 17:33:10 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D117D6.003/4cVdFf3Vtkz501bS
X-Stat-Signature: r4hmzeuhgwkobn79bf64squzpeaah957
X-Rspamd-Queue-Id: DBDAD2000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758533597-172557
X-HE-Meta: U2FsdGVkX18WGuqh0G7P6Y0tZlPdms5jbj2qKWYy41Z4hxmLm59ohEV4pf3T90LbDcaO1n65r7rIoVUW3DlQvzPxteSdN49fmU615lX7CttvwctaKIhCOb8xYjFtStIw5/oSxT5I5DqxDZJEy+lRBuyBYkT5lpbHxRsctrQp1R8B70utSveJehs/fq0uQ5Zn3xEmzR+kZ0eU+IuwcECi0bo30rIaIfuUrzy4UCBZUjAOT8+zf3Wf01/0wbHR7LozjjWIO07N4UJS7BDXt/PHXIAHBNMJrEdPyq1n9iro+pp/PuvcA123ghnK1SYHRMewysRtLHU0+xIv4hdQROm5/TpLfmdrhanrzhvQPPjbK7lYDoAtwZWClrmk3eHDzsuYRX8WcfYd2L0AL7SNfjqelCHzInE2XRJxzWfRyoeswnBT3Y+SU/Owr0/tcFTZVum1hee62dINErAzBKdDB6nRR5OvdR2coR1hL2e6EMmi/h7Ae4UGUbh9PArFpGx/GQ63CGmqLbifMiIX9AuQoLqJkTa0Sz5Wrbb5yaXdIlZ58v6zhk0ivVr6coqi4GPKA0ObW8KmMgY0ZVEwDRYO2qrw3QdCAT4+ydhZTbaCOZMLMDXbU+ytxZgLFXlxRtgZ4DdsxBFzkByrk9sUKZ8o8Woo3dydzy5ZxjAWH+MaDCeFrcy6Kp3uL9ClUEXdEm+UsYyQZS7iZx04dmL1R4ieemidnrLLxwEKOA/+sDu9/ec0euE5LTmwMOaBDaTyOT6LPvAZJlfIShfbfruZQxszFmHlkgVMR3Z0NQsM2bUECb+UhPoiR7xpuevSmHNc9/pWinXoS7fDz4Qf6rwRcEAjcJQSnVKAi9j+QXspGHjUmTsjc4M+sNCMoPfxpSwiPfvMtuZo1qvfDKQXbcMxY5STKFxkYQyPDAWgRBeSwcN8Q6xFmki1CxxNnTXaZpdGzbURRcuNt4JVsiRPbX5/oZIclHQ
 E/0gF2dX
 m7w6KHfZedZ5CBFuLrflR++c2esfd2tAiqHG7zIB1wNq2N0sNZ09yLBeEI7zqg8JiHr3SADCMo0mDNig62dq7v8tYx3N6jxCkSKB/2WFt8Opw3TS5YkEMHSPk80pwj18FJlzgJ71EhhGfK3VWNnRHOaIIkTbMlqYSuYcHYBOro6QLfUhik4G88NldXGvppY/yB71NNfNmf+/bsX55S7uUhyDsOuapdlfCa3dWz4mpNBi2kdhf3aILyeE09cD+mTfh4aE1AzhkvOdnc8uVqSLdJzNU7PqtVw/XPJewbrm0dhPXS6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > v2->v3:
> > ------
> > Some fixes of compilation error due to missed inclusion of header or missed
> > function definition on some kernel config.
> > https://lore.kernel.org/all/202509142147.WQI0impC-lkp@intel.com/
> > https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/
> > 
> > v1->v2:
> > ------
> > According to Shakeel's suggestion, expose these metric item into memory.stat
> > instead of a new interface.
> > https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/
> > 
> > Background
> > ==========
> > 
> > With the enablement of container-level KSM (e.g., via prctl [1]), there is
> > a growing demand for container-level observability of KSM behavior. However,
> > current cgroup implementations lack support for exposing KSM-related metrics.
> 
> Could you be more specific why this is needed and what it will be used
> for?

Yes. Some Linux application developers or vendors are eager to deploy container-level
KSM feature in containers (docker, containerd or runc and so on). They have found
significant memory savings without needing to modify application source code as
before—for example, by adding prctl to enable KSM in the container’s startup
program. Processes within the container can inherit KSM attributes via fork,
allowing the entire container to have KSM enabled.  

However, in practice, not all containers benefit from KSM’s memory savings. Some
containers may have few identical pages but incur additional memory overhead due
to excessive ksm_rmap_items generation from KSM scanning. Therefore, we need to
provide a container-level KSM monitoring method, enabling users to adjust their
strategies based on actual KSM merging performance.

> -- 
> Michal Hocko
> SUSE Labs

