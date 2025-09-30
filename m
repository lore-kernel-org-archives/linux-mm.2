Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3276CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 20:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E838E0006; Tue, 30 Sep 2025 16:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE018E0002; Tue, 30 Sep 2025 16:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD1D8E0006; Tue, 30 Sep 2025 16:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E53FC8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:45:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E6AA447DF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:45:18 +0000 (UTC)
X-FDA: 83947096716.26.1739378
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 361DFA0003
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:45:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d96RJ5Us;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759265116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KhdHzEXScZ1ZuHAPb/984gxCrhf58t9oc3EYjkX9MI=;
	b=VCV9zCBzY/LkGKmx3iklvz6cSaVqWMK5nFoLYjgIZyreE6BoduzKAW0Y3+YPBzFvTeTFVf
	bdXAQO09qpoLMSWeeGPCkyqCxS52wu+EJwicklJuTfBG7QYsCh5ITF5Qn6iXhAHEyseKQj
	k2vgoU0VdCopc49RYRgQW1HFQSdSZnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759265116; a=rsa-sha256;
	cv=none;
	b=ifo8qhCMsINax6gHX6QMrbPomAa42dfPzzpPSnZhfjcpT2lxRBUyVSDX5GoD8oj2TghaG9
	dbC8xSMzWgfN10F6AvSmB6qHG8LE2vURVH+HPgcVNSxTyJLQLw/ZjzN9K30ftLcaAP9C0m
	T/aYFhHk+zud5VQYSa/SLNtWciFPSIA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d96RJ5Us;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759265115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KhdHzEXScZ1ZuHAPb/984gxCrhf58t9oc3EYjkX9MI=;
	b=d96RJ5UsR11uW5DevxrJsHRkXk9Yj8e0zq92ctjJZEEJ93npVNqQp/ZvgJeCpa2yk5IcWT
	tdJnd38oPM2Tk/BaHzyT2ZQd+RtL22f5pExvh/kcvzKtLijzRy9FOz13PL64JfaHTu8PdO
	1VOlQEkz5EPh9+blU14ATM+PG74e95E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-hgbD_GcbPl6hE04ydbyWrw-1; Tue, 30 Sep 2025 16:45:13 -0400
X-MC-Unique: hgbD_GcbPl6hE04ydbyWrw-1
X-Mimecast-MFC-AGG-ID: hgbD_GcbPl6hE04ydbyWrw_1759265113
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-871614ad3efso190972285a.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759265113; x=1759869913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KhdHzEXScZ1ZuHAPb/984gxCrhf58t9oc3EYjkX9MI=;
        b=gdlMZ8brWqOUIQvxa33HAznsR3FtKQCF2N/VorMzd7mWe0p+i650476z/jsQhYIkSk
         aVtwpsl+bRXB5+muW04f3L9zXU1444rhnG6U9ImH9tl3WPoFuFgdQBxRr9RNyOfB7eOh
         pXX9bEUrnggz5eI9vitxg1pBssCMX/GTcPOK5Gwy9zG42GSU2iWCk75Jk3YfotuHw9Nj
         QeuMOpAqLeqPcb6ip26jOyvxyJN5KGGv6RjQYN341QLsVSfZOA8U6pbYUd+SRiWWvzLb
         AMtPi8Zq8G/yFwEHUIA9Uh28qz9wDKF8Kid3vGMuNALVqC7WUo3c2YJ4th9jG9gdoKR2
         S5rQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7r1LlrdYxgJZyBj2g+HrgMPwSnOKCQ8pMHhRpqrQc+i0R6J1TOIaxiWvnwvU37eYMlccNc+SG5w==@kvack.org
X-Gm-Message-State: AOJu0YxAPsyCIzbpbElWnaruB8AEsFNkeK8QHvdEwkAIvgW1cBeUOlHw
	5PBKNgShOWp0sgClbl51PtQHojBrJpAooSayFJS1AyJ23M7CfYCFaotouCTFS1tjBVNwVQFNBDo
	yMQ0PTEnPnhPxAbEpAUvSdxnUStjunuQoKhdhKZ+cBzUVwap0bMtw
X-Gm-Gg: ASbGnct8EChJbt1B47d6csshH2VHhzbGJU9qJErhK+D57r867l+iIYS5t5KnTu98OAt
	/2wref6tFL2dPvY5daCecJfPg5K0F0rUn4w3ICw+xxjBSE8HTXeru3L8oNE2jgsjtZLVaqPkR1O
	xJ+MZKmpwdLWLRslzwXBpaTOGmyqCtaDOUSB7AOPgY4kjqDJLmRwzMN6K4QeX+DGbk2g/8gyzK4
	G8vcNShXBkVpge/bgeavFEnhGfpKT3mfv6oYrr3erVEKGc27gc6ymlNP0WSETid7C8bxZnyYwxE
	O8d8+yEy/qkqtCCGj6xoHjuMcLPoliPGrOCtzA==
X-Received: by 2002:a05:620a:4723:b0:82e:6ec8:9887 with SMTP id af79cd13be357-87371172610mr182017385a.24.1759265112685;
        Tue, 30 Sep 2025 13:45:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOUW1s4NzIrA6CcfA5cgYQ1iR+uPx4PZsCRjPXoXfqPRBxU2cfAJOj4iIKUlkfgDU9xy9dNw==
X-Received: by 2002:a05:620a:4723:b0:82e:6ec8:9887 with SMTP id af79cd13be357-87371172610mr182013085a.24.1759265112108;
        Tue, 30 Sep 2025 13:45:12 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c2737848csm1124926985a.3.2025.09.30.13.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 13:45:11 -0700 (PDT)
Date: Tue, 30 Sep 2025 16:45:10 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aNxBVj6Ya0FhvkS2@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <urtzlj3wwjmmgdon3goi2qopxlxrajewdxhhchzw72exz4of7l@vlmbjw3i3xth>
MIME-Version: 1.0
In-Reply-To: <urtzlj3wwjmmgdon3goi2qopxlxrajewdxhhchzw72exz4of7l@vlmbjw3i3xth>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TASSTzfG_Wk6xuma4CeuLDlnawF0gGBhm5_Oc7QNFkc_1759265113
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: cp3i5rn7zzhrshfcn7x3uym7fqtrw6wz
X-Rspam-User: 
X-Rspamd-Queue-Id: 361DFA0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1759265116-201704
X-HE-Meta: U2FsdGVkX199C82TjxwHlLI4qKmsqtlqz+APHmcn9XnAmrSyeXgCWIiChf+Lc0Ts9WyNHZ2AaF74PVKWraV+uFtmfTnCMmoO9M7c+OwHs6fvDjC/SUr4WkemyAKkDEgBitvKUo7QZUX423GAYWmktDiVHHGJT2vA4OUywKit+fC7azkOXJhEwdMsS2vJzuDhOciNCh5epoWvCQN74p19o7DhHYfEm093sC3PiBmIIv2oTJbD9TEVBt5I8tOar1KYceDeqFsnwVyQS0biuMftEDHI3fK0wCcXJcs7EVtt4ZMiUW9VBrZNVMgvuHx1Ou9DQf8TABtHp5XiZbfJ5n6oXP/mMncVGzJPui0n/83K+3yuh5eUy+AmAf/hFfz5pi1Vz+0ox6HV57YdhaVj+HbSgBiw+i+qYzB3UAnNjg6RfMjw/IWpsz7FpGALy8uO+zguV6rJDDUDPh7g1x4NGXGqPe9qFa6/tSlESkQuGqyN6VzKXiJZiXicvVahYnQ+23RSQto1MP0xMoWKxX0oqIFL2ReT9Hxrhy3JuPsJPx6Ow4gVeNURaiJ6SsppfhXCpmuSCiBY1at9ipWFFx6QFmqHqoQvR6ABgWAF5l6t86LjhN1A/K65ArXzHvnuEhZHLOVN/ViekziG028PHHOgUC/H9frIW2O2sUJG+JhnW1c9TVkHjHI2bjO8yatiKH2EPrzwaEIUeqZgIma0rvgciqFjMzLaLEXOFueZopXY1PDe2k7KONqUN5DTEzmSFxqHDa+EJODnvdOLFMHGk+cZ6G9C3vKnlt6sUT/fXF4B/mKSqKdNDpWKmHVXE1tnj6n6038tuq32a8waIZflBb2HgJVu0jzulV13tZtbz/PNJv7MtcRhCdQrHwYC8PYy5TcOpT4gzrVn8aPEpiUWbdVBSlJJwD/QQPSnxrKYZtxpA9fbH31V1gEZ6nFD9P0WtwMgp4+mw5usLZuSX4LCLoguAX6
 58sON8ZO
 LLlgvZwqEpudm2LEry6aiM+bzUkq7czqwYmuETb9932NErtXRCwr1bzP0ZJA1tnWdVfXIJjWNq3SudWZCSWHmwJi4mYVQNJtXm3hpOK6YkcrwEhb4Vnz1rkgBNMsgKp0CB4IpYyXvZCasDl806rvx9AkhsuIE7Hwduu25yKjEc6CmP1ehL5qZvCB2Asn8RYfvvSle29UkkuNFtUrANG9mO+hIUfOWMqpZCbuIfTtXsUBhFDjkD0s+2npeD0z8IzQOg9QPM7Rg4hGYJSHd+7cnHbGwt6nE5d/TRoCHAdn2ZySQAGwJBw9tIuLLuToIYzIPFbQPOxF8koPWmd+E5hmT3VmwqjVd2JTDpt5fm/R0Hxr/2DTDNOALVmL+ZQljBO7PN/cy5JWrW7zSRqtpovkDNNOPqmIpwsq/xwz6Kte12oBAdWqSDdnJp96UEo9ofENujopU9WYcUff54JULxWuB7n2XgyvqjZDU6jWiLy0n3s6AXsBbrrAQ7BPRI5KYiss74j3Un/eMdRhbjF3GMbznvz88XaaSuJC1YiACzC9lqvxXlSA7DAyfSxgJab722VdzR31g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 03:49:34PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [250926 17:17]:
> > [based on latest akpm/mm-new of Sep 26th, commit e612c80ae0aeb]
> > 
> > v3 changelog:
> > - Fixed checkpatch issues on spaces or typedef
> > - Dropped uffd_copy() API
> > - Refined commit messages here and there to reflect the removal of uffd_copy()
> > 
> > v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
> > v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
> > 
> > This series is an alternative proposal of what Nikita proposed here on the
> > initial three patches:
> > 
> >   https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com
> > 
> > This is not yet relevant to any guest-memfd support, but paving way for it.
> 
> It would be much easier to review this with the guest-memfd support in
> this patch set.  Any chance of including the target user?

It should be something like what Nikita posted previously here against v1:

https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/

I'll add the link into the cover letter when I repost. That formal patch
logically will need to be reviewed from KVM side after this patch lands.

Thanks,

-- 
Peter Xu


