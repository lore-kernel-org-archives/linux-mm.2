Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D956C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 16:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902736B00E6; Tue, 14 Jul 2026 12:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA726B00E9; Tue, 14 Jul 2026 12:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9276B00EA; Tue, 14 Jul 2026 12:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 570E26B00E6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:09:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB8BEC041D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:09:58 +0000 (UTC)
X-FDA: 84987868476.18.9C7F22E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 148F11C000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:09:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gtWRbexS;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784045397;
	b=6uBV92DnWLQeF2DykvHx2eud9z+FJVfTM1j8sXkt5C+CBMPl04awFVfI3fLUxszpGI2vve
	NUQTY/Ip5nWRU4LUQp1rqecg+X7v55zQXfDGiLh6pdMxwBtdWEfKtSrZFgJlwgLFwIwLwF
	hyOfyURIWgUdNcYRjKdL1/JEEY7Hvd0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gtWRbexS;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784045397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdgMbrcVylxaBaGAreEv3T5etD7pXeCq9ZAv6P049TQ=;
	b=6Cj11IOrRd/KF01LpS+i5h3OaaTAywkKhSavVfrvzQmpvZV7OBduF5u2sAFntegSydvKXX
	ItyVoVbD7/SuumbO4/gxd2wi8xEu1GGPHHx7LPVpD2MK43o/T1iLW/w3lmgdTlCYt3g2Zr
	AY68sWrZ01YDoqalCmoI8vF7QSLOYjA=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ccdb73f0e1so11452995ad.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784045396; x=1784650196; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kdgMbrcVylxaBaGAreEv3T5etD7pXeCq9ZAv6P049TQ=;
        b=gtWRbexSMytn5Wv7IzMrv2tiWzL91XyGM1ZeHx+tCMMzpnaIN158MQDtqnKDvjdBPV
         gns5qphhL9rXEEP7eKI+BZWznK/00vhsgmgwDs1up7E5W322Sc1lLQoN2kEykPqYU0e0
         9ZWEakJ8bbH53w3uYkjcpgav+cANKAs9sZVjGp9Os91Mc1W743jWfwpWSTJV0OnlUucs
         WornYg0PFd/ITqYLX7TNTBprR7+js3JbbCPpEN+UKGhetYDluQJ2HB0wcp12fNV4wYCU
         635k4EXlXLgNn8EAaSG+Yl74bimkw3d9Gp7wMQhlNXkV7XhLKEHg5+ns8+45GpY7C8L9
         LK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784045396; x=1784650196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kdgMbrcVylxaBaGAreEv3T5etD7pXeCq9ZAv6P049TQ=;
        b=o/9CyQL7BcB3c7LwJwlpTS6UAdTu9nIIqFaFuNiQgcAyMI3ZHx5zU/xd4t50mfVdfa
         H6vjSGibepJPFtzz5kHS/U+P01aEZkz+seM6sSfqHinh9TcWUSZQomvRMuG5ryIElps4
         xsNbsA5evZWC3LyIv4jEtCOD9i0gaKZQoFATP+ndBLq3pekG2T36xMqZTF/3o+uJeAVB
         TBBgqrCysYozddumEGjcaFcchB6UNz/Z632hcJRQw39JgS/8jtBTMUJs1b0o/RBwcYB6
         VfBHspYooHeLsZ3GcZsBNJlfqiIbsKOYofvt6g3jFghkodK3BHaD0B5Mx0sG2oiNYtND
         qbAg==
X-Forwarded-Encrypted: i=1; AHgh+RqHmcnpzLun3BiI2uE1jv6PJg1Z/wSUsuzYy8uxh7b+bG3M7myP/+DSFLBbbxkIECu7FR6HjayOIg==@kvack.org
X-Gm-Message-State: AOJu0YwgjM/NdSepnLV4sMhLb9BLipFlbDuggZsUImaxq4FNUwrOmb7Z
	2IsMCWnd2L9Xzy6nEMk5qf+oMO02fBOpT+qyxTVrZ5iwdatVMbYYMYZk
X-Gm-Gg: AfdE7ckiFDs8KX6AbySZXdJafjRn0p+0vQH4HN5rTAmh6lswS860Bz05t1FfuYSfILY
	6+RahDjfdIhY5DkBH8h6CJwsluO9LtCk/mVTebhJ3pjUClY2/VKlR4c1uZY3dGf68L4E40HG0gK
	wJYMmO+s2zfQfKq04jT7PksfgUPgm91mQxRNAMH1rbXtQsi+VrwYMx5ZNuodKJyBHxMkA0OXxeg
	Q/tzkCtPBJ5Ubq3+m3KcRsLByU/fUe7YB6gWO79YSFZDj9C6jSDt3SO6CcDvWF4ePf3Fcxvb785
	CPt3JqEGi8F9ejF/wH1QzvJhGzLJmtIzZzoCZ6qs05qttST2/Atp9peYVWaPIzNyzDTfHTgxYNe
	4yxmwILY06NXgat4Fc/lSEPRCL1wm0rBkmeZYM+hbgKkJcfubbcmUZk4NtVhKPDv4OvevVXdR/A
	BOTF9KUcS25N7N3xdD1QGTUfhYo+UXmYzGEGjAydzMrCCwPo3nJW7hDSw=
X-Received: by 2002:a05:6a20:d70a:b0:3c0:b55a:80ff with SMTP id adf61e73a8af0-3c11063d595mr15198722637.24.1784045395651;
        Tue, 14 Jul 2026 09:09:55 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b31628c1sm10020860a12.19.2026.07.14.09.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 09:09:54 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:09:51 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <alZfTxfypj39OrCE@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
 <alG2-RSitzPWClAX@skinsburskii>
 <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
 <alVRU38lMfvmUFqJ@skinsburskii>
 <20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 148F11C000C
X-Stat-Signature: tzbwrxnpt47scm8jjybtobpg68jp5pbe
X-HE-Tag: 1784045396-590890
X-HE-Meta: U2FsdGVkX18k5nugArVYgGympDNVWy7qgY5ECtwRKBpS4tjkZNrVUTibZvJs9BHvJFWL4Xoeb3DtmRAQsLBNMNIuWnUcgMm1g7yXCiOrwvLvOzfv6KSvDvybL4SquGW2IIjyTJ9yGndI8KkIzKMMILiGIJS5/NODslF1NI2LCzLb4U8WjWlgBPILbPGPMHsEfGzUYMkNqYLUO6Nt9mEdp3apwXhtlFqRSRx5eum7hL5n3md0Kkc9yCmlSxVGf5V5OSdWremIlxwK7lbXPSnA8CQzyapvvEBPdaHH4NT/YstVKkZ3bZ+x4U4nLXd0OWWeYFp0/OzJ9BylMZeI0Q1QVQnjseslFkDrW0/8ZaMJyUQuF0VDaB6DUwU0o2UuhxHYtkjCUaXbGYdij65K6BdxVwSxJ/PJ2+S91R3mP/ul7z+J3wTnNlJJj2mW5rCMw48yA7mnBo8XldujQdKu2ojYg842DyRRNQeYW32KFBrvTUgPhYaZRwhwiWfHPqHNeRjDWf6xubDz36O46iE1L4aTxe7LQJq5Y9MQLE4KjYVTdcbrXI8pVOwiIFdTnZyVR9X7H5k4bPhw5pEhLpPMobvfjAqtwAJ8CnI1RYSHjpfQxBXYYc50pqqGafL7zkrXoRXrkYu2xhdwx2ouldG0OBQrQtoBuynXVf96/vV/LAuQw//QAc5wG8HRRt9qXHPERDa0xkT4BE5Aqxe86r513Q3bmh27dCY3tFAotX8jhNs7hH7NfeGTC5UeW8PhVhnK1uDGZn9sGX92efbEKDUs2UW51PM7sTavIRtSC2vGHt7Yq1SkTsKOTlb5IxbBbrFPzgSY5Mb78SuqOXtkznz938K5EhiChjXgMQujX18C6AzORZPQJU9umfIQRI7Dp6u0wrV0L1nTozW4qCJfz9c77I9zm2zhHSLFJIdOCjR/R1AbkwwVy8fsxKkWQstp4hiPlgNEwR5HB0mRfNdk/Dd2RP3
 ZQbxLFad
 IoWRZeQ38ft9y91K5whhsdCkaV8qsaNB+/T5C/6I+qXH7vtHKeNh6BEgLLbnhVNb7v5lO8wa3YBhp/JuwuaH7dpIluEgDcbiB9W0go/ZyOSVXNRzRgxHYAjyGiF0/8DQHpHbxzoSp2x2TBeijLj5/Lu5hLq63R4UOYsLxdY7XTEeNpWyGl3LpWH8Rhkv5RIP49VXkrH/mcMIrFz8yakSWn71Pburz5VzC84OH2Q30rHiPCiRm97+kiK9GUSguu9RmplNdKX+ZeSC4cxOSH/atfgYi621HgdHERbT80JhPaHXTYh/6dGzVN1J2Iu5rb33QllxEnCjL2SL38J7uJG4zpvRDwU1xpFR9beKzpVSKHMGoJMFG+NWFWFnafECgnEZ1ORXC3CeVjbqK68uMinuv9N622Wq6i5oMIw7pIEzRbZcvBjgCWv0oY/VpMLGshIYPy1CpB0bHWx2tn/9Ut1iDM4DEHsRAh/mmxCp5pm2j1w2P40MCbVjjl14aH0M5QpSisD8dnMndjjwE7jUyUm+YdMMS7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 03:45:35PM -0700, Andrew Morton wrote:
> On Mon, 13 Jul 2026 13:57:55 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > > > I rebased this series on top of mm-new right before sending it out.
> > > > Should I have used a different branch?
> > > 
> > > mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> > > this point in the development cycle.
> > > 
> > 
> > I’d like to send another revision addressing a few comments and also
> > replace the `max/max_t` check with something simpler.
> > 
> > Which branch should I base it on so that Sashiko can apply it
> > successfully?
> 
> mainline Linus would be safest.
> 

Looks like linux-next/master has been updated with the v8 of the series.

I have v9 with a few small fixes, but it is too late to send it out already?

If it's not, then what should I base it on?

Thanks,
Stanislav

> > Or would it be better to send fixups against `mm-new`?
> 
> That should work as well, but it doesn't give us a Sashiko scan of the
> whole patchset.

