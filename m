Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BBCC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97346B0088; Wed,  8 Jul 2026 23:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20E16B008A; Wed,  8 Jul 2026 23:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E86F6B008C; Wed,  8 Jul 2026 23:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 567B66B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:18:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBA7314036E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:18:39 +0000 (UTC)
X-FDA: 84967780758.24.D37663A
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9BA8A0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:18:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="JJOuD/rD";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783567118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzrq08S63xNTVU7E8KWRcfGp4/hYHhmDRNHdz9i3UrU=;
	b=8HyxFXmhSVbypXvFh7KdWh85lD5z/orIT+6zTM/xJQSK+WwCIBplwx3SmX6w2a+IaCMsAb
	1CN/FXEmBYE0HLyltn/w6ndzfhjmLm2/gxQgoZmn0O+NN6nXltZZL31suCY4p78ezPe66J
	kcHzds8g8jCTGGqRBMOVck4F6pmXRp0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="JJOuD/rD";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783567118;
	b=Il0gXU6bGUuYphs75H80T6XjMsLUGbnVFlmgLDegz7FVZc8M3QOILb91WSQRMqmkp+hDYp
	LT3eaEuAwTL2+mTfTRCUNqaeAXhJHW0BwWRnN7t6/Xm8IU7UmxtJNnYkEQaZlR1Lhka++b
	SiEr5ynC+Wn6Av9eslPR/QnpqvI4G3I=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hzrq08S63xNTVU7E8KWRcfGp4/hYHhmDRNHdz9i3UrU=;
	b=JJOuD/rDeHv2AAUyFTLf3x7iXUtLjFXZYvkTy6Ywb3hltv2TeHbFvQCZpFa+2vvcGpbd8WhCL
	PGTPywS8IWiUjQHUVPghi3lN4ht0fTpo9Npjihv8XxcU0cuzkzf9+OSoQSDXn4+7YZ9muDOimX+
	VrJZppqxd2vVRFG0wLRMb5M=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gwg0t5twpzRhv6;
	Thu,  9 Jul 2026 11:09:18 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DD554057A;
	Thu,  9 Jul 2026 11:18:32 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 11:18:31 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 11:18:30 +0800
Subject: Re: [PATCH v10 5/6] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
	<lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-5-c6ed5b62eea2@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <30215c3f-c063-e7ca-1499-3d61e359ef80@huawei.com>
Date: Thu, 9 Jul 2026 11:18:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260630-ecc_panic-v10-5-c6ed5b62eea2@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: A9BA8A0003
X-Stat-Signature: w1rz49r4dda5f8g9pmwkrwuriowupju5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783567116-101151
X-HE-Meta: U2FsdGVkX1/uGRuamj8wGQJmQVyg50ZEBhp8WZ+zsedRjQ6IvI5m6Kb+fcMqmNsk7WLRpq0f9dfR+nvJaha/fzuuCFrSXE1dSGDtNxUhg8LW/yEzgDpWWxNi/TAIJ2P7K8TCBggoD6ZrUDKjUIpXIAlSRq3IJUm/LdNSJvEJ+9zCrvBnw1OwdSDivkbWcQDMk1aWccNi2nRIoVtJXD4jKoHRimOmz1bZp7V2WQZxgldfxKXRPg41hMk56KF1JdwFpemj3RFK2s2HCord0couH+A9Gqf8l6a71vNy/KKqbCzukrN7wkCsU2fDdYkparLBXG/xXAsIAP/WIIKSpz9coSahdW75HvzyW77XH4MUAEzJOaG6IICFK2ipavQonD+2eb+tEAH5jd64PDCK7KIdMDMs71cMWyU3Z6hWJK1qgoG6Y9BSbpzsFxBDgQVfkP7elDlVID46gRn+IZUWvfAKTOmsjNbgga+v9bpSyOW+GHq1CtK0iQ36CwjdMaSGtsMLKrkXEb5uvl4Hg8WVoH3KarfyZAB2Vwj/9lCqVVqUd64BwYW1Xe3Drqq4AexW7viY5b693lLQ2VEcGeU7YK30iWLTIf18hZK3Y8Kl9tSAr3pypa2g1RUMFfGETTIAcxsP5dCJEL7vKEbXcz4JF2U278yprVoiMLMqkbFmV7krKpjlEPxvfnZ5ttdXIOodr+WPqMveaCcK9wL948EYvQ7X/AG9HlSn7qcqfzM164tV2SbSfaaVEJbA8JzTBHZVazmo5jonkhqgJby7e8JOpKQHOnoVXpTGARq92058OknTVG/nai45etmXolucS5oHIoMerXgV7Jfls54+CJziW3Tk+ZCVY6DWn5w7okNW6EbpkrFwN0u0ufkxVYjM7UVlVEqhxLew+6tSrJeMEQusD5OUWQJAA33HGu3EYYCLDweXdcPuhu+oRgQY9cEmEWUPLbJstDTIDhy2BgcVTbJQOsT
 2l/OKsop
 +PKLf7kK2ZXl2YbjMj16E1AnQWXKyQ6b/27mCR7kcXXbT2TKE1mLnG1UXKf/lXeEwU1QfCqjZ+2vmeIo1U72GTLj/Hqe0fWiN4vj0PwDKm7jhQ7DwiPq+o6YjYLY1+QAR/iq+UxU4saFD09yaQg/3QZcZN38kQ5HYyfno9ffwI25OkddAgTpgJUgwkF2rx96ce37Y9DGY2lclABuWRYd3dfDoCxCVhs/1VT/toxRcOU453CqsnFjUcfYCnV2gE798Y6Ik/hfXPQyH4vMlNPxiaP4kE5YAvO16MlLvfDD1puINpAIZNiJXWKC+GmemA14qUtMySIpd/CMIv9W4a8R1FOyiEy/kvk5/cbIpXzbuE9i3vTR4WyyfoJs9AOXB2qrmlHpudXh6Hci9DysCht1GabfWhcvLZW6eNoyZBOshy9t5yDtI8DyrpB46G1J1NcpuRQKY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/30 20:46, Breno Leitao wrote:
> Add documentation for the new vm.panic_on_unrecoverable_memory_failure
> sysctl, describing which failures trigger a panic (kernel-owned pages
> the handler cannot recover) and which are intentionally left out
> (transient allocator races and unclassified pages).
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

