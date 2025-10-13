Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0909ACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576178E006E; Mon, 13 Oct 2025 16:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D858E0036; Mon, 13 Oct 2025 16:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C1F8E006E; Mon, 13 Oct 2025 16:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC678E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:10:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3E2B13B5ED
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:10:18 +0000 (UTC)
X-FDA: 83994182916.21.B4B3AB4
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4EEBC1C000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:10:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=oBDRFKbZ;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760386216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0OByzRAdI1bKsCWZYB46xlFw13WEFPjGEh4rNhssjs=;
	b=XPCMEZ6CPa4wp347rougxwr2GP4SZ4cz3m9NlGbbBKQeuhpKrzjSszpuZYdMO5eaHQgmX8
	e9TpBRgGMpRJZXfm7w5v7f1sSGvUR4rLo2tP8IJr4JnM2i72t1dKB8jkMW5ByR1k9NTXfx
	uLju5qCyULeW+znKG0wHDXkRknuiiAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760386216; a=rsa-sha256;
	cv=none;
	b=aixlA8MJpNi7pcCiaN8W7S8NLzMqNKE1LchjSCwpRvbO1wUpyZwLARk75aaVuX+Z/rV+7X
	bGquy5H6B7+v8c+Q2rgaoOzrrwjhTMTvcQ9xnbBi1NHRAdjy+mi8tUqXPS3efk3F9APrgd
	acjwVpV98hS4kFBvC7IMgM4i1AlVWy0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=oBDRFKbZ;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760386209; x=1760991009; i=markus.elfring@web.de;
	bh=n0OByzRAdI1bKsCWZYB46xlFw13WEFPjGEh4rNhssjs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oBDRFKbZ/rhgPhqnz/JaW66sBWHc+clg/jm1sAQiiBZpAY2iKo2MkS9YBhiSU/5V
	 mibnK5Bopgzl5br3ppIKfML4mbrEkd82JHDqdiOI8KUD/77wgeTpH0OOXnOeARfe3
	 ufVuzSFWfQb1hyKXyVYs/OauEio0j0wKMdk4yxVKkmF7y8RzUUfTWiAk/dI2nlk7I
	 vOIKwyQvcns4FMocraxVvV3mPz+78fF/Obk5hq1x18j9Fu378P7jnNv2m12IlPeg3
	 OJpodRw5KqZDMR+nsERco69U/bfPBC2dGrsdYlDBJ0JykaT/ZuVatw3zmNG9UlYKN
	 e+JH/t7IikbrZjLjuA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.175]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MBjIG-1uwK2n0f2C-00CVi4; Mon, 13
 Oct 2025 22:10:09 +0200
Message-ID: <5e20b91c-c4e2-4450-b038-6afbdd3297e2@web.de>
Date: Mon, 13 Oct 2025 22:10:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Longlong Xia <xialonglong@kylinos.cn>, linux-mm@kvack.org,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Longlong Xia <xialonglong2025@163.com>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, xu xin <xu.xin16@zte.com.cn>
References: <20251009070045.2011920-2-xialonglong2025@163.com>
Subject: Re: [PATCH RFC] mm/ksm: Add recovery mechanism for memory failures
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251009070045.2011920-2-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cZdEeIWfCMiOggcN0LgpHcIIlvgr9uVN1xf9O1Mrl6iH2fZkKdb
 c7Kbs4uENGjLRnu1sECLRJicY01IL3MQesmfw52LKeSbNhkGHXgeflj06WLVsHlBnlKHoji
 39I+m7XqvPLAaSoqW31gaYIfkwHl6tcipQyvaHcGshxzepQBxre/JHE9+Lfm96p/DZHohYE
 oy1gWNzQUxRWkyxmGO4/Q==
UI-OutboundReport: notjunk:1;M01:P0:zXn+M0ajh+w=;HqX2lPoBAwIAcNqSaJswimLVIvv
 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
 0gf+Uase+/QUrw==
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EEBC1C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: 55kifxcie7q7af3butkg1fyipguj8mfc
X-HE-Tag: 1760386216-677178
X-HE-Meta: U2FsdGVkX19mxUoJQ5K6sOM1Th4qohnQT4/+X7/K0s0r2KPzZ3NXSmCWKI60Jn5z2axTPbwVaTfA9Mr+BK4T9Y/cvft7ZBOLgYsLZcA61ZISIL7G6eGJV2JI+tg4j508FeGXpiNc6dmbJuc49J4/oTqAzQDSjkejHAIZuCZxuddkuSqgv4U0oeEgtPqDiZVT2xNF4bisFndpytfPiudw0lfWf/FAFCCQnObiRm9AbxIerTnOCyPWZiSeLoMoeIYYrYstO8KF2DtK5qqEO5fEzNn5rjK+MRIzDrAq5Ev9a8/2o3QuX9q9tPyEVkRpRyknIujHjmIRWQi1uCIaMrEb1Pymfe/mqpvHtSyILdepjznlhsCkUt8ZhWn0opcIxY3QeeS9dgnrYXNSY3BWXkM7J/BfhkO8f/kyCCQO2rSK6eO2YoOcjxFqN/9fEyMPvZwKMvGYx/ecpCDDh6u0oevfditxgfYbnH5KEmNaVhDJ7H9ehT8vO5nV+HncHqLsEzVSGbZNDZfXfaQCK8h6Solt+UhImKdBcU7f1O6mR5x3+QljEnnRSagWdncEmB5pKG9/vv3J2cCXJslb1s3fNE5gEsGsWOVvjXMlcQfVG6VTfRupEqg8azqxLD5hAJ03csqH30X4u300OOgOXBVQmMK2q12xS/1dt2VWsDLdSZjOFRHnaFo+02GVQVnsXmN3ENbKpPbhyqc6Ynf++xVlKHQgr7cAHnlFG4ubg0mnhDhJxYVSlk0w141m8w9h8fwV15l5WIV8X4ArWtd/C+GzOMNErWhVFirIrHPhA3KnJaLY7ISYaiEMbWIKASJQADXdtPHX67viOJ4E0gOHDVfOsVFOA9i5F+ANW0K4jD+7WOvocwGQ5UqNufxlcR3YZTGqWFvu4gKeayKVM2PGlMwp3Ixd7tV93Auw+r5BBhLFHG63uSoudc+7XIS5SI8TOjMJC5h1X5LH92EGwiV7eiYH2W/
 Ex+i9aLO
 +JeH1tv/cjIMl8eS37hZdU+wIZiBfuZ7eVRBdAoXypCNPsAofKfZwUr5q/7t/uFdwd8XrmvSawLX+sd1LXJUml6JfwdRVbRahd7OFjfUqcJSfEKPJdzzsuMfX67g7Q4kr1QD8ja+ffEblCdH9v3W+c2sEJkb05yDUKgTAvkYDV9674uAa8D72gT/2fm1bcTK3bjUzCMG5qI87igoXjy+ilrd61XWkK4CjyCkrad82q4mq/JR50400uWP6kTYsKLOXn9iYME/fhL7IRErqYAXiX7PTkIQjDEtrYKRDPnbERecW85zxBVpnhrdCeTshF2+WRVAajBKqAm73PuTz5ZRxSHi0bw4SpILeNtkWiq/e3iRYR3Q87gQmoIp/jSgCLQ5MVA7QlFgKabIoi2lH4gS9BZQJMxJYM4O0H9eyyLAlO8J4FOTO69BpDGeBPZzuhsfmAUs/4nsB8kesZ/I4geDykwy50zOE/18SrxGqE7XFaVI/TaZF06sF16p1FjFEkFNPIiC1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> This patch introduces =E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17#n94


=E2=80=A6
> +++ b/mm/ksm.c
=E2=80=A6
> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_no=
de)
> +{
=E2=80=A6
> +		struct vm_area_struct *vma;
> +
> +		mmap_read_lock(mm);
=E2=80=A6
> +		}
> +
> +		mmap_read_unlock(mm);
=E2=80=A6

Under which circumstances would you become interested to apply a statement
like =E2=80=9Cguard(mmap_read_lock)(mm);=E2=80=9D?
https://elixir.bootlin.com/linux/v6.17.1/source/include/linux/mmap_lock.h#=
L483-L484

Regards,
Markus

