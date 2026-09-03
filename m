Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F60C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6D86B00A2; Thu,  3 Sep 2026 09:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5983F6B00A4; Thu,  3 Sep 2026 09:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC956B00A5; Thu,  3 Sep 2026 09:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A23B6B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAEE51204FD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:05:27 +0000 (UTC)
X-FDA: 85172472294.23.819CC4E
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0CD8F140017
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:05:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=I6byXRFO;
	spf=pass (imf26.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788440726;
	b=0Uy2zYoR1kBIiTOZ3l9x3sSYjBwBImp44k4g5m7aVRa5YKPorRF7EAm27MXJe8PDX+OyA4
	Vyyt1Dh+7ziw65/eLoTJl8kUNwXrVew8JgDKuSnH/M/Z9fKLp1AyZYcqCgMZf7137cCaeE
	VuzmG7VTJRzMYMZXYOV13NQc3Z/ELZA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=I6byXRFO;
	spf=pass (imf26.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri99RnR3lTWhl+hn2Yk0ksLghgMmFBeXXT4SDf6YodE=;
	b=SDr9M69GA6hYxAu3apWuscyhj1g04smX/btzk1tg3LpWMEROUwEqSlg25FTgbHzdISf315
	vyQl/8nPu9lq89Tadr4r58AIscOb2YHcc+In9Dy3JyExpCXNU7/AfVgBNNmnuou0vEXU07
	SgVrZx4GVWo0fWKzRQWcietsdaIziFc=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4CA7D408D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788440724; bh=Ri99RnR3lTWhl+hn2Yk0ksLghgMmFBeXXT4SDf6YodE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=I6byXRFOCo2HjSbU6l2QAhvnQeJvaHQkGz0LJZ64KUtDhJRqJMcgfPH0kOSAScVSV
	 kcwYLzexF/dlV4WGtCwy74ahS9Y/acvl39jZyImCA1K1Oau99AQ8J6ax1UJRYddLXJ
	 2dOA14s4kE/YeZ+lEeka/eH6aRzuHomYr/+Jev4sYJBuvtGi1IwMKdkmbrLwyA/LPS
	 BXJV1GWKVi/t1d9/TMiX0N4JEQCrsZm6diJSY+uZ12caOmLEC6s9bzx4Kbed3o0UEn
	 4V2hayIqs5Xix91QaN7lDdWjX6t/f+qkXVhGuAtADNS52F2HsfhHq5W5DSBGkHLnf6
	 WmXdO4effSlDw==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 4CA7D408D3;
	Thu,  3 Sep 2026 13:05:24 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebnerli@mailbox.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: admin-guide: Fix bracket
In-Reply-To: <20260903063257.711435-2-manuelebnerli@mailbox.org>
References: <2e2333a9-dc4b-49e5-a09a-47fa502e0e22@infradead.org>
 <20260903063257.711435-2-manuelebnerli@mailbox.org>
Date: Thu, 03 Sep 2026 07:05:23 -0600
Message-ID: <87v78m7aek.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: rcybwmu4hgfs6opsqrybz3tyycicwgqs
X-Rspamd-Queue-Id: 0CD8F140017
X-Rspamd-Server: rspam06
X-HE-Tag: 1788440725-676031
X-HE-Meta: U2FsdGVkX18G0graO74WhfGUVZb4acs5iNwdfnTFq8WNF6fFyJcUE7giK0G35SCuhjzGOyRCveRhAVjEnlmdlRNO3jF/h8TkzNdeHLpJYF0cYLvItmiAkyj4WsSDMG16XQway1iesFs8bL0tqcOigF+jolBbX7l31hNS2vyIATYkWE3obaRntBv4Tl1RSr1Y1pH+6pL/9FDZBjuAejLPOZisiSC+F80qW6OKkRvL+y5J67KZ2Zrz/Da1atEfg5qEeEgL6mB6Ps54soYTXcmKmJsQmu7zjkys33oIWfKY5ujJDVt2KCS2rvsA+re9kcmW7LBdiffKoUJbQqa5cDKXjBGUoZl3qHUhPJWIi8/SxubNKyQdJUMv+20TbZf7W1MwerG9JRk7ntlmXPH/t6FXvbFyuXdgfB88I85JKEIpeQOs9hss0P4tlDjYi81/NjOiKCSDWXro9xNTCInK4awv/5N4myqGQ64jeqZvK3vWf9FKGG2dIIpN3qdP2GMnseOK5BMp59/OFxT61JVtocXHHUv61ytFP/8iJwYmccM51mdkFPrHkdit2T8CrdXJHJB7Xefm6Y1pHiA7LURoI/S1VetwGgfKN/3Kzk9YJT6DmrjwG3pE1Tu3RSZXaunx3+q1bgGnnZEIJV9cZt4h7TqnjvCIzfrFj8wR8BSa5GonYqGADQAF4SqUR6F9ccn210hAZ6L7oODxioG0TWdqr7p0nedKaY2SuqwyBIGp+JJHjDJTkEGeRJcgU/J3sJQVyrFpElnIU849wnhhm9ulGLbHmQ8g0QmPIKiC3VTPngxgR0T8DscdMkphWnnsF/ofB/kRLYPgprjRffLUqwAK07Lt6inGPk8Akg0lt5HiTDLrSXAwN5wc8Um8KUwLk4WneoFsWYhJ7EYYqQHWcB38NN13C91RAEnz+r/VKqW5ufNXXi+ltouGAwtqYOWdTsy2DXAlh7aD3i6Jqzbl2CVOOo1
 sX5CPzhu
 SDEMgE2Y1dpVmYY8Y6qBNMz0/24gLoUJvmLE8j2oD6oMonjGlie4JTZm4xPoqRIpLSk2AiQEXI2WK8IBkx0Xe3JTeclJGBYYEUEB/VONMizA1F3FBBNUTWq4CIV4Cbq4Hv6Tg+DzmSmXuupA9CRTIb99CgI/9iKv4TVjhto9P8oE4TZiaUcWYu6Q3MY5pnPDQTSXVF8wOkBAe3apiOFY+Yqt6p8CN9hw1KaCG2tji4vIE+dLai6gp/md4f7AO1RL/wHekNT75lmySBtINJWTJxZzSlcQPFz0K9pOZGLasugFgDvFBtB4TrB8KazUtaI3jZNaXq1PTRnfRglHoNYbsGLj2hNjdONgPUGXFvTwEZ2Ti4V2gergv/8GkvI9imAvpzDH0VBxQzwDl6a5gYhFGai0g4pSh1amrjp9sDPoTYnAaWnzrj0HstvmVM2syZgWtLcsR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manuel Ebner <manuelebnerli@mailbox.org> writes:

> Add missing ')' and remove ';'.
>
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 5b318d17a..5f4a056e4 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -438,7 +438,7 @@ zone[i]'s protection[j] is calculated by following expression::
>      = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
>        / lowmem_reserve_ratio[i];
>    (i = j):
> -     (should not be protected. = 0;
> +     (should not be protected. = 0)
>    (i > j):

1) Reposts should be in a separate thread, not replies

2) Put a version number on new posts

3) Say *why* there is a new version - what changed?

4) If all that changed is adding a tag, you do not need to post a new
   version; the tooling handles that just fine.

Thanks,

jon

