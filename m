Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECF0CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15B96B0088; Mon, 28 Sep 2026 20:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0116B008A; Mon, 28 Sep 2026 20:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D696C6B008C; Mon, 28 Sep 2026 20:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD2936B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:20:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E88E140261
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:20:31 +0000 (UTC)
X-FDA: 85264893462.19.E574A9D
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40E0240009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:20:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1a+HAsZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790641229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JB+Tmj3rI7ONx/tLDWlB6lOOPKvo5RIyeaTTXknKqpc=;
	b=hUM9asv4A5D+8px2JEb2Yial65ncGFnpwVyrUrXrmnsK2xsBqL5SDXwNLdiMdwLIuuFITj
	ssHOtS6kCLE1arNG5oCNfyYm5yzJRgQ4lG31Nhzm71pQVB+sKXWUa/H6mIAxhwVQKt1AES
	7k7IKQf5MwhAR5zOM5CwfE/X3LkRPXU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1a+HAsZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790641229;
	b=P9PiMXhn6xwQ0hL4za3jMoWqB2uNhMsU1hHKxV27qXseRRWB/n1GpGmX+kY8Oq1ILR/xZ3
	DO22n3KUk3FyyGkDGC41KaJpLbXRwramMJFMR38eBP4EIiNyUhOmww4rOFP96PWVxD1IWr
	FKSy4o4SAFOlhBv/my/NCRvrw904rBU=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a494638445so393440a91.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790641228; x=1791246028; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JB+Tmj3rI7ONx/tLDWlB6lOOPKvo5RIyeaTTXknKqpc=;
        b=B1a+HAsZlUDISo3cvjmlB6cc9o5wRLYelsHyMiLQv49TMJNtWlZFtC5zXOdp6J/ZI8
         mtFCdPq5IAHGJBL26sR4wiq80Ou1bwEkr3jjyFLYhBiJlFec2tHYJs24uw2pzwFk1z6W
         XlIoKFzUI60fK3kINH+qPdThBnPWspVp5k07fJmszciNi0xsHc3kX+L3OKTK8IGWD5J9
         73O0Z7b01i7wneyQUP76LKaRgWFMkO0l5AUUSqO+Xje6PC8Th1lEaRK1PmL0iERMdLVI
         VsECB2//E7G57vieBaz61xZbBd4tOVQE95Cud7cgFCsisp4vFAYDQlycViXUpzLZkyvP
         DBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790641228; x=1791246028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JB+Tmj3rI7ONx/tLDWlB6lOOPKvo5RIyeaTTXknKqpc=;
        b=if4Yn3CVHIDceqDOkQA3E5amCqpSqjc3Cqdc8VihXUaHC2O3AfagCqAi/Kp7yztKaw
         xKJbOun/w6ptqreCYEIJoGjVKpQXjzDoGtBgOeiXCocxPSQzezDe8qOKMpdV8/fZe/KQ
         s800d90sbWJp7pdNftjCJL/aRiJIWP7yVMknw2QXLAv2W4RiUe6WzpnmnUfxW6WZL3Xa
         3EoI8t+oS8ShyTQQYMXof9K/md+WAlX2iMsVAN5E8rs+MtBaG2r7uH7rtLGyo8ditpBN
         m7mocYlBNKW6ei17jCfuPXwI8BLAn3SsjkbGN3jg+PAG8UuI9URHshYJ5Ij/kho6xN9J
         /JKg==
X-Forwarded-Encrypted: i=1; AKwUvBy0XdCnjWwoidk9aY+WQJHlNYovPFf600d/Zo5gKscdgfRptI5A5ypjW37USk+4Nq+xV0WHas7XZA==@kvack.org
X-Gm-Message-State: AFq9FYIhYIS3Zmd463raWVYlpJQPm4YdoqO39kp4a4uZD0fsggqZHYbk
	nK4LBzuEMvO2oFIDnJQo0CtPMNmb7D9rUwQ6K8k/aWsx/D7G9O5L1tg=
X-Gm-Gg: AYBFou1v7A6fQPWfCBnClmQGOATtkAbBmBnkURnSe8BkBad1t0+PSLnW43zFK0IZ5nI
	t5uFCv3q11aJvvMk/GGILVgg75BAPsBlXvLFqec4XxywGS6CK/miiRV1w2zEss3rYUo3Zr4T61f
	flXlqW7eqDp9Ys5SIeUlZAmN2AstediMHCb5XzlcI5/HPN69QVGtHYXBN0MR9eMw51lwCMBTTh4
	7Cl8AqfAg8WARZBKQlZa7rhNCGjWEI+hHCOsF/xZT+YySUBi9C0edy7aoyJlZBq4M5+0tGcM8A3
	tcgT/1upqGfQTCKSuHIIaxue1aClX50w+jRByUrTtJhiEb03njPP67H/esFAsZErYU/QrgfXuXy
	j4QpQiXxK+cbxhNIZ5npxWjIX3+9E6Yo9+/qMeq9Vwsz7FTACT2nUbQImDIfLeWNMBAnUC0Gua8
	tYJv64raJVXXaO5UYpSf2NTmEJnj1lrmgznBiRmqaktLDHz0NUn618r7PSD8FQpm7PlNPww2D/l
	ZMoPDTXPTikRrh7PkmLfHPvYMA7eq9N3XKZcA==
X-Received: by 2002:a17:90b:4d09:b0:3a0:c85a:e602 with SMTP id 98e67ed59e1d1-3a0c85aeba7mr6091841a91.9.1790641228008;
        Mon, 28 Sep 2026 17:20:28 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:712c:b4ae:f935:9398:3170:36f6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a497718037sm2047605a91.0.2026.09.28.17.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 17:20:27 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v3 2/2] selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry
Date: Tue, 29 Sep 2026 09:20:19 +0900
Message-ID: <20260929002019.1847080-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cc123233-5b48-4069-8f84-f95301a83dcf@kernel.org>
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com> <20260926124145.2878520-3-donggeunyoo.kernel@gmail.com> <cc123233-5b48-4069-8f84-f95301a83dcf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8gbpp7iei98e653s4dsaxcdjj3wq3rns
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40E0240009
X-HE-Tag: 1790641229-912402
X-HE-Meta: U2FsdGVkX1/FQWxb5f9FUy/Hci72jR+Az+RqDUU+4Sq3CrqC6LaQpMl0TpzH5aJ15m1EJnEHIJ0EgCk8H1XdBvVaXPEfyT60ngKjgzqMYD5YcycAlAbKsxP7T8YXJK5RFWyJhIH7PTbzDvBiOF4Kov3+6HyeAEz17YeUux2V5fQAlOk2x0uDvxEgC3CMzAgOHkR7ALvCHG289gvfCSfmahlME/pF9oAJnCTVTZXqiuINr/E56BQXtJvR46CvGKkkyaPSslmnNFkWR2qM8704Dc/koeqmWebdo1bUwhZpZ7n9iEla+7wBwLDpAZXl0ZYCtr2PALI0BxtOn7xN5Yh+bZpl7n8X+PNHmQFQRoUR/pxZ2N/awvbT7VPGbeZ6PRoQgTgCQT7Qz2gkVvlgSLIrOG2jWRni4HV+mTllnDDbzPU876tp+LneFU8pcTCLO6Wg4Gd1toSuWYvuw3L1sLdy6toVyhRu1GcThXhdt8EMZXIpkZJOzNOjIw2i5POV5tFgDeg7IO3NFfOxtO9wwQtn0A3hu5le9+6lqcvwrfafloC8yWxGjO6uqDTyMVLs3/s5zNMXCKhEyYEyduGhGVhfCIV7COEroufUeuW9Hq24qkTjVk/Cb5C7nWqdaO2lhvDcswl8Nzzwlg8EHX9+ztmf78c/4PpPevKlgE7zFL1/RHIT9vsd2v2eBgk5rZ+coRlH19yvlvlG9aRYreaJGrIkUvkLjz1Q+4NhOZc7JkESxSSEJSGz8EB/SS5osOE9e6zh2k4J7HZwQ74S5jrBp3OK0WEV4QNAaoPr4XrQsFSKHKcmxj2dRlhPLv2hMqx5UXrVzcFCm1Q/tztWZMy3iYVDtEQ0rCLgQClRFwO8h8ED+L4JbroDP6Yzu1qm06k+xDkPl1zYD+lmHnqYj3p21OF3MWBG9cma6WRrExKPWf2AkE2NTXzDzdlYT8e71A/heCOdRROZuoQqKEZNJRRl/Ta
 tWPYA8sN
 1xwTJ7ReYd3v5DPcPLnml2VpfOGIIbdxM2BHv/UF6MbgkizmUgEVPv6USqkhfcUKD0t58jsEE+FqVVlAOLmwqivJ//tzIydiH3xtQtyn8sgH3N4aFoPIKHqzoYqzoGftXBLb2PFUA3MF6JxQ/Ps6N1IsmT7Y2/AbUravt+yWeYzErmhlB1oYXzMsbXAnWEcU15LAOIY/EX+E/a6IQlxznUd/V/2NacYZ+XijLsBau4jcan2OdRTxtEKxdqPv7d7yVClEBuBOiupXGObgNgiw0gSPNKIsedixi7VR1AE2ki3CWQfTQb49ybJDBKIWF/4wN8v/b5K++XG0jBg/ZZHPCl26u4qyVmXZlYgaVtZj5G1bYSg3lNM4B43vy2bpWMJvph4NaJ1DIhIPRkCzDNxVDItxBhlS9YPPAw41aE6M6Adn9dGcT2wKuYTwsvbJaZDWs7dJ9ri8IoGWVCz529xmT1EoXek4iIJZr0preTetRJHttZKQT/4LFt2BsJ8zzOVgEh0yeLy/p2CvLO9NYLEVgIbKe/zcl5QdaHibJ16bkPlbYDzkhUC0HEHQUrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 11:11:50 +0200, David Hildenbrand (Arm) wrote:
> Why not combine it with the protection?

Will do.

> Why not do that at the very top?

Will do.

> You can set that all already when initializing aboce

Will do.

> BTW, why do we fail the entire test here instead of only this test case?

I did that because the test is about the bit after the move, not the move
itself, so a failing move is closer to a setup failure. I thought it was
better to stop there and let whoever runs it check their environment
before running the rest.

But having gone through the file's history, I see the direction has been
to skip or fail just that one test and keep the rest running. I'll change
it in v4.

Thanks for the review!

Donggeun

