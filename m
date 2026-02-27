Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3742FFEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2396B00EF; Fri, 27 Feb 2026 15:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992326B00F1; Fri, 27 Feb 2026 15:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A24B6B00F4; Fri, 27 Feb 2026 15:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9F16B00EF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:47:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B2BD8C6F4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:47:09 +0000 (UTC)
X-FDA: 84491421378.10.F45BA7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2979710000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:47:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U38+DtAZ;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8fouIILW+kOEqFcPLc+dtAweW93xa3dq7gDjLmsLyY=;
	b=7RIGkuIPj9deeJbB4RZ583YfT26quPDq91EQLiRPtoysR3Kd/DD22yGqEJsGiEli8rld8H
	3FPxGNcoUB4FwgbSw+XPuA7938uf+9yxaiEet5r/YsZuGGwOlS3MYl6/rvLEF966Fx6DkO
	ui6Pp84Vm59UXaMiugtXtPJf1Qb67Ec=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U38+DtAZ;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225227; a=rsa-sha256;
	cv=none;
	b=K0g1r+C0MqJ/QljSlTdInOjS/MP3Rc5vFAfoX79lfQNNEjR7wtmgNpwhqFI3KnoIhOh6F+
	WT7vYJHmXrjG+v5BapPe0hBCpMsqsWYiFlblQCi3fVS787qSZHFHmwb1lxRPUu0wOAxC9X
	AJjZogPTvACwyqbaLAUVzGh4MCbS5/0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB3BA43BFE;
	Fri, 27 Feb 2026 20:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC35C116C6;
	Fri, 27 Feb 2026 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225225;
	bh=KiEZ634NcmDBBGpW41mXdUQd6VZVLW3WgbPtT1aB5vA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U38+DtAZ4hheFkQsR6IvNxjwmIfGdSAJaWFMvwxrN5fKMOMBZi2Ydie+hnBGhh4Mw
	 8Xps7pf/AWsCptlgvUpq2SdpnqsIXFC/Kvatgefm1fAl1yT1BKaQx5BAmIZ8UtFJdA
	 tWP9G1+eUo+BTLxQraiXUjxYIh+MKWztJCd3Vh1uhuGiurXAZLpLVvsciXYphvo0Vy
	 v9LOZa/XL9T7cXWFIyOUscgKZ71W4CfVIfkOyc5d5n2N8v1maxc3MlpePoFn7OmGD0
	 C0ZLjb2gegz0VJYgzXX+zxlW7QFhXQu53U6T8h65al4jazzZ3GIQajhxJGkYG/ryST
	 CKsDDCG3Sx15A==
Message-ID: <3e406be3-3317-4385-a5b8-e2aa1481bde5@kernel.org>
Date: Fri, 27 Feb 2026 21:46:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] virtio_balloon: set default page reporting order
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org
Cc: mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-3-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227140655.360696-3-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2979710000A
X-Stat-Signature: wbr9fwk18prncqxnz5xc5azkfw4wrye6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772225226-335197
X-HE-Meta: U2FsdGVkX19ZFCPwZq8LVkiTqnnxffWmlUEEV0bs2z4GkgdUnUNE5Fsc7dcR3brrzUkYP//f2B/pB2K+UM0wJvRhNXXx/dYAOds7H4wMkuWBs1k/d/KzSy+5vWpimnMYxKj0ghFJhjjWYB58hdyLsY48LhOyb8DO/pThe23KVlYf76t/fmEKs6E9qyzlD9rhvf1mZDCUwXBMXyGOAOQRQ82hsPYLeIW2V8rxQktMpaX/T5I1K2fpBzakf/FskeNJADEWXBjllXETBDNh9v8gHSyHtQ6Z1Wi/xPrYYSV6XT90Uad3VMSXSG4cdRcIcCG6TIRLABbwYMjtcim/h/mpNiARwuLPxQvJaRX3C/mws5XhGQAS5wZvbAOkY9Tdo747a4MpLBTU8mKjCB388UsBUIOUvPJjKBFvHSu+lt98hTnzWwckvsISmFIrr/a+ewDlho3at899lUkU1drvz5RtbfTSbLbzfUkl/MZzliIkWrCWV7RMaambkX1VHBSTdoPpKrEvLYOdfhRckG72CcwTRzkde/3VZCCwRygiIA+0yu+YMa1BRlnWzRlzy9WhQ3E05D90KSG98C6rpJJYJqJsV+xEXsnHduNx+GvwjhQUWAi5zwssqeSMD3S354aL7exHOaHZxNdNWWjSw8yQALsXFQ9sE6Vdy2jqKXxmzvofsO4rJuD1xv6buarDRIB4JnaYcIRFpULDGSwz4VDjnb7lSp+Hn7atOf24fMU5zGsBVP7cxKuFRPv7Ve0saEsRByMmoQXAYmk6iPqalPDljz0OKmqebPRsL56Jgq2EQdnnhOivo7O8WPVgNAvlinzCV82437nG/q43ecwe0lKYF+x11ep0hjKOYzFCD6/zyAgA6V3l/Jm0DNJJE3pOAyHW4Pnai0lqj5nx6uOISLK8wBlEQO5qNVlhmslxFuEywSFVuyePXUXWkuUISPQFdh72SQYOkPBLLA6SabIjnORalnr
 cJPVYZbd
 jut16WVLwlkzC9DjaWfpbhREE41GJl/aO/klp8ufLmiL0snJSOUITYuXPYD/I+wUFG423vplUbpFykIpuh3wIupsqiWFhpMJRVr5+2mMa4FrKK18DbgIgBfShscMIoyidxIVbh3fm/GJiCcosKmunRqqc9+IA0DyJUdLH2sfHxPPh89e31zAUsmi5AkHr+m1rYCpgAfGmMQIsYEFfu9Ez2N113IGFp4BxEYP8HnnOtF4Jua3Z2gKozGYpRO8KonYhu0Z7oRoAK2HLTvbfIxYiLQNXe45HQTQA+29iA/y3bGgt2lHKyYxmFmMJug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 15:06, Yuvraj Sakshith wrote:
> virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly
> as vb->prdev.order is never initialised and is auto-set to zero.
> 
> Explicitly mention usage of default page order by making use of
> PAGE_REPORTING_DEFAULT ORDER fallback value.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

