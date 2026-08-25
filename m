Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9995C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66596B0088; Tue, 25 Aug 2026 09:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17976B008A; Tue, 25 Aug 2026 09:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D064D6B0092; Tue, 25 Aug 2026 09:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B203B6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:41:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 391C04041D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:41:31 +0000 (UTC)
X-FDA: 85139903982.24.BC737AF
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id B964C140005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:41:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k03XLFk2;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wExAbX1IRHGuTmFZoTigdFhDsFBtbVmbQyeLxUxZJ3E=;
	b=VCNePb6HVFR5WpGa9IrnAT4l5ip3UBAiKnlQgO5hz3J0XKRAJuJk6xtQikqPty7SW3YhfW
	s32gHSY83Vny1tKBVdzi0QFxyhPPRagMcMGSpQmJi/xGvI/Eb3pFYnKtkqD4w/Z3pNg55G
	hNcz79h9vSd24nIZmgPMxArz8xE5esw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k03XLFk2;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665289;
	b=oDMtrahlMfoXm0kwOzBW6RicFiJqioB/Ux50tYFikTH+k4EZh73BPw38MNGhaaV3ZvfQIw
	S2TlMF9iyaSmP3FAaercYrSDb3LQbgOyf1jeFxX/18aGVhFWFMFVDibS8/ElegNX0ojhiw
	PpoVN7Znw9n4UfLEnwXy0XU20jWFTpY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NOgJidbiGrJG88x44g1fJromHckoem1NyeL67+A4AJQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665286; v=1; x=1788270086;
 b=k03XLFk2Cxunyu6c/2QquZRO5H4voHuR78KDn9veJREeIaNlWCO/SJKcoG+oionnt3ykXK1y
 +lOlPIOpPGjcvpFKo3Q+iIusCAxDYS4aqDtKmv5vcWS6ES/IsM29e/aZP/AgXdtLUMyGtfoBoZS
 L5u3QiZDXYd1TdygkSRb7fes=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.50.204] (146.199.86.12)
	by smtp.migadu.com with ESMTPS id c020eec8f82fa5ae;
	Tue, 25 Aug 2026 13:41:26 +0000
X-Mizu-Trace-ID: c020eec8f82fa5ae
X-Migadu-Flow: FLOW_OUT
Message-ID: <ba18d382-556c-4f29-bce2-6780810da4fa@linux.dev>
Date: Tue, 25 Aug 2026 14:41:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rdfskw3rsqiba1hskhtrxnckh8f843mk
X-Rspamd-Queue-Id: B964C140005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787665287-151212
X-HE-Meta: U2FsdGVkX1+BLyhKhYZcmxAP/+LNU6vgfTIMsKhwBW5nTqqP/qagZ087YzuFMRokYHOVOH7iEb9MGlwSuXvZDVErspOgFhXcG0MliT8KbMqDOzh21fIQ7EFzs0seJJYxLWNVv5PTWgSHMMxgshkRIF5a57iGwDoHrIxj3NQUmQU+2Ef+okn56rECGiLYg5badqCZJR6CHtVYSXKWnC+IOVU0p1Mn0l/nbSQqhaSxik8Dlvw44Y0vI3f0oCN6Owcw1srWBZ4fI0pwvTErJp7KK0jwgjT12BJRTRD1ZDEBIwQsbggEkW0dlWk0OsNOlzR7HNc3LKmF/p3wZljnML5qw+qvo6wj9TnOyycHIUj3zxnyDnTpmHdTo0PWeooIr1xfi2kn5i947TRMU12vouUN0Y39+qvpED/aGw/MmF/0RYfIz2B11L6FlfgdmVDDylHu1BsJF8TJrRPy8jUnUkhGexXwIy3wpxRYBZUTutFgDRXlZJgaghxGz7sxRBMzbXwWCwRTgiFgmC0K53isuXs/CPSbobb+sMezrfT1HcxG/S8ESoqqK8dS48W43oavPol0bLE83V8Hb0upC7D//wZS/nxnm2ZyvLd5YWWk69/rcifyZgiwlYrl6j/kqySwnybYDKxrVMlYhPxq6TQr7e2zh61XNiqigcWKZDga8YoD71UrKTKwjOtxNwRPR3EAVyq+SOtqLUj/WMnIgrwL9k8kXYuiHTYNbb6OWCpb0JGbs7Bh7c8Bhbu2RKOk5LBASq1Lvqbdv+VIYlxYXvD4Ey0gj/kC2+/P1sogXbMS3sOE+n0B2xx5qObJLqAaLuOhIPACKrfsiTRnJfQQ/geJ0ZHb82/GZLJpah3K1GVY4JwUi3uU0s/kgN2ytf6NNTXZ9Ce6NhNBAsNSp/PCA40QOuTX9/3WxLmXD1jnAlPBoBA5EWRPbIKdHYL3AqSq8nrlFsoJx5YEgFyDIHt4uke1Nhf
 KGFmCZZQ
 dP+AhgnE9HLLxtYHv0fpbKUM7xQjModV1d4nrishcM2CWcLXOE6xuz5eov7bHt9DqiM9Y+s7FboyjAM0wh2RQUPLhZozGaYqAobkbPMjnsee0xDylJXgvQPN9ptLdD7CJjSLtEOJ7VlIuego15lx3Rc4J6lWXRHut+wrU6mhPINnXxmCXzTfCDQCQnZCtBXQkPecJtp04obquLdtM1WOmi4KI2qD/XL5JHHstB180A+4W5NNxvPF1VJUj+7sjHOniLCMM1k9rrDuEevKfUfgzSLEyMTmkUharpENJXlS6+18OfhmcVYmrpu7UKMrf5ETjc9Y9eWGks0ZWtdNp00HsbKTanqXTVRi8uueIeXHEGG4VKfFEwBtddUXUew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/08/2026 12:20, David Hildenbrand (Arm) wrote:
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
> 
> Nobody after us needs these parts of the argv[0] string anyway.
> 
> This patch is inspired by previous work from Anshuman Tewari [1].
> 
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Acked-by: Usama Arif <usama.arif@linux.dev>


