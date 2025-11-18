Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F436CED63B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 13:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4669D6B0096; Tue, 18 Nov 2025 08:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4166C6B0099; Tue, 18 Nov 2025 08:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DDE16B00A4; Tue, 18 Nov 2025 08:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 199256B0096
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:16:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B364657EF8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:16:30 +0000 (UTC)
X-FDA: 84123776940.25.CA5A004
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8DBF110000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:16:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=XAeXYZ7H;
	spf=pass (imf05.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763471788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGQZu3FbiaJ335e8QsW/UT4FYzm+jhTQbf4DkeqY++4=;
	b=d+hnH71MYw4hTLGAY+DrJgdIFotzyfxsIkMSi5c5trw/XaIN+NAh0PWTB2z3adzKtz5rjm
	S4TbVEnQP2bHQpxwdvvakLGqgPcsGQNxE85rVMSyqprUfDkf4+QgSodMPdwTMYiC/rT6zI
	rlVZyB22CnFunfwJyU6dyQ3uoKf0w6E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=XAeXYZ7H;
	spf=pass (imf05.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763471788; a=rsa-sha256;
	cv=none;
	b=IQlb+wNnYBd+MhdDgHYnrZmHCRK2TGrLtOhJFKgf+7bPlaPkZcmbOduyV5ch355Ap7k38v
	2zCJdpjYG9YgBb1xqy1jxPFZRdRvoajTRRHNhwsdAjrBuEC7cN9xHiqQUoBWmgEFg7vftc
	vKigWhSZ/xopRNjgjhu6IRlg1S8LKMk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763471742; x=1764076542; i=markus.elfring@web.de;
	bh=fGQZu3FbiaJ335e8QsW/UT4FYzm+jhTQbf4DkeqY++4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XAeXYZ7HhXDJzEepPwCPBs3uO7b70umyjzGOOuRpo7dhoSWl2coa/8dEaI7KabWz
	 i2c6dAHitj5weuxfy0eRV4bWDLHwNxS6XXy8vNiv+nGZWwECrsiJCQESe1t+o4Mie
	 4Z699CMFKRR8jdcfUbLkDGVo+TGf/VkbK7OTxSUPKOwJAz+StVTHslKAVuvKOxS5t
	 9ZGHEvyBttQh+FgjXiqK8/l31JGHqOOueTJSZMQA5xaGRUedNFgrjc2yU89Wxx9aD
	 069PwNqwrehlem2MqH9IkfuhZmm9pbRoyGHC//BZrL2qe0FFpg0KmZOJyVHiW86ol
	 DniXxKRA0Zyer4TwRQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.234]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mq1CA-1vzaBA2DdS-00dOQA; Tue, 18
 Nov 2025 14:15:42 +0100
Message-ID: <76cfa66f-2254-465d-8977-28915ed5cbc1@web.de>
Date: Tue, 18 Nov 2025 14:15:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Sahil Chandna <chandna.sahil@gmail.com>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>
References: <94ba6ef88d97eb1a5e20eeab9f913be8fdc46fd5.1763227530.git.chandna.sahil@gmail.com>
Subject: Re: [PATCH 2/3] mm/vmscan: use %pe to print PTR_ERR() values
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <94ba6ef88d97eb1a5e20eeab9f913be8fdc46fd5.1763227530.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZzZirao3hDsSPFt/T1Mpd8nyRcXx8yf9hmqeo9hlvcWH0jnbOwy
 izCqJ8MQQvJsORaEJ7QE6FCkqxhOvvppIFLVwVuV5XZGZhl2vaWM6RGi/dj3MtDOVVB9HXN
 JtNJ4GqfxjmC2RoVikrctrXd7SHG74b+n5SpBAU0ufG9nd9AfD6UJWpRTK8kQXBr4KgXcoO
 Ai2Y+tO+JHYtLFErHNS+g==
UI-OutboundReport: notjunk:1;M01:P0:IfmTe5zFKo4=;f1KO+pda3pGSNr9RNtyjRELfws3
 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
 qYkdsHGUt46ZER0CQ=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8DBF110000F
X-Stat-Signature: pgb4so8aqdopr4yeb1qtodnr85mo1qg8
X-Rspam-User: 
X-HE-Tag: 1763471788-619001
X-HE-Meta: U2FsdGVkX1+2Mx0mJ0gedW4yEDtLzk74KrTgoyhg3+K6fC5cQaWjpRBteOL3TnpHwWXKH99yxEnfUyqfyXQJpb3MwuzvJKMwytqjM09bmarnhKzBwy0b0T6LR3rF+tSh6b1Y/VxrHl93eC7AYbrR6MvEmKkq8QyKAza17vh1CfAHUJCCcuIh28PuLkH/cm9oIzkwEqoEdBziUZ+lqrrYImolJv9LI/cSfYbw6u4cKpnEcwZ5Ez1VCHiPJR++y4S5hYM/6TlQgfOmMFjD7ZwrmF4/8PjxGfsNw9tKLNW9teQwTfdRU1+uQRVEms0ytOLkkpYDuFRvTaTONvQa54MQpYN3RqT/6XUyjDQwrDEoDrDONOnON8DVEF42qwsR2ttzr+UfBr3T9neq/TeKoMWxPOi9F5+73MwnZGitE1y5AL8ccxMRq8ehb1GyA/UbmwWghQC1Wb07Gm21zLVQZMAlByi/+6usqCs/OTgZX/3qmmZ3IF/IybSseS14podbHCizMghvEFKWGRHIEoI9NNDpa3ihC+sNPYxOHsaK5zmthj9cg2K/RgWjhNn4lW7VLT+7nIr24S4D2RwuXYQesZWzFb+RuPcOfgM7cpiK//uQM/qW7DgysbCWTa3F/m/IVrm+TPmgf9Zgl6pNRCNkbv5lDDprFkpvDg9CwGSmyyPUkp41b3hacxes0iMclYcDTFVTibSCg2k/ChM6wypDConhwGIPY0jJkWaj2O0wOM+jFDUb+59uTgajwzWCPOSMBVM35hVjT4nFFgL5ZO47S+rkxZnJI3AD+gdRT7elnRL7725pmENhqNZp9UC5zQ/xZpLmPFbawBS8re3Jza44X7IPG3rwbnkuYO38xv6Veli3WCmYfiFw6YaGW8oiKbJab7uDOGN5wqohyP5Xg3yHS+RqWbaEndQPEH0OvZHVm79YkgGQiUZAIH/tteExHw8NSP/JDuoCJD+r46VuJ1Bh/LS
 gsB4bDPU
 BoDlSsNv7XiWtGp3BsBTf6IHywKYqb1jWWKsIALlw8ZDMW5wA9DLgd9tKn86qIGr0x0LnpyWo/4ymRaTESKFLyH9fhJIebwSMsfoG3jUeme3eJ6eXTqEsO7G2sxzFreOgEDxD4QhDeBJ/85aKsmexkcJMefek9ZN7NZpPVPrq6FsG5czeR7uO5YIgm2V5nJ6YztIQikIoPLjEcDlpW00fd95JmDo/nwM/MOlsO/EcrIpRMaLCyvWhN/+nhJREa58bAMwjh50Fgps16l7HJDqEdO1+Jo3io6aazsDwn6m/jWJaJ/H6XIsnG/gxMVF06u3xHKV7V83ZAlfBrveHsXu7It2PC1/rlabo/d7TiHoXWdNhs8Jd53LhdbMr9UpOsVcgaC03NHuiqrUqNHOUPUwHi7rdLAH2glV8hiiEZrQm/Nc2+3i5X1WCavGlJMi4uI4bFsV8GeP8vZB+KwXwGVaQNt9yLNr5h1ljDc/Fip9k3bCnR+o8gbYTjkroIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> +++ b/mm/vmscan.c
> @@ -7500,8 +7500,8 @@ void __meminit kswapd_run(int nid)
>  		pgdat->kswapd =3D kthread_create_on_node(kswapd, pgdat, nid, "kswapd%=
d", nid);
>  		if (IS_ERR(pgdat->kswapd)) {
=E2=80=A6
> +			pr_err("Failed to start kswapd on node %d,ret=3D%pe\n",
> +				   nid, pgdat->kswapd);
>  			BUG_ON(system_state < SYSTEM_RUNNING);
=E2=80=A6

I propose to adjust the indentation for the passed parameters.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.18-rc6#n110

Regards,
Markus

