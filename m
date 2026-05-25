Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4ACCD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CE86B0093; Mon, 25 May 2026 03:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343E76B0095; Mon, 25 May 2026 03:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280936B0096; Mon, 25 May 2026 03:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 167AD6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:53:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD988A01B4
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:53:45 +0000 (UTC)
X-FDA: 84805178010.09.177E57B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF08D40011
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:53:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VMQXeXls;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779695624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axQYDtMo/5SwDXs6nQsqVjyWpPLMRPpV/xSTSlWZZZw=;
	b=BBQpPgODEQ9QM0uw8khAijLAD9zYZlqFtV1+7Id2FJN+GbKIu5Gx4ggHBidi0H+QBfdyIs
	04tC6jjHVRoTNgikeTha8M94LJtW0QXqP5qYCMAF+vAVhsrZgZr3yjCdgMC/C0j0JXH8LG
	KqKKcbmGpxL4qZDXjbd8DdRRY6HCySs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VMQXeXls;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779695624; a=rsa-sha256;
	cv=none;
	b=ZfXeDL496Zxu/HTgQ6vWlwfXlvYkQiKQFYkw8M4V8cv4afK8OibWi/IZ8/w0h/v09BRKF/
	k4ppCu4udXQ+s24i3rAb3BpfycFmoFY9ysHMQ6Hn62zAQ1d6MybmcOAPvycoMWubvP/MPr
	k01qqE0hZke6C03kOGcNlwFYptzfYmg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ax
	QYDtMo/5SwDXs6nQsqVjyWpPLMRPpV/xSTSlWZZZw=; b=VMQXeXlsUSn6JqZdyX
	FGXaxLcl+8PyIZkPtumy/0+XKU/nasl/+aRqEEuOsycUszrRqbCu1zqd7ipMGcVV
	tKsXNP9G9mF0/cD6bkTkAOAUqHV4AdWsswINZ5iK7bawBfLROvYb+6j399J8snFd
	8UWVHP71EyvRwMjNrfseP4Oto=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3P8a1_xNqQ6RnFA--.147S2;
	Mon, 25 May 2026 15:52:25 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	leitao@debian.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npache@redhat.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [PATCH v3 1/2] mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Mon, 25 May 2026 07:52:21 +0000
Message-ID: <20260525075221.68631-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ahAxasYwrGvwQLKs@lucifer>
References: <ahAxasYwrGvwQLKs@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3P8a1_xNqQ6RnFA--.147S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGry5Jr45WFyfWrW3ZrW5Wrg_yoW5XFyDpF
	s3G34SyrWUJF9rKrWxXF4rtryrtrs3t3W8Kry3G34fJ3ZYvwnIyFyktry09a4kZ34fJr4I
	kr18WF9xW3yqyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUbVycUUUUU=
X-Originating-IP: [117.176.242.242]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hmN2WoT-7lu0gAA3g
X-Rspamd-Queue-Id: DF08D40011
X-Stat-Signature: qk6xj9ta6s7ex35ksatwpetmui44q986
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779695622-705792
X-HE-Meta: U2FsdGVkX18whMnZhFhiUPSGglpA31eilConjEUERfmjJMAbHE9RDLSTuWtPNgsqRCVWYDsRXDXRFPH9t/yTsfZB7w+ecepPU08nAcpcDidqlRCbiNKJq9RGxqoh7PSctdVuSuOpX00mgh2GpkFlFopuXeEVr6txrMnSw1Geki3S3mNuhZGqYND3S9r/mqhUoLs3TbiDKnDvRWWTDodc5srIGaXMOF5noLk7gJZ8Wn/eTH1m4f+Fd6f70QsDos045AHEStBd3nv5UV3nPz6xDTUvIfTzgv0JU4dI/qKjyEQGQ6l/WBJy92D5VTd7R2r5d9rwOlLERug+fKeHBfvYcn8v06cjxVHXkxLPcnAejOPLmhHva9Y/G4NbeyHEy352C3XiM2gExoueNw7JdQuksKt8ys4ESoy2zwtNc1jd+w0wxuT/UMY51fOtBiE3mjm9+/9KALitJcl6U3KZBocfLwMCKzLl51I7ZxXxEx+Mk/5mjvATYfMwzhMyqeuwZvOpSuYnVxqJLr2CAU01Vua/jqVoQcjrucZryGcT/Bg2zJibcLnBAMr9eOGCtOCx0MgVA6iEAsSoOkNYa443v/M7svKS+uDnwrH99TFDfoG1uJrmucKVpuv9TAfH+yA27+T/MgAW/7Bke66AddJIfFeq26Z8zR6ujKvWl07dxGipN2Svktrcg+xk4NAkjd9Y+fh40EhHLp04+6MDVGEfYPbdEr4hJPAYbGlvW7D/S3EGAifxOEU7iDN/WHibio43zpGO4D0WJAlDrQ5Cys1CcSvVZFlEU+D5DAFCQEYIrLs21cFn0d299EPwsuQGArbCEdCEgPhMYGfeIHApNio7uL9LPTMGHtAsisuMPwFNm/9i0/goOY5IEojMnUIi3bBN0yofWZcJTDmJ4jOFXvQpnFaZ8xOBnprd5bo3oR59elyFj4VZhVL7nD9tKDKJoSGaiF+VSe7TrunYTjL1qJmu6YX
 78SBFEJl
 EOBqNiE7UK/LYTRpiD6zE1W+uRFgYZoCet4e0IoruRx8IYUXc8Zd18+KCSkDwq+R7qxMvmMXzIOYFh9XhUC3UHpZQz3ImzVTqqAyNb8u4rEikQXwIDQ9uL/aLyEMXUE6+m72WDjf3KCqkUKUfx8Pve2FYoLcrHIOamg38iuq1fVq4ohWVViZ5hw+Fc0nVHmSr1M7Bq7wIZ+y4Yknvxbj1DaG/S3jJALoorNdrnWK8/xfic+QzV6GXzbSQileQLdntrlhEevMtmHdIzbGVQk1mVIpZeLNRMUvpvSc13KIksVXtWzmpgTH/PbSAJhm4EuUrdpto/MUOIbnscU/qmWTchd9ASr3GVBWmoNd7oFvxJMo1R0f2DIK5VjE6njkyAA9ALC/DEQl1wADzjol1pbyUvJMOkNH8o0sVZLVhBiIFHEwmeS6dwjCEyGkc1rsI8rdQAF/0MbqSmYf+W5EgO2HLI29DJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Mon, May 18, 2026 at 12:32:37PM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>>  mm/shmem.c | 107 ++++++++++++++++++++++++++++++-----------------------
>>  1 file changed, 60 insertions(+), 47 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3b5dc21b323c..46d2cfc30823 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>>  struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>>  static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>>
>> +enum huge_shmem_enabled_mode {
>> +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
>> +	HUGE_SHMEM_ENABLED_INHERIT,
>> +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
>> +	HUGE_SHMEM_ENABLED_ADVISE,
>> +	HUGE_SHMEM_ENABLED_NEVER,
>> +};
>> +
>> +static const char * const huge_shmem_enabled_mode_strings[] = {
>> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
>> +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
>> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
>> +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
>> +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
>> +};
>> +
>> +static unsigned long * const huge_shmem_orders_by_mode[] = {
>> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
>> +	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
>> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
>> +	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
>> +};
>
>As Baolin suggested, we can probably rename these for bervity.
>
>We know it's shmem, as it's in shmem.c :) so drop that.
>
>huge_mode, huge_mode_strings, huge_mode_orders seems good to me?

The old naming is indeed a bit verbose.
I will send a new version based on Baolin and your suggestion.

>> +
>>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>>  					  struct kobj_attribute *attr, char *buf)
>>  {
>> @@ -5546,63 +5569,53 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>>  	return sysfs_emit(buf, "%s\n", output);
>>  }
>>
>> +static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
>> +{
>> +	bool changed = false;
>> +	enum huge_shmem_enabled_mode idx;
>> +
>> +	spin_lock(&huge_shmem_orders_lock);
>> +	for (idx = 0; idx < ARRAY_SIZE(huge_shmem_orders_by_mode); idx++) {
>> +		if (idx == mode)
>> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[idx]);
>> +		else
>> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[idx]);
>> +	}
>> +	spin_unlock(&huge_shmem_orders_lock);
>> +
>> +	return changed;
>> +}
>> +
>
>Thanks for separating this out! :)


