Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D643CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687A08E0084; Mon,  3 Nov 2025 09:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637B98E005A; Mon,  3 Nov 2025 09:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF2D8E0084; Mon,  3 Nov 2025 09:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8748E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:43:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C785D1601DA
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:43:56 +0000 (UTC)
X-FDA: 84069565272.13.7202B00
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id EDA7B180013
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:43:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YLKy0t+6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762181034; a=rsa-sha256;
	cv=none;
	b=oDQO1+BLnwqKWv2wXv/4WQ21M3IMNkPUQUCYVd1+r7cZiOVZmrSrXRj2XGf9IjIghKDUJ8
	Z/LHbrD/47HD2htyWyG1c2PytrDWZO2qG4pLHwIgvHx1+le+ee47lRlbX+FPSg7F9w0oW9
	pZc4BYWb4zSOn1hwHevM3zEG/MCaHvs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YLKy0t+6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762181034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J02W1Iw/Jfwyc8k+uXOvE16dWe+Giy8i3f3bmJQNB04=;
	b=IsQV3brv4tJrV193M+tvgUxQ6gbToGERMBo52JFCjtWg9Z2ba0Vpz4q7B/0pbYnQ1OgDfJ
	iynnH5qpIztDB+fgmnJ6q+SoZKEO/jfs5XNVtVnsTz87unpQNe479yvTyMYwZNUpQa/2vF
	7ZI+lqfJxlOFQgoP14mQH2vHK/Z5pys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762181035; x=1793717035;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J02W1Iw/Jfwyc8k+uXOvE16dWe+Giy8i3f3bmJQNB04=;
  b=YLKy0t+6dsGjU7aUkaMhoNM5RjEsocOv4v2jj26NHJqdgS9CARGhaRBr
   8a4LVCVCEfHZtKtl3D8zjN7Jqw2wYGOrTfwikRvhxck++HfR3d/hsFnhE
   SedgBMqzgOfGmLMNiZmmzBCUgMX7zwexaemEUQUI1y8aSmwG1zhSgPNNo
   ti88rXeWxkmc2NBm+YFAhQV0JRArtyfBzG9xeomc2BlP+JoOVtmh7IGEE
   +Cc88WxA2EAiUuRA4RLtrWQTL1yUh+7nZ7jjeKpsHj2lPYBNoYyLrvijt
   1Q0K/YWxFu2ivMxfkPpJSP0tB2uPM/WsP5dNo4/b1KseYzFbgK+ddw/PD
   w==;
X-CSE-ConnectionGUID: 0ex4Cf7vThSQPQA9rmJwZA==
X-CSE-MsgGUID: N2RsnLESTqyqIJK9fbcA2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="86879819"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="86879819"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 06:43:53 -0800
X-CSE-ConnectionGUID: sg2xt+/qTXexAbr7EYwjtA==
X-CSE-MsgGUID: S+XBoW6qRC2gVayyp3RQag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="186172524"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.129]) ([10.125.110.129])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 06:43:52 -0800
Message-ID: <8c6c5d0a-c5e1-4c43-b824-2e3aa6641d48@intel.com>
Date: Mon, 3 Nov 2025 06:43:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/mm: support memory-failure on 32-bits with
 SPARSEMEM
To: Xie Yuanbin <xieyuanbin1@huawei.com>, tglx@linutronix.de,
 david@redhat.com, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, luto@kernel.org, peterz@infradead.org,
 tony.luck@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, will@kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <5ace86cc-0b2d-4306-8bc1-dfc34cccef1a@redhat.com>
 <20251103132358.79766-1-xieyuanbin1@huawei.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251103132358.79766-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDA7B180013
X-Stat-Signature: jsz4wbx57bih5afj9rpiniz35nh8dpnh
X-HE-Tag: 1762181033-88966
X-HE-Meta: U2FsdGVkX18OGBOPQfJJC5kJCl95a8jcTIrRDIrojPwn6xu0V3wLlCS+aWZ1qTpKNgnYsP0YzMig+GjC1o/z6Yx8hDr1alAzUxg3XWnCGZMxChsPwOS+/8UXQlZTbUo2GhuHQPgfAsRnX5xjqmlzwxb28OAwb3Da0poUzMLn1E6OqKfCEDinGM9jk07jJ616VYhBBPAFKOa/YxU/Yx/SvZO4HIy+lfqiq6gG+Hj58X5BivHqguh3lDjbPMWUlyxIiROFZspe3V/zxg5BTLikqd4F2kATKw+RRK75P0DrHuUlB3BnoD5gQucLpj2/70fI/cRtVZjYAbJ+Lel9CZxPJqBkMWCxjF7hGLNRztqYOGVU5Lbx2s9X4OisOxt7pnk3y5hI8zxVjWfiUBYMLGwhc34r+tsvlMOlOn6MYqJ8dNiFBFrtuJ4NSCFiHGFj1GomwrAVKUy1iM6DFdyDTcD9xa3e9ap0yYRw+TI0d1UYyMM4vnqd9/NhcT+RLk4YSqTqg4hRYnqBWvGZrrqv5KOolZ+E3DhXqupEeJizVJXmnAuOGP9enayvLCnqS0Y4YVa0QF+ROBC0+gkd/omscPakHFTeQRp+6z/xl3YokH1p/vJJVWtbPFHi3NckP/dvzTuN8Ph7ZzBoJC2zWF1Ku5GfalPbDnTGljCzpYqNyuRIlwpRJso6KeYCvzvUqGLP3QryQW5pgBlncLzh6Uf1Ypc/vsl6Drgn1W/33nDLSnj5u9pnFNHl0ENXXj9QA9s/v+4UNCgL88rw+hW+KBTzyr+YyzXcS8Yp/imPa19KZRLLPB7iaCk1lDfa5TsvY+WqWfZEGChGb3v6CGSKd1OMAlk6HiJQK1YNCMmWltJhQZMlomVbRKi3sz1sfQjNIKagr+miHpAyGgCPTzonsFlI4oS2Xd8cld5keUZZyKcHfltJGROVt7XkJvm4rRCrnMuSR8M0aHpHezaJk+Q3RPAlhzw
 zKQs0pCM
 TVvVT920cZtO6pY1cy6QU5iqpw8/ItxF04tXBnNEGJ4Ny51XOV5spyuaQKwtb4/M9AwC9ue6cj+UqWrSxa0KHTMuYd2Hp9VMwlQZXYpANzgvunULU92+cMrXk002rmGoOa3wGW+64eWX2oYsOaCCXTM97g2A4WGMMPLVX1T7o/3bVIdwd7AqpijF9iZQOXTdL3AXdhIHiN8909TNn/PevDvSlqUeAWX4AUU14+1eQNuVPSSmHSRSP7dAVDnk0FnzoHlCV4LzEkVhyCDxBnjjb17cK4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/3/25 05:23, Xie Yuanbin wrote:
> I will update the V2 patch to describe it.

Please also include the logic behind why you want this change, including
a description of the hardware on which you want to use this change.

