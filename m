Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D857C87FCE
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 00:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C478E6B007B; Fri, 25 Jul 2025 20:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF86B6B0089; Fri, 25 Jul 2025 20:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0DFC6B008A; Fri, 25 Jul 2025 20:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A58416B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:28:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 348F81A0557
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 00:28:19 +0000 (UTC)
X-FDA: 83704529118.27.43B66B8
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id D35DB40007
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 00:28:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753489697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j5b6X/DL8i1W/4H/CuqimfcgAZGhk6tVtUWWFbYMqY=;
	b=buNtpoAsUVUPF5Mg/saSapubei7V0kGI3ydQxPBMuyZKzGttDk1d+xJAhvyn9AmRxLCrMM
	Os/CN6ITcvS2kWCr9AXf/hX/QSglqlCN65ruGLxfHSBDt6ezxdZ383+yYd9jGhKzBtJfWF
	6eukToyWGE+L+RFvBXwi7Cgzw3MpgEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753489697; a=rsa-sha256;
	cv=none;
	b=OAbUYNqCk87+mYsG07FtHb9x5O+QiCIdMvg9zlxLdmlb0ESz9AuuLStspd5gzzO5kc8EdG
	9GtguwXOLvvmkjiCQ8E8EGpAMdV8d9uyzk9/ZSfxWEvMNiTg2jUJh0Vs9mVYPPoXZxG3FB
	w9kwUyCW1yJvGyDApnAGtt/v2lpd5N4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bpltL3XlgztSkv;
	Sat, 26 Jul 2025 08:27:06 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 0655A180B57;
	Sat, 26 Jul 2025 08:28:10 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Jul 2025 08:28:08 +0800
Content-Type: multipart/alternative;
	boundary="------------cKk00zsXUmPcVSbNLXlr1Q6P"
Message-ID: <a0c990be-f56a-4c40-8fdf-acc7252be015@huawei.com>
Date: Sat, 26 Jul 2025 08:28:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: hold PTL in hwpoison_hugetlb_range
To: Andrew Morton <akpm@linux-foundation.org>
CC: <andrii@kernel.org>, <avagin@gmail.com>, <baolin.wang@linux.alibaba.com>,
	<brahmajit.xyz@gmail.com>, <catalin.marinas@arm.com>,
	<christophe.leroy@csgroup.eu>, <david@redhat.com>, <dev.jain@arm.com>,
	<hughd@google.com>, <joern@logfs.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rientjes@google.com>,
	<ryan.roberts@arm.com>, <superman.xpt@gmail.com>,
	<thiago.bauermann@linaro.org>, <wangkefeng.wang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
 <20250725033112.2690158-1-tujinjiang@huawei.com>
 <20250725162913.5ab54fa56b8b67c749cff948@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20250725162913.5ab54fa56b8b67c749cff948@linux-foundation.org>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D35DB40007
X-Stat-Signature: brrtqtab3ojywuoh5ywsupzpdzcs6tw4
X-Rspam-User: 
X-HE-Tag: 1753489695-69027
X-HE-Meta: U2FsdGVkX1/e9+jX/VU6b0NdtjjjocAWLmP3XOH4rYy2h7BQBtbr0yKKTDYjikSRuFRnTJnRYl/cMjatmLYjdder6XJBhYu4ed4wGzrWmGFkk5fAmk3Ue7BCAHdR3n9Km39jYIojAXmxEN/ajQjz7sv7jQJc3G2GKbsle+ekcD6ws/QSg7KGMipDAxIi2c8mYWkVDX4XwU/i4z83BxPu3kZdQvQDgf1/dfvvme+LnmELH8earEg1QFAZ6BKjAqgac9JbmKY7b8nluRlZb+W3uzN/BJ0hOv2INedy9rPwSD0MOGMKttGbxnwDoeVBVvtQej2hjL89JPzBbNpWJYzJE0kEYPyFh5a0RTqQhga4uwgtBu2VHSvKkASATV24R4Bs3n6qRjn2JYPFXyMv+T9ydO5dquf47l69cCuSTzi+kdp0GdiHuAN5ZiyySuXpZHWKAIIp4wcl7ofSqsarrVdjGdxtH/IaKjCDwnmocyynXQwQLTStL6mNAkoh+L/tYjauHOskN8fqh0M6D9G/lJrsP+KVespo5zuwyVTOW3ta+/7AenAgG5oFooRwTAoKfNCbNzezh+1bqNN92ScLE1jUmhjPgwpj786lwzfYFpPGh4WnUImt2B5qbjRRu7YoL2ww4tb50rwV2KacgEbWID6p74DwG/lqtkBbom2wLE60ml+3LxH0P0oHly6/4tBfRQr29dSuyUByGubDHa6/y3SpNfZsJgGRc3M+72QT7Sc//LOVLUcpkaBQtQkhDv12m1YIyPizu3jL59MOlLUAv9/O+fBbt392Uy7lSpIxl6fMTjIuEesDEfNcDzGnrTZZmbMh+NJDbDTdsbCHaAMC7Vm4xj/MF10AP1cOHgGWm801eoyxQPIA3nf1Oqm0Fv4e4phGLDdskfSTye0SacfS2dnS8kQthY+L0m8zBjTdeS0GQ3voIh8irp91OIQcrJJQsLAEgdQES09mGifo0nvccAu
 VOeixPHI
 txCmm7bS9uu99xxWCvNmqtsGVULRLnOEoWfhoiUhuHzbBLOD64be7/1fwdgPb3EMUGhCb7VmCoMsGKj+YuEv+zbdBVHskCO6KNpgbwRTC/E0qcPzR7KxPVLPDvRPfRU4iO5sKuiSQFRvStJgp5DcZcWBxsJ4aAfDDb/MkGKVp0rdMpKmd5Kd7Zc2Ewfx4HoMXEmcqnLuWI3xLPEI/g+zpJBw6HepDWZIUWAoSdgFS+VkjkBWzZtodY6eGrvOfu2/iwuas6wxemzhfU3+KTFvX55ORro3MhsMxmrNDbRHCUTteERmkqkewP3g97tqAYn0LLOC3fXHFXR13c0FAgbC6/qz9HiA37TnV12keafrhjCypZr9ZLiMgry9qF8LLx3qbFjaOtHYhSY5AoZ5XRwMcOG54XY2KUIoqTZOsrJwq3735WAjGXLvq0uV7RIyXGfd1Ck5tx+A/O9OFC4bSws47JsvQPstMsd9x71/LZN9mLG6cTdf/tZi9dxh/5b1txNttB1cTHorhUphz1ebbvDGI+6O/zlTj27cWib52P8r+bdDCkhfWJRUWy0EZsaZEpW2XpsXqvzCXbHh/gYB7g3UfGyQMd/r1qtLm5jPs5lfoGiKVG5uphw6oorVpSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------cKk00zsXUmPcVSbNLXlr1Q6P
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/7/26 7:29, Andrew Morton 写道:
> On Fri, 25 Jul 2025 11:31:12 +0800 Jinjiang Tu<tujinjiang@huawei.com> wrote:
>
>> Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
>> hwpoison_pte_range() have done.
> Does this fix any known runtime issues?  Or is it expected to?

It doesn't. There is no known issues, PTL is expected to hold like PTE handling to avoid poissible issues.

So, there is no need to backport it.

>
> In other words, do we have reason to backport this fix into earlier
> kernels?
>
>
--------------cKk00zsXUmPcVSbNLXlr1Q6P
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/7/26 7:29, Andrew Morton 写道:<br>
    </div>
    <blockquote type="cite"
cite="mid:20250725162913.5ab54fa56b8b67c749cff948@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">On Fri, 25 Jul 2025 11:31:12 +0800 Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
hwpoison_pte_range() have done.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Does this fix any known runtime issues?  Or is it expected to?</pre>
    </blockquote>
    <pre>It doesn't. There is no known issues, PTL is expected to hold like PTE handling to avoid poissible issues.

So, there is no need to backport it.</pre>
    <blockquote type="cite"
cite="mid:20250725162913.5ab54fa56b8b67c749cff948@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">

In other words, do we have reason to backport this fix into earlier
kernels?


</pre>
    </blockquote>
  </body>
</html>

--------------cKk00zsXUmPcVSbNLXlr1Q6P--

