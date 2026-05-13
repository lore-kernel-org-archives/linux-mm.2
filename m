Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C40CCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77356B008A; Wed, 13 May 2026 04:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DB06B008C; Wed, 13 May 2026 04:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D1B6B0092; Wed, 13 May 2026 04:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1D546B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:26:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F4CF1A07AD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:26:28 +0000 (UTC)
X-FDA: 84761714856.07.508761B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 85B4C1C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:26:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iWkgX8LH;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778660786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vz+YEC6ezg4b0gK7irFezRpf/4ex9t9RFut6kNbP42I=;
	b=0/iWS3gWoo6B0ojFqr8EO2NGaj0cXU9hqF1/lMU/AQ09N6lgfbYQGDReTUXtGehkWWxgZu
	Pi2JoTIBPxRsHkIdMOXrYYsZWNRgN9zGritrNh6/lnizc5rQwoHWgbrhUvZX2+jajp6ilW
	W5LiROGs1Yq+q2NMQmUKLdZ+k7UGa04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778660786; a=rsa-sha256;
	cv=none;
	b=AweI9jvopLGqYFEL9KpVzkJB1EhYM/R0acCBEOM+Ne6JvPTeK3kbbetCOhV35mcBnIeoPW
	l1NxRLTH8FPtt+OqcFaACj61Pr9CgAn2BcZhP+iYmr2HEhNeex31TjwNf7RZ69WaGZlEaO
	DEX73qACfaRyqh00ZoHQ3A313TkYCus=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iWkgX8LH;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=vz
	+YEC6ezg4b0gK7irFezRpf/4ex9t9RFut6kNbP42I=; b=iWkgX8LHAi7ptnuSzO
	4dHlnmXlMGftEmD5uH9AwuDOspaKiXomQLTP+aYu05wcVP62Ij+HeTeE7TMaPtlG
	GBnzUSPGQagvYCu1D3lVMVGSiqsWlsb0hnNt8jrKiV0q+83ebJOt4Nt6VTwCxEZM
	Lax4tYk4+b/+xZSkQkO3z60Tc=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wCHNjuWNQRqDPV+BA--.19592S2;
	Wed, 13 May 2026 16:25:59 +0800 (CST)
From: ranxiaokai627@163.com
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Wed, 13 May 2026 08:25:58 +0000
Message-ID: <20260513082558.50743-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
References: <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHNjuWNQRqDPV+BA--.19592S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr48CF1kWF4DXry8WFyDWrg_yoW8ZrWDpr
	Z3G3Wayr4UX3s2krsxZa18ZryFqrs5Gw48try3G3WfZ3Z0vrn2gr10yr18X345AryIqa1I
	vF1UGas8W398A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUpxR-UUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhgPW2oENZgDkgAA3Y
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 85B4C1C0005
X-Stat-Signature: 3bqco1r34tk5gixph414h6iazohr5csn
X-Rspam-User: 
X-HE-Tag: 1778660785-396146
X-HE-Meta: U2FsdGVkX1+eYlQV9e1hSYNb7V7NMWkpwdaBVzGhLLwvD7ckvD/l73sgS5XUsjMgrzsui+64U3pKUBJfS9YE4b3lqOl8XqVxIcRm4qrJHKqlXk7XMegOb/kSF33lN7d0K+kxib6/S8d/JJ17CJH0q1aobp5YFqYQdpjSPIdM7nn+LI+caV/FZ9CCpylfUrWWAFNtl6jL57u+UwlXBvrAm3q0spnYSoZsjJPiF+k5tXEkXYbQK/EBqR19TEp5oumxnyil71rtmepydwYOC/kdiNsBtjPpqpFDKpVp1HJeL3yGsDuon7Ofm/6L1ZBd7ysaNb+c1j/kN9I3YUYL06/0XZ6A8C27cxDoKQ4E8l0XEvX0X4hlxkMPIR9yo4Ud/SAUQQmHQZAXkyKuUOnIOW5stK67YT0ZKEqB1a59gAx94gx11lZ8tkHKv741c0jyClaKzQj5uceAFj8AySVaFc0VG8uwhFun7T1LPrrxk2VMLuK/LpdzttgfrYWZO1JPbONKvhLji6LKvZ1qeXodNHHd8KK0QlCQh0hT8iLRjgtRo4W8T8Mp6e2M641uK8slpEuUOQPqY0e3X3szkF4qh6nW7pPdL79OHOyTZtffS5njbBB6sdOQ5eTM1kXDYhdeRALAWv+RQRi+XSh3wVx0ijwWsCYMX7EaEbyYWkhggf/jTs6y+DAc83DAOs1yIwKfUV6xZmWP7Vf2Eg/3Gz4Bt9TdGL8Nd/jUanieapN95Dtk/W/mzAAxcRHetTLhPn0UyAvUs1py+KRZnQzEJBsYEUlsTSTXmBnsoFtpv1otHQpXRIxP7DC12eEFMg604WD/zeKvbsU5cmU0yy90dbp6HF2qK1MQAOonaoDbzM+h3BoYruy1DYHvwZ+skZ+R8w1znT70QBsCiIoeMEgpN27sGgSCnw1Q0uLyRjzRE5YvXWA0SiH4k4r5KXMQm0eBgYx2HEkh6+2PaenUB8QmGap/ADj
 iH0c8KGL
 0M72RLmt0QibJD51tMENSfQIQZPYZJlC9kWqzoS7eXqZothLv/rb9nTq4Qr40uyuMysgM/MK2oWyphr3eknnE1r2TJVIJejQ+PEGjyq12/VZI0zMqhfplvik5ykMVa24lzRha2LkHPKyxJf8YgekPjaYnuaDuqS1lpZ8gd79F5U32Y1Wfd+D4Uc+/NIo4WB1fopQ+rIia9C79n1iDCxtzM/Ho3wNfGpr6cWeiQnqIpfRV/6QpIEaFtd0Sypl849BE2tbDp3kTatbh14KZfX1LVen8TNVA7V35tCoegwV0CYRg49zM1fBOxC+Ic74xVFIw5oeNwBlsto7EX08b4mexotIZze69RHpCUYLZ0MoB08o0rCr+lkrrhxecT8/ddaz560xQButD45p35u0g0FyAi4PYk3s3zjPHjpjLlRyPXf8cmk54UxW9OSqDWIlKXwN+siUUsoMTt5GaZaMiOOUBMnxjzW2wH6vCk6WNVIZIhj/J3uQ39gHoCTUt0RzZMDNPGuz1Wy7ArIw4JIYPkIZ/LTihzFQB16fs+xtiTc0S3IxBDfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>CC Breno and Lorenzo
>
>On 5/12/26 8:05 PM, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> 
>> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
>> anon_enabled_store() with set_anon_enabled_mode()"), refactor
>> thpsize_shmem_enabled_store() using sysfs_match_string().
>> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
>> calls across all branches, reducing code duplication.
>> 
>> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
>> all test cases passed.
>> 
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>
>Thanks for doing this.
>
>>   mm/shmem.c | 88 ++++++++++++++++++++++++++----------------------------
>>   1 file changed, 43 insertions(+), 45 deletions(-)
>> 
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3b5dc21b323c..0cc7872cc576 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>>   struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>>   static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>>   
>
>We are already under the lock, so you can use non-atomic functions like 
>commit 82d9ff648c6c does: __test_and_set_bit/__test_and_clear_bit.
>
>> +	spin_unlock(&huge_shmem_orders_lock);
>>   
>> -	if (ret > 0) {
>> -		int err = start_stop_khugepaged();
>> +	err = start_stop_khugepaged();
>> +	if (err)
>
>Moreover, I think we can follow commit 82d9ff648c6c's approach: if 
>nothing changed, we don't need to call start_stop_khugepaged().

Thanks for the review.
Yes, indeed, We can further optimize this by following the approach
in commit 82d9ff648c6c. 

It seems odd to still call set_recommended_min_free_kbytes() when the 
mode hasn't changed. Maybe this is to handle the case where the user
modified /proc/sys/vm/min_free_kbytes in this timewindow?

I'll follow the existing logic and send a v2.


