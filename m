Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A9EE9DE41
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D439E6B0005; Thu,  9 Apr 2026 03:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4136B0088; Thu,  9 Apr 2026 03:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09FE6B008A; Thu,  9 Apr 2026 03:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58986B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:01:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D32D1B7E3D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:01:03 +0000 (UTC)
X-FDA: 84638120406.01.82477A0
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38CC5180004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:00:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Bo1v9F6x;
	spf=pass (imf24.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775718060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6z0npu8fIAS2o6fPNf20bgRccAnWCocIwK4i1LBbuDk=;
	b=YIwuPx7J05XRnsu+cj7Cqw247nAIIJTfwA3gWBYUsP/gSQrJg333r7xlOtn0DQA+wcZNoW
	QeTfOFZidXQ29CPje7Pc1oTJTq7sXJN/jr9kMqUp+r8o4oVtIdyR8w0HNdINcP952PX8Ek
	WUTUWizOqdOSd9Nh3rHahsJIFWhZoiw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Bo1v9F6x;
	spf=pass (imf24.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775718060; a=rsa-sha256;
	cv=none;
	b=doqERh1wdnZS6BzF1spp46y0k2YLFctlXppdQ0xbW3dwvxFhVpnJQiiKmEUIx72xUcQOjb
	/k9yOI4dHUY1ezO9g1rbGE7UmXTjNL5DzJMLQUB+3o+xiEr9r92PZKlkYM/0ksQ4hMlHjE
	2jwe9El0Ev/ANY164CUx1WCZ5CnA1Z4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6z0npu8fIAS2o6fPNf20bgRccAnWCocIwK4i1LBbuDk=;
	b=Bo1v9F6xb1v1tcbT3IigZThvbxJhZJzCcW9AreNAGNXvJX8vZXF3cjM6RPMpUbBYYRyW6xSiO
	UDH5gFF4yk7dTH4Or6aEPqUUhT0hTLtGiqoKOiqeZv3nBerblnH1g7Z4jEQs7YiE1ULoAcfksB/
	/9xSoefK15RzpvhwVDZLkBQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4frrJv0BklzLlYJ;
	Thu,  9 Apr 2026 14:54:39 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id DBED640562;
	Thu,  9 Apr 2026 15:00:52 +0800 (CST)
Received: from [10.174.177.52] (10.174.177.52) by
 dggpemf500012.china.huawei.com (7.185.36.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 15:00:52 +0800
Content-Type: multipart/alternative;
	boundary="------------0VuqlmOkxonvbK8qZuc6iukh"
Message-ID: <b8dac53f-443e-4cdf-9229-9949c90b8eda@huawei.com>
Date: Thu, 9 Apr 2026 15:00:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: support freeze kdamond
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <chenjun102@huawei.com>,
	<tongtiangen@huawei.com>, <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260408140708.89729-1-sj@kernel.org>
From: "linruifeng (A)" <linruifeng4@huawei.com>
In-Reply-To: <20260408140708.89729-1-sj@kernel.org>
X-Originating-IP: [10.174.177.52]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38CC5180004
X-Stat-Signature: up8drzc4qnw7zjbz14ejdwdmzac9g3u7
X-Rspam-User: 
X-HE-Tag: 1775718058-786495
X-HE-Meta: U2FsdGVkX19XweWaAiBryVci37W40pAnR6ot4QYB3X2fzEZkx4mUfkkzXlYPgiZe6wvBBQZ2+U0x85+VreMr98udANsvxFu+9bzg9ZycbInNBE9n7vIbe/tV6Etn0MvRb/OL6mO9ijfWdoeXmrsAeS8h9uKDjrEMygAUEnngrX+0q5LmFkZ1R7jglegfY+qp9dIsmKS25INvHIw/r5KeVbQJwfuv9BWG0Pl2wAwgGMNoketHPsvv1zd/69+mVJYvs+Yf54RmEv8L1Au8Gx+gK9X7NmnC1RFDPORSm8s2FDSCyRBJAGxx6uVFnl4PYja+xYHiLmw0UIASw+ad5UWd9KNFgNISBCUGid+VoSBtArOWPe3jSOH/S9IGjGRHH2tEvoQSxM1oHxV0ACSqhm0mN91dox+aVibRQ4MPZTbyqZtwZ4GREDxvKLVxzt6bAUf9Py0O1+9qNjkQD9EHwj8GJAG31NK/NbRq+qkutpkxrWMmpOZFcunohpk/IlHXM10Oxt1n3ElfsWvRdFlMXtESulVuevanFhlBX9nKsJh0VqPXcHZF7TQXQPM8mGEGuF+2rD+UT1ndRUIQY3M0JHHZ8jV9TF2ihI6oE+EPWVaxXPxVhYF9nqV0Pq440qnAhArxlRZTj26ZVkA+Z6OWRJQgpQefMK4JhEneHjE3s3FPQ1Qel+xuHJrIZhVpbNRaGNt24GCwCuLJAK/hJ00uhjVmnumfLUj0gMj/x53wUZiWc6ITQ87OQrTze2Xs1xAmIadqKH5F3A5cVkL+1b+zB6y4AKLhMZne9YJYgD3YK/N6YN1e0ExioxDhI5+fJZcZt6i8XrioG3LsyMfTWras1tvY5CcXRYHWcYXXSTgPelqi0pjrbCWyLqoxGm/2fkylBP1IT6MEILZ1FnvAq/eV/xxWwl3Q27AayHkaXRDoFpIJUdJzG1K0zs0NOGSJzLAPetNjNeiZGFxn49hcs9jtD2i
 xwjO1o2H
 4ht0SLmraSCwdGMRwLrq0zZ40KFWm1G/ypuhNPGxT1fMeI/o94OGu0h8Kkwz+Iz6E/l1izqE60v+zCF2kLTCgyKJB4/hy/Q3tGvJgEbEkYUIBqli/GI3uzL9v10Wvh0PKpfACFAndrMp5B+uL/B7pytBdsGrljDXiIC2HenX4htFonq+pmqh0Z83e+sC1LBBi0IqLjpWiRLKJEJQIVUn0kjRD8KHTxjKp4bQfEhk18f2QdBR6o4jJLUJglUGTH/I7LFe/dDWricEApbmoKcN19NjyGz4qOLHqxC6bXq3ILSLhwB6M5XM16k/OmxfNsitbHCYlHwJ++r8XgZWG3mpNcVFNulx1bkHENgLFYp36aCeteZd99tH8sZAndg9YFWEc+Hf8KdJeMvu3oz0wJyYDYvBtOKY1TWYA4JiSCvq/DijGYMdasmhTl75IByNZY/yR6u8YtgRsxyGUvq+13rD9VAX873XCkCb40U/e92VM0+jz7rBRE7v3ee7XjEq0HcBRxsgorpZFyJXNCYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------0VuqlmOkxonvbK8qZuc6iukh
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

Hello SJ，

Thank you for your reply. Based on my current knowledge, I think this can be
described from three aspects:

1、kdamond monitors physical/virtual addresses and performs certain actions based
on the monitoring results to improve system/process efficiency. When the system
undergoes suspend/resume, most user-space processes are in a suspended state.
kdamond may therefore perform operations such as PAGEOUT / MADV_NOHUGEPAGE, but
these are not true data monitoring results. This may cause changes in the efficiency
of certain processes after system resume. Therefore, I believe that continuing to
run kdamond during suspend is meaningless and may even have negative effects.

2、When performing hibernate, most of the used memory in the system is swapped out to
disk. When memory is large, this is time-consuming. If kdamond does not sleep, it may
affect hibernate efficiency.

3、As discussed in [1]: "The principal reason is to prevent filesystems from being damaged
after hibernation. At the moment we have no simple means of checkpointing filesystems, so if
there are any modifications made to filesystem data and/or metadata on disks, we cannot bring
them back to the state from before the modifications. At the same time each hibernation image
contains some filesystem-related information that must be consistent with the state of the on
disk data and metadata after the system memory state has been restored from the image (otherwise
the filesystems will be damaged in a nasty way, usually making them almost impossible to repair).
We therefore freeze tasks that might cause the on-disk filesystems' data and metadata to be modified
after the hibernation image has been created and before the system is finally powered off. The majority
of these are user space processes, but if any of the kernel threads may cause something like this to
happen, they have to be freezable." During suspend/resume, processes involving I/O operations should
be frozen.

Based on the above reasons, I believe it is reasonable to support freezing kdamond. If there are any
errors in my thinking, please point them out.

Thans,
Lin Ruifeng


在 2026/4/8 22:07, SeongJae Park 写道:
> Hello Lin,
>
>
> Thank you for sharing this patch.
>
> On Wed, 8 Apr 2026 16:06:52 +0800 Lin Ruifeng<linruifeng4@huawei.com> wrote:
>
>> During suspend and resume, the data monitored by kdamond is
>> no longer meaningful. Meanwhile, since kdamond may involve
>> I/O operations, it is necessary to freeze it.
> I'm not used to PM freezer, and maybe because of that, I'm not fully
> understanding the motivation of this patch.  Could you please elaborate the
> existing problem and how this patch is fixing or improving it?
>
>
> Thanks,
> SJ
>
>> Signed-off-by: Lin Ruifeng<linruifeng4@huawei.com>
>> ---
>>   mm/damon/core.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 3e1890d64d06..5cd1f0aed66b 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -16,6 +16,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/string.h>
>>   #include <linux/string_choices.h>
>> +#include <linux/freezer.h>
>>   
>>   #define CREATE_TRACE_POINTS
>>   #include <trace/events/damon.h>
>> @@ -2753,6 +2754,7 @@ static int kdamond_fn(void *data)
>>   
>>   	complete(&ctx->kdamond_started);
>>   	kdamond_init_ctx(ctx);
>> +	set_freezable();
>>   
>>   	if (ctx->ops.init)
>>   		ctx->ops.init(ctx);
>> @@ -2774,6 +2776,8 @@ static int kdamond_fn(void *data)
>>   		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
>>   		unsigned long sample_interval = ctx->attrs.sample_interval;
>>   
>> +		try_to_freeze();
>> +
>>   		if (kdamond_wait_activation(ctx))
>>   			break;
>>   
>> -- 
>> 2.43.0
--------------0VuqlmOkxonvbK8qZuc6iukh
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <pre>Hello SJ，</pre>
    <font face="monospace"><span
style="color: rgb(15, 17, 21); font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Thank
        you for your reply. Based on my current knowledge, I think this
        can be</span><br>
      <span
style="color: rgb(15, 17, 21); font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">described
        from three aspects:</span><br>
    </font>
    <pre><span
style="color: rgb(15, 17, 21); font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"></span>1、kdamond monitors physical/virtual addresses and performs certain actions based
on the monitoring results to improve system/process efficiency. When the system
undergoes suspend/resume, most user-space processes are in a suspended state.
kdamond may therefore perform operations such as PAGEOUT / MADV_NOHUGEPAGE, but
these are not true data monitoring results. This may cause changes in the efficiency
of certain processes after system resume. Therefore, I believe that continuing to
run kdamond during suspend is meaningless and may even have negative effects.

2、When performing hibernate, most of the used memory in the system is swapped out to
disk. When memory is large, this is time-consuming. If kdamond does not sleep, it may
affect hibernate efficiency.

3、As discussed in [1]: "The principal reason is to prevent filesystems from being damaged
after hibernation. At the moment we have no simple means of checkpointing filesystems, so if
there are any modifications made to filesystem data and/or metadata on disks, we cannot bring
them back to the state from before the modifications. At the same time each hibernation image
contains some filesystem-related information that must be consistent with the state of the on
disk data and metadata after the system memory state has been restored from the image (otherwise
the filesystems will be damaged in a nasty way, usually making them almost impossible to repair).
We therefore freeze tasks that might cause the on-disk filesystems' data and metadata to be modified
after the hibernation image has been created and before the system is finally powered off. The majority
of these are user space processes, but if any of the kernel threads may cause something like this to
happen, they have to be freezable." During suspend/resume, processes involving I/O operations should
be frozen.

Based on the above reasons, I believe it is reasonable to support freezing kdamond. If there are any
errors in my thinking, please point them out.

Thans,
Lin Ruifeng</pre>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2026/4/8 22:07, SeongJae Park 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260408140708.89729-1-sj@kernel.org">
      <pre wrap="" class="moz-quote-pre">Hello Lin,


Thank you for sharing this patch.

On Wed, 8 Apr 2026 16:06:52 +0800 Lin Ruifeng <a class="moz-txt-link-rfc2396E" href="mailto:linruifeng4@huawei.com">&lt;linruifeng4@huawei.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">During suspend and resume, the data monitored by kdamond is
no longer meaningful. Meanwhile, since kdamond may involve
I/O operations, it is necessary to freeze it.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I'm not used to PM freezer, and maybe because of that, I'm not fully
understanding the motivation of this patch.  Could you please elaborate the
existing problem and how this patch is fixing or improving it?


Thanks,
SJ

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
Signed-off-by: Lin Ruifeng <a class="moz-txt-link-rfc2396E" href="mailto:linruifeng4@huawei.com">&lt;linruifeng4@huawei.com&gt;</a>
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3e1890d64d06..5cd1f0aed66b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -16,6 +16,7 @@
 #include &lt;linux/slab.h&gt;
 #include &lt;linux/string.h&gt;
 #include &lt;linux/string_choices.h&gt;
+#include &lt;linux/freezer.h&gt;
 
 #define CREATE_TRACE_POINTS
 #include &lt;trace/events/damon.h&gt;
@@ -2753,6 +2754,7 @@ static int kdamond_fn(void *data)
 
 	complete(&amp;ctx-&gt;kdamond_started);
 	kdamond_init_ctx(ctx);
+	set_freezable();
 
 	if (ctx-&gt;ops.init)
 		ctx-&gt;ops.init(ctx);
@@ -2774,6 +2776,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx-&gt;next_ops_update_sis;
 		unsigned long sample_interval = ctx-&gt;attrs.sample_interval;
 
+		try_to_freeze();
+
 		if (kdamond_wait_activation(ctx))
 			break;
 
-- 
2.43.0
</pre>
      </blockquote>
    </blockquote>
  </body>
</html>

--------------0VuqlmOkxonvbK8qZuc6iukh--

