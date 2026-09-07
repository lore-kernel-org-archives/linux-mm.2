Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52953C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 22:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E875B6B008A; Mon,  7 Sep 2026 18:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38DD6B008C; Mon,  7 Sep 2026 18:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DD66B0092; Mon,  7 Sep 2026 18:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B04D36B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:04:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C39940319
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:04:24 +0000 (UTC)
X-FDA: 85188345648.11.C56CBA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 987B8C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:04:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nc5PARS1;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788818662;
	b=L8xItwWdu7HNgRnZF545P+oMurQ3Q02im2gJpgDK0JWnaZVx5Esk3N056YOAaAAoZL7pm2
	SUYtGXohYVgeApfYuu3vxJTBEmD1/5z+MQj7Dmv2ndQNhq4kc9346A014PRunTPkFdAFkl
	gj/yPp3Cpm0hU4gANisDxedTeFFBS90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788818662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+WJThc+89xsf7gmckVEw7glfJg5iEGwGLi5Ff+8t/E=;
	b=tBnLDuzZyoEfRhezMcXOpgvVUPt35yCaN8DxW+whtRdfJXjz9y1xJQvl+TyzK4L4yZetu4
	szJmANy06iKImzckoXWI5kFxTm5fxeE1OxzUh+V12ceFiamgGsiW29kRSAjdXaYxnWpLjM
	aCVrPDonznsL4hnKmaeoIv/gHMqmPNE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nc5PARS1;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A81CF434C1;
	Mon,  7 Sep 2026 22:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20AF1F00A3A;
	Mon,  7 Sep 2026 22:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788818661;
	bh=l+WJThc+89xsf7gmckVEw7glfJg5iEGwGLi5Ff+8t/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nc5PARS1EjkluXLbShdqsC6SVqdVMZHPM9kaeoLuh5m3CjWmRVkHxfHdLpVaKDxNN
	 UCu4W0hyGTAyZCCBff5ZQ9zIeFHxCeo12h5of2dThu0uDoHA304cTIgTL2My6h+XXx
	 aj7KD51Gprs9d3ZTYyyl2qg+f5NQBNdf/k8+I+pW6+LAkl64Zuvu3A87javb/8DHJB
	 V6HgK0A5FPQyNvk2d7+1PXH0FK/mo69urZDHDW1TwQjNSlvlkT2Abj+kXV1tI9sFEi
	 0o4+fCoD/BmNZFHsFQcdeNyg9Om7HNw00pA4pI3CzLeJzA1YLJBEd/LHBuqdb8KYq7
	 6WnlRKDoR+0zQ==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove PageWriteback
Date: Mon,  7 Sep 2026 15:04:13 -0700
Message-ID: <20260907220414.89196-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 987B8C0008
X-Stat-Signature: 63n5n8axcysxn1sgaybiuzcyih4otpda
X-HE-Tag: 1788818662-476979
X-HE-Meta: U2FsdGVkX18U/r7xgkMAejKzSE4UP6wz5BqTmHT4z0v0+w5DdCnTCO55moQ0ixk4vqCO+5XNNnq1CVdMixoRncYZn1jZNTMkDxxalv8rNoBOlH6UGR5/tk+HX/GsGBTA2qxii+MTDg7Xn/JlgtS4Z0wz2tTj7enPdYif4HH/igqS5FwfNT2+hx1DP96FIm0sZOSN1CHtxKh7tS/0ZURRlre1ZQ+FK+gC6FHhckKV2gnaCr9YK3wJxU7+xmEcVkmkXc4KZ4j77+AWaWJKUD7n1xrvxaFqYpLMQO4XF0QbaL321FBcOmFfGOH3s1YFBcTNJKRdJwT+ZHppHeeav3rnDu+JmuGDRzq1/5rgfHYkV+MHCsP8fKC/ifJydMgqWsLoo1yndxqr0libDuua+s6lLwRXh2ECqfhCa7iWVKDYBnLVgBMDCWOECKVV8EB5M9i8tkNu1SHoHTv0gGcK34fKdvm8rEtSeIF8H1Bx/m3KUWm6zMj9BE/hKJHowawuuEOkcuvCDWnOx9KJMNPMihqwzy+KolLm/ubZKsj4BL4q/SDP/PKqmBNFb69sqkfoxVHQxy7CsX8xfuI2iSaDuX6/W9UmlIV7oEB9+VKGBfDLwfO/lEJgwDpNZmN9QzE5oAiz0ogeTmlD8CtMIWMzTqErMZk23IoWU3bxuIeIDycy++izokgEst2zlCfBBtABXdMSPWI3HSXRls3yGMxbWPEY07k/dZjQ238X/Dctrq+lFReb/1d2M74BL6VYdzR3IGHSWmRGBvP36U3yvrEijC+/GE7ukFT3GaK09EdG8LIJb8Szi5hKR6lVeQXPp1hkidxeZZcvF6GoyDFDQlnrfTFm0hlZZci9pwqIwy2mEk3gjRrigSnZdeR4EgG821kG2t4Vr17sZWCLccTrrNwYXsFmczE0wLKbY7NpAAn6biSXDDXlgMwPusMoxReLFYaDHstoaGOaY0mGI+slGVNlASN
 V/wtZ43Y
 R0sEOIlDxP3yGOKwbX8UMpecSUbbguvSYOz20ymNX6fjbwkCDZWdMjiU3HhRmadYBSkKAxjhIdZfEJnu2lFCBiufuIsx/JMrWiesMSTVPVPRDNRerhGO6IposzEF/DbgQEIZ7rt4UY9yPf9Vy1XQ1NgUk53aiRDkYMHs7hgqXdai2C3r7E7XO2i6+a6XQkjen6byhtal+VtAfEwz7x3bpkJb6vNs6rhv1eB3e9IvuV75K7J4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 05 Sep 2026 15:08:30 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The last caller of PageWriteback() was removed in commit f75987e543c2
> ("libceph: remove pinning assertion in ceph_msg_data_iter_next()").
> This flag is now only used on folios, so we can remove all the page
> accessors. folio_test_clear_writeback() is not used, so don't add
> FOLIO_TEST_CLEAR_FLAG() for it.

Looks good to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

