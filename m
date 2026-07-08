Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0249C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7773C6B0099; Tue,  7 Jul 2026 23:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728E16B009B; Tue,  7 Jul 2026 23:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641236B009D; Tue,  7 Jul 2026 23:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3918A6B0099
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:38:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA7A6A0646
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:38:30 +0000 (UTC)
X-FDA: 84964201980.28.440C3B7
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22C7C140003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:38:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783481908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3FodyK3IPy2t7mIPJxV+YnUFcxTJTsPLhT5Omn/DMtg=;
	b=cC1UlRvZLpjND8ZoE6ssNTb1u6KlO5aOjlW4b7i0kzg6Z2lOKy8LmPqcGn1crfL92x05VU
	+1GV+l1QXp21ORhz8pXspM30ciEDg6gMKthBYrqUDUvqvGWtTyDQLFvfNXCjh+GnwbvUPP
	Tabb848fG80ly0YwNy8sBVwYDQlGVHs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783481908;
	b=Hbk3izydszC3oIsP0T8VzK9cX1sxB6J5iTHi3fxz1UKPV/iFaQchFnuD1pwUdp8utJqzua
	8gvQq/W2f6Ej0+uiYe71ZPIL3Os+TPq7gwBErih/rco6Tw1sVJMo3zYLWlwCMrztcSTgkM
	HmpbPhGvsHs0NUVhOD6Lv27VlaKPVyY=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gw3hx0ZPXz5B1K3;
	Wed, 08 Jul 2026 11:38:25 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6683cIdL009181;
	Wed, 8 Jul 2026 11:38:18 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Jul 2026 11:38:19 +0800 (CST)
X-Zmail-TransId: 2afc6a4dc62b80e-18733
X-Mailer: Zmail v1.0
Message-ID: <20260708113819554pIZuGzMiKKrOwHvNXFBZ2@zte.com.cn>
Date: Wed, 8 Jul 2026 11:38:19 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIFJFU0VORCAwLzJdIEtTTTogdXNlIGxpbmVhcl9wYWdlX2luZGV4IGluIGNvbGxlY3RfcHJvY3Nfa3NtKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6683cIdL009181
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 08 Jul 2026 11:38:25 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4DC631.000/4gw3hx0ZPXz5B1K3
X-Stat-Signature: srkd7j19g44ymgz9wpgd6nmd37fqhgw4
X-Rspamd-Queue-Id: 22C7C140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783481907-754562
X-HE-Meta: U2FsdGVkX19Rhd0gMP5JD+2eoAwvaocsHwPU+TOVdl/tQMRyGZtD0fTRb2Wfo/0nPvkBPVwnkQ4ntbhu985Hv+2qgZrEqCYlOHqVOKJ41vXHdX1mqT8XdrjOG5GT1BZNf0C0HYf03Fg7fe+eqUuqn7jvhYlogQs4YFPHdjORT+d8MlHNaJJlV+Sfof+og5BX1BcHX6bfw/fzMOkeUgBbQcCEi209YlZgvn2d5laonLH2YiA3jzyjk8OlucRyEvi9UAZxBAUlyQ++3ensPdzakxKzWhqNlmiMxHTHf5X9ZU/cqYR8alkorFVGxZxNOClq5JtKKicTaspSgFdBAYUvfYwm8OjAXucfMyXESDfDLeaz5iLB3OTvcj/lN5EeR/pfLmgXMb1y6RpoQIMrWkNsKcAy1P/XKpvYvWjVgfgb/GUTJWCMrZ3h5yA0c2admF27g4zITX4/Mz7TkLJuPqRw5B2AbnAM6yCo+p4Ki/DqoO/kqdgSlRmzPuXbosaboGTxz/m0XddAe4fko0j2b3vGl/oTD3r52U50480vG8h5k5rRB7H1gxEO33H5VzyBATrkdzLED3ntbBBxAMkadj/nvphy10o2vAFz2woEMct5Jq1TUHnPLND7+z6C47S02XrZTKloVosZ73dYyVbHoJ98yaPVnEgzeUHP/1OOj55aCnKc8lnFkWmUyNLQnbpce8Y++BZPBs+XztoHEJ2AijQRLl2lGr8zNE3314nR+QIuzBu5S5QcxA1GeGMBfvxcZNEsT9f9ave2iN9YxAGLSI13cZ7CZ7LXwKzlPQCJ8zAdGaaU+sEhgdA3QhRbEMP63gMLZ9ep9PzAZyCXQ6s8g4oyj00atzLPeCzthpNn8KE5ftsePYfOiPTl0DsIKNiFVhdDJBS4oaaO7cYR7FEeqx8OopxIQTpe/dUai26Z1DDq6K6rGLFqdW5MCQwELN3unOYQWgfLCylvjZzUkLF1PF9
 KSgvOend
 kQRBfXQA+N05utznOqAw+bEUfNa5vuZNAPbqXfByCZBMbNMcWKL/+uGDkFCQsa33ms58MtxSQeVE5lKxtkHEaW2OdI2yje/pl5IlDUQcckFIWplm649yz578UaNBMLnRpuP9Bqr3rkniNZwS2FTW7OGF6/xrIeulX2/EitaQuhcgzrhaYdzN1WemSTIV7ejkbLduG5mYXlolzPhd7Dfu/28erEjbSbNVcC2MtTugMWOdR8s3N6ksjF+dG/GOugnp5DEQpoTATrpkzMlRIzta5C6RwMjBqbJ8HPaD5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From 65241f800da589be1981181d1bc3efd69a7d0385 Mon Sep 17 00:00:00 2001
From: xu xin <xu.xin16@zte.com.cn>
Date: Wed, 8 Jul 2026 11:13:47 +0800
Subject: [PATCH 0/2] KSM: use linear_page_index in collect_procs_ksm()

In collect_procs_ksm() which is used to collect processes when the error
hit an ksm page, there is the same issue with rmap_walk_ksm (see the
previous discussion at [1]). So we apply the similar logic changes to
the collect_procs_ksm().

The patch [1/2] move the initializaion of addr from the position inside
loop to the position before the loop, since the variable will not change
in the loop.

The patch [2/2] optimize collect_procs_ksm by passing a suitable page offset
range to the anon_vma_interval_tree_foreach loop to reduce ineffective
checks.

[1] https://lore.kernel.org/all/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn/

xu xin (2):
  mm/ksm: Initialize the addr only once in collect_procs_ksm
  mm/ksm: Use precise linear_page_index instead of the whole address
    space

 mm/ksm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

