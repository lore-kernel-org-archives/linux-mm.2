Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A48CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EE76B0005; Wed, 20 May 2026 01:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF096B0088; Wed, 20 May 2026 01:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5D36B008A; Wed, 20 May 2026 01:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE126B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:43:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48EEA1C04E8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:43:02 +0000 (UTC)
X-FDA: 84786704604.19.5886692
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 462DA140009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:43:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lQrZNrGc;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/p0aykl0rOg/tr3JDR5GW/c2782npkazgwq4hJABg0=;
	b=MpYbZv9osijlPgeRIiURHUYTod8tK5DueVrf9gW3mRjtUxTt53368OPSkVXTUuFp3P9dIS
	qcglObul5wI5gbmbCrP1UwDzuQfgAPksTt7HAoBL2f/T8760PAAV9IleIoX3AQrhIkPhLP
	QC2h90qZwMPGs17nWX4F0yg67B3PM+E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lQrZNrGc;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255780; a=rsa-sha256;
	cv=none;
	b=21f0a2MMXKx4M1+EWAMj4l4zdoF+9JVEx3EdLkB4ZetkuNxgtanOpLAfJeDqkLz3LfoDIJ
	/mKfLIDmH/x+2N3GB30YuKcyf3rozIVGkeyiqpZXvnLZ6Eowqig+pELqirl8ozrh1QNJj4
	fZplciA4/96rgd4uoM+yuRo8UlU0Zo4=
Message-ID: <7ef494ec-9080-43e0-95d4-d687f8703339@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779255778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/p0aykl0rOg/tr3JDR5GW/c2782npkazgwq4hJABg0=;
	b=lQrZNrGcN0ASJMh/Sw3EpKa8+Q7dtKIVmp5s7pacTjxN2dwWl95pdTQPosyeMIudpgP2cQ
	ahzeaeEgAIXMtyVRl7paAEJl69CJ1itKIqcj0Ega24KangKSEBLcLBunhzNw6Ga3lC0V0k
	C8quyR4Cc7jgkCMTQX0n5ybe3V+Ha5s=
Date: Wed, 20 May 2026 13:42:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new] Documentation/admin-guide/mm: Fix typos in
 transhuge.rst
To: Leon Hwang <leon.hwang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520051751.74396-1-leon.hwang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260520051751.74396-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 462DA140009
X-Stat-Signature: 3p64ro37une5ec5yqy9egqnqk3gmenh4
X-HE-Tag: 1779255780-260465
X-HE-Meta: U2FsdGVkX1+XnFm0RxpWozADQcFRVdN0wTxenGAtdxyqSvxgwVMDj5yBSuH0gaAspHclsSeGY+aHZD/B8vBzqWl98+4nXTX3fGx7Y5ZZRWvUzEzTbRuTxkBaNHaIxdURIpI2DhF3P1wvDlx+XH+gtvc7Hs1hEEWLXZOWUji7SDVm6qZbe0g9HJrnGXuSZt4QWpcagdHOuEH7e4oxmu1BTMBmpwrwL95acIR6jCfdYpp+ynb7XdmJSunfnnSQX/BrA4rFXtczSNm+4m4EbdQNY7jsW6WTS/bxyVxj6qQwJX3wAQusTlYSIrEgTdfdx0lolMXeelsN2dpWEzD6EzfRSN5jk2V9ux/U4tTh+sTvYP/vmvGJ095FcXq3bEjyIYt0byZNILr8ae8Wihn2/OboFNRopKHGYrqR6C+9wkqBWzXAhnjz1qE8Ix3YOK8vn06GwaP1m57uRmN1QG22Gw9tPMtg2IW5mgVyQ+mtVWDXFB9pJZbiPji896nS0T0Kr2mgYwVNGYTaajJAldSOwPCEF0/Msv1IqgtOWtfhsKoDr4F75sAWnpRnqh5Q4FTuBqC5slKdzEG0FhbFvxibDkVmVSy6aYUv0bk0rrkrXpatgLWBKdDe7ou59dvTRl2PCLpUKni/4S7JGLvbXH0Lo9FoPsszGNpz4UPqTeP4mtrwDergqkZBaXuf6dZBJaHmg1a8kb4Pur16nQ2s2C14T5RLrvJIExJ5r8V/10xuAsFpCANU8LWiF3x0ZcB50A5b9ZJQ7NY3W0AuPc/DrgwGs+G817/VsQ/kBxfh4hC/XrUGpFWYDfz/fbUGEPscQbnRl2UX7PGNqjJQmedxnSrHgJ6CgyRXKTDhPdaGYtsXw/97gOBrs+WAOkpoGW7n83wKSF0+kJhGtecjYhjCrt+BoYOFlFD6aAiaGflUlY36A9yJj7ladYinFjhvTFn0AYp8lDM8zr+N0GpU8w/auweT3mF
 BPq1pLPg
 ahr9BQJxJvKzHrEbx6xICSTxP4RUP6/R7CXYGQVb8RjdS+oJhRxPLWv+cr5Dib0EkUhCwxZQvoykXIsREYWHXoWea3AQSjHM/er0KCzfbBDrVjHeiie5XdWSPIzjTKRfO7jmPyq0d05FJIKZ13whRxAY6kZgDih1fofim0Iz2bVo7ZplfVMI/FcWsiYMaqkDpakDVBYqGbCNBjKgFkLBpv9knAlbA4VUeGxgDuMbHt6wXFdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/20 13:17, Leon Hwang wrote:
> Fix these two typos:
> 
> 1. approporiately -> appropriately
> 2. presure -> pressure
> 
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---

Thanks.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

