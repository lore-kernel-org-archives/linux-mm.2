Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFE1CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 12:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C936B008A; Sun,  4 Oct 2026 08:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD936B008C; Sun,  4 Oct 2026 08:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2DE6B0092; Sun,  4 Oct 2026 08:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEAB56B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:39:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11D2B16099A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 12:39:44 +0000 (UTC)
X-FDA: 85284900288.09.227C391
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE43B20008
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 12:39:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nRcqtA1u;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791117582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBWmqnMZ2eh2SNXsdMgayJ5cgB3d0+mfuddwasHosY4=;
	b=TFRXYsjbWZg8kwcoJoTuFQTQ5djp1ua+rCqtwOvpKu/vKHinJt5AjUiBxOkhliHZvaHxtt
	zbclYruE0LFiFYUedtnmSMD0ytO0WzrREvLMTRIP//WWZycxYKpb7qIxJLzAII9eiR6vzp
	B1zmFa1bsioCep5UH123mjumhSsy8xc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791117582;
	b=T1HXQaDpSvZ6gpCWxY7d/04XxA23WkyZ22OrLEa/2AwVZjkBVHHJnfwD5m4ljzUsnYUreL
	rxuepkFGl84eHnox3hiYyZ4XHtrt0M6/CoSA2jueGY+LdPQoB5gRY5D4j2a0kkfZIdKvpc
	vBK7zrZ6JJhbCLDDHREckeBbGLClBkg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nRcqtA1u;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GjG9IXEV3KJ1cynJiT/y41reNwnp88Iy9TKL1JQcBbc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791117578; v=1; x=1791722378;
 b=nRcqtA1uW8d1T+SF0YOBZE1HWCyO4M9CBEtw8Uo87/jFFsvmu7HrkMzQLfKtGsBKnYRf0HsJ
 LER+fVq/+KeY8i/xTBHRsxUS/NcpUAGsBEoIWcj5MkxIbzv2dJB2aCJps8qiAMvT/1G2lgB25dS
 V9W0ZvQ0JPsNnzIPCMXKljCg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e71eaeadc4a5a23e;
	Sun, 04 Oct 2026 12:39:38 +0000
X-Mizu-Trace-ID: e71eaeadc4a5a23e
X-Migadu-Flow: FLOW_OUT
Message-ID: <0b188796-502f-4d1d-8b57-08e6540531ef@linux.dev>
Date: Sun, 4 Oct 2026 13:39:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/30] mm: PMD-level swap entries for anonymous THPs
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20261002095503.3585565-1-usama.arif@linux.dev>
 <ebc72eb7-daf3-45be-8994-b51e5e301b56@kernel.org>
 <D596001F-875E-4061-8124-68B0DB34CF19@nvidia.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <D596001F-875E-4061-8124-68B0DB34CF19@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE43B20008
X-Stat-Signature: z735uwi5ozdwnontx93myotjqo5rz4n5
X-HE-Tag: 1791117581-319107
X-HE-Meta: U2FsdGVkX1+euJO3Q/p/KuUeY8cmTj+rQYQ05zayrrZ3OCmmE+fGn6NtApankFjQLhe/yvQ1KkV37Hk+s+hwtDXhGFLMsBOwrMsvDw2tc4oC4qCvfu3BWlSnKyY3OSaaV+7inds/Z9U4CiTKTDmE6wQK85jOgnFPMEbupJ4DuWmhcnDQrV/OT1gKMyRzOWExXrKBEMM7mZTKMxvnCU3i3TR826Hscg8FsSdrTUi2mWJEtDfl2xY8/FikwNIYFnGY85fjZlSfm9+u0pHShfvcSFrSkCPptp5nBMcR/psK6Vs6yZiKlUIMjfoBiP7XJ8zrfeO6GTEojewZCQsI3ToLsYhOQpZMCm+nNlTipaRRj2Glt4wCzTrtUaxUSwVKdxfWd4kCwEklyyGECB/a7NrLTe6ehj8LoxkQ7a46asB/mRfoTCBC2xc8pJnomTUo2UtEkdXYlnM7W7MHcur8+E5La7xQIJ5glQKhyUiFqJFNaF8upf4B1zFY/q2NI1USD7ovPKh5iNLMfggNjM9aMPzGCNjr/Gjt8bH95B2tMfeYOlB7m/pk3n2d0grUjXQgccS+0bbQwLKGoUTJVL6TMHOVO1Vkb6TqPSgp4yp4yJOERqZF4NUm1y3vUtsZjynUU2kmrVYxHOMKyFxi6+FfdqOeAtv1IvhJOhCuc7G9322LGE8nvMfWgNex2cB5pMrRKfQml/wKaacefUM2fDpe43YMNRiMD8XN2/WxuAGxi5G68bd6OpBMtBs5hAu0aSB/Chb224bKXJx5PZMABfgY/3gVkB+aGlUmEQkrBtidix8iTwFlTfYfYYBQPc8YrwZelavY1puDMTG0YaR7ZI34KsTmSxMrcss18pdIyMb7fugy+jen3Q5DUX6k+yxuhR0o9OvnZXgH36vnLYAgTvzYFgdlp3uznn136znnjYJZ4fWbmhh6f4EonBS4vtaMuCPUGbCt4qkl7TPYlVbcLgK1p6i
 jFcNmOaG
 ZpaGb99cLly89nZg4OoVjzHH5MmK8hox2z/f8Y70uYX0d6Ebq3O7s952Us2Z4xhP3urQd8U1t496ZuONhXfHHnKNv4nrq85griqw7suljN7qdrhT9hSnsUYDqVHH3bXKiUSRMYqlMosQXjtwdqrPYztQnsrjG9sMtSDUi4ewtgaHUIvPE8XZGITLDm/4oARWr5LMl5u/COumss4wB79pLNppLBp4jdvC9gHoo7wgYVp1TbyFeh0upaZfa2PWVRs9kf0DFo/T1bolVZalJQUjyKPU9mL1MduQw+3ji4+m3ISFgIQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> I was hoping that we could get this into the next merge window, but as we are
>> approach rc6 and I didn't even manage to review all patches (shame on me), I
>> assume this would be a quite fit.
>>
>> So I assume this series is one of the things that we'll try to get in shape over
>> the next merge window to queue it early after rc1.

No worries! Really do appreciate all the reviews and the feedback! I will need to
learn your magic of reviewing so many different ongoing series at the same time.

> 
> I am going to review this series, since I have done with Lorenzo’s VM_SPECIAL one.

Thanks Zi!

> 
> 
> Best Regards,
> Yan, Zi


