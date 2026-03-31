Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C0310F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF2A6B0096; Tue, 31 Mar 2026 12:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC566B0098; Tue, 31 Mar 2026 12:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13FC6B0099; Tue, 31 Mar 2026 12:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B26516B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:32:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47C03C34B2
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:32:19 +0000 (UTC)
X-FDA: 84606900798.30.A2F4E79
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id B59A240017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:32:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bNA1Fkic;
	spf=pass (imf01.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774974737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MAqzCf42QLu8TV8j9Wj61ROnuwrNN7bkpugWVreJh8=;
	b=lOr9AZNuipNEUP33hRKnMwRnfWBvG8zhPqehVYBFdpOMw1X7XHTgE/DdM19a5bRMq43Cvz
	i2Jhc9CFtWxXQQJ6jOLuv993SyIgdyUC4XF2232wbyPKzpHIKYdrZQPR3eZVEnUaN386yX
	TeZeS/FyT5D2VMgmJMOpIlGfHRDRZmo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bNA1Fkic;
	spf=pass (imf01.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774974737; a=rsa-sha256;
	cv=none;
	b=qf/ycVplc/2OFIlIp1zb8b1BnS6Xa+795TE0am2CcWClI6mzMoSLzvoZ0GcUwY64CjNy88
	w7xD+Qn8nI4UVHoQnJbgtgEekj40Bh7ZGZVUqfh6WaBZi5lNK0InAPnJS4q/tkx/XgKVti
	iSDk1Y8sYsYUse5KkVoiTvJwtM6VKIc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774974736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/MAqzCf42QLu8TV8j9Wj61ROnuwrNN7bkpugWVreJh8=;
	b=bNA1FkicqrCm6jyKo4l2lM7jy3dM/z9yxsjxAwrRBlXPNSCV013p0ACz1xuHxWdmGRNBl+
	4lTnFr7bj0vpYstQ0gVTHQxVSBThZC1wEhRFt55vSajzS0/sjgmd+NBDLUtMcxj2cQTNkW
	irB+kjoqjsoR56lDyWVSsBpkBuHbs3E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-ON8EvXtePNOdxzNh7juJ0A-1; Tue,
 31 Mar 2026 12:32:14 -0400
X-MC-Unique: ON8EvXtePNOdxzNh7juJ0A-1
X-Mimecast-MFC-AGG-ID: ON8EvXtePNOdxzNh7juJ0A_1774974731
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5686C180049D;
	Tue, 31 Mar 2026 16:32:11 +0000 (UTC)
Received: from fedora (unknown [10.22.81.166])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A92019560AB;
	Tue, 31 Mar 2026 16:32:09 +0000 (UTC)
Date: Tue, 31 Mar 2026 12:32:07 -0400
From: Audra Mitchell <audra@redhat.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kselftest@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <acv3B8ah8toDYYlP@fedora>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
 <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
 <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
 <f00dce3f-d6dd-477e-bac5-b9b8253b03ba@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <f00dce3f-d6dd-477e-bac5-b9b8253b03ba@lucifer.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: SoW4UMFKY6fLf_Y3_-7cPViL0VDkrP6eIVpiz5CL3TI_1774974731
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B59A240017
X-Stat-Signature: s5opdmohy78oromx8s3ebwzywff7ooqu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774974736-243767
X-HE-Meta: U2FsdGVkX186BmZmBJzsj86QwhTzWuJ9pxuSMtY/cJmOFro8LQEEfMpBHr4Uhrx90BABkrvT7NLaRNUYzZvFdT0D2HlSTUDZuI6m5RJESxgyZ6t0glkgfQVwiWWFn4FrWweq+1S0QtXCNdrQSQL7n56rQ9Tb/bxjXdvodXhinE3oYT3UZYKnzE/JZJpK9cPv7dxIaEx21PiJf5jNxh6etVqMsmTzp4GS65rfHYwHoCzg/aiiFHX5X1Le9kgbxjFyvLPTJLNsF943juidMb8Tqoswhdcr1QbF3Z9ZUZkgFIQOWBqKzH3F14ybH+lXMIcmgFdzyBfMyBZFbBfsXWlu59RG48kZs4fCydP+vbcnm4C5RsHKH4eTn/NwAlncc99re7S+sL1dLrPvFysPoSp6fYCWKR/24EVEBtuY8gD/857hzLyCVqFbHKxMbVnAz5N5P01/HgDTkgDjCy7qR0cxgkVQgm6uWSzgP8w7QsJ9+KDXNtjLA8EV+HSykwWgqr6MNbUpiDFiqkzeGQYdCyNkNL4/ZD2Ao7/UXeYmHugmOVLGkO6oNuE+6zCgHMVcxwcAHfUuJAINIWQLbDLupplvu6Cv0CgfCJl8tdbbg5efWw0oLxGu+ZFpWZi9WV23RBpvXLXBJaEvCsUGsQNd21F6PuGWoZGTpx2AKsyf9/S8iDEnZb9PI/B9epxlxWriVfbdsuaJRZdf0rutSejfRCI2rUlnGIIXtw4MCOLtvjVXqd1zqo0SmL+RhkLbfnztAfuSan7IWVsHHKOier4AKgmT9kk96MPGPsKIcMIZYpUxnIzl6Zd7VhX8Q6SmX0UoEeHkI0uwOphJacLFjQjhXOfOy/obOl7TxTDCmyQ/gh72eRLC2YpuG+twu5RXfJlkxapKzRo02pFPiz7AInidyTyZ0m7dr0mvhPlMtqV/WQodyH7F3wjdqRXLcwI0X0dWPHIElHhcTmSmRO2AG/rqK0Q
 Yd0FNqcS
 UHM2C3MRPGXFpqY86Fgi4nGDD+VSbzxKbpKB11PY0yn4yOpbW3yLSRroQ3kuDTF+B+fx4PrHWttLqSDfP+54MCw9MTZDiyafnF4TG2Qjy69rkZtzH7EXEhNhcrd1RLxvQJ8IeZfRYSWdJIKDFLvUHZXHbhp17tuPDM0wPO8HrLnoeCFtB1ahwt+SBxtHDSKtSLWBpT1SqRGks+oyApdFfANrLkRXWs70izOpDVoC0CAzuC8Hrg6E11/0kaTbL+lMf6RIvm3NRCko7pN0Ufy6SfEG5g2bLbRu9vvqba0Gn9PMm1nP79wj5Y9V/rwxGdUziz8zr5AR1CiTh6t8vTUoNK+ZzhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:14:04AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 27, 2026 at 10:52:24AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > OK again I'm starting to think we just shouldn't support fix-patches at all any
> > more.
> >
> > This is an example  of a change being done in a fix-patch that's _really_
> > causing issues.

Yeah, this is my bad. I built my test patches, but didn't verify on David's.
I will also take full responsibility, I rarely push upstream fixes- which is
not an excuse.

> 
> Thoughts?...

I think all your suggestions are great, but I also don't believe I am the
intended recipient =)

I intend to push a V3, but it's going to a few more days as I have some other
things that got put on my plate that are a higher priority.

Thanks!


