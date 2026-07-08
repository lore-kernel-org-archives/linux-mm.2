Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8F7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B7F6B008A; Wed,  8 Jul 2026 00:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713466B008C; Wed,  8 Jul 2026 00:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629346B0093; Wed,  8 Jul 2026 00:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2916B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:17:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B41ABC3EF3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:17:39 +0000 (UTC)
X-FDA: 84964300638.28.B67E66F
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3F658140008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:17:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783484257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M61sMJLZaquQVkkka0YzELZxJUPrEoMn6bjNAFQnfj4=;
	b=PXLyRL+cbRF3HYmAauk9DLXi/7AIUguPGujK5UWDYC9JiXakvlu3SPX/RL42hx2ZKYx9GN
	QCz79AOuSzbiqyiabpJjhqz+jLc/SGF31hwFKl4m5E2Sh8+Su7hk0XYYr7SZ4edMC4Nqf/
	YQtD826zViSnL5DFR6P78MOIiiT6dHs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783484257;
	b=PEniwGwcPnyf47Q8XF2GNErhwjT8YctNycX+r6gnY5rp+5pF8nqECLTAF6MqQhVhyRepxk
	LsAojMYwHR5WK4lAsAo8RklBZpL1CWis7yV3/lU9okk3qM80gzVUED5i+4skAKZtRkRuju
	+0uarbVom9j0z8S6/Pl9q+omWWfwnfM=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gw4Z50Qlwz55RJ0;
	Wed, 08 Jul 2026 12:17:33 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6684HQJL075143;
	Wed, 8 Jul 2026 12:17:26 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Jul 2026 12:17:26 +0800 (CST)
X-Zmail-TransId: 2afb6a4dcf56b6e-4ba60
X-Mailer: Zmail v1.0
Message-ID: <20260708121726084JGE3_Z7FWvU2CTGNEHJi6@zte.com.cn>
In-Reply-To: <20260708113616415f3tkwZLqvjZkGqWYbBk4t@zte.com.cn>
References: 20260708112943731Lz7DsMxSAWtV6I69GjZmU@zte.com.cn,20260708113616415f3tkwZLqvjZkGqWYbBk4t@zte.com.cn
Date: Wed, 8 Jul 2026 12:17:26 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IG1tL2tzbTogVXNlIHByZWNpc2UgbGluZWFyX3BhZ2VfaW5kZXggaW5zdGVhZCBvZiB0aGUKIHdob2xlIGFkZHJlc3Mgc3BhY2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6684HQJL075143
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 08 Jul 2026 12:17:33 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4DCF5D.000/4gw4Z50Qlwz55RJ0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F658140008
X-Stat-Signature: 4637tdxd9x5nz946g9xzkex4pab3e5t7
X-HE-Tag: 1783484257-575763
X-HE-Meta: U2FsdGVkX18oARzeTPQMHwGAUcbSyyXnctY3yootTuXPFA1m7SPno432qjPMdMtcHyxlYMT4z05gF33JvDhziLJrZt2zJLhG6EHnjyEzuxZDH+WQGAQMLLpF6Pwq+5fqlNtLOR50BxAxohm1cecigBr6lPorln/wn3fzlqzCKH77l5u9mlZJHOWHxFhYcO1GP8pCuYkCWnnVGXBUEn+CaHRSkmpsyT3rpVu+zBK3Xlh88QbKiTlpnQ9xyp0admmnN4jrcXu6GIoR1Wc+VV8/WPeIqqB/ViCykrPaziM4SUo29LeIOpOEKW94iiOhHNJj6bU0ZG9EKVGh8WpKyvoTQVaRb2lUVqFvYRZF9rWSdF09GDn0wnc2IATKzCCwODT/CzIGc9+dCDCaZCDEzeQBoeoU/Tmu35GGCI9CkE/hI+jzmRcpPtzlmYvow3HlWwSsFgqrLSc5Y87wp/hJ/gYtahTCQQs1bb7lj//DJ3aPX6jZXDyug91WsNt3SDEjEPp5UREydiVNf3eD1xuE/LJvRwx6YDKEPYEUZxMJza2ruvqf3c+sbn52eekc1FAsg8i2RN2zvlSodgPt3IWDi0SmM4xDlihc9puSMpHOEOHzD9RWY7AiHOnosFBrQcPitCjvRXSsve51WV0Q4I4djCNzWZBd3U3GCp1ivoL3vsCs5bm1Z45wkeSkfPvecjkK9OiP43SS9sF5jI9xjBc0j+Gqs+mhQ3bWu7/qPlIB9qOs9S+do+R5JLhoVVa+2aY6abFKA6rLuVJD9RuKpnNIUr00ECmIEeQjWP7tRk4+uMPkJ0jW7Q4rCX8u1SGreaQbdkUKS+gQ7yYqMCtf7/juE42vpyOANtB/35dFX7fFp1XfXLCIWHmpHA8DXnmpNvntXE4fqNXKxYw3RfxzSR6OkM+NtTYxfF1fhANc65N0GfsjqaC71+XF3LljUdNvTl74b9P6qXL2RyfDpcwO0dC+Rlj
 J3l1x+KU
 xDJNUdC8MOsL9tY2jecHU0mcowtob97/cXOS3yMXmK/9jOs077S/NAmXJOrj9FWBedDSA0DudBG0fCzfdq1aJf16XlvAe5DoC/OaTsuYKMWDENilp1BB4QpIC4MNpSkCPWjZxbdvc8UEEU89uaL1Zw7mybInb8x2VJZFUr7CniDwu+gmEjzYrrtj1BvpWhBvfZei0Wh1i0SUJh38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oh, the subject is wrong . Just ignoring this email. I'll resend it

