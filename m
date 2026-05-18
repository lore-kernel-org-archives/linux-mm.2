Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259BFCD4F3D
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 02:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356D26B0005; Sun, 17 May 2026 22:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3074E6B0088; Sun, 17 May 2026 22:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6606B008C; Sun, 17 May 2026 22:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1331E6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 22:02:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB862A0752
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:02:46 +0000 (UTC)
X-FDA: 84778891932.11.1A00727
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf07.hostedemail.com (Postfix) with ESMTP id ADBBC40009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:02:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=V2jUlbDw;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779069764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kS82Y82Smkz806tcG5eajrNEYIT+cNNWW5kXF3cQzFY=;
	b=1KNYK0UudI72L/lUgQzgLx807oecIUiD0vWpquhRx4h2rNerL8wqmmVU9QmFGDcHDV+KVy
	wHw9Fi4d0myt0UARFoRzDcpJtSOZ/dzDI+qB26I3ZkuU002whVn2Ip6TMmhNbiXyqqwYSa
	PlaV7LV6yTWxhX+/o5RpUn/Yn9cj1L0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779069764; a=rsa-sha256;
	cv=none;
	b=DNBVM1Hp6guuubz/EjxxCfCn17Y8OEpwX5313gMSAXCF5saqEKBZjDiBYcRMqDFqk94iqa
	yEWpuGP04+zRHtjNpi0L8N3bO8py8EupaxU2OkL2k3dDxqdvxXpbt4Vi9zuBF4An32jny4
	xqlQNKHLuhVQ0Kt1wFh76eizW+G5+zw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=V2jUlbDw;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=kS
	82Y82Smkz806tcG5eajrNEYIT+cNNWW5kXF3cQzFY=; b=V2jUlbDwF4V7pumD24
	siiYEpmjOvuRHg1j2KdGVCb+c+gm9IVdgQTDKX1UULmh/XJW2fUYu/0hMzZliiF8
	3BvR/Xwyji2FP7lNbVV/Z4XWC7mhozq3ZEXEVe9XWb2dH0zEDOK6pqeEtu4LRgfr
	VgY4se1xxoGzf/l4bYXkp3iHY=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDn1jUgcwpqX1zSBw--.33526S2;
	Mon, 18 May 2026 10:02:10 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Mon, 18 May 2026 02:02:08 +0000
Message-ID: <20260518020208.55676-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <agW_BR8qNsxzAKYi@lucifer>
References: <agW_BR8qNsxzAKYi@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn1jUgcwpqX1zSBw--.33526S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWfuFW5WFy8Jr43Jw1kZrb_yoW8Ww15pr
	Z5A34IyryUJ34kKayIvFW8Ja45tr4xXr15t3s8Wa4Sy3Z5Wr1vgr1vyryrZa4xur95Wr42
	qF4xWF98Z34qqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUGFAQUUUUU=
X-Originating-IP: [2409:8a62:10:5dc0:5054:ff:fe87:d41]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7QICTmoKcyJkOgAA3M
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADBBC40009
X-Stat-Signature: 9unk36o5apg4jtqwrtda31b6gqj8sux7
X-Rspam-User: 
X-HE-Tag: 1779069762-962823
X-HE-Meta: U2FsdGVkX18d45vW71QKMDs9y1vE6lO+X1TflHg8QO9wVvXPvs79VDe//OQiLj338tkbJvSGQSPfWSHeyCgATOojwWu7Byt95UbXeRl6l2IJg83TpKJfumw9GSo9dLgIkwaowCDK2E1Q/krInWpT/c7zUxL3n2f7Uxl1EUciUb9uoeePjLm3vsv/RGBw5ORbdKExsk8VX92kdqmqWjIKyQpW+I0qB5VID6W9tamwlNfMi6tgGRadMws6z5HjyTau2ilbVlzGs6fzz2cxWz6UKT+v4mDY8NNOii/P85TJfG4X4yOzquo7tPl4QhN3bcPy7CQgMpCSDevXfWkoQ9QucbcauNpW6PsD/jVH8mMXvyIlCUmxhN+AeNEBa7TmxshZ41KMP9KP8NcmQVC9nnWyeJCwtQXFkHzrc+I91aDzOiJW1mDIsDbF88Phfm15bQtdpzxkS9NboE9BnoWRozByPbD8tt38Sxdf2Mg5yl+GgulGuExRNMOibyWukVYz74P/f344mwp28Fdouu2uNJpl7x1mXq6FdS0NykChjsGRDl1RKHMrEKYtXwx6Nn+9A07E9loj52QSFJUIyfTX8il9STtbeIEvgldxx/xJbfBezSMnMKvYxFNIpLQEqD7TkrcrmRX9YjT2lgVjIEIO3itzfLPNKTd5J7Ah6+JRnXRE6zPVHm/D4qd8OuRf6H7YIttvPpomRxA4VqOTIPjiPKF406/AseSMjGkabmS3SXB+MP3DQ+m/L46w+AF2QbpktdTnERtE6t/Od1xxq3VxmhKQh+utOpGtDTTrIZBRX3gxgqeQRqiPInD1e1QF2efvGX1iyc63qr8Ly3IvTImiWqviA5WfN7dN13z6HNlqAbVoBtw/uSRtjjSxs0j4/mEcGpPj4ajRDnaMM4Hg7HXbm4msJJ4gkkwT9SAVvjU+KxDVtR6iQzJRzPAB0S700Dkb/cv1Dok9UuN+NLdCcUqvdzA
 sIxezluX
 o7lZXjHHoN4wl+tuC/LUDjOFwxDxuV1SlSKvvUkHH6giYsH6CdqUt+/sClFWSy6tTdJ5jrG+ctvDMqjls6/Wd6pqXHfXRvs5E4ffnkjHiRsbSHuNaB0uLs5Qt1/6Y3B6XK68sZ0cxUYlRTd+dbIFMb2cqzIJEWF3IYJUjafQDDhQOfZWdi/Odww3d3vPhJVUC7JrqgkltW4xu1rfVPAVw8gqWMP7uHycVCwhhdnZfuhImBRmqt52ujKxXuN28OprKMwdmRISf1IYYWkwUpJJ7MrV/dj89h/berNzrWIIB6UKcZXEyjPAprJ2piytwqi8+Cj7M9xCHJFBWzcXGlM9s/K591czaLUmDLe1YZCC7C/pOP+7Y1OYMKWCcCAk7Nu8lX2rF5DkkEEtTccLmxLzoR0YdY8xoa4YfyiB4ovKSpIN0qM8JbU/msNmYE8dZRD5WmeJA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
>> anon_enabled_store() with set_anon_enabled_mode()"), refactor
>> thpsize_shmem_enabled_store() using sysfs_match_string().
>> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
>> calls across all branches, reducing code duplication.
>
>>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>>  					  struct kobj_attribute *attr, char *buf)
>>  {
>> @@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>>  					   const char *buf, size_t count)
>>  {
>>  	int order = to_thpsize(kobj)->order;
>> +	int mode, m;
>
>I hate single letter variable names (yes I see set_anon_enabled_mode() has it, I
>should have reviewed against that, oops :).
>
>Please give it its type of enum huge_shmem_enalbed_mode.

Hi, Lorenzo,

int main()
{
    enum huge_shmem_enabled_mode mode = 0;
    const char* type_name = _Generic((mode),
        int: "signed int",
        unsigned int: "unsigned int",
        default: "other"
    );
    printf("enum huge_shmem_enabled_mode underlying type is: %s\n", type_name);
    return 0;
}
 ./a.out
enum huge_shmem_enabled_mode underlying type is: unsigned int

This will cause the following check to always evaluate to false and
does not validate input parameters like echo "xxx" > .../hugepages-xxkB/shmem_enable
if (mode < 0)
	return mode;

So i think we should keep mode as integer.

>> +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
>> +	if (mode < 0)
>> +		return -EINVAL;


