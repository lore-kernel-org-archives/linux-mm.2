Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4D2606A334
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ed7M+ndB
Received: by kanga.kvack.org (Postfix)
	id 9896D6B05B0; Mon, 23 Nov 2026 08:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939E66B05B1; Mon, 23 Nov 2026 08:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850386B05D1; Mon, 23 Nov 2026 08:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 657D26B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:59:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEE8FA090F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:59:15 +0000 (UTC)
X-FDA: 85466540670.12.EE38A2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02313160005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:59:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ed7M+ndB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795442354;
	b=oGdaQWclR3k418haP0/kwQ655JXdSe+ZesbowREvokfdPDKCFu0T26KBv4r/hP92+n+UMO
	9OCjFkZZcqoPeMvJa7/sFwDgZCPliajN0M/BMLJgcXRnsliRfMalw1FYRs+LiW/+dae2lK
	1EeM/5PSPxTlniTJbnw5wOykCmWJ5Tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795442354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIppZ5VSu1Vdxs+kZ2hQDu5Utw55NAcCNL9PonbNlV8=;
	b=8LlHs6tBVpqXM2iNkeoV+OBURXFLMFjpkwrNafX43rJGGQkYGZk0oApdFtyjGscYxBnKMf
	zfvxgkw6DbaQRXQAA47Iyoba7Yqf+J0P4T84sW8wYcVczG/0k7QCK4npKd1yKahRkly0+v
	N5BvKIEVKKHwMHpoo2yMtpkZbP7jb8k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ed7M+ndB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795442353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIppZ5VSu1Vdxs+kZ2hQDu5Utw55NAcCNL9PonbNlV8=;
	b=ed7M+ndBtWGxHpoPxB68ujeSxoSK//kE5J1mtmcwWK66+O8taKlHEzkADQZL4P97Od2b/l
	2BT5ZA/vhrLZnHXW04LK2T11EJlgtxZivEfIKEddtqqFM9cVlBdjOlfSp9BbAujI2QM6Pl
	qodcQNasu7rDSJQk29MjE/TI85hD+uM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-hGGQHv-jN2WZbHXAb5GYWw-1; Mon,
 23 Nov 2026 13:59:08 +0000
X-MC-Unique: hGGQHv-jN2WZbHXAb5GYWw-1
X-Mimecast-MFC-AGG-ID: hGGQHv-jN2WZbHXAb5GYWw_1795442347
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20F801955BDD;
	Mon, 23 Nov 2026 13:59:06 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8149B18011E2;
	Mon, 23 Nov 2026 13:59:03 +0000 (UTC)
Date: Mon, 23 Nov 2026 08:59:01 -0500
From: Brian Foster <bfoster@redhat.com>
To: Ding Feng <dingf3ng@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
Message-ID: <awRGpWDa9jAGYy4d@bfoster>
References: <7cc5ca1f-fbeb-422f-bc05-55b3f6b6db20@kernel.org>
 <20261121152706.34523-1-dingf3ng@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261121152706.34523-1-dingf3ng@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CW69IcjShbeJ9Fg6map8DcJu9FNZZ1jw6lrd8p9DQBg_1795442347
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 02313160005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ss8fafrd8u9mt1i611hwnpgku9xpdo8h
X-Rspam-User:
X-HE-Tag: 1795442353-73686
X-HE-Meta: U2FsdGVkX1+pPs+HPghyLDrL9NJa0EYcSTdbmJaqv1vpEhq7utkqy74333GCv5tE6faAgm1Dgp7w0bZc6BMXyztcWA3avN/NdAAoVFegZyAvlbesikwK8RRYzj4ePguzA2/Pprfi7hW9NJdp7cT8DW9cAwVp3AvlLj9Um4nHkAE/ZhnU3EPklG7KqUvCfCch/jXBNSvvOxsUo5nQ/dhiouAd/JQYLygDwQ7cAgZPoezDM0ZhUtqVVnW1PdaV3kFmQl0JXW8Swjij1Vwksi0G1oCJl81DMxFYjLPyMKeuA5Gw1+TIzr159ti8oiQRA5LW92yUk1NTl+MbBlENj+IzDkAglxvIcCWBzdeBpcnQ5wlukNI8WjZHykatcWyWQlats3FbFNLkuwyP663Q48chqcwHl4VcYWCXylAB3r3w7IPJDb6rVKOwUER30uZV53pkRfCrgshx7qjdYtrGNpzB4Y+fswxD+dPsaN+xTWk9KDXh82ROIintKJv6glnx6+yE+zVgcpVpGyjbZeog0+OEfItArNl/H8QwA/YGdPxq0D2raGrXegbH8NxbQ52uCI8OrhInxYTg+vHkk7qAD9n6X//42Dk+cOqURfh4TMKS63vRA6Lh+3H6zG7zrXf3GeFlvoXVO4/XcohMziWIpBt3uRcWj9FauH6JLPGOhFUa0OVIXJaP1t1XTLlXsmsYDKLYh2OemyAyug47Bts5uGPmcI1x0ZJcVnG1REX3ghXpx7CUJdegdh4lW7W4iv4HKa5CVR5Iw2MjO9FvuI6m2aGEPVO/YLLeP0Snz+vpbojYP6zcXZbl6xR5ABmJETicI0ttRR9z+SuA+1GmXpusY4X1I2sMOtiRWN0JFrRZ3pJK2XfIFDNyVo94//FrbdZ7Wfz6gO5KOyvT/E6nR99CWRLeoUOExe0sfaWp3lefaOHNcuzxxG5rp2YTF9X+OgIpvic8aQNjaYNFppym53GEayU
 8N+GlVjB
 OF9lOhjJut8JH8QjTQ6ev3yK7UIG0dZsz8WIBgu2GB6gRiDwrwaMpjRJZ7qUK35nEQtQT09UmQLmiGbE9e78MLF+ERkTGSTg+Dnt8CEyQ8U8xctvBD5eTVqdr+OvH0iunXVa/8X//WN+IKe9hWhLqic6EO3CmajIfV29/s92Q10y7BpYtY4DFDf6bHeGBX7FCzqzUoDuA8MZ+S62jGjrfs5x0xYxHzGJ7PyrooEwqcnfXncOJx3YCgMgbn3DPy8rsWd8Y/19OFNLE4rPp7ka7X+QYbn6JSbftgGa60XGGNvochYh8VkC1usoO2Tmme+zhgSJ6QE9I8lKFi0lceXY0dYPlYHuCUYaCXRm/H0Q5d10a9oLpUR9I4Wl5RsMDh1BKgeMRh/okMRwlXT/tBVHcavGkVjStVmKmax9b1JEW9Trms1LPJzvYqR4nIcsIYoA47SWvWkFnDdFB7QsC9Cp+0W/ME+nFZgfwz8vqSTDvcEhlgbKWofCmwdhR8G/lnAotByd8Uz8QXnRK9eOR1O5kcBr1MZm5yJ+4MJO9d9tm96IPg/ljrFIr3Dd7sgbz47d7b7b74PzAWTFB067rk3kzwkqYpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 11:27:06PM +0800, Ding Feng wrote:
> Hi David,
> 
> Understood, thanks.
> 
> Brian, do you plan to revive this? If not, I can rebase it onto
> current mainline and resend it as v4 with your authorship kept. Is
> there anything from the v3 review that still needs to be addressed?
> 

Hi,

Thanks for looking at and testing this! This was still on my radar as
well, but just hasn't been high enough priority to get back to quite yet
unfortunately. I was hoping to get back to it some day, but if you have
time and interest please go for it..

I don't recall any outstanding work from the last post. I think Hugh's
response is probably the latest (i.e. he was digesting and framing
further feedback). Otherwise I think the latest post passed all my
testing at that time, though I do have some notes on an i_size vs. swap
issue that I documented as unrelated, and otherwise don't recall details
of.

Note that we did add a little test to cover this in xfstests:
generic/363. That runs the internal fsx tool in a mode that
intentionally pollutes post-eof folio ranges and detects unexpected
non-zero ranges being mapped within eof. You should be able run
generic/363 or fsx directly on top of tmpfs to test (along with your
direct testing of course). I also found it useful to run this test under
various conditions: huge=always, artificially low mem environment to
generate swap activity, etc.

I'll try to at least make a pass at the last version I had posted to try
and page back in any details and help with review if I can..

Brian

> Thanks,
> Ding Feng
> 


